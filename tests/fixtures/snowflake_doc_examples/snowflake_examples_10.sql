-- More Extracted Snowflake SQL Examples (Set 10)

-- From snowflake_split_407.sql

-- DML/DDL examples
CREATE TABLE t (c1 INT, c2 STRING);
INSERT INTO t (c1, c2) VALUES (1, 'Test string');
INSERT INTO t (c1, c2) VALUES (?, ?);
INSERT INTO t (col1, col2) VALUES (?, ?);
INSERT INTO t (c1) VALUES (:variable1);

-- Scripting/bind variable usage
EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price);
LET c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
OPEN c1 USING (minimum_price, maximum_price);

EXECUTE IMMEDIATE $$
DECLARE
  i INTEGER DEFAULT 1;
  v VARCHAR DEFAULT 'SnowFlake';
  r RESULTSET;
BEGIN
  CREATE OR REPLACE TABLE snowflake_scripting_bind_demo (id INTEGER, value VARCHAR);
  EXECUTE IMMEDIATE 'INSERT INTO snowflake_scripting_bind_demo (id, value)
    SELECT :1, (:2 || :1)' USING (i, v);
  r := (SELECT * FROM snowflake_scripting_bind_demo);
  RETURN TABLE(r);
END;
$$; 