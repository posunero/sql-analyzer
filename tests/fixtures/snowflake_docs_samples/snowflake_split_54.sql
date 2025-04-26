-- Example 3601
SELECT ts, HOUR(ts) FROM ts_test;

-- Example 3602
+-------------------------+----------+
| TS                      | HOUR(TS) |
|-------------------------+----------|
| 2024-01-01 16:00:00.000 |       16 |
| 2024-01-02 16:00:00.000 |       16 |
+-------------------------+----------+

-- Example 3603
ALTER SESSION SET TIMEZONE = 'America/New_York';

SELECT ts, HOUR(ts) FROM ts_test;

-- Example 3604
+-------------------------+----------+
| TS                      | HOUR(TS) |
|-------------------------+----------|
| 2024-01-01 16:00:00.000 |       16 |
| 2024-01-02 16:00:00.000 |       16 |
+-------------------------+----------+

-- Example 3605
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_TZ);

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2024-01-01 16:00:00');
INSERT INTO ts_test VALUES('2024-01-02 16:00:00 +00:00');

-- Example 3606
SELECT ts, HOUR(ts) FROM ts_test;

-- Example 3607
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 16:00:00.000 -0800 |       16 |
| 2024-01-02 16:00:00.000 +0000 |       16 |
+-------------------------------+----------+

-- Example 3608
ALTER SESSION SET TIMEZONE = 'America/New_York';

SELECT ts, HOUR(ts) FROM ts_test;

-- Example 3609
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 16:00:00.000 -0800 |       16 |
| 2024-01-02 16:00:00.000 +0000 |       16 |
+-------------------------------+----------+

-- Example 3610
CREATE OR REPLACE TABLE timestamp_demo_table(
  tstmp TIMESTAMP,
  tstmp_tz TIMESTAMP_TZ,
  tstmp_ntz TIMESTAMP_NTZ,
  tstmp_ltz TIMESTAMP_LTZ);
INSERT INTO timestamp_demo_table (tstmp, tstmp_tz, tstmp_ntz, tstmp_ltz) VALUES (
  '2024-03-12 01:02:03.123456789',
  '2024-03-12 01:02:03.123456789',
  '2024-03-12 01:02:03.123456789',
  '2024-03-12 01:02:03.123456789');

-- Example 3611
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_TZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_NTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_LTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Example 3612
SELECT tstmp, tstmp_tz, tstmp_ntz, tstmp_ltz
  FROM timestamp_demo_table;

-- Example 3613
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+
| TSTMP                         | TSTMP_TZ                      | TSTMP_NTZ                     | TSTMP_LTZ                     |
|-------------------------------+-------------------------------+-------------------------------+-------------------------------|
| 2024-03-12 01:02:03.123456789 | 2024-03-12 01:02:03.123456789 | 2024-03-12 01:02:03.123456789 | 2024-03-12 01:02:03.123456789 |
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+

-- Example 3614
DATE '2024-08-14'
TIME '10:03:56'
TIMESTAMP '2024-08-15 10:59:43'

-- Example 3615
CREATE TABLE t1 (d1 DATE);

INSERT INTO t1 (d1) VALUES (DATE '2024-08-15');

-- Example 3616
{ + | - } INTERVAL '<integer> [ <date_time_part> ] [ , <integer> [ <date_time_part> ] ... ]'

-- Example 3617
SELECT TO_DATE ('2019-02-28') + INTERVAL '1 day, 1 year';

-- Example 3618
+---------------------------------------------------+
| TO_DATE ('2019-02-28') + INTERVAL '1 DAY, 1 YEAR' |
|---------------------------------------------------|
| 2020-03-01                                        |
+---------------------------------------------------+

-- Example 3619
SELECT TO_DATE ('2019-02-28') + INTERVAL '1 year, 1 day';

-- Example 3620
+---------------------------------------------------+
| TO_DATE ('2019-02-28') + INTERVAL '1 YEAR, 1 DAY' |
|---------------------------------------------------|
| 2020-02-29                                        |
+---------------------------------------------------+

