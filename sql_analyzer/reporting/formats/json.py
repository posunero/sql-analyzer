"""
Formats analysis results into JSON.
"""

import json
from dataclasses import asdict, is_dataclass
from sql_analyzer.analysis.models import AnalysisResult
from collections import defaultdict

class DataclassJSONEncoder(json.JSONEncoder):
    """A JSON encoder that handles dataclasses and specific nested structures."""
    def default(self, o):
        if is_dataclass(o):
            # 1. Convert dataclass to dict first
            data = asdict(o)
            
            # 2. Manually process specific fields within the dict *after* asdict
            
            # Process object_interactions: Convert tuple keys to strings, set values to lists
            if 'object_interactions' in data and isinstance(data['object_interactions'], dict):
                 # Check keys/values to be safe, handle defaultdict converted by asdict
                 if all(isinstance(k, tuple) for k in data['object_interactions'].keys()):
                    new_interactions = {}
                    for key_tuple, value_set in data['object_interactions'].items():
                        str_key = f"{key_tuple[0]}:{key_tuple[1]}"
                        # Ensure value is processed (asdict might leave sets)
                        processed_value = sorted(list(value_set)) if isinstance(value_set, set) else value_set
                        new_interactions[str_key] = processed_value
                    data['object_interactions'] = new_interactions # Replace with the processed dict

            # Process statement_counts: Convert defaultdict to dict (if asdict didn't already)
            if 'statement_counts' in data and isinstance(data['statement_counts'], defaultdict):
                 data['statement_counts'] = dict(data['statement_counts'])
                 
            # Process destructive_counts: Convert defaultdict to dict
            if 'destructive_counts' in data and isinstance(data['destructive_counts'], defaultdict):
                 data['destructive_counts'] = dict(data['destructive_counts'])

            # Process object_dependencies: Convert tuple keys to strings and values to list of dicts
            if 'object_dependencies' in data and isinstance(data['object_dependencies'], dict):
                if all(isinstance(k, tuple) for k in data['object_dependencies'].keys()):
                    new_dependencies = {}
                    for key_tuple, deps in data['object_dependencies'].items():
                        parent_key = f"{key_tuple[0]}:{key_tuple[1]}"
                        dep_list = []
                        for dep in deps:
                            # Each dep is (dependent_type, dependent_name, relationship_type)
                            dep_list.append({
                                'dependent_type': dep[0],
                                'dependent_name': dep[1],
                                'relationship_type': dep[2]
                            })
                        new_dependencies[parent_key] = dep_list
                    data['object_dependencies'] = new_dependencies

            # 3. Return the modified dictionary for the base encoder to handle
            return data 

        # Fallback for non-dataclass types (e.g., if default is called on a raw set/defaultdict initially)
        # This might not be strictly necessary if only AnalysisResult is passed initially,
        # but kept for robustness.
        if isinstance(o, defaultdict):
            return dict(o)
        if isinstance(o, set):
            return sorted(list(o))
            
        # Let the base class handle standard types or raise errors for unknown ones
        return super().default(o)

def format_json(result: AnalysisResult) -> str:
    """Formats the analysis result into a JSON string by constructing a pure-Python dict."""
    from dataclasses import asdict

    # Convert counts
    statement_counts = dict(result.statement_counts)
    destructive_counts = dict(result.destructive_counts)
    # Objects found
    objects_found = [asdict(obj) for obj in result.objects_found]
    # Errors
    errors = result.errors
    # Object interactions: convert tuple keys
    object_interactions = {
        f"{obj_type}:{name}": sorted(list(actions))
        for (obj_type, name), actions in result.object_interactions.items()
    }
    # Object dependencies: convert tuple keys and tuples to dicts
    object_dependencies = {}
    for (obj_type, name), deps in result.object_dependencies.items():
        key = f"{obj_type}:{name}"
        dep_list = []
        for dep in deps:
            dep_list.append({
                "dependent_type": dep[0],
                "dependent_name": dep[1],
                "relationship_type": dep[2]
            })
        object_dependencies[key] = dep_list

    # Build final dict
    result_dict = {
        "statement_counts": statement_counts,
        "destructive_counts": destructive_counts,
        "objects_found": objects_found,
        "errors": errors,
        "object_interactions": object_interactions,
        "object_dependencies": object_dependencies,
        "current_file": result.current_file,
    }
    return json.dumps(result_dict, indent=2)

# Ensure the directory exists if running this directly for testing (unlikely needed)
# if __name__ == '__main__':
#     from pathlib import Path
#     Path(__file__).parent.mkdir(parents=True, exist_ok=True)

# The JSON output already includes all objects and interactions, including STAGE, FILE_FORMAT, and COPY_INTO actions, via the AnalysisResult dataclass.
# No code changes needed, but this comment clarifies that the new features are covered. 