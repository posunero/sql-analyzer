-- Example 3333
CREATE OR REPLACE TABLE demo_ca_provinces (province VARCHAR, capital VARCHAR);
INSERT INTO demo_ca_provinces (province, capital) VALUES
  ('Ontario', 'Toronto'),
  ('British Columbia', 'Victoria');

SELECT province, capital
  FROM demo_ca_provinces
  ORDER BY province;

-- Example 3334
+------------------+----------+
| PROVINCE         | CAPITAL  |
|------------------+----------|
| British Columbia | Victoria |
| Ontario          | Toronto  |
+------------------+----------+

-- Example 3335
INSERT INTO my_object_table (my_object)
  SELECT {*} FROM demo_ca_provinces;

SELECT * FROM my_object_table;

-- Example 3336
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

-- Example 3337
SET my_variable = 10;
SELECT {'key1': $my_variable+1, 'key2': $my_variable+2};

-- Example 3338
+--------------------------------------------------+
| {'KEY1': $MY_VARIABLE+1, 'KEY2': $MY_VARIABLE+2} |
|--------------------------------------------------|
| {                                                |
|   "key1": 11,                                    |
|   "key2": 12                                     |
| }                                                |
+--------------------------------------------------+

-- Example 3339
SELECT { 'Manitoba': 'Winnipeg' } AS province_capital;

-- Example 3340
+--------------------------+
| PROVINCE_CAPITAL         |
|--------------------------|
| {                        |
|   "Manitoba": "Winnipeg" |
| }                        |
+--------------------------+

-- Example 3341
SELECT object_column['thirteen'] FROM object_example;

-- Example 3342
SELECT object_column['thirteen'],
       object_column:thirteen
  FROM object_example;

-- Example 3343
+---------------------------+------------------------+
| OBJECT_COLUMN['THIRTEEN'] | OBJECT_COLUMN:THIRTEEN |
|---------------------------+------------------------|
| 13                        | 13                     |
+---------------------------+------------------------+

-- Example 3344
CREATE OR REPLACE TABLE array_example (array_column ARRAY);
INSERT INTO array_example (array_column)
  SELECT ARRAY_CONSTRUCT(12, 'twelve', NULL);

-- Example 3345
[<value> [, <value> , ...]]

-- Example 3346
INSERT INTO array_example (array_column)
  SELECT [ 12, 'twelve', NULL ];

-- Example 3347
UPDATE my_table SET my_array = [ 1, 2 ];

UPDATE my_table SET my_array = ARRAY_CONSTRUCT(1, 2);

-- Example 3348
SET my_variable = 10;
SELECT [$my_variable+1, $my_variable+2];

-- Example 3349
+----------------------------------+
| [$MY_VARIABLE+1, $MY_VARIABLE+2] |
|----------------------------------|
| [                                |
|   11,                            |
|   12                             |
| ]                                |
+----------------------------------+

-- Example 3350
SELECT [ 'Alberta', 'Manitoba' ] AS province;

-- Example 3351
+--------------+
| PROVINCE     |
|--------------|
| [            |
|   "Alberta", |
|   "Manitoba" |
| ]            |
+--------------+

-- Example 3352
SELECT my_array_column[2] FROM my_table;

-- Example 3353
SELECT my_array_column[0][0] FROM my_table;

-- Example 3354
SELECT ARRAY_SLICE(my_array_column, 5, 10) FROM my_table;

-- Example 3355
[ undefined, undefined ]

-- Example 3356
SELECT ARRAY_SLICE(array_column, 6, 8) FROM table_1;

-- Example 3357
+---------------------------------+
| array_slice(array_column, 6, 8) |
+---------------------------------+
| [ ]                             |
+---------------------------------+

-- Example 3358
CREATE OR REPLACE TABLE test_semi_structured(
  var VARIANT,
  arr ARRAY,
  obj OBJECT);

DESC TABLE test_semi_structured;

-- Example 3359
+------+---------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type    | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+---------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| VAR  | VARIANT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| ARR  | ARRAY   | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| OBJ  | OBJECT  | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+---------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3360
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

-- Example 3361
SELECT *
  FROM demonstration1
  ORDER BY id;

-- Example 3362
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

-- Example 3363
ARRAY_EXCEPT( <source_array> , <array_of_elements_to_exclude> )

-- Example 3364
SELECT ARRAY_EXCEPT(['A', 'B'], ['B', 'C']);

+--------------------------------------+
| ARRAY_EXCEPT(['A', 'B'], ['B', 'C']) |
|--------------------------------------|
| [                                    |
|   "A"                                |
| ]                                    |
+--------------------------------------+

