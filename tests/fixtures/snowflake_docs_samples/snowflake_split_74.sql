-- Example 4941
SELECT INSERT('abc', 1, 2, NULL) as STR;
+------+
| STR  |
|------|
| NULL |
+------+

-- Example 4942
SNOWFLAKE.NOTIFICATION.INTEGRATION( '<integration_name>' )

-- Example 4943
'{"my_queue_int":{}}'

-- Example 4944
INVOKER_ROLE()

-- Example 4945
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN INVOKER_ROLE() IN ('ANALYST') THEN val
  ELSE NULL
END;

-- Example 4946
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN INVOKER_ROLE() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 4947
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN INVOKER_ROLE() IN ('ANALYST') THEN val
  ELSE SHA2(val)
END;

-- Example 4948
INVOKER_SHARE()

-- Example 4949
create or replace masking policy mask_share
as (val string) returns string ->
case
  when invoker_share() in ('SHARE1') then mask1_function(val)
  when invoker_share() in ('SHARE2') then mask2_function(val)
  else '***MASKED***'
end;

-- Example 4950
<expr1> IS [ NOT ] DISTINCT FROM <expr2>

-- Example 4951
CREATE OR REPLACE TABLE x (i number);
INSERT INTO x values
    (1), 
    (2), 
    (null);

-- Example 4952
SELECT x1.i x1_i, x2.i x2_i 
    FROM x x1, x x2
    ORDER BY x1.i, x2.i;
+------+------+
| X1_I | X2_I |
|------+------|
|    1 |    1 |
|    1 |    2 |
|    1 | NULL |
|    2 |    1 |
|    2 |    2 |
|    2 | NULL |
| NULL |    1 |
| NULL |    2 |
| NULL | NULL |
+------+------+

-- Example 4953
SELECT x1.i x1_i, x2.i x2_i 
    FROM x x1, x x2 
    WHERE x1.i=x2.i;
+------+------+
| X1_I | X2_I |
|------+------|
|    1 |    1 |
|    2 |    2 |
+------+------+

-- Example 4954
SELECT x1.i x1_i, x2.i x2_i 
    FROM x x1, x x2 
    WHERE x1.i IS NOT DISTINCT FROM x2.i
    ORDER BY x1.i;
+------+------+
| X1_I | X2_I |
|------+------|
|    1 |    1 |
|    2 |    2 |
| NULL | NULL |
+------+------+

-- Example 4955
SELECT x1.i x1_i, 
       x2.i x2_i,
       x1.i=x2.i, 
       iff(x1.i=x2.i, 'Selected', 'Not') "SELECT IF X1.I=X2.I",
       x1.i<>x2.i, 
       iff(not(x1.i=x2.i), 'Selected', 'Not') "SELECT IF X1.I<>X2.I"
    FROM x x1, x x2;
+------+------+-----------+---------------------+------------+----------------------+
| X1_I | X2_I | X1.I=X2.I | SELECT IF X1.I=X2.I | X1.I<>X2.I | SELECT IF X1.I<>X2.I |
|------+------+-----------+---------------------+------------+----------------------|
|    1 |    1 | True      | Selected            | False      | Not                  |
|    1 |    2 | False     | Not                 | True       | Selected             |
|    1 | NULL | NULL      | Not                 | NULL       | Not                  |
|    2 |    1 | False     | Not                 | True       | Selected             |
|    2 |    2 | True      | Selected            | False      | Not                  |
|    2 | NULL | NULL      | Not                 | NULL       | Not                  |
| NULL |    1 | NULL      | Not                 | NULL       | Not                  |
| NULL |    2 | NULL      | Not                 | NULL       | Not                  |
| NULL | NULL | NULL      | Not                 | NULL       | Not                  |
+------+------+-----------+---------------------+------------+----------------------+

-- Example 4956
SELECT x1.i x1_i, x2.i x2_i,
               x1.i IS NOT DISTINCT FROM x2.i, iff(x1.i IS NOT DISTINCT FROM x2.i, 'Selected', 'Not') "SELECT IF X1.I IS NOT DISTINCT FROM X2.I",
               x1.i IS DISTINCT FROM x2.i, iff(x1.i IS DISTINCT FROM x2.i, 'Selected', 'Not') "SELECT IF X1.I IS DISTINCT FROM X2.I"
        FROM x x1, x x2
        ORDER BY x1.i, x2.i;
+------+------+--------------------------------+------------------------------------------+----------------------------+--------------------------------------+
| X1_I | X2_I | X1.I IS NOT DISTINCT FROM X2.I | SELECT IF X1.I IS NOT DISTINCT FROM X2.I | X1.I IS DISTINCT FROM X2.I | SELECT IF X1.I IS DISTINCT FROM X2.I |
|------+------+--------------------------------+------------------------------------------+----------------------------+--------------------------------------|
|    1 |    1 | True                           | Selected                                 | False                      | Not                                  |
|    1 |    2 | False                          | Not                                      | True                       | Selected                             |
|    1 | NULL | False                          | Not                                      | True                       | Selected                             |
|    2 |    1 | False                          | Not                                      | True                       | Selected                             |
|    2 |    2 | True                           | Selected                                 | False                      | Not                                  |
|    2 | NULL | False                          | Not                                      | True                       | Selected                             |
| NULL |    1 | False                          | Not                                      | True                       | Selected                             |
| NULL |    2 | False                          | Not                                      | True                       | Selected                             |
| NULL | NULL | True                           | Selected                                 | False                      | Not                                  |
+------+------+--------------------------------+------------------------------------------+----------------------------+--------------------------------------+

