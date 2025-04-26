-- Example 1
MAX( <expr> )

-- Example 2
MAX( <expr> ) [ OVER ( [ PARTITION BY <expr1> ] [ ORDER BY <expr2> [ <window_frame> ] ] ) ]

-- Example 3
CREATE OR REPLACE TABLE sample_table(k CHAR(4), d CHAR(4));

INSERT INTO sample_table VALUES
    ('1', '1'), ('1', '5'), ('1', '3'),
    ('2', '2'), ('2', NULL),
    ('3', NULL),
    (NULL, '7'), (NULL, '1');

-- Example 4
SELECT k, d
    FROM sample_table
    ORDER BY k, d;

-- Example 5
+------+------+
| K    | D    |
|------+------|
| 1    | 1    |
| 1    | 3    |
| 1    | 5    |
| 2    | 2    |
| 2    | NULL |
| 3    | NULL |
| NULL | 1    |
| NULL | 7    |
+------+------+

-- Example 6
SELECT MAX(d) FROM sample_table;

-- Example 7
+--------+                                                                      
| MAX(D) |
|--------|
| 7      |
+--------+

-- Example 8
SELECT k, MAX(d)
  FROM sample_table 
  GROUP BY k
  ORDER BY k;

-- Example 9
+------+--------+                                                               
| K    | MAX(D) |
|------+--------|
| 1    | 5      |
| 2    | 2      |
| 3    | NULL   |
| NULL | 7      |
+------+--------+

-- Example 10
SELECT k, d, MAX(d) OVER (PARTITION BY k)
  FROM sample_table
  ORDER BY k, d;

-- Example 11
+------+------+------------------------------+                                  
| K    | D    | MAX(D) OVER (PARTITION BY K) |
|------+------+------------------------------|
| 1    | 1    | 5                            |
| 1    | 3    | 5                            |
| 1    | 5    | 5                            |
| 2    | 2    | 2                            |
| 2    | NULL | 2                            |
| 3    | NULL | NULL                         |
| NULL | 1    | 7                            |
| NULL | 7    | 7                            |
+------+------+------------------------------+

