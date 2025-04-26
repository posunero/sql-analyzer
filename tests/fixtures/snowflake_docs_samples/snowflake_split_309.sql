-- Example 20681
// Import the col function from the functions object.
import com.snowflake.snowpark.functions._

// Create a DataFrame for the rows with the ID 1
// in the "sample_product_data" table.
//
// This example uses the === operator of the Column object to perform an
// equality check.
val df = session.table("sample_product_data").filter(col("id") === 1)
df.show()

-- Example 20682
// Import the col function from the functions object.
import com.snowflake.snowpark.functions._

// Create a DataFrame that contains the id, name, and serial_number
// columns in te "sample_product_data" table.
val df = session.table("sample_product_data").select(col("id"), col("name"), col("serial_number"))
df.show()

-- Example 20683
// Import the col function from the functions object.
import com.snowflake.snowpark.functions._

val dfProductInfo = session.table("sample_product_data").select(col("id"), col("name"))
dfProductInfo.show()

-- Example 20684
// Specify the equivalent of "WHERE id = 20"
// in an SQL SELECT statement.
df.filter(col("id") === 20)

-- Example 20685
// Specify the equivalent of "WHERE a + b < 10"
// in an SQL SELECT statement.
df.filter((col("a") + col("b")) < 10)

-- Example 20686
// Specify the equivalent of "SELECT b * 10 AS c"
// in an SQL SELECT statement.
df.select((col("b") * 10) as "c")

-- Example 20687
// Specify the equivalent of "X JOIN Y on X.a_in_X = Y.b_in_Y"
// in an SQL SELECT statement.
dfX.join(dfY, col("a_in_X") === col("b_in_Y"))

-- Example 20688
// Create a DataFrame that joins two other DataFrames (dfLhs and dfRhs).
// Use the DataFrame.col method to refer to the columns used in the join.
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("key") === dfRhs.col("key")).select(dfLhs.col("value").as("L"), dfRhs.col("value").as("R"))

-- Example 20689
// Create a DataFrame that joins two other DataFrames (dfLhs and dfRhs).
// Use the DataFrame.apply method to refer to the columns used in the join.
// Note that dfLhs("key") is shorthand for dfLhs.apply("key").
val dfJoined = dfLhs.join(dfRhs, dfLhs("key") === dfRhs("key")).select(dfLhs("value").as("L"), dfRhs("value").as("R"))

-- Example 20690
val session = Session.builder.configFile("/path/to/properties").create

// Import this after you create the session.
import session.implicits._

// Use the $ (dollar sign) shorthand.
val df = session.table("T").filter($"id" === 10).filter(($"a" + $"b") < 10)

// Use ' (apostrophe) shorthand.
val df = session.table("T").filter('id === 10).filter(('a + 'b) < 10).select('b * 10)

-- Example 20691
// The following calls are equivalent:
df.select(col("id123"))
df.select(col("ID123"))

-- Example 20692
val df = session.table("\"10tablename\"")

-- Example 20693
// The following calls are equivalent:
df.select(col("3rdID"))
df.select(col("\"3rdID\""))

// The following calls are equivalent:
df.select(col("id with space"))
df.select(col("\"id with space\""))

-- Example 20694
describe table quoted;
+------------------------+ ...
| name                   | ...
|------------------------+ ...
| name_with_"air"_quotes | ...
| "column_name_quoted"   | ...
+------------------------+ ...

-- Example 20695
val dfTable = session.table("quoted")
dfTable.select("\"name_with_\"\"air\"\"_quotes\"").show()
dfTable.select("\"\"\"column_name_quoted\"\"\"").show()

-- Example 20696
// The following calls are NOT equivalent!
// The Snowpark library adds double quotes around the column name,
// which makes Snowflake treat the column name as case-sensitive.
df.select(col("id with space"))
df.select(col("ID WITH SPACE"))

-- Example 20697
// Import for the lit and col functions.
import com.snowflake.snowpark.functions._

// Show the first 10 rows in which num_items is greater than 5.
// Use `lit(5)` to create a Column object for the literal 5.
df.filter(col("num_items").gt(lit(5))).show()

