-- Example 5609
SELECT CURRENT_DATE() AS "Today's Date",
       PREVIOUS_DAY("Today's Date", 'Friday ') AS "Previous Friday";

+--------------+-----------------+
| Today's Date | Previous Friday |
|--------------+-----------------|
| 2018-06-12   | 2018-06-08      |
+--------------+-----------------+

-- Example 5610
SELECT PROMPT('<template_string>', <expr_1> [ , <expr_2>, ... ] )
    FROM <table>;

-- Example 5611
{
  'template': '<template_string>',
  'args': ARRAY(<value_1>, <value_2>, ...)
}

-- Example 5612
SELECT PROMPT('Hello, {0}! Today is {1}.', 'Alice', 'Monday');

-- Example 5613
{
    'template': 'Hello, {0}! Today is {1}.',
    'args': ['Alice', 'Monday']
}

-- Example 5614
SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    PROMPT('Classify the input image {0} in no more than 2 words. Respond in JSON', img_file)) AS image_classification
FROM image_table;

-- Example 5615
QUERY_ACCELERATION_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [ , DATE_RANGE_END => <constant_expr> ]
      [ , WAREHOUSE_NAME => '<string>' ] )

-- Example 5616
QUERY_HISTORY(
      [ END_TIME_RANGE_START => <constant_expr> ]
      [, END_TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <num> ]
      [, INCLUDE_CLIENT_GENERATED_STATEMENT => <boolean_expr> ] )

QUERY_HISTORY_BY_SESSION(
      [ SESSION_ID => <constant_expr> ]
      [, END_TIME_RANGE_START => <constant_expr> ]
      [, END_TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <num> ]
      [, INCLUDE_CLIENT_GENERATED_STATEMENT => <boolean_expr> ] )

QUERY_HISTORY_BY_USER(
      [ USER_NAME => '<string>' ]
      [, END_TIME_RANGE_START => <constant_expr> ]
      [, END_TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <num> ]
      [, INCLUDE_CLIENT_GENERATED_STATEMENT => <boolean_expr> ] )

QUERY_HISTORY_BY_WAREHOUSE(
      [ WAREHOUSE_NAME => '<string>' ]
      [, END_TIME_RANGE_START => <constant_expr> ]
      [, END_TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <num> ]
      [, INCLUDE_CLIENT_GENERATED_STATEMENT => <boolean_expr> ] )

-- Example 5617
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_SESSION())
  ORDER BY start_time;

-- Example 5618
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
  ORDER BY start_time;

-- Example 5619
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY(DATEADD('hours',-1,CURRENT_TIMESTAMP()),CURRENT_TIMESTAMP()))
  ORDER BY start_time;

-- Example 5620
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY(
    END_TIME_RANGE_START=>TO_TIMESTAMP_LTZ('2017-12-4 12:00:00.000 -0700'),
    END_TIME_RANGE_END=>TO_TIMESTAMP_LTZ('2017-12-4 12:30:00.000 -0700')));

-- Example 5621
SELECT COUNT(*)
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
    WAREHOUSE_NAME => 'my_xsmall_wh',
    INCLUDE_CLIENT_GENERATED_STATEMENT => TRUE));

-- Example 5622
RADIANS( <real_expr> )

-- Example 5623
SELECT RADIANS(0), RADIANS(60), RADIANS(180), RADIANS(360), RADIANS(720);
+------------+-------------+--------------+--------------+--------------+
| RADIANS(0) | RADIANS(60) | RADIANS(180) | RADIANS(360) | RADIANS(720) |
|------------+-------------+--------------+--------------+--------------|
|          0 | 1.047197551 |  3.141592654 |  6.283185307 | 12.566370614 |
+------------+-------------+--------------+--------------+--------------+

-- Example 5624
RANDOM([seed])

-- Example 5625
SELECT RANDOM() FROM TABLE(GENERATOR(ROWCOUNT => 3));

-- Example 5626
+----------------------+
|             RANDOM() |
|----------------------|
|  -962378740685764490 |
|  2115408279841266588 |
| -3473099493125344079 |
+----------------------+

-- Example 5627
SELECT RANDOM(4711) FROM TABLE(GENERATOR(ROWCOUNT => 3));

-- Example 5628
+----------------------+
|         RANDOM(4711) |
|----------------------|
| -3581185414942383166 |
|  1570543588041465562 |
| -6684111782596764647 |
+----------------------+

