-- Example 3400
CREATE OR REPLACE TABLE array_demo (ID INTEGER, array1 ARRAY, array2 ARRAY, tip VARCHAR);

INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 1, ARRAY_CONSTRUCT(1, 2), ARRAY_CONSTRUCT(3, 4), 'non-overlapping';
INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 2, ARRAY_CONSTRUCT(1, 2, 3), ARRAY_CONSTRUCT(3, 4, 5), 'value 3 overlaps';
INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 3, ARRAY_CONSTRUCT(1, 2, 3, 4), ARRAY_CONSTRUCT(3, 4, 5), 'values 3 and 4 overlap';
INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 4, ARRAY_CONSTRUCT(NULL, 102, NULL), ARRAY_CONSTRUCT(NULL, NULL, 103), 'NULLs overlap';
INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 5, array_construct(object_construct('a',1,'b',2), 1, 2),
              array_construct(object_construct('a',1,'b',2), 3, 4), 
              'the objects in the array match';
INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 6, array_construct(object_construct('a',1,'b',2), 1, 2),
              array_construct(object_construct('b',2,'c',3), 3, 4), 
              'neither the objects nor any other values match';
INSERT INTO array_demo (ID, array1, array2, tip)
    SELECT 7, array_construct(object_construct('a',1, 'b',2, 'c',3)),
              array_construct(object_construct('c',3, 'b',2, 'a',1)), 
              'the objects contain the same values, but in different order';

-- Example 3401
SELECT ID, array1, array2, tip, ARRAY_INTERSECTION(array1, array2) 
    FROM array_demo
    WHERE ID <= 3
    ORDER BY ID;
+----+--------+--------+------------------------+------------------------------------+
| ID | ARRAY1 | ARRAY2 | TIP                    | ARRAY_INTERSECTION(ARRAY1, ARRAY2) |
|----+--------+--------+------------------------+------------------------------------|
|  1 | [      | [      | non-overlapping        | []                                 |
|    |   1,   |   3,   |                        |                                    |
|    |   2    |   4    |                        |                                    |
|    | ]      | ]      |                        |                                    |
|  2 | [      | [      | value 3 overlaps       | [                                  |
|    |   1,   |   3,   |                        |   3                                |
|    |   2,   |   4,   |                        | ]                                  |
|    |   3    |   5    |                        |                                    |
|    | ]      | ]      |                        |                                    |
|  3 | [      | [      | values 3 and 4 overlap | [                                  |
|    |   1,   |   3,   |                        |   3,                               |
|    |   2,   |   4,   |                        |   4                                |
|    |   3,   |   5    |                        | ]                                  |
|    |   4    | ]      |                        |                                    |
|    | ]      |        |                        |                                    |
+----+--------+--------+------------------------+------------------------------------+

-- Example 3402
SELECT ID, array1, array2, tip, ARRAY_INTERSECTION(array1, array2) 
    FROM array_demo
    WHERE ID = 4
    ORDER BY ID;
+----+--------------+--------------+---------------+------------------------------------+
| ID | ARRAY1       | ARRAY2       | TIP           | ARRAY_INTERSECTION(ARRAY1, ARRAY2) |
|----+--------------+--------------+---------------+------------------------------------|
|  4 | [            | [            | NULLs overlap | [                                  |
|    |   undefined, |   undefined, |               |   undefined,                       |
|    |   102,       |   undefined, |               |   undefined                        |
|    |   undefined  |   103        |               | ]                                  |
|    | ]            | ]            |               |                                    |
+----+--------------+--------------+---------------+------------------------------------+

-- Example 3403
SELECT ID, array1, array2, tip, ARRAY_INTERSECTION(array1, array2) 
    FROM array_demo
    WHERE ID >= 5 and ID <= 7
    ORDER BY ID;
