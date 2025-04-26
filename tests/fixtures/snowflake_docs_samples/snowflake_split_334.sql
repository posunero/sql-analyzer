-- Example 22356
>>> db = session.get_current_database().replace('"', "")
>>> schema = session.get_current_schema().replace('"', "")
>>> _ = session.sql(f"CREATE OR REPLACE TABLE {db}.{schema}.T1(C1 INT)").collect()
>>> _ = session.sql(
...     f"CREATE OR REPLACE VIEW {db}.{schema}.V1 AS SELECT * FROM {db}.{schema}.T1"
... ).collect()
>>> _ = session.sql(
...     f"CREATE OR REPLACE VIEW {db}.{schema}.V2 AS SELECT * FROM {db}.{schema}.V1"
... ).collect()
>>> df = session.lineage.trace(
...     f"{db}.{schema}.T1",
...     "table",
...     direction="downstream"
... )
>>> df.show() 
-------------------------------------------------------------------------------------------------------------------------------------------------
| "SOURCE_OBJECT"                                         | "TARGET_OBJECT"                                        | "DIRECTION"   | "DISTANCE" |
-------------------------------------------------------------------------------------------------------------------------------------------------
| {"createdOn": "2023-11-15T12:30:23Z", "domain": "TABLE",| {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW",| "Downstream"  | 1          |
|  "name": "YOUR_DATABASE.YOUR_SCHEMA.T1", "status":      |  "name": "YOUR_DATABASE.YOUR_SCHEMA.V1", "status":     |               |            |
|  "ACTIVE"}                                              |  "ACTIVE"}                                             |               |            |
| {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW", | {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW",| "Downstream"  | 2          |
|  "name": "YOUR_DATABASE.YOUR_SCHEMA.V1", "status":      |  "name": "YOUR_DATABASE.YOUR_SCHEMA.V2", "status":     |               |            |
|  "ACTIVE"}                                              |  "ACTIVE"}                                             |               |            |
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 22357
>>> from snowflake.snowpark.testing import assert_dataframe_equal
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, DoubleType
>>> schema1 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", DoubleType())
... ])
>>> data1 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0]]
>>> df1 = session.create_dataframe(data1, schema1)
>>> df2 = session.create_dataframe(data1, schema1)
>>> assert_dataframe_equal(df2, df1)  # pass, DataFrames are identical

>>> data2 = [[2, "Saka", 2.0], [1, "Rice", 1.0], [3, "White", 3.0]]  # change the order
>>> df3 = session.create_dataframe(data2, schema1)
>>> assert_dataframe_equal(df3, df1)  # pass, DataFrames are identical

>>> data3 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [4, "Rowe", 4.0]]
>>> df4 = session.create_dataframe(data3, schema1)
>>> assert_dataframe_equal(df4, df1)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 0: actual 4, expected 3
Different row:
--- actual ---
+++ expected +++
- Row(ID=4, NAME='Rowe', VALUE=4.0)
?        ^        ^^^          ^

+ Row(ID=3, NAME='White', VALUE=3.0)
?        ^        ^^^^          ^

>>> data4 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0001]]
>>> df5 = session.create_dataframe(data4, schema1)
>>> assert_dataframe_equal(df5, df1, atol=1e-3)  # pass, DataFrames are identical due to higher error tolerance
>>> assert_dataframe_equal(df5, df1, atol=1e-5)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 2: actual 3.0001, expected 3.0
Different row:
--- actual ---
+++ expected +++
- Row(ID=3, NAME='White', VALUE=3.0001)
?                                  ---

+ Row(ID=3, NAME='White', VALUE=3.0)

>>> schema2 = StructType([
...     StructField("id", IntegerType()),
...     StructField("key", StringType()),
...     StructField("value", DoubleType())
... ])
>>> df6 = session.create_dataframe(data1, schema2)
>>> assert_dataframe_equal(df6, df1)  
Traceback (most recent call last):
AssertionError: Column name mismatch at column 1: actual KEY, expected NAME
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('KEY', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?                                                                        ^ -

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

>>> schema3 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", IntegerType())
... ])
>>> df7 = session.create_dataframe(data1, schema3)
>>> assert_dataframe_equal(df7, df1)  
Traceback (most recent call last):
AssertionError: Column data type mismatch at column 2: actual LongType(), expected DoubleType()
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', LongType(), nullable=True)])
?                                                                                                                                  ^ ^^

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

