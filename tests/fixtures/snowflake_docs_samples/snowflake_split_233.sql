-- Example 15591
create or replace function native_module_test_zip()
   returns string
   language python
   runtime_version=3.9
   resource_constraint=(architecture='x86')
   imports=('@mystage/mycustompackage.zip')
   handler='compute'
   as
   $$
   def compute():
      import mycustompackage
      return mycustompackage.mycustompackage()
   $$;

-- Example 15592
select * from information_schema.packages where language = 'python';

-- Example 15593
select * from information_schema.packages where (package_name = 'numpy' and language = 'python');

-- Example 15594
desc function stock_sale_average(varchar, number, number);

-- Example 15595
conda create --name py39_env -c https://repo.anaconda.com/pkgs/snowflake python=3.9 numpy pandas

-- Example 15596
import xgboost as xgb
model = xgb.Booster()
model.set_param('nthread', 1)
model.load_model(...)

-- Example 15597
import xgboost as xgb
model = xgb.XGBRegressor(n_jobs=1)

-- Example 15598
import keras
model = keras.models.load_model(...)
model.predict_on_batch(np.array([input]))

-- Example 15599
Could not reload streamlit files.
Error: 092806 (P0002): The specified Streamlit was not found.

-- Example 15600
# This will not work
import streamlit.components.v1 as components
components.html("""
<script src="http://www.example.com/example.js"></script>
""", height=0)

-- Example 15601
MessageSizeError: Data Size exceeds message limit

-- Example 15602
https://app.snowflake.com/org/account_name/#/streamlit-apps/DB.SCHEMA.APP_NAME?streamlit-first_key=one&streamlit-second_key=two

-- Example 15603
{
   "first_key" : "one",
   "second_key" : "two"
}

-- Example 15604
└── streamlit/
    └── environment.yml
    └── streamlit_main.py
    └── pages/
         └── data_frame_demo.py
         └── plot_demo.py

-- Example 15605
PUT file:///<path_to_your_root_folder>/streamlit/streamlit_main.py @streamlit_db.streamlit_schema.streamlit_stage overwrite=true auto_compress=false;
PUT file:///<path_to_your_root_folder>/streamlit/environment.yml @streamlit_db.streamlit_schema.streamlit_stage overwrite=true auto_compress=false;
PUT file:///<path_to_your_root_folder>/streamlit/pages/streamlit_page_2.py @streamlit_db.streamlit_schema.streamlit_stage/pages/ overwrite=true auto_compress=false;
PUT file:///<path_to_your_root_folder>/streamlit/pages/streamlit_page_3.py @streamlit_db.streamlit_schema.streamlit_stage/pages/ overwrite=true auto_compress=false;

-- Example 15606
CREATE STREAMLIT hello_streamlit
ROOT_LOCATION = '@streamlit_db.streamlit_schema.streamlit_stage'
MAIN_FILE = 'streamlit_main.py'
QUERY_WAREHOUSE = my_warehouse;

-- Example 15607
SHOW STREAMLITS;

-- Example 15608
name: sf_env
channels:
- snowflake
dependencies:
- scikit-learn

-- Example 15609
name: sf_env
channels:
- snowflake
dependencies:
- scikit-learn
- streamlit=1.31.1

-- Example 15610
DESC STREAMLIT hello_streamlit;

-- Example 15611
ALTER STREAMLIT hello_streamlit RENAME TO hello_snowflake;

-- Example 15612
ALTER STREAMLIT hello_streamlit SET ROOT_LOCATION = '@snowflake_db.snowflake_schema.snowflake_stage'

-- Example 15613
ALTER STREAMLIT hello_streamlit SET MAIN_FILE = 'snowflake_main.py'

-- Example 15614
ALTER STREAMLIT hello_streamlit SET QUERY_WAREHOUSE = my_new_warehouse;

-- Example 15615
SHOW STREAMLITS;

-- Example 15616
DROP STREAMLIT hello_streamlit;

