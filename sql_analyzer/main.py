from __future__ import annotations
"""
Main entry point for the SQL Analyzer application.
"""
import logging
import sys
import argparse
from pathlib import Path

# Assume these modules exist based on the plan
from sql_analyzer import cli
from sql_analyzer.utils import file_system, error_handling

# --- Actual module imports ---
from sql_analyzer.parser import core as parser_core
from lark import LarkError, Tree # Import specific Lark error
from sql_analyzer.analysis import models as analysis_models
from sql_analyzer.analysis import engine as analysis_engine
from sql_analyzer.reporting import manager as reporting_manager
from typing import List, Dict, Any, Optional, Tuple
from sql_analyzer.analysis.engine import AnalysisEngine
from sql_analyzer.analysis.models import AnalysisResult
# --- End Actual imports ---

# --- Placeholder Data Structures (replace with actual ones later) ---
# class PlaceholderAnalysisResult:
#     def __init__(self):
#         self.file_count = 0
#         self.statement_count = 0
#         self.errors = []
#
#     def add_error(self, file_path, error_type, message):
#         self.errors.append({"file": str(file_path), "type": error_type, "message": message})
#
#     def merge(self, other_result):
#         # Placeholder for merging results from different files
#         self.file_count += other_result.file_count
#         self.statement_count += other_result.statement_count
#         self.errors.extend(other_result.errors)
#
# --- End Placeholder Data Structures ---


logger: logging.Logger = logging.getLogger(__name__)

