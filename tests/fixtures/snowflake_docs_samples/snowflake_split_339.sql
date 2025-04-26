-- Example 22691
SELECT *
FROM TABLE(MODEL_MONITOR_DRIFT_METRIC (
                                        <model_monitor_name>,
                                        <drift_metric_name>,
                                        <column_name>,
                                        <granularity>,
                                        <start_time>,
                                        <end_time>
                                      )
          )

-- Example 22692
SELECT *
FROM TABLE(MODEL_MONITOR_PERFORMANCE_METRIC (
                                        <model_monitor_name>,
                                        <metric_name>,
                                        <granularity>,
                                        <start_time>,
                                        <end_time>
                                      )
          )

-- Example 22693
SELECT *
FROM TABLE(MODEL_MONITOR_STAT_METRIC (
                                        <model_monitor_name>,
                                        <metric_name>,
                                        <granularity>,
                                        <start_time>,
                                        <end_time>
                                      )
          )

-- Example 22694
SELECT
  SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
    @parse_document.demo.documents,
    'document_1.pdf',
    {'mode': 'LAYOUT'}
  ) AS layout;

-- Example 22695
CREATE STAGE input_stage
    DIRECTORY = ( ENABLE = true )
    ENCRYPTION = ( TYPE = 'SNOWFLAKE_SSE' );

-- Example 22696
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
    @document_stage,
    'weather_policy.pdf'
  ) AS weather_policy_doc

-- Example 22697
{
  "content": "SOME INSURANCE COMPANY\nWEATHER PROTECTION INSURANCE POLICY\nPolicy Number: WP-2025-789456\nEffective Date: April 1, 2025\nExpiration Date: April 1, 2026\nNAMED INSURED AND PROPERTY:\nJohn and Mary Homeowner\n123 Shelter Lane\nWeatherton, ST 12345\n

SECTION I - DEFINITIONS\nThroughout this policy, \"you\" and \"your\" refer to the Named Insured shown in the Declarations and the spouse if a\nresident of the same household. \"We,\" \"us,\" and \"our\" refer to Evergreen Insurance Company providing this\ninsurance. In addition, certain words and phrases are defined as follows:\n1. Weather Event means a natural atmospheric occurrence including but not limited to: a. Wind (including\nhurricanes, tornadoes, and straight-line winds) b. Hail c. Lightning d. Snow, ice, and freezing rain e.\nExcessive rainfall resulting in flooding f. Extreme temperatures causing damage\n2. Named Storm means any storm or weather disturbance that has been declared and named as a tropical\nstorm or hurricane by the National Weather Service or National Hurricane Center.\n3. Actual Cash Value (ACV) means the cost to repair or replace damaged property with new material of like\nkind and quality, less depreciation due to age, wear and condition.\n4. Replacement Cost means the cost to repair or replace damaged property with new material of like kind\nand quality, without deduction for depreciation.\n5. Dwelling means the building structure at the insured location including attached structures and fixtures.\n6. Other Structures means structures on the residence premises separated from the dwelling by clear\nspace or connected only by a fence, utility line, or similar connection.\n7. Personal Property means movable items owned by you and located at the insured property.\n

SECTION II - COVERAGE\nA. PROPERTY COVERAGE\nWe will pay for direct physical loss to property described in the Declarations caused by a Weather Event unless\nthe loss is excluded in Section III - Exclusions.\n1. Dwelling Protection We will cover: a. Your dwelling, including attached structures b. Materials and\nsupplies located on or adjacent to the residence premises for use in construction, alteration, or repair of\nthe dwelling or other structures c. Foundation, floor slab, and footings supporting the dwelling d.\nWall-to-wall carpeting attached to the dwelling\n2. Other Structures Protection We will cover structures on your property separated from your dwelling by\nclear space, including: a. Detached garages b. Storage sheds c. Fences d. Driveways and walkways e.\nPatios and retaining walls\n3. Personal Property Protection We will cover personal property owned or used by you while it is on the\nresidence premises. Coverage includes but is not limited to: a. Furniture b. Clothing c. Electronic\nequipment d. Appliances e. Sporting goods\n4. Loss of Use Protection If a Weather Event makes your residence uninhabitable, we will cover: a.\nAdditional living expenses incurred to maintain your normal standard of living b. Fair rental value if part of\nyour residence is rented to others c. Necessary expenses required to make the residence habitable or\nmove to temporary housing\nB. ADDITIONAL COVERAGES",
  "metadata": {
    "pageCount": 1
  }
}

