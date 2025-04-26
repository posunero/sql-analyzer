-- Example 30055
CALL model_binary!SHOW_FEATURE_IMPORTANCE();

-- Example 30056
+------+---------------------+---------------+---------------+
| RANK | FEATURE             |         SCORE | FEATURE_TYPE  |
|------+---------------------+---------------+---------------|
|    1 | USER_RATING         | 0.9295302013  | user_provided |
|    2 | USER_INTEREST_SCORE | 0.07046979866 | user_provided |
+------+---------------------+---------------+---------------+

-- Example 30057
session.sql('call my_model!FORECAST(...)').collect()

-- Example 30058
CREATE STAGE doc_ai_stage
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 30059
USE ROLE ACCOUNTADMIN;

CREATE ROLE doc_ai_role;
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE doc_ai_role;

-- Example 30060
CREATE DATABASE doc_ai_db;
CREATE SCHEMA doc_ai_db.doc_ai_schema;
CREATE WAREHOUSE doc_ai_wh;

-- Example 30061
GRANT USAGE, OPERATE ON WAREHOUSE doc_ai_wh TO ROLE doc_ai_role;

-- Example 30062
GRANT USAGE ON DATABASE doc_ai_db TO ROLE doc_ai_role;
GRANT USAGE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 30063
GRANT CREATE STAGE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 30064
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 30065
GRANT CREATE STREAM, CREATE TABLE, CREATE TASK, CREATE VIEW ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE doc_ai_role;

-- Example 30066
GRANT ROLE doc_ai_role TO USER doc_ai_user;

-- Example 30067
('2020-01-01 00:00:00.000', 2.0),
('2020-01-02 00:00:00.000', 3.0),
('2020-01-03 00:00:00.000', 4.0);

-- Example 30068
-- Train your model
CREATE SNOWFLAKE.ML.FORECAST my_model(
  INPUT_DATA => TABLE(my_view),
  TIMESTAMP_COLNAME => 'my_timestamps',
  TARGET_COLNAME => 'my_metric'
);

-- Generate forecasts using your model
SELECT * FROM TABLE(my_model!FORECAST(FORECASTING_PERIODS => 7));

-- Example 30069
CREATE OR REPLACE TABLE sales_data (store_id NUMBER, item VARCHAR, date TIMESTAMP_NTZ,
  sales FLOAT, temperature NUMBER, humidity FLOAT, holiday VARCHAR);

INSERT INTO sales_data VALUES
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-01'), 2.0, 50, 0.3, 'new year'),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-02'), 3.0, 52, 0.3, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-03'), 4.0, 54, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-04'), 5.0, 54, 0.3, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-05'), 6.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-06'), 7.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-07'), 8.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-08'), 9.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-09'), 10.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-10'), 11.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-11'), 12.0, 55, 0.2, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-12'), 13.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-01'), 2.0, 50, 0.3, 'new year'),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-02'), 3.0, 52, 0.3, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-03'), 4.0, 54, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-04'), 5.0, 54, 0.3, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-05'), 6.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-06'), 7.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-07'), 8.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-08'), 9.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-09'), 10.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-10'), 11.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-11'), 12.0, 55, 0.2, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-12'), 13.0, 55, 0.2, NULL);

-- Future values for additional columns (features)
CREATE OR REPLACE TABLE future_features (store_id NUMBER, item VARCHAR,
  date TIMESTAMP_NTZ, temperature NUMBER, humidity FLOAT, holiday VARCHAR);

