-- Example 23559
SELECT object_type, SUM(credits_used) AS total_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.HYBRID_TABLE_USAGE_HISTORY
  GROUP BY 1;

-- Example 23560
SELECT object_type, SUM(credits_used) AS total_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.HYBRID_TABLE_USAGE_HISTORY
  WHERE start_time >= DATEADD(day, -5, CURRENT_TIMESTAMP())
  GROUP BY 1;

-- Example 23561
SELECT policy_name, policy_body, created
  FROM SNOWFLAKE.ACCOUNT_USAGE.JOIN_POLICIES
  WHERE policy_name='JP2' AND created LIKE '2024-11-26%';

-- Example 23562
+-------------+----------------------------------------------------------+-------------------------------+
| POLICY_NAME | POLICY_BODY                                              | CREATED                       |
|-------------+----------------------------------------------------------+-------------------------------|
| JP2         | CASE                                                     | 2024-11-26 11:22:54.848 -0800 |
|             |           WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'           |                               |
|             |             THEN JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE) |                               |
|             |           ELSE JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE)    |                               |
|             |         END                                              |                               |
+-------------+----------------------------------------------------------+-------------------------------+

-- Example 23563
WHERE last_load_time > 'Sun, 01 Apr 2016 16:00:00 -0800'

-- Example 23564
SELECT file_name, last_load_time FROM snowflake.account_usage.load_history
  ORDER BY last_load_time DESC
  LIMIT 10;

-- Example 23565
select a.PIPE_CATALOG as PIPE_CATALOG,
       a.PIPE_SCHEMA as PIPE_SCHEMA,
       a.PIPE_NAME as PIPE_NAME,
       b.CREDITS_USED as CREDITS_USED
from SNOWFLAKE.ACCOUNT_USAGE.PIPES a join SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY b
on a.pipe_id = b.pipe_id
where b.START_TIME > date_trunc(month, current_date);

-- Example 23566
SET query_id = '<query_id>';

WITH query_hash_of_query AS (
  SELECT query_parameterized_hash
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE query_id = $query_id
  LIMIT 1
)
SELECT
  query_parameterized_hash,
  COUNT (*) AS query_count,
  SUM(credits_attributed_compute) AS recurrent_query_attributed_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
  AND start_time < CURRENT_DATE
  AND query_parameterized_hash = (SELECT query_parameterized_hash FROM query_hash_of_query)
GROUP BY ALL;

-- Example 23567
SELECT user_name, SUM(credits_attributed_compute) AS credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE user_name = CURRENT_USER()
    AND start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
    AND start_time < CURRENT_DATE
  GROUP BY user_name;

-- Example 23568
SET query_id = '<query_id>';

SELECT query_id,
       parent_query_id,
       root_query_id,
       direct_objects_accessed
  FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
  WHERE query_id = $query_id;

-- Example 23569
SET query_id = '<root_query_id>';

SELECT SUM(credits_attributed_compute) AS total_attributed_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE (root_query_id = $query_id OR query_id = $query_id);

-- Example 23570
ALTER SESSION SET TIMEZONE = UTC;

-- Example 23571
select policy_name, policy_signature, created
from row_access_policies
order by created
;

-- Example 23572
SELECT
    table_id,
    ANY_VALUE(table_name) AS table_name,
    SUM(num_scans) AS total_num_scans,
    SUM(partitions_pruned_default) AS total_partitions_pruned_default,
    SUM(partitions_pruned_additional) AS total_partitions_pruned_additional,
    SUM(partitions_scanned) AS total_partitions_scanned
  FROM SNOWFLAKE.ACCOUNT_USAGE.SEARCH_OPTIMIZATION_BENEFITS
  WHERE start_time >= DATEADD(day, -7, CURRENT_TIMESTAMP())
  GROUP BY table_id
  ORDER BY
    total_partitions_pruned_additional / GREATEST(total_partitions_pruned_default + total_partitions_pruned_additional, 1) DESC,
    total_partitions_pruned_additional DESC
  LIMIT 5;

