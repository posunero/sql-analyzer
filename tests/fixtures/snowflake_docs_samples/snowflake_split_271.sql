-- Example 18135
-------------------------------------
|"COL1"  |"COL2"  |"COL3"  |"COL4"  |
-------------------------------------
|1       |a       |True    |1.23    |
|2       |b       |False   |4.56    |
-------------------------------------

-- Example 18136
import pandas as pd

pandas_df = pd.DataFrame(
    data={
        "col1": pd.Series(["value1", "value2"]),
        "col2": pd.Series([1.23, 4.56]),
        "col3": pd.Series([123, 456]),
        "col4": pd.Series([True, False]),
    }
)

dataframe = session.create_dataframe(data=pandas_df)
dataframe.show()

-- Example 18137
-------------------------------------
|"col1"  |"col2"  |"col3"  |"col4"  |
-------------------------------------
|value1  |1.23    |123     |True    |
|value2  |4.56    |456     |False   |
-------------------------------------

-- Example 18138
from snowflake.snowpark.types import StructType, StructField, StringType, DoubleType, LongType, BooleanType

dataframe = session.create_dataframe(
    data=[
        ["value1", 1.23, 123, True],
        ["value2", 4.56, 456, False],
    ],
    schema=StructType([
        StructField("col1", StringType()),
        StructField("col2", DoubleType()),
        StructField("col3", LongType()),
        StructField("col4", BooleanType()),
    ])
)

pandas_dataframe = dataframe.to_pandas()
print(pandas_dataframe.to_string())

-- Example 18139
COL1  COL2  COL3   COL4
0  value1  1.23   123   True
1  value2  4.56   456  False

-- Example 18140
# test/conftest.py
import pytest
from snowflake.snowpark.session import Session

def pytest_addoption(parser):
    parser.addoption("--snowflake-session", action="store", default="live")

@pytest.fixture(scope='module')
def session(request) -> Session:
    if request.config.getoption('--snowflake-session') == 'local':
        return Session.builder.config('local_testing', True).create()
    else:
        return Session.builder.configs(CONNECTION_PARAMETERS).create()

-- Example 18141
# Using local mode:
pytest --snowflake-session local

# Using live mode
pytest

-- Example 18142
from unittest import mock
from functools import partial

def test_something(pytestconfig, session):

    def mock_sql(session, sql_string):  # patch for SQL operations
        if sql_string == "select 1,2,3":
            return session.create_dataframe([[1,2,3]])
        else:
            raise RuntimeError(f"Unexpected query execution: {sql_string}")

    if pytestconfig.getoption('--snowflake-session') == 'local':
        with mock.patch.object(session, 'sql', wraps=partial(mock_sql, session)): # apply patch for SQL operations
            assert session.sql("select 1,2,3").collect() == [Row(1,2,3)]
    else:
        assert session.sql("select 1,2,3").collect() == [Row(1,2,3)]

-- Example 18143
import datetime
from snowflake.snowpark.mock import patch, ColumnEmulator, ColumnType
from snowflake.snowpark.functions import to_timestamp
from snowflake.snowpark.types import TimestampType

@patch(to_timestamp)
def mock_to_timestamp(column: ColumnEmulator, format = None) -> ColumnEmulator:
    ret_column = ColumnEmulator(data=[datetime.datetime.strptime(row, '%Y-%m-%dT%H:%M:%S%z') for row in column])
    ret_column.sf_type = ColumnType(TimestampType(), True)
    return ret_column

-- Example 18144
import pytest

@pytest.mark.skipif(
    condition="config.getvalue('local_testing_mode') == 'local'",
reason="Test case disabled for local testing"
)
def test_case(session):
    ...

-- Example 18145
from snowflake.snowpark.session import Session
from snowflake.snowpark.dataframe import col, DataFrame
from snowflake.snowpark.functions import udf, sproc, call_udf
from snowflake.snowpark.types import IntegerType, StringType

# Create local session
session = Session.builder.config('local_testing', True).create()

# Create local table
table = 'example'
session.create_dataframe([[1,2],[3,4]],['a','b']).write.save_as_table(table)

# Register a UDF, which is called from the stored procedure
@udf(name='example_udf', return_type=IntegerType(), input_types=[IntegerType(), IntegerType()])
def example_udf(a, b):
    return a + b

# Register stored procedure
@sproc(name='example_proc', return_type=IntegerType(), input_types=[StringType()])
def example_proc(session, table_name):
    return session.table(table_name)\
        .with_column('c', call_udf('example_udf', col('a'), col('b')))\
        .count()

