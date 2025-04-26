-- Example 20212
CREATE OR REPLACE VIEW view_with_training_data
  AS SELECT date, sales FROM historical_sales_data
    WHERE store_id=1 AND item='jacket';

-- Example 20213
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION basic_model(
  INPUT_DATA => TABLE(view_with_training_data),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => '');

-- Example 20214
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION basic_model(
  INPUT_DATA =>
    TABLE(SELECT date, sales FROM historical_sales_data WHERE store_id=1 AND item='jacket'),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => '');

-- Example 20215
+--------------------------------------------+
|                 status                     |
+--------------------------------------------+
| Instance basic_model successfully created. |
+--------------------------------------------+

-- Example 20216
CREATE OR REPLACE VIEW view_with_data_to_analyze
  AS SELECT date, sales FROM new_sales_data
    WHERE store_id=1 and item='jacket';

-- Example 20217
CALL basic_model!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_to_analyze),
  TIMESTAMP_COLNAME =>'date',
  TARGET_COLNAME => 'sales'
);

-- Example 20218
+--------+-------------------------+----+----------+--------------+--------------+------------+--------------+--------------+
| SERIES | TS                      |  Y | FORECAST |  LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |     DISTANCE |
+--------|-------------------------+----+----------+--------------+--------------+------------+--------------+--------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |      4.6 | -7.185885251 | 16.385885251 | False      | 0.6201873452 | 0.3059728606 |
| NULL   | 2020-01-17 00:00:00.000 | 20 |      9   | -2.785885251 | 20.785885251 | False      | 0.9918932208 | 2.404072476  |
+--------+-------------------------+----+----------+--------------+--------------+------------+--------------+--------------|

-- Example 20219
CREATE TABLE my_anomalies AS
  SELECT * FROM TABLE(basic_model!DETECT_ANOMALIES(
    INPUT_DATA => TABLE(view_with_data_to_analyze),
    TIMESTAMP_COLNAME =>'date',
    TARGET_COLNAME => 'sales'
  ));

-- Example 20220
CREATE OR REPLACE VIEW view_with_labeled_data_for_training
  AS SELECT date, sales, label FROM historical_sales_data
    WHERE store_id=1 and item='jacket';

-- Example 20221
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_trained_with_labeled_data(
  INPUT_DATA => TABLE(view_with_labeled_data_for_training),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => 'label'
);

-- Example 20222
CALL model_trained_with_labeled_data!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_to_analyze),
  TIMESTAMP_COLNAME =>'date',
  TARGET_COLNAME => 'sales'
);

-- Example 20223
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+
| SERIES | TS                      |  Y | FORECAST |   LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |   DISTANCE |
+--------|-------------------------+----+----------+---------------+--------------+------------+--------------+------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |        6 |  0.82         | 11.18        | False      | 0.5          | 0          |
| NULL   | 2020-01-17 00:00:00.000 | 20 |        6 | -0.39         | 12.33        | True       | 0.99         | 5.70       |
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+

-- Example 20224
CALL model_trained_with_labeled_data!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_to_analyze),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'prediction_interval':0.995}
);

-- Example 20225
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+
| SERIES | TS                      |  Y | FORECAST |   LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |   DISTANCE |
+--------|-------------------------+----+----------+---------------+--------------+------------+--------------+------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |        6 |  0.36         | 11.64        | False      | 0.5          | 0          |
| NULL   | 2020-01-17 00:00:00.000 | 20 |        6 | -0.90         | 12.90        | True       | 0.99         | 5.70       |
+--------+-------------------------+----+----------+---------------+--------------+------------+--------------+------------+

-- Example 20226
CREATE OR REPLACE VIEW view_with_training_data_extra_columns
  AS SELECT date, sales, label, temperature, humidity, holiday
    FROM historical_sales_data
    WHERE store_id=1 AND item='jacket';

-- Example 20227
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_with_additional_columns(
  INPUT_DATA => TABLE(view_with_training_data_extra_columns),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => 'label'
);

-- Example 20228
CREATE OR REPLACE VIEW view_with_data_for_analysis_extra_columns
  AS SELECT date, sales, temperature, humidity, holiday
    FROM new_sales_data
    WHERE store_id=1 AND item='jacket';

-- Example 20229
CALL model_with_additional_columns!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_for_analysis_extra_columns),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'prediction_interval':0.93}
);

-- Example 20230
+--------+-------------------------+----+----------+-------------+--------------+------------+--------------+------------+
| SERIES | TS                      |  Y | FORECAST | LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |   DISTANCE |
+--------|-------------------------+----+----------+-------------+--------------+------------+--------------+------------|
| NULL   | 2020-01-16 00:00:00.000 |  6 |        6 | 2.34        |  9.64        | False      | 0.5          | 0          |
| NULL   | 2020-01-17 00:00:00.000 | 20 |        6 | 1.56        | 10.451       | True       | 0.99         | 5.70       |
+--------+-------------------------+----+----------+-------------+--------------+------------+--------------+------------+

