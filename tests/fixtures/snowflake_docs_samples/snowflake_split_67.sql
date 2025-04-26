-- Example 4472
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'image.jpg', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_STAGE(f) FROM file_table;

-- Example 4473
+------------------------+
| FL_GET_STAGE(F)        |
|------------------------|
| MYSTAGE                |
+------------------------+

-- Example 4474
FL_GET_STAGE_FILE_URL( <stage_name>, <relative_path> )

FL_GET_STAGE_FILE_URL( <file_url> )

FL_GET_STAGE_FILE_URL( <metadata> )

-- Example 4475
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_STAGE_FILE_URL(f) FROM file_table;

-- Example 4476
+-------------------------------------------------------------------------------------------+
| FL_GET_STAGE_FILE_URL(F)                                                                  |
|-------------------------------------------------------------------------------------------|
| https://snowflake.account.snowflakecomputing.com/api/files/TEST/PUBLIC/MYSTAGE/image.png  |
+-------------------------------------------------------------------------------------------+

-- Example 4477
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE_FILE_URL', 'https://snowflake.account.snowflakecomputing.com/api/files/TEST/PUBLIC/MYSTAGE/image.png',
  'ETAG', '<ETAG value>', 'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_STAGE_FILE_URL(f) FROM file_table;

-- Example 4478
+-------------------------------------------------------------------------------------------+
| FL_GET_STAGE_FILE_URL(F)                                                                  |
|-------------------------------------------------------------------------------------------|
| https://snowflake.account.snowflakecomputing.com/api/files/TEST/PUBLIC/MYSTAGE/image.png  |
+-------------------------------------------------------------------------------------------+

-- Example 4479
FL_IS_AUDIO( <stage_name>, <relative_path> )

FL_IS_AUDIO( <file_url> )

FL_IS_AUDIO( <metadata> )

-- Example 4480
CREATE TABLE file_table(f FILE);
insert into file_table select to_file(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_IS_AUDIO(f) FROM file_table;

-- Example 4481
+-------------------+
| FL_IS_AUDIO(F)    |
|-------------------|
| False             |
+-------------------+

-- Example 4482
CREATE TABLE file_table(f OBJECT);

INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'music.mpeg', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'audio/mpeg');

SELECT FL_IS_AUDIO(f) FROM file_table;

-- Example 4483
+-------------------+
| FL_IS_AUDIO(F)    |
|-------------------|
| True              |
+-------------------+

-- Example 4484
FL_IS_COMPRESSED( <stage_name>, <relative_path> )

FL_IS_COMPRESSED( <file_url> )

FL_IS_COMPRESSED( <metadata> )

-- Example 4485
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_IS_COMPRESSED(f) FROM file_table;

-- Example 4486
+---------------------+
| FL_IS_COMPRESSED(F) |
|---------------------|
| False               |
+---------------------+

-- Example 4487
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'document.pdf.gz', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'application/gzip');

SELECT FL_IS_COMPRESSED(f) FROM file_table;

-- Example 4488
+---------------------+
| FL_IS_COMPRESSED(F) |
|---------------------|
| True                |
+---------------------+

-- Example 4489
FL_IS_DOCUMENT( <stage_name>, <relative_path> )

FL_IS_DOCUMENT( <file_url> )

FL_IS_DOCUMENT( <metadata> )

-- Example 4490
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_IS_DOCUMENT(f) FROM file_table;

-- Example 4491
+-------------------+
| FL_IS_DOCUMENT(F) |
|-------------------|
| False             |
+-------------------+

-- Example 4492
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'document.pdf', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'application/pdf');

SELECT FL_IS_DOCUMENT(f) FROM file_table;

-- Example 4493
+-------------------+
| FL_IS_DOCUMENT(F) |
|-------------------|
| True              |
+-------------------+

-- Example 4494
FL_IS_IMAGE( <stage_name>, <relative_path> )

FL_IS_IMAGE( <file_url> )

FL_IS_IMAGE( <metadata> )

-- Example 4495
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_IS_IMAGE(f) FROM file_table;

-- Example 4496
+-------------------+
| FL_IS_IMAGE(F)    |
|-------------------|
| True              |
+-------------------+

