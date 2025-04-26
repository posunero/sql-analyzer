-- Example 3197
CREATE OR REPLACE PROCEDURE exception_test_vars(amount INT)
  RETURNS TEXT
  LANGUAGE SQL
AS
DECLARE
  my_exception_1 EXCEPTION (-20002, 'Value too low');
  my_exception_2 EXCEPTION (-20003, 'Value too high');
BEGIN
  CREATE OR REPLACE TABLE test_order_insert(units INT);
  IF (amount < 1) THEN
    RAISE my_exception_1;
  ELSEIF (amount > 10) THEN
    RAISE my_exception_2;
  ELSE
    INSERT INTO test_order_insert VALUES (:amount);
  END IF;
  RETURN 'Order inserted successfully.';
EXCEPTION
  WHEN my_exception_1 THEN
    RETURN 'Error ' || sqlcode || ': Submitted amount ' || amount || ' is too low (1 or greater required).';
  WHEN my_exception_2 THEN
    RETURN 'Error ' || sqlcode || ': Submitted amount ' || amount || ' is too high (exceeds limit of 10).';
END;

-- Example 3198
CREATE OR REPLACE PROCEDURE exception_test_vars(amount INT)
  RETURNS TEXT
  LANGUAGE SQL
AS
$$
DECLARE
  my_exception_1 EXCEPTION (-20002, 'Value too low');
  my_exception_2 EXCEPTION (-20003, 'Value too high');
BEGIN
  CREATE OR REPLACE TABLE test_order_insert(units INT);
  IF (amount < 1) THEN
    RAISE my_exception_1;
  ELSEIF (amount > 10) THEN
    RAISE my_exception_2;
  ELSE
    INSERT INTO test_order_insert VALUES (:amount);
  END IF;
  RETURN 'Order inserted successfully.';
EXCEPTION
  WHEN my_exception_1 THEN
    RETURN 'Error ' || sqlcode || ': Submitted amount ' || amount || ' is too low (1 or greater required).';
  WHEN my_exception_2 THEN
    RETURN 'Error ' || sqlcode || ': Submitted amount ' || amount || ' is too high (exceeds limit of 10).';
END;
$$
;

-- Example 3199
CALL exception_test_vars(7);

-- Example 3200
+------------------------------+
| EXCEPTION_TEST_VARS          |
|------------------------------|
| Order inserted successfully. |
+------------------------------+

-- Example 3201
CALL exception_test_vars(-3);

-- Example 3202
+-----------------------------------------------------------------------+
| EXCEPTION_TEST_VARS                                                   |
|-----------------------------------------------------------------------|
| Error -20002: Submitted amount -3 is too low (1 or greater required). |
+-----------------------------------------------------------------------+

-- Example 3203
CALL exception_test_vars(20);

-- Example 3204
+----------------------------------------------------------------------+
| EXCEPTION_TEST_VARS                                                  |
|----------------------------------------------------------------------|
| Error -20003: Submitted amount 20 is too high (exceeds limit of 10). |
+----------------------------------------------------------------------+

-- Example 3205
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2025_01');

-- Example 3206
SELECT SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2025_01');

-- Example 3207
CREATE OR REPLACE TABLE my_values (value NUMBER);

-- Example 3208
BEGIN
  LET sql_row_count_var INT := 0;
  INSERT INTO my_values VALUES (1), (2), (3);
  sql_row_count_var := SQLROWCOUNT;
  SELECT * from my_values;
  RETURN sql_row_count_var;
END;

-- Example 3209
EXECUTE IMMEDIATE $$
BEGIN
  LET sql_row_count_var INT := 0;
  INSERT INTO my_values VALUES (1), (2), (3);
  sql_row_count_var := SQLROWCOUNT;
  SELECT * from my_values;
  RETURN sql_row_count_var;
END;
$$;

-- Example 3210
+-----------------+
| anonymous block |
|-----------------|
|               3 |
+-----------------+

-- Example 3211
BEGIN
  LET sql_row_count_var INT := 0;
  LET sql_found_var BOOLEAN := NULL;
  LET sql_notfound_var BOOLEAN := NULL;
  IF ((SELECT MAX(value) FROM my_values) > 2) THEN
    UPDATE my_values SET value = 4 WHERE value < 3;
    sql_row_count_var := SQLROWCOUNT;
    sql_found_var := SQLFOUND;
    sql_notfound_var := SQLNOTFOUND;
  END IF;
  SELECT * from my_values;
  IF (sql_found_var = true) THEN
    RETURN 'Updated ' || sql_row_count_var || ' rows.';
  ELSEIF (sql_notfound_var = true) THEN
    RETURN 'No rows updated.';
  ELSE
    RETURN 'No DML statements executed.';
  END IF;
END;