-- Example 3621
SET v1 = '1 year';

SELECT TO_DATE('2023-04-15') + INTERVAL $v1;

-- Example 3622
SELECT TO_DATE('2023-04-15') + INTERVAL '1 year';

-- Example 3623
+-------------------------------------------+
| TO_DATE('2023-04-15') + INTERVAL '1 YEAR' |
|-------------------------------------------|
| 2024-04-15                                |
+-------------------------------------------+

-- Example 3624
SELECT TO_TIME('04:15:29') + INTERVAL '3 hours, 18 minutes';

-- Example 3625
+------------------------------------------------------+
| TO_TIME('04:15:29') + INTERVAL '3 HOURS, 18 MINUTES' |
|------------------------------------------------------|
| 07:33:29                                             |
+------------------------------------------------------+

-- Example 3626
SELECT CURRENT_TIMESTAMP + INTERVAL
    '1 year, 3 quarters, 4 months, 5 weeks, 6 days, 7 minutes, 8 seconds,
    1000 milliseconds, 4000000 microseconds, 5000000001 nanoseconds'
  AS complex_interval1;

-- Example 3627
+-------------------------------+
| COMPLEX_INTERVAL1             |
|-------------------------------|
| 2026-11-07 18:07:19.875000001 |
+-------------------------------+

-- Example 3628
SELECT TO_DATE('2025-01-17') + INTERVAL
    '1 y, 3 q, 4 mm, 5 w, 6 d, 7 h, 9 m, 8 s,
    1000 ms, 445343232 us, 898498273498 ns'
  AS complex_interval2;

-- Example 3629
+-------------------------------+
| COMPLEX_INTERVAL2             |
|-------------------------------|
| 2027-03-30 07:31:32.841505498 |
+-------------------------------+

-- Example 3630
SELECT name, hire_date
  FROM employees
  WHERE hire_date > CURRENT_DATE - INTERVAL '2 y, 3 month';

-- Example 3631
SELECT ts + INTERVAL '4 seconds'
  FROM t1
  WHERE ts > TO_TIMESTAMP('2024-04-05 01:02:03');

-- Example 3632
SELECT TO_DATE('2024-04-15') + 1;

-- Example 3633
+---------------------------+
| TO_DATE('2024-04-15') + 1 |
|---------------------------|
| 2024-04-16                |
+---------------------------+

-- Example 3634
SELECT TO_DATE('2024-04-15') - 4;

-- Example 3635
+---------------------------+
| TO_DATE('2024-04-15') - 4 |
|---------------------------|
| 2024-04-11                |
+---------------------------+

-- Example 3636
SELECT name
  FROM employees
  WHERE end_date > start_date + 365;

-- Example 3637
AS_DECIMAL( <variant_expr> [ , <precision> [ , <scale> ] ] )

AS_NUMBER( <variant_expr> [ , <precision> [ , <scale> ] ] )

-- Example 3638
CREATE OR REPLACE TABLE as_number_example (number1 VARIANT);

INSERT INTO as_number_example (number1)
  SELECT TO_VARIANT(TO_NUMBER(2.34, 6, 3));

-- Example 3639
SELECT AS_NUMBER(number1, 6, 3) number_value
  FROM as_number_example;

-- Example 3640
+--------------+
| NUMBER_VALUE |
|--------------|
|        2.340 |
+--------------+

-- Example 3641
CREATE OR REPLACE TABLE test_fixed(
  num0 NUMBER,
  num10 NUMBER(10,1),
  dec20 DECIMAL(20,2),
  numeric30 NUMERIC(30,3),
  int1 INT,
  int2 INTEGER);

DESC TABLE test_fixed;

