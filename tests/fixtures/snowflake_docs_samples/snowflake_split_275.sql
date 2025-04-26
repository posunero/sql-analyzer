-- Example 18403
ALTER SESSION SET week_of_year_policy=1, week_start=3;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 18404
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  53 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  53 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |   1 |        52 | 2017 |      2016 |
| 2017-01-02 | Mon |   1 |         1 | 2017 |      2017 |
| 2017-01-03 | Tue |   1 |         1 | 2017 |      2017 |
| 2017-01-04 | Wed |   2 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   2 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  53 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  53 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

-- Example 18405
SELECT <expression1>
   [ , <expression2> ]
   [ , <expressionN> ]
[ INTO :<variable1> ]
   [ , :<variable2> ]
   [ , :<variableN> ]
FROM ...
WHERE ...
[ ... ]

-- Example 18406
MATCH_RECOGNIZE (
    [ PARTITION BY <expr> [, ... ] ]
    [ ORDER BY <expr> [, ... ] ]
    [ MEASURES <expr> [AS] <alias> [, ... ] ]
    [ ONE ROW PER MATCH |
      ALL ROWS PER MATCH [ { SHOW EMPTY MATCHES | OMIT EMPTY MATCHES | WITH UNMATCHED ROWS } ]
      ]
    [ AFTER MATCH SKIP
          {
          PAST LAST ROW   |
          TO NEXT ROW   |
          TO [ { FIRST | LAST} ] <symbol>
          }
      ]
    PATTERN ( <pattern> )
    DEFINE <symbol> AS <expr> [, ... ]
)

-- Example 18407
DEFINE <symbol1> AS <expr1> [ , <symbol2> AS <expr2> ]

-- Example 18408
...
define
    my_example_symbol as true
...

-- Example 18409
PATTERN ( <pattern> )

-- Example 18410
PATTERN (S1 S2)

-- Example 18411
^ S1 S2*? ( {- S3 -} S4 )+ | PERMUTE(S1, S2){1,2} $

-- Example 18412
symbol1+ any_symbol* symbol2

-- Example 18413
symbol1{1,limit} not_symbol1{,limit} symbol2

-- Example 18414
orderItem ::= { <column_alias> | <expr> } [ ASC | DESC ] [ NULLS { FIRST | LAST } ]

-- Example 18415
MEASURES <expr1> [AS] <alias1> [ ... , <exprN> [AS] <aliasN> ]

-- Example 18416
{
  ONE ROW PER MATCH  |
  ALL ROWS PER MATCH [ { SHOW EMPTY MATCHES | OMIT EMPTY MATCHES | WITH UNMATCHED ROWS } ]
}

-- Example 18417
AFTER MATCH SKIP
{
    PAST LAST ROW   |
    TO NEXT ROW   |
    TO [ { FIRST | LAST} ] <symbol>
}

-- Example 18418
expr ::= ... [ { RUNNING | FINAL } ] windowFunction ...

-- Example 18419
predicatedColumnReference ::= <symbol>.<column>

-- Example 18420
create table stock_price_history (company TEXT, price_date DATE, price INT);

-- Example 18421
insert into stock_price_history values
    ('ABCD', '2020-10-01', 50),
    ('XYZ' , '2020-10-01', 89),
    ('ABCD', '2020-10-02', 36),
    ('XYZ' , '2020-10-02', 24),
    ('ABCD', '2020-10-03', 39),
    ('XYZ' , '2020-10-03', 37),
    ('ABCD', '2020-10-04', 42),
    ('XYZ' , '2020-10-04', 63),
    ('ABCD', '2020-10-05', 30),
    ('XYZ' , '2020-10-05', 65),
    ('ABCD', '2020-10-06', 47),
    ('XYZ' , '2020-10-06', 56),
    ('ABCD', '2020-10-07', 71),
    ('XYZ' , '2020-10-07', 50),
    ('ABCD', '2020-10-08', 80),
    ('XYZ' , '2020-10-08', 54),
    ('ABCD', '2020-10-09', 75),
    ('XYZ' , '2020-10-09', 30),
    ('ABCD', '2020-10-10', 63),
    ('XYZ' , '2020-10-10', 32);

