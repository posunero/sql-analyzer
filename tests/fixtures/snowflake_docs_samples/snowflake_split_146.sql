-- Example 9763
employee_ID  manager_ID
-----------  ----------
       1         2

-- Example 9764
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 9765
table1.employee_ID  table1.manager_ID  cte.employee_ID  cte.manager_ID
-----------------   -----------------  ---------------  --------------
 ...
       2                   1                 1                2
 ...

-- Example 9766
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 9767
employee_ID  manager_ID
-----------  ----------
 ...
       1         2        -- Because manager and employee IDs reversed
 ...

-- Example 9768
SELECT SEARCH('leopard', 'snow leopard');

-- Example 9769
+-----------------------------------+
| SEARCH('LEOPARD', 'SNOW LEOPARD') |
|-----------------------------------|
| True                              |
+-----------------------------------+

-- Example 9770
SELECT SEARCH('lion', 'snow leopard');

-- Example 9771
+--------------------------------+
| SEARCH('LION', 'SNOW LEOPARD') |
|--------------------------------|
| False                          |
+--------------------------------+

-- Example 9772
SELECT SEARCH('leopard', 'snow leopard', search_mode => 'AND');

-- Example 9773
+---------------------------------------------------------+
| SEARCH('LEOPARD', 'SNOW LEOPARD', SEARCH_MODE => 'AND') |
|---------------------------------------------------------|
| False                                                   |
+---------------------------------------------------------+

-- Example 9774
SELECT SEARCH_IP('192.0.2.146','10.10.10.1');

-- Example 9775
+---------------------------------------+
| SEARCH_IP('192.0.2.146','10.10.10.1') |
|---------------------------------------|
| False                                 |
+---------------------------------------+

-- Example 9776
SELECT COUNT(*) FROM TABLE(TO_QUERY('SELECT 1'));

-- Example 9777
+----------+
| COUNT(*) |
|----------|
|        1 |
+----------+

-- Example 9778
CREATE OR REPLACE PROCEDURE get_num_results_tq(query VARCHAR)
RETURNS TABLE ()
LANGUAGE SQL
AS
DECLARE
  res RESULTSET DEFAULT (SELECT COUNT(*) FROM TABLE(TO_QUERY(:query)));
BEGIN
  RETURN TABLE(res);
END;

-- Example 9779
CREATE OR REPLACE PROCEDURE get_num_results_tq(query VARCHAR)
RETURNS TABLE ()
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT COUNT(*) FROM TABLE(TO_QUERY(:query)));
BEGIN
  RETURN TABLE(res);
END;
$$
;

-- Example 9780
CALL get_num_results_tq('SELECT 1');

-- Example 9781
+----------+
| COUNT(*) |
|----------|
|        1 |
+----------+

-- Example 9782
CREATE OR REPLACE PROCEDURE get_num_results(query VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
AS
DECLARE
  row_count INTEGER DEFAULT 0;
  stmt VARCHAR DEFAULT 'SELECT COUNT(*) FROM (' || query || ')';
  res RESULTSET DEFAULT (EXECUTE IMMEDIATE :stmt);
  cur CURSOR FOR res;
BEGIN
  OPEN cur;
  FETCH cur INTO row_count;
  RETURN row_count;
END;

-- Example 9783
CREATE OR REPLACE PROCEDURE get_num_results(query VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
AS
$$
DECLARE
  row_count INTEGER DEFAULT 0;
  stmt VARCHAR DEFAULT 'SELECT COUNT(*) FROM (' || query || ')';
  res RESULTSET DEFAULT (EXECUTE IMMEDIATE :stmt);
  cur CURSOR FOR res;
BEGIN
  OPEN cur;
  FETCH cur INTO row_count;
  RETURN row_count;
END;
$$
;

-- Example 9784
CALL get_num_results('SELECT 1');

-- Example 9785
+-----------------+
| GET_NUM_RESULTS |
|-----------------|
|               1 |
+-----------------+

-- Example 9786
CREATE OR REPLACE TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
  (11.11),
  (22.22);

-- Example 9787
DECLARE
  rs RESULTSET;
  query VARCHAR DEFAULT 'SELECT * FROM invoices WHERE price > ? AND price < ?';
  minimum_price NUMBER(12,2) DEFAULT 20.00;
  maximum_price NUMBER(12,2) DEFAULT 30.00;
BEGIN
  rs := (EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price));
  RETURN TABLE(rs);
END;

-- Example 9788
EXECUTE IMMEDIATE $$
DECLARE
  rs RESULTSET;
  query VARCHAR DEFAULT 'SELECT * FROM invoices WHERE price > ? AND price < ?';
  minimum_price NUMBER(12,2) DEFAULT 20.00;
  maximum_price NUMBER(12,2) DEFAULT 30.00;
BEGIN
  rs := (EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price));
  RETURN TABLE(rs);