# Call the stored procedure by name
output = session.call('example_proc', table)

print(output)

-- Example 18146
# Selecting window function expressions is supported
df.select("key", "value", sum_("value").over(), avg("value").over())

# Aggregating window function expressions is NOT supported
df.group_by("key").agg([sum_("value"), sum_(sum_("value")).over(window) - sum_("value")])

-- Example 18147
df.select(lit(1), lit(1)).show() # col("a"), col("a")
#---------
#|"'1'"  |
#---------
#|1      |
#|...    |
#---------

# Workaround: Column.alias
DataFrame.select(lit(1).alias("col1_1"), lit(1).alias("col1_2"))
# "col1_1", "col1_2"

-- Example 18148
{
    "Flood": flood_date_array::VARIANT,
    "Earthquake": earthquake_date_array::VARIANT,
    ...
}

-- Example 18149
[
    {
        "Event_ID": 54::VARIANT,
        "Type": "Earthquake"::VARIANT,
        "Magnitude": 7.4::VARIANT,
        "Timestamp": "2018-06-09 12:32:15"::TIMESTAMP_LTZ::VARIANT
        ...
    }::VARIANT,
    {
        "Event_ID": 55::VARIANT,
        "Type": "Tornado"::VARIANT,
        "Maximum_wind_speed": 186::VARIANT,
        "Timestamp": "2018-07-01 09:42:55"::TIMESTAMP_LTZ::VARIANT
        ...
    }::VARIANT
]

-- Example 18150
CREATE TABLE my_table (my_variant_column VARIANT);
COPY INTO my_table ... FILE FORMAT = (TYPE = 'JSON') ...

-- Example 18151
INSERT INTO my_table (my_variant_column) SELECT PARSE_JSON('{...}');

-- Example 18152
SELECT CAST('2022-04-01' AS DATE);

SELECT '2022-04-01'::DATE;

SELECT TO_DATE('2022-04-01');

-- Example 18153
SELECT date_column
  FROM log_table
  WHERE date_column >= '2022-04-01'::DATE;

-- Example 18154
SELECT my_float_function(my_integer_column)
  FROM my_table;

-- Example 18155
SELECT 17 || '76';

-- Example 18156
SELECT ...
  FROM my_table
  WHERE my_integer_column < my_float_column;

-- Example 18157
SELECT height * width::VARCHAR || ' square meters'
  FROM dimensions;

-- Example 18158
... height * (width::VARCHAR) ...

-- Example 18159
SELECT (height * width)::VARCHAR || ' square meters'
  FROM dimensions;

-- Example 18160
SELECT -0.0::FLOAT::BOOLEAN;

-- Example 18161
SELECT (-0.0::FLOAT)::BOOLEAN;

-- Example 18162
SELECT -(0.0::FLOAT::BOOLEAN);

-- Example 18163
SELECT 12.3::FLOAT::NUMBER(3,2);

-- Example 18164
CREATE OR REPLACE TABLE convert_test_zeros (
  varchar1 VARCHAR,
  float1 FLOAT,
  variant1 VARIANT);

INSERT INTO convert_test_zeros SELECT
  '5.000',
  5.000,
  PARSE_JSON('{"Loan Number": 5.000}');

-- Example 18165
SELECT varchar1,
       float1::VARCHAR,
       variant1:"Loan Number"::VARCHAR
  FROM convert_test_zeros;

-- Example 18166
+----------+-----------------+---------------------------------+
| VARCHAR1 | FLOAT1::VARCHAR | VARIANT1:"LOAN NUMBER"::VARCHAR |
|----------+-----------------+---------------------------------|
| 5.000    | 5               | 5                               |
+----------+-----------------+---------------------------------+

-- Example 18167
SELECT SYSTEM$TYPEOF(IFNULL(12.3, 0)),
       SYSTEM$TYPEOF(IFNULL(NULL, 0));

-- Example 18168
+--------------------------------+--------------------------------+
| SYSTEM$TYPEOF(IFNULL(12.3, 0)) | SYSTEM$TYPEOF(IFNULL(NULL, 0)) |
|--------------------------------+--------------------------------|
| NUMBER(3,1)[SB1]               | NUMBER(1,0)[SB1]               |
+--------------------------------+--------------------------------+

-- Example 18169
SHOW COLUMNS [ LIKE '<pattern>' ]
             [ IN { ACCOUNT | DATABASE [ <database_name> ] | SCHEMA [ <schema_name> ] | TABLE | [ TABLE ] <table_name> | VIEW | [ VIEW ] <view_name> } | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> ]

