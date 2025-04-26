-- Example 17800
my_warehouses = root.warehouses # my_warehouses is a WarehouseCollection

-- Example 17801
my_wh_ref = my_warehouses.warehouses["my_wh"] # my_wh_ref is a WarehouseResource

-- Example 17802
my_wh = my_wh_ref.fetch() # my_wh is a Warehouse model object

-- Example 17803
my_wh.warehouse_size = "X-Small"

-- Example 17804
my_wh_ref.create_or_alter(my_wh) # Use the WarehouseResource to perform create_or_alter

-- Example 17805
# my_wh is fetched from an existing warehouse
my_warehouses = root.warehouses # my_warehouses is a WarehouseCollection
my_wh_ref = my_warehouses.warehouses["my_wh"] # my_wh_ref is a WarehouseResource
my_wh = my_wh_ref.fetch() # my_wh is a Warehouse model object
my_wh.warehouse_size = "X-Small"

my_wh_ref.create_or_alter(my_wh) # Use the WarehouseResource perform create_or_alter

-- Example 17806
ALTER SERVICE [ IF EXISTS ] <name> { SUSPEND | RESUME }

ALTER SERVICE [ IF EXISTS ] <name>
  {
     fromSpecification
     | fromSpecificationTemplate
  }

ALTER SERVICE [IF EXISTS] <service_name> RESTORE VOLUME <volume_name>
                                                 INSTANCES <comma_separated_instance_ids>
                                                 FROM SNAPSHOT <snapshot_name>

ALTER SERVICE [ IF EXISTS ] <name> SET [ MIN_INSTANCES = <num> ]
                                       [ MAX_INSTANCES = <num> ]
                                       [ AUTO_SUSPEND_SECS = <num> ]
                                       [ MIN_READY_INSTANCES = <num> ]
                                       [ QUERY_WAREHOUSE = <warehouse_name> ]
                                       [ AUTO_RESUME = { TRUE | FALSE } ]
                                       [ EXTERNAL_ACCESS_INTEGRATIONS = ( <EAI_name> [ , ... ] ) ]
                                       [ COMMENT = '<string_literal>' ]



ALTER SERVICE [ IF EXISTS ] <name> UNSET { MIN_INSTANCES                |
                                           AUTO_SUSPEND_SECS            |
                                           MAX_INSTANCES                |
                                           MIN_READY_INSTANCES          |
                                           QUERY_WAREHOUSE              |
                                           AUTO_RESUME                  |
                                           EXTERNAL_ACCESS_INTEGRATIONS |
                                           COMMENT
                                         }
                                         [ , ... ]

ALTER SERVICE [ IF EXISTS ] <name> SET [ TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]]

-- Example 17807
fromSpecification ::=
  {
    FROM SPECIFICATION_FILE = '<yaml_file_path>' -- for native app service.
    | FROM @<stage> SPECIFICATION_FILE = '<yaml_file_path>' -- for non-native app service.
    | FROM SPECIFICATION <specification_text>
  }

-- Example 17808
fromSpecificationTemplate ::=
  {
    FROM SPECIFICATION_TEMPLATE_FILE = '<yaml_file_path>' -- for native app service.
    | FROM @<stage> SPECIFICATION_TEMPLATE_FILE = '<yaml_file_path>' -- for non-native app service.
    | FROM SPECIFICATION_TEMPLATE <specification_text>
  }
  USING ( <key> => <value> [ , <key> => <value> [ , ... ] ]  )

-- Example 17809
ALTER SERVICE echo_service SUSPEND;

-- Example 17810
ALTER SERVICE echo_service SET MIN_INSTANCES=3 MAX_INSTANCES=5;

-- Example 17811
ALTER SERVICE example_service
  RESTORE VOLUME "myvolume"
  INSTANCES 0,2
  FROM SNAPSHOT my_snapshot;

-- Example 17812
snow app deploy
  <paths>
  --prune / --no-prune
  --recursive / --no-recursive
  --interactive / --no-interactive
  --force
  --validate / --no-validate
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 17813
cd my_app_project
my_app_project_build_script.sh
snow app deploy --connection="dev"

-- Example 17814
snow app run
  --version <version>
  --patch <patch>
  --from-release-directive
  --channel <channel>
  --interactive / --no-interactive
  --force
  --validate / --no-validate
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 17815
cd my_app_project
my_app_project_build_script.sh
snow app run --connection="dev"

-- Example 17816
snow app run --version V1 --patch 12 --interactive --connection="dev"

-- Example 17817
snow app run --from-release-directive --force --connection="dev"

-- Example 17818
snow app run --from-release-directive --channel ALPHA --connection="dev"

-- Example 17819
snow app run --env source_folder="src/app" --env stage_name=mystage

-- Example 17820
name: sf_env
channels:
- snowflake
dependencies:
- snowflake-native-apps-permission

-- Example 17821
import snowflake.permissions as permissions

-- Example 17822
privileges:
- CREATE DATABASE:
    description: "Creation of ingestion (required) and audit databases"

