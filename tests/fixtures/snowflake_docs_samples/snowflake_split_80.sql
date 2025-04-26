-- Example 5341
CREATE MATERIALIZED VIEW mv AS
  SELECT SUM(c1) AS sum_c1, c2 FROM t GROUP BY c2;

CREATE VIEW view_on_mv AS
  SELECT 100 * sum_c1 AS sigma FROM mv WHERE sum_c1 > 0;

-- Example 5342
OVER ( [ PARTITION BY <expr1> ] [ ORDER BY <expr2> ] )

-- Example 5343
create materialized view bad_example (ts1) as
    select to_timestamp(n) from t1;

-- Example 5344
create materialized view good_example (ts1) as
    select to_timestamp(n)::TIMESTAMP_NTZ from t1;

-- Example 5345
CREATE OR REPLACE MATERIALIZED VIEW mv1 AS
  SELECT My_ResourceIntensive_Function(binary_col) FROM table1;

SELECT * FROM mv1;

-- Example 5346
Failure during expansion of view 'MY_MV':
  SQL compilation error: Materialized View MY_MV is invalid.
  Invalidation reason: Division by zero

-- Example 5347
ALTER MATERIALIZED VIEW <name> SUSPEND

-- Example 5348
ALTER MATERIALIZED VIEW <name> RESUME

-- Example 5349
CREATE OR REPLACE MATERIALIZED VIEW <view_name> ... COPY GRANTS ...

-- Example 5350
SELECT * FROM TABLE(INFORMATION_SCHEMA.MATERIALIZED_VIEW_REFRESH_HISTORY());

-- Example 5351
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.materialized_view_refresh_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 5352
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

-- Example 5353
CREATE TABLE inventory (product_ID INTEGER, wholesale_price FLOAT,
  description VARCHAR);
    
CREATE OR REPLACE MATERIALIZED VIEW mv1 AS
  SELECT product_ID, wholesale_price FROM inventory;

INSERT INTO inventory (product_ID, wholesale_price, description) VALUES 
    (1, 1.00, 'cog');

-- Example 5354
SELECT product_ID, wholesale_price FROM mv1;
+------------+-----------------+
| PRODUCT_ID | WHOLESALE_PRICE |
|------------+-----------------|
|          1 |               1 |
+------------+-----------------+

-- Example 5355
CREATE TABLE sales (product_ID INTEGER, quantity INTEGER, price FLOAT);

INSERT INTO sales (product_ID, quantity, price) VALUES 
   (1,  1, 1.99);

CREATE or replace VIEW profits AS
  SELECT m.product_ID, SUM(IFNULL(s.quantity, 0)) AS quantity,
      SUM(IFNULL(quantity * (s.price - m.wholesale_price), 0)) AS profit
    FROM mv1 AS m LEFT OUTER JOIN sales AS s ON s.product_ID = m.product_ID
    GROUP BY m.product_ID;

-- Example 5356
SELECT * FROM profits;
+------------+----------+--------+
| PRODUCT_ID | QUANTITY | PROFIT |
|------------+----------+--------|
|          1 |        1 |   0.99 |
+------------+----------+--------+

-- Example 5357
ALTER MATERIALIZED VIEW mv1 SUSPEND;
    
INSERT INTO inventory (product_ID, wholesale_price, description) VALUES 
    (2, 2.00, 'sprocket');

INSERT INTO sales (product_ID, quantity, price) VALUES 
   (2, 10, 2.99),
   (2,  1, 2.99);

-- Example 5358
SELECT * FROM profits ORDER BY product_ID;

-- Example 5359
002037 (42601): SQL compilation error:
Failure during expansion of view 'PROFITS': SQL compilation error:
Failure during expansion of view 'MV1': SQL compilation error: Materialized View MV1 is invalid.

-- Example 5360
ALTER MATERIALIZED VIEW mv1 RESUME;

-- Example 5361
SELECT * FROM profits ORDER BY product_ID;
+------------+----------+--------+
| PRODUCT_ID | QUANTITY | PROFIT |
|------------+----------+--------|
|          1 |        1 |   0.99 |
|          2 |       11 |  10.89 |
+------------+----------+--------+

-- Example 5362
CREATE TABLE pipeline_segments (
    segment_ID BIGINT,
    material VARCHAR, -- e.g. copper, cast iron, PVC.
    installation_year DATE,  -- older pipes are more likely to be corroded.
    rated_pressure FLOAT  -- maximum recommended pressure at installation time.
    );
    
