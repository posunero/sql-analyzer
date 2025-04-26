-- Example 21150
df.groupBy(col("a")).builtin("max")(col("b"))

-- Example 21151
val row = Row(1, "Alice", 95.5)
row.getAs[Int](0) // Returns 1 as an Int
row.getAs[String](1) // Returns "Alice" as a String
row.getAs[Double](2) // Returns 95.5 as a Double

-- Example 21152
val schema =
      StructType(Seq(StructField("name", StringType), StructField("value", IntegerType)))
val data = Seq(Row("Alice", 1))
val df = session.createDataFrame(data, schema)
val row = df.collect()(0)

row.getAs[String]("name") // Returns "Alice" as a String
row.getAs[Int]("value") // Returns 1 as an Int

-- Example 21153
val sp = session.sproc.registerTemporary((session: Session, num: Int) => s"num: $num")
session.storedProcedure(sp, 123)

-- Example 21154
val name = "sproc"
val sp = session.sproc.registerTemporary(name,
  (session: Session, num: Int) => s"num: $num")
session.storedProcedure(sp, 123)
session.storedProcedure(name, 123)

-- Example 21155
val name = "sproc"
val stageName = "<a user stage name>"
val sp = session.sproc.registerPermanent(name,
  (session: Session, num: Int) => s"num: $num",
  stageName,
  isCallerMode = true)
session.storedProcedure(sp, 123)
session.storedProcedure(name, 123)

-- Example 21156
// a client side Scala lambda
val func = (session: Session, num: Int) => s"num: $num"
// register a server side stored procedure
val sp = session.sproc.registerTemporary(func)
// execute the lambda function of this SP from the client side
val localResult = session.sproc.runLocally(func, 123)
// execute this SP from the server side
val resultDF = session.storedProcedure(sp, 123)

-- Example 21157
val session = Session.builder.configFile("/path/to/file.properties").create

-- Example 21158
val configMap = Map(
"URL" -> "demo.snowflakecomputing.com",
"USER" -> "testUser",
"PASSWORD" -> "******",
"ROLE" -> "myrole",
"WAREHOUSE" -> "warehouse1",
"DB" -> "db1",
"SCHEMA" -> "schema1"
)
Session.builder.configs(configMap).create

-- Example 21159
session.addDependency("@my_stage/http-commons.jar")
session.addDependency("/home/username/lib/language-detector.jar")
session.addDependency("./resource-dir/")
session.addDependency("./resource.xml")

-- Example 21160
val asyncJob = session.createAsyncJob(<query_id>)
println(s"Is query ${asyncJob.getQueryId} running? ${asyncJob.isRunning()}")
val rows = asyncJob.getRows()

-- Example 21161
import com.snowflake.snowpark.types._
...
// Create an array of Row objects containing data.
val data = Array(Row(1, "a"), Row(2, "b"))
// Define the schema for the columns in the DataFrame.
val schema = StructType(Seq(StructField("num", IntegerType),
  StructField("str", StringType)))
// Create the DataFrame.
val df = session.createDataFrame(data, schema)

-- Example 21162
import com.snowflake.snowpark.types._
...
// Create a sequence of a single Row object containing data.
val data = Seq(Row(1, "a", new Variant(1)))
// Define the schema for the columns in the DataFrame.
val schema = StructType(Seq(StructField("int", IntegerType),
  StructField("string", StringType),
  StructField("variant", VariantType)))
// Create the DataFrame.
val df = session.createDataFrame(data, schema)

-- Example 21163
val session = Session.builder.configFile(..).create
// Importing this allows you to call the toDF method on a Seq object.
import session.implicits._
// Create a DataFrame from a Seq object.
val df = Seq((1, "x"), (2, "y"), (3, "z")).toDF("numCol", "varcharCol")
df.show()

-- Example 21164
session.file.put("file:///tmp/file1.csv", "@myStage/prefix1")
session.file.get("@myStage/prefix1", "file:///tmp")

-- Example 21165
import com.snowflake.snowpark.functions._
val df = session.flatten(parse_json(lit("""{"a":[1,2]}""")), "a", false, false, "BOTH")

-- Example 21166
import com.snowflake.snowpark.functions._
val df = session.flatten(parse_json(lit("""{"a":[1,2]}""")))

-- Example 21167
import com.snowflake.snowpark.functions._
session.generator(10, seq4(), uniform(lit(1), lit(5), random())).show()

-- Example 21168
import com.snowflake.snowpark.functions._
session.generator(10, Seq(seq4(), uniform(lit(1), lit(5), random()))).show()

-- Example 21169
session.sql("use database newDB").collect()

-- Example 21170
session.sql("use schema newSchema").collect()

-- Example 21171
val sp = session.sproc.registerTemporary((session: Session, num: Int) => num * 2)
session.storedProcedure(sp, 100).show()

-- Example 21172
val sp = session.sproc.register(...)
session.storedProcedure(
  sp, "arg1", "arg2"
).show()

-- Example 21173
session.storedProcedure(
  "sp_name", "arg1", "arg2"
).show()

-- Example 21174
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

session.tableFunction(
  flatten(parse_json(lit("[1,2]")))
)

-- Example 21175
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

session.tableFunction(
  flatten,
  Map("input" -> parse_json(lit("[1,2]")))
)
// Since 1.8.0, DataFrame columns are accepted as table function arguments:
df = Seq("[1,2]").toDF("a")
session.tableFunction((
  flatten,
  Map("input" -> parse_json(df("a")))
)

-- Example 21176
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

session.tableFunction(
  split_to_table,
  Seq(lit("split by space"), lit(" "))
)
// Since 1.8.0, DataFrame columns are accepted as table function arguments:
df = Seq(Seq("split by space", " ")).toDF(Seq("a", "b"))
session.tableFunction((
  split_to_table,
  Seq(df("a"), df("b"))
)

-- Example 21177
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

session.tableFunction(
  split_to_table,
  lit("split by space"),
  lit(" ")
)

-- Example 21178
session.udf.registerTemporary("mydoubleudf", (x: Int) => 2 * x)
session.sql(s"SELECT mydoubleudf(c) FROM table")

-- Example 21179
class MyWordSplitter extends UDTF1[String] {
  override def process(input: String): Iterable[Row] = input.split(" ").map(Row(_))
  override def endPartition(): Iterable[Row] = Array.empty[Row]
  override def outputSchema(): StructType = StructType(StructField("word", StringType))
}
val tableFunction = session.udtf.registerTemporary(new MyWordSplitter)
session.tableFunction(tableFunction, lit("My name is Snow Park")).show()

-- Example 21180
session.setQueryTag("""{"key1":"value1"}""")
session.updateQueryTag("""{"key2":"value2"}""")
print(session.getQueryTag().get)
{"key1":"value1","key2":"value2"}

-- Example 21181
session.sql("""ALTER SESSION SET QUERY_TAG = '{"key1":"value1"}'""").collect()
session.updateQueryTag("""{"key2":"value2"}""")
print(session.getQueryTag().get)
{"key1":"value1","key2":"value2"}

-- Example 21182
session.setQueryTag("")
session.updateQueryTag("""{"key1":"value1"}""")
print(session.getQueryTag().get)
{"key1":"value1"}

-- Example 21183
val session = Session.builder.configFile(..).create
import session.implicits._

-- Example 21184
// Create a DataFrame from a local sequence of integers.
val df = (1 to 10).toDF("a")
val df = Seq((1, "one"), (2, "two")).toDF("a", "b")

-- Example 21185
// Refer to a column in a DataFrame by using $"colName".
val df = session.table("T").filter($"a" > 1)
// Refer to columns by using 'colName.
val df = session.table("T").filter('a > 1)

-- Example 21186
val sp = session.sproc.registerTemporary(
  (session: Session, num: Int) => {
    val result = session.sql(s"select $num").collect().head.getInt(0)
    result + 100
  })
session.storedProcedure(sp, 123).show()

-- Example 21187
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.TableFunction

session.tableFunction(
  TableFunction("flatten"),
  Map("input" -> parse_json(lit("[1,2]")))
)

df.join(TableFunction("split_to_table"), df("a"), lit(","))

-- Example 21188
val asyncJob1 = df.async.collect()
val asyncJob2 = df.async.toLocalIterator()
val asyncJob3 = df.async.count()

-- Example 21189
val df = session.table("t1")
val asyncJob = df.async.collect()
println(s"Is query ${asyncJob.getQueryId()} running? ${asyncJob.isRunning()}")
val rowResult = asyncJob.getResult()

-- Example 21190
val asyncJob = df.async.count()
val longResult = asyncJob.getResult()

-- Example 21191
session.udf.registerTemporary("mydoubleudf", (x: Int) => x * x)
session.sql(s"SELECT mydoubleudf(c) from T)

-- Example 21192
session.udf.registerPermanent("mydoubleudf", (x: Int) => x * x, "mystage")
session.sql(s"SELECT mydoubleudf(c) from T)

-- Example 21193
val myUdf = session.udf.registerTemporary("mydoubleudf", (x: Int) => x * x)
session.table("T").select(myUdf(col("c")))

-- Example 21194
class MyRangeUdtf extends UDTF2[Int, Int] {
    override def process(start: Int, count: Int): Iterable[Row] =
        (start until (start + count)).map(Row(_))
    override def endPartition(): Iterable[Row] = Array.empty[Row]
    override def outputSchema(): StructType = StructType(StructField("C1", IntegerType))
}

-- Example 21195
// Use the MyRangeUdtf defined in previous example.
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 21196
val tableFunction = session.udtf.registerPermanent("myUdtf", new MyRangeUdtf(), "@myStage")
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 21197
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 21198
val dfPrices = session.table("itemsdb.publicschema.prices")

-- Example 21199
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Array(max($"num_sales"), mean($"price")))

-- Example 21200
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Seq(max($"num_sales"), mean($"price")))

-- Example 21201
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(max($"num_sales"), mean($"price"))

-- Example 21202
val dfAgg = df.agg(Seq("num_sales" -> "max", "price" -> "mean"))

-- Example 21203
val dfAgg = df.groupBy().agg(Seq(df("num_sales") -> "max", df("price") -> "mean"))

-- Example 21204
val dfAgg = df.agg("num_sales" -> "max", "price" -> "mean")

-- Example 21205
val dfAgg = df.groupBy().agg(df("num_sales") -> "max", df("price") -> "mean")

-- Example 21206
val df2 = df.alias("A")
df2.select(df2.col("A.num"))

-- Example 21207
val updatable = session.table(tableName)
val asyncJob = updatable.async.update(Map(col("b") -> lit(0)), col("a") === 1)
// At this point, the thread is not blocked. You can perform additional work before
// calling asyncJob.getResult() to retrieve the results of the action.
// NOTE: getResult() is a blocking call.
val updateResult = asyncJob.getResult()

-- Example 21208
val dfCrossJoin = left.crossJoin(right)
val project = dfCrossJoin.select(left("common_col") + right("common_col"))

-- Example 21209
t1.delete(t1("a") === t2("a"), t2)

-- Example 21210
updatable.delete(col("a") === 1)

-- Example 21211
updatable.delete()

-- Example 21212
val df1except2 = df1.except(df2)

-- Example 21213
val dfFiltered = df.filter($"colA" > 1 && $"colB" < 100)

-- Example 21214
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"), "", outer = false,
  recursive = false, "both")
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 21215
val table1 = session.sql(
  "select parse_json(value) as value from values('[1,2]') as T(value)")
val flattened = table1.flatten(table1("value"))
flattened.select(table1("value"), flattened("value").as("newValue")).show()

-- Example 21216
val dfIntersectionOf1and2 = df1.intersect(df2)

