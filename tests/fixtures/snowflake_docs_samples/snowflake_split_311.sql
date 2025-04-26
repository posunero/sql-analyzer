-- Example 20815
val dfJoined =
  dfLhs.join(dfRhs, dfLhs.col("id_a") === dfRhs.col("id_a"))
dfJoined.show()

-- Example 20816
SELECT * FROM sample_a NATURAL JOIN sample_b;

-- Example 20817
val dfJoined = dfLhs.naturalJoin(dfRhs)
dfJoined.show()

-- Example 20818
SELECT src:salesperson.name FROM car_sales;

-- Example 20819
dfJsonField =
  df.select(col("src")("salesperson")("name"))
dfJsonField.show()

-- Example 20820
SELECT category_id, count(*)
  FROM sample_product_data GROUP BY category_id;

-- Example 20821
val dfCountPerCategory = df.groupBy(col("category")).count()
dfCountPerCategory.show()

-- Example 20822
SELECT category_id, price_date, SUM(amount) OVER
  (PARTITION BY category_id ORDER BY price_date)
  FROM prices ORDER BY price_date;

-- Example 20823
val window = Window.partitionBy(
  col("category")).orderBy(col("price_date"))
val dfCumulativePrices = dfPrices.select(
  col("category"), col("price_date"),
  sum(col("amount")).over(window)).sort(col("price_date"))
dfCumulativePrices.show()

-- Example 20824
UPDATE sample_product_data
  SET serial_number = 'xyz' WHERE id = 12;

-- Example 20825
val updateResult =
  updatableDf.update(
    Map("serial_number" -> lit("xyz")),
    col("id") === 12)

-- Example 20826
DELETE FROM sample_product_data
  WHERE category_id = 50;

-- Example 20827
val deleteResult =
  updatableDf.delete(updatableDf("category_id") === 50)

-- Example 20828
MERGE  INTO target_table USING source_table
  ON target_table.id = source_table.id
  WHEN MATCHED THEN
    UPDATE SET target_table.description =
      source_table.description;

-- Example 20829
val mergeResult =
   target.merge(source, target("id") === source("id"))
  .whenMatched.update(Map("description" -> source("description")))
  .collect()

-- Example 20830
PUT file:///tmp/*.csv @myStage OVERWRITE = TRUE;

-- Example 20831
val putOptions = Map("OVERWRITE" -> "TRUE")
val putResults = session.file.put(
  "file:///tmp/*.csv", "@myStage", putOptions)

-- Example 20832
GET @myStage file:///tmp PATTERN = '.*.csv.gz';

-- Example 20833
val getOptions = Map("PATTERN" -> s"'.*.csv.gz'")
val getResults = session.file.get(
 "@myStage", "file:///tmp", getOptions)

-- Example 20834
CREATE FILE FORMAT snowpark_temp_format TYPE = JSON;
SELECT "$1"[0]['salesperson']['name'] FROM (
  SELECT $1::VARIANT AS "$1" FROM @mystage/car_sales.json(
    FILE_FORMAT => 'snowpark_temp_format')) LIMIT 10;
DROP FILE FORMAT snowpark_temp_format;

-- Example 20835
val df = session.read.json(
  "@mystage/car_sales.json").select(
    col("$1")(0)("salesperson")("name"))
df.show();

-- Example 20836
COPY INTO new_car_sales
  FROM @mystage/car_sales.json
  FILE_FORMAT = (TYPE = JSON);

-- Example 20837
val dfCopyableDf = session.read.json("@mystage/car_sales.json")
dfCopyableDf.copyInto("new_car_sales")

-- Example 20838
COPY INTO @mystage/saved_data.json
  FROM (  SELECT  *  FROM (car_sales) )
  FILE_FORMAT = ( TYPE = JSON COMPRESSION = 'none' )
  OVERWRITE = TRUE
  DETAILED_OUTPUT = TRUE

-- Example 20839
val df = session.table("car_sales")
val writeFileResult = df.write.mode(
  SaveMode.Overwrite).option(
  "DETAILED_OUTPUT", "TRUE").option(
  "compression", "none").json(
  "@mystage/saved_data.json")

-- Example 20840
CREATE FUNCTION <temp_function_name>
  RETURNS INT
  LANGUAGE JAVA
  ...
  AS
  ...;

SELECT ...,
  <temp_function_name>(amount) AS doublenum
  FROM sample_product_data;

-- Example 20841
val doubleUdf = udf((x: Int) => x + x)
val dfWithDoubleNum = df.withColumn(
 "doubleNum", doubleUdf(col("amount")))
dfWithDoubleNum.show()

