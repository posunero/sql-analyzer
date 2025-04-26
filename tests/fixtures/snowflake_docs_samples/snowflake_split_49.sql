-- Example 3265
UPDATE array_append_examples
  SET array_column = ARRAY_APPEND(array_column, 4);

-- Example 3266
SELECT * FROM array_append_examples;

-- Example 3267
+--------------+
| ARRAY_COLUMN |
|--------------|
| [            |
|   1,         |
|   2,         |
|   3,         |
|   4          |
| ]            |
+--------------+

-- Example 3268
UPDATE array_append_examples
  SET array_column = ARRAY_APPEND(array_column, 'five');

-- Example 3269
SELECT array_column,
       ARRAY_CONSTRUCT(
        TYPEOF(array_column[0]),
        TYPEOF(array_column[1]),
        TYPEOF(array_column[2]),
        TYPEOF(array_column[3]),
        TYPEOF(array_column[4])) AS type
  FROM array_append_examples;

-- Example 3270
+--------------+--------------+
| ARRAY_COLUMN | TYPE         |
|--------------+--------------|
| [            | [            |
|   1,         |   "INTEGER", |
|   2,         |   "INTEGER", |
|   3,         |   "INTEGER", |
|   4,         |   "INTEGER", |
|   "five"     |   "VARCHAR"  |
| ]            | ]            |
+--------------+--------------+

-- Example 3271
ARRAY_CAT( <array1> , <array2> )

-- Example 3272
CREATE TABLE array_demo (ID INTEGER, array1 ARRAY, array2 ARRAY);

-- Example 3273
INSERT INTO array_demo (ID, array1, array2) 
    SELECT 1, ARRAY_CONSTRUCT(1, 2), ARRAY_CONSTRUCT(3, 4);

-- Example 3274
SELECT ARRAY_CAT(array1, array2) FROM array_demo;
+---------------------------+
| ARRAY_CAT(ARRAY1, ARRAY2) |
|---------------------------|
| [                         |
|   1,                      |
|   2,                      |
|   3,                      |
|   4                       |
| ]                         |
+---------------------------+

-- Example 3275
ARRAY_COMPACT( <array1> )

-- Example 3276
CREATE TABLE array_demo (ID INTEGER, array1 ARRAY, array2 ARRAY);

-- Example 3277
INSERT INTO array_demo (ID, array1, array2) 
    SELECT 2, ARRAY_CONSTRUCT(10, NULL, 30), ARRAY_CONSTRUCT(40);

-- Example 3278
SELECT array1, ARRAY_COMPACT(array1) FROM array_demo WHERE ID = 2;
+--------------+-----------------------+
| ARRAY1       | ARRAY_COMPACT(ARRAY1) |
|--------------+-----------------------|
| [            | [                     |
|   10,        |   10,                 |
|   undefined, |   30                  |
|   30         | ]                     |
| ]            |                       |
+--------------+-----------------------+

-- Example 3279
ARRAY_CONSTRUCT( [ <expr1> ] [ , <expr2> [ , ... ] ] )

-- Example 3280
SELECT ARRAY_CONSTRUCT(10, 20, 30);

-- Example 3281
+-----------------------------+
| ARRAY_CONSTRUCT(10, 20, 30) |
|-----------------------------|
| [                           |
|   10,                       |
|   20,                       |
|   30                        |
| ]                           |
+-----------------------------+

-- Example 3282
SELECT ARRAY_CONSTRUCT(NULL, PARSE_JSON('null'), 'hello', 3::DOUBLE, 4, 5);

-- Example 3283
+---------------------------------------------------------------------+
| ARRAY_CONSTRUCT(NULL, PARSE_JSON('NULL'), 'HELLO', 3::DOUBLE, 4, 5) |
|---------------------------------------------------------------------|
| [                                                                   |
|   undefined,                                                        |
|   null,                                                             |
|   "hello",                                                          |
|   3.000000000000000e+00,                                            |
|   4,                                                                |
|   5                                                                 |
| ]                                                                   |
+---------------------------------------------------------------------+

-- Example 3284
SELECT ARRAY_CONSTRUCT();

-- Example 3285
+-------------------+
| ARRAY_CONSTRUCT() |
|-------------------|
| []                |
+-------------------+

-- Example 3286
CREATE OR REPLACE TABLE construct_array_example (id INT, array_column ARRAY);

INSERT INTO construct_array_example (id, array_column)
  SELECT 1,
         ARRAY_CONSTRUCT(1, 2, 3);

INSERT INTO construct_array_example (id, array_column)
  SELECT 2,
         ARRAY_CONSTRUCT(4, 5, 6);

INSERT INTO construct_array_example (id, array_column)
  SELECT 3,
         ARRAY_CONSTRUCT(7, 8, 9);

SELECT * FROM construct_array_example;

