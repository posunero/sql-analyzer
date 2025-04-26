-- Example 27043
DataFrame dfTable = session.table("quoted");
dfTable.select("\"name_with_\"\"air\"\"_quotes\"");
dfTable.select("\"\"\"column_name_quoted\"\"\"");

-- Example 27044
// The following calls are NOT equivalent!
// The Snowpark library adds double quotes around the column name,
// which makes Snowflake treat the column name as case-sensitive.
df.select(Functions.col("id with space"));
df.select(Functions.col("ID WITH SPACE"));

-- Example 27045
// Show the first 10 rows in which category_id is greater than 5.
// Use `Functions.lit(5)` to create a Column object for the literal 5.
DataFrame df = session.table("sample_product_data");
df.filter(Functions.col("category_id").gt(Functions.lit(5))).show();

-- Example 27046
// Create a DataFrame that contains the value 0.05.
DataFrame df = session.sql("select 0.05 :: Numeric(5, 2) as a");

// Applying this filter results in no matching rows in the DataFrame.
df.filter(Functions.col("a").leq(Functions.lit(0.06).minus(Functions.lit(0.01)))).show();

-- Example 27047
import com.snowflake.snowpark_java.types.*;
...

df.filter(Functions.col("a").leq(Functions.lit(0.06).cast(DataTypes.createDecimalType(5, 2)).minus(Functions.lit(0.01).cast(DataTypes.createDecimalType(5, 2))))).show();

-- Example 27048
// Import for the DecimalType class..
import com.snowflake.snowpark_java.types.*;

Column decimalValue = Functions.lit(0.05).cast(DataTypes.createDecimalType(5,2));

-- Example 27049
DataFrame dfProductInfo = session.table("sample_product_data").filter(Functions.col("id").equal_to(Functions.lit(1))).select(Functions.col("name"), Functions.col("serial_number"));
dfProductInfo.show();

-- Example 27050
// This fails with the error "invalid identifier 'ID'."
DataFrame dfProductInfo = session.table("sample_product_data").select(Functions.col("name"), Functions.col("serial_number")).filter(Functions.col("id").equal_to(Functions.lit(1)));
dfProductInfo.show();

-- Example 27051
// This succeeds because the DataFrame returned by the table() method
// includes the "id" column.
DataFrame dfProductInfo = session.table("sample_product_data").filter(Functions.col("id").equal_to(Functions.lit(1))).select(Functions.col("name"), Functions.col("serial_number"));
dfProductInfo.show();

-- Example 27052
DataFrame df = session.table("sample_product_data");

// Limit the number of rows to 5, sorted by parent_id.
DataFrame dfSubset = df.sort(Functions.col("parent_id")).limit(5);

// Return the first 5 rows, sorted by parent_id.
Row[] arrayOfRows = df.sort(Functions.col("parent_id")).first(5);

// Print the first 5 rows, sorted by parent_id.
df.sort(Functions.col("parent_id")).show(5);

-- Example 27053
import com.snowflake.snowpark_java.types.*;
...

// Get the StructType object that describes the columns in the
// underlying rowset.
StructType tableSchema = session.table("sample_product_data").schema();
System.out.println("Schema for sample_product_data: " + tableSchema);

-- Example 27054
import java.util.Arrays;
...

// Create a DataFrame containing the "id" and "3rd" columns.
DataFrame dfSelectedColumns = session.table("sample_product_data").select(Functions.col("id"), Functions.col("3rd"));
// Print out the names of the columns in the schema.
System.out.println(Arrays.toString(dfSelectedColumns.schema().names()));

-- Example 27055
CREATE OR REPLACE TABLE sample_a (
  id_a INTEGER,
  name_a VARCHAR,
  value INTEGER
);
INSERT INTO sample_a (id_a, name_a, value) VALUES
  (10, 'A1', 5),
  (40, 'A2', 10),
  (80, 'A3', 15),
  (90, 'A4', 20)
;
CREATE OR REPLACE TABLE sample_b (
  id_b INTEGER,
  name_b VARCHAR,
  id_a INTEGER,
  value INTEGER
);
INSERT INTO sample_b (id_b, name_b, id_a, value) VALUES
  (4000, 'B1', 40, 10),
  (4001, 'B2', 10, 5),
  (9000, 'B3', 80, 15),
  (9099, 'B4', NULL, 200)
;
CREATE OR REPLACE TABLE sample_c (
  id_c INTEGER,
  name_c VARCHAR,
  id_a INTEGER,
  id_b INTEGER
);
INSERT INTO sample_c (id_c, name_c, id_a, id_b) VALUES
  (1012, 'C1', 10, NULL),
  (1040, 'C2', 40, 4000),
  (1041, 'C3', 40, 4001)
;

