-- Example 4606
CREATE OR REPLACE PROCEDURE last_n_query_duration(last_n NUMBER, total NUMBER)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION=3.9
  PACKAGES=('snowflake-snowpark-python')
  HANDLER='main'
AS $$
import snowflake.snowpark.functions as funcs

def main(session, last_n, total):
  # create sample dataset to emulate id + elapsed time
  session.sql('''
  CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)
  ''').collect()
  session.sql('''
  INSERT INTO sample_query_history
  SELECT
  seq8() AS query_id,
  uniform(0::float, 100::float, random()) as elapsed_time
  FROM table(generator(rowCount => {0}));'''.format(total)).collect()

  # get the mean of the last n query elapsed time
  df = session.table('sample_query_history').select(
    funcs.col('query_id'),
    funcs.col('elapsed_time')).limit(last_n)

  pandas_df = df.to_pandas()
  mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
  del pandas_df
  return mean_time
$$;

CREATE TEMPORARY STAGE profiler_output;
ALTER SESSION SET PYTHON_PROFILER_TARGET_STAGE = "my_database.my_schema.profiler_output";
ALTER SESSION SET ACTIVE_PYTHON_PROFILER = 'LINE';

-- Sample 1 million from 10 million records
CALL last_n_query_duration(1000000, 10000000);

SELECT SNOWFLAKE.CORE.GET_PYTHON_PROFILER_OUTPUT(last_query_id());

-- Example 4607
Handler Name: main
Python Runtime Version: 3.9
Modules Profiled: ['main_module']
Timer Unit: 0.001 s

Total Time: 8.96127 s
File: _udf_code.py
Function: main at line 4

Line #      Hits        Time  Per Hit   % Time  Line Contents
==============================================================
    4                                           def main(session, last_n, total):
    5                                               # create sample dataset to emulate id + elapsed time
    6         1        122.3    122.3      1.4      session.sql('''
    7                                                   CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)''').collect()
    8         2       7248.4   3624.2     80.9      session.sql('''
    9                                               INSERT INTO sample_query_history
    10                                               SELECT
    11                                               seq8() AS query_id,
    12                                               uniform(0::float, 100::float, random()) as elapsed_time
    13         1          0.0      0.0      0.0      FROM table(generator(rowCount => {0}));'''.format(total)).collect()
    14
    15                                               # get the mean of the last n query elapsed time
    16         3         58.6     19.5      0.7      df = session.table('sample_query_history').select(
    17         1          0.0      0.0      0.0          funcs.col('query_id'),
    18         2          0.0      0.0      0.0          funcs.col('elapsed_time')).limit(last_n)
    19
    20         1       1528.4   1528.4     17.1      pandas_df = df.to_pandas()
    21         1          3.2      3.2      0.0      mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
    22         1          0.3      0.3      0.0      del pandas_df
    23         1          0.0      0.0      0.0      return mean_time

-- Example 4608
ALTER SESSION SET ACTIVE_PYTHON_PROFILER = 'MEMORY';

Handler Name: main
Python Runtime Version: 3.9
Modules Profiled: ['main_module']
File: _udf_code.py
Function: main at line 4

Line #   Mem usage    Increment  Occurrences  Line Contents
=============================================================
    4    245.3 MiB    245.3 MiB           1   def main(session, last_n, total):
    5                                             # create sample dataset to emulate id + elapsed time
    6    245.8 MiB      0.5 MiB           1       session.sql('''
    7                                                 CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)''').collect()
    8    245.8 MiB      0.0 MiB           2       session.sql('''
    9                                             INSERT INTO sample_query_history
    10                                             SELECT
    11                                             seq8() AS query_id,
    12                                             uniform(0::float, 100::float, random()) as elapsed_time
    13    245.8 MiB      0.0 MiB           1       FROM table(generator(rowCount => {0}));'''.format(total)).collect()
    14
    15                                             # get the mean of the last n query elapsed time
    16    245.8 MiB      0.0 MiB           3       df = session.table('sample_query_history').select(
    17    245.8 MiB      0.0 MiB           1           funcs.col('query_id'),
    18    245.8 MiB      0.0 MiB           2           funcs.col('elapsed_time')).limit(last_n)
    19
    20    327.9 MiB     82.1 MiB           1       pandas_df = df.to_pandas()
    21    328.9 MiB      1.0 MiB           1       mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
    22    320.9 MiB     -8.0 MiB           1       del pandas_df
    23    320.9 MiB      0.0 MiB           1       return mean_time

