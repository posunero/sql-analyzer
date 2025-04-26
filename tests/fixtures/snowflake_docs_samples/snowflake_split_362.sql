-- Example 24229
ALTER ACCOUNT SET AUTHENTICATION POLICY multiple_idps_authentication_policy;

-- Example 24230
CREATE ACCOUNT my_admin ADMIN_USER_TYPE = PERSON;

-- Example 24231
CREATE ACCOUNT my_admin
  ADMIN_USER_TYPE = SERVICE
  ADMIN_RSA_PUBLIC_KEY = 'MIIBIj...';

-- Example 24232
pip install "snowflake-connector-python[pandas]"

-- Example 24233
pip install "snowflake-connector-python[secure-local-storage,pandas]"

-- Example 24234
import pandas as pd

-- Example 24235
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

-- Example 24236
import pandas as pd

def fetch_pandas_sqlalchemy(sql):
    rows = 0
    for chunk in pd.read_sql_query(sql, engine, chunksize=50000):
        rows += chunk.shape[0]
    print(rows)

-- Example 24237
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 2A3149C82551A34A

-- Example 24238
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 24239
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 24240
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 24241
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 24242
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 24243
gpg: keyserver receive failed: Server indicated a failure

-- Example 24244
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 24245
$ gpg --verify snowflake-jdbc-3.23.2.jar.asc snowflake-jdbc-3.23.2.jar
gpg: Signature made Wed 22 Feb 2017 04:31:58 PM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>"

-- Example 24246
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 24247
$ gpg --delete-key "Snowflake Computing"

-- Example 24248
<dependencies>
  ...
  <dependency>
    <groupId>net.snowflake</groupId>
    <artifactId>snowflake-jdbc</artifactId>
    <version>3.23.2</version>
  </dependency>
  ...
</dependencies>

-- Example 24249
<dependencies>
  ...
  <dependency>
    <groupId>net.snowflake</groupId>
    <artifactId>snowflake-jdbc-fips</artifactId>
    <version>3.23.2</version>
  </dependency>
  ...
</dependencies>

-- Example 24250
<dependencies>
  ...
  <dependency>
    <groupId>net.snowflake</groupId>
    <artifactId>snowflake-jdbc-thin</artifactId>
    <version>3.23.2</version>
  </dependency>
  ...
</dependencies>

-- Example 24251
format: .execute("... WHERE my_column = %s", (value,))
pyformat: .execute("... WHERE my_column = %(name)s", {"name": value})
qmark: .execute("... WHERE my_column = ?", (value,))
numeric: .execute("... WHERE my_column = :1", (value,))

-- Example 24252
ctx = snowflake.connector.connect(
    user='<user_name>',
    password='<password>',
    account='myorganization-myaccount',
    ... )

-- Example 24253
ctx = snowflake.connector.connect(
    user='<user_name>',
    password='<password>',
    account='xy12345',
    ... )

-- Example 24254
# context manager ensures the connection is closed
with snowflake.connector.connect(...) as con:
    con.cursor().execute(...)

# try & finally to ensure the connection is closed.
con = snowflake.connector.connect(...)
try:
    con.cursor().execute(...)
finally:
    con.close()

-- Example 24255
cursor_list = connection1.execute_string(
    "SELECT * FROM testtable WHERE col1 LIKE 'T%';"
    "SELECT * FROM testtable WHERE col2 LIKE 'A%';"
    )

for cursor in cursor_list:
   for row in cursor:
      print(row[0], row[1])

-- Example 24256
# "Binding" data via the format() function (UNSAFE EXAMPLE)
value1_from_user = "'ok3'); DELETE FROM testtable WHERE col1 = 'ok1'; select pi("
sql_cmd = "insert into testtable(col1) values('ok1'); "                  \
          "insert into testtable(col1) values('ok2'); "                  \
          "insert into testtable(col1) values({col1});".format(col1=value1_from_user)
# Show what SQL Injection can do to a composed statement.
print(sql_cmd)

connection1.execute_string(sql_cmd)

-- Example 24257
insert into testtable(col1) values('ok1');
insert into testtable(col1) values('ok2');
insert into testtable(col1) values('ok3');
DELETE FROM testtable WHERE col1 = 'ok1';
select pi();

