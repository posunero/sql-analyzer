-- Example 11638
SELECT DATEDIFF(year, CURRENT_DATE(),
       DATEADD(year, 3, CURRENT_DATE()));

-- Example 11639
SELECT DATEDIFF(month, CURRENT_DATE(),
       DATEADD(month, 3, CURRENT_DATE()));

-- Example 11640
SELECT DATEDIFF(day, CURRENT_DATE(),
       DATEADD(day, 3, CURRENT_DATE()));

-- Example 11641
SELECT DATEDIFF(hour, CURRENT_TIMESTAMP(),
       DATEADD(hour, 3, CURRENT_TIMESTAMP()));

-- Example 11642
SELECT DATEDIFF(minute, CURRENT_TIMESTAMP(),
       DATEADD(minute, 3, CURRENT_TIMESTAMP()));

-- Example 11643
SELECT DATEDIFF(second, CURRENT_TIMESTAMP(),
       DATEADD(second, 3, CURRENT_TIMESTAMP()));

-- Example 11644
CREATE OR REPLACE VIEW calendar_2016 AS
  SELECT n,
         theDate,
         DECODE (EXTRACT('dayofweek',theDate),
           1 , 'Monday',
           2 , 'Tuesday',
           3 , 'Wednesday',
           4 , 'Thursday',
           5 , 'Friday',
           6 , 'Saturday',
           0 , 'Sunday') theDayOfTheWeek,
         DECODE (EXTRACT(month FROM theDate),
           1 , 'January',
           2 , 'February',
           3 , 'March',
           4 , 'April',
           5 , 'May',
           6 , 'June',
           7 , 'July',
           8 , 'August',
           9 , 'september',
           10, 'October',
           11, 'November',
           12, 'December') theMonth,
         EXTRACT(year FROM theDate) theYear
  FROM
    (SELECT ROW_NUMBER() OVER (ORDER BY seq4()) AS n,
            DATEADD(day, ROW_NUMBER() OVER (ORDER BY seq4())-1, TO_DATE('2016-01-01')) AS theDate
      FROM table(generator(rowCount => 365)))
  ORDER BY n ASC;

SELECT * from CALENDAR_2016;

-- Example 11645
+-----+------------+-----------------+-----------+---------+
|   N | THEDATE    | THEDAYOFTHEWEEK | THEMONTH  | THEYEAR |
|-----+------------+-----------------+-----------+---------|
|   1 | 2016-01-01 | Friday          | January   |    2016 |
|   2 | 2016-01-02 | Saturday        | January   |    2016 |
  ...
| 364 | 2016-12-29 | Thursday        | December  |    2016 |
| 365 | 2016-12-30 | Friday          | December  |    2016 |
+-----+------------+-----------------+-----------+---------+

-- Example 11646
CallableStatement stmt = testConnection.prepareCall("call read_result_set(?,?) ");

-- Example 11647
CallableStatement stmt = testConnection.prepareCall("? = call read_result_set() ");  -- INVALID

-- Example 11648
ResultSet resultSet;
resultSet = connection.unwrap(SnowflakeConnection.class).createResultSet(queryID);

-- Example 11649
getColumns( connection,
    "TEMPORARYDB1",      // Database name.
    "TEMPORARYSCHEMA1",  // Schema name.
    "%",                 // All table names.
    "%"                  // All column names.
    );

-- Example 11650
getColumns(
    connection, "TEMPORARYDB1", "TEMPORARYSCHEMA1", "T\\_\\\\", "%" // All column names.
    );

-- Example 11651
Java sees...............: T\\_\\%\\\\
SQL sees................: T\_\%\\
The actual table name is: T_%\

-- Example 11652
// Demonstrate the Driver.getPropertyInfo() method.
  public static void do_the_real_work(String connectionString) throws Exception {
    Properties properties = new Properties();
    Driver driver = DriverManager.getDriver(connectionString);
    DriverPropertyInfo[] dpinfo = driver.getPropertyInfo("", properties);
    System.out.println(dpinfo[0].description);
  }

-- Example 11653
INSERT INTO t1 (c1, c2) VALUES (1, 'One');   -- single row inserted.

INSERT INTO t1 (c1, c2) VALUES (1, 'One'),   -- multiple rows inserted.
                               (2, 'Two'),
                               (3, 'Three');

-- Example 11654
...
PreparedStatement prepStatement = connection.prepareStatement("insert into testTable values (?)");
prepStatement.setInt(1, 33);
ResultSet rs = prepStatement.executeAsyncQuery();
...

-- Example 11655
// Retrieve the query ID from the PreparedStatement.
    String queryID;
    queryID = preparedStatement.unwrap(SnowflakePreparedStatement.class).getQueryID();

-- Example 11656
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
if (queryStatus == queryStatus.FAILED_WITH_ERROR) {
  // Print the error code to stdout
  System.out.format("Error code: %d%n", queryStatus.getErrorCode());
}

