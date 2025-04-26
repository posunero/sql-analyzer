-- Example 8959
SELECT * FROM employees;

+------------+-----------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+-----------+----------------+---------------+-------------|
| May        | Franklin  | 1-650-249-5198 | San Francisco | 94115       |
| Gillian    | Patterson | 1-650-859-3954 | San Francisco | 94115       |
+------------+-----------+----------------+---------------+-------------+

INSERT INTO employees
  VALUES
  ('Lysandra','Reeves','1-212-759-3751','New York',10018),
  ('Michael','Arnett','1-650-230-8467','San Francisco',94116);

SELECT * FROM employees;

+------------+-----------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+-----------+----------------+---------------+-------------|
| May        | Franklin  | 1-650-249-5198 | San Francisco | 94115       |
| Gillian    | Patterson | 1-650-859-3954 | San Francisco | 94115       |
| Lysandra   | Reeves    | 1-212-759-3751 | New York      | 10018       |
| Michael    | Arnett    | 1-650-230-8467 | San Francisco | 94116       |
+------------+-----------+----------------+---------------+-------------+

-- Example 8960
CREATE TABLE t1 (v VARCHAR);

-- works as expected.
INSERT INTO t1 (v) VALUES
   ('three'),
   ('four');

-- Fails with error "Numeric value 'd' is not recognized"
-- even though the data type of 'd' is the same as the
-- data type of the column v.
INSERT INTO t1 (v) VALUES
   (3),
   ('d');

-- Example 8961
SELECT * FROM employees;

+------------+-----------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+-----------+----------------+---------------+-------------|
| May        | Franklin  | 1-650-249-5198 | San Francisco | 94115       |
| Gillian    | Patterson | 1-650-859-3954 | San Francisco | 94115       |
| Lysandra   | Reeves    | 1-212-759-3751 | New York      | 10018       |
| Michael    | Arnett    | 1-650-230-8467 | San Francisco | 94116       |
+------------+-----------+----------------+---------------+-------------+

SELECT * FROM contractors;

+------------------+-----------------+----------------+---------------+----------+
| CONTRACTOR_FIRST | CONTRACTOR_LAST | WORKNUM        | CITY          | ZIP_CODE |
|------------------+-----------------+----------------+---------------+----------|
| Bradley          | Greenbloom      | 1-650-445-0676 | San Francisco | 94110    |
| Cole             | Simpson         | 1-212-285-8904 | New York      | 10001    |
| Laurel           | Slater          | 1-650-633-4495 | San Francisco | 94115    |
+------------------+-----------------+----------------+---------------+----------+

INSERT INTO employees(first_name, last_name, workphone, city,postal_code)
  SELECT
    contractor_first,contractor_last,worknum,NULL,zip_code
  FROM contractors
  WHERE CONTAINS(worknum,'650');

SELECT * FROM employees;

+------------+------------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME  | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+------------+----------------+---------------+-------------|
| May        | Franklin   | 1-650-249-5198 | San Francisco | 94115       |
| Gillian    | Patterson  | 1-650-859-3954 | San Francisco | 94115       |
| Lysandra   | Reeves     | 1-212-759-3751 | New York      | 10018       |
| Michael    | Arnett     | 1-650-230-8467 | San Francisco | 94116       |
| Bradley    | Greenbloom | 1-650-445-0676 | NULL          | 94110       |
| Laurel     | Slater     | 1-650-633-4495 | NULL          | 94115       |
+------------+------------+----------------+---------------+-------------+

-- Example 8962
INSERT INTO employees (first_name,last_name,workphone,city,postal_code)
  WITH cte AS
    (SELECT contractor_first AS first_name,contractor_last AS last_name,worknum AS workphone,city,zip_code AS postal_code
     FROM contractors)
  SELECT first_name,last_name,workphone,city,postal_code
  FROM cte;

-- Example 8963
INSERT INTO emp (id,first_name,last_name,city,postal_code,ph)
  SELECT a.id,a.first_name,a.last_name,a.city,a.postal_code,b.ph
  FROM emp_addr a
  INNER JOIN emp_ph b ON a.id = b.id;

