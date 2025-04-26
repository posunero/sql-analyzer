-- Example 27512
CREATE SERVICE IF NOT EXISTS app_service
  IN COMPUTE POOL app_compute_pool
  FROM SPECIFICATION_TEMPLATE_FILE = '/containers/service1_spec.yaml';

-- Example 27513
configuration:
  log_level: INFO
  trace_level: ALWAYS
  metric_level: ALL
  grant_callback: core.grant_callback

-- Example 27514
CREATE SCHEMA core;
 CREATE APPLICATION ROLE app_public;

 CREATE OR REPLACE PROCEDURE core.grant_callback(privileges array)
 RETURNS STRING
 AS $$
 BEGIN
   IF (ARRAY_CONTAINS('CREATE COMPUTE POOL'::VARIANT, privileges)) THEN
      CREATE COMPUTE POOL IF NOT EXISTS app_compute_pool
          MIN_NODES = 1
          MAX_NODES = 3
          INSTANCE_FAMILY = GPU_NV_M;
   END IF;
   IF (ARRAY_CONTAINS('BIND SERVICE ENDPOINT'::VARIANT, privileges)) THEN
      CREATE SERVICE IF NOT EXISTS core.app_service
       IN COMPUTE POOL my_compute_pool
       FROM SPECIFICATION_FILE = '/containers/service1_spec.yaml';
   END IF;
   RETURN 'DONE';
 END;
 $$;

GRANT USAGE ON PROCEDURE core.grant_callback(array) TO APPLICATION ROLE app_public;

-- Example 27515
SELECT SYSTEM$WAIT_FOR_SERVICES(600, 'services.web_ui', 'services.worker', 'services.aggregation');

-- Example 27516
lifecycle_callback:
  version_initializer: callback.version_init

-- Example 27517
CREATE OR ALTER VERSIONED SCHEMA callback;

CREATE OR REPLACE PROCEDURE callback.version_init()
  ...
  -- body of the version_init() procedure
  ...

-- Example 27518
CREATE OR ALTER VERSIONED SCHEMA stateless_objects;
CREATE OR REPLACE PROCEDURE stateless_object.py_echo_proc(STR string)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION=3.9
  PACKAGES=('snowflake-snowpark-python')
  HANDLER='echo.echo_proc'
  IMPORTS=('/libraries/echo.py');

CREATE OR ALTER SCHEMA stateful_object;
CREATE TABLE stateful_object.config_props
  prop_name STRING;
  prop_value STRING;
  time_stamp TIMESTAMP;

-- Example 27519
CREATE OR ALTER VERSIONED SCHEMA version_schema;

-- Example 27520
CREATE SCHEMA IF NOT EXISTS stateful_object;

CREATE TABLE IF NOT EXISTS stateful_object.config (
  config_param STRING,
  config_value STRING,
  default_value STRING,
  modified_on  TIMESTAMP);

ALTER TABLE stateful_object.config
  ADD COLUMN IF NOT EXISTS modified_on TIMESTAMP;

-- Example 27521
CREATE OR ALTER VERSIONED SCHEMA stateless_object;
CREATE FUNCTION IF NOT EXISTS stateless_object.add(x int, y int)
  RETURNS INT
  LANGUAGE SQL
  AS $$ x + y $$;

-- Example 27522
CREATE APPLICATION PACKAGE hello_snowflake_package
  DISTRIBUTION = EXTERNAL;

-- Example 27523
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DISTRIBUTION = EXTERNAL;

-- Example 27524
SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 27525
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00'

-- Example 27526
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00'

-- Example 27527
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00'

-- Example 27528
ALTER APPLICATION PACKAGE my_application_package SET DEFAULT RELEASE DIRECTIVE
  VERSION = v2
  PATCH = 0;

-- Example 27529
ALTER APPLICATION PACKAGE my_application_package
  SET RELEASE DIRECTIVE my_custom_release_directive
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = v2
  PATCH = 0;

-- Example 27530
ALTER APPLICATION <name> UPGRADE

