-- Example 27177
// Create a DataFrame that joins the DataFrames for the tables
// "sample_a" and "sample_b" on the column named "id_a".
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"))
dfJoined.show()

-- Example 27178
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |
|40      |A2        |10       |4000    |B1        |40      |10       |
|80      |A3        |15       |9000    |B3        |80      |15       |
----------------------------------------------------------------------

-- Example 27179
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"))
val dfSelected = dfJoined.select(dfLhs.col("value").as("LeftValue"), dfRhs.col("value").as("RightValue"))
dfSelected.show()

-- Example 27180
------------------------------
|"LEFTVALUE"  |"RIGHTVALUE"  |
------------------------------
|5            |5             |
|10           |10            |
|15           |15            |
------------------------------

-- Example 27181
--------------------------------------------------------------------------------------------------
|"l_ZSz7_ID_A"  |"NAME_A"  |"l_ZSz7_VALUE"  |"ID_B"  |"NAME_B"  |"r_heec_ID_A"  |"r_heec_VALUE"  |
--------------------------------------------------------------------------------------------------
|10             |A1        |5               |4001    |B2        |10             |5               |
|40             |A2        |10              |4000    |B1        |40             |10              |
|80             |A3        |15              |9000    |B3        |80             |15              |
--------------------------------------------------------------------------------------------------

-- Example 27182
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfJoined = dfLhs.naturalJoin(dfRhs)
dfJoined.show()

-- Example 27183
---------------------------------------------------
|"ID_A"  |"VALUE"  |"NAME_A"  |"ID_B"  |"NAME_B"  |
---------------------------------------------------
|10      |5        |A1        |4001    |B2        |
|40      |10       |A2        |4000    |B1        |
|80      |15       |A3        |9000    |B3        |
---------------------------------------------------

-- Example 27184
// Create a DataFrame that performs a left outer join on
// "sample_a" and "sample_b" on the column named "id_a".
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfLeftOuterJoin = dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"), "left")
dfLeftOuterJoin.show()

-- Example 27185
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|40      |A2        |10       |4000    |B1        |40      |10       |
|10      |A1        |5        |4001    |B2        |10      |5        |
|80      |A3        |15       |9000    |B3        |80      |15       |
|90      |A4        |20       |NULL    |NULL      |NULL    |NULL     |
----------------------------------------------------------------------

-- Example 27186
val dfFirst = session.table("sample_a")
val dfSecond  = session.table("sample_b")
val dfThird = session.table("sample_c")
val dfJoinThreeTables = dfFirst.join(dfSecond, dfFirst.col("id_a") === dfSecond.col("id_a")).join(dfThird, dfFirst.col("id_a") === dfThird.col("id_a"))
dfJoinThreeTables.show()

-- Example 27187
------------------------------------------------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |"ID_C"  |"NAME_C"  |"ID_A"  |"ID_B"  |
------------------------------------------------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |1012    |C1        |10      |NULL    |
|40      |A2        |10       |4000    |B1        |40      |10       |1040    |C2        |40      |4000    |
|40      |A2        |10       |4000    |B1        |40      |10       |1041    |C3        |40      |4001    |
------------------------------------------------------------------------------------------------------------

-- Example 27188
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
val df = session.table("sample_product_data");
val dfJoined = df.join(df, col("id") === col("parent_id"))

-- Example 27189
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
val df = session.table("sample_product_data");
val dfJoined = df.join(df, df("id") === df("parent_id"))

-- Example 27190
Exception in thread "main" com.snowflake.snowpark.SnowparkClientException:
  Joining a DataFrame to itself can lead to incorrect results due to ambiguity of column references.
  Instead, join this DataFrame to a clone() of itself.

-- Example 27191
// Create a DataFrame object for the "sample_product_data" table for the left-hand side of the join.
val dfLhs = session.table("sample_product_data")
// Clone the DataFrame object to use as the right-hand side of the join.
val dfRhs = dfLhs.clone()

// Create a DataFrame that joins the two DataFrames
// for the "sample_product_data" table on the
// "id" and "parent_id" columns.
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("id") === dfRhs.col("parent_id"))
dfJoined.show()

-- Example 27192
// Create a DataFrame that performs a self-join on a DataFrame
// using the column named "key".
val df = session.table("sample_product_data");
val dfJoined = df.join(df, Seq("key"))

-- Example 27193
// Create a DataFrame for the "sample_product_data" table.
val dfProducts = session.table("sample_product_data")

// Send the query to the server for execution and
// print the count of rows in the table.
println("Rows returned: " + dfProducts.count())

-- Example 27194
// Create a DataFrame with the "id" and "name" columns from the "sample_product_data" table.
// This does not execute the query.
val df = session.table("sample_product_data").select(col("id"), col("name"))

