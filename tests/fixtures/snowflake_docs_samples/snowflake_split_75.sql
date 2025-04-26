-- Example 5008
IS_BOOLEAN( <variant_expr> )

-- Example 5009
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

-- Example 5010
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5011
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

-- Example 5012
SELECT * FROM vartab WHERE IS_BOOLEAN(v);

-- Example 5013
+---+------+
| N | V    |
|---+------|
| 3 | true |
+---+------+

-- Example 5014
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

-- Example 5015
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

-- Example 5016
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5017
SELECT IS_BOOLEAN(boolean1),
       IS_BOOLEAN(array1)
  FROM multiple_types;

-- Example 5018
+----------------------+--------------------+
| IS_BOOLEAN(BOOLEAN1) | IS_BOOLEAN(ARRAY1) |
|----------------------+--------------------|
| True                 | False              |
+----------------------+--------------------+

-- Example 5019
IS_CHAR( <variant_expr> )

IS_VARCHAR( <variant_expr> )

-- Example 5020
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

-- Example 5021
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5022
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

-- Example 5023
SELECT * FROM vartab WHERE IS_VARCHAR(v);

-- Example 5024
+---+------------------------+
| N | V                      |
|---+------------------------|
| 7 | "Om ara pa ca na dhih" |
+---+------------------------+

-- Example 5025
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

-- Example 5026
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

-- Example 5027
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5028
SELECT IS_VARCHAR(varchar1),
       IS_VARCHAR(boolean1)
  FROM multiple_types;

-- Example 5029
+----------------------+----------------------+
| IS_VARCHAR(VARCHAR1) | IS_VARCHAR(BOOLEAN1) |
|----------------------+----------------------|
| True                 | False                |
+----------------------+----------------------+

-- Example 5030
IS_DATABASE_ROLE_IN_SESSION( '<string_literal>' )

-- Example 5031
IS_DATABASE_ROLE_IN_SESSION( <column_name> )

-- Example 5032
Could not resolve the database for IS_DATABASE_ROLE_IN_SESSION({})

-- Example 5033
SELECT IS_ROLE_IN_SESSION(UPPER(authz_role)) FROM t1;

-- Example 5034
CREATE VIEW v2 AS
SELECT
  authz_role,
  UPPER(authz_role) AS upper_authz_role
FROM t2;

SELECT IS_ROLE_IN_SESSION(upper_authz_role) FROM v2;

-- Example 5035
SELECT IS_DATABASE_ROLE_IN_SESSION('R1');

-- Example 5036
+-----------------------------------+
| IS_DATABASE_ROLE_IN_SESSION('R1') |
+-----------------------------------+
| True                              |
+-----------------------------------+

-- Example 5037
SELECT *
FROM myb.s1.t1
WHERE IS_DATABASE_ROLE_IN_SESSION(role_name);

-- Example 5038
IS_DATE( <variant_expr> )

IS_DATE_VALUE( <variant_expr> )

-- Example 5039
CREATE OR REPLACE TABLE vardttm (v VARIANT);

