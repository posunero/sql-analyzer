-- Example 21351
CREATE FUNCTION F(...)
  RETURNS TABLE(NAME VARCHAR, ID INTEGER)
  ...

-- Example 21352
public Stream<OutputRow> process(String v) {
  ...
  return Stream.of(new OutputRow(...));
}

public Stream<OutputRow> endPartition() {
  ...
  return Stream.of(new OutputRow(...));
}

-- Example 21353
public static Class getOutputClass() {
  return OutputRow.class;
}

-- Example 21354
create function return_two_copies(v varchar)
returns table(output_value varchar)
language java
handler='TestFunction'
target_path='@~/TestFunction.jar'
as
$$

  import java.util.stream.Stream;

  class OutputRow {

    public String output_value;

    public OutputRow(String outputValue) {
      this.output_value = outputValue;
    }

  }


  class TestFunction {

    String myString;

    public TestFunction()  {
      myString = "Created in constructor and output from endPartition()";
    }

    public static Class getOutputClass() {
      return OutputRow.class;
    }

    public Stream<OutputRow> process(String inputValue) {
      // Return two rows with the same value.
      return Stream.of(new OutputRow(inputValue), new OutputRow(inputValue));
    }

    public Stream<OutputRow> endPartition() {
      // Returns the value we initialized in the constructor.
      return Stream.of(new OutputRow(myString));
    }

  }

$$;

-- Example 21355
SELECT output_value
   FROM TABLE(return_two_copies('Input string'));
+-------------------------------------------------------+
| OUTPUT_VALUE                                          |
|-------------------------------------------------------|
| Input string                                          |
| Input string                                          |
| Created in constructor and output from endPartition() |
+-------------------------------------------------------+

-- Example 21356
CREATE TABLE cities_of_interest (city_name VARCHAR);
INSERT INTO cities_of_interest (city_name) VALUES
    ('Toronto'),
    ('Warsaw'),
    ('Kyoto');

-- Example 21357
SELECT city_name, output_value
   FROM cities_of_interest,
       TABLE(return_two_copies(city_name))
   ORDER BY city_name, output_value;
+-----------+-------------------------------------------------------+
| CITY_NAME | OUTPUT_VALUE                                          |
|-----------+-------------------------------------------------------|
| Kyoto     | Kyoto                                                 |
| Kyoto     | Kyoto                                                 |
| Toronto   | Toronto                                               |
| Toronto   | Toronto                                               |
| Warsaw    | Warsaw                                                |
| Warsaw    | Warsaw                                                |
| NULL      | Created in constructor and output from endPartition() |
+-----------+-------------------------------------------------------+

-- Example 21358
FROM cities_of_interest, TABLE(f(city_name))

-- Example 21359
for city_name in cities_of_interest:
    output_row = f(city_name)

-- Example 21360
SELECT city_name, output_value
   FROM cities_of_interest,
       TABLE(return_two_copies(city_name) OVER (PARTITION BY city_name))
   ORDER BY city_name, output_value;
+-----------+-------------------------------------------------------+
| CITY_NAME | OUTPUT_VALUE                                          |
|-----------+-------------------------------------------------------|
| Kyoto     | Created in constructor and output from endPartition() |
| Kyoto     | Kyoto                                                 |
| Kyoto     | Kyoto                                                 |
| Toronto   | Created in constructor and output from endPartition() |
| Toronto   | Toronto                                               |
| Toronto   | Toronto                                               |
| Warsaw    | Created in constructor and output from endPartition() |
| Warsaw    | Warsaw                                                |
| Warsaw    | Warsaw                                                |
+-----------+-------------------------------------------------------+

-- Example 21361
SELECT city_name, output_value
   FROM cities_of_interest,
       TABLE(return_two_copies(city_name) OVER (PARTITION BY 1))
   ORDER BY city_name, output_value;
+-----------+-------------------------------------------------------+
| CITY_NAME | OUTPUT_VALUE                                          |
|-----------+-------------------------------------------------------|
| Kyoto     | Kyoto                                                 |
| Kyoto     | Kyoto                                                 |
| Toronto   | Toronto                                               |
| Toronto   | Toronto                                               |
| Warsaw    | Warsaw                                                |
| Warsaw    | Warsaw                                                |
| NULL      | Created in constructor and output from endPartition() |
+-----------+-------------------------------------------------------+

