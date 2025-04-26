-- Example 18202
for (col1, col2) in con.cursor().execute("SELECT col1, col2 FROM testtable"):
    print('{0}, {1}'.format(col1, col2))

-- Example 18203
col1, col2 = con.cursor().execute("SELECT col1, col2 FROM testtable").fetchone()
print('{0}, {1}'.format(col1, col2))

-- Example 18204
cur = con.cursor().execute("SELECT col1, col2 FROM testtable")
ret = cur.fetchmany(3)
print(ret)
while len(ret) > 0:
    ret = cur.fetchmany(3)
    print(ret)

-- Example 18205
results = con.cursor().execute("SELECT col1, col2 FROM testtable").fetchall()
for rec in results:
    print('%s, %s' % (rec[0], rec[1]))

-- Example 18206
conn.cursor().execute("create or replace table testtbl(a int, b string)")

conn.cursor().execute("begin")
try:
   conn.cursor().execute("insert into testtbl(a,b) values(3, 'test3'), (4,'test4')", timeout=10) # long query

except ProgrammingError as e:
   if e.errno == 604:
      print("timeout")
      conn.cursor().execute("rollback")
   else:
      raise e
else:
   conn.cursor().execute("commit")

-- Example 18207
# Querying data by DictCursor
from snowflake.connector import DictCursor
cur = con.cursor(DictCursor)
try:
    cur.execute("SELECT col1, col2 FROM testtable")
    for rec in cur:
        print('{0}, {1}'.format(rec['COL1'], rec['COL2']))
finally:
    cur.close()

-- Example 18208
from snowflake.connector import ProgrammingError
import time

conn = snowflake.connector.connect( ... )
cur = conn.cursor()

# Submit an asynchronous query for execution.
cur.execute_async('select count(*) from table(generator(timeLimit => 25))')

# Retrieve the results.
cur.get_results_from_sfqid(query_id)
results = cur.fetchall()
print(f'{results[0]}')

-- Example 18209
from snowflake.connector import ProgrammingError
import time

conn = snowflake.connector.connect( ... )
cur = conn.cursor()

# Submit an asynchronous query for execution.
cur.execute_async('select count(*) from table(generator(timeLimit => 25))')

# Get the query ID for the asynchronous query.
query_id = cur.sfqid

# Close the cursor and the connection.
cur.close()
conn.close()

# Open a new connection.
new_conn = snowflake.connector.connect( ... )

# Create a new cursor.
new_cur = new_conn.cursor()

# Retrieve the results.
new_cur.get_results_from_sfqid(query_id)
results = new_cur.fetchall()
print(f'{results[0]}')

-- Example 18210
cur = cn.cursor()

try:
  cur.execute(r"SELECT SYSTEM$CANCEL_QUERY('queryID')")
  result = cur.fetchall()
  print(len(result))
  print(result[0])
finally:
  cur.close()

-- Example 18211
from snowflake.connector.converter_null import SnowflakeNoConverterToPython

con = snowflake.connector.connect(
    ...
    converter_class=SnowflakeNoConverterToPython
)
for rec in con.cursor().execute("SELECT * FROM large_table"):
    # rec includes raw Snowflake data

-- Example 18212
con.cursor().execute("INSERT INTO testtable(col1, col2) VALUES(789, 'test string3')")

-- Example 18213
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%s, %s)", (
        789,
        'test string3'
    ))

-- Example 18214
conn.cursor().execute(
    "INSERT INTO test_table(col1, col2) "
    "VALUES(%(col1)s, %(col2)s)", {
        'col1': 789,
        'col2': 'test string3',
        })

-- Example 18215
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%s, %s)", (
        789,
        'test string3'
    ))

-- Example 18216
# Binding data for IN operator
con.cursor().execute(
    "SELECT col1, col2 FROM testtable"
    " WHERE col2 IN (%s)", (
        ['test string1', 'test string3'],
    ))

-- Example 18217
SELECT col1, col2
    FROM test_table
    WHERE col2 ILIKE '%York' LIMIT 1;  -- Find York, New York, etc.

-- Example 18218
sql_command = "select col1, col2 from test_table "
sql_command += " where col2 like '%%York' limit %(lim)s"
parameter_dictionary = {'lim': 1 }
cur.execute(sql_command, parameter_dictionary)

-- Example 18219
from snowflake.connector import connect

