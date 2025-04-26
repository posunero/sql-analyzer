-- Example 10968
ALTER WAREHOUSE so_warehouse SET
  RESOURCE_CONSTRAINT = 'MEMORY_16X_x86';

-- Example 10969
SHOW [ TERSE ] TABLES [ HISTORY ] [ LIKE '<pattern>' ]
                                  [ IN
                                        {
                                          ACCOUNT                                         |

                                          DATABASE                                        |
                                          DATABASE <database_name>                        |

                                          SCHEMA                                          |
                                          SCHEMA <schema_name>                            |
                                          <schema_name>

                                          APPLICATION <application_name>                  |
                                          APPLICATION PACKAGE <application_package_name>  |
                                        }
                                  ]
                                  [ STARTS WITH '<name_string>' ]
                                  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 10970
SHOW TERSE TABLES IN tpch_sf1 STARTS WITH 'LINE';

-- Example 10971
+-------------------------------+----------+-------+-----------------------+-------------+
| created_on                    | name     | kind  | database_name         | schema_name |
|-------------------------------+----------+-------+-----------------------+-------------|
| 2016-07-08 13:41:59.960 -0700 | LINEITEM | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
+-------------------------------+----------+-------+-----------------------+-------------+

-- Example 10972
SHOW TERSE TABLES LIKE '%PART%' IN tpch_sf1;

-- Example 10973
+-------------------------------+-----------+-------+-----------------------+-------------+
| created_on                    | name      | kind  | database_name         | schema_name |
|-------------------------------+-----------+-------+-----------------------+-------------|
| 2016-07-08 13:41:59.960 -0700 | JPART     | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | JPARTSUPP | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | PART      | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | PARTSUPP  | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
+-------------------------------+-----------+-------+-----------------------+-------------+

-- Example 10974
SHOW TERSE TABLES IN tpch_sf1 LIMIT 3 FROM 'J';

-- Example 10975
+-------------------------------+-----------+-------+-----------------------+-------------+
| created_on                    | name      | kind  | database_name         | schema_name |
|-------------------------------+-----------+-------+-----------------------+-------------|
| 2016-07-08 13:41:59.960 -0700 | JCUSTOMER | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | JLINEITEM | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | JNATION   | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
+-------------------------------+-----------+-------+-----------------------+-------------+

-- Example 10976
CREATE OR REPLACE TABLE test_show_tables_history(c1 NUMBER);

DROP TABLE test_show_tables_history;

-- Example 10977
SHOW TABLES HISTORY LIKE 'test_show_tables_history';

-- Example 10978
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

-- Example 10979
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

-- Example 10980
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

-- Example 10981
SELECT
    usage_date,
    credits_used_cloud_services,
    credits_adjustment_cloud_services,
    credits_used_cloud_services + credits_adjustment_cloud_services AS billed_cloud_services
FROM snowflake.account_usage.metering_daily_history
WHERE usage_date >= DATEADD(month,-1,CURRENT_TIMESTAMP())
    AND credits_used_cloud_services > 0
ORDER BY 4 DESC;

-- Example 10982
SELECT query_type,
  SUM(credits_used_cloud_services) AS cs_credits,
  COUNT(1) num_queries
FROM snowflake.account_usage.query_history
WHERE true
  AND start_time >= TIMESTAMPADD(day, -1, CURRENT_TIMESTAMP)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Example 10983
SELECT *
FROM snowflake.account_usage.query_history
WHERE true
  AND start_time >= TIMESTAMPADD(day, -1, CURRENT_TIMESTAMP)
  AND query_type = 'COPY'
ORDER BY credits_used_cloud_services DESC
LIMIT 10;

-- Example 10984
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

-- Example 10985
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

-- Example 10986
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.automatic_clustering_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 10987
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

-- Example 10988
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.search_optimization_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 10989
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

-- Example 10990
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.materialized_view_refresh_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 10991
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

-- Example 10992
SELECT warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE start_time >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1
  ORDER BY 2 DESC;

-- Example 10993
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

-- Example 10994
SELECT TO_DATE(start_time) AS date,
  pipe_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.pipe_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 10995
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

