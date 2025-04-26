-- Example 13648
{
  "name": "name_a"
}

-- Example 13649
{
  "name": "name_b"
}

-- Example 13650
{
  "score": 89,
  "pass": true
}

-- Example 13651
snowflake.setSpanAttribute(key, value);

-- Example 13652
// Setting span attributes.
snowflake.setSpanAttribute("example.boolean", true);
snowflake.setSpanAttribute("example.long", 2L);
snowflake.setSpanAttribute("example.double", 2.5);
snowflake.setSpanAttribute("example.string", "testAttribute");

-- Example 13653
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 13654
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

-- Example 13655
CREATE OR REPLACE FUNCTION my_function(...)
  RETURNS ...
  LANGUAGE PYTHON
  ...
  PACKAGES = ('snowflake-telemetry-python')
  ...

-- Example 13656
from snowflake import telemetry

-- Example 13657
telemetry.add_event(<name>, <attributes>)

-- Example 13658
telemetry.add_event("FunctionEmptyEvent")
telemetry.add_event("FunctionEventWithAttributes", {"key1": "value1", "key2": "value2"})

-- Example 13659
{
  "name": "FunctionEmptyEvent"
}

-- Example 13660
{
  "name": "FunctionEventWithAttributes"
}

-- Example 13661
{
  "key1": "value1",
  "key2": "value2"
}

-- Example 13662
telemetry.set_span_attribute(<key>, <value>)

-- Example 13663
// Setting span attributes.
telemetry.set_span_attribute("example.boolean", true);
telemetry.set_span_attribute("example.long", 2);
telemetry.set_span_attribute("example.double", 2.5);
telemetry.set_span_attribute("example.string", "testAttribute");

-- Example 13664
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 13665
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

-- Example 13666
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

-- Example 13667
import streamlit as st
from snowflake import telemetry

st.title("Streamlit trace event example")

hifives_val = st.slider("Number of high-fives", min_value=0, max_value=90, value=60)

if st.button("Submit"):
    telemetry.add_event("new_submission", {"high_fives": hifives_val})

-- Example 13668
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

-- Example 13669
select count(times_two(seq8())) from table(generator(rowcount => 50));

-- Example 13670
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

-- Example 13671
select * from table(generator(rowcount => 50)), table(digits_of_number(seq8())) order by 1;

