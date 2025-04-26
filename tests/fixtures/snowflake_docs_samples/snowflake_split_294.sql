-- Example 19676
{
  SHOW SNOWFLAKE.ML.TOP_INSIGHTS           |
  SHOW SNOWFLAKE.ML.TOP_INSIGHTS INSTANCES
}
  [ LIKE <pattern> ]
  [ IN
      {
        ACCOUNT                  |

        DATABASE                 |
        DATABASE <database_name> |

        SCHEMA                   |
        SCHEMA <schema_name>     |
        <schema_name>
      }
   ]

-- Example 19677
<model_name>!GET_DRIVERS(
  INPUT_DATA => <input_data>,
  LABEL_COLNAME => '<label_colname>',
  METRIC_COLNAME => '<metric_colname>'
);

-- Example 19678
SELECT CURRENT_DATABASE();

--------------------+
 CURRENT_DATABASE() |
--------------------+
 TESTDB             |
--------------------+

CREATE DATABASE db1;

------------------------------------+
               status               |
------------------------------------+
 Database DB1 successfully created. |
------------------------------------+

SELECT CURRENT_DATABASE();

--------------------+
 CURRENT_DATABASE() |
--------------------+
 DB1                |
--------------------+

USE DATABASE testdb;

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SELECT current_database();

--------------------+
 CURRENT_DATABASE() |
--------------------+
 TESTDB             |
--------------------+

-- Example 19679
SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 TESTSCHEMA       |
------------------+

CREATE DATABASE db1;

------------------------------------+
               status               |
------------------------------------+
 Database DB1 successfully created. |
------------------------------------+

SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 PUBLIC           |
------------------+

CREATE SCHEMA sch1;

-----------------------------------+
              status               |
-----------------------------------+
 Schema SCH1 successfully created. |
-----------------------------------+

SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 SCH1             |
------------------+

USE SCHEMA public;

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SELECT current_schema();

------------------+
 CURRENT_SCHEMA() |
------------------+
 PUBLIC           |
------------------+

-- Example 19680
select current_schemas();

+-------------------+
| CURRENT_SCHEMAS() |
|-------------------|
| []                |
+-------------------+

use database mytestdb;

select current_schemas();

+---------------------+
| CURRENT_SCHEMAS()   |
|---------------------|
| ["MYTESTDB.PUBLIC"] |
+---------------------+

create schema private;

select current_schemas();

+-----------------------------------------+
| CURRENT_SCHEMAS()                       |
|-----------------------------------------|
| ["MYTESTDB.PRIVATE", "MYTESTDB.PUBLIC"] |
+-----------------------------------------+

-- Example 19681
SHOW PARAMETERS LIKE 'search_path';

-------------+--------------------+--------------------+------------------------------------------------+
     key     |           value    |          default   |                  description                   |
-------------+--------------------+--------------------+------------------------------------------------+
 SEARCH_PATH | $current, $public, | $current, $public, | Search path for unqualified object references. |
-------------+--------------------+--------------------+------------------------------------------------+

SELECT current_schemas();

---------------------------------------------------------------------------+
                       CURRENT_SCHEMAS()                                   |
---------------------------------------------------------------------------+
 [XY12345.TESTDB.TESTSCHEMA, XY12345.TESTDB.PUBLIC, SAMPLES.COMMON.PUBLIC] |
---------------------------------------------------------------------------+

CREATE DATABASE db1;

------------------------------------+
               status               |
------------------------------------+
 Database DB1 successfully created. |
------------------------------------+

USE SCHEMA public;

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SELECT current_schemas();

---------------------------------------------+
                CURRENT_SCHEMAS()            |
---------------------------------------------+
 [XY12345.DB1.PUBLIC, SAMPLES.COMMON.PUBLIC] |
---------------------------------------------+

ALTER SESSION SET search_path='$current, $public, testdb.public';

----------------------------------+
              status              |
----------------------------------+
 Statement executed successfully. |
----------------------------------+

SHOW PARAMETERS LIKE 'search_path';

-------------+----------------------------------+--------------------+------------------------------------------------+
     key     |              value               |          default   |                  description                   |
-------------+----------------------------------+--------------------+------------------------------------------------+
 SEARCH_PATH | $current, $public, testdb.public | $current, $public, | Search path for unqualified object references. |
-------------+----------------------------------+--------------------+------------------------------------------------+

SELECT current_schemas();

---------------------------------------------+
            CURRENT_SCHEMAS()                |
---------------------------------------------+
 [XY12345.DB1.PUBLIC, XY12345.TESTDB.PUBLIC] |
---------------------------------------------+

-- Example 19682
DECLARE
  my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION.');

-- Example 19683
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

-- Example 19684
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

-- Example 19685
-20002 (P0001): Uncaught exception of type 'MY_EXCEPTION' on line 8 at position 4 : Raised MY_EXCEPTION.

-- Example 19686
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

-- Example 19687
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

-- Example 19688
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

-- Example 19689
-20002 (P0001): Uncaught exception of type 'MY_EXCEPTION' on line 8 at position 4 : Raised MY_EXCEPTION.

-- Example 19690
BEGIN
  SELECT * FROM non_existent_table;
EXCEPTION
  WHEN OTHER THEN
    LET LINE := SQLCODE || ': ' || SQLERRM;
    INSERT INTO myexceptions VALUES (:line);
    RAISE; -- Raise the same exception that you are handling.
END;

-- Example 19691
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

-- Example 19692
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

-- Example 19693
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

-- Example 19694
+---------------------------------------------------------+
| anonymous block                                         |
|---------------------------------------------------------|
| Error -20002: Counter value 11 exceeds the limit of 10. |
+---------------------------------------------------------+

-- Example 19695
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

-- Example 19696
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

-- Example 19697
CALL exception_test_vars(7);

