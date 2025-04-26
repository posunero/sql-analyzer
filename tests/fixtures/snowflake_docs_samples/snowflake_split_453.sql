-- Example 30323
...
PreparedStatement prepStatement = connection.prepareStatement("insert into testTable values (?)");
prepStatement.setInt(1, 33);
ResultSet rs = prepStatement.executeAsyncQuery();
...

-- Example 30324
// Retrieve the query ID from the PreparedStatement.
    String queryID;
    queryID = preparedStatement.unwrap(SnowflakePreparedStatement.class).getQueryID();

-- Example 30325
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
if (queryStatus == queryStatus.FAILED_WITH_ERROR) {
  // Print the error code to stdout
  System.out.format("Error code: %d%n", queryStatus.getErrorCode());
}

-- Example 30326
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
if (queryStatus == queryStatus.FAILED_WITH_ERROR) {
  // Print the error message to stdout
  System.out.format("Error message: %s%n", queryStatus.getErrorMessage());
}

-- Example 30327
String queryID2;
    queryID2 = resultSet.unwrap(SnowflakeResultSet.class).getQueryID();

-- Example 30328
QueryStatus queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();

-- Example 30329
SnowflakeTimestampWithTimezone(
    long seconds,
    int nanoseconds,
    TimeZone tz)

-- Example 30330
SnowflakeTimestampWithTimezone(
    Timestamp ts,
    TimeZone tz)

-- Example 30331
SnowflakeTimestampWithTimezone(
    Timestamp ts)

-- Example 30332
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

-- Example 30333
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

-- Example 30334
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

-- Example 30335
String queryID1;
    queryID1 = statement.unwrap(SnowflakeStatement.class).getQueryID();

-- Example 30336
Statement statement1;
...
// Tell Statement to expect to execute 2 statements:
statement1.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 2);

-- Example 30337
// Use columns and literals in expressions.
df.select(col("c") + lit(1))

// Call system-defined (built-in) functions.
// This example calls the function that corresponds to the ADD_MONTHS() SQL function.
df.select(add_months(col("d"), lit(3)))

// Call system-defined functions that have no corresponding function in the functions object.
// This example calls the RADIANS() SQL function, passing in values from the column "e".
df.select(callBuiltin("radians", col("e")))

// Call a user-defined function (UDF) by name.
df.select(callUDF("some_func", col("c")))

// Register and call an anonymous UDF.
val myudf = udf((x:Int) => x + x)
df.select(myudf(col("c")))

// Evaluate an SQL expression
df.select(sqlExpr("c + 1"))

-- Example 30338
String => String
Byte => TinyInt
Int => Int
Short => SmallInt
Long => BigInt
Float => Float
Double => Double
Decimal => Number
Boolean => Boolean
Array => Array
Timestamp => Timestamp
Date => Date

-- Example 30339
val repeat = functions.builtin("repeat")
df.select(repeat(col("col_1"), 3))

-- Example 30340
CONVERT_TIMEZONE( <source_tz> , <target_tz> , <source_timestamp_ntz> )

CONVERT_TIMEZONE( <target_tz> , <source_timestamp> )

-- Example 30341
ALTER SESSION UNSET TIMESTAMP_OUTPUT_FORMAT;

-- Example 30342
SELECT CONVERT_TIMEZONE(
  'America/Los_Angeles',
  'America/New_York',
  '2024-01-01 14:00:00'::TIMESTAMP_NTZ
) AS conv;

-- Example 30343
+-------------------------+
| CONV                    |
|-------------------------|
| 2024-01-01 17:00:00.000 |
+-------------------------+

-- Example 30344
SELECT CONVERT_TIMEZONE(
  'Europe/Warsaw',
  'UTC',
  '2024-01-01 00:00:00'::TIMESTAMP_NTZ
) AS conv;

-- Example 30345
+-------------------------+
| CONV                    |
|-------------------------|
| 2023-12-31 23:00:00.000 |
+-------------------------+

-- Example 30346
SELECT CONVERT_TIMEZONE(
  'America/Los_Angeles',
  '2024-04-05 12:00:00 +02:00'
) AS time_in_la;

-- Example 30347
+-------------------------------+
| TIME_IN_LA                    |
|-------------------------------|
| 2024-04-05 03:00:00.000 -0700 |
+-------------------------------+

-- Example 30348
SELECT
  CURRENT_TIMESTAMP() AS now_in_la,
  CONVERT_TIMEZONE('America/New_York', CURRENT_TIMESTAMP()) AS now_in_nyc,
  CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()) AS now_in_paris,
  CONVERT_TIMEZONE('Asia/Tokyo', CURRENT_TIMESTAMP()) AS now_in_tokyo;