connection_parameters = {
    'account': 'xxxxx',
    'user': 'xxxx',
    'password': 'xxxxxx',
    "host": "xxxxxx",
    "port": 443,
    'protocol': 'https',
    'warehouse': 'xxx',
    'database': 'xxx',
    'schema': 'xxx',
    'paramstyle': 'qmark'  # note paramstyle setting here at connection level
}

con = connect(**connection_parameters)

con.cursor().execute(
    "INSERT INTO testtable2(col1,col2,col3) "
    "VALUES(?,?,?)", (
        987,
        'test string4',
        ("TIMESTAMP_LTZ", datetime.now())
    )
)

-- Example 18220
import snowflake.connector

snowflake.connector.paramstyle='numeric'

con = snowflake.connector.connect(...)

con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(:1, :2)", (
        789,
        'test string3'
    ))

-- Example 18221
con.cursor().execute(
    "INSERT INTO testtable(complete_video, short_sample_of_video) "
    "VALUES(:1, SUBSTRING(:1, :2, :3))", (
        binary_value_that_stores_video,          # variable :1
        starting_offset_in_bytes_of_video_clip,  # variable :2
        length_in_bytes_of_video_clip            # variable :3
    ))

-- Example 18222
import snowflake.connector

snowflake.connector.paramstyle='qmark'

con = snowflake.connector.connect(...)

con.cursor().execute(
    "CREATE OR REPLACE TABLE testtable2 ("
    "   col1 int, "
    "   col2 string, "
    "   col3 timestamp_ltz"
    ")"
)

con.cursor().execute(
    "INSERT INTO testtable2(col1,col2,col3) "
    "VALUES(?,?,?)", (
        987,
        'test string4',
        ("TIMESTAMP_LTZ", datetime.now())
    )
 )

-- Example 18223
insert into grocery (item, quantity) values (?, ?)

-- Example 18224
rows_to_insert = [('milk', 2), ('apple', 3), ('egg', 2)]

-- Example 18225
conn = snowflake.connector.connect( ... )
rows_to_insert = [('milk', 2), ('apple', 3), ('egg', 2)]
conn.cursor().executemany(
    "insert into grocery (item, quantity) values (?, ?)",
    rows_to_insert)

-- Example 18226
CREATE TEMPORARY STAGE SYSTEM$BIND file_format=(type=csv field_optionally_enclosed_by='"')
Cannot perform CREATE STAGE. This session does not have a current schema. Call 'USE SCHEMA', or use a qualified name.

-- Example 18227
# Binding data (UNSAFE EXAMPLE)
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%(col1)d, '%(col2)s')" % {
        'col1': 789,
        'col2': 'test string3'
    })

-- Example 18228
# Binding data (UNSAFE EXAMPLE)
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%d, '%s')" % (
        789,
        'test string3'
    ))

-- Example 18229
# Binding data (UNSAFE EXAMPLE)
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES({col1}, '{col2}')".format(
        col1=789,
        col2='test string3')
    )

-- Example 18230
cur = conn.cursor()
cur.execute("SELECT * FROM test_table")
print(','.join([col[0] for col in cur.description]))

-- Example 18231
cur = conn.cursor()
cur.execute("SELECT * FROM test_table")
print(','.join([col.name for col in cur.description]))

-- Example 18232
cur = conn.cursor()
result_metadata_list = cur.describe("SELECT * FROM test_table")
print(','.join([col.name for col in result_metadata_list]))

-- Example 18233
# Catching the syntax error
cur = con.cursor()
try:
    cur.execute("SELECT * FROM testtable")
except snowflake.connector.errors.ProgrammingError as e:
    # default error message
    print(e)
    # customer error message
    print('Error {0} ({1}): {2} ({3})'.format(e.errno, e.sqlstate, e.msg, e.sfqid))
finally:
    cur.close()

-- Example 18234
from codecs import open
with open(sqlfile, 'r', encoding='utf-8') as f:
    for cur in con.execute_stream(f):
        for ret in cur:
            print(ret)

-- Example 18235
connection.close()

-- Example 18236
# Connecting to Snowflake
con = snowflake.connector.connect(...)
try:
    # Running queries
    con.cursor().execute(...)
    ...
finally:
    # Closing the connection
    con.close()

