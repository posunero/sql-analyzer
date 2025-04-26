-- Example 2857
CREATE [ OR REPLACE ] TABLE <name> ( ... , [ <outofline_constraint> ], ... )

ALTER TABLE <name> ADD <outofline_constraint>

-- Example 2858
ALTER TABLE <table_name> RENAME CONSTRAINT <old_name> TO <new_name>;

-- Example 2859
ALTER TABLE <table_name>
    { ALTER | MODIFY } { CONSTRAINT <name> | PRIMARY KEY | { UNIQUE | FOREIGN KEY } (<column_name>, [ ... ] ) }
    { [ [ NOT ] ENFORCED ] [ VALIDATE | NOVALIDATE ] [ RELY | NORELY ] };

-- Example 2860
ALTER TABLE <table_name> DROP { CONSTRAINT <name> | PRIMARY KEY | { UNIQUE | FOREIGN KEY } (<column>, [ ... ] ) } [ CASCADE | RESTRICT ]

-- Example 2861
ALTER TABLE <table_name> DROP COLUMN <name> [ CASCADE | RESTRICT ]

-- Example 2862
DROP { TABLE | SCHEMA | DATABASE } <name> [ CASCADE | RESTRICT ]

-- Example 2863
CallableStatement stmt = testConnection.prepareCall("call read_result_set(?,?) ");

-- Example 2864
CallableStatement stmt = testConnection.prepareCall("? = call read_result_set() ");  -- INVALID

-- Example 2865
ResultSet resultSet;
resultSet = connection.unwrap(SnowflakeConnection.class).createResultSet(queryID);

-- Example 2866
getColumns( connection,
    "TEMPORARYDB1",      // Database name.
    "TEMPORARYSCHEMA1",  // Schema name.
    "%",                 // All table names.
    "%"                  // All column names.
    );

-- Example 2867
getColumns(
    connection, "TEMPORARYDB1", "TEMPORARYSCHEMA1", "T\\_\\\\", "%" // All column names.
    );

-- Example 2868
Java sees...............: T\\_\\%\\\\
SQL sees................: T\_\%\\
The actual table name is: T_%\

-- Example 2869
// Demonstrate the Driver.getPropertyInfo() method.
  public static void do_the_real_work(String connectionString) throws Exception {
    Properties properties = new Properties();
    Driver driver = DriverManager.getDriver(connectionString);
    DriverPropertyInfo[] dpinfo = driver.getPropertyInfo("", properties);
    System.out.println(dpinfo[0].description);
  }

-- Example 2870
INSERT INTO t1 (c1, c2) VALUES (1, 'One');   -- single row inserted.

INSERT INTO t1 (c1, c2) VALUES (1, 'One'),   -- multiple rows inserted.
                               (2, 'Two'),
                               (3, 'Three');

-- Example 2871
...
PreparedStatement prepStatement = connection.prepareStatement("insert into testTable values (?)");
prepStatement.setInt(1, 33);
ResultSet rs = prepStatement.executeAsyncQuery();
...

-- Example 2872
// Retrieve the query ID from the PreparedStatement.
    String queryID;
    queryID = preparedStatement.unwrap(SnowflakePreparedStatement.class).getQueryID();

-- Example 2873
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
if (queryStatus == queryStatus.FAILED_WITH_ERROR) {
  // Print the error code to stdout
  System.out.format("Error code: %d%n", queryStatus.getErrorCode());
}

-- Example 2874
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
if (queryStatus == queryStatus.FAILED_WITH_ERROR) {
  // Print the error message to stdout
  System.out.format("Error message: %s%n", queryStatus.getErrorMessage());
}

-- Example 2875
String queryID2;
    queryID2 = resultSet.unwrap(SnowflakeResultSet.class).getQueryID();

-- Example 2876
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();

-- Example 2877
SnowflakeTimestampWithTimezone(
    long seconds,
    int nanoseconds,
    TimeZone tz)

-- Example 2878
SnowflakeTimestampWithTimezone(
    Timestamp ts,
    TimeZone tz)

-- Example 2879
SnowflakeTimestampWithTimezone(
    Timestamp ts)

-- Example 2880
import java.sql.Timestamp;
import java.time.ZonedDateTime;
import java.util.TimeZone;

