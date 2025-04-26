-- Example 8289
CALL <procedure_name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 8290
CALL stproc1(5.14::FLOAT);

-- Example 8291
CALL stproc1(2 * 5.14::FLOAT);

-- Example 8292
CALL stproc1(SELECT COUNT(*) FROM stproc_test_table1);

-- Example 8293
CALL proc1(1), proc2(2);                          -- Not allowed

-- Example 8294
CALL proc1(1) + proc1(2);                         -- Not allowed
CALL proc1(1) + 1;                                -- Not allowed
CALL proc1(proc2(x));                             -- Not allowed
SELECT * FROM (call proc1(1));                    -- Not allowed

-- Example 8295
CALL sv_proc1('Manitoba', 127.4);

-- Example 8296
CALL sv_proc1(province => 'Manitoba', amount => 127.4);

-- Example 8297
SET Variable1 = 49;
CALL sv_proc2($Variable1);

-- Example 8298
DECLARE
  ret1 NUMBER;
BEGIN
  CALL sv_proc1('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;

-- Example 8299
EXECUTE IMMEDIATE $$
DECLARE
  ret1 NUMBER;
BEGIN
  CALL sv_proc1('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
$$
;

-- Example 8300
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
    WHERE TAG_NAME = 'PRIVACY_CATEGORY'
    ORDER BY OBJECT_DATABASE, OBJECT_SCHEMA, OBJECT_NAME, COLUMN_NAME;

-- Example 8301
SELECT * FROM
  TABLE(
    MY_DB.INFORMATION_SCHEMA.TAG_REFERENCES(
      'my_db.my_schema.hr_data.fname',
      'COLUMN'
    ));

-- Example 8302
SELECT * from
  TABLE(
    MY_DB.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
      'my_db.my_schema.hr_data',
      'table'
    ));

-- Example 8303
SELECT SYSTEM$GET_TAG(
  'SNOWFLAKE.CORE.PRIVACY_CATEGORY',
  'hr_data.fname',
  'COLUMN'
  );

-- Example 8304
'datasets':[
  {
    'input_table': 'd.s.orders',
    'output_table': 'd.s.orders_synth',
    'columns': {'cust_id': {'join_key': True, 'replace': 'uuid'}, ...}
  },
  {
    'input_table': 'd.s.customers',
    'output_table': 'd.s.customers_synth',
    'columns' : {'cust_id': {'join_key': True, 'replace':'uuid'}, ...}

  }
]

-- Example 8305
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.PATIENTS1',
        'output_table': 'MY_DB.PUBLIC.PATIENTS1',
        'columns': { 'patient_id': {'join_key': TRUE}, 'age':{'join_key': TRUE}}
      },
      {
        'input_table': 'CLINICAL_DB.PUBLIC.PATIENTS2',
        'output_table': 'MY_DB.PUBLIC.PATIENTS2',
        'columns': { 'patient_id': {'join_key': TRUE}, 'age':{'join_key': TRUE}}
      }
    ],
    'replace_output_tables': TRUE
});

-- Example 8306
-- Generate consistent join keys across multiple runs by
-- providing a symmetric key secret.
CREATE OR REPLACE SECRET my_db.public.my_consistency_secret
  TYPE=SYMMETRIC_KEY
  ALGORITHM=GENERIC;

CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.BASE_TABLE',
        'output_table': 'MY_DB.PUBLIC.PATIENTS1',
        'columns': { 'patient_id': {'join_key': TRUE}}
      }
    ],
    'consistency_secret': SYSTEM$REFERENCE('SECRET', 'MY_CONSISTENCY_SECRET', 'SESSION', 'READ')::STRING,
    'replace_output_tables': TRUE
});

CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.SECOND_TABLE',
        'output_table': 'MY_DB.PUBLIC.PATIENTS2',
        'columns': { 'patient_id': {'join_key': TRUE}}
      }
    ],
    'consistency_secret': SYSTEM$REFERENCE('SECRET', 'MY_CONSISTENCY_SECRET', 'SESSION', 'READ')::STRING,
    'replace_output_tables': TRUE
});