-- Example 23573
ALTER SESSION SET TIMEZONE = UTC;

-- Example 23574
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SEMANTIC_DIMENSIONS
  WHERE semantic_view_name = 'O_TPCH_SEMANTIC_VIEW'
    AND semantic_view_database_name = 'MY_DB';

-- Example 23575
+-----------------------+------------------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-------------+----------------------+----------+-------------------------------+-------------------------------+---------+---------+
| SEMANTIC_DIMENSION_ID | SEMANTIC_DIMENSION_NAME            | SEMANTIC_TABLE_ID | SEMANTIC_TABLE_NAME | SEMANTIC_VIEW_ID | SEMANTIC_VIEW_NAME   | SEMANTIC_VIEW_SCHEMA_ID | SEMANTIC_VIEW_SCHEMA_NAME | SEMANTIC_VIEW_DATABASE_ID | SEMANTIC_VIEW_DATABASE_NAME | DATA_TYPE   | EXPRESSION           | SYNONYMS | CREATED                       | LAST_ALTERED                  | DELETED | COMMENT |
|-----------------------+------------------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-------------+----------------------+----------+-------------------------------+-------------------------------+---------+---------|
|                   391 | D_CUSTOMER_REGION_NAME_FROM_REGION |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(25) | region.d_region_name | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                   392 | D_CUSTOMER_NATION_NAME             |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(25) | nation.d_nation_name | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                   393 | D_CUSTOMER_MARKET_SEGMENT          |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(10) | c_mktsegment         | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                   387 | D_NATION_NAME                      |                98 | NATION              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(25) | n_name               | NULL     | 2025-02-28 16:16:04.388 -0800 | 2025-02-28 16:16:04.388 -0800 | NULL    | NULL    |
|                   389 | D_REGION_NAME                      |                97 | REGION              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(25) | r_name               | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                   394 | D_CUSTOMER_COUNTRY_CODE            |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(15) | LEFT(c_phone, 2)     | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                   390 | D_CUSTOMER_REGION_NAME             |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(25) | nation.d_region_name | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                   388 | D_REGION_NAME                      |                98 | NATION              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | VARCHAR(25) | region.d_region_name | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
+-----------------------+------------------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-------------+----------------------+----------+-------------------------------+-------------------------------+---------+---------+

-- Example 23576
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SEMANTIC_FACTS
  WHERE semantic_view_name = 'O_TPCH_SEMANTIC_VIEW'
    AND semantic_view_database_name = 'MY_DB';

-- Example 23577
+------------------+------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+--------------+--------------------------+----------+-------------------------------+-------------------------------+---------+---------+
| SEMANTIC_FACT_ID | SEMANTIC_FACT_NAME     | SEMANTIC_TABLE_ID | SEMANTIC_TABLE_NAME | SEMANTIC_VIEW_ID | SEMANTIC_VIEW_NAME   | SEMANTIC_VIEW_SCHEMA_ID | SEMANTIC_VIEW_SCHEMA_NAME | SEMANTIC_VIEW_DATABASE_ID | SEMANTIC_VIEW_DATABASE_NAME | DATA_TYPE    | EXPRESSION               | SYNONYMS | CREATED                       | LAST_ALTERED                  | DELETED | COMMENT |
|------------------+------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+--------------+--------------------------+----------+-------------------------------+-------------------------------+---------+---------|
|              386 | A_CUSTOMER_ORDER_COUNT |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | NUMBER(18,0) | COUNT(orders.d_orderkey) | NULL     | 2025-02-28 16:16:04.388 -0800 | 2025-02-28 16:16:04.388 -0800 | NULL    | NULL    |
|              385 | D_ORDERKEY             |               100 | ORDERS              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | NUMBER(38,0) | o_orderkey               | NULL     | 2025-02-28 16:16:04.388 -0800 | 2025-02-28 16:16:04.388 -0800 | NULL    | NULL    |
+------------------+------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+--------------+--------------------------+----------+-------------------------------+-------------------------------+---------+---------+

