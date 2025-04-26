-- Example 13380
ALTER MODEL my_model VERSION v2 UNSET ALIAS;
ALTER MODEL my_model VERSION v2 SET ALIAS = beta;

-- Example 13381
ALTER MODEL my_model VERSION v1 UNSET ALIAS;
ALTER MODEL my_model VERSION v2 UNSET ALIAS;
ALTER MODEL my_model VERSION v2 SET ALIAS = production;

-- Example 13382
WITH my_version AS MODEL my_model VERSION production
    SELECT my_version!predict(...) ...;

-- Example 13383
WITH my_version AS MODEL my_model VERSION alpha
    SELECT my_version!predict(...) ...;

-- Example 13384
GRANT USAGE ON MODEL my_model TO ROLE prod_role;

-- Example 13385
USE ROLE ACCOUNTADMIN;
GRANT APPLY TAG ON ACCOUNT ON MODEL my_model TO ROLE prod_role;
GRANT USAGE ON SCHEMA model_database.model_schema TO ROLE prod_role;

-- Example 13386
USE ROLE prod_role;
USE SCHEMA prod_db.prod_schema;

CREATE TAG live_version;

-- Example 13387
USE ROLE prod_role;
USE SCHEMA prod_db.prod_schema;

ALTER MODEL model_database.model_schema.my_model
    SET TAG live_version = 'V1';

-- Example 13388
USE ROLE prod_role;

ALTER MODEL model_database.model_schema.my_model
    SET TAG prod_db.prod_schema.live_version = 'V2';

-- Example 13389
-- get production model version from live_version tag
SET live_version = (SELECT
    SYSTEM$GET_TAG('prod_db.prod_schema.live_version', 'my_model', 'MODULE'));

-- call that version
WITH my_version AS MODEL my_model VERSION IDENTIFIER($live_version)
    SELECT my_version!predict(...) ... ;

-- Example 13390
USE ROLE ACCOUNTADMIN;
CREATE ROLE ml_admin;

USE ROLE model_owner;
GRANT ROLE model_owner TO ROLE ml_admin;

USE ROLE prod_role;
GRANT ROLE prod_role TO ROLE ml_admin;

-- Example 13391
USE ROLE ml_admin;

CREATE MODEL prod_db.prod_schema.prod_model WITH VERSION V1
    FROM MODEL dev_db.dev_sch.dev_model VERSION V12;

-- Example 13392
USE ROLE ml_admin;

GRANT USAGE ON MODEL my_model TO ROLE prod_role;

-- Example 13393
USE ROLE ml_admin;

ALTER MODEL prod_db.prod_schema.prod_model ADD VERSION V2
    FROM MODEL dev_db.dev_schema.dev_model VERSION V24;

ALTER MODEL prod_db.prod_schema.prod_model
    SET DEFAULT_VERSION = V2;

-- Example 13394
ALTER MODEL prod_db.prod_schema.prod_model SET DEFAULT_VERSION = V1;

-- Example 13395
SELECT prod_model!predict(...) ... ;

-- Example 13396
remote_prediction = mv.run(test_features, function_name="predict")
remote_prediction.show()   # assuming test_features is Snowpark DataFrame

-- Example 13397
SELECT <model_name>!<method_name>(...) FROM <table_name>;

-- Example 13398
WITH <model_version_alias> AS MODEL <model_name> VERSION <version_or_alias_name>
    SELECT <model_version_alias>!<method_name>(...) FROM <table_name>;

-- Example 13399
WITH latest AS MODEL my_model VERSION LAST
    SELECT latest!predict(...) FROM my_table;

-- Example 13400
CREATE COMPUTE POOL IF NOT EXISTS mypool
    MIN_NODES = 2
    MAX_NODES = 4
    INSTANCE_FAMILY = 'CPU_X64_M'
    AUTO_RESUME = TRUE;

-- Example 13401
CREATE IMAGE REPOSITORY IF NOT EXISTS my_inference_images