-- Example 18237
# Connecting to Snowflake using the context manager
with snowflake.connector.connect(
  user=USER,
  password=PASSWORD,
  account=ACCOUNT,
  autocommit=False,
) as con:
    con.cursor().execute("INSERT INTO a VALUES(1, 'test1')")
    con.cursor().execute("INSERT INTO a VALUES(2, 'test2')")
    con.cursor().execute("INSERT INTO a VALUES(not numeric value, 'test3')") # fail

-- Example 18238
# Connecting to Snowflake using try and except blocks
con = snowflake.connector.connect(
  user=USER,
  password=PASSWORD,
  account=ACCOUNT,
  autocommit=False)
try:
    con.cursor().execute("INSERT INTO a VALUES(1, 'test1')")
    con.cursor().execute("INSERT INTO a VALUES(2, 'test2')")
    con.cursor().execute("INSERT INTO a VALUES(not numeric value, 'test3')") # fail
    con.commit()
except Exception as e:
    con.rollback()
    raise e
finally:
    con.close()

-- Example 18239
import snowflake.connector

conn = ... # Set up connection
cur = conn.cursor()

# Create a table and insert some vectors
cur.execute("CREATE OR REPLACE TABLE vectors (a VECTOR(FLOAT, 3), b VECTOR(FLOAT, 3))")
values = [([1.1, 2.2, 3], [1, 1, 1]), ([1, 2.2, 3], [4, 6, 8])]
for row in values:
    cur.execute(f"""
        INSERT INTO vectors(a, b)
          SELECT {row[0]}::VECTOR(FLOAT,3), {row[1]}::VECTOR(FLOAT,3)
    """)

# Compute the pairwise inner product between columns a and b
cur.execute("SELECT VECTOR_INNER_PRODUCT(a, b) FROM vectors")
print(cur.fetchall())

-- Example 18240
[(6.30...,), (41.2...,)]

-- Example 18241
cur.execute(f"""
    SELECT a, VECTOR_COSINE_SIMILARITY(a, {[1,2,3]}::VECTOR(FLOAT, 3))
      AS similarity
      FROM vectors
      ORDER BY similarity DESC
      LIMIT 1;
""")
print(cur.fetchall())

-- Example 18242
[([1.0, 2.2..., 3.0], 0.9990...)]

-- Example 18243
logging.basicConfig(
    filename=file_name,
    level=logging.INFO)

-- Example 18244
# Logging including the timestamp, thread and the source code location
import logging
for logger_name in ['snowflake.connector', 'botocore', 'boto3']:
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler('/tmp/python_connector.log')
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(logging.Formatter('%(asctime)s - %(threadName)s %(filename)s:%(lineno)d - %(funcName)s() - %(levelname)s - %(message)s'))
    logger.addHandler(ch)

-- Example 18245
# Logging including the timestamp, thread and the source code location
import logging
from snowflake.connector.secret_detector import SecretDetector
for logger_name in ['snowflake.connector', 'botocore', 'boto3']:
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler('/tmp/python_connector.log')
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(SecretDetector('%(asctime)s - %(threadName)s %(filename)s:%(lineno)d - %(funcName)s() - %(levelname)s - %(message)s'))
    logger.addHandler(ch)

-- Example 18246
[log]
save_logs = true
level = "INFO"
path = "<directory to store logs>"

-- Example 18247
# -- (> ---------------------- SECTION=import_connector ---------------------
...
# -- <) ---------------------------- END_SECTION ----------------------------

-- Example 18248
import logging
import os
import sys


# -- (> ---------------------- SECTION=import_connector ---------------------
import snowflake.connector
# -- <) ---------------------------- END_SECTION ----------------------------


