-- Example 21418
DataFrame df = session.table("sample_product_data");
df.sort(Functions.col("name")).show();

-- Example 21419
import java.util.HashMap;
import java.util.Map;
...

Map<String, Column> assignments = new HashMap<>();
assignments.put("3rd", Functions.lit(1));
Updatable updatableDf = session.table("sample_product_data");
UpdateResult updateResult = updatableDf.updateColumn(assignments);
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 21420
import java.util.HashMap;
import java.util.Map;
...

Map<Column, Column> assignments = new HashMap<>();
assignments.put(Functions.col("3rd"), Functions.lit(1));
Updatable updatableDf = session.table("sample_product_data");
UpdateResult updateResult = updatableDf.update(assignments);
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 21421
import java.util.HashMap;
import java.util.Map;
...
Map<Column, Column> assignments = new HashMap<>();
assignments.put(Functions.col("3rd"), Functions.lit(2));
Updatable updatableDf = session.table("sample_product_data");
UpdateResult updateResult = updatableDf.update(assignments, Functions.col("category_id").equal_to(Functions.lit(20)));
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 21422
import java.util.HashMap;
import java.util.Map;
...
Map<Column, Column> assignments = new HashMap<>();
assignments.put(Functions.col("3rd"), Functions.lit(3));
Updatable updatableDf = session.table("sample_product_data");
DataFrame dfParts = session.table("parts");
UpdateResult updateResult = updatableDf.update(assignments, updatableDf.col("category_id").equal_to(dfParts.col("category_id")), dfParts);
System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 21423
Updatable updatableDf = session.table("sample_product_data");
DeleteResult deleteResult = updatableDf.delete(updatableDf.col("category_id").equal_to(Functions.lit(1)));
System.out.println("Number of rows deleted: " + deleteResult.getRowsDeleted());

-- Example 21424
Updatable updatableDf = session.table("sample_product_data");
DeleteResult deleteResult = updatableDf.delete(updatableDf.col("category_id").equal_to(dfParts.col("category_id")), dfParts);
System.out.println("Number of rows deleted: " + deleteResult.getRowsDeleted());

-- Example 21425
MergeResult mergeResult = target.merge(source, target.col("id").equal_to(source.col("id")))
                    .whenNotMatched().insert([source.col("id"), source.col("value")])
                    .collect();

-- Example 21426
import java.util.HashMap;
import java.util.Map;
...
Map<String, Column> assignments = new HashMap<>();
assignments.put("value", source.col("value"));
MergeResult mergeResult = target.merge(source, target.col("id").equal_to(source.col("id")))
                    .whenMatched().update(assignments)
                    .collect();

-- Example 21427
df.write().mode(SaveMode.Overwrite).saveAsTable(tableName);

-- Example 21428
DataFrame df = session.sql("SELECT 1 AS c2, 2 as c1");
// With the columnOrder option set to "name", the DataFrameWriter uses the column names
// and inserts a row with the values (2, 1).
df.write().mode(SaveMode.Append).option("columnOrder", "name").saveAsTable(tableName);
// With the default value of the columnOrder option ("index"), the DataFrameWriter uses the column positions
// and inserts a row with the values (1, 2).
df.write().mode(SaveMode.Append).saveAsTable(tableName);

-- Example 21429
df.createOrReplaceView("db.schema.viewName");

-- Example 21430
df.createOrReplaceTempView("db.schema.viewName");

-- Example 21431
// Set up a DataFrame to query a table.
DataFrame df = session.table("sample_product_data").filter(Functions.col("category_id").gt(Functions.lit(10)));
// Retrieve the results and cache the data.
HasCachedResult cachedDf = df.cacheResult();
// Create a DataFrame containing a subset of the cached data.
DataFrame dfSubset = cachedDf.filter(Functions.col("category_id").equal_to(Functions.lit(20))).select(Functions.col("name"), Functions.col("category_id"));
dfSubset.show();

-- Example 21432
HasCachedResult dfTempTable = dfTable.cacheResult();