// Execute the query asynchronously.
// This call does not block.
val asyncJob = df.async.collect()
// Check if the query has completed execution.
println(s"Is query ${asyncJob.getQueryId()} done? ${asyncJob.isDone()}")
// Get an Array of Rows containing the results, and print the results.
// Note that getResult is a blocking call.
val results = asyncJob.getResult()
results.foreach(println)

-- Example 27195
// Create a DataFrame for the "sample_product_data" table.
val dfProducts = session.table("sample_product_data")

// Execute the query asynchronously.
// This call does not block.
val asyncJob = df.async.count()
// Check if the query has completed execution.
println(s"Is query ${asyncJob.getQueryId()} done? ${asyncJob.isDone()}")
// Print the count of rows in the table.
// Note that getResult is a blocking call.
println("Rows returned: " + asyncJob.getResult())

-- Example 27196
// Wait a maximum of 10 seconds for the query to complete before retrieving the results.
val results = asyncJob.getResult(10)

-- Example 27197
val asyncJob = session.createAsyncJob(myQueryId)
// Check if the query has completed execution.
println(s"Is query ${asyncJob.getQueryId()} done? ${asyncJob.isDone()}")
// If you need to retrieve the results, call getRows to return an Array of Rows containing the results.
// Note that getRows is a blocking call.
val rows = asyncJob.getRows()
rows.foreach(println)

-- Example 27198
import com.snowflake.snowpark.functions_

val rows = session.table("sample_product_data").select(col("name"), col("category_id")).sort(col("name")).collect()
for (row <- rows) {
  println(s"Name: ${row.getString(0)}; Category ID: ${row.getInt(1)}")
}

-- Example 27199
import com.snowflake.snowpark.functions_

while (rowIterator.hasNext) {
  val row = rowIterator.next()
  println(s"Name: ${row.getString(0)}; Category ID: ${row.getInt(1)}")
}

-- Example 27200
import com.snowflake.snowpark.functions_

val df = session.table("sample_product_data")
val rows = df.sort(col("name")).first(5)
rows.foreach(println)

-- Example 27201
import com.snowflake.snowpark.functions_

val df = session.table("sample_product_data")
df.sort(col("name")).show()

-- Example 27202
val updatableDf = session.table("sample_product_data")
val updateResult = updatableDf.update(Map("count" -> lit(1)))
println(s"Number of rows updated: ${updateResult.rowsUpdated}")

-- Example 27203
val updateResult = updatableDf.update(Map(col("count") -> lit(1)))

-- Example 27204
val updateResult = updatableDf.update(Map(col("count") -> lit(1)), col("category_id") === 20)

-- Example 27205
val updatableDf = session.table("sample_product_data")
val dfParts = session.table("parts")
val updateResult = updatableDf.update(Map(col("count") -> lit(1)), updatableDf("category_id") === dfParts("category_id"), dfParts)

-- Example 27206
val updatableDf = session.table("sample_product_data")
val deleteResult = updatableDf.delete(updatableDf("category_id") === 1)
println(s"Number of rows deleted: ${deleteResult.rowsDeleted}")

-- Example 27207
val updatableDf = session.table("sample_product_data")
val deleteResult = updatableDf.delete(updatableDf("category_id") === dfParts("category_id"), dfParts)
println(s"Number of rows deleted: ${deleteResult.rowsDeleted}")

-- Example 27208
val mergeResult = target.merge(source, target("id") === source("id"))
                      .whenNotMatched.insert(Seq(source("id"), source("value")))
                      .collect()

-- Example 27209
val mergeResult = target.merge(source, target("id") === source("id"))
                      .whenMatched.update(Map("value" -> source("value")))
                      .collect()

-- Example 27210
df.write.mode(SaveMode.Overwrite).saveAsTable(tableName)

-- Example 27211
val df = session.sql("SELECT 1 AS c2, 2 as c1")
// With the columnOrder option set to "name", the DataFrameWriter uses the column names
// and inserts a row with the values (2, 1).
df.write.mode(SaveMode.Append).option("columnOrder", "name").saveAsTable(tableName)
// With the default value of the columnOrder option ("index"), the DataFrameWriter the uses column positions
// and inserts a row with the values (1, 2).
df.write.mode(SaveMode.Append).saveAsTable(tableName)

-- Example 27212
df.createOrReplaceView("db.schema.viewName")

-- Example 27213
df.createOrReplaceTempView("db.schema.viewName")

-- Example 27214
import com.snowflake.snowpark.functions_