-- Example 13402
GRANT READ ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;
GRANT WRITE ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;
GRANT SERVICE READ ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;
GRANT SERVICE WRITE ON IMAGE REPOSITORY my_inference_images TO ROLE myrole;

-- Example 13403
# reg is a snowflake.ml.registry.Registry object
reg.log_model(
    model_name="my_model",
    version_name="v1",
    model=model,
    conda_dependencies=["conda-forge::scikit-learn"])

-- Example 13404
# mv is a snowflake.ml.model.ModelVersion object
mv.create_service(service_name="myservice",
                  service_compute_pool="my_compute_pool",
                  image_repo="mydb.myschema.my_image_repo",
                  ingress_enabled=True,
                  gpu_requests=None)

-- Example 13405
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

-- Example 13406
-- See signature of the inference function in SQL.
SHOW FUNCTIONS IN MODEL my_native_xgb_model VERSION ...;

-- Call the inference function in SQL following the same signature (from `arguments` column of the above query)
SELECT MY_SERVICE!PREDICT(feature1, feature2, ...) FROM input_data_table;

-- Example 13407
# Get signature of the inference function in Python
# mv is a snowflake.ml.model.ModelVersion object
mv.show_functions()
# Call the function in Python
service_prediction = mv.run(
    test_df,
    function_name="predict",
    service_name="my_service")

-- Example 13408
SHOW ENDPOINTS IN SERVICE my_service;

-- Example 13409
ALTER SERVICE my_service SUSPEND;

-- Example 13410
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

-- Example 13411
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

-- Example 13412
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

-- Example 13413
SELECT my_minilm_service!encode('This is a test sentence.');

-- Example 13414
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

-- Example 13415
ALTER SERVICE myservice
    SET MIN_INSTANCES = <new_num>
        MAX_INSTANCES = <new_num>;

-- Example 13416
SHOW SERVICES IN COMPUTE POOL my_compute_pool;

-- Example 13417
CALL SYSTEM$GET_SERVICE_LOGS('MODEL_BUILD_xxxxx', 0, 'model-build');

-- Example 13418
CALL SYSTEM$GET_SERVICE_LOGS('MYSERVICE', 0, 'model-inference');

-- Example 13419
CREATE OR REPLACE DYNAMIC TABLE logins_with_predictions
    WAREHOUSE = my_wh
    TARGET_LAG = '20 minutes'
    REFRESH_MODE = INCREMENTAL
    INITIALIZE = on_create
    COMMENT = 'Dynamic table with continuously updated model predictions'
AS
WITH my_model AS MODEL ml.registry.mymodel
SELECT
    l.login_id,
    l.user_id,
    l.location,
    l.event_time,
    my_model!predict(l.user_id, l.location) AS prediction_result
FROM logins_raw l;

-- Example 13420
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col
from snowflake.ml.registry import Registry

# Initialize the registry
reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")

# Retrieve the default model version from the registry
model = reg.get_model("MYMODEL")

# Load the source data
df_raw = sp_session.table("LOGINS_RAW")

# Run inference on the necessary features
predictions_df = model.run(df_raw.select("USER_ID", "LOCATION"))

# Join predictions back to the source data
joined_df = df_raw.join(predictions_df, on=["USER_ID", "LOCATION"])

# Create or replace a dynamic table from the joined DataFrame
joined_df.create_or_replace_dynamic_table(
    name="LOGINS_WITH_PREDICTIONS",
    warehouse="MY_WH",
    lag='20 minutes',
    refresh_mode='INCREMENTAL',
    initiliaze="ON_CREATE",
    comment="Dynamic table continuously updated with model predictions"
)

-- Example 13421
USE ROLE ACCOUNTADMIN;
GRANT VIEW LINEAGE ON ACCOUNT TO ROLE test_role;

-- Example 13422
registry.log_model(...,
          sample_input_data=df_backed_by_source_table)

-- Example 13423
model_version.lineage(direction="upstream")

-- Example 13424
my_dataset.lineage(direction="upstream", domain_filter=["feature_view"])

-- Example 13425
my_dataset.lineage(direction="downstream", domain_filter=["model"])

