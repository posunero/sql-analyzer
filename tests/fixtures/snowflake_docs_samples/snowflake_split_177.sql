-- Example 11839
CREATE OR REPLACE EXTERNAL TABLE ext_table
 INTEGRATION = 'MY_NOTIFICATION_INT'
 WITH LOCATION = @mystage/path1/
 FILE_FORMAT = (TYPE = JSON);

-- Example 11840
ALTER EXTERNAL TABLE ext_table REFRESH;

+---------------------------------------------+----------------+-------------------------------+
| file                                        | status         | description                   |
|---------------------------------------------+----------------+-------------------------------|
| files/path1/file1.json                      | REGISTERED_NEW | File registered successfully. |
| files/path1/file2.json                      | REGISTERED_NEW | File registered successfully. |
| files/path1/file3.json                      | REGISTERED_NEW | File registered successfully. |
+---------------------------------------------+----------------+-------------------------------+

-- Example 11841
-- table
CREATE [ OR REPLACE ] STREAM [IF NOT EXISTS]
  <name>
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COPY GRANTS ]
  ON TABLE <table_name>
  [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } ) ]
  [ APPEND_ONLY = TRUE | FALSE ]
  [ SHOW_INITIAL_ROWS = TRUE | FALSE ]
  [ COMMENT = '<string_literal>' ]

-- External table
CREATE [ OR REPLACE ] STREAM [IF NOT EXISTS]
  <name>
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COPY GRANTS ]
  ON EXTERNAL TABLE <external_table_name>
  [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } ) ]
  [ INSERT_ONLY = TRUE ]
  [ COMMENT = '<string_literal>' ]

-- Directory table
CREATE [ OR REPLACE ] STREAM [IF NOT EXISTS]
  <name>
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COPY GRANTS ]
  ON STAGE <stage_name>
  [ COMMENT = '<string_literal>' ]

-- View
CREATE [ OR REPLACE ] STREAM [IF NOT EXISTS]
  <name>
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COPY GRANTS ]
  ON VIEW <view_name>
  [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } ) ]
  [ APPEND_ONLY = TRUE | FALSE ]
  [ SHOW_INITIAL_ROWS = TRUE | FALSE ]
  [ COMMENT = '<string_literal>' ]

-- Example 11842
CREATE [ OR REPLACE ] STREAM <name> CLONE <source_stream>
  [ COPY GRANTS ]
  [ ... ]

-- Example 11843
CREATE STREAM mystream ON TABLE mytable;

-- Example 11844
CREATE STREAM mystream ON TABLE mytable BEFORE (TIMESTAMP => TO_TIMESTAMP(40*365*86400));

-- Example 11845
CREATE STREAM mystream ON TABLE mytable AT (TIMESTAMP => TO_TIMESTAMP_TZ('02/02/2019 01:02:03', 'mm/dd/yyyy hh24:mi:ss'));

-- Example 11846
CREATE STREAM mystream ON TABLE mytable AT(OFFSET => -60*5);

-- Example 11847
CREATE STREAM mystream ON TABLE mytable AT(STREAM => 'oldstream');

-- Example 11848
CREATE OR REPLACE STREAM mystream ON TABLE mytable AT(STREAM => 'mystream');

-- Example 11849
CREATE STREAM mystream ON TABLE mytable BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 11850
CREATE STREAM mystream ON VIEW myview;

-- Example 11851
-- Create an external table that points to the MY_EXT_STAGE stage.
-- The external table is partitioned by the date (in YYYY/MM/DD format) in the file path.
CREATE EXTERNAL TABLE my_ext_table (
  date_part date as to_date(substr(metadata$filename, 1, 10), 'YYYY/MM/DD'),
  ts timestamp AS (value:time::timestamp),
  user_id varchar AS (value:userId::varchar),
  color varchar AS (value:color::varchar)
) PARTITION BY (date_part)
  LOCATION=@my_ext_stage
  AUTO_REFRESH = false
  FILE_FORMAT=(TYPE=JSON);

