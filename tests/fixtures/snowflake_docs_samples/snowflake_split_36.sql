-- Example 2381
CREATE OR REPLACE PROCEDURE my_procedure(values ARRAY(INTEGER))
  RETURNS ARRAY(INTEGER)
  LANGUAGE SQL
  AS
  $$
    ...
  $$;

-- Example 2382
CREATE OR REPLACE FUNCTION my_function(values ARRAY(INTEGER))
  RETURNS ARRAY(INTEGER)
  LANGUAGE PYTHON
  RUNTIME_VERSION=3.10
  AS
  $$
    ...
  $$;

-- Example 2383
map(VARCHAR(16777216), VARCHAR(16777216))

-- Example 2384
ARRAY(NUMBER(38,0))

-- Example 2385
CREATE TABLE images_table(img FILE);

-- Example 2386
ALTER STAGE my_images DIRECTORY=(ENABLE=true);

-- Example 2387
INSERT INTO images_table
    SELECT TO_FILE(file_url) FROM DIRECTORY(@my_images);

-- Example 2388
SELECT FL_GET_RELATIVE_PATH(f)
    FROM images_table
    WHERE FL_GET_LAST_MODIFIED(f) BETWEEN '2021-01-01' and '2023-01-01';

-- Example 2389
VECTOR( <type>, <dimension> )

-- Example 2390
VECTOR(FLOAT, 256)

-- Example 2391
VECTOR(INT, 16)

-- Example 2392
VECTOR(STRING, 256)

-- Example 2393
VECTOR(INT, -1)

-- Example 2394
CREATE OR REPLACE TABLE myvectortable (a VECTOR(float, 3), b VECTOR(float, 3));
INSERT INTO myvectortable SELECT [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3);
INSERT INTO myvectortable SELECT [1,2.2,3]::VECTOR(FLOAT,3), [4,6,8]::VECTOR(FLOAT,3);

COPY INTO @mystage/unload/
  FROM (SELECT TO_ARRAY(a), TO_ARRAY(b) FROM myvectortable);

-- Example 2395
CREATE OR REPLACE TABLE arraytable (a ARRAY, b ARRAY);

COPY INTO arraytable
  FROM @mystage/unload/mydata.csv.gz;

SELECT a::VECTOR(FLOAT, 3), b::VECTOR(FLOAT, 3)
  FROM arraytable;

-- Example 2396
SELECT [1, 2, 3]::VECTOR(FLOAT, 3) AS vec;

-- Example 2397
ALTER TABLE myissues ADD COLUMN issue_vec VECTOR(FLOAT, 768);

UPDATE TABLE myissues
  SET issue_vec = SNOWFLAKE.CORTEX.EMBED_TEXT_768('e5-base-v2', issue_text);

-- Example 2398
SELECT CAST('2022-04-01' AS DATE);

SELECT '2022-04-01'::DATE;

SELECT TO_DATE('2022-04-01');

-- Example 2399
SELECT date_column
  FROM log_table
  WHERE date_column >= '2022-04-01'::DATE;

-- Example 2400
SELECT my_float_function(my_integer_column)
  FROM my_table;

-- Example 2401
SELECT 17 || '76';

-- Example 2402
SELECT ...
  FROM my_table
  WHERE my_integer_column < my_float_column;

-- Example 2403
SELECT height * width::VARCHAR || ' square meters'
  FROM dimensions;

-- Example 2404
... height * (width::VARCHAR) ...

-- Example 2405
SELECT (height * width)::VARCHAR || ' square meters'
  FROM dimensions;

-- Example 2406
SELECT -0.0::FLOAT::BOOLEAN;

-- Example 2407
SELECT (-0.0::FLOAT)::BOOLEAN;

-- Example 2408
SELECT -(0.0::FLOAT::BOOLEAN);

-- Example 2409
SELECT 12.3::FLOAT::NUMBER(3,2);

-- Example 2410
CREATE OR REPLACE TABLE convert_test_zeros (
  varchar1 VARCHAR,
  float1 FLOAT,
  variant1 VARIANT);

