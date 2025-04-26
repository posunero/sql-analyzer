-- Example 4137
SELECT DATE_FROM_PARTS(1977, 8, 7);
+-----------------------------+
| DATE_FROM_PARTS(1977, 8, 7) |
|-----------------------------|
| 1977-08-07                  |
+-----------------------------+

-- Example 4138
SELECT DATE_FROM_PARTS(2010, 1, 100), DATE_FROM_PARTS(2010, 1 + 24, 1);
+-------------------------------+----------------------------------+
| DATE_FROM_PARTS(2010, 1, 100) | DATE_FROM_PARTS(2010, 1 + 24, 1) |
|-------------------------------+----------------------------------|
| 2010-04-10                    | 2012-01-01                       |
+-------------------------------+----------------------------------+

-- Example 4139
SELECT DATE_FROM_PARTS(2004, 1, 1),   -- January 1, 2004, as expected.
       DATE_FROM_PARTS(2004, 0, 1),   -- This is one month prior to DATE_FROM_PARTS(2004, 1, 1), so it's December 1, 2003.
                                      -- This is NOT a synonym for January 1, 2004.
       DATE_FROM_PARTS(2004, -1, 1)   -- This is two months (not one month) before DATE_FROM_PARTS(2004, 1, 1), so it's November 1, 2003.
       ;
+-----------------------------+-----------------------------+------------------------------+
| DATE_FROM_PARTS(2004, 1, 1) | DATE_FROM_PARTS(2004, 0, 1) | DATE_FROM_PARTS(2004, -1, 1) |
|-----------------------------+-----------------------------+------------------------------|
| 2004-01-01                  | 2003-12-01                  | 2003-11-01                   |
+-----------------------------+-----------------------------+------------------------------+

-- Example 4140
SELECT DATE_FROM_PARTS(2004, 2, 1),   -- February 1, 2004, as expected.
       DATE_FROM_PARTS(2004, 2, 0),   -- This is one day prior to DATE_FROM_PARTS(2004, 2, 1), so it's January 31, 2004.
       DATE_FROM_PARTS(2004, 2, -1);  -- Two days prior to DATE_FROM_PARTS(2004, 2, 1) so it's January 30, 2004.
+-----------------------------+-----------------------------+------------------------------+
| DATE_FROM_PARTS(2004, 2, 1) | DATE_FROM_PARTS(2004, 2, 0) | DATE_FROM_PARTS(2004, 2, -1) |
|-----------------------------+-----------------------------+------------------------------|
| 2004-02-01                  | 2004-01-31                  | 2004-01-30                   |
+-----------------------------+-----------------------------+------------------------------+

-- Example 4141
SELECT DATE_FROM_PARTS(2004, -1, -1);  -- Two months and two days prior to DATE_FROM_PARTS(2004, 1, 1), so it's October 30, 2003.
+-------------------------------+
| DATE_FROM_PARTS(2004, -1, -1) |
|-------------------------------|
| 2003-10-30                    |
+-------------------------------+

-- Example 4142
DATE_PART( <date_or_time_part> , <date_or_timestamp_expr> )

-- Example 4143
DATE_PART( <date_or_time_part> FROM <date_or_time_expr> )

-- Example 4144
SELECT DATE_PART(quarter, '2024-04-08'::DATE);

-- Example 4145
+----------------------------------------+
| DATE_PART(QUARTER, '2024-04-08'::DATE) |
|----------------------------------------|
|                                      2 |
+----------------------------------------+

-- Example 4146
SELECT TO_TIMESTAMP(
  '2024-04-08T23:39:20.123-07:00') AS "TIME_STAMP1",
  DATE_PART(year, "TIME_STAMP1") AS "EXTRACTED YEAR";

-- Example 4147
+-------------------------+----------------+
| TIME_STAMP1             | EXTRACTED YEAR |
|-------------------------+----------------|
| 2024-04-08 23:39:20.123 |           2024 |
+-------------------------+----------------+

-- Example 4148
SELECT TO_TIMESTAMP(
  '2024-04-08T23:39:20.123-07:00') AS "TIME_STAMP1",
  DATE_PART(epoch_second, "TIME_STAMP1") AS "EXTRACTED EPOCH SECOND";

-- Example 4149
+-------------------------+------------------------+
| TIME_STAMP1             | EXTRACTED EPOCH SECOND |
|-------------------------+------------------------|
| 2024-04-08 23:39:20.123 |             1712619560 |
+-------------------------+------------------------+

-- Example 4150
SELECT TO_TIMESTAMP(
  '2024-04-08T23:39:20.123-07:00') AS "TIME_STAMP1",
  DATE_PART(epoch_millisecond, "TIME_STAMP1") AS "EXTRACTED EPOCH MILLISECOND";

