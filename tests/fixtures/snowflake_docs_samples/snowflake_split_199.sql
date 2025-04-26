-- Example 13313
--!jinja2
{% from "macros.jinja" import get_environments %}

{%- set environments = get_environments(DEPLOYMENT_TYPE).split(",") -%}

{%- for environment in environments -%}
  CREATE DATABASE {{ environment }}_db;
  USE DATABASE {{ environment }}_db;
  CREATE TABLE {{ environment }}_orders (
    id NUMBER,
    item VARCHAR,
    quantity NUMBER);
  CREATE TABLE {{ environment }}_customers (
    id NUMBER,
    name VARCHAR);
{% endfor %}

-- Example 13314
CREATE STAGE my_stage;

-- Example 13315
PUT file://path/to/setup-env.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;
PUT file://path/to/macros.jinja @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 13316
EXECUTE IMMEDIATE FROM @my_stage/scripts/setup-env.sql
  USING (DEPLOYMENT_TYPE => 'prod') DRY_RUN = TRUE;

-- Example 13317
+----------------------------------+
| rendered file contents           |
|----------------------------------|
| --!jinja2                        |
| CREATE DATABASE prod1_db;        |
|   USE DATABASE prod1_db;         |
|   CREATE TABLE prod1_orders (    |
|     id NUMBER,                   |
|     item VARCHAR,                |
|     quantity NUMBER);            |
|   CREATE TABLE prod1_customers ( |
|     id NUMBER,                   |
|     name VARCHAR);               |
| CREATE DATABASE prod2_db;        |
|   USE DATABASE prod2_db;         |
|   CREATE TABLE prod2_orders (    |
|     id NUMBER,                   |
|     item VARCHAR,                |
|     quantity NUMBER);            |
|   CREATE TABLE prod2_customers ( |
|     id NUMBER,                   |
|     name VARCHAR);               |
|                                  |
+----------------------------------+

-- Example 13318
EXECUTE IMMEDIATE FROM @my_stage/scripts/setup-env.sql
  USING (DEPLOYMENT_TYPE => 'prod');

-- Example 13319
import logging

logger = logging.getLogger("mylog")

def test_logging(self):
    logger.info("This is an INFO test.")

-- Example 13320
import logging

logger = logging.getLogger("mylog")

def test_logging(self):
    logger.info("This is an INFO test.")

-- Example 13321
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| TIMESTAMP           | SCOPE                             | RESOURCE_ATTRIBUTES   | RECORD_TYPE | RECORD                       | VALUE                                                      |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | { "name": "python_logger" }       | **See excerpt below** | LOG         | { "severity_text": "INFO" }  | Logging from Python module.                                |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | { "name": "python_logger" }       | **See excerpt below** | LOG         | { "severity_text": "INFO" }  | Logging from Python function start.                        |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | { "name": "python_logger" }       | **See excerpt below** | LOG         | { "severity_text": "ERROR" } | Logging an error from Python handler.                      |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:12:55 | { "name": "ScalaLoggingHandler" } | **See excerpt below** | LOG         | { "severity_text": "INFO" }  | Logging from within the Scala constructor.                 |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:12:56 | { "name": "ScalaLoggingHandler" } | **See excerpt below** | LOG         | { "severity_text": "INFO" }  | Logging from Scala method start.                           |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:12:56 | { "name": "ScalaLoggingHandler" } | **See excerpt below** | LOG         | { "severity_text": "ERROR" } | Logging an error from Scala handler: Something went wrong. |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 13322
{
  ...
  "snow.executable.name": "ADD_TWO_NUMBERS(A FLOAT, B FLOAT):FLOAT"
  ...
}

{
  ...
  "snow.executable.name": "ADD_TWO_NUMBERS(A FLOAT, B FLOAT):FLOAT"
  ...
}

{
  ...
  "snow.executable.name": "ADD_TWO_NUMBERS(A FLOAT, B FLOAT):FLOAT"
  ...
}

{
  ...
  "snow.executable.name": "DO_LOGGING():VARCHAR(16777216)"
  ...
}

{
  ...
  "snow.executable.name": "DO_LOGGING():VARCHAR(16777216)"
  ...
}

{
  ...
  "snow.executable.name": "DO_LOGGING():VARCHAR(16777216)"
  ...
}

