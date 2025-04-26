-- Example 11504
CREATE OR REPLACE PROCEDURE my_proc(fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('@mystage/myjar.jar')
  HANDLER = 'MyClass.myMethod';

-- Example 11505
CREATE OR ALTER PROCEDURE python_add1(A NUMBER)
  RETURNS NUMBER
  LANGUAGE PYTHON
  HANDLER='main'
  RUNTIME_VERSION=3.10
  EXTERNAL_ACCESS_INTEGRATIONS=(example_integration)
  PACKAGES = ('snowflake-snowpark-python')
  EXECUTE AS OWNER
  AS
$$
def main(session, a):
    return a+1
$$;

-- Example 11506
CREATE OR ALTER PROCEDURE python_add1(A NUMBER)
  RETURNS NUMBER
  LANGUAGE PYTHON
  HANDLER='main'
  RUNTIME_VERSION=3.10
  EXTERNAL_ACCESS_INTEGRATIONS=(example_integration)
  secrets=('secret_variable_name'=secret_name)
  PACKAGES = ('snowflake-snowpark-python')
  EXECUTE AS CALLER
  AS
$$
def main(session, a):
    return a+1
$$;

-- Example 11507
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE JAVA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <java_jdk_version> ]
  [ COMMENT = '<string_literal>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ PACKAGES = ( '<package_name_and_version>' [ , ... ] ) ]
  HANDLER = '<path_to_method>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  AS '<function_definition>'

-- Example 11508
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE JAVA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <java_jdk_version> ]
  [ COMMENT = '<string_literal>' ]
  IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] )
  HANDLER = '<path_to_method>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]

-- Example 11509
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE JAVASCRIPT
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ COMMENT = '<string_literal>' ]
  AS '<function_definition>'

-- Example 11510
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] [ AGGREGATE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE PYTHON
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  RUNTIME_VERSION = <python_version>
  [ COMMENT = '<string_literal>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ PACKAGES = ( '<package_name>[==<version>]' [ , ... ] ) ]
  HANDLER = '<function_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  AS '<function_definition>'

-- Example 11511
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] [ AGGREGATE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  LANGUAGE PYTHON
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  RUNTIME_VERSION = <python_version>
  [ COMMENT = '<string_literal>' ]
  IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] )
  [ PACKAGES = ( '<package_name>[==<version>]' [ , ... ] ) ]
  HANDLER = '<module_file_name>.<function_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]

-- Example 11512
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  LANGUAGE SCALA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <scala_version> ]
  [ COMMENT = '<string_literal>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ PACKAGES = ( '<package_name_and_version>' [ , ... ] ) ]
  HANDLER = '<path_to_method>'
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  AS '<function_definition>'

-- Example 11513
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION [ IF NOT EXISTS ] <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS <result_data_type>
  [ [ NOT ] NULL ]
  LANGUAGE SCALA
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ]
  [ RUNTIME_VERSION = <scala_version> ]
  [ COMMENT = '<string_literal>' ]
  IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] )
  HANDLER = '<path_to_method>'

-- Example 11514
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] FUNCTION <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( <col_name> <col_data_type> [ , ... ] ) }
  [ [ NOT ] NULL ]
  [ { VOLATILE | IMMUTABLE } ]
  [ MEMOIZABLE ]
  [ COMMENT = '<string_literal>' ]
  AS '<function_definition>'

-- Example 11515
CREATE [ OR ALTER ] FUNCTION ...

-- Example 11516
-- Use version 1.2.0 of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:1.2.0')

-- Use the latest version of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:latest')

-- Example 11517
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'java';

-- Example 11518
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 11519
REMOVE @handlers/myhandler.jar;

-- Example 11520
-- Use version 1.2.2 of the NumPy package.
PACKAGES=('numpy==1.2.2')

-- Use the latest version of the NumPy package.
PACKAGES=('numpy')

-- Example 11521
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'python';