-- Example 3365
SELECT ARRAY_EXCEPT(['A', 'B', 'C'], ['B', 'C']);

+-------------------------------------------+
| ARRAY_EXCEPT(['A', 'B', 'C'], ['B', 'C']) |
|-------------------------------------------|
| [                                         |
|   "A"                                     |
| ]                                         |
+-------------------------------------------+

-- Example 3366
SELECT ARRAY_EXCEPT(['A', 'B', 'B', 'B', 'C'], ['B']);

+------------------------------------------------+
| ARRAY_EXCEPT(['A', 'B', 'B', 'B', 'C'], ['B']) |
|------------------------------------------------|
| [                                              |
|   "A",                                         |
|   "B",                                         |
|   "B",                                         |
|   "C"                                          |
| ]                                              |
+------------------------------------------------+

-- Example 3367
SELECT ARRAY_EXCEPT(['A', 'B'], ['A', 'B']);

+--------------------------------------+
| ARRAY_EXCEPT(['A', 'B'], ['A', 'B']) |
|--------------------------------------|
| []                                   |
+--------------------------------------+

-- Example 3368
SELECT ARRAY_EXCEPT(['A', NULL, NULL], ['B', NULL]);

+----------------------------------------------+
| ARRAY_EXCEPT(['A', NULL, NULL], ['B', NULL]) |
|----------------------------------------------|
| [                                            |
|   "A",                                       |
|   undefined                                  |
| ]                                            |
+----------------------------------------------+

-- Example 3369
SELECT ARRAY_EXCEPT(['A', NULL, NULL], [NULL, 'B', NULL]);

+----------------------------------------------------+
| ARRAY_EXCEPT(['A', NULL, NULL], [NULL, 'B', NULL]) |
|----------------------------------------------------|
| [                                                  |
|   "A"                                              |
| ]                                                  |
+----------------------------------------------------+

-- Example 3370
SELECT ARRAY_EXCEPT([{'a': 1, 'b': 2}, 1], [{'a': 1, 'b': 2}, 3]);

+------------------------------------------------------------+
| ARRAY_EXCEPT([{'A': 1, 'B': 2}, 1], [{'A': 1, 'B': 2}, 3]) |
|------------------------------------------------------------|
| [                                                          |
|   1                                                        |
| ]                                                          |
+------------------------------------------------------------+

-- Example 3371
SELECT ARRAY_EXCEPT(['A', 'B'], NULL);

+--------------------------------+
| ARRAY_EXCEPT(['A', 'B'], NULL) |
|--------------------------------|
| NULL                           |
+--------------------------------+

-- Example 3372
ARRAY_FLATTEN( <array> )

-- Example 3373
[ [ [1, 2], [3] ], [ [4], [5] ] ]

-- Example 3374
[ [1, 2], [3], [4], [5] ]

-- Example 3375
SELECT ARRAY_FLATTEN([[1, 2, 3], [4], [5, 6]]);

-- Example 3376
+-----------------------------------------+
| ARRAY_FLATTEN([[1, 2, 3], [4], [5, 6]]) |
|-----------------------------------------|
| [                                       |
|   1,                                    |
|   2,                                    |
|   3,                                    |
|   4,                                    |
|   5,                                    |
|   6                                     |
| ]                                       |
+-----------------------------------------+

-- Example 3377
SELECT ARRAY_FLATTEN([[[1, 2], [3]], [[4], [5]]]);

-- Example 3378
+--------------------------------------------+
| ARRAY_FLATTEN([[[1, 2], [3]], [[4], [5]]]) |
|--------------------------------------------|
| [                                          |
|   [                                        |
|     1,                                     |
|     2                                      |
|   ],                                       |
|   [                                        |
|     3                                      |
|   ],                                       |
|   [                                        |
|     4                                      |
|   ],                                       |
|   [                                        |
|     5                                      |
|   ]                                        |
| ]                                          |
+--------------------------------------------+

-- Example 3379
SELECT ARRAY_FLATTEN([[1, 2, 3], 4, [5, 6]]);

-- Example 3380
100107 (22000): Not an array: 'Input argument to ARRAY_FLATTEN is not an array of arrays'

-- Example 3381
SELECT ARRAY_FLATTEN([[1, 2, 3], NULL, [5, 6]]);

-- Example 3382
+------------------------------------------+
| ARRAY_FLATTEN([[1, 2, 3], NULL, [5, 6]]) |
|------------------------------------------|
| NULL                                     |
+------------------------------------------+

-- Example 3383
SELECT ARRAY_FLATTEN([[1, 2, 3], [NULL], [5, 6]]);

