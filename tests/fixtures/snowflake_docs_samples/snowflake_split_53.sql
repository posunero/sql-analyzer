-- Example 3534
+---+------------+------------+
| N | AS_REAL(V) | TYPEOF(V)  |
|---+------------+------------|
| 1 |       NULL | NULL_VALUE |
| 2 |       NULL | NULL       |
| 3 |       NULL | BOOLEAN    |
| 4 |     -17    | INTEGER    |
| 5 |     123.12 | DECIMAL    |
| 6 |     191.2  | DOUBLE     |
| 7 |       NULL | VARCHAR    |
| 8 |       NULL | ARRAY      |
| 9 |       NULL | OBJECT     |
+---+------------+------------+

-- Example 3535
SELECT AVG(AS_REAL(v)) FROM vartab;

-- Example 3536
+-----------------+
| AVG(AS_REAL(V)) |
|-----------------|
|    99.106666667 |
+-----------------+

-- Example 3537
AS_ARRAY( <variant_expr> )

-- Example 3538
CREATE OR REPLACE TABLE as_array_example (
  array1 VARIANT,
  array2 VARIANT);

INSERT INTO as_array_example (array1, array2)
  SELECT
    TO_VARIANT(TO_ARRAY('Example')),
    TO_VARIANT(ARRAY_CONSTRUCT('Array-like', 'example'));

-- Example 3539
SELECT AS_ARRAY(array1) AS array1,
       AS_ARRAY(array2) AS array2
  FROM as_array_example;

-- Example 3540
+-------------+-----------------+
| ARRAY1      | ARRAY2          |
|-------------+-----------------|
| [           | [               |
|   "Example" |   "Array-like", |
| ]           |   "example"     |
|             | ]               |
+-------------+-----------------+

-- Example 3541
AS_BINARY( <variant_expr> )

-- Example 3542
CREATE OR REPLACE TABLE as_binary_example (binary1 VARIANT);

INSERT INTO as_binary_example (binary1)
  SELECT TO_VARIANT(TO_BINARY('F0A5'));

-- Example 3543
SELECT AS_BINARY(binary1) AS binary_value
  FROM as_binary_example;

-- Example 3544
+--------------+
| BINARY_VALUE |
|--------------|
| F0A5         |
+--------------+

-- Example 3545
CREATE TABLE t1 (v VARCHAR(16777216));

-- Example 3546
CREATE OR REPLACE TABLE test_text(
  vd VARCHAR,
  v50 VARCHAR(50),
  cd CHAR,
  c10 CHAR(10),
  sd STRING,
  s20 STRING(20),
  td TEXT,
  t30 TEXT(30));

DESC TABLE test_text;

-- Example 3547
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| VD   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| V50  | VARCHAR(50)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| CD   | VARCHAR(1)        | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| C10  | VARCHAR(10)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| SD   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| S20  | VARCHAR(20)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| TD   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| T30  | VARCHAR(30)       | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3548
CREATE OR REPLACE TABLE test_binary(
  bd BINARY,
  b100 BINARY(100),
  vbd VARBINARY);

DESC TABLE test_binary;

-- Example 3549
+------+-----------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type            | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+-----------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| BD   | BINARY(8388608) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| B100 | BINARY(100)     | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| VBD  | BINARY(8388608) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+-----------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3550
SELECT 'Today''s sales projections', '-''''-';

-- Example 3551
+------------------------------+----------+
| 'TODAY''S SALES PROJECTIONS' | '-''''-' |
|------------------------------+----------|
| Today's sales projections    | -''-     |
+------------------------------+----------+

-- Example 3552
SELECT $1, $2 FROM
  VALUES
    ('Tab','Hello\tWorld'),
    ('Newline','Hello\nWorld'),
    ('Backslash','C:\\user'),
    ('Octal','-\041-'),
    ('Hexadecimal','-\x21-'),
    ('Unicode','-\u26c4-'),
    ('Not an escape sequence', '\z');

