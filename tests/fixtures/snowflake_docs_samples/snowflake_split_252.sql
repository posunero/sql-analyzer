-- Example 16863
GRANT READ SESSION ON ACCOUNT TO ROLE streamlit_owner_role;

-- Example 16864
# Import Python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("CURRENT_USER() + Row Access Policy in SiS Demo :balloon:")
st.write(
        """You can access `CURRENT_USER()` and data from tables with row access policies
        in Streamlit in Snowflake apps
        """)

# Get the current credentials
session = get_active_session()

st.header('Demo')

st.subheader('Credentials')
sql = "SELECT CURRENT_USER();"
df = session.sql(sql).collect()
st.write(df)

st.subheader('Row Access on a Table')
sql = "SELECT * FROM st_db.st_schema.row_access_policy_test_table;"
df = session.sql(sql).collect()

st.write(df)

-- Example 16865
pip install --upgrade snowflake-sqlalchemy

-- Example 16866
#!/usr/bin/env python
from sqlalchemy import create_engine

engine = create_engine(
    'snowflake://{user}:{password}@{account_identifier}/'.format(
        user='<user_login_name>',
        password='<password>',
        account_identifier='<account_identifier>',
    )
)
try:
    connection = engine.connect()
    results = connection.execute('select current_version()').fetchone()
    print(results[0])
finally:
    connection.close()
    engine.dispose()

-- Example 16867
python validate.py

-- Example 16868
'snowflake://<user_login_name>:<password>@<account_identifier>'

-- Example 16869
'snowflake://<user_login_name>:<password>@<account_identifier>/<database_name>/<schema_name>?warehouse=<warehouse_name>&role=<role_name>'

-- Example 16870
from sqlalchemy import create_engine
engine = create_engine(
    'snowflake://testuser1:0123456@myorganization-myaccount/testdb/public?warehouse=testwh&role=myrole'
)

-- Example 16871
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine

engine = create_engine(URL(
    account = 'myorganization-myaccount',
    user = 'testuser1',
    password = '0123456',
    database = 'testdb',
    schema = 'public',
    warehouse = 'testwh',
    role='myrole',
))

-- Example 16872
# Avoid this.
engine = create_engine(...)
engine.execute(<SQL>)
engine.dispose()

# Do this.
engine = create_engine(...)
connection = engine.connect()
try:
    connection.execute(<SQL>)
finally:
    connection.close()
    engine.dispose()

-- Example 16873
# Disable AUTOCOMMIT if you need to use an explicit transaction.
with engine.connect().execution_options(autocommit=False) as connection:

  try:
    connection.execute("BEGIN")
    connection.execute("INSERT INTO test_table VALUES (88888, 'X', 434354)")
    connection.execute("INSERT INTO test_table VALUES (99999, 'Y', 453654654)")
    connection.execute("COMMIT")
  except Exception as e:
    connection.execute("ROLLBACK")
  finally:
    connection.close()

engine.dispose()

-- Example 16874
t = Table('mytable', metadata,
    Column('id', Integer, Sequence('id_seq'), primary_key=True),
    Column(...), ...
)

-- Example 16875
hybrid_test_table_1 = HybridTable(
  "table_name",
  metadata,
  Column("column1", Integer, primary_key=True),
  Column("column2", String, index=True),
  Index("index_1","column1", "column2")
)

metadata.create_all(engine_testaccount)

-- Example 16876
hybrid_test_table_1 = HybridTable(
  "table_name",
  metadata,
  Column("column1", Integer, primary_key=True),
  Column("column2", String),
  Index("index_1","column1", "column2")
)

metadata.create_all(engine_testaccount)

-- Example 16877
import numpy as np
import pandas as pd
engine = create_engine(URL(
    account = 'myorganization-myaccount',
    user = 'testuser1',
    password = 'pass',
    database = 'db',
    schema = 'public',
    warehouse = 'testwh',
    role='myrole',
    numpy=True,
))

