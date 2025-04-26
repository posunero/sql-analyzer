-- Example 17198
profiler.register_modules()

-- Example 17199
CREATE OR REPLACE PROCEDURE profiler_test_proc()
RETURNS NUMBER
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'main'
AS
$$
from snowflake.snowpark.functions import col, udf

def main(session):
  df = session.sql("select 1")
  return df.collect()[0][0]
$$;

-- Example 17200
profiler = profiler_session.stored_procedure_profiler
profiler.register_modules(["profiler_test_proc"])
profiler.set_target_stage(
  f"{db_parameters['database']}.{db_parameters['schema']}.{tmp_stage_name}"
)

profiler.set_active_profiler("LINE")

profiler_session.call("profiler_test_proc")
res = profiler.get_output()
print(res)

profiler.disable()
profiler.register_modules([])

-- Example 17201
Handler Name: main
Python Runtime Version: 3.8
Modules Profiled: ['main_module']
Timer Unit: 0.001 s

Total Time: 0.0619571 s
File: _udf_code.py
Function: main at line 4

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
     4                                           def main(session):
     5         1          0.4      0.4      0.6      df = session.sql("select 1")
     6         1         61.6     61.6     99.4      return df.collect()[0][0]

-- Example 17202
volumes:
  - name: <name>
    source: block
    size: <size in Gi>
    blockConfig:                             # optional
      initialContents:
        fromSnapshot: <snapshot name>
      iops: <number-of-operations>
      throughput: <MiB per second>

-- Example 17203
volumes:
  - name: vol-1
    source: block
    size: 200Gi
    blockConfig:
      initialContents:
        fromSnapshot: snapshot1
      iops: 3000
      throughput: 125

-- Example 17204
CREATE [ OR REPLACE ] EXTERNAL VOLUME [IF NOT EXISTS]
  <name>
  STORAGE_LOCATIONS =
    (
      (
        NAME = '<storage_location_name>'
        { cloudProviderParams | s3CompatibleStorageParams }
      )
      [, (...), ...]
    )
  [ ALLOW_WRITES = { TRUE | FALSE }]
  [ COMMENT = '<string_literal>' ]

-- Example 17205
cloudProviderParams (for Amazon S3) ::=
  STORAGE_PROVIDER = '{ S3 | S3GOV }'
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_BASE_URL = '<protocol>://<bucket>[/<path>/]'
  [ STORAGE_AWS_ACCESS_POINT_ARN = '<string>' ]
  [ STORAGE_AWS_EXTERNAL_ID = '<external_id>' ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_SSE_S3' ] |
              [ TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ] ] |
              [ TYPE = 'NONE' ] ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 17206
cloudProviderParams (for Google Cloud Storage) ::=
  STORAGE_PROVIDER = 'GCS'
  STORAGE_BASE_URL = 'gcs://<bucket>[/<path>/]'
  [ ENCRYPTION = ( [ TYPE = 'GCS_SSE_KMS' ] [ KMS_KEY_ID = '<string>' ] |
              [ TYPE = 'NONE' ] ) ]

-- Example 17207
cloudProviderParams (for Microsoft Azure) ::=
  STORAGE_PROVIDER = 'AZURE'
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_BASE_URL = 'azure://...'
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 17208
s3CompatibleStorageParams ::=
  STORAGE_PROVIDER = 'S3COMPAT'
  STORAGE_BASE_URL = 's3compat://<bucket>[/<path>/]'
  CREDENTIALS = ( AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' )
  STORAGE_ENDPOINT = '<s3_api_compatible_endpoint>'

-- Example 17209
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "external_volume_name" = 'my_external_volume_1';

-- Example 17210
CREATE OR REPLACE EXTERNAL VOLUME exvol
  STORAGE_LOCATIONS =
      (
        (
            NAME = 'my-s3-us-west-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://my-example-bucket/'
            STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/myrole'
            ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID='1234abcd-12ab-34cd-56ef-1234567890ab')
        )
      )
  ALLOW_WRITES = TRUE;