public void testGetTimezone() {
    String timezone = "Australia/Sydney";

    // Create a timestamp from a point in time
    Long datetime = System.currentTimeMillis();
    Timestamp currentTimestamp = new Timestamp(datetime);
    SnowflakeTimestampWithTimezone ts =
        new SnowflakeTimestampWithTimezone(currentTimestamp, TimeZone.getTimeZone(timezone));

    // Verify timezone was set
    assertEquals(ts.getTimezone().getID(), timezone);
}

-- Example 2881
import java.sql.Timestamp;
import java.time.ZonedDateTime;
import java.util.TimeZone;

public void testToZonedDateTime() {
    String timezone = "Australia/Sydney";
    String zonedDateTime = "2022-03-17T10:10:08+11:00[Australia/Sydney]";

    // Create a timestamp from a point in time
    Long datetime = 1647472208000L;
    Timestamp timestamp = new Timestamp(datetime);
    SnowflakeTimestampWithTimezone ts =
        new SnowflakeTimestampWithTimezone(timestamp, TimeZone.getTimeZone(timezone));
    ZonedDateTime zd = ts.toZonedDateTime();

    // Verify timestamp was converted to zoned datetime
    assertEquals(zd.toString(), zonedDateTime);
}

-- Example 2882
connection.setAutoCommit(false);
    statement.addBatch("SELECT 1;");
    statement.addBatch("SELECT 2;");
    statement.executeBatch();
    connection.commit();
    connection.setAutoCommit(true);
    List<String> batchQueryIDs1;
    // Since getQueryID is not standard JDBC API, we must call unwrap() to
    // use these Snowflake methods.
    batchQueryIDs1 = statement.unwrap(SnowflakeStatement.class).getBatchQueryIDs();
    int num_query_ids = batchQueryIDs1.size();
    if (num_query_ids != 2) {
      System.out.println("ERROR: wrong number of query IDs in batch 1.");
    }
    // Check that each query ID is plausible.
    for (int i = 0; i < num_query_ids; i++) {
      String qid = batchQueryIDs1.get(i);
      if (!is_plausible_query_id(qid)) {
        msg = "SEVERE WARNING: suspicious query ID in batch";
        System.out.println("msg");
        System.out.println(qid);
      }
    }

-- Example 2883
String queryID1;
    queryID1 = statement.unwrap(SnowflakeStatement.class).getQueryID();

-- Example 2884
Statement statement1;
...
// Tell Statement to expect to execute 2 statements:
statement1.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 2);

-- Example 2885
////////////////////////////////////////////////////////////////////////////////////////////////////
/// Custom SQL Data Type Definition
///
///
////////////////////////////////////////////////////////////////////////////////////////////////////

#define SQL_SF_TIMESTAMP_LTZ 2000
#define SQL_SF_TIMESTAMP_TZ  2001
#define SQL_SF_TIMESTAMP_NTZ 2002
#define SQL_SF_ARRAY         2003
#define SQL_SF_OBJECT        2004
#define SQL_SF_VARIANT       2005

-- Example 2886
// bind insert as timestamp_ntz
SQLRETURN rc;
rc = SQLPrepare(odbc.StmtHandle,
               (SQLCHAR *) "insert into testtimestampntz values (?)",
               SQL_NTS);

 SQL_TIMESTAMP_STRUCT bindData;
 SQLLEN datalen = sizeof(SQL_TIMESTAMP_STRUCT);
 bindData.year = 2017;
 bindData.month = 11;
 bindData.day = 30;
 bindData.hour = 18;
 bindData.minute = 17;
 bindData.second = 5;
 bindData.fraction = 123456789;

 rc = SQLBindParameter(
   odbc.StmtHandle, 1, SQL_PARAM_INPUT,
   SQL_C_TIMESTAMP, SQL_SF_TIMESTAMP_NTZ,
   100, 0, &bindData, sizeof(bindData), &datalen);

 rc = SQLExecute(odbc.StmtHandle);

 // query table
 rc = SQLExecDirect(odbc.StmtHandle, (SQLCHAR *)"select * from testtimestampntz", SQL_NTS);

 rc = SQLFetch(odbc.StmtHandle);

 // fetch data as timestamp
 SQL_TIMESTAMP_STRUCT ret;
 SQLLEN retLen = (SQLLEN) 0;
 rc = SQLGetData(odbc.StmtHandle, 1, SQL_C_TIMESTAMP, &ret, (SQLLEN)sizeof(ret), &retLen);