-- Example 5040
INSERT INTO vardttm SELECT TO_VARIANT(TO_DATE('2024-02-24'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIME('20:57:01.123456789+07:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP('2023-02-24 12:00:00.456'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_LTZ('2022-02-24 13:00:00.123 +01:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_NTZ('2021-02-24 14:00:00.123 +01:00'));
INSERT INTO vardttm SELECT TO_VARIANT(TO_TIMESTAMP_TZ('2020-02-24 15:00:00.123 +01:00'));

-- Example 5041
SELECT v, TYPEOF(v) AS type FROM vardttm;

-- Example 5042
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

-- Example 5043
SELECT v FROM vardttm WHERE IS_DATE(v);

-- Example 5044
+--------------+
| V            |
|--------------|
| "2024-02-24" |
+--------------+

-- Example 5045
IS_DECIMAL( <variant_expr> )

-- Example 5046
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

-- Example 5047
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5048
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

-- Example 5049
SELECT * FROM vartab WHERE IS_DECIMAL(v);

-- Example 5050
+---+--------+
| N | V      |
|---+--------|
| 4 | -17    |
| 5 | 123.12 |
+---+--------+

-- Example 5051
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

-- Example 5052
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

-- Example 5053
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5054
SELECT IS_DECIMAL(decimal1),
       IS_DECIMAL(double1),
       IS_DECIMAL(integer1)
  FROM multiple_types;

-- Example 5055
+----------------------+---------------------+----------------------+
| IS_DECIMAL(DECIMAL1) | IS_DECIMAL(DOUBLE1) | IS_DECIMAL(INTEGER1) |
|----------------------+---------------------+----------------------|
| True                 | False               | True                 |
+----------------------+---------------------+----------------------+

-- Example 5056
IS_DOUBLE( <variant_expr> )

IS_REAL( <variant_expr> )

-- Example 5057
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

-- Example 5058
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5059
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

-- Example 5060
SELECT * FROM vartab WHERE IS_DOUBLE(v);

-- Example 5061
+---+-----------------------+
| N | V                     |
|---+-----------------------|
| 4 | -17                   |
| 5 | 123.12                |
| 6 | 1.912000000000000e+02 |
+---+-----------------------+

-- Example 5062
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

-- Example 5063
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

-- Example 5064
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+
| TYPEOF(ARRAY1) | TYPEOF(ARRAY2) | TYPEOF(BOOLEAN1) | TYPEOF(VARCHAR1) | TYPEOF(VARCHAR2) | TYPEOF(DECIMAL1) | TYPEOF(DOUBLE1) | TYPEOF(INTEGER1) | TYPEOF(OBJECT1) |
|----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------|
| ARRAY          | ARRAY          | BOOLEAN          | VARCHAR          | VARCHAR          | DECIMAL          | DOUBLE          | INTEGER          | OBJECT          |
+----------------+----------------+------------------+------------------+------------------+------------------+-----------------+------------------+-----------------+

-- Example 5065
SELECT IS_DOUBLE(boolean1),
       IS_DOUBLE(decimal1),
       IS_DOUBLE(double1),
       IS_DOUBLE(integer1)
  FROM multiple_types;

-- Example 5066
+---------------------+---------------------+--------------------+---------------------+
| IS_DOUBLE(BOOLEAN1) | IS_DOUBLE(DECIMAL1) | IS_DOUBLE(DOUBLE1) | IS_DOUBLE(INTEGER1) |
|---------------------+---------------------+--------------------+---------------------|
| False               | True                | True               | True                |
+---------------------+---------------------+--------------------+---------------------+

-- Example 5067
IS_GRANTED_TO_INVOKER_ROLE( '<string_literal>' )

-- Example 5068
IS_GRANTED_TO_INVOKER_ROLE('ANALYST')

--------------------------------------+
IS_GRANTED_TO_INVOKER_ROLE('ANALYST') |
--------------------------------------+
                TRUE                  |
--------------------------------------+

-- Example 5069
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN IS_GRANTED_TO_INVOKER_ROLE('ANALYST') then val
  ELSE '*******'
END;

-- Example 5070
IS_INSTANCE_ROLE_IN_SESSION( '<instance_name>' , '<instance_role_name>' )

-- Example 5071
USE ROLE my_role;

SELECT IS_INSTANCE_ROLE_IN_SESSION('my_db.my_schema.my_anomaly_detector', 'user');

-- Example 5072
+----------------------------------------------------------------------------+
| IS_INSTANCE_ROLE_IN_SESSION('MY_DB.MY_SCHEMA.MY_ANOMALY_DETECTOR', 'USER') |
+----------------------------------------------------------------------------+
| TRUE                                                                       |
+----------------------------------------------------------------------------+

-- Example 5073
IS_INTEGER( <variant_expr> )

-- Example 5074
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

