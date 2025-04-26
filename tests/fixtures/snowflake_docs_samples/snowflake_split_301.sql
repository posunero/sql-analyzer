-- Example 20145
CREATE OR REPLACE PROCEDURE test_udf_1()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES=('snowflake-snowpark-python')
  HANDLER = 'test_python_import_main.my_udf'
  IMPORTS = ('@stage1/test_python_import_main.py', '@stage2/test_python_import_module.py');

-- Example 20146
ALTER SESSION SET PYTHON_PROFILER_MODULES = 'test_python_import_main, test_python_import_module';

-- Example 20147
CREATE OR REPLACE PROCEDURE last_n_query_duration(last_n NUMBER, total NUMBER)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION=3.9
  PACKAGES=('snowflake-snowpark-python')
  HANDLER='main'
AS $$
import snowflake.snowpark.functions as funcs

def main(session, last_n, total):
  # create sample dataset to emulate id + elapsed time
  session.sql('''
  CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)
  ''').collect()
  session.sql('''
  INSERT INTO sample_query_history
  SELECT
  seq8() AS query_id,
  uniform(0::float, 100::float, random()) as elapsed_time
  FROM table(generator(rowCount => {0}));'''.format(total)).collect()

  # get the mean of the last n query elapsed time
  df = session.table('sample_query_history').select(
    funcs.col('query_id'),
    funcs.col('elapsed_time')).limit(last_n)

  pandas_df = df.to_pandas()
  mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
  del pandas_df
  return mean_time
$$;

CREATE TEMPORARY STAGE profiler_output;
ALTER SESSION SET PYTHON_PROFILER_TARGET_STAGE = "my_database.my_schema.profiler_output";
ALTER SESSION SET ACTIVE_PYTHON_PROFILER = 'LINE';

-- Sample 1 million from 10 million records
CALL last_n_query_duration(1000000, 10000000);

SELECT SNOWFLAKE.CORE.GET_PYTHON_PROFILER_OUTPUT(last_query_id());

-- Example 20148
Handler Name: main
Python Runtime Version: 3.9
Modules Profiled: ['main_module']
Timer Unit: 0.001 s

Total Time: 8.96127 s
File: _udf_code.py
Function: main at line 4

Line #      Hits        Time  Per Hit   % Time  Line Contents
==============================================================
    4                                           def main(session, last_n, total):
    5                                               # create sample dataset to emulate id + elapsed time
    6         1        122.3    122.3      1.4      session.sql('''
    7                                                   CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)''').collect()
    8         2       7248.4   3624.2     80.9      session.sql('''
    9                                               INSERT INTO sample_query_history
    10                                               SELECT
    11                                               seq8() AS query_id,
    12                                               uniform(0::float, 100::float, random()) as elapsed_time
    13         1          0.0      0.0      0.0      FROM table(generator(rowCount => {0}));'''.format(total)).collect()
    14
    15                                               # get the mean of the last n query elapsed time
    16         3         58.6     19.5      0.7      df = session.table('sample_query_history').select(
    17         1          0.0      0.0      0.0          funcs.col('query_id'),
    18         2          0.0      0.0      0.0          funcs.col('elapsed_time')).limit(last_n)
    19
    20         1       1528.4   1528.4     17.1      pandas_df = df.to_pandas()
    21         1          3.2      3.2      0.0      mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
    22         1          0.3      0.3      0.0      del pandas_df
    23         1          0.0      0.0      0.0      return mean_time

-- Example 20149
ALTER SESSION SET ACTIVE_PYTHON_PROFILER = 'MEMORY';

Handler Name: main
Python Runtime Version: 3.9
Modules Profiled: ['main_module']
File: _udf_code.py
Function: main at line 4

Line #   Mem usage    Increment  Occurrences  Line Contents
=============================================================
    4    245.3 MiB    245.3 MiB           1   def main(session, last_n, total):
    5                                             # create sample dataset to emulate id + elapsed time
    6    245.8 MiB      0.5 MiB           1       session.sql('''
    7                                                 CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)''').collect()
    8    245.8 MiB      0.0 MiB           2       session.sql('''
    9                                             INSERT INTO sample_query_history
    10                                             SELECT
    11                                             seq8() AS query_id,
    12                                             uniform(0::float, 100::float, random()) as elapsed_time
    13    245.8 MiB      0.0 MiB           1       FROM table(generator(rowCount => {0}));'''.format(total)).collect()
    14
    15                                             # get the mean of the last n query elapsed time
    16    245.8 MiB      0.0 MiB           3       df = session.table('sample_query_history').select(
    17    245.8 MiB      0.0 MiB           1           funcs.col('query_id'),
    18    245.8 MiB      0.0 MiB           2           funcs.col('elapsed_time')).limit(last_n)
    19
    20    327.9 MiB     82.1 MiB           1       pandas_df = df.to_pandas()
    21    328.9 MiB      1.0 MiB           1       mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
    22    320.9 MiB     -8.0 MiB           1       del pandas_df
    23    320.9 MiB      0.0 MiB           1       return mean_time

