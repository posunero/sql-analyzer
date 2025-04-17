# SQL Analyzer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

A command-line tool to analyze Snowflake SQL files, extracting metadata, statistics, and identifying potential issues or patterns.

## Features

*   Parses Snowflake SQL syntax using a Lark grammar. Key supported constructs include:
    *   **DDL**: `CREATE/ALTER/DROP/SHOW/DESCRIBE` for `TABLE`, `VIEW`, `WAREHOUSE`, `TASK`, `STREAM`, `STAGE`, `DATABASE`, `SCHEMA`, `PROCEDURE`, `FUNCTION`, `SEQUENCE`, `RESOURCE MONITOR`, `FILE FORMAT`, `ROLE`, `MASKING POLICY`, `TAG`, `ROW ACCESS POLICY`.
    *   **Advanced DDL**: `CREATE OR REPLACE`, `IF [NOT] EXISTS`, `TRANSIENT` tables, `CLUSTER BY (expr...)`, `DATA_RETENTION_TIME_IN_DAYS`, table `WITH TAG (...)`, column `COMMENT '...'`, `CREATE TABLE AS SELECT` (CTAS), `ALTER TABLE` actions (including `ADD/DROP/RENAME ROW ACCESS POLICY`).
    *   **DML**: `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `INSERT ALL` (multi-table insert), `TRUNCATE`.
    *   **Query**: `SELECT`, `WITH` (CTEs), various `JOIN` types, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`, window functions (`func() OVER (PARTITION BY ... ORDER BY ...)`), `LATERAL FLATTEN` table functions, `IN (...)` tuple syntax.
    *   **Transactions**: `BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`.
    *   **Snowflake Scripting**: `DECLARE`, `SET`, `EXECUTE IMMEDIATE $$...$$`.
    *   **Other**: `USE`, `GRANT`, `REVOKE`, `COPY INTO`, `PUT`.
*   Identifies and counts statement types (e.g., `SELECT`, `CREATE_TABLE`, `INSERT`, `USE_WAREHOUSE`, `USE_DATABASE`, `ALTER_TABLE`).
*   Tracks destructive operations (e.g., `CREATE OR REPLACE`, `DROP`, `DELETE`, `TRUNCATE`, `ALTER TABLE DROP COLUMN`).
*   Extracts database objects (tables, views, functions, databases, warehouses, etc.) and tracks their actions (e.g., `CREATE`, `ALTER`, `DROP`, `USE`, `REFERENCE`, `SELECT`).
*   Generates object interaction summaries showing all actions performed on each object.
*   Flags objects with potentially conflicting actions (marked with `[!]` in reports).
*   Aggregates statistics across multiple files.
*   Supports different output formats (Text, JSON, HTML). (CSV format is planned but not yet implemented.)
*   Handles file and directory inputs.

## Snowflake SQL Coverage

Current implementation covers approximately **70-75%** of the Snowflake SQL specification. The parser successfully handles:

- Core SQL syntax (SELECT, INSERT, UPDATE, DELETE)
- Most DDL operations for common Snowflake objects
- Standard DML operations
- Transaction control statements
- Basic Snowflake-specific features (warehouses, tasks, streams)
- Function and procedure definitions with various language options
- Data sharing features

**Areas planned for future implementation (25-30% remaining):**

- Advanced Snowflake features:
  - Complete LATERAL FLATTEN and semi-structured data operations
  - Full Cortex Search capabilities
  - Database and application roles
  - Container Services and job features

- Modern analytics features:
  - Machine learning model operations
  - Full Apache Iceberg table support
  - Snowpark Container Services
  - Advanced monitoring and alerting

- Security and compliance:
  - Complete row access policies
  - Column-level security
  - Dynamic data masking
  - Authentication policies

- Data pipeline features:
  - Complete Snowpipe and Snowpipe streaming
  - Notification integrations

