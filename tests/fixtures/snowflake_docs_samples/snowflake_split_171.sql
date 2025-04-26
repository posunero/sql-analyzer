-- Example 11437
SELECT DISTINCT COLLATION(c1), COLLATION(c2) FROM collation_demo2;

-- Example 11438
+---------------+---------------+
| COLLATION(C1) | COLLATION(C2) |
|---------------+---------------|
| fr            | NULL          |
+---------------+---------------+

-- Example 11439
DESC TABLE collation_demo2;

-- Example 11440
+------+--------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type                           | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+--------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| C1   | VARCHAR(16777216) COLLATE 'fr' | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| C2   | VARCHAR(16777216)              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+--------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 11441
SELECT REGEXP_COUNT('snow', 'SNOW', 1, 'c') AS case_sensitive_matching,
       REGEXP_COUNT('snow', 'SNOW', 1, 'i') AS case_insensitive_matching;

-- Example 11442
+-------------------------+---------------------------+
| CASE_SENSITIVE_MATCHING | CASE_INSENSITIVE_MATCHING |
|-------------------------+---------------------------|
|                       0 |                         1 |
+-------------------------+---------------------------+

-- Example 11443
SELECT REGEXP_SUBSTR('Release 24', 'Release\\W+(\\d+)', 1, 1, 'e') AS release_number;

-- Example 11444
+----------------+
| RELEASE_NUMBER |
|----------------|
| 24             |
+----------------+

-- Example 11445
SELECT REGEXP_SUBSTR('Customers - (NY)','\\([[:alnum:]]+\\)') AS location;

-- Example 11446
+----------+
| LOCATION |
|----------|
| (NY)     |
+----------+

-- Example 11447
SELECT REGEXP_SUBSTR('Customers - (NY)',$$\([[:alnum:]]+\)$$) AS location;

-- Example 11448
+----------+
| LOCATION |
|----------|
| (NY)     |
+----------+

-- Example 11449
SELECT w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, $$\?$$);

-- Example 11450
SELECT w2, REGEXP_REPLACE(w2, '(.old)', $$very \1$$)
  FROM wildcards
  ORDER BY w2;

-- Example 11451
CREATE OR REPLACE TABLE wildcards (w VARCHAR, w2 VARCHAR);
INSERT INTO wildcards (w, w2) VALUES ('\\', '?');

-- Example 11452
SELECT w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, '\\?');

-- Example 11453
+----+
| W2 |
|----|
| ?  |
+----+

-- Example 11454
SELECT w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, '\\' || '?');

-- Example 11455
+----+
| W2 |
|----|
| ?  |
+----+

-- Example 11456
SELECT w, w2, w || w2 AS escape_sequence, w2
  FROM wildcards
  WHERE REGEXP_LIKE(w2, w || w2);

-- Example 11457
+---+----+-----------------+----+
| W | W2 | ESCAPE_SEQUENCE | W2 |
|---+----+-----------------+----|
| \ | ?  | \?              | ?  |
+---+----+-----------------+----+

-- Example 11458
INSERT INTO wildcards (w, w2) VALUES (NULL, 'When I am cold, I am bold.');

-- Example 11459
SELECT w2, REGEXP_REPLACE(w2, '(.old)', 'very \\1')
  FROM wildcards
  ORDER BY w2;

-- Example 11460
+----------------------------+------------------------------------------+
| W2                         | REGEXP_REPLACE(W2, '(.OLD)', 'VERY \\1') |
|----------------------------+------------------------------------------|
| ?                          | ?                                        |
| When I am cold, I am bold. | When I am very cold, I am very bold.     |
+----------------------------+------------------------------------------+

-- Example 11461
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE JAVA
  RUNTIME_VERSION = '<java_runtime_version>'
  PACKAGES = ( 'com.snowflake:snowpark:<version>' [, '<package_name_and_version>' ...] )
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<fully_qualified_method_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]
  AS '<procedure_definition>'

-- Example 11462
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE JAVA
  RUNTIME_VERSION = '<java_runtime_version>'
  PACKAGES = ( 'com.snowflake:snowpark:<version>' [, '<package_name_and_version>' ...] )
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<fully_qualified_method_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ VOLATILE | IMMUTABLE ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]

-- Example 11463
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS <result_data_type> [ NOT NULL ]
  LANGUAGE JAVASCRIPT
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ VOLATILE | IMMUTABLE ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]
  AS '<procedure_definition>'

-- Example 11464
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] [ SECURE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE PYTHON
  RUNTIME_VERSION = '<python_version>'
  PACKAGES = ( 'snowflake-snowpark-python[==<version>]'[, '<package_name>[==<version>]' ... ])
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<function_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER }]
  AS '<procedure_definition>'

-- Example 11465
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE PYTHON
  RUNTIME_VERSION = '<python_version>'
  PACKAGES = ( 'snowflake-snowpark-python[==<version>]'[, '<package_name>[==<version>]' ... ])
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<module_file_name>.<function_name>'
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <name_of_integration> [ , ... ] ) ]
  [ SECRETS = ('<secret_variable_name>' = <secret_name> [ , ... ] ) ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]