-- Example 21433
import java.util.HashMap;
import java.util.Map;
...
// Upload a file to a stage without compressing the file.
Map<String, String> putOptions = new HashMap<>();
putOptions.put("AUTO_COMPRESS", "FALSE");
PutResult[] putResults = session.file().put("file:///tmp/myfile.csv", "@myStage", putOptions);

-- Example 21434
// Upload the CSV files in /tmp with names that start with "file".
// You can use the wildcard characters "*" and "?" to match multiple files.
PutResult[] putResults = session.file().put("file:///tmp/file*.csv", "@myStage/prefix2")

-- Example 21435
// Print the filename and the status of the PUT operation.
for (PutResult result : putResults) {
  System.out.println(result.getSourceFileName() + ": " + result.getStatus());
}

-- Example 21436
import java.util.HashMap;
import java.util.Map;
...
// Upload a file to a stage without compressing the file.
// Download files with names that match a regular expression pattern.
Map<String, String> getOptions = new HashMap<>();
getOptions.put("PATTERN", "'.*file_.*.csv.gz'");
GetResult[] getResults = session.file().get("@myStage", "file:///tmp", getOptions);

-- Example 21437
// Print the filename and the status of the GET operation.
for (GetResult result : getResults) {
  System.out.println(result.getFileName() + ": " + result.getStatus());
}

-- Example 21438
import java.io.InputStream;
...
boolean compressData = true;
String pathToFileOnStage = "@myStage/path/file";
session.file().uploadStream(pathToFileOnStage, new ByteArrayInputStream(fileContent.getBytes()), compressData);

-- Example 21439
import java.io.InputStream;
...
boolean isDataCompressed = true;
String pathToFileOnStage = "@myStage/path/file";
InputStream is = session.file().downloadStream(pathToFileOnStage, isDataCompressed);

-- Example 21440
import com.snowflake.snowpark_java.types.*;
...

StructType schemaForDataFile = StructType.create(
  new StructField("id", DataTypes.StringType, true),
  new StructField("name", DataTypes.StringType, true));

-- Example 21441
DataFrameReader dfReader = session.read().schema(schemaForDataFile);

-- Example 21442
dfReader = dfReader.option("field_delimiter", ";").option("COMPRESSION", "NONE");

-- Example 21443
DataFrame df = dfReader.csv("@mystage/myfile.csv");

-- Example 21444
DataFrame df = dfReader.csv("@mystage/csv_");

-- Example 21445
DataFrame df = session.read().json("@mystage/data.json").select(Functions.col("$1").subField("color"));

-- Example 21446
Row[] results = df.collect();

-- Example 21447
CopyableDataFrame copyableDf = session.read().schema(schemaForDataFile).csv("@mystage/myfile.csv");
copyableDf.copyInto("mytable");

-- Example 21448
DataFrameWriter dfWriter = session.table("sample_product_data").write();

-- Example 21449
dfWriter = dfWriter.mode(SaveMode.Overwrite);

-- Example 21450
dfWriter = dfWriter.option("field_delimiter", ";").option("COMPRESSION", "NONE");

-- Example 21451
WriteFileResult writeFileResult = dfWriter.csv("@mystage/saved_data");

-- Example 21452
WriteFileResult writeFileResult = dfWriter.csv("@mystage/saved_data");
Row[] rows = writeFileResult.getRows();
StructType schema = writeFileResult.getSchema();
for (int i = 0 ; i < rows.length ; i++) {
  System.out.println("Row:" + i);
  Row row = rows[i];
  for (int j = 0; j < schema.size(); j++) {
    System.out.println(schema.get(j).name() + ": " + row.get(j));
  }
}

-- Example 21453
DataFrame df = session.table("car_sales");
WriteFileResult writeFileResult = df.write().mode(SaveMode.Overwrite).option("DETAILED_OUTPUT", "TRUE").option("compression", "none").json("@mystage/saved_data");
Row[] rows = writeFileResult.getRows();
StructType schema = writeFileResult.getSchema();
for (int i = 0 ; i < rows.length ; i++) {
  System.out.println("Row:" + i);
  Row row = rows[i];
  for (int j = 0; j < schema.size(); j++) {
    System.out.println(schema.get(j).name() + ": " + row.get(j));
  }
}

