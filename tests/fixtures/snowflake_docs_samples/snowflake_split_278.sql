-- Example 18604
ALTER TABLE <name> DROP COLUMN <col_name>

-- Example 18605
ALTER EXTERNAL TABLE exttable_json REFRESH;

-- Example 18606
CREATE OR REPLACE STAGE mystage
  URL='<cloud_platform>://twitter_feed/logs/'
  .. ;

-- Create the external table
-- 'daily' path includes paths in </YYYY/MM/DD/> format
CREATE OR REPLACE EXTERNAL TABLE daily_tweets
  WITH LOCATION = @twitter_feed/daily/;

-- Refresh the metadata for a single day of data files by date
ALTER EXTERNAL TABLE exttable_part REFRESH '2018/08/05/';

-- Example 18607
ALTER EXTERNAL TABLE exttable1 ADD FILES ('path1/sales4.json.gz', 'path1/sales5.json.gz');

-- Example 18608
ALTER EXTERNAL TABLE exttable1 REMOVE FILES ('path1/sales4.json.gz', 'path1/sales5.json.gz');

-- Example 18609
BEGIN;

ALTER EXTERNAL TABLE extable1 REMOVE FILES ('2019/12/log1.json.gz');

ALTER EXTERNAL TABLE extable1 ADD FILES ('2019/12/log1.json.gz');

COMMIT;

-- Example 18610
ALTER EXTERNAL TABLE et2 ADD PARTITION(col1='2022-01-24', col2='a', col3='12') LOCATION '2022/01';

-- Example 18611
ALTER EXTERNAL TABLE et2 DROP PARTITION LOCATION '2022/01';

-- Example 18612
ALTER EXTERNAL VOLUME [ IF EXISTS ] <name> ADD STORAGE_LOCATION =
  (
    NAME = '<storage_location_name>'
    cloudProviderParams
  )

ALTER EXTERNAL VOLUME [ IF EXISTS ] <name> REMOVE STORAGE_LOCATION '<storage_location_name>'

ALTER EXTERNAL VOLUME [ IF EXISTS ] <name> UPDATE
  STORAGE_LOCATION = '<s3_compatible_storage_location_name>'
  CREDENTIALS = (
    AWS_KEY_ID = '<string>'
    AWS_SECRET_KEY = '<string>'
  )

ALTER EXTERNAL VOLUME [ IF EXISTS ] <name> SET ALLOW_WRITES = { TRUE | FALSE }

ALTER EXTERNAL VOLUME [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

-- Example 18613
cloudProviderParams (for Amazon S3) ::=
  STORAGE_PROVIDER = '{ S3 | S3GOV }'
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_BASE_URL = '<protocol>://<bucket>[/<path>/]'
  [ STORAGE_AWS_ACCESS_POINT_ARN = '<string>' ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_SSE_S3' ] |
              [ TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ] ] |
              [ TYPE = 'NONE' ] ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 18614
cloudProviderParams (for Google Cloud Storage) ::=
  STORAGE_PROVIDER = 'GCS'
  STORAGE_BASE_URL = 'gcs://<bucket>[/<path>/]'
  [ ENCRYPTION = ( [ TYPE = 'GCS_SSE_KMS' ] [ KMS_KEY_ID = '<string>' ] |
              [ TYPE = 'NONE' ] ) ]

-- Example 18615
cloudProviderParams (for Microsoft Azure) ::=
  STORAGE_PROVIDER = 'AZURE'
  AZURE_TENANT_ID = '<tenant_id>'
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]
  STORAGE_BASE_URL = 'azure://<account>.blob.core.windows.net/<container>[/<path>/]'

-- Example 18616
ALTER EXTERNAL VOLUME exvol1 REMOVE STORAGE_LOCATION 'my-us-east-1';

-- Example 18617
ALTER EXTERNAL VOLUME exvol1
  ADD STORAGE_LOCATION =
    (
      NAME = 'my-s3-us-central-2'
      STORAGE_PROVIDER = 'S3'
      STORAGE_BASE_URL = 's3://my_bucket_us_central-1/'
      STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/myrole'
    );

-- Example 18618
ALTER EXTERNAL VOLUME exvol2
  ADD STORAGE_LOCATION =
    (
      NAME = 'my-gcs-europe-west4'
      STORAGE_PROVIDER = 'GCS'
      STORAGE_BASE_URL = 'gcs://my_bucket_europe-west4/'
    );

-- Example 18619
ALTER EXTERNAL VOLUME exvol3
  ADD STORAGE_LOCATION =
    (
      NAME = 'my-azure-japaneast'
      STORAGE_PROVIDER = 'AZURE'
      STORAGE_BASE_URL = 'azure://sfcdev1.blob.core.windows.net/my_container_japaneast/'
      AZURE_TENANT_ID = 'a9876545-4321-987b-b23c-2kz436789d0'
    );

