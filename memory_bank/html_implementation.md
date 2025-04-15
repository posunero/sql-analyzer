# Implementation Plan: HTML Output for SQL Analyzer

This plan outlines the steps required to implement the HTML output feature based on the `html_output_design.md` document.

## 1. Setup and Dependencies ✅

1.  **Add Dependency:**
    *   Modify `requirements.txt` to include `Jinja2`. ✅
    *   Run `pip install -r requirements.txt` (or equivalent environment update). ✅
2.  **Create Files/Directories:**
    *   Create the new Python module file: `sql_analyzer/reporting/formats/html.py`. ✅
    *   Create a directory for templates: `sql_analyzer/reporting/formats/templates/`. ✅
    *   Create the Jinja2 template file: `sql_analyzer/reporting/formats/templates/report_template.html.j2`. ✅

## 2. Command-Line Interface (CLI) Updates ✅

1.  **Modify `sql_analyzer/cli.py`:**
    *   Locate the `parser.add_argument` call for `--format`. ✅
    *   Add `'html'` to the `choices` list: `choices=['text', 'json', 'html']`. ✅
    *   Uncomment the `parser.add_argument` block for `--output`/`--out`. Ensure it accepts a string argument and defaults to `None`. ✅

## 3. Main Application Flow Updates ✅

1.  **Modify `sql_analyzer/main.py`:**
    *   Import `sys` at the top. ✅
    *   Locate the report generation section near the end of the `main()` function. ✅
    *   Modify the logic:
        *   Store the output of `reporting_manager.generate_report(...)` in a variable (e.g., `report_output`). ✅
        *   Check if `args.output` is set (i.e., not `None`). ✅
        *   If `args.output` is set:
            *   Use `pathlib.Path(args.output).write_text(report_output, encoding='utf-8')` to write the report to the specified file. Add appropriate error handling (e.g., `try...except IOError`). Log success or failure. ✅
            *   Consider if you still want to print *anything* to stdout when outputting to a file (e.g., a confirmation message like "Report written to report.html"). ✅
        *   Else (`args.output` is `None`):
            *   Print `report_output` to `sys.stdout` as it does currently. ✅

## 4. Reporting Manager Updates ✅

1.  **Modify `sql_analyzer/reporting/manager.py`:**
    *   Add the import: `from .formats import text, json, html`. ✅
    *   Add the new formatter to the `_FORMATTERS` dictionary: `'html': html.format_html,`. ✅

## 5. HTML Formatter Implementation ✅

1.  **Implement `sql_analyzer/reporting/formats/html.py`:**
    *   Add imports: `from ...analysis.models import AnalysisResult`, `from jinja2 import Environment, FileSystemLoader, select_autoescape`, `import datetime`, `import os`. ✅
    *   Define the function `format_html(result: AnalysisResult, **kwargs) -> str`. ✅
    *   Determine the path to the `templates` directory relative to `html.py`: `template_dir = os.path.join(os.path.dirname(__file__), 'templates')`. ✅
    *   Set up the Jinja2 environment:
        ```python
        env = Environment(
            loader=FileSystemLoader(template_dir),
            autoescape=select_autoescape(['html', 'xml'])
        )
        ``` ✅
    *   Load the template: `template = env.get_template('report_template.html.j2')`. ✅
    *   Prepare the context dictionary to pass to the template. This should include:
        *   The `result` object itself. ✅
        *   Generation timestamp: `datetime.datetime.now().isoformat()`. ✅
        *   Processed data suitable for easy rendering (e.g., sorted `object_interactions`). Convert sets to sorted lists for deterministic output if needed. ✅
        ```python
        # Example context preparation
        object_interactions_sorted = sorted(result.object_interactions.items())
        context = {
            'result': result,
            'generation_time': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC"),
            'object_interactions_sorted': [
                (obj_key, sorted(list(actions))) for obj_key, actions in object_interactions_sorted
            ],
            # Add other processed data as needed
        }
        ``` ✅
    *   Render the template: `html_output = template.render(context)`. ✅
    *   Return `html_output`. ✅

## 6. HTML Template Implementation ✅

1.  **Implement `sql_analyzer/reporting/formats/templates/report_template.html.j2`:**
    *   Create the HTML boilerplate (`<!DOCTYPE html>`, `<html>`, `<head>`, `<body>`). ✅
    *   Add `<meta charset="UTF-8">` and `<title>SQL Analysis Report</title>` in `<head>`. ✅
    *   Add a `<style>` block in `<head>`. Define CSS rules for:
        *   Basic body styling (font, margins). ✅
        *   Headings (`h1`, `h2`, `h3`). ✅
        *   Tables (`table`, `th`, `td`, borders, padding, alternating rows `tbody tr:nth-child(odd)`). ✅
        *   Error messages (e.g., class `.error-message`, `color: red;`). ✅
        *   Summary sections (e.g., class `.summary-card`). ✅
        *   Code/monospace elements (`code`, `pre`). ✅
        *   Optional `<details>` styling. ✅
    *   In `<body>`, use Jinja2 syntax to render the data passed in the context:
        *   Header: `<h1>SQL Analysis Report</h1>`, `<p>Generated: {{ generation_time }}</p>`. ✅
        *   Summary: Display `result.statement_counts`, `result.destructive_counts`, total errors (`result.errors|length`). Use `{% for key, value in dictionary.items() %}`. ✅
        *   Errors: Use an `{% if result.errors %}` block. Inside, create a `<table>` iterating through `result.errors` with columns for File, Line, Message. Apply the `.error-message` class where appropriate. ✅
        *   Object Interactions: Create a `<table>` iterating through `object_interactions_sorted`. Columns: Type (`item[0][0]`), Name (`item[0][1]`), Actions (`item[1]|join(', ')`). ✅
        *   (Optional) Detailed Occurrences: Use `<details>`/`<summary>`. Inside, create a `<table>` iterating through `result.objects_found` with columns: File, Line, Column, Type, Name, Action. ✅
    *   Ensure HTML escaping is handled correctly by Jinja2 (which `select_autoescape` helps with). ✅

## 7. Testing

1.  **Prepare Test Data:** Ensure `sample_sql/` or other test directories contain SQL files that produce various results (different statements, objects created/referenced/dropped, parsing errors).
2.  **Run Analysis:**
    ```bash
    python -m sql_analyzer sample_sql/ --format html --output report.html
    # Also test multiple inputs
    python -m sql_analyzer sample_sql/another_dir/ --format html --output report2.html
    # Test stdout
    python -m sql_analyzer sample_sql/ --format html
    ```
3.  **Verify Output:**
    *   Open `report.html` in a web browser. Check for rendering issues, correct data display, and overall readability.
    *   Verify all sections (Summary, Errors, Objects) are present and contain the expected information.
    *   Check if errors are clearly marked.
    *   Check table sorting and formatting.
    *   Verify the `--output` flag works correctly and files are created.
    *   Verify printing to stdout works when `--output` is omitted for the HTML format.
4.  **Regression Testing:**
    *   Run the analyzer with `--format text` and `--format json` (with and without `--output`) to ensure existing functionality is not broken. 