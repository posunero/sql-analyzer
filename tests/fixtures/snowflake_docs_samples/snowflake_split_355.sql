-- Example 23760
+--------+-------------------------+-----------+--------------+--------------+
| SERIES | TS                      | FORECAST  | LOWER_BOUND  | UPPER_BOUND  |
+--------+-------------------------+-----------+--------------+--------------+
| NULL   | 2020-01-13 00:00:00.000 | 14        | 14           | 14           |
| NULL   | 2020-01-14 00:00:00.000 | 15        | 15           | 15           |
+--------+-------------------------+-----------+--------------+--------------+

-- Example 23761
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

-- Example 23762
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

-- Example 23763
CALL model!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 23764
+--------+------+--------------+---------------+---------------+
| SERIES | RANK | FEATURE_NAME | SCORE         | FEATURE_TYPE  |
+--------+------+--------------+---------------+---------------+
| NULL   |    1 | exog_a       |  31.414947903 | user_provided |
| NULL   |    2 | exog_b       |             0 | user_provided |
+--------+------+--------------+---------------+---------------+

-- Example 23765
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

-- Example 23766
+--------+--------------------------------------------------------------------------+
| SERIES | LOGS                                                                     |
+--------+--------------------------------------------------------------------------+
| "B"    | {   "Errors": [     "At least two unique timestamps are required."   ] } |
| "A"    | NULL                                                                     |
+--------+--------------------------------------------------------------------------+

-- Example 23767
SHOW SNOWFLAKE.ML.FORECAST;

-- Example 23768
DROP SNOWFLAKE.ML.FORECAST my_model;

-- Example 23769
USE ROLE admin;
GRANT USAGE ON DATABASE admin_db TO ROLE analyst;
GRANT USAGE ON SCHEMA admin_schema TO ROLE analyst;
GRANT CREATE SNOWFLAKE.ML.FORECAST ON SCHEMA admin_db.admin_schema TO ROLE analyst;

-- Example 23770
USE ROLE analyst;
USE SCHEMA admin_db.admin_schema;

-- Example 23771
USE ROLE analyst;
CREATE SCHEMA analyst_db.analyst_schema;
USE SCHEMA analyst_db.analyst_schema;

-- Example 23772
REVOKE CREATE SNOWFLAKE.ML.FORECAST ON SCHEMA admin_db.admin_schema FROM ROLE analyst;

-- Example 23773
USE ROLE admin;
GRANT USAGE ON DATABASE admin_db TO ROLE analyst;
GRANT USAGE ON SCHEMA admin_schema TO ROLE analyst;
GRANT CREATE SNOWFLAKE.ML.ANOMALY_DETECTION ON SCHEMA admin_db.admin_schema TO ROLE analyst;

-- Example 23774
USE ROLE analyst;
USE SCHEMA admin_db.admin_schema;

-- Example 23775
USE ROLE analyst;
CREATE SCHEMA analyst_db.analyst_schema;
USE SCHEMA analyst_db.analyst_schema;

-- Example 23776
REVOKE CREATE SNOWFLAKE.ML.ANOMALY_DETECTION ON SCHEMA admin_db.admin_schema FROM ROLE analyst;

-- Example 23777
CREATE OR REPLACE TABLE historical_sales_data (
  store_id NUMBER, item VARCHAR, date TIMESTAMP_NTZ, sales FLOAT, label BOOLEAN,
  temperature NUMBER, humidity FLOAT, holiday VARCHAR);

INSERT INTO historical_sales_data VALUES
  (1, 'jacket', to_timestamp_ntz('2020-01-01'), 2.0, false, 50, 0.3, 'new year'),
  (1, 'jacket', to_timestamp_ntz('2020-01-02'), 3.0, false, 52, 0.3, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-03'), 5.0, false, 54, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-04'), 30.0, true, 54, 0.3, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-05'), 8.0, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-06'), 6.0, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-07'), 4.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-08'), 2.7, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-09'), 8.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-10'), 9.2, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-11'), 4.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-12'), 7.0, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-13'), 3.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-14'), 8.0, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-01'), 3.4, false, 50, 0.3, 'new year'),
  (2, 'umbrella', to_timestamp_ntz('2020-01-02'), 5.0, false, 52, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-03'), 4.0, false, 54, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-04'), 5.4, false, 54, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-05'), 3.7, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-06'), 3.2, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-07'), 3.2, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-08'), 5.6, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-09'), 7.3, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-10'), 8.2, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-11'), 3.7, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-12'), 5.7, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-13'), 6.3, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-14'), 2.9, false, 55, 0.2, null);