-- Example 4497
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'document.pdf', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'application/pdf');

SELECT FL_IS_IMAGE(f) FROM file_table;

-- Example 4498
+-------------------+
| FL_IS_IMAGE(F)    |
|-------------------|
| False             |
+-------------------+

-- Example 4499
FL_IS_VIDEO( <stage_name>, <relative_path> )

FL_IS_VIDEO( <file_url> )

FL_IS_VIDEO( <metadata> )

-- Example 4500
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_IS_VIDEO(f) FROM file_table;

-- Example 4501
+-------------------+
| FL_IS_VIDEO(F)    |
|-------------------|
| False             |
+-------------------+

-- Example 4502
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'movie.mp4', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'video/mp4');

SELECT FL_IS_VIDEO(f) FROM file_table;

-- Example 4503
+-------------------+
| FL_IS_VIDEO(F)    |
|-------------------|
| True              |
+-------------------+

-- Example 4504
FLATTEN( INPUT => <expr> [ , PATH => <constant_expr> ]
                         [ , OUTER => TRUE | FALSE ]
                         [ , RECURSIVE => TRUE | FALSE ]
                         [ , MODE => 'OBJECT' | 'ARRAY' | 'BOTH' ] )

-- Example 4505
+-----+------+------+-------+-------+------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS |
|-----+------+------+-------+-------+------|

-- Example 4506
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('[1, ,77]'))) f;

-- Example 4507
+-----+------+------+-------+-------+------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS |
|-----+------+------+-------+-------+------|
|   1 | NULL | [0]  |     0 |     1 | [    |
|     |      |      |       |       |   1, |
|     |      |      |       |       |   ,  |
|     |      |      |       |       |   77 |
|     |      |      |       |       | ]    |
|   1 | NULL | [2]  |     2 |    77 | [    |
|     |      |      |       |       |   1, |
|     |      |      |       |       |   ,  |
|     |      |      |       |       |   77 |
|     |      |      |       |       | ]    |
+-----+------+------+-------+-------+------+

-- Example 4508
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88]}'), OUTER => TRUE)) f;

-- Example 4509
+-----+-----+------+-------+-------+-----------+
| SEQ | KEY | PATH | INDEX | VALUE | THIS      |
|-----+-----+------+-------+-------+-----------|
|     |     |      |       |       |   "a": 1, |
|     |     |      |       |       |   "b": [  |
|     |     |      |       |       |     77,   |
|     |     |      |       |       |     88    |
|     |     |      |       |       |   ]       |
|     |     |      |       |       | }         |
|   1 | b   | b    |  NULL | [     | {         |
|     |     |      |       |   77, |   "a": 1, |
|     |     |      |       |   88  |   "b": [  |
|     |     |      |       | ]     |     77,   |
|     |     |      |       |       |     88    |
|     |     |      |       |       |   ]       |
|     |     |      |       |       | }         |
+-----+-----+------+-------+-------+-----------+

-- Example 4510
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88]}'), PATH => 'b')) f;

-- Example 4511
+-----+------+------+-------+-------+-------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS  |
|-----+------+------+-------+-------+-------|
|   1 | NULL | b[0] |     0 |    77 | [     |
|     |      |      |       |       |   77, |
|     |      |      |       |       |   88  |
|     |      |      |       |       | ]     |
|   1 | NULL | b[1] |     1 |    88 | [     |
|     |      |      |       |       |   77, |
|     |      |      |       |       |   88  |
|     |      |      |       |       | ]     |
+-----+------+------+-------+-------+-------+

-- Example 4512
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('[]'))) f;

-- Example 4513
+-----+-----+------+-------+-------+------+
| SEQ | KEY | PATH | INDEX | VALUE | THIS |
|-----+-----+------+-------+-------+------|
+-----+-----+------+-------+-------+------+

-- Example 4514
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('[]'), OUTER => TRUE)) f;

-- Example 4515
+-----+------+------+-------+-------+------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS |
|-----+------+------+-------+-------+------|
|   1 | NULL |      |  NULL |  NULL | []   |
+-----+------+------+-------+-------+------+

-- Example 4516
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88], "c": {"d":"X"}}'))) f;