-- Example 20698
// Create a DataFrame that contains the value 0.05.
val df = session.sql("select 0.05 :: Numeric(5, 2) as a")

// Applying this filter results in no matching rows in the DataFrame.
df.filter(col("a") <= lit(0.06) - lit(0.01)).show()

-- Example 20699
df.filter(col("a") <= lit(0.06).cast(new DecimalType(5, 2)) - lit(0.01).cast(new DecimalType(5, 2))).show()

-- Example 20700
df.filter(col("a") <= lit(BigDecimal(0.06)) - lit(BigDecimal(0.01))).show()

-- Example 20701
// Import for the lit function.
import com.snowflake.snowpark.functions._
// Import for the DecimalType class..
import com.snowflake.snowpark.types._

val decimalValue = lit(0.05).cast(new DecimalType(5,2))

-- Example 20702
val dfProductInfo = session.table("sample_product_data").filter(col("id") === 1).select(col("name"), col("serial_number"))
dfProductInfo.show()

-- Example 20703
// This fails with the error "invalid identifier 'ID'."
val dfProductInfo = session.table("sample_product_data").select(col("name"), col("serial_number")).filter(col("id") === 1)

-- Example 20704
// This succeeds because the DataFrame returned by the table() method
// includes the "id" column.
val dfProductInfo = session.table("sample_product_data").filter(col("id") === 1).select(col("name"), col("serial_number"))
dfProductInfo.show()

-- Example 20705
// Limit the number of rows to 5, sorted by parent_id.
var dfSubset = df.sort(col("parent_id")).limit(5);

// Return the first 5 rows, sorted by parent_id.
var arrayOfRows = df.sort(col("parent_id")).first(5)

// Print the first 5 rows, sorted by parent_id.
df.sort(col("parent_id")).show(5)

-- Example 20706
// Get the StructType object that describes the columns in the
// underlying rowset.
val tableSchema = session.table("sample_product_data").schema
println("Schema for sample_product_data: " + tableSchema);

-- Example 20707
// Create a DataFrame containing the "id" and "3rd" columns.
val dfSelectedColumns = session.table("sample_product_data").select(col("id"), col("3rd"))
// Print out the names of the columns in the schema. This prints out:
//   ArraySeq(ID, "3rd")
println(dfSelectedColumns.schema.names.toSeq)

-- Example 20708
create or replace table sample_a (
  id_a integer,
  name_a varchar,
  value integer
);
insert into sample_a (id_a, name_a, value) values
  (10, 'A1', 5),
  (40, 'A2', 10),
  (80, 'A3', 15),
  (90, 'A4', 20)
;
create or replace table sample_b (
  id_b integer,
  name_b varchar,
  id_a integer,
  value integer
);
insert into sample_b (id_b, name_b, id_a, value) values
  (4000, 'B1', 40, 10),
  (4001, 'B2', 10, 5),
  (9000, 'B3', 80, 15),
  (9099, 'B4', null, 200)
;
create or replace table sample_c (
  id_c integer,
  name_c varchar,
  id_a integer,
  id_b integer
);
insert into sample_c (id_c, name_c, id_a, id_b) values
  (1012, 'C1', 10, null),
  (1040, 'C2', 40, 4000),
  (1041, 'C3', 40, 4001)
;

-- Example 20709
// Create a DataFrame that joins the DataFrames for the tables
// "sample_a" and "sample_b" on the column named "id_a".
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"))
dfJoined.show()

-- Example 20710
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |
|40      |A2        |10       |4000    |B1        |40      |10       |
|80      |A3        |15       |9000    |B3        |80      |15       |
----------------------------------------------------------------------

-- Example 20711
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"))
val dfSelected = dfJoined.select(dfLhs.col("value").as("LeftValue"), dfRhs.col("value").as("RightValue"))
dfSelected.show()

-- Example 20712
------------------------------
|"LEFTVALUE"  |"RIGHTVALUE"  |
------------------------------
|5            |5             |
|10           |10            |
|15           |15            |
------------------------------

