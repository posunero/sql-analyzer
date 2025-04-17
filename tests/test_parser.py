"""
Tests for the parser core module using pytest.
"""

import pytest
from lark import Tree, LarkError

# Ensure imports work from the root directory perspective when running tests
from sql_analyzer.parser.core import parse_sql, sql_parser

# Basic SQL test cases
VALID_SQL_SELECT = "SELECT column1, column2 FROM schema1.table_name WHERE condition = 1;"
VALID_SQL_CREATE = "CREATE OR REPLACE TABLE my_db.my_schema.my_table (id INT, name VARCHAR);"
# INVALID_SQL = "SELECT FROM WHERE;"  # This is actually syntactically valid but semantically wrong
INVALID_SQL = "THIS IS NOT SQL AT ALL !@#$%"  # This will definitely cause a parsing error

def test_parser_loaded():
    """Test if the sql_parser object is loaded (not None)."""
    assert sql_parser is not None, "SQL parser object should be loaded."

def test_parse_valid_select():
    """Test parsing a valid SELECT statement."""
    tree = parse_sql(VALID_SQL_SELECT)
    assert isinstance(tree, Tree), "Parsing valid SELECT SQL should return a Tree."
    # Add more specific assertions about the tree structure if needed
    # print(tree.pretty())

def test_parse_valid_create_table():
    """Test parsing a valid CREATE TABLE statement."""
    tree = parse_sql(VALID_SQL_CREATE)
    assert isinstance(tree, Tree), "Parsing valid CREATE TABLE SQL should return a Tree."
    # print(tree.pretty())

def test_parse_invalid_sql():
    """Test parsing invalid SQL (should raise LarkError)."""
    # Updated: parse_sql now re-raises LarkError
    # Revert back to pytest.raises
    with pytest.raises(LarkError):
        parse_sql(INVALID_SQL)
    # assert tree is None, "Parsing invalid SQL should return None." # Old assertion

# --- Parameterized Tests for Common Statement Structures ---

# Object types for DROP, DESCRIBE, USE statements
OBJECT_TYPES = [
    "TABLE", "VIEW", "WAREHOUSE", "TASK", "STREAM", "STAGE",
    "DATABASE", "SCHEMA", "PROCEDURE", "FUNCTION", "SEQUENCE"
]
OBJECT_TYPES_FOR_SHOW = [
    "TABLES", "VIEWS", "WAREHOUSES", "TASKS", "STREAMS", "STAGES",
    "DATABASES", "SCHEMAS"
]
OBJECT_TYPES_FOR_USE = ["WAREHOUSE", "DATABASE", "SCHEMA"]

@pytest.mark.parametrize("obj_type", OBJECT_TYPES)
def test_parse_drop_statements(obj_type):
    """Test parsing DROP statements for various object types."""
    sql = f"DROP {obj_type} my_object_name;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing DROP {obj_type} should return a Tree."

@pytest.mark.parametrize("obj_type", OBJECT_TYPES_FOR_SHOW)
def test_parse_show_statements(obj_type):
    """Test parsing SHOW statements for various object types."""
    sql = f"SHOW {obj_type};"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing SHOW {obj_type} should return a Tree."

@pytest.mark.parametrize("obj_type", OBJECT_TYPES)
def test_parse_describe_statements(obj_type):
    """Test parsing DESCRIBE/DESC statements for various object types."""
    sql_desc = f"DESC {obj_type} my_object_name;"
    sql_describe = f"DESCRIBE {obj_type} my_object_name;"
    tree_desc = parse_sql(sql_desc)
    tree_describe = parse_sql(sql_describe)
    assert isinstance(tree_desc, Tree), f"Parsing DESC {obj_type} should return a Tree."
    assert isinstance(tree_describe, Tree), f"Parsing DESCRIBE {obj_type} should return a Tree."

@pytest.mark.parametrize("obj_type", OBJECT_TYPES_FOR_USE)
def test_parse_use_statements(obj_type):
    """Test parsing USE statements for various object types."""
    sql = f"USE {obj_type} my_object_name;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing USE {obj_type} should return a Tree."


