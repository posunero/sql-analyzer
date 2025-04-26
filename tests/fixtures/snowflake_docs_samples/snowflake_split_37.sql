-- Example 2449
SHOW PARAMETERS LIKE 'search_path';

-- Example 2450
ALTER SESSION SET SEARCH_PATH = '$current, $public, SNOWFLAKE.ML';

-- Example 2451
ALTER USER SET SEARCH_PATH = '$current, $public, SNOWFLAKE.ML';

-- Example 2452
ALTER ACCOUNT SET SEARCH_PATH = '$current, $public, SNOWFLAKE.ML';

-- Example 2453
SHOW FUNCTIONS IN CLASS ANOMALY_DETECTION;

-- Example 2454
+-----------------------+-------------------+-------------------+--------------------------------------------------------------------------+--------------+----------+
| name                  | min_num_arguments | max_num_arguments | arguments                                                                | descriptions | language |
|-----------------------+-------------------+-------------------+--------------------------------------------------------------------------+--------------+----------|
| _DETECT_ANOMALIES_1_1 |                 5 |                 5 | (MODEL BINARY, TS TIMESTAMP_NTZ, Y FLOAT, FEATURES ARRAY, CONFIG OBJECT) | NULL         | Python   |
| _FIT                  |                 3 |                 3 | (TS TIMESTAMP_NTZ, Y FLOAT, FEATURES ARRAY)                              | NULL         | Python   |
| _FIT                  |                 4 |                 4 | (TS TIMESTAMP_NTZ, Y FLOAT, LABEL BOOLEAN, FEATURES ARRAY)               | NULL         | Python   |
+-----------------------+-------------------+-------------------+--------------------------------------------------------------------------+--------------+----------+

-- Example 2455
SHOW PROCEDURES IN CLASS ANOMALY_DETECTION;

-- Example 2456
+---------------------------------+-------------------+-------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+
| name                            | min_num_arguments | max_num_arguments | arguments                                                                                                                                | descriptions | language   |
|---------------------------------+-------------------+-------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------|
| __CONSTRUCT                     |                 4 |                 4 | (INPUT_DATA VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, LABEL_COLNAME VARCHAR)                                           | NULL         | Javascript |
| __CONSTRUCT                     |                 5 |                 5 | (INPUT_DATA VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, LABEL_COLNAME VARCHAR)                   | NULL         | Javascript |
| DETECT_ANOMALIES                |                 4 |                 4 | (INPUT_DATA VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR)                                          | NULL         | SQL        |
| DETECT_ANOMALIES                |                 5 |                 5 | (INPUT_DATA VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, CONFIG_OBJECT OBJECT)                    | NULL         | SQL        |
| DETECT_ANOMALIES                |                 3 |                 3 | (INPUT_DATA VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR)                                                                  | NULL         | SQL        |
| DETECT_ANOMALIES                |                 4 |                 4 | (INPUT_DATA VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, CONFIG_OBJECT OBJECT)                                            | NULL         | SQL        |
| EXPLAIN_FEATURE_IMPORTANCE      |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
| _CONSTRUCTFEATUREINPUT          |                 6 |                 6 | (INPUT_REF VARCHAR, SERIES_COLNAME VARCHAR, TIMESTAMP_COLNAME VARCHAR, TARGET_COLNAME VARCHAR, LABEL_COLNAME VARCHAR, REF_ALIAS VARCHAR) | NULL         | Javascript |
| _CONSTRUCTINFERENCEFUNCTIONNAME |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
| _CONSTRUCTINFERENCERESULTAPI    |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
| _SETTRAININGINFO                |                 0 |                 0 | ()                                                                                                                                       | NULL         | SQL        |
+---------------------------------+-------------------+-------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------+------------+

-- Example 2457
SHOW ROLES IN CLASS ANOMALY_DETECTION;

-- Example 2458
+-------------------------------+------+---------+
| created_on                    | name | comment |
|-------------------------------+------+---------|
| 2023-06-06 01:06:42.808 +0000 | USER | NULL    |
+-------------------------------+------+---------+

-- Example 2459
SHOW GRANTS TO SNOWFLAKE.ML.ANOMALY_DETECTION ROLE my_db.my_schema.my_anomaly_detector!USER;

-- Example 2460
GRANT SNOWFLAKE.ML.ANOMALY_DETECTION ROLE my_db.my_schema.my_anomaly_detector!USER
  TO ROLE my_role;

-- Example 2461
GRANT CREATE ANOMALY_DETECTION ON SCHEMA mydb.myschema TO ROLE ml_admin;

-- Example 2462
CREATE ANOMALY_DETECTION my_anomaly_detector(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'my_view'),
  TIMESTAMP_COLUMN => 'my_timestamp_column'
  TARGET_COLNAME => 'my_target_column',
  LABEL_COLNAME => ''
);