-- Example 8964
INSERT INTO prospects
  SELECT PARSE_JSON(column1)
  FROM VALUES
  ('{
    "_id": "57a37f7d9e2b478c2d8a608b",
    "name": {
      "first": "Lydia",
      "last": "Williamson"
    },
    "company": "Miralinz",
    "email": "lydia.williamson@miralinz.info",
    "phone": "+1 (914) 486-2525",
    "address": "268 Havens Place, Dunbar, Rhode Island, 7725"
  }')
  , ('{
    "_id": "57a37f7d622a2b1f90698c01",
    "name": {
      "first": "Denise",
      "last": "Holloway"
    },
    "company": "DIGIGEN",
    "email": "denise.holloway@digigen.net",
    "phone": "+1 (979) 587-3021",
    "address": "441 Dover Street, Ada, New Mexico, 5922"
  }');

-- Example 8965
SELECT * FROM employees;
+------------+-----------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+-----------+----------------+---------------+-------------|
| May        | Franklin  | 1-650-111-1111 | San Francisco | 94115       |
| Gillian    | Patterson | 1-650-222-2222 | San Francisco | 94115       |
| Lysandra   | Reeves    | 1-212-222-2222 | New York      | 10018       |
| Michael    | Arnett    | 1-650-333-3333 | San Francisco | 94116       |
+------------+-----------+----------------+---------------+-------------+
SELECT * FROM sf_employees;
+------------+-----------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+-----------+----------------+---------------+-------------|
| Martin     | Short     | 1-650-999-9999 | San Francisco | 94115       |
+------------+-----------+----------------+---------------+-------------+

-- Example 8966
INSERT OVERWRITE INTO sf_employees
  SELECT * FROM employees
  WHERE city = 'San Francisco';

-- Example 8967
SELECT * FROM sf_employees;
+------------+-----------+----------------+---------------+-------------+
| FIRST_NAME | LAST_NAME | WORKPHONE      | CITY          | POSTAL_CODE |
|------------+-----------+----------------+---------------+-------------|
| May        | Franklin  | 1-650-111-1111 | San Francisco | 94115       |
| Gillian    | Patterson | 1-650-222-2222 | San Francisco | 94115       |
| Michael    | Arnett    | 1-650-333-3333 | San Francisco | 94116       |
+------------+-----------+----------------+---------------+-------------+

-- Example 8968
UPDATE <target_table>
       SET <col_name> = <value> [ , <col_name> = <value> , ... ]
        [ FROM <additional_tables> ]
        [ WHERE <condition> ]

-- Example 8969
ALTER SESSION SET ERROR_ON_NONDETERMINISTIC_UPDATE=TRUE;

-- Example 8970
UPDATE t1
  SET number_column = t1.number_column + t2.number_column, t1.text_column = 'ASDF'
  FROM t2
  WHERE t1.key_column = t2.t1_key and t1.number_column < 10;

-- Example 8971
select * from target;

+---+----+
| K |  V |
|---+----|
| 0 | 10 |
+---+----+

Select * from src;

+---+----+
| K |  V |
|---+----|
| 0 | 11 |
| 0 | 12 |
| 0 | 13 |
+---+----+

-- Following statement joins all three rows in src against the single row in target
UPDATE target
  SET v = src.v
  FROM src
  WHERE target.k = src.k;

+------------------------+-------------------------------------+
| number of rows updated | number of multi-joined rows updated |
|------------------------+-------------------------------------|
|                      1 |                                   1 |
+------------------------+-------------------------------------+

-- Example 8972
UPDATE target SET v = b.v
  FROM (SELECT k, MIN(v) v FROM src GROUP BY k) b
  WHERE target.k = b.k;

-- Example 8973
MERGE INTO <target_table> USING <source> ON <join_expr> { matchedClause | notMatchedClause } [ ... ]

-- Example 8974
matchedClause ::=
  WHEN MATCHED [ AND <case_predicate> ] THEN { UPDATE SET <col_name> = <expr> [ , <col_name2> = <expr2> ... ] | DELETE } [ ... ]

