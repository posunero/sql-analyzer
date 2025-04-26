-- Example 27110
DataFrameWriter dfWriter = session.table("sample_product_data").write();

-- Example 27111
dfWriter = dfWriter.mode(SaveMode.Overwrite);

-- Example 27112
dfWriter = dfWriter.option("field_delimiter", ";").option("COMPRESSION", "NONE");

-- Example 27113
WriteFileResult writeFileResult = dfWriter.csv("@mystage/saved_data");

-- Example 27114
WriteFileResult writeFileResult = dfWriter.csv("@mystage/saved_data");
Row[] rows = writeFileResult.getRows();
StructType schema = writeFileResult.getSchema();
for (int i = 0 ; i < rows.length ; i++) {
  System.out.println("Row:" + i);
  Row row = rows[i];
  for (int j = 0; j < schema.size(); j++) {
    System.out.println(schema.get(j).name() + ": " + row.get(j));
  }
}

-- Example 27115
DataFrame df = session.table("car_sales");
WriteFileResult writeFileResult = df.write().mode(SaveMode.Overwrite).option("DETAILED_OUTPUT", "TRUE").option("compression", "none").json("@mystage/saved_data");
Row[] rows = writeFileResult.getRows();
StructType schema = writeFileResult.getSchema();
for (int i = 0 ; i < rows.length ; i++) {
  System.out.println("Row:" + i);
  Row row = rows[i];
  for (int j = 0; j < schema.size(); j++) {
    System.out.println(schema.get(j).name() + ": " + row.get(j));
  }
}

-- Example 27116
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("dealership")).show();

-- Example 27117
----------------------------
|"""SRC""['DEALERSHIP']"   |
----------------------------
|"Valley View Auto Sales"  |
|"Tindel Toyota"           |
----------------------------

-- Example 27118
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("salesperson").subField("name")).show();

-- Example 27119
------------------------------------
|"""SRC""['SALESPERSON']['NAME']"  |
------------------------------------
|"Frank Beasley"                   |
|"Greg Northrup"                   |
------------------------------------

-- Example 27120
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("vehicle").subField(0)).show();
df.select(Functions.col("src").subField("vehicle").subField(0).subField("price")).show();

-- Example 27121
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

-- Example 27122
df.select(Functions.get(Functions.col("src"), Functions.lit("dealership"))).show();
df.select(Functions.col("src").subField("dealership")).show();

-- Example 27123
df.select(Functions.get_path(Functions.col("src"), Functions.lit("vehicle[0].make"))).show();
df.select(Functions.col("src").subField("vehicle").subField(0).subField("make")).show();

-- Example 27124
// Import the objects for the data types, including StringType.
import com.snowflake.snowpark_java.types.*;
...
DataFrame df = session.table("car_sales");
df.select(Functions.col("src").subField("salesperson").subField("id")).show();
df.select(Functions.col("src").subField("salesperson").subField("id").cast(DataTypes.StringType)).show();

