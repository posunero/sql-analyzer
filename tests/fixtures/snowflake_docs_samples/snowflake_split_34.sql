-- Example 2245
#test/test_sproc.py

def test_create_fact_tables(request, session):
    # Add conditional to include the patch if local testing is being used
    if request.config.getoption('--snowflake-session') == 'local':
        from patches import patch_monthname

    # No other changes required

-- Example 2246
pytest test/test_sproc.py --snowflake-session local

-- Example 2247
time pytest

-- Example 2248
=================================== test session starts ==========================
platform darwin -- Python 3.9.18, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/jfreeberg/Desktop/snowpark-testing-tutorial
configfile: pytest.ini
collected 4 items

test/test_sproc.py .                                                             [ 25%]
test/test_transformers.py ...                                                    [100%]

=================================== 4 passed in 6.86s =================================
pytest  1.63s user 1.86s system 44% cpu 7.893 total

-- Example 2249
time pytest --snowflake-session local

-- Example 2250
================================== test session starts ================================
platform darwin -- Python 3.9.18, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/jfreeberg/Desktop/snowpark-testing-tutorial
configfile: pytest.ini
collected 4 items

test/test_sproc.py .                                                             [ 25%]
test/test_transformers.py ...                                                    [100%]

=================================== 4 passed in 0.10s ==================================
pytest --snowflake-session local  1.37s user 1.70s system 281% cpu 1.093 total

-- Example 2251
CREATE OR REPLACE TABLE variant_insert (v VARIANT);
INSERT INTO variant_insert (v)
  SELECT PARSE_JSON('{"key3": "value3", "key4": "value4"}');
SELECT * FROM variant_insert;

-- Example 2252
+---------------------+
| V                   |
|---------------------|
| {                   |
|   "key3": "value3", |
|   "key4": "value4"  |
| }                   |
+---------------------+

-- Example 2253
CREATE OR REPLACE TABLE varia (float1 FLOAT, v VARIANT, float2 FLOAT);
INSERT INTO varia (float1, v, float2) VALUES (1.23, NULL, NULL);

-- Example 2254
UPDATE varia SET v = TO_VARIANT(float1);  -- converts from a FLOAT value to a VARIANT value.
UPDATE varia SET float2 = v::FLOAT;       -- converts from a VARIANT value to a FLOAT value.

-- Example 2255
SELECT * FROM varia;

-- Example 2256
+--------+-----------------------+--------+
| FLOAT1 | V                     | FLOAT2 |
|--------+-----------------------+--------|
|   1.23 | 1.230000000000000e+00 |   1.23 |
+--------+-----------------------+--------+

-- Example 2257
SELECT my_variant_column::FLOAT * 3.14 FROM ...;

-- Example 2258
SELECT my_variant_column * 3.14 FROM ...;

-- Example 2259
SELECT 'Sample', 'Sample'::VARIANT, 'Sample'::VARIANT::VARCHAR;

-- Example 2260
+----------+-------------------+----------------------------+
| 'SAMPLE' | 'SAMPLE'::VARIANT | 'SAMPLE'::VARIANT::VARCHAR |
|----------+-------------------+----------------------------|
| Sample   | "Sample"          | Sample                     |
+----------+-------------------+----------------------------+

-- Example 2261
SELECT OBJECT_CONSTRUCT(
  'name', 'Jones'::VARIANT,
  'age',  42::VARIANT);

-- Example 2262
CREATE OR REPLACE TABLE object_example (object_column OBJECT);
INSERT INTO object_example (object_column)
  SELECT OBJECT_CONSTRUCT('thirteen', 13::VARIANT, 'zero', 0::VARIANT);
SELECT * FROM object_example;

-- Example 2263
+-------------------+
| OBJECT_COLUMN     |
|-------------------|
| {                 |
|   "thirteen": 13, |
|   "zero": 0       |
| }                 |
+-------------------+

-- Example 2264
{ [<key>: <value> [, <key>: <value> , ...]] }

-- Example 2265
SELECT {*} FROM my_table;

SELECT {my_table1.*}
  FROM my_table1 INNER JOIN my_table2
    ON my_table2.col1 = my_table1.col1;

-- Example 2266
SELECT {* ILIKE 'col1%'} FROM my_table;

-- Example 2267
SELECT {* EXCLUDE col1} FROM my_table;

-- Example 2268
SELECT {* EXCLUDE (col1, col2)} FROM my_table;

-- Example 2269
SELECT {*, 'k': 'v'} FROM my_table;

-- Example 2270
SELECT {t1.*, t2.*} FROM t1, t2;

-- Example 2271
CREATE OR REPLACE TABLE my_object_table (my_object OBJECT);

INSERT INTO my_object_table (my_object)
  SELECT { 'PROVINCE': 'Alberta'::VARIANT , 'CAPITAL': 'Edmonton'::VARIANT };

INSERT INTO my_object_table (my_object)
  SELECT OBJECT_CONSTRUCT('PROVINCE', 'Manitoba'::VARIANT , 'CAPITAL', 'Winnipeg'::VARIANT );