-- Example 13672
CREATE OR REPLACE PROCEDURE myproc(...)
  RETURNS ...
  LANGUAGE SCALA
  ...
  PACKAGES = ('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
  ...

-- Example 13673
import com.snowflake.telemetry.Telemetry

-- Example 13674
public static void addEvent(String name)
public static void addEvent(String name, Attributes attributes)

-- Example 13675
// Adding an event without attributes.
Telemetry.addEvent("testEvent")

// Adding an event with attributes.
Attributes eventAttributes = Attributes.of(
  AttributeKey.stringKey("key"), "run",
  AttributeKey.longKey("result"), Long.valueOf(123))
Telemetry.addEvent("testEventWithAttributes", eventAttributes)

-- Example 13676
{
  "name": "testEvent"
}

-- Example 13677
{
  "name": "testEventWithAttributes"
}

-- Example 13678
{
  "key": "run",
  "result": 123
}

-- Example 13679
public static void setSpanAttribute(String key, boolean value)
public static void setSpanAttribute(String key, long value)
public static void setSpanAttribute(String key, double value)
public static void setSpanAttribute(String key, String value)

-- Example 13680
// Setting span attributes.
Telemetry.setSpanAttribute("example.boolean", true)
Telemetry.setSpanAttribute("example.long", 2L)
Telemetry.setSpanAttribute("example.double", 2.5)
Telemetry.setSpanAttribute("example.string", "testAttribute")

-- Example 13681
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 13682
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

-- Example 13683
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

-- Example 13684
SYSTEM$ADD_EVENT('SProcEmptyEvent');
SYSTEM$ADD_EVENT('SProcEventWithAttributes', {'key1': 'value1', 'key2': 'value2'});

-- Example 13685
{
  "name": "SProcEmptyEvent"
}

-- Example 13686
{
  "name": "SProcEventWithAttributes"
}

-- Example 13687
{
  "key1": "value1",
  "key2": "value2"
}

-- Example 13688
SYSTEM$SET_SPAN_ATTRIBUTES(<object>);

-- Example 13689
SYSTEM$SET_SPAN_ATTRIBUTES('{'attr1':'value1', 'attr2':true}');

-- Example 13690
{
  "attr1": "value1",
  "attr2": "value2"
}

-- Example 13691
CREATE OR REPLACE PROCEDURE pi_proc()
  RETURNS DOUBLE
  LANGUAGE SQL
  AS $$
  BEGIN
    -- Add an event without attributes
    SYSTEM$ADD_EVENT('name_a');

    -- Add an event with attributes
    LET attr := {'score': 89, 'pass': TRUE};
    SYSTEM$ADD_EVENT('name_b', attr);

    -- Set attributes for the span
    SYSTEM$SET_SPAN_ATTRIBUTES({'key1': 'value1', 'key2': TRUE});

    RETURN 3.14;
  END;
  $$;

-- Example 13692
CALL pi_proc();

-- Example 13693
CREATE OR REPLACE TABLE test_auto_event_logging (id INTEGER, num NUMBER(12, 2));

INSERT INTO test_auto_event_logging (id, num) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 13694
CREATE OR REPLACE PROCEDURE auto_event_logging_sp(
  table_name VARCHAR,
  id_val INTEGER,
  num_val NUMBER(12, 2))
RETURNS TABLE()
LANGUAGE SQL
AS
$$
BEGIN
  UPDATE IDENTIFIER(:table_name)
    SET num = :num_val
    WHERE id = :id_val;
  LET res RESULTSET := (SELECT * FROM IDENTIFIER(:table_name) ORDER BY id);
  RETURN TABLE(res);
EXCEPTION
  WHEN statement_error THEN
    res := (SELECT :sqlcode sql_code, :sqlerrm error_message, :sqlstate sql_state);
    RETURN TABLE(res);
END;
$$
;

-- Example 13695
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'TRACING';

-- Example 13696
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'ALL';

-- Example 13697
CALL auto_event_logging_sp('test_auto_event_logging', 2, 44.44);

-- Example 13698
+----+-------+
| ID |   NUM |
|----+-------|
|  1 | 11.11 |
|  2 | 44.44 |
+----+-------+

-- Example 13699
SELECT
    TIMESTAMP as time,
    RECORD['name'] as event_name,
    RECORD_ATTRIBUTES as attributes,
  FROM
    my_db.public.my_events
  WHERE
    RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%AUTO_EVENT_LOGGING_SP%'
    AND RECORD_TYPE LIKE 'SPAN%';

-- Example 13700
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------+
| TIME                    | EVENT_NAME               | ATTRIBUTES                                                                                    |
|-------------------------+--------------------------+-----------------------------------------------------------------------------------------------|
| 2024-10-25 20:48:49.844 | "snow.auto_instrumented" | {                                                                                             |
|                         |                          |   "childJobTime": 474,                                                                        |
|                         |                          |   "executionTime": 2,                                                                         |
|                         |                          |   "inputArgumentValues": "{ ID_VAL: 2, TABLE_NAME: test_auto_event_logging, NUM_VAL: 44.44 }" |
|                         |                          | }                                                                                             |
| 2024-10-25 20:48:49.740 | "child_job"              | {                                                                                             |
|                         |                          |   "childJobUUID": "01b7ef00-0003-01d1-0000-a99501233092",                                     |
|                         |                          |   "rowCount": 1,                                                                              |
|                         |                          |   "rowsAffected": 1                                                                           |
|                         |                          | }                                                                                             |
| 2024-10-25 20:48:49.843 | "child_job"              | {                                                                                             |
|                         |                          |   "childJobUUID": "01b7ef00-0003-01d1-0000-a99501233096",                                     |
|                         |                          |   "rowCount": 2,                                                                              |
|                         |                          |   "rowsAffected": 0                                                                           |
|                         |                          | }                                                                                             |
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------+

-- Example 13701
CALL auto_event_logging_sp('no_table', 2, 82.44);

-- Example 13702
+----------+-----------------------------------------------------+-----------+
| SQL_CODE | ERROR_MESSAGE                                       | SQL_STATE |
|----------+-----------------------------------------------------+-----------|
|     2003 | SQL compilation error:                              | 42S02     |
|          | Object 'NO_TABLE' does not exist or not authorized. |           |
+----------+-----------------------------------------------------+-----------+

-- Example 13703
SELECT
    TIMESTAMP as time,
    RECORD['name'] as event_name,
    RECORD_ATTRIBUTES as attributes,
  FROM
    my_db.public.my_events
  WHERE
    RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%AUTO_EVENT_LOGGING_SP%'
    AND RECORD_TYPE LIKE 'SPAN%';

-- Example 13704
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| TIME                    | EVENT_NAME               | ATTRIBUTES                                                                                          |
|-------------------------+--------------------------+-----------------------------------------------------------------------------------------------------|
| 2024-10-25 20:52:43.633 | "snow.auto_instrumented" | {                                                                                                   |
|                         |                          |   "childJobTime": 66,                                                                               |
|                         |                          |   "executionTime": 4,                                                                               |
|                         |                          |   "inputArgumentValues": "{ ID_VAL: 2, TABLE_NAME: no_table, NUM_VAL: 82.44 }"                      |
|                         |                          | }                                                                                                   |
| 2024-10-25 20:52:43.601 | "caught_exception"       | {                                                                                                   |
|                         |                          |   "exceptionCode": 2003,                                                                            |
|                         |                          |   "exceptionMessage": "SQL compilation error:\nObject 'NO_TABLE' does not exist or not authorized." |
|                         |                          | }                                                                                                   |
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------------+

-- Example 13705
from snowflake.core import Root

root = Root(my_connection)

-- Example 13706
from snowflake.core import Root
from snowflake.snowpark.context import get_active_session

session = get_active_session()
root = Root(session)

-- Example 13707
root = Root(my_connection)
stages = root.databases["my_db"].schemas["my_schema"].stages
my_stage = stages["my_stage"] # Access the "my_stage" StageResource

-- Example 13708
# my_wh is created from scratch
my_wh = Warehouse(name="my_wh", warehouse_size="X-Small")
root.warehouses.create(my_wh)

-- Example 13709
# my_wh_ref is retrieved from an existing warehouse
# This returns a WarehouseResource object, which is a reference to a warehouse named "my_wh" in your Snowflake account
my_wh_ref = root.warehouses["my_wh"]

-- Example 13710
# my_wh is fetched from an existing warehouse
my_wh = root.warehouses["my_wh"].fetch()
print(my_wh.name, my_wh.auto_resume)

-- Example 13711
# my_wh is fetched from an existing warehouse
my_wh = root.warehouses["my_wh"].fetch()
my_wh.warehouse_size = "X-Small"
root.warehouses["my_wh"].create_or_alter(my_wh)

-- Example 13712
# my_wh_ref is retrieved from an existing warehouse
# This returns a WarehouseResource object, which is a reference to a warehouse named "my_wh" in your Snowflake account
my_wh_ref = root.warehouses["my_wh"]

# Fetch returns the properties of the object (returns a "Model" Warehouse object that represents that warehouse's properties)
wh_properties = my_wh_ref.fetch()

-- Example 13713
# my_wh_ref is retrieved from an existing warehouse
my_wh_ref = root.warehouses["my_wh"]

# Resume a warehouse using a WarehouseResource object
my_wh_ref.resume()

-- Example 13714
# my_stage is retrieved from an existing stage
stage_ref = root.databases["my_db"].schemas["my_schema"].stages["my_stage"]

# Print file names and their sizes on a stage using a StageResource object
for file in stage_ref.list_files():
  print(file.name, file.size)

