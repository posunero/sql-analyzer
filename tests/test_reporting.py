"""
This module provides unit tests for the reporting components,
including the manager and individual formatters.
"""

import unittest
import json
from collections import defaultdict
import pytest
from pathlib import Path

from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo
from sql_analyzer.reporting import manager
from sql_analyzer.reporting.formats import text as text_formatter
from sql_analyzer.reporting.formats import json as json_formatter

# Assuming analyze_fixture_file is correctly defined in test_analysis
try:
    from .test_analysis import analyze_fixture_file
except ImportError: # Handle running this file directly for unittest discovery
    from test_analysis import analyze_fixture_file 

# Fixture paths
COMPLEX_MIX_FIXTURE = "tests/fixtures/valid/complex_mix.sql"
COMPLEX_SELECT_FIXTURE = "tests/fixtures/valid/complex_select.sql"
FUNCTION_PROCEDURE_FIXTURE = "tests/fixtures/valid/function_and_procedure.sql"

# --- Pytest Fixtures for Analysis Results --- 

@pytest.fixture(scope="module")
def complex_mix_result() -> AnalysisResult:
    """Provides the analysis result for complex_mix.sql"""
    return analyze_fixture_file(COMPLEX_MIX_FIXTURE)

@pytest.fixture(scope="module")
def complex_select_result() -> AnalysisResult:
    """Provides the analysis result for complex_select.sql"""
    return analyze_fixture_file(COMPLEX_SELECT_FIXTURE)

@pytest.fixture(scope="module")
def function_procedure_result() -> AnalysisResult:
    """Provides the analysis result for function_and_procedure.sql"""
    return analyze_fixture_file(FUNCTION_PROCEDURE_FIXTURE)

# --- Pytest Test Functions for Reporting with Fixtures ---

def test_text_formatter_complex_mix(complex_mix_result):
    """Test text output for the complex_mix fixture."""
    report = text_formatter.format_text(complex_mix_result, verbose=False)
    assert "CREATE_TABLE: 1" in report
    assert "USE_WAREHOUSE: 1" in report
    assert "INSERT: 1" in report
    assert "USE_DATABASE: 1" in report
    assert "SELECT: 1" in report
    assert "ALTER_TABLE: 1" in report
    assert "DROP_VIEW: 1" in report
    assert "Total statements analyzed: 7" in report
    assert "Total objects found: 7" in report
    # Check summary counts
    assert "- CREATE TABLE: 1" in report
    assert "- USE WAREHOUSE: 1" in report
    assert "- REFERENCE TABLE: 2" in report # INSERT + SELECT
    assert "- USE DATABASE: 1" in report
    assert "- ALTER TABLE: 1" in report
    assert "- DROP VIEW: 1" in report
    assert "Detailed Object List" not in report # Check non-verbose

def test_text_formatter_complex_mix_verbose(complex_mix_result):
    """Test verbose text output for the complex_mix fixture."""
    report = text_formatter.format_text(complex_mix_result, verbose=True)
    assert "Detailed Object List" in report
    # Check specific object details with location hints (lines might change slightly)
    assert "CREATE TABLE: my_schema.Mixed_Case_Table (Line: 4)" in report
    assert "USE WAREHOUSE: LOAD_WH (Line: 14)" in report
    assert "REFERENCE TABLE: My_Schema.mixed_case_table (Line: 16)" in report # INSERT (Updated line)
    assert "USE DATABASE: analytics_db (Line: 21)" in report
    assert "REFERENCE TABLE: my_schema.mixed_case_table (Line: 23)" in report # SELECT (Updated line)
    assert "ALTER TABLE: my_schema.Mixed_Case_Table (Line: 25)" in report
    assert "DROP VIEW: old_reporting_view (Line: 28)" in report

def test_text_formatter_complex_select(complex_select_result):
    """Test text output for the complex_select fixture."""
    report = text_formatter.format_text(complex_select_result, verbose=False)
    assert "SELECT: 1" in report
    assert "Total statements analyzed: 1" in report
    assert "Total objects found: 5" in report # tables + function
    assert "- REFERENCE FUNCTION: 1" in report
    assert "- REFERENCE TABLE: 4" in report # sales_data, regions, customers, orders
    assert "Detailed Object List" not in report

