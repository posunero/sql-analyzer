"""
Defines data structures (using dataclasses) to hold analysis results.
"""

from dataclasses import dataclass, field
from typing import Dict, List, Set, DefaultDict
from collections import defaultdict

@dataclass
class ObjectInfo:
    """Holds information about a database object encountered.

    Attributes:
        name: The fully qualified name of the object (e.g., db.schema.table).
        object_type: The type of object (e.g., TABLE, VIEW, WAREHOUSE, FUNCTION).
        action: The action performed on the object (CREATE, ALTER, DROP, REFERENCE).
        line: The starting line number where the action occurred.
        column: The starting column number where the action occurred.
    """
    name: str
    object_type: str
    action: str # CREATE, ALTER, DROP, REFERENCE
    line: int = 0
    column: int = 0

@dataclass
class AnalysisResult:
    """Container for the overall analysis results from one or more files.

    Attributes:
        statement_counts: A dictionary counting occurrences of each statement type (uppercase).
        objects_found: A list storing details of each database object encountered.
        errors: A list of dictionaries, each describing a parsing error encountered.
    """
    statement_counts: DefaultDict[str, int] = field(default_factory=lambda: defaultdict(int))
    objects_found: List[ObjectInfo] = field(default_factory=list)
    errors: List[Dict] = field(default_factory=list) # E.g., {'file': str, 'line': int, 'message': str}

    def merge(self, other_result: 'AnalysisResult'):
        """Merges results from another AnalysisResult object into this one."""
        for stmt_type, count in other_result.statement_counts.items():
            self.statement_counts[stmt_type] += count
        self.objects_found.extend(other_result.objects_found)
        self.errors.extend(other_result.errors)

    def add_error(self, file_path: str, line: int, message: str):
        """Adds a parsing error record."""
        self.errors.append({"file": file_path, "line": line, "message": message})

    def add_statement(self, statement_type: str):
        """Increments the count for a given statement type."""
        self.statement_counts[statement_type.upper()] += 1

    def add_object(self, name: str, object_type: str, action: str, line: int = 0, column: int = 0):
        """Adds information about an object encountered."""
        self.objects_found.append(
            ObjectInfo(
                name=name,
                object_type=object_type.upper(),
                action=action.upper(),
                line=line,
                column=column
            )
        ) 