-- Example 18170
create or replace table dt_test (n1 number default 5, n2_int integer default n1+5, n3_bigint bigint autoincrement, n4_dec decimal identity (1,10),
                                 f1 float, f2_double double, f3_real real,
                                 s1 string, s2_var varchar, s3_char char, s4_text text,
                                 b1 binary, b2_var varbinary,
                                 bool1 boolean,
                                 d1 date,
                                 t1 time,
                                 ts1 timestamp, ts2_ltz timestamp_ltz, ts3_ntz timestamp_ntz, ts4_tz timestamp_tz);

show columns in table dt_test;

+------------+-------------+-------------+---------------------------------------------------------------------------------------+-------+----------------+--------+------------+---------+---------------+-------------------------------+
| table_name | schema_name | column_name | data_type                                                                             | null? | default        | kind   | expression | comment | database_name | autoincrement                 |
|------------+-------------+-------------+---------------------------------------------------------------------------------------+-------+----------------+--------+------------+---------+---------------+-------------------------------|
| DT_TEST    | PUBLIC      | N1          | {"type":"FIXED","precision":38,"scale":0,"nullable":true}                             | true  | 5              | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | N2_INT      | {"type":"FIXED","precision":38,"scale":0,"nullable":true}                             | true  | DT_TEST.N1 + 5 | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | N3_BIGINT   | {"type":"FIXED","precision":38,"scale":0,"nullable":true}                             | true  |                | COLUMN |            |         | TEST1         | IDENTITY START 1 INCREMENT 1  |
| DT_TEST    | PUBLIC      | N4_DEC      | {"type":"FIXED","precision":38,"scale":0,"nullable":true}                             | true  |                | COLUMN |            |         | TEST1         | IDENTITY START 1 INCREMENT 10 |
| DT_TEST    | PUBLIC      | F1          | {"type":"REAL","nullable":true}                                                       | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | F2_DOUBLE   | {"type":"REAL","nullable":true}                                                       | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | F3_REAL     | {"type":"REAL","nullable":true}                                                       | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | S1          | {"type":"TEXT","length":16777216,"byteLength":16777216,"nullable":true,"fixed":false} | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | S2_VAR      | {"type":"TEXT","length":16777216,"byteLength":16777216,"nullable":true,"fixed":false} | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | S3_CHAR     | {"type":"TEXT","length":1,"byteLength":4,"nullable":true,"fixed":false}               | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | S4_TEXT     | {"type":"TEXT","length":16777216,"byteLength":16777216,"nullable":true,"fixed":false} | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | B1          | {"type":"BINARY","length":8388608,"byteLength":8388608,"nullable":true,"fixed":true}  | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | B2_VAR      | {"type":"BINARY","length":8388608,"byteLength":8388608,"nullable":true,"fixed":false} | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | BOOL1       | {"type":"BOOLEAN","nullable":true}                                                    | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | D1          | {"type":"DATE","nullable":true}                                                       | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | T1          | {"type":"TIME","precision":0,"scale":9,"nullable":true}                               | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | TS1         | {"type":"TIMESTAMP_LTZ","precision":0,"scale":9,"nullable":true}                      | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | TS2_LTZ     | {"type":"TIMESTAMP_LTZ","precision":0,"scale":9,"nullable":true}                      | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | TS3_NTZ     | {"type":"TIMESTAMP_NTZ","precision":0,"scale":9,"nullable":true}                      | true  |                | COLUMN |            |         | TEST1         |                               |
| DT_TEST    | PUBLIC      | TS4_TZ      | {"type":"TIMESTAMP_TZ","precision":0,"scale":9,"nullable":true}                       | true  |                | COLUMN |            |         | TEST1         |                               |
+------------+-------------+-------------+---------------------------------------------------------------------------------------+-------+----------------+--------+------------+---------+---------------+-------------------------------+

-- Example 18171
DESC[RIBE] RESULT { '<query_id>' | LAST_QUERY_ID() }

-- Example 18172
SELECT LAST_QUERY_ID(-2);

-- Example 18173
DESC RESULT 'f2f07bdb-6a08-4689-9ad8-a1ba968a44b6';

-- Example 18174
SELECT * FROM boston_sales;

+---------------+-------+-------+--------+-------------+---------------------+-------+
| CITY          | ZIP   | STATE | SQ__FT | TYPE        | SALE_DATE           | PRICE |
|---------------+-------+-------+--------+-------------+---------------------+-------|
| MA-Lexington  | 40502 | MA    |    836 | Residential | 0016-01-25T00:00:00 | 59222 |
| MA-Belmont    | 02478 | MA    |    852 | Residential | 0016-02-21T00:00:00 | 69307 |
| MA-Winchester | 01890 | MA    |   1122 | Condo       | 0016-01-31T00:00:00 | 89921 |
+---------------+-------+-------+--------+-------------+---------------------+-------+

