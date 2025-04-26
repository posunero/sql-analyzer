-- Example 273
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 274
(mytable.* ILIKE 'col1%')

-- Example 275
SELECT HASH_AGG(NULL), HASH_AGG(NULL, NULL), HASH_AGG(NULL, NULL, NULL);

-- Example 276
+----------------------+----------------------+----------------------------+
|       HASH_AGG(NULL) | HASH_AGG(NULL, NULL) | HASH_AGG(NULL, NULL, NULL) |
|----------------------+----------------------+----------------------------|
| -5089618745711334219 |  2405106413361157177 |       -5970411136727777524 |
+----------------------+----------------------+----------------------------+

-- Example 277
SELECT HASH_AGG(NULL) WHERE 0 = 1;

-- Example 278
+----------------+
| HASH_AGG(NULL) |
|----------------|
|              0 |
+----------------+

-- Example 279
SELECT HASH_AGG(*) FROM orders;

-- Example 280
+---------------------+
|     HASH_AGG(*)     |
|---------------------|
| 1830986524994392080 |
+---------------------+

-- Example 281
SELECT YEAR(o_orderdate), HASH_AGG(*)
  FROM ORDERS GROUP BY 1 ORDER BY 1;

-- Example 282
+-------------------+----------------------+
| YEAR(O_ORDERDATE) |     HASH_AGG(*)      |
|-------------------+----------------------|
| 1992              | 4367993187952496263  |
| 1993              | 7016955727568565995  |
| 1994              | -2863786208045652463 |
| 1995              | 1815619282444629659  |
| 1996              | -4747088155740927035 |
| 1997              | 7576942849071284554  |
| 1998              | 4299551551435117762  |
+-------------------+----------------------+

-- Example 283
SELECT YEAR(o_orderdate), HASH_AGG(o_custkey, o_orderdate)
  FROM orders GROUP BY 1 ORDER BY 1;

-- Example 284
+-------------------+----------------------------------+
| YEAR(O_ORDERDATE) | HASH_AGG(O_CUSTKEY, O_ORDERDATE) |
|-------------------+----------------------------------|
| 1992              | 5686635209456450692              |
| 1993              | -6250299655507324093             |
| 1994              | 6630860688638434134              |
| 1995              | 6010861038251393829              |
| 1996              | -767358262659738284              |
| 1997              | 6531729365592695532              |
| 1998              | 2105989674377706522              |
+-------------------+----------------------------------+

-- Example 285
SELECT YEAR(o_orderdate), HASH_AGG(DISTINCT o_custkey, o_orderdate)
  FROM orders GROUP BY 1 ORDER BY 1;

-- Example 286
+-------------------+-------------------------------------------+
| YEAR(O_ORDERDATE) | HASH_AGG(DISTINCT O_CUSTKEY, O_ORDERDATE) |
|-------------------+-------------------------------------------|
| 1992              | -8416988862307613925                      |
| 1993              | 3646533426281691479                       |
| 1994              | -7562910554240209297                      |
| 1995              | 6413920023502140932                       |
| 1996              | -3176203653000722750                      |
| 1997              | 4811642075915950332                       |
| 1998              | 1919999828838507836                       |
+-------------------+-------------------------------------------+

-- Example 287
SELECT COUNT(DISTINCT o_orderdate) FROM orders;

-- Example 288
+-----------------------------+
| COUNT(DISTINCT O_ORDERDATE) |
|-----------------------------|
| 2406                        |
+-----------------------------+

-- Example 289
SELECT COUNT(o_orderdate)
  FROM (SELECT o_orderdate, HASH_AGG(DISTINCT o_custkey)
    FROM orders
    WHERE o_orderstatus <> 'F'
    GROUP BY 1
    INTERSECT
      SELECT o_orderdate, HASH_AGG(DISTINCT o_custkey)
        FROM orders
        WHERE o_orderstatus <> 'P'
        GROUP BY 1);

