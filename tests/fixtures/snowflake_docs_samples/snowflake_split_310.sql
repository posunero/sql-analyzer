-- Example 20748
// Upload a file to a stage without compressing the file.
val putOptions = Map("AUTO_COMPRESS" -> "FALSE")
val putResults = session.file.put("file:///tmp/myfile.csv", "@myStage", putOptions)

-- Example 20749
// Upload the CSV files in /tmp with names that start with "file".
// You can use the wildcard characters "*" and "?" to match multiple files.
val putResults = session.file.put("file:///tmp/file*.csv", "@myStage/prefix2")

-- Example 20750
// Print the filename and the status of the PUT operation.
putResults.foreach(r => println(s"  ${r.sourceFileName}: ${r.status}"))

-- Example 20751
// Download files with names that match a regular expression pattern.
val getOptions = Map("PATTERN" -> s"'.*file_.*.csv.gz'")
val getResults = session.file.get("@myStage", "file:///tmp", getOptions)

-- Example 20752
// Print the filename and the status of the GET operation.
getResults.foreach(r => println(s"  ${r.fileName}: ${r.status}"))

-- Example 20753
import java.io.InputStream
...
val compressData = true
val pathToFileOnStage = "@myStage/path/file"
session.file.uploadStream(pathToFileOnStage, new ByteArrayInputStream(fileContent.getBytes()), compressData)

-- Example 20754
import java.io.InputStream
...
val isDataCompressed = true
val pathToFileOnStage = "@myStage/path/file"
val is = session.file.downloadStream(pathToFileOnStage, isDataCompressed)

-- Example 20755
import com.snowflake.snowpark.types._

val schemaForDataFile = StructType(
    Seq(
        StructField("id", StringType, true),
        StructField("name", StringType, true)))

-- Example 20756
var dfReader = session.read.schema(schemaForDataFile)

-- Example 20757
dfReader = dfReader.option("field_delimiter", ";").option("COMPRESSION", "NONE")

-- Example 20758
val df = dfReader.csv("@s3_ts_stage/emails/data_0_0_0.csv")

-- Example 20759
val df = dfReader.csv("@mystage/csv_")

-- Example 20760
val df = session.read.json("@mystage/data.json").select(col("$1")("color"))

-- Example 20761
val results = df.collect()

-- Example 20762
val df = session.read.schema(csvFileSchema).csv(myFileStage)
df.copyInto("mytable")

-- Example 20763
dfWriter = session.table("sample_product_data").write

-- Example 20764
dfWriter = dfWriter.mode(SaveMode.Overwrite)

-- Example 20765
dfWriter = dfWriter.option("field_delimiter", ";").option("COMPRESSION", "NONE")

-- Example 20766
val writeFileResult = dfWriter.csv("@mystage/saved_data")

-- Example 20767
val writeFileResult = dfWriter.csv("@mystage/saved_data")
for ((row, index) <- writeFileResult.rows.zipWithIndex) {
  (writeFileResult.schema.fields, writeFileResult.rows(index).toSeq).zipped.foreach {
    (structField, element) => println(s"${structField.name}: $element")
  }
}

-- Example 20768
val df = session.table("car_sales")
val writeFileResult = df.write.mode(SaveMode.Overwrite).option("DETAILED_OUTPUT", "TRUE").option("compression", "none").json("@mystage/saved_data")
for ((row, index) <- writeFileResult.rows.zipWithIndex) {
  println(s"Row: $index")
  (writeFileResult.schema.fields, writeFileResult.rows(index).toSeq).zipped.foreach {
    (structField, element) => println(s"${structField.name}: $element")
  }
}

-- Example 20769
col("column_name")("field_name")
col("column_name")(index)

-- Example 20770
val df = session.table("car_sales")
df.select(col("src")("dealership")).show()

-- Example 20771
----------------------------
|"""SRC""['DEALERSHIP']"   |
----------------------------
|"Valley View Auto Sales"  |
|"Tindel Toyota"           |
----------------------------

-- Example 20772
val df = session.table("car_sales")
df.select(col("src")("salesperson")("name")).show()

-- Example 20773
------------------------------------
|"""SRC""['SALESPERSON']['NAME']"  |
------------------------------------
|"Frank Beasley"                   |
|"Greg Northrup"                   |
------------------------------------

