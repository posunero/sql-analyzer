-- Example 27244
df.select(get(col("src"), lit("dealership"))).show()
df.select(col("src")("dealership")).show()

-- Example 27245
df.select(get_path(col("src"), lit("vehicle[0].make"))).show()
df.select(col("src")("vehicle")(0)("make")).show()

-- Example 27246
// Import the objects for the data types, including StringType.
import com.snowflake.snowpark.types._
...
val df = session.table("car_sales")
df.select(col("src")("salesperson")("id")).show()
df.select(col("src")("salesperson")("id").cast(StringType)).show()

-- Example 27247
----------------------------------
|"""SRC""['SALESPERSON']['ID']"  |
----------------------------------
|"55"                            |
|"274"                           |
----------------------------------

---------------------------------------------------
|"CAST (""SRC""['SALESPERSON']['ID'] AS STRING)"  |
---------------------------------------------------
|55                                               |
|274                                              |
---------------------------------------------------

-- Example 27248
val df = session.table("car_sales")
df.flatten(col("src")("customer")).show()

-- Example 27249
----------------------------------------------------------------------------------------------------------------------------------------------------------
|"SRC"                                      |"SEQ"  |"KEY"  |"PATH"  |"INDEX"  |"VALUE"                            |"THIS"                               |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|{                                          |1      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "San Francisco, CA",  |  {                                  |
|    {                                      |       |       |        |         |  "name": "Joyce Ridgely",         |    "address": "San Francisco, CA",  |
|      "address": "San Francisco, CA",      |       |       |        |         |  "phone": "16504378889"           |    "name": "Joyce Ridgely",         |
|      "name": "Joyce Ridgely",             |       |       |        |         |}                                  |    "phone": "16504378889"           |
|      "phone": "16504378889"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Valley View Auto Sales",  |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "55",                            |       |       |        |         |                                   |                                     |
|    "name": "Frank Beasley"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "paint protection"                 |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Honda",                     |       |       |        |         |                                   |                                     |
|      "model": "Civic",                    |       |       |        |         |                                   |                                     |
|      "price": "20275",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
|{                                          |2      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "New York, NY",       |  {                                  |
|    {                                      |       |       |        |         |  "name": "Bradley Greenbloom",    |    "address": "New York, NY",       |
|      "address": "New York, NY",           |       |       |        |         |  "phone": "12127593751"           |    "name": "Bradley Greenbloom",    |
|      "name": "Bradley Greenbloom",        |       |       |        |         |}                                  |    "phone": "12127593751"           |
|      "phone": "12127593751"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Tindel Toyota",           |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "274",                           |       |       |        |         |                                   |                                     |
|    "name": "Greg Northrup"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "rust proofing",                   |       |       |        |         |                                   |                                     |
|        "fabric protection"                |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Toyota",                    |       |       |        |         |                                   |                                     |
|      "model": "Camry",                    |       |       |        |         |                                   |                                     |
|      "price": "23500",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 27250
df.flatten(col("src")("customer")).select(col("value")("name"), col("value")("address")).show()

-- Example 27251
-------------------------------------------------
|"""VALUE""['NAME']"   |"""VALUE""['ADDRESS']"  |
-------------------------------------------------
|"Joyce Ridgely"       |"San Francisco, CA"     |
|"Bradley Greenbloom"  |"New York, NY"          |
-------------------------------------------------

-- Example 27252
df.flatten(col("src")("customer")).select(col("value")("name").cast(StringType).as("Customer Name"), col("value")("address").cast(StringType).as("Customer Address")).show()

-- Example 27253
-------------------------------------------
|"Customer Name"     |"Customer Address"  |
-------------------------------------------
|Joyce Ridgely       |San Francisco, CA   |
|Bradley Greenbloom  |New York, NY        |
-------------------------------------------

-- Example 27254
// Get the list of the files in a stage.
// The collect() method causes this SQL statement to be executed.
val dfStageFiles = session.sql("ls @myStage")
val files = dfStageFiles.collect()
files.foreach(println)

// Resume the operation of a warehouse.
// Note that you must call the collect method in order to execute
// the SQL statement.
session.sql("alter warehouse if exists myWarehouse resume if suspended").collect()

val tableDf = session.table("table").select(col("a"), col("b"))
// Get the count of rows from the table.
val numRows = tableDf.count()
println("Count: " + numRows);

-- Example 27255
val df = session.sql("select id, category_id, name from sample_product_data where id > 10")
// Because the underlying SQL statement for the DataFrame is a SELECT statement,
// you can call the filter method to transform this DataFrame.
val results = df.filter(col("category_id") < 10).select(col("id")).collect()
results.foreach(println)

