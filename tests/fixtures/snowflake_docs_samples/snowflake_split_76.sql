-- Example 5075
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5076
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

-- Example 5077
SELECT * FROM vartab WHERE IS_INTEGER(v);

-- Example 5078
+---+-----+
| N | V   |
|---+-----|
| 4 | -17 |
+---+-----+

-- Example 5079
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

-- Example 5080
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

-- Example 5081
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5082
SELECT IS_INTEGER(decimal1),
       IS_INTEGER(double1),
       IS_INTEGER(integer1)
  FROM multiple_types;

-- Example 5083
+----------------------+---------------------+----------------------+
| IS_INTEGER(DECIMAL1) | IS_INTEGER(DOUBLE1) | IS_INTEGER(INTEGER1) |
|----------------------+---------------------+----------------------|
| False                | False               | True                 |
+----------------------+---------------------+----------------------+

-- Example 5084
IS_NULL_VALUE( <variant_expr> )

-- Example 5085
CREATE OR REPLACE TABLE test_is_null_value_function (
  variant_value VARIANT);

-- Example 5086
INSERT INTO test_is_null_value_function (variant_value)
  (SELECT PARSE_JSON('"string value"'));

-- Example 5087
INSERT INTO test_is_null_value_function (variant_value)
  (SELECT PARSE_JSON('null'));

-- Example 5088
INSERT INTO test_is_null_value_function (variant_value)
  (SELECT PARSE_JSON('{}'));

-- Example 5089
INSERT INTO test_is_null_value_function (variant_value)
  (SELECT PARSE_JSON('{"x": null}'));

INSERT INTO test_is_null_value_function (variant_value)
  (SELECT PARSE_JSON('{"x": "foo"}'));

-- Example 5090
INSERT INTO test_is_null_value_function (variant_value)
  (SELECT PARSE_JSON(NULL));

-- Example 5091
SELECT variant_value,
       variant_value:x value_of_x,
       IS_NULL_VALUE(variant_value) is_variant_value_a_json_null,
       IS_NULL_VALUE(variant_value:x) is_x_a_json_null,
       IS_NULL_VALUE(variant_value:y) is_y_a_json_null
  FROM test_is_null_value_function;

-- Example 5092
+----------------+------------+------------------------------+------------------+------------------+
| VARIANT_VALUE  | VALUE_OF_X | IS_VARIANT_VALUE_A_JSON_NULL | IS_X_A_JSON_NULL | IS_Y_A_JSON_NULL |
|----------------+------------+------------------------------+------------------+------------------|
| "string value" | NULL       | False                        | NULL             | NULL             |
| null           | NULL       | True                         | NULL             | NULL             |
| {}             | NULL       | False                        | NULL             | NULL             |
| {              | null       | False                        | True             | NULL             |
|   "x": null    |            |                              |                  |                  |
| }              |            |                              |                  |                  |
| {              | "foo"      | False                        | False            | NULL             |
|   "x": "foo"   |            |                              |                  |                  |
| }              |            |                              |                  |                  |
| NULL           | NULL       | NULL                         | NULL             | NULL             |
+----------------+------------+------------------------------+------------------+------------------+

-- Example 5093
SELECT PARSE_JSON(NULL) AS "SQL NULL",
       PARSE_JSON('null') AS "JSON NULL",
       PARSE_JSON('[ null ]') AS "JSON NULL",
       PARSE_JSON('{ "a": null }'):a AS "JSON NULL",
       PARSE_JSON('{ "a": null }'):b AS "ABSENT VALUE";

-- Example 5094
+----------+-----------+-----------+-----------+--------------+
| SQL NULL | JSON NULL | JSON NULL | JSON NULL | ABSENT VALUE |
|----------+-----------+-----------+-----------+--------------|
| NULL     | null      | [         | null      | NULL         |
|          |           |   null    |           |              |
|          |           | ]         |           |              |
+----------+-----------+-----------+-----------+--------------+