-- Example 20231
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

-- Example 20232
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION model_for_multiple_series(
  INPUT_DATA => TABLE(view_with_training_data_multiple_series),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  LABEL_COLNAME => 'label'
);

-- Example 20233
CREATE OR REPLACE VIEW view_with_data_for_analysis_multiple_series
  AS SELECT
    [store_id, item] AS store_item,
    date,
    sales,
    temperature,
    humidity,
    holiday
  FROM new_sales_data;

-- Example 20234
CALL model_for_multiple_series!DETECT_ANOMALIES(
  INPUT_DATA => TABLE(view_with_data_for_analysis_multiple_series),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'prediction_interval':0.995}
);

-- Example 20235
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

-- Example 20236
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

-- Example 20237
ALTER TASK ad_model_retrain_task RESUME;

-- Example 20238
ALTER TASK ad_model_retrain_task SUSPEND;

-- Example 20239
CREATE OR REPLACE TABLE anomaly_res_table (
  ts TIMESTAMP_NTZ, y FLOAT, forecast FLOAT, lower_bound FLOAT, upper_bound FLOAT,
  is_anomaly BOOLEAN, percentile FLOAT, distance FLOAT);

-- Example 20240
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

-- Example 20241
ALTER TASK ad_model_monitoring_task RESUME;

-- Example 20242
ALTER TASK ad_model_monitoring_task SUSPEND;

-- Example 20243
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

-- Example 20244
ALTER ALERT sample_sales_alert RESUME;

-- Example 20245
ALTER ALERT sample_sales_alert SUSPEND;

-- Example 20246
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

-- Example 20247
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

-- Example 20248
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

-- Example 20249
+--------+--------------------------------------------------------------------------+
| SERIES | LOGS                                                                     |
+--------+--------------------------------------------------------------------------+
| "B"    | {   "Errors": [     "At least two unique timestamps are required."   ] } |
| "A"    | NULL                                                                     |
+--------+--------------------------------------------------------------------------+

-- Example 20250
references:
  - consumer_table:
      label: "Consumer table"
      description: "A table in the consumer account that exists outside the APPLICATION object."
      privileges:
        - INSERT
        - SELECT
      object_type: TABLE
      multi_valued: false
      register_callback: config.register_single_reference

-- Example 20251
Reference definition '<REF_DEF_NAME>' cannot be found in the current version of the application '<APP_NAME>'

-- Example 20252
CREATE APPLICATION ROLE app_admin;

CREATE OR ALTER VERSIONED SCHEMA config;
GRANT USAGE ON SCHEMA config TO APPLICATION ROLE app_admin;

CREATE PROCEDURE CONFIG.REGISTER_SINGLE_REFERENCE(ref_name STRING, operation STRING, ref_or_alias STRING)
  RETURNS STRING
  LANGUAGE SQL
  AS $$
    BEGIN
      CASE (operation)
        WHEN 'ADD' THEN
          SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
        WHEN 'REMOVE' THEN
          SELECT SYSTEM$REMOVE_REFERENCE(:ref_name, :ref_or_alias);
        WHEN 'CLEAR' THEN
          SELECT SYSTEM$REMOVE_ALL_REFERENCES(:ref_name);
      ELSE
        RETURN 'unknown operation: ' || operation;
      END CASE;
      RETURN NULL;
    END;
  $$;

GRANT USAGE ON PROCEDURE CONFIG.REGISTER_SINGLE_REFERENCE(STRING, STRING, STRING)
  TO APPLICATION ROLE app_admin;

-- Example 20253
CREATE OR REPLACE CONFIG.GET_CONFIGURATION_FOR_REFERENCE(ref_name STRING)
  RETURNS STRING
  LANGUAGE SQL
  AS
  $$
  BEGIN
    CASE (ref_name)
      WHEN 'CONSUMER_EXTERNAL_ACCESS' THEN
        RETURN '{
          "type": "CONFIGURATION",
          "payload":{
            "host_ports":["google.com"],
            "allowed_secrets" : "LIST",
            "secret_references":["CONSUMER_SECRET"]}}';
      WHEN 'CONSUMER_SECRET' THEN
        RETURN '{
          "type": "CONFIGURATION",
          "payload":{
            "type" : "OAUTH2",
            "security_integration": {
              "oauth_scopes": ["https://www.googleapis.com/auth/analytics.readonly"],
              "oauth_token_endpoint": "https://oauth2.googleapis.com/token",
              "oauth_authorization_endpoint":
                "https://accounts.google.com/o/oauth2/auth"}}}';
     END CASE;
     RETURN '';
   END;
   $$;

GRANT USAGE ON PROCEDURE CONFIG.GET_CONFIGURATION_FOR_REFERENCE(STRING)
  TO APPLICATION ROLE app_admin;

-- Example 20254
SHOW REFERENCES IN APPLICATION hello_snowflake_app;

-- Example 20255
SELECT SYSTEM$REFERENCE('table', 'db1.schema1.table1', 'persistent', 'select', 'insert');