-- Example 24258
sql_script = """
-- This is first comment line;
select 1;
select 2;
-- This is comment in middle;
-- With some extra comment lines;
select 3;
-- This is the end with last line comment;
"""
sql_stream = StringIO(sql_script)
with con.cursor() as cur:
        for result_cursor in con.execute_stream(sql_stream,remove_comments=True):
            for result in result_cursor:
                print(f"Result: {result}")

-- Example 24259
@mystage/myfile.csv

-- Example 24260
cursor.execute(
    "PUT file://this_directory_path/is_ignored/myfile.csv @mystage",
    file_stream=<io_object>)

-- Example 24261
"insert into testy (v1, v2) values (?, ?)"

-- Example 24262
# This example uses qmark (question mark) binding, so
# you must configure the connector to use this binding style.
from snowflake import connector
connector.paramstyle='qmark'

stmt1 = "create table testy (V1 varchar, V2 varchar)"
cs.execute(stmt1)

# A list of lists
sequence_of_parameters1 = [ ['Smith', 'Ann'], ['Jones', 'Ed'] ]
# A tuple of tuples
sequence_of_parameters2 = ( ('Cho', 'Kim'), ('Cooper', 'Pat') )

stmt2 = "insert into testy (v1, v2) values (?, ?)"
cs.executemany(stmt2, sequence_of_parameters1)
cs.executemany(stmt2, sequence_of_parameters2)

-- Example 24263
ctx = snowflake.connector.connect(
          host=host,
          user=user,
          password=password,
          account=account,
          warehouse=warehouse,
          database=database,
          schema=schema,
          protocol='https',
          port=port)

# Create a cursor object.
cur = ctx.cursor()

# Execute a statement that will generate a result set.
sql = "select * from t"
cur.execute(sql)

# Fetch the result set from the cursor and deliver it as the pandas DataFrame.
df = cur.fetch_pandas_all()

# ...

-- Example 24264
ctx = snowflake.connector.connect(
          host=host,
          user=user,
          password=password,
          account=account,
          warehouse=warehouse,
          database=database,
          schema=schema,
          protocol='https',
          port=port)

# Create a cursor object.
cur = ctx.cursor()

# Execute a statement that will generate a result set.
sql = "select * from t"
cur.execute(sql)

# Fetch the result set from the cursor and deliver it as the pandas DataFrame.
for df in cur.fetch_pandas_batches():
    my_dataframe_processing_function(df)

# ...

-- Example 24265
import pandas
from snowflake.connector.pandas_tools import write_pandas

# Create the connection to the Snowflake database.
cnx = snowflake.connector.connect(...)

# Create a DataFrame containing data about customers
df = pandas.DataFrame([('Mark', 10), ('Luke', 20)], columns=['name', 'balance'])

# Write the data from the DataFrame to the table named "customers".
success, nchunks, nrows, _ = write_pandas(cnx, df, 'customers')

-- Example 24266
import pandas as pd
from snowflake.connector.pandas_tools import pd_writer

sf_connector_version_df = pd.DataFrame([('snowflake-connector-python', '1.0')], columns=['NAME', 'NEWEST_VERSION'])

# Specify that the to_sql method should use the pd_writer function
# to write the data from the DataFrame to the table named "driver_versions"
# in the Snowflake database.
sf_connector_version_df.to_sql('driver_versions', engine, index=False, method=pd_writer)

# When the column names consist of only lower case letters, quote the column names
sf_connector_version_df = pd.DataFrame([('snowflake-connector-python', '1.0')], columns=['"name"', '"newest_version"'])
sf_connector_version_df.to_sql('driver_versions', engine, index=False, method=pd_writer)

-- Example 24267
import pandas
from snowflake.connector.pandas_tools import pd_writer

# Create a DataFrame containing data about customers
df = pandas.DataFrame([('Mark', 10), ('Luke', 20)], columns=['name', 'balance'])

# Specify that the to_sql method should use the pd_writer function
# to write the data from the DataFrame to the table named "customers"
# in the Snowflake database.
df.to_sql('customers', engine, index=False, method=pd_writer)

-- Example 24268
CREATE OR REPLACE VIEW v1 (vc1, vc2) AS
SELECT c1 as vc1,
       c2 as vc2
FROM t
WHERE t.c3 > 0
;

-- Example 24269
CREATE OR REPLACE VIEW join_v (vc1, vc2, c1) AS
  SELECT
      bt.c1 AS vc1,
      bt.c2 AS vc2,
      jt.c1
  FROM bt, jt
  WHERE bt.c3 = jt.c1;