-- Example 22358
>>> from snowflake.snowpark.testing import assert_dataframe_equal
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, DoubleType
>>> schema1 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", DoubleType())
... ])
>>> data1 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0]]
>>> df1 = session.create_dataframe(data1, schema1)
>>> df2 = session.create_dataframe(data1, schema1)
>>> assert_dataframe_equal(df2, df1)  # pass, DataFrames are identical

>>> data2 = [[2, "Saka", 2.0], [1, "Rice", 1.0], [3, "White", 3.0]]  # change the order
>>> df3 = session.create_dataframe(data2, schema1)
>>> assert_dataframe_equal(df3, df1)  # pass, DataFrames are identical

>>> data3 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [4, "Rowe", 4.0]]
>>> df4 = session.create_dataframe(data3, schema1)
>>> assert_dataframe_equal(df4, df1)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 0: actual 4, expected 3
Different row:
--- actual ---
+++ expected +++
- Row(ID=4, NAME='Rowe', VALUE=4.0)
?        ^        ^^^          ^

+ Row(ID=3, NAME='White', VALUE=3.0)
?        ^        ^^^^          ^

>>> data4 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0001]]
>>> df5 = session.create_dataframe(data4, schema1)
>>> assert_dataframe_equal(df5, df1, atol=1e-3)  # pass, DataFrames are identical due to higher error tolerance
>>> assert_dataframe_equal(df5, df1, atol=1e-5)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 2: actual 3.0001, expected 3.0
Different row:
--- actual ---
+++ expected +++
- Row(ID=3, NAME='White', VALUE=3.0001)
?                                  ---

+ Row(ID=3, NAME='White', VALUE=3.0)

>>> schema2 = StructType([
...     StructField("id", IntegerType()),
...     StructField("key", StringType()),
...     StructField("value", DoubleType())
... ])
>>> df6 = session.create_dataframe(data1, schema2)
>>> assert_dataframe_equal(df6, df1)  
Traceback (most recent call last):
AssertionError: Column name mismatch at column 1: actual KEY, expected NAME
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('KEY', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?                                                                        ^ -

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

>>> schema3 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", IntegerType())
... ])
>>> df7 = session.create_dataframe(data1, schema3)
>>> assert_dataframe_equal(df7, df1)  
Traceback (most recent call last):
AssertionError: Column data type mismatch at column 2: actual LongType(), expected DoubleType()
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', LongType(), nullable=True)])
?                                                                                                                                  ^ ^^

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

-- Example 22359
UPDATE <target_table>
       SET <col_name> = <value> [ , <col_name> = <value> , ... ]
        [ FROM <additional_tables> ]
        [ WHERE <condition> ]

-- Example 22360
ALTER SESSION SET ERROR_ON_NONDETERMINISTIC_UPDATE=TRUE;

-- Example 22361
UPDATE t1
  SET number_column = t1.number_column + t2.number_column, t1.text_column = 'ASDF'
  FROM t2
  WHERE t1.key_column = t2.t1_key and t1.number_column < 10;

-- Example 22362
select * from target;

+---+----+
| K |  V |
|---+----|
| 0 | 10 |
+---+----+

Select * from src;

+---+----+
| K |  V |
|---+----|
| 0 | 11 |
| 0 | 12 |
| 0 | 13 |
+---+----+

-- Following statement joins all three rows in src against the single row in target
UPDATE target
  SET v = src.v
  FROM src
  WHERE target.k = src.k;

+------------------------+-------------------------------------+
| number of rows updated | number of multi-joined rows updated |
|------------------------+-------------------------------------|
|                      1 |                                   1 |
+------------------------+-------------------------------------+

-- Example 22363
UPDATE target SET v = b.v
  FROM (SELECT k, MIN(v) v FROM src GROUP BY k) b
  WHERE target.k = b.k;

