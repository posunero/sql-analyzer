-- Example 24162
const connection = snowflake.createConnection({
    account: process.env.SNOWFLAKE_TEST_ACCOUNT,
    username: process.env.SNOWFLAKE_TEST_USER,
    ...
    authenticator: 'USERNAME_PASSWORD_MFA',
    password: "abc123987654", // passcode 987654 is part of the password
    passcodeInPassword: true  // because passcodeInPassword is true
});

-- Example 24163
const connection = snowflake.createConnection({
    account: process.env.SNOWFLAKE_TEST_ACCOUNT,
    username: process.env.SNOWFLAKE_TEST_USER,
    ...
    authenticator: 'USERNAME_PASSWORD_MFA',
    password: "abc123", // password and MFA passcode are input separately
    passcode: "987654"
});

-- Example 24164
ALTER ACCOUNT SET ALLOW_ID_TOKEN = TRUE;

-- Example 24165
const connection = snowflake.createConnection({
  account: process.env.SNOWFLAKE_TEST_ACCOUNT,
  username: process.env.SNOWFLAKE_TEST_USER,
  database: process.env.SNOWFLAKE_TEST_DATABASE,
  schema: process.env.SNOWFLAKE_TEST_SCHEMA,
  warehouse: process.env.SNOWFLAKE_TEST_WAREHOUSE,
  authenticator: 'EXTERNALBROWSER',
  clientStoreTemporaryCredential: true,
});

-- Example 24166
ALTER ACCOUNT SET ALLOW_CLIENT_MFA_CACHING = TRUE;

-- Example 24167
const connection = snowflake.createConnection({
  account: process.env.SNOWFLAKE_TEST_ACCOUNT,
  username: process.env.SNOWFLAKE_TEST_USER,
  database: process.env.SNOWFLAKE_TEST_DATABASE,
  schema: process.env.SNOWFLAKE_TEST_SCHEMA,
  warehouse: process.env.SNOWFLAKE_TEST_WAREHOUSE,
  authenticator: 'USERNAME_PASSWORD_MFA',
  clientRequestMFAToken: true,
});

-- Example 24168
const connection = snowflake.createConnection({
          credentialCacheDir: "../../<folder name>",
});

-- Example 24169
const connection = snowflake.createConnection({
          credentialCacheDir: "C:\\<folder name>\\<subfolder name>",
});

-- Example 24170
const sampleCustomManager = {
  read: function (key) {
  //(do something with the key)
    return token;
  },
  write: function (key, token) {
  //(do something with the key and token)
  },
  remove: function (key) {
    //(do something with the key)
  }
};

-- Example 24171
const myCredentialManager = require('<your custom credential manager module>')
const snowflake = require('snowflake-sdk');

snowflake.configure({
  customCredentialManager: myCredentialManager
})

const connection = snowflake.createConnection({
  account: process.env.SNOWFLAKE_TEST_ACCOUNT,
  database: process.env.SNOWFLAKE_TEST_DATABASE,
  schema: process.env.SNOWFLAKE_TEST_SCHEMA,
  warehouse: process.env.SNOWFLAKE_TEST_WAREHOUSE,
  authenticator: 'USERNAME_PASSWORD_MFA',
  clientRequestMFAToken: true,
});

-- Example 24172
POLICY_REFERENCES( POLICY_NAME => '<password_policy_name>' )

-- Example 24173
SELECT *
FROM TABLE(
    my_db.information_schema.policy_references(
      POLICY_NAME => 'my_db.my_schema.password_policy_prod_1'
  )
);

-- Example 24174
USE ROLE USERADMIN;

CREATE ROLE policy_admin;

-- Example 24175
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE security TO ROLE policy_admin;

GRANT USAGE ON SCHEMA security.policies TO ROLE policy_admin;

GRANT CREATE PASSWORD POLICY ON SCHEMA security.policies TO ROLE policy_admin;

GRANT APPLY PASSWORD POLICY ON ACCOUNT TO ROLE policy_admin;

-- Example 24176
GRANT APPLY PASSWORD POLICY ON USER jsmith TO ROLE policy_admin;

-- Example 24177
USE ROLE SECURITYADMIN;
GRANT ROLE policy_admin TO USER jsmith;

-- Example 24178
USE ROLE policy_admin;

USE SCHEMA security.policies;

