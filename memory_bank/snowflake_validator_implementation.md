# Snowflake SQL Validator Implementation Plan

## Overview

This document outlines the implementation plan for adding a simple Snowflake SQL validation feature to the sql-analyzer tool. This feature will allow users to quickly validate whether a SQL file contains valid Snowflake SQL syntax without performing the full analysis.

## Feature Requirements

1. Add a new command-line option `--validate` that switches the tool into validation-only mode
2. When in validation mode, the tool should:
   - Parse the SQL file using the existing Snowflake grammar
   - Report whether the file is valid or invalid
   - Provide detailed error information for invalid files
   - Exit with appropriate status code (0 for valid, non-zero for invalid)
3. Support validating multiple files with summary reporting
4. Make validation errors clear and actionable

## Implementation Steps

### 1. Update CLI Module

Modify `sql_analyzer/cli.py` to add the new validation option:

```python
parser.add_argument(
    '--validate',
    action='store_true',
    help='Only validate SQL syntax without performing analysis.'
)
```

### 2. Create Validation Module

Create a new module `sql_analyzer/validation.py` to handle the validation logic:

```python
"""
Module for SQL validation functionality.
"""
import logging
from pathlib import Path
from typing import Dict, List, Tuple

from lark import LarkError

from sql_analyzer.parser import core as parser_core
from sql_analyzer.utils import file_system

logger = logging.getLogger(__name__)

def validate_sql_file(file_path: Path) -> Tuple[bool, str]:
    """
    Validate a single SQL file.
    
    Args:
        file_path: Path to the SQL file
        
    Returns:
        Tuple of (is_valid, error_message)
    """
    try:
        content = file_system.read_file_content(file_path)
        if content is None:
            return False, "Could not read file"
            
        # Use existing parser to validate
        parser_core.parse_sql(content)
        return True, ""
    except LarkError as e:
        # Format error message nicely
        error_msg = f"Line {e.line}, column {e.column}: {str(e)}"
        return False, error_msg
    except Exception as e:
        return False, f"Unexpected error: {str(e)}"

def validate_multiple_files(file_paths: List[Path]) -> Dict[str, Tuple[bool, str]]:
    """
    Validate multiple SQL files.
    
    Args:
        file_paths: List of paths to SQL files
        
    Returns:
        Dictionary of {file_path: (is_valid, error_message)}
    """
    results = {}
    for file_path in file_paths:
        is_valid, error_message = validate_sql_file(file_path)
        results[str(file_path)] = (is_valid, error_message)
    return results
```

### 3. Update Main Module

Modify `sql_analyzer/main.py` to add validation-only mode:

```python
def main():
    """Main execution function."""
    args = cli.parse_arguments()
    setup_logging(args.verbose)
    
    if args.validate:
        # Run in validation-only mode
        from sql_analyzer.validation import validate_multiple_files
        
        all_files = []
        for input_path_str in args.input_paths:
            logger.info(f"Processing path: {input_path_str}")
            sql_files = list(file_system.find_sql_files(input_path_str))
            if not sql_files:
                logger.warning(f"No .sql files found in path: {input_path_str}")
                continue
            all_files.extend(sql_files)
        
        if not all_files:
            logger.error("No SQL files found in specified paths.")
            sys.exit(1)
            
        # Validate all files
        validation_results = validate_multiple_files(all_files)
        
        # Print results based on format
        if args.format == 'json':
            # Output JSON format
            import json
            result_dict = {
                "files": len(validation_results),
                "valid": sum(1 for result in validation_results.values() if result[0]),
                "invalid": sum(1 for result in validation_results.values() if not result[0]),
                "results": {
                    file_path: {
                        "valid": is_valid,
                        "error": error_msg if not is_valid else None
                    } for file_path, (is_valid, error_msg) in validation_results.items()
                }
            }
            print(json.dumps(result_dict, indent=2))
        else:
            # Default text output
            print(f"--- Snowflake SQL Validation Report ---")
            print(f"Files processed: {len(validation_results)}")
            print(f"Valid files: {sum(1 for result in validation_results.values() if result[0])}")
            print(f"Invalid files: {sum(1 for result in validation_results.values() if not result[0])}")
            print("")
            
            if sum(1 for result in validation_results.values() if not result[0]) > 0:
                print("Invalid files:")
                for file_path, (is_valid, error_msg) in validation_results.items():
                    if not is_valid:
                        print(f"  - {file_path}: {error_msg}")
            
        # Exit with appropriate status code
        has_invalid = any(not result[0] for result in validation_results.values())
        sys.exit(1 if has_invalid else 0)
    else:
        # Run in normal analysis mode
        # ... existing analysis code ...
```

