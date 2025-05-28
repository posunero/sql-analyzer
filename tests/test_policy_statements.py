"""
Tests for policy-related SQL statements (ROW ACCESS POLICY, MASKING POLICY, etc.)
"""

import pytest
from lark import Tree
from sql_analyzer.parser.core import parse_sql


@pytest.mark.parametrize("sql", [
    "DESC ROW ACCESS POLICY my_policy;",
    "DESCRIBE ROW ACCESS POLICY my_policy;",
    "DESC MASKING POLICY email_mask;",
    "DESCRIBE MASKING POLICY email_mask;",
])
def test_describe_policy_statements(sql):
    """Test parsing DESCRIBE/DESC statements for policies."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing {sql} should return a Tree."


@pytest.mark.parametrize("sql", [
    "DROP ROW ACCESS POLICY my_policy;",
    "DROP MASKING POLICY email_mask;",
])
def test_drop_policy_statements(sql):
    """Test parsing DROP statements for policies."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing {sql} should return a Tree."


def test_describe_iceberg_table():
    """Test parsing DESCRIBE ICEBERG TABLE statement."""
    sql = "DESCRIBE ICEBERG TABLE my_iceberg_table;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DESCRIBE ICEBERG TABLE should return a Tree."


@pytest.mark.parametrize("sql", [
    "DESC ROW ACCESS POLICY schema1.my_policy;",
    "DESCRIBE MASKING POLICY db1.schema1.email_mask;",
    "DROP ROW ACCESS POLICY IF EXISTS my_policy;",
    "DROP MASKING POLICY IF EXISTS email_mask;",
])
def test_policy_statements_with_qualifiers(sql):
    """Test parsing policy statements with schema qualifiers and IF EXISTS."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing {sql} should return a Tree." 