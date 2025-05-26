-- More Extracted Snowflake SQL Examples

-- From snowflake_split_296.sql

EXECUTE IMMEDIATE $$
DECLARE
  id INTEGER;
  name VARCHAR;
BEGIN
  SELECT id, name INTO :id, :name FROM some_data WHERE id = 1;
  RETURN :id || ' ' || :name;
END;
$$;

DECLARE
  w INTEGER;
  x INTEGER DEFAULT 0;
  dt DATE;
  result_string VARCHAR;
BEGIN
  w := 1;
  w := 24 * 7;
  dt := '2020-09-30'::DATE;
  dt := '2020-09-30';
  result_string := w::VARCHAR || ', ' || dt::VARCHAR;
  RETURN result_string;
END;

CREATE OR REPLACE TABLE names (v VARCHAR);

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
    INSERT INTO names (v) VALUES (:PV_NAME);
  END;
  INSERT INTO names (v) VALUES (:PV_NAME);
  RETURN 'Completed.';
END;

CALL duplicate_name('parameter');

SELECT * FROM names ORDER BY v;

CREATE OR REPLACE TABLE t001 (a INTEGER, b VARCHAR);
INSERT INTO t001 (a, b) VALUES
  (1, 'row1'),
  (2, 'row2');

CREATE OR REPLACE PROCEDURE test_sp()
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
  DECLARE
    res RESULTSET DEFAULT (SELECT a FROM t001 ORDER BY a);
  BEGIN
    RETURN TABLE(res);
  END;

CALL test_sp();

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) ORDER BY 1;

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

CALL test_sp_dynamic('t001');

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

CALL test_sp_02();

CREATE OR REPLACE PROCEDURE test_sp_03()
RETURNS INTEGER
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
    RETURN accumulator;
  END;

CALL test_sp_03();

-- Control flow and exception handling examples

BEGIN
  LET count := 1;
  IF (count < 0) THEN
    RETURN 'negative value';
  ELSEIF (count = 0) THEN
    RETURN 'zero';
  ELSE
    RETURN 'positive value';
  END IF;
END;

DECLARE
  expression_to_evaluate VARCHAR DEFAULT 'default value';
BEGIN
  expression_to_evaluate := 'value a';
  CASE (expression_to_evaluate)
    WHEN 'value a' THEN
      RETURN 'x';
    WHEN 'value b' THEN
      RETURN 'y';
    WHEN 'value c' THEN
      RETURN 'z';
    WHEN 'default value' THEN
      RETURN 'default';
    ELSE
      RETURN 'other';
  END;
END;

DECLARE
  a VARCHAR DEFAULT 'x';
  b VARCHAR DEFAULT 'y';
  c VARCHAR DEFAULT 'z';
BEGIN
  CASE
    WHEN a = 'x' THEN
      RETURN 'a is x';
    WHEN b = 'y' THEN
      RETURN 'b is y';
    WHEN c = 'z' THEN
      RETURN 'c is z';
    ELSE
      RETURN 'a is not x, b is not y, and c is not z';
  END;
END;

DECLARE
  RESULT VARCHAR;
  EXCEPTION_1 EXCEPTION (-20001, 'I caught the expected exception.');
  EXCEPTION_2 EXCEPTION (-20002, 'Not the expected exception!');
BEGIN
  RESULT := 'If you see this, I did not catch any exception.';
  IF (TRUE) THEN
    RAISE EXCEPTION_1;
  END IF;
  RETURN RESULT;
EXCEPTION
  WHEN EXCEPTION_2 THEN
    RETURN SQLERRM;
  WHEN EXCEPTION_1 THEN
    RETURN SQLERRM;
END;

DECLARE
  e1 EXCEPTION (-20001, 'Exception e1');
BEGIN
  DECLARE
    e2 EXCEPTION (-20002, 'Exception e2');
    selector BOOLEAN DEFAULT TRUE;
  BEGIN
    IF (selector) THEN
      RAISE e1;
    ELSE
      RAISE e2;
    END IF;
  END;
EXCEPTION
  WHEN e1 THEN
    RETURN SQLERRM || ' caught in outer block.';
END;

DECLARE
  RESULT VARCHAR;
  e1 EXCEPTION (-20001, 'Outer exception e1');
BEGIN
  RESULT := 'No error so far (but there will be).';
  DECLARE
    e1 EXCEPTION (-20101, 'Inner exception e1');
  BEGIN
    RAISE e1;
  EXCEPTION
    WHEN e1 THEN
      RESULT := 'Inner exception raised.';
      RETURN RESULT;
  END;
  RETURN RESULT;
EXCEPTION
  WHEN e1 THEN
    RESULT := 'Outer exception raised.';
    RETURN RESULT;
END;

DECLARE
  MY_EXCEPTION EXCEPTION (-20001, 'Sample message');
BEGIN
  RAISE MY_EXCEPTION;
EXCEPTION
  WHEN STATEMENT_ERROR THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'STATEMENT_ERROR',
                            'SQLCODE', SQLCODE,
                            'SQLERRM', SQLERRM,
                            'SQLSTATE', SQLSTATE);
  WHEN EXPRESSION_ERROR THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'EXPRESSION_ERROR',
                            'SQLCODE', SQLCODE,
                            'SQLERRM', SQLERRM,
                            'SQLSTATE', SQLSTATE);
  WHEN OTHER THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'Other error',
                            'SQLCODE', SQLCODE,
                            'SQLERRM', SQLERRM,
                            'SQLSTATE', SQLSTATE);
END; 