-- Example 25167
+---------------------------------------+------+----------------------------------+-------------------------------+
| name                                  | size | md5                              | last_modified                 |
|---------------------------------------+------+----------------------------------+-------------------------------|
| my_gcs_stage/load/                    |  12  | 12348f18bcb35e7b6b628ca12345678c | Mon, 11 Aug 2022 16:57:43 GMT |
| my_gcs_stage/load/data_0_0_0.csv.gz   |  147 | 9765daba007a643bdff4eae10d43218y | Mon, 11 Aug 2022 18:13:07 GMT |
+---------------------------------------+------+----------------------------------+-------------------------------+

-- Example 25168
COPY FILES
  INTO @trg_stage
  FROM @src_stage;

-- Example 25169
COPY FILES
  INTO @trg_stage
  FROM @src_stage
  FILES = ('file1.csv', 'file2.csv');

-- Example 25170
COPY FILES
  INTO @trg_stage/trg_path/
  FROM @src_stage/src_path/;

-- Example 25171
COPY FILES
  INTO @trg_stage
  FROM @src_stage
  PATTERN='.*/.*/.*[.]csv[.]gz';

-- Example 25172
COPY FILES
  INTO @trg_stage
  FROM @src_stage
  PATTERN='.*sales.*[.]csv';

-- Example 25173
COPY FILES
  INTO @trg_stage
  FROM (SELECT '@src_stage/file.txt');

-- Example 25174
COPY FILES
  INTO @trg_stage
  FROM (SELECT '@src_stage/file.txt', 'new_filename.txt');

-- Example 25175
-- Create a table with URLs
CREATE TABLE urls(src_file STRING, trg_file STRING);
INSERT INTO urls VALUES ('@src_stage/file.txt', 'new_filename.txt');

-- Insert additional URLs here
COPY FILES
  INTO @trg_stage
  FROM (SELECT src_file, trg_file FROM urls);

-- Example 25176
COPY FILES
  INTO @trg_stage
  FROM (SELECT src_file, trg_file FROM urls WHERE src_file LIKE '%file%');

-- Example 25177
COPY FILES
  INTO @trg_stage
  FROM (SELECT relative_path FROM directory(@src_stage) WHERE relative_path LIKE '%.txt');

-- Example 25178
CREATE STAGE my_int_stage
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 25179
from snowflake.core.stage import Stage, StageEncryption

my_stage = Stage(
  name="my_int_stage",
  encryption=StageEncryption(type="SNOWFLAKE_SSE")
)
root.databases["<database>"].schemas["<schema>"].stages.create(my_stage)

-- Example 25180
ALTER STAGE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER STAGE [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER STAGE <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Internal stage
ALTER STAGE [ IF EXISTS ] <name> SET
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  { [ COMMENT = '<string_literal>' ] }

-- External stage
ALTER STAGE [ IF EXISTS ] <name> SET {
    [ externalStageParams ]
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
    [ COMMENT = '<string_literal>' ]
    }

-- Example 25181
externalStageParams (for Amazon S3) ::=
  URL = '<protocol>://<bucket>[/<path>/]'
  [ AWS_ACCESS_POINT_ARN = '<string>' ]
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } | AWS_ROLE = '<string>'  } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] MASTER_KEY = '<string>'
                   | TYPE = 'AWS_SSE_S3'
                   | TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 25182