-- Example 20150
use role accountadmin;
alter account set ENABLE_INTERNAL_STAGES_PRIVATELINK = true;

-- Example 20151
use role accountadmin;
alter account set ENABLE_INTERNAL_STAGES_PRIVATELINK = true;
select key, value from table(flatten(input=>parse_json(system$get_privatelink_config())));

-- Example 20152
dig <bucket_name>.s3.<region>.amazonaws.com

-- Example 20153
alter account set S3_STAGE_VPCE_DNS_NAME='*.vpce-sd98fs0d9f8g.s3.us-west2.vpce.amazonaws.com';

-- Example 20154
CREATE [ OR REPLACE ] TASK [ IF NOT EXISTS ] <name>
    [ WITH TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ { WAREHOUSE = <string> } | { USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = <string> } ]
    [ SCHEDULE = { '<num> { HOURS | MINUTES | SECONDS }'
                 | 'USING CRON <expr> <time_zone>' } ]
    [ CONFIG = <configuration_string> ]
    [ ALLOW_OVERLAPPING_EXECUTION = TRUE | FALSE ]
    [ <session_parameter> = <value> [ , <session_parameter> = <value> ... ] ]
    [ USER_TASK_TIMEOUT_MS = <num> ]
    [ SUSPEND_TASK_AFTER_NUM_FAILURES = <num> ]
    [ ERROR_INTEGRATION = <integration_name> ]
    [ SUCCESS_INTEGRATION = <integration_name> ]
    [ LOG_LEVEL = '<log_level>' ]
    [ COMMENT = '<string_literal>' ]
    [ FINALIZE = <string> ]
    [ TASK_AUTO_RETRY_ATTEMPTS = <num> ]
    [ USER_TASK_MINIMUM_TRIGGER_INTERVAL_IN_SECONDS = <num> ]
    [ TARGET_COMPLETION_INTERVAL = '<num> { HOURS | MINUTES | SECONDS }' ]
    [ SERVERLESS_TASK_MIN_STATEMENT_SIZE = '{ XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | ... }' ]
    [ SERVERLESS_TASK_MAX_STATEMENT_SIZE = '{ XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | ... }' ]
  [ AFTER <string> [ , <string> , ... ] ]
  [ WHEN <boolean_expr> ]
  AS
    <sql>

-- Example 20155
CREATE OR ALTER TASK <name>
    [ { WAREHOUSE = <string> } | { USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = <string> } ]
    [ SCHEDULE = '{ <num> { HOURS | MINUTES | SECONDS } | USING CRON <expr> <time_zone> }' ]
    [ CONFIG = <configuration_string> ]
    [ ALLOW_OVERLAPPING_EXECUTION = TRUE | FALSE ]
    [ USER_TASK_TIMEOUT_MS = <num> ]
    [ <session_parameter> = <value> [ , <session_parameter> = <value> ... ] ]
    [ SUSPEND_TASK_AFTER_NUM_FAILURES = <num> ]
    [ ERROR_INTEGRATION = <integration_name> ]
    [ SUCCESS_INTEGRATION = <integration_name> ]
    [ COMMENT = '<string_literal>' ]
    [ FINALIZE = <string> ]
    [ TASK_AUTO_RETRY_ATTEMPTS = <num> ]
  [ AFTER <string> [ , <string> , ... ] ]
  [ WHEN <boolean_expr> ]
  AS
    <sql>

-- Example 20156
CREATE [ OR REPLACE ] TASK <name> CLONE <source_task>
  [ ... ]

-- Example 20157
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 20158
WHEN NOT SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_name')::BOOLEAN

-- Example 20159
WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_name') != 'VALIDATION'

-- Example 20160
WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_name')::FLOAT < 0.2

-- Example 20161
CREATE TASK my_task
    WHEN SYSTEM$STREAM_HAS_DATA('my_customer_stream')
    OR   SYSTEM$STREAM_HAS_DATA('my_order_stream')
    WAREHOUSE = my_warehouse
    AS
      SELECT CURRENT_TIMESTAMP;

-- Example 20162
CREATE TASK t1
  SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  AS
    SELECT CURRENT_TIMESTAMP;

