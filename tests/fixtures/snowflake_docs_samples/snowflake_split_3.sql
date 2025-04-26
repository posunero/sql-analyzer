-- Example 137
+------+------+----------------------------------------------------------------------+
| K    | D    | MIN(D) OVER (ORDER BY K, D ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) |
|------+------+----------------------------------------------------------------------|
| 1    | 1    | 1                                                                    |
| 1    | 3    | 1                                                                    |
| 1    | 5    | 3                                                                    |
| 2    | 2    | 2                                                                    |
| 2    | NULL | 2                                                                    |
| 3    | NULL | NULL                                                                 |
| NULL | 1    | 1                                                                    |
| NULL | 7    | 1                                                                    |
+------+------+----------------------------------------------------------------------+

-- Example 138
MIN_BY( <col_to_return>, <col_containing_mininum> [ , <maximum_number_of_values_to_return> ] )

-- Example 139
CREATE OR REPLACE TABLE employees(employee_id NUMBER, department_id NUMBER, salary NUMBER);

INSERT INTO employees VALUES
  (1001, 10, 10000),
  (1020, 10, 9000),
  (1030, 10, 8000),
  (900, 20, 15000),
  (2000, 20, NULL),
  (2010, 20, 15000),
  (2020, 20, 8000);

-- Example 140
SELECT * FROM employees;

-- Example 141
+-------------+---------------+--------+
| EMPLOYEE_ID | DEPARTMENT_ID | SALARY |
|-------------+---------------+--------|
|        1001 |            10 |  10000 |
|        1020 |            10 |   9000 |
|        1030 |            10 |   8000 |
|         900 |            20 |  15000 |
|        2000 |            20 |   NULL |
|        2010 |            20 |  15000 |
|        2020 |            20 |   8000 |
+-------------+---------------+--------+

-- Example 142
SELECT MIN_BY(employee_id, salary) FROM employees;

-- Example 143
+-----------------------------+
| MIN_BY(EMPLOYEE_ID, SALARY) |
|-----------------------------|
|                        1030 |
+-----------------------------+

-- Example 144
SELECT MIN_BY(employee_id, salary, 3) FROM employees;

+--------------------------------+
| MIN_BY(EMPLOYEE_ID, SALARY, 3) |
|--------------------------------|
| [                              |
|   1030,                        |
|   2020,                        |
|   1020                         |
| ]                              |
+--------------------------------+

-- Example 145
MODE( <expr1> )

-- Example 146
MODE( <expr1> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 147
create or replace table aggr(k int, v decimal(10,2));

-- Example 148
select mode(v) from aggr;
+---------+
| MODE(V) |
|---------|
|    NULL |
+---------+

-- Example 149
INSERT INTO aggr (k, v) VALUES
    (1, 10), 
    (1, 10), 
    (1, 10), 
    (1, 10), 
    (1, 20), 
    (1, 21);

-- Example 150
select mode(v) from aggr;
+---------+
| MODE(V) |
|---------|
|   10.00 |
+---------+

-- Example 151
INSERT INTO aggr (k, v) VALUES
    (2, 20), 
    (2, 20), 
    (2, 25), 
    (2, 30);

-- Example 152
select mode(v) from aggr;
+---------+
| MODE(V) |
|---------|
|   10.00 |
+---------+

-- Example 153
INSERT INTO aggr (k, v) VALUES (3, null);

-- Example 154
select k, mode(v) 
    from aggr 
    group by k
    order by k;
+---+---------+
| K | MODE(V) |
|---+---------|
| 1 |   10.00 |
| 2 |   20.00 |
| 3 |    NULL |
+---+---------+

-- Example 155
select k, v, mode(v) over (partition by k) 
    from aggr 
    order by k, v;
+---+-------+-------------------------------+
| K |     V | MODE(V) OVER (PARTITION BY K) |
|---+-------+-------------------------------|
| 1 | 10.00 |                         10.00 |
| 1 | 10.00 |                         10.00 |
| 1 | 10.00 |                         10.00 |
| 1 | 10.00 |                         10.00 |
| 1 | 20.00 |                         10.00 |
| 1 | 21.00 |                         10.00 |
| 2 | 20.00 |                         20.00 |
| 2 | 20.00 |                         20.00 |
| 2 | 25.00 |                         20.00 |
| 2 | 30.00 |                         20.00 |
| 3 |  NULL |                          NULL |
+---+-------+-------------------------------+

-- Example 156
PERCENTILE_CONT( <percentile> ) WITHIN GROUP (ORDER BY <order_by_expr>)

-- Example 157
PERCENTILE_CONT( <percentile> )
  WITHIN GROUP (ORDER BY <order_by_expr>)
  OVER ( [ PARTITION BY <expr3> ] )

-- Example 158
create or replace table aggr(k int, v decimal(10,2));
insert into aggr (k, v) values
    (0,  0),
    (0, 10),
    (0, 20),
    (0, 30),
    (0, 40),
    (1, 10),
    (1, 20),
    (2, 10),
    (2, 20),
    (2, 25),
    (2, 30),
    (3, 60),
    (4, NULL);

-- Example 159
select k, percentile_cont(0.25) within group (order by v) 
  from aggr 
  group by k
  order by k;
+---+-------------------------------------------------+
| K | PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY V) |
|---+-------------------------------------------------|
| 0 |                                        10.00000 |
| 1 |                                        12.50000 |
| 2 |                                        17.50000 |
| 3 |                                        60.00000 |
| 4 |                                            NULL |
+---+-------------------------------------------------+

