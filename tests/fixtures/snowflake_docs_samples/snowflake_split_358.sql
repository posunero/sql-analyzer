-- Example 23961
'datasets':[
  {
    'input_table': 'd.s.orders',
    'output_table': 'd.s.orders_synth',
    'columns': {'cust_id': {'join_key': True, 'replace': 'uuid'}, ...}
  },
  {
    'input_table': 'd.s.customers',
    'output_table': 'd.s.customers_synth',
    'columns' : {'cust_id': {'join_key': True, 'replace':'uuid'}, ...}

  }
]

-- Example 23962
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.PATIENTS1',
        'output_table': 'MY_DB.PUBLIC.PATIENTS1',
        'columns': { 'patient_id': {'join_key': TRUE}, 'age':{'join_key': TRUE}}
      },
      {
        'input_table': 'CLINICAL_DB.PUBLIC.PATIENTS2',
        'output_table': 'MY_DB.PUBLIC.PATIENTS2',
        'columns': { 'patient_id': {'join_key': TRUE}, 'age':{'join_key': TRUE}}
      }
    ],
    'replace_output_tables': TRUE
});

-- Example 23963
-- Generate consistent join keys across multiple runs by
-- providing a symmetric key secret.
CREATE OR REPLACE SECRET my_db.public.my_consistency_secret
  TYPE=SYMMETRIC_KEY
  ALGORITHM=GENERIC;

CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.BASE_TABLE',
        'output_table': 'MY_DB.PUBLIC.PATIENTS1',
        'columns': { 'patient_id': {'join_key': TRUE}}
      }
    ],
    'consistency_secret': SYSTEM$REFERENCE('SECRET', 'MY_CONSISTENCY_SECRET', 'SESSION', 'READ')::STRING,
    'replace_output_tables': TRUE
});

CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.SECOND_TABLE',
        'output_table': 'MY_DB.PUBLIC.PATIENTS2',
        'columns': { 'patient_id': {'join_key': TRUE}}
      }
    ],
    'consistency_secret': SYSTEM$REFERENCE('SECRET', 'MY_CONSISTENCY_SECRET', 'SESSION', 'READ')::STRING,
    'replace_output_tables': TRUE
});

-- Example 23964
USE ROLE ACCOUNTADMIN;
CREATE or REPLACE DATABASE SNOWFLAKE_SAMPLE_DATA from share SFC_SAMPLES.SAMPLE_DATA;

-- Example 23965
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE ROLE data_engineer;
CREATE OR REPLACE DATABASE syndata_db;
CREATE OR REPLACE WAREHOUSE syndata_wh;

GRANT OWNERSHIP ON DATABASE syndata_db TO ROLE data_engineer;
GRANT USAGE ON WAREHOUSE syndata_wh TO ROLE data_engineer;
GRANT ROLE data_engineer TO USER jsmith; -- Or whoever you want to run this example. Or skip this line to run it yourself.

-- Example 23966
- Sign in as user with data_engineer role. Then...
CREATE SCHEMA syndata_db.sch;
CREATE OR REPLACE VIEW syndata_db.sch.TPC_ORDERS_5K as (
    SELECT * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
    LIMIT 5000
);
CREATE OR REPLACE VIEW syndata_db.sch.TPC_CUSTOMERS_5K as (
    SELECT * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
    LIMIT 5000
);

-- Example 23967
USE WAREHOUSE syndata_wh;
SELECT TOP 20 * FROM syndata_db.sch.TPC_ORDERS_5K;
SELECT COUNT(*) FROM syndata_db.sch.TPC_ORDERS_5K;
select count(distinct o_clerk), count(*) from syndata_db.sch.TPC_ORDERS_5K;

SELECT TOP 20 * FROM syndata_db.sch.TPC_CUSTOMERS_5K;
SELECT COUNT(*) FROM syndata_db.sch.TPC_CUSTOMERS_5K;

-- Example 23968
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
    'datasets':[
        {
          'input_table': 'syndata_db.sch.TPC_ORDERS_5K',
          'output_table': 'syndata_db.sch.TPC_ORDERS_5K_SYNTHETIC',
          'columns': {'O_CUSTKEY': {'join_key': True}}
        },
        {
          'input_table': 'syndata_db.sch.TPC_CUSTOMERS_5K',
          'output_table': 'syndata_db.sch.TPC_CUSTOMERS_5K_SYNTHETIC',
          'columns' : {'C_CUSTKEY': {'join_key': True}}

        }
      ],
      'replace_output_tables':True
  });

