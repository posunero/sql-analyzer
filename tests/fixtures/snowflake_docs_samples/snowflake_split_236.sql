-- Example 15792
+------------------------+
| SP_CONCATENATE_STRINGS |
|------------------------|
| onetwothree            |
+------------------------+

-- Example 15793
CALL sp_concatenate_strings(
  'one',
  'two',
  'three');

-- Example 15794
+------------------------+
| SP_CONCATENATE_STRINGS |
|------------------------|
| onetwothree            |
+------------------------+

-- Example 15795
CREATE OR REPLACE PROCEDURE build_string_proc(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
    BEGIN
      RETURN prefix || word || suffix;
    END;
  $$
  ;

-- Example 15796
CALL build_string_proc('hello');

-- Example 15797
+-------------------+
| BUILD_STRING_PROC |
|-------------------|
| pre-hello-post    |
+-------------------+

-- Example 15798
CALL build_string_proc('hello', 'before-');

-- Example 15799
+-------------------+
| BUILD_STRING_PROC |
|-------------------|
| before-hello-post |
+-------------------+

-- Example 15800
CALL build_string_proc(word => 'hello', suffix => '-after');

-- Example 15801
+-------------------+
| BUILD_STRING_PROC |
|-------------------|
| pre-hello-after   |
+-------------------+

-- Example 15802
CREATE OR REPLACE FUNCTION udf_concatenate_strings(
    first_arg VARCHAR,
    second_arg VARCHAR,
    third_arg VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
    SELECT first_arg || second_arg || third_arg
  $$;

-- Example 15803
SELECT udf_concatenate_strings(
  first_arg => 'one',
  second_arg => 'two',
  third_arg => 'three');

-- Example 15804
+--------------------------+
| UDF_CONCATENATE_STRINGS( |
|   FIRST_ARG => 'ONE',    |
|   SECOND_ARG => 'TWO',   |
|   THIRD_ARG => 'THREE')  |
|--------------------------|
| onetwothree              |
+--------------------------+

-- Example 15805
SELECT udf_concatenate_strings(
  third_arg => 'three',
  first_arg => 'one',
  second_arg => 'two');

-- Example 15806
+--------------------------+
| UDF_CONCATENATE_STRINGS( |
|   THIRD_ARG => 'THREE',  |
|   FIRST_ARG => 'ONE',    |
|   SECOND_ARG => 'TWO')   |
|--------------------------|
| onetwothree              |
+--------------------------+

-- Example 15807
SELECT udf_concatenate_strings(
  'one',
  'two',
  'three');

-- Example 15808
+--------------------------+
| UDF_CONCATENATE_STRINGS( |
|   'ONE',                 |
|   'TWO',                 |
|   'THREE')               |
|--------------------------|
| onetwothree              |
+--------------------------+

-- Example 15809
CREATE OR REPLACE FUNCTION build_string_udf(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  RETURNS VARCHAR
  AS
  $$
    SELECT prefix || word || suffix
  $$
  ;

-- Example 15810
SELECT build_string_udf('hello');

-- Example 15811
+---------------------------+
| BUILD_STRING_UDF('HELLO') |
|---------------------------|
| pre-hello-post            |
+---------------------------+

-- Example 15812
SELECT build_string_udf('hello', 'before-');

-- Example 15813
+--------------------------------------+
| BUILD_STRING_UDF('HELLO', 'BEFORE-') |
|--------------------------------------|
| before-hello-post                    |
+--------------------------------------+

-- Example 15814
SELECT build_string_udf(word => 'hello', suffix => '-after');

-- Example 15815
+-------------------------------------------------------+
| BUILD_STRING_UDF(WORD => 'HELLO', SUFFIX => '-AFTER') |
|-------------------------------------------------------|
| pre-hello-after                                       |
+-------------------------------------------------------+

-- Example 15816
SELECT ...
  FROM TABLE ( udtf_name (udtf_arguments) )

-- Example 15817
SELECT ...
  FROM TABLE(my_java_udtf('2021-01-16'::DATE));

-- Example 15818
create table file_names (file_name varchar);
insert into file_names (file_name) values ('sample.txt'),
                                          ('sample_2.txt');

select f.file_name, w.word
   from file_names as f, table(split_file_into_words(f.file_name)) as w;

-- Example 15819
+-------------------+------------+
| FILE_NAME         | WORD       |
+-------------------+------------+
| sample_data.txt   | some       |
| sample_data.txt   | words      |
| sample_data_2.txt | additional |
| sample_data_2.txt | words      |
+-------------------+------------+

-- Example 15820
create function split_file_into_words(inputFileName string)
    ...
    imports = ('@inline_jars/sample.txt', '@inline_jars/sample_2.txt')
    ...

-- Example 15821
SELECT *
    FROM stocks_table AS st,
         TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY st.symbol))

-- Example 15822
SELECT *
    FROM stocks_table AS st,
         TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY 1))

-- Example 15823
SELECT *
     FROM stocks_table AS st,
          TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY st.symbol ORDER BY st.transaction_date))

-- Example 15824
SELECT *
    FROM stocks_table AS st,
         TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY st.symbol ORDER BY st.transaction_date))
    ORDER BY st.symbol, st.transaction_date, st.transaction_time;