-- Example 11522
-- Use version 1.2.3 or higher of the NumPy package.
PACKAGES=('numpy>=1.2.3')

-- Example 11523
-- Use version 1.7.0 of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:1.7.0')

-- Use the latest version of the Snowpark package.
PACKAGES=('com.snowflake:snowpark:latest')

-- Example 11524
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'scala';

-- Example 11525
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 11526
REMOVE @handlers/myhandler.jar;

-- Example 11527
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

-- Example 11528
create function my_decrement_udf(i numeric(9, 0))
    returns numeric
    language java
    imports = ('@~/my_decrement_udf_package_dir/my_decrement_udf_jar.jar')
    handler = 'my_decrement_udf_package.my_decrement_udf_class.my_decrement_udf_method'
    ;

-- Example 11529
CREATE OR REPLACE FUNCTION js_factorial(d double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  STRICT
  AS '
  if (D <= 0) {
    return 1;
  } else {
    var result = 1;
    for (var i = 2; i <= D; i++) {
      result = result * i;
    }
    return result;
  }
  ';

-- Example 11530
CREATE OR REPLACE FUNCTION py_udf()
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  PACKAGES = ('numpy','pandas','xgboost==1.5.0')
  HANDLER = 'udf'
AS $$
import numpy as np
import pandas as pd
import xgboost as xgb
def udf():
    return [np.__version__, pd.__version__, xgb.__version__]
$$;

-- Example 11531
CREATE OR REPLACE FUNCTION dream(i int)
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  HANDLER = 'sleepy.snore'
  IMPORTS = ('@my_stage/sleepy.py')

-- Example 11532
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
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

-- Example 11533
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  IMPORTS = ('@udf_libs/echohandler.jar')
  HANDLER='Echo.echoVarchar';

-- Example 11534
CREATE FUNCTION pi_udf()
  RETURNS FLOAT
  AS '3.141592654::FLOAT'
  ;

-- Example 11535
CREATE FUNCTION simple_table_function ()
  RETURNS TABLE (x INTEGER, y INTEGER)
  AS
  $$
    SELECT 1, 2
    UNION ALL
    SELECT 3, 4
  $$
  ;

-- Example 11536
SELECT * FROM TABLE(simple_table_function());

-- Example 11537
SELECT * FROM TABLE(simple_table_function());
+---+---+
| X | Y |
|---+---|
| 1 | 2 |
| 3 | 4 |
+---+---+

-- Example 11538
CREATE FUNCTION multiply1 (a number, b number)
  RETURNS number
  COMMENT='multiply two numbers'
  AS 'a * b';

-- Example 11539
CREATE OR REPLACE FUNCTION get_countries_for_user ( id NUMBER )
  RETURNS TABLE (country_code CHAR, country_name VARCHAR)
  AS 'SELECT DISTINCT c.country_code, c.country_name
      FROM user_addresses a, countries c
      WHERE a.user_id = id
      AND c.country_code = a.country_code';

-- Example 11540
CREATE OR ALTER FUNCTION multiply(a NUMBER, b NUMBER)
  RETURNS NUMBER
  AS 'a * b';

-- Example 11541
CREATE OR ALTER SECURE FUNCTION multiply(a NUMBER, b NUMBER)
  RETURNS NUMBER
  COMMENT = 'Multiply two numbers.'
  AS 'a * b';

-- Example 11542
...
WHERE <predicate>
[ ... ]

-- Example 11543
SELECT column_x
   FROM mytable
   WHERE column_y IN (<expr1>, <expr2>, <expr3> ...);

-- Example 11544
SELECT column_x
  FROM mytable t
  JOIN mylookuptable l
  ON t.column_y = l.values_for_comparison;

-- Example 11545
SELECT t1.c1, t2.c2
    FROM t1, t2
    WHERE t1.c1 = t2.c2;

SELECT t1.c1, t2.c2
    FROM t1 INNER JOIN t2
        ON t1.c1 = t2.c2;

-- Example 11546
SELECT t1.c1, t2.c2
FROM t1 LEFT OUTER JOIN t2
        ON t1.c1 = t2.c2;

SELECT t1.c1, t2.c2
FROM t1, t2
WHERE t1.c1 = t2.c2(+);

-- Example 11547
+-------+-------+
| T1.C1 | T2.C2 |
|-------+-------|
|     1 |     1 |
|     2 |  NULL |
|     3 |     3 |
|     4 |  NULL |
+-------+-------+

-- Example 11548
SELECT t1.c1, t2.c2
FROM t1, t2
WHERE t1.c1 = t2.c2 (+)
  AND t1.c3 = t2.c4 (+);

-- Example 11549
-- NOT VALID
select t1.c1
    from t1, t2
    where t1.c1 (+) = t2.c2 (+);

-- Example 11550
-- NOT VALID
select t1.c1
    from t1, t2, t3
    where t1.c1 (+) = t2.c2
      and t1.c1 (+) = t3.c3;

-- Example 11551
select t1.c1
    from t1, t2, t3
    where t1.c1 = t2.c2 (+)
      and t2.c2 = t3.c3 (+);

-- Example 11552
where t1.c1 = t2.c2(+)

where t1.c1 = t2.c2 (+)

-- Example 11553
SELECT * FROM invoices
  WHERE invoice_date < '2018-01-01';

SELECT * FROM invoices
  WHERE invoice_date < '2018-01-01'
    AND paid = FALSE;

-- Example 11554
SELECT * FROM invoices
    WHERE amount < (
                   SELECT AVG(amount)
                       FROM invoices
                   )
    ;

-- Example 11555
SELECT t1.col1, t2.col1
    FROM t1, t2
    WHERE t2.col1 = t1.col1
    ORDER BY 1, 2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
+------+------+

-- Example 11556
SELECT t1.col1, t2.col1
    FROM t1 JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1, 2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
+------+------+

-- Example 11557
create table departments (
    department_ID INTEGER,
    department_name VARCHAR,
    location VARCHAR
    );
insert into departments (department_id, department_name, location) values
    (10, 'CUSTOMER SUPPORT', 'CHICAGO'),
    (40, 'RESEARCH', 'BOSTON'),
    (80, 'Department with no employees yet', 'CHICAGO'),
    (90, 'Department with no projects or employees yet', 'EREHWON')
    ;

create table projects (
    project_id integer,
    project_name varchar,
    department_id integer
    );
insert into projects (project_id, project_name, department_id) values
    (4000, 'Detect fake product reviews', 40),
    (4001, 'Detect false insurance claims', 10),
    (9000, 'Project with no employees yet', 80),
    (9099, 'Project with no department or employees yet', NULL)
    ;

create table employees (
    employee_ID INTEGER,
    employee_name VARCHAR,
    department_id INTEGER,
    project_id INTEGER
    );
insert into employees (employee_id, employee_name, department_id, project_id)
  values
    (1012, 'May Aidez', 10, NULL),
    (1040, 'Devi Nobel', 40, 4000),
    (1041, 'Alfred Mendeleev', 40, 4001)
    ;

-- Example 11558
SELECT d.department_name, p.project_name, e.employee_name
    FROM  departments d, projects p, employees e
    WHERE
            p.department_id = d.department_id
        AND
            e.project_id = p.project_id
    ORDER BY d.department_id, p.project_id, e.employee_id;
+------------------+-------------------------------+------------------+
| DEPARTMENT_NAME  | PROJECT_NAME                  | EMPLOYEE_NAME    |
|------------------+-------------------------------+------------------|
| CUSTOMER SUPPORT | Detect false insurance claims | Alfred Mendeleev |
| RESEARCH         | Detect fake product reviews   | Devi Nobel       |
+------------------+-------------------------------+------------------+

-- Example 11559
SELECT d.department_name, p.project_name, e.employee_name
    FROM  departments d, projects p, employees e
    WHERE
            p.department_id = d.department_id
        AND
            e.project_id(+) = p.project_id
    ORDER BY d.department_id, p.project_id, e.employee_id;
+----------------------------------+-------------------------------+------------------+
| DEPARTMENT_NAME                  | PROJECT_NAME                  | EMPLOYEE_NAME    |
|----------------------------------+-------------------------------+------------------|
| CUSTOMER SUPPORT                 | Detect false insurance claims | Alfred Mendeleev |
| RESEARCH                         | Detect fake product reviews   | Devi Nobel       |
| Department with no employees yet | Project with no employees yet | NULL             |
+----------------------------------+-------------------------------+------------------+

-- Example 11560
SELECT d.department_name, p.project_name, e.employee_name
    FROM  departments d, projects p, employees e
    WHERE
            p.department_id(+) = d.department_id
        AND
            e.project_id(+) = p.project_id
    ORDER BY d.department_id, p.project_id, e.employee_id;
+----------------------------------------------+-------------------------------+------------------+
| DEPARTMENT_NAME                              | PROJECT_NAME                  | EMPLOYEE_NAME    |
|----------------------------------------------+-------------------------------+------------------|
| CUSTOMER SUPPORT                             | Detect false insurance claims | Alfred Mendeleev |
| RESEARCH                                     | Detect fake product reviews   | Devi Nobel       |
| Department with no employees yet             | Project with no employees yet | NULL             |
| Department with no projects or employees yet | NULL                          | NULL             |
+----------------------------------------------+-------------------------------+------------------+

-- Example 11561
ALTER SESSION SET TIMESTAMP_TYPE_MAPPING = 'TIMESTAMP_LTZ';
ALTER SESSION SET TIMEZONE = 'America/Chicago';

CREATE OR REPLACE TABLE time (ltz TIMESTAMP);
INSERT INTO time VALUES ('2024-05-01 00:00:00.000');

SELECT * FROM time;

-- Example 11562
+-------------------------------+
| LTZ                           |
|-------------------------------|
| 2024-05-01 00:00:00.000 -0500 |
+-------------------------------+

-- Example 11563
ALTER SESSION SET TIMESTAMP_TYPE_MAPPING = 'TIMESTAMP_LTZ';
ALTER SESSION SET TIMEZONE = 'America/Chicago';

CREATE OR REPLACE TABLE time (ltz TIMESTAMP);
INSERT INTO time VALUES ('2024-04-30 19:00:00.000 -0800');

SELECT * FROM time;

-- Example 11564
+-------------------------------+
| LTZ                           |
|-------------------------------|
| 2024-04-30 22:00:00.000 -0500 |
+-------------------------------+

-- Example 11565
ALTER SESSION SET TIMEZONE = 'UTC';
ALTER SESSION SET TIMESTAMP_LTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS TZH:TZM';

CREATE OR REPLACE TABLE utctime (ntz TIMESTAMP_NTZ);
INSERT INTO utctime VALUES ('2024-05-01 00:00:00.000');

-- Example 11566
SELECT * FROM utctime;

-- Example 11567
+-------------------------+
| NTZ                     |
|-------------------------|
| 2024-05-01 00:00:00.000 |
+-------------------------+

-- Example 11568
SELECT CONVERT_TIMEZONE('UTC','America/Chicago', ntz)::TIMESTAMP_LTZ AS ChicagoTime
  FROM utctime;

-- Example 11569
+---------------------------+
| CHICAGOTIME               |
|---------------------------|
| 2024-04-30 19:00:00 +0000 |
+---------------------------+

-- Example 11570
SELECT CONVERT_TIMEZONE('UTC','America/Los_Angeles', ntz)::TIMESTAMP_LTZ AS LATime
  FROM utctime;