-- Example 18620
ALTER EXTERNAL VOLUME ext_vol_s3_compat UPDATE
  STORAGE_LOCATION = 'my_s3_compat_storage_location'
  CREDENTIALS = (
    AWS_KEY_ID = '4d5e6f...'
    AWS_SECRET_KEY = '7g8h9i...'
  );

-- Example 18621
ALTER FILE FORMAT [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER FILE FORMAT [ IF EXISTS ] <name> SET { [ formatTypeOptions ] [ COMMENT = '<string_literal>' ] }

-- Example 18622
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

-- Example 18623
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 18624
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 18625
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

-- Example 18626
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

-- Example 18627
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

-- Example 18628
ALTER FILE FORMAT IF EXISTS my_format RENAME TO my_new_format;

-- Example 18629
ALTER FILE FORMAT my_format SET FIELD_DELIMITER=',';

-- Example 18630
ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  SET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  UNSET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  SET COMMENT = '<string_literal>'

ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  UNSET COMMENT

ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FUNCTION [ IF EXISTS ] <name> ( TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ] )
  UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18631
ALTER FUNCTION governance.dmfs.count_positive_numbers(
 TABLE(
   NUMBER,
   NUMBER,
   NUMBER
))
SET SECURE;

-- Example 18632
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )
  RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )
  SET CONTEXT_HEADERS = ( <context_function_1> [ , <context_function_2> ...] )

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )
  SET MAX_BATCH_ROWS = <integer>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )
  SET COMMENT = '<string_literal>'

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )
  SET SERVICE = '<service_name>' ENDPOINT = '<endpoint_name>'

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )
  UNSET { CONTEXT_HEADERS | MAX_BATCH_ROWS | COMMENT }

-- Example 18633
ALTER FUNCTION my_echo_udf(VARCHAR) RENAME TO my_echo_udf_temp;

-- Example 18634
ALTER FUNCTION my_echo_udf(VARCHAR) SET COMMENT = 'some comment';

-- Example 18635
ALTER FUNCTION my_echo_udf(number) SET MAX_BATCH_ROWS = 100;

-- Example 18636
ALTER FUNCTION my_echo_udf(VARCHAR) SET CONTEXT_HEADER = (CURRENT_USER);

-- Example 18637
ALTER FUNCTION my_echo_udf(VARCHAR) UNSET MAX_BATCH_ROWS;

-- Example 18638
ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> { clusteringAction | tableColumnAction }

ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> SET
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ CATALOG_SYNC = '<snowflake_open_catalog_integration_name>']
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]

ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> UNSET REPLACE_INVALID_CHARACTERS

ALTER ICEBERG TABLE [ IF EXISTS ] dataGovnPolicyTagAction

-- Example 18639
clusteringAction ::=
  {
     CLUSTER BY ( <expr> [ , <expr> , ... ] )
     /* { SUSPEND | RESUME } RECLUSTER is valid action */
   | { SUSPEND | RESUME } RECLUSTER
   | DROP CLUSTERING KEY
  }

-- Example 18640
tableColumnAction ::=
  {
     ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
        [ inlineConstraint ]
        [ COLLATE '<collation_specification>' ]

   | RENAME COLUMN <col_name> TO <new_col_name>

   | ALTER | MODIFY [ ( ]
                          , [ COLUMN ] <col1_name> { [ SET ] NOT NULL | DROP NOT NULL }
                          , [ COLUMN ] <col1_name> [ [ SET DATA ] TYPE ] <type>
                          , [ COLUMN ] <col1_name> COMMENT '<string>'
                          , [ COLUMN ] <col1_name> UNSET COMMENT
                        [ , [ COLUMN ] <col2_name> ... ]
                        [ , ... ]
                    [ ) ]

   | DROP [ COLUMN ] [ IF EXISTS ] <col1_name> [, <col2_name> ... ]
  }

  inlineConstraint ::=
    [ NOT NULL ]
    [ CONSTRAINT <constraint_name> ]
    { UNIQUE | PRIMARY KEY | { [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ] } }
    [ <constraint_properties> ]

-- Example 18641
dataGovnPolicyTagAction ::=
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }
  |
  {
      SET AGGREGATION POLICY <policy_name>
        [ ENTITY KEY ( <col_name> [, ... ] ) ]
        [ FORCE ]
    | UNSET AGGREGATION POLICY
  }
  |
  {
      SET JOIN POLICY <policy_name>
        [ FORCE ]
    | UNSET JOIN POLICY
  }
  |
  ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
    [ [ WITH ] MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] ]
    [ [ WITH ] PROJECTION POLICY <policy_name> ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>'
          [ , <tag_name> = '<tag_value>' , ... ] ) ]
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] [ FORCE ]
      | UNSET MASKING POLICY
  }
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET PROJECTION POLICY <policy_name>
          [ FORCE ]
      | UNSET PROJECTION POLICY
  }
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> SET TAG
      <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
      , [ COLUMN ] <col2_name> SET TAG
          <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
                   , [ COLUMN ] <col2_name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18642
ALTER ICEBERG TABLE my_iceberg_table SET TAG my_tag = 'customer';