-- Example 18422
SELECT * FROM stock_price_history
  MATCH_RECOGNIZE(
    PARTITION BY company
    ORDER BY price_date
    MEASURES
      MATCH_NUMBER() AS match_number,
      FIRST(price_date) AS start_date,
      LAST(price_date) AS end_date,
      COUNT(*) AS rows_in_sequence,
      COUNT(row_with_price_decrease.*) AS num_decreases,
      COUNT(row_with_price_increase.*) AS num_increases
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO LAST row_with_price_increase
    PATTERN(row_before_decrease row_with_price_decrease+ row_with_price_increase+)
    DEFINE
      row_with_price_decrease AS price < LAG(price),
      row_with_price_increase AS price > LAG(price)
  )
ORDER BY company, match_number;
+---------+--------------+------------+------------+------------------+---------------+---------------+
| COMPANY | MATCH_NUMBER | START_DATE | END_DATE   | ROWS_IN_SEQUENCE | NUM_DECREASES | NUM_INCREASES |
|---------+--------------+------------+------------+------------------+---------------+---------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |                4 |             1 |             2 |
| ABCD    |            2 | 2020-10-04 | 2020-10-08 |                5 |             1 |             3 |
| XYZ     |            1 | 2020-10-01 | 2020-10-05 |                5 |             1 |             3 |
| XYZ     |            2 | 2020-10-05 | 2020-10-08 |                4 |             2 |             1 |
| XYZ     |            3 | 2020-10-08 | 2020-10-10 |                3 |             1 |             1 |
+---------+--------------+------------+------------+------------------+---------------+---------------+

-- Example 18423
select price_date, match_number, msq, price, cl from
  (select * from stock_price_history where company='ABCD') match_recognize(
    order by price_date
    measures
        match_number() as "MATCH_NUMBER",
        match_sequence_number() as msq,
        classifier() as cl
    all rows per match
    pattern(ANY_ROW UP+)
    define
        ANY_ROW AS TRUE,
        UP as price > lag(price)
)
order by match_number, msq;
+------------+--------------+-----+-------+---------+
| PRICE_DATE | MATCH_NUMBER | MSQ | PRICE | CL      |
|------------+--------------+-----+-------+---------|
| 2020-10-02 |            1 |   1 |    36 | ANY_ROW |
| 2020-10-03 |            1 |   2 |    39 | UP      |
| 2020-10-04 |            1 |   3 |    42 | UP      |
| 2020-10-05 |            2 |   1 |    30 | ANY_ROW |
| 2020-10-06 |            2 |   2 |    47 | UP      |
| 2020-10-07 |            2 |   3 |    71 | UP      |
| 2020-10-08 |            2 |   4 |    80 | UP      |
+------------+--------------+-----+-------+---------+

-- Example 18424
select * from stock_price_history match_recognize(
    partition by company
    order by price_date
    measures
        match_number() as "MATCH_NUMBER"
    all rows per match omit empty matches
    pattern(OVERAVG*)
    define
        OVERAVG as price > avg(price) over (rows between unbounded
                                  preceding and unbounded following)
)
order by company, price_date;
+---------+------------+-------+--------------+
| COMPANY | PRICE_DATE | PRICE | MATCH_NUMBER |
|---------+------------+-------+--------------|
| ABCD    | 2020-10-07 |    71 |            7 |
| ABCD    | 2020-10-08 |    80 |            7 |
| ABCD    | 2020-10-09 |    75 |            7 |
| ABCD    | 2020-10-10 |    63 |            7 |
| XYZ     | 2020-10-01 |    89 |            1 |
| XYZ     | 2020-10-04 |    63 |            4 |
| XYZ     | 2020-10-05 |    65 |            4 |
| XYZ     | 2020-10-06 |    56 |            4 |
| XYZ     | 2020-10-08 |    54 |            6 |
+---------+------------+-------+--------------+