-- Example 5095
SELECT PARSE_JSON('{ "a": null }'):a,
       TO_CHAR(PARSE_JSON('{ "a": null }'):a);

-- Example 5096
+-------------------------------+----------------------------------------+
| PARSE_JSON('{ "A": NULL }'):A | TO_CHAR(PARSE_JSON('{ "A": NULL }'):A) |
|-------------------------------+----------------------------------------|
| null                          | NULL                                   |
+-------------------------------+----------------------------------------+

-- Example 5097
SELECT ARRAY_CONSTRUCT(1, NULL, PARSE_JSON('null')) AS array_with_null_values;

-- Example 5098
+------------------------+
| ARRAY_WITH_NULL_VALUES |
|------------------------|
| [                      |
|   1,                   |
|   undefined,           |
|   null                 |
| ]                      |
+------------------------+

-- Example 5099
{"foo":1}

-- Example 5100
{"foo":"1"}

-- Example 5101
SELECT column1
  , TO_VARCHAR(PARSE_JSON(column1):a)
FROM
  VALUES('{"a" : null}')
, ('{"b" : "hello"}')
, ('{"a" : "world"}');

+-----------------+-----------------------------------+
| COLUMN1         | TO_VARCHAR(PARSE_JSON(COLUMN1):A) |
|-----------------+-----------------------------------|
| {"a" : null}    | NULL                              |
| {"b" : "hello"} | NULL                              |
| {"a" : "world"} | world                             |
+-----------------+-----------------------------------+

-- Example 5102
IS_OBJECT( <variant_expr> )

-- Example 5103
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

-- Example 5104
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5105
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

-- Example 5106
SELECT * FROM vartab WHERE IS_OBJECT(v);

-- Example 5107
+---+---------------+
| N | V             |
|---+---------------|
| 9 | {             |
|   |   "x": "abc", |
|   |   "y": false, |
|   |   "z": 10     |
|   | }             |
+---+---------------+

-- Example 5108
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

-- Example 5109
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

-- Example 5110
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5111
SELECT IS_OBJECT(array1),
       IS_OBJECT(boolean1),
       IS_OBJECT(object1)
  FROM multiple_types;

-- Example 5112
+-------------------+---------------------+--------------------+
| IS_OBJECT(ARRAY1) | IS_OBJECT(BOOLEAN1) | IS_OBJECT(OBJECT1) |
|-------------------+---------------------+--------------------|
| False             | False               | True               |
+-------------------+---------------------+--------------------+

-- Example 5113
IS_ROLE_IN_SESSION( '<string_literal>' )

-- Example 5114
IS_ROLE_IN_SESSION( <column_name> )

-- Example 5115
SELECT IS_ROLE_IN_SESSION(UPPER(authz_role)) FROM t1;

-- Example 5116
CREATE VIEW v2 AS
SELECT
  authz_role,
  UPPER(authz_role) AS upper_authz_role
FROM t2;

SELECT IS_ROLE_IN_SESSION(upper_authz_role) FROM v2;

-- Example 5117
SELECT IS_ROLE_IN_SESSION('ANALYST');

+-------------------------------+
| IS_ROLE_IN_SESSION('ANALYST') |
|-------------------------------|
| True                          |
+-------------------------------+

-- Example 5118
SELECT *
FROM myb.s1.t1
WHERE IS_ROLE_IN_SESSION(t1.role_name);

-- Example 5119
CREATE OR REPLACE MASKING POLICY allow_analyst AS (val string)
RETURNS string ->
CASE
  WHEN IS_ROLE_IN_SESSION('ANALYST') THEN val
  ELSE '*******'
END;

-- Example 5120
CREATE OR REPLACE ROW ACCESS POLICY rap_authz_role AS (authz_role string)
RETURNS boolean ->
IS_ROLE_IN_SESSION(authz_role);

-- Example 5121
ALTER TABLE allowed_roles
  ADD ROW ACCESS POLICY rap_authz_role ON (authz_role);

