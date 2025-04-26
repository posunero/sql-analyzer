-- Example 11236
ALTER TASK mytask MODIFY AS SELECT CURRENT_VERSION();

-- Example 11237
ALTER TASK mytask MODIFY WHEN SYSTEM$STREAM_HAS_DATA('MYSTREAM');

-- Example 11238
ALTER TASK task_with_config SET
      CONFIG=$${"output_directory": "/temp/prod_directory/", "environment": "prod"}$$;

-- Example 11239
ALTER TASK task_with_config UNSET CONFIG;

-- Example 11240
ALTER ALERT [ IF EXISTS ] <name> { RESUME | SUSPEND };

ALTER ALERT [ IF EXISTS ] <name> SET
  [ WAREHOUSE = <string> ]
  [ SCHEDULE = '{ <number> MINUTE | USING CRON <expr> <time_zone> }' ]
  [ COMMENT = '<string_literal>' ]

ALTER ALERT [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER ALERT [ IF EXISTS ] <name> UNSET
  [ WAREHOUSE ]
  [ COMMENT ]

ALTER ALERT <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER ALERT [ IF EXISTS ] <name> MODIFY CONDITION EXISTS (<condition>)

ALTER ALERT [ IF EXISTS ] <name> MODIFY ACTION <action>

-- Example 11241
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 11242
SELECT ...
FROM ...
  {
   AT( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } ) |
   BEFORE( STATEMENT => <id> )
  }
[ ... ]

-- Example 11243
Error: statement <query_id> not found

-- Example 11244
AT ( TIMESTAMP => '2024-06-05 12:30:00'::TIMESTAMP_LTZ )

AT ( TIMESTAMP => '2024-06-05 12:30:00'::TIMESTAMP )

AT ( TIMESTAMP => '2024-06-05 12:30:00' )

-- Example 11245
CREATE OR REPLACE TABLE tt1 (c1 INT, c2 INT);
INSERT INTO tt1 VALUES(1,2);
INSERT INTO tt1 VALUES(2,3);

-- Example 11246
SHOW TERSE TABLES LIKE 'tt1';

-- Example 11247
+-------------------------------+------+-------+---------------+----------------+
| created_on                    | name | kind  | database_name | schema_name    |
|-------------------------------+------+-------+---------------+----------------|
| 2024-06-05 15:25:35.557 -0700 | TT1  | TABLE | TRAVEL_DB     | TRAVEL_SCHEMA  |
+-------------------------------+------+-------+---------------+----------------+

-- Example 11248
INSERT INTO tt1 VALUES(3,4);

-- Example 11249
SELECT * FROM tt1 at(TIMESTAMP => '2024-06-05 15:29:00'::TIMESTAMP);

-- Example 11250
000707 (02000): Time travel data is not available for table TT1. The requested time is either beyond the allowed time travel period or before the object creation time.

-- Example 11251
SELECT * FROM tt1 at(TIMESTAMP => '2024-06-05 15:29:00'::TIMESTAMP_LTZ);

-- Example 11252
+----+----+
| C1 | C2 |
|----+----|
|  1 |  2 |
|  2 |  3 |
+----+----+

-- Example 11253
SELECT * FROM tt1 at(TIMESTAMP => '2024-06-05 15:31:00'::TIMESTAMP_LTZ);

-- Example 11254
+----+----+
| C1 | C2 |
|----+----|
|  1 |  2 |
|  2 |  3 |
|  3 |  4 |
+----+----+

-- Example 11255
WITH mycte AS
  (SELECT mytable.* FROM mytable)
SELECT * FROM mycte AT(TIMESTAMP => '2024-03-13 13:56:09.553 +0100'::TIMESTAMP_TZ);

-- Example 11256
WITH mycte AS
  (SELECT * FROM mytable AT(TIMESTAMP => '2024-03-13 13:56:09.553 +0100'::TIMESTAMP_TZ))
SELECT * FROM mycte;

-- Example 11257
Time travel data is not available for table <tablename>

