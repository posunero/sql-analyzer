-- Example 7217
SYSTEM$WAIT( amount [ , time_unit ] )

-- Example 7218
CALL SYSTEM$WAIT(10);

-------------------+
    SYSTEM$WAIT    |
-------------------+
 waited 10 seconds |
-------------------+

-- Example 7219
CALL SYSTEM$WAIT(2, 'MINUTES');

-------------------+
    SYSTEM$WAIT    |
-------------------+
 waited 2 minutes  |
-------------------+

-- Example 7220
SYSTEM$WAIT_FOR_SERVICES( <seconds_to_pause>, '<service_name>' [, ...] )

-- Example 7221
SELECT SYSTEM$WAIT_FOR_SERVICES(600, 'service-name-1', 'service-name-2', 'service-name-3');

-- Example 7222
SYSTEM$WHITELIST()

-- Example 7223
SELECT SYSTEM$WHITELIST();

-- Example 7224
[
  {"type":"SNOWFLAKE_DEPLOYMENT", "host":"xy12345.snowflakecomputing.com",                 "port":443},
  {"type":"STAGE",                "host":"sfc-customer-stage.s3.us-west-2.amazonaws.com",  "port":443},
  ...
  {"type":"SNOWSQL_REPO",         "host":"sfc-repo.snowflakecomputing.com",                "port":443},
  ...
  {"type":"OCSP_CACHE",           "host":"ocsp.snowflakecomputing.com",                    "port":80}
  {"type":"OCSP_RESPONDER",       "host":"o.ss2.us",                                       "port":80},
  ...
]

-- Example 7225
SELECT t.VALUE:type::VARCHAR as type,
       t.VALUE:host::VARCHAR as host,
       t.VALUE:port as port
FROM TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$WHITELIST()))) AS t;

-- Example 7226
+-----------------------+---------------------------------------------------+------+
| TYPE                  | HOST                                              | PORT |
|-----------------------+---------------------------------------------------+------|
| SNOWFLAKE_DEPLOYMENT  | xy12345.snowflakecomputing.com                    | 443  |
| STAGE                 | sfc-customer-stage.s3.us-west-2.amazonaws.com     | 443  |
  ...
| SNOWSQL_REPO          | sfc-repo.snowflakecomputing.com                   | 443  |
  ...
| OCSP_CACHE            | ocsp.snowflakecomputing.com                       | 80   |
| OCSP_RESPONDER        | ocsp.sca1b.amazontrust.com                        | 80   |
  ...
+-----------------------+---------------------------------------------------+------+

-- Example 7227
SYSTEM$WHITELIST_PRIVATELINK()

-- Example 7228
SELECT SYSTEM$WHITELIST_PRIVATELINK();

-- Example 7229
[
  {"type":"SNOWFLAKE_DEPLOYMENT", "host":"xy12345.us-west-2.privatelink.snowflakecomputing.com","port":443},
  {"type":"STAGE",                "host":"sfc-ss-ds2-customer-stage.s3.us-west-2.amazonaws.com","port":443},
  ...
  {"type":"SNOWSQL_REPO",         "host":"sfc-repo.snowflakecomputing.com",                     "port":443},
  ...
  {"type":"OUT_OF_BAND_TELEMETRY","host":"client-telemetry.snowflakecomputing.com","port":443},
  {"type":"OCSP_CACHE",           "host":"ocsp.station00752.us-west-2.privatelink.snowflakecomputing.com","port":80}
]

-- Example 7230
SELECT t.VALUE:type::VARCHAR as type,
       t.VALUE:host::VARCHAR as host,
       t.VALUE:port as port
FROM TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$WHITELIST_PRIVATELINK()))) AS t;

-- Example 7231
+-----------------------+---------------------------------------------------+------+
| TYPE                  | HOST                                              | PORT |
+-----------------------+---------------------------------------------------+------+
| SNOWFLAKE_DEPLOYMENT  | xy12345.snowflakecomputing.com                    | 443  |
| STAGE                 | sfc-customer-stage.s3.us-west-2.amazonaws.com     | 443  |
  ...