-- Example 21362
CREATE OR REPLACE TABLE sample_product_data (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT, amount NUMBER(12, 2), quantity INT, product_date DATE);
INSERT INTO sample_product_data VALUES
    (1, 0, 5, 'Product 1', 'prod-1', 1, 10, 1.00, 15, TO_DATE('2021.01.01', 'YYYY.MM.DD')),
    (2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20, 2.00, 30, TO_DATE('2021.02.01', 'YYYY.MM.DD')),
    (3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30, 3.00, 45, TO_DATE('2021.03.01', 'YYYY.MM.DD')),
    (4, 0, 10, 'Product 2', 'prod-2', 2, 40, 4.00, 60, TO_DATE('2021.04.01', 'YYYY.MM.DD')),
    (5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50, 5.00, 75, TO_DATE('2021.05.01', 'YYYY.MM.DD')),
    (6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60, 6.00, 90, TO_DATE('2021.06.01', 'YYYY.MM.DD')),
    (7, 0, 20, 'Product 3', 'prod-3', 3, 70, 7.00, 105, TO_DATE('2021.07.01', 'YYYY.MM.DD')),
    (8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80, 7.25, 120, TO_DATE('2021.08.01', 'YYYY.MM.DD')),
    (9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90, 7.50, 135, TO_DATE('2021.09.01', 'YYYY.MM.DD')),
    (10, 0, 50, 'Product 4', 'prod-4', 4, 100, 7.75, 150, TO_DATE('2021.10.01', 'YYYY.MM.DD')),
    (11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100, 8.00, 165, TO_DATE('2021.11.01', 'YYYY.MM.DD')),
    (12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100, 8.50, 180, TO_DATE('2021.12.01', 'YYYY.MM.DD'));

-- Example 21363
SELECT * FROM sample_product_data;

-- Example 21364
// Create a DataFrame from the data in the "sample_product_data" table.
DataFrame dfTable = session.table("sample_product_data");

// Print out the first 10 rows.
dfTable.show();

-- Example 21365
// Import name from the types package, which contains StructType and StructField.
import com.snowflake.snowpark_java.types.*;
...

 // Create a DataFrame containing specified values.
 Row[] data = {Row.create(1, "a"), Row.create(2, "b")};
 StructType schema =
   StructType.create(
     new StructField("num", DataTypes.IntegerType),
     new StructField("str", DataTypes.StringType));
 DataFrame df = session.createDataFrame(data, schema);

 // Print the contents of the DataFrame.
 df.show();

-- Example 21366
// Create a DataFrame from a range
DataFrame dfRange = session.range(1, 10, 2);

// Print the contents of the DataFrame.
dfRange.show();

-- Example 21367
// Create a DataFrame from data in a stage.
DataFrame dfJson = session.read().json("@mystage2/data1.json");

// Print the contents of the DataFrame.
dfJson.show();

-- Example 21368
// Create a DataFrame from a SQL query
DataFrame dfSql = session.sql("SELECT name from sample_product_data");

// Print the contents of the DataFrame.
dfSql.show();

-- Example 21369
// Create a DataFrame for the rows with the ID 1
// in the "sample_product_data" table.
DataFrame df = session.table("sample_product_data").filter(
  Functions.col("id").equal_to(Functions.lit(1)));
df.show();

-- Example 21370
// Create a DataFrame that contains the id, name, and serial_number
// columns in te "sample_product_data" table.
DataFrame df = session.table("sample_product_data").select(
  Functions.col("id"), Functions.col("name"), Functions.col("serial_number"));
df.show();

-- Example 21371
DataFrame dfProductInfo = session.table("sample_product_data").select(Functions.col("id"), Functions.col("name"));
dfProductInfo.show();

-- Example 21372
// Specify the equivalent of "WHERE id = 12"
// in an SQL SELECT statement.
DataFrame df = session.table("sample_product_data");
df.filter(Functions.col("id").equal_to(Functions.lit(12))).show();

-- Example 21373
// Specify the equivalent of "WHERE key + category_id < 10"
// in an SQL SELECT statement.
DataFrame df2 = session.table("sample_product_data");
df2.filter(Functions.col("key").plus(Functions.col("category_id")).lt(Functions.lit(10))).show();

-- Example 21374
// Specify the equivalent of "SELECT key * 10 AS c"
// in an SQL SELECT statement.
DataFrame df3 = session.table("sample_product_data");
df3.select(Functions.col("key").multiply(Functions.lit(10)).as("c")).show();

-- Example 21375
// Specify the equivalent of "sample_a JOIN sample_b on sample_a.id_a = sample_b.id_a"
// in an SQL SELECT statement.
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));
dfJoined.show();

