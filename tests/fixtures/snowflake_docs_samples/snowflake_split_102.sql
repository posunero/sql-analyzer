-- Example 6815
-- Updates the date/time table after the root task completes.
CREATE OR REPLACE TASK "task_date_time_table"
  USER_TASK_TIMEOUT_MS = 60000
  AFTER "task_root"
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
      INSERT INTO date_time_table VALUES('order_date',:value);
    END;

-- Example 6816
-- Create a notebook in the public schema
-- USE DATABASE <database name>;
-- USE SCHEMA <schema name>;

-- task_a: Root task. Starts the task graph and sets basic configurations.
CREATE OR REPLACE TASK task_a
  SCHEDULE = '1 MINUTE'
  TASK_AUTO_RETRY_ATTEMPTS = 2
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3
  USER_TASK_TIMEOUT_MS = 60000
  CONFIG='{"environment": "production", "path": "/prod_directory/"}'
  AS
    BEGIN
      CALL SYSTEM$SET_RETURN_VALUE('task_a successful');
    END;
;

-- task_customer_table: Updates the customer table.
--   Runs after the root task completes.
CREATE OR REPLACE TASK task_customer_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT customer_id FROM ref_cust_table
        WHERE cust_name = "Jane Doe";);
      INSERT INTO customer_table VALUES('customer_id',:value);
    END;
;

-- task_product_table: Updates the product table.
--   Runs after the root task completes.
CREATE OR REPLACE TASK task_product_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT product_id FROM ref_item_table
        WHERE PRODUCT_NAME = "widget";);
      INSERT INTO product_table VALUES('product_id',:value);
    END;
;

-- task_date_time_table: Updates the date/time table.
--   Runs after the root task completes.
CREATE OR REPLACE TASK task_date_time_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
      INSERT INTO "date_time_table" VALUES('order_date',:value);
    END;
;

-- task_sales_table: Aggregates changes from other tables.
--   Runs only after updates are complete to all three other tables.
CREATE OR REPLACE TASK task_sales_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_customer_table, task_product_table, task_date_time_table
  AS
    BEGIN
      LET VALUE := (SELECT sales_order_id FROM ORDERS);
      JOIN CUSTOMER_TABLE ON orders.customer_id=customer_table.customer_id;
      INSERT INTO sales_table VALUES('sales_order_id',:value);
    END;
;

-- Example 6817
CREATE OR REPLACE TASK notify_finalizer
  USER_TASK_TIMEOUT_MS = 60000
  FINALIZE = task_root