END;
$$
;

-- Example 9789
+-------+
| PRICE |
|-------|
| 22.22 |
+-------+

-- Example 9790
EVENTID | TYPE | SEVERITY | START_TIME              | END_TIME                | PRECIP | TIME_ZONE   | CITY       | COUNTY    | STATE | ZIP
W100    | Rain | Moderate | 2020-12-20 16:35:00.000 | 2020-12-20 17:15:00.000 |   0.32 | US/Eastern  | Southport  | Brunswick | NC    | 28461

-- Example 9791
DEVICE | LINE | DEVICE_TIMESTAMP        | TEMP     | BROKER_TIMESTAMP
IOT    | 3000 | 2023-01-01 00:01:00.000 | 21.1673  | 2023-01-01 00:01:32.000

-- Example 9792
+-----------+-------------------------+-------------+-----------+-----------+
| DEVICE_ID | TIMESTAMP               | TEMPERATURE | VIBRATION | MOTOR_RPM |
|-----------+-------------------------+-------------+-----------+-----------|
| DEVICE1   | 2024-03-01 00:00:00.000 |     32.6908 |    0.3158 |      1492 |
| DEVICE2   | 2024-03-01 00:00:00.000 |     35.2086 |    0.3232 |      1461 |
| DEVICE1   | 2024-03-01 00:00:01.000 |     35.9578 |    0.3302 |      1452 |
| DEVICE2   | 2024-03-01 00:00:01.000 |     26.2468 |    0.3029 |      1455 |
+-----------+-------------------------+-------------+-----------+-----------+

-- Example 9793
SELECT device_id, count(*) FROM sensor_data_ts
  WHERE TIMESTAMP >= ('2024-03-01 00:01:00')
    AND TIMESTAMP < ('2024-03-01 00:02:00')
  GROUP BY device_id;

-- Example 9794
+-----------+----------+
| DEVICE_ID | COUNT(*) |
|-----------+----------|
| DEVICE2   |       60 |
| DEVICE1   |       60 |
+-----------+----------+

-- Example 9795
SELECT
    TIME_SLICE(TO_TIMESTAMP_NTZ(timestamp), 1, 'MINUTE') minute_slice,
    device_id,
    COUNT(*),
    AVG(temperature) avg_temp
  FROM sensor_data_ts
  WHERE TIMESTAMP >= ('2024-03-01 00:01:00')
    AND TIMESTAMP < ('2024-03-01 00:02:00')
  GROUP BY 1,2
  ORDER BY 1,2;

-- Example 9796
+-------------------------+-----------+----------+---------------+
| MINUTE_SLICE            | DEVICE_ID | COUNT(*) |      AVG_TEMP |
|-------------------------+-----------+----------+---------------|
| 2024-03-01 00:01:00.000 | DEVICE1   |       60 | 32.4315466667 |
| 2024-03-01 00:01:00.000 | DEVICE2   |       60 | 30.4967783333 |
+-------------------------+-----------+----------+---------------+

-- Example 9797
SELECT DATE_TRUNC('day', order_ts)::date sliced_ts, truck_id, location_id, AVG(order_amount)::NUMBER(4,2) as avg_amount
  FROM order_header
  WHERE EXTRACT(YEAR FROM order_ts)='2022'
  GROUP BY date_trunc('day', order_ts), truck_id, location_id
  ORDER BY 1, 2, 3 LIMIT 25;

