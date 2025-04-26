-- Example 16461
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

-- Example 16462
Exception in thread "main" java.io.NotSerializableException: <YourObjectName>

-- Example 16463
// Declare the detector object as lazy.
lazy val detector = new LanguageDetector("en")
// The detector object is not serialized but is instead reconstructed on the server.
val langUdf = udf((s: String) =>
     Option(detector.detect(s)).getOrElse("UNKNOWN"))

-- Example 16464
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

-- Example 16465
# Create a new JAR file containing data/hello.txt.
$ jar cvf <path>/myJar.jar data/hello.txt

-- Example 16466
// Specify that myJar.jar contains files that your UDF depends on.
session.addDependency("<path>/myJar.jar")

-- Example 16467
// Read data/hello.txt from myJar.jar.
val resourceName = "/data/hello.txt"
val inputStream = classOf[com.snowflake.snowpark.DataFrame].getResourceAsStream(resourceName)

-- Example 16468
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

-- Example 16469
// Add the JAR file as a dependency.
session.addDependency("<path>/myJar.jar")

// Create a new DataFrame with one column (NAME)
// that contains the name "Raymond".
val myDf = session.sql("select 'Raymond' NAME")

// Register the function that you defined earlier as an anonymous UDF.
val readFileUdf = udf(UDFCode.readFileFunc)

// Call UDF for the values in the NAME column of the DataFrame.
myDf.withColumn("CONCAT", readFileUdf(col("NAME"))).show()

-- Example 16470
def outputSchema(): StructType

-- Example 16471
override def outputSchema(): StructType = StructType(StructField("C1", IntegerType))

-- Example 16472
def process(arg0: A0, ... arg<n> A<n>): Iterable[Row]

-- Example 16473
def process(arg0: A0, arg1: A1): Iterable[Row]

-- Example 16474
override def process(start: Int, count: Int): Iterable[Row] =
    (start until (start + count)).map(Row(_))

-- Example 16475
def endPartition(): Iterable[Row]

-- Example 16476
override def endPartition(): Iterable[Row] = Array.empty[Row]

-- Example 16477
class MyRangeUdtf extends UDTF2[Int, Int] {
  override def process(start: Int, count: Int): Iterable[Row] =
    (start until (start + count)).map(Row(_))
  override def endPartition(): Iterable[Row] = Array.empty[Row]
  override def outputSchema(): StructType = StructType(StructField("C1", IntegerType))
}

-- Example 16478
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary(new MyRangeUdtf())
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, lit(10), lit(5)).show

-- Example 16479
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
// Call the UDTF by name.
session.tableFunction(TableFunction("myUdtf"), lit(10), lit(5)).show()

-- Example 16480
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerPermanent("myUdtf", new MyRangeUdtf(), "@mystage")
// Call the UDTF by name.
session.tableFunction(TableFunction("myUdtf"), lit(10), lit(5)).show()

-- Example 16481
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary(new MyRangeUdtf())
// Use the returned TableFunction object to call the UDTF.
session.tableFunction(tableFunction, lit(10), lit(5)).show()

-- Example 16482
// Register the MyRangeUdtf class that was defined in the previous example.
val tableFunction = session.udtf.registerTemporary("myUdtf", new MyRangeUdtf())
// Call the UDTF by name.
session.tableFunction(TableFunction("myUdtf"), lit(10), lit(5)).show()

-- Example 16483
session.sql("select * from table(myUdtf(10, 5))")

-- Example 16484
-- Create an internal stage to store the JAR files.
CREATE OR REPLACE STAGE jars_stage;

-- Create an internal stage to store the data files. The stage includes a directory table.
CREATE OR REPLACE STAGE data_stage DIRECTORY=(ENABLE=TRUE) ENCRYPTION = (TYPE='SNOWFLAKE_SSE');

-- Example 16485
PUT file:///tmp/pdfbox-app-2.0.27.jar @jars_stage AUTO_COMPRESS=FALSE;

-- Example 16486
PUT file://C:\temp\pdfbox-app-2.0.27.jar @jars_stage AUTO_COMPRESS=FALSE;

-- Example 16487
PUT file:///tmp/myfile.pdf @data_stage AUTO_COMPRESS=FALSE;

-- Example 16488
PUT file://C:\temp\myfile.pdf @data_stage AUTO_COMPRESS=FALSE;