INSERT INTO future_features VALUES
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-13'), 52, 0.3, NULL),
  (1, 'jacket', TO_TIMESTAMP_NTZ('2020-01-14'), 53, 0.3, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-13'), 52, 0.3, NULL),
  (2, 'umbrella', TO_TIMESTAMP_NTZ('2020-01-14'), 53, 0.3, NULL);

-- Example 30070
CREATE OR REPLACE VIEW v1 AS SELECT date, sales
  FROM sales_data WHERE store_id=1 AND item='jacket';
SELECT * FROM v1;

-- Example 30071
+-------------------------+-------+
| DATE                    | SALES |
+-------------------------+-------+
| 2020-01-01 00:00:00.000 | 2     |
| 2020-01-02 00:00:00.000 | 3     |
| 2020-01-03 00:00:00.000 | 4     |
| 2020-01-04 00:00:00.000 | 5     |
| 2020-01-05 00:00:00.000 | 6     |
+-------------------------+-------+

-- Example 30072
CREATE SNOWFLAKE.ML.FORECAST model1(
  INPUT_DATA => TABLE(v1),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- Example 30073
Instance MODEL1 successfully created.

-- Example 30074
call model1!FORECAST(FORECASTING_PERIODS => 3);

-- Example 30075
+--------+-------------------------+-----------+--------------+--------------+
| SERIES | TS                      | FORECAST  | LOWER_BOUND  | UPPER_BOUND  |
+--------+-------------------------+-----------+--------------+--------------+
| NULL   | 2020-01-13 00:00:00.000 | 14        | 14           | 14           |
| NULL   | 2020-01-14 00:00:00.000 | 15        | 15           | 15           |
| NULL   | 2020-01-15 00:00:00.000 | 16        | 16           | 16           |
+--------+-------------------------+-----------+--------------+--------------+

-- Example 30076
CALL model1!FORECAST(FORECASTING_PERIODS => 3, CONFIG_OBJECT => {'prediction_interval': 0.8});

-- Example 30077
CREATE TABLE my_forecasts AS
  SELECT * FROM TABLE(model1!FORECAST(FORECASTING_PERIODS => 3));

-- Example 30078
CREATE OR REPLACE VIEW v3 AS SELECT [store_id, item] AS store_item, date, sales FROM sales_data;
SELECT * FROM v3;

-- Example 30079
+-------------------+-------------------------+-------+
| STORE_ITEM        | DATE                    | SALES |
+-------------------+-------------------------+-------+
| [ 1, "jacket" ]   | 2020-01-01 00:00:00.000 | 2     |
| [ 1, "jacket" ]   | 2020-01-02 00:00:00.000 | 3     |
| [ 1, "jacket" ]   | 2020-01-03 00:00:00.000 | 4     |
| [ 1, "jacket" ]   | 2020-01-04 00:00:00.000 | 5     |
| [ 1, "jacket" ]   | 2020-01-05 00:00:00.000 | 6     |
| [ 2, "umbrella" ] | 2020-01-01 00:00:00.000 | 2     |
| [ 2, "umbrella" ] | 2020-01-02 00:00:00.000 | 3     |
| [ 2, "umbrella" ] | 2020-01-03 00:00:00.000 | 4     |
| [ 2, "umbrella" ] | 2020-01-04 00:00:00.000 | 5     |
| [ 2, "umbrella" ] | 2020-01-05 00:00:00.000 | 6     |
+-------------------+-------------------------+-------+

-- Example 30080
CREATE SNOWFLAKE.ML.FORECAST model2(
  INPUT_DATA => TABLE(v3),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- Example 30081
CALL model2!FORECAST(FORECASTING_PERIODS => 2);

-- Example 30082
+-------------------+------------------------+----------+-------------+-------------+
| SERIES            | TS                     | FORECAST | LOWER_BOUND | UPPER_BOUND |
+-------------------+------------------------+----------+-------------+-------------+
| [ 1, "jacket" ]   | 2020-01-13 00:00:00.000 | 14      | 14          | 14          |
| [ 1, "jacket" ]   | 2020-01-14 00:00:00.000 | 15      | 15          | 15          |
| [ 2, "umbrella" ] | 2020-01-13 00:00:00.000 | 14      | 14          | 14          |
| [ 2, "umbrella" ] | 2020-01-14 00:00:00.000 | 15      | 15          | 15          |
+-------------------+-------------------------+---------+-------------+-------------+

-- Example 30083
CALL model2!FORECAST(SERIES_VALUE => [2,'umbrella'], FORECASTING_PERIODS => 2);

-- Example 30084
+-------------------+------------ ------------+-----------+-------------+-------------+
| SERIES            | TS                      | FORECAST  | LOWER_BOUND | UPPER_BOUND |
+-------------------+---------- --------------+-----------+-------------+-------------+
| [ 2, "umbrella" ] | 2020-01-13 00:00:00.000 | 14        | 14          | 14          |
| [ 2, "umbrella" ] | 2020-01-14 00:00:00.000 | 15        | 15          | 15          |
+-------------------+-------------------------+-----------+-------------+-------------+

-- Example 30085
CREATE OR REPLACE VIEW v2 AS SELECT date, sales, temperature, humidity, holiday
  FROM sales_data WHERE store_id=1 AND item='jacket';
SELECT * FROM v2;

-- Example 30086
+-------------------------+--------+-------------+----------+----------+
| DATE                    | SALES  | TEMPERATURE | HUMIDITY | HOLIDAY  |
+-------------------------+--------+-------------+----------+----------+
| 2020-01-01 00:00:00.000 | 2      | 50          | 0.3      | new year |
| 2020-01-02 00:00:00.000 | 3      | 52          | 0.3      | null     |
| 2020-01-03 00:00:00.000 | 4      | 54          | 0.2      | null     |
| 2020-01-04 00:00:00.000 | 5      | 54          | 0.3      | null     |
| 2020-01-05 00:00:00.000 | 6      | 55          | 0.2      | null     |
+-------------------------+--------+-------------+----------+----------+

-- Example 30087
CREATE SNOWFLAKE.ML.FORECAST model3(
  INPUT_DATA => TABLE(v2),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- Example 30088
CREATE OR REPLACE VIEW v2_forecast AS select date, temperature, humidity, holiday
  FROM future_features WHERE store_id=1 AND item='jacket';
SELECT * FROM v2_forecast;

-- Example 30089
+-------------------------+-------------+----------+---------+
| DATE                    | TEMPERATURE | HUMIDITY | HOLIDAY |
+-------------------------+-------------+----------+---------+
| 2020-01-13 00:00:00.000 | 52          | 0.3      | null    |
| 2020-01-14 00:00:00.000 | 53          | 0.3      | null    |
+-------------------------+-------------+----------+---------+

-- Example 30090
CALL model3!FORECAST(
  INPUT_DATA => TABLE(v2_forecast),
  TIMESTAMP_COLNAME =>'date'
);

-- Example 30091
+--------+-------------------------+-----------+--------------+--------------+
| SERIES | TS                      | FORECAST  | LOWER_BOUND  | UPPER_BOUND  |
+--------+-------------------------+-----------+--------------+--------------+
| NULL   | 2020-01-13 00:00:00.000 | 14        | 14           | 14           |
| NULL   | 2020-01-14 00:00:00.000 | 15        | 15           | 15           |
+--------+-------------------------+-----------+--------------+--------------+

-- Example 30092
CREATE OR REPLACE VIEW v_random_data AS SELECT
  DATEADD('minute', ROW_NUMBER() over (ORDER BY 1), '2023-12-01')::TIMESTAMP_NTZ ts,
  UNIFORM(1, 100, RANDOM(0)) exog_a,
  UNIFORM(1, 100, RANDOM(0)) exog_b,
  (MOD(SEQ1(),10) + exog_a) y
FROM TABLE(GENERATOR(ROWCOUNT => 500));

CREATE OR REPLACE SNOWFLAKE.ML.FORECAST model(
  INPUT_DATA => TABLE(v_random_data),
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'y'
);

CALL model!SHOW_EVALUATION_METRICS();

-- Example 30093
+--------+--------------------------+--------------+--------------------+------+
| SERIES | ERROR_METRIC             | METRIC_VALUE | STANDARD_DEVIATION | LOGS |
+--------+--------------------------+--------------+--------------------+------+
| NULL   | "MAE"                    |         2.49 |                NaN | NULL |
| NULL   | "MAPE"                   |        0.084 |                NaN | NULL |
| NULL   | "MDA"                    |         0.99 |                NaN | NULL |
| NULL   | "MSE"                    |        8.088 |                NaN | NULL |
| NULL   | "SMAPE"                  |        0.077 |                NaN | NULL |
| NULL   | "WINKLER_ALPHA=0.05"     |       12.101 |                NaN | NULL |
| NULL   | "COVERAGE_INTERVAL=0.95" |            1 |                NaN | NULL |
+--------+--------------------------+--------------+--------------------+------+

-- Example 30094
CALL model!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 30095
+--------+------+--------------+---------------+---------------+
| SERIES | RANK | FEATURE_NAME | SCORE         | FEATURE_TYPE  |
+--------+------+--------------+---------------+---------------+
| NULL   |    1 | exog_a       |  31.414947903 | user_provided |
| NULL   |    2 | exog_b       |             0 | user_provided |
+--------+------+--------------+---------------+---------------+

-- Example 30096
CREATE TABLE t_error(date TIMESTAMP_NTZ, sales FLOAT, series VARCHAR);
INSERT INTO t_error VALUES
  (TO_TIMESTAMP_NTZ('2019-12-30'), 3.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-31'), 2.0, 'A'),
  (TO_TIMESTAMP_NTZ('2020-01-01'), 2.0, 'A'),
  (TO_TIMESTAMP_NTZ('2020-01-02'), 3.0, 'A'),
  (TO_TIMESTAMP_NTZ('2020-01-03'), 3.0, 'A'),
  (TO_TIMESTAMP_NTZ('2020-01-04'), 7.0, 'A'),
  (TO_TIMESTAMP_NTZ('2020-01-06'), 10.0, 'B'), -- the same timestamp used again and again
  (TO_TIMESTAMP_NTZ('2020-01-06'), 13.0, 'B'),
  (TO_TIMESTAMP_NTZ('2020-01-06'), 12.0, 'B'),
  (TO_TIMESTAMP_NTZ('2020-01-06'), 15.0, 'B'),
  (TO_TIMESTAMP_NTZ('2020-01-06'), 14.0, 'B'),
  (TO_TIMESTAMP_NTZ('2020-01-06'), 18.0, 'B'),
  (TO_TIMESTAMP_NTZ('2020-01-06'), 12.0, 'B');

CREATE SNOWFLAKE.ML.FORECAST error_model(
  INPUT_DATA => TABLE(SELECT date, sales, series FROM t_error),
  SERIES_COLNAME => 'series',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'ON_ERROR': 'SKIP'}
);

CALL error_model!SHOW_TRAINING_LOGS();

-- Example 30097
+--------+--------------------------------------------------------------------------+
| SERIES | LOGS                                                                     |
+--------+--------------------------------------------------------------------------+
| "B"    | {   "Errors": [     "At least two unique timestamps are required."   ] } |
| "A"    | NULL                                                                     |
+--------+--------------------------------------------------------------------------+

-- Example 30098
SHOW SNOWFLAKE.ML.FORECAST;

-- Example 30099
DROP SNOWFLAKE.ML.FORECAST my_model;

-- Example 30100
USE ROLE admin;
GRANT USAGE ON DATABASE admin_db TO ROLE analyst;
GRANT USAGE ON SCHEMA admin_schema TO ROLE analyst;
GRANT CREATE SNOWFLAKE.ML.FORECAST ON SCHEMA admin_db.admin_schema TO ROLE analyst;

-- Example 30101
USE ROLE analyst;
USE SCHEMA admin_db.admin_schema;

-- Example 30102
USE ROLE analyst;
CREATE SCHEMA analyst_db.analyst_schema;
USE SCHEMA analyst_db.analyst_schema;

-- Example 30103
REVOKE CREATE SNOWFLAKE.ML.FORECAST ON SCHEMA admin_db.admin_schema FROM ROLE analyst;

-- Example 30104
CREATE SNOWFLAKE.ML.TOP_INSIGHTS IF NOT EXISTS my_insights();

-- Example 30105
CALL my_insights!get_drivers (
  INPUT_DATA => TABLE(my_table),
  LABEL_COLNAME => 'label',
  METRIC_COLNAMe => 'sales');

-- Example 30106
CREATE VIEW input_table_time_series_label (
  ds, metric, dim_country, dim_vertical, label ) AS
  SELECT
    ds,
    metric,
    dim_country,
    dim_vertical,
    ds >= dateadd(month, -1, current_date) AS label
  FROM input_table;

-- Example 30107
CREATE VIEW input_table_vertical_label (
  ds, metric,  dim_country, dim_vertical, label ) AS
  SELECT
    ds,
    metric,
    dim_country,
    dim_vertical,
    dim_country <> 'USA' as label
  FROM input_table;

-- Example 30108
CREATE OR REPLACE TABLE input_table(
  ds DATE, metric NUMBER, dim_country VARCHAR, dim_vertical VARCHAR);

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'usa' AS dim_country,
    'tech' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'usa' AS dim_country,
    'auto' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, seq4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'usa' AS dim_country,
    'fashion' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'usa' AS dim_country,
    'finance' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'canada' AS dim_country,
    'fashion' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'canada' AS dim_country,
    'finance' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'canada' AS dim_country,
    'tech' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'canada' AS dim_country,
    'auto' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'france' AS dim_country,
    'fashion' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'france' AS dim_country,
    'finance' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'france' AS dim_country,
    'tech' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS ds,
    UNIFORM(1, 10, RANDOM()) AS metric,
    'france' AS dim_country,
    'auto' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

-- Data for the test group

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 8, 1)) AS ds,
    UNIFORM(300, 320, RANDOM()) AS metric,
    'usa' AS dim_country,
    'auto' AS dim_vertica
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO input_table
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 8, 1))  AS ds,
    UNIFORM(400, 420, RANDOM()) AS metric,
    'usa' AS dim_country,
    'finance' AS dim_vertical
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

