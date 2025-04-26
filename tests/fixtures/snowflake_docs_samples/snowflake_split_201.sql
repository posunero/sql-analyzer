-- Example 13447
- name: resource-test
  image: ...
  resources:
    requests:
      memory: 15G

-- Example 13448
spec:
  containers:
  - name: resource-test-gpu
    image: ...
    resources:
      requests:
        memory: 2G
        nvidia.com/gpu: 1
      limits:
        nvidia.com/gpu: 1

-- Example 13449
secrets:                                # optional list
  - snowflakeSecret:
      objectName: <object-name>         # specify this or objectReference
      objectReference: <reference-name> # specify this or objectName
    directoryPath: <path>               # specify this or envVarName
    envVarName: <name>                  # specify this or directoryPath
    secretKeyRef: username | password | secret_string # specify only with envVarName
  - snowflakeSecret: <object-name>      # equivalent to snowflakeSecret.objectName
    ...

-- Example 13450
instances.<Snowflake_assigned_service_DNS_name>

-- Example 13451
spec:
  container:
  - name: echo
    image: <image-name>
    env:
      SERVER_PORT: 8000
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8000
      path: /healthcheck
  endpoint:
  - name: echoendpoint
    port: 8000
    public: true

-- Example 13452
spec:
  containers:
  - name: app
    image: <image1-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/app/logs
    - name: models
      mountPath: /opt/models
  - name: logging-agent
    image: <image2-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/logs
  volumes:
  - name: logs
    source: local
  - name: models
    source: "@model_stage"

-- Example 13453
spec:
  containers:
  - name: app
    image: <image1-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/app/logs
    - name: models
      mountPath: /opt/models
    - name: my-mem-volume
      mountPath: /dev/shm
  - name: logging-agent
    image: <image2-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/logs
  volumes:
  - name: logs
    source: local
  - name: models
    source: "@model_stage"
  - name: "my-mem-volume"
    source: memory
    size: 2G

-- Example 13454
spec:
  ...

  volumes:
  - name: stagemount
    source: "@test"
    uid: <UID-value>
    gid: <GID-value>

-- Example 13455
CONTAINER ID   IMAGE                       COMMAND
—----------------------------------------------------------
a6a1f1fe204d  tutorial-image         "/usr/local/bin/entr…"

-- Example 13456
docker exec -it <container-id> id

-- Example 13457
uid=0(root) gid=0(root) groups=0(root)

-- Example 13458
logExporters:
  eventTableConfig:
    logLevel: < INFO | ERROR | NONE >

-- Example 13459
platformMonitor:
  metricConfig:
    groups:
    - <group_1>
    - <group_2>
    ...

-- Example 13460
capabilities:
  securityContext:
    executeAsCaller: <true / false>    # optional, indicates whether application intends to use caller’s rights

-- Example 13461
serviceRoles:                   # Optional list of service roles
- name: <name>
  endpoints:
  - <endpoint-name>
  - <endpoint-name>
  - ...
- ...

-- Example 13462
CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;

-- Example 13463
ALTER COMPUTE POOL <name> { SUSPEND | RESUME | STOP ALL }

-- Example 13464
ALTER COMPUTE POOL <name> SET propertiesToAlter = <value>
propertiesToAlter := { MIN_NODES | MAX_NODES | AUTO_RESUME | AUTO_SUSPEND_SECS | COMMENT }

-- Example 13465
ALTER COMPUTE POOL my_pool SET MIN_NODES = 2  MAX_NODES = 2;

-- Example 13466
DROP COMPUTE POOL <name>

-- Example 13467
USE ROLE ACCOUNTADMIN;
ALTER COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU STOP ALL;
DROP COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU;

-- Example 13468
USE ROLE ACCOUNTADMIN;
REVOKE USAGE ON COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU FROM ROLE PUBLIC;
GRANT USAGE ON COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU TO ROLE <role-name>;

-- Example 13469
ALTER ACCOUNT SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';

-- Example 13470
ALTER DATABASE my_db SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';

-- Example 13471
ALTER SCHEMA my_db.my_schema SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';

-- Example 13472
SHOW PARAMETERS LIKE 'DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU' IN ACCOUNT;

SHOW PARAMETERS LIKE 'DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU' IN DATABASE my_db;

SHOW PARAMETERS LIKE 'DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU' IN SCHEMA my_db.my_schema;

-- Example 13473
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE <role_name> [WITH GRANT OPTION];

-- Example 13474
SNOWFLAKE_ACCOUNT = os.getenv('SNOWFLAKE_ACCOUNT')
SNOWFLAKE_HOST = os.getenv('SNOWFLAKE_HOST')

-- Example 13475
def get_login_token():
  with open('/snowflake/session/token', 'r') as f:
    return f.read()

conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth'
)

-- Example 13476
conn = snowflake.connector.connect(
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  user = '<user-name>',
  password = <password>
)

-- Example 13477
CREATE OR REPLACE NETWORK RULE snowflake_egress_access
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('myaccount.snowflakecomputing.com');

