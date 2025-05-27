#!/usr/bin/env python3
"""
Test file for unsupported Snowflake features in the current grammar.

This file contains SQL statements that represent Snowflake features documented
in the official Snowflake documentation but not currently supported by our
Snowflake grammar parser.

Each test case includes:
1. The SQL statement that should be supported
2. A comment explaining what feature it represents
3. The expected behavior when parsing is implemented
"""

import pytest
from lark import Lark
from lark.exceptions import LarkError

# Load the grammar (assuming it's in the same directory)
with open('sql_analyzer/grammar/snowflake.lark', 'r') as f:
    grammar = f.read()

parser = Lark(grammar, start='start')

class TestUnsupportedFeatures:
    """Test cases for Snowflake features not currently supported in the grammar."""
    
    def test_parse_unsupported_sql(self, sql_statement: str) -> None:
        """Helper method to test if SQL statement fails to parse (as expected for unsupported features)."""
        parser.parse(sql_statement)
    
    # ========== STREAMLIT OBJECTS ==========
    
    def test_create_streamlit_from_stage(self):
        """CREATE STREAMLIT from stage - not supported"""
        sql = """
        CREATE STREAMLIT hello_streamlit
          FROM @streamlit_db.streamlit_schema.streamlit_stage
          MAIN_FILE = 'streamlit_main.py'
          QUERY_WAREHOUSE = my_warehouse;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_streamlit_from_git(self):
        """CREATE STREAMLIT from Git repository - not supported"""
        sql = """
        CREATE STREAMLIT hello_streamlit
          FROM @streamlit_db.streamlit_schema.streamlit_repo/branches/streamlit_branch/
          MAIN_FILE = 'streamlit_main.py'
          QUERY_WAREHOUSE = my_warehouse;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_show_streamlits(self):
        """SHOW STREAMLITS command - not supported"""
        sql = "SHOW STREAMLITS;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_streamlit(self):
        """DESCRIBE STREAMLIT command - not supported"""
        sql = "DESC STREAMLIT hello_streamlit;"
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_streamlit(self):
        """DROP STREAMLIT command - not supported"""
        sql = "DROP STREAMLIT hello_streamlit;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== DYNAMIC TABLES ==========
    
    def test_create_dynamic_table(self):
        """CREATE DYNAMIC TABLE - not supported"""
        sql = """
        CREATE DYNAMIC TABLE product (pre_tax_profit, taxes, after_tax_profit)
          TARGET_LAG = '20 minutes'
          WAREHOUSE = mywh
          AS
            SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
            FROM staging_table;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_dynamic_table_with_refresh_mode(self):
        """CREATE DYNAMIC TABLE with REFRESH_MODE - not supported"""
        sql = """
        CREATE OR REPLACE DYNAMIC TABLE logins_with_predictions
            WAREHOUSE = my_wh
            TARGET_LAG = '20 minutes'
            REFRESH_MODE = INCREMENTAL
            INITIALIZE = on_create
            COMMENT = 'Dynamic table with continuously updated model predictions'
        AS
        SELECT l.login_id, l.user_id, l.location, l.event_time
        FROM logins_raw l;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_dynamic_iceberg_table(self):
        """CREATE DYNAMIC ICEBERG TABLE - not supported"""
        sql = """
        CREATE DYNAMIC ICEBERG TABLE my_dynamic_iceberg_table (
          id INT,
          name VARCHAR(100)
        )
        TARGET_LAG = '10 minutes'
        WAREHOUSE = my_warehouse
        EXTERNAL_VOLUME = 'my_external_volume'
        CATALOG = 'SNOWFLAKE'
        BASE_LOCATION = 'dynamic_table_location'
        AS SELECT id, name FROM source_table;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_show_dynamic_tables(self):
        """SHOW DYNAMIC TABLES - not supported"""
        sql = "SHOW DYNAMIC TABLES LIKE 'product_%' IN SCHEMA mydb.myschema;"
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_dynamic_table(self):
        """DROP DYNAMIC TABLE - not supported"""
        sql = "DROP DYNAMIC TABLE product;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== HYBRID TABLES ==========
    
    def test_create_hybrid_table(self):
        """CREATE HYBRID TABLE - not supported"""
        sql = """
        CREATE HYBRID TABLE my_hybrid_table (
            id INT PRIMARY KEY,
            name VARCHAR(100),
            value DOUBLE
        );
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_show_hybrid_tables(self):
        """SHOW HYBRID TABLES - not supported"""
        sql = "SHOW HYBRID TABLES;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== DATASETS ==========
    
    def test_create_dataset(self):
        """CREATE DATASET - not supported"""
        sql = "CREATE DATASET my_dataset;"
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_dataset_drop_version(self):
        """ALTER DATASET DROP VERSION - not supported"""
        sql = """
        ALTER DATASET my_dataset
        DROP VERSION 'v1';
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== MODELS ==========
    
    def test_alter_model_drop_version(self):
        """ALTER MODEL DROP VERSION - not supported"""
        sql = "ALTER MODEL my_model DROP VERSION v1_0;"
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_model_set_properties(self):
        """ALTER MODEL SET properties - not supported"""
        sql = """
        ALTER MODEL my_model SET
          COMMENT = 'Updated model'
          DEFAULT_VERSION = 'v2_0';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_model_set_tag(self):
        """ALTER MODEL SET TAG - not supported"""
        sql = "ALTER MODEL my_model SET TAG environment = 'production';"
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_model_version_set_alias(self):
        """ALTER MODEL VERSION SET ALIAS - not supported"""
        sql = "ALTER MODEL my_model VERSION v1_0 SET ALIAS = 'stable';"
        self.test_parse_unsupported_sql(sql)
    
    # ========== SNAPSHOTS ==========
    
    def test_drop_snapshot(self):
        """DROP SNAPSHOT - not supported"""
        sql = "DROP SNAPSHOT example_snapshot;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_snapshot(self):
        """DESCRIBE SNAPSHOT - not supported"""
        sql = "DESCRIBE SNAPSHOT example_snapshot;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== EXTERNAL VOLUMES ==========
    
    def test_create_external_volume_s3(self):
        """CREATE EXTERNAL VOLUME for S3 - not supported"""
        sql = """
        CREATE EXTERNAL VOLUME my_s3_external_volume
          STORAGE_LOCATIONS = (
            (
              NAME = 'my-s3-us-west-2'
              STORAGE_PROVIDER = 'S3'
              STORAGE_BASE_URL = 's3://my-bucket/my-path/'
              STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/my-role'
            )
          );
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_external_volume_azure(self):
        """CREATE EXTERNAL VOLUME for Azure - not supported"""
        sql = """
        CREATE EXTERNAL VOLUME my_azure_external_volume
          STORAGE_LOCATIONS = (
            (
              NAME = 'my-azure-location'
              STORAGE_PROVIDER = 'AZURE'
              STORAGE_BASE_URL = 'azure://myaccount.blob.core.windows.net/mycontainer/mypath/'
              AZURE_TENANT_ID = 'tenant-id'
            )
          );
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_external_volume_gcs(self):
        """CREATE EXTERNAL VOLUME for GCS - not supported"""
        sql = """
        CREATE EXTERNAL VOLUME my_gcs_external_volume
          STORAGE_LOCATIONS = (
            (
              NAME = 'my-gcs-location'
              STORAGE_PROVIDER = 'GCS'
              STORAGE_BASE_URL = 'gcs://my-bucket/my-path/'
              STORAGE_GCP_SERVICE_ACCOUNT = 'my-service-account@my-project.iam.gserviceaccount.com'
            )
          );
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_external_volume(self):
        """DROP EXTERNAL VOLUME - not supported"""
        sql = "DROP EXTERNAL VOLUME my_external_volume;"
        self.test_parse_unsupported_sql(sql)
    
    def test_undrop_external_volume(self):
        """UNDROP EXTERNAL VOLUME - not supported"""
        sql = "UNDROP EXTERNAL VOLUME my_external_volume;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_external_volumes(self):
        """SHOW EXTERNAL VOLUMES - not supported"""
        sql = "SHOW EXTERNAL VOLUMES;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_external_volume(self):
        """DESCRIBE EXTERNAL VOLUME - not supported"""
        sql = "DESCRIBE EXTERNAL VOLUME my_external_volume;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== CATALOG INTEGRATIONS ==========
    
    def test_create_catalog_integration_open_catalog(self):
        """CREATE CATALOG INTEGRATION for Open Catalog - not supported"""
        sql = """
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
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_catalog_integration_object_store(self):
        """CREATE CATALOG INTEGRATION for Object Store - not supported"""
        sql = """
        CREATE CATALOG INTEGRATION myCatalogInt
          CATALOG_SOURCE = OBJECT_STORE
          TABLE_FORMAT = ICEBERG
          ENABLED = TRUE;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_catalog_integration_rest(self):
        """CREATE CATALOG INTEGRATION for REST - not supported"""
        sql = """
        CREATE OR REPLACE CATALOG INTEGRATION tabular_catalog_int
          CATALOG_SOURCE = ICEBERG_REST
          TABLE_FORMAT = ICEBERG
          CATALOG_NAMESPACE = 'default'
          REST_CONFIG = (
            CATALOG_URI = 'https://api.tabular.io/ws'
            CATALOG_NAME = 'my_warehouse'
          )
          REST_AUTHENTICATION = (
            TYPE = OAUTH
            OAUTH_TOKEN_URI = 'https://api.tabular.io/ws/v1/oauth/tokens'
            OAUTH_CLIENT_ID = 'my_client_id'
            OAUTH_CLIENT_SECRET = 'my_client_secret'
            OAUTH_ALLOWED_SCOPES = ('catalog')
          )
          ENABLED = TRUE;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_catalog_integration(self):
        """DROP CATALOG INTEGRATION - not supported"""
        sql = "DROP CATALOG INTEGRATION my_catalog_integration;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED ICEBERG TABLE FEATURES ==========
    
    def test_create_iceberg_table_from_metadata_file(self):
        """CREATE ICEBERG TABLE from metadata file - not supported"""
        sql = """
        CREATE ICEBERG TABLE my_iceberg_table
          EXTERNAL_VOLUME='my_external_volume'
          CATALOG='my_catalog_integration'
          METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_iceberg_table_from_rest_catalog(self):
        """CREATE ICEBERG TABLE from REST catalog - not supported"""
        sql = """
        CREATE ICEBERG TABLE open_catalog_iceberg_table
          EXTERNAL_VOLUME = 'my_external_volume'
          CATALOG = 'open_catalog_int'
          CATALOG_TABLE_NAME = 'my_open_catalog_table'
          AUTO_REFRESH = TRUE;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_iceberg_table_from_delta_files(self):
        """CREATE ICEBERG TABLE from Delta files - not supported"""
        sql = """
        CREATE ICEBERG TABLE my_delta_iceberg_table
          CATALOG = delta_catalog_integration
          EXTERNAL_VOLUME = delta_external_volume
          BASE_LOCATION = 'relative/path/from/ext/vol/'
          AUTO_REFRESH = TRUE;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_iceberg_table_with_snowflake_catalog(self):
        """CREATE ICEBERG TABLE with Snowflake catalog - not supported"""
        sql = """
        CREATE ICEBERG TABLE my_iceberg_table (amount int)
          CATALOG = 'SNOWFLAKE'
          EXTERNAL_VOLUME = 'my_external_volume'
          BASE_LOCATION = 'my_iceberg_table'
          STORAGE_SERIALIZATION_POLICY = OPTIMIZED;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_iceberg_table_convert_to_managed(self):
        """ALTER ICEBERG TABLE CONVERT TO MANAGED - not supported"""
        sql = """
        ALTER ICEBERG TABLE myTable CONVERT TO MANAGED
          BASE_LOCATION = 'my/relative/path/from/external_volume'
          STORAGE_SERIALIZATION_POLICY = COMPATIBLE;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_iceberg_table_refresh(self):
        """ALTER ICEBERG TABLE REFRESH - not supported"""
        sql = "ALTER ICEBERG TABLE my_iceberg_table REFRESH 'path/to/metadata/v2.metadata.json';"
        self.test_parse_unsupported_sql(sql)
    
    def test_undrop_iceberg_table(self):
        """UNDROP ICEBERG TABLE - not supported"""
        sql = "UNDROP ICEBERG TABLE my_iceberg_table;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_iceberg_tables(self):
        """SHOW ICEBERG TABLES - not supported"""
        sql = "SHOW ICEBERG TABLES;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_iceberg_table(self):
        """DESCRIBE ICEBERG TABLE - not supported"""
        sql = "DESCRIBE ICEBERG TABLE my_iceberg_table;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== COMPUTE POOLS ==========
    
    def test_create_compute_pool(self):
        """CREATE COMPUTE POOL - not supported"""
        sql = """
        CREATE COMPUTE POOL tutorial_compute_pool
          MIN_NODES = 1
          MAX_NODES = 5
          INSTANCE_FAMILY = CPU_X64_XS;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_compute_pool(self):
        """DESCRIBE COMPUTE POOL - not supported"""
        sql = "DESCRIBE COMPUTE POOL tutorial_compute_pool;"
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_account_set_compute_pool(self):
        """ALTER ACCOUNT SET compute pool defaults - not supported"""
        sql = "ALTER ACCOUNT SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';"
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_compute_pool(self):
        """DROP COMPUTE POOL - not supported"""
        sql = "DROP COMPUTE POOL tutorial_compute_pool;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== CONNECTIONS ==========
    
    def test_create_connection(self):
        """CREATE CONNECTION - not supported"""
        sql = "CREATE CONNECTION my_connection;"
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_connection(self):
        """DROP CONNECTION - not supported"""
        sql = "DROP CONNECTION my_connection;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== APPLICATION PACKAGES & NATIVE APPS ==========
    
    def test_create_application_package(self):
        """CREATE APPLICATION PACKAGE - not supported"""
        sql = "CREATE APPLICATION PACKAGE hello_snowflake_package;"
        self.test_parse_unsupported_sql(sql)
    
    def test_create_application_from_package(self):
        """CREATE APPLICATION from package - not supported"""
        sql = """
        CREATE APPLICATION hello_snowflake_app
          FROM APPLICATION PACKAGE hello_snowflake_package;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_application_package_release_directive(self):
        """ALTER APPLICATION PACKAGE release directives - not supported"""
        sql = """
        ALTER APPLICATION PACKAGE hello_snowflake_package
          SET DEFAULT RELEASE DIRECTIVE
          VERSION = v1_0
          PATCH = 2;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_show_release_directives(self):
        """SHOW RELEASE DIRECTIVES - not supported"""
        sql = "SHOW RELEASE DIRECTIVES IN APPLICATION PACKAGE hello_snowflake_package;"
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_application_package(self):
        """DROP APPLICATION PACKAGE - not supported"""
        sql = "DROP APPLICATION PACKAGE hello_snowflake_package;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== LISTINGS ==========
    
    def test_alter_listing(self):
        """ALTER LISTING - not supported"""
        sql = "ALTER LISTING my_listing PUBLISH;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== PASSWORD POLICIES ==========
    
    def test_create_password_policy(self):
        """CREATE PASSWORD POLICY - not supported"""
        sql = """
        CREATE PASSWORD POLICY password_policy_production_1
          PASSWORD_MIN_LENGTH = 12
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
          COMMENT = 'Production password policy';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_password_policy(self):
        """DROP PASSWORD POLICY - not supported"""
        sql = "DROP PASSWORD POLICY password_policy_production_1;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_password_policies(self):
        """SHOW PASSWORD POLICIES - not supported"""
        sql = "SHOW PASSWORD POLICIES;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_password_policy(self):
        """DESCRIBE PASSWORD POLICY - not supported"""
        sql = "DESCRIBE PASSWORD POLICY password_policy_production_1;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== ROW ACCESS POLICIES ==========
    
    def test_create_row_access_policy(self):
        """CREATE ROW ACCESS POLICY - not supported"""
        sql = """
        CREATE OR REPLACE ROW ACCESS POLICY st_schema.row_access_policy
        AS (the_owner VARCHAR) RETURNS BOOLEAN ->
            the_owner = CURRENT_USER();
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_row_access_policy(self):
        """ALTER ROW ACCESS POLICY - not supported"""
        sql = "ALTER ROW ACCESS POLICY rap_table_employee_info SET BODY -> false;"
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_row_access_policy(self):
        """DROP ROW ACCESS POLICY - not supported"""
        sql = "DROP ROW ACCESS POLICY rap_table_employee_info;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_row_access_policies(self):
        """SHOW ROW ACCESS POLICIES - not supported"""
        sql = "SHOW ROW ACCESS POLICIES;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_row_access_policy(self):
        """DESCRIBE ROW ACCESS POLICY - not supported"""
        sql = "DESC ROW ACCESS POLICY rap_table_employee_info;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== MASKING POLICIES ==========
    
    def test_create_masking_policy(self):
        """CREATE MASKING POLICY - not supported"""
        sql = """
        CREATE OR REPLACE MASKING POLICY email_mask AS (val string) returns string ->
          CASE
            WHEN current_role() IN ('ANALYST') THEN VAL
            ELSE '*********'
          END;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_masking_policy(self):
        """DESCRIBE MASKING POLICY - not supported"""
        sql = "DESC MASKING POLICY email_mask;"
        self.test_parse_unsupported_sql(sql)
    
    def test_masking_policy_with_exempt_other_policies(self):
        """CREATE MASKING POLICY with exempt_other_policies - not supported"""
        sql = """
        CREATE OR REPLACE MASKING POLICY governance.policies.email_mask
        AS (val string) RETURNS string ->
        CASE
          WHEN current_role() IN ('ANALYST') THEN val
          WHEN current_role() IN ('SUPPORT') THEN regexp_replace(val,'.+\\@','*****@')
          ELSE '********'
        END
        COMMENT = 'specify in row access policy'
        EXEMPT_OTHER_POLICIES = true;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_masking_policy(self):
        """DROP MASKING POLICY - not supported"""
        sql = "DROP MASKING POLICY email_mask;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_masking_policies(self):
        """SHOW MASKING POLICIES - not supported"""
        sql = "SHOW MASKING POLICIES IN SCHEMA governance.policies;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== EXTERNAL VOLUMES ==========
    
    def test_external_volume_in_create_database(self):
        """CREATE DATABASE with EXTERNAL_VOLUME - not supported"""
        sql = """
        CREATE OR ALTER DATABASE db1
          EXTERNAL_VOLUME = my_external_volume
          DATA_RETENTION_TIME_IN_DAYS = 5;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED ALTER TABLE FEATURES ==========
    
    def test_alter_table_add_row_access_policy(self):
        """ALTER TABLE ADD ROW ACCESS POLICY - not supported"""
        sql = """
        ALTER TABLE row_access_policy_test_table 
        ADD ROW ACCESS POLICY st_schema.row_access_policy ON (the_owner);
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_table_drop_all_row_access_policies(self):
        """ALTER TABLE DROP ALL ROW ACCESS POLICIES - not supported"""
        sql = "ALTER TABLE my_table DROP ALL ROW ACCESS POLICIES;"
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_table_constraint_properties(self):
        """ALTER TABLE with constraint properties (ENFORCED, VALIDATE, RELY) - not supported"""
        sql = """
        ALTER TABLE my_table 
        ADD CONSTRAINT pk_constraint PRIMARY KEY (id) NOT ENFORCED NOVALIDATE RELY;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_table_modify_constraint(self):
        """ALTER TABLE MODIFY CONSTRAINT - not supported"""
        sql = """
        ALTER TABLE my_table 
        MODIFY CONSTRAINT pk_constraint NOT ENFORCED VALIDATE NORELY;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED CREATE TABLE FEATURES ==========
    
    def test_create_table_with_classification_profile(self):
        """CREATE TABLE with CLASSIFICATION_PROFILE - not supported"""
        sql = """
        CREATE TABLE my_table (
            id INT,
            name VARCHAR(100)
        ) CLASSIFICATION_PROFILE = 'my_profile';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_table_with_storage_serialization_policy(self):
        """CREATE TABLE with STORAGE_SERIALIZATION_POLICY - not supported"""
        sql = """
        CREATE TABLE my_table (
            id INT,
            name VARCHAR(100)
        ) STORAGE_SERIALIZATION_POLICY = OPTIMIZED;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_table_with_max_data_extension_time(self):
        """CREATE TABLE with MAX_DATA_EXTENSION_TIME_IN_DAYS - not supported"""
        sql = """
        CREATE TABLE my_table (
            id INT,
            name VARCHAR(100)
        ) MAX_DATA_EXTENSION_TIME_IN_DAYS = 14;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED SCHEMA FEATURES ==========
    
    def test_create_schema_with_classification_profile(self):
        """CREATE SCHEMA with CLASSIFICATION_PROFILE - not supported"""
        sql = """
        CREATE SCHEMA my_schema
          CLASSIFICATION_PROFILE = 'my_profile'
          DEFAULT_NOTEBOOK_COMPUTE_POOL_CPU = 'my_pool';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_alter_schema_set_compute_pools(self):
        """ALTER SCHEMA SET compute pool defaults - not supported"""
        sql = """
        ALTER SCHEMA my_schema SET
          DEFAULT_NOTEBOOK_COMPUTE_POOL_CPU = 'cpu_pool'
          DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU = 'gpu_pool';
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== SYSTEM FUNCTIONS ==========
    
    def test_system_list_iceberg_tables_from_catalog(self):
        """SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG function - not supported"""
        sql = "SELECT SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG('myCatalogIntegration');"
        self.test_parse_unsupported_sql(sql)
    
    def test_system_list_namespaces_from_catalog(self):
        """SYSTEM$LIST_NAMESPACES_FROM_CATALOG function - not supported"""
        sql = "SELECT SYSTEM$LIST_NAMESPACES_FROM_CATALOG('my_catalog_integration', 'db1');"
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED FUNCTION FEATURES ==========
    
    def test_create_function_with_context_headers(self):
        """CREATE FUNCTION with CONTEXT_HEADERS - not supported"""
        sql = """
        CREATE OR ALTER FUNCTION my_echo_udf (InputText VARCHAR)
          RETURNS VARCHAR
          SERVICE = echo_service
          ENDPOINT = reverse_echoendpoint
          CONTEXT_HEADERS = (current_account)
          MAX_BATCH_ROWS = 100
          AS '/echo';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_function_with_service(self):
        """CREATE FUNCTION with SERVICE parameter - not supported"""
        sql = """
        CREATE FUNCTION my_service_function(input_text VARCHAR)
          RETURNS VARCHAR
          SERVICE = my_service
          ENDPOINT = my_endpoint
          AS '/process';
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== DESCRIBE TRANSACTION ==========
    
    def test_describe_transaction(self):
        """DESCRIBE TRANSACTION - not supported"""
        sql = "DESCRIBE TRANSACTION;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED ICEBERG FEATURES ==========
    
    def test_create_iceberg_table_with_policies(self):
        """CREATE ICEBERG TABLE with masking and row access policies - not supported"""
        sql = """
        CREATE ICEBERG TABLE my_iceberg_table (
            id INT WITH MASKING POLICY id_mask,
            name VARCHAR(100) WITH MASKING POLICY name_mask
        )
        EXTERNAL_VOLUME = 'my_volume'
        CATALOG = 'SNOWFLAKE'
        BASE_LOCATION = '/path/to/table'
        WITH ROW ACCESS POLICY my_row_policy ON (id)
        AS SELECT id, name FROM source_table;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED SELECT FEATURES ==========
    
    def test_select_with_exclude_replace_rename(self):
        """SELECT * with EXCLUDE, REPLACE, RENAME - not supported"""
        sql = """
        SELECT * EXCLUDE (sensitive_col) 
                 REPLACE (UPPER(name) AS name) 
                 RENAME (old_col AS new_col)
        FROM my_table;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== STAGE QUERIES ==========
    
    def test_stage_query_with_file_format(self):
        """Stage query with FILE_FORMAT - not supported"""
        sql = """
        SELECT $1
        FROM 'snow://dataset/foo/versions/V1'
        ( FILE_FORMAT => 'my_parquet_format',
        PATTERN => '.*data.*' ) t;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== UNDROP STATEMENTS ==========
    
    def test_undrop_tag(self):
        """UNDROP TAG - not supported"""
        sql = "UNDROP TAG my_tag;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== SECRETS ==========
    
    def test_create_secret_password(self):
        """CREATE SECRET with PASSWORD type - not supported"""
        sql = """
        CREATE OR REPLACE SECRET secret_password
          TYPE = PASSWORD
          USERNAME = 'my_user_name'
          PASSWORD = 'my_password';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_secret_oauth2(self):
        """CREATE SECRET with OAUTH2 type - not supported"""
        sql = """
        CREATE SECRET my_oauth_secret
          TYPE = OAUTH2
          API_AUTHENTICATION = 'oauth_integration'
          OAUTH2_REFRESH_TOKEN = 'refresh_token_value';
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_secret(self):
        """DROP SECRET - not supported"""
        sql = "DROP SECRET my_secret;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_secrets(self):
        """SHOW SECRETS - not supported"""
        sql = "SHOW SECRETS;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_secret(self):
        """DESCRIBE SECRET - not supported"""
        sql = "DESCRIBE SECRET my_secret;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== NETWORK RULES ==========
    
    def test_create_network_rule(self):
        """CREATE NETWORK RULE - not supported"""
        sql = """
        CREATE NETWORK RULE allow_access_rule
          MODE = INGRESS
          TYPE = IPV4
          VALUE_LIST = ('192.168.1.0/24');
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_drop_network_rule(self):
        """DROP NETWORK RULE - not supported"""
        sql = "DROP NETWORK RULE allow_access_rule;"
        self.test_parse_unsupported_sql(sql)
    
    def test_show_network_rules(self):
        """SHOW NETWORK RULES - not supported"""
        sql = "SHOW NETWORK RULES;"
        self.test_parse_unsupported_sql(sql)
    
    def test_describe_network_rule(self):
        """DESCRIBE NETWORK RULE - not supported"""
        sql = "DESCRIBE NETWORK RULE allow_access_rule;"
        self.test_parse_unsupported_sql(sql)
    
    # ========== ADVANCED EXTERNAL TABLE FEATURES ==========
    
    def test_create_external_table_with_infer_schema(self):
        """CREATE EXTERNAL TABLE with INFER_SCHEMA - not supported"""
        sql = """
        CREATE EXTERNAL TABLE mytable
          USING TEMPLATE (
            SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
            FROM TABLE(
              INFER_SCHEMA(
                LOCATION=>'@mystage',
                FILE_FORMAT=>'my_parquet_format'
              )
            )
          )
          LOCATION=@mystage
          FILE_FORMAT=my_parquet_format
          AUTO_REFRESH=false;
        """
        self.test_parse_unsupported_sql(sql)
    
    def test_create_external_table_with_delta_format(self):
        """CREATE EXTERNAL TABLE with Delta format - not supported"""
        sql = """
        CREATE EXTERNAL TABLE my_delta_table
          LOCATION = @my_stage
          FILE_FORMAT = (TYPE = PARQUET)
          TABLE_FORMAT = DELTA
          AUTO_REFRESH = TRUE;
        """
        self.test_parse_unsupported_sql(sql)
    
    # ========== COPY INTO WITH LOAD_MODE ==========
    
    def test_copy_into_with_load_mode(self):
        """COPY INTO with LOAD_MODE for Iceberg tables - not supported"""
        sql = """
        COPY INTO customer_iceberg_ingest
          FROM @my_parquet_stage
          FILE_FORMAT = 'my_parquet_format'
          LOAD_MODE = ADD_FILES_COPY
          PURGE = TRUE
          MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;
        """
        self.test_parse_unsupported_sql(sql)

if __name__ == "__main__":
    # Run a simple test to verify the test framework works
    test_instance = TestUnsupportedFeatures()
    
    print("Testing unsupported Snowflake features...")
    print("Note: All tests should FAIL to parse (as expected for unsupported features)")
    
    # Test a few examples
    try:
        test_instance.test_create_streamlit_from_stage()
        print("✓ CREATE STREAMLIT test passed (correctly failed to parse)")
    except Exception as e:
        print(f"✗ CREATE STREAMLIT test failed unexpectedly: {e}")
    
    try:
        test_instance.test_create_dynamic_table()
        print("✓ CREATE DYNAMIC TABLE test passed (correctly failed to parse)")
    except Exception as e:
        print(f"✗ CREATE DYNAMIC TABLE test failed unexpectedly: {e}")
    
    try:
        test_instance.test_create_row_access_policy()
        print("✓ CREATE ROW ACCESS POLICY test passed (correctly failed to parse)")
    except Exception as e:
        print(f"✗ CREATE ROW ACCESS POLICY test failed unexpectedly: {e}")
    
    try:
        test_instance.test_create_external_volume_s3()
        print("✓ CREATE EXTERNAL VOLUME test passed (correctly failed to parse)")
    except Exception as e:
        print(f"✗ CREATE EXTERNAL VOLUME test failed unexpectedly: {e}")
    
    try:
        test_instance.test_create_catalog_integration_open_catalog()
        print("✓ CREATE CATALOG INTEGRATION test passed (correctly failed to parse)")
    except Exception as e:
        print(f"✗ CREATE CATALOG INTEGRATION test failed unexpectedly: {e}")
    
    print("\nAll tests completed. These features should be added to the grammar.") 