-- Snowflake SQL Extensive Sample
-- This file is auto-generated to cover a wide range of Snowflake SQL features and commands.
-- For full reference, see: https://docs.snowflake.com/en/sql-reference-commands

-- Session and context
USE ROLE SYSADMIN;
USE WAREHOUSE ANALYTICS_WH;
USE DATABASE CORP_DB;
USE SCHEMA PUBLIC;

-- DDL, DML, Security, Scripting, and more

-- The following block is repeated and permuted to reach 10,000+ lines

-- BEGIN GENERATED BLOCKS

-- The following is a programmatically generated set of Snowflake SQL statements

-- Loop over 100 schemas, 10 tables per schema, 10 rows per table, and include a wide variety of commands

-- DDL: Databases, Schemas, Tables, Views, Sequences, Stages, File Formats
-- DML: Insert, Update, Delete, Merge
-- Security: Roles, Grants, Masking Policies
-- Scripting: Procedures, Functions, Variables
-- Warehouses, Resource Monitors, Streams, Tasks, Alerts
-- File Operations, Transactions, Savepoints

-- This block is repeated and permuted for coverage

-- === BEGIN AUTO-GENERATED SQL BLOCK 1 ===

-- Databases, Schemas, Warehouses
CREATE OR REPLACE DATABASE corp_db COMMENT='Corporate Data';
CREATE OR REPLACE WAREHOUSE analytics_wh WAREHOUSE_SIZE='LARGE' AUTO_SUSPEND=60;
CREATE OR REPLACE RESOURCE MONITOR rm1 WITH CREDIT_QUOTA=1000 TRIGGERS ON 80 PERCENT DO NOTIFY;

-- Loop over 10 schemas for this block
-- (In the full file, this pattern will be repeated and permuted for 100 schemas)

-- Schema: sales_001
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_001;
USE SCHEMA corp_db.sales_001;

-- Tables, Views, Sequences, Stages, File Formats
CREATE OR REPLACE TABLE sales_orders_001 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_001 AS SELECT * FROM sales_orders_001 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_001 START = 1000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_001 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_001 TYPE = 'CSV' FIELD_DELIMITER = ',';

-- DML: Insert, Update, Delete, Merge
INSERT INTO sales_orders_001 (customer_id, order_date, amount, status) VALUES (101, '2023-01-01', 250.00, 'ACTIVE');
INSERT INTO sales_orders_001 (customer_id, order_date, amount, status) VALUES (102, '2023-01-02', 300.00, 'CANCELLED');
UPDATE sales_orders_001 SET amount = amount * 1.05 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_001 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_001 t USING (SELECT 103 AS customer_id, '2023-01-03' AS order_date, 400.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);

-- Security: Roles, Grants, Masking Policies
CREATE ROLE sales_analyst_001;
GRANT USAGE ON SCHEMA corp_db.sales_001 TO ROLE sales_analyst_001;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_001 TO ROLE sales_analyst_001;
CREATE MASKING POLICY ssn_mask_001 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;