-- Example 18425
select * from stock_price_history match_recognize(
    partition by company
    order by price_date
    measures
        match_number() as "MATCH_NUMBER",
        classifier() as cl
    all rows per match with unmatched rows
    pattern(OVERAVG+)
    define
        OVERAVG as price > avg(price) over (rows between unbounded
                                 preceding and unbounded following)
)
order by company, price_date;
+---------+------------+-------+--------------+---------+
| COMPANY | PRICE_DATE | PRICE | MATCH_NUMBER | CL      |
|---------+------------+-------+--------------+---------|
| ABCD    | 2020-10-01 |    50 |         NULL | NULL    |
| ABCD    | 2020-10-02 |    36 |         NULL | NULL    |
| ABCD    | 2020-10-03 |    39 |         NULL | NULL    |
| ABCD    | 2020-10-04 |    42 |         NULL | NULL    |
| ABCD    | 2020-10-05 |    30 |         NULL | NULL    |
| ABCD    | 2020-10-06 |    47 |         NULL | NULL    |
| ABCD    | 2020-10-07 |    71 |            1 | OVERAVG |
| ABCD    | 2020-10-08 |    80 |            1 | OVERAVG |
| ABCD    | 2020-10-09 |    75 |            1 | OVERAVG |
| ABCD    | 2020-10-10 |    63 |            1 | OVERAVG |
| XYZ     | 2020-10-01 |    89 |            1 | OVERAVG |
| XYZ     | 2020-10-02 |    24 |         NULL | NULL    |
| XYZ     | 2020-10-03 |    37 |         NULL | NULL    |
| XYZ     | 2020-10-04 |    63 |            2 | OVERAVG |
| XYZ     | 2020-10-05 |    65 |            2 | OVERAVG |
| XYZ     | 2020-10-06 |    56 |            2 | OVERAVG |
| XYZ     | 2020-10-07 |    50 |         NULL | NULL    |
| XYZ     | 2020-10-08 |    54 |            3 | OVERAVG |
| XYZ     | 2020-10-09 |    30 |         NULL | NULL    |
| XYZ     | 2020-10-10 |    32 |         NULL | NULL    |
+---------+------------+-------+--------------+---------+

-- Example 18426
SELECT company, price_date, price, "FINAL FIRST(LT45.price)", "FINAL LAST(LT45.price)"
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               FINAL FIRST(LT45.price) AS "FINAL FIRST(LT45.price)",
               FINAL LAST(LT45.price)  AS "FINAL LAST(LT45.price)"
           ALL ROWS PER MATCH
           AFTER MATCH SKIP PAST LAST ROW
           PATTERN (LT45 LT45)
           DEFINE
               LT45 AS price < 45.00
           )
    WHERE company = 'ABCD'
    ORDER BY price_date;
+---------+------------+-------+-------------------------+------------------------+
| COMPANY | PRICE_DATE | PRICE | FINAL FIRST(LT45.price) | FINAL LAST(LT45.price) |
|---------+------------+-------+-------------------------+------------------------|
| ABCD    | 2020-10-02 |    36 |                      36 |                     39 |
| ABCD    | 2020-10-03 |    39 |                      36 |                     39 |
| ABCD    | 2020-10-04 |    42 |                      42 |                     30 |
| ABCD    | 2020-10-05 |    30 |                      42 |                     30 |
+---------+------------+-------+-------------------------+------------------------+

-- Example 18427
SELECT ...
FROM ( VALUES ( <expr> [ , <expr> [ , ... ] ] ) [ , ( ... ) ] ) [ [ AS ] <table_alias> [ ( <column_alias> [, ... ] ) ] ]
[ ... ]

-- Example 18428
SELECT * FROM (VALUES (1, 'one'), (2, 'two'), (3, 'three'));

+---------+---------+
| COLUMN1 | COLUMN2 |
|---------+---------|
|       1 | one     |
|       2 | two     |
|       3 | three   |
+---------+---------+

SELECT column1, $2 FROM (VALUES (1, 'one'), (2, 'two'), (3, 'three'));

