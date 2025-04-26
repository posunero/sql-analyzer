-- Example 11705
javac -d classes src/mypackage/MyUDFHandler.java

-- Example 11706
Manifest-Version: 1.0
Main-Class: mypackage.MyUDFHandler

-- Example 11707
jar cmf my_udf.manifest my_udf.jar -C ./classes mypackage/MyUDFHandler.class

-- Example 11708
put
    file:///Users/Me/my_udf/my_udf.jar
    @jar_stage
    auto_compress = false
    overwrite = true
    ;

-- Example 11709
snowsql -a <account_identifier> -w <warehouse> -d <database> -s <schema> -u <user> -f put_command.sql

-- Example 11710
CREATE FUNCTION decrement_value(i NUMERIC(9, 0))
  RETURNS NUMERIC
  LANGUAGE JAVA
  IMPORTS = ('@jar_stage/my_udf.jar')
  HANDLER = 'mypackage.MyUDFHandler.decrementValue'
  ;

-- Example 11711
SELECT decrement_value(-15);

-- Example 11712
+----------------------+
| DECREMENT_VALUE(-15) |
|----------------------|
|                  -16 |
+----------------------+

-- Example 11713
CREATE STAGE my_int_stage
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 11714
from snowflake.core.stage import Stage, StageEncryption

my_stage = Stage(
  name="my_int_stage",
  encryption=StageEncryption(type="SNOWFLAKE_SSE")
)
root.databases["<database>"].schemas["<schema>"].stages.create(my_stage)

-- Example 11715
PUT file:///data/data.csv @~/staged;

-- Example 11716
PUT file://C:\data\data.csv @~/staged;

-- Example 11717
PUT file:///data/data.csv @%mytable;

-- Example 11718
PUT file://C:\data\data.csv @%mytable;

-- Example 11719
PUT file:///data/data.csv @my_stage;

-- Example 11720
my_stage_res = root.databases["<database>"].schemas["<schema>"].stages["my_stage"]
my_stage_res.put("/data/data.csv", "/")

-- Example 11721
PUT file://C:\data\data.csv @my_stage;

-- Example 11722
my_stage_res = root.databases["<database>"].schemas["<schema>"].stages["my_stage"]
my_stage_res.put("C:/data/data.csv", "/")

-- Example 11723
LIST @~;

-- Example 11724
LIST @%mytable;

-- Example 11725
LIST @my_stage;

-- Example 11726
stage_files = root.databases["<database>"].schemas["<schema>"].stages["my_stage"].list_files()
for stage_file in stage_files:
  print(stage_file)

-- Example 11727
ALTER WAREHOUSE mywarehouse RESUME;

-- Example 11728
COPY INTO mytable from @~/staged FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

-- Example 11729
COPY INTO mytable FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);

-- Example 11730
COPY INTO mytable from @my_stage;

-- Example 11731
COPY FILES
  INTO @trg_stage
  FROM @src_stage;

-- Example 11732
split [-a suffix_length] [-b byte_count[k|m]] [-l line_count] [-p pattern] [file [name]]

-- Example 11733
split -l 100000 pagecounts-20151201.csv pages

-- Example 11734
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2025_02');

-- Example 11735
CREATE OR REPLACE TABLE my_table (
  c1 VARCHAR(134217728),
  c2 BINARY(67108864));

-- Example 11736
ALTER TABLE my_table ALTER COLUMN col1 SET DATA TYPE VARCHAR(134217728);

-- Example 11737
CREATE OR REPLACE TABLE my_table (c1 VARIANT);

-- Example 11738
CREATE OR REPLACE FUNCTION udf_varchar(g1 VARCHAR)
  RETURNS VARCHAR
  AS $$
    'Hello' || g1
  $$;

-- Example 11739
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN col1 SET DATA TYPE VARCHAR(134217728);

-- Example 11740
100067 (54000): The data length in result column <column_name> is not supported by this version of the client.
Actual length <actual_size> exceeds supported length of 16777216.

-- Example 11741
Max LOB size (16777216) exceeded

-- Example 11742
COPY INTO <table>
  FROM @~/<file>.json
  FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY = true);

-- Example 11743
{
  "ID": 1,
  "CustomerDetails": {
    "RegistrationDate": 158415500,
    "FirstName": "John",
    "LastName": "Doe",
    "Events": [
      {
        "Type": "LOGIN",
        "Time": 1584158401,
        "EventID": "NZ0000000001"
      },
      /* ... */
      /* this array contains thousands of elements */
      /* with total size exceeding 16 MB */
      /* ... */
      {
        "Type": "LOGOUT",
        "Time": 1584158402,
        "EventID": "NZ0000000002"
      }
    ]
  }
}

