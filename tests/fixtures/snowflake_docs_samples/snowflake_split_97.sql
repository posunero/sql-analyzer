-- Example 6480
ST_Y( <geography_or_geometry_expression> )

-- Example 6481
SELECT ST_X(ST_MAKEPOINT(37.5, 45.5)), ST_Y(ST_MAKEPOINT(37.5, 45.5));
+--------------------------------+--------------------------------+
| ST_X(ST_MAKEPOINT(37.5, 45.5)) | ST_Y(ST_MAKEPOINT(37.5, 45.5)) |
|--------------------------------+--------------------------------|
|                           37.5 |                           45.5 |
+--------------------------------+--------------------------------+

-- Example 6482
SELECT
    ST_X(ST_MAKEPOINT(NULL, NULL)), ST_X(NULL),
    ST_Y(ST_MAKEPOINT(NULL, NULL)), ST_Y(NULL)
    ;
+--------------------------------+------------+--------------------------------+------------+
| ST_X(ST_MAKEPOINT(NULL, NULL)) | ST_X(NULL) | ST_Y(ST_MAKEPOINT(NULL, NULL)) | ST_Y(NULL) |
|--------------------------------+------------+--------------------------------+------------|
|                           NULL |       NULL |                           NULL |       NULL |
+--------------------------------+------------+--------------------------------+------------+

-- Example 6483
ST_YMAX( <geography_or_geometry_expression> )

-- Example 6484
CREATE or replace TABLE extreme_point_collection (id INTEGER, g GEOGRAPHY);
INSERT INTO extreme_point_collection (id, g)
    SELECT column1, TO_GEOGRAPHY(column2) FROM VALUES
        (1, 'POINT(-180 0)'),
        (2, 'POINT(180 0)'),
        (3, 'LINESTRING(-179 0, 179 0)'),
        (4, 'LINESTRING(-60 30, 60 30)'),
        (5, 'LINESTRING(-60 -30, 60 -30)');

-- Example 6485
SELECT
    g,
    ST_XMIN(g),
    ST_XMAX(g),
    ST_YMIN(g),
    ST_YMAX(g)
  FROM extreme_point_collection
  ORDER BY id;
+----------------------------+------------+------------+-------------------+-------------------+
| G                          | ST_XMIN(G) | ST_XMAX(G) |        ST_YMIN(G) |        ST_YMAX(G) |
|----------------------------+------------+------------+-------------------+-------------------|
| POINT(-180 0)              |       -180 |        180 |   0               |   0               |
| POINT(180 0)               |       -180 |        180 |   0               |   0               |
| LINESTRING(-179 0,179 0)   |       -180 |        180 |  -6.883275617e-14 |   6.883275617e-14 |
| LINESTRING(-60 30,60 30)   |        -60 |         60 |  30               |  49.106605351     |
| LINESTRING(-60 -30,60 -30) |        -60 |         60 | -49.106605351     | -30               |
+----------------------------+------------+------------+-------------------+-------------------+

-- Example 6486
ST_YMIN( <geography_or_geometry_expression> )

-- Example 6487
CREATE or replace TABLE extreme_point_collection (id INTEGER, g GEOGRAPHY);
INSERT INTO extreme_point_collection (id, g)
    SELECT column1, TO_GEOGRAPHY(column2) FROM VALUES
        (1, 'POINT(-180 0)'),
        (2, 'POINT(180 0)'),
        (3, 'LINESTRING(-179 0, 179 0)'),
        (4, 'LINESTRING(-60 30, 60 30)'),
        (5, 'LINESTRING(-60 -30, 60 -30)');

-- Example 6488
SELECT
    g,
    ST_XMIN(g),
    ST_XMAX(g),
    ST_YMIN(g),
    ST_YMAX(g)
  FROM extreme_point_collection
  ORDER BY id;
