-- Example 3129
BEGIN
  ...
  LET res RESULTSET := (SELECT col1 FROM mytable ORDER BY col1);

-- Example 3130
<resultset_name> := [ ASYNC ] ( <query> ) ;

-- Example 3131
DECLARE
  res RESULTSET;
BEGIN
  res := (SELECT col1 FROM mytable ORDER BY col1);
  ...

-- Example 3132
DECLARE
  res RESULTSET;
BEGIN
  res := ASYNC (SELECT col1 FROM mytable ORDER BY col1);
  ...

-- Example 3133
DECLARE
  res RESULTSET;
  col_name VARCHAR;
  select_statement VARCHAR;
BEGIN
  col_name := 'col1';
  select_statement := 'SELECT ' || col_name || ' FROM mytable';
  res := (EXECUTE IMMEDIATE :select_statement);
  RETURN TABLE(res);
END;

-- Example 3134
DECLARE
  ...
  res RESULTSET DEFAULT (SELECT col1 FROM mytable ORDER BY col1);
  c1 CURSOR FOR res;

-- Example 3135
CREATE PROCEDURE f()
  RETURNS TABLE(column_1 INTEGER, column_2 VARCHAR)
  ...
    RETURN TABLE(my_resultset_1);
  ...

-- Example 3136
SELECT * FROM my_result_set;

-- Example 3137
CREATE OR REPLACE TABLE t001 (a INTEGER, b VARCHAR);
INSERT INTO t001 (a, b) VALUES
  (1, 'row1'),
  (2, 'row2');

-- Example 3138
CREATE OR REPLACE PROCEDURE test_sp()
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
  DECLARE
    res RESULTSET DEFAULT (SELECT a FROM t001 ORDER BY a);
  BEGIN
    RETURN TABLE(res);
  END;

-- Example 3139
CREATE OR REPLACE PROCEDURE test_sp()
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
$$
  DECLARE
      res RESULTSET default (SELECT a FROM t001 ORDER BY a);
  BEGIN
      RETURN TABLE(res);
  END;
$$;

-- Example 3140
CALL test_sp();

-- Example 3141
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 3142
SELECT *
  FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  ORDER BY 1;

-- Example 3143
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 3144
CREATE OR REPLACE PROCEDURE test_sp_dynamic(table_name VARCHAR)
  RETURNS TABLE(a INTEGER)
  LANGUAGE SQL
AS
DECLARE
  res RESULTSET;
  query VARCHAR DEFAULT 'SELECT a FROM IDENTIFIER(?) ORDER BY a;';
BEGIN
  res := (EXECUTE IMMEDIATE :query USING(table_name));
  RETURN TABLE(res);
END;

-- Example 3145
CREATE OR REPLACE PROCEDURE test_sp_dynamic(table_name VARCHAR)
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
$$
  DECLARE
    res RESULTSET;
    query VARCHAR DEFAULT 'SELECT a FROM IDENTIFIER(?) ORDER BY a;';
  BEGIN
    res := (EXECUTE IMMEDIATE :query USING(table_name));
    RETURN TABLE(res);
  END
$$
;

-- Example 3146
CALL test_sp_dynamic('t001');

-- Example 3147
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 3148
CREATE OR REPLACE PROCEDURE test_sp_02()
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
  DECLARE
    res RESULTSET;
  BEGIN
    res := (SELECT a FROM t001 ORDER BY a);
    RETURN TABLE(res);
  END;

-- Example 3149
CREATE OR REPLACE PROCEDURE test_sp_02()
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
$$
  DECLARE
      res RESULTSET;
  BEGIN
      res := (SELECT a FROM t001 ORDER BY a);
      RETURN TABLE(res);
  END;
$$;

-- Example 3150
CALL test_sp_02();

-- Example 3151
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 3152
CREATE OR REPLACE PROCEDURE test_sp_03()
RETURNS VARCHAR
LANGUAGE SQL
AS