DESC RESULT LAST_QUERY_ID();

+-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name      | type              | kind   | null? | default | primary key | unique key | check | expression | comment |
|-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| CITY      | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| ZIP       | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| STATE     | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| SQ__FT    | NUMBER(38,0)      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| TYPE      | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| SALE_DATE | DATE              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| PRICE     | NUMBER(38,0)      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+

-- Example 18175
DESC[RIBE] FUNCTION <name> ( [ <arg_data_type> ] [ , ... ] )

-- Example 18176
DESC FUNCTION multiply(number, number);

-----------+----------------------------------+
 property  |              value               |
-----------+----------------------------------+
 signature | (a NUMBER(38,0), b NUMBER(38,0)) |
 returns   | NUMBER(38,0)                     |
 language  | SQL                              |
 body      | a * b                            |
-----------+----------------------------------+

-- Example 18177
DESC[RIBE] PROCEDURE <procedure_name> ( [ <arg_data_type> [ , <arg_data_type_2> ... ] ] )

-- Example 18178
DESC PROCEDURE my_pi();
+---------------+----------------------+
| property      | value                |
|---------------+----------------------|
| signature     | ()                   |
| returns       | FLOAT                |
| language      | JAVASCRIPT           |
| null handling | CALLED ON NULL INPUT |
| volatility    | VOLATILE             |
| execute as    | CALLER               |
| body          |                      |
|               |   return 3.1415926;  |
|               |                      |
+---------------+----------------------+

-- Example 18179
DESC PROCEDURE area_of_circle(FLOAT);
+---------------+------------------------------------------------------------------+
| property      | value                                                            |
|---------------+------------------------------------------------------------------|
| signature     | (RADIUS FLOAT)                                                   |
| returns       | FLOAT                                                            |
| language      | JAVASCRIPT                                                       |
| null handling | CALLED ON NULL INPUT                                             |
| volatility    | VOLATILE                                                         |
| execute as    | OWNER                                                            |
| body          |                                                                  |
|               |   var stmt = snowflake.createStatement(                          |
|               |       {sqlText: "SELECT pi() * POW($RADIUS, 2)", binds:[RADIUS]} |
|               |       );                                                         |
|               |   var rs = stmt.execute();                                       |
|               |   rs.next()                                                      |
|               |   var output = rs.getColumnValue(1);                             |
|               |   return output;                                                 |
|               |                                                                  |
+---------------+------------------------------------------------------------------+

-- Example 18180
SHOW FUNCTIONS [ LIKE '<pattern>' ]
  [ IN
    {
      ACCOUNT                       |

      CLASS <class_name>            |

      DATABASE                      |
      DATABASE <database_name>      |

      SCHEMA                        |
      SCHEMA <schema_name>          |
      <schema_name>
    }
  ]

-- Example 18181
| name | min_num_arguments | max_num_arguments | arguments | descriptions | language |

-- Example 18182
SHOW FUNCTIONS;

-- Example 18183
SHOW FUNCTIONS LIKE 'SQUARE';

-- Example 18184
------------+--------+-------------+------------+--------------+---------+-------------------+-------------------+----------------------------------------------------------------------+------------------------------------------------------------+----------+---------------+----------------+
 created_on | name   | schema_name | is_builtin | is_aggregate | is_ansi | min_num_arguments | max_num_arguments |                               arguments                              |                      description                           | language | is_memoizable | is_data_metric |
------------+--------+-------------+------------+--------------+---------+-------------------+-------------------+----------------------------------------------------------------------+------------------------------------------------------------+----------+---------------+----------------+
            | SQUARE |             | Y          | N            | Y       | 1                 | 1                 | SQUARE(NUMBER(38,0)) RETURN NUMBER(38,0), SQUARE(FLOAT) RETURN FLOAT | Compute the square of the input expression.                | SQL      | N             | N              |
------------+--------+-------------+------------+--------------+---------+-------------------+-------------------+----------------------------------------------------------------------+------------------------------------------------------------+----------+---------------+----------------+

