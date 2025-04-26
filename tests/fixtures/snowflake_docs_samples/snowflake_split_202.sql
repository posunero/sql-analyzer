-- Example 13514
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret_object
    directoryPath: '/usr/local/creds'

-- Example 13515
CREATE SECRET testdb.testschema.my_secret
  TYPE=generic_string
  SECRET_STRING='
       some_magic: config
  ';

-- Example 13516
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.my_secret
    directoryPath: '/usr/local/creds'

-- Example 13517
CREATE SECRET testdb.testschema.oauth_secret
  TYPE = OAUTH2
  OAUTH_REFRESH_TOKEN = '34n;vods4nQsdg09wee4qnfvadH'
  OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '2023-12-31 20:00:00'
  API_AUTHENTICATION = my_integration;

-- Example 13518
containers:
- name: main
  image: <url>
  secrets:
  - snowflakeSecret: testdb.testschema.oauth_secret
    directoryPath: '/usr/local/creds'

-- Example 13519
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION example_eai
  ALLOWED_NETWORK_RULES = (<name>)
  ALLOWED_AUTHENTICATION_SECRETS = (testdb.testschema.oauth_secret)
  ENABLED = true;

-- Example 13520
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

-- Example 13521
ALTER SESSION SET statement_timeout_in_seconds=<time>

-- Example 13522
SELECT SYSTEM$GET_SERVICE_LOGS('echo_service', '0', 'echo', 10);

-- Example 13523
+--------------------------------------------------------------------------+
| SYSTEM$GET_SERVICE_LOGS                                                  |
|--------------------------------------------------------------------------|
| 10.16.6.163 - - [11/Apr/2023 21:44:03] "GET /healthcheck HTTP/1.1" 200 - |
| 10.16.6.163 - - [11/Apr/2023 21:44:08] "GET /healthcheck HTTP/1.1" 200 - |
| 10.16.6.163 - - [11/Apr/2023 21:44:13] "GET /healthcheck HTTP/1.1" 200 - |
| 10.16.6.163 - - [11/Apr/2023 21:44:18] "GET /healthcheck HTTP/1.1" 200 - |
+--------------------------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.878s

-- Example 13524
SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;

-- Example 13525
SELECT TIMESTAMP, RESOURCE_ATTRIBUTES, RECORD_ATTRIBUTES, VALUE
FROM <current-event-table-for-your-account>
WHERE timestamp > dateadd(hour, -1, current_timestamp())
AND RESOURCE_ATTRIBUTES:"snow.service.name" = <service-name>
AND RECORD_TYPE = 'LOG'
ORDER BY timestamp DESC
LIMIT 10;

-- Example 13526
{
  "snow.account.name": "SPCSDOCS1",
  "snow.compute_pool.id": 20,
  "snow.compute_pool.name": "TUTORIAL_COMPUTE_POOL",
  "snow.compute_pool.node.id": "a17e8157",
  "snow.compute_pool.node.instance_family": "CPU_X64_XS",
  "snow.database.id": 26,
  "snow.database.name": "TUTORIAL_DB",
  "snow.schema.id": 212,
  "snow.schema.name": "DATA_SCHEMA",
  "snow.service.container.instance": "0",
  "snow.service.container.name": "echo",
  "snow.service.container.run.id": "b30566",
   "snow.service.id": 114,
  "snow.service.name": "ECHO_SERVICE2",
  "snow.service.type": "Service"
}

-- Example 13527
{ "log.iostream": "stdout" }

-- Example 13528
"echo-service [2023-10-23 17:52:27,429] [DEBUG] Sending response: {'data': [[0, 'Joe said hello!']]}"

-- Example 13529
platformMonitor:
  metricConfig:
    groups:
    - <group 1>
    - <group 2>
    - ...

-- Example 13530
SELECT timestamp, value
  FROM my_event_table_db.my_event_table_schema.my_event_table
  WHERE timestamp > DATEADD(hour, -1, CURRENT_TIMESTAMP())
    AND RESOURCE_ATTRIBUTES:"snow.service.name" = 'MY_SERVICE'
    AND RECORD_TYPE = 'METRIC'
    ORDER BY timestamp DESC
    LIMIT 10;

