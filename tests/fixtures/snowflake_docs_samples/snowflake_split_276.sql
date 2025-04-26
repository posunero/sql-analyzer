-- Example 18470
+-------+-----+---------+
|    N1 |  N2 | N1 * N2 |
|-------+-----+---------|
| 10.01 | 1.1 |  11.011 |
+-------+-----+---------+

-- Example 18471
SELECT 10.001 n1, .001 n2, n1 * n2;

-- Example 18472
+--------+-------+----------+
|     I1 |    I2 |  I1 * I2 |
|--------+-------+----------|
| 10.001 | 0.001 | 0.010001 |
+--------+-------+----------+

-- Example 18473
SELECT .1 n1, .0000000000001 n2, n1 * n2;

-- Example 18474
+-----+-----------------+-----------------+
|  N1 |              N2 |         N1 * N2 |
|-----+-----------------+-----------------|
| 0.1 | 0.0000000000001 | 0.0000000000000 |
+-----+-----------------+-----------------+

-- Example 18475
SELECT 2 n1, 7 n2, n1 / n2;

-- Example 18476
+----+----+----------+
| N1 | N2 |  N1 / N2 |
|----+----+----------|
|  2 |  7 | 0.285714 |
+----+----+----------+

-- Example 18477
SELECT 10.1 n1, 2.1 n2, n1 / n2;

-- Example 18478
+------+-----+-----------+
|   N1 |  N2 |   N1 / N2 |
|------+-----+-----------|
| 10.1 | 2.1 | 4.8095238 |
+------+-----+-----------+

-- Example 18479
SELECT 10.001 n1, .001 n2, n1 / n2;

-- Example 18480
+--------+-------+-----------------+
|     N1 |    N2 |         N1 / N2 |
|--------+-------+-----------------|
| 10.001 | 0.001 | 10001.000000000 |
+--------+-------+-----------------+

-- Example 18481
SELECT .1 n1, .0000000000001 n2, n1 / n2;

-- Example 18482
+-----+-----------------+-----------------------+
|  N1 |              N2 |               N1 / N2 |
|-----+-----------------+-----------------------|
| 0.1 | 0.0000000000001 | 1000000000000.0000000 |
+-----+-----------------+-----------------------+

-- Example 18483
** <array>

-- Example 18484
CREATE OR REPLACE TABLE spread_demo (col1 INT, col2 VARCHAR);

INSERT INTO spread_demo VALUES
  (1, 'a'),
  (2, 'b'),
  (3, 'c'),
  (4, 'd'),
  (5, 'e');

SELECT * FROM spread_demo;

-- Example 18485
+------+------+
| COL1 | COL2 |
|------+------|
|    1 | a    |
|    2 | b    |
|    3 | c    |
|    4 | d    |
|    5 | e    |
+------+------+

-- Example 18486
SELECT * FROM spread_demo
  WHERE col1 IN (** [3, 4])
  ORDER BY col1;

-- Example 18487
+------+------+
| COL1 | COL2 |
|------+------|
|    3 | c    |
|    4 | d    |
+------+------+

-- Example 18488
SELECT * FROM spread_demo
  WHERE col2 IN (** ['b', 'd'])
  ORDER BY col1;

-- Example 18489
+------+------+
| COL1 | COL2 |
|------+------|
|    2 | b    |
|    4 | d    |
+------+------+

-- Example 18490
SELECT * FROM spread_demo
  WHERE col1 IN (** [1, 2], 4, 5)
  ORDER BY col1;

-- Example 18491
+------+------+
| COL1 | COL2 |
|------+------|
|    1 | a    |
|    2 | b    |
|    4 | d    |
|    5 | e    |
+------+------+

-- Example 18492
SELECT COALESCE(** [NULL, NULL, 'my_string_1', 'my_string_2']) AS first_non_null;

-- Example 18493
+----------------+
| FIRST_NON_NULL |
|----------------|
| my_string_1    |
+----------------+

-- Example 18494
SELECT GREATEST(** [1, 2, 5, 4, 5]) AS greatest_value;

-- Example 18495
+----------------+
| GREATEST_VALUE |
|----------------|
|              5 |
+----------------+

-- Example 18496
CREATE OR REPLACE FUNCTION spread_function_demo(col_1_values ARRAY)
  RETURNS TABLE(
    col1 INT,
    col2 VARCHAR)
AS
$$
   SELECT * FROM spread_demo
     WHERE col1 IN (** col_1_values)
     ORDER BY col1
$$;

-- Example 18497
SELECT * FROM TABLE(spread_function_demo([1, 3, 5]));

-- Example 18498
+------+------+
| COL1 | COL2 |
|------+------|
|    1 | a    |
|    3 | c    |
|    5 | e    |
+------+------+

-- Example 18499
CREATE OR REPLACE PROCEDURE spread_sp_demo(col_1_values ARRAY)
  RETURNS TABLE(
    col1 INT,
    col2 VARCHAR)
  LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET;
BEGIN
  res := (SELECT * FROM spread_demo
     WHERE col1 IN (** :col_1_values)
     ORDER BY col1);
  RETURN TABLE(res);
END;
$$;

-- Example 18500
CALL spread_sp_demo([2, 4]);

