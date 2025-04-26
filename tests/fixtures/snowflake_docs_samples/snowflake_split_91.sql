-- Example 6078
SNOWFLAKE.CORTEX.SENTIMENT(<text>)

-- Example 6079
SELECT SNOWFLAKE.CORTEX.SENTIMENT(review_content), review_content FROM reviews LIMIT 10;

-- Example 6080
SEQ1( [0|1] )

SEQ2( [0|1] )

SEQ4( [0|1] )

SEQ8( [0|1] )

-- Example 6081
SELECT seq8() FROM table(generator(rowCount => 5));

+--------+
| SEQ8() |
|--------|
|      0 |
|      1 |
|      2 |
|      3 |
|      4 |
+--------+

-- Example 6082
SELECT * FROM (SELECT seq2(0), seq1(1) FROM table(generator(rowCount => 132))) ORDER BY seq2(0) LIMIT 7 OFFSET 125;

+---------+---------+
| SEQ2(0) | SEQ1(1) |
|---------+---------|
|     125 |     125 |
|     126 |     126 |
|     127 |     127 |
|     128 |    -128 |
|     129 |    -127 |
|     130 |    -126 |
|     131 |    -125 |
+---------+---------+

-- Example 6083
SELECT ROW_NUMBER() OVER (ORDER BY seq4()) 
    FROM TABLE(generator(rowcount => 10));
+-------------------------------------+
| ROW_NUMBER() OVER (ORDER BY SEQ4()) |
|-------------------------------------|
|                                   1 |
|                                   2 |
|                                   3 |
|                                   4 |
|                                   5 |
|                                   6 |
|                                   7 |
|                                   8 |
|                                   9 |
|                                  10 |
+-------------------------------------+

-- Example 6084
SERVERLESS_ALERT_HISTORY(
  [ DATE_RANGE_START => <constant_expr> ]
  [ , DATE_RANGE_END => <constant_expr> ]
  [ , ALERT_NAME => '<string>' ] )

-- Example 6085
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.SERVERLESS_ALERT_HISTORY(
    DATE_RANGE_START=>'2024-10-08 19:00:00.000 -0700',
    DATE_RANGE_END=>'2024-10-08 20:00:00.000 -0700'));

-- Example 6086
+-------------------------------+-------------------------------+------------+--------------+
| START_TIME                    | END_TIME                      | ALERT_NAME | CREDITS_USED |
|-------------------------------+-------------------------------+------------+--------------|
| 2024-10-08 04:16:22.000 -0700 | 2024-10-08 05:16:22.000 -0700 | A1         |  0.000286714 |
| 2024-10-08 05:16:22.000 -0700 | 2024-10-08 06:16:22.000 -0700 | A1         |  0.007001568 |
+-------------------------------+-------------------------------+------------+--------------+

-- Example 6087
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.SERVERLESS_ALERT_HISTORY(
    DATE_RANGE_START=>DATEADD(H, -12, CURRENT_TIMESTAMP)));

-- Example 6088
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.SERVERLESS_ALERT_HISTORY(
    DATE_RANGE_START=>DATEADD(D, -7, CURRENT_DATE),
    DATE_RANGE_END=>CURRENT_DATE));

-- Example 6089
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.SERVERLESS_ALERT_HISTORY(
    DATE_RANGE_START=>DATEADD(D, -7, CURRENT_DATE),
    DATE_RANGE_END=>CURRENT_DATE,
    ALERT_NAME=>'my_database.my_schema.my_alert'));

-- Example 6090
USE ROLE ACCOUNTADMIN;

CREATE ROLE my_alert_role;

-- Example 6091
GRANT EXECUTE ALERT ON ACCOUNT TO ROLE my_alert_role;

-- Example 6092
GRANT EXECUTE MANAGED ALERT ON ACCOUNT TO ROLE my_alert_role;

-- Example 6093
GRANT ROLE my_alert_role TO USER my_user;