-- Example 27531
SELECT * FROM snowflake.data_sharing_usage.APPLICATION_STATE

-- Example 27532
Error Code: 093197 Account is not allowed to create application package versions or patches with
Snowpark Container Services for EXTERNAL distribution

-- Example 27533
Appeal <App Name>, <Version>, <Patch>

-- Example 27534
CREATE APPLICATION PACKAGE hello_snowflake_package
  DISTRIBUTION = EXTERNAL;

-- Example 27535
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DISTRIBUTION = EXTERNAL;

-- Example 27536
SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 27537
{
    "status": "PAUSED",
    "configurationStatus": "FINALIZED"
}

-- Example 27538
{
  "response_code": "OK"
}

-- Example 27539
{
  "response_code": "<ERROR_CODE>",
  "message": "error message"
}

-- Example 27540
{
    "status": "STARTED",
    "configurationStatus": "FINALIZED"
}

-- Example 27541
{
  "response_code": "OK"
}

-- Example 27542
{
  "response_code": "<ERROR_CODE>",
  "message": "error message"
}

-- Example 27543
{
    "response_code" : "OK",
    "config": {
        "key1": "value1",
        "key2": "value2"
    }
}

-- Example 27544
{
  "response_code": "OK"
}

-- Example 27545
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 27546
{
  "response_code": "OK"
}

-- Example 27547
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 27548
EXECUTE IMMEDIATE FROM 'native-connectors-sdk-components/all.sql';

-- Example 27549
-- Core connector objects
EXECUTE IMMEDIATE FROM 'core.sql';

-- Connector configuration prerequisites
EXECUTE IMMEDIATE FROM 'prerequisites.sql';

-- Connector configuration flow
EXECUTE IMMEDIATE FROM 'configuration/app_config.sql';
EXECUTE IMMEDIATE FROM 'configuration/connector_configuration.sql';

-- Example 27550
{
    "response_code": "<response code>",
    "message": "<message>"
}

-- Example 27551
default ConnectorResponse withExceptionLoggingAndWrapping(Supplier<ConnectorResponse> action) {
    return withExceptionWrapping(() -> withExceptionLogging(action));
}

-- Example 27552
public static Variant setConnectionConfiguration(Session session, Variant configuration) {
    var handler = ConnectionConfigurationHandler.builder(session).build();
    return handler.setConnectionConfiguration(configuration).toVariant();
}

public ConnectorResponse setConnectionConfiguration(Variant configuration) {
    return errorHelper.withExceptionLoggingAndWrapping(
        () -> setConnectionConfigurationBody(configuration)
    );
}

-- Example 27553
class CustomUnknownExceptionMapper implements ExceptionMapper<Exception> {

    @Override
    public ConnectorException map(Exception exception) {
        return new CustomConnectorException(exception);
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the PUBLIC.SET_CONNECTION_CONFIGURATION procedure using SQL
    public static Variant configureConnection(Session session, Variant configuration) {
            //Using builder
        var errorHelper = new ConnectorErrorHelperBuilder()
            .withConnectorExceptionLogger(new CustomUnknownExceptionMapper())
            .build();

        var handler = ConnectionConfigurationHandler.builder(session)
            .withErrorHelper(errorHelper)
            .build();

        return handler.connectionConfiguration(configuration).toVariant();
    }
}

-- Example 27554
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 27555
SELECT * FROM PLATFORM_CI_TOOLS.PUBLIC.EVENTS
    WHERE RESOURCE_ATTRIBUTES:"snow.database.name" LIKE '<INSTANCE_NAME>'
    [AND SCOPE:"name" LIKE '<ERROR_CODE>']
    [ORDER BY timestamp DESC];

-- Example 27556
{
    "status": "CONFIGURING",
    "configurationStatus": "INSTALLED"
}

-- Example 27557
CREATE OR REPLACE PROCEDURE PUBLIC.RESET_CONFIGURATION()
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.snowflake.connectors.application.configuration.reset.CustomResetConfigurationHandler.resetConfiguration';

GRANT USAGE ON PROCEDURE PUBLIC.RESET_CONFIGURATION() TO APPLICATION ROLE ADMIN;

-- Example 27558
CREATE OR REPLACE PROCEDURE PUBLIC.RESET_CONFIGURATION_INTERNAL()
    RETURNS VARIANT
LANGUAGE SQL
EXECUTE AS OWNER
AS
BEGIN
    -- SOME CUSTOM LOGIC

    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
END;

-- Example 27559
CREATE OR REPLACE PROCEDURE PUBLIC.RESET_CONFIGURATION_INTERNAL()
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.snowflake.connectors.application.configuration.reset.CustomResetConfigurationCallback.resetConfiguration';

-- Example 27560
class CustomResetConfigurationValidator implements ResetConfigurationValidator {

