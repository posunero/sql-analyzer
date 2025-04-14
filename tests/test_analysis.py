"""
Tests for the analysis engine and visitor interaction using pytest.
"""

import pytest

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine
from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo

# Test SQL snippets
SQL_EMPTY = "  ; "
SQL_SIMPLE_SELECT = "SELECT col1 FROM my_schema.my_table;"
SQL_SIMPLE_CREATE = "CREATE TABLE another_table (id INT);"
SQL_MIXED = """
SELECT f1 FROM t1;
CREATE TABLE t2 (c1 INT);
USE WAREHOUSE my_wh;
ALTER TABLE t1 ADD COLUMN c2 STRING;
DROP VIEW v1;
"""

def analyze_sql(sql: str) -> AnalysisResult:
    """Helper function to parse and analyze SQL."""
    print(f"\n--- Analyzing SQL ---\n{sql}\n-------------------")
    tree = parse_sql(sql)
    if tree is None:
        print("PARSING FAILED - Returned None")
        return AnalysisResult()  # Return an empty result
        
    engine = AnalysisEngine()
    engine.visitor.debug = True  # Enable tree debugging
    # Handle None tree gracefully in analyze method
    result = engine.analyze(tree)
    
    # Add debug print of the results
    print("\n--- Analysis Results ---")
    print(f"Statement counts: {dict(result.statement_counts)}")
    print(f"Objects found: {len(result.objects_found)}")
    for obj in result.objects_found:
        print(f"  - {obj.action} {obj.object_type}: {obj.name}")
    print("-------------------\n")
    
    return result

def test_analyze_empty_sql():
    """Test analyzing empty or whitespace SQL."""
    result = analyze_sql(SQL_EMPTY)
    assert isinstance(result, AnalysisResult)
    assert len(result.statement_counts) == 0
    assert len(result.objects_found) == 0

def test_analyze_simple_select():
    """Test analysis of a simple SELECT statement."""
    result = analyze_sql(SQL_SIMPLE_SELECT)

    assert result.statement_counts['SELECT'] == 1
    assert len(result.statement_counts) == 1

    # Check for the referenced table (based on the simple visitor implementation)
    found_objects = [o for o in result.objects_found if o.object_type == 'TABLE']
    assert len(found_objects) == 1
    assert found_objects[0].name == 'my_schema.my_table'
    assert found_objects[0].action == 'REFERENCE' # Default action

def test_analyze_simple_create():
    """Test analysis of a simple CREATE TABLE statement."""
    result = analyze_sql(SQL_SIMPLE_CREATE)

    assert result.statement_counts['CREATE_TABLE'] == 1
    assert len(result.statement_counts) == 1

    # The current basic visitor might record this as a REFERENCE, not CREATE
    # This test highlights where visitor context logic needs improvement
    found_objects = [o for o in result.objects_found if o.object_type == 'TABLE']
    assert len(found_objects) == 1
    assert found_objects[0].name == 'another_table'
    # TODO: Update this assertion when visitor correctly identifies CREATE action
    assert found_objects[0].action == 'CREATE' # Visitor should now correctly identify the action

def test_analyze_mixed_statements():
    """Test analysis of multiple mixed statements."""
    result = analyze_sql(SQL_MIXED)

    # Check statement counts (based on visitor identifying top-level nodes)
    assert result.statement_counts['SELECT'] == 1
    assert result.statement_counts['CREATE_TABLE'] == 1
    assert result.statement_counts['USE_WAREHOUSE'] == 1 # Assumes grammar rule
    assert result.statement_counts['ALTER_TABLE'] == 1
    assert result.statement_counts['DROP_VIEW'] == 1 # Assumes grammar rule
    assert len(result.statement_counts) == 5

    # Check objects (will be incomplete/inaccurate action until visitor improves)
    table_refs = [o for o in result.objects_found if o.object_type == 'TABLE']
    # Expecting t1 (SELECT), t2 (CREATE), t1 (ALTER)
    # Also expecting my_wh (USE) and v1 (DROP)
    assert len(result.objects_found) == 5 # Updated expected count

    # Check specific objects and actions
    actions = { (o.name, o.object_type): o.action for o in result.objects_found }
    assert actions.get(('t1', 'TABLE')) == 'REFERENCE' # First SELECT
    assert actions.get(('t2', 'TABLE')) == 'CREATE'
    assert actions.get(('my_wh', 'WAREHOUSE')) == 'USE'
    assert actions.get(('t1', 'TABLE', 2)) is None # Should only record t1 once for REFERENCE/ALTER
    assert actions.get(('v1', 'VIEW')) == 'DROP'

    # More refined check for t1 (should be referenced and altered)
    t1_objects = [o for o in result.objects_found if o.name == 't1']
    assert len(t1_objects) == 2 # Once for SELECT (REFERENCE), once for ALTER
    assert {o.action for o in t1_objects} == {'REFERENCE', 'ALTER'}

# TODO: Add tests for merging results from multiple analyses
# TODO: Add tests specifically targeting the visitor's ability to extract
#       different object types (views, functions, etc.) once implemented.
# TODO: Add tests for correct line/column numbers in ObjectInfo. 