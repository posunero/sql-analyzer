-- Example 7954
SELECT zip FROM customer_zip_example
MINUS
SELECT zip FROM sales_office_zip_example;

-- Example 7955
+-------+
| ZIP   |
|-------|
| 98444 |
| 94066 |
+-------+

-- Example 7956
SELECT ...
UNION [ ALL ]
SELECT ...

-- Example 7957
SELECT office_name office_or_customer, zip FROM sales_office_zip_example
UNION
SELECT customer, zip FROM customer_zip_example
ORDER BY zip;

-- Example 7958
+--------------------+-------+
| OFFICE_OR_CUSTOMER | ZIP   |
|--------------------+-------|
| sales1             | 94061 |
| customer2          | 94061 |
| customer1          | 94066 |
| sales2             | 94070 |
| sales4             | 98005 |
| customer4          | 98005 |
| sales3             | 98116 |
| customer3          | 98444 |
+--------------------+-------+

-- Example 7959
CREATE OR REPLACE TABLE union_test1 (v VARCHAR);
CREATE OR REPLACE TABLE union_test2 (i INTEGER);

INSERT INTO union_test1 (v) VALUES ('Adams, Douglas');
INSERT INTO union_test2 (i) VALUES (42);

-- Example 7960
SELECT v FROM union_test1
UNION
SELECT i FROM union_test2;

-- Example 7961
100038 (22018): Numeric value 'Adams, Douglas' is not recognized

-- Example 7962
SELECT v::VARCHAR FROM union_test1
UNION
SELECT i::VARCHAR FROM union_test2;

-- Example 7963
+----------------+
| V::VARCHAR     |
|----------------|
| Adams, Douglas |
| 42             |
+----------------+

-- Example 7964
CREATE OR REPLACE TABLE array_unique_agg_test (a INTEGER);
INSERT INTO array_unique_agg_test VALUES (5), (2), (1), (2), (1);

-- Example 7965
SELECT ARRAY_UNIQUE_AGG(a) AS distinct_values FROM array_unique_agg_test;

-- Example 7966
+-----------------+
| DISTINCT_VALUES |
|-----------------|
| [               |
|   5,            |
|   2,            |
|   1             |
| ]               |
+-----------------+

-- Example 7967
SELECT ARRAY_SIZE(ARRAY_UNIQUE_AGG(a)) AS number_of_distinct_values FROM array_unique_agg_test;

-- Example 7968
+---------------------------+
| NUMBER_OF_DISTINCT_VALUES |
|---------------------------|
|                         3 |
+---------------------------+

-- Example 7969
SELECT
  COUNT(DISTINCT my_column_1),
  COUNT(DISTINCT my_column_2)
FROM my_table;

-- Example 7970
SELECT
  ARRAY_SIZE(ARRAY_UNIQUE_AGG(my_column_1)),
  ARRAY_SIZE(ARRAY_UNIQUE_AGG(my_column_2))
FROM my_table;

-- Example 7971
SELECT
  COUNT(DISTINCT my_column_1),
  COUNT(DISTINCT my_column_2)
FROM my_table
GROUP BY my_key_1, my_key_2;

-- Example 7972
SELECT
  ARRAY_SIZE(ARRAY_UNIQUE_AGG(my_column_1)),
  ARRAY_SIZE(ARRAY_UNIQUE_AGG(my_column_2))
FROM my_table
GROUP BY my_key_1, my_key_2;

-- Example 7973
SELECT
  COUNT(DISTINCT my_column)
FROM my_table
GROUP BY ROLLUP(my_key_1, my_key_2);

-- Example 7974
SELECT
  ARRAY_SIZE(ARRAY_UNIQUE_AGG(my_column))
FROM my_table
GROUP BY ROLLUP(my_key_1, my_key_2);

-- Example 7975
CREATE TABLE precompute AS
SELECT
  my_dimension_1,
  my_dimension_2,
  ARRAY_UNIQUE_AGG(my_column) arr
FROM my_table
GROUP BY 1, 2;

-- Example 7976
SELECT
  my_dimension_1,
  my_dimension_2,
  ARRAY_SIZE(arr)
FROM precompute
GROUP BY 1, 2;

-- Example 7977
SELECT
  my_dimension_1,
  ARRAY_SIZE(ARRAY_UNION_AGG(arr))
FROM precompute
GROUP BY 1;

-- Example 7978
SELECT
  my_dimension_2,
  ARRAY_SIZE(ARRAY_UNION_AGG(arr))
FROM precompute
GROUP BY 1;

-- Example 7979
select bitmap_bucket_number(1), bitmap_bit_position(1);

+-------------------------+------------------------+
| BITMAP_BUCKET_NUMBER(1) | BITMAP_BIT_POSITION(1) |
|-------------------------+------------------------|
|                       1 |                      0 |
+-------------------------+------------------------+

-- Example 7980
select bitmap_bucket_number(32768), bitmap_bit_position(32768);

