-- Example 12308
SELECT * FROM mounted_db2.tables.empl_info;

-- Example 12309
CREATE OR REPLACE ROW ACCESS POLICY rap_authz_role AS (authz_role string)
RETURNS boolean ->
IS_DATABASE_ROLE_IN_SESSION(authz_role);

-- Example 12310
ALTER TABLE allowed_roles
  ADD ROW ACCESS POLICY rap_authz_role ON (authz_role);

-- Example 12311
CREATE OR REPLACE ROW ACCESS POLICY rap_authz_role_map AS (authz_role string)
RETURNS boolean ->
EXISTS (
  SELECT 1 FROM mapping_table m
  WHERE authz_role = m.key AND IS_DATABASE_ROLE_IN_SESSION(m.role_name)
);

-- Example 12312
ALTER TABLE allowed_roles
  ADD ROW ACCESS POLICY rap_authz_role_map ON (authz_role);

-- Example 12313
CREATE [ OR REPLACE ] ROW ACCESS POLICY [ IF NOT EXISTS ] <name> AS
( <arg_name> <arg_type> [ , ... ] ) RETURNS BOOLEAN -> <body>
[ COMMENT = '<string_literal>' ]

-- Example 12314
create or replace row access policy rap_it as (empl_id varchar) returns boolean ->
  case
      when 'it_admin' = current_role() then true
      else false
  end
;

-- Example 12315
use role securityadmin;

create or replace row access policy rap_sales_manager_regions_1 as (sales_region varchar) returns boolean ->
  'sales_executive_role' = current_role()
      or exists (
            select 1 from salesmanagerregions
              where sales_manager = current_role()
                and region = sales_region
          )
;

-- Example 12316
create or replace row access policy rap_test2 as (n number, v varchar)
  returns boolean -> true;

-- Example 12317
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

