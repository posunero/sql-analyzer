-- Example 885
SELECT *
    FROM widgets_view
    WHERE 1/iff(color = 'Purple', 0, 1) = 1;

-- Example 886
select table_catalog, table_schema, table_name, is_secure
    from mydb.information_schema.views
    where table_name = 'MYVIEW';

-- Example 887
select table_catalog, table_schema, table_name, is_secure
    from snowflake.account_usage.views
    where table_name = 'MYVIEW';

-- Example 888
SHOW VIEWS LIKE 'myview';

-- Example 889
SHOW MATERIALIZED VIEWS LIKE 'my_mv';

-- Example 890
CREATE TABLE widgets (
    id NUMBER(38,0) DEFAULT widget_id_sequence.nextval, 
    name VARCHAR,
    color VARCHAR,
    price NUMBER(38,0),
    created_on TIMESTAMP_LTZ(9));
CREATE TABLE widget_access_rules (
    widget_id NUMBER(38,0),
    role_name VARCHAR);
CREATE OR REPLACE SECURE VIEW widgets_view AS
    SELECT w.*
        FROM widgets AS w
        WHERE w.id IN (SELECT widget_id
                           FROM widget_access_rules AS a
                           WHERE upper(role_name) = CURRENT_ROLE()
                      )
    ;

-- Example 891
SELECT *
    FROM widgets_view
    WHERE 1/iff(color = 'Purple', 0, 1) = 1;

-- Example 892
select * from widgets_view order by created_on;

------+-----------------------+-------+-------+-------------------------------+
  ID  |         NAME          | COLOR | PRICE |          CREATED_ON           |
------+-----------------------+-------+-------+-------------------------------+
...
 315  | Small round widget    | Red   | 1     | 2017-01-07 15:22:14.810 -0700 |
 1455 | Small cylinder widget | Blue  | 2     | 2017-01-15 03:00:12.106 -0700 |
...

-- Example 893
ALTER TABLE <table_name> ALTER COLUMN <column_name> SET DEFAULT <new_sequence>.nextval;

-- Example 894
ALTER TABLE <name> RESUME RECLUSTER

-- Example 895
CREATE OR REPLACE DATABASE staging_sales CLONE sales;

DROP TABLE sales.public.t_sales;

ALTER TABLE sales.public.t_sales_20170522 RENAME TO sales.public.t_sales;

-- Example 896
002002 (42710): None: SQL compilation error: Object 'T_SALES' already exists.

-- Example 897
ProgrammingError occurred: "000707 (02000): None: Data is not available." with query id None

-- Example 898
CREATE TABLE t_sales (numeric integer) data_retention_time_in_days=1;

CREATE OR REPLACE TABLE sales.public.t_sales_20170522 CLONE sales.public.t_sales at(offset => -60*30);

-- Example 899
002003 (02000): SQL compilation error:
Object 'SALES.PUBLIC.T_SALES' does not exist.

-- Example 900
CREATE OR REPLACE TABLE test_fixed(
  num0 NUMBER,
  num10 NUMBER(10,1),
  dec20 DECIMAL(20,2),
  numeric30 NUMERIC(30,3),
  int1 INT,
  int2 INTEGER);

DESC TABLE test_fixed;

-- Example 901
+-----------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name      | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|-----------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| NUM0      | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| NUM10     | NUMBER(10,1) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| DEC20     | NUMBER(20,2) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| NUMERIC30 | NUMBER(30,3) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| INT1      | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| INT2      | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+-----------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 902
CREATE OR REPLACE TABLE test_float(
  double1 DOUBLE,
  float1 FLOAT,
  dp1 DOUBLE PRECISION,
  real1 REAL);

DESC TABLE test_float;

-- Example 903
+---------+-------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name    | type  | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|---------+-------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| DOUBLE1 | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| FLOAT1  | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| DP1     | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| REAL1   | FLOAT | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+---------+-------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 904
15
+1.34
0.2
15e-03
1.234E2
1.234E+2
-1

