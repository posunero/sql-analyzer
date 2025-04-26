-- Example 7753
WAREHOUSE_METERING_HISTORY(
      DATE_RANGE_START => <constant_expr>
      [ , DATE_RANGE_END => <constant_expr> ]
      [ , WAREHOUSE_NAME => '<string>' ] )

-- Example 7754
select *
from table(information_schema.warehouse_metering_history(dateadd('days',-10,current_date())));

-- Example 7755
select *
from table(information_schema.warehouse_metering_history('2017-10-23', '2017-10-23', 'testingwh'));

-- Example 7756
WIDTH_BUCKET( <expr> , <min_value> , <max_value> , <num_buckets> )

-- Example 7757
CREATE TABLE home_sales (
    sale_date DATE,
    price NUMBER(11, 2)
    );
INSERT INTO home_sales (sale_date, price) VALUES 
    ('2013-08-01'::DATE, 290000.00),
    ('2014-02-01'::DATE, 320000.00),
    ('2015-04-01'::DATE, 399999.99),
    ('2016-04-01'::DATE, 400000.00),
    ('2017-04-01'::DATE, 470000.00),
    ('2018-04-01'::DATE, 510000.00);

-- Example 7758
SELECT 
    sale_date, 
    price,
    WIDTH_BUCKET(price, 200000, 600000, 4) AS "SALES GROUP"
  FROM home_sales
  ORDER BY sale_date;
+------------+-----------+-------------+
| SALE_DATE  |     PRICE | SALES GROUP |
|------------+-----------+-------------|
| 2013-08-01 | 290000.00 |           1 |
| 2014-02-01 | 320000.00 |           2 |
| 2015-04-01 | 399999.99 |           2 |
| 2016-04-01 | 400000.00 |           3 |
| 2017-04-01 | 470000.00 |           3 |
| 2018-04-01 | 510000.00 |           4 |
+------------+-----------+-------------+

-- Example 7759
XMLGET( <expression> , <tag_name> [ , <instance_number> ] )

-- Example 7760
SELECT XMLGET(XMLGET(my_xml_column, 'my_tag'), 'my_inner_tag') ...;

-- Example 7761
CREATE OR REPLACE TABLE xml_demo (id INTEGER, object_col OBJECT);

INSERT INTO xml_demo (id, object_col)
  SELECT 1001,
    PARSE_XML('<level1> 1 <level2> 2 <level3> 3A </level3> <level3> 3B </level3> </level2> </level1>');

-- Example 7762
SELECT object_col,
       XMLGET(object_col, 'level2'),
       XMLGET(XMLGET(object_col, 'level2'), 'level3', 1)
  FROM xml_demo;

-- Example 7763
+-------------------------+------------------------------+---------------------------------------------------+
| OBJECT_COL              | XMLGET(OBJECT_COL, 'LEVEL2') | XMLGET(XMLGET(OBJECT_COL, 'LEVEL2'), 'LEVEL3', 1) |
|-------------------------+------------------------------+---------------------------------------------------|
| <level1>                | <level2>                     | <level3>3B</level3>                               |
|   1                     |   2                          |                                                   |
|   <level2>              |   <level3>3A</level3>        |                                                   |
|     2                   |   <level3>3B</level3>        |                                                   |
|     <level3>3A</level3> | </level2>                    |                                                   |
|     <level3>3B</level3> |                              |                                                   |
|   </level2>             |                              |                                                   |
| </level1>               |                              |                                                   |
+-------------------------+------------------------------+---------------------------------------------------+

-- Example 7764
SELECT object_col,
       GET(XMLGET(object_col, 'level2'), '$') AS content_of_element
  FROM xml_demo;

-- Example 7765
+-------------------------+--------------------+
| OBJECT_COL              | CONTENT_OF_ELEMENT |
|-------------------------+--------------------|
| <level1>                | [                  |
|   1                     |   2,               |
|   <level2>              |   {                |
|     2                   |     "$": "3A",     |
|     <level3>3A</level3> |     "@": "level3"  |
|     <level3>3B</level3> |   },               |
|   </level2>             |   {                |
| </level1>               |     "$": "3B",     |
|                         |     "@": "level3"  |
|                         |   }                |
|                         | ]                  |
+-------------------------+--------------------+