-- Example 4957
<expr> IS [ NOT ] NULL

-- Example 4958
CREATE OR REPLACE TABLE test_is_not_null (id NUMBER, col1 NUMBER, col2 NUMBER);
INSERT INTO test_is_not_null (id, col1, col2) VALUES 
  (1, 0, 5), 
  (2, 0, NULL), 
  (3, NULL, 5), 
  (4, NULL, NULL);

-- Example 4959
SELECT * 
  FROM test_is_not_null
  ORDER BY id;

-- Example 4960
+----+------+------+
| ID | COL1 | COL2 |
|----+------+------|
|  1 |    0 |    5 |
|  2 |    0 | NULL |
|  3 | NULL |    5 |
|  4 | NULL | NULL |
+----+------+------+

-- Example 4961
SELECT * 
  FROM test_is_not_null 
  WHERE col1 IS NOT NULL
  ORDER BY id;

-- Example 4962
+----+------+------+
| ID | COL1 | COL2 |
|----+------+------|
|  1 |    0 |    5 |
|  2 |    0 | NULL |
+----+------+------+

-- Example 4963
SELECT * 
  FROM test_is_not_null 
  WHERE col2 IS NULL
  ORDER BY id;

-- Example 4964
+----+------+------+
| ID | COL1 | COL2 |
|----+------+------|
|  2 |    0 | NULL |
|  4 | NULL | NULL |
+----+------+------+

-- Example 4965
SELECT * 
  FROM test_is_not_null 
  WHERE col1 IS NOT NULL OR col2 IS NULL
  ORDER BY id;

-- Example 4966
+----+------+------+
| ID | COL1 | COL2 |
|----+------+------|
|  1 |    0 |    5 |
|  2 |    0 | NULL |
|  4 | NULL | NULL |
+----+------+------+

-- Example 4967
SELECT *
  FROM test_is_not_null
  WHERE col1 IS NOT NULL AND col2 IS NULL
  ORDER BY id;

-- Example 4968
+----+------+------+
| ID | COL1 | COL2 |
|----+------+------|
|  2 |    0 | NULL |
+----+------+------+

-- Example 4969
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

-- Example 4970
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 4971
+---+------------------------+------------+
| N | V                      | TYPEOF(V)  |
|---+------------------------+------------|
| 1 | null                   | NULL_VALUE |
| 2 | NULL                   | NULL       |
| 3 | true                   | BOOLEAN    |
| 4 | -17                    | INTEGER    |
| 5 | 123.12                 | DECIMAL    |
| 6 | 1.912000000000000e+02  | DOUBLE     |
| 7 | "Om ara pa ca na dhih" | VARCHAR    |
| 8 | [                      | ARRAY      |
|   |   -1,                  |            |
|   |   12,                  |            |
|   |   289,                 |            |
|   |   2188,                |            |
|   |   false,               |            |
|   |   undefined            |            |
|   | ]                      |            |
| 9 | {                      | OBJECT     |
|   |   "x": "abc",          |            |
|   |   "y": false,          |            |
|   |   "z": 10              |            |
|   | }                      |            |
+---+------------------------+------------+

-- Example 4972
SELECT COUNT(*) FROM vartab WHERE IS_VARCHAR(v);

-- Example 4973
+----------+
| COUNT(*) |
|----------|
|        1 |
+----------+

-- Example 4974
SELECT * FROM vartab WHERE IS_NULL_VALUE(v);

-- Example 4975
+---+------+
| N | V    |
|---+------|
| 1 | null |
+---+------+

-- Example 4976
SELECT * FROM vartab WHERE IS_BOOLEAN(v);

-- Example 4977
+---+------+
| N | V    |
|---+------|
| 3 | true |
+---+------+

-- Example 4978
SELECT * FROM vartab WHERE IS_INTEGER(v);

-- Example 4979
+---+-----+
| N | V   |
|---+-----|
| 4 | -17 |
+---+-----+

-- Example 4980
SELECT * FROM vartab WHERE IS_DECIMAL(v);

-- Example 4981
+---+--------+
| N | V      |
|---+--------|
| 4 | -17    |
| 5 | 123.12 |
+---+--------+

-- Example 4982
SELECT * FROM vartab WHERE IS_DOUBLE(v);

-- Example 4983
+---+-----------------------+
| N | V                     |
|---+-----------------------|
| 4 | -17                   |
| 5 | 123.12                |
| 6 | 1.912000000000000e+02 |
+---+-----------------------+

-- Example 4984
SELECT * FROM vartab WHERE IS_VARCHAR(v);