-- Example 20774
val df = session.table("car_sales")
df.select(col("src")("vehicle")(0)).show()
df.select(col("src")("vehicle")(0)("price")).show()

-- Example 20775
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

-- Example 20776
df.select(get(col("src"), lit("dealership"))).show()
df.select(col("src")("dealership")).show()

-- Example 20777
df.select(get_path(col("src"), lit("vehicle[0].make"))).show()
df.select(col("src")("vehicle")(0)("make")).show()

-- Example 20778
// Import the objects for the data types, including StringType.
import com.snowflake.snowpark.types._
...
val df = session.table("car_sales")
df.select(col("src")("salesperson")("id")).show()
df.select(col("src")("salesperson")("id").cast(StringType)).show()

-- Example 20779
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

-- Example 20780
val df = session.table("car_sales")
df.flatten(col("src")("customer")).show()

-- Example 20781
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

-- Example 20782
df.flatten(col("src")("customer")).select(col("value")("name"), col("value")("address")).show()

-- Example 20783
-------------------------------------------------
|"""VALUE""['NAME']"   |"""VALUE""['ADDRESS']"  |
-------------------------------------------------
|"Joyce Ridgely"       |"San Francisco, CA"     |
|"Bradley Greenbloom"  |"New York, NY"          |
-------------------------------------------------

-- Example 20784
df.flatten(col("src")("customer")).select(col("value")("name").cast(StringType).as("Customer Name"), col("value")("address").cast(StringType).as("Customer Address")).show()

-- Example 20785
-------------------------------------------
|"Customer Name"     |"Customer Address"  |
-------------------------------------------
|Joyce Ridgely       |San Francisco, CA   |
|Bradley Greenbloom  |New York, NY        |
-------------------------------------------

-- Example 20786
// Get the list of the files in a stage.
// The collect() method causes this SQL statement to be executed.
val dfStageFiles = session.sql("ls @myStage")
val files = dfStageFiles.collect()
files.foreach(println)

// Resume the operation of a warehouse.
// Note that you must call the collect method in order to execute
// the SQL statement.
session.sql("alter warehouse if exists myWarehouse resume if suspended").collect()

val tableDf = session.table("table").select(col("a"), col("b"))
// Get the count of rows from the table.
val numRows = tableDf.count()
println("Count: " + numRows);

-- Example 20787
val df = session.sql("select id, category_id, name from sample_product_data where id > 10")
// Because the underlying SQL statement for the DataFrame is a SELECT statement,
// you can call the filter method to transform this DataFrame.
val results = df.filter(col("category_id") < 10).select(col("id")).collect()
results.foreach(println)

// In this example, the underlying SQL statement is not a SELECT statement.
val dfStageFiles = session.sql("ls @myStage")
// Calling the filter method results in an error.
dfStageFiles.filter(...)

-- Example 20788
// Import the upper function from the functions object.
import com.snowflake.snowpark.functions._
...
session.table("products").select(upper(col("name"))).show()

-- Example 20789
// Import the callBuiltin function from the functions object.
import com.snowflake.snowpark.functions._
...
// Call the system-defined function RADIANS() on col1.
val result = df.select(callBuiltin("radians", col("col1"))).collect()

-- Example 20790
// Import the callBuiltin function from the functions object.
import com.snowflake.snowpark.functions._
...
// Create a function object for the system-defined function RADIANS().
val radians = builtin("radians")
// Call the system-defined function RADIANS() on col1.
val result = df.select(radians(col("col1"))).collect()

-- Example 20791
// Import the callUDF function from the functions object.
import com.snowflake.snowpark.functions._
...
// Runs the scalar function 'myFunction' on col1 and col2 of df.
val result =
    df.select(
        callUDF("myDB.schema.myFunction", col("col1"), col("col2"))
    ).collect()

-- Example 20792
CREATE OR REPLACE FUNCTION product_by_category_id(cat_id INT)
  RETURNS TABLE(id INT, name VARCHAR)
  AS
  $$
    SELECT id, name
      FROM sample_product_data
      WHERE category_id = cat_id
  $$
  ;

