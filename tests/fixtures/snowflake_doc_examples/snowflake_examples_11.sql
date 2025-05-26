-- More Extracted Snowflake SQL Examples (Set 11)

-- From snowflake_split_408.sql

CREATE OR REPLACE FUNCTION add_two_numbers(A FLOAT, B FLOAT) RETURNS FLOAT
  LANGUAGE JAVA
  PACKAGES=('com.snowflake:telemetry:latest')
  HANDLER = 'ScalarFunctionHandler.run'
  AS
  $$
  // Java code omitted for brevity
  $$;

CREATE OR REPLACE FUNCTION digits_of_number(x int)
  RETURNS TABLE(result INT)
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:telemetry:latest')
  HANDLER = 'TableFunctionHandler'
  AS
  $$
  // Java code omitted for brevity
  $$;

CREATE PROCEDURE PI_JS()
  RETURNS double
  LANGUAGE javascript
  AS
  $$
    snowflake.addEvent('name_a');
    snowflake.addEvent('name_b', {'score': 89, 'pass': true});
    return 3.14;
  $$
  ;

CREATE OR REPLACE FUNCTION javascript_custom_span()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
const { trace } = opentelemetry;
const tracer = trace.getTracer("example_tracer");
tracer.startActiveSpan("example_custom_span", (span) => {
  span.addEvent("testEventWithAttributes");
  span.setAttribute("testAttribute", "value");
  span.end();
});
$$; 