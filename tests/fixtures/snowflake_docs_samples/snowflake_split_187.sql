-- Example 12509
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET { SECURE | LOG_LEVEL | TRACE_LEVEL | COMMENT }

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ COMMENT = '<string_literal>' ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12510
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET { SECURE | LOG_LEVEL | TRACE_LEVEL | COMMENT }

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <integration_name> [ , <integration_name> ... ] ) ]
  [ SECRETS = ( '<secret_variable_name>' = <secret_name> [ , '<secret_variable_name>' = <secret_name> ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12511
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET { SECURE | LOG_LEVEL | TRACE_LEVEL | COMMENT }

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <integration_name> [ , <integration_name> ... ] ) ]
  [ SECRETS = ( '<secret_variable_name>' = <secret_name> [ , '<secret_variable_name>' = <secret_name> ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12512
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET { SECURE | LOG_LEVEL | TRACE_LEVEL | COMMENT }

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ COMMENT = '<string_literal>' ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12513
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET API_INTEGRATION = <api_integration_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET HEADERS = ( [ '<header_1>' = '<value>' [ , '<header_2>' = '<value>' ... ] ] )

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET CONTEXT_HEADERS = ( [ <context_function_1> [ , <context_function_2> ...] ] )

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET MAX_BATCH_ROWS = <integer>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET COMPRESSION = <compression_type>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET { REQUEST_TRANSLATOR | RESPONSE_TRANSLATOR } = <udf_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET
              { COMMENT | HEADERS | CONTEXT_HEADERS | MAX_BATCH_ROWS | COMPRESSION | SECURE | REQUEST_TRANSLATOR | RESPONSE_TRANSLATOR }

-- Example 12514
ALTER FUNCTION IF EXISTS function1(number) RENAME TO function2;

-- Example 12515
ALTER FUNCTION function2(number) SET SECURE;

-- Example 12516
ALTER FUNCTION function4(number) SET API_INTEGRATION = api_integration_2;

-- Example 12517
ALTER FUNCTION function5(number) SET MAX_BATCH_ROWS = 100;

-- Example 12518
ALTER PASSWORD POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER PASSWORD POLICY [ IF EXISTS ] <name> SET [ PASSWORD_MIN_LENGTH = <integer> ]
                                               [ PASSWORD_MAX_LENGTH = <integer> ]
                                               [ PASSWORD_MIN_UPPER_CASE_CHARS = <integer> ]
                                               [ PASSWORD_MIN_LOWER_CASE_CHARS = <integer> ]
                                               [ PASSWORD_MIN_NUMERIC_CHARS = <integer> ]
                                               [ PASSWORD_MIN_SPECIAL_CHARS = <integer> ]
                                               [ PASSWORD_MIN_AGE_DAYS = <integer> ]
                                               [ PASSWORD_MAX_AGE_DAYS = <integer> ]
                                               [ PASSWORD_MAX_RETRIES = <integer> ]
                                               [ PASSWORD_LOCKOUT_TIME_MINS = <integer> ]
                                               [ PASSWORD_HISTORY = <integer> ]
                                               [ COMMENT = '<string_literal>' ]

ALTER PASSWORD POLICY [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PASSWORD POLICY [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PASSWORD POLICY [ IF EXISTS ] <name> UNSET [ PASSWORD_MIN_LENGTH ]
                                                 [ PASSWORD_MAX_LENGTH ]
                                                 [ PASSWORD_MIN_UPPER_CASE_CHARS ]
                                                 [ PASSWORD_MIN_LOWER_CASE_CHARS ]
                                                 [ PASSWORD_MIN_NUMERIC_CHARS ]
                                                 [ PASSWORD_MIN_SPECIAL_CHARS ]
                                                 [ PASSWORD_MIN_AGE_DAYS ]
                                                 [ PASSWORD_MAX_AGE_DAYS ]
                                                 [ PASSWORD_MAX_RETRIES ]
                                                 [ PASSWORD_LOCKOUT_TIME_MINS ]
                                                 [ PASSWORD_HISTORY ]
                                                 [ COMMENT ]

-- Example 12519
DESC PASSWORD POLICY password_policy_prod_1;

ALTER PASSWORD POLICY password_policy_prod_1 SET PASSWORD_MAX_RETRIES = 3;

-- Example 12520
ALTER ROW ACCESS POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER ROW ACCESS POLICY [ IF EXISTS ] <name> SET BODY -> <expression_on_arg_name>

ALTER ROW ACCESS POLICY [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER ROW ACCESS POLICY [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER ROW ACCESS POLICY [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER ROW ACCESS POLICY [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12521
DESC ROW ACCESS POLICY rap_table_employee_info;

-- Example 12522
+-------------------------+-------------+-------------+------+
| name                    | signature   | return_type | body |
+-------------------------+-------------+-------------+------+
| rap_table_employee_info | (V VARCHAR) | BOOLEAN     | true |
+-------------------------+-------------+-------------+------+

-- Example 12523
ALTER ROW ACCESS POLICY rap_table_employee_info SET BODY -> false;

-- Example 12524
ALTER SESSION POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER SESSION POLICY [ IF EXISTS ] <name> SET
  [ SESSION_IDLE_TIMEOUT_MINS = <integer> ]
  [ SESSION_UI_IDLE_TIMEOUT_MINS = <integer> ]
  [ ALLOWED_SECONDARY_ROLES = ( [ { 'ALL' | <role_name> [ , <role_name> ... ] } ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER SESSION POLICY [ IF EXISTS ] <name> SET
  TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER SESSION POLICY [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER SESSION POLICY [ IF EXISTS ] <name> UNSET
  [ SESSION_IDLE_TIMEOUT_MINS ]
  [ SESSION_UI_IDLE_TIMEOUT_MINS ]
  [ ALLOWED_SECONDARY_ROLES ]
  [ COMMENT ]

-- Example 12525
DESC SESSION POLICY session_policy_prod_1;

-- Example 12526
+---------------------------------+-----------------------+------------------------+--------------------------+--------------------------------------------------+
| createdOn                       | name                  | sessionIdleTimeoutMins | sessionUIIdleTimeoutMins | comment                                          |
+---------------------------------+-----------------------+------------------------+--------------------------+--------------------------------------------------+
| Mon, 11 Jan 2021 00:00:00 -0700 | session_policy_prod_1 | 30                     | 30                       | session policy for use in the prod_1 environment |
+---------------------------------+-----------------------+------------------------+--------------------------+--------------------------------------------------+

-- Example 12527
ALTER SESSION POLICY session_policy_prod_1 SET SESSION_UI_IDLE_TIMEOUT_MINS = 15;

-- Example 12528
ALTER AGGREGATION POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER AGGREGATION POLICY [ IF EXISTS ] <name> SET BODY -> <expression>

ALTER AGGREGATION POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER AGGREGATION POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER AGGREGATION POLICY [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER AGGREGATION POLICY [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12529
AGGREGATION_CONSTRAINT (
    { MIN_GROUP_SIZE => <integer_expression>
    | MIN_ROW_COUNT => <integer_expression>, MIN_ENTITY_COUNT => <integer_expression>
    }
)

-- Example 12530
ALTER AGGREGATION POLICY my_policy SET BODY -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE=>2);

-- Example 12531
ALTER AGGREGATION POLICY my_policy RENAME TO agg_policy_table1;

-- Example 12532
ALTER JOIN POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER JOIN POLICY [ IF EXISTS ] <name> SET BODY -> <expression>

ALTER JOIN POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER JOIN POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER JOIN POLICY [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER JOIN POLICY [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12533
JOIN_CONSTRAINT (
  { JOIN_REQUIRED => <boolean_expression> }
  )

-- Example 12534
ALTER JOIN POLICY jp3 SET BODY -> JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE);

-- Example 12535
ALTER JOIN POLICY my_join_policy RENAME TO my_join_policy_2;

-- Example 12536
ALTER PROJECTION POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER PROJECTION POLICY [ IF EXISTS ] <name> SET BODY -> <expression>

ALTER PROJECTION POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PROJECTION POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PROJECTION POLICY [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER PROJECTION POLICY [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12537
ALTER PROJECTION POLICY mypolicy RENAME TO proj_policy_acctnumber;

-- Example 12538
ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = '<integration_name>' [ , '<integration_name>' ... ] ]
  [ SECRETS = '<secret_variable_name>' = <secret_name> [ , '<secret_variable_name>' = <secret_name> ... ] ]
  [ COMMENT = '<string_literal>' ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET COMMENT

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER }

-- Example 12539
ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ COMMENT = '<string_literal>' ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET COMMENT

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER }

-- Example 12540
ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = '<integration_name>' [ , '<integration_name>' ... ] ]
  [ SECRETS = '<secret_variable_name>' = <secret_name> [ , '<secret_variable_name>' = <secret_name> ... ] ]
  [ COMMENT = '<string_literal>' ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET COMMENT

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER }

-- Example 12541
ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = '<integration_name>' [ , '<integration_name>' ... ] ]
  [ SECRETS = '<secret_variable_name>' = <secret_name> [ , '<secret_variable_name>' = <secret_name> ... ] ]
  [ COMMENT = '<string_literal>' ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET COMMENT

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER }

-- Example 12542
ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ AUTO_EVENT_LOGGING = '<option>' ]
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ COMMENT = '<string_literal>' ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET COMMENT

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PROCEDURE [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER }

-- Example 12543
ALTER PROCEDURE IF EXISTS procedure1(FLOAT) RENAME TO procedure2;

-- Example 12544
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

-- Example 12545
externalStageParams (for Amazon S3) ::=
  URL = '<protocol>://<bucket>[/<path>/]'
  [ AWS_ACCESS_POINT_ARN = '<string>' ]
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } | AWS_ROLE = '<string>'  } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] MASTER_KEY = '<string>'
                   | TYPE = 'AWS_SSE_S3'
                   | TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 12546
externalStageParams (for Google Cloud Storage) ::=
  [ URL = 'gcs://<bucket>[/<path>/]' ]
  [ STORAGE_INTEGRATION = <integration_name> } ]
  [ ENCRYPTION = (   TYPE = 'GCS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]

-- Example 12547
externalStageParams (for Microsoft Azure) ::=
  [ URL = 'azure://<account>.blob.core.windows.net/<container>[/<path>/]' ]
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = (   TYPE = 'AZURE_CSE' [ MASTER_KEY = '<string>' ]
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 12548
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

-- Example 12549
ALTER STAGE [ IF EXISTS ] <name> SET DIRECTORY = ( { ENABLE = TRUE | FALSE } )

ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 12550
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 12551
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 12552
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

-- Example 12553
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

-- Example 12554
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

-- Example 12555
ALTER STAGE my_int_stage RENAME TO new_int_stage;

-- Example 12556
ALTER STAGE my_ext_stage
SET URL='s3://loading/files/new/'
COPY_OPTIONS = (ON_ERROR='skip_file');

-- Example 12557
ALTER STAGE my_ext_stage SET STORAGE_INTEGRATION = myint;

-- Example 12558
ALTER STAGE my_ext_stage SET CREDENTIALS=(AWS_KEY_ID='d4c3b2a1' AWS_SECRET_KEY='z9y8x7w6');

-- Example 12559
ALTER STAGE my_ext_stage3 SET ENCRYPTION=(TYPE='AWS_SSE_S3');

-- Example 12560
ALTER STAGE mystage SET DIRECTORY = ( ENABLE = TRUE );

-- Example 12561
ALTER STAGE mystage REFRESH;

+-------------------------+----------------+-------------------------------+
| file                    | status         | description                   |
|-------------------------+----------------+-------------------------------|
| data/json/myfile.json   | REGISTERED_NEW | File registered successfully. |
+-------------------------+----------------+-------------------------------+

-- Example 12562
ALTER STAGE mystage REFRESH SUBPATH = 'data';

-- Example 12563
ALTER TABLE [ IF EXISTS ] <name> RENAME TO <new_table_name>

ALTER TABLE [ IF EXISTS ] <name> clusteringAction

ALTER TABLE [ IF EXISTS ] <name> dataGovnPolicyTagAction

ALTER TABLE [ IF EXISTS ] <name> searchOptimizationAction

ALTER TABLE [ IF EXISTS ] <name> SET
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE  } ]
  [ COMMENT = '<string_literal>' ]

ALTER TABLE [ IF EXISTS ] <name> UNSET {
                                       DATA_RETENTION_TIME_IN_DAYS         |
                                       MAX_DATA_EXTENSION_TIME_IN_DAYS     |
                                       CHANGE_TRACKING                     |
                                       COMMENT                             |
                                       }

-- Example 12564
clusteringAction ::=
  {
     CLUSTER BY ( <expr> [ , <expr> , ... ] )
   | { SUSPEND | RESUME } RECLUSTER
   | DROP CLUSTERING KEY
  }

-- Example 12565
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

-- Example 12566
searchOptimizationAction ::=
  {
     ADD SEARCH OPTIMIZATION [
       ON <search_method_with_target> [ , <search_method_with_target> ... ]
     ]

   | DROP SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]

  }

-- Example 12567
<search_method>(<target> [, ...])

-- Example 12568
-- Allowed
ON SUBSTRING(*)
ON EQUALITY(*), SUBSTRING(*), GEO(*)

-- Example 12569
-- Not allowed
ON EQUALITY(*, c1)
ON EQUALITY(c1, *)
ON EQUALITY(v1:path, *)
ON EQUALITY(c1), EQUALITY(*)

-- Example 12570
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 12571
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c3, c4);

-- Example 12572
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3, c4);

-- Example 12573
CREATE TABLE parent ... CONSTRAINT primary_key_1 PRIMARY KEY (c_1, c_2) ...
CREATE TABLE child  ... CONSTRAINT foreign_key_1 FOREIGN KEY (...) REFERENCES parent (c_1, c_2) ...

-- Example 12574
CREATE OR REPLACE TABLE t1(a1 number);

SHOW TABLES LIKE 't1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
 Tue, 17 Mar 2015 16:52:33 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         |            | 0    | 0     | PUBLIC | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+

ALTER TABLE t1 RENAME TO tt1;

SHOW TABLES LIKE 'tt1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
 Tue, 17 Mar 2015 16:52:33 -0700 | TT1  | TESTDB        | MY_SCHEMA   | TABLE |         |            | 0    | 0     | PUBLIC | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+

-- Example 12575
CREATE OR REPLACE TABLE T1 (id NUMBER, date TIMESTAMP_NTZ, name STRING) CLUSTER BY (id, date);

SHOW TABLES LIKE 'T1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (ID,DATE)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Change the order of the clustering key
ALTER TABLE t1 CLUSTER BY (date, id);

SHOW TABLES LIKE 'T1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (DATE,ID)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