-- Example 4517
+-----+-----+------+-------+------------+--------------+
| SEQ | KEY | PATH | INDEX | VALUE      | THIS         |
|-----+-----+------+-------+------------+--------------|
|   1 | a   | a    |  NULL | 1          | {            |
|     |     |      |       |            |   "a": 1,    |
|     |     |      |       |            |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | b   | b    |  NULL | [          | {            |
|     |     |      |       |   77,      |   "a": 1,    |
|     |     |      |       |   88       |   "b": [     |
|     |     |      |       | ]          |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | c   | c    |  NULL | {          | {            |
|     |     |      |       |   "d": "X" |   "a": 1,    |
|     |     |      |       | }          |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
+-----+-----+------+-------+------------+--------------+

-- Example 4518
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88], "c": {"d":"X"}}'),
                            RECURSIVE => TRUE )) f;

-- Example 4519
+-----+------+------+-------+------------+--------------+
| SEQ | KEY  | PATH | INDEX | VALUE      | THIS         |
|-----+------+------+-------+------------+--------------|
|   1 | a    | a    |  NULL | 1          | {            |
|     |      |      |       |            |   "a": 1,    |
|     |      |      |       |            |   "b": [     |
|     |      |      |       |            |     77,      |
|     |      |      |       |            |     88       |
|     |      |      |       |            |   ],         |
|     |      |      |       |            |   "c": {     |
|     |      |      |       |            |     "d": "X" |
|     |      |      |       |            |   }          |
|     |      |      |       |            | }            |
|   1 | b    | b    |  NULL | [          | {            |
|     |      |      |       |   77,      |   "a": 1,    |
|     |      |      |       |   88       |   "b": [     |
|     |      |      |       | ]          |     77,      |
|     |      |      |       |            |     88       |
|     |      |      |       |            |   ],         |
|     |      |      |       |            |   "c": {     |
|     |      |      |       |            |     "d": "X" |
|     |      |      |       |            |   }          |
|     |      |      |       |            | }            |
|   1 | NULL | b[0] |     0 | 77         | [            |
|     |      |      |       |            |   77,        |
|     |      |      |       |            |   88         |
|     |      |      |       |            | ]            |
|   1 | NULL | b[1] |     1 | 88         | [            |
|     |      |      |       |            |   77,        |
|     |      |      |       |            |   88         |
|     |      |      |       |            | ]            |
|   1 | c    | c    |  NULL | {          | {            |
|     |      |      |       |   "d": "X" |   "a": 1,    |
|     |      |      |       | }          |   "b": [     |
|     |      |      |       |            |     77,      |
|     |      |      |       |            |     88       |
|     |      |      |       |            |   ],         |
|     |      |      |       |            |   "c": {     |
|     |      |      |       |            |     "d": "X" |
|     |      |      |       |            |   }          |
|     |      |      |       |            | }            |
|   1 | d    | c.d  |  NULL | "X"        | {            |
|     |      |      |       |            |   "d": "X"   |
|     |      |      |       |            | }            |
+-----+------+------+-------+------------+--------------+

-- Example 4520
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88], "c": {"d":"X"}}'),
                            RECURSIVE => TRUE, MODE => 'OBJECT' )) f;

