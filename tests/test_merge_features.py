import pytest
from lark import Tree

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine


def analyze_sql(sql: str):
    """Helper to parse and analyze SQL and return the AnalysisResult."""
    tree = parse_sql(sql)
    engine = AnalysisEngine()
    return engine.analyze(tree)


@ pytest.mark.parametrize("sql", [
    # Simple MERGE with update only
    "MERGE INTO target_table USING source_table ON target_table.id = source_table.id WHEN MATCHED THEN UPDATE SET target_table.col1 = source_table.col1;",
    # MERGE with alias and delete
    "MERGE INTO target_table t USING source_table s ON t.id = s.id WHEN MATCHED AND t.col2 > 100 THEN DELETE;",
    # MERGE with insert VALUES
    "MERGE INTO schema.target AS t USING (SELECT id, col1 FROM schema.source) AS s ON t.id = s.id WHEN NOT MATCHED THEN INSERT (id, col1) VALUES (s.id, s.col1);",
    # MERGE with update, where clause, and insert SELECT
    "MERGE INTO target USING source ON target.id = source.id WHEN MATCHED THEN UPDATE SET col1 = source.col1, col2 = 2 WHERE col2 < 10 WHEN NOT MATCHED AND source.col3 IS NOT NULL THEN INSERT (col1, col2) SELECT col1, col2 FROM other_table;",
    # MERGE without alias for source
    "MERGE INTO t USING s ON t.id = s.id WHEN NOT MATCHED THEN INSERT VALUES (1, 'a');"
])

def test_parse_merge_variants(sql):
    """Test parsing of various MERGE statement variants."""
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing MERGE SQL should return a Tree. SQL: {sql}"


def test_analyze_merge_simple():
    """Test analysis of a simple MERGE with update and insert clauses."""
    sql = (
        "MERGE INTO tgt USING src ON tgt.id = src.id "
        "WHEN MATCHED THEN UPDATE SET tgt.col = src.col "
        "WHEN NOT MATCHED THEN INSERT (col) VALUES (src.col);"
    )
    result = analyze_sql(sql)
    # MERGE statement should be recorded
    assert result.statement_counts.get('MERGE', 0) == 1, "MERGE statement count should be 1"
    # UPDATE action on target
    assert any(o.object_type == 'TABLE' and o.name == 'tgt' and o.action == 'UPDATE' for o in result.objects_found), "UPDATE on target not detected"
    # INSERT action on target
    assert any(o.object_type == 'TABLE' and o.name == 'tgt' and o.action == 'INSERT' for o in result.objects_found), "INSERT on target not detected"
    # SELECT action on source
    assert any(o.object_type == 'TABLE' and o.name == 'src' and o.action == 'SELECT' for o in result.objects_found), "SELECT on source not detected"


def test_analyze_merge_insert_select():
    """Test analysis of MERGE with INSERT ... SELECT clause."""
    sql = (
        "MERGE INTO target AS t USING source AS s ON t.id = s.id "
        "WHEN NOT MATCHED THEN INSERT (id, col) SELECT col1, col2 FROM other;"
    )
    result = analyze_sql(sql)
    # Should detect MERGE
    assert result.statement_counts.get('MERGE', 0) == 1
    # INSERT on target
    assert any(o.object_type == 'TABLE' and o.name == 'target' and o.action == 'INSERT' for o in result.objects_found)
    # SELECT dependencies from subquery
    assert any(o.object_type == 'TABLE' and o.name == 'other' and o.action in ('REFERENCE', 'SELECT') for o in result.objects_found)


def test_analyze_merge_delete_only():
    """Test analysis of MERGE with only DELETE clause."""
    sql = (
        "MERGE INTO tgt USING src ON tgt.id = src.id "
        "WHEN MATCHED THEN DELETE;"
    )
    result = analyze_sql(sql)
    # MERGE stmt
    assert result.statement_counts.get('MERGE', 0) == 1
    # DELETE action on target
    assert any(o.object_type == 'TABLE' and o.name == 'tgt' and o.action == 'DELETE' for o in result.objects_found)
    # SELECT action on source
    assert any(o.object_type == 'TABLE' and o.name == 'src' and o.action == 'SELECT' for o in result.objects_found)


def test_analyze_merge_with_where_clauses():
    """Test analysis of MERGE with WHERE in UPDATE and DELETE clauses."""
    sql = (
        "MERGE INTO target_table USING source_table ON target_table.id = source_table.id "
        "WHEN MATCHED THEN UPDATE SET target_table.flag = TRUE WHERE source_table.flag = FALSE "
        "WHEN MATCHED AND target_table.status = 'NEW' THEN DELETE WHERE source_table.status = 'OLD';"
    )
    result = analyze_sql(sql)
    # Ensure MERGE recorded
    assert result.statement_counts.get('MERGE', 0) == 1
    # UPDATE and DELETE on target_table
    assert any(o.object_type == 'TABLE' and o.name == 'target_table' and o.action == 'UPDATE' for o in result.objects_found)
    assert any(o.object_type == 'TABLE' and o.name == 'target_table' and o.action == 'DELETE' for o in result.objects_found)
    # SELECT on source_table
    assert any(o.object_type == 'TABLE' and o.name == 'source_table' and o.action == 'SELECT' for o in result.objects_found) 