-- Example 4609
GET_QUERY_OPERATOR_STATS( <query_id> )

-- Example 4610
select *
    from table(get_query_operator_stats(last_query_id()));

-- Example 4611
select x1.i, x2.i
    from x1 inner join x2 on x2.i = x1.i
    order by x1.i, x2.i;

-- Example 4612
set lqid = (select last_query_id());

-- Example 4613
select * from table(get_query_operator_stats($lqid));
+--------------------------------------+---------+-------------+--------------------+---------------+-----------------------------------------+-----------------------------------------------+----------------------------------------------------------------------+
| QUERY_ID                             | STEP_ID | OPERATOR_ID | PARENT_OPERATORS   | OPERATOR_TYPE | OPERATOR_STATISTICS                     | EXECUTION_TIME_BREAKDOWN                      | OPERATOR_ATTRIBUTES                                                  |
|--------------------------------------+---------+-------------+--------------------+---------------+-----------------------------------------+-----------------------------------------------+----------------------------------------------------------------------|
| 01a8f330-0507-3f5b-0000-43830248e09a |       1 |           0 |               NULL | Result        | {                                       | {                                             | {                                                                    |
|                                      |         |             |                    |               |   "input_rows": 64                      |   "overall_percentage": 0.000000000000000e+00 |   "expressions": [                                                   |
|                                      |         |             |                    |               | }                                       | }                                             |     "X1.I",                                                          |
|                                      |         |             |                    |               |                                         |                                               |     "X2.I"                                                           |
|                                      |         |             |                    |               |                                         |                                               |   ]                                                                  |
|                                      |         |             |                    |               |                                         |                                               | }                                                                    |
| 01a8f330-0507-3f5b-0000-43830248e09a |       1 |           1 |              [ 0 ] | Sort          | {                                       | {                                             | {                                                                    |
|                                      |         |             |                    |               |   "input_rows": 64,                     |   "overall_percentage": 0.000000000000000e+00 |   "sort_keys": [                                                     |
|                                      |         |             |                    |               |   "output_rows": 64                     | }                                             |     "X1.I ASC NULLS LAST",                                           |
|                                      |         |             |                    |               | }                                       |                                               |     "X2.I ASC NULLS LAST"                                            |
|                                      |         |             |                    |               |                                         |                                               |   ]                                                                  |
|                                      |         |             |                    |               |                                         |                                               | }                                                                    |
| 01a8f330-0507-3f5b-0000-43830248e09a |       1 |           2 |              [ 1 ] | Join          | {                                       | {                                             | {                                                                    |
|                                      |         |             |                    |               |   "input_rows": 128,                    |   "overall_percentage": 0.000000000000000e+00 |   "equality_join_condition": "(X2.I = X1.I)",                        |
|                                      |         |             |                    |               |   "output_rows": 64                     | }                                             |   "join_type": "INNER"                                               |
|                                      |         |             |                    |               | }                                       |                                               | }                                                                    |
| 01a8f330-0507-3f5b-0000-43830248e09a |       1 |           3 |              [ 2 ] | TableScan     | {                                       | {                                             | {                                                                    |
|                                      |         |             |                    |               |   "io": {                               |   "overall_percentage": 0.000000000000000e+00 |   "columns": [                                                       |
|                                      |         |             |                    |               |     "bytes_scanned": 1024,              | }                                             |     "I"                                                              |
|                                      |         |             |                    |               |     "percentage_scanned_from_cache": 1, |                                               |   ],                                                                 |
|                                      |         |             |                    |               |     "scan_progress": 1                  |                                               |   "table_name": "MY_DB.MY_SCHEMA.X2" |
|                                      |         |             |                    |               |   },                                    |                                               | }                                                                    |
|                                      |         |             |                    |               |   "output_rows": 64,                    |                                               |                                                                      |
|                                      |         |             |                    |               |   "pruning": {                          |                                               |                                                                      |
|                                      |         |             |                    |               |     "partitions_scanned": 1,            |                                               |                                                                      |
|                                      |         |             |                    |               |     "partitions_total": 1               |                                               |                                                                      |
|                                      |         |             |                    |               |   }                                     |                                               |                                                                      |
|                                      |         |             |                    |               | }                                       |                                               |                                                                      |
| 01a8f330-0507-3f5b-0000-43830248e09a |       1 |           4 |              [ 2 ] | JoinFilter    | {                                       | {                                             | {                                                                    |
|                                      |         |             |                    |               |   "input_rows": 64,                     |   "overall_percentage": 0.000000000000000e+00 |   "join_id": "2"                                                     |
|                                      |         |             |                    |               |   "output_rows": 64                     | }                                             | }                                                                    |
|                                      |         |             |                    |               | }                                       |                                               |                                                                      |
| 01a8f330-0507-3f5b-0000-43830248e09a |       1 |           5 |              [ 4 ] | TableScan     | {                                       | {                                             | {                                                                    |
|                                      |         |             |                    |               |   "io": {                               |   "overall_percentage": 0.000000000000000e+00 |   "columns": [                                                       |
|                                      |         |             |                    |               |     "bytes_scanned": 1024,              | }                                             |     "I"                                                              |
|                                      |         |             |                    |               |     "percentage_scanned_from_cache": 1, |                                               |   ],                                                                 |
|                                      |         |             |                    |               |     "scan_progress": 1                  |                                               |   "table_name": "MY_DB.MY_SCHEMA.X1" |
|                                      |         |             |                    |               |   },                                    |                                               | }                                                                    |
|                                      |         |             |                    |               |   "output_rows": 64,                    |                                               |                                                                      |
|                                      |         |             |                    |               |   "pruning": {                          |                                               |                                                                      |
|                                      |         |             |                    |               |     "partitions_scanned": 1,            |                                               |                                                                      |
|                                      |         |             |                    |               |     "partitions_total": 1               |                                               |                                                                      |
|                                      |         |             |                    |               |   }                                     |                                               |                                                                      |
|                                      |         |             |                    |               | }                                       |                                               |                                                                      |
+--------------------------------------+---------+-------------+--------------------+---------------+-----------------------------------------+-----------------------------------------------+----------------------------------------------------------------------+

