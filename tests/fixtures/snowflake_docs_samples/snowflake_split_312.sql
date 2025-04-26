-- Example 20882
import com.snowflake.snowpark.functions._
val df = session.read.schema(userSchema).csv(myFileStage)
val transformations = Seq(col("$1"), length(col("$1")))
df.copyInto("T", transformations)

-- Example 20883
val df = session.read.schema(userSchema).csv(myFileStage)
df.copyInto("T")

-- Example 20884
val dfCrossJoin = left.crossJoin(right)
val project = dfCrossJoin.select(left("common_col") + right("common_col"))

-- Example 20885
val df1except2 = df1.except(df2)

-- Example 20886
val dfFiltered = df.filter($"colA" > 1 && $"colB" < 100)

-- Example 20887
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"), "", outer = false,
  recursive = false, "both")
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 20888
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"))
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 20889
val dfIntersectionOf1and2 = df1.intersect(df2)

-- Example 20890
val tf = session.udtf.registerTemporary(TableFunc1)
df.join(tf(Map("arg1" -> df("col1")),Seq(df("col2")), Seq(df("col1"))))

-- Example 20891
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten(parse_json(df("a")))
)

-- Example 20892
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

-- Example 20893
// The following example uses the flatten function to explode compound values from
// column 'a' in this DataFrame into multiple columns.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunction("flatten"),
  Map("input" -> parse_json(df("a")))
)

-- Example 20894
// The following example passes the values in the column `col1` to the
// user-defined tabular function (UDTF) `udtf`, partitioning the
// data by `col2` and sorting the data by `col1`. The example returns
// a new DataFrame that joins the contents of the current DataFrame with
// the output of the UDTF.
df.join(TableFunction("udtf"), Seq(df("col1")), Seq(df("col2")), Seq(df("col1")))

-- Example 20895
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in this DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, Seq(df("a"), lit(",")))

-- Example 20896
// The following example uses the split_to_table function to split
// column 'a' in this DataFrame on the character ','.
// Each row in the current DataFrame will produce N rows in the resulting DataFrame,
// where N is the number of tokens in the column 'a'.

import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(split_to_table, df("a"), lit(","))

-- Example 20897
val dfJoin = df1.join(df2, df1("a") === df2("b"), "left")
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"), "outer")
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"), "outer")
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 20898
val dfJoined = df.join(df, df("a") === df("b"), joinType) // Column references are ambiguous

-- Example 20899
val clonedDf = df.clone
val dfJoined = df.join(clonedDf, df("a") === clonedDf("b"), joinType)