-- Example 3553
+------------------------+---------------+
| $1                     | $2            |
|------------------------+---------------|
| Tab                    | Hello   World |
| Newline                | Hello         |
|                        | World         |
| Backslash              | C:\user       |
| Octal                  | -!-           |
| Hexadecimal            | -!-           |
| Unicode                | -⛄-          |
| Not an escape sequence | z             |
+------------------------+---------------+

-- Example 3554
'string with a \' character'

-- Example 3555
$$string with a ' character$$

-- Example 3556
'regular expression with \\ characters: \\d{2}-\\d{3}-\\d{4}'

-- Example 3557
$$regular expression with \ characters: \d{2}-\d{3}-\d{4}$$

-- Example 3558
'string with a newline\ncharacter'

-- Example 3559
$$string with a newline
character$$

-- Example 3560
SELECT $1, $2 FROM VALUES (
  'row1',
  $$a
                                  ' \ \t
                                  \x21 z $ $$);

-- Example 3561
+------+---------------------------------------------+
| $1   | $2                                          |
|------+---------------------------------------------|
| row1 | a                                           |
|      |                                   ' \ \t    |
|      |                                   \x21 z $  |
+------+---------------------------------------------+

-- Example 3562
AS_BOOLEAN( <variant_expr> )

-- Example 3563
CREATE OR REPLACE TABLE as_boolean_example (
  boolean1 VARIANT,
  boolean2 VARIANT);

INSERT INTO as_boolean_example (boolean1, boolean2)
  SELECT
    TO_VARIANT(TO_BOOLEAN(TRUE)),
    TO_VARIANT(TO_BOOLEAN(FALSE));

-- Example 3564
SELECT AS_BOOLEAN(boolean1) boolean_true,
       AS_BOOLEAN(boolean2) boolean_false
  FROM as_boolean_example;

-- Example 3565
+--------------+---------------+
| BOOLEAN_TRUE | BOOLEAN_FALSE |
|--------------+---------------|
| True         | False         |
+--------------+---------------+

-- Example 3566
CREATE OR REPLACE TABLE test_boolean(
  b BOOLEAN,
  n NUMBER,
  s STRING);

INSERT INTO test_boolean VALUES
  (true, 1, 'yes'),
  (false, 0, 'no'),
  (NULL, NULL, NULL);

SELECT * FROM test_boolean;

-- Example 3567
+-------+------+------+
| B     |    N | S    |
|-------+------+------|
| True  |    1 | yes  |
| False |    0 | no   |
| NULL  | NULL | NULL |
+-------+------+------+

-- Example 3568
SELECT b, n, NOT b AND (n < 1) FROM test_boolean;

-- Example 3569
+-------+------+-------------------+
| B     |    N | NOT B AND (N < 1) |
|-------+------+-------------------|
| True  |    1 | False             |
| False |    0 | True              |
| NULL  | NULL | NULL              |
+-------+------+-------------------+

-- Example 3570
SELECT * FROM test_boolean WHERE NOT b AND (n < 1);

-- Example 3571
+-------+---+----+
| B     | N | S  |
|-------+---+----|
| False | 0 | no |
+-------+---+----+

-- Example 3572
SELECT s,
       TO_BOOLEAN(s),
       SYSTEM$TYPEOF(TO_BOOLEAN(s))
  FROM test_boolean;

-- Example 3573
+------+---------------+------------------------------+
| S    | TO_BOOLEAN(S) | SYSTEM$TYPEOF(TO_BOOLEAN(S)) |
|------+---------------+------------------------------|
| yes  | True          | BOOLEAN[SB1]                 |
| no   | False         | BOOLEAN[SB1]                 |
| NULL | NULL          | BOOLEAN[SB1]                 |
+------+---------------+------------------------------+

-- Example 3574
SELECT n,
       TO_BOOLEAN(n),
       SYSTEM$TYPEOF(TO_BOOLEAN(n))
  FROM test_boolean;

-- Example 3575
+------+---------------+------------------------------+
| N    | TO_BOOLEAN(N) | SYSTEM$TYPEOF(TO_BOOLEAN(N)) |
|------+---------------+------------------------------|
| 1    | True          | BOOLEAN[SB1]                 |
| 0    | False         | BOOLEAN[SB1]                 |
| NULL | NULL          | BOOLEAN[SB1]                 |
+------+---------------+------------------------------+