-- Example 22364
OPEN <cursor_name> [ USING (bind_variable_1 [, bind_variable_2 ...] ) ] ;

-- Example 22365
DECLARE
    c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
    OPEN c1;
    ...

-- Example 22366
DECLARE
    price_to_search_for FLOAT;
    price_count INTEGER;
    c2 CURSOR FOR SELECT COUNT(*) FROM invoices WHERE price = ?;
BEGIN
    price_to_search_for := 11.11;
    OPEN c2 USING (price_to_search_for);

-- Example 22367
DECLARE
  { <variable_declaration> | <cursor_declaration> | <resultset_declaration> | <exception_declaration> };
  [{ <variable_declaration> | <cursor_declaration> | <resultset_declaration> | <exception_declaration> }; ... ]

-- Example 22368
<variable_declaration> ::=
  <variable_name> [<type>] [ { DEFAULT | := } <expression>]

-- Example 22369
profit NUMBER(38, 2) := 0;

-- Example 22370
<cursor_declaration> ::=
  <cursor_name> CURSOR FOR <query>

-- Example 22371
c1 CURSOR FOR SELECT id, price FROM invoices;

-- Example 22372
<resultset_name> RESULTSET [ { DEFAULT | := } [ ASYNC ] ( <query> ) ] ;

-- Example 22373
res RESULTSET DEFAULT (SELECT col1 FROM mytable ORDER BY col1);

-- Example 22374
<exception_name> EXCEPTION [ ( <exception_number> , '<exception_message>' ) ] ;

-- Example 22375
exception_could_not_create_table EXCEPTION (-20003, 'ERROR: Could not create table.');

-- Example 22376
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;

-- Example 22377
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

-- Example 22378
LET { <variable_assignment> | <cursor_assignment> | <resultset_assignment> }

-- Example 22379
LET <variable_name> <type> { DEFAULT | := } <expression> ;

LET <variable_name> { DEFAULT | := } <expression> ;

-- Example 22380
BEGIN
  ...
  LET profit NUMBER(38, 2) DEFAULT 0.0;
  LET revenue NUMBER(38, 2) DEFAULT 110.0;
  LET cost NUMBER(38, 2) := 100.0;
  ...

-- Example 22381
LET <cursor_name> CURSOR FOR <query> ;

-- Example 22382
LET <cursor_name> CURSOR FOR <resultset_name> ;

-- Example 22383
BEGIN
  ...
  LET c1 CURSOR FOR SELECT price FROM invoices;
  ...

-- Example 22384
<resultset_name> := ( <query> ) ;

-- Example 22385
BEGIN
  ...
  LET res RESULTSET := (SELECT price FROM invoices);
  ...

-- Example 22386
CREATE OR REPLACE TABLE bonuses (
  emp_id INT,
  performance_rating INT,
  salary NUMBER(12, 2),
  bonus NUMBER(12, 2)
);

INSERT INTO bonuses (emp_id, performance_rating, salary, bonus) VALUES
  (1001, 3, 100000, NULL),
  (1002, 1, 50000, NULL),
  (1003, 4, 75000, NULL),
  (1004, 4, 80000, NULL),
  (1005, 5, 120000, NULL),
  (1006, 2, 60000, NULL),
  (1007, 5, 40000, NULL),
  (1008, 3, 140000, NULL),
  (1009, 1, 95000, NULL);

SELECT * FROM bonuses;

-- Example 22387
+--------+--------------------+-----------+-------+
| EMP_ID | PERFORMANCE_RATING |    SALARY | BONUS |
|--------+--------------------+-----------+-------|
|   1001 |                  3 | 100000.00 |  NULL |
|   1002 |                  1 |  50000.00 |  NULL |
|   1003 |                  4 |  75000.00 |  NULL |
|   1004 |                  4 |  80000.00 |  NULL |
|   1005 |                  5 | 120000.00 |  NULL |
|   1006 |                  2 |  60000.00 |  NULL |
|   1007 |                  5 |  40000.00 |  NULL |
|   1008 |                  3 | 140000.00 |  NULL |
|   1009 |                  1 |  95000.00 |  NULL |
+--------+--------------------+-----------+-------+

