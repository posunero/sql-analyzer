-- Example 17934
StreamingError:
type: object
properties:
  message:
    type: string
    description: A description of the error
  code:
    type: string
    description: The Snowflake error code categorizing the error
  request_id:
    type: string
    description: Unique request ID

-- Example 17935
Warnings:
type: object
description: Warnings found while processing the request
properties:
  warnings:
    type: array
    items:
      $ref: "#/components/schemas/Warning"
Warning:
type: object
title: The warning object
description: Represents a warning within a chat.
properties:
  message:
    type: string
    description: A human-readable message describing the warning

-- Example 17936
'tag_map': {
  'column_tag_map': [
    {
      'tag_name':'tag_db.sch.pii',
      'tag_value':'Highly Confidential',
      'semantic_categories':[
        'NAME',
        'NATIONAL_IDENTIFIER'
      ]
    },
    {
      'tag_name': 'tag_db.sch.pii',
      'tag_value':'Confidential',
      'semantic_categories': [
        'EMAIL'
      ]
    }
  ]
}

-- Example 17937
CALL SYSTEM$GET_CLASSIFICATION_RESULT('mydb.sch.t1');

-- Example 17938
SELECT * FROM snowflake.account_usage.data_classification_latest;

-- Example 17939
SELECT
  service_type,
  start_time,
  end_time,
  entity_id,
  name,
  credits_used_compute,
  credits_used_cloud_services,
  credits_used,
  budget_id
  FROM snowflake.account_usage.metering_history
  WHERE service_type = 'SENSITIVE_DATA_CLASSIFICATION';

-- Example 17940
SELECT
  service_type,
  usage_date,
  credits_used_compute,
  credits_used_cloud_services,
  credits_used
  FROM snowflake.account_usage.metering_daily_history
  WHERE service_type = 'SENSITIVE_DATA_CLASSIFICATION';

-- Example 17941
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON DATABASE mydb TO ROLE data_engineer;
GRANT EXECUTE AUTO CLASSIFICATION ON SCHEMA mydb.sch TO ROLE data_engineer;

GRANT DATABASE ROLE SNOWFLAKE.CLASSIFICATION_ADMIN TO ROLE data_engineer;
GRANT CREATE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE ON SCHEMA mydb.sch TO ROLE data_engineer;

GRANT APPLY TAG ON ACCOUNT TO ROLE data_engineer;

-- Example 17942
USE ROLE data_engineer;

-- Example 17943
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  my_classification_profile(
    {
      'minimum_object_age_for_classification_days': 0,
      'maximum_classification_validity_days': 30,
      'auto_tag': true
    });

-- Example 17944
SELECT my_classification_profile!DESCRIBE();

-- Example 17945
ALTER SCHEMA mydb.sch
 SET CLASSIFICATION_PROFILE = 'mydb.sch.my_classification_profile';

-- Example 17946
CALL SYSTEM$GET_CLASSIFICATION_RESULT('mydb.sch.t1');

-- Example 17947
ALTER SCHEMA mydb.sch UNSET CLASSIFICATION_PROFILE;

-- Example 17948
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  my_classification_profile(
    {
      'minimum_object_age_for_classification_days': 0,
      'maximum_classification_validity_days': 30,
      'auto_tag': true
    });

-- Example 17949
CALL my_classification_profile!SET_TAG_MAP(
  {'column_tag_map':[
    {
      'tag_name':'my_db.sch1.pii',
      'tag_value':'sensitive',
      'semantic_categories':['NAME']
    }]});

-- Example 17950
CALL my_classification_profile!set_custom_classifiers(
  {
    'medical_codes': medical_codes!list(),
    'finance_codes': finance_codes!list()
  });

-- Example 17951
SELECT my_classification_profile!DESCRIBE();

-- Example 17952
ALTER SCHEMA mydb.sch
 SET CLASSIFICATION_PROFILE = 'mydb.sch.my_classification_profile';

-- Example 17953
ALTER TAG tag_db.sch.pii SET MASKING POLICY pii_mask;

-- Example 17954
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE my_classification_profile(
  {
    'minimum_object_age_for_classification_days':0,
    'auto_tag':true,
    'tag_map': {
      'column_tag_map':[
        {
          'tag_name':'tag_db.sch.pii',
          'tag_value':'highly sensitive',
          'semantic_categories':['NAME','NATIONAL_IDENTIFIER']
        },
        {
          'tag_name':'tag_db.sch.pii',
          'tag_value':'sensitive',
          'semantic_categories':['EMAIL','MEDICAL_CODE']
        }
      ]
    },
    'custom_classifiers': {
      'medical_codes': medical_codes!list(),
      'finance_codes': finance_codes!list()
    }
  }
);

