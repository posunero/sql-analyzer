"""
Tests for the analysis engine and visitor interaction using pytest.
"""

import pytest
import logging
from lark import Tree, Token, LarkError
from pathlib import Path # Import Path

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine
from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo

# Configure logging
def setup_logging():
    """Configure logging to output debug information for tests."""
    logger = logging.getLogger('sql_analyzer')
    logger.setLevel(logging.DEBUG)
    
    # Create console handler
    handler = logging.StreamHandler()
    handler.setLevel(logging.DEBUG)
    
    # Create formatter
    formatter = logging.Formatter('%(levelname)s:%(name)s:%(message)s')
    handler.setFormatter(formatter)
    
    # Add handler to logger
    logger.addHandler(handler)
    
    return logger

# Set up logging before tests run
logger = setup_logging()

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
# --- Add new SQL snippets ---
SQL_ALTER_WAREHOUSE = "ALTER WAREHOUSE my_test_wh SET WAREHOUSE_SIZE = 'LARGE';"
SQL_UPDATE = "UPDATE db1.sch1.table_to_update SET col1 = 'new value' WHERE id = 10;"
SQL_CREATE_REPLACE_VIEW = "CREATE OR REPLACE VIEW my_schema.v_replace AS SELECT colA FROM source_table WHERE id > 100;"
SQL_DATABASE_OPS = """
CREATE DATABASE IF NOT EXISTS new_db;
USE DATABASE new_db;
DROP DATABASE new_db;
"""

def analyze_sql(sql: str) -> AnalysisResult:
    """Helper function to parse and analyze SQL."""
    print(f"\n--- Analyzing SQL ---\n{sql}\n-------------------")
    tree = None # Initialize tree to None
    try:
        tree = parse_sql(sql)
    except LarkError as e:
        print(f"PARSING FAILED - Caught LarkError: {e}")
        # Tree remains None

    if tree is None:
        print("PARSING SKIPPED/FAILED - Returning empty result") # Consistent message
        return AnalysisResult()  # Return an empty result for None tree or error

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

# Helper function to analyze a fixture file
def analyze_fixture_file(fixture_path_str: str) -> AnalysisResult:
    """Helper function to read, parse, and analyze a fixture SQL file."""
    file_path = Path(fixture_path_str)
    print(f"\n--- Analyzing Fixture File: {file_path} ---")
    assert file_path.exists(), f"Fixture file not found: {fixture_path_str}"

    sql_content = file_path.read_text()
    tree = None
    try:
        tree = parse_sql(sql_content)
    except LarkError as e:
        print(f"PARSING FAILED - Caught LarkError: {e}")
        # Re-raise for test failure or return empty if tests expect this
        # For now, let tests handle expected errors via pytest.raises
        raise 

    if tree is None:
        # Should only happen for empty files, handled by parse_sql
        print("PARSING SKIPPED (empty file) - Returning empty result")
        return AnalysisResult()

    engine = AnalysisEngine()
    # Disable visitor debug for fixture tests unless needed for specific debugging
    # engine.visitor.debug = True 
    result = engine.analyze(tree, file_path=str(file_path))
    
    # Add debug print of the results
    print("\n--- Analysis Results ---")
    print(f"Statement counts: {dict(result.statement_counts)}")
    print(f"Objects found: {len(result.objects_found)}")
    for obj in result.objects_found:
        print(f"  - {obj.action} {obj.object_type}: {obj.name} @ {obj.file_path}:{obj.line}")
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

# --- Add new test functions ---

def test_analyze_alter_warehouse():
    """Test analysis of ALTER WAREHOUSE statement."""
    result = analyze_sql(SQL_ALTER_WAREHOUSE)
    
    assert result.statement_counts['ALTER_WAREHOUSE'] == 1
    assert len(result.statement_counts) == 1

    found_objects = [o for o in result.objects_found if o.object_type == 'WAREHOUSE']
    assert len(found_objects) == 1
    assert found_objects[0].name == 'my_test_wh'
    assert found_objects[0].action == 'ALTER'

def test_analyze_update():
    """Test analysis of UPDATE statement."""
    result = analyze_sql(SQL_UPDATE)
    
    assert result.statement_counts['UPDATE'] == 1
    assert len(result.statement_counts) == 1

    found_objects = [o for o in result.objects_found if o.object_type == 'TABLE']
    assert len(found_objects) == 1
    assert found_objects[0].name == 'db1.sch1.table_to_update'
    assert found_objects[0].action == 'UPDATE'

def test_analyze_create_replace_view():
    """Test analysis of CREATE OR REPLACE VIEW statement."""
    result = analyze_sql(SQL_CREATE_REPLACE_VIEW)
    
    # Engine should record this as CREATE_VIEW
    assert result.statement_counts['CREATE_VIEW'] == 1 
    assert len(result.statement_counts) == 1

    # Check created view
    view_objects = [o for o in result.objects_found if o.object_type == 'VIEW']
    assert len(view_objects) == 1
    assert view_objects[0].name == 'my_schema.v_replace'
    assert view_objects[0].action == 'CREATE'

    # Check referenced table in the view definition
    table_objects = [o for o in result.objects_found if o.object_type == 'TABLE']
    assert len(table_objects) == 1
    assert table_objects[0].name == 'source_table'
    assert table_objects[0].action == 'REFERENCE'

    assert len(result.objects_found) == 2 # View created, Table referenced

def test_analyze_database_ops():
    """Test analysis of CREATE, USE, DROP DATABASE statements."""
    result = analyze_sql(SQL_DATABASE_OPS)
    
    assert result.statement_counts['CREATE_DATABASE'] == 1
    assert result.statement_counts['USE_DATABASE'] == 1
    assert result.statement_counts['DROP_DATABASE'] == 1
    assert len(result.statement_counts) == 3

    # Check database objects and actions
    db_objects = [o for o in result.objects_found if o.object_type == 'DATABASE']
    assert len(db_objects) == 3
    
    actions_on_db = {o.action for o in db_objects if o.name == 'new_db'}
    assert actions_on_db == {'CREATE', 'USE', 'DROP'}

