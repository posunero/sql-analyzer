-- Example 13045
CREATE CONNECTION [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 13046
CREATE CONNECTION [ IF NOT EXISTS ] <name>
  AS REPLICA OF <organization_name>.<account_name>.<name>
  [ COMMENT = '<string_literal>' ]

-- Example 13047
CREATE CONNECTION IF NOT EXISTS myconnection;

-- Example 13048
CREATE CONNECTION myconnection AS REPLICA OF myorg.myaccount1.myconnection;

-- Example 13049
ALTER CONNECTION [ IF EXISTS ] <name> ENABLE FAILOVER TO ACCOUNTS <organization_name>.<account_name> [ , <organization_name>.<account_name> ... ]
                        [ IGNORE EDITION CHECK ]

ALTER CONNECTION [ IF EXISTS ] <name> DISABLE FAILOVER [ TO ACCOUNTS <organization_name>.<account_name> [ , <organization_name>.<account_name> ... ] ]

ALTER CONNECTION [ IF EXISTS ] <name> PRIMARY

ALTER CONNECTION [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER CONNECTION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 13050
ALTER CONNECTION myconnection ENABLE FAILOVER TO ACCOUNTS myorg.myaccount2, myorg.myaccount3;

-- Example 13051
ALTER CONNECTION myconnection SET COMMENT = 'New comment for connection';

-- Example 13052
ALTER CONNECTION myconnection PRIMARY;

-- Example 13053
SHOW CONNECTIONS [ LIKE '<pattern>' ]

-- Example 13054
SHOW CONNECTIONS LIKE 'test%';

-- Example 13055
CREATE CONNECTION [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 13056
CREATE CONNECTION [ IF NOT EXISTS ] <name>
  AS REPLICA OF <organization_name>.<account_name>.<name>
  [ COMMENT = '<string_literal>' ]

-- Example 13057
CREATE CONNECTION IF NOT EXISTS myconnection;

-- Example 13058
CREATE CONNECTION myconnection AS REPLICA OF myorg.myaccount1.myconnection;

-- Example 13059
SELECT t.VALUE:type::VARCHAR as type,
  t.VALUE:host::VARCHAR as host,
  t.VALUE:port as port
FROM TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$ALLOWLIST_PRIVATELINK()))) AS t
WHERE type ILIKE ANY ('OCSP%');

-- Example 13060
+-----------------------+---------------------------------------------------------------+------+
| TYPE                  | HOST                                                          | PORT |
|-----------------------+---------------------------------------------------------------+------|
| OCSP_CACHE            | ocsp.account1234.us-west-2.privatelink.snowflakecomputing.com | 80   |
| OCSP_CACHE_REGIONLESS | ocsp.my_org-my_account.privatelink.snowflakecomputing.com     | 80   |
+-----------------------+---------------------------------------------------------------+------+

-- Example 13061
conn.cursor().execute("CREATE WAREHOUSE IF NOT EXISTS tiny_warehouse_mg")
conn.cursor().execute("CREATE DATABASE IF NOT EXISTS testdb_mg")
conn.cursor().execute("USE DATABASE testdb_mg")
conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS testschema_mg")

-- Example 13062
conn.cursor().execute("USE WAREHOUSE tiny_warehouse_mg")
conn.cursor().execute("USE DATABASE testdb_mg")
conn.cursor().execute("USE SCHEMA testdb_mg.testschema_mg")

-- Example 13063
conn.cursor().execute(
    "CREATE OR REPLACE TABLE "
    "test_table(col1 integer, col2 string)")

conn.cursor().execute(
    "INSERT INTO test_table(col1, col2) VALUES " + 
    "    (123, 'test string1'), " + 
    "    (456, 'test string2')")

-- Example 13064
# Putting Data
con.cursor().execute("PUT file:///tmp/data/file* @%testtable")
con.cursor().execute("COPY INTO testtable")

-- Example 13065
# Copying Data
con.cursor().execute("""
COPY INTO testtable FROM s3://<s3_bucket>/data/
    STORAGE_INTEGRATION = myint
    FILE_FORMAT=(field_delimiter=',')
""".format(
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY))

-- Example 13066
conn = snowflake.connector.connect( ... )
cur = conn.cursor()
cur.execute('select * from products')

-- Example 13067
conn = snowflake.connector.connect( ... )
cur = conn.cursor()
# Submit an asynchronous query for execution.
cur.execute_async('select count(*) from table(generator(timeLimit => 25))')

-- Example 13068
# Retrieving a Snowflake Query ID
cur = con.cursor()
cur.execute("SELECT * FROM testtable")
print(cur.sfqid)

-- Example 13069
import time
...
# Execute a long-running query asynchronously.
cur.execute_async('select count(*) from table(generator(timeLimit => 25))')
...
# Wait for the query to finish running.
query_id = cur.sfqid
while conn.is_still_running(conn.get_query_status(query_id)):
  time.sleep(1)

-- Example 13070
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

-- Example 13071
# Get the results from a query.
cur.get_results_from_sfqid(query_id)
results = cur.fetchall()
print(f'{results[0]}')

-- Example 13072
cur = conn.cursor()
try:
    cur.execute("SELECT col1, col2 FROM test_table ORDER BY col1")
    for (col1, col2) in cur:
        print('{0}, {1}'.format(col1, col2))
finally:
    cur.close()

-- Example 13073
for (col1, col2) in con.cursor().execute("SELECT col1, col2 FROM testtable"):
    print('{0}, {1}'.format(col1, col2))