-- Example 13531
SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;

-- Example 13532
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
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
      platformMonitor:
        metricConfig:
          groups:
          - system
          - system_limits
      $$
    MIN_INSTANCES=1
    MAX_INSTANCES=1;

-- Example 13533
SELECT timestamp, value
  FROM my_events
  WHERE timestamp > DATEADD(hour, -1, CURRENT_TIMESTAMP())
    AND RESOURCE_ATTRIBUTES:"snow.service.name" = 'ECHO_SERVICE'
    AND RECORD_TYPE = 'METRIC'
    AND RECORD:metric.name = 'container.cpu.usage'
    ORDER BY timestamp DESC
    LIMIT 100;

-- Example 13534
# HELP node_memory_capacity Defines SPCS compute pool resource capacity on the node
# TYPE node_memory_capacity gauge
node_memory_capacity{snow_compute_pool_name="MY_POOL",snow_compute_pool_node_instance_family="CPU_X64_S",snow_compute_pool_node_id="10.244.3.8"} 1
node_cpu_capacity{snow_compute_pool_name="MY_POOL",snow_compute_pool_node_instance_family="CPU_X64_S",snow_compute_pool_node_id="10.244.3.8"} 7.21397383168e+09

-- Example 13535
snow_compute_pool_name="MY_POOL",
snow_compute_pool_node_instance_family="CPU_X64_S",snow_compute_pool_node_id="10.244.3.8"

-- Example 13536
SELECT *
FROM snowflake.account_usage.query_history
WHERE user_type = 'SNOWFLAKE_SERVICE'
AND user_name = '<service_name>'
AND user_database_name = '<service_db_name>'
AND user_schema_name = '<service_schema_name>'
order by start_time;

-- Example 13537
SELECT *
FROM TABLE(<service_db_name>.information_schema.query_history())
WHERE user_database_name = '<service_db_name>'
AND user_schema_name = '<service_schema_name>'
AND user_type = 'SNOWFLAKE_SERVICE'
AND user_name = '<service_name>'
order by start_time;

-- Example 13538
SELECT query_history.*, services.*
FROM snowflake.account_usage.query_history
JOIN snowflake.account_usage.services
ON query_history.user_name = services.service_name
AND query_history.user_schema_id = services.service_schema_id
AND query_history.user_type = 'SNOWFLAKE_SERVICE'

-- Example 13539
SELECT services.*, users.*
FROM snowflake.account_usage.users
JOIN snowflake.account_usage.services
ON users.name = services.service_name
AND users.schema_id = services.service_schema_id
AND users.type = 'SNOWFLAKE_SERVICE'

-- Example 13540
from opentelemetry.sdk.trace import TracerProvider
from snowflake.telemetry.trace import SnowflakeTraceIdGenerator


trace_id_generator = SnowflakeTraceIdGenerator()
tracer_provider = TracerProvider(
    resource=Resource.create({"service.name": SERVICE_NAME}),
    id_generator=trace_id_generator
)

-- Example 13541
import io.opentelemetry.sdk.autoconfigure.AutoConfiguredOpenTelemetrySdk;
import com.snowflake.telemetry.trace.SnowflakeTraceIdGenerator;