-- Create a stream on the external table
CREATE STREAM my_ext_table_stream ON EXTERNAL TABLE my_ext_table INSERT_ONLY = TRUE;

-- Execute SHOW streams
-- The MODE column indicates that the new stream is an INSERT_ONLY stream
SHOW STREAMS;
+-------------------------------+------------------------+---------------+-------------+--------------+-----------+------------------------------------+-------+-------+-------------+
| created_on                    | name                   | database_name | schema_name | owner        | comment   | table_name                         | type  | stale | mode        |
|-------------------------------+------------------------+---------------+-------------+--------------+-----------+------------------------------------+-------+-------+-------------|
| 2020-08-02 05:13:20.174 -0800 | MY_EXT_TABLE_STREAM    | MYDB          | PUBLIC      | MYROLE       |           | MYDB.PUBLIC.EXTTABLE_S3_PART       | DELTA | false | INSERT_ONLY |
+-------------------------------+------------------------+---------------+-------------+--------------+-----------+------------------------------------+-------+-------+-------------+

-- Add a file named '2020/08/05/1408/log-08051409.json' to the stage using the appropriate tool for the cloud storage service.

-- Manually refresh the external table metadata.
ALTER EXTERNAL TABLE my_ext_table REFRESH;

-- Query the external table stream.
-- The stream indicates that the rows in the added JSON file were recorded in the external table metadata.
SELECT * FROM my_ext_table_stream;
+----------------------------------------+------------+-------------------------+---------+-------+-----------------+-------------------+-----------------+---------------------------------------------+
| VALUE                                  | DATE_PART  | TS                      | USER_ID | COLOR | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID | METADATA$FILENAME                           |
|----------------------------------------+------------+-------------------------+---------+-------+-----------------+-------------------+-----------------+---------------------------------------------|
| {                                      | 2020-08-05 | 2020-08-05 15:57:01.000 | user25  | green | INSERT          | False             |                 | test/logs/2020/08/05/1408/log-08051409.json |
|   "color": "green",                    |            |                         |         |       |                 |                   |                 |                                             |
|   "time": "2020-08-05 15:57:01-07:00", |            |                         |         |       |                 |                   |                 |                                             |
|   "userId": "user25"                   |            |                         |         |       |                 |                   |                 |                                             |
| }                                      |            |                         |         |       |                 |                   |                 |                                             |
| {                                      | 2020-08-05 | 2020-08-05 15:58:02.000 | user56  | brown | INSERT          | False             |                 | test/logs/2020/08/05/1408/log-08051409.json |
|   "color": "brown",                    |            |                         |         |       |                 |                   |                 |                                             |
|   "time": "2020-08-05 15:58:02-07:00", |            |                         |         |       |                 |                   |                 |                                             |
|   "userId": "user56"                   |            |                         |         |       |                 |                   |                 |                                             |
| }                                      |            |                         |         |       |                 |                   |                 |                                             |
+----------------------------------------+------------+-------------------------+---------+-------+-----------------+-------------------+-----------------+---------------------------------------------+

-- Example 11852
CREATE STREAM dirtable_mystage_s ON STAGE mystage;

-- Example 11853
ALTER STAGE mystage REFRESH;

-- Example 11854
SELECT * FROM dirtable_mystage_s;

+-------------------+--------+-------------------------------+----------------------------------+----------------------------------+-------------------------------------------------------------------------------------------+-----------------+-------------------+-----------------+
| RELATIVE_PATH     | SIZE   | LAST_MODIFIED                 | MD5                              | ETAG                             | FILE_URL                                                                                  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|-------------------+--------+-------------------------------+----------------------------------+----------------------------------+-------------------------------------------------------------------------------------------+-----------------+-------------------+-----------------|
| file1.csv.gz      |   1048 | 2021-05-14 06:09:08.000 -0700 | c98f600c492c39bef249e2fcc7a4b6fe | c98f600c492c39bef249e2fcc7a4b6fe | https://myaccount.snowflakecomputing.com/api/files/MYDB/MYSCHEMA/MYSTAGE/file1%2ecsv%2egz | INSERT          | False             |                 |
| file2.csv.gz      |   3495 | 2021-05-14 06:09:09.000 -0700 | 7f1a4f98ef4c7c42a2974504d11b0e20 | 7f1a4f98ef4c7c42a2974504d11b0e20 | https://myaccount.snowflakecomputing.com/api/files/MYDB/MYSCHEMA/MYSTAGE/file2%2ecsv%2egz | INSERT          | False             |                 |
+-------------------+--------+-------------------------------+----------------------------------+----------------------------------+-------------------------------------------------------------------------------------------+-----------------+-------------------+-----------------+

