-- Example 6882
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   FROM @tutorial_stage
   SPECIFICATION_FILE='echo_spec.yaml'
   MIN_INSTANCES=2
   MAX_INSTANCES=4
   MIN_READY_INSTANCES=1;

-- Example 6883
resources:
  requests:
   cpu: <cpu-units>

-- Example 6884
ALTER SERVICE echo_service
FROM SPECIFICATION $$
spec:
  …
  …
$$;

-- Example 6885
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

-- Example 6886
GRANT USAGE ON DATABASE my_db TO ROLE some_role;
GRANT USAGE ON SCHEMA my_schema TO ROLE some_role;

-- Example 6887
GRANT SERVICE ROLE my_service!all_endpoints_usage TO ROLE some_role;

-- Example 6888
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

-- Example 6889
GRANT SERVICE ROLE my_service!ep1_role TO ROLE some_role;

-- Example 6890
spec:
…
  endpoints:
  - name: echoendpoint
    port: 8080

-- Example 6891
CREATE FUNCTION my_echo_udf (text varchar)
   RETURNS varchar
   SERVICE=echo_service
   ENDPOINT=echoendpoint
   AS '/echo';

-- Example 6892
@app.post("/echo")
def echo():
...

-- Example 6893
SELECT service_function_name(<parameter-list>);

-- Example 6894
"Alex", "2014-01-01 16:00:00"
"Steve", "2015-01-01 16:00:00"
…

-- Example 6895
SELECT service_func(col1, col2) FROM input_table;

-- Example 6896
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

-- Example 6897
{
   "data":[
      [0, "a"],
      [1, "b"],
      …
      [ row_index,  output_column1]
   ]
}

-- Example 6898
ALTER FUNCTION my_echo_udf(VARCHAR)
   SET MAX_BATCH_ROWS = 10

-- Example 6899
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

-- Example 6900
spec
  ...
  endpoints
  - name: <endpoint name>
    port: <port number>
    public: true

-- Example 6901
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

-- Example 6902
Sf-Context-Current-User: <user_name>

-- Example 6903
<service-name>.<hash>.svc.spcs.internal

-- Example 6904
instances.<service-name>.<hash>.svc.spcs.internal

-- Example 6905
eth0Ip=$(ifconfig eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')

-- Example 6906
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

-- Example 6907
SYSTEM$GET_SERVICE_STATUS( [ <db_name>.<schema_name>. ]<service_name> [ , <timeout_secs> ]  )

-- Example 6908
SELECT SYSTEM$GET_SERVICE_STATUS('echo_service', 5);

-- Example 6909
[
 {
    "status":"READY",
    "message":"Running",
    "containerName":"echo",
    "instanceId":"0",
    "serviceName":"ECHO_SERVICE",
    "image":"<account>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:tutorial",
    "restartCount":0,
    "startTime":"2023-01-01T00:00:00Z"
 }
]

-- Example 6910
[
  {
  "status":"READY",
  "message":"Running",
  "containerName":"echo-1",
  "instanceId":"0",
  "serviceName":"ECHO_SERVICE",
  "image":"<account>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image_x:tutorial",
  "restartCount":0,
  "startTime":"2023-01-01T00:00:00Z"
  },
  {
  "status":"READY",
  "message":"Running",
  "containerName":"echo-2",
  "instanceId":"0",
  "serviceName":"ECHO_SERVICE",
  "image":"<account>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image_y:tutorial",
  "restartCount":0,
  "startTime":"2023-01-01T00:00:00Z"
  },
  {
  "status":"READY",
  "message":"Running",
  "containerName":"echo-3",
  "instanceId":"0",
  "serviceName":"ECHO_SERVICE",
  "image":"<account>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image_z:tutorial",
  "restartCount":0,
  "startTime":"2023-01-01T00:00:00Z"
  }
]

-- Example 6911
SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO()

-- Example 6912
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();

-- Example 6913
SYSTEM$GET_TAG( '<tag_name>' , '<obj_name>' , '<obj_domain>' )

-- Example 6914
select system$get_tag('cost_center', 'my_table', 'table');

+-----------------------------------------------------+
| SYSTEM$GET_TAG('COST_CENTER', 'MY_TABLE', 'TABLE')  |
+-----------------------------------------------------+
| NULL                                                |
+-----------------------------------------------------+

-- Example 6915
select system$get_tag('cost_center', 'my_table', 'table');

-----------------------------------------------------+
| SYSTEM$GET_TAG('COST_CENTER', 'MY_TABLE', 'TABLE') |
+----------------------------------------------------+
| sales                                              |
+----------------------------------------------------+

-- Example 6916
select system$get_tag('fiscal_quarter', 'my_table.revenue', 'column');

+----------------------------------------------------------------+
| SYSTEM$GET_TAG('FISCAL_QUARTER', 'MY_TABLE.REVENUE', 'COLUMN') |
+----------------------------------------------------------------+
| Q1                                                             |
+----------------------------------------------------------------+

-- Example 6917
SYSTEM$GET_TAG_ALLOWED_VALUES('<name>')

-- Example 6918
select system$get_tag_allowed_values('governance.tags.cost_center');

-- Example 6919
create tag cost_center
    allowed_values 'finance', 'engineering';

-- Example 6920
select get_ddl('tag', 'cost_center')

+------------------------------------------------------------------------------+
| GET_DDL('tag', 'cost_center')                                                |
|------------------------------------------------------------------------------|
| create or replace tag cost_center allowed_values = 'finance', 'engineering'; |
+------------------------------------------------------------------------------+

-- Example 6921
alter tag cost_center
    add allowed_values 'marketing';

-- Example 6922
alter tag cost_center
    drop allowed_values 'engineering';

-- Example 6923
select system$get_tag_allowed_values('governance.tags.cost_center');

+--------------------------------------------------------------+
| SYSTEM$GET_TAG_ALLOWED_VALUES('GOVERNANCE.TAGS.COST_CENTER') |
|--------------------------------------------------------------|
| ["finance","marketing"]                                      |
+--------------------------------------------------------------+

-- Example 6924
USE ROLE USERADMIN;
CREATE ROLE tag_admin;
USE ROLE ACCOUNTADMIN;
GRANT CREATE TAG ON SCHEMA mydb.mysch TO ROLE tag_admin;
GRANT APPLY TAG ON ACCOUNT TO ROLE tag_admin;

-- Example 6925
USE ROLE USERADMIN;
GRANT ROLE tag_admin TO USER jsmith;

-- Example 6926
USE ROLE tag_admin;
USE SCHEMA mydb.mysch;
CREATE TAG cost_center;

-- Example 6927
USE ROLE tag_admin;
CREATE WAREHOUSE mywarehouse WITH TAG (cost_center = 'sales');

-- Example 6928
USE ROLE tag_admin;
ALTER WAREHOUSE wh1 SET TAG cost_center = 'sales';

-- Example 6929
ALTER TABLE hr.tables.empl_info
  MODIFY COLUMN job_title
  SET TAG visibility = 'public';

-- Example 6930
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAGS
ORDER BY TAG_NAME;

-- Example 6931
SELECT SYSTEM$GET_TAG('cost_center', 'my_table', 'table');

-- Example 6932
SELECT *
FROM TABLE(
  snowflake.account_usage.tag_references_with_lineage(
    'my_db.my_schema.cost_center'
  )
);

-- Example 6933
SELECT * FROM snowflake.account_usage.tag_references
ORDER BY TAG_NAME, DOMAIN, OBJECT_ID;

-- Example 6934
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.TAG_REFERENCES(
    'my_table',
    'table'
  )
);

