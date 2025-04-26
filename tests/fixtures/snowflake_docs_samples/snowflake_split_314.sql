-- Example 21016
import com.snowflake.snowpark.types._
// Define the schema for the data in the CSV files.
val userSchema: StructType = StructType(Seq(StructField("a", IntegerType),StructField("b", StringType)))
// Create a DataFrame that is configured to load data from the CSV files in the stage.
val csvDF = session.read.option("pattern", ".*[.]csv").schema(userSchema).csv("@stage_location")
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = csvDF.collect()

-- Example 21017
val filePath = "@mystage1"
// Create a DataFrame that is configured to load data from the JSON file.
val jsonDF = session.read.json(filePath)
// Load the data into the specified table `T1`.
// The table "T1" should exist before calling copyInto().
jsonDF.copyInto("T1")

-- Example 21018
session.read.avro(path).where(col("$1:num") > 1)

-- Example 21019
// The table "T1" should exist before calling copyInto().
session.read.avro(path).copyInto("T1")

-- Example 21020
val filePath = "@mystage1/myfile.csv"
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.schema(userSchema).csv(fileInAStage).filter(col("a") < 2)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21021
// The table "T1" should exist before calling copyInto().
session.read.schema(userSchema).csv(path).copyInto("T1")

-- Example 21022
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.json(path).where(col("$1:num") > 1)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21023
// The table "T1" should exist before calling copyInto().
session.read.json(path).copyInto("T1")