-- Example 23578
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SEMANTIC_METRICS
  WHERE semantic_view_name = 'O_TPCH_SEMANTIC_VIEW'
    AND semantic_view_database_name = 'MY_DB';

-- Example 23579
i+--------------------+------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+--------------+--------------------------------------+----------+-------------------------------+-------------------------------+---------+---------+
| SEMANTIC_METRIC_ID | SEMANTIC_METRIC_NAME   | SEMANTIC_TABLE_ID | SEMANTIC_TABLE_NAME | SEMANTIC_VIEW_ID | SEMANTIC_VIEW_NAME   | SEMANTIC_VIEW_SCHEMA_ID | SEMANTIC_VIEW_SCHEMA_NAME | SEMANTIC_VIEW_DATABASE_ID | SEMANTIC_VIEW_DATABASE_NAME | DATA_TYPE    | EXPRESSION                           | SYNONYMS | CREATED                       | LAST_ALTERED                  | DELETED | COMMENT |
|--------------------+------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+--------------+--------------------------------------+----------+-------------------------------+-------------------------------+---------+---------|
|                396 | M_CUSTOMER_ORDER_COUNT |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | NUMBER(30,0) | SUM(customer.a_customer_order_count) | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                395 | M_CUSTOMER_COUNT       |                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | NUMBER(18,0) | COUNT(c_custkey)                     | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                398 | M_SUPPLIER_COUNT       |               102 | SUPPLIER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | NUMBER(18,0) | COUNT(s_suppkey)                     | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
|                397 | M_ORDER_COUNT          |               100 | ORDERS              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | NUMBER(18,0) | COUNT(o_orderkey)                    | NULL     | 2025-02-28 16:16:04.389 -0800 | 2025-02-28 16:16:04.389 -0800 | NULL    | NULL    |
+--------------------+------------------------+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+--------------+--------------------------------------+----------+-------------------------------+-------------------------------+---------+---------+

-- Example 23580
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SEMANTIC_RELATIONSHIPS
  WHERE semantic_view_name = 'O_TPCH_SEMANTIC_VIEW'
    AND semantic_view_database_name = 'MY_DB';