-- Example 20900
val dfJoin = df1.join(df2, df1("a") === df2("b"))
val dfJoin2 = df1.join(df2, df1("a") === df2("b") && df1("c" === df2("d"))
val dfJoin3 = df1.join(df2, df1("a") === df2("a") && df1("b" === df2("b"))
// If both df1 and df2 contain column 'c'
val project = dfJoin3.select(df1("c") + df2("c"))

-- Example 20901
val dfJoined = df.join(df, df("a") === df("b")) // Column references are ambiguous

-- Example 20902
val dfLeftJoin = df1.join(df2, Seq("a"), "left")
val dfOuterJoin = df1.join(df2, Seq("a", "b"), "outer")

-- Example 20903
val dfJoinOnColA = df.join(df2, Seq("a"))
val dfJoinOnColAAndColB = df.join(df2, Seq("a", "b"))

-- Example 20904
val result = left.join(right, "a")

-- Example 20905
val result = left.join(right)
val project = result.select(left("common_col") + right("common_col"))

-- Example 20906
val dfNaturalJoin = df.naturalJoin(df2, "left")

-- Example 20907
val dfNaturalJoin = df.naturalJoin(df2)

-- Example 20908
val dfNaturalJoin = df.naturalJoin(df2, "inner")

-- Example 20909
val dfPivoted = df.pivot(col("col_1"), Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 20910
val dfPivoted = df.pivot("col_1", Seq(1,2,3)).agg(sum(col("col_2")))

-- Example 20911
val df = session.sql("select 1 as A, 2 as B")
val dfRenamed = df.rename("NEW_A", col("A"))

-- Example 20912
val dfSelected = df.select(Array("col1", "col2"))

-- Example 20913
val dfSelected = df.select(Seq("col1", "col2", "col3"))

-- Example 20914
val dfSelected = df.select("col1", "col2", "col3")

-- Example 20915
val dfSelected =
  df.select(Array(df.col("col1"), lit("abc"), df.col("col1") + df.col("col2")))

-- Example 20916
val dfSelected = df.select(Seq($"col1", substring($"col2", 0, 10), df("col3") + df("col4")))

-- Example 20917
val dfSelected = df.select($"col1", substring($"col2", 0, 10), df("col3") + df("col4"))

-- Example 20918
val dfSorted = df.sort(Array(col("col1").asc, col("col2").desc, col("col3")))

-- Example 20919
val dfSorted = df.sort(Seq($"colA", $"colB".desc))

-- Example 20920
val dfSorted = df.sort($"colA", $"colB".asc)

-- Example 20921
val df = session.createDataFrame(Seq((1, "a"))).toDF(Array("a", "b"))

-- Example 20922
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 20923
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Array("a", "b"))

-- Example 20924
var df = session.createDataFrame(Seq((1, 2), (3, 4))).toDF(Seq("a", "b"))

-- Example 20925
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 20926
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 20927
var df = session.createDataFrame(Seq((1, "a")).toDF(Seq("a", "b"))

-- Example 20928
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

-- Example 20929
import mysession.implicits_
var df = Seq((1, 2), (3, 4)).toDF(Seq("a", "b"))

-- Example 20930
val df1and2 = df1.union(df2)

-- Example 20931
val df1and2 = df1.unionAll(df2)

-- Example 20932
val df1and2 = df1.unionAllByName(df2)

-- Example 20933
val df1and2 = df1.unionByName(df2)

-- Example 20934
// The following two result in the same SQL query:
pricesDF.filter($"price" > 100)
pricesDF.where($"price" > 100)

-- Example 20935
val dfWithMeanPriceCol = df.withColumn("mean_price", mean($"price"))

-- Example 20936
val dfWithAddedColumns = df.withColumn(
    Seq("mean_price", "avg_price"), Seq(mean($"price"), avg($"price") )

-- Example 20937
df.write.saveAsTable("table1")

-- Example 20938
val dfPrices = session.table("itemsdb.publicschema.prices")

-- Example 20939
val dfCatalog = session.read.csv("@stage/some_dir")

-- Example 20940
val df = session.createDataFrame(Seq((1, "one"), (2, "two")))

-- Example 20941
val df = session.range(1, 10, 2)

-- Example 20942
val dfMergedData = dfCatalog.join(dfPrices, dfCatalog("itemId") === dfPrices("ID"))

-- Example 20943
// Return a new DataFrame containing the ID and amount columns of the prices table. This is
// equivalent to:
//   SELECT ID, AMOUNT FROM PRICES;
val dfPriceIdsAndAmounts = dfPrices.select(col("ID"), col("amount"))

-- Example 20944
// Return a new DataFrame containing the ID column of the prices table as a column named
// itemId. This is equivalent to:
//   SELECT ID AS itemId FROM PRICES;
val dfPriceItemIds = dfPrices.select(col("ID").as("itemId"))

-- Example 20945
// Return a new DataFrame containing the row from the prices table with the ID 1. This is
// equivalent to:
//   SELECT * FROM PRICES WHERE ID = 1;
val dfPrice1 = dfPrices.filter((col("ID") === 1))

-- Example 20946
// Return a new DataFrame for the prices table with the rows sorted by ID. This is equivalent
// to:
//   SELECT * FROM PRICES ORDER BY ID;
val dfSortedPrices = dfPrices.sort(col("ID"))

-- Example 20947
// Return a new DataFrame for the prices table that computes the sum of the prices by
// category. This is equivalent to:
//   SELECT CATEGORY, SUM(AMOUNT) FROM PRICES GROUP BY CATEGORY;
val dfTotalPricePerCategory = dfPrices.groupBy(col("category")).sum(col("amount"))

-- Example 20948
// Define a window that partitions prices by category and sorts the prices by date within the
// partition.
val window = Window.partitionBy(col("category")).orderBy(col("price_date"))
// Calculate the running sum of prices over this window. This is equivalent to:
//   SELECT CATEGORY, PRICE_DATE, SUM(AMOUNT) OVER
//       (PARTITION BY CATEGORY ORDER BY PRICE_DATE)
//       FROM PRICES ORDER BY PRICE_DATE;
val dfCumulativePrices = dfPrices.select(
    col("category"), col("price_date"),
    sum(col("amount")).over(window)).sort(col("price_date"))