// In this example, the underlying SQL statement is not a SELECT statement.
val dfStageFiles = session.sql("ls @myStage")
// Calling the filter method results in an error.
dfStageFiles.filter(...)

-- Example 27256
DROP ACCOUNT my_account GRACE_PERIOD_IN_DAYS = 14;

-- Example 27257
SHOW ACCOUNTS HISTORY;

-- Example 27258
UNDROP ACCOUNT myaccount123;

-- Example 27259
INSERT INTO t (c1, c2) VALUES (1, 'Test string');

-- Example 27260
INSERT INTO t (c1, c2) VALUES (?, ?);

-- Example 27261
INSERT INTO t (col1, col2) VALUES (?, ?)

-- Example 27262
INSERT INTO t (c1) VALUES (:variable1)

-- Example 27263
EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price);

-- Example 27264
LET c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
OPEN c1 USING (minimum_price, maximum_price);

-- Example 27265
EXECUTE IMMEDIATE $$
DECLARE
  i INTEGER DEFAULT 1;
  v VARCHAR DEFAULT 'SnowFlake';
  r RESULTSET;
BEGIN
  CREATE OR REPLACE TABLE snowflake_scripting_bind_demo (id INTEGER, value VARCHAR);
  EXECUTE IMMEDIATE 'INSERT INTO snowflake_scripting_bind_demo (id, value)
    SELECT :1, (:2 || :1)' USING (i, v);
  r := (SELECT * FROM snowflake_scripting_bind_demo);
  RETURN TABLE(r);
END;
$$
;

-- Example 27266
+----+------------+
| ID | VALUE      |
|----+------------|
|  1 | SnowFlake1 |
+----+------------+

-- Example 27267
conn = snowflake.connector.connect( ... )
rows_to_insert = [('milk', 2), ('apple', 3), ('egg', 2)]
conn.cursor().executemany(
            "insert into grocery (item, quantity) values (?, ?)",
            rows_to_insert)

-- Example 27268
+-------+----+
| C1    | C2 |
|-------+----|
| milk  |  2 |
| apple |  3 |
| egg   |  2 |
+-------+----+

-- Example 27269
VALUES (?,?), (?,?)

-- Example 27270
INSERT INTO t VALUES (?,?), (?,?);

-- Example 27271
CREATE TABLE t (a VARIANT);
-- Code that supplies a bind value for ? of '{'a': 'abc', 'x': 'xyz'}'
INSERT INTO t SELECT PARSE_JSON(a) FROM VALUES (?);

-- Example 27272
SELECT * FROM t;

-- Example 27273
+---------------+
| A             |
|---------------|
| {             |
|   "a": "abc", |
|   "x": "xyz"  |
| }             |
+---------------+

-- Example 27274
INSERT INTO t SELECT ARRAY_CONSTRUCT(column1) FROM VALUES (?);

-- Example 27275
{
  "severity_text": "INFO"
}

-- Example 27276
{
  "metric": {
    "name": "process.memory.usage",
    "unit": "bytes"
  },
  "metric_type": "sum",
  "value_type": "INT"
}

-- Example 27277
{
  "code.filepath": "main.scala",
  "code.function": "$anonfun$new$10",
  "code.lineno": 149,
  "code.namespace": "main.main$",
  "thread.id": 1,
  "thread.name": "main"
  "employee.id": "52307953446424"
}

-- Example 27278
{
  "snow.input.rows": 12
  "snow.output.rows": 12
}

-- Example 27279
{
  "MyFunctionVersion": "1.1.0"
}

-- Example 27280
{
  "mykey1": "value1",
  "mykey2": "value2"
}

-- Example 27281
{
  "db.user": "MYUSERNAME",
  "snow.database.id": 13,
  "snow.database.name": "MY_DB",
  "snow.executable.id": 197,
  "snow.executable.name": "FUNCTION_NAME(I NUMBER):ARG_NAME(38,0)",
  "snow.executable.type": "FUNCTION",
  "snow.owner.id": 2,
  "snow.owner.name": "MY_ROLE",
  "snow.query.id": "01ab0f07-0000-15c8-0000-0129000592c2",
  "snow.schema.id": 16,
  "snow.schema.name": "PUBLIC",
  "snow.session.id": 1275605667850,
  "snow.session.role.primary.id": 2,
  "snow.session.role.primary.name": "MY_ROLE",
  "snow.user.id": 25,
  "snow.warehouse.id": 5,
  "snow.warehouse.name": "MYWH",
  "telemetry.sdk.language": "python"
}

