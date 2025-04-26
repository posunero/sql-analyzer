-- Example 15926
+---------------+
| COMMENT       |
|---------------|
| My Test Table |
+---------------+

-- Example 15927
CREATE OR REPLACE STAGE st;
PUT file://good_data.csv @st;
PUT file://errors_data.csv @st;

-- Example 15928
CREATE OR REPLACE TABLE test_bind_stage_and_load (a VARCHAR, b VARCHAR, c VARCHAR);

-- Example 15929
CREATE OR REPLACE PROCEDURE test_copy_files_validate(
  my_stage_name VARCHAR,
  on_error VARCHAR,
  valid_mode VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
  COPY INTO test_bind_stage_and_load
    FROM :my_stage_name
    ON_ERROR=:on_error
    FILE_FORMAT=(type='csv')
    VALIDATION_MODE=:valid_mode;
END;

-- Example 15930
CREATE OR REPLACE PROCEDURE test_copy_files_validate(
  my_stage_name VARCHAR,
  on_error VARCHAR,
  valid_mode VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  COPY INTO test_bind_stage_and_load
    FROM :my_stage_name
    ON_ERROR=:on_error
    FILE_FORMAT=(type='csv')
    VALIDATION_MODE=:valid_mode;
END;
$$
;

-- Example 15931
CALL test_copy_files_validate('@st', 'skip_file', 'return_all_errors');

-- Example 15932
CREATE OR REPLACE PROCEDURE get_row_count(table_name VARCHAR)
RETURNS INTEGER NOT NULL
LANGUAGE SQL
AS
DECLARE
  row_count INTEGER DEFAULT 0;
  res RESULTSET DEFAULT (SELECT COUNT(*) AS COUNT FROM IDENTIFIER(:table_name));
  c1 CURSOR FOR res;
BEGIN
  FOR row_variable IN c1 DO
    row_count := row_variable.count;
  END FOR;
  RETURN row_count;
END;

-- Example 15933
CREATE OR REPLACE PROCEDURE get_row_count(table_name VARCHAR)
RETURNS INTEGER NOT NULL
LANGUAGE SQL
AS
$$
DECLARE
  row_count INTEGER DEFAULT 0;
  res RESULTSET DEFAULT (SELECT COUNT(*) AS COUNT FROM IDENTIFIER(:table_name));
  c1 CURSOR FOR res;
BEGIN
  FOR row_variable IN c1 DO
    row_count := row_variable.count;
  END FOR;
  RETURN row_count;
END;
$$
;

-- Example 15934
CALL get_row_count('invoices');

-- Example 15935
CREATE OR REPLACE PROCEDURE ctas_sp(existing_table VARCHAR, new_table VARCHAR)
  RETURNS TEXT
  LANGUAGE SQL
AS
BEGIN
  CREATE OR REPLACE TABLE IDENTIFIER(:new_table) AS
    SELECT * FROM IDENTIFIER(:existing_table);
  RETURN 'Table created';
END;

-- Example 15936
CREATE OR REPLACE PROCEDURE ctas_sp(existing_table VARCHAR, new_table VARCHAR)
  RETURNS TEXT
  LANGUAGE SQL
AS
$$
BEGIN
  CREATE OR REPLACE TABLE IDENTIFIER(:new_table) AS
    SELECT * FROM IDENTIFIER(:existing_table);
  RETURN 'Table created';
END;
$$
;

-- Example 15937
CREATE OR REPLACE TABLE test_table_for_ctas_sp (
  id NUMBER(2),
  v  VARCHAR(2))
AS SELECT
  column1,
  column2,
FROM
  VALUES
    (1, 'a'),
    (2, 'b'),
    (3, 'c');

-- Example 15938
CALL ctas_sp('test_table_for_ctas_sp', 'test_table_for_ctas_sp_backup');

-- Example 15939
CREATE OR REPLACE PROCEDURE find_invoice_by_id_via_execute_immediate(id VARCHAR)
RETURNS TABLE (id INTEGER, price NUMBER(12,2))
LANGUAGE SQL
AS
DECLARE
  select_statement VARCHAR;
  res RESULTSET;
BEGIN
  select_statement := 'SELECT * FROM invoices WHERE id = ' || id;
  res := (EXECUTE IMMEDIATE :select_statement);
  RETURN TABLE(res);
END;

-- Example 15940
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE (sales_date DATE, quantity NUMBER)
...

-- Example 15941
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE ()
...

-- Example 15942
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 15943
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 15944
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 15945
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 15946
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 15947
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE (sales_date DATE, quantity NUMBER)
LANGUAGE SQL
AS
DECLARE
  res RESULTSET DEFAULT (SELECT sales_date, quantity FROM sales ORDER BY quantity DESC LIMIT 10);
BEGIN
  RETURN TABLE(res);
END;

-- Example 15948
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE (sales_date DATE, quantity NUMBER)
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT sales_date, quantity FROM sales ORDER BY quantity DESC LIMIT 10);
BEGIN
  RETURN TABLE(res);
END;
$$
;

-- Example 15949
CALL get_top_sales();

-- Example 15950
-- Create a table for use in the example.
CREATE OR REPLACE TABLE int_table (value INTEGER);

-- Example 15951
-- Create a stored procedure to be called from another stored procedure.
CREATE OR REPLACE PROCEDURE insert_value(value INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
  INSERT INTO int_table VALUES (:value);
  RETURN 'Rows inserted: ' || SQLROWCOUNT;
END;

-- Example 15952
-- Create a stored procedure to be called from another stored procedure.
CREATE OR REPLACE PROCEDURE insert_value(value INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  INSERT INTO int_table VALUES (:value);
  RETURN 'Rows inserted: ' || SQLROWCOUNT;
END;
$$
;

-- Example 15953
CREATE OR REPLACE PROCEDURE insert_two_values(value1 INTEGER, value2 INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
  CALL insert_value(:value1);
  CALL insert_value(:value2);
  RETURN 'Finished calling stored procedures';
END;

-- Example 15954
CREATE OR REPLACE PROCEDURE insert_two_values(value1 INTEGER, value2 INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  CALL insert_value(:value1);
  CALL insert_value(:value2);
  RETURN 'Finished calling stored procedures';
END;
$$
;

-- Example 15955
CALL insert_two_values(4, 5);

-- Example 15956
CREATE OR REPLACE PROCEDURE count_greater_than(table_name VARCHAR, maximum_count INTEGER)
  RETURNS BOOLEAN NOT NULL
  LANGUAGE SQL
  AS
  DECLARE
    count1 NUMBER;
  BEGIN
    CALL get_row_count(:table_name) INTO :count1;
    IF (:count1 > maximum_count) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

-- Example 15957
CREATE OR REPLACE PROCEDURE count_greater_than(table_name VARCHAR, maximum_count INTEGER)
  RETURNS BOOLEAN NOT NULL
  LANGUAGE SQL
  AS
  $$
  DECLARE
    count1 NUMBER;
  BEGIN
    CALL get_row_count(:table_name) INTO :count1;
    IF (:count1 > maximum_count) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;
  $$
  ;

-- Example 15958
CALL count_greater_than('invoices', 3);

-- Example 15959
DECLARE
  res1 RESULTSET;
BEGIN
res1 := (CALL my_procedure());
LET c1 CURSOR FOR res1;
FOR row_variable IN c1 DO
  IF (row_variable.col1 > 0) THEN
    ...;
  ELSE
    ...;
  END IF;
END FOR;
...

-- Example 15960
SET example_use_variable = 2;

-- Example 15961
CREATE OR REPLACE PROCEDURE use_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
  sess_var_x_2 NUMBER;
BEGIN
  sess_var_x_2 := 2 * $example_use_variable;
  RETURN sess_var_x_2;
END;

-- Example 15962
CREATE OR REPLACE PROCEDURE use_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
  sess_var_x_2 NUMBER;
BEGIN
  sess_var_x_2 := 2 * $example_use_variable;
  RETURN sess_var_x_2;
END;
$$
;

-- Example 15963
CALL use_sql_variable_proc();

-- Example 15964
+-----------------------+
| USE_SQL_VARIABLE_PROC |
|-----------------------|
|                     4 |
+-----------------------+

-- Example 15965
SET example_use_variable = 9;

-- Example 15966
CALL use_sql_variable_proc();

-- Example 15967
+-----------------------+
| USE_SQL_VARIABLE_PROC |
|-----------------------|
|                    18 |
+-----------------------+

-- Example 15968
SET example_set_variable = 55;

-- Example 15969
SHOW VARIABLES LIKE 'example_set_variable';

-- Example 15970
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+
|     session_id | created_on                    | updated_on                    | name                 | value | type  | comment |
|----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------|
| 10363782631910 | 2024-11-27 08:18:32.007 -0800 | 2024-11-27 08:20:17.255 -0800 | EXAMPLE_SET_VARIABLE | 55    | fixed |         |
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+

-- Example 15971
CREATE OR REPLACE PROCEDURE set_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
  SET example_set_variable = $example_set_variable - 3;
  RETURN $example_set_variable;
END;

-- Example 15972
CREATE OR REPLACE PROCEDURE set_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
  SET example_set_variable = $example_set_variable - 3;
  RETURN $example_set_variable;
END;
$$
;

-- Example 15973
CALL set_sql_variable_proc();

-- Example 15974
+-----------------------+
| SET_SQL_VARIABLE_PROC |
|-----------------------|
|                    52 |
+-----------------------+

-- Example 15975
SHOW VARIABLES LIKE 'example_set_variable';

-- Example 15976
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+
|     session_id | created_on                    | updated_on                    | name                 | value | type  | comment |
|----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------|
| 10363782631910 | 2024-11-27 08:18:32.007 -0800 | 2024-11-27 08:24:04.027 -0800 | EXAMPLE_SET_VARIABLE | 52    | fixed |         |
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+

-- Example 15977
Session session = Session.builder().configFile("my_config.properties").create();

StoredProcedure sp =
  session.sproc().registerTemporary(
    (Session spSession, Integer num) -> num + 1,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

-- Example 15978
session.storedProcedure(sp, 1).show();

-- Example 15979
Session session = Session.builder().configFile("my_config.properties").create();

String procName = "increment";

StoredProcedure tempSP =
  session.sproc().registerTemporary(
    procName,
    (Session session, Integer num) -> num + 1,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

-- Example 15980
session.storedProcedure(procName, 1).show();

-- Example 15981
Session session = Session.builder().configFile("my_config.properties").create();

String procName = "add_hundred";
String stageName = "sproc_libs";

StoredProcedure sp =
    session.sproc().registerPermanent(
        procName,
        (Session session, Integer num) -> num + 100,
        DataTypes.IntegerType,
        DataTypes.IntegerType,
        stageName,
        true
    );

-- Example 15982
session.storedProcedure(procName, 1).show();

-- Example 15983
import pandas as pd
import snowflake.snowpark
import xgboost as xgb
from snowflake.snowpark.functions import sproc

session.add_packages("snowflake-snowpark-python", "pandas", "xgboost==1.5.0")

@sproc
def compute(session: snowflake.snowpark.Session) -> list:
  return [pd.__version__, xgb.__version__]

-- Example 15984
session.add_requirements("mydir/requirements.txt")

-- Example 15985
import pandas as pd
import snowflake.snowpark
import xgboost as xgb
from snowflake.snowpark.functions import sproc

@sproc(packages=["snowflake-snowpark-python", "pandas", "xgboost==1.5.0"])
def compute(session: snowflake.snowpark.Session) -> list:
  return [pd.__version__, xgb.__version__]

-- Example 15986
from snowflake.snowpark.functions import sproc
from snowflake.snowpark.types import IntegerType

add_one = sproc(lambda session, x: session.sql(f"select {x} + 1").collect()[0][0], return_type=IntegerType(), input_types=[IntegerType()], packages=["snowflake-snowpark-python"])

-- Example 15987
from snowflake.snowpark.functions import sproc
from snowflake.snowpark.types import IntegerType

add_one = sproc(lambda session, x: session.sql(f"select {x} + 1").collect()[0][0], return_type=IntegerType(), input_types=[IntegerType()], name="my_sproc", replace=True, packages=["snowflake-snowpark-python"])

-- Example 15988
import snowflake.snowpark
from snowflake.snowpark.functions import sproc

@sproc(name="minus_one", is_permanent=True, stage_location="@my_stage", replace=True, packages=["snowflake-snowpark-python"])
def minus_one(session: snowflake.snowpark.Session, x: int) -> int:
  return session.sql(f"select {x} - 1").collect()[0][0]

-- Example 15989
add_one(1)

-- Example 15990
2

-- Example 15991
session.call("minus_one", 1)

-- Example 15992
0