-- Example 7766
INSERT INTO xml_demo (id, object_col)
  SELECT 1002,
      PARSE_XML('<level1> 1 <level2 an_attribute="my attribute"> 2 </level2> </level1>');

-- Example 7767
SELECT object_col,
       GET(XMLGET(object_col, 'level2'), '@an_attribute') AS attribute
  FROM xml_demo
  WHERE ID = 1002;

-- Example 7768
+--------------------------------------------------+----------------+
| OBJECT_COL                                       | ATTRIBUTE      |
|--------------------------------------------------+----------------|
| <level1>                                         | "my attribute" |
|   1                                              |                |
|   <level2 an_attribute="my attribute">2</level2> |                |
| </level1>                                        |                |
+--------------------------------------------------+----------------+

-- Example 7769
YEAR( <date_or_timestamp_expr> )

YEAROFWEEK( <date_or_timestamp_expr> )
YEAROFWEEKISO( <date_or_timestamp_expr> )

DAY( <date_or_timestamp_expr> )

DAYOFMONTH( <date_or_timestamp_expr> )
DAYOFWEEK( <date_or_timestamp_expr> )
DAYOFWEEKISO( <date_or_timestamp_expr> )
DAYOFYEAR( <date_or_timestamp_expr> )

WEEK( <date_or_timestamp_expr> )

WEEKOFYEAR( <date_or_timestamp_expr> )
WEEKISO( <date_or_timestamp_expr> )

MONTH( <date_or_timestamp_expr> )

QUARTER( <date_or_timestamp_expr> )

-- Example 7770
SELECT '2025-04-11T23:39:20.123-07:00'::TIMESTAMP AS tstamp,
       YEAR(tstamp) AS "YEAR",
       QUARTER(tstamp) AS "QUARTER OF YEAR",
       MONTH(tstamp) AS "MONTH",
       DAY(tstamp) AS "DAY",
       DAYOFMONTH(tstamp) AS "DAY OF MONTH",
       DAYOFYEAR(tstamp) AS "DAY OF YEAR";

-- Example 7771
+-------------------------+------+-----------------+-------+-----+--------------+-------------+
| TSTAMP                  | YEAR | QUARTER OF YEAR | MONTH | DAY | DAY OF MONTH | DAY OF YEAR |
|-------------------------+------+-----------------+-------+-----+--------------+-------------|
| 2025-04-11 23:39:20.123 | 2025 |               2 |     4 |  11 |           11 |         101 |
+-------------------------+------+-----------------+-------+-----+--------------+-------------+

-- Example 7772
ALTER SESSION SET WEEK_OF_YEAR_POLICY = 1;

-- Example 7773
SELECT '2016-01-02T23:39:20.123-07:00'::TIMESTAMP AS tstamp,
       WEEK(tstamp) AS "WEEK",
       WEEKISO(tstamp) AS "WEEK ISO",
       WEEKOFYEAR(tstamp) AS "WEEK OF YEAR",
       YEAROFWEEK(tstamp) AS "YEAR OF WEEK",
       YEAROFWEEKISO(tstamp) AS "YEAR OF WEEK ISO";

-- Example 7774
+-------------------------+------+----------+--------------+--------------+------------------+
| TSTAMP                  | WEEK | WEEK ISO | WEEK OF YEAR | YEAR OF WEEK | YEAR OF WEEK ISO |
|-------------------------+------+----------+--------------+--------------+------------------|
| 2016-01-02 23:39:20.123 |    1 |       53 |            1 |         2016 |             2015 |
+-------------------------+------+----------+--------------+--------------+------------------+

-- Example 7775
ALTER SESSION SET WEEK_OF_YEAR_POLICY = 0;

