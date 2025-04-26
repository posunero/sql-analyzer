-- Example 7351
TO_ARRAY( <expr> )

-- Example 7352
CREATE TABLE array_demo_2 (ID INTEGER, array1 ARRAY, array2 ARRAY);

-- Example 7353
INSERT INTO array_demo_2 (ID, array1, array2) 
    SELECT 1, TO_ARRAY(1), TO_ARRAY(3);

-- Example 7354
SELECT array1, array2, ARRAY_CAT(array1, array2) FROM array_demo_2;
+--------+--------+---------------------------+
| ARRAY1 | ARRAY2 | ARRAY_CAT(ARRAY1, ARRAY2) |
|--------+--------+---------------------------|
| [      | [      | [                         |
|   1    |   3    |   1,                      |
| ]      | ]      |   3                       |
|        |        | ]                         |
+--------+--------+---------------------------+

-- Example 7355
TO_BINARY( <string_expr> [, '<format>'] )
TO_BINARY( <variant_expr> )

-- Example 7356
CREATE TABLE binary_test (v VARCHAR, b BINARY);
INSERT INTO binary_test(v) VALUES ('SNOW');

-- Example 7357
UPDATE binary_test SET b = TO_BINARY(HEX_ENCODE(v), 'HEX');

-- Example 7358
SELECT v, HEX_DECODE_STRING(TO_VARCHAR(b, 'HEX')) FROM binary_test;
+------+-----------------------------------------+
| V    | HEX_DECODE_STRING(TO_VARCHAR(B, 'HEX')) |
|------+-----------------------------------------|
| SNOW | SNOW                                    |
+------+-----------------------------------------+

-- Example 7359
SELECT TO_BINARY('SNOW', 'utf-8');
+----------------------------+
| TO_BINARY('SNOW', 'UTF-8') |
|----------------------------|
| 534E4F57                   |
+----------------------------+

-- Example 7360
SELECT TO_VARCHAR(TO_BINARY('SNOW', 'utf-8'), 'HEX');
+-----------------------------------------------+
| TO_VARCHAR(TO_BINARY('SNOW', 'UTF-8'), 'HEX') |
|-----------------------------------------------|
| 534E4F57                                      |
+-----------------------------------------------+

-- Example 7361
TO_BOOLEAN( <string_or_numeric_expr> )

-- Example 7362
CREATE OR REPLACE TABLE test_boolean(
  b BOOLEAN,
  n NUMBER,
  s STRING);

INSERT INTO test_boolean VALUES
  (true, 1, 'yes'),
  (false, 0, 'no'),
  (null, null, null);

SELECT * FROM test_boolean;

-- Example 7363
+-------+------+------+
| B     |    N | S    |
|-------+------+------|
| True  |    1 | yes  |
| False |    0 | no   |
| NULL  | NULL | NULL |
+-------+------+------+

-- Example 7364
SELECT s, TO_BOOLEAN(s) FROM test_boolean;

-- Example 7365
+------+---------------+
| S    | TO_BOOLEAN(S) |
|------+---------------|
| yes  | True          |
| no   | False         |
| NULL | NULL          |
+------+---------------+

-- Example 7366
SELECT n, TO_BOOLEAN(n) FROM test_boolean;

-- Example 7367
+------+---------------+
|    N | TO_BOOLEAN(N) |
|------+---------------|
|    1 | True          |
|    0 | False         |
| NULL | NULL          |
+------+---------------+

-- Example 7368
TO_DATE( <string_expr> [, <format> ] )
TO_DATE( <timestamp_expr> )
TO_DATE( '<integer>' )
TO_DATE( <variant_expr> )

DATE( <string_expr> [, <format> ] )
DATE( <timestamp_expr> )
DATE( '<integer>' )
DATE( <variant_expr> )

-- Example 7369
SELECT TO_DATE('2024-05-10'), DATE('2024-05-10');

-- Example 7370
+-----------------------+--------------------+
| TO_DATE('2024-05-10') | DATE('2024-05-10') |
|-----------------------+--------------------|
| 2024-05-10            | 2024-05-10         |
+-----------------------+--------------------+

-- Example 7371
CREATE OR REPLACE TABLE date_from_timestamp(ts TIMESTAMP);

INSERT INTO date_from_timestamp(ts)
  VALUES (TO_TIMESTAMP('2024.10.02 04:00:00', 'YYYY.MM.DD HH:MI:SS'));