-- Example 27056
// Create a DataFrame that joins the DataFrames for the tables
// "sample_a" and "sample_b" on the column named "id_a".
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));
dfJoined.show();

-- Example 27057
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |
|40      |A2        |10       |4000    |B1        |40      |10       |
|80      |A3        |15       |9000    |B3        |80      |15       |
----------------------------------------------------------------------

-- Example 27058
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));
DataFrame dfSelected = dfJoined.select(dfLhs.col("value").as("LeftValue"), dfRhs.col("value").as("RightValue"));
dfSelected.show();

-- Example 27059
------------------------------
|"LEFTVALUE"  |"RIGHTVALUE"  |
------------------------------
|5            |5             |
|10           |10            |
|15           |15            |
------------------------------

-- Example 27060
--------------------------------------------------------------------------------------------------
|"l_ZSz7_ID_A"  |"NAME_A"  |"l_ZSz7_VALUE"  |"ID_B"  |"NAME_B"  |"r_heec_ID_A"  |"r_heec_VALUE"  |
--------------------------------------------------------------------------------------------------
|10             |A1        |5               |4001    |B2        |10             |5               |
|40             |A2        |10              |4000    |B1        |40             |10              |
|80             |A3        |15              |9000    |B3        |80             |15              |
--------------------------------------------------------------------------------------------------

-- Example 27061
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.naturalJoin(dfRhs);
dfJoined.show();

-- Example 27062
---------------------------------------------------
|"ID_A"  |"VALUE"  |"NAME_A"  |"ID_B"  |"NAME_B"  |
---------------------------------------------------
|10      |5        |A1        |4001    |B2        |
|40      |10       |A2        |4000    |B1        |
|80      |15       |A3        |9000    |B3        |
---------------------------------------------------

-- Example 27063
// Create a DataFrame that performs a left outer join on
// "sample_a" and "sample_b" on the column named "id_a".
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfLeftOuterJoin = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")), "left");
dfLeftOuterJoin.show();

-- Example 27064
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|40      |A2        |10       |4000    |B1        |40      |10       |
|10      |A1        |5        |4001    |B2        |10      |5        |
|80      |A3        |15       |9000    |B3        |80      |15       |
|90      |A4        |20       |NULL    |NULL      |NULL    |NULL     |
----------------------------------------------------------------------

-- Example 27065
DataFrame dfFirst = session.table("sample_a");
DataFrame dfSecond  = session.table("sample_b");
DataFrame dfThird = session.table("sample_c");
DataFrame dfJoinThreeTables = dfFirst.join(dfSecond, dfFirst.col("id_a").equal_to(dfSecond.col("id_a"))).join(dfThird, dfFirst.col("id_a").equal_to(dfThird.col("id_a")));
dfJoinThreeTables.show();

-- Example 27066
------------------------------------------------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |"ID_C"  |"NAME_C"  |"ID_A"  |"ID_B"  |
------------------------------------------------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |1012    |C1        |10      |NULL    |
|40      |A2        |10       |4000    |B1        |40      |10       |1040    |C2        |40      |4000    |
|40      |A2        |10       |4000    |B1        |40      |10       |1041    |C3        |40      |4001    |
------------------------------------------------------------------------------------------------------------

-- Example 27067
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
DataFrame df = session.table("sample_product_data");
DataFrame dfJoined = df.join(df, Functions.col("id").equal_to(Functions.col("parent_id")));

-- Example 27068
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
DataFrame df = session.table("sample_product_data");
DataFrame dfJoined = df.join(df, df.col("id").equal_to(df.col("parent_id")));

-- Example 27069
Exception in thread "main" com.snowflake.snowpark_java.SnowparkClientException:
  Joining a DataFrame to itself can lead to incorrect results due to ambiguity of column references.
  Instead, join this DataFrame to a clone() of itself.

-- Example 27070
// Create a DataFrame object for the "sample_product_data" table for the left-hand side of the join.
DataFrame dfLhs = session.table("sample_product_data");
// Clone the DataFrame object to use as the right-hand side of the join.
DataFrame dfRhs = dfLhs.clone();

// Create a DataFrame that joins the two DataFrames
// for the "sample_product_data" table on the
// "id" and "parent_id" columns.
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id").equal_to(dfRhs.col("parent_id")));
dfJoined.show();

-- Example 27071
// Create a DataFrame that performs a self-join on a DataFrame
// using the column named "key".
DataFrame df = session.table("sample_product_data");
DataFrame dfJoined = df.join(df, "key");

-- Example 27072
// Create a DataFrame for the "sample_product_data" table.
DataFrame dfProducts = session.table("sample_product_data");

// Send the query to the server for execution and
// print the count of rows in the table.
System.out.println("Rows returned: " + dfProducts.count());

