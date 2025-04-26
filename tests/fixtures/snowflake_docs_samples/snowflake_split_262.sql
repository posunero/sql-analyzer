-- Example 17532
DROP SNAPSHOT [ IF EXISTS ] <name>;

-- Example 17533
DROP SNAPSHOT example_snapshot;

-- Example 17534
+----------------------------------------+
| status                                 |
|----------------------------------------|
| EXAMPLE_SNAPSHOT successfully dropped. |
+----------------------------------------+

-- Example 17535
SHOW IMAGE REPOSITORIES [ LIKE '<pattern>' ]
           [ IN
                {
                  ACCOUNT                  |

                  DATABASE                 |
                  DATABASE <database_name> |

                  SCHEMA                   |
                  SCHEMA <schema_name>     |
                  <schema_name>
                }
           ]

-- Example 17536
SHOW IMAGE REPOSITORIES;

-- Example 17537
SHOW IMAGE REPOSITORIES IN SCHEMA;

-- Example 17538
SHOW IMAGE REPOSITORIES IN SCHEMA sc1;

-- Example 17539
SHOW IMAGE REPOSITORIES IN DATABASE;

-- Example 17540
SHOW IMAGE REPOSITORIES IN DATABASE db1;

-- Example 17541
SHOW IMAGE REPOSITORIES IN ACCOUNT;

-- Example 17542
+-------------------------------+---------------------+---------------+-------------+-----------------------------------------------------------------------------------------------------------------+-----------+-----------------+---------+
| created_on                    | name                | database_name | schema_name | repository_url                                                                                                  | owner     | owner_role_type | comment |
|-------------------------------+---------------------+---------------+-------------+-----------------------------------------------------------------------------------------------------------------+-----------+-----------------+---------|
| 2023-05-09 14:27:19.459 -0700 | TUTORIAL_REPOSITORY | TUTORIAL_DB   | DATA_SCHEMA | orgname-acctname.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository | TEST_ROLE | ROLE            |         |
+-------------------------------+---------------------+---------------+-------------+-----------------------------------------------------------------------------------------------------------------+-----------+-----------------+---------+

-- Example 17543
USE ROLE ACCOUNTADMIN;

CREATE ROLE test_role;

CREATE DATABASE IF NOT EXISTS tutorial_db;
GRANT OWNERSHIP ON DATABASE tutorial_db TO ROLE test_role COPY CURRENT GRANTS;

CREATE OR REPLACE WAREHOUSE tutorial_warehouse WITH
  WAREHOUSE_SIZE='X-SMALL';
GRANT USAGE ON WAREHOUSE tutorial_warehouse TO ROLE test_role;

GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE test_role;

CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;
GRANT USAGE, MONITOR ON COMPUTE POOL tutorial_compute_pool TO ROLE test_role;

GRANT ROLE test_role TO USER <user_name>

-- Example 17544
USE ROLE test_role;
USE DATABASE tutorial_db;
USE WAREHOUSE tutorial_warehouse;

CREATE SCHEMA IF NOT EXISTS data_schema;
CREATE IMAGE REPOSITORY IF NOT EXISTS tutorial_repository;
CREATE STAGE IF NOT EXISTS tutorial_stage
  DIRECTORY = ( ENABLE = true );

-- Example 17545
SHOW COMPUTE POOLS; --or DESCRIBE COMPUTE POOL tutorial_compute_pool;

-- Example 17546
SHOW WAREHOUSES;

-- Example 17547
SHOW IMAGE REPOSITORIES;

-- Example 17548
SHOW STAGES;

-- Example 17549
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 17550
SNOWFLAKE_ACCOUNT = os.getenv('SNOWFLAKE_ACCOUNT')
SNOWFLAKE_HOST = os.getenv('SNOWFLAKE_HOST')

-- Example 17551
def get_login_token():
  with open('/snowflake/session/token', 'r') as f:
    return f.read()

conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth'
)

-- Example 17552
conn = snowflake.connector.connect(
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  user = '<user-name>',
  password = <password>
)

-- Example 17553
CREATE OR REPLACE NETWORK RULE snowflake_egress_access
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('myaccount.snowflakecomputing.com');

-- Example 17554
CREATE EXTERNAL ACCESS INTEGRATION snowflake_egress_access_integration
  ALLOWED_NETWORK_RULES = (snowflake_egress_access)
  ENABLED = true;

-- Example 17555
-- Create a service.
CREATE SERVICE test_service IN COMPUTE POOL ...

-- Execute a job service.
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = example_job_service ...

