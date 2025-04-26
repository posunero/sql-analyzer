-- Example 12040
EXECUTE JOB SERVICE
   IN COMPUTE POOL tutorial_compute_pool
   NAME = example_job_service
   ASYNC = TRUE
   FROM SPECIFICATION $$
   ...
   $$;

-- Example 12041
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = example_job_service
  FROM @tutorial_stage
  SPECIFICATION_FILE='my_job_spec.yaml';

-- Example 12042
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
  spec:
    containers:
    - name: echo
      image: myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:{{ tag_name }}
        ...
    endpoints:
    - name: ...
      ...
  $$
  USING (tag_name=>'latest');

-- Example 12043
CREATE SERVICE echo_service
    IN COMPUTE POOL tutorial_compute_pool
    FROM @STAGE SPECIFICATION_TEMPLATE_FILE='echo.yaml'
    USING (tag_name=>'latest');

-- Example 12044
spec:
  containers:
  - name: echo
    image: <image_name>
    env:
      CHARACTER_NAME: {{ character_name | default('Bob') }}
      SERVER_PORT: 8085
  endpoints:
  - name: {{ endpoint_name | default('echo-endpoint') }}
    port: 8085

-- Example 12045
spec:
  containers:
  - name: echo
    image: <image_name>
    env:
      CHARACTER_NAME: {{ character_name | default('Bob', false) }}
      SERVER_PORT: 8085
  endpoints:
  - name: {{ endpoint_name | default('echo-endpoint', true) }}
    port: 8085

-- Example 12046
USING( var_name=>var_value, [var_name=>var_value, ... ] );

-- Example 12047
-- Alphanumeric string and literal values
USING(some_alphanumeric_var=>'blah123',
      some_int_var=>111,
      some_bool_var=>true,
      some_float_var=>-1.2)

-- JSON string
USING(some_json_var=>' "/path/file.txt" ')

-- JSON map
USING(env_values=>'{"SERVER_PORT": 8000, "CHARACTER_NAME": "Bob"}' );

-- JSON list
USING (ARGS='["-n", 2]' );

-- Example 12048
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   MIN_INSTANCES=1
   MAX_INSTANCES=1
   FROM SPECIFICATION_TEMPLATE $$
      spec:
         containers:
         - name: echo
           image: {{ image_url }}
           env:
             SERVER_PORT: {{SERVER_PORT}}
             CHARACTER_NAME: Bob
           readinessProbe:
             port: {{SERVER_PORT}}
             path: /healthcheck
         endpoints:
         - name: echoendpoint
           port: {{SERVER_PORT}}
           public: true
         $$
      USING (image_url=>' "/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest" ', SERVER_PORT=>8000 );

-- Example 12049
spec:
  containers:
  - name: echo
    image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
    env:
      SERVER_PORT: 8000
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8000
      path: /healthcheck
    endpoints:
    - name: echoendpoint
      port: 8000
      public: true

-- Example 12050
spec:
 containers:
 - name: echo
   image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
   env:
     SERVER_PORT: 8000
     CHARACTER_NAME: Bob
   …

-- Example 12051
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  MIN_INSTANCES=1
  MAX_INSTANCES=1
  FROM SPECIFICATION_TEMPLATE $$
     spec:
       containers:
       - name: echo
         image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
         env: {{env_values}}
         readinessProbe:
           port: {{SERVER_PORT}}    #this and next tell SF to connect to port 8000
           path: /healthcheck
       endpoints:
       - name: echoendpoint
         port: {{SERVER_PORT}}
         public: true
        $$
     USING (env_values=>'{"SERVER_PORT": 8000, "CHARACTER_NAME": "Bob"}' );

-- Example 12052
spec:
  container:
  - name: main
    image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
    env:
      SNOWFLAKE_WAREHOUSE: tutorial_warehouse
    args:
    - "--query=select current_time() as time,'hello'"
    - "--result_table=results"