-- Example 16489
CREATE FUNCTION process_pdf_func(file STRING)
RETURNS STRING
LANGUAGE JAVA
RUNTIME_VERSION = 11
IMPORTS = ('@jars_stage/pdfbox-app-2.0.27.jar')
HANDLER = 'PdfParser.readFile'
AS
$$
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class PdfParser {

    public static String readFile(InputStream stream) throws IOException {
        try (PDDocument document = PDDocument.load(stream)) {

            document.getClass();

            if (!document.isEncrypted()) {

                PDFTextStripperByArea stripper = new PDFTextStripperByArea();
                stripper.setSortByPosition(true);

                PDFTextStripper tStripper = new PDFTextStripper();

                String pdfFileInText = tStripper.getText(document);
                return pdfFileInText;
            }
        }
        return null;
    }
}
$$;

-- Example 16490
ALTER STAGE data_stage REFRESH;

-- Example 16491
SELECT process_pdf_func(BUILD_SCOPED_FILE_URL('@data_stage', '/myfile.pdf'));

-- Example 16492
CREATE PROCEDURE process_pdf_proc(file STRING)
RETURNS STRING
LANGUAGE JAVA
RUNTIME_VERSION = 11
IMPORTS = ('@jars_stage/pdfbox-app-2.0.28.jar')
HANDLER = 'PdfParser.readFile'
PACKAGES = ('com.snowflake:snowpark:latest')
AS
$$
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import com.snowflake.snowpark_java.types.SnowflakeFile;
import com.snowflake.snowpark_java.Session;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class PdfParser {

    public static String readFile(Session session, String fileURL) throws IOException {
        SnowflakeFile file = SnowflakeFile.newInstance(fileURL);
        try (PDDocument document = PDDocument.load(file.getInputStream())) {

            document.getClass();

            if (!document.isEncrypted()) {

                PDFTextStripperByArea stripper = new PDFTextStripperByArea();
                stripper.setSortByPosition(true);

                PDFTextStripper tStripper = new PDFTextStripper();

                String pdfFileInText = tStripper.getText(document);
                return pdfFileInText;
            }
        }

        return null;
    }
}
$$;

-- Example 16493
ALTER STAGE data_stage REFRESH;

-- Example 16494
CALL process_pdf_proc(BUILD_SCOPED_FILE_URL('@data_stage', '/UsingThird-PartyPackages.pdf'));

-- Example 16495
-- Create an internal stage to store the data files. The stage includes a directory table.
CREATE OR REPLACE STAGE data_stage DIRECTORY=(ENABLE=TRUE) ENCRYPTION = (TYPE='SNOWFLAKE_SSE');

-- Example 16496
PUT file:///tmp/sample.csv @data_stage AUTO_COMPRESS=FALSE;

-- Example 16497
PUT file://C:\temp\sample.csv @data_stage AUTO_COMPRESS=FALSE;

-- Example 16498
CREATE OR REPLACE FUNCTION parse_csv(file STRING)
RETURNS TABLE (col1 STRING, col2 STRING, col3 STRING )
LANGUAGE JAVA
HANDLER = 'CsvParser'
AS
$$
import org.xml.sax.SAXException;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;
import com.snowflake.snowpark_java.types.SnowflakeFile;

public class CsvParser {

  static class Record {
    public String col1;
    public String col2;
    public String col3;

    public Record(String col1_value, String col2_value, String col3_value)
    {
      col1 = col1_value;
      col2 = col2_value;
      col3 = col3_value;
    }
  }

  public static Class getOutputClass() {
    return Record.class;
  }

  static class CsvStreamingReader {
    private final BufferedReader csvReader;

    public CsvStreamingReader(InputStream is) {
      this.csvReader = new BufferedReader(new InputStreamReader(is));
    }

    public void close() {
      try {
        this.csvReader.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }

    Record getNextRecord() {
      String csvRecord;

      try {
        if ((csvRecord = csvReader.readLine()) != null) {
          String[] columns = csvRecord.split(",", 3);
          return new Record(columns[0], columns[1], columns[2]);
        }
      } catch (IOException e) {
        throw new RuntimeException("Reading CSV failed.", e);
      } finally {
        // No more records, we can close the reader.
        close();
      }

      // Return null to indicate the end of the stream.
      return null;
    }
  }

