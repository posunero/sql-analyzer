-- Example 25502
CALL file_reader_java_proc_snowflakefile(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 25503
String filename = "@my_stage/filename.txt";
String sfFile = SnowflakeFile.newInstance(filename, false);

-- Example 25504
CREATE OR REPLACE PROCEDURE file_reader_java_proc_input(input VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = 11
HANDLER = 'FileReader.execute'
PACKAGES=('com.snowflake:snowpark:latest')
AS $$
import java.io.InputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import com.snowflake.snowpark.Session;

class FileReader {
  public String execute(Session session, InputStream stream) throws IOException {
    String contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
    return contents;
  }
}
$$;

-- Example 25505
CALL file_reader_java_proc_input(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 25506
ALTER DYNAMIC TABLE my_dynamic_table SET TARGET_LAG = '1 hour';

-- Example 25507
ALTER DYNAMIC TABLE my_dynamic_table SET TARGET_LAG = DOWNSTREAM;

-- Example 25508
SELECT
    name
FROM
  TABLE (
    INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY (
      NAME_PREFIX => 'MYDB.MYSCHEMA.', ERROR_ONLY => TRUE
    )
  );

-- Example 25509
-- Create the dynamic table, for reference only
CREATE OR REPLACE DYNAMIC TABLE product ...;

-- Create the stream.
CREATE OR REPLACE STREAM deltaStream ON DYNAMIC TABLE product;

-- Example 25510
-- Create a landing table to store
-- raw JSON data.
CREATE OR REPLACE TABLE raw
  (var VARIANT);

-- Create a stream to capture inserts
-- to the landing table.
CREATE OR REPLACE STREAM rawstream1
  ON TABLE raw;

-- Create a table that stores the
-- names of office visitors from the
-- raw data.
CREATE OR REPLACE TABLE names
  (id INT,
   first_name STRING,
   last_name STRING);

-- Create a task that inserts new name
-- records from the rawstream1 stream
-- into the names table.
-- Execute the task every minute when
-- the stream contains records.
CREATE OR REPLACE TASK raw_to_names
  WAREHOUSE = mywh
  SCHEDULE = '1 minute'
  WHEN
    SYSTEM$STREAM_HAS_DATA('rawstream1')
  AS
    MERGE INTO names n
      USING (
        SELECT var:id id, var:fname fname,
        var:lname lname FROM rawstream1
      ) r1 ON n.id = TO_NUMBER(r1.id)
      WHEN MATCHED AND metadata$action = 'DELETE' THEN
        DELETE
      WHEN MATCHED AND metadata$action = 'INSERT' THEN
        UPDATE SET n.first_name = r1.fname, n.last_name = r1.lname
      WHEN NOT MATCHED AND metadata$action = 'INSERT' THEN
        INSERT (id, first_name, last_name)
          VALUES (r1.id, r1.fname, r1.lname);

-- Example 25511
-- Create a landing table to store
-- raw JSON data.
CREATE OR REPLACE TABLE raw
  (var VARIANT);

-- Create a dynamic table containing the
-- names of office visitors from
-- the raw data.
-- Try to keep the data up to date within
-- 1 minute of real time.
CREATE OR REPLACE DYNAMIC TABLE names
  TARGET_LAG = '1 minute'
  WAREHOUSE = mywh
  AS
    SELECT var:id::int id, var:fname::string first_name,
    var:lname::string last_name FROM raw;

-- Example 25512
SHOW SHARES;

-- Example 25513
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |                  |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.XY12345         | SALES_S2      | UPDATED_SALES_DB      |                  |              | Transformed and updated sales data     |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 25514
DESC SHARE xy12345.sales_s;

+----------+------------------------------------+---------------------------------+
| kind     | name                               | shared_on                       |
|----------+------------------------------------+---------------------------------|
| DATABASE | <DB>                               | Thu, 15 Jun 2017 17:03:16 -0700 |
| SCHEMA   | <DB>.AGGREGATES_EULA               | Thu, 15 Jun 2017 17:03:16 -0700 |
| TABLE    | <DB>.AGGREGATES_EULA.AGGREGATE_1   | Thu, 15 Jun 2017 17:03:16 -0700 |
| VIEW     | <DB>.AGGREGATES_EULA.AGGREGATE_1_v | Thu, 15 Jun 2017 17:03:16 -0700 |
+----------+------------------------------------+---------------------------------+

-- Example 25515
CREATE DATABASE <name> FROM SHARE <provider_account>.<share_name>

-- Example 25516
CREATE DATABASE snow_sales FROM SHARE xy12345.sales_s;

-- Example 25517
SHOW DATABASES LIKE 'snow%';

+---------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------+
| created_on                      | name                  | is_default | is_current | origin                  | owner        | comment | options | retention_time |
|---------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------|
| Sun, 10 Jul 2016 23:28:50 -0700 | SNOWFLAKE_SAMPLE_DATA | N          | N          | SFC_SAMPLES.SAMPLE_DATA | ACCOUNTADMIN |         |         | 1              |
| Thu, 15 Jun 2017 18:30:08 -0700 | SNOW_SALES            | N          | Y          | xy12345.SALES_S         | ACCOUNTADMIN |         |         | 1              |
+---------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------+

-- Example 25518
SHOW SHARES;

-- Example 25519
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.XY12345         | SALES_S2      | UPDATED_SALES_DB      |                  |              | Transformed and updated sales data     |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 25520
DESC SHARE xy12345.sales_s;

+----------+------------------------------------------+---------------------------------+
| kind     | name                                     | shared_on                       |
|----------+------------------------------------------+---------------------------------|
| DATABASE | SNOW_SALES                               | Thu, 15 Jun 2017 17:03:16 -0700 |
| SCHEMA   | SNOW_SALES.AGGREGATES_EULA               | Thu, 15 Jun 2017 17:03:16 -0700 |
| TABLE    | SNOW_SALES.AGGREGATES_EULA.AGGREGATE_1   | Thu, 15 Jun 2017 17:03:16 -0700 |
| VIEW     | SNOW_SALES.AGGREGATES_EULA.AGGREGATE_1_v | Thu, 15 Jun 2017 17:03:16 -0700 |
+----------+------------------------------------------+---------------------------------+

-- Example 25521
use role r1;
create database snow_sales from share xy12345.sales_s;

-- Example 25522
grant imported privileges on database snow_sales to role r2;

-- Example 25523
use role r2;
grant imported privileges on database snow_sales to role r3;
revoke imported privileges on database snow_sales from role r3;

-- Example 25524
CREATE DATABASE c1 FROM SHARE provider1.share1;

-- Example 25525
SHOW DATABASE ROLES in DATABASE c1;
GRANT DATABASE ROLE c1.r1 TO ROLE analyst;

-- Example 25526
CREATE STREAM <name> ON VIEW <shared_db>.<schema>.<view>;

-- Example 25527
CREATE STREAM aggregate_1_v_stream ON VIEW snow_sales.aggregates_eula.aggregate_1_v;

-- Example 25528
CREATE STREAM <name> ON TABLE <shared_db>.<schema>.<table>;

-- Example 25529
CREATE STREAM aggregate_1_stream ON TABLE snow_sales.aggregates_eula.aggregate_1;

-- Example 25530
USE ROLE r1;

USE DATABASE snow_sales;

SELECT * FROM aggregates_1;

-- Example 25531
CREATE STREAM mystream ON TABLE mybasetable BEFORE(STATEMENT => 'last refresh UUID');

-- Example 25532
SELECT * FROM TABLE(SYSTEM$STREAM_BACKLOG('mystream'))

-- Example 25533
CREATE [ OR REPLACE ] [ TRANSIENT ] DYNAMIC TABLE [ IF NOT EXISTS ] <name> (
    -- Column definition
    <col_name> <col_type>
      [ [ WITH ] MASKING POLICY <policy_name> [ USING ( <col_name> , <cond_col1> , ... ) ] ]
      [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
      [ COMMENT '<string_literal>' ]

    -- Additional column definitions
    [ , <col_name> <col_type> [ ... ] ]

  )
  TARGET_LAG = { '<num> { seconds | minutes | hours | days }' | DOWNSTREAM }
  WAREHOUSE = <warehouse_name>
  [ REFRESH_MODE = { AUTO | FULL | INCREMENTAL } ]
  [ INITIALIZE = { ON_CREATE | ON_SCHEDULE } ]
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ REQUIRE USER ]
  AS <query>

-- Example 25534
CREATE [ OR REPLACE ] [ TRANSIENT ] DYNAMIC TABLE <name>
  CLONE <source_dynamic_table>
        [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
  [
    COPY GRANTS
    TARGET_LAG = { '<num> { seconds | minutes | hours | days }' | DOWNSTREAM }
    WAREHOUSE = <warehouse_name>
  ]

-- Example 25535
CREATE [ OR REPLACE ] DYNAMIC ICEBERG TABLE <name> (
  -- Column definition
  <col_name> <col_type>
    [ [ WITH ] MASKING POLICY <policy_name> [ USING ( <col_name> , <cond_col1> , ... ) ] ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ COMMENT '<string_literal>' ]

  -- Additional column definitions
  [ , <col_name> <col_type> [ ... ] ]

)
TARGET_LAG = { '<num> { seconds | minutes | hours | days }' | DOWNSTREAM }
WAREHOUSE = <warehouse_name>
[ EXTERNAL_VOLUME = '<external_volume_name>' ]
[ CATALOG = 'SNOWFLAKE' ]
[ BASE_LOCATION = '<optional_directory_for_table_files>' ]
[ REFRESH_MODE = { AUTO | FULL | INCREMENTAL } ]
[ INITIALIZE = { ON_CREATE | ON_SCHEDULE } ]
[ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
[ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
[ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
[ COMMENT = '<string_literal>' ]
[ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ REQUIRE USER ]
AS <query>

-- Example 25536
Dynamic Table is not initialized. Please run a manual refresh or wait for a scheduled refresh before querying.

-- Example 25537
CREATE DYNAMIC TABLE product (pre_tax_profit, taxes, after_tax_profit)
  TARGET_LAG = '20 minutes'
    WAREHOUSE = mywh
    AS
      SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
      FROM staging_table;

-- Example 25538
CREATE DYNAMIC TABLE product (pre_tax_profit COMMENT 'revenue minus cost',
                taxes COMMENT 'assumes taxes are a fixed percentage of profit',
                after_tax_profit)
  TARGET_LAG = '20 minutes'
    WAREHOUSE = mywh
    AS
      SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
      FROM staging_table;

-- Example 25539
CREATE OR REPLACE DYNAMIC TABLE product
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = mywh
  AS
    SELECT * FROM staging_table
    COPY GRANTS;

-- Example 25540
CREATE OR REPLACE DYNAMIC TABLE product
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 25541
CREATE DYNAMIC ICEBERG TABLE product (date TIMESTAMP_NTZ, id NUMBER, content STRING)
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my_iceberg_table'
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 25542
CREATE DYNAMIC TABLE product (date TIMESTAMP_NTZ, id NUMBER, content VARIANT)
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  CLUSTER BY (date, id)
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 25543
CREATE DYNAMIC TABLE product_clone CLONE product AT (TIMESTAMP => TO_TIMESTAMP_TZ('04/05/2013 01:02:03', 'mm/dd/yyyy hh24:mi:ss'));

-- Example 25544
CREATE DYNAMIC TABLE product
  TARGET_LAG = 'DOWNSTREAM'
  WAREHOUSE = mywh
  INITIALIZE = on_schedule
  REQUIRE USER
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 25545
ALTER DYNAMIC TABLE product REFRESH COPY SESSION;

-- Example 25546
ALTER DYNAMIC TABLE my_dynamic_table SET TARGET_LAG = '1 hour';

-- Example 25547
ALTER DYNAMIC TABLE my_dynamic_table SET TARGET_LAG = DOWNSTREAM;

-- Example 25548
SELECT
    name
FROM
  TABLE (
    INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY (
      NAME_PREFIX => 'MYDB.MYSCHEMA.', ERROR_ONLY => TRUE
    )
  );

-- Example 25549
CREATE DYNAMIC TABLE controller
  TARGET_LAG = <target_lag>
  WAREHOUSE = <warehouse>
  AS
    SELECT 1 A FROM <leaf1>, …, <leafN> LIMIT 0;

-- Example 25550
ALTER DYNAMIC TABLE controller SET
  TARGET_LAG = <new_target_lag>

-- Example 25551
ALTER DYNAMIC TABLE controller REFRESH

-- Example 25552
ALTER DYNAMIC TABLE [ IF EXISTS ] <name> { SUSPEND | RESUME }

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> SWAP WITH <target_dynamic_table_name>

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> REFRESH [ COPY SESSION ]

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> { clusteringAction }

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> { tableColumnCommentAction }

ALTER DYNAMIC TABLE <name> { SET | UNSET } COMMENT = '<string_literal>'

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> dataGovnPolicyTagAction

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> searchOptimizationAction

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> SET
  [ TARGET_LAG = { '<num> { seconds | minutes | hours | days }'  | DOWNSTREAM } ]
  [ WAREHOUSE = <warehouse_name> ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ LOG_LEVEL = '<log_level>' ]

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> UNSET
  [ DATA_RETENTION_TIME_IN_DAYS ],
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS ],
  [ DEFAULT_DDL_COLLATION ]
  [ LOG_LEVEL ]

-- Example 25553
clusteringAction ::=
  {
    CLUSTER BY ( <expr> [ , <expr> , ... ] )
    | { SUSPEND | RESUME } RECLUSTER
    | DROP CLUSTERING KEY
  }

-- Example 25554
tableCommentAction ::=
  {
    ALTER | MODIFY [ ( ]
                           [ COLUMN ] <col1_name> COMMENT '<string>'
                         , [ COLUMN ] <col1_name> UNSET COMMENT
                       [ , ... ]
                   [ ) ]
  }

-- Example 25555
dataGovnPolicyTagAction ::=
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] [ FORCE ]
      | UNSET MASKING POLICY
  }
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> SET TAG
      <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
      , [ COLUMN ] <col2_name> SET TAG
          <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
                  , [ COLUMN ] <col2_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }

-- Example 25556
searchOptimizationAction ::=
  {
    ADD SEARCH OPTIMIZATION [
      ON <search_method_with_target> [ , <search_method_with_target> ... ]
        [ EQUALITY ]
      ]

    | DROP SEARCH OPTIMIZATION [
      ON { <search_method_with_target> | <column_name> | <expression_id> }
        [ EQUALITY ]
        [ , ... ]
      ]

    | SUSPEND SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]

    | RESUME SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]
  }

-- Example 25557
<search_method>(<target> [, ...])

-- Example 25558
ON SUBSTRING(*)
ON EQUALITY(*), SUBSTRING(*), GEO(*)

-- Example 25559
ON EQUALITY(*, c1)
ON EQUALITY(c1, *)
ON EQUALITY(v1:path, *)
ON EQUALITY(c1), EQUALITY(*)

-- Example 25560
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 25561
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2);
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c3, c4);

-- Example 25562
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3, c4);

-- Example 25563
ALTER DYNAMIC TABLE IDENTIFIER(product) SUSPEND;

-- Example 25564
ALTER DYNAMIC TABLE product SET
  TARGET_LAG = '1 hour';

-- Example 25565
ALTER DYNAMIC TABLE product SET TARGET_LAG = DOWNSTREAM;

-- Example 25566
ALTER DYNAMIC TABLE product SUSPEND;

-- Example 25567
ALTER DYNAMIC TABLE product RESUME;

-- Example 25568
ALTER DYNAMIC TABLE product RENAME TO updated_product;