CREATE PASSWORD POLICY PASSWORD_POLICY_PROD_1
    PASSWORD_MIN_LENGTH = 14
    PASSWORD_MAX_LENGTH = 24
    PASSWORD_MIN_UPPER_CASE_CHARS = 2
    PASSWORD_MIN_LOWER_CASE_CHARS = 2
    PASSWORD_MIN_NUMERIC_CHARS = 2
    PASSWORD_MIN_SPECIAL_CHARS = 2
    PASSWORD_MIN_AGE_DAYS = 1
    PASSWORD_MAX_AGE_DAYS = 999
    PASSWORD_MAX_RETRIES = 3
    PASSWORD_LOCKOUT_TIME_MINS = 30
    PASSWORD_HISTORY = 5
    COMMENT = 'production account password policy';

-- Example 24179
ALTER ACCOUNT SET PASSWORD POLICY security.policies.password_policy_prod_1;

-- Example 24180
ALTER USER jsmith SET PASSWORD POLICY security.policies.password_policy_user;

-- Example 24181
ALTER ACCOUNT UNSET PASSWORD POLICY;

ALTER ACCOUNT SET PASSWORD POLICY security.policies.password_policy_prod_2;

-- Example 24182
ALTER USER JSMITH SET MUST_CHANGE_PASSWORD = true;

-- Example 24183
ALTER USER janesmith SET PASSWORD = 'H8MZRqa8gEe/kvHzvJ+Giq94DuCYoQXmfbb$Xnt' MUST_CHANGE_PASSWORD = TRUE;

-- Example 24184
ALTER USER janesmith RESET PASSWORD;

-- Example 24185
CREATE AUTHENTICATION POLICY require_mfa_policy
  MFA_AUTHENTICATION_METHODS = ('PASSWORD')
  MFA_ENROLLMENT = REQUIRED;

-- Example 24186
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET AUTHENTICATION POLICY require_mfa_policy;

-- Example 24187
SELECT DISTINCT
  f.value:entity_id::VARCHAR AS entity_id,
  f.value:entity_name::VARCHAR AS entity_name,
  f.value:entity_detail:user_type::VARCHAR as user_type,
  f.value:entity_detail:has_password::VARCHAR as has_password,
  f.value:entity_detail:has_rsa_public_key::VARCHAR as has_rsa_public_key,
  f.value:entity_detail:mfa_enabled::VARCHAR as mfa_enabled,
  f.value:entity_detail:account_auth_policy_name::VARCHAR as Account_level_Auth_policy,
  f.value:entity_detail:account_auth_policy_requires_mfa::VARCHAR as Account_level_EnforceMFA_policy,
  f.value:entity_detail:user_auth_policy_name::VARCHAR as User_level_Auth_policy,
  f.value:entity_detail:user_auth_policy_requires_mfa::VARCHAR as User_level_EnforceMFA_policy,
  f.value:entity_detail:account_network_policy_name::VARCHAR as Account_level_Net_policy_Name,
  f.value:entity_detail:account_network_policy_Allowlist::VARCHAR as Account_level_Net_policy_Allowlist,
  f.value:entity_detail:user_network_policy_name::VARCHAR as User_level_Net_policy_Name,
  f.value:entity_detail:user_network_policy_allowlist::VARCHAR as User_level_Net_policy_Allowlist,
FROM SNOWFLAKE.TRUST_CENTER.FINDINGS,
  LATERAL FLATTEN(input => at_risk_entities) AS f
WHERE EVENT_ID =
  (SELECT event_id FROM snowflake.trust_center.findings WHERE SCANNER_PACKAGE_NAME = 'Threat Intelligence'
   ORDER BY event_id DESC LIMIT 1);

-- Example 24188
SELECT *
  FROM SNOWFLAKE.TRUST_CENTER.FINDINGS
  WHERE event_id =
    (SELECT event_id FROM SNOWFLAKE.TRUST_CENTER.FINDINGS
    WHERE scanner_id = 'THREAT_INTELLIGENCE_NON_MFA_PERSON_USERS'
    ORDER BY event_id DESC LIMIT 1) AND total_at_risk_count != 0
;

-- Example 24189
SELECT *
  FROM SNOWFLAKE.TRUST_CENTER.FINDINGS
  WHERE event_id =
    (SELECT event_id FROM SNOWFLAKE.TRUST_CENTER.FINDINGS
    WHERE scanner_id = 'THREAT_INTELLIGENCE_PASSWORD_SERVICE_USERS'
    ORDER BY event_id DESC LIMIT 1 ) and total_at_risk_count != 0