-- Example 9798
+------------+----------+-------------+------------+
| SLICED_TS  | TRUCK_ID | LOCATION_ID | AVG_AMOUNT |
|------------+----------+-------------+------------|
| 2022-01-01 |        1 |        3223 |      19.23 |
| 2022-01-01 |        1 |        3869 |      20.15 |
| 2022-01-01 |        2 |        2401 |      39.29 |
| 2022-01-01 |        2 |        4199 |      34.29 |
| 2022-01-01 |        3 |        2883 |      35.01 |
| 2022-01-01 |        3 |        2961 |      39.15 |
| 2022-01-01 |        4 |        2614 |      35.95 |
| 2022-01-01 |        4 |        2899 |      40.29 |
| 2022-01-01 |        6 |        1946 |      26.58 |
| 2022-01-01 |        6 |       14960 |      18.59 |
| 2022-01-01 |        7 |        1427 |      26.91 |
| 2022-01-01 |        7 |        3224 |      28.88 |
| 2022-01-01 |        9 |        1557 |      35.52 |
| 2022-01-01 |        9 |        2612 |      43.80 |
| 2022-01-01 |       10 |        2217 |      32.35 |
| 2022-01-01 |       10 |        2694 |      32.23 |
| 2022-01-01 |       11 |        2656 |      44.23 |
| 2022-01-01 |       11 |        3327 |      52.00 |
| 2022-01-01 |       12 |        3181 |      52.84 |
| 2022-01-01 |       12 |        3622 |      49.59 |
| 2022-01-01 |       13 |        2516 |      31.13 |
| 2022-01-01 |       13 |        3876 |      28.13 |
| 2022-01-01 |       14 |        1359 |      72.04 |
| 2022-01-01 |       14 |        2505 |      68.75 |
| 2022-01-01 |       15 |        2901 |      41.90 |
+------------+----------+-------------+------------+

-- Example 9799
SELECT city, start_time, precip,
    SUM(precip) OVER(
      PARTITION BY city
      ORDER BY start_time
      RANGE BETWEEN INTERVAL '12 hours' PRECEDING AND CURRENT ROW) moving_sum_precip
  FROM heavy_weather
  WHERE city IN('South Lake Tahoe','Big Bear City')
  GROUP BY city, precip, start_time
  ORDER BY city;

-- Example 9800
+------------------+-------------------------+--------+-------------------+
| CITY             | START_TIME              | PRECIP | MOVING_SUM_PRECIP |
|------------------+-------------------------+--------+-------------------|
| Big Bear City    | 2021-12-24 05:35:00.000 |   0.42 |              0.42 |
| Big Bear City    | 2021-12-24 16:55:00.000 |   0.09 |              0.51 |
| Big Bear City    | 2021-12-26 09:55:00.000 |   0.07 |              0.07 |
| South Lake Tahoe | 2021-12-23 16:23:00.000 |   0.56 |              0.56 |
| South Lake Tahoe | 2021-12-23 17:24:00.000 |   0.38 |              0.94 |
| South Lake Tahoe | 2021-12-23 18:30:00.000 |   0.28 |              1.22 |
| South Lake Tahoe | 2021-12-23 19:36:00.000 |   0.80 |              2.02 |
| South Lake Tahoe | 2021-12-24 06:49:00.000 |   0.17 |              0.97 |
| South Lake Tahoe | 2021-12-24 15:53:00.000 |   0.07 |              0.24 |
| South Lake Tahoe | 2021-12-26 05:43:00.000 |   0.16 |              0.16 |
| South Lake Tahoe | 2021-12-27 14:53:00.000 |   0.07 |              0.07 |
| South Lake Tahoe | 2021-12-27 17:53:00.000 |   0.07 |              0.14 |
+------------------+-------------------------+--------+-------------------+