-- Example 3212
EXECUTE IMMEDIATE $$
BEGIN
  LET sql_row_count_var INT := 0;
  LET sql_found_var BOOLEAN := NULL;
  LET sql_notfound_var BOOLEAN := NULL;
  IF ((SELECT MAX(value) FROM my_values) > 2) THEN
    UPDATE my_values SET value = 4 WHERE value < 3;
    sql_row_count_var := SQLROWCOUNT;
    sql_found_var := SQLFOUND;
    sql_notfound_var := SQLNOTFOUND;
  END IF;
  SELECT * from my_values;
  IF (sql_found_var = true) THEN
    RETURN 'Updated ' || sql_row_count_var || ' rows.';
  ELSEIF (sql_notfound_var = true) THEN
    RETURN 'No rows updated.';
  ELSE
    RETURN 'No DML statements executed.';
  END IF;
END;
$$;

-- Example 3213
+-----------------+
| anonymous block |
|-----------------|
| Updated 2 rows. |
+-----------------+

-- Example 3214
SELECT * FROM my_values;

-- Example 3215
+-------+
| VALUE |
|-------|
|     4 |
|     4 |
|     3 |
+-------+

-- Example 3216
+------------------+
| anonymous block  |
|------------------|
| No rows updated. |
+------------------+

-- Example 3217
UPDATE my_values SET value = 1;

SELECT * FROM my_values;

-- Example 3218
+-------+
| VALUE |
|-------|
|     1 |
|     1 |
|     1 |
+-------+

-- Example 3219
+-----------------------------+
| anonymous block             |
|-----------------------------|
| No DML statements executed. |
+-----------------------------+

-- Example 3220
DECLARE
  query_id_1 VARCHAR;
  query_id_2 VARCHAR;
BEGIN
  SELECT 1;
  query_id_1 := SQLID;
  SELECT 2;
  query_id_2 := SQLID;
  RETURN [query_id_1, query_id_2];
END;

-- Example 3221
EXECUTE IMMEDIATE $$
DECLARE
  query_id_1 VARCHAR;
  query_id_2 VARCHAR;
BEGIN
  SELECT 1;
  query_id_1 := SQLID;
  SELECT 2;
  query_id_2 := SQLID;
  RETURN [query_id_1, query_id_2];
END;
$$
;

-- Example 3222
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

-- Example 3223
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

-- Example 3224
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

-- Example 3225
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

-- Example 3226
CALL apply_bonus(3, 5);

-- Example 3227
SELECT * FROM bonuses;

-- Example 3228
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

-- Example 3229
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

-- Example 3230
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

-- Example 3231
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

-- Example 3232
CALL vm_user_settings();

-- Example 3233
SELECT * FROM vm_settings_history ORDER BY vm_id;

-- Example 3234
+-------+------------+-------+-------+------------+
| VM_ID | VM_SETTING | VALUE | OWNER | DATE       |
|-------+------------+-------+-------+------------|
|     2 | s2         |   600 |  1003 | 2024-04-01 |
|     3 | s1         |     3 |  1002 | 2024-04-01 |
|     4 | s2         |   700 |  1003 | 2024-04-01 |
|     5 | s1         |     1 |  1001 | 2024-04-01 |
|     6 | s2         |   800 |  1003 | 2024-04-01 |
+-------+------------+-------+-------+------------+

-- Example 3235
SQL compilation error: syntax error line 2 at position 25 unexpected '<EOF>'

-- Example 3236
CREATE OR REPLACE PROCEDURE myprocedure()
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
    -- Snowflake Scripting code
    DECLARE
      radius_of_circle FLOAT;
      area_of_circle FLOAT;
    BEGIN
      radius_of_circle := 3;
      area_of_circle := pi() * radius_of_circle * radius_of_circle;
      RETURN area_of_circle;
    END;
  $$
  ;

-- Example 3237
EXECUTE IMMEDIATE $$
-- Snowflake Scripting code
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := pi() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;
$$
;

-- Example 3238
SET stmt =
$$
DECLARE
    radius_of_circle FLOAT;
    area_of_circle FLOAT;
BEGIN
    radius_of_circle := 3;
    area_of_circle := pi() * radius_of_circle * radius_of_circle;
    RETURN area_of_circle;
END;
$$
;

EXECUTE IMMEDIATE $stmt;

-- Example 3239
SELECT city_name, temperature
    FROM TABLE(record_high_temperatures_for_date('2021-06-27'::DATE))
    ORDER BY city_name;

-- Example 3240
CREATE OR REPLACE table dates_of_interest (event_date DATE);
INSERT INTO dates_of_interest (event_date) VALUES
    ('2021-06-21'::DATE),
    ('2022-06-21'::DATE);

CREATE OR REPLACE FUNCTION record_high_temperatures_for_date(d DATE)
    RETURNS TABLE (event_date DATE, city VARCHAR, temperature NUMBER)
    as
    $$
    SELECT d, 'New York', 65.0
    UNION ALL
    SELECT d, 'Los Angeles', 69.0
    $$;

