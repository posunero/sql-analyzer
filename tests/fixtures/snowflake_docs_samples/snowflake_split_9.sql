-- Example 545
SELECT
        doi.event_date as "Date", 
        record_temperatures.city,
        record_temperatures.temperature
    FROM dates_of_interest AS doi,
         TABLE(record_high_temperatures_for_date(doi.event_date)) AS record_temperatures
      ORDER BY doi.event_date, city;
+------------+-------------+-------------+
| Date       | CITY        | TEMPERATURE |
|------------+-------------+-------------|
| 2021-06-21 | Los Angeles |          69 |
| 2021-06-21 | New York    |          65 |
| 2022-06-21 | Los Angeles |          69 |
| 2022-06-21 | New York    |          65 |
+------------+-------------+-------------+

-- Example 546
SELECT ...
  FROM [ <input_table> [ [AS] <alias_1> ] ,
         [ LATERAL ]
       ]
       TABLE( <table_function>( [ <arg_1> [, ... ] ] ) ) [ [ AS ] <alias_2> ];

-- Example 547
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', null);

-- Example 548
<function> ( [ <arguments> ] ) OVER ( [ <windowDefinition> ] )

-- Example 549
windowDefinition ::=

[ PARTITION BY <expr1> [, ...] ]
[ ORDER BY <expr2> [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] ]
[ <windowFrameClause> ]

-- Example 550
windowFrameClause ::=

{
    { ROWS | RANGE } UNBOUNDED PRECEDING
  | { ROWS | RANGE } <n> PRECEDING
  | { ROWS | RANGE } CURRENT ROW
  | { ROWS | RANGE } BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  | { ROWS | RANGE } BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
  | { ROWS | RANGE } BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  | { ROWS | RANGE } BETWEEN <n> { PRECEDING | FOLLOWING } AND <n> { PRECEDING | FOLLOWING }
  | { ROWS | RANGE } BETWEEN UNBOUNDED PRECEDING AND <n> { PRECEDING | FOLLOWING }
  | { ROWS | RANGE } BETWEEN <n> { PRECEDING | FOLLOWING } AND UNBOUNDED FOLLOWING
}

-- Example 551
COUNT(t1.*) OVER(ORDER BY col1 RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING)

-- Example 552
ORDER BY col1 ASC RANGE BETWEEN 2 PRECEDING AND 4 PRECEDING
ORDER BY col1 ASC RANGE BETWEEN 2 FOLLOWING AND 2 PRECEDING

-- Example 553
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- Example 554
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- Example 555
CREATE TRANSIENT TABLE store_sales (
    branch_ID    INTEGER,
    city        VARCHAR,
    gross_sales NUMERIC(9, 2),
    gross_costs NUMERIC(9, 2),
    net_profit  NUMERIC(9, 2)
    );

INSERT INTO store_sales (branch_ID, city, gross_sales, gross_costs)
    VALUES
    (1, 'Vancouver', 110000, 100000),
    (2, 'Vancouver', 140000, 125000),
    (3, 'Montreal', 150000, 140000),
    (4, 'Montreal', 155000, 146000);

UPDATE store_sales SET net_profit = gross_sales - gross_costs;

-- Example 556
SELECT branch_ID,
       net_profit,
       100 * RATIO_TO_REPORT(net_profit) OVER () AS percent_of_chain_profit
    FROM store_sales AS s1
    ORDER BY branch_ID;
+-----------+------------+-------------------------+
| BRANCH_ID | NET_PROFIT | PERCENT_OF_CHAIN_PROFIT |
|-----------+------------+-------------------------|
|         1 |   10000.00 |             22.72727300 |
|         2 |   15000.00 |             34.09090900 |
|         3 |   10000.00 |             22.72727300 |
|         4 |    9000.00 |             20.45454500 |
+-----------+------------+-------------------------+

-- Example 557
CREATE OR REPLACE TABLE example_cumulative (p INT, o INT, i INT);

INSERT INTO example_cumulative VALUES
    (  0, 1, 10), (0, 2, 20), (0, 3, 30),
    (100, 1, 10),(100, 2, 30),(100, 2, 5),(100, 3, 11),(100, 3, 120),
    (200, 1, 10000),(200, 1, 200),(200, 1, 808080),(200, 2, 33333),(200, 3, null), (200, 3, 4),
    (300, 1, null), (300, 1, null);

