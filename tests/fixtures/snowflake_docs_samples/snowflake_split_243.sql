-- Example 16260
import com.snowflake.snowpark_java.types.*;

// Add the JAR file as a dependency.
session.addDependency("<path>/myJar.jar");

// Create a new DataFrame with one column (NAME)
// that contains the name "Raymond".
DataFrame myDf = session.sql("select 'Raymond' NAME");

// Register the function that you defined earlier as an anonymous UDF.
UserDefinedFunction readFileUdf = session.udf().registerTemporary(
  (String s) -> UDFCode.readFile() + " : " + s, DataTypes.StringType, DataTypes.StringType);

// Call UDF for the values in the NAME column of the DataFrame.
myDf.withColumn("CONCAT", readFileUdf.apply(Functions.col("NAME"))).show();

-- Example 16261
public StructType outputSchema()

-- Example 16262
public StructType outputSchema() {
  return StructType.create(new StructField("C1", DataTypes.IntegerType));
}

-- Example 16263
Stream<Row> process(A0 arg0, ... A<n> arg<n>)

-- Example 16264
Stream<Row> process(A0 arg0, A1 arg1)

-- Example 16265
import java.util.stream.Stream;
...

public Stream<Row> process(Integer start, Integer count) {
  Stream.Builder<Row> builder = Stream.builder();
  for (int i = start; i < start + count ; i++) {
    builder.add(Row.create(i));
  }
  return builder.build();
}

-- Example 16266
import java.util.Map;
import com.snowflake.snowpark_java.*;
import com.snowflake.snowpark_java.types.*;
...

public Stream<Row> process(Map<String, String> stringMap, Map<String, Variant> varMap) {
  ...
}

-- Example 16267
import java.util.Map;
import com.snowflake.snowpark_java.types.*;
...

public StructType inputSchema() {
  return StructType.create(
      new StructField(
          "string_map",
          DataTypes.createMapType(DataTypes.StringType, DataTypes.StringType)),
      new StructField(
          "variant_map",
          DataTypes.createMapType(DataTypes.StringType, DataTypes.VariantType)));
}

-- Example 16268
public Stream<Row> endPartition()

-- Example 16269
public Stream<Row> endPartition() {
  return Stream.empty();
}

-- Example 16270
import java.util.stream.Stream;
import com.snowflake.snowpark_java.types.*;
import com.snowflake.snowpark_java.udtf.*;

class MyRangeUdtf implements JavaUDTF2<Integer, Integer> {
  public StructType outputSchema() {
    return StructType.create(new StructField("C1", DataTypes.IntegerType));
  }

  // Because the process() method in this example does not pass in Map arguments,
  // implementing the inputSchema() method is optional.
  public StructType inputSchema() {
    return StructType.create(
            new StructField("start_value", DataTypes.IntegerType),
            new StructField("value_count", DataTypes.IntegerType));
  }

  public Stream<Row> endPartition() {
    return Stream.empty();
  }

  public Stream<Row> process(Integer start, Integer count) {
    Stream.Builder<Row> builder = Stream.builder();
    for (int i = start; i < start + count ; i++) {
      builder.add(Row.create(i));
    }
    return builder.build();
  }
}

-- Example 16271
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary(new MyRangeUdtf());
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 16272
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary("myUdtf", new MyRangeUdtf());
// Call the UDTF by name.
session.tableFunction(new TableFunction("myUdtf"), Functions.lit(10), Functions.lit(5)).show();

-- Example 16273
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerPermanent("myUdtf", new MyRangeUdtf(), "@myStage");
// Call the UDTF by name.
session.tableFunction(new TableFunction("myUdtf"), Functions.lit(10), Functions.lit(5)).show();

-- Example 16274
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary(new MyRangeUdtf());
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 16275
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary("myUdtf", new MyRangeUdtf());
// Call the UDTF by name.
session.tableFunction(new TableFunction("myUdtf"), Functions.lit(10), Functions.lit(5)).show();

-- Example 16276
session.sql("select * from table(myUdtf(10, 5))");

-- Example 16277
import com.snowflake.snowpark_java.types.*;
...