specific_date = np.datetime64('2016-03-04T12:03:05.123456789Z')

with engine.connect() as connection:
    connection.exec_sql_query(
        "CREATE OR REPLACE TABLE ts_tbl(c1 TIMESTAMP_NTZ)")
    connection.exec_sql_query(
        "INSERT INTO ts_tbl(c1) values(%s)", (specific_date,)
    )
    df = pd.read_sql_query("SELECT * FROM ts_tbl", connection)
    assert df.c1.values[0] == specific_date

-- Example 16878
inspector = inspect(engine)
schema = inspector.default_schema_name
for table_name in inspector.get_table_names(schema):
    column_metadata = inspector.get_columns(table_name, schema)
    primary_keys = inspector.get_primary_keys(table_name, schema)
    foreign_keys = inspector.get_foreign_keys(table_name, schema)
    ...

-- Example 16879
engine = create_engine(URL(
    account = 'myorganization-myaccount',
    user = 'testuser1',
    password = 'pass',
    database = 'db',
    schema = 'public',
    warehouse = 'testwh',
    role='myrole',
    cache_column_metadata=True,
))

-- Example 16880
from snowflake.sqlalchemy import (VARIANT, ARRAY, OBJECT)
...
t = Table('my_semi_structured_datatype_table', metadata,
    Column('va', VARIANT),
    Column('ob', OBJECT),
    Column('ar', ARRAY))
metadata.create_all(engine)

-- Example 16881
import json
connection = engine.connect()
results = connection.execute(select([t]))
row = results.fetchone()
data_variant = json.loads(row[0])
data_object  = json.loads(row[1])
data_array   = json.loads(row[2])

-- Example 16882
IcebergTable(
  table_name,
  metadata,
  Column("id", Integer, primary_key=True),
  Column("map_col", MAP(NUMBER(10, 0), TEXT(16777216))),
  external_volume="external_volume",
  base_location="base_location",
)

-- Example 16883
IcebergTable(
    table_name,
    metadata,
    Column("id", Integer, primary_key=True),
    Column(
        "object_col",
        OBJECT(key1=(TEXT(16777216), False), key2=(NUMBER(10, 0), False)),
        OBJECT(key1=TEXT(16777216), key2=NUMBER(10, 0)), # Without nullable flag
    ),
    external_volume="external_volume",
    base_location="base_location",
)

-- Example 16884
IcebergTable(
    table_name,
    metadata,
    Column("id", Integer, primary_key=True),
    Column("array_col", ARRAY(TEXT(16777216))),
    external_volume="external_volume",
    base_location="base_location",
)

-- Example 16885
t = Table('myuser', metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String),
    snowflake_clusterby=['id', 'name'], ...
)
metadata.create_all(engine)

-- Example 16886
from alembic.ddl.impl import DefaultImpl

class SnowflakeImpl(DefaultImpl):
    __dialect__ = 'snowflake'

-- Example 16887
...
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

with open("rsa_key.p8", "rb") as key:
    p_key= serialization.load_pem_private_key(
        key.read(),
        password=os.environ['PRIVATE_KEY_PASSPHRASE'].encode(),
        backend=default_backend()
    )

pkb = p_key.private_bytes(
    encoding=serialization.Encoding.DER,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption())

engine = create_engine(URL(
    account='abc123',
    user='testuser1',
    ),
    connect_args={
        'private_key': pkb,
        },
    )

-- Example 16888
from sqlalchemy.orm import sessionmaker
from sqlalchemy import MetaData, create_engine
from snowflake.sqlalchemy import MergeInto

engine = create_engine(db.url, echo=False)
session = sessionmaker(bind=engine)()
connection = engine.connect()

meta = MetaData()
meta.reflect(bind=session.bind)
t1 = meta.tables['t1']
t2 = meta.tables['t2']

