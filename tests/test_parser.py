"""
Tests for the parser core module using pytest.
"""

import pytest
from lark import Tree

# Ensure imports work from the root directory perspective when running tests
from sql_analyzer.parser.core import parse_sql, sql_parser

# Basic SQL test cases
VALID_SQL_SELECT = "SELECT column1, column2 FROM schema1.table_name WHERE condition = 1;"
VALID_SQL_CREATE = "CREATE OR REPLACE TABLE my_db.my_schema.my_table (id INT, name VARCHAR);"
INVALID_SQL = "SELECT FROM WHERE;"

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
    """Test parsing invalid SQL (should return None)."""
    # The current parse_sql catches LarkError and returns None
    tree = parse_sql(INVALID_SQL)
    assert tree is None, "Parsing invalid SQL should return None."

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

if __name__ == '__main__':
    pytest.main() 