-- Example 21454
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("dealership")).show();

-- Example 21455
----------------------------
|"""SRC""['DEALERSHIP']"   |
----------------------------
|"Valley View Auto Sales"  |
|"Tindel Toyota"           |
----------------------------

-- Example 21456
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("salesperson").subField("name")).show();

-- Example 21457
------------------------------------
|"""SRC""['SALESPERSON']['NAME']"  |
------------------------------------
|"Frank Beasley"                   |
|"Greg Northrup"                   |
------------------------------------

-- Example 21458
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("vehicle").subField(0)).show();
df.select(Functions.col("src").subField("vehicle").subField(0).subField("price")).show();

-- Example 21459
---------------------------
|"""SRC""['VEHICLE'][0]"  |
---------------------------
|{                        |
|  "extras": [            |
|    "ext warranty",      |
|    "paint protection"   |
|  ],                     |
|  "make": "Honda",       |
|  "model": "Civic",      |
|  "price": "20275",      |
|  "year": "2017"         |
|}                        |
|{                        |
|  "extras": [            |
|    "ext warranty",      |
|    "rust proofing",     |
|    "fabric protection"  |
|  ],                     |
|  "make": "Toyota",      |
|  "model": "Camry",      |
|  "price": "23500",      |
|  "year": "2017"         |
|}                        |
---------------------------

------------------------------------
|"""SRC""['VEHICLE'][0]['PRICE']"  |
------------------------------------
|"20275"                           |
|"23500"                           |
------------------------------------

-- Example 21460
df.select(Functions.get(Functions.col("src"), Functions.lit("dealership"))).show();
df.select(Functions.col("src").subField("dealership")).show();

-- Example 21461
df.select(Functions.get_path(Functions.col("src"), Functions.lit("vehicle[0].make"))).show();
df.select(Functions.col("src").subField("vehicle").subField(0).subField("make")).show();

-- Example 21462
// Import the objects for the data types, including StringType.
import com.snowflake.snowpark_java.types.*;
...
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("salesperson").subField("id")).show();
df.select(Functions.col("src").subField("salesperson").subField("id").cast(DataTypes.StringType)).show();

-- Example 21463
----------------------------------
|"""SRC""['SALESPERSON']['ID']"  |
----------------------------------
|"55"                            |
|"274"                           |
----------------------------------

---------------------------------------------------
|"CAST (""SRC""['SALESPERSON']['ID'] AS STRING)"  |
---------------------------------------------------
|55                                               |
|274                                              |
---------------------------------------------------

-- Example 21464
DataFrame df = session.table("car_sales");
df.flatten(Functions.col("src").subField("customer")).show();

-- Example 21465
----------------------------------------------------------------------------------------------------------------------------------------------------------
|"SRC"                                      |"SEQ"  |"KEY"  |"PATH"  |"INDEX"  |"VALUE"                            |"THIS"                               |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|{                                          |1      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "San Francisco, CA",  |  {                                  |
|    {                                      |       |       |        |         |  "name": "Joyce Ridgely",         |    "address": "San Francisco, CA",  |
|      "address": "San Francisco, CA",      |       |       |        |         |  "phone": "16504378889"           |    "name": "Joyce Ridgely",         |
|      "name": "Joyce Ridgely",             |       |       |        |         |}                                  |    "phone": "16504378889"           |
|      "phone": "16504378889"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Valley View Auto Sales",  |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "55",                            |       |       |        |         |                                   |                                     |
|    "name": "Frank Beasley"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "paint protection"                 |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Honda",                     |       |       |        |         |                                   |                                     |
|      "model": "Civic",                    |       |       |        |         |                                   |                                     |
|      "price": "20275",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
|{                                          |2      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "New York, NY",       |  {                                  |
|    {                                      |       |       |        |         |  "name": "Bradley Greenbloom",    |    "address": "New York, NY",       |
|      "address": "New York, NY",           |       |       |        |         |  "phone": "12127593751"           |    "name": "Bradley Greenbloom",    |
|      "name": "Bradley Greenbloom",        |       |       |        |         |}                                  |    "phone": "12127593751"           |
|      "phone": "12127593751"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Tindel Toyota",           |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "274",                           |       |       |        |         |                                   |                                     |
|    "name": "Greg Northrup"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "rust proofing",                   |       |       |        |         |                                   |                                     |
|        "fabric protection"                |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Toyota",                    |       |       |        |         |                                   |                                     |
|      "model": "Camry",                    |       |       |        |         |                                   |                                     |
|      "price": "23500",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 21466
df.flatten(Functions.col("src").subField("customer")).select(Functions.col("value").subField("name"), Functions.col("value").subField("address")).show();

-- Example 21467
-------------------------------------------------
|"""VALUE""['NAME']"   |"""VALUE""['ADDRESS']"  |
-------------------------------------------------
|"Joyce Ridgely"       |"San Francisco, CA"     |
|"Bradley Greenbloom"  |"New York, NY"          |
-------------------------------------------------

