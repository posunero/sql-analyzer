-- Example 23693
WITH t1 AS (SELECT * FROM t1 WHERE t1 ...)
SELECT ...
  FROM t1
    ASOF JOIN (SELECT * FROM t2 WHERE t2.c1 IN (SELECT t1.c1 FROM t1)) AS t2
      MATCH_CONDITION(...)
      ON t1.c1 = t2.c1;

-- Example 23694
SELECT * FROM asof;

WITH match_condition AS (SELECT * FROM T1) SELECT * FROM match_condition;

-- Example 23695
SELECT * FROM "asof";

WITH "match_condition" AS (SELECT * FROM T1) SELECT * FROM "match_condition";

-- Example 23696
SELECT * FROM "ASOF";

WITH "MATCH_CONDITION" AS (SELECT * FROM T1) SELECT * FROM "MATCH_CONDITION";

-- Example 23697
SELECT * FROM t1 asof;

SELECT * FROM t2 match_condition;

-- Example 23698
SELECT * FROM t1 AS asof;

SELECT * FROM t1 "asof";

SELECT * FROM t2 AS match_condition;

SELECT * FROM t2 "match_condition";

-- Example 23699
INSERT INTO trades VALUES('SNOW','2023-09-30 12:02:55.000',3000);

-- Example 23700
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       1 |
+-------------------------+

-- Example 23701
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time >= quote_time)
    ON t.stock_symbol=q.stock_symbol
  ORDER BY t.stock_symbol;

-- Example 23702
+--------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:03.000 | 139.00000000 |
| SNOW         | 2023-09-30 12:02:55.000 |     3000 | NULL                    |         NULL |
| SNOW         | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:02.000 | 163.00000000 |
| SNOW         | 2023-10-01 09:00:10.000 |     1500 | 2023-10-01 09:00:08.000 | 165.00000000 |
+--------------+-------------------------+----------+-------------------------+--------------+

-- Example 23703
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time <= quote_time)
    ON t.stock_symbol=q.stock_symbol
  ORDER BY t.stock_symbol;

-- Example 23704
+--------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:07.000 | 142.00000000 |
| SNOW         | 2023-10-01 09:00:10.000 |     1500 | NULL                    |         NULL |
| SNOW         | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:07.000 | 166.00000000 |
| SNOW         | 2023-09-30 12:02:55.000 |     3000 | 2023-10-01 09:00:01.000 | 166.00000000 |
+--------------+-------------------------+----------+-------------------------+--------------+

-- Example 23705
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time <= quote_time)
    USING(stock_symbol)
  ORDER BY t.stock_symbol;

-- Example 23706
CREATE OR REPLACE TABLE companies(
  stock_symbol VARCHAR(4),
  company_name VARCHAR(100)
);

 INSERT INTO companies VALUES
  ('NVDA','NVIDIA Corp'),
  ('TSLA','Tesla Inc'),
  ('SNOW','Snowflake Inc'),
  ('AAPL','Apple Inc')
;

-- Example 23707
SELECT t.stock_symbol, c.company_name, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time >= quote_time)
    ON t.stock_symbol=q.stock_symbol
    INNER JOIN companies c ON c.stock_symbol=t.stock_symbol
  ORDER BY t.stock_symbol;

-- Example 23708
+--------------+---------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | COMPANY_NAME  | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+---------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | Apple Inc     | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:03.000 | 139.00000000 |
| SNOW         | Snowflake Inc | 2023-09-30 12:02:55.000 |     3000 | NULL                    |         NULL |
| SNOW         | Snowflake Inc | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:02.000 | 163.00000000 |
| SNOW         | Snowflake Inc | 2023-10-01 09:00:10.000 |     1500 | 2023-10-01 09:00:08.000 | 165.00000000 |
+--------------+---------------+-------------------------+----------+-------------------------+--------------+

-- Example 23709
SELECT * FROM trades_unixtime;

-- Example 23710
+--------------+------------+----------+--------------+
| STOCK_SYMBOL | TRADE_TIME | QUANTITY |        PRICE |
|--------------+------------+----------+--------------|
| SNOW         | 1696150805 |      100 | 165.33300000 |
+--------------+------------+----------+--------------+

-- Example 23711
SELECT * FROM quotes_unixtime;

