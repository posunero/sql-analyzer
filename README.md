# SQL Analyzer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

A command-line tool to analyze Snowflake SQL files, extracting metadata, statistics, and identifying potential issues or patterns.

## Features

*   Parses Snowflake SQL syntax using a Lark grammar.
*   Identifies and counts statement types (e.g., `CREATE_TABLE`, `SELECT`, `INSERT`, `USE_WAREHOUSE`, `USE_DATABASE`, `ALTER_TABLE`, `DROP_VIEW`).
*   Extracts database objects (tables, views, functions, databases, warehouses, etc.) and tracks their actions (e.g., `CREATE`, `ALTER`, `DROP`, `USE`, `REFERENCE`).
*   Aggregates statistics across multiple files.
*   Supports different output formats (Text, JSON - more planned).
*   Handles file and directory inputs.

## Installation

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd sql-analyzer
    ```
2.  **Set up a virtual environment (recommended):**
    ```bash
    python -m venv venv
    # On Windows
    .\venv\Scripts\activate
    # On macOS/Linux
    source venv/bin/activate
    ```
3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

## Usage

The SQL Analyzer is run from the command line.

**Basic Syntax:**

```bash
python -m sql_analyzer.main [OPTIONS] <input_path1> [input_path2 ...]
```

**Arguments:**

*   `input_path`: One or more required paths to SQL files or directories containing `.sql` files. The tool will search directories recursively.

**Options:**

*   `--format {text,json}`: Specify the output format for the analysis results. (Default: `text`) (*Note: CSV format is planned but not yet implemented.*)
*   `--log-level {DEBUG,INFO,WARNING,ERROR,CRITICAL}` (alias: `--verbose`): Set the detail level for logging messages. (Default: `INFO`)
*   `--verbose-report`: Generate a more detailed report. For the `text` format, this includes the line and column number for each object found.
*   `--fail-fast`: Stop processing immediately if an error (like a parsing error) is encountered in any file. By default, the tool tries to process all specified files.

**Examples:**

1.  **Analyze a single SQL file:**
    ```bash
    python -m sql_analyzer.main path/to/your/script.sql
    ```

2.  **Analyze all `.sql` files in a directory (recursively):**
    ```bash
    python -m sql_analyzer.main path/to/your/sql/directory/
    ```

3.  **Analyze multiple files and directories:**
    ```bash
    python -m sql_analyzer.main file1.sql another_dir/ specific_scripts/script.sql
    ```

4.  **Output results in JSON format:**
    ```bash
    python -m sql_analyzer.main --format json path/to/your/sql/directory/
    ```

5.  **Run with detailed debug logging:**
    ```bash
    python -m sql_analyzer.main --verbose DEBUG path/to/your/script.sql
    ```

6.  **Stop immediately if any file fails to parse:**
    ```bash
    python -m sql_analyzer.main --fail-fast path/to/your/sql/directory/
    ```

7.  **Generate a verbose text report showing object locations:**
    ```bash
    python -m sql_analyzer.main --verbose-report path/to/your/sql/directory/
    ```

## Project Structure

```
sql-analyzer/
├── .venv/                   # Virtual environment
├── memory_bank/             # AI Memory/Implementation Plan (optional)
├── sample_sql/              # Sample SQL files for testing/examples
├── sql_analyzer/            # Main application source code
│   ├── __init__.py
│   ├── analysis/            # Core analysis logic and data models
│   │   ├── __init__.py
│   │   ├── engine.py        # AnalysisEngine class
│   │   └── models.py        # Data structures (AnalysisResult, etc.)
│   ├── cli.py               # Command-line interface parsing
│   ├── grammar/             # Lark grammar files
│   │   ├── __init__.py
│   │   └── snowflake.lark   # Snowflake SQL grammar
│   ├── parser/              # SQL parsing components
│   │   ├── __init__.py
│   │   ├── core.py          # Main parsing functions
│   │   └── visitor.py       # AST visitor
│   ├── reporting/           # Report generation
│   │   ├── __init__.py
│   │   ├── formats/         # Output formatters (text, json)
│   │   │   ├── __init__.py
│   │   │   ├── json.py
│   │   │   └── text.py
│   │   └── manager.py       # Selects and runs the correct formatter
│   ├── utils/               # Utility functions
│   │   ├── __init__.py
│   │   ├── error_handling.py
│   │   └── file_system.py
│   └── main.py              # Main script entry point
├── tests/                   # Unit and integration tests
│   ├── __init__.py
│   ├── fixtures/            # Test data (SQL files, etc.)
│   ├── test_analysis.py
│   ├── test_cli.py
│   ├── test_parser.py
│   └── test_reporting.py
├── .gitignore
├── LICENSE                  # Project license file
├── README.md                # This file
├── pyproject.toml           # Project metadata and dependencies (for build/packaging)
└── requirements.txt         # Project dependencies (for pip install)
```

## Example Output

Below are examples of the `text` output format.

**Standard Text Output:**

```text
--- SQL Analysis Report ---

== Statement Summary ==
Total statements analyzed: 5
  - create_table: 2
  - select: 2
  - insert: 1

== Object Summary ==
Total objects found: 6
Summary by Type and Action:
  - CREATE TABLE: 2
  - REFERENCE FUNCTION: 1
  - REFERENCE TABLE: 3

== Errors ==
Total errors encountered: 1
  - [File: sample_sql/invalid/bad_syntax.sql, Line: 3]: Lark parsing error at line 3, column 1: Unexpected token Token('FROM', 'FROM') at line 3, column 1.
Expected one of: 
	* RPAR
	* AS
	* COMMA
	* DOT

--- End Report ---
```

**Verbose Text Output (`--verbose-report`):**

```text
--- SQL Analysis Report ---

== Statement Summary ==
Total statements analyzed: 5
  - create_table: 2
  - select: 2
  - insert: 1

== Object Summary ==
Total objects found: 6
Summary by Type and Action:
  - CREATE TABLE: 2
  - REFERENCE FUNCTION: 1
  - REFERENCE TABLE: 3

Detailed Object List:
  File: sample_sql/complex_script.sql
    - CREATE TABLE: MY_SCHEMA.NEW_TABLE (Line: 2)
    - REFERENCE TABLE: SOURCE_TABLE1 (Line: 7)
    - REFERENCE TABLE: SOURCE_TABLE2 (Line: 8)
    - REFERENCE FUNCTION: BUILTIN_FUNC (Line: 8)
    - CREATE TABLE: ANOTHER_TABLE (Line: 12)
    - REFERENCE TABLE: MY_SCHEMA.NEW_TABLE (Line: 15)

== Errors ==
Total errors encountered: 1
  - [File: sample_sql/invalid/bad_syntax.sql, Line: 3]: Lark parsing error at line 3, column 1: Unexpected token Token('FROM', 'FROM') at line 3, column 1.
Expected one of: 
	* RPAR
	* AS
	* COMMA
	* DOT

--- End Report ---
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs, feature requests, or improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