INSERT INTO pipeline_segments 
    (segment_ID, material, installation_year, rated_pressure)
  VALUES
    (1, 'PVC', '1994-01-01'::DATE, 60),
    (2, 'cast iron', '1950-01-01'::DATE, 120)
    ;

CREATE TABLE pipeline_pressures (
    segment_ID BIGINT,
    pressure_psi FLOAT,  -- pressure in Pounds per Square Inch
    measurement_timestamp TIMESTAMP
    );
INSERT INTO pipeline_pressures 
   (segment_ID, pressure_psi, measurement_timestamp) 
  VALUES
    (2, 10, '2018-09-01 00:01:00'),
    (2, 95, '2018-09-01 00:02:00')
    ;

-- Example 5363
CREATE MATERIALIZED VIEW vulnerable_pipes 
  (segment_ID, installation_year, rated_pressure) 
  AS
    SELECT segment_ID, installation_year, rated_pressure
        FROM pipeline_segments 
        WHERE material = 'cast iron' AND installation_year < '1980'::DATE;

-- Example 5364
ALTER MATERIALIZED VIEW vulnerable_pipes CLUSTER BY (installation_year);

-- Example 5365
CREATE VIEW high_risk AS
    SELECT seg.segment_ID, installation_year, measurement_timestamp::DATE AS measurement_date, 
         DATEDIFF('YEAR', installation_year::DATE, measurement_timestamp::DATE) AS age, 
         rated_pressure - age AS safe_pressure, pressure_psi AS actual_pressure
       FROM vulnerable_pipes AS seg INNER JOIN pipeline_pressures AS psi 
           ON psi.segment_ID = seg.segment_ID
       WHERE pressure_psi > safe_pressure
       ;

-- Example 5366
SELECT * FROM high_risk;
+------------+-------------------+------------------+-----+---------------+-----------------+
| SEGMENT_ID | INSTALLATION_YEAR | MEASUREMENT_DATE | AGE | SAFE_PRESSURE | ACTUAL_PRESSURE |
|------------+-------------------+------------------+-----+---------------+-----------------|
|          2 | 1950-01-01        | 2018-09-01       |  68 |            52 |              95 |
+------------+-------------------+------------------+-----+---------------+-----------------+

-- Example 5367
create or replace table db1.schema1.table1(c1 int);
create or replace share sh1;
grant usage on database db1 to share sh1;
alter share sh1 add accounts = account2;
grant usage on schema db1.schema1 to share sh1;
grant select on table db1.schema1.table1 to share sh1;

-- Example 5368
create or replace database dbshared from share account1.sh1;
create or replace materialized view mv1 as select * from dbshared.schema1.table1 where c1 >= 50;

-- Example 5369
Failure during expansion of view 'MY_MV':
  SQL compilation error: Materialized View MY_MV is invalid.
  Invalidation reason: Division by zero

-- Example 5370
MD5(<msg>)

MD5_HEX(<msg>)

-- Example 5371
SELECT md5('Snowflake');

----------------------------------+
         MD5('SNOWFLAKE')         |
----------------------------------+
 edf1439075a83a447fb8b630ddc9c8de |
----------------------------------+

-- Example 5372
MD5_BINARY(<msg>)

-- Example 5373
SELECT md5_binary('Snowflake');
+----------------------------------+
| MD5_BINARY('SNOWFLAKE')          |
|----------------------------------|
| EDF1439075A83A447FB8B630DDC9C8DE |
+----------------------------------+

-- Example 5374
CREATE TABLE binary_demo (b BINARY);
INSERT INTO binary_demo (b) SELECT MD5_BINARY('Snowflake');

-- Example 5375
SELECT TO_VARCHAR(b, 'HEX') AS hex_representation
    FROM binary_demo;
+----------------------------------+
| HEX_REPRESENTATION               |
|----------------------------------|
| EDF1439075A83A447FB8B630DDC9C8DE |
+----------------------------------+

-- Example 5376
MD5_NUMBER(<msg>)

-- Example 5377
SELECT md5_number('Snowflake');

-----------------------------------------+
         MD5_NUMBER('SNOWFLAKE')         |
-----------------------------------------+
 -24002618010294540563082926240470284066 |
-----------------------------------------+