-- Example 22388
CREATE OR REPLACE PROCEDURE apply_bonus(bonus_percentage INT, performance_value INT)
  RETURNS TEXT
  LANGUAGE SQL
AS
DECLARE
  -- Use input to calculate the bonus percentage
  updated_bonus_percentage NUMBER(2,2) DEFAULT (:bonus_percentage/100);
  --  Declare a result set
  rs RESULTSET;
BEGIN
  -- Assign a query to the result set and execute the query
  rs := (SELECT * FROM bonuses);
  -- Use a FOR loop to iterate over the records in the result set
  FOR record IN rs DO
    -- Assign variable values using values in the current record
    LET emp_id_value INT := record.emp_id;
    LET performance_rating_value INT := record.performance_rating;
    LET salary_value NUMBER(12, 2) := record.salary;
    -- Determine whether the performance rating in the record matches the user input
    IF (performance_rating_value = :performance_value) THEN
      -- If the condition is met, update the bonuses table using the calculated bonus percentage
      UPDATE bonuses SET bonus = ( :salary_value * :updated_bonus_percentage )
        WHERE emp_id = :emp_id_value;
    END IF;
  END FOR;
  -- Return text when the stored procedure completes
  RETURN 'Update applied';
END;

-- Example 22389
CREATE OR REPLACE PROCEDURE apply_bonus(bonus_percentage INT, performance_value INT)
  RETURNS TEXT
  LANGUAGE SQL
AS
$$
DECLARE
  -- Use input to calculate the bonus percentage
  updated_bonus_percentage NUMBER(2,2) DEFAULT (:bonus_percentage/100);
  --  Declare a result set
  rs RESULTSET;
BEGIN
  -- Assign a query to the result set and execute the query
  rs := (SELECT * FROM bonuses);
  -- Use a FOR loop to iterate over the records in the result set
  FOR record IN rs DO
    -- Assign variable values using values in the current record
    LET emp_id_value INT := record.emp_id;
    LET performance_rating_value INT := record.performance_rating;
    LET salary_value NUMBER(12, 2) := record.salary;
    -- Determine whether the performance rating in the record matches the user input
    IF (performance_rating_value = :performance_value) THEN
      -- If the condition is met, update the bonuses table using the calculated bonus percentage
      UPDATE bonuses SET bonus = ( :salary_value * :updated_bonus_percentage )
        WHERE emp_id = :emp_id_value;
    END IF;
  END FOR;
  -- Return text when the stored procedure completes
  RETURN 'Update applied';
END;
$$
;

-- Example 22390
CALL apply_bonus(3, 5);

-- Example 22391
SELECT * FROM bonuses;

-- Example 22392
+--------+--------------------+-----------+---------+
| EMP_ID | PERFORMANCE_RATING |    SALARY |   BONUS |
|--------+--------------------+-----------+---------|
|   1001 |                  3 | 100000.00 |    NULL |
|   1002 |                  1 |  50000.00 |    NULL |
|   1003 |                  4 |  75000.00 |    NULL |
|   1004 |                  4 |  80000.00 |    NULL |
|   1005 |                  5 | 120000.00 | 3600.00 |
|   1006 |                  2 |  60000.00 |    NULL |
|   1007 |                  5 |  40000.00 | 1200.00 |
|   1008 |                  3 | 140000.00 |    NULL |
|   1009 |                  1 |  95000.00 |    NULL |
+--------+--------------------+-----------+---------+

-- Example 22393
CREATE OR REPLACE TABLE vm_ownership (
  emp_id INT,
  vm_id VARCHAR
);

INSERT INTO vm_ownership (emp_id, vm_id) VALUES
  (1001, 1),
  (1001, 5),
  (1002, 3),
  (1003, 4),
  (1003, 6),
  (1003, 2);

CREATE OR REPLACE TABLE vm_settings (
  vm_id INT,
  vm_setting VARCHAR,
  value NUMBER
);