-- Example 19698
+------------------------------+
| EXCEPTION_TEST_VARS          |
|------------------------------|
| Order inserted successfully. |
+------------------------------+

-- Example 19699
CALL exception_test_vars(-3);

-- Example 19700
+-----------------------------------------------------------------------+
| EXCEPTION_TEST_VARS                                                   |
|-----------------------------------------------------------------------|
| Error -20002: Submitted amount -3 is too low (1 or greater required). |
+-----------------------------------------------------------------------+

-- Example 19701
CALL exception_test_vars(20);

-- Example 19702
+----------------------------------------------------------------------+
| EXCEPTION_TEST_VARS                                                  |
|----------------------------------------------------------------------|
| Error -20003: Submitted amount 20 is too high (exceeds limit of 10). |
+----------------------------------------------------------------------+

-- Example 19703
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

-- Example 19704
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

-- Example 19705
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

-- Example 19706
CALL test_sp_async_child_jobs_query();

-- Example 19707
+--------------------------------+
| TEST_SP_ASYNC_CHILD_JOBS_QUERY |
|--------------------------------|
|                           4570 |
+--------------------------------+

-- Example 19708
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

-- Example 19709
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

-- Example 19710
CALL test_sp_async_child_jobs_insert(1, 325, 2, 241);

-- Example 19711
+----------+--------------+
| ORDER_ID | ORDER_AMOUNT |
|----------+--------------|
|        1 |       325.00 |
|        2 |       241.00 |
+----------+--------------+

-- Example 19712
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

-- Example 19713
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

-- Example 19714
CREATE OR REPLACE TABLE test_child_job_queries2 (id INT, cola INT);

INSERT INTO test_child_job_queries2 VALUES
  (1, 100), (2, 101), (3, 102);

-- Example 19715
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

-- Example 19716
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

-- Example 19717
CREATE OR REPLACE PROCEDURE test_async_child_job_calls()
RETURNS VARCHAR
LANGUAGE SQL
AS
BEGIN
  ASYNC (CALL test_async_child_job_inserts());
  ASYNC (CALL test_async_child_job_updates());
  AWAIT ALL;
END;

-- Example 19718
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

-- Example 19719
CALL test_async_child_job_calls();

-- Example 19720
SELECT col1 FROM test_child_job_queries1 ORDER BY col1;

-- Example 19721
+------+
| COL1 |
|------|
|    1 |
|    2 |
|    3 |
+------+

-- Example 19722
SELECT * FROM test_child_job_queries2 ORDER BY id;

-- Example 19723
+----+------+
| ID | COLA |
|----+------|
|  1 |  200 |
|  2 |  201 |
|  3 |  202 |
+----+------+

-- Example 19724
CREATE OR REPLACE TABLE async_loop_test1(col1 VARCHAR, col2 INT);

INSERT INTO async_loop_test1 VALUES
  ('child', 0),
  ('job', 1),
  ('loop', 2),
  ('test', 3);

CREATE OR REPLACE TABLE async_loop_test2(col1 INT, col2 VARCHAR);

-- Example 19725
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

-- Example 19726
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

-- Example 19727
CALL async_insert();

-- Example 19728
+--------------+
| ASYNC_INSERT |
|--------------|
| Success      |
+--------------+

-- Example 19729
SELECT * FROM async_loop_test2 ORDER BY col1;

-- Example 19730
+------+-------------+
| COL1 | COL2        |
|------+-------------|
|    0 | async_child |
|    1 | async_job   |
|    2 | async_loop  |
|    3 | async_test  |
+------+-------------+

-- Example 19731
FOR <counter_variable> IN [ REVERSE ] <start> TO <end> { DO | LOOP }
  <statement>;
  [ <statement>; ... ]
END { FOR | LOOP } [ <label> ] ;

-- Example 19732
DECLARE
  counter INTEGER DEFAULT 0;
  maximum_count INTEGER default 5;
BEGIN
  FOR i IN 1 TO maximum_count DO
    counter := counter + 1;
  END FOR;
  RETURN counter;
END;

-- Example 19733
EXECUTE IMMEDIATE $$
DECLARE
  counter INTEGER DEFAULT 0;
  maximum_count INTEGER default 5;
BEGIN
  FOR i IN 1 TO maximum_count DO
    counter := counter + 1;
  END FOR;
  RETURN counter;
END;
$$
;

-- Example 19734
+-----------------+
| anonymous block |
|-----------------|
|               5 |
+-----------------+

-- Example 19735
FOR <row_variable> IN <cursor_name> DO
  <statement>;
  [ <statement>; ... ]
END FOR [ <label> ] ;

-- Example 19736
CREATE OR REPLACE TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
  (11.11),
  (22.22);

-- Example 19737
DECLARE
  total_price FLOAT;
  c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
  total_price := 0.0;
  FOR record IN c1 DO
    total_price := total_price + record.price;
  END FOR;
  RETURN total_price;
END;

-- Example 19738
EXECUTE IMMEDIATE $$
DECLARE
  total_price FLOAT;
  c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
  total_price := 0.0;
  FOR record IN c1 DO
    total_price := total_price + record.price;
  END FOR;
  RETURN total_price;
END;
$$
;

-- Example 19739
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 19740
FOR <row_variable> IN <RESULTSET_name> DO
  <statement>;
  [ <statement>; ... ]
END FOR [ <label> ] ;

-- Example 19741
CREATE OR REPLACE TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
  (11.11),
  (22.22);

-- Example 19742
DECLARE
  total_price FLOAT;
  rs RESULTSET;
BEGIN
  total_price := 0.0;
  rs := (SELECT price FROM invoices);
  FOR record IN rs DO
    total_price := total_price + record.price;
  END FOR;
  RETURN total_price;
END;

