-- Example 18872
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  ENABLED = { TRUE | FALSE }
  TYPE = QUEUE
  DIRECTION = OUTBOUND
  NOTIFICATION_PROVIDER = AWS_SNS
  AWS_SNS_TOPIC_ARN = '<topic_arn>'
  AWS_SNS_ROLE_ARN = '<iam_role_arn>'
  [ COMMENT = '<string_literal>' ]

-- Example 18873
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  ENABLED = { TRUE | FALSE }
  TYPE = QUEUE
  DIRECTION = OUTBOUND
  NOTIFICATION_PROVIDER = AZURE_EVENT_GRID
  AZURE_EVENT_GRID_TOPIC_ENDPOINT = '<event_grid_topic_endpoint>'
  AZURE_TENANT_ID = '<ad_directory_id>';
  [ COMMENT = '<string_literal>' ]

-- Example 18874
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  ENABLED = { TRUE | FALSE }
  TYPE = QUEUE
  DIRECTION = OUTBOUND
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  GCP_PUBSUB_TOPIC_NAME = '<topic_id>'
  [ COMMENT = '<string_literal>' ]

-- Example 18875
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  TYPE = WEBHOOK
  ENABLED = { TRUE | FALSE }
  WEBHOOK_URL = '<url>'
  [ WEBHOOK_SECRET = <secret_name> ]
  [ WEBHOOK_BODY_TEMPLATE = '<template_for_http_request_body>' ]
  [ WEBHOOK_HEADERS = ( '<header_1>'='<value_1>' [ , '<header_N>'='<value_N>', ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18876
https://<hostname>.webhook.office.com/webhookb2/<path_components>/IncomingWebhook/<path_components>

-- Example 18877
WEBHOOK_URL='https://hooks.slack.com/services/SNOWFLAKE_WEBHOOK_SECRET'

-- Example 18878
WEBHOOK_SECRET = my_secrets_db.my_secrets_schema.my_slack_webhook_secret

-- Example 18879
WEBHOOK_BODY_TEMPLATE='{
  "routing_key": "SNOWFLAKE_WEBHOOK_SECRET",
  "event_action": "trigger",
  "payload":
    {
      "summary": "SNOWFLAKE_WEBHOOK_MESSAGE",
      "source": "Snowflake monitoring",
      "severity": "INFO",
    }
  }'

-- Example 18880
WEBHOOK_HEADERS=('Content-Type'='application/json')

-- Example 18881
WEBHOOK_HEADERS=('Authorization'='Basic SNOWFLAKE_WEBHOOK_SECRET')

-- Example 18882
CREATE ORGANIZATION ACCOUNT <name>
    ADMIN_NAME = <string>
    { ADMIN_PASSWORD = '<string_literal>' | ADMIN_RSA_PUBLIC_KEY = <string> }
    [ FIRST_NAME = <string> ]
    [ LAST_NAME = <string> ]
    EMAIL = '<string>'
    [ MUST_CHANGE_PASSWORD = { TRUE | FALSE } ]
    EDITION = { ENTERPRISE | BUSINESS_CRITICAL }
    [ REGION_GROUP = <region_group_id> ]
    [ REGION = <snowflake_region_id> ]
    [ COMMENT = '<string_literal>' ]

-- Example 18883
CREATE ORGANIZATION ACCOUNT myorgaccount
  ADMIN_NAME = admin
  ADMIN_PASSWORD = 'TestPassword1'
  EMAIL = 'myemail@myorg.org'
  MUST_CHANGE_PASSWORD = true
  EDITION = enterprise;

-- Example 18884
CREATE [ OR REPLACE ] PACKAGES POLICY [ IF NOT EXISTS ] <name>
  LANGUAGE PYTHON
  [ ALLOWLIST = ( [ '<packageSpec>' ] [ , '<packageSpec>' ... ] ) ]
  [ BLOCKLIST = ( [ '<packageSpec>' ] [ , '<packageSpec>' ... ] ) ]
  [ ADDITIONAL_CREATION_BLOCKLIST = ( [ '<packageSpec>' ] [ , '<packageSpec>' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18885
CREATE PACKAGES POLICY yourdb.yourschema.packages_policy_prod_1
  LANGUAGE PYTHON
  ALLOWLIST = ('numpy', 'pandas==1.2.3', ...)
  BLOCKLIST = ('numpy==1.2.3', 'bad_package', ...)
  COMMENT = 'Packages policy for the prod_1 environment';

-- Example 18886
CREATE [ OR REPLACE ] PASSWORD POLICY [ IF NOT EXISTS ] <name>
  [ PASSWORD_MIN_LENGTH = <integer> ]
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

-- Example 18887
CREATE PASSWORD POLICY PASSWORD_POLICY_PROD_1
    PASSWORD_MIN_LENGTH = 14
    PASSWORD_MAX_LENGTH = 24
    PASSWORD_MIN_UPPER_CASE_CHARS = 2
    PASSWORD_MIN_LOWER_CASE_CHARS = 2
    PASSWORD_MIN_NUMERIC_CHARS = 2
    PASSWORD_MIN_SPECIAL_CHARS = 2
    PASSWORD_MIN_AGE_DAYS = 1
    PASSWORD_MAX_AGE_DAYS = 30
    PASSWORD_MAX_RETRIES = 3
    PASSWORD_LOCKOUT_TIME_MINS = 30
    PASSWORD_HISTORY = 5
    COMMENT = 'production account password policy';

-- Example 18888
CREATE [ OR REPLACE ] PRIVACY POLICY [ IF NOT EXISTS ] <name>
  AS () RETURNS PRIVACY_BUDGET -> <body>
  [ COMMENT = '<string_literal>' ]

-- Example 18889
PRIVACY_BUDGET(
  BUDGET_NAME=> '<string>'
  [, BUDGET_LIMIT=> <decimal> ]
  [, MAX_BUDGET_PER_AGGREGATE=> <decimal> ]
  [, BUDGET_WINDOW=> <string> ]
)

-- Example 18890
CREATE PRIVACY POLICY my_priv_policy
  AS ( ) RETURNS PRIVACY_BUDGET ->
  PRIVACY_BUDGET(BUDGET_NAME=> 'analysts');

-- Example 18891
CREATE PRIVACY POLICY my_priv_policy
  AS () RETURNS PRIVACY_BUDGET ->
    CASE
      WHEN CURRENT_USER() = 'ADMIN'
        THEN NO_PRIVACY_POLICY()
      ELSE PRIVACY_BUDGET(BUDGET_NAME => 'analysts')
    END;

-- Example 18892
CREATE [ OR REPLACE ] RESOURCE MONITOR [ IF NOT EXISTS ] <name> WITH
                      [ CREDIT_QUOTA = <number> ]
                      [ FREQUENCY = { MONTHLY | DAILY | WEEKLY | YEARLY | NEVER } ]
                      [ START_TIMESTAMP = { <timestamp> | IMMEDIATELY } ]
                      [ END_TIMESTAMP = <timestamp> ]
                      [ NOTIFY_USERS = ( <user_name> [ , <user_name> , ... ] ) ]
                      [ TRIGGERS triggerDefinition [ triggerDefinition ... ] ]

-- Example 18893
triggerDefinition ::=
    ON <threshold> PERCENT DO { SUSPEND | SUSPEND_IMMEDIATE | NOTIFY }

-- Example 18894
CREATE OR REPLACE RESOURCE MONITOR limiter
  WITH CREDIT_QUOTA = 5000
  TRIGGERS ON 75 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND
           ON 110 PERCENT DO SUSPEND_IMMEDIATE;

-- Example 18895
CREATE OR REPLACE RESOURCE MONITOR limiter
  WITH CREDIT_QUOTA = 5000
       NOTIFY_USERS = (JDOE, "Jane Smith", "John Doe")
  TRIGGERS ON 75 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND
           ON 110 PERCENT DO SUSPEND_IMMEDIATE;

-- Example 18896
CREATE [ OR REPLACE ] ROLE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 18897
CREATE OR ALTER ROLE <name>
  [ COMMENT = '<string_literal>' ]

-- Example 18898
CREATE ROLE myrole;

-- Example 18899
CREATE [ OR REPLACE ] SECURITY INTEGRATION [ IF NOT EXISTS ]
  <name>
  TYPE = { API_AUTHENTICATION | EXTERNAL_OAUTH | OAUTH | SAML2 | SCIM }
  ...

-- Example 18900
CREATE SECURITY INTEGRATION <name>
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  ENABLED = { TRUE | FALSE }
  [ OAUTH_TOKEN_ENDPOINT = '<string_literal>' ]
  [ OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST ]
  [ OAUTH_CLIENT_ID = '<string_literal>' ]
  [ OAUTH_CLIENT_SECRET = '<string_literal>' ]
  [ OAUTH_GRANT = 'CLIENT_CREDENTIALS']
  [ OAUTH_ACCESS_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_ALLOWED_SCOPES = ( '<scope_1>' [ , '<scope_2>' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18901
CREATE SECURITY INTEGRATION <name>
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  ENABLED = { TRUE | FALSE }
  [ OAUTH_AUTHORIZATION_ENDPOINT = '<string_literal>' ]
  [ OAUTH_TOKEN_ENDPOINT = '<string_literal>' ]
  [ OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST ]
  [ OAUTH_CLIENT_ID = '<string_literal>' ]
  [ OAUTH_CLIENT_SECRET = '<string_literal>' ]
  [ OAUTH_GRANT = 'AUTHORIZATION_CODE']
  [ OAUTH_ACCESS_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18902
CREATE SECURITY INTEGRATION <name>
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  ENABLED = { TRUE | FALSE }
  [ OAUTH_AUTHORIZATION_ENDPOINT = '<string_literal>' ]
  [ OAUTH_TOKEN_ENDPOINT = '<string_literal>' ]
  [ OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST ]
  [ OAUTH_CLIENT_ID = '<string_literal>' ]
  [ OAUTH_CLIENT_SECRET = '<string_literal>' ]
  [ OAUTH_GRANT = 'JWT_BEARER']
  [ OAUTH_ACCESS_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18903
https://<instance_name>.service-now.com/oauth_token

-- Example 18904
CREATE SECURITY INTEGRATION servicenow_oauth
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST
  OAUTH_CLIENT_ID = 'sn-oauth-134o9erqfedlc'
  OAUTH_CLIENT_SECRET = 'eb9vaXsrcEvrFdfcvCaoijhilj4fc'
  OAUTH_TOKEN_ENDPOINT = 'https://myinstance.service-now.com/oauth_token.do'
  ENABLED = TRUE;

-- Example 18905
CREATE SECURITY INTEGRATION sharepoint_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST
  OAUTH_CLIENT_ID = 'YOUR_CLIENT_ID'
  OAUTH_CLIENT_SECRET = 'YOUR_CLIENT_SECRET'
  OAUTH_GRANT = 'CLIENT_CREDENTIALS'
  OAUTH_TOKEN_ENDPOINT = 'https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/v2.0/token'
  OAUTH_ALLOWED_SCOPES = ('https://graph.microsoft.com/.default')
  ENABLED = TRUE;

-- Example 18906
CREATE SECURITY INTEGRATION <name>
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  AWS_ROLE_ARN = '<iam_role_arn>'
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]

-- Example 18907
CREATE SECURITY INTEGRATION aws_iam
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  ENABLED = true;

-- Example 18908
CREATE [ OR REPLACE ] SECURITY INTEGRATION [IF NOT EXISTS]
  <name>
  TYPE = EXTERNAL_OAUTH
  ENABLED = { TRUE | FALSE }
  EXTERNAL_OAUTH_TYPE = { OKTA | AZURE | PING_FEDERATE | CUSTOM }
  EXTERNAL_OAUTH_ISSUER = '<string_literal>'
  EXTERNAL_OAUTH_TOKEN_USER_MAPPING_CLAIM = { '<string_literal>' | ('<string_literal>' [ , '<string_literal>' , ... ] ) }
  EXTERNAL_OAUTH_SNOWFLAKE_USER_MAPPING_ATTRIBUTE = { 'LOGIN_NAME' | 'EMAIL_ADDRESS' }
  [ EXTERNAL_OAUTH_JWS_KEYS_URL = { '<string_literal>' | ('<string_literal>' [ , '<string_literal>' , ... ] ) } ]
  [ EXTERNAL_OAUTH_BLOCKED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ EXTERNAL_OAUTH_ALLOWED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ EXTERNAL_OAUTH_RSA_PUBLIC_KEY = <public_key1> ]
  [ EXTERNAL_OAUTH_RSA_PUBLIC_KEY_2 = <public_key2> ]
  [ EXTERNAL_OAUTH_AUDIENCE_LIST = { '<string_literal>' | ('<string_literal>' [ , '<string_literal>' , ... ] ) } ]
  [ EXTERNAL_OAUTH_ANY_ROLE_MODE = { DISABLE | ENABLE | ENABLE_FOR_PRIVILEGE } ]
  [ EXTERNAL_OAUTH_SCOPE_DELIMITER = '<string_literal>' ]
  [ EXTERNAL_OAUTH_SCOPE_MAPPING_ATTRIBUTE = '<string_literal>' ]
  [ COMMENT = '<string_literal>' ]

-- Example 18909
EXTERNAL_OAUTH_JWS_KEYS_URL = ('https://example.ca', 'https://example.co.uk')

-- Example 18910
EXTERNAL_OAUTH_JWS_KEYS_URL = 'https://example.ca'

-- Example 18911
EXTERNAL_OAUTH_AUDIENCE_LIST = ('https://example.com/api/v2/', 'https://example.com')

-- Example 18912
GRANT USE_ANY_ROLE ON INTEGRATION external_oauth_1 TO role1;

-- Example 18913
REVOKE USE_ANY_ROLE ON INTEGRATION external_oauth_1 FROM role1;

-- Example 18914
CREATE SECURITY INTEGRATION external_oauth_azure_1
    TYPE = external_oauth
    ENABLED = true
    EXTERNAL_OAUTH_TYPE = azure
    EXTERNAL_OAUTH_ISSUER = '<AZURE_AD_ISSUER>'
    EXTERNAL_OAUTH_JWS_KEYS_URL = '<AZURE_AD_JWS_KEY_ENDPOINT>'
    EXTERNAL_OAUTH_TOKEN_USER_MAPPING_CLAIM = 'upn'
    EXTERNAL_OAUTH_SNOWFLAKE_USER_MAPPING_ATTRIBUTE = 'login_name';

-- Example 18915
DESC SECURITY INTEGRATION external_oauth_azure_1;

-- Example 18916
CREATE SECURITY INTEGRATION external_oauth_okta_1
    TYPE = external_oauth
    ENABLED = true
    EXTERNAL_OAUTH_TYPE = okta
    EXTERNAL_OAUTH_ISSUER = '<OKTA_ISSUER>'
    EXTERNAL_OAUTH_JWS_KEYS_URL = '<OKTA_JWS_KEY_ENDPOINT>'
    EXTERNAL_OAUTH_TOKEN_USER_MAPPING_CLAIM = 'sub'
    EXTERNAL_OAUTH_SNOWFLAKE_USER_MAPPING_ATTRIBUTE = 'login_name';

-- Example 18917
DESC SECURITY INTEGRATION external_oauth_okta_1;

-- Example 18918
CREATE [ OR REPLACE ] SECURITY INTEGRATION [IF NOT EXISTS]
  <name>
  TYPE = OAUTH
  OAUTH_CLIENT = <partner_application>
  OAUTH_REDIRECT_URI = '<uri>'  -- Required when OAUTH_CLIENT=LOOKER
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_ISSUE_REFRESH_TOKENS = TRUE | FALSE ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_USE_SECONDARY_ROLES = IMPLICIT | NONE ]
  [ BLOCKED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18919
CREATE [ OR REPLACE ] SECURITY INTEGRATION [IF NOT EXISTS]
  <name>
  TYPE = OAUTH
  OAUTH_CLIENT = CUSTOM
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL' | 'PUBLIC'
  OAUTH_REDIRECT_URI = '<uri>'
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_ALLOW_NON_TLS_REDIRECT_URI = TRUE | FALSE ]
  [ OAUTH_ENFORCE_PKCE = TRUE | FALSE ]
  [ OAUTH_USE_SECONDARY_ROLES = IMPLICIT | NONE ]
  [ PRE_AUTHORIZED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ BLOCKED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ OAUTH_ISSUE_REFRESH_TOKENS = TRUE | FALSE ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ NETWORK_POLICY = '<network_policy>' ]
  [ OAUTH_CLIENT_RSA_PUBLIC_KEY = <public_key1> ]
  [ OAUTH_CLIENT_RSA_PUBLIC_KEY_2 = <public_key2> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18920
CREATE SECURITY INTEGRATION td_oauth_int1
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = tableau_desktop;

-- Example 18921
DESC SECURITY INTEGRATION td_oauth_int1;

-- Example 18922
CREATE SECURITY INTEGRATION td_oauth_int2
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = tableau_desktop
  OAUTH_REFRESH_TOKEN_VALIDITY = 36000
  BLOCKED_ROLES_LIST = ('SYSADMIN');

-- Example 18923
CREATE SECURITY INTEGRATION ts_oauth_int1
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = tableau_server;

-- Example 18924
DESC SECURITY INTEGRATION ts_oauth_int1;

-- Example 18925
CREATE SECURITY INTEGRATION ts_oauth_int2
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = tableau_server
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400
  BLOCKED_ROLES_LIST = ('SYSADMIN');

-- Example 18926
CREATE SECURITY INTEGRATION oauth_kp_int
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = custom
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'
  OAUTH_REDIRECT_URI = 'https://localhost.com'
  OAUTH_ISSUE_REFRESH_TOKENS = TRUE
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400
  PRE_AUTHORIZED_ROLES_LIST = ('MYROLE')
  BLOCKED_ROLES_LIST = ('SYSADMIN');

-- Example 18927
CREATE [ OR REPLACE ] SECURITY INTEGRATION [ IF NOT EXISTS ]
    <name>
    TYPE = SCIM
    ENABLED = { TRUE | FALSE }
    SCIM_CLIENT = { 'OKTA' | 'AZURE' | 'GENERIC' }
    RUN_AS_ROLE = { 'OKTA_PROVISIONER' | 'AAD_PROVISIONER' | 'GENERIC_SCIM_PROVISIONER' }
    [ NETWORK_POLICY = '<network_policy>' ]
    [ SYNC_PASSWORD = { TRUE | FALSE } ]
    [ COMMENT = '<string_literal>' ]

-- Example 18928
CREATE OR REPLACE SECURITY INTEGRATION okta_provisioning
    TYPE = scim
    SCIM_CLIENT = 'AZURE'
    RUN_AS_ROLE = 'AAD_PROVISIONER';

-- Example 18929
DESC SECURITY INTEGRATION aad_provisioning;

-- Example 18930
CREATE OR REPLACE SECURITY INTEGRATION okta_provisioning
    TYPE = scim
    SCIM_CLIENT = 'OKTA'
    RUN_AS_ROLE = 'OKTA_PROVISIONER';

-- Example 18931
DESC SECURITY INTEGRATION okta_provisioning;

-- Example 18932
CREATE [ OR REPLACE ] SEMANTIC VIEW [ IF NOT EXISTS ] <name>
  TABLES ( logicalTable [ , ... ] )
  [ RELATIONSHIPS ( relationshipDef [ , ... ] ) ]
  [ FACTS ( semanticExpression [ , ... ] ) ]
  [ DIMENSIONS ( semanticExpression [ , ... ] ) ]
  [ METRICS ( semanticExpression [ , ... ] ) ]
  [ COMMENT = '<comment_about_semantic_view>' ]

-- Example 18933
logicalTable ::=
  [ <table_alias> AS ] <table_name>
  [ PRIMARY KEY ( <primary_key_column_name> [ , ... ] ) ]
  [ WITH SYNONYMS [ = ] ( '<synonym>' [ , ... ] ) ]
  [ COMMENT = '<comment_about_table>' ]

-- Example 18934
relationshipDef ::=
  [ <relationship_identifier> AS ]
  <table_alias> ( <column_name> [ , ... ] )
  REFERENCES
  <ref_table_alias> [ ( <ref_column_name> [ , ... ] ) ]

-- Example 18935
semanticExpression ::=
  <table_alias>.<dim_fact_or_metric> AS <sql_expr>
  [ WITH SYNONYMS [ = ] ( '<synonym>' [ , ... ] ) ]
  [ COMMENT = '<comment_about_dim_fact_or_metric>' ]

-- Example 18936
CREATE [ OR REPLACE ] SEQUENCE [ IF NOT EXISTS ] <name>
  [ WITH ]
  [ START [ WITH ] [ = ] <initial_value> ]
  [ INCREMENT [ BY ] [ = ] <sequence_interval> ]
  [ { ORDER | NOORDER } ]
  [ COMMENT = '<string_literal>' ]

-- Example 18937
CREATE OR REPLACE SEQUENCE seq_01 START = 1 INCREMENT = 1;
CREATE OR REPLACE TABLE sequence_test_table (i INTEGER);

-- Example 18938
SELECT seq_01.nextval;
+---------+
| NEXTVAL |
|---------|
|       1 |
+---------+