-- Example 10996
SELECT start_time,
  end_time,
  SUM(credits_used) AS total_credits,
  name,
  IFF(CONTAINS(name,':'),'streaming client cost', 'streaming compute cost') AS streaming_cost_type
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE service_type ='SNOWPIPE_STREAMING'
GROUP BY ALL;

-- Example 10997
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

-- Example 10998
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

-- Example 10999
SELECT start_time, 
  end_time, 
  replication_group_name, 
  credits_used, 
  bytes_transferred
FROM snowflake.account_usage.replication_group_usage_history
WHERE start_time >= DATE_TRUNC('month', CURRENT_DATE());

-- Example 11000
SELECT TO_DATE(start_time) AS date,
  database_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.database_replication_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 11001
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.database_replication_usage_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 11002
-- This Is Approximate Credit Consumption By Client Application
WITH
  client_hour_execution_cte AS (
    SELECT
      CASE
        WHEN client_application_id LIKE 'Go %' THEN 'Go'
        WHEN client_application_id LIKE 'Snowflake UI %' THEN 'Snowflake UI'
        WHEN client_application_id LIKE 'SnowSQL %' THEN 'SnowSQL'
        WHEN client_application_id LIKE 'JDBC %' THEN 'JDBC'
        WHEN client_application_id LIKE 'PythonConnector %' THEN 'Python'
        WHEN client_application_id LIKE 'ODBC %' THEN 'ODBC'
        ELSE 'NOT YET MAPPED: ' || CLIENT_APPLICATION_ID
      END AS client_application_name,
      warehouse_name,
      DATE_TRUNC('hour',start_time) AS start_time_hour,
      SUM(execution_time)  AS client_hour_execution_time
    FROM snowflake.account_usage.query_history qh
      JOIN snowflake.account_usage.sessions se
        ON se.session_id = qh.session_id
    WHERE warehouse_name IS NOT NULL
      AND execution_time > 0
      AND start_time > DATEADD(month,-1,CURRENT_TIMESTAMP())
    GROUP BY 1,2,3
  ),
  hour_execution_cte AS (
    SELECT start_time_hour,
      warehouse_name,
      SUM(client_hour_execution_time) AS hour_execution_time
    FROM client_hour_execution_cte
    GROUP BY 1,2
  ),
  approximate_credits AS (
    SELECT A.client_application_name,
      C.warehouse_name,
      (A.client_hour_execution_time/B.hour_execution_time)*C.credits_used AS approximate_credits_used
    FROM client_hour_execution_cte A
      JOIN hour_execution_cte B
        ON A.start_time_hour = B.start_time_hour and B.warehouse_name = A.warehouse_name
      JOIN snowflake.account_usage.warehouse_metering_history C
        ON C.warehouse_name = A.warehouse_name AND C.start_time = A.start_time_hour
  )

SELECT client_application_name,
  warehouse_name,
  SUM(approximate_credits_used) AS approximate_credits_used
FROM approximate_credits
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 11003
-- Credits used (all time = past year)

SELECT object_type,
  SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.HYBRID_TABLE_USAGE_HISTORY
GROUP BY 1;

-- Credits used (past N days/weeks/months)

SELECT object_type,
  SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.HYBRID_TABLE_USAGE_HISTORY
WHERE start_time >= DATEADD(day, -5, CURRENT_TIMESTAMP()) 
GROUP BY 1;

-- Example 11004
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_ANALYST_USAGE_HISTORY;

-- Example 11005
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FINE_TUNING_USAGE_HISTORY;

-- Example 11006
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY;

-- Example 11007
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY
  WHERE model_name = 'mistral-large';

-- Example 11008
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY
  WHERE query_id = 'query-id';

-- Example 11009
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_SEARCH_DAILY_USAGE_HISTORY;

-- Example 11010
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_SEARCH_SERVING_USAGE_HISTORY;

-- Example 11011
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.DOCUMENT_AI_USAGE_HISTORY;

-- Example 11012
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_DOCUMENT_PROCESSING_USAGE_HISTORY
  WHERE CREDITS_USED > 0.072

