-- Example 25234
SELECT * FROM <ull>.<schema>.<view>

-- Example 25235
SELECT * FROM "<orgdatacloud$internal$organizational_listing_name>".<schema_name>.<object_within_listing>;
SELECT * FROM <orgdatacloud$internal$organizational_listing_name>.<schema_name>.<object_within_listing>;

-- Example 25236
SELECT * FROM <orgdatacloud$internal$organizational_listing_name>.<schema_name>.<object_within_listing>;

-- Example 25237
CREATE OR REPLACE VIEW <view_name>
AS
SELECT *
FROM <orgdatacloud$internal$organizational_listing_name>.<schema_name>.<object_within_listing>;

-- Example 25238
USE ROLE ACCOUNTADMIN;
CREATE ROLE ORG_LISTING_PROVIDER;
GRANT ROLE ORG_LISTING_PROVIDER TO USER <user_name>;
GRANT CREATE SHARE ON ACCOUNT TO ROLE ORG_LISTING_PROVIDER;

-- Example 25239
USE ROLE ORG_LISTING_PROVIDER;
CREATE OR REPLACE DATABASE DEVORGDB;
USE DATABASE DEVORGDB;
CREATE SHARE ORG_SHARE SECURE_OBJECTS_ONLY=FALSE;
GRANT USAGE ON DATABASE DEVORGDB TO SHARE ORG_SHARE;
GRANT USAGE ON SCHEMA PUBLIC TO SHARE ORG_SHARE;
CREATE OR REPLACE TABLE TUTORIAL_TABLE ( item_id INT, item_name STRING );
GRANT SELECT ON TABLE DEVORGDB.PUBLIC.TUTORIAL_TABLE TO SHARE ORG_SHARE;
INSERT INTO TUTORIAL_TABLE (item_id, item_name) VALUES (1,'Tutorial table');

-- Example 25240
USE ROLE ORG_LISTING_PROVIDER;
CREATE ORGANIZATION LISTING ORG_LISTING
SHARE ORG_SHARE AS
$$
title : "My title"
organization_profile: INTERNAL
organization_targets:
    access:
    - all_accounts : true 
locations:
  access_regions:
  - name: "ALL"
auto_fulfillment:
  refresh_type: "SUB_DATABASE"
  refresh_schedule: "10 MINUTE"
$$;

-- Example 25241
USE ROLE ORG_LISTING_PROVIDER;
ALTER LISTING ORG_LISTING
AS
$$
title : "My title"
organization_profile: INTERNAL
organization_targets:
    access:
    - all_accounts : false 
locations:
  access_regions:
  - name: "ALL"
auto_fulfillment:
  refresh_type: "SUB_DATABASE"
  refresh_schedule: "10 MINUTE"
$$;

-- Example 25242
SHOW LISTINGS;
DESCRIBE LISTING ORG_LISTING;

-- Example 25243
USE ROLE ACCOUNTADMIN;
GRANT MANAGE LISTING AUTO FULFILLMENT ON ACCOUNT TO ROLE ORG_LISTING_PROVIDER;

USE ROLE ORG_LISTING_PROVIDER;
SHOW ORGANIZATION ACCOUNTS;
SELECT SYSTEM$IS_GLOBAL_DATA_SHARING_ENABLED_FOR_ACCOUNT('<ORGACCOUNT>');

CALL SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('<ORGACCOUNT>');

-- Example 25244
DROP LISTING <organizational_listing_name>;
DROP SHARE org_listing1_share1;
DROP DATABASE org_listing_db1;
--CALL SYSTEM$DISABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('ORGACCOUNT');
DROP ROLE ORG_LISTING_PROVIDER;

-- Example 25245
#
# Organization profile manifest
#
title: <organization_profile_title>
description: <organization_profile_description>
contact: <organization_profile_contact>
approver_contact: <organization_profile_approver_contacts>
allowed_publishers:
  access:
      - account: account_name1
      - account: account_name2
logo: <organization_profile_logo_urn>

-- Example 25246
. . .
title: "Title"
. . .

-- Example 25247
. . .
description: "Description"
. . .

-- Example 25248
. . .
contact: "contact@snowflake.com"
. . .

-- Example 25249
. . .
approver_contact: "approver_contact@snowflake.com"
. . .

-- Example 25250
. . .
allowed_publishers:
  access:
    - account: "account_name1"
    - account: "account_name2"
. . .

-- Example 25251
. . .
logo: "urn:icon:shieldlock:blue"
. . .