-- Example 23969
SELECT TOP 20 * FROM syndata_db.sch.TPC_ORDERS_5K_SYNTHETIC;
SELECT COUNT(*) FROM syndata_db.sch.TPC_ORDERS_5K_SYNTHETIC;

SELECT TOP 20 * FROM syndata_db.sch.TPC_CUSTOMERS_5K_SYNTHETIC;
SELECT COUNT(*) FROM syndata_db.sch.TPC_CUSTOMERS_5K_SYNTHETIC;

-- Example 23970
USE ROLE ACCOUNTADMIN;
DROP DATABASE syndata_db;
DROP ROLE data_engineer;
DROP WAREHOUSE syndata_wh;

-- Example 23971
Function name (including parameter and return type) too long.

-- Example 23972
CALL mydatabase.myschema.myprocedure();

-- Example 23973
CREATE OR REPLACE FUNCTION myudf (number_argument NUMBER) ...

-- Example 23974
CREATE OR REPLACE FUNCTION myudf (varchar_argument VARCHAR) ...

-- Example 23975
CREATE OR REPLACE FUNCTION myudf (number_argument NUMBER, varchar_argument VARCHAR) ...

-- Example 23976
CREATE OR REPLACE PROCEDURE myproc (number_argument NUMBER) ...

-- Example 23977
CREATE OR REPLACE PROCEDURE myproc (varchar_argument VARCHAR) ...

-- Example 23978
CREATE OR REPLACE PROCEDURE myproc (number_argument NUMBER, varchar_argument VARCHAR) ...

-- Example 23979
CREATE OR REPLACE FUNCTION echo_input (numeric_input NUMBER)
  RETURNS NUMBER
  AS 'numeric_input';

-- Example 23980
CREATE OR REPLACE FUNCTION echo_input (varchar_input VARCHAR)
  RETURNS VARCHAR
  AS 'varchar_input';

-- Example 23981
SELECT echo_input(numeric_input => 10);

-- Example 23982
SELECT echo_input(varchar_input => 'hello world');

-- Example 23983
SELECT myudf(text_input => 'hello world');

-- Example 23984
SELECT myudf('hello world');

-- Example 23985
CREATE OR REPLACE FUNCTION add5 (n NUMBER)
  RETURNS NUMBER
  AS 'n + 5';

CREATE OR REPLACE FUNCTION add5 (s VARCHAR)
  RETURNS VARCHAR
  AS
  $$
    s || '5'
  $$;

-- Example 23986
SELECT add5(1);

-- Example 23987
+---------+
| ADD5(1) |
|---------|
|       6 |
+---------+

-- Example 23988
SELECT add5('1');

-- Example 23989
+-----------+
| ADD5('1') |
|-----------|
| 15        |
+-----------+

-- Example 23990
SELECT add5('hello');

-- Example 23991
+---------------+
| ADD5('HELLO') |
|---------------|
| hello5        |
+---------------+

-- Example 23992
SELECT add5(TO_DATE('2014-01-01'));

-- Example 23993
+-----------------------------+
| ADD5(TO_DATE('2014-01-01')) |
|-----------------------------|
| 2014-01-015                 |
+-----------------------------+

-- Example 23994
SELECT add5(n => 1);

-- Example 23995
SELECT add5(s => '1');

-- Example 23996
USE SCHEMA s1;
CREATE OR REPLACE FUNCTION add5 ( n number)
  RETURNS number
  AS 'n + 5';

-- Example 23997
USE SCHEMA s2;
CREATE OR REPLACE FUNCTION add5 ( s string)
  RETURNS string
  AS 's || ''5''';

-- Example 23998
USE SCHEMA s3;
ALTER SESSION SET SEARCH_PATH='s1,s2';

SELECT add5(5);

-- Example 23999
+---------+
| ADD5(5) |
+---------+
| 10      |
+---------+

-- Example 24000
ALTER SESSION SET SEARCH_PATH='s2,s1';

SELECT add5(5);

+---------+
| ADD5(5) |
*---------+
| 55      |
+---------+