-- Example 5629
SELECT RANDOM(), RANDOM() FROM TABLE(GENERATOR(ROWCOUNT => 3));

-- Example 5630
+----------------------+----------------------+
|             RANDOM() |             RANDOM() |
|----------------------+----------------------|
|  3150854865719208303 | -5331309978450480587 |
| -8117961043441270292 |   738998101727879972 |
|  6683692108700370630 |  7526520486590420231 |
+----------------------+----------------------+

-- Example 5631
SELECT RANDOM(4711), RANDOM(4711) FROM TABLE(GENERATOR(ROWCOUNT => 3));

-- Example 5632
+----------------------+----------------------+
|         RANDOM(4711) |         RANDOM(4711) |
|----------------------+----------------------|
| -3581185414942383166 | -3581185414942383166 |
|  1570543588041465562 |  1570543588041465562 |
| -6684111782596764647 | -6684111782596764647 |
+----------------------+----------------------+

-- Example 5633
RANDSTR( <length> , <gen> )

-- Example 5634
SELECT randstr(5, random()) FROM table(generator(rowCount => 5));

+----------------------+
| RANDSTR(5, RANDOM()) |
|----------------------|
| rM6ep                |
| nsWJ0                |
| IQi5H                |
| VBNvY                |
| wjk6y                |
+----------------------+

-- Example 5635
SELECT randstr(5, 1234) FROM table(generator(rowCount => 5));

+------------------+
| RANDSTR(5, 1234) |
|------------------|
| E5tav            |
| E5tav            |
| E5tav            |
| E5tav            |
| E5tav            |
+------------------+

-- Example 5636
SELECT randstr(abs(random()) % 10, random()) FROM table(generator(rowCount => 5));

+---------------------------------------+
| RANDSTR(ABS(RANDOM()) % 10, RANDOM()) |
|---------------------------------------|
| e                                     |
| iR                                    |
| qRwWl7W6                              |
|                                       |
| Yg                                    |
+---------------------------------------+

-- Example 5637
RANK() OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] [ <window_frame> ] )

-- Example 5638
-- Create table and load data.
create or replace table corn_production (farmer_ID INTEGER, state varchar, bushels float);
insert into corn_production (farmer_ID, state, bushels) values
    (1, 'Iowa', 100),
    (2, 'Iowa', 110),
    (3, 'Kansas', 120),
    (4, 'Kansas', 130);

-- Example 5639
SELECT state, bushels,
        RANK() OVER (ORDER BY bushels DESC),
        DENSE_RANK() OVER (ORDER BY bushels DESC)
    FROM corn_production;
+--------+---------+-------------------------------------+-------------------------------------------+
| STATE  | BUSHELS | RANK() OVER (ORDER BY BUSHELS DESC) | DENSE_RANK() OVER (ORDER BY BUSHELS DESC) |
|--------+---------+-------------------------------------+-------------------------------------------|
| Kansas |     130 |                                   1 |                                         1 |
| Kansas |     120 |                                   2 |                                         2 |
| Iowa   |     110 |                                   3 |                                         3 |
| Iowa   |     100 |                                   4 |                                         4 |
+--------+---------+-------------------------------------+-------------------------------------------+

-- Example 5640
SELECT state, bushels,
        RANK() OVER (PARTITION BY state ORDER BY bushels DESC),
        DENSE_RANK() OVER (PARTITION BY state ORDER BY bushels DESC)
    FROM corn_production;
+--------+---------+--------------------------------------------------------+--------------------------------------------------------------+
| STATE  | BUSHELS | RANK() OVER (PARTITION BY STATE ORDER BY BUSHELS DESC) | DENSE_RANK() OVER (PARTITION BY STATE ORDER BY BUSHELS DESC) |
|--------+---------+--------------------------------------------------------+--------------------------------------------------------------|
| Iowa   |     110 |                                                      1 |                                                            1 |
| Iowa   |     100 |                                                      2 |                                                            2 |
| Kansas |     130 |                                                      1 |                                                            1 |
| Kansas |     120 |                                                      2 |                                                            2 |
+--------+---------+--------------------------------------------------------+--------------------------------------------------------------+

-- Example 5641
SELECT state, bushels,
        RANK() OVER (ORDER BY bushels DESC),
        DENSE_RANK() OVER (ORDER BY bushels DESC)
    FROM corn_production;