-- Example 12
SELECT k, d, MAX(d) OVER (ORDER BY k, d ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
  FROM sample_table
  ORDER BY k, d;

-- Example 13
+------+------+----------------------------------------------------------------------+
| K    | D    | MAX(D) OVER (ORDER BY K, D ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) |
|------+------+----------------------------------------------------------------------|
| 1    | 1    | 1                                                                    |
| 1    | 3    | 3                                                                    |
| 1    | 5    | 5                                                                    |
| 2    | 2    | 5                                                                    |
| 2    | NULL | 2                                                                    |
| 3    | NULL | NULL                                                                 |
| NULL | 1    | 1                                                                    |
| NULL | 7    | 7                                                                    |
+------+------+----------------------------------------------------------------------+

-- Example 14
from snowflake.snowpark import Sessionfrom snowflake.snowpark.functions import col# Create a new session, using the connection properties specified in a file.new_session = Session.builder.configs(connection_parameters).create()# Create a DataFrame that contains the id, name, and serial_number# columns in the “sample_product_data” table.df = session.table("sample_product_data").select(col("id"), col("name"), col("name"), col("serial_number"))# Show the results df.show()

-- Example 15
-- Variable declaration
[ DECLARE ... ]
  ...
BEGIN
  ...
  -- Branching
  [ IF ... ]
  [ CASE ... ]

  -- Looping
  [ FOR ... ]
  [ WHILE ... ]
  [ REPEAT ... ]
  [ LOOP ... ]

  -- Loop termination (within a looping construct)
  [ BREAK ]
  [ CONTINUE ]

  -- Variable assignment
  [ LET ... ]

  -- Cursor management
  [ OPEN ... ]
  [ FETCH ... ]
  [ CLOSE ... ]

  -- Asynchronous child job management
  [ AWAIT ... ]
  [ CANCEL ... ]

  -- "No-op" (no-operation) statement (usually within a branch or exception)
  [ NULL ]

  -- Raising exceptions
  [ RAISE ... ]

  -- Returning a value
  [ RETURN ... ]

-- Exception handling
[ EXCEPTION ... ]

END;

-- Example 16
CREATE TABLE simple (x INTEGER, y INTEGER);
INSERT INTO simple (x, y) VALUES
    (10, 20),
    (20, 44),
    (30, 70);

-- Example 17
SELECT x, y 
    FROM simple
    ORDER BY x,y;

-- Example 18
+----+----+
|  X |  Y |
|----+----|
| 10 | 20 |
| 20 | 44 |
| 30 | 70 |
+----+----+

-- Example 19
SELECT COS(x)
    FROM simple
    ORDER BY x;

-- Example 20
+---------------+
|        COS(X) |
|---------------|
| -0.8390715291 |
|  0.4080820618 |
|  0.1542514499 |
+---------------+

-- Example 21
SELECT SUM(x)
    FROM simple;

-- Example 22
+--------+
| SUM(X) |
|--------|
|     60 |
+--------+

-- Example 23
SELECT COUNT(col1, col2) FROM table1;

-- Example 24
CREATE OR REPLACE TABLE test_null_aggregate_functions (x INT, y INT);
INSERT INTO test_null_aggregate_functions (x, y) VALUES
  (1, 2),         -- No NULLs.
  (3, NULL),      -- One but not all columns are NULL.
  (NULL, 6),      -- One but not all columns are NULL.
  (NULL, NULL);   -- All columns are NULL.

-- Example 25
SELECT COUNT(x, y) FROM test_null_aggregate_functions;

-- Example 26
+-------------+
| COUNT(X, Y) |
|-------------|
|           1 |
+-------------+

-- Example 27
SELECT SUM(x + y) FROM test_null_aggregate_functions;

-- Example 28
+------------+
| SUM(X + Y) |
|------------|
|          3 |
+------------+

-- Example 29
SELECT x AS X_COL, y AS Y_COL 
  FROM test_null_aggregate_functions 
  GROUP BY x, y;

-- Example 30
+-------+-------+
| X_COL | Y_COL |
|-------+-------|
|     1 |     2 |
|     3 |  NULL |
|  NULL |     6 |
|  NULL |  NULL |
+-------+-------+

-- Example 31
ANY_VALUE( [ DISTINCT ] <expr1> )

-- Example 32
ANY_VALUE( [ DISTINCT ] <expr1> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 33
SELECT customer.id , customer.name , SUM(orders.value)
  FROM customer
  JOIN orders ON customer.id = orders.customer_id
  GROUP BY customer.id , customer.name;

-- Example 34
SELECT customer.id , MIN(customer.name) , SUM(orders.value)
  FROM customer
  JOIN orders ON customer.id = orders.customer_id
  GROUP BY customer.id;

-- Example 35
SELECT customer.id , ANY_VALUE(customer.name) , SUM(orders.value)
  FROM customer
  JOIN orders ON customer.id = orders.customer_id
  GROUP BY customer.id;

-- Example 36
AVG( [ DISTINCT ] <expr1> )

-- Example 37
AVG( [ DISTINCT ] <expr1> ) OVER (
                                 [ PARTITION BY <expr2> ]
                                 [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                 )

-- Example 38
CREATE OR REPLACE TABLE avg_example(int_col int, d decimal(10,5), s1 varchar(10), s2 varchar(10));
INSERT INTO avg_example VALUES
    (1, 1.1, '1.1','one'), 
    (1, 10, '10','ten'),
    (2, 2.4, '2.4','two'), 
    (2, NULL, NULL, 'NULL'),
    (3, NULL, NULL, 'NULL'),
    (NULL, 9.9, '9.9','nine');

-- Example 39
SELECT * 
    FROM avg_example 
    ORDER BY int_col, d;
+---------+----------+------+------+
| INT_COL |        D | S1   | S2   |
|---------+----------+------+------|
|       1 |  1.10000 | 1.1  | one  |
|       1 | 10.00000 | 10   | ten  |
|       2 |  2.40000 | 2.4  | two  |
|       2 |     NULL | NULL | NULL |
|       3 |     NULL | NULL | NULL |
|    NULL |  9.90000 | 9.9  | nine |
+---------+----------+------+------+

-- Example 40
SELECT AVG(int_col), AVG(d)
    FROM avg_example;
+--------------+---------------+
| AVG(INT_COL) |        AVG(D) |
|--------------+---------------|
|     1.800000 | 5.85000000000 |
+--------------+---------------+

-- Example 41
SELECT int_col, AVG(d), AVG(s1) 
    FROM avg_example 
    GROUP BY int_col
    ORDER BY int_col;
+---------+---------------+---------+
| INT_COL |        AVG(D) | AVG(S1) |
|---------+---------------+---------|
|       1 | 5.55000000000 |    5.55 |
|       2 | 2.40000000000 |    2.4  |
|       3 |          NULL |    NULL |
|    NULL | 9.90000000000 |    9.9  |
+---------+---------------+---------+

-- Example 42
SELECT 
       int_col,
       AVG(int_col) OVER(PARTITION BY int_col) 
    FROM avg_example
    ORDER BY int_col;
+---------+-----------------------------------------+
| INT_COL | AVG(INT_COL) OVER(PARTITION BY INT_COL) |
|---------+-----------------------------------------|
|       1 |                                   1.000 |
|       1 |                                   1.000 |
|       2 |                                   2.000 |
|       2 |                                   2.000 |
|       3 |                                   3.000 |
|    NULL |                                    NULL |
+---------+-----------------------------------------+

-- Example 43
CORR( y , x )

-- Example 44
CORR( y , x ) OVER ( [ PARTITION BY <expr3> ] )

-- Example 45
CREATE OR REPLACE TABLE aggr(k int, v decimal(10,2), v2 decimal(10, 2));
INSERT INTO aggr VALUES(1, 10, NULL);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, NULL), (2, 30, 35);

SELECT * FROM aggr;

-- Example 46
+---+-------+-------+
| K |     V |    V2 |
|---+-------+-------|
| 1 | 10.00 |  NULL |
| 2 | 10.00 | 11.00 |
| 2 | 20.00 | 22.00 |
| 2 | 25.00 |  NULL |
| 2 | 30.00 | 35.00 |
+---+-------+-------+

-- Example 47
SELECT k, CORR(v, v2) FROM aggr GROUP BY k;

-- Example 48
+---+--------------+
| K |  CORR(V, V2) |
|---+--------------|
| 1 |         NULL |
| 2 | 0.9988445981 |
+---+--------------+

-- Example 49
COUNT( [ DISTINCT ] <expr1> [ , <expr2> ... ] )

COUNT(*)

COUNT(<alias>.*)

-- Example 50
COUNT( [ DISTINCT ] <expr1> [ , <expr2> ... ] ) OVER (
                                                     [ PARTITION BY <expr3> ]
                                                     [ ORDER BY <expr4> [ ASC | DESC ] [ <window_frame> ] ]
                                                     )

-- Example 51
(mytable.*)

-- Example 52
(* ILIKE 'col1%')

-- Example 53
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 54
(mytable.* ILIKE 'col1%')

-- Example 55
1, 1, 1
1, 1, 1
1, 1, 1
1, 1, 2

-- Example 56
CREATE TABLE basic_example (i_col INTEGER, j_col INTEGER);
INSERT INTO basic_example VALUES
    (11,101), (11,102), (11,NULL), (12,101), (NULL,101), (NULL,102);

-- Example 57
SELECT *
    FROM basic_example
    ORDER BY i_col;

-- Example 58
+-------+-------+
| I_COL | J_COL |
|-------+-------|
|    11 |   101 |
|    11 |   102 |
|    11 |  NULL |
|    12 |   101 |
|  NULL |   101 |
|  NULL |   102 |
+-------+-------+

-- Example 59
SELECT COUNT(*) AS "All",
       COUNT(* ILIKE 'i_c%') AS "ILIKE",
       COUNT(* EXCLUDE i_col) AS "EXCLUDE",
       COUNT(i_col) AS "i_col", 
       COUNT(DISTINCT i_col) AS "DISTINCT i_col", 
       COUNT(j_col) AS "j_col", 
       COUNT(DISTINCT j_col) AS "DISTINCT j_col"
  FROM basic_example;

-- Example 60
+-----+-------+---------+-------+----------------+-------+----------------+
| All | ILIKE | EXCLUDE | i_col | DISTINCT i_col | j_col | DISTINCT j_col |
|-----+-------+---------+-------+----------------+-------+----------------|
|   6 |     4 |       5 |     4 |              2 |     5 |              2 |
+-----+-------+---------+-------+----------------+-------+----------------+

-- Example 61
SELECT i_col, COUNT(*), COUNT(j_col)
    FROM basic_example
    GROUP BY i_col
    ORDER BY i_col;

-- Example 62
+-------+----------+--------------+
| I_COL | COUNT(*) | COUNT(J_COL) |
|-------+----------+--------------|
|    11 |        3 |            2 |
|    12 |        1 |            1 |
|  NULL |        2 |            2 |
+-------+----------+--------------+

-- Example 63
SELECT COUNT(n.*) FROM basic_example AS n;

-- Example 64
+------------+
| COUNT(N.*) |
|------------|
|          3 |
+------------+

-- Example 65
CREATE OR REPLACE TABLE count_example_with_variant_column (
  i_col INTEGER, 
  j_col INTEGER, 
  v VARIANT);

-- Example 66
BEGIN WORK;

INSERT INTO count_example_with_variant_column (i_col, j_col, v) 
  VALUES (NULL, 10, NULL);
INSERT INTO count_example_with_variant_column (i_col, j_col, v) 
  SELECT 1, 11, PARSE_JSON('{"Title": null}');
INSERT INTO count_example_with_variant_column (i_col, j_col, v) 
  SELECT 2, 12, PARSE_JSON('{"Title": "O"}');
INSERT INTO count_example_with_variant_column (i_col, j_col, v) 
  SELECT 3, 12, PARSE_JSON('{"Title": "I"}');

COMMIT WORK;

-- Example 67
SELECT i_col, j_col, v, v:Title
    FROM count_example_with_variant_column
    ORDER BY i_col;

-- Example 68
+-------+-------+-----------------+---------+
| I_COL | J_COL | V               | V:TITLE |
|-------+-------+-----------------+---------|
|     1 |    11 | {               | null    |
|       |       |   "Title": null |         |
|       |       | }               |         |
|     2 |    12 | {               | "O"     |
|       |       |   "Title": "O"  |         |
|       |       | }               |         |
|     3 |    12 | {               | "I"     |
|       |       |   "Title": "I"  |         |
|       |       | }               |         |
|  NULL |    10 | NULL            | NULL    |
+-------+-------+-----------------+---------+