-- Example 4151
+-------------------------+-----------------------------+
| TIME_STAMP1             | EXTRACTED EPOCH MILLISECOND |
|-------------------------+-----------------------------|
| 2024-04-08 23:39:20.123 |               1712619560123 |
+-------------------------+-----------------------------+

-- Example 4152
DATE_TRUNC( <date_or_time_part>, <date_or_time_expr> )

-- Example 4153
CREATE OR REPLACE TABLE test_date_trunc (
 mydate DATE,
 mytime TIME,
 mytimestamp TIMESTAMP);

INSERT INTO test_date_trunc VALUES (
  '2024-05-09',
  '08:50:48',
  '2024-05-09 08:50:57.891 -0700');

SELECT * FROM test_date_trunc;

-- Example 4154
+------------+----------+-------------------------+
| MYDATE     | MYTIME   | MYTIMESTAMP             |
|------------+----------+-------------------------|
| 2024-05-09 | 08:50:48 | 2024-05-09 08:50:57.891 |
+------------+----------+-------------------------+

-- Example 4155
SELECT mydate AS "DATE",
       DATE_TRUNC('year', mydate) AS "TRUNCATED TO YEAR",
       DATE_TRUNC('month', mydate) AS "TRUNCATED TO MONTH",
       DATE_TRUNC('week', mydate) AS "TRUNCATED TO WEEK",
       DATE_TRUNC('day', mydate) AS "TRUNCATED TO DAY"
  FROM test_date_trunc;

-- Example 4156
+------------+-------------------+--------------------+-------------------+------------------+
| DATE       | TRUNCATED TO YEAR | TRUNCATED TO MONTH | TRUNCATED TO WEEK | TRUNCATED TO DAY |
|------------+-------------------+--------------------+-------------------+------------------|
| 2024-05-09 | 2024-01-01        | 2024-05-01         | 2024-05-06        | 2024-05-09       |
+------------+-------------------+--------------------+-------------------+------------------+

-- Example 4157
SELECT mytime AS "TIME",
       DATE_TRUNC('minute', mytime) AS "TRUNCATED TO MINUTE"
  FROM test_date_trunc;

-- Example 4158
+----------+---------------------+
| TIME     | TRUNCATED TO MINUTE |
|----------+---------------------|
| 08:50:48 | 08:50:00            |
+----------+---------------------+

-- Example 4159
SELECT mytimestamp AS "TIMESTAMP",
       DATE_TRUNC('hour', mytimestamp) AS "TRUNCATED TO HOUR",
       DATE_TRUNC('minute', mytimestamp) AS "TRUNCATED TO MINUTE",
       DATE_TRUNC('second', mytimestamp) AS "TRUNCATED TO SECOND"
  FROM test_date_trunc;

-- Example 4160
+-------------------------+-------------------------+-------------------------+-------------------------+
| TIMESTAMP               | TRUNCATED TO HOUR       | TRUNCATED TO MINUTE     | TRUNCATED TO SECOND     |
|-------------------------+-------------------------+-------------------------+-------------------------|
| 2024-05-09 08:50:57.891 | 2024-05-09 08:00:00.000 | 2024-05-09 08:50:00.000 | 2024-05-09 08:50:57.000 |
+-------------------------+-------------------------+-------------------------+-------------------------+

-- Example 4161
SELECT DATE_TRUNC('quarter', mytimestamp) AS "TRUNCATED",
       EXTRACT('quarter', mytimestamp) AS "EXTRACTED"
  FROM test_date_trunc;

-- Example 4162
+-------------------------+-----------+
| TRUNCATED               | EXTRACTED |
|-------------------------+-----------|
| 2024-04-01 00:00:00.000 |         2 |
+-------------------------+-----------+

-- Example 4163
DATEADD( <date_or_time_part>, <value>, <date_or_time_expr> )

-- Example 4164
SELECT TO_DATE('2022-05-08') AS original_date,
       DATEADD(year, 2, TO_DATE('2022-05-08')) AS date_plus_two_years;

-- Example 4165
+---------------+---------------------+
| ORIGINAL_DATE | DATE_PLUS_TWO_YEARS |
|---------------+---------------------|
| 2022-05-08    | 2024-05-08          |
+---------------+---------------------+

-- Example 4166
SELECT TO_DATE('2022-05-08') AS original_date,
       DATEADD(year, -2, TO_DATE('2022-05-08')) AS date_minus_two_years;

-- Example 4167
+---------------+----------------------+
| ORIGINAL_DATE | DATE_MINUS_TWO_YEARS |
|---------------+----------------------|
| 2022-05-08    | 2020-05-08           |
+---------------+----------------------+

-- Example 4168
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF9';
CREATE TABLE datetest (d date);
INSERT INTO datetest VALUES ('2022-04-05');