-- Example 11855
ALTER SESSION SET SIMULATED_DATA_SHARING_CONSUMER = xy12345;

-- Example 11856
GRANT READ ON TAG mydb.tags.tag1 TO SHARE my_share;

GRANT USAGE ON DATABASE mydb TO SHARE my_share;
GRANT USAGE ON SCHEMA mydb.tags TO SHARE my_share;

-- Example 11857
GRANT READ ON TAG mydb.tags.tag1 TO DATABASE ROLE my_db_role;
GRANT USAGE ON SCHEMA mydb.tags TO DATABASE ROLE my_db_role;
GRANT DATABASE ROLE my_db_role TO SHARE my_share;

-- Example 11858
GRANT IMPORTED PRIVILEGES ON DATABASE db_share TO ROLE db_share_role;

-- Example 11859
GRANT DATABASE ROLE my_db_role TO ROLE consumer_analyst_role;

-- Example 11860
CREATE SHARE sales_s;

-- Example 11861
CREATE DATABASE ROLE sales_db.dr1;

GRANT USAGE ON DATABASE sales_db TO DATABASE ROLE sales_db.dr1;

GRANT USAGE ON SCHEMA sales_db.aggregates_eula TO DATABASE ROLE sales_db.dr1;

GRANT SELECT ON TABLE sales_db.aggregates_eula.aggregate_1 TO DATABASE ROLE sales_db.dr1;

GRANT USAGE ON DATABASE sales_db TO SHARE sales_s;

GRANT DATABASE ROLE sales_db.dr1 TO SHARE sales_s;

-- Example 11862
GRANT USAGE ON DATABASE sales_db TO SHARE sales_s;

GRANT USAGE ON SCHEMA sales_db.aggregates_eula TO SHARE sales_s;

GRANT SELECT ON TABLE sales_db.aggregates_eula.aggregate_1 TO SHARE sales_s;

-- Example 11863
SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

-- Example 11864
ALTER SHARE sales_s ADD ACCOUNTS=xy12345, yz23456;

-- Example 11865
SHOW SHARES;

-- Example 11866
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.XY12345         | SALES_S2      | UPDATED_SALES_DB      |                  |              | Transformed and updated sales data     |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 11867
SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

GRANT SELECT ON VIEW sales_db.aggregates_eula.agg_secure TO SHARE sales_s;

SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-17 12:33:15.310 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGG_SECURE  | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

-- Example 11868
SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-17 12:33:15.310 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGG_SECURE  | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

REVOKE SELECT ON VIEW sales_db.aggregates_eula.agg_secure FROM SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

-- Example 11869
SHOW SHARES;

-- Example 11870
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.PRVDR1          | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.PRVDR1          | SALES_S2      | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 11871
SHOW GRANTS OF SHARE sales_s;

-- Example 11872
+-------------------------------+----------------+------------+----------+
| created_on                    | share          | granted_to | account  |
|-------------------------------+----------------+------------+----------|
| 2017-06-15 18:00:03.803 -0700 | PRVDR1.SALES_S | ACCOUNT    | XY12345  |
+-------------------------------+----------------+------------+----------+

-- Example 11873
SHOW GRANTS OF SHARE sales_s2;

-- Example 11874
+------------+-------+------------+---------+
| created_on | share | granted_to | account |
|------------+-------+------------+---------|
+------------+-------+------------+---------+

-- Example 11875
DESC[RIBE] STREAM <name>

-- Example 11876
CREATE STREAM mystream ( ... );

-- Example 11877
DESC STREAM mystream;