-- Example 23712
+--------------+------------+----------+--------------+--------------+
| STOCK_SYMBOL | QUOTE_TIME | QUANTITY |          BID |          ASK |
|--------------+------------+----------+--------------+--------------|
| SNOW         | 1696150802 |      100 | 166.00000000 | 165.00000000 |
+--------------+------------+----------+--------------+--------------+

-- Example 23713
SELECT *
  FROM trades_unixtime tu
    ASOF JOIN quotes_unixtime qu
    MATCH_CONDITION(tu.trade_time>=qu.quote_time);

-- Example 23714
+--------------+------------+----------+--------------+--------------+------------+----------+--------------+--------------+
| STOCK_SYMBOL | TRADE_TIME | QUANTITY |        PRICE | STOCK_SYMBOL | QUOTE_TIME | QUANTITY |          BID |          ASK |
|--------------+------------+----------+--------------+--------------+------------+----------+--------------+--------------|
| SNOW         | 1696150805 |      100 | 165.33300000 | SNOW         | 1696150802 |      100 | 166.00000000 | 165.00000000 |
+--------------+------------+----------+--------------+--------------+------------+----------+--------------+--------------+

-- Example 23715
CREATE OR REPLACE TABLE raintime(
  observed TIME(9),
  location VARCHAR(40),
  state VARCHAR(2),
  observation NUMBER(5,2)
);

INSERT INTO raintime VALUES
  ('14:42:59.230', 'Ahwahnee', 'CA', 0.90),
  ('14:42:59.001', 'Oakhurst', 'CA', 0.50),
  ('14:42:44.435', 'Reno', 'NV', 0.00)
;

CREATE OR REPLACE TABLE preciptime(
  observed TIME(9),
  location VARCHAR(40),
  state VARCHAR(2),
  observation NUMBER(5,2)
);

INSERT INTO preciptime VALUES
  ('14:42:59.230', 'Ahwahnee', 'CA', 0.91),
  ('14:42:59.001', 'Oakhurst', 'CA', 0.51),
  ('14:41:44.435', 'Las Vegas', 'NV', 0.01),
  ('14:42:44.435', 'Reno', 'NV', 0.01),
  ('14:40:34.000', 'Bozeman', 'MT', 1.11)
;

CREATE OR REPLACE TABLE snowtime(
  observed TIME(9),
  location VARCHAR(40),
  state VARCHAR(2),
  observation NUMBER(5,2)
);

INSERT INTO snowtime VALUES
  ('14:42:59.199', 'Fish Camp', 'CA', 3.20),
  ('14:42:44.435', 'Reno', 'NV', 3.00),
  ('14:43:01.000', 'Lake Tahoe', 'CA', 4.20),
  ('14:42:45.000', 'Bozeman', 'MT', 1.80)
;

-- Example 23716
SELECT * FROM preciptime p ASOF JOIN snowtime s MATCH_CONDITION(p.observed>=s.observed)
  ORDER BY p.observed;

-- Example 23717
+----------+-----------+-------+-------------+----------+-----------+-------+-------------+
| OBSERVED | LOCATION  | STATE | OBSERVATION | OBSERVED | LOCATION  | STATE | OBSERVATION |
|----------+-----------+-------+-------------+----------+-----------+-------+-------------|
| 14:40:34 | Bozeman   | MT    |        1.11 | NULL     | NULL      | NULL  |        NULL |
| 14:41:44 | Las Vegas | NV    |        0.01 | NULL     | NULL      | NULL  |        NULL |
| 14:42:44 | Reno      | NV    |        0.01 | 14:42:44 | Reno      | NV    |        3.00 |
| 14:42:59 | Oakhurst  | CA    |        0.51 | 14:42:45 | Bozeman   | MT    |        1.80 |
| 14:42:59 | Ahwahnee  | CA    |        0.91 | 14:42:59 | Fish Camp | CA    |        3.20 |
+----------+-----------+-------+-------------+----------+-----------+-------+-------------+

-- Example 23718
ALTER SESSION SET TIME_OUTPUT_FORMAT = 'HH24:MI:SS.FF3';

-- Example 23719
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 23720
SELECT * FROM preciptime p ASOF JOIN snowtime s MATCH_CONDITION(p.observed>=s.observed)
  ORDER BY p.observed;