-- Example 5122
CREATE OR REPLACE ROW ACCESS POLICY rap_authz_role_map AS (authz_role string)
RETURNS boolean ->
EXISTS (
  SELECT 1 FROM mapping_table m
  WHERE authz_role = m.key and IS_ROLE_IN_SESSION(m.role_name)
);

-- Example 5123
ALTER TABLE allowed_roles
  ADD ROW ACCESS POLICY rap_authz_role_map ON (authz_role);

-- Example 5124
IS_TIME( <variant_expr> )

-- Example 5125
CREATE OR REPLACE TABLE vardttm (v VARIANT);

-- Example 5126
INSERT INTO vardttm SELECT TO_VARIANT(TO_DATE('2024-02-24'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIME('20:57:01.123456789+07:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP('2023-02-24 12:00:00.456'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_LTZ('2022-02-24 13:00:00.123 +01:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_NTZ('2021-02-24 14:00:00.123 +01:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_TZ('2020-02-24 15:00:00.123 +01:00'));

-- Example 5127
SELECT v, TYPEOF(v) AS type FROM vardttm;

-- Example 5128
+---------------------------------+---------------+
| V                               | TYPE          |
|---------------------------------+---------------|
| "2024-02-24"                    | DATE          |
| "20:57:01"                      | TIME          |
| "2023-02-24 12:00:00.456"       | TIMESTAMP_NTZ |
| "2022-02-24 04:00:00.123 -0800" | TIMESTAMP_LTZ |
| "2021-02-24 14:00:00.123"       | TIMESTAMP_NTZ |
| "2020-02-24 15:00:00.123 +0100" | TIMESTAMP_TZ  |
+---------------------------------+---------------+

-- Example 5129
SELECT v FROM vardttm WHERE IS_TIME(v);

-- Example 5130
+------------+
| V          |
|------------|
| "20:57:01" |
+------------+

-- Example 5131
IS_TIMESTAMP_LTZ( <variant_expr> )

IS_TIMESTAMP_NTZ( <variant_expr> )

IS_TIMESTAMP_TZ( <variant_expr> )

-- Example 5132
CREATE OR REPLACE TABLE vardttm (v VARIANT);

-- Example 5133
INSERT INTO vardttm SELECT TO_VARIANT(TO_DATE('2024-02-24'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIME('20:57:01.123456789+07:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP('2023-02-24 12:00:00.456'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_LTZ('2022-02-24 13:00:00.123 +01:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_NTZ('2021-02-24 14:00:00.123 +01:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_TZ('2020-02-24 15:00:00.123 +01:00'));

-- Example 5134
SELECT v, TYPEOF(v) AS type FROM vardttm;

-- Example 5135
+---------------------------------+---------------+
| V                               | TYPE          |
|---------------------------------+---------------|
| "2024-02-24"                    | DATE          |
| "20:57:01"                      | TIME          |
| "2023-02-24 12:00:00.456"       | TIMESTAMP_NTZ |
| "2022-02-24 04:00:00.123 -0800" | TIMESTAMP_LTZ |
| "2021-02-24 14:00:00.123"       | TIMESTAMP_NTZ |
| "2020-02-24 15:00:00.123 +0100" | TIMESTAMP_TZ  |
+---------------------------------+---------------+

-- Example 5136
SELECT * FROM vardttm WHERE IS_TIMESTAMP_NTZ(v);

-- Example 5137
+---------------------------+
| V                         |
|---------------------------|
| "2023-02-24 12:00:00.456" |
| "2021-02-24 14:00:00.123" |
+---------------------------+

-- Example 5138
SELECT * FROM vardttm WHERE IS_TIMESTAMP_LTZ(v);

-- Example 5139
+---------------------------------+
| V                               |
|---------------------------------|
| "2022-02-24 04:00:00.123 -0800" |
+---------------------------------+

-- Example 5140
SELECT * FROM vardttm WHERE IS_TIMESTAMP_TZ(v);

-- Example 5141
+---------------------------------+
| V                               |
|---------------------------------|
| "2020-02-24 15:00:00.123 +0100" |
+---------------------------------+