-- Example 13426
mv = reg.log_model(
    catboost_model,
    model_name="diamond_catboost_explain_enabled",
    version_name="explain_v0",
    conda_dependencies=["snowflake-ml-python"],
    sample_input_data = xs, # xs will be used as background data
)

-- Example 13427
mv = reg.log_model(
    catboost_model,
    model_name="diamond_catboost_explain_enabled",
    version_name="explain_v0",
    conda_dependencies=["snowflake-ml-python"],
    signatures={"predict": predict_signature, "predict_proba": predict_proba_signature},
    sample_input_data = xs, # xs will be used as background data
    options= {"enable_explainability": True} # you will need to set this flag in order to pass both signatures and background data
)

-- Example 13428
reg = Registry(...)
mv = reg.get_model("Explainable_Catboost_Model").default
explanations = mv.run(input_data, function_name="explain")

-- Example 13429
WITH MV_ALIAS AS MODEL DATABASE.SCHEMA.DIAMOND_CATBOOST_MODEL VERSION EXPLAIN_V0
SELECT *,
      FROM DATABASE.SCHEMA.DIAMOND_DATA,
          TABLE(MV_ALIAS!EXPLAIN(CUT, COLOR, CLARITY, CARAT, DEPTH, TABLE_PCT, X, Y, Z));

-- Example 13430
mv_new = reg.log_model(
    model,
    model_name="model_with_explain_enabled",
    version_name="explain_v0",
    conda_dependencies=["snowflake-ml-python"],
    sample_input_data = xs,
    options={"relax_version": False}
)

-- Example 13431
mv_old = reg.get_model("model_without_explain_enabled").default
model = mv_old.load()
mv_new = reg.log_model(
    model,
    model_name="model_with_explain_enabled",
    version_name="explain_v0",
    conda_dependencies=["snowflake-ml-python"],
    sample_input_data = xs
)

-- Example 13432
mv = reg.log_model(
    catboost_model,
    model_name="diamond_catboost_explain_enabled",
    version_name="explain_v0",
    conda_dependencies=["snowflake-ml-python"],
    sample_input_data = xs,
    options= {"enable_explainability": False}
)

-- Example 13433
from snowflake.snowpark.context import get_active_session
from snowflake.ml.data.data_connector import DataConnector
import pandas as pd
import xgboost as xgb
from sklearn.model_selection import train_test_split

session = get_active_session()

# Use the DataConnector API to pull in large data efficiently
df = session.table("my_dataset")
pandas_df = DataConnector.from_dataframe(df).to_pandas()

# Build with open source

X = df_pd[['feature1', 'feature2']]
y = df_pd['label']

# Split data into test and train in memory
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=34)

# Train in memory
model = xgb.XGBClassifier()
model.fit(X_train, y_train)

# Predict
y_pred = model.predict(X_test)

