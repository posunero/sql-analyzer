# SQL Analyzer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

A command-line tool to analyze Snowflake SQL files, extracting metadata, statistics, and identifying potential issues or patterns.

## Features

*   Parses Snowflake SQL syntax.
*   Identifies statement types (CREATE, SELECT, INSERT, etc.).
*   Extracts referenced database objects (tables, views, functions, etc.).
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

*   `--format {text,json,csv}`: Specify the output format for the analysis results. (Default: `text`)
*   `--verbose {DEBUG,INFO,WARNING,ERROR,CRITICAL}` or `--log-level {DEBUG,INFO,WARNING,ERROR,CRITICAL}`: Set the logging level for console output. (Default: `INFO`)
*   `--fail-fast`: Stop processing immediately if an error is encountered in any file. By default, the tool tries to process all files even if some have errors.

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

## Contributing

Contributions are welcome! Please read the contributing guidelines (if any).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details (You'll need to create a LICENSE file).
