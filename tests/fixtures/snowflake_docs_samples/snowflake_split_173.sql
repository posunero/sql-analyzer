-- Example 11571
+---------------------------+
| LATIME                    |
|---------------------------|
| 2024-04-30 17:00:00 +0000 |
+---------------------------+

-- Example 11572
CREATE OR REPLACE TABLE my_table(id INTEGER, date1 DATE);
INSERT INTO my_table(id, date1) VALUES (1, TO_DATE('2024.07.23', 'YYYY.MM.DD'));
INSERT INTO my_table(id) VALUES (2);

-- Example 11573
SELECT id, date1
  FROM my_table
  ORDER BY id;

-- Example 11574
+----+------------+
| ID | DATE1      |
|----+------------|
|  1 | 2024-07-23 |
|  2 | NULL       |
+----+------------+

-- Example 11575
INSERT INTO my_table(id, date1) VALUES
  (3, TO_DATE('2024.02.20 11:15:00', 'YYYY.MM.DD HH:MI:SS')),
  (4, TO_TIMESTAMP('2024.02.24 04:00:00', 'YYYY.MM.DD HH:MI:SS'));

-- Example 11576
SELECT id, date1
  FROM my_table
  WHERE id >= 3;

-- Example 11577
+----+------------+
| ID | DATE1      |
|----+------------|
|  3 | 2024-02-20 |
|  4 | 2024-02-24 |
+----+------------+

-- Example 11578
INSERT INTO my_table(id, date1) VALUES
  (5, TO_DATE('11:20:30', 'hh:mi:ss'));

-- Example 11579
SELECT id, date1
  FROM my_table
  WHERE id = 5;

-- Example 11580
+----+------------+
| ID | DATE1      |
|----+------------|
|  5 | 1970-01-01 |
+----+------------+

-- Example 11581
SELECT id,
       TO_VARCHAR(date1, 'dd-mon-yyyy hh:mi:ss') AS date1
  FROM my_table
  ORDER BY id;

-- Example 11582
+----+----------------------+
| ID | DATE1                |
|----+----------------------|
|  1 | 23-Jul-2024 00:00:00 |
|  2 | NULL                 |
|  3 | 20-Feb-2024 00:00:00 |
|  4 | 24-Feb-2024 00:00:00 |
|  5 | 01-Jan-1970 00:00:00 |
+----+----------------------+

-- Example 11583
SELECT CURRENT_DATE();

-- Example 11584
SELECT CURRENT_TIMESTAMP();

-- Example 11585
SELECT EXTRACT('dayofweek', CURRENT_DATE());

-- Example 11586
SELECT TO_VARCHAR(CURRENT_DATE(), 'dy');

-- Example 11587
SELECT DECODE(EXTRACT('dayofweek_iso', CURRENT_DATE()),
  1, 'Monday',
  2, 'Tuesday',
  3, 'Wednesday',
  4, 'Thursday',
  5, 'Friday',
  6, 'Saturday',
  7, 'Sunday') AS weekday_name;

-- Example 11588
SELECT DATE_PART(day, CURRENT_TIMESTAMP());

-- Example 11589
SELECT DATE_PART(year, CURRENT_TIMESTAMP());

-- Example 11590
SELECT DATE_PART(month, CURRENT_TIMESTAMP());

-- Example 11591
SELECT DATE_PART(hour, CURRENT_TIMESTAMP());

-- Example 11592
SELECT DATE_PART(minute, CURRENT_TIMESTAMP());

-- Example 11593
SELECT DATE_PART(second, CURRENT_TIMESTAMP());

-- Example 11594
SELECT EXTRACT('day', CURRENT_TIMESTAMP());

-- Example 11595
SELECT EXTRACT('year', CURRENT_TIMESTAMP());

-- Example 11596
SELECT EXTRACT('month', CURRENT_TIMESTAMP());

-- Example 11597
SELECT EXTRACT('hour', CURRENT_TIMESTAMP());

-- Example 11598
SELECT EXTRACT('minute', CURRENT_TIMESTAMP());

-- Example 11599
SELECT EXTRACT('second', CURRENT_TIMESTAMP());

-- Example 11600
SELECT month(CURRENT_TIMESTAMP()) AS month,
       day(CURRENT_TIMESTAMP()) AS day,
       hour(CURRENT_TIMESTAMP()) AS hour,
       minute(CURRENT_TIMESTAMP()) AS minute,
       second(CURRENT_TIMESTAMP()) AS second;

-- Example 11601
+-------+-----+------+--------+--------+
| MONTH | DAY | HOUR | MINUTE | SECOND |
|-------+-----+------+--------+--------|
|     8 |  28 |    7 |     59 |     28 |
+-------+-----+------+--------+--------+

-- Example 11602
SELECT DATE_TRUNC('month', CURRENT_DATE());

-- Example 11603
SELECT DATEADD('day',
               -1,
               DATE_TRUNC('month', DATEADD(day, 31, DATE_TRUNC('month',CURRENT_DATE()))));

-- Example 11604
SELECT DATEADD('day',
               -1,
               DATEADD('month', 1, DATE_TRUNC('month', CURRENT_DATE())));

