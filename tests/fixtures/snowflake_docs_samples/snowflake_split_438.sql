-- Example 29320
CREATE OR REPLACE TABLE table_with_default(x INT, v TEXT DEFAULT x::VARCHAR);

-- Example 29321
SELECT GET_DDL('table', 'table_with_default');

-- Example 29322
create or replace TABLE TABLE_WITH_DEFAULT ( |
      X NUMBER(38,0),
      V VARCHAR(16777216) DEFAULT CAST(TABLE_WITH_DEFAULT.X AS VARCHAR(16777216))
);

-- Example 29323
create or replace TABLE TABLE_WITH_DEFAULT ( |
      X NUMBER(38,0),
      V VARCHAR(16777216) DEFAULT CAST(TABLE_WITH_DEFAULT.X AS VARCHAR)
);

-- Example 29324
CREATE OR REPLACE EXTERNAL TABLE ext_table(
    data_str VARCHAR AS (value:c1::TEXT))
  LOCATION = @csv_stage
  AUTO_REFRESH = false
  FILE_FORMAT =(type = csv);

-- Example 29325
SELECT GET_DDL('table', 'ext_table');

-- Example 29326
create or replace external table EXT_TABLE(
      DATA_STR VARCHAR(16777216) AS (CAST(GET(VALUE, 'c1') AS VARCHAR(16777216))))
location=@CSV_STAGE/
auto_refresh=false
file_format=(TYPE=csv)
;

-- Example 29327
create or replace external table EXT_TABLE(
      DATA_STR VARCHAR(16777216) AS (CAST(GET(VALUE, 'c1') AS VARCHAR)))
location=@CSV_STAGE/
auto_refresh=false
file_format=(TYPE=csv)
;

-- Example 29328
SELECT SYSTEM$TYPEOF(REPEAT('a',10));

-- Example 29329
VARCHAR(16777216)[LOB]

-- Example 29330
VARCHAR[LOB]

-- Example 29331
CREATE OR REPLACE TABLE t AS
  SELECT TO_VARIANT('abc') AS col;

SHOW COLUMNS IN t;

-- Example 29332
{
  "type":"VARIANT",
  "length":16777216,
  "byteLength":16777216,
  "nullable":true,
  "fixed":false
}

-- Example 29333
{
  "type":"VARIANT",
  "nullable":true,
  "fixed":false
}

-- Example 29334
CREATE OR REPLACE FILE FORMAT json_format TYPE = JSON;

CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR) AS
  SELECT $1::VARCHAR
    FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format');

-- Example 29335
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29336
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29337
CREATE or REPLACE FILE FORMAT xml_format TYPE = XML;

CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR) AS
  SELECT $1 AS XML
    FROM @lob_int_stage/large_xml.xte (FILE_FORMAT => 'xml_format');

-- Example 29338
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29339
100078 (22000): String '<string_preview>' is too long and would be truncated