INSERT INTO convert_test_zeros SELECT
  '5.000',
  5.000,
  PARSE_JSON('{"Loan Number": 5.000}');

-- Example 2411
SELECT varchar1,
       float1::VARCHAR,
       variant1:"Loan Number"::VARCHAR
  FROM convert_test_zeros;

-- Example 2412
+----------+-----------------+---------------------------------+
| VARCHAR1 | FLOAT1::VARCHAR | VARIANT1:"LOAN NUMBER"::VARCHAR |
|----------+-----------------+---------------------------------|
| 5.000    | 5               | 5                               |
+----------+-----------------+---------------------------------+

-- Example 2413
SELECT SYSTEM$TYPEOF(IFNULL(12.3, 0)),
       SYSTEM$TYPEOF(IFNULL(NULL, 0));

-- Example 2414
+--------------------------------+--------------------------------+
| SYSTEM$TYPEOF(IFNULL(12.3, 0)) | SYSTEM$TYPEOF(IFNULL(NULL, 0)) |
|--------------------------------+--------------------------------|
| NUMBER(3,1)[SB1]               | NUMBER(1,0)[SB1]               |
+--------------------------------+--------------------------------+

-- Example 2415
CREATE STAGE my_int_stage
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
  DIRECTORY = ( ENABLE = true );

-- Example 2416
TIME_SLICE( <date_or_time_expr> , <slice_length> , <date_or_time_part> [ , <start_or_end> ] )

-- Example 2417
SELECT '2019-02-28'::DATE AS "DATE",
       TIME_SLICE("DATE", 4, 'MONTH', 'START') AS "START OF SLICE",
       TIME_SLICE("DATE", 4, 'MONTH', 'END') AS "END OF SLICE";
+------------+----------------+--------------+
| DATE       | START OF SLICE | END OF SLICE |
|------------+----------------+--------------|
| 2019-02-28 | 2019-01-01     | 2019-05-01   |
+------------+----------------+--------------+

-- Example 2418
SELECT '2019-02-28T01:23:45.678'::TIMESTAMP_NTZ AS "TIMESTAMP 1",
       '2019-02-28T12:34:56.789'::TIMESTAMP_NTZ AS "TIMESTAMP 2",
       TIME_SLICE("TIMESTAMP 1", 8, 'HOUR') AS "SLICE FOR TIMESTAMP 1",
       TIME_SLICE("TIMESTAMP 2", 8, 'HOUR') AS "SLICE FOR TIMESTAMP 2";
+-------------------------+-------------------------+-------------------------+-------------------------+
| TIMESTAMP 1             | TIMESTAMP 2             | SLICE FOR TIMESTAMP 1   | SLICE FOR TIMESTAMP 2   |
|-------------------------+-------------------------+-------------------------+-------------------------|
| 2019-02-28 01:23:45.678 | 2019-02-28 12:34:56.789 | 2019-02-28 00:00:00.000 | 2019-02-28 08:00:00.000 |
+-------------------------+-------------------------+-------------------------+-------------------------+

-- Example 2419
CREATE TABLE accounts (ID INT, billing_date DATE, balance_due NUMBER(11, 2));

INSERT INTO accounts (ID, billing_date, balance_due) VALUES
    (1, '2018-07-31', 100.00),
    (2, '2018-08-01', 200.00),
    (3, '2018-08-25', 400.00);

-- Example 2420
SELECT
       TIME_SLICE(billing_date, 2, 'WEEK', 'START') AS "START OF SLICE",
       TIME_SLICE(billing_date, 2, 'WEEK', 'END')   AS "END OF SLICE",
       COUNT(*) AS "NUMBER OF LATE BILLS",
       SUM(balance_due) AS "SUM OF MONEY OWED"
    FROM accounts
    WHERE balance_due > 0    -- bill hasn't yet been paid
    GROUP BY "START OF SLICE", "END OF SLICE";
