-- Example 22959
...
  ST_CONTAINS(
    g1,
    TO_GEOGRAPHY('MULTIPOINT((0 0), (1 1))'))

-- Example 22960
...
  ST_WITHIN(
   TO_GEOGRAPHY('{"type" : "MultiPoint","coordinates" : [[-122.30, 37.55], [-122.20, 47.61]]}'),
   g1)

-- Example 22961
...
  ST_WITHIN(
    g1,
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'))

-- Example 22962
...
  ST_COVERS(
    TO_GEOGRAPHY('POLYGON((-1 -1, -1 4, 4 4, 4 -1, -1 -1))'),
    g1)

-- Example 22963
...
  ST_COVERS(
    g1,
    TO_GEOGRAPHY('POINT(0 0)'))

-- Example 22964
...
  ST_COVEREDBY(
    TO_GEOGRAPHY('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))'),
    g1)

-- Example 22965
...
  ST_COVEREDBY(
    g1,
    TO_GEOGRAPHY('POINT(-122.35 37.55)'))

-- Example 22966
...
  ST_DWITHIN(
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    g1,
    100000)

-- Example 22967
...
  ST_DWITHIN(
    g1,
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    100000)

-- Example 22968
...
  ST_INTERSECTS(
    g1,
    ST_GEOGRAPHYFROMWKT('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'))

-- Example 22969
...
  ST_INTERSECTS(
    ST_GEOGFROMTEXT('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    g1)

-- Example 22970
...
  ST_CONTAINS(
    ST_GEOGRAPHYFROMEWKT('POLYGON((-74.17 40.64, -74.1796875 40.58, -74.09 40.58, -74.09 40.64, -74.17 40.64))'),
    g1)

-- Example 22971
...
  ST_WITHIN(
    ST_GEOGRAPHYFROMWKB('01010000006666666666965EC06666666666C64240'),
    g1)

-- Example 22972
...
  ST_COVERS(
    g1,
    ST_MAKEPOINT(0.2, 0.8))

-- Example 22973
...
  ST_INTERSECTS(
    g1,
    ST_MAKELINE(
      TO_GEOGRAPHY('MULTIPOINT((0 0), (1 1))'),
      TO_GEOGRAPHY('POINT(0.8 0.2)')))

-- Example 22974
...
  ST_INTERSECTS(
    ST_POLYGON(
      TO_GEOGRAPHY('SRID=4326;LINESTRING(0.0 0.0, 1.0 0.0, 1.0 2.0, 0.0 2.0, 0.0 0.0)')),
    g1)

-- Example 22975
...
  ST_WITHIN(
    g1,
    TRY_TO_GEOGRAPHY('POLYGON((-1 -1, -1 4, 4 4, 4 -1, -1 -1))'))

-- Example 22976
...
  ST_COVERS(
    g1,
    ST_GEOGPOINTFROMGEOHASH('s00'))

-- Example 22977
SELECT APPROX_COUNT_DISTINCT(column1) FROM table1;

-- Example 22978
SELECT COUNT(DISTINCT c1), COUNT(DISTINCT c2) FROM test_table;

-- Example 22979
CREATE OR REPLACE TABLE search_optimization_collation_demo (
  en_ci_col VARCHAR COLLATE 'en-ci',
  utf_8_col VARCHAR COLLATE 'utf8');

INSERT INTO search_optimization_collation_demo VALUES (
  'test_collation_1',
  'test_collation_2');

-- Example 22980
ALTER TABLE search_optimization_collation_demo
  ADD SEARCH OPTIMIZATION ON EQUALITY(en_ci_col, utf_8_col);

-- Example 22981
SELECT *
  FROM search_optimization_collation_demo
  WHERE utf_8_col = 'test_collation_2';

-- Example 22982
SELECT *
  FROM search_optimization_collation_demo
  WHERE utf_8_col COLLATE 'de-ci' = 'test_collation_2';

-- Example 22983
SELECT *
  FROM search_optimization_collation_demo
  WHERE utf_8_col = 'test_collation_2' COLLATE 'de-ci';

-- Example 22984
-- Supported predicate
-- (where the string '2020-01-01' is implicitly cast to a date)
WHERE timestamp1 = '2020-01-01';

-- Supported predicate
-- (where the string '2020-01-01' is explicitly cast to a date)
WHERE timestamp1 = '2020-01-01'::date;

-- Example 22985
-- Unsupported predicate
-- (where values in a VARCHAR column are cast to DATE)
WHERE to_date(varchar_column) = '2020-01-01';

-- Example 22986
-- Supported predicate
-- (where values in a numeric column are cast to a string)
WHERE cast(numeric_column as varchar) = '2'

-- Example 22987
CREATE OR REPLACE FUNCTION addone(i int)
  RETURNS int
  LANGUAGE python
  RUNTIME_VERSION = '3.8'
  HANDLER = 'addone_py'
  AS
    $$
    def addone_py(i):
      return i+1
    $$;

-- Example 22988
CREATE OR REPLACE FUNCTION add_one(i int)
  RETURNS int
  LANGUAGE java
  CALLED ON NULL INPUT
  HANDLER = 'TestFunc.addOne'
  TARGET_PATH = '@~/testfunc.jar'
  AS
    'class TestFunc {
      public static int addOne(int i) {
        return i+1;
      }
    }';

-- Example 22989
CREATE OR REPLACE TASK IF NOT EXISTS my_task2
  AFTER my_task1
  AS
    SELECT addone(SYSTEM$GET_PREDECESSOR_RETURN_VALUE());

-- Example 22990
CREATE OR REPLACE TASK IF NOT EXISTS my_task2
  AFTER my_task1
  AS
    SELECT add_one(SYSTEM$GET_PREDECESSOR_RETURN_VALUE());

-- Example 22991
CREATE OR REPLACE PROCEDURE filterByRole(tableName VARCHAR, role VARCHAR)
  RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'filter_by_role'
  AS
    $$
    from snowflake.snowpark.functions import col

    def filter_by_role(session, table_name, role):
      df = session.table(table_name)
      return df.filter(col("role") == role)
    $$;

-- Example 22992
CREATE OR REPLACE PROCEDURE filter_by_role(table_name VARCHAR, role VARCHAR)
  RETURNS TABLE()
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'FilterClass.filterByRole'
  AS
    $$
    import com.snowflake.snowpark_java.*;

    public class FilterClass {
      public DataFrame filterByRole(Session session, String tableName, String role) {
        DataFrame table = session.table(tableName);
        DataFrame filteredRows = table.filter(Functions.col("role").equal_to(Functions.lit(role)));
        return filteredRows;
      }
    }
    $$;

-- Example 22993
CREATE OR REPLACE TASK IF NOT EXISTS my_task2
  AFTER my_task1
  AS
    CALL filterByRole(SYSTEM$GET_PREDECESSOR_RETURN_VALUE(), 'dev');

-- Example 22994
CREATE OR REPLACE TASK IF NOT EXISTS my_task2
  AFTER my_task1
  AS
    CALL filter_by_role(SYSTEM$GET_PREDECESSOR_RETURN_VALUE(), 'dev');

-- Example 22995
CREATE OR REPLACE TASK IF NOT EXISTS task2
  SCHEDULE = '1 minute'
  AS
    $$
    print(Task completed successfully.)
    $$
  ;

-- Example 22996
SHOW PARAMETERS LIKE 'USER_TASK_TIMEOUT_MS' IN TASK <task_name>;

-- Example 22997
CREATE OR REPLACE PROCEDURE myproc(from_table STRING, to_table STRING, count INT)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'run'
as
$$
def run(session, from_table, to_table, count):
  session.table(from_table).limit(count).write.save_as_table(to_table)
  return "SUCCESS"
$$;

-- Example 22998
CALL myproc('table_a', 'table_b', 5);

-- Example 22999
SELECT *
FROM snowflake.account_usage.task_versions
WHERE ROOT_TASK_ID = 'afb36ccc-. . .-b746f3bf555d' AND GRAPH_VERSION = 3;

-- Example 23000
SELECT
task_history.* rename state AS task_run_state,
task_versions.state AS task_state,
task_versions.graph_version_created_on,
task_versions.warehouse_name,
task_versions.comment,
task_versions.schedule,
task_versions.predecessors,
task_versions.allow_overlapping_execution,
task_versions.error_integration
FROM snowflake.account_usage.task_history
JOIN snowflake.account_usage.task_versions using (root_task_id, graph_version)
WHERE task_history.ROOT_TASK_ID = 'afb36ccc-. . .-b746f3bf555d'

-- Example 23001
CREATE TASK <name>
  [...]
  ERROR_INTEGRATION = <integration_name>
  AS <sql>

-- Example 23002
CREATE TASK mytask
  SCHEDULE = '5 MINUTE'
  ERROR_INTEGRATION = my_notification_int
  AS
  INSERT INTO mytable(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 23003
ALTER TASK <name> SET ERROR_INTEGRATION = <integration_name>;

-- Example 23004
ALTER TASK mytask SET ERROR_INTEGRATION = my_notification_int;

-- Example 23005
{\"version\":\"1.0\",\"messageId\":\"3ff1eff0-7ad7-493c-9552-c0307087e0c6\",\"messageType\":\"USER_TASK_FAILED\",\"timestamp\":\"2021-11-11T19:46:39.648Z\",\"accountName\":\"AWS_UTEN_DPO_ACC\",\"taskName\":\"AWS_UTEN_DPO_DB.AWS_UTEN_SC.UTEN_AWS_TK1\",\"taskId\":\"01a03962-2b57-889e-0000-000000000001\",\"rootTaskName\":\"AWS_UTEN_DPO_DB.AWS_UTEN_SC.UTEN_AWS_TK1\",\"rootTaskId\":\"01a03962-2b57-889e-0000-000000000001\",\"messages\":[{\"runId\":\"2021-11-11T19:46:23.826Z\",\"scheduledTime\":\"2021-11-11T19:46:23.826Z\",\"queryStartTime\":\"2021-11-11T19:46:24.879Z\",\"completedTime\":\"null\",\"queryId\":\"01a03962-0300-0002-0000-0000000034d8\",\"errorCode\":\"000630\",\"errorMessage\":\"Statement reached its statement or warehouse timeout of 10 second(s) and was canceled.\"}]}

-- Example 23006
SELECT start_time,
  warehouse_name,
  credits_used_compute
FROM snowflake.account_usage.warehouse_metering_history
WHERE start_time >= DATEADD(day, -m, CURRENT_TIMESTAMP())
  AND warehouse_id > 0  -- Skip pseudo-VWs such as "CLOUD_SERVICES_ONLY"
ORDER BY 1 DESC, 2;

-- by hour
SELECT DATE_PART('HOUR', start_time) AS start_hour,
  warehouse_name,
  AVG(credits_used_compute) AS credits_used_compute_avg
FROM snowflake.account_usage.warehouse_metering_history
WHERE start_time >= DATEADD(day, -m, CURRENT_TIMESTAMP())
  AND warehouse_id > 0  -- Skip pseudo-VWs such as "CLOUD_SERVICES_ONLY"
GROUP BY 1, 2
ORDER BY 1, 2;

-- Example 23007
-- Credits used (all time = past year)
SELECT warehouse_name,
  SUM(credits_used_compute) AS credits_used_compute_sum
FROM snowflake.account_usage.warehouse_metering_history
GROUP BY 1
ORDER BY 2 DESC;

-- Credits used (past N days/weeks/months)
SELECT warehouse_name,
  SUM(credits_used_compute) AS credits_used_compute_sum
FROM snowflake.account_usage.warehouse_metering_history
WHERE start_time >= DATEADD(day, -m, CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 DESC;

-- Example 23008
WITH cte_date_wh AS (
  SELECT TO_DATE(start_time) AS start_date,
    warehouse_name,
    SUM(credits_used) AS credits_used_date_wh
  FROM snowflake.account_usage.warehouse_metering_history
  GROUP BY start_date, warehouse_name
)

SELECT start_date,
  warehouse_name,
  credits_used_date_wh,
  AVG(credits_used_date_wh) OVER (PARTITION BY warehouse_name ORDER BY start_date ROWS m PRECEDING) AS credits_used_m_day_avg,
  100.0*((credits_used_date_wh / credits_used_m_day_avg) - 1) AS pct_over_to_m_day_average
FROM cte_date_wh
  QUALIFY credits_used_date_wh > 100  -- Minimum N=100 credits
    AND pct_over_to_m_day_average >= 0.5  -- Minimum 50% increase over past m day average
ORDER BY pct_over_to_m_day_average DESC;

-- Example 23009
SELECT
    usage_date,
    credits_used_cloud_services,
    credits_adjustment_cloud_services,
    credits_used_cloud_services + credits_adjustment_cloud_services AS billed_cloud_services
FROM snowflake.account_usage.metering_daily_history
WHERE usage_date >= DATEADD(month,-1,CURRENT_TIMESTAMP())
    AND credits_used_cloud_services > 0
ORDER BY 4 DESC;

-- Example 23010
SELECT query_type,
  SUM(credits_used_cloud_services) AS cs_credits,
  COUNT(1) num_queries
FROM snowflake.account_usage.query_history
WHERE true
  AND start_time >= TIMESTAMPADD(day, -1, CURRENT_TIMESTAMP)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Example 23011
SELECT *
FROM snowflake.account_usage.query_history
WHERE true
  AND start_time >= TIMESTAMPADD(day, -1, CURRENT_TIMESTAMP)
  AND query_type = 'COPY'
ORDER BY credits_used_cloud_services DESC
LIMIT 10;

-- Example 23012
SELECT
  warehouse_name,
  SUM(credits_used) AS credits_used,
  SUM(credits_used_cloud_services) AS credits_used_cloud_services,
  SUM(credits_used_cloud_services)/SUM(credits_used) AS percent_cloud_services
FROM snowflake.account_usage.warehouse_metering_history
WHERE TO_DATE(start_time) >= DATEADD(month,-1,CURRENT_TIMESTAMP())
    AND credits_used_cloud_services > 0
GROUP BY 1
ORDER BY 4 DESC;

-- Example 23013
SELECT *
FROM snowflake.account_usage.query_history
WHERE true
  AND start_time >= TIMESTAMPADD(minute, -60, CURRENT_TIMESTAMP)
ORDER BY compilation_time DESC,
  execution_time DESC,
  list_external_files_time DESC,
  queued_overload_time DESC,
  credits_used_cloud_services DESC
LIMIT 10;

-- Example 23014
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.automatic_clustering_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 23015
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.automatic_clustering_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
      AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 23016
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.search_optimization_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 23017
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.search_optimization_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week', date),
  AVG(credits_used) as avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 23018
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.materialized_view_refresh_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 23019
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.materialized_view_refresh_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 23020
SELECT warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE start_time >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1
  ORDER BY 2 DESC;

-- Example 23021
SELECT TO_DATE(last_load_time) AS load_date,
  status,
  table_catalog_name AS database_name,
  table_schema_name AS schema_name,
  table_name,
  CASE
    WHEN pipe_name IS NULL THEN 'COPY'
    ELSE 'SNOWPIPE'
  END AS ingest_method,
  SUM(row_count) AS row_count,
  SUM(row_parsed) AS rows_parsed,
  AVG(file_size) AS avg_file_size_bytes,
  SUM(file_size) AS total_file_size_bytes,
  SUM(file_size)/POWER(1024,1) AS total_file_size_kb,
  SUM(file_size)/POWER(1024,2) AS total_file_size_mb,
  SUM(file_size)/POWER(1024,3) AS total_file_size_gb,
  SUM(file_size)/POWER(1024,4) AS total_file_size_tb
FROM snowflake.account_usage.copy_history
GROUP BY 1,2,3,4,5,6
ORDER BY 3,4,5,1,2;

-- Example 23022
SELECT TO_DATE(start_time) AS date,
  pipe_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.pipe_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 23023
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.pipe_usage_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 23024
SELECT start_time,
  end_time,
  SUM(credits_used) AS total_credits,
  name,
  IFF(CONTAINS(name,':'),'streaming client cost', 'streaming compute cost') AS streaming_cost_type
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE service_type ='SNOWPIPE_STREAMING'
GROUP BY ALL;

-- Example 23025
SELECT
    start_time,
    end_time,
    alert_id,
    alert_name,
    credits_used,
    schema_id,
    schema_name,
    database_id,
    database_name
  FROM SNOWFLAKE.ACCOUNT_USAGE.serverless_alert_history
  ORDER BY start_time, alert_id;