+--------+---------+-------------------------------------+-------------------------------------------+
| STATE  | BUSHELS | RANK() OVER (ORDER BY BUSHELS DESC) | DENSE_RANK() OVER (ORDER BY BUSHELS DESC) |
|--------+---------+-------------------------------------+-------------------------------------------|
| Kansas |     130 |                                   1 |                                         1 |
| Kansas |     120 |                                   2 |                                         2 |
| Iowa   |     110 |                                   3 |                                         3 |
| Iowa   |     110 |                                   3 |                                         3 |
| Iowa   |     100 |                                   5 |                                         4 |
+--------+---------+-------------------------------------+-------------------------------------------+

-- Example 5642
RATIO_TO_REPORT( <expr1> ) [ OVER ( [ PARTITION BY <expr2> ] [ ORDER BY <expr3> ] ) ]

-- Example 5643
CREATE TABLE store_profit (
    store_ID INTEGER, 
    province VARCHAR,
    profit NUMERIC(11, 2));
INSERT INTO store_profit (store_ID, province, profit) VALUES
    (1, 'Ontario', 300),
    (2, 'Saskatchewan', 250),
    (3, 'Ontario', 450),
    (4, 'Ontario', NULL)  -- hasn't opened yet, so no profit yet.
    ;

-- Example 5644
SELECT 
        store_ID, profit, 
        100 * RATIO_TO_REPORT(profit) OVER () AS percent_profit
    FROM store_profit
    ORDER BY store_ID;
+----------+--------+----------------+
| STORE_ID | PROFIT | PERCENT_PROFIT |
|----------+--------+----------------|
|        1 | 300.00 |    30.00000000 |
|        2 | 250.00 |    25.00000000 |
|        3 | 450.00 |    45.00000000 |
|        4 |   NULL |           NULL |
+----------+--------+----------------+

-- Example 5645
SELECT 
        province, store_ID, profit, 
        100 * RATIO_TO_REPORT(profit) OVER (PARTITION BY province) AS percent_profit
    FROM store_profit
    ORDER BY province, store_ID;
+--------------+----------+--------+----------------+
| PROVINCE     | STORE_ID | PROFIT | PERCENT_PROFIT |
|--------------+----------+--------+----------------|
| Ontario      |        1 | 300.00 |    40.00000000 |
| Ontario      |        3 | 450.00 |    60.00000000 |
| Ontario      |        4 |   NULL |           NULL |
| Saskatchewan |        2 | 250.00 |   100.00000000 |
+--------------+----------+--------+----------------+

-- Example 5646
REDUCE( <array> , <init> , <lambda_expression> )

-- Example 5647
<acc> [ <datatype> ] , <value> [ <datatype> ] -> <expr>

-- Example 5648
SELECT REDUCE([1,2,3],
              0,
              (acc, val) -> acc + val)
  AS sum_of_values;

-- Example 5649
+---------------+
| SUM_OF_VALUES |
|---------------|
|             6 |
+---------------+

-- Example 5650
SELECT REDUCE([1,2,3]::ARRAY(INT),
              0,
              (acc, val) -> acc + val)
  AS sum_of_values_structured;

-- Example 5651
+--------------------------+
| SUM_OF_VALUES_STRUCTURED |
|--------------------------|
|                        6 |
+--------------------------+

-- Example 5652
SELECT REDUCE([1,2,3],
              10,
              (acc, val) -> acc + val)
  AS sum_of_values_plus_10;

-- Example 5653
+-----------------------+
| SUM_OF_VALUES_PLUS_10 |
|-----------------------|
|                    16 |
+-----------------------+

-- Example 5654
SELECT REDUCE([1,2,3],
              0,
              (acc, val) -> acc + val * val)
  AS sum_of_squares;

-- Example 5655
+----------------+
| SUM_OF_SQUARES |
|----------------|
|             14 |
+----------------+

-- Example 5656
SELECT REDUCE([1,NULL,2,NULL,3,4],
              0,
              (acc, val) -> IFNULL(acc + val, acc + 0))
  AS SUM_OF_VALUES_SKIP_NULL;

-- Example 5657
+-------------------------+
| SUM_OF_VALUES_SKIP_NULL |
|-------------------------|
|                      10 |
+-------------------------+