-- Example 8307
USE ROLE ACCOUNTADMIN;
CREATE or REPLACE DATABASE SNOWFLAKE_SAMPLE_DATA from share SFC_SAMPLES.SAMPLE_DATA;

-- Example 8308
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE ROLE data_engineer;
CREATE OR REPLACE DATABASE syndata_db;
CREATE OR REPLACE WAREHOUSE syndata_wh;

GRANT OWNERSHIP ON DATABASE syndata_db TO ROLE data_engineer;
GRANT USAGE ON WAREHOUSE syndata_wh TO ROLE data_engineer;
GRANT ROLE data_engineer TO USER jsmith; -- Or whoever you want to run this example. Or skip this line to run it yourself.

-- Example 8309
- Sign in as user with data_engineer role. Then...
CREATE SCHEMA syndata_db.sch;
CREATE OR REPLACE VIEW syndata_db.sch.TPC_ORDERS_5K as (
    SELECT * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
    LIMIT 5000
);
CREATE OR REPLACE VIEW syndata_db.sch.TPC_CUSTOMERS_5K as (
    SELECT * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
    LIMIT 5000
);

-- Example 8310
USE WAREHOUSE syndata_wh;
SELECT TOP 20 * FROM syndata_db.sch.TPC_ORDERS_5K;
SELECT COUNT(*) FROM syndata_db.sch.TPC_ORDERS_5K;
select count(distinct o_clerk), count(*) from syndata_db.sch.TPC_ORDERS_5K;

SELECT TOP 20 * FROM syndata_db.sch.TPC_CUSTOMERS_5K;
SELECT COUNT(*) FROM syndata_db.sch.TPC_CUSTOMERS_5K;

-- Example 8311
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
    'datasets':[
        {
          'input_table': 'syndata_db.sch.TPC_ORDERS_5K',
          'output_table': 'syndata_db.sch.TPC_ORDERS_5K_SYNTHETIC',
          'columns': {'O_CUSTKEY': {'join_key': True}}
        },
        {
          'input_table': 'syndata_db.sch.TPC_CUSTOMERS_5K',
          'output_table': 'syndata_db.sch.TPC_CUSTOMERS_5K_SYNTHETIC',
          'columns' : {'C_CUSTKEY': {'join_key': True}}

        }
      ],
      'replace_output_tables':True
  });

-- Example 8312
SELECT TOP 20 * FROM syndata_db.sch.TPC_ORDERS_5K_SYNTHETIC;
SELECT COUNT(*) FROM syndata_db.sch.TPC_ORDERS_5K_SYNTHETIC;

SELECT TOP 20 * FROM syndata_db.sch.TPC_CUSTOMERS_5K_SYNTHETIC;
SELECT COUNT(*) FROM syndata_db.sch.TPC_CUSTOMERS_5K_SYNTHETIC;

-- Example 8313
USE ROLE ACCOUNTADMIN;
DROP DATABASE syndata_db;
DROP ROLE data_engineer;
DROP WAREHOUSE syndata_wh;

-- Example 8314
GRANT APPLICATION ROLE SNOWFLAKE.EVENTS_ADMIN TO ROLE my_admin_role

GRANT APPLICATION ROLE SNOWFLAKE.EVENTS_VIEWER TO ROLE my_analysis_role

-- Example 8315
CREATE EVENT TABLE my_database.my_schema.my_events;

-- Example 8316
ALTER DATABASE my_database SET EVENT_TABLE = my_database.my_schema.my_events;

-- Example 8317
ALTER ACCOUNT SET EVENT_TABLE = my_database.my_schema.my_events;

-- Example 8318
ALTER ACCOUNT UNSET EVENT_TABLE;

-- Example 8319
SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;

-- Example 8320
ALTER DATABASE my_database SET EVENT_TABLE = my_database.my_schema.my_events;

-- Example 8321
ALTER DATABASE my_database UNSET EVENT_TABLE;

-- Example 8322
SHOW PARAMETERS LIKE 'event_table' IN DATABASE my_database;