-- Example 23721
+--------------+-----------+-------+-------------+--------------+-----------+-------+-------------+
| OBSERVED     | LOCATION  | STATE | OBSERVATION | OBSERVED     | LOCATION  | STATE | OBSERVATION |
|--------------+-----------+-------+-------------+--------------+-----------+-------+-------------|
| 14:40:34.000 | Bozeman   | MT    |        1.11 | NULL         | NULL      | NULL  |        NULL |
| 14:41:44.435 | Las Vegas | NV    |        0.01 | NULL         | NULL      | NULL  |        NULL |
| 14:42:44.435 | Reno      | NV    |        0.01 | 14:42:44.435 | Reno      | NV    |        3.00 |
| 14:42:59.001 | Oakhurst  | CA    |        0.51 | 14:42:45.000 | Bozeman   | MT    |        1.80 |
| 14:42:59.230 | Ahwahnee  | CA    |        0.91 | 14:42:59.199 | Fish Camp | CA    |        3.20 |
+--------------+-----------+-------+-------------+--------------+-----------+-------+-------------+

-- Example 23722
ALTER SESSION SET TIME_OUTPUT_FORMAT = 'HH24:MI:SS.FF3';

SELECT *
  FROM snowtime s
    ASOF JOIN raintime r
      MATCH_CONDITION(s.observed>=r.observed)
      ON s.state=r.state
    ASOF JOIN preciptime p
      MATCH_CONDITION(s.observed>=p.observed)
      ON s.state=p.state
  ORDER BY s.observed;

-- Example 23723
+--------------+------------+-------+-------------+--------------+----------+-------+-------------+--------------+----------+-------+-------------+
| OBSERVED     | LOCATION   | STATE | OBSERVATION | OBSERVED     | LOCATION | STATE | OBSERVATION | OBSERVED     | LOCATION | STATE | OBSERVATION |
|--------------+------------+-------+-------------+--------------+----------+-------+-------------+--------------+----------+-------+-------------|
| 14:42:44.435 | Reno       | NV    |        3.00 | 14:42:44.435 | Reno     | NV    |        0.00 | 14:42:44.435 | Reno     | NV    |        0.01 |
| 14:42:45.000 | Bozeman    | MT    |        1.80 | NULL         | NULL     | NULL  |        NULL | 14:40:34.000 | Bozeman  | MT    |        1.11 |
| 14:42:59.199 | Fish Camp  | CA    |        3.20 | 14:42:59.001 | Oakhurst | CA    |        0.50 | 14:42:59.001 | Oakhurst | CA    |        0.51 |
| 14:43:01.000 | Lake Tahoe | CA    |        4.20 | 14:42:59.230 | Ahwahnee | CA    |        0.90 | 14:42:59.230 | Ahwahnee | CA    |        0.91 |
+--------------+------------+-------+-------------+--------------+----------+-------+-------------+--------------+----------+-------+-------------+

-- Example 23724
SELECT *
  FROM snowtime s
    ASOF JOIN raintime r
      MATCH_CONDITION(s.observed>r.observed)
      ON s.state=r.state
    ASOF JOIN preciptime p
      MATCH_CONDITION(s.observed<p.observed)
      ON s.state=p.state
  ORDER BY s.observed;

-- Example 23725
+--------------+------------+-------+-------------+--------------+-----------+-------+-------------+--------------+----------+-------+-------------+
| OBSERVED     | LOCATION   | STATE | OBSERVATION | OBSERVED     | LOCATION  | STATE | OBSERVATION | OBSERVED     | LOCATION | STATE | OBSERVATION |
|--------------+------------+-------+-------------+--------------+-----------+-------+-------------+--------------+----------+-------+-------------|
| 14:42:44.435 | Reno       | NV    |        3.00 | 14:41:44.435 | Las Vegas | NV    |        0.00 | NULL         | NULL     | NULL  |        NULL |
| 14:42:45.000 | Bozeman    | MT    |        1.80 | NULL         | NULL      | NULL  |        NULL | NULL         | NULL     | NULL  |        NULL |
| 14:42:59.199 | Fish Camp  | CA    |        3.20 | 14:42:59.001 | Oakhurst  | CA    |        0.50 | 14:42:59.230 | Ahwahnee | CA    |        0.91 |
| 14:43:01.000 | Lake Tahoe | CA    |        4.20 | 14:42:59.230 | Ahwahnee  | CA    |        0.90 | NULL         | NULL     | NULL  |        NULL |
+--------------+------------+-------+-------------+--------------+-----------+-------+-------------+--------------+----------+-------+-------------+