-- Example 11744
CREATE OR REPLACE TABLE mytable AS
  SELECT
    t1.$1:ID AS id,
    t1.$1:CustomerDetails:RegistrationDate::VARCHAR AS RegistrationDate,
    t1.$1:CustomerDetails:FirstName::VARCHAR AS First_Name,
    t1.$1:CustomerDetails:LastName::VARCHAR AS as Last_Name,
    t2.value AS Event
  FROM @json t1,
    TABLE(FLATTEN(INPUT => $1:CustomerDetails:Events)) t2;

-- Example 11745
+----+-------------------+------------+------------+------------------------------+
| ID | REGISTRATION_DATE | FIRST_NAME | LAST_NAME  | EVENT                        |
|----+-------------------+------------+------------+------------------------------|
| 1  | 158415500         | John       | Doe        | {                            |
|    |                   |            |            |   "EventID": "NZ0000000001", |
|    |                   |            |            |   "Time": 1584158401,        |
|    |                   |            |            |   "Type": "LOGIN"            |
|    |                   |            |            | }                            |
|                     ... thousands of rows ...                                   |
| 1  | 158415500         | John       | Doe        | {                            |
|    |                   |            |            |   "EventID": "NZ0000000002", |
|    |                   |            |            |   "Time": 1584158402,        |
|    |                   |            |            |   "Type": "LOGOUT"           |
|    |                   |            |            | }                            |
+----+-------------------+------------+------------+------------------------------+

-- Example 11746
CREATE OR REPLACE TABLE mytable (
  id VARCHAR,
  registration_date VARCHAR(16777216),
  first_name VARCHAR(16777216),
  last_name VARCHAR(16777216),
  event VARCHAR(16777216));

INSERT INTO mytable
  SELECT
    t1.$1:ID,
    t1.$1:CustomerDetails:RegistrationDate::VARCHAR,
    t1.$1:CustomerDetails:FirstName::VARCHAR,
    t1.$1:CustomerDetails:LastName::VARCHAR,
    t2.value
  FROM @json t1,
    TABLE(FLATTEN(INPUT => $1:CustomerDetails:Events)) t2;

-- Example 11747
<?xml version='1.0' encoding='UTF-8'?>
<osm version="0.6" generator="osmium/1.14.0">
  <node id="197798" version="17" timestamp="2021-09-06T17:01:27Z" />
  <node id="197824" version="7" timestamp="2021-08-04T23:17:18Z" >
    <tag k="highway" v="traffic_signals"/>
  </node>
  <!--  thousands of node elements with total size exceeding 16 MB -->
  <node id="197826" version="4" timestamp="2021-08-04T16:43:28Z" />
</osm>

-- Example 11748
CREATE OR REPLACE TABLE mytable AS
  SELECT
    value:"@id" AS id,
    value:"@version" AS version,
    value:"@timestamp"::datetime AS TIMESTAMP,
    value:"$" AS tags
  FROM @mystage,
    LATERAL FLATTEN(INPUT => $1:"$")
  WHERE value:"@" = 'node';

-- Example 11749
+--------+---------+-------------------------+---------------------------------------------+
| ID     | VERSION | TIMESTAMP               | TAGS                                        |
|--------+---------+-------------------------+---------------------------------------------|
| 197798 | 17      | 2021-09-06 17:01:27.000 | ""                                          |
| 197824 | 7       | 2021-08-04 23:17:18.000 | <tag k="highway" v="traffic_signals"></tag> |
|                   ... thousands of rows ...                                              |
| 197826 | 4       | 2021-08-04 16:43:28.000 | ""                                          |
+--------+---------+-------------------------+---------------------------------------------+

-- Example 11750
CREATE OR REPLACE TABLE mytable AS
  SELECT
    ST_SIMPLIFY($1:geo, 10) AS geo
  FROM @mystage;

-- Example 11751
CREATE OR REPLACE TABLE mytable (
  id VARCHAR,
  registration_date VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR);

COPY INTO mytable (
  id,
  registration_date,
  first_name,
  last_name
) FROM (
    SELECT
      $1:ID,
      $1:CustomerDetails::OBJECT:RegistrationDate::VARCHAR,
      $1:CustomerDetails::OBJECT:FirstName::VARCHAR,
      $1:CustomerDetails::OBJECT:LastName::VARCHAR
    FROM @mystage
);

-- Example 11752
{"foo":1}

-- Example 11753
{"foo":"1"}

-- Example 11754
CREATE [ OR REPLACE ] PIPE [ IF NOT EXISTS ] <name>
  [ AUTO_INGEST = [ TRUE | FALSE ] ]
  [ ERROR_INTEGRATION = <integration_name> ]
  [ AWS_SNS_TOPIC = '<string>' ]
  [ INTEGRATION = '<string>' ]
  [ COMMENT = '<string_literal>' ]
  AS <copy_statement>

-- Example 11755
CREATE PIPE mypipe
  AS
  COPY INTO mytable
  FROM @mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 11756
CREATE PIPE mypipe2
  AS
  COPY INTO mytable(C1, C2)
  FROM (SELECT $5, $4 FROM @mystage)
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 11757
CREATE PIPE mypipe3
  AS
  (COPY INTO mytable
    FROM @mystage
    MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE
    INCLUDE_METADATA = (c1= METADATA$START_SCAN_TIME, c2=METADATA$FILENAME)
    FILE_FORMAT = (TYPE = 'JSON'));

