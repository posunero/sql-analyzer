-- More Extracted Snowflake SQL Examples (Set 13)

-- From snowflake_split_411.sql

CREATE SERVICE IF NOT EXISTS app_service
  IN COMPUTE POOL app_compute_pool
  FROM SPECIFICATION_TEMPLATE_FILE = '/containers/service1_spec.yaml';

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

SELECT SYSTEM$WAIT_FOR_SERVICES(600, 'services.web_ui', 'services.worker', 'services.aggregation');

CREATE OR ALTER VERSIONED SCHEMA callback;
CREATE OR REPLACE PROCEDURE callback.version_init()
  -- body of the version_init() procedure
  ...

CREATE OR ALTER VERSIONED SCHEMA stateless_objects;
CREATE OR REPLACE PROCEDURE stateless_object.py_echo_proc(STR string)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION=3.9
  PACKAGES=('snowflake-snowpark-python')
  HANDLER='echo.echo_proc'
  IMPORTS=('/libraries/echo.py');

CREATE OR ALTER SCHEMA stateful_object;
CREATE TABLE stateful_object.config_props (
  prop_name STRING,
  prop_value STRING,
  time_stamp TIMESTAMP
);

CREATE OR ALTER VERSIONED SCHEMA version_schema;

CREATE SCHEMA IF NOT EXISTS stateful_object;
CREATE TABLE IF NOT EXISTS stateful_object.config (
  config_param STRING,
  config_value STRING,
  default_value STRING,
  modified_on  TIMESTAMP);
ALTER TABLE stateful_object.config
  ADD COLUMN IF NOT EXISTS modified_on TIMESTAMP;

CREATE OR ALTER VERSIONED SCHEMA stateless_object;
CREATE FUNCTION IF NOT EXISTS stateless_object.add(x int, y int)
  RETURNS INT
  LANGUAGE SQL
  AS $$ x + y $$;

CREATE APPLICATION PACKAGE hello_snowflake_package
  DISTRIBUTION = EXTERNAL;

ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DISTRIBUTION = EXTERNAL;

SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_package;

ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00';

ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00';

ALTER APPLICATION PACKAGE my_application_package SET DEFAULT RELEASE DIRECTIVE
  VERSION = v2
  PATCH = 0;

ALTER APPLICATION PACKAGE my_application_package
  SET RELEASE DIRECTIVE my_custom_release_directive
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = v2
  PATCH = 0;

ALTER APPLICATION <name> UPGRADE;

SELECT * FROM snowflake.data_sharing_usage.APPLICATION_STATE; 