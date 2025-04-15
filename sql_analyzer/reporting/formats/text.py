"""
Formats analysis results into a human-readable text summary.
"""

import io
from collections import Counter
from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo

def format_text(result: AnalysisResult, verbose: bool = False) -> str:
    """Formats the analysis result into a plain text string.

    Includes sections for Statement Summary, Object Summary, and Errors.
    Also includes new sections for Destructive Operations Summary and Object Interaction Summary.

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

    # --- Destructive Operations Summary ---
    output.write("== Destructive Operations Summary ==\n")
    if result.destructive_counts:
        total_destructive = sum(result.destructive_counts.values())
        output.write(f"Total destructive operations: {total_destructive}\n")
        # Sort by count descending, then by type ascending
        sorted_destructive = sorted(result.destructive_counts.items(), key=lambda item: (-item[1], item[0]))
        for stmt_type, count in sorted_destructive:
            output.write(f"  - {stmt_type}: {count}\n")
    else:
        output.write("No destructive operations found.\n")
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

        # Highlight STAGE, FILE_FORMAT, and COPY_INTO actions
        stage_objs = [obj for obj in result.objects_found if obj.object_type in ("STAGE", "FILE_FORMAT") or "COPY_INTO" in obj.action]
        if stage_objs:
            output.write("\nDetailed Stage/File Format/COPY INTO Objects:\n")
            for obj in stage_objs:
                location = f" (Line: {obj.line})" if obj.line > 0 else ""
                output.write(f"    - {obj.action} {obj.object_type}: {obj.name}{location}\n")

        # Add detailed object list in verbose mode
        if verbose:
            output.write("\nDetailed Object List:\n")
            for obj in result.objects_found:
                location = f" (Line: {obj.line})" if getattr(obj, 'line', 0) else ""
                file_info = f" [File: {getattr(obj, 'file_path', 'N/A')}]" if getattr(obj, 'file_path', None) else ""
                output.write(f"    - {obj.action} {obj.object_type}: {obj.name}{location}{file_info}\n")
    else:
        output.write("No database objects found.\n")
    output.write("\n")

    # --- Object Interaction Summary ---
    output.write("== Object Interaction Summary ==\n")
    if result.object_interactions:
        output.write(f"Total objects with interactions: {len(result.object_interactions)}\n")
        
        # Sort by object type, then by name
        sorted_interactions = sorted(result.object_interactions.items(), key=lambda item: (item[0][0], item[0][1]))
        
        for (obj_type, obj_name), actions in sorted_interactions:
            # Sort actions alphabetically, but place destructive actions first
            destructive_actions = sorted(a for a in actions if a in ('DELETE', 'DROP', 'TRUNCATE', 'REPLACE', 'DROP_COLUMN'))
            other_actions = sorted(a for a in actions if a not in ('DELETE', 'DROP', 'TRUNCATE', 'REPLACE', 'DROP_COLUMN'))
            
            # Create a formatted list of actions
            action_list = ", ".join(destructive_actions + other_actions)
            
            # Mark destructive actions with an asterisk if present
            has_destructive = any(a in ('DELETE', 'DROP', 'TRUNCATE', 'REPLACE', 'DROP_COLUMN') for a in actions)
            risk_marker = " [!]" if has_destructive else ""
            
            output.write(f"  - {obj_type}: {obj_name}{risk_marker}\n")
            output.write(f"    Actions: {action_list}\n")
    else:
        output.write("No object interactions recorded.\n")
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