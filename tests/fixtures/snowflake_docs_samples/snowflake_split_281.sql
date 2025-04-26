-- Example 18805
sf-context-current-statement-base64

-- Example 18806
CREATE OR REPLACE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/prod/remote_echo';

-- Example 18807
CREATE OR ALTER SECURE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  HEADERS = ('header_variable1'='header_value', 'header_variable2'='header_value2')
  CONTEXT_HEADERS = (current_account)
  MAX_BATCH_ROWS = 100
  COMPRESSION = "GZIP"
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/prod/remote_echo';

-- Example 18808
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name> (
    -- Column definition
    <col_name> <col_type>
      [ inlineConstraint ]
      [ NOT NULL ]
      [ [ WITH ] MASKING POLICY <policy_name> [ USING ( <col_name> , <cond_col1> , ... ) ] ]
      [ [ WITH ] PROJECTION POLICY <policy_name> ]
      [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
      [ COMMENT '<string_literal>' ]

    -- Additional column definitions
    [ , <col_name> <col_type> [ ... ] ]

    -- Out-of-line constraints
    [ , outoflineConstraint [ ... ] ]
  )
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<directory_for_table_files>' ]
  [ CATALOG_SYNC = '<open_catalog_integration_name>']
  [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE } ]
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] AGGREGATION POLICY <policy_name> ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18809
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE
    | PRIMARY KEY
    | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  }
  [ <constraint_properties> ]

-- Example 18810
outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]

-- Example 18811
CREATE [ OR REPLACE ] ICEBERG TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<relative_path_from_external_volume>' ]
  [ COPY GRANTS ]
  [ ... ]
  AS SELECT <query>

-- Example 18812
CREATE [ OR REPLACE ] ICEBERG TABLE <table_name> LIKE <source_table>
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  [ ... ]