+----------------------------+------------+------------+-------------------+-------------------+
| G                          | ST_XMIN(G) | ST_XMAX(G) |        ST_YMIN(G) |        ST_YMAX(G) |
|----------------------------+------------+------------+-------------------+-------------------|
| POINT(-180 0)              |       -180 |        180 |   0               |   0               |
| POINT(180 0)               |       -180 |        180 |   0               |   0               |
| LINESTRING(-179 0,179 0)   |       -180 |        180 |  -6.883275617e-14 |   6.883275617e-14 |
| LINESTRING(-60 30,60 30)   |        -60 |         60 |  30               |  49.106605351     |
| LINESTRING(-60 -30,60 -30) |        -60 |         60 | -49.106605351     | -30               |
+----------------------------+------------+------------+-------------------+-------------------+

-- Example 6489
STAGE_DIRECTORY_FILE_REGISTRATION_HISTORY (
      STAGE_NAME => '<string>'
      [, START_TIME => <constant_expr> ] )

-- Example 6490
SELECT *
  FROM TABLE(information_schema.stage_directory_file_registration_history(
  STAGE_NAME=>'MYSTAGE'));

-- Example 6491
SELECT *
  FROM TABLE(information_schema.stage_directory_file_registration_history(
    START_TIME=>DATEADD('hour',-1,current_timestamp()),
    STAGE_NAME=>'mydb.public.mystage'));

-- Example 6492
STAGE_STORAGE_USAGE_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [, DATE_RANGE_END => <constant_expr> ] )

-- Example 6493
select *
from table(information_schema.stage_storage_usage_history(dateadd('days',-10,current_date()),current_date()));

-- Example 6494
STARTSWITH( <expr1> , <expr2> )

-- Example 6495
select * from strings;

---------+
    S    |
---------+
 coffee  |
 ice tea |
 latte   |
 tea     |
 [NULL]  |
---------+

select * from strings where startswith(s, 'te');

-----+
  S  |
-----+
 tea |
-----+

-- Example 6496
STRIP_NULL_VALUE( <variant_expr> )

-- Example 6497
CREATE OR REPLACE TABLE mytable
(
  SRC Variant
);

INSERT INTO mytable
  SELECT PARSE_JSON(column1)
  FROM VALUES
  ('{
  "a": "1",
  "b": "2",
  "c": null
  }')
  , ('{
  "a": "1",
  "b": "2",
  "c": "3"
  }');

SELECT STRIP_NULL_VALUE(src:c) FROM mytable;

-- Example 6498
+-------------------------+
| STRIP_NULL_VALUE(SRC:C) |
|-------------------------|
| NULL                    |
| "3"                     |
+-------------------------+

-- Example 6499
STRTOK(<string> [,<delimiter>] [,<partNr>])

-- Example 6500
SELECT STRTOK('a.b.c', '.', 1);
+-------------------------+
| STRTOK('A.B.C', '.', 1) |
|-------------------------|
| a                       |
+-------------------------+

-- Example 6501
SELECT STRTOK('user@snowflake.com', '@.', 1);
+---------------------------------------+
| STRTOK('USER@SNOWFLAKE.COM', '@.', 1) |
|---------------------------------------|
| user                                  |
+---------------------------------------+

-- Example 6502
SELECT STRTOK('user@snowflake.com', '@.', 2);
+---------------------------------------+
| STRTOK('USER@SNOWFLAKE.COM', '@.', 2) |
|---------------------------------------|
| snowflake                             |
+---------------------------------------+

-- Example 6503
SELECT STRTOK('user@snowflake.com', '@.', 3);
+---------------------------------------+
| STRTOK('USER@SNOWFLAKE.COM', '@.', 3) |
|---------------------------------------|
| com                                   |
+---------------------------------------+

-- Example 6504
select strtok('user@snowflake.com.', '@.', 4);
+----------------------------------------+
| STRTOK('USER@SNOWFLAKE.COM.', '@.', 4) |
|----------------------------------------|
| NULL                                   |
+----------------------------------------+