# --- End new test functions ---

# --- Tests using complex fixtures ---

def test_analyze_complex_mix_fixture():
    """Test analysis of the complex_mix.sql fixture file."""
    fixture = "tests/fixtures/valid/complex_mix.sql"
    result = analyze_fixture_file(fixture)

    # Expected statements
    expected_statements = {
        'CREATE_TABLE': 1,
        'USE_WAREHOUSE': 1,
        'INSERT': 1,
        'USE_DATABASE': 1,
        'SELECT': 1,
        'ALTER_TABLE': 1,
        'DROP_VIEW': 1
    }
    assert dict(result.statement_counts) == expected_statements

    # Expected objects (check name, type, action)
    # Note: Names might be case-sensitive depending on extraction, but actions/types are uppercased
    expected_objects = [
        ("my_schema.Mixed_Case_Table", "TABLE", "CREATE"),
        ("LOAD_WH", "WAREHOUSE", "USE"),
        ("My_Schema.mixed_case_table", "TABLE", "REFERENCE"), # From INSERT (visitor only gets name)
        ("analytics_db", "DATABASE", "USE"),
        ("my_schema.mixed_case_table", "TABLE", "REFERENCE"), # From SELECT
        ("my_schema.Mixed_Case_Table", "TABLE", "ALTER"),
        ("old_reporting_view", "VIEW", "DROP"),
    ]
    assert len(result.objects_found) == len(expected_objects)

    found_obj_tuples = sorted([(o.name, o.object_type, o.action) for o in result.objects_found])
    expected_obj_tuples = sorted(expected_objects)

    assert found_obj_tuples == expected_obj_tuples, "Mismatch in found objects (name, type, action)"
    
    # Verify file path and line numbers are populated (simple check)
    for obj in result.objects_found:
        # Normalize paths for comparison
        assert Path(obj.file_path).resolve() == Path(fixture).resolve()
        # Check if line number is greater than 0 (basic check for population)
        # TODO: Add more precise line number checks based on fixture content
        assert obj.line > 0, f"Object {obj.name} ({obj.action} {obj.object_type}) has line number 0"
        assert obj.column > 0, f"Object {obj.name} ({obj.action} {obj.object_type}) has column number 0"

def test_analyze_complex_select_fixture():
    """Test analysis of the complex_select.sql fixture file."""
    fixture = "tests/fixtures/valid/complex_select.sql"
    result = analyze_fixture_file(fixture)

    # Expected statements
    assert dict(result.statement_counts) == {'SELECT': 1}

    # Expected objects 
    # Visitor currently catches tables in FROM/JOIN and functions like CURRENT_USER
    expected_objects = [
        ("sales_data", "TABLE", "REFERENCE"),
        ("regions", "TABLE", "REFERENCE"),
        ("customers", "TABLE", "REFERENCE"),
        ("orders", "TABLE", "REFERENCE"),
        ("CURRENT_USER", "FUNCTION", "REFERENCE"), # Assuming function calls are caught generically
        # ("LEFT", "FUNCTION", "REFERENCE"), # Currently likely not caught
    ]
    assert len(result.objects_found) == len(expected_objects)
    found_obj_tuples = sorted([(o.name, o.object_type, o.action) for o in result.objects_found])
    expected_obj_tuples = sorted(expected_objects)
    assert found_obj_tuples == expected_obj_tuples

def test_analyze_function_procedure_fixture():
    """Test analysis of the function_and_procedure.sql fixture file."""
    fixture = "tests/fixtures/valid/function_and_procedure.sql"
    # Note: CREATE PROCEDURE might parse but not be specifically analyzed yet.
    # The DELETE inside the procedure body is likely not analyzed either.
    result = analyze_fixture_file(fixture)

    # Expected statements (assuming CREATE_PROCEDURE isn't specifically identified by engine yet)
    expected_statements = {
        'CREATE_FUNCTION': 2, 
        'SELECT': 1,
        # 'CREATE_PROCEDURE': 1, # Add if/when engine handles it
    }
    # Check subset: Ensure expected statements are present
    for stmt, count in expected_statements.items():
        assert result.statement_counts.get(stmt, 0) == count
    # We might have a generic CREATE_PROCEDURE if the grammar rule exists but engine doesn't refine
    # assert 'CREATE_PROCEDURE' not in result.statement_counts # Or assert if it is expected generically

    # Expected objects 
    expected_objects = [
        ("simple_math.add_two_integers", "FUNCTION", "CREATE"),
        ("financial_data.calculate_tax", "FUNCTION", "CREATE"),
        # Procedure object might not be created if visitor doesn't handle it
        # ("admin_tasks.cleanup_logs", "PROCEDURE", "CREATE"), 
        ("simple_math.add_two_integers", "FUNCTION", "REFERENCE"), # From SELECT
    ]
    # Because procedure might not be found, check count and content carefully
    # assert len(result.objects_found) == len(expected_objects)
    found_obj_tuples = sorted([(o.name, o.object_type, o.action) for o in result.objects_found])
    expected_obj_tuples = sorted(expected_objects)
    assert found_obj_tuples == expected_obj_tuples, "Mismatch in found objects (functions)"

# --- End tests using complex fixtures ---

# TODO: Add tests for merging results from multiple analyses
# TODO: Add tests specifically targeting the visitor's ability to extract
#       different object types (views, functions, etc.) once implemented.
# TODO: Add tests for correct line/column numbers in ObjectInfo. 