-- Example 5658
SELECT REDUCE(['a', 'b', 'c'],
              '',
              (acc, val) -> acc || ' ' || val)
  AS string_values;

-- Example 5659
+---------------+
| STRING_VALUES |
|---------------|
|  a b c        |
+---------------+

-- Example 5660
SELECT REDUCE([1, 2, 3, 4],
              [],
              (acc, val) -> ARRAY_PREPEND(acc, val))
  AS reverse_order;

-- Example 5661
+---------------+
| REVERSE_ORDER |
|---------------|
| [             |
|   4,          |
|   3,          |
|   2,          |
|   1           |
| ]             |
+---------------+

-- Example 5662
SELECT REDUCE([5,10,15],
              0,
              (acc, val) -> IFF(val < 7, acc + val * val, acc + val))
  AS conditional_logic;

-- Example 5663
+-------------------+
| CONDITIONAL_LOGIC |
|-------------------|
|                50 |
+-------------------+

-- Example 5664
CREATE OR REPLACE TABLE orders AS
  SELECT 1 AS order_id, '2024-01-01' AS order_date, [
    {'item':'UHD Monitor', 'quantity':3, 'subtotal':1500},
    {'item':'Business Printer', 'quantity':1, 'subtotal':1200}
  ] AS order_detail
  UNION SELECT 2 AS order_id, '2024-01-02' AS order_date, [
    {'item':'Laptop', 'quantity':5, 'subtotal':7500},
    {'item':'Noise-canceling Headphones', 'quantity':5, 'subtotal':1000}
  ] AS order_detail;

SELECT * FROM orders;

-- Example 5665
+----------+------------+-------------------------------------------+
| ORDER_ID | ORDER_DATE | ORDER_DETAIL                              |
|----------+------------+-------------------------------------------|
|        1 | 2024-01-01 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "UHD Monitor",                |
|          |            |     "quantity": 3,                        |
|          |            |     "subtotal": 1500                      |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Business Printer",           |
|          |            |     "quantity": 1,                        |
|          |            |     "subtotal": 1200                      |
|          |            |   }                                       |
|          |            | ]                                         |
|        2 | 2024-01-02 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "Laptop",                     |
|          |            |     "quantity": 5,                        |
|          |            |     "subtotal": 7500                      |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Noise-canceling Headphones", |
|          |            |     "quantity": 5,                        |
|          |            |     "subtotal": 1000                      |
|          |            |   }                                       |
|          |            | ]                                         |
+----------+------------+-------------------------------------------+

-- Example 5666
SELECT order_id,
       order_date,
       REDUCE(o.order_detail,
              0,
              (acc, val) -> acc + val:subtotal) subtotal_sum
  FROM orders o;

-- Example 5667
+----------+------------+--------------+
| ORDER_ID | ORDER_DATE | SUBTOTAL_SUM |
|----------+------------+--------------|
|        1 | 2024-01-01 |         2700 |
|        2 | 2024-01-02 |         8500 |
+----------+------------+--------------+

-- Example 5668
SELECT order_id,
       order_date,
       REDUCE(o.order_detail,
              '',
              (acc, val) -> val:item || '\n' || acc) items_sold
  FROM orders o;

-- Example 5669
+----------+------------+-----------------------------+
| ORDER_ID | ORDER_DATE | ITEMS_SOLD                  |
|----------+------------+-----------------------------|
|        1 | 2024-01-01 | Business Printer            |
|          |            | UHD Monitor                 |
|          |            |                             |
|        2 | 2024-01-02 | Noise-canceling Headphones  |
|          |            | Laptop                      |
|          |            |                             |
+----------+------------+-----------------------------+

-- Example 5670
<subject> [ NOT ] REGEXP <pattern>

-- Example 5671
CREATE OR REPLACE TABLE strings (v VARCHAR(50));
INSERT INTO strings (v) VALUES
  ('San Francisco'),
  ('San Jose'),
  ('Santa Clara'),
  ('Sacramento');

-- Example 5672
SELECT v
  FROM strings
  WHERE v REGEXP 'San* [fF].*'
  ORDER BY v;

-- Example 5673
+---------------+
| V             |
|---------------|
| San Francisco |
+---------------+

-- Example 5674
INSERT INTO strings (v) VALUES
  ('Contains embedded single \\backslash');

-- Example 5675
SELECT *
  FROM strings
  ORDER BY v;