class python_veritas_base:

    """
    PURPOSE:
        This is the Base/Parent class for programs that use the Snowflake
        Connector for Python.
        This class is intended primarily for:
            * Sample programs, e.g. in the documentation.
            * Tests.
    """


    def __init__(self, p_log_file_name = None):

        """
        PURPOSE:
            This does any required initialization steps, which in this class is
            basically just turning on logging.
        """

        file_name = p_log_file_name
        if file_name is None:
            file_name = '/tmp/snowflake_python_connector.log'

        # -- (> ---------- SECTION=begin_logging -----------------------------
        logging.basicConfig(
            filename=file_name,
            level=logging.INFO)
        # -- <) ---------- END_SECTION ---------------------------------------


    # -- (> ---------------------------- SECTION=main ------------------------
    def main(self, argv):

        """
        PURPOSE:
            Most tests follow the same basic pattern in this main() method:
               * Create a connection.
               * Set up, e.g. use (or create and use) the warehouse, database,
                 and schema.
               * Run the queries (or do the other tasks, e.g. load data).
               * Clean up. In this test/demo, we drop the warehouse, database,
                 and schema. In a customer scenario, you'd typically clean up
                 temporary tables, etc., but wouldn't drop your database.
               * Close the connection.
        """

        # Read the connection parameters (e.g. user ID) from the command line
        # and environment variables, then connect to Snowflake.
        connection = self.create_connection(argv)

        # Set up anything we need (e.g. a separate schema for the test/demo).
        self.set_up(connection)

        # Do the "real work", for example, create a table, insert rows, SELECT
        # from the table, etc.
        self.do_the_real_work(connection)

        # Clean up. In this case, we drop the temporary warehouse, database, and
        # schema.
        self.clean_up(connection)

        print("\nClosing connection...")
        # -- (> ------------------- SECTION=close_connection -----------------
        connection.close()
        # -- <) ---------------------------- END_SECTION ---------------------

    # -- <) ---------------------------- END_SECTION=main --------------------


    def args_to_properties(self, args):

        """
        PURPOSE:
            Read the command-line arguments and store them in a dictionary.
            Command-line arguments should come in pairs, e.g.:
                "--user MyUser"
        INPUTS:
            The command line arguments (sys.argv).
        RETURNS:
            Returns the dictionary.
        DESIRABLE ENHANCEMENTS:
            Improve error detection and handling.
        """

        connection_parameters = {}

        i = 1
        while i < len(args) - 1:
            property_name = args[i]
            # Strip off the leading "--" from the tag, e.g. from "--user".
            property_name = property_name[2:]
            property_value = args[i + 1]
            connection_parameters[property_name] = property_value
            i += 2

        return connection_parameters


    def create_connection(self, argv):

        """
        PURPOSE:
            This gets account identifier and login information from the
            environment variables and command-line parameters, connects to the
            server, and returns the connection object.
        INPUTS:
            argv: This is usually sys.argv, which contains the command-line
                  parameters. It could be an equivalent substitute if you get
                  the parameter information from another source.
        RETURNS:
            A connection.
        """

        # Get account identifier and login information from environment variables and command-line parameters.
        # For information about account identifiers, see
        # https://docs.snowflake.com/en/user-guide/admin-account-identifier.html .
        # -- (> ----------------------- SECTION=set_login_info ---------------

        # Get the password from an appropriate environment variable, if
        # available.
        PASSWORD = os.getenv('SNOWSQL_PWD')

        # Get the other login info etc. from the command line.
        if len(argv) < 11:
            msg = "ERROR: Please pass the following command-line parameters:\n"
            msg += "--warehouse <warehouse> --database <db> --schema <schema> "
            msg += "--user <user> --account <account_identifier> "
            print(msg)
            sys.exit(-1)
        else:
            connection_parameters = self.args_to_properties(argv)
            USER = connection_parameters["user"]
            ACCOUNT = connection_parameters["account"]
            WAREHOUSE = connection_parameters["warehouse"]
            DATABASE = connection_parameters["database"]
            SCHEMA = connection_parameters["schema"]
            # Optional: for internal testing only.
            try:
                PORT = connection_parameters["port"]
            except:
                PORT = ""
            try:
                PROTOCOL = connection_parameters["protocol"]
            except:
                PROTOCOL = ""

        # If the password is set by both command line and env var, the
        # command-line value takes precedence over (is written over) the
        # env var value.

        # If the password wasn't set either in the environment var or on
        # the command line...
        if PASSWORD is None or PASSWORD == '':
            print("ERROR: Set password, e.g. with SNOWSQL_PWD environment variable")
            sys.exit(-2)
        # -- <) ---------------------------- END_SECTION ---------------------

        # Optional diagnostic:
        #print("USER:", USER)
        #print("ACCOUNT:", ACCOUNT)
        #print("WAREHOUSE:", WAREHOUSE)
        #print("DATABASE:", DATABASE)
        #print("SCHEMA:", SCHEMA)
        #print("PASSWORD:", PASSWORD)
        #print("PROTOCOL:" "'" + PROTOCOL + "'")
        #print("PORT:" + "'" + PORT + "'")

        print("Connecting...")
        # If the PORT is set but the protocol is not, we ignore the PORT (bug!!).
        if PROTOCOL is None or PROTOCOL == "" or PORT is None or PORT == "":
            # -- (> ------------------- SECTION=connect_to_snowflake ---------
            conn = snowflake.connector.connect(
                user=USER,
                password=PASSWORD,
                account=ACCOUNT,
                warehouse=WAREHOUSE,
                database=DATABASE,
                schema=SCHEMA
                )
            # -- <) ---------------------------- END_SECTION -----------------
        else:

            conn = snowflake.connector.connect(
                user=USER,
                password=PASSWORD,
                account=ACCOUNT,
                warehouse=WAREHOUSE,
                database=DATABASE,
                schema=SCHEMA,
                # Optional: for internal testing only.
                protocol=PROTOCOL,
                port=PORT
                )

        return conn


    def set_up(self, connection):

        """
        PURPOSE:
            Set up to run a test. You can override this method with one
            appropriate to your test/demo.
        """

        # Create a temporary warehouse, database, and schema.
        self.create_warehouse_database_and_schema(connection)


    def do_the_real_work(self, conn):

        """
        PURPOSE:
            Your sub-class should override this to include the code required for
            your documentation sample or your test case.
            This default method does a very simple self-test that shows that the
            connection was successful.
        """

        # Create a cursor for this connection.
        cursor1 = conn.cursor()
        # This is an example of an SQL statement we might want to run.
        command = "SELECT PI()"
        # Run the statement.
        cursor1.execute(command)
        # Get the results (should be only one):
        for row in cursor1:
            print(row[0])
        # Close this cursor.
        cursor1.close()


    def clean_up(self, connection):

        """
        PURPOSE:
            Clean up after a test. You can override this method with one
            appropriate to your test/demo.
        """

        # Create a temporary warehouse, database, and schema.
        self.drop_warehouse_database_and_schema(connection)


    def create_warehouse_database_and_schema(self, conn):

        """
        PURPOSE:
            Create the temporary schema, database, and warehouse that we use
            for most tests/demos.
        """

        # Create a database, schema, and warehouse if they don't already exist.
        print("\nCreating warehouse, database, schema...")
        # -- (> ------------- SECTION=create_warehouse_database_schema -------
        conn.cursor().execute("CREATE WAREHOUSE IF NOT EXISTS tiny_warehouse_mg")
        conn.cursor().execute("CREATE DATABASE IF NOT EXISTS testdb_mg")
        conn.cursor().execute("USE DATABASE testdb_mg")
        conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS testschema_mg")
        # -- <) ---------------------------- END_SECTION ---------------------

        # -- (> --------------- SECTION=use_warehouse_database_schema --------
        conn.cursor().execute("USE WAREHOUSE tiny_warehouse_mg")
        conn.cursor().execute("USE DATABASE testdb_mg")
        conn.cursor().execute("USE SCHEMA testdb_mg.testschema_mg")
        # -- <) ---------------------------- END_SECTION ---------------------


    def drop_warehouse_database_and_schema(self, conn):

        """
        PURPOSE:
            Drop the temporary schema, database, and warehouse that we create
            for most tests/demos.
        """

        # -- (> ------------- SECTION=drop_warehouse_database_schema ---------
        conn.cursor().execute("DROP SCHEMA IF EXISTS testschema_mg")
        conn.cursor().execute("DROP DATABASE IF EXISTS testdb_mg")
        conn.cursor().execute("DROP WAREHOUSE IF EXISTS tiny_warehouse_mg")
        # -- <) ---------------------------- END_SECTION ---------------------