AS
  DECLARE
    my_root_task_id STRING;
    my_start_time TIMESTAMP_LTZ;
    summary_json STRING;
    summary_html STRING;
  BEGIN
    --- Get root task ID
    my_root_task_id := (CALL SYSTEM$TASK_RUNTIME_INFO('CURRENT_ROOT_TASK_UUID'));
    --- Get root task scheduled time
    my_start_time := (CALL SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
    --- Combine all task run info into one JSON string
    summary_json := (SELECT get_task_graph_run_summary(:my_root_task_id, :my_start_time));
    --- Convert JSON into HTML table
    summary_html := (SELECT HTML_FROM_JSON_TASK_RUNS(:summary_json));

    --- Send HTML to email
    CALL SYSTEM$SEND_EMAIL(
        'email_notification',
        'admin@snowflake.com',
        'notification task run summary',
        :summary_html,
        'text/html');
    --- Set return value for finalizer
    CALL SYSTEM$SET_RETURN_VALUE('✅ Graph run summary sent.');
  END

CREATE OR REPLACE FUNCTION get_task_graph_run_summary(my_root_task_id STRING, my_start_time TIMESTAMP_LTZ)
  RETURNS STRING
AS
$$
  (SELECT
    ARRAY_AGG(OBJECT_CONSTRUCT(
      'task_name', name,
      'run_status', state,
      'return_value', return_value,
      'started', query_start_time,
      'duration', duration,
      'error_message', error_message
      )
    ) AS GRAPH_RUN_SUMMARY
  FROM
    (SELECT
      NAME,
      CASE
        WHEN STATE = 'SUCCEED' then '🟢 Succeeded'
        WHEN STATE = 'FAILED' then '🔴 Failed'
        WHEN STATE = 'SKIPPED' then '🔵 Skipped'
        WHEN STATE = 'CANCELLED' then '🔘 Cancelled'
      END AS STATE,
      RETURN_VALUE,
      TO_VARCHAR(QUERY_START_TIME, 'YYYY-MM-DD HH24:MI:SS') AS QUERY_START_TIME,
      CONCAT(TIMESTAMPDIFF('seconds', query_start_time, completed_time),
        ' s') AS DURATION,
      ERROR_MESSAGE
    FROM
      TABLE(my-database.information_schema.task_history(
        ROOT_TASK_ID => my_root_task_id ::STRING,
        SCHEDULED_TIME_RANGE_START => my_start_time,
        SCHEDULED_TIME_RANGE_END => current_timestamp()
      ))
    ORDER BY
      SCHEDULED_TIME)
  )::STRING
$$
;

CREATE OR REPLACE FUNCTION HTML_FROM_JSON_TASK_RUNS(JSON_DATA STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  HANDLER = 'GENERATE_HTML_TABLE'
AS
$$
  IMPORT JSON

  def GENERATE_HTML_TABLE(JSON_DATA):
    column_widths = ["320px", "120px", "400px", "160px", "80px", "480px"]

  DATA = json.loads(JSON_DATA)
  HTML = f"""
    <img src="https://example.com/logo.jpg"
      alt="Company logo" height="72">
    <p><strong>Task Graph Run Summary</strong>
      <br>Sign in to Snowsight to see more details.</p>
    <table border="1" style="border-color:#DEE3EA"
      cellpadding="5" cellspacing="0">
      <thead>
        <tr>
        """
        headers = ["Task name", "Run status", "Return value", "Started", "Duration", "Error message"]
        for i, header in enumerate(headers):
            HTML += f'<th scope="col" style="text-align:left;
            width: {column_widths[i]}">{header.capitalize()}</th>'

        HTML +="""
        </tr>
      </thead>
      <tbody>
        """
        for ROW_DATA in DATA:
          HTML += "<tr>"
          for header in headers:
            key = header.replace(" ", "_").upper()
            CELL_DATA = ROW_DATA.get(key, "")
            HTML += f'<td style="text-align:left;
            width: {column_widths[headers.index(header)]}">{CELL_DATA}</td>'
          HTML += "</tr>"
        HTML +="""
      </tbody>
    </table>
    """
  return HTML
$$
;

-- Example 6818
-- Configuration
-- By default, the notebook creates the objects in the public schema.
-- USE DATABASE <database name>;
-- USE SCHEMA <schema name>;

-- 1. Set the default configurations.
--    Creates a root task ("task_a"), and sets the default configurations
--    used throughout the task graph.
--    Configurations include:
--    * Each task runs after one minute, with a 60-second timeout.
--    * If a task fails, retry it twice. if it fails twice,
--      the entire task graph is considered as failed.
--    * If the task graph fails consecutively three times, suspend the task.
--    * Other environment values are set.

CREATE OR REPLACE TASK task_a
  SCHEDULE = '1 MINUTE'
  USER_TASK_TIMEOUT_MS = 60000
  TASK_AUTO_RETRY_ATTEMPTS = 2
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3
  AS
    BEGIN
      CALL SYSTEM$SET_RETURN_VALUE('task a successful');
    END;
;

-- 2. Use a runtime reflection variable.
--    Creates a child task ("task_b").
--    By design, this example fails the first time it runs, because
--    it writes to a table ("demo_table") that doesn’t exist.
CREATE OR REPLACE TASK task_b
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$TASK_RUNTIME_INFO('current_task_name'));
      INSERT INTO demo_table VALUES('task b name',:VALUE);
    END;
;

-- 3. Get a task graph configuration value.
--    Creates the child task ("task_c").
--    By design, this example fails the first time it runs, because
--    the predecessor task ("task_b") fails.
CREATE OR REPLACE TASK task_c
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_b
  AS
    BEGIN
      CALL SYSTEM$GET_TASK_GRAPH_CONFIG('path');
      LET VALUE := (SELECT SYSTEM$GET_TASK_GRAPH_CONFIG('path'));
      INSERT INTO demo_table VALUES('task c path',:value);
    END;
;

-- 4. Get a value from a predecessor.
--    Creates the child task ("task_d").
--    By design, this example fails the first time it runs, because
--    the predecessor task ("task_c") fails.
CREATE OR REPLACE TASK task_d
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_c
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$GET_PREDECESSOR_RETURN_VALUE('TASK_A'));
      INSERT INTO demo_table VALUES('task d: predecessor return value', :value);
    END;