-- Example 11878
SHOW [ TERSE ] STREAMS [ LIKE '<pattern>' ]
                       [ IN { ACCOUNT | DATABASE [ <db_name> ] | [ SCHEMA ] [ <schema_name> ] | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> } ]
                       [ STARTS WITH '<name_string>' ]
                       [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 11879
SHOW STREAMS LIKE 'line%' IN tpch.public;

-- Example 11880
CREATE SECURE VIEW v CHANGE_TRACKING = TRUE AS SELECT col1, col2 FROM t;

-- Example 11881
ALTER VIEW v2 SET CHANGE_TRACKING = TRUE;

-- Example 11882
CREATE TABLE t (col1 STRING, col2 NUMBER) CHANGE_TRACKING = TRUE;

-- Example 11883
ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

-- Example 11884
SELECT ...
FROM ...
   CHANGES ( INFORMATION => { DEFAULT | APPEND_ONLY } )
   AT ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } ) | BEFORE ( STATEMENT => <id> )
   [ END( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
[ ... ]

-- Example 11885
ALTER TABLE mytable SET CHANGE_TRACKING = TRUE;

-- Example 11886
CREATE OR REPLACE TABLE t1 (
   id number(8) NOT NULL,
   c1 varchar(255) default NULL
 );

-- Enable change tracking on the table.
 ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

 -- Initialize a session variable for the current timestamp.
 SET ts1 = (SELECT CURRENT_TIMESTAMP());

 INSERT INTO t1 (id,c1)
 VALUES
 (1,'red'),
 (2,'blue'),
 (3,'green');

 DELETE FROM t1 WHERE id = 1;

 UPDATE t1 SET c1 = 'purple' WHERE id = 2;

 -- Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the full delta of the changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => DEFAULT)
   AT(TIMESTAMP => $ts1);

 +----+--------+-----------------+-------------------+------------------------------------------+
 | ID | C1     | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
 |----+--------+-----------------+-------------------+------------------------------------------|
 |  2 | purple | INSERT          | False             | 1614e92e93f86af6348f15af01a85c4229b42907 |
 |  3 | green  | INSERT          | False             | 86df000054a4d1dc64d5d74a44c3131c4c046a1f |
 +----+--------+-----------------+-------------------+------------------------------------------+

 -- Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the append-only changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => APPEND_ONLY)
   AT(TIMESTAMP => $ts1);

 +----+-------+-----------------+-------------------+------------------------------------------+
 | ID | C1    | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
 |----+-------+-----------------+-------------------+------------------------------------------|
 |  1 | red   | INSERT          | False             | 6a964a652fa82974f3f20b4f49685de54eeb4093 |
 |  2 | blue  | INSERT          | False             | 1614e92e93f86af6348f15af01a85c4229b42907 |
 |  3 | green | INSERT          | False             | 86df000054a4d1dc64d5d74a44c3131c4c046a1f |
 +----+-------+-----------------+-------------------+------------------------------------------+

-- Example 11887
CREATE OR REPLACE TABLE t1 (
  id number(8) NOT NULL,
  c1 varchar(255) default NULL
);

-- Enable change tracking on the table.
ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

-- Initialize a session 'start timestamp' variable for the current timestamp.
SET ts1 = (SELECT CURRENT_TIMESTAMP());

INSERT INTO t1 (id,c1)
VALUES
(1,'red'),
(2,'blue'),
(3,'green');

-- Initialize a session 'end timestamp' variable for the current timestamp.
SET ts2 = (SELECT CURRENT_TIMESTAMP());

DELETE FROM t1 WHERE id = 3;
SET last_query_id = (SELECT LAST_QUERY_ID());

-- Create a table populated by the change data between the start and end timestamps.
CREATE OR REPLACE TABLE t2 (
  c1 varchar(255) default NULL
  )
AS SELECT C1
  FROM t1
  CHANGES(INFORMATION => APPEND_ONLY)
  AT(TIMESTAMP => $ts1)
  END(TIMESTAMP => $ts2);

SELECT * FROM t2;

