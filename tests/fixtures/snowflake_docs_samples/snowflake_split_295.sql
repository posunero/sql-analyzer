-- Example 19743
EXECUTE IMMEDIATE $$
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
$$
;

-- Example 19744
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 19745
WHILE ( <condition> ) { DO | LOOP }
  <statement>;
  [ <statement>; ... ]
END { WHILE | LOOP } [ <label> ] ;

-- Example 19746
BEGIN
  LET counter := 0;
  WHILE (counter < 5) DO
    counter := counter + 1;
  END WHILE;
  RETURN counter;
END;

-- Example 19747
EXECUTE IMMEDIATE $$
BEGIN
  LET counter := 0;
  WHILE (counter < 5) DO
    counter := counter + 1;
  END WHILE;
  RETURN counter;
END;
$$
;

-- Example 19748
+-----------------+
| anonymous block |
|-----------------|
|               5 |
+-----------------+

-- Example 19749
REPEAT
  <statement>;
  [ <statement>; ... ]
UNTIL ( <condition> )
END REPEAT [ <label> ] ;

-- Example 19750
BEGIN
  LET counter := 5;
  LET number_of_iterations := 0;
  REPEAT
    counter := counter - 1;
    number_of_iterations := number_of_iterations + 1;
  UNTIL (counter = 0)
  END REPEAT;
  RETURN number_of_iterations;
END;

-- Example 19751
EXECUTE IMMEDIATE $$
BEGIN
  LET counter := 5;
  LET number_of_iterations := 0;
  REPEAT
    counter := counter - 1;
    number_of_iterations := number_of_iterations + 1;
  UNTIL (counter = 0)
  END REPEAT;
  RETURN number_of_iterations;
END;
$$
;

-- Example 19752
+-----------------+
| anonymous block |
|-----------------|
|               5 |
+-----------------+

-- Example 19753
LOOP
  <statement>;
  [ <statement>; ... ]
END LOOP [ <label> ] ;

-- Example 19754
BEGIN
  LET counter := 5;
  LOOP
    IF (counter = 0) THEN
      BREAK;
    END IF;
    counter := counter - 1;
  END LOOP;
  RETURN counter;
END;

-- Example 19755
EXECUTE IMMEDIATE $$
BEGIN
  LET counter := 5;
  LOOP
    IF (counter = 0) THEN
      BREAK;
    END IF;
    counter := counter - 1;
  END LOOP;
  RETURN counter;
END;
$$
;

-- Example 19756
+-----------------+
| anonymous block |
|-----------------|
|               0 |
+-----------------+

-- Example 19757
BEGIN
  LET inner_counter := 0;
  LET outer_counter := 0;
  LOOP
    LOOP
      IF (inner_counter < 5) THEN
        inner_counter := inner_counter + 1;
        CONTINUE OUTER;
      ELSE
        BREAK OUTER;
      END IF;
    END LOOP INNER;
    outer_counter := outer_counter + 1;
    BREAK;
  END LOOP OUTER;
  RETURN ARRAY_CONSTRUCT(outer_counter, inner_counter);
END;

-- Example 19758
EXECUTE IMMEDIATE $$
BEGIN
  LET inner_counter := 0;
  LET outer_counter := 0;
  LOOP
    LOOP
      IF (inner_counter < 5) THEN
        inner_counter := inner_counter + 1;
        CONTINUE OUTER;
      ELSE
        BREAK OUTER;
      END IF;
    END LOOP INNER;
    outer_counter := outer_counter + 1;
    BREAK;
  END LOOP OUTER;
  RETURN ARRAY_CONSTRUCT(outer_counter, inner_counter);
END;
$$;

-- Example 19759
+-----------------+
| anonymous block |
|-----------------|
| [               |
|   0,            |
|   5             |
| ]               |
+-----------------+

-- Example 19760
CREATE OR REPLACE TABLE invoices (id INTEGER, price NUMBER(12, 2));

INSERT INTO invoices (id, price) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 19761
DECLARE
  ...
  c1 CURSOR FOR SELECT price FROM invoices;

-- Example 19762
DECLARE
  ...
  res RESULTSET DEFAULT (SELECT price FROM invoices);
  c1 CURSOR FOR res;

-- Example 19763
BEGIN
  ...
  LET c1 CURSOR FOR SELECT price FROM invoices;

-- Example 19764
DECLARE
  id INTEGER DEFAULT 0;
  minimum_price NUMBER(13,2) DEFAULT 22.00;
  maximum_price NUMBER(13,2) DEFAULT 33.00;
  c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
BEGIN
  OPEN c1 USING (minimum_price, maximum_price);
  FETCH c1 INTO id;
  RETURN id;
END;

-- Example 19765
EXECUTE IMMEDIATE $$
DECLARE
  id INTEGER DEFAULT 0;
  minimum_price NUMBER(13,2) DEFAULT 22.00;
  maximum_price NUMBER(13,2) DEFAULT 33.00;
  c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
BEGIN
  OPEN c1 USING (minimum_price, maximum_price);
  FETCH c1 INTO id;
  RETURN id;
END;
$$
;

-- Example 19766
+-----------------+
| anonymous block |
|-----------------|
|               2 |
+-----------------+

-- Example 19767
OPEN c1;

-- Example 19768
LET c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
OPEN c1 USING (minimum_price, maximum_price);

-- Example 19769
FETCH c1 INTO var_for_column_value;

-- Example 19770
DECLARE
  geohash_value VARCHAR;
