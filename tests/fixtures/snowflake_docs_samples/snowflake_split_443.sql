-- Example 29653
MessageSizeError: Data of size 522.0 MB exceeds the message size limit of 200.0 MB.
This is often caused by a large chart or dataframe. Please decrease the amount of data sent to the browser,
or increase the limit by setting the config option server.maxMessageSize.
Click here to learn more about config options.
Note that increasing the limit may lead to long loading times and large memory consumption of the client's browser and the Streamlit server.

-- Example 29654
df

-- Example 29655
data = session.table("BIG_TABLE")
df = data.to_pandas() # This may lead to memory error

-- Example 29656
# Import Snowpark pandas
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
# Create a Snowpark pandas DataFrame from BIG_TABLE
df = pd.read_snowflake("BIG_TABLE")
# Keep working with your data using the pandas API
df.dropna()

-- Example 29657
SELECT * from BIG_TABLE

-- Example 29658
df = cell1.to_pandas() # This may lead to memory error

-- Example 29659
SELECT * from BIG_TABLE
snowpark_df = cell1.to_df()
df = snowpark_df.to_snowpark_pandas()
# Keep working with your data using the Snowpark pandas API

-- Example 29660
Failed to retrieve image.

-- Example 29661
import logging
import sys

# Create a logger
logger = logging.getLogger()

# Set the log level
logger.setLevel(logging.DEBUG)

# Create a stream handler that writes to sys.stdout
stdout_handler = logging.StreamHandler(sys.stdout)

# Set the log format (optional)
formatter = logging.Formatter('%(levelname)s: %(message)s')
stdout_handler.setFormatter(formatter)

# Add the handler to the logger
logger.addHandler(stdout_handler)

# Test the logging output
logger.warning("This is a warning message.")

-- Example 29662
import streamlit as st st.warning("This is a warning message.")
st.write("This is a normal message.")
st.error("This is an error message.")

-- Example 29663
CREATE OR REPLACE FUNCTION get_secret_type()
  RETURNS STRING
  LANGUAGE JAVA
  HANDLER = 'SecretTest.getSecretType'
  EXTERNAL_ACCESS_INTEGRATIONS = (external_access_integration)
  PACKAGES = ('com.snowflake:snowpark:latest')
  SECRETS = ('cred' = oauth_token )
  AS
  $$
  import com.snowflake.snowpark_java.types.SnowflakeSecrets;

  public class SecretTest {
    public static String getSecretType() {
      SnowflakeSecrets sfSecrets = SnowflakeSecrets.newInstance();

      String secretType = sfSecrets.getSecretType("cred");

      return secretType;
    }
  }
  $$;

-- Example 29664
CREATE OR REPLACE FUNCTION get_secret_type()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'get_secret'
  EXTERNAL_ACCESS_INTEGRATIONS = (external_access_integration)
  SECRETS = ('cred' = oauth_token )
  AS
$$
import _snowflake

def get_secret():
  secret_type = _snowflake.get_secret_type('cred')
  return secret_type
$$;

-- Example 29665
CREATE OR REPLACE FUNCTION get_secret_username_password()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'get_secret_username_password'
  EXTERNAL_ACCESS_INTEGRATIONS = (external_access_integration)
  SECRETS = ('cred' = credentials_secret )
  AS
$$
import _snowflake

def get_secret_username_password():
  username_password_object = _snowflake.get_username_password('cred');

  username_password_dictionary = {}
  username_password_dictionary["Username"] = username_password_object.username
  username_password_dictionary["Password"] = username_password_object.password

  return username_password_dictionary
$$;

-- Example 29666
USE ROLE ACCOUNTADMIN;

GRANT IMPORT SHARE ON ACCOUNT TO SYSADMIN;

-- Example 29667
name: sf_env
channels:
- snowflake
dependencies:
- snowflake-native-apps-permission

-- Example 29668
import snowflake.permissions as permissions

-- Example 29669
privileges:
- CREATE DATABASE:
    description: "Creation of ingestion (required) and audit databases"

-- Example 29670
import streamlit as st
import snowflake.permissions as permissions
...
if not permissions.get_held_account_privileges(["CREATE DATABASE"]):
    st.error("The app needs CREATE DB privilege to replicate data")

-- Example 29671
references:
- servicenow_api_integration:
  label: "API INTEGRATION for ServiceNow communication"
  description: "An integration required in order to support extraction and visualization of ServiceNow data."
  privileges:
    - USAGE
  object_type: API Integration
  register_callback: config.register_reference

-- Example 29672
permissions.request_reference("servicenow_api_integration")

-- Example 29673
{
  "alias": "<value>",
  "database": "<value>",
  "schema": "<value>",
  "name": "<value>"
}

