"""
Manages the generation of reports in different formats.
"""

from ..analysis.models import AnalysisResult
from .formats import text, json, html # Add html import

# Map format strings to formatter functions
_FORMATTERS = {
    'text': text.format_text,
    'json': json.format_json,
    'html': html.format_html,
    # Add other formats like 'csv' here if implemented
}


def generate_report(result: AnalysisResult, format_name: str, verbose: bool = False) -> str:
    """
    Generates a report for the given analysis result using the specified format.

    Selects the appropriate formatting function based on `format_name` and calls it.
    The `verbose` flag is passed to the formatter if it's known to support it
    (currently, only the 'text' formatter uses it).

    Args:
        result: The AnalysisResult object containing the analysis data.
        format_name: The desired output format (e.g., 'text', 'json').
        verbose: Flag for generating a more detailed report (used by some formatters).

    Returns:
        A string containing the formatted report.

    Raises:
        ValueError: If the requested format_name is not supported.
    """
    formatter = _FORMATTERS.get(format_name.lower())

    if formatter:
        # Pass verbose flag only if the formatter accepts it (currently only text)
        if format_name.lower() == 'text':
            return formatter(result, verbose=verbose)
        else:
            # Other formatters currently don't use verbose
            return formatter(result)
    else:
        supported_formats = ", ".join(_FORMATTERS.keys())
        raise ValueError(f"Unsupported report format: '{format_name}'. Supported formats are: {supported_formats}")

# Ensure the directory exists if running this directly (unlikely needed)
# if __name__ == '__main__':
#     from pathlib import Path
#     Path(__file__).parent.mkdir(parents=True, exist_ok=True) 