-- Example 6505
select strtok('', '', 1);
+-------------------+
| STRTOK('', '', 1) |
|-------------------|
| NULL              |
+-------------------+

-- Example 6506
select strtok('a.b', '', 1);
+----------------------+
| STRTOK('A.B', '', 1) |
|----------------------|
| a.b                  |
+----------------------+

-- Example 6507
select strtok(NULL, '.', 1);
+----------------------+
| STRTOK(NULL, '.', 1) |
|----------------------|
| NULL                 |
+----------------------+

-- Example 6508
select strtok('a.b', NULL, 1);
+------------------------+
| STRTOK('A.B', NULL, 1) |
|------------------------|
| NULL                   |
+------------------------+

-- Example 6509
select strtok('a.b', '.', NULL);
+--------------------------+
| STRTOK('A.B', '.', NULL) |
|--------------------------|
| NULL                     |
+--------------------------+

-- Example 6510
STRTOK_SPLIT_TO_TABLE(<string> [,<delimiter_list>])

-- Example 6511
SELECT table1.value
  FROM TABLE(STRTOK_SPLIT_TO_TABLE('a.b', '.')) AS table1
  ORDER BY table1.value;

-- Example 6512
+-------+
| VALUE |
|-------|
| a     |
| b     |
+-------+

-- Example 6513
CREATE OR REPLACE TABLE splittable_strtok (v VARCHAR);
INSERT INTO splittable_strtok (v) VALUES ('a b'), ('cde'), ('f|g'), ('');
SELECT * FROM splittable_strtok;

-- Example 6514
+-----+
| V   |
|-----|
| a b |
| cde |
| f|g |
|     |
+-----+

-- Example 6515
SELECT *
  FROM splittable_strtok, LATERAL STRTOK_SPLIT_TO_TABLE(splittable_strtok.v, ' ')
  ORDER BY SEQ, INDEX;

-- Example 6516
+-----+-----+-------+-------+
| V   | SEQ | INDEX | VALUE |
|-----+-----+-------+-------|
| a b |   1 |     1 | a     |
| a b |   1 |     2 | b     |
| cde |   2 |     1 | cde   |
| f|g |   3 |     1 | f|g   |
+-----+-----+-------+-------+

-- Example 6517
SELECT *
  FROM splittable_strtok, LATERAL STRTOK_SPLIT_TO_TABLE(splittable_strtok.v, ' |')
  ORDER BY SEQ, INDEX;

-- Example 6518
+-----+-----+-------+-------+
| V   | SEQ | INDEX | VALUE |
|-----+-----+-------+-------|
| a b |   1 |     1 | a     |
| a b |   1 |     2 | b     |
| cde |   2 |     1 | cde   |
| f|g |   3 |     1 | f     |
| f|g |   3 |     2 | g     |
+-----+-----+-------+-------+

-- Example 6519
CREATE OR REPLACE TABLE authors_books_test2 (author VARCHAR, titles VARCHAR);
INSERT INTO authors_books_test2 (author, titles) VALUES
  ('Nathaniel Hawthorne', 'The Scarlet Letter ; The House of the Seven Gables;The Blithedale Romance'),
  ('Herman Melville', 'Moby Dick,The Confidence-Man');
SELECT * FROM authors_books_test2;

-- Example 6520
+---------------------+---------------------------------------------------------------------------+
| AUTHOR              | TITLES                                                                    |
|---------------------+---------------------------------------------------------------------------|
| Nathaniel Hawthorne | The Scarlet Letter ; The House of the Seven Gables;The Blithedale Romance |
| Herman Melville     | Moby Dick,The Confidence-Man                                              |
+---------------------+---------------------------------------------------------------------------+

-- Example 6521
SELECT author, TRIM(value) AS title
  FROM authors_books_test2, LATERAL STRTOK_SPLIT_TO_TABLE(titles, ',;')
  ORDER BY author;