    @Override
    public ConnectorResponse validate() {
        // CUSTOM VALIDATION LOGIC
        return ConnectorResponse.success();
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the SQL definition of the PUBLIC.RESET_CONFIGURATION procedure
    public static Variant resetConfiguration(Session session) {
        // Using the builder
        var handler = ResetConfigurationHandler.builder(session)
            .withValidator(new CustomResetConfigurationValidator())
            .build();
        return handler.resetConfiguration().toVariant();
    }
}

-- Example 27561
CREATE OR REPLACE PROCEDURE PUBLIC.PAUSE_CONNECTOR()
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.custom.handler.CustomPauseConnectorHandler.pauseConnector';

GRANT USAGE ON PROCEDURE PUBLIC.PAUSE_CONNECTOR() TO APPLICATION ROLE ADMIN;

-- Example 27562
CREATE OR REPLACE PROCEDURE PUBLIC.PAUSE_CONNECTOR_INTERNAL()
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

CREATE OR REPLACE PROCEDURE PUBLIC.PAUSE_CONNECTOR_VALIDATE()
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.custom.handler.CustomPauseConnectorInternalHandler.pauseConnector';

-- Example 27563
class CustomPauseConnectorStateValidator implements PauseConnectorStateValidator {
    @Override
    public ConnectorResponse validate() {
        // CUSTOM LOGIC
        return ConnectorResponse.success();
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the PUBLIC.PAUSE_CONNECTOR procedure using SQL
    public static Variant pauseConnector(Session session) {
            //Using builder
        var handler = PauseConnectorHandlerBuilder.builder(session)
            .withStateValidator(new CustomPauseConnectorStateValidator())
            .build();
        return handler.pauseConnector().toVariant();
    }
}

-- Example 27564
CREATE OR REPLACE PROCEDURE PUBLIC.RESUME_CONNECTOR()
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.custom.handler.CustomResumeConnectorHandler.resumeConnector';

GRANT USAGE ON PROCEDURE PUBLIC.RESUME_CONNECTOR() TO APPLICATION ROLE ADMIN;

-- Example 27565
CREATE OR REPLACE PROCEDURE PUBLIC.RESUME_CONNECTOR_INTERNAL()
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

CREATE OR REPLACE PROCEDURE PUBLIC.RESUME_CONNECTOR_VALIDATE()
RETURNS VARIANT
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:1.11.0')
IMPORTS = ('/connectors-native-sdk.jar')
HANDLER = 'com.custom.handler.CustomResumeConnectorInternalHandler.resumeConnector';

-- Example 27566
class CustomResumeConnectorStateValidator implements ResumeConnectorStateValidator {
    @Override
    public ConnectorResponse validate() {
        // CUSTOM LOGIC
        return ConnectorResponse.success();
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the PUBLIC.RESUME_CONNECTOR procedure using SQL
    public static Variant resumeConnector(Session session) {
            //Using builder
        var handler = ResumeConnectorHandlerBuilder.builder(session)
            .withStateValidator(new CustomResumeConnectorStateValidator())
            .build();
        return handler.resumeConnector().toVariant();
    }
}

-- Example 27567
EXECUTE IMMEDIATE
$$
DECLARE
    prerequisites_exist NUMBER;
BEGIN
    SELECT COUNT (*) INTO :prerequisites_exist FROM state.prerequisites;
    IF (:prerequisites_exist = 0) THEN
        INSERT INTO STATE.PREREQUISITES (ID, TITLE, DESCRIPTION, DOCUMENTATION_URL, POSITION)
            VALUES
                ('1', '<Prerequisite name>', '<Prerequisite description>', 'Prerequisite url', 1)
    END IF;
END;
$$;

-- Example 27568
{
    "status": "CONFIGURING",
    "configurationStatus": "PREREQUISITES_DONE"
}

-- Example 27569
CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_CONNECTION_CONFIGURATION(connection_configuration VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomUpdateConnectionConfigurationHandler.updateConnectionConfiguration';

GRANT USAGE ON PROCEDURE PUBLIC.UPDATE_CONNECTION_CONFIGURATION(VARIANT) TO APPLICATION ROLE ADMIN;

-- Example 27570
CREATE OR REPLACE PROCEDURE PUBLIC.DRAFT_CONNECTION_CONFIGURATION_INTERNAL(connection_configuration VARIANT)
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

  CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_CONNECTION_CONFIGURATION_VALIDATE(connection_configuration VARIANT)
    RETURNS VARIANT
    LANGUAGE JAVA
    RUNTIME_VERSION = '11'
    PACKAGES = ('com.snowflake:snowpark:1.11.0')
    IMPORTS = ('/connectors-native-sdk.jar')
    HANDLER = 'com.custom.handler.CustomConnectionConfigurationInputValidator.validate';

-- Example 27571
class CustomConnectionConfigurationInputValidator implements ConnectionConfigurationInputValidator {

  @Override
  public ConnectorResponse validate(Variant configuration) {
    // CUSTOM VALIDATION LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.UPDATE_CONNECTION_CONFIGURATION procedure using SQL
  public static Variant updateConnectionConfiguration(Session session, Variant configuration) {
    // Using the builder
    var handler = UpdateConnectionConfigurationHandler.builder(session)
      .withInputValidator(new CustomConnectionConfigurationInputValidator())
      .build();
    return handler.updateConnectionConfiguration(configuration).toVariant();
  }
}

-- Example 27572
CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_WAREHOUSE(warehouse_name STRING)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomUpdateWarehouseHandler.updateWarehouse';

GRANT USAGE ON PROCEDURE PUBLIC.UPDATE_WAREHOUSE(STRING) TO APPLICATION ROLE ADMIN;

-- Example 27573
CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_WAREHOUSE_INTERNAL(warehouse_name STRING)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    -- SOME CUSTOM LOGIC

    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

-- Example 27574
CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_WAREHOUSE_INTERNAL(warehouse_name STRING)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomUpdateWarehouseCallback.execute';

-- Example 27575
class CustomUpdateWarehouseInputValidator implements UpdateWarehouseInputValidator {

  @Override
  public ConnectorResponse validate(Identifier warehouse) {
    // CUSTOM VALIDATION LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.UPDATE_WAREHOUSE procedure using SQL
  public static Variant updateWarehouse(Session session, String warehouseName) {
    // Using the builder
    var handler = UpdateWarehouseHandler.builder(session)
      .withInputValidator(new CustomUpdateWarehouseInputValidator())
      .build();
    return handler.updateWarehouse(warehouseName).toVariant();
  }
}

-- Example 27576
{
"statusCode": <http_status_code>,
"body":
        {
            "data":
                  [
                      [ 0, <value> ],
                      [ 1, <value> ]
                      ...
                  ]
        }
}

-- Example 27577
{
  "body":
    "{ \"data\": [ [ 0, 43, \"page\" ], [ 1, 42, \"life, the universe, and everything\" ] ] }"
}

-- Example 27578
{
  "statusCode": 200,
  "body": "{\"data\": [[0, [\"Echoing inputs:\", 43, \"page\"]], [1, [\"Echoing inputs:\", 42, \"life, the universe, and everything\"]]]}"
}