-- Example 23581
+--------------------------+-------------------------------------------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-------------------+---------------------+-----------------+-----------------------+-------------------------+-----------------+-------------------------------+-------------------------------+---------+
| SEMANTIC_RELATIONSHIP_ID | SEMANTIC_RELATIONSHIP_NAME                            | SEMANTIC_VIEW_ID | SEMANTIC_VIEW_NAME   | SEMANTIC_VIEW_SCHEMA_ID | SEMANTIC_VIEW_SCHEMA_NAME | SEMANTIC_VIEW_DATABASE_ID | SEMANTIC_VIEW_DATABASE_NAME | SEMANTIC_TABLE_ID | SEMANTIC_TABLE_NAME | FOREIGN_KEYS    | REF_SEMANTIC_TABLE_ID | REF_SEMANTIC_TABLE_NAME | REF_KEYS        | CREATED                       | LAST_ALTERED                  | DELETED |
|--------------------------+-------------------------------------------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-------------------+---------------------+-----------------+-----------------------+-------------------------+-----------------+-------------------------------+-------------------------------+---------|
|                       99 | SYS_RELATIONSHIP_67ae9bb4-652a-4985-8dc5-c99fdf7f4276 |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       |               100 | ORDERS              | [               |                    99 | CUSTOMER                | [               | 2025-02-28 16:16:04.321 -0800 | 2025-02-28 16:16:04.321 -0800 | NULL    |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     |   "O_CUSTKEY"   |                       |                         |   "C_CUSTKEY"   |                               |                               |         |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     | ]               |                       |                         | ]               |                               |                               |         |
|                      100 | SYS_RELATIONSHIP_906b4d92-582a-4bef-b2c1-9a69e8f61af1 |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       |               101 | LINEITEM            | [               |                   100 | ORDERS                  | [               | 2025-02-28 16:16:04.363 -0800 | 2025-02-28 16:16:04.363 -0800 | NULL    |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     |   "L_ORDERKEY"  |                       |                         |   "O_ORDERKEY"  |                               |                               |         |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     | ]               |                       |                         | ]               |                               |                               |         |
|                      101 | SYS_RELATIONSHIP_fadc2c0f-db3a-48e4-b96a-53ea2767a2b0 |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       |               102 | SUPPLIER            | [               |                    98 | NATION                  | [               | 2025-02-28 16:16:04.376 -0800 | 2025-02-28 16:16:04.376 -0800 | NULL    |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     |   "S_NATIONKEY" |                       |                         |   "N_NATIONKEY" |                               |                               |         |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     | ]               |                       |                         | ]               |                               |                               |         |
|                       98 | SYS_RELATIONSHIP_8c9ad09e-0ba4-489f-aabb-0503ef80e11b |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       |                99 | CUSTOMER            | [               |                    98 | NATION                  | [               | 2025-02-28 16:16:04.309 -0800 | 2025-02-28 16:16:04.309 -0800 | NULL    |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     |   "C_NATIONKEY" |                       |                         |   "N_NATIONKEY" |                               |                               |         |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     | ]               |                       |                         | ]               |                               |                               |         |
|                       97 | SYS_RELATIONSHIP_8529b4a7-eaff-4c36-888f-d9e1ad2683de |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       |                98 | NATION              | [               |                    97 | REGION                  | [               | 2025-02-28 16:16:04.294 -0800 | 2025-02-28 16:16:04.294 -0800 | NULL    |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     |   "N_REGIONKEY" |                       |                         |   "R_REGIONKEY" |                               |                               |         |
|                          |                                                       |                  |                      |                         |                           |                           |                             |                   |                     | ]               |                       |                         | ]               |                               |                               |         |
+--------------------------+-------------------------------------------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-------------------+---------------------+-----------------+-----------------------+-------------------------+-----------------+-------------------------------+-------------------------------+---------+

-- Example 23582
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SEMANTIC_TABLES
  WHERE semantic_view_name = 'O_TPCH_SEMANTIC_VIEW'
    AND semantic_view_database_name = 'MY_DB';

-- Example 23583
+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+------------------+----------+-------------------------------+-------------------------------+---------+---------+
| SEMANTIC_TABLE_ID | SEMANTIC_TABLE_NAME | SEMANTIC_VIEW_ID | SEMANTIC_VIEW_NAME   | SEMANTIC_VIEW_SCHEMA_ID | SEMANTIC_VIEW_SCHEMA_NAME | SEMANTIC_VIEW_DATABASE_ID | SEMANTIC_VIEW_DATABASE_NAME | PRIMARY_KEYS     | SYNONYMS | CREATED                       | LAST_ALTERED                  | DELETED | COMMENT |
|-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+------------------+----------+-------------------------------+-------------------------------+---------+---------|
|               101 | LINEITEM            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | [                | NULL     | 2025-02-28 16:16:04.363 -0800 | 2025-02-28 16:16:04.363 -0800 | NULL    | NULL    |
|                   |                     |                  |                      |                         |                           |                           |                             |   "L_ORDERKEY",  |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             |   "L_LINENUMBER" |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             | ]                |          |                               |                               |         |         |
|                99 | CUSTOMER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | [                | NULL     | 2025-02-28 16:16:04.309 -0800 | 2025-02-28 16:16:04.309 -0800 | NULL    | NULL    |
|                   |                     |                  |                      |                         |                           |                           |                             |   "C_CUSTKEY"    |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             | ]                |          |                               |                               |         |         |
|               100 | ORDERS              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | [                | NULL     | 2025-02-28 16:16:04.321 -0800 | 2025-02-28 16:16:04.321 -0800 | NULL    | NULL    |
|                   |                     |                  |                      |                         |                           |                           |                             |   "O_ORDERKEY"   |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             | ]                |          |                               |                               |         |         |
|               102 | SUPPLIER            |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | [                | NULL     | 2025-02-28 16:16:04.376 -0800 | 2025-02-28 16:16:04.376 -0800 | NULL    | NULL    |
|                   |                     |                  |                      |                         |                           |                           |                             |   "S_SUPPKEY"    |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             | ]                |          |                               |                               |         |         |
|                98 | NATION              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | [                | NULL     | 2025-02-28 16:16:04.294 -0800 | 2025-02-28 16:16:04.294 -0800 | NULL    | NULL    |
|                   |                     |                  |                      |                         |                           |                           |                             |   "N_NATIONKEY"  |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             | ]                |          |                               |                               |         |         |
|                97 | REGION              |               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | [                | NULL     | 2025-02-28 16:16:04.249 -0800 | 2025-02-28 16:16:04.249 -0800 | NULL    | NULL    |
|                   |                     |                  |                      |                         |                           |                           |                             |   "R_REGIONKEY"  |          |                               |                               |         |         |
|                   |                     |                  |                      |                         |                           |                           |                             | ]                |          |                               |                               |         |         |
+-------------------+---------------------+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+------------------+----------+-------------------------------+-------------------------------+---------+---------+

