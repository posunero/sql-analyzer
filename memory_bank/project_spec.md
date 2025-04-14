# SQL Analyzer Project Specification

## 1. Overview

The SQL Analyzer project aims to create a tool that parses and analyzes Snowflake SQL scripts. The primary goal is to generate statistics and summaries about the SQL statements contained within one or more files. This analysis will help users, such as developers and database administrators, understand the scope and potential impact of SQL scripts, primarily for verification and review purposes.

## 2. Goals

*   **Identify Statement Types:** Count and categorize all SQL statements (e.g., `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE TABLE`, `ALTER WAREHOUSE`, `DROP FUNCTION`, etc.).
*   **Identify Targeted Objects:** List all database objects (tables, views, functions, procedures, warehouses, tasks, streams, etc.) that are referenced, created, modified, or dropped.
*   **Summarize Changes:** Provide a concise summary of the actions performed by the script(s).
*   **Aid Code Review:** Enable reviewers to quickly grasp the changes proposed in a SQL file or set of files.
*   **Impact Assessment:** Help users understand which parts of the database might be affected by running the script(s).

## 3. Input

*   **Source:** The tool will accept one or more `.sql` file paths or directory paths as input via command-line arguments. If a directory is provided, the tool should recursively find and process all `.sql` files within it.
*   **SQL Dialect:** The parser will specifically target Snowflake SQL syntax.
*   **Error Handling:** The tool should gracefully handle:
    *   Files that cannot be read.
    *   Files containing invalid SQL syntax (report errors, potentially attempt to continue parsing subsequent statements or files).
    *   Snowflake-specific comments and syntax nuances.

## 4. Processing

*   **Parsing:** Utilize a robust SQL parser (e.g., based on the Lark grammar already present) to create an Abstract Syntax Tree (AST) for each SQL statement.
*   **Analysis:** Traverse the AST to:
    *   Identify the type of each statement.
    *   Extract names of objects being acted upon (e.g., table names in `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`, `SELECT`, `INSERT`, `UPDATE`, `DELETE`).
    *   Extract names of other objects (warehouses, tasks, streams, functions, procedures, etc.).
    *   Differentiate between object references (e.g., `SELECT * FROM my_table`) and modifications (e.g., `ALTER TABLE my_table ...`, `INSERT INTO my_table ...`).
*   **Aggregation:** Consolidate the analysis results across all processed statements and files.

## 5. Output

*   **Format:** The primary output will be a structured summary printed to standard output. Consider supporting multiple output formats via command-line flags:
    *   **Text (Default):** Human-readable summary.
        *   Overall counts of each statement type.
        *   Lists of objects created, altered, dropped, and referenced (grouped by object type - tables, views, warehouses, etc.).
    *   **JSON:** Machine-readable format containing detailed analysis results, suitable for integration with other tools.
    *   **CSV:** Potential format for easily importing lists of affected objects into spreadsheets.
*   **Verbosity:** Allow different levels of detail (e.g., a concise summary vs. a detailed statement-by-statement breakdown).
*   **Error Reporting:** Clearly report any parsing errors encountered, including the file name and approximate location (line number) if possible.

## 6. Non-Functional Requirements

*   **Performance:** Should handle reasonably large SQL files efficiently.
*   **Accuracy:** The parser must accurately interpret Snowflake SQL syntax, including common DDL, DML, and DCL statements.
*   **Maintainability:** Code should be well-structured and documented to allow for future extensions.

## 7. Potential Future Enhancements

*   **Dependency Analysis:** Identify dependencies between objects within the script(s) (e.g., a view created that depends on a table also created).
*   **Risk Analysis:** Flag potentially dangerous operations (e.g., `DROP TABLE`, `UPDATE`/`DELETE` without a `WHERE` clause).
*   **Cost Estimation Hints:** Provide basic warnings if statements might involve significant warehouse usage (e.g., large `CREATE TABLE AS SELECT`).
*   **SQL Style Checking:** Enforce basic formatting or naming conventions.
*   **CI/CD Integration:** Package the tool for easy integration into CI/CD pipelines to automatically analyze SQL changes in pull requests.
*   **Support for other SQL dialects.**
*   **Configuration File:** Allow customization of analysis rules or output formats via a configuration file.

## 8. Proposed Project Structure

```
sql_analyzer/
├── __init__.py             # Makes sql_analyzer a Python package
├── main.py                 # Main script, entry point for the application
├── cli.py                  # Handles command-line argument parsing (using argparse, click, or typer)
│
├── grammar/
│   ├── __init__.py
│   └── snowflake.lark      # The Lark grammar file for Snowflake SQL syntax
│
├── parser/
│   ├── __init__.py
│   ├── core.py             # Loads the Lark grammar and provides parsing functions
│   └── visitor.py          # Contains Lark Visitor/Transformer classes to traverse the AST
│
├── analysis/
│   ├── __init__.py
│   ├── models.py           # Defines data structures to hold analysis results (e.g., statement counts, object lists)
│   └── engine.py           # Core analysis logic: uses the visitor to populate analysis models from the AST
│
├── reporting/
│   ├── __init__.py
│   ├── formats/            # Module for different output formatters
│   │   ├── __init__.py
│   │   ├── text.py         # Generates human-readable text output
│   │   ├── json.py         # Generates JSON output
│   │   └── csv.py          # Generates CSV output (if implemented)
│   └── manager.py          # Selects the appropriate formatter based on user request
│
└── utils/
    ├── __init__.py
    ├── file_system.py      # Utilities for finding/reading SQL files
    └── error_handling.py   # Centralized error reporting utilities

tests/                      # Directory for all tests
├── __init__.py
├── fixtures/               # Contains sample .sql files for testing
│   ├── valid/
│   └── invalid/
├── test_parser.py          # Tests for the parser module
├── test_analysis.py        # Tests for the analysis engine
├── test_reporting.py       # Tests for output formatting
└── test_cli.py             # Tests for the command-line interface

README.md                   # Overall project documentation, setup, and usage instructions
requirements.txt            # Lists project dependencies (e.g., lark)
pyproject.toml              # Project build configuration (optional, but good practice)
```

**Explanation:**

*   **`main.py`**: The main executable script that orchestrates the process: gets CLI args, finds files, calls parser, analyzer, and reporter.
*   **`cli.py`**: Dedicated to parsing command-line arguments (input files/dirs, output format, verbosity).
*   **`grammar/`**: Stores the `snowflake.lark` grammar file. Separated for clarity.
*   **`parser/`**: Handles loading the grammar (`core.py`) and traversing the Abstract Syntax Tree (AST) generated by Lark (`visitor.py`).
*   **`analysis/`**: Contains the core logic. `models.py` defines how analysis results are stored. `engine.py` uses the `parser.visitor` to walk the AST and extract the required information, populating the models.
*   **`reporting/`**: Responsible for presenting the analysis results. `manager.py` chooses the correct format (text, JSON, etc.) based on CLI arguments, and the actual formatting logic resides in the `formats/` sub-module.
*   **`utils/`**: Holds common utility functions, like finding `.sql` files or handling errors consistently.
*   **`tests/`**: Contains unit and integration tests, crucial for verifying correctness, especially for the parser and analyzer. `fixtures/` provides sample SQL files.
*   **Root Files**: Standard Python project files like `README.md`, `requirements.txt`, and optionally `pyproject.toml`.