-- Example 22698
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
  CONCAT ('Is clothing covered as part of the weather protection insurance policy?',
    TO_VARCHAR(weather_policy_doc))) FROM ocr_example_docs

-- Example 22699
Yes, clothing is covered under the insurance policy. According to Section II - Coverage, Part A.3 (Personal Property Protection), clothing is specifically listed as one of the covered personal property items while it is on the residence premises. The policy states: "We will cover personal property owned or used by you while it is on the residence premises. Coverage includes but is not limited to: a. Furniture b. Clothing c. Electronic equipment d. Appliances e. Sporting goods"

-- Example 22700
ALTER SESSION SET TIMEZONE = UTC;

-- Example 22701
SELECT
    pipe_id,
    start_time,
    end_time,
    credits_used,
    bytes_inserted,
    files_inserted
  FROM SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY
  WHERE pipe_name = 'my_auto_refresh_pipe'
  AND START_TIME >= '2025-04-01';

-- Example 22702
SELECT
    pipe_id,
    start_time,
    end_time,
    credits_used,
  FROM SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY
  WHERE pipe_name = 'iceberg_glue_table'
  AND START_TIME >= '2025-04-01';

-- Example 22703
POLICY_REFERENCES( POLICY_NAME => '<password_policy_name>' )

-- Example 22704
SELECT *
FROM TABLE(
    my_db.information_schema.policy_references(
      POLICY_NAME => 'my_db.my_schema.password_policy_prod_1'
  )
);

-- Example 22705
USE ROLE USERADMIN;

CREATE ROLE policy_admin;

-- Example 22706
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE security TO ROLE policy_admin;

GRANT USAGE ON SCHEMA security.policies TO ROLE policy_admin;

GRANT CREATE PASSWORD POLICY ON SCHEMA security.policies TO ROLE policy_admin;

GRANT APPLY PASSWORD POLICY ON ACCOUNT TO ROLE policy_admin;

-- Example 22707
GRANT APPLY PASSWORD POLICY ON USER jsmith TO ROLE policy_admin;

-- Example 22708
USE ROLE SECURITYADMIN;
GRANT ROLE policy_admin TO USER jsmith;

-- Example 22709
USE ROLE policy_admin;

USE SCHEMA security.policies;

CREATE PASSWORD POLICY PASSWORD_POLICY_PROD_1
    PASSWORD_MIN_LENGTH = 14
    PASSWORD_MAX_LENGTH = 24
    PASSWORD_MIN_UPPER_CASE_CHARS = 2
    PASSWORD_MIN_LOWER_CASE_CHARS = 2
    PASSWORD_MIN_NUMERIC_CHARS = 2
    PASSWORD_MIN_SPECIAL_CHARS = 2
    PASSWORD_MIN_AGE_DAYS = 1
    PASSWORD_MAX_AGE_DAYS = 999
    PASSWORD_MAX_RETRIES = 3
    PASSWORD_LOCKOUT_TIME_MINS = 30
    PASSWORD_HISTORY = 5
    COMMENT = 'production account password policy';

-- Example 22710
ALTER ACCOUNT SET PASSWORD POLICY security.policies.password_policy_prod_1;

-- Example 22711
ALTER USER jsmith SET PASSWORD POLICY security.policies.password_policy_user;

-- Example 22712
ALTER ACCOUNT UNSET PASSWORD POLICY;

ALTER ACCOUNT SET PASSWORD POLICY security.policies.password_policy_prod_2;

-- Example 22713
ALTER USER JSMITH SET MUST_CHANGE_PASSWORD = true;