-- Example 23584
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SEMANTIC_VIEWS
  WHERE semantic_view_name = 'O_TPCH_SEMANTIC_VIEW'
    AND semantic_view_database_name = 'MY_DB';

-- Example 23585
+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-----------------+-------------------------------+-------------------------------+---------+---------+
| SEMANTIC_VIEW_ID | SEMANTIC_VIEW_NAME   | SEMANTIC_VIEW_SCHEMA_ID | SEMANTIC_VIEW_SCHEMA_NAME | SEMANTIC_VIEW_DATABASE_ID | SEMANTIC_VIEW_DATABASE_NAME | OWNER           | CREATED                       | LAST_ALTERED                  | DELETED | COMMENT |
|------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-----------------+-------------------------------+-------------------------------+---------+---------|
|               49 | O_TPCH_SEMANTIC_VIEW |                      92 | MY_SCHEMA                 |                         7 | MY_DB                       | DYOSHINAGA_ROLE | 2025-02-28 16:16:04.002 -0800 | 2025-02-28 16:16:04.589 -0800 | NULL    | NULL    |
+------------------+----------------------+-------------------------+---------------------------+---------------------------+-----------------------------+-----------------+-------------------------------+-------------------------------+---------+---------+

-- Example 23586
SELECT *
FROM snowflake.account_usage.services
WHERE service_name LIKE '%myservice%';

-- Example 23587
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SNOWPIPE_STREAMING_CLIENT_HISTORY;

-- Example 23588
+----------------+----------------------------+------------------------------+--------------+----------------+
|    CLIENT_NAME |    SNOWFLAKE_PROVIDED_ID   |              EVENT_TIMESTAMP |   EVENT_TYPE | BLOB_SIZE_BYTES|
|----------------+--------------------------- +------------------------------+--------------|----------------|
|      MY_CLIENT |FE0B1xJrBAAL3bAAUz1M9876nMCd| 2023-02-04 02:07:34.000 +0000| BLOB_PERSIST |           1,648|
|      MY_CLIENT |D1CIBBPGGFyprBanMvAA1234V3ss| 2023-02-04 02:15:54.000 +0000| BLOB_PERSIST |           3,120|
+----------------+----------------------------+------------------------------+--------------+----------------+

-- Example 23589
SELECT COUNT(DISTINCT event_timestamp) AS client_seconds, date_trunc('hour',event_timestamp) AS event_hour, client_seconds*0.000002777777778 as credits, client_name, snowflake_provided_id
FROM SNOWFLAKE.ACCOUNT_USAGE.SNOWPIPE_STREAMING_CLIENT_HISTORY
GROUP BY event_hour, client_name, snowflake_provided_id;

-- Example 23590
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.SNOWPIPE_STREAMING_FILE_MIGRATION_HISTORY;

