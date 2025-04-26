-- Example 20949
val results = dfPrices.collect()

-- Example 20950
dfPrices.show()

-- Example 20951
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Array(max($"num_sales"), mean($"price")))

-- Example 20952
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Seq(max($"num_sales"), mean($"price")))

-- Example 20953
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(max($"num_sales"), mean($"price"))

-- Example 20954
val dfAgg = df.agg(Seq("num_sales" -> "max", "price" -> "mean"))

-- Example 20955
val dfAgg = df.groupBy().agg(Seq(df("num_sales") -> "max", df("price") -> "mean"))

-- Example 20956
val dfAgg = df.agg("num_sales" -> "max", "price" -> "mean")

-- Example 20957
val dfAgg = df.groupBy().agg(df("num_sales") -> "max", df("price") -> "mean")

-- Example 20958
val df2 = df.alias("A")
df2.select(df2.col("A.num"))

-- Example 20959
val asyncJob = df.async.collect()
// At this point, the thread is not blocked. You can perform additional work before
// calling asyncJob.getResult() to retrieve the results of the action.
// NOTE: getResult() is a blocking call.
val rows = asyncJob.getResult()

-- Example 20960
val dfCrossJoin = left.crossJoin(right)
val project = dfCrossJoin.select(left("common_col") + right("common_col"))

-- Example 20961
val df1except2 = df1.except(df2)

-- Example 20962
val dfFiltered = df.filter($"colA" > 1 && $"colB" < 100)

-- Example 20963
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"), "", outer = false,
  recursive = false, "both")
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 20964
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"))
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 20965
val dfIntersectionOf1and2 = df1.intersect(df2)

-- Example 20966
val tf = session.udtf.registerTemporary(TableFunc1)
df.join(tf(Map("arg1" -> df("col1")),Seq(df("col2")), Seq(df("col1"))))

-- Example 20967
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten(parse_json(df("a")))
)

-- Example 20968
// The following example passes the values in the column `col1` to the
// user-defined tabular function (UDTF) `udtf`, partitioning the
// data by `col2` and sorting the data by `col1`. The example returns
// a new DataFrame that joins the contents of the current DataFrame with
// the output of the UDTF.
df.join(
  tableFunction("udtf"),
  Map("arg1" -> df("col1"),
  Seq(df("col2")), Seq(df("col1")))
)

-- Example 20969
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunction("flatten"),
  Map("input" -> parse_json(df("a")))
)

-- Example 20970
// The following example passes the values in the column `col1` to the
// user-defined tabular function (UDTF) `udtf`, partitioning the
// data by `col2` and sorting the data by `col1`. The example returns
// a new DataFrame that joins the contents of the current DataFrame with
// the output of the UDTF.
df.join(TableFunction("udtf"), Seq(df("col1")), Seq(df("col2")), Seq(df("col1")))

-- Example 20971
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in this DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, Seq(df("a"), lit(",")))

-- Example 20972
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in the current DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, df("a"), lit(","))

-- Example 20973
val dfJoin = df1.join(df2, df1("a") === df2("b"), "left")
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"), "outer")
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"), "outer")
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 20974
val dfJoined = df.join(df, df("a") === df("b"), joinType) // Column references are ambiguous

-- Example 20975
val clonedDf = df.clone
val dfJoined = df.join(clonedDf, df("a") === clonedDf("b"), joinType)

-- Example 20976
val dfJoin = df1.join(df2, df1("a") === df2("b"))
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"))
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"))
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 20977
val dfJoined = df.join(df, df("a") === df("b")) // Column references are ambiguous

-- Example 20978
val dfLeftJoin = df1.join(df2, Seq("a"), "left")
val dfOuterJoin = df1.join(df2, Seq("a", "b"), "outer")

-- Example 20979
val dfJoinOnColA = df.join(df2, Seq("a"))
val dfJoinOnColAAndColB = df.join(df2, Seq("a", "b"))

-- Example 20980
val result = left.join(right, "a")

-- Example 20981
val result = left.join(right)
val project = result.select(left("common_col") + right("common_col"))

-- Example 20982
val dfNaturalJoin = df.naturalJoin(df2, "left")

-- Example 20983
val dfNaturalJoin = df.naturalJoin(df2)

-- Example 20984
val dfNaturalJoin = df.naturalJoin(df2, "inner")

-- Example 20985
val dfPivoted = df.pivot(col("col_1"), Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 20986
val dfPivoted = df.pivot("col_1", Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 20987
val df = session.sql("select 1 as A, 2 as B")
val dfRenamed = df.rename("NEW_A", col("A"))

-- Example 20988
val dfSelected = df.select(Array("col1", "col2"))

-- Example 20989
val dfSelected = df.select(Seq("col1", "col2", "col3"))

-- Example 20990
val dfSelected = df.select("col1", "col2", "col3")

-- Example 20991
val dfSelected =
  df.select(Array(df.col("col1"), lit("abc"), df.col("col1") + df.col("col2")))

-- Example 20992
val dfSelected = df.select(Seq($"col1", substring($"col2", 0, 10), df("col3") + df("col4")))

-- Example 20993
val dfSelected = df.select($"col1", substring($"col2", 0, 10), df("col3") + df("col4"))

-- Example 20994
val dfSorted = df.sort(Array(col("col1").asc, col("col2").desc, col("col3")))

-- Example 20995
val dfSorted = df.sort(Seq($"colA", $"colB".desc))

-- Example 20996
val dfSorted = df.sort($"colA", $"colB".asc)

-- Example 20997
val df = session.createDataFrame(Seq((1, "a"))).toDF(Array("a", "b"))

-- Example 20998
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 20999
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Array("a", "b"))

-- Example 21000
var df = session.createDataFrame(Seq((1, 2), (3, 4))).toDF(Seq("a", "b"))

-- Example 21001
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21002
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 21003
var df = session.createDataFrame(Seq((1, "a")).toDF(Seq("a", "b"))

-- Example 21004
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21005
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 21006
val df1and2 = df1.union(df2)

-- Example 21007
val df1and2 = df1.unionAll(df2)

-- Example 21008
val df1and2 = df1.unionAllByName(df2)

-- Example 21009
val df1and2 = df1.unionByName(df2)

-- Example 21010
// The following two result in the same SQL query:
pricesDF.filter($"price" > 100)
pricesDF.where($"price" > 100)

-- Example 21011
val dfWithMeanPriceCol = df.withColumn("mean_price", mean($"price"))

-- Example 21012
val dfWithAddedColumns = df.withColumn(
    Seq("mean_price", "avg_price"), Seq(mean($"price"), avg($"price") )

-- Example 21013
df.write.saveAsTable("table1")

-- Example 21014
// Import the package for StructType.
import com.snowflake.snowpark.types._
val filePath = "@mystage1"
// Define the schema for the data in the CSV file.
val userSchema = StructType(Seq(StructField("a", IntegerType), StructField("b", StringType)))
// Create a DataFrame that is configured to load data from the CSV file.
val csvDF = session.read.option("skip_header", 1).schema(userSchema).csv(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = csvDF.collect()

-- Example 21015
val filePath = "@mystage2/data.json.gz"
// Create a DataFrame that is configured to load data from the gzipped JSON file.
val jsonDF = session.read.option("compression", "gzip").json(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = jsonDF.collect()