# --- Individual Tests for Other Statement Types ---

@pytest.mark.parametrize("sql", [
    "INSERT INTO tbl1 (col1, col2) VALUES ('val1', 123);",
    "INSERT INTO tbl1 (col1) SELECT other_col FROM other_tbl WHERE id > 5;"
])
def test_parse_insert(sql):
    """Test parsing INSERT statements (VALUES and SELECT variants)."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing INSERT SQL should return a Tree. SQL: {sql}"

def test_parse_update():
    """Test parsing UPDATE statement."""
    sql = "UPDATE db1.sch1.tbl1 SET col1 = 'new', col2 = col2 + 1 WHERE id = 10;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing UPDATE SQL should return a Tree."

def test_parse_delete():
    """Test parsing DELETE statement."""
    sql = "DELETE FROM sch1.tbl1 WHERE date_col < '2023-01-01';"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DELETE SQL should return a Tree."

def test_parse_create_view():
    """Test parsing CREATE VIEW statement."""
    sql = "CREATE VIEW v1 AS SELECT c1, c2 FROM tbl1 JOIN tbl2 USING (id);"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE VIEW SQL should return a Tree."

def test_parse_create_warehouse():
    """Test parsing CREATE WAREHOUSE statement."""
    sql = "CREATE WAREHOUSE IF NOT EXISTS wh1 WAREHOUSE_SIZE = 'SMALL' AUTO_SUSPEND = 600 AUTO_RESUME = TRUE;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE WAREHOUSE SQL should return a Tree."

def test_parse_create_task():
    """Test parsing CREATE TASK statement."""
    sql = "CREATE OR REPLACE TASK my_task WAREHOUSE = my_wh SCHEDULE = 'USING CRON 0 5 * * * UTC' AS INSERT INTO log_tbl VALUES (CURRENT_TIMESTAMP());"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TASK SQL should return a Tree."

def test_parse_create_stream():
    """Test parsing CREATE STREAM statement."""
    sql = "CREATE STREAM my_stream ON TABLE source_tbl APPEND_ONLY = TRUE;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE STREAM SQL should return a Tree."

def test_parse_create_stage():
    """Test parsing CREATE STAGE statement."""
    sql = "CREATE STAGE my_stage URL = 's3://mybucket/load/' FILE_FORMAT = ( TYPE = 'CSV' FIELD_DELIMITER = '|' );"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE STAGE SQL should return a Tree."

def test_parse_create_database():
    """Test parsing CREATE DATABASE statement."""
    sql = "CREATE DATABASE IF NOT EXISTS db_test;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE DATABASE SQL should return a Tree."

def test_parse_create_schema():
    """Test parsing CREATE SCHEMA statement."""
    sql = "CREATE OR REPLACE SCHEMA db1.sch_test;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE SCHEMA SQL should return a Tree."

@pytest.mark.parametrize("sql", [
    "ALTER TABLE tbl1 ADD COLUMN col_new DATE;",
    "ALTER TABLE db1.sch1.tbl1 DROP COLUMN col_old;",
    "ALTER TABLE tbl1 MODIFY COLUMN existing_col VARCHAR(100);"
])
def test_parse_alter_table(sql):
    """Test parsing ALTER TABLE statements."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing ALTER TABLE SQL should return a Tree. SQL: {sql}"

@pytest.mark.parametrize("sql", [
    "ALTER WAREHOUSE wh1 SET WAREHOUSE_SIZE = 'LARGE' AUTO_RESUME = FALSE;",
    "ALTER WAREHOUSE my_other_wh SUSPEND;",
    "ALTER WAREHOUSE my_other_wh RESUME;"
])
def test_parse_alter_warehouse(sql):
    """Test parsing ALTER WAREHOUSE statements."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing ALTER WAREHOUSE SQL should return a Tree. SQL: {sql}"

@pytest.mark.parametrize("sql", [
    "ALTER TASK my_task SET SCHEDULE = 'USING CRON 0 6 * * * UTC';",
    "ALTER TASK some_task SUSPEND;",
    "ALTER TASK some_task RESUME;"
])
def test_parse_alter_task(sql):
    """Test parsing ALTER TASK statements."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing ALTER TASK SQL should return a Tree. SQL: {sql}"

