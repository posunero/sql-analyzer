"""
Formats analysis results into JSON.
"""

import json
from dataclasses import asdict, is_dataclass
from sql_analyzer.analysis.models import AnalysisResult

class DataclassJSONEncoder(json.JSONEncoder):
    """A JSON encoder that can handle dataclasses."""
    def default(self, o):
        if is_dataclass(o):
            return asdict(o)
        # Handle defaultdict specifically if present in AnalysisResult
        if isinstance(o, dict) and hasattr(o, 'default_factory') and o.default_factory is not None:
            return dict(o) # Convert defaultdict to regular dict for serialization
        return super().default(o)

def format_json(result: AnalysisResult) -> str:
    """Formats the analysis result into a JSON string.

    Uses a custom encoder (`DataclassJSONEncoder`) to handle the serialization
    of the `AnalysisResult` dataclass and its nested `ObjectInfo` dataclasses,
    as well as converting the `defaultdict` for statement counts.
    """
    return json.dumps(result, cls=DataclassJSONEncoder, indent=2)

# Ensure the directory exists if running this directly for testing (unlikely needed)
# if __name__ == '__main__':
#     from pathlib import Path
#     Path(__file__).parent.mkdir(parents=True, exist_ok=True) 