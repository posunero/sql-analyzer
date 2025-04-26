-- Example 11303
SHOW TERSE TABLES;

-- Example 11304
+-------------------------------+------+-------+---------------+-------------+
| created_on                    | name | kind  | database_name | schema_name |
|-------------------------------+------+-------+---------------+-------------|
| 2024-11-14 16:05:14.102 -0800 | HT1  | TABLE | CLONE_TESTDB  | TESTDATA    |
| 2024-11-14 16:05:14.102 -0800 | ST1  | TABLE | CLONE_TESTDB  | TESTDATA    |
+-------------------------------+------+-------+---------------+-------------+

-- Example 11305
SHOW TERSE TABLES;

-- Example 11306
+-------------------------------+------+-------+---------------+-------------+
| created_on                    | name | kind  | database_name | schema_name |
|-------------------------------+------+-------+---------------+-------------|
| 2024-11-14 15:59:32.683 -0800 | HT1  | TABLE | TESTDB        | TESTDATA    |
| 2024-11-14 17:37:24.304 -0800 | HT2  | TABLE | TESTDB        | TESTDATA    |
| 2024-11-14 16:00:01.360 -0800 | ST1  | TABLE | TESTDB        | TESTDATA    |
+-------------------------------+------+-------+---------------+-------------+

-- Example 11307
DROP TABLE HT2;

-- Example 11308
+---------------------------+
| status                    |
|---------------------------|
| HT2 successfully dropped. |
+---------------------------+

-- Example 11309
SHOW TERSE TABLES;

-- Example 11310
+-------------------------------+------+-------+---------------+-------------+
| created_on                    | name | kind  | database_name | schema_name |
|-------------------------------+------+-------+---------------+-------------|
| 2024-11-14 15:59:32.683 -0800 | HT1  | TABLE | TESTDB        | TESTDATA    |
| 2024-11-14 16:00:01.360 -0800 | ST1  | TABLE | TESTDB        | TESTDATA    |
+-------------------------------+------+-------+---------------+-------------+

-- Example 11311
CREATE OR REPLACE DATABASE restore_testdb
  CLONE testdb AT(TIMESTAMP => '2024-11-14 17:38'::TIMESTAMP_LTZ);

-- Example 11312
+-----------------------------------------------+
| status                                        |
|-----------------------------------------------|
| Database RESTORE_TESTDB successfully created. |
+-----------------------------------------------+

-- Example 11313
USE DATABASE restore_testdb;
USE SCHEMA testdata;
SHOW TERSE TABLES;

-- Example 11314
+-------------------------------+------+-------+----------------+-------------+
| created_on                    | name | kind  | database_name  | schema_name |
|-------------------------------+------+-------+----------------+-------------|
| 2024-11-14 17:47:58.984 -0800 | HT1  | TABLE | RESTORE_TESTDB | TESTDATA    |
| 2024-11-14 17:47:58.984 -0800 | HT2  | TABLE | RESTORE_TESTDB | TESTDATA    |
| 2024-11-14 17:47:58.984 -0800 | ST1  | TABLE | RESTORE_TESTDB | TESTDATA    |
+-------------------------------+------+-------+----------------+-------------+

-- Example 11315
SELECT COUNT(*) FROM sensor_data_service2
  AT(TIMESTAMP => 'Mon, 25 Nov 2024 14:09:00'::TIMESTAMP_LTZ) WHERE MOTOR_RPM>1504;

-- Example 11316
+----------+
| COUNT(*) |
|----------|
|     1855 |
+----------+

-- Example 11317
SELECT COUNT(*) FROM sensor_data_service2
  AT(TIMESTAMP => 'Mon, 25 Nov 2024 14:10:00'::TIMESTAMP_LTZ) WHERE MOTOR_RPM>1504;

-- Example 11318
+----------+
| COUNT(*) |
|----------|
|        0 |
+----------+

-- Example 11319
USE DATABASE ht_sensors;
USE SCHEMA ht_schema;

CREATE OR REPLACE DATABASE restore_ht_sensors
  CLONE ht_sensors AT(TIMESTAMP => 'Mon, 25 Nov 2024 14:09:00'::TIMESTAMP_LTZ);

-- Example 11320
+---------------------------------------------------+
| status                                            |
|---------------------------------------------------|
| Database RESTORE_HT_SENSORS successfully created. |
+---------------------------------------------------+

-- Example 11321
USE DATABASE restore_ht_sensors;
USE SCHEMA ht_schema;
SELECT COUNT(*) FROM SENSOR_DATA_DEVICE2 WHERE motor_rpm>1504;

-- Example 11322
+----------+
| COUNT(*) |
|----------|
|     1855 |
+----------+

-- Example 11323
SELECT COUNT(*) FROM SENSOR_DATA_DEVICE2 AT(TIMESTAMP => 'Mon, 25 Nov 2024 14:09:00'::TIMESTAMP_LTZ) WHERE MOTOR_RPM>1504;

