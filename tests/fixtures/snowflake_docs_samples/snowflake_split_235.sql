-- Example 15725
CREATE OR REPLACE PROCEDURE test_bind_comment(comment VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  CREATE OR REPLACE TABLE test_table_with_comment(a VARCHAR, n NUMBER) COMMENT = :comment;
END;
$$
;

-- Example 15726
CALL test_bind_comment('My Test Table');

-- Example 15727
SELECT comment FROM information_schema.tables WHERE table_name='TEST_TABLE_WITH_COMMENT';

-- Example 15728
+---------------+
| COMMENT       |
|---------------|
| My Test Table |
+---------------+

-- Example 15729
CREATE OR REPLACE STAGE st;
PUT file://good_data.csv @st;
PUT file://errors_data.csv @st;

-- Example 15730
CREATE OR REPLACE TABLE test_bind_stage_and_load (a VARCHAR, b VARCHAR, c VARCHAR);

-- Example 15731
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

-- Example 15732
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

-- Example 15733
CALL test_copy_files_validate('@st', 'skip_file', 'return_all_errors');

-- Example 15734
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

-- Example 15735
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

-- Example 15736
CALL get_row_count('invoices');

-- Example 15737
CREATE OR REPLACE PROCEDURE ctas_sp(existing_table VARCHAR, new_table VARCHAR)
  RETURNS TEXT
  LANGUAGE SQL
AS
BEGIN
  CREATE OR REPLACE TABLE IDENTIFIER(:new_table) AS
    SELECT * FROM IDENTIFIER(:existing_table);
  RETURN 'Table created';
END;

-- Example 15738
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

-- Example 15739
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

-- Example 15740
CALL ctas_sp('test_table_for_ctas_sp', 'test_table_for_ctas_sp_backup');

-- Example 15741
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

-- Example 15742
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE (sales_date DATE, quantity NUMBER)
...

-- Example 15743
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE ()
...

-- Example 15744
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 15745
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 15746
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 15747
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 15748
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 15749
CREATE OR REPLACE PROCEDURE get_top_sales()
RETURNS TABLE (sales_date DATE, quantity NUMBER)
LANGUAGE SQL
AS
DECLARE
  res RESULTSET DEFAULT (SELECT sales_date, quantity FROM sales ORDER BY quantity DESC LIMIT 10);
BEGIN
  RETURN TABLE(res);
END;

-- Example 15750
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

-- Example 15751
CALL get_top_sales();

-- Example 15752
-- Create a table for use in the example.
CREATE OR REPLACE TABLE int_table (value INTEGER);

-- Example 15753
-- Create a stored procedure to be called from another stored procedure.
CREATE OR REPLACE PROCEDURE insert_value(value INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
  INSERT INTO int_table VALUES (:value);
  RETURN 'Rows inserted: ' || SQLROWCOUNT;
END;

-- Example 15754
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

-- Example 15755
CREATE OR REPLACE PROCEDURE insert_two_values(value1 INTEGER, value2 INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
  CALL insert_value(:value1);
  CALL insert_value(:value2);
  RETURN 'Finished calling stored procedures';
END;

-- Example 15756
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

-- Example 15757
CALL insert_two_values(4, 5);

-- Example 15758
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

-- Example 15759
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

-- Example 15760
CALL count_greater_than('invoices', 3);

-- Example 15761
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

-- Example 15762
SET example_use_variable = 2;

-- Example 15763
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

-- Example 15764
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

-- Example 15765
CALL use_sql_variable_proc();

-- Example 15766
+-----------------------+
| USE_SQL_VARIABLE_PROC |
|-----------------------|
|                     4 |
+-----------------------+

-- Example 15767
SET example_use_variable = 9;

-- Example 15768
CALL use_sql_variable_proc();

-- Example 15769
+-----------------------+
| USE_SQL_VARIABLE_PROC |
|-----------------------|
|                    18 |
+-----------------------+

-- Example 15770
SET example_set_variable = 55;

-- Example 15771
SHOW VARIABLES LIKE 'example_set_variable';

-- Example 15772
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+
|     session_id | created_on                    | updated_on                    | name                 | value | type  | comment |
|----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------|
| 10363782631910 | 2024-11-27 08:18:32.007 -0800 | 2024-11-27 08:20:17.255 -0800 | EXAMPLE_SET_VARIABLE | 55    | fixed |         |
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+

-- Example 15773
CREATE OR REPLACE PROCEDURE set_sql_variable_proc()
RETURNS NUMBER
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
  SET example_set_variable = $example_set_variable - 3;
  RETURN $example_set_variable;
END;

-- Example 15774
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

-- Example 15775
CALL set_sql_variable_proc();

-- Example 15776
+-----------------------+
| SET_SQL_VARIABLE_PROC |
|-----------------------|
|                    52 |
+-----------------------+

-- Example 15777
SHOW VARIABLES LIKE 'example_set_variable';

-- Example 15778
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+
|     session_id | created_on                    | updated_on                    | name                 | value | type  | comment |
|----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------|
| 10363782631910 | 2024-11-27 08:18:32.007 -0800 | 2024-11-27 08:24:04.027 -0800 | EXAMPLE_SET_VARIABLE | 52    | fixed |         |
+----------------+-------------------------------+-------------------------------+----------------------+-------+-------+---------+

-- Example 15779
SELECT ... FROM TABLE( <stored_procedure_name>( <arg> [ , <arg> ... ] ) );

-- Example 15780
CREATE OR REPLACE TABLE orders (
  order_id INT,
  u_id VARCHAR,
  order_date DATE,
  order_amount NUMBER(12,2));

INSERT INTO orders VALUES (1, 'user_id_001', current_date, 500.00);
INSERT INTO orders VALUES (2, 'user_id_003', current_date, 225.00);
INSERT INTO orders VALUES (3, 'user_id_001', current_date, 725.00);
INSERT INTO orders VALUES (4, 'user_id_002', current_date, 150.00);
INSERT INTO orders VALUES (5, 'user_id_002', current_date, 900.00);

-- Example 15781
CREATE OR REPLACE PROCEDURE find_orders_by_user_id(user_id VARCHAR)
RETURNS TABLE (
  order_id INT, order_date DATE, order_amount NUMBER(12,2)
)
LANGUAGE SQL AS
DECLARE
  res RESULTSET;
BEGIN
  res := (SELECT order_id, order_date, order_amount FROM orders WHERE u_id = :user_id);
  RETURN TABLE(res);
END;

-- Example 15782
CREATE OR REPLACE PROCEDURE find_orders_by_user_id(user_id VARCHAR)
RETURNS TABLE (
  order_id INT, order_date DATE, order_amount NUMBER(12,2)
)
LANGUAGE SQL AS
$$
DECLARE
  res RESULTSET;
BEGIN
  res := (SELECT order_id, order_date, order_amount FROM orders WHERE u_id = :user_id);
  RETURN TABLE(res);
END;
$$
;

-- Example 15783
SELECT * FROM TABLE(find_orders_by_user_id('user_id_001'));

-- Example 15784
+----------+------------+--------------+
| ORDER_ID | ORDER_DATE | ORDER_AMOUNT |
|----------+------------+--------------|
|        1 | 2024-08-30 |       500.00 |
|        3 | 2024-08-30 |       725.00 |
+----------+------------+--------------+

-- Example 15785
RETURNS TABLE (col1 INT, col2 STRING)

-- Example 15786
RETURNS STRING

-- Example 15787
RETURNS TABLE()

-- Example 15788
CREATE OR REPLACE PROCEDURE sp_concatenate_strings(
    first_arg VARCHAR,
    second_arg VARCHAR,
    third_arg VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
  BEGIN
    RETURN first_arg || second_arg || third_arg;
  END;
  $$;

-- Example 15789
CALL sp_concatenate_strings(
  first_arg => 'one',
  second_arg => 'two',
  third_arg => 'three');

-- Example 15790
+------------------------+
| SP_CONCATENATE_STRINGS |
|------------------------|
| onetwothree            |
+------------------------+

-- Example 15791
CALL sp_concatenate_strings(
  third_arg => 'three',
  first_arg => 'one',
  second_arg => 'two');