-- Example 6522
+---------------------+-------------------------------+
| AUTHOR              | TITLE                         |
|---------------------+-------------------------------|
| Herman Melville     | Moby Dick                     |
| Herman Melville     | The Confidence-Man            |
| Nathaniel Hawthorne | The Scarlet Letter            |
| Nathaniel Hawthorne | The House of the Seven Gables |
| Nathaniel Hawthorne | The Blithedale Romance        |
+---------------------+-------------------------------+

-- Example 6523
STRTOK_TO_ARRAY(<string> [,<delimiter>])

-- Example 6524
SELECT STRTOK_TO_ARRAY('a.b.c', '.');
+-------------------------------+
| STRTOK_TO_ARRAY('A.B.C', '.') |
|-------------------------------|
| [                             |
|   "a",                        |
|   "b",                        |
|   "c"                         |
| ]                             |
+-------------------------------+

-- Example 6525
SELECT STRTOK_TO_ARRAY('user@snowflake.com', '.@');
+---------------------------------------------+
| STRTOK_TO_ARRAY('USER@SNOWFLAKE.COM', '.@') |
|---------------------------------------------|
| [                                           |
|   "user",                                   |
|   "snowflake",                              |
|   "com"                                     |
| ]                                           |
+---------------------------------------------+

-- Example 6526
SUBSTR( <base_expr>, <start_expr> [ , <length_expr> ] )

SUBSTRING( <base_expr>, <start_expr> [ , <length_expr> ] )

-- Example 6527
SELECT SUBSTR('testing 1 2 3', 9, 3);

-- Example 6528
+-------------------------------+
| SUBSTR('TESTING 1 2 3', 9, 3) |
|-------------------------------|
| 1 2                           |
+-------------------------------+

-- Example 6529
CREATE OR REPLACE TABLE test_substr (
    base_value VARCHAR,
    start_value INT,
    length_value INT)
  AS SELECT
    column1,
    column2,
    column3
  FROM
    VALUES
      ('mystring', -1, 3),
      ('mystring', -3, 3),
      ('mystring', -3, 7),
      ('mystring', -5, 3),
      ('mystring', -7, 3),
      ('mystring', 0, 3),
      ('mystring', 0, 7),
      ('mystring', 1, 3),
      ('mystring', 1, 7),
      ('mystring', 3, 3),
      ('mystring', 3, 7),
      ('mystring', 5, 3),
      ('mystring', 5, 7),
      ('mystring', 7, 3),
      ('mystring', NULL, 3),
      ('mystring', 3, NULL);

SELECT base_value,
       start_value,
       length_value,
       SUBSTR(base_value, start_value, length_value) AS substring
  FROM test_substr;

-- Example 6530
+------------+-------------+--------------+-----------+
| BASE_VALUE | START_VALUE | LENGTH_VALUE | SUBSTRING |
|------------+-------------+--------------+-----------|
| mystring   |          -1 |            3 | g         |
| mystring   |          -3 |            3 | ing       |
| mystring   |          -3 |            7 | ing       |
| mystring   |          -5 |            3 | tri       |
| mystring   |          -7 |            3 | yst       |
| mystring   |           0 |            3 | mys       |
| mystring   |           0 |            7 | mystrin   |
| mystring   |           1 |            3 | mys       |
| mystring   |           1 |            7 | mystrin   |
| mystring   |           3 |            3 | str       |
| mystring   |           3 |            7 | string    |
| mystring   |           5 |            3 | rin       |
| mystring   |           5 |            7 | ring      |
| mystring   |           7 |            3 | ng        |
| mystring   |        NULL |            3 | NULL      |
| mystring   |           3 |         NULL | NULL      |
+------------+-------------+--------------+-----------+

-- Example 6531
CREATE OR REPLACE TABLE customer_contact_example (
    cust_id INT,
    cust_email VARCHAR,
    cust_phone VARCHAR,
    activation_date VARCHAR)
  AS SELECT
    column1,
    column2,
    column3,
    column4
  FROM
    VALUES
      (1, 'some_text@example.com', '800-555-0100', '20210320'),
      (2, 'some_other_text@example.org', '800-555-0101', '20240509'),
      (3, 'some_different_text@example.net', '800-555-0102', '20191017');

