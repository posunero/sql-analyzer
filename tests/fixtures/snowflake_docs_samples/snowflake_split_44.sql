-- Example 2925
HTTP/1.1 401 Unauthorized
Date: Tue, 04 May 2021 20:17:57 GMT
Content-Type: application/json
{
  "code" : "390303",
  "message" : "Invalid OAuth access token. ...TTTTTTTT"
}

-- Example 2926
HTTP/1.1 405 Method Not Allowed
Date: Tue, 04 May 2021 22:55:38 GMT
Content-Length: 0

-- Example 2927
HTTP/1.1 429 Too many requests
Content-Type: application/json
Content-Length: 69
{
  "code" : "390505",
  "message" : "Too many requests."
 }

-- Example 2928
Link: </api/v2/statements/e127cc7c-7812-4e72-9a55-3b4d4f969840?partition=1; rel="last">,
      </api/v2/statements/e127cc7c-7812-4e72-9a55-3b4d4f969840?partition=1; rel="next">,
      </api/v2/statements/e127cc7c-7812-4e72-9a55-3b4d4f969840?partition=0; rel="first">

-- Example 2929
{
  "code" : "0",
  "sqlState" : "",
  "message" : "successfully canceled",
  "statementHandle" : "536fad38-b564-4dc5-9892-a4543504df6c",
  "statementStatusUrl" : "/api/v2/statements/536fad38-b564-4dc5-9892-a4543504df6c"
}

-- Example 2930
{
  "code" : "002140",
  "sqlState" : "42601",
  "message" : "SQL compilation error",
  "statementHandle" : "e4ce975e-f7ff-4b5e-b15e-bf25f59371ae",
  "statementStatusUrl" : "/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"
}

-- Example 2931
{
  "code" : "0",
  "sqlState" : "",
  "message" : "successfully executed",
  "statementHandle" : "e4ce975e-f7ff-4b5e-b15e-bf25f59371ae",
  "statementStatusUrl" : "/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"
}

-- Example 2932
[
  ["customer1","1234 A Avenue","98765","1565481394123000000"],
  ["customer2","987 B Street","98765","1565516712912012345"],
  ["customer3","8777 C Blvd","98765","1565605431999999999"],
  ["customer4","64646 D Circle","98765","1565661272000000000"]
]

-- Example 2933
[
 {"name":"ROWNUM","type":"FIXED","length":0,"precision":38,"scale":0,"nullable":false},
 {"name":"ACCOUNT_ID","type":"FIXED","length":0,"precision":38,"scale":0,"nullable":false},
 {"name":"ACCOUNT_NAME","type":"TEXT","length":1024,"precision":0,"scale":0,"nullable":false},
 {"name":"ADDRESS","type":"TEXT","length":16777216,"precision":0,"scale":0,"nullable":true},
 {"name":"ZIP","type":"TEXT","length":100,"precision":0,"scale":0,"nullable":true},
 {"name":"CREATED_ON","type":"TIMESTAMP_NTZ","length":0,"precision":0,"scale":3,"nullable":false}
]

-- Example 2934
{
 "name":"ACCOUNT_NAME",
 "type":"TEXT",
 "length":1024,
 "precision":0,
 "scale":0,
 "nullable":false
}

-- Example 2935
val asyncJob = session.createAsyncJob(<query_id>)
println(s"Is query ${asyncJob.getQueryId()} running? ${asyncJob.isRunning()}")
val rows = asyncJob.getRows()

-- Example 2936
session.createAsyncJob(<query_id>).cancel()

-- Example 2937
import com.snowflake.snowpark.functions._
df.select(
  when(col("col").is_null, lit(1))
    .when(col("col") === 1, lit(2))
    .otherwise(lit(3))
)

-- Example 2938
import com.snowflake.snowpark.functions.col
df.select(col("name"))
df.select(df.col("name"))
dfLeft.select(dfRight, dfLeft("name") === dfRight("name"))

-- Example 2939
df
 .filter(col("id") === 20)
 .filter((col("a") + col("b")) < 10)
 .select((col("b") * 10) as "c")

-- Example 2940
val dfPrices = session.table("itemsdb.publicschema.prices")

-- Example 2941
val dfCatalog = session.read.csv("@stage/some_dir")

-- Example 2942
val df = session.createDataFrame(Seq((1, "one"), (2, "two")))

-- Example 2943
val df = session.range(1, 10, 2)