-- Example 30109
CREATE OR REPLACE VIEW input_view AS (
    SELECT
        metric,
        dim_country as country,
        dim_vertical as vertical,
        ds >= '2021-01-01' AS label
    FROM input_table
);

-- Example 30110
CREATE OR REPLACE SNOWFLAKE.ML.TOP_INSIGHTS my_insights_model()

CALL my_insights_model!GET_DRIVERS(
  INPUT_DATA => TABLE(input_view),
  LABEL_COLNAME => 'label',
  METRIC_COLNAME => 'metric'
)

-- Example 30111
+---------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+---------------+
| CONTRIBUTOR                                                         | METRIC_CONTROL | METRIC_TEST | CONTRIBUTION | RELATIVE_CONTRIBUTION |   GROWTH_RATE |
|---------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+---------------|
| ["Overall"]                                                         |         128445 |      158456 |        30011 |         1             |  0.2336486434 |
| ["COUNTRY = usa"]                                                   |         116238 |      154574 |        38336 |         1.277398287   |  0.3298060875 |
| ["COUNTRY = usa","VERTICAL = finance"]                              |          64281 |       87423 |        23142 |         0.771117257   |  0.3600130676 |
| ["COUNTRY = usa","VERTICAL = auto"]                                 |          48930 |       66131 |        17201 |         0.5731565093  |  0.3515430206 |
| ["COUNTRY = usa","VERTICAL = tech"]                                 |           1543 |         503 |        -1040 |        -0.03465396021 | -0.6740116656 |
| ["COUNTRY = canada","VERTICAL = finance"]                           |           1538 |         482 |        -1056 |        -0.03518709806 | -0.6866059818 |
| ["COUNTRY = canada","VERTICAL = fashion"]                           |           1519 |         446 |        -1073 |        -0.03575355703 | -0.7063857801 |
| ["COUNTRY = france","VERTICAL = auto"]                              |           1534 |         460 |        -1074 |        -0.03578687814 | -0.7001303781 |
| ["COUNTRY = usa","not VERTICAL = auto","not VERTICAL = finance"]    |           3027 |        1020 |        -2007 |        -0.06687547899 | -0.6630327056 |
| ["COUNTRY = france","not VERTICAL = fashion","not VERTICAL = tech"] |           3100 |         962 |        -2138 |        -0.07124054513 | -0.6896774194 |
| ["COUNTRY = france","not VERTICAL = fashion"]                       |           4687 |        1456 |        -3231 |        -0.1076605245  | -0.689353531  |
| ["COUNTRY = france"]                                                |           6202 |        1947 |        -4255 |        -0.1417813468  | -0.68606901   |
| ["not COUNTRY = usa"]                                               |          12207 |        3882 |        -8325 |        -0.2773982873  | -0.6819857459 |
+---------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+---------------+