SELECT * from customer_contact_example;

-- Example 6532
+---------+---------------------------------+--------------+-----------------+
| CUST_ID | CUST_EMAIL                      | CUST_PHONE   | ACTIVATION_DATE |
|---------+---------------------------------+--------------+-----------------|
|       1 | some_text@example.com           | 800-555-0100 | 20210320        |
|       2 | some_other_text@example.org     | 800-555-0101 | 20240509        |
|       3 | some_different_text@example.net | 800-555-0102 | 20191017        |
+---------+---------------------------------+--------------+-----------------+

-- Example 6533
SELECT cust_id,
       cust_email,
       SUBSTR(cust_email, POSITION('@' IN cust_email) + 1) AS domain
  FROM customer_contact_example;

-- Example 6534
+---------+---------------------------------+-------------+
| CUST_ID | CUST_EMAIL                      | DOMAIN      |
|---------+---------------------------------+-------------|
|       1 | some_text@example.com           | example.com |
|       2 | some_other_text@example.org     | example.org |
|       3 | some_different_text@example.net | example.net |
+---------+---------------------------------+-------------+

-- Example 6535
SELECT cust_id,
       cust_phone,
       SUBSTR(cust_phone, 1, 3) AS area_code
  FROM customer_contact_example;

-- Example 6536
+---------+--------------+-----------+
| CUST_ID | CUST_PHONE   | AREA_CODE |
|---------+--------------+-----------|
|       1 | 800-555-0100 | 800       |
|       2 | 800-555-0101 | 800       |
|       3 | 800-555-0102 | 800       |
+---------+--------------+-----------+

-- Example 6537
SELECT cust_id,
       cust_phone,
       SUBSTR(cust_phone, 5) AS phone_without_area_code
  FROM customer_contact_example;

-- Example 6538
+---------+--------------+-------------------------+
| CUST_ID | CUST_PHONE   | PHONE_WITHOUT_AREA_CODE |
|---------+--------------+-------------------------|
|       1 | 800-555-0100 | 555-0100                |
|       2 | 800-555-0101 | 555-0101                |
|       3 | 800-555-0102 | 555-0102                |
+---------+--------------+-------------------------+

-- Example 6539
SELECT cust_id,
       activation_date,
       SUBSTR(activation_date, 1, 4) AS year,
       SUBSTR(activation_date, 5, 2) AS month,
       SUBSTR(activation_date, 7, 2) AS day
  FROM customer_contact_example;

-- Example 6540
+---------+-----------------+------+-------+-----+
| CUST_ID | ACTIVATION_DATE | YEAR | MONTH | DAY |
|---------+-----------------+------+-------+-----|
|       1 | 20210320        | 2021 | 03    | 20  |
|       2 | 20240509        | 2024 | 05    | 09  |
|       3 | 20191017        | 2019 | 10    | 17  |
+---------+-----------------+------+-------+-----+

-- Example 6541
SNOWFLAKE.CORTEX.SUMMARIZE(<text>)

-- Example 6542
SELECT SNOWFLAKE.CORTEX.SUMMARIZE(review_content) FROM reviews LIMIT 10;

-- Example 6543
SYSDATE()

-- Example 6544
ALTER SESSION SET TIMESTAMP_NTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF4';
ALTER SESSION SET TIMESTAMP_LTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF4';

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

SELECT SYSDATE(), CURRENT_TIMESTAMP();

-- Example 6545
+--------------------------+--------------------------+
| SYSDATE()                | CURRENT_TIMESTAMP()      |
|--------------------------+--------------------------|
| 2024-04-17 22:47:54.3520 | 2024-04-17 15:47:54.3520 |
+--------------------------+--------------------------+

-- Example 6546
SYSTEM$ABORT_SESSION( <session_id> )