-- Example 20842
CREATE FUNCTION <temp_function_name>
  RETURNS INT
  LANGUAGE JAVA
  ...
  AS
  ...;

SELECT ...,
  <temp_function_name>(amount) AS doublenum
  FROM sample_product_data;

-- Example 20843
session.udf.registerTemporary(
  "doubleUdf", (x: Int) => x + x)
val dfWithDoubleNum = df.withColumn(
 "doubleNum", callUDF("doubleUdf", (col("amount"))))
dfWithDoubleNum.show()

-- Example 20844
CREATE FUNCTION doubleUdf(arg1 INT)
  RETURNS INT
  LANGUAGE JAVA
  ...
  AS
  ...;

SELECT ...,
  doubleUdf(amount) AS doublenum
  FROM sample_product_data;

-- Example 20845
session.udf.registerPermanent(
  "doubleUdf", (x: Int) => x + x, "mystage")
val dfWithDoubleNum = df.withColumn(
 "doubleNum", callUDF("doubleUdf", (col("amount"))))
dfWithDoubleNum.show()

-- Example 20846
CREATE PROCEDURE <temp_procedure_name>(x INTEGER, y INTEGER)
  RETURNS INTEGER
  LANGUAGE JAVA
  ...
  AS
  $$
  BEGIN
   RETURN x + y;
  END
  $$
  ;

CALL <temp_procedure_name>(2, 3);

-- Example 20847
StoredProcedure sp =
  session.sproc().registerTemporary((Session session, Integer x, Integer y) -> x + y,
    new DataType[] {DataTypes.IntegerType, DataTypes.IntegerType},
    DataTypes.IntegerType);

  session.storedProcedure(sp, 2, 3).show();

-- Example 20848
CREATE PROCEDURE sproc(x INTEGER, y INTEGER)
  RETURNS INTEGER
  LANGUAGE JAVA
  ...
  AS
  $$
  BEGIN
   RETURN x + y;
  END
  $$
  ;

CALL sproc(2, 3);

-- Example 20849
String name = "sproc";
StoredProcedure sp =
  session.sproc().registerTemporary(name,
    (Session session, Integer x, Integer y) -> x + y,
    new DataType[] {DataTypes.IntegerType, DataTypes.IntegerType},
    DataTypes.IntegerType);

  session.storedProcedure(name, 2, 3).show();

-- Example 20850
CREATE PROCEDURE add_hundred(x INTEGER)
  RETURNS INTEGER
  LANGUAGE JAVA
  ...
  AS
  $$
  BEGIN
   RETURN x + 100;
  END
  $$
  ;

CALL add_hundred(3);

-- Example 20851
val name: String = "add_hundred"
val stageName: String = "sproc_libs"

val sp: StoredProcedure =
  session.sproc.registerPermanent(
    name,
    (session: Session, x: Int) => x + 100,
    stageName,
    true
  )

session.storedProcedure(name, 3).show

-- Example 20852
val asyncJob = session.createAsyncJob(<query_id>)
println(s"Is query ${asyncJob.getQueryId()} running? ${asyncJob.isRunning()}")
val rows = asyncJob.getRows()

-- Example 20853
session.createAsyncJob(<query_id>).cancel()

-- Example 20854
import com.snowflake.snowpark.functions._
df.select(
  when(col("col").is_null, lit(1))
    .when(col("col") === 1, lit(2))
    .otherwise(lit(3))
)

-- Example 20855
lhs.filter(col("a") === 10).join(rhs, rhs("id") === lhs("id"))

-- Example 20856
import com.snowflake.snowpark.functions.col
df.select(col("src")(1)(0)("name")(0))

-- Example 20857
import com.snowflake.snowpark.functions.col
df.select(col("src")("salesperson")("emails")(0))

-- Example 20858
val df1 = session.table(table1)
val df2 = session.table(table2)
df2.filter(col("a").in(df1))

-- Example 20859
df.filter(df("a").in(Seq(1, 2, 3)))

-- Example 20860
import com.snowflake.snowpark.functions._
import session.implicits._
// Create a DataFrame from a sequence.
val df = Seq((3, "v1"), (1, "v3"), (2, "v2")).toDF("a", "b")
// Create a DataFrame containing the values in "a" sorted by "b".
df.select(array_agg(col("a")).withinGroup(Seq(col("b"))))
// Create a DataFrame containing the values in "a" grouped by "b"
// and sorted by "a" in descending order.
df.select(
  array_agg(Seq(col("a")))
  .withinGroup(col("a").desc)
  .over(Window.partitionBy(col("b")))
)