// Set up a DataFrame to query a table.
val df = session.table("sample_product_data").filter(col("category_id") > 10)
// Retrieve the results and cache the data.
val cachedDf = df.cacheResult()
// Create a DataFrame containing a subset of the cached data.
val dfSubset = cachedDf.filter(col("category_id") === lit(20)).select(col("name"), col("category_id"))
dfSubset.show()

-- Example 27215
val dfTempTable = dfTable.cacheResult()

-- Example 27216
// Upload a file to a stage without compressing the file.
val putOptions = Map("AUTO_COMPRESS" -> "FALSE")
val putResults = session.file.put("file:///tmp/myfile.csv", "@myStage", putOptions)

-- Example 27217
// Upload the CSV files in /tmp with names that start with "file".
// You can use the wildcard characters "*" and "?" to match multiple files.
val putResults = session.file.put("file:///tmp/file*.csv", "@myStage/prefix2")

-- Example 27218
// Print the filename and the status of the PUT operation.
putResults.foreach(r => println(s"  ${r.sourceFileName}: ${r.status}"))

-- Example 27219
// Download files with names that match a regular expression pattern.
val getOptions = Map("PATTERN" -> s"'.*file_.*.csv.gz'")
val getResults = session.file.get("@myStage", "file:///tmp", getOptions)

-- Example 27220
// Print the filename and the status of the GET operation.
getResults.foreach(r => println(s"  ${r.fileName}: ${r.status}"))

-- Example 27221
import java.io.InputStream
...
val compressData = true
val pathToFileOnStage = "@myStage/path/file"
session.file.uploadStream(pathToFileOnStage, new ByteArrayInputStream(fileContent.getBytes()), compressData)

-- Example 27222
import java.io.InputStream
...
val isDataCompressed = true
val pathToFileOnStage = "@myStage/path/file"
val is = session.file.downloadStream(pathToFileOnStage, isDataCompressed)

-- Example 27223
import com.snowflake.snowpark.types._

val schemaForDataFile = StructType(
    Seq(
        StructField("id", StringType, true),
        StructField("name", StringType, true)))

-- Example 27224
var dfReader = session.read.schema(schemaForDataFile)

-- Example 27225
dfReader = dfReader.option("field_delimiter", ";").option("COMPRESSION", "NONE")

-- Example 27226
val df = dfReader.csv("@s3_ts_stage/emails/data_0_0_0.csv")

-- Example 27227
val df = dfReader.csv("@mystage/csv_")

-- Example 27228
val df = session.read.json("@mystage/data.json").select(col("$1")("color"))

-- Example 27229
val results = df.collect()

-- Example 27230
val df = session.read.schema(csvFileSchema).csv(myFileStage)
df.copyInto("mytable")

-- Example 27231
dfWriter = session.table("sample_product_data").write

-- Example 27232
dfWriter = dfWriter.mode(SaveMode.Overwrite)

-- Example 27233
dfWriter = dfWriter.option("field_delimiter", ";").option("COMPRESSION", "NONE")

-- Example 27234
val writeFileResult = dfWriter.csv("@mystage/saved_data")

-- Example 27235
val writeFileResult = dfWriter.csv("@mystage/saved_data")
for ((row, index) <- writeFileResult.rows.zipWithIndex) {
  (writeFileResult.schema.fields, writeFileResult.rows(index).toSeq).zipped.foreach {
    (structField, element) => println(s"${structField.name}: $element")
  }
}

-- Example 27236
val df = session.table("car_sales")
val writeFileResult = df.write.mode(SaveMode.Overwrite).option("DETAILED_OUTPUT", "TRUE").option("compression", "none").json("@mystage/saved_data")
for ((row, index) <- writeFileResult.rows.zipWithIndex) {
  println(s"Row: $index")
  (writeFileResult.schema.fields, writeFileResult.rows(index).toSeq).zipped.foreach {
    (structField, element) => println(s"${structField.name}: $element")
  }
}

-- Example 27237
col("column_name")("field_name")
col("column_name")(index)

-- Example 27238
val df = session.table("car_sales")
df.select(col("src")("dealership")).show()

-- Example 27239
----------------------------
|"""SRC""['DEALERSHIP']"   |
----------------------------
|"Valley View Auto Sales"  |
|"Tindel Toyota"           |
----------------------------

-- Example 27240
val df = session.table("car_sales")
df.select(col("src")("salesperson")("name")).show()

-- Example 27241
------------------------------------
|"""SRC""['SALESPERSON']['NAME']"  |
------------------------------------
|"Frank Beasley"                   |
|"Greg Northrup"                   |
------------------------------------

-- Example 27242
val df = session.table("car_sales")
df.select(col("src")("vehicle")(0)).show()
df.select(col("src")("vehicle")(0)("price")).show()

-- Example 27243
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

