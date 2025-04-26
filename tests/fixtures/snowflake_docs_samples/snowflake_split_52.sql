-- Example 3467
+--------------------------------------+
| ARRAY_SLICE([0,1,2,3,4,5,6], -5, -3) |
|--------------------------------------|
| [                                    |
|   2,                                 |
|   3                                  |
| ]                                    |
+--------------------------------------+

-- Example 3468
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], 10, 12);

-- Example 3469
+--------------------------------------+
| ARRAY_SLICE([0,1,2,3,4,5,6], 10, 12) |
|--------------------------------------|
| []                                   |
+--------------------------------------+

-- Example 3470
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], -10, -12);

-- Example 3471
+----------------------------------------+
| ARRAY_SLICE([0,1,2,3,4,5,6], -10, -12) |
|----------------------------------------|
| []                                     |
+----------------------------------------+

-- Example 3472
ARRAY_SORT( <array> [ , <sort_ascending> [ , <nulls_first> ] ] )

-- Example 3473
SELECT ARRAY_SORT([20, PARSE_JSON('null'), 0, NULL, 10]);

-- Example 3474
+---------------------------------------------------+
| ARRAY_SORT([20, PARSE_JSON('NULL'), 0, NULL, 10]) |
|---------------------------------------------------|
| [                                                 |
|   0,                                              |
|   10,                                             |
|   20,                                             |
|   null,                                           |
|   undefined                                       |
| ]                                                 |
+---------------------------------------------------+

-- Example 3475
SELECT ARRAY_SORT([20, PARSE_JSON('null'), 0, NULL, 10], FALSE);

-- Example 3476
+----------------------------------------------------------+
| ARRAY_SORT([20, PARSE_JSON('NULL'), 0, NULL, 10], FALSE) |
|----------------------------------------------------------|
| [                                                        |
|   undefined,                                             |
|   null,                                                  |
|   20,                                                    |
|   10,                                                    |
|   0                                                      |
| ]                                                        |
+----------------------------------------------------------+

-- Example 3477
SELECT ARRAY_SORT([20, PARSE_JSON('null'), 0, NULL, 10], TRUE, TRUE);

-- Example 3478
+---------------------------------------------------------------+
| ARRAY_SORT([20, PARSE_JSON('NULL'), 0, NULL, 10], TRUE, TRUE) |
|---------------------------------------------------------------|
| [                                                             |
|   undefined,                                                  |
|   0,                                                          |
|   10,                                                         |
|   20,                                                         |
|   null                                                        |
| ]                                                             |
+---------------------------------------------------------------+

-- Example 3479
SELECT ARRAY_SORT([20, PARSE_JSON('null'), 0, NULL, 10], FALSE, FALSE);

-- Example 3480
+-----------------------------------------------------------------+
| ARRAY_SORT([20, PARSE_JSON('NULL'), 0, NULL, 10], FALSE, FALSE) |
|-----------------------------------------------------------------|
| [                                                               |
|   null,                                                         |
|   20,                                                           |
|   10,                                                           |
|   0,                                                            |
|   undefined                                                     |
| ]                                                               |
+-----------------------------------------------------------------+

-- Example 3481
SELECT ARRAY_INSERT(ARRAY_INSERT(ARRAY_CONSTRUCT(), 3, 2), 6, 1) arr, ARRAY_SORT(arr);

-- Example 3482
+--------------+-----------------+
| ARR          | ARRAY_SORT(ARR) |
|--------------+-----------------|
| [            | [               |
|   undefined, |   1,            |
|   undefined, |   2,            |
|   undefined, |   undefined,    |
|   2,         |   undefined,    |
|   undefined, |   undefined,    |
|   undefined, |   undefined,    |
|   1          |   undefined     |
| ]            | ]               |
+--------------+-----------------+

-- Example 3483
SELECT ARRAY_SORT([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1e0::REAL]) AS array_of_different_numeric_types;

-- Example 3484
+----------------------------------+
| ARRAY_OF_DIFFERENT_NUMERIC_TYPES |
|----------------------------------|
| [                                |
|   1,                             |
|   1.000000000000000e+00,         |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1,                             |
|   1                              |
| ]                                |
+----------------------------------+