-- Example 160
PERCENTILE_DISC( <percentile> ) WITHIN GROUP (ORDER BY <order_by_expr> )

-- Example 161
PERCENTILE_DISC( <percentile> )
  WITHIN GROUP (ORDER BY <order_by_expr> )
  OVER ( [ PARTITION BY <expr3> ] )

-- Example 162
create or replace table aggr(k int, v decimal(10,2));
insert into aggr (k, v) values
    (0,  0),
    (0, 10),
    (0, 20),
    (0, 30),
    (0, 40),
    (1, 10),
    (1, 20),
    (2, 10),
    (2, 20),
    (2, 25),
    (2, 30),
    (3, 60),
    (4, NULL);

-- Example 163
select k, percentile_disc(0.25) within group (order by v) 
  from aggr 
  group by k
  order by k;
+---+-------------------------------------------------+
| K | PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY V) |
|---+-------------------------------------------------|
| 0 |                                           10.00 |
| 1 |                                           10.00 |
| 2 |                                           10.00 |
| 3 |                                           60.00 |
| 4 |                                            NULL |
+---+-------------------------------------------------+

-- Example 164
{ STDDEV | STDDEV_SAMP } ( [ DISTINCT ] <expr1> )

-- Example 165
{ STDDEV | STDDEV_SAMP } ( [ DISTINCT ] <expr1> ) OVER (
                                                       [ PARTITION BY <expr2> ]
                                                       [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                                       )

-- Example 166
CREATE TABLE t1 (c1 INTEGER);
INSERT INTO t1 (c1) VALUES
    (6),
   (10),
   (14)
   ;
SELECT STDDEV(c1) FROM t1;

-- Example 167
+----------+
| STDDEV() |
|----------|
|        4 |
+----------+

-- Example 168
SELECT STDDEV_SAMP(c1) FROM t1;

-- Example 169
+-----------------+
| STDDEV_SAMP(C1) |
|-----------------|
|               4 |
+-----------------+

-- Example 170
SELECT menu_category, STDDEV(menu_cogs_usd) stddev_cogs, STDDEV(menu_price_usd) stddev_price
  FROM menu_items
  WHERE menu_category='Dessert'
  GROUP BY 1;

-- Example 171
+---------------+-------------+--------------+
| MENU_CATEGORY | STDDEV_COGS | STDDEV_PRICE |
|---------------+-------------+--------------|
| Dessert       |  1.00519484 |  1.471960144 |
+---------------+-------------+--------------+

-- Example 172
SELECT menu_category, menu_cogs_usd,
    STDDEV(menu_cogs_usd) OVER(PARTITION BY menu_category) stddev_cogs
  FROM menu_items
  GROUP BY 1,2
  ORDER BY menu_category;

-- Example 173
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

-- Example 174
CREATE OR REPLACE TABLE menu_items(
  menu_id INT NOT NULL,
  menu_category VARCHAR(20),
  menu_item_name VARCHAR(50),
  menu_cogs_usd NUMBER(7,2),
  menu_price_usd NUMBER(7,2));

-- Example 175
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

-- Example 176
STDDEV_POP( [ DISTINCT ] <expr1>)

-- Example 177
STDDEV_POP( [ DISTINCT ] <expr1> ) OVER (
                                        [ PARTITION BY <expr2> ]
                                        [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                        )

-- Example 178
CREATE TABLE t1 (c1 INTEGER);
INSERT INTO t1 (c1) VALUES
    (6),
   (10),
   (14)
   ;
SELECT STDDEV_POP(c1) FROM t1;

-- Example 179
+----------------+
| STDDEV_POP(C1) |
|----------------|
|    3.265986375 |
+----------------+

-- Example 180
+---------+--------------------+---------------+-------------------+----------------+
| MENU_ID | MENU_ITEM_NAME     | ITEM_CATEGORY | COST_OF_GOODS_USD | SALE_PRICE_USD |
|---------+--------------------+---------------+-------------------+----------------|
|   10002 | Sugar Cone         | Dessert       |            2.5000 |         6.0000 |
|   10003 | Waffle Cone        | Dessert       |            2.5000 |         6.0000 |
|   10004 | Two Scoop Bowl     | Dessert       |            3.0000 |         7.0000 |
|   10008 | Ice Cream Sandwich | Dessert       |            1.0000 |         4.0000 |
|   10009 | Mango Sticky Rice  | Dessert       |            1.2500 |         5.0000 |
|   10010 | Popsicle           | Dessert       |            0.5000 |         3.0000 |
+---------+--------------------+---------------+-------------------+----------------+

-- Example 181
SELECT item_category, STDDEV_POP(cost_of_goods_usd) stddev_cogs, STDDEV_POP(sale_price_usd) stddev_price
  FROM menu
  WHERE item_category='Dessert'
  GROUP BY 1;

-- Example 182
+---------------+--------------+--------------+
| ITEM_CATEGORY |  STDDEV_COGS | STDDEV_PRICE |
|---------------+--------------+--------------|
| Dessert       | 0.9176131477 |  1.343709625 |
+---------------+--------------+--------------+

-- Example 183
SELECT item_category, cost_of_goods_usd, STDDEV_POP(cost_of_goods_usd) OVER(PARTITION BY item_category) stddev_cogs
  FROM menu
  GROUP BY 1,2
  ORDER BY item_category;

-- Example 184
+---------------+-------------------+--------------+
| ITEM_CATEGORY | COST_OF_GOODS_USD |  STDDEV_COGS |
|---------------+-------------------+--------------|
| Beverage      |            0.5000 | 0.1027402334 |
| Beverage      |            0.7500 | 0.1027402334 |
| Beverage      |            0.6500 | 0.1027402334 |
| Dessert       |            2.5000 | 0.9433981132 |
| Dessert       |            3.0000 | 0.9433981132 |
| Dessert       |            1.0000 | 0.9433981132 |
| Dessert       |            0.5000 | 0.9433981132 |
| Dessert       |            1.2500 | 0.9433981132 |
| Main          |            4.5000 | 3.352193642  |
| Main          |            8.0000 | 3.352193642  |
| Main          |            2.0000 | 3.352193642  |
| Main          |            3.5000 | 3.352193642  |
...

-- Example 185
SUM( [ DISTINCT ] <expr1> )

-- Example 186
SUM( [ DISTINCT ] <expr1> ) OVER (
                                 [ PARTITION BY <expr2> ]
                                 [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                 )

-- Example 187
CREATE OR REPLACE TABLE sum_example(k INT, d DECIMAL(10,5),
                                    s1 VARCHAR(10), s2 VARCHAR(10));

INSERT INTO sum_example VALUES
  (1, 1.1, '1.1','one'),
  (1, 10, '10','ten'),
  (2, 2.2, '2.2','two'),
  (2, null, null,'null'),
  (3, null, null, 'null'),
  (null, 9, '9.9','nine');

SELECT * FROM sum_example;

-- Example 188
+------+----------+------+------+
|    K |        D | S1   | S2   |
|------+----------+------+------|
|    1 |  1.10000 | 1.1  | one  |
|    1 | 10.00000 | 10.0 | ten  |
|    2 |  2.20000 | 2.2  | two  |
|    2 |     NULL | NULL | null |
|    3 |     NULL | NULL | null |
| NULL |  9.00000 | 9.9  | nine |
+------+----------+------+------+

-- Example 189
SELECT SUM(d), SUM(s1) FROM sum_example;

-- Example 190
+----------+---------+
|   SUM(D) | SUM(S1) |
|----------+---------|
| 22.30000 |    23.2 |
+----------+---------+

-- Example 191
SELECT k, SUM(d), SUM(s1) FROM sum_example GROUP BY k;

-- Example 192
+------+----------+---------+
|    K |   SUM(D) | SUM(S1) |
|------+----------+---------|
|    1 | 11.10000 |    11.1 |
|    2 |  2.20000 |     2.2 |
|    3 |     NULL |    NULL |
| NULL |  9.00000 |     9.9 |
+------+----------+---------+

-- Example 193
SELECT SUM(s2) FROM sum_example;

-- Example 194
100038 (22018): Numeric value 'one' is not recognized

-- Example 195
CREATE OR REPLACE TABLE example_cumulative (p INT, o INT, i INT);

INSERT INTO example_cumulative VALUES
    (  0, 1, 10), (0, 2, 20), (0, 3, 30),
    (100, 1, 10),(100, 2, 30),(100, 2, 5),(100, 3, 11),(100, 3, 120),
    (200, 1, 10000),(200, 1, 200),(200, 1, 808080),(200, 2, 33333),(200, 3, null), (200, 3, 4),
    (300, 1, null), (300, 1, null);

-- Example 196
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

-- Example 197
VAR_POP( [ DISTINCT ] <expr1> )

-- Example 198
VAR_POP( [ DISTINCT ] <expr1> ) OVER (
                                     [ PARTITION BY <expr2> ]
                                     [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                     )

-- Example 199
create table aggr(k int, v decimal(10,2), v2 decimal(10, 2));
insert into aggr values 
   (1, 10, null),
   (2, 10, 11), 
   (2, 20, 22), 
   (2, 25, null), 
   (2, 30, 35);

-- Example 200
SELECT k, var_pop(v), var_pop(v2) 
    FROM aggr 
    GROUP BY k
    ORDER BY k;
+---+---------------+---------------+
| K |    VAR_POP(V) |   VAR_POP(V2) |
|---+---------------+---------------|
| 1 |  0.0000000000 |          NULL |
| 2 | 54.6875000000 | 96.2222222222 |
+---+---------------+---------------+

-- Example 201
VAR_SAMP( [DISTINCT] <expr1> )

-- Example 202
VAR_SAMP( <expr1> ) OVER (
                         [ PARTITION BY <expr2> ]
                         [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                         )

-- Example 203
create table aggr(k int, v decimal(10,2), v2 decimal(10, 2));
insert into aggr values 
   (1, 10, null),
   (2, 10, 11), 
   (2, 20, 22), 
   (2, 25, null), 
   (2, 30, 35);

-- Example 204
SELECT k, var_samp(v), var_samp(v2) 
    FROM aggr 
    GROUP BY k
    ORDER BY k;
+---+---------------+----------------+
| K |   VAR_SAMP(V) |   VAR_SAMP(V2) |
|---+---------------+----------------|
| 1 |          NULL |           NULL |
| 2 | 72.9166666667 | 144.3333333333 |
+---+---------------+----------------+