;

-- 5. Create the finalizer task ("task_f"), which creates the missing demo table.
--    After the finalizer completes, the task should automatically retry
--    (see task_a: task_auto_retry_attempts).
--    On retry, task_b, task_c, and task_d should complete successfully.
CREATE OR REPLACE TASK task_f
  USER_TASK_TIMEOUT_MS = 60000
  FINALIZE = task_a
  AS
    BEGIN
      CREATE TABLE IF NOT EXISTS demo_table(NAME VARCHAR, VALUE VARCHAR);
    END;
;

-- 6. Resume the finalizer. Upon creation, tasks start in a suspended state.
--    Use this command to resume the finalizer.
ALTER TASK task_f RESUME;
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE('task_a');

-- 7. Query the task history
SELECT
    name, state, attempt_number, scheduled_from
  FROM
    TABLE(information_schema.task_history(task_name=> 'task_b'))
  LIMIT 5;
;

-- 8. Suspend the task graph to stop incurring costs
--    Note: To stop the task graph, you only need to suspend the root task
--    (task_a). Child tasks don’t run unless the root task is run.
--    If any child tasks are running, they have a limited duration
--    and will end soon.
ALTER TASK task_a SUSPEND;
DROP TABLE demo_table;

-- 9. Check tasks during execution (optional)
--    Run this command to query the demo table during execution
--    to check which tasks have run.
SELECT * FROM demo_table;

-- 10. Demo reset (optional)
--     Run this command to remove the demo table.
--     This causes task_b to fail during its first run.
--     After the task graph retries, task_b will succeed.
DROP TABLE demo_table;

-- Example 6819
SYSTEM$GET_PREVIEW_ACCESS_STATUS()

-- Example 6820
+--------------------------------------------+
| SYSTEM$GET_PREVIEW_ACCESS_STATUS()         |
+--------------------------------------------+
| Preview access is ENABLED for this account |
+--------------------------------------------+

-- Example 6821
+---------------------------------------------+
| SYSTEM$GET_PREVIEW_ACCESS_STATUS()          |
|---------------------------------------------|
| Preview access is DISABLED for this account |
+---------------------------------------------+

-- Example 6822
SELECT SYSTEM$GET_PREVIEW_ACCESS_STATUS();

-- Example 6823
SYSTEM$GET_PRIVATELINK( '<aws_id>' , '<federated_token>' )

-- Example 6824
SYSTEM$GET_PRIVATELINK( '<private-endpoint-resource-id>' , '<federated_token>' )

-- Example 6825
aws sts get-federation-token --name sam

-- Example 6826
az account get-access-token --subscription <SubscriptionID>

-- Example 6827
az account list --output table

-- Example 6828
Name     CloudName   SubscriptionId                        State    IsDefault
-------  ----------  ------------------------------------  -------  ----------
MyCloud  AzureCloud  13c...                                Enabled  True

-- Example 6829
use role accountadmin;

select SYSTEM$GET_PRIVATELINK(
    '185...',
    '{
      "Credentials": {
          "AccessKeyId": "ASI...",
          "SecretAccessKey": "enw...",
          "SessionToken": "Fwo...",
          "Expiration": "2021-01-07T19:06:23+00:00"
      },
      "FederatedUser": {
          "FederatedUserId": "185...:sam",
          "Arn": "arn:aws:sts::185...:federated-user/sam"
      },
      "PackedPolicySize": 0
  }'
  );

-- Example 6830
use role accountadmin;

select SYSTEM$GET_PRIVATELINK(
  '/subscriptions/26d.../resourcegroups/sf-1/providers/microsoft.network/privateendpoints/test-self-service',
  'eyJ...');

-- Example 6831
SYSTEM$GET_PRIVATELINK_AUTHORIZED_ENDPOINTS()

-- Example 6832
use role accountadmin;
select system$get_privatelink_authorized_endpoints();

-- Example 6833
select
  value: endpointId