-- Example 23591
+-------------------------------+-------------------------------+--------------+--------------------+------------------+----------+-----------------+------------+--------------+---------------+--------------+
| START_TIME                    | END_TIME                      | CREDITS_USED | NUM_BYTES_MIGRATED | NUM_ROWS_MIGRATED| TABLE_ID |      TABLE_NAME | SCHEMA_ID  |  SCHEMA_NAME |   DATABASE_ID | DATABASE_NAME|
|-------------------------------+-------------------------------+--------------+--------------------+------------------+----------+----------------------------------------------------------------------------|
|2023-02-08 19:00:00.000 +0000  |2023-02-08 20:00:00.000 +0000  | 0.0000325    |                 0  |                0 |  16849926| STREAMING_TABLE |   101351   |   SNOW       |  3166         |STREAMING     |
|2023-02-07 19:00:00.000 +0000  |2023-02-07 20:00:00.000 +0000  | 0.000096761  |             7,850  |               39 |  16849926| STREAMING_TABLE |   101351   |   SNOW       |  3166         |STREAMING     |
+-------------------------------+-------------------------------+--------------+--------------------+------------------+----------+-----------------+------------+--------------+---------------|--------------+

-- Example 23592
SELECT
    table_id,
    ANY_VALUE(table_name) AS table_name,
    SUM(rows_added) AS total_rows_added,
    SUM(rows_removed) AS total_rows_removed,
    SUM(rows_updated) AS total_rows_updated
  FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_DML_HISTORY
  WHERE start_time >= DATEADD(day, -7, CURRENT_TIMESTAMP())
  GROUP BY table_id
  ORDER BY total_rows_added + total_rows_removed + total_rows_updated DESC
  LIMIT 5;

-- Example 23593
+----------+----------------------+------------------+--------------------+--------------------+
| TABLE_ID | TABLE_NAME           | TOTAL_ROWS_ADDED | TOTAL_ROWS_REMOVED | TOTAL_ROWS_UPDATED |
|----------+----------------------+------------------+--------------------+--------------------|
|   338948 | SENSOR_DATA_TS       |          5356800 |             259200 |                  0 |
|   338950 | SENSOR_DATA_DEVICE2  |          2678400 |                  0 |                  0 |
|   341006 | SENSOR_DATA_30_ROWS  |               30 |                  0 |                  0 |
|   341004 | SENSOR_DATA_12_HOURS |               12 |                  0 |                  0 |
|   340005 | SENSOR_DATA_12_HOURS |               12 |                  0 |                  0 |
+----------+----------------------+------------------+--------------------+--------------------+

-- Example 23594
SELECT
    table_id,
    ANY_VALUE(table_name) AS table_name,
    SUM(num_scans) AS total_num_scans,
    SUM(partitions_scanned) AS total_partitions_scanned,
    SUM(partitions_pruned) AS total_partitions_pruned,
    SUM(rows_scanned) AS total_rows_scanned,
    SUM(rows_pruned) AS total_rows_pruned
  FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_PRUNING_HISTORY
  WHERE start_time >= DATEADD(day, -7, CURRENT_TIMESTAMP())
  GROUP BY table_id
  ORDER BY
    total_partitions_pruned / GREATEST(total_partitions_scanned + total_partitions_pruned, 1),
    total_partitions_scanned DESC
  LIMIT 5;

-- Example 23595
+----------+----------------+-----------------+--------------------------+-------------------------+--------------------+-------------------+
| TABLE_ID | TABLE_NAME     | TOTAL_NUM_SCANS | TOTAL_PARTITIONS_SCANNED | TOTAL_PARTITIONS_PRUNED | TOTAL_ROWS_SCANNED | TOTAL_ROWS_PRUNED |
|----------+----------------+-----------------+--------------------------+-------------------------+--------------------+-------------------|
|   308226 | SENSOR_DATA_TS |              11 |                       21 |                       1 |           52500000 |           2500000 |
|   185364 | MATCH          |              16 |                       14 |                       2 |             240968 |             34424 |
|   209932 | ORDER_HEADER   |               2 |                      300 |                      56 |          421051748 |          75350790 |
|   209922 | K7_T1          |             261 |                      261 |                      52 |              30421 |              3272 |
|   338948 | SENSOR_DATA_TS |               9 |                       15 |                       3 |           38880000 |           8035200 |
+----------+----------------+-----------------+--------------------------+-------------------------+--------------------+-------------------+