  public Stream<Record> process(String file_url) throws IOException {
    SnowflakeFile file = SnowflakeFile.newInstance(file_url);

    CsvStreamingReader csvReader = new CsvStreamingReader(file.getInputStream());
    return Stream.generate(csvReader::getNextRecord);
  }
}
$$
;

-- Example 16499
ALTER STAGE data_stage REFRESH;

-- Example 16500
-- Input a file URL.
SELECT * FROM TABLE(PARSE_CSV(BUILD_SCOPED_FILE_URL(@data_stage, 'sample.csv')));

-- Example 16501
SELECT col1
  FROM tab1
  WHERE location = 'New York';

-- Example 16502
CREATE TABLE patients
  (patient_ID INTEGER,
   category VARCHAR,      -- 'PhysicalHealth' or 'MentalHealth'
   diagnosis VARCHAR
   );

INSERT INTO patients (patient_ID, category, diagnosis) VALUES
  (1, 'MentalHealth', 'paranoia'),
  (2, 'PhysicalHealth', 'lung cancer');

-- Example 16503
CREATE VIEW mental_health_view AS
  SELECT * FROM patients WHERE category = 'MentalHealth';

CREATE VIEW physical_health_view AS
  SELECT * FROM patients WHERE category = 'PhysicalHealth';

-- Example 16504
SELECT * FROM physical_health_view
  WHERE 1/IFF(category = 'MentalHealth', 0, 1) = 1;

-- Example 16505
SELECT * FROM patients
  WHERE
    category = 'PhysicalHealth' AND
    1/IFF(category = 'MentalHealth', 0, 1) = 1;

-- Example 16506
CREATE STAGE mystage;

-- Example 16507
PUT file:///Users/MyUserName/MyCompiledJavaCode.jar
  @mystage
  AUTO_COMPRESS = FALSE
  OVERWRITE = TRUE
  ;

-- Example 16508
CREATE OR REPLACE PROCEDURE MYPROC(value INT, fromTable STRING, toTable STRING, count INT)
  RETURNS INT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('@mystage/MyCompiledJavaCode.jar')
  HANDLER = 'MyJavaClass.run';

-- Example 16509
hello-snowpark/
|-- build.sbt
    |-- project/
        |-- plugins.sbt

-- Example 16510
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "1.1.0")

-- Example 16511
libraryDependencies += "com.snowflake" % "snowpark" % "1.1.0" % "provided"

-- Example 16512
sbt assembly

-- Example 16513
target/scala-<version>/<project-name>-assembly-1.0.jar

-- Example 16514
<assembly xmlns="http://maven.apache.org/ASSEMBLY/2.1.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.1.0 http://maven.apache.org/xsd/assembly-2.1.0.xsd">
  <id>jar-with-dependencies</id>
  <formats>
     <format>jar</format>
  </formats>
  <includeBaseDirectory>false</includeBaseDirectory>
  <dependencySets>
    <dependencySet>
      <outputDirectory>/</outputDirectory>
      <useProjectArtifact>false</useProjectArtifact>
      <unpack>true</unpack>
      <scope>provided</scope>
      <excludes>
        <exclude>com.snowflake:snowpark</exclude>
      </excludes>
    </dependencySet>
  </dependencySets>
</assembly>

-- Example 16515
<project>
  [...]
  <build>
    [...]
    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
          <descriptors>
            <descriptor>src/assembly/jar-with-dependencies.xml</descriptor>
          </descriptors>
        </configuration>
        [...]
      </plugin>
      [...]
    </plugins>
    [...]
  </build>
  [...]
</project>

-- Example 16516
VALUE_LIST = ('example.com:80')

-- Example 16517
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 16518
CREATE OR REPLACE SECRET oauth_token
  TYPE = OAUTH2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';

-- Example 16519
CREATE OR REPLACE SECRET bp_maps_api
  TYPE = GENERIC_STRING
  SECRET_STRING = 'replace-with-your-api-key';

-- Example 16520
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = true;

-- Example 16521
CREATE OR REPLACE FUNCTION google_translate_python(sentence STRING, language STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
HANDLER = 'get_translation'
EXTERNAL_ACCESS_INTEGRATIONS = (google_apis_access_integration)
PACKAGES = ('snowflake-snowpark-python','requests')
SECRETS = ('cred' = oauth_token )
AS
$$
import _snowflake
import requests
import json
session = requests.Session()
def get_translation(sentence, language):
  token = _snowflake.get_oauth_access_token('cred')
  url = "https://translation.googleapis.com/language/translate/v2"
  data = {'q': sentence,'target': language}
  response = session.post(url, json = data, headers = {"Authorization": "Bearer " + token})
  return response.json()['data']['translations'][0]['translatedText']
$$;

-- Example 16522
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 16523
CREATE OR REPLACE NETWORK RULE aws_s3_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('external-access-iam-bucket.s3.us-west-2.amazonaws.com');

-- Example 16524
CREATE OR REPLACE SECURITY INTEGRATION aws_s3_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  ENABLED = TRUE
  AWS_ROLE_ARN = 'arn:aws:iam::736112632310:role/external-access-iam-bucket';

-- Example 16525
DESC SECURITY INTEGRATION aws_s3_security_integration;

-- Example 16526
CREATE OR REPLACE SECRET aws_s3_access_token
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = aws_s3_security_integration;

-- Example 16527
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION aws_s3_external_access_integration
  ALLOWED_NETWORK_RULES = (aws_s3_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (aws_s3_access_token)
  ENABLED = TRUE
  COMMENT = 'Testing S3 connectivity';