-- Example 3485
ARRAY_TO_STRING( <array> , <separator_string> )

-- Example 3486
SELECT column1,
       ARRAY_TO_STRING(PARSE_JSON(column1), '') AS no_separation,
       ARRAY_TO_STRING(PARSE_JSON(column1), ', ') AS comma_separated
  FROM VALUES
    (NULL),
    ('[]'),
    ('[1]'),
    ('[1, 2]'),
    ('[true, 1, -1.2e-3, "Abc", ["x","y"], {"a":1}]'),
    ('[, 1]'),
    ('[1, ]'),
    ('[1, , ,2]');

-- Example 3487
+-----------------------------------------------+---------------------------------+-------------------------------------------+
| COLUMN1                                       | NO_SEPARATION                   | COMMA_SEPARATED                           |
|-----------------------------------------------+---------------------------------+-------------------------------------------|
| NULL                                          | NULL                            | NULL                                      |
| []                                            |                                 |                                           |
| [1]                                           | 1                               | 1                                         |
| [1, 2]                                        | 12                              | 1, 2                                      |
| [true, 1, -1.2e-3, "Abc", ["x","y"], {"a":1}] | true1-0.0012Abc["x","y"]{"a":1} | true, 1, -0.0012, Abc, ["x","y"], {"a":1} |
| [, 1]                                         | 1                               | , 1                                       |
| [1, ]                                         | 1                               | 1,                                        |
| [1, , ,2]                                     | 12                              | 1, , , 2                                  |
+-----------------------------------------------+---------------------------------+-------------------------------------------+

-- Example 3488
CREATE TABLE test_array_to_string_with_null(a ARRAY);

INSERT INTO test_array_to_string_with_null
  SELECT (['A', NULL, 'B']);

-- Example 3489
SELECT a,
       ARRAY_TO_STRING(a, ''),
       ARRAY_TO_STRING(a, ', ')
  FROM test_array_to_string_with_null;

-- Example 3490
+--------------+------------------------+--------------------------+
| A            | ARRAY_TO_STRING(A, '') | ARRAY_TO_STRING(A, ', ') |
|--------------+------------------------+--------------------------|
| [            | AB                     | A, , B                   |
|   "A",       |                        |                          |
|   undefined, |                        |                          |
|   "B"        |                        |                          |
| ]            |                        |                          |
+--------------+------------------------+--------------------------+

-- Example 3491
TO_CHAR( <expr> )
TO_CHAR( <numeric_expr> [, '<format>' ] )
TO_CHAR( <date_or_time_expr> [, '<format>' ] )
TO_CHAR( <binary_expr> [, '<format>' ] )

TO_VARCHAR( <expr> )
TO_VARCHAR( <numeric_expr> [, '<format>' ] )
TO_VARCHAR( <date_or_time_expr> [, '<format>' ] )
TO_VARCHAR( <binary_expr> [, '<format>' ] )

-- Example 3492
CREATE OR REPLACE TABLE convert_numbers_to_strings(column1 NUMBER);

INSERT INTO convert_numbers_to_strings VALUES
  (-12.391),
  (0),
  (-1),
  (0.10),
  (0.01),
  (3987),
  (1.111);

SELECT column1 AS orig_value,
       TO_CHAR(column1, '">"$99.0"<"') AS D2_1,
       TO_CHAR(column1, '">"B9,999.0"<"') AS D4_1,
       TO_CHAR(column1, '">"TME"<"') AS TME,
       TO_CHAR(column1, '">"TM9"<"') AS TM9,
       TO_CHAR(column1, '">"0XXX"<"') AS X4,
       TO_CHAR(column1, '">"S0XXX"<"') AS SX4
  FROM convert_numbers_to_strings;