-- Example 11605
SELECT DATEADD(day,
               -1,
               DATE_TRUNC('month', CURRENT_DATE()));

-- Example 11606
SELECT TO_VARCHAR(CURRENT_DATE(), 'Mon');

-- Example 11607
SELECT DECODE(EXTRACT('month', CURRENT_DATE()),
         1, 'January',
         2, 'February',
         3, 'March',
         4, 'April',
         5, 'May',
         6, 'June',
         7, 'July',
         8, 'August',
         9, 'September',
         10, 'October',
         11, 'November',
         12, 'December') AS current_month;

-- Example 11608
SELECT DATEADD('day',
               (EXTRACT('dayofweek_iso', CURRENT_DATE()) * -1) + 1,
               CURRENT_DATE());

-- Example 11609
SELECT DATEADD('day',
               (5 - EXTRACT('dayofweek_iso', CURRENT_DATE())),
               CURRENT_DATE());

-- Example 11610
SELECT DATEADD(day,
               MOD( 7 + 1 - DATE_PART('dayofweek_iso', DATE_TRUNC('month', CURRENT_DATE())), 7),
               DATE_TRUNC('month', CURRENT_DATE()));

-- Example 11611
SELECT DATE_TRUNC('year', CURRENT_DATE());

-- Example 11612
SELECT DATEADD('day',
               -1,
               DATEADD('year', 1, DATE_TRUNC('year', CURRENT_DATE())));

-- Example 11613
SELECT DATEADD('day',
               -1,
               DATE_TRUNC('year', CURRENT_DATE()));

-- Example 11614
SELECT DATE_TRUNC('quarter', CURRENT_DATE());

-- Example 11615
SELECT DATEADD('day',
               -1,
               DATEADD('month', 3, DATE_TRUNC('quarter', CURRENT_DATE())));

-- Example 11616
SELECT DATE_TRUNC('day', CURRENT_TIMESTAMP());

-- Example 11617
+----------------------------------------+
| DATE_TRUNC('DAY', CURRENT_TIMESTAMP()) |
|----------------------------------------|
| Wed, 07 Sep 2016 00:00:00 -0700        |
+----------------------------------------+

-- Example 11618
SELECT DATEADD(year, 2, CURRENT_DATE());

-- Example 11619
SELECT DATEADD(day, 2, CURRENT_DATE());

-- Example 11620
SELECT DATEADD(hour, 2, CURRENT_TIMESTAMP());

-- Example 11621
SELECT DATEADD(minute, 2, CURRENT_TIMESTAMP());

-- Example 11622
SELECT DATEADD(second, 2, CURRENT_TIMESTAMP());

-- Example 11623
CREATE OR REPLACE TABLE timestamps(timestamp1 STRING);

INSERT INTO timestamps VALUES
  ('Fri, 05 Apr 2013 00:00:00 -0700'),
  ('Sat, 06 Apr 2013 00:00:00 -0700'),
  ('Sat, 01 Jan 2000 00:00:00 -0800'),
  ('Wed, 01 Jan 2020 00:00:00 -0800');

-- Example 11624
SELECT * FROM timestamps WHERE timestamp1 < '2014-01-01';

-- Example 11625
+------------+
| TIMESTAMP1 |
|------------|
+------------+

-- Example 11626
SELECT * FROM timestamps WHERE timestamp1 < '2014-01-01'::DATE;

-- Example 11627
+---------------------------------+
| DATE1                           |
|---------------------------------|
| Fri, 05 Apr 2013 00:00:00 -0700 |
| Sat, 06 Apr 2013 00:00:00 -0700 |
| Sat, 01 Jan 2000 00:00:00 -0800 |
+---------------------------------+

-- Example 11628
SELECT DATEADD('day',
               5,
               TO_TIMESTAMP('12-jan-2024 00:00:00','dd-mon-yyyy hh:mi:ss'))
  AS add_five_days;

-- Example 11629
+-------------------------+
| ADD_FIVE_DAYS           |
|-------------------------|
| 2024-01-17 00:00:00.000 |
+-------------------------+

-- Example 11630
SELECT DATEDIFF('day',
                TO_TIMESTAMP ('12-jan-2024 00:00:00','dd-mon-yyyy hh:mi:ss'),
                CURRENT_DATE())
  AS to_timestamp_difference;

-- Example 11631
+-------------------------+
| TO_TIMESTAMP_DIFFERENCE |
|-------------------------|
|                     229 |
+-------------------------+

-- Example 11632
SELECT DATEDIFF('day',
                TO_DATE ('12-jan-2024 00:00:00','dd-mon-yyyy hh:mi:ss'),
                CURRENT_DATE())
  AS to_date_difference;

-- Example 11633
+--------------------+
| TO_DATE_DIFFERENCE |
|--------------------|
|                229 |
+--------------------+

-- Example 11634
SELECT TO_DATE('2024-01-15') + 1 AS date_plus_one;

-- Example 11635
+---------------+
| DATE_PLUS_ONE |
|---------------|
| 2024-01-16    |
+---------------+

-- Example 11636
SELECT CURRENT_DATE() - 9 AS date_minus_nine;

-- Example 11637
+-----------------+
| DATE_MINUS_NINE |
|-----------------|
| 2024-08-19      |
+-----------------+