# ----------------------------------------------------------------------------

if __name__ == '__main__':
    pvb = python_veritas_base()
    pvb.main(sys.argv)

-- Example 18249
import sys

# -- (> ---------------------- SECTION=import_connector ---------------------
import snowflake.connector
# -- <) ---------------------------- END_SECTION ----------------------------


# Import the base class that contains methods used in many tests and code 
# examples.
from python_veritas_base import python_veritas_base


class python_connector_example (python_veritas_base):

  """
  PURPOSE:
      This is a simple example program that shows how to use the Snowflake 
      Python Connector to create and query a table.
  """

  def __init__(self):
    pass


  def do_the_real_work(self, conn):

    """
    INPUTS:
        conn is a Connection object returned from snowflake.connector.connect().
    """

    print("\nCreating table test_table...")
    # -- (> ----------------------- SECTION=create_table ---------------------
    conn.cursor().execute(
        "CREATE OR REPLACE TABLE "
        "test_table(col1 integer, col2 string)")

    conn.cursor().execute(
        "INSERT INTO test_table(col1, col2) VALUES " + 
        "    (123, 'test string1'), " + 
        "    (456, 'test string2')")
    # -- <) ---------------------------- END_SECTION -------------------------


    print("\nSelecting from test_table...")
    # -- (> ----------------------- SECTION=querying_data --------------------
    cur = conn.cursor()
    try:
        cur.execute("SELECT col1, col2 FROM test_table ORDER BY col1")
        for (col1, col2) in cur:
            print('{0}, {1}'.format(col1, col2))
    finally:
        cur.close()
    # -- <) ---------------------------- END_SECTION -------------------------




