-- Example 17064
df = pd.DataFrame(
{
      "COLUMN1": [1, 4, 0, 10, 9],
      "COLUMN2": [-1.3, -1.4, -2.9, -10.1, -20.4],
}
)

schema = DataFrameSchema(
{
      "COLUMN1": Column(int8, Check.between(0, 10, element_wise=True)),
      "COLUMN2": Column(
          float,
          [
              Check.greater_than(-20.5),
              Check.less_than(-1.0),
              Check(lambda x: x < -1.2),
          ],
      ),
}
)

session = Session.builder.getOrCreate()
sp_df = session.create_dataframe(df)
check_dataframe_schema(
  sp_df,
  schema,
  skip_checks={"COLUMN1": [SKIP_ALL], "COLUMN2": ["greater_than", "less_than"]},
)

-- Example 17065
df = pd.DataFrame(
  {
        "COLUMN1": [1, 4, 0, 10, 9],
        "COLUMN2": [-1.3, -1.4, -2.9, -10.1, -20.4],
  }
)

session = Session.builder.getOrCreate()
sp_df = session.create_dataframe(df)

# Those check will be added to the schema generate from the JSON file
result = validate_dataframe_checkpoint(
  sp_df,
  "checkpoint-name",
  custom_checks={
        "COLUMN1": [
            Check(lambda x: x.shape[0] == 5),
            Check(lambda x: x.shape[1] == 2),
    ],
    "COLUMN2": [Check(lambda x: x.shape[0] == 5)],
  },
)

-- Example 17066
def dataframe_strategy(
  schema: Union[str, DataFrameSchema],
  session: Session,
  size: Optional[int] = None
) -> SearchStrategy[DataFrame]

-- Example 17067
from hypothesis import given

from snowflake.hypothesis_snowpark import dataframe_strategy
from snowflake.snowpark import DataFrame, Session


@given(
    df=dataframe_strategy(
        schema="path/to/file.json",
        session=Session.builder.getOrCreate(),
        size=10,
    )
)
def test_my_function_from_json_file(df: DataFrame):
    # Test a particular function using the generated Snowpark DataFrame
    ...

-- Example 17068
import pandera as pa

from hypothesis import given

from snowflake.hypothesis_snowpark import dataframe_strategy
from snowflake.snowpark import DataFrame, Session


@given(
    df=dataframe_strategy(
        schema=pa.DataFrameSchema(
            {
                "boolean_column": pa.Column(bool),
                "integer_column": pa.Column("int64", pa.Check.in_range(0, 9)),
                "float_column": pa.Column(pa.Float32, pa.Check.in_range(10.5, 20.5)),
            }
        ),
        session=Session.builder.getOrCreate(),
        size=10,
    )
)
def test_my_function_from_dataframeschema_object(df: DataFrame):
    # Test a particular function using the generated Snowpark DataFrame
    ...

-- Example 17069
from datetime import timedelta

from hypothesis import given, settings
from snowflake.snowpark import DataFrame, Session

from snowflake.hypothesis_snowpark import dataframe_strategy


@given(
    df=dataframe_strategy(
        schema="path/to/file.json",
        session=Session.builder.getOrCreate(),
    )
)
@settings(
    deadline=timedelta(milliseconds=800),
    max_examples=25,
)
def test_my_function(df: DataFrame):
    # Test a particular function using the generated Snowpark DataFrame
    ...

-- Example 17070
import logging

