-- Example 2109
CALL snowflake.local.account_root_budget!SET_EMAIL_NOTIFICATIONS(
   'budgets_notification_integration',
   '<YOUR_EMAIL_ADDRESS>');

-- Example 2110
USE ROLE budget_owner;
USE SCHEMA budgets_db.budgets_schema;
USE WAREHOUSE na_finance_wh;

CREATE SNOWFLAKE.CORE.BUDGET na_finance_budget();

-- Example 2111
CALL na_finance_budget!SET_SPENDING_LIMIT(500);

-- Example 2112
CALL na_finance_budget!SET_EMAIL_NOTIFICATIONS('budgets_notification_integration',
                                               '<YOUR_EMAIL_ADDRESS>');

-- Example 2113
CALL na_finance_budget!ADD_RESOURCE(
  SYSTEM$REFERENCE('database', 'na_finance_db', 'SESSION', 'applybudget'));

CALL na_finance_budget!ADD_RESOURCE(
  SYSTEM$REFERENCE('warehouse', 'na_finance_wh', 'SESSION', 'applybudget'));

-- Example 2114
USE ROLE budget_owner;

GRANT SNOWFLAKE.CORE.BUDGET ROLE budgets_db.budgets_schema.na_finance_budget!ADMIN
  TO ROLE budget_admin;

-- Example 2115
USE ROLE budget_owner;

GRANT SNOWFLAKE.CORE.BUDGET ROLE budgets_db.budgets_schema.na_finance_budget!VIEWER
  TO ROLE budget_monitor;

-- Example 2116
USE ROLE account_budget_monitor;

CALL snowflake.local.account_root_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND => DATEADD('days', -7, CURRENT_TIMESTAMP()),
  TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 2117
USE ROLE account_budget_monitor;

CALL snowflake.local.account_root_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'SEARCH_OPTIMIZATION',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => DATEADD('day', -7, CURRENT_TIMESTAMP()),
   TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 2118
USE ROLE budget_monitor;

CALL budgets_db.budgets_schema.na_finance_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND => DATEADD('days', -7, CURRENT_TIMESTAMP()),
  TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 2119
USE ROLE budget_owner;

DROP SNOWFLAKE.CORE.BUDGET budgets_db.budgets_schema.na_finance_budget;

-- Example 2120
USE ROLE ACCOUNTADMIN;

DROP DATABASE na_finance_db;
DROP WAREHOUSE na_finance_wh;
DROP DATABASE budgets_db;

-- Example 2121
USE ROLE ACCOUNTADMIN;

DROP ROLE budget_monitor;
DROP ROLE budget_admin;
DROP ROLE budget_owner;

-- Example 2122
USE ROLE ACCOUNTADMIN;

DROP ROLE account_budget_monitor;
DROP ROLE account_budget_admin;

-- Example 2123
USE ROLE ACCOUNTADMIN;

DROP NOTIFICATION INTEGRATION budgets_notification_integration;

-- Example 2124
CREATE OR REPLACE DATABASE tutorial_log_trace_db;

-- Example 2125
CREATE OR REPLACE WAREHOUSE tutorial_log_trace_wh
  WAREHOUSE_TYPE = STANDARD
  WAREHOUSE_SIZE = XSMALL;

-- Example 2126
CREATE OR REPLACE EVENT TABLE tutorial_event_table;

-- Example 2127
USE ROLE ACCOUNTADMIN;

ALTER ACCOUNT SET EVENT_TABLE = tutorial_log_trace_db.public.tutorial_event_table;

-- Example 2128
ALTER SESSION SET LOG_LEVEL = INFO;

-- Example 2129
CREATE OR REPLACE FUNCTION log_trace_data()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
HANDLER = 'run'
AS $$
import logging
logger = logging.getLogger("tutorial_logger")

def run():
  logger.info("Logging from Python function.")
  return "SUCCESS"
$$;

-- Example 2130
SELECT log_trace_data();

-- Example 2131
--------------------
| LOG_TRACE_DATA() |
--------------------
| SUCCESS          |
--------------------

-- Example 2132
SELECT
  TIMESTAMP AS time,
  RESOURCE_ATTRIBUTES['snow.executable.name'] as executable,
  RECORD['severity_text'] AS severity,
  VALUE AS message
FROM
  tutorial_log_trace_db.public.tutorial_event_table
WHERE
  RECORD_TYPE = 'LOG'
  AND SCOPE['name'] = 'tutorial_logger';

-- Example 2133
-----------------------------------------------------------------------------------------------------------
| TIME                | EXECUTABLE                           | SEVERITY | MESSAGE                         |
-----------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "LOG_TRACE_DATA():VARCHAR(16777216)" | "INFO"   | "Logging from Python function." |
-----------------------------------------------------------------------------------------------------------