-- Example 21024
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.option("compression", "lzo").parquet(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21025
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.option("compression", "none").json(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21026
import com.snowflake.snowpark.types._
// Define the schema for the data in the CSV files.
val userSchema = StructType(Seq(StructField("a", IntegerType), StructField("b", StringType)))
// Create a DataFrame that is configured to load data from the CSV file.
val csvDF = session.read.option("field_delimiter", ":").option("skip_header", 1).schema(userSchema).csv(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = csvDF.collect()

-- Example 21027
import com.snowflake.snowpark.types._
// Define the schema for the data in the CSV files.
val userSchema: StructType = StructType(Seq(StructField("a", IntegerType),StructField("b", StringType)))
// Create a DataFrame that is configured to load data from the CSV files in the stage.
val csvDF = session.read.option("pattern", ".*[.]csv").schema(userSchema).csv("@stage_location")
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = csvDF.collect()

-- Example 21028
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.option(Map("compression"-> "lzo", "trim_space" -> true)).parquet(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21029
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.orc(path).where(col("$1:num") > 1)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21030
// The table "T1" should exist before calling copyInto().
session.read.orc(path).copyInto("T1")

-- Example 21031
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.parquet(path).where(col("$1:num") > 1)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21032
// The table "T1" should exist before calling copyInto().
session.read.parquet(path).copyInto("T1")

-- Example 21033
// Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
val df = session.read.xml(path).where(col("xmlget($1, 'num', 0):\"$\"") > 1)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = df.collect()

-- Example 21034
// The table "T1" should exist before calling copyInto().
session.read.xml(path).copyInto("T1")

-- Example 21035
import session.implicits._
val df = Seq((0.1, 0.5), (0.2, 0.6), (0.3, 0.7)).toDF("a", "b")
val res = double2.stat.approxQuantile(Array("a", "b"), Array(0, 0.1, 0.6))

-- Example 21036
res: Array(Array(Some(0.05), Some(0.15000000000000002), Some(0.25)),
           Array(Some(0.45), Some(0.55), Some(0.6499999999999999)))

-- Example 21037
import session.implicits._
val df = Seq(1, 2, 3, 4, 5, 6, 7, 8, 9, 0).toDF("a")
val res = df.stat.approxQuantile("a", Array(0, 0.1, 0.4, 0.6, 1))

-- Example 21038
res: Array(Some(-0.5), Some(0.5), Some(3.5), Some(5.5), Some(9.5))

-- Example 21039
import session.implicits._
val df = Seq((0.1, 0.5), (0.2, 0.6), (0.3, 0.7)).toDF("a", "b")
double res = df.stat.corr("a", "b").get

-- Example 21040
res: 0.9999999999999991

-- Example 21041
import session.implicits._
val df = Seq((0.1, 0.5), (0.2, 0.6), (0.3, 0.7)).toDF("a", "b")
double res = df.stat.cov("a", "b").get

-- Example 21042
res: 0.010000000000000037

-- Example 21043
import session.implicits._
val df = Seq((1, 1), (1, 2), (2, 1), (2, 1), (2, 3), (3, 2), (3, 3)).toDF("key", "value")
val ct = df.stat.crosstab("key", "value")
ct.show()

-- Example 21044
---------------------------------------------------------------------------------------------
|"KEY"  |"CAST(1 AS NUMBER(38,0))"  |"CAST(2 AS NUMBER(38,0))"  |"CAST(3 AS NUMBER(38,0))"  |
---------------------------------------------------------------------------------------------
|1      |1                          |1                          |0                          |
|2      |2                          |0                          |1                          |
|3      |0                          |1                          |1                          |
---------------------------------------------------------------------------------------------

-- Example 21045
import session.implicits._
val df = Seq(("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)).toDF("name", "age")
val fractions = Map("Bob" -> 0.5, "Nico" -> 1.0)
df.stat.sampleBy("name", fractions).show()

-- Example 21046
------------------
|"NAME"  |"AGE"  |
------------------
|Bob     |17     |
|Nico    |8      |
------------------

-- Example 21047
import session.implicits._
val df = Seq(("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)).toDF("name", "age")
val fractions = Map("Bob" -> 0.5, "Nico" -> 1.0)
df.stat.sampleBy(col("name"), fractions).show()

-- Example 21048
------------------
|"NAME"  |"AGE"  |
------------------
|Bob     |17     |
|Nico    |8      |
------------------

-- Example 21049
df.write.mode("overwrite").saveAsTable("T")

-- Example 21050
val result = df.write.csv("@myStage/prefix")

-- Example 21051
val result = df.write.option("compression", "none").csv("@myStage/prefix")

-- Example 21052
val asyncJob = df.write.mode(SaveMode.Overwrite).async.saveAsTable(tableName)
// At this point, the thread is not blocked. You can perform additional work before
// calling asyncJob.getResult() to retrieve the results of the action.
// NOTE: getResult() is a blocking call.
asyncJob.getResult()

-- Example 21053
val result = df.write.csv("@myStage/prefix")

-- Example 21054
val result = df.write.option("compression", "none").csv("@myStage/prefix")

-- Example 21055
val result = session.sql("select to_variant('a')").write.json("@myStage/prefix")

-- Example 21056
val df = Seq((1, 1.1, "a"), (2, 2.2, "b")).toDF("a", "b", "c")
val df2 = df.select(array_construct(df.schema.names.map(df(_)): _*))
val result = df2.write.option("compression", "none").json("@myStage/prefix")

-- Example 21057
val df = Seq((1, 1.1, "a"), (2, 2.2, "b")).toDF("a", "b", "c")
val df2 = df.select(object_construct(df.schema.names.map(x => Seq(lit(x), df(x))).flatten: _*))
val result = df2.write.option("compression", "none").json("@myStage/prefix")

-- Example 21058
val result = df.write.csv("@myStage/prefix")

-- Example 21059
val result = df.write.option("compression", "none").csv("@myStage/prefix")

-- Example 21060
val result = df.write.csv("@myStage/prefix")

-- Example 21061
val result = df.write.option("compression", "none").csv("@myStage/prefix")

-- Example 21062
val result = df.write.parquet("@myStage/prefix")

-- Example 21063
val result = df.write.option("compression", "LZO").parquet("@myStage/prefix")

-- Example 21064
val list = new java.util.ArrayList[String](3)
  list.add(db)
  list.add(sc)
  list.add(tableName)
df.write.saveAsTable(list)

-- Example 21065
df.write.saveAsTable(Seq("db_name", "schema_name", "table_name"))

-- Example 21066
df.write.saveAsTable("db1.public_schema.table1")

-- Example 21067
// Upload a file to a stage.
session.file.put("file:///tmp/file1.csv", "@myStage/prefix1")
// Download a file from a stage.
session.file.get("@myStage/prefix1/file1.csv", "file:///tmp")

-- Example 21068
// Upload files to a stage.
session.file.put("file:///tmp/file_1.csv", "@myStage/prefix2")
session.file.put("file:///tmp/file_2.csv", "@myStage/prefix2")

// Download one file from a stage.
val res1 = session.file.get("@myStage/prefix2/file_1.csv", "file:///tmp/target")
// Download all the files from @myStage/prefix2.
val res2 = session.file.get("@myStage/prefix2", "file:///tmp/target2")
// Download files with names that match a regular expression pattern.
val getOptions = Map("PATTERN" -> s"'.*file_.*.csv.gz'")
val res3 = session.file.get("@myStage/prefix2", "file:///tmp/target3", getOptions)

-- Example 21069
// Upload a file to a stage without compressing the file.
val putOptions = Map("AUTO_COMPRESS" -> "FALSE")
val res1 = session.file.put("file:///tmp/file1.csv", "@myStage", putOptions)

// Upload the CSV files in /tmp with names that start with "file".
// You can use the wildcard characters "*" and "?" to match multiple files.
val res2 = session.file.put("file:///tmp/file*.csv", "@myStage/prefix2")

-- Example 21070
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Array(max($"num_sales"), mean($"price")))

-- Example 21071
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Seq(max($"num_sales"), mean($"price")))

-- Example 21072
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(max($"num_sales"), mean($"price"))

-- Example 21073
val dfAgg = df.agg(Seq("num_sales" -> "max", "price" -> "mean"))

-- Example 21074
val dfAgg = df.groupBy().agg(Seq(df("num_sales") -> "max", df("price") -> "mean"))

-- Example 21075
val dfAgg = df.agg("num_sales" -> "max", "price" -> "mean")

-- Example 21076
val dfAgg = df.groupBy().agg(df("num_sales") -> "max", df("price") -> "mean")

-- Example 21077
val df2 = df.alias("A")
df2.select(df2.col("A.num"))

-- Example 21078
val asyncJob = df.async.collect()
// At this point, the thread is not blocked. You can perform additional work before
// calling asyncJob.getResult() to retrieve the results of the action.
// NOTE: getResult() is a blocking call.
val rows = asyncJob.getResult()

-- Example 21079
val dfCrossJoin = left.crossJoin(right)
val project = dfCrossJoin.select(left("common_col") + right("common_col"))

-- Example 21080
val df1except2 = df1.except(df2)

-- Example 21081
val dfFiltered = df.filter($"colA" > 1 && $"colB" < 100)

-- Example 21082
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"), "", outer = false,
  recursive = false, "both")
flattened.select(table1("value"), flattened("value").as("newValue")).show()

