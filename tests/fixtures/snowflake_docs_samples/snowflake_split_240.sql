-- Example 16060
package com.my_company.my_package;

-- Example 16061
WITH copy_to_table AS PROCEDURE (fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE SCALA
  RUNTIME_VERSION = '2.12'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'DataCopy.copyBetweenTables'
  AS
  $$
    object DataCopy
    {
      def copyBetweenTables(session: com.snowflake.snowpark.Session, fromTable: String, toTable: String, count: Int): String =
      {
        session.table(fromTable).limit(count).write.saveAsTable(toTable)
        return "Success"
      }
    }
  $$
  CALL copy_to_table('table_a', 'table_b', 5);

-- Example 16062
WITH copy_to_table AS PROCEDURE (fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE SCALA
  RUNTIME_VERSION = '2.12'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'DataCopy.copyBetweenTables'
  AS
  $$
    object DataCopy
    {
      def copyBetweenTables(session: com.snowflake.snowpark.Session, fromTable: String, toTable: String, count: Int): String =
      {
        session.table(fromTable).limit(count).write.saveAsTable(toTable)
        return "Success"
      }
      }
    }
  $$
  CALL copy_to_table(
    toTable => 'table_b',
    count => 5,
    fromTable => 'table_a');

-- Example 16063
Function name (including parameter and return type) too long.

-- Example 16064
CALL mydatabase.myschema.myprocedure();

-- Example 16065
CREATE OR REPLACE FUNCTION myudf (number_argument NUMBER) ...

-- Example 16066
CREATE OR REPLACE FUNCTION myudf (varchar_argument VARCHAR) ...

-- Example 16067
CREATE OR REPLACE FUNCTION myudf (number_argument NUMBER, varchar_argument VARCHAR) ...

-- Example 16068
CREATE OR REPLACE PROCEDURE myproc (number_argument NUMBER) ...

-- Example 16069
CREATE OR REPLACE PROCEDURE myproc (varchar_argument VARCHAR) ...

-- Example 16070
CREATE OR REPLACE PROCEDURE myproc (number_argument NUMBER, varchar_argument VARCHAR) ...

-- Example 16071
CREATE OR REPLACE FUNCTION echo_input (numeric_input NUMBER)
  RETURNS NUMBER
  AS 'numeric_input';

-- Example 16072
CREATE OR REPLACE FUNCTION echo_input (varchar_input VARCHAR)
  RETURNS VARCHAR
  AS 'varchar_input';

-- Example 16073
SELECT echo_input(numeric_input => 10);

-- Example 16074
SELECT echo_input(varchar_input => 'hello world');

-- Example 16075
SELECT myudf(text_input => 'hello world');

-- Example 16076
SELECT myudf('hello world');

-- Example 16077
CREATE OR REPLACE FUNCTION add5 (n NUMBER)
  RETURNS NUMBER
  AS 'n + 5';

CREATE OR REPLACE FUNCTION add5 (s VARCHAR)
  RETURNS VARCHAR
  AS
  $$
    s || '5'
  $$;

-- Example 16078
SELECT add5(1);

-- Example 16079
+---------+
| ADD5(1) |
|---------|
|       6 |
+---------+

-- Example 16080
SELECT add5('1');

-- Example 16081
+-----------+
| ADD5('1') |
|-----------|
| 15        |
+-----------+

-- Example 16082
SELECT add5('hello');

-- Example 16083
+---------------+
| ADD5('HELLO') |
|---------------|
| hello5        |
+---------------+

-- Example 16084
SELECT add5(TO_DATE('2014-01-01'));

-- Example 16085
+-----------------------------+
| ADD5(TO_DATE('2014-01-01')) |
|-----------------------------|
| 2014-01-015                 |
+-----------------------------+

-- Example 16086
SELECT add5(n => 1);

-- Example 16087
SELECT add5(s => '1');

-- Example 16088
USE SCHEMA s1;
CREATE OR REPLACE FUNCTION add5 ( n number)
  RETURNS number
  AS 'n + 5';

-- Example 16089
USE SCHEMA s2;
CREATE OR REPLACE FUNCTION add5 ( s string)
  RETURNS string
  AS 's || ''5''';

-- Example 16090
USE SCHEMA s3;
ALTER SESSION SET SEARCH_PATH='s1,s2';

SELECT add5(5);

-- Example 16091
+---------+
| ADD5(5) |
+---------+
| 10      |
+---------+

-- Example 16092
ALTER SESSION SET SEARCH_PATH='s2,s1';

SELECT add5(5);

+---------+
| ADD5(5) |
*---------+
| 55      |
+---------+

-- Example 16093
CREATE FUNCTION my_function(integer_argument INT, varchar_argument VARCHAR)
  ...

-- Example 16094
CREATE PROCEDURE my_procedure(boolean_argument BOOLEAN, date_argument DATE)
  ...

-- Example 16095
public String queryTable(Session session, String tableName) { ... }

-- Example 16096
CREATE OR REPLACE PROCEDURE query_table(table_name VARCHAR)
  ...

-- Example 16097
CREATE OR REPLACE FUNCTION build_string_udf(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  ...

-- Example 16098
CREATE OR REPLACE PROCEDURE build_string_proc(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  ...

-- Example 16099
CREATE OR REPLACE FUNCTION my_date_udf(optional_date_arg DATE DEFAULT CURRENT_DATE())
  ...

-- Example 16100
-- This is not allowed.
CREATE FUNCTION wrong_order(optional_argument INTEGER DEFAULT 0, required_argument INTEGER)
  ...

-- Example 16101
CREATE FUNCTION my_udf_a()
  ...

-- Example 16102
CREATE FUNCTION my_udf_a(optional_arg INTEGER DEFAULT 0)
  ...

-- Example 16103
000949 (42723): SQL compilation error:
  Cannot overload FUNCTION 'MY_UDF_A' as it would cause ambiguous FUNCTION overloading.

-- Example 16104
CREATE FUNCTION my_udf_b(required_arg INTEGER)
  ...

-- Example 16105
CREATE FUNCTION my_udf_b(required_arg INTEGER, optional_arg INTEGER DEFAULT 0)
  ...

-- Example 16106
000949 (42723): SQL compilation error:
  Cannot overload FUNCTION 'MY_UDF_B' as it would cause ambiguous FUNCTION overloading.

-- Example 16107
CREATE FUNCTION abc_udf(required_arg INTEGER)
  ...

-- Example 16108
CREATE FUNCTION def_udf(required_arg INTEGER, optional_arg INTEGER DEFAULT 0)
  ...

-- Example 16109
000949 (42723): SQL compilation error:
  Cannot overload FUNCTION 'ABC_UDF' as it would cause ambiguous FUNCTION overloading.

-- Example 16110
GRANT USAGE ON FUNCTION my_java_udf(number, number) TO my_role;

-- Example 16111
create function function_name(x integer, y integer)
  returns integer
  language java
  handler='HandlerClass.handlerMethod'
  target_path='@~/HandlerCode.jar'
  as
  $$
      class HandlerClass {
          public static int handlerMethod(int x, int y) {
            return x + y;
          }
      }
  $$;

-- Example 16112
import java.util.stream.Stream;

...

public Stream<OutputRow> process(String v) {
  return Stream.of(new OutputRow(v));
}

...

-- Example 16113
public Stream<OutputRow> process(int number) {
  if (inputNumber < 1) {
    return Stream.empty();
  }
  return Stream.of(new OutputRow(number));
}

-- Example 16114
class OutputRow {

  public String name;
  public int id;

  public OutputRow(String pName, int pId) {
    this.name = pName;
    this.id = pId;
  }

}

-- Example 16115
CREATE FUNCTION F(...)
  RETURNS TABLE(NAME VARCHAR, ID INTEGER)
  ...

-- Example 16116
public Stream<OutputRow> process(String v) {
  ...
  return Stream.of(new OutputRow(...));
}

public Stream<OutputRow> endPartition() {
  ...
  return Stream.of(new OutputRow(...));
}

-- Example 16117
public static Class getOutputClass() {
  return OutputRow.class;
}

-- Example 16118
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

-- Example 16119
SELECT output_value
   FROM TABLE(return_two_copies('Input string'));
+-------------------------------------------------------+
| OUTPUT_VALUE                                          |
|-------------------------------------------------------|
| Input string                                          |
| Input string                                          |
| Created in constructor and output from endPartition() |
+-------------------------------------------------------+

-- Example 16120
CREATE TABLE cities_of_interest (city_name VARCHAR);
INSERT INTO cities_of_interest (city_name) VALUES
    ('Toronto'),
    ('Warsaw'),
    ('Kyoto');

-- Example 16121
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

-- Example 16122
FROM cities_of_interest, TABLE(f(city_name))

-- Example 16123
for city_name in cities_of_interest:
    output_row = f(city_name)

-- Example 16124
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

-- Example 16125
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

-- Example 16126
{
   processRow: function (row, rowWriter, context) {/*...*/},
   finalize: function (rowWriter, context) {/*...*/},
   initialize: function (argumentInfo, context) {/*...*/},
}