-- Example 24001
[connections]
# *WARNING* *WARNING* *WARNING* *WARNING* *WARNING* *WARNING*
#
# The Snowflake user password is stored in plain text in this file.
# Pay special attention to the management of this file.
# Thank you.
#
# *WARNING* *WARNING* *WARNING* *WARNING* *WARNING* *WARNING*

#If a connection doesn't specify a value, it will default to these
#
#accountname = defaultaccount
#region = defaultregion
#username = defaultuser
#password = defaultpassword
#dbname = defaultdbname
#schemaname = defaultschema
#warehousename = defaultwarehouse
#rolename = defaultrolename
#proxy_host = defaultproxyhost
#proxy_port = defaultproxyport

[connections.example]
#Can be used in SnowSql as #connect example

accountname = my_organization-my_account
username = username
password = password1234

[variables]
# SnowSQL defines the variables in this section on startup.
# You can use these variables in SQL statements. For details, see
# https://docs.snowflake.com/en/user-guide/snowsql-use.html#using-variables

# example_variable=27

[options]
# If set to false auto-completion will not occur interactive mode.
auto_completion = True

# main log file location. The file includes the log from SnowSQL main
# executable.
log_file = ~/.snowsql/log

# bootstrap log file location. The file includes the log from SnowSQL bootstrap
# executable.
# log_bootstrap_file = ~/.snowsql/log_bootstrap

# Default log level. Possible values: "CRITICAL", "ERROR", "WARNING", "INFO"
# and "DEBUG".
log_level = INFO

# Timing of sql statements and table rendering.
timing = True

# Table format. Possible values: psql, plain, simple, grid, fancy_grid, pipe,
# orgtbl, rst, mediawiki, html, latex, latex_booktabs, tsv.
# Recommended: psql, fancy_grid and grid.
output_format = psql

# Keybindings: Possible values: emacs, vi.
# Emacs mode: Ctrl-A is home, Ctrl-E is end. All emacs keybindings are available in the REPL.
# When Vi mode is enabled you can use modal editing features offered by Vi in the REPL.
key_bindings = emacs

# OCSP Fail Open Mode.
# The only OCSP scenario which will lead to connection failure would be OCSP response with a
# revoked status. Any other errors or in the OCSP module will not raise an error.
# ocsp_fail_open = True

# Enable temporary credential file for Linux users
# For Linux users, since there are no OS-key-store, an unsecure temporary credential for SSO can be enabled by this option. The default value for this option is False.
# client_store_temporary_credential = True

# Select statement split method (default is to use the sql_split method in snowsql, which does not support 'sql_delimiter')
# sql_split = snowflake.connector.util_text # to use connector's statement_split which has legacy support to 'sql_delimiter'.

# Force the result data to be decoded in utf-8. By default the value is set to false for compatibility with legacy data. It is recommended to set the value to true.
# json_result_force_utf8_decoding = False

-- Example 24002
$ chmod 700 ~/.snowsql/config

-- Example 24003
password = "my$^pwd"

-- Example 24004
password = "my$^\"\'pwd"

-- Example 24005
prompt_format='''[#FFFF00][user]@[account]
[#00FF00]> '''

-- Example 24006
[options]
<option_name> = <option_value>