merge = MergeInto(target=t1, source=t2, on=t1.c.t1key == t2.c.t2key)
merge.when_matched_then_delete().where(t2.c.marked == 1)
merge.when_matched_then_update().where(t2.c.isnewstatus == 1).values(val = t2.c.newval, status=t2.c.newstatus)
merge.when_matched_then_update().values(val=t2.c.newval)
merge.when_not_matched_then_insert().values(val=t2.c.newval, status=t2.c.newstatus)
connection.execute(merge)

-- Example 16889
from sqlalchemy.orm import sessionmaker
from sqlalchemy import MetaData, create_engine
from snowflake.sqlalchemy import CopyIntoStorage, AWSBucket, CSVFormatter

engine = create_engine(db.url, echo=False)
session = sessionmaker(bind=engine)()
connection = engine.connect()

meta = MetaData()
meta.reflect(bind=session.bind)
users = meta.tables['users']

copy_into = CopyIntoStorage(from_=users,
                            into=AWSBucket.from_uri('s3://my_private_backup').encryption_aws_sse_kms('1234abcd-12ab-34cd-56ef-1234567890ab'),
                            formatter=CSVFormatter().null_if(['null', 'Null']))
connection.execute(copy_into)

-- Example 16890
table = IcebergTable(
        "myuser",
        metadata,
        Column("id", Integer, primary_key=True),
        Column("name", String),
        external_volume=external_volume_name,
        base_location="my_iceberg_table",
  as_query="SELECT * FROM table"
    )

-- Example 16891
class MyUser(Base):
    __tablename__ = "myuser"

    @classmethod
    def __table_cls__(cls, name, metadata, *arg, **kw):
        return IcebergTable(name, metadata, *arg, **kw)

    __table_args__ = {
        "external_volume": "my_external_volume",
        "base_location": "my_iceberg_table",
  "as_query": "SELECT * FROM table",
    }

    id = Column(Integer, primary_key=True)
    name = Column(String)