-- Example 22714
ALTER USER janesmith SET PASSWORD = 'H8MZRqa8gEe/kvHzvJ+Giq94DuCYoQXmfbb$Xnt' MUST_CHANGE_PASSWORD = TRUE;

-- Example 22715
ALTER USER janesmith RESET PASSWORD;

-- Example 22716
SELECT SYSTEM$GET_SERVICE_LOGS('echo_service', '0', 'echo', 10);

-- Example 22717
+--------------------------------------------------------------------------+
| SYSTEM$GET_SERVICE_LOGS                                                  |
|--------------------------------------------------------------------------|
| 10.16.6.163 - - [11/Apr/2023 21:44:03] "GET /healthcheck HTTP/1.1" 200 - |
| 10.16.6.163 - - [11/Apr/2023 21:44:08] "GET /healthcheck HTTP/1.1" 200 - |
| 10.16.6.163 - - [11/Apr/2023 21:44:13] "GET /healthcheck HTTP/1.1" 200 - |
| 10.16.6.163 - - [11/Apr/2023 21:44:18] "GET /healthcheck HTTP/1.1" 200 - |
+--------------------------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.878s

-- Example 22718
SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;

-- Example 22719
SELECT TIMESTAMP, RESOURCE_ATTRIBUTES, RECORD_ATTRIBUTES, VALUE
FROM <current-event-table-for-your-account>
WHERE timestamp > dateadd(hour, -1, current_timestamp())
AND RESOURCE_ATTRIBUTES:"snow.service.name" = <service-name>
AND RECORD_TYPE = 'LOG'
ORDER BY timestamp DESC
LIMIT 10;

-- Example 22720
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

-- Example 22721
{ "log.iostream": "stdout" }

-- Example 22722
"echo-service [2023-10-23 17:52:27,429] [DEBUG] Sending response: {'data': [[0, 'Joe said hello!']]}"

-- Example 22723
platformMonitor:
  metricConfig:
    groups:
    - <group 1>
    - <group 2>
    - ...

-- Example 22724
SELECT timestamp, value
  FROM my_event_table_db.my_event_table_schema.my_event_table
  WHERE timestamp > DATEADD(hour, -1, CURRENT_TIMESTAMP())
    AND RESOURCE_ATTRIBUTES:"snow.service.name" = 'MY_SERVICE'
    AND RECORD_TYPE = 'METRIC'
    ORDER BY timestamp DESC
    LIMIT 10;

-- Example 22725
SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;

-- Example 22726
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

-- Example 22727
SELECT timestamp, value
  FROM my_events
  WHERE timestamp > DATEADD(hour, -1, CURRENT_TIMESTAMP())
    AND RESOURCE_ATTRIBUTES:"snow.service.name" = 'ECHO_SERVICE'
    AND RECORD_TYPE = 'METRIC'
    AND RECORD:metric.name = 'container.cpu.usage'
    ORDER BY timestamp DESC
    LIMIT 100;

-- Example 22728
# HELP node_memory_capacity Defines SPCS compute pool resource capacity on the node
# TYPE node_memory_capacity gauge
node_memory_capacity{snow_compute_pool_name="MY_POOL",snow_compute_pool_node_instance_family="CPU_X64_S",snow_compute_pool_node_id="10.244.3.8"} 1
node_cpu_capacity{snow_compute_pool_name="MY_POOL",snow_compute_pool_node_instance_family="CPU_X64_S",snow_compute_pool_node_id="10.244.3.8"} 7.21397383168e+09

-- Example 22729
snow_compute_pool_name="MY_POOL",
snow_compute_pool_node_instance_family="CPU_X64_S",snow_compute_pool_node_id="10.244.3.8"

-- Example 22730
SELECT *
FROM snowflake.account_usage.query_history
WHERE user_type = 'SNOWFLAKE_SERVICE'
AND user_name = '<service_name>'
AND user_database_name = '<service_db_name>'
AND user_schema_name = '<service_schema_name>'
order by start_time;

