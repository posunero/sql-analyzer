"""
Main entry point for the SQL Analyzer application.
"""
import logging
import sys
from pathlib import Path

# Assume these modules exist based on the plan
from sql_analyzer import cli
from sql_analyzer.utils import file_system, error_handling

# --- Actual module imports ---
from sql_analyzer.parser import core as parser_core
from lark import LarkError # Import specific Lark error
from sql_analyzer.analysis import models as analysis_models
from sql_analyzer.analysis import engine as analysis_engine
from sql_analyzer.parser import visitor as parser_visitor
from sql_analyzer.reporting import manager as reporting_manager
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


logger = logging.getLogger(__name__)

def setup_logging(level_str: str):
    """Configures basic Python logging.

    Args:
        level_str: The desired logging level as a string (e.g., 'INFO', 'DEBUG').
    """
    level = getattr(logging, level_str.upper(), logging.INFO)
    # Basic config logs to stderr by default
    logging.basicConfig(level=level, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger.info(f"Logging level set to {level_str.upper()}")

def main():
    """Main execution function.

    Parses arguments, iterates through input files, performs parsing and analysis,
    generates a report, and prints it to standard output.
    Exits with code 0 on success, 1 on any error.
    """
    args = cli.parse_arguments()
    setup_logging(args.verbose) # Use verbose as log-level arg name

    overall_result = analysis_models.AnalysisResult() # Use actual AnalysisResult

    exit_code = 0 # Track if any errors occurred

    for input_path_str in args.input_paths:
        logger.info(f"Processing path: {input_path_str}")
        try:
            sql_files = list(file_system.find_sql_files(input_path_str))
            if not sql_files:
                logger.warning(f"No .sql files found in path: {input_path_str}")
                continue

            for file_path in sql_files:
                logger.debug(f"Reading file: {file_path}")
                content = file_system.read_file_content(file_path)

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
                    parse_tree = parser_core.parse_sql(content)
                    logger.debug(f"Successfully parsed {file_path}")
                    # --- End Actual Parsing ---

                    # --- Actual Analysis ---
                    # Create engine and visitor ONCE before loop if accumulating results,
                    # or inside if resetting per file (current approach assumes accumulation in overall_result)
                    # The visitor is implicitly created within the engine in this setup
                    engine = analysis_engine.AnalysisEngine() # Initialize without arguments
                    # The engine's analyze method now takes the tree and file path
                    # It internally uses its visitor to populate its result object
                    # We need to merge the result back into overall_result
                    file_specific_result = engine.analyze(parse_tree, file_path=str(file_path))
                    overall_result.merge(file_specific_result) # Merge results into the main accumulator

                    # OLD APPROACH (Incorrect based on AnalysisEngine definition):
                    # engine = analysis_engine.AnalysisEngine(overall_result, current_file=str(file_path))
                    # ast_visitor = parser_visitor.SQLAnalyzerVisitor(engine)
                    # ast_visitor.visit(parse_tree)

                    logger.debug(f"Analysis completed for {file_path}")
                    # --- End Actual Analysis ---

                except LarkError as e:
                    # Error parsing file
                    line_number = e.line
                    column_number = e.column
                    error_message = f"Lark parsing error at line {line_number}, column {column_number}: {e}"
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
            verbose=args.verbose_report # Use the new flag here
        )
        print(report_output) # Print to standard output
        # TODO: Add logic to write to file if args.output is set
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