externalStageParams (for Google Cloud Storage) ::=
  [ URL = 'gcs://<bucket>[/<path>/]' ]
  [ STORAGE_INTEGRATION = <integration_name> } ]
  [ ENCRYPTION = (   TYPE = 'GCS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]

-- Example 25183
externalStageParams (for Microsoft Azure) ::=
  [ URL = 'azure://<account>.blob.core.windows.net/<container>[/<path>/]' ]
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = (   TYPE = 'AZURE_CSE' [ MASTER_KEY = '<string>' ]
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 25184
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

-- Example 25185
ALTER STAGE [ IF EXISTS ] <name> SET DIRECTORY = ( { ENABLE = TRUE | FALSE } )

ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 25186
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 25187
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 25188
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

-- Example 25189
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

-- Example 25190
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

-- Example 25191
ALTER STAGE my_int_stage RENAME TO new_int_stage;

-- Example 25192
ALTER STAGE my_ext_stage
SET URL='s3://loading/files/new/'
COPY_OPTIONS = (ON_ERROR='skip_file');

-- Example 25193
ALTER STAGE my_ext_stage SET STORAGE_INTEGRATION = myint;

-- Example 25194
ALTER STAGE my_ext_stage SET CREDENTIALS=(AWS_KEY_ID='d4c3b2a1' AWS_SECRET_KEY='z9y8x7w6');

-- Example 25195
ALTER STAGE my_ext_stage3 SET ENCRYPTION=(TYPE='AWS_SSE_S3');

-- Example 25196
ALTER STAGE mystage SET DIRECTORY = ( ENABLE = TRUE );

-- Example 25197
ALTER STAGE mystage REFRESH;

+-------------------------+----------------+-------------------------------+
| file                    | status         | description                   |
|-------------------------+----------------+-------------------------------|
| data/json/myfile.json   | REGISTERED_NEW | File registered successfully. |
+-------------------------+----------------+-------------------------------+

-- Example 25198
ALTER STAGE mystage REFRESH SUBPATH = 'data';

-- Example 25199
ALTER TABLE t1 SUSPEND RECLUSTER;

-- Example 25200
DROP MATERIALIZED VIEW mv1;

-- Example 25201
ALTER TABLE t1 DROP SEARCH OPTIMIZATION;

-- Example 25202
DROP TABLE t1;

-- Example 25203
DROP TABLE t1;

-- Example 25204
CREATE TRANSIENT TABLE t1;

-- Example 25205
ALTER WAREHOUSE wh1 SET MIN_CLUSTER_COUNT = 1;

-- Example 25206
{
  SHOW SNOWFLAKE.ML.ANOMALY_DETECTION           |
  SHOW SNOWFLAKE.ML.ANOMALY_DETECTION INSTANCES
}
  [ LIKE <pattern> ]
  [ IN
      {
        ACCOUNT                  |

        DATABASE                 |
        DATABASE <database_name> |

        SCHEMA                   |
        SCHEMA <schema_name>     |
        <schema_name>
      }
   ]

-- Example 25207
{
  SHOW SNOWFLAKE.ML.FORECAST           |
  SHOW SNOWFLAKE.ML.FORECAST INSTANCES
}
  [ LIKE <pattern> ]
  [ IN
      {
        ACCOUNT                  |

        DATABASE                 |
        DATABASE <database_name> |

        SCHEMA                   |
        SCHEMA <schema_name>     |
        <schema_name>
      }
   ]

-- Example 25208
organization_targets:
  access:

-- Example 25209
USE ROLE <organizational_listing_role>;

CREATE ORGANIZATION LISTING <organization_listing_name>
SHARE <share_name> AS
$$
title: "My title"
description: "One region, all accounts"
organization_profile: "INTERNAL"
organization_targets:
  discovery:
  - account: "<account_name>"
    roles:
    - "<role>"

  access:
  - account: "<account_name>"
    roles:
    - "<role>"

support_contact: "support@somedomain.com"
approver_contact: "approver@somedomain.com"
locations:
  access_regions:
  - name: "PUBLIC.<snowflake_region>"
$$;

-- Example 25210
SHOW AVAILABLE LISTINGS
  IS_ORGANIZATION = TRUE;

-- Example 25211
SHOW LISTINGS;

-- Example 25212
USE ROLE <organizational_listing_role>;

ALTER LISTING my-org-listing1
AS
$$
title: "My title"
description: "One region, all accounts"
organization_profile: INTERNAL
organization_targets:
  access:
  - account: "<account_name>"
    roles:
    - "<role>"
locations:
  access_regions:
  - name: "PUBLIC.<snowflake_region>"
$$;

-- Example 25213
title: "My title"
description: "One region, all accounts"
organization_profile: INTERNAL
organization_targets:
  access:
  - account: "<account_name>"
    roles:
    - "<role>"
locations:
  access_regions:
  - name: "PUBLIC.<snowflake_region>"

-- Example 25214
title: "My title"
description: "One region, two accounts, four roles"
organization_profile: INTERNAL
organization_targets:
  access:
  - account: "<account_name>"
    roles:
    - "<role>"
    - "<role>"
  - account: "<account_name>"
    roles:
    - "<role>"
    - "<role>"
locations:
  access_regions:
  - name: "PUBLIC.<snowflake_region>"

-- Example 25215
title : 'My title'
description: "Three region, all accounts"
organization_profile: INTERNAL
organization_targets:
  access:
  - all_accounts : true
locations:
  access_regions:
  - names:
  "PUBLIC.<snowflake_region>"
  "PUBLIC.<snowflake_region>"
  "PUBLIC.<snowflake_region>"
auto_fulfillment:
  refresh_type: "SUB_DATABASE"
  refresh_schedule: "10 MINUTE"

-- Example 25216
title : "My title"
description: "Three region, all accounts"
organization_profile: INTERNAL
organization_targets:
  access:
  - all_accounts : true
locations:
  access_regions:
  - names: "ALL"
auto_fulfillment:
  refresh_type: "SUB_DATABASE"
  refresh_schedule: "10 MINUTE"

-- Example 25217
ALTER LISTING <organizational_listing_name> UNPUBLISH;

-- Example 25218
DROP LISTING <organizational_listing_name>;

-- Example 25219
SELECT * FROM "ORGDATACLOUD$INTERNAL$MY_LISTING_NAME_123".PUBLIC.TABLE_FROM_LISTING;

-- Example 25220
organization_targets:
   access:
   - all_accounts : true

-- Example 25221
organization_targets:
   access:
   - account: 'Account1'
   - account: 'Account2'

-- Example 25222
organization_targets:
   access:
      - account: 'Account1'
         roles: [<role1>, <role2>, <role3>]

-- Example 25223
organization_targets:
   discovery:
   - all_accounts : true

-- Example 25224
organization_targets:
   discovery:
   - account: 'Account1'
   - account: 'Account2'

-- Example 25225
organization_targets:
   discovery:
      - account: 'Account1'
         roles: [<role1>, <role2>, <role3>]

-- Example 25226
locations:
  access_regions:
     - name: "ALL"

-- Example 25227
locations:
   access_regions:
     - name: "AWS_US_WEST_2"
     - name: "AZURE_CENTRALINDIAUS-EAST"

-- Example 25228
support_contact: "support@somedomain.com"
approver_contact: "approver@somedomain.com"

-- Example 25229
auto_fulfillment:
   refresh_type: SUB_DATABASE
   refresh_schedule: '10 MINUTE'

-- Example 25230
SHOW ACCOUNTS;

-- Example 25231
SELECT SYSTEM$IS_GLOBAL_DATA_SHARING_ENABLED_FOR_ACCOUNT('<account_name>');

-- Example 25232
CALL SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('<account_name>');

-- Example 25233
CALL SYSTEM$DISABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('<account_name>');