-- Example 4614
select *
from t1
    join t2 on t1.a = t2.a
    join t3 on t1.b = t3.b
    join t4 on t1.c = t4.c
;

-- Example 4615
set lid = last_query_id();

-- Example 4616
select
        operator_id,
        operator_attributes,
        operator_statistics:output_rows / operator_statistics:input_rows as row_multiple
    from table(get_query_operator_stats($lid))
    where operator_type = 'Join'
    order by step_id, operator_id;

+---------+-------------+--------------------------------------------------------------------------+---------------+
| STEP_ID | OPERATOR_ID | OPERATOR_ATTRIBUTES                                                      | ROW_MULTIPLE  |
+---------+-------------+--------------------------------------------------------------------------+---------------+
|       1 |           1 | {  "equality_join_condition": "(T4.C = T1.C)",   "join_type": "INNER"  } |  49.969249692 |
|       1 |           3 | {  "equality_join_condition": "(T3.B = T1.B)",   "join_type": "INNER"  } | 116.071428571 |
|       1 |           5 | {  "equality_join_condition": "(T2.A = T1.A)",   "join_type": "INNER"  } |  12.20657277  |
+---------+-------------+--------------------------------------------------------------------------+---------------+

-- Example 4617
GET_RELATIVE_PATH( @<stage_name> , '<absolute_file_path>' )

-- Example 4618
SELECT GET_RELATIVE_PATH(@images_stage, 's3://photos/national_parks/us/yosemite/half_dome.jpg');
+================================================================================---------------------+
| GET_RELATIVE_PATH(@IMAGES_STAGE, 'S3://PHOTOS/NATIONAL_PARKS/US/YOSEMITE/HALF_DOME.JPG')  |
+================================================================================---------------------+
| us/yosemite/half_dome.jpg                                                                 |
+================================================================================---------------------+

-- Example 4619
GET_STAGE_LOCATION( @<stage_name> )

-- Example 4620
CREATE STAGE images_stage URL = 's3://photos/national_parks/us/yosemite/';

SELECT GET_STAGE_LOCATION(@images_stage);

+----------------------------------------------------------+
| GET_STAGE_LOCATION(@IMAGES_STAGE)                        |
+----------------------------------------------------------+
| s3://photos/national_parks/us/yosemite/                  |
+----------------------------------------------------------+

-- Example 4621
GETBIT( <integer_expr>, <bit_position> )

-- Example 4622
SELECT GETBIT(11, 100), GETBIT(11, 3), GETBIT(11, 2), GETBIT(11, 1), GETBIT(11, 0);