-- Example 20163
CREATE TASK mytask_hour
  WAREHOUSE = mywh
  SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'
  AS
    SELECT CURRENT_TIMESTAMP;

-- Example 20164
CREATE TASK t1
  SCHEDULE = '60 MINUTES'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  AS
    INSERT INTO mytable(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 20165
CREATE TASK mytask_minute
  WAREHOUSE = mywh
  SCHEDULE = '5 MINUTES'
  AS
    INSERT INTO mytable(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 20166
CREATE TASK mytask1
  WAREHOUSE = mywh
  SCHEDULE = '5 MINUTES'
  WHEN
    SYSTEM$STREAM_HAS_DATA('MYSTREAM')
  AS
    INSERT INTO mytable1(id,name) SELECT id, name FROM mystream WHERE METADATA$ACTION = 'INSERT';

-- Example 20167
-- Create task5 and specify task2, task3, task4 as predecessors tasks.
-- The new task is a serverless task that inserts the current timestamp into a table column.
CREATE TASK task5
  AFTER task2, task3, task4
AS
  INSERT INTO t1(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 20168
-- Create a stored procedure that unloads data from a table
-- The COPY statement in the stored procedure unloads data to files in a path identified by epoch time (using the Date.now() method)
CREATE OR REPLACE PROCEDURE my_unload_sp()
  returns string not null
  language javascript
  AS
    $$
      var my_sql_command = ""
      var my_sql_command = my_sql_command.concat("copy into @mystage","/",Date.now(),"/"," from mytable overwrite=true;");
      var statement1 = snowflake.createStatement( {sqlText: my_sql_command} );
      var result_set1 = statement1.execute();
    return my_sql_command; // Statement returned for info/debug purposes
    $$;

-- Create a task that calls the stored procedure every hour
CREATE TASK my_copy_task
  WAREHOUSE = mywh
  SCHEDULE = '60 MINUTES'
  AS
    CALL my_unload_sp();

-- Example 20169
!set sql_delimiter=/
CREATE OR REPLACE TASK test_logging
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = 'USING CRON  0 * * * * America/Los_Angeles'
  AS
    BEGIN
      ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
      SELECT CURRENT_TIMESTAMP;
    END;/
!set sql_delimiter=';'

-- Example 20170
CREATE TASK t1
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '15 SECONDS'
  AS
    EXECUTE IMMEDIATE
    $$
    DECLARE
      radius_of_circle float;
      area_of_circle float;
    BEGIN
      radius_of_circle := 3;
      area_of_circle := pi() * radius_of_circle * radius_of_circle;
      return area_of_circle;
    END;
    $$;

-- Example 20171
CREATE OR REPLACE TASK root_task_with_config
  WAREHOUSE=mywarehouse
  SCHEDULE='10 m'
  CONFIG=$${"output_dir": "/temp/test_directory/", "learning_rate": 0.1}$$
  AS
    BEGIN
      LET OUTPUT_DIR STRING := SYSTEM$GET_TASK_GRAPH_CONFIG('output_dir')::string;
      LET LEARNING_RATE DECIMAL := SYSTEM$GET_TASK_GRAPH_CONFIG('learning_rate')::DECIMAL;
    ...
    END;

-- Example 20172
CREATE TASK finalize_task
  WAREHOUSE = my_warehouse
  FINALIZE = my_root_task
  AS
    CALL SYSTEM$SEND_EMAIL(
      'my_email_int',
      'first.last@example.com, first2.last2@example.com',
      'Email Alert: Task A has finished.',
      'Task A has successfully finished.\nStart Time: 10:10:32\nEnd Time: 12:15:45\nTotal Records Processed: 115678'
    );

-- Example 20173
CREATE TASK triggeredTask  WAREHOUSE = my_warehouse
  WHEN system$stream_has_data('my_stream')
  AS
    INSERT INTO my_downstream_table
    SELECT * FROM my_stream;

ALTER TASK triggeredTask RESUME;

-- Example 20174
CREATE OR ALTER TASK my_task
  WAREHOUSE = my_warehouse
  SCHEDULE = '60 MINUTES'
  AS
    SELECT PI();

-- Example 20175
CREATE OR ALTER TASK my_task
  WAREHOUSE = regress
  AFTER my_other_task
  AS
    SELECT 2 * PI();

-- Example 20176
CREATE TABLE <name> ( <col1_name> <col1_type>    [ NOT NULL ] { inlineUniquePK | inlineFK }
                     [ , <col2_name> <col2_type> [ NOT NULL ] { inlineUniquePK | inlineFK } ]
                     [ , ... ] )

ALTER TABLE <name> ADD COLUMN <col_name> <col_type> [ NOT NULL ] { inlineUniquePK | inlineFK }

-- Example 20177
inlineUniquePK ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY }
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]

-- Example 20178
inlineFK :=
  [ CONSTRAINT <constraint_name> ]
  [ FOREIGN KEY ]
  REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  [ MATCH { FULL | SIMPLE | PARTIAL } ]
  [ ON [ UPDATE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]
       [ DELETE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ] ]
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]