-- Example 3493
+------------+----------+------------+-------------+------------+--------+---------+
| ORIG_VALUE | D2_1     | D4_1       | TME         | TM9        | X4     | SX4     |
|------------+----------+------------+-------------+------------+--------+---------|
|    -12.391 | >-$12.4< | >   -12.4< | >-1.2391E1< | >-12.391<  | >FFF4< | >-000C< |
|      0.000 | >  $0.0< | >      .0< | >0E0<       | >0.000<    | >0000< | >+0000< |
|     -1.000 | > -$1.0< | >    -1.0< | >-1E0<      | >-1.000<   | >FFFF< | >-0001< |
|      0.100 | >  $0.1< | >      .1< | >1E-1<      | >0.100<    | >0000< | >+0000< |
|      0.010 | >  $0.0< | >      .0< | >1E-2<      | >0.010<    | >0000< | >+0000< |
|   3987.000 | > $##.#< | > 3,987.0< | >3.987E3<   | >3987.000< | >0F93< | >+0F93< |
|      1.111 | >  $1.1< | >     1.1< | >1.111E0<   | >1.111<    | >0001< | >+0001< |
+------------+----------+------------+-------------+------------+--------+---------+

-- Example 3494
SELECT TO_VARCHAR(LOG(3,4));

-- Example 3495
+----------------------+
| TO_VARCHAR(LOG(3,4)) |
|----------------------|
| 1.261859507          |
+----------------------+

-- Example 3496
SELECT TO_VARCHAR('2024-04-05 01:02:03'::TIMESTAMP, 'mm/dd/yyyy, hh24:mi hours');

-- Example 3497
+---------------------------------------------------------------------------+
| TO_VARCHAR('2024-04-05 01:02:03'::TIMESTAMP, 'MM/DD/YYYY, HH24:MI HOURS') |
|---------------------------------------------------------------------------|
| 04/05/2024, 01:02 hours                                                   |
+---------------------------------------------------------------------------+

-- Example 3498
SELECT TO_VARCHAR('03-April-2024'::DATE);

-- Example 3499
+-----------------------------------+
| TO_VARCHAR('03-APRIL-2024'::DATE) |
|-----------------------------------|
| 2024-04-03                        |
+-----------------------------------+

-- Example 3500
SELECT TO_VARCHAR('03-April-2024'::DATE, 'yyyy.mm.dd');

-- Example 3501
+-------------------------------------------------+
| TO_VARCHAR('03-APRIL-2024'::DATE, 'YYYY.MM.DD') |
|-------------------------------------------------|
| 2024.04.03                                      |
+-------------------------------------------------+

-- Example 3502
ARRAYS_OVERLAP( <array1> , <array2> )

-- Example 3503
SELECT ARRAYS_OVERLAP(array_construct('hello', 'aloha'), 
                      array_construct('hello', 'hi', 'hey'))
  AS Overlap;
+---------+
| OVERLAP |
|---------|
| True    |
+---------+
SELECT ARRAYS_OVERLAP(array_construct('hello', 'aloha'), 
                      array_construct('hola', 'bonjour', 'ciao'))
  AS Overlap;
+---------+
| OVERLAP |
|---------|
| False   |
+---------+
SELECT ARRAYS_OVERLAP(array_construct(object_construct('a',1,'b',2), 1, 2), 
                      array_construct(object_construct('b',2,'c',3), 3, 4))
  AS Overlap;
+---------+
| OVERLAP |
|---------|
| False   |
+---------+
SELECT ARRAYS_OVERLAP(array_construct(object_construct('a',1,'b',2), 1, 2), 
                      array_construct(object_construct('a',1,'b',2), 3, 4))
  AS Overlap;
+---------+
| OVERLAP |
|---------|
| True    |
+---------+

-- Example 3504
SELECT ARRAYS_OVERLAP(ARRAY_CONSTRUCT(1, 2, NULL),
                      ARRAY_CONSTRUCT(3, NULL, 5))
 AS Overlap;
+---------+
| OVERLAP |
|---------|
| True    |
+---------+

-- Example 3505
ARRAYS_TO_OBJECT( <key_array> , <value_array> )

-- Example 3506
215002 (22000): Key supplied for ARRAYS_TO_OBJECT does not have string type

-- Example 3507
215001 (22000): Key array and value array had unequal lengths in ARRAYS_TO_OBJECT

-- Example 3508
SELECT ARRAYS_TO_OBJECT(['key1', 'key2', 'key3'], [1, 2, 3]);