-- Example 3287
+----+--------------+
| ID | ARRAY_COLUMN |
|----+--------------|
|  1 | [            |
|    |   1,         |
|    |   2,         |
|    |   3          |
|    | ]            |
|  2 | [            |
|    |   4,         |
|    |   5,         |
|    |   6          |
|    | ]            |
|  3 | [            |
|    |   7,         |
|    |   8,         |
|    |   9          |
|    | ]            |
+----+--------------+

-- Example 3288
ARRAY_CONSTRUCT_COMPACT( [ <expr1> ] [ , <expr2> [ , ... ] ] )

-- Example 3289
SELECT ARRAY_CONSTRUCT_COMPACT(null,'hello',3::double,4,5);
+-----------------------------------------------------+
| ARRAY_CONSTRUCT_COMPACT(NULL,'HELLO',3::DOUBLE,4,5) |
|-----------------------------------------------------|
| [                                                   |
|   "hello",                                          |
|   3.000000000000000e+00,                            |
|   4,                                                |
|   5                                                 |
| ]                                                   |
+-----------------------------------------------------+

-- Example 3290
ARRAY_CONTAINS( <value_expr> , <array> )

-- Example 3291
SELECT ARRAY_CONTAINS('hello'::VARIANT, ARRAY_CONSTRUCT('hello', 'hi'));

-- Example 3292
+------------------------------------------------------------------+
| ARRAY_CONTAINS('HELLO'::VARIANT, ARRAY_CONSTRUCT('HELLO', 'HI')) |
|------------------------------------------------------------------|
| True                                                             |
+------------------------------------------------------------------+

-- Example 3293
SELECT ARRAY_CONTAINS('hello'::VARIANT, ARRAY_CONSTRUCT('hola', 'bonjour'));

-- Example 3294
+----------------------------------------------------------------------+
| ARRAY_CONTAINS('HELLO'::VARIANT, ARRAY_CONSTRUCT('HOLA', 'BONJOUR')) |
|----------------------------------------------------------------------|
| False                                                                |
+----------------------------------------------------------------------+

-- Example 3295
SELECT ARRAY_CONTAINS(NULL, ARRAY_CONSTRUCT('hola', 'bonjour'));

-- Example 3296
+----------------------------------------------------------+
| ARRAY_CONTAINS(NULL, ARRAY_CONSTRUCT('HOLA', 'BONJOUR')) |
|----------------------------------------------------------|
| NULL                                                     |
+----------------------------------------------------------+

-- Example 3297
SELECT ARRAY_CONTAINS(NULL, ARRAY_CONSTRUCT('hola', NULL));

-- Example 3298
+-----------------------------------------------------+
| ARRAY_CONTAINS(NULL, ARRAY_CONSTRUCT('HOLA', NULL)) |
|-----------------------------------------------------|
| True                                                |
+-----------------------------------------------------+

-- Example 3299
SELECT ARRAY_CONTAINS(PARSE_JSON('null'), ARRAY_CONSTRUCT('hola', PARSE_JSON('null')));

-- Example 3300
+---------------------------------------------------------------------------------+
| ARRAY_CONTAINS(PARSE_JSON('NULL'), ARRAY_CONSTRUCT('HOLA', PARSE_JSON('NULL'))) |
|---------------------------------------------------------------------------------|
| True                                                                            |
+---------------------------------------------------------------------------------+

-- Example 3301
SELECT ARRAY_CONTAINS(NULL, ARRAY_CONSTRUCT('hola', PARSE_JSON('null')));

-- Example 3302
+-------------------------------------------------------------------+
| ARRAY_CONTAINS(NULL, ARRAY_CONSTRUCT('HOLA', PARSE_JSON('NULL'))) |
|-------------------------------------------------------------------|
| NULL                                                              |
+-------------------------------------------------------------------+

-- Example 3303
CREATE OR REPLACE TABLE array_example (id INT, array_column ARRAY);

INSERT INTO array_example (id, array_column)
  SELECT 1, ARRAY_CONSTRUCT(1, 2, 3);

INSERT INTO array_example (id, array_column)
  SELECT 2, ARRAY_CONSTRUCT(4, 5, 6);

SELECT * FROM array_example;

-- Example 3304
+----+--------------+
| ID | ARRAY_COLUMN |
|----+--------------|
|  1 | [            |
|    |   1,         |
|    |   2,         |
|    |   3          |
|    | ]            |
|  2 | [            |
|    |   4,         |
|    |   5,         |
|    |   6          |
|    | ]            |
+----+--------------+

-- Example 3305
SELECT * FROM array_example WHERE ARRAY_CONTAINS(5, array_column);

-- Example 3306
+----+--------------+
| ID | ARRAY_COLUMN |
|----+--------------|
|  2 | [            |
|    |   4,         |
|    |   5,         |
|    |   6          |
|    | ]            |
+----+--------------+

-- Example 3307
ARRAY_DISTINCT( <array> )

-- Example 3308
SELECT ARRAY_DISTINCT(['A', 'A', 'B', NULL, NULL]);