from
  table(
    flatten(
      input => parse_json(system$get_privatelink_authorized_endpoints())
    )
  );

-- Example 6834
+------------------+
| VALUE:ENDPOINTID |
+------------------+
| "123456789012"   |
+------------------+

-- Example 6835
SYSTEM$GET_PRIVATELINK_CONFIG()

-- Example 6836
{
  "regionless-snowsight-privatelink-url": "<privatelink_org_snowsight_url>",
  "privatelink-account-name": "<account_identifier>",
  "privatelink-connection-ocsp-urls": "<client_redirect_ocsp_url_list>",
  "snowsight-privatelink-url": "<privatelink_region_snowsight_url>",
  "privatelink-internal-stage": "<privatelink_stage_endpoint>",
  "privatelink-account-url": "<privatelink_account_url>",
  "privatelink-connection-urls": "<privatelink_connection_url_list>",
  "regionless-privatelink-account-url": "<privatelink_org_account_url>",
  "privatelink-ocsp-url": "<privatelink_ocsp_url>",
  "privatelink-vpce-id": "<aws_vpce_id>",
  "privatelink-account-principal": "<aws_principal_arn>",
  "regionless-privatelink-ocsp-url": "<privatelink_org_ocsp_url>",
  "app-service-privatelink-url": "<privatelink_streamlit_url>"
}

-- Example 6837
{
  "regionless-snowsight-privatelink-url": "<privatelink_org_snowsight_url>",
  "privatelink-account-name": "<account_identifier>",
  "privatelink-connection-ocsp-urls": "<client_redirect_ocsp_url_list>",
  "snowsight-privatelink-url": "<privatelink_region_snowsight_url>",
  "privatelink-internal-stage": "<privatelink_stage_endpoint>",
  "privatelink-account-url":"<privatelink_account_url>",
  "privatelink-connection-urls": "<privatelink_connection_url_list>",
  "regionless-privatelink-account-url": "<privatelink_org_account_url>",
  "privatelink-ocsp-url": "<privatelink_ocsp_url>",
  "privatelink-pls-id": "<azure_privatelink_service_id>",
  "regionless-privatelink-ocsp-url": "<privatelink_org_ocsp_url>"
}

-- Example 6838
{
  "regionless-snowsight-privatelink-url": "<privatelink_org_snowsight_url>",
  "privatelink-account-name": "<account_identifier>",
  "privatelink-connection-ocsp-urls": "<client_redirect_ocsp_url_list>",
  "snowsight-privatelink-url": "<privatelink_region_snowsight_url>",
  "privatelink-account-url": "<privatelink_account_url>",
  "privatelink-connection-urls": "<privatelink_connection_url_list>",
  "regionless-privatelink-account-url": "<privatelink_org_account_url>",
  "privatelink-ocsp-url": "<privatelink_ocsp_url>",
  "privatelink-gcp-service-attachment": "<snowflake_service_endpoint>",
  "regionless-privatelink-ocsp-url": "<privatelink_org_ocsp_url>"
}

-- Example 6839
SELECT SYSTEM$GET_PRIVATELINK_CONFIG();

-- Example 6840
select key, value from table(flatten(input=>parse_json(SYSTEM$GET_PRIVATELINK_CONFIG())));

+--------------------------------------+--------------------------------------+
| KEY                                  | VALUE                                |
+--------------------------------------+--------------------------------------+
| regionless-snowsight-privatelink-url | "<privatelink_org_snowsight_url>"    |
|--------------------------------------+--------------------------------------|
| privatelink-account-name             | "<account_identifier>"               |
|--------------------------------------+--------------------------------------|
| privatelink-connection-ocsp-urls     | "<client_redirect_ocsp_url_list>"    |
|--------------------------------------+--------------------------------------|
| snowsight-privatelink-url            | "<privatelink_region_snowsight_url>" |
|--------------------------------------+--------------------------------------|
| privatelink-internal-stage           | "<privatelink_stage_endpoint>"       |
|--------------------------------------+--------------------------------------|
| privatelink-account-url              | "<privatelink_account_url>"          |
|--------------------------------------+--------------------------------------|
| privatelink-connection-urls          | "<privatelink_connection_url_list>"  |
|--------------------------------------+--------------------------------------|
| privatelink-pls-id                   | "<azure_private_link_service_id>"    |
|--------------------------------------+--------------------------------------|
| regionless-privatelink-account-url   | "<privatelink_org_account_url>"      |
|--------------------------------------+--------------------------------------|
| privatelink-ocsp-url                 | "<privatelink_ocsp_url>"             |
|--------------------------------------+--------------------------------------|
| regionless-privatelink-ocsp-url      | "<privatelink_org_ocsp_url>"         |
+--------------------------------------+--------------------------------------+