+----+-------------+-------------+-------------------------------------------------------------+------------------------------------+
| ID | ARRAY1      | ARRAY2      | TIP                                                         | ARRAY_INTERSECTION(ARRAY1, ARRAY2) |
|----+-------------+-------------+-------------------------------------------------------------+------------------------------------|
|  5 | [           | [           | the objects in the array match                              | [                                  |
|    |   {         |   {         |                                                             |   {                                |
|    |     "a": 1, |     "a": 1, |                                                             |     "a": 1,                        |
|    |     "b": 2  |     "b": 2  |                                                             |     "b": 2                         |
|    |   },        |   },        |                                                             |   }                                |
|    |   1,        |   3,        |                                                             | ]                                  |
|    |   2         |   4         |                                                             |                                    |
|    | ]           | ]           |                                                             |                                    |
|  6 | [           | [           | neither the objects nor any other values match              | []                                 |
|    |   {         |   {         |                                                             |                                    |
|    |     "a": 1, |     "b": 2, |                                                             |                                    |
|    |     "b": 2  |     "c": 3  |                                                             |                                    |
|    |   },        |   },        |                                                             |                                    |
|    |   1,        |   3,        |                                                             |                                    |
|    |   2         |   4         |                                                             |                                    |
|    | ]           | ]           |                                                             |                                    |
|  7 | [           | [           | the objects contain the same values, but in different order | [                                  |
|    |   {         |   {         |                                                             |   {                                |
|    |     "a": 1, |     "a": 1, |                                                             |     "a": 1,                        |
|    |     "b": 2, |     "b": 2, |                                                             |     "b": 2,                        |
|    |     "c": 3  |     "c": 3  |                                                             |     "c": 3                         |
|    |   }         |   }         |                                                             |   }                                |
|    | ]           | ]           |                                                             | ]                                  |
+----+-------------+-------------+-------------------------------------------------------------+------------------------------------+

-- Example 3404
SELECT array_intersection(ARRAY_CONSTRUCT('A', 'B'), 
                          NULL);
+------------------------------------------------+
| ARRAY_INTERSECTION(ARRAY_CONSTRUCT('A', 'B'),  |
|                           NULL)                |
|------------------------------------------------|
| NULL                                           |
+------------------------------------------------+

-- Example 3405
ARRAY_MAX( <array> )

-- Example 3406
SELECT ARRAY_MAX([20, 0, NULL, 10, NULL]);

-- Example 3407
+------------------------------------+
| ARRAY_MAX([20, 0, NULL, 10, NULL]) |
|------------------------------------|
| 20                                 |
+------------------------------------+

-- Example 3408
SELECT ARRAY_MAX([NULL, PARSE_JSON('null'), NULL]);

-- Example 3409
+--------------------------------------------------+
| ARRAY_MAX([20, 0, PARSE_JSON('NULL'), 10, NULL]) |
|--------------------------------------------------|
| null                                             |
+--------------------------------------------------+

-- Example 3410
SELECT ARRAY_MAX([]);

-- Example 3411
+---------------+
| ARRAY_MAX([]) |
|---------------|
| NULL          |
+---------------+

-- Example 3412
SELECT ARRAY_MAX([NULL, NULL, NULL]);

-- Example 3413
+-------------------------+
| ARRAY_MAX([NULL, NULL]) |
|-------------------------|
| NULL                    |
+-------------------------+

-- Example 3414
SELECT ARRAY_MAX([date1::TIMESTAMP, timestamp1]) AS array_max
  FROM (
      VALUES ('1999-01-01'::DATE, '2023-12-09 22:09:26.000000000'::TIMESTAMP),
             ('2023-12-09'::DATE, '1999-01-01 22:09:26.000000000'::TIMESTAMP)
          AS t(date1, timestamp1)
      );

-- Example 3415
+---------------------------+
| ARRAY_MAX                 |
|---------------------------|
| "2023-12-09 22:09:26.000" |
| "2023-12-09 00:00:00.000" |
+---------------------------+

-- Example 3416
ARRAY_MIN( <array> )

-- Example 3417
SELECT ARRAY_MIN([20, 0, NULL, 10, NULL]);

-- Example 3418
+------------------------------------+
| ARRAY_MIN([20, 0, NULL, 10, NULL]) |
|------------------------------------|
| 0                                  |
+------------------------------------+

-- Example 3419
SELECT ARRAY_MIN([]);

-- Example 3420
+---------------+
| ARRAY_MIN([]) |
|---------------|
| NULL          |
+---------------+

-- Example 3421
SELECT ARRAY_MIN([NULL, NULL, NULL]);

-- Example 3422
+-------------------------+
| ARRAY_MIN([NULL, NULL]) |
|-------------------------|
| NULL                    |
+-------------------------+