-- Example 11758
CREATE PIPE mypipe_s3
  AUTO_INGEST = TRUE
  AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket'
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 11759
CREATE PIPE mypipe_gcs
  AUTO_INGEST = TRUE
  INTEGRATION = 'MYINT'
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 11760
CREATE PIPE mypipe_azure
  AUTO_INGEST = TRUE
  INTEGRATION = 'MYINT'
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 11761
CREATE PIPE mypipe_aws
  AUTO_INGEST = TRUE
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 11762
DROP PIPE [ IF EXISTS ] <name>

-- Example 11763
DROP PIPE mypipe;

+------------------------------+
| status                       |
|------------------------------|
| MYPIPE successfully dropped. |
+------------------------------+

-- Example 11764
DESC[RIBE] PIPE <name>

-- Example 11765
| created_on | name | database_name | schema_name | definition | owner | notification_channel | comment | integration | pattern | error_integration | invalid_reason | kind |

-- Example 11766
desc pipe mypipe;

+-------------------------------+--------+---------------+-------------+---------------------------------+----------+---------+
| created_on                    | name   | database_name | schema_name | definition                      | owner    | comment |
|-------------------------------+--------+---------------+-------------+---------------------------------+----------+---------|
| 2017-08-15 06:11:05.703 -0700 | MYPIPE | MYDATABASE    | PUBLIC      | copy into mytable from @mystage | SYSADMIN |         |
+-------------------------------+--------+---------------+-------------+---------------------------------+----------+---------+

-- Example 11767
SHOW PIPES [ LIKE '<pattern>' ]
           [ IN
                {
                  ACCOUNT                                         |

                  DATABASE                                        |
                  DATABASE <database_name>                        |

                  SCHEMA                                          |
                  SCHEMA <schema_name>                            |
                  <schema_name>

                  APPLICATION <application_name>                  |
                  APPLICATION PACKAGE <application_package_name>  |
                }
           ]

-- Example 11768
use database mydb;

show pipes;

-- Example 11769
REVOKE [ GRANT OPTION FOR ]
    {
       { globalPrivileges         | ALL [ PRIVILEGES ] } ON ACCOUNT
     | { accountObjectPrivileges  | ALL [ PRIVILEGES ] } ON { RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | CONNECTION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME } <object_name>
     | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
     | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
     | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN SCHEMA <schema_name> }
     | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
    }
  FROM [ ROLE ] <role_name> [ RESTRICT | CASCADE ]

-- Example 11770
REVOKE [ GRANT OPTION FOR ]
    {
       { CREATE SCHEMA | MODIFY | MONITOR | USAGE } [ , ... ] } ON DATABASE <object_name>
       { globalPrivileges         | ALL [ PRIVILEGES ] } ON ACCOUNT
     | { accountObjectPrivileges  | ALL [ PRIVILEGES ] } ON { RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | EXTERNAL VOLUME } <object_name>
     | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
     | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
     | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN SCHEMA <schema_name> }
     | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
    }
  FROM DATABASE ROLE <database_role_name> [ RESTRICT | CASCADE ]

-- Example 11771
globalPrivileges ::=
  {
      CREATE {
          ACCOUNT | APPLICATION | APPLICATION PACKAGE | COMPUTE POOL | DATA EXCHANGE LISTING
          | DATABASE | EXTERNAL VOLUME | FAILOVER GROUP | INTEGRATION | NETWORK POLICY
          | ORGANIZATION LISTING | ORGANIZATION PROFILE | REPLICATION GROUP | ROLE | SHARE
       | USER | WAREHOUSE
      }
      | ATTACH POLICY | AUDIT | BIND SERVICE ENDPOINT
      | APPLY {
         { AGGREGATION | AUTHENTICATION | JOIN | MASKING | PACKAGES | PASSWORD
           | PROJECTION | ROW ACCESS | SESSION } POLICY
         | TAG }
      | EXECUTE { ALERT | DATA METRIC FUNCTION | MANAGED ALERT | MANAGED TASK | TASK }
      | IMPORT { SHARE | ORGANIZATION LISTING }
      | MANAGE { ACCOUNT SUPPORT CASES | EVENT SHARING | GRANTS | LISTING AUTO FULFILLMENT | ORGANIZATION SUPPORT CASES | SHARE TARGET | USER SUPPORT CASES | WAREHOUSES }
      | MODIFY { LOG LEVEL | TRACE LEVEL | SESSION LOG LEVEL | SESSION TRACE LEVEL }
      | MONITOR { EXECUTION | SECURITY | USAGE }
      | OVERRIDE SHARE RESTRICTIONS | PURCHASE DATA EXCHANGE LISTING | RESOLVE ALL
      | READ SESSION
  }
  [ , ... ]