-- Example 11324
000707 (02000): Time travel data is not available for table SENSOR_DATA_DEVICE2. The requested time is either
beyond the allowed time travel period or before the object creation time.

-- Example 11325
SELECT c1, TO_CHAR(TO_BINARY(c1, 'hex'), 'base64') FROM hex_strings;

-- Example 11326
+----------------------+-----------------------------------------+
| C1                   | TO_CHAR(TO_BINARY(C1, 'HEX'), 'BASE64') |
|----------------------+-----------------------------------------|
| df32ede209ed5a4e3c25 | 3zLt4gntWk48JQ==                        |
| AB4F3C421B           | q088Qhs=                                |
| 9324df2ecc54         | kyTfLsxU                                |
+----------------------+-----------------------------------------+

-- Example 11327
SELECT c1, TO_CHAR(TO_BINARY(c1, 'base64'), 'hex') FROM base64_strings;

-- Example 11328
+------------------+-----------------------------------------+
| C1               | TO_CHAR(TO_BINARY(C1, 'BASE64'), 'HEX') |
|------------------+-----------------------------------------|
| 3zLt4gntWk48JQ== | DF32EDE209ED5A4E3C25                    |
| q088Qhs=         | AB4F3C421B                              |
| kyTfLsxU         | 9324DF2ECC54                            |
+------------------+-----------------------------------------+

-- Example 11329
SELECT c1, TO_BINARY(c1, 'utf-8') FROM characters;

-- Example 11330
+----+------------------------+
| C1 | TO_BINARY(C1, 'UTF-8') |
|----+------------------------|
| a  | 61                     |
| é  | C3A9                   |
| ❄  | E29D84                 |
| π  | CF80                   |
+----+------------------------+

-- Example 11331
SELECT TO_CHAR(X'41424320E29D84', 'utf-8');

-- Example 11332
+-------------------------------------+
| TO_CHAR(X'41424320E29D84', 'UTF-8') |
|-------------------------------------|
| ABC ❄                               |
+-------------------------------------+

-- Example 11333
SELECT TO_CHAR(MD5_BINARY(c1), 'base64') FROM variants;

-- Example 11334
+----------+-----------------------------------+
| C1       | TO_CHAR(MD5_BINARY(C1), 'BASE64') |
|----------+-----------------------------------|
| 3        | 7MvIfktc4v4oMI/Z8qe68w==          |
| 45       | bINJzHJgrmLjsTloMag5jw==          |
| "abcdef" | 6AtQFwmJUPxYqtg8jBSXjg==          |
| "côté"   | H6G3w1nEJsUY4Do1BFp2tw==          |
+----------+-----------------------------------+

-- Example 11335
SELECT c1,
       TRY_TO_BINARY(SPLIT_PART(c1, ':', 2), SPLIT_PART(c1, ':', 1)) AS binary_value
  FROM strings;

-- Example 11336
+-------------------------+----------------------+
| C1                      | BINARY_VALUE         |
|-------------------------+----------------------|
| hex:AB4F3C421B          | AB4F3C421B           |
| base64:c25vd2ZsYWtlCg== | 736E6F77666C616B650A |
| utf8:côté               | 63C3B474C3A9         |
| ???:abc                 | NULL                 |
+-------------------------+----------------------+

-- Example 11337
SELECT c1,
       COALESCE(
         x'00' || TRY_TO_BINARY(c1, 'hex'),
         x'01' || TRY_TO_BINARY(c1, 'base64'),
         x'02' || TRY_TO_BINARY(c1, 'utf-8')) AS binary_value
  FROM strings;

-- Example 11338
+------------------+------------------------+
| C1               | BINARY_VALUE           |
|------------------+------------------------|
| ab4f3c421b       | 00AB4F3C421B           |
| c25vd2ZsYWtlCg== | 01736E6F77666C616B650A |
| côté             | 0263C3B474C3A9         |
| 1100             | 001100                 |
+------------------+------------------------+

-- Example 11339
SELECT c1,
       TO_CHAR(
       SUBSTR(c1, 2),
       DECODE(SUBSTR(c1, 1, 1), x'00', 'hex', x'01', 'base64', x'02', 'utf-8')) AS string_value
  FROM bin;

-- Example 11340
+------------------------+------------------+
| C1                     | STRING_VALUE     |
|------------------------+------------------|
| 00AB4F3C421B           | AB4F3C421B       |
| 01736E6F77666C616B650A | c25vd2ZsYWtlCg== |
| 0263C3B474C3A9         | côté             |
| 001100                 | 1100             |
+------------------------+------------------+

-- Example 11341
CREATE OR REPLACE FUNCTION my_decoder (b BINARY)
  RETURNS VARIANT
  LANGUAGE JAVASCRIPT
