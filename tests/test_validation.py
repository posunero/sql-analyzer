import json
import sys
import pytest
from pathlib import Path
from unittest.mock import patch

from sql_analyzer.validation import validate_sql_file, validate_multiple_files
from sql_analyzer.reporting.formats.html import format_validation_results
from sql_analyzer.main import main

# Fixture directory paths
test_dir = Path(__file__).parent / 'fixtures'
VALID_DIR = test_dir / 'valid'
INVALID_DIR = test_dir / 'invalid'


def test_validate_sql_file_valid():
    """validate_sql_file returns True for a valid SQL file with no error message."""
    valid_file = VALID_DIR / 'simple_select.sql'
    is_valid, error_msg = validate_sql_file(valid_file)
    assert is_valid
    assert error_msg is None


def test_validate_sql_file_invalid():
    """validate_sql_file returns False and an error message for an invalid SQL file."""
    invalid_file = INVALID_DIR / 'syntax_error.sql'
    is_valid, error_msg = validate_sql_file(invalid_file)
    assert not is_valid
    assert isinstance(error_msg, str)
    assert error_msg != ''
    assert 'Line' in error_msg


def test_validate_multiple_files():
    """validate_multiple_files correctly validates multiple files and returns a dict."""
    files = [VALID_DIR / 'simple_select.sql', INVALID_DIR / 'syntax_error.sql']
    results = validate_multiple_files(files)
    assert isinstance(results, dict)
    assert str(files[0]) in results
    assert str(files[1]) in results
    assert results[str(files[0])][0] is True
    assert results[str(files[1])][0] is False


def test_format_validation_results():
    """HTML formatter produces expected content for validation results."""
    sample = {
        'a.sql': (True, ''),
        'b.sql': (False, 'error message')
    }
    html = format_validation_results(sample)
    assert '<h1>Snowflake SQL Validation Report' in html
    assert 'a.sql' in html and 'Valid' in html
    assert 'b.sql' in html and 'error message' in html


def test_main_json_validation(capsys):
    """Integration test: JSON output and exit code for mixed valid/invalid."""
    valid = str(VALID_DIR / 'simple_select.sql')
    invalid = str(INVALID_DIR / 'syntax_error.sql')
    args = ['prog', '--validate', '--format', 'json', valid, invalid]
    with patch.object(sys, 'argv', args):
        with pytest.raises(SystemExit) as exc_info:
            main()
    assert exc_info.value.code == 1
    out = capsys.readouterr().out
    data = json.loads(out)
    assert data['files'] == 2
    assert data['valid'] == 1
    assert data['invalid'] == 1
    assert data['results'][valid]['valid'] is True
    assert data['results'][invalid]['valid'] is False
    assert isinstance(data['results'][invalid]['error'], str)


def test_main_text_validation(capsys):
    """Integration test: default text output and exit code for mixed files."""
    valid = str(VALID_DIR / 'simple_select.sql')
    invalid = str(INVALID_DIR / 'syntax_error.sql')
    args = ['prog', '--validate', valid, invalid]
    with patch.object(sys, 'argv', args):
        with pytest.raises(SystemExit) as exc_info:
            main()
    assert exc_info.value.code == 1
    out = capsys.readouterr().out
    assert 'Snowflake SQL Validation Report' in out
    assert 'Files processed: 2' in out
    assert 'Valid files: 1' in out
    assert 'Invalid files: 1' in out
    assert f'- {invalid}' in out


def test_main_html_validation(capsys):
    """Integration test: HTML output and exit code for valid files only."""
    valid = str(VALID_DIR / 'simple_select.sql')
    args = ['prog', '--validate', '--format', 'html', valid]
    with patch.object(sys, 'argv', args):
        with pytest.raises(SystemExit) as exc_info:
            main()
    assert exc_info.value.code == 0
    out = capsys.readouterr().out
    assert '<!DOCTYPE html>' in out
    assert '<title>Snowflake SQL Validation Report' in out
    assert 'simple_select.sql' in out


def test_main_no_sql_files(tmp_path):
    """Integration test: exiting with non-zero when no SQL files found."""
    empty_dir = tmp_path / 'empty'
    empty_dir.mkdir()
    args = ['prog', '--validate', str(empty_dir)]
    with patch.object(sys, 'argv', args):
        with pytest.raises(SystemExit) as exc_info:
            main()
    assert exc_info.value.code == 1
    