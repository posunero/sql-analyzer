-- Example 17131
sf-context-current-statement-base64

-- Example 17132
CREATE FUNCTION my_echo_udf (InputText VARCHAR)
  RETURNS VARCHAR
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 17133
CREATE OR ALTER FUNCTION my_echo_udf (InputText VARCHAR)
  RETURNS VARCHAR
  SERVICE = echo_service
  ENDPOINT = reverse_echoendpoint
  CONTEXT_HEADERS = (current_account)
  MAX_BATCH_ROWS = 100
  AS '/echo';

-- Example 17134
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

-- Example 17135
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

-- Example 17136
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

-- Example 17137
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

-- Example 17138
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

-- Example 17139
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

-- Example 17140
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

-- Example 17141
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

-- Example 17142
CREATE [ OR ALTER ] PROCEDURE ...

-- Example 17143
CREATE OR REPLACE PROCEDURE get_top_sales()
  RETURNS TABLE (sales_date DATE, quantity NUMBER)
...

-- Example 17144
CREATE OR REPLACE PROCEDURE get_top_sales()
  RETURNS TABLE ()

-- Example 17145
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 17146
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 17147
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 17148
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 17149
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 17150
CREATE OR REPLACE TABLE table1 ("column 1" VARCHAR);

-- Example 17151
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

-- Example 17152
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'java';

-- Example 17153
domain:package_name:version

-- Example 17154
PACKAGES = ('com.snowflake:snowpark:latest')

-- Example 17155
com.my_company.my_package.MyClass.myMethod

-- Example 17156
com.my_company.my_package

-- Example 17157
package com.my_company.my_package;

-- Example 17158
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'python';

-- Example 17159
package_name[==version]

-- Example 17160
PACKAGES = ('snowflake-snowpark-python', 'spacy==2.3.5')

-- Example 17161
-- Use version 1.2.3 or higher of the NumPy package.
PACKAGES=('numpy>=1.2.3')

-- Example 17162
CREATE OR REPLACE PROCEDURE MYPROC(from_table STRING, to_table STRING, count INT)
  ...
  HANDLER = 'run'
AS
$$
def run(session, from_table, to_table, count):
  ...
$$;

-- Example 17163
CREATE OR REPLACE PROCEDURE MYPROC(from_table STRING, to_table STRING, count INT)
  ...
  IMPORTS = ('@mystage/my_py_file.py')
  HANDLER = 'my_py_file.run';

-- Example 17164
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'scala';

-- Example 17165
domain:package_name:version

-- Example 17166
PACKAGES = ('com.snowflake:snowpark:latest')

-- Example 17167
com.my_company.my_package.MyClass.myMethod

-- Example 17168
com.my_company.my_package

-- Example 17169
package com.my_company.my_package;

-- Example 17170
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 17171
REMOVE @handlers/myhandler.jar;

-- Example 17172
TARGET_PATH = '@handlers/myhandler.jar'

-- Example 17173
REMOVE @handlers/myhandler.jar;

-- Example 17174
CREATE OR REPLACE PROCEDURE sp_pi()
    RETURNS FLOAT NOT NULL
    LANGUAGE JAVASCRIPT
    AS
    $$
    return 3.1415926;
    $$
    ;

-- Example 17175
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

-- Example 17176
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

-- Example 17177
CREATE OR REPLACE PROCEDURE my_proc(fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('@mystage/myjar.jar')
  HANDLER = 'MyClass.myMethod';

-- Example 17178
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

-- Example 17179
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

-- Example 17180
CREATE OR REPLACE PROCEDURE sp_pi()
  RETURNS FLOAT NOT NULL
  LANGUAGE JAVASCRIPT
  EXECUTE AS RESTRICTED CALLER
  AS
  $$
  RETURN 3.1415926;
  $$
  ;

-- Example 17181
GRANT CALLER SELECT ON VIEW v1 TO owner_role;

-- Example 17182
GRANT INHERITED CALLER SELECT, INSERT ON ALL TABLES IN SCHEMA db.sch TO ROLE owner_role;

-- Example 17183
GRANT ALL INHERITED CALLER PRIVILEGES ON ALL SCHEMAS IN ACCOUNT TO ROLE owner_role;

-- Example 17184
GRANT CALLER SELECT ON TABLE db.sch1.t1 TO DATABASE ROLE db.r;

-- Example 17185
GRANT ALL CALLER PRIVILEGES ON DATABASE my_db TO ROLE owner_role;

-- Example 17186
REVOKE ALL INHERITED CALLER PRIVILEGES ON ALL VIEWS IN ACCOUNT FROM ROLE owner_role;

-- Example 17187
REVOKE CALLER USAGE ON SCHEMA db.sch1 FROM ROLE owner_role;

-- Example 17188
SHOW CALLER GRANTS ON TABLE t1;

-- Example 17189
SHOW CALLER GRANTS ON ACCOUNT;

-- Example 17190
SHOW CALLER GRANTS TO DATABASE ROLE db.owner_role;

-- Example 17191
# Create your session
session = Session.builder.configs(CONNECTION_PARAMETERS).create()

# Acquire profiler object
profiler = session.stored_procedure_profiler()

-- Example 17192
profiler.set_target_stage("mydb.myschema.profiler_output")

-- Example 17193
profiler.set_active_profiler("LINE")

-- Example 17194
profiler.set_active_profiler("MEMORY")

-- Example 17195
session.call("my_stored_procedure")

-- Example 17196
profiler.get_output()

-- Example 17197
profiler.register_modules(["module_A", "module_B"])