-- Example 21376
// Create a DataFrame that joins two other DataFrames (dfLhs and dfRhs).
// Use the DataFrame.col method to refer to the columns used in the join.
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a"))).select(dfLhs.col("value").as("L"), dfRhs.col("value").as("R"));
dfJoined.show();

-- Example 21377
// The following calls are equivalent:
df.select(Functions.col("id123"));
df.select(Functions.col("ID123"));

-- Example 21378
DataFrame df = session.table("\"10tablename\"");

-- Example 21379
// The following calls are equivalent:
df.select(Functions.col("3rdID"));
df.select(Functions.col("\"3rdID\""));

// The following calls are equivalent:
df.select(Functions.col("id with space"));
df.select(Functions.col("\"id with space\""));

-- Example 21380
describe table quoted;
+------------------------+ ...
| name                   | ...
|------------------------+ ...
| name_with_"air"_quotes | ...
| "column_name_quoted"   | ...
+------------------------+ ...

-- Example 21381
DataFrame dfTable = session.table("quoted");
dfTable.select("\"name_with_\"\"air\"\"_quotes\"");
dfTable.select("\"\"\"column_name_quoted\"\"\"");

-- Example 21382
// The following calls are NOT equivalent!
// The Snowpark library adds double quotes around the column name,
// which makes Snowflake treat the column name as case-sensitive.
df.select(Functions.col("id with space"));
df.select(Functions.col("ID WITH SPACE"));

-- Example 21383
// Show the first 10 rows in which category_id is greater than 5.
// Use `Functions.lit(5)` to create a Column object for the literal 5.
DataFrame df = session.table("sample_product_data");
df.filter(Functions.col("category_id").gt(Functions.lit(5))).show();

-- Example 21384
// Create a DataFrame that contains the value 0.05.
DataFrame df = session.sql("select 0.05 :: Numeric(5, 2) as a");

// Applying this filter results in no matching rows in the DataFrame.
df.filter(Functions.col("a").leq(Functions.lit(0.06).minus(Functions.lit(0.01)))).show();

-- Example 21385
import com.snowflake.snowpark_java.types.*;
...

df.filter(Functions.col("a").leq(Functions.lit(0.06).cast(DataTypes.createDecimalType(5, 2)).minus(Functions.lit(0.01).cast(DataTypes.createDecimalType(5, 2))))).show();

-- Example 21386
// Import for the DecimalType class..
import com.snowflake.snowpark_java.types.*;

Column decimalValue = Functions.lit(0.05).cast(DataTypes.createDecimalType(5,2));

-- Example 21387
DataFrame dfProductInfo = session.table("sample_product_data").filter(Functions.col("id").equal_to(Functions.lit(1))).select(Functions.col("name"), Functions.col("serial_number"));
dfProductInfo.show();

-- Example 21388
// This fails with the error "invalid identifier 'ID'."
DataFrame dfProductInfo = session.table("sample_product_data").select(Functions.col("name"), Functions.col("serial_number")).filter(Functions.col("id").equal_to(Functions.lit(1)));
dfProductInfo.show();

-- Example 21389
// This succeeds because the DataFrame returned by the table() method
// includes the "id" column.
DataFrame dfProductInfo = session.table("sample_product_data").filter(Functions.col("id").equal_to(Functions.lit(1))).select(Functions.col("name"), Functions.col("serial_number"));
dfProductInfo.show();

-- Example 21390
DataFrame df = session.table("sample_product_data");

// Limit the number of rows to 5, sorted by parent_id.
DataFrame dfSubset = df.sort(Functions.col("parent_id")).limit(5);

// Return the first 5 rows, sorted by parent_id.
Row[] arrayOfRows = df.sort(Functions.col("parent_id")).first(5);

// Print the first 5 rows, sorted by parent_id.
df.sort(Functions.col("parent_id")).show(5);

-- Example 21391
import com.snowflake.snowpark_java.types.*;
...

// Get the StructType object that describes the columns in the
// underlying rowset.
StructType tableSchema = session.table("sample_product_data").schema();
System.out.println("Schema for sample_product_data: " + tableSchema);

-- Example 21392
import java.util.Arrays;
...

// Create a DataFrame containing the "id" and "3rd" columns.
DataFrame dfSelectedColumns = session.table("sample_product_data").select(Functions.col("id"), Functions.col("3rd"));
// Print out the names of the columns in the schema.
System.out.println(Arrays.toString(dfSelectedColumns.schema().names()));