-- Example 23596
SELECT timestamp, warehouse_name, cluster_number,
       event_name, event_reason, event_state,
       size, cluster_count
  FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_EVENTS_HISTORY
  WHERE warehouse_name = 'MY_WH'
  AND timestamp > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY timestamp DESC;

-- Example 23597
ALTER WAREHOUSE my_wh SET
  COMMENT = 'Updated comment for warehouse';

-- Example 23598
ALTER WAREHOUSE my_wh SET
  WAREHOUSE_SIZE = 'SMALL';

-- Example 23599
select to_varchar(-123.45, '999.99MI') as EXAMPLE;

-- Example 23600
create table sample_numbers (f float);
insert into sample_numbers (f) values (1.2);
insert into sample_numbers (f) values (123.456);
insert into sample_numbers (f) values (1234.56);
insert into sample_numbers (f) values (-123456.789);
select to_varchar(f, '999,999.999'), to_varchar(f, 'S000,000.000') from sample_numbers;

-- Example 23601
+------------------------------+-------------------------------+
| TO_VARCHAR(F, '999,999.999') | TO_VARCHAR(F, 'S000,000.000') |
+==============================+===============================+
|        1.2                   | +000,001.200                  |
+------------------------------+-------------------------------+
|      123.456                 | +000,123.456                  |
+------------------------------+-------------------------------+
|    1,234.56                  | +001,234.560                  |
+------------------------------+-------------------------------+
| -123,456.789                 | -123,456.789                  |
+------------------------------+-------------------------------+

-- Example 23602
select to_varchar(f, '999,999.999'), to_varchar(f, 'S999,999.999') from sample_numbers;

-- Example 23603
+------------------------------+-------------------------------+
| TO_VARCHAR(F, '999,999.999') | TO_VARCHAR(F, 'S999,999.999') |
+==============================+===============================+
|        1.2                   |       +1.2                    |
+------------------------------+-------------------------------+
|      123.456                 |     +123.456                  |
+------------------------------+-------------------------------+
|    1,234.56                  |   +1,234.56                   |
+------------------------------+-------------------------------+
| -123,456.789                 | -123,456.789                  |
+------------------------------+-------------------------------+

-- Example 23604
select  to_varchar(f, '999,999.999'), to_varchar(f, 'FM999,999.999') from sample_numbers;

-- Example 23605
+------------------------------+--------------------------------+
| TO_VARCHAR(F, '999,999.999') | TO_VARCHAR(F, 'FM999,999.999') |
+==============================+================================+
|        1.2                   | 1.2                            |
+------------------------------+--------------------------------+
|      123.456                 | 123.456                        |
+------------------------------+--------------------------------+
|    1,234.56                  | 1,234.56                       |
+------------------------------+--------------------------------+
| -123,456.789                 | -123,456.789                   |
+------------------------------+--------------------------------+

-- Example 23606
select to_char(1234, '9d999EE'), 'will look like', '1.234E3';

-- Example 23607
+--------------------------+------------------+-----------+
| TO_CHAR(1234, '9D999EE') | 'WILL LOOK LIKE' | '1.234E3' |
+==========================+==================+===========+
| 1.234E3                  |  will look like  |  1.234E3  |
+--------------------------+------------------+-----------+

-- Example 23608
select to_char(12, '">"99"<"');

-- Example 23609
+-------+
| > 12< |
+-------+

