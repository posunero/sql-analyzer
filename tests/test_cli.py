"""
Tests for the command-line interface.
"""

import unittest
from unittest.mock import patch
import sys

# Add project root to sys.path or use relative imports if structure allows
# This assumes tests are run from the project root or using a test runner
# that handles paths correctly.
# For simplicity here, we might rely on the execution environment.
# A better approach involves proper packaging or test runner configuration.
from sql_analyzer import cli # Assuming cli.py is accessible

class TestCli(unittest.TestCase):

    def test_required_input_paths(self):
        """Tests if input_paths are correctly parsed."""
        test_args = ['prog', 'path/to/file.sql', 'another/dir']
        with patch.object(sys, 'argv', test_args):
            args = cli.parse_arguments()
            self.assertEqual(args.input_paths, ['path/to/file.sql', 'another/dir'])

    def test_default_arguments(self):
        """Tests default values for optional arguments."""
        test_args = ['prog', 'some/path']
        with patch.object(sys, 'argv', test_args):
            args = cli.parse_arguments()
            self.assertEqual(args.format, 'text')
            self.assertEqual(args.verbose, 'INFO') # Default log level
            self.assertFalse(args.fail_fast)

    def test_set_format(self):
        """Tests setting the --format argument."""
        test_args = ['prog', '--format', 'json', 'some/path']
        with patch.object(sys, 'argv', test_args):
            args = cli.parse_arguments()
            self.assertEqual(args.format, 'json')

    def test_set_verbose(self):
        """Tests setting the --verbose/--log-level argument."""
        test_args = ['prog', '--verbose', 'DEBUG', 'some/path']
        with patch.object(sys, 'argv', test_args):
            args = cli.parse_arguments()
            self.assertEqual(args.verbose, 'DEBUG')

        # Test alias --log-level
        test_args_alias = ['prog', '--log-level', 'WARNING', 'some/path']
        with patch.object(sys, 'argv', test_args_alias):
            args_alias = cli.parse_arguments()
            self.assertEqual(args_alias.verbose, 'WARNING')

    def test_set_fail_fast(self):
        """Tests setting the --fail-fast flag."""
        test_args = ['prog', '--fail-fast', 'some/path']
        with patch.object(sys, 'argv', test_args):
            args = cli.parse_arguments()
            self.assertTrue(args.fail_fast)

    def test_invalid_format_choice(self):
        """Tests providing an invalid choice for --format."""
        test_args = ['prog', '--format', 'xml', 'some/path']
        # We expect argparse to exit, so we catch SystemExit
        # We also need to redirect stderr to check the error message
        with patch.object(sys, 'argv', test_args):
            with self.assertRaises(SystemExit):
                 # Suppress argparse error output during test
                 with patch('sys.stderr'):
                    cli.parse_arguments()

    def test_missing_input_path(self):
        """Tests calling without the required input_paths."""
        test_args = ['prog', '--format', 'json'] # Missing input_paths
        with patch.object(sys, 'argv', test_args):
            with self.assertRaises(SystemExit):
                with patch('sys.stderr'):
                    cli.parse_arguments()

if __name__ == '__main__':
    unittest.main() 