-- Example 18738
ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18739
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_ISSUE_REFRESH_TOKENS = TRUE | FALSE ]
  [ OAUTH_REDIRECT_URI ] = '<uri>'
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_USE_SECONDARY_ROLES = IMPLICIT | NONE ]
  [ BLOCKED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> UNSET {
  ENABLED |
  COMMENT
  }
  [ , ... ]

-- Example 18740
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_REDIRECT_URI = '<uri>' ]
  [ OAUTH_ALLOW_NON_TLS_REDIRECT_URI = TRUE | FALSE ]
  [ OAUTH_ENFORCE_PKCE = TRUE | FALSE ]
  [ PRE_AUTHORIZED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ BLOCKED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ OAUTH_ISSUE_REFRESH_TOKENS = TRUE | FALSE ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_USE_SECONDARY_ROLES = IMPLICIT | NONE ]
  [ NETWORK_POLICY = '<network_policy>' ]
  [ OAUTH_CLIENT_RSA_PUBLIC_KEY = <public_key1> ]
  [ OAUTH_CLIENT_RSA_PUBLIC_KEY_2 = <public_key2> ]
  [ COMMENT = '{string_literal}' ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name>  UNSET {
                                                           ENABLED                       |
                                                           NETWORK_POLICY                |
                                                           OAUTH_CLIENT_RSA_PUBLIC_KEY   |
                                                           OAUTH_CLIENT_RSA_PUBLIC_KEY_2 |
                                                           OAUTH_USE_SECONDARY_ROLES = IMPLICIT | NONE
                                                           COMMENT
                                                           }
                                                           [ , ... ]

-- Example 18741
ALTER SECURITY INTEGRATION myint SET ENABLED = TRUE;

-- Example 18742
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET
    [ TYPE = SAML2 ]
    [ ENABLED = { TRUE | FALSE } ]
    [ SAML2_ISSUER = '<string_literal>' ]
    [ SAML2_SSO_URL = '<string_literal>' ]
    [ SAML2_PROVIDER = '<string_literal>' ]
    [ SAML2_X509_CERT = '<string_literal>' ]
    [ ALLOWED_USER_DOMAINS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
    [ ALLOWED_EMAIL_PATTERNS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
    [ SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = '<string_literal>' ]
    [ SAML2_ENABLE_SP_INITIATED = TRUE | FALSE ]
    [ SAML2_SNOWFLAKE_X509_CERT = '<string_literal>' ]
    [ SAML2_SIGN_REQUEST = TRUE | FALSE ]
    [ SAML2_REQUESTED_NAMEID_FORMAT = '<string_literal>' ]
    [ SAML2_POST_LOGOUT_REDIRECT_URL = '<string_literal>' ]
    [ SAML2_FORCE_AUTHN = TRUE | FALSE ]
    [ SAML2_SNOWFLAKE_ISSUER_URL = '<string_literal>' ]
    [ SAML2_SNOWFLAKE_ACS_URL = '<string_literal>' ]
    [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> UNSET {
    ENABLED |
    [ , ... ]
    }

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ SECURITY ] INTEGRATION <name> REFRESH SAML2_SNOWFLAKE_PRIVATE_KEY

-- Example 18743
ALTER SECURITY INTEGRATION myint SET ENABLED = TRUE;

-- Example 18744
alter security integration my_idp refresh SAML2_SNOWFLAKE_PRIVATE_KEY;

-- Example 18745
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET
    [ ENABLED = { TRUE | FALSE } ]
    [ NETWORK_POLICY = '<network_policy>' ]
    [ SYNC_PASSWORD = { TRUE | FALSE } ]
    [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name>  UNSET {
                                                            NETWORK_POLICY |
                                                            [ , ... ]
                                                            }
ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18746
ALTER SECURITY INTEGRATION myint SET ENABLED = TRUE;

-- Example 18747
ALTER SEQUENCE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER SEQUENCE [ IF EXISTS ] <name> [ SET ] [ INCREMENT [ BY ] [ = ] <sequence_interval> ]

ALTER SEQUENCE [ IF EXISTS ] <name> SET
  [ { ORDER | NOORDER } ]
  [ COMMENT = '<string_literal>' ]

ALTER SEQUENCE [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18748
ALTER SEQUENCE myseq RENAME TO newseq;

-- Example 18749
ALTER SESSION SET sessionParams

ALTER SESSION UNSET <param_name> [ , <param_name> , ... ]

-- Example 18750
sessionParams ::=
  ABORT_DETACHED_QUERY = TRUE | FALSE
  ACTIVE_PYTHON_PROFILER = 'LINE' | 'MEMORY'
  AUTOCOMMIT = TRUE | FALSE
  BINARY_INPUT_FORMAT = <string>
  BINARY_OUTPUT_FORMAT = <string>
  DATE_INPUT_FORMAT = <string>
  DATE_OUTPUT_FORMAT = <string>
  ERROR_ON_NONDETERMINISTIC_MERGE = TRUE | FALSE
  ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE | FALSE
  GEOGRAPHY_OUTPUT_FORMAT = 'GeoJSON' | 'WKT' | 'WKB' | 'EWKT' | 'EWKB'
  HYBRID_TABLE_LOCK_TIMEOUT = <num>
  JSON_INDENT = <num>
  LOG_LEVEL = <string>
  LOCK_TIMEOUT = <num>
  PYTHON_PROFILER_TARGET_STAGE = <string>
  PYTHON_PROFILER_MODULES = <string>
  QUERY_TAG = <string>
  ROWS_PER_RESULTSET = <num>
  S3_STAGE_VPCE_DNS_NAME = <string>
  SEARCH_PATH = <string>
  SIMULATED_DATA_SHARING_CONSUMER = <string>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>
  STRICT_JSON_OUTPUT = TRUE | FALSE
  TIMESTAMP_DAY_IS_ALWAYS_24H = TRUE | FALSE
  TIMESTAMP_INPUT_FORMAT = <string>
  TIMESTAMP_LTZ_OUTPUT_FORMAT = <string>
  TIMESTAMP_NTZ_OUTPUT_FORMAT = <string>
  TIMESTAMP_OUTPUT_FORMAT = <string>
  TIMESTAMP_TYPE_MAPPING = <string>
  TIMESTAMP_TZ_OUTPUT_FORMAT = <string>
  TIMEZONE = <string>
  TIME_INPUT_FORMAT = <string>
  TIME_OUTPUT_FORMAT = <string>
  TRACE_LEVEL = <string>
  TRANSACTION_DEFAULT_ISOLATION_LEVEL = <string>
  TWO_DIGIT_CENTURY_START = <num>
  UNSUPPORTED_DDL_ACTION = <string>
  USE_CACHED_RESULT = TRUE | FALSE
  WEEK_OF_YEAR_POLICY = <num>
  WEEK_START = <num>

-- Example 18751
ALTER SESSION SET LOCK_TIMEOUT = 3600;

-- Example 18752
ALTER SESSION UNSET LOCK_TIMEOUT;

-- Example 18753
ALTER [ STORAGE ] INTEGRATION [ IF EXISTS ] <name> SET
  [ cloudProviderParams ]
  [ ENABLED = { TRUE | FALSE } ]
  [ STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/' [ , '<cloud>://<bucket>/<path>/' ... ] ) ]
  [ STORAGE_BLOCKED_LOCATIONS = ('<cloud>://<bucket>/<path>/' [ , '<cloud>://<bucket>/<path>/' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER [ STORAGE ] INTEGRATION [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ STORAGE ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ STORAGE ] INTEGRATION [ IF EXISTS ] <name>  UNSET {
                                                          ENABLED                   |
                                                          STORAGE_BLOCKED_LOCATIONS |
                                                          COMMENT
                                                          }
                                                          [ , ... ]

-- Example 18754
cloudProviderParams (for Amazon S3) ::=
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  [ STORAGE_AWS_OBJECT_ACL = 'bucket-owner-full-control' ]
  [ STORAGE_AWS_EXTERNAL_ID = '<external_id>' ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 18755
cloudProviderParams (for Microsoft Azure) ::=
  AZURE_TENANT_ID = '<tenant_id>'
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 18756
ALTER STORAGE INTEGRATION myint SET ENABLED = TRUE;

-- Example 18757
ALTER STREAM [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER STREAM [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER STREAM <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER STREAM [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18758
ALTER STREAM mystream SET COMMENT = 'New comment for stream';

-- Example 18759
ALTER STREAMLIT [ IF EXISTS ] <name> SET
  [ ROOT_LOCATION = '<stage_path_and_root_directory>' ]
  [ MAIN_FILE = '<path_to_main_file>']
  [ QUERY_WAREHOUSE = <warehouse_name> ]
  [ COMMENT = '<string_literal>']
  [ TITLE = '<app_title>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <integration_name> [ , ... ] ) ]

ALTER STREAMLIT [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER STREAMLIT <name> COMMIT

ALTER STREAMLIT <name> PUSH [ TO <git_branch_uri> ]
  [ { GIT_CREDENTIALS = <snowflake_secret> | USERNAME = <git_username> PASSWORD = <git_password> } NAME = <git_author_name> EMAIL = <git_author_email> ]
  [ COMMENT = <git_push_comment> ]

ALTER STREAMLIT <name> ABORT

ALTER STREAMLIT <name> PULL

-- Example 18760
CREATE ACCOUNT <name>
      ADMIN_NAME = '<string_literal>'
    { ADMIN_PASSWORD = '<string_literal>' | ADMIN_RSA_PUBLIC_KEY = '<string_literal>' }
    [ ADMIN_USER_TYPE = { PERSON | SERVICE | LEGACY_SERVICE | NULL } ]
    [ FIRST_NAME = '<string_literal>' ]
    [ LAST_NAME = '<string_literal>' ]
      EMAIL = '<string_literal>'
    [ MUST_CHANGE_PASSWORD = { TRUE | FALSE } ]
      EDITION = { STANDARD | ENTERPRISE | BUSINESS_CRITICAL }
    [ REGION_GROUP = <region_group_id> ]
    [ REGION = <snowflake_region_id> ]
    [ COMMENT = '<string_literal>' ]
    [ POLARIS = { TRUE | FALSE } ]

-- Example 18761
create account myaccount1
  admin_name = admin
  admin_password = 'TestPassword1'
  first_name = Jane
  last_name = Smith
  email = 'myemail@myorg.org'
  edition = enterprise
  region = aws_us_west_2;

-- Example 18762
create account myaccount2
  admin_name = admin
  admin_password = 'TestPassword1'
  email = 'myemail@myorg.org'
  edition = enterprise;

-- Example 18763
create account myaccount1
  admin_name = admin
  admin_password = 'TestPassword1'
  first_name = Jane
  last_name = Smith
  email = 'myemail@myorg.org'
  edition = enterprise
  region = aws_us_west_2
  polaris = true;

-- Example 18764
CREATE [ OR REPLACE ] AUTHENTICATION POLICY [ IF NOT EXISTS ] <name>
  [ AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_ENROLLMENT = { REQUIRED | OPTIONAL } ]
  [ CLIENT_TYPES = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ SECURITY_INTEGRATIONS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18765
CREATE OR ALTER AUTHENTICATION POLICY <name>
  [ AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_ENROLLMENT = { REQUIRED | OPTIONAL } ]
  [ CLIENT_TYPES = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ SECURITY_INTEGRATIONS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18766
CREATE AUTHENTICATION POLICY restrict_client_types_policy
  CLIENT_TYPES = ('SNOWFLAKE_UI')
  COMMENT = 'Auth policy that only allows access through the web interface';

-- Example 18767
CREATE OR ALTER AUTHENTICATION POLICY restrict_client_types_policy
  MFA_ENROLLMENT = REQUIRED
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWFLAKE_CLI');

-- Example 18768
CREATE [ OR REPLACE ] CATALOG INTEGRATION [IF NOT EXISTS]
  <name>
  CATALOG_SOURCE = GLUE
  TABLE_FORMAT = ICEBERG
  GLUE_AWS_ROLE_ARN = '<arn-for-AWS-role-to-assume>'
  GLUE_CATALOG_ID = '<glue-catalog-id>'
  [ GLUE_REGION = '<AWS-region-of-the-glue-catalog>' ]
  [ CATALOG_NAMESPACE = '<catalog-namespace>' ]
  ENABLED = { TRUE | FALSE }
  [ REFRESH_INTERVAL_SECONDS = <value> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18769
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "catalog_name" = 'my_catalog_integration_1';

-- Example 18770
CREATE CATALOG INTEGRATION glueCatalogInt
  CATALOG_SOURCE = GLUE
  CATALOG_NAMESPACE = 'myNamespace'
  TABLE_FORMAT = ICEBERG
  GLUE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/myGlueRole'
  GLUE_CATALOG_ID = '123456789012'
  GLUE_REGION = 'us-east-2'
  ENABLED = TRUE;

-- Example 18771
CREATE [ OR REPLACE ] CATALOG INTEGRATION [IF NOT EXISTS]
  <name>
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = { ICEBERG | DELTA }
  ENABLED = { TRUE | FALSE }
  [ REFRESH_INTERVAL_SECONDS = <value> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18772
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "catalog_name" = 'my_catalog_integration_1';

-- Example 18773
CREATE CATALOG INTEGRATION myCatalogInt
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = ICEBERG
  ENABLED = TRUE;

-- Example 18774
CREATE [ OR REPLACE ] CATALOG INTEGRATION [ IF NOT EXISTS ]
  <name>
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  [ CATALOG_NAMESPACE = '<open_catalog_namespace>' ]
  REST_CONFIG = (
    CATALOG_URI = '<open_catalog_account_url>'
    CATALOG_NAME = '<open_catalog_catalog_name>'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = '<oauth_client_id>'
    OAUTH_CLIENT_SECRET = '<oauth_secret>'
    OAUTH_ALLOWED_SCOPES = ('<scope 1>', '<scope 2>')
  )
  ENABLED = { TRUE | FALSE }
  [ REFRESH_INTERVAL_SECONDS = <value> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18775
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "catalog_name" = 'my_catalog_integration_1';

-- Example 18776
CREATE OR REPLACE CATALOG INTEGRATION open_catalog_int
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my_catalog_namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://my_org_name-my_snowflake_open_catalog_account_name.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'my_catalog_name'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'my_client_id'
    OAUTH_CLIENT_SECRET = 'my_client_secret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;

-- Example 18777
CREATE OR REPLACE CATALOG INTEGRATION open_catalog_int2
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  REST_CONFIG = (
    CATALOG_URI = 'https://my_org_name-my_snowflake_open_catalog_account_name.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'customers'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'my_client_id'
    OAUTH_CLIENT_SECRET = 'my_client_secret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;

-- Example 18778
CREATE [ OR REPLACE ] CATALOG INTEGRATION [ IF NOT EXISTS ] <name>
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  [ CATALOG_NAMESPACE = '<namespace>' ]
  REST_CONFIG = (
    restConfigParams
  )
  REST_AUTHENTICATION = (
    restAuthenticationParams
  )
  ENABLED = { TRUE | FALSE }
  [ REFRESH_INTERVAL_SECONDS = <value> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18779
restConfigParams ::=

  CATALOG_URI = '<rest_api_endpoint_url>'
  [ PREFIX = '<prefix>' ]
  [ CATALOG_NAME = '<catalog_name>' ]
  [ CATALOG_API_TYPE = { PUBLIC | AWS_API_GATEWAY | AWS_PRIVATE_API_GATEWAY | AWS_GLUE } ]

-- Example 18780
restAuthenticationParams (for OAuth) ::=

  TYPE = OAUTH
  [ OAUTH_TOKEN_URI = 'https://<token_server_uri>' ]
  OAUTH_CLIENT_ID = '<oauth_client_id>'
  OAUTH_CLIENT_SECRET = '<oauth_client_secret>'
  OAUTH_ALLOWED_SCOPES = ('<scope_1>', '<scope_2>')

-- Example 18781
restAuthenticationParams (for Bearer token) ::=

  TYPE = BEARER
  BEARER_TOKEN = '<bearer_token>'

-- Example 18782
restAuthenticationParams (for SigV4) ::=

  TYPE = SIGV4
  SIGV4_IAM_ROLE = '<iam_role_arn>'
  [ SIGV4_SIGNING_REGION = '<region>' ]
  [ SIGV4_EXTERNAL_ID = '<external_id>' ]

-- Example 18783
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "catalog_name" = 'my_catalog_integration_1';

-- Example 18784
CREATE OR REPLACE CATALOG INTEGRATION tabular_catalog_int
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'default'
  REST_CONFIG = (
    CATALOG_URI = 'https://api.tabular.io/ws'
    CATALOG_NAME = '<tabular_warehouse_name>'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_TOKEN_URI = 'https://api.tabular.io/ws/v1/oauth/tokens'
    OAUTH_CLIENT_ID = '<oauth_client_id>'
    OAUTH_CLIENT_SECRET = '<oauth_client_secret>'
    OAUTH_ALLOWED_SCOPES = ('catalog')
  )
  ENABLED = TRUE;

-- Example 18785
CREATE CATALOG INTEGRATION glue_rest_catalog_int
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'rest_catalog_integration'
  REST_CONFIG = (
    CATALOG_URI = 'https://glue.us-west-2.amazonaws.com/iceberg'
    CATALOG_API_TYPE = AWS_GLUE
    CATALOG_NAME = '123456789012'
  )
  REST_AUTHENTICATION = (
    TYPE = SIGV4
    SIGV4_IAM_ROLE = 'arn:aws:iam::123456789012:role/my-role'
    SIGV4_SIGNING_REGION = 'us-west-2'
  )
  ENABLED = TRUE;

-- Example 18786
CREATE [ OR REPLACE ] [ SECURE ] DATA METRIC FUNCTION [ IF NOT EXISTS ] <name>
  ( <table_arg> TABLE( <col_arg> <data_type> [ , ... ] )
    [ , <table_arg> TABLE( <col_arg> <data_type> [ , ... ] ) ] )
  RETURNS NUMBER [ [ NOT ] NULL ]
  [ LANGUAGE SQL ]
  [ COMMENT = '<string_literal>' ]
  AS
  '<expression>'

-- Example 18787
CREATE [ OR ALTER ] DATA METRIC FUNCTION ...

-- Example 18788
CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.count_positive_numbers(
  arg_t TABLE(
    arg_c1 NUMBER,
    arg_c2 NUMBER,
    arg_c3 NUMBER
  )
)
RETURNS NUMBER
AS
$$
  SELECT
    COUNT(*)
  FROM arg_t
  WHERE
    arg_c1>0
    AND arg_c2>0
    AND arg_c3>0
$$;

-- Example 18789
CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.referential_check(
  arg_t1 TABLE (arg_c1 INT), arg_t2 TABLE (arg_c2 INT))
RETURNS NUMBER
AS
$$
  SELECT
    COUNT(*)
    FROM arg_t1
  WHERE
    arg_c1 NOT IN (SELECT arg_c2 FROM arg_t2)
$$;

-- Example 18790
CREATE OR ALTER SECURE DATA METRIC FUNCTION governance.dmfs.count_positive_numbers(
  arg_t TABLE(
    arg_c1 NUMBER,
    arg_c2 NUMBER,
    arg_c3 NUMBER
  )
)
RETURNS NUMBER
COMMENT = "count positive numbers"
AS
$$
  SELECT
    COUNT(*)
  FROM arg_t
  WHERE
    arg_c1>0
    AND arg_c2>0
    AND arg_c3>0
$$;

-- Example 18791
CREATE [ OR REPLACE ] DATABASE ROLE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 18792
CREATE OR ALTER DATABASE ROLE <name>
  [ COMMENT = '<string_literal>' ]

-- Example 18793
CREATE DATABASE ROLE d1.dr1;

-- Example 18794
CREATE [ OR REPLACE ] EVENT TABLE [ IF NOT EXISTS ] <name>
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ COPY GRANTS ]
  [ [ WITH ] COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18795
CREATE [ OR REPLACE ] EVENT TABLE [ IF NOT EXISTS ] <name>
  CLONE <source_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [ COPY GRANTS ]
    [ ... ]

-- Example 18796
CREATE EVENT TABLE my_events;

-- Example 18797
CREATE [ OR REPLACE ] [ SECURE ] EXTERNAL FUNCTION <name> ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ COMMENT = '<string_literal>' ]
  API_INTEGRATION = <api_integration_name>
  [ HEADERS = ( '<header_1>' = '<value_1>' [ , '<header_2>' = '<value_2>' ... ] ) ]
  [ CONTEXT_HEADERS = ( <context_function_1> [ , <context_function_2> ...] ) ]
  [ MAX_BATCH_ROWS = <integer> ]
  [ COMPRESSION = <compression_type> ]
  [ REQUEST_TRANSLATOR = <request_translator_udf_name> ]
  [ RESPONSE_TRANSLATOR = <response_translator_udf_name> ]
  AS '<url_of_proxy_and_resource>';

-- Example 18798
CREATE [ OR ALTER ] EXTERNAL FUNCTION ...

-- Example 18799
HEADERS = (
    'volume-measure' = 'liters',
    'distance-measure' = 'kilometers'
)

-- Example 18800
CONTEXT_HEADERS = (current_timestamp)

-- Example 18801
select
  /*ÄÎßë¬±©®*/
  my_external_function(1);

-- Example 18802
select /* */ my_external_function(1);

-- Example 18803
base64_encode('select\n/ÄÎßë¬±©®/\nmy_external_function(1)')

-- Example 18804
sf-context-<context-function>-base64