-- Example 7776
SELECT '2016-01-02T23:39:20.123-07:00'::TIMESTAMP AS tstamp,
       WEEK(tstamp) AS "WEEK",
       WEEKISO(tstamp) AS "WEEK ISO",
       WEEKOFYEAR(tstamp) AS "WEEK OF YEAR",
       YEAROFWEEK(tstamp) AS "YEAR OF WEEK",
       YEAROFWEEKISO(tstamp) AS "YEAR OF WEEK ISO";

-- Example 7777
+-------------------------+------+----------+--------------+--------------+------------------+
| TSTAMP                  | WEEK | WEEK ISO | WEEK OF YEAR | YEAR OF WEEK | YEAR OF WEEK ISO |
|-------------------------+------+----------+--------------+--------------+------------------|
| 2016-01-02 23:39:20.123 |   53 |       53 |           53 |         2015 |             2015 |
+-------------------------+------+----------+--------------+--------------+------------------+

-- Example 7778
ALTER SESSION SET WEEK_START = 7;

-- Example 7779
SELECT '2025-04-05T23:39:20.123-07:00'::TIMESTAMP AS tstamp,
       DAYOFWEEK(tstamp) AS "DAY OF WEEK",
       DAYOFWEEKISO(tstamp) AS "DAY OF WEEK ISO";

-- Example 7780
+-------------------------+-------------+-----------------+
| TSTAMP                  | DAY OF WEEK | DAY OF WEEK ISO |
|-------------------------+-------------+-----------------|
| 2025-04-05 23:39:20.123 |           7 |               6 |
+-------------------------+-------------+-----------------+

-- Example 7781
ALTER SESSION SET WEEK_START = 1;

-- Example 7782
SELECT '2025-04-05T23:39:20.123-07:00'::TIMESTAMP AS tstamp,
       DAYOFWEEK(tstamp) AS "DAY OF WEEK",
       DAYOFWEEKISO(tstamp) AS "DAY OF WEEK ISO";

-- Example 7783
+-------------------------+-------------+-----------------+
| TSTAMP                  | DAY OF WEEK | DAY OF WEEK ISO |
|-------------------------+-------------+-----------------|
| 2025-04-05 23:39:20.123 |           6 |               6 |
+-------------------------+-------------+-----------------+

-- Example 7784
ZEROIFNULL( <expr> )

-- Example 7785
SELECT column1, ZEROIFNULL(column1) 
    FROM VALUES (1), (null), (5), (0), (3.14159);
+---------+---------------------+
| COLUMN1 | ZEROIFNULL(COLUMN1) |
|---------+---------------------|
| 1.00000 |             1.00000 |
|    NULL |             0.00000 |
| 5.00000 |             5.00000 |
| 0.00000 |             0.00000 |
| 3.14159 |             3.14159 |
+---------+---------------------+

-- Example 7786
ZIPF( <s> , <N> , <gen> )

-- Example 7787
SELECT zipf(1, 10, random()) FROM table(generator(rowCount => 10));

+-----------------------+
| ZIPF(1, 10, RANDOM()) |
|-----------------------|
|                     9 |
|                     7 |
|                     1 |
|                     8 |
|                     8 |
|                     2 |
|                     3 |
|                     8 |
|                     2 |
|                     5 |
+-----------------------+

-- Example 7788
SELECT zipf(1, 10, 1234) FROM table(generator(rowCount => 10));

+-------------------+
| ZIPF(1, 10, 1234) |
|-------------------|
|                 4 |
|                 4 |
|                 4 |
|                 4 |
|                 4 |
|                 4 |
|                 4 |
|                 4 |
|                 4 |
|                 4 |
+-------------------+

-- Example 7789
{
  "version" : 3,
  "precision" : 12,
  "dense" : [3,3,3,3,5,3,4,3,5,6,2,4,4,7,5,6,6,3,2,2,3,2,4,5,5,5,2,5,5,3,6,1,4,2,2,4,4,5,2,5,...,4,6,3]
}

-- Example 7790
{
  "version" : 3,
  "precision" : 12,
  "sparse" : {
    "indices": [1131,1241,1256,1864,2579,2699,3730],
    "maxLzCounts":[2,4,2,1,3,2,1]
  }
}