-- Example 2944
val dfMergedData = dfCatalog.join(dfPrices, dfCatalog("itemId") === dfPrices("ID"))

-- Example 2945
// Return a new DataFrame containing the ID and amount columns of the prices table. This is
// equivalent to:
//   SELECT ID, AMOUNT FROM PRICES;
val dfPriceIdsAndAmounts = dfPrices.select(col("ID"), col("amount"))

-- Example 2946
// Return a new DataFrame containing the ID column of the prices table as a column named
// itemId. This is equivalent to:
//   SELECT ID AS itemId FROM PRICES;
val dfPriceItemIds = dfPrices.select(col("ID").as("itemId"))

-- Example 2947
// Return a new DataFrame containing the row from the prices table with the ID 1. This is
// equivalent to:
//   SELECT * FROM PRICES WHERE ID = 1;
val dfPrice1 = dfPrices.filter((col("ID") === 1))

-- Example 2948
// Return a new DataFrame for the prices table with the rows sorted by ID. This is equivalent
// to:
//   SELECT * FROM PRICES ORDER BY ID;
val dfSortedPrices = dfPrices.sort(col("ID"))

-- Example 2949
// Return a new DataFrame for the prices table that computes the sum of the prices by
// category. This is equivalent to:
//   SELECT CATEGORY, SUM(AMOUNT) FROM PRICES GROUP BY CATEGORY;
val dfTotalPricePerCategory = dfPrices.groupBy(col("category")).sum(col("amount"))

-- Example 2950
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

-- Example 2951
val results = dfPrices.collect()

-- Example 2952
dfPrices.show()