-- Example 30112
CREATE OR REPLACE TABLE vertical_input_table(
  region VARCHAR, industry VARCHAR, num_employee NUMBER, credits FLOAT);

INSERT INTO vertical_input_table
  SELECT
    'USA' as region,
    ['technology', 'finance', 'healthcare', 'consumer'][MOD(ABS(RANDOM()), 4)] as industry,
    UNIFORM(100, 10000, RANDOM()) as num_employee,
    UNIFORM(1000, 3000, RANDOM()) AS credits,
  FROM TABLE(GENERATOR(ROWCOUNT => 450));

INSERT INTO vertical_input_table
  SELECT
    'EMEA' as region,
    ['technology', 'finance', 'healthcare', 'consumer'][MOD(ABS(RANDOM()), 4)] as industry,
    UNIFORM(100, 10000, RANDOM()) as num_employee,
    UNIFORM(100, 5000, RANDOM()) AS credits,
  FROM TABLE(GENERATOR(ROWCOUNT => 350));

-- Example 30113
CREATE OR REPLACE VIEW vertical_input_view AS (
    SELECT
        credits,
        industry,
        num_employee,
        region = 'EMEA' AS label
    FROM vertical_input_table
);

-- Example 30114
CREATE OR REPLACE SNOWFLAKE.ML.TOP_INSIGHTS my_insights_model();