-- Example 20861
import com.snowflake.snowpark.functions._
import session.implicits._
// Create a DataFrame from a sequence.
val df = Seq((3, "v1"), (1, "v3"), (2, "v2")).toDF("a", "b")
// Create a DataFrame containing the values in "a" sorted by "b".
val dfArrayAgg = df.select(array_agg(col("a")).withinGroup(col("b")))
// Create a DataFrame containing the values in "a" grouped by "b"
// and sorted by "a" in descending order.
var dfArrayAggWindow = df.select(
  array_agg(col("a"))
  .withinGroup(col("a").desc)
  .over(Window.partitionBy(col("b")))
)

-- Example 20862
import com.snowflake.snowpark.functions.col
df.select(col("name"))
df.select(df.col("name"))
dfLeft.select(dfRight, dfLeft("name") === dfRight("name"))

-- Example 20863
df
 .filter(col("id") === 20)
 .filter((col("a") + col("b")) < 10)
 .select((col("b") * 10) as "c")

-- Example 20864
lhs.filter(col("a") === 10).join(rhs, rhs("id") === lhs("id"))

-- Example 20865
import com.snowflake.snowpark.functions.col
df.select(col("src")(1)(0)("name")(0))

-- Example 20866
import com.snowflake.snowpark.functions.col
df.select(col("src")("salesperson")("emails")(0))

-- Example 20867
val df1 = session.table(table1)
val df2 = session.table(table2)
df2.filter(col("a").in(df1))

-- Example 20868
df.filter(df("a").in(Seq(1, 2, 3)))

-- Example 20869
import com.snowflake.snowpark.functions._
import session.implicits._
// Create a DataFrame from a sequence.
val df = Seq((3, "v1"), (1, "v3"), (2, "v2")).toDF("a", "b")
// Create a DataFrame containing the values in "a" sorted by "b".
df.select(array_agg(col("a")).withinGroup(Seq(col("b"))))
// Create a DataFrame containing the values in "a" grouped by "b"
// and sorted by "a" in descending order.
df.select(
  array_agg(Seq(col("a")))
  .withinGroup(col("a").desc)
  .over(Window.partitionBy(col("b")))
)

-- Example 20870
import com.snowflake.snowpark.functions._
import session.implicits._
// Create a DataFrame from a sequence.
val df = Seq((3, "v1"), (1, "v3"), (2, "v2")).toDF("a", "b")
// Create a DataFrame containing the values in "a" sorted by "b".
val dfArrayAgg = df.select(array_agg(col("a")).withinGroup(col("b")))
// Create a DataFrame containing the values in "a" grouped by "b"
// and sorted by "a" in descending order.
var dfArrayAggWindow = df.select(
  array_agg(col("a"))
  .withinGroup(col("a").desc)
  .over(Window.partitionBy(col("b")))
)

-- Example 20871
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Array(max($"num_sales"), mean($"price")))

-- Example 20872
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(Seq(max($"num_sales"), mean($"price")))

-- Example 20873
import com.snowflake.snowpark.functions._

val dfAgg = df.agg(max($"num_sales"), mean($"price"))

-- Example 20874
val dfAgg = df.agg(Seq("num_sales" -> "max", "price" -> "mean"))

-- Example 20875
val dfAgg = df.groupBy().agg(Seq(df("num_sales") -> "max", df("price") -> "mean"))

-- Example 20876
val dfAgg = df.agg("num_sales" -> "max", "price" -> "mean")

-- Example 20877
val dfAgg = df.groupBy().agg(df("num_sales") -> "max", df("price") -> "mean")

-- Example 20878
val df2 = df.alias("A")
df2.select(df2.col("A.num"))

-- Example 20879
val asyncJob = session.read.schema(userSchema).csv(testFileOnStage).async.collect()
// At this point, the thread is not blocked. You can perform additional work before
// calling asyncJob.getResult() to retrieve the results of the action.
// NOTE: getResult() is a blocking call.
asyncJob.getResult()

-- Example 20880
import com.snowflake.snowpark.functions._
val df = session.read.schema(userSchema).option("skip_header", 1).csv(myFileStage)
val transformations = Seq(col("$1"), length(col("$1")))
val targetColumnNames = Seq("A", "A_LEN")
val extraOptions = Map("FORCE" -> "true", "skip_header" -> 2)
df.copyInto("T", targetColumnNames, transformations, extraOptions)

-- Example 20881
import com.snowflake.snowpark.functions._
val df = session.read.schema(userSchema).option("skip_header", 1).csv(myFileStage)
val transformations = Seq(col("$1"), length(col("$1")))
val extraOptions = Map("FORCE" -> "true", "skip_header" -> 2)
df.copyInto("T", transformations, extraOptions)