-- Example 2887
// Space to store the query ID.
// The SQLGetStmtAttr() function fills this in with the actual ID.
char queryId[37];   // Maximum 36 chars plus string terminator.

// The length (in characters) of the query ID. The SQLGetStmtAttr() function fills this in
// with the actual length of the query ID (usually 36).
SQLINTEGER idLen;

// Execute a query.
rc = SQLExecDirect(odbc.StmtHandle, (SQLCHAR *) "select 1", SQL_NTS);

// Retrieve the query ID (queryId) and the length of that query ID (idLen).
SQLGetStmtAttr(odbc.StmtHandle, SQL_SF_STMT_ATTR_LAST_QUERY_ID, queryId, sizeof(queryId), &idLen);

-- Example 2888
SQLRETURN rc;
SQLSMALLINT numCols;
const size_t s_MaxDataLen = 300;

// fetch with SQLGetData()
// query table
rc = SQLExecDirect(stmt, (SQLCHAR *)"select * from table", SQL_NTS);

// Find out the number of result set columns.
rc = SQLNumResultCols(stmt, &numCols);

// buffer for one cell
vector<char> dataBuffer(s_MaxDataLen);
SQLLEN dataLen = (SQLLEN)0;

// call SQLFetch() per row and SQLGetData() per column per row
while (true)
{
    rc = SQLFetch(stmt);
    if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
    {
        break;
    }
    for (SQLUSMALLINT i = 0; i < numCols; i++)
    {
        rc = SQLGetData(stmt, i + 1, SQL_C_CHAR, dataBuffer.data(), (SQLLEN)s_MaxDataLen, &dataLen);
        std::string data;
        if (SQL_NULL_DATA == dataLen)
            continue;
        if (SQL_NO_TOTAL == dataLen)
            dataLen = s_MaxDataLen;
        data = std::string(dataBuffer.data(), dataLen);
    }
}
rc = SQLCloseCursor(stmt);

-- Example 2889
SQLRETURN rc;
SQLSMALLINT numCols;
const size_t s_MaxDataLen = 300;

// fetch with SQLBindCol()
// query table
rc = SQLExecDirect(stmt, (SQLCHAR *)"select * from table", SQL_NTS);

// Find out the number of result set columns.
rc = SQLNumResultCols(stmt, &numCols);

// buffer for one row
vector<char> rowBuffer(s_MaxDataLen * numCols);
vector<SQLLEN> columnLenBuffer(numCols);

// call SQLBindCol() per column
for (SQLSMALLINT i = 0; i < numCols; ++i)
{
    SQLBindCol(stmt, i + 1, SQL_C_CHAR, &rowBuffer[s_MaxDataLen * i],
               s_MaxDataLen, &columnLenBuffer[i]);
}

// call SQLFetch() per row
while (true)
{
    rc = SQLFetch(stmt);
    if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
    {
         break;
    }
    // go through data for each cell in buffer without ODBC calls
    for (SQLUSMALLINT i = 0; i < numCols; i++)
    {
        std::string data;
        SQLLEN len = columnLenBuffer[i];
        if (SQL_NULL_DATA == len)
            continue;
        if (SQL_NO_TOTAL == len)
            len = s_MaxDataLen;
        data = std::string(&rowBuffer[s_MaxDataLen * i], len);
    }
}
rc = SQLCloseCursor(stmt);

-- Example 2890
SQLRETURN rc;
SQLSMALLINT numCols;
const size_t s_MaxDataLen = 300;

// fetch with SQLBindCol() and SQL_ATTR_ROW_ARRAY_SIZE > 1
const size_t s_numRowsPerSQLFetch = 100;
SQLULEN numRowsFetched = 0;
rc = SQLSetStmtAttr(stmt, SQL_ATTR_ROW_ARRAY_SIZE, (SQLPOINTER)s_numRowsPerSQLFetch, 0);
rc = SQLSetStmtAttr(stmt, SQL_ATTR_ROWS_FETCHED_PTR, (SQLPOINTER)&numRowsFetched, sizeof(SQLULEN));