| SNOWSQL_REPO          | sfc-repo.snowflakecomputing.com                   | 443  |
  ...
| OCSP_CACHE            | ocsp.snowflakecomputing.com                       | 80   |
  ...
+-----------------------+---------------------------------------------------+------+

-- Example 7232
SYSTIMESTAMP()

-- Example 7233
SELECT SYSTIMESTAMP();

-- Example 7234
+--------------------------+
| SYSTIMESTAMP()           |
|--------------------------|
| 2024-04-17 15:49:34.0800 |
+--------------------------+

-- Example 7235
TAG_REFERENCES( '<object_name>' , '<object_domain>' )

-- Example 7236
select *
  from table(my_db.information_schema.tag_references('my_table', 'table'));

-- Example 7237
select *
  from table(my_db.information_schema.tag_references('my_table.result', 'COLUMN'));

-- Example 7238
TAG_REFERENCES_ALL_COLUMNS( '<object_name>' , '<object_domain>' )

-- Example 7239
select *
  from table(my_db.information_schema.tag_references_all_columns('my_table', 'table'));

-- Example 7240
TAG_REFERENCES_WITH_LINEAGE( '<name>' )

-- Example 7241
select *
  from table(snowflake.account_usage.tag_references_with_lineage('MY_DB.MY_SCHEMA.COST_CENTER'));

-- Example 7242
USE ROLE ACCOUNTADMIN;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE SYSADMIN;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE customrole1;

-- Example 7243
USE ROLE customrole1;

SELECT database_name, database_owner FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES;

-- Example 7244
ALTER SESSION SET TIMEZONE = UTC;

-- Example 7245
USE ROLE ACCOUNTADMIN;

USE SCHEMA snowflake.account_usage;

-- Example 7246
select user_name,
       count(*) as failed_logins,
       avg(seconds_between_login_attempts) as average_seconds_between_login_attempts
from (
      select user_name,
             timediff(seconds, event_timestamp, lead(event_timestamp)
                 over(partition by user_name order by event_timestamp)) as seconds_between_login_attempts
      from login_history
      where event_timestamp > date_trunc(month, current_date)
      and is_success = 'NO'
     )
group by 1
order by 3;

-- Example 7247
select user_name,
       sum(iff(is_success = 'NO', 1, 0)) as failed_logins,
       count(*) as logins,
       sum(iff(is_success = 'NO', 1, 0)) / nullif(count(*), 0) as login_failure_rate
from login_history
where event_timestamp > date_trunc(month, current_date)
group by 1
order by 4 desc;

-- Example 7248
select reported_client_type,
       user_name,
       sum(iff(is_success = 'NO', 1, 0)) as failed_logins,
       count(*) as logins,
       sum(iff(is_success = 'NO', 1, 0)) / nullif(count(*), 0) as login_failure_rate
from login_history
where event_timestamp > date_trunc(month, current_date)
group by 1,2
order by 5 desc;

-- Example 7249
WITH
params AS (
SELECT
    CURRENT_WAREHOUSE() AS warehouse_name,
    '2021-11-01' AS time_from,
    '2021-11-02' AS time_to
),

jobs AS (
SELECT
    query_id,
    time_slice(start_time::timestamp_ntz, 15, 'minute','start') as interval_start,
    qh.warehouse_name,
    database_name,
    query_type,
    total_elapsed_time,
    compilation_time AS compilation_and_scheduling_time,
    (queued_provisioning_time + queued_repair_time + queued_overload_time) AS queued_time,
    transaction_blocked_time,
    execution_time
FROM snowflake.account_usage.query_history qh, params
WHERE
    qh.warehouse_name = params.warehouse_name
AND start_time >= params.time_from
AND start_time <= params.time_to
AND execution_status = 'SUCCESS'
AND query_type IN ('SELECT','UPDATE','INSERT','MERGE','DELETE')
),