-- Example 23610
-- All of the following convert the input to the number 12,345.67.
SELECT TO_NUMBER('012,345.67', '999,999.99', 8, 2);
SELECT TO_NUMBER('12,345.67', '999,999.99', 8, 2);
SELECT TO_NUMBER(' 12,345.67', '999,999.99', 8, 2);
-- The first of the following works, but the others will not convert.
-- (They are not supposed to convert, so "failure" is correct.)
SELECT TO_NUMBER('012,345.67', '000,000.00', 8, 2);
SELECT TO_NUMBER('12,345.67', '000,000.00', 8, 2);
SELECT TO_NUMBER(' 12,345.67', '000,000.00', 8, 2);

-- Example 23611
-- Create the table and insert data.
create table format1 (v varchar, i integer);
insert into format1 (v) values ('-101');
insert into format1 (v) values ('102-');
insert into format1 (v) values ('103');

-- Try to convert varchar to integer without a
-- format model.  This fails (as expected)
-- with a message similar to:
--    "Numeric value '102-' is not recognized"
update format1 set i = TO_NUMBER(v);

-- Now try again with a format specifier that allows the minus sign
-- to be at either the beginning or the end of the number.
-- Note the use of the vertical bar ("|") to indicate that
-- either format is acceptable.
update format1 set i = TO_NUMBER(v, 'MI999|999MI');
select i from format1;

-- Example 23612
COPY INTO load1 FROM @%load1/data1/ FILES=('test1.csv', 'test2.csv', 'test3.csv')

-- Example 23613
COPY INTO people_data FROM @%people_data/data1/
   PATTERN='.*person_data[^0-9{1,3}$$].csv';

-- Example 23614
"value1", "value2", "value3"

-- Example 23615
COPY INTO mytable
FROM @%mytable
FILE_FORMAT = (TYPE = CSV TRIM_SPACE=true FIELD_OPTIONALLY_ENCLOSED_BY = '0x22');

SELECT * FROM mytable;

+--------+--------+--------+
| col1   | col2   | col3   |
+--------+--------+--------+
| value1 | value2 | value3 |
+--------+--------+--------+

-- Example 23616
CREATE TABLE sales (
  customer   varchar,
  product    varchar,
  spend      decimal(20, 2),
  sale_date  date,
  region     varchar
);

-- Example 23617
CREATE TABLE security.salesmanagerregions (
  sales_manager varchar,
  region        varchar
);

-- Example 23618
USE ROLE SECURITYADMIN;

CREATE ROLE mapping_role;

GRANT SELECT ON TABLE security.salesmanagerregions TO ROLE mapping_role;

-- Example 23619
USE ROLE schema_owner_role;

CREATE OR REPLACE ROW ACCESS POLICY security.sales_policy
AS (sales_region varchar) RETURNS BOOLEAN ->
  'sales_executive_role' = CURRENT_ROLE()
    OR EXISTS (
      SELECT 1 FROM salesmanagerregions
        WHERE sales_manager = CURRENT_ROLE()
        AND region = sales_region
    )
;

-- Example 23620
GRANT OWNERSHIP ON ROW ACCESS POLICY security.sales_policy TO mapping_role;

GRANT APPLY ON ROW ACCESS POLICY security.sales_policy TO ROLE sales_analyst_role;

-- Example 23621
USE ROLE SECURITYADMIN;

ALTER TABLE sales ADD ROW ACCESS POLICY security.sales_policy ON (region);

-- Example 23622
GRANT SELECT ON TABLE sales TO ROLE sales_manager_role;

-- Example 23623
USE ROLE sales_manager_role;
SELECT product, SUM(spend)
FROM sales
WHERE YEAR(sale_date) = 2020
GROUP BY product;

-- Example 23624
CREATE OR REPLACE ROW ACCESS POLICY rap_NO_memoizable_function
  AS (region_id number, customer_id number, product_id number)
  RETURNS BOOLEAN ->
    EXISTS(SELECT 1 FROM regions WHERE id = region_id) OR
    EXISTS(SELECT 1 FROM customers WHERE id = customer_id) OR
    EXISTS(SELECT 1 FROM products WHERE id = product_id)
  ;

-- Example 23625
USE ROLE USERADMIN;

CREATE ROLE functions_admin;