BEGIN
  LET res RESULTSET := (SELECT TO_GEOGRAPHY('POINT(1 1)') AS GEOGRAPHY_VALUE);
  LET cur CURSOR FOR res;
  FOR row_variable IN cur DO
    geohash_value := ST_GEOHASH(row_variable.geography_value);
  END FOR;
  RETURN geohash_value;
END;

-- Example 19771
001044 (42P13): Uncaught exception of type 'EXPRESSION_ERROR' on line 7 at position 21 : SQL compilation error: ...
Invalid argument types for function 'ST_GEOHASH': (OBJECT)

-- Example 19772
geohash_value := ST_GEOHASH(TO_GEOGRAPHY(row_variable.geography_value));

-- Example 19773
DECLARE
  c1 CURSOR FOR SELECT * FROM invoices;
BEGIN
  OPEN c1;
  RETURN TABLE(RESULTSET_FROM_CURSOR(c1));
END;

-- Example 19774
EXECUTE IMMEDIATE $$
DECLARE
  c1 CURSOR FOR SELECT * FROM invoices;
BEGIN
  OPEN c1;
  RETURN TABLE(RESULTSET_FROM_CURSOR(c1));
END;
$$
;

-- Example 19775
+----+-------+
| ID | PRICE |
|----+-------|
|  1 | 11.11 |
|  2 | 22.22 |
+----+-------+

-- Example 19776
CLOSE c1;

-- Example 19777
DECLARE
  row_price FLOAT;
  total_price FLOAT;
  c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
  row_price := 0.0;
  total_price := 0.0;
  OPEN c1;
  FETCH c1 INTO row_price;
  total_price := total_price + row_price;
  FETCH c1 INTO row_price;
  total_price := total_price + row_price;
  CLOSE c1;
  RETURN total_price;
END;

-- Example 19778
EXECUTE IMMEDIATE $$
DECLARE
    row_price FLOAT;
    total_price FLOAT;
    c1 CURSOR FOR SELECT price FROM invoices;
BEGIN
    row_price := 0.0;
    total_price := 0.0;
    OPEN c1;
    FETCH c1 INTO row_price;
    total_price := total_price + row_price;
    FETCH c1 INTO row_price;
    total_price := total_price + row_price;
    CLOSE c1;
    RETURN total_price;
END;
$$
;

-- Example 19779
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 19780
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

-- Example 19781
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

-- Example 19782
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 19783
FOR <row_variable> IN <cursor_name> DO
    statement;
    [ statement; ... ]
END FOR [ <label> ] ;

-- Example 19784
FOR <counter_variable> IN [ REVERSE ] <start> TO <end> { DO | LOOP }
    statement;
    [ statement; ... ]
END { FOR | LOOP } [ <label> ] ;

-- Example 19785
CREATE or replace TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
    (11.11),
    (22.22);

-- Example 19786
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

-- Example 19787
CALL for_loop_over_cursor();
+----------------------+
| FOR_LOOP_OVER_CURSOR |
|----------------------|
|                33.33 |
+----------------------+

-- Example 19788
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

-- Example 19789
CALL simple_for(3);
+------------+
| SIMPLE_FOR |
|------------|
|          3 |
+------------+

-- Example 19790
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

-- Example 19791
CALL reverse_loop(3);
+--------------+
| REVERSE_LOOP |
|--------------|
|  3 2 1       |
+--------------+

-- Example 19792
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

-- Example 19793
CALL p(3);
+------------+
| P          |
|------------|
| counter: 3 |
| i: -999    |
+------------+

-- Example 19794
<variable_name> <type> ;

<variable_name> DEFAULT <expression> ;

<variable_name> <type> DEFAULT <expression> ;

-- Example 19795
LET <variable_name> <type> { DEFAULT | := } <expression> ;

LET <variable_name> { DEFAULT | := } <expression> ;

-- Example 19796
DECLARE
  profit number(38, 2) DEFAULT 0.0;
BEGIN
  LET cost number(38, 2) := 100.0;
  LET revenue number(38, 2) DEFAULT 110.0;

  profit := revenue - cost;
  RETURN profit;
END;

-- Example 19797
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

-- Example 19798
+-----------------+
| anonymous block |
|-----------------|
|           10.00 |
+-----------------+

-- Example 19799
...
FOR current_row IN cursor_1 DO:
  LET price := current_row.price_column;
  ...

-- Example 19800
092228 (P0000): SQL compilation error:
  error line 7 at position 4 variable 'PRICE' cannot have its type inferred from initializer

-- Example 19801
<variable_name> := <expression> ;

-- Example 19802
DECLARE
  profit NUMBER(38, 2);
  revenue NUMBER(38, 2);
  cost NUMBER(38, 2);
BEGIN
  ...
  profit := revenue - cost;
  ...
RETURN profit;

-- Example 19803
INSERT INTO my_table (x) VALUES (:my_variable)

-- Example 19804
SELECT COUNT(*) FROM IDENTIFIER(:table_name)

-- Example 19805
RETURN profit;

-- Example 19806
LET select_statement := 'SELECT * FROM invoices WHERE id = ' || id_variable;

-- Example 19807
SELECT <expression1>, <expression2>, ... INTO :<variable1>, :<variable2>, ... FROM ... WHERE ...;

-- Example 19808
CREATE OR REPLACE TABLE some_data (id INTEGER, name VARCHAR);
INSERT INTO some_data (id, name) VALUES
  (1, 'a'),
  (2, 'b');

-- Example 19809
DECLARE
  id INTEGER;
  name VARCHAR;
BEGIN
  SELECT id, name INTO :id, :name FROM some_data WHERE id = 1;
  RETURN id || ' ' || name;
END;