# ============================================================================

if __name__ == '__main__':

    test_case = python_connector_example()
    test_case.main(sys.argv)

-- Example 18250
export SNOWSQL_PWD='MyPassword'

-- Example 18251
python3 python_connector_example.py --warehouse <unique_warehouse_name> --database <new_warehouse_zzz_test> --schema <new_schema_zzz_test> --account myorganization-myaccount --user MyUserName

-- Example 18252
Connecting...

Creating warehouse, database, schema...

Creating table test_table...

Selecting from test_table...
123, test string1
456, test string2

Closing connection...

-- Example 18253
#!/usr/bin/env python
#
# Snowflake Connector for Python Sample Program
#

# Logging
import logging
logging.basicConfig(
    filename='/tmp/snowflake_python_connector.log',
    level=logging.INFO)

import snowflake.connector

# Set ACCOUNT to your account identifier.
# See https://docs.snowflake.com/en/user-guide/gen-conn-config.
ACCOUNT = '<my_organization>-<my_account>'
# Set your login information.
USER = '<login_name>'
PASSWORD = '<password>'

import os

# Only required if you copy data from your S3 bucket
AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')

# Connecting to Snowflake
con = snowflake.connector.connect(
  user=USER,
  password=PASSWORD,
  account=ACCOUNT,
)

# Creating a database, schema, and warehouse if none exists
con.cursor().execute("CREATE WAREHOUSE IF NOT EXISTS tiny_warehouse")
con.cursor().execute("CREATE DATABASE IF NOT EXISTS testdb")
con.cursor().execute("USE DATABASE testdb")
con.cursor().execute("CREATE SCHEMA IF NOT EXISTS testschema")

# Using the database, schema and warehouse
con.cursor().execute("USE WAREHOUSE tiny_warehouse")
con.cursor().execute("USE SCHEMA testdb.testschema")

# Creating a table and inserting data
con.cursor().execute(
    "CREATE OR REPLACE TABLE "
    "testtable(col1 integer, col2 string)")
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(123, 'test string1'),(456, 'test string2')")

# Copying data from internal stage (for testtable table)
con.cursor().execute("PUT file:///tmp/data0/file* @%testtable")
con.cursor().execute("COPY INTO testtable")

# Copying data from external stage (S3 bucket -
# replace <s3_bucket> with the name of your bucket)
con.cursor().execute("""
COPY INTO testtable FROM s3://<s3_bucket>/data/
     STORAGE_INTEGRATION = myint
     FILE_FORMAT=(field_delimiter=',')
""".format(
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY))

# Querying data
cur = con.cursor()
try:
    cur.execute("SELECT col1, col2 FROM testtable")
    for (col1, col2) in cur:
        print('{0}, {1}'.format(col1, col2))
finally:
    cur.close()

# Binding data
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%(col1)s, %(col2)s)", {
        'col1': 789,
        'col2': 'test string3',
        })

# Retrieving column names
cur = con.cursor()
cur.execute("SELECT * FROM testtable")
print(','.join([col[0] for col in cur.description]))

# Catching syntax errors
cur = con.cursor()
try:
    cur.execute("SELECT * FROM testtable")
except snowflake.connector.errors.ProgrammingError as e:
    # default error message
    print(e)
    # user error message
    print('Error {0} ({1}): {2} ({3})'.format(e.errno, e.sqlstate, e.msg, e.sfqid))