-- Example 290
+--------------------+
| COUNT(O_ORDERDATE) |
|--------------------|
| 1143               |
+--------------------+

-- Example 291
ARRAY_AGG( [ DISTINCT ] <expr1> ) [ WITHIN GROUP ( <orderby_clause> ) ]

-- Example 292
ARRAY_AGG( [ DISTINCT ] <expr1> )
  [ WITHIN GROUP ( <orderby_clause> ) ]
  OVER ( [ PARTITION BY <expr2> ] [ ORDER BY <expr3> [ { ASC | DESC } ] ] [ <window_frame> ] )

-- Example 293
SELECT ARRAY_AGG(DISTINCT O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY) ...;

-- Example 294
SELECT ARRAY_AGG(DISTINCT O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERSTATUS) ...;

-- Example 295
SQL compilation error: [ORDERS.O_ORDERSTATUS] is not a valid order by expression

-- Example 296
CREATE TABLE orders (
    o_orderkey INTEGER,         -- unique ID for each order.
    o_clerk VARCHAR,            -- identifies which clerk is responsible.
    o_totalprice NUMBER(12, 2), -- total price.
    o_orderstatus CHAR(1)       -- 'F' = Fulfilled (sent); 
                                -- 'O' = 'Ordered but not yet Fulfilled'.
    );

INSERT INTO orders (o_orderkey, o_orderstatus, o_clerk, o_totalprice) 
  VALUES 
    ( 32123, 'O', 'Clerk#000000321',     321.23),
    ( 41445, 'F', 'Clerk#000000386', 1041445.00),
    ( 55937, 'O', 'Clerk#000000114', 1055937.00),
    ( 67781, 'F', 'Clerk#000000521', 1067781.00),
    ( 80550, 'O', 'Clerk#000000411', 1080550.00),
    ( 95808, 'F', 'Clerk#000000136', 1095808.00),
    (101700, 'O', 'Clerk#000000220', 1101700.00),
    (103136, 'F', 'Clerk#000000508', 1103136.00);

-- Example 297
SELECT O_ORDERKEY AS order_keys
  FROM orders
  WHERE O_TOTALPRICE > 450000
  ORDER BY O_ORDERKEY;
+------------+
| ORDER_KEYS |
|------------|
|      41445 |
|      55937 |
|      67781 |
|      80550 |
|      95808 |
|     101700 |
|     103136 |
+------------+

-- Example 298
SELECT ARRAY_AGG(O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY ASC)
  FROM orders 
  WHERE O_TOTALPRICE > 450000;
+--------------------------------------------------------------+
| ARRAY_AGG(O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY ASC) |
|--------------------------------------------------------------|
| [                                                            |
|   41445,                                                     |
|   55937,                                                     |
|   67781,                                                     |
|   80550,                                                     |
|   95808,                                                     |
|   101700,                                                    |
|   103136                                                     |
| ]                                                            |
+--------------------------------------------------------------+

-- Example 299
SELECT ARRAY_AGG(DISTINCT O_ORDERSTATUS) WITHIN GROUP (ORDER BY O_ORDERSTATUS ASC)
  FROM orders 
  WHERE O_TOTALPRICE > 450000
  ORDER BY O_ORDERSTATUS ASC;
+-----------------------------------------------------------------------------+
| ARRAY_AGG(DISTINCT O_ORDERSTATUS) WITHIN GROUP (ORDER BY O_ORDERSTATUS ASC) |
|-----------------------------------------------------------------------------|
| [                                                                           |
|   "F",                                                                      |
|   "O"                                                                       |
| ]                                                                           |
+-----------------------------------------------------------------------------+

-- Example 300
SELECT 
    O_ORDERSTATUS, 
    ARRAYAGG(O_CLERK) WITHIN GROUP (ORDER BY O_TOTALPRICE DESC)
  FROM orders 
  WHERE O_TOTALPRICE > 450000
  GROUP BY O_ORDERSTATUS
  ORDER BY O_ORDERSTATUS DESC;
