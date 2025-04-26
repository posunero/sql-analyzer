-- Example 8892
SHOW TABLES LIKE 'tt1';

-- Example 8893
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | change_tracking | is_external | enable_schema_evolution | owner_role_type | is_event | budget |
|-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------|
| 2023-10-19 10:37:04.858 -0700 | TT1  | TESTDB        | MY_SCHEMA   | TABLE |         |            |    0 |     0 | PUBLIC | 1              | OFF             | N           | N                       | ROLE            | N        | NULL   |
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+

-- Example 8894
CREATE OR REPLACE TABLE t1(a1 NUMBER, a2 VARCHAR, a3 DATE);
CREATE OR REPLACE TABLE t2(b1 VARCHAR);

-- Example 8895
DESC TABLE t1;

-- Example 8896
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | DATE              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8897
DESC TABLE t2;

-- Example 8898
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8899
ALTER TABLE t1 SWAP WITH t2;

-- Example 8900
DESC TABLE t1;

-- Example 8901
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8902
DESC TABLE t2;

-- Example 8903
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | DATE              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8904
CREATE OR REPLACE TABLE t1(a1 NUMBER);

-- Example 8905
DESC TABLE t1;

-- Example 8906
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8907
ALTER TABLE t1 ADD COLUMN a2 NUMBER;

-- Example 8908
ALTER TABLE t1 ADD COLUMN a3 NUMBER NOT NULL;

-- Example 8909
ALTER TABLE t1 ADD COLUMN a4 NUMBER DEFAULT 0 NOT NULL;

-- Example 8910
ALTER TABLE t1 ADD COLUMN a5 VARCHAR COLLATE 'en_US';

-- Example 8911
DESC TABLE t1;

-- Example 8912
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type                              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0)                      | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0)                      | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A5   | VARCHAR(16777216) COLLATE 'en_us' | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8913
ALTER TABLE t1 ADD COLUMN IF NOT EXISTS a2 NUMBER;

-- Example 8914
DESC TABLE t1;

-- Example 8915
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type                              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0)                      | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0)                      | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A5   | VARCHAR(16777216) COLLATE 'en_us' | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8916
ALTER TABLE t1 RENAME COLUMN a1 TO b1;

-- Example 8917
DESC TABLE t1;

-- Example 8918
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0) | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8919
ALTER TABLE t1 DROP COLUMN a2;

-- Example 8920
DESC TABLE t1;

-- Example 8921
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0) | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8922
ALTER TABLE t1 DROP COLUMN IF EXISTS a2;

-- Example 8923
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0) | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 8924
CREATE EXTERNAL TABLE exttable1
  LOCATION=@mystage/logs/
  AUTO_REFRESH = true
  FILE_FORMAT = (TYPE = PARQUET)
  ;

-- Example 8925
DESC EXTERNAL TABLE exttable1;

-- Example 8926
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 8927
ALTER TABLE exttable1 ADD COLUMN a1 VARCHAR AS (value:a1::VARCHAR);

-- Example 8928
DESC EXTERNAL TABLE exttable1;

-- Example 8929
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
| A1        | VARCHAR(16777216) | VIRTUAL   | Y     | NULL    | N           | N          | NULL  | TO_CHAR(GET(VALUE, 'a1'))                                | NULL                  |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 8930
ALTER TABLE exttable1 RENAME COLUMN a1 TO b1;

-- Example 8931
DESC EXTERNAL TABLE exttable1;

-- Example 8932
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
| B1        | VARCHAR(16777216) | VIRTUAL   | Y     | NULL    | N           | N          | NULL  | TO_CHAR(GET(VALUE, 'a1'))                                | NULL                  |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 8933
ALTER TABLE exttable1 DROP COLUMN b1;

-- Example 8934
DESC EXTERNAL TABLE exttable1;

-- Example 8935
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 8936
CREATE OR REPLACE TABLE T1 (id NUMBER, date TIMESTAMP_NTZ, name STRING) CLUSTER BY (id, date);

-- Example 8937
SHOW TABLES LIKE 'T1';

-- Example 8938
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (ID,DATE)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Example 8939
ALTER TABLE t1 CLUSTER BY (date, id);

-- Example 8940
SHOW TABLES LIKE 'T1';

-- Example 8941
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (DATE,ID)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Example 8942
ALTER TABLE t1 ADD ROW ACCESS POLICY rap_t1 ON (empl_id);

-- Example 8943
ALTER TABLE t1 ADD ROW ACCESS POLICY rap_test2 ON (cost, item);

-- Example 8944
ALTER TABLE t1 DROP ROW ACCESS POLICY rap_v1;

-- Example 8945
alter table t1
  drop row access policy rap_t1_version_1,
  add row access policy rap_t1_version_2 on (empl_id);

-- Example 8946
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = '5 MINUTE';

-- Example 8947
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * * UTC';

-- Example 8948
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * MON,TUE,WED,THU,FRI UTC';

-- Example 8949
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 6,12,18 * * * UTC';

-- Example 8950
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES';

-- Example 8951
ALTER TABLE join_table_2
  SET JOIN POLICY jp1 ALLOWED JOIN KEYS (col1);

-- Example 8952
INSERT [ OVERWRITE ] INTO <target_table> [ ( <target_col_name> [ , ... ] ) ]
       {
         VALUES ( { <value> | DEFAULT | NULL } [ , ... ] ) [ , ( ... ) ]  |
         <query>
       }

-- Example 8953
DROP TABLE t;
CREATE TABLE t AS SELECT * FROM ... ;

-- Example 8954
VALUES ( 1, 2, 3 ) ,
       ( 1, 2, 3 ) ,
       ( 2, 3, 4 )

-- Example 8955
INSERT INTO table1 (ID, varchar1, variant1)
    VALUES (4, 'Fourier', PARSE_JSON('{ "key1": "value1", "key2": "value2" }'));

-- Example 8956
INSERT INTO table1 (ID, varchar1, variant1)
    SELECT 4, 'Fourier', PARSE_JSON('{ "key1": "value1", "key2": "value2" }');

-- Example 8957
DESC TABLE mytable;

+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name | type             | kind   | null? | default | primary key | unique key | check | expression | comment |
|------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| COL1 | DATE             | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| COL2 | TIMESTAMP_NTZ(9) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| COL3 | TIMESTAMP_NTZ(9) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+------+------------------+--------+-------+---------+-------------+------------+-------+------------+---------+

INSERT INTO mytable
  SELECT TO_DATE('2013-05-08T23:39:20.123'), TO_TIMESTAMP('2013-05-08T23:39:20.123'), TO_TIMESTAMP('2013-05-08T23:39:20.123');

SELECT * FROM mytable;

+------------+-------------------------+-------------------------+
| COL1       | COL2                    | COL3                    |
|------------+-------------------------+-------------------------|
| 2013-05-08 | 2013-05-08 23:39:20.123 | 2013-05-08 23:39:20.123 |
+------------+-------------------------+-------------------------+

-- Example 8958
INSERT INTO mytable (col1, col3)
  SELECT TO_DATE('2013-05-08T23:39:20.123'), TO_TIMESTAMP('2013-05-08T23:39:20.123');

SELECT * FROM mytable;

+------------+-------------------------+-------------------------+
| COL1       | COL2                    | COL3                    |
|------------+-------------------------+-------------------------|
| 2013-05-08 | 2013-05-08 23:39:20.123 | 2013-05-08 23:39:20.123 |
| 2013-05-08 | NULL                    | 2013-05-08 23:39:20.123 |
+------------+-------------------------+-------------------------+