-- Example 9801
SELECT device_id, timestamp, temperature, AVG(temperature)
  OVER (PARTITION BY device_id ORDER BY timestamp
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_temp
FROM sensor_data_ts
WHERE timestamp BETWEEN '2024-03-15 00:00:59.000' AND '2024-03-15 00:01:10.000'
ORDER BY 1, 2;

-- Example 9802
SELECT MAX_BY(precip, start_time) most_recent_precip
  FROM heavy_weather;

-- Example 9803
+--------------------+
| MOST_RECENT_PRECIP |
|--------------------|
|               0.07 |
+--------------------+

-- Example 9804
SELECT * FROM heavy_weather WHERE start_time=
  (SELECT MAX(start_time) FROM heavy_weather);

-- Example 9805
+-------------------------+--------+-------+-------------+
| START_TIME              | PRECIP | CITY  | COUNTY      |
|-------------------------+--------+-------+-------------|
| 2021-12-30 20:53:00.000 |   0.07 | Lebec | Los Angeles |
+-------------------------+--------+-------+-------------+

-- Example 9806
SELECT city, MAX_BY(precip, start_time) most_recent_precip
  FROM heavy_weather
  GROUP BY city
  ORDER BY 2 DESC;

-- Example 9807
+------------------+--------------------+
| CITY             | MOST_RECENT_PRECIP |
|------------------+--------------------|
| Alta             |               0.89 |
| Bishop           |               0.75 |
| Mammoth Lakes    |               0.37 |
| Alturas          |               0.23 |
| Mount Shasta     |               0.09 |
| South Lake Tahoe |               0.07 |
| Big Bear City    |               0.07 |
| Montague         |               0.07 |
| Lebec            |               0.07 |
+------------------+--------------------+

-- Example 9808
SELECT city, MIN_BY(precip, start_time) oldest_precip
  FROM heavy_weather
  GROUP BY city
  ORDER BY 2 DESC;

-- Example 9809
+------------------+---------------+
| CITY             | OLDEST_PRECIP |
|------------------+---------------|
| South Lake Tahoe |          0.56 |
| Big Bear City    |          0.42 |
| Mammoth Lakes    |          0.37 |
| Alta             |          0.25 |
| Alturas          |          0.23 |
| Bishop           |          0.08 |
| Lebec            |          0.08 |
| Mount Shasta     |          0.08 |
| Montague         |          0.07 |
+------------------+---------------+

-- Example 9810
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time >= quote_time)
    ON t.stock_symbol=q.stock_symbol
  ORDER BY t.stock_symbol;

-- Example 9811
+--------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:03.000 | 139.00000000 |
| SNOW         | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:02.000 | 163.00000000 |
| SNOW         | 2023-10-01 09:00:10.000 |     1500 | 2023-10-01 09:00:08.000 | 165.00000000 |
+--------------+-------------------------+----------+-------------------------+--------------+

-- Example 9812
CREATE OR REPLACE TABLE trades (
  stock_symbol VARCHAR(4),
  trade_time TIMESTAMP_NTZ(9),
  quantity NUMBER(38,0)
  );

CREATE OR REPLACE TABLE quotes (
  stock_symbol VARCHAR(4),
  quote_time TIMESTAMP_NTZ(9),
  price NUMBER(12,8)
  );

INSERT INTO trades VALUES
  ('SNOW','2023-10-01 09:00:05.000', 1000),
  ('AAPL','2023-10-01 09:00:05.000', 2000),
  ('SNOW','2023-10-01 09:00:10.000', 1500);

INSERT INTO quotes VALUES
  ('SNOW','2023-10-01 09:00:01.000', 166.00),
  ('SNOW','2023-10-01 09:00:02.000', 163.00),
  ('SNOW','2023-10-01 09:00:07.000', 166.00),
  ('SNOW','2023-10-01 09:00:08.000', 165.00),
  ('AAPL','2023-10-01 09:00:03.000', 139.00),
  ('AAPL','2023-10-01 09:00:07.000', 142.00),
  ('AAPL','2023-10-01 09:00:11.000', 142.00);

-- Example 9813
DELETE FROM sensor_data_ts
  WHERE device_id='DEVICE2'
    AND TIMESTAMP > ('2024-03-07 00:01:15')
    AND TIMESTAMP <= ('2024-03-07 00:01:20');

-- Example 9814
+------------------------+
| number of rows deleted |
|------------------------|
|                      5 |
+------------------------+

-- Example 9815
SELECT * FROM sensor_data_ts
  WHERE device_id='DEVICE2'
  AND TIMESTAMP >= ('2024-03-07 00:01:15')
  AND TIMESTAMP <= ('2024-03-07 00:01:21')