-- Example 7372
SELECT ts FROM date_from_timestamp;

-- Example 7373
+-------------------------+
| TS                      |
|-------------------------|
| 2024-10-02 04:00:00.000 |
+-------------------------+

-- Example 7374
SELECT TO_DATE(ts) FROM date_from_timestamp;

-- Example 7375
+-------------+
| TO_DATE(TS) |
|-------------|
| 2024-10-02  |
+-------------+

-- Example 7376
SELECT TO_DATE('2024.05.10', 'YYYY.MM.DD'), DATE('2024.05.10', 'YYYY.MM.DD');

-- Example 7377
+-------------------------------------+----------------------------------+
| TO_DATE('2024.05.10', 'YYYY.MM.DD') | DATE('2024.05.10', 'YYYY.MM.DD') |
|-------------------------------------+----------------------------------|
| 2024-05-10                          | 2024-05-10                       |
+-------------------------------------+----------------------------------+

-- Example 7378
SELECT TO_DATE('2024-05-10', 'AUTO'), DATE('2024-05-10', 'AUTO');

-- Example 7379
+-------------------------------+----------------------------+
| TO_DATE('2024-05-10', 'AUTO') | DATE('2024-05-10', 'AUTO') |
|-------------------------------+----------------------------|
| 2024-05-10                    | 2024-05-10                 |
+-------------------------------+----------------------------+

-- Example 7380
SELECT TO_DATE('05/10/2024', 'MM/DD/YYYY'), DATE('05/10/2024', 'MM/DD/YYYY');

-- Example 7381
+-------------------------------------+----------------------------------+
| TO_DATE('05/10/2024', 'MM/DD/YYYY') | DATE('05/20/2024', 'MM/DD/YYYY') |
|-------------------------------------+----------------------------------|
| 2024-05-10                          | 2024-05-20                       |
+-------------------------------------+----------------------------------+

-- Example 7382
ALTER SESSION SET DATE_OUTPUT_FORMAT = 'DD-MON-YYYY';

-- Example 7383
SELECT TO_DATE('2024-05-10', 'YYYY-MM-DD'), DATE('2024-05-10', 'YYYY-MM-DD');

-- Example 7384
+-------------------------------------+----------------------------------+
| TO_DATE('2024-05-10', 'YYYY-MM-DD') | DATE('2024-05-10', 'YYYY-MM-DD') |
|-------------------------------------+----------------------------------|
| 10-May-2024                         | 10-May-2024                      |
+-------------------------------------+----------------------------------+

-- Example 7385
SELECT TO_DATE('05/10/2024', 'MM/DD/YYYY'), DATE('05/10/2024', 'MM/DD/YYYY');

-- Example 7386
+-------------------------------------+----------------------------------+
| TO_DATE('05/10/2024', 'MM/DD/YYYY') | DATE('05/10/2024', 'MM/DD/YYYY') |
|-------------------------------------+----------------------------------|
| 10-May-2024                         | 10-May-2024                      |
+-------------------------------------+----------------------------------+

-- Example 7387
CREATE OR REPLACE TABLE demo1 (
  description VARCHAR,
  value VARCHAR -- string rather than bigint
);

INSERT INTO demo1 (description, value) VALUES
  ('Seconds',      '31536000'),
  ('Milliseconds', '31536000000'),
  ('Microseconds', '31536000000000'),
  ('Nanoseconds',  '31536000000000000');

-- Example 7388
SELECT description,
       value,
       TO_TIMESTAMP(value),
       TO_DATE(value)
  FROM demo1
  ORDER BY value;

-- Example 7389
+--------------+-------------------+-------------------------+----------------+
| DESCRIPTION  | VALUE             | TO_TIMESTAMP(VALUE)     | TO_DATE(VALUE) |
|--------------+-------------------+-------------------------+----------------|
| Seconds      | 31536000          | 1971-01-01 00:00:00.000 | 1971-01-01     |
| Milliseconds | 31536000000       | 1971-01-01 00:00:00.000 | 1971-01-01     |
| Microseconds | 31536000000000    | 1971-01-01 00:00:00.000 | 1971-01-01     |
| Nanoseconds  | 31536000000000000 | 1971-01-01 00:00:00.000 | 1971-01-01     |
+--------------+-------------------+-------------------------+----------------+

-- Example 7390
TO_DECIMAL( <expr> [, '<format>' ] [, <precision> [, <scale> ] ] )