-- Example 21468
df.flatten(Functions.col("src").subField("customer")).select(Functions.col("value").subField("name").cast(DataTypes.StringType).as("Customer Name"), Functions.col("value").subField("address").cast(DataTypes.StringType).as("Customer Address")).show();

-- Example 21469
-------------------------------------------
|"Customer Name"     |"Customer Address"  |
-------------------------------------------
|Joyce Ridgely       |San Francisco, CA   |
|Bradley Greenbloom  |New York, NY        |
-------------------------------------------

-- Example 21470
import java.util.Arrays;

// Get the list of the files in a stage.
// The collect() method causes this SQL statement to be executed.
DataFrame dfStageFiles  = session.sql("ls @myStage");
Row[] files = dfStageFiles.collect();
System.out.println(Arrays.toString(files));

// Resume the operation of a warehouse.
// Note that you must call the collect method in order to execute
// the SQL statement.
session.sql("alter warehouse if exists myWarehouse resume if suspended").collect();

DataFrame tableDf = session.table("sample_product_data").select(Functions.col("id"), Functions.col("name"));
// Get the count of rows from the table.
long numRows = tableDf.count();
System.out.println("Count: " + numRows);

-- Example 21471
import java.util.Arrays;

DataFrame df = session.sql("select id, category_id, name from sample_product_data where id > 10");
// Because the underlying SQL statement for the DataFrame is a SELECT statement,
// you can call the filter method to transform this DataFrame.
Row[] results = df.filter(Functions.col("category_id").lt(Functions.lit(10))).select(Functions.col("id")).collect();
System.out.println(Arrays.toString(results));

// In this example, the underlying SQL statement is not a SELECT statement.
DataFrame dfStageFiles = session.sql("ls @myStage");
// Calling the filter method results in an error.
dfStageFiles.filter(...);

-- Example 21472
DataFrame df = session.table("sample_product_data");
df.select(Functions.upper(Functions.col("name"))).show();

-- Example 21473
// Call the system-defined function RADIANS() on degrees.
DataFrame dfDegrees = session.range(0, 360, 45).rename("degrees", Functions.col("id"));
dfDegrees.select(Functions.col("degrees"), Functions.callUDF("radians", Functions.col("degrees"))).show();

-- Example 21474
import com.snowflake.snowpark_java.types.*;
...
// Create and register a temporary named UDF
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerTemporary(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType);
// Call the named UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", doubleUdf.apply(Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 21475
CREATE OR REPLACE FUNCTION product_by_category_id(cat_id INT)
  RETURNS TABLE(id INT, name VARCHAR)
  AS
  $$
    SELECT id, name
      FROM sample_product_data
      WHERE category_id = cat_id
  $$
  ;

-- Example 21476
import java.util.HashMap;
import java.util.Map;
...