-- Example 20713
--------------------------------------------------------------------------------------------------
|"l_ZSz7_ID_A"  |"NAME_A"  |"l_ZSz7_VALUE"  |"ID_B"  |"NAME_B"  |"r_heec_ID_A"  |"r_heec_VALUE"  |
--------------------------------------------------------------------------------------------------
|10             |A1        |5               |4001    |B2        |10             |5               |
|40             |A2        |10              |4000    |B1        |40             |10              |
|80             |A3        |15              |9000    |B3        |80             |15              |
--------------------------------------------------------------------------------------------------

-- Example 20714
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfJoined = dfLhs.naturalJoin(dfRhs)
dfJoined.show()

-- Example 20715
---------------------------------------------------
|"ID_A"  |"VALUE"  |"NAME_A"  |"ID_B"  |"NAME_B"  |
---------------------------------------------------
|10      |5        |A1        |4001    |B2        |
|40      |10       |A2        |4000    |B1        |
|80      |15       |A3        |9000    |B3        |
---------------------------------------------------

-- Example 20716
// Create a DataFrame that performs a left outer join on
// "sample_a" and "sample_b" on the column named "id_a".
val dfLhs = session.table("sample_a")
val dfRhs = session.table("sample_b")
val dfLeftOuterJoin = dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"), "left")
dfLeftOuterJoin.show()

-- Example 20717
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|40      |A2        |10       |4000    |B1        |40      |10       |
|10      |A1        |5        |4001    |B2        |10      |5        |
|80      |A3        |15       |9000    |B3        |80      |15       |
|90      |A4        |20       |NULL    |NULL      |NULL    |NULL     |
----------------------------------------------------------------------

-- Example 20718
val dfFirst = session.table("sample_a")
val dfSecond  = session.table("sample_b")
val dfThird = session.table("sample_c")
val dfJoinThreeTables = dfFirst.join(dfSecond, dfFirst.col("id_a") === dfSecond.col("id_a")).join(dfThird, dfFirst.col("id_a") === dfThird.col("id_a"))
dfJoinThreeTables.show()

-- Example 20719
------------------------------------------------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |"ID_C"  |"NAME_C"  |"ID_A"  |"ID_B"  |
------------------------------------------------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |1012    |C1        |10      |NULL    |
|40      |A2        |10       |4000    |B1        |40      |10       |1040    |C2        |40      |4000    |
|40      |A2        |10       |4000    |B1        |40      |10       |1041    |C3        |40      |4001    |
------------------------------------------------------------------------------------------------------------

-- Example 20720
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
val df = session.table("sample_product_data");
val dfJoined = df.join(df, col("id") === col("parent_id"))

-- Example 20721
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
val df = session.table("sample_product_data");
val dfJoined = df.join(df, df("id") === df("parent_id"))

-- Example 20722
Exception in thread "main" com.snowflake.snowpark.SnowparkClientException:
  Joining a DataFrame to itself can lead to incorrect results due to ambiguity of column references.
  Instead, join this DataFrame to a clone() of itself.

-- Example 20723
// Create a DataFrame object for the "sample_product_data" table for the left-hand side of the join.
val dfLhs = session.table("sample_product_data")
// Clone the DataFrame object to use as the right-hand side of the join.
val dfRhs = dfLhs.clone()

// Create a DataFrame that joins the two DataFrames
// for the "sample_product_data" table on the
// "id" and "parent_id" columns.
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("id") === dfRhs.col("parent_id"))
dfJoined.show()

-- Example 20724
// Create a DataFrame that performs a self-join on a DataFrame
// using the column named "key".
val df = session.table("sample_product_data");
val dfJoined = df.join(df, Seq("key"))

-- Example 20725
// Create a DataFrame for the "sample_product_data" table.
val dfProducts = session.table("sample_product_data")

// Send the query to the server for execution and
// print the count of rows in the table.
println("Rows returned: " + dfProducts.count())

-- Example 20726
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

-- Example 20727
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