-- Example 8975
notMatchedClause ::=
   WHEN NOT MATCHED [ AND <case_predicate> ] THEN INSERT [ ( <col_name> [ , ... ] ) ] VALUES ( <expr> [ , ... ] )

-- Example 8976
MERGE INTO target USING (select k, max(v) as v from src group by k) AS b ON target.k = b.k
  WHEN MATCHED THEN UPDATE SET target.v = b.v
  WHEN NOT MATCHED THEN INSERT (k, v) VALUES (b.k, b.v);

-- Example 8977
CREATE TABLE target_table (ID INTEGER, description VARCHAR);

CREATE TABLE source_table (ID INTEGER, description VARCHAR);

-- Example 8978
INSERT INTO target_table (ID, description) VALUES
    (10, 'To be updated (this is the old value)')
    ;

INSERT INTO source_table (ID, description) VALUES
    (10, 'To be updated (this is the new value)')
    ;

-- Example 8979
MERGE INTO target_table USING source_table 
    ON target_table.id = source_table.id
    WHEN MATCHED THEN 
        UPDATE SET target_table.description = source_table.description;
+------------------------+
| number of rows updated |
|------------------------|
|                      1 |
+------------------------+

-- Example 8980
SELECT * FROM target_table;
+----+---------------------------------------+
| ID | DESCRIPTION                           |
|----+---------------------------------------|
| 10 | To be updated (this is the new value) |
+----+---------------------------------------+
SELECT * FROM source_table;
+----+---------------------------------------+
| ID | DESCRIPTION                           |
|----+---------------------------------------|
| 10 | To be updated (this is the new value) |
+----+---------------------------------------+

-- Example 8981
MERGE INTO t1 USING t2 ON t1.t1Key = t2.t2Key
    WHEN MATCHED AND t2.marked = 1 THEN DELETE
    WHEN MATCHED AND t2.isNewStatus = 1 THEN UPDATE SET val = t2.newVal, status = t2.newStatus
    WHEN MATCHED THEN UPDATE SET val = t2.newVal
    WHEN NOT MATCHED THEN INSERT (val, status) VALUES (t2.newVal, t2.newStatus);

-- Example 8982
TRUNCATE TABLE source_table;

TRUNCATE TABLE target_table;

INSERT INTO source_table (ID, description) VALUES
    (50, 'This is a duplicate in the source and has no match in target'),
    (50, 'This is a duplicate in the source and has no match in target')
    ;

-- Example 8983
MERGE INTO target_table USING source_table 
    ON target_table.id = source_table.id
    WHEN MATCHED THEN 
        UPDATE SET target_table.description = source_table.description
    WHEN NOT MATCHED THEN 
        INSERT (ID, description) VALUES (source_table.id, source_table.description);
+-------------------------+------------------------+
| number of rows inserted | number of rows updated |
|-------------------------+------------------------|
|                       2 |                      0 |
+-------------------------+------------------------+

-- Example 8984
SELECT ID FROM target_table;
+----+
| ID |
|----|
| 50 |
| 50 |
+----+

-- Example 8985
-- Setup for example.
CREATE TABLE target_orig (k NUMBER, v NUMBER);
INSERT INTO target_orig VALUES (0, 10);

CREATE TABLE src (k NUMBER, v NUMBER);
INSERT INTO src VALUES (0, 11), (0, 12), (0, 13);

-- Multiple updates conflict with each other.
-- If ERROR_ON_NONDETERMINISTIC_MERGE=true, returns an error;
-- otherwise updates target.v with a value (e.g. 11, 12, or 13) from one of the duplicate rows (row not defined).

CREATE OR REPLACE TABLE target CLONE target_orig;

MERGE INTO target
  USING src ON target.k = src.k
  WHEN MATCHED THEN UPDATE SET target.v = src.v;

-- Updates and deletes conflict with each other.
-- If ERROR_ON_NONDETERMINISTIC_MERGE=true, returns an error;
-- otherwise either deletes the row or updates target.v with a value (e.g. 12 or 13) from one of the duplicate rows (row not defined).

