"""
Formats analysis results into JSON.
"""

import json
from dataclasses import asdict
from sql_analyzer.analysis.models import AnalysisResult

def format_report(result: AnalysisResult, verbose: bool = False) -> str:
    """Generates a JSON report string from the AnalysisResult.

    Args:
        result: The AnalysisResult object.
        verbose: Not used in JSON format, but included for consistency.

    Returns:
        A string containing the formatted JSON report (indented by 4 spaces).
    """
    # Convert the dataclass instance (and nested dataclasses) to a dictionary
    # Handle the defaultdict specifically if needed, or convert it to a regular dict first
    result_dict = asdict(result)

    # Convert defaultdict to dict for clean JSON output
    if isinstance(result_dict.get('statement_counts'), dict):
         # Assuming statement_counts is already dict-like or easily convertible
         pass # It should be handled by asdict if it's a field

    # Convert the dictionary to a JSON string
    # Use indent for readability
    return json.dumps(result_dict, indent=4) 