-- Example 2134
ALTER SESSION SET TRACE_LEVEL = ON_EVENT;

-- Example 2135
CREATE OR REPLACE FUNCTION log_trace_data()
RETURNS VARCHAR
LANGUAGE PYTHON
PACKAGES = ('snowflake-telemetry-python')
RUNTIME_VERSION = 3.9
HANDLER = 'run'
AS $$
import logging
logger = logging.getLogger("tutorial_logger")
from snowflake import telemetry

def run():
  telemetry.set_span_attribute("example.proc.run", "begin")
  telemetry.add_event("event_with_attributes", {"example.key1": "value1", "example.key2": "value2"})
  logger.info("Logging from Python function.")
  return "SUCCESS"
$$;

-- Example 2136
SELECT log_trace_data();

-- Example 2137
--------------------
| LOG_TRACE_DATA() |
--------------------
| SUCCESS          |
--------------------

-- Example 2138
SELECT
  TIMESTAMP AS time,
  RESOURCE_ATTRIBUTES['snow.executable.name'] AS handler_name,
  RECORD['name'] AS event_name,
  RECORD_ATTRIBUTES AS attributes
FROM
  tutorial_log_trace_db.public.tutorial_event_table
WHERE
  RECORD_TYPE = 'SPAN_EVENT'
  AND HANDLER_NAME LIKE 'LOG_TRACE_DATA%';

-- Example 2139
-----------------------------------------------------------------------------------------------------------------------------------------------------
| TIME                    | HANDLER_NAME                         | EVENT_NAME              | ATTRIBUTES                                             |
-----------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-05-10 20:49:35.080 | "LOG_TRACE_DATA():VARCHAR(16777216)" | "event_with_attributes" | { "example.key1": "value1", "example.key2": "value2" } |
-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 2140
SELECT *
   FROM samooha_by_snowflake_local_db.public.provider_activation_summary
   WHERE segment = 'Provider Snowflake Account';

-- Example 2141
DELETE FROM samooha_by_snowflake_local_db.public.provider_activation_summary
   WHERE segment = 'Provider Snowflake Account';

-- Example 2142
USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS dq_tutorial_role;

-- Example 2143
GRANT CREATE DATABASE ON ACCOUNT TO ROLE dq_tutorial_role;
GRANT EXECUTE DATA METRIC FUNCTION ON ACCOUNT TO ROLE dq_tutorial_role;
GRANT APPLICATION ROLE SNOWFLAKE.DATA_QUALITY_MONITORING_VIEWER TO ROLE dq_tutorial_role;
GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE dq_tutorial_role;
GRANT DATABASE ROLE SNOWFLAKE.DATA_METRIC_USER TO ROLE dq_tutorial_role;

-- Example 2144
CREATE WAREHOUSE IF NOT EXISTS dq_tutorial_wh;
GRANT USAGE ON WAREHOUSE dq_tutorial_wh TO ROLE dq_tutorial_role;

-- Example 2145
SHOW GRANTS TO ROLE dq_tutorial_role;

-- Example 2146
GRANT ROLE dq_tutorial_role TO ROLE SYSADMIN;
GRANT ROLE dq_tutorial_role TO USER jsmith;

-- Example 2147
USE ROLE dq_tutorial_role;
CREATE DATABASE IF NOT EXISTS dq_tutorial_db;
CREATE SCHEMA IF NOT EXISTS sch;

CREATE TABLE customers (
  account_number NUMBER(38,0),
  first_name VARCHAR(16777216),
  last_name VARCHAR(16777216),
  email VARCHAR(16777216),
  phone VARCHAR(16777216),
  created_at TIMESTAMP_NTZ(9),
  street VARCHAR(16777216),
  city VARCHAR(16777216),
  state VARCHAR(16777216),
  country VARCHAR(16777216),
  zip_code NUMBER(38,0)
);

-- Example 2148
USE WAREHOUSE dq_tutorial_wh;

INSERT INTO customers (account_number, city, country, email, first_name, last_name, phone, state, street, zip_code)
  VALUES (1589420, 'san francisco', 'usa', 'john.doe@', 'john', 'doe', 1234567890, null, null, null);

INSERT INTO customers (account_number, city, country, email, first_name, last_name, phone, state, street, zip_code)
  VALUES (8028387, 'san francisco', 'usa', 'bart.simpson@example.com', 'bart', 'simpson', 1012023030, null, 'market st', 94102);

