-- Example 8356
SELECT MONTH(sales_date) AS MONTH_NUM, 
       quantity, 
       SUM(quantity) OVER (ORDER BY MONTH(sales_date)
                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
           AS CUMULATIVE_SUM_QUANTITY
    FROM sales
    ORDER BY sales_date;

-- Example 8357
+-----------+----------+-------------------------+
| MONTH_NUM | QUANTITY | CUMULATIVE_SUM_QUANTITY |
|-----------+----------+-------------------------|
|         1 |        1 |                       1 |  -- sum = 1
|         1 |        3 |                       4 |  -- sum = 1 + 3
|         1 |        5 |                       9 |  -- sum = 1 + 3 + 5
|         2 |        2 |                      11 |  -- sum = 1 + 3 + 5 + 2
+-----------+----------+-------------------------+

-- Example 8358
SELECT AVG(price) OVER(ORDER BY timestamp1 ROWS BETWEEN 90 PRECEDING AND CURRENT ROW)
  FROM sales;

-- Example 8359
SELECT MONTH(sales_date) AS MONTH_NUM,
       quantity,
       SUM(quantity) OVER (ORDER BY sales_date
                           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
           AS SLIDING_SUM_QUANTITY
  FROM sales
  ORDER BY sales_date;

-- Example 8360
+-----------+----------+----------------------+
| MONTH_NUM | QUANTITY | SLIDING_SUM_QUANTITY |
|-----------+----------+----------------------+
|         1 |        1 |                   1  |  -- sum = 1
|         1 |        3 |                   4  |  -- sum = 1 + 3
|         1 |        5 |                   8  |  -- sum = 3 + 5 (1 is no longer in the window)
|         2 |        2 |                   7  |  -- sum = 5 + 2 (3 is no longer in the window)
+-----------+----------+----------------------+

-- Example 8361
SELECT MONTH(sales_date) AS MONTH_NUM,
       SUM(quantity) OVER (PARTITION BY MONTH(sales_date) ORDER BY sales_date)
          AS MONTHLY_CUMULATIVE_SUM_QUANTITY
    FROM sales
    ORDER BY sales_date;

-- Example 8362
+-----------+---------------------------------+
| MONTH_NUM | MONTHLY_CUMULATIVE_SUM_QUANTITY |
|-----------+---------------------------------+
|         1 |                               1 |  -- sum = 1
|         1 |                               4 |  -- sum = 1 + 3
|         1 |                               9 |  -- sum = 1 + 3 + 5
|         2 |                               2 |  -- sum = 0 + 2 (new month)
+-----------+---------------------------------+

-- Example 8363
SELECT
       MONTH(sales_date) AS MONTH_NUM,
       quantity,
       SUM(quantity) OVER (PARTITION BY MONTH(sales_date) 
                           ORDER BY sales_date
                           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
         AS MONTHLY_SLIDING_SUM_QUANTITY
    FROM sales
    ORDER BY sales_date;

-- Example 8364
+-----------+----------+------------------------------+
| MONTH_NUM | QUANTITY | MONTHLY_SLIDING_SUM_QUANTITY |
|-----------+----------+------------------------------+
|         1 |        1 |                           1  |  -- sum = 1
|         1 |        3 |                           4  |  -- sum = 1 + 3
|         1 |        5 |                           8  |  -- sum = 3 + 5
|         2 |        2 |                           2  |  -- sum = 0 + 2 (new month)
+-----------+----------+------------------------------+

-- Example 8365
SELECT branch_ID,
       city,
       100 * RATIO_TO_REPORT(net_profit) OVER (PARTITION BY city)
    FROM store_sales AS s1
    ORDER BY city, branch_ID;
+-----------+-----------+------------------------------------------------------------+
| BRANCH_ID | CITY      | 100 * RATIO_TO_REPORT(NET_PROFIT) OVER (PARTITION BY CITY) |
|-----------+-----------+------------------------------------------------------------|
|         3 | Montreal  |                                                52.63157900 |
|         4 | Montreal  |                                                47.36842100 |
|         1 | Vancouver |                                                40.00000000 |
|         2 | Vancouver |                                                60.00000000 |
+-----------+-----------+------------------------------------------------------------+

-- Example 8366
SELECT branch_ID,
       100 * RATIO_TO_REPORT(net_profit) OVER ()
    FROM store_sales AS s1
    ORDER BY branch_ID;
+-----------+-------------------------------------------+
| BRANCH_ID | 100 * RATIO_TO_REPORT(NET_PROFIT) OVER () |
|-----------+-------------------------------------------|
|         1 |                               22.72727300 |
|         2 |                               34.09090900 |
|         3 |                               22.72727300 |
|         4 |                               20.45454500 |
+-----------+-------------------------------------------+

-- Example 8367
SELECT menu_category,
    AVG(menu_cogs_usd) avg_cogs
  FROM menu_items
  GROUP BY 1
  ORDER BY menu_category;

-- Example 8368
+---------------+------------+
| MENU_CATEGORY |   AVG_COGS |
|---------------+------------|
| Beverage      | 0.60000000 |
| Dessert       | 1.79166667 |
| Main          | 6.11046512 |
| Snack         | 3.10000000 |
+---------------+------------+

-- Example 8369
SELECT menu_category,
    AVG(menu_cogs_usd) OVER(PARTITION BY menu_category) avg_cogs
  FROM menu_items
  ORDER BY menu_category
  LIMIT 15;

-- Example 8370
+---------------+----------+
| MENU_CATEGORY | AVG_COGS |
|---------------+----------|
| Beverage      |  0.60000 |
| Beverage      |  0.60000 |
| Beverage      |  0.60000 |
| Beverage      |  0.60000 |
| Dessert       |  1.79166 |
| Dessert       |  1.79166 |
| Dessert       |  1.79166 |
| Dessert       |  1.79166 |
| Dessert       |  1.79166 |
| Dessert       |  1.79166 |
| Main          |  6.11046 |
| Main          |  6.11046 |
| Main          |  6.11046 |
| Main          |  6.11046 |
| Main          |  6.11046 |
+---------------+----------+

-- Example 8371
SELECT menu_category, menu_price_usd, menu_cogs_usd,
    AVG(menu_cogs_usd) OVER(PARTITION BY menu_category ORDER BY menu_price_usd ROWS BETWEEN CURRENT ROW and 2 FOLLOWING) avg_cogs
  FROM menu_items
  ORDER BY menu_category, menu_price_usd
  LIMIT 15;

-- Example 8372
+---------------+----------------+---------------+----------+
| MENU_CATEGORY | MENU_PRICE_USD | MENU_COGS_USD | AVG_COGS |
|---------------+----------------+---------------+----------|
| Beverage      |           2.00 |          0.50 |  0.58333 |
| Beverage      |           3.00 |          0.50 |  0.57500 |
| Beverage      |           3.00 |          0.75 |  0.63333 |
| Beverage      |           3.50 |          0.65 |  0.65000 |
| Dessert       |           3.00 |          0.50 |  0.91666 |
| Dessert       |           4.00 |          1.00 |  1.58333 |
| Dessert       |           5.00 |          1.25 |  2.08333 |
| Dessert       |           6.00 |          2.50 |  2.66666 |
| Dessert       |           6.00 |          2.50 |  2.75000 |
| Dessert       |           7.00 |          3.00 |  3.00000 |
| Main          |           5.00 |          1.50 |  2.03333 |
| Main          |           6.00 |          2.60 |  3.00000 |
| Main          |           6.00 |          2.00 |  2.33333 |
| Main          |           6.00 |          2.40 |  3.13333 |
| Main          |           8.00 |          4.00 |  3.66666 |
+---------------+----------------+---------------+----------+

-- Example 8373
CREATE OR REPLACE TABLE heavy_weather
  (start_time TIMESTAMP, precip NUMBER(3,2), city VARCHAR(20), county VARCHAR(20));

-- Example 8374
+-------------------------+--------+-------+-------------+
| START_TIME              | PRECIP | CITY  | COUNTY      |
|-------------------------+--------+-------+-------------|
| 2021-12-30 11:23:00.000 |   0.12 | Lebec | Los Angeles |
| 2021-12-30 11:43:00.000 |   0.98 | Lebec | Los Angeles |
| 2021-12-30 13:53:00.000 |   0.23 | Lebec | Los Angeles |
| 2021-12-30 14:53:00.000 |   0.13 | Lebec | Los Angeles |
| 2021-12-30 15:15:00.000 |   0.29 | Lebec | Los Angeles |
| 2021-12-30 17:53:00.000 |   0.10 | Lebec | Los Angeles |
| 2021-12-30 18:53:00.000 |   0.09 | Lebec | Los Angeles |
| 2021-12-30 19:53:00.000 |   0.07 | Lebec | Los Angeles |
| 2021-12-30 20:53:00.000 |   0.07 | Lebec | Los Angeles |
+-------------------------+--------+-------+-------------+

-- Example 8375
AVG(precip)
  OVER(ORDER BY start_time
    RANGE BETWEEN CURRENT ROW AND INTERVAL '3 hours' FOLLOWING)

-- Example 8376
RANGE BETWEEN CURRENT ROW AND INTERVAL '1 day' FOLLOWING

-- Example 8377
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- Example 8378
SELECT menu_category, menu_price_usd,
    SUM(menu_price_usd)
      OVER(PARTITION BY menu_category ORDER BY menu_price_usd
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_price
  FROM menu_items
  WHERE menu_category IN('Beverage','Dessert','Snack')
  ORDER BY menu_category, menu_price_usd;

-- Example 8379
+---------------+----------------+-----------+
| MENU_CATEGORY | MENU_PRICE_USD | SUM_PRICE |
|---------------+----------------+-----------|
| Beverage      |           2.00 |      2.00 |
| Beverage      |           3.00 |      5.00 |
| Beverage      |           3.00 |      8.00 |
| Beverage      |           3.50 |     11.50 |
| Dessert       |           3.00 |      3.00 |
| Dessert       |           4.00 |      7.00 |
| Dessert       |           5.00 |     12.00 |
| Dessert       |           6.00 |     18.00 |
| Dessert       |           6.00 |     24.00 |
| Dessert       |           7.00 |     31.00 |
| Snack         |           6.00 |      6.00 |
| Snack         |           6.00 |     12.00 |
| Snack         |           7.00 |     19.00 |
| Snack         |           9.00 |     28.00 |
| Snack         |          11.00 |     39.00 |
+---------------+----------------+-----------+

-- Example 8380
SELECT menu_category, menu_price_usd,
    SUM(menu_price_usd)
      OVER(PARTITION BY menu_category ORDER BY menu_price_usd
      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_price
  FROM menu_items
  WHERE menu_category IN('Beverage','Dessert','Snack')
  ORDER BY menu_category, menu_price_usd;

-- Example 8381
+---------------+----------------+-----------+
| MENU_CATEGORY | MENU_PRICE_USD | SUM_PRICE |
|---------------+----------------+-----------|
| Beverage      |           2.00 |      2.00 |
| Beverage      |           3.00 |      8.00 |
| Beverage      |           3.00 |      8.00 |
| Beverage      |           3.50 |     11.50 |
| Dessert       |           3.00 |      3.00 |
| Dessert       |           4.00 |      7.00 |
| Dessert       |           5.00 |     12.00 |
| Dessert       |           6.00 |     24.00 |
| Dessert       |           6.00 |     24.00 |
| Dessert       |           7.00 |     31.00 |
| Snack         |           6.00 |     12.00 |
| Snack         |           6.00 |     12.00 |
| Snack         |           7.00 |     19.00 |
| Snack         |           9.00 |     28.00 |
| Snack         |          11.00 |     39.00 |
+---------------+----------------+-----------+

-- Example 8382
OVER(PARTITION BY col1 ORDER BY col2 ROWS UNBOUNDED PRECEDING)

-- Example 8383
OVER(PARTITION BY col1 ORDER BY col2 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

-- Example 8384
OVER(PARTITION BY col1 ORDER BY col2 ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING)

-- Example 8385
OVER(PARTITION BY col1 ORDER BY col2 ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)

-- Example 8386
+--------+-------+---------------+
| Day of | Sales | Most Recent   |
| Month  | Today | 3 Days' Sales |
|--------+-------+---------------+
|      1 |    10 |            10 |
|      2 |    11 |            21 |
|      3 |    12 |            33 |
|      4 |    13 |            36 |
|      5 |    14 |            39 |
|    ... |   ... |           ... |
+--------+-------+---------------+

-- Example 8387
+-------------+-------------+------+
| Salesperson | Amount Sold | Rank |
|-------------+-------------+------|
| Smith       |        2000 |    1 |
| Jones       |        1500 |    2 |
| Torkelson   |        1200 |    3 |
| Dolenz      |        1100 |    4 |
+-------------+-------------+------+

-- Example 8388
SELECT city, branch_ID, net_profit,
       RANK() OVER (PARTITION BY city ORDER BY net_profit DESC) AS rank
    FROM store_sales
    ORDER BY city, rank;
+-----------+-----------+------------+------+
| CITY      | BRANCH_ID | NET_PROFIT | RANK |
|-----------+-----------+------------+------|
| Montreal  |         3 |   10000.00 |    1 |
| Montreal  |         4 |    9000.00 |    2 |
| Vancouver |         2 |   15000.00 |    1 |
| Vancouver |         1 |   10000.00 |    2 |
+-----------+-----------+------------+------+

-- Example 8389
SELECT
    branch_ID,
    net_profit,
    RANK() OVER (ORDER BY net_profit DESC) AS sales_rank
  FROM store_sales

-- Example 8390
SELECT
    branch_ID,
    net_profit,
    RANK() OVER (ORDER BY net_profit DESC) AS sales_rank
  FROM store_sales
  ORDER BY branch_ID;

-- Example 8391
+--------+-------+------+--------------+-------------+--------------+
| Day of | Sales | Rank | Sales So Far | Total Sales | 3-Day Moving |
| Week   | Today |      | This Week    | This Week   | Average      |
|--------+-------+------+--------------+-------------|--------------+
|      1 |    10 |    4 |           10 |          84 |         10.0 |
|      2 |    14 |    3 |           24 |          84 |         12.0 |
|      3 |     6 |    5 |           30 |          84 |         10.0 |
|      4 |     6 |    5 |           36 |          84 |          9.0 |
|      5 |    14 |    3 |           50 |          84 |         10.0 |
|      6 |    16 |    2 |           66 |          84 |         11.0 |
|      7 |    18 |    1 |           84 |          84 |         12.0 |
+--------+-------+------+--------------+-------------+--------------+

-- Example 8392
... WHERE date >= start_of_relevant_week and date <= end_of_relevant_week ...

-- Example 8393
CREATE TABLE store_sales_2 (
    day INTEGER,
    sales_today INTEGER
    );
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| Table STORE_SALES_2 successfully created. |
+-------------------------------------------+
INSERT INTO store_sales_2 (day, sales_today) VALUES
    (1, 10),
    (2, 14),
    (3,  6),
    (4,  6),
    (5, 14),
    (6, 16),
    (7, 18);
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       7 |
+-------------------------+

-- Example 8394
SELECT day, 
       sales_today, 
       RANK()
           OVER (ORDER BY sales_today DESC) AS Rank
    FROM store_sales_2
    ORDER BY day;
+-----+-------------+------+
| DAY | SALES_TODAY | RANK |
|-----+-------------+------|
|   1 |          10 |    5 |
|   2 |          14 |    3 |
|   3 |           6 |    6 |
|   4 |           6 |    6 |
|   5 |          14 |    3 |
|   6 |          16 |    2 |
|   7 |          18 |    1 |
+-----+-------------+------+

-- Example 8395
SELECT day, 
       sales_today, 
       SUM(sales_today)
           OVER (ORDER BY day
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
               AS "SALES SO FAR THIS WEEK"
    FROM store_sales_2
    ORDER BY day;
+-----+-------------+------------------------+
| DAY | SALES_TODAY | SALES SO FAR THIS WEEK |
|-----+-------------+------------------------|
|   1 |          10 |                     10 |
|   2 |          14 |                     24 |
|   3 |           6 |                     30 |
|   4 |           6 |                     36 |
|   5 |          14 |                     50 |
|   6 |          16 |                     66 |
|   7 |          18 |                     84 |
+-----+-------------+------------------------+

-- Example 8396
SELECT day, 
       sales_today, 
       SUM(sales_today)
           OVER ()
               AS total_sales
    FROM store_sales_2
    ORDER BY day;
+-----+-------------+-------------+
| DAY | SALES_TODAY | TOTAL_SALES |
|-----+-------------+-------------|
|   1 |          10 |          84 |
|   2 |          14 |          84 |
|   3 |           6 |          84 |
|   4 |           6 |          84 |
|   5 |          14 |          84 |
|   6 |          16 |          84 |
|   7 |          18 |          84 |
+-----+-------------+-------------+

-- Example 8397
SELECT day, 
       sales_today, 
       AVG(sales_today)
           OVER (ORDER BY day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
               AS "3-DAY MOVING AVERAGE"
    FROM store_sales_2
    ORDER BY day;
+-----+-------------+----------------------+
| DAY | SALES_TODAY | 3-DAY MOVING AVERAGE |
|-----+-------------+----------------------|
|   1 |          10 |               10.000 |
|   2 |          14 |               12.000 |
|   3 |           6 |               10.000 |
|   4 |           6 |                8.666 |
|   5 |          14 |                8.666 |
|   6 |          16 |               12.000 |
|   7 |          18 |               16.000 |
+-----+-------------+----------------------+

-- Example 8398
SELECT day, 
       sales_today, 
       RANK()
           OVER (ORDER BY sales_today DESC) AS Rank,
       SUM(sales_today)
           OVER (ORDER BY day
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
               AS "SALES SO FAR THIS WEEK",
       SUM(sales_today)
           OVER ()
               AS total_sales,
       AVG(sales_today)
           OVER (ORDER BY day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
               AS "3-DAY MOVING AVERAGE"
    FROM store_sales_2
    ORDER BY day;
+-----+-------------+------+------------------------+-------------+----------------------+
| DAY | SALES_TODAY | RANK | SALES SO FAR THIS WEEK | TOTAL_SALES | 3-DAY MOVING AVERAGE |
|-----+-------------+------+------------------------+-------------+----------------------|
|   1 |          10 |    5 |                     10 |          84 |               10.000 |
|   2 |          14 |    3 |                     24 |          84 |               12.000 |
|   3 |           6 |    6 |                     30 |          84 |               10.000 |
|   4 |           6 |    6 |                     36 |          84 |                8.666 |
|   5 |          14 |    3 |                     50 |          84 |                8.666 |
|   6 |          16 |    2 |                     66 |          84 |               12.000 |
|   7 |          18 |    1 |                     84 |          84 |               16.000 |
+-----+-------------+------+------------------------+-------------+----------------------+

-- Example 8399
CREATE TABLE sales (sales_date DATE, quantity INTEGER);

INSERT INTO sales (sales_date, quantity) VALUES
    ('2018-01-01', 1),
    ('2018-01-02', 3),
    ('2018-01-03', 5),
    ('2018-02-01', 2)
    ;

-- Example 8400
SELECT MONTH(sales_date) AS MONTH_NUM, 
       quantity, 
       SUM(quantity) OVER (ORDER BY MONTH(sales_date)
                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
           AS CUMULATIVE_SUM_QUANTITY
    FROM sales
    ORDER BY sales_date;

-- Example 8401
+-----------+----------+-------------------------+
| MONTH_NUM | QUANTITY | CUMULATIVE_SUM_QUANTITY |
|-----------+----------+-------------------------|
|         1 |        1 |                       1 |  -- sum = 1
|         1 |        3 |                       4 |  -- sum = 1 + 3
|         1 |        5 |                       9 |  -- sum = 1 + 3 + 5
|         2 |        2 |                      11 |  -- sum = 1 + 3 + 5 + 2
+-----------+----------+-------------------------+

-- Example 8402
SELECT AVG(price) OVER(ORDER BY timestamp1 ROWS BETWEEN 90 PRECEDING AND CURRENT ROW)
  FROM sales;

-- Example 8403
SELECT MONTH(sales_date) AS MONTH_NUM,
       quantity,
       SUM(quantity) OVER (ORDER BY sales_date
                           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
           AS SLIDING_SUM_QUANTITY
  FROM sales
  ORDER BY sales_date;

-- Example 8404
+-----------+----------+----------------------+
| MONTH_NUM | QUANTITY | SLIDING_SUM_QUANTITY |
|-----------+----------+----------------------+
|         1 |        1 |                   1  |  -- sum = 1
|         1 |        3 |                   4  |  -- sum = 1 + 3
|         1 |        5 |                   8  |  -- sum = 3 + 5 (1 is no longer in the window)
|         2 |        2 |                   7  |  -- sum = 5 + 2 (3 is no longer in the window)
+-----------+----------+----------------------+

-- Example 8405
SELECT MONTH(sales_date) AS MONTH_NUM,
       SUM(quantity) OVER (PARTITION BY MONTH(sales_date) ORDER BY sales_date)
          AS MONTHLY_CUMULATIVE_SUM_QUANTITY
    FROM sales
    ORDER BY sales_date;

-- Example 8406
+-----------+---------------------------------+
| MONTH_NUM | MONTHLY_CUMULATIVE_SUM_QUANTITY |
|-----------+---------------------------------+
|         1 |                               1 |  -- sum = 1
|         1 |                               4 |  -- sum = 1 + 3
|         1 |                               9 |  -- sum = 1 + 3 + 5
|         2 |                               2 |  -- sum = 0 + 2 (new month)
+-----------+---------------------------------+

-- Example 8407
SELECT
       MONTH(sales_date) AS MONTH_NUM,
       quantity,
       SUM(quantity) OVER (PARTITION BY MONTH(sales_date) 
                           ORDER BY sales_date
                           ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
         AS MONTHLY_SLIDING_SUM_QUANTITY
    FROM sales
    ORDER BY sales_date;

-- Example 8408
+-----------+----------+------------------------------+
| MONTH_NUM | QUANTITY | MONTHLY_SLIDING_SUM_QUANTITY |
|-----------+----------+------------------------------+
|         1 |        1 |                           1  |  -- sum = 1
|         1 |        3 |                           4  |  -- sum = 1 + 3
|         1 |        5 |                           8  |  -- sum = 3 + 5
|         2 |        2 |                           2  |  -- sum = 0 + 2 (new month)
+-----------+----------+------------------------------+

-- Example 8409
SELECT branch_ID,
       city,
       100 * RATIO_TO_REPORT(net_profit) OVER (PARTITION BY city)
    FROM store_sales AS s1
    ORDER BY city, branch_ID;
+-----------+-----------+------------------------------------------------------------+
| BRANCH_ID | CITY      | 100 * RATIO_TO_REPORT(NET_PROFIT) OVER (PARTITION BY CITY) |
|-----------+-----------+------------------------------------------------------------|
|         3 | Montreal  |                                                52.63157900 |
|         4 | Montreal  |                                                47.36842100 |
|         1 | Vancouver |                                                40.00000000 |
|         2 | Vancouver |                                                60.00000000 |
+-----------+-----------+------------------------------------------------------------+

-- Example 8410
SELECT branch_ID,
       100 * RATIO_TO_REPORT(net_profit) OVER ()
    FROM store_sales AS s1
    ORDER BY branch_ID;
+-----------+-------------------------------------------+
| BRANCH_ID | 100 * RATIO_TO_REPORT(NET_PROFIT) OVER () |
|-----------+-------------------------------------------|
|         1 |                               22.72727300 |
|         2 |                               34.09090900 |
|         3 |                               22.72727300 |
|         4 |                               20.45454500 |
+-----------+-------------------------------------------+

-- Example 8411
{ STDDEV | STDDEV_SAMP } ( [ DISTINCT ] <expr1> )

-- Example 8412
{ STDDEV | STDDEV_SAMP } ( [ DISTINCT ] <expr1> ) OVER (
                                                       [ PARTITION BY <expr2> ]
                                                       [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                                       )

-- Example 8413
CREATE TABLE t1 (c1 INTEGER);
INSERT INTO t1 (c1) VALUES
    (6),
   (10),
   (14)
   ;
SELECT STDDEV(c1) FROM t1;

-- Example 8414
+----------+
| STDDEV() |
|----------|
|        4 |
+----------+

-- Example 8415
SELECT STDDEV_SAMP(c1) FROM t1;

-- Example 8416
+-----------------+
| STDDEV_SAMP(C1) |
|-----------------|
|               4 |
+-----------------+

-- Example 8417
SELECT menu_category, STDDEV(menu_cogs_usd) stddev_cogs, STDDEV(menu_price_usd) stddev_price
  FROM menu_items
  WHERE menu_category='Dessert'
  GROUP BY 1;

-- Example 8418
+---------------+-------------+--------------+
| MENU_CATEGORY | STDDEV_COGS | STDDEV_PRICE |
|---------------+-------------+--------------|
| Dessert       |  1.00519484 |  1.471960144 |
+---------------+-------------+--------------+

-- Example 8419
SELECT menu_category, menu_cogs_usd,
    STDDEV(menu_cogs_usd) OVER(PARTITION BY menu_category) stddev_cogs
  FROM menu_items
  GROUP BY 1,2
  ORDER BY menu_category;

-- Example 8420
+---------------+---------------+--------------+
| MENU_CATEGORY | MENU_COGS_USD |  STDDEV_COGS |
|---------------+---------------+--------------|
| Beverage      |          0.50 | 0.1258305738 |
| Beverage      |          0.65 | 0.1258305738 |
| Beverage      |          0.75 | 0.1258305738 |
| Dessert       |          1.25 | 1.054751155  |
| Dessert       |          3.00 | 1.054751155  |
| Dessert       |          1.00 | 1.054751155  |
| Dessert       |          2.50 | 1.054751155  |
| Dessert       |          0.50 | 1.054751155  |
| Main          |          4.50 | 3.444051572  |
| Main          |          2.40 | 3.444051572  |
| Main          |          1.50 | 3.444051572  |
| Main          |         11.00 | 3.444051572  |
| Main          |          8.00 | 3.444051572  |
| Main          |          NULL | 3.444051572  |
| Main          |         12.00 | 3.444051572  |
...

-- Example 8421
CREATE OR REPLACE TABLE menu_items(
  menu_id INT NOT NULL,
  menu_category VARCHAR(20),
  menu_item_name VARCHAR(50),
  menu_cogs_usd NUMBER(7,2),
  menu_price_usd NUMBER(7,2));

-- Example 8422
INSERT INTO menu_items VALUES(1,'Beverage','Bottled Soda',0.500,3.00);
INSERT INTO menu_items VALUES(2,'Beverage','Bottled Water',0.500,2.00);
INSERT INTO menu_items VALUES(3,'Main','Breakfast Crepe',5.00,12.00);
INSERT INTO menu_items VALUES(4,'Main','Buffalo Mac & Cheese',6.00,10.00);
INSERT INTO menu_items VALUES(5,'Main','Chicago Dog',4.00,9.00);
INSERT INTO menu_items VALUES(6,'Main','Chicken Burrito',3.2500,12.500);
INSERT INTO menu_items VALUES(7,'Main','Chicken Pot Pie Crepe',6.00,15.00);
INSERT INTO menu_items VALUES(8,'Main','Combination Curry',9.00,15.00);
INSERT INTO menu_items VALUES(9,'Main','Combo Fried Rice',5.00,11.00);
INSERT INTO menu_items VALUES(10,'Main','Combo Lo Mein',6.00,13.00);
INSERT INTO menu_items VALUES(11,'Main','Coney Dog',5.00,10.00);
INSERT INTO menu_items VALUES(12,'Main','Creamy Chicken Ramen',8.00,17.2500);
INSERT INTO menu_items VALUES(13,'Snack','Crepe Suzette',4.00,9.00);
INSERT INTO menu_items VALUES(14,'Main','Fish Burrito',3.7500,12.500);
INSERT INTO menu_items VALUES(15,'Snack','Fried Pickles',1.2500,6.00);
INSERT INTO menu_items VALUES(16,'Snack','Greek Salad',4.00,11.00);
INSERT INTO menu_items VALUES(17,'Main','Gyro Plate',8.00,12.00);
INSERT INTO menu_items VALUES(18,'Main','Hot Ham & Cheese',7.00,11.00);
INSERT INTO menu_items VALUES(19,'Dessert','Ice Cream Sandwich',1.00,4.00);
INSERT INTO menu_items VALUES(20,'Beverage','Iced Tea',0.7500,3.00);
INSERT INTO menu_items VALUES(21,'Main','Italian',6.00,11.00);
INSERT INTO menu_items VALUES(22,'Main','Lean Beef Tibs',6.00,13.00);
INSERT INTO menu_items VALUES(23,'Main','Lean Burrito Bowl',3.500,12.500);
INSERT INTO menu_items VALUES(24,'Main','Lean Chicken Tibs',5.00,11.00);
INSERT INTO menu_items VALUES(25,'Main','Lean Chicken Tikka Masala',10.00,17.00);
INSERT INTO menu_items VALUES(26,'Beverage','Lemonade',0.6500,3.500);
INSERT INTO menu_items VALUES(27,'Main','Lobster Mac & Cheese',10.00,15.00);
INSERT INTO menu_items VALUES(28,'Dessert','Mango Sticky Rice',1.2500,5.00);
INSERT INTO menu_items VALUES(29,'Main','Miss Piggie',2.600,6.00);
INSERT INTO menu_items VALUES(30,'Main','Mothers Favorite',4.500,12.00);
INSERT INTO menu_items VALUES(31,'Main','New York Dog',4.00,8.00);
INSERT INTO menu_items VALUES(32,'Main','Pastrami',8.00,11.00);
INSERT INTO menu_items VALUES(33,'Dessert','Popsicle',0.500,3.00);
INSERT INTO menu_items VALUES(34,'Main','Pulled Pork Sandwich',7.00,12.00);
INSERT INTO menu_items VALUES(35,'Main','Rack of Pork Ribs',11.2500,21.00);
INSERT INTO menu_items VALUES(36,'Snack','Seitan Buffalo Wings',4.00,7.00);
INSERT INTO menu_items VALUES(37,'Main','Spicy Miso Vegetable Ramen',7.00,17.2500);
INSERT INTO menu_items VALUES(38,'Snack','Spring Mix Salad',2.2500,6.00);
INSERT INTO menu_items VALUES(39,'Main','Standard Mac & Cheese',3.00,8.00);
INSERT INTO menu_items VALUES(40,'Dessert','Sugar Cone',2.500,6.00);
INSERT INTO menu_items VALUES(41,'Main','Tandoori Mixed Grill',11.00,18.00);
INSERT INTO menu_items VALUES(42,'Main','The Classic',4.00,12.00);
INSERT INTO menu_items VALUES(43,'Main','The King Combo',12.00,20.00);
INSERT INTO menu_items VALUES(44,'Main','The Kitchen Sink',6.00,14.00);
INSERT INTO menu_items VALUES(45,'Main','The Original',1.500,5.00);
INSERT INTO menu_items VALUES(46,'Main','The Ranch',2.400,6.00);
INSERT INTO menu_items VALUES(47,'Main','The Salad of All Salads',6.00,12.00);
INSERT INTO menu_items VALUES(48,'Main','Three Meat Plate',10.00,17.00);
INSERT INTO menu_items VALUES(49,'Main','Three Taco Combo Plate',7.00,11.00);
INSERT INTO menu_items VALUES(50,'Main','Tonkotsu Ramen',7.00,17.2500);
INSERT INTO menu_items VALUES(51,'Main','Two Meat Plate',9.00,14.00);
INSERT INTO menu_items VALUES(52,'Dessert','Two Scoop Bowl',3.00,7.00);
INSERT INTO menu_items VALUES(53,'Main','Two Taco Combo Plate',6.00,9.00);
INSERT INTO menu_items VALUES(54,'Main','Veggie Burger',5.00,9.00);
INSERT INTO menu_items VALUES(55,'Main','Veggie Combo',4.00,9.00);
INSERT INTO menu_items VALUES(56,'Main','Veggie Taco Bowl',6.00,10.00);
INSERT INTO menu_items VALUES(57,'Dessert','Waffle Cone',2.500,6.00);
INSERT INTO menu_items VALUES(58,'Main','Wonton Soup',2.00,6.00);
INSERT INTO menu_items VALUES(59,'Main','Mini Pizza',null,null);
INSERT INTO menu_items VALUES(60,'Main','Large Pizza',null,null);

