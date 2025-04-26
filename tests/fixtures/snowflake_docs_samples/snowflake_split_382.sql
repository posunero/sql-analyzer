-- Example 25569
ALTER DYNAMIC TABLE product SWAP WITH new_product;

-- Example 25570
ALTER DYNAMIC TABLE product CLUSTER BY (date);

-- Example 25571
ALTER DYNAMIC TABLE product DROP CLUSTERING KEY;

-- Example 25572
ALTER DYNAMIC TABLE product REFRESH COPY SESSION

-- Example 25573
SHOW DYNAMIC TABLES [ LIKE '<pattern>' ]
                    [ IN
                      {
                           ACCOUNT              |

                           DATABASE             |
                           DATABASE <db_name>   |

                           SCHEMA               |
                           SCHEMA <schema_name> |
                           <schema_name>
                      }
                    ]
                    [ STARTS WITH '<name_string>' ]
                    [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 25574
SHOW DYNAMIC TABLES LIKE 'product_%' IN SCHEMA mydb.myschema;

-- Example 25575
CREATE STREAM mystream ON TABLE mybasetable BEFORE(STATEMENT => 'last refresh UUID');

-- Example 25576
SELECT * FROM TABLE(SYSTEM$STREAM_BACKLOG('mystream'))

-- Example 25577
FROM ubuntu
COPY snowCli /dockerDestinationFolder
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
RUN apt-get update
RUN apt-get install -y ca-certificates openssl

-- Example 25578
> Executing task: docker build --pull --rm -f "Dockerfile" -t release:Ubuntu "." <

[+] Building 2.0s (11/11) FINISHED                                                                                           0.0s 
.
.
.

-- Example 25579
SELECT employee_id,
       ename,
       hire_date,
       SALARY,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rn
FROM employees
WHERE hire_date > ADD_MONTHS(SYSDATE, -12);

-- Example 25580
SELECT employee_id,
       ename,
       hire_date,
       SALARY,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rn
FROM employees
WHERE hire_date > ADD_MONTHS(CURRENT_DATE(), -12); -- SYSDATE becomes CURRENT_DATE()

-- Example 25581
SELECT employee_id,
       ename,
       hire_date,
       salary,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rn
FROM employees
WHERE hire_date > DATEADD(year, -1, GETDATE());

-- Example 25582
SELECT employee_id,
       ename,
       hire_date,
       salary,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rn
FROM employees
WHERE hire_date > DATEADD(year, -1, CURRENT_TIMESTAMP());

-- Example 25583
sma [command] [argument] [command] [argument] ...

-- Example 25584
sma install-access-code <access-code>

-- Example 25585
sma install-ac <access-code>

-- Example 25586
sma install-access-code --file <path-to-file>
or
sma install-access-code -f <path-to-file>

-- Example 25587
sma show-access-code

-- Example 25588
sma -i <input-path> -o <output-path> -e <client email> -c <client company> -p <project name> <additional-parameters>

-- Example 25589
sma --input <input-path> --output <output-path> --assessment <additional-parameters>

-- Example 25590
sma --version
sma -v

-- Example 25591
sma -i <input-path> -o <output-path> --enableJupyter

-- Example 25592
sma --input <input-path> --output <output-path> --sql SparkSql
sma --input <input-path> --output <output-path> --sql HiveSql

-- Example 25593
sma --help
sma -h

-- Example 25594
sma <command> --help

-- Example 25595
FROM ubuntu
COPY snowCli /dockerDestinationFolder
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
RUN apt-get update
RUN apt-get install -y ca-certificates openssl

-- Example 25596
> Executing task: docker build --pull --rm -f "Dockerfile" -t release:Ubuntu "." <

[+] Building 2.0s (11/11) FINISHED                                                                                           0.0s 
.
.
.

-- Example 25597
./sma show-ac

-- Example 25598
./sma -i '/your/INput/directory/path/here' -o '/your/OUTput/directory/path/here' -e your@email.com -c Your-Organization -p Your-Project-Name

-- Example 25599
dependencies {
    implementation 'com.snowflake:snowpark:1.6.2'
    implementation 'net.mobilize.snowpark-extensions:snowparkextensions:0.0.9'
    ...
}

-- Example 25600
...
libraryDependencies += "com.snowflake" % "snowpark" % "1.6.2"
libraryDependencies += "net.mobilize.snowpark-extensions" % "snowparkextensions" % "0.0.9"
...

-- Example 25601
<dependencies>
    <dependency>
        <groupId>com.snowflake</groupId>
        <artifactId>snowpark</artifactId>
        <version>1.6.2</version>
    </dependency>
    <dependency>
        <groupId>net.mobilize.snowpark-extensions</groupId>
        <artifactId>snowparkextensions</artifactId>
        <version>0.0.9</version>
    </dependency>
    ...
</dependencies>

-- Example 25602
import com.snowflake.snowpark_extensions.Extensions._
import com.snowflake.snowpark_extensions.Extensions.functions._

-- Example 25603
package com.mobilize.spark

import org.apache.spark.sql._

object Main {

   def main(args: Array[String]) : Unit = {

      var languageArray = Array("Java");

      var languageHex = hex(col("language"));

      col("language").isin(languageArray:_*);
   }

}

-- Example 25604
package com.mobilize.spark

import com.snowflake.snowpark._
import com.snowflake.snowpark_extensions.Extensions._
import com.snowflake.snowpark_extensions.Extensions.functions._

object Main {

   def main(args: Array[String]) : Unit = {

      var languageArray = Array("Java");
      
      // hex does not exist on Snowpark. It is a extension.
      var languageHex = hex(col("language"));
      
      // isin does not exist on Snowpark. It is a extension.
      col("language").isin(languageArray :_*)

   }

}

-- Example 25605
pip install snowpark-extensions

-- Example 25606
pip install snowflake-snowpark-python

-- Example 25607
import snowpark_extensions

-- Example 25608
import pyspark.sql.functions as df
df.select(create_map('name', 'age').alias("map")).collect()

-- Example 25609
import snowpark_extensions
import snowflake.snowpark.functions as df
df.select(create_map('name', 'age').alias("map")).collect()

-- Example 25610
# Original in Spark
spark.sql("""MERGE INTO people_target pt
USING people_source ps
ON (pt.person_id1 = ps.person_id2)
WHEN NOT MATCHED BY SOURCE THEN DELETE""")

-- Example 25611
# SMA transformation
spark.sql("""MERGE INTO people_target pt
USING (
   SELECT
      pt.person_id1
   FROM
      people_target pt
      LEFT JOIN
         people_source ps
         ON pt.person_id1 = ps.person_id2
   WHERE
      ps.person_id2 IS NULL
) s_src
ON pt.person_id1 = s_src.person_id1
WHEN MATCHED THEN
   DELETE;""")

-- Example 25612
query = "SELECT COUNT(COUNTRIES) FROM SALES"
dfSales = spark.sql(query)

-- Example 25613
query = "SELECT COUNT(COUNTRIES) FROM SALES" 
#EWI: SPRKPY1077 => SQL embedded code cannot be processed. 
dfSales = spark.sql(query)

-- Example 25614
base = "SELECT "
criteria_1 = " COUNT(*) "
criteria_2 = " * "
fromClause = " FROM COUNTRIES"

df1 = spark.sql(bas + criteria_1 + fromClause)
df2 = spark.sql(bas + criteria_2 + fromClause)

-- Example 25615
base = "SELECT "
criteria_1 = " COUNT(*) "
criteria_2 = " * "
fromClause = " FROM COUNTRIES"
#EWI: SPRKPY1077 => SQL embedded code cannot be processed.

df1 = spark.sql(bas + criteria_1 + fromClause)
#EWI: SPRKPY1077 => SQL embedded code cannot be processed.
df2 = spark.sql(bas + criteria_2 + fromClause)

-- Example 25616
# Old Style interpolation
</strong>UStbl = "SALES_US"
salesUS = spark.sql("SELECT * FROM %s" % (UStbl))

# Using format function
COLtbl = "COL_SALES WHERE YEAR(saleDate) > 2023"
salesCol = spark.sql("SELECT * FROM {}".format(COLtbl))

# New Style
UKTbl = " UK_SALES_JUN_18" 
salesUk = spark.sql(f"SELECT * FROM {UKTbl}")

-- Example 25617
# Old Style interpolation
UStbl = "SALES_US"
#EWI: SPRKPY1077 => SQL embedded code cannot be processed.
salesUS = spark.sql("SELECT * FROM %s" % (UStbl))

# Using format function
COLtbl = "COL_SALES WHERE YEAR(saleDate) > 2023"
#EWI: SPRKPY1077 => SQL embedded code cannot be processed.
salesCol = spark.sql("SELECT * FROM {}".format(COLtbl))

# New Style
UKTbl = " UK_SALES_JUN_18"
#EWI: SPRKPY1077 => SQL embedded code cannot be processed.
salesUk = spark.sql(f"SELECT * FROM {UKTbl}")

-- Example 25618
def ByMonth(month):
    query = f"SELECT * LOGS WHERE MONTH(access_date) = {month}"
    return spark.sql(query)

-- Example 25619
def ByMonth(month):
query = f"SELECT * LOGS WHERE MONTH(access_date) = {month}"
    #EWI: SPRKPY1077 => SQL embedded code cannot be processed.
    return spark.sql(query)

-- Example 25620
/*Scala*/
 class SparkSqlExample {
    def main(spark: SparkSession) : Unit = {
    /*EWI: SPRKSCL1173 => SQL embedded code cannot be processed.*/
    spark.sql("CREATE VIEW IF EXISTS My View AS Select * From my Table WHERE date < current_date() ")
    }

-- Example 25621
# Python Output 
#EWI: SPRKPY1077 => SQL embedded code cannot be processed.
b = spark.sql("CREATE VIEW IF EXISTS My View AS Select * From my Table WHERE date < current_date() ")

-- Example 25622
SELECT ...
  FROM left_hand_table_expression AS lhte,
    LATERAL (SELECT col_1 FROM table_2 AS t2 WHERE t2.col_1 = lhte.col_1);

-- Example 25623
... FROM te1, LATERAL iv1 ...

-- Example 25624
CREATE TABLE departments (department_id INTEGER, name VARCHAR);
CREATE TABLE employees (employee_ID INTEGER, last_name VARCHAR,
  department_ID INTEGER, project_names ARRAY);

INSERT INTO departments (department_ID, name) VALUES
  (1, 'Engineering'),
  (2, 'Support');
INSERT INTO employees (employee_ID, last_name, department_ID) VALUES
  (101, 'Richards', 1),
  (102, 'Paulson',  1),
  (103, 'Johnson',  2);

-- Example 25625
SELECT *
  FROM departments AS d, employees AS e
  WHERE e.department_ID = d.department_ID
  ORDER BY employee_ID;

-- Example 25626
+---------------+-------------+-------------+-----------+---------------+---------------+
| DEPARTMENT_ID | NAME        | EMPLOYEE_ID | LAST_NAME | DEPARTMENT_ID | PROJECT_NAMES |
|---------------+-------------+-------------+-----------+---------------+---------------|
|             1 | Engineering |         101 | Richards  |             1 | NULL          |
|             1 | Engineering |         102 | Paulson   |             1 | NULL          |
|             2 | Support     |         103 | Johnson   |             2 | NULL          |
+---------------+-------------+-------------+-----------+---------------+---------------+

-- Example 25627
for each row in left_hand_table LHT:
  execute right_hand_subquery RHS using the values from the current row in the LHT

-- Example 25628
SELECT *
  FROM departments AS d,
    LATERAL (SELECT * FROM employees AS e WHERE e.department_ID = d.department_ID) AS iv2
  ORDER BY employee_ID;

-- Example 25629
+---------------+-------------+-------------+-----------+---------------+---------------+
| DEPARTMENT_ID | NAME        | EMPLOYEE_ID | LAST_NAME | DEPARTMENT_ID | PROJECT_NAMES |
|---------------+-------------+-------------+-----------+---------------+---------------|
|             1 | Engineering |         101 | Richards  |             1 | NULL          |
|             1 | Engineering |         102 | Paulson   |             1 | NULL          |
|             2 | Support     |         103 | Johnson   |             2 | NULL          |
+---------------+-------------+-------------+-----------+---------------+---------------+

-- Example 25630
for each row in left_hand_table LHT:
  for each row in right_hand_table RHT:
    concatenate the columns of the RHT to the columns of the LHT

-- Example 25631
for each row in left_hand_table LHT:
  execute right_hand_subquery RHS using the values from the LHT row,
    and concatenate LHT columns to RHS columns

-- Example 25632
SELECT *
  FROM t1, TABLE(udtf2(t1.col1))
  ...
  ;

-- Example 25633
for each row in left_hand_table LHT:
  udtf2(row) -- that is, call udtf2() with the value(s) from the LHT row.

-- Example 25634
for each row in left_hand_table LHT:
  execute right_hand_subquery RHS using the values from the LHT row

-- Example 25635
UPDATE employees SET project_names = ARRAY_CONSTRUCT('Materialized Views', 'UDFs')
  WHERE employee_ID = 101;
UPDATE employees SET project_names = ARRAY_CONSTRUCT('Materialized Views', 'Lateral Joins')
  WHERE employee_ID = 102;