-- Example 12318
CREATE [ OR REPLACE ] [ TRANSIENT ] DYNAMIC TABLE <name>
  CLONE <source_dynamic_table>
        [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
  [
    COPY GRANTS
    TARGET_LAG = { '<num> { seconds | minutes | hours | days }' | DOWNSTREAM }
    WAREHOUSE = <warehouse_name>
  ]

-- Example 12319
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

-- Example 12320
Dynamic Table is not initialized. Please run a manual refresh or wait for a scheduled refresh before querying.

-- Example 12321
CREATE DYNAMIC TABLE product (pre_tax_profit, taxes, after_tax_profit)
  TARGET_LAG = '20 minutes'
    WAREHOUSE = mywh
    AS
      SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
      FROM staging_table;

-- Example 12322
CREATE DYNAMIC TABLE product (pre_tax_profit COMMENT 'revenue minus cost',
                taxes COMMENT 'assumes taxes are a fixed percentage of profit',
                after_tax_profit)
  TARGET_LAG = '20 minutes'
    WAREHOUSE = mywh
    AS
      SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
      FROM staging_table;

-- Example 12323
CREATE OR REPLACE DYNAMIC TABLE product
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = mywh
  AS
    SELECT * FROM staging_table
    COPY GRANTS;

-- Example 12324
CREATE OR REPLACE DYNAMIC TABLE product
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 12325
CREATE DYNAMIC ICEBERG TABLE product (date TIMESTAMP_NTZ, id NUMBER, content STRING)
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my_iceberg_table'
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 12326
CREATE DYNAMIC TABLE product (date TIMESTAMP_NTZ, id NUMBER, content VARIANT)
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  CLUSTER BY (date, id)
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 12327
CREATE DYNAMIC TABLE product_clone CLONE product AT (TIMESTAMP => TO_TIMESTAMP_TZ('04/05/2013 01:02:03', 'mm/dd/yyyy hh24:mi:ss'));

-- Example 12328
CREATE DYNAMIC TABLE product
  TARGET_LAG = 'DOWNSTREAM'
  WAREHOUSE = mywh
  INITIALIZE = on_schedule
  REQUIRE USER
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 12329
ALTER DYNAMIC TABLE product REFRESH COPY SESSION;

-- Example 12330
{ DESCRIBE | DESC } TABLE <name> [ TYPE =  { COLUMNS | STAGE } ]

-- Example 12331
CREATE OR REPLACE TABLE desc_example(
  c1 INT PRIMARY KEY,
  c2 INT,
  c3 INT UNIQUE,
  c4 VARCHAR(30) DEFAULT 'Not applicable' COMMENT 'This column is rarely populated',
  c5 VARCHAR(100));

-- Example 12332
DESCRIBE TABLE desc_example;

-- Example 12333
+------+--------------+--------+-------+------------------+-------------+------------+-------+------------+---------------------------------+-------------+----------------+-------------------------+
| name | type         | kind   | null? | default          | primary key | unique key | check | expression | comment                         | policy name | privacy domain | schema evolution record |
|------+--------------+--------+-------+------------------+-------------+------------+-------+------------+---------------------------------+-------------+----------------+-------------------------|
| C1   | NUMBER(38,0) | COLUMN | N     | NULL             | Y           | N          | NULL  | NULL       | NULL                            | NULL        | NULL           | NULL                    |
| C2   | NUMBER(38,0) | COLUMN | Y     | NULL             | N           | N          | NULL  | NULL       | NULL                            | NULL        | NULL           | NULL                    |
| C3   | NUMBER(38,0) | COLUMN | Y     | NULL             | N           | Y          | NULL  | NULL       | NULL                            | NULL        | NULL           | NULL                    |
| C4   | VARCHAR(30)  | COLUMN | Y     | 'Not applicable' | N           | N          | NULL  | NULL       | This column is rarely populated | NULL        | NULL           | NULL                    |
| C5   | VARCHAR(100) | COLUMN | Y     | NULL             | N           | N          | NULL  | NULL       | NULL                            | NULL        | NULL           | NULL                    |
+------+--------------+--------+-------+------------------+-------------+------------+-------+------------+---------------------------------+-------------+----------------+-------------------------+

-- Example 12334
CREATE OR REPLACE TABLE desc_example(
  c1 INT PRIMARY KEY,
  c2 INT,
  c3 INT UNIQUE,
  c4 VARCHAR(30) DEFAULT 'Not applicable' COMMENT 'This column is rarely populated',
  c5 VARCHAR(100) WITH MASKING POLICY email_mask);

-- Example 12335
+------+--------------+--------+-------+------------------+-------------+------------+-------+------------+---------------------------------+---------------------------------+----------------+-------------------------+
| name | type         | kind   | null? | default          | primary key | unique key | check | expression | comment                         | policy name                     | privacy domain | schema evolution record |
|------+--------------+--------+-------+------------------+-------------+------------+-------+------------+---------------------------------+---------------------------------+----------------|-------------------------|
| C1   | NUMBER(38,0) | COLUMN | N     | NULL             | Y           | N          | NULL  | NULL       | NULL                            | NULL                            | NULL           | NULL                    |
| C2   | NUMBER(38,0) | COLUMN | Y     | NULL             | N           | N          | NULL  | NULL       | NULL                            | NULL                            | NULL           | NULL                    |
| C3   | NUMBER(38,0) | COLUMN | Y     | NULL             | N           | Y          | NULL  | NULL       | NULL                            | NULL                            | NULL           | NULL                    |
| C4   | VARCHAR(30)  | COLUMN | Y     | 'Not applicable' | N           | N          | NULL  | NULL       | This column is rarely populated | NULL                            | NULL           | NULL                    |
| C5   | VARCHAR(100) | COLUMN | Y     | NULL             | N           | N          | NULL  | NULL       | NULL                            | HT_SENSORS.HT_SCHEMA.EMAIL_MASK | NULL           | NULL                    |
+------+--------------+--------+-------+------------------+-------------+------------+-------+------------+---------------------------------+---------------------------------+----------------+-------------------------+

-- Example 12336
DESCRIBE TABLE desc_example TYPE = STAGE;

-- Example 12337
+--------------------+--------------------------------+---------------+-----------------+------------------+
| parent_property    | property                       | property_type | property_value  | property_default |
|--------------------+--------------------------------+---------------+-----------------+------------------|
| STAGE_FILE_FORMAT  | TYPE                           | String        | CSV             | CSV              |
| STAGE_FILE_FORMAT  | RECORD_DELIMITER               | String        | \n              | \n               |
| STAGE_FILE_FORMAT  | FIELD_DELIMITER                | String        | ,               | ,                |
| STAGE_FILE_FORMAT  | FILE_EXTENSION                 | String        |                 |                  |
| STAGE_FILE_FORMAT  | SKIP_HEADER                    | Integer       | 0               | 0                |
...

-- Example 12338
DESC[RIBE] VIEW <name>

-- Example 12339
CREATE VIEW emp_view AS SELECT id "Employee Number", lname "Last Name", location "Home Base" FROM emp;

-- Example 12340
DESC VIEW emp_view;

+-----------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+-----------------+
| name            | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |  privacy domain |
|-----------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+-----------------+
| Employee Number | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL            |
| Last Name       | VARCHAR(50)  | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL            |
| Home Base       | VARCHAR(100) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL            |
+-----------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+-----------------+

-- Example 12341
-- Partitions computed from expressions
CREATE [ OR REPLACE ] EXTERNAL TABLE [IF NOT EXISTS]
  <table_name>
    ( [ <col_name> <col_type> AS <expr> | <part_col_name> <col_type> AS <part_expr> ]
      [ inlineConstraint ]
      [ , <col_name> <col_type> AS <expr> | <part_col_name> <col_type> AS <part_expr> ... ]
      [ , ... ] )
  cloudProviderParams
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  [ WITH ] LOCATION = externalStage
  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ PATTERN = '<regex_pattern>' ]
  FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET } [ formatTypeOptions ] } )
  [ AWS_SNS_TOPIC = '<string>' ]
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON (VALUE) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Partitions added and removed manually
CREATE [ OR REPLACE ] EXTERNAL TABLE [IF NOT EXISTS]
  <table_name>
    ( [ <col_name> <col_type> AS <expr> | <part_col_name> <col_type> AS <part_expr> ]
      [ inlineConstraint ]
      [ , <col_name> <col_type> AS <expr> | <part_col_name> <col_type> AS <part_expr> ... ]
      [ , ... ] )
  cloudProviderParams
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  [ WITH ] LOCATION = externalStage
  PARTITION_TYPE = USER_SPECIFIED
  FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET } [ formatTypeOptions ] } )
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON (VALUE) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Delta Lake
CREATE [ OR REPLACE ] EXTERNAL TABLE [IF NOT EXISTS]
  <table_name>
    ( [ <col_name> <col_type> AS <expr> | <part_col_name> <col_type> AS <part_expr> ]
      [ inlineConstraint ]
      [ , <col_name> <col_type> AS <expr> | <part_col_name> <col_type> AS <part_expr> ... ]
      [ , ... ] )
  cloudProviderParams
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  [ WITH ] LOCATION = externalStage
  PARTITION_TYPE = USER_SPECIFIED
  FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET } [ formatTypeOptions ] } )
  [ TABLE_FORMAT = DELTA ]
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON (VALUE) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 12342
inlineConstraint ::=
  [ NOT NULL ]
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> ] ) ] }
  [ <constraint_properties> ]