+----------------+--------------+----------------------+-------------------+
| START OF SLICE | END OF SLICE | NUMBER OF LATE BILLS | SUM OF MONEY OWED |
|----------------+--------------+----------------------+-------------------|
| 2018-07-23     | 2018-08-06   |                    2 |            300.00 |
| 2018-08-20     | 2018-09-03   |                    1 |            400.00 |
+----------------+--------------+----------------------+-------------------+

-- Example 2421
[ WITH ... ]
SELECT
   [ TOP <n> ]
   ...
[ INTO ... ]
[ FROM ...
   [ AT | BEFORE ... ]
   [ CHANGES ... ]
   [ CONNECT BY ... ]
   [ JOIN ... ]
   [ ASOF JOIN ... ]
   [ LATERAL ... ]
   [ MATCH_RECOGNIZE ... ]
   [ PIVOT | UNPIVOT ... ]
   [ VALUES ... ]
   [ SAMPLE ... ] ]
[ WHERE ... ]
[ GROUP BY ...
   [ HAVING ... ] ]
[ QUALIFY ... ]
[ ORDER BY ... ]
[ LIMIT ... ]
[ FOR UPDATE ... ]

-- Example 2422
ALTER SESSION SET SEARCH_PATH = '$current, $public, snowflake.ml';

-- Example 2423
CREATE ANOMALY_DETECTION mydatabase.myschema.my_anomaly_detector(...);

-- Example 2424
mydatabase.myschema.my_anomaly_detector!DETECT_ANOMALIES(...);

-- Example 2425
SHOW CLASSES IN DATABASE SNOWFLAKE;

-- Example 2426
SHOW PARAMETERS LIKE 'search_path';

-- Example 2427
ALTER SESSION SET SEARCH_PATH = '$current, $public, SNOWFLAKE.ML';

-- Example 2428
ALTER USER SET SEARCH_PATH = '$current, $public, SNOWFLAKE.ML';

-- Example 2429
ALTER ACCOUNT SET SEARCH_PATH = '$current, $public, SNOWFLAKE.ML';

-- Example 2430
SHOW FUNCTIONS IN CLASS ANOMALY_DETECTION;

-- Example 2431
+-----------------------+-------------------+-------------------+--------------------------------------------------------------------------+--------------+----------+
| name                  | min_num_arguments | max_num_arguments | arguments                                                                | descriptions | language |
|-----------------------+-------------------+-------------------+--------------------------------------------------------------------------+--------------+----------|
| _DETECT_ANOMALIES_1_1 |                 5 |                 5 | (MODEL BINARY, TS TIMESTAMP_NTZ, Y FLOAT, FEATURES ARRAY, CONFIG OBJECT) | NULL         | Python   |
| _FIT                  |                 3 |                 3 | (TS TIMESTAMP_NTZ, Y FLOAT, FEATURES ARRAY)                              | NULL         | Python   |
| _FIT                  |                 4 |                 4 | (TS TIMESTAMP_NTZ, Y FLOAT, LABEL BOOLEAN, FEATURES ARRAY)               | NULL         | Python   |
+-----------------------+-------------------+-------------------+--------------------------------------------------------------------------+--------------+----------+

-- Example 2432
SHOW PROCEDURES IN CLASS ANOMALY_DETECTION;