logging.basicConfig(
  level=logging.DEBUG, # Adjust the log level as needed
  format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

-- Example 17071
import logging.config
from datetime import datetime

LOGGING_CONFIG = {
  "version": 1,
  "disable_existing_loggers": False,
  "formatters": {
      "standard": {
          "format": "{asctime} - {name} - {levelname} - {message}",
          "style": "{",
          "datefmt": "%Y-%m-%d %H:%M:%S",
      },
  },
  "handlers": {
      "console": {
          "class": "logging.StreamHandler",
          "formatter": "standard",
          "level": "DEBUG",  # Adjust the log level as needed
      },
      "file": {
          "class": "logging.FileHandler",
          "formatter": "standard",
          "filename": f"app_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.log",
          "level": "DEBUG",  # Adjust the log level as needed
          "encoding": "utf-8",
      },
  },
  "root": {
      "handlers": ["console", "file"],
      "level": "DEBUG",  # Adjust the log level as needed
  },
}

logging.config.dictConfig(LOGGING_CONFIG)

-- Example 17072
import logging.config
from datetime import datetime

LOGGING_CONFIG = {
  "version": 1,
  "disable_existing_loggers": False,
  "formatters": {
      "standard": {
          "format": "{asctime} - {name} - {levelname} - {message}",
          "style": "{",
          "datefmt": "%Y-%m-%d %H:%M:%S",
      },
  },
  "handlers": {
      "console": {
          "class": "logging.StreamHandler",
          "formatter": "standard",
          "level": "DEBUG",  # Adjust the log level as needed
      },
      "file": {
          "class": "logging.FileHandler",
          "formatter": "standard",
          "filename": f"app_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.log",
          "level": "DEBUG",  # Adjust the log level as needed
          "encoding": "utf-8",
      },
  },
  "loggers": {
      "snowflake.snowpark_checkpoints_collector": {
          "handlers": ["console", "file"],
          "level": "DEBUG",  # Adjust the log level as needed
          "propagate": False,
      },
      "snowflake.snowpark_checkpoints": {
          "handlers": ["console", "file"],
          "level": "DEBUG",  # Adjust the log level as needed
          "propagate": False,
      },
      "snowflake.snowpark_checkpoints_configuration": {
          "handlers": ["console", "file"],
          "level": "DEBUG",  # Adjust the log level as needed
          "propagate": False,
      },
      "snowflake.hypothesis_snowpark": {
          "handlers": ["console", "file"],
          "level": "DEBUG",  # Adjust the log level as needed
          "propagate": False,
      },
  },
}

logging.config.dictConfig(LOGGING_CONFIG)

-- Example 17073
CREATE [ OR REPLACE ] [ SECURE ] DATA METRIC FUNCTION [ IF NOT EXISTS ] <name>
  ( <table_arg> TABLE( <col_arg> <data_type> [ , ... ] )
    [ , <table_arg> TABLE( <col_arg> <data_type> [ , ... ] ) ] )
  RETURNS NUMBER [ [ NOT ] NULL ]
  [ LANGUAGE SQL ]
  [ COMMENT = '<string_literal>' ]
  AS
  '<expression>'

-- Example 17074
CREATE [ OR ALTER ] DATA METRIC FUNCTION ...

-- Example 17075
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

-- Example 17076
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

-- Example 17077
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

-- Example 17078
CREATE [ OR REPLACE ] [ SECURE ] EXTERNAL FUNCTION <name> ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ COMMENT = '<string_literal>' ]
  API_INTEGRATION = <api_integration_name>
  [ HEADERS = ( '<header_1>' = '<value_1>' [ , '<header_2>' = '<value_2>' ... ] ) ]
  [ CONTEXT_HEADERS = ( <context_function_1> [ , <context_function_2> ...] ) ]
  [ MAX_BATCH_ROWS = <integer> ]
  [ COMPRESSION = <compression_type> ]
  [ REQUEST_TRANSLATOR = <request_translator_udf_name> ]
  [ RESPONSE_TRANSLATOR = <response_translator_udf_name> ]
  AS '<url_of_proxy_and_resource>';

-- Example 17079
CREATE [ OR ALTER ] EXTERNAL FUNCTION ...

-- Example 17080
HEADERS = (
    'volume-measure' = 'liters',
    'distance-measure' = 'kilometers'
)

-- Example 17081
CONTEXT_HEADERS = (current_timestamp)

