-- Example 28651
pip install "snowflake-snowpark-python[pandas]"

-- Example 28652
pip install notebook

-- Example 28653
jupyter notebook

-- Example 28654
>>> from snowflake.snowpark.functions import avg

-- Example 28655
object MyObject
{
  def myProcedure(session: com.snowflake.snowpark.Session, fromTable: String, toTable: String, count: Int): String =
  {
    session.table(fromTable).limit(count).write.saveAsTable(toTable)
    return "Success"
  }
}

-- Example 28656
object MyObject
{
  val myProcedure = (session: com.snowflake.snowpark.Session, fromTable: String, toTable: String, count: Int): String =>
  {
    session.table(fromTable).limit(count).write.saveAsTable(toTable)
    "Success"
  }
}

-- Example 28657
CREATE OR REPLACE PROCEDURE asyncWait()
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = 2.12
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'TestScalaSP.asyncBasic'
AS
$$
import com.snowflake.snowpark._
object TestScalaSP {
  def asyncBasic(session: com.snowflake.snowpark.Session): String = {
    val df = session.sql("select system$wait(10)")
    val asyncJob = df.async.collect()
    while(!asyncJob.isDone()) {
      Thread.sleep(1000)
    }
    "Done"
  }
}
$$;

call asyncScalaTest();

-- Example 28658
CREATE OR REPLACE PROCEDURE cancelJob()
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = 2.12
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'TestScalaSP.asyncBasic'
AS
$$
import com.snowflake.snowpark._
object TestScalaSP {
  def asyncBasic(session: com.snowflake.snowpark.Session): String = {
    val df = session.sql("select system$wait(10)")
    val asyncJob = df.async.collect()
    asyncJob.cancel()
    "Done"
  }
}
$$;

-- Example 28659
CREATE OR REPLACE PROCEDURE checkStatus()
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = 2.12
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'TestScalaSP.asyncBasic'
AS
$$
import java.sql.ResultSet
import net.snowflake.client.jdbc.{SnowflakeConnectionV1, SnowflakeResultSet, SnowflakeStatement}
object TestScalaSP {
  def asyncBasic(session: com.snowflake.snowpark.Session): String = {
    val connection = session.jdbcConnection
    val stmt = connection.createStatement()
    val rs = stmt.asInstanceOf[SnowflakeStatement].executeAsyncQuery("CALL SYSTEM$WAIT(10)")
    val status = rs.asInstanceOf[SnowflakeResultSet].getStatus.toString
    s"""status:    ${status}"""
  }
}
$$;

-- Example 28660
if (x < 0) throw new IllegalArgumentException("x must be non-negative.")