-- Example 24270
query_id | query_start_time | user_name | direct_objects_accessed | base_objects_accessed | objects_modified | object_modified_by_ddl | policies_referenced | parent_query_id | root_query_id

-- Example 24271
select * from view_2;

-- Example 24272
create table table_1 as select * from base_table;

-- Example 24273
SELECT query_id, parent_query_id, direct_objects_accessed
FROM snowflake.account_usage.access_history
WHERE parent_query_id = 6789;

-- Example 24274
SELECT user_name
       , query_id
       , query_start_time
       , direct_objects_accessed
       , base_objects_accessed
FROM access_history
ORDER BY 1, 3 desc
;

-- Example 24275
SELECT distinct user_name
FROM access_history
     , lateral flatten(base_objects_accessed) f1
WHERE f1.value:"objectId"::int=<fill_in_object_id>
AND f1.value:"objectDomain"::string='Table'
AND query_start_time >= dateadd('day', -30, current_timestamp())
;

-- Example 24276
SELECT query_id
       , query_start_time
FROM access_history
     , lateral flatten(base_objects_accessed) f1
WHERE f1.value:"objectId"::int=32998411400350
AND f1.value:"objectDomain"::string='Table'
AND query_start_time >= dateadd('day', -30, current_timestamp())
;

-- Example 24277
SELECT distinct f4.value AS column_name
FROM access_history
     , lateral flatten(base_objects_accessed) f1
     , lateral flatten(f1.value) f2
     , lateral flatten(f2.value) f3
     , lateral flatten(f3.value) f4
WHERE f1.value:"objectId"::int=32998411400350
AND f1.value:"objectDomain"::string='Table'
AND f4.key='columnName'
;

-- Example 24278
copy into table1(col1, col2)
from (select t.$1, t.$2 from @mystage1/data1.csv.gz);

-- Example 24279
{
  "objectDomain": STAGE
  "objectName": "mystage1",
  "objectId": 1,
  "stageKind": "External Named"
}

-- Example 24280
{
  "columns": [
     {
       "columnName": "col1",
       "columnId": 1
     },
     {
       "columnName": "col2",
       "columnId": 2
     }
  ],
  "objectId": 1,
  "objectName": "TEST_DB.TEST_SCHEMA.TABLE1",
  "objectDomain": TABLE
}

-- Example 24281
copy into @mystage1/data1.csv
from table1;

-- Example 24282
{
  "objectDomain": TABLE
  "objectName": "TEST_DB.TEST_SCHEMA.TABLE1",
  "objectId": 123,
  "columns": [
     {
       "columnName": "col1",
       "columnId": 1
     },
     {
       "columnName": "col2",
       "columnId": 2
     }
  ]
}

-- Example 24283
{
  "objectId": 1,
  "objectName": "mystage1",
  "objectDomain": STAGE,
  "stageKind": "External Named"
}

-- Example 24284
put file:///tmp/data/mydata.csv @my_int_stage;

-- Example 24285
{
  "location": "file:///tmp/data/mydata.csv"
}

-- Example 24286
{
  "objectId": 1,
  "objectName": "my_int_stage",
  "objectDomain": STAGE,
  "stageKind": "Internal Named"
}

-- Example 24287
get @%mytable file:///tmp/data/;

-- Example 24288
{
  "objectDomain": Stage
  "objectName": "mytable",
  "objectId": 1,
  "stageKind": "Table"
}

-- Example 24289
{
  "location": "file:///tmp/data/"
}

-- Example 24290
use test_db.test_schema;
create or replace table T1(content variant);
insert into T1(content) select parse_json('{"name": "A", "id":1}');

-- T1 -> T6
insert into T6 select * from T1;

-- S1 -> T1
copy into T1 from @S1;

-- T1 -> T2
create table T2 as select content:"name" as name, content:"id" as id from T1;

-- T1 -> S2
copy into @S2 from T1;

-- S1 -> T3
create or replace table T3(customer_info variant);
copy into T3 from @S1;

-- T1 -> T4
create or replace table T4(name string, id string, address string);
insert into T4(name, id) select content:"name", content:"id" from T1;

-- T6 -> T7
create table T7 as select * from T6;

-- Example 24291
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24292
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24293
[
  {
    "columns": [
      {
        "columnId": 68611,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66566,
    "objectName": "TEST_DB.TEST_SCHEMA.T6"
  }
]

-- Example 24294
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 24295
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