-- Example 30349
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+
| NOW_IN_LA                     | NOW_IN_NYC                    | NOW_IN_PARIS                  | NOW_IN_TOKYO                  |
|-------------------------------+-------------------------------+-------------------------------+-------------------------------|
| 2024-06-12 08:52:53.114 -0700 | 2024-06-12 11:52:53.114 -0400 | 2024-06-12 17:52:53.114 +0200 | 2024-06-13 00:52:53.114 +0900 |
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+

-- Example 30350
<dependencies>
  ...
  <dependency>
    <groupId>com.snowflake</groupId>
    <artifactId>snowpark</artifactId>
    <version>1.15.0</version>
  </dependency>
  ...
</dependencies>

-- Example 30351
import com.snowflake.snowpark_java.*;
import java.util.HashMap;
import java.util.Map;

public class HelloSnowpark {
  public static void main(String[] args) {
    // Replace the <placeholders> below.
    Map<String, String> properties = new HashMap<>();
    properties.put("URL", "https://<account_identifier>.snowflakecomputing.com:443");
    properties.put("USER", "<user name>");
    properties.put("PASSWORD", "<password>");
    properties.put("ROLE", "<role name>");
    properties.put("WAREHOUSE", "<warehouse name>");
    properties.put("DB", "<database name>");
    properties.put("SCHEMA", "<schema name>");
    Session session = Session.builder().configs(properties).create();
    session.sql("show tables").show();
  }
}

-- Example 30352
public class DataFrame
extends com.snowflake.snowpark.internal.Logging
implements Cloneable

-- Example 30353
public StructType schema()

-- Example 30354
public HasCachedResult cacheResult()

-- Example 30355
public void explain()

-- Example 30356
public DataFrame toDF​(String... colNames)

-- Example 30357
public DataFrame withColumn​(String colName,
                            Column col)

-- Example 30358
public DataFrame withColumns​(String[] colNames,
                             Column[] values)

-- Example 30359
DataFrame dfWithAddedColumns = df.withColumns(
       new String[]{"mean_price", "avg_price"},
       new Column[]{Functions.mean(df.col("price")),
         Functions.avg(df.col("price"))}
     );

-- Example 30360
public DataFrame rename​(String newName,
                        Column col)

-- Example 30361
DataFrame df = session.sql("select 1 as A, 2 as B");
 DateFrame dfRenamed = df.rename("NEW_A", df.col("A"));

-- Example 30362
public DataFrame select​(Column... columns)

-- Example 30363
import com.snowflake.snowpark_java.Functions;

 DataFrame dfSelected =
   df.select(df.col("col1"), Functions.lit("abc"), df.col("col1").plus(df.col("col2")));

-- Example 30364
public DataFrame select​(String... columnNames)

-- Example 30365
public DataFrame drop​(Column... columns)

-- Example 30366
public DataFrame drop​(String... columnNames)

-- Example 30367
public DataFrame filter​(Column condition)

-- Example 30368
import com.snowflake.snowpark_java.Functions;

 DataFrame dfFiltered =
   df.filter(df.col("colA").gt(Functions.lit(1)));

-- Example 30369
public DataFrame where​(Column condition)

-- Example 30370
import com.snowflake.snowpark_java.Functions;

 DataFrame dfFiltered =
   df.where(df.col("colA").gt(Functions.lit(1)));

-- Example 30371
public DataFrame agg​(Column... exprs)

-- Example 30372
public DataFrame distinct()

-- Example 30373
public DataFrame dropDuplicates​(String... colNames)

-- Example 30374
public DataFrame union​(DataFrame other)

-- Example 30375
public DataFrame unionAll​(DataFrame other)

-- Example 30376
public DataFrame unionByName​(DataFrame other)

-- Example 30377
public DataFrame unionAllByName​(DataFrame other)

-- Example 30378
public DataFrame intersect​(DataFrame other)

-- Example 30379
public DataFrame except​(DataFrame other)

-- Example 30380
public DataFrame clone()

-- Example 30381
public DataFrame join​(DataFrame right)

-- Example 30382
public DataFrame join​(DataFrame right,
                      String usingColumn)

-- Example 30383
public DataFrame join​(DataFrame right,
                      String[] usingColumns)

-- Example 30384
public DataFrame join​(DataFrame right,
                      String[] usingColumns,
                      String joinType)

-- Example 30385
left.join(right, new String[]{"col"}, "left");
 left.join(right, new String[]{"col1", "col2}, "outer");

-- Example 30386
public DataFrame join​(DataFrame right,
                      Column joinExpr)

-- Example 30387
public DataFrame join​(DataFrame right,
                      Column joinExpr,
                      String joinType)

-- Example 30388
public DataFrame crossJoin​(DataFrame right)

-- Example 30389
public DataFrame naturalJoin​(DataFrame right)

