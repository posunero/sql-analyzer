-- Example 22423
CALL test_get_scale('1970-01-01 00:00:01.123', '2');
+----------------+
| TEST_GET_SCALE |
|----------------|
|              2 |
+----------------+

-- Example 22424
CALL test_get_scale('1971-01-01 00:00:00.000123456', '9');
+----------------+
| TEST_GET_SCALE |
|----------------|
|              9 |
+----------------+

-- Example 22425
CREATE OR REPLACE PROCEDURE test_get_Timezone(TSV VARCHAR)
    RETURNS FLOAT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_TZ;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.getTimezone();
    $$
    ;

-- Example 22426
CALL test_get_timezone('1970-01-01 00:00:01-08:00');
+-------------------+
| TEST_GET_TIMEZONE |
|-------------------|
|              -480 |
+-------------------+

-- Example 22427
CALL test_get_timezone('1971-01-01 00:00:00.000123456+11:00');
+-------------------+
| TEST_GET_TIMEZONE |
|-------------------|
|               660 |
+-------------------+

-- Example 22428
CREATE OR REPLACE PROCEDURE test_toString(TSV VARCHAR)
    RETURNS VARIANT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_TZ;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.toString();
    $$
    ;

-- Example 22429
CALL test_toString('1970-01-02 03:04:05');
+------------------------------------------------------------------+
| TEST_TOSTRING                                                    |
|------------------------------------------------------------------|
| "Fri Jan 02 1970 03:04:05 GMT+0000 (Coordinated Universal Time)" |
+------------------------------------------------------------------+

-- Example 22430
EXECUTE IMMEDIATE
$$
BEGIN
  CREATE OR REPLACE TABLE test_snowflake_scripting_gv (i INT);
  INSERT INTO test_snowflake_scripting_gv VALUES (1);
  SELECT 1;
  RETURN SQLROWCOUNT;
END;
$$;

-- Example 22431
+-----------------+
| anonymous block |
|-----------------|
|               1 |
+-----------------+

-- Example 22432
+-----------------+
| anonymous block |
|-----------------|
|            NULL |
+-----------------+

-- Example 22433
EXECUTE IMMEDIATE
$$
BEGIN
  LET sql_row_count_var := 0;
  CREATE OR REPLACE TABLE test_snowflake_scripting_gv (i INT);
  INSERT INTO test_snowflake_scripting_gv VALUES (1);
  sql_row_count_var := SQLROWCOUNT;
  SELECT 1;
  RETURN sql_row_count_var;
END;
$$;

-- Example 22434
SELECT SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2024_02');

-- Example 22435
+-------------------------------------------------+
| SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2024_02') |
|-------------------------------------------------|
| DISABLED                                        |
+-------------------------------------------------+

-- Example 22436
SELECT SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES();

-- Example 22437
+--------------------------------------------------------------------------------------------------------------+
| SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES()                                                                 |
|--------------------------------------------------------------------------------------------------------------|
| [{"name":"2023_08","isDefault":true,"isEnabled":true},{"name":"2024_01","isDefault":false,"isEnabled":true}] |
+--------------------------------------------------------------------------------------------------------------+

-- Example 22438
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02');

-- Example 22439
+-------------------------------------------------+
| SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02') |
|-------------------------------------------------|
| ENABLED                                         |
+-------------------------------------------------+

-- Example 22440
SELECT SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02');

-- Example 22441
+-------------------------------------------------+
| SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02')|
|-------------------------------------------------|
| DISABLED                                        |
+-------------------------------------------------+

-- Example 22442
SELECT CURRENT_VERSION();

-- Example 22443
+-------------------+
| CURRENT_VERSION() |
|-------------------|
| 8.5.1             |
+-------------------+

-- Example 22444
CREATE MASKING POLICY MP AS (n NUMBER)
RETURNS NUMBER -> 12345;

-- Example 22445
CREATE TABLE t(col1 NUMBER(2,0));

ALTER TABLE t MODIFY COLUMN col1 SET MASKING POLICY mp;
INSERT INTO t VALUES (10);

-- Example 22446
SELECT * FROM t;

-- Example 22447
SET DDM_CASTING_BCR_START_DATE = '2024-03-01';
SET DDM_CASTING_BCR_END_DATE = '2024-04-03';

-- Example 22448
USE ROLE ACCOUNTADMIN;
SET DDM_CASTING_BCR_START_DATE = '2024-03-01';
SET DDM_CASTING_BCR_END_DATE = '2024-04-03';
SELECT * FROM SNOWFLAKE.BCR_ROLLOUT.BCR_2024_03_DDM_ROLLOUT;

-- Example 22449
DECLARE
  -- (variable declarations, cursor declarations, etc.) ...
