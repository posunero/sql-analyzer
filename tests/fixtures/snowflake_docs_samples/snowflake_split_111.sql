-- Example 7418
select TO_GEOGRAPHY('POINT(-122.35 37.55)');

-- Example 7419
+--------------------------------------+
| TO_GEOGRAPHY('POINT(-122.35 37.55)') |
|--------------------------------------|
| POINT(-122.35 37.55)                 |
+--------------------------------------+

-- Example 7420
select TO_GEOGRAPHY('POINTZ(-122.35 37.55 30)');

-- Example 7421
+------------------------------------------+
| TO_GEOGRAPHY('POINTZ(-122.35 37.55 30)') |
|------------------------------------------|
| POINTZ(-122.35 37.55 30)                 |
+------------------------------------------+

-- Example 7422
TO_GEOMETRY( <varchar_expression> [ , <srid> ] [ , <allow_invalid> ] )

TO_GEOMETRY( <binary_expression> [ , <srid> ] [ , <allow_invalid> ] )

TO_GEOMETRY( <variant_expression> [ , <srid> ] [ , <allow_invalid> ] )

TO_GEOMETRY( <geography_expression> [ , <srid> ] [ , <allow_invalid> ] )

-- Example 7423
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT TO_GEOMETRY('POINT(1820.12 890.56)');

-- Example 7424
+--------------------------------------+
| TO_GEOMETRY('POINT(1820.12 890.56)') |
|--------------------------------------|
| SRID=0;POINT(1820.12 890.56)         |
+--------------------------------------+

-- Example 7425
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT TO_GEOMETRY('SRID=4326;POINT(1820.12 890.56)');

-- Example 7426
+------------------------------------------------+
| TO_GEOMETRY('SRID=4326;POINT(1820.12 890.56)') |
|------------------------------------------------|
| SRID=4326;POINT(1820.12 890.56)                |
+------------------------------------------------+

-- Example 7427
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT TO_GEOMETRY('POINT(1820.12 890.56)', 4326);

-- Example 7428
+--------------------------------------------+
| TO_GEOMETRY('POINT(1820.12 890.56)', 4326) |
|--------------------------------------------|
| SRID=4326;POINT(1820.12 890.56)            |
+--------------------------------------------+

-- Example 7429
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT TO_GEOMETRY('SRID=32633;POINTZ(389866.35 5819003.03 30)');

-- Example 7430
+-----------------------------------------------------------+
| TO_GEOMETRY('SRID=32633;POINTZ(389866.35 5819003.03 30)') |
|-----------------------------------------------------------|
| SRID=32633;POINTZ(389866.35 5819003.03 30)                |
+-----------------------------------------------------------+

-- Example 7431
TO_JSON( <expr> )

-- Example 7432
CREATE OR REPLACE TABLE jdemo1 (v VARIANT);
INSERT INTO jdemo1 SELECT PARSE_JSON('{"food":"bard"}');

-- Example 7433
SELECT v, v:food, TO_JSON(v) FROM jdemo1;

-- Example 7434
+------------------+--------+-----------------+
| V                | V:FOOD | TO_JSON(V)      |
|------------------+--------+-----------------|
| {                | "bard" | {"food":"bard"} |
|   "food": "bard" |        |                 |
| }                |        |                 |
+------------------+--------+-----------------+

-- Example 7435
SELECT TO_JSON(NULL), TO_JSON('null'::VARIANT),
       PARSE_JSON(NULL), PARSE_JSON('null');

-- Example 7436
+---------------+--------------------------+------------------+--------------------+
| TO_JSON(NULL) | TO_JSON('NULL'::VARIANT) | PARSE_JSON(NULL) | PARSE_JSON('NULL') |
|---------------+--------------------------+------------------+--------------------|
| NULL          | "null"                   | NULL             | null               |
+---------------+--------------------------+------------------+--------------------+

-- Example 7437
CREATE OR REPLACE TABLE jdemo2 (
  varchar1 VARCHAR, 
  variant1 VARIANT);

INSERT INTO jdemo2 (varchar1) VALUES ('{"PI":3.14}');

UPDATE jdemo2 SET variant1 = PARSE_JSON(varchar1);

-- Example 7438
SELECT varchar1, 
       PARSE_JSON(varchar1), 
       variant1, 
       TO_JSON(variant1),
       PARSE_JSON(varchar1) = variant1, 
       TO_JSON(variant1) = varchar1
  FROM jdemo2;

-- Example 7439
+-------------+----------------------+--------------+-------------------+---------------------------------+------------------------------+
| VARCHAR1    | PARSE_JSON(VARCHAR1) | VARIANT1     | TO_JSON(VARIANT1) | PARSE_JSON(VARCHAR1) = VARIANT1 | TO_JSON(VARIANT1) = VARCHAR1 |
|-------------+----------------------+--------------+-------------------+---------------------------------+------------------------------|
| {"PI":3.14} | {                    | {            | {"PI":3.14}       | True                            | True                         |
|             |   "PI": 3.14         |   "PI": 3.14 |                   |                                 |                              |
|             | }                    | }            |                   |                                 |                              |
+-------------+----------------------+--------------+-------------------+---------------------------------+------------------------------+