static OpenTelemetry initOpenTelemetry() {
  return AutoConfiguredOpenTelemetrySdk.builder()
      .addPropertiesSupplier(
          () ->
              Map.of(...config options...)
      .addTracerProviderCustomizer(
          (tracerProviderBuilder, configProperties) -> {
            tracerProviderBuilder.setIdGenerator(SnowflakeTraceIdGenerator.INSTANCE);
            return tracerProviderBuilder;
          })
      .build()
      .getOpenTelemetrySdk();

-- Example 13542
localhost:{PORT}/{METRICS_PATH}, {SCRAPE_FREQUENCY}

-- Example 13543
spec:
  containers:
  - name: <name>
    image: <image-name>
    .....
  - name: prometheus
    image: /snowflake/images/snowflake_images/monitoring-prometheus-sidecar:0.0.1
    args:
      - "-e"
      - "localhost:8000/metrics,1m"

-- Example 13544
spec:
    ...
    args:
      - "-e"
      - "localhost:8000"

-- Example 13545
SELECT timestamp, record:metric.name, value
  FROM <current_event_table_for_your_account>
  WHERE timestamp > dateadd(hour, -1, CURRENT_TIMESTAMP())
    AND resource_attributes:"snow.service.name" = <service_name>
    AND scope:"name" != 'snow.spcs.platform'
    AND record_type = 'METRIC'
  ORDER BY timestamp DESC
  LIMIT 10;

-- Example 13546
AND record_type = 'SPAN' OR record_type = 'SPAN_EVENT'

-- Example 13547
docker push myorg-my_acct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/service_to_service

-- Example 13548
Get "https:/v2/": http: no Host in request URL.

-- Example 13549
ALTER COMPUTE POOL <pool_name> STOP ALL

-- Example 13550
CREATE SERVICE [ IF NOT EXISTS ] <name>
  IN COMPUTE POOL <compute_pool_name>
  {
     fromSpecification
     | fromSpecificationTemplate
  }
  [ AUTO_SUSPEND_SECS = <num> ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <EAI_name> [ , ... ] ) ]
  [ AUTO_RESUME = { TRUE | FALSE } ]
  [ MIN_INSTANCES = <num> ]
  [ MIN_READY_INSTANCES = <num> ]
  [ MAX_INSTANCES = <num> ]
  [ QUERY_WAREHOUSE = <warehouse_name> ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COMMENT = '{string_literal}']

-- Example 13551
fromSpecification ::=
  {
    FROM SPECIFICATION_FILE = '<yaml_file_path>' -- for native app service.
    | FROM @<stage> SPECIFICATION_FILE = '<yaml_file_path>' -- for non-native app service.
    | FROM SPECIFICATION <specification_text>
  }

-- Example 13552
fromSpecificationTemplate ::=
  {
    FROM SPECIFICATION_TEMPLATE_FILE = '<yaml_file_stage_path>' -- for native app service.
    | FROM @<stage> SPECIFICATION_TEMPLATE_FILE = '<yaml_file_stage_path>' -- for non-native app service.
    | FROM SPECIFICATION_TEMPLATE <specification_text>
  }
  USING ( <key> => <value> [ , <key> => <value> [ , ... ] ]  )

-- Example 13553
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM @tutorial_stage
  SPECIFICATION_FILE='echo_spec.yaml'
  MIN_INSTANCES=2
  MAX_INSTANCES=2

-- Example 13554
EXECUTE JOB SERVICE
  IN COMPUTE POOL <compute_pool_name>
  {
     fromSpecification
     | fromSpecificationTemplate
  }
  NAME = [<db>.<schema>.]<name>
  [ ASYNC = { TRUE | FALSE } ]
  [ QUERY_WAREHOUSE = <warehouse_name> ]
  [ COMMENT = '<string_literal>']
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <EAI_name> [ , ... ] ) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 13555
fromSpecification ::=
  {
    FROM @<stage> SPECIFICATION_FILE = '<yaml_file_stage_path>'
    | FROM SPECIFICATION <specification_text>
  }

-- Example 13556
fromSpecificationTemplate ::=
  {
    FROM @<stage> SPECIFICATION_TEMPLATE_FILE = '<yaml_file_stage_path>'
    | FROM SPECIFICATION_TEMPLATE <specification_text>
  }
  USING ( <key> => <value> [ , <key> => <value> [ , ... ] ]  )

-- Example 13557
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = tutorial_db.data_schema.example_job
  ASYNC = TRUE
  FROM @tutorial_stage
  FROM SPECIFICATION $$
  <job specification>
  $$;

-- Example 13558
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME=tutorial_job_service
  FROM SPECIFICATION $$
  spec:
    container:
    - name: main
      image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
      volumeMounts:
        - name: block-vol1
          mountPath: /opt/block/path
    volumes:
    - name: block-vol1
      source: block
      size: 10Gi
      blockConfig:
        iops: 4000
        throughput: 200
  $$