- Newer features (post-2023):
  - Organization accounts
  - Privacy policies
  - More cloud service integrations
  - Streamlit application support
  - External access integrations

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

*   `--format {text,json,html}`: Specify the output format for the analysis results. (Default: `text`) (*Note: CSV format is planned but not yet implemented.*)
*   `--log-level {DEBUG,INFO,WARNING,ERROR,CRITICAL}` (alias: `--verbose`): Set the detail level for logging messages. (Default: `INFO`)
*   `--verbose-report`: Generate a more detailed report. For the `text` format, this includes the line and column number for each object found.
*   `--fail-fast`: Stop processing immediately if an error (like a parsing error) is encountered in any file. By default, the tool tries to process all specified files.
*   `--output`, `--out` <file_path>: Optional path to write the output report file instead of printing to stdout.

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

5.  **Output results in HTML format:**
    ```bash
    python -m sql_analyzer.main --format html path/to/your/sql/directory/
    ```

6.  **Run with detailed debug logging:**
    ```bash
    python -m sql_analyzer.main --verbose DEBUG path/to/your/script.sql
    ```

7.  **Stop immediately if any file fails to parse:**
    ```bash
    python -m sql_analyzer.main --fail-fast path/to/your/sql/directory/
    ```

8.  **Generate a verbose text report showing object locations:**
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
│   │   ├── formats/         # Output formatters (text, json, html)
│   │   │   ├── __init__.py
│   │   │   ├── json.py
│   │   │   ├── text.py
│   │   │   └── html.py
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
Total statements analyzed: 24
  - USE_SCHEMA: 3
  - ALTER_TABLE: 2
  - CREATE_OR_REPLACE_TABLE: 2
  - CREATE_SCHEMA_STMT: 2
  - SELECT: 2
  - USE_DATABASE: 2
  - COPY_INTO_STMT: 1
  - CREATE_FUNCTION: 1
  - CREATE_OR_REPLACE_DATABASE: 1
  - CREATE_OR_REPLACE_PROCEDURE: 1
  - CREATE_OR_REPLACE_STAGE: 1
  - CREATE_OR_REPLACE_VIEW: 1
  - DELETE: 1
  - GRANT_STMT: 1
  - INSERT: 1
  - MERGE: 1
  - UPDATE: 1

== Destructive Operations Summary ==
Total destructive operations: 9
  - CREATE_OR_REPLACE_TABLE: 4
  - CREATE_OR_REPLACE_VIEW: 2
  - UPDATE: 2
  - DELETE: 1

== Object Summary ==
Total objects found: 23
Summary by Type and Action:
  - CREATE DATABASE: 1
  - USE DATABASE: 2
  - CREATE FUNCTION: 1
  - REFERENCE FUNCTION: 2
  - USE SCHEMA: 3
  - ALTER TABLE: 1
  - INSERT TABLE: 1
  - REFERENCE TABLE: 4
  - REPLACE TABLE: 2
  - SELECT TABLE: 4
  - UPDATE TABLE: 1
  - REPLACE VIEW: 1

== Object Interaction Summary ==
Total objects with interactions: 10
  - DATABASE: my_sample_db
    Actions: CREATE, USE
  - FUNCTION: CURRENT_DATE
    Actions: REFERENCE
  - FUNCTION: PARSE_JSON
    Actions: REFERENCE
  - FUNCTION: get_user_email
    Actions: CREATE
  - SCHEMA: production
    Actions: USE
  - SCHEMA: staging
    Actions: USE
  - TABLE: dim_users [!]
    Actions: REPLACE, REFERENCE, SELECT
  - TABLE: raw_events [!]
    Actions: REPLACE, ALTER, INSERT, REFERENCE, SELECT, UPDATE
  - TABLE: staging.raw_events
    Actions: REFERENCE, SELECT
  - VIEW: recent_events_v [!]
    Actions: REPLACE

