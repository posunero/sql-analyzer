-- Example 2789
begin transaction;
insert into tracker_1 values (00, 'outer_alpha');
call sp1_outer('begin transaction', 'begin transaction', 'rollback', 'commit');
insert into tracker_1 values (09, 'outer_charlie');
rollback;

-- Example 2790
-- Should return only 12, 21, 23.
select id, name from tracker_1
union all
select id, name from tracker_2
union all
select id, name from tracker_3
order by id;
+----+------------+
| ID | NAME       |
|----+------------|
| 12 | p1_bravo   |
| 21 | p2_alpha   |
| 23 | p2_charlie |
+----+------------+

-- Example 2791
begin transaction;
insert into tracker_1 values (00, 'outer_alpha');
call sp1_outer('begin transaction', 'begin transaction', 'commit', 'rollback');
insert into tracker_1 values (09, 'outer_charlie');
commit;

-- Example 2792
select id, name from tracker_1
union all
select id, name from tracker_2
union all
select id, name from tracker_3
order by id;
+----+---------------+
| ID | NAME          |
|----+---------------|
|  0 | outer_alpha   |
|  9 | outer_charlie |
| 11 | p1_alpha      |
| 13 | p1_charlie    |
| 22 | p2_bravo      |
+----+---------------+

-- Example 2793
begin transaction;

create table parent(id integer);
create table child (child_id integer, parent_ID integer);

-- ----------------------------------------------------- --
-- Wrap multiple related statements in a transaction,
-- and use try/catch to commit or roll back.
-- ----------------------------------------------------- --
-- Create the procedure
create or replace procedure cleanup(FORCE_FAILURE varchar)
  returns varchar not null
  language javascript
  as
  $$
  var result = "";
  snowflake.execute( {sqlText: "begin transaction;"} );
  try {
      snowflake.execute( {sqlText: "delete from child where parent_id = 1;"} );
      snowflake.execute( {sqlText: "delete from parent where id = 1;"} );
      if (FORCE_FAILURE === "fail")  {
          // To see what happens if there is a failure/rollback,
          snowflake.execute( {sqlText: "delete from no_such_table;"} );
          }
      snowflake.execute( {sqlText: "commit;"} );
      result = "Succeeded";
      }
  catch (err)  {
      snowflake.execute( {sqlText: "rollback;"} );
      return "Failed: " + err;   // Return a success/error indicator.
      }
  return result;
  $$
  ;

commit;

-- Example 2794
call cleanup('fail');
+----------------------------------------------------------+
| CLEANUP                                                  |
|----------------------------------------------------------|
| Failed: SQL compilation error:                           |
| Object 'NO_SUCH_TABLE' does not exist or not authorized. |
+----------------------------------------------------------+

-- Example 2795
call cleanup('do not fail');
+-----------+
| CLEANUP   |
|-----------|
| Succeeded |
+-----------+

-- Example 2796
TABLE( { <string_literal> | <session_variable> | <bind_variable> } )

-- Example 2797
SELECT * FROM TABLE('mytable');

SELECT * FROM TABLE($$mytable$$);

-- Example 2798
SELECT * FROM TABLE('mydb."myschema"."mytable"');

SELECT * FROM TABLE($$mydb."myschema"."mytable"$$);

-- Example 2799
SET myvar = 'mytable';

SELECT * FROM TABLE($myvar);

-- Example 2800
SELECT * FROM TABLE(?);

SELECT * FROM TABLE(:binding);

-- Example 2801
SELECT table_name, comment FROM testdb.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' ... ;

SELECT event_timestamp, user_name FROM TABLE(testdb.INFORMATION_SCHEMA.LOGIN_HISTORY( ... ));

-- Example 2802
USE DATABASE testdb;

SELECT table_name, comment FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' ... ;

SELECT event_timestamp, user_name FROM TABLE(INFORMATION_SCHEMA.LOGIN_HISTORY( ... ));

-- Example 2803
USE SCHEMA testdb.INFORMATION_SCHEMA;