-- Example 17823
import streamlit as st
import snowflake.permissions as permissions
...
if not permissions.get_held_account_privileges(["CREATE DATABASE"]):
    st.error("The app needs CREATE DB privilege to replicate data")

-- Example 17824
references:
- servicenow_api_integration:
  label: "API INTEGRATION for ServiceNow communication"
  description: "An integration required in order to support extraction and visualization of ServiceNow data."
  privileges:
    - USAGE
  object_type: API Integration
  register_callback: config.register_reference

-- Example 17825
permissions.request_reference("servicenow_api_integration")

-- Example 17826
{
  "alias": "<value>",
  "database": "<value>",
  "schema": "<value>",
  "name": "<value>"
}

-- Example 17827
references:
  - consumer_table:
      label: "Consumer table"
      description: "A table in the consumer account that exists outside the APPLICATION object."
      privileges:
        - INSERT
        - SELECT
      object_type: TABLE
      multi_valued: false
      register_callback: config.register_single_reference

-- Example 17828
Reference definition '<REF_DEF_NAME>' cannot be found in the current version of the application '<APP_NAME>'

-- Example 17829
CREATE APPLICATION ROLE app_admin;

CREATE OR ALTER VERSIONED SCHEMA config;
GRANT USAGE ON SCHEMA config TO APPLICATION ROLE app_admin;

CREATE PROCEDURE CONFIG.REGISTER_SINGLE_REFERENCE(ref_name STRING, operation STRING, ref_or_alias STRING)
  RETURNS STRING
  LANGUAGE SQL
  AS $$
    BEGIN
      CASE (operation)
        WHEN 'ADD' THEN
          SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
        WHEN 'REMOVE' THEN
          SELECT SYSTEM$REMOVE_REFERENCE(:ref_name, :ref_or_alias);
        WHEN 'CLEAR' THEN
          SELECT SYSTEM$REMOVE_ALL_REFERENCES(:ref_name);
      ELSE
        RETURN 'unknown operation: ' || operation;
      END CASE;
      RETURN NULL;
    END;
  $$;

GRANT USAGE ON PROCEDURE CONFIG.REGISTER_SINGLE_REFERENCE(STRING, STRING, STRING)
  TO APPLICATION ROLE app_admin;

-- Example 17830
CREATE OR REPLACE CONFIG.GET_CONFIGURATION_FOR_REFERENCE(ref_name STRING)
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

GRANT USAGE ON PROCEDURE CONFIG.GET_CONFIGURATION_FOR_REFERENCE(STRING)
  TO APPLICATION ROLE app_admin;

-- Example 17831
SHOW REFERENCES IN APPLICATION hello_snowflake_app;

-- Example 17832
SELECT SYSTEM$REFERENCE('table', 'db1.schema1.table1', 'persistent', 'select', 'insert');

-- Example 17833
CALL app.config.register_single_reference(
  'consumer_table' , 'ADD', SYSTEM$REFERENCE('TABLE', 'db1.schema1.table1', 'PERSISTENT', 'SELECT', 'INSERT'));

-- Example 17834
SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);

-- Example 17835
SELECT * FROM reference('consumer_table');

-- Example 17836
SELECT reference('encrypt_func')(t.c1) FROM consumer_table t;

-- Example 17837
CALL reference('consumer_proc')(11, 'hello world');

-- Example 17838
INSERT INTO reference('data_export')(C1, C2)
  SELECT T.C1, T.C2 FROM reference('other_table')

-- Example 17839
COPY INTO reference('the_table') ...

-- Example 17840
DESCRIBE TABLE reference('the_table')

-- Example 17841
CREATE TASK app_task
  WAREHOUSE = reference('consumer_warehouse')
  ...;

ALTER TASK app_task SET WAREHOUSE = reference('consumer_warehouse');

-- Example 17842
CREATE VIEW app_view
  AS SELECT reference('function')(T.C1) FROM reference('table') AS T;

-- Example 17843
CREATE FUNCTION app.func(x INT)
  RETURNS STRING
  AS $$ select reference('consumer_func')(x) $$;

-- Example 17844
CREATE EXTERNAL FUNCTION app.func(x INT)
  RETURNS STRING
  ...
  API_INTEGRATION = reference('app_integration');

-- Example 17845
CREATE FUNCTION app.func(x INT)
  RETURNS STRING
  ...
  EXTERNAL_ACCESS_INTEGRATIONS = (reference('consumer_external_access_integration'), ...);
  SECRETS = ('cred1' = reference('consumer_secret'), ...);

-- Example 17846
CREATE ROW ACCESS POLICY app_policy
  AS (sales_region varchar) RETURNS BOOLEAN ->
  'sales_executive_role' = reference('get_sales_team')
    or exists (
      select 1 from reference('sales_table')
        where sales_manager = reference('get_sales_team')()
        and region = sales_region
      );

-- Example 17847
{
  "type": "CONFIGURATION",
  "payload": {
    "host_ports": ["host_port_1", ...],
    "allowed_secrets": "NONE|ALL|LIST",
    "secret_references": ["ref_name_1", ...]
  }
}