-- Example 22731
SELECT *
FROM TABLE(<service_db_name>.information_schema.query_history())
WHERE user_database_name = '<service_db_name>'
AND user_schema_name = '<service_schema_name>'
AND user_type = 'SNOWFLAKE_SERVICE'
AND user_name = '<service_name>'
order by start_time;

-- Example 22732
SELECT query_history.*, services.*
FROM snowflake.account_usage.query_history
JOIN snowflake.account_usage.services
ON query_history.user_name = services.service_name
AND query_history.user_schema_id = services.service_schema_id
AND query_history.user_type = 'SNOWFLAKE_SERVICE'

-- Example 22733
SELECT services.*, users.*
FROM snowflake.account_usage.users
JOIN snowflake.account_usage.services
ON users.name = services.service_name
AND users.schema_id = services.service_schema_id
AND users.type = 'SNOWFLAKE_SERVICE'

-- Example 22734
from opentelemetry.sdk.trace import TracerProvider
from snowflake.telemetry.trace import SnowflakeTraceIdGenerator


trace_id_generator = SnowflakeTraceIdGenerator()
tracer_provider = TracerProvider(
    resource=Resource.create({"service.name": SERVICE_NAME}),
    id_generator=trace_id_generator
)

-- Example 22735
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

-- Example 22736
localhost:{PORT}/{METRICS_PATH}, {SCRAPE_FREQUENCY}

-- Example 22737
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

-- Example 22738
spec:
    ...
    args:
      - "-e"
      - "localhost:8000"

-- Example 22739
SELECT timestamp, record:metric.name, value
  FROM <current_event_table_for_your_account>
  WHERE timestamp > dateadd(hour, -1, CURRENT_TIMESTAMP())
    AND resource_attributes:"snow.service.name" = <service_name>
    AND scope:"name" != 'snow.spcs.platform'
    AND record_type = 'METRIC'
  ORDER BY timestamp DESC
  LIMIT 10;

-- Example 22740
AND record_type = 'SPAN' OR record_type = 'SPAN_EVENT'

-- Example 22741
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 22742
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 22743
SELECT
    query_hash,
    COUNT(*),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE warehouse_name = 'MY_WAREHOUSE'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 7
  GROUP BY query_hash
  ORDER BY SUM(total_elapsed_time) DESC
  LIMIT 100;

-- Example 22744
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 22745
SELECT * FROM table1 WHERE table1.name = 'AIHUA'

-- Example 22746
SELECT
    DATE_TRUNC('day', start_time),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE query_parameterized_hash = 'cbd58379a88c37ed6cc0ecfebb053b03'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 30
  GROUP BY DATE_TRUNC('day', start_time);

-- Example 22747
...
WHERE (query_hash = 'hash_from_v1' AND query_hash_version = 1)
  OR (query_hash = 'hash_from_v2' AND query_hash_version = 2)

-- Example 22748
SELECT phase_name, start_time, end_time,
       total_bytes, object_count, error
  FROM SNOWFLAKE.ACCOUNT_USAGE.REPLICATION_GROUP_REFRESH_HISTORY
  WHERE replication_group_name = 'MYFG';

-- Example 22749
SELECT replication_group_name, phase_name,
       start_time, end_time,
       total_bytes, object_count, error,
       ROW_NUMBER() OVER (
         PARTITION BY replication_group_name
         ORDER BY end_time DESC
       ) AS row_num
  FROM SNOWFLAKE.ACCOUNT_USAGE.REPLICATION_GROUP_REFRESH_HISTORY
  QUALIFY row_num = 1;

-- Example 22750
https://hooks.slack.com/services/<secret>

-- Example 22751
https://<hostname>.webhook.office.com/webhookb2/<secret>

-- Example 22752
{
   "routing_key" : "<integration_key>",
   ...

-- Example 22753
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

-- Example 22754
CREATE OR REPLACE SECRET my_slack_webhook_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX';

-- Example 22755
https://mymsofficehost.webhook.office.com/webhookb2/xxxxxxxx

-- Example 22756
CREATE OR REPLACE SECRET my_teams_webhook_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'xxxxxxxx';

-- Example 22757
xxxxxxxx