CALL my_insights_model!get_drivers(
  INPUT_DATA => TABLE(vertical_input_view),
  LABEL_COLNAME => 'label',
  METRIC_COLNAME => 'credits'
);

-- Example 30115
+-------------------------------------------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+------------------+|
| CONTRIBUTOR                                                                                           | METRIC_CONTROL | METRIC_TEST | CONTRIBUTION | RELATIVE_CONTRIBUTION |      GROWTH_RATE |
|-------------------------------------------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+------------------|
| ["Overall"]                                                                                           |         896672 |      895326 |        -1346 |           1           |  -0.001501106313 |
| ["not INDUSTRY = consumer","NUM_EMPLOYEE <= 6248.0","NUM_EMPLOYEE > 4235.0"]                          |         141138 |       70337 |       -70801 |          52.601040119 |  -0.5016437813   |
| ["NUM_EMPLOYEE <= 6248.0","NUM_EMPLOYEE > 4235.0"]                                                    |         188770 |      127320 |       -61450 |          45.653789004 |  -0.3255284208   |
| ["not INDUSTRY = technology","NUM_EMPLOYEE <= 8670.0","NUM_EMPLOYEE > 7582.5"]                        |         100533 |       42925 |       -57608 |          42.799405646 |  -0.5730257726   |
| ["not INDUSTRY = consumer","NUM_EMPLOYEE <= 5562.5","NUM_EMPLOYEE > 4235.0"]                          |         103851 |       47052 |       -56799 |          42.198365527 |  -0.54692781     |
+-------------------------------------------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+------------------+

-- Example 30116
{
  "argumentSignature": (function_signature varchar),
  "objectName": "DATABASE_NAME.SCHEMA_NAME.FUNCTION_NAME",
  "objectID": "12345",
  "objectDomain": "Function"
}

-- Example 30117
{
  "argumentSignature": (function_signature varchar),
  "objectName": "DATABASE_NAME.SCHEMA_NAME.PROCEDURE_NAME"
  "objectID":"12345"
  "objectDomain":"Procedure"
}

-- Example 30118
[
  {
    "Columns": [
      {
        "columnId": ######,
        "columnName": "column1_name"
      },
      {
        "columnId": ######,
        "columnName": "column2_name"
      }
    ],
    "objectDomain":"VIEW",
    "objectId": ##view_id##,
    "objectName": "DATABASE_1.PUBLIC.VIEW_1"
  },
  {
    "Columns": [
      {
        "columnId": ######,
        "columnName": "column3_name"
      },
      {
        "columnId": ######,
        "columnName": "column4_name"
      }
    ],
    "objectDomain":"TABLE",
    "objectId": ##table_id##,
    "objectName": "DATABASE_2.PUBLIC.TABLE1"
  }
]

-- Example 30119
{
  "argumentSignature": (function_signature varchar),
  "objectName": "23662386A408C571B77FDC53691793E4992D1C12.SCHEMA_NAME.FUNCTION_NAME",
  "objectDomain": "Function"
}

-- Example 30120
{
  "argumentSignature": (function_signature varchar),
  "objectName": "23662386A408C571B77FDC53691793E4992D1C12.SCHEMA_NAME.PROCEDURE_NAME"
  "objectDomain":"Procedure"
}

-- Example 30121
[
  {
    "Columns": [
      {
        "columnName": "column1_name"
      },
      {
        "columnName": "column2_name"
      }
    ],
    "objectDomain":"VIEW",
    "objectName": "5F3297829072D2E23B852D7787825FF762E74EF3.PUBLIC.VIEW_1"
  },
  {
    "Columns": [
      {
        "columnName": "column3_name"
      },
      {
        "columnName": "column4_name"
      }
    ],
    "objectDomain":"TABLE",
    "objectName": "D85A2CE1531C6C1E077FA701713047305BDF5A83.PUBLIC.TABLE1"
  }
]