SELECT * FROM my_object_table;

-- Example 2272
+--------------------------+
| MY_OBJECT                |
|--------------------------|
| {                        |
|   "CAPITAL": "Edmonton", |
|   "PROVINCE": "Alberta"  |
| }                        |
| {                        |
|   "CAPITAL": "Winnipeg", |
|   "PROVINCE": "Manitoba" |
| }                        |
+--------------------------+

-- Example 2273
CREATE OR REPLACE TABLE demo_ca_provinces (province VARCHAR, capital VARCHAR);
INSERT INTO demo_ca_provinces (province, capital) VALUES
  ('Ontario', 'Toronto'),
  ('British Columbia', 'Victoria');

SELECT province, capital
  FROM demo_ca_provinces
  ORDER BY province;

-- Example 2274
+------------------+----------+
| PROVINCE         | CAPITAL  |
|------------------+----------|
| British Columbia | Victoria |
| Ontario          | Toronto  |
+------------------+----------+

-- Example 2275
INSERT INTO my_object_table (my_object)
  SELECT {*} FROM demo_ca_provinces;

SELECT * FROM my_object_table;

-- Example 2276
+----------------------------------+
| MY_OBJECT                        |
|----------------------------------|
| {                                |
|   "CAPITAL": "Edmonton",         |
|   "PROVINCE": "Alberta"          |
| }                                |
| {                                |
|   "CAPITAL": "Winnipeg",         |
|   "PROVINCE": "Manitoba"         |
| }                                |
| {                                |
|   "CAPITAL": "Toronto",          |
|   "PROVINCE": "Ontario"          |
| }                                |
| {                                |
|   "CAPITAL": "Victoria",         |
|   "PROVINCE": "British Columbia" |
| }                                |
+----------------------------------+

-- Example 2277
SET my_variable = 10;
SELECT {'key1': $my_variable+1, 'key2': $my_variable+2};

-- Example 2278
+--------------------------------------------------+
| {'KEY1': $MY_VARIABLE+1, 'KEY2': $MY_VARIABLE+2} |
|--------------------------------------------------|
| {                                                |
|   "key1": 11,                                    |
|   "key2": 12                                     |
| }                                                |
+--------------------------------------------------+

-- Example 2279
SELECT { 'Manitoba': 'Winnipeg' } AS province_capital;

-- Example 2280
+--------------------------+
| PROVINCE_CAPITAL         |
|--------------------------|
| {                        |
|   "Manitoba": "Winnipeg" |
| }                        |
+--------------------------+

-- Example 2281
SELECT object_column['thirteen'] FROM object_example;

-- Example 2282
SELECT object_column['thirteen'],
       object_column:thirteen
  FROM object_example;

-- Example 2283
+---------------------------+------------------------+
| OBJECT_COLUMN['THIRTEEN'] | OBJECT_COLUMN:THIRTEEN |
|---------------------------+------------------------|
| 13                        | 13                     |
+---------------------------+------------------------+

-- Example 2284
CREATE OR REPLACE TABLE array_example (array_column ARRAY);
INSERT INTO array_example (array_column)
  SELECT ARRAY_CONSTRUCT(12, 'twelve', NULL);

-- Example 2285
[<value> [, <value> , ...]]

-- Example 2286
INSERT INTO array_example (array_column)
  SELECT [ 12, 'twelve', NULL ];

-- Example 2287
UPDATE my_table SET my_array = [ 1, 2 ];

UPDATE my_table SET my_array = ARRAY_CONSTRUCT(1, 2);

-- Example 2288
SET my_variable = 10;
SELECT [$my_variable+1, $my_variable+2];

-- Example 2289
+----------------------------------+
| [$MY_VARIABLE+1, $MY_VARIABLE+2] |
|----------------------------------|
| [                                |
|   11,                            |
|   12                             |
| ]                                |
+----------------------------------+

-- Example 2290
SELECT [ 'Alberta', 'Manitoba' ] AS province;

-- Example 2291
+--------------+
| PROVINCE     |
|--------------|
| [            |
|   "Alberta", |
|   "Manitoba" |
| ]            |
+--------------+

-- Example 2292
SELECT my_array_column[2] FROM my_table;

-- Example 2293
SELECT my_array_column[0][0] FROM my_table;

-- Example 2294
SELECT ARRAY_SLICE(my_array_column, 5, 10) FROM my_table;

-- Example 2295
[ undefined, undefined ]

-- Example 2296
SELECT ARRAY_SLICE(array_column, 6, 8) FROM table_1;

-- Example 2297
+---------------------------------+
| array_slice(array_column, 6, 8) |
+---------------------------------+
| [ ]                             |
+---------------------------------+

-- Example 2298
CREATE OR REPLACE TABLE test_semi_structured(
  var VARIANT,
  arr ARRAY,
  obj OBJECT);

DESC TABLE test_semi_structured;

