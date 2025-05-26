-- More Extracted Snowflake SQL Examples (Set 3)

-- From snowflake_split_255.sql

CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.count_positive_numbers(
  arg_t TABLE(
    arg_c1 NUMBER,
    arg_c2 NUMBER,
    arg_c3 NUMBER
  )
)
RETURNS NUMBER
AS
$$
  SELECT
    COUNT(*)
  FROM arg_t
  WHERE
    arg_c1>0
    AND arg_c2>0
    AND arg_c3>0
$$;

CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.referential_check(
  arg_t1 TABLE (arg_c1 INT), arg_t2 TABLE (arg_c2 INT))
RETURNS NUMBER
AS
$$
  SELECT
    COUNT(*)
    FROM arg_t1
  WHERE
    arg_c1 NOT IN (SELECT arg_c2 FROM arg_t2)
$$;

CREATE OR ALTER SECURE DATA METRIC FUNCTION governance.dmfs.count_positive_numbers(
  arg_t TABLE(
    arg_c1 NUMBER,
    arg_c2 NUMBER,
    arg_c3 NUMBER
  )
)
RETURNS NUMBER
COMMENT = "count positive numbers"
AS
$$
  SELECT
    COUNT(*)
  FROM arg_t
  WHERE
    arg_c1>0
    AND arg_c2>0
    AND arg_c3>0
$$;

CREATE OR REPLACE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/prod/remote_echo';

CREATE OR ALTER SECURE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  HEADERS = ('header_variable1'='header_value', 'header_variable2'='header_value2')
  CONTEXT_HEADERS = (current_account)
  MAX_BATCH_ROWS = 100
  COMPRESSION = "GZIP"
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/prod/remote_echo';

CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  AS '
    return x;
  ';

CREATE OR REPLACE FUNCTION js_factorial(d double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS '
    if (d == 0) return 1;
    else return d * js_factorial(d - 1);
  ';

CREATE OR REPLACE FUNCTION py_udf()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  HANDLER = 'my_py_func'
  AS '
    def my_py_func():
        return "Hello from Python UDF!"
  ';

CREATE OR REPLACE FUNCTION dream(i int)
  RETURNS int
  LANGUAGE SQL
  AS $$
    SELECT i + 1;
  $$;

CREATE FUNCTION pi_udf()
  RETURNS FLOAT
  LANGUAGE SQL
  AS $$
    SELECT 3.141592653589793;
  $$;

CREATE FUNCTION simple_table_function ()
  RETURNS TABLE (a INT, b INT)
  LANGUAGE SQL
  AS $$
    SELECT 1, 2 UNION ALL SELECT 3, 4;
  $$;

SELECT * FROM TABLE(simple_table_function());

CREATE FUNCTION multiply1 (a number, b number)
  RETURNS number
  LANGUAGE SQL
  AS $$
    SELECT a * b;
  $$;

CREATE OR REPLACE FUNCTION get_countries_for_user ( id NUMBER )
  RETURNS TABLE (country_code VARCHAR, country_name VARCHAR)
  LANGUAGE SQL
  AS $$
    SELECT DISTINCT c.country_code, c.country_name
    FROM user_addresses a, countries c
    WHERE a.user_id = id
      AND a.country_id = c.country_id;
  $$; 