INSERT INTO vm_settings (vm_id, vm_setting, value) VALUES
  (1, 's1', 5),
  (1, 's2', 500),
  (2, 's1', 10),
  (2, 's2', 600),
  (3, 's1', 3),
  (3, 's2', 400),
  (4, 's1', 8),
  (4, 's2', 700),
  (5, 's1', 1),
  (5, 's2', 300),
  (6, 's1', 7),
  (6, 's2', 800);

CREATE OR REPLACE TABLE vm_settings_history (
  vm_id INT,
  vm_setting VARCHAR,
  value NUMBER,
  owner INT,
  date DATE
);

-- Example 22394
CREATE OR REPLACE PROCEDURE vm_user_settings()
  RETURNS VARCHAR
  LANGUAGE SQL
AS
DECLARE
  -- Declare a cursor and a variable
  c1 CURSOR FOR SELECT * FROM vm_settings;
  current_owner NUMBER;
BEGIN
  -- Open the cursor to execute the query and retrieve the rows into the cursor
  OPEN c1;
  -- Use a FOR loop to iterate over the records in the result set
  FOR record IN c1 DO
    -- Assign variable values using values in the current record
    LET current_vm_id NUMBER := record.vm_id;
    LET current_vm_setting VARCHAR := record.vm_setting;
    LET current_value NUMBER := record.value;
    -- Assign a value to the current_owner variable by querying the vm_ownership table
    SELECT emp_id INTO :current_owner
      FROM vm_ownership
      WHERE vm_id = :current_vm_id;
    -- If the record has a vm_setting equal to 's1', determine whether its value is less than 5
    IF (current_vm_setting = 's1' AND current_value < 5) THEN
      -- If the condition is met, insert a row into the vm_settings_history table
      INSERT INTO vm_settings_history VALUES (
        :current_vm_id,
        :current_vm_setting,
        :current_value,
        :current_owner,
        SYSDATE());
    -- If the record has a vm_setting equal to 's2', determine whether its value is greater than 500
    ELSEIF (current_vm_setting = 's2' AND current_value > 500) THEN
      -- If the condition is met, insert a row into the vm_settings_history table
      INSERT INTO vm_settings_history VALUES (
        :current_vm_id,
        :current_vm_setting,
        :current_value,
        :current_owner,
        SYSDATE());
    END IF;
  END FOR;
  -- Close the cursor
  CLOSE c1;
  -- Return text when the stored procedure completes
  RETURN 'Success';
END;

-- Example 22395
CREATE OR REPLACE PROCEDURE vm_user_settings()
  RETURNS VARCHAR
  LANGUAGE SQL
AS
$$
DECLARE
  -- Declare a cursor and a variable
  c1 CURSOR FOR SELECT * FROM vm_settings;
  current_owner NUMBER;
BEGIN
  -- Open the cursor to execute the query and retrieve the rows into the cursor
  OPEN c1;
  -- Use a FOR loop to iterate over the records in the result set
  FOR record IN c1 DO
    -- Assign variable values using values in the current record
    LET current_vm_id NUMBER := record.vm_id;
    LET current_vm_setting VARCHAR := record.vm_setting;
    LET current_value NUMBER := record.value;
    -- Assign a value to the current_owner variable by querying the vm_ownership table
    SELECT emp_id INTO :current_owner
      FROM vm_ownership
      WHERE vm_id = :current_vm_id;
    -- If the record has a vm_setting equal to 's1', determine whether its value is less than 5
    IF (current_vm_setting = 's1' AND current_value < 5) THEN
      -- If the condition is met, insert a row into the vm_settings_history table
      INSERT INTO vm_settings_history VALUES (
        :current_vm_id,
        :current_vm_setting,
        :current_value,
        :current_owner,
        SYSDATE());
    -- If the record has a vm_setting equal to 's2', determine whether its value is greater than 500
    ELSEIF (current_vm_setting = 's2' AND current_value > 500) THEN
      -- If the condition is met, insert a row into the vm_settings_history table
      INSERT INTO vm_settings_history VALUES (
        :current_vm_id,
        :current_vm_setting,
        :current_value,
        :current_owner,
        SYSDATE());
    END IF;
  END FOR;
  -- Close the cursor
  CLOSE c1;
  -- Return text when the stored procedure completes
  RETURN 'Success';