-- Example 16892
table = HybridTable(
    "myuser",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("name", String),
    Index("idx_name", "name")

-- Example 16893
class MyUser(Base):
    __tablename__ = "myuser"

    @classmethod
    def __table_cls__(cls, name, metadata, *arg, **kw):
        return HybridTable(name, metadata, *arg, **kw)

    __table_args__ = (
        Index("idx_name", "name"),
    )

    id = Column(Integer, primary_key=True)
    name = Column(String)

-- Example 16894
dynamic_test_table_1 = DynamicTable(
       "dynamic_MyUser",
       metadata,
       Column("id", Integer),
       Column("name", String),
       target_lag=(1, TimeUnit.HOURS), # Additionally you can use SnowflakeKeyword.DOWNSTREAM
       warehouse='test_wh',
refresh_mode=SnowflakeKeyword.FULL
       as_query="SELECT id, name from MyUser;"
   )

-- Example 16895
dynamic_test_table_1 = DynamicTable(
       "dynamic_MyUser",
       metadata,
       target_lag=(1, TimeUnit.HOURS),
       warehouse='test_wh',
refresh_mode=SnowflakeKeyword.FULL
       as_query=select(MyUser.id, MyUser.name)
   )

-- Example 16896
<configuration>
  ..
  <property>
    <name>snowflake.hive-metastore-listener.database-filter-regex</name>
    <value>mydb[^1]</value>
  </property>
</configuration>

-- Example 16897
<configuration>
  <property>
    <name>snowflake.jdbc.username</name>
    <value>jsmith</value>
  </property>
  <property>
    <name>snowflake.jdbc.password</name>
    <value>mySecurePassword</value>
  </property>
  <property>
    <name>snowflake.jdbc.role</name>
    <value>custom_role1</value>
  </property>
  <property>
    <name>snowflake.jdbc.account</name>
    <value>myaccount</value>
  </property>
  <property>
    <name>snowflake.jdbc.db</name>
    <value>mydb</value>
  </property>
  <property>
    <name>snowflake.jdbc.schema</name>
    <value>myschema</value>
  </property>
  <property>
    <name>snowflake.jdbc.connection</name>
    <value>jdbc:snowflake://myaccount.snowflakecomputing.com</value>
  </property>
  <property>
    <name>snowflake.hive-metastore-listener.integration</name>
    <value>s3_int</value>
  </property>
  <property>
    <name>snowflake.hive-metastore-listener.schemas</name>
    <value>myschema1,myschema2</value>
  </property>
</configuration>

-- Example 16898
<configuration>
 ...
 <property>
  <name>hive.metastore.event.listeners</name>
  <value>net.snowflake.hivemetastoreconnector.SnowflakeHiveListener</value>
 </property>
</configuration>

-- Example 16899
SHOW EXTERNAL TABLES IN <database>.<schema>;

-- Example 16900
ALTER TABLE <table_name> TOUCH [PARTITION partition_spec];

-- Example 16901
ALTER TABLE <table_name> TOUCH PARTITION <partition_spec>;

-- Example 16902
ALTER TABLE <table_name> TOUCH;

-- Example 16903
ALTER EXTERNAL TABLE exttable ADD PARTITION(partcol='1') LOCATION 's3:///files/2019/05/12';

ALTER EXTERNAL TABLE exttable ADD PARTITION(partcol='2') LOCATION 's3:///files/2019/05/12';

-- Example 16904
{
    "status": "CONFIGURING",
    "configurationStatus": "INSTALLED"
}

-- Example 16905
{
  "response_code": "OK"
}

-- Example 16906
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 16907
{
    "status": "CONFIGURING",
    "configurationStatus": "INSTALLED"
}

-- Example 16908
{
    "response_code": "OK",
    "message": "Instance has been initialized successfully."
}

-- Example 16909
{
    "response_code": "OK"
}

-- Example 16910
{
    "response_code": "OK"
}

-- Example 16911
{
    "response_code": "OK"
}

-- Example 16912
{
    "response_code": "OK"
}

-- Example 16913
{
  "response_code": "OK",
  "id": "<new resource ingestion definition id>"
}

-- Example 16914
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 16915
{
  "response_code": "OK"
}

-- Example 16916
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 16917
{
  "response_code": "OK"
}

-- Example 16918
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 16919
{
  "response_code": "OK",
  "message": "Resource successfully updated."
}

-- Example 16920
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 16921
SELECT COUNT(* ILIKE 'col1%') FROM mytable;

-- Example 16922
SELECT OBJECT_CONSTRUCT(* EXCLUDE col1) AS oc FROM mytable;

-- Example 16923
SELECT {* ILIKE 'col1%'} FROM mytable;

SELECT {* EXCLUDE col1} FROM mytable;

-- Example 16924
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE insert_row(table_identifier VARCHAR)
RETURNS TABLE()
LANGUAGE SQL
AS
$$
BEGIN
  LET stmt VARCHAR := 'INSERT INTO ' || table_identifier || ' VALUES (10)';
  LET res RESULTSET := (EXECUTE IMMEDIATE stmt);
  RETURN TABLE(res);
END;
$$;

-- Example 16925
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE insert_row(table_identifier VARCHAR)
RETURNS FLOAT
LANGUAGE JAVASCRIPT
AS
$$
  let res = snowflake.execute({
    sqlText: "INSERT INTO IDENTIFIER(?) VALUES (10);",
    binds : [TABLE_IDENTIFIER]
  });
  res.next()
  return res.getColumnValue(1);
$$;

-- Example 16926
USE ROLE table_owner;

CREATE OR REPLACE TABLE table_with_different_owner (x NUMBER) AS SELECT 42;

-- Example 16927
USE ROLE table_owner;

CALL insert_row('table_with_different_owner');

-- Example 16928
002003 (42S02): Uncaught exception of type 'STATEMENT_ERROR' on line 4 at position 25 : SQL compilation error:
Table 'TABLE_WITH_DIFFERENT_OWNER' does not exist or not authorized.

-- Example 16929
USE ROLE table_owner;

CALL insert_row(SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT'));

