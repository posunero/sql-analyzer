"""
Defines data structures (using dataclasses) to hold analysis results.

This module contains the primary classes for storing information extracted
from SQL files, such as statement counts, object details, and errors.
"""

from dataclasses import dataclass, field
from typing import Dict, List, Set, DefaultDict, Optional, Tuple
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
            found across all analyzed files. (Note: `object_interactions` provides more detail).
        errors: A list of dictionaries, where each dictionary represents an error
            encountered during parsing or analysis. Each dictionary should have keys:
            `'file'` (str), `'line'` (int|str), and `'message'` (str).
        destructive_counts: A dictionary mapping destructive statement types (uppercase
            strings like 'DROP_TABLE', 'DELETE') to their occurrence count.
        object_interactions: A dictionary mapping (object_type, object_name) tuples
            to a set of actions (uppercase strings like 'CREATE', 'DELETE', 'SELECT')
            performed on that object.
        object_dependencies: A dictionary mapping (object_type, object_name) tuples
            to a set of (dependent_type, dependent_name, relationship_type) tuples,
            recording dependencies between objects.
        current_file: The path of the current file being processed.
    """
    statement_counts: DefaultDict[str, int] = field(default_factory=lambda: defaultdict(int))
    objects_found: List[ObjectInfo] = field(default_factory=list)
    errors: List[Dict[str, object]] = field(default_factory=list) # Keys: 'file', 'line', 'message'
    destructive_counts: DefaultDict[str, int] = field(default_factory=lambda: defaultdict(int))
    object_interactions: DefaultDict[Tuple[str, str], Set[str]] = field(default_factory=lambda: defaultdict(set))
    object_dependencies: DefaultDict[Tuple[str, str], Set[Tuple[str, str, str]]] = field(default_factory=lambda: defaultdict(set))
    current_file: str = ""

    def merge(self, other_result: 'AnalysisResult') -> None:
        """Merges results from another AnalysisResult object into this one.

        Combines statement counts, object lists, error lists, destructive counts,
        object interactions, and object dependencies.

        Args:
            other_result: The `AnalysisResult` object to merge from.
        """
        for stmt_type, count in other_result.statement_counts.items():
            self.statement_counts[stmt_type] += count
        for stmt_type, count in other_result.destructive_counts.items():
            self.destructive_counts[stmt_type] += count
        for obj_key, actions in other_result.object_interactions.items():
            self.object_interactions[obj_key].update(actions)
        for obj_key, deps in other_result.object_dependencies.items():
            self.object_dependencies[obj_key].update(deps)
        # Keep objects_found merge for now, though its utility might decrease
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

        Also calls `add_object_interaction`.

        Args:
            name: The name of the object.
            object_type: The type of the object (e.g., 'TABLE', 'VIEW').
            action: The action performed on the object (e.g., 'CREATE', 'REFERENCE').
            file_path: The path to the file where the object was found.
            line: The line number where the object reference starts.
            column: The column number where the object reference starts.
        """
        # Convert to uppercase for consistent storage
        object_type = object_type.upper()
        action = action.upper()
        file_path = str(file_path)

        # Add to the detailed interaction list
        self.add_object_interaction(name, object_type, action, line, column)

        # Check if this specific object info instance already exists in objects_found
        # This list might become less primary compared to object_interactions
        obj_key = (name, object_type, action, file_path)
        if any(
            (obj.name == name and
             obj.object_type == object_type and
             obj.action == action and
             obj.file_path == file_path)
            for obj in self.objects_found
        ):
            return # Skip adding duplicate to objects_found

        # Add the object info if it's not a duplicate for this specific action/file combo
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

    def add_destructive_statement(self, statement_type: str) -> None:
        """Increments the count for a given destructive statement type.

        The statement type is converted to uppercase before counting.

        Args:
            statement_type: The type of destructive SQL statement (e.g., 'DROP_TABLE').
        """
        statement_type = statement_type.upper()
        self.destructive_counts[statement_type] += 1

    def add_object_interaction(self, name: str, object_type: str, action: str, line: int = 0, column: int = 0) -> None:
        """Records an interaction (action) with a specific database object.

        Object type and action are stored in uppercase.

        Args:
            name: The name of the object.
            object_type: The type of the object (e.g., 'TABLE', 'VIEW').
            action: The action performed on the object (e.g., 'CREATE', 'DELETE', 'SELECT').
            line: The line number where the interaction occurs (optional, for potential future use).
            column: The column number where the interaction occurs (optional, for potential future use).
        """
        # Convert to uppercase for consistent storage and grouping
        object_type = object_type.upper()
        action = action.upper()
        obj_key = (object_type, name) # Group by type and name

        self.object_interactions[obj_key].add(action)
        # Note: line/column are not stored directly in object_interactions yet,
        # but are available if needed later. The primary interaction record is the action set. 

    def add_dependency(self, object_type: str, object_name: str, 
                       dependent_type: str, dependent_name: str, 
                       relationship_type: str) -> None:
        """Records a dependency relationship between two objects.
        
        Args:
            object_type: The type of the parent object (e.g., 'TASK')
            object_name: The name of the parent object
            dependent_type: The type of the dependent object (e.g., 'TABLE', 'TASK')
            dependent_name: The name of the dependent object
            relationship_type: The type of relationship (e.g., 'AFTER', 'REFERENCES')
        """
        # Convert to uppercase for consistent storage
        object_type = object_type.upper()
        dependent_type = dependent_type.upper()
        relationship_type = relationship_type.upper()
        
        # Add the dependency
        parent_key = (object_type, object_name)
        dependent_tuple = (dependent_type, dependent_name, relationship_type)
        self.object_dependencies[parent_key].add(dependent_tuple) 