-- Example 8323
SELECT menu_category,
    AVG(menu_cogs_usd) avg_cogs
  FROM menu_items
  GROUP BY 1
  ORDER BY menu_category;

-- Example 8324
+---------------+------------+
| MENU_CATEGORY |   AVG_COGS |
|---------------+------------|
| Beverage      | 0.60000000 |
| Dessert       | 1.79166667 |
| Main          | 6.11046512 |
| Snack         | 3.10000000 |
+---------------+------------+

-- Example 8325
SELECT menu_category,
    AVG(menu_cogs_usd) OVER(PARTITION BY menu_category) avg_cogs
  FROM menu_items
  ORDER BY menu_category
  LIMIT 15;

-- Example 8326
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

-- Example 8327
SELECT menu_category, menu_price_usd, menu_cogs_usd,
    AVG(menu_cogs_usd) OVER(PARTITION BY menu_category ORDER BY menu_price_usd ROWS BETWEEN CURRENT ROW and 2 FOLLOWING) avg_cogs
  FROM menu_items
  ORDER BY menu_category, menu_price_usd
  LIMIT 15;

-- Example 8328
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

-- Example 8329
CREATE OR REPLACE TABLE heavy_weather
  (start_time TIMESTAMP, precip NUMBER(3,2), city VARCHAR(20), county VARCHAR(20));

-- Example 8330
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

-- Example 8331
AVG(precip)
  OVER(ORDER BY start_time
    RANGE BETWEEN CURRENT ROW AND INTERVAL '3 hours' FOLLOWING)

-- Example 8332
RANGE BETWEEN CURRENT ROW AND INTERVAL '1 day' FOLLOWING

-- Example 8333
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- Example 8334
SELECT menu_category, menu_price_usd,
    SUM(menu_price_usd)
      OVER(PARTITION BY menu_category ORDER BY menu_price_usd
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_price
  FROM menu_items
  WHERE menu_category IN('Beverage','Dessert','Snack')
  ORDER BY menu_category, menu_price_usd;

-- Example 8335
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

-- Example 8336
SELECT menu_category, menu_price_usd,
    SUM(menu_price_usd)
      OVER(PARTITION BY menu_category ORDER BY menu_price_usd
      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_price
  FROM menu_items
  WHERE menu_category IN('Beverage','Dessert','Snack')
  ORDER BY menu_category, menu_price_usd;

-- Example 8337
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

-- Example 8338
OVER(PARTITION BY col1 ORDER BY col2 ROWS UNBOUNDED PRECEDING)

-- Example 8339
OVER(PARTITION BY col1 ORDER BY col2 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

-- Example 8340
OVER(PARTITION BY col1 ORDER BY col2 ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING)

-- Example 8341
OVER(PARTITION BY col1 ORDER BY col2 ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)

-- Example 8342
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

-- Example 8343
+-------------+-------------+------+
| Salesperson | Amount Sold | Rank |
|-------------+-------------+------|
| Smith       |        2000 |    1 |
| Jones       |        1500 |    2 |
| Torkelson   |        1200 |    3 |
| Dolenz      |        1100 |    4 |
+-------------+-------------+------+

-- Example 8344
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

-- Example 8345
SELECT
    branch_ID,
    net_profit,
    RANK() OVER (ORDER BY net_profit DESC) AS sales_rank
  FROM store_sales

-- Example 8346
SELECT
    branch_ID,
    net_profit,
    RANK() OVER (ORDER BY net_profit DESC) AS sales_rank
  FROM store_sales
  ORDER BY branch_ID;

-- Example 8347
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

-- Example 8348
... WHERE date >= start_of_relevant_week and date <= end_of_relevant_week ...

-- Example 8349
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

-- Example 8350
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

-- Example 8351
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

-- Example 8352
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

-- Example 8353
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

-- Example 8354
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

-- Example 8355
CREATE TABLE sales (sales_date DATE, quantity INTEGER);

INSERT INTO sales (sales_date, quantity) VALUES
    ('2018-01-01', 1),
    ('2018-01-02', 3),
    ('2018-01-03', 5),
    ('2018-02-01', 2)
    ;