-- Example 3642
+-----------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name      | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|-----------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| NUM0      | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| NUM10     | NUMBER(10,1) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| DEC20     | NUMBER(20,2) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| NUMERIC30 | NUMBER(30,3) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| INT1      | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| INT2      | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+-----------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3643
CREATE OR REPLACE TABLE test_float(
  double1 DOUBLE,
  float1 FLOAT,
  dp1 DOUBLE PRECISION,
  real1 REAL);

DESC TABLE test_float;

-- Example 3644
+---------+-------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name    | type  | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|---------+-------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| DOUBLE1 | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| FLOAT1  | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| DP1     | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| REAL1   | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+---------+-------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3645
15
+1.34
0.2
15e-03
1.234E2
1.234E+2
-1

-- Example 3646
AS_DOUBLE( <variant_expr> )

AS_REAL( <variant_expr> )

-- Example 3647
CREATE OR REPLACE TABLE as_double_example (double1 VARIANT);

INSERT INTO as_double_example (double1)
  SELECT TO_VARIANT(TO_DOUBLE(1.23));

-- Example 3648
SELECT AS_DOUBLE(double1) double_value
  FROM as_double_float_example;

-- Example 3649
+--------------+
| DOUBLE_VALUE |
|--------------|
|         1.23 |
+--------------+

-- Example 3650
AS_INTEGER( <variant_expr> )

-- Example 3651
CREATE OR REPLACE TABLE as_integer_example (integer1 VARIANT);

INSERT INTO as_integer_example (integer1)
  SELECT TO_VARIANT(15);

-- Example 3652
SELECT AS_INTEGER(integer1) AS integer_value
  FROM as_integer_example;

-- Example 3653
+---------------+
| INTEGER_VALUE |
|---------------|
|            15 |
+---------------+

-- Example 3654
AS_OBJECT( <variant_expr> )

-- Example 3655
CREATE OR REPLACE TABLE as_object_example (object1 VARIANT);

INSERT INTO as_object_example (object1)
  SELECT TO_VARIANT(TO_OBJECT(PARSE_JSON('{"Tree": "Pine"}')));

-- Example 3656
SELECT AS_OBJECT(object1) AS object_value
  FROM as_object_example;

-- Example 3657
+------------------+
| OBJECT_VALUE     |
|------------------|
| {                |
|   "Tree": "Pine" |
| }                |
+------------------+

-- Example 3658
AS_TIME( <variant_expr> )

-- Example 3659
CREATE OR REPLACE TABLE as_time_example (time1 VARIANT);

INSERT INTO as_time_example (time1)
  SELECT TO_VARIANT(TO_TIME('12:34:56'));

-- Example 3660
SELECT AS_TIME(time1) AS time_value
  FROM as_time_example;

-- Example 3661
+------------+
| TIME_VALUE |
|------------|
| 12:34:56   |
+------------+

-- Example 3662
AS_TIMESTAMP_LTZ( <variant_expr> )

AS_TIMESTAMP_NTZ( <variant_expr> )

AS_TIMESTAMP_TZ( <variant_expr> )

-- Example 3663
CREATE OR REPLACE TABLE as_timestamp_example (timestamp1 VARIANT);

INSERT INTO as_timestamp_example (timestamp1)
  SELECT TO_VARIANT(TO_TIMESTAMP_NTZ('2024-10-10 12:34:56'));

-- Example 3664
SELECT AS_TIMESTAMP_NTZ(timestamp1) AS timestamp_value
  FROM as_timestamp_example;

-- Example 3665
+-------------------------+
| TIMESTAMP_VALUE         |
|-------------------------|
| 2024-10-10 12:34:56.000 |
+-------------------------+

-- Example 3666
ASCII( <input> )

-- Example 3667
SELECT column1, ASCII(column1)
  FROM (values('!'), ('A'), ('a'), ('bcd'), (''), (null));
+---------+----------------+
| COLUMN1 | ASCII(COLUMN1) |
|---------+----------------|
| !       |             33 |
| A       |             65 |
| a       |             97 |
| bcd     |             98 |
|         |              0 |
| NULL    |           NULL |
+---------+----------------+