-- Example 27125
----------------------------------
|"""SRC""['SALESPERSON']['ID']"  |
----------------------------------
|"55"                            |
|"274"                           |
----------------------------------

---------------------------------------------------
|"CAST (""SRC""['SALESPERSON']['ID'] AS STRING)"  |
---------------------------------------------------
|55                                               |
|274                                              |
---------------------------------------------------

-- Example 27126
DataFrame df = session.table("car_sales");
df.flatten(Functions.col("src").subField("customer")).show();

-- Example 27127
----------------------------------------------------------------------------------------------------------------------------------------------------------
|"SRC"                                      |"SEQ"  |"KEY"  |"PATH"  |"INDEX"  |"VALUE"                            |"THIS"                               |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|{                                          |1      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "San Francisco, CA",  |  {                                  |
|    {                                      |       |       |        |         |  "name": "Joyce Ridgely",         |    "address": "San Francisco, CA",  |
|      "address": "San Francisco, CA",      |       |       |        |         |  "phone": "16504378889"           |    "name": "Joyce Ridgely",         |
|      "name": "Joyce Ridgely",             |       |       |        |         |}                                  |    "phone": "16504378889"           |
|      "phone": "16504378889"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Valley View Auto Sales",  |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "55",                            |       |       |        |         |                                   |                                     |
|    "name": "Frank Beasley"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "paint protection"                 |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Honda",                     |       |       |        |         |                                   |                                     |
|      "model": "Civic",                    |       |       |        |         |                                   |                                     |
|      "price": "20275",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
|{                                          |2      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "New York, NY",       |  {                                  |
|    {                                      |       |       |        |         |  "name": "Bradley Greenbloom",    |    "address": "New York, NY",       |
|      "address": "New York, NY",           |       |       |        |         |  "phone": "12127593751"           |    "name": "Bradley Greenbloom",    |
|      "name": "Bradley Greenbloom",        |       |       |        |         |}                                  |    "phone": "12127593751"           |
|      "phone": "12127593751"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Tindel Toyota",           |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "274",                           |       |       |        |         |                                   |                                     |
|    "name": "Greg Northrup"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "rust proofing",                   |       |       |        |         |                                   |                                     |
|        "fabric protection"                |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Toyota",                    |       |       |        |         |                                   |                                     |
|      "model": "Camry",                    |       |       |        |         |                                   |                                     |
|      "price": "23500",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 27128
df.flatten(Functions.col("src").subField("customer")).select(Functions.col("value").subField("name"), Functions.col("value").subField("address")).show();

-- Example 27129
-------------------------------------------------
|"""VALUE""['NAME']"   |"""VALUE""['ADDRESS']"  |
-------------------------------------------------
|"Joyce Ridgely"       |"San Francisco, CA"     |
|"Bradley Greenbloom"  |"New York, NY"          |
-------------------------------------------------

-- Example 27130
df.flatten(Functions.col("src").subField("customer")).select(Functions.col("value").subField("name").cast(DataTypes.StringType).as("Customer Name"), Functions.col("value").subField("address").cast(DataTypes.StringType).as("Customer Address")).show();

-- Example 27131
-------------------------------------------
|"Customer Name"     |"Customer Address"  |
-------------------------------------------
|Joyce Ridgely       |San Francisco, CA   |
|Bradley Greenbloom  |New York, NY        |
-------------------------------------------

-- Example 27132
import java.util.Arrays;

// Get the list of the files in a stage.
// The collect() method causes this SQL statement to be executed.
DataFrame dfStageFiles  = session.sql("ls @myStage");
Row[] files = dfStageFiles.collect();
System.out.println(Arrays.toString(files));

// Resume the operation of a warehouse.
// Note that you must call the collect method in order to execute
// the SQL statement.
session.sql("alter warehouse if exists myWarehouse resume if suspended").collect();

DataFrame tableDf = session.table("sample_product_data").select(Functions.col("id"), Functions.col("name"));
// Get the count of rows from the table.
long numRows = tableDf.count();
System.out.println("Count: " + numRows);

-- Example 27133
import java.util.Arrays;

DataFrame df = session.sql("select id, category_id, name from sample_product_data where id > 10");
// Because the underlying SQL statement for the DataFrame is a SELECT statement,
// you can call the filter method to transform this DataFrame.
Row[] results = df.filter(Functions.col("category_id").lt(Functions.lit(10))).select(Functions.col("id")).collect();
System.out.println(Arrays.toString(results));

// In this example, the underlying SQL statement is not a SELECT statement.
DataFrame dfStageFiles = session.sql("ls @myStage");
// Calling the filter method results in an error.
dfStageFiles.filter(...);

-- Example 27134
cd <path>/snowpark-1.15.0
./run.sh

-- Example 27135
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._

object Main {
  def main(args: Array[String]): Unit = {
    // Replace the <placeholders> below.
    val configs = Map (
      "URL" -> "https://<account_identifier>.snowflakecomputing.com:443",
      "USER" -> "<user name>",
      "PASSWORD" -> "<password>",
      "ROLE" -> "<role name>",
      "WAREHOUSE" -> "<warehouse name>",
      "DB" -> "<database name>",
      "SCHEMA" -> "<schema name>"
    )
    val session = Session.builder.configs(configs).create
    session.sql("show tables").show()
  }
}

-- Example 27136
./run.sh

-- Example 27137
:load Main.scala

-- Example 27138
Main.main(Array[String]())

-- Example 27139
----------DATAFRAME EXECUTION PLAN----------
Query List:
0.
SELECT
  "_1" AS "col %",
  "_2" AS "col *"