-- Example 3509
+-------------------------------------------------------+
| ARRAYS_TO_OBJECT(['KEY1', 'KEY2', 'KEY3'], [1, 2, 3]) |
|-------------------------------------------------------|
| {                                                     |
|   "key1": 1,                                          |
|   "key2": 2,                                          |
|   "key3": 3                                           |
| }                                                     |
+-------------------------------------------------------+

-- Example 3510
SELECT ARRAYS_TO_OBJECT(['key1', NULL, 'key3'], [1, 2, 3]);

-- Example 3511
+-----------------------------------------------------+
| ARRAYS_TO_OBJECT(['KEY1', NULL, 'KEY3'], [1, 2, 3]) |
|-----------------------------------------------------|
| {                                                   |
|   "key1": 1,                                        |
|   "key3": 3                                         |
| }                                                   |
+-----------------------------------------------------+

-- Example 3512
SELECT ARRAYS_TO_OBJECT(['key1', 'key2', 'key3'], [1, NULL, 3]);

-- Example 3513
+----------------------------------------------------------+
| ARRAYS_TO_OBJECT(['KEY1', 'KEY2', 'KEY3'], [1, NULL, 3]) |
|----------------------------------------------------------|
| {                                                        |
|   "key1": 1,                                             |
|   "key2": null,                                          |
|   "key3": 3                                              |
| }                                                        |
+----------------------------------------------------------+

-- Example 3514
ARRAYS_ZIP( <array> [ , <array> ... ] )

-- Example 3515
SELECT ARRAYS_ZIP(
  [1, 2, 3],
  ['first', 'second', 'third'],
  ['i', 'ii', 'iii']
) AS zipped_arrays;

-- Example 3516
+---------------------+
| ZIPPED_ARRAYS       |
|---------------------|
| [                   |
|   {                 |
|     "$1": 1,        |
|     "$2": "first",  |
|     "$3": "i"       |
|   },                |
|   {                 |
|     "$1": 2,        |
|     "$2": "second", |
|     "$3": "ii"      |
|   },                |
|   {                 |
|     "$1": 3,        |
|     "$2": "third",  |
|     "$3": "iii"     |
|   }                 |
| ]                   |
+---------------------+

-- Example 3517
SELECT ARRAYS_ZIP(
  [1, 2, 3]
) AS zipped_array;

-- Example 3518
+--------------+
| ZIPPED_ARRAY |
|--------------|
| [            |
|   {          |
|     "$1": 1  |
|   },         |
|   {          |
|     "$1": 2  |
|   },         |
|   {          |
|     "$1": 3  |
|   }          |
| ]            |
+--------------+

-- Example 3519
SELECT ARRAYS_ZIP(
  [1, 2, 3],
  [10, 20, 30],
  [100, 200, 300]
) AS zipped_array;

-- Example 3520
+---------------+
| ZIPPED_ARRAY  |
|---------------|
| [             |
|   {           |
|     "$1": 1,  |
|     "$2": 10, |
|     "$3": 100 |
|   },          |
|   {           |
|     "$1": 2,  |
|     "$2": 20, |
|     "$3": 200 |
|   },          |
|   {           |
|     "$1": 3,  |
|     "$2": 30, |
|     "$3": 300 |
|   }           |
| ]             |
+---------------+

-- Example 3521
SELECT ARRAYS_ZIP(
  [1, 2, 3],
  ['one'],
  ['I', 'II']
) AS zipped_array;

-- Example 3522
+------------------+
| ZIPPED_ARRAY     |
|------------------|
| [                |
|   {              |
|     "$1": 1,     |
|     "$2": "one", |
|     "$3": "I"    |
|   },             |
|   {              |
|     "$1": 2,     |
|     "$2": null,  |
|     "$3": "II"   |
|   },             |
|   {              |
|     "$1": 3,     |
|     "$2": null,  |
|     "$3": null   |
|   }              |
| ]                |
+------------------+

-- Example 3523
SELECT ARRAYS_ZIP(
  [1, 2, 3],
  NULL,
  [100, 200, 300]
) AS zipped_array;