TO_NUMBER( <expr> [, '<format>' ] [, <precision> [, <scale> ] ] )

TO_NUMERIC( <expr> [, '<format>' ] [, <precision> [, <scale> ] ] )

-- Example 7391
CREATE OR REPLACE TABLE number_conv(expr VARCHAR);
INSERT INTO number_conv VALUES ('12.3456'), ('98.76546');

SELECT expr,
       TO_NUMBER(expr),
       TO_NUMBER(expr, 10, 1),
       TO_NUMBER(expr, 10, 8)
  FROM number_conv;

-- Example 7392
+----------+-----------------+------------------------+------------------------+
| EXPR     | TO_NUMBER(EXPR) | TO_NUMBER(EXPR, 10, 1) | TO_NUMBER(EXPR, 10, 8) |
|----------+-----------------+------------------------+------------------------|
| 12.3456  |              12 |                   12.3 |            12.34560000 |
| 98.76546 |              99 |                   98.8 |            98.76546000 |
+----------+-----------------+------------------------+------------------------+

-- Example 7393
SELECT expr, TO_NUMBER(expr, 10, 9) FROM number_conv;

-- Example 7394
100039 (22003): Numeric value '12.3456' is out of range

-- Example 7395
SELECT column1,
       TO_DECIMAL(column1, '99.9') as D0,
       TO_DECIMAL(column1, '99.9', 9, 5) as D5,
       TO_DECIMAL(column1, 'TM9', 9, 5) as TD5
  FROM VALUES ('1.0'), ('-12.3'), ('0.0'), ('- 0.1');

-- Example 7396
+---------+-----+-----------+-----------+
| COLUMN1 |  D0 |        D5 |       TD5 |
|---------+-----+-----------+-----------|
| 1.0     |   1 |   1.00000 |   1.00000 |
| -12.3   | -12 | -12.30000 | -12.30000 |
| 0.0     |   0 |   0.00000 |   0.00000 |
| - 0.1   |   0 |  -0.10000 |  -0.10000 |
+---------+-----+-----------+-----------+

-- Example 7397
SELECT column1,
       TO_DECIMAL(column1, '9,999.99', 6, 2) as convert_number
  FROM VALUES ('3,741.72');

-- Example 7398
+----------+----------------+
| COLUMN1  | CONVERT_NUMBER |
|----------+----------------|
| 3,741.72 |        3741.72 |
+----------+----------------+

-- Example 7399
SELECT column1,
       TO_DECIMAL(column1, '$9,999.99', 6, 2) as convert_currency
  FROM VALUES ('$3,741.72');

-- Example 7400
+-----------+------------------+
| COLUMN1   | CONVERT_CURRENCY |
|-----------+------------------|
| $3,741.72 |          3741.72 |
+-----------+------------------+

-- Example 7401
SELECT TO_DECIMAL('ae5', 'XXX');

-- Example 7402
+--------------------------+
| TO_DECIMAL('AE5', 'XXX') |
|--------------------------|
|                     2789 |
+--------------------------+

-- Example 7403
SELECT TO_DECIMAL('ae5', 'XX');

-- Example 7404
100140 (22007): Can't parse 'ae5' as number with format 'XX'

-- Example 7405
TO_DOUBLE( <expr> [, '<format>' ] )

-- Example 7406
CREATE OR REPLACE TABLE double_demo (d DECIMAL(7, 2), v VARCHAR, o VARIANT);
INSERT INTO double_demo (d, v, o) SELECT 1.1, '2.2', TO_VARIANT(3.14);
SELECT TO_DOUBLE(d), TO_DOUBLE(v), TO_DOUBLE(o) FROM double_demo;

-- Example 7407
+--------------+--------------+--------------+
| TO_DOUBLE(D) | TO_DOUBLE(V) | TO_DOUBLE(O) |
|--------------+--------------+--------------|
|          1.1 |          2.2 |         3.14 |
+--------------+--------------+--------------+

-- Example 7408
SELECT TO_DOUBLE(1.1)::NUMBER(38, 18);

-- Example 7409
+--------------------------------+
| TO_DOUBLE(1.1)::NUMBER(38, 18) |
|--------------------------------|
|           1.100000000000000089 |
+--------------------------------+

-- Example 7410
TO_FILE( <stage_name>, <relative_path> )

TO_FILE( <file_url> )

TO_FILE( <metadata> )

-- Example 7411
SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