-- Example 6841
SYSTEM$GET_PRIVATELINK_ENDPOINT_REGISTRATIONS()

-- Example 6842
use role accountadmin;

SELECT SYSTEM$GET_PRIVATELINK_ENDPOINT_REGISTRATIONS();

-- Example 6843
[
  {
    "consumerEndpointId": "148896251...",
    "consumerEndpointType": "Aws Id",
    "pinnedConsumerEndpointId": "vpce-0be92fc5953c0...",
    "providerServiceEndpoint": "vpce-svc-0dcda6d2e9d14..."
  }
]

-- Example 6844
use role accountadmin;

SELECT SYSTEM$GET_PRIVATELINK_ENDPOINT_REGISTRATIONS();

-- Example 6845
[
  {
    "consumerEndpointId": "/subscriptions/a92a429f-83ba-4249.../..../snowflake-private-link",
    "consumerEndpointType": "Azure Endpoint Connection Id",
    "pinnedConsumerEndpointId": "184549...",
    "providerServiceEndpoint": "sf-pvlinksvc-azcanadacentral.70f..."
  }
]

-- Example 6846
SYSTEM$GET_PRIVATELINK_ENDPOINTS_INFO()

-- Example 6847
SELECT SYSTEM$GET_PRIVATELINK_ENDPOINTS_INFO();

-- Example 6848
[
  {
    "provider_service_name": "com.amazonaws.us-west-2.s3",
    "snowflake_endpoint_name": "vpce-123456789012abcdea",
    "endpoint_state": "CREATED",
    "host": "*.s3.us-west-2.amazonaws.com",
    "status": "Available"
  },
  ...
]

-- Example 6849
SELECT SYSTEM$GET_PRIVATELINK_ENDPOINTS_INFO();

-- Example 6850
[
     {
        "provider_resource_id": "/subscriptions/11111111-2222-3333-4444-5555555555/...",
        "subresource": "sqlServer",
        "snowflake_resource_id": "/subscriptions/fa57a1f0-b4e6-4847-9c00-95f39520f...",
        "host": "testdb.database.windows.net",
        "endpoint_state": "CREATED",
        "status": "Approved",
     }
  ]

-- Example 6851
SYSTEM$GET_REFERENCED_OBJECT_ID_HASH('<reference_name>'[, '<alias>'])

-- Example 6852
SYSTEM$GET_RESULTSET_STATUS( <resultset_name> )

-- Example 6853
EXECUTE IMMEDIATE $$
DECLARE
  status2 VARCHAR DEFAULT 'invalid';
BEGIN
  LET res RESULTSET := ASYNC (SELECT SYSTEM$WAIT(3));
  LET status VARCHAR := SYSTEM$GET_RESULTSET_STATUS(res);

  AWAIT res;
  status2 := SYSTEM$GET_RESULTSET_STATUS(res);
  RETURN [status, status2];
END;
$$;

-- Example 6854
+------------------+
| GET_QUERY_STATUS |
+------------------+
| [                |
|   "RUNNING",     |
|   "SUCCESS"      |
| ]                |
+------------------+

-- Example 6855
SYSTEM$GET_SERVICE_DNS_DOMAIN( <schema_name> )

-- Example 6856
SELECT SYSTEM$GET_SERVICE_DNS_DOMAIN('DATA_SCHEMA');
SELECT SYSTEM$GET_SERVICE_DNS_DOMAIN('TUTORIAL_DB.DATA_SCHEMA');

-- Example 6857
+----------------------------------------------+
| SYSTEM$GET_SERVICE_DNS_DOMAIN('DATA_SCHEMA') |
|----------------------------------------------|
| k3m6.svc.spcs.internal                       |
+----------------------------------------------+