;

-- Example 24190
WITH users AS (
  SELECT DISTINCT
       user_id
      , name
      , login_name
      , type
      , email
  FROM
      SNOWFLAKE.ACCOUNT_USAGE.USERS
  WHERE
      DELETED_ON IS NULL)
SELECT
    u.user_id
    , a.event_timestamp
    , a.user_name
    , u.type
    , a.reported_client_type
    , a.first_authentication_factor
    , a.second_authentication_factor
  FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY AS a
    JOIN USERS u ON a.user_name = u.name
;

-- Example 24191
ALTER USER svc_user1 SET TYPE = SERVICE;
ALTER USER user1@example.COM SET TYPE = PERSON;
-- LEGACY APPLICATION ONLY

-- Example 24192
CREATE ACCOUNT <name> [ ADMIN_USER_TYPE = PERSON | SERVICE | LEGACY_SERVICE | NULL ];

-- Example 24193
CREATE AUTHENTICATION POLICY PROGRAMMATIC_ACCESS_USER_AUTH
  CLIENT_TYPES = ('DRIVERS', 'SNOWSQL')
  AUTHENTICATION_METHODS = ('OAUTH')
  SECURITY_INTEGRATIONS = ('<OAUTH SECURITY INTEGRATIONS>');

ALTER USER <SERVICE_USER> SET AUTHENTICATION POLICY PROGRAMMATIC_ACCESS_USER_AUTH;

-- Example 24194
CREATE AUTHENTICATION POLICY HUMAN_ACCESS_ACCOUNT_ENFORCE_MFA
  AUTHENTICATION_METHODS = ('SAML', 'PASSWORD')
  SECURITY_INTEGRATIONS = ('<SAML SECURITY INTEGRATIONS>')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD'); -- enforce Snowflake MFA for native passwords only
  MFA_ENROLLMENT = 'REQUIRED';

-- Example 24195
CREATE AUTHENTICATION POLICY ACCOUNTADMIN_BREAKGLASS_MFA
  AUTHENTICATION_METHODS = ('PASSWORD')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD') -- enforce Snowflake MFA for native passwords only
  MFA_ENROLLMENT = 'REQUIRED';

-- Example 24196
CREATE AUTHENTICATION POLICY ACCOUNTADMIN_DOUBLE_MFA
  AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  SECURITY_INTEGRATIONS = ('<SAML SECURITY INTEGRATIONS>')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML') -- double MFA
  MFA_ENROLLMENT = 'REQUIRED';

-- Example 24197
CREATE PASSWORD POLICY password_policy_account
  PASSWORD_MIN_LENGTH = 32
  -- PASSWORD_MAX_LENGTH = <integer>
  PASSWORD_MIN_UPPER_CASE_CHARS = 6
  PASSWORD_MIN_LOWER_CASE_CHARS = 6
  PASSWORD_MIN_NUMERIC_CHARS = 4
  PASSWORD_MIN_SPECIAL_CHARS = 8
  PASSWORD_MIN_AGE_DAYS = 10
  PASSWORD_MAX_AGE_DAYS = 30
  PASSWORD_MAX_RETRIES = 3
  PASSWORD_LOCKOUT_TIME_MINS = 30
  PASSWORD_HISTORY = 24
  COMMENT = '<string_literal>';

-- Example 24198
CREATE SESSION POLICY session_policy_account
  SESSION_IDLE_TIMEOUT_MINS = 240 -- Snowflake clients and programmatic clients
  SESSION_UI_IDLE_TIMEOUT_MINS = 20 -- For the Snowflake web interface
  COMMENT = '<string_literal>';

-- Example 24199
-- ACCESS FROM PUBLIC IP ADDRESSES
CREATE NETWORK RULE PROGRAMMATIC_ACCESS_USER_NET_RULE_PUBLIC
  TYPE = IPV4
  VALUE_LIST = ( 'PUBLIC IP1' , 'XX.XX.XX.XX/24' [ , ... ] )
  MODE =  INGRESS
;
-- ACCESS FROM PRIVATE NETWORK
CREATE NETWORK RULE PROGRAMMATIC_ACCESS_USER_NET_RULE_PL
  TYPE = AWSVPCEID
  VALUE_LIST = ( 'VPCE-123ABC3420C1931' , 'VPCE-123ABC3420C1932' )
  MODE =  INGRESS
