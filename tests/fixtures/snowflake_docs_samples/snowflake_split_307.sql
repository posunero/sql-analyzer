-- Example 20547
[default]
account = "myorganization-myaccount"
user = "jdoe-test"
password = "******"
warehouse = "my-test_wh"
database = "my_test_db"
schema = "my_schema"

-- Example 20548
default_connection_name = "myaccount"

-- Example 20549
SNOWFLAKE_DEFAULT_CONNECTION_NAME = myconnection_test

-- Example 20550
with snowflake.connector.connect() as conn:
    with conn.cursor() as cur:
        print(cur.execute("SELECT 1;").fetchall())

-- Example 20551
import os
import snowflake.connector as sc

private_key_file = '<path>'
private_key_file_pwd = '<password>'

conn_params = {
    'account': '<account_identifier>',
    'user': '<user>',
    'authenticator': 'SNOWFLAKE_JWT',
    'private_key_file': private_key_file,
    'private_key_file_pwd':private_key_file_pwd,
    'warehouse': '<warehouse>',
    'database': '<database>',
    'schema': '<schema>'
}

ctx = sc.connect(**conn_params)
cs = ctx.cursor()

-- Example 20552
export HTTP_PROXY='http://username:password@proxyserver.example.com:80'
export HTTPS_PROXY='http://username:password@proxyserver.example.com:80'

-- Example 20553
set HTTP_PROXY=http://username:password@proxyserver.example.com:80
set HTTPS_PROXY=http://username:password@proxyserver.example.com:80

-- Example 20554
localhost,.example.com,.snowflakecomputing.com,192.168.1.15,192.168.1.16

-- Example 20555
ctx = snowflake.connector.connect(
    user="<username>",
    host="<hostname>",
    account="<account_identifier>",
    authenticator="oauth",
    token="<oauth_access_token>",
    warehouse="test_warehouse",
    database="test_db",
    schema="test_schema"
)

-- Example 20556
# this request itself stops retrying after 60 seconds as it is a login request
conn = snowflake.connector.connect(
login_timeout=60,
network_timeout=30,
socket_timeout=10
)

# this request stops retrying after 30 seconds
conn.cursor.execute("SELECT * FROM table")

-- Example 20557
# even though login_timeout is 1, connect will take up to n*300 seconds before failing
# (n depends on possible socket addresses)
# this issue arises because socket operations cannot be cancelled once started
conn = snowflake.connector.connect(
login_timeout=1,
socket_timeout=300
)

-- Example 20558
# socket timeout for login request overriden by env variable JWT_CNXN_WAIT_TIME
conn = snowflake.connector.connect(
authenticator="SNOWFLAKE_JWT",
socket_timeout=300
)

# socket timeout for this request is still 300 seconds
conn.cursor.execute("SELECT * FROM table")

-- Example 20559
from snowflake.connector.backoff_policies import exponential_backoff

# correct, no required arguments
snowflake.connector.connect(
backoff_policy=exponential_backoff()
)

# correct, parameters are customizable
snowflake.connector.connect(
backoff_policy=exponential_backoff(
    factor=5,
    base=10,
    cap=60,
    enable_jitter=False
  )
)

-- Example 20560
def my_backoff_policy() -> int:
  while True:
    # yield the desired backoff duration

-- Example 20561
snowflake.connector.connect(
  backoff_policy=constant_backoff
)

-- Example 20562
con = snowflake.connector.connect(
    account=<account_identifier>,
    user=<user>,
    ...,
    ocsp_fail_open=False,
    ...);

-- Example 20563
from snowflake import connector

ctx = connector.connect(
        user=<user>,
        password=<password>,
        account=<account>,
        enable_connection_diag=True,
        connection_diag_log_path="<HOME>/diag-tests",
        )
print('connected')

-- Example 20564
pip install "snowflake-connector-python[pandas]"

-- Example 20565
pip install "snowflake-connector-python[secure-local-storage,pandas]"

-- Example 20566
import pandas as pd

-- Example 20567
import pandas as pd

def fetch_pandas_old(cur, sql):
    cur.execute(sql)
    rows = 0
    while True:
        dat = cur.fetchmany(50000)
        if not dat:
            break
        df = pd.DataFrame(dat, columns=cur.description)
        rows += df.shape[0]
    print(rows)

-- Example 20568
import pandas as pd

def fetch_pandas_sqlalchemy(sql):
    rows = 0
    for chunk in pd.read_sql_query(sql, engine, chunksize=50000):
        rows += chunk.shape[0]
    print(rows)

-- Example 20569
with connect(...) as conn:
    with conn.cursor() as cur:
        # Execute a query.
        cur.execute('select seq4() as n from table(generator(rowcount => 100000));')

        # Get the list of result batches
        result_batch_list = cur.get_result_batches()

        # Get the number of result batches in the list.
        num_result_batches = len(result_batch_list)

        # Split the list of result batches into two
        # to distribute the work of fetching results
        # between two workers.
        result_batch_list_1 = result_batch_list[:: 2]
        result_batch_list_2 = result_batch_list[1 :: 2]