+-----------------------------+----------------------------+
| BITMAP_BUCKET_NUMBER(32768) | BITMAP_BIT_POSITION(32768) |
|-----------------------------+----------------------------|
|                           1 |                      32767 |
+-----------------------------+----------------------------+

-- Example 7981
select bitmap_bucket_number(32769), bitmap_bit_position(32769);

+-----------------------------+----------------------------+
| BITMAP_BUCKET_NUMBER(32769) | BITMAP_BIT_POSITION(32769) |
|-----------------------------+----------------------------|
|                           2 |                          0 |
+-----------------------------+----------------------------+

-- Example 7982
CREATE OR REPLACE TABLE bitmap_test_values (val INT);
insert into bitmap_test_values values (1), (32769);

-- Example 7983
-- Display the bitmap in hexadecimal
alter session set binary_output_format='hex';

select bitmap_bucket_number(val) as bitmap_id,
    bitmap_construct_agg(bitmap_bit_position(val)) as bitmap
    from bitmap_test_values
    group by bitmap_id;

+-----------+----------------------+
| BITMAP_ID | BITMAP               |
|-----------+----------------------|
|         1 | 00010000000000000000 |
|         2 | 00010000000000000000 |
+-----------+----------------------+

-- Example 7984
insert into bitmap_test_values values (32769), (32769), (1);

select bitmap_bucket_number(val) as bitmap_id,
    bitmap_construct_agg(bitmap_bit_position(val)) as bitmap
    from bitmap_test_values
    group by bitmap_id;

+-----------+----------------------+
| BITMAP_ID | BITMAP               |
|-----------+----------------------|
|         1 | 00010000000000000000 |
|         2 | 00010000000000000000 |
+-----------+----------------------+

-- Example 7985
insert into bitmap_test_values values (2), (3), (4);

select bitmap_bucket_number(val) as bitmap_id,
    bitmap_construct_agg(bitmap_bit_position(val)) as bitmap
    from bitmap_test_values
    group by bitmap_id;

+-----------+----------------------+
| BITMAP_ID | BITMAP               |
|-----------+----------------------|
|         1 | 00040000010002000300 |
|         2 | 00010000000000000000 |
+-----------+----------------------+

-- Example 7986
select bitmap_bucket_number(val) as bitmap_id,
    bitmap_count(bitmap_construct_agg(bitmap_bit_position(val))) as distinct_values
    from bitmap_test_values
    group by bitmap_id;

+-----------+-----------------+
| BITMAP_ID | DISTINCT_VALUES |
|-----------+-----------------|
|         1 |               4 |
|         2 |               1 |
+-----------+-----------------+

-- Example 7987
SELECT
  COUNT(DISTINCT my_column)
FROM my_table;

-- Example 7988
SELECT SUM(cnt) FROM (
  SELECT
    BITMAP_COUNT(BITMAP_CONSTRUCT_AGG(BITMAP_BIT_POSITION(my_column))) cnt
  FROM my_table
  GROUP BY BITMAP_BUCKET_NUMBER(my_table)
);

-- Example 7989
-- If the full value range of my_column fits into the bitmap:
--   MIN(my_column) >= 0 AND MAX(my_column) < 32,768
SELECT
  BITMAP_COUNT(BITMAP_CONSTRUCT_AGG(my_column))
FROM my_table;

-- Example 7990
SELECT
  my_key_1,
  my_key_2,
  COUNT(DISTINCT my_column)
FROM my_table
GROUP BY my_key_1, my_key_2;

-- Example 7991
SELECT my_key_1, my_key_2, SUM(cnt) FROM (
  SELECT
    my_key_1,
    my_key_2,
    BITMAP_COUNT(BITMAP_CONSTRUCT_AGG(BITMAP_BIT_POSITION(my_column))) cnt
  FROM my_table
  GROUP BY my_key_1, my_key_2, BITMAP_BUCKET_NUMBER(my_column)
)
GROUP BY my_key_1, my_key_2;

-- Example 7992
SELECT
  my_key_1,
  my_key_2,
  COUNT(DISTINCT my_column)
FROM my_table
GROUP BY ROLLUP(my_key_1, my_key_2);

-- Example 7993
SELECT my_key_1, my_key_2, SUM(cnt) FROM (
  SELECT
    my_key_1,
    my_key_2,
    BITMAP_COUNT(BITMAP_CONSTRUCT_AGG(BITMAP_BIT_POSITION(my_column))) cnt
  FROM my_table
  GROUP BY ROLLUP(my_key_1, my_key_2), BITMAP_BUCKET_NUMBER(my_column)
)
GROUP BY my_key_1, my_key_2;

-- Example 7994
CREATE TABLE precompute AS
SELECT
  my_dimension_1,
  my_dimension_2,
  BITMAP_BUCKET_NUMBER(my_column) bucket,
  BITMAP_CONSTRUCT_AGG(BITMAP_BIT_POSITION(my_column)) bmp