-- Example 11657
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
if (queryStatus == queryStatus.FAILED_WITH_ERROR) {
  // Print the error message to stdout
  System.out.format("Error message: %s%n", queryStatus.getErrorMessage());
}

-- Example 11658
String queryID2;
    queryID2 = resultSet.unwrap(SnowflakeResultSet.class).getQueryID();

-- Example 11659
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();

-- Example 11660
SnowflakeTimestampWithTimezone(
    long seconds,
    int nanoseconds,
    TimeZone tz)

-- Example 11661
SnowflakeTimestampWithTimezone(
    Timestamp ts,
    TimeZone tz)

-- Example 11662
SnowflakeTimestampWithTimezone(
    Timestamp ts)

-- Example 11663
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

-- Example 11664
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

-- Example 11665
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

-- Example 11666
String queryID1;
    queryID1 = statement.unwrap(SnowflakeStatement.class).getQueryID();

-- Example 11667
Statement statement1;
...
// Tell Statement to expect to execute 2 statements:
statement1.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 2);

-- Example 11668
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

-- Example 11669
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

-- Example 11670
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

-- Example 11671
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

-- Example 11672
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

-- Example 11673
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

-- Example 11674
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

-- Example 11675
SELECT echo_varchar('Hello');
+-----------------------+
| ECHO_VARCHAR('HELLO') |
|-----------------------|
| Hello                 |
+-----------------------+

-- Example 11676
SELECT echo_varchar(NULL);
+--------------------+
| ECHO_VARCHAR(NULL) |
|--------------------|
| NULL               |
+--------------------+

-- Example 11677
static int myMethod(int fixedArgument1, int fixedArgument2, String[] stringArray)