-- Example 11258
... AT(TIMESTAMP => '2018-07-27 12:00:00')               -- fails
... AT(TIMESTAMP => '2018-07-27 12:00:00'::TIMESTAMP)    -- succeeds

-- Example 11259
SELECT * FROM my_table AT(TIMESTAMP => 'Wed, 26 Jun 2024 09:20:00 -0700'::TIMESTAMP_LTZ);

-- Example 11260
SELECT * FROM my_table AT(TIMESTAMP => TO_TIMESTAMP(1432669154242, 3));

-- Example 11261
SELECT * FROM my_table AT(OFFSET => -60*5) AS T WHERE T.flag = 'valid';

-- Example 11262
SELECT * FROM my_table BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 11263
SELECT oldt.* ,newt.*
  FROM my_table BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726') AS oldt
    FULL OUTER JOIN my_table AT(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726') AS newt
    ON oldt.id = newt.id
  WHERE oldt.id IS NULL OR newt.id IS NULL;

-- Example 11264
SELECT *
  FROM db1.public.htt1
    AT(TIMESTAMP => '2024-06-05 17:50:00'::TIMESTAMP_LTZ) h
    JOIN db1.public.tt1
    AT(TIMESTAMP => '2024-06-05 17:50:00'::TIMESTAMP_LTZ) t
    ON h.c1=t.c1;

-- Example 11265
CREATE [ OR REPLACE ] { DATABASE | SCHEMA } [ IF NOT EXISTS ] <object_name>
  CLONE <source_object_name>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [ IGNORE TABLES WITH INSUFFICIENT DATA RETENTION ]
    [ IGNORE HYBRID TABLES ]
  ...

-- Example 11266
CREATE [ OR REPLACE ] TABLE [ IF NOT EXISTS ] <object_name>
  CLONE <source_object_name>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
  ...

-- Example 11267
CREATE [ OR REPLACE ] DYNAMIC TABLE <name>
  CLONE <source_dynamic_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
  [
    TARGET_LAG = { '<num> { seconds | minutes | hours | days }' | DOWNSTREAM }
    WAREHOUSE = <warehouse_name>
  ]

-- Example 11268
CREATE [ OR REPLACE ] EVENT TABLE <name>
  CLONE <source_event_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]

-- Example 11269
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <name>
  CLONE <source_iceberg_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [ COPY GRANTS ]
    ...

-- Example 11270
CREATE [ OR REPLACE ] DATABASE ROLE [ IF NOT EXISTS ] <database_role_name>
  CLONE <source_database_role_name>

-- Example 11271
CREATE [ OR REPLACE ] { ALERT | FILE FORMAT | SEQUENCE | STAGE | STREAM | TASK }
  [ IF NOT EXISTS ] <object_name>
  CLONE <source_object_name>
  ...

-- Example 11272
Error: statement <query_id> not found

-- Example 11273
CREATE SCHEMA S1;
USE SCHEMA S1;
CREATE TASK T1 AS SELECT 1;
CREATE SCHEMA S2 CLONE S1 AT(TIMESTAMP => '2025-04-01 12:00:00');
  -- T1 is not cloned into S2
CREATE SCHEMA S3 CLONE S1;
  -- T1 is cloned into S3

-- Example 11274
-- Create a schema to serve as the source for a cloned schema.
CREATE SCHEMA source;

-- Create a table.
CREATE TABLE mytable (col1 string, col2 string);

-- Create a view that references the table with a fully-qualified name.
CREATE VIEW myview AS SELECT col1 FROM source.mytable;

-- Retrieve the DDL for the source schema.
SELECT GET_DDL ('schema', 'source', true);

-- Example 11275
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

-- Example 11276
-- Clone the source schema.
CREATE SCHEMA source_clone CLONE source;

-- Retrieve the DDL for the clone of the source schema.
-- The clone of the view references the source table with the same fully-qualified name
-- as in the view in the source schema.
SELECT GET_DDL ('schema', 'source_clone', true);

-- Example 11277
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

-- Example 11278
000707 (02000): Time travel data is not available for <object_type>
<object_name>. The requested time is either beyond the allowed time
travel period or before the object creation time.