-- Example 20570
with connect(...) as conn:
    with conn.cursor() as cur:
        # Execute a query.
        cur.execute('select seq4() as n from table(generator(rowcount => 100000));')

        # Return a PyArrow table containing all of the results.
        table = cur.fetch_arrow_all()

        # Iterate over a list of PyArrow tables for result batches.
        for table_for_batch in cur.fetch_arrow_batches():
          my_pyarrow_table_processing_function(table_for_batch)

-- Example 20571
with connect(...) as conn:
    with conn.cursor() as cur:
        # Execute a query.
        cur.execute('select seq4() as n from table(generator(rowcount => 100000));')

        # Return a pandas DataFrame containing all of the results.
        table = cur.fetch_pandas_all()

        # Iterate over a list of pandas DataFrames for result batches.
        for dataframe_for_batch in cur.fetch_pandas_batches():
          my_dataframe_processing_function(dataframe_for_batch)

-- Example 20572
import pickle

# Serialize a result batch from the first list.
pickled_batch = pickle.dumps(result_batch_list_1[1])

# At this point, you can move the serialized data to
# another worker/node.
...

# Deserialize the result batch for processing.
unpickled_batch = pickle.loads(pickled_batch)

-- Example 20573
# Iterate over the list of result batches.
for batch in result_batch_list_1:
    # Iterate over the subset of rows in a result batch.
    for row in batch:
        print(row)

-- Example 20574
# Materialize the subset of results for the first result batch
# in the list.
first_result_batch = result_batch_list_1[1]
first_result_batch_data = list(first_result_batch)

-- Example 20575
# Get the number of rows in a result batch.
num_rows = first_result_batch.rowcount

# Get the size of the data in a result batch.
compressed_size = first_result_batch.compressed_size
uncompressed_size = first_result_batch.uncompressed_size

-- Example 20576
with conn_cnx as con:
  with con.cursor() as cur:
    cur.execute("select col1 from table")
    batches = cur.get_result_batches()

    # Get the row from the ResultBatch as a pandas DataFrame.
    dataframe = batches[0].to_pandas()

    # Get the row from the ResultBatch as a PyArrow table.
    table = batches[0].to_arrow()

-- Example 20577
package1>=1.0,<2.0

-- Example 20578
package1>=1.0,<1.3

-- Example 20579
package1>=1.0,<2.0

-- Example 20580
import snowflake.connector

-- Example 20581
PASSWORD = os.getenv('SNOWSQL_PWD')
WAREHOUSE = os.getenv('WAREHOUSE')
...

-- Example 20582
import os

AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')

-- Example 20583
con = snowflake.connector.connect(
    user='XXXX',
    password='XXXX',
    account='XXXX',
    session_parameters={
        'QUERY_TAG': 'EndOfMonthFinancials',
    }
)

-- Example 20584
con.cursor().execute("ALTER SESSION SET QUERY_TAG = 'EndOfMonthFinancials'")

-- Example 20585
conn = snowflake.connector.connect(
    user=USER,
    password=PASSWORD,
    account=ACCOUNT,
    warehouse=WAREHOUSE,
    database=DATABASE,
    schema=SCHEMA
    )

-- Example 20586
$ vi connections.toml

-- Example 20587
[myconnection]
account = "myorganization-myaccount"
user = "jdoe"
password = "******"
warehouse = "my-wh"
database = "my_db"
schema = "my_schema"

-- Example 20588
[myconnection_test]
account = "myorganization-myaccount"
user = "jdoe-test"
password = "******"
warehouse = "my-test_wh"
database = "my_test_db"
schema = "my_schema"

-- Example 20589
with snowflake.connector.connect(
      connection_name="myconnection",
) as conn:

-- Example 20590
with snowflake.connector.connect(
      connection_name="myconnection",
      warehouse="test_xl_wh",
      database="testdb_2"
) as conn:

-- Example 20591
[default]
account = "myorganization-myaccount"
user = "jdoe-test"
password = "******"
warehouse = "my-test_wh"
database = "my_test_db"
schema = "my_schema"

-- Example 20592
default_connection_name = "myaccount"

-- Example 20593
SNOWFLAKE_DEFAULT_CONNECTION_NAME = myconnection_test

-- Example 20594
with snowflake.connector.connect() as conn:
    with conn.cursor() as cur:
        print(cur.execute("SELECT 1;").fetchall())

-- Example 20595
import os
import snowflake.connector as sc

private_key_file = '<path>'
private_key_file_pwd = '<password>'