// query table
rc = SQLExecDirect(stmt, (SQLCHAR *)"select * from table", SQL_NTS);

// Find out the number of result set columns.
rc = SQLNumResultCols(stmt, &numCols);

// buffer for all columns; each column has buffer size of s_numRowsPerSQLFetch
// To retrieve multiple rows per SQLFetch() call, use the default behavior of SQL_BIND_BY_COLUMN
vector<vector<char> > colArray(numCols);
vector<vector<SQLLEN> > colLenArray(numCols);

// call SQLBindCol() per column
for (SQLSMALLINT i = 0; i < numCols; ++i)
{
    // initialize buffer for each column
    colArray[i].resize(s_MaxDataLen * s_numRowsPerSQLFetch);
    colLenArray[i].resize(s_numRowsPerSQLFetch);

    SQLBindCol(stmt, i + 1, SQL_C_CHAR, colArray[i].data(),
                s_MaxDataLen, colLenArray[i].data());
}

// call SQLFetch() per s_numRowsPerSQLFetch rows
while (true)
{
    rc = SQLFetch(stmt);
    if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
    {
        break;
    }
    // go through data for each cell in buffer without ODBC calls
    for (SQLULEN rowIndex = 0; rowIndex < numRowsFetched; rowIndex++)
    {
        for (SQLUSMALLINT colIndex = 0; colIndex < colIndex; colIndex++)
        {
            std::string data;
            SQLLEN len = colLenArray[colIndex][rowIndex];
            if (SQL_NULL_DATA == len)
                continue;
            if (SQL_NO_TOTAL == len)
                len = s_MaxDataLen;
            data = std::string(&(colArray[colIndex][s_MaxDataLen * rowIndex]), len);
        }
    }
}
rc = SQLCloseCursor(stmt);

-- Example 2891
format: .execute("... WHERE my_column = %s", (value,))
pyformat: .execute("... WHERE my_column = %(name)s", {"name": value})
qmark: .execute("... WHERE my_column = ?", (value,))
numeric: .execute("... WHERE my_column = :1", (value,))

-- Example 2892
ctx = snowflake.connector.connect(
    user='<user_name>',
    password='<password>',
    account='myorganization-myaccount',
    ... )

-- Example 2893
ctx = snowflake.connector.connect(
    user='<user_name>',
    password='<password>',
    account='xy12345',
    ... )

-- Example 2894
# context manager ensures the connection is closed
with snowflake.connector.connect(...) as con:
    con.cursor().execute(...)

# try & finally to ensure the connection is closed.
con = snowflake.connector.connect(...)
try:
    con.cursor().execute(...)
finally:
    con.close()

-- Example 2895
cursor_list = connection1.execute_string(
    "SELECT * FROM testtable WHERE col1 LIKE 'T%';"
    "SELECT * FROM testtable WHERE col2 LIKE 'A%';"
    )

for cursor in cursor_list:
   for row in cursor:
      print(row[0], row[1])

-- Example 2896
# "Binding" data via the format() function (UNSAFE EXAMPLE)
value1_from_user = "'ok3'); DELETE FROM testtable WHERE col1 = 'ok1'; select pi("
sql_cmd = "insert into testtable(col1) values('ok1'); "                  \
          "insert into testtable(col1) values('ok2'); "                  \
          "insert into testtable(col1) values({col1});".format(col1=value1_from_user)
# Show what SQL Injection can do to a composed statement.
print(sql_cmd)

connection1.execute_string(sql_cmd)

-- Example 2897
insert into testtable(col1) values('ok1');
insert into testtable(col1) values('ok2');
insert into testtable(col1) values('ok3');
DELETE FROM testtable WHERE col1 = 'ok1';
select pi();

-- Example 2898
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

-- Example 2899
@mystage/myfile.csv

-- Example 2900
cursor.execute(
    "PUT file://this_directory_path/is_ignored/myfile.csv @mystage",
    file_stream=<io_object>)

-- Example 2901
"insert into testy (v1, v2) values (?, ?)"

-- Example 2902
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

-- Example 2903
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

-- Example 2904
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

