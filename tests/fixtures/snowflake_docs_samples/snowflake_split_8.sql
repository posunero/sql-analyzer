-- Example 477
SELECT approx_percentile_estimate(c1, 0.5) FROM combined_resultstate;

-- Example 478
SELECT approx_percentile_estimate(c1, 0.5) FROM combined_resultstate;
+-------------------------------------+
| APPROX_PERCENTILE_ESTIMATE(C1, 0.5) |
|-------------------------------------|
|                                 4.5 |
+-------------------------------------+

-- Example 479
APPROX_PERCENTILE_COMBINE( <state> )

-- Example 480
CREATE OR REPLACE TABLE mytesttable AS
  SELECT APPROX_PERCENTILE_COMBINE(td) s FROM
    (
      (SELECT APPROX_PERCENTILE_ACCUMULATE(c2) td FROM testtable WHERE c2 <= 0)
        UNION ALL
      (SELECT APPROX_PERCENTILE_ACCUMULATE(c2) td FROM testtable WHERE c2 > 0 AND c2 <= 0.5)
        UNION ALL
      (SELECT APPROX_PERCENTILE_ACCUMULATE(C2) td FROM testtable WHERE c2 > 0.5)
    );

SELECT APPROX_PERCENTILE_ESTIMATE(s , 0.5) FROM mytesttable;

-- Example 481
CREATE OR REPLACE TABLE mytest AS (SELECT APPROX_PERCENTILE_ACCUMULATE(c2) s1 FROM testtable WHERE c2 < 0);

CREATE OR REPLACE TABLE mytest2 AS (SELECT APPROX_PERCENTILE_ACCUMULATE(c2) s1 FROM testtable WHERE c2 >= 0);

CREATE OR REPLACE TABLE combinedtable AS
  SELECT APPROX_PERCENTILE_COMBINE(s) combinedstate FROM
    (
      (SELECT s1 s FROM mytest)
        UNION ALL
      (SELECT s1 s FROM mytest2)
    );

SELECT APPROX_PERCENTILE_ESTIMATE(combinedstate , 0.02) FROM combinedtable;

-- Example 482
APPROX_PERCENTILE_ESTIMATE( <state> , <percentile> )

-- Example 483
CREATE OR REPLACE TABLE resultstate AS (SELECT APPROX_PERCENTILE_ACCUMULATE(c1) s FROM testtable);

-- Example 484
SELECT APPROX_PERCENTILE_ESTIMATE(s , 0.01),
       APPROX_PERCENTILE_ESTIMATE(s , 0.15),
       APPROX_PERCENTILE_ESTIMATE(s , 0.845)
FROM testtable;

-- Example 485
GROUPING( <expr1> [ , <expr2> , ... ] )

-- Example 486
CREATE OR REPLACE TABLE aggr2(col_x int, col_y int, col_z int);
INSERT INTO aggr2 VALUES(1, 2, 1), (1, 2, 3);
INSERT INTO aggr2 VALUES(2, 1, 10), (2, 2, 11), (2, 2, 3);

-- Example 487
SELECT * FROM aggr2 ORDER BY col_x, col_y, col_z;
+-------+-------+-------+
| COL_X | COL_Y | COL_Z |
|-------+-------+-------|
|     1 |     2 |     1 |
|     1 |     2 |     3 |
|     2 |     1 |    10 |
|     2 |     2 |     3 |
|     2 |     2 |    11 |
+-------+-------+-------+

-- Example 488
SELECT col_x, col_y, sum(col_z), 
       grouping(col_x), grouping(col_y), grouping(col_x, col_y)
    FROM aggr2 GROUP BY GROUPING SETS ((col_x), (col_y), ())
    ORDER BY 1, 2;
+-------+-------+------------+-----------------+-----------------+------------------------+
| COL_X | COL_Y | SUM(COL_Z) | GROUPING(COL_X) | GROUPING(COL_Y) | GROUPING(COL_X, COL_Y) |
|-------+-------+------------+-----------------+-----------------+------------------------|
|     1 |  NULL |          4 |               0 |               1 |                      1 |
|     2 |  NULL |         24 |               0 |               1 |                      1 |
|  NULL |     1 |         10 |               1 |               0 |                      2 |
|  NULL |     2 |         18 |               1 |               0 |                      2 |
|  NULL |  NULL |         28 |               1 |               1 |                      3 |
+-------+-------+------------+-----------------+-----------------+------------------------+