-- Example 20256
CALL app.config.register_single_reference(
  'consumer_table' , 'ADD', SYSTEM$REFERENCE('TABLE', 'db1.schema1.table1', 'PERSISTENT', 'SELECT', 'INSERT'));

-- Example 20257
SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);

-- Example 20258
SELECT * FROM reference('consumer_table');

-- Example 20259
SELECT reference('encrypt_func')(t.c1) FROM consumer_table t;

-- Example 20260
CALL reference('consumer_proc')(11, 'hello world');

-- Example 20261
INSERT INTO reference('data_export')(C1, C2)
  SELECT T.C1, T.C2 FROM reference('other_table')

-- Example 20262
COPY INTO reference('the_table') ...

-- Example 20263
DESCRIBE TABLE reference('the_table')

-- Example 20264
CREATE TASK app_task
  WAREHOUSE = reference('consumer_warehouse')
  ...;

ALTER TASK app_task SET WAREHOUSE = reference('consumer_warehouse');

-- Example 20265
CREATE VIEW app_view
  AS SELECT reference('function')(T.C1) FROM reference('table') AS T;

-- Example 20266
CREATE FUNCTION app.func(x INT)
  RETURNS STRING
  AS $$ select reference('consumer_func')(x) $$;

-- Example 20267
CREATE EXTERNAL FUNCTION app.func(x INT)
  RETURNS STRING
  ...
  API_INTEGRATION = reference('app_integration');

-- Example 20268
CREATE FUNCTION app.func(x INT)
  RETURNS STRING
  ...
  EXTERNAL_ACCESS_INTEGRATIONS = (reference('consumer_external_access_integration'), ...);
  SECRETS = ('cred1' = reference('consumer_secret'), ...);

-- Example 20269
CREATE ROW ACCESS POLICY app_policy
  AS (sales_region varchar) RETURNS BOOLEAN ->
  'sales_executive_role' = reference('get_sales_team')
    or exists (
      select 1 from reference('sales_table')
        where sales_manager = reference('get_sales_team')()
        and region = sales_region
      );

-- Example 20270
{
  "type": "CONFIGURATION",
  "payload": {
    "host_ports": ["host_port_1", ...],
    "allowed_secrets": "NONE|ALL|LIST",
    "secret_references": ["ref_name_1", ...]
  }
}

-- Example 20271
{
  "type": "CONFIGURATION",
    "payload": {
            "type": "OAUTH2",
            "security_integration": {
                    "oauth_scopes": ["scope_1", "scope_2"],
                    "oauth_token_endpoint" : "token_endpoint",
                    "oauth_authorization_endpoint" : "auth_endpoint"
            }
    }
}

-- Example 20272
{
   "type": "ERROR",
   "payload":{
     "message": "The reference is not available for configuration ..."
  }
}

-- Example 20273
EXECUTE IMMEDIATE '<string_literal>'
    [ USING ( <bind_variable> [ , <bind_variable> ... ] ) ]

EXECUTE IMMEDIATE <variable>
    [ USING ( <bind_variable> [ , <bind_variable> ... ] ) ]

EXECUTE IMMEDIATE $<session_variable>
    [ USING ( <bind_variable> [ , <bind_variable> ... ] ) ]

-- Example 20274
CREATE PROCEDURE execute_immediate_local_variable()
RETURNS VARCHAR
AS
DECLARE
  v1 VARCHAR DEFAULT 'CREATE TABLE temporary1 (i INTEGER)';
  v2 VARCHAR DEFAULT 'INSERT INTO temporary1 (i) VALUES (76)';
  result INTEGER DEFAULT 0;
BEGIN
  EXECUTE IMMEDIATE v1;
  EXECUTE IMMEDIATE v2  ||  ',(80)'  ||  ',(84)';
  result := (SELECT SUM(i) FROM temporary1);
  RETURN result::VARCHAR;
END;

-- Example 20275
CREATE PROCEDURE execute_immediate_local_variable()
RETURNS VARCHAR
AS
$$
DECLARE
  v1 VARCHAR DEFAULT 'CREATE TABLE temporary1 (i INTEGER)';
  v2 VARCHAR DEFAULT 'INSERT INTO temporary1 (i) VALUES (76)';
  result INTEGER DEFAULT 0;
BEGIN
  EXECUTE IMMEDIATE v1;
  EXECUTE IMMEDIATE v2  ||  ',(80)'  ||  ',(84)';
  result := (SELECT SUM(i) FROM temporary1);
  RETURN result::VARCHAR;
END;
$$;

-- Example 20276
CALL execute_immediate_local_variable();

-- Example 20277
+----------------------------------+
| EXECUTE_IMMEDIATE_LOCAL_VARIABLE |
|----------------------------------|
| 240                              |
+----------------------------------+

-- Example 20278
CREATE OR REPLACE TABLE invoices (id INTEGER, price NUMBER(12, 2));

INSERT INTO invoices (id, price) VALUES
  (1, 11.11),
  (2, 22.22);