-- Example 23726
SELECT * FROM snowtime s ASOF JOIN preciptime p MATCH_CONDITION(p.observed>=s.observed);

-- Example 23727
010002 (42601): SQL compilation error:
MATCH_CONDITION clause is invalid: The left side allows only column references from the left side table, and the right side allows only column references from the right side table.

-- Example 23728
SELECT * FROM preciptime p ASOF JOIN snowtime s MATCH_CONDITION(p.observed=s.observed);

-- Example 23729
010001 (42601): SQL compilation error:
MATCH_CONDITION clause is invalid: Only comparison operators '>=', '>', '<=' and '<' are allowed. Keywords such as AND and OR are not allowed.

-- Example 23730
SELECT *
  FROM preciptime p ASOF JOIN snowtime s
  MATCH_CONDITION(p.observed>=s.observed)
  ON s.state>=p.state;

-- Example 23731
010010 (42601): SQL compilation error:
ON clause for ASOF JOIN must contain conjunctions of equality conditions only. Disjunctions are not allowed. Each side of an equality condition must only refer to either the left table or the right table. S.STATE >= P.STATE is invalid.

-- Example 23732
SELECT *
  FROM preciptime p ASOF JOIN snowtime s
  MATCH_CONDITION(p.observed>=s.observed)
  ON s.state=p.state OR s.location=p.location;

-- Example 23733
010010 (42601): SQL compilation error:
ON clause for ASOF JOIN must contain conjunctions of equality conditions only. Disjunctions are not allowed. Each side of an equality condition must only refer to either the left table or the right table. (S.STATE = P.STATE) OR (S.LOCATION = P.LOCATION) is invalid.

-- Example 23734
SELECT t1.a "t1a", t2.a "t2a"
  FROM t1 ASOF JOIN
    LATERAL(SELECT a FROM t2 WHERE t1.b = t2.b) t2
    MATCH_CONDITION(t1.a >= t2.a)
  ORDER BY 1,2;

-- Example 23735
010004 (42601): SQL compilation error:
ASOF JOIN is not supported for joins with LATERAL table functions or LATERAL views.

-- Example 23736
('2020-01-01 00:00:00.000', 2.0),
('2020-01-02 00:00:00.000', 3.0),
('2020-01-03 00:00:00.000', 4.0);

-- Example 23737
-- Train your model
CREATE SNOWFLAKE.ML.FORECAST my_model(
  INPUT_DATA => TABLE(my_view),
  TIMESTAMP_COLNAME => 'my_timestamps',
  TARGET_COLNAME => 'my_metric'
);

-- Generate forecasts using your model
SELECT * FROM TABLE(my_model!FORECAST(FORECASTING_PERIODS => 7));

-- Example 23738
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

-- Example 23739
CREATE OR REPLACE VIEW v1 AS SELECT date, sales
  FROM sales_data WHERE store_id=1 AND item='jacket';
SELECT * FROM v1;

-- Example 23740
+-------------------------+-------+
| DATE                    | SALES |
+-------------------------+-------+
| 2020-01-01 00:00:00.000 | 2     |
| 2020-01-02 00:00:00.000 | 3     |
| 2020-01-03 00:00:00.000 | 4     |
| 2020-01-04 00:00:00.000 | 5     |
| 2020-01-05 00:00:00.000 | 6     |
+-------------------------+-------+