-- Example 6935
SELECT *
FROM TABLE(
  INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
    'my_table',
    'table'
  )
);

-- Example 6936
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 6937
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| created_on                    | privilege | granted_on    | name                        | granted_to | grantee_name    | grant_option | granted_by |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| 2024-01-24 17:12:26.984 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.GOVERNANCE_VIEWER | ROLE       | DATA_ENGINEER   | false        |            |
| 2024-01-24 17:12:47.967 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.OBJECT_VIEWER     | ROLE       | DATA_ENGINEER   | false        |            |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|

-- Example 6938
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE data_engineer;
GRANT DATABASE ROLE SNOWFLAKE.OBJECT_VIEWER TO ROLE data_engineer;
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 6939
use role securityadmin;
grant create tag on schema <db_name.schema_name> to role tag_admin;
grant apply tag on account to role tag_admin;

-- Example 6940
use role securityadmin;
grant create tag on schema <db_name.schema_name> to role tag_admin;
grant apply on tag cost_center to role finance_role;

-- Example 6941
SYSTEM$GET_TAG_ON_CURRENT_COLUMN( '<tag_name>' )

-- Example 6942
Tag '<tag_name>' does not exist or not authorized.

-- Example 6943
CREATE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col') = 'public'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 6944
SYSTEM$GET_TAG_ON_CURRENT_TABLE( '<tag_name>' )

-- Example 6945
Tag '<tag_name>' does not exist or not authorized.

-- Example 6946
SYSTEM$GET_TASK_GRAPH_CONFIG([configuration_path])

-- Example 6947
-- Create a task which defines and then uses configuration
CREATE OR REPLACE TASK root_task_with_config
WAREHOUSE=mywarehouse
SCHEDULE='10 m'
CONFIG=$${"output_dir": "/temp/test_directory/", "learning_rate": 0.1}$$
AS
BEGIN
  LET OUTPUT_DIR STRING := SYSTEM$GET_TASK_GRAPH_CONFIG('output_dir')::string;
  LET LEARNING_RATE DECIMAL := SYSTEM$GET_TASK_GRAPH_CONFIG('learning_rate')::DECIMAL;
      ...
END;

-- Example 6948
SELECT SYSTEM$GLOBAL_ACCOUNT_SET_PARAMETER('<account_identifier>',
  'ENABLE_ACCOUNT_DATABASE_REPLICATION', 'true');