-- Example 5378
MD5_NUMBER_LOWER64(<msg>)

-- Example 5379
select md5_number_lower64('Snowflake');

+---------------------------------+
| MD5_NUMBER_LOWER64('SNOWFLAKE') |
|---------------------------------|
|             9203306159527282910 |
+---------------------------------+

-- Example 5380
MD5_NUMBER_UPPER64(<msg>)

-- Example 5381
select md5_number_upper64('Snowflake');

+---------------------------------+
| MD5_NUMBER_UPPER64('SNOWFLAKE') |
|---------------------------------|
|            17145559544104499780 |
+---------------------------------+

-- Example 5382
MOD( <expr1> , <expr2> )

-- Example 5383
SELECT MOD(3, 2) AS mod1, MOD(4.5, 1.2) AS mod2;

-- Example 5384
+------+------+
| MOD1 | MOD2 |
+------+------+
|    1 |  0.9 |
+------+------+

-- Example 5385
MODEL_MONITOR_DRIFT_METRIC(
  <model_monitor_name>, <drift_metric_name>, <column_name>
  [ , <granularity> [ , <start_time>  [ , <end_time> ] ] ]
)

-- Example 5386
SELECT * FROM TABLE(MODEL_MONITOR_DRIFT_METRIC(
'MY_MONITOR', 'DIFFERENCE_OF_MEANS', 'MODEL_PREDICTION', '1 DAY', TO_TIMESTAMP_TZ('2024-01-01'), TO_TIMESTAMP_TZ('2024-01-02'))
)

-- Example 5387
SELECT * FROM TABLE(MODEL_MONITOR_DRIFT_METRIC(
'MY_MONITOR', 'JENSEN_SHANNON', 'MODEL_PREDICTION', '1 DAY', DATEADD('DAY', -30, CURRENT_DATE()), CURRENT_DATE())
)

-- Example 5388
SELECT *
FROM TABLE(MODEL_MONITOR_DRIFT_METRIC (
                                        <model_monitor_name>,
                                        <drift_metric_name>,
                                        <column_name>,
                                        <granularity>,
                                        <start_time>,
                                        <end_time>
                                      )
          )

-- Example 5389
SELECT *
FROM TABLE(MODEL_MONITOR_PERFORMANCE_METRIC (
                                        <model_monitor_name>,
                                        <metric_name>,
                                        <granularity>,
                                        <start_time>,
                                        <end_time>
                                      )
          )

-- Example 5390
SELECT *
FROM TABLE(MODEL_MONITOR_STAT_METRIC (
                                        <model_monitor_name>,
                                        <metric_name>,
                                        <granularity>,
                                        <start_time>,
                                        <end_time>
                                      )
          )

-- Example 5391
MODEL_MONITOR_PERFORMANCE_METRIC(<model_monitor_name>, <performance_metric_name>,
    [, <granularity> [, <start_time>  [, <end_time> ] ] ] )

-- Example 5392
SELECT * FROM TABLE(MODEL_MONITOR_PERFORMANCE_METRIC(
'MY_MONITOR', 'RMSE', '1 DAY', TO_TIMESTAMP_TZ(‘2024-01-01’)
, TO_TIMESTAMP_TZ(‘2024-01-02’))
)

-- Example 5393
SELECT * FROM TABLE(MODEL_MONITOR_PERFORMANCE_METRIC(
'MY_MONITOR', 'RMSE', '1 DAY', DATEADD('DAY', -30, CURRENT_DATE()), CURRENT_DATE())
)

-- Example 5394
MODEL_MONITOR_STAT_METRIC(<model_monitor_name>, <stat_metric_name>, <column_name>
    [, <granularity> [, <start_time>  [, <end_time> ] ] ] )

-- Example 5395
SELECT * FROM TABLE(MODEL_MONITOR_STAT_METRIC(
'MY_MONITOR', 'COUNT', 'MODEL_PREDICTION', '1 DAY', TO_TIMESTAMP_TZ('2024-01-01')
, TO_TIMESTAMP_TZ('2024-01-02'))
)

-- Example 5396
SELECT * FROM TABLE(MODEL_MONITOR_STAT_METRIC(
'MY_MONITOR', 'COUNT', 'MODEL_PREDICTION', '1 DAY', DATEADD('DAY', -30, CURRENT_DATE()), CURRENT_DATE())
)