def test_text_formatter_complex_select_verbose(complex_select_result):
    """Test verbose text output for the complex_select fixture."""
    report = text_formatter.format_text(complex_select_result, verbose=True)
    assert "Detailed Object List" in report
    # Check line numbers based on the fixture content
    assert "REFERENCE TABLE: sales_data (Line: 7)" in report
    assert "REFERENCE TABLE: regions (Line: 8)" in report
    assert "REFERENCE TABLE: customers (Line: 17)" in report
    assert "REFERENCE TABLE: orders (Line: 18)" in report
    assert "REFERENCE FUNCTION: CURRENT_USER (Line: 27)" in report

def test_text_formatter_function_procedure(function_procedure_result):
    """Test text output for the function_procedure fixture."""
    report = text_formatter.format_text(function_procedure_result, verbose=False)
    assert "CREATE_FUNCTION: 2" in report
    assert "SELECT: 1" in report
    # Check if CREATE_PROCEDURE is handled generically or not (adjust if needed)
    # assert "CREATE_PROCEDURE: 1" not in report # Assuming not specifically handled yet
    # assert "Total statements analyzed: 3" in report # Adjust if CREATE_PROCEDURE is counted
    assert "Total objects found: 3" in report # 2 CREATE FUNCTION, 1 REFERENCE FUNCTION
    assert "- CREATE FUNCTION: 2" in report
    assert "- REFERENCE FUNCTION: 1" in report
    # assert "- CREATE PROCEDURE: 1" not in report # Check if procedure object is created
    assert "Detailed Object List" not in report

def test_json_formatter_complex_mix(complex_mix_result):
    """Test JSON output for the complex_mix fixture."""
    report = json_formatter.format_json(complex_mix_result)
    data = json.loads(report)
    assert data['statement_counts']['CREATE_TABLE'] == 1
    assert data['statement_counts']['USE_WAREHOUSE'] == 1
    assert data['statement_counts']['DROP_VIEW'] == 1
    assert len(data['objects_found']) == 7
    # Find specific object
    created_table = next(o for o in data['objects_found'] if o['action'] == 'CREATE' and o['object_type'] == 'TABLE')
    assert created_table['name'] == "my_schema.Mixed_Case_Table"
    assert created_table['line'] == 4
    used_wh = next(o for o in data['objects_found'] if o['action'] == 'USE' and o['object_type'] == 'WAREHOUSE')
    assert used_wh['name'] == "LOAD_WH"
    assert used_wh['line'] == 14

def test_json_formatter_complex_select(complex_select_result):
    """Test JSON output for the complex_select fixture."""
    report = json_formatter.format_json(complex_select_result)
    data = json.loads(report)
    assert data['statement_counts']['SELECT'] == 1
    assert len(data['objects_found']) == 5
    table_names = {o['name'] for o in data['objects_found'] if o['object_type'] == 'TABLE'}
    assert table_names == {"sales_data", "regions", "customers", "orders"}
    func_names = {o['name'] for o in data['objects_found'] if o['object_type'] == 'FUNCTION'}
    assert func_names == {"CURRENT_USER"}

def test_json_formatter_function_procedure(function_procedure_result):
    """Test JSON output for the function_procedure fixture."""
    report = json_formatter.format_json(function_procedure_result)
    data = json.loads(report)
    assert data['statement_counts']['CREATE_FUNCTION'] == 2
    assert data['statement_counts']['SELECT'] == 1
    # assert 'CREATE_PROCEDURE' not in data['statement_counts'] # If not specifically handled
    assert len(data['objects_found']) == 3
    created_funcs = {o['name'] for o in data['objects_found'] if o['action'] == 'CREATE'}
    assert created_funcs == {"simple_math.add_two_integers", "financial_data.calculate_tax"}
    referenced_funcs = {o['name'] for o in data['objects_found'] if o['action'] == 'REFERENCE'}
    assert referenced_funcs == {"simple_math.add_two_integers"}
    # procedure_obj = [o for o in data['objects_found'] if o['object_type'] == 'PROCEDURE']
    # assert not procedure_obj # Check if procedure object is created

# --- Keep existing unittest structure --- 