def test_parse_alter_stream():
    """Test parsing ALTER STREAM statement."""
    sql = "ALTER STREAM my_stream SET APPEND_ONLY = FALSE;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER STREAM SQL should return a Tree."

def test_parse_truncate():
    """Test parsing TRUNCATE TABLE statement."""
    sql = "TRUNCATE TABLE db1.sch1.temp_table;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing TRUNCATE TABLE SQL should return a Tree."

# --- Tests for Specific Syntax Edge Cases --- 

def test_parse_autoincrement_columns():
    """Test parsing CREATE TABLE with AUTOINCREMENT/IDENTITY columns."""
    sql_variants = [
        "CREATE TABLE test_autoinc (id INT AUTOINCREMENT);",
        "CREATE TABLE test_autoinc (id INT AUTOINCREMENT START 100 INCREMENT 5);",
        "CREATE TABLE test_identity (id INT IDENTITY);",
        "CREATE TABLE test_identity_params (id INT IDENTITY START 1 INCREMENT 1, name STRING);"
    ]
    for sql in sql_variants:
        tree = parse_sql(sql)
        assert isinstance(tree, Tree), f"Parsing AUTOINCREMENT/IDENTITY SQL failed for: {sql}"

def test_parse_add_column_with_default():
    """Test parsing ALTER TABLE ADD COLUMN with a DEFAULT clause."""
    sql_variants = [
        "ALTER TABLE my_table ADD COLUMN new_col VARCHAR DEFAULT 'N/A';",
        "ALTER TABLE db.schema.events ADD COLUMN processed_flag BOOLEAN DEFAULT FALSE;",
        "ALTER TABLE users ADD COLUMN created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP();"
    ]
    for sql in sql_variants:
        tree = parse_sql(sql)
        assert isinstance(tree, Tree), f"Parsing ADD COLUMN WITH DEFAULT failed for: {sql}"

def test_parse_alter_table_rename():
    """Test parsing ALTER TABLE RENAME COLUMN and RENAME TO statements."""
    sql_variants = [
        "ALTER TABLE my_table RENAME COLUMN old_name TO new_name;",
        "ALTER TABLE db1.sch1.old_table_name RENAME TO new_table_name;"
    ]
    for sql in sql_variants:
        tree = parse_sql(sql)
        assert isinstance(tree, Tree), f"Parsing ALTER TABLE RENAME failed for: {sql}"

def test_parse_create_function():
    """Test parsing various CREATE FUNCTION statements."""
    sql_variants = [
        "CREATE FUNCTION simple_udf() RETURNS FLOAT AS '3.14::FLOAT';",
        "CREATE OR REPLACE FUNCTION add_ints(a INT, b INT DEFAULT 5) RETURNS INT LANGUAGE SQL AS 'a + b';",
        "CREATE SECURE FUNCTION my_js_udf(d double) RETURNS double LANGUAGE JAVASCRIPT STRICT AS \'return D * 2;\';",
        "CREATE FUNCTION my_python_udf(x int) RETURNS int LANGUAGE PYTHON RUNTIME_VERSION = '3.8' HANDLER = 'handler_module.process' AS \'...\';",
        "CREATE FUNCTION my_java_udf(x VARCHAR) RETURNS VARCHAR LANGUAGE JAVA HANDLER = 'MyClass.method' IMPORTS = ('@stage/myjar.jar');",
        "CREATE FUNCTION my_scala_udf() RETURNS TABLE (col_a INT, col_b STRING) LANGUAGE SCALA HANDLER = 'MyObject.tableMethod';",
        "CREATE FUNCTION udf_with_comment(x INT) RETURNS INT COMMENT = 'A sample comment' AS 'x+1';",
        "CREATE TEMP FUNCTION temporary_func(i int) RETURNS int LANGUAGE SQL AS 'i*i';"
    ]
    for sql in sql_variants:
        tree = parse_sql(sql)
        assert isinstance(tree, Tree), f"Parsing CREATE FUNCTION failed for: {sql}"