DECLARE
  accumulator INTEGER DEFAULT 0;
  res1 RESULTSET DEFAULT (SELECT a FROM t001 ORDER BY a);
  cur1 CURSOR FOR res1;
BEGIN
  FOR row_variable IN cur1 DO
    accumulator := accumulator + row_variable.a;
  END FOR;
  RETURN accumulator::VARCHAR;
END;

-- Example 3153
CREATE OR REPLACE PROCEDURE test_sp_03()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  DECLARE
    accumulator INTEGER DEFAULT 0;
    res1 RESULTSET DEFAULT (SELECT a FROM t001 ORDER BY a);
    cur1 CURSOR FOR res1;
  BEGIN
    FOR row_variable IN cur1 DO
        accumulator := accumulator + row_variable.a;
    END FOR;
    RETURN accumulator;
  END;
$$;

-- Example 3154
CALL test_sp_03();

-- Example 3155
+------------+
| TEST_SP_03 |
|------------|
| 3          |
+------------+

-- Example 3156
CREATE OR REPLACE TABLE orders_q1_2024 (
  order_id INT,
  order_amount NUMBER(12,2));

INSERT INTO orders_q1_2024 VALUES (1, 500.00);
INSERT INTO orders_q1_2024 VALUES (2, 225.00);
INSERT INTO orders_q1_2024 VALUES (3, 725.00);
INSERT INTO orders_q1_2024 VALUES (4, 150.00);
INSERT INTO orders_q1_2024 VALUES (5, 900.00);

CREATE OR REPLACE TABLE orders_q2_2024 (
  order_id INT,
  order_amount NUMBER(12,2));

INSERT INTO orders_q2_2024 VALUES (1, 100.00);
INSERT INTO orders_q2_2024 VALUES (2, 645.00);
INSERT INTO orders_q2_2024 VALUES (3, 275.00);
INSERT INTO orders_q2_2024 VALUES (4, 800.00);
INSERT INTO orders_q2_2024 VALUES (5, 250.00);

-- Example 3157
CREATE OR REPLACE PROCEDURE test_sp_async_child_jobs_query()
RETURNS INTEGER
LANGUAGE SQL
AS
DECLARE
  accumulator1 INTEGER DEFAULT 0;
  accumulator2 INTEGER DEFAULT 0;
  res1 RESULTSET DEFAULT ASYNC (SELECT order_amount FROM orders_q1_2024);
  res2 RESULTSET DEFAULT ASYNC (SELECT order_amount FROM orders_q2_2024);
BEGIN
  AWAIT res1;
  LET cur1 CURSOR FOR res1;
  OPEN cur1;
  AWAIT res2;
  LET cur2 CURSOR FOR res2;
  OPEN cur2;
  FOR row_variable IN cur1 DO
      accumulator1 := accumulator1 + row_variable.order_amount;
  END FOR;
  FOR row_variable IN cur2 DO
      accumulator2 := accumulator2 + row_variable.order_amount;
  END FOR;
  RETURN accumulator1 + accumulator2;
END;

-- Example 3158
CREATE OR REPLACE PROCEDURE test_sp_async_child_jobs_query()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  DECLARE
    accumulator1 INTEGER DEFAULT 0;
    accumulator2 INTEGER DEFAULT 0;
    res1 RESULTSET DEFAULT ASYNC (SELECT order_amount FROM orders_q1_2024);
    res2 RESULTSET DEFAULT ASYNC (SELECT order_amount FROM orders_q2_2024);
  BEGIN
    AWAIT res1;
    LET cur1 CURSOR FOR res1;
    OPEN cur1;
    AWAIT res2;
    LET cur2 CURSOR FOR res2;
    OPEN cur2;
    FOR row_variable IN cur1 DO
        accumulator1 := accumulator1 + row_variable.order_amount;
    END FOR;
    FOR row_variable IN cur2 DO
        accumulator2 := accumulator2 + row_variable.order_amount;
    END FOR;
    RETURN accumulator1 + accumulator2;
  END;