INSERT INTO customers (account_number, city, country, email, first_name, last_name, phone, state, street, zip_code)
  VALUES
    (1589420, 'san francisco', 'usa', 'john.doe@example.com', 'john', 'doe', 1234567890, 'ca', 'concar dr', 94402),
    (2834123, 'san mateo', 'usa', 'jane.doe@example.com', 'jane', 'doe', 3641252911, 'ca', 'concar dr', 94402),
    (4829381, 'san mateo', 'usa', 'jim.doe@example.com', 'jim', 'doe', 3641252912, 'ca', 'concar dr', 94402),
    (9821802, 'san francisco', 'usa', 'susan.smith@example.com', 'susan', 'smith', 1234567891, 'ca', 'geary st', 94121),
    (8028387, 'san francisco', 'usa', 'bart.simpson@example.com', 'bart', 'simpson', 1012023030, 'ca', 'market st', 94102);

-- Example 2149
CREATE DATA METRIC FUNCTION IF NOT EXISTS
  invalid_email_count (ARG_T table(ARG_C1 STRING))
  RETURNS NUMBER AS
  'SELECT COUNT_IF(FALSE = (
    ARG_C1 REGEXP ''^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))
    FROM ARG_T';

-- Example 2150
ALTER TABLE customers SET DATA_METRIC_SCHEDULE = '5 MINUTE';

-- Example 2151
ALTER TABLE customers ADD DATA METRIC FUNCTION
  invalid_email_count ON (email);

-- Example 2152
SELECT * FROM TABLE(INFORMATION_SCHEMA.DATA_METRIC_FUNCTION_REFERENCES(
  REF_ENTITY_NAME => 'dq_tutorial_db.sch.customers',
  REF_ENTITY_DOMAIN => 'TABLE'));

-- Example 2153
SELECT scheduled_time, measurement_time, table_name, metric_name, value
FROM SNOWFLAKE.LOCAL.DATA_QUALITY_MONITORING_RESULTS
WHERE TRUE
AND METRIC_NAME = 'INVALID_EMAIL_COUNT'
AND METRIC_DATABASE = 'DQ_TUTORIAL_DB'
LIMIT 100;

-- Example 2154
ALTER TABLE customers DROP DATA METRIC FUNCTION
  invalid_email_count ON (email);

-- Example 2155
CREATE or REPLACE table dq_tutorial_db.sch.employeesTable (
  id NUMBER,
  name VARCHAR,
  last_name VARCHAR,
  email VARCHAR,
  zip_code NUMBER
 );

-- Example 2156
INSERT INTO dq_tutorial_db.sch.employeesTable (id, name, last_name, email, zip_code)
VALUES
  (8, 'John', 'Doe', 'johndoe@example.com', 12345),
  (23, '', 'Smith', 'smithj@example.com', 23456),
  (1, NULL, 'Taylor', 'taylorj@example.com', 34567),
  (99, 'Jane', 'Adams', 'jadams@example.com', 45678),
  (50, 'Alice', 'Brown', '', 56789),
  (51, NULL, 'Lee', 'lee@example.com', 67890),
  (234, 'Michael', '', 'michael@example.com', 78901),
  (56, 'Sara', 'Jones', 'sjones@example.com', 89012),
  (11, '', NULL, 'blanklast@example.com', 90123),
  (12, 'Tom', 'Harris', NULL, 10234);

-- Example 2157
SELECT snowflake.core.blank_count (SELECT name FROM dq_tutorial_db.sch.employeesTable)

-- Example 2158
SELECT *
  FROM TABLE(SYSTEM$DATA_METRIC_SCAN(
    REF_ENTITY_NAME  => 'dq_tutorial_db.sch.employeesTable',
    METRIC_NAME  => 'snowflake.core.blank_count',
    ARGUMENT_NAME => 'name'
   ));

-- Example 2159
+-----+-------+--------------+-----------------------+-----------+------- --+
| ID  | NAME  | LAST_NAME    | EMAIL                 | CREATEDAT | ZIP_CODE |
|-----+-------+--------------+-----------------------+----------------------|
| 23  |       |   Smith      | smith@example.com     | null      | 23456    |
| 11  |       |   null       | blanklast@example.com | null      | 90123    |
+-----+-------+--------------+-----------------------+-----------+----------+

-- Example 2160
UPDATE dq_tutorial_db.sch.employeesTable
  SET name = null
  WHERE dq_tutorial_db.sch.employeesTable.ID IN (
    select ID from table(system$data_metric_scan(
  REF_ENTITY_NAME => 'dq_tutorial_db.sch.employeesTable',
  METRIC_NAME => 'snowflake.core.blank_count',
  ARGUMENT_NAME => 'name'
  )));

-- Example 2161
SELECT snowflake.core.blank_count (SELECT name FROM dq_tutorial_db.sch.employeesTable)