# --- Tests for Parsing Specific Fixture Files ---

@pytest.mark.parametrize("fixture_file", [
    "tests/fixtures/valid/complex_mix.sql",
    "tests/fixtures/valid/complex_select.sql",
    "tests/fixtures/valid/function_and_procedure.sql",
    "tests/fixtures/invalid/syntax_error.sql" # Include invalid to test error handling
])
def test_parse_fixture_files(fixture_file):
    """Test parsing specific SQL files from the fixtures directory."""
    from pathlib import Path
    file_path = Path(fixture_file)
    assert file_path.exists(), f"Fixture file not found: {fixture_file}"
    
    sql_content = file_path.read_text()
    
    if "invalid" in fixture_file:
        with pytest.raises(LarkError):
            parse_sql(sql_content)
    else:
        try:
            tree = parse_sql(sql_content)
            assert isinstance(tree, Tree), f"Parsing valid fixture {fixture_file} should return a Tree."
        except LarkError as e:
            pytest.fail(f"Parsing valid fixture {fixture_file} raised LarkError unexpectedly: {e}")

def test_parse_use_role():
    sql = "USE ROLE SYSADMIN;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing USE ROLE should return a Tree."

def test_parse_create_database_with_comment():
    sql = "CREATE OR REPLACE DATABASE corp_db COMMENT='Corporate Data';"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE DATABASE with COMMENT should return a Tree."

def test_parse_create_resource_monitor_with_triggers():
    sql = "CREATE OR REPLACE RESOURCE MONITOR rm1 WITH CREDIT_QUOTA=1000 TRIGGERS ON 80 PERCENT DO NOTIFY;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE RESOURCE MONITOR with TRIGGERS should return a Tree."

def test_parse_create_table_with_table_pk():
    sql = "CREATE OR REPLACE TABLE orders (order_id INT, PRIMARY KEY (order_id));"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TABLE with table-level PRIMARY KEY should return a Tree."

def test_parse_create_sequence():
    sql = "CREATE OR REPLACE SEQUENCE order_seq_003 START = 3000 INCREMENT = 1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE SEQUENCE should return a Tree."

def test_parse_create_file_format():
    sql = "CREATE OR REPLACE FILE FORMAT csv_format_003 TYPE = 'CSV' FIELD_DELIMITER = ',';"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE FILE FORMAT should return a Tree."

def test_parse_create_role():
    sql = "CREATE ROLE sales_analyst_001;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE ROLE should return a Tree."

def test_parse_create_masking_policy():
    sql = "CREATE MASKING POLICY ssn_mask_001 AS (VAL STRING) RETURNS STRING -> CASE WHEN CURRENT_ROLE() IN ('HR_ADMIN') THEN VAL ELSE 'XXX-XX-XXXX' END;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE MASKING POLICY should return a Tree."

def test_parse_create_task_with_call():
    sql = "CREATE OR REPLACE TASK daily_raise_001 WAREHOUSE = analytics_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS CALL raise_orders_001();"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TASK with CALL procedure should return a Tree."

def test_parse_put_statement():
    sql = "PUT file://local/path/to/orders_001.csv @sales_stage_001 AUTO_COMPRESS=TRUE;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing PUT statement should return a Tree."

def test_parse_begin():
    sql = "BEGIN;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing BEGIN should return a Tree."

def test_parse_commit():
    sql = "COMMIT;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing COMMIT should return a Tree."

def test_parse_rollback():
    sql = "ROLLBACK;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ROLLBACK should return a Tree."

def test_parse_savepoint():
    sql = "SAVEPOINT before_bonus_001;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SAVEPOINT should return a Tree."

def test_parse_rollback_to_savepoint():
    sql = "ROLLBACK TO SAVEPOINT before_bonus_001;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ROLLBACK TO SAVEPOINT should return a Tree."

def test_parse_declare():
    sql = "DECLARE v_total_orders_001 INT;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DECLARE should return a Tree."

def test_parse_set():
    sql = "SET v_total_orders_001 = (SELECT COUNT(*) FROM sales_orders_001);"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SET should return a Tree."

