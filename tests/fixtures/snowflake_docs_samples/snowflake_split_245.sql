-- Example 16394
-- A basic UDF to read a file:
CREATE OR REPLACE FUNCTION read_udf(filename string)
RETURNS STRING
LANGUAGE PYTHON
VOLATILE
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'read'
AS
'
from snowflake.snowpark.files import SnowflakeFile

def read(filename):
  return SnowflakeFile.open(filename, "r").read()
';

-- Example 16395
-- Create files_to_convert as in Example 2.

SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file)) as new_file
  FROM files_to_convert;
-- The following query must be run within 24 hours from the prior one
SELECT read_udf(new_file) FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- Example 16396
-- Set up files_to_convert as in Example 2.
-- Set up read_udf as in Example 4.

SELECT read_udf(
    convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file))) FROM files_to_convert;

-- Example 16397
COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file)) FROM files_to_convert);

-- Refresh the directory to get new files in output_stage.
ALTER STAGE output_stage REFRESH;

-- Example 16398
-- Create a stage that includes the font (for PDF creation)

CREATE OR REPLACE STAGE fonts
URL = 's3://sfquickstarts/misc/';

-- UDF to write the data
CREATE OR REPLACE FUNCTION create_report_pdf(data string)
RETURNS TABLE (file string)
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
HANDLER='CreateReport'
PACKAGES = ('snowflake-snowpark-python', 'fpdf')
IMPORTS  = ('@fonts/DejaVuSans.ttf')
AS $$
from snowflake.snowpark.files import SnowflakeFile
from fpdf import FPDF
import shutil
import sys
import uuid
import_dir = sys._xoptions["snowflake_import_directory"]

class CreateReport:
  def __init__(self):
      self.pdf = None

  def process(self, data):
      if self.pdf == None:
        # PDF library edits this file, make sure it's unique.
        font_file = f'/tmp/DejaVuSans-{uuid.uuid4()}.ttf'
        shutil.copy(f'{import_dir}/DejaVuSans.ttf', font_file)
        self.pdf = FPDF()
        self.pdf.add_page()
        self.pdf.add_font('DejaVu', '', font_file, uni=True)
        self.pdf.set_font('DejaVu', '', 14)
      self.pdf.write(8, data)
      self.pdf.ln(8)

  def end_partition(self):
      f = SnowflakeFile.open_new_result("wb")
      f.write(self.pdf.output(dest='S').encode('latin-1'))
      yield f,
$$;

-- Example 16399
-- Fictitious data
 CREATE OR REPLACE TABLE reportData(location string, item string);
 INSERT INTO reportData VALUES ('SanMateo' ,'Item A');
 INSERT INTO reportData VALUES ('SanMateo' ,'Item Z');
 INSERT INTO reportData VALUES ('SanMateo' ,'Item X');
 INSERT INTO reportData VALUES ('Bellevue' ,'Item B');
 INSERT INTO reportData VALUES ('Bellevue' ,'Item Q');

 -- Presigned URLs only work with SSE stages, see note above.
 CREATE OR REPLACE STAGE output_stage ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

 COPY FILES INTO @output_stage
   FROM (SELECT reports.file, location || '.pdf'
           FROM reportData, TABLE(create_report_pdf(item)
           OVER (partition BY location)) AS reports);

 -- Check the results
LIST @output_stage;
SELECT GET_PRESIGNED_URL(@output_stage, 'SanMateo.pdf');

-- Example 16400
CREATE OR REPLACE FUNCTION split_file(path string)
RETURNS TABLE(file string, name string)
LANGUAGE PYTHON
VOLATILE
PACKAGES = ('snowflake-snowpark-python')
RUNTIME_VERSION = 3.9
HANDLER = 'SplitCsvFile'
AS $$
import csv
from snowflake.snowpark.files import SnowflakeFile