-- Example 4623
+-----------------+---------------+---------------+---------------+---------------+
| GETBIT(11, 100) | GETBIT(11, 3) | GETBIT(11, 2) | GETBIT(11, 1) | GETBIT(11, 0) |
|-----------------+---------------+---------------+---------------+---------------|
|               0 |             1 |             0 |             1 |             1 |
+-----------------+---------------+---------------+---------------+---------------+

-- Example 4624
GETDATE()

-- Example 4625
SELECT GETDATE();

-- Example 4626
+-------------------------------+
| GETDATE()                     |
|-------------------------------|
| 2024-04-17 15:44:20.960000000 |
+-------------------------------+

-- Example 4627
GETVARIABLE( '<name>' )

-- Example 4628
SET MY_LOCAL_VARIABLE= 'my_local_variable_value';
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
SELECT 
    GETVARIABLE('MY_LOCAL_VARIABLE'), 
    SESSION_CONTEXT('MY_LOCAL_VARIABLE'),
    $MY_LOCAL_VARIABLE;
+----------------------------------+--------------------------------------+-------------------------+
| GETVARIABLE('MY_LOCAL_VARIABLE') | SESSION_CONTEXT('MY_LOCAL_VARIABLE') | $MY_LOCAL_VARIABLE      |
|----------------------------------+--------------------------------------+-------------------------|
| my_local_variable_value          | my_local_variable_value              | my_local_variable_value |
+----------------------------------+--------------------------------------+-------------------------+

-- Example 4629
SET var_2 = 'value_2';
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
SELECT 
    GETVARIABLE('var_2'),
    GETVARIABLE('VAR_2'),
    SESSION_CONTEXT('var_2'),
    SESSION_CONTEXT('VAR_2'),
    $var_2,
    $VAR_2;
+----------------------+----------------------+--------------------------+--------------------------+---------+---------+
| GETVARIABLE('VAR_2') | GETVARIABLE('VAR_2') | SESSION_CONTEXT('VAR_2') | SESSION_CONTEXT('VAR_2') | $VAR_2  | $VAR_2  |
|----------------------+----------------------+--------------------------+--------------------------+---------+---------|
| NULL                 | value_2              | NULL                     | value_2                  | value_2 | value_2 |
+----------------------+----------------------+--------------------------+--------------------------+---------+---------+

-- Example 4630
GREATEST( <expr1> [ , <expr2> ... ] )

-- Example 4631
CREATE TABLE test_table_1_greatest (
  col_1 INTEGER, 
  col_2 INTEGER, 
  col_3 INTEGER, 
  col_4 FLOAT);
INSERT INTO test_table_1_greatest (col_1, col_2, col_3, col_4) VALUES
  (1, 2,    3,  4.00),
  (2, 4,   -1, -2.00),
  (3, 6, NULL, 13.45);

-- Example 4632
SELECT col_1,
       col_2,
       col_3,
       GREATEST(col_1, col_2, col_3) AS greatest
  FROM test_table_1_greatest
  ORDER BY col_1;

-- Example 4633
+-------+-------+-------+----------+
| COL_1 | COL_2 | COL_3 | GREATEST |
|-------+-------+-------+----------|
|     1 |     2 |     3 |        3 |
|     2 |     4 |    -1 |        4 |
|     3 |     6 |  NULL |     NULL |
+-------+-------+-------+----------+

-- Example 4634
SELECT col_1,
       col_4,
       GREATEST(col_1, col_4) AS greatest
  FROM test_table_1_greatest
  ORDER BY col_1;

-- Example 4635
+-------+-------+----------+
| COL_1 | COL_4 | GREATEST |
|-------+-------+----------|
|     1 |  4    |     4    |
|     2 | -2    |     2    |
|     3 | 13.45 |    13.45 |
+-------+-------+----------+

-- Example 4636
GREATEST_IGNORE_NULLS( <expr1> [ , <expr2> ... ] )

-- Example 4637
CREATE TABLE test_greatest_ignore_nulls (
  col_1 INTEGER,
  col_2 INTEGER,
  col_3 INTEGER,
  col_4 FLOAT);

INSERT INTO test_greatest_ignore_nulls (col_1, col_2, col_3, col_4) VALUES
  (1, 2,    3,  4.25),
  (2, 4,   -1,  NULL),
  (3, 6, NULL,  -2.75);

-- Example 4638
SELECT col_1,
       col_2,
       col_3,
       col_4,
       GREATEST_IGNORE_NULLS(col_1, col_2, col_3, col_4) AS greatest_ignore_nulls
 FROM test_greatest_ignore_nulls
 ORDER BY col_1;