+-------+
| C1    |
|-------|
| red   |
| blue  |
| green |
+-------+

-- Create a table populated by the change data between the start timestamp and end statement.
-- This example demonstrates that END is inclusive of the statement passed in.
CREATE OR REPLACE TABLE t3 (
  c1 varchar(255) default NULL
  )
AS SELECT C1
  FROM t1
  CHANGES(INFORMATION => DEFAULT)
  AT(TIMESTAMP => $ts1)
  END(STATEMENT => $last_query_id);

+-------+
| C1    |
|-------|
| red   |
| blue  |
+-------+

-- Example 11888
CREATE OR REPLACE TABLE t1 (
  id number(8) NOT NULL,
  c1 varchar(255) default NULL
);

-- Create a stream on the table.
CREATE OR REPLACE STREAM s1 ON TABLE t1;

INSERT INTO t1 (id,c1)
VALUES
(1,'red'),
(2,'blue'),
(3,'green');

-- Initialize a session 'end timestamp' variable for the current timestamp.
SET ts2 = (SELECT CURRENT_TIMESTAMP());

DELETE FROM t1;

-- Create a table populated by the change data between the current
-- s1 offset and the end timestamp.
CREATE OR REPLACE TABLE t2 (
  c1 varchar(255) default NULL
  )
AS SELECT C1
  FROM t1
  CHANGES(INFORMATION => APPEND_ONLY)
  AT(STREAM => 's1')
  END(TIMESTAMP => $ts2);

SELECT * FROM t2;

+-------+
| C1    |
|-------|
| red   |
| blue  |
| green |
+-------+

-- Example 11889
ALTER SESSION SET TIMEZONE = UTC;

-- Example 11890
SELECT
  (SUM(credits_used_compute) -
    SUM(credits_attributed_compute_queries)) AS idle_cost,
  warehouse_name
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('days', -10, CURRENT_DATE())
  AND end_time < CURRENT_DATE()
GROUP BY warehouse_name;

-- Example 11891
ALTER ACCOUNT SET LOG_LEVEL = ERROR;

-- Example 11892
ALTER DATABASE my_db SET LOG_LEVEL = INFO;

-- Example 11893
ALTER DYNAMIC TABLE my_dynamic_table SET LOG_LEVEL = WARN;

-- Example 11894
CREATE ALERT my_alert_on_dt_refreshes
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENT_TABLE
      WHERE resource_attributes:"snow.executable.type" = 'dynamic_table'
        AND resource_attributes:"snow.database.name" = 'my_db'
        AND record_attributes:"event.name" = 'refresh.status'
        AND record:"severity_text" = 'ERROR'
        AND value:"state" = 'FAILED'))
  THEN
    BEGIN
      LET result_str VARCHAR;
      (SELECT ARRAY_TO_STRING(ARRAY_ARG(name)::ARRAY, ',') INTO :result_str
         FROM (
           SELECT resource_attributes:"snow.executable.name"::VARCHAR name
             FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()))
             LIMIT 10
         )
      );
      CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
        SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(:result_str),
        '{"my_slack_integration": {}}'
      );
    END;

-- Example 11895
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS dt_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 11896
+-------------------------+------------------+--------------------------------------+---------------------------------------------------------------------------------+
| TIMESTAMP               | DT_NAME          | QUERY_ID                             | ERROR                                                                           |
|-------------------------+------------------+--------------------------------------+---------------------------------------------------------------------------------|
| 2025-02-17 21:40:45.444 | MY_DYNAMIC_TABLE | 01ba7614-0107-e56c-0000-a995024f304a | SQL compilation error:                                                          |
|                         |                  |                                      | Failure during expansion of view 'MY_DYNAMIC_TABLE': SQL compilation error:     |
|                         |                  |                                      | Object 'MY_DB.MY_SCHEMA.MY_BASE_TABLE' does not exist or not authorized.        |
+-------------------------+------------------+--------------------------------------+---------------------------------------------------------------------------------+

-- Example 11897
SELECT *
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
    resource_attributes:"snow.schema.name" = 'MY_SCHEMA' AND
    value:state = 'UPSTREAM_FAILURE'
  ORDER BY timestamp DESC;