-- Example 20728
// Wait a maximum of 10 seconds for the query to complete before retrieving the results.
val results = asyncJob.getResult(10)

-- Example 20729
val asyncJob = session.createAsyncJob(myQueryId)
// Check if the query has completed execution.
println(s"Is query ${asyncJob.getQueryId()} done? ${asyncJob.isDone()}")
// If you need to retrieve the results, call getRows to return an Array of Rows containing the results.
// Note that getRows is a blocking call.
val rows = asyncJob.getRows()
rows.foreach(println)

-- Example 20730
import com.snowflake.snowpark.functions_

val rows = session.table("sample_product_data").select(col("name"), col("category_id")).sort(col("name")).collect()
for (row <- rows) {
  println(s"Name: ${row.getString(0)}; Category ID: ${row.getInt(1)}")
}

-- Example 20731
import com.snowflake.snowpark.functions_

while (rowIterator.hasNext) {
  val row = rowIterator.next()
  println(s"Name: ${row.getString(0)}; Category ID: ${row.getInt(1)}")
}

-- Example 20732
import com.snowflake.snowpark.functions_

val df = session.table("sample_product_data")
val rows = df.sort(col("name")).first(5)
rows.foreach(println)

-- Example 20733
import com.snowflake.snowpark.functions_

val df = session.table("sample_product_data")
df.sort(col("name")).show()

-- Example 20734
val updatableDf = session.table("sample_product_data")
val updateResult = updatableDf.update(Map("count" -> lit(1)))
println(s"Number of rows updated: ${updateResult.rowsUpdated}")

-- Example 20735
val updateResult = updatableDf.update(Map(col("count") -> lit(1)))

-- Example 20736
val updateResult = updatableDf.update(Map(col("count") -> lit(1)), col("category_id") === 20)

-- Example 20737
val updatableDf = session.table("sample_product_data")
val dfParts = session.table("parts")
val updateResult = updatableDf.update(Map(col("count") -> lit(1)), updatableDf("category_id") === dfParts("category_id"), dfParts)

-- Example 20738
val updatableDf = session.table("sample_product_data")
val deleteResult = updatableDf.delete(updatableDf("category_id") === 1)
println(s"Number of rows deleted: ${deleteResult.rowsDeleted}")

-- Example 20739
val updatableDf = session.table("sample_product_data")
val deleteResult = updatableDf.delete(updatableDf("category_id") === dfParts("category_id"), dfParts)
println(s"Number of rows deleted: ${deleteResult.rowsDeleted}")

-- Example 20740
val mergeResult = target.merge(source, target("id") === source("id"))
                      .whenNotMatched.insert(Seq(source("id"), source("value")))
                      .collect()

-- Example 20741
val mergeResult = target.merge(source, target("id") === source("id"))
                      .whenMatched.update(Map("value" -> source("value")))
                      .collect()

-- Example 20742
df.write.mode(SaveMode.Overwrite).saveAsTable(tableName)

-- Example 20743
val df = session.sql("SELECT 1 AS c2, 2 as c1")
// With the columnOrder option set to "name", the DataFrameWriter uses the column names
// and inserts a row with the values (2, 1).
df.write.mode(SaveMode.Append).option("columnOrder", "name").saveAsTable(tableName)
// With the default value of the columnOrder option ("index"), the DataFrameWriter the uses column positions
// and inserts a row with the values (1, 2).
df.write.mode(SaveMode.Append).saveAsTable(tableName)

-- Example 20744
df.createOrReplaceView("db.schema.viewName")

-- Example 20745
df.createOrReplaceTempView("db.schema.viewName")

-- Example 20746
import com.snowflake.snowpark.functions_

// Set up a DataFrame to query a table.
val df = session.table("sample_product_data").filter(col("category_id") > 10)
// Retrieve the results and cache the data.
val cachedDf = df.cacheResult()
// Create a DataFrame containing a subset of the cached data.
val dfSubset = cachedDf.filter(col("category_id") === lit(20)).select(col("name"), col("category_id"))
dfSubset.show()

-- Example 20747
val dfTempTable = dfTable.cacheResult()