-- Example 2463
CALL my_anomaly_detector!DETECT_ANOMALIES(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'my_view'),
  TIMESTAMP_COLNAME =>'my_timestamp_column',
  TARGET_COLNAME => 'my_target_column'
);

-- Example 2464
SELECT ... FROM TABLE( <method_name>( <arg> [ , ... <arg> ] ) );

-- Example 2465
SELECT ts, forecast, is_anomaly FROM TABLE(
  my_anomaly_detector!DETECT_ANOMALIES(
    INPUT_DATA => TABLE('my_view'),
    TIMESTAMP_COLNAME =>'my_timestamp_column',
    TARGET_COLNAME => 'my_target_column'
  )
);

-- Example 2466
WITH my_data AS (
  SELECT * FROM my_view
)
SELECT ts, forecast FROM TABLE(
  my_anomaly_detector!DETECT_ANOMALIES(
    INPUT_DATA => TABLE('SELECT * FROM my_data'),
    TIMESTAMP_COLNAME =>'my_timestamp_column',
    TARGET_COLNAME => 'my_target_column'
  )
);

-- Example 2467
SELECT ts, forecast FROM TABLE(
  my_anomaly_detector!DETECT_ANOMALIES(
    INPUT_DATA => TABLE('
      WITH my_data AS (
        SELECT * FROM my_view
      )
      SELECT * FROM my_data
    '),
    TIMESTAMP_COLNAME =>'my_timestamp_column',
    TARGET_COLNAME => 'my_target_column'
  )
);

-- Example 2468
AWAIT { ALL | <result_set_name> };

-- Example 2469
BEGIN
  LET res RESULTSET := ASYNC (SELECT * FROM invalid_table);
  AWAIT res;
END;

-- Example 2470
002003 (42S02): Uncaught exception of type 'STATEMENT_ERROR' on line 2 at position 4 : SQL compilation error:
Table 'INVALID_TABLE' does not exist or not authorized.

-- Example 2471
AWAIT ALL;

-- Example 2472
AWAIT my_result_set;

-- Example 2473
BEGIN
    <statement>;
    [ <statement>; ... ]
[ EXCEPTION <exception_handler> ]
END;

-- Example 2474
EXECUTE IMMEDIATE $$
BEGIN
    CREATE TABLE parent (ID INTEGER);
    CREATE TABLE child (ID INTEGER, parent_ID INTEGER);
    RETURN 'Completed';
END;
$$
;

-- Example 2475
EXECUTE IMMEDIATE $$
BEGIN
    BEGIN TRANSACTION;
    TRUNCATE TABLE child;
    TRUNCATE TABLE parent;
    COMMIT;
    RETURN '';
END;
$$
;

-- Example 2476
IF (both_rows_are_valid) THEN
    BEGIN
        BEGIN TRANSACTION;
        INSERT INTO parent ...;
        INSERT INTO child ...;
        COMMIT;
    END;
END IF;

-- Example 2477
{ BREAK | EXIT } [ <label> ] ;

-- Example 2478
DECLARE
  i INTEGER;
  j INTEGER;
BEGIN
  i := 1;
  j := 1;
  WHILE (i <= 4) DO
    WHILE (j <= 4) DO
      -- Exit when j is 3, even if i is still 1.
      IF (j = 3) THEN
        BREAK outer_loop;
      END IF;
      j := j + 1;
    END WHILE inner_loop;
    i := i + 1;
  END WHILE outer_loop;
  -- Execution resumes here after the BREAK executes.
  RETURN i;
END;

-- Example 2479
EXECUTE IMMEDIATE $$
    DECLARE
        i INTEGER;
        j INTEGER;
    BEGIN
        i := 1;
        j := 1;
        WHILE (i <= 4) DO
            WHILE (j <= 4) DO
                -- Exit when j is 3, even if i is still 1.
                IF (j = 3) THEN
                     BREAK outer_loop;
                END IF;
                j := j + 1;
            END WHILE inner_loop;
            i := i + 1;
        END WHILE outer_loop;
        -- Execution resumes here after the BREAK executes.
        RETURN i;
    END;
$$;

-- Example 2480
+-----------------+
| anonymous block |
|-----------------|
|               1 |
+-----------------+

-- Example 2481
CANCEL <result_set_name> ;

-- Example 2482
CANCEL my_result_set;

-- Example 2483
CASE ( <expression_to_match> )
    WHEN <expression> THEN
        <statement>;
        [ <statement>; ... ]
    [ WHEN ... ]
    [ ELSE
        <statement>;
        [ <statement>; ... ]
    ]
END [ CASE ] ;

-- Example 2484
CASE
    WHEN <boolean_expression> THEN
        <statement>;
        [ <statement>; ... ]
    [ WHEN ... ]
    [ ELSE
        <statement>;
        [ <statement>; ... ]
    ]
END [ CASE ] ;

-- Example 2485
CREATE PROCEDURE case_demo_01(v VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
  BEGIN
    CASE (v)
      WHEN 'first choice' THEN
        RETURN 'one';
      WHEN 'second choice' THEN
        RETURN 'two';
      ELSE
        RETURN 'unexpected choice';
    END;
  END;

-- Example 2486
CREATE PROCEDURE case_demo_01(v VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    BEGIN
        CASE (v)
            WHEN 'first choice' THEN
                RETURN 'one';
            WHEN 'second choice' THEN
                RETURN 'two';
            ELSE
                RETURN 'unexpected choice';
       END CASE;
    END;
$$
;

-- Example 2487
CALL case_demo_01('second choice');
+--------------+
| CASE_DEMO_01 |
|--------------|
| two          |
+--------------+

-- Example 2488
CREATE PROCEDURE case_demo_2(v VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
  BEGIN
    CASE
      WHEN v = 'first choice' THEN
        RETURN 'one';
      WHEN v = 'second choice' THEN
        RETURN 'two';
      ELSE
        RETURN 'unexpected choice';
    END;
  END;

-- Example 2489
CREATE PROCEDURE case_demo_2(v VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    BEGIN
        CASE 
            WHEN v = 'first choice' THEN
                RETURN 'one';
            WHEN v = 'second choice' THEN
                RETURN 'two';
            ELSE
                RETURN 'unexpected choice';
       END CASE;
    END;
$$
;

-- Example 2490
CALL case_demo_2('none of the above');
+-------------------+
| CASE_DEMO_2       |
|-------------------|
| unexpected choice |
+-------------------+

-- Example 2491
CLOSE <cursor_name> ;

-- Example 2492
CLOSE my_cursor_name;

-- Example 2493
{ CONTINUE | ITERATE } [ <label> ] ;

-- Example 2494
DECLARE
  counter1 NUMBER(8, 0);
  counter2 NUMBER(8, 0);
BEGIN
  counter1 := 0;
  counter2 := 0;
  WHILE (counter1 < 3) DO
    counter1 := counter1 + 1;
    CONTINUE;
    counter2 := counter2 + 1;
  END WHILE;
  RETURN counter2;
END;

-- Example 2495
EXECUTE IMMEDIATE $$
DECLARE
    counter1 NUMBER(8, 0);
    counter2 NUMBER(8, 0);
BEGIN
    counter1 := 0;
    counter2 := 0;
    WHILE (counter1 < 3) DO
        counter1 := counter1 + 1;
        CONTINUE;
        counter2 := counter2 + 1;
    END WHILE;
    RETURN counter2;
END;
$$;

-- Example 2496
+-----------------+
| anonymous block |
|-----------------|
|               0 |
+-----------------+

-- Example 2497
DECLARE
  { <variable_declaration> | <cursor_declaration> | <resultset_declaration> | <exception_declaration> };
  [{ <variable_declaration> | <cursor_declaration> | <resultset_declaration> | <exception_declaration> }; ... ]

-- Example 2498
<variable_declaration> ::=
  <variable_name> [<type>] [ { DEFAULT | := } <expression>]

-- Example 2499
profit NUMBER(38, 2) := 0;

-- Example 2500
<cursor_declaration> ::=
  <cursor_name> CURSOR FOR <query>

-- Example 2501
c1 CURSOR FOR SELECT id, price FROM invoices;

-- Example 2502
<resultset_name> RESULTSET [ { DEFAULT | := } [ ASYNC ] ( <query> ) ] ;

-- Example 2503
res RESULTSET DEFAULT (SELECT col1 FROM mytable ORDER BY col1);

-- Example 2504
<exception_name> EXCEPTION [ ( <exception_number> , '<exception_message>' ) ] ;

-- Example 2505
exception_could_not_create_table EXCEPTION (-20003, 'ERROR: Could not create table.');

-- Example 2506
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;

-- Example 2507
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

-- Example 2508
EXCEPTION
    WHEN <exception_name> [ OR <exception_name> ... ] THEN
        <statement>;
        [ <statement>; ... ]
    [ WHEN ... ]
    [ WHEN OTHER THEN ]
        <statement>;
        [ <statement>; ... ]

-- Example 2509
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

-- Example 2510
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

-- Example 2511
+----------------------------------+
| anonymous block                  |
|----------------------------------|
| I caught the expected exception. |
+----------------------------------+

-- Example 2512
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

-- Example 2513
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

-- Example 2514
+-------------------------------------+
| anonymous block                     |
|-------------------------------------|
| Exception e1 caught in outer block. |
+-------------------------------------+

-- Example 2515
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

-- Example 2516
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