$$;

-- Example 3159
CALL test_sp_async_child_jobs_query();

-- Example 3160
+--------------------------------+
| TEST_SP_ASYNC_CHILD_JOBS_QUERY |
|--------------------------------|
|                           4570 |
+--------------------------------+

-- Example 3161
CREATE OR REPLACE PROCEDURE test_sp_async_child_jobs_insert(
  arg1 INT,
  arg2 NUMBER(12,2),
  arg3 INT,
  arg4 NUMBER(12,2))
RETURNS TABLE()
LANGUAGE SQL
AS
  BEGIN
   CREATE TABLE IF NOT EXISTS orders_q3_2024 (
      order_id INT,
      order_amount NUMBER(12,2));
    LET insert_1 RESULTSET := ASYNC (INSERT INTO orders_q3_2024 SELECT :arg1, :arg2);
    LET insert_2 RESULTSET := ASYNC (INSERT INTO orders_q3_2024 SELECT :arg3, :arg4);
    AWAIT insert_1;
    AWAIT insert_2;
    LET res RESULTSET := (SELECT * FROM orders_q3_2024 ORDER BY order_id);
    RETURN TABLE(res);
  END;

-- Example 3162
CREATE OR REPLACE PROCEDURE test_sp_async_child_jobs_insert(
  arg1 INT,
  arg2 NUMBER(12,2),
  arg3 INT,
  arg4 NUMBER(12,2))
RETURNS TABLE()
LANGUAGE SQL
AS
$$
  BEGIN
   CREATE TABLE IF NOT EXISTS orders_q3_2024 (
      order_id INT,
      order_amount NUMBER(12,2));
    LET insert_1 RESULTSET := ASYNC (INSERT INTO orders_q3_2024 SELECT :arg1, :arg2);
    LET insert_2 RESULTSET := ASYNC (INSERT INTO orders_q3_2024 SELECT :arg3, :arg4);
    AWAIT insert_1;
    AWAIT insert_2;
    LET res RESULTSET := (SELECT * FROM orders_q3_2024 ORDER BY order_id);
    RETURN TABLE(res);
  END;
$$;

-- Example 3163
CALL test_sp_async_child_jobs_insert(1, 325, 2, 241);

-- Example 3164
+----------+--------------+
| ORDER_ID | ORDER_AMOUNT |
|----------+--------------|
|        1 |       325.00 |
|        2 |       241.00 |
+----------+--------------+

-- Example 3165
CREATE OR REPLACE PROCEDURE test_async_child_job_inserts()
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
  CREATE OR REPLACE TABLE test_child_job_queries1 (col1 INT);
  ASYNC (INSERT INTO test_child_job_queries1(col1) VALUES(1));
  ASYNC (INSERT INTO test_child_job_queries1(col1) VALUES(2));
  ASYNC (INSERT INTO test_child_job_queries1(col1) VALUES(3));
  AWAIT ALL;
END;

-- Example 3166
CREATE OR REPLACE PROCEDURE test_async_child_job_inserts()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  CREATE OR REPLACE TABLE test_child_job_queries1 (col1 INT);
  ASYNC (INSERT INTO test_child_job_queries1(col1) VALUES(1));
  ASYNC (INSERT INTO test_child_job_queries1(col1) VALUES(2));
  ASYNC (INSERT INTO test_child_job_queries1(col1) VALUES(3));
  AWAIT ALL;
END;
$$
;

-- Example 3167
CREATE OR REPLACE TABLE test_child_job_queries2 (id INT, cola INT);

INSERT INTO test_child_job_queries2 VALUES
  (1, 100), (2, 101), (3, 102);

-- Example 3168
CREATE OR REPLACE PROCEDURE test_async_child_job_updates()
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
  ASYNC (UPDATE test_child_job_queries2 SET cola=200 WHERE id=1);
  ASYNC (UPDATE test_child_job_queries2 SET cola=201 WHERE id=2);
  ASYNC (UPDATE test_child_job_queries2 SET cola=202 WHERE id=3);
  AWAIT ALL;