-- Example 2162
USE ROLE dq_tutorial_role;
SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.DATA_QUALITY_MONITORING_USAGE_HISTORY
WHERE TRUE
AND START_TIME >= CURRENT_TIMESTAMP - INTERVAL '3 days'
LIMIT 100;

-- Example 2163
USE ROLE ACCOUNTADMIN;
DROP DATABASE dq_tutorial_db;
DROP WAREHOUSE dq_tutorial_wh;
DROP ROLE dq_tutorial_role;

-- Example 2164
SELECT query_id,
       query_text,
       start_time,
       end_time,
       warehouse_name,
       warehouse_size,
       eligible_query_acceleration_time,
       upper_limit_scale_factor,
       DATEDIFF(second, start_time, end_time) AS total_duration,
       eligible_query_acceleration_time / NULLIF(DATEDIFF(second, start_time, end_time), 0) AS eligible_time_ratio
FROM
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
WHERE
    start_time >= DATEADD(day, -30, CURRENT_TIMESTAMP())
    AND eligible_time_ratio <= 1.0
    AND total_duration BETWEEN 3 * 60 and 5 * 60
ORDER BY (eligible_time_ratio, upper_limit_scale_factor) DESC NULLS LAST
LIMIT 100;

-- Example 2165
SELECT d.d_year as "Year",
       i.i_brand_id as "Brand ID",
       i.i_brand as "Brand",
       SUM(ss_net_profit) as "Profit"
FROM   snowflake_sample_data.tpcds_sf10tcl.date_dim    d,
       snowflake_sample_data.tpcds_sf10tcl.store_sales s,
       snowflake_sample_data.tpcds_sf10tcl.item        i
WHERE  d.d_date_sk = s.ss_sold_date_sk
  AND s.ss_item_sk = i.i_item_sk
  AND i.i_manufact_id = 939
  AND d.d_moy = 12
GROUP BY d.d_year,
         i.i_brand,
         i.i_brand_id
ORDER BY 1, 4, 2
LIMIT 200;

-- Example 2166
CREATE WAREHOUSE noqas_wh WITH
  WAREHOUSE_SIZE='<warehouse_size>'
  ENABLE_QUERY_ACCELERATION = false
  INITIALLY_SUSPENDED = true
  AUTO_SUSPEND = 60;

CREATE WAREHOUSE qas_wh WITH
  WAREHOUSE_SIZE='<warehouse_size>'
  ENABLE_QUERY_ACCELERATION = true
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = <upper_limit_scale_factor>
  INITIALLY_SUSPENDED = true
  AUTO_SUSPEND = 60;

-- Example 2167
USE SCHEMA snowflake_sample_data.tpcds_sf10tcl;

-- Example 2168
USE WAREHOUSE noqas_wh;

-- Example 2169
SELECT LAST_QUERY_ID();

-- Example 2170
USE WAREHOUSE qas_wh;

-- Example 2171
SELECT LAST_QUERY_ID();

-- Example 2172
SELECT query_id,
       query_text,
       warehouse_name,
       total_elapsed_time
FROM TABLE(snowflake.information_schema.query_history())
WHERE query_id IN ('<non_accelerated_query_id>', '<accelerated_query_id>')
ORDER BY start_time;

-- Example 2173
SELECT start_time,
       end_time,
       warehouse_name,
       credits_used,
       credits_used_compute,
       credits_used_cloud_services,
       (credits_used + credits_used_compute + credits_used_cloud_services) AS credits_used_total
  FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.WAREHOUSE_METERING_HISTORY(
    DATE_RANGE_START => DATEADD('days', -1, CURRENT_DATE()),
    WAREHOUSE_NAME => 'NOQAS_WH'
  ));

-- Example 2174
SELECT start_time,
       end_time,
       warehouse_name,
       credits_used,
       credits_used_compute,
       credits_used_cloud_services,
       (credits_used + credits_used_compute + credits_used_cloud_services) AS credits_used_total
  FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.WAREHOUSE_METERING_HISTORY(
    DATE_RANGE_START => DATEADD('days', -1, CURRENT_DATE()),
    WAREHOUSE_NAME => 'QAS_WH'
  ));

-- Example 2175
SELECT start_time,
         end_time,
         warehouse_name,
         credits_used,
         num_files_scanned,
         num_bytes_scanned
    FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.QUERY_ACCELERATION_HISTORY(
      DATE_RANGE_START => DATEADD('days', -1, CURRENT_DATE()),
      WAREHOUSE_NAME => 'QAS_WH'
));

-- Example 2176
SELECT warehouse_name, count(query_id) as num_eligible_queries, MAX(upper_limit_scale_factor)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD(month, -1, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY num_eligible_queries DESC;