;
-- RESTRICT ACCESS TO INTERNAL STAGE USING VPCE ID
CREATE NETWORK RULE PROGRAMMATIC_ACCESS_USER_NET_RULE_INTERNAL_STAGE
  TYPE = AWSVPCEID
  VALUE_LIST = ( 'VPCE-123ABC3420C1933' )
  MODE =  INTERNAL_STAGE
;
CREATE NETWORK POLICY PROGRAMMATIC_ACCESS_USER_NET_POLICY
  ALLOWED_NETWORK_RULE_LIST =
    (
     'PROGRAMMATIC_ACCESS_USER_NET_RULE_PUBLIC',
     'PROGRAMMATIC_ACCESS_USER_NET_RULE_PL',
     'PROGRAMMATIC_ACCESS_USER_NET_RULE_INTERNAL_STAGE'
    )
  --BLOCKED_NETWORK_RULE_LIST = ( 'OPTIONAL BLOCKED LIST OF IPS' )
;

-- Example 24200
-- ACCESS FROM PUBLIC IP ADDRESSES
CREATE NETWORK RULE HUMAN_ACCESS_ACCOUNT_NET_RULE_PUBLIC
  TYPE = IPV4
  VALUE_LIST = ( 'PUBLIC IP1' , 'XX.XX.XX.XX/24' [ , ... ] )
  MODE =  INGRESS
;
-- ACCESS FROM PRIVATE NETWORK
CREATE NETWORK RULE HUMAN_ACCESS_ACCOUNT_NET_RULE_PL
  TYPE = AWSVPCEID
  VALUE_LIST = ( 'VPCE-123ABC3420C1934' , 'VPCE-123ABC3420C1936' )
  MODE =  INGRESS
;
-- RESTRICT ACCESS TO INTERNAL STAGE USING VPCE ID
CREATE NETWORK RULE HUMAN_ACCESS_ACCOUNT_NET_RULE_INTERNAL_STAGE
  TYPE = AWSVPCEID
  VALUE_LIST = ( 'VPCE-123ABC3420C1937')
  MODE =  INTERNAL_STAGE
;
CREATE NETWORK POLICY ACCOUNT_LEVEL_NET_POLICY
  ALLOWED_NETWORK_RULE_LIST =
   (
    'HUMAN_ACCESS_ACCOUNT_NET_RULE_PUBLIC',
    'HUMAN_ACCESS_ACCOUNT_NET_RULE_PL',
    'HUMAN_ACCESS_ACCOUNT_NET_RULE_INTERNAL_STAGE'
   )
   --BLOCKED_NETWORK_RULE_LIST = ( 'OPTIONAL BLOCKED LIST OF IPS' )
;

-- Example 24201
-- FOR EVERY SERVICE PROGRAMMATIC ACCESS USER
ALTER USER SERVICE_USER_1 SET
TYPE = SERVICE
NETWORK_POLICY = PROGRAMMATIC_ACCESS_USER_NET_POLICY
AUTHENTICATION POLICY = PROGRAMMATIC_ACCESS_USER_AUTH;

-- Example 24202
ALTER ACCOUNT SET
SESSION POLICY = SESSION_POLICY_ACCOUNT;
PASSWORD POLICY = PASSWORD_POLICY_ACCOUNT;

-- Example 24203
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.LOGIN_HISTORY(TIME_RANGE_START =>
    DATEADD('HOURS',-1,CURRENT_TIMESTAMP()),CURRENT_TIMESTAMP()))
  ORDER BY EVENT_TIMESTAMP;

-- Example 24204
ALTER ACCOUNT SET
AUTHENTICATION POLICY = HUMAN_ACCESS_ACCOUNT_ENFORCE_MFA;

-- Example 24205
ALTER USER SUPER_PROTECTED_ACCOUNTADMIN_1
AUTHENTICATION POLICY = ACCOUNTADMIN_DOUBLE_MFA;

-- Example 24206
ALTER USER BREAKGLASS_ACCOUNTADMIN_1
AUTHENTICATION POLICY = ACCOUNTADMIN_BREAKGLASS_MFA;

-- Example 24207
ALTER ACCOUNT SET
NETWORK_POLICY = ACCOUNT_LEVEL_NET_POLICY;