-- Example 13323
COLUMN_NAME['attribute_name']

-- Example 13324
SET event_table_name='my_db.public.my_event_table';

SELECT
  TIMESTAMP as time,
  RESOURCE_ATTRIBUTES['snow.executable.name'] as executable,
  RECORD['severity_text'] as severity,
  VALUE as message
FROM
  IDENTIFIER($event_table_name)
WHERE
  SCOPE['name'] = 'python_logger'
  AND RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%DO_LOGGING%'
  AND RECORD_TYPE = 'LOG';

-- Example 13325
----------------------------------------------------------------------------------------------------------------
| TIME                | EXECUTABLE                       | SEVERITY   | MESSAGE                                |
----------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "DO_LOGGING():VARCHAR(16777216)" | "INFO"     | "Logging from Python module."          |
----------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "DO_LOGGING():VARCHAR(16777216)" | "INFO"     | "Logging from Python function start."  |
----------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "DO_LOGGING():VARCHAR(16777216)" | "ERROR"    | "Logging an error from Python handler" |
----------------------------------------------------------------------------------------------------------------

-- Example 13326
SET EVENT_TABLE_NAME='my_db.public.my_events';

SELECT TIMESTAMP, RESOURCE_ATTRIBUTES['snow.executable.name'] AS FUNCTION_NAME, RECORD['METRIC']['NAME']AS METRIC_NAME, VALUE
FROM EVENT_TABLE_NAME
WHERE
  RESOURCE_ATTRIBUTES['snow.query.id']  = <INSERT YOUR QUERY ID>
  AND RECORD_TYPE = 'METRIC'
ORDER BY TIMESTAMP DESC;

-- Example 13327
CREATE OR REPLACE PROCEDURE do_tracing()
RETURNS VARIANT
LANGUAGE PYTHON
PACKAGES=('snowflake-snowpark-python', 'snowflake-telemetry-python')
RUNTIME_VERSION = 3.9
HANDLER='run'
AS $$
from snowflake import telemetry
def run(session):
  telemetry.set_span_attribute("example.proc.do_tracing", "begin")
  telemetry.add_event("event_with_attributes", {"example.key1": "value1", "example.key2": "value2"})
  return "SUCCESS"
$$;

-- Example 13328
CREATE OR REPLACE PROCEDURE do_tracing()
RETURNS VARIANT
LANGUAGE PYTHON
PACKAGES=('snowflake-snowpark-python', 'snowflake-telemetry-python')
RUNTIME_VERSION = 3.9
HANDLER='run'
AS $$
from snowflake import telemetry
def run(session):
  telemetry.set_span_attribute("example.proc.do_tracing", "begin")
  telemetry.add_event("event_with_attributes", {"example.key1": "value1", "example.key2": "value2"})
  return "SUCCESS"
$$;

-- Example 13329
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| TIMESTAMP          | START_TIMESTAMP    | RESOURCE_ATTRIBUTES   | RECORD_TYPE | RECORD                                                                                                  | RECORD_ATTRIBUTES                                                           |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | 2023-04-20 0:45:49 | **See excerpt below** | SPAN        | { "kind": "SPAN_KIND_INTERNAL", "name": "digits_of_number", "status": { "code": "STATUS_CODE_UNSET" } } |                                                                             |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 |                    |                       | SPAN_EVENT  | { "name": "test_udtf_init" }                                                                            |                                                                             |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 |                    |                       | SPAN_EVENT  | { "name": "test_udtf_process" }                                                                         | { "input": "42" }                                                           |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 |                    |                       | SPAN_EVENT  | { "name": "test_udtf_end_partition" }                                                                   |                                                                             |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:46:00 | 2023-04-20 0:46:00 |                       | SPAN        | { "kind": "SPAN_KIND_INTERNAL", "name": "times_two", "status": { "code": "STATUS_CODE_UNSET" } }        | { "example.func.times_two": "begin", "example.func.times_two.response": 8 } |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:46:00 |                    |                       | SPAN_EVENT  | { "name": "event_without_attributes" }                                                                  |                                                                             |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:46:00 |                    |                       | SPAN_EVENT  | { "name": "event_with_attributes" }                                                                     | { "example.key1": "value1", "example.key2": "value2" }                      |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:46:08 | 2023-04-20 0:46:08 |                       | SPAN        | { "kind": "SPAN_KIND_INTERNAL", "name": "do_tracing", "status": { "code": "STATUS_CODE_UNSET" } }       | { "example.proc.do_tracing": "begin" }                                      |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:46:08 |                    |                       | SPAN_EVENT  | { "name": "event_with_attributes" }                                                                     | { "example.key1": "value1", "example.key2": "value2" }                      |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 13330
{
  ...
  "snow.executable.name": "DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER)",
  "snow.executable.type": "FUNCTION",
  ...
}

