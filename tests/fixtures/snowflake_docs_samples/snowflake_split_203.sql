-- Example 13581
{
  "name": "com.sample.MyClass"
}

-- Example 13582
{
  "span_id": "b4c28078330873a2",
  "trace_id": "6992e9febf0b97f45b34a62e54936adb"
}

-- Example 13583
SET event_table_name = 'my_db.public.my_event_table';

SELECT
  RECORD['severity_text'] AS severity,
  RECORD_ATTRIBUTES['exception.message'] AS error_message,
  RECORD_ATTRIBUTES['exception.type'] AS exception_type,
  RECORD_ATTRIBUTES['exception.stacktrace'] AS stacktrace
FROM
  my_event_table
WHERE
  RECORD_TYPE = 'LOG';

-- Example 13584
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| SEVERITY | ERROR_MESSAGE                                        | EXCEPTION_TYPE | STACKTRACE                                                                                                                                          |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| "FATAL"  | "could not convert string to float: '$1,000,000.00'" | "ValueError"   | "Traceback (most recent call last):\n  File \"_udf_code.py\", line 6, in compute\nValueError: could not convert string to float: '$1,000,000.00'\n" |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 13585
SET event_table_name = 'my_db.public.my_event_table';

SELECT
  RECORD['status']['code'] AS span_status
FROM
  my_event_table
WHERE
  record_type = 'SPAN';

-- Example 13586
-----------------------
| SPAN_STATUS         |
-----------------------
| "STATUS_CODE_ERROR" |
-----------------------

-- Example 13587
SET event_table_name = 'my_db.public.my_event_table';

SELECT
  RECORD['name'] AS event_name,
  RECORD_ATTRIBUTES['exception.message'] AS error_message,
  RECORD_ATTRIBUTES['exception.type'] AS exception_type,
  RECORD_ATTRIBUTES['exception.stacktrace'] AS stacktrace
FROM
  my_event_table
WHERE
  RECORD_TYPE = 'SPAN_EVENT';

-- Example 13588
-----------------------------------------------------------------------------------------------------------------------------------------
| EVENT_NAME  | ERROR_MESSAGE                                        | EXCEPTION_TYPE | STACKTRACE                                      |
-----------------------------------------------------------------------------------------------------------------------------------------
| "exception" | "could not convert string to float: '$1,000,000.00'" | "ValueError"   | "  File \"_udf_code.py\", line 6, in compute\n" |
-----------------------------------------------------------------------------------------------------------------------------------------

-- Example 13589
<dependency>
  <groupId>com.snowflake</groupId>
  <artifactId>telemetry</artifactId>
  <version>0.01</version>
</dependency>

-- Example 13590
<assembly xmlns="http://maven.apache.org/ASSEMBLY/2.1.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.1.0 http://maven.apache.org/xsd/assembly-2.1.0.xsd">
  <id>jar-with-dependencies</id>
  <formats>
      <format>jar</format>
  </formats>
  <includeBaseDirectory>false</includeBaseDirectory>
  <dependencySets>
    <dependencySet>
      <outputDirectory>/</outputDirectory>
      <useProjectArtifact>true</useProjectArtifact>
      <unpack>true</unpack>
      <scope>runtime</scope>
      <excludes>
        <exclude>com.snowflake:telemetry</exclude>
      </excludes>
    </dependencySet>
  </dependencySets>
</assembly>

-- Example 13591
<project>
  [...]
  <build>
    [...]
    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
          <descriptors>
            <descriptor>src/assembly/jar-with-dependencies.xml</descriptor>
          </descriptors>
        </configuration>
        [...]
      </plugin>
      [...]
    </plugins>
    [...]
  </build>
  [...]
</project>

-- Example 13592
CREATE OR REPLACE PROCEDURE do_logging_java()
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:telemetry:latest','com.snowflake:snowpark:latest')
HANDLER = 'JavaLoggingHandler.doThings'
AS
$$
  import org.slf4j.Logger;
  import org.slf4j.LoggerFactory;
  import com.snowflake.snowpark_java.Session;

  public class JavaLoggingHandler {
    private static Logger logger = LoggerFactory.getLogger(JavaLoggingHandler.class);

    public String doThings(Session session) {
      logger.atInfo().addKeyValue("custom1", "value1").setMessage("Logging with attributes").log();
      return "SUCCESS";
    }
  }
$$;

-- Example 13593
------------------------------------------------------------------
| VALUE                     | RECORD_ATTRIBUTES                  |
------------------------------------------------------------------
| "Logging with attributes" | {                                  |
|                           |   "custom1": "value1",             |
|                           |   "thread.name": "Thread-5"        |
|                           | }                                  |
------------------------------------------------------------------