-- Example 4639
+-------+-------+-------+-------+-----------------------+
| COL_1 | COL_2 | COL_3 | COL_4 | GREATEST_IGNORE_NULLS |
|-------+-------+-------+-------+-----------------------|
|     1 |     2 |     3 |  4.25 |                  4.25 |
|     2 |     4 |    -1 |  NULL |                  4    |
|     3 |     6 |  NULL | -2.75 |                  6    |
+-------+-------+-------+-------+-----------------------+

-- Example 4640
SELECT ...
  FROM ...
  [ ... ]
  GROUP BY groupItem [ , groupItem [ , ... ] ]
  [ ... ]

-- Example 4641
SELECT ...
  FROM ...
  [ ... ]
  GROUP BY ALL
  [ ... ]

-- Example 4642
groupItem ::= { <column_alias> | <position> | <expr> }

-- Example 4643
SELECT SUM(amount)
  FROM mytable
  GROUP BY ALL;

-- Example 4644
SELECT SUM(amount)
  FROM mytable;

-- Example 4645
CREATE TABLE sales (
  product_ID INTEGER,
  retail_price REAL,
  quantity INTEGER,
  city VARCHAR,
  state VARCHAR);

INSERT INTO sales (product_id, retail_price, quantity, city, state) VALUES
  (1, 2.00,  1, 'SF', 'CA'),
  (1, 2.00,  2, 'SJ', 'CA'),
  (2, 5.00,  4, 'SF', 'CA'),
  (2, 5.00,  8, 'SJ', 'CA'),
  (2, 5.00, 16, 'Miami', 'FL'),
  (2, 5.00, 32, 'Orlando', 'FL'),
  (2, 5.00, 64, 'SJ', 'PR');

CREATE TABLE products (
  product_ID INTEGER,
  wholesale_price REAL);
INSERT INTO products (product_ID, wholesale_price) VALUES (1, 1.00);
INSERT INTO products (product_ID, wholesale_price) VALUES (2, 2.00);

-- Example 4646
SELECT product_ID, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY product_ID;

-- Example 4647
+------------+---------------+
| PRODUCT_ID | GROSS_REVENUE |
+============+===============+
|          1 |          6    |
+------------+---------------+
|          2 |        620    |
+------------+---------------+

-- Example 4648
SELECT p.product_ID, SUM((s.retail_price - p.wholesale_price) * s.quantity) AS profit
  FROM products AS p, sales AS s
  WHERE s.product_ID = p.product_ID
  GROUP BY p.product_ID;

-- Example 4649
+------------+--------+
| PRODUCT_ID | PROFIT |
+============+========+
|          1 |      3 |
+------------+--------+
|          2 |    372 |
+------------+--------+

-- Example 4650
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY state, city;

-- Example 4651
+-------+---------+---------------+
| STATE |   CITY  | GROSS REVENUE |
+=======+=========+===============+
|   CA  | SF      |            22 |
+-------+---------+---------------+
|   CA  | SJ      |            44 |
+-------+---------+---------------+
|   FL  | Miami   |            80 |
+-------+---------+---------------+
|   FL  | Orlando |           160 |
+-------+---------+---------------+
|   PR  | SJ      |           320 |
+-------+---------+---------------+

-- Example 4652
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY ALL;

-- Example 4653
+-------+---------+---------------+
| STATE |   CITY  | GROSS REVENUE |
+=======+=========+===============+
|   CA  | SF      |            22 |
+-------+---------+---------------+
|   CA  | SJ      |            44 |
+-------+---------+---------------+
|   FL  | Miami   |            80 |
+-------+---------+---------------+
|   FL  | Orlando |           160 |
+-------+---------+---------------+
|   PR  | SJ      |           320 |
+-------+---------+---------------+

-- Example 4654
SELECT x, some_expression AS x
  FROM ...

-- Example 4655
Create table employees (salary float, state varchar, employment_state varchar);
insert into employees (salary, state, employment_state) values
    (60000, 'California', 'Active'),
    (70000, 'California', 'On leave'),
    (80000, 'Oregon', 'Active');

-- Example 4656
select sum(salary), ANY_VALUE(employment_state)
    from employees
    group by employment_state;
+-------------+-----------------------------+
| SUM(SALARY) | ANY_VALUE(EMPLOYMENT_STATE) |
|-------------+-----------------------------|
|      140000 | Active                      |
|       70000 | On leave                    |
+-------------+-----------------------------+