-- Example 27073
import java.util.Arrays;

// Create a DataFrame with the "id" and "name" columns from the "sample_product_data" table.
// This does not execute the query.
DataFrame df = session.table("sample_product_data").select(Functions.col("id"), Functions.col("name"));

// Execute the query asynchronously.
// This call does not block.
TypedAsyncJob<Row[]> asyncJob = df.async().collect();
// Check if the query has completed execution.
System.out.println("Is query " + asyncJob.getQueryId() + " done? " + asyncJob.isDone());
// Get an Array of Rows containing the results, and print the results.
// Note that getResult is a blocking call.
Row[] results = asyncJob.getResult();
System.out.println(Arrays.toString(results));

-- Example 27074
// Create a DataFrame for the "sample_product_data" table.
DataFrame dfProducts = session.table("sample_product_data");

// Execute the query asynchronously.
// This call does not block.
TypedAsyncJob<Long> asyncJob = dfProducts.async().count();
// Check if the query has completed execution.
System.out.println("Is query " + asyncJob.getQueryId() + " done? " + asyncJob.isDone());
// Print the count of rows in the table.
// Note that getResult is a blocking call.
System.out.println("Rows returned: " + asyncJob.getResult());

-- Example 27075
// Wait a maximum of 10 seconds for the query to complete before retrieving the results.
Row[] results = asyncJob.getResult(10);

-- Example 27076
import java.util.Arrays;
...

AsyncJob asyncJob = session.createAsyncJob(myQueryId);
// Check if the query has completed execution.
System.out.println("Is query " + asyncJob.getQueryId() + " done? " + asyncJob.isDone());
// If you need to retrieve the results, call getRows to return an Array of Rows containing the results.
// Note that getRows is a blocking call.
Row[] rows = asyncJob.getRows();
System.out.println(Arrays.toString(rows));

-- Example 27077
Row[] rows = session.table("sample_product_data").select(Functions.col("name"), Functions.col("category_id")).sort(Functions.col("name")).collect();
for (Row row : rows) {
  System.out.println("Name: " + row.getString(0) + "; Category ID: " + row.getInt(1));
}

-- Example 27078
import java.util.Iterator;

Iterator<Row> rowIterator = session.table("sample_product_data").select(Functions.col("name"), Functions.col("category_id")).sort(Functions.col("name")).toLocalIterator();
while (rowIterator.hasNext()) {
  Row row = rowIterator.next();
  System.out.println("Name: " + row.getString(0) + "; Category ID: " + row.getInt(1));
}

-- Example 27079
import java.util.Arrays;
...

DataFrame df = session.table("sample_product_data");
Row[] rows = df.sort(Functions.col("name")).first(5);
System.out.println(Arrays.toString(rows));

-- Example 27080
DataFrame df = session.table("sample_product_data");
df.sort(Functions.col("name")).show();

-- Example 27081
import java.util.HashMap;
import java.util.Map;
...

Map<String, Column> assignments = new HashMap<>();
assignments.put("3rd", Functions.lit(1));
Updatable updatableDf = session.table("sample_product_data");
UpdateResult updateResult = updatableDf.updateColumn(assignments);
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 27082
import java.util.HashMap;
import java.util.Map;
...

Map<Column, Column> assignments = new HashMap<>();
assignments.put(Functions.col("3rd"), Functions.lit(1));
Updatable updatableDf = session.table("sample_product_data");
UpdateResult updateResult = updatableDf.update(assignments);
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 27083
import java.util.HashMap;
import java.util.Map;
...
Map<Column, Column> assignments = new HashMap<>();
assignments.put(Functions.col("3rd"), Functions.lit(2));
Updatable updatableDf = session.table("sample_product_data");
UpdateResult updateResult = updatableDf.update(assignments, Functions.col("category_id").equal_to(Functions.lit(20)));
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 27084
import java.util.HashMap;
import java.util.Map;
...
Map<Column, Column> assignments = new HashMap<>();
assignments.put(Functions.col("3rd"), Functions.lit(3));
Updatable updatableDf = session.table("sample_product_data");
DataFrame dfParts = session.table("parts");
UpdateResult updateResult = updatableDf.update(assignments, updatableDf.col("category_id").equal_to(dfParts.col("category_id")), dfParts);
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 27085
Updatable updatableDf = session.table("sample_product_data");
DeleteResult deleteResult = updatableDf.delete(updatableDf.col("category_id").equal_to(Functions.lit(1)));
System.out.println("Number of rows deleted: " + deleteResult.getRowsDeleted());

-- Example 27086
Updatable updatableDf = session.table("sample_product_data");
DeleteResult deleteResult = updatableDf.delete(updatableDf.col("category_id").equal_to(dfParts.col("category_id")), dfParts);
System.out.println("Number of rows deleted: " + deleteResult.getRowsDeleted());

