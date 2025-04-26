-- Example 2993
var queryText = statement.getSqlText();

-- Example 2994
var valueArray = [];
// For each row...
while (myResultSet.next())  {
    // Append each column of the current row...
    valueArray.push(myResultSet.getColumnValue('MY_COLUMN_NAME1'));
    valueArray.push(myResultSet.getColumnValue('MY_COLUMN_NAME2'));
    ...
    // Do something with the row of data that we retrieved.
    f(valueArray);
    // Reset the array before getting the next row.
    valueArray = [];
    }

-- Example 2995
var valueArray = [];
// For each row...
while (myResultSet.next())  {
    // Append each column of the current row...
    valueArray.push(myResultSet.MY_COLUMN_NAME1);
    valueArray.push(myResultSet.MY_COLUMN_NAME2);
    ...
    // Do something with the row of data that we retrieved.
    f(valueArray);
    // Reset the array before getting the next row.
    valueArray = [];
    }

-- Example 2996
var queryId = resultSet.getQueryId();

-- Example 2997
CREATE OR REPLACE PROCEDURE test_get_epoch_seconds(TSV VARCHAR)
    RETURNS FLOAT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_NTZ;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.getEpochSeconds();
    $$
    ;

-- Example 2998
CALL test_get_epoch_seconds('1970-01-01 00:00:00.000000000');
+------------------------+
| TEST_GET_EPOCH_SECONDS |
|------------------------|
|                      0 |
+------------------------+

-- Example 2999
CALL test_get_epoch_seconds('1970-01-01 00:00:01.987654321');
+------------------------+
| TEST_GET_EPOCH_SECONDS |
|------------------------|
|                      1 |
+------------------------+

-- Example 3000
CALL test_get_epoch_seconds('1971-01-01 00:00:00');
+------------------------+
| TEST_GET_EPOCH_SECONDS |
|------------------------|
|               31536000 |
+------------------------+

-- Example 3001
CREATE OR REPLACE PROCEDURE test_get_nano_seconds2(TSV VARCHAR)
    RETURNS FLOAT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_NTZ;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.getNanoSeconds();
    $$
    ;