-- Example 11678
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 11679
CREATE OR REPLACE FUNCTION concat_varchar_2(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc_2.concatVarchar2'
  TARGET_PATH = '@~/TestFunc_2.jar'
  AS
  $$
  class TestFunc_2 {
      public static String concatVarchar2(String[] strings) {
          return String.join(" ", strings);
      }
  }
  $$;

-- Example 11680
SELECT concat_varchar_2(a)
  FROM string_array_table
  ORDER BY id;
+---------------------+
| CONCAT_VARCHAR_2(A) |
|---------------------|
| Hello               |
| Hello Jay           |
| Hello Jay Smith     |
+---------------------+

-- Example 11681
static int myMethod(int fixedArgument1, int fixedArgument2, String ... stringArray)

-- Example 11682
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 11683
CREATE OR REPLACE FUNCTION concat_varchar(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc.concatVarchar'
  TARGET_PATH = '@~/TestFunc.jar'
  AS
  $$
  class TestFunc {
      public static String concatVarchar(String ... stringArray) {
          return String.join(" ", stringArray);
      }
  }
  $$;

-- Example 11684
SELECT concat_varchar(a)
    FROM string_array_table
    ORDER BY id;
+-------------------+
| CONCAT_VARCHAR(A) |
|-------------------|
| Hello             |
| Hello Jay         |
| Hello Jay Smith   |
+-------------------+

-- Example 11685
CREATE OR REPLACE FUNCTION return_a_null()
  RETURNS VARCHAR
  NULL
  LANGUAGE JAVA
  HANDLER = 'TemporaryTestLibrary.returnNull'
  TARGET_PATH = '@~/TemporaryTestLibrary.jar'
  AS
  $$
  class TemporaryTestLibrary {
    public static String returnNull() {
      return null;
    }
  }
  $$;

-- Example 11686
SELECT return_a_null();
+-----------------+
| RETURN_A_NULL() |
|-----------------|
| NULL            |
+-----------------+

-- Example 11687
CREATE TABLE objectives (o OBJECT);
INSERT INTO objectives SELECT PARSE_JSON('{"outer_key" : {"inner_key" : "inner_value"} }');

-- Example 11688
CREATE OR REPLACE FUNCTION extract_from_object(x OBJECT, key VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVA
  HANDLER = 'VariantLibrary.extract'
  TARGET_PATH = '@~/VariantLibrary.jar'
  AS
  $$
  import java.util.Map;
  class VariantLibrary {
    public static String extract(Map<String, String> m, String key) {
      return m.get(key);
    }
  }
  $$;

-- Example 11689
SELECT extract_from_object(o, 'outer_key'), 
       extract_from_object(o, 'outer_key')['inner_key'] FROM objectives;
+-------------------------------------+--------------------------------------------------+
| EXTRACT_FROM_OBJECT(O, 'OUTER_KEY') | EXTRACT_FROM_OBJECT(O, 'OUTER_KEY')['INNER_KEY'] |
|-------------------------------------+--------------------------------------------------|
| {                                   | "inner_value"                                    |
|   "inner_key": "inner_value"        |                                                  |
| }                                   |                                                  |
+-------------------------------------+--------------------------------------------------+

-- Example 11690
CREATE OR REPLACE FUNCTION geography_equals(x GEOGRAPHY, y GEOGRAPHY)
  RETURNS BOOLEAN
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:1.2.0')
  HANDLER = 'TestGeography.compute'
  AS
  $$
  import com.snowflake.snowpark_java.types.Geography;

  class TestGeography {
    public static boolean compute(Geography geo1, Geography geo2) {
      return geo1.equals(geo2);
    }
  }
  $$;

-- Example 11691
CREATE TABLE geocache_table (id INTEGER, g1 GEOGRAPHY, g2 GEOGRAPHY);

INSERT INTO geocache_table (id, g1, g2)
  SELECT 1, TO_GEOGRAPHY('POINT(-122.35 37.55)'), TO_GEOGRAPHY('POINT(-122.35 37.55)');
INSERT INTO geocache_table (id, g1, g2)
  SELECT 2, TO_GEOGRAPHY('POINT(-122.35 37.55)'), TO_GEOGRAPHY('POINT(90.0 45.0)');

SELECT id, g1, g2, geography_equals(g1, g2) AS "EQUAL?"
  FROM geocache_table
  ORDER BY id;

-- Example 11692
+----+--------------------------------------------------------+---------------------------------------------------------+--------+
| ID | G1                                                     | G2                                                      | EQUAL? |
+----+--------------------------------------------------------|---------------------------------------------------------+--------+
| 1  | { "coordinates": [ -122.35, 37.55 ], "type": "Point" } | { "coordinates": [ -122.35,  37.55 ], "type": "Point" } | TRUE   |
| 2  | { "coordinates": [ -122.35, 37.55 ], "type": "Point" } | { "coordinates": [   90.0,   45.0  ], "type": "Point" } | FALSE  |
+----+--------------------------------------------------------+---------------------------------------------------------+--------+

-- Example 11693
CREATE OR REPLACE FUNCTION retrieve_price(v VARIANT)
  RETURNS INTEGER
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:1.4.0')
  HANDLER = 'VariantTest.retrievePrice'
  AS
  $$
  import java.util.Map;
  import com.snowflake.snowpark_java.types.Variant;

  public class VariantTest {
    public static Integer retrievePrice(Variant v) throws Exception {
      Map<String, Variant> saleMap = v.asMap();
      int price = saleMap.get("vehicle").asMap().get("price").asInt();
      return price;
    }
  }
  $$;

-- Example 11694
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

class TestReadRelativeFile {
  public static String readFile(String fileName) throws IOException {
    StringBuilder contentBuilder = new StringBuilder();
    String importDirectory = System.getProperty("com.snowflake.import_directory");
    String fPath = importDirectory + fileName;
    Stream<String> stream = Files.lines(Paths.get(fPath), StandardCharsets.UTF_8);
    stream.forEach(s -> contentBuilder.append(s).append("\n"));
    return contentBuilder.toString();
  }
}

-- Example 11695
CREATE FUNCTION file_reader(file_name VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVA
  IMPORTS = ('@my_stage/my_package/TestReadRelativeFile.jar',
             '@my_stage/my_path/my_config_file_1.txt',
             '@my_stage/my_path/my_config_file_2.txt')
  HANDLER = 'my_package.TestReadRelativeFile.readFile';

-- Example 11696
SELECT file_reader('my_config_file_1.txt') ...;
...
SELECT file_reader('my_config_file_2.txt') ...;

-- Example 11697
... IMPORTS = ('@MyStage/MyData.txt.gz', ...)

-- Example 11698
CREATE OR REPLACE FUNCTION sum_total_sales(file STRING)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'SalesSum.sumTotalSales'
  TARGET_PATH = '@jar_stage/sales_functions2.jar'
  AS
  $$
  import java.io.InputStream;
  import java.io.IOException;
  import java.nio.charset.StandardCharsets;
  import com.snowflake.snowpark_java.types.SnowflakeFile;

  public class SalesSum {

    public static int sumTotalSales(String filePath) throws IOException {
      int total = -1;

      // Use a SnowflakeFile instance to read sales data from a stage.
      SnowflakeFile file = SnowflakeFile.newInstance(filePath);
      InputStream stream = file.getInputStream();
      String contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8);

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total;
    }
  }
  $$;

-- Example 11699
SELECT sum_total_sales(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 11700
String filename = "@my_stage/filename.txt";
String sfFile = SnowflakeFile.newInstance(filename, false);

-- Example 11701
CREATE OR REPLACE FUNCTION sum_total_sales(file STRING)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'SalesSum.sumTotalSales'
  TARGET_PATH = '@jar_stage/sales_functions2.jar'
  AS
  $$
  import java.io.InputStream;
  import java.io.IOException;
  import java.nio.charset.StandardCharsets;

  public class SalesSum {

    public static int sumTotalSales(InputStream stream) throws IOException {
      int total = -1;
      String contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8);

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total;
    }
  }
  $$;

-- Example 11702
SELECT sum_total_sales(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 11703
my_udf/
|-- classes/
|-- src/

-- Example 11704
package mypackage;

public class MyUDFHandler {

  public static int decrementValue(int i)
  {
    return i - 1;
  }

  public static void main(String[] argv)
  {
    System.out.println("This main() function won't be called.");
  }
}