SELECT table_name, comment FROM TABLES WHERE TABLE_SCHEMA = 'PUBLIC' ... ;

SELECT event_timestamp, user_name FROM TABLE(LOGIN_HISTORY( ... ));

-- Example 2804
BEGIN [ WORK ]

-- Example 2805
BEGIN;
BEGIN WORK;

-- Example 2806
BEGIN [ { WORK | TRANSACTION } ]

-- Example 2807
BEGIN;
BEGIN WORK;
BEGIN TRANSACTION;

-- Example 2808
create function <function_name>( <argument_name> <data_type> )

-- Example 2809
create function my_function(my_argument integer)

-- Example 2810
<function_name>( <argument_name> <data_type> [ , <argument_name> data_type ] ... )

-- Example 2811
my_function(argument_1 integer)
my_function(argument_1 integer, argument_2 integer)
my_function(argument_1 integer, argument_2 integer, argument_3 varchar)

-- Example 2812
CREATE TABLE "quote""andunquote""" ...

-- Example 2813
quote"andunquote"

-- Example 2814
myidentifier
MyIdentifier1
My$identifier
_my_identifier

-- Example 2815
CREATE TABLE mytable(c1 INT, c2 INT);

-- Example 2816
+-------------------------------------+
| status                              |
|-------------------------------------|
| Table MYTABLE successfully created. |
+-------------------------------------+

-- Example 2817
CREATE TABLE "MYTABLE"(c1 INT, c2 INT);

-- Example 2818
002002 (42710): SQL compilation error:
Object 'MYTABLE' already exists.

-- Example 2819
"MyIdentifier"
"my.identifier"
"my identifier"
"My 'Identifier'"
"3rd_identifier"
"$Identifier"
"идентификатор"

-- Example 2820
"My.DB"."My.Schema"."Table.1"

-- Example 2821
TABLENAME
tablename
tableName
TableName

-- Example 2822
"TABLENAME"
"tablename"
"tableName"
"TableName"

-- Example 2823
TABLENAME
tablename
tableName
TableName
"TABLENAME"
"tablename"
"tableName"
"TableName"

-- Example 2824
-- Set the default behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = false;

-- Create a table with a double-quoted identifier
CREATE TABLE "One" (i int);  -- stored as "One"

-- Create a table with an unquoted identifier
CREATE TABLE TWO(j int);     -- stored as "TWO"

-- These queries work
SELECT * FROM "One";         -- searches for "One"
SELECT * FROM two;           -- searched for "TWO"
SELECT * FROM "TWO";         -- searches for "TWO"

-- These queries do not work
SELECT * FROM One;           -- searches for "ONE"
SELECT * FROM "Two";         -- searches for "Two"

-- Change to the all-uppercase behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = true;

-- Create another table with a double-quoted identifier
CREATE TABLE "Three"(k int); -- stored as "THREE"

-- These queries work
SELECT * FROM "Two";         -- searches for "TWO"
SELECT * FROM two;           -- searched for "TWO"
SELECT * FROM "TWO";         -- searches for "TWO"
SELECT * FROM "Three";       -- searches for "THREE"
SELECT * FROM three;         -- searches for "THREE"

-- This query does not work now - "One" is not retrievable
SELECT * FROM "One";         -- searches for "ONE"

-- Example 2825
-- Set the default behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = false;

-- Create a table with a double-quoted identifier
CREATE TABLE "Tab" (i int);  -- stored as "Tab"

-- Create a table with an unquoted identifier
CREATE TABLE TAB(j int);     -- stored as "TAB"

-- This query retrieves "Tab"
SELECT * FROM "Tab";         -- searches for "Tab"

-- Change to the all-uppercase behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = true;

-- This query retrieves "TAB"
SELECT * FROM "Tab";         -- searches for "TAB"

-- Example 2826
IDENTIFIER( { string_literal | session_variable | bind_variable | snowflake_scripting_variable } )

-- Example 2827
CREATE OR REPLACE DATABASE IDENTIFIER('my_db');