### 4. Add HTML Output for Validation

Update the HTML formatter to handle validation results:

```python
# In sql_analyzer/reporting/formats/html.py

def format_validation_results(validation_results):
    """Format validation results as HTML."""
    env = Environment(loader=PackageLoader('sql_analyzer.reporting', 'templates'))
    template = env.get_template('validation_report.html')
    
    context = {
        'total_files': len(validation_results),
        'valid_files': sum(1 for result in validation_results.values() if result[0]),
        'invalid_files': sum(1 for result in validation_results.values() if not result[0]),
        'results': validation_results
    }
    
    return template.render(context)
```

### 5. Create HTML Template for Validation

Create a new template file `sql_analyzer/reporting/templates/validation_report.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Snowflake SQL Validation Report</title>
    <style>
        /* Include CSS styles similar to the analysis report */
    </style>
</head>
<body>
    <h1>Snowflake SQL Validation Report</h1>
    
    <div class="summary">
        <h2>Summary</h2>
        <p>Files processed: {{ total_files }}</p>
        <p>Valid files: {{ valid_files }}</p>
        <p>Invalid files: {{ invalid_files }}</p>
    </div>
    
    {% if invalid_files > 0 %}
    <div class="errors">
        <h2>Invalid Files</h2>
        <table>
            <tr>
                <th>File</th>
                <th>Error</th>
            </tr>
            {% for file_path, (is_valid, error_msg) in results.items() %}
                {% if not is_valid %}
                <tr>
                    <td>{{ file_path }}</td>
                    <td>{{ error_msg }}</td>
                </tr>
                {% endif %}
            {% endfor %}
        </table>
    </div>
    {% endif %}
    
    <div class="all-files">
        <h2>All Files</h2>
        <table>
            <tr>
                <th>File</th>
                <th>Status</th>
            </tr>
            {% for file_path, (is_valid, _) in results.items() %}
            <tr>
                <td>{{ file_path }}</td>
                <td class="{{ 'valid' if is_valid else 'invalid' }}">
                    {{ 'Valid' if is_valid else 'Invalid' }}
                </td>
            </tr>
            {% endfor %}
        </table>
    </div>
</body>
</html>
```

### 6. Update README.md

Add documentation for the new validation feature:

```markdown
### SQL Validation

The tool can be used to validate Snowflake SQL files without performing full analysis:

```bash
python -m sql_analyzer.main --validate path/to/your/sql/files/
```

This mode quickly checks whether files contain valid Snowflake SQL syntax and provides detailed error messages for invalid files. Use with different output formats:

```bash
# JSON format
python -m sql_analyzer.main --validate --format json path/to/your/sql/files/

# HTML report
python -m sql_analyzer.main --validate --format html --output validation_report.html path/to/your/sql/files/
```
```

### 7. Add Tests

Create test cases for the validation functionality:

1. Create a new test file `tests/test_validation.py`
2. Add tests for valid and invalid SQL files
3. Test different output formats
4. Test the exit codes

## Task Breakdown

1. **CLI Enhancement** (2 hours)
   - Add validation option to CLI
   - Update command-line help
   - Add tests for CLI changes

2. **Core Validation Logic** (4 hours)
   - Create validation module
   - Implement file validation functions
   - Add error handling and reporting
   - Write tests for validation logic

3. **Reporting for Validation** (3 hours)
   - Extend reporting system to handle validation results
   - Implement text, JSON, and HTML formats for validation
   - Create templates for HTML output
   - Test different report formats

4. **Integration** (2 hours)
   - Connect validation to main entry point
   - Ensure proper exit codes
   - Test end-to-end validation workflow

5. **Documentation** (1 hour)
   - Update README with validation examples
   - Add docstrings to new functions
   - Create example validation outputs

## Timeline

Total estimated time: 12 hours

- Day 1: CLI enhancement and core validation logic (6 hours)
- Day 2: Reporting, integration, and documentation (6 hours)

## Future Enhancements

1. Add more detailed error explanations
2. Provide suggestions for fixing common syntax errors
3. Add batch validation mode for CI/CD pipelines
4. Create a standalone validation script
5. Add syntax highlighting in HTML validation reports 