-- Example 11279
... AT(TIMESTAMP => '2023-12-31 12:00:00')               -- fails
... AT(TIMESTAMP => '2023-12-31 12:00:00'::TIMESTAMP)    -- succeeds

-- Example 11280
CREATE DATABASE mytestdb_clone CLONE mytestdb;

-- Example 11281
CREATE SCHEMA mytestschema_clone CLONE testschema;

-- Example 11282
CREATE TABLE orders_clone CLONE orders;

-- Example 11283
CREATE SCHEMA mytestschema_clone_restore CLONE testschema
  BEFORE (TIMESTAMP => TO_TIMESTAMP(40*365*86400));

-- Example 11284
CREATE TABLE orders_clone_restore CLONE orders
  AT (TIMESTAMP => TO_TIMESTAMP_TZ('04/05/2013 01:02:03', 'mm/dd/yyyy hh24:mi:ss'));

-- Example 11285
CREATE TABLE orders_clone_restore CLONE orders BEFORE (STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 11286
CREATE DATABASE restored_db CLONE my_db
  AT (TIMESTAMP => DATEADD(days, -4, current_timestamp)::timestamp_tz)
  IGNORE TABLES WITH INSUFFICIENT DATA RETENTION;

-- Example 11287
CREATE OR REPLACE SCHEMA clone_ht_schema CLONE ht_schema
  IGNORE HYBRID TABLES;

-- Example 11288
Dangling references in the snapshot. Correct the errors before refreshing again.
The following references are missing (referred entity <- [referring entities])

-- Example 11289
003131 (55000): Dangling references in the snapshot. Correct the errors before refreshing again.
The following references are missing (referred entity <- [referring entities]):
POLICY '<policy_db>.<policy_schema>.<packages_policy_name>' <- [ACCOUNT '<account_locator>']

-- Example 11290
Primary database: the source object ''<object_name>'' for this stream ''<stream_name>'' is not included in the replication group.
Stream replication does not support replication across databases in different replication groups. Please see Streams Documentation
https://docs.snowflake.com/en/user-guide/account-replication-considerations#replication-and-streams for options.

-- Example 11291
CREATE REPLICATION GROUP myrg
  OBJECT_TYPES = DATABASES, ROLES, USERS
  ALLOWED_DATABASES = session_policy_db
  ALLOWED_ACCOUNTS = myorg.myaccount
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 11292
CREATE REPLICATION GROUP myrg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1, db2
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 11293
CREATE DATABASE clone_db1 CLONE db1;

-- Example 11294
CREATE HYBRID TABLE clone_ht1 CLONE ht1;

-- Example 11295
391411 (0A000): This feature is not supported for hybrid tables: 'CLONE'.

-- Example 11296
CREATE OR REPLACE SCHEMA clone_ht_schema CLONE ht_schema IGNORE HYBRID TABLES;

-- Example 11297
+----------------------------------------------+
| status                                       |
|----------------------------------------------|
| Schema CLONE_HT_SCHEMA successfully created. |
+----------------------------------------------+

-- Example 11298
SHOW TERSE TABLES;

-- Example 11299
+-------------------------------+------+-------+---------------+-------------+
| created_on                    | name | kind  | database_name | schema_name |
|-------------------------------+------+-------+---------------+-------------|
| 2024-11-14 15:59:32.683 -0800 | HT1  | TABLE | TESTDB        | TESTDATA    |
| 2024-11-14 16:00:01.360 -0800 | ST1  | TABLE | TESTDB        | TESTDATA    |
+-------------------------------+------+-------+---------------+-------------+

-- Example 11300
CREATE OR REPLACE DATABASE clone_testdb
  CLONE testdb AT(TIMESTAMP => '2024-11-14 16:01:00'::TIMESTAMP_LTZ);

-- Example 11301
+---------------------------------------------+
| status                                      |
|---------------------------------------------|
| Database CLONE_TESTDB successfully created. |
+---------------------------------------------+

-- Example 11302
USE DATABASE clone_testdb;
USE SCHEMA testdata;