{
  ...
  "snow.executable.name": "TIMES_TWO(X NUMBER):NUMBER(38,0)",
  "snow.executable.type": "FUNCTION",
  ...
}

{
  ...
  "snow.executable.name": "DO_TRACING():VARIANT",
  "snow.executable.type": "PROCEDURE",
  ...
}

-- Example 13331
COLUMN_NAME['attribute_name']

-- Example 13332
SET EVENT_TABLE_NAME='my_db.public.my_events';

SELECT
  TIMESTAMP as time,
  RESOURCE_ATTRIBUTES['snow.executable.name'] as handler_name,
  RESOURCE_ATTRIBUTES['snow.executable.type'] as handler_type,
  RECORD['name'] as event_name,
  RECORD_ATTRIBUTES as attributes
FROM
  IDENTIFIER($event_table_name)
WHERE
  RECORD_TYPE = 'SPAN_EVENT'
  AND HANDLER_NAME LIKE 'DIGITS_OF_NUMBER%';

-- Example 13333
-------------------------------------------------------------------------------------------------------------------------------------------
| TIME               | HANDLER_NAME                                          | HANDLER_TYPE | EVENT_NAME              | ATTRIBUTES        |
-------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER) | FUNCTION     | test_udtf_init          |                   |
-------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER) | FUNCTION     | test_udtf_process       | { "input": "42" } |
-------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER) | FUNCTION     | test_udtf_end_partition |                   |
-------------------------------------------------------------------------------------------------------------------------------------------

-- Example 13334
GRANT MODIFY LOG LEVEL ON ACCOUNT TO ROLE central_log_admin;

-- Example 13335
-- Set the log level on the account
ALTER ACCOUNT SET LOG_LEVEL = ERROR;

-- Example 13336
GRANT MODIFY LOG LEVEL ON ACCOUNT TO ROLE central_log_admin;
GRANT MODIFY ON DATABASE db1 TO ROLE central_log_admin;

-- Example 13337
USE ROLE central_log_admin;

-- Set the log levels on a database and UDF.
ALTER DATABASE db1 SET LOG_LEVEL = ERROR;
ALTER FUNCTION f1(int) SET LOG_LEVEL = WARN;

-- Example 13338
GRANT MODIFY SESSION LOG LEVEL ON ACCOUNT TO ROLE developer_debugging;

-- Example 13339
USE ROLE developer_debugging;

-- Set the logging level to DEBUG for the current session.
ALTER SESSION SET LOG_LEVEL = DEBUG;

-- Example 13340
ALTER ACCOUNT SET LOG_LEVEL = FATAL;

ALTER FUNCTION MyJavaUDF SET LOG_LEVEL = INFO;

-- The INFO log level is used because the FUNCTION MYJAVAUDF
-- is lower than the ACCOUNT in the hierarchy.

-- Example 13341
CREATE OR REPLACE FUNCTION customSpansPythonExample() RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-telemetry-python', 'opentelemetry-api')
HANDLER = 'custom_spans_function'
AS $$
from snowflake import telemetry
from opentelemetry import trace

def custom_spans_function():
  tracer = trace.get_tracer("my.tracer")
  with tracer.start_as_current_span("my.span") as span:
    span.add_event("Event2 in custom span", {"key1": "value1", "key2": "value2"})

  return "success"
$$;

-- Example 13342
import pickle
import pandas as pd
from snowflake.ml.model import custom_model

# Initialize ModelContext with keyword arguments
# my_model can be any supported model type
# my_file_path is a local pickle file path
model_context = custom_model.ModelContext(
    my_model=my_model,
    my_file_path='/path/to/file.pkl',
)