class TestReporting(unittest.TestCase):

    def setUp(self):
        """Set up a sample AnalysisResult for testing."""
        self.result = AnalysisResult(
            statement_counts=defaultdict(int, {
                'SELECT': 5,
                'CREATE_TABLE': 2,
                'INSERT': 3
            }),
            objects_found=[
                ObjectInfo(name="db1.schema1.table1", object_type="TABLE", action="CREATE", line=10, column=1),
                ObjectInfo(name="db1.schema1.view1", object_type="VIEW", action="CREATE", line=25, column=1),
                ObjectInfo(name="db1.schema1.table1", object_type="TABLE", action="REFERENCE", line=30, column=15),
                ObjectInfo(name="db_other.sch2.proc1", object_type="PROCEDURE", action="REFERENCE", line=35, column=8),
            ],
            errors=[
                {'file': 'path/to/file1.sql', 'line': 5, 'message': 'Syntax error near X'},
                {'file': 'path/to/file2.sql', 'line': 15, 'message': 'Invalid identifier Y'}
            ]
        )
        self.empty_result = AnalysisResult()

    # --- Test Manager ---

    def test_manager_selects_text(self):
        """Test if the manager correctly calls the text formatter."""
        report = manager.generate_report(self.result, 'text')
        self.assertIn("--- SQL Analysis Report ---", report)
        self.assertIn("== Statement Summary ==", report)
        self.assertIn("== Object Summary ==", report)
        self.assertIn("== Errors ==", report)

    def test_manager_selects_json(self):
        """Test if the manager correctly calls the json formatter."""
        report = manager.generate_report(self.result, 'json')
        try:
            data = json.loads(report)
            self.assertIsInstance(data, dict)
            self.assertIn('statement_counts', data)
            self.assertIn('objects_found', data)
            self.assertIn('errors', data)
        except json.JSONDecodeError:
            self.fail("Manager did not produce valid JSON output.")

    def test_manager_unsupported_format(self):
        """Test manager raises error for unsupported format."""
        with self.assertRaises(ValueError):
            manager.generate_report(self.result, 'xml')

    # --- Test Text Formatter ---

    def test_text_formatter_basic_output(self):
        """Test basic structure and content of text report."""
        report = text_formatter.format_text(self.result)
        self.assertIn("--- SQL Analysis Report ---", report)
        self.assertIn("== Statement Summary ==", report)
        self.assertIn("== Object Summary ==", report)
        self.assertIn("== Errors ==", report)
        self.assertIn("Total statements analyzed: 10", report)
        self.assertIn("- SELECT: 5", report)
        self.assertIn("- CREATE_TABLE: 2", report)
        self.assertIn("- INSERT: 3", report)
        self.assertIn("Total objects found: 4", report)
        self.assertIn("- CREATE TABLE: 1", report)
        self.assertIn("- CREATE VIEW: 1", report)
        self.assertIn("- REFERENCE PROCEDURE: 1", report)
        self.assertIn("- REFERENCE TABLE: 1", report)
        self.assertIn("Total errors encountered: 2", report)
        self.assertIn("[File: path/to/file1.sql, Line: 5]: Syntax error near X", report)
        self.assertNotIn("Detailed Object List", report)

    def test_text_formatter_empty_result(self):
        """Test text formatter handles empty results gracefully."""
        report = text_formatter.format_text(self.empty_result)
        self.assertIn("No statements found.", report)
        self.assertIn("No database objects found.", report)
        self.assertIn("No errors encountered.", report)
        self.assertNotIn("Total statements analyzed:", report)
        self.assertNotIn("Total objects found:", report)
        self.assertNotIn("Total errors encountered:", report)

    # --- Test JSON Formatter ---

    def test_json_formatter_output(self):
        """Test JSON formatter produces correct structure and data."""
        report = json_formatter.format_json(self.result)
        data = json.loads(report)

        self.assertIsInstance(data, dict)
        self.assertEqual(data['statement_counts']['SELECT'], 5)
        self.assertEqual(data['statement_counts']['CREATE_TABLE'], 2)
        self.assertEqual(len(data['objects_found']), 4)
        self.assertEqual(data['objects_found'][0]['name'], "db1.schema1.table1")
        self.assertEqual(data['objects_found'][0]['object_type'], "TABLE")
        self.assertEqual(data['objects_found'][0]['action'], "CREATE")
        self.assertEqual(data['objects_found'][0]['line'], 10)
        self.assertEqual(len(data['errors']), 2)
        self.assertEqual(data['errors'][0]['file'], 'path/to/file1.sql')
        self.assertEqual(data['errors'][0]['message'], 'Syntax error near X')

    def test_json_formatter_empty_result(self):
        """Test JSON formatter handles empty results correctly."""
        report = json_formatter.format_json(self.empty_result)
        data = json.loads(report)

        self.assertEqual(data['statement_counts'], {})
        self.assertEqual(data['objects_found'], [])
        self.assertEqual(data['errors'], [])


if __name__ == '__main__':
    unittest.main() 