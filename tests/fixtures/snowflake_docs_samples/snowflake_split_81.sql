-- Example 5408
USE ROLE network_admin;
USE DATABASE securitydb;
SELECT *
  FROM TABLE(
    securitydb.INFORMATION_SCHEMA.NETWORK_RULE_REFERENCES(
      NETWORK_RULE_NAME => 'securitydb.myrules.cloud_rule'
    )
  );

-- Example 5409
USE ROLE network_admin;
USE DATABASE securitydb;
SELECT *
  FROM TABLE(
    securitydb.INFORMATION_SCHEMA.NETWORK_RULE_REFERENCES(
      CONTAINER_NAME => 'my_network_policy' ,
      CONTAINER_TYPE => 'NETWORK_POLICY'
    )
  );

-- Example 5410
NEXT_DAY( <date_or_time_expr> , <dow_string> )

-- Example 5411
SELECT CURRENT_DATE() AS "Today's Date",
       NEXT_DAY("Today's Date", 'Friday ') AS "Next Friday";

+--------------+-------------+
| Today's Date | Next Friday |
|--------------+-------------|
| 2018-06-12   | 2018-06-15  |
+--------------+-------------+

-- Example 5412
NORMAL( <mean> , <stddev> , <gen> )

-- Example 5413
SELECT normal(0, 1, random()) FROM table(generator(rowCount => 5));

+------------------------+
| NORMAL(0, 1, RANDOM()) |
|------------------------|
|           0.227384164  |
|           0.9945290748 |
|          -0.2045078571 |
|          -1.594607893  |
|          -0.8213296842 |
+------------------------+

-- Example 5414
SELECT normal(0, 1, 1234) FROM table(generator(rowCount => 5));

+--------------------+
| NORMAL(0, 1, 1234) |
|--------------------|
|      -0.6604156716 |
|      -0.6604156716 |
|      -0.6604156716 |
|      -0.6604156716 |
|      -0.6604156716 |
+--------------------+

-- Example 5415
NOTIFICATION_HISTORY(
  [ START_TIME => <constant_expr> ]
  [, END_TIME => <constant_expr> ]
  [, INTEGRATION_NAME => '<string>' ]
  [, RESULT_LIMIT => <integer> ] )

-- Example 5416
SELECT * FROM TABLE(INFORMATION_SCHEMA.NOTIFICATION_HISTORY());

-- Example 5417
SELECT * FROM TABLE(INFORMATION_SCHEMA.NOTIFICATION_HISTORY(
  START_TIME=>DATEADD('hour',-1,CURRENT_TIMESTAMP()),
  END_TIME=>CURRENT_TIMESTAMP(),
  RESULT_LIMIT=>100,
  INTEGRATION_NAME=>'my_integration'));

-- Example 5418
SELECT id, attempt, created, processed, status
  FROM TABLE(INFORMATION_SCHEMA.NOTIFICATION_HISTORY());

-- Example 5419
+-------------------+-------------+-----------------------------------+-----------------------------------+-----------------------+
|   ID              |   ATTEMPT   |   CREATED                         |   PROCESSED                       |   STATUS              |
+-------------------+-------------+-----------------------------------+-----------------------------------+-----------------------+
|   10ae695e-93c3   |   3         |   2023-12-05 15:10:15.194 -0800   |   NULL                            |   QUEUED              |
|   10ae695e-93c3   |   2         |   2023-12-05 15:10:15.194 -0800   |   2023-12-05 15:11:21.443 -0800   |   RETRIABLE_FAILURE   |
|   10ae695e-93c3   |   1         |   2023-12-05 15:10:15.194 -0800   |   2023-12-05 15:10:21.443 -0800   |   RETRIABLE_FAILURE   |
+-------------------+-------------+-----------------------------------+-----------------------------------+-----------------------+

-- Example 5420
SELECT id, attempt, created, processed, status
  FROM TABLE(INFORMATION_SCHEMA.NOTIFICATION_HISTORY());

-- Example 5421
+-------------------+-------------+-----------------------------------+-----------------------------------+-----------------------+
|   ID              |   ATTEMPT   |   CREATED                         |   PROCESSED                       |   STATUS              |
+-------------------+-------------+-----------------------------------+-----------------------------------+-----------------------+
|   10ae695e-93c3   |   3         |   2023-12-05 15:10:15.194 -0800   |   2023-12-05 15:12:21.443 -0800   |   SUCCESS             |
|   10ae695e-93c3   |   2         |   2023-12-05 15:10:15.194 -0800   |   2023-12-05 15:11:21.443 -0800   |   RETRIABLE_FAILURE   |
|   10ae695e-93c3   |   1         |   2023-12-05 15:10:15.194 -0800   |   2023-12-05 15:10:21.443 -0800   |   RETRIABLE_FAILURE   |
+-------------------+-------------+-----------------------------------+-----------------------------------+-----------------------+