-- Example 18813
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  CATALOG_TABLE_NAME = '<catalog_table_name>'
  [ CATALOG_NAMESPACE = '<catalog_namespace>' ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18814
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  METADATA_FILE_PATH = '<metadata_file_path>'
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18815
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  BASE_LOCATION = '<relative_path_from_external_volume>'
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18816
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  CATALOG_TABLE_NAME = '<rest_catalog_table_name>'
  [ CATALOG_NAMESPACE = '<catalog_namespace>' ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18817
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  CATALOG_TABLE_NAME = '<catalog_table_name>'
  [ CATALOG_NAMESPACE = '<catalog_namespace>' ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18818
CREATE ICEBERG TABLE glue_iceberg_table
  EXTERNAL_VOLUME='glue_catalog_volume'
  CATALOG='glue_catalog_integration'
  CATALOG_TABLE_NAME='my_glue_catalog_table'
  CATALOG_NAMESPACE='icebergcatalogdb2';

-- Example 18819
CREATE OR REPLACE ICEBERG TABLE itable_with_quoted_catalog
  EXTERNAL_VOLUME = '"glue_volume_1"'
  CATALOG = '"glue_catalog_integration_1"'
  CATALOG_TABLE_NAME='my_glue_catalog_table'
  CATALOG_NAMESPACE='icebergcatalogdb2';

-- Example 18820
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  BASE_LOCATION = '<relative_path_from_external_volume>'
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18821
CREATE ICEBERG TABLE my_delta_iceberg_table
  CATALOG = delta_catalog_integration
  EXTERNAL_VOLUME = delta_external_volume
  BASE_LOCATION = 'relative/path/from/ext/vol/';

-- Example 18822
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  METADATA_FILE_PATH = '<metadata_file_path>'
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18823
CREATE ICEBERG TABLE my_iceberg_table
  EXTERNAL_VOLUME='my_external_volume'
  CATALOG='my_catalog_integration'
  METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 18824
CREATE OR REPLACE ICEBERG TABLE itable_with_quoted_catalog
  EXTERNAL_VOLUME = '"external_volume_1"'
  CATALOG = '"catalog_integration_1"'
  METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 18825
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  CATALOG_TABLE_NAME = '<rest_catalog_table_name>'
  [ CATALOG_NAMESPACE = '<catalog_namespace>' ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18826
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'my_rest_catalog_integration'
  CATALOG_TABLE_NAME = 'my_remote_table';

-- Example 18827
CREATE ICEBERG TABLE open_catalog_iceberg_table
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'open_catalog_int'
  CATALOG_TABLE_NAME = 'my_open_catalog_table';

-- Example 18828
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name> (
    -- Column definition
    <col_name> <col_type>
      [ inlineConstraint ]
      [ NOT NULL ]
      [ [ WITH ] MASKING POLICY <policy_name> [ USING ( <col_name> , <cond_col1> , ... ) ] ]
      [ [ WITH ] PROJECTION POLICY <policy_name> ]
      [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
      [ COMMENT '<string_literal>' ]

    -- Additional column definitions
    [ , <col_name> <col_type> [ ... ] ]

    -- Out-of-line constraints
    [ , outoflineConstraint [ ... ] ]
  )
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<directory_for_table_files>' ]
  [ CATALOG_SYNC = '<open_catalog_integration_name>']
  [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE } ]
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] AGGREGATION POLICY <policy_name> ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18829
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE
    | PRIMARY KEY
    | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  }
  [ <constraint_properties> ]

-- Example 18830
outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]

-- Example 18831
CREATE [ OR REPLACE ] ICEBERG TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<relative_path_from_external_volume>' ]
  [ COPY GRANTS ]
  [ ... ]
  AS SELECT <query>

-- Example 18832
CREATE ICEBERG TABLE <table_name> ( <col1> <data_type> [ WITH ] MASKING POLICY <policy_name> [ , ... ] )
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<directory_for_table_files>' ]
  [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col1> [ , ... ] )
  [ ... ]
  AS SELECT <query>

-- Example 18833
CREATE [ OR REPLACE ] ICEBERG TABLE <table_name> LIKE <source_table>
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  [ ... ]

-- Example 18834
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <name>
  CLONE <source_iceberg_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [COPY GRANTS]
    ...

-- Example 18835
CREATE ICEBERG TABLE my_iceberg_table (amount int)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume'
  BASE_LOCATION = 'my_iceberg_table';

-- Example 18836
CREATE OR REPLACE ICEBERG TABLE iceberg_table_copy (column1 int)
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'iceberg_table_copy'
  AS SELECT * FROM base_iceberg_table;

-- Example 18837
CREATE OR REPLACE ICEBERG TABLE table_with_quoted_external_volume
  EXTERNAL_VOLUME = '"external_volume_1"'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my/relative/path/from/external_volume';

-- Example 18838
CREATE [ OR REPLACE ] IMAGE REPOSITORY [ IF NOT EXISTS ] <name>

-- Example 18839
CREATE OR REPLACE IMAGE REPOSITORY tutorial_repository;

-- Example 18840
CREATE [ OR REPLACE ] INDEX [ IF NOT EXISTS ] <index_name>
  ON <table_name>
    ( <col_name> [ , <col_name> , ... ] )

-- Example 18841
Column '<col_name>' cannot be dropped because it is used by index '<index-name>'.

-- Example 18842
DML was unaware of concurrent DDL. Please retry this query.

-- Example 18843
CREATE OR REPLACE HYBRID TABLE mytable (
  pk INT PRIMARY KEY,
  val INT,
  val2 INT
);

INSERT INTO mytable SELECT seq, seq+100, seq+200
  FROM (SELECT seq8() seq FROM TABLE(GENERATOR(rowcount => 100)) v);

-- Example 18844
CREATE OR REPLACE INDEX vidx ON mytable (val);

-- Example 18845
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 18846
BUILD FAILURE Index build failed. Please drop the index and re-create it.

-- Example 18847
DROP INDEX mytable.vidx;

-- Example 18848
+-------------------------------------+
| status                              |
|-------------------------------------|
| Statement executed successfully.    |
+-------------------------------------+

-- Example 18849
CREATE [ OR REPLACE ] JOIN POLICY [ IF NOT EXISTS ] <name>
  AS () RETURNS JOIN_CONSTRAINT -> <body>
  [ COMMENT = '<string_literal>' ]

-- Example 18850
JOIN_CONSTRAINT (
  { JOIN_REQUIRED => <boolean_expression> }
  )

-- Example 18851
CREATE JOIN POLICY jp1 AS ()
  RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

-- Example 18852
CREATE JOIN POLICY jp2 AS ()
  RETURNS JOIN_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'
        THEN JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE)
      ELSE JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE)
    END;

-- Example 18853
CREATE EXTERNAL LISTING [ IF NOT EXISTS ] <name>
  [ { SHARE <share_name>  |  APPLICATION PACKAGE <package_name> } ]
  AS '<yaml_manifest_string>'
  [ PUBLISH = { TRUE | FALSE } ]
  [ REVIEW = { TRUE | FALSE } ]
  [ COMMENT = '<string>' ]

-- Example 18854
CREATE EXTERNAL LISTING MYLISTING
SHARE MySHARE AS
$$
title: "MyListing"
subtitle: "Subtitle for MyListing"
description: "Description for MyListing"
listing_terms:
   type: "STANDARD"
targets:
    accounts: ["Org1.Account1"]