-- Example 2953
// Import the package for StructType.
import com.snowflake.snowpark.types._
val filePath = "@mystage1"
// Define the schema for the data in the CSV file.
val userSchema = StructType(Seq(StructField("a", IntegerType), StructField("b", StringType)))
// Create a DataFrame that is configured to load data from the CSV file.
val csvDF = session.read.option("skip_header", 1).schema(userSchema).csv(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = csvDF.collect()

-- Example 2954
val filePath = "@mystage2/data.json.gz"
// Create a DataFrame that is configured to load data from the gzipped JSON file.
val jsonDF = session.read.option("compression", "gzip").json(filePath)
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = jsonDF.collect()

-- Example 2955
import com.snowflake.snowpark.types._
// Define the schema for the data in the CSV files.
val userSchema: StructType = StructType(Seq(StructField("a", IntegerType),StructField("b", StringType)))
// Create a DataFrame that is configured to load data from the CSV files in the stage.
val csvDF = session.read.option("pattern", ".*[.]csv").schema(userSchema).csv("@stage_location")
// Load the data into the DataFrame and return an Array of Rows containing the results.
val results = csvDF.collect()

-- Example 2956
val filePath = "@mystage1"
// Create a DataFrame that is configured to load data from the JSON file.
val jsonDF = session.read.json(filePath)
// Load the data into the specified table `T1`.
// The table "T1" should exist before calling copyInto().
jsonDF.copyInto("T1")

-- Example 2957
df.write.mode("overwrite").saveAsTable("T")

-- Example 2958
val result = df.write.csv("@myStage/prefix")

-- Example 2959
val result = df.write.option("compression", "none").csv("@myStage/prefix")

-- Example 2960
// Upload a file to a stage.
session.file.put("file:///tmp/file1.csv", "@myStage/prefix1")
// Download a file from a stage.
session.file.get("@myStage/prefix1/file1.csv", "file:///tmp")

-- Example 2961
val groupedDf: RelationalGroupedDataFrame = df.groupBy("dept")
val aggDf: DataFrame = groupedDf.agg(groupedDf("salary") -> "mean")

-- Example 2962
val sp = session.sproc.registerTemporary((session: Session, num: Int) => s"num: $num")
session.storedProcedure(sp, 123)

-- Example 2963
val name = "sproc"
val sp = session.sproc.registerTemporary(name,
  (session: Session, num: Int) => s"num: $num")
session.storedProcedure(sp, 123)
session.storedProcedure(name, 123)

-- Example 2964
val name = "sproc"
val stageName = "<a user stage name>"
val sp = session.sproc.registerPermanent(name,
  (session: Session, num: Int) => s"num: $num",
  stageName,
  isCallerMode = true)
session.storedProcedure(sp, 123)
session.storedProcedure(name, 123)

-- Example 2965
// a client side Scala lambda
val func = (session: Session, num: Int) => s"num: $num"
// register a server side stored procedure
val sp = session.sproc.registerTemporary(func)
// execute the lambda function of this SP from the client side
val localResult = session.sproc.runLocally(func, 123)
// execute this SP from the server side
val resultDF = session.storedProcedure(sp, 123)

-- Example 2966
val session = Session.builder.configFile("/path/to/file.properties").create

-- Example 2967
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

-- Example 2968
val sp = session.sproc.registerTemporary(
  (session: Session, num: Int) => {
    val result = session.sql(s"select $num").collect().head.getInt(0)
    result + 100
  })
session.storedProcedure(sp, 123).show()

-- Example 2969
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.TableFunction

session.tableFunction(
  TableFunction("flatten"),
  Map("input" -> parse_json(lit("[1,2]")))
)

df.join(TableFunction("split_to_table"), df("a"), lit(","))

-- Example 2970
val asyncJob1 = df.async.collect()
val asyncJob2 = df.async.toLocalIterator()
val asyncJob3 = df.async.count()

-- Example 2971
session.udf.registerTemporary("mydoubleudf", (x: Int) => x * x)
session.sql(s"SELECT mydoubleudf(c) from T)

-- Example 2972
session.udf.registerPermanent("mydoubleudf", (x: Int) => x * x, "mystage")
session.sql(s"SELECT mydoubleudf(c) from T)

-- Example 2973
val myUdf = session.udf.registerTemporary("mydoubleudf", (x: Int) => x * x)
session.table("T").select(myUdf(col("c")))

-- Example 2974
class MyRangeUdtf extends UDTF2[Int, Int] {
    override def process(start: Int, count: Int): Iterable[Row] =
        (start until (start + count)).map(Row(_))
    override def endPartition(): Iterable[Row] = Array.empty[Row]
    override def outputSchema(): StructType = StructType(StructField("C1", IntegerType))
}

-- Example 2975
// Use the MyRangeUdtf defined in previous example.
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 2976
val tableFunction = session.udtf.registerPermanent("myUdtf", new MyRangeUdtf(), "@myStage")
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 2977
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 2978
val dfPrices = session.table("itemsdb.publicschema.prices")

-- Example 2979
import com.snowflake.snowpark.functions._
val myUdf = udf((x: Int, y: String) => y + x)
df.select(myUdf(col("i"), col("s")))

-- Example 2980
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

-- Example 2981
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

-- Example 2982
import com.snowflake.snowpark.functions.parse_json

// Creates DataFrame from Session.tableFunction
session.tableFunction(tableFunctions.flatten, Map("input" -> parse_json(lit("[1,2]"))))
session.tableFunction(tableFunctions.split_to_table, "split by space", " ")

// DataFrame joins table function
df.join(tableFunctions.flatten, Map("input" -> parse_json(df("a"))))
df.join(tableFunctions.split_to_table, df("a"), ",")

// Invokes any table function including user-defined table function
 df.join(tableFunctions.tableFunction("flatten"), Map("input" -> parse_json(df("a"))))
 session.tableFunction(tableFunctions.tableFunction("split_to_table"), "split by space", " ")

-- Example 2983
CREATE PROCEDURE stproc1()
  RETURNS STRING NOT NULL
  LANGUAGE JAVASCRIPT
  AS
  -- "$$" is the delimiter for the beginning and end of the stored procedure.
  $$
  // The "snowflake" object is provided automatically in each stored procedure.
  var statement = snowflake.createStatement(...);
  ...
  $$
  ;

-- Example 2984
snowflake.addEvent('my_event', {'score': 89, 'pass': true});

-- Example 2985
var stmt = snowflake.createStatement(
  {sqlText: "INSERT INTO table1 (col1) VALUES (1);"}
);

-- Example 2986
var stmt = snowflake.createStatement(
  {
  sqlText: "INSERT INTO table2 (col1, col2) VALUES (?, ?);",
  binds:["LiteralValue1", variable2]
  }
);

-- Example 2987
snowflake.log("error", "Error message", {"custom1": "value1", "custom2": "value2"});

-- Example 2988
snowflake.setSpanAttribute("example.boolean", true);

-- Example 2989
var column_count = statement.getColumnCount();

-- Example 2990
CREATE TABLE scale_example  (
    n10_4 NUMERIC(10, 4)    // Precision is 10, Scale is 4.
    );

-- Example 2991
var row_count = statement.getRowCount();

-- Example 2992
var queryId = statement.getQueryId();