-- Example 12343
cloudProviderParams (for Google Cloud Storage) ::=
  [ INTEGRATION = '<integration_name>' ]

cloudProviderParams (for Microsoft Azure) ::=
  [ INTEGRATION = '<integration_name>' ]

-- Example 12344
externalStage ::=
  @[<namespace>.]<ext_stage_name>[/<path>]

-- Example 12345
formatTypeOptions ::=
-- If FILE_FORMAT = ( TYPE = CSV ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
     SKIP_HEADER = <integer>
     SKIP_BLANK_LINES = TRUE | FALSE
     ESCAPE_UNENCLOSED_FIELD = '<character>' | NONE
     TRIM_SPACE = TRUE | FALSE
     FIELD_OPTIONALLY_ENCLOSED_BY = '<character>' | NONE
     NULL_IF = ( '<string1>' [ , '<string2>' , ... ] )
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     ENCODING = '<string>'
-- If FILE_FORMAT = ( TYPE = JSON ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     MULTI_LINE = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
-- If FILE_FORMAT = ( TYPE = AVRO ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
-- If FILE_FORMAT = ( TYPE = ORC ... )
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ]
-- If FILE_FORMAT = ( TYPE = PARQUET ... )
     COMPRESSION = AUTO | SNAPPY | NONE
     BINARY_AS_TEXT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE

-- Example 12346
CREATE [ OR REPLACE ] EXTERNAL TABLE <table_name>
  [ COPY GRANTS ]
  USING TEMPLATE <query>
  [ ... ]

-- Example 12347
mycol varchar as (value:c1::varchar)

-- Example 12348
{ "a":"1", "b": { "c":"2", "d":"3" } }

-- Example 12349
mycol varchar as (value:"b"."c"::varchar)

-- Example 12350
col1 varchar as (parse_json(metadata$external_table_partition):col1::varchar),
col2 number as (parse_json(metadata$external_table_partition):col2::number),
col3 timestamp_tz as (parse_json(metadata$external_table_partition):col3::timestamp_tz)

-- Example 12351
|"Hello world"|    /* returned as */  >Hello world<
|" Hello world "|  /* returned as */  > Hello world <
| "Hello world" |  /* returned as */  >Hello world<

-- Example 12352
CREATE STAGE s1
  URL='s3://mybucket/files/logs/'
  ...
  ;

-- Example 12353
CREATE STAGE s1
  URL='gcs://mybucket/files/logs/'
  ...
  ;

-- Example 12354
CREATE STAGE s1
  URL='azure://mycontainer/files/logs/'
  ...
  ;

-- Example 12355
SELECT metadata$filename FROM @s1/;

+----------------------------------------+
| METADATA$FILENAME                      |
|----------------------------------------|
| files/logs/2018/08/05/0524/log.parquet |
| files/logs/2018/08/27/1408/log.parquet |
+----------------------------------------+

-- Example 12356
CREATE EXTERNAL TABLE et1(
 date_part date AS TO_DATE(SPLIT_PART(metadata$filename, '/', 3)
   || '/' || SPLIT_PART(metadata$filename, '/', 4)
   || '/' || SPLIT_PART(metadata$filename, '/', 5), 'YYYY/MM/DD'),
 timestamp bigint AS (value:timestamp::bigint),
 col2 varchar AS (value:col2::varchar))
 PARTITION BY (date_part)
 LOCATION=@s1/logs/
 AUTO_REFRESH = true
 FILE_FORMAT = (TYPE = PARQUET)
 AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket';

-- Example 12357
CREATE EXTERNAL TABLE et1(
  date_part date AS TO_DATE(SPLIT_PART(metadata$filename, '/', 3)
    || '/' || SPLIT_PART(metadata$filename, '/', 4)
    || '/' || SPLIT_PART(metadata$filename, '/', 5), 'YYYY/MM/DD'),
  timestamp bigint AS (value:timestamp::bigint),
  col2 varchar AS (value:col2::varchar))
  PARTITION BY (date_part)
  LOCATION=@s1/logs/
  AUTO_REFRESH = true
  FILE_FORMAT = (TYPE = PARQUET);

-- Example 12358
CREATE EXTERNAL TABLE et1(
  date_part date AS TO_DATE(SPLIT_PART(metadata$filename, '/', 3)
    || '/' || SPLIT_PART(metadata$filename, '/', 4)
    || '/' || SPLIT_PART(metadata$filename, '/', 5), 'YYYY/MM/DD'),
  timestamp bigint AS (value:timestamp::bigint),
  col2 varchar AS (value:col2::varchar))
  PARTITION BY (date_part)
  INTEGRATION = 'MY_INT'
  LOCATION=@s1/logs/
  AUTO_REFRESH = true
  FILE_FORMAT = (TYPE = PARQUET);

-- Example 12359
ALTER EXTERNAL TABLE et1 REFRESH;

-- Example 12360
SELECT timestamp, col2 FROM et1 WHERE date_part = to_date('08/05/2018');

-- Example 12361
CREATE STAGE s2
  URL='s3://mybucket/files/logs/'
  ...
  ;

-- Example 12362
CREATE STAGE s2
  URL='gcs://mybucket/files/logs/'
  ...
  ;

-- Example 12363
CREATE STAGE s2
  URL='azure://mycontainer/files/logs/'
  ...
  ;

-- Example 12364
create external table et2(
  col1 date as (parse_json(metadata$external_table_partition):COL1::date),
  col2 varchar as (parse_json(metadata$external_table_partition):COL2::varchar),
  col3 number as (parse_json(metadata$external_table_partition):COL3::number))
  partition by (col1,col2,col3)
  location=@s2/logs/
  partition_type = user_specified
  file_format = (type = parquet);

-- Example 12365
ALTER EXTERNAL TABLE et2 ADD PARTITION(col1='2022-01-24', col2='a', col3='12') LOCATION '2022/01';

-- Example 12366
+---------------------------------------+----------------+-------------------------------+
|                       file            |     status     |          description          |
+---------------------------------------+----------------+-------------------------------+
| mycontainer/files/logs/2022/01/24.csv | REGISTERED_NEW | File registered successfully. |
| mycontainer/files/logs/2022/01/25.csv | REGISTERED_NEW | File registered successfully. |
+---------------------------------------+----------------+-------------------------------+

-- Example 12367
SELECT col1, col2, col3 FROM et1 WHERE col1 = TO_DATE('2022-01-24') AND col2 = 'a' ORDER BY METADATA$FILE_ROW_NUMBER;

-- Example 12368
CREATE MATERIALIZED VIEW et1_mv
  AS
  SELECT col2 FROM et1;

-- Example 12369
CREATE EXTERNAL TABLE mytable
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(
      INFER_SCHEMA(
        LOCATION=>'@mystage',
        FILE_FORMAT=>'my_parquet_format'
      )
    )
  )
  LOCATION=@mystage
  FILE_FORMAT=my_parquet_format
  AUTO_REFRESH=false;

-- Example 12370
CREATE EXTERNAL TABLE mytable
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT('COLUMN_NAME',COLUMN_NAME, 'TYPE',TYPE, 'NULLABLE', NULLABLE, 'EXPRESSION',EXPRESSION))
    FROM TABLE(
      INFER_SCHEMA(
        LOCATION=>'@mystage',
        FILE_FORMAT=>'my_parquet_format'
      )
    )
  )
  LOCATION=@mystage
  FILE_FORMAT=my_parquet_format
  AUTO_REFRESH=false;

-- Example 12371
SELECT * FROM TABLE(get_widgets_function()) ORDER BY created_on;

------+-----------------------+-------+-------+-------------------------------+
  ID  |         NAME          | COLOR | PRICE |          CREATED_ON           |
------+-----------------------+-------+-------+-------------------------------+
...
 315  | Small round widget    | Red   | 1     | 2017-01-07 15:22:14.810 -0700 |
 1455 | Small cylinder widget | Blue  | 2     | 2017-01-15 03:00:12.106 -0700 |
...

-- Example 12372
SHOW FUNCTIONS LIKE 'MYFUNCTION';

-- Example 12373
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing (referred entity <- [referring entities])

-- Example 12374
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referredentity <- [referring entities])