-- Should be 0 nanoseconds.
-- (> SNIPPET_TAG=query_03_01
CALL test_get_nano_seconds2('1970-01-01 00:00:00.000000000');

-- Example 3002
CALL test_get_nano_seconds2('1970-01-01 00:00:00.000000000');
+------------------------+
| TEST_GET_NANO_SECONDS2 |
|------------------------|
|                      0 |
+------------------------+

-- Example 3003
CALL test_get_nano_seconds2('1970-01-01 00:00:01.987654321');
+------------------------+
| TEST_GET_NANO_SECONDS2 |
|------------------------|
|              987654321 |
+------------------------+

-- Example 3004
CALL test_get_nano_seconds2('1971-01-01 00:00:00.000123456');
+------------------------+
| TEST_GET_NANO_SECONDS2 |
|------------------------|
|                 123456 |
+------------------------+

-- Example 3005
CREATE OR REPLACE PROCEDURE test_get_scale(TSV VARCHAR, SCALE VARCHAR)
    RETURNS FLOAT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_NTZ(" + SCALE + ");";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.getScale();
    $$
    ;

-- Should be 0.
-- (> SNIPPET_TAG=query_04_01
CALL test_get_scale('1970-01-01 00:00:00', '0');

-- Example 3006
CALL test_get_scale('1970-01-01 00:00:00', '0');
+----------------+
| TEST_GET_SCALE |
|----------------|
|              0 |
+----------------+

-- Example 3007
CALL test_get_scale('1970-01-01 00:00:01.123', '2');
+----------------+
| TEST_GET_SCALE |
|----------------|
|              2 |
+----------------+

-- Example 3008
CALL test_get_scale('1971-01-01 00:00:00.000123456', '9');
+----------------+
| TEST_GET_SCALE |
|----------------|
|              9 |
+----------------+

-- Example 3009
CREATE OR REPLACE PROCEDURE test_get_Timezone(TSV VARCHAR)
    RETURNS FLOAT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_TZ;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.getTimezone();
    $$
    ;

-- Example 3010
CALL test_get_timezone('1970-01-01 00:00:01-08:00');
+-------------------+
| TEST_GET_TIMEZONE |
|-------------------|
|              -480 |
+-------------------+

-- Example 3011
CALL test_get_timezone('1971-01-01 00:00:00.000123456+11:00');
+-------------------+
| TEST_GET_TIMEZONE |
|-------------------|
|               660 |
+-------------------+

-- Example 3012
CREATE OR REPLACE PROCEDURE test_toString(TSV VARCHAR)
    RETURNS VARIANT
    LANGUAGE JAVASCRIPT
    AS
    $$
    var sql_command = "SELECT '" + TSV + "'::TIMESTAMP_TZ;";
    var stmt = snowflake.createStatement( {sqlText: sql_command} );
    var resultSet = stmt.execute();
    resultSet.next();
    var my_sfDate = resultSet.getColumnValue(1);
    return my_sfDate.toString();
    $$
    ;

-- Example 3013
CALL test_toString('1970-01-02 03:04:05');
+------------------------------------------------------------------+
| TEST_TOSTRING                                                    |
|------------------------------------------------------------------|
| "Fri Jan 02 1970 03:04:05 GMT+0000 (Coordinated Universal Time)" |
+------------------------------------------------------------------+

-- Example 3014
DECLARE
  -- (variable declarations, cursor declarations, etc.) ...
BEGIN
  -- (Snowflake Scripting and SQL statements) ...
EXCEPTION
  -- (statements for handling exceptions) ...
END;

-- Example 3015
BEGIN
  CREATE TABLE employee (id INTEGER, ...);
  CREATE TABLE dependents (id INTEGER, ...);
END;

-- Example 3016
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := pi() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;

-- Example 3017
CREATE OR REPLACE PROCEDURE area()
RETURNS FLOAT
LANGUAGE SQL
AS
DECLARE
  radius FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius := 3;
  area_of_circle := PI() * radius * radius;
  RETURN area_of_circle;
END;

-- Example 3018
CREATE OR REPLACE PROCEDURE area()
RETURNS FLOAT
LANGUAGE SQL
AS
$$
DECLARE
  radius FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius := 3;
  area_of_circle := PI() * radius * radius;
  RETURN area_of_circle;
END;
$$
;

-- Example 3019
CALL area();

-- Example 3020
+--------------+
|         AREA |
|--------------|
| 28.274333882 |
+--------------+

-- Example 3021
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := PI() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;

-- Example 3022
EXECUTE IMMEDIATE $$
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := PI() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;
$$
;

-- Example 3023
+-----------------+
| anonymous block |
|-----------------|
|    28.274333882 |
+-----------------+

-- Example 3024
BEGIN
  CREATE TABLE parent (ID INTEGER);
  CREATE TABLE child (ID INTEGER, parent_ID INTEGER);
  RETURN 'Completed';
END;

-- Example 3025
EXECUTE IMMEDIATE $$
BEGIN
    CREATE TABLE parent (ID INTEGER);
    CREATE TABLE child (ID INTEGER, parent_ID INTEGER);
    RETURN 'Completed';
END;
$$
;

-- Example 3026
+-----------------+
| anonymous block |
|-----------------|
| Completed       |
+-----------------+

-- Example 3027
<variable_name> <type> ;

<variable_name> DEFAULT <expression> ;

<variable_name> <type> DEFAULT <expression> ;

-- Example 3028
LET <variable_name> <type> { DEFAULT | := } <expression> ;

LET <variable_name> { DEFAULT | := } <expression> ;

-- Example 3029
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;

-- Example 3030
EXECUTE IMMEDIATE 
$$
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;
$$
;

-- Example 3031
+-----------------+
| anonymous block |
|-----------------|
|           10.00 |
+-----------------+

-- Example 3032
...
FOR current_row IN cursor_1 DO:
  LET price := current_row.price_column;
  ...

-- Example 3033
092228 (P0000): SQL compilation error:
  error line 7 at position 4 variable 'PRICE' cannot have its type inferred from initializer

-- Example 3034
<variable_name> := <expression> ;

-- Example 3035
DECLARE
  profit NUMBER(38, 2);
  revenue NUMBER(38, 2);
  cost NUMBER(38, 2);
BEGIN
  ...
  profit := revenue - cost;
  ...
RETURN profit;

-- Example 3036
INSERT INTO my_table (x) VALUES (:my_variable)

-- Example 3037
SELECT COUNT(*) FROM IDENTIFIER(:table_name)

-- Example 3038
RETURN profit;

-- Example 3039
LET select_statement := 'SELECT * FROM invoices WHERE id = ' || id_variable;

-- Example 3040
SELECT <expression1>, <expression2>, ... INTO :<variable1>, :<variable2>, ... FROM ... WHERE ...;

-- Example 3041
CREATE OR REPLACE TABLE some_data (id INTEGER, name VARCHAR);
INSERT INTO some_data (id, name) VALUES
  (1, 'a'),
  (2, 'b');

-- Example 3042
DECLARE
  id INTEGER;
  name VARCHAR;
BEGIN
  SELECT id, name INTO :id, :name FROM some_data WHERE id = 1;
  RETURN id || ' ' || name;
END;

-- Example 3043
EXECUTE IMMEDIATE $$
DECLARE
  id INTEGER;
  name VARCHAR;
BEGIN
  SELECT id, name INTO :id, :name FROM some_data WHERE id = 1;
  RETURN :id || ' ' || :name;
END;
$$
;

-- Example 3044
+-----------------+
| anonymous block |
|-----------------|
| 1 a             |
+-----------------+

-- Example 3045
DECLARE
  w INTEGER;
  x INTEGER DEFAULT 0;
  dt DATE;
  result_string VARCHAR;
BEGIN
  w := 1;                     -- Assign a value.
  w := 24 * 7;                -- Assign the result of an expression.
  dt := '2020-09-30'::DATE;   -- Explicit cast.
  dt := '2020-09-30';         -- Implicit cast.
  result_string := w::VARCHAR || ', ' || dt::VARCHAR;
  RETURN result_string;
END;

-- Example 3046
EXECUTE IMMEDIATE $$
DECLARE
    w INTEGER;
    x INTEGER DEFAULT 0;
    dt DATE;
    result_string VARCHAR;
BEGIN
    w := 1;                     -- Assign a value.
    w := 24 * 7;                -- Assign the result of an expression.
    dt := '2020-09-30'::DATE;   -- Explicit cast.
    dt := '2020-09-30';         -- Implicit cast.
    result_string := w::VARCHAR || ', ' || dt::VARCHAR;
    RETURN result_string;
END;
$$
;

-- Example 3047
+-----------------+
| anonymous block |
|-----------------|
| 168, 2020-09-30 |
+-----------------+

-- Example 3048
my_variable := SQRT(variable_x);

-- Example 3049
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;

-- Example 3050
EXECUTE IMMEDIATE $$
DECLARE
    profit DEFAULT 0.0;
BEGIN
    LET cost := 100.0;
    LET revenue DEFAULT 110.0;
    profit := revenue - cost;
    RETURN profit;
END;
$$
;

-- Example 3051
+-----------------+
| anonymous block |
|-----------------|
|              10 |
+-----------------+

-- Example 3052
CREATE OR REPLACE TABLE names (v VARCHAR);

-- Example 3053
CREATE OR REPLACE PROCEDURE duplicate_name(pv_name VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
  DECLARE
    PV_NAME VARCHAR;
  BEGIN
    PV_NAME := 'middle block variable';
    DECLARE
      PV_NAME VARCHAR;
    BEGIN
      PV_NAME := 'innermost block variable';
      INSERT INTO names (v) VALUES (:PV_NAME);
    END;
    -- Because the innermost and middle blocks have separate variables
    -- named "pv_name", the INSERT below inserts the value
    -- 'middle block variable'.
    INSERT INTO names (v) VALUES (:PV_NAME);
  END;
  -- This inserts the value of the input parameter.
  INSERT INTO names (v) VALUES (:PV_NAME);
  RETURN 'Completed.';
END;

-- Example 3054
CREATE OR REPLACE PROCEDURE duplicate_name(pv_name VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  DECLARE
    PV_NAME VARCHAR;
  BEGIN
    PV_NAME := 'middle block variable';
    DECLARE
    PV_NAME VARCHAR;
    BEGIN
      PV_NAME := 'innermost block variable';
      INSERT INTO names (v) VALUES (:PV_NAME);
    END;
    -- Because the innermost and middle blocks have separate variables
    -- named "pv_name", the INSERT below inserts the value
    -- 'middle block variable'.
    INSERT INTO names (v) VALUES (:PV_NAME);
  END;
  -- This inserts the value of the input parameter.
  INSERT INTO names (v) VALUES (:PV_NAME);
  RETURN 'Completed.';
END;
$$
;

-- Example 3055
CALL duplicate_name('parameter');

-- Example 3056
SELECT *
    FROM names
    ORDER BY v;

-- Example 3057
+--------------------------+
| V                        |
|--------------------------|
| innermost block variable |
| middle block variable    |
| parameter                |
+--------------------------+

-- Example 3058
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 3059
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 3060
Stored procedure execution error: data type of returned table does not match expected returned table type