-- Example 25252
#
# Organization listing manifest
#
title: <Required listing title>
description: <listing description>
resources: <optional listing resources>
listing_terms: <optional listing terms>
data_dictionary: <optional data dictionary>
usage_examples: <optional usage examples>
data_attributes: <optional data attributes>
organization_profile: <Optional custom organization profile. Default "INTERNAL">
organization_targets:
  - # Required
support_contact: "<support email address>"
  - # Required
approver_contact: "<approver email address"
  - # Required when the organization_targets includes the organization_targets.discover field
locations:
  - # Optional list of regions to share into.
auto_fulfillment:
  - # Required when the target accounts are outside the provider's region, otherwise optional.

-- Example 25253
. . .
resources:
  documentation: https://www.example.com/documentation/
  media: https://www.youtube.com/watch?v=MEFlT3dc3uc
. . .

-- Example 25254
. . .
listing_terms:
  type: "CUSTOM"
  link: "http://example.com/my/listing/terms"
. . .

-- Example 25255
. . .
data_dictionary:
 featured:
    database: "WEATHERDATA"
    objects:
       - name: "GLOBAL_WEATHER"
         schema: "PUBLIC"
         domain: "TABLE"
       - name: "GLOBAL_WEATHER_REPORT"
         schema: "PUBLIC"
         domain: "TABLE"
. . .

-- Example 25256
. . .
usage_examples:
  - title: "Return all weather for the US"
    description: "Example of how to select weather information for the United States"
    query: "select * from weather where country_code='USA'";
. . .

-- Example 25257
. . .
data_attributes:
  refresh_rate: DAILY
  geography:
    granularity:
      - REGION_CONTINENT
    geo_option: COUNTRIES
    coverage:
      continents:
        ASIA:
          - INDIA
          - CHINA
        NORTH AMERICA:
          - UNITED STATES
          - CANADA
        EUROPE:
          - UNITED KINGDOM
    time:
      granularity: MONTHLY
      time_range:
        time_frame: LAST
        unit: MONTHS
        value: 6

-- Example 25258
. . .
organization_targets:
   discovery:
   - all_accounts : true
   access:
   - all_accounts : true
. . .

-- Example 25259
. . .
organization_targets:
   discovery:
   - all_accounts : true
   access:
   - account: 'finance'
. . .

-- Example 25260
. . .
organization_targets:
   discovery:
   - all_accounts : true
   access:
   - account: 'finance'
   - account: 'credit'
. . .

-- Example 25261
. . .
organization_targets:
    discovery:
    - all_accounts : true
    access:
    - account: 'finance'

      roles: [ 'accounting','debit']
. . .

-- Example 25262
. . .
support_contact: "support@exampledomain.com"
. . .

-- Example 25263
. . .
  approver_contact: "approver@exampledomain.com"
. . .

-- Example 25264
. . .
locations:
  access_regions:
  - name: "<names | ALL>"
. . .

-- Example 25265
CREATE OR REPLACE CATALOG INTEGRATION icebergCatalogInt
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = ICEBERG
  ENABLED = TRUE;

-- Example 25266
CREATE OR REPLACE CATALOG INTEGRATION delta_catalog_integration
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = DELTA
  ENABLED = TRUE;