-- Example 24007
+----------------------------+---------------------+------------------------------------------------------------------------------------+
| Name                       | Value               | Help                                                                               |
+----------------------------+---------------------+------------------------------------------------------------------------------------+
| auto_completion            | True                | Displays auto-completion suggestions for commands and Snowflake objects.           |
| client_session_keep_alive  | False               | Keeps the session active indefinitely, even if there is no activity from the user. |
| echo                       | False               | Outputs the SQL command to the terminal when it is executed.                       |
| editor                     | vim                 | Changes the editor to use for the !edit command.                                   |
| empty_for_null_in_tsv      | False               | Outputs an empty string for NULL values in TSV format.                             |
| environment_variables      | ['PATH']            | Specifies the environment variables that can be referenced as SnowSQL variables.   |
|                            |                     | The variable names should be comma separated.                                      |
| execution_only             | False               | Executes queries only.                                                             |
| exit_on_error              | False               | Quits when SnowSQL encounters an error.                                            |
| fix_parameter_precedence   | True                | Controls the precedence of the environment variable and the config file entries    |
|                            |                     | for password, proxy password, and private key phrase.                              |
| force_put_overwrite        | False               | Force PUT command to stage data files without checking whether already exists.     |
| friendly                   | True                | Shows the splash text and goodbye messages.                                        |
| header                     | True                | Outputs the header in query results.                                               |
| insecure_mode              | False               | Turns off OCSP certificate checks.                                                 |
| key_bindings               | emacs               | Changes keybindings for navigating the prompt to emacs or vi.                      |
| log_bootstrap_file         | ~/.snowsql/log_...  | SnowSQL bootstrap log file location.                                               |
| log_file                   | ~/.snowsql/log      | SnowSQL main log file location.                                                    |
| log_level                  | CRITICAL            | Changes the log level (critical, debug, info, error, warning).                     |
| login_timeout              | 120                 | Login timeout in seconds.                                                          |
| noup                       | False               | Turns off auto upgrading SnowSQL.                                                  |
| output_file                | None                | Writes output to the specified file in addition to the terminal.                   |
| output_format              | psql                | Sets the output format for query results.                                          |
| paging                     | False               | Enables paging to pause output per screen height.                                  |
| progress_bar               | True                | Shows progress bar while transferring data.                                        |
| prompt_format              | [user]#[warehou...] | Sets the prompt format. Experimental feature, currently not documented.            |
| sfqid                      | False               | Turns on/off Snowflake query id in the summary.                                    |
| sfqid_in_error             | False               | Turns on/off Snowflake query id in the error message.                              |
| quiet                      | False               | Hides all output.                                                                  |
| remove_comments            | False               | Removes comments before sending query to Snowflake.                                |
| remove_trailing_semicolons | True                | Removes trailing semicolons from SQL text before sending queries to Snowflake.     |
| results                    | True                | If set to off, queries will be sent asynchronously, but no results will be fetched.|
|                            |                     | Use !queries to check the status.                                                  |
| rowset_size                | 1000                | Sets the size of rowsets to fetch from the server.                                 |
|                            |                     | Set the option low for smooth output, high for fast output.                        |
| stop_on_error              | False               | Stops all queries yet to run when SnowSQL encounters an error.                     |
| syntax_style               | default             | Sets the colors for the text of SnowSQL.                                           |
| timing                     | True                | Turns on/off timing for each query.                                                |
| timing_in_output_file      | False               | Includes timing in the output file.                                                |
| variable_substitution      | False               | Substitutes variables (starting with '&') with values.                             |
| version                    | 1.1.70              | Returns SnowSQL version.                                                           |
| wrap                       | True                | Truncates lines at the width of the terminal screen.                               |
+----------------------------+---------------------+------------------------------------------------------------------------------------+

-- Example 24008
prompt_format="[#FF0000][user]@[#00FF00][database][schema][#0000FF][warehouse]"

-- Example 24009
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE
    FIRST_AUTHENTICATION_FACTOR = 'OAUTH_ACCESS_TOKEN'
    AND
    REPORTED_CLIENT_TYPE = 'SNOWFLAKE_UI'
    AND
    EVENT_TIMESTAMP > DATEADD('DAY', -2, CURRENT_DATE());
ORDER BY
    EVENT_TIMESTAMP DESC;

-- Example 24010
SELECT
    COUNT(O_ORDERDATE) as orders,
    :datebucket(O_ORDERDATE) as bucket
FROM
    SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
WHERE
    O_ORDERDATE = :daterange
GROUP BY
    :datebucket(O_ORDERDATE)
ORDER BY
    bucket;

-- Example 24011
+--------+------------+
| orders |  buckets   |
+--------+------------+
|    621 | 1992-01-01 |
|    612 | 1992-01-02 |
|    598 | 1992-01-03 |
|    670 | 1992-01-04 |
+--------+------------+

-- Example 24012
+--------+------------+
| orders |  buckets   |
+--------+------------+
|   3142 | 1991-12-30 |
|   4404 | 1992-01-06 |
|   4306 | 1992-01-13 |
|   4284 | 1992-01-20 |
+--------+------------+

-- Example 24013
# Import the upper function from the functions module.
from snowflake.snowpark.functions import upper, col
session.table("sample_product_data").select(upper(col("name")).alias("upper_name")).collect()