-- Example 17082
select
  /*ÄÎßë¬±©®*/
  my_external_function(1);

-- Example 17083
select /* */ my_external_function(1);

-- Example 17084
base64_encode('select\n/ÄÎßë¬±©®/\nmy_external_function(1)')

-- Example 17085
sf-context-<context-function>-base64

-- Example 17086
sf-context-current-statement-base64

-- Example 17087
CREATE OR REPLACE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/prod/remote_echo';

-- Example 17088
CREATE OR ALTER SECURE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  HEADERS = ('header_variable1'='header_value', 'header_variable2'='header_value2')
  CONTEXT_HEADERS = (current_account)
  MAX_BATCH_ROWS = 100
  COMPRESSION = "GZIP"
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/prod/remote_echo';

-- Example 17089
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE JAVA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <java_jdk_version> ]
  [ COMMENT = '<string_literal>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ PACKAGES = ( '<package_name_and_version>' [ , ... ] ) ]
  HANDLER = '<path_to_method>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  AS '<function_definition>'

-- Example 17090
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE JAVA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <java_jdk_version> ]
  [ COMMENT = '<string_literal>' ]
  IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] )
  HANDLER = '<path_to_method>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]

-- Example 17091
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE JAVASCRIPT
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ COMMENT = '<string_literal>' ]
  AS '<function_definition>'

-- Example 17092
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] [ AGGREGATE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE PYTHON
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  RUNTIME_VERSION = <python_version>
  [ COMMENT = '<string_literal>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ PACKAGES = ( '<package_name>[==<version>]' [ , ... ] ) ]
  HANDLER = '<function_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  AS '<function_definition>'

-- Example 17093
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] [ AGGREGATE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE PYTHON
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  RUNTIME_VERSION = <python_version>
  [ COMMENT = '<string_literal>' ]
  IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] )
  [ PACKAGES = ( '<package_name>[==<version>]' [ , ... ] ) ]
  HANDLER = '<module_file_name>.<function_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]

-- Example 17094
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  LANGUAGE SCALA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <scala_version> ]
  [ COMMENT = '<string_literal>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ PACKAGES = ( '<package_name_and_version>' [ , ... ] ) ]
  HANDLER = '<path_to_method>'
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  AS '<function_definition>'

-- Example 17095
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  LANGUAGE SCALA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <scala_version> ]
  [ COMMENT = '<string_literal>' ]
  IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] )
  HANDLER = '<path_to_method>'

-- Example 17096
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  [ { VOLATILE | IMMUTABLE } ]
  [ MEMOIZABLE ]
  [ COMMENT = '<string_literal>' ]
  AS '<function_definition>'

-- Example 17097
CREATE [ OR ALTER ] FUNCTION ...

-- Example 17098
-- Use version 1.2.0 of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:1.2.0')

-- Use the latest version of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:latest')

-- Example 17099
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'java';

-- Example 17100
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 17101
REMOVE @handlers/myhandler.jar;

-- Example 17102
-- Use version 1.2.2 of the NumPy package.
PACKAGES=('numpy==1.2.2')

-- Use the latest version of the NumPy package.
PACKAGES=('numpy')

-- Example 17103
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'python';

-- Example 17104
-- Use version 1.2.3 or higher of the NumPy package.
PACKAGES=('numpy>=1.2.3')

-- Example 17105
-- Use version 1.7.0 of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:1.7.0')

-- Use the latest version of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:latest')

-- Example 17106
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'scala';

-- Example 17107
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 17108
REMOVE @handlers/myhandler.jar;

-- Example 17109
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVA
  CALLED ON NULL INPUT
  HANDLER = 'TestFunc.echoVarchar'
  TARGET_PATH = '@~/testfunc.jar'
  AS
  'class TestFunc {
    public static String echoVarchar(String x) {
      return x;
    }
  }';