-- Example 3423
SELECT ARRAY_MIN([date1::TIMESTAMP, timestamp1]) AS array_min
  FROM (
      VALUES ('1999-01-01'::DATE, '2023-12-09 22:09:26.000000000'::TIMESTAMP),
             ('2023-12-09'::DATE, '1999-01-01 22:09:26.000000000'::TIMESTAMP)
          AS t(date1, timestamp1)
      );

-- Example 3424
+---------------------------+
| ARRAY_MIN                 |
|---------------------------|
| "1999-01-01 00:00:00.000" |
| "1999-01-01 22:09:26.000" |
+---------------------------+

-- Example 3425
ARRAY_POSITION( <variant_expr> , <array> )

-- Example 3426
SELECT ARRAY_POSITION('hello'::variant, array_construct('hello', 'hi'));
+------------------------------------------------------------------+
| ARRAY_POSITION('HELLO'::VARIANT, ARRAY_CONSTRUCT('HELLO', 'HI')) |
|------------------------------------------------------------------|
|                                                                0 |
+------------------------------------------------------------------+

-- Example 3427
SELECT ARRAY_POSITION('hi'::variant, array_construct('hello', 'hi'));
+---------------------------------------------------------------+
| ARRAY_POSITION('HI'::VARIANT, ARRAY_CONSTRUCT('HELLO', 'HI')) |
|---------------------------------------------------------------|
|                                                             1 |
+---------------------------------------------------------------+

-- Example 3428
SELECT ARRAY_POSITION('hello'::variant, array_construct('hola', 'bonjour'));
+----------------------------------------------------------------------+
| ARRAY_POSITION('HELLO'::VARIANT, ARRAY_CONSTRUCT('HOLA', 'BONJOUR')) |
|----------------------------------------------------------------------|
|                                                                 NULL |
+----------------------------------------------------------------------+

-- Example 3429
ARRAY_PREPEND( <array> , <new_element> )

-- Example 3430
SELECT ARRAY_PREPEND(ARRAY_CONSTRUCT(0,1,2,3),'hello');
+-------------------------------------------------+
| ARRAY_PREPEND(ARRAY_CONSTRUCT(0,1,2,3),'HELLO') |
|-------------------------------------------------|
| [                                               |
|   "hello",                                      |
|   0,                                            |
|   1,                                            |
|   2,                                            |
|   3                                             |
| ]                                               |
+-------------------------------------------------+

-- Example 3431
ARRAY_REMOVE( <array> , <value_of_elements_to_remove> )

-- Example 3432
SELECT ARRAY_REMOVE(
  [1, 5, 5.00, 5.00::DOUBLE, '5', 5, NULL],
  5);

-- Example 3433
+---------------------------------------------+
| ARRAY_REMOVE(                               |
|   [1, 5, 5.00, 5.00::DOUBLE, '5', 5, NULL], |
|   5)                                        |
|---------------------------------------------|
| [                                           |
|   1,                                        |
|   "5",                                      |
|   undefined                                 |
| ]                                           |
+---------------------------------------------+

-- Example 3434
SELECT ARRAY_REMOVE([5, 5], 5);

-- Example 3435
+-------------------------+
| ARRAY_REMOVE([5, 5], 5) |
|-------------------------|
| []                      |
+-------------------------+

-- Example 3436
SELECT ARRAY_REMOVE(
  ['a', 'b', 'a', 'c', 'd', 'a'],
  'a'::VARIANT);

-- Example 3437
+-----------------------------------+
| ARRAY_REMOVE(                     |
|   ['A', 'B', 'A', 'C', 'D', 'A'], |
|   'A'::VARIANT)                   |
|-----------------------------------|
| [                                 |
|   "b",                            |
|   "c",                            |
|   "d"                             |
| ]                                 |
+-----------------------------------+

-- Example 3438
ARRAY_REMOVE_AT( <array> , <position> )

-- Example 3439
SELECT ARRAY_REMOVE_AT(
  [2, 5, 7],
  0);

-- Example 3440
+-------------------------------+
| ARRAY_REMOVE_AT([2, 5, 7], 0) |
|-------------------------------|
| [                             |
|   5,                          |
|   7                           |
| ]                             |
+-------------------------------+

-- Example 3441
SELECT ARRAY_REMOVE_AT(
  [2, 5, 7],
  -1);

-- Example 3442
+--------------------------------+
| ARRAY_REMOVE_AT([2, 5, 7], -1) |
|--------------------------------|
| [                              |
|   2,                           |
|   5                            |
| ]                              |
+--------------------------------+