-- Example 2905
import pandas
from snowflake.connector.pandas_tools import write_pandas

# Create the connection to the Snowflake database.
cnx = snowflake.connector.connect(...)

# Create a DataFrame containing data about customers
df = pandas.DataFrame([('Mark', 10), ('Luke', 20)], columns=['name', 'balance'])

# Write the data from the DataFrame to the table named "customers".
success, nchunks, nrows, _ = write_pandas(cnx, df, 'customers')

-- Example 2906
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

-- Example 2907
import pandas
from snowflake.connector.pandas_tools import pd_writer

# Create a DataFrame containing data about customers
df = pandas.DataFrame([('Mark', 10), ('Luke', 20)], columns=['name', 'balance'])

# Specify that the to_sql method should use the pd_writer function
# to write the data from the DataFrame to the table named "customers"
# in the Snowflake database.
df.to_sql('customers', engine, index=False, method=pd_writer)

-- Example 2908
POST /api/v2/statements
(request body)

-- Example 2909
"data" : [ [ null ], ... ]

-- Example 2910
"data" : [ [ "null" ], ... ]

-- Example 2911
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 18:06:24 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=0>; rel="last"
{
  "resultSetMetaData" : {
    "numRows" : 4,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "COLUMN1",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : null,
      "precision" : null,
      "length" : 4,
      "type" : "text",
      "nullable" : false,
      "byteLength" : 16,
      "collation" : null
    }, {
      "name" : "COLUMN2",
      "database" : "",
      "schema" : "",
      "table" : "\"VALUES\"",
      "scale" : 0,
      "precision" : 1,
      "length" : null,
      "type" : "fixed",
      "nullable" : false,
      "byteLength" : null,
      "collation" : null
    } ],
    "partitionInfo": [{
      "rowCount": 4,
      "uncompressedSize": 1438,
    }]
  },
  "data" : [ [ "test", "2" ], [ "test", "3" ], [ "test", "4" ], [ "test", "5" ] ],
  "code" : "090001",
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id3}&partition=0",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1620151584132
}

-- Example 2912
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 18:08:15 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=1>; rel="next",
  </api/v2/statements/{handle}?requestId={id3}&partition=1>; rel="last"
{
  "resultSetMetaData" : {
    "numRows" : 56090,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "SEQ8()",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : 0,
      "precision" : 19,
      "length" : null,
      "type" : "fixed",
      "nullable" : false,
      "byteLength" : null,
      "collation" : null
    }, {
      "name" : "RANDSTR(1000, RANDOM())",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : null,
      "precision" : null,
      "length" : 16777216,
      "type" : "text",
      "nullable" : false,
      "byteLength" : 16777216,
      "collation" : null
    } ],
    "partitionInfo": [{
      "rowCount": 12344,
      "uncompressedSize": 14384873,
    },{
      "rowCount": 43746,
      "uncompressedSize": 43748274,
      "compressedSize": 746323
    }]
  },
  "data" : [ [ "0", "QqKow2xzdJ....." ],.... [ "98", "ZugTcURrcy...." ] ],
  "code" : "090001",
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id4}",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1620151693299
}

-- Example 2913
HTTP/1.1 200 OK
Date: Mon, 31 May 2021 22:50:31 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=1>; rel="last"

{
  "resultSetMetaData" : {
  "numRows" : 56090,
  "format" : "jsonv2",
  "rowType" : [ {
      "name" : "multiple statement execution",
      "database" : "",
      "schema" : "",
      "table" : "",
      "type" : "text",
      "scale" : null,
      "precision" : null,
      "byteLength" : 16777216,
      "nullable" : false,
      "collation" : null,
      "length" : 16777216
    } ],
    "partitionInfo": [{
      "rowCount": 12344,
      "uncompressedSize": 14384873,
    },{
     "rowCount": 43746,
     "uncompressedSize": 43748274,
     "compressedSize": 746323
    }]
  },
  "data" : [ [ "Multiple statements executed successfully." ] ],
  "code" : "090001",
  "statementHandles" : [ "{handle1}", "{handle2}", "{handle3}" ],
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id3}",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1622501430333
}