-- Example 4521
+-----+-----+------+-------+------------+--------------+
| SEQ | KEY | PATH | INDEX | VALUE      | THIS         |
|-----+-----+------+-------+------------+--------------|
|   1 | a   | a    |  NULL | 1          | {            |
|     |     |      |       |            |   "a": 1,    |
|     |     |      |       |            |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | b   | b    |  NULL | [          | {            |
|     |     |      |       |   77,      |   "a": 1,    |
|     |     |      |       |   88       |   "b": [     |
|     |     |      |       | ]          |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | c   | c    |  NULL | {          | {            |
|     |     |      |       |   "d": "X" |   "a": 1,    |
|     |     |      |       | }          |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | d   | c.d  |  NULL | "X"        | {            |
|     |     |      |       |            |   "d": "X"   |
|     |     |      |       |            | }            |
+-----+-----+------+-------+------------+--------------+

-- Example 4522
CREATE OR REPLACE TABLE persons AS
  SELECT column1 AS id, PARSE_JSON(column2) as c
    FROM values
      (12712555,
       '{ name:  { first: "John", last: "Smith"},
         contact: [
         { business:[
           { type: "phone", content:"555-1234" },
           { type: "email", content:"j.smith@example.com" } ] } ] }'),
      (98127771,
       '{ name:  { first: "Jane", last: "Doe"},
         contact: [
         { business:[
           { type: "phone", content:"555-1236" },
           { type: "email", content:"j.doe@example.com" } ] } ] }') v;

-- Example 4523
SELECT id as "ID",
    f.value AS "Contact",
    f1.value:type AS "Type",
    f1.value:content AS "Details"
  FROM persons p,
    LATERAL FLATTEN(INPUT => p.c, PATH => 'contact') f,
    LATERAL FLATTEN(INPUT => f.value:business) f1;

-- Example 4524
+----------+-----------------------------------------+---------+-----------------------+
|       ID | Contact                                 | Type    | Details               |
|----------+-----------------------------------------+---------+-----------------------|
| 12712555 | {                                       | "phone" | "555-1234"            |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1234",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.smith@example.com", |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
| 12712555 | {                                       | "email" | "j.smith@example.com" |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1234",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.smith@example.com", |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
| 98127771 | {                                       | "phone" | "555-1236"            |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1236",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.doe@example.com",   |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
| 98127771 | {                                       | "email" | "j.doe@example.com"   |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1236",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.doe@example.com",   |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
+----------+-----------------------------------------+---------+-----------------------+

-- Example 4525
FLOOR( <input_expr> [, <scale_expr> ] )

-- Example 4526
SELECT FLOOR(135.135), FLOOR(-975.975);
+----------------+-----------------+
| FLOOR(135.135) | FLOOR(-975.975) |
|----------------+-----------------|
|            135 |            -976 |
+----------------+-----------------+

-- Example 4527
CREATE TABLE test_floor (n FLOAT, scale INTEGER);
INSERT INTO test_floor (n, scale) VALUES
   (-975.975, -1),
   (-975.975,  0),
   (-975.975,  2),
   ( 135.135, -2),
   ( 135.135,  0),
   ( 135.135,  1),
   ( 135.135,  3),
   ( 135.135, 50),
   ( 135.135, NULL)
   ;

-- Example 4528
SELECT n, scale, FLOOR(n, scale)
  FROM test_floor
  ORDER BY n, scale;
+----------+-------+-----------------+
|        N | SCALE | FLOOR(N, SCALE) |
|----------+-------+-----------------|
| -975.975 |    -1 |        -980     |
| -975.975 |     0 |        -976     |
| -975.975 |     2 |        -975.98  |
|  135.135 |    -2 |         100     |
|  135.135 |     0 |         135     |
|  135.135 |     1 |         135.1   |
|  135.135 |     3 |         135.135 |
|  135.135 |    50 |         135.135 |
|  135.135 |  NULL |            NULL |
+----------+-------+-----------------+

-- Example 4529
GENERATE_COLUMN_DESCRIPTION( <expr> , '<string>' )

-- Example 4530
-- Create a file format that sets the file type as Parquet.
CREATE FILE FORMAT my_parquet_format
  TYPE = parquet;

-- Query the GENERATE_COLUMN_DESCRIPTION function.
SELECT GENERATE_COLUMN_DESCRIPTION(ARRAY_AGG(OBJECT_CONSTRUCT(*)), 'table') AS COLUMNS
  FROM TABLE (
    INFER_SCHEMA(
      LOCATION=>'@mystage',
      FILE_FORMAT=>'my_parquet_format'
    )
  );

+--------------------+
| COLUMN_DESCRIPTION |
|--------------------|
| "country" VARIANT, |
| "continent" TEXT   |
+--------------------+

-- The function output can be used to define the columns in a table.
CREATE TABLE mytable ("country" VARIANT, "continent" TEXT);

-- Example 4531
-- Query the GENERATE_COLUMN_DESCRIPTION function.
SELECT GENERATE_COLUMN_DESCRIPTION(ARRAY_AGG(OBJECT_CONSTRUCT(*)), 'external_table') AS COLUMNS
  FROM TABLE (
    INFER_SCHEMA(
      LOCATION=>'@mystage',
      FILE_FORMAT=>'my_parquet_format'
    )
  );

+---------------------------------------------+
| COLUMN_DESCRIPTION                          |
|---------------------------------------------|
| "country" VARIANT AS ($1:country::VARIANT), |
| "continent" TEXT AS ($1:continent::TEXT)    |
+---------------------------------------------+

-- Example 4532
-- Query the GENERATE_COLUMN_DESCRIPTION function.
SELECT GENERATE_COLUMN_DESCRIPTION(ARRAY_AGG(OBJECT_CONSTRUCT(*)), 'view') AS COLUMNS
  FROM TABLE (
    INFER_SCHEMA(
      LOCATION=>'@mystage',
      FILE_FORMAT=>'my_parquet_format'
    )
  );

+--------------------+
| COLUMN_DESCRIPTION |
|--------------------|
| "country" ,        |
| "continent"        |
+--------------------+

-- Example 4533
INFER_SCHEMA(
  LOCATION => '{ internalStage | externalStage }'
  , FILE_FORMAT => '<file_format_name>'
  , FILES => ( '<file_name>' [ , '<file_name>' ] [ , ... ] )
  , IGNORE_CASE => TRUE | FALSE
  , MAX_FILE_COUNT => <num>
  , MAX_RECORDS_PER_FILE => <num>
)

-- Example 4534
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>][/<filename>]
  | @~[/<path>][/<filename>]

-- Example 4535
externalStage ::=
  @[<namespace>.]<ext_stage_name>[/<path>][/<filename>]

-- Example 4536
-- Create a file format that sets the file type as Parquet.
CREATE FILE FORMAT my_parquet_format
  TYPE = parquet;

-- Query the INFER_SCHEMA function.
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@mystage'
      , FILE_FORMAT=>'my_parquet_format'
      )
    );

+-------------+---------+----------+---------------------+--------------------------+----------+
| COLUMN_NAME | TYPE    | NULLABLE | EXPRESSION          | FILENAMES                | ORDER_ID |
|-------------+---------+----------+---------------------+--------------------------|----------+
| continent   | TEXT    | True     | $1:continent::TEXT  | geography/cities.parquet | 0        |
| country     | VARIANT | True     | $1:country::VARIANT | geography/cities.parquet | 1        |
| COUNTRY     | VARIANT | True     | $1:COUNTRY::VARIANT | geography/cities.parquet | 2        |
+-------------+---------+----------+---------------------+--------------------------+----------+

-- Example 4537
-- Query the INFER_SCHEMA function.
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@mystage/geography/cities.parquet'
      , FILE_FORMAT=>'my_parquet_format'
      )
    );

+-------------+---------+----------+---------------------+--------------------------+----------+
| COLUMN_NAME | TYPE    | NULLABLE | EXPRESSION          | FILENAMES                | ORDER_ID |
|-------------+---------+----------+---------------------+--------------------------|----------+
| continent   | TEXT    | True     | $1:continent::TEXT  | geography/cities.parquet | 0        |
| country     | VARIANT | True     | $1:country::VARIANT | geography/cities.parquet | 1        |
| COUNTRY     | VARIANT | True     | $1:COUNTRY::VARIANT | geography/cities.parquet | 2        |
+-------------+---------+----------+---------------------+--------------------------+----------+

-- Example 4538
-- Query the INFER_SCHEMA function.
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@mystage'
      , FILE_FORMAT=>'my_parquet_format'
      , IGNORE_CASE=>TRUE
      )
    );

+-------------+---------+----------+----------------------------------------+--------------------------+----------+
| COLUMN_NAME | TYPE    | NULLABLE | EXPRESSION                             | FILENAMES                | ORDER_ID |
|-------------+---------+----------+---------------------+---------------------------------------------|----------+
| CONTINENT   | TEXT    | True     | GET_IGNORE_CASE ($1, CONTINENT)::TEXT  | geography/cities.parquet | 0        |
| COUNTRY     | VARIANT | True     | GET_IGNORE_CASE ($1, COUNTRY)::VARIANT | geography/cities.parquet | 1        |
+-------------+---------+----------+---------------------+---------------------------------------------+----------+