-- Example 3524
+--------------+
| ZIPPED_ARRAY |
|--------------|
| NULL         |
+--------------+

-- Example 3525
SELECT ARRAYS_ZIP(
  [], [], []
) AS zipped_array;

-- Example 3526
+--------------+
| ZIPPED_ARRAY |
|--------------|
| [            |
|   {}         |
| ]            |
+--------------+

-- Example 3527
SELECT ARRAYS_ZIP(
  [1, NULL, 3],
  [NULL, 20, NULL],
  [100, NULL, 300]
) AS zipped_array;

-- Example 3528
+-----------------+
| ZIPPED_ARRAY    |
|-----------------|
| [               |
|   {             |
|     "$1": 1,    |
|     "$2": null, |
|     "$3": 100   |
|   },            |
|   {             |
|     "$1": null, |
|     "$2": 20,   |
|     "$3": null  |
|   },            |
|   {             |
|     "$1": 3,    |
|     "$2": null, |
|     "$3": 300   |
|   }             |
| ]               |
+-----------------+

-- Example 3529
CREATE OR REPLACE TABLE multiple_types_example (
  array1 VARIANT,
  array2 VARIANT,
  boolean1 VARIANT,
  char1 VARIANT,
  varchar1 VARIANT,
  decimal1 VARIANT,
  double1 VARIANT,
  integer1 VARIANT,
  object1 VARIANT);

INSERT INTO multiple_types_example
  (array1, array2, boolean1, char1, varchar1,
   decimal1, double1, integer1, object1)
  SELECT
    TO_VARIANT(TO_ARRAY('Example')),
    TO_VARIANT(ARRAY_CONSTRUCT('Array-like', 'example')),
    TO_VARIANT(TRUE),
    TO_VARIANT('X'),
    TO_VARIANT('Y'),
    TO_VARIANT(1.23::DECIMAL(6, 3)),
    TO_VARIANT(3.21::DOUBLE),
    TO_VARIANT(15),
    TO_VARIANT(TO_OBJECT(PARSE_JSON('{"Tree": "Pine"}')));

-- Example 3530
SELECT AS_ARRAY(array1) AS array1,
       AS_ARRAY(array2) AS array2,
       AS_BOOLEAN(boolean1) AS boolean,
       AS_CHAR(char1) AS char,
       AS_VARCHAR(varchar1) AS varchar,
       AS_DECIMAL(decimal1, 6, 3) AS decimal,
       AS_DOUBLE(double1) AS double,
       AS_INTEGER(integer1) AS integer,
       AS_OBJECT(object1) AS object
  FROM multiple_types_example;

-- Example 3531
+-------------+-----------------+---------+------+---------+---------+--------+---------+------------------+
| ARRAY1      | ARRAY2          | BOOLEAN | CHAR | VARCHAR | DECIMAL | DOUBLE | INTEGER | OBJECT           |
|-------------+-----------------+---------+------+---------+---------+--------+---------+------------------|
| [           | [               | True    | X    | Y       |   1.230 |   3.21 |      15 | {                |
|   "Example" |   "Array-like", |         |      |         |         |        |         |   "Tree": "Pine" |
| ]           |   "example"     |         |      |         |         |        |         | }                |
|             | ]               |         |      |         |         |        |         |                  |
+-------------+-----------------+---------+------+---------+---------+--------+---------+------------------+

-- Example 3532
CREATE OR REPLACE TABLE vartab (n NUMBER(2), v VARIANT);

INSERT INTO vartab
  SELECT column1 AS n, PARSE_JSON(column2) AS v
    FROM VALUES (1, 'null'), 
                (2, null), 
                (3, 'true'),
                (4, '-17'), 
                (5, '123.12'), 
                (6, '1.912e2'),
                (7, '"Om ara pa ca na dhih"  '), 
                (8, '[-1, 12, 289, 2188, false,]'), 
                (9, '{ "x" : "abc", "y" : false, "z": 10} ') 
       AS vals;

-- Example 3533
SELECT n, AS_REAL(v), TYPEOF(v)
  FROM vartab
  ORDER BY n;