-- Example 4169
SELECT d AS original_date,
       DATEADD(year, 2, d) AS date_plus_two_years,
       TO_TIMESTAMP(d) AS original_timestamp,
       DATEADD(hour, 2, d) AS timestamp_plus_two_hours
  FROM datetest;

-- Example 4170
+---------------+---------------------+-------------------------+--------------------------+
| ORIGINAL_DATE | DATE_PLUS_TWO_YEARS | ORIGINAL_TIMESTAMP      | TIMESTAMP_PLUS_TWO_HOURS |
|---------------+---------------------+-------------------------+--------------------------|
| 2022-04-05    | 2024-04-05          | 2022-04-05 00:00:00.000 | 2022-04-05 02:00:00.000  |
+---------------+---------------------+-------------------------+--------------------------+

-- Example 4171
SELECT DATEADD(month, 1, '2023-01-31'::DATE) AS date_plus_one_month;

-- Example 4172
+---------------------+
| DATE_PLUS_ONE_MONTH |
|---------------------|
| 2023-02-28          |
+---------------------+

-- Example 4173
SELECT DATEADD(month, 1, '2023-02-28'::DATE) AS date_plus_one_month;

-- Example 4174
+---------------------+
| DATE_PLUS_ONE_MONTH |
|---------------------|
| 2023-03-28          |
+---------------------+

-- Example 4175
SELECT TO_TIME('05:00:00') AS original_time,
       DATEADD(hour, 3, TO_TIME('05:00:00')) AS time_plus_three_hours;

-- Example 4176
+---------------+-----------------------+
| ORIGINAL_TIME | TIME_PLUS_THREE_HOURS |
|---------------+-----------------------|
| 05:00:00      | 08:00:00              |
+---------------+-----------------------+

-- Example 4177
DATEDIFF( <date_or_time_part>, <date_or_time_expr1>, <date_or_time_expr2> )

-- Example 4178
<date_expr2> - <date_expr1>

-- Example 4179
DATEDIFF(month, '2021-01-01'::DATE, '2021-02-28'::DATE)

-- Example 4180
SELECT DATEDIFF(year, 
                '2020-04-09 14:39:20'::TIMESTAMP, 
                '2023-05-08 23:39:20'::TIMESTAMP) 
  AS diff_years;

-- Example 4181
+------------+
| DIFF_YEARS |
|------------|
|          3 |
+------------+

-- Example 4182
SELECT DATEDIFF(hour, 
               '2023-05-08T23:39:20.123-07:00'::TIMESTAMP, 
               DATEADD(year, 2, ('2023-05-08T23:39:20.123-07:00')::TIMESTAMP)) 
  AS diff_hours;

-- Example 4183
+------------+
| DIFF_HOURS |
|------------|
|      17544 |
+------------+

-- Example 4184
SELECT column1 date_1, column2 date_2,
       DATEDIFF(year, column1, column2) diff_years,
       DATEDIFF(month, column1, column2) diff_months,
       DATEDIFF(day, column1, column2) diff_days,
       column2::DATE - column1::DATE AS diff_days_via_minus
  FROM VALUES
       ('2015-12-30', '2015-12-31'),
       ('2015-12-31', '2016-01-01'),
       ('2016-01-01', '2017-12-31'),
       ('2016-08-23', '2016-09-07');

-- Example 4185
+------------+------------+------------+-------------+-----------+---------------------+
| DATE_1     | DATE_2     | DIFF_YEARS | DIFF_MONTHS | DIFF_DAYS | DIFF_DAYS_VIA_MINUS |
|------------+------------+------------+-------------+-----------+---------------------|
| 2015-12-30 | 2015-12-31 |          0 |           0 |         1 |                   1 |
| 2015-12-31 | 2016-01-01 |          1 |           1 |         1 |                   1 |
| 2016-01-01 | 2017-12-31 |          1 |          23 |       730 |                 730 |
| 2016-08-23 | 2016-09-07 |          0 |           1 |        15 |                  15 |
+------------+------------+------------+-------------+-----------+---------------------+

-- Example 4186
ALTER SESSION SET TIMESTAMP_NTZ_OUTPUT_FORMAT = 'DY, DD MON YYYY HH24:MI:SS';

-- Example 4187
SELECT column1 timestamp_1, column2 timestamp_2,
       DATEDIFF(hour, column1, column2) diff_hours,
       DATEDIFF(minute, column1, column2) diff_minutes,
       DATEDIFF(second, column1, column2) diff_seconds
  FROM VALUES
       ('2016-01-01 01:59:59'::TIMESTAMP, '2016-01-01 02:00:00'::TIMESTAMP),
       ('2016-01-01 01:00:00'::TIMESTAMP, '2016-01-01 01:59:00'::TIMESTAMP),
       ('2016-01-01 01:00:59'::TIMESTAMP, '2016-01-01 02:00:00'::TIMESTAMP);

