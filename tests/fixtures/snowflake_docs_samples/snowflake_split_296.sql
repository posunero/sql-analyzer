-- Example 19810
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

-- Example 19811
+-----------------+
| anonymous block |
|-----------------|
| 1 a             |
+-----------------+

-- Example 19812
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

-- Example 19813
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

-- Example 19814
+-----------------+
| anonymous block |
|-----------------|
| 168, 2020-09-30 |
+-----------------+

-- Example 19815
my_variable := SQRT(variable_x);

-- Example 19816
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;

-- Example 19817
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

-- Example 19818
+-----------------+
| anonymous block |
|-----------------|
|              10 |
+-----------------+

-- Example 19819
CREATE OR REPLACE TABLE names (v VARCHAR);

-- Example 19820
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

-- Example 19821
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

-- Example 19822
CALL duplicate_name('parameter');

-- Example 19823
SELECT *
    FROM names
    ORDER BY v;

-- Example 19824
+--------------------------+
| V                        |
|--------------------------|
| innermost block variable |
| middle block variable    |
| parameter                |
+--------------------------+

-- Example 19825
DECLARE
  ...
  res RESULTSET DEFAULT (SELECT col1 FROM mytable ORDER BY col1);

-- Example 19826
BEGIN
  ...
  LET res RESULTSET := (SELECT col1 FROM mytable ORDER BY col1);

-- Example 19827
<resultset_name> := [ ASYNC ] ( <query> ) ;

-- Example 19828
DECLARE
  res RESULTSET;
BEGIN
  res := (SELECT col1 FROM mytable ORDER BY col1);
  ...

-- Example 19829
DECLARE
  res RESULTSET;
BEGIN
  res := ASYNC (SELECT col1 FROM mytable ORDER BY col1);
  ...

-- Example 19830
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

-- Example 19831
DECLARE
  ...
  res RESULTSET DEFAULT (SELECT col1 FROM mytable ORDER BY col1);
  c1 CURSOR FOR res;

-- Example 19832
CREATE PROCEDURE f()
  RETURNS TABLE(column_1 INTEGER, column_2 VARCHAR)
  ...
    RETURN TABLE(my_resultset_1);
  ...

-- Example 19833
SELECT * FROM my_result_set;

-- Example 19834
CREATE OR REPLACE TABLE t001 (a INTEGER, b VARCHAR);
INSERT INTO t001 (a, b) VALUES
  (1, 'row1'),
  (2, 'row2');

-- Example 19835
CREATE OR REPLACE PROCEDURE test_sp()
RETURNS TABLE(a INTEGER)
LANGUAGE SQL
AS
  DECLARE
    res RESULTSET DEFAULT (SELECT a FROM t001 ORDER BY a);
  BEGIN
    RETURN TABLE(res);
  END;

-- Example 19836
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

-- Example 19837
CALL test_sp();

-- Example 19838
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 19839
SELECT *
  FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  ORDER BY 1;

-- Example 19840
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 19841
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

-- Example 19842
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

-- Example 19843
CALL test_sp_dynamic('t001');

-- Example 19844
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 19845
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

-- Example 19846
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

-- Example 19847
CALL test_sp_02();

-- Example 19848
+---+
| A |
|---|
| 1 |
| 2 |
+---+

-- Example 19849
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

-- Example 19850
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

-- Example 19851
CALL test_sp_03();

-- Example 19852
+------------+
| TEST_SP_03 |
|------------|
| 3          |
+------------+

-- Example 19853
IF (<condition>) THEN
   -- Statements to execute if the <condition> is true.

[ ELSEIF ( <condition_2> ) THEN
  -- Statements to execute if the <condition_2> is true.
]

[ ELSE
  -- Statements to execute if none of the conditions are true.
]

  END IF ;

-- Example 19854
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

-- Example 19855
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 19856
+-----------------+
| anonymous block |
|-----------------|
| positive value  |
+-----------------+

-- Example 19857
CASE ( <expression_to_match> )

    WHEN <value_1_of_expression> THEN
        <statement>;
        [ <statement>; ... ]

    [ WHEN <value_2_of_expression> THEN
        <statement>;
        [ <statement>; ... ]
    ]

    ... -- Additional WHEN clauses for other possible values;

    [ ELSE
        <statement>;
        [ <statement>; ... ]
    ]

END [ CASE ] ;

-- Example 19858
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

-- Example 19859
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 19860
+-----------------+
| anonymous block |
|-----------------|
| x               |
+-----------------+

-- Example 19861
CASE

  WHEN <condition_1> THEN
    <statement>;
    [ <statement>; ... ]

  [ WHEN <condition_2> THEN
    <statement>;
    [ <statement>; ... ]
  ]

  ... -- Additional WHEN clauses for other possible conditions;

  [ ELSE
    <statement>;
    [ <statement>; ... ]
  ]

END [ CASE ] ;

-- Example 19862
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

-- Example 19863
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 19864
+-----------------+
| anonymous block |
|-----------------|
| a is x          |
+-----------------+

-- Example 19865
EXCEPTION
    WHEN <exception_name> [ OR <exception_name> ... ] THEN
        <statement>;
        [ <statement>; ... ]
    [ WHEN ... ]
    [ WHEN OTHER THEN ]
        <statement>;
        [ <statement>; ... ]

-- Example 19866
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

-- Example 19867
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 19868
+----------------------------------+
| anonymous block                  |
|----------------------------------|
| I caught the expected exception. |
+----------------------------------+

-- Example 19869
DECLARE
  e1 EXCEPTION (-20001, 'Exception e1');

BEGIN
  -- Inner block.
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

-- Example 19870
EXECUTE IMMEDIATE $$
    DECLARE
        e1 EXCEPTION (-20001, 'Exception e1');

    BEGIN
        -- Inner block.
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
            BEGIN
                RETURN SQLERRM || ' caught in outer block.';
            END;

    END;
$$
;

-- Example 19871
+-------------------------------------+
| anonymous block                     |
|-------------------------------------|
| Exception e1 caught in outer block. |
+-------------------------------------+

-- Example 19872
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

-- Example 19873
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 19874
+-------------------------+
| anonymous block         |
|-------------------------|
| Inner exception raised. |
+-------------------------+

-- Example 19875
EXCEPTION
  WHEN MY_FIRST_EXCEPTION OR MY_SECOND_EXCEPTION OR MY_THIRD_EXCEPTION THEN
    RETURN 123;
  WHEN MY_FOURTH_EXCEPTION THEN
    RETURN 4;
  WHEN OTHER THEN
    RETURN 99;

-- Example 19876
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

