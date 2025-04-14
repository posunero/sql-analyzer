"""
Defines data structures (using dataclasses) to hold analysis results.

This module contains the primary classes for storing information extracted
from SQL files, such as statement counts, object details, and errors.
"""

from dataclasses import dataclass, field
from typing import Dict, List, Set, DefaultDict, Optional
from collections import defaultdict

@dataclass
class ObjectInfo:
    """Holds information about a database object encountered during analysis.

    Attributes:
        name: The name of the object as found in the SQL.
        object_type: The type of object (e.g., 'TABLE', 'VIEW', 'FUNCTION').
        action: The action performed on the object (e.g., 'CREATE', 'REFERENCE').
        file_path: The path to the SQL file where the object was found.
        line: The starting line number in the file where the object was found.
        column: The starting column number in the file where the object was found.
        # Optional: Add fully_qualified_name later if resolution is implemented
    """
    name: str
    object_type: str
    action: str # CREATE, ALTER, DROP, REFERENCE, etc.
    file_path: str = ""
    line: int = 0
    column: int = 0

@dataclass
class AnalysisResult:
    """Container for the aggregated analysis results from one or more SQL files.

    This class accumulates counts of different statement types, details of database
    objects encountered, and any errors that occurred during processing.

    Attributes:
        statement_counts: A dictionary mapping statement types (uppercase strings like
            'CREATE_TABLE', 'SELECT') to their occurrence count.
        objects_found: A list of `ObjectInfo` instances detailing each database object
            found across all analyzed files.
        errors: A list of dictionaries, where each dictionary represents an error
            encountered during parsing or analysis. Each dictionary should have keys:
            `'file'` (str), `'line'` (int|str), and `'message'` (str).
        current_file: The path of the current file being processed.
    """
    statement_counts: DefaultDict[str, int] = field(default_factory=lambda: defaultdict(int))
    objects_found: List[ObjectInfo] = field(default_factory=list)
    errors: List[Dict[str, object]] = field(default_factory=list) # Keys: 'file', 'line', 'message'
    current_file: str = ""

    def merge(self, other_result: 'AnalysisResult') -> None:
        """Merges results from another AnalysisResult object into this one.

        Combines statement counts, object lists, and error lists.

        Args:
            other_result: The `AnalysisResult` object to merge from.
        """
        for stmt_type, count in other_result.statement_counts.items():
            self.statement_counts[stmt_type] += count
        self.objects_found.extend(other_result.objects_found)
        self.errors.extend(other_result.errors)

    def add_error(self, file_path: str, line: Optional[int], message: str) -> None:
        """Adds a record of an error encountered during processing.

        Args:
            file_path: The path to the file where the error occurred.
            line: The line number (1-indexed) where the error occurred, or None if not applicable.
            message: A description of the error.
        """
        self.errors.append({"file": str(file_path), "line": line if line is not None else 'N/A', "message": message})

    def add_statement(self, statement_type: str, file_path: str = "") -> None:
        """Increments the count for a given statement type.

        The statement type is converted to uppercase before counting.

        Args:
            statement_type: The type of SQL statement (e.g., 'SELECT', 'create_table').
            file_path: The path of the file where the statement was found.
        """
        self.statement_counts[statement_type.upper()] += 1
        # Note: Currently file_path is not used in the statement counts, but
        # is kept for future use in tracking statement origins

    def add_object(self, name: str, object_type: str, action: str, file_path: str, line: int = 0, column: int = 0) -> None:
        """Adds information about a database object encountered.

        Object type and action are stored in uppercase. Prevents adding duplicate objects
        with the same name, type, action, and file_path.

        Args:
            name: The name of the object.
            object_type: The type of the object (e.g., 'TABLE', 'VIEW').
            action: The action performed on the object (e.g., 'CREATE', 'REFERENCE').
            file_path: The path to the file where the object was found.
            line: The line number where the object reference starts.
            column: The column number where the object reference starts.
        """
        # Convert to uppercase for consistent comparison
        object_type = object_type.upper()
        action = action.upper()
        file_path = str(file_path)

        # Check if this object already exists
        for obj in self.objects_found:
            if (obj.name == name and 
                obj.object_type == object_type and 
                obj.action == action and 
                obj.file_path == file_path):
                return  # Skip adding if it's a duplicate

        # Add the object if it's not a duplicate
        self.objects_found.append(
            ObjectInfo(
                name=name,
                object_type=object_type,
                action=action,
                file_path=file_path,
                line=line,
                column=column
            )
        ) 