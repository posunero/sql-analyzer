# SQL Analyzer Implementation Plan

This document outlines the steps to implement the SQL Analyzer project based on the defined specification and project structure.

## Phase 1: Core Parsing and Analysis Logic

1.  [x] **Load Grammar & Basic Parsing (`parser/core.py`):**
    *   Implement robust loading of the `snowflake.lark` grammar file.
    *   Create a function `parse_sql(sql_text: str)` that takes SQL text and returns a Lark parse tree or raises a specific parsing error.
    *   Handle potential `LarkError` exceptions gracefully.

2.  [x] **Define Analysis Data Structures (`analysis/models.py`):**
    *   Define Python classes or dataclasses to represent the analysis results. Examples:
        *   `AnalysisResult` (overall container)
        *   `StatementStats` (counts per statement type)
        *   `ObjectInfo` (details about a DB object: name, type, action - create/alter/drop/reference)
    *   Ensure these structures can aggregate results from multiple files.

3.  [x] **Implement AST Visitor (`parser/visitor.py`):**
    *   Create a Lark `Visitor` or `Transformer` subclass.
    *   Implement methods for relevant Lark rules (e.g., `visit_create_table_statement`, `visit_select_statement`, `visit_table_name`, etc.).
    *   The visitor's role is primarily to *identify* nodes of interest and pass them to the analysis engine.

4.  [x] **Develop Analysis Engine (`analysis/engine.py`):**
    *   Create an `AnalysisEngine` class that takes an `AnalysisResult` object (from `models.py`).
    *   The engine will use the `Visitor` (from `visitor.py`). When the visitor encounters relevant nodes (like a statement type or an object name), it calls methods on the `AnalysisEngine`.
    *   The `AnalysisEngine` methods update the `AnalysisResult` object (e.g., increment statement counts, add object details to lists).

5.  [x] **Initial Testing (`tests/test_parser.py`, `tests/test_analysis.py`):**
    *   Add basic test fixtures (simple valid/invalid SQL strings).
    *   Write unit tests for `parse_sql` to ensure it parses correctly or raises errors as expected.
    *   Write unit tests for the `AnalysisEngine` and `Visitor` combination to verify that simple statements are correctly identified and counted.

## Phase 2: File Handling and Command Line Interface

6.  [x] **Implement File System Utilities (`utils/file_system.py`):**
    *   Create function `find_sql_files(path: str)` that yields file paths (handles single files and recursive directory searching for `.sql` files).
    *   Create function `read_file_content(file_path: str)` that reads a file and handles potential `IOError`.

7.  [x] **Implement CLI Argument Parsing (`cli.py`):**
    *   Use `argparse` (or similar) to define command-line arguments:
        *   Input paths (required, one or more).
        *   Output format (`--format`, default 'text', choices: 'text', 'json', 'csv').
        *   Verbosity (`--verbose` flag).
        *   Error handling options (e.g., `--fail-fast`).
    *   Create a function `parse_arguments()` that returns a configuration object or dictionary.

8.  [x] **Basic Error Handling (`utils/error_handling.py`):**
    *   Define simple functions for reporting errors (e.g., `report_parsing_error(file_path, line, message)`, `report_file_error(file_path, message)`).

9.  [x] **Initial Integration (`main.py`):**
    *   Modify `main.py` to:
        *   Call `cli.parse_arguments()`.
        *   Use `utils.find_sql_files` to iterate through input paths.
        *   For each file:
            *   Call `utils.read_file_content`.
            *   Call `parser.parse_sql`.
            *   Instantiate `AnalysisEngine` and `Visitor`.
            *   Run the visitor on the parse tree.
            *   Aggregate results into a main `AnalysisResult` object.
        *   Catch and report errors using `utils.error_handling`.
    *   Add a placeholder for calling the reporting module.

10. [x] **CLI Testing (`tests/test_cli.py`):**
    *   Write tests to verify argument parsing logic.

## Phase 3: Reporting and Finalization

11. **Implement Report Formatters (`reporting/formats/`):**
    *   Implement `text.py`: Format the `AnalysisResult` object into a human-readable summary.
    *   Implement `json.py`: Serialize the `AnalysisResult` object into JSON.
    *   (Optional) Implement `csv.py`.

12. **Implement Report Manager (`reporting/manager.py`):**
    *   Create a function `generate_report(result: AnalysisResult, format: str)` that selects the correct formatter based on the `format` string and calls it.

13. **Complete `main.py` Integration:**
    *   Call `reporting.generate_report` at the end of the main loop to print the final results to standard output.

14. **Refine Error Handling and Verbosity:**
    *   Improve error messages.
    *   Implement different levels of output detail based on the verbosity flag.

15. **Documentation (`README.md`, Docstrings):**
    *   Update `README.md` with detailed usage instructions, options, and examples.
    *   Add comprehensive docstrings to all modules, classes, and functions.

16. **Comprehensive Testing (`tests/`):**
    *   Add more complex test fixtures (SQL files).
    *   Expand test coverage for parsing edge cases, analysis logic, and reporting formats.

## Dependencies

*   `lark-parser`: Core dependency for parsing. Ensure `requirements.txt` and `pyproject.toml` are accurate.

## Potential Challenges

*   **Grammar Completeness:** The `snowflake.lark` grammar might need significant refinement to cover the required Snowflake SQL syntax accurately.
*   **AST Complexity:** Navigating the potentially complex Lark AST to extract specific information reliably.
*   **Performance:** Handling very large SQL files efficiently. 