ORDER BY TIMESTAMP;

-- Example 9816
+-----------+-------------------------+-------------+-----------+-----------+
| DEVICE_ID | TIMESTAMP               | TEMPERATURE | VIBRATION | MOTOR_RPM |
|-----------+-------------------------+-------------+-----------+-----------|
| DEVICE2   | 2024-03-07 00:01:15.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:21.000 |     28.0426 |    0.2944 |      1448 |
+-----------+-------------------------+-------------+-----------+-----------+

-- Example 9817
CREATE OR REPLACE TABLE continuous_timestamps AS
  SELECT 'DEVICE2' as DEVICE_ID,
    DATEADD('SECOND', ROW_NUMBER() OVER (ORDER BY SEQ8()), '2024-03-07 00:01:15')::TIMESTAMP_NTZ AS TS
  FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- Example 9818
SELECT * FROM continuous_timestamps ORDER BY ts;

-- Example 9819
+-----------+-------------------------+
| DEVICE_ID | TS                      |
|-----------+-------------------------|
| DEVICE2   | 2024-03-07 00:01:16.000 |
| DEVICE2   | 2024-03-07 00:01:17.000 |
| DEVICE2   | 2024-03-07 00:01:18.000 |
| DEVICE2   | 2024-03-07 00:01:19.000 |
| DEVICE2   | 2024-03-07 00:01:20.000 |
+-----------+-------------------------+

-- Example 9820
INSERT INTO sensor_data_ts(device_id, timestamp, temperature, vibration, motor_rpm)
  SELECT t.device_id, t.ts, s.temperature, s.vibration, s.motor_rpm
    FROM continuous_timestamps t
      ASOF JOIN sensor_data_ts s
        MATCH_CONDITION(t.ts >= s.timestamp)
        ON t.device_id = s.device_id
    WHERE TIMESTAMP >= ('2024-03-07 00:01:15')
      AND TIMESTAMP < ('2024-03-07 00:01:21');

-- Example 9821
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       5 |
+-------------------------+

-- Example 9822
SELECT * FROM sensor_data_ts
  WHERE device_id='DEVICE2'
    AND TIMESTAMP >= ('2024-03-07 00:01:15')
    AND TIMESTAMP <= ('2024-03-07 00:01:21')
  ORDER BY TIMESTAMP;

-- Example 9823
+-----------+-------------------------+-------------+-----------+-----------+
| DEVICE_ID | TIMESTAMP               | TEMPERATURE | VIBRATION | MOTOR_RPM |
|-----------+-------------------------+-------------+-----------+-----------|
| DEVICE2   | 2024-03-07 00:01:15.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:16.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:17.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:18.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:19.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:20.000 |     30.1088 |    0.2960 |      1457 |
| DEVICE2   | 2024-03-07 00:01:21.000 |     28.0426 |    0.2944 |      1448 |
+-----------+-------------------------+-------------+-----------+-----------+

-- Example 9824
CREATE OR REPLACE TABLE sensor_data_30_rows (
  device_id VARCHAR(10),
  timestamp TIMESTAMP,
  temperature DECIMAL(6,4),
  vibration DECIMAL(6,4),
  motor_rpm INT);

INSERT INTO sensor_data_30_rows (device_id, timestamp, temperature, vibration, motor_rpm)
  SELECT 'DEVICE3', timestamp,
    UNIFORM(30.2345, 36.3456, RANDOM()), --
    UNIFORM(0.4000, 0.4718, RANDOM()), --
    UNIFORM(1510, 1625, RANDOM()) --
  FROM (
    SELECT DATEADD(SECOND, SEQ4(), '2024-03-01') AS timestamp
      FROM TABLE(GENERATOR(ROWCOUNT => 30))
  );

CREATE OR REPLACE VIEW sensor_data_view AS SELECT * FROM sensor_data_30_rows;

-- Example 9825
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION sensor_model(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'sensor_data_view'),
  TIMESTAMP_COLNAME => 'timestamp',
  TARGET_COLNAME => 'temperature',
  LABEL_COLNAME => '');