interval_stats AS (
SELECT
    query_type,
    interval_start,
    COUNT(DISTINCT query_id) AS numjobs,
    MEDIAN(total_elapsed_time)/1000 AS p50_total_duration,
    (percentile_cont(0.95) within group (order by total_elapsed_time))/1000 AS p95_total_duration,
    SUM(total_elapsed_time)/1000 AS sum_total_duration,
    SUM(compilation_and_scheduling_time)/1000 AS sum_compilation_and_scheduling_time,
    SUM(queued_time)/1000 AS sum_queued_time,
    SUM(transaction_blocked_time)/1000 AS sum_transaction_blocked_time,
    SUM(execution_time)/1000 AS sum_execution_time,
    ROUND(sum_compilation_and_scheduling_time/sum_total_duration,2) AS compilation_and_scheduling_ratio,
    ROUND(sum_queued_time/sum_total_duration,2) AS queued_ratio,
    ROUND(sum_transaction_blocked_time/sum_total_duration,2) AS blocked_ratio,
    ROUND(sum_execution_time/sum_total_duration,2) AS execution_ratio,
    ROUND(sum_total_duration/numjobs,2) AS total_duration_perjob,
    ROUND(sum_compilation_and_scheduling_time/numjobs,2) AS compilation_and_scheduling_perjob,
    ROUND(sum_queued_time/numjobs,2) AS queued_perjob,
    ROUND(sum_transaction_blocked_time/numjobs,2) AS blocked_perjob,
    ROUND(sum_execution_time/numjobs,2) AS execution_perjob
FROM jobs
GROUP BY 1,2
ORDER BY 1,2
)
SELECT * FROM interval_stats;

-- Example 7250
select warehouse_name,
       sum(credits_used) as total_credits_used
from warehouse_metering_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

-- Example 7251
select start_time::date as usage_date,
       warehouse_name,
       sum(credits_used) as total_credits_used
from warehouse_metering_history
where start_time >= date_trunc(month, current_date)
group by 1,2
order by 2,1;

-- Example 7252
select date_trunc(month, usage_date) as usage_month
  , avg(storage_bytes + stage_bytes + failsafe_bytes) / power(1024, 4) as billable_tb
from storage_usage
group by 1
order by 1;

-- Example 7253
select count(*) as number_of_jobs
from query_history
where start_time >= date_trunc(month, current_date);

-- Example 7254
select warehouse_name,
       count(*) as number_of_jobs
from query_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

-- Example 7255
select user_name,
       avg(execution_time) as average_execution_time
from query_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

-- Example 7256
select query_type,
       warehouse_size,
       avg(execution_time) as average_execution_time
from query_history
where start_time >= date_trunc(month, current_date)
group by 1,2
order by 3 desc;

-- Example 7257
select l.user_name,
       l.event_timestamp as login_time,
       l.client_ip,
       l.reported_client_type,
       l.first_authentication_factor,
       l.second_authentication_factor,
       count(q.query_id)
from snowflake.account_usage.login_history l
join snowflake.account_usage.sessions s on l.event_id = s.login_event_id
join snowflake.account_usage.query_history q on q.session_id = s.session_id
group by 1,2,3,4,5,6
order by l.user_name
;

-- Example 7258
TAN( <real_expr> )

-- Example 7259
SELECT TAN(0), TAN(PI()/3), TAN(RADIANS(90));
--------+-------------+----------------------+
 TAN(0) | TAN(PI()/3) |   TAN(RADIANS(90))   |
--------+-------------+----------------------+
 0      | 1.732050808 | 1.63312393531954e+16 |
--------+-------------+----------------------+

-- Example 7260
TANH( <real_expr> )

-- Example 7261
SELECT TANH(1.5);

--------------+
  TANH(1.5)   |
--------------+
 0.9051482536 |
--------------+