-- Example 20179
CREATE TABLE <name> ... ( <col1_name> <col1_type>
                         [ , <col2_name> <col2_type> , ... ]
                         [ , { outoflineUniquePK | outoflineFK } ]
                         [ , { outoflineUniquePK | outoflineFK } ]
                         [ , ... ] )

ALTER TABLE <name> ... ADD { outoflineUniquePK | outoflineFK }

-- Example 20180
outoflineUniquePK ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY } ( <col_name> [ , <col_name> , ... ] )
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]
  [ COMMENT '<string_literal>' ]

-- Example 20181
outoflineFK :=
  [ CONSTRAINT <constraint_name> ]
  FOREIGN KEY ( <col_name> [ , <col_name> , ... ] )
  REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  [ MATCH { FULL | SIMPLE | PARTIAL } ]
  [ ON [ UPDATE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]
       [ DELETE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ] ]
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]
  [ COMMENT '<string_literal>' ]

-- Example 20182
[ NOT ] ENFORCED
[ NOT ] DEFERRABLE
INITIALLY { DEFERRED | IMMEDIATE }
{ ENABLE | DISABLE }
{ VALIDATE | NOVALIDATE }
{ RELY | NORELY }

-- Example 20183
ALTER TABLE table_with_primary_key ALTER CONSTRAINT a_primary_key_constraint RELY;
ALTER TABLE table_with_foreign_key ALTER CONSTRAINT a_foreign_key_constraint RELY;

-- Example 20184
MATCH { FULL | SIMPLE | PARTIAL }
ON [ UPDATE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]
   [ DELETE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]

-- Example 20185
CREATE OR REPLACE TABLE uni (c1 INT, c2 int, CONSTRAINT uni1 UNIQUE(C1) COMMENT 'Unique column');

-- Example 20186
CREATE OR REPLACE TABLE uni (c1 INT UNIQUE COMMENT 'Unique column', c2 int);

-- Example 20187
COMMENT = 'My comment'

-- Example 20188
COMMENT 'My comment'

-- Example 20189
CREATE TABLE parent ... CONSTRAINT primary_key_1 PRIMARY KEY (c_1, c_2) ...
CREATE TABLE child  ... CONSTRAINT foreign_key_1 FOREIGN KEY (...) REFERENCES parent (c_1, c_2) ...

-- Example 20190
GRANT REFERENCES ON TABLE <pk_table_name> TO ROLE <role_name>

REVOKE REFERENCES ON TABLE <pk_table_name> FROM ROLE <role_name>

-- Example 20191
CREATE TABLE table1 (col1 INTEGER NOT NULL);

-- Example 20192
ALTER TABLE table1 ADD COLUMN col2 VARCHAR NOT NULL;

-- Example 20193
ALTER TABLE table1 
  ADD COLUMN col3 VARCHAR NOT NULL CONSTRAINT uniq_col3 UNIQUE NOT ENFORCED;

-- Example 20194
CREATE TABLE table2 (
  col1 INTEGER NOT NULL,
  col2 INTEGER NOT NULL,
  CONSTRAINT pkey_1 PRIMARY KEY (col1, col2) NOT ENFORCED
);
CREATE TABLE table3 (
  col_a INTEGER NOT NULL,
  col_b INTEGER NOT NULL,
  CONSTRAINT fkey_1 FOREIGN KEY (col_a, col_b) REFERENCES table2 (col1, col2) NOT ENFORCED
);

-- Example 20195
CREATE PROCEDURE MyProcedure()
...
$$
   READ SESSION_VAR1;
   SET SESSION_VAR2;
$$
;

-- Example 20196
SET SESSION_VAR1 = 'some interesting value';
CALL MyProcedure();
SELECT *
  FROM table1
  WHERE column1 = $SESSION_VAR2;

-- Example 20197
SET SESSION_VAR1 = 'some interesting value';
READ SESSION_VAR1;
SET SESSION_VAR2;
SELECT *
  FROM table1
  WHERE column1 = $SESSION_VAR2;

-- Example 20198
SET Variable_1 = 49;