-- Example 11013
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 11014
from snowflake.core.warehouse import Warehouse

my_wh = Warehouse(
  name="my_wh",
  warehouse_size="SMALL",
  auto_suspend=600,
)
warehouses = root.warehouses
warehouses.create(my_wh)

-- Example 11015
my_wh = root.warehouses["my_wh"].fetch()
print(my_wh.to_dict())

-- Example 11016
from snowflake.core.warehouse import Warehouse

my_wh = root.warehouses["my_wh"].fetch()
my_wh.warehouse_size = "LARGE"
my_wh.auto_suspend = 1800

my_wh_res = root.warehouses["my_wh"]
my_wh_res.create_or_alter(my_wh)

-- Example 11017
from snowflake.core.warehouse import WarehouseCollection

warehouses: WarehouseCollection = root.warehouses
wh_iter = warehouses.iter(like="my%")  # returns a PagedIter[Warehouse]
for wh_obj in wh_iter:
  print(wh_obj.name)

-- Example 11018
my_wh_res = root.warehouses["my_wh"]

my_wh_res.suspend()
my_wh_res.resume()
my_wh_res.abort_all_queries()
my_wh_res.drop()

-- Example 11019
GRANT {  { globalPrivileges         | ALL [ PRIVILEGES ] } ON ACCOUNT
       | { accountObjectPrivileges  | ALL [ PRIVILEGES ] } ON { USER | RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | CONNECTION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME } <object_name>
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> } }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
      }
  TO [ ROLE ] <role_name> [ WITH GRANT OPTION ]

-- Example 11020
GRANT {  { CREATE SCHEMA | MODIFY | MONITOR | USAGE } [ , ... ] } ON DATABASE <object_name>
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> } }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
      }
  TO DATABASE ROLE <database_role_name> [ WITH GRANT OPTION ]

-- Example 11021
globalPrivileges ::=
  {
      CREATE {
          ACCOUNT | APPLICATION | APPLICATION PACKAGE | COMPUTE POOL | DATA EXCHANGE LISTING
          | DATABASE | EXTERNAL VOLUME | FAILOVER GROUP | INTEGRATION | NETWORK POLICY
          | ORGANIZATION LISTING | ORGANIZATION PROFILE | REPLICATION GROUP | ROLE | SHARE
       | USER | WAREHOUSE
      }
      | ATTACH POLICY | AUDIT | BIND SERVICE ENDPOINT
      | APPLY {
         { AGGREGATION | AUTHENTICATION | JOIN | MASKING | PACKAGES | PASSWORD
           | PROJECTION | ROW ACCESS | SESSION } POLICY
         | TAG }
      | EXECUTE { ALERT | DATA METRIC FUNCTION | MANAGED ALERT | MANAGED TASK | TASK }
      | IMPORT { SHARE | ORGANIZATION LISTING }
      | MANAGE { ACCOUNT SUPPORT CASES | EVENT SHARING | GRANTS | LISTING AUTO FULFILLMENT | ORGANIZATION SUPPORT CASES | SHARE TARGET | USER SUPPORT CASES | WAREHOUSES }
      | MODIFY { LOG LEVEL | TRACE LEVEL | SESSION LOG LEVEL | SESSION TRACE LEVEL }
      | MONITOR { EXECUTION | SECURITY | USAGE }
      | OVERRIDE SHARE RESTRICTIONS | PURCHASE DATA EXCHANGE LISTING | RESOLVE ALL
      | READ SESSION
  }
  [ , ... ]

-- Example 11022
accountObjectPrivileges ::=
-- For APPLICATION PACKAGE
    { ATTACH LISTING | DEVELOP | INSTALL | MANAGE VERSIONS | MANAGE RELEASES } [ , ... ]
-- For COMPUTE POOL
   { MODIFY | MONITOR | OPERATE | USAGE } [ , ... ]
-- For CONNECTION
   { FAILOVER } [ , ... ]
-- For DATABASE
   { APPLYBUDGET | CREATE { DATABASE ROLE | SCHEMA }
   | IMPORTED PRIVILEGES | MODIFY | MONITOR | USAGE } [ , ... ]