-- Example 24208
SELECT
  F.VALUE:ENTITY_ID::VARCHAR AS ENTITY_ID,
  F.VALUE:ENTITY_NAME::VARCHAR AS ENTITY_NAME,
  F.VALUE:ENTITY_OBJECT_TYPE::VARCHAR AS ENTITY_OBJECT_TYPE,
  F.VALUE:ENTITY_DETAIL AS ENTITY_DETAIL
FROM
  SNOWFLAKE.TRUST_CENTER.FINDINGS,
  LATERAL FLATTEN(INPUT => AT_RISK_ENTITIES) AS F;

-- Example 24209
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE DATABASE my_database;
USE DATABASE my_database;

CREATE OR REPLACE SCHEMA my_schema;
USE SCHEMA my_schema;

CREATE ROLE policy_admin;

GRANT USAGE ON DATABASE my_database TO ROLE policy_admin;
GRANT USAGE ON SCHEMA my_database.my_schema TO ROLE policy_admin;
GRANT CREATE AUTHENTICATION POLICY ON SCHEMA my_database.my_schema TO ROLE policy_admin;
GRANT APPLY AUTHENTICATION POLICY ON ACCOUNT TO ROLE policy_admin;

USE ROLE policy_admin;

CREATE AUTHENTICATION POLICY my_example_authentication_policy
  CLIENT_TYPES = ('SNOWFLAKE_UI')
  AUTHENTICATION_METHODS = ('OAUTH', 'PASSWORD');

-- Example 24210
ALTER ACCOUNT SET AUTHENTICATION POLICY my_example_authentication_policy;

-- Example 24211
ALTER USER example_user SET AUTHENTICATION POLICY my_example_authentication_policy;

-- Example 24212
GRANT APPLY AUTHENTICATION POLICY ON ACCOUNT TO ROLE my_policy_admin

-- Example 24213
GRANT APPLY AUTHENTICATION POLICY ON USER example_user TO ROLE my_policy_admin

-- Example 24214
CREATE AUTHENTICATION POLICY require_mfa_with_password_authentication_policy
  MFA_AUTHENTICATION_METHODS = ('PASSWORD')
  MFA_ENROLLMENT = REQUIRED;

-- Example 24215
ALTER ACCOUNT SET AUTHENTICATION POLICY require_mfa_with_password_authentication_policy;

-- Example 24216
CREATE AUTHENTICATION POLICY require_mfa_authentication_policy
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  MFA_ENROLLMENT = REQUIRED;

-- Example 24217
ALTER ACCOUNT SET AUTHENTICATION POLICY require_mfa_authentication_policy;

-- Example 24218
POLICY_REFERENCES( POLICY_NAME => '<authentication_policy_name>' )

-- Example 24219
POLICY_REFERENCES( REF_ENTITY_DOMAIN => 'USER', REF_ENTITY_NAME => '<username>')

-- Example 24220
POLICY_REFERENCES( REF_ENTITY_DOMAIN => 'ACCOUNT', REF_ENTITY_NAME => '<accountname>')

-- Example 24221
SELECT *
FROM TABLE(
    my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
      POLICY_NAME => 'my_db.my_schema.authentication_policy_prod_1'
  )
);

-- Example 24222
CREATE AUTHENTICATION POLICY admin_authentication_policy
  AUTHENTICATION_METHODS = ('SAML', 'PASSWORD')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  SECURITY_INTEGRATIONS = ('EXAMPLE_OKTA_INTEGRATION');

-- Example 24223
ALTER USER <administrator_name> SET AUTHENTICATION POLICY admin_authentication_policy

-- Example 24224
CREATE AUTHENTICATION POLICY restrict_client_type_policy
  CLIENT_TYPES = ('SNOWFLAKE_UI')
  COMMENT = 'Only allows access through the web interface';

-- Example 24225
ALTER USER example_user SET AUTHENTICATION POLICY restrict_client_type_policy;

-- Example 24226
CREATE SECURITY INTEGRATION example_okta_integration
  TYPE = SAML2
  SAML2_SSO_URL = 'https://okta.example.com';
  ...

-- Example 24227
CREATE SECURITY INTEGRATION example_entra_integration
  TYPE = SAML2
  SAML2_SSO_URL = 'https://entra-example_acme.com';
  ...

-- Example 24228
CREATE AUTHENTICATION POLICY multiple_idps_authentication_policy
  AUTHENTICATION_METHODS = ('SAML')
  SECURITY_INTEGRATIONS = ('EXAMPLE_OKTA_INTEGRATION', 'EXAMPLE_ENTRA_INTEGRATION');