// Create and register an anonymous UDF (doubleUdf)
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  Functions.udf((Integer x) -> x + x, DataTypes.IntegerType, DataTypes.IntegerType);
// Call the anonymous UDF.
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", doubleUdf.apply(Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16278
import com.snowflake.snowpark_java.types.*;
...

// Create and register a permanent named UDF ("doubleUdf")
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerPermanent(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType,
      "mystage");
// Call the named UDF.
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16279
// Add a JAR file that you uploaded to a stage.
session.addDependency("@my_stage/<path>/my-library.jar");

-- Example 16280
// Add a JAR file on your local machine.
session.addDependency("/<path>/my-library.jar");

// Add a directory of resource files.
session.addDependency("/<path>/my-resource-dir/");

// Add a resource file.
session.addDependency("/<path>/my-resource.xml");

-- Example 16281
-- Put the Snowpark JAR file in a stage.
PUT file:///<path>/snowpark-1.15.0.jar @mystage

-- Example 16282
// Add the Snowpark JAR file that you uploaded to a stage.
session.addDependency("@mystage/snowpark-1.15.0.jar.gz");

-- Example 16283
import com.snowflake.snowpark_java.types.*;
...

// Create and register an anonymous UDF
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  Functions.udf((Integer x) -> x + x, DataTypes.IntegerType, DataTypes.IntegerType);
// Call the anonymous UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", doubleUdf.apply(Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16284
import com.snowflake.snowpark_java.types.*;

// Import the package for your custom code.
// The custom code in this example detects the language of textual data.
import com.mycompany.LanguageDetector;

// If the custom code is packaged in a JAR file, add that JAR file as
// a dependency.
session.addDependency("$HOME/language-detector.jar");

// Create a detector
LanguageDetector detector = new LanguageDetector();

// Create an anonymous UDF that takes a string of text and returns the language used in that string.
// Note that this captures the detector object created above.
// Assign the UDF to the langUdf variable, which will be used to call the UDF.
UserDefinedFunction langUdf =
  Functions.udf(
    (String s) -> Option(detector.detect(s)).getOrElse("UNKNOWN"),
    DataTypes.StringType,
    DataTypes.StringType);

// Create a new DataFrame that contains an additional "lang" column that contains the language
// detected by the UDF.
DataFrame dfEmailsWithLangCol =
    dfEmails.withColumn("lang", langUdf(Functions.col("text_data")));

-- Example 16285
import com.snowflake.snowpark_java.types.*;
...
// Create and register a temporary named UDF
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerTemporary(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType);
// Call the named UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16286
import com.snowflake.snowpark_java.types.*;
...

// Create and register a permanent named UDF
// that takes in an integer argument and returns an integer value.
// Specify that the UDF and dependent JAR files should be uploaded to
// the internal stage named mystage.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerPermanent(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType,
      "mystage");
// Call the named UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16287
Exception in thread "main" java.io.NotSerializableException: <YourObjectName>

-- Example 16288
import com.snowflake.snowpark_java.*;
import com.snowflake.snowpark_java.types.*;
import java.io.Serializable;

// Context needed for a UDF.
class Context {
  double randomInt = Math.random();
}

// Serializable context needed for the UDF.
class SerContext implements Serializable {
  double randomInt = Math.random();
}

class TestUdf {
  public static void main(String[] args) {
    // Create the session.
    Session session = Session.builder().configFile("/<path>/profile.properties").create();
    session.range(1, 10, 2).show();

    // Create a DataFrame with two columns ("c" and "d").
    DataFrame dummy =
      session.createDataFrame(
        new Row[]{
          Row.create(1, 1),
          Row.create(2, 2),
          Row.create(3, 3)
        },
        StructType.create(
          new StructField("c", DataTypes.IntegerType),
          new StructField("d", DataTypes.IntegerType))
        );
    dummy.show();

    // Initialize the context once per invocation.
    UserDefinedFunction udfRepeatedInit =
      Functions.udf(
        (Integer i) -> new Context().randomInt,
        DataTypes.IntegerType,
        DataTypes.DoubleType
      );
    dummy.select(udfRepeatedInit.apply(dummy.col("c"))).show();

    // Initialize the serializable context only once,
    // regardless of the number of times that the UDF is invoked.
    SerContext sC = new SerContext();
    UserDefinedFunction udfOnceInit =
      Functions.udf(
        (Integer i) -> sC.randomInt,
        DataTypes.IntegerType,
        DataTypes.DoubleType
      );
    dummy.select(udfOnceInit.apply(dummy.col("c"))).show();
    UserDefinedFunction udfOnceInit = udf((i: Int) => sC.randomInt);
  }
}

-- Example 16289
# Create a new JAR file containing data/hello.txt.
$ jar cvf <path>/myJar.jar data/hello.txt

-- Example 16290
// Specify that myJar.jar contains files that your UDF depends on.
session.addDependency("<path>/myJar.jar");

-- Example 16291
// Read data/hello.txt from myJar.jar.
String resourceName = "/data/hello.txt";
InputStream inputStream = Class.forName("com.snowflake.snowpark_java.DataFrame").getResourceAsStream(resourceName);

-- Example 16292
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

// Create a function class that reads a file.
class UDFCode {
  private static String fileContent = null;
  // The code in this block reads the file. To prevent this code from executing each time that the UDF is called,
  // The file content is cached in 'fileContent'.
  public static String readFile() {
    if (fileContent == null) {
      try {
        String resourceName = "/data/hello.txt";
        InputStream inputStream = Class.forName("com.snowflake.snowpark_java.DataFrame")
          .getResourceAsStream(resourceName);
        fileContent = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
      } catch (Exception e) {
        fileContent = "Error while reading file";
      }
    }
    return fileContent;
  }
}

-- Example 16293
import com.snowflake.snowpark_java.types.*;

// Add the JAR file as a dependency.
session.addDependency("<path>/myJar.jar");

// Create a new DataFrame with one column (NAME)
// that contains the name "Raymond".
DataFrame myDf = session.sql("select 'Raymond' NAME");

// Register the function that you defined earlier as an anonymous UDF.
UserDefinedFunction readFileUdf = session.udf().registerTemporary(
  (String s) -> UDFCode.readFile() + " : " + s, DataTypes.StringType, DataTypes.StringType);

// Call UDF for the values in the NAME column of the DataFrame.
myDf.withColumn("CONCAT", readFileUdf.apply(Functions.col("NAME"))).show();

-- Example 16294
public StructType outputSchema()

-- Example 16295
public StructType outputSchema() {
  return StructType.create(new StructField("C1", DataTypes.IntegerType));
}

-- Example 16296
Stream<Row> process(A0 arg0, ... A<n> arg<n>)

-- Example 16297
Stream<Row> process(A0 arg0, A1 arg1)

-- Example 16298
import java.util.stream.Stream;
...

public Stream<Row> process(Integer start, Integer count) {
  Stream.Builder<Row> builder = Stream.builder();
  for (int i = start; i < start + count ; i++) {
    builder.add(Row.create(i));
  }
  return builder.build();
}

-- Example 16299
import java.util.Map;
import com.snowflake.snowpark_java.*;
import com.snowflake.snowpark_java.types.*;
...

public Stream<Row> process(Map<String, String> stringMap, Map<String, Variant> varMap) {
  ...
}

-- Example 16300
import java.util.Map;
import com.snowflake.snowpark_java.types.*;
...

public StructType inputSchema() {
  return StructType.create(
      new StructField(
          "string_map",
          DataTypes.createMapType(DataTypes.StringType, DataTypes.StringType)),
      new StructField(
          "variant_map",
          DataTypes.createMapType(DataTypes.StringType, DataTypes.VariantType)));
}

-- Example 16301
public Stream<Row> endPartition()

-- Example 16302
public Stream<Row> endPartition() {
  return Stream.empty();
}

-- Example 16303
import java.util.stream.Stream;
import com.snowflake.snowpark_java.types.*;
import com.snowflake.snowpark_java.udtf.*;

class MyRangeUdtf implements JavaUDTF2<Integer, Integer> {
  public StructType outputSchema() {
    return StructType.create(new StructField("C1", DataTypes.IntegerType));
  }

  // Because the process() method in this example does not pass in Map arguments,
  // implementing the inputSchema() method is optional.
  public StructType inputSchema() {
    return StructType.create(
            new StructField("start_value", DataTypes.IntegerType),
            new StructField("value_count", DataTypes.IntegerType));
  }

  public Stream<Row> endPartition() {
    return Stream.empty();
  }

  public Stream<Row> process(Integer start, Integer count) {
    Stream.Builder<Row> builder = Stream.builder();
    for (int i = start; i < start + count ; i++) {
      builder.add(Row.create(i));
    }
    return builder.build();
  }
}

-- Example 16304
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary(new MyRangeUdtf());
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 16305
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary("myUdtf", new MyRangeUdtf());
// Call the UDTF by name.
session.tableFunction(new TableFunction("myUdtf"), Functions.lit(10), Functions.lit(5)).show();

-- Example 16306
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerPermanent("myUdtf", new MyRangeUdtf(), "@myStage");
// Call the UDTF by name.
session.tableFunction(new TableFunction("myUdtf"), Functions.lit(10), Functions.lit(5)).show();

-- Example 16307
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary(new MyRangeUdtf());
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 16308
// Register the MyRangeUdtf class that was defined in the previous example.
TableFunction tableFunction = session.udtf().registerTemporary("myUdtf", new MyRangeUdtf());
// Call the UDTF by name.
session.tableFunction(new TableFunction("myUdtf"), Functions.lit(10), Functions.lit(5)).show();

-- Example 16309
session.sql("select * from table(myUdtf(10, 5))");

-- Example 16310
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
  df_table = session.table("sample_product_data")

-- Example 16311
# Add a zip file that you uploaded to a stage.
session.add_import("@my_stage/<path>/my_library.zip")

-- Example 16312
# Import a Python file from your local machine.
session.add_import("/<path>/my_module.py")

# Import a Python file from your local machine and specify a relative Python import path.
session.add_import("/<path>/my_module.py", import_path="my_dir.my_module")

-- Example 16313
# Add a directory of resource files.
session.add_import("/<path>/my-resource-dir/")

# Add a resource file.
session.add_import("/<path>/my-resource.xml")

-- Example 16314
import numpy as np
import pandas as pd
import xgboost as xgb
from snowflake.snowpark.functions import udf

session.add_packages("numpy", "pandas", "xgboost==1.5.0")

@udf
def compute() -> list:
  return [np.__version__, pd.__version__, xgb.__version__]

-- Example 16315
session.add_requirements("mydir/requirements.txt")

-- Example 16316
import numpy as np
import pandas as pd
import xgboost as xgb
from snowflake.snowpark.functions import udf

@udf(packages=["numpy", "pandas", "xgboost==1.5.0"])
  def compute() -> list:
  return [np.__version__, pd.__version__, xgb.__version__]

-- Example 16317
from snowflake.snowpark.types import IntegerType
from snowflake.snowpark.functions import udf

add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()])

-- Example 16318
from snowflake.snowpark.types import IntegerType
from snowflake.snowpark.functions import udf

add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()], name="my_udf", replace=True)

-- Example 16319
@udf(name="minus_one", is_permanent=True, stage_location="@my_stage", replace=True)
def minus_one(x: int) -> int:
  return x-1

-- Example 16320
df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
df.select(add_one("a"), minus_one("b")).collect()

-- Example 16321
[Row(MY_UDF("A")=2, MINUS_ONE("B")=1), Row(MY_UDF("A")=4, MINUS_ONE("B")=3)]

-- Example 16322
session.sql("select minus_one(1)").collect()

-- Example 16323
[Row(MINUS_ONE(1)=0)]

-- Example 16324
def mod5(x: int) -> int:
  return x % 5

-- Example 16325
# mod5() in that file has type hints
mod5_udf = session.udf.register_from_file(
  file_path="tests/resources/test_udf_dir/test_udf_file.py",
  func_name="mod5",
)
session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()

-- Example 16326
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