-- Example 13594
CREATE OR REPLACE PROCEDURE do_logging()
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES=('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
HANDLER = 'JavaLoggingHandler.doThings'
AS
$$
  import org.slf4j.Logger;
  import org.slf4j.LoggerFactory;
  import com.snowflake.snowpark_java.Session;

  public class JavaLoggingHandler {
    private static Logger logger = LoggerFactory.getLogger(JavaLoggingHandler.class);

    public JavaLoggingHandler() {
      logger.info("Logging from within the constructor.");
    }

    public String doThings(Session session) {
      logger.info("Logging from method start.");

      try {
        throwException();
      } catch (Exception e) {
        logger.error("Logging an error: " + e.getMessage());
        return "ERROR";
      }
      return "SUCCESS";
    }

    // Simulate a thrown exception to catch.
    private void throwException() throws Exception {
      throw new Exception("Something went wrong.");
    }
  }
$$
;

-- Example 13595
SET event_table_name='my_db.public.my_event_table';

SELECT
  RECORD['severity_text'] AS SEVERITY,
  VALUE AS MESSAGE
FROM
  IDENTIFIER($event_table_name)
WHERE
  SCOPE['name'] = 'JavaLoggingHandler'
  AND RECORD_TYPE = 'LOG';

-- Example 13596
--------------------------------------------------------
| SEVERITY | MESSAGE                                   |
--------------------------------------------------------
| "INFO"   | "Logging from within the constructor."    |
--------------------------------------------------------
| "INFO"   | "Logging from method start."              |
--------------------------------------------------------
| "ERROR"  | "Logging an error: Something went wrong." |
--------------------------------------------------------

-- Example 13597
snowflake.log("info", "Information-level message");
snowflake.log("error", "Error message");
snowflake.log("warn", "Warning message");
snowflake.log("debug", "Debug message");
snowflake.log("trace", "Trace message");
snowflake.log("fatal", "Fatal message");

-- Example 13598
CREATE OR REPLACE PROCEDURE do_logging_javascript()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS $$
  let log_attributes = {
    "custom1": "value1",
    "custom2": "value2"
  }
  snowflake.log("info", "Logging with attributes", log_attributes)
  return "success";
$$;

-- Example 13599
------------------------------------------------------------------
| VALUE                     | RECORD_ATTRIBUTES                  |
------------------------------------------------------------------
| "Logging with attributes" | {                                  |
|                           |   "custom1": "value1",             |
|                           |   "custom2": "value2"              |
|                           | }                                  |
------------------------------------------------------------------

-- Example 13600
session_logger = logging.getLogger('snowflake.snowpark.session')
session_logger.setLevel(logging.DEBUG)

-- Example 13601
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

-- Example 13602
numpy_logger = logging.getLogger('numpy_logs')
numpy_logger.setLevel(logging.ERROR)

-- Example 13603
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

-- Example 13604
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

-- Example 13605
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

-- Example 13606
SET event_table_name='my_db.public.my_event_table';

SELECT
  RECORD['severity_text'] AS SEVERITY,
  VALUE AS MESSAGE
FROM
  IDENTIFIER($event_table_name)
WHERE
  SCOPE['name'] = 'python_logger'
  AND RECORD_TYPE = 'LOG';

-- Example 13607
---------------------------------------------------------------------------
| SEVERITY | MESSAGE                                                      |
---------------------------------------------------------------------------
| "INFO"   | "Logging from Python module."                                |
---------------------------------------------------------------------------
| "INFO"   | "Logging from Python function start."                        |
---------------------------------------------------------------------------
| "ERROR"  | "Logging an error from Python handler."                      |
---------------------------------------------------------------------------

-- Example 13608
import streamlit as st
import logging

logger = logging.getLogger('app_logger')

st.title("Streamlit logging example")

hifives_val = st.slider("Number of high-fives", min_value=0, max_value=90, value=60)

if st.button("Submit"):
    logger.info(f"Submitted with high-fives: {hifives_val}")

-- Example 13609
CREATE OR REPLACE PROCEDURE do_logging_scala()
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = '2.12'
PACKAGES=('com.snowflake:telemetry:latest', 'com.snowflake:snowpark:latest')
HANDLER = 'ScalaLoggingHandler.doThings'
AS
$$
  import org.slf4j.Logger
  import org.slf4j.LoggerFactory
  import com.snowflake.snowpark.Session

  class ScalaLoggingHandler {
    private val logger: Logger = LoggerFactory.getLogger(getClass)

    def doThings(session: Session): String = {
      logger.atInfo().addKeyValue("custom1", "value1").setMessage("Logging with attributes").log();
      return "SUCCESS"
    }
  }
$$;

-- Example 13610
------------------------------------------------------------------
| VALUE                     | RECORD_ATTRIBUTES                  |
------------------------------------------------------------------
| "Logging with attributes" | {                                  |
|                           |   "custom1": "value1",             |
|                           |   "thread.name": "Thread-5"        |
|                           | }                                  |
------------------------------------------------------------------

-- Example 13611
CREATE OR REPLACE PROCEDURE do_logging()
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = '2.12'
PACKAGES=('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
HANDLER = 'ScalaLoggingHandler.doThings'
AS
$$
  import org.slf4j.Logger
  import org.slf4j.LoggerFactory
  import com.snowflake.snowpark.Session

  class ScalaLoggingHandler {
    private val logger: Logger = LoggerFactory.getLogger(getClass)

    logger.info("Logging from within the Scala constructor.")

    def doThings(session: Session): String = {
      logger.info("Logging from Scala method start.")

      try {
        throwException
      } catch {
        case e: Exception => logger.error("Logging an error from Scala handler: " + e.getMessage())
        return "ERROR"
      }
      return "SUCCESS"
    }

    // Simulate a thrown exception to catch.
    @throws(classOf[Exception])
    private def throwException = {
      throw new Exception("Something went wrong.")
    }
  }
$$
;

-- Example 13612
SET event_table_name='my_db.public.my_event_table';

SELECT
  RECORD['severity_text'] AS SEVERITY,
  VALUE AS MESSAGE
FROM
  IDENTIFIER($event_table_name)
WHERE
  SCOPE['name'] = 'ScalaLoggingHandler'
  AND RECORD_TYPE = 'LOG';

-- Example 13613
---------------------------------------------------------------------------
| SEVERITY | MESSAGE                                                      |
---------------------------------------------------------------------------
| "INFO"   | "Logging from within the Scala constructor."                 |
---------------------------------------------------------------------------
| "INFO"   | "Logging from Scala method start."                           |
---------------------------------------------------------------------------
| "ERROR"  | "Logging an error from Scala handler: Something went wrong." |
---------------------------------------------------------------------------

-- Example 13614
-- The following calls are equivalent.
-- Both log information-level messages.
SYSTEM$LOG('info', 'Information-level message');
SYSTEM$LOG_INFO('Information-level message');

-- The following calls are equivalent.
-- Both log error messages.
SYSTEM$LOG('error', 'Error message');
SYSTEM$LOG_ERROR('Error message');


-- The following calls are equivalent.
-- Both log warning messages.
SYSTEM$LOG('warning', 'Warning message');
SYSTEM$LOG_WARN('Warning message');

-- The following calls are equivalent.
-- Both log debug messages.
SYSTEM$LOG('debug', 'Debug message');
SYSTEM$LOG_DEBUG('Debug message');

-- The following calls are equivalent.
-- Both log trace messages.
SYSTEM$LOG('trace', 'Trace message');
SYSTEM$LOG_TRACE('Trace message');

-- The following calls are equivalent.
-- Both log fatal messages.
SYSTEM$LOG('fatal', 'Fatal message');
SYSTEM$LOG_FATAL('Fatal message');

-- Example 13615
CREATE OR REPLACE TABLE test_auto_event_logging (id INTEGER, num NUMBER(12, 2));

INSERT INTO test_auto_event_logging (id, num) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 13616
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

-- Example 13617
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'LOGGING';

-- Example 13618
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'ALL';

-- Example 13619
CALL auto_event_logging_sp('test_auto_event_logging', 2, 33.33);

-- Example 13620
+----+-------+
| ID |   NUM |
|----+-------|
|  1 | 11.11 |
|  2 | 33.33 |
+----+-------+

-- Example 13621
SELECT
    TIMESTAMP as time,
    RECORD['severity_text'] as severity,
    VALUE as message
  FROM
    my_db.public.my_events
  WHERE
    RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%AUTO_EVENT_LOGGING_SP%'
    AND RECORD_TYPE = 'LOG';

-- Example 13622
+-------------------------+----------+----------------------------------+
| TIME                    | SEVERITY | MESSAGE                          |
|-------------------------+----------+----------------------------------|
| 2024-10-25 20:42:24.134 | "TRACE"  | "Entering outer block at line 2" |
| 2024-10-25 20:42:24.135 | "TRACE"  | "Entering block at line 2"       |
| 2024-10-25 20:42:24.135 | "TRACE"  | "Starting child job"             |
| 2024-10-25 20:42:24.633 | "TRACE"  | "Ending child job"               |
| 2024-10-25 20:42:24.633 | "TRACE"  | "Starting child job"             |
| 2024-10-25 20:42:24.721 | "TRACE"  | "Ending child job"               |
| 2024-10-25 20:42:24.721 | "TRACE"  | "Exiting with return at line 7"  |
+-------------------------+----------+----------------------------------+

-- Example 13623
ALTER SESSION SET METRIC_LEVEL = ALL;

-- Example 13624
CREATE OR REPLACE PROCEDURE DEMO_SP(n_queries number)
RETURNS VARCHAR(16777216)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-snowpark-python', 'snowflake-telemetry-python==0.2.0')
HANDLER = 'my_handler'
AS $$
import time
def my_handler(session, n_queries):
  import snowflake.snowpark
  from snowflake.snowpark.functions import col, udf
  from snowflake import telemetry

  session.sql('create or replace stage udf_stage;').collect()

  @udf(name='example_udf', is_permanent=True, stage_location='@udf_stage', replace=True)
  def example_udf(x: int) -> int:
    # This UDF will consume 1GB of memory to illustrate the memory consumption metric
    one_gb_list = [0] * (1024**3 // 8)
    return x

  pandas_grouped_df = session.table('snowflake.account_usage.query_history').select(
    col('total_elapsed_time'),
    col('rows_written_to_result'),
    col('database_name'),
    example_udf(col('bytes_scanned'))
  ).limit(n_queries)\
  .to_pandas()\
  .groupby('DATABASE_NAME')

  mean_time = pandas_grouped_df['TOTAL_ELAPSED_TIME'].mean()
  mean_rows_written = pandas_grouped_df['ROWS_WRITTEN_TO_RESULT'].mean()

  return f"""
  {mean_time}
  {mean_rows_written}
  """
$$;

-- Example 13625
CALL DEMO_SP(100);

-- Example 13626
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

-- Example 13627
{
  "kind": "SPAN_KIND_INTERNAL",
  "name": "snow.auto_instrumented",
  "status": {
    "code": "STATUS_CODE_UNSET"
  }
}

-- Example 13628
{
  "example.boolean": true,
  "example.double": 2.5,
  "example.long": 2,
  "example.string": "testAttribute"
}

-- Example 13629
{
  "dropped_attributes_count": 0,
  "name": "testEvent"
}

-- Example 13630
{
  "dropped_attributes_count": 0,
  "name": "testEventWithAttributes"
}

-- Example 13631
{
  "key": "run",
  "result": 123
}

-- Example 13632
CREATE OR REPLACE PROCEDURE myproc(...)
  RETURNS ...
  LANGUAGE JAVA
  ...
  PACKAGES = ('com.snowflake:snowpark:latest', 'com.snowflake:telemetry:latest')
  ...

-- Example 13633
import com.snowflake.telemetry.Telemetry;

-- Example 13634
public static void addEvent(String name)
public static void addEvent(String name, Attributes attributes)

-- Example 13635
// Adding an event without attributes.
Telemetry.addEvent("testEvent");

// Adding an event with attributes.
Attributes eventAttributes = Attributes.of(
  AttributeKey.stringKey("key"), "run",
  AttributeKey.longKey("result"), Long.valueOf(123));
Telemetry.addEvent("testEventWithAttributes", eventAttributes);

-- Example 13636
{
  "name": "testEvent"
}

-- Example 13637
{
  "name": "testEventWithAttributes"
}

-- Example 13638
{
  "key": "run",
  "result": 123
}

-- Example 13639
public static void setSpanAttribute(String key, boolean value)
public static void setSpanAttribute(String key, long value)
public static void setSpanAttribute(String key, double value)
public static void setSpanAttribute(String key, String value)

-- Example 13640
// Setting span attributes.
Telemetry.setSpanAttribute("example.boolean", true);
Telemetry.setSpanAttribute("example.long", 2L);
Telemetry.setSpanAttribute("example.double", 2.5);
Telemetry.setSpanAttribute("example.string", "testAttribute");

-- Example 13641
{
  "example.boolean": true,
  "example.long": 2,
  "example.double": 2.5,
  "example.string": "testAttribute"
}

-- Example 13642
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

-- Example 13643
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

-- Example 13644
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

-- Example 13645
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

-- Example 13646
snowflake.addEvent(name [, { key:value [, key:value] } ] );

-- Example 13647
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