def test_parse_select_count_star():
    sql = "SELECT COUNT(*) FROM t;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SELECT COUNT(*) should return a Tree."

def test_parse_set_with_count_star():
    sql = "SET x = (SELECT COUNT(*) FROM t);"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SET with COUNT(*) should return a Tree."

def test_parse_create_tag():
    """Test parsing CREATE TAG statement with ALLOWED_VALUES and COMMENT."""
    sql = "CREATE OR REPLACE TAG my_tag ALLOWED_VALUES 'A', 'B', 'C' COMMENT = 'Test tag';"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TAG SQL should return a Tree."

def test_parse_create_row_access_policy():
    """Test parsing CREATE ROW ACCESS POLICY statement."""
    sql = """
    CREATE OR REPLACE ROW ACCESS POLICY rap_test AS (empl_id VARCHAR) RETURNS BOOLEAN ->
        CASE WHEN 'it_admin' = CURRENT_ROLE() THEN TRUE ELSE FALSE END
        COMMENT = 'Allow IT admin to see rows';
    """
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE ROW ACCESS POLICY SQL should return a Tree."

def test_parse_in_tuple():
    sql = "SELECT 1 WHERE 'foo' IN ('foo', 'bar', 'baz');"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing IN with tuple of literals should return a Tree."