-- Example 17110
create function my_decrement_udf(i numeric(9, 0))
    returns numeric
    language java
    imports = ('@~/my_decrement_udf_package_dir/my_decrement_udf_jar.jar')
    handler = 'my_decrement_udf_package.my_decrement_udf_class.my_decrement_udf_method'
    ;

-- Example 17111
CREATE OR REPLACE FUNCTION js_factorial(d double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  STRICT
  AS '
  if (D <= 0) {
    return 1;
  } else {
    var result = 1;
    for (var i = 2; i <= D; i++) {
      result = result * i;
    }
    return result;
  }
  ';

-- Example 17112
CREATE OR REPLACE FUNCTION py_udf()
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  PACKAGES = ('numpy','pandas','xgboost==1.5.0')
  HANDLER = 'udf'
AS $$
import numpy as np
import pandas as pd
import xgboost as xgb
def udf():
    return [np.__version__, pd.__version__, xgb.__version__]
$$;

-- Example 17113
CREATE OR REPLACE FUNCTION dream(i int)
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  HANDLER = 'sleepy.snore'
  IMPORTS = ('@my_stage/sleepy.py')

-- Example 17114
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='Echo.echoVarchar'
  AS
  $$
  class Echo {
    def echoVarchar(x : String): String = {
      return x
    }
  }
  $$;

-- Example 17115
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  IMPORTS = ('@udf_libs/echohandler.jar')
  HANDLER='Echo.echoVarchar';

-- Example 17116
CREATE FUNCTION pi_udf()
  RETURNS FLOAT
  AS '3.141592654::FLOAT'
  ;

-- Example 17117
CREATE FUNCTION simple_table_function ()
  RETURNS TABLE (x INTEGER, y INTEGER)
  AS
  $$
    SELECT 1, 2
    UNION ALL
    SELECT 3, 4
  $$
  ;

-- Example 17118
SELECT * FROM TABLE(simple_table_function());

-- Example 17119
SELECT * FROM TABLE(simple_table_function());
+---+---+
| X | Y |
|---+---|
| 1 | 2 |
| 3 | 4 |
+---+---+

-- Example 17120
CREATE FUNCTION multiply1 (a number, b number)
  RETURNS number
  COMMENT='multiply two numbers'
  AS 'a * b';

-- Example 17121
CREATE OR REPLACE FUNCTION get_countries_for_user ( id NUMBER )
  RETURNS TABLE (country_code CHAR, country_name VARCHAR)
  AS 'SELECT DISTINCT c.country_code, c.country_name
      FROM user_addresses a, countries c
      WHERE a.user_id = id
      AND c.country_code = a.country_code';

-- Example 17122
CREATE OR ALTER FUNCTION multiply(a NUMBER, b NUMBER)
  RETURNS NUMBER
  AS 'a * b';

-- Example 17123
CREATE OR ALTER SECURE FUNCTION multiply(a NUMBER, b NUMBER)
  RETURNS NUMBER
  COMMENT = 'Multiply two numbers.'
  AS 'a * b';

-- Example 17124
CREATE [ OR REPLACE ] FUNCTION <name> ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  SERVICE = <service_name>
  ENDPOINT = <endpoint_name>
  [ COMMENT = '<string_literal>' ]
  [ CONTEXT_HEADERS = ( <context_function_1> [ , <context_function_2> ...] ) ]
  [ MAX_BATCH_ROWS = <integer> ]
  AS '<http_path_to_request_handler>'

-- Example 17125
CREATE [ OR ALTER ] FUNCTION ...

-- Example 17126
CONTEXT_HEADERS = (current_timestamp)

-- Example 17127
select
  /*ÄÎßë¬±©®*/
  my_service_function(1);

-- Example 17128
select /* */ my_service_function(1);

-- Example 17129
base64_encode('select\n/ÄÎßë¬±©®/\nmy_service_function(1)')

-- Example 17130
sf-context-<context-function>-base64