-- Example 15825
SELECT * FROM udtf_table, TABLE(my_func(col1) OVER (PARTITION BY udtf_table.col2 * 2));   -- NO!

-- Example 15826
var my_sql_command1 = "delete from history_table where event_year < 2016";
var statement1 = snowflake.createStatement(my_sql_command1);
statement1.execute();

var my_sql_command2 = "delete from log_table where event_year < 2016";
var statement2 = snowflake.createStatement(my_sql_command2);
statement2.execute();

-- Example 15827
var statement1 = ...;

-- Example 15828
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

-- Example 15829
var sql_command = "SELECT * \
                       FROM table1;";

-- Example 15830
var sql_command = `SELECT *
                       FROM table1;`;

-- Example 15831
var sql_command = "SELECT col1, col2"
sql_command += "     FROM table1"
sql_command += "     WHERE col1 >= 100"
sql_command += "     ORDER BY col2;"

-- Example 15832
CREATE OR REPLACE FUNCTION num_test(a double)
  RETURNS string
  LANGUAGE JAVASCRIPT
AS
$$
  return A;
$$
;

-- Example 15833
select hash(1) AS a, 
       num_test(hash(1)) AS b, 
       a - b;
+----------------------+----------------------+------------+
|                    A | B                    |      A - B |
|----------------------+----------------------+------------|
| -4730168494964875235 | -4730168494964875000 | -235.00000 |
+----------------------+----------------------+------------+

-- Example 15834
getColumnValueAsString()

-- Example 15835
CREATE PROCEDURE f(argument1 VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
var local_variable1 = argument1;  // Incorrect
var local_variable2 = ARGUMENT1;  // Correct
$$;

-- Example 15836
var stmt = snowflake.createStatement(
  {
  sqlText: "INSERT INTO table2 (col1, col2) VALUES (?, ?);",
  binds:["LiteralValue1", variable2]
  }
);

-- Example 15837
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

-- Example 15838
CALL right_bind('2019-09-16 01:02:03');
+------------+
| RIGHT_BIND |
|------------|
| True       |
+------------+

-- Example 15839
CREATE TABLE table1 (v VARCHAR,
                     ts1 TIMESTAMP_LTZ(9), 
                     int1 INTEGER,
                     float1 FLOAT,
                     numeric1 NUMERIC(10,9),
                     ts_ntz1 TIMESTAMP_NTZ,
                     date1 DATE,
                     time1 TIME
                     );

-- Example 15840
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

-- Example 15841
CALL string_to_timestamp_ltz('2008-11-18 16:00:00');
+-------------------------------+
| STRING_TO_TIMESTAMP_LTZ       |
|-------------------------------|
| 2008-11-18 16:00:00.000 -0800 |
+-------------------------------+

-- Example 15842
SELECT * FROM table1;
+---------------------+-------------------------------+------+----------+-------------+-------------------------+------------+----------+
| V                   | TS1                           | INT1 |   FLOAT1 |    NUMERIC1 | TS_NTZ1                 | DATE1      | TIME1    |
|---------------------+-------------------------------+------+----------+-------------+-------------------------+------------+----------|
| 2008-11-18 16:00:00 | 2008-11-18 16:00:00.000 -0800 |    3 | 3.141593 | 3.141593000 | 2008-11-18 16:00:00.000 | 2008-11-18 | 12:30:00 |
+---------------------+-------------------------------+------+----------+-------------+-------------------------+------------+----------+

-- Example 15843
CREATE OR REPLACE PROCEDURE sp_pi()
    RETURNS FLOAT NOT NULL
    LANGUAGE JAVASCRIPT
    AS
    $$
    return 3.1415926;
    $$
    ;

-- Example 15844
CALL sp_pi();
+-----------+
|     SP_PI |
|-----------|
| 3.1415926 |
+-----------+

-- Example 15845
CREATE TABLE stproc_test_table1 (num_col1 numeric(14,7));

-- Example 15846
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

-- Example 15847
call stproc1(5.14::FLOAT);
+------------+
| STPROC1    |
|------------|
| Succeeded. |
+------------+

-- Example 15848
select * from stproc_test_table1;
+-----------+
|  NUM_COL1 |
|-----------|
| 5.1400000 |
+-----------+

-- Example 15849
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

-- Example 15850
call get_row_count('stproc_test_table1');
+---------------+
| GET_ROW_COUNT |
|---------------|
|             3 |
+---------------+

-- Example 15851
select count(*) from stproc_test_table1;
+----------+
| COUNT(*) |
|----------|
|        3 |
+----------+

-- Example 15852
create or replace table stproc_test_table2 (col1 FLOAT);

-- Example 15853
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

-- Example 15854
call recursive_stproc(4.0::FLOAT);
+------------------+
| RECURSIVE_STPROC |
|------------------|
| 4:3:2:1:0:       |
+------------------+

-- Example 15855
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

-- Example 15856
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

-- Example 15857
call get_row_count('stproc_test_table1');
+---------------+
| GET_ROW_COUNT |
|---------------|
|             3 |
+---------------+

-- Example 15858
SELECT COUNT(*) FROM stproc_test_table1;
+----------+
| COUNT(*) |
|----------|
|        3 |
+----------+