-- Example 29674
USE ROLE ACCOUNTADMIN;
GRANT VIEW LINEAGE ON ACCOUNT TO ROLE test_role;

-- Example 29675
registry.log_model(...,
          sample_input_data=df_backed_by_source_table)

-- Example 29676
model_version.lineage(direction="upstream")

-- Example 29677
my_dataset.lineage(direction="upstream", domain_filter=["feature_view"])

-- Example 29678
my_dataset.lineage(direction="downstream", domain_filter=["model"])

-- Example 29679
USE ROLE acxiom_admin_role;

-- Example 29680
GRANT APPLICATION ROLE <acxiom_app_database>.realid_app_role
  TO ROLE samooha_app_role;

-- Example 29681
USE ROLE acxiom_admin_role;

-- Example 29682
GRANT APPLICATION ROLE <acxiom_app_database>.realid_app_role TO ROLE samooha_app_role;

-- Example 29683
GRANT APPLICATION ROLE <merkury_app_database>.DCR_DB_ROLE TO ROLE samooha_app_role;

-- Example 29684
USE ROLE tu_admin_role;

-- Example 29685
GRANT APPLICATION ROLE <transunion_app_database>.tru_app_public
   TO ROLE SAMOOHA_APP_ROLE;

GRANT SELECT, INSERT
   ON TABLE SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS
   TO ROLE SAMOOHA_APP_ROLE;

-- Example 29686
USE ROLE ACCOUNTADMIN;

DESCRIBE PROCEDURE SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.GRANT_EXTERNAL_APP_ROLE;

-- Example 29687
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.GRANT_EXTERNAL_APP_ROLE(APP_ROLE string, APPLICATION string)
   RETURNS string
   LANGUAGE SQL
   EXECUTE AS OWNER
   AS
   $$
   GRANT APPLICATION ROLE IDENTIFIER(:APP_ROLE) TO APPLICATION IDENTIFIER(:APPLICATION);
   $$;

GRANT USAGE ON PROCEDURE SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.GRANT_EXTERNAL_APP_ROLE(string, string)
  TO ROLE SAMOOHA_APP_ROLE;

-- Example 29688
TRUNCATE SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS;

-- Example 29689
DELETE FROM SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS
  WHERE inputid IN ('123456', 'abcedf');

-- Example 29690
DELETE FROM SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS
  WHERE INPUTID IN (
    SELECT user_id as INPUTID
    FROM my_db.my_schema.ref_table
  );