-- Example 7262
TASK_DEPENDENTS(
      TASK_NAME => '<string>'
      [, RECURSIVE => <Boolean> ] )

-- Example 7263
| created_on | name | database_name | schema_name | owner | comment | warehouse | schedule | predecessors | state | definition | condition |

-- Example 7264
select *
  from table(information_schema.task_dependents(task_name => 'mydb.myschema.mytask', recursive => false));

-- Example 7265
CREATE TASK SCHEDULED_T1 SCHEDULE='USING CRON 0 * * * * America/Los_Angeles'
TARGET_COMPLETION_INTERVAL='120 MINUTE' AS SELECT 1;

-- Example 7266
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

-- Example 7267
CREATE TASK SCHEDULED_T2 SCHEDULE='USING CRON 0 * * * * UTC'
TARGET_COMPLETION_INTERVAL='10 MINUTE'
SERVERLESS_TASK_MAX_STATEMENT_SIZE='LARGE'
AS SELECT 1;

-- Example 7268
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

-- Example 7269
CREATE TASK SCHEDULED_T3 SCHEDULE='USING CRON 0 0 * * * UTC'
TARGET_COMPLETION_INTERVAL='180 M'
SERVERLESS_TASK_MIN_STATEMENT_SIZE='MEDIUM' SERVERLESS_TASK_MAX_STATEMENT_SIZE='LARGE' AS SELECT 1;

-- Example 7270
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

-- Example 7271
CREATE TASK
  SCHEDULED_T4
  SCHEDULE='10 SECONDS'
SERVERLESS_TASK_MAX_STATEMENT_SIZE='LARGE' AS SELECT 1;

-- Example 7272
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

-- Example 7273
ALTER TASK task SUSPEND;
ALTER TASK task UNSET SCHEDULE;
ALTER TASK task RESUME;

-- Example 7274
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

-- Example 7275
CREATE TASK triggeredTask
  WHEN SYSTEM$STREAM_HAS_DATA('orders_stream')
  TARGET_COMPLETION_INTERVAL='120 MINUTES'
  AS
    INSERT INTO completed_promotions
    SELECT order_id, order_total, order_time, promotion_id
    FROM orders_stream
    WHERE promotion_id IS NOT NULL;

-- Example 7276
SET num_credits = (SELECT SUM(credits_used)
  FROM TABLE(<database_name>.information_schema.serverless_task_history(
    date_range_start=>dateadd(D, -1, current_timestamp()),
    date_range_end=>dateadd(D, 1, current_timestamp()),
    task_name => '<task_name>')
    )
  );

-- Example 7277
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

-- Example 7278
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

-- Example 7279
SELECT
  usage_date AS date,
  account_name,
  SUM(usage) AS credits,
  currency,
  SUM(usage_in_currency) AS usage_in_currency
FROM
  SNOWFLAKE.ORGANIZATION_USAGE.USAGE_IN_CURRENCY_DAILY
WHERE
  USAGE_TYPE ILIKE '%SERVERLESS_TASK%'
GROUP BY
  usage_date, account_name, currency
ORDER BY
  USAGE_DATE DESC;

-- Example 7280
USE SYSADMIN;

CREATE ROLE warehouse_task_creation
  COMMENT = 'This role can create user-managed tasks.';

-- Example 7281
from snowflake.core.role import Role

root.session.use_role("SYSADMIN")

my_role = Role(
    name="warehouse_task_creation",
    comment="This role can create user-managed tasks."
)
root.roles.create(my_role)

-- Example 7282
USE ACCOUNTADMIN;

GRANT CREATE TASK
  ON SCHEMA schema1
  TO ROLE warehouse_task_creation;

-- Example 7283
from snowflake.core.role import Securable

root.session.use_role("ACCOUNTADMIN")

root.roles['warehouse_task_creation'].grant_privileges(
    privileges=["CREATE TASK"], securable_type="schema", securable=Securable(name='schema1')
)