usage_examples:
    - title: "this is a test sql"
      description: "Simple example"
      query: "select *"
$$
;

-- Example 18855
CREATE EXTERNAL LISTING MYLISTING
SHARE MySHARE AS
$$
title: "MyListing"
subtitle: "Subtitle for MyListing"
description: "Description for MyListing"
listing_terms:
  type: "OFFLINE"
targets:
   regions: ["PUBLIC.AWS_US_EAST_1", "PUBLIC.AZURE_WESTUS2"]
usage_examples:
   - title: "this is a test sql"
     description: "Simple example"
     query: "select *"
$$ PUBLISH=FALSE REVIEW=FALSE;

-- Example 18856
CREATE MANAGED ACCOUNT <name>
    ADMIN_NAME = <username> , ADMIN_PASSWORD = <user_password> ,
    TYPE = READER ,
    [ COMMENT = '<string_literal>' ]

-- Example 18857
CREATE MANAGED ACCOUNT reader_acct1
    ADMIN_NAME = user1 , ADMIN_PASSWORD = 'Sdfed43da!44' ,
    TYPE = READER;

-- Example 18858
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| status                                                                                                                                                                            |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| {"accountName":"READER_ACCT1","accountLocator":"IIB88126","url":"https://myorg-reader_acct1.snowflakecomputing.com","accountLocatorUrl":"https://iib88126.snowflakecomputing.com"}|
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 18859
CREATE [ OR REPLACE ] MODEL [ IF NOT EXISTS ] <name> [ WITH VERSION <version_name> ]
    FROM MODEL <source_model_name> [ VERSION <source_version_or_alias_name> ]

-- Example 18860
CREATE [ OR REPLACE ] MODEL [ IF NOT EXISTS ] <name> FROM internalStage

-- Example 18861
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 18862
CREATE [ OR REPLACE ] MODEL MONITOR [ IF NOT EXISTS ] <monitor_name> WITH
    MODEL = <model_name>
    VERSION = '<version_name>'
    FUNCTION = '<function_name>'
    SOURCE = <source_name>
    WAREHOUSE = <warehouse_name>
    REFRESH_INTERVAL = '<refresh_interval>'
    AGGREGATION_WINDOW = '<aggregation_window>'
    TIMESTAMP_COLUMN = <timestamp_name>
    [ BASELINE = <baseline_name> ]
    [ ID_COLUMNS = <id_column_name_array> ]
    [ PREDICTION_CLASS_COLUMNS = <prediction_class_column_name_array> ]
    [ PREDICTION_SCORE_COLUMNS = <prediction_column-name_array> ]
    [ ACTUAL_CLASS_COLUMNS = <actual_class_column_name_array> ]
    [ ACTUAL_SCORE_COLUMNS = <actual_column_name_array> ]

-- Example 18863
CREATE [ OR REPLACE ] NOTEBOOK [ IF NOT EXISTS ] <name>
  [ FROM '<source_location>' ]
  [ MAIN_FILE = '<main_file_name>' ]
  [ COMMENT = '<string_literal>' ]
  [ QUERY_WAREHOUSE = <warehouse_to_run_nb_and_sql_queries_in> ]
  [ IDLE_AUTO_SHUTDOWN_TIME_SECONDS = <number_of_seconds> ]
  [ WAREHOUSE = <warehouse_to_run_notebook_python_runtime> ]

-- Example 18864
CREATE NOTEBOOK mynotebook;

-- Example 18865
CREATE NOTEBOOK mynotebook
 QUERY_WAREHOUSE = my_warehouse;

-- Example 18866
CREATE NOTEBOOK mynotebook
 FROM '@my_db.my_schema.my_stage'
 MAIN_FILE = 'my_notebook_file.ipynb'
 QUERY_WAREHOUSE = my_warehouse;

-- Example 18867
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  TYPE = EMAIL
  ENABLED = { TRUE | FALSE }
  [ ALLOWED_RECIPIENTS = ( '<email_address>' [ , ... '<email_address>' ] ) ]
  [ DEFAULT_RECIPIENTS = ( '<email_address>' [ , ... '<email_address>' ] ) ]
  [ DEFAULT_SUBJECT = '<subject_line>' ]
  [ COMMENT = '<string_literal>' ]

-- Example 18868
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  ENABLED = { TRUE | FALSE }
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_url>'
  AZURE_TENANT_ID = '<ad_directory_id>';
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]

-- Example 18869
Notification queue already in use with another integration.

-- Example 18870
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  ENABLED = { TRUE | FALSE }
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>'
  [ COMMENT = '<string_literal>' ]

-- Example 18871
Notification queue already in use with another integration.