-- Example 5422
NTH_VALUE( <expr> , <n> ) [ FROM { FIRST | LAST } ] [ { IGNORE | RESPECT } NULLS ]
  OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] [ <window_frame> ] )

-- Example 5423
PARTITION BY column_1, column_2

-- Example 5424
ORDER BY column_3, column_4

-- Example 5425
... OVER (PARTITION BY p ORDER BY o COLLATE 'lower') ...

-- Example 5426
SELECT
    column1,
    column2,
    NTH_VALUE(column2, 2) OVER (PARTITION BY column1 ORDER BY column2) AS column2_2nd
  FROM VALUES
      (1, 10), (1, 11), (1, 12),
      (2, 20), (2, 21), (2, 22);

-- Example 5427
+---------+---------+-------------+
| COLUMN1 | COLUMN2 | COLUMN2_2ND |
|---------+---------+-------------|
|       1 |      10 |          11 |
|       1 |      11 |          11 |
|       1 |      12 |          11 |
|       2 |      20 |          21 |
|       2 |      21 |          21 |
|       2 |      22 |          21 |
+---------+---------+-------------+

-- Example 5428
SELECT
        partition_col, order_col, i,
        FIRST_VALUE(i)  OVER (PARTITION BY partition_col ORDER BY order_col
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS FIRST_VAL,
        NTH_VALUE(i, 2) OVER (PARTITION BY partition_col ORDER BY order_col
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS NTH_VAL,
        LAST_VALUE(i)   OVER (PARTITION BY partition_col ORDER BY order_col
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS LAST_VAL
    FROM demo1
    ORDER BY partition_col, i, order_col;
+---------------+-----------+---+-----------+---------+----------+
| PARTITION_COL | ORDER_COL | I | FIRST_VAL | NTH_VAL | LAST_VAL |
|---------------+-----------+---+-----------+---------+----------|
|             1 |         1 | 1 |      NULL |       1 |        2 |
|             1 |         2 | 2 |         1 |       2 |        3 |
|             1 |         3 | 3 |         2 |       3 |        4 |
|             1 |         4 | 4 |         3 |       4 |        5 |
|             1 |         5 | 5 |         4 |       5 |        5 |
|             2 |         1 | 1 |      NULL |       1 |        2 |
|             2 |         2 | 2 |         1 |       2 |        3 |
|             2 |         3 | 3 |         2 |       3 |        4 |
|             2 |         4 | 4 |         3 |       4 |        4 |
+---------------+-----------+---+-----------+---------+----------+

-- Example 5429
NTILE( <constant_value> ) OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] )

-- Example 5430
SELECT
    exchange,
    symbol,
    NTILE(4) OVER (PARTITION BY exchange ORDER BY shares) AS ntile_4
  FROM trades
  ORDER BY exchange, NTILE_4;

-- Example 5431
+--------+------+-------+
|exchange|symbol|NTILE_4|
+--------+------+-------+
|C       |SPY   |      1|
|C       |AAPL  |      2|
|C       |AAPL  |      3|
|N       |SPY   |      1|
|N       |AAPL  |      1|
|N       |SPY   |      2|
|N       |QQQ   |      2|
|N       |QQQ   |      3|
|N       |YHOO  |      4|
|Q       |MSFT  |      1|
|Q       |YHOO  |      1|
|Q       |MSFT  |      2|
|Q       |YHOO  |      2|
|Q       |QQQ   |      3|
|Q       |QQQ   |      4|
|P       |AAPL  |      1|
|P       |YHOO  |      1|
|P       |MSFT  |      2|
|P       |SPY   |      3|
|P       |MSFT  |      4|
+--------+------+-------+

-- Example 5432
NULLIF( <expr1> , <expr2> )

-- Example 5433
SELECT a, b, NULLIF(a,b) FROM i;

--------+--------+-------------+
   a    |   b    | nullif(a,b) |
--------+--------+-------------+
 0      | 0      | [NULL]      |
 0      | 1      | 0           |
 0      | [NULL] | 0           |
 1      | 0      | 1           |
 1      | 1      | [NULL]      |
 1      | [NULL] | 1           |
 [NULL] | 0      | [NULL]      |
 [NULL] | 1      | [NULL]      |
 [NULL] | [NULL] | [NULL]      |
--------+--------+-------------+

-- Example 5434
NULLIFZERO( <expr> )

-- Example 5435
SELECT NULLIFZERO(0);
+---------------+
| NULLIFZERO(0) |
|---------------|
|          NULL |
+---------------+

-- Example 5436
SELECT NULLIFZERO(52);
+----------------+
| NULLIFZERO(52) |
|----------------|
|             52 |
+----------------+

-- Example 5437
SELECT NULLIFZERO(3.14159);
+---------------------+
| NULLIFZERO(3.14159) |
|---------------------|
|             3.14159 |
+---------------------+

-- Example 5438
NVL( <expr1> , <expr2> )

-- Example 5439
CREATE TABLE IF NOT EXISTS suppliers (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(30),
  phone_region_1 VARCHAR(15),
  phone_region_2 VARCHAR(15));

-- Example 5440
INSERT INTO suppliers(supplier_id, supplier_name, phone_region_1, phone_region_2)
  VALUES(1, 'Company_ABC', NULL, '555-01111'),
        (2, 'Company_DEF', '555-01222', NULL),
        (3, 'Company_HIJ', '555-01333', '555-01444'),
        (4, 'Company_KLM', NULL, NULL);

-- Example 5441
SELECT supplier_id,
       supplier_name,
       phone_region_1,
       phone_region_2,
       NVL(phone_region_1, phone_region_2) IF_REGION_1_NULL,
       NVL(phone_region_2, phone_region_1) IF_REGION_2_NULL
  FROM suppliers
  ORDER BY supplier_id;

-- Example 5442
+-------------+---------------+----------------+----------------+------------------+------------------+
| SUPPLIER_ID | SUPPLIER_NAME | PHONE_REGION_1 | PHONE_REGION_2 | IF_REGION_1_NULL | IF_REGION_2_NULL |
|-------------+---------------+----------------+----------------+------------------+------------------|
|           1 | Company_ABC   | NULL           | 555-01111      | 555-01111        | 555-01111        |
|           2 | Company_DEF   | 555-01222      | NULL           | 555-01222        | 555-01222        |
|           3 | Company_HIJ   | 555-01333      | 555-01444      | 555-01333        | 555-01444        |
|           4 | Company_KLM   | NULL           | NULL           | NULL             | NULL             |
+-------------+---------------+----------------+----------------+------------------+------------------+

-- Example 5443
NVL2( <expr1> , <expr2> , <expr3> )

-- Example 5444
SELECT a, b, c, NVL2(a, b, c) FROM i2;

--------+--------+--------+---------------+
   A    |   B    |   C    | NVL2(A, B, C) |
--------+--------+--------+---------------+
 0      | 5      | 3      | 5             |
 0      | 5      | [NULL] | 5             |
 0      | [NULL] | 3      | [NULL]        |
 0      | [NULL] | [NULL] | [NULL]        |
 [NULL] | 5      | 3      | 3             |
 [NULL] | 5      | [NULL] | [NULL]        |
 [NULL] | [NULL] | 3      | 3             |
 [NULL] | [NULL] | [NULL] | [NULL]        |
--------+--------+--------+---------------+

-- Example 5445
OBJECT_CONSTRUCT( [<key>, <value> [, <key>, <value> , ...]] )

OBJECT_CONSTRUCT(*)

-- Example 5446
(mytable.*)

-- Example 5447
(* ILIKE 'col1%')

-- Example 5448
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 5449
(mytable.* ILIKE 'col1%')

-- Example 5450
SELECT OBJECT_CONSTRUCT('a', 1, 'b', 'BBBB', 'c', NULL);

-- Example 5451
+--------------------------------------------------+
| OBJECT_CONSTRUCT('A', 1, 'B', 'BBBB', 'C', NULL) |
|--------------------------------------------------|
| {                                                |
|   "a": 1,                                        |
|   "b": "BBBB"                                    |
| }                                                |
+--------------------------------------------------+

-- Example 5452
CREATE OR REPLACE TABLE demo_table_1 (province VARCHAR, created_date DATE);
INSERT INTO demo_table_1 (province, created_date) VALUES
  ('Manitoba', '2024-01-18'::DATE),
  ('Alberta', '2024-01-19'::DATE);

-- Example 5453
SELECT province, created_date
  FROM demo_table_1
  ORDER BY province;

-- Example 5454
+----------+--------------+
| PROVINCE | CREATED_DATE |
|----------+--------------|
| Alberta  | 2024-01-19   |
| Manitoba | 2024-01-18   |
+----------+--------------+

-- Example 5455
SELECT OBJECT_CONSTRUCT(*) AS oc
  FROM demo_table_1
  ORDER BY oc['PROVINCE'];

-- Example 5456
+---------------------------------+
| OC                              |
|---------------------------------|
| {                               |
|   "CREATED_DATE": "2024-01-19", |
|   "PROVINCE": "Alberta"         |
| }                               |
| {                               |
|   "CREATED_DATE": "2024-01-18", |
|   "PROVINCE": "Manitoba"        |
| }                               |
+---------------------------------+

-- Example 5457
SELECT OBJECT_CONSTRUCT(* ILIKE 'prov%') AS oc
  FROM demo_table_1
  ORDER BY oc['PROVINCE'];

-- Example 5458
+--------------------------+
| OC                       |
|--------------------------|
| {                        |
|   "PROVINCE": "Alberta"  |
| }                        |
| {                        |
|   "PROVINCE": "Manitoba" |
| }                        |
+--------------------------+

-- Example 5459
SELECT OBJECT_CONSTRUCT(* EXCLUDE province) AS oc
  FROM demo_table_1
  ORDER BY oc['PROVINCE'];

-- Example 5460
+--------------------------------+
| OC                             |
|--------------------------------|
| {                              |
|   "CREATED_DATE": "2024-01-18" |
| }                              |
| {                              |
|   "CREATED_DATE": "2024-01-19" |
| }                              |
+--------------------------------+

-- Example 5461
SELECT {* EXCLUDE province} AS oc
  FROM demo_table_1
  ORDER BY oc['PROVINCE'];

-- Example 5462
+--------------------------------+
| OC                             |
|--------------------------------|
| {                              |
|   "CREATED_DATE": "2024-01-18" |
| }                              |
| {                              |
|   "CREATED_DATE": "2024-01-19" |
| }                              |
+--------------------------------+

-- Example 5463
SELECT OBJECT_CONSTRUCT(*) FROM VALUES(1,'x'), (2,'y');

-- Example 5464
+---------------------+
| OBJECT_CONSTRUCT(*) |
|---------------------|
| {                   |
|   "COLUMN1": 1,     |
|   "COLUMN2": "x"    |
| }                   |
| {                   |
|   "COLUMN1": 2,     |
|   "COLUMN2": "y"    |
| }                   |
+---------------------+

-- Example 5465
SELECT OBJECT_CONSTRUCT(
  'Key_One', PARSE_JSON('NULL'), 
  'Key_Two', NULL, 
  'Key_Three', 'null') AS obj;

-- Example 5466
+-----------------------+
| OBJ                   |
|-----------------------|
| {                     |
|   "Key_One": null,    |
|   "Key_Three": "null" |
| }                     |
+-----------------------+

-- Example 5467
SELECT OBJECT_CONSTRUCT(
    'foo', 1234567,
    'dataset_size', (SELECT COUNT(*) FROM demo_table_1),
    'distinct_province', (SELECT COUNT(DISTINCT province) FROM demo_table_1),
    'created_date_seconds', extract(epoch_seconds, created_date)
  )  AS json_object
  FROM demo_table_1;

-- Example 5468
+---------------------------------------+
| JSON_OBJECT                           |
|---------------------------------------|
| {                                     |
|   "created_date_seconds": 1705536000, |
|   "dataset_size": 2,                  |
|   "distinct_province": 2,             |
|   "foo": 1234567                      |
| }                                     |
| {                                     |
|   "created_date_seconds": 1705622400, |
|   "dataset_size": 2,                  |
|   "distinct_province": 2,             |
|   "foo": 1234567                      |
| }                                     |
+---------------------------------------+

-- Example 5469
OBJECT_CONSTRUCT_KEEP_NULL( [<key>, <value> [, <key>, <value> , ...]] )

OBJECT_CONSTRUCT_KEEP_NULL(*)

-- Example 5470
(mytable.*)

-- Example 5471
(* ILIKE 'col1%')

-- Example 5472
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 5473
(mytable.* ILIKE 'col1%')

-- Example 5474
SELECT OBJECT_CONSTRUCT('key_1', 'one', 'key_2', NULL) AS WITHOUT_KEEP_NULL,
       OBJECT_CONSTRUCT_KEEP_NULL('key_1', 'one', 'key_2', NULL) AS KEEP_NULL_1,
       OBJECT_CONSTRUCT_KEEP_NULL('key_1', 'one', NULL, 'two') AS KEEP_NULL_2;