-- Example 12053
spec:
  container:
  - name: main
    image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
    env:
      SNOWFLAKE_WAREHOUSE: tutorial_warehouse
    args: {{ARGS}}
  $$
  USING (ARGS=$$["--query=select current_time() as time,'hello'", "--result_table=results"]$$ );

-- Example 12054
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   FROM @tutorial_stage
   SPECIFICATION_FILE='echo_spec.yaml'
   MIN_INSTANCES=2
   MAX_INSTANCES=4;

-- Example 12055
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   FROM @tutorial_stage
   SPECIFICATION_FILE='echo_spec.yaml'
   MIN_INSTANCES=2
   MAX_INSTANCES=4
   MIN_READY_INSTANCES=1;

-- Example 12056
resources:
  requests:
   cpu: <cpu-units>

-- Example 12057
ALTER SERVICE echo_service
FROM SPECIFICATION $$
spec:
  …
  …
$$;

-- Example 12058
spec:
containers:
- name: "echo"
    image: "/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest"
    sha256: "@sha256:8d912284f935ecf6c4753f42016777e09e3893eed61218b2960f782ef2b367af"
    env:
      SERVER_PORT: "8000"
      CHARACTER_NAME: "Bob"
    readinessProbe:
      port: 8000
      path: "/healthcheck"
endpoints:
- name: "echoendpoint"
    port: 8000
    public: true

-- Example 12059
GRANT USAGE ON DATABASE my_db TO ROLE some_role;
GRANT USAGE ON SCHEMA my_schema TO ROLE some_role;

-- Example 12060
GRANT SERVICE ROLE my_service!all_endpoints_usage TO ROLE some_role;

-- Example 12061
USE DATABASE my_db;
USE SCHEMA my_schema;


CREATE SERVICE my_service
IN COMPUTE POOL tutorial_pool
FROM SPECIFICATION $$
spec:
  containers:
  - name: echo
    image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
  endpoints:
  - name: ep1
    port: 8000
    public: true
  - name: ep2
    port: 8082
    public: true
serviceRoles:
- name: ep1_role
  endpoints:
  - ep1
$$

-- Example 12062
GRANT SERVICE ROLE my_service!ep1_role TO ROLE some_role;

-- Example 12063
spec:
…
  endpoints:
  - name: echoendpoint
    port: 8080

-- Example 12064
CREATE FUNCTION my_echo_udf (text varchar)
   RETURNS varchar
   SERVICE=echo_service
   ENDPOINT=echoendpoint
   AS '/echo';

-- Example 12065
@app.post("/echo")
def echo():
...

-- Example 12066
SELECT service_function_name(<parameter-list>);

-- Example 12067
"Alex", "2014-01-01 16:00:00"
"Steve", "2015-01-01 16:00:00"
…

-- Example 12068
SELECT service_func(col1, col2) FROM input_table;

-- Example 12069
{
   "data":[
      [
         0,
         "Alex",
         "2014-01-01 16:00:00"
      ],
      [
         1,
         "Steve",
         "2015-01-01 16:00:00"
      ],
      …
      [
         <row_index>,
         "<column1>",
         "<column2>"
      ],
   ]
}

-- Example 12070
{
   "data":[
      [0, "a"],
      [1, "b"],
      …
      [ row_index,  output_column1]
   ]
}

-- Example 12071
ALTER FUNCTION my_echo_udf(VARCHAR)
   SET MAX_BATCH_ROWS = 10

-- Example 12072
USE ROLE service_owner;
GRANT USAGE ON DATABASE service_db TO ROLE func_owner;
GRANT USAGE ON SCHEMA my_schema TO ROLE func_owner;
GRANT SERVICE ROLE ON service service_db.my_schema.my_service!all_endpoints_usage TO ROLE func_owner;
USE ROLE func_owner;
CREATE OR REPLACE test_udf(v VARCHAR)
  RETURNS VARCHAR
  SERVICE=service_db.my_schema.my_service
  ENDPOINT=endpointname1
  AS '/run';