CREATE OR REPLACE TABLE target CLONE target_orig;

MERGE INTO target
  USING src ON target.k = src.k
  WHEN MATCHED AND src.v = 11 THEN DELETE
  WHEN MATCHED THEN UPDATE SET target.v = src.v;

-- Multiple deletes do not conflict with each other;
-- joined values that do not match any clause do not prevent the delete (src.v = 13).
-- Merge succeeds and the target row is deleted.

CREATE OR REPLACE TABLE target CLONE target_orig;

MERGE INTO target
  USING src ON target.k = src.k
  WHEN MATCHED AND src.v <= 12 THEN DELETE;

-- Joined values that do not match any clause do not prevent an update (src.v = 12, 13).
-- Merge succeeds and the target row is set to target.v = 11.

CREATE OR REPLACE TABLE target CLONE target_orig;

MERGE INTO target
  USING src ON target.k = src.k
  WHEN MATCHED AND src.v = 11 THEN UPDATE SET target.v = src.v;

-- Use GROUP BY in the source clause to ensure that each target row joins against one row
-- in the source:

CREATE OR REPLACE TABLE target CLONE target_orig;

MERGE INTO target USING (select k, max(v) as v from src group by k) AS b ON target.k = b.k
  WHEN MATCHED THEN UPDATE SET target.v = b.v
  WHEN NOT MATCHED THEN INSERT (k, v) VALUES (b.k, b.v);

-- Example 8986
MERGE INTO members m
  USING (
  SELECT id, date
  FROM signup
  WHERE DATEDIFF(day, CURRENT_DATE(), signup.date::DATE) < -30) s ON m.id = s.id
  WHEN MATCHED THEN UPDATE SET m.fee = 40;

-- Example 8987
DELETE FROM <table_name>
            [ USING <additional_table_or_query> [, <additional_table_or_query> ] ]
            [ WHERE <condition> ]

-- Example 8988
select * from tab1;

-------+-------+
   k   |   v   |
-------+-------+
   0   |   10  |
-------+-------+

Select * from tab2;

-------+-------+
   k   |   v   |
-------+-------+
   0   |   20  |
   0   |   30  |
-------+-------+

-- Example 8989
DELETE FROM tab1 USING tab2 WHERE tab1.k = tab2.k

-- Example 8990
CREATE TABLE leased_bicycles (bicycle_id INTEGER, customer_id INTEGER);
CREATE TABLE returned_bicycles (bicycle_id INTEGER);

-- Example 8991
INSERT INTO leased_bicycles (bicycle_ID, customer_ID) VALUES
    (101, 1111),
    (102, 2222),
    (103, 3333),
    (104, 4444),
    (105, 5555);
INSERT INTO returned_bicycles (bicycle_ID) VALUES
    (102),
    (104);

-- Example 8992
DELETE FROM leased_bicycles WHERE bicycle_ID = 105;
+------------------------+
| number of rows deleted |
|------------------------|
|                      1 |
+------------------------+

-- Example 8993
SELECT * FROM leased_bicycles ORDER BY bicycle_ID;
+------------+-------------+
| BICYCLE_ID | CUSTOMER_ID |
|------------+-------------|
|        101 |        1111 |
|        102 |        2222 |
|        103 |        3333 |
|        104 |        4444 |
+------------+-------------+

-- Example 8994
BEGIN WORK;
DELETE FROM leased_bicycles 
    USING returned_bicycles
    WHERE leased_bicycles.bicycle_ID = returned_bicycles.bicycle_ID;
TRUNCATE TABLE returned_bicycles;
COMMIT WORK;

-- Example 8995
SELECT * FROM leased_bicycles ORDER BY bicycle_ID;
+------------+-------------+
| BICYCLE_ID | CUSTOMER_ID |
|------------+-------------|
|        101 |        1111 |
|        103 |        3333 |
+------------+-------------+

-- Example 8996
INSERT INTO returned_bicycles (bicycle_ID) VALUES (103);