FROM my_table
GROUP BY 1, 2, 3;

-- Example 7995
SELECT
  my_dimension_1,
  my_dimension_2,
  SUM(BITMAP_COUNT(bmp))
FROM precompute
GROUP BY 1, 2;

-- Example 7996
SELECT my_dimension_1, SUM(cnt) FROM (
  SELECT
    my_dimension_1,
    BITMAP_COUNT(BITMAP_OR_AGG(bmp)) cnt
  FROM precompute
  GROUP BY 1, bucket
)
GROUP BY 1;

-- Example 7997
SELECT my_dimension_2, SUM(cnt) FROM (
  SELECT
    my_dimension_2,
    BITMAP_COUNT(BITMAP_OR_AGG(bmp)) cnt
  FROM precompute
  GROUP BY 1, bucket
)
GROUP BY 1;

-- Example 7998
SELECT TO_TIMESTAMP('2019-02-28T23:59:59', 'YYYY-MM-DD"T"HH24:MI:SS');

-- Example 7999
SELECT TO_TIMESTAMP('2019-02-2823:59:59 -07:00', 'YYYY-MM-DD HH24:MI:SS TZH:TZM');

-- Example 8000
SELECT TO_TIMESTAMP('2019-02-28 23:59:59.000000000 -07:00', 'YYYY-MM-DDHH24:MI:SS.FF TZH:TZM');

-- Example 8001
SELECT TO_TIMESTAMP('1487654321');

-- Example 8002
+-------------------------------+
| TO_TIMESTAMP('1487654321')    |
|-------------------------------|
| 2017-02-21 05:18:41.000000000 |
+-------------------------------+

-- Example 8003
SELECT TO_TIMESTAMP('1487654321321');

-- Example 8004
+-------------------------------+
| TO_TIMESTAMP('1487654321321') |
|-------------------------------|
| 2017-02-21 05:18:41.321000000 |
+-------------------------------+

-- Example 8005
SELECT TO_TIMESTAMP(column1) FROM VALUES ('2013-04-05'), ('1487654321');

-- Example 8006
+-------------------------+
| TO_TIMESTAMP(COLUMN1)   |
|-------------------------|
| 2013-04-05 00:00:00.000 |
| 2017-02-21 05:18:41.000 |
+-------------------------+

-- Example 8007
TO_TIMESTAMP(<value>, '<format>')

-- Example 8008
TO_TIMESTAMP(TO_NUMBER(<string_column>), <scale>)

-- Example 8009
CREATE OR REPLACE TABLE binary_table (v VARCHAR, b BINARY);

INSERT INTO binary_table (v, b)
  SELECT 'AB', TO_BINARY('AB');

SELECT v, b FROM binary_table;

-- Example 8010
+----+----+
| V  | B  |
|----+----|
| AB | AB |
+----+----+

-- Example 8011
CREATE OR REPLACE TABLE demo_binary_hex (b BINARY);

-- Example 8012
INSERT INTO demo_binary_hex (b) SELECT TO_BINARY('HELP', 'HEX');

-- Example 8013
100115 (22000): The following string is not a legal hex-encoded value: 'HELP'

-- Example 8014
INSERT INTO demo_binary_hex (b) SELECT TO_BINARY(HEX_ENCODE('HELP'), 'HEX');

-- Example 8015
SELECT TO_VARCHAR(b), HEX_DECODE_STRING(TO_VARCHAR(b)) FROM demo_binary_hex;

-- Example 8016
+---------------+----------------------------------+
| TO_VARCHAR(B) | HEX_DECODE_STRING(TO_VARCHAR(B)) |
|---------------+----------------------------------|
| 48454C50      | HELP                             |
+---------------+----------------------------------+

-- Example 8017
SELECT 'HELP',
       HEX_ENCODE('HELP'),
       b,
       HEX_DECODE_STRING(HEX_ENCODE('HELP')),
       TO_VARCHAR(b),
       HEX_DECODE_STRING(TO_VARCHAR(b))
  FROM demo_binary_hex;

-- Example 8018
+--------+--------------------+----------+---------------------------------------+---------------+----------------------------------+
| 'HELP' | HEX_ENCODE('HELP') | B        | HEX_DECODE_STRING(HEX_ENCODE('HELP')) | TO_VARCHAR(B) | HEX_DECODE_STRING(TO_VARCHAR(B)) |
|--------+--------------------+----------+---------------------------------------+---------------+----------------------------------|
| HELP   | 48454C50           | 48454C50 | HELP                                  | 48454C50      | HELP                             |
+--------+--------------------+----------+---------------------------------------+---------------+----------------------------------+

-- Example 8019
CREATE OR REPLACE TABLE demo_binary_base64 (b BINARY);

-- Example 8020
INSERT INTO demo_binary_base64 (b) SELECT TO_BINARY(BASE64_ENCODE('HELP'), 'BASE64');