FROM
  (
    SELECT
      *
    FROM
      (
        VALUES
          (1 :: int, 2 :: int),
          (3 :: int, 4 :: int) AS SN_TEMP_OBJECT_639016133("_1", "_2")
      )
  )
Logical Execution Plan:
 GlobalStats:
    partitionsTotal=0
    partitionsAssigned=0
    bytesAssigned=0
Operations:
1:0     ->Result  SN_TEMP_OBJECT_639016133.COLUMN1, SN_TEMP_OBJECT_639016133.COLUMN2
1:1          ->ValuesClause  (1, 2), (3, 4)

--------------------------------------------

-- Example 27140
# simplelogger.properties file (a text file)
# Set the default log level for the SimpleLogger to DEBUG.
org.slf4j.simpleLogger.defaultLogLevel=debug

-- Example 27141
scala -J-Xmx4G ...

-- Example 27142
CREATE OR REPLACE TABLE sample_product_data (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT);
INSERT INTO sample_product_data VALUES
    (1, 0, 5, 'Product 1', 'prod-1', 1, 10),
    (2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20),
    (3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30),
    (4, 0, 10, 'Product 2', 'prod-2', 2, 40),
    (5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50),
    (6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60),
    (7, 0, 20, 'Product 3', 'prod-3', 3, 70),
    (8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80),
    (9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90),
    (10, 0, 50, 'Product 4', 'prod-4', 4, 100),
    (11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100),
    (12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100);

-- Example 27143
SELECT * FROM sample_product_data;

-- Example 27144
// Create a DataFrame from the data in the "sample_product_data" table.
val dfTable = session.table("sample_product_data")

// To print out the first 10 rows, call:
//   dfTable.show()

-- Example 27145
// Create a DataFrame containing a sequence of values.
// In the DataFrame, name the columns "i" and "s".
val dfSeq = session.createDataFrame(Seq((1, "one"), (2, "two"))).toDF("i", "s")

-- Example 27146
// Create a DataFrame from a range
val dfRange = session.range(1, 10, 2)

-- Example 27147
// Create a DataFrame from data in a stage.
val dfJson = session.read.json("@mystage2/data1.json")

-- Example 27148
// Create a DataFrame from a SQL query
val dfSql = session.sql("SELECT name from products")

-- Example 27149
// Import the col function from the functions object.
import com.snowflake.snowpark.functions._

// Create a DataFrame for the rows with the ID 1
// in the "sample_product_data" table.
//
// This example uses the === operator of the Column object to perform an
// equality check.
val df = session.table("sample_product_data").filter(col("id") === 1)
df.show()

-- Example 27150
// Import the col function from the functions object.
import com.snowflake.snowpark.functions._

// Create a DataFrame that contains the id, name, and serial_number
// columns in te "sample_product_data" table.
val df = session.table("sample_product_data").select(col("id"), col("name"), col("serial_number"))
df.show()

-- Example 27151
// Import the col function from the functions object.
import com.snowflake.snowpark.functions._

val dfProductInfo = session.table("sample_product_data").select(col("id"), col("name"))
dfProductInfo.show()

-- Example 27152
// Specify the equivalent of "WHERE id = 20"
// in an SQL SELECT statement.
df.filter(col("id") === 20)

-- Example 27153
// Specify the equivalent of "WHERE a + b < 10"
// in an SQL SELECT statement.
df.filter((col("a") + col("b")) < 10)

-- Example 27154
// Specify the equivalent of "SELECT b * 10 AS c"
// in an SQL SELECT statement.
df.select((col("b") * 10) as "c")

-- Example 27155
// Specify the equivalent of "X JOIN Y on X.a_in_X = Y.b_in_Y"
// in an SQL SELECT statement.
dfX.join(dfY, col("a_in_X") === col("b_in_Y"))

-- Example 27156
// Create a DataFrame that joins two other DataFrames (dfLhs and dfRhs).
// Use the DataFrame.col method to refer to the columns used in the join.
val dfJoined = dfLhs.join(dfRhs, dfLhs.col("key") === dfRhs.col("key")).select(dfLhs.col("value").as("L"), dfRhs.col("value").as("R"))