-- Example 6858
SYSTEM$GET_SERVICE_LOGS( <service_name>, <instance_id>, <container_name>
   [, <number_of_most_recent_lines> ] [, <retrieve_previous_logs> ])

-- Example 6859
SELECT SYSTEM$GET_SERVICE_LOGS('TUTORIAL_DB.data_schema.echo_service', 0, 'echo', 10);

-- Example 6860
SELECT value AS log_line
  FROM TABLE(
    SPLIT_TO_TABLE(SYSTEM$GET_SERVICE_LOGS('echo_service', 0, 'echo'), '\n')
  )

-- Example 6861
SELECT value AS log_line
  FROM TABLE(
   SPLIT_TO_TABLE(SYSTEM$GET_SERVICE_LOGS('echo_service', '0', 'echo'), '\n')
  )
  WHERE (CONTAINS(log_line, '06/Jun/2023 02:44:'))
  ORDER BY log_line;

-- Example 6862
+-----------------------------------------------------------------------------------------------------+
| LOG_LINE                                                                                            |
|-----------------------------------------------------------------------------------------------------|
| 10.16.9.193 - - [06/Jun/2023 02:44:04] "GET /healthcheck HTTP/1.1" 200 -                            |
| 10.16.9.193 - - [06/Jun/2023 02:44:09] "GET /healthcheck HTTP/1.1" 200 -                            |
| 10.16.9.193 - - [06/Jun/2023 02:44:14] "GET /healthcheck HTTP/1.1" 200 -                            |
+-----------------------------------------------------------------------------------------------------+

-- Example 6863
SELECT SYSTEM$GET_SERVICE_LOGS('TUTORIAL_DB.data_schema.echo_service', 0, 'echo', 10, true);

-- Example 6864
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   FROM SPECIFICATION $$
   spec:
     containers:
     - name: echo
       image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:tutorial
       readinessProbe:
         port: 8000
         path: /healthcheck
     endpoints:
     - name: echoendpoint
       port: 8000
       public: true
   $$;

-- Example 6865
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM @tutorial_stage
  SPECIFICATION_FILE='echo_spec.yaml';

-- Example 6866
EXECUTE JOB SERVICE
   IN COMPUTE POOL tutorial_compute_pool
   NAME = example_job_service
   FROM SPECIFICATION $$
   spec:
     container:
     - name: main
       image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
       env:
         SNOWFLAKE_WAREHOUSE: tutorial_warehouse
       args:
       - "--query=select current_time() as time,'hello'"
       - "--result_table=results"
   $$;

-- Example 6867
EXECUTE JOB SERVICE
   IN COMPUTE POOL tutorial_compute_pool
   NAME = example_job_service
   ASYNC = TRUE
   FROM SPECIFICATION $$
   ...
   $$;

-- Example 6868
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME = example_job_service
  FROM @tutorial_stage
  SPECIFICATION_FILE='my_job_spec.yaml';

-- Example 6869
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

-- Example 6870
CREATE SERVICE echo_service
    IN COMPUTE POOL tutorial_compute_pool
    FROM @STAGE SPECIFICATION_TEMPLATE_FILE='echo.yaml'
    USING (tag_name=>'latest');

-- Example 6871
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

-- Example 6872
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

-- Example 6873
USING( var_name=>var_value, [var_name=>var_value, ... ] );

-- Example 6874
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

-- Example 6875
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

-- Example 6876
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

-- Example 6877
spec:
 containers:
 - name: echo
   image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
   env:
     SERVER_PORT: 8000
     CHARACTER_NAME: Bob
   …

-- Example 6878
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

-- Example 6879
spec:
  container:
  - name: main
    image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
    env:
      SNOWFLAKE_WAREHOUSE: tutorial_warehouse
    args:
    - "--query=select current_time() as time,'hello'"
    - "--result_table=results"

-- Example 6880
spec:
  container:
  - name: main
    image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
    env:
      SNOWFLAKE_WAREHOUSE: tutorial_warehouse
    args: {{ARGS}}
  $$
  USING (ARGS=$$["--query=select current_time() as time,'hello'", "--result_table=results"]$$ );

-- Example 6881
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   FROM @tutorial_stage
   SPECIFICATION_FILE='echo_spec.yaml'
   MIN_INSTANCES=2
   MAX_INSTANCES=4;