-- Example 2433
+---------------------------------+-------------------+-------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+
| name                            | min_num_arguments | max_num_arguments | arguments                                                                                                                                | descriptions | language   |
|---------------------------------+-------------------+-------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------|
| __CONSTRUCT                     |                 4 |                 4 | (INPUT_DATA VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, LABEL_COLNAME VARCHAR)                                           | NULL         | Javascript |
| __CONSTRUCT                     |                 5 |                 5 | (INPUT_DATA VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, LABEL_COLNAME VARCHAR)                   | NULL         | Javascript |
| DETECT_ANOMALIES                |                 4 |                 4 | (INPUT_DATA VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR)                                          | NULL         | SQL        |
| DETECT_ANOMALIES                |                 5 |                 5 | (INPUT_DATA VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, CONFIG_OBJECT OBJECT)                    | NULL         | SQL        |
| DETECT_ANOMALIES                |                 3 |                 3 | (INPUT_DATA VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR)                                                                  | NULL         | SQL        |
| DETECT_ANOMALIES                |                 4 |                 4 | (INPUT_DATA VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, CONFIG_OBJECT OBJECT)                                            | NULL         | SQL        |
| EXPLAIN_FEATURE_IMPORTANCE      |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
| _CONSTRUCTFEATUREINPUT          |                 6 |                 6 | (INPUT_REF VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, LABEL_COLNAME VARCHAR, REF_ALIAS VARCHAR) | NULL         | Javascript |
| _CONSTRUCTINFERENCEFUNCTIONNAME |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
| _CONSTRUCTINFERENCERESULTAPI    |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
| _SETTRAININGINFO                |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
+---------------------------------+-------------------+-------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+

-- Example 2434
SHOW ROLES IN CLASS ANOMALY_DETECTION;

-- Example 2435
+-------------------------------+------+---------+
| created_on                    | name | comment |
|-------------------------------+------+---------|
| 2023-06-06 01:06:42.808 +0000 | USER | NULL    |
+-------------------------------+------+---------+

-- Example 2436
SHOW GRANTS TO SNOWFLAKE.ML.ANOMALY_DETECTION ROLE my_db.my_schema.my_anomaly_detector!USER;

-- Example 2437
GRANT SNOWFLAKE.ML.ANOMALY_DETECTION ROLE my_db.my_schema.my_anomaly_detector!USER
  TO ROLE my_role;

-- Example 2438
GRANT CREATE ANOMALY_DETECTION ON SCHEMA mydb.myschema TO ROLE ml_admin;

-- Example 2439
CREATE ANOMALY_DETECTION my_anomaly_detector(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'my_view'),
  TIMESTAMP_COLUMN => 'my_timestamp_column'
  TARGET_COLNAME => 'my_target_column',
  LABEL_COLNAME => ''
);

-- Example 2440
CALL my_anomaly_detector!DETECT_ANOMALIES(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'my_view'),
  TIMESTAMP_COLNAME =>'my_timestamp_column',
  TARGET_COLNAME => 'my_target_column'
);

-- Example 2441
SELECT ... FROM TABLE( <method_name>( <arg> [ , ... <arg> ] ) );

-- Example 2442
SELECT ts, forecast, is_anomaly FROM TABLE(
  my_anomaly_detector!DETECT_ANOMALIES(
    INPUT_DATA => TABLE('my_view'),
    TIMESTAMP_COLNAME =>'my_timestamp_column',
    TARGET_COLNAME => 'my_target_column'
  )
);

-- Example 2443
WITH my_data AS (
  SELECT * FROM my_view
)
SELECT ts, forecast FROM TABLE(
  my_anomaly_detector!DETECT_ANOMALIES(
    INPUT_DATA => TABLE('SELECT * FROM my_data'),
    TIMESTAMP_COLNAME =>'my_timestamp_column',
    TARGET_COLNAME => 'my_target_column'
  )
);

-- Example 2444
SELECT ts, forecast FROM TABLE(
  my_anomaly_detector!DETECT_ANOMALIES(
    INPUT_DATA => TABLE('
      WITH my_data AS (
        SELECT * FROM my_view
      )
      SELECT * FROM my_data
    '),
    TIMESTAMP_COLNAME =>'my_timestamp_column',
    TARGET_COLNAME => 'my_target_column'
  )
);

-- Example 2445
ALTER SESSION SET SEARCH_PATH = '$current, $public, snowflake.ml';

-- Example 2446
CREATE ANOMALY_DETECTION mydatabase.myschema.my_anomaly_detector(...);

-- Example 2447
mydatabase.myschema.my_anomaly_detector!DETECT_ANOMALIES(...);

-- Example 2448
SHOW CLASSES IN DATABASE SNOWFLAKE;

