-- Example 21485
java --add-opens=java.base/java.nio=ALL-UNNAMED -jar my-snowpark-app.jar.

-- Example 21486
java --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/sun.security.util=ALL-UNNAMED -jar my-snowpark-app.jar

-- Example 21487
export JDK_JAVA_OPTIONS="--add-opens=java.base/java.nio=ALL-UNNAMED"

-- Example 21488
export JDK_JAVA_OPTIONS="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/sun.security.util=ALL-UNNAMED"

-- Example 21489
SELECT id, name FROM sample_product_data;

-- Example 21490
DataFrame df = session.table("sample_product_data");

DataFrame dfSelectedCols = df.select(Functions.col("id"), Functions.col("name"));

dfSelectedCols.show();

-- Example 21491
SELECT id AS item_id FROM sample_product_data;

-- Example 21492
DataFrame df = session.table("sample_product_data");

DataFrame dfRenamedCol = df.select(Functions.col("id").as("item_id"));

dfRenamedCol.show();

-- Example 21493
DataFrame df = session.table("sample_product_data");

DataFrame dfRenamedCol = df.select(Functions.col("id").alias("item_id"));

dfRenamedCol.show();

-- Example 21494
SELECT * FROM sample_product_data WHERE id = 1;

-- Example 21495
DataFrame df = session.table("sample_product_data");

DataFrame dfFilteredRows = df.filter(Functions.col("id").equal_to(Functions.lit(1)));

dfFilteredRows.show();

-- Example 21496
DataFrame df = session.table("sample_product_data");

DataFrame dfFilteredRows = df.where(Functions.col("id").equal_to(Functions.lit(1)));

dfFilteredRows.show();

-- Example 21497
SELECT * FROM sample_product_data ORDER BY category_id;

-- Example 21498
DataFrame df = session.table("sample_product_data");

DataFrame dfSorted = df.sort(Functions.col("category_id"));

dfSorted.show();

-- Example 21499
SELECT * FROM sample_product_data
  ORDER BY category_id LIMIT 2;

-- Example 21500
DataFrame df = session.table("sample_product_data");

DataFrame dfSorted = df.sort(Functions.col("category_id")).limit(2);

Row[] arrayRows = dfSorted.collect();

-- Example 21501
SELECT * FROM sample_a
  INNER JOIN sample_b
  on sample_a.id_a = sample_b.id_a;

-- Example 21502
DataFrame dfLhs = session.table("sample_a");

DataFrame dfRhs = session.table("sample_b");

DataFrame dfJoined =
  dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));

dfJoined.show();

-- Example 21503
SELECT * FROM sample_a NATURAL JOIN sample_b;

-- Example 21504
DataFrame dfLhs = session.table("sample_a");

DataFrame dfRhs = session.table("sample_b");

DataFrame dfJoined = dfLhs.naturalJoin(dfRhs);

dfJoined.show();

-- Example 21505
SELECT src:salesperson.name FROM car_sales;

-- Example 21506
DataFrame df = session.table("car_sales");

DataFrame dfJsonField =
  df.select(Functions.col("src").subField("salesperson").subField("name"));

dfJsonField.show();

-- Example 21507
SELECT category_id, count(*)
  FROM sample_product_data GROUP BY category_id;

-- Example 21508
DataFrame df = session.table("sample_product_data");

DataFrame dfCountPerCategory = df.groupBy(Functions.col("category_id")).count();

dfCountPerCategory.show();

-- Example 21509
SELECT category_id, id, SUM(amount) OVER
  (PARTITION BY category_id ORDER BY product_date)
  FROM sample_product_data ORDER BY product_date;

-- Example 21510
WindowSpec window = Window.partitionBy(
  Functions.col("category_id")).orderBy(Functions.col("product_date"));

DataFrame df = session.table("sample_product_data");

DataFrame dfCumulativePrices = df.select(
  Functions.col("category_id"), Functions.col("product_date"),
  Functions.sum(Functions.col("amount")).over(window)).sort(Functions.col("product_date"));

dfCumulativePrices.show();

-- Example 21511
UPDATE sample_product_data
  SET serial_number = 'xyz' WHERE id = 12;

-- Example 21512
import java.util.HashMap;
import java.util.Map;
...

Map<Column, Column> assignments = new HashMap<>();

assignments.put(Functions.col("serial_number"), Functions.lit("xyz"));