-- Example 17955
CALL SYSTEM$CLASSIFY(
 'db.sch.table1',
 'db.sch.my_classification_profile'
);

-- Example 17956
{
  "classification_profile_config": {
    "classification_profile_name": "db.schema.my_classification_profile"
  },
  "classification_result": {
    "EMAIL": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "EMAIL",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "EMAIL"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          },
          {
            "tag_applied": true,
            "tag_name": "tag_db.sch.pii",
            "tag_value": "sensitive"
          }
        ]
      },
      "valid_value_ratio": 1
    },
    "FIRST_NAME": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "NAME",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "NAME"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          },
          {
            "tag_applied": true,
            "tag_name": "tag_db.sch.pii",
            "tag_value": "highly sensitive"
          }
        ]
      },
      "valid_value_ratio": 1
    }
  }
}

-- Example 17957
ALTER SCHEMA mydb.sch
 SET CLASSIFICATION_PROFILE = 'mydb.sch.my_classification_profile';

-- Example 17958
SELECT
  record_type,
  record:severity_text::string log_level,
  parse_json(value) error_message
  FROM log_db.log_schema.log_table
  WHERE record_type='LOG' and scope:name ='snow.automatic_sensitive_data_classification'
  ORDER BY log_level;

-- Example 17959
"failure_reason":"NO_TAGGING_PRIVILEGE"

-- Example 17960
"failure_reason":"MANUALLY_APPLIED_VALUE_PRESENT"

-- Example 17961
"failure_reason":"TAG_NOT_ACCESSIBLE_OR_AUTHORIZED"

-- Example 17962
SELECT * FROM SNOWFLAKE.ORGANIZATION_USAGE.METERING_DAILY_HISTORY
  WHERE service_type ILIKE '%ai_services%';

-- Example 17963
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

-- Example 17964
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE
    | PRIMARY KEY
    | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  }
  [ <constraint_properties> ]

-- Example 17965
outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]

-- Example 17966
CREATE [ OR REPLACE ] ICEBERG TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<relative_path_from_external_volume>' ]
  [ COPY GRANTS ]
  [ ... ]
  AS SELECT <query>

-- Example 17967
CREATE ICEBERG TABLE <table_name> ( <col1> <data_type> [ WITH ] MASKING POLICY <policy_name> [ , ... ] )
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = 'SNOWFLAKE' ]
  [ BASE_LOCATION = '<directory_for_table_files>' ]
  [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col1> [ , ... ] )
  [ ... ]
  AS SELECT <query>

-- Example 17968
CREATE [ OR REPLACE ] ICEBERG TABLE <table_name> LIKE <source_table>
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  [ ... ]

-- Example 17969
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <name>
  CLONE <source_iceberg_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [COPY GRANTS]
    ...

-- Example 17970
CREATE ICEBERG TABLE my_iceberg_table (amount int)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume'
  BASE_LOCATION = 'my_iceberg_table';

-- Example 17971
CREATE OR REPLACE ICEBERG TABLE iceberg_table_copy (column1 int)
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'iceberg_table_copy'
  AS SELECT * FROM base_iceberg_table;

-- Example 17972
CREATE OR REPLACE ICEBERG TABLE table_with_quoted_external_volume
  EXTERNAL_VOLUME = '"external_volume_1"'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my/relative/path/from/external_volume';

-- Example 17973
CREATE EXTERNAL VOLUME my_gcs_external_volume
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-us-west-2'
        STORAGE_PROVIDER = 'GCS'
        STORAGE_BASE_URL = 'gcs://mybucket1/path1/'
        ENCRYPTION=(TYPE='GCS_SSE_KMS' KMS_KEY_ID = '1234abcd-12ab-34cd-56ef-1234567890ab')
      )
    );

-- Example 17974
DESC EXTERNAL VOLUME my_gcs_external_volume;

-- Example 17975
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 17976
CREATE EXTERNAL VOLUME exvol
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-azure-northeurope'
        STORAGE_PROVIDER = 'AZURE'
        STORAGE_BASE_URL = 'azure://exampleacct.blob.core.windows.net/my_container_northeurope/'
        AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
      )
    );