-- Example 4985
+---+------------------------+
| N | V                      |
|---+------------------------|
| 7 | "Om ara pa ca na dhih" |
+---+------------------------+

-- Example 4986
SELECT * FROM vartab WHERE IS_ARRAY(v);

-- Example 4987
+---+-------------+
| N | V           |
|---+-------------|
| 8 | [           |
|   |   -1,       |
|   |   12,       |
|   |   289,      |
|   |   2188,     |
|   |   false,    |
|   |   undefined |
|   | ]           |
+---+-------------+

-- Example 4988
SELECT * FROM vartab WHERE IS_OBJECT(v);

-- Example 4989
+---+---------------+
| N | V             |
|---+---------------|
| 9 | {             |
|   |   "x": "abc", |
|   |   "y": false, |
|   |   "z": 10     |
|   | }             |
+---+---------------+

-- Example 4990
IS_APPLICATION_ROLE_IN_SESSION( '<string_literal>' )

-- Example 4991
SELECT IS_APPLICATION_ROLE_IN_SESSION('ANALYST');

-- Example 4992
+-------------------------------------------+
| IS_APPLICATION_ROLE_IN_SESSION('ANALYST') |
+-------------------------------------------+
| FALSE                                     |
+-------------------------------------------+

-- Example 4993
IS_ARRAY( <variant_expr> )

-- Example 4994
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

-- Example 4995
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 4996
+---+------------------------+------------+
| N | V                      | TYPEOF(V)  |
|---+------------------------+------------|
| 1 | null                   | NULL_VALUE |
| 2 | NULL                   | NULL       |
| 3 | true                   | BOOLEAN    |
| 4 | -17                    | INTEGER    |
| 5 | 123.12                 | DECIMAL    |
| 6 | 1.912000000000000e+02  | DOUBLE     |
| 7 | "Om ara pa ca na dhih" | VARCHAR    |
| 8 | [                      | ARRAY      |
|   |   -1,                  |            |
|   |   12,                  |            |
|   |   289,                 |            |
|   |   2188,                |            |
|   |   false,               |            |
|   |   undefined            |            |
|   | ]                      |            |
| 9 | {                      | OBJECT     |
|   |   "x": "abc",          |            |
|   |   "y": false,          |            |
|   |   "z": 10              |            |
|   | }                      |            |
+---+------------------------+------------+

-- Example 4997
SELECT * FROM vartab WHERE IS_ARRAY(v);

-- Example 4998
+---+-------------+
| N | V           |
|---+-------------|
| 8 | [           |
|   |   -1,       |
|   |   12,       |
|   |   289,      |
|   |   2188,     |
|   |   false,    |
|   |   undefined |
|   | ]           |
+---+-------------+

-- Example 4999
CREATE OR REPLACE TABLE multiple_types (
  array1 VARIANT,
  array2 VARIANT,
  boolean1 VARIANT,
  varchar1 VARIANT,
  varchar2 VARIANT,
  decimal1 VARIANT,
  double1 VARIANT,
  integer1 VARIANT,
  object1 VARIANT);

INSERT INTO multiple_types
    (array1, array2, boolean1, varchar1, varchar2,
     decimal1, double1, integer1, object1)
  SELECT
    TO_VARIANT(TO_ARRAY('Example')),
    TO_VARIANT(ARRAY_CONSTRUCT('Array-like', 'example')),
    TO_VARIANT(TRUE),
    TO_VARIANT('X'),
    TO_VARIANT('I am a real character'),
    TO_VARIANT(1.23::DECIMAL(6, 3)),
    TO_VARIANT(3.21::DOUBLE),
    TO_VARIANT(15),
    TO_VARIANT(TO_OBJECT(PARSE_JSON('{"Tree": "Pine"}')));

-- Example 5000
SELECT TYPEOF(array1),
       TYPEOF(array2),
       TYPEOF(boolean1),
       TYPEOF(varchar1),
       TYPEOF(varchar2),
       TYPEOF(decimal1),
       TYPEOF(double1),
       TYPEOF(integer1),
       TYPEOF(object1)
  FROM multiple_types;

-- Example 5001
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5002
SELECT IS_ARRAY(array1),
       IS_ARRAY(array2),
       IS_ARRAY(boolean1)
  FROM multiple_types;

-- Example 5003
+------------------+------------------+--------------------+
| IS_ARRAY(ARRAY1) | IS_ARRAY(ARRAY2) | IS_ARRAY(BOOLEAN1) |
|------------------+------------------+--------------------|
| True             | True             | False              |
+------------------+------------------+--------------------+

-- Example 5004
IS_BINARY( <variant_expr> )

-- Example 5005
CREATE OR REPLACE TABLE varbin (v VARIANT);

INSERT INTO varbin SELECT TO_VARIANT(TO_BINARY('snow', 'utf-8'));

-- Example 5006
SELECT v AS hex_encoded_binary_value
  FROM varbin
  WHERE IS_BINARY(v);

-- Example 5007
+--------------------------+
| HEX_ENCODED_BINARY_VALUE |
|--------------------------|
| "736E6F77"               |
+--------------------------+