-- Example 18643
ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> ALTER COLUMN <structured_column>
  SET DATA TYPE <new_structured_type>

-- Example 18644
ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> ALTER COLUMN <structured_column>
  SET DATA TYPE <new_structured_type>
  RENAME FIELDS

-- Example 18645
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN col1
  SET DATA TYPE ARRAY(long);

-- Example 18646
CREATE ICEBERG TABLE my_iceberg_table (
  column_1 OBJECT(
      key_a int,
      key_b int
    )
  )
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume'
  BASE_LOCATION = '';

-- Example 18647
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN column_1
  SET DATA TYPE OBJECT(
    key_b int,
    key_a int
  );

-- Example 18648
CREATE ICEBERG TABLE my_iceberg_table (
  column_1 OBJECT(
      key_1 int
    )
  )
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume'
  BASE_LOCATION = '';

-- Example 18649
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN column_1
  SET DATA TYPE OBJECT(
    key_1 int,
    key_2 int
  );

-- Example 18650
CREATE ICEBERG TABLE my_iceberg_table (
  column_1 OBJECT(
      key_1 int,
      key_2 ARRAY(string)
    )
  )
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume'
  BASE_LOCATION = '';

-- Example 18651
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN column_1
  SET DATA TYPE OBJECT(
    key_1 int
  );

-- Example 18652
CREATE ICEBERG TABLE my_iceberg_table (
  column_1 OBJECT(
      key_1 int,
      key_2 int
    )
  )
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume'
  BASE_LOCATION = '';

-- Example 18653
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN column_1
  SET DATA TYPE OBJECT(
    k_1 int,
    k_2 int
  )
  RENAME FIELDS;

-- Example 18654
ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> CONVERT TO MANAGED
  [ BASE_LOCATION = '<directory_for_table_files>' ]
  [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]

-- Example 18655
ALTER ICEBERG TABLE myTable CONVERT TO MANAGED
  BASE_LOCATION = 'my/relative/path/from/external_volume';

-- Example 18656
ALTER ICEBERG TABLE [ IF EXISTS ] <table_name> REFRESH [ '<metadata_file_relative_path>' ]

-- Example 18657
ALTER ICEBERG TABLE myIcebergTable REFRESH;

-- Example 18658
ALTER ICEBERG TABLE my_iceberg_table REFRESH 'path/to/metadata/v2.metadata.json';

-- Example 18659
ALTER LISTING [ IF EXISTS ] <name> [ { PUBLISH | UNPUBLISH } ]

ALTER LISTING [ IF EXISTS ] <name> AS '<yaml_manifest_string>'
  [ PUBLISH={ TRUE | FALSE } ]
  [ REVIEW= { TRUE | FALSE } ]
  [ COMMENT = '<string>' ]

ALTER LISTING [ IF EXISTS ] <name> RENAME TO <new_name>;

ALTER LISTING [ IF EXISTS ] <name> SET COMMENT = '<string>'

-- Example 18660
ALTER LISTING MYLISTING
AS
  $$
  title: "MyListing"
  subtitle: "Subtitle for MyListing"
  description: "Description or MyListing"
  listing_terms:
    type: "STANDARD"
  targets:
    accounts: ["Org1.Account1"]
  usage_examples:
     - title: "this is a test sql"
       description: "Simple example"
       query: "select *"
  $$

-- Example 18661
ALTER LISTING MYLISTING PUBLISH;

-- Example 18662
ALTER LISTING MYLISTING UNPUBLISH;

-- Example 18663
ALTER LISTING MYLISTING SET COMMENT = 'My listing is ready!';

-- Example 18664
ALTER MODEL [ IF EXISTS ] <name> ADD VERSION <version_name>
  FROM MODEL <source_model_name> [ VERSION <source_version_name> ]

-- Example 18665
ALTER MODEL [ IF EXISTS ] <name> ADD VERSION <version_name> FROM internalStage

-- Example 18666
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
| @[<namespace>.]%<table_name>[/<path>]
| @~[/<path>]

-- Example 18667
ALTER MODEL MONITOR [ IF EXISTS ] <monitor_name> { SUSPEND | RESUME }

ALTER MODEL MONITOR [ IF EXISTS ] <monitor_name> SET
   [ BASELINE='<baseline_table_name>' ]
   [ REFRESH_INTERVAL='<refresh_interval>' ]
   [ WAREHOUSE=<warehouse_name> ]

-- Example 18668
ALTER NOTEBOOK [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER NOTEBOOK [ IF EXISTS ] <name> SET
  [ COMMENT = '<string_literal>' ]
  [ QUERY_WAREHOUSE = <warehouse_to_run_nb_and_sql_queries_in> ]
  [ IDLE_AUTO_SHUTDOWN_TIME_SECONDS = <number_of_seconds> ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name>) [ , ... ] ]

-- Example 18669
ALTER NOTEBOOK my_notebook RENAME TO notebook_v2;

-- Example 18670
ALTER NOTEBOOK my_notebook UNSET QUERY_WAREHOUSE;