-- Example 2828
+--------------------------------------+
| status                               |
|--------------------------------------|
| Database MY_DB successfully created. |
+--------------------------------------+

-- Example 2829
CREATE OR REPLACE SCHEMA IDENTIFIER('my_schema');

-- Example 2830
+----------------------------------------+
| status                                 |
|----------------------------------------|
| Schema MY_SCHEMA successfully created. |
+----------------------------------------+

-- Example 2831
CREATE OR REPLACE TABLE IDENTIFIER('my_db.my_schema.my_table') (c1 number);

-- Example 2832
+--------------------------------------+
| status                               |
|--------------------------------------|
| Table MY_TABLE successfully created. |
+--------------------------------------+

-- Example 2833
CREATE OR REPLACE TABLE IDENTIFIER('"my_table"') (c1 number);

-- Example 2834
+--------------------------------------+
| status                               |
|--------------------------------------|
| Table my_table successfully created. |
+--------------------------------------+

-- Example 2835
SHOW TABLES IN SCHEMA IDENTIFIER('my_schema');

-- Example 2836
+-------------------------------+----------+---------------+-------------+-------+---------+---------+
| created_on                    | name     | database_name | schema_name | kind  | comment | ...     |
|-------------------------------+----------+---------------+-------------+-------+---------+---------|
| 2024-07-03 08:55:11.992 -0700 | MY_TABLE | MY_DB         | MY_SCHEMA   | TABLE |         | ...     |
| 2024-07-03 08:56:00.604 -0700 | my_table | MY_DB         | MY_SCHEMA   | TABLE |         | ...     |
+-------------------------------+----------+---------------+-------------+-------+---------+---------+

-- Example 2837
SET schema_name = 'my_db.my_schema';

-- Example 2838
SET table_name = 'my_table';

-- Example 2839
USE SCHEMA IDENTIFIER($schema_name);

-- Example 2840
INSERT INTO IDENTIFIER($table_name) VALUES (1), (2), (3);

-- Example 2841
SELECT * FROM IDENTIFIER($table_name) ORDER BY 1;

-- Example 2842
+----+
| C1 |
|----|
|  1 |
|  2 |
|  3 |
+----+

-- Example 2843
CREATE FUNCTION speed_of_light() 
RETURNS INTEGER
AS
  $$
  299792458
  $$;

-- Example 2844
SELECT speed_of_light();

-- Example 2845
+------------------+
| SPEED_OF_LIGHT() |
|------------------|
|        299792458 |
+------------------+

-- Example 2846
SET my_function_name = 'speed_of_light';

-- Example 2847
SELECT IDENTIFIER($my_function_name)();

-- Example 2848
+---------------------------------+
| IDENTIFIER($MY_FUNCTION_NAME)() |
|---------------------------------|
|                       299792458 |
+---------------------------------+

-- Example 2849
String sql_command;

// Create a Statement object to use later.
System.out.println("Create JDBC statement.");
Statement statement = connection.createStatement();
System.out.println("Create function.");
sql_command = "CREATE FUNCTION speed_of_light() RETURNS INTEGER AS $$ 299792458 $$";
statement.execute(sql_command);

System.out.println("Create prepared statement.");
sql_command = "SELECT IDENTIFIER(?)()";
PreparedStatement ps = connection.prepareStatement(sql_command);
// Bind
ps.setString(1, "speed_of_light");
ResultSet rs = ps.executeQuery();
if (rs.next()) {
  System.out.println("Speed of light (m/s) = " + rs.getInt(1));
}

-- Example 2850
USE SCHEMA IDENTIFIER(?);

CREATE OR REPLACE TABLE IDENTIFIER(?) (c1 NUMBER);

INSERT INTO IDENTIFIER(?) values (?), (?), (?);

SELECT t2.c1
  FROM IDENTIFIER(?) AS t1,
       IDENTIFIER(?) AS t2
  WHERE t1.c1 = t2.c1 AND t1.c1 > (?);

DROP TABLE IDENTIFIER(?);