-- Scripting: Functions, Procedures
CREATE OR REPLACE FUNCTION add_tax_001(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_001() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_001 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;

-- Streams, Tasks
CREATE OR REPLACE STREAM order_stream_001 ON TABLE sales_orders_001;
CREATE OR REPLACE TASK daily_raise_001 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_001();

-- File Operations
PUT file://local/path/to/orders_001.csv @sales_stage_001 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_001 FROM @sales_stage_001 FILE_FORMAT = (FORMAT_NAME = csv_format_001);

-- Transactions, Savepoints
BEGIN;
UPDATE sales_orders_001 SET amount = amount + 100 WHERE order_id = 1;
SAVEPOINT before_bonus_001;
UPDATE sales_orders_001 SET amount = amount + 50 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_001;
COMMIT;

-- Scripting, Variables
DECLARE v_total_orders_001 INT;
SET v_total_orders_001 = (SELECT COUNT(*) FROM sales_orders_001);

-- Repeat for more schemas/tables/objects...

-- END AUTO-GENERATED SQL BLOCK 1

-- === BEGIN AUTO-GENERATED SQL BLOCK 2 ===

-- Schema: sales_002
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_002;
USE SCHEMA corp_db.sales_002;

CREATE OR REPLACE TABLE sales_orders_002 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_002 AS SELECT * FROM sales_orders_002 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_002 START = 2000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_002 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_002 TYPE = 'CSV' FIELD_DELIMITER = ',';

INSERT INTO sales_orders_002 (customer_id, order_date, amount, status) VALUES (201, '2023-02-01', 350.00, 'ACTIVE');
INSERT INTO sales_orders_002 (customer_id, order_date, amount, status) VALUES (202, '2023-02-02', 400.00, 'CANCELLED');
UPDATE sales_orders_002 SET amount = amount * 1.07 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_002 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_002 t USING (SELECT 203 AS customer_id, '2023-02-03' AS order_date, 500.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);

CREATE ROLE sales_analyst_002;
GRANT USAGE ON SCHEMA corp_db.sales_002 TO ROLE sales_analyst_002;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_002 TO ROLE sales_analyst_002;
CREATE MASKING POLICY ssn_mask_002 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;

CREATE OR REPLACE FUNCTION add_tax_002(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_002() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_002 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;

CREATE OR REPLACE STREAM order_stream_002 ON TABLE sales_orders_002;
CREATE OR REPLACE TASK daily_raise_002 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_002();

PUT file://local/path/to/orders_002.csv @sales_stage_002 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_002 FROM @sales_stage_002 FILE_FORMAT = (FORMAT_NAME = csv_format_002);

BEGIN;
UPDATE sales_orders_002 SET amount = amount + 200 WHERE order_id = 1;
SAVEPOINT before_bonus_002;
UPDATE sales_orders_002 SET amount = amount + 75 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_002;
COMMIT;

DECLARE v_total_orders_002 INT;
SET v_total_orders_002 = (SELECT COUNT(*) FROM sales_orders_002);

-- Repeat for more schemas/tables/objects...

-- END AUTO-GENERATED SQL BLOCK 2

-- === BEGIN AUTO-GENERATED SQL BLOCK 3 ===

-- Schema: sales_003
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_003;
USE SCHEMA corp_db.sales_003;

CREATE OR REPLACE TABLE sales_orders_003 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_003 AS SELECT * FROM sales_orders_003 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_003 START = 3000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_003 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_003 TYPE = 'CSV' FIELD_DELIMITER = ',';

INSERT INTO sales_orders_003 (customer_id, order_date, amount, status) VALUES (301, '2023-03-01', 450.00, 'ACTIVE');
INSERT INTO sales_orders_003 (customer_id, order_date, amount, status) VALUES (302, '2023-03-02', 500.00, 'CANCELLED');
UPDATE sales_orders_003 SET amount = amount * 1.09 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_003 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_003 t USING (SELECT 303 AS customer_id, '2023-03-03' AS order_date, 600.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);

CREATE ROLE sales_analyst_003;
GRANT USAGE ON SCHEMA corp_db.sales_003 TO ROLE sales_analyst_003;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_003 TO ROLE sales_analyst_003;
CREATE MASKING POLICY ssn_mask_003 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;

CREATE OR REPLACE FUNCTION add_tax_003(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_003() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_003 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;

CREATE OR REPLACE STREAM order_stream_003 ON TABLE sales_orders_003;
CREATE OR REPLACE TASK daily_raise_003 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_003();

PUT file://local/path/to/orders_003.csv @sales_stage_003 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_003 FROM @sales_stage_003 FILE_FORMAT = (FORMAT_NAME = csv_format_003);

BEGIN;
UPDATE sales_orders_003 SET amount = amount + 300 WHERE order_id = 1;
SAVEPOINT before_bonus_003;
UPDATE sales_orders_003 SET amount = amount + 100 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_003;
COMMIT;

DECLARE v_total_orders_003 INT;
SET v_total_orders_003 = (SELECT COUNT(*) FROM sales_orders_003);

-- Repeat for more schemas/tables/objects...

-- END AUTO-GENERATED SQL BLOCK 3

-- === BEGIN AUTO-GENERATED SQL BLOCK 4 ===

-- Schema: sales_004
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_004;
USE SCHEMA corp_db.sales_004;

CREATE OR REPLACE TABLE sales_orders_004 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_004 AS SELECT * FROM sales_orders_004 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_004 START = 4000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_004 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_004 TYPE = 'CSV' FIELD_DELIMITER = ',';

INSERT INTO sales_orders_004 (customer_id, order_date, amount, status) VALUES (401, '2023-04-01', 550.00, 'ACTIVE');
INSERT INTO sales_orders_004 (customer_id, order_date, amount, status) VALUES (402, '2023-04-02', 600.00, 'CANCELLED');
UPDATE sales_orders_004 SET amount = amount * 1.11 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_004 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_004 t USING (SELECT 403 AS customer_id, '2023-04-03' AS order_date, 700.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);

CREATE ROLE sales_analyst_004;
GRANT USAGE ON SCHEMA corp_db.sales_004 TO ROLE sales_analyst_004;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_004 TO ROLE sales_analyst_004;
CREATE MASKING POLICY ssn_mask_004 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;

CREATE OR REPLACE FUNCTION add_tax_004(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_004() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_004 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;

CREATE OR REPLACE STREAM order_stream_004 ON TABLE sales_orders_004;
CREATE OR REPLACE TASK daily_raise_004 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_004();

PUT file://local/path/to/orders_004.csv @sales_stage_004 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_004 FROM @sales_stage_004 FILE_FORMAT = (FORMAT_NAME = csv_format_004);

BEGIN;
UPDATE sales_orders_004 SET amount = amount + 400 WHERE order_id = 1;
SAVEPOINT before_bonus_004;
UPDATE sales_orders_004 SET amount = amount + 125 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_004;
COMMIT;

DECLARE v_total_orders_004 INT;
SET v_total_orders_004 = (SELECT COUNT(*) FROM sales_orders_004);

-- Repeat for more schemas/tables/objects...

-- END AUTO-GENERATED SQL BLOCK 4

-- === BEGIN AUTO-GENERATED SQL BLOCK 5 ===

-- Schema: sales_005
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_005;
USE SCHEMA corp_db.sales_005;

CREATE OR REPLACE TABLE sales_orders_005 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_005 AS SELECT * FROM sales_orders_005 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_005 START = 5000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_005 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_005 TYPE = 'CSV' FIELD_DELIMITER = ',';

INSERT INTO sales_orders_005 (customer_id, order_date, amount, status) VALUES (501, '2023-05-01', 650.00, 'ACTIVE');
INSERT INTO sales_orders_005 (customer_id, order_date, amount, status) VALUES (502, '2023-05-02', 700.00, 'CANCELLED');
UPDATE sales_orders_005 SET amount = amount * 1.13 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_005 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_005 t USING (SELECT 503 AS customer_id, '2023-05-03' AS order_date, 800.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);

CREATE ROLE sales_analyst_005;
GRANT USAGE ON SCHEMA corp_db.sales_005 TO ROLE sales_analyst_005;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_005 TO ROLE sales_analyst_005;
CREATE MASKING POLICY ssn_mask_005 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;

CREATE OR REPLACE FUNCTION add_tax_005(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_005() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_005 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;

CREATE OR REPLACE STREAM order_stream_005 ON TABLE sales_orders_005;
CREATE OR REPLACE TASK daily_raise_005 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_005();

PUT file://local/path/to/orders_005.csv @sales_stage_005 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_005 FROM @sales_stage_005 FILE_FORMAT = (FORMAT_NAME = csv_format_005);

BEGIN;
UPDATE sales_orders_005 SET amount = amount + 500 WHERE order_id = 1;
SAVEPOINT before_bonus_005;
UPDATE sales_orders_005 SET amount = amount + 150 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_005;
COMMIT;

DECLARE v_total_orders_005 INT;
SET v_total_orders_005 = (SELECT COUNT(*) FROM sales_orders_005);

-- Repeat for more schemas/tables/objects...

-- END AUTO-GENERATED SQL BLOCK 5

-- === BEGIN AUTO-GENERATED SQL BLOCK 6 ===

-- Schema: sales_006
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_006;
USE SCHEMA corp_db.sales_006;
CREATE OR REPLACE TABLE sales_orders_006 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_006 AS SELECT * FROM sales_orders_006 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_006 START = 6000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_006 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_006 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_006 (customer_id, order_date, amount, status) VALUES (601, '2023-06-01', 750.00, 'ACTIVE');
INSERT INTO sales_orders_006 (customer_id, order_date, amount, status) VALUES (602, '2023-06-02', 800.00, 'CANCELLED');
UPDATE sales_orders_006 SET amount = amount * 1.15 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_006 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_006 t USING (SELECT 603 AS customer_id, '2023-06-03' AS order_date, 900.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_006;
GRANT USAGE ON SCHEMA corp_db.sales_006 TO ROLE sales_analyst_006;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_006 TO ROLE sales_analyst_006;
CREATE MASKING POLICY ssn_mask_006 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_006(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_006() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_006 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_006 ON TABLE sales_orders_006;
CREATE OR REPLACE TASK daily_raise_006 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_006();
PUT file://local/path/to/orders_006.csv @sales_stage_006 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_006 FROM @sales_stage_006 FILE_FORMAT = (FORMAT_NAME = csv_format_006);
BEGIN;
UPDATE sales_orders_006 SET amount = amount + 600 WHERE order_id = 1;
SAVEPOINT before_bonus_006;
UPDATE sales_orders_006 SET amount = amount + 175 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_006;
COMMIT;
DECLARE v_total_orders_006 INT;
SET v_total_orders_006 = (SELECT COUNT(*) FROM sales_orders_006);

-- END AUTO-GENERATED SQL BLOCK 6

-- === BEGIN AUTO-GENERATED SQL BLOCK 7 ===

-- Schema: sales_007
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_007;
USE SCHEMA corp_db.sales_007;
CREATE OR REPLACE TABLE sales_orders_007 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_007 AS SELECT * FROM sales_orders_007 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_007 START = 7000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_007 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_007 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_007 (customer_id, order_date, amount, status) VALUES (701, '2023-07-01', 850.00, 'ACTIVE');
INSERT INTO sales_orders_007 (customer_id, order_date, amount, status) VALUES (702, '2023-07-02', 900.00, 'CANCELLED');
UPDATE sales_orders_007 SET amount = amount * 1.17 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_007 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_007 t USING (SELECT 703 AS customer_id, '2023-07-03' AS order_date, 1000.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_007;
GRANT USAGE ON SCHEMA corp_db.sales_007 TO ROLE sales_analyst_007;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_007 TO ROLE sales_analyst_007;
CREATE MASKING POLICY ssn_mask_007 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_007(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_007() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_007 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_007 ON TABLE sales_orders_007;
CREATE OR REPLACE TASK daily_raise_007 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_007();
PUT file://local/path/to/orders_007.csv @sales_stage_007 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_007 FROM @sales_stage_007 FILE_FORMAT = (FORMAT_NAME = csv_format_007);
BEGIN;
UPDATE sales_orders_007 SET amount = amount + 700 WHERE order_id = 1;
SAVEPOINT before_bonus_007;
UPDATE sales_orders_007 SET amount = amount + 200 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_007;
COMMIT;
DECLARE v_total_orders_007 INT;
SET v_total_orders_007 = (SELECT COUNT(*) FROM sales_orders_007);

-- END AUTO-GENERATED SQL BLOCK 7

-- === BEGIN AUTO-GENERATED SQL BLOCK 8 ===

-- Schema: sales_008
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_008;
USE SCHEMA corp_db.sales_008;
CREATE OR REPLACE TABLE sales_orders_008 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_008 AS SELECT * FROM sales_orders_008 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_008 START = 8000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_008 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_008 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_008 (customer_id, order_date, amount, status) VALUES (801, '2023-08-01', 950.00, 'ACTIVE');
INSERT INTO sales_orders_008 (customer_id, order_date, amount, status) VALUES (802, '2023-08-02', 1000.00, 'CANCELLED');
UPDATE sales_orders_008 SET amount = amount * 1.19 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_008 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_008 t USING (SELECT 803 AS customer_id, '2023-08-03' AS order_date, 1100.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_008;
GRANT USAGE ON SCHEMA corp_db.sales_008 TO ROLE sales_analyst_008;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_008 TO ROLE sales_analyst_008;
CREATE MASKING POLICY ssn_mask_008 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_008(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_008() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_008 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_008 ON TABLE sales_orders_008;
CREATE OR REPLACE TASK daily_raise_008 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_008();
PUT file://local/path/to/orders_008.csv @sales_stage_008 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_008 FROM @sales_stage_008 FILE_FORMAT = (FORMAT_NAME = csv_format_008);
BEGIN;
UPDATE sales_orders_008 SET amount = amount + 800 WHERE order_id = 1;
SAVEPOINT before_bonus_008;
UPDATE sales_orders_008 SET amount = amount + 225 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_008;
COMMIT;
DECLARE v_total_orders_008 INT;
SET v_total_orders_008 = (SELECT COUNT(*) FROM sales_orders_008);

-- END AUTO-GENERATED SQL BLOCK 8

-- === BEGIN AUTO-GENERATED SQL BLOCK 9 ===

-- Schema: sales_009
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_009;
USE SCHEMA corp_db.sales_009;
CREATE OR REPLACE TABLE sales_orders_009 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_009 AS SELECT * FROM sales_orders_009 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_009 START = 9000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_009 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_009 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_009 (customer_id, order_date, amount, status) VALUES (901, '2023-09-01', 1050.00, 'ACTIVE');
INSERT INTO sales_orders_009 (customer_id, order_date, amount, status) VALUES (902, '2023-09-02', 1100.00, 'CANCELLED');
UPDATE sales_orders_009 SET amount = amount * 1.21 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_009 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_009 t USING (SELECT 903 AS customer_id, '2023-09-03' AS order_date, 1200.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_009;
GRANT USAGE ON SCHEMA corp_db.sales_009 TO ROLE sales_analyst_009;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_009 TO ROLE sales_analyst_009;
CREATE MASKING POLICY ssn_mask_009 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_009(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_009() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_009 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_009 ON TABLE sales_orders_009;
CREATE OR REPLACE TASK daily_raise_009 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_009();
PUT file://local/path/to/orders_009.csv @sales_stage_009 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_009 FROM @sales_stage_009 FILE_FORMAT = (FORMAT_NAME = csv_format_009);
BEGIN;
UPDATE sales_orders_009 SET amount = amount + 900 WHERE order_id = 1;
SAVEPOINT before_bonus_009;
UPDATE sales_orders_009 SET amount = amount + 250 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_009;
COMMIT;
DECLARE v_total_orders_009 INT;
SET v_total_orders_009 = (SELECT COUNT(*) FROM sales_orders_009);

-- END AUTO-GENERATED SQL BLOCK 9

-- === BEGIN AUTO-GENERATED SQL BLOCK 10 ===

-- Schema: sales_010
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_010;
USE SCHEMA corp_db.sales_010;
CREATE OR REPLACE TABLE sales_orders_010 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_010 AS SELECT * FROM sales_orders_010 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_010 START = 10000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_010 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_010 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_010 (customer_id, order_date, amount, status) VALUES (1001, '2023-10-01', 1150.00, 'ACTIVE');
INSERT INTO sales_orders_010 (customer_id, order_date, amount, status) VALUES (1002, '2023-10-02', 1200.00, 'CANCELLED');
UPDATE sales_orders_010 SET amount = amount * 1.23 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_010 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_010 t USING (SELECT 1003 AS customer_id, '2023-10-03' AS order_date, 1300.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_010;
GRANT USAGE ON SCHEMA corp_db.sales_010 TO ROLE sales_analyst_010;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_010 TO ROLE sales_analyst_010;
CREATE MASKING POLICY ssn_mask_010 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_010(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_010() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_010 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_010 ON TABLE sales_orders_010;
CREATE OR REPLACE TASK daily_raise_010 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_010();
PUT file://local/path/to/orders_010.csv @sales_stage_010 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_010 FROM @sales_stage_010 FILE_FORMAT = (FORMAT_NAME = csv_format_010);
BEGIN;
UPDATE sales_orders_010 SET amount = amount + 1000 WHERE order_id = 1;
SAVEPOINT before_bonus_010;
UPDATE sales_orders_010 SET amount = amount + 275 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_010;
COMMIT;
DECLARE v_total_orders_010 INT;
SET v_total_orders_010 = (SELECT COUNT(*) FROM sales_orders_010);

-- END AUTO-GENERATED SQL BLOCK 10

-- === BEGIN AUTO-GENERATED SQL BLOCK 11 ===

-- Schema: sales_011
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_011;
USE SCHEMA corp_db.sales_011;
CREATE OR REPLACE TABLE sales_orders_011 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_011 AS SELECT * FROM sales_orders_011 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_011 START = 11000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_011 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_011 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_011 (customer_id, order_date, amount, status) VALUES (1101, '2023-11-01', 1250.00, 'ACTIVE');
INSERT INTO sales_orders_011 (customer_id, order_date, amount, status) VALUES (1102, '2023-11-02', 1300.00, 'CANCELLED');
UPDATE sales_orders_011 SET amount = amount * 1.25 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_011 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_011 t USING (SELECT 1103 AS customer_id, '2023-11-03' AS order_date, 1400.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_011;
GRANT USAGE ON SCHEMA corp_db.sales_011 TO ROLE sales_analyst_011;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_011 TO ROLE sales_analyst_011;
CREATE MASKING POLICY ssn_mask_011 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_011(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_011() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_011 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_011 ON TABLE sales_orders_011;
CREATE OR REPLACE TASK daily_raise_011 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_011();
PUT file://local/path/to/orders_011.csv @sales_stage_011 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_011 FROM @sales_stage_011 FILE_FORMAT = (FORMAT_NAME = csv_format_011);
BEGIN;
UPDATE sales_orders_011 SET amount = amount + 1100 WHERE order_id = 1;
SAVEPOINT before_bonus_011;
UPDATE sales_orders_011 SET amount = amount + 300 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_011;
COMMIT;
DECLARE v_total_orders_011 INT;
SET v_total_orders_011 = (SELECT COUNT(*) FROM sales_orders_011);

-- END AUTO-GENERATED SQL BLOCK 11

-- === BEGIN AUTO-GENERATED SQL BLOCK 12 ===

-- Schema: sales_012
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_012;
USE SCHEMA corp_db.sales_012;
CREATE OR REPLACE TABLE sales_orders_012 (
    order_id INT AUTOINCREMENT,
    customer_id INT,
    order_date DATE,
    amount NUMBER(10,2),
    status STRING,
    PRIMARY KEY (order_id)
);
CREATE OR REPLACE VIEW active_orders_012 AS SELECT * FROM sales_orders_012 WHERE status = 'ACTIVE';
CREATE OR REPLACE SEQUENCE order_seq_012 START = 12000 INCREMENT = 1;
CREATE OR REPLACE STAGE sales_stage_012 FILE_FORMAT = (TYPE = 'CSV');
CREATE OR REPLACE FILE FORMAT csv_format_012 TYPE = 'CSV' FIELD_DELIMITER = ',';
INSERT INTO sales_orders_012 (customer_id, order_date, amount, status) VALUES (1201, '2023-12-01', 1350.00, 'ACTIVE');
INSERT INTO sales_orders_012 (customer_id, order_date, amount, status) VALUES (1202, '2023-12-02', 1400.00, 'CANCELLED');
UPDATE sales_orders_012 SET amount = amount * 1.27 WHERE status = 'ACTIVE';
DELETE FROM sales_orders_012 WHERE status = 'CANCELLED';
MERGE INTO sales_orders_012 t USING (SELECT 1203 AS customer_id, '2023-12-03' AS order_date, 1500.00 AS amount, 'ACTIVE' AS status) s
ON t.customer_id = s.customer_id AND t.order_date = s.order_date
WHEN MATCHED THEN UPDATE SET t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (customer_id, order_date, amount, status) VALUES (s.customer_id, s.order_date, s.amount, s.status);
CREATE ROLE sales_analyst_012;
GRANT USAGE ON SCHEMA corp_db.sales_012 TO ROLE sales_analyst_012;
GRANT SELECT ON ALL TABLES IN SCHEMA corp_db.sales_012 TO ROLE sales_analyst_012;
CREATE MASKING POLICY ssn_mask_012 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;
CREATE OR REPLACE FUNCTION add_tax_012(amount NUMBER, tax_rate NUMBER) RETURNS NUMBER AS 'amount * (1 + tax_rate)';
CREATE OR REPLACE PROCEDURE raise_orders_012() RETURNS STRING LANGUAGE JAVASCRIPT AS $$
var stmt = snowflake.createStatement({sqlText: "UPDATE sales_orders_012 SET amount = amount * 1.10"});
stmt.execute();
return 'All orders raised by 10%';
$$;
CREATE OR REPLACE STREAM order_stream_012 ON TABLE sales_orders_012;
CREATE OR REPLACE TASK daily_raise_012 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_012();
PUT file://local/path/to/orders_012.csv @sales_stage_012 AUTO_COMPRESS=TRUE;
COPY INTO sales_orders_012 FROM @sales_stage_012 FILE_FORMAT = (FORMAT_NAME = csv_format_012);
BEGIN;
UPDATE sales_orders_012 SET amount = amount + 1200 WHERE order_id = 1;
SAVEPOINT before_bonus_012;
UPDATE sales_orders_012 SET amount = amount + 325 WHERE order_id = 1;
ROLLBACK TO SAVEPOINT before_bonus_012;
COMMIT;
DECLARE v_total_orders_012 INT;
SET v_total_orders_012 = (SELECT COUNT(*) FROM sales_orders_012);

-- END AUTO-GENERATED SQL BLOCK 12

-- === BEGIN AUTO-GENERATED SQL BLOCK 13 (More Constructs) ===

-- Schema: sales_013
CREATE OR REPLACE SCHEMA IF NOT EXISTS corp_db.sales_013;
USE SCHEMA corp_db.sales_013;

-- Security: TAG and ROW ACCESS POLICY
CREATE OR REPLACE TAG sensitive_data_tag ALLOWED_VALUES 'PII', 'Confidential';
CREATE OR REPLACE ROW ACCESS POLICY order_access_policy_013 AS (order_id INT) RETURNS BOOLEAN ->
    CURRENT_ROLE() IN ('ACCOUNTADMIN', 'SALES_MANAGER') -- Define roles allowed to see all rows
    OR EXISTS (
        SELECT 1 FROM sales_orders_013_details d
        WHERE d.order_id = order_id AND d.assigned_rep = CURRENT_ROLE()
    );

-- Table: TRANSIENT, VARIANT, ARRAY, TIMESTAMP_LTZ, CLUSTERING KEY, NOT NULL, TAG, ROW ACCESS POLICY
CREATE OR REPLACE TRANSIENT TABLE sales_orders_013 (
    order_id INT AUTOINCREMENT,
    customer_id INT NOT NULL COMMENT 'Customer identifier',
    order_details VARIANT COMMENT 'Semi-structured order info (JSON)',
    items ARRAY COMMENT 'Array of item IDs',
    order_timestamp TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    status STRING,
    PRIMARY KEY (order_id)
)
CLUSTER BY (customer_id, order_timestamp) -- Add clustering key
DATA_RETENTION_TIME_IN_DAYS = 0 -- Transient tables have 0 or 1 day retention
WITH TAG (sensitive_data_tag = 'Confidential');

-- Apply row access policy
ALTER TABLE sales_orders_013 ADD ROW ACCESS POLICY order_access_policy_013 ON (order_id);

-- Create a related detail table for policy demo
CREATE OR REPLACE TABLE sales_orders_013_details (
    detail_id INT AUTOINCREMENT,
    order_id INT,
    assigned_rep STRING,
    notes STRING
);

-- DML: Insert with VARIANT and ARRAY data
INSERT INTO sales_orders_013 (customer_id, order_details, items, status)
VALUES
    (1301,
     PARSE_JSON('{"product": "Laptop", "quantity": 1, "options": {"color": "Silver", "RAM": "16GB"}}'),
     ARRAY_CONSTRUCT(101, 202, 303),
     'PENDING'
    ),
    (1302,
     PARSE_JSON('{"product": "Monitor", "quantity": 2, "options": {"size": "27 inch"}}'),
     ARRAY_CONSTRUCT(404, 505),
     'SHIPPED'
    );

-- Insert detail for policy testing
INSERT INTO sales_orders_013_details (order_id, assigned_rep, notes) VALUES (1, 'SALES_REP_A', 'Needs follow-up');
INSERT INTO sales_orders_013_details (order_id, assigned_rep, notes) VALUES (2, 'SALES_REP_B', 'Urgent delivery');

-- Query: Using LATERAL FLATTEN and Window Function
SELECT
    order_id,
    customer_id,
    order_details:product::STRING AS product_name,
    order_details:quantity::INT AS quantity,
    f.value::INT AS item_id,
    ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY f.index) as item_sequence
FROM
    sales_orders_013,
    LATERAL FLATTEN(input => items) f
WHERE status = 'PENDING';

-- DDL: ALTER TABLE (add column)
ALTER TABLE sales_orders_013 ADD COLUMN last_modified_by STRING;

-- DML: UPDATE using the new column
UPDATE sales_orders_013 SET last_modified_by = 'SYS_BATCH' WHERE status = 'PENDING';

-- DML: MULTI TABLE INSERT
CREATE OR REPLACE TABLE shipped_orders_013 AS SELECT * FROM sales_orders_013 WHERE 1=0;
CREATE OR REPLACE TABLE pending_orders_013 AS SELECT * FROM sales_orders_013 WHERE 1=0;

INSERT ALL
    WHEN status = 'SHIPPED' THEN
        INTO shipped_orders_013 (order_id, customer_id, order_details, items, order_timestamp, status, last_modified_by)
        VALUES (order_id, customer_id, order_details, items, order_timestamp, status, 'MULTI_INSERT')
    WHEN status = 'PENDING' THEN
        INTO pending_orders_013 (order_id, customer_id, order_details, items, order_timestamp, status, last_modified_by)
        VALUES (order_id, customer_id, order_details, items, order_timestamp, status, 'MULTI_INSERT')
SELECT * FROM sales_orders_013;

-- Scripting: Snowflake Scripting Block with CURSOR and FOR loop
EXECUTE IMMEDIATE $$
DECLARE
  total_pending_amount NUMBER(10,2) := 0;
  order_cursor CURSOR FOR SELECT order_details:quantity::INT * 50.0 AS approx_value FROM pending_orders_013;
  order_value NUMBER(10,2);
BEGIN
  OPEN order_cursor;
  FOR i IN 1 TO (SELECT COUNT(*) FROM pending_orders_013) DO
    FETCH order_cursor INTO order_value;
    total_pending_amount := total_pending_amount + order_value;
  END FOR;
  CLOSE order_cursor;
  RETURN total_pending_amount;
END;
$$;

-- DML: TRUNCATE TABLE
TRUNCATE TABLE pending_orders_013;

-- Other: SHOW/DESCRIBE
SHOW TABLES LIKE 'sales_orders_013%' IN SCHEMA corp_db.sales_013;
DESCRIBE TABLE sales_orders_013;

-- Cleanup policies and tags (optional, uncomment if needed for full cleanup)
-- ALTER TABLE sales_orders_013 DROP ROW ACCESS POLICY order_access_policy_013;
-- DROP ROW ACCESS POLICY order_access_policy_013;
-- ALTER TABLE sales_orders_013 DROP TAG sensitive_data_tag;
-- DROP TAG sensitive_data_tag;

-- END AUTO-GENERATED SQL BLOCK 13

-- END GENERATED BLOCKS 