+---------+-------+
| COLUMN1 | $2    |
|---------+-------|
|       1 | one   |
|       2 | two   |
|       3 | three |
+---------+-------+

-- Example 18429
SELECT v1.$2, v2.$2
  FROM (VALUES (1, 'one'), (2, 'two')) AS v1
        INNER JOIN (VALUES (1, 'One'), (3, 'three')) AS v2
  WHERE v2.$1 = v1.$1;

-- Example 18430
SELECT c1, c2
  FROM (VALUES (1, 'one'), (2, 'two')) AS v1 (c1, c2);

-- Example 18431
SELECT ...
FROM ...
  { SAMPLE | TABLESAMPLE } [ samplingMethod ]
[ ... ]

-- Example 18432
samplingMethod ::= { { BERNOULLI | ROW } ( { <probability> | <num> ROWS } ) |
                     { SYSTEM | BLOCK } ( <probability> ) [ { REPEATABLE | SEED } ( <seed> ) ] }

-- Example 18433
SELECT * FROM example_table SAMPLE SYSTEM (10 ROWS);

SELECT * FROM example_table SAMPLE ROW (10 ROWS) SEED (99);

-- Example 18434
SELECT * FROM (SELECT * FROM example_table) SAMPLE (1) SEED (99);

-- Example 18435
SELECT * FROM testtable SAMPLE (10);

-- Example 18436
SELECT * FROM testtable TABLESAMPLE BERNOULLI (20.3);

-- Example 18437
SELECT * FROM testtable TABLESAMPLE (100);

-- Example 18438
SELECT * FROM testtable SAMPLE ROW (0);

-- Example 18439
SELECT i, j
  FROM
    table1 AS t1 SAMPLE (25)
      INNER JOIN
    table2 AS t2 SAMPLE (50)
  WHERE t2.j = t1.i;

-- Example 18440
SELECT i, j
  FROM table1 AS t1 INNER JOIN table2 AS t2 SAMPLE (50)
  WHERE t2.j = t1.i;

-- Example 18441
SELECT *
  FROM (
       SELECT *
         FROM t1 JOIN t2
           ON t1.a = t2.c
       ) SAMPLE (1);

-- Example 18442
SELECT * FROM testtable SAMPLE SYSTEM (3) SEED (82);

-- Example 18443
SELECT * FROM testtable SAMPLE BLOCK (0.012) REPEATABLE (99992);

-- Example 18444
SELECT * FROM testtable SAMPLE (10 ROWS);

-- Example 18445
SELECT ...
FROM ...
GROUP BY ...
HAVING <predicate>
[ ... ]

-- Example 18446
SELECT department_id
FROM employees
GROUP BY department_id
HAVING count(*) < 10;

-- Example 18447
QUALIFY <predicate>

-- Example 18448
SELECT <column_list>
  FROM <data_source>
  [GROUP BY ...]
  [HAVING ...]
  QUALIFY <predicate>
  [ ... ]

-- Example 18449
CREATE TABLE qt (i INTEGER, p CHAR(1), o INTEGER);
INSERT INTO qt (i, p, o) VALUES
    (1, 'A', 1),
    (2, 'A', 2),
    (3, 'B', 1),
    (4, 'B', 2);

-- Example 18450
SELECT * 
    FROM (
         SELECT i, p, o, 
                ROW_NUMBER() OVER (PARTITION BY p ORDER BY o) AS row_num
            FROM qt
        )
    WHERE row_num = 1
    ;
+---+---+---+---------+
| I | P | O | ROW_NUM |
|---+---+---+---------|
| 1 | A | 1 |       1 |
| 3 | B | 1 |       1 |
+---+---+---+---------+

-- Example 18451
SELECT i, p, o
    FROM qt
    QUALIFY ROW_NUMBER() OVER (PARTITION BY p ORDER BY o) = 1
    ;
+---+---+---+
| I | P | O |
|---+---+---|
| 1 | A | 1 |
| 3 | B | 1 |
+---+---+---+