-- Example 3576
SELECT 'Text for ' || s || ' is ' || b AS result,
       SYSTEM$TYPEOF('Text for ' || s || ' is ' || b) AS type_of_result
  FROM test_boolean;

-- Example 3577
+----------------------+------------------------+
| RESULT               | TYPE_OF_RESULT         |
|----------------------+------------------------|
| Text for yes is true | VARCHAR(16777216)[LOB] |
| Text for no is false | VARCHAR(16777216)[LOB] |
| NULL                 | VARCHAR(16777216)[LOB] |
+----------------------+------------------------+

-- Example 3578
AS_CHAR( <variant_expr> )

AS_VARCHAR( <variant_expr> )

-- Example 3579
CREATE OR REPLACE TABLE as_varchar_example (varchar1 VARIANT);

INSERT INTO as_varchar_example (varchar1)
  SELECT TO_VARIANT('My VARCHAR value');

-- Example 3580
SELECT AS_VARCHAR(varchar1) varchar_value
  FROM as_varchar_example;

-- Example 3581
+------------------+
| VARCHAR_VALUE    |
|------------------|
| My VARCHAR value |
+------------------+

-- Example 3582
AS_DATE( <variant_expr> )

-- Example 3583
CREATE OR REPLACE TABLE as_date_example (date1 VARIANT);

INSERT INTO as_date_example (date1)
 SELECT TO_VARIANT(TO_DATE('2024-10-10'));

-- Example 3584
SELECT AS_DATE(date1) date_value
  FROM as_date_example;

-- Example 3585
+------------+
| DATE_VALUE |
|------------|
| 2024-10-10 |
+------------+

-- Example 3586
SELECT '2024-01-01 00:00:00 +0000'::TIMESTAMP_TZ = '2024-01-01 01:00:00 +0100'::TIMESTAMP_TZ;

-- Example 3587
SELECT '2024-01-01 12:00:00'::TIMESTAMP_TZ;

-- Example 3588
+-------------------------------------+
| '2024-01-01 12:00:00'::TIMESTAMP_TZ |
|-------------------------------------|
| 2024-01-01 12:00:00.000 -0800       |
+-------------------------------------+

-- Example 3589
SELECT DATEADD(MONTH, 6, '2024-01-01 12:00:00'::TIMESTAMP_TZ);

-- Example 3590
+--------------------------------------------------------+
| DATEADD(MONTH, 6, '2024-01-01 12:00:00'::TIMESTAMP_TZ) |
|--------------------------------------------------------|
| 2024-07-01 12:00:00.000 -0800                          |
+--------------------------------------------------------+

-- Example 3591
ALTER SESSION SET TIMESTAMP_TYPE_MAPPING = TIMESTAMP_NTZ;

CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP);

DESC TABLE ts_test;

-- Example 3592
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type             | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| TS   | TIMESTAMP_NTZ(9) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3593
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_LTZ);

DESC TABLE ts_test;

-- Example 3594
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type             | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| TS   | TIMESTAMP_LTZ(9) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 3595
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_LTZ);

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2024-01-01 16:00:00');
INSERT INTO ts_test VALUES('2024-01-02 16:00:00 +00:00');

-- Example 3596
SELECT ts, HOUR(ts) FROM ts_test;

-- Example 3597
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 16:00:00.000 -0800 |       16 |
| 2024-01-02 08:00:00.000 -0800 |        8 |
+-------------------------------+----------+

-- Example 3598
ALTER SESSION SET TIMEZONE = 'America/New_York';

SELECT ts, HOUR(ts) FROM ts_test;

-- Example 3599
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 19:00:00.000 -0500 |       19 |
| 2024-01-02 11:00:00.000 -0500 |       11 |
+-------------------------------+----------+

-- Example 3600
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_NTZ);

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2024-01-01 16:00:00');
INSERT INTO ts_test VALUES('2024-01-02 16:00:00 +00:00');