conn_params = {
    'account': '<account_identifier>',
    'user': '<user>',
    'authenticator': 'SNOWFLAKE_JWT',
    'private_key_file': private_key_file,
    'private_key_file_pwd':private_key_file_pwd,
    'warehouse': '<warehouse>',
    'database': '<database>',
    'schema': '<schema>'
}

ctx = sc.connect(**conn_params)
cs = ctx.cursor()

-- Example 20596
export HTTP_PROXY='http://username:password@proxyserver.example.com:80'
export HTTPS_PROXY='http://username:password@proxyserver.example.com:80'

-- Example 20597
set HTTP_PROXY=http://username:password@proxyserver.example.com:80
set HTTPS_PROXY=http://username:password@proxyserver.example.com:80

-- Example 20598
localhost,.example.com,.snowflakecomputing.com,192.168.1.15,192.168.1.16

-- Example 20599
ctx = snowflake.connector.connect(
    user="<username>",
    host="<hostname>",
    account="<account_identifier>",
    authenticator="oauth",
    token="<oauth_access_token>",
    warehouse="test_warehouse",
    database="test_db",
    schema="test_schema"
)

-- Example 20600
# this request itself stops retrying after 60 seconds as it is a login request
conn = snowflake.connector.connect(
login_timeout=60,
network_timeout=30,
socket_timeout=10
)

# this request stops retrying after 30 seconds
conn.cursor.execute("SELECT * FROM table")

-- Example 20601
# even though login_timeout is 1, connect will take up to n*300 seconds before failing
# (n depends on possible socket addresses)
# this issue arises because socket operations cannot be cancelled once started
conn = snowflake.connector.connect(
login_timeout=1,
socket_timeout=300
)

-- Example 20602
# socket timeout for login request overriden by env variable JWT_CNXN_WAIT_TIME
conn = snowflake.connector.connect(
authenticator="SNOWFLAKE_JWT",
socket_timeout=300
)

# socket timeout for this request is still 300 seconds
conn.cursor.execute("SELECT * FROM table")

-- Example 20603
from snowflake.connector.backoff_policies import exponential_backoff

# correct, no required arguments
snowflake.connector.connect(
backoff_policy=exponential_backoff()
)

# correct, parameters are customizable
snowflake.connector.connect(
backoff_policy=exponential_backoff(
    factor=5,
    base=10,
    cap=60,
    enable_jitter=False
  )
)

-- Example 20604
def my_backoff_policy() -> int:
  while True:
    # yield the desired backoff duration

-- Example 20605
snowflake.connector.connect(
  backoff_policy=constant_backoff
)

-- Example 20606
con = snowflake.connector.connect(
    account=<account_identifier>,
    user=<user>,
    ...,
    ocsp_fail_open=False,
    ...);

-- Example 20607
from snowflake import connector

ctx = connector.connect(
        user=<user>,
        password=<password>,
        account=<account>,
        enable_connection_diag=True,
        connection_diag_log_path="<HOME>/diag-tests",
        )
print('connected')

-- Example 20608
/* Standard data load */
COPY INTO [<namespace>.]<table_name>
     FROM { internalStage | externalStage | externalLocation }
[ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
[ PATTERN = '<regex_pattern>' ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
                    TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
[ copyOptions ]
[ VALIDATION_MODE = RETURN_<n>_ROWS | RETURN_ERRORS | RETURN_ALL_ERRORS ]

/* Data load with transformation */
COPY INTO [<namespace>.]<table_name> [ ( <col_name> [ , <col_name> ... ] ) ]
     FROM ( SELECT [<alias>.]$<file_col_num>[.<element>] [ , [<alias>.]$<file_col_num>[.<element>] ... ]
            FROM { internalStage | externalStage } )
[ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
[ PATTERN = '<regex_pattern>' ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
                    TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
[ copyOptions ]

-- Example 20609
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 20610
externalStage ::=
  @[<namespace>.]<ext_stage_name>[/<path>]

-- Example 20611
externalLocation (for Amazon S3) ::=
  '<protocol>://<bucket>[/<path>]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] [ MASTER_KEY = '<string>' ] |
                   [ TYPE = 'AWS_SSE_S3' ] |
                   [ TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ] ] |
                   [ TYPE = 'NONE' ] ) ]

-- Example 20612
externalLocation (for Google Cloud Storage) ::=
  'gcs://<bucket>[/<path>]'
  [ STORAGE_INTEGRATION = <integration_name> ]
  [ ENCRYPTION = ( [ TYPE = 'GCS_SSE_KMS' ] [ KMS_KEY_ID = '<string>' ] | [ TYPE = 'NONE' ] ) ]

-- Example 20613
externalLocation (for Microsoft Azure) ::=
  'azure://<account>.blob.core.windows.net/<container>[/<path>]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = ( [ TYPE = { 'AZURE_CSE' | 'NONE' } ] [ MASTER_KEY = '<string>' ] ) ]