-- Example 18452
SELECT i, p, o, ROW_NUMBER() OVER (PARTITION BY p ORDER BY o) AS row_num
    FROM qt
    QUALIFY row_num = 1
    ;
+---+---+---+---------+
| I | P | O | ROW_NUM |
|---+---+---+---------|
| 1 | A | 1 |       1 |
| 3 | B | 1 |       1 |
+---+---+---+---------+

-- Example 18453
SELECT i, p, o, ROW_NUMBER() OVER (PARTITION BY p ORDER BY o) AS row_num
    FROM qt
    ;
+---+---+---+---------+
| I | P | O | ROW_NUM |
|---+---+---+---------|
| 1 | A | 1 |       1 |
| 2 | A | 2 |       2 |
| 3 | B | 1 |       1 |
| 4 | B | 2 |       2 |
+---+---+---+---------+

-- Example 18454
SELECT c2, SUM(c3) OVER (PARTITION BY c2) as r
  FROM t1
  WHERE c3 < 4
  GROUP BY c2, c3
  HAVING SUM(c1) > 3
  QUALIFY r IN (
    SELECT MIN(c1)
      FROM test
      GROUP BY c2
      HAVING MIN(c1) > 3);

-- Example 18455
SELECT ...
FROM ...
[ ORDER BY ... ]
LIMIT <count> [ OFFSET <start> ]
[ ... ]

-- Example 18456
SELECT ...
FROM ...
[ ORDER BY ... ]
[ OFFSET <start> ] [ { ROW | ROWS } ] FETCH [ { FIRST | NEXT } ] <count> [ { ROW | ROWS } ] [ ONLY ]
[ ... ]

-- Example 18457
select c1 from testtable;

+------+
|   C1 |
|------|
|    1 |
|    2 |
|    3 |
|   20 |
|   19 |
|   18 |
|    1 |
|    2 |
|    3 |
|    4 |
| NULL |
|   30 |
| NULL |
+------+

select c1 from testtable limit 3 offset 3;

+----+
| C1 |
|----|
| 20 |
| 19 |
| 18 |
+----+

select c1 from testtable order by c1;

+------+
|   C1 |
|------|
|    1 |
|    1 |
|    2 |
|    2 |
|    3 |
|    3 |
|    4 |
|   18 |
|   19 |
|   20 |
|   30 |
| NULL |
| NULL |
+------+

select c1 from testtable order by c1 limit 3 offset 3;

+----+
| ID |
|----|
|  2 |
|  3 |
|  3 |
+----+

-- Example 18458
CREATE TABLE demo1 (i INTEGER);
INSERT INTO demo1 (i) VALUES (1), (2);

-- Example 18459
SELECT * FROM demo1 ORDER BY i LIMIT NULL OFFSET NULL;
+---+
| I |
|---|
| 1 |
| 2 |
+---+

-- Example 18460
SELECT * FROM demo1 ORDER BY i LIMIT '' OFFSET '';
+---+
| I |
|---|
| 1 |
| 2 |
+---+

-- Example 18461
SELECT * FROM demo1 ORDER BY i LIMIT $$$$ OFFSET $$$$;
+---+
| I |
|---|
| 1 |
| 2 |
+---+

-- Example 18462
SELECT ...
  FROM ...
  [ ... ]
  FOR UPDATE [ NOWAIT | WAIT <wait_time> ]

-- Example 18463
SELECT * FROM T WHERE ID < 20 FOR UPDATE;

-- Example 18464
DELETE FROM T WHERE ID = 5;

-- Example 18465
INSERT INTO T VALUES 12;

-- Example 18466
SELECT * FROM T WHERE ID < 20;

-- Example 18467
BEGIN;
...
SELECT * FROM ht ORDER BY c1 FOR UPDATE;
...
UPDATE ht set c1 = c1 + 10 WHERE c1 = 0;
...
SELECT ... ;
...
COMMIT;

-- Example 18468
BEGIN;
...
SELECT * FROM ht FOR UPDATE WAIT 60;
...
COMMIT;

-- Example 18469
SELECT 10.01 n1, 1.1 n2, n1 * n2;