-- Example 489
GROUPING_ID( <expr1> [ , <expr2> , ... ] )

-- Example 490
CREATE OR REPLACE TABLE aggr2(col_x int, col_y int, col_z int);
INSERT INTO aggr2 VALUES (1, 2, 1), 
                         (1, 2, 3);
INSERT INTO aggr2 VALUES (2, 1, 10), 
                         (2, 2, 11), 
                         (2, 2, 3);

-- Example 491
SELECT col_x, sum(col_z), GROUPING_ID(col_x)
    FROM aggr2 
    GROUP BY col_x
    ORDER BY col_x;
+-------+------------+--------------------+
| COL_X | SUM(COL_Z) | GROUPING_ID(COL_X) |
|-------+------------+--------------------|
|     1 |          4 |                  0 |
|     2 |         24 |                  0 |
+-------+------------+--------------------+

-- Example 492
SELECT col_x, col_y, sum(col_z), 
       GROUPING_ID(col_x), 
       GROUPING_ID(col_y), 
       GROUPING_ID(col_x, col_y)
    FROM aggr2 
    GROUP BY GROUPING SETS ((col_x), (col_y), ())
    ORDER BY col_x ASC, col_y DESC;
+-------+-------+------------+--------------------+--------------------+---------------------------+
| COL_X | COL_Y | SUM(COL_Z) | GROUPING_ID(COL_X) | GROUPING_ID(COL_Y) | GROUPING_ID(COL_X, COL_Y) |
|-------+-------+------------+--------------------+--------------------+---------------------------|
|     1 |  NULL |          4 |                  0 |                  1 |                         1 |
|     2 |  NULL |         24 |                  0 |                  1 |                         1 |
|  NULL |  NULL |         28 |                  1 |                  1 |                         3 |
|  NULL |     2 |         18 |                  1 |                  0 |                         2 |
|  NULL |     1 |         10 |                  1 |                  0 |                         2 |
+-------+-------+------------+--------------------+--------------------+---------------------------+

-- Example 493
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Example 494
+---------------------+--------------------+------------------+
| CURRENT_WAREHOUSE() | CURRENT_DATABASE() | CURRENT_SCHEMA() |
|---------------------+--------------------+------------------+
| MY_WAREHOUSE        | MY_DB              | PUBLIC           |
|---------------------+--------------------+------------------+

-- Example 495
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP;

-- Example 496
+--------------+--------------+-------------------------------+
| CURRENT_DATE | CURRENT_TIME | CURRENT_TIMESTAMP             |
|--------------+--------------+-------------------------------|
| 2024-06-07   | 10:45:15     | 2024-06-07 10:45:15.064 -0700 |
+--------------+--------------+-------------------------------+

-- Example 497
EXECUTE IMMEDIATE
$$
DECLARE
  currdate DATE;
BEGIN
  SELECT CURRENT_DATE INTO currdate;
  RETURN currdate;
END;
$$
;

-- Example 498
+-----------------+
| anonymous block |
|-----------------|
| 2024-06-07      |
+-----------------+

-- Example 499
EXECUTE IMMEDIATE
$$
DECLARE
  today DATE;
BEGIN
  today := CURRENT_DATE;
  RETURN today;
END;
$$
;

-- Example 500
000904 (42000): SQL compilation error: error line 5 at position 11
invalid identifier 'CURRENT_DATE'

-- Example 501
EXECUTE IMMEDIATE
$$
DECLARE
  today DATE;
BEGIN
  today := CURRENT_DATE();
  RETURN today;
END;
$$
;

-- Example 502
+-----------------+
| anonymous block |
|-----------------|
| 2024-06-07      |
+-----------------+

-- Example 503
SELECT TO_DATE('3/4/2024', 'dd/mm/yyyy');

-- Example 504
+-----------------------------------+
| TO_DATE('3/4/2024', 'DD/MM/YYYY') |
|-----------------------------------|
| 2024-04-03                        |
+-----------------------------------+

-- Example 505
SELECT TO_VARCHAR('2024-04-05'::DATE, 'mon dd, yyyy');

-- Example 506
+------------------------------------------------+
| TO_VARCHAR('2024-04-05'::DATE, 'MON DD, YYYY') |
|------------------------------------------------|
| Apr 05, 2024                                   |
+------------------------------------------------+

-- Example 507
CREATE OR REPLACE TABLE week_examples (d DATE);