-- Example 8997
BEGIN WORK;
DELETE FROM leased_bicycles 
    USING (SELECT bicycle_ID AS bicycle_ID FROM returned_bicycles) AS returned
    WHERE leased_bicycles.bicycle_ID = returned.bicycle_ID;
TRUNCATE TABLE returned_bicycles;
COMMIT WORK;

-- Example 8998
SELECT * FROM leased_bicycles ORDER BY bicycle_ID;
+------------+-------------+
| BICYCLE_ID | CUSTOMER_ID |
|------------+-------------|
|        101 |        1111 |
+------------+-------------+

-- Example 8999
CREATE [ OR REPLACE ] { DATABASE | SCHEMA } [ IF NOT EXISTS ] <object_name>
  CLONE <source_object_name>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [ IGNORE TABLES WITH INSUFFICIENT DATA RETENTION ]
    [ IGNORE HYBRID TABLES ]
  ...

-- Example 9000
CREATE [ OR REPLACE ] TABLE [ IF NOT EXISTS ] <object_name>
  CLONE <source_object_name>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
  ...

-- Example 9001
CREATE [ OR REPLACE ] DYNAMIC TABLE <name>
  CLONE <source_dynamic_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
  [
    TARGET_LAG = { '<num> { seconds | minutes | hours | days }' | DOWNSTREAM }
    WAREHOUSE = <warehouse_name>
  ]

-- Example 9002
CREATE [ OR REPLACE ] EVENT TABLE <name>
  CLONE <source_event_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]

-- Example 9003
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <name>
  CLONE <source_iceberg_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [ COPY GRANTS ]
    ...

-- Example 9004
CREATE [ OR REPLACE ] DATABASE ROLE [ IF NOT EXISTS ] <database_role_name>
  CLONE <source_database_role_name>

-- Example 9005
CREATE [ OR REPLACE ] { ALERT | FILE FORMAT | SEQUENCE | STAGE | STREAM | TASK }
  [ IF NOT EXISTS ] <object_name>
  CLONE <source_object_name>
  ...

-- Example 9006
Error: statement <query_id> not found

-- Example 9007
CREATE SCHEMA S1;
USE SCHEMA S1;
CREATE TASK T1 AS SELECT 1;
CREATE SCHEMA S2 CLONE S1 AT(TIMESTAMP => '2025-04-01 12:00:00');
  -- T1 is not cloned into S2
CREATE SCHEMA S3 CLONE S1;
  -- T1 is cloned into S3

-- Example 9008
-- Create a schema to serve as the source for a cloned schema.
CREATE SCHEMA source;

-- Create a table.
CREATE TABLE mytable (col1 string, col2 string);

-- Create a view that references the table with a fully-qualified name.
CREATE VIEW myview AS SELECT col1 FROM source.mytable;

-- Retrieve the DDL for the source schema.
SELECT GET_DDL ('schema', 'source', true);

-- Example 9009
+--------------------------------------------------------------------------+
| GET_DDL('SCHEMA', 'SOURCE', TRUE)                                        |
|--------------------------------------------------------------------------|
| create or replace schema MPETERS_DB.SOURCE;                              |
|                                                                          |
| create or replace TABLE MPETERS_DB.SOURCE.MYTABLE (                      |
|   COL1 VARCHAR(16777216),                                                |
|   COL2 VARCHAR(16777216)                                                 |
| );                                                                       |
|                                                                          |
| create view MPETERS_DB.SOURCE.MYVIEW as select col1 from SOURCE.MYTABLE; |
|                                                                          |
+--------------------------------------------------------------------------+

-- Example 9010
-- Clone the source schema.
CREATE SCHEMA source_clone CLONE source;

-- Retrieve the DDL for the clone of the source schema.
-- The clone of the view references the source table with the same fully-qualified name
-- as in the view in the source schema.
SELECT GET_DDL ('schema', 'source_clone', true);