BEGIN
  -- (Snowflake Scripting and SQL statements) ...
EXCEPTION
  -- (statements for handling exceptions) ...
END;

-- Example 22450
BEGIN
  CREATE TABLE employee (id INTEGER, ...);
  CREATE TABLE dependents (id INTEGER, ...);
END;

-- Example 22451
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := pi() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;

-- Example 22452
CREATE OR REPLACE PROCEDURE area()
RETURNS FLOAT
LANGUAGE SQL
AS
DECLARE
  radius FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius := 3;
  area_of_circle := PI() * radius * radius;
  RETURN area_of_circle;
END;

-- Example 22453
CREATE OR REPLACE PROCEDURE area()
RETURNS FLOAT
LANGUAGE SQL
AS
$$
DECLARE
  radius FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius := 3;
  area_of_circle := PI() * radius * radius;
  RETURN area_of_circle;
END;
$$
;

-- Example 22454
CALL area();

-- Example 22455
+--------------+
|         AREA |
|--------------|
| 28.274333882 |
+--------------+

-- Example 22456
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := PI() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;

-- Example 22457
EXECUTE IMMEDIATE $$
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := PI() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;
$$
;

-- Example 22458
+-----------------+
| anonymous block |
|-----------------|
|    28.274333882 |
+-----------------+

-- Example 22459
BEGIN
  CREATE TABLE parent (ID INTEGER);
  CREATE TABLE child (ID INTEGER, parent_ID INTEGER);
  RETURN 'Completed';
END;

-- Example 22460
EXECUTE IMMEDIATE $$
BEGIN
    CREATE TABLE parent (ID INTEGER);
    CREATE TABLE child (ID INTEGER, parent_ID INTEGER);
    RETURN 'Completed';
END;
$$
;

-- Example 22461
+-----------------+
| anonymous block |
|-----------------|
| Completed       |
+-----------------+

-- Example 22462
SELECT TO_DATE('3/4/2024', 'dd/mm/yyyy');

-- Example 22463
+-----------------------------------+
| TO_DATE('3/4/2024', 'DD/MM/YYYY') |
|-----------------------------------|
| 2024-04-03                        |
+-----------------------------------+

-- Example 22464
SELECT TO_VARCHAR('2024-04-05'::DATE, 'mon dd, yyyy');

-- Example 22465
+------------------------------------------------+
| TO_VARCHAR('2024-04-05'::DATE, 'MON DD, YYYY') |
|------------------------------------------------|
| Apr 05, 2024                                   |
+------------------------------------------------+

-- Example 22466
ALTER SESSION SET TIMEZONE = UTC;

-- Example 22467
-- Source table (null_empty1) contents
+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Create a file format that describes the data and the guidelines for processing it
create or replace file format my_csv_format
  field_optionally_enclosed_by='0x27' null_if=('null');

-- Unload table data into a stage
copy into @mystage
  from null_empty1
  file_format = (format_name = 'my_csv_format');

-- Output the data file contents
1,'null','NULL value'
2,'','Empty string'

-- Load data from the staged file into the target table (null_empty2)
copy into null_empty2
    from @mystage/data_0_0_0.csv.gz
    file_format = (format_name = 'my_csv_format');

select * from null_empty2;

+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Example 22468
-- Source table (null_empty1) contents
+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Create a file format that describes the data and the guidelines for processing it
create or replace file format my_csv_format
  empty_field_as_null=false null_if=('null');

-- Unload table data into a stage
copy into @mystage
  from null_empty1
  file_format = (format_name = 'my_csv_format');

-- Output the data file contents
1,null,NULL value
2,,Empty string

-- Load data from the staged file into the target table (null_empty2)
copy into null_empty2
    from @mystage/data_0_0_0.csv.gz
    file_format = (format_name = 'my_csv_format');

select * from null_empty2;

+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Example 22469
copy into @mystage/myfile.csv.gz from mytable
file_format = (type=csv compression='gzip')
single=true
max_file_size=4900000000;

-- Example 22470
-- Create a table
CREATE OR REPLACE TABLE mytable (
 id number(8) NOT NULL,
 first_name varchar(255) default NULL,
 last_name varchar(255) default NULL,
 city varchar(255),
 state varchar(255)
);

-- Populate the table with data
INSERT INTO mytable (id,first_name,last_name,city,state)
 VALUES
 (1,'Ryan','Dalton','Salt Lake City','UT'),
 (2,'Upton','Conway','Birmingham','AL'),
 (3,'Kibo','Horton','Columbus','GA');

-- Unload the data to a file in a stage
COPY INTO @mystage
 FROM (SELECT OBJECT_CONSTRUCT('id', id, 'first_name', first_name, 'last_name', last_name, 'city', city, 'state', state) FROM mytable)
 FILE_FORMAT = (TYPE = JSON);

