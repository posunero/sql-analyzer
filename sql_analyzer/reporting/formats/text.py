"""
Formats analysis results into a human-readable text summary.
"""

from collections import Counter
from sql_analyzer.analysis.models import AnalysisResult

def format_report(result: AnalysisResult, verbose: bool = False) -> str:
    """Generates a multi-section, human-readable text report string.

    Includes sections for Statement Summary, Object Summary, and Error Summary.

    Args:
        result: The AnalysisResult object.
        verbose: If True, includes more detailed information like object locations.

    Returns:
        A string containing the formatted multi-line text report.
    """
    report_lines = [] # List to hold lines of the report

    report_lines.append("SQL Analysis Report")
    report_lines.append("=================")

    # --- Statement Counts --- 
    report_lines.append("\n--- Statement Summary ---")
    if result.statement_counts:
        total_statements = sum(result.statement_counts.values())
        report_lines.append(f"Total Statements Analyzed: {total_statements}")
        # Sort for consistent output
        for stmt_type, count in sorted(result.statement_counts.items()):
            report_lines.append(f"  {stmt_type}: {count}")
    else:
        report_lines.append("No statements found.")

    # --- Object Summary --- 
    report_lines.append("\n--- Object Summary ---")
    if result.objects_found:
        report_lines.append(f"Total Objects Found: {len(result.objects_found)}")
        # Group by type and action for a summarized view
        object_summary = Counter((obj.object_type, obj.action) for obj in result.objects_found)
        if object_summary:
            report_lines.append("\nCounts by Type and Action:")
            # Sort for consistent output
            for (obj_type, action), count in sorted(object_summary.items()):
                report_lines.append(f"  {obj_type} - {action}: {count}")

        # Detailed object listing (optional based on verbosity)
        if verbose:
            report_lines.append("\nDetailed Object List:")
            # Sort objects for consistent output, e.g., by type then name
            sorted_objects = sorted(result.objects_found, key=lambda x: (x.object_type, x.name))
            for obj in sorted_objects:
                location = f" (Line: {obj.line}, Col: {obj.column})" if obj.line else ""
                report_lines.append(f"  - {obj.action} {obj.object_type} {obj.name}{location}")

    else:
        report_lines.append("No database objects found.")

    # --- Error Summary --- 
    report_lines.append("\n--- Error Summary ---")
    if result.errors:
        report_lines.append(f"Total Errors: {len(result.errors)}")
        for error in result.errors:
            report_lines.append(f"  - File: {error.get('file', 'N/A')}, Line: {error.get('line', 'N/A')}: {error.get('message', 'Unknown error')}")
    else:
        report_lines.append("No errors reported.")

    report_lines.append("\n=================")

    return "\n".join(report_lines) 