-- Example 9011
+--------------------------------------------------------------------------------+
| GET_DDL('SCHEMA', 'SOURCE_CLONE', TRUE)                                        |
|--------------------------------------------------------------------------------|
| create or replace schema MPETERS_DB.SOURCE_CLONE;                              |
|                                                                                |
| create or replace TABLE MPETERS_DB.SOURCE_CLONE.MYTABLE (                      |
|   COL1 VARCHAR(16777216),                                                      |
|   COL2 VARCHAR(16777216)                                                       |
| );                                                                             |
|                                                                                |
| create view MPETERS_DB.SOURCE_CLONE.MYVIEW as select col1 from SOURCE.MYTABLE; |
|                                                                                |
+--------------------------------------------------------------------------------+

-- Example 9012
000707 (02000): Time travel data is not available for <object_type>
<object_name>. The requested time is either beyond the allowed time
travel period or before the object creation time.

-- Example 9013
... AT(TIMESTAMP => '2023-12-31 12:00:00')               -- fails
... AT(TIMESTAMP => '2023-12-31 12:00:00'::TIMESTAMP)    -- succeeds

-- Example 9014
CREATE DATABASE mytestdb_clone CLONE mytestdb;

-- Example 9015
CREATE SCHEMA mytestschema_clone CLONE testschema;

-- Example 9016
CREATE TABLE orders_clone CLONE orders;

-- Example 9017
CREATE SCHEMA mytestschema_clone_restore CLONE testschema
  BEFORE (TIMESTAMP => TO_TIMESTAMP(40*365*86400));

-- Example 9018
CREATE TABLE orders_clone_restore CLONE orders
  AT (TIMESTAMP => TO_TIMESTAMP_TZ('04/05/2013 01:02:03', 'mm/dd/yyyy hh24:mi:ss'));

-- Example 9019
CREATE TABLE orders_clone_restore CLONE orders BEFORE (STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 9020
CREATE DATABASE restored_db CLONE my_db
  AT (TIMESTAMP => DATEADD(days, -4, current_timestamp)::timestamp_tz)
  IGNORE TABLES WITH INSUFFICIENT DATA RETENTION;

-- Example 9021
CREATE OR REPLACE SCHEMA clone_ht_schema CLONE ht_schema
  IGNORE HYBRID TABLES;

-- Example 9022
TRUNCATE [ TABLE ] [ IF EXISTS ] <name>

-- Example 9023
-- create a basic table
CREATE OR REPLACE TABLE temp (i number);

-- populate it with some rows
INSERT INTO temp SELECT seq8() FROM table(generator(rowcount=>20)) v;

-- verify that the rows exist
SELECT COUNT (*) FROM temp;

----------+
 count(*) |
----------+
 20       |
----------+

-- truncate the table
TRUNCATE TABLE IF EXISTS temp;

-- verify that the table is now empty
SELECT COUNT (*) FROM temp;

----------+
 count(*) |
----------+
 0        |
----------+

-- Example 9024
DROP TABLE [ IF EXISTS ] <name> [ CASCADE | RESTRICT ]

-- Example 9025
SHOW TABLES LIKE 't2%';

+---------------------------------+------+---------------+-------------+-----------+------------+------------+------+-------+--------------+----------------+
| created_on                      | name | database_name | schema_name | kind      | comment    | cluster_by | rows | bytes | owner        | retention_time |
|---------------------------------+------+---------------+-------------+-----------+------------+------------+------+-------+--------------+----------------+
| Tue, 17 Mar 2015 16:48:16 -0700 | T2   | TESTDB        | PUBLIC      | TABLE     |            |            |    5 | 4096  | PUBLIC       |              1 |
+---------------------------------+------+---------------+-------------+-----------+------------+------------+------+-------+--------------+----------------+

DROP TABLE t2;

+--------------------------+
| status                   |
|--------------------------|
| T2 successfully dropped. |
+--------------------------+

SHOW TABLES LIKE 't2%';

+------------+------+---------------+-------------+------+---------+------------+------+-------+-------+----------------+
| created_on | name | database_name | schema_name | kind | comment | cluster_by | rows | bytes | owner | retention_time |
|------------+------+---------------+-------------+------+---------+------------+------+-------+-------+----------------|
+------------+------+---------------+-------------+------+---------+------------+------+-------+-------+----------------+