class SplitCsvFile:
    def process(self, file):
      toTable1 = SnowflakeFile.open_new_result("w")
      toTable1Csv = csv.writer(toTable1)
      toTable2 = SnowflakeFile.open_new_result("w")
      toTable2Csv = csv.writer(toTable2)
      toTable3 = SnowflakeFile.open_new_result("w")
      toTable3Csv = csv.writer(toTable3)
      with SnowflakeFile.open(file, 'r') as file:
        # File is of the format 1:itemA \n 2:itemB \n [...]
        for line in file.readlines():
          forTable = line[0]
          if (forTable == "1"):
            toTable1Csv.writerow([line[2:-1]])
          if (forTable == "2"):
            toTable2Csv.writerow([line[2:-1]])
          if (forTable == "3"):
            toTable3Csv.writerow([line[2:-1]])
      yield toTable1, 'table1.csv'
      yield toTable2, 'table2.csv'
      yield toTable3, 'table3.csv'
$$;
-- Create a stage with access to an import file.
CREATE OR REPLACE STAGE staged_files url="s3://sfquickstarts/misc/";

-- Add the files to be split into a table - we just add one.
CREATE OR REPLACE TABLE filesToSplit(path string);
INSERT INTO filesToSplit VALUES ( 'items.txt');

-- Create output tables
CREATE OR REPLACE TABLE table1(item string);
CREATE OR REPLACE TABLE table2(item string);
CREATE OR REPLACE TABLE table3(item string);

-- Create output stage
CREATE OR REPLACE stage output_stage;

-- Creates files named path-tableX.csv
COPY FILES INTO @output_stage FROM
  (SELECT file, path || '-' || name FROM filesToSplit, TABLE(split_file(build_scoped_file_url(@staged_files, path))));

-- We use pattern and COPY INTO (not COPY FILES INTO) to upload to a final table.
COPY INTO table1 FROM @output_stage PATTERN = '.*.table1.csv';
COPY INTO table2 FROM @output_stage PATTERN = '.*.table2.csv';
COPY INTO table3 FROM @output_stage PATTERN = '.*.table3.csv';

-- See results
SELECT * from table1;
SELECT * from table2;
SELECT * from table3;

-- Example 16401
from sklearn.linear_model import LinearRegression
model = LinearRegression()
model.fit(X, y)

@udf(packages=['pandas', 'scikit-learn','xgboost'])
def predict(df: PandasDataFrame[float, float, float, float]) -> PandasSeries[float]:
    # The input pandas DataFrame doesn't include column names. Specify the column names explicitly when needed.
    df.columns = ["col1", "col2", "col3", "col4"]
    return model.predict(df)

-- Example 16402
// Create and register an anonymous UDF (doubleUdf).
val doubleUdf = udf((x: Int) => x + x)
// Call the anonymous UDF.
val dfWithDoubleNum = df.withColumn("doubleNum", doubleUdf(col("num")))

-- Example 16403
// Create and register a permanent named UDF ("doubleUdf").
session.udf.registerPermanent("doubleUdf", (x: Int) => x + x, "mystage")
// Call the named UDF.
val dfWithDoubleNum = df.withColumn("doubleNum", callUDF("doubleUdf", col("num")))

-- Example 16404
object Main extends App {
  ...
  // Initialize a field.
  val myConst = "Prefix "
  // Use the field in a UDF.
  // Because the App trait delays the initialization of the object fields,
  // myConst in the UDF definition resolves to null.
  val myUdf = udf((s : String) =>  myConst + s )
  ...
}

-- Example 16405
object Main {
  ...
  def main(args: Array[String]): Unit = {
    ... // Your code ...
  }
  ...
}

-- Example 16406
// If you used the run.sh script to start the Scala REPL, call this to add the REPL classes directory as a dependency.
session.addDependency("<path_to_directory_where_you_ran_run.sh>/repl_classes/")

-- Example 16407
// Add a JAR file that you uploaded to a stage.
session.addDependency("@my_stage/<path>/my-library.jar")

-- Example 16408
// Add a JAR file on your local machine.
session.addDependency("/<path>/my-library.jar")

// Add a directory of resource files.
session.addDependency("/<path>/my-resource-dir/")

// Add a resource file.
session.addDependency("/<path>/my-resource.xml")

-- Example 16409
-- Put the Snowpark JAR file in a stage.
PUT file:///<path>/snowpark-1.15.0.jar @mystage

-- Example 16410
// Add the Snowpark JAR file that you uploaded to a stage.
session.addDependency("@mystage/snowpark-1.15.0.jar.gz")