-- Example 27087
MergeResult mergeResult = target.merge(source, target.col("id").equal_to(source.col("id")))
                    .whenNotMatched().insert([source.col("id"), source.col("value")])
                    .collect();

-- Example 27088
import java.util.HashMap;
import java.util.Map;
...
Map<String, Column> assignments = new HashMap<>();
assignments.put("value", source.col("value"));
MergeResult mergeResult = target.merge(source, target.col("id").equal_to(source.col("id")))
                    .whenMatched().update(assignments)
                    .collect();

-- Example 27089
df.write().mode(SaveMode.Overwrite).saveAsTable(tableName);

-- Example 27090
DataFrame df = session.sql("SELECT 1 AS c2, 2 as c1");
// With the columnOrder option set to "name", the DataFrameWriter uses the column names
// and inserts a row with the values (2, 1).
df.write().mode(SaveMode.Append).option("columnOrder", "name").saveAsTable(tableName);
// With the default value of the columnOrder option ("index"), the DataFrameWriter uses the column positions
// and inserts a row with the values (1, 2).
df.write().mode(SaveMode.Append).saveAsTable(tableName);

-- Example 27091
df.createOrReplaceView("db.schema.viewName");

-- Example 27092
df.createOrReplaceTempView("db.schema.viewName");

-- Example 27093
// Set up a DataFrame to query a table.
DataFrame df = session.table("sample_product_data").filter(Functions.col("category_id").gt(Functions.lit(10)));
// Retrieve the results and cache the data.
HasCachedResult cachedDf = df.cacheResult();
// Create a DataFrame containing a subset of the cached data.
DataFrame dfSubset = cachedDf.filter(Functions.col("category_id").equal_to(Functions.lit(20))).select(Functions.col("name"), Functions.col("category_id"));
dfSubset.show();

-- Example 27094
HasCachedResult dfTempTable = dfTable.cacheResult();

-- Example 27095
import java.util.HashMap;
import java.util.Map;
...
// Upload a file to a stage without compressing the file.
Map<String, String> putOptions = new HashMap<>();
putOptions.put("AUTO_COMPRESS", "FALSE");
PutResult[] putResults = session.file().put("file:///tmp/myfile.csv", "@myStage", putOptions);

-- Example 27096
// Upload the CSV files in /tmp with names that start with "file".
// You can use the wildcard characters "*" and "?" to match multiple files.
PutResult[] putResults = session.file().put("file:///tmp/file*.csv", "@myStage/prefix2")

-- Example 27097
// Print the filename and the status of the PUT operation.
for (PutResult result : putResults) {
  System.out.println(result.getSourceFileName() + ": " + result.getStatus());
}

-- Example 27098
import java.util.HashMap;
import java.util.Map;
...
// Upload a file to a stage without compressing the file.
// Download files with names that match a regular expression pattern.
Map<String, String> getOptions = new HashMap<>();
getOptions.put("PATTERN", "'.*file_.*.csv.gz'");
GetResult[] getResults = session.file().get("@myStage", "file:///tmp", getOptions);

-- Example 27099
// Print the filename and the status of the GET operation.
for (GetResult result : getResults) {
  System.out.println(result.getFileName() + ": " + result.getStatus());
}

-- Example 27100
import java.io.InputStream;
...
boolean compressData = true;
String pathToFileOnStage = "@myStage/path/file";
session.file().uploadStream(pathToFileOnStage, new ByteArrayInputStream(fileContent.getBytes()), compressData);

-- Example 27101
import java.io.InputStream;
...
boolean isDataCompressed = true;
String pathToFileOnStage = "@myStage/path/file";
InputStream is = session.file().downloadStream(pathToFileOnStage, isDataCompressed);

-- Example 27102
import com.snowflake.snowpark_java.types.*;
...

StructType schemaForDataFile = StructType.create(
  new StructField("id", DataTypes.StringType, true),
  new StructField("name", DataTypes.StringType, true));

-- Example 27103
DataFrameReader dfReader = session.read().schema(schemaForDataFile);

-- Example 27104
dfReader = dfReader.option("field_delimiter", ";").option("COMPRESSION", "NONE");

-- Example 27105
DataFrame df = dfReader.csv("@mystage/myfile.csv");

-- Example 27106
DataFrame df = dfReader.csv("@mystage/csv_");

-- Example 27107
DataFrame df = session.read().json("@mystage/data.json").select(Functions.col("$1").subField("color"));

-- Example 27108
Row[] results = df.collect();

-- Example 27109
CopyableDataFrame copyableDf = session.read().schema(schemaForDataFile).csv("@mystage/myfile.csv");
copyableDf.copyInto("mytable");