+---------------+-------------------------------------------------------------+
| O_ORDERSTATUS | ARRAYAGG(O_CLERK) WITHIN GROUP (ORDER BY O_TOTALPRICE DESC) |
|---------------+-------------------------------------------------------------|
| O             | [                                                           |
|               |   "Clerk#000000220",                                        |
|               |   "Clerk#000000411",                                        |
|               |   "Clerk#000000114"                                         |
|               | ]                                                           |
| F             | [                                                           |
|               |   "Clerk#000000508",                                        |
|               |   "Clerk#000000136",                                        |
|               |   "Clerk#000000521",                                        |
|               |   "Clerk#000000386"                                         |
|               | ]                                                           |
+---------------+-------------------------------------------------------------+

-- Example 301
CREATE OR REPLACE TABLE array_data AS (
WITH data AS (
  SELECT 1 a, [1,3,2,4,7,8,10] b
  UNION ALL
  SELECT 2, [1,3,2,4,7,8,10]
  )
SELECT 'Ord'||a o_orderkey, 'c'||value o_clerk, index
  FROM data, TABLE(FLATTEN(b))
);

-- Example 302
SELECT o_orderkey,
    ARRAY_AGG(o_clerk) OVER(PARTITION BY o_orderkey ORDER BY o_orderkey
      ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS result
  FROM array_data;

-- Example 303
+------------+---------+
| O_ORDERKEY | RESULT  |
|------------+---------|
| Ord1       | [       |
|            |   "c1"  |
|            | ]       |
| Ord1       | [       |
|            |   "c1", |
|            |   "c3"  |
|            | ]       |
| Ord1       | [       |
|            |   "c1", |
|            |   "c3", |
|            |   "c2"  |
|            | ]       |
| Ord1       | [       |
|            |   "c1", |
|            |   "c3", |
|            |   "c2", |
|            |   "c4"  |
|            | ]       |
| Ord1       | [       |
|            |   "c3", |
|            |   "c2", |
|            |   "c4", |
|            |   "c7"  |
|            | ]       |
| Ord1       | [       |
|            |   "c2", |
|            |   "c4", |
|            |   "c7", |
|            |   "c8"  |
|            | ]       |
| Ord1       | [       |
|            |   "c4", |
|            |   "c7", |
|            |   "c8", |
|            |   "c10" |
|            | ]       |
| Ord2       | [       |
|            |   "c1"  |
|            | ]       |
| Ord2       | [       |
|            |   "c1", |
|            |   "c3"  |
|            | ]       |
...

-- Example 304
OBJECT_AGG(<key>, <value>)

-- Example 305
OBJECT_AGG(<key>, <value>) OVER ( [ PARTITION BY <expr2> ] )

-- Example 306
CREATE OR REPLACE TABLE objectagg_example(g NUMBER, k VARCHAR(30), v VARIANT);
INSERT INTO objectagg_example SELECT 0, 'name', 'Joe'::VARIANT;
INSERT INTO objectagg_example SELECT 0, 'age', 21::VARIANT;
INSERT INTO objectagg_example SELECT 1, 'name', 'Sue'::VARIANT;
INSERT INTO objectagg_example SELECT 1, 'zip', 94401::VARIANT;

SELECT * FROM objectagg_example;

-- Example 307
+---+------+-------+
| G |  K   |   V   |
|---+------+-------|
| 0 | name | "Joe" |
| 0 | age  | 21    |
| 1 | name | "Sue" |
| 1 | zip  | 94401 |
+---+------+-------+

-- Example 308
SELECT OBJECT_AGG(k, v) FROM objectagg_example GROUP BY g;

-- Example 309
+-------------------+
| OBJECT_AGG(K, V)  |
|-------------------|
| {                 |
|  "name": "Sue",   |
|   "zip": 94401    |
| }                 |
| {                 |
|  "age": 21,       |
|  "name": "Joe"    |
| }                 |
+-------------------+

-- Example 310
SELECT seq, key, value
  FROM (SELECT object_agg(k, v) o FROM objectagg_example GROUP BY g),
    LATERAL FLATTEN(input => o);

-- Example 311
+-----+------+-------+
| SEQ | KEY  | VALUE |
|-----+------+-------|
|   1 | name | "Sue" |
|   1 | zip  | 94401 |
|   2 | age  | 21    |
|   2 | name | "Joe" |
+-----+------+-------+

-- Example 312
REGR_AVGX(y, x)

-- Example 313
REGR_AVGX(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 314
CREATE OR REPLACE TABLE aggr(k int, v decimal(10,2), v2 decimal(10, 2));
INSERT INTO aggr VALUES(1, 10, NULL);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, NULL), (2, 30, 35);

-- Example 315
SELECT k, REGR_AVGX(v, v2) FROM aggr GROUP BY k;

---+------------------+
 k | regr_avgx(v, v2) |
---+------------------+
 1 | [NULL]           |
 2 | 22.666666667     |
---+------------------+

-- Example 316
REGR_AVGY(y, x)

-- Example 317
REGR_AVGY(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 318
create or replace table aggr(k int, v decimal(10,2), v2 decimal(10, 2));
insert into aggr values(1, 10, null);
insert into aggr values(2, 10, 11), (2, 20, 22), (2, 25,null), (2, 30, 35);

-- Example 319
select k, regr_avgy(v, v2) from aggr group by k;

---+------------------+
 k | regr_avgy(v, v2) |
---+------------------+
 1 | [NULL]           |
 2 | 20               |
---+------------------+

-- Example 320
REGR_COUNT(y, x)

-- Example 321
REGR_COUNT(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 322
CREATE OR REPLACE TABLE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

SELECT k, COUNT(*), REGR_COUNT(v, v2) FROM aggr GROUP BY k;

-- Example 323
+---+----------+-------------------+
| k | count(*) | regr_count(v, v2) |
|---+----------+-------------------|
| 1 |      1   |            0      |
| 2 |      4   |            3      |
+---+----------+-------------------+

-- Example 324
REGR_INTERCEPT(y, x)

-- Example 325
REGR_INTERCEPT(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 326
CREATE OR REPLACE TABLE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

SELECT k, REGR_INTERCEPT(v, v2) FROM aggr GROUP BY k;

-- Example 327
+---+-----------------------+
| k | regr_intercept(v, v2) |
|---+-----------------------|
| 1 | [NULL]                |
| 2 | 1.154734411           |
+---+-----------------------+

-- Example 328
NULL                 if VAR_POP(x) = 0, else
1                    if VAR_POP(y) = 0 and VAR_POP(x) <> 0, else
POWER(CORR(y,x), 2)

-- Example 329
REGR_R2(y, x)

-- Example 330
REGR_R2(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 331
CREATE OR REPLACE TABLE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

-- Example 332
SELECT k, REGR_R2(v, v2) FROM aggr GROUP BY k;

-- Example 333
+---+----------------+
| k | regr_r2(v, v2) |
|---+----------------+
| 1 | [NULL]         |
| 2 | 0.9976905312   |
+---+----------------+

-- Example 334
REGR_SLOPE(y, x)

-- Example 335
REGR_SLOPE(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 336
CREATE OR REPLACE TABLE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

SELECT k, REGR_SLOPE(v, v2) FROM aggr GROUP BY k;

-- Example 337
+---+-------------------+
| k | regr_slope(v, v2) |
|---+-------------------|
| 1 | [NULL]            |
| 2 | 0.831408776       |
+---+-------------------+

-- Example 338
REGR_SXX(y, x)

-- Example 339
REGR_SXX(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 340
CREATE OR REPLACE TABLE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

SELECT k, REGR_SXX(v, v2) FROM aggr GROUP BY k;