-- Example 558
SELECT
    p, o, i,
    COUNT(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) count_i_Rows_Pre,
    SUM(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_i_Rows_Pre,
    AVG(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) avg_i_Rows_Pre,
    MIN(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) min_i_Rows_Pre,
    MAX(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) max_i_Rows_Pre
  FROM example_cumulative
  ORDER BY p,o;
+-----+---+--------+------------------+----------------+----------------+----------------+----------------+
|   P | O |      I | COUNT_I_ROWS_PRE | SUM_I_ROWS_PRE | AVG_I_ROWS_PRE | MIN_I_ROWS_PRE | MAX_I_ROWS_PRE |
|-----+---+--------+------------------+----------------+----------------+----------------+----------------|
|   0 | 1 |     10 |                1 |             10 |         10.000 |             10 |             10 |
|   0 | 2 |     20 |                2 |             30 |         15.000 |             10 |             20 |
|   0 | 3 |     30 |                3 |             60 |         20.000 |             10 |             30 |
| 100 | 1 |     10 |                1 |             10 |         10.000 |             10 |             10 |
| 100 | 2 |     30 |                2 |             40 |         20.000 |             10 |             30 |
| 100 | 2 |      5 |                3 |             45 |         15.000 |              5 |             30 |
| 100 | 3 |     11 |                4 |             56 |         14.000 |              5 |             30 |
| 100 | 3 |    120 |                5 |            176 |         35.200 |              5 |            120 |
| 200 | 1 |  10000 |                1 |          10000 |      10000.000 |          10000 |          10000 |
| 200 | 1 |    200 |                2 |          10200 |       5100.000 |            200 |          10000 |
| 200 | 1 | 808080 |                3 |         818280 |     272760.000 |            200 |         808080 |
| 200 | 2 |  33333 |                4 |         851613 |     212903.250 |            200 |         808080 |
| 200 | 3 |   NULL |                4 |         851613 |     212903.250 |            200 |         808080 |
| 200 | 3 |      4 |                5 |         851617 |     170323.400 |              4 |         808080 |
| 300 | 1 |   NULL |                0 |           NULL |           NULL |           NULL |           NULL |
| 300 | 1 |   NULL |                0 |           NULL |           NULL |           NULL |           NULL |
+-----+---+--------+------------------+----------------+----------------+----------------+----------------+

-- Example 559
SELECT
    p, o, i,
    COUNT(i) OVER (PARTITION BY p ORDER BY o) count_i_Range_Pre,
    SUM(i)   OVER (PARTITION BY p ORDER BY o) sum_i_Range_Pre,
    AVG(i)   OVER (PARTITION BY p ORDER BY o) avg_i_Range_Pre,
    MIN(i)   OVER (PARTITION BY p ORDER BY o) min_i_Range_Pre,
    MAX(i)   OVER (PARTITION BY p ORDER BY o) max_i_Range_Pre
  FROM example_cumulative
  ORDER BY p,o;
+-----+---+--------+-------------------+-----------------+-----------------+-----------------+-----------------+
|   P | O |      I | COUNT_I_RANGE_PRE | SUM_I_RANGE_PRE | AVG_I_RANGE_PRE | MIN_I_RANGE_PRE | MAX_I_RANGE_PRE |
|-----+---+--------+-------------------+-----------------+-----------------+-----------------+-----------------|
|   0 | 1 |     10 |                 1 |              10 |       10.000000 |              10 |              10 |
|   0 | 2 |     20 |                 2 |              30 |       15.000000 |              10 |              20 |
|   0 | 3 |     30 |                 3 |              60 |       20.000000 |              10 |              30 |
| 100 | 1 |     10 |                 1 |              10 |       10.000000 |              10 |              10 |
| 100 | 2 |     30 |                 3 |              45 |       15.000000 |               5 |              30 |
| 100 | 2 |      5 |                 3 |              45 |       15.000000 |               5 |              30 |
| 100 | 3 |     11 |                 5 |             176 |       35.200000 |               5 |             120 |
| 100 | 3 |    120 |                 5 |             176 |       35.200000 |               5 |             120 |
| 200 | 1 |  10000 |                 3 |          818280 |   272760.000000 |             200 |          808080 |
| 200 | 1 |    200 |                 3 |          818280 |   272760.000000 |             200 |          808080 |
| 200 | 1 | 808080 |                 3 |          818280 |   272760.000000 |             200 |          808080 |
| 200 | 2 |  33333 |                 4 |          851613 |   212903.250000 |             200 |          808080 |
| 200 | 3 |   NULL |                 5 |          851617 |   170323.400000 |               4 |          808080 |
| 200 | 3 |      4 |                 5 |          851617 |   170323.400000 |               4 |          808080 |
| 300 | 1 |   NULL |                 0 |            NULL |            NULL |            NULL |            NULL |
| 300 | 1 |   NULL |                 0 |            NULL |            NULL |            NULL |            NULL |
+-----+---+--------+-------------------+-----------------+-----------------+-----------------+-----------------+

-- Example 560
CREATE TABLE example_sliding
  (p INT, o INT, i INT, r INT, s VARCHAR(100));

INSERT INTO example_sliding VALUES
  (100,1,1,70,'seventy'),(100,2,2,30, 'thirty'),(100,3,3,40,'forty'),(100,4,NULL,90,'ninety'),
  (100,5,5,50,'fifty'),(100,6,6,30,'thirty'),
  (200,7,7,40,'forty'),(200,8,NULL,NULL,'n_u_l_l'),(200,9,NULL,NULL,'n_u_l_l'),(200,10,10,20,'twenty'),
  (200,11,NULL,90,'ninety'),
  (300,12,12,30,'thirty'),
  (400,13,NULL,20,'twenty');

-- Example 561
select p, o, i AS i_col,
    MIN(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) min_i_3P_1P,
    MIN(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) min_i_1F_3F,
    MIN(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) min_i_1P_3F,
    s,
    MIN(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) min_s_3P_1P,
    MIN(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) min_s_1F_3F,
    MIN(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) min_s_1P_3F
  FROM example_sliding
  ORDER BY p, o;
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+
|   P |  O | I_COL | MIN_I_3P_1P | MIN_I_1F_3F | MIN_I_1P_3F | S       | MIN_S_3P_1P | MIN_S_1F_3F | MIN_S_1P_3F |
|-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------|
| 100 |  1 |     1 |        NULL |           2 |           1 | seventy | NULL        | forty       | forty       |
| 100 |  2 |     2 |           1 |           3 |           1 | thirty  | seventy     | fifty       | fifty       |
| 100 |  3 |     3 |           1 |           5 |           2 | forty   | seventy     | fifty       | fifty       |
| 100 |  4 |  NULL |           1 |           5 |           3 | ninety  | forty       | fifty       | fifty       |
| 100 |  5 |     5 |           2 |           6 |           5 | fifty   | forty       | thirty      | fifty       |
| 100 |  6 |     6 |           3 |        NULL |           5 | thirty  | fifty       | NULL        | fifty       |
| 200 |  7 |     7 |        NULL |          10 |           7 | forty   | NULL        | n_u_l_l     | forty       |
| 200 |  8 |  NULL |           7 |          10 |           7 | n_u_l_l | forty       | n_u_l_l     | forty       |
| 200 |  9 |  NULL |           7 |          10 |          10 | n_u_l_l | forty       | ninety      | n_u_l_l     |
| 200 | 10 |    10 |           7 |        NULL |          10 | twenty  | forty       | ninety      | n_u_l_l     |
| 200 | 11 |  NULL |          10 |        NULL |          10 | ninety  | n_u_l_l     | NULL        | ninety      |
| 300 | 12 |    12 |        NULL |        NULL |          12 | thirty  | NULL        | NULL        | thirty      |
| 400 | 13 |  NULL |        NULL |        NULL |        NULL | twenty  | NULL        | NULL        | twenty      |
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+

-- Example 562
SELECT p, o, i AS i_col,
    MAX(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) max_i_3P_1P,
    MAX(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) max_i_1F_3F,
    MAX(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) max_i_1P_3F,
    s,
    MAX(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) max_s_3P_1P,
    MAX(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) max_s_1F_3F,
    MAX(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) max_s_1P_3F
  FROM example_sliding
  ORDER BY p, o;
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+
|   P |  O | I_COL | MAX_I_3P_1P | MAX_I_1F_3F | MAX_I_1P_3F | S       | MAX_S_3P_1P | MAX_S_1F_3F | MAX_S_1P_3F |
|-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------|
| 100 |  1 |     1 |        NULL |           3 |           3 | seventy | NULL        | thirty      | thirty      |
| 100 |  2 |     2 |           1 |           5 |           5 | thirty  | seventy     | ninety      | thirty      |
| 100 |  3 |     3 |           2 |           6 |           6 | forty   | thirty      | thirty      | thirty      |
| 100 |  4 |  NULL |           3 |           6 |           6 | ninety  | thirty      | thirty      | thirty      |
| 100 |  5 |     5 |           3 |           6 |           6 | fifty   | thirty      | thirty      | thirty      |
| 100 |  6 |     6 |           5 |        NULL |           6 | thirty  | ninety      | NULL        | thirty      |
| 200 |  7 |     7 |        NULL |          10 |          10 | forty   | NULL        | twenty      | twenty      |
| 200 |  8 |  NULL |           7 |          10 |          10 | n_u_l_l | forty       | twenty      | twenty      |
| 200 |  9 |  NULL |           7 |          10 |          10 | n_u_l_l | n_u_l_l     | twenty      | twenty      |
| 200 | 10 |    10 |           7 |        NULL |          10 | twenty  | n_u_l_l     | ninety      | twenty      |
| 200 | 11 |  NULL |          10 |        NULL |          10 | ninety  | twenty      | NULL        | twenty      |
| 300 | 12 |    12 |        NULL |        NULL |          12 | thirty  | NULL        | NULL        | thirty      |
| 400 | 13 |  NULL |        NULL |        NULL |        NULL | twenty  | NULL        | NULL        | twenty      |
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+

-- Example 563
SELECT p, o, r AS r_col,
    SUM(r) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 4 PRECEDING AND 2 PRECEDING) sum_r_4P_2P,
    sum(r) over (partition by p ORDER BY o ROWS BETWEEN 2 FOLLOWING AND 4 FOLLOWING) sum_r_2F_4F,
    sum(r) over (partition by p ORDER BY o ROWS BETWEEN 2 PRECEDING AND 4 FOLLOWING) sum_r_2P_4F
  FROM example_sliding
  ORDER BY p, o;