-- Example 28661
CREATE OR REPLACE FUNCTION <name> ( [ <arguments> ] )
  RETURNS <type>
  LANGUAGE SCALA
  [ IMPORTS = ( '<imports>' ) ]
  RUNTIME_VERSION = 2.12
  [ PACKAGES = ( '<package_name>' [, '<package_name>' . . .] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  HANDLER = '<handler_class>.<handler_method>'
  [ AS '<scala_code>' ]

-- Example 28662
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='MyHandler.echoVarchar'
  AS
  $$
  class MyHandler {
    def echoVarchar(x : String): String = {
      return x
    }
  }
  $$;

-- Example 28663
SELECT echo_varchar('Hello');

-- Example 28664
def this() = {
  // Initialize here.
}

-- Example 28665
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

-- Example 28666
SELECT generate_greeting(['Hello', 'world']);

-- Example 28667
Hello world

-- Example 28668
Cannot determine which implementation of handler "handler name" to invoke since there are multiple
definitions with <number of args> arguments in function <user defined function name> with
handler <class name>.<handler name>

-- Example 28669
SELECT my_scala_udf(42), my_scala_udf(42) FROM table1;

-- Example 28670
class MyClass {

  var x: Double = 0.0

  // Constructor
  def this() = {
    x = Math.random()
  }

  // Handler
  def myHandler(): Double = x
}

-- Example 28671
CREATE FUNCTION my_scala_udf_1()
  RETURNS DOUBLE
  LANGUAGE SCALA
  IMPORTS = ('@udf_libs/rand.jar')
  HANDLER = 'MyClass.myHandler';

CREATE FUNCTION my_scala_udf_2()
  RETURNS DOUBLE
  LANGUAGE SCALA
  IMPORTS = ('@udf_libs/rand.jar')
  HANDLER = 'MyClass.myHandler';

-- Example 28672
SELECT my_scala_udf_1(), my_scala_udf_2() FROM table1;

-- Example 28673
SnowflakeProject
|-- project
|   |-- plugins.sbt
|-- src
|   |-- main / scala / org / example
|   |   |-- function
|   |   |   |-- FunctionHandler.scala
|   |   |-- procedure
|   |   |-- utils
|   |-- test / scala / org / example
|   |   |-- function
|   |   |-- procedure
|-- build.sbt
|-- pom.xml

-- Example 28674
if (x < 0) throw new IllegalArgumentException("x must be non-negative.")

-- Example 28675
CREATE OR REPLACE FUNCTION <name> ( [ <arguments> ] )
  RETURNS <type>
  LANGUAGE SCALA
  [ IMPORTS = ( '<imports>' ) ]
  RUNTIME_VERSION = 2.12
  [ PACKAGES = ( '<package_name>' [, '<package_name>' . . .] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  HANDLER = '<handler_class>.<handler_method>'
  [ AS '<scala_code>' ]

-- Example 28676
CREATE OR REPLACE FUNCTION tf (arg1 VARCHAR(1))
RETURNS VARCHAR(1)
LANGUAGE SQL AS 'SHA2(a)';

-- Example 28677
Compilation of SQL UDF failed: SQL compilation error: syntax error... unexpected '<variable_name>'

-- Example 28678
CREATE OR REPLACE FUNCTION profit2(table_name_parameter VARCHAR)
  RETURNS NUMERIC(11, 2)
  AS
  $$
    SELECT SUM((retail_price - wholesale_price) * number_sold)
        FROM IDENTIFIER(table_name_parameter)
  $$
  ;

-- Example 28679
CREATE FUNCTION area_of_circle(radius FLOAT)
  RETURNS FLOAT
  AS
  $$
    pi() * radius * radius
  $$
  ;

-- Example 28680
SELECT area_of_circle(1.0);

-- Example 28681
SELECT area_of_circle(1.0);
+---------------------+
| AREA_OF_CIRCLE(1.0) |
|---------------------|
|         3.141592654 |
+---------------------+

-- Example 28682
CREATE FUNCTION profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
    SELECT SUM((retail_price - wholesale_price) * number_sold)
        FROM purchases
  $$
  ;

-- Example 28683
CREATE FUNCTION pi_udf()
  RETURNS FLOAT
  AS '3.141592654::FLOAT'
  ;

-- Example 28684
SELECT pi_udf();

-- Example 28685
SELECT pi_udf();
+-------------+
|    PI_UDF() |
|-------------|
| 3.141592654 |
+-------------+

-- Example 28686
CREATE TABLE purchases (number_sold INTEGER, wholesale_price NUMBER(7,2), retail_price NUMBER(7,2));
INSERT INTO purchases (number_sold, wholesale_price, retail_price) VALUES 
   (3,  10.00,  20.00),
   (5, 100.00, 200.00)
   ;

-- Example 28687
CREATE FUNCTION profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
    SELECT SUM((retail_price - wholesale_price) * number_sold)
        FROM purchases
  $$
  ;

-- Example 28688
SELECT profit();

-- Example 28689
SELECT profit();
+----------+
| PROFIT() |
|----------|
|   530.00 |
+----------+

-- Example 28690
CREATE TABLE circles (diameter FLOAT);

INSERT INTO circles (diameter) VALUES
    (2.0),
    (4.0);

CREATE FUNCTION diameter_to_radius(f FLOAT) 
  RETURNS FLOAT
  AS 
  $$ f / 2 $$
  ;

-- Example 28691
WITH
    radii AS (SELECT diameter_to_radius(diameter) AS radius FROM circles)
  SELECT radius FROM radii
    ORDER BY radius
  ;

-- Example 28692
+--------+
| RADIUS |
|--------|
|      1 |
|      2 |
+--------+

-- Example 28693
CREATE TABLE orders (product_ID varchar, quantity integer, price numeric(11, 2), buyer_info varchar);
CREATE TABLE inventory (product_ID varchar, quantity integer, price numeric(11, 2), vendor_info varchar);
INSERT INTO inventory (product_ID, quantity, price, vendor_info) VALUES 
  ('X24 Bicycle', 4, 1000.00, 'HelloVelo'),
  ('GreenStar Helmet', 8, 50.00, 'MellowVelo'),
  ('SoundFX', 5, 20.00, 'Annoying FX Corporation');
INSERT INTO orders (product_id, quantity, price, buyer_info) VALUES 
  ('X24 Bicycle', 1, 1500.00, 'Jennifer Juniper'),
  ('GreenStar Helmet', 1, 75.00, 'Donovan Liege'),
  ('GreenStar Helmet', 1, 75.00, 'Montgomery Python');

-- Example 28694
CREATE FUNCTION store_profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
  SELECT SUM( (o.price - i.price) * o.quantity) 
    FROM orders AS o, inventory AS i 
    WHERE o.product_id = i.product_id
  $$
  ;

-- Example 28695
SELECT store_profit();

-- Example 28696
SELECT store_profit();
+----------------+
| STORE_PROFIT() |
|----------------|
|         550.00 |
+----------------+

-- Example 28697
-- ----- These examples show a UDF called from different clauses ----- --

select MyFunc(column1) from table1;

select * from table1 where column2 > MyFunc(column1);

-- Example 28698
SET id_threshold = (SELECT COUNT(*)/2 FROM table1);

-- Example 28699
CREATE OR REPLACE FUNCTION my_filter_function()
RETURNS TABLE (id int)
AS
$$
SELECT id FROM table1 WHERE id > $id_threshold
$$
;

-- Example 28700
CREATE TABLE stores (store_ID INTEGER, city VARCHAR);
CREATE TABLE employee_sales (employee_ID INTEGER, store_ID INTEGER, sales NUMERIC(10,2), 
    sales_date DATE);
INSERT INTO stores (store_ID, city) VALUES 
    (1, 'Winnipeg'),
    (2, 'Toronto');
INSERT INTO employee_sales (employee_ID, store_ID, sales, sales_date) VALUES 
    (1001, 1, 9000.00, '2020-01-27'),
    (1002, 1, 2000.00, '2020-01-27'),
    (2001, 2, 6000.00, '2020-01-27'),
    (2002, 2, 4000.00, '2020-01-27'),
    (2002, 2, 5000.00, '2020-01-28')
    ;

-- Example 28701
SELECT employee_ID,
       store_ID,
       (SELECT city FROM stores WHERE stores.store_ID = employee_sales.store_ID)
    FROM employee_sales;

-- Example 28702
CREATE FUNCTION subquery_like_udf(X INT)
    RETURNS VARCHAR
    LANGUAGE SQL
    AS
    $$
        SELECT city FROM stores WHERE stores.store_ID = X
    $$;

-- Example 28703
SELECT employee_ID, subquery_like_udf(employee_sales.store_ID)
    FROM employee_sales;

-- Example 28704
SELECT subquery_like_udf(1);
+----------------------+
| SUBQUERY_LIKE_UDF(1) |
|----------------------|
| Winnipeg             |
+----------------------+

-- Example 28705
CREATE FUNCTION subquery_like_udf_2(X INT)
    RETURNS VARCHAR
    LANGUAGE SQL
    AS
    $$
        SELECT ANY_VALUE(city) FROM stores WHERE stores.store_ID = X
    $$;

-- Example 28706
SELECT employee_ID, sales_date, subquery_like_udf_2(employee_sales.store_ID)
    FROM employee_sales
    ORDER BY employee_ID, sales_date;
+-------------+------------+----------------------------------------------+
| EMPLOYEE_ID | SALES_DATE | SUBQUERY_LIKE_UDF_2(EMPLOYEE_SALES.STORE_ID) |
|-------------+------------+----------------------------------------------|
|        1001 | 2020-01-27 | Winnipeg                                     |
|        1002 | 2020-01-27 | Winnipeg                                     |
|        2001 | 2020-01-27 | Toronto                                      |
|        2002 | 2020-01-27 | Toronto                                      |
|        2002 | 2020-01-28 | Toronto                                      |
+-------------+------------+----------------------------------------------+

-- Example 28707
snow snowpark execute
  <object_type>
  <execution_identifier>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 28708
snow snowpark execute function "hello_function('Olaf')"

-- Example 28709
+--------------------------------------+
| key                    | value       |
|------------------------+-------------|
| HELLO_FUNCTION('Olaf') | Hello Olaf! |
+--------------------------------------+

-- Example 28710
{
   processRow: function (row, rowWriter, context) {/*...*/},
   finalize: function (rowWriter, context) {/*...*/},
   initialize: function (argumentInfo, context) {/*...*/},
}

-- Example 28711
CREATE FUNCTION f(argument_1 INTEGER, argument_2 VARCHAR) ...

-- Example 28712
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER (PARTITION BY <expression>)) ...;

-- Example 28713
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER (PARTITION BY <expression> ORDER BY <expression>)) ...;

-- Example 28714
SELECT ...
  FROM TABLE ( udtf_name (udtf_arguments) )

-- Example 28715
SELECT * FROM TABLE(js_udtf(10.0::FLOAT, 20.0::FLOAT));
+----+----+
|  Y |  X |
|----+----|
| 20 | 10 |
+----+----+

-- Example 28716
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2)) ;

-- Example 28717
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER (PARTITION BY tab1.c3 ORDER BY tab1.c1));