-- Example 27157
// Create a DataFrame that joins two other DataFrames (dfLhs and dfRhs).
// Use the DataFrame.apply method to refer to the columns used in the join.
// Note that dfLhs("key") is shorthand for dfLhs.apply("key").
val dfJoined = dfLhs.join(dfRhs, dfLhs("key") === dfRhs("key")).select(dfLhs("value").as("L"), dfRhs("value").as("R"))

-- Example 27158
val session = Session.builder.configFile("/path/to/properties").create

// Import this after you create the session.
import session.implicits._

// Use the $ (dollar sign) shorthand.
val df = session.table("T").filter($"id" === 10).filter(($"a" + $"b") < 10)

// Use ' (apostrophe) shorthand.
val df = session.table("T").filter('id === 10).filter(('a + 'b) < 10).select('b * 10)

-- Example 27159
// The following calls are equivalent:
df.select(col("id123"))
df.select(col("ID123"))

-- Example 27160
val df = session.table("\"10tablename\"")

-- Example 27161
// The following calls are equivalent:
df.select(col("3rdID"))
df.select(col("\"3rdID\""))

// The following calls are equivalent:
df.select(col("id with space"))
df.select(col("\"id with space\""))

-- Example 27162
describe table quoted;
+------------------------+ ...
| name                   | ...
|------------------------+ ...
| name_with_"air"_quotes | ...
| "column_name_quoted"   | ...
+------------------------+ ...

-- Example 27163
val dfTable = session.table("quoted")
dfTable.select("\"name_with_\"\"air\"\"_quotes\"").show()
dfTable.select("\"\"\"column_name_quoted\"\"\"").show()

-- Example 27164
// The following calls are NOT equivalent!
// The Snowpark library adds double quotes around the column name,
// which makes Snowflake treat the column name as case-sensitive.
df.select(col("id with space"))
df.select(col("ID WITH SPACE"))

-- Example 27165
// Import for the lit and col functions.
import com.snowflake.snowpark.functions._

// Show the first 10 rows in which num_items is greater than 5.
// Use `lit(5)` to create a Column object for the literal 5.
df.filter(col("num_items").gt(lit(5))).show()

-- Example 27166
// Create a DataFrame that contains the value 0.05.
val df = session.sql("select 0.05 :: Numeric(5, 2) as a")

// Applying this filter results in no matching rows in the DataFrame.
df.filter(col("a") <= lit(0.06) - lit(0.01)).show()

-- Example 27167
df.filter(col("a") <= lit(0.06).cast(new DecimalType(5, 2)) - lit(0.01).cast(new DecimalType(5, 2))).show()

-- Example 27168
df.filter(col("a") <= lit(BigDecimal(0.06)) - lit(BigDecimal(0.01))).show()

-- Example 27169
// Import for the lit function.
import com.snowflake.snowpark.functions._
// Import for the DecimalType class..
import com.snowflake.snowpark.types._

val decimalValue = lit(0.05).cast(new DecimalType(5,2))

-- Example 27170
val dfProductInfo = session.table("sample_product_data").filter(col("id") === 1).select(col("name"), col("serial_number"))
dfProductInfo.show()

-- Example 27171
// This fails with the error "invalid identifier 'ID'."
val dfProductInfo = session.table("sample_product_data").select(col("name"), col("serial_number")).filter(col("id") === 1)

-- Example 27172
// This succeeds because the DataFrame returned by the table() method
// includes the "id" column.
val dfProductInfo = session.table("sample_product_data").filter(col("id") === 1).select(col("name"), col("serial_number"))
dfProductInfo.show()

-- Example 27173
// Limit the number of rows to 5, sorted by parent_id.
var dfSubset = df.sort(col("parent_id")).limit(5);

// Return the first 5 rows, sorted by parent_id.
var arrayOfRows = df.sort(col("parent_id")).first(5)

// Print the first 5 rows, sorted by parent_id.
df.sort(col("parent_id")).show(5)

-- Example 27174
// Get the StructType object that describes the columns in the
// underlying rowset.
val tableSchema = session.table("sample_product_data").schema
println("Schema for sample_product_data: " + tableSchema);

-- Example 27175
// Create a DataFrame containing the "id" and "3rd" columns.
val dfSelectedColumns = session.table("sample_product_data").select(col("id"), col("3rd"))
// Print out the names of the columns in the schema. This prints out:
//   ArraySeq(ID, "3rd")
println(dfSelectedColumns.schema.names.toSeq)

-- Example 27176
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