def setup_logging(level_str: str) -> None:
    """Configures basic Python logging.

    Args:
        level_str: The desired logging level as a string (e.g., 'INFO', 'DEBUG').
    """
    level: int = getattr(logging, level_str.upper(), logging.INFO)
    # Basic config logs to stderr by default
    logging.basicConfig(level=level, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger.info(f"Logging level set to {level_str.upper()}")

def main() -> None:
    """Main execution function.

    Parses arguments, iterates through input files, performs parsing and analysis,
    generates a report, and prints it to standard output.
    Exits with code 0 on success, 1 on any error.
    """
    args: argparse.Namespace = cli.parse_arguments()
    setup_logging(args.verbose) # Use verbose as log-level arg name

    if args.validate:
        # Run in validation-only mode
        from sql_analyzer.validation import validate_multiple_files

        all_files: List[Path] = []
        for input_path_str in args.input_paths:
            logger.info(f"Processing path: {input_path_str}")
            sql_files: List[Path] = list(file_system.find_sql_files(input_path_str))
            if not sql_files:
                logger.warning(f"No .sql files found in path: {input_path_str}")
                continue
            all_files.extend(sql_files)

        if not all_files:
            logger.error("No SQL files found in specified paths.")
            sys.exit(1)
        
        # Validate all files
        validation_results: Dict[str, Tuple[bool, Optional[str]]] = validate_multiple_files(all_files)

        # Print results based on format
        if args.format == 'json':
            import json
            result_dict: Dict[str, Any] = {
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
        elif args.format == 'html':
            # HTML output for validation
            from sql_analyzer.reporting.formats.html import format_validation_results
            html_output = format_validation_results(validation_results)
            print(html_output)
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
        has_invalid: bool = any(not result[0] for result in validation_results.values())
        sys.exit(1 if has_invalid else 0)

    overall_result: AnalysisResult = analysis_models.AnalysisResult() # Use actual AnalysisResult

    exit_code: int = 0 # Track if any errors occurred

    for input_path_str in args.input_paths:
        logger.info(f"Processing path: {input_path_str}")
        try:
            sql_files: List[Path] = list(file_system.find_sql_files(input_path_str))
            if not sql_files:
                logger.warning(f"No .sql files found in path: {input_path_str}")
                continue

            for file_path in sql_files:
                logger.debug(f"Reading file: {file_path}")
                content: Optional[str] = file_system.read_file_content(file_path)

                if content is None:
                    # Error reading file (already logged by read_file_content)
                    error_handling.report_file_error(file_path, "Could not read file.")
                    overall_result.add_error(file_path=str(file_path), line=0, message="Could not read file.")
                    exit_code = 1
                    if args.fail_fast:
                        logger.error("Exiting due to --fail-fast.")
                        sys.exit(exit_code)
                    continue # Skip to next file

                logger.info(f"Parsing file: {file_path}")
                try:
                    # --- Actual Parsing ---
                    # parse_sql returns Optional[Tree]; handle None for empty or uninitialized parser
                    parse_tree_opt: Optional[Tree[Any]] = parser_core.parse_sql(content)
                    if parse_tree_opt is None:
                        logger.warning(f"No parse tree generated for empty or invalid content: {file_path}")
                        continue
                    parse_tree: Tree[Any] = parse_tree_opt
                    logger.debug(f"Successfully parsed {file_path}")
                    # --- End Actual Parsing ---

                    # --- Actual Analysis ---
                    # Create engine and visitor ONCE before loop if accumulating results,
                    # or inside if resetting per file (current approach assumes accumulation in overall_result)
                    # The visitor is implicitly created within the engine in this setup
                    engine: AnalysisEngine = analysis_engine.AnalysisEngine() # Initialize without arguments
                    # The engine's analyze method now takes the tree and file path
                    # It internally uses its visitor to populate its result object
                    # We need to merge the result back into overall_result
                    file_specific_result: AnalysisResult = engine.analyze(parse_tree, file_path=str(file_path))
                    overall_result.merge(file_specific_result) # Merge results into the main accumulator

                    # OLD APPROACH (Incorrect based on AnalysisEngine definition):
                    # engine = analysis_engine.AnalysisEngine(overall_result, current_file=str(file_path))
                    # ast_visitor = parser_visitor.SQLAnalyzerVisitor(engine)
                    # ast_visitor.visit(parse_tree)

                    logger.debug(f"Analysis completed for {file_path}")
                    # --- End Actual Analysis ---

                except LarkError as e:
                    # Error parsing file, use getattr for line/column
                    line_number: int = getattr(e, 'line', 0)
                    column_number: int = getattr(e, 'column', 0)
                    error_message: str = f"Lark parsing error at line {line_number}, column {column_number}: {e}"
                    error_handling.report_parsing_error(file_path, line_number, error_message)
                    overall_result.add_error(file_path=str(file_path), line=line_number, message=error_message)
                    exit_code = 1
                    if args.fail_fast:
                        logger.error("Exiting due to --fail-fast.")
                        sys.exit(exit_code)
                    continue # Skip to next file
                except Exception as e: # Catch other potential analysis errors
                    error_message = f"Unexpected error during analysis of {file_path}: {e}"
                    logger.error(error_message, exc_info=True)
                    overall_result.add_error(file_path=str(file_path), line=0, message=error_message)
                    exit_code = 1
                    if args.fail_fast:
                        logger.error("Exiting due to --fail-fast.")
                        sys.exit(exit_code)
                    continue # Skip to next file

        except Exception as e:
            logger.error(f"Unexpected error processing path {input_path_str}: {e}", exc_info=True)
            overall_result.add_error(file_path=str(Path(input_path_str)), line=0, message=f"Error processing path: {e}")
            exit_code = 1
            if args.fail_fast:
                logger.error("Exiting due to --fail-fast.")
                sys.exit(exit_code)


    # --- Actual Reporting ---
    logger.info("Generating report...")
    try:
        report_output = reporting_manager.generate_report(
            result=overall_result,
            format_name=args.format,
            verbose=args.verbose_report
        )
        if args.output:
            try:
                Path(args.output).write_text(report_output, encoding='utf-8')
                print(f"Report written to {args.output}")
            except Exception as e:
                logger.error(f"Failed to write report to {args.output}: {e}")
                print(f"Error writing report to {args.output}: {e}", file=sys.stderr)
                exit_code = 1
        else:
            print(report_output) # Print to standard output
    except (ValueError, ImportError, AttributeError) as e:
        logger.error(f"Error generating report: {e}", exc_info=True)
        print(f"Error generating report: {e}", file=sys.stderr)
        exit_code = 1 # Indicate an error occurred
    except Exception as e:
        logger.error(f"Unexpected error during report generation: {e}", exc_info=True)
        print(f"Unexpected error generating report: {e}", file=sys.stderr)
        exit_code = 1 # Indicate an error occurred

    logger.info("SQL Analyzer finished.")
    sys.exit(exit_code)


if __name__ == "__main__":
    # This ensures the main function is called only when the script is executed directly.
    main() 