-- Example 4188
+---------------------------+---------------------------+------------+--------------+--------------+
| TIMESTAMP_1               | TIMESTAMP_2               | DIFF_HOURS | DIFF_MINUTES | DIFF_SECONDS |
|---------------------------+---------------------------+------------+--------------+--------------|
| Fri, 01 Jan 2016 01:59:59 | Fri, 01 Jan 2016 02:00:00 |          1 |            1 |            1 |
| Fri, 01 Jan 2016 01:00:00 | Fri, 01 Jan 2016 01:59:00 |          0 |           59 |         3540 |
| Fri, 01 Jan 2016 01:00:59 | Fri, 01 Jan 2016 02:00:00 |          1 |           60 |         3541 |
+---------------------------+---------------------------+------------+--------------+--------------+

-- Example 4189
SELECT column1 specified_timestamp,
       column2 timestamp_now,
       DATEDIFF(year, column1, column2) diff_years,
       DATEDIFF(month, column1, column2) diff_months,
       DATEDIFF(day, column1, column2) diff_days,
       column2::DATE - column1::DATE AS diff_days_via_minus
  FROM VALUES
    ('2012-08-23 09:00:00.000 -0700', CURRENT_TIMESTAMP);

-- Example 4190
+-------------------------------+-------------------------------+------------+-------------+-----------+---------------------+
| SPECIFIED_TIMESTAMP           | TIMESTAMP_NOW                 | DIFF_YEARS | DIFF_MONTHS | DIFF_DAYS | DIFF_DAYS_VIA_MINUS |
|-------------------------------+-------------------------------+------------+-------------+-----------+---------------------|
| 2012-08-23 09:00:00.000 -0700 | 2024-09-04 17:21:12.189 -0700 |         12 |         145 |      4395 |                4395 |
+-------------------------------+-------------------------------+------------+-------------+-----------+---------------------+

-- Example 4191
DAYNAME( <date_or_timestamp_expr> )

-- Example 4192
SELECT DAYNAME(TO_DATE('2024-04-01')) AS DAY;

-- Example 4193
+-----+
| DAY |
|-----|
| Mon |
+-----+

-- Example 4194
SELECT DAYNAME(TO_TIMESTAMP_NTZ('2024-04-02 10:00')) AS DAY;

-- Example 4195
+-----+
| DAY |
|-----|
| Tue |
+-----+

-- Example 4196
CREATE OR REPLACE TABLE dates (d DATE);

-- Example 4197
INSERT INTO dates (d) VALUES 
  ('2024-01-01'::DATE),
  ('2024-01-02'::DATE),
  ('2024-01-03'::DATE),
  ('2024-01-04'::DATE),
  ('2024-01-05'::DATE),
  ('2024-01-06'::DATE),
  ('2024-01-07'::DATE),
  ('2024-01-08'::DATE);

-- Example 4198
SELECT d, DAYNAME(d) 
  FROM dates
  ORDER BY d;

-- Example 4199
+------------+------------+
| D          | DAYNAME(D) |
|------------+------------|
| 2024-01-01 | Mon        |
| 2024-01-02 | Tue        |
| 2024-01-03 | Wed        |
| 2024-01-04 | Thu        |
| 2024-01-05 | Fri        |
| 2024-01-06 | Sat        |
| 2024-01-07 | Sun        |
| 2024-01-08 | Mon        |
+------------+------------+

-- Example 4200
DECODE( <expr> , <search1> , <result1> [ , <search2> , <result2> ... ] [ , <default> ] )

-- Example 4201
CREATE TABLE d (column1 INTEGER);
INSERT INTO d (column1) VALUES 
    (1),
    (2),
    (NULL),
    (4);

-- Example 4202
SELECT column1, decode(column1, 
                       1, 'one', 
                       2, 'two', 
                       NULL, '-NULL-', 
                       'other'
                      ) AS decode_result
    FROM d;
+---------+---------------+
| COLUMN1 | DECODE_RESULT |
|---------+---------------|
|       1 | one           |
|       2 | two           |
|    NULL | -NULL-        |
|       4 | other         |
+---------+---------------+

-- Example 4203
SELECT column1, decode(column1, 
                       1, 'one', 
                       2, 'two', 
                       NULL, '-NULL-'
                       ) AS decode_result
    FROM d;
+---------+---------------+
| COLUMN1 | DECODE_RESULT |
|---------+---------------|
|       1 | one           |
|       2 | two           |
|    NULL | -NULL-        |
|       4 | NULL          |
+---------+---------------+