-- For EXTERNAL VOLUME
   { USAGE } [ , ... ]
-- For FAILOVER GROUP
   { FAILOVER | MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For INTEGRATION
   { USAGE | USE_ANY_ROLE } [ , ... ]
-- For ORGANIZATION PROFILE
   { MODIFY } [ , ... ]
-- For REPLICATION GROUP
   { MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For RESOURCE MONITOR
   { MODIFY | MONITOR } [ , ... ]
-- For USER
   { MONITOR } [ , ... ]
-- For WAREHOUSE
   { APPLYBUDGET | MODIFY | MONITOR | USAGE | OPERATE } [ , ... ]

-- Example 11023
schemaPrivileges ::=

    ADD SEARCH OPTIMIZATION | APPLYBUDGET
  | CREATE {
        ALERT | CORTEX SEARCH SERVICE | DATA METRIC FUNCTION | DATASET
      | EVENT TABLE | FILE FORMAT | FUNCTION
      | { GIT | IMAGE } REPOSITORY
      | MODEL | NETWORK RULE | NOTEBOOK | PIPE | PROCEDURE
      | { AGGREGATION | AUTHENTICATION | MASKING | PACKAGES
         | PASSWORD | PRIVACY | PROJECTION | ROW ACCESS | SESSION } POLICY
      | SECRET | SEQUENCE | SERVICE | SNAPSHOT | STAGE | STREAM | STREAMLIT
      | SNOWFLAKE.CORE.BUDGET
      | SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
      | SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER
      | SNOWFLAKE.ML.ANOMALY_DETECTION | SNOWFLAKE.ML.CLASSIFICATION
         | SNOWFLAKE.ML.FORECAST | SNOWFLAKE.ML.TOP_INSIGHTS
      | SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE
      | [ { DYNAMIC | EXTERNAL | ICEBERG } ] TABLE
      | TAG | TASK | [ { MATERIALIZED | SEMANTIC } ] VIEW
      }
   | MODIFY | MONITOR | USAGE
   [ , ... ]

-- Example 11024
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DATA METRIC FUNCTION
     USAGE [ , ... ]
  -- For DYNAMIC TABLE
     MONITOR, OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { APPLYBUDGET | DELETE | OWNERSHIP | REFERENCES | SELECT | TRUNCATE } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), MODEL, PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For GIT REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For HYBRID TABLE
     { APPLYBUDGET | DELETE | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For ICEBERG TABLE
     { APPLYBUDGET | DELETE | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { AGGREGATION | AUTHENTICATION | MASKING | JOIN | PACKAGES | PASSWORD | PRIVACY | PROJECTION | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     { READ | USAGE } [ , ... ]
  -- For SEMANTIC VIEW
     REFERENCES [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For STREAMLIT
     USAGE [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]

-- Example 11025
<udf_or_stored_procedure_name> ( [ <arg_data_type> [ , ... ] ] )

-- Example 11026
GRANT SELECT ON FUTURE TABLES IN DATABASE d1 TO ROLE r1;

-- Example 11027
GRANT INSERT, DELETE ON FUTURE TABLES IN SCHEMA d1.s1 TO ROLE r2;

-- Example 11028
GRANT OPERATE ON WAREHOUSE report_wh TO ROLE analyst;

-- Example 11029
GRANT OPERATE ON WAREHOUSE report_wh TO ROLE analyst WITH GRANT OPTION;

-- Example 11030
GRANT SELECT ON ALL TABLES IN SCHEMA mydb.myschema to ROLE analyst;

-- Example 11031
GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(number) TO ROLE analyst;

GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(string) TO ROLE analyst;

-- Example 11032
GRANT USAGE ON PROCEDURE mydb.myschema.myprocedure(number) TO ROLE analyst;

-- Example 11033
GRANT CREATE MATERIALIZED VIEW ON SCHEMA mydb.myschema TO ROLE myrole;

-- Example 11034
GRANT SELECT, INSERT ON FUTURE TABLES IN SCHEMA mydb.myschema TO ROLE role1;