-- Example 20793
val dfTableFunctionOutput = session.tableFunction(TableFunction("product_by_category_id"), Map("cat_id" -> lit(10)))
dfTableFunctionOutput.show()

-- Example 20794
val session = Session.builder.configFile("my_config.properties").create

// Assign the lambda function.
val func = (session: Session, num: Int) => num + 1

// Execute the function locally.
val result = session.sproc.runLocally(func, 1)
print("\nResult: " + result)

-- Example 20795
val session = Session.builder.configFile("my_config.properties").create

val name: String = "add_two"

val tempSP: StoredProcedure =
  session.sproc.registerTemporary(
    name,
    (session: Session, num: Int) => num + 2
  )

session.storedProcedure(name, 1).show()

// Execute the procedure on the server by passing the procedure's name.
session.storedProcedure(incrementProc, 1).show();

// Execute the procedure on the server by passing a variable
// representing the procedure.
session.storedProcedure(tempSP, 1).show();

-- Example 20796
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._

object Main {
  def main(args: Array[String]) {

    // Create a Session, specifying the properties used to
    // connect to the Snowflake database.
    val builder = Session.builder.configs(Map(
      "URL" -> "https://<account_identifier>.snowflakecomputing.com",
      "USER" -> "<username>",
      "PASSWORD" -> "<password>",
      "ROLE" -> "<role_name_with_access_to_public_schema>",
      "WAREHOUSE" -> "<warehouse_name>",
      "DB" -> "<database_name>",
      "SCHEMA" -> "<schema_name>"
    ))
    val session = builder.create

    // Get the number of tables in the PUBLIC schema.
    var dfTables = session.table("INFORMATION_SCHEMA.TABLES").filter(col("TABLE_SCHEMA") === "PUBLIC")
    var tableCount = dfTables.count()
    var currentDb = session.getCurrentDatabase.getOrElse("<no current database>")
    println(s"Number of tables in the PUBLIC schema in the $currentDb database: $tableCount")

    // Get the list of table names in the PUBLIC schema.
    var dfPublicSchemaTables = dfTables.select(col("TABLE_NAME"))
    dfPublicSchemaTables.show()
  }
}

-- Example 20797
Number of tables in the PUBLIC schema in the "MY_DB" database: 8
...
---------------------
|"TABLE_NAME"       |
---------------------
|A_TABLE            |
...

-- Example 20798
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

-- Example 20799
# simplelogger.properties file (a text file)
# Set the default log level for the SimpleLogger to DEBUG.
org.slf4j.simpleLogger.defaultLogLevel=debug

-- Example 20800
scala -J-Xmx4G ...

-- Example 20801
SELECT id, name FROM sample_product_data;

-- Example 20802
val dfSelectedCols = df.select(col("id"), col("name"))
dfSelectedCols.show()

-- Example 20803
SELECT id AS item_id FROM sample_product_data;

-- Example 20804
val dfRenamedCol = df.select(col("id").as("item_id"))
dfRenamedCol.show()

-- Example 20805
val dfRenamedCol = df.select(col("id").alias("item_id"))
dfRenamedCol.show()

-- Example 20806
val dfRenamedCol = df.select(col("id").name("item_id"))
dfRenamedCol.show()

-- Example 20807
SELECT * FROM sample_product_data WHERE id = 1;

-- Example 20808
val dfFilteredRows = df.filter((col("id") === 1))
dfFilteredRows.show()

-- Example 20809
val dfFilteredRows = df.where((col("id") === 1))
dfFilteredRows.show()

-- Example 20810
SELECT * FROM sample_product_data ORDER BY category_id;

-- Example 20811
val dfSorted = df.sort(col("category_id"))
dfSorted.show()

-- Example 20812
SELECT * FROM sample_product_data
  ORDER BY category_id LIMIT 2;

-- Example 20813
val dfSorted = df.sort(col("category_id")).limit(2);
val arrayRows = dfSorted.collect()

-- Example 20814
SELECT * FROM sample_a
  INNER JOIN sample_b
  on sample_a.id_a = sample_b.id_a;

