from __future__ import annotations
"""
Formats analysis results into JSON.
"""

import json
from dataclasses import asdict, is_dataclass
from sql_analyzer.analysis.models import AnalysisResult
from collections import defaultdict
from typing import Any, Dict, cast, Mapping, Set

def format_json(result: AnalysisResult) -> str:
    """Formats the analysis result into a JSON string by constructing a pure-Python dict."""
    # Create a JSON-safe dict directly
    result_dict: Dict[str, Any] = {
        # Basic counters
        "statement_counts": dict(result.statement_counts),
        "destructive_counts": dict(result.destructive_counts),
        
        # Objects and errors
        "objects_found": [asdict(obj) for obj in result.objects_found],
        "errors": result.errors,
        "current_file": result.current_file,
        
        # Process interactions
        "object_interactions": {
            f"{obj_type}:{name}": sorted(str(a) for a in actions)
            for (obj_type, name), actions in result.object_interactions.items()
        },
        
        # Process dependencies
        "object_dependencies": {
            f"{obj_type}:{name}": [
                {
                    "dependent_type": str(dep[0]),
                    "dependent_name": str(dep[1]),
                    "relationship_type": str(dep[2])
                }
                for dep in deps
            ]
            for (obj_type, name), deps in result.object_dependencies.items()
        }
    }
    
    # Use a safe JSON encoder to handle remaining conversions
    return json.dumps(result_dict, indent=2, cls=SafeJSONEncoder)

class SafeJSONEncoder(json.JSONEncoder):
    """JSON encoder that safely handles dataclasses, defaultdicts, and sets."""
    def default(self, o: Any) -> Any:
        # Handle dataclasses
        if is_dataclass(o) and not isinstance(o, type):
            return asdict(o)
            
        # Handle defaultdict
        if isinstance(o, defaultdict):
            # Cast to Mapping[Any, Any] for typing
            return dict(cast(Mapping[Any, Any], o))
            
        # Handle sets
        if isinstance(o, set):
            # Cast to Set[Any] for typing
            return sorted([str(item) for item in cast(Set[Any], o)])
            
        # Let the default encoder handle the rest
        return super().default(o)

# Ensure the directory exists if running this directly for testing (unlikely needed)
# if __name__ == '__main__':
#     from pathlib import Path
#     Path(__file__).parent.mkdir(parents=True, exist_ok=True)

# The JSON output already includes all objects and interactions, including STAGE, FILE_FORMAT, and COPY_INTO actions, via the AnalysisResult dataclass.
# No code changes needed, but this comment clarifies that the new features are covered. 