-- Example 3443
SELECT ARRAY_REMOVE_AT(
  [2, 5, 7],
  10);

-- Example 3444
+------------------+
| ARRAY_REMOVE_AT( |
|   [2, 5, 7],     |
|   10)            |
|------------------|
| [                |
|   2,             |
|   5,             |
|   7              |
| ]                |
+------------------+

-- Example 3445
ARRAY_REVERSE( <array> )

-- Example 3446
SELECT ARRAY_REVERSE([1,2,3,4]);

-- Example 3447
+--------------------------+
| ARRAY_REVERSE([1,2,3,4]) |
|--------------------------|
| [                        |
|   4,                     |
|   3,                     |
|   2,                     |
|   1                      |
| ]                        |
+--------------------------+

-- Example 3448
ARRAY_SIZE( <array> )

ARRAY_SIZE( <variant> )

-- Example 3449
SELECT ARRAY_SIZE(ARRAY_CONSTRUCT(1, 2, 3)) AS SIZE;
+------+
| SIZE |
|------|
|    3 |
+------+

-- Example 3450
CREATE OR replace TABLE colors (v variant);

INSERT INTO
   colors
   SELECT
      parse_json(column1) AS v
   FROM
   VALUES
     ('[{r:255,g:12,b:0},{r:0,g:255,b:0},{r:0,g:0,b:255}]'),
     ('[{r:255,g:128,b:0},{r:128,g:255,b:0},{r:0,g:255,b:128},{r:0,g:128,b:255},{r:128,g:0,b:255},{r:255,g:0,b:128}]')
    v;

-- Example 3451
SELECT ARRAY_SIZE(v) from colors;
+---------------+
| ARRAY_SIZE(V) |
|---------------|
|             3 |
|             6 |
+---------------+

-- Example 3452
SELECT GET(v, ARRAY_SIZE(v)-1) FROM colors;
+-------------------------+
| GET(V, ARRAY_SIZE(V)-1) |
|-------------------------|
| {                       |
|   "b": 255,             |
|   "g": 0,               |
|   "r": 0                |
| }                       |
| {                       |
|   "b": 128,             |
|   "g": 0,               |
|   "r": 255              |
| }                       |
+-------------------------+

-- Example 3453
ARRAY_SLICE( <array> , <from> , <to> )

-- Example 3454
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], 0, 2);

-- Example 3455
+------------------------------------+
| ARRAY_SLICE([0,1,2,3,4,5,6], 0, 2) |
|------------------------------------|
| [                                  |
|   0,                               |
|   1                                |
| ]                                  |
+------------------------------------+

-- Example 3456
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], 3, ARRAY_SIZE([0,1,2,3,4,5,6])) AS slice_to_last_index;

-- Example 3457
+---------------------+
| SLICE_TO_LAST_INDEX |
|---------------------|
| [                   |
|   3,                |
|   4,                |
|   5,                |
|   6                 |
| ]                   |
+---------------------+

-- Example 3458
SELECT ARRAY_SLICE(['foo','snow','flake','bar'], 1, 3);

-- Example 3459
+-------------------------------------------------+
| ARRAY_SLICE(['FOO','SNOW','FLAKE','BAR'], 1, 3) |
|-------------------------------------------------|
| [                                               |
|   "snow",                                       |
|   "flake"                                       |
| ]                                               |
+-------------------------------------------------+

-- Example 3460
SELECT ARRAY_SLICE(NULL, 2, 3);

-- Example 3461
+-------------------------+
| ARRAY_SLICE(NULL, 2, 3) |
|-------------------------|
| NULL                    |
+-------------------------+

-- Example 3462
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], NULL, 2);

-- Example 3463
+---------------------------------------+
| ARRAY_SLICE([0,1,2,3,4,5,6], NULL, 2) |
|---------------------------------------|
| NULL                                  |
+---------------------------------------+

-- Example 3464
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], 0, -2);

-- Example 3465
+-------------------------------------+
| ARRAY_SLICE([0,1,2,3,4,5,6], 0, -2) |
|-------------------------------------|
| [                                   |
|   0,                                |
|   1,                                |
|   2,                                |
|   3,                                |
|   4                                 |
| ]                                   |
+-------------------------------------+

-- Example 3466
SELECT ARRAY_SLICE([0,1,2,3,4,5,6], -5, -3);

