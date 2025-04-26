-- Example 27311
CREATE OR REPLACE FUNCTION add_two_numbers(A FLOAT, B FLOAT) RETURNS FLOAT
  LANGUAGE JAVA
  PACKAGES=('com.snowflake:telemetry:latest')
  HANDLER = 'ScalarFunctionHandler.run'
  AS
  $$
  import com.snowflake.telemetry.Telemetry;
  import io.opentelemetry.api.common.AttributeKey;
  import io.opentelemetry.api.common.Attributes;
  import io.opentelemetry.api.common.AttributesBuilder;

  class ScalarFunctionHandler {

    public static Double run(Double d0, Double d1) {

      // Set span attribute.
      Telemetry.setSpanAttribute("example.func.add_two_numbers", "begin");

      // Add an event without attributes.
      Telemetry.addEvent("run_method_start");

      // Add an event with attributes.
      Attributes eventAttributes = Attributes.of(
        AttributeKey.stringKey("example.method.name"), "run",
        AttributeKey.longKey("example.long"), Long.valueOf(123));
      Telemetry.addEvent("event_with_attributes", eventAttributes);

      Double response = d0 == null || d1 == null ? null : (d0 + d1);

      // Set span attribute.
      Telemetry.setSpanAttribute("example.func.add_two_numbers.response", response);
      Telemetry.setSpanAttribute("example.func.add_two_numbers", "complete");

      return response;
    }
  }
  $$;

-- Example 27312
CREATE OR REPLACE FUNCTION digits_of_number(x int)
  RETURNS TABLE(result INT)
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:telemetry:latest')
  HANDLER = 'TableFunctionHandler'
  AS
  $$
  import com.snowflake.telemetry.Telemetry;
  import io.opentelemetry.api.common.AttributeKey;
  import io.opentelemetry.api.common.Attributes;
  import io.opentelemetry.api.common.AttributesBuilder;
  import java.util.stream.Stream;

  public class TableFunctionHandler {

    public TableFunctionHandler() {
      // Set span attribute.
      Telemetry.setSpanAttribute("example.func.digits_of_number", "begin");
    }

    static class OutputRow {
      public int result;

      public OutputRow(int result) {
        this.result = result;
      }
    }

    public static Class getOutputClass() {
      return OutputRow.class;
    }

    public Stream<OutputRow> process(int input) {

      // Add an event with attributes.
      Attributes eventAttributes = Attributes.of(
        AttributeKey.longKey("example.received.value"), Long.valueOf(input));
      Telemetry.addEvent("digits_of_number", eventAttributes);

      Stream.Builder<OutputRow> stream = Stream.builder();
      while (input > 0) {

        stream.add(new OutputRow(input %10));
        input /= 10;
      }

      // Set span attribute.
      Telemetry.setSpanAttribute("example.func.digits_of_number", "complete");

      return stream.build();
    }
  }
  $$;

-- Example 27313
snowflake.addEvent(name [, { key:value [, key:value] } ] );

-- Example 27314
create procedure PI_JS()
  returns double
  language javascript
  as
  $$
    snowflake.addEvent('name_a');  // add an event without attributes
    snowflake.addEvent('name_b', {'score': 89, 'pass': true});
    return 3.14;
  $$
  ;

-- Example 27315
{
  "name": "name_a"
}

-- Example 27316
{
  "name": "name_b"
}

-- Example 27317
{
  "score": 89,
  "pass": true
}

-- Example 27318
snowflake.setSpanAttribute(key, value);

-- Example 27319
// Setting span attributes.
snowflake.setSpanAttribute("example.boolean", true);
snowflake.setSpanAttribute("example.long", 2L);
snowflake.setSpanAttribute("example.double", 2.5);
snowflake.setSpanAttribute("example.string", "testAttribute");

-- Example 27320
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 27321
CREATE OR REPLACE FUNCTION javascript_custom_span()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
const { trace } = opentelemetry;
const tracer = trace.getTracer("example_tracer");
// Alternatively, const tracer = opentelemetry.trace.getTracer("example_tracer");

tracer.startActiveSpan("example_custom_span", (span) => {
  span.addEvent("testEventWithAttributes");
  span.setAttribute("testAttribute", "value");

  span.end();
});
$$;

-- Example 27322
CREATE OR REPLACE FUNCTION my_function(...)
  RETURNS ...
  LANGUAGE PYTHON
  ...
  PACKAGES = ('snowflake-telemetry-python')
  ...

-- Example 27323
from snowflake import telemetry