-- Example 18185
SHOW PROCEDURES [ LIKE '<pattern>' ]
  [ IN
    {
      ACCOUNT                                         |

      CLASS <class_name>                              |

      DATABASE                                        |
      DATABASE <database_name>                        |

      SCHEMA                                          |
      SCHEMA <schema_name>                            |
      <schema_name>

      APPLICATION <application_name>                  |
      APPLICATION PACKAGE <application_package_name>  |
    }
  ]

-- Example 18186
| name | min_num_arguments | max_num_arguments | arguments | descriptions | language |

-- Example 18187
SHOW PROCEDURES;

-- Example 18188
SHOW PROCEDURES LIKE 'area_of_%';
+-------------------------------+----------------+--------------------+------------+--------------+---------+-------------------+-------------------+------------------------------------+------------------------+-----------------------+-------------------+----------------------+-----------+
| created_on                    | name           | schema_name        | is_builtin | is_aggregate | is_ansi | min_num_arguments | max_num_arguments | arguments                          | description            | catalog_name          | is_table_function | valid_for_clustering | is_secure |
|-------------------------------+----------------+--------------------+------------+--------------+---------+-------------------+-------------------+------------------------------------+------------------------+-----------------------+-------------------+----------------------+-----------|
| 1967-06-23 00:00:00.123 -0700 | AREA_OF_CIRCLE | TEMPORARY_DOC_TEST | N          | N            | N       |                 1 |                 1 | AREA_OF_CIRCLE(FLOAT) RETURN FLOAT | user-defined procedure | TEMPORARY_DOC_TEST_DB | N                 | N                    | N         |
+-------------------------------+----------------+--------------------+------------+--------------+---------+-------------------+-------------------+------------------------------------+------------------------+-----------------------+-------------------+----------------------+-----------+

-- Example 18189
USE DATABASE mydb;
SELECT *
    FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'myTable';

-- Example 18190
conn.cursor().execute("CREATE WAREHOUSE IF NOT EXISTS tiny_warehouse_mg")
conn.cursor().execute("CREATE DATABASE IF NOT EXISTS testdb_mg")
conn.cursor().execute("USE DATABASE testdb_mg")
conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS testschema_mg")

-- Example 18191
conn.cursor().execute("USE WAREHOUSE tiny_warehouse_mg")
conn.cursor().execute("USE DATABASE testdb_mg")
conn.cursor().execute("USE SCHEMA testdb_mg.testschema_mg")

-- Example 18192
conn.cursor().execute(
    "CREATE OR REPLACE TABLE "
    "test_table(col1 integer, col2 string)")

conn.cursor().execute(
    "INSERT INTO test_table(col1, col2) VALUES " + 
    "    (123, 'test string1'), " + 
    "    (456, 'test string2')")

-- Example 18193
# Putting Data
con.cursor().execute("PUT file:///tmp/data/file* @%testtable")
con.cursor().execute("COPY INTO testtable")

-- Example 18194
# Copying Data
con.cursor().execute("""
COPY INTO testtable FROM s3://<s3_bucket>/data/
    STORAGE_INTEGRATION = myint
    FILE_FORMAT=(field_delimiter=',')
""".format(
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY))

-- Example 18195
conn = snowflake.connector.connect( ... )
cur = conn.cursor()
cur.execute('select * from products')

-- Example 18196
conn = snowflake.connector.connect( ... )
cur = conn.cursor()
# Submit an asynchronous query for execution.
cur.execute_async('select count(*) from table(generator(timeLimit => 25))')

-- Example 18197
# Retrieving a Snowflake Query ID
cur = con.cursor()
cur.execute("SELECT * FROM testtable")
print(cur.sfqid)

-- Example 18198
import time
...
# Execute a long-running query asynchronously.
cur.execute_async('select count(*) from table(generator(timeLimit => 25))')
...
# Wait for the query to finish running.
query_id = cur.sfqid
while conn.is_still_running(conn.get_query_status(query_id)):
  time.sleep(1)

-- Example 18199
from snowflake.connector import ProgrammingError
import time
...
# Wait for the query to finish running and raise an error
# if a problem occurred with the execution of the query.
try:
  query_id = cur.sfqid
  while conn.is_still_running(conn.get_query_status_throw_if_error(query_id)):
    time.sleep(1)
except ProgrammingError as err:
  print('Programming Error: {0}'.format(err))

-- Example 18200
# Get the results from a query.
cur.get_results_from_sfqid(query_id)
results = cur.fetchall()
print(f'{results[0]}')

-- Example 18201
cur = conn.cursor()
try:
    cur.execute("SELECT col1, col2 FROM test_table ORDER BY col1")
    for (col1, col2) in cur:
        print('{0}, {1}'.format(col1, col2))
finally:
    cur.close()