+---------------------------------------------+
| ARRAY_DISTINCT(['A', 'A', 'B', NULL, NULL]) |
|---------------------------------------------|
| [                                           |
|   "A",                                      |
|   "B",                                      |
|   undefined                                 |
| ]                                           |
+---------------------------------------------+

-- Example 3309
SELECT ARRAY_DISTINCT(NULL);

+----------------------+
| ARRAY_DISTINCT(NULL) |
|----------------------|
| NULL                 |
+----------------------+

-- Example 3310
SELECT ARRAY_DISTINCT( [ {'a': 1, 'b': 2}, {'a': 1, 'b': 2}, {'a': 1, 'b': 3} ] );

+----------------------------------------------------------------------------+
| ARRAY_DISTINCT( [ {'A': 1, 'B': 2}, {'A': 1, 'B': 2}, {'A': 1, 'B': 3} ] ) |
|----------------------------------------------------------------------------|
| [                                                                          |
|   {                                                                        |
|     "a": 1,                                                                |
|     "b": 2                                                                 |
|   },                                                                       |
|   {                                                                        |
|     "a": 1,                                                                |
|     "b": 3                                                                 |
|   }                                                                        |
| ]                                                                          |
+----------------------------------------------------------------------------+

-- Example 3311
CREATE OR REPLACE TABLE variant_insert (v VARIANT);
INSERT INTO variant_insert (v)
  SELECT PARSE_JSON('{"key3": "value3", "key4": "value4"}');
SELECT * FROM variant_insert;

-- Example 3312
+---------------------+
| V                   |
|---------------------|
| {                   |
|   "key3": "value3", |
|   "key4": "value4"  |
| }                   |
+---------------------+

-- Example 3313
CREATE OR REPLACE TABLE varia (float1 FLOAT, v VARIANT, float2 FLOAT);
INSERT INTO varia (float1, v, float2) VALUES (1.23, NULL, NULL);

-- Example 3314
UPDATE varia SET v = TO_VARIANT(float1);  -- converts from a FLOAT value to a VARIANT value.
UPDATE varia SET float2 = v::FLOAT;       -- converts from a VARIANT value to a FLOAT value.

-- Example 3315
SELECT * FROM varia;

-- Example 3316
+--------+-----------------------+--------+
| FLOAT1 | V                     | FLOAT2 |
|--------+-----------------------+--------|
|   1.23 | 1.230000000000000e+00 |   1.23 |
+--------+-----------------------+--------+

-- Example 3317
SELECT my_variant_column::FLOAT * 3.14 FROM ...;

-- Example 3318
SELECT my_variant_column * 3.14 FROM ...;

-- Example 3319
SELECT 'Sample', 'Sample'::VARIANT, 'Sample'::VARIANT::VARCHAR;

-- Example 3320
+----------+-------------------+----------------------------+
| 'SAMPLE' | 'SAMPLE'::VARIANT | 'SAMPLE'::VARIANT::VARCHAR |
|----------+-------------------+----------------------------|
| Sample   | "Sample"          | Sample                     |
+----------+-------------------+----------------------------+

-- Example 3321
SELECT OBJECT_CONSTRUCT(
  'name', 'Jones'::VARIANT,
  'age',  42::VARIANT);

-- Example 3322
CREATE OR REPLACE TABLE object_example (object_column OBJECT);
INSERT INTO object_example (object_column)
  SELECT OBJECT_CONSTRUCT('thirteen', 13::VARIANT, 'zero', 0::VARIANT);
SELECT * FROM object_example;

-- Example 3323
+-------------------+
| OBJECT_COLUMN     |
|-------------------|
| {                 |
|   "thirteen": 13, |
|   "zero": 0       |
| }                 |
+-------------------+

-- Example 3324
{ [<key>: <value> [, <key>: <value> , ...]] }

-- Example 3325
SELECT {*} FROM my_table;

SELECT {my_table1.*}
  FROM my_table1 INNER JOIN my_table2
    ON my_table2.col1 = my_table1.col1;

-- Example 3326
SELECT {* ILIKE 'col1%'} FROM my_table;

-- Example 3327
SELECT {* EXCLUDE col1} FROM my_table;

-- Example 3328
SELECT {* EXCLUDE (col1, col2)} FROM my_table;

-- Example 3329
SELECT {*, 'k': 'v'} FROM my_table;

-- Example 3330
SELECT {t1.*, t2.*} FROM t1, t2;

-- Example 3331
CREATE OR REPLACE TABLE my_object_table (my_object OBJECT);

INSERT INTO my_object_table (my_object)
  SELECT { 'PROVINCE': 'Alberta'::VARIANT , 'CAPITAL': 'Edmonton'::VARIANT };

INSERT INTO my_object_table (my_object)
  SELECT OBJECT_CONSTRUCT('PROVINCE', 'Manitoba'::VARIANT , 'CAPITAL', 'Winnipeg'::VARIANT );

SELECT * FROM my_object_table;

-- Example 3332
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

