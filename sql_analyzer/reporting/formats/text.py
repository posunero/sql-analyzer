"""
Formats analysis results into a human-readable text summary.
"""

import io
from collections import Counter
from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo

def format_text(result: AnalysisResult, verbose: bool = False) -> str:
    """Formats the analysis result into a plain text string.

    Includes sections for Statement Summary, Object Summary, and Errors.

    Args:
        result: The AnalysisResult object.
        verbose: If True, includes a detailed list of objects found with their
                 file paths and line numbers in the Object Summary section.

    Returns:
        A string containing the formatted text report.
    """
    output = io.StringIO()

    output.write("--- SQL Analysis Report ---\n\n")

    # --- Statement Summary ---
    output.write("== Statement Summary ==\n")
    if result.statement_counts:
        total_statements = sum(result.statement_counts.values())
        output.write(f"Total statements analyzed: {total_statements}\n")
        # Sort by count descending, then by type ascending
        sorted_counts = sorted(result.statement_counts.items(), key=lambda item: (-item[1], item[0]))
        for stmt_type, count in sorted_counts:
            output.write(f"  - {stmt_type}: {count}\n")
    else:
        output.write("No statements found.\n")
    output.write("\n")

    # --- Object Summary ---
    output.write("== Object Summary ==\n")
    if result.objects_found:
        output.write(f"Total objects found: {len(result.objects_found)}\n")
        # Group by type and action
        objects_by_type_action = Counter((obj.object_type, obj.action) for obj in result.objects_found)
        sorted_obj_summary = sorted(objects_by_type_action.items())

        output.write("Summary by Type and Action:\n")
        for (obj_type, action), count in sorted_obj_summary:
             output.write(f"  - {action} {obj_type}: {count}\n")

        # Optional: Add detailed list later if needed via verbosity flag
        if verbose:
            output.write("\nDetailed Object List:\n")
            sorted_objects = sorted(result.objects_found, key=lambda o: (o.file_path, o.line, o.object_type, o.action, o.name))
            last_file = None
            for obj in sorted_objects:
                if obj.file_path != last_file:
                    output.write(f"  File: {obj.file_path}\n")
                    last_file = obj.file_path
                location = f" (Line: {obj.line})" if obj.line > 0 else ""
                # Indent object details under the file path
                output.write(f"    - {obj.action} {obj.object_type}: {obj.name}{location}\n")
    else:
        output.write("No database objects found.\n")
    output.write("\n")

    # --- Error Summary ---
    output.write("== Errors ==\n")
    if result.errors:
        output.write(f"Total errors encountered: {len(result.errors)}\n")
        # Sort errors by file, then by line
        sorted_errors = sorted(result.errors, key=lambda e: (e.get('file', ''), e.get('line', 0)))
        for error in sorted_errors:
            file_info = f"File: {error.get('file', 'N/A')}"
            line_info = f"Line: {error.get('line', 'N/A')}"
            message = error.get('message', 'Unknown error')
            output.write(f"  - [{file_info}, {line_info}]: {message}\n")
    else:
        output.write("No errors encountered.\n")
    output.write("\n")

    output.write("--- End Report ---\n")

    return output.getvalue()

# Ensure the directory exists if running this directly for testing (unlikely needed)
# if __name__ == '__main__':
#     from pathlib import Path
#     Path(__file__).parent.mkdir(parents=True, exist_ok=True) 