AS '
  IF (B[0] == 0) {
      var number = 0;
      FOR (var i = 1; i < B.length; i++) {
          number = number * 256 + B[i];
      }
      RETURN number;
  }
  IF (B[0] == 1) {
      var str = "";
      FOR (var i = 1; i < B.length; i++) {
          str += String.fromCharCode(B[i]);
      }
      RETURN str;
  }
  RETURN NULL;';

-- Example 11342
SELECT c1, my_decoder(c1) FROM bin;

-- Example 11343
+----------------+----------------+
| C1             | MY_DECODER(C1) |
|----------------+----------------|
| 002A           | 42             |
| 0148656C6C6F21 | "Hello!"       |
| 00FFFF         | 65535          |
| 020B1701       | null           |
+----------------+----------------+

-- Example 11344
CREATE TABLE <table_name> ( <col_name> <col_type> COLLATE '<collation_specification>'
                            [ , <col_name> <col_type> COLLATE '<collation_specification>' ... ]
                            [ , ... ]
                          )

-- Example 11345
COLLATE( <expression> , '<collation_specification>' )

-- Example 11346
<expression> COLLATE '<collation_specification>'

-- Example 11347
SELECT * FROM t1 WHERE COLLATE(col1 , 'en-ci') = 'Tango';

-- Example 11348
SELECT * FROM t1 ORDER BY COLLATE(col1 , 'de');

-- Example 11349
CREATE TABLE t2 AS SELECT COLLATE(col1, 'fr') AS col1 FROM t1;

-- Example 11350
CREATE TABLE t2 AS SELECT col1 COLLATE 'fr' AS col1 FROM t1;

-- Example 11351
COLLATION( <expression> )

-- Example 11352
SELECT DISTINCT COLLATION(column1) FROM table1;

-- Example 11353
CREATE OR REPLACE TABLE test_table (col1 VARCHAR, col2 VARCHAR);
INSERT INTO test_table VALUES ('ı', 'i');

-- Example 11354
SELECT col1 = col2,
       COLLATE(col1, 'lower') = COLLATE(col2, 'lower'),
       COLLATE(col1, 'upper') = COLLATE(col2, 'upper')
  FROM test_table;

-- Example 11355
+-------------+-------------------------------------------------+-------------------------------------------------+
| COL1 = COL2 | COLLATE(COL1, 'LOWER') = COLLATE(COL2, 'LOWER') | COLLATE(COL1, 'UPPER') = COLLATE(COL2, 'UPPER') |
|-------------+-------------------------------------------------+-------------------------------------------------|
| False       | False                                           | True                                            |
+-------------+-------------------------------------------------+-------------------------------------------------+

-- Example 11356
SELECT 'abc' COLLATE 'bin' = 'abc' COLLATE 'utf8';

-- Example 11357
CREATE OR REPLACE TABLE demo (
    no_explicit_collation VARCHAR,
    en_ci VARCHAR COLLATE 'en-ci',
    en VARCHAR COLLATE 'en',
    utf_8 VARCHAR collate 'utf8');
INSERT INTO demo (no_explicit_collation) VALUES
    ('-'),
    ('+');
UPDATE demo SET
    en_ci = no_explicit_collation,
    en = no_explicit_collation,
    utf_8 = no_explicit_collation;

-- Example 11358
SELECT MAX(no_explicit_collation), MAX(en_ci), MAX(en), MAX(utf_8)
  FROM demo;

-- Example 11359
+----------------------------+------------+---------+------------+
| MAX(NO_EXPLICIT_COLLATION) | MAX(EN_CI) | MAX(EN) | MAX(UTF_8) |
|----------------------------+------------+---------+------------|
| -                          | +          | +       | -          |
+----------------------------+------------+---------+------------+

-- Example 11360
CREATE OR REPLACE TABLE collation_precedence_example(
  col1    VARCHAR,               -- equivalent to COLLATE ''
  col2_fr VARCHAR COLLATE 'fr',  -- French locale
  col3_de VARCHAR COLLATE 'de'   -- German locale
);

-- Example 11361
... WHERE col1 = col2_fr ...

-- Example 11362
... WHERE col1 COLLATE 'en' = col2_fr ...

-- Example 11363
... WHERE col2_fr = col3_de ...

-- Example 11364
... WHERE col2_fr COLLATE '' = col3_de ...

-- Example 11365
... WHERE col2_fr COLLATE 'en' = col3_de COLLATE 'de' ...

-- Example 11366
CREATE OR REPLACE TABLE collation_precedence_example2(
  s1 STRING COLLATE '',
  s2 STRING COLLATE 'utf8',
  s3 STRING COLLATE 'fr'
);

-- Example 11367
... WHERE s1 = 'a' ...

-- Example 11368
... WHERE s1 = s2 ...

-- Example 11369
... WHERE s1 = s3 ...