-- Example 23778
CREATE OR REPLACE TABLE new_sales_data (
  store_id NUMBER, item VARCHAR, date TIMESTAMP_NTZ, sales FLOAT,
  temperature NUMBER, humidity FLOAT, holiday VARCHAR);

INSERT INTO new_sales_data VALUES
  (1, 'jacket', to_timestamp_ntz('2020-01-16'), 6.0, 52, 0.3, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-17'), 20.0, 53, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-16'), 3.0, 52, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-17'), 70.0, 53, 0.3, null);

-- Example 23779
CREATE SNOWFLAKE.ML.ANOMALY_DETECTION mydetector(...);

-- Example 23780
CALL mydetector!DETECT_ANOMALIES(...);

-- Example 23781
SELECT ts, forecast FROM TABLE(mydetector!DETECT_ANOMALIES(...));

-- Example 23782
SHOW SNOWFLAKE.ML.ANOMALY_DETECTION;

-- Example 23783
DROP SNOWFLAKE.ML.ANOMALY_DETECTION <name>;

-- Example 23784
CREATE OR REPLACE VIEW view_with_training_data
  AS SELECT date, sales FROM historical_sales_data
    WHERE store_id=1 AND item='jacket';

-- Example 23785
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION basic_model(
  INPUT_DATA => TABLE(view_with_training_data),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => '');

-- Example 23786
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION basic_model(
  INPUT_DATA =>
    TABLE(SELECT date, sales FROM historical_sales_data WHERE store_id=1 AND item='jacket'),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => '');

-- Example 23787
+--------------------------------------------+
|                 status                     |
+--------------------------------------------+
| Instance basic_model successfully created. |
+--------------------------------------------+

-- Example 23788
CREATE OR REPLACE VIEW view_with_data_to_analyze
  AS SELECT date, sales FROM new_sales_data
    WHERE store_id=1 and item='jacket';

-- Example 23789
CALL basic_model!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_to_analyze),
  TIMESTAMP_COLNAME =>'date',
  TARGET_COLNAME => 'sales'
);

-- Example 23790
+--------+-------------------------+----+----------+--------------+--------------+------------+--------------+--------------+
| SERIES | TS                      |  Y | FORECAST |  LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |     DISTANCE |
+--------|-------------------------+----+----------+--------------+--------------+------------+--------------+--------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |      4.6 | -7.185885251 | 16.385885251 | False      | 0.6201873452 | 0.3059728606 |
| NULL   | 2020-01-17 00:00:00.000 | 20 |      9   | -2.785885251 | 20.785885251 | False      | 0.9918932208 | 2.404072476  |
+--------+-------------------------+----+----------+--------------+--------------+------------+--------------+--------------|

-- Example 23791
CREATE TABLE my_anomalies AS
  SELECT * FROM TABLE(basic_model!DETECT_ANOMALIES(
    INPUT_DATA => TABLE(view_with_data_to_analyze),
    TIMESTAMP_COLNAME =>'date',
    TARGET_COLNAME => 'sales'
  ));

-- Example 23792
CREATE OR REPLACE VIEW view_with_labeled_data_for_training
  AS SELECT date, sales, label FROM historical_sales_data
    WHERE store_id=1 and item='jacket';

-- Example 23793
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_trained_with_labeled_data(
  INPUT_DATA => TABLE(view_with_labeled_data_for_training),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => 'label'
);

-- Example 23794
CALL model_trained_with_labeled_data!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_to_analyze),
  TIMESTAMP_COLNAME =>'date',
  TARGET_COLNAME => 'sales'
);