-- Example 27324
telemetry.add_event(<name>, <attributes>)

-- Example 27325
telemetry.add_event("FunctionEmptyEvent")
telemetry.add_event("FunctionEventWithAttributes", {"key1": "value1", "key2": "value2"})

-- Example 27326
{
  "name": "FunctionEmptyEvent"
}

-- Example 27327
{
  "name": "FunctionEventWithAttributes"
}

-- Example 27328
{
  "key1": "value1",
  "key2": "value2"
}

-- Example 27329
telemetry.set_span_attribute(<key>, <value>)

-- Example 27330
// Setting span attributes.
telemetry.set_span_attribute("example.boolean", true);
telemetry.set_span_attribute("example.long", 2);
telemetry.set_span_attribute("example.double", 2.5);
telemetry.set_span_attribute("example.string", "testAttribute");

-- Example 27331
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 27332
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

-- Example 27333
CREATE OR REPLACE PROCEDURE do_tracing()
  RETURNS VARIANT
  LANGUAGE PYTHON
  PACKAGES = ('snowflake-snowpark-python', 'snowflake-telemetry-python')
  RUNTIME_VERSION = 3.9
  HANDLER = 'run'
  AS $$
  from snowflake import telemetry
  def run(session):
    telemetry.set_span_attribute("example.proc.do_tracing", "begin")
    telemetry.add_event("event_with_attributes", {"example.key1": "value1", "example.key2": "value2"})
    return "SUCCESS"
  $$;

-- Example 27334
import streamlit as st
from snowflake import telemetry

st.title("Streamlit trace event example")

hifives_val = st.slider("Number of high-fives", min_value=0, max_value=90, value=60)

if st.button("Submit"):
    telemetry.add_event("new_submission", {"high_fives": hifives_val})

-- Example 27335
CREATE OR REPLACE FUNCTION times_two(x NUMBER)
  RETURNS NUMBER
  LANGUAGE PYTHON
  PACKAGES = ('snowflake-telemetry-python')
  RUNTIME_VERSION = 3.9
  HANDLER = 'times_two'
AS $$
from snowflake import telemetry
def times_two(x):
  telemetry.set_span_attribute("example.func.times_two", "begin")
  telemetry.add_event("event_without_attributes")
  telemetry.add_event("event_with_attributes", {"example.key1": "value1", "example.key2": "value2"})

  response = 2 * x

  telemetry.set_span_attribute("example.func.times_two.response", response)

  return response
$$;

-- Example 27336
select count(times_two(seq8())) from table(generator(rowcount => 50));

-- Example 27337
CREATE OR REPLACE FUNCTION digits_of_number(input NUMBER)
  RETURNS TABLE(result NUMBER)
  LANGUAGE PYTHON
  PACKAGES = ('snowflake-telemetry-python')
  RUNTIME_VERSION = 3.9
  HANDLER = 'TableFunctionHandler'
  AS
$$
from snowflake import telemetry

class TableFunctionHandler:

  def __init__(self):
    telemetry.add_event("test_udtf_init")

  def process(self, input):
    telemetry.add_event("test_udtf_process", {"input": str(input)})
    response = input

    while input > 0:
      response = input % 10
      input /= 10
      yield (response,)

  def end_partition(self):
    telemetry.add_event("test_udtf_end_partition")
$$;

-- Example 27338
select * from table(generator(rowcount => 50)), table(digits_of_number(seq8())) order by 1;