-- Example 7412
+--------------------------------------------------------------------------------------------------------------------+
| TO_FILE(BUILD_STAGE_FILE_URL('@MYSTAGE', 'IMAGE.PNG'))                                                             |
|--------------------------------------------------------------------------------------------------------------------|
| {                                                                                                                  |
|   "CONTENT_TYPE": "image/png",                                                                                     |
|   "ETAG": "..."                                                                                                    |
|   "LAST_MODIFIED": "Wed, 11 Dec 2024 20:24:00 GMT",                                                                |
|   "RELATIVE_PATH": "image.png",                                                                                    |
|   "SIZE": 105859,                                                                                                  |
|   "STAGE": "@MYDB.MYSCHEMA.MYSTAGE",                                                                               |
|   "STAGE_FILE_URL": "https://snowflake.account.snowflakecomputing.com/api/files/MYDB/MYSCHEMA/MYSTAGE/image.png"   |
| }                                                                                                                  |
+--------------------------------------------------------------------------------------------------------------------+

-- Example 7413
SELECT TO_FILE(file_url) FROM DIRECTORY(@mystage) LIMIT 1;

-- Example 7414
+--------------------------------------------------------------------------------------------------------------------+
| TO_FILE(FILE_URL)                                                                                                  |
|--------------------------------------------------------------------------------------------------------------------|
| {                                                                                                                  |
|   "CONTENT_TYPE": "image/png",                                                                                     |
|   "ETAG": "..."                                                                                                    |
|   "LAST_MODIFIED": "Wed, 11 Dec 2024 20:24:00 GMT",                                                                |
|   "RELATIVE_PATH": "image.png",                                                                                    |
|   "SIZE": 105859,                                                                                                  |
|   "STAGE": "@MYDB.MYSCHEMA.MYSTAGE",                                                                               |
|   "STAGE_FILE_URL": "https://snowflake.account.snowflakecomputing.com/api/files/MYDB/MYSCHEMA/MYSTAGE/image.png"   |
| }                                                                                                                  |
+--------------------------------------------------------------------------------------------------------------------+

-- Example 7415
SELECT TO_FILE(`https://snowflake.account.snowflakecomputing.com/api/files/01ba4df2-0100-0001-0000-00040002e2b6/299017/Y6JShH6KjV`);

+------------------------------------------------------------------------------------------------------------------------------------------------+
| TO_FILE(https://snowflake.account.snowflakecomputing.com/api/files/01ba4df2-0100-0001-0000-00040002e2b6/299017/Y6JShH6KjV                      |
|------------------------------------------------------------------------------------------------------------------------------------------------|
| {                                                                                                                                              |
|   "CONTENT_TYPE": "image/png",                                                                                                                 |
|   "ETAG": "..."                                                                                                                                |
|   "LAST_MODIFIED": "Wed, 11 Dec 2024 20:24:00 GMT",                                                                                            |
|   "SCOPED_FILE_URL": "https://snowflake.account.snowflakecomputing.com/api/files/01ba4df2-0100-0001-0000-00040002e2b6/299017/Y6JShH6KjV",      |
|   "SIZE": 105859                                                                                                                               |
| }                                                                                                                                              |
+-----------------------------------------------------------------------------------------------------------------------------------------------+|

-- Example 7416
SELECT TO_FILE(OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'image.png', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/png'));

+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| TO_FILE(OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'IMAGE.PNG', 'ETAG', '<ETAG value>', 'LAST_MODIFIED', 'WED, 11 DEC 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'IMAGE/PNG')) |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| {                                                                                                                                                                                                  |
|   "CONTENT_TYPE": "image/png",                                                                                                                                                                     |
|   "ETAG": "<ETAG value>>"                                                                                                                                                                          |
|   "LAST_MODIFIED": "Wed, 11 Dec 2024 20:24:00 GMT",                                                                                                                                                |
|   "RELATIVE_PATH": "image.png",                                                                                                                                                                    |
|   "SIZE": 105859,                                                                                                                                                                                  |
|   "STAGE": "@MYDB.MYSCHEMA.MYSTAGE"                                                                                                                                                                |
| }                                                                                                                                                                                                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 7417
TO_GEOGRAPHY( <varchar_expression> [ , <allow_invalid> ] )

TO_GEOGRAPHY( <binary_expression> [ , <allow_invalid> ] )

TO_GEOGRAPHY( <variant_expression> [ , <allow_invalid> ] )

TO_GEOGRAPHY( <geometry_expression> [ , <allow_invalid> ] )

