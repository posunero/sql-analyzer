-- Example 20279
CREATE OR REPLACE PROCEDURE min_max_invoices_sp(
    minimum_price NUMBER(12,2),
    maximum_price NUMBER(12,2))
  RETURNS TABLE (id INTEGER, price NUMBER(12, 2))
  LANGUAGE SQL
AS
DECLARE
  rs RESULTSET;
  query VARCHAR DEFAULT 'SELECT * FROM invoices WHERE price > ? AND price < ?';
BEGIN
  rs := (EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price));
  RETURN TABLE(rs);
END;

-- Example 20280
CREATE OR REPLACE PROCEDURE min_max_invoices_sp(
    minimum_price NUMBER(12,2),
    maximum_price NUMBER(12,2))
  RETURNS TABLE (id INTEGER, price NUMBER(12, 2))
  LANGUAGE SQL
AS
$$
DECLARE
  rs RESULTSET;
  query VARCHAR DEFAULT 'SELECT * FROM invoices WHERE price > ? AND price < ?';
BEGIN
  rs := (EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price));
  RETURN TABLE(rs);
END;
$$
;

-- Example 20281
CALL min_max_invoices_sp(20, 30);

-- Example 20282
+----+-------+
| ID | PRICE |
|----+-------|
|  2 | 22.22 |
+----+-------+

-- Example 20283
SET stmt =
$$
    SELECT PI();
$$
;

-- Example 20284
EXECUTE IMMEDIATE $stmt;

-- Example 20285
+-------------+
|        PI() |
|-------------|
| 3.141592654 |
+-------------+

-- Example 20286
EXECUTE IMMEDIATE $$
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := PI() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;
$$
;

-- Example 20287
+-----------------+
| anonymous block |
|-----------------|
|    28.274333882 |
+-----------------+

-- Example 20288
POST /api/v2/statements HTTP/1.1
(request body)

-- Example 20289
{
  "statement": "select * from my_table",
  ...
}

-- Example 20290
curl -i -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <jwt>" \
    -H "Accept: application/json" \
    -H "User-Agent: myApplicationName/1.0" \
    -d "@request-body.json" \
    "https://<account_identifier>.snowflakecomputing.com/api/v2/statements"

-- Example 20291
{
  "statement": "select * from T where c1=?",
  "timeout": 60,
  "database": "TESTDB",
  "schema": "TESTSCHEMA",
  "warehouse": "TESTWH",
  "role": "TESTROLE",
  "bindings": {
    "1": {
      "type": "FIXED",
      "value": "123"
    }
  }
}

-- Example 20292
...
"statement": "select * from T where c1=?",
...
"bindings": {
  "1": {
    "type": "FIXED",
    "value": "123"
  }
},
...

-- Example 20293
{
  code: "100037",
  message: "<bind type> value '<value>' is not recognized",
  sqlState: "22018",
  statementHandle: "<ID>"
}

-- Example 20294
POST /api/v2/statements?requestId=ea7b46ed-bdc1-8c32-d593-764fcad64e83&retry=true HTTP/1.1

-- Example 20295
Statement statement1;
...
// Unwrap the statement1 object to expose the SnowflakeStatement object, and call the
// SnowflakeStatement object's setParameter() method.
statement1.unwrap(SnowflakeStatement.class).setParameter(...);