-- Example 7440
SELECT TO_JSON(PARSE_JSON('{"b":1,"a":2}')),
       TO_JSON(PARSE_JSON('{"b":1,"a":2}')) = '{"b":1,"a":2}',
       TO_JSON(PARSE_JSON('{"b":1,"a":2}')) = '{"a":2,"b":1}';

-- Example 7441
+--------------------------------------+--------------------------------------------------------+--------------------------------------------------------+
| TO_JSON(PARSE_JSON('{"B":1,"A":2}')) | TO_JSON(PARSE_JSON('{"B":1,"A":2}')) = '{"B":1,"A":2}' | TO_JSON(PARSE_JSON('{"B":1,"A":2}')) = '{"A":2,"B":1}' |
|--------------------------------------+--------------------------------------------------------+--------------------------------------------------------|
| {"a":2,"b":1}                        | False                                                  | True                                                   |
+--------------------------------------+--------------------------------------------------------+--------------------------------------------------------+

-- Example 7442
TO_OBJECT( <expr> )

-- Example 7443
CREATE TABLE t1 (vo VARIANT);
INSERT INTO t1 (vo) 
    SELECT PARSE_JSON('{"a":1}');

-- Example 7444
SELECT TO_OBJECT(vo) from t1;
+---------------+
| TO_OBJECT(VO) |
|---------------|
| {             |
|   "a": 1      |
| }             |
+---------------+

-- Example 7445
TO_QUERY( SQL => '<string>' [ , <arg> => '<value>' [, <arg> => '<value>' ...] ] )

-- Example 7446
CREATE OR REPLACE TABLE to_query_example (
  deptno NUMBER(2),
  dname  VARCHAR(14),
  loc    VARCHAR(13))
AS SELECT
  column1,
  column2,
  column3
FROM
  VALUES
    (10, 'ACCOUNTING', 'NEW YORK'),
    (20, 'RESEARCH',   'DALLAS'  ),
    (30, 'SALES',      'CHICAGO' ),
    (40, 'OPERATIONS', 'BOSTON'  );

-- Example 7447
SET table_name = 'to_query_example';

-- Example 7448
SELECT * FROM TABLE(TO_QUERY('SELECT * FROM IDENTIFIER($table_name)'));

-- Example 7449
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
|--------+------------+----------|
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |
+--------+------------+----------+

-- Example 7450
SELECT deptno FROM TABLE(TO_QUERY('SELECT * FROM IDENTIFIER($table_name)'));

-- Example 7451
+--------+
| DEPTNO |
|--------|
|     10 |
|     20 |
|     30 |
|     40 |
+--------+

-- Example 7452
SELECT * FROM TABLE(
  TO_QUERY(
    'SELECT * FROM IDENTIFIER($table_name)
    WHERE deptno = TO_NUMBER(:dno)', dno => '10'
    )
  );

-- Example 7453
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
|--------+------------+----------|
|     10 | ACCOUNTING | NEW YORK |
+--------+------------+----------+

-- Example 7454
SET dept = '10';

SELECT * FROM TABLE(
  TO_QUERY(
    'SELECT * FROM IDENTIFIER($table_name)
    WHERE deptno = TO_NUMBER(:dno)', dno => $dept
    )
  );

-- Example 7455
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
|--------+------------+----------|
|     10 | ACCOUNTING | NEW YORK |
+--------+------------+----------+

-- Example 7456
SELECT * FROM TABLE(
  TO_QUERY(
    'SELECT * FROM IDENTIFIER($table_name)
    WHERE deptno = TO_NUMBER(:dno) OR dname = :dnm',
    dno => '10', dnm => 'SALES'
    )
  );

-- Example 7457
+--------+------------+----------+
| DEPTNO | DNAME      | LOC      |
|--------+------------+----------|
|     10 | ACCOUNTING | NEW YORK |
|     30 | SALES      | CHICAGO  |
+--------+------------+----------+

-- Example 7458
CREATE OR REPLACE PROCEDURE get_num_results_tq(query VARCHAR)
RETURNS TABLE ()
LANGUAGE SQL
AS
DECLARE
  res RESULTSET DEFAULT (SELECT COUNT(*) FROM TABLE(TO_QUERY(:query)));
BEGIN
  RETURN TABLE(res);
END;

-- Example 7459
CREATE OR REPLACE PROCEDURE get_num_results_tq(query VARCHAR)
RETURNS TABLE ()
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT COUNT(*) FROM TABLE(TO_QUERY(:query)));
BEGIN
  RETURN TABLE(res);
END;
$$
;

-- Example 7460
CALL get_num_results_tq('SELECT * FROM to_query_example');

-- Example 7461
+----------+
| COUNT(*) |
|----------|
|        4 |
+----------+

-- Example 7462
CALL get_num_results_tq('SELECT * FROM to_query_example WHERE deptno = 20');

-- Example 7463
+----------+
| COUNT(*) |
|----------|
|        1 |
+----------+