-- Example 23741
CREATE SNOWFLAKE.ML.FORECAST model1(
  INPUT_DATA => TABLE(v1),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- Example 23742
Instance MODEL1 successfully created.

-- Example 23743
call model1!FORECAST(FORECASTING_PERIODS => 3);

-- Example 23744
+--------+-------------------------+-----------+--------------+--------------+
| SERIES | TS                      | FORECAST  | LOWER_BOUND  | UPPER_BOUND  |
+--------+-------------------------+-----------+--------------+--------------+
| NULL   | 2020-01-13 00:00:00.000 | 14        | 14           | 14           |
| NULL   | 2020-01-14 00:00:00.000 | 15        | 15           | 15           |
| NULL   | 2020-01-15 00:00:00.000 | 16        | 16           | 16           |
+--------+-------------------------+-----------+--------------+--------------+

-- Example 23745
CALL model1!FORECAST(FORECASTING_PERIODS => 3, CONFIG_OBJECT => {'prediction_interval': 0.8});

-- Example 23746
CREATE TABLE my_forecasts AS
  SELECT * FROM TABLE(model1!FORECAST(FORECASTING_PERIODS => 3));

-- Example 23747
CREATE OR REPLACE VIEW v3 AS SELECT [store_id, item] AS store_item, date, sales FROM sales_data;
SELECT * FROM v3;

-- Example 23748
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

-- Example 23749
CREATE SNOWFLAKE.ML.FORECAST model2(
  INPUT_DATA => TABLE(v3),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- Example 23750
CALL model2!FORECAST(FORECASTING_PERIODS => 2);

-- Example 23751
+-------------------+------------------------+----------+-------------+-------------+
| SERIES            | TS                     | FORECAST | LOWER_BOUND | UPPER_BOUND |
+-------------------+------------------------+----------+-------------+-------------+
| [ 1, "jacket" ]   | 2020-01-13 00:00:00.000 | 14      | 14          | 14          |
| [ 1, "jacket" ]   | 2020-01-14 00:00:00.000 | 15      | 15          | 15          |
| [ 2, "umbrella" ] | 2020-01-13 00:00:00.000 | 14      | 14          | 14          |
| [ 2, "umbrella" ] | 2020-01-14 00:00:00.000 | 15      | 15          | 15          |
+-------------------+-------------------------+---------+-------------+-------------+

-- Example 23752
CALL model2!FORECAST(SERIES_VALUE => [2,'umbrella'], FORECASTING_PERIODS => 2);

-- Example 23753
+-------------------+------------ ------------+-----------+-------------+-------------+
| SERIES            | TS                      | FORECAST  | LOWER_BOUND | UPPER_BOUND |
+-------------------+---------- --------------+-----------+-------------+-------------+
| [ 2, "umbrella" ] | 2020-01-13 00:00:00.000 | 14        | 14          | 14          |
| [ 2, "umbrella" ] | 2020-01-14 00:00:00.000 | 15        | 15          | 15          |
+-------------------+-------------------------+-----------+-------------+-------------+

-- Example 23754
CREATE OR REPLACE VIEW v2 AS SELECT date, sales, temperature, humidity, holiday
  FROM sales_data WHERE store_id=1 AND item='jacket';
SELECT * FROM v2;

-- Example 23755
+-------------------------+--------+-------------+----------+----------+
| DATE                    | SALES  | TEMPERATURE | HUMIDITY | HOLIDAY  |
+-------------------------+--------+-------------+----------+----------+
| 2020-01-01 00:00:00.000 | 2      | 50          | 0.3      | new year |
| 2020-01-02 00:00:00.000 | 3      | 52          | 0.3      | null     |
| 2020-01-03 00:00:00.000 | 4      | 54          | 0.2      | null     |
| 2020-01-04 00:00:00.000 | 5      | 54          | 0.3      | null     |
| 2020-01-05 00:00:00.000 | 6      | 55          | 0.2      | null     |
+-------------------------+--------+-------------+----------+----------+

-- Example 23756
CREATE SNOWFLAKE.ML.FORECAST model3(
  INPUT_DATA => TABLE(v2),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- Example 23757
CREATE OR REPLACE VIEW v2_forecast AS select date, temperature, humidity, holiday
  FROM future_features WHERE store_id=1 AND item='jacket';
SELECT * FROM v2_forecast;

-- Example 23758
+-------------------------+-------------+----------+---------+
| DATE                    | TEMPERATURE | HUMIDITY | HOLIDAY |
+-------------------------+-------------+----------+---------+
| 2020-01-13 00:00:00.000 | 52          | 0.3      | null    |
| 2020-01-14 00:00:00.000 | 53          | 0.3      | null    |
+-------------------------+-------------+----------+---------+

-- Example 23759
CALL model3!FORECAST(
  INPUT_DATA => TABLE(v2_forecast),
  TIMESTAMP_COLNAME =>'date'
);