-- Example 21393
CREATE OR REPLACE TABLE sample_a (
  id_a INTEGER,
  name_a VARCHAR,
  value INTEGER
);
INSERT INTO sample_a (id_a, name_a, value) VALUES
  (10, 'A1', 5),
  (40, 'A2', 10),
  (80, 'A3', 15),
  (90, 'A4', 20)
;
CREATE OR REPLACE TABLE sample_b (
  id_b INTEGER,
  name_b VARCHAR,
  id_a INTEGER,
  value INTEGER
);
INSERT INTO sample_b (id_b, name_b, id_a, value) VALUES
  (4000, 'B1', 40, 10),
  (4001, 'B2', 10, 5),
  (9000, 'B3', 80, 15),
  (9099, 'B4', NULL, 200)
;
CREATE OR REPLACE TABLE sample_c (
  id_c INTEGER,
  name_c VARCHAR,
  id_a INTEGER,
  id_b INTEGER
);
INSERT INTO sample_c (id_c, name_c, id_a, id_b) VALUES
  (1012, 'C1', 10, NULL),
  (1040, 'C2', 40, 4000),
  (1041, 'C3', 40, 4001)
;

-- Example 21394
// Create a DataFrame that joins the DataFrames for the tables
// "sample_a" and "sample_b" on the column named "id_a".
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));
dfJoined.show();

-- Example 21395
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |
|40      |A2        |10       |4000    |B1        |40      |10       |
|80      |A3        |15       |9000    |B3        |80      |15       |
----------------------------------------------------------------------

-- Example 21396
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));
DataFrame dfSelected = dfJoined.select(dfLhs.col("value").as("LeftValue"), dfRhs.col("value").as("RightValue"));
dfSelected.show();

-- Example 21397
------------------------------
|"LEFTVALUE"  |"RIGHTVALUE"  |
------------------------------
|5            |5             |
|10           |10            |
|15           |15            |
------------------------------

-- Example 21398
--------------------------------------------------------------------------------------------------
|"l_ZSz7_ID_A"  |"NAME_A"  |"l_ZSz7_VALUE"  |"ID_B"  |"NAME_B"  |"r_heec_ID_A"  |"r_heec_VALUE"  |
--------------------------------------------------------------------------------------------------
|10             |A1        |5               |4001    |B2        |10             |5               |
|40             |A2        |10              |4000    |B1        |40             |10              |
|80             |A3        |15              |9000    |B3        |80             |15              |
--------------------------------------------------------------------------------------------------

-- Example 21399
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.naturalJoin(dfRhs);
dfJoined.show();

-- Example 21400
---------------------------------------------------
|"ID_A"  |"VALUE"  |"NAME_A"  |"ID_B"  |"NAME_B"  |
---------------------------------------------------
|10      |5        |A1        |4001    |B2        |
|40      |10       |A2        |4000    |B1        |
|80      |15       |A3        |9000    |B3        |
---------------------------------------------------

-- Example 21401
// Create a DataFrame that performs a left outer join on
// "sample_a" and "sample_b" on the column named "id_a".
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfLeftOuterJoin = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")), "left");
dfLeftOuterJoin.show();

-- Example 21402
----------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |
----------------------------------------------------------------------
|40      |A2        |10       |4000    |B1        |40      |10       |
|10      |A1        |5        |4001    |B2        |10      |5        |
|80      |A3        |15       |9000    |B3        |80      |15       |
|90      |A4        |20       |NULL    |NULL      |NULL    |NULL     |
----------------------------------------------------------------------

-- Example 21403
DataFrame dfFirst = session.table("sample_a");
DataFrame dfSecond  = session.table("sample_b");
DataFrame dfThird = session.table("sample_c");
DataFrame dfJoinThreeTables = dfFirst.join(dfSecond, dfFirst.col("id_a").equal_to(dfSecond.col("id_a"))).join(dfThird, dfFirst.col("id_a").equal_to(dfThird.col("id_a")));
dfJoinThreeTables.show();

-- Example 21404
------------------------------------------------------------------------------------------------------------
|"ID_A"  |"NAME_A"  |"VALUE"  |"ID_B"  |"NAME_B"  |"ID_A"  |"VALUE"  |"ID_C"  |"NAME_C"  |"ID_A"  |"ID_B"  |
------------------------------------------------------------------------------------------------------------
|10      |A1        |5        |4001    |B2        |10      |5        |1012    |C1        |10      |NULL    |
|40      |A2        |10       |4000    |B1        |40      |10       |1040    |C2        |40      |4000    |
|40      |A2        |10       |4000    |B1        |40      |10       |1041    |C3        |40      |4001    |
------------------------------------------------------------------------------------------------------------