-- Example 7791
USE WAREHOUSE dontdrop;
USE DATABASE stressdb;
USE SCHEMA bdb_5nodes;

SELECT COUNT(*) FROM uservisits;

-----------+
 COUNT(*)  |
-----------+
 751754869 |
-----------+

-- Example 7792
CREATE OR REPLACE TABLE daily_uniques
AS
SELECT
 visitdate,
 hll_export(hll_accumulate(sourceip)) AS hll_sourceip
FROM uservisits
GROUP BY visitdate;

-- Example 7793
SELECT
  EXTRACT(year FROM visitdate) AS visit_year,
  EXTRACT(month FROM visitdate) AS visit_month,
  hll_estimate(hll_combine(hll_import(hll_sourceip))) AS distinct_ips
FROM daily_uniques
WHERE visitdate BETWEEN '2000-01-01' AND '2000-12-31'
GROUP BY 1,2
ORDER BY 1,2;

------------+-------------+--------------+
 VISIT_YEAR | VISIT_MONTH | DISTINCT_IPS |
------------+-------------+--------------+
       2000 |           1 |      1515168 |
       2000 |           2 |      1410289 |
       2000 |           3 |      1491997 |
       2000 |           4 |      1460837 |
       2000 |           5 |      1546647 |
       2000 |           6 |      1485599 |
       2000 |           7 |      1522643 |
       2000 |           8 |      1492831 |
       2000 |           9 |      1488507 |
       2000 |          10 |      1553201 |
       2000 |          11 |      1461140 |
       2000 |          12 |      1515772 |
------------+-------------+--------------+

Elapsed 1.3s

-- Example 7794
SELECT
  EXTRACT(year FROM visitdate) AS visit_year,
  EXTRACT(month FROM visitdate) AS visit_month,
  hll(sourceip) AS distinct_ips
FROM uservisits
WHERE visitdate BETWEEN '2000-01-01' AND '2000-12-31'
GROUP BY 1,2
ORDER BY 1,2;

------------+-------------+--------------+
 VISIT_YEAR | VISIT_MONTH | DISTINCT_IPS |
------------+-------------+--------------+
       2000 |           1 |      1515168 |
       2000 |           2 |      1410289 |
       2000 |           3 |      1491997 |
       2000 |           4 |      1460837 |
       2000 |           5 |      1546647 |
       2000 |           6 |      1485599 |
       2000 |           7 |      1522643 |
       2000 |           8 |      1492831 |
       2000 |           9 |      1488507 |
       2000 |          10 |      1553201 |
       2000 |          11 |      1461140 |
       2000 |          12 |      1515772 |
------------+-------------+--------------+

Elapsed 2m 29s

-- Example 7795
CREATE OR REPLACE TABLE mhtab1(c1 NUMBER,c2 DOUBLE,c3 TEXT,c4 DATE);
CREATE OR REPLACE TABLE mhtab2(c1 NUMBER,c2 DOUBLE,c3 TEXT,c4 DATE);

INSERT INTO mhtab1 VALUES
    (1, 1.1, 'item 1', to_date('2016-11-30')),
    (2, 2.31, 'item 2', to_date('2016-11-30')),
    (3, 1.1, 'item 3', to_date('2016-11-29')),
    (4, 44.4, 'item 4', to_date('2016-11-30'));

INSERT INTO mhtab2 VALUES
    (1, 1.1, 'item 1', to_date('2016-11-30')),
    (2, 2.31, 'item 2', to_date('2016-11-30')),
    (3, 1.1, 'item 3', to_date('2016-11-29')),
    (4, 44.4, 'item 4', to_date('2016-11-30')),
    (6, 34.23, 'item 6', to_date('2016-11-29'));

-- Example 7796
SELECT APPROXIMATE_SIMILARITY(mh) FROM
    ((SELECT MINHASH(100, *) AS mh FROM mhtab1)
    UNION ALL
    (SELECT MINHASH(100, *) AS mh FROM mhtab2));