-- Example 2299
+------+---------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type    | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+---------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| VAR  | VARIANT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| ARR  | ARRAY   | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| OBJ  | OBJECT  | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+---------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 2300
CREATE OR REPLACE TABLE demonstration1 (
  ID INTEGER,
  array1 ARRAY,
  variant1 VARIANT,
  object1 OBJECT);

INSERT INTO demonstration1 (id, array1, variant1, object1)
  SELECT
    1,
    ARRAY_CONSTRUCT(1, 2, 3),
    PARSE_JSON(' { "key1": "value1", "key2": "value2" } '),
    PARSE_JSON(' { "outer_key1": { "inner_key1A": "1a", "inner_key1B": "1b" }, '
              ||
               '   "outer_key2": { "inner_key2": 2 } } ');

INSERT INTO demonstration1 (id, array1, variant1, object1)
  SELECT
    2,
    ARRAY_CONSTRUCT(1, 2, 3, NULL),
    PARSE_JSON(' { "key1": "value1", "key2": NULL } '),
    PARSE_JSON(' { "outer_key1": { "inner_key1A": "1a", "inner_key1B": NULL }, '
              ||
                '   "outer_key2": { "inner_key2": 2 } '
              ||
               ' } ');

-- Example 2301
SELECT *
  FROM demonstration1
  ORDER BY id;

-- Example 2302
+----+-------------+---------------------+--------------------------+
| ID | ARRAY1      | VARIANT1            | OBJECT1                  |
|----+-------------+---------------------+--------------------------|
|  1 | [           | {                   | {                        |
|    |   1,        |   "key1": "value1", |   "outer_key1": {        |
|    |   2,        |   "key2": "value2"  |     "inner_key1A": "1a", |
|    |   3         | }                   |     "inner_key1B": "1b"  |
|    | ]           |                     |   },                     |
|    |             |                     |   "outer_key2": {        |
|    |             |                     |     "inner_key2": 2      |
|    |             |                     |   }                      |
|    |             |                     | }                        |
|  2 | [           | {                   | {                        |
|    |   1,        |   "key1": "value1", |   "outer_key1": {        |
|    |   2,        |   "key2": null      |     "inner_key1A": "1a", |
|    |   3,        | }                   |     "inner_key1B": null  |
|    |   undefined |                     |   },                     |
|    | ]           |                     |   "outer_key2": {        |
|    |             |                     |     "inner_key2": 2      |
|    |             |                     |   }                      |
|    |             |                     | }                        |
+----+-------------+---------------------+--------------------------+

-- Example 2303
ARRAY( <element_type> [ NOT NULL ] )

-- Example 2304
SELECT
  SYSTEM$TYPEOF(
    [1, 2, 3]::ARRAY(NUMBER)
  ) AS structured_array,
  SYSTEM$TYPEOF(
    [1, 2, 3]
  ) AS semi_structured_array;

-- Example 2305
+-------------------------------+-----------------------+
| STRUCTURED_ARRAY              | SEMI_STRUCTURED_ARRAY |
|-------------------------------+-----------------------|
| ARRAY(NUMBER(38,0))[LOB]      | ARRAY[LOB]            |
+-------------------------------+-----------------------+

-- Example 2306
OBJECT(
  [
    <key> <value_type> [ NOT NULL ]
    [ , <key> <value_type> [ NOT NULL ] ]
    [ , ... ]
  ]
)

-- Example 2307
SELECT
  SYSTEM$TYPEOF(
    {
      'str': 'test',
      'num': 1
    }::OBJECT(
      str VARCHAR NOT NULL,
      num NUMBER
    )
  ) AS structured_object,
  SYSTEM$TYPEOF(
    {
      'str': 'test',
      'num': 1
    }
  ) AS semi_structured_object;

-- Example 2308
+---------------------------------------------------------------+------------------------+
| STRUCTURED_OBJECT                                             | SEMI_STRUCTURED_OBJECT |
|---------------------------------------------------------------+------------------------|
| OBJECT(str VARCHAR(16777216) NOT NULL, num NUMBER(38,0))[LOB] | OBJECT[LOB]            |
+---------------------------------------------------------------+------------------------+

-- Example 2309
MAP( <key_type> , <value_type> [ NOT NULL ] )

-- Example 2310
SELECT
  SYSTEM$TYPEOF(
    {
      'a_key': 'a_val',
      'b_key': 'b_val'
    }::MAP(VARCHAR, VARCHAR)
  ) AS map_example;

-- Example 2311
+------------------------------------------------+
| MAP_EXAMPLE                                    |
|------------------------------------------------|
| MAP(VARCHAR(16777216), VARCHAR(16777216))[LOB] |
+------------------------------------------------+

-- Example 2312
SELECT
  SYSTEM$TYPEOF(
    CAST ([1,2,3] AS ARRAY(NUMBER))
  ) AS array_cast_type,
  SYSTEM$TYPEOF(
    CAST ([1,2,3]::VARIANT AS ARRAY(NUMBER))
  ) AS variant_cast_type;