-- Example 3241
SELECT
        doi.event_date as "Date", 
        record_temperatures.city,
        record_temperatures.temperature
    FROM dates_of_interest AS doi,
         TABLE(record_high_temperatures_for_date(doi.event_date)) AS record_temperatures
      ORDER BY doi.event_date, city;
+------------+-------------+-------------+
| Date       | CITY        | TEMPERATURE |
|------------+-------------+-------------|
| 2021-06-21 | Los Angeles |          69 |
| 2021-06-21 | New York    |          65 |
| 2022-06-21 | Los Angeles |          69 |
| 2022-06-21 | New York    |          65 |
+------------+-------------+-------------+

-- Example 3242
SELECT ...
  FROM [ <input_table> [ [AS] <alias_1> ] ,
         [ LATERAL ]
       ]
       TABLE( <table_function>( [ <arg_1> [, ... ] ] ) ) [ [ AS ] <alias_2> ];

-- Example 3243
ABS( <num_expr> )

-- Example 3244
SELECT column1, abs(column1)
    FROM (values (0), (1), (-2), (3.5), (-4.5), (null));
+---------+--------------+
| COLUMN1 | ABS(COLUMN1) |
|---------+--------------|
|     0.0 |          0.0 |
|     1.0 |          1.0 |
|    -2.0 |          2.0 |
|     3.5 |          3.5 |
|    -4.5 |          4.5 |
|    NULL |         NULL |
+---------+--------------+

-- Example 3245
ACOS( <real_expr> )

-- Example 3246
SELECT ACOS(0), ACOS(0.5), ACOS(1);
+-------------+-------------+---------+
|     ACOS(0) |   ACOS(0.5) | ACOS(1) |
|-------------+-------------+---------|
| 1.570796327 | 1.047197551 |       0 |
+-------------+-------------+---------+

-- Example 3247
ACOSH( <real_expr> )

-- Example 3248
SELECT ACOSH(2.352409615);
+--------------------+
| ACOSH(2.352409615) |
|--------------------|
|                1.5 |
+--------------------+

-- Example 3249
ADD_MONTHS( <date_or_timestamp_expr> , <num_months_expr> )

-- Example 3250
SELECT ADD_MONTHS('2016-05-15'::timestamp_ntz, 2) AS RESULT;
+-------------------------+
| RESULT                  |
|-------------------------|
| 2016-07-15 00:00:00.000 |
+-------------------------+

-- Example 3251
SELECT ADD_MONTHS('2016-02-29'::date, 1) AS RESULT;
+------------+
| RESULT     |
|------------|
| 2016-03-31 |
+------------+

-- Example 3252
SELECT ADD_MONTHS('2016-05-31'::date, -1) AS RESULT;
+------------+
| RESULT     |
|------------|
| 2016-04-30 |
+------------+

-- Example 3253
ALERT_HISTORY(
      [ SCHEDULED_TIME_RANGE_START => <constant_expr> ]
      [, SCHEDULED_TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <integer> ]
      [, ALERT_NAME => '<string>' ] )

-- Example 3254
SELECT table_name, comment FROM testdb.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' ... ;

SELECT event_timestamp, user_name FROM TABLE(testdb.INFORMATION_SCHEMA.LOGIN_HISTORY( ... ));

-- Example 3255
USE DATABASE testdb;

SELECT table_name, comment FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PUBLIC' ... ;

SELECT event_timestamp, user_name FROM TABLE(INFORMATION_SCHEMA.LOGIN_HISTORY( ... ));

-- Example 3256
USE SCHEMA testdb.INFORMATION_SCHEMA;

SELECT table_name, comment FROM TABLES WHERE TABLE_SCHEMA = 'PUBLIC' ... ;

SELECT event_timestamp, user_name FROM TABLE(LOGIN_HISTORY( ... ));

-- Example 3257
ALL_USER_NAMES()

-- Example 3258
select all_user_names();

+---------------------------+
| ALL_USER_NAMES()          |
+---------------------------+
| [ "user1", "user2", ... ] |
+---------------------------+

-- Example 3259
SNOWFLAKE.NOTIFICATION.APPLICATION_JSON( '<message>' )

-- Example 3260
SELECT SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{"data": "hello world"}');

-- Example 3261
'{"application/json":"{\"data\": \"hello world\"}"}'

-- Example 3262
ARRAY_APPEND( <array> , <new_element> )

-- Example 3263
CREATE OR REPLACE TABLE array_append_examples (array_column ARRAY);

INSERT INTO array_append_examples (array_column)
  SELECT ARRAY_CONSTRUCT(1, 2, 3);

SELECT * FROM array_append_examples;

-- Example 3264
+--------------+
| ARRAY_COLUMN |
|--------------|
| [            |
|   1,         |
|   2,         |
|   3          |
| ]            |
+--------------+