+----------------------------+
| APPROXIMATE_SIMILARITY(MH) |
|----------------------------|
|                       0.79 |
+----------------------------+

-- Example 7797
[ ... ]
SELECT [ { ALL | DISTINCT } ]
       [ TOP <n> ]
       [{<object_name>|<alias>}.]*

       [ ILIKE '<pattern>' ]

       [ EXCLUDE
         {
           <col_name> | ( <col_name>, <col_name>, ... )
         }
       ]

       [ REPLACE
         {
           ( <expr> AS <col_name> [ , <expr> AS <col_name>, ... ] )
         }
       ]

       [ RENAME
         {
           <col_name> AS <col_alias>
           | ( <col_name> AS <col_alias>, <col_name> AS <col_alias>, ... )
         }
       ]

-- Example 7798
SELECT * ILIKE ... REPLACE ...

-- Example 7799
SELECT * ILIKE ... RENAME ...

-- Example 7800
SELECT * ILIKE ... REPLACE ... RENAME ...

-- Example 7801
SELECT * EXCLUDE ... REPLACE ...

-- Example 7802
SELECT * EXCLUDE ... RENAME ...

-- Example 7803
SELECT * EXCLUDE ... REPLACE ... RENAME ...

-- Example 7804
SELECT * REPLACE ... RENAME ...

-- Example 7805
[ ... ]
SELECT [ { ALL | DISTINCT } ]
       [ TOP <n> ]
       {
         [{<object_name>|<alias>}.]<col_name>
         | [{<object_name>|<alias>}.]$<col_position>
         | <expr>
       }
       [ [ AS ] <col_alias> ]
       [ , ... ]
[ ... ]

-- Example 7806
SELECT emp_id,
       name,
       dept,
  FROM employees;

-- Example 7807
SELECT table_a.* EXCLUDE column_in_table_a ,
  table_b.* EXCLUDE column_in_table_b
  ...

-- Example 7808
SELECT * REPLACE ('DEPT-' || department_id AS department_id) ...

-- Example 7809
SELECT table_a.* RENAME column_in_table_a AS col_alias_a,
  table_b.* RENAME column_in_table_b AS col_alias_b
  ...

-- Example 7810
SELECT * EXCLUDE col_a RENAME col_b AS alias_b ...

-- Example 7811
SELECT * EXCLUDE employee_id REPLACE ('DEPT-' || department_id AS department_id) ...

-- Example 7812
SELECT * ILIKE '%id%' RENAME department_id AS department ...

-- Example 7813
SELECT * ILIKE '%id%' REPLACE ('DEPT-' || department_id AS department_id) ...

-- Example 7814
SELECT * REPLACE ('DEPT-' || department_id AS department_id) RENAME employee_id as employee ...

-- Example 7815
SELECT * REPLACE ('DEPT-' || department_id AS department_id) RENAME department_id as department ...

-- Example 7816
CREATE TABLE employee_table (
    employee_ID INTEGER,
    last_name VARCHAR,
    first_name VARCHAR,
    department_ID INTEGER
    );

CREATE TABLE department_table (
    department_ID INTEGER,
    department_name VARCHAR
    );

-- Example 7817
INSERT INTO employee_table (employee_ID, last_name, first_name, department_ID) VALUES
    (101, 'Montgomery', 'Pat', 1),
    (102, 'Levine', 'Terry', 2),
    (103, 'Comstock', 'Dana', 2);

INSERT INTO department_table (department_ID, department_name) VALUES
    (1, 'Engineering'),
    (2, 'Customer Support'),
    (3, 'Finance');

-- Example 7818
SELECT * FROM employee_table;

-- Example 7819
+-------------+------------+------------+---------------+
| EMPLOYEE_ID | LAST_NAME  | FIRST_NAME | DEPARTMENT_ID |
|-------------+------------+------------+---------------|
|         101 | Montgomery | Pat        |             1 |
|         102 | Levine     | Terry      |             2 |
|         103 | Comstock   | Dana       |             2 |
+-------------+------------+------------+---------------+