-- Example 11466
CREATE [ OR REPLACE ] [ SECURE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE SCALA
  RUNTIME_VERSION = '<scala_runtime_version>'
  PACKAGES = ( 'com.snowflake:snowpark:<version>' [, '<package_name_and_version>' ...] )
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<fully_qualified_method_name>'
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]
  AS '<procedure_definition>'

-- Example 11467
CREATE [ OR REPLACE ] [ SECURE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE SCALA
  RUNTIME_VERSION = '<scala_runtime_version>'
  PACKAGES = ( 'com.snowflake:snowpark:<version>' [, '<package_name_and_version>' ...] )
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<fully_qualified_method_name>'
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ VOLATILE | IMMUTABLE ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]

-- Example 11468
CREATE [ OR REPLACE ] PROCEDURE <name> (
    [ <arg_name> <arg_data_type> [ DEFAULT <default_value> ] ] [ , ... ] )
  [ COPY GRANTS ]
  RETURNS { <result_data_type> | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  [ NOT NULL ]
  LANGUAGE SQL
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ { VOLATILE | IMMUTABLE } ] -- Note: VOLATILE and IMMUTABLE are deprecated.
  [ COMMENT = '<string_literal>' ]
  [ EXECUTE AS { OWNER | CALLER | RESTRICTED CALLER } ]
  AS <procedure_definition>

-- Example 11469
CREATE [ OR ALTER ] PROCEDURE ...

-- Example 11470
CREATE OR REPLACE PROCEDURE get_top_sales()
  RETURNS TABLE (sales_date DATE, quantity NUMBER)
...

-- Example 11471
CREATE OR REPLACE PROCEDURE get_top_sales()
  RETURNS TABLE ()

-- Example 11472
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 11473
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 11474
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 11475
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 11476
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 11477
CREATE OR REPLACE TABLE table1 ("column 1" VARCHAR);

-- Example 11478
CREATE or replace PROCEDURE proc3()
  RETURNS VARCHAR
  LANGUAGE javascript
  AS
  $$
  var rs = snowflake.execute( { sqlText: 
      `INSERT INTO table1 ("column 1") 
           SELECT 'value 1' AS "column 1" ;`
       } );
  return 'Done.';
  $$;

-- Example 11479
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'java';

-- Example 11480
domain:package_name:version

-- Example 11481
PACKAGES = ('com.snowflake:snowpark:latest')

-- Example 11482
com.my_company.my_package.MyClass.myMethod

-- Example 11483
com.my_company.my_package

-- Example 11484
package com.my_company.my_package;

-- Example 11485
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'python';

-- Example 11486
package_name[==version]

-- Example 11487
PACKAGES = ('snowflake-snowpark-python', 'spacy==2.3.5')

-- Example 11488
-- Use version 1.2.3 or higher of the NumPy package.
PACKAGES=('numpy>=1.2.3')

-- Example 11489
CREATE OR REPLACE PROCEDURE MYPROC(from_table STRING, to_table STRING, count INT)
  ...
  HANDLER = 'run'
AS
$$
def run(session, from_table, to_table, count):
  ...
$$;

-- Example 11490
CREATE OR REPLACE PROCEDURE MYPROC(from_table STRING, to_table STRING, count INT)
  ...
  IMPORTS = ('@mystage/my_py_file.py')
  HANDLER = 'my_py_file.run';

-- Example 11491
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'scala';

-- Example 11492
domain:package_name:version

-- Example 11493
PACKAGES = ('com.snowflake:snowpark:latest')

-- Example 11494
com.my_company.my_package.MyClass.myMethod

-- Example 11495
com.my_company.my_package

-- Example 11496
package com.my_company.my_package;

-- Example 11497
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 11498
REMOVE @handlers/myhandler.jar;

-- Example 11499
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 11500
REMOVE @handlers/myhandler.jar;

-- Example 11501
CREATE OR REPLACE PROCEDURE sp_pi()
    RETURNS FLOAT NOT NULL
    LANGUAGE JAVASCRIPT
    AS
    $$
    return 3.1415926;
    $$
    ;

-- Example 11502
CREATE OR REPLACE PROCEDURE stproc1(FLOAT_PARAM1 FLOAT)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    STRICT
    EXECUTE AS OWNER
    AS
    $$
    var sql_command = 
     "INSERT INTO stproc_test_table1 (num_col1) VALUES (" + FLOAT_PARAM1 + ")";
    try {
        snowflake.execute (
            {sqlText: sql_command}
            );
        return "Succeeded.";   // Return a success/error indicator.
        }
    catch (err)  {
        return "Failed: " + err;   // Return a success/error indicator.
        }
    $$
    ;

-- Example 11503
CREATE OR REPLACE PROCEDURE my_proc(from_table STRING, to_table STRING, count INT)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'run'
AS
$$
def run(session, from_table, to_table, count):
  session.table(from_table).limit(count).write.save_as_table(to_table)
  return "SUCCESS"
$$;

