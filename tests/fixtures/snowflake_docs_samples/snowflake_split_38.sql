-- Example 2517
+-------------------------+
| anonymous block         |
|-------------------------|
| Inner exception raised. |
+-------------------------+

-- Example 2518
EXCEPTION
  WHEN MY_FIRST_EXCEPTION OR MY_SECOND_EXCEPTION OR MY_THIRD_EXCEPTION THEN
    RETURN 123;
  WHEN MY_FOURTH_EXCEPTION THEN
    RETURN 4;
  WHEN OTHER THEN
    RETURN 99;

-- Example 2519
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

-- Example 2520
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 2521
+--------------------------------+
| anonymous block                |
|--------------------------------|
| {                              |
|   "Error type": "Other error", |
|   "SQLCODE": -20001,           |
|   "SQLERRM": "Sample message", |
|   "SQLSTATE": "P0001"          |
| }                              |
+--------------------------------+

-- Example 2522
declare
    e1 exception;
    e2 exception;
begin
    statement_1;
    ...
    RETURN x;
exception
    when e1 then begin
        ...
        RETURN y;
        end;
    when e2 then begin
        ...
        RETURN z;
        end;
end;

-- Example 2523
FETCH <cursor_name> INTO <variable> [, <variable> ... ] ;

-- Example 2524
FETCH my_cursor_name INTO my_variable_name ;

-- Example 2525
FOR <row_variable> IN <cursor_name> DO
    statement;
    [ statement; ... ]
END FOR [ <label> ] ;

-- Example 2526
FOR <counter_variable> IN [ REVERSE ] <start> TO <end> { DO | LOOP }
    statement;
    [ statement; ... ]
END { FOR | LOOP } [ <label> ] ;

-- Example 2527
CREATE or replace TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
    (11.11),
    (22.22);

-- Example 2528
CREATE OR REPLACE PROCEDURE for_loop_over_cursor()
RETURNS FLOAT
LANGUAGE SQL
AS
$$
DECLARE
    total_price FLOAT;
    c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
    total_price := 0.0;
    OPEN c1;
    FOR rec IN c1 DO
        total_price := total_price + rec.price;
    END FOR;
    CLOSE c1;
    RETURN total_price;
END;
$$
;

-- Example 2529
CALL for_loop_over_cursor();
+----------------------+
| FOR_LOOP_OVER_CURSOR |
|----------------------|
|                33.33 |
+----------------------+

-- Example 2530
CREATE PROCEDURE simple_for(iteration_limit INTEGER)
RETURNS INTEGER
LANGUAGE SQL
AS
$$
    DECLARE
        counter INTEGER DEFAULT 0;
    BEGIN
        FOR i IN 1 TO iteration_limit DO
            counter := counter + 1;
        END FOR;
        RETURN counter;
    END;
$$;

-- Example 2531
CALL simple_for(3);
+------------+
| SIMPLE_FOR |
|------------|
|          3 |
+------------+