END;

-- Example 3169
CREATE OR REPLACE PROCEDURE test_async_child_job_updates()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  ASYNC (UPDATE test_child_job_queries2 SET cola=200 WHERE id=1);
  ASYNC (UPDATE test_child_job_queries2 SET cola=201 WHERE id=2);
  ASYNC (UPDATE test_child_job_queries2 SET cola=202 WHERE id=3);
  AWAIT ALL;
END;
$$
;

-- Example 3170
CREATE OR REPLACE PROCEDURE test_async_child_job_calls()
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
  ASYNC (CALL test_async_child_job_inserts());
  ASYNC (CALL test_async_child_job_updates());
  AWAIT ALL;
END;

-- Example 3171
CREATE OR REPLACE PROCEDURE test_async_child_job_calls()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  ASYNC (CALL test_async_child_job_inserts());
  ASYNC (CALL test_async_child_job_updates());
  AWAIT ALL;
END;
$$
;

-- Example 3172
CALL test_async_child_job_calls();

-- Example 3173
SELECT col1 FROM test_child_job_queries1 ORDER BY col1;

-- Example 3174
+------+
| COL1 |
|------|
|    1 |
|    2 |
|    3 |
+------+

-- Example 3175
SELECT * FROM test_child_job_queries2 ORDER BY id;

-- Example 3176
+----+------+
| ID | COLA |
|----+------|
|  1 |  200 |
|  2 |  201 |
|  3 |  202 |
+----+------+

-- Example 3177
CREATE OR REPLACE TABLE async_loop_test1(col1 VARCHAR, col2 INT);

INSERT INTO async_loop_test1 VALUES
  ('child', 0),
  ('job', 1),
  ('loop', 2),
  ('test', 3);

CREATE OR REPLACE TABLE async_loop_test2(col1 INT, col2 VARCHAR);

-- Example 3178
CREATE OR REPLACE PROCEDURE async_insert()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
begin
  LET res RESULTSET := (SELECT * FROM async_loop_test1 ORDER BY 1);

  FOR record IN res DO
    LET v VARCHAR := record.col1;
    LET x INT := record.col2;
      ASYNC (INSERT INTO async_loop_test2(col1, col2) VALUES (:x, (SELECT 'async_' || :v)));
    END FOR;

    AWAIT ALL;
    RETURN 'Success';
END;

-- Example 3179
CREATE OR REPLACE PROCEDURE async_insert()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
begin
  LET res RESULTSET := (SELECT * FROM async_loop_test1 ORDER BY 1);

  FOR record IN res DO
    LET v VARCHAR := record.col1;
    LET x INT := record.col2;
      ASYNC (INSERT INTO async_loop_test2(col1, col2) VALUES (:x, (SELECT 'async_' || :v)));
    END FOR;

    AWAIT ALL;
    RETURN 'Success';
END;
$$;

-- Example 3180
CALL async_insert();

-- Example 3181
+--------------+
| ASYNC_INSERT |
|--------------|
| Success      |
+--------------+

-- Example 3182
SELECT * FROM async_loop_test2 ORDER BY col1;

-- Example 3183
+------+-------------+
| COL1 | COL2        |
|------+-------------|
|    0 | async_child |
|    1 | async_job   |
|    2 | async_loop  |
|    3 | async_test  |
+------+-------------+

-- Example 3184
DECLARE
  my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION.');

-- Example 3185
DECLARE
  my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION.');
BEGIN
  LET counter := 0;
  LET should_raise_exception := true;
  IF (should_raise_exception) THEN
    RAISE my_exception;
  END IF;
  counter := counter + 1;
  RETURN counter;
END;

-- Example 3186
EXECUTE IMMEDIATE $$
DECLARE
  my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION.');
BEGIN
  LET counter := 0;
  LET should_raise_exception := true;
  IF (should_raise_exception) THEN
    RAISE my_exception;
  END IF;
  counter := counter + 1;
  RETURN counter;