-- Example 27282
{
  "name": "com.sample.MyClass"
}

-- Example 27283
{
  "span_id": "b4c28078330873a2",
  "trace_id": "6992e9febf0b97f45b34a62e54936adb"
}

-- Example 27284
CREATE OR REPLACE PROCEDURE test_stored_proc()
RETURNS STRING
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES=('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
HANDLER = 'MyClass.run'
AS
$$
  import com.snowflake.snowpark_java.Session;
  import com.snowflake.telemetry.Telemetry;
  import io.opentelemetry.api.common.AttributeKey;
  import io.opentelemetry.api.common.Attributes;
  import io.opentelemetry.api.common.AttributesBuilder;

  public class MyClass {

    public String run(Session session) {
      // Adding an event without attributes.
      Telemetry.addEvent("testEvent");

      // Adding an event with attributes.
      Attributes eventAttributes = Attributes.of(
          AttributeKey.stringKey("key"), "run",
          AttributeKey.longKey("result"), Long.valueOf(123));
      Telemetry.addEvent("testEventWithAttributes", eventAttributes);

      // Setting span attributes of different types.
      Telemetry.setSpanAttribute("example.boolean", true);
      Telemetry.setSpanAttribute("example.long", 2L);
      Telemetry.setSpanAttribute("example.double", 2.5);
      Telemetry.setSpanAttribute("example.string", "testAttribute");

      return "SUCCESS";
    }
  }
$$;

-- Example 27285
{
  "kind": "SPAN_KIND_INTERNAL",
  "name": "snow.auto_instrumented",
  "status": {
    "code": "STATUS_CODE_UNSET"
  }
}

-- Example 27286
{
  "example.boolean": true,
  "example.double": 2.5,
  "example.long": 2,
  "example.string": "testAttribute"
}

-- Example 27287
{
  "dropped_attributes_count": 0,
  "name": "testEvent"
}

-- Example 27288
{
  "dropped_attributes_count": 0,
  "name": "testEventWithAttributes"
}

-- Example 27289
{
  "key": "run",
  "result": 123
}

-- Example 27290
session_logger = logging.getLogger('snowflake.snowpark.session')
session_logger.setLevel(logging.DEBUG)

-- Example 27291
SET event_table_name='my_db.public.my_event_table';

SELECT
  TIMESTAMP as time,
  RECORD['severity_text'] as log_level,
  SCOPE['name'] as logger_name,
  VALUE as message
FROM
  IDENTIFIER($event_table_name)
WHERE
  RECORD_TYPE = 'LOG';

-- Example 27292
numpy_logger = logging.getLogger('numpy_logs')
numpy_logger.setLevel(logging.ERROR)

-- Example 27293
CREATE OR REPLACE PROCEDURE do_logging_python()
RETURNS VARCHAR
LANGUAGE PYTHON
PACKAGES = ('snowflake-snowpark-python')
RUNTIME_VERSION = 3.9
HANDLER = 'do_things'
AS $$
import logging

logger = logging.getLogger("python_logger")

def do_things(session):

  logger.info("Logging with attributes in SP", extra = {'custom1': 'value1', 'custom2': 'value2'})

  return "SUCCESS"
$$;

-- Example 27294
---------------------------------------------------------------------
| VALUE                        | RECORD_ATTRIBUTES                  |
---------------------------------------------------------------------
| "Logging with attributes in" | {                                  |
|                              |   "code.filepath": "_udf_code.py", |
|                              |   "code.function": "do_things",    |
|                              |   "code.lineno": 10,               |
|                              |   "custom1": "value1",             |
|                              |   "custom2": "value2"              |
|                              | }                                  |
---------------------------------------------------------------------

-- Example 27295
CREATE OR REPLACE PROCEDURE do_logging()
RETURNS VARCHAR
LANGUAGE PYTHON
PACKAGES=('snowflake-snowpark-python')
RUNTIME_VERSION = 3.9
HANDLER='do_things'
AS $$
import logging

logger = logging.getLogger("python_logger")
logger.info("Logging from Python module.")

def do_things(session):
  logger.info("Logging from Python function start.")

  try:
    throw_exception()
  except Exception:
    logger.error("Logging an error from Python handler: ")
    return "ERROR"

  return "SUCCESS"

def throw_exception():
  raise Exception("Something went wrong.")

$$;

-- Example 27296
SET event_table_name='my_db.public.my_event_table';

SELECT
  RECORD['severity_text'] AS SEVERITY,
  VALUE AS MESSAGE
FROM
  IDENTIFIER($event_table_name)
WHERE
  SCOPE['name'] = 'python_logger'
  AND RECORD_TYPE = 'LOG';

-- Example 27297
---------------------------------------------------------------------------
| SEVERITY | MESSAGE                                                      |
---------------------------------------------------------------------------
| "INFO"   | "Logging from Python module."                                |
---------------------------------------------------------------------------
| "INFO"   | "Logging from Python function start."                        |
---------------------------------------------------------------------------
| "ERROR"  | "Logging an error from Python handler."                      |
---------------------------------------------------------------------------

-- Example 27298
import streamlit as st
import logging

logger = logging.getLogger('app_logger')

st.title("Streamlit logging example")

hifives_val = st.slider("Number of high-fives", min_value=0, max_value=90, value=60)

if st.button("Submit"):
    logger.info(f"Submitted with high-fives: {hifives_val}")

-- Example 27299
CREATE OR REPLACE PROCEDURE myproc(...)
  RETURNS ...
  LANGUAGE JAVA
  ...
  PACKAGES = ('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
  ...

-- Example 27300
import com.snowflake.telemetry.Telemetry;

-- Example 27301
public static void addEvent(String name)
public static void addEvent(String name, Attributes attributes)

-- Example 27302
// Adding an event without attributes.
Telemetry.addEvent("testEvent");

// Adding an event with attributes.
Attributes eventAttributes = Attributes.of(
  AttributeKey.stringKey("key"), "run",
  AttributeKey.longKey("result"), Long.valueOf(123));
Telemetry.addEvent("testEventWithAttributes", eventAttributes);

-- Example 27303
{
  "name": "testEvent"
}

-- Example 27304
{
  "name": "testEventWithAttributes"
}

-- Example 27305
{
  "key": "run",
  "result": 123
}

-- Example 27306
public static void setSpanAttribute(String key, boolean value)
public static void setSpanAttribute(String key, long value)
public static void setSpanAttribute(String key, double value)
public static void setSpanAttribute(String key, String value)

-- Example 27307
// Setting span attributes.
Telemetry.setSpanAttribute("example.boolean", true);
Telemetry.setSpanAttribute("example.long", 2L);
Telemetry.setSpanAttribute("example.double", 2.5);
Telemetry.setSpanAttribute("example.string", "testAttribute");

-- Example 27308
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 27309
CREATE OR REPLACE FUNCTION customSpansJavaExample() RETURNS STRING
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:telemetry:latest')
  HANDLER = 'MyJavaClass.run'
  as
  $$
  import com.snowflake.telemetry.Telemetry;
  import io.opentelemetry.api.common.AttributeKey;
  import io.opentelemetry.api.common.Attributes;
  import io.opentelemetry.api.GlobalOpenTelemetry;
  import io.opentelemetry.api.trace.Tracer;
  import io.opentelemetry.api.trace.Span;
  import io.opentelemetry.context.Scope;

  class MyJavaClass {
    public static String run() {
      Tracer tracer = GlobalOpenTelemetry.getTracerProvider().get("my.tracer");
      Span span = tracer.spanBuilder("my.span").startSpan();
      try (Scope scope = span.makeCurrent()) {
        // Do processing, adding events that will be captured in a my.span.

        // Add an event with attributes.
        Attributes eventAttributes = Attributes.of(
          AttributeKey.stringKey("key"), "run",
          AttributeKey.longKey("result"), Long.valueOf(123));

        span.addEvent("testEventWithAttributes", eventAttributes);
        span.setAttribute("testAttribute", "value");

      } finally {
        span.end();
      }
      return "success";
    }
  }
  $$;

-- Example 27310
CREATE OR REPLACE PROCEDURE do_tracing()
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES=('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
  HANDLER = 'ProcedureHandler.run'
  AS
  $$
  import com.snowflake.snowpark_java.Session;
  import com.snowflake.telemetry.Telemetry;
  import io.opentelemetry.api.common.AttributeKey;
  import io.opentelemetry.api.common.Attributes;

  public class ProcedureHandler {

    public String run(Session session) {

      // Set span attribute.
      Telemetry.setSpanAttribute("example.proc.do_tracing", "begin");

      // Add an event without attributes.
      Telemetry.addEvent("run_method_start");

      // Add an event with attributes.
      Attributes eventAttributes = Attributes.of(
        AttributeKey.stringKey("example.method.name"), "run",
        AttributeKey.longKey("example.long"), Long.valueOf(123));
      Telemetry.addEvent("event_with_attributes", eventAttributes);

      // Set span attribute.
      Telemetry.setSpanAttribute("example.proc.do_tracing", "complete");

      return "SUCCESS";
    }
  }
  $$;