-- Example 13559
CREATE COMPUTE POOL [ IF NOT EXISTS ] <name>
  [ FOR APPLICATION <app-name> ]
  MIN_NODES = <num>
  MAX_NODES = <num>
  INSTANCE_FAMILY = <instance_family_name>
  [ AUTO_RESUME = { TRUE | FALSE } ]
  [ INITIALLY_SUSPENDED = { TRUE | FALSE } ]
  [ AUTO_SUSPEND_SECS = <num>  ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 13560
CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;

-- Example 13561
CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS
  AUTO_RESUME = FALSE;

-- Example 13562
CREATE [ OR REPLACE ] FUNCTION <name> ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  SERVICE = <service_name>
  ENDPOINT = <endpoint_name>
  [ COMMENT = '<string_literal>' ]
  [ CONTEXT_HEADERS = ( <context_function_1> [ , <context_function_2> ...] ) ]
  [ MAX_BATCH_ROWS = <integer> ]
  AS '<http_path_to_request_handler>'

-- Example 13563
CREATE [ OR ALTER ] FUNCTION ...

-- Example 13564
CONTEXT_HEADERS = (current_timestamp)

-- Example 13565
select
  /*ÄÎßë¬±©®*/
  my_service_function(1);

-- Example 13566
select /* */ my_service_function(1);

-- Example 13567
base64_encode('select\n/ÄÎßë¬±©®/\nmy_service_function(1)')

-- Example 13568
sf-context-<context-function>-base64

-- Example 13569
sf-context-current-statement-base64

-- Example 13570
CREATE FUNCTION my_echo_udf (InputText VARCHAR)
  RETURNS VARCHAR
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 13571
CREATE OR ALTER FUNCTION my_echo_udf (InputText VARCHAR)
  RETURNS VARCHAR
  SERVICE = echo_service
  ENDPOINT = reverse_echoendpoint
  CONTEXT_HEADERS = (current_account)
  MAX_BATCH_ROWS = 100
  AS '/echo';

-- Example 13572
ALTER ACCOUNT SET EVENT_TABLE = NONE

-- Example 13573
CREATE STREAM append_only_comparison ON EVENT TABLE my_event_table APPEND_ONLY=TRUE;

-- Example 13574
{
  "severity_text": "INFO"
}

-- Example 13575
{
  "metric": {
    "name": "process.memory.usage",
    "unit": "bytes"
  },
  "metric_type": "sum",
  "value_type": "INT"
}

-- Example 13576
{
  "code.filepath": "main.scala",
  "code.function": "$anonfun$new$10",
  "code.lineno": 149,
  "code.namespace": "main.main$",
  "thread.id": 1,
  "thread.name": "main"
  "employee.id": "52307953446424"
}

-- Example 13577
{
  "snow.input.rows": 12
  "snow.output.rows": 12
}

-- Example 13578
{
  "MyFunctionVersion": "1.1.0"
}

-- Example 13579
{
  "mykey1": "value1",
  "mykey2": "value2"
}

-- Example 13580
{
  "db.user": "MYUSERNAME",
  "snow.database.id": 13,
  "snow.database.name": "MY_DB",
  "snow.executable.id": 197,
  "snow.executable.name": "FUNCTION_NAME(I NUMBER):ARG_NAME(38,0)",
  "snow.executable.type": "FUNCTION",
  "snow.owner.id": 2,
  "snow.owner.name": "MY_ROLE",
  "snow.query.id": "01ab0f07-0000-15c8-0000-0129000592c2",
  "snow.schema.id": 16,
  "snow.schema.name": "PUBLIC",
  "snow.session.id": 1275605667850,
  "snow.session.role.primary.id": 2,
  "snow.session.role.primary.name": "MY_ROLE",
  "snow.user.id": 25,
  "snow.warehouse.id": 5,
  "snow.warehouse.name": "MYWH",
  "telemetry.sdk.language": "python"
}