END;
$$
;

-- Example 3187
-20002 (P0001): Uncaught exception of type 'MY_EXCEPTION' on line 8 at position 4 : Raised MY_EXCEPTION.

-- Example 3188
DECLARE
  my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION.');
BEGIN
  LET counter := 0;
  LET should_raise_exception := true;
  IF (should_raise_exception) THEN
    RAISE my_exception;
  END IF;
  counter := counter + 1;
  RETURN counter;
EXCEPTION
  WHEN statement_error THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
  WHEN my_exception THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'MY_EXCEPTION',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
  WHEN OTHER THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'Other error',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
  END;

-- Example 3189
EXECUTE IMMEDIATE $$
DECLARE
  my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION.');
BEGIN
  LET counter := 0;
  LET should_raise_exception := true;
  IF (should_raise_exception) THEN
    RAISE my_exception;
  END IF;
  counter := counter + 1;
  RETURN counter;
EXCEPTION
  WHEN statement_error THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
  WHEN my_exception THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'MY_EXCEPTION',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
  WHEN OTHER THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'Other error',
                            'SQLCODE', sqlcode,
                            'SQLERRM', sqlerrm,
                            'SQLSTATE', sqlstate);
END;
$$
;

-- Example 3190
+--------------------------------------+
| anonymous block                      |
|--------------------------------------|
| {                                    |
|   "Error type": "MY_EXCEPTION",      |
|   "SQLCODE": -20002,                 |
|   "SQLERRM": "Raised MY_EXCEPTION.", |
|   "SQLSTATE": "P0001"                |
| }                                    |
+--------------------------------------+

-- Example 3191
-20002 (P0001): Uncaught exception of type 'MY_EXCEPTION' on line 8 at position 4 : Raised MY_EXCEPTION.

-- Example 3192
BEGIN
  SELECT * FROM non_existent_table;
EXCEPTION
  WHEN OTHER THEN
    LET LINE := SQLCODE || ': ' || SQLERRM;
    INSERT INTO myexceptions VALUES (:line);
    RAISE; -- Raise the same exception that you are handling.
END;

-- Example 3193
EXECUTE IMMEDIATE $$
BEGIN
  SELECT * FROM non_existent_table;
EXCEPTION
  WHEN OTHER THEN
    LET LINE := SQLCODE || ': ' || SQLERRM;
    INSERT INTO myexceptions VALUES (:line);
    RAISE; -- Raise the same exception that you are handling.
END;
$$;

-- Example 3194
DECLARE
  counter_val INTEGER DEFAULT 0;
  my_exception EXCEPTION (-20002, 'My exception text');
BEGIN
  WHILE (counter_val < 12) DO
    counter_val := counter_val + 1;
    IF (counter_val > 10) THEN
      RAISE my_exception;
    END IF;
  END WHILE;
  RETURN counter_val;
EXCEPTION
  WHEN my_exception THEN
    RETURN 'Error ' || sqlcode || ': Counter value ' || counter_val || ' exceeds the limit of 10.';
END;

-- Example 3195
EXECUTE IMMEDIATE $$
DECLARE
  counter_val INTEGER DEFAULT 0;
  my_exception EXCEPTION (-20002, 'My exception text');
BEGIN
  WHILE (counter_val < 12) DO
    counter_val := counter_val + 1;
    IF (counter_val > 10) THEN
      RAISE my_exception;
    END IF;
  END WHILE;
  RETURN counter_val;
EXCEPTION
  WHEN my_exception THEN
    RETURN 'Error ' || sqlcode || ': Counter value ' || counter_val || ' exceeds the limit of 10.';
END;
$$
;

-- Example 3196
+---------------------------------------------------------+
| anonymous block                                         |
|---------------------------------------------------------|
| Error -20002: Counter value 11 exceeds the limit of 10. |
+---------------------------------------------------------+