-- Example 5397
MONTHNAME( <date_or_timestamp_expr> )

-- Example 5398
SELECT MONTHNAME(TO_DATE('2015-05-01')) AS MONTH;

-------+
 MONTH |
-------+
 May   |
-------+

-- Example 5399
SELECT MONTHNAME(TO_TIMESTAMP('2015-04-03 10:00')) AS MONTH;

-------+
 MONTH |
-------+
 Apr   |
-------+

-- Example 5400
SELECT d, MONTHNAME(d) FROM dates;

------------+--------------+
     D      | MONTHNAME(D) |
------------+--------------+
 2015-01-01 | Jan          |
 2015-02-01 | Feb          |
 2015-03-01 | Mar          |
 2015-04-01 | Apr          |
 2015-05-01 | May          |
 2015-06-01 | Jun          |
 2015-07-01 | Jul          |
 2015-08-01 | Aug          |
 2015-09-01 | Sep          |
 2015-10-01 | Oct          |
 2015-11-01 | Nov          |
 2015-12-01 | Dec          |
------------+--------------+

-- Example 5401
MONTHS_BETWEEN( <date_expr1> , <date_expr2> )

-- Example 5402
SELECT
    ROUND(MONTHS_BETWEEN('2019-03-31 12:00:00'::TIMESTAMP,
                         '2019-02-28 00:00:00'::TIMESTAMP)) AS MonthsBetween1;
+----------------+
| MONTHSBETWEEN1 |
|----------------|
|              1 |
+----------------+

-- Example 5403
SELECT
    MONTHS_BETWEEN('2019-03-15'::DATE,
                   '2019-02-15'::DATE) AS MonthsBetween1,
    MONTHS_BETWEEN('2019-03-31'::DATE,
                   '2019-02-28'::DATE) AS MonthsBetween2;
+----------------+----------------+
| MONTHSBETWEEN1 | MONTHSBETWEEN2 |
|----------------+----------------|
|       1.000000 |       1.000000 |
+----------------+----------------+

-- Example 5404
SELECT
    MONTHS_BETWEEN('2019-03-01'::DATE,
                   '2019-02-15'::DATE) AS MonthsBetween1,
    MONTHS_BETWEEN('2019-03-01 02:00:00'::TIMESTAMP,
                   '2019-02-15 01:00:00'::TIMESTAMP) AS MonthsBetween2,
    MONTHS_BETWEEN('2019-02-15 02:00:00'::TIMESTAMP,
                   '2019-02-15 01:00:00'::TIMESTAMP) AS MonthsBetween3
    ;
+----------------+----------------+----------------+
| MONTHSBETWEEN1 | MONTHSBETWEEN2 | MONTHSBETWEEN3 |
|----------------+----------------+----------------|
|       0.548387 |       0.549731 |       0.000000 |
+----------------+----------------+----------------+

-- Example 5405
SELECT
    MONTHS_BETWEEN('2019-03-28'::DATE,
                   '2019-02-28'::DATE) AS MonthsBetween1,
    MONTHS_BETWEEN('2019-03-30'::DATE,
                   '2019-02-28'::DATE) AS MonthsBetween2,
    MONTHS_BETWEEN('2019-03-31'::DATE,
                   '2019-02-28'::DATE) AS MonthsBetween3
    ;
+----------------+----------------+----------------+
| MONTHSBETWEEN1 | MONTHSBETWEEN2 | MONTHSBETWEEN3 |
|----------------+----------------+----------------|
|       1.000000 |       1.064516 |       1.000000 |
+----------------+----------------+----------------+

-- Example 5406
SELECT
    MONTHS_BETWEEN('2019-03-01'::DATE,
                   '2019-02-01'::DATE) AS MonthsBetween1,
    MONTHS_BETWEEN('2019-02-01'::DATE,
                   '2019-03-01'::DATE) AS MonthsBetween2
    ;
+----------------+----------------+
| MONTHSBETWEEN1 | MONTHSBETWEEN2 |
|----------------+----------------|
|       1.000000 |      -1.000000 |
+----------------+----------------+

-- Example 5407
NETWORK_RULE_REFERENCES(
  NETWORK_RULE_NAME => '<string>'
)

NETWORK_RULE_REFERENCES(
  CONTAINER_NAME => '<container_name>' ,
  CONTAINER_TYPE => { 'INTEGRATION' | 'NETWORK_POLICY' }
)

