"""
Manages the generation of reports in different formats.
"""

import importlib
from sql_analyzer.analysis.models import AnalysisResult

SUPPORTED_FORMATS = ["text", "json"] # Add "csv" here if implemented

def generate_report(result: AnalysisResult, format_name: str, verbose: bool = False) -> str:
    """
    Generates a report string in the specified format using dynamically imported formatters.

    Looks for a `format_report(result: AnalysisResult, verbose: bool)` function

    Args:
        result: The AnalysisResult object containing analysis data.
        format_name: The desired output format (e.g., 'text', 'json').
        verbose: Verbosity flag passed to the formatter (mainly for text).

    Returns:
        A string containing the formatted report.

    Raises:
        ValueError: If the requested format is not supported.
        ImportError: If the formatter module for the given `format_name` cannot be imported.
        AttributeError: If the formatter module does not have a `format_report` function.
    """
    format_name = format_name.lower()

    if format_name not in SUPPORTED_FORMATS:
        raise ValueError(f"Unsupported report format: '{format_name}'. Supported formats: {SUPPORTED_FORMATS}")

    try:
        # Dynamically import the formatter module
        formatter_module = importlib.import_module(f".formats.{format_name}", package="sql_analyzer.reporting")
    except ImportError as e:
        raise ImportError(f"Could not import formatter for '{format_name}': {e}")

    if not hasattr(formatter_module, "format_report"):
        raise AttributeError(f"Formatter module '{format_name}' does not have a 'format_report' function.")

    # Call the format_report function from the imported module
    report_content = formatter_module.format_report(result, verbose=verbose)
    return report_content 