-- Example 17977
DESC EXTERNAL VOLUME exvol;

-- Example 17978
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 17979
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

-- Example 17980
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

-- Example 17981
cloudProviderParams (for Google Cloud Storage) ::=
  STORAGE_PROVIDER = 'GCS'
  STORAGE_BASE_URL = 'gcs://<bucket>[/<path>/]'
  [ ENCRYPTION = ( [ TYPE = 'GCS_SSE_KMS' ] [ KMS_KEY_ID = '<string>' ] |
              [ TYPE = 'NONE' ] ) ]

-- Example 17982
cloudProviderParams (for Microsoft Azure) ::=
  STORAGE_PROVIDER = 'AZURE'
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_BASE_URL = 'azure://...'
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 17983
s3CompatibleStorageParams ::=
  STORAGE_PROVIDER = 'S3COMPAT'
  STORAGE_BASE_URL = 's3compat://<bucket>[/<path>/]'
  CREDENTIALS = ( AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' )
  STORAGE_ENDPOINT = '<s3_api_compatible_endpoint>'

-- Example 17984
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "external_volume_name" = 'my_external_volume_1';

-- Example 17985
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

-- Example 17986
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

-- Example 17987
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

-- Example 17988
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

-- Example 17989
DESC[RIBE] EXTERNAL VOLUME <name>

-- Example 17990
DESC EXTERNAL VOLUME my_external_volume;

-- Example 17991
+-------------------+--------------------+---------------+-------------------------------------------------------------------------------------------+------------------+
| parent_property   | property           | property_type | property_value                                                                            | property_default |
|-------------------+--------------------+---------------+-------------------------------------------------------------------------------------------+------------------|
|                   | ALLOW_WRITES       | Boolean       | true                                                                                      | true             |
| STORAGE_LOCATIONS | STORAGE_LOCATION_1 | String        | {"NAME":"my_storage_us_west","STORAGE_PROVIDER":"S3","STORAGE_BASE_URL":"s3://...", ...}  |                  |
| STORAGE_LOCATIONS | ACTIVE             | String        | my_storage_us_west                                                                        |                  |
+-------------------+--------------------+---------------+-------------------------------------------------------------------------------------------+------------------+

-- Example 17992
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  USE_VECTORIZED_SCANNER = TRUE;

-- Example 17993
CREATE OR REPLACE ICEBERG TABLE customer_iceberg_ingest (
  c_custkey INTEGER,
  c_name STRING,
  c_address STRING,
  c_nationkey INTEGER,
  c_phone STRING,
  c_acctbal INTEGER,
  c_mktsegment STRING,
  c_comment STRING
)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_ingest_vol'
  BASE_LOCATION = 'customer_iceberg_ingest/';

-- Example 17994
COPY INTO customer_iceberg_ingest
  FROM @my_parquet_stage
  FILE_FORMAT = 'my_parquet_format'
  LOAD_MODE = ADD_FILES_COPY
  PURGE = TRUE
  MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;

-- Example 17995
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                          | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_008.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_006.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_005.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_002.parquet | LOADED |           5 |           5 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_010.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 17996
SELECT
    c_custkey,
    c_name,
    c_mktsegment
  FROM customer_iceberg_ingest
  LIMIT 10;

-- Example 17997
+-----------+--------------------+--------------+
| C_CUSTKEY | C_NAME             | C_MKTSEGMENT |
|-----------+--------------------+--------------|
|     75001 | Customer#000075001 | FURNITURE    |
|     75002 | Customer#000075002 | FURNITURE    |
|     75003 | Customer#000075003 | MACHINERY    |
|     75004 | Customer#000075004 | AUTOMOBILE   |
|     75005 | Customer#000075005 | FURNITURE    |
|         1 | Customer#000000001 | BUILDING     |
|         2 | Customer#000000002 | AUTOMOBILE   |
|         3 | Customer#000000003 | AUTOMOBILE   |
|         4 | Customer#000000004 | MACHINERY    |
|         5 | Customer#000000005 | HOUSEHOLD    |
+-----------+--------------------+--------------+

-- Example 17998
ALTER DATABASE my_database_1
  SET CATALOG = 'shared_catalog_integration';

-- Example 17999
CREATE ICEBERG TABLE my_iceberg_table
   EXTERNAL_VOLUME='my_external_volume'
   METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 18000
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_s3_external_volume');