-- Example 4657
select sum(salary), ANY_VALUE(employment_state) as state
    from employees
    group by state;
+-------------+--------+
| SUM(SALARY) | STATE  |
|-------------+--------|
|      130000 | Active |
|       80000 | Active |
+-------------+--------+

-- Example 4658
H3_CELL_TO_BOUNDARY( <cell_id> )

-- Example 4659
SELECT H3_CELL_TO_BOUNDARY(613036919424548863);

-- Example 4660
+-----------------------------------------+
| H3_CELL_TO_BOUNDARY(613036919424548863) |
|-----------------------------------------|
| {                                       |
|   "coordinates": [                      |
|     [                                   |
|       [                                 |
|         1.337146281884266e+01,          |
|         5.251934565725256e+01           |
|       ],                                |
|       [                                 |
|         1.336924966147084e+01,          |
|         5.251510220405509e+01           |
|       ],                                |
|       [                                 |
|         1.337455447449988e+01,          |
|         5.251214028989955e+01           |
|       ],                                |
|       [                                 |
|         1.338207263166664e+01,          |
|         5.251342164903257e+01           |
|       ],                                |
|       [                                 |
|         1.338428664751681e+01,          |
|         5.251766506194694e+01           |
|       ],                                |
|       [                                 |
|         1.337898164779325e+01,          |
|         5.252062715603375e+01           |
|       ],                                |
|       [                                 |
|         1.337146281884266e+01,          |
|         5.251934565725256e+01           |
|       ]                                 |
|     ]                                   |
|   ],                                    |
|   "type": "Polygon"                     |
| }                                       |
+-----------------------------------------+

-- Example 4661
SELECT H3_CELL_TO_BOUNDARY('881F1D4887FFFFF');

-- Example 4662
+----------------------------------------+
| H3_CELL_TO_BOUNDARY('881F1D4887FFFFF') |
|----------------------------------------|
| {                                      |
|   "coordinates": [                     |
|     [                                  |
|       [                                |
|         1.337146281884266e+01,         |
|         5.251934565725256e+01          |
|       ],                               |
|       [                                |
|         1.336924966147084e+01,         |
|         5.251510220405509e+01          |
|       ],                               |
|       [                                |
|         1.337455447449988e+01,         |
|         5.251214028989955e+01          |
|       ],                               |
|       [                                |
|         1.338207263166664e+01,         |
|         5.251342164903257e+01          |
|       ],                               |
|       [                                |
|         1.338428664751681e+01,         |
|         5.251766506194694e+01          |
|       ],                               |
|       [                                |
|         1.337898164779325e+01,         |
|         5.252062715603375e+01          |
|       ],                               |
|       [                                |
|         1.337146281884266e+01,         |
|         5.251934565725256e+01          |
|       ]                                |
|     ]                                  |
|   ],                                   |
|   "type": "Polygon"                    |
| }                                      |
+----------------------------------------+

-- Example 4663
CREATE OR REPLACE TABLE geospatial_table (id INTEGER, g GEOGRAPHY);
INSERT INTO geospatial_table VALUES
  (1, 'POINT(-122.35 37.55)'),
  (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 4664
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='GeoJSON';

-- Example 4665
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 4666
+------------------------+
| G                      |
|------------------------|
| {                      |
|   "coordinates": [     |
|     -122.35,           |
|     37.55              |
|   ],                   |
|   "type": "Point"      |
| }                      |
| {                      |
|   "coordinates": [     |
|     [                  |
|       -124.2,          |
|       42               |
|     ],                 |
|     [                  |
|       -120.01,         |
|       41.99            |
|     ]                  |
|   ],                   |
|   "type": "LineString" |
| }                      |
+------------------------+

-- Example 4667
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKT';

-- Example 4668
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 4669
+-------------------------------------+
| G                                   |
|-------------------------------------|
| POINT(-122.35 37.55)                |
| LINESTRING(-124.2 42,-120.01 41.99) |
+-------------------------------------+

-- Example 4670
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKB';

-- Example 4671
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 4672
+------------------------------------------------------------------------------------+
| G                                                                                  |
|------------------------------------------------------------------------------------|
| 01010000006666666666965EC06666666666C64240                                         |
| 010200000002000000CDCCCCCCCC0C5FC00000000000004540713D0AD7A3005EC01F85EB51B8FE4440 |
+------------------------------------------------------------------------------------+