Updatable updatableDf = session.table("sample_product_data");

UpdateResult updateResult =
  updatableDf.update(
    assignments,
    Functions.col("id").equal_to(Functions.lit(12)));

System.out.println("Number of rows updated: " + updateResult.getRowsUpdated());

-- Example 21513
DELETE FROM sample_product_data
  WHERE category_id = 50;

-- Example 21514
Updatable updatableDf = session.table("sample_product_data");

DeleteResult deleteResult =
  updatableDf.delete(updatableDf.col("category_id").equal_to(Functions.lit(50)));

System.out.println("Number of rows deleted: " + deleteResult.getRowsDeleted());

-- Example 21515
MERGE  INTO target_table USING source_table
  ON target_table.id = source_table.id
  WHEN MATCHED THEN
    UPDATE SET target_table.description =
      source_table.description;

-- Example 21516
import java.util.HashMap;
import java.util.Map;

Map<String, Column> assignments = new HashMap<>();
assignments.put("description", source.col("description"));
MergeResult mergeResult =
  target.merge(source, target.col("id").equal_to(source.col("id")))
  .whenMatched.updateColumn(assignments)
  .collect();

-- Example 21517
PUT file:///tmp/*.csv @myStage OVERWRITE = TRUE;

-- Example 21518
import java.util.HashMap;
import java.util.Map;
...
Map<String, String> putOptions = new HashMap<>();

putOptions.put("OVERWRITE", "TRUE");

PutResult[] putResults = session.file().put(
  "file:///tmp/*.csv", "@myStage", putOptions);

for (PutResult result : putResults) {
  System.out.println(result.getSourceFileName() + ": " + result.getStatus());
}

-- Example 21519
GET @myStage file:///tmp PATTERN = '.*.csv.gz';

-- Example 21520
import java.util.HashMap;
import java.util.Map;
...
Map<String, String> getOptions = new HashMap<>();

getOptions.put("PATTERN", "'.*.csv.gz'");

GetResult[] getResults = session.file().get(
"@myStage", "file:///tmp", getOptions);

for (GetResult result : getResults) {
  System.out.println(result.getFileName() + ": " + result.getStatus());
}

-- Example 21521
CREATE FILE FORMAT snowpark_temp_format TYPE = JSON;

SELECT "$1"[0]['salesperson']['name'] FROM (
  SELECT $1::VARIANT AS "$1" FROM @mystage/car_sales.json(
    FILE_FORMAT => 'snowpark_temp_format')) LIMIT 10;

DROP FILE FORMAT snowpark_temp_format;

-- Example 21522
DataFrame df = session.read().json(
  "@mystage/car_sales.json").select(
    Functions.col("$1").subField(0).subField("salesperson").subField("name"));

df.show();

-- Example 21523
COPY INTO new_car_sales
  FROM @mystage/car_sales.json
  FILE_FORMAT = (TYPE = JSON);

-- Example 21524
CopyableDataFrame dfCopyableDf = session.read().json("@mystage/car_sales.json");
dfCopyableDf.copyInto("new_car_sales");

-- Example 21525
COPY INTO @mystage/saved_data.json
  FROM (  SELECT  *  FROM (car_sales) )
  FILE_FORMAT = ( TYPE = JSON COMPRESSION = 'none' )
  OVERWRITE = TRUE
  DETAILED_OUTPUT = TRUE

-- Example 21526
DataFrame df = session.table("car_sales");

WriteFileResult writeFileResult = df.write().mode(
  SaveMode.Overwrite).option(
  "DETAILED_OUTPUT", "TRUE").option(
  "compression", "none").json(
  "@mystage/saved_data.json");

-- Example 21527
CREATE FUNCTION <temp_function_name>
  RETURNS INT
  LANGUAGE JAVA
  ...
  AS
  ...;

SELECT ...,
  <temp_function_name>(quantity) AS doublenum
  FROM sample_product_data;

-- Example 21528
UserDefinedFunction doubleUdf =
  Functions.udf(
    (Integer x) -> x + x,
    DataTypes.IntegerType,
    DataTypes.IntegerType);

DataFrame df = session.table("sample_product_data");

DataFrame dfWithDoubleNum =
  df.withColumn("doubleNum",
    doubleUdf.apply(Functions.col("quantity")));

