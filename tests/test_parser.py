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

def test_parse_valid_create():
    """Test parsing a valid CREATE TABLE statement."""
    tree = parse_sql(VALID_SQL_CREATE)
    assert isinstance(tree, Tree), "Parsing valid CREATE SQL should return a Tree."
    # print(tree.pretty())

def test_parse_invalid_sql():
    """Test parsing invalid SQL (should return None)."""
    # The current parse_sql catches LarkError and returns None
    tree = parse_sql(INVALID_SQL)
    assert tree is None, "Parsing invalid SQL should return None."

# TODO: Add tests for more complex SQL statements supported by the grammar
# TODO: Add tests for parsing errors (e.g., specific LarkError types if needed)
# Consider using pytest parametrize for multiple valid/invalid cases

if __name__ == '__main__':
    pytest.main() 