-- Example 15617
CREATE [ OR REPLACE ] STREAMLIT [ IF NOT EXISTS ] <name>
  FROM <source_location>
  MAIN_FILE = '<path_to_main_file_in_root_directory>'
  QUERY_WAREHOUSE = <warehouse_name>
  [ COMMENT = '<string_literal>' ]
  [ TITLE = '<app_title>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <integration_name> [ , ... ] ) ]
  [ ROOT_LOCATION = '<stage_path_and_root_directory>' ]

-- Example 15618
ROOT_LOCATION = '@streamlit_db.streamlit_schema.streamlit_stage'

-- Example 15619
CREATE STREAMLIT hello_streamlit
  FROM @streamlit_db.streamlit_schema.streamlit_stage
  MAIN_FILE = 'streamlit_main.py'
  QUERY_WAREHOUSE = my_warehouse;

-- Example 15620
CREATE STREAMLIT hello_streamlit
  FROM @streamlit_db.streamlit_schema.streamlit_repo/branches/streamlit_branch/
  MAIN_FILE = 'streamlit_main.py'
  QUERY_WAREHOUSE = my_warehouse;

-- Example 15621
var my_sql_command1 = "delete from history_table where event_year < 2016";
var statement1 = snowflake.createStatement(my_sql_command1);
statement1.execute();

var my_sql_command2 = "delete from log_table where event_year < 2016";
var statement2 = snowflake.createStatement(my_sql_command2);
statement2.execute();

-- Example 15622
var statement1 = ...;

-- Example 15623
CREATE OR REPLACE PROCEDURE read_result_set()
  RETURNS FLOAT NOT NULL
  LANGUAGE JAVASCRIPT
  AS     
  $$  
    var my_sql_command = "select * from table1";
    var statement1 = snowflake.createStatement( {sqlText: my_sql_command} );
    var result_set1 = statement1.execute();
    // Loop through the results, processing one row at a time... 
    while (result_set1.next())  {
       var column1 = result_set1.getColumnValue(1);
       var column2 = result_set1.getColumnValue(2);
       // Do something with the retrieved values...
       }
  return 0.0; // Replace with something more useful.
  $$
  ;

-- Example 15624
var sql_command = "SELECT * \
                       FROM table1;";

-- Example 15625
var sql_command = `SELECT *
                       FROM table1;`;

-- Example 15626
var sql_command = "SELECT col1, col2"
sql_command += "     FROM table1"
sql_command += "     WHERE col1 >= 100"
sql_command += "     ORDER BY col2;"

-- Example 15627
CREATE OR REPLACE FUNCTION num_test(a double)
  RETURNS string
  LANGUAGE JAVASCRIPT
AS
$$
  return A;
$$
;

-- Example 15628
select hash(1) AS a, 
       num_test(hash(1)) AS b, 
       a - b;
+----------------------+----------------------+------------+
|                    A | B                    |      A - B |
|----------------------+----------------------+------------|
| -4730168494964875235 | -4730168494964875000 | -235.00000 |
+----------------------+----------------------+------------+

-- Example 15629
getColumnValueAsString()

-- Example 15630
CREATE PROCEDURE f(argument1 VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
var local_variable1 = argument1;  // Incorrect
var local_variable2 = ARGUMENT1;  // Correct
$$;

-- Example 15631
var stmt = snowflake.createStatement(
  {
  sqlText: "INSERT INTO table2 (col1, col2) VALUES (?, ?);",
  binds:["LiteralValue1", variable2]
  }
);

-- Example 15632
CREATE OR REPLACE PROCEDURE right_bind(TIMESTAMP_VALUE VARCHAR)
RETURNS BOOLEAN
LANGUAGE JAVASCRIPT
AS
$$
var cmd = "SELECT CURRENT_DATE() > TO_TIMESTAMP(:1, 'YYYY-MM-DD HH24:MI:SS')";
var stmt = snowflake.createStatement(
          {
          sqlText: cmd,
          binds: [TIMESTAMP_VALUE]
          }
          );
var result1 = stmt.execute();
result1.next();
return result1.getColumnValue(1);
$$
;

-- Example 15633
CALL right_bind('2019-09-16 01:02:03');
+------------+
| RIGHT_BIND |
|------------|
| True       |
+------------+

-- Example 15634
CREATE TABLE table1 (v VARCHAR,
                     ts1 TIMESTAMP_LTZ(9), 
                     int1 INTEGER,
                     float1 FLOAT,
                     numeric1 NUMERIC(10,9),
                     ts_ntz1 TIMESTAMP_NTZ,
                     date1 DATE,
                     time1 TIME
                     );

-- Example 15635
CREATE OR REPLACE PROCEDURE string_to_timestamp_ltz(TSV VARCHAR) 
RETURNS TIMESTAMP_LTZ 
LANGUAGE JAVASCRIPT 
AS 
$$ 
    // Convert the input varchar to a TIMESTAMP_LTZ.
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_LTZ;"; 
    var stmt = snowflake.createStatement( {sqlText: sql_command} ); 
    var resultSet = stmt.execute(); 
    resultSet.next(); 
    // Retrieve the TIMESTAMP_LTZ and store it in an SfDate variable.
    var my_sfDate = resultSet.getColumnValue(1); 

    f = 3.1415926;

    // Specify that we'd like position-based binding.
    sql_command = `INSERT INTO table1 VALUES(:1, :2, :3, :4, :5, :6, :7, :8);` 
    // Bind a VARCHAR, a TIMESTAMP_LTZ, a numeric to our INSERT statement.
    result = snowflake.execute(
        { 
        sqlText: sql_command, 
        binds: [TSV, my_sfDate, f, f, f, my_sfDate, my_sfDate, '12:30:00.123' ] 
        }
        ); 

    return my_sfDate; 
$$ ;

-- Example 15636
CALL string_to_timestamp_ltz('2008-11-18 16:00:00');
+-------------------------------+
| STRING_TO_TIMESTAMP_LTZ       |
|-------------------------------|
| 2008-11-18 16:00:00.000 -0800 |
+-------------------------------+

-- Example 15637
SELECT * FROM table1;
+---------------------+-------------------------------+------+----------+-------------+-------------------------+------------+----------+
| V                   | TS1                           | INT1 |   FLOAT1 |    NUMERIC1 | TS_NTZ1                 | DATE1      | TIME1    |
|---------------------+-------------------------------+------+----------+-------------+-------------------------+------------+----------|
| 2008-11-18 16:00:00 | 2008-11-18 16:00:00.000 -0800 |    3 | 3.141593 | 3.141593000 | 2008-11-18 16:00:00.000 | 2008-11-18 | 12:30:00 |
+---------------------+-------------------------------+------+----------+-------------+-------------------------+------------+----------+

-- Example 15638
CREATE OR REPLACE PROCEDURE sp_pi()
    RETURNS FLOAT NOT NULL
    LANGUAGE JAVASCRIPT
    AS
    $$
    return 3.1415926;
    $$
    ;

-- Example 15639
CALL sp_pi();
+-----------+
|     SP_PI |
|-----------|
| 3.1415926 |
+-----------+

-- Example 15640
CREATE TABLE stproc_test_table1 (num_col1 numeric(14,7));

-- Example 15641
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

-- Example 15642
call stproc1(5.14::FLOAT);
+------------+
| STPROC1    |
|------------|
| Succeeded. |
+------------+

-- Example 15643
select * from stproc_test_table1;
+-----------+
|  NUM_COL1 |
|-----------|
| 5.1400000 |
+-----------+

-- Example 15644
CREATE OR REPLACE PROCEDURE get_row_count(table_name VARCHAR)
  RETURNS FLOAT NOT NULL
  LANGUAGE JAVASCRIPT
  AS
  $$
  var row_count = 0;
  // Dynamically compose the SQL statement to execute.
  var sql_command = "select count(*) from " + TABLE_NAME;
  // Run the statement.
  var stmt = snowflake.createStatement(
         {
         sqlText: sql_command
         }
      );
  var res = stmt.execute();
  // Get back the row count. Specifically, ...
  // ... get the first (and in this case only) row from the result set ...
  res.next();
  // ... and then get the returned value, which in this case is the number of
  // rows in the table.
  row_count = res.getColumnValue(1);
  return row_count;
  $$
  ;

-- Example 15645
call get_row_count('stproc_test_table1');
+---------------+
| GET_ROW_COUNT |
|---------------|
|             3 |
+---------------+

-- Example 15646
select count(*) from stproc_test_table1;
+----------+
| COUNT(*) |
|----------|
|        3 |
+----------+

-- Example 15647
create or replace table stproc_test_table2 (col1 FLOAT);

-- Example 15648
create or replace procedure recursive_stproc(counter FLOAT)
    returns varchar not null
    language javascript
    as
    -- "$$" is the delimiter that shows the beginning and end of the stored proc.
    $$
    var counter1 = COUNTER;
    var returned_value = "";
    var accumulator = "";
    var stmt = snowflake.createStatement(
        {
        sqlText: "INSERT INTO stproc_test_table2 (col1) VALUES (?);",
        binds:[counter1]
        }
        );
    var res = stmt.execute();
    if (COUNTER > 0)
        {
        stmt = snowflake.createStatement(
            {
            sqlText: "call recursive_stproc (?);",
            binds:[counter1 - 1]
            }
            );
        res = stmt.execute();
        res.next();
        returned_value = res.getColumnValue(1);
        }
    accumulator = accumulator + counter1 + ":" + returned_value;
    return accumulator;
    $$
    ;

-- Example 15649
call recursive_stproc(4.0::FLOAT);
+------------------+
| RECURSIVE_STPROC |
|------------------|
| 4:3:2:1:0:       |
+------------------+

-- Example 15650
SELECT * 
    FROM stproc_test_table2
    ORDER BY col1;
+------+
| COL1 |
|------|
|    0 |
|    1 |
|    2 |
|    3 |
|    4 |
+------+

-- Example 15651
create or replace procedure get_row_count(table_name VARCHAR)
    returns float 
    not null
    language javascript
    as
    $$
    var row_count = 0;
    // Dynamically compose the SQL statement to execute.
    // Note that we uppercased the input parameter name.
    var sql_command = "select count(*) from " + TABLE_NAME;
    // Run the statement.
    var stmt = snowflake.createStatement(
           {
           sqlText: sql_command
           }
        );
    var res = stmt.execute();
    // Get back the row count. Specifically, ...
    // ... first, get the first (and in this case only) row from the
    //  result set ...
    res.next();
    // ... then extract the returned value (which in this case is the
    // number of rows in the table).
    row_count = res.getColumnValue(1);
    return row_count;
    $$
    ;

-- Example 15652
call get_row_count('stproc_test_table1');
+---------------+
| GET_ROW_COUNT |
|---------------|
|             3 |
+---------------+

-- Example 15653
SELECT COUNT(*) FROM stproc_test_table1;
+----------+
| COUNT(*) |
|----------|
|        3 |
+----------+

-- Example 15654
create or replace table stproc_test_table3 (
    n10 numeric(10,0),     /* precision = 10, scale = 0 */
    n12 numeric(12,4),     /* precision = 12, scale = 4 */
    v1 varchar(19)         /* scale = 0 */
    );

-- Example 15655
create or replace procedure get_column_scale(column_index float)
    returns float not null
    language javascript
    as
    $$
    var stmt = snowflake.createStatement(
        {sqlText: "select n10, n12, v1 from stproc_test_table3;"}
        );
    stmt.execute();  // ignore the result set; we just want the scale.
    return stmt.getColumnScale(COLUMN_INDEX); // Get by column index (1-based)
    $$
    ;

-- Example 15656
call get_column_scale(1);
+------------------+
| GET_COLUMN_SCALE |
|------------------|
|                0 |
+------------------+

-- Example 15657
call get_column_scale(2);
+------------------+
| GET_COLUMN_SCALE |
|------------------|
|                4 |
+------------------+