-- Example 13434
spec:
  containers:                           # container list
  - name: <name>
    image: <image-name>
    command:                            # optional list of strings
      - <cmd>
      - <arg1>
    args:                               # optional list of strings
      - <arg2>
      - <arg3>
      - ...
    env:                                # optional
        <key>: <value>
        <key>: <value>
        ...
    readinessProbe:                     # optional
        port: <TCP port-num>
        path: <http-path>
    volumeMounts:                       # optional list
      - name: <volume-name>
        mountPath: <mount-path>
      - name: <volume-name>
        ...
    resources:                          # optional
        requests:
          memory: <amount-of-memory>
          nvidia.com/gpu: <count>
          cpu: <cpu-units>
        limits:
          memory: <amount-of-memory>
          nvidia.com/gpu: <count>
          cpu: <cpu-units>
    secrets:                                # optional list
      - snowflakeSecret:
          objectName: <object-name>         # specify this or objectReference
          objectReference: <reference-name> # specify this or objectName
        directoryPath: <path>               # specify this or envVarName
        envVarName: <name>                  # specify this or directoryPath
        secretKeyRef: username | password | secret_string # specify only with envVarName
  endpoints:                             # optional endpoint list
    - name: <name>
      port: <TCP port-num>                     # specify this or portRange
      portRange: <TCP port-num>-<TCP port-num> # specify this or port
      public: <true / false>
      protocol : < TCP / HTTP >
      corsSettings:                  # optional CORS configuration
        Access-Control-Allow-Origin: # required list of allowed origins, for example, "http://example.com"
          - <origin>
          - <origin>
            ...
        Access-Control-Allow-Methods: # optional list of HTTP methods
          - <method>
          - <method>
            ...
        Access-Control-Allow-Headers: # optional list of HTTP headers
          - <header-name>
          - <header-name>
            ...
        Access-Control-Expose-Headers: # optional list of HTTP headers
          - <header-name>
          - <header-name>
            ...
    - name: <name>
      ...
  volumes:                               # optional volume list
    - name: <name>
      source: local | @<stagename> | memory | block
      size: <bytes-of-storage>           # specify if memory or block is the volume source
      blockConfig:                       # optional
        initialContents:
          fromSnapshot: <snapshot-name>
        iops: <number-of-operations>
        throughput: <MiB per second>
      uid: <UID-value>                   # optional, only for stage volumes
      gid: <GID-value>                   # optional, only for stage volumes
    - name: <name>
      source: local | @<stagename> | memory | block
      size: <bytes-of-storage>           # specify if memory or block is the volume source
      ...
  logExporters:
    eventTableConfig:
      logLevel: <INFO | ERROR | NONE>
  platformMonitor:                      # optional, platform metrics to log to the event table
    metricConfig:
      groups:
      - <group-1>
      - <group-2>
      ...
capabilities:
  securityContext:
    executeAsCaller: <true / false>     # optional, indicates whether application intends to use caller’s rights
serviceRoles:                   # Optional list of service roles
- name: <service-role-name>
  endpoints:
  - <endpoint_name1>
  - <endpoint_name2>
  - ...
- ...

-- Example 13435
spec:
  containers:
    - name: echo
      image: /tutorial_db/data_schema/tutorial_repository/echo_service:dev

-- Example 13436
ENTRYPOINT ["python3", "main.py"]
CMD ["Bob"]

-- Example 13437
spec:
  containers:
  - name: echo
    image: <image_name>
    command:
    - python3.9
    - main.py

-- Example 13438
spec:
  containers:
  - name: echo
    image: <image_name>
    args:
      - Alice

-- Example 13439
spec:
  containers:
  - name: <name>
    image: <image_name>
    env:
      ENV_VARIABLE_1: <value1>
      ENV_VARIABLE_2: <value2>
      …
      …

-- Example 13440
CHARACTER_NAME = os.getenv('CHARACTER_NAME', 'I')
SERVER_PORT = os.getenv('SERVER_PORT', 8080)

-- Example 13441
spec:
  containers:
  - name: echo
    image: <image_name>
    env:
      CHARACTER_NAME: Bob
      SERVER_PORT: 8085
  endpoints:
  - name: echo-endpoint
    port: 8085

-- Example 13442
@app.get("/healthcheck")
def readiness_probe():

-- Example 13443
spec:
  containers:
  - name: echo
    image: <image_name>
    env:
      SERVER_PORT: 8088
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8088
      path: /healthcheck
  endpoints:
  - name: echo-endpoint
    port: 8088

-- Example 13444
spec:
  containers:
  - name: resource-test-gpu
    image: ...
    resources:
      requests:
        memory: 2G
        cpu: 0.5
        nvidia.com/gpu: 1
      limits:
        memory: 4G
        nvidia.com/gpu: 1

-- Example 13445
CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 2
  MAX_NODES = 2
  INSTANCE_FAMILY = gpu_nv_s

-- Example 13446
CREATE SERVICE echo_service
  MIN_INSTANCES=2
  MAX_INSTANCES=2
  IN COMPUTE POOL tutorial_compute_pool
  FROM @<stage_path>
  SPEC=<spec-file-stage-path>;