-- Example 2532
CREATE PROCEDURE reverse_loop(iteration_limit INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    DECLARE
        values_of_i VARCHAR DEFAULT '';
    BEGIN
        FOR i IN REVERSE 1 TO iteration_limit DO
            values_of_i := values_of_i || ' ' || i::varchar;
        END FOR;
        RETURN values_of_i;
    END;
$$;

-- Example 2533
CALL reverse_loop(3);
+--------------+
| REVERSE_LOOP |
|--------------|
|  3 2 1       |
+--------------+

-- Example 2534
CREATE PROCEDURE p(iteration_limit INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    DECLARE
        counter INTEGER DEFAULT 0;
        i INTEGER DEFAULT -999;
        return_value VARCHAR DEFAULT '';
    BEGIN
        FOR i IN 1 TO iteration_limit DO
            counter := counter + 1;
        END FOR;
        return_value := 'counter: ' || counter::varchar || '\n';
        return_value := return_value || 'i: ' || i::VARCHAR;
        RETURN return_value;
    END;
$$;

-- Example 2535
CALL p(3);
+------------+
| P          |
|------------|
| counter: 3 |
| i: -999    |
+------------+

-- Example 2536
IF ( <condition> ) THEN
    <statement>;
    [ <statement>; ... ]
[
ELSEIF ( <condition> ) THEN
    <statement>;
    [ <statement>; ... ]
]
[
ELSE
    <statement>;
    [ <statement>; ... ]
]
END IF;

-- Example 2537
CREATE OR REPLACE PROCEDURE example_if(flag INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF (FLAG = 1) THEN
    RETURN 'one';
  ELSEIF (FLAG = 2) THEN
    RETURN 'two';
  ELSE
    RETURN 'Unexpected input.';
  END IF;
END;
$$
;

-- Example 2538
CALL example_if(3);

-- Example 2539
+-------------------+
| EXAMPLE_IF        |
|-------------------|
| Unexpected input. |
+-------------------+

-- Example 2540
LET { <variable_assignment> | <cursor_assignment> | <resultset_assignment> }

-- Example 2541
LET <variable_name> <type> { DEFAULT | := } <expression> ;

LET <variable_name> { DEFAULT | := } <expression> ;

-- Example 2542
BEGIN
  ...
  LET profit NUMBER(38, 2) DEFAULT 0.0;
  LET revenue NUMBER(38, 2) DEFAULT 110.0;
  LET cost NUMBER(38, 2) := 100.0;
  ...

-- Example 2543
LET <cursor_name> CURSOR FOR <query> ;

-- Example 2544
LET <cursor_name> CURSOR FOR <resultset_name> ;

-- Example 2545
BEGIN
  ...
  LET c1 CURSOR FOR SELECT price FROM invoices;
  ...

-- Example 2546
<resultset_name> := ( <query> ) ;

-- Example 2547
BEGIN
  ...
  LET res RESULTSET := (SELECT price FROM invoices);
  ...

-- Example 2548
LOOP
    <statement>;
    [ <statement>; ... ]
END LOOP [ <label> ] ;

-- Example 2549
CREATE TABLE dummy_data (ID INTEGER);

CREATE PROCEDURE break_out_of_loop()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
    DECLARE
        counter INTEGER;
    BEGIN
        counter := 0;
        LOOP
            counter := counter + 1;
            IF (counter > 5) THEN
                BREAK;
            END IF;
            INSERT INTO dummy_data (ID) VALUES (:counter);
        END LOOP;
        RETURN counter;
    END;
$$
;

-- Example 2550
CALL break_out_of_loop();
+-------------------+
| BREAK_OUT_OF_LOOP |
|-------------------|
|                 6 |
+-------------------+

-- Example 2551
SELECT *
    FROM dummy_data
    ORDER BY ID;
+----+
| ID |
|----|
|  1 |
|  2 |
|  3 |
|  4 |
|  5 |
+----+

-- Example 2552
NULL;

-- Example 2553
CREATE PROCEDURE null_as_statement()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    SELECT 1 / 0;
    RETURN 'If you see this, the exception was not thrown/caught properly.';
EXCEPTION
    WHEN OTHER THEN
        NULL;
END;
$$
;

-- Example 2554
CALL null_as_statement();
+-------------------+
| NULL_AS_STATEMENT |
|-------------------|
|              NULL |
+-------------------+

-- Example 2555
OPEN <cursor_name> [ USING (bind_variable_1 [, bind_variable_2 ...] ) ] ;

-- Example 2556
DECLARE
    c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
    OPEN c1;
    ...

-- Example 2557
DECLARE
    price_to_search_for FLOAT;
    price_count INTEGER;
    c2 CURSOR FOR SELECT COUNT(*) FROM invoices WHERE price = ?;
BEGIN
    price_to_search_for := 11.11;
    OPEN c2 USING (price_to_search_for);

-- Example 2558
RAISE <exception_name> ;

-- Example 2559
CREATE PROCEDURE thrower()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    DECLARE
        MY_EXCEPTION EXCEPTION;
    BEGIN
        RAISE MY_EXCEPTION;
    END;
$$
;

-- Example 2560
CALL thrower();

-- Example 2561
-20000 (P0001): Uncaught exception of type 'MY_EXCEPTION' on line 5 at position 8

-- Example 2562
DECLARE
        MY_EXCEPTION EXCEPTION (-20002, 'Raised MY_EXCEPTION.');

-- Example 2563
-20002 (P0001): Uncaught exception of type 'MY_EXCEPTION' on line 7 at position 8 : Raised MY_EXCEPTION.

-- Example 2564
REPEAT
    <statement>;
    [ <statement>; ... ]
UNTIL ( <condition> )
END REPEAT [ <label> ] ;

-- Example 2565
CREATE PROCEDURE power_of_2()
RETURNS NUMBER(8, 0)
LANGUAGE SQL
AS
$$
DECLARE
    counter NUMBER(8, 0);      -- Loop counter.
    power_of_2 NUMBER(8, 0);   -- Stores the most recent power of 2 that we calculated.
BEGIN
    counter := 1;
    power_of_2 := 1;
    REPEAT
        power_of_2 := power_of_2 * 2;
        counter := counter + 1;
    UNTIL (counter > 8)
    END REPEAT;
    RETURN power_of_2;
END;
$$;

-- Example 2566
CALL power_of_2();
+------------+
| POWER_OF_2 |
|------------|
|        256 |
+------------+

-- Example 2567
RETURN <expression>;

-- Example 2568
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 2569
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 2570
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 2571
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 2572
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 2573
CREATE PROCEDURE ...
RETURNS TABLE(...)
...
    RETURN TABLE(my_result_set);
...

-- Example 2574
WHILE ( <condition> ) { DO | LOOP }
    <statement>;
    [ <statement>; ... ]
END { WHILE | LOOP } [ <label> ] ;

-- Example 2575
WHILE (...) DO
    ...
END WHILE;

WHILE (...) LOOP
    ...
END LOOP;

-- Example 2576
CREATE PROCEDURE power_of_2()
RETURNS NUMBER(8, 0)
LANGUAGE SQL
AS
$$
DECLARE
  counter NUMBER(8, 0);      -- Loop counter.
  power_of_2 NUMBER(8, 0);   -- Stores the most recent power of 2 that we calculated.
BEGIN
  counter := 1;
  power_of_2 := 1;
  WHILE (counter <= 8) DO
    power_of_2 := power_of_2 * 2;
    counter := counter + 1;
  END WHILE;
  RETURN power_of_2;
END;
$$
;

-- Example 2577
CALL power_of_2();

-- Example 2578
+------------+
| POWER_OF_2 |
|------------|
|        256 |
+------------+

-- Example 2579
EXECUTE IMMEDIATE $$
BEGIN
  LET mydate := '2024-05-08';
  WHILE (mydate < '2024-05-20') DO
    mydate := DATEADD(day, 1, mydate);
  END WHILE;
  RETURN mydate;
END;
$$
;

-- Example 2580
+-------------------------+
| anonymous block         |
|-------------------------|
| 2024-05-20 00:00:00.000 |
+-------------------------+

-- Example 2581
SHOW PARAMETERS;

-- Example 2582
SHOW PARAMETERS IN DATABASE mydb;

SHOW PARAMETERS IN WAREHOUSE mywh;

-- Example 2583
SHOW PARAMETERS IN ACCOUNT;

-- Example 2584
SHOW PARAMETERS LIKE '%time%';