-- Example 25267
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<bucket>/<prefix>/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<bucket>",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "<prefix>/*"
                    ]
                }
            }
        }
    ]
}

-- Example 25268
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 25269
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 25270
DESC INTEGRATION <integration_name>;

-- Example 25271
DESC INTEGRATION s3_int;

-- Example 25272
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+
| property                  | property_type | property_value                                                                 | property_default |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------|
| ENABLED                   | Boolean       | true                                                                           | false            |
| STORAGE_ALLOWED_LOCATIONS | List          | s3://mybucket1/mypath1/,s3://mybucket2/mypath2/                                | []               |
| STORAGE_BLOCKED_LOCATIONS | List          | s3://mybucket1/mypath1/sensitivedata/,s3://mybucket2/mypath2/sensitivedata/    | []               |
| STORAGE_AWS_IAM_USER_ARN  | String        | arn:aws:iam::123456789001:user/abc1-b-self1234                                 |                  |
| STORAGE_AWS_ROLE_ARN      | String        | arn:aws:iam::001234567890:role/myrole                                          |                  |
| STORAGE_AWS_EXTERNAL_ID   | String        | MYACCOUNT_SFCRole=2_a123456/s0aBCDEfGHIJklmNoPq=                               |                  |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+

-- Example 25273
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake_external_id>"
        }
      }
    }
  ]
}

-- Example 25274
USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL = 's3://mybucket/files'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 25275
CREATE OR REPLACE EXTERNAL TABLE ext_table
 WITH LOCATION = @mystage/path1/
 FILE_FORMAT = (TYPE = JSON);

-- Example 25276
SHOW EXTERNAL TABLES;

-- Example 25277
ALTER EXTERNAL TABLE ext_table REFRESH;

-- Example 25278
select system$get_aws_sns_iam_policy('<sns_topic_arn>');

-- Example 25279
select system$get_aws_sns_iam_policy('arn:aws:sns:us-west-2:001234567890:s3_mybucket');

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_AWS_SNS_IAM_POLICY('ARN:AWS:SNS:US-WEST-2:001234567890:S3_MYBUCKET')                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {"Version":"2012-10-17","Statement":[{"Sid":"1","Effect":"Allow","Principal":{"AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"},"Action":["sns:Subscribe"],"Resource":["arn:aws:sns:us-west-2:001234567890:s3_mybucket"]}]}                 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 25280
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     }
   ]
 }

-- Example 25281
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     },
     {
        "Sid":"1",
        "Effect":"Allow",
        "Principal":{
          "AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
         },
         "Action":[
           "sns:Subscribe"
         ],
         "Resource":[
           "arn:aws:sns:us-west-2:001234567890:s3_mybucket"
         ]
     }
   ]
 }

-- Example 25282
{
    "Sid":"s3-event-notifier",
    "Effect":"Allow",
    "Principal":{
       "Service":"s3.amazonaws.com"
    },
    "Action":"SNS:Publish",
    "Resource":"arn:aws:sns:us-west-2:001234567890:s3_mybucket",
    "Condition":{
       "ArnLike":{
          "aws:SourceArn":"arn:aws:s3:*:*:s3_mybucket"
       }
    }
 }

-- Example 25283
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     },
     {
        "Sid":"1",
        "Effect":"Allow",
        "Principal":{
          "AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
         },
         "Action":[
           "sns:Subscribe"
         ],
         "Resource":[
           "arn:aws:sns:us-west-2:001234567890:s3_mybucket"
         ]
     },
     {
        "Sid":"s3-event-notifier",
        "Effect":"Allow",
        "Principal":{
           "Service":"s3.amazonaws.com"
        },
        "Action":"SNS:Publish",
        "Resource":"arn:aws:sns:us-west-2:001234567890:s3_mybucket",
        "Condition":{
           "ArnLike":{
              "aws:SourceArn":"arn:aws:s3:*:*:s3_mybucket"
           }
        }
      }
   ]
 }

-- Example 25284
USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL = 's3://mybucket/files'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 25285
CREATE EXTERNAL TABLE <table_name>
 ..
 AWS_SNS_TOPIC = '<sns_topic_arn>';

-- Example 25286
CREATE EXTERNAL TABLE ext_table
 WITH LOCATION = @mystage/path1/
 FILE_FORMAT = (TYPE = JSON)
 AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket';

-- Example 25287
ALTER EXTERNAL TABLE ext_table REFRESH;

-- Example 25288
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

-- Example 25289
inlineConstraint ::=
  [ NOT NULL ]
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> ] ) ] }
  [ <constraint_properties> ]

-- Example 25290
cloudProviderParams (for Google Cloud Storage) ::=
  [ INTEGRATION = '<integration_name>' ]

cloudProviderParams (for Microsoft Azure) ::=
  [ INTEGRATION = '<integration_name>' ]

-- Example 25291
externalStage ::=
  @[<namespace>.]<ext_stage_name>[/<path>]

-- Example 25292
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

-- Example 25293
CREATE [ OR REPLACE ] EXTERNAL TABLE <table_name>
  [ COPY GRANTS ]
  USING TEMPLATE <query>
  [ ... ]

-- Example 25294
mycol varchar as (value:c1::varchar)

-- Example 25295
{ "a":"1", "b": { "c":"2", "d":"3" } }

-- Example 25296
mycol varchar as (value:"b"."c"::varchar)

-- Example 25297
col1 varchar as (parse_json(metadata$external_table_partition):col1::varchar),
col2 number as (parse_json(metadata$external_table_partition):col2::number),
col3 timestamp_tz as (parse_json(metadata$external_table_partition):col3::timestamp_tz)

-- Example 25298
|"Hello world"|    /* returned as */  >Hello world<
|" Hello world "|  /* returned as */  > Hello world <
| "Hello world" |  /* returned as */  >Hello world<

-- Example 25299
CREATE STAGE s1
  URL='s3://mybucket/files/logs/'
  ...
  ;

-- Example 25300
CREATE STAGE s1
  URL='gcs://mybucket/files/logs/'
  ...
  ;