-- Example 9826
+---------------------------------------------+
| status                                      |
|---------------------------------------------|
| Instance SENSOR_MODEL successfully created. |
+---------------------------------------------+

-- Example 9827
CREATE OR REPLACE TABLE sensor_data_device3 (
  device_id VARCHAR(10),
  timestamp TIMESTAMP,
  temperature DECIMAL(6,4),
  vibration DECIMAL(6,4),
  motor_rpm INT);

INSERT INTO sensor_data_device3 VALUES
  ('DEVICE3','2024-03-01 00:00:30.000',36.0422,0.4226,1560),
  ('DEVICE3','2024-03-01 00:00:31.000',36.1519,0.4341,1515),
  ('DEVICE3','2024-03-01 00:00:32.000',36.1524,0.4321,1591);

CALL sensor_model!DETECT_ANOMALIES(
  INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'sensor_data_device3'),
  TIMESTAMP_COLNAME => 'timestamp',
  TARGET_COLNAME => 'temperature'
);

-- Example 9828
+-------------------------+---------+--------------+--------------+--------------+------------+--------------+-------------+
| TS                      |       Y |     FORECAST |  LOWER_BOUND |  UPPER_BOUND | IS_ANOMALY |   PERCENTILE |    DISTANCE |
|-------------------------+---------+--------------+--------------+--------------+------------+--------------+-------------|
| 2024-03-01 00:00:30.000 | 36.0422 | 30.809998241 | 25.583156942 | 36.036839539 | True       | 0.9950380683 | 2.578470982 |
| 2024-03-01 00:00:31.000 | 36.1519 | 32.559470456 | 27.332629158 | 37.786311755 | False      | 0.961667911  | 1.770378085 |
| 2024-03-01 00:00:32.000 | 36.1524 | 32.205610776 | 26.978769478 | 37.432452075 | False      | 0.9741130751 | 1.945009377 |
+-------------------------+---------+--------------+--------------+--------------+------------+--------------+-------------+

-- Example 9829
CREATE OR REPLACE TABLE sensor_data_device1 (
   device_id VARCHAR(10),
   timestamp TIMESTAMP,
   temperature DECIMAL(6,4),
   vibration DECIMAL(6,4),
   motor_rpm INT
 );

 INSERT INTO sensor_data_device1 (device_id, timestamp, temperature, vibration, motor_rpm)
   SELECT 'DEVICE1', timestamp,
     UNIFORM(25.1111, 40.2222, RANDOM()), -- Temperature range in °C
     UNIFORM(0.2985, 0.3412, RANDOM()), -- Vibration range in mm/s
     UNIFORM(1400, 1495, RANDOM()) -- Motor RPM range
   FROM (
     SELECT DATEADD(SECOND, SEQ4(), '2024-03-01') AS timestamp
       FROM TABLE(GENERATOR(ROWCOUNT => 2678400)) -- seconds in 31 days
 );

CREATE OR REPLACE TABLE sensor_data_device2 (
   device_id VARCHAR(10),
   timestamp TIMESTAMP,
   temperature DECIMAL(6,4),
   vibration DECIMAL(6,4),
   motor_rpm INT
 );

INSERT INTO sensor_data_device2 (device_id, timestamp, temperature, vibration, motor_rpm)
   SELECT 'DEVICE2', timestamp,
     UNIFORM(24.6642, 36.3107, RANDOM()), -- Temperature range in °C
     UNIFORM(0.2876, 0.3333, RANDOM()), -- Vibration range in mm/s
     UNIFORM(1425, 1505, RANDOM()) -- Motor RPM range
   FROM (
     SELECT DATEADD(SECOND, SEQ4(), '2024-03-01') AS timestamp
       FROM TABLE(GENERATOR(ROWCOUNT => 2678400)) -- seconds in 31 days
 );

 INSERT INTO sensor_data_device1 SELECT * FROM sensor_data_device2;

 DROP TABLE IF EXISTS sensor_data_ts;

 ALTER TABLE sensor_data_device1 rename to sensor_data_ts;

 DROP TABLE sensor_data_device2;

 SELECT COUNT(*) FROM sensor_data_ts; -- verify row count = 5356800