-- Example 17848
{
  "type": "CONFIGURATION",
    "payload": {
            "type": "OAUTH2",
            "security_integration": {
                    "oauth_scopes": ["scope_1", "scope_2"],
                    "oauth_token_endpoint" : "token_endpoint",
                    "oauth_authorization_endpoint" : "auth_endpoint"
            }
    }
}

-- Example 17849
{
   "type": "ERROR",
   "payload":{
     "message": "The reference is not available for configuration ..."
  }
}

-- Example 17850
{
    "status": "CONFIGURING",
    "configurationStatus": "PREREQUISITES_DONE"
}

-- Example 17851
"global_schedule": {
    "scheduleType": "CRON",
    "scheduleDefinition": "*/10 * * * *"
}

-- Example 17852
{
    "status": "CONFIGURING",
    "configurationStatus": "CONFIGURED"
}

-- Example 17853
{
  "response_code": "OK",
}

-- Example 17854
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 17855
CREATE OR REPLACE PROCEDURE PUBLIC.CONFIGURE_CONNECTOR(config VARIANT)
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.custom.handler.CustomConfigureConnectorHandler.configureConnector';

GRANT USAGE ON PROCEDURE PUBLIC.CONFIGURE_CONNECTOR(VARIANT) TO APPLICATION ROLE ADMIN;

-- Example 17856
CREATE OR REPLACE PROCEDURE PUBLIC.CONFIGURE_CONNECTOR_INTERNAL(config VARIANT)
RETURNS VARIANT
LANGUAGE SQL
EXECUTE AS OWNER
AS
BEGIN
    -- SOME CUSTOM LOGIC BEGIN
    SELECT sysdate();
    -- SOME CUSTOM LOGIC END

    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
END;

CREATE OR REPLACE PROCEDURE PUBLIC.CONFIGURE_CONNECTOR_VALIDATE(config VARIANT)
    RETURNS VARIANT
    LANGUAGE JAVA
    RUNTIME_VERSION = '11'
    PACKAGES = ('com.snowflake:snowpark:1.11.0')
    IMPORTS = ('/connectors-native-sdk.jar')
    HANDLER = 'com.custom.handler.CustomConfigureConnectorInternalHandler.configureConnector';

-- Example 17857
class CustomConfigureConnectorInputValidator implements ConfigureConnectorInputValidator {
    @Override
    public ConnectorResponse validate(Variant config) {
        // CUSTOM LOGIC
        return ConnectorResponse.success();
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the PUBLIC.CONFIGURE_CONNECTOR procedure using SQL
    public static Variant configureConnector(Session session, Variant configuration) {
            //Using builder
        var handler = ConfigureConnectorHandler.builder(session)
            .withInputValidator(new CustomConfigureConnectorInputValidator())
            .build();
        return handler.configureConnector(configuration).toVariant();
    }
}

-- Example 17858
{
    "response_code" : "OK",
    "config": {
        "key1": "value1",
        "key2": "value2"
    }
}

-- Example 17859
{
    "status": "CONFIGURING",
    "configurationStatus": "CONNECTED"
}

-- Example 17860
{
  "response_code": "OK"
}

-- Example 17861
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 17862
CREATE OR REPLACE PROCEDURE PUBLIC.SET_CONNECTION_CONFIGURATION(config VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomConnectionConfigurationHandler.setConnectionConfiguration';

GRANT USAGE ON PROCEDURE PUBLIC.CONFIGURE_CONNECTOR(VARIANT) TO APPLICATION ROLE ADMIN;

-- Example 17863
CREATE OR REPLACE PROCEDURE PUBLIC.SET_CONNECTION_CONFIGURATION_INTERNAL(config VARIANT)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    -- SOME CUSTOM LOGIC BEGIN
    SELECT sysdate();
    -- SOME CUSTOM LOGIC END

    RETURN OBJECT_CONSTRUCT('response_code', 'OK', '"config"', '"transformed config variant"');
  END;

CREATE OR REPLACE PROCEDURE PUBLIC.SET_CONNECTION_CONFIGURATION_VALIDATE(config VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomConnectionConfigurationValidateHandler.setConnectionConfiguration';

-- Example 17864
class CustomConnectionConfigurationInputValidator implements ConnectionConfigurationInputValidator {
  @Override
  public ConnectorResponse validate(Variant config) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.SET_CONNECTION_CONFIGURATION procedure using SQL
  public static Variant configureConnection(Session session, Variant configuration) {
    //Using builder
    var handler = ConnectionConfigurationHandler.builder(session)
      .withInputValidator(new CustomConnectionConfigurationInputValidator())
      .build();
    return handler.connectionConfiguration(configuration).toVariant();
  }
}

-- Example 17865
CREATE OR REPLACE PROCEDURE PUBLIC.SETUP_EXTERNAL_INTEGRATION_WITH_NAMES(methods ARRAY)
    RETURNS VARIANT
    LANGUAGE SQL
    [...]

-- Example 17866
{
  "response_code": "OK",
  "message": "Successfully set up <number> method(s)."
}