Map<String, Column> arguments = new HashMap<>();
arguments.put("cat_id", Functions.lit(10));
DataFrame dfTableFunctionOutput = session.tableFunction(new TableFunction("product_by_category_id"), arguments);
dfTableFunctionOutput.show();

-- Example 21477
Session session = Session.builder().configFile("my_config.properties").create();

// Assign the lambda function to a variable.
JavaSProc1<Integer, Integer> func =
  (Session session, Integer num) -> num + 1;

// Execute the function locally.
int result = (Integer)session.sproc().runLocally(func, 1);
System.out.println("\nResult: " + result);

// Register the procedure.
StoredProcedure sp =
  session.sproc().registerTemporary(
    func,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

// Execute the procedure on the server.
session.storedProcedure(sp, 1).show();

-- Example 21478
Session session = Session.builder().configFile("my_config.properties").create();

String incrementProc = "increment";

// Register the procedure.
StoredProcedure tempSP =
  session.sproc().registerTemporary(
    incrementProc,
    (Session session, Integer num) -> num + 1,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

// Execute the procedure on the server by passing the procedure's name.
session.storedProcedure(incrementProc, 1).show();

// Execute the procedure on the server by passing a variable
// representing the procedure.
session.storedProcedure(tempSP, 1).show();

-- Example 21479
import com.snowflake.snowpark_java.*;
import java.util.HashMap;
import java.util.Map;

public class SnowparkExample {
  public static void main(String[] args) {
    // Create a Session, specifying the properties used to
    // connect to the Snowflake database.
    Map<String, String> properties = new HashMap<>();
    properties.put("URL", "https://<account_identifier>.snowflakecomputing.com");
    properties.put("USER", "<username>");
    properties.put("PASSWORD", "<password>");
    properties.put("ROLE", "<role_name_with_access_to_public_schema>");
    properties.put("WAREHOUSE", "<warehouse_name>");
    properties.put("DB", "<database_name>");
    properties.put("SCHEMA", "<schema_name>");
    Session session = Session.builder().configs(properties).create();

    // Get the number of tables in the PUBLIC schema.
    DataFrame dfTables = session.table("INFORMATION_SCHEMA.TABLES")
      .filter(Functions.col("TABLE_SCHEMA").equal_to(Functions.lit("PUBLIC")));
    long tableCount = dfTables.count();
    String currentDb = session.getCurrentDatabase().orElse("<no current database>");
    System.out.println("Number of tables in the PUBLIC schema in " + currentDb + " database: " + tableCount);

    // Get the list of table names in the PUBLIC schema.
    DataFrame dfPublicSchemaTables = dfTables.select(Functions.col("TABLE_NAME"));
    dfPublicSchemaTables.show();
  }
}

-- Example 21480
Number of tables in the PUBLIC schema in the "MY_DB" database: 8
...
---------------------
|"TABLE_NAME"       |
---------------------
|A_TABLE            |
...

-- Example 21481
----------DATAFRAME EXECUTION PLAN----------
Query List:
0.
SELECT
  "_1" AS "col %",
  "_2" AS "col *"
FROM
  (
    SELECT
      *
    FROM
      (
        VALUES
          (1 :: int, 2 :: int),
          (3 :: int, 4 :: int) AS SN_TEMP_OBJECT_639016133("_1", "_2")
      )
  )
Logical Execution Plan:
 GlobalStats:
    partitionsTotal=0
    partitionsAssigned=0
    bytesAssigned=0
Operations:
1:0     ->Result  SN_TEMP_OBJECT_639016133.COLUMN1, SN_TEMP_OBJECT_639016133.COLUMN2
1:1          ->ValuesClause  (1, 2), (3, 4)

--------------------------------------------

-- Example 21482
# simplelogger.properties file (a text file)
# Set the default log level for the SimpleLogger to DEBUG.
org.slf4j.simpleLogger.defaultLogLevel=debug

-- Example 21483
java.base does not "opens java.nio" to unnamed module

-- Example 21484
--add-opens=java.base/java.nio=ALL-UNNAMED

