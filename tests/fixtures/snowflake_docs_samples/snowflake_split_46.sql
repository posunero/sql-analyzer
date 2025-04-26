-- Example 3061
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 3062
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 3063
CREATE PROCEDURE ...
RETURNS TABLE(...)
...
RETURN TABLE(my_result_set);
...

-- Example 3064
IF (<condition>) THEN
   -- Statements to execute if the <condition> is true.

[ ELSEIF ( <condition_2> ) THEN
  -- Statements to execute if the <condition_2> is true.
]

[ ELSE
  -- Statements to execute if none of the conditions are true.
]

  END IF ;

-- Example 3065
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

-- Example 3066
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

-- Example 3067
+-----------------+
| anonymous block |
|-----------------|
| positive value  |
+-----------------+

-- Example 3068
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

-- Example 3069
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

-- Example 3070
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

-- Example 3071
+-----------------+
| anonymous block |
|-----------------|
| x               |
+-----------------+

-- Example 3072
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

-- Example 3073
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

-- Example 3074
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

-- Example 3075
+-----------------+
| anonymous block |
|-----------------|
| a is x          |
+-----------------+

-- Example 3076
FOR <counter_variable> IN [ REVERSE ] <start> TO <end> { DO | LOOP }
  <statement>;
  [ <statement>; ... ]
END { FOR | LOOP } [ <label> ] ;

-- Example 3077
DECLARE
  counter INTEGER DEFAULT 0;
  maximum_count INTEGER default 5;
BEGIN
  FOR i IN 1 TO maximum_count DO
    counter := counter + 1;
  END FOR;
  RETURN counter;
END;

-- Example 3078
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

-- Example 3079
+-----------------+
| anonymous block |
|-----------------|
|               5 |
+-----------------+

-- Example 3080
FOR <row_variable> IN <cursor_name> DO
  <statement>;
  [ <statement>; ... ]
END FOR [ <label> ] ;

-- Example 3081
CREATE OR REPLACE TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
  (11.11),
  (22.22);

-- Example 3082
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

-- Example 3083
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

-- Example 3084
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 3085
FOR <row_variable> IN <RESULTSET_name> DO
  <statement>;
  [ <statement>; ... ]
END FOR [ <label> ] ;

-- Example 3086
CREATE OR REPLACE TABLE invoices (price NUMBER(12, 2));
INSERT INTO invoices (price) VALUES
  (11.11),
  (22.22);

-- Example 3087
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

-- Example 3088
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

-- Example 3089
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 3090
WHILE ( <condition> ) { DO | LOOP }
  <statement>;
  [ <statement>; ... ]
END { WHILE | LOOP } [ <label> ] ;

-- Example 3091
BEGIN
  LET counter := 0;
  WHILE (counter < 5) DO
    counter := counter + 1;
  END WHILE;
  RETURN counter;
END;

-- Example 3092
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

-- Example 3093
+-----------------+
| anonymous block |
|-----------------|
|               5 |
+-----------------+

-- Example 3094
REPEAT
  <statement>;
  [ <statement>; ... ]
UNTIL ( <condition> )
END REPEAT [ <label> ] ;

-- Example 3095
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

-- Example 3096
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

-- Example 3097
+-----------------+
| anonymous block |
|-----------------|
|               5 |
+-----------------+

-- Example 3098
LOOP
  <statement>;
  [ <statement>; ... ]
END LOOP [ <label> ] ;

-- Example 3099
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

-- Example 3100
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

-- Example 3101
+-----------------+
| anonymous block |
|-----------------|
|               0 |
+-----------------+

-- Example 3102
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

-- Example 3103
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

-- Example 3104
+-----------------+
| anonymous block |
|-----------------|
| [               |
|   0,            |
|   5             |
| ]               |
+-----------------+

-- Example 3105
CREATE OR REPLACE TABLE invoices (id INTEGER, price NUMBER(12, 2));

INSERT INTO invoices (id, price) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 3106
DECLARE
  ...
  c1 CURSOR FOR SELECT price FROM invoices;

-- Example 3107
DECLARE
  ...
  res RESULTSET DEFAULT (SELECT price FROM invoices);
  c1 CURSOR FOR res;

-- Example 3108
BEGIN
  ...
  LET c1 CURSOR FOR SELECT price FROM invoices;

-- Example 3109
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

-- Example 3110
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

-- Example 3111
+-----------------+
| anonymous block |
|-----------------|
|               2 |
+-----------------+

-- Example 3112
OPEN c1;

-- Example 3113
LET c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
OPEN c1 USING (minimum_price, maximum_price);

-- Example 3114
FETCH c1 INTO var_for_column_value;

-- Example 3115
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

-- Example 3116
001044 (42P13): Uncaught exception of type 'EXPRESSION_ERROR' on line 7 at position 21 : SQL compilation error: ...
Invalid argument types for function 'ST_GEOHASH': (OBJECT)

-- Example 3117
geohash_value := ST_GEOHASH(TO_GEOGRAPHY(row_variable.geography_value));

-- Example 3118
DECLARE
  c1 CURSOR FOR SELECT * FROM invoices;
BEGIN
  OPEN c1;
  RETURN TABLE(RESULTSET_FROM_CURSOR(c1));
END;

-- Example 3119
EXECUTE IMMEDIATE $$
DECLARE
  c1 CURSOR FOR SELECT * FROM invoices;
BEGIN
  OPEN c1;
  RETURN TABLE(RESULTSET_FROM_CURSOR(c1));
END;
$$
;

-- Example 3120
+----+-------+
| ID | PRICE |
|----+-------|
|  1 | 11.11 |
|  2 | 22.22 |
+----+-------+

-- Example 3121
CLOSE c1;

-- Example 3122
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

-- Example 3123
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

-- Example 3124
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 3125
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

-- Example 3126
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

-- Example 3127
+-----------------+
| anonymous block |
|-----------------|
|           33.33 |
+-----------------+

-- Example 3128
DECLARE
  ...
  res RESULTSET DEFAULT (SELECT col1 FROM mytable ORDER BY col1);