INSERT INTO week_examples VALUES
  ('2016-12-30'),
  ('2016-12-31'),
  ('2017-01-01'),
  ('2017-01-02'),
  ('2017-01-03'),
  ('2017-01-04'),
  ('2017-01-05'),
  ('2017-12-30'),
  ('2017-12-31');

-- Example 508
ALTER SESSION SET WEEK_START = 0;

SELECT d "Date",
       DAYNAME(d) "Day",
       DAYOFWEEK(d) "DOW",
       DATE_TRUNC('week', d) "Trunc Date",
       DAYNAME("Trunc Date") "Trunc Day",
       LAST_DAY(d, 'week') "Last DOW Date",
       DAYNAME("Last DOW Date") "Last DOW Day",
       DATEDIFF('week', '2017-01-01', d) "Weeks Diff from 2017-01-01 to Date"
  FROM week_examples;

-- Example 509
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+
| Date       | Day | DOW | Trunc Date | Trunc Day | Last DOW Date | Last DOW Day | Weeks Diff from 2017-01-01 to Date |
|------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------|
| 2016-12-30 | Fri |   5 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2016-12-31 | Sat |   6 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-01 | Sun |   0 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-02 | Mon |   1 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-03 | Tue |   2 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-04 | Wed |   3 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-05 | Thu |   4 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-12-30 | Sat |   6 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
| 2017-12-31 | Sun |   0 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+

-- Example 510
ALTER SESSION SET WEEK_START = 1;

SELECT d "Date",
       DAYNAME(d) "Day",
       DAYOFWEEK(d) "DOW",
       DATE_TRUNC('week', d) "Trunc Date",
       DAYNAME("Trunc Date") "Trunc Day",
       LAST_DAY(d, 'week') "Last DOW Date",
       DAYNAME("Last DOW Date") "Last DOW Day",
       DATEDIFF('week', '2017-01-01', d) "Weeks Diff from 2017-01-01 to Date"
  FROM week_examples;

-- Example 511
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+
| Date       | Day | DOW | Trunc Date | Trunc Day | Last DOW Date | Last DOW Day | Weeks Diff from 2017-01-01 to Date |
|------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------|
| 2016-12-30 | Fri |   5 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2016-12-31 | Sat |   6 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-01 | Sun |   7 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-02 | Mon |   1 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-03 | Tue |   2 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-04 | Wed |   3 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-05 | Thu |   4 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-12-30 | Sat |   6 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
| 2017-12-31 | Sun |   7 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+

-- Example 512
ALTER SESSION SET WEEK_START = 3;

SELECT d "Date",
       DAYNAME(d) "Day",
       DAYOFWEEK(d) "DOW",
       DATE_TRUNC('week', d) "Trunc Date",
       DAYNAME("Trunc Date") "Trunc Day",
       LAST_DAY(d, 'week') "Last DOW Date",
       DAYNAME("Last DOW Date") "Last DOW Day",
       DATEDIFF('week', '2017-01-01', d) "Weeks Diff from 2017-01-01 to Date"
  FROM week_examples;

-- Example 513
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+
| Date       | Day | DOW | Trunc Date | Trunc Day | Last DOW Date | Last DOW Day | Weeks Diff from 2017-01-01 to Date |
|------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------|
| 2016-12-30 | Fri |   3 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2016-12-31 | Sat |   4 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-01 | Sun |   5 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-02 | Mon |   6 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-03 | Tue |   7 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-04 | Wed |   1 | 2017-01-04 | Wed       | 2017-01-10    | Tue          |                                  1 |
| 2017-01-05 | Thu |   2 | 2017-01-04 | Wed       | 2017-01-10    | Tue          |                                  1 |
| 2017-12-30 | Sat |   4 | 2017-12-27 | Wed       | 2018-01-02    | Tue          |                                 52 |
| 2017-12-31 | Sun |   5 | 2017-12-27 | Wed       | 2018-01-02    | Tue          |                                 52 |
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+

-- Example 514
ALTER SESSION SET WEEK_OF_YEAR_POLICY=0, WEEK_START=0;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 515
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  52 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  52 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |  52 |        52 | 2016 |      2016 |
| 2017-01-02 | Mon |   1 |         1 | 2017 |      2017 |
| 2017-01-03 | Tue |   1 |         1 | 2017 |      2017 |
| 2017-01-04 | Wed |   1 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   1 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  52 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  52 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

