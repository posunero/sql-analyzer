-- Example 26641
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

-- Example 26642
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

-- Example 26643
SELECT
    my_java_udf(42),
    my_java_udf(42)
  FROM table1;

-- Example 26644
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

-- Example 26645
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

-- Example 26646
SELECT
    my_java_udf_1(),
    my_java_udf_2()
  FROM table1;

-- Example 26647
if (x < 0) {
  throw new IllegalArgumentException("x must be non-negative.");
}

-- Example 26648
SELECT
   snowflake_region,
   database_name,
   listings,
   SUM(average_database_bytes) AS total_storage
FROM snowflake.data_sharing_usage.listing_auto_fulfillment_database_storage_daily
WHERE 1=1
   AND usage_date BETWEEN '2023-04-17' AND '2023-04-30'
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Example 26649
CREATE OR REPLACE TABLE employees(id NUMBER, name VARCHAR, role VARCHAR);
INSERT INTO employees (id, name, role) VALUES (1, 'Alice', 'op'), (2, 'Bob', 'dev'), (3, 'Cindy', 'dev');

-- Example 26650
CREATE OR REPLACE PROCEDURE filter_by_role(table_name VARCHAR, role VARCHAR)
RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'Filter.filterByRole'
AS
$$
import com.snowflake.snowpark_java.*;

public class Filter {
  public DataFrame filterByRole(Session session, String tableName, String role) {
    DataFrame table = session.table(tableName);
    DataFrame filteredRows = table.filter(Functions.col("role").equal_to(Functions.lit(role)));
    return filteredRows;
  }
}
$$;

-- Example 26651
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 26652
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 26653
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 26654
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 26655
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 26656
CREATE OR REPLACE PROCEDURE filter_by_role(table_name VARCHAR, role VARCHAR)
RETURNS TABLE()
LANGUAGE JAVA
RUNTIME_VERSION = '11'
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'FilterClass.filterByRole'
AS
$$
import com.snowflake.snowpark_java.*;

public class FilterClass {
  public DataFrame filterByRole(Session session, String tableName, String role) {
    DataFrame table = session.table(tableName);
    DataFrame filteredRows = table.filter(Functions.col("role").equal_to(Functions.lit(role)));
    return filteredRows;
  }
}
$$;

-- Example 26657
CALL filter_by_role('employees', 'dev');

-- Example 26658
+----+-------+------+
| ID | NAME  | ROLE |
+----+-------+------+
| 2  | Bob   | dev  |
| 3  | Cindy | dev  |
+----+-------+------+

-- Example 26659
CREATE OR REPLACE TABLE employees(id NUMBER, name VARCHAR, role VARCHAR);
INSERT INTO employees (id, name, role) VALUES (1, 'Alice', 'op'), (2, 'Bob', 'dev'), (3, 'Cindy', 'dev');

-- Example 26660
CREATE OR REPLACE PROCEDURE filter_by_role(table_name VARCHAR, role VARCHAR)
RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
LANGUAGE SCALA
RUNTIME_VERSION = '2.12'
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'Filter.filterByRole'
AS
$$
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark._

object Filter {
   def filterByRole(session: Session, tableName: String, role: String): DataFrame = {
     val table = session.table(tableName)
     val filteredRows = table.filter(col("role") === role)
     return filteredRows
   }
}
$$;

-- Example 26661
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 26662
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 26663
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 26664
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 26665
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 26666
CREATE OR REPLACE PROCEDURE filter_by_role(table_name VARCHAR, role VARCHAR)
   RETURNS TABLE()
   LANGUAGE SCALA
   RUNTIME_VERSION = '2.12'
   PACKAGES = ('com.snowflake:snowpark:latest')
   HANDLER = 'Filter.filterByRole'
   AS
   $$
   import com.snowflake.snowpark.functions._
   import com.snowflake.snowpark._

   object Filter {
      def filterByRole(session: Session, tableName: String, role: String): DataFrame = {
         val table = session.table(tableName)
         val filteredRows = table.filter(col("role") === role)
         return filteredRows
      }
   }