-- Example 24014
[Row(UPPER_NAME='PRODUCT 1'), Row(UPPER_NAME='PRODUCT 1A'), Row(UPPER_NAME='PRODUCT 1B'), Row(UPPER_NAME='PRODUCT 2'),
Row(UPPER_NAME='PRODUCT 2A'), Row(UPPER_NAME='PRODUCT 2B'), Row(UPPER_NAME='PRODUCT 3'), Row(UPPER_NAME='PRODUCT 3A'),
Row(UPPER_NAME='PRODUCT 3B'), Row(UPPER_NAME='PRODUCT 4'), Row(UPPER_NAME='PRODUCT 4A'), Row(UPPER_NAME='PRODUCT 4B')]

-- Example 24015
# Import the call_function function from the functions module.
from snowflake.snowpark.functions import call_function
df = session.create_dataframe([[1, 2], [3, 4]], schema=["col1", "col2"])
# Call the system-defined function RADIANS() on col1.
df.select(call_function("radians", col("col1"))).collect()

-- Example 24016
[Row(RADIANS("COL1")=0.017453292519943295), Row(RADIANS("COL1")=0.05235987755982988)]

-- Example 24017
# Import the call_function function from the functions module.
from snowflake.snowpark.functions import function

# Create a function object for the system-defined function RADIANS().
radians = function("radians")
df = session.create_dataframe([[1, 2], [3, 4]], schema=["col1", "col2"])
# Call the system-defined function RADIANS() on col1.
df.select(radians(col("col1"))).collect()

-- Example 24018
[Row(RADIANS("COL1")=0.017453292519943295), Row(RADIANS("COL1")=0.05235987755982988)]

-- Example 24019
# Import the call_udf function from the functions module.
from snowflake.snowpark.functions import call_udf

# Runs the scalar function 'minus_one' on col1 of df.
df = session.create_dataframe([[1, 2], [3, 4]], schema=["col1", "col2"])
df.select(call_udf("minus_one", col("col1"))).collect()

-- Example 24020
[Row(MINUS_ONE("COL1")=0), Row(MINUS_ONE("COL1")=2)]

-- Example 24021
from snowflake.snowpark.types import IntegerType, StructField, StructType
from snowflake.snowpark.functions import udtf, lit
class GeneratorUDTF:
    def process(self, n):
        for i in range(n):
            yield (i, )
generator_udtf = udtf(GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
session.table_function(generator_udtf(lit(3))).collect()

-- Example 24022
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 24023
from snowflake.snowpark.functions import table_function
split_to_table = table_function("split_to_table")
df = session.create_dataframe([
  ["John", "James", "address1 address2 address3"],
  ["Mike", "James", "address4 address5 address6"],
  ["Cathy", "Stone", "address4 address5 address6"],
],
schema=["first_name", "last_name", "addresses"])
df.join_table_function(split_to_table(df["addresses"], lit(" ")).over(partition_by="last_name", order_by="first_name")).show()

-- Example 24024
----------------------------------------------------------------------------------------
|"FIRST_NAME"  |"LAST_NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
----------------------------------------------------------------------------------------
|John          |James        |address1 address2 address3  |1      |1        |address1  |
|John          |James        |address1 address2 address3  |1      |2        |address2  |
|John          |James        |address1 address2 address3  |1      |3        |address3  |
|Mike          |James        |address4 address5 address6  |2      |1        |address4  |
|Mike          |James        |address4 address5 address6  |2      |2        |address5  |
|Mike          |James        |address4 address5 address6  |2      |3        |address6  |
|Cathy         |Stone        |address4 address5 address6  |3      |1        |address4  |
|Cathy         |Stone        |address4 address5 address6  |3      |2        |address5  |
|Cathy         |Stone        |address4 address5 address6  |3      |3        |address6  |
----------------------------------------------------------------------------------------

-- Example 24025
session.call("your_proc_name", 1)

-- Example 24026
0

-- Example 24027
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE
    FIRST_AUTHENTICATION_FACTOR = 'OAUTH_ACCESS_TOKEN'
    AND
    REPORTED_CLIENT_TYPE = 'SNOWFLAKE_UI'
    AND
    EVENT_TIMESTAMP > DATEADD('DAY', -2, CURRENT_DATE());
ORDER BY
    EVENT_TIMESTAMP DESC;