-- Example 516
ALTER SESSION SET WEEK_OF_YEAR_POLICY=0, WEEK_START=3;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 517
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  53 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  53 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |  53 |        52 | 2016 |      2016 |
| 2017-01-02 | Mon |  53 |         1 | 2016 |      2017 |
| 2017-01-03 | Tue |  53 |         1 | 2016 |      2017 |
| 2017-01-04 | Wed |   1 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   1 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  52 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  52 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

-- Example 518
ALTER SESSION SET WEEK_OF_YEAR_POLICY=1, WEEK_START=1;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 519
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  53 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  53 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |   1 |        52 | 2017 |      2016 |
| 2017-01-02 | Mon |   2 |         1 | 2017 |      2017 |
| 2017-01-03 | Tue |   2 |         1 | 2017 |      2017 |
| 2017-01-04 | Wed |   2 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   2 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  53 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  53 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

-- Example 520
ALTER SESSION SET week_of_year_policy=1, week_start=3;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 521
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

-- Example 522
SELECT REGEXP_COUNT('snow', 'SNOW', 1, 'c') AS case_sensitive_matching,
       REGEXP_COUNT('snow', 'SNOW', 1, 'i') AS case_insensitive_matching;

-- Example 523
+-------------------------+---------------------------+
| CASE_SENSITIVE_MATCHING | CASE_INSENSITIVE_MATCHING |
|-------------------------+---------------------------|
|                       0 |                         1 |
+-------------------------+---------------------------+

-- Example 524
SELECT REGEXP_SUBSTR('Release 24', 'Release\\W+(\\d+)', 1, 1, 'e') AS release_number;

-- Example 525
+----------------+
| RELEASE_NUMBER |
|----------------|
| 24             |
+----------------+

-- Example 526
SELECT REGEXP_SUBSTR('Customers - (NY)','\\([[:alnum:]]+\\)') AS location;

-- Example 527
+----------+
| LOCATION |
|----------|
| (NY)     |
+----------+

-- Example 528
SELECT REGEXP_SUBSTR('Customers - (NY)',$$\([[:alnum:]]+\)$$) AS location;

-- Example 529
+----------+
| LOCATION |
|----------|
| (NY)     |
+----------+

-- Example 530
SELECT w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, $$\?$$);

-- Example 531
SELECT w2, REGEXP_REPLACE(w2, '(.old)', $$very \1$$)
  FROM wildcards
  ORDER BY w2;

-- Example 532
CREATE OR REPLACE TABLE wildcards (w VARCHAR, w2 VARCHAR);
INSERT INTO wildcards (w, w2) VALUES ('\\', '?');

-- Example 533
SELECT w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, '\\?');

-- Example 534
+----+
| W2 |
|----|
| ?  |
+----+

-- Example 535
SELECT w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, '\\' || '?');

-- Example 536
+----+
| W2 |
|----|
| ?  |
+----+

-- Example 537
SELECT w, w2, w || w2 AS escape_sequence, w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, w || w2);

-- Example 538
+---+----+-----------------+----+
| W | W2 | ESCAPE_SEQUENCE | W2 |
|---+----+-----------------+----|
| \ | ?  | \?              | ?  |
+---+----+-----------------+----+

-- Example 539
INSERT INTO wildcards (w, w2) VALUES (NULL, 'When I am cold, I am bold.');

-- Example 540
SELECT w2, REGEXP_REPLACE(w2, '(.old)', 'very \\1')
  FROM wildcards
  ORDER BY w2;

-- Example 541
+----------------------------+------------------------------------------+
| W2                         | REGEXP_REPLACE(W2, '(.OLD)', 'VERY \\1') |
|----------------------------+------------------------------------------|
| ?                          | ?                                        |
| When I am cold, I am bold. | When I am very cold, I am very bold.     |
+----------------------------+------------------------------------------+

-- Example 542
SELECT SYSTEM$TYPEOF('a');

-- Example 543
SELECT city_name, temperature
    FROM TABLE(record_high_temperatures_for_date('2021-06-27'::DATE))
    ORDER BY city_name;

-- Example 544
CREATE OR REPLACE table dates_of_interest (event_date DATE);
INSERT INTO dates_of_interest (event_date) VALUES
    ('2021-06-21'::DATE),
    ('2022-06-21'::DATE);

CREATE OR REPLACE FUNCTION record_high_temperatures_for_date(d DATE)
    RETURNS TABLE (event_date DATE, city VARCHAR, temperature NUMBER)
    as
    $$
    SELECT d, 'New York', 65.0
    UNION ALL
    SELECT d, 'Los Angeles', 69.0
    $$;