-- Example 905
CREATE TABLE t1 (v VARCHAR(16777216));

-- Example 906
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

-- Example 907
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

-- Example 908
CREATE OR REPLACE TABLE test_binary(
  bd BINARY,
  b100 BINARY(100),
  vbd VARBINARY);

DESC TABLE test_binary;

-- Example 909
+------+-----------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type            | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+-----------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| BD   | BINARY(8388608) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| B100 | BINARY(100)     | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| VBD  | BINARY(8388608) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+-----------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 910
SELECT 'Today''s sales projections', '-''''-';

-- Example 911
+------------------------------+----------+
| 'TODAY''S SALES PROJECTIONS' | '-''''-' |
|------------------------------+----------|
| Today's sales projections    | -''-     |
+------------------------------+----------+

-- Example 912
SELECT $1, $2 FROM
  VALUES
    ('Tab','Hello\tWorld'),
    ('Newline','Hello\nWorld'),
    ('Backslash','C:\\user'),
    ('Octal','-\041-'),
    ('Hexadecimal','-\x21-'),
    ('Unicode','-\u26c4-'),
    ('Not an escape sequence', '\z');

-- Example 913
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

-- Example 914
'string with a \' character'

-- Example 915
$$string with a ' character$$

-- Example 916
'regular expression with \\ characters: \\d{2}-\\d{3}-\\d{4}'

-- Example 917
$$regular expression with \ characters: \d{2}-\d{3}-\d{4}$$

-- Example 918
'string with a newline\ncharacter'

-- Example 919
$$string with a newline
character$$

-- Example 920
SELECT $1, $2 FROM VALUES (
  'row1',
  $$a
                                  ' \ \t
                                  \x21 z $ $$);

-- Example 921
+------+---------------------------------------------+
| $1   | $2                                          |
|------+---------------------------------------------|
| row1 | a                                           |
|      |                                   ' \ \t    |
|      |                                   \x21 z $  |
+------+---------------------------------------------+

-- Example 922
CREATE OR REPLACE TABLE test_boolean(
  b BOOLEAN,
  n NUMBER,
  s STRING);

INSERT INTO test_boolean VALUES
  (true, 1, 'yes'),
  (false, 0, 'no'),
  (NULL, NULL, NULL);

SELECT * FROM test_boolean;

-- Example 923
+-------+------+------+
| B     |    N | S    |
|-------+------+------|
| True  |    1 | yes  |
| False |    0 | no   |
| NULL  | NULL | NULL |
+-------+------+------+

-- Example 924
SELECT b, n, NOT b AND (n < 1) FROM test_boolean;

-- Example 925
+-------+------+-------------------+
| B     |    N | NOT B AND (N < 1) |
|-------+------+-------------------|
| True  |    1 | False             |
| False |    0 | True              |
| NULL  | NULL | NULL              |
+-------+------+-------------------+

-- Example 926
SELECT * FROM test_boolean WHERE NOT b AND (n < 1);

-- Example 927
+-------+---+----+
| B     | N | S  |
|-------+---+----|
| False | 0 | no |
+-------+---+----+

-- Example 928
SELECT s,
       TO_BOOLEAN(s),
       SYSTEM$TYPEOF(TO_BOOLEAN(s))
  FROM test_boolean;

-- Example 929
+------+---------------+------------------------------+
| S    | TO_BOOLEAN(S) | SYSTEM$TYPEOF(TO_BOOLEAN(S)) |
|------+---------------+------------------------------|
| yes  | True          | BOOLEAN[SB1]                 |
| no   | False         | BOOLEAN[SB1]                 |
| NULL | NULL          | BOOLEAN[SB1]                 |
+------+---------------+------------------------------+

-- Example 930
SELECT n,
       TO_BOOLEAN(n),
       SYSTEM$TYPEOF(TO_BOOLEAN(n))
  FROM test_boolean;