dfWithDoubleNum.show();

-- Example 21529
CREATE FUNCTION <temp_function_name>
  RETURNS INT
  LANGUAGE JAVA
  ...
  AS
  ...;

SELECT ...,
  <temp_function_name>(quantity) AS doublenum
  FROM sample_product_data;

-- Example 21530
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerTemporary(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType);

DataFrame df = session.table("sample_product_data");

DataFrame dfWithDoubleNum =
  df.withColumn("doubleNum",
    Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleNum.show();

-- Example 21531
CREATE FUNCTION doubleUdf(arg1 INT)
  RETURNS INT
  LANGUAGE JAVA
  ...
  AS
  ...;

SELECT ...,
  doubleUdf(quantity) AS doublenum
  FROM sample_product_data;

-- Example 21532
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerPermanent(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType,
      "mystage");

DataFrame df = session.table("sample_product_data");

DataFrame dfWithDoubleNum =
  df.withColumn("doubleNum",
    Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleNum.show();

-- Example 21533
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

-- Example 21534
StoredProcedure sp =
  session.sproc().registerTemporary((Session session, Integer x, Integer y) -> x + y,
    new DataType[] {DataTypes.IntegerType, DataTypes.IntegerType},
    DataTypes.IntegerType);

  session.storedProcedure(sp, 2, 3).show();

-- Example 21535
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

-- Example 21536
String name = "sproc";

StoredProcedure sp =
  session.sproc().registerTemporary(name,
    (Session session, Integer x, Integer y) -> x + y,
    new DataType[] {DataTypes.IntegerType, DataTypes.IntegerType},
    DataTypes.IntegerType);

  session.storedProcedure(name, 2, 3).show();

-- Example 21537
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

-- Example 21538
String name = "add_hundred";
String stageName = "sproc_libs";

StoredProcedure sp =
  session.sproc().registerPermanent(
    name,
    (Session session, Integer x) -> x + 100,
    DataTypes.IntegerType,
    DataTypes.IntegerType,
    stageName,
    true);

  session.storedProcedure(name, 3).show();

-- Example 21539
pip install "snowflake-snowpark-python[modin]"

-- Example 21540
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

-- Example 21541
import modin.pandas as pd

# Import the Snowpark plugin for modin.
import snowflake.snowpark.modin.plugin

# Create a Snowpark session with a default connection.
from snowflake.snowpark.session import Session
session = Session.builder.create()

# Create a Snowpark pandas DataFrame from existing Snowflake table
df = pd.read_snowflake('SNOWFALL')

# Alternatively, create a Snowpark pandas DataFrame with sample data.
df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                    [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                    [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                    columns=["DAY", "LOCATION", "SNOWFALL"])

# Inspect the DataFrame
df

-- Example 21542
DAY  LOCATION  SNOWFALL
0       1  Big Bear       8.0
1       2  Big Bear      10.0
2       3  Big Bear       NaN
3       1     Tahoe       3.0
4       2     Tahoe       NaN
5       3     Tahoe      13.0
6       1  Whistler       NaN
7  Friday  Whistler      40.0
8       3  Whistler      25.0

-- Example 21543
# In-place point update to fix data error.
df.loc[df["DAY"]=="Friday","DAY"]=2

# Inspect the columns after update.
# Note how the data type is updated automatically after transformation.
df["DAY"]

-- Example 21544
0    1
1    2
2    3
3    1
4    2
5    3
6    1
7    2
8    3
Name: DAY, dtype: int64

-- Example 21545
# Drop rows with null values.
df.dropna()

-- Example 21546
DAY  LOCATION  SNOWFALL
0   1  Big Bear       8.0
1   2  Big Bear      10.0
3   1     Tahoe       3.0
5   3     Tahoe      13.0
7   2  Whistler      40.0
8   3  Whistler      25.0

-- Example 21547
# Compute the average daily snowfall across locations.
df.groupby("LOCATION").mean()["SNOWFALL"]

-- Example 21548
LOCATION
Big Bear     9.0
Tahoe        8.0
Whistler    32.5
Name: SNOWFALL, dtype: float64

-- Example 21549
conda create --name snowpark_pandas python=3.9
conda activate snowpark_pandas

-- Example 21550
pip install "snowflake-snowpark-python[modin]"

-- Example 21551
conda install snowflake-snowpark-python modin==0.28.1