SELECT test_udf(col1) FROM some_table;

ALTER FUNCTION test_udf(VARCHAR) SET
  SERVICE = service_db.other_schema.other_service
  ENDPOINT=anotherendpoint;

GRANT USAGE ON DATABASE service_db TO ROLE func_user;
GRANT USAGE ON SCHEMA my_schema TO ROLE func_user;
GRANT USAGE ON FUNCTION test_udf(varchar) TO ROLE func_user;
USE ROLE func_user;
SELECT my_test_udf('abcd');

-- Example 12073
spec
  ...
  endpoints
  - name: <endpoint name>
    port: <port number>
    public: true

-- Example 12074
import snowflake.connector
import requests

ctx = snowflake.connector.connect(
   user="<username>",# username
   password="<password>", # insert password here
   account="<orgname>-<acct-name>",
   session_parameters={
      'PYTHON_CONNECTOR_QUERY_RESULT_FORMAT': 'json'
   })

# Obtain a session token.
token_data = ctx._rest._token_request('ISSUE')
token_extract = token_data['data']['sessionToken']

# Create a request to the ingress endpoint with authz.
token = f'\"{token_extract}\"'
headers = {'Authorization': f'Snowflake Token={token}'}
# Set this to the ingress endpoint URL for your service
url = 'http://<ingress_url>'

# Validate the connection.
response = requests.get(f'{url}', headers=headers)
print(response.text)

# Insert your code to interact with the application here

-- Example 12075
Sf-Context-Current-User: <user_name>

-- Example 12076
<service-name>.<hash>.svc.spcs.internal

-- Example 12077
instances.<service-name>.<hash>.svc.spcs.internal

