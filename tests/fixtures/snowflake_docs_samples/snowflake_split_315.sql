-- Example 21083
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"))
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 21084
val dfIntersectionOf1and2 = df1.intersect(df2)

-- Example 21085
val tf = session.udtf.registerTemporary(TableFunc1)
df.join(tf(Map("arg1" -> df("col1")),Seq(df("col2")), Seq(df("col1"))))

-- Example 21086
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten(parse_json(df("a")))
)

-- Example 21087
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

-- Example 21088
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunction("flatten"),
  Map("input" -> parse_json(df("a")))
)

-- Example 21089
// The following example passes the values in the column `col1` to the
// user-defined tabular function (UDTF) `udtf`, partitioning the
// data by `col2` and sorting the data by `col1`. The example returns
// a new DataFrame that joins the contents of the current DataFrame with
// the output of the UDTF.
df.join(TableFunction("udtf"), Seq(df("col1")), Seq(df("col2")), Seq(df("col1")))

-- Example 21090
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in this DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, Seq(df("a"), lit(",")))

-- Example 21091
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in the current DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, df("a"), lit(","))

-- Example 21092
val dfJoin = df1.join(df2, df1("a") === df2("b"), "left")
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"), "outer")
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"), "outer")
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 21093
val dfJoined = df.join(df, df("a") === df("b"), joinType) // Column references are ambiguous

-- Example 21094
val clonedDf = df.clone
val dfJoined = df.join(clonedDf, df("a") === clonedDf("b"), joinType)

-- Example 21095
val dfJoin = df1.join(df2, df1("a") === df2("b"))
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"))
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"))
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 21096
val dfJoined = df.join(df, df("a") === df("b")) // Column references are ambiguous

-- Example 21097
val dfLeftJoin = df1.join(df2, Seq("a"), "left")
val dfOuterJoin = df1.join(df2, Seq("a", "b"), "outer")

-- Example 21098
val dfJoinOnColA = df.join(df2, Seq("a"))
val dfJoinOnColAAndColB = df.join(df2, Seq("a", "b"))

-- Example 21099
val result = left.join(right, "a")

-- Example 21100
val result = left.join(right)
val project = result.select(left("common_col") + right("common_col"))

-- Example 21101
val dfNaturalJoin = df.naturalJoin(df2, "left")

-- Example 21102
val dfNaturalJoin = df.naturalJoin(df2)

-- Example 21103
val dfNaturalJoin = df.naturalJoin(df2, "inner")

-- Example 21104
val dfPivoted = df.pivot(col("col_1"), Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 21105
val dfPivoted = df.pivot("col_1", Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 21106
val df = session.sql("select 1 as A, 2 as B")
val dfRenamed = df.rename("NEW_A", col("A"))

-- Example 21107
val dfSelected = df.select(Array("col1", "col2"))

-- Example 21108
val dfSelected = df.select(Seq("col1", "col2", "col3"))

-- Example 21109
val dfSelected = df.select("col1", "col2", "col3")

-- Example 21110
val dfSelected =
  df.select(Array(df.col("col1"), lit("abc"), df.col("col1") + df.col("col2")))

-- Example 21111
val dfSelected = df.select(Seq($"col1", substring($"col2", 0, 10), df("col3") + df("col4")))

-- Example 21112
val dfSelected = df.select($"col1", substring($"col2", 0, 10), df("col3") + df("col4"))

-- Example 21113
val dfSorted = df.sort(Array(col("col1").asc, col("col2").desc, col("col3")))

-- Example 21114
val dfSorted = df.sort(Seq($"colA", $"colB".desc))

-- Example 21115
val dfSorted = df.sort($"colA", $"colB".asc)

-- Example 21116
val df = session.createDataFrame(Seq((1, "a"))).toDF(Array("a", "b"))

-- Example 21117
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21118
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Array("a", "b"))

-- Example 21119
var df = session.createDataFrame(Seq((1, 2), (3, 4))).toDF(Seq("a", "b"))

-- Example 21120
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21121
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 21122
var df = session.createDataFrame(Seq((1, "a")).toDF(Seq("a", "b"))

-- Example 21123
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21124
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 21125
val df1and2 = df1.union(df2)

-- Example 21126
val df1and2 = df1.unionAll(df2)

-- Example 21127
val df1and2 = df1.unionAllByName(df2)

-- Example 21128
val df1and2 = df1.unionByName(df2)

-- Example 21129
// The following two result in the same SQL query:
pricesDF.filter($"price" > 100)
pricesDF.where($"price" > 100)

-- Example 21130
val dfWithMeanPriceCol = df.withColumn("mean_price", mean($"price"))

-- Example 21131
val dfWithAddedColumns = df.withColumn(
    Seq("mean_price", "avg_price"), Seq(mean($"price"), avg($"price") )

-- Example 21132
df.write.saveAsTable("table1")

-- Example 21133
target.merge(source, target("id") === source("id"))
.whenMatched.delete()

-- Example 21134
target.merge(source, target("id") === source("id"))
.whenMatched.update(Map(target("value") -> source("value")))

-- Example 21135
target.merge(source, target("id") === source("id"))
.whenMatched.update(Map("value" -> source("value")))

-- Example 21136
val target = session.table(tableName)
val source = Seq((10, "new")).toDF("id", "desc")
val asyncJob = target
  .merge(source, target("id") === source("id"))
  .whenMatched
  .update(Map(target("desc") -> source("desc")))
  .async
  .collect()
// At this point, the thread is not blocked. You can perform additional work before
// calling asyncJob.getResult() to retrieve the results of the action.
// NOTE: getResult() is a blocking call.
val mergeResult = asyncJob.getResult()

-- Example 21137
target.merge(source, target("id") === source("id")).whenMatched(target("value") === lit(0))

-- Example 21138
target.merge(source, target("id") === source("id")).whenMatched

-- Example 21139
target.merge(source, target("id") === source("id"))
.whenNotMatched(source("value") === lit(0))

-- Example 21140
target.merge(source, target("id") === source("id")).whenNotMatched

-- Example 21141
target.merge(source, target("id") === source("id"))
.whenNotMatched.insert(Map(target("id") -> source("id")))

-- Example 21142
target.merge(source, target("id") === source("id"))
.whenNotMatched.insert(Map("id" -> source("id")))

-- Example 21143
target.merge(source, target("id") === source("id"))
.whenNotMatched.insert(Seq(source("id"), source("value")))

-- Example 21144
val groupedDf: RelationalGroupedDataFrame = df.groupBy("dept")
val aggDf: DataFrame = groupedDf.agg(groupedDf("salary") -> "mean")

-- Example 21145
import com.snowflake.snowpark.functions.col
df.groupBy("itemType").agg(Map(
col("price") -> "mean",
col("sales") -> "sum"
))

-- Example 21146
impoer com.snowflake.snowpark.functions._
df.groupBy("itemType").agg(Seq(
  mean($"price"),
  sum($"sales")))

-- Example 21147
impoer com.snowflake.snowpark.functions._
df.groupBy("itemType").agg(
  mean($"price"),
  sum($"sales"))

-- Example 21148
import com.snowflake.snowpark.functions.col
df.groupBy("itemType").agg(Seq(
  col("price") -> "mean",
  col("sales") -> "sum"))

-- Example 21149
import com.snowflake.snowpark.functions.col
df.groupBy("itemType").agg(
  col("price") -> "mean",
  col("sales") -> "sum")