$$;

-- Example 26667
CALL filter_by_role('employees', 'dev');

-- Example 26668
+----+-------+------+
| ID | NAME  | ROLE |
+----+-------+------+
| 2  | Bob   | dev  |
| 3  | Cindy | dev  |
+----+-------+------+

-- Example 26669
CREATE FUNCTION my_function(integer_argument INT, varchar_argument VARCHAR)
  ...

-- Example 26670
CREATE PROCEDURE my_procedure(boolean_argument BOOLEAN, date_argument DATE)
  ...

-- Example 26671
public String queryTable(Session session, String tableName) { ... }

-- Example 26672
CREATE OR REPLACE PROCEDURE query_table(table_name VARCHAR)
  ...

-- Example 26673
CREATE OR REPLACE FUNCTION build_string_udf(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  ...

-- Example 26674
CREATE OR REPLACE PROCEDURE build_string_proc(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  ...

-- Example 26675
CREATE OR REPLACE FUNCTION my_date_udf(optional_date_arg DATE DEFAULT CURRENT_DATE())
  ...

-- Example 26676
-- This is not allowed.
CREATE FUNCTION wrong_order(optional_argument INTEGER DEFAULT 0, required_argument INTEGER)
  ...

-- Example 26677
CREATE FUNCTION my_udf_a()
  ...

-- Example 26678
CREATE FUNCTION my_udf_a(optional_arg INTEGER DEFAULT 0)
  ...

-- Example 26679
000949 (42723): SQL compilation error:
  Cannot overload FUNCTION 'MY_UDF_A' as it would cause ambiguous FUNCTION overloading.

-- Example 26680
CREATE FUNCTION my_udf_b(required_arg INTEGER)
  ...

-- Example 26681
CREATE FUNCTION my_udf_b(required_arg INTEGER, optional_arg INTEGER DEFAULT 0)
  ...

-- Example 26682
000949 (42723): SQL compilation error:
  Cannot overload FUNCTION 'MY_UDF_B' as it would cause ambiguous FUNCTION overloading.

-- Example 26683
CREATE FUNCTION abc_udf(required_arg INTEGER)
  ...

-- Example 26684
CREATE FUNCTION def_udf(required_arg INTEGER, optional_arg INTEGER DEFAULT 0)
  ...

-- Example 26685
000949 (42723): SQL compilation error:
  Cannot overload FUNCTION 'ABC_UDF' as it would cause ambiguous FUNCTION overloading.

-- Example 26686
SELECT MyFunction(col1) FROM table1;

-- Example 26687
CREATE OR REPLACE PROCEDURE do_stuff(input NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
  ERROR VARCHAR DEFAULT 'Bad input. Number must be less than 10.';

BEGIN
  IF (input > 10) THEN
    RETURN ERROR;
  END IF;

  -- Perform an operation that doesn't return a value.

END;
$$
;

-- Example 26688
y = stored_procedure1(x);                         -- Not allowed.

-- Example 26689
SELECT MyFunction_1(column_1) FROM table1;

-- Example 26690
CALL MyStoredProcedure_1(argument_1);

-- Example 26691
CREATE PROCEDURE ...
  $$
  // Create a Statement object that can call a stored procedure named
  // MY_PROCEDURE().
  var stmt1 = snowflake.createStatement( { sqlText: "call MY_PROCEDURE(22)" } );
  // Execute the SQL command; in other words, call MY_PROCEDURE(22).
  stmt1.execute();
  // Create a Statement object that executes a SQL command that includes
  // a call to a UDF.
  var stmt2 = snowflake.createStatement( { sqlText: "select MY_UDF(column1) from table1" } );
  // Execute the SQL statement and store the output (the "result set") in
  // a variable named "rs", which we can access later.
  var rs = stmt2.execute();
  // etc.
  $$;

-- Example 26692
CREATE PROCEDURE ...
  -- Call a stored procedure named my_procedure().
  CALL my_procedure(22);
  -- Execute a SQL statement that includes a call to a UDF.
  SELECT my_udf(column1) FROM table1;

-- Example 26693
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
  CALLED ON NULL INPUT
  RUNTIME_VERSION = 2.12
  HANDLER='Echo.echoVarchar'
  AS
  $$
  class Echo {
    def echoVarchar(x : String): String = {
      return x
    }
  }
  $$;

-- Example 26694
SELECT echo_varchar('Hello');

-- Example 26695
SELECT echo_varchar(NULL);

-- Example 26696
CREATE OR REPLACE FUNCTION return_a_null()
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='TemporaryTestLibrary.returnNull'
  AS
  $$
  class TemporaryTestLibrary {
    def returnNull(): String = {
      return null
    }
  }
  $$;

-- Example 26697
SELECT return_a_null();

-- Example 26698
CREATE TABLE objectives (o OBJECT);
INSERT INTO objectives SELECT PARSE_JSON('{"outer_key" : {"inner_key" : "inner_value"} }');

-- Example 26699
CREATE OR REPLACE FUNCTION extract_from_object(x OBJECT, key VARCHAR)
  RETURNS VARIANT
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='VariantLibrary.extract'
  AS
  $$
  import scala.collection.immutable.Map

  class VariantLibrary {
    def extract(m: Map[String, String], key: String): String = {
      return m(key)
    }
  }
  $$;

-- Example 26700
SELECT extract_from_object(o, 'outer_key'),
  extract_from_object(o, 'outer_key')['inner_key'] FROM OBJECTIVES;

-- Example 26701
CREATE OR REPLACE FUNCTION generate_greeting(greeting_words ARRAY)
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='StringHandler.handleStrings'
  AS
  $$
  class StringHandler {
    def handleStrings(strings: Array[String]): String = {
      return concatenate(strings)
    }
    private def concatenate(strings: Array[String]): String = {
      var concatenated : String = ""
      for (newString <- strings)  {
          concatenated = concatenated + " " + newString
      }
      return concatenated
    }
  }
  $$;

-- Example 26702
var filename = "@my_stage/filename.txt"
var sfFile = SnowflakeFile.newInstance(filename, false)

-- Example 26703
CREATE OR REPLACE FUNCTION sum_total_sales_snowflake_file(file STRING)
  RETURNS INTEGER
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  PACKAGES=('com.snowflake:snowpark:latest')
  HANDLER='SalesSum.sumTotalSales'
  AS
  $$
  import java.io.InputStream
  import java.io.IOException
  import java.nio.charset.StandardCharsets
  import com.snowflake.snowpark_java.types.SnowflakeFile

  object SalesSum {
    @throws(classOf[IOException])
    def sumTotalSales(filePath: String): Int = {
      var total = -1

      // Use a SnowflakeFile instance to read sales data from a stage.
      val file = SnowflakeFile.newInstance(filePath)
      val stream = file.getInputStream()
      val contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8)

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total
    }
  }
  $$;

-- Example 26704
SELECT sum_total_sales_input_stream(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 26705
CREATE OR REPLACE FUNCTION sum_total_sales_input_stream(file STRING)
  RETURNS NUMBER
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER = 'SalesSum.sumTotalSales'
  PACKAGES = ('com.snowflake:snowpark:latest')
  AS $$
  import com.snowflake.snowpark.types.Variant
  import java.io.InputStream
  import java.io.IOException
  import java.nio.charset.StandardCharsets
  object SalesSum {
    @throws(classOf[IOException])
    def sumTotalSales(stream: InputStream): Int = {
      val total = -1
      val contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8)

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total
    }
  }
  $$;

-- Example 26706
SELECT sum_total_sales_input_stream(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 26707
public class Geography
extends Object
implements Serializable

