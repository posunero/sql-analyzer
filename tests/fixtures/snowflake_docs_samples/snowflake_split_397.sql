-- Example 26574
COPY INTO @my_s3compat_stage/unload/
  FROM t2;

-- Example 26575
CREATE EXTERNAL TABLE et
 LOCATION=@my_s3compat_stage/path1/
 AUTO_REFRESH = FALSE
 REFRESH_ON_CREATE = TRUE
 FILE_FORMAT = (TYPE = PARQUET);

-- Example 26576
SELECT value FROM et;

-- Example 26577
CREATE EXTERNAL VOLUME my_gcs_external_volume
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-us-west-2'
        STORAGE_PROVIDER = 'GCS'
        STORAGE_BASE_URL = 'gcs://mybucket1/path1/'
        ENCRYPTION=(TYPE='GCS_SSE_KMS' KMS_KEY_ID = '1234abcd-12ab-34cd-56ef-1234567890ab')
      )
    );

-- Example 26578
DESC EXTERNAL VOLUME my_gcs_external_volume;

-- Example 26579
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 26580
static int myMethod(int fixedArgument1, int fixedArgument2, String[] stringArray)

-- Example 26581
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 26582
CREATE OR REPLACE FUNCTION concat_varchar_2(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc_2.concatVarchar2'
  TARGET_PATH = '@~/TestFunc_2.jar'
  AS
  $$
  class TestFunc_2 {
      public static String concatVarchar2(String[] strings) {
          return String.join(" ", strings);
      }
  }
  $$;

-- Example 26583
SELECT concat_varchar_2(a)
  FROM string_array_table
  ORDER BY id;
+---------------------+
| CONCAT_VARCHAR_2(A) |
|---------------------|
| Hello               |
| Hello Jay           |
| Hello Jay Smith     |
+---------------------+

-- Example 26584
static int myMethod(int fixedArgument1, int fixedArgument2, String ... stringArray)

-- Example 26585
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 26586
CREATE OR REPLACE FUNCTION concat_varchar(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc.concatVarchar'
  TARGET_PATH = '@~/TestFunc.jar'
  AS
  $$
  class TestFunc {
      public static String concatVarchar(String ... stringArray) {
          return String.join(" ", stringArray);
      }
  }
  $$;

-- Example 26587
SELECT concat_varchar(a)
    FROM string_array_table
    ORDER BY id;
+-------------------+
| CONCAT_VARCHAR(A) |
|-------------------|
| Hello             |
| Hello Jay         |
| Hello Jay Smith   |
+-------------------+

-- Example 26588
SELECT
    my_java_udf(42),
    my_java_udf(42)
  FROM table1;

-- Example 26589
class MyClass {

  private double x;

  // Constructor
  public MyClass()  {
    x = Math.random();
  }

  // Handler
  public double myHandler() {
    return x;
  }
}

-- Example 26590
CREATE FUNCTION my_java_udf_1()
  RETURNS DOUBLE
  LANGUAGE JAVA
  IMPORTS = ('@java_udf_stage/rand.jar')
  HANDLER = 'MyClass.myHandler';

CREATE FUNCTION my_java_udf_2()
  RETURNS DOUBLE
  LANGUAGE JAVA
  IMPORTS = ('@java_udf_stage/rand.jar')
  HANDLER = 'MyClass.myHandler';

-- Example 26591
SELECT
    my_java_udf_1(),
    my_java_udf_2()
  FROM table1;

-- Example 26592
if (x < 0) {
  throw new IllegalArgumentException("x must be non-negative.");
}

-- Example 26593
Cannot determine which implementation of handler "handler name" to invoke since there are multiple
definitions with <number of args> arguments in function <user defined function name> with
handler <class name>.<handler name>

-- Example 26594
jar cf ./my_udf.jar MyClass.class

-- Example 26595
jar cmf my_udf.manifest ./my_udf.jar example/MyClass.class

-- Example 26596
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVA
  CALLED ON NULL INPUT
  HANDLER = 'TestFunc.echoVarchar'
  TARGET_PATH = '@~/testfunc.jar'
  AS
  'class TestFunc {
    public static String echoVarchar(String x) {
      return x;
    }
  }';

-- Example 26597
SELECT echo_varchar('Hello');
+-----------------------+
| ECHO_VARCHAR('HELLO') |
|-----------------------|
| Hello                 |
+-----------------------+

-- Example 26598
SELECT echo_varchar(NULL);
+--------------------+
| ECHO_VARCHAR(NULL) |
|--------------------|
| NULL               |
+--------------------+

-- Example 26599
static int myMethod(int fixedArgument1, int fixedArgument2, String[] stringArray)

-- Example 26600
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 26601
CREATE OR REPLACE FUNCTION concat_varchar_2(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc_2.concatVarchar2'
  TARGET_PATH = '@~/TestFunc_2.jar'
  AS
  $$
  class TestFunc_2 {
      public static String concatVarchar2(String[] strings) {
          return String.join(" ", strings);
      }
  }
  $$;

-- Example 26602
SELECT concat_varchar_2(a)
  FROM string_array_table
  ORDER BY id;
+---------------------+
| CONCAT_VARCHAR_2(A) |
|---------------------|
| Hello               |
| Hello Jay           |
| Hello Jay Smith     |
+---------------------+

-- Example 26603
static int myMethod(int fixedArgument1, int fixedArgument2, String ... stringArray)

-- Example 26604
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 26605
CREATE OR REPLACE FUNCTION concat_varchar(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc.concatVarchar'
  TARGET_PATH = '@~/TestFunc.jar'
  AS
  $$
  class TestFunc {
      public static String concatVarchar(String ... stringArray) {
          return String.join(" ", stringArray);
      }
  }
  $$;

-- Example 26606
SELECT concat_varchar(a)
    FROM string_array_table
    ORDER BY id;
+-------------------+
| CONCAT_VARCHAR(A) |
|-------------------|
| Hello             |
| Hello Jay         |
| Hello Jay Smith   |
+-------------------+

-- Example 26607
CREATE OR REPLACE FUNCTION return_a_null()
  RETURNS VARCHAR
  NULL
  LANGUAGE JAVA
  HANDLER = 'TemporaryTestLibrary.returnNull'
  TARGET_PATH = '@~/TemporaryTestLibrary.jar'
  AS
  $$
  class TemporaryTestLibrary {
    public static String returnNull() {
      return null;
    }
  }
  $$;

-- Example 26608
SELECT return_a_null();
+-----------------+
| RETURN_A_NULL() |
|-----------------|
| NULL            |
+-----------------+

-- Example 26609
CREATE TABLE objectives (o OBJECT);
INSERT INTO objectives SELECT PARSE_JSON('{"outer_key" : {"inner_key" : "inner_value"} }');

-- Example 26610
CREATE OR REPLACE FUNCTION extract_from_object(x OBJECT, key VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVA
  HANDLER = 'VariantLibrary.extract'
  TARGET_PATH = '@~/VariantLibrary.jar'
  AS
  $$
  import java.util.Map;
  class VariantLibrary {
    public static String extract(Map<String, String> m, String key) {
      return m.get(key);
    }
  }
  $$;

-- Example 26611
SELECT extract_from_object(o, 'outer_key'), 
       extract_from_object(o, 'outer_key')['inner_key'] FROM objectives;
+-------------------------------------+--------------------------------------------------+
| EXTRACT_FROM_OBJECT(O, 'OUTER_KEY') | EXTRACT_FROM_OBJECT(O, 'OUTER_KEY')['INNER_KEY'] |
|-------------------------------------+--------------------------------------------------|
| {                                   | "inner_value"                                    |
|   "inner_key": "inner_value"        |                                                  |
| }                                   |                                                  |
+-------------------------------------+--------------------------------------------------+

-- Example 26612
CREATE OR REPLACE FUNCTION geography_equals(x GEOGRAPHY, y GEOGRAPHY)
  RETURNS BOOLEAN
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:1.2.0')
  HANDLER = 'TestGeography.compute'
  AS
  $$
  import com.snowflake.snowpark_java.types.Geography;

  class TestGeography {
    public static boolean compute(Geography geo1, Geography geo2) {
      return geo1.equals(geo2);
    }
  }
  $$;

-- Example 26613
CREATE TABLE geocache_table (id INTEGER, g1 GEOGRAPHY, g2 GEOGRAPHY);

INSERT INTO geocache_table (id, g1, g2)
  SELECT 1, TO_GEOGRAPHY('POINT(-122.35 37.55)'), TO_GEOGRAPHY('POINT(-122.35 37.55)');
INSERT INTO geocache_table (id, g1, g2)
  SELECT 2, TO_GEOGRAPHY('POINT(-122.35 37.55)'), TO_GEOGRAPHY('POINT(90.0 45.0)');

SELECT id, g1, g2, geography_equals(g1, g2) AS "EQUAL?"
  FROM geocache_table
  ORDER BY id;

-- Example 26614
+----+--------------------------------------------------------+---------------------------------------------------------+--------+
| ID | G1                                                     | G2                                                      | EQUAL? |
+----+--------------------------------------------------------|---------------------------------------------------------+--------+
| 1  | { "coordinates": [ -122.35, 37.55 ], "type": "Point" } | { "coordinates": [ -122.35,  37.55 ], "type": "Point" } | TRUE   |
| 2  | { "coordinates": [ -122.35, 37.55 ], "type": "Point" } | { "coordinates": [   90.0,   45.0  ], "type": "Point" } | FALSE  |
+----+--------------------------------------------------------+---------------------------------------------------------+--------+

-- Example 26615
CREATE OR REPLACE FUNCTION retrieve_price(v VARIANT)
  RETURNS INTEGER
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:1.4.0')
  HANDLER = 'VariantTest.retrievePrice'
  AS
  $$
  import java.util.Map;
  import com.snowflake.snowpark_java.types.Variant;

  public class VariantTest {
    public static Integer retrievePrice(Variant v) throws Exception {
      Map<String, Variant> saleMap = v.asMap();
      int price = saleMap.get("vehicle").asMap().get("price").asInt();
      return price;
    }
  }
  $$;

-- Example 26616
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

class TestReadRelativeFile {
  public static String readFile(String fileName) throws IOException {
    StringBuilder contentBuilder = new StringBuilder();
    String importDirectory = System.getProperty("com.snowflake.import_directory");
    String fPath = importDirectory + fileName;
    Stream<String> stream = Files.lines(Paths.get(fPath), StandardCharsets.UTF_8);
    stream.forEach(s -> contentBuilder.append(s).append("\n"));
    return contentBuilder.toString();
  }
}

-- Example 26617
CREATE FUNCTION file_reader(file_name VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVA
  IMPORTS = ('@my_stage/my_package/TestReadRelativeFile.jar',
             '@my_stage/my_path/my_config_file_1.txt',
             '@my_stage/my_path/my_config_file_2.txt')
  HANDLER = 'my_package.TestReadRelativeFile.readFile';

-- Example 26618
SELECT file_reader('my_config_file_1.txt') ...;
...
SELECT file_reader('my_config_file_2.txt') ...;

-- Example 26619
... IMPORTS = ('@MyStage/MyData.txt.gz', ...)

-- Example 26620
CREATE OR REPLACE FUNCTION sum_total_sales(file STRING)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'SalesSum.sumTotalSales'
  TARGET_PATH = '@jar_stage/sales_functions2.jar'
  AS
  $$
  import java.io.InputStream;
  import java.io.IOException;
  import java.nio.charset.StandardCharsets;
  import com.snowflake.snowpark_java.types.SnowflakeFile;

  public class SalesSum {

    public static int sumTotalSales(String filePath) throws IOException {
      int total = -1;

      // Use a SnowflakeFile instance to read sales data from a stage.
      SnowflakeFile file = SnowflakeFile.newInstance(filePath);
      InputStream stream = file.getInputStream();
      String contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8);

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total;
    }
  }
  $$;

-- Example 26621
SELECT sum_total_sales(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 26622
String filename = "@my_stage/filename.txt";
String sfFile = SnowflakeFile.newInstance(filename, false);

-- Example 26623
CREATE OR REPLACE FUNCTION sum_total_sales(file STRING)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'SalesSum.sumTotalSales'
  TARGET_PATH = '@jar_stage/sales_functions2.jar'
  AS
  $$
  import java.io.InputStream;
  import java.io.IOException;
  import java.nio.charset.StandardCharsets;

  public class SalesSum {

    public static int sumTotalSales(InputStream stream) throws IOException {
      int total = -1;
      String contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8);

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total;
    }
  }
  $$;

-- Example 26624
SELECT sum_total_sales(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 26625
my_udf/
|-- classes/
|-- src/

-- Example 26626
package mypackage;

public class MyUDFHandler {

  public static int decrementValue(int i)
  {
    return i - 1;
  }

  public static void main(String[] argv)
  {
    System.out.println("This main() function won't be called.");
  }
}

-- Example 26627
javac -d classes src/mypackage/MyUDFHandler.java

-- Example 26628
Manifest-Version: 1.0
Main-Class: mypackage.MyUDFHandler

-- Example 26629
jar cmf my_udf.manifest my_udf.jar -C ./classes mypackage/MyUDFHandler.class

-- Example 26630
put
    file:///Users/Me/my_udf/my_udf.jar
    @jar_stage
    auto_compress = false
    overwrite = true
    ;

-- Example 26631
snowsql -a <account_identifier> -w <warehouse> -d <database> -s <schema> -u <user> -f put_command.sql

-- Example 26632
CREATE FUNCTION decrement_value(i NUMERIC(9, 0))
  RETURNS NUMERIC
  LANGUAGE JAVA
  IMPORTS = ('@jar_stage/my_udf.jar')
  HANDLER = 'mypackage.MyUDFHandler.decrementValue'
  ;

-- Example 26633
SELECT decrement_value(-15);

-- Example 26634
+----------------------+
| DECREMENT_VALUE(-15) |
|----------------------|
|                  -16 |
+----------------------+

-- Example 26635
static int myMethod(int fixedArgument1, int fixedArgument2, String[] stringArray)

-- Example 26636
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

-- Example 26637
CREATE OR REPLACE FUNCTION concat_varchar_2(a ARRAY)
  RETURNS VARCHAR
  LANGUAGE JAVA
  HANDLER = 'TestFunc_2.concatVarchar2'
  TARGET_PATH = '@~/TestFunc_2.jar'
  AS
  $$
  class TestFunc_2 {
      public static String concatVarchar2(String[] strings) {
          return String.join(" ", strings);
      }
  }
  $$;

-- Example 26638
SELECT concat_varchar_2(a)
  FROM string_array_table
  ORDER BY id;
+---------------------+
| CONCAT_VARCHAR_2(A) |
|---------------------|
| Hello               |
| Hello Jay           |
| Hello Jay Smith     |
+---------------------+

-- Example 26639
static int myMethod(int fixedArgument1, int fixedArgument2, String ... stringArray)

-- Example 26640
CREATE TABLE string_array_table(id INTEGER, a ARRAY);
INSERT INTO string_array_table (id, a) SELECT
        1, ARRAY_CONSTRUCT('Hello');
INSERT INTO string_array_table (id, a) SELECT
        2, ARRAY_CONSTRUCT('Hello', 'Jay');
INSERT INTO string_array_table (id, a) SELECT
        3, ARRAY_CONSTRUCT('Hello', 'Jay', 'Smith');