-- Example 23795
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+
| SERIES | TS                      |  Y | FORECAST |   LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |   DISTANCE |
+--------|-------------------------+----+----------+---------------+--------------+------------+--------------+------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |        6 |  0.82         | 11.18        | False      | 0.5          | 0          |
| NULL   | 2020-01-17 00:00:00.000 | 20 |        6 | -0.39         | 12.33        | True       | 0.99         | 5.70       |
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+

-- Example 23796
CALL model_trained_with_labeled_data!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_to_analyze),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'prediction_interval':0.995}
);

-- Example 23797
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+
| SERIES | TS                      |  Y | FORECAST |   LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |   DISTANCE |
+--------|-------------------------+----+----------+---------------+--------------+------------+--------------+------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |        6 |  0.36         | 11.64        | False      | 0.5          | 0          |
| NULL   | 2020-01-17 00:00:00.000 | 20 |        6 | -0.90         | 12.90        | True       | 0.99         | 5.70       |
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+

-- Example 23798
CREATE OR REPLACE VIEW view_with_training_data_extra_columns
  AS SELECT date, sales, label, temperature, humidity, holiday
    FROM historical_sales_data
    WHERE store_id=1 AND item='jacket';

-- Example 23799
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_with_additional_columns(
  INPUT_DATA => TABLE(view_with_training_data_extra_columns),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => 'label'
);

-- Example 23800
CREATE OR REPLACE VIEW view_with_data_for_analysis_extra_columns
  AS SELECT date, sales, temperature, humidity, holiday
    FROM new_sales_data
    WHERE store_id=1 AND item='jacket';

-- Example 23801
CALL model_with_additional_columns!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_for_analysis_extra_columns),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'prediction_interval':0.93}
);

-- Example 23802
+--------+-------------------------+----+----------+-------------+--------------+------------+--------------+------------+
| SERIES | TS                      |  Y | FORECAST | LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |   DISTANCE |
+--------|-------------------------+----+----------+-------------+--------------+------------+--------------+------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |        6 | 2.34        |  9.64        | False      | 0.5          | 0          |
| NULL   | 2020-01-17 00:00:00.000 | 20 |        6 | 1.56        | 10.451       | True       | 0.99         | 5.70       |
+--------+-------------------------+----+----------+-------------+--------------+------------+--------------+------------+

-- Example 23803
CREATE OR REPLACE VIEW view_with_training_data_multiple_series
  AS SELECT
    [store_id, item] AS store_item,
    date,
    sales,
    label,
    temperature,
    humidity,
    holiday
  FROM historical_sales_data;

-- Example 23804
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_for_multiple_series(
  INPUT_DATA => TABLE(view_with_training_data_multiple_series),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => 'label'
);

-- Example 23805
CREATE OR REPLACE VIEW view_with_data_for_analysis_multiple_series
  AS SELECT
    [store_id, item] AS store_item,
    date,
    sales,
    temperature,
    humidity,
    holiday
  FROM new_sales_data;

-- Example 23806
CALL model_for_multiple_series!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_for_analysis_multiple_series),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'prediction_interval':0.995}
);

-- Example 23807
+--------------+-------------------------+----+----------+---------------+--------------+------------+---------------+--------------+
| SERIES       | TS                      |  Y | FORECAST |   LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |    PERCENTILE |     DISTANCE |
|--------------+-------------------------+----+----------+---------------+--------------+------------+---------------+--------------|
| [            | 2020-01-16 00:00:00.000 |  3 |      6.3 |  2.07         | 10.53        | False      | 0.01          | -2.19         |
|   2,         |                         |    |          |               |              |            |               |              |
|   "umbrella" |                         |    |          |               |              |            |               |              |
| ]            |                         |    |          |               |              |            |               |              |
| [            | 2020-01-17 00:00:00.000 | 70 |      2.9 | -1.33         |  7.13        | True       | 1             | 44.54         |
|   2,         |                         |    |          |               |              |            |               |              |
|   "umbrella" |                         |    |          |               |              |            |               |              |
| ]            |                         |    |          |               |              |            |               |              |
| [            | 2020-01-16 00:00:00.000 |  6 |      6   |  0.36         | 11.64        | False      | 0.5           |  0           |
|   1,         |                         |    |          |               |              |            |               |              |
|   "jacket"   |                         |    |          |               |              |            |               |              |
| ]            |                         |    |          |               |              |            |               |              |
| [            | 2020-01-17 00:00:00.000 | 20 |      6   | -0.90         | 12.90        | True       | 0.99          |  5.70         |
|   1,         |                         |    |          |               |              |            |               |              |
|   "jacket"   |                         |    |          |               |              |            |               |              |
| ]            |                         |    |          |               |              |            |               |              |
+--------------+-------------------------+----+----------+---------------+--------------+------------+---------------+--------------+

-- Example 23808
CREATE OR REPLACE TASK ad_model_retrain_task
WAREHOUSE = <your_warehouse_name>
SCHEDULE = '60 MINUTE'
AS
EXECUTE IMMEDIATE
$$
BEGIN
  CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_trained_with_labeled_data(
    INPUT_DATA => TABLE(view_with_labeled_data_for_training),
    TIMESTAMP_COLNAME => 'date',
    TARGET_COLNAME => 'sales',
    LABEL_COLNAME => 'label'
  );
END;
$$;

-- Example 23809
ALTER TASK ad_model_retrain_task RESUME;

-- Example 23810
ALTER TASK ad_model_retrain_task SUSPEND;

-- Example 23811
CREATE OR REPLACE TABLE anomaly_res_table (
  ts TIMESTAMP_NTZ, y FLOAT, forecast FLOAT, lower_bound FLOAT, upper_bound FLOAT,
  is_anomaly BOOLEAN, percentile FLOAT, distance FLOAT);

-- Example 23812
CREATE OR REPLACE TASK ad_model_monitoring_task
WAREHOUSE = snowhouse
SCHEDULE = '1 minute'
AS
EXECUTE IMMEDIATE
$$
BEGIN
  INSERT INTO anomaly_res_table (ts, y, forecast, lower_bound, upper_bound, is_anomaly, percentile, distance)
    SELECT * FROM TABLE(
      model_trained_with_labeled_data!DETECT_ANOMALIES(
        INPUT_DATA => TABLE(view_with_data_to_analyze),
        TIMESTAMP_COLNAME => 'date',
        TARGET_COLNAME => 'sales',
        CONFIG_OBJECT => {'prediction_interval':0.99}
    )
  );
END;
$$;

-- Example 23813
ALTER TASK ad_model_monitoring_task RESUME;

-- Example 23814
ALTER TASK ad_model_monitoring_task SUSPEND;

-- Example 23815
CREATE OR REPLACE PROCEDURE extract_anomalies()
  RETURNS TABLE()
  LANGUAGE SQL
  AS
  $$
    BEGIN
      let res RESULTSET := (SELECT * FROM TABLE(
        model_trained_with_labeled_data!DETECT_ANOMALIES(
          INPUT_DATA => TABLE(view_with_data_to_analyze),
          TIMESTAMP_COLNAME => 'date',
          TARGET_COLNAME => 'sales',
          CONFIG_OBJECT => {'prediction_interval':0.99}
        ))
        WHERE is_anomaly = TRUE
      );
      RETURN TABLE(res);
    END;
  $$
  ;

CREATE OR REPLACE ALERT sample_sales_alert
WAREHOUSE = <your_warehouse_name>
SCHEDULE = '1 MINUTE'
IF (EXISTS (CALL extract_anomalies()))
THEN
CALL SYSTEM$SEND_EMAIL(
  'sales_email_alert',
  'your_email@snowflake.com',
  'Anomalous Sales Data Detected in data stream',
  CONCAT(
    'Anomalous Sales Data Detected in data stream \n',
    'Value outside of prediction interval detected in the most recent run at ',
    current_timestamp(1)
  ));