-- Example 29691
INSERT INTO SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS (
  INPUTID,
  COLLABORATIONID,
  LASTPROCESSED
SELECT
  INPUTID,
  COLLABORATIONID,
  LASTPROCESSED
FROM <TRANSUNION_APPLICATION_DATABASE>.SHARE_SCHEMA.REF_MATCHING_OUTPUT_VIEW
WHERE BATCHID = '<BATCH_ID>';

-- Example 29692
MERGE INTO SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS CT
USING <TRANSUNION_APPLICATION_DATABASE>.SHARE_SCHEMA.REF_MATCHING_OUTPUT_VIEW OT
  ON
    CT.INPUTID = OT.INPUTID
    AND OT.BATCHID = '<BATCH_ID>'
WHEN MATCHED THEN
  UPDATE SET
    CT.COLLABORATIONID = OT.COLLABORATIONID,
    CT.LASTPROCESSED = OT.LASTPROCESSED
WHEN NOT MATCHED THEN
  INSERT (
    INPUTID,
    COLLABORATIONID,
    LASTPROCESSED
  ) VALUES (
      OT.INPUTID,
      OT.COLLABORATIONID,
      OT.LASTPROCESSED
  );

-- Example 29693
INSERT INTO SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.SAMOOHA_INTERNAL_TRANSUNION_ID_GENERATION_RECORDS (
  INPUTID,
  COLLABORATIONID,
  LASTPROCESSED
)
  SELECT
    INPUTID,
    COLLABORATIONID,
    LASTPROCESSED
  FROM <TRANSUNION_APPLICATION_DATABASE>.SHARE_SCHEMA.REF_MATCHING_OUTPUT_VIEW
  WHERE INPUTID IN (
    SELECT <column_name_containing_input_ids_to_be_added> as INPUTID
    FROM <dataset_fqtn_containing_input_ids_to_be_added>
    )
    AND BATCHID = '<BATCH_ID>';

-- Example 29694
CREATE OR REPLACE WAREHOUSE snowpark_opt_wh WITH
  WAREHOUSE_SIZE = 'MEDIUM'
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED';

-- Example 29695
CREATE WAREHOUSE so_warehouse WITH
  WAREHOUSE_SIZE = 'LARGE'
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
  RESOURCE_CONSTRAINT = 'MEMORY_16X_X86';

-- Example 29696
from snowflake.core import CreateMode
from snowflake.core.warehouse import Warehouse

my_wh = Warehouse(
  name="snowpark_opt_wh",
  warehouse_size="MEDIUM",
  warehouse_type="SNOWPARK-OPTIMIZED"
)
root.warehouses.create(my_wh, mode=CreateMode.or_replace)

-- Example 29697
ALTER WAREHOUSE snowpark_opt_wh SUSPEND;

-- Example 29698
root.warehouses["snowpark_opt_wh"].suspend()

-- Example 29699
ALTER WAREHOUSE so_warehouse SET
  RESOURCE_CONSTRAINT = 'MEMORY_1X_x86';

-- Example 29700
CREATE COMPUTE POOL IF NOT EXISTS mypool
    MIN_NODES = 2
    MAX_NODES = 4
    INSTANCE_FAMILY = 'CPU_X64_M'
    AUTO_RESUME = TRUE;

-- Example 29701
CREATE IMAGE REPOSITORY IF NOT EXISTS my_inference_images

-- Example 29702
GRANT READ ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;
GRANT WRITE ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;
GRANT SERVICE READ ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;
GRANT SERVICE WRITE ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;

-- Example 29703
# reg is a snowflake.ml.registry.Registry object
reg.log_model(
    model_name="my_model",
    version_name="v1",
    model=model,
    conda_dependencies=["conda-forge::scikit-learn"])

-- Example 29704
# mv is a snowflake.ml.model.ModelVersion object
mv.create_service(service_name="myservice",
                  service_compute_pool="my_compute_pool",
                  image_repo="mydb.myschema.my_image_repo",
                  ingress_enabled=True,
                  gpu_requests=None)

-- Example 29705
# Train a model using Snowpark ML
from snowflake.ml.modeling.xgboost import XGBRegressor
regressor = XGBRegressor(...)
regressor.fit(training_df)

# Extract the native model
xgb_model = regressor.to_xgboost()
# Test the model with pandas dataframe
pandas_test_df = test_df.select(['FEATURE1', 'FEATURE2', ...]).to_pandas()
xgb_model.predict(pandas_test_df)

# Log the model in Snowflake Model Registry
mv = reg.log_model(xgb_model,
                   model_name="my_native_xgb_model",
                   sample_input_data=pandas_test_df,
                   comment = 'A native XGB model trained from Snowflake Modeling API',
                   )
# Now we should be able to deploy to a GPU compute pool on SPCS
mv.create_service(
    service_name="my_service_gpu",
    service_compute_pool="my_gpu_pool",
    image_repo="my_repo",
    max_instances=1,
    gpu_requests="1",
)

-- Example 29706
-- See signature of the inference function in SQL.
SHOW FUNCTIONS IN MODEL my_native_xgb_model VERSION ...;

-- Call the inference function in SQL following the same signature (from `arguments` column of the above query)
SELECT MY_SERVICE!PREDICT(feature1, feature2, ...) FROM input_data_table;

-- Example 29707
# Get signature of the inference function in Python
# mv is a snowflake.ml.model.ModelVersion object
mv.show_functions()
# Call the function in Python
service_prediction = mv.run(
    test_df,
    function_name="predict",
    service_name="my_service")

-- Example 29708
SHOW ENDPOINTS IN SERVICE my_service;

-- Example 29709
ALTER SERVICE my_service SUSPEND;

-- Example 29710
from snowflake.ml.registry import registry
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions
from snowflake.snowpark import Session

from xgboost import XGBRegressor

# your model training code here output of which is a trained xgb_model

# Open model registry
reg = registry.Registry(session=session, database_name='my_registry_db', schema_name='my_registry_schema')

# Log the model in Snowflake Model Registry
model_ref = reg.log_model(
    model_name="my_xgb_forecasting_model",
    version_name="v1",
    model=xgb_model,
    conda_dependencies=["scikit-learn","xgboost"],
    sample_input_data=pandas_test_df,
    comment="XGBoost model for forecasting customer demand"
)

# Deploy the model to SPCS
model_ref.create_service(
    service_name="forecast_model_service",
    service_compute_pool="my_cpu_pool",
    image_repo="my_image_repo",
    ingress_enabled=True)

# See all services running a model
model_ref.list_services()

# Run on SPCS
model_ref.run(pandas_test_df, function_name="predict", service_name="forecast_model_service")

# Delete the service
model_ref.delete_service("forecast_model_service")

-- Example 29711
import json
import numpy as np
from pprint import pprint
import requests
import snowflake.connector

# Generate headers including authorization.
# This example uses session token authorization. Ideally key-pair authentication is used for API access.
def initiate_snowflake_connection():
    connection_parameters = SnowflakeLoginOptions("connection_name")
    connection_parameters["session_parameters"] = {"PYTHON_CONNECTOR_QUERY_RESULT_FORMAT": "json"}
    snowflake_conn = snowflake.connector.connect(**connection_parameters)
    return snowflake_conn

def get_headers(snowflake_conn):
    token = snowflake_conn._rest._token_request('ISSUE')
    headers = {'Authorization': f'Snowflake Token=\"{token["data"]["sessionToken"]}\"'}
    return headers

headers = get_headers(initiate_snowflake_connection())

# Put the endpoint url with method name `predict`
# The endpoint url can be found with `show endpoints in service <service_name>`.
URL = 'https://<random_str>-<organization>-<account>.snowflakecomputing.app/predict'

# Prepare data to be sent
data = {"data": np.column_stack([range(pandas_test_df.shape[0]), pandas_test_df.values]).tolist()}

# Send over HTTP
def send_request(data: dict):
    output = requests.post(URL, json=data, headers=headers)
    assert (output.status_code == 200), f"Failed to get response from the service. Status code: {output.status_code}"
    return output.content

# Test
results = send_request(data=data)
pprint(json.loads(results))

-- Example 29712
from snowflake.ml.registry import registry
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions
from snowflake.snowpark import Session
from sentence_transformers import SentenceTransformer

session = Session.builder.configs(SnowflakeLoginOptions("connection_name")).create()
reg = registry.Registry(session=session, database_name='my_registry_db', schema_name='my_registry_schema')

# Take an example sentence transformer from HF
embed_model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')

# Have some sample input data
input_data = [
    "This is the first sentence.",
    "Here's another sentence for testing.",
    "The quick brown fox jumps over the lazy dog.",
    "I love coding and programming.",
    "Machine learning is an exciting field.",
    "Python is a popular programming language.",
    "I enjoy working with data.",
    "Deep learning models are powerful.",
    "Natural language processing is fascinating.",
    "I want to improve my NLP skills.",
]

# Log the model with pip dependencies
pip_model = reg.log_model(
    embed_model,
    model_name="sentence_transformer_minilm",
    version_name="pip",
    sample_input_data=input_data,  # Needed for determining signature of the model
    pip_requirements=["sentence-transformers", "torch", "transformers"], # If you want to run this model in the Warehouse, you can use conda_dependencies instead
)

# Force Snowflake to not try to check warehouse
conda_forge_model = reg.log_model(
    embed_model,
    model_name="sentence_transformer_minilm",
    version_name="conda_forge_force",
    sample_input_data=input_data,
    # setting any package from conda-forge is sufficient to know that it can't be run in warehouse
    conda_dependencies=["sentence-transformers", "conda-forge::pytorch", "transformers"]
)

# Deploy the model to SPCS
pip_model.create_service(
    service_name="my_minilm_service",
    service_compute_pool="my_gpu_pool",  # Using GPU_NV_S - smallest GPU node that can run the model
    image_repo="my_image_repo",
    ingress_enabled=True,
    gpu_requests="1", # Model fits in GPU memory; only needed for GPU pool
    max_instances=4, # 4 instances were able to run 10M inferences from an XS warehouse
)

# See all services running a model
pip_model.list_services()

# Run on SPCS
pip_model.run(input_data, function_name="encode", service_name="my_minilm_service")

# Delete the service
pip_model.delete_service("my_minilm_service")

-- Example 29713
SELECT my_minilm_service!encode('This is a test sentence.');

-- Example 29714
import json
from pprint import pprint
import requests

# Put the endpoint url with method name `encode`
URL='https://<random_str>-<account>.snowflakecomputing.app/encode'

# Prepare data to be sent
data = {
    'data': []
}
for idx, x in enumerate(input_data):
    data['data'].append([idx, x])

# Send over HTTP
def send_request(data: dict):
    output = requests.post(URL, json=data, headers=headers)
    assert (output.status_code == 200), f"Failed to get response from the service. Status code: {output.status_code}"
    return output.content

# Test
results = send_request(data=data)
pprint(json.loads(results))

-- Example 29715
ALTER SERVICE myservice
    SET MIN_INSTANCES = <new_num>
        MAX_INSTANCES = <new_num>;

-- Example 29716
SHOW SERVICES IN COMPUTE POOL my_compute_pool;

-- Example 29717
CALL SYSTEM$GET_SERVICE_LOGS('MODEL_BUILD_xxxxx', 0, 'model-build');

-- Example 29718
CALL SYSTEM$GET_SERVICE_LOGS('MYSERVICE', 0, 'model-inference');

-- Example 29719
CREATE [ OR REPLACE ] TASK [ IF NOT EXISTS ] <name>
    WAREHOUSE = <string>
    [...]
    SUCCESS_INTEGRATION = <integration_name>