-- Example 6094
GRANT CREATE ALERT ON SCHEMA my_schema TO ROLE my_alert_role;
GRANT USAGE ON SCHEMA my_schema TO ROLE my_alert_role;

-- Example 6095
GRANT USAGE ON DATABASE my_database TO ROLE my_alert_role;

-- Example 6096
GRANT USAGE ON WAREHOUSE my_warehouse TO ROLE my_alert_role;

-- Example 6097
CREATE OR REPLACE ALERT my_alert
  WAREHOUSE = mywarehouse
  SCHEDULE = '1 minute'
  IF( EXISTS(
    SELECT gauge_value FROM gauge WHERE gauge_value>200))
  THEN
    INSERT INTO gauge_value_exceeded_history VALUES (current_timestamp());

-- Example 6098
CREATE OR REPLACE ALERT my_alert
  SCHEDULE = '1 minute'
  IF( EXISTS(
    SELECT gauge_value FROM gauge WHERE gauge_value>200))
  THEN
    INSERT INTO gauge_value_exceeded_history VALUES (current_timestamp());

-- Example 6099
ALTER ALERT my_alert RESUME;

-- Example 6100
SHOW PARAMETERS LIKE 'EVENT_TABLE' IN ACCOUNT;

-- Example 6101
+-------------+---------------------------+----------------------------+---------+-----------------------------------------+--------+
| key         | value                     | default                    | level   | description                             | type   |
|-------------+---------------------------+----------------------------+---------+-----------------------------------------+--------|
| EVENT_TABLE | my_db.my_schema.my_events | snowflake.telemetry.events | ACCOUNT | Event destination for the given target. | STRING |
+-------------+---------------------------+----------------------------+---------+-----------------------------------------+--------+

-- Example 6102
ALTER TABLE my_db.my_schema.my_events SET CHANGE_TRACKING = TRUE;

-- Example 6103
CREATE OR REPLACE ALERT my_alert
  WAREHOUSE = mywarehouse
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENTS
      WHERE
        resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
        record_type='EVENT' AND
        value:"state"='ERROR'
  ))
  THEN
    BEGIN
      LET result_str VARCHAR;
      (SELECT ARRAY_TO_STRING(ARRAY_ARG(name)::ARRAY, ',') INTO :result_str
        FROM (
          SELECT resource_attributes:"snow.executable.name"::VARCHAR name
            FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()))
            LIMIT 10
        )
      );
      CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
        SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(:result_str),
        '{"my_slack_integration": {}}'
      );
    END;

-- Example 6104
CREATE OR REPLACE ALERT my_alert
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENTS
      WHERE
        resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
        record_type='EVENT' AND
        value:"state"='ERROR'
  ))
  THEN
    BEGIN
      LET result_str VARCHAR;
      (SELECT ARRAY_TO_STRING(ARRAY_ARG(name)::ARRAY, ',') INTO :result_str
        FROM (
          SELECT resource_attributes:"snow.executable.name"::VARCHAR name
            FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()))
            LIMIT 10
        )
      );
      CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
        SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(:result_str),
        '{"my_slack_integration": {}}'
      );
    END;

-- Example 6105
ALTER ALERT my_alert RESUME;

-- Example 6106
<now> - <last_execution_of_the_alert>

-- Example 6107
GRANT DATABASE ROLE SNOWFLAKE.ALERT_VIEWER TO ROLE alert_role;

-- Example 6108
CREATE OR REPLACE ALERT alert_new_rows
  WAREHOUSE = my_warehouse
  SCHEDULE = '1 MINUTE'
  IF (EXISTS (
      SELECT *
      FROM my_table
      WHERE row_timestamp BETWEEN SNOWFLAKE.ALERT.LAST_SUCCESSFUL_SCHEDULED_TIME()
       AND SNOWFLAKE.ALERT.SCHEDULED_TIME()
  ))
  THEN CALL SYSTEM$SEND_EMAIL(...);

-- Example 6109
CREATE ALERT my_alert
  WAREHOUSE = my_warehouse
  SCHEDULE = '1 MINUTE'
  IF (EXISTS (
    SELECT * FROM my_source_table))
  THEN
    BEGIN
      LET condition_result_set RESULTSET :=
        (SELECT * FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID())));
      ...
    END;

-- Example 6110
EXECUTE ALERT my_alert;

-- Example 6111
ALTER ALERT my_alert SUSPEND;

-- Example 6112
ALTER ALERT my_alert RESUME;

-- Example 6113
ALTER ALERT my_alert SET WAREHOUSE = my_other_warehouse;

-- Example 6114
ALTER ALERT my_alert SET SCHEDULE = '2 minutes';

-- Example 6115
ALTER ALERT my_alert MODIFY CONDITION EXISTS (SELECT gauge_value FROM gauge WHERE gauge_value>300);

-- Example 6116
ALTER ALERT my_alert MODIFY ACTION CALL my_procedure();

-- Example 6117
DROP ALERT my_alert;

-- Example 6118
DROP ALERT IF EXISTS my_alert;

-- Example 6119
SHOW ALERTS;

-- Example 6120
DESC ALERT my_alert;

-- Example 6121
SELECT *
FROM
  TABLE(INFORMATION_SCHEMA.ALERT_HISTORY(
    SCHEDULED_TIME_RANGE_START
      =>dateadd('hour',-1,current_timestamp())))
ORDER BY SCHEDULED_TIME DESC;

-- Example 6122
GRANT MONITOR ON ALERT my_alert TO ROLE my_alert_role;

-- Example 6123
USE ROLE my_alert_role;

-- Example 6124
SELECT query_text FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
  WHERE query_text LIKE '%Some condition%'
    OR query_text LIKE '%Some action%'
  ORDER BY start_time DESC;

-- Example 6125
SERVERLESS_TASK_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [ , DATE_RANGE_END => <constant_expr> ]
      [ , TASK_NAME => '<string>' ] )

-- Example 6126
select *
  from table(information_schema.serverless_task_history(
    date_range_start=>'2021-10-08 19:00:00.000',
    date_range_end=>'2021-10-08 20:00:00.000'));

-- Example 6127
+-------------------------------+-------------------------------+-----------+--------------+
| START_TIME                    | END_TIME                      | TASK_NAME | CREDITS_USED |
|-------------------------------+-------------------------------+-----------+--------------|
| 2021-10-08 04:16:22.000 -0700 | 2021-10-08 05:16:22.000 -0700 | T1        |  0.000286714 |
| 2021-10-08 05:16:22.000 -0700 | 2021-10-08 06:16:22.000 -0700 | T1        |  0.007001568 |
+-------------------------------+-------------------------------+-----------+--------------+

-- Example 6128
select *
  from table(information_schema.serverless_task_history(
    date_range_start=>dateadd(H, -12, current_timestamp)));

-- Example 6129
select *
  from table(information_schema.serverless_task_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date));

-- Example 6130
select *
  from table(information_schema.serverless_task_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date,
    task_name=>'mydb.myschema.mytask'));

-- Example 6131
CREATE TASK SCHEDULED_T1 SCHEDULE='USING CRON 0 * * * * America/Los_Angeles'
TARGET_COMPLETION_INTERVAL='120 MINUTE' AS SELECT 1;

-- Example 6132
from datetime import timedelta
from snowflake.core.task import Cron, Task

tasks = root.databases["TEST_DB"].schemas["TEST_SCHEMA"].tasks

task = tasks.create(
    Task(
        name="SCHEDULED_T1",
        definition="SELECT 1",
        schedule=Cron("0 * * * *", "America/Los_Angeles"),
        target_completion_interval=timedelta(minutes=120),
    ),
)

-- Example 6133
CREATE TASK SCHEDULED_T2 SCHEDULE='USING CRON 0 * * * * UTC'
TARGET_COMPLETION_INTERVAL='10 MINUTE'
SERVERLESS_TASK_MAX_STATEMENT_SIZE='LARGE'
AS SELECT 1;

-- Example 6134
from datetime import timedelta
from snowflake.core.task import Cron, Task

tasks = root.databases["TEST_DB"].schemas["TEST_SCHEMA"].tasks

task = tasks.create(
    Task(
        name="SCHEDULED_T2",
        definition="SELECT 1",
        schedule=Cron("0 * * * *", "UTC"),
        target_completion_interval=timedelta(minutes=10),
        serverless_task_max_statement_size="LARGE",
    ),
)

-- Example 6135
CREATE TASK SCHEDULED_T3 SCHEDULE='USING CRON 0 0 * * * UTC'
TARGET_COMPLETION_INTERVAL='180 M'
SERVERLESS_TASK_MIN_STATEMENT_SIZE='MEDIUM' SERVERLESS_TASK_MAX_STATEMENT_SIZE='LARGE' AS SELECT 1;

-- Example 6136
from datetime import timedelta
from snowflake.core.task import Cron, Task

tasks = root.databases["TEST_DB"].schemas["TEST_SCHEMA"].tasks

task = tasks.create(
    Task(
        name="SCHEDULED_T3",
        definition="SELECT 1",
        schedule=Cron("0 0 * * *", "UTC"),
        target_completion_interval=timedelta(minutes=180),
        serverless_task_min_statement_size="MEDIUM",
        serverless_task_max_statement_size="LARGE",
    ),
)

-- Example 6137
CREATE TASK
  SCHEDULED_T4
  SCHEDULE='10 SECONDS'
SERVERLESS_TASK_MAX_STATEMENT_SIZE='LARGE' AS SELECT 1;

-- Example 6138
from datetime import timedelta
from snowflake.core.task import Cron, Task

tasks = root.databases["TEST_DB"].schemas["TEST_SCHEMA"].tasks

task = tasks.create(
    Task(
        name="SCHEDULED_T4",
        definition="SELECT 1",
        schedule=timedelta(seconds=10),),
        serverless_task_max_statement_size="LARGE",
    ),
)

-- Example 6139
ALTER TASK task SUSPEND;
ALTER TASK task UNSET SCHEDULE;
ALTER TASK task RESUME;

-- Example 6140
CREATE TASK my_task
  WHEN SYSTEM$STREAM_HAS_DATA('my_return_stream')
  OR   SYSTEM$STREAM_HAS_DATA('my_order_stream')
  WAREHOUSE = my_warehouse
  AS
    INSERT INTO customer_activity
    SELECT customer_id, return_total, return_date, ‘return’
    FROM my_return_stream
    UNION ALL
    SELECT customer_id, order_total, order_date, ‘order’
    FROM my_order_stream;

-- Example 6141
CREATE TASK triggeredTask
  WHEN SYSTEM$STREAM_HAS_DATA('orders_stream')
  TARGET_COMPLETION_INTERVAL='120 MINUTES'
  AS
    INSERT INTO completed_promotions
    SELECT order_id, order_total, order_time, promotion_id
    FROM orders_stream
    WHERE promotion_id IS NOT NULL;

-- Example 6142
SET num_credits = (SELECT SUM(credits_used)
  FROM TABLE(<database_name>.information_schema.serverless_task_history(
    date_range_start=>dateadd(D, -1, current_timestamp()),
    date_range_end=>dateadd(D, 1, current_timestamp()),
    task_name => '<task_name>')
    )
  );

-- Example 6143
SELECT start_time,
  end_time,
  task_id,
  task_name,
  credits_used,
  schema_id,
  schema_name,
  database_id,
  database_name
FROM snowflake.account_usage.serverless_task_history
ORDER BY start_time, task_id;

-- Example 6144
SELECT
 name,
 SUM(credits_used_compute) AS total_credits
FROM
  SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE
 service_type ILIKE '%SERVERLESS_TASK%'
 AND start_time >= '2024-12-01'
 AND end_time <= '2024-12-31'
GROUP BY
 name
ORDER BY
 name ASC;