-- Example 13478
CREATE EXTERNAL ACCESS INTEGRATION snowflake_egress_access_integration
  ALLOWED_NETWORK_RULES = (snowflake_egress_access)
  ENABLED = true;

-- Example 13479
-- Create a service.
CREATE SERVICE test_service IN COMPUTE POOL ...

-- Execute a job service.
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = example_job_service ...

-- Example 13480
-- Create a service.
CREATE SERVICE test_db.test_schema.test_service IN COMPUTE POOL ...

-- Execute a job service.
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = test_db.test_schema.example_job_service ...

-- Example 13481
conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth',
  database = os.getenv('SNOWFLAKE_DATABASE'),
  schema = os.getenv('SNOWFLAKE_SCHEMA')
)

-- Example 13482
USE DATABASE tutorial_db;
...
USE SCHEMA data_schema;

-- Example 13483
SNOWFLAKE_DATABASE = os.getenv('SNOWFLAKE_DATABASE')
SNOWFLAKE_SCHEMA = os.getenv('SNOWFLAKE_SCHEMA')

-- Example 13484
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

-- Example 13485
def get_login_token():
  with open('/snowflake/session/token', 'r') as f:
    return f.read()

conn = snowflake.connector.connect(
  host = os.getenv('SNOWFLAKE_HOST'),
  account = os.getenv('SNOWFLAKE_ACCOUNT'),
  token = get_login_token(),
  authenticator = 'oauth'
)

-- Example 13486
spec:
  containers:
  ...
capabilities:
  securityContext:
    executeAsCaller: true

-- Example 13487
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

-- Example 13488
ALTER USER my_user SET DEFAULT_SECONDARY_ROLES = ( 'ALL' );

-- Example 13489
-- Permissions to resolve the table's name.
GRANT CALLER USAGE ON DATABASE <db_name> TO ROLE <service_owner_role>;
GRANT CALLER USAGE ON SCHEMA <schema_name> TO ROLE <service_owner_role>;
-- Permissions to use a warehouse
GRANT CALLER USAGE ON WAREHOUSE <warehouse_name> TO ROLE <service_owner_role>;
-- Permissions to query the table.
GRANT CALLER SELECT ON TABLE T1 TO ROLE <service_owner_role>;

-- Example 13490
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

-- Example 13491
default-src 'self' 'unsafe-inline' 'unsafe-eval' blob: data:; object-src 'none'; connect-src 'self'; frame-ancestors 'self';

-- Example 13492
script-src 'self'

-- Example 13493
default-src 'self' 'unsafe-inline' 'unsafe-eval' http://example.com https://example.com blob: data:; object-src 'none'; connect-src 'self' http://example.com https://example.com wss://example.com; frame-ancestors 'self';

-- Example 13494
SHOW PARAMETERS LIKE 'SAML_IDENTITY_PROVIDER' IN ACCOUNT;

-- Example 13495
SHOW INTEGRATIONS;
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) WHERE "type" = 'SAML2';

-- Example 13496
CREATE OR REPLACE NETWORK RULE translate_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 13497
CREATE OR REPLACE NETWORK RULE google_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('google.com:80', 'google.com:443');

-- Example 13498
CREATE NETWORK RULE allow_all_rule
  TYPE = 'HOST_PORT'
  MODE= 'EGRESS'
  VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

-- Example 13499
CREATE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (translate_network_rule, google_network_rule)
  ENABLED = true;

-- Example 13500
GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE test_role;

-- Example 13501
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

-- Example 13502
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

-- Example 13503
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 13504
CREATE OR REPLACE NETWORK RULE private_link_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('<bucket-name>.s3.us-west-2.amazonaws.com');

-- Example 13505
...
secrets:
- snowflakeSecret:
    objectName: '<secret-name>'
  <other info about where in the container to copy the secret>
  ...

-- Example 13506
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret:
      objectReference: '<reference-name>'
    <other info about where in the container to copy the secret>

-- Example 13507
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: <secret-name>
    secretKeyRef: username | password | secret_string |  'access_token'
    envVarName: '<env-variable-name>'

-- Example 13508
CREATE SECRET testdb.testschema.my_secret_object
  TYPE = password
  USERNAME = 'snowman'
  PASSWORD = '1234abc';

-- Example 13509
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

-- Example 13510
CREATE SECRET testdb.testschema.my_secret
  TYPE=generic_string
  SECRET_STRING='
       some_magic: config
  ';

-- Example 13511
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret
    secretKeyRef: secret_string
    envVarName: GENERIC_SECRET

-- Example 13512
containers:
- name: <name>
  image: <url>
  ...
  secrets:
  - snowflakeSecret: <snowflake-secret-name>
    directoryPath: '<local directory path in the container>'

-- Example 13513
CREATE SECRET testdb.testschema.my_secret_object
  TYPE = password
  USERNAME = 'snowman'
  PASSWORD = '1234abc';