def test_parse_create_transient_table_with_options():
    sql = (
        "CREATE OR REPLACE TRANSIENT TABLE t1 ("
        "id INT, name STRING, PRIMARY KEY (id)"
        ") CLUSTER BY (id, name) DATA_RETENTION_TIME_IN_DAYS = 0 WITH TAG (my_tag = 'foo', another_tag = 'bar');"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TRANSIENT TABLE with options should return a Tree."

def test_parse_create_table_with_column_comment():
    sql = (
        "CREATE TABLE t2 ("
        "id INT COMMENT 'Primary key',"
        "name STRING COMMENT 'User name',"
        "age INT"
        ");"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TABLE with column COMMENT should return a Tree."

def test_parse_create_table_with_cluster_by_expr():
    sql = (
        "CREATE TABLE t3 (id INT, region STRING) "
        "CLUSTER BY (id, UPPER(region));"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TABLE with CLUSTER BY expr should return a Tree."

def test_parse_create_table_as_select():
    sql = (
        "CREATE TABLE t4 AS SELECT * FROM t1 WHERE x > 0;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TABLE AS SELECT (CTAS) should return a Tree."

def test_parse_alter_table_add_row_access_policy():
    sql = (
        "ALTER TABLE t1 ADD ROW ACCESS POLICY my_policy ON (col1, col2);"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER TABLE ADD ROW ACCESS POLICY should return a Tree."

def test_parse_alter_table_drop_row_access_policy():
    sql = "ALTER TABLE t1 DROP ROW ACCESS POLICY;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER TABLE DROP ROW ACCESS POLICY should return a Tree."

def test_parse_alter_table_rename_row_access_policy():
    sql = "ALTER TABLE t1 RENAME ROW ACCESS POLICY TO new_policy;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER TABLE RENAME ROW ACCESS POLICY should return a Tree."

def test_parse_select_with_window_function():
    sql = (
        "SELECT id, ROW_NUMBER() OVER (PARTITION BY region ORDER BY id) AS rn FROM t1;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SELECT with window function should return a Tree."

def test_parse_select_with_lateral_flatten():
    sql = (
        "SELECT * FROM t1, LATERAL FLATTEN(input => items) f;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SELECT with LATERAL FLATTEN should return a Tree."

def test_parse_select_with_lateral_flatten_named_arg():
    sql = (
        "SELECT * FROM t1, LATERAL FLATTEN(input => items) f;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing LATERAL FLATTEN with named argument should return a Tree."

def test_parse_insert_all_multi_table():
    sql = (
        "INSERT ALL "
        "WHEN x = 1 THEN INTO t1 (a, b) VALUES (1, 2) "
        "WHEN x = 2 THEN INTO t2 (a, b) VALUES (3, 4) "
        "SELECT * FROM src;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing multi-table INSERT ALL should return a Tree."

def test_parse_execute_immediate():
    sql = (
        "EXECUTE IMMEDIATE $$"
        "DECLARE msg STRING; BEGIN msg := 'Hello'; RETURN msg; END;"
        "$$;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing EXECUTE IMMEDIATE should return a Tree."

def test_parse_show_tables_like_in_schema():
    sql = "SHOW TABLES LIKE 'sales%orders%' IN SCHEMA corp_db.sales_013;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing SHOW TABLES LIKE ... IN SCHEMA should return a Tree."

@pytest.mark.parametrize("sql", [
    "CREATE FILE FORMAT csv_fmt TYPE = 'CSV' FIELD_DELIMITER = ',';",
    "CREATE FILE FORMAT json_fmt TYPE = 'JSON';",
    "CREATE FILE FORMAT parquet_fmt TYPE = 'PARQUET';",
    "CREATE STAGE mystage1 URL = 's3://bucket/data/' FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = '|');",
    "CREATE STAGE mystage2 FILE_FORMAT = csv_fmt;",
    "CREATE STAGE mystage3 URL = 'azure://container/data/';",
    "COPY INTO mytable FROM @mystage1 FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = '|');",
    "COPY INTO mytable2 FROM @mystage2 FILE_FORMAT = (FORMAT_NAME = csv_fmt);",
    "COPY INTO mytable3 FROM @mystage3;",
    "COPY INTO @mystage1 FROM mytable;",
    "COPY INTO mytable4 FROM (SELECT * FROM @mystage2 WHERE col1 > 10) FILE_FORMAT = (FORMAT_NAME = csv_fmt);"
])
def test_parse_stage_fileformat_copyinto_variants(sql):
    """Test parsing of CREATE STAGE, CREATE FILE FORMAT, and COPY INTO variants."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing SQL should return a Tree. SQL: {sql}"


def test_parse_stage_fileformat_copyinto_fixture():
    """Test parsing the full stage_fileformat_copyinto.sql fixture."""
    fixture_path = "tests/fixtures/valid/stage_fileformat_copyinto.sql"
    with open(fixture_path) as f:
        sql = f.read()
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing the stage_fileformat_copyinto.sql fixture should return a Tree."

def test_parse_stage_fileformat_copyinto_invalid_fixture():
    """Test parsing the invalid stage_fileformat_copyinto_invalid.sql fixture raises errors or fails."""
    fixture_path = "tests/fixtures/invalid/stage_fileformat_copyinto_invalid.sql"
    with open(fixture_path) as f:
        sql = f.read()
    from lark import LarkError
    import pytest
    with pytest.raises(LarkError):
        parse_sql(sql)

def test_parse_drop_task():
    """Test parsing DROP TASK statement specifically."""
    sql = "DROP TASK IF EXISTS my_task;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DROP TASK should return a Tree."

def test_parse_task_multiple_after_dependencies():
    """Test parsing ALTER TASK ADD AFTER with multiple dependencies."""
    sql = "ALTER TASK multi_dep_task ADD AFTER base_task, another_task, schema2.third_task;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER TASK with multiple AFTER dependencies should return a Tree."

def test_parse_task_cte_as_clause():
    """Test parsing CREATE TASK with CTEs in AS clause."""
    sql = (
        "CREATE OR REPLACE TASK cte_task WAREHOUSE = wh_cte AS "
        "WITH base AS (SELECT id, value FROM raw_data), "
        "filtered AS (SELECT id, value FROM base WHERE value > 100) "
        "INSERT INTO processed_data SELECT id, value FROM filtered;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TASK with CTE AS clause should return a Tree."

def test_parse_task_merge_delete_as_clause():
    """Test parsing CREATE TASK with MERGE DELETE in AS clause."""
    sql = (
        "CREATE OR REPLACE TASK delete_task WAREHOUSE = wh_del AS "
        "MERGE INTO target_table t USING source_table s ON t.id = s.id "
        "WHEN MATCHED THEN DELETE;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE TASK with MERGE DELETE AS clause should return a Tree."

if __name__ == '__main__':
    pytest.main() 