CREATE PROCEDURE sv_proc2(PARAMETER_1 FLOAT)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  AS
  $$
    var rs = snowflake.execute( {sqlText: "SELECT 2 * " + PARAMETER_1} );
    rs.next();
    var MyString = rs.getColumnValue(1);
    return MyString;
  $$
  ;

CALL sv_proc2($Variable_1);

-- Example 20199
CREATE PROCEDURE sv_proc1()
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
  AS
  $$
    var rs = snowflake.execute( {sqlText: "SET SESSION_VAR_ZYXW = 51"} );

    var rs = snowflake.execute( {sqlText: "SELECT 2 * $SESSION_VAR_ZYXW"} );
    rs.next();
    var MyString = rs.getColumnValue(1);

    rs = snowflake.execute( {sqlText: "UNSET SESSION_VAR_ZYXW"} );

    return MyString;
  $$
  ;

CALL sv_proc1();

-- This fails because SESSION_VAR_ZYXW is no longer defined.
SELECT $SESSION_VAR_ZYXW;

-- Example 20200
SET PROVINCE = 'Manitoba';
CALL MyProcedure($PROVINCE);

-- Example 20201
USE ROLE admin;
GRANT USAGE ON DATABASE admin_db TO ROLE analyst;
GRANT USAGE ON SCHEMA admin_schema TO ROLE analyst;
GRANT CREATE SNOWFLAKE.ML.ANOMALY_DETECTION ON SCHEMA admin_db.admin_schema TO ROLE analyst;

-- Example 20202
USE ROLE analyst;
USE SCHEMA admin_db.admin_schema;

-- Example 20203
USE ROLE analyst;
CREATE SCHEMA analyst_db.analyst_schema;
USE SCHEMA analyst_db.analyst_schema;

-- Example 20204
REVOKE CREATE SNOWFLAKE.ML.ANOMALY_DETECTION ON SCHEMA admin_db.admin_schema FROM ROLE analyst;

-- Example 20205
CREATE OR REPLACE TABLE historical_sales_data (
  store_id NUMBER, item VARCHAR, date TIMESTAMP_NTZ, sales FLOAT, label BOOLEAN,
  temperature NUMBER, humidity FLOAT, holiday VARCHAR);

INSERT INTO historical_sales_data VALUES
  (1, 'jacket', to_timestamp_ntz('2020-01-01'), 2.0, false, 50, 0.3, 'new year'),
  (1, 'jacket', to_timestamp_ntz('2020-01-02'), 3.0, false, 52, 0.3, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-03'), 5.0, false, 54, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-04'), 30.0, true, 54, 0.3, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-05'), 8.0, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-06'), 6.0, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-07'), 4.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-08'), 2.7, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-09'), 8.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-10'), 9.2, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-11'), 4.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-12'), 7.0, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-13'), 3.6, false, 55, 0.2, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-14'), 8.0, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-01'), 3.4, false, 50, 0.3, 'new year'),
  (2, 'umbrella', to_timestamp_ntz('2020-01-02'), 5.0, false, 52, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-03'), 4.0, false, 54, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-04'), 5.4, false, 54, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-05'), 3.7, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-06'), 3.2, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-07'), 3.2, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-08'), 5.6, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-09'), 7.3, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-10'), 8.2, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-11'), 3.7, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-12'), 5.7, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-13'), 6.3, false, 55, 0.2, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-14'), 2.9, false, 55, 0.2, null);

-- Example 20206
CREATE OR REPLACE TABLE new_sales_data (
  store_id NUMBER, item VARCHAR, date TIMESTAMP_NTZ, sales FLOAT,
  temperature NUMBER, humidity FLOAT, holiday VARCHAR);

INSERT INTO new_sales_data VALUES
  (1, 'jacket', to_timestamp_ntz('2020-01-16'), 6.0, 52, 0.3, null),
  (1, 'jacket', to_timestamp_ntz('2020-01-17'), 20.0, 53, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-16'), 3.0, 52, 0.3, null),
  (2, 'umbrella', to_timestamp_ntz('2020-01-17'), 70.0, 53, 0.3, null);

-- Example 20207
CREATE SNOWFLAKE.ML.ANOMALY_DETECTION mydetector(...);

-- Example 20208
CALL mydetector!DETECT_ANOMALIES(...);

-- Example 20209
SELECT ts, forecast FROM TABLE(mydetector!DETECT_ANOMALIES(...));

-- Example 20210
SHOW SNOWFLAKE.ML.ANOMALY_DETECTION;

-- Example 20211
DROP SNOWFLAKE.ML.ANOMALY_DETECTION <name>;