-- Example 13074
col1, col2 = con.cursor().execute("SELECT col1, col2 FROM testtable").fetchone()
print('{0}, {1}'.format(col1, col2))

-- Example 13075
cur = con.cursor().execute("SELECT col1, col2 FROM testtable")
ret = cur.fetchmany(3)
print(ret)
while len(ret) > 0:
    ret = cur.fetchmany(3)
    print(ret)

-- Example 13076
results = con.cursor().execute("SELECT col1, col2 FROM testtable").fetchall()
for rec in results:
    print('%s, %s' % (rec[0], rec[1]))

-- Example 13077
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

-- Example 13078
# Querying data by DictCursor
from snowflake.connector import DictCursor
cur = con.cursor(DictCursor)
try:
    cur.execute("SELECT col1, col2 FROM testtable")
    for rec in cur:
        print('{0}, {1}'.format(rec['COL1'], rec['COL2']))
finally:
    cur.close()

-- Example 13079
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

-- Example 13080
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

-- Example 13081
cur = cn.cursor()

try:
  cur.execute(r"SELECT SYSTEM$CANCEL_QUERY('queryID')")
  result = cur.fetchall()
  print(len(result))
  print(result[0])
finally:
  cur.close()

-- Example 13082
from snowflake.connector.converter_null import SnowflakeNoConverterToPython

con = snowflake.connector.connect(
    ...
    converter_class=SnowflakeNoConverterToPython
)
for rec in con.cursor().execute("SELECT * FROM large_table"):
    # rec includes raw Snowflake data

-- Example 13083
con.cursor().execute("INSERT INTO testtable(col1, col2) VALUES(789, 'test string3')")

-- Example 13084
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%s, %s)", (
        789,
        'test string3'
    ))

-- Example 13085
conn.cursor().execute(
    "INSERT INTO test_table(col1, col2) "
    "VALUES(%(col1)s, %(col2)s)", {
        'col1': 789,
        'col2': 'test string3',
        })

-- Example 13086
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%s, %s)", (
        789,
        'test string3'
    ))

-- Example 13087
# Binding data for IN operator
con.cursor().execute(
    "SELECT col1, col2 FROM testtable"
    " WHERE col2 IN (%s)", (
        ['test string1', 'test string3'],
    ))

-- Example 13088
SELECT col1, col2
    FROM test_table
    WHERE col2 ILIKE '%York' LIMIT 1;  -- Find York, New York, etc.

-- Example 13089
sql_command = "select col1, col2 from test_table "
sql_command += " where col2 like '%%York' limit %(lim)s"
parameter_dictionary = {'lim': 1 }
cur.execute(sql_command, parameter_dictionary)

-- Example 13090
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

-- Example 13091
import snowflake.connector

snowflake.connector.paramstyle='numeric'

con = snowflake.connector.connect(...)

con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(:1, :2)", (
        789,
        'test string3'
    ))

-- Example 13092
con.cursor().execute(
    "INSERT INTO testtable(complete_video, short_sample_of_video) "
    "VALUES(:1, SUBSTRING(:1, :2, :3))", (
        binary_value_that_stores_video,          # variable :1
        starting_offset_in_bytes_of_video_clip,  # variable :2
        length_in_bytes_of_video_clip            # variable :3
    ))

-- Example 13093
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

-- Example 13094
insert into grocery (item, quantity) values (?, ?)

-- Example 13095
rows_to_insert = [('milk', 2), ('apple', 3), ('egg', 2)]

-- Example 13096
conn = snowflake.connector.connect( ... )
rows_to_insert = [('milk', 2), ('apple', 3), ('egg', 2)]
conn.cursor().executemany(
    "insert into grocery (item, quantity) values (?, ?)",
    rows_to_insert)

-- Example 13097
CREATE TEMPORARY STAGE SYSTEM$BIND file_format=(type=csv field_optionally_enclosed_by='"')
Cannot perform CREATE STAGE. This session does not have a current schema. Call 'USE SCHEMA', or use a qualified name.

-- Example 13098
# Binding data (UNSAFE EXAMPLE)
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%(col1)d, '%(col2)s')" % {
        'col1': 789,
        'col2': 'test string3'
    })

-- Example 13099
# Binding data (UNSAFE EXAMPLE)
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%d, '%s')" % (
        789,
        'test string3'
    ))

-- Example 13100
# Binding data (UNSAFE EXAMPLE)
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES({col1}, '{col2}')".format(
        col1=789,
        col2='test string3')
    )

-- Example 13101
cur = conn.cursor()
cur.execute("SELECT * FROM test_table")
print(','.join([col[0] for col in cur.description]))

-- Example 13102
cur = conn.cursor()
cur.execute("SELECT * FROM test_table")
print(','.join([col.name for col in cur.description]))

-- Example 13103
cur = conn.cursor()
result_metadata_list = cur.describe("SELECT * FROM test_table")
print(','.join([col.name for col in result_metadata_list]))

-- Example 13104
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

-- Example 13105
from codecs import open
with open(sqlfile, 'r', encoding='utf-8') as f:
    for cur in con.execute_stream(f):
        for ret in cur:
            print(ret)

-- Example 13106
connection.close()

-- Example 13107
# Connecting to Snowflake
con = snowflake.connector.connect(...)
try:
    # Running queries
    con.cursor().execute(...)
    ...
finally:
    # Closing the connection
    con.close()

-- Example 13108
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

-- Example 13109
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

-- Example 13110
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

-- Example 13111
[(6.30...,), (41.2...,)]