-- Example 17556
-- Create a service.
CREATE SERVICE test_db.test_schema.test_service IN COMPUTE POOL ...

-- Execute a job service.
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = test_db.test_schema.example_job_service ...

-- Example 17557
conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth',
  database = os.getenv('SNOWFLAKE_DATABASE'),
  schema = os.getenv('SNOWFLAKE_SCHEMA')
)

-- Example 17558
USE DATABASE tutorial_db;
...
USE SCHEMA data_schema;

-- Example 17559
SNOWFLAKE_DATABASE = os.getenv('SNOWFLAKE_DATABASE')
SNOWFLAKE_SCHEMA = os.getenv('SNOWFLAKE_SCHEMA')

-- Example 17560
{
   "account": SNOWFLAKE_ACCOUNT,
   "host": SNOWFLAKE_HOST,
   "authenticator": "oauth",
   "token": get_login_token(),
   "warehouse": SNOWFLAKE_WAREHOUSE,
   "database": SNOWFLAKE_DATABASE,
   "schema": SNOWFLAKE_SCHEMA
}
...

-- Example 17561
def get_login_token():
  with open('/snowflake/session/token', 'r') as f:
    return f.read()

conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth'
)

-- Example 17562
spec:
  containers:
  ...
capabilities:
  securityContext:
    executeAsCaller: true

-- Example 17563
# Environment variables below will be automatically populated by Snowflake.
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_HOST = os.getenv("SNOWFLAKE_HOST")

def get_login_token():
    with open("/snowflake/session/token", "r") as f:
        return f.read()

def get_connection_params(ingress_user_token = None):
    # start a Snowflake session as ingress user
    # (if user token header provided)
    if ingress_user_token:
        logger.info("Creating a session on behalf of the current user.")
        token = get_login_token() + "." + ingress_user_token
    else:
        logger.info("Creating a session as the service user.")
        token = get_login_token()

    return {
        "account": SNOWFLAKE_ACCOUNT,
        "host": SNOWFLAKE_HOST,
        "authenticator": "oauth",
        "token": token
    }

def run_query(request, query):
    ingress_user_token = request.headers.get('Sf-Context-Current-User-Token')
    # ingress_user_token is None if header not present
    connection_params = get_connection_params(ingress_user_token)
    with Session.builder.configs(connection_params).create() as session:
      # use the session to execute a query.

-- Example 17564
ALTER USER my_user SET DEFAULT_SECONDARY_ROLES = ( 'ALL' );

-- Example 17565
-- Permissions to resolve the table's name.
GRANT CALLER USAGE ON DATABASE <db_name> TO ROLE <service_owner_role>;
GRANT CALLER USAGE ON SCHEMA <schema_name> TO ROLE <service_owner_role>;
-- Permissions to use a warehouse
GRANT CALLER USAGE ON WAREHOUSE <warehouse_name> TO ROLE <service_owner_role>;
-- Permissions to query the table.
GRANT CALLER SELECT ON TABLE T1 TO ROLE <service_owner_role>;

-- Example 17566
endpoints:
- name: <endpoint name>
  port: <port number>
  protocol : < TCP / HTTP >
  public: true
  corsSettings:                  # optional CORS configuration
    Access-Control-Allow-Origin: # required list of allowed origins
      - <origin>                 # for example, "http://example.com"
      - <origin>
        ...
    Access-Control-Allow-Methods: # optional list of HTTP methods
      - <method>
      - <method>
        ...
    Access-Control-Allow-Headers: # optional list of HTTP headers
      - <header-name>
      - <header-name>
        ...
    Access-Control-Expose-Headers: # optional list of HTTP headers
      - <header-name>
      - <header-name>
        ...

-- Example 17567
default-src 'self' 'unsafe-inline' 'unsafe-eval' blob: data:; object-src 'none'; connect-src 'self'; frame-ancestors 'self';

-- Example 17568
script-src 'self'

-- Example 17569
default-src 'self' 'unsafe-inline' 'unsafe-eval' http://example.com https://example.com blob: data:; object-src 'none'; connect-src 'self' http://example.com https://example.com wss://example.com; frame-ancestors 'self';

-- Example 17570
SHOW PARAMETERS LIKE 'SAML_IDENTITY_PROVIDER' IN ACCOUNT;

-- Example 17571
SHOW INTEGRATIONS;
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) WHERE "type" = 'SAML2';

-- Example 17572
CREATE OR REPLACE NETWORK RULE translate_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 17573
CREATE OR REPLACE NETWORK RULE google_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('google.com:80', 'google.com:443');