-- Example 7464
CREATE OR REPLACE PROCEDURE get_results_tqbnd(dno VARCHAR)
RETURNS TABLE ()
LANGUAGE SQL
AS
DECLARE
  res RESULTSET DEFAULT (SELECT * FROM TABLE(
    TO_QUERY(
      'SELECT * FROM to_query_example
      WHERE deptno = TO_NUMBER(:dnoval)', dnoval => :dno
    )
  ));
BEGIN
  RETURN TABLE(res);
END;

-- Example 7465
CREATE OR REPLACE PROCEDURE get_results_tqbnd(dno VARCHAR)
RETURNS TABLE ()
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT * FROM TABLE(
    TO_QUERY(
      'SELECT * FROM to_query_example
      WHERE deptno = TO_NUMBER(:dnoval)', dnoval => :dno
    )
  ));
BEGIN
  RETURN TABLE(res);
END;
$$
;

-- Example 7466
CALL get_results_tqbnd('40');

-- Example 7467
+--------+------------+--------+
| DEPTNO | DNAME      | LOC    |
|--------+------------+--------|
|     40 | OPERATIONS | BOSTON |
+--------+------------+--------+

-- Example 7468
SET dept = '20';

CALL get_results_tqbnd($dept);

-- Example 7469
+--------+----------+--------+
| DEPTNO | DNAME    | LOC    |
|--------+----------+--------|
|     20 | RESEARCH | DALLAS |
+--------+----------+--------+

-- Example 7470
TO_TIME( <string_expr> [, <format> ] )
TO_TIME( <timestamp_expr> )
TO_TIME( '<integer>' )
TO_TIME( <variant_expr> )

TIME( <string_expr> )
TIME( <timestamp_expr> )
TIME( '<integer>' )
TIME( <variant_expr> )

-- Example 7471
SELECT TO_TIME('13:30:00'), TIME('13:30:00');

-- Example 7472
+---------------------+------------------+
| TO_TIME('13:30:00') | TIME('13:30:00') |
|---------------------+------------------|
| 13:30:00            | 13:30:00         |
+---------------------+------------------+

-- Example 7473
SELECT TO_TIME('13:30:00.000'), TIME('13:30:00.000');

-- Example 7474
+-------------------------+----------------------+
| TO_TIME('13:30:00.000') | TIME('13:30:00.000') |
|-------------------------+----------------------|
| 13:30:00                | 13:30:00             |
+-------------------------+----------------------+

-- Example 7475
SELECT TO_TIME('11.15.00', 'HH24.MI.SS');

-- Example 7476
+-----------------------------------+
| TO_TIME('11.15.00', 'HH24.MI.SS') |
|-----------------------------------|
| 11:15:00                          |
+-----------------------------------+

-- Example 7477
CREATE OR REPLACE TABLE demo1_time (
  description VARCHAR,
  value VARCHAR -- string rather than bigint
);

INSERT INTO demo1_time (description, value) VALUES
  ('Seconds',      '31536001'),
  ('Milliseconds', '31536002400'),
  ('Microseconds', '31536003600000'),
  ('Nanoseconds',  '31536004900000000');

-- Example 7478
SELECT description,
       value,
       TO_TIMESTAMP(value),
       TO_TIME(value)
  FROM demo1_time
  ORDER BY value;

-- Example 7479
+--------------+-------------------+-------------------------+----------------+
| DESCRIPTION  | VALUE             | TO_TIMESTAMP(VALUE)     | TO_TIME(VALUE) |
|--------------+-------------------+-------------------------+----------------|
| Seconds      | 31536001          | 1971-01-01 00:00:01.000 | 00:00:01       |
| Milliseconds | 31536002400       | 1971-01-01 00:00:02.400 | 00:00:02       |
| Microseconds | 31536003600000    | 1971-01-01 00:00:03.600 | 00:00:03       |
| Nanoseconds  | 31536004900000000 | 1971-01-01 00:00:04.900 | 00:00:04       |
+--------------+-------------------+-------------------------+----------------+

-- Example 7480
timestampFunction ( <numeric_expr> [ , <scale> ] )

timestampFunction ( <date_expr> )

timestampFunction ( <timestamp_expr> )

timestampFunction ( <string_expr> [ , <format> ] )

timestampFunction ( '<integer>' )

timestampFunction ( <variant_expr> )

-- Example 7481
timestampFunction ::=
    TO_TIMESTAMP | TO_TIMESTAMP_LTZ | TO_TIMESTAMP_NTZ | TO_TIMESTAMP_TZ

-- Example 7482
SELECT TO_TIMESTAMP(31000000);
SELECT TO_TIMESTAMP(PARSE_JSON(31000000));
SELECT PARSE_JSON(31000000)::TIMESTAMP_NTZ;

-- Example 7483
SELECT TO_TIMESTAMP(31000000);
SELECT TO_TIMESTAMP(PARSE_JSON(31000000)::INT);
SELECT PARSE_JSON(31000000)::INT::TIMESTAMP_NTZ;

-- Example 7484
ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