-- Example 11898
+-------------------------+-----------------+-------------------------+-------+----------+-------------------------------------------------+-------+------------------+-------------+-----------------------------+-------------------+-------------------------------+-----------+
| TIMESTAMP               | START_TIMESTAMP | OBSERVED_TIMESTAMP      | TRACE | RESOURCE | RESOURCE_ATTRIBUTES                             | SCOPE | SCOPE_ATTRIBUTES | RECORD_TYPE | RECORD                      | RECORD_ATTRIBUTES | VALUE                         | EXEMPLARS |
|-------------------------+-----------------+-------------------------+-------+----------+-------------------------------------------------+-------+------------------+-------------+-----------------------------+-------------------+-------------------------------+-----------|
| 2025-02-17 21:40:45.486 | NULL            | 2025-02-17 21:40:45.486 | NULL  | NULL     | {                                               | NULL  | NULL             | EVENT       | {                           | NULL              | {                             | NULL      |
|                         |                 |                         |       |          |   "snow.database.id": 49,                       |       |                  |             |   "name": "refresh.status", |                   |   "state": "UPSTREAM_FAILURE" |           |
|                         |                 |                         |       |          |   "snow.database.name": "MY_DB",                |       |                  |             |   "severity_text": "WARN"   |                   | }                             |           |
|                         |                 |                         |       |          |   "snow.executable.id": 487426,                 |       |                  |             | }                           |                   |                               |           |
|                         |                 |                         |       |          |   "snow.executable.name": "MY_DYNAMIC_TABLE_2", |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.executable.type": "DYNAMIC_TABLE",      |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.owner.id": 2601,                        |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.owner.name": "DATA_ADMIN",              |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.owner.type": "ROLE",                    |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.schema.id": 411,                        |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.schema.name": "MY_SCHEMA"               |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          | }                                               |       |                  |             |                             |                   |                               |           |
+-------------------------+-----------------+-------------------------+-------+----------+-------------------------------------------------+-------+------------------+-------------+-----------------------------+-------------------+-------------------------------+-----------+

-- Example 11899
SELECT name, state, state_code, state_message, query_id, data_timestamp, refresh_start_time, refresh_end_time
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(NAME_PREFIX => 'MYDB.MYSCHEMA.', ERROR_ONLY => TRUE))
ORDER BY name, data_timestamp;

-- Example 11900
ALTER ACCOUNT SET LOG_LEVEL = ERROR;

-- Example 11901
ALTER DATABASE my_db SET LOG_LEVEL = INFO;

-- Example 11902
ALTER TASK my_task SET LOG_LEVEL = ERROR;

-- Example 11903
CREATE ALERT my_alert_on_task_failures
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENT_TABLE
      WHERE resource_attributes:"snow.executable.type" = 'task'
        AND resource_attributes:"snow.database.name" = 'my_db'
        AND record:"severity_text" = 'ERROR'
        AND value:"state" = 'FAILED'))
  THEN
    BEGIN
      LET result_str VARCHAR;
      (SELECT ARRAY_TO_STRING(ARRAY_ARG(name)::ARRAY, ',') INTO :result_str
         FROM (
           SELECT resource_attributes:"snow.executable.name"::VARCHAR name
             FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()))
             LIMIT 10
         )
      );
      CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
        SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(:result_str),
        '{"my_slack_integration": {}}'
      );
    END;

-- Example 11904
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS task_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'TASK' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 11905
+-------------------------+-----------+--------------------------------------+------------------------------------------------------+
| TIMESTAMP               | TASK_NAME | QUERY_ID                             | ERROR                                                |
|-------------------------+-----------+--------------------------------------+------------------------------------------------------|
| 2025-02-18 00:21:19.461 | T1        | 01ba76b5-0107-e56d-0000-a995024f4222 | 002003: SQL compilation error:                       |
|                         |           |                                      | Object 'MY_TABLE' does not exist or not authorized.  |
+-------------------------+-----------+--------------------------------------+------------------------------------------------------+