-- Example 20296
QueryStatus queryStatus = QueryStatus.RUNNING;
while (queryStatus != QueryStatus.SUCCESS)  {     //  NOT RECOMMENDED
    Thread.sleep(2000);   // 2000 milliseconds.
    queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

-- Example 20297
// Assume that the query is not done yet.
QueryStatus queryStatus = QueryStatus.RUNNING;
while (queryStatus == QueryStatus.RUNNING || queryStatus == QueryStatus.RESUMING_WAREHOUSE)  {
    Thread.sleep(2000);   // 2000 milliseconds.
    queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

if (queryStatus == QueryStatus.SUCCESS) {
    ...
    }

-- Example 20298
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import net.snowflake.client.core.QueryStatus;
import net.snowflake.client.jdbc.SnowflakeConnection;
import net.snowflake.client.jdbc.SnowflakeResultSet;
import net.snowflake.client.jdbc.SnowflakeStatement;

-- Example 20299
String sql_command = "";
    ResultSet resultSet;

    System.out.println("Create JDBC statement.");
    Statement statement = connection.createStatement();
    sql_command = "SELECT PI()";
    System.out.println("Simple SELECT query: " + sql_command);
    resultSet = statement.unwrap(SnowflakeStatement.class).executeAsyncQuery(sql_command);

    // Assume that the query isn't done yet.
    QueryStatus queryStatus = QueryStatus.RUNNING;
    while (queryStatus == QueryStatus.RUNNING || queryStatus == QueryStatus.RESUMING_WAREHOUSE) {
      Thread.sleep(2000); // 2000 milliseconds.
      queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

    if (queryStatus == QueryStatus.FAILED_WITH_ERROR) {
      // Print the error code to stdout
      System.out.format("Error code: %d%n", queryStatus.getErrorCode());
      System.out.format("Error message: %s%n", queryStatus.getErrorMessage());
    } else if (queryStatus != QueryStatus.SUCCESS) {
      System.out.println("ERROR: unexpected QueryStatus: " + queryStatus);
    } else {
      boolean result_exists = resultSet.next();
      if (!result_exists) {
        System.out.println("ERROR: No rows returned.");
      } else {
        float pi_result = resultSet.getFloat(1);
        System.out.println("pi = " + pi_result);
      }
    }

-- Example 20300
String sql_command = "";
    ResultSet resultSet;
    String queryID = "";

    System.out.println("Create JDBC statement.");
    Statement statement = connection.createStatement();
    sql_command = "SELECT PI() * 2";
    System.out.println("Simple SELECT query: " + sql_command);
    resultSet = statement.unwrap(SnowflakeStatement.class).executeAsyncQuery(sql_command);
    queryID = resultSet.unwrap(SnowflakeResultSet.class).getQueryID();
    System.out.println("INFO: Closing statement.");
    statement.close();
    System.out.println("INFO: Closing connection.");
    connection.close();

    System.out.println("INFO: Re-opening connection.");
    connection = create_connection(args);
    use_warehouse_db_and_schema(connection);
    resultSet = connection.unwrap(SnowflakeConnection.class).createResultSet(queryID);

    // Assume that the query isn't done yet.
    QueryStatus queryStatus = QueryStatus.RUNNING;
    while (queryStatus == QueryStatus.RUNNING) {
      Thread.sleep(2000); // 2000 milliseconds.
      queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

    if (queryStatus == QueryStatus.FAILED_WITH_ERROR) {
      System.out.format(
          "ERROR %d: %s%n", queryStatus.getErrorMessage(), queryStatus.getErrorCode());
    } else if (queryStatus != QueryStatus.SUCCESS) {
      System.out.println("ERROR: unexpected QueryStatus: " + queryStatus);
    } else {
      boolean result_exists = resultSet.next();
      if (!result_exists) {
        System.out.println("ERROR: No rows returned.");
      } else {
        float pi_result = resultSet.getFloat(1);
        System.out.println("pi = " + pi_result);
      }
    }

-- Example 20301
/**
 * Method to compress data from a stream and upload it at a stage location.
 * The data will be uploaded as one file. No splitting is done in this method.
 *
 * Caller is responsible for releasing the inputStream after the method is
 * called.
 *
 * @param stageName    stage name: e.g. ~ or table name or stage name
 * @param destPrefix   path / prefix under which the data should be uploaded on the stage
 * @param inputStream  input stream from which the data will be uploaded
 * @param destFileName destination file name to use
 * @param compressData compress data or not before uploading stream
 * @throws java.sql.SQLException failed to compress and put data from a stream at stage
 */
public void uploadStream(String stageName,
                         String destPrefix,
                         InputStream inputStream,
                         String destFileName,
                         boolean compressData)
    throws SQLException

-- Example 20302
Connection connection = DriverManager.getConnection(url, prop);
File file = new File("/tmp/test.csv");
FileInputStream fileInputStream = new FileInputStream(file);

// upload file stream to user stage
connection.unwrap(SnowflakeConnection.class).uploadStream("MYSTAGE", "testUploadStream",
   fileInputStream, "destFile.csv", true);

-- Example 20303
...

// For versions prior to 3.9.2:
// upload file stream to user stage
((SnowflakeConnectionV1) connection.uploadStream("MYSTAGE", "testUploadStream",
   fileInputStream, "destFile.csv", true));

-- Example 20304
/**
 * Download file from the given stage and return an input stream
 *
 * @param stageName      stage name
 * @param sourceFileName file path in stage
 * @param decompress     true if file compressed
 * @return an input stream
 * @throws SnowflakeSQLException if any SQL error occurs.
 */
InputStream downloadStream(String stageName,
                           String sourceFileName,
                           boolean decompress) throws SQLException;

-- Example 20305
Connection connection = DriverManager.getConnection(url, prop);
InputStream out = connection.unwrap(SnowflakeConnection.class).downloadStream(
    "~",
    DEST_PREFIX + "/" + TEST_DATA_FILE + ".gz",
    true);

-- Example 20306
...

// For versions prior to 3.9.2:
// download file stream to user stage
((SnowflakeConnectionV1) connection.downloadStream(...));

-- Example 20307
alter session set MULTI_STATEMENT_COUNT = 0;

-- Example 20308
alter account set MULTI_STATEMENT_COUNT = 0;

-- Example 20309
// Specify the number of statements that we expect to execute.
statement.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 3);

-- Example 20310
// Create a string that contains multiple SQL statements.
String command_string = "create table test(n int); " +
                        "insert into test values (1), (2); " +
                        "select * from test order by n";
Statement stmt = connection.createStatement();
// Specify the number of statements (3) that we expect to execute.
stmt.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 3);

// Execute all of the statements.
stmt.execute(command_string);                       // false

// --- Get results. ---
// First statement (create table)
stmt.getUpdateCount();                              // 0 (DDL)

// Second statement (insert)
stmt.getMoreResults();                              // true
stmt.getUpdateCount();                              // 2

// Third statement (select)
stmt.getMoreResults();                              // true
ResultSet rs = stmt.getResultSet();
rs.next();                                          // true
rs.getInt(1);                                       // 1
rs.next();                                          // true
rs.getInt(1);                                       // 2
rs.next();                                          // false

// Past the last statement executed.
stmt.getMoreResults();                              // false
stmt.getUpdateCount();                              // 0 (no more results)

-- Example 20311
CREATE OR REPLACE TABLE test(n int);
INSERT INTO TEST VALUES (1), (2);
INSERT INTO TEST VALUES ('not_an_int');  -- execution fails here
INSERT INTO TEST VALUES (3);

-- Example 20312
stmt.execute("UPDATE table1 SET integer_column = 42 WHERE ID = 1000");

-- Example 20313
int my_integer_variable = 42;
PreparedStatement pstmt = connection.prepareStatement("UPDATE table1 SET integer_column = ? WHERE ID = 1000");
pstmt.setInt(1, my_integer_variable);
pstmt.executeUpdate();

-- Example 20314
// The following call interprets the timestamp in terms of the local time zone.
insertStmt.setTimestamp(1, myTimestamp);
// The following call interprets the timestamp in terms of the time zone of the Calendar object.
insertStmt.setTimestamp(1, myTimestamp, Calendar.getInstance(TimeZone.getTimeZone("America/New_York")));

-- Example 20315
import net.snowflake.client.jdbc.SnowflakeUtil;
...
insertStmt.setObject(1, myTimestamp, SnowflakeUtil.EXTRA_TYPES_TIMESTAMP_NTZ);

-- Example 20316
Connection connection = DriverManager.getConnection(url, prop);
connection.setAutoCommit(false);

PreparedStatement pstmt = connection.prepareStatement("INSERT INTO t(c1, c2) VALUES(?, ?)");
pstmt.setInt(1, 101);
pstmt.setString(2, "test1");
pstmt.addBatch();

pstmt.setInt(1, 102);
pstmt.setString(2, "test2");
pstmt.addBatch();

int[] count = pstmt.executeBatch(); // After execution, count[0]=1, count[1]=1
connection.commit();

-- Example 20317
CREATE TEMPORARY STAGE SYSTEM$BIND file_format=(type=csv field_optionally_enclosed_by='"')
Cannot perform CREATE STAGE. This session does not have a current schema. Call 'USE SCHEMA', or use a qualified name.

-- Example 20318
I/O error: Connection reset

-- Example 20319
// Set the "time to live" to 60 seconds.
System.setProperty("net.snowflake.jdbc.ttl", "60")

-- Example 20320
# Set the "time to live" to 60 seconds.
java -cp .:snowflake-jdbc-<version>.jar -Dnet.snowflake.jdbc.ttl=60 <ClassName>

-- Example 20321
var statement = connection.execute({
  sqlText: 'CREATE DATABASE testdb',
  complete: function(err, stmt, rows) {
    if (err) {
      console.error('Failed to execute statement due to the following error: ' + err.message);
    } else {
      console.log('Successfully executed statement: ' + stmt.getSqlText());
    }
  }
});

-- Example 20322
let queryId;
let statement;

// 1. Execute query with asyncExec set to true
await new Promise((resolve) =>
{
  connection.execute({
    sqlText: 'CALL SYSTEM$WAIT(3, \'SECONDS\')',
    asyncExec: true,
    complete: async function (err, stmt, rows)
    {
      queryId = stmt.getQueryId(); // Get the query ID
      resolve();
    }
  });
});

// 2. Get results using the query ID
const statement = await connection.getResultsFromQueryId({ queryId: queryId });
await new Promise((resolve, reject) =>
{
  var stream = statement.streamRows();
  stream.on('error', function (err)
  {
    reject(err);
  });
  stream.on('data', function (row)
  {
    console.log(row);
  });
  stream.on('end', function ()
  {
    resolve();
  });
});

-- Example 20323
// 1. Execute query with asyncExec set to true
connection.execute({
  sqlText: 'CALL SYSTEM$WAIT(3, \'SECONDS\')',
  asyncExec: true,
  complete: async function (err, stmt, rows)
  {
    let queryId = stmt.getQueryId();

    // 2. Get results using the query ID
    connection.getResultsFromQueryId({
      queryId: queryId,
      complete: async function (err, _stmt, rows)
      {
        console.log(rows);
      }
    });
  }
});

-- Example 20324
let queryId;

// 1. Execute query with asyncExec set to true
await new Promise((resolve, reject) =>
{
  statement = connection.execute({
    sqlText: 'CALL SYSTEM$WAIT(3, \'SECONDS\')',
    asyncExec: true,
    complete: async function (err, stmt, rows)
    {
      queryId = statement.getQueryId();
      resolve();
    }
  });
});

// 2. Check query status until it's finished executing
const seconds = 2;
let status = await connection.getQueryStatus(queryId);
while (connection.isStillRunning(status))
{
  console.log(`Query status is ${status}, timeout for ${seconds} seconds`);

  await new Promise((resolve) =>
  {
    setTimeout(() => resolve(), 1000 * seconds);
  });

  status = await connection.getQueryStatus(queryId);
}

console.log(`Query has finished executing, status is ${status}`);

-- Example 20325
ALTER SESSION SET multi_statement_count = <n>

-- Example 20326
var statement = connection.execute({
    sqlText: "ALTER SESSION SET multi_statement_count=0",
    complete: function (err, stmt, rows) {
      if (err) {
        console.error('1 Failed to execute statement due to the following error: ' + err.message);
      } else {
        testMulti();
      }
    }
  });
function testMulti() {
  console.log('select bind execute.');
  var selectStatement = connection.execute({
    sqlText: "create or replace table test(n int); insert into test values(1), (2); select * from test order by n",
    complete: function (err, stmt, rows) {
      if (err) {
        console.error('1 Failed to execute statement due to the following error: ' + err.message);
      }
      else {
        console.log('==== complete');
        console.log('==== sqlText=' + stmt.getSqlText());
        if(stmt.hasNext())
        {
          stmt.NextResult();
        }
        else {
          // do something else, e.g. close the connection
        }
      }
    }
  });
}

-- Example 20327
var selectStatement = connection.execute({
    sqlText: "CREATE OR REPLACE TABLE test(n int); INSERT INTO test values(1), (2); SELECT * FROM test ORDER BY n",
    parameters: { MULTI_STATEMENT_COUNT: 3 },
    complete: function (err, stmt, rows) {
      if (err) {
        console.error('1 Failed to execute statement due to the following error: ' + err.message);
      }
      else {
        console.log('==== complete');
        console.log('==== sqlText=' + stmt.getSqlText());
        if(stmt.hasNext())
        {
          stmt.NextResult();
        }
        else {
          // do something else, e.g. close the connection
        }
      }
    }
  });

-- Example 20328
connection.execute({
  sqlText: 'SELECT c1 FROM (SELECT 1 AS c1 UNION ALL SELECT 2 AS c1) WHERE c1 = 1;'
});

-- Example 20329
connection.execute({
  sqlText: 'SELECT c1 FROM (SELECT :1 AS c1 UNION ALL SELECT :2 AS c1) WHERE c1 = :1;',
  binds: [1, 2]
});

-- Example 20330
connection.execute({
p
  sqlText: 'SELECT c1 FROM (SELECT ? AS c1 UNION ALL SELECT ? AS c1) WHERE c1 = ?;',
  binds: [1, 2, 1]
});

-- Example 20331
connection.execute({
  sqlText: 'INSERT INTO t(c1, c2, c3) values(?, ?, ?)',
  binds: [[1, 'string1', 2.0], [2, 'string2', 4.0], [3, 'string3', 6.0]]
});

-- Example 20332
create or replace table test(id int, foo variant);

-- Example 20333
// standard stuff like defining connection, etc
var statement = connection.execute({
    // table columns are id: int, foo: variant
    sqlText: 'insert into test_db.public.test select value:id, value:foo from table(flatten(parse_json(?)))',
    binds: [JSON.stringify([
    {id: 1, foo: [{a: '1', b: '2'}]},
    {id: 2, foo: [{c: '3', d: '4'}]}
    ])],
    complete: function(err, stmt, rows) {
        if (err) {
            console.error('Failed to execute statement due to the following error: ' + err.message);
        } else {
            console.log('[queryID ' + statement.getStatementId() + ', requestId ' + statement.getRequestId() + '] Number of rows produced: ' + rows.length);
            // rest of the code
          }
    }
});

-- Example 20334
statement.cancel(function(err, stmt) {
  if (err) {
    console.error('Unable to abort statement due to the following error: ' + err.message);
  } else {
    console.log('Successfully aborted statement');
  }
});

-- Example 20335
var requestId;
connection.execute({
  sqlText: 'INSERT INTO testTable VALUES (1);',
    complete: function (err, stmt, rows)
    {
      var stream = stmt.streamRows();
      requestId = stmt.getRequestId();   // Retrieves the request ID
      stream.on('data', function (row)
      {
        console.log(row);
      });
      stream.on('end', function (row)
      {
        console.log('done');
      });
    }
});

-- Example 20336
connection.execute({
  sqlText: 'INSERT INTO testTable VALUES (1);',  // optional
    requestId: requestId,  // Uses the request ID from before
    complete: function (err, stmt, rows)
    {
      var stream = stmt.streamRows();
      stream.on('data', function (row)
      {
        console.log(row);
      });
      stream.on('end', function (row)
      {
        console.log('done');
      });
  }
});

-- Example 20337
// Sending a batch of SQL statements to be executed
rc = SQLExecDirect(hstmt,
      (SQLCHAR *) "select c1 from t1; select c2 from t2; select c3 from t3",
      SQL_NTS);

-- Example 20338
// Specify that you want to execute a batch of 3 SQL statements
rc = SQLSetStmtAttr(hstmt, SQL_SF_STMT_ATTR_MULTI_STATEMENT_COUNT, (SQLPOINTER)3, 0);

-- Example 20339
alter session set MULTI_STATEMENT_COUNT = 0;

-- Example 20340
alter account set MULTI_STATEMENT_COUNT = 0;

-- Example 20341
alter user set MULTI_STATEMENT_COUNT = 0;

-- Example 20342
SQLCHAR * Statement = "INSERT INTO t (c1, c2) VALUES (?, ?)";

SQLSetStmtAttr(hstmt, SQL_ATTR_PARAM_BIND_TYPE, SQL_PARAM_BIND_BY_COLUMN, 0);
SQLSetStmtAttr(hstmt, SQL_ATTR_PARAMSET_SIZE, ARRAY_SIZE, 0);
SQLSetStmtAttr(hstmt, SQL_ATTR_PARAM_STATUS_PTR, ParamStatusArray, 0);
SQLSetStmtAttr(hstmt, SQL_ATTR_PARAMS_PROCESSED_PTR, &ParamsProcessed, 0);
SQLBindParameter(hstmt, 1, SQL_PARAM_INPUT, SQL_C_ULONG, SQL_INTEGER, 5, 0,
                 IntValuesArray, 0, IntValuesIndArray);
SQLBindParameter(hstmt, 2, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, STR_VALUE_LEN - 1, 0,
                 StringValuesArray, STR_VALUE_LEN, StringValuesLenOrIndArray);
...
SQLExecDirect(hstmt, Statement, SQL_NTS);

-- Example 20343
CREATE TEMPORARY STAGE SYSTEM$BIND file_format=(type=csv field_optionally_enclosed_by='"')
Cannot perform CREATE STAGE. This session does not have a current schema. Call 'USE SCHEMA', or use a qualified name.

-- Example 20344
-- Set up.
push a;
push b;
...
-- Clean up in the reverse order that you set up.
pop b;
pop a;

-- Example 20345
CREATE PROCEDURE f() ...
    $$
    set x;
    set y;
    try  {
       set z;
       -- Do something interesting...
       ...
       unset z;
       }
    catch  {
       -- Give error message...
       ...
       unset z;
       }
    unset y;
    unset x;
    $$
    ;