-- Example 21405
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
DataFrame df = session.table("sample_product_data");
DataFrame dfJoined = df.join(df, Functions.col("id").equal_to(Functions.col("parent_id")));

-- Example 21406
// This fails because columns named "id" and "parent_id"
// are in the left and right DataFrames in the join.
DataFrame df = session.table("sample_product_data");
DataFrame dfJoined = df.join(df, df.col("id").equal_to(df.col("parent_id")));

-- Example 21407
Exception in thread "main" com.snowflake.snowpark_java.SnowparkClientException:
  Joining a DataFrame to itself can lead to incorrect results due to ambiguity of column references.
  Instead, join this DataFrame to a clone() of itself.

-- Example 21408
// Create a DataFrame object for the "sample_product_data" table for the left-hand side of the join.
DataFrame dfLhs = session.table("sample_product_data");
// Clone the DataFrame object to use as the right-hand side of the join.
DataFrame dfRhs = dfLhs.clone();

// Create a DataFrame that joins the two DataFrames
// for the "sample_product_data" table on the
// "id" and "parent_id" columns.
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id").equal_to(dfRhs.col("parent_id")));
dfJoined.show();

-- Example 21409
// Create a DataFrame that performs a self-join on a DataFrame
// using the column named "key".
DataFrame df = session.table("sample_product_data");
DataFrame dfJoined = df.join(df, "key");

-- Example 21410
// Create a DataFrame for the "sample_product_data" table.
DataFrame dfProducts = session.table("sample_product_data");

// Send the query to the server for execution and
// print the count of rows in the table.
System.out.println("Rows returned: " + dfProducts.count());

-- Example 21411
import java.util.Arrays;

// Create a DataFrame with the "id" and "name" columns from the "sample_product_data" table.
// This does not execute the query.
DataFrame df = session.table("sample_product_data").select(Functions.col("id"), Functions.col("name"));

// Execute the query asynchronously.
// This call does not block.
TypedAsyncJob<Row[]> asyncJob = df.async().collect();
// Check if the query has completed execution.
System.out.println("Is query " + asyncJob.getQueryId() + " done? " + asyncJob.isDone());
// Get an Array of Rows containing the results, and print the results.
// Note that getResult is a blocking call.
Row[] results = asyncJob.getResult();
System.out.println(Arrays.toString(results));

-- Example 21412
// Create a DataFrame for the "sample_product_data" table.
DataFrame dfProducts = session.table("sample_product_data");

// Execute the query asynchronously.
// This call does not block.
TypedAsyncJob<Long> asyncJob = dfProducts.async().count();
// Check if the query has completed execution.
System.out.println("Is query " + asyncJob.getQueryId() + " done? " + asyncJob.isDone());
// Print the count of rows in the table.
// Note that getResult is a blocking call.
System.out.println("Rows returned: " + asyncJob.getResult());

-- Example 21413
// Wait a maximum of 10 seconds for the query to complete before retrieving the results.
Row[] results = asyncJob.getResult(10);

-- Example 21414
import java.util.Arrays;
...

AsyncJob asyncJob = session.createAsyncJob(myQueryId);
// Check if the query has completed execution.
System.out.println("Is query " + asyncJob.getQueryId() + " done? " + asyncJob.isDone());
// If you need to retrieve the results, call getRows to return an Array of Rows containing the results.
// Note that getRows is a blocking call.
Row[] rows = asyncJob.getRows();
System.out.println(Arrays.toString(rows));

-- Example 21415
Row[] rows = session.table("sample_product_data").select(Functions.col("name"), Functions.col("category_id")).sort(Functions.col("name")).collect();
for (Row row : rows) {
  System.out.println("Name: " + row.getString(0) + "; Category ID: " + row.getInt(1));
}

-- Example 21416
import java.util.Iterator;

Iterator<Row> rowIterator = session.table("sample_product_data").select(Functions.col("name"), Functions.col("category_id")).sort(Functions.col("name")).toLocalIterator();
while (rowIterator.hasNext()) {
  Row row = rowIterator.next();
  System.out.println("Name: " + row.getString(0) + "; Category ID: " + row.getInt(1));
}

-- Example 21417
import java.util.Arrays;
...

DataFrame df = session.table("sample_product_data");
Row[] rows = df.sort(Functions.col("name")).first(5);
System.out.println(Arrays.toString(rows));