-- Example 27339
CREATE OR REPLACE PROCEDURE myproc(...)
  RETURNS ...
  LANGUAGE SCALA
  ...
  PACKAGES = ('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
  ...

-- Example 27340
import com.snowflake.telemetry.Telemetry

-- Example 27341
public static void addEvent(String name)
public static void addEvent(String name, Attributes attributes)

-- Example 27342
// Adding an event without attributes.
Telemetry.addEvent("testEvent")

// Adding an event with attributes.
Attributes eventAttributes = Attributes.of(
  AttributeKey.stringKey("key"), "run",
  AttributeKey.longKey("result"), Long.valueOf(123))
Telemetry.addEvent("testEventWithAttributes", eventAttributes)

-- Example 27343
{
  "name": "testEvent"
}

-- Example 27344
{
  "name": "testEventWithAttributes"
}

-- Example 27345
{
  "key": "run",
  "result": 123
}

-- Example 27346
public static void setSpanAttribute(String key, boolean value)
public static void setSpanAttribute(String key, long value)
public static void setSpanAttribute(String key, double value)
public static void setSpanAttribute(String key, String value)

-- Example 27347
// Setting span attributes.
Telemetry.setSpanAttribute("example.boolean", true)
Telemetry.setSpanAttribute("example.long", 2L)
Telemetry.setSpanAttribute("example.double", 2.5)
Telemetry.setSpanAttribute("example.string", "testAttribute")

-- Example 27348
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 27349
CREATE OR REPLACE FUNCTION testScalaUserSpans(x VARCHAR) RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  PACKAGES = ('com.snowflake:telemetry:latest')
  HANDLER = 'TestScalaClass.run'
  AS
  $$
  class TestScalaClass {
    import com.snowflake.telemetry.Telemetry
    import io.opentelemetry.api.GlobalOpenTelemetry
    import io.opentelemetry.api.trace.Tracer
    import io.opentelemetry.api.trace.Span
    import io.opentelemetry.context.Scope

    def run(x: String): String = {
      val tracer: Tracer = GlobalOpenTelemetry.getTracerProvider().get("my.tracer")
      val span: Span = tracer.spanBuilder("my.span").startSpan()
      span.addEvent("test event from scala")
      span.end()
      return x
    }
  }
  $$;

-- Example 27350
CREATE OR REPLACE PROCEDURE do_tracing()
  RETURNS STRING
  LANGUAGE SCALA
  RUNTIME_VERSION = '2.12'
  PACKAGES=('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
  HANDLER = 'ProcedureHandler.run'
  AS
  $$
  import com.snowflake.snowpark_java.Session
  import com.snowflake.telemetry.Telemetry
  import io.opentelemetry.api.common.AttributeKey
  import io.opentelemetry.api.common.Attributes

  class ProcedureHandler {

    def run(session: Session): String = {

      // Set span attribute.
      Telemetry.setSpanAttribute("example.proc.do_tracing", "begin")

      // Add an event without attributes.
      Telemetry.addEvent("run_method_start")

      // Add an event with attributes.
      val eventAttributes: Attributes = Attributes.of(
        AttributeKey.stringKey("example.method.name"), "run")
      Telemetry.addEvent("event_with_attributes", eventAttributes)

      // Set span attribute.
      Telemetry.setSpanAttribute("example.proc.do_tracing", "complete")

      return "SUCCESS"
    }
  }
  $$;

-- Example 27351
val df1 = df.alias("A")
df1.join(df2).select(col("A.col"))

-- Example 27352
import pandas as pd
import numpy as np
from sklearn import datasets
from snowflake.ml.modeling.xgboost import XGBClassifier

iris = datasets.load_iris()
df = pd.DataFrame(data=np.c_[iris["data"], iris["target"]], columns=iris["feature_names"] + ["target"])
df.columns = [s.replace(" (CM)", "").replace(" ", "") for s in df.columns.str.upper()]

input_cols = ["SEPALLENGTH", "SEPALWIDTH", "PETALLENGTH", "PETALWIDTH"]
label_cols = "TARGET"
output_cols = "PREDICTED_TARGET"

clf_xgb = XGBClassifier(
        input_cols=input_cols, output_cols=output_cols, label_cols=label_cols, drop_input_cols=True
)
clf_xgb.fit(df)
model_ref = registry.log_model(
    clf_xgb,
    model_name="XGBClassifier",
    version_name="v1",
)
model_ref.run(df.drop(columns=label_cols).head(10), function_name='predict_proba')

-- Example 27353
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

-- Example 27354
my_model = ExampleBringYourOwnModel(model_context)
output_df = my_model.predict(input_df)

-- Example 27355
reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")
mv = reg.log_model(my_model,
            model_name="my_custom_model",
            version_name="v1",
            conda_dependencies=["scikit-learn"],
            comment="My Custom ML Model",
            sample_input_data=train_features)
output_df = mv.run(input_df)

-- Example 27356
pycaret_model_context = custom_model.ModelContext(
  model_file = 'pycaret_best_model.pkl',
)

-- Example 27357
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

-- Example 27358
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

-- Example 27359
predict_signature = model_signature.infer_signature(input_data=test_df, output_data=output_df)

-- Example 27360
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

-- Example 27361
snowml_registry.show_models()

-- Example 27362
snowpark_df = session.create_dataframe(test_data, schema=col_nms)

custom_mv.run(snowpark_df).show()

-- Example 27363
SELECT
    my_pycaret_model!predict(*) AS predict_dict,
    predict_dict['prediction_label']::text AS prediction_label,
    predict_dict['prediction_score']::double AS prediction_score
from pycaret_input_data;

-- Example 27364
CREATE SERVICE [ IF NOT EXISTS ] <name>
  IN COMPUTE POOL <compute_pool_name>
  {
     fromSpecification
     | fromSpecificationTemplate
  }
  [ AUTO_SUSPEND_SECS = <num> ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <EAI_name> [ , ... ] ) ]
  [ AUTO_RESUME = { TRUE | FALSE } ]
  [ MIN_INSTANCES = <num> ]
  [ MIN_READY_INSTANCES = <num> ]
  [ MAX_INSTANCES = <num> ]
  [ QUERY_WAREHOUSE = <warehouse_name> ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ COMMENT = '{string_literal}']

-- Example 27365
fromSpecification ::=
  {
    FROM SPECIFICATION_FILE = '<yaml_file_path>' -- for native app service.
    | FROM @<stage> SPECIFICATION_FILE = '<yaml_file_path>' -- for non-native app service.
    | FROM SPECIFICATION <specification_text>
  }

-- Example 27366
fromSpecificationTemplate ::=
  {
    FROM SPECIFICATION_TEMPLATE_FILE = '<yaml_file_stage_path>' -- for native app service.
    | FROM @<stage> SPECIFICATION_TEMPLATE_FILE = '<yaml_file_stage_path>' -- for non-native app service.
    | FROM SPECIFICATION_TEMPLATE <specification_text>
  }
  USING ( <key> => <value> [ , <key> => <value> [ , ... ] ]  )

-- Example 27367
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM @tutorial_stage
  SPECIFICATION_FILE='echo_spec.yaml'
  MIN_INSTANCES=2
  MAX_INSTANCES=2

-- Example 27368
>>> db = session.get_current_database().replace('"', "")
>>> schema = session.get_current_schema().replace('"', "")
>>> _ = session.sql(f"CREATE OR REPLACE TABLE {db}.{schema}.T1(C1 INT)").collect()
>>> _ = session.sql(
...     f"CREATE OR REPLACE VIEW {db}.{schema}.V1 AS SELECT * FROM {db}.{schema}.T1"
... ).collect()
>>> _ = session.sql(
...     f"CREATE OR REPLACE VIEW {db}.{schema}.V2 AS SELECT * FROM {db}.{schema}.V1"
... ).collect()
>>> df = session.lineage.trace(
...     f"{db}.{schema}.T1",
...     "table",
...     direction="downstream"
... )
>>> df.show() 
-------------------------------------------------------------------------------------------------------------------------------------------------
| "SOURCE_OBJECT"                                         | "TARGET_OBJECT"                                        | "DIRECTION"   | "DISTANCE" |
-------------------------------------------------------------------------------------------------------------------------------------------------
| {"createdOn": "2023-11-15T12:30:23Z", "domain": "TABLE",| {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW",| "Downstream"  | 1          |
|  "name": "YOUR_DATABASE.YOUR_SCHEMA.T1", "status":      |  "name": "YOUR_DATABASE.YOUR_SCHEMA.V1", "status":     |               |            |
|  "ACTIVE"}                                              |  "ACTIVE"}                                             |               |            |
| {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW", | {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW",| "Downstream"  | 2          |
|  "name": "YOUR_DATABASE.YOUR_SCHEMA.V1", "status":      |  "name": "YOUR_DATABASE.YOUR_SCHEMA.V2", "status":     |               |            |
|  "ACTIVE"}                                              |  "ACTIVE"}                                             |               |            |
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 27369
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

-- Example 27370
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

-- Example 27371
COLUMN_NAME['attribute_name']

-- Example 27372
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

-- Example 27373
----------------------------------------------------------------------------------------------------------------
| TIME                | EXECUTABLE                       | SEVERITY   | MESSAGE                                |
----------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "DO_LOGGING():VARCHAR(16777216)" | "INFO"     | "Logging from Python module."          |
----------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "DO_LOGGING():VARCHAR(16777216)" | "INFO"     | "Logging from Python function start."  |
----------------------------------------------------------------------------------------------------------------
| 2023-04-19 22:00:49 | "DO_LOGGING():VARCHAR(16777216)" | "ERROR"    | "Logging an error from Python handler" |
----------------------------------------------------------------------------------------------------------------

-- Example 27374
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

-- Example 27375
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

-- Example 27376
COLUMN_NAME['attribute_name']

-- Example 27377
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

