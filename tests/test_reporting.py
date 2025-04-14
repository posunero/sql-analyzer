"""
This module provides unit tests for the reporting components,
including the manager and individual formatters.
"""

import unittest
import json
from collections import defaultdict
from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo
from sql_analyzer.reporting import manager
from sql_analyzer.reporting.formats import text as text_formatter
from sql_analyzer.reporting.formats import json as json_formatter

class TestReporting(unittest.TestCase):

    def setUp(self):
        """Set up a sample AnalysisResult for testing."""
        self.result = AnalysisResult(
            statement_counts=defaultdict(int, {
                'SELECT': 5,
                'CREATE TABLE': 2,
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
        self.assertIn("SQL Analysis Report", report)
        self.assertIn("Statement Summary", report)
        self.assertIn("Object Summary", report)

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

    def test_manager_calls_formatter_with_verbose(self):
        """Test manager passes verbose flag to text formatter."""
        # Non-verbose
        report_normal = manager.generate_report(self.result, 'text', verbose=False)
        self.assertNotIn("Detailed Object List", report_normal)
        # Verbose
        report_verbose = manager.generate_report(self.result, 'text', verbose=True)
        self.assertIn("Detailed Object List", report_verbose)
        self.assertIn("(Line: 10, Col: 1)", report_verbose) # Check if location is printed

    # --- Test Text Formatter --- 

    def test_text_formatter_basic_output(self):
        """Test basic structure and content of text report."""
        report = text_formatter.format_report(self.result)
        self.assertIn("SQL Analysis Report", report)
        self.assertIn("Total Statements Analyzed: 10", report)
        self.assertIn("CREATE TABLE: 2", report)
        self.assertIn("SELECT: 5", report)
        self.assertIn("INSERT: 3", report)
        self.assertIn("Total Objects Found: 4", report)
        self.assertIn("TABLE - CREATE: 1", report)
        self.assertIn("TABLE - REFERENCE: 1", report)
        self.assertIn("VIEW - CREATE: 1", report)
        self.assertIn("PROCEDURE - REFERENCE: 1", report)
        self.assertIn("Total Errors: 2", report)
        self.assertIn("File: path/to/file1.sql, Line: 5: Syntax error near X", report)
        self.assertNotIn("Detailed Object List", report)

    def test_text_formatter_verbose_output(self):
        """Test verbose output includes detailed object list with locations."""
        report = text_formatter.format_report(self.result, verbose=True)
        self.assertIn("Detailed Object List", report)
        self.assertIn("- CREATE TABLE db1.schema1.table1 (Line: 10, Col: 1)", report)
        self.assertIn("- REFERENCE TABLE db1.schema1.table1 (Line: 30, Col: 15)", report)
        self.assertIn("- REFERENCE PROCEDURE db_other.sch2.proc1 (Line: 35, Col: 8)", report)
        self.assertIn("- CREATE VIEW db1.schema1.view1 (Line: 25, Col: 1)", report)

    def test_text_formatter_empty_result(self):
        """Test text formatter handles empty results gracefully."""
        report = text_formatter.format_report(self.empty_result)
        self.assertIn("No statements found.", report)
        self.assertIn("No database objects found.", report)
        self.assertIn("No errors reported.", report)
        self.assertNotIn("Total Statements Analyzed", report)

    # --- Test JSON Formatter --- 

    def test_json_formatter_output(self):
        """Test JSON formatter produces correct structure and data."""
        report = json_formatter.format_report(self.result)
        data = json.loads(report)

        self.assertIsInstance(data, dict)
        self.assertEqual(data['statement_counts']['SELECT'], 5)
        self.assertEqual(data['statement_counts']['CREATE TABLE'], 2)
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
        report = json_formatter.format_report(self.empty_result)
        data = json.loads(report)

        self.assertEqual(data['statement_counts'], {})
        self.assertEqual(data['objects_found'], [])
        self.assertEqual(data['errors'], [])


if __name__ == '__main__':
    unittest.main() 