-- Example 17211
CREATE EXTERNAL VOLUME exvol
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-us-east-1'
        STORAGE_PROVIDER = 'GCS'
        STORAGE_BASE_URL = 'gcs://mybucket1/path1/'
        ENCRYPTION=(TYPE='GCS_SSE_KMS' KMS_KEY_ID = '1234abcd-12ab-34cd-56ef-1234567890ab')
      )
    )
  ALLOW_WRITES = TRUE;

-- Example 17212
CREATE EXTERNAL VOLUME exvol
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-azure-northeurope'
        STORAGE_PROVIDER = 'AZURE'
        STORAGE_BASE_URL = 'azure://exampleacct.blob.core.windows.net/my_container_northeurope/'
        AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
      )
    )
  ALLOW_WRITES = TRUE;

-- Example 17213
CREATE OR REPLACE EXTERNAL VOLUME ext_vol_s3_compat
  STORAGE_LOCATIONS = (
    (
      NAME = 'my_s3_compat_storage_location'
      STORAGE_PROVIDER = 'S3COMPAT'
      STORAGE_BASE_URL = 's3compat://mybucket/unload/mys3compatdata'
      CREDENTIALS = (
        AWS_KEY_ID = '1a2b3c...'
        AWS_SECRET_KEY = '4x5y6z...'
      )
      STORAGE_ENDPOINT = 'example.com'
    )
  )
  ALLOW_WRITES = FALSE;

-- Example 17214
CREATE [ OR REPLACE ] APPLICATION ROLE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 17215
CREATE OR ALTER APPLICATION ROLE <name>
  [ COMMENT = '<string_literal>' ]

-- Example 17216
CREATE APPLICATION ROLE app_role
  COMMENT = 'Application role for the Hello Snowflake application.';