-- Example 18501
+------+------+
| COL1 | COL2 |
|------+------|
|    2 | b    |
|    4 | d    |
+------+------+

-- Example 18502
CREATE OR REPLACE TABLE logical_test1 (id INT, a INT, b VARCHAR);

INSERT INTO logical_test1 (id, a, b) VALUES (1, 8, 'Up');
INSERT INTO logical_test1 (id, a, b) VALUES (2, 25, 'Down');
INSERT INTO logical_test1 (id, a, b) VALUES (3, 15, 'Down');
INSERT INTO logical_test1 (id, a, b) VALUES (4, 47, 'Up');

SELECT * FROM logical_test1;

-- Example 18503
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  1 |  8 | Up   |
|  2 | 25 | Down |
|  3 | 15 | Down |
|  4 | 47 | Up   |
+----+----+------+

-- Example 18504
SELECT *
  FROM logical_test1
  WHERE a > 20 AND
        b = 'Down';

-- Example 18505
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  2 | 25 | Down |
+----+----+------+

-- Example 18506
SELECT *
  FROM logical_test1
  WHERE a > 20 OR
        b = 'Down';

-- Example 18507
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  2 | 25 | Down |
|  3 | 15 | Down |
|  4 | 47 | Up   |
+----+----+------+

-- Example 18508
SELECT *
  FROM logical_test1
  WHERE a > 20 OR
        b = 'Up';

-- Example 18509
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  1 |  8 | Up   |
|  2 | 25 | Down |
|  4 | 47 | Up   |
+----+----+------+

-- Example 18510
SELECT *
  FROM logical_test1
  WHERE NOT a > 20;

-- Example 18511
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  1 |  8 | Up   |
|  3 | 15 | Down |
+----+----+------+

-- Example 18512
SELECT *
  FROM logical_test1
  WHERE b = 'Down' OR
        a = 8 AND b = 'Up';

-- Example 18513
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  1 |  8 | Up   |
|  2 | 25 | Down |
|  3 | 15 | Down |
+----+----+------+

-- Example 18514
SELECT *
  FROM logical_test1
  WHERE (b = 'Down' OR a = 8) AND b = 'Up';

-- Example 18515
+----+---+----+
| ID | A | B  |
|----+---+----|
|  1 | 8 | Up |
+----+---+----+

-- Example 18516
SELECT *
  FROM logical_test1
  WHERE NOT a = 15 AND b = 'Down';

-- Example 18517
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  2 | 25 | Down |
+----+----+------+

-- Example 18518
SELECT *
  FROM logical_test1
  WHERE NOT (a = 15 AND b = 'Down');

-- Example 18519
+----+----+------+
| ID |  A | B    |
|----+----+------|
|  1 |  8 | Up   |
|  2 | 25 | Down |
|  4 | 47 | Up   |
+----+----+------+

-- Example 18520
CREATE OR REPLACE TABLE logical_test2 (a BOOLEAN, b BOOLEAN);

INSERT INTO logical_test2 VALUES (0, 1);

SELECT * FROM logical_test2;

-- Example 18521
+-------+------+
| A     | B    |
|-------+------|
| False | True |
+-------+------+

-- Example 18522
SELECT a, b FROM logical_test2 WHERE a OR b;

-- Example 18523
+-------+------+
| A     | B    |
|-------+------|
| False | True |
+-------+------+

-- Example 18524
SELECT a, b FROM logical_test2 WHERE a AND b;

-- Example 18525
+---+---+
| A | B |
|---+---|
+---+---+

-- Example 18526
SELECT a, b FROM logical_test2 WHERE b AND NOT a;

-- Example 18527
+-------+------+
| A     | B    |
|-------+------|
| False | True |
+-------+------+

-- Example 18528
SELECT a, b FROM logical_test2 WHERE a AND NOT b;

-- Example 18529
+---+---+
| A | B |
|---+---|
+---+---+

-- Example 18530
CREATE OR REPLACE TABLE logical_test3 (x BOOLEAN);

INSERT INTO logical_test3 (x) VALUES
  (False),
  (True),
  (NULL);

-- Example 18531
SELECT x AS "OR",
       x OR False AS "FALSE",
       x OR True AS "TRUE",
       x OR NULL AS "NULL"
  FROM logical_test3;

-- Example 18532
+-------+-------+------+------+
| OR    | FALSE | TRUE | NULL |
|-------+-------+------+------|
| False | False | True | NULL |
| True  | True  | True | True |
| NULL  | NULL  | True | NULL |
+-------+-------+------+------+

-- Example 18533
SELECT x AS "AND",
       x AND False AS "FALSE",
       x AND True AS "TRUE",
       x AND NULL AS "NULL"
  FROM logical_test3;

-- Example 18534
+-------+-------+-------+-------+
| AND   | FALSE | TRUE  | NULL  |
|-------+-------+-------+-------|
| False | False | False | False |
| True  | False | True  | NULL  |
| NULL  | False | NULL  | NULL  |
+-------+-------+-------+-------+

-- Example 18535
<expr> comparisonOperator { ALL | ANY } ( <query> )

-- Example 18536
comparisonOperator ::=
  { = | != | > | >= | < | <= }