-- Example 3384
+--------------------------------------------+
| ARRAY_FLATTEN([[1, 2, 3], [NULL], [5, 6]]) |
|--------------------------------------------|
| [                                          |
|   1,                                       |
|   2,                                       |
|   3,                                       |
|   undefined,                               |
|   5,                                       |
|   6                                        |
| ]                                          |
+--------------------------------------------+

-- Example 3385
ARRAY_GENERATE_RANGE( <start> , <stop> [ , <step> ] )

-- Example 3386
SELECT ARRAY_GENERATE_RANGE(2, 5);

-- Example 3387
+----------------------------+
| ARRAY_GENERATE_RANGE(2, 5) |
|----------------------------|
| [                          |
|   2,                       |
|   3,                       |
|   4                        |
| ]                          |
+----------------------------+

-- Example 3388
SELECT ARRAY_GENERATE_RANGE(5, 25, 10);

-- Example 3389
+---------------------------------+
| ARRAY_GENERATE_RANGE(5, 25, 10) |
|---------------------------------|
| [                               |
|   5,                            |
|   15                            |
| ]                               |
+---------------------------------+

-- Example 3390
SELECT ARRAY_GENERATE_RANGE(-5, -25, -10);

-- Example 3391
+------------------------------------+
| ARRAY_GENERATE_RANGE(-5, -25, -10) |
|------------------------------------|
| [                                  |
|   -5,                              |
|   -15                              |
| ]                                  |
+------------------------------------+

-- Example 3392
ARRAY_INSERT( <array> , <pos> , <new_element> )

-- Example 3393
SELECT ARRAY_INSERT(ARRAY_CONSTRUCT(0,1,2,3),2,'hello');
+--------------------------------------------------+
| ARRAY_INSERT(ARRAY_CONSTRUCT(0,1,2,3),2,'HELLO') |
|--------------------------------------------------|
| [                                                |
|   0,                                             |
|   1,                                             |
|   "hello",                                       |
|   2,                                             |
|   3                                              |
| ]                                                |
+--------------------------------------------------+

-- Example 3394
SELECT ARRAY_INSERT(ARRAY_CONSTRUCT(0,1,2,3),5,'hello');
+--------------------------------------------------+
| ARRAY_INSERT(ARRAY_CONSTRUCT(0,1,2,3),5,'HELLO') |
|--------------------------------------------------|
| [                                                |
|   0,                                             |
|   1,                                             |
|   2,                                             |
|   3,                                             |
|   undefined,                                     |
|   "hello"                                        |
| ]                                                |
+--------------------------------------------------+

-- Example 3395
SELECT ARRAY_INSERT(ARRAY_CONSTRUCT(0,1,2,3),-1,'hello');
+---------------------------------------------------+
| ARRAY_INSERT(ARRAY_CONSTRUCT(0,1,2,3),-1,'HELLO') |
|---------------------------------------------------|
| [                                                 |
|   0,                                              |
|   1,                                              |
|   2,                                              |
|   "hello",                                        |
|   3                                               |
| ]                                                 |
+---------------------------------------------------+

-- Example 3396
ARRAY_INTERSECTION( <array1> , <array2> )

-- Example 3397
SELECT array_intersection(ARRAY_CONSTRUCT('A', 'B'), 
                          ARRAY_CONSTRUCT('B', 'C'));
+------------------------------------------------------+
| ARRAY_INTERSECTION(ARRAY_CONSTRUCT('A', 'B'),        |
|                           ARRAY_CONSTRUCT('B', 'C')) |
|------------------------------------------------------|
| [                                                    |
|   "B"                                                |
| ]                                                    |
+------------------------------------------------------+

-- Example 3398
SELECT array_intersection(ARRAY_CONSTRUCT('A', 'B', 'C'), 
                          ARRAY_CONSTRUCT('B', 'C'));
+------------------------------------------------------+
| ARRAY_INTERSECTION(ARRAY_CONSTRUCT('A', 'B', 'C'),   |
|                           ARRAY_CONSTRUCT('B', 'C')) |
|------------------------------------------------------|
| [                                                    |
|   "B",                                               |
|   "C"                                                |
| ]                                                    |
+------------------------------------------------------+

-- Example 3399
SELECT array_intersection(ARRAY_CONSTRUCT('A', 'B', 'B', 'B', 'C'), 
                          ARRAY_CONSTRUCT('B', 'B'));
+---------------------------------------------------------------+
| ARRAY_INTERSECTION(ARRAY_CONSTRUCT('A', 'B', 'B', 'B', 'C'),  |
|                           ARRAY_CONSTRUCT('B', 'B'))          |
|---------------------------------------------------------------|
| [                                                             |
|   "B",                                                        |
|   "B"                                                         |
| ]                                                             |
+---------------------------------------------------------------+