-- Example 17217
CREATE [ OR REPLACE ] [ TRANSIENT ] DATABASE [ IF NOT EXISTS ] <name>
    [ CLONE <source_schema>
        [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
        [ IGNORE TABLES WITH INSUFFICIENT DATA RETENTION ]
        [ IGNORE HYBRID TABLES ] ]
    [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
    [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
    [ EXTERNAL_VOLUME = <external_volume_name> ]
    [ CATALOG = <catalog_integration_name> ]
    [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
    [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
    [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
    [ COMMENT = '<string_literal>' ]
    [ CATALOG_SYNC = '<snowflake_open_catalog_integration_name>' ]
    [ CATALOG_SYNC_NAMESPACE_MODE = { NEST | FLATTEN } ]
    [ CATALOG_SYNC_NAMESPACE_FLATTEN_DELIMITER = '<string_literal>' ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 17218
CREATE DATABASE <name> FROM LISTING '<listing_global_name>'

-- Example 17219
CREATE DATABASE <name> FROM SHARE <provider_account>.<share_name>

-- Example 17220
CREATE DATABASE <name>
    AS REPLICA OF <account_identifier>.<primary_db_name>
    [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]

-- Example 17221
CREATE OR ALTER [ TRANSIENT ] DATABASE <name>
    [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
    [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
    [ EXTERNAL_VOLUME = <external_volume_name> ]
    [ CATALOG = <catalog_integration_name> ]
    [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
    [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
    [ LOG_LEVEL = '<log_level>' ]
    [ TRACE_LEVEL = '<trace_level>' ]
    [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
    [ COMMENT = '<string_literal>' ]

-- Example 17222
CREATE [ OR REPLACE ] DATABASE [ IF NOT EXISTS ] <name> CLONE <source_database>
  [ ... ]

-- Example 17223
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 17224
-- determine the active warehouse in the current session (if any)
SELECT CURRENT_WAREHOUSE();

+---------------------+
| CURRENT_WAREHOUSE() |
|---------------------|
| MY_WH               |
+---------------------+

-- change the STATEMENT_TIMEOUT_IN_SECONDS value for the active warehouse

ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 17225
ALTER WAREHOUSE my_wh UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- Example 17226
CREATE DATABASE mytestdb;

CREATE DATABASE mytestdb2 DATA_RETENTION_TIME_IN_DAYS = 10;

SHOW DATABASES LIKE 'my%';

+---------------------------------+------------+------------+------------+--------+----------+---------+---------+----------------+
| created_on                      | name       | is_default | is_current | origin | owner    | comment | options | retention_time |
|---------------------------------+------------+------------+------------+--------+----------+---------+---------+----------------|
| Tue, 17 Mar 2016 16:57:04 -0700 | MYTESTDB   | N          | N          |        | PUBLIC   |         |         | 1              |
| Tue, 17 Mar 2016 17:06:32 -0700 | MYTESTDB2  | N          | N          |        | PUBLIC   |         |         | 10             |
+---------------------------------+------------+------------+------------+--------+----------+---------+---------+----------------+

-- Example 17227
CREATE TRANSIENT DATABASE mytransientdb;

SHOW DATABASES LIKE 'my%';

+---------------------------------+---------------+------------+------------+--------+----------+---------+-----------+----------------+
| created_on                      | name          | is_default | is_current | origin | owner    | comment | options   | retention_time |
|---------------------------------+---------------+------------+------------+--------+----------+---------+-----------+----------------|
| Tue, 17 Mar 2016 16:57:04 -0700 | MYTESTDB      | N          | N          |        | PUBLIC   |         |           | 1              |
| Tue, 17 Mar 2016 17:06:32 -0700 | MYTESTDB2     | N          | N          |        | PUBLIC   |         |           | 10             |
| Tue, 17 Mar 2015 17:07:51 -0700 | MYTRANSIENTDB | N          | N          |        | PUBLIC   |         | TRANSIENT | 1              |
+---------------------------------+---------------+------------+------------+--------+----------+---------+-----------+----------------+

-- Example 17228
CREATE DATABASE snow_sales FROM SHARE ab67890.sales_s;

-- Example 17229
CREATE OR ALTER DATABASE db1;

-- Example 17230
CREATE OR ALTER DATABASE db1
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 17231
CREATE OR ALTER DATABASE db1
  DEFAULT_DDL_COLLATION = 'de';

-- Example 17232
CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 17233
CREATE OR ALTER ROLE <name>
  [ COMMENT = '<string_literal>' ]

-- Example 17234
CREATE ROLE myrole;

-- Example 17235
-- Internal stage
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] STAGE [ IF NOT EXISTS ] <internal_stage_name>
    internalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- External stage
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] STAGE [ IF NOT EXISTS ] <external_stage_name>
    externalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 17236
internalStageParams ::=
  [ ENCRYPTION = (   TYPE = 'SNOWFLAKE_FULL'
                   | TYPE = 'SNOWFLAKE_SSE' ) ]

-- Example 17237
externalStageParams (for Amazon S3) ::=
  URL = '<protocol>://<bucket>[/<path>/]'
  [ AWS_ACCESS_POINT_ARN = '<string>' ]
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } | AWS_ROLE = '<string>'  } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] MASTER_KEY = '<string>'
                   | TYPE = 'AWS_SSE_S3'
                   | TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 17238
externalStageParams (for Google Cloud Storage) ::=
  URL = 'gcs://<bucket>[/<path>/]'
  [ STORAGE_INTEGRATION = <integration_name> ]
  [ ENCRYPTION = (   TYPE = 'GCS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]

-- Example 17239
externalStageParams (for Microsoft Azure) ::=
  URL = 'azure://<account>.blob.core.windows.net/<container>[/<path>/]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = (   TYPE = 'AZURE_CSE' MASTER_KEY = '<string>'
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 17240
externalStageParams (for Amazon S3-compatible Storage) ::=
  URL = 's3compat://{bucket}[/{path}/]'
  ENDPOINT = '<s3_api_compatible_endpoint>'
  [ { CREDENTIALS = ( AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' ) } ]

-- Example 17241
directoryTableParams (for internal stages) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ] ) ]

-- Example 17242
directoryTableParams (for Amazon S3) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
                  [ AUTO_REFRESH = { TRUE | FALSE } ] ) ]

-- Example 17243
directoryTableParams (for Google Cloud Storage) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 17244
directoryTableParams (for Microsoft Azure) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 17245
formatTypeOptions ::=
-- If TYPE = CSV
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
     FILE_EXTENSION = '<string>'
     PARSE_HEADER = TRUE | FALSE
     SKIP_HEADER = <integer>
     SKIP_BLANK_LINES = TRUE | FALSE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     ESCAPE = '<character>' | NONE
     ESCAPE_UNENCLOSED_FIELD = '<character>' | NONE
     TRIM_SPACE = TRUE | FALSE
     FIELD_OPTIONALLY_ENCLOSED_BY = '<character>' | NONE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
     ENCODING = '<string>' | UTF8
-- If TYPE = JSON
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     TRIM_SPACE = TRUE | FALSE
     MULTI_LINE = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     FILE_EXTENSION = '<string>'
     ENABLE_OCTAL = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
-- If TYPE = AVRO
     COMPRESSION = AUTO | GZIP | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = ORC
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = PARQUET
     COMPRESSION = AUTO | LZO | SNAPPY | NONE
     SNAPPY_COMPRESSION = TRUE | FALSE
     BINARY_AS_TEXT = TRUE | FALSE
     USE_LOGICAL_TYPE = TRUE | FALSE
     TRIM_SPACE = TRUE | FALSE
     USE_VECTORIZED_SCANNER = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = XML
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     PRESERVE_SPACE = TRUE | FALSE
     STRIP_OUTER_ELEMENT = TRUE | FALSE
     DISABLE_AUTO_CONVERT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE

-- Example 17246
-- Internal stage
CREATE OR ALTER [ { TEMP | TEMPORARY } ] STAGE <internal_stage_name>
    internalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]

-- External stage
CREATE OR ALTER [ { TEMP | TEMPORARY } ] STAGE <external_stage_name>
    externalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 17247
CREATE [ OR REPLACE ] STAGE [ IF NOT EXISTS ] <name> CLONE <source_stage>
  [ ... ]

-- Example 17248
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 17249
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 17250
"person":
 {
  "name": "Adam",
  "nickname": null,
  "age": 34,
  "phone_numbers":
  [
    "1234567890",
    "0987654321",
    null,
    "6781234590"
  ]
  }

-- Example 17251
"my_map":
 {
  "key_value":
  [
   {
          "key": "k1",
          "value": "v1"
      },
      {
          "key": "k2",
          "value": "v2"
      }
    ]
  }

-- Example 17252
"person":
 {
  "name": "Adam",
  "age": 34
  "phone_numbers":
  [
   "1234567890",
   "0987654321",
   "6781234590"
  ]
 }

-- Example 17253
CREATE STAGE my_int_stage
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 17254
CREATE TEMPORARY STAGE my_temp_int_stage;

-- Example 17255
CREATE TEMPORARY STAGE my_int_stage
  FILE_FORMAT = my_csv_format;

-- Example 17256
CREATE STAGE mystage
  DIRECTORY = (ENABLE = TRUE)
  FILE_FORMAT = myformat;

-- Example 17257
CREATE STAGE my_ext_stage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = myint;

-- Example 17258
CREATE STAGE my_ext_stage1
  URL='s3://load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z');

-- Example 17259
CREATE STAGE my_ext_stage2
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  ENCRYPTION=(MASTER_KEY = 'eSx...');

-- Example 17260
CREATE STAGE my_ext_stage3
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID = 'aws/key');

-- Example 17261
CREATE STAGE my_ext_stage3
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_ROLE='arn:aws:iam::001234567890:role/mysnowflakerole')
  ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID = 'aws/key');

-- Example 17262
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
  );

-- Example 17263
CREATE STAGE my_ext_stage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = myint;

-- Example 17264
CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