-- Example 2851
BEGIN
  LET res RESULTSET := (SELECT COUNT(*) AS COUNT FROM IDENTIFIER(:table_name));
  ...

-- Example 2852
SELECT CURRENT_DATABASE();

--------------------+
 CURRENT_DATABASE() |
--------------------+
 TESTDB             |
--------------------+

CREATE DATABASE db1;

------------------------------------+
               status               |
------------------------------------+
 Database DB1 successfully created. |
------------------------------------+

SELECT CURRENT_DATABASE();

--------------------+
 CURRENT_DATABASE() |
--------------------+
 DB1                |
--------------------+

USE DATABASE testdb;

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SELECT current_database();

--------------------+
 CURRENT_DATABASE() |
--------------------+
 TESTDB             |
--------------------+

-- Example 2853
SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 TESTSCHEMA       |
------------------+

CREATE DATABASE db1;

------------------------------------+
               status               |
------------------------------------+
 Database DB1 successfully created. |
------------------------------------+

SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 PUBLIC           |
------------------+

CREATE SCHEMA sch1;

-----------------------------------+
              status               |
-----------------------------------+
 Schema SCH1 successfully created. |
-----------------------------------+

SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 SCH1             |
------------------+

USE SCHEMA public;

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 PUBLIC           |
------------------+

-- Example 2854
select current_schemas();

+-------------------+
| CURRENT_SCHEMAS() |
|-------------------|
| []                |
+-------------------+

use database mytestdb;

select current_schemas();

+---------------------+
| CURRENT_SCHEMAS()   |
|---------------------|
| ["MYTESTDB.PUBLIC"] |
+---------------------+

create schema private;

select current_schemas();

+-----------------------------------------+
| CURRENT_SCHEMAS()                       |
|-----------------------------------------|
| ["MYTESTDB.PRIVATE", "MYTESTDB.PUBLIC"] |
+-----------------------------------------+

-- Example 2855
SHOW PARAMETERS LIKE 'search_path';

-------------+--------------------+--------------------+------------------------------------------------+
     key     |           value    |          default   |                  description                   |
-------------+--------------------+--------------------+------------------------------------------------+
 SEARCH_PATH | $current, $public, | $current, $public, | Search path for unqualified object references. |
-------------+--------------------+--------------------+------------------------------------------------+

SELECT current_schemas();

---------------------------------------------------------------------------+
                       CURRENT_SCHEMAS()                                   |
---------------------------------------------------------------------------+
 [XY12345.TESTDB.TESTSCHEMA, XY12345.TESTDB.PUBLIC, SAMPLES.COMMON.PUBLIC] |
---------------------------------------------------------------------------+

CREATE DATABASE db1;

------------------------------------+
               status               |
------------------------------------+
 Database DB1 successfully created. |
------------------------------------+

USE SCHEMA public;

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SELECT current_schemas();

---------------------------------------------+
                CURRENT_SCHEMAS()            |
---------------------------------------------+
 [XY12345.DB1.PUBLIC, SAMPLES.COMMON.PUBLIC] |
---------------------------------------------+

ALTER SESSION SET search_path='$current, $public, testdb.public';

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SHOW PARAMETERS LIKE 'search_path';

-------------+----------------------------------+--------------------+------------------------------------------------+
     key     |              value               |          default   |                  description                   |
-------------+----------------------------------+--------------------+------------------------------------------------+
 SEARCH_PATH | $current, $public, testdb.public | $current, $public, | Search path for unqualified object references. |
-------------+----------------------------------+--------------------+------------------------------------------------+

SELECT current_schemas();

---------------------------------------------+
            CURRENT_SCHEMAS()                |
---------------------------------------------+
 [XY12345.DB1.PUBLIC, XY12345.TESTDB.PUBLIC] |
---------------------------------------------+

-- Example 2856
CREATE [ OR REPLACE ] TABLE <name> (<column_name> <column_type> [ <inline_constraint> ] , ... )

ALTER TABLE <name> ADD COLUMN <column_name> <column_type> [ <inline_constraint> ]

