-- Example 21217
val tf = session.udtf.registerTemporary(TableFunc1)
df.join(tf(Map("arg1" -> df("col1")),Seq(df("col2")), Seq(df("col1"))))

-- Example 21218
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten(parse_json(df("a")))
)

-- Example 21219
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

-- Example 21220
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunction("flatten"),
  Map("input" -> parse_json(df("a")))
)

-- Example 21221
// The following example passes the values in the column `col1` to the
// user-defined tabular function (UDTF) `udtf`, partitioning the
// data by `col2` and sorting the data by `col1`. The example returns
// a new DataFrame that joins the contents of the current DataFrame with
// the output of the UDTF.
df.join(TableFunction("udtf"), Seq(df("col1")), Seq(df("col2")), Seq(df("col1")))

-- Example 21222
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in this DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, Seq(df("a"), lit(",")))

-- Example 21223
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in the current DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, df("a"), lit(","))

-- Example 21224
val dfJoin = df1.join(df2, df1("a") === df2("b"), "left")
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"), "outer")
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"), "outer")
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 21225
val dfJoined = df.join(df, df("a") === df("b"), joinType) // Column references are ambiguous

-- Example 21226
val clonedDf = df.clone
val dfJoined = df.join(clonedDf, df("a") === clonedDf("b"), joinType)

-- Example 21227
val dfJoin = df1.join(df2, df1("a") === df2("b"))
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"))
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"))
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 21228
val dfJoined = df.join(df, df("a") === df("b")) // Column references are ambiguous

-- Example 21229
val dfLeftJoin = df1.join(df2, Seq("a"), "left")
val dfOuterJoin = df1.join(df2, Seq("a", "b"), "outer")

-- Example 21230
val dfJoinOnColA = df.join(df2, Seq("a"))
val dfJoinOnColAAndColB = df.join(df2, Seq("a", "b"))

-- Example 21231
val result = left.join(right, "a")

-- Example 21232
val result = left.join(right)
val project = result.select(left("common_col") + right("common_col"))

-- Example 21233
target.merge(source, target("id") === source("id"))

-- Example 21234
val dfNaturalJoin = df.naturalJoin(df2, "left")

-- Example 21235
val dfNaturalJoin = df.naturalJoin(df2)

-- Example 21236
val dfNaturalJoin = df.naturalJoin(df2, "inner")

-- Example 21237
val dfPivoted = df.pivot(col("col_1"), Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 21238
val dfPivoted = df.pivot("col_1", Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 21239
val df = session.sql("select 1 as A, 2 as B")
val dfRenamed = df.rename("NEW_A", col("A"))

-- Example 21240
val dfSelected = df.select(Array("col1", "col2"))

-- Example 21241
val dfSelected = df.select(Seq("col1", "col2", "col3"))

-- Example 21242
val dfSelected = df.select("col1", "col2", "col3")

-- Example 21243
val dfSelected =
  df.select(Array(df.col("col1"), lit("abc"), df.col("col1") + df.col("col2")))

-- Example 21244
val dfSelected = df.select(Seq($"col1", substring($"col2", 0, 10), df("col3") + df("col4")))

-- Example 21245
val dfSelected = df.select($"col1", substring($"col2", 0, 10), df("col3") + df("col4"))

-- Example 21246
val dfSorted = df.sort(Array(col("col1").asc, col("col2").desc, col("col3")))

-- Example 21247
val dfSorted = df.sort(Seq($"colA", $"colB".desc))

-- Example 21248
val dfSorted = df.sort($"colA", $"colB".asc)

-- Example 21249
val df = session.createDataFrame(Seq((1, "a"))).toDF(Array("a", "b"))

-- Example 21250
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21251
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Array("a", "b"))

-- Example 21252
var df = session.createDataFrame(Seq((1, 2), (3, 4))).toDF(Seq("a", "b"))

-- Example 21253
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21254
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 21255
var df = session.createDataFrame(Seq((1, "a")).toDF(Seq("a", "b"))

-- Example 21256
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 21257
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 21258
val df1and2 = df1.union(df2)

-- Example 21259
val df1and2 = df1.unionAll(df2)

-- Example 21260
val df1and2 = df1.unionAllByName(df2)

-- Example 21261
val df1and2 = df1.unionByName(df2)

-- Example 21262
t1.update(Map("b" -> lit(0)), t1("a") === t2("a"), t2)

-- Example 21263
t1.update(Map(col("b") -> lit(0)), t1("a") === t2("a"), t2)

-- Example 21264
updatable.update(Map("b" -> lit(0)), col("a") === 1)

-- Example 21265
updatable.update(Map(col("b") -> lit(0)), col("a") === 1)

-- Example 21266
updatable.update(Map("b" -> lit(0)))

-- Example 21267
updatable.update(Map("c" -> (col("a") + col("b"))))

-- Example 21268
updatable.update(Map(col("b") -> lit(0)))

-- Example 21269
updatable.update(Map(col("c") -> (col("a") + col("b"))))

-- Example 21270
// The following two result in the same SQL query:
pricesDF.filter($"price" > 100)
pricesDF.where($"price" > 100)

-- Example 21271
val dfWithMeanPriceCol = df.withColumn("mean_price", mean($"price"))

-- Example 21272
val dfWithAddedColumns = df.withColumn(
    Seq("mean_price", "avg_price"), Seq(mean($"price"), avg($"price") )

-- Example 21273
df.write.saveAsTable("table1")

-- Example 21274
import com.snowflake.snowpark.functions._
val myUdf = udf((x: Int, y: String) => y + x)
df.select(myUdf(col("i"), col("s")))

-- Example 21275
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

-- Example 21276
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

-- Example 21277
val repeat = functions.builtin("repeat")
df.select(repeat(col("col_1"), 3))

-- Example 21278
val df = session.createDataFrame(Seq((1, 2, 3), (4, 5, 6))).toDF("id")
  df.select(array(col("a"), col("b")).as("id")).show()

 --------
|"ID"  |
--------
|[     |
|  1,  |
|  2   |
|]     |
|[     |
|  4,  |
|  5   |
|]     |
--------

-- Example 21279
val df = session.createDataFrame(Seq(3, 2, 1)).toDF("id")
  df.sort(asc("id")).show()

--------
|"ID"  |
--------
|1     |
|2     |
|3     |
--------

-- Example 21280
val df = session.createDataFrame(Seq("test")).toDF("a")
 df.select(base64(col("a")).as("base64")).show()
------------
|"BASE64"  |
------------
|dGVzdA==  |
------------

-- Example 21281
import functions._
val df1 = session.sql("select * from values(1,1,1),(2,2,3) as T(c1,c2,c3)")
val df2 = session.sql("select * from values(2) as T(a)")
df1.select(Column("c1"), col(df2)).show()
df1.filter(Column("c1") < col(df2)).show()

-- Example 21282
timestamp.select(convert_timezone(lit("America/New_York"), col("time")))

-- Example 21283
timestampNTZ.select(convert_timezone(lit("America/Los_Angeles"), lit("America/New_York"), col("time")))