-- Example 17574
CREATE NETWORK RULE allow_all_rule
  TYPE = 'HOST_PORT'
  MODE= 'EGRESS'
  VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

-- Example 17575
CREATE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (translate_network_rule, google_network_rule)
  ENABLED = true;

-- Example 17576
GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE test_role;

-- Example 17577
USE ROLE test_role;

CREATE SERVICE eai_service
  IN COMPUTE POOL MYPOOL
  EXTERNAL_ACCESS_INTEGRATIONS = (GOOGLE_APIS_ACCESS_INTEGRATION)
  FROM SPECIFICATION
  $$
  spec:
    containers:
      - name: main
        image: /db/data_schema/tutorial_repository/my_echo_service_image:tutorial
        env:
          TEST_FILE_STAGE: source_stage/test_file
        args:
          - read_secret.py
    endpoints:
      - name: read
        port: 8080
  $$;

-- Example 17578
EXECUTE JOB SERVICE
  IN COMPUTE POOL tt_cp
  NAME = example_job_service
  EXTERNAL_ACCESS_INTEGRATIONS = (GOOGLE_APIS_ACCESS_INTEGRATION)
  FROM SPECIFICATION $$
  spec:
    container:
    - name: curl
      image: /tutorial_db/data_schema/tutorial_repo/alpine-curl:latest
      command:
      - "curl"
      - "http://google.com/"
  $$;

-- Example 17579
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 17580
CREATE OR REPLACE NETWORK RULE private_link_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('<bucket-name>.s3.us-west-2.amazonaws.com');

-- Example 17581
...
secrets:
- snowflakeSecret:
    objectName: '<secret-name>'
  <other info about where in the container to copy the secret>
  ...

-- Example 17582
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret:
      objectReference: '<reference-name>'
    <other info about where in the container to copy the secret>

-- Example 17583
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: <secret-name>
    secretKeyRef: username | password | secret_string |  'access_token'
    envVarName: '<env-variable-name>'

-- Example 17584
CREATE SECRET testdb.testschema.my_secret_object
  TYPE = password
  USERNAME = 'snowman'
  PASSWORD = '1234abc';

-- Example 17585
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret_object
    secretKeyRef: username
    envVarName: LOGIN_USER
  - snowflakeSecret: testdb.testschema.my_secret_object
    secretKeyRef: password
    envVarName: LOGIN_PASSWORD

-- Example 17586
CREATE SECRET testdb.testschema.my_secret
  TYPE=generic_string
  SECRET_STRING='
       some_magic: config
  ';

-- Example 17587
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret
    secretKeyRef: secret_string
    envVarName: GENERIC_SECRET

-- Example 17588
containers:
- name: <name>
  image: <url>
  ...
  secrets:
  - snowflakeSecret: <snowflake-secret-name>
    directoryPath: '<local directory path in the container>'

-- Example 17589
CREATE SECRET testdb.testschema.my_secret_object
  TYPE = password
  USERNAME = 'snowman'
  PASSWORD = '1234abc';

-- Example 17590
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret_object
    directoryPath: '/usr/local/creds'

-- Example 17591
CREATE SECRET testdb.testschema.my_secret
  TYPE=generic_string
  SECRET_STRING='
       some_magic: config
  ';

-- Example 17592
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret
    directoryPath: '/usr/local/creds'

-- Example 17593
CREATE SECRET testdb.testschema.oauth_secret
  TYPE = OAUTH2
  OAUTH_REFRESH_TOKEN = '34n;vods4nQsdg09wee4qnfvadH'
  OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '2023-12-31 20:00:00'
  API_AUTHENTICATION = my_integration;

-- Example 17594
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.oauth_secret
    directoryPath: '/usr/local/creds'

-- Example 17595
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION example_eai
  ALLOWED_NETWORK_RULES = (<name>)
  ALLOWED_AUTHENTICATION_SECRETS = (testdb.testschema.oauth_secret)
  ENABLED = true;

-- Example 17596
CREATE SERVICE eai_service
  IN COMPUTE POOL MYPOOL
  EXTERNAL_ACCESS_INTEGRATIONS = (example_eai)
  FROM SPECIFICATION
  $$
  spec:
    containers:
      - name: main
        image: <url>
        secrets:
        - snowflakeSecret: testdb.testschema.oauth_secret
          directoryPath: '/usr/local/creds'
    endpoints:
      - name: api
        port: 8080
  $$;

-- Example 17597
ALTER SESSION SET statement_timeout_in_seconds=<time>

-- Example 17598
SELECT COUNT(age) AS count_age where age >= 20 and age <= 100 FROM t1 GROUP BY score