-- Example 2914
HTTP/1.1 202 Accepted
Date: Tue, 04 May 2021 18:12:37 GMT
Content-Type: application/json
Content-Length: 285
{
  "code" : "333334",
  "message" :
      "Asynchronous execution in progress. Use provided query id to perform query monitoring and management.",
  "statementHandle" : "019c06a4-0000-df4f-0000-00100006589e",
  "statementStatusUrl" : "/api/v2/statements/019c06a4-0000-df4f-0000-00100006589e"
}

-- Example 2915
HTTP/1.1 422 Unprocessable Entity
Date: Tue, 04 May 2021 20:24:11 GMT
Content-Type: application/json
{
  "code" : "000904",
  "message" : "SQL compilation error: error line 1 at position 7\ninvalid identifier 'AFAF'",
  "sqlState" : "42000",
  "statementHandle" : "019c0728-0000-df4f-0000-00100006606e"
}

-- Example 2916
GET /api/v2/statements/{statementHandle}

-- Example 2917
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 20:25:46 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=0>; rel="prev",
  </api/v2/statements/{handle}?requestId={id3}&partition=1>; rel="next",
  </api/v2/statements/{handle}?requestId={id4}&partition=10>; rel="last"
{
  "resultSetMetaData" : {
    "numRows" : 10000,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "SEQ8()",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : 0,
      "precision" : 19,
      "length" : null,
      "type" : "fixed",
      "nullable" : false,
      "byteLength" : null,
      "collation" : null
    }, {
      "name" : "RANDSTR(1000, RANDOM())",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : null,
      "precision" : null,
      "length" : 16777216,
      "type" : "text",
      "nullable" : false,
      "byteLength" : 16777216,
      "collation" : null
    } ],
    "partitionInfo": [{
      "rowCount": 12344,
      "uncompressedSize": 14384873,
    },{
      "rowCount": 43746,
      "uncompressedSize": 43748274,
      "compressedSize": 746323
    }]
  },
  "data" : [ [ "10", "lJPPMTSwps......" ], ... [ "19", "VJKoHmUFJz......" ] ],
  "code" : "090001",
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id5}&partition=10",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1620151693299
}

-- Example 2918
HTTP/1.1 202 Accepted
Date: Tue, 04 May 2021 22:31:33 GMT
Content-Type: application/json
Content-Length: 285
{
  "code" : "333334",
  "message" :
      "Asynchronous execution in progress. Use provided query id to perform query monitoring and management.",
  "statementHandle" : "019c07a7-0000-df4f-0000-001000067872",
  "statementStatusUrl" : "/api/v2/statements/019c07a7-0000-df4f-0000-001000067872"
}

-- Example 2919
POST /api/v2/statements/{statementHandle}/cancel

-- Example 2920
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 22:52:15 GMT
Content-Type: application/json
Content-Length: 230
{
  "code" : "000604",
  "sqlState" : "57014",
  "message" : "SQL execution canceled",
  "statementHandle" : "019c07bc-0000-df4f-0000-001000067c3e",
  "statementStatusUrl" : "/api/v2/statements/019c07bc-0000-df4f-0000-001000067c3e"
}

-- Example 2921
HTTP/1.1 422 Unprocessable Entity
Date: Tue, 04 May 2021 22:52:49 GMT
Content-Type: application/json
Content-Length: 183
{
  "code" : "000709",
  "message" : "Statement 019c07bc-0000-df4f-0000-001000067c3e not found",
  "sqlState" : "02000",
  "statementHandle" : "019c07bc-0000-df4f-0000-001000067c3e"
}

-- Example 2922
{"1":{"type":"FIXED","value":"123"},"2":{"type":"TEXT","value":"teststring"}}

-- Example 2923
{
  "statement" : "select * from T where c1=?",
  "timeout" : 10,
  "database" : "TESTDB",
  "schema" : "TESTSCHEMA",
  "warehouse" : "TESTWH",
  "role" : "TESTROLE",
  "bindings" : {
    "1" : {
      "type" : "FIXED",
      "value" : "123"
    }
  }
}

-- Example 2924
HTTP/1.1 400 Bad Request
Date: Tue, 04 May 2021 22:54:21 GMT
Content-Type: application/json
{
  "code" : "390142",
  "message" : "Incoming request does not contain a valid payload."
}