-- Example 12078
eth0Ip=$(ifconfig eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')

-- Example 12079
import os
import socket

service_name = os.environ['SNOWFLAKE_SERVICE_NAME']
service_dns_name = service_name.lower().replace("_","-")

service_ip = socket.gethostbyname(service_dns_name)
instance_ip = socket.gethostbyname(socket.gethostname())
fqdn, _, instance_ips = socket.gethostbyname_ex(
    "instances." + service_dns_name)
print(f"""
  service name: {service_name}
  service dns name: {service_dns_name}
  service fqdn: {fqdn}
  service ip: {service_ip}
  instance ip: {instance_ip}
  instances ips: {instance_ips}
""")

-- Example 12080
USE SECONDARY ROLES {
      ALL
    | NONE
    | <role_name> [ , <role_name> ... ]
  }

-- Example 12081
USE SECONDARY ROLES ALL;

-- Example 12082
USE SECONDARY ROLES test_role_1, test_role_2;

-- Example 12083
CREATE [ OR REPLACE ] DATABASE ROLE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 12084
CREATE OR ALTER DATABASE ROLE <name>
  [ COMMENT = '<string_literal>' ]

-- Example 12085
CREATE DATABASE ROLE d1.dr1;

-- Example 12086
CREATE DATABASE ROLE d1.r1;

CREATE DATABASE ROLE d1.r2;

-- Example 12087
USE DATABASE d1;

CREATE DATABASE ROLE r1;

CREATE DATABASE ROLE r2;

-- Example 12088
GRANT USAGE ON SCHEMA d1.s1 TO DATABASE ROLE d1.r1;
GRANT SELECT ON VIEW d1.s1.v1 TO DATABASE ROLE d1.r1;

-- Example 12089
GRANT USAGE ON SCHEMA d1.s1 TO DATABASE ROLE d1.r2;
GRANT SELECT ON VIEW d1.s1.v2 TO DATABASE ROLE d1.r2;

-- Example 12090
SHOW GRANTS TO DATABASE ROLE d1.r1;
SHOW GRANTS TO DATABASE ROLE d1.r2;

-- Example 12091
USE DATABASE d1;

SHOW GRANTS TO DATABASE ROLE r1;
SHOW GRANTS TO DATABASE ROLE r2;

-- Example 12092
CREATE SHARE share1;

-- Example 12093
GRANT USAGE ON DATABASE d1 TO SHARE share1;

-- Example 12094
GRANT DATABASE ROLE d1.r1 TO SHARE share1;
GRANT DATABASE ROLE d1.r2 TO SHARE share1;

-- Example 12095
ALTER SHARE share1 ADD ACCOUNTS = org1.consumer1,org1.consumer2;

-- Example 12096
ALTER DATABASE ROLE d1.r1 RENAME TO d1.r3;

-- Example 12097
ALTER DATABASE ROLE d1.r1 RENAME TO d2.r1;

-- Example 12098
DROP DATABASE ROLE d1.r2;

-- Example 12099
USE ROLE accountadmin;

CREATE SHARE sales_s;

GRANT USAGE ON DATABASE sales_db TO SHARE sales_s;
GRANT USAGE ON SCHEMA sales_db.aggregates_eula TO SHARE sales_s;
GRANT SELECT ON TABLE sales_db.aggregates_eula.aggregate_1 TO SHARE sales_s;

SHOW GRANTS TO SHARE sales_s;

ALTER SHARE sales_s ADD ACCOUNTS=xy12345, yz23456;

SHOW GRANTS OF SHARE sales_s;

-- Example 12100
ALTER ACCOUNT SET { [ accountParams ] | [ objectParams ] | [ sessionParams ] }

ALTER ACCOUNT UNSET <param_name> [ , ... ]

ALTER ACCOUNT SET RESOURCE_MONITOR = <monitor_name>

ALTER ACCOUNT SET { AUTHENTICATION | PASSWORD | SESSION } POLICY <policy_name>

ALTER ACCOUNT UNSET { AUTHENTICATION | PASSWORD | SESSION } POLICY

ALTER ACCOUNT SET PACKAGES POLICY <policy_name> [ FORCE ]

ALTER ACCOUNT UNSET { PACKAGES | PASSWORD | SESSION } POLICY

ALTER ACCOUNT SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER ACCOUNT UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12101
accountParams ::=
    ALLOW_ID_TOKEN = TRUE | FALSE
    CLIENT_ENCRYPTION_KEY_SIZE = <integer>
    CORTEX_ENABLED_CROSS_REGION = { 'DISABLED' | 'ANY_REGION' | '<list_of_regions>' }
    ENABLE_EGRESS_COST_OPTIMIZER = TRUE | FALSE
    ENABLE_INTERNAL_STAGES_PRIVATELINK = TRUE | FALSE
    ENFORCE_NETWORK_RULES_FOR_INTERNAL_STAGES = TRUE | FALSE
    EXTERNAL_OAUTH_ADD_PRIVILEGED_ROLES_TO_BLOCKED_LIST = TRUE | FALSE
    INITIAL_REPLICATION_SIZE_LIMIT_IN_TB = <num>
    LISTING_AUTO_FULFILLMENT_REPLICATION_REFRESH_SCHEDULE = <schedule>
    LLM_INFERENCE_PARSE_DOCUMENT_PRESIGNED_URL_EXPIRY_SECONDS = <integer>
    NETWORK_POLICY = <string>
    OAUTH_ADD_PRIVILEGED_ROLES_TO_BLOCKED_LIST = TRUE | FALSE
    PERIODIC_DATA_REKEYING = TRUE | FALSE
    REQUIRE_STORAGE_INTEGRATION_FOR_STAGE_CREATION = TRUE | FALSE
    REQUIRE_STORAGE_INTEGRATION_FOR_STAGE_OPERATION = TRUE | FALSE
    SAML_IDENTITY_PROVIDER = <json_object>
    SSO_LOGIN_PAGE = TRUE | FALSE

-- Example 12102
objectParams ::=
    DATA_RETENTION_TIME_IN_DAYS = <integer>
    DEFAULT_STREAMLIT_NOTEBOOK_WAREHOUSE = <warehouse_name>
    ENABLE_PERSONAL_DATABASE = { TRUE | FALSE }
    ENABLE_UNREDACTED_QUERY_SYNTAX_ERROR = TRUE | FALSE
    ENABLE_UNREDACTED_SECURE_OBJECT_ERROR = TRUE | FALSE
    MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer>
    EXTERNAL_VOLUME = <external_volume_name>
    CATALOG = <catalog_integration_name>
    DEFAULT_DDL_COLLATION = '<collation_specification>'
    DEFAULT_NOTEBOOK_COMPUTE_POOL_CPU = <compute_pool_name>
    DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU = <compute_pool_name>
    MAX_CONCURRENCY_LEVEL = <num>
    NETWORK_POLICY = <string>
    PIPE_EXECUTION_PAUSED = TRUE | FALSE
    PREVENT_UNLOAD_TO_INLINE_URL = TRUE | FALSE
    PREVENT_UNLOAD_TO_INTERNAL_STAGES = TRUE | FALSE
    REPLACE_INVALID_CHARACTERS = TRUE | FALSE
    STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <num>
    STATEMENT_TIMEOUT_IN_SECONDS = <num>
    STORAGE_SERIALIZATION_POLICY = COMPATIBLE | OPTIMIZED
    CATALOG_SYNC = '<snowflake_open_catalog_integration_name>'
    BASE_LOCATION_PREFIX = '<string>'

-- Example 12103
sessionParams ::=
    ABORT_DETACHED_QUERY = TRUE | FALSE
    AUTOCOMMIT = TRUE | FALSE
    BINARY_INPUT_FORMAT = <string>
    BINARY_OUTPUT_FORMAT = <string>
    DATE_INPUT_FORMAT = <string>
    DATE_OUTPUT_FORMAT = <string>
    DEFAULT_NULL_ORDERING = <string>
    ERROR_ON_NONDETERMINISTIC_MERGE = TRUE | FALSE
    ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE | FALSE
    JSON_INDENT = <num>
    LOCK_TIMEOUT = <num>
    QUERY_TAG = <string>
    ROWS_PER_RESULTSET = <num>
    S3_STAGE_VPCE_DNS_NAME = <string>
    SEARCH_PATH = <string>
    SIMULATED_DATA_SHARING_CONSUMER = <string>
    STATEMENT_TIMEOUT_IN_SECONDS = <num>
    STRICT_JSON_OUTPUT = TRUE | FALSE
    TIMESTAMP_DAY_IS_ALWAYS_24H = TRUE | FALSE
    TIMESTAMP_INPUT_FORMAT = <string>
    TIMESTAMP_LTZ_OUTPUT_FORMAT = <string>
    TIMESTAMP_NTZ_OUTPUT_FORMAT = <string>
    TIMESTAMP_OUTPUT_FORMAT = <string>
    TIMESTAMP_TYPE_MAPPING = <string>
    TIMESTAMP_TZ_OUTPUT_FORMAT = <string>
    TIMEZONE = <string>
    TIME_INPUT_FORMAT = <string>
    TIME_OUTPUT_FORMAT = <string>
    TRANSACTION_DEFAULT_ISOLATION_LEVEL = <string>
    TWO_DIGIT_CENTURY_START = <num>
    UNSUPPORTED_DDL_ACTION = <string>
    USE_CACHED_RESULT = TRUE | FALSE
    WEEK_OF_YEAR_POLICY = <num>
    WEEK_START = <num>

-- Example 12104
ALTER ACCOUNT <name> SET IS_ORG_ADMIN = { TRUE | FALSE }

ALTER ACCOUNT <name> RENAME TO <new_name> [ SAVE_OLD_URL = { TRUE | FALSE } ]

ALTER ACCOUNT <name> DROP OLD URL

ALTER ACCOUNT <name> DROP OLD ORGANIZATION URL

-- Example 12105
ALTER ACCOUNT SET NETWORK_POLICY = mypolicy;

-- Example 12106
ALTER ACCOUNT UNSET NETWORK_POLICY;