-- Example 29340
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar FROM (
  SELECT $1::VARCHAR
    FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format'));

-- Example 29341
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29342
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29343
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar FROM (
  SELECT $1:"Driver_Status"
    FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format'));

-- Example 29344
100069 (22P02): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29345
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29346
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar FROM (
  SELECT $1::VARCHAR AS lob_column
    FROM @lob_int_stage/large_xml.xte (FILE_FORMAT => 'xml_format'));

-- Example 29347
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29348
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29349
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar (lob_column)
  FROM @lob_int_stage/driver_status.json.gz
  FILE_FORMAT = (FORMAT_NAME = json_format);

-- Example 29350
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29351
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29352
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar (lob_column)
  FROM @lob_int_stage/large_xml.xte
  FILE_FORMAT = (FORMAT_NAME = xml_format);

-- Example 29353
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29354
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29355
SELECT $1
  FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format');

-- Example 29356
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29357
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29358
SELECT $1 as lob_column
  FROM @lob_int_stage/large_xml.xte (FILE_FORMAT => 'xml_format');

-- Example 29359
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29360
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29361
SELECT $1
  FROM @lob_int_stage/driver_status.csv.gz (FILE_FORMAT => 'csv_format');

-- Example 29362
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29363
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29364
SELECT $1
  FROM @lob_int_stage/driver_status.parquet (FILE_FORMAT => 'parquet_format');

-- Example 29365
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29366
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29367
SELECT large_str || large_str FROM lob_strings;

-- Example 29368
100078 (22000): String '<preview_of_string>' is too long and would be truncated in 'CONCAT'

-- Example 29369
100067 (54000): The data length in result column <column_name> is not supported by this version of the client. Actual length <actual_size> exceeds supported length of 16777216.

-- Example 29370
CREATE OR REPLACE TABLE table_varchar
  AS SELECT large_str || large_str as LOB_column
  FROM lob_strings;

-- Example 29371
100078 (22000): String '<preview_of_string>' is too long and would be truncated in 'CONCAT'

-- Example 29372
100067 (54000): The data length in result column <column_name> is not supported by this version of the client. Actual length <actual_size> exceeds supported length of 16777216.

-- Example 29373
SELECT ARRAY_AGG(status) FROM lob_object;

-- Example 29374
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29375
100067 (54000): The data length in result column <column_name> is not supported by this version of the client. Actual length <actual_size> exceeds supported length of 16777216.

-- Example 29376
+-----------------------------------------------------------+
| RESOURCE_ATTRIBUTES                                       |
|-----------------------------------------------------------|
| {                                                         |
|   "snow.account.name": "SPCSDOCS1",                       |
|   "snow.compute_pool.id": 20,                             |
|   "snow.compute_pool.name": "TUTORIAL_COMPUTE_POOL",      |
|   "snow.compute_pool.node.id": "a17e8157",                |
|   "snow.compute_pool.node.instance_family": "CPU_X64_XS", |
|   "snow.database.id": 26,                                 |
|   "snow.database.name": "TUTORIAL_DB",                    |
|   "snow.schema.id": 212,                                  |
|   "snow.schema.name": "DATA_SCHEMA",                      |
|   "snow.service.container.instance": "0",                 |
|   "snow.service.container.name": "echo",                  |
|   "snow.service.container.run.id": "b30566",              |
|   "snow.service.id": 114,                                 |
|   "snow.service.name": "ECHO_SERVICE2",                   |
|   "snow.service.type": "Service"                          |
| }                                                         |
+-----------------------------------------------------------+

-- Example 29377
GRANT MANAGE SHARE TARGET ON ACCOUNT TO ROLE <role-name>;
GRANT ROLE <role-name> TO USER <user_name>;

USE ROLE <role-name>;
ALTER SHARE <data_share_name> ADD ACCOUNTS = '<account_name_1>', '<account_name_2>';

-- Example 29378
SELECT SYSTEM$GET_SERVICE_DNS_DOMAIN('mydb.myschema');

-- Example 29379
ALTER ACCOUNT SET EVENT_TABLE = NONE

-- Example 29380
003540 (42501): SQL execution error:
  Creating table on shared database '<database_name>'
  is not allowed.

-- Example 29381
003001 (42501): SQL access control error:
  Insufficient privileges to operate on schema '<schema_name>'

-- Example 29382
{
  "argumentSignature": (function_signature varchar),
  "objectName": "23662386A408C571B77FDC53691793E4992D1C12.SCHEMA_NAME.FUNCTION_NAME",
  "objectDomain": "Function"
}

-- Example 29383
{
  "argumentSignature": (function_signature varchar),
  "objectName": "23662386A408C571B77FDC53691793E4992D1C12.SCHEMA_NAME.PROCEDURE_NAME",
  "objectDomain":"Procedure"
}

-- Example 29384
[
  {
    "Columns": [
      {
        "columnName": "column1_name"
      },
      {
        "columnName": "column2_name"
      }
    ],
    "objectDomain":"VIEW",
    "objectName": "5F3297829072D2E23B852D7787825FF762E74EF3.PUBLIC.VIEW_1"
  },
  {
    "Columns": [
      {
        "columnName": "column3_name"
      },
      {
        "columnName": "column4_name"
      }
    ],
    "objectDomain":"TABLE",
    "objectName": "D85A2CE1531C6C1E077FA701713047305BDF5A83.PUBLIC.TABLE1"
  }
]

-- Example 29385
Application package <pkg> failed validation during version creation: ....<details of error>

-- Example 29386
CREATE OR REPLACE TEMPORARY READ ONLY TABLE <table_name> CLONE <src_table_name>