+-----+----+-------+-------------+-------------+-------------+
|   P |  O | R_COL | SUM_R_4P_2P | SUM_R_2F_4F | SUM_R_2P_4F |
|-----+----+-------+-------------+-------------+-------------|
| 100 |  1 |    70 |        NULL |         180 |         280 |
| 100 |  2 |    30 |        NULL |         170 |         310 |
| 100 |  3 |    40 |          70 |          80 |         310 |
| 100 |  4 |    90 |         100 |          30 |         240 |
| 100 |  5 |    50 |         140 |        NULL |         210 |
| 100 |  6 |    30 |         160 |        NULL |         170 |
| 200 |  7 |    40 |        NULL |         110 |         150 |
| 200 |  8 |  NULL |        NULL |         110 |         150 |
| 200 |  9 |  NULL |          40 |          90 |         150 |
| 200 | 10 |    20 |          40 |        NULL |         110 |
| 200 | 11 |    90 |          40 |        NULL |         110 |
| 300 | 12 |    30 |        NULL |        NULL |          30 |
| 400 | 13 |    20 |        NULL |        NULL |          20 |
+-----+----+-------+-------------+-------------+-------------+

-- Example 564
CREATE TABLE sales_table (salesperson_name VARCHAR, sales_in_dollars INTEGER);
INSERT INTO sales_table (salesperson_name, sales_in_dollars) VALUES
    ('Smith', 600),
    ('Jones', 1000),
    ('Torkelson', 700),
    ('Dolenz', 800);

-- Example 565
SELECT
    salesperson_name,
    sales_in_dollars,
    RANK() OVER (ORDER BY sales_in_dollars DESC) AS sales_rank
  FROM sales_table;
+------------------+------------------+------------+
| SALESPERSON_NAME | SALES_IN_DOLLARS | SALES_RANK |
|------------------+------------------+------------|
| Jones            |             1000 |          1 |
| Dolenz           |              800 |          2 |
| Torkelson        |              700 |          3 |
| Smith            |              600 |          4 |
+------------------+------------------+------------+

-- Example 566
SELECT
    salesperson_name,
    sales_in_dollars,
    RANK() OVER (ORDER BY sales_in_dollars DESC) AS sales_rank
  FROM sales_table
  ORDER BY 3;
+------------------+------------------+------------+
| SALESPERSON_NAME | SALES_IN_DOLLARS | SALES_RANK |
|------------------+------------------+------------|
| Jones            |             1000 |          1 |
| Dolenz           |              800 |          2 |
| Torkelson        |              700 |          3 |
| Smith            |              600 |          4 |
+------------------+------------------+------------+

-- Example 567
SELECT
    salesperson_name,
    sales_in_dollars,
    RANK() OVER (ORDER BY sales_in_dollars DESC) AS sales_rank
  FROM sales_table
  ORDER BY salesperson_name;
+------------------+------------------+------------+
| SALESPERSON_NAME | SALES_IN_DOLLARS | SALES_RANK |
|------------------+------------------+------------|
| Dolenz           |              800 |          2 |
| Jones            |             1000 |          1 |
| Smith            |              600 |          4 |
| Torkelson        |              700 |          3 |
+------------------+------------------+------------+

-- Example 568
SELECT menu_category, menu_cogs_usd,
    AVG(menu_cogs_usd)
      OVER(ORDER BY menu_cogs_usd RANGE BETWEEN CURRENT ROW AND 2 FOLLOWING) avg_cogs
  FROM menu_items
  WHERE menu_category IN('Beverage','Dessert','Snack')
  GROUP BY menu_category, menu_cogs_usd
  ORDER BY menu_category, menu_cogs_usd;