END;
$$;

-- Example 22396
CALL vm_user_settings();

-- Example 22397
SELECT * FROM vm_settings_history ORDER BY vm_id;

-- Example 22398
+-------+------------+-------+-------+------------+
| VM_ID | VM_SETTING | VALUE | OWNER | DATE       |
|-------+------------+-------+-------+------------|
|     2 | s2         |   600 |  1003 | 2024-04-01 |
|     3 | s1         |     3 |  1002 | 2024-04-01 |
|     4 | s2         |   700 |  1003 | 2024-04-01 |
|     5 | s1         |     1 |  1001 | 2024-04-01 |
|     6 | s2         |   800 |  1003 | 2024-04-01 |
+-------+------------+-------+-------+------------+

-- Example 22399
CREATE PROCEDURE stproc1()
  RETURNS STRING NOT NULL
  LANGUAGE JAVASCRIPT
  AS
  -- "$$" is the delimiter for the beginning and end of the stored procedure.
  $$
  // The "snowflake" object is provided automatically in each stored procedure.
  var statement = snowflake.createStatement(...);
  ...
  $$
  ;

-- Example 22400
snowflake.addEvent('my_event', {'score': 89, 'pass': true});

-- Example 22401
var stmt = snowflake.createStatement(
  {sqlText: "INSERT INTO table1 (col1) VALUES (1);"}
);

-- Example 22402
var stmt = snowflake.createStatement(
  {
  sqlText: "INSERT INTO table2 (col1, col2) VALUES (?, ?);",
  binds:["LiteralValue1", variable2]
  }
);

-- Example 22403
snowflake.log("error", "Error message", {"custom1": "value1", "custom2": "value2"});

-- Example 22404
snowflake.setSpanAttribute("example.boolean", true);

-- Example 22405
var column_count = statement.getColumnCount();

-- Example 22406
CREATE TABLE scale_example  (
    n10_4 NUMERIC(10, 4)    // Precision is 10, Scale is 4.
    );

-- Example 22407
var row_count = statement.getRowCount();

-- Example 22408
var queryId = statement.getQueryId();

-- Example 22409
var queryText = statement.getSqlText();

-- Example 22410
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

-- Example 22411
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

-- Example 22412
var queryId = resultSet.getQueryId();

-- Example 22413
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

-- Example 22414
CALL test_get_epoch_seconds('1970-01-01 00:00:00.000000000');
+------------------------+
| TEST_GET_EPOCH_SECONDS |
|------------------------|
|                      0 |
+------------------------+

-- Example 22415
CALL test_get_epoch_seconds('1970-01-01 00:00:01.987654321');
+------------------------+
| TEST_GET_EPOCH_SECONDS |
|------------------------|
|                      1 |
+------------------------+

-- Example 22416
CALL test_get_epoch_seconds('1971-01-01 00:00:00');
+------------------------+
| TEST_GET_EPOCH_SECONDS |
|------------------------|
|               31536000 |
+------------------------+

-- Example 22417
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

-- Example 22418
CALL test_get_nano_seconds2('1970-01-01 00:00:00.000000000');
+------------------------+
| TEST_GET_NANO_SECONDS2 |
|------------------------|
|                      0 |
+------------------------+

-- Example 22419
CALL test_get_nano_seconds2('1970-01-01 00:00:01.987654321');
+------------------------+
| TEST_GET_NANO_SECONDS2 |
|------------------------|
|              987654321 |
+------------------------+

-- Example 22420
CALL test_get_nano_seconds2('1971-01-01 00:00:00.000123456');
+------------------------+
| TEST_GET_NANO_SECONDS2 |
|------------------------|
|                 123456 |
+------------------------+

-- Example 22421
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

-- Example 22422
CALL test_get_scale('1970-01-01 00:00:00', '0');
+----------------+
| TEST_GET_SCALE |
|----------------|
|              0 |
+----------------+