-- The COPY INTO location statement creates a file named data_0_0_0.json.gz in the stage.
-- The file contains the following data:

{"city":"Salt Lake City","first_name":"Ryan","id":1,"last_name":"Dalton","state":"UT"}
{"city":"Birmingham","first_name":"Upton","id":2,"last_name":"Conway","state":"AL"}
{"city":"Columbus","first_name":"Kibo","id":3,"last_name":"Horton","state":"GA"}

-- Example 22471
COPY INTO @mystage/myfile.parquet FROM (SELECT id, name, start_date FROM mytable)
  FILE_FORMAT=(TYPE='parquet')
  HEADER = TRUE;

-- Example 22472
COPY INTO @mystage
FROM (SELECT CAST(C1 AS TINYINT) ,
             CAST(C2 AS SMALLINT) ,
             CAST(C3 AS INT),
             CAST(C4 AS BIGINT) FROM mytable)
FILE_FORMAT=(TYPE=PARQUET);

-- Example 22473
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  USE_VECTORIZED_SCANNER = TRUE;

-- Example 22474
CREATE OR REPLACE ICEBERG TABLE customer_iceberg_ingest (
  c_custkey INTEGER,
  c_name STRING,
  c_address STRING,
  c_nationkey INTEGER,
  c_phone STRING,
  c_acctbal INTEGER,
  c_mktsegment STRING,
  c_comment STRING
)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_ingest_vol'
  BASE_LOCATION = 'customer_iceberg_ingest/';

-- Example 22475
COPY INTO customer_iceberg_ingest
  FROM @my_parquet_stage
  FILE_FORMAT = 'my_parquet_format'
  LOAD_MODE = ADD_FILES_COPY
  PURGE = TRUE
  MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;

-- Example 22476
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                          | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_008.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_006.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_005.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_002.parquet | LOADED |           5 |           5 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_010.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 22477
SELECT
    c_custkey,
    c_name,
    c_mktsegment
  FROM customer_iceberg_ingest
  LIMIT 10;

-- Example 22478
+-----------+--------------------+--------------+
| C_CUSTKEY | C_NAME             | C_MKTSEGMENT |
|-----------+--------------------+--------------|
|     75001 | Customer#000075001 | FURNITURE    |
|     75002 | Customer#000075002 | FURNITURE    |
|     75003 | Customer#000075003 | MACHINERY    |
|     75004 | Customer#000075004 | AUTOMOBILE   |
|     75005 | Customer#000075005 | FURNITURE    |
|         1 | Customer#000000001 | BUILDING     |
|         2 | Customer#000000002 | AUTOMOBILE   |
|         3 | Customer#000000003 | AUTOMOBILE   |
|         4 | Customer#000000004 | MACHINERY    |
|         5 | Customer#000000005 | HOUSEHOLD    |
+-----------+--------------------+--------------+

-- Example 22479
select root_task_name, state from snowflake.account_usage.complete_task_graphs
  limit 10;

-- Example 22480
select file_name, error_count, status, last_load_time from snowflake.account_usage.copy_history
  order by last_load_time desc
  limit 10;

-- Example 22481
SELECT * FROM snowflake.account_usage.privacy_budgets
  WHERE policy_name='patients_policy' AND budget_name='analyst_budget';

-- Example 22482
SELECT *
  FROM TABLE(SNOWFLAKE.DATA_PRIVACY.CUMULATIVE_PRIVACY_LOSSES(
    'my_policy_db.my_policy_schema.my_policy_privacy'));

-- Example 22483
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts',
  BUDGET_LIMIT=>300,
  MAX_BUDGET_PER_AGGREGATE=>0.1);

-- Example 22484
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts', BUDGET_WINDOW=>'daily');

-- Example 22485
CALL SNOWFLAKE.DATA_PRIVACY.RESET_PRIVACY_BUDGET(
  'my_policy_db.my_policy_schema.my_policy',
  'analyst_budget',
  'companyorg',
  'account_123');

-- Example 22486
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts', MAX_BUDGET_PER_AGGREGATE=>0.1);

-- Example 22487
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts',
  BUDGET_LIMIT=>300,
  MAX_BUDGET_PER_AGGREGATE=>0.1);

-- Example 22488
SELECT COUNT(*)
FROM t1 INNER JOIN t2 ON t1.a=t2.a;

-- Example 22489
SELECT COUNT(*)
FROM (SELECT a, COUNT(b) FROM t1 GROUP BY a) AS g1
    INNER JOIN (SELECT * FROM t2) AS g2
    ON g1.a=g2.a;