-- Example 931
+------+---------------+------------------------------+
| N    | TO_BOOLEAN(N) | SYSTEM$TYPEOF(TO_BOOLEAN(N)) |
|------+---------------+------------------------------|
| 1    | True          | BOOLEAN[SB1]                 |
| 0    | False         | BOOLEAN[SB1]                 |
| NULL | NULL          | BOOLEAN[SB1]                 |
+------+---------------+------------------------------+

-- Example 932
SELECT 'Text for ' || s || ' is ' || b AS result,
       SYSTEM$TYPEOF('Text for ' || s || ' is ' || b) AS type_of_result
  FROM test_boolean;

-- Example 933
+----------------------+------------------------+
| RESULT               | TYPE_OF_RESULT         |
|----------------------+------------------------|
| Text for yes is true | VARCHAR(16777216)[LOB] |
| Text for no is false | VARCHAR(16777216)[LOB] |
| NULL                 | VARCHAR(16777216)[LOB] |
+----------------------+------------------------+

-- Example 934
SELECT '2024-01-01 00:00:00 +0000'::TIMESTAMP_TZ = '2024-01-01 01:00:00 +0100'::TIMESTAMP_TZ;

-- Example 935
SELECT '2024-01-01 12:00:00'::TIMESTAMP_TZ;

-- Example 936
+-------------------------------------+
| '2024-01-01 12:00:00'::TIMESTAMP_TZ |
|-------------------------------------|
| 2024-01-01 12:00:00.000 -0800       |
+-------------------------------------+

-- Example 937
SELECT DATEADD(MONTH, 6, '2024-01-01 12:00:00'::TIMESTAMP_TZ);

-- Example 938
+--------------------------------------------------------+
| DATEADD(MONTH, 6, '2024-01-01 12:00:00'::TIMESTAMP_TZ) |
|--------------------------------------------------------|
| 2024-07-01 12:00:00.000 -0800                          |
+--------------------------------------------------------+

-- Example 939
ALTER SESSION SET TIMESTAMP_TYPE_MAPPING = TIMESTAMP_NTZ;

CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP);

DESC TABLE ts_test;

-- Example 940
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type             | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| TS   | TIMESTAMP_NTZ(9) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 941
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_LTZ);

DESC TABLE ts_test;

-- Example 942
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type             | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| TS   | TIMESTAMP_LTZ(9) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 943
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_LTZ);

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2024-01-01 16:00:00');
INSERT INTO ts_test VALUES('2024-01-02 16:00:00 +00:00');

-- Example 944
SELECT ts, HOUR(ts) FROM ts_test;

-- Example 945
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 16:00:00.000 -0800 |       16 |
| 2024-01-02 08:00:00.000 -0800 |        8 |
+-------------------------------+----------+

-- Example 946
ALTER SESSION SET TIMEZONE = 'America/New_York';

SELECT ts, HOUR(ts) FROM ts_test;

-- Example 947
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 19:00:00.000 -0500 |       19 |
| 2024-01-02 11:00:00.000 -0500 |       11 |
+-------------------------------+----------+

-- Example 948
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_NTZ);

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2024-01-01 16:00:00');
INSERT INTO ts_test VALUES('2024-01-02 16:00:00 +00:00');

-- Example 949
SELECT ts, HOUR(ts) FROM ts_test;

-- Example 950
+-------------------------+----------+
| TS                      | HOUR(TS) |
|-------------------------+----------|
| 2024-01-01 16:00:00.000 |       16 |
| 2024-01-02 16:00:00.000 |       16 |
+-------------------------+----------+

-- Example 951
ALTER SESSION SET TIMEZONE = 'America/New_York';

SELECT ts, HOUR(ts) FROM ts_test;

-- Example 952
+-------------------------+----------+
| TS                      | HOUR(TS) |
|-------------------------+----------|
| 2024-01-01 16:00:00.000 |       16 |
| 2024-01-02 16:00:00.000 |       16 |
+-------------------------+----------+