-- Example 569
+---------------+---------------+----------+
| MENU_CATEGORY | MENU_COGS_USD | AVG_COGS |
|---------------+---------------+----------|
| Beverage      |          0.50 |  1.18333 |
| Beverage      |          0.65 |  1.37857 |
| Beverage      |          0.75 |  1.50000 |
| Dessert       |          0.50 |  1.18333 |
| Dessert       |          1.00 |  1.87500 |
| Dessert       |          1.25 |  2.05000 |
| Dessert       |          2.50 |  3.16666 |
| Dessert       |          3.00 |  3.50000 |
| Snack         |          1.25 |  2.05000 |
| Snack         |          2.25 |  2.93750 |
| Snack         |          4.00 |  4.00000 |
+---------------+---------------+----------+

-- Example 570
CREATE OR REPLACE TABLE nulls(c1 int, c2 int);

INSERT INTO nulls VALUES
  (1,10),
  (2,20),
  (3,30),
  (NULL,20),
  (NULL,50);

-- Example 571
SELECT c1 c1_nulls_last, c2,
    SUM(c2) OVER(ORDER BY c1 NULLS LAST RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_c2
  FROM nulls;

-- Example 572
+---------------+----+--------+
| C1_NULLS_LAST | C2 | SUM_C2 |
|---------------+----+--------|
|             1 | 10 |     30 |
|             2 | 20 |     60 |
|             3 | 30 |     50 |
|          NULL | 20 |     70 |
|          NULL | 50 |     70 |
+---------------+----+--------+

-- Example 573
SELECT c1 c1_nulls_last, c2,
    SUM(c2) OVER(ORDER BY c1 NULLS LAST RANGE BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) sum_c2
  FROM nulls;

-- Example 574
+---------------+----+--------+
| C1_NULLS_LAST | C2 | SUM_C2 |
|---------------+----+--------|
|             1 | 10 |    130 |
|             2 | 20 |    130 |
|             3 | 30 |    120 |
|          NULL | 20 |     70 |
|          NULL | 50 |     70 |
+---------------+----+--------+

-- Example 575
CREATE OR REPLACE TABLE heavy_weather
  (start_time TIMESTAMP, precip NUMBER(3,2), city VARCHAR(20), county VARCHAR(20));

INSERT INTO heavy_weather VALUES
('2021-12-23 06:56:00.000',0.08,'Mount Shasta','Siskiyou'),
('2021-12-23 07:51:00.000',0.09,'Mount Shasta','Siskiyou'),
('2021-12-23 16:23:00.000',0.56,'South Lake Tahoe','El Dorado'),
('2021-12-23 17:24:00.000',0.38,'South Lake Tahoe','El Dorado'),
('2021-12-23 18:30:00.000',0.28,'South Lake Tahoe','El Dorado'),
('2021-12-23 19:35:00.000',0.37,'Mammoth Lakes','Mono'),
('2021-12-23 19:36:00.000',0.80,'South Lake Tahoe','El Dorado'),
('2021-12-24 04:43:00.000',0.25,'Alta','Placer'),
('2021-12-24 05:26:00.000',0.34,'Alta','Placer'),
('2021-12-24 05:35:00.000',0.42,'Big Bear City','San Bernardino'),
('2021-12-24 06:49:00.000',0.17,'South Lake Tahoe','El Dorado'),
('2021-12-24 07:40:00.000',0.07,'Alta','Placer'),
('2021-12-24 08:36:00.000',0.07,'Alta','Placer'),
('2021-12-24 11:52:00.000',0.08,'Alta','Placer'),
('2021-12-24 12:52:00.000',0.38,'Alta','Placer'),
('2021-12-24 15:44:00.000',0.13,'Alta','Placer'),
('2021-12-24 15:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
('2021-12-24 16:55:00.000',0.09,'Big Bear City','San Bernardino'),
('2021-12-24 21:53:00.000',0.07,'Montague','Siskiyou'),
('2021-12-25 02:52:00.000',0.07,'Alta','Placer'),
('2021-12-25 07:52:00.000',0.07,'Alta','Placer'),
('2021-12-25 08:52:00.000',0.08,'Alta','Placer'),
('2021-12-25 09:48:00.000',0.18,'Alta','Placer'),
('2021-12-25 12:52:00.000',0.10,'Alta','Placer'),
('2021-12-25 17:21:00.000',0.23,'Alturas','Modoc'),
('2021-12-25 17:52:00.000',1.54,'Alta','Placer'),
('2021-12-26 01:52:00.000',0.61,'Alta','Placer'),
('2021-12-26 05:43:00.000',0.16,'South Lake Tahoe','El Dorado'),
('2021-12-26 05:56:00.000',0.08,'Bishop','Inyo'),
('2021-12-26 06:52:00.000',0.75,'Bishop','Inyo'),
('2021-12-26 06:53:00.000',0.08,'Lebec','Los Angeles'),
('2021-12-26 07:52:00.000',0.65,'Alta','Placer'),
('2021-12-26 09:52:00.000',2.78,'Alta','Placer'),
('2021-12-26 09:55:00.000',0.07,'Big Bear City','San Bernardino'),
('2021-12-26 14:22:00.000',0.32,'Alta','Placer'),
('2021-12-26 14:52:00.000',0.34,'Alta','Placer'),
('2021-12-26 15:43:00.000',0.35,'Alta','Placer'),
('2021-12-26 17:31:00.000',5.24,'Alta','Placer'),
('2021-12-26 22:52:00.000',0.07,'Alta','Placer'),
('2021-12-26 23:15:00.000',0.52,'Alta','Placer'),
('2021-12-27 02:52:00.000',0.08,'Alta','Placer'),
('2021-12-27 03:52:00.000',0.14,'Alta','Placer'),
('2021-12-27 04:52:00.000',1.52,'Alta','Placer'),
('2021-12-27 14:37:00.000',0.89,'Alta','Placer'),
('2021-12-27 14:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
('2021-12-27 17:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
('2021-12-30 11:23:00.000',0.12,'Lebec','Los Angeles'),
('2021-12-30 11:43:00.000',0.98,'Lebec','Los Angeles'),
('2021-12-30 13:53:00.000',0.23,'Lebec','Los Angeles'),
('2021-12-30 14:53:00.000',0.13,'Lebec','Los Angeles'),
('2021-12-30 15:15:00.000',0.29,'Lebec','Los Angeles'),
('2021-12-30 17:53:00.000',0.10,'Lebec','Los Angeles'),
('2021-12-30 18:53:00.000',0.09,'Lebec','Los Angeles'),
('2021-12-30 19:53:00.000',0.07,'Lebec','Los Angeles'),
('2021-12-30 20:53:00.000',0.07,'Lebec','Los Angeles')
;

-- Example 576
<function> ( [ <arguments> ] ) OVER ( [ <windowDefinition> ] )

-- Example 577
windowDefinition ::=

[ PARTITION BY <expr1> [, ...] ]
[ ORDER BY <expr2> [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] ]
[ <windowFrameClause> ]

-- Example 578
windowFrameClause ::=

{
    { ROWS | RANGE } UNBOUNDED PRECEDING
  | { ROWS | RANGE } <n> PRECEDING
  | { ROWS | RANGE } CURRENT ROW
  | { ROWS | RANGE } BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  | { ROWS | RANGE } BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
  | { ROWS | RANGE } BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  | { ROWS | RANGE } BETWEEN <n> { PRECEDING | FOLLOWING } AND <n> { PRECEDING | FOLLOWING }
  | { ROWS | RANGE } BETWEEN UNBOUNDED PRECEDING AND <n> { PRECEDING | FOLLOWING }
  | { ROWS | RANGE } BETWEEN <n> { PRECEDING | FOLLOWING } AND UNBOUNDED FOLLOWING
}

-- Example 579
COUNT(t1.*) OVER(ORDER BY col1 RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING)

-- Example 580
ORDER BY col1 ASC RANGE BETWEEN 2 PRECEDING AND 4 PRECEDING
ORDER BY col1 ASC RANGE BETWEEN 2 FOLLOWING AND 2 PRECEDING

-- Example 581
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- Example 582
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- Example 583
CREATE TRANSIENT TABLE store_sales (
    branch_ID    INTEGER,
    city        VARCHAR,
    gross_sales NUMERIC(9, 2),
    gross_costs NUMERIC(9, 2),
    net_profit  NUMERIC(9, 2)
    );

INSERT INTO store_sales (branch_ID, city, gross_sales, gross_costs)
    VALUES
    (1, 'Vancouver', 110000, 100000),
    (2, 'Vancouver', 140000, 125000),
    (3, 'Montreal', 150000, 140000),
    (4, 'Montreal', 155000, 146000);

UPDATE store_sales SET net_profit = gross_sales - gross_costs;

-- Example 584
SELECT branch_ID,
       net_profit,
       100 * RATIO_TO_REPORT(net_profit) OVER () AS percent_of_chain_profit
    FROM store_sales AS s1
    ORDER BY branch_ID;
+-----------+------------+-------------------------+
| BRANCH_ID | NET_PROFIT | PERCENT_OF_CHAIN_PROFIT |
|-----------+------------+-------------------------|
|         1 |   10000.00 |             22.72727300 |
|         2 |   15000.00 |             34.09090900 |
|         3 |   10000.00 |             22.72727300 |
|         4 |    9000.00 |             20.45454500 |
+-----------+------------+-------------------------+

-- Example 585
CREATE OR REPLACE TABLE example_cumulative (p INT, o INT, i INT);

INSERT INTO example_cumulative VALUES
    (  0, 1, 10), (0, 2, 20), (0, 3, 30),
    (100, 1, 10),(100, 2, 30),(100, 2, 5),(100, 3, 11),(100, 3, 120),
    (200, 1, 10000),(200, 1, 200),(200, 1, 808080),(200, 2, 33333),(200, 3, null), (200, 3, 4),
    (300, 1, null), (300, 1, null);

-- Example 586
SELECT
    p, o, i,
    COUNT(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) count_i_Rows_Pre,
    SUM(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_i_Rows_Pre,
    AVG(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) avg_i_Rows_Pre,
    MIN(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) min_i_Rows_Pre,
    MAX(i)   OVER (PARTITION BY p ORDER BY o ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) max_i_Rows_Pre
  FROM example_cumulative
  ORDER BY p,o;
+-----+---+--------+------------------+----------------+----------------+----------------+----------------+
|   P | O |      I | COUNT_I_ROWS_PRE | SUM_I_ROWS_PRE | AVG_I_ROWS_PRE | MIN_I_ROWS_PRE | MAX_I_ROWS_PRE |
|-----+---+--------+------------------+----------------+----------------+----------------+----------------|
|   0 | 1 |     10 |                1 |             10 |         10.000 |             10 |             10 |
|   0 | 2 |     20 |                2 |             30 |         15.000 |             10 |             20 |
|   0 | 3 |     30 |                3 |             60 |         20.000 |             10 |             30 |
| 100 | 1 |     10 |                1 |             10 |         10.000 |             10 |             10 |
| 100 | 2 |     30 |                2 |             40 |         20.000 |             10 |             30 |
| 100 | 2 |      5 |                3 |             45 |         15.000 |              5 |             30 |
| 100 | 3 |     11 |                4 |             56 |         14.000 |              5 |             30 |
| 100 | 3 |    120 |                5 |            176 |         35.200 |              5 |            120 |
| 200 | 1 |  10000 |                1 |          10000 |      10000.000 |          10000 |          10000 |
| 200 | 1 |    200 |                2 |          10200 |       5100.000 |            200 |          10000 |
| 200 | 1 | 808080 |                3 |         818280 |     272760.000 |            200 |         808080 |
| 200 | 2 |  33333 |                4 |         851613 |     212903.250 |            200 |         808080 |
| 200 | 3 |   NULL |                4 |         851613 |     212903.250 |            200 |         808080 |
| 200 | 3 |      4 |                5 |         851617 |     170323.400 |              4 |         808080 |
| 300 | 1 |   NULL |                0 |           NULL |           NULL |           NULL |           NULL |
| 300 | 1 |   NULL |                0 |           NULL |           NULL |           NULL |           NULL |
+-----+---+--------+------------------+----------------+----------------+----------------+----------------+

-- Example 587
SELECT
    p, o, i,
    COUNT(i) OVER (PARTITION BY p ORDER BY o) count_i_Range_Pre,
    SUM(i)   OVER (PARTITION BY p ORDER BY o) sum_i_Range_Pre,
    AVG(i)   OVER (PARTITION BY p ORDER BY o) avg_i_Range_Pre,
    MIN(i)   OVER (PARTITION BY p ORDER BY o) min_i_Range_Pre,
    MAX(i)   OVER (PARTITION BY p ORDER BY o) max_i_Range_Pre
  FROM example_cumulative
  ORDER BY p,o;
+-----+---+--------+-------------------+-----------------+-----------------+-----------------+-----------------+
|   P | O |      I | COUNT_I_RANGE_PRE | SUM_I_RANGE_PRE | AVG_I_RANGE_PRE | MIN_I_RANGE_PRE | MAX_I_RANGE_PRE |
|-----+---+--------+-------------------+-----------------+-----------------+-----------------+-----------------|
|   0 | 1 |     10 |                 1 |              10 |       10.000000 |              10 |              10 |
|   0 | 2 |     20 |                 2 |              30 |       15.000000 |              10 |              20 |
|   0 | 3 |     30 |                 3 |              60 |       20.000000 |              10 |              30 |
| 100 | 1 |     10 |                 1 |              10 |       10.000000 |              10 |              10 |
| 100 | 2 |     30 |                 3 |              45 |       15.000000 |               5 |              30 |
| 100 | 2 |      5 |                 3 |              45 |       15.000000 |               5 |              30 |
| 100 | 3 |     11 |                 5 |             176 |       35.200000 |               5 |             120 |
| 100 | 3 |    120 |                 5 |             176 |       35.200000 |               5 |             120 |
| 200 | 1 |  10000 |                 3 |          818280 |   272760.000000 |             200 |          808080 |
| 200 | 1 |    200 |                 3 |          818280 |   272760.000000 |             200 |          808080 |
| 200 | 1 | 808080 |                 3 |          818280 |   272760.000000 |             200 |          808080 |
| 200 | 2 |  33333 |                 4 |          851613 |   212903.250000 |             200 |          808080 |
| 200 | 3 |   NULL |                 5 |          851617 |   170323.400000 |               4 |          808080 |
| 200 | 3 |      4 |                 5 |          851617 |   170323.400000 |               4 |          808080 |
| 300 | 1 |   NULL |                 0 |            NULL |            NULL |            NULL |            NULL |
| 300 | 1 |   NULL |                 0 |            NULL |            NULL |            NULL |            NULL |
+-----+---+--------+-------------------+-----------------+-----------------+-----------------+-----------------+

-- Example 588
CREATE TABLE example_sliding
  (p INT, o INT, i INT, r INT, s VARCHAR(100));

INSERT INTO example_sliding VALUES
  (100,1,1,70,'seventy'),(100,2,2,30, 'thirty'),(100,3,3,40,'forty'),(100,4,NULL,90,'ninety'),
  (100,5,5,50,'fifty'),(100,6,6,30,'thirty'),
  (200,7,7,40,'forty'),(200,8,NULL,NULL,'n_u_l_l'),(200,9,NULL,NULL,'n_u_l_l'),(200,10,10,20,'twenty'),
  (200,11,NULL,90,'ninety'),
  (300,12,12,30,'thirty'),
  (400,13,NULL,20,'twenty');

-- Example 589
select p, o, i AS i_col,
    MIN(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) min_i_3P_1P,
    MIN(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) min_i_1F_3F,
    MIN(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) min_i_1P_3F,
    s,
    MIN(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) min_s_3P_1P,
    MIN(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) min_s_1F_3F,
    MIN(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) min_s_1P_3F
  FROM example_sliding
  ORDER BY p, o;
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+
|   P |  O | I_COL | MIN_I_3P_1P | MIN_I_1F_3F | MIN_I_1P_3F | S       | MIN_S_3P_1P | MIN_S_1F_3F | MIN_S_1P_3F |
|-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------|
| 100 |  1 |     1 |        NULL |           2 |           1 | seventy | NULL        | forty       | forty       |
| 100 |  2 |     2 |           1 |           3 |           1 | thirty  | seventy     | fifty       | fifty       |
| 100 |  3 |     3 |           1 |           5 |           2 | forty   | seventy     | fifty       | fifty       |
| 100 |  4 |  NULL |           1 |           5 |           3 | ninety  | forty       | fifty       | fifty       |
| 100 |  5 |     5 |           2 |           6 |           5 | fifty   | forty       | thirty      | fifty       |
| 100 |  6 |     6 |           3 |        NULL |           5 | thirty  | fifty       | NULL        | fifty       |
| 200 |  7 |     7 |        NULL |          10 |           7 | forty   | NULL        | n_u_l_l     | forty       |
| 200 |  8 |  NULL |           7 |          10 |           7 | n_u_l_l | forty       | n_u_l_l     | forty       |
| 200 |  9 |  NULL |           7 |          10 |          10 | n_u_l_l | forty       | ninety      | n_u_l_l     |
| 200 | 10 |    10 |           7 |        NULL |          10 | twenty  | forty       | ninety      | n_u_l_l     |
| 200 | 11 |  NULL |          10 |        NULL |          10 | ninety  | n_u_l_l     | NULL        | ninety      |
| 300 | 12 |    12 |        NULL |        NULL |          12 | thirty  | NULL        | NULL        | thirty      |
| 400 | 13 |  NULL |        NULL |        NULL |        NULL | twenty  | NULL        | NULL        | twenty      |
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+

-- Example 590
SELECT p, o, i AS i_col,
    MAX(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) max_i_3P_1P,
    MAX(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) max_i_1F_3F,
    MAX(i) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) max_i_1P_3F,
    s,
    MAX(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) max_s_3P_1P,
    MAX(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) max_s_1F_3F,
    MAX(s) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 1 PRECEDING AND 3 FOLLOWING) max_s_1P_3F
  FROM example_sliding
  ORDER BY p, o;
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+
|   P |  O | I_COL | MAX_I_3P_1P | MAX_I_1F_3F | MAX_I_1P_3F | S       | MAX_S_3P_1P | MAX_S_1F_3F | MAX_S_1P_3F |
|-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------|
| 100 |  1 |     1 |        NULL |           3 |           3 | seventy | NULL        | thirty      | thirty      |
| 100 |  2 |     2 |           1 |           5 |           5 | thirty  | seventy     | ninety      | thirty      |
| 100 |  3 |     3 |           2 |           6 |           6 | forty   | thirty      | thirty      | thirty      |
| 100 |  4 |  NULL |           3 |           6 |           6 | ninety  | thirty      | thirty      | thirty      |
| 100 |  5 |     5 |           3 |           6 |           6 | fifty   | thirty      | thirty      | thirty      |
| 100 |  6 |     6 |           5 |        NULL |           6 | thirty  | ninety      | NULL        | thirty      |
| 200 |  7 |     7 |        NULL |          10 |          10 | forty   | NULL        | twenty      | twenty      |
| 200 |  8 |  NULL |           7 |          10 |          10 | n_u_l_l | forty       | twenty      | twenty      |
| 200 |  9 |  NULL |           7 |          10 |          10 | n_u_l_l | n_u_l_l     | twenty      | twenty      |
| 200 | 10 |    10 |           7 |        NULL |          10 | twenty  | n_u_l_l     | ninety      | twenty      |
| 200 | 11 |  NULL |          10 |        NULL |          10 | ninety  | twenty      | NULL        | twenty      |
| 300 | 12 |    12 |        NULL |        NULL |          12 | thirty  | NULL        | NULL        | thirty      |
| 400 | 13 |  NULL |        NULL |        NULL |        NULL | twenty  | NULL        | NULL        | twenty      |
+-----+----+-------+-------------+-------------+-------------+---------+-------------+-------------+-------------+

-- Example 591
SELECT p, o, r AS r_col,
    SUM(r) OVER (PARTITION BY p ORDER BY o ROWS BETWEEN 4 PRECEDING AND 2 PRECEDING) sum_r_4P_2P,
    sum(r) over (partition by p ORDER BY o ROWS BETWEEN 2 FOLLOWING AND 4 FOLLOWING) sum_r_2F_4F,
    sum(r) over (partition by p ORDER BY o ROWS BETWEEN 2 PRECEDING AND 4 FOLLOWING) sum_r_2P_4F
  FROM example_sliding
  ORDER BY p, o;
+-----+----+-------+-------------+-------------+-------------+
|   P |  O | R_COL | SUM_R_4P_2P | SUM_R_2F_4F | SUM_R_2P_4F |
|-----+----+-------+-------------+-------------+-------------|
| 100 |  1 |    70 |        NULL |         180 |         280 |
| 100 |  2 |    30 |        NULL |         170 |         310 |
| 100 |  3 |    40 |          70 |          80 |         310 |
| 100 |  4 |    90 |         100 |          30 |         240 |
| 100 |  5 |    50 |         140 |        NULL |         210 |
| 100 |  6 |    30 |         160 |        NULL |         170 |
| 200 |  7 |    40 |        NULL |         110 |         150 |
| 200 |  8 |  NULL |        NULL |         110 |         150 |
| 200 |  9 |  NULL |          40 |          90 |         150 |
| 200 | 10 |    20 |          40 |        NULL |         110 |
| 200 | 11 |    90 |          40 |        NULL |         110 |
| 300 | 12 |    30 |        NULL |        NULL |          30 |
| 400 | 13 |    20 |        NULL |        NULL |          20 |
+-----+----+-------+-------------+-------------+-------------+

-- Example 592
CREATE TABLE sales_table (salesperson_name VARCHAR, sales_in_dollars INTEGER);
INSERT INTO sales_table (salesperson_name, sales_in_dollars) VALUES
    ('Smith', 600),
    ('Jones', 1000),
    ('Torkelson', 700),
    ('Dolenz', 800);

-- Example 593
SELECT
    salesperson_name,
    sales_in_dollars,
    RANK() OVER (ORDER BY sales_in_dollars DESC) AS sales_rank
  FROM sales_table;
+------------------+------------------+------------+
| SALESPERSON_NAME | SALES_IN_DOLLARS | SALES_RANK |
|------------------+------------------+------------|
| Jones            |             1000 |          1 |
| Dolenz           |              800 |          2 |
| Torkelson        |              700 |          3 |
| Smith            |              600 |          4 |
+------------------+------------------+------------+

-- Example 594
SELECT
    salesperson_name,
    sales_in_dollars,
    RANK() OVER (ORDER BY sales_in_dollars DESC) AS sales_rank
  FROM sales_table
  ORDER BY 3;
+------------------+------------------+------------+
| SALESPERSON_NAME | SALES_IN_DOLLARS | SALES_RANK |
|------------------+------------------+------------|
| Jones            |             1000 |          1 |
| Dolenz           |              800 |          2 |
| Torkelson        |              700 |          3 |
| Smith            |              600 |          4 |
+------------------+------------------+------------+

-- Example 595
SELECT
    salesperson_name,
    sales_in_dollars,
    RANK() OVER (ORDER BY sales_in_dollars DESC) AS sales_rank
  FROM sales_table
  ORDER BY salesperson_name;
+------------------+------------------+------------+
| SALESPERSON_NAME | SALES_IN_DOLLARS | SALES_RANK |
|------------------+------------------+------------|
| Dolenz           |              800 |          2 |
| Jones            |             1000 |          1 |
| Smith            |              600 |          4 |
| Torkelson        |              700 |          3 |
+------------------+------------------+------------+

-- Example 596
SELECT menu_category, menu_cogs_usd,
    AVG(menu_cogs_usd)
      OVER(ORDER BY menu_cogs_usd RANGE BETWEEN CURRENT ROW AND 2 FOLLOWING) avg_cogs
  FROM menu_items
  WHERE menu_category IN('Beverage','Dessert','Snack')
  GROUP BY menu_category, menu_cogs_usd
  ORDER BY menu_category, menu_cogs_usd;

-- Example 597
+---------------+---------------+----------+
| MENU_CATEGORY | MENU_COGS_USD | AVG_COGS |
|---------------+---------------+----------|
| Beverage      |          0.50 |  1.18333 |
| Beverage      |          0.65 |  1.37857 |
| Beverage      |          0.75 |  1.50000 |
| Dessert       |          0.50 |  1.18333 |
| Dessert       |          1.00 |  1.87500 |
| Dessert       |          1.25 |  2.05000 |
| Dessert       |          2.50 |  3.16666 |
| Dessert       |          3.00 |  3.50000 |
| Snack         |          1.25 |  2.05000 |
| Snack         |          2.25 |  2.93750 |
| Snack         |          4.00 |  4.00000 |
+---------------+---------------+----------+

-- Example 598
CREATE OR REPLACE TABLE nulls(c1 int, c2 int);

INSERT INTO nulls VALUES
  (1,10),
  (2,20),
  (3,30),
  (NULL,20),
  (NULL,50);

-- Example 599
SELECT c1 c1_nulls_last, c2,
    SUM(c2) OVER(ORDER BY c1 NULLS LAST RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_c2
  FROM nulls;

-- Example 600
+---------------+----+--------+
| C1_NULLS_LAST | C2 | SUM_C2 |
|---------------+----+--------|
|             1 | 10 |     30 |
|             2 | 20 |     60 |
|             3 | 30 |     50 |
|          NULL | 20 |     70 |
|          NULL | 50 |     70 |
+---------------+----+--------+

-- Example 601
SELECT c1 c1_nulls_last, c2,
    SUM(c2) OVER(ORDER BY c1 NULLS LAST RANGE BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) sum_c2
  FROM nulls;

-- Example 602
+---------------+----+--------+
| C1_NULLS_LAST | C2 | SUM_C2 |
|---------------+----+--------|
|             1 | 10 |    130 |
|             2 | 20 |    130 |
|             3 | 30 |    120 |
|          NULL | 20 |     70 |
|          NULL | 50 |     70 |
+---------------+----+--------+

-- Example 603
CREATE OR REPLACE TABLE heavy_weather
  (start_time TIMESTAMP, precip NUMBER(3,2), city VARCHAR(20), county VARCHAR(20));

INSERT INTO heavy_weather VALUES
('2021-12-23 06:56:00.000',0.08,'Mount Shasta','Siskiyou'),
('2021-12-23 07:51:00.000',0.09,'Mount Shasta','Siskiyou'),
('2021-12-23 16:23:00.000',0.56,'South Lake Tahoe','El Dorado'),
('2021-12-23 17:24:00.000',0.38,'South Lake Tahoe','El Dorado'),
('2021-12-23 18:30:00.000',0.28,'South Lake Tahoe','El Dorado'),
('2021-12-23 19:35:00.000',0.37,'Mammoth Lakes','Mono'),
('2021-12-23 19:36:00.000',0.80,'South Lake Tahoe','El Dorado'),
('2021-12-24 04:43:00.000',0.25,'Alta','Placer'),
('2021-12-24 05:26:00.000',0.34,'Alta','Placer'),
('2021-12-24 05:35:00.000',0.42,'Big Bear City','San Bernardino'),
('2021-12-24 06:49:00.000',0.17,'South Lake Tahoe','El Dorado'),
('2021-12-24 07:40:00.000',0.07,'Alta','Placer'),
('2021-12-24 08:36:00.000',0.07,'Alta','Placer'),
('2021-12-24 11:52:00.000',0.08,'Alta','Placer'),
('2021-12-24 12:52:00.000',0.38,'Alta','Placer'),
('2021-12-24 15:44:00.000',0.13,'Alta','Placer'),
('2021-12-24 15:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
('2021-12-24 16:55:00.000',0.09,'Big Bear City','San Bernardino'),
('2021-12-24 21:53:00.000',0.07,'Montague','Siskiyou'),
('2021-12-25 02:52:00.000',0.07,'Alta','Placer'),
('2021-12-25 07:52:00.000',0.07,'Alta','Placer'),
('2021-12-25 08:52:00.000',0.08,'Alta','Placer'),
('2021-12-25 09:48:00.000',0.18,'Alta','Placer'),
('2021-12-25 12:52:00.000',0.10,'Alta','Placer'),
('2021-12-25 17:21:00.000',0.23,'Alturas','Modoc'),
('2021-12-25 17:52:00.000',1.54,'Alta','Placer'),
('2021-12-26 01:52:00.000',0.61,'Alta','Placer'),
('2021-12-26 05:43:00.000',0.16,'South Lake Tahoe','El Dorado'),
('2021-12-26 05:56:00.000',0.08,'Bishop','Inyo'),
('2021-12-26 06:52:00.000',0.75,'Bishop','Inyo'),
('2021-12-26 06:53:00.000',0.08,'Lebec','Los Angeles'),
('2021-12-26 07:52:00.000',0.65,'Alta','Placer'),
('2021-12-26 09:52:00.000',2.78,'Alta','Placer'),
('2021-12-26 09:55:00.000',0.07,'Big Bear City','San Bernardino'),
('2021-12-26 14:22:00.000',0.32,'Alta','Placer'),
('2021-12-26 14:52:00.000',0.34,'Alta','Placer'),
('2021-12-26 15:43:00.000',0.35,'Alta','Placer'),
('2021-12-26 17:31:00.000',5.24,'Alta','Placer'),
('2021-12-26 22:52:00.000',0.07,'Alta','Placer'),
('2021-12-26 23:15:00.000',0.52,'Alta','Placer'),
('2021-12-27 02:52:00.000',0.08,'Alta','Placer'),
('2021-12-27 03:52:00.000',0.14,'Alta','Placer'),
('2021-12-27 04:52:00.000',1.52,'Alta','Placer'),
('2021-12-27 14:37:00.000',0.89,'Alta','Placer'),
('2021-12-27 14:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
('2021-12-27 17:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
('2021-12-30 11:23:00.000',0.12,'Lebec','Los Angeles'),
('2021-12-30 11:43:00.000',0.98,'Lebec','Los Angeles'),
('2021-12-30 13:53:00.000',0.23,'Lebec','Los Angeles'),
('2021-12-30 14:53:00.000',0.13,'Lebec','Los Angeles'),
('2021-12-30 15:15:00.000',0.29,'Lebec','Los Angeles'),
('2021-12-30 17:53:00.000',0.10,'Lebec','Los Angeles'),
('2021-12-30 18:53:00.000',0.09,'Lebec','Los Angeles'),
('2021-12-30 19:53:00.000',0.07,'Lebec','Los Angeles'),
('2021-12-30 20:53:00.000',0.07,'Lebec','Los Angeles')
;

-- Example 604
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

-- Example 605
$ snowsql -a <account_identifier>

-- Example 606
$ snowsql -a <account_identifier> -u <user_login_name>

-- Example 607
Althea,Featherstone,afeatherstona@sf_tuts.com,"8172 Browning Street, Apt B",Calatrava,7/12/2017

-- Example 608
$ snowsql -a <account_identifier> -u <user_name>

-- Example 609
$ snowsql -a <account_identifier> -u <user_name> --authenticator externalbrowser

-- Example 610
user-name#(no warehouse)@(no database).(no schema)>

-- Example 611
CREATE OR REPLACE DATABASE sf_tuts;

-- Example 612
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();