-- Example 23816
ALTER ALERT sample_sales_alert RESUME;

-- Example 23817
ALTER ALERT sample_sales_alert SUSPEND;

-- Example 23818
CREATE OR REPLACE VIEW v_random_data AS SELECT
  DATEADD('minute', ROW_NUMBER() over (ORDER BY 1), '2023-12-01')::TIMESTAMP_NTZ ts,
  MOD(SEQ1(),10) y,
  UNIFORM(1, 100, RANDOM(0)) exog_a
FROM TABLE(GENERATOR(ROWCOUNT => 500));

CREATE OR REPLACE VIEW v_feature_importance_demo AS SELECT
  ts,
  y,
  exog_a
FROM v_random_data;

SELECT * FROM v_feature_importance_demo;

CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION anomaly_model_feature_importance_demo(
  INPUT_DATA => TABLE(v_feature_importance_demo),
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'y',
  LABEL_COLNAME => ''
);

CALL anomaly_model_feature_importance_demo!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 23819
+--------+------+--------------------------------------+-------+-------------------------+
| SERIES | RANK | FEATURE_NAME                         | SCORE | FEATURE_TYPE            |
+--------+------+--------------------------------------+-------+-------------------------+
| NULL   |    1 | aggregated_endogenous_trend_features |  0.36 | derived_from_endogenous |
| NULL   |    2 | exog_a                               |  0.22 | user_provided           |
| NULL   |    3 | epoch_time                           |  0.15 | derived_from_timestamp  |
| NULL   |    4 | minute                               |  0.13 | derived_from_timestamp  |
| NULL   |    5 | lag60                                |  0.07 | derived_from_endogenous |
| NULL   |    6 | lag120                               |  0.06 | derived_from_endogenous |
| NULL   |    7 | hour                                 |  0.01 | derived_from_timestamp  |
+--------+------+--------------------------------------+-------+-------------------------+

-- Example 23820
CREATE TABLE t_error(date TIMESTAMP_NTZ, sales FLOAT, series VARCHAR);
INSERT INTO t_error VALUES
  (TO_TIMESTAMP_NTZ('2019-12-20'), 1.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-21'), 2.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-22'), 3.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-23'), 2.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-24'), 1.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-25'), 2.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-26'), 3.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-27'), 2.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-28'), 1.0, 'A'),
  (TO_TIMESTAMP_NTZ('2019-12-29'), 2.0, 'A'),
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

CREATE SNOWFLAKE.ML.ANOMALY_DETECTION model(
  INPUT_DATA => TABLE(SELECT date, sales, series FROM t_error),
  SERIES_COLNAME => 'series',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => '',
  CONFIG_OBJECT => {'ON_ERROR': 'SKIP'}
);

CALL model!SHOW_TRAINING_LOGS();

-- Example 23821
+--------+--------------------------------------------------------------------------+
| SERIES | LOGS                                                                     |
+--------+--------------------------------------------------------------------------+
| "B"    | {   "Errors": [     "At least two unique timestamps are required."   ] } |
| "A"    | NULL                                                                     |
+--------+--------------------------------------------------------------------------+

-- Example 23822
CREATE SNOWFLAKE.ML.TOP_INSIGHTS IF NOT EXISTS my_insights();

-- Example 23823
CALL my_insights!get_drivers (
  INPUT_DATA => TABLE(my_table),
  LABEL_COLNAME => 'label',
  METRIC_COLNAMe => 'sales');

-- Example 23824
CREATE VIEW input_table_time_series_label (
  ds, metric, dim_country, dim_vertical, label ) AS
  SELECT
    ds,
    metric,
    dim_country,
    dim_vertical,
    ds >= dateadd(month, -1, current_date) AS label
  FROM input_table;

-- Example 23825
CREATE VIEW input_table_vertical_label (
  ds, metric,  dim_country, dim_vertical, label ) AS
  SELECT
    ds,
    metric,
    dim_country,
    dim_vertical,
    dim_country <> 'USA' as label
  FROM input_table;

-- Example 23826
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