== Errors ==
Total errors encountered: 1
  - [File: create_objects.sql, Line: 3]: Lark parsing error at line 3, column 39: No terminal matches 'C' in the current parser context, at line 3 col 39

--- End Report ---
```

**Verbose Text Output (`--verbose-report`):**

```text
--- SQL Analysis Report ---

== Statement Summary ==
Total statements analyzed: 24
  - USE_SCHEMA: 3
  - ALTER_TABLE: 2
  - CREATE_OR_REPLACE_TABLE: 2
  - CREATE_SCHEMA_STMT: 2
  - SELECT: 2
  - USE_DATABASE: 2
  - COPY_INTO_STMT: 1
  - CREATE_FUNCTION: 1
  - CREATE_OR_REPLACE_DATABASE: 1
  - CREATE_OR_REPLACE_PROCEDURE: 1
  - CREATE_OR_REPLACE_STAGE: 1
  - CREATE_OR_REPLACE_VIEW: 1
  - DELETE: 1
  - GRANT_STMT: 1
  - INSERT: 1
  - MERGE: 1
  - UPDATE: 1

== Destructive Operations Summary ==
Total destructive operations: 9
  - CREATE_OR_REPLACE_TABLE: 4
  - CREATE_OR_REPLACE_VIEW: 2
  - UPDATE: 2
  - DELETE: 1

== Object Summary ==
Total objects found: 23
Summary by Type and Action:
  - CREATE DATABASE: 1
  - USE DATABASE: 2
  - CREATE FUNCTION: 1
  - REFERENCE FUNCTION: 2
  - USE SCHEMA: 3
  - ALTER TABLE: 1
  - INSERT TABLE: 1
  - REFERENCE TABLE: 4
  - REPLACE TABLE: 2
  - SELECT TABLE: 4
  - UPDATE TABLE: 1
  - REPLACE VIEW: 1

Detailed Object List:
  File: sample_sql/simple_select.sql
    - SELECT TABLE: raw_events (Line: 4)
    - REFERENCE FUNCTION: CURRENT_DATE (Line: 5)
    - USE DATABASE: my_sample_db (Line: 12)
    - USE SCHEMA: production (Line: 13)
    - REPLACE TABLE: dim_users (Line: 15)
    - REFERENCE TABLE: staging.raw_events (Line: 18)
    - SELECT TABLE: raw_events (Line: 24)
    - ALTER TABLE: raw_events (Line: 29)
    - UPDATE TABLE: raw_events (Line: 33)
    - REPLACE VIEW: recent_events_v (Line: 38)
    - SELECT TABLE: raw_events (Line: 39)
    - REFERENCE FUNCTION: PARSE_JSON (Line: 40)
    - INSERT TABLE: raw_events (Line: 46)
    - SELECT TABLE: staging.raw_events (Line: 48)

== Object Interaction Summary ==
Total objects with interactions: 10
  - DATABASE: my_sample_db
    Actions: CREATE, USE
  - FUNCTION: CURRENT_DATE
    Actions: REFERENCE
  - FUNCTION: PARSE_JSON
    Actions: REFERENCE
  - FUNCTION: get_user_email
    Actions: CREATE
  - SCHEMA: production
    Actions: USE
  - SCHEMA: staging
    Actions: USE
  - TABLE: dim_users [!]
    Actions: REPLACE, REFERENCE, SELECT
  - TABLE: raw_events [!]
    Actions: REPLACE, ALTER, INSERT, REFERENCE, SELECT, UPDATE
  - TABLE: staging.raw_events
    Actions: REFERENCE, SELECT
  - VIEW: recent_events_v [!]
    Actions: REPLACE

== Errors ==
Total errors encountered: 1
  - [File: create_objects.sql, Line: 3]: Lark parsing error at line 3, column 39: No terminal matches 'C' in the current parser context, at line 3 col 39

--- End Report ---
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs, feature requests, or improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