-- Example 16411
// Create and register an anonymous UDF.
val doubleUdf = udf((x: Int) => x + x)
// Call the anonymous UDF, passing in the "num" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleNum".
val dfWithDoubleNum = df.withColumn("doubleNum", doubleUdf(col("num")))

-- Example 16412
// Create and register an anonymous UDF.
val appendUdf = udf((x: Array[String]) => x.map(a => a + " x"))
// Call the anonymous UDF, passing in the "a" column, which holds an ARRAY.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "appended".
val dfWithXAppended = df.withColumn("appended", appendUdf(col("a")))

-- Example 16413
// Import the udf function from the functions object.
import com.snowflake.snowpark.functions._

// Import the package for your custom code.
// The custom code in this example detects the language of textual data.
import com.mycompany.LanguageDetector

// If the custom code is packaged in a JAR file, add that JAR file as
// a dependency.
session.addDependency("$HOME/language-detector.jar")

// Create a detector
val detector = new LanguageDetector()

// Create an anonymous UDF that takes a string of text and returns the language used in that string.
// Note that this captures the detector object created above.
// Assign the UDF to the langUdf variable, which will be used to call the UDF.
val langUdf = udf((s: String) =>
     Option(detector.detect(s)).getOrElse("UNKNOWN"))

// Create a new DataFrame that contains an additional "lang" column that contains the language
// detected by the UDF.
val dfEmailsWithLangCol =
    dfEmails.withColumn("lang", langUdf(col("text_data")))

-- Example 16414
// Create and register a temporary named UDF.
session.udf.registerTemporary("doubleUdf", (x: Int) => x + x)
// Call the named UDF, passing in the "num" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleNum".
val dfWithDoubleNum = df.withColumn("doubleNum", callUDF("doubleUdf", col("num")))

-- Example 16415
// Create and register a permanent named UDF.
// Specify that the UDF and dependent JAR files should be uploaded to
// the internal stage named mystage.
session.udf.registerPermanent("doubleUdf", (x: Int) => x + x, "mystage")
// Call the named UDF, passing in the "num" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleNum".
val dfWithDoubleNum = df.withColumn("doubleNum", callUDF("doubleUdf", col("num")))

-- Example 16416
// Class containing a function that implements your UDF.
class MyUDFCode( ... ) extends Serializable {
  val myUserDefinedFunc = (s: String) => {
    ...
  }
}
val myUdf = udf((new MyUDFCode(resourceName)).myUserDefinedFunc)

-- Example 16417
In [1]:

-- Example 16418
val prefix = "Hello"

-- Example 16419
In [2]:

-- Example 16420
// resourceName is the argument for the variable defined in another cell.
class UDFCode(var prefix: String) extends Serializable {
  val prependPrefixFunc = (s: String) => {
    s"$prefix $s"
  }
}

// When constructing UDFCode, pass in the variable (resourceName) that is defined in another cell.
val prependPrefixUdf = udf((new UDFCode(prefix)).prependPrefixFunc)
val myDf = session.sql("select 'Raymond' NAME")
myDf.withColumn("CONCAT", prependPrefixUdf(col("NAME"))).show()

-- Example 16421
Exception in thread "main" java.io.NotSerializableException: <YourObjectName>

-- Example 16422
// Declare the detector object as lazy.
lazy val detector = new LanguageDetector("en")
// The detector object is not serialized but is instead reconstructed on the server.
val langUdf = udf((s: String) =>
     Option(detector.detect(s)).getOrElse("UNKNOWN"))

-- Example 16423
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._
import scala.util.Random

// Context needed for a UDF.
class Context {
  val randomInt = Random.nextInt
}

// Serializable context needed for the UDF.
class SerContext extends Serializable {
  val randomInt = Random.nextInt
}