# Define a custom model class that utilizes the context
class ExampleBringYourOwnModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)

        # Use 'my_file_path' key from the context to load the pickled object
        with open(self.context['my_file_path'], 'rb') as f:
            self.obj = pickle.load(f)

    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        # Use the model with key 'my_model' from the context to make predictions
        model_output = self.context['my_model'].predict(input)
        return pd.DataFrame({'output': model_output})

# Instantiate the custom model with the model context. This instance can be logged in the model registry.
my_model = ExampleBringYourOwnModel(model_context)

-- Example 13343
my_model = ExampleBringYourOwnModel(model_context)
output_df = my_model.predict(input_df)

-- Example 13344
reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")
mv = reg.log_model(my_model,
            model_name="my_custom_model",
            version_name="v1",
            conda_dependencies=["scikit-learn"],
            comment="My Custom ML Model",
            sample_input_data=train_features)
output_df = mv.run(input_df)

-- Example 13345
pycaret_model_context = custom_model.ModelContext(
  model_file = 'pycaret_best_model.pkl',
)

-- Example 13346
from pycaret.classification import load_model, predict_model

class PyCaretModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)
        model_dir = self.context["model_file"][:-4]  # Remove '.pkl' suffix
        self.model = load_model(model_dir, verbose=False)
        self.model.memory = '/tmp/'  # Update memory directory

    @custom_model.inference_api
    def predict(self, X: pd.DataFrame) -> pd.DataFrame:
        model_output = predict_model(self.model, data=X)
        return pd.DataFrame({
            "prediction_label": model_output['prediction_label'],
            "prediction_score": model_output['prediction_score']
        })

-- Example 13347
test_data = [
    [1, 237, 1, 1.75, 1.99, 0.00, 0.00, 0, 0, 0.5, 1.99, 1.75, 0.24, 'No', 0.0, 0.0, 0.24, 1],
    # Additional test rows...
]
col_names = ['Id', 'WeekofPurchase', 'StoreID', 'PriceCH', 'PriceMM', 'DiscCH', 'DiscMM',
            'SpecialCH', 'SpecialMM', 'LoyalCH', 'SalePriceMM', 'SalePriceCH',
            'PriceDiff', 'Store7', 'PctDiscMM', 'PctDiscCH', 'ListPriceDiff', 'STORE']

test_df = pd.DataFrame(test_data, columns=col_names)

my_pycaret_model = PyCaretModel(pycaret_model_context)
output_df = my_pycaret_model.predict(test_df)

-- Example 13348
predict_signature = model_signature.infer_signature(input_data=test_df, output_data=output_df)

-- Example 13349
snowml_registry = Registry(session)

custom_mv = snowml_registry.log_model(
    my_pycaret_model,
    model_name="'my_pycaret_best_model",
    version_name="version_1",
    conda_dependencies=["pycaret==3.0.2", "scipy==1.11.4", "joblib==1.2.0"],
    options={"relax_version": False},
    signatures={"predict": predict_signature},
    comment = 'My PyCaret classification experiment using the CustomModel API'
)

-- Example 13350
snowml_registry.show_models()

-- Example 13351
snowpark_df = session.create_dataframe(test_data, schema=col_nms)

custom_mv.run(snowpark_df).show()

-- Example 13352
SELECT
    my_pycaret_model!predict(*) AS predict_dict,
    predict_dict['prediction_label']::text AS prediction_label,
    predict_dict['prediction_score']::double AS prediction_score
from pycaret_input_data;

-- Example 13353
from sklearn import datasets, svm
import pandas as pd
from snowflake.ml.model import custom_model

# Step 1: Import the Iris dataset
iris_X, iris_y = datasets.load_iris(return_X_y=True)

# Step 2: Initialize a scikit-learn LinearSVC model and train it
svc = svm.LinearSVC()
svc.fit(iris_X, iris_y)

# Step 3: Initialize ModelContext with keyword arguments
mc = custom_model.ModelContext(
    my_model=svc,
)

# Step 4: Define a custom model class to utilize the context
class ExampleSklearnModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)

    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        # Use the model from the context for predictions
        model_output = self.context['my_model'].predict(input)
        # Return the predictions in a DataFrame
        return pd.DataFrame({'output': model_output})

-- Example 13354
from sklearn import datasets
from sklearn.svm import SVC
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.impute import SimpleImputer
import pandas as pd
from snowflake.ml.model import custom_model

# Step 1: Load the Iris dataset
iris_X, iris_y = datasets.load_iris(return_X_y=True)

# Step 2: Create a scikit-learn pipeline
# The pipeline includes:
# - A SimpleImputer to handle missing values
# - A StandardScaler to standardize the data
# - A Support Vector Classifier (SVC) for predictions
pipeline = Pipeline([
    ('imputer', SimpleImputer(strategy='mean')),
    ('scaler', StandardScaler()),
    ('classifier', SVC(kernel='linear', probability=True))
])

# Step 3: Fit the pipeline to the dataset
pipeline.fit(iris_X, iris_y)

# Step 4: Initialize ModelContext with the pipeline
mc = custom_model.ModelContext(
    pipeline_model=pipeline,
)

# Step 5: Define a custom model class to utilize the pipeline
class ExamplePipelineModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)

    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        # Use the pipeline from the context to process input and make predictions
        predictions = self.context['pipeline_model'].predict(input)
        probabilities = self.context['pipeline_model'].predict_proba(input)

        # Return predictions and probabilities as a DataFrame
        return pd.DataFrame({
            'predictions': predictions,
            'probability_class_0': probabilities[:, 0],
            'probability_class_1': probabilities[:, 1]
        })

# Example usage:
# Convert new input data into a DataFrame
new_input = pd.DataFrame(iris_X[:5])  # Using the first 5 samples for demonstration

# Initialize the custom model and run predictions
custom_pipeline_model = ExamplePipelineModel(context=mc)
result = custom_pipeline_model.predict(new_input)

print(result)

-- Example 13355
mc = custom_model.ModelContext(
    my_model=your_own_model,
)

from snowflake.ml.model import custom_model
import pandas as pd
import json

class ExampleYourOwnModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)

    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        model_output = self.context['my_model'].predict(features)
        return pd.DataFrame({'output': model_output})

-- Example 13356
mc = custom_model.ModelContext(
    model1=model1,
    model2=model2,
    feature_preproc=preproc
    }
)

-- Example 13357
from snowflake.ml.model import custom_model
import pandas as pd
import json

class ExamplePipelineModel(custom_model.CustomModel):

    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        ...
        return pd.DataFrame(...)


# Here is the fully-functional custom model that uses both model1 and model2
class ExamplePipelineModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)

    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        features = self.context['feature_preproc'].transform(input)
        model_output = self.context['model1'].predict(
            self.context['model2'].predict(features)
        )
        return pd.DataFrame({'output': model_output})

-- Example 13358
import pandas as pd

from snowflake.ml.model import custom_model

class ExamplePartitionedModel(custom_model.CustomModel):

  @custom_model.partitioned_inference_api
  def predict(self, input: pd.DataFrame) -> pd.DataFrame:
      # All data in the partition will be loaded in the input dataframe.
      #… implement model logic here …
      return output_df

my_model = ExamplePartitionedModel()

-- Example 13359
from snowflake.ml.registry import Registry

reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")
model_version = reg.log_model(my_model,
  model_name="my_model",
  version_name="v1",
  options={"function_type": "TABLE_FUNCTION"},    ###
  conda_dependencies=["scikit-learn"],
  sample_input_data=train_features
)

-- Example 13360
model_version = reg.log_model(my_model,
    model_name="my_model",
    version_name="v1",
    options={
      "method_options": {                                 ###
        "METHOD1": {"function_type": "TABLE_FUNCTION"},   ###
        "METHOD2": {"function_type": "FUNCTION"}          ###
      }
    }
    conda_dependencies=["scikit-learn"],
    sample_input_data=train_features
)

-- Example 13361
model_version.run(
  input_df,
  function_name="PREDICT",
  partition_column="STORE_NUMBER"
)

-- Example 13362
SELECT output1, output2, partition_column
  FROM input_table,
      TABLE(
          my_model!predict(input_table.input1, input_table.input2)
          OVER (PARTITION BY input_table.store_number)
      )
  ORDER BY input_table.store_number;

-- Example 13363
class ExampleStatelessPartitionedModel(custom_model.CustomModel):

  @custom_model.partitioned_inference_api
  def predict(self, input_df: pd.DataFrame) -> pd.DataFrame:
      import xgboost
      # All data in the partition will be loaded in the input dataframe.
      # Construct training data by transforming input_df.
      training_data = # ...

      # Train the model.
      my_model = xgboost.XGBRegressor()
      my_model.fit(training_data)

      # Generate predictions.
      output_df = my_model.predict(...)

      return output_df

my_model = ExampleStatelessPartitionedModel()

-- Example 13364
from snowflake.ml.model import custom_model

# `models` is a dict with model ids as keys, and fitted xgboost models as values.
models = {
  "model1": models[0],
  "model2": models[1],
  ...
}

model_context = custom_model.ModelContext(
  models=models
)
my_stateful_model = MyStatefulCustomModel(model_context=model_context)

-- Example 13365
class ExampleStatefulModel(custom_model.CustomModel):

  @custom_model.inference_api
  def predict(self, input: pd.DataFrame) -> pd.DataFrame:
    model1 = self.context.model_ref("model1")
    # ... use model1 for inference

-- Example 13366
class ExampleStatefulModel(custom_model.CustomModel):

  @custom_model.inference_api
  def predict(self, input: pd.DataFrame) -> pd.DataFrame:
    model_id = input["MY_PARTITION_COLUMN"][0]
    model = self.context.model_ref(model_id)
    # ... use model for inference

-- Example 13367
import pandas as pd
from sklearn import svm, datasets

from snowflake.ml.model import model_signature

digits = datasets.load_digits()
target_digit = 6

def one_vs_all(dataset, digit):
    return [x == digit for x in dataset]

train_features = digits.data[:10]
train_labels = one_vs_all(digits.target[:10], target_digit)
clf = svm.SVC(gamma=0.001, C=10.0, probability=True)
clf.fit(train_features, train_labels)

sig = model_signature.infer_signature(
    train_features,
    labels_df,
    input_feature_names=['column1', 'column2', ...],
    output_feature_names=['is_target_digit'])

# Supply a signature for every function the model exposes, in this case only `predict`.
mv = reg.log_model(
    clf,
    model_name='my_model',
    version_name='v1',
    signatures={"predict": sig}
)

-- Example 13368
from snowflake.ml.model.model_signature import ModelSignature, FeatureSpec, DataType

sig = ModelSignature(
    inputs=[
        FeatureSpec(dtype=DataType.DOUBLE, name=f_0),
        FeatureSpec(dtype=DataType.INT64, name=sparse_0_fixed_len, shape=(5, 5)),
        FeatureSpec(dtype=DataType.INT64, name=sparse_1_variable_len, shape=(-1,)),
    ],
    outputs=[
        FeatureSpec(dtype=DataType.FLOAT, name=output),
    ]
)

-- Example 13369
GRANT USAGE ON MODEL my_model TO ROLE prod_role;

-- Example 13370
ALTER MODEL my_model MODIFY VERSION v1
    SET METADATA = '{"metric": {"accuracy": 0.769}}';

-- Example 13371
mv = reg.get_model("my_model").version("v1").set_metric("accuracy", 0.769)

-- Example 13372
SELECT
    catalog_name,
    schema_name,
    model_name,
    model_version_name,
    metadata:metric:accuracy AS accuracy,
    comment,
    owner,
    functions,
    created_on,
    last_altered_on
FROM my_database.INFORMATION_SCHEMA.MODEL_VERSIONS
ORDER BY accuracy DESC;

-- Example 13373
GRANT USAGE ON MODEL my_model TO ROLE prod_role;

-- Example 13374
ALTER MODEL my_model SET DEFAULT_VERSION = new_version;

-- Example 13375
SELECT my_model!predict(...) ... ;

-- Example 13376
WITH my_version AS MODEL my_model VERSION new_version
    SELECT my_version!predict(...) ...;

-- Example 13377
GRANT USAGE ON MODEL my_model TO ROLE prod_role;

-- Example 13378
ALTER MODEL my_model VERSION v1 SET ALIAS = production;

-- Example 13379
ALTER MODEL my_model VERSION v2 SET ALIAS = alpha;