finally:
    cur.close()

# Retrieving the Snowflake query ID
cur = con.cursor()
cur.execute("SELECT * FROM testtable")
print(cur.sfqid)

# Closing the connection
con.close()

-- Example 18254
ARRAY( <element_type> [ NOT NULL ] )

-- Example 18255
SELECT
  SYSTEM$TYPEOF(
    [1, 2, 3]::ARRAY(NUMBER)
  ) AS structured_array,
  SYSTEM$TYPEOF(
    [1, 2, 3]
  ) AS semi_structured_array;

-- Example 18256
+-------------------------------+-----------------------+
| STRUCTURED_ARRAY              | SEMI_STRUCTURED_ARRAY |
|-------------------------------+-----------------------|
| ARRAY(NUMBER(38,0))[LOB]      | ARRAY[LOB]            |
+-------------------------------+-----------------------+

-- Example 18257
OBJECT(
  [
    <key> <value_type> [ NOT NULL ]
    [ , <key> <value_type> [ NOT NULL ] ]
    [ , ... ]
  ]
)

-- Example 18258
SELECT
  SYSTEM$TYPEOF(
    {
      'str': 'test',
      'num': 1
    }::OBJECT(
      str VARCHAR NOT NULL,
      num NUMBER
    )
  ) AS structured_object,
  SYSTEM$TYPEOF(
    {
      'str': 'test',
      'num': 1
    }
  ) AS semi_structured_object;

-- Example 18259
+---------------------------------------------------------------+------------------------+
| STRUCTURED_OBJECT                                             | SEMI_STRUCTURED_OBJECT |
|---------------------------------------------------------------+------------------------|
| OBJECT(str VARCHAR(16777216) NOT NULL, num NUMBER(38,0))[LOB] | OBJECT[LOB]            |
+---------------------------------------------------------------+------------------------+

-- Example 18260
MAP( <key_type> , <value_type> [ NOT NULL ] )

-- Example 18261
SELECT
  SYSTEM$TYPEOF(
    {
      'a_key': 'a_val',
      'b_key': 'b_val'
    }::MAP(VARCHAR, VARCHAR)
  ) AS map_example;

-- Example 18262
+------------------------------------------------+
| MAP_EXAMPLE                                    |
|------------------------------------------------|
| MAP(VARCHAR(16777216), VARCHAR(16777216))[LOB] |
+------------------------------------------------+

-- Example 18263
SELECT
  SYSTEM$TYPEOF(
    CAST ([1,2,3] AS ARRAY(NUMBER))
  ) AS array_cast_type,
  SYSTEM$TYPEOF(
    CAST ([1,2,3]::VARIANT AS ARRAY(NUMBER))
  ) AS variant_cast_type;

-- Example 18264
SELECT
  SYSTEM$TYPEOF(
    [1,2,3]::ARRAY(NUMBER)
  ) AS array_cast_type,
  SYSTEM$TYPEOF(
    [1,2,3]::VARIANT::ARRAY(NUMBER)
  ) AS variant_cast_type;

-- Example 18265
+--------------------------+--------------------------+
| ARRAY_CAST_TYPE          | VARIANT_CAST_TYPE        |
|--------------------------+--------------------------|
| ARRAY(NUMBER(38,0))[LOB] | ARRAY(NUMBER(38,0))[LOB] |
+--------------------------+--------------------------+

-- Example 18266
SELECT
  CAST ([1,2,3] AS ARRAY(VARCHAR)) AS varchar_array,
  SYSTEM$TYPEOF(varchar_array) AS array_cast_type;

-- Example 18267
+---------------+-------------------------------+
| VARCHAR_ARRAY | ARRAY_CAST_TYPE               |
|---------------+-------------------------------|
| [             | ARRAY(VARCHAR(16777216))[LOB] |
|   "1",        |                               |
|   "2",        |                               |
|   "3"         |                               |
| ]             |                               |
+---------------+-------------------------------+

-- Example 18268
SELECT
  SYSTEM$TYPEOF(
    CAST ({'city':'San Mateo','state':'CA'} AS OBJECT(city VARCHAR, state VARCHAR))
  ) AS object_cast_type,
  SYSTEM$TYPEOF(
    CAST ({'city':'San Mateo','state':'CA'}::VARIANT AS OBJECT(city VARCHAR, state VARCHAR))
  ) AS variant_cast_type;