object TestUdf {
  def main(args: Array[String]): Unit = {
    // Create the session.
    val session = Session.builder.configFile("/<path>/profile.properties").create
    import session.implicits._
    session.range(1, 10, 2).show()

    // Create a DataFrame with two columns ("c" and "d").
    val dummy = session.createDataFrame(Seq((1, 1), (2, 2), (3, 3))).toDF("c", "d")
    dummy.show()

    // Initialize the context once per invocation.
    val udfRepeatedInit = udf((i: Int) => (new Context).randomInt)
    dummy.select(udfRepeatedInit('c)).show()

    // Initialize the serializable context only once,
    // regardless of the number of times that the UDF is invoked.
    val sC = new SerContext
    val udfOnceInit = udf((i: Int) => sC.randomInt)
    dummy.select(udfOnceInit('c)).show()

    // Initialize the non-serializable context only once,
    // regardless of the number of times that the UDF is invoked.
    lazy val unserC = new Context
    val udfOnceInitU = udf((i: Int) => unserC.randomInt)
    dummy.select(udfOnceInitU('c)).show()
  }
}

-- Example 16424
# Create a new JAR file containing data/hello.txt.
$ jar cvf <path>/myJar.jar data/hello.txt

-- Example 16425
// Specify that myJar.jar contains files that your UDF depends on.
session.addDependency("<path>/myJar.jar")

-- Example 16426
// Read data/hello.txt from myJar.jar.
val resourceName = "/data/hello.txt"
val inputStream = classOf[com.snowflake.snowpark.DataFrame].getResourceAsStream(resourceName)

-- Example 16427
// Create a function object that reads a file.
object UDFCode extends Serializable {

  // The code in this block reads the file. To prevent this code from executing each time that the UDF is called,
  // the code is used in the definition of a lazy val. The code for a lazy val is executed only once when the variable is
  // first accessed.
  lazy val prefix = {
    import java.io._
    val resourceName = "/data/hello.txt"
    val inputStream = classOf[com.snowflake.snowpark.DataFrame]
      .getResourceAsStream(resourceName)
    if (inputStream == null) {
      throw new Exception("Can't find file " + resourceName)
    }
    scala.io.Source.fromInputStream(inputStream).mkString
  }

  val readFileFunc = (s: String) => prefix + " : " + s
}

-- Example 16428
// Add the JAR file as a dependency.
session.addDependency("<path>/myJar.jar")

// Create a new DataFrame with one column (NAME)
// that contains the name "Raymond".
val myDf = session.sql("select 'Raymond' NAME")

// Register the function that you defined earlier as an anonymous UDF.
val readFileUdf = udf(UDFCode.readFileFunc)

// Call UDF for the values in the NAME column of the DataFrame.
myDf.withColumn("CONCAT", readFileUdf(col("NAME"))).show()

-- Example 16429
def outputSchema(): StructType

-- Example 16430
override def outputSchema(): StructType = StructType(StructField("C1", IntegerType))

-- Example 16431
def process(arg0: A0, ... arg<n> A<n>): Iterable[Row]

-- Example 16432
def process(arg0: A0, arg1: A1): Iterable[Row]

-- Example 16433
override def process(start: Int, count: Int): Iterable[Row] =
    (start until (start + count)).map(Row(_))

-- Example 16434
def endPartition(): Iterable[Row]

-- Example 16435
override def endPartition(): Iterable[Row] = Array.empty[Row]

-- Example 16436
class MyRangeUdtf extends UDTF2[Int, Int] {
  override def process(start: Int, count: Int): Iterable[Row] =
    (start until (start + count)).map(Row(_))
  override def endPartition(): Iterable[Row] = Array.empty[Row]
  override def outputSchema(): StructType = StructType(StructField("C1", IntegerType))
}

-- Example 16437
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary(new MyRangeUdtf())
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 16438
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
// Call the UDTF by name.
session.tableFunction(TableFunction("myUdtf"), lit(10), lit(5)).show()

-- Example 16439
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerPermanent("myUdtf", new MyRangeUdtf(), "@mystage")
// Call the UDTF by name.
session.tableFunction(TableFunction("myUdtf"), lit(10), lit(5)).show()

-- Example 16440
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary(new MyRangeUdtf())
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, lit(10), lit(5)).show()

-- Example 16441
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
// Call the UDTF by name.
session.tableFunction(TableFunction("myUdtf"), lit(10), lit(5)).show()

-- Example 16442
session.sql("select * from table(myUdtf(10, 5))")

-- Example 16443
// Create and register an anonymous UDF (doubleUdf).
val doubleUdf = udf((x: Int) => x + x)
// Call the anonymous UDF.
val dfWithDoubleNum = df.withColumn("doubleNum", doubleUdf(col("num")))

-- Example 16444
// Create and register a permanent named UDF ("doubleUdf").
session.udf.registerPermanent("doubleUdf", (x: Int) => x + x, "mystage")
// Call the named UDF.
val dfWithDoubleNum = df.withColumn("doubleNum", callUDF("doubleUdf", col("num")))

-- Example 16445
object Main extends App {
  ...
  // Initialize a field.
  val myConst = "Prefix "
  // Use the field in a UDF.
  // Because the App trait delays the initialization of the object fields,
  // myConst in the UDF definition resolves to null.
  val myUdf = udf((s : String) =>  myConst + s )
  ...
}

-- Example 16446
object Main {
  ...
  def main(args: Array[String]): Unit = {
    ... // Your code ...
  }
  ...
}

-- Example 16447
// If you used the run.sh script to start the Scala REPL, call this to add the REPL classes directory as a dependency.
session.addDependency("<path_to_directory_where_you_ran_run.sh>/repl_classes/")

-- Example 16448
// Add a JAR file that you uploaded to a stage.
session.addDependency("@my_stage/<path>/my-library.jar")

-- Example 16449
// Add a JAR file on your local machine.
session.addDependency("/<path>/my-library.jar")

// Add a directory of resource files.
session.addDependency("/<path>/my-resource-dir/")

// Add a resource file.
session.addDependency("/<path>/my-resource.xml")

-- Example 16450
-- Put the Snowpark JAR file in a stage.
PUT file:///<path>/snowpark-1.15.0.jar @mystage

-- Example 16451
// Add the Snowpark JAR file that you uploaded to a stage.
session.addDependency("@mystage/snowpark-1.15.0.jar.gz")

-- Example 16452
// Create and register an anonymous UDF.
val doubleUdf = udf((x: Int) => x + x)
// Call the anonymous UDF, passing in the "num" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleNum".
val dfWithDoubleNum = df.withColumn("doubleNum", doubleUdf(col("num")))

-- Example 16453
// Create and register an anonymous UDF.
val appendUdf = udf((x: Array[String]) => x.map(a => a + " x"))
// Call the anonymous UDF, passing in the "a" column, which holds an ARRAY.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "appended".
val dfWithXAppended = df.withColumn("appended", appendUdf(col("a")))

-- Example 16454
// Import the udf function from the functions object.
import com.snowflake.snowpark.functions._

// Import the package for your custom code.
// The custom code in this example detects the language of textual data.
import com.mycompany.LanguageDetector

// If the custom code is packaged in a JAR file, add that JAR file as
// a dependency.
session.addDependency("$HOME/language-detector.jar")

// Create a detector
val detector = new LanguageDetector()

// Create an anonymous UDF that takes a string of text and returns the language used in that string.
// Note that this captures the detector object created above.
// Assign the UDF to the langUdf variable, which will be used to call the UDF.
val langUdf = udf((s: String) =>
     Option(detector.detect(s)).getOrElse("UNKNOWN"))

// Create a new DataFrame that contains an additional "lang" column that contains the language
// detected by the UDF.
val dfEmailsWithLangCol =
    dfEmails.withColumn("lang", langUdf(col("text_data")))

-- Example 16455
// Create and register a temporary named UDF.
session.udf.registerTemporary("doubleUdf", (x: Int) => x + x)
// Call the named UDF, passing in the "num" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleNum".
val dfWithDoubleNum = df.withColumn("doubleNum", callUDF("doubleUdf", col("num")))

-- Example 16456
// Create and register a permanent named UDF.
// Specify that the UDF and dependent JAR files should be uploaded to
// the internal stage named mystage.
session.udf.registerPermanent("doubleUdf", (x: Int) => x + x, "mystage")
// Call the named UDF, passing in the "num" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleNum".
val dfWithDoubleNum = df.withColumn("doubleNum", callUDF("doubleUdf", col("num")))

-- Example 16457
// Class containing a function that implements your UDF.
class MyUDFCode( ... ) extends Serializable {
  val myUserDefinedFunc = (s: String) => {
    ...
  }
}
val myUdf = udf((new MyUDFCode(resourceName)).myUserDefinedFunc)

-- Example 16458
In [1]:

-- Example 16459
val prefix = "Hello"

-- Example 16460
In [2]:

