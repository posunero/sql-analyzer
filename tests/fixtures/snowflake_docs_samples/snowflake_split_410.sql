-- Example 27445
CREATE EXTERNAL LISTING my1stlisting
SHARE myshare AS
$$
 title: "My first SQL listing"
 description: "This is my first listing"
 listing_terms:
   type: "OFFLINE"
 targets:
   accounts: ["Org1.Account1"]
$$ PUBLISH=FALSE REVIEW=FALSE;

-- Example 27446
ALTER LISTING MY1STLISTING PUBLISH;

-- Example 27447
ALTER LISTING MY1STLISTING UNPUBLISH;

-- Example 27448
ALTER LISTING MY1STLISTING AS
$$
   title: "My First SQL Listing"
   description: "This is my first listing"
   listing_terms:
     type: "OFFLINE"
   targets:
     accounts: ["Org1.Account1"]
   usage_examples:
     - title: "this is a test sql"
       description: "Simple example"
       query: "select *"
$$;

-- Example 27449
SHOW LISTINGS LIKE 'MY1STLISTING';

-- Example 27450
SHOW LISTINGS;

-- Example 27451
DESC LISTING MY1STLISTING;

-- Example 27452
ALTER LISTING MY1STLISTING UNPUBLISH;

-- Example 27453
DROP LISTING IF EXISTS MY1STLISTING

-- Example 27454
GRANT MANAGE RELEASES ON APPLICATION PACKAGE hello_snowflake_package
  TO ROLE release_mgr;

-- Example 27455
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = v1_0
  PATCH = 2;

-- Example 27456
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET RELEASE DIRECTIVE hello_snowflake_package_custom
  ACCOUNTS = (CONSUMER_ORG.CONSUMER_ACCOUNT)
  VERSION = v1_0
  PATCH = 0;

-- Example 27457
ALTER APPLICATION PACKAGE hello_snowflake_package
  MODIFY RELEASE DIRECTIVE hello_snowflake_package_custom
  VERSION = v1_0
  PATCH = 0;

-- Example 27458
ALTER APPLICATION PACKAGE hello_snowflake_package
  UNSET RELEASE DIRECTIVE hello_snowflake_package_custom;

-- Example 27459
CREATE APPLICATION hello_snowflake
  FROM APPLICATION PACKAGE hello_snowflake_package

-- Example 27460
SHOW RELEASE DIRECTIVES IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 27461
@DEV_DB.DEV_SCHEMA.DEV_STAGE/V1:
└── app_files/
    └── dev
        ├── manifest.yml
        └── scripts/
            ├── setup_script.sql
            └── libraries/
                └── jars/
                    ├── lookup.jar
                    └── log4j.jar
            └── python
                └── evaluation.py

-- Example 27462
CREATE PROCEDURE PROGRAMS.LOOKUP(...)
  RETURNS STRING
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('/scripts/libraries/jar/lookup.jar',
             '/scripts/libraries/jar/log4j.jar')
  HANDLER = 'com.acme.programs.Lookup';

-- Example 27463
CREATE OR ALTER VERSIONED SCHEMA app_code;
CREATE STAGE app_code.app_jars;

CREATE FUNCTION app_code.add(x INT, y INT)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'TestAddFunc.add'
  TARGET_PATH = '@app_code.app_jars/TestAddFunc.jar'
  AS
  $$
  class TestAddFunc {
    public static int add(int x, int y) {
      Return x + y;
    }
  }
  $$;

-- Example 27464
@DEV_DB.DEV_SCHEMA.DEV_STAGE/V1:
└── V1/
    ├── manifest.yml
    ├── setup_script.sql
    └── JARs/
        ├── Java/
        │   └── TestAddFunc.jar
        └── Scala/
            └── TestMulFunc.jar

-- Example 27465
CREATE FUNCTION app_code.add(x INTEGER, y INTEGER)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'TestAddFunc.add'
  IMPORTS = ('/JARs/Java/TestAddFunc.jar');

-- Example 27466
CREATE FUNCTION app_code.py_echo_func(str STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  HANDLER = 'echo'
AS
$$
def echo(str):
  return "ECHO: " + str
$$;

-- Example 27467
CREATE FUNCTION PY_PROCESS_DATA_FUNC()
  RETURNS STRING
  LANGUAGE PYTHON
  HANDLER = 'TestPythonFunc.process'
  IMPORTS = ('/python_modules/TestPythonFunc.py',
    '/python_modules/data.csv')

-- Example 27468
CREATE OR REPLACE PROCEDURE APP_SCHEMA.ERROR_CATCH()
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS OWNER
  AS $$
    try {
      let x = y.length;
    }
    catch(err){
      return "There is an error.";
    }
    return "Done";
  $$;

-- Example 27469
CREATE OR REPLACE PROCEDURE calculator.create_external_function(integration_name STRING)
  RETURNS STRING
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  DECLARE
    CREATE_STATEMENT VARCHAR;
  BEGIN
    CREATE_STATEMENT := 'CREATE OR REPLACE EXTERNAL FUNCTION EXTERNAL_ADD(NUM1 FLOAT, NUM2 FLOAT)
        RETURNS FLOAT API_INTEGRATION = ? AS ''https://xyz.execute-api.us-west-2.amazonaws.com/production/sum'';' ;
    EXECUTE IMMEDIATE :CREATE_STATEMENT USING (INTEGRATION_NAME);
    RETURN 'EXTERNAL FUNCTION CREATED';
  END;

GRANT USAGE ON PROCEDURE calculator.create_external_function(string) TO APPLICATION ROLE app_public;

-- Example 27470
CREATE OR ALTER VERSIONED SCHEMA app_schema;
CREATE OR REPLACE PROCEDURE app_schema.sum(num1 float, num2 float)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
    BEGIN
      IF (SYSTEM$IS_APPLICATION_AUTHORIZED_FOR_TELEMETRY_EVENT_SHARING() and SYSTEM$IS_APPLICATION_ALL_MANDATORY_TELEMETRY_EVENT_DEFINITIONS_ENABLED()) THEN
        RETURN num1 + num2;
      ELSE
        -- notify consumers that they need to enable event sharing
        RETURN 'Sorry you can\'t access the API, please enable event sharing.';
      END IF;
    END;
$$;

-- Example 27471
import streamlit as st
import snowflake.permissions as permissions

def critical_feature_that_requires_event_sharing():
  st.write("critical_feature_that_requires_event_sharing")

def main():
  if permissions.is_application_authorized_for_telemetry_event_sharing() and permissions.is_application_all_mandatory_telemetry_event_definitions_enabled():
     critical_feature_that_requires_event_sharing()
  else:
     permissions.request_event_sharing()

if __name__ == "__main__":
  main()

-- Example 27472
SELECT SYSTEM$SET_EVENT_SHARING_ACCOUNT_FOR_REGION('<snowflake_region>', '<region_group>', '<account_name>')

-- Example 27473
CREATE EVENT TABLE event_db.event_schema.my_event_table;

-- Example 27474
ALTER ACCOUNT SET EVENT_TABLE=event_db.event_schema.my_event_table;

-- Example 27475
SELECT SYSTEM$UNSET_EVENT_SHARING_ACCOUNT_FOR_REGION('<snowflake_region>', '<region_group>', '<account_name>')

-- Example 27476
SELECT SYSTEM$SHOW_EVENT_SHARING_ACCOUNTS()

-- Example 27477
SHOW VERSIONS
  IN APPLICATION PACKAGE HelloSnowflake;

-- Example 27478
SELECT * FROM EVENT_DB.EVENT_SCHEMA.MY_EVENT_TABLE

-- Example 27479
artifacts:
  setup_script: setup.sql
configuration:
  trace_level: OFF
  log_level: DEBUG

-- Example 27480
CALL SYSTEM$SET_EVENT_SHARING_ACCOUNT_FOR_REGION('<snowflake_region>', '<region_group>', '<account_name>')

-- Example 27481
CALL SYSTEM$UNSET_EVENT_SHARING_ACCOUNT_FOR_REGION('<snowflake_region>', '<region_group>', '<account_name>')

-- Example 27482
CALL SYSTEM$SHOW_EVENT_SHARING_ACCOUNTS()

-- Example 27483
DESC APPLICATION HelloSnowflake;

-- Example 27484
SHOW VERSIONS
  IN APPLICATION PACKAGE HelloSnowflake;

-- Example 27485
SELECT * FROM EVENT_DB.EVENT_SCHEMA.MY_EVENT_TABLE

-- Example 27486
CREATE OR ALTER VERSIONED SCHEMA app_schema;

CREATE OR REPLACE PROCEDURE app_schema.hidden_sum(num1 float, num2 float)
RETURNS FLOAT
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
  DECLARE
    SUM FLOAT;
  BEGIN
    SYSTEM$LOG('INFO', 'CALCULATE THE SUM OF TWO NUMBERS');
    SUM := :NUM1 + :NUM2;
    RETURN SUM;
  END;
$$;

-- Example 27487
CREATE OR REPLACE PROCEDURE app_schema.sum(num1 float, num2 float)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
    BEGIN
      IF (SYSTEM$IS_APPLICATION_INSTALLED_FROM_SAME_ACCOUNT() or SYSTEM$IS_APPLICATION_SHARING_EVENTS_WITH_PROVIDER()) THEN
        CALL APP_SCHEMA.HIDDEN_SUM(:NUM1, :NUM2);
      ELSE
        -- notify consumers that they need to enable event sharing
        RETURN 'Sorry you can\'t access the API, please enable event sharing.';
      END IF;
    END;
$$;


CREATE APPLICATION ROLE IF NOT EXISTS ADMIN_ROLE;
GRANT USAGE ON SCHEMA APP_SCHEMA TO APPLICATION ROLE ADMIN_ROLE;

-- Example 27488
import streamlit as st
import snowflake.permissions as permissions

def critical_feature_that_requires_event_sharing():
  st.write("critical_feature_that_requires_event_sharing")

def main():
  if permissions.is_event_sharing_enabled() or permissions.is_application_local_to_package():
     critical_feature_that_requires_event_sharing()
  else:
     permissions.request_event_sharing()

if __name__ == "__main__":
  main()

-- Example 27489
configuration:
  ...
  log_level: INFO
  trace_level: ALWAYS
  metric_level: ALL
  ...

-- Example 27490
configuration:
  telemetry_event_definitions:
    - type: ERRORS_AND_WARNINGS
      sharing: MANDATORY
    - type: DEBUG_LOGS
      sharing: OPTIONAL

-- Example 27491
SELECT SYSTEM$SET_EVENT_SHARING_ACCOUNT_FOR_REGION('<snowflake_region>', '<region_group>', '<account_name>')

-- Example 27492
CREATE EVENT TABLE event_db.event_schema.my_event_table;

-- Example 27493
ALTER ACCOUNT SET EVENT_TABLE=event_db.event_schema.my_event_table;

-- Example 27494
SELECT SYSTEM$UNSET_EVENT_SHARING_ACCOUNT_FOR_REGION('<snowflake_region>', '<region_group>', '<account_name>')

-- Example 27495
SELECT SYSTEM$SHOW_EVENT_SHARING_ACCOUNTS()

-- Example 27496
SHOW VERSIONS
  IN APPLICATION PACKAGE HelloSnowflake;

-- Example 27497
SELECT * FROM EVENT_DB.EVENT_SCHEMA.MY_EVENT_TABLE

-- Example 27498
privileges:
  - EXECUTE TASK:
    description: "Privilege to run tasks within the consumer account"

-- Example 27499
SHOW PRIVILEGES IN APPLICATION hello_snowflake_app;

-- Example 27500
GRANT CREATE DATABASE ON ACCOUNT TO APPLICATION hello_snowflake_app;

-- Example 27501
GRANT IMPORTED PRIVILEGES ON DATABASE MYDATABASE TO APPLICATION hello_snowflake_app;

-- Example 27502
restricted_features:
  - external_data:
     description: “The reason for enabling an external or Iceberg table.”

-- Example 27503
manifest_version: 1
configuration:
  log_level: warn
  trace_level: off
...
references:
  - consumer_secret:
      label: "Consumer's Secret"
      description: "Needed to authenticate with xyz.com"
      privileges:
        - READ
      object_type: SECRET
      register_callback: config.register_my_secret
      configuration_callback: config.get_config_for_ref
  - consumer_external_access:
      label: "Default External Access Integration"
      description: "This is required to access xyz.com"
      privileges:
        - USAGE
      object_type: EXTERNAL ACCESS INTEGRATION
      register_callback: config.register_reference
      configuration_callback: config.get_config_for_ref
      required_at_setup: true

-- Example 27504
CREATE OR REPLACE PROCEDURE configuration_callback_name(ref_name string)
RETURNS STRING
language <language>
as
$$
  ...
$$

-- Example 27505
GRANT USAGE ON PROCEDURE configuration_callback_name(string)
  TO APPLICATION ROLE app_role;

-- Example 27506
CREATE OR REPLACE PROCEDURE config.get_config_for_ref(ref_name STRING)
    RETURNS STRING
    LANGUAGE SQL
    AS
    $$
    BEGIN
      CASE (ref_name)
        WHEN 'CONSUMER_EXTERNAL_ACCESS' THEN
          RETURN '{
            "type": "CONFIGURATION",
            "payload":{
              "host_ports":["google.com"],
              "allowed_secrets" : "LIST",
              "secret_references":["CONSUMER_SECRET"]}}';
        WHEN 'CONSUMER_SECRET' THEN
          RETURN '{
            "type": "CONFIGURATION",
            "payload":{
              "type" : "OAUTH2",
              "security_integration": {
                "oauth_scopes": ["https://www.googleapis.com/auth/analytics.readonly"],
                "oauth_token_endpoint": "https://oauth2.googleapis.com/token",
                "oauth_authorization_endpoint":
                    "https://accounts.google.com/o/oauth2/auth"}}}';
  END CASE;
  RETURN '';
  END;
  $$;

GRANT USAGE ON PROCEDURE config.get_config_for_ref(string)
  TO APPLICATION ROLE app_admin;

-- Example 27507
privileges:
  - EXECUTE TASK:
    description: "Privilege to run tasks within the consumer account"

-- Example 27508
SHOW PRIVILEGES IN APPLICATION hello_snowflake_app;

-- Example 27509
GRANT CREATE DATABASE ON ACCOUNT TO APPLICATION hello_snowflake_app;

-- Example 27510
GRANT IMPORTED PRIVILEGES ON DATABASE MYDATABASE TO APPLICATION hello_snowflake_app;

-- Example 27511
CREATE SERVICE IF NOT EXISTS app_service
  IN COMPUTE POOL app_compute_pool
  FROM SPECIFICATION_FILE = '/containers/service1_spec.yaml';

