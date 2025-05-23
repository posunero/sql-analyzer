"""
Core analysis logic using a visitor pattern.

This module defines the `AnalysisEngine` which coordinates with a `SQLVisitor`
to traverse the abstract syntax tree (AST) generated by the parser and
extract relevant information, populating an `AnalysisResult` object.
"""
from __future__ import annotations

from lark import Tree, Token
from typing import Optional, TYPE_CHECKING, Any, cast, List
import logging

from sql_analyzer.analysis.models import AnalysisResult
from sql_analyzer.parser.visitor import SQLVisitor

# Prevent circular import for type hinting
if TYPE_CHECKING:
    from sql_analyzer.parser.visitor import SQLVisitor

logger: logging.Logger = logging.getLogger(__name__)

class AnalysisEngine:
    """Orchestrates the analysis of a parsed SQL abstract syntax tree (AST).

    This engine initializes an `AnalysisResult` and uses an `SQLVisitor` instance
    to walk through the AST nodes. The visitor calls methods on this engine
    (`record_statement`, `record_object`) when it encounters relevant nodes,
    allowing the engine to populate the `AnalysisResult`.

    Attributes:
        result: An `AnalysisResult` object that stores the findings.
        visitor: An `SQLVisitor` instance used to traverse the AST.
    """
    def __init__(self) -> None:
        """Initializes the AnalysisEngine with a fresh AnalysisResult and SQLVisitor."""
        self.result: AnalysisResult = AnalysisResult()
        self.visitor: SQLVisitor = SQLVisitor(self)  # Type hint with forward reference
        self.last_use_object_type: Optional[str] = None  # Track the object type from USE statements
        self.last_drop_object_type: Optional[str] = None  # Track the object type from DROP statements

    def analyze(self, tree: Tree[Any], file_path: str = "") -> AnalysisResult:
        """Analyzes a parsed SQL AST and returns the populated AnalysisResult.

        Args:
            tree: The root node of the Lark AST to analyze.
            file_path: The path of the file from which the tree was parsed,
                       used for context in error reporting and object tracking.

        Returns:
            The `AnalysisResult` object containing the analysis findings.
        """
        if not tree:
            return self.result # Return empty result if tree is invalid

        # Set the context for the visitor before starting traversal
        self.visitor.current_file = file_path
        self.visitor.visit(tree)
        return self.result

    # --- Methods called by the Visitor --- 

    def record_statement(self, stmt_type: str, node: Tree[Any] | Token, file_path: str) -> None:
        """Records an encountered SQL statement.

        Args:
            stmt_type: The type of statement (e.g., 'CREATE_TABLE', 'SELECT', 'USE', 'DROP').
            node: The AST node representing the statement.
            file_path: The path of the file where the statement was found.
        """
        logger.debug(f"ENGINE: record_statement called with stmt_type={stmt_type}, file_path={file_path}")
        
        if self.result.current_file != file_path:
            self.result.current_file = file_path

        # Handle USE statements: Use the specific object type if available
        if stmt_type == "USE":
            logger.debug(f"ENGINE: Processing USE statement with last_use_object_type: {self.last_use_object_type}")
            if self.last_use_object_type:
                # Convert to a specific USE statement based on the object type
                specific_stmt_type = f"USE_{self.last_use_object_type}"
                logger.debug(f"ENGINE: Recording specific USE statement: {specific_stmt_type}")
                self.result.add_statement(specific_stmt_type, file_path)
                # Reset after use
                self.last_use_object_type = None
            else:
                # Fallback to generic USE if object type unknown (should be rare)
                logger.debug(f"ENGINE: Recording generic USE statement because last_use_object_type is not set")
                self.result.add_statement(stmt_type, file_path)
        
        # Handle DROP statements: Use the specific object type if available
        elif stmt_type == "DROP":
            logger.debug(f"ENGINE: Processing DROP statement with last_drop_object_type: {self.last_drop_object_type}")
            if self.last_drop_object_type:
                # Convert to a specific DROP statement based on the object type
                specific_stmt_type = f"DROP_{self.last_drop_object_type}"
                logger.debug(f"ENGINE: Recording specific DROP statement: {specific_stmt_type}")
                self.result.add_statement(specific_stmt_type, file_path)
                # Reset after use
                self.last_drop_object_type = None
            else:
                # Fallback to generic DROP if object type unknown (should be rare)
                logger.debug(f"ENGINE: Recording generic DROP statement because last_drop_object_type is not set")
                self.result.add_statement(stmt_type, file_path)
        
        # Handle other statement types (could be generic like DDL_STMT or specific like CREATE_TABLE_STMT)
        else:
            # Refine common generic types if possible (example for CREATE_TABLE)
            # TODO: Add refinement for other types if needed
            if stmt_type == 'CREATE_TABLE_STMT':
                 refined_type = 'CREATE_TABLE'
            elif stmt_type == 'CREATE_VIEW_STMT':
                 refined_type = 'CREATE_VIEW'
            # Add similar refinements for ALTER_..., DROP_... if the visitor passes them
            else:
                 refined_type = stmt_type # Use the type as passed by the visitor
                 
            logger.debug(f"ENGINE: Recording standard statement: {refined_type}")
            self.result.add_statement(refined_type, file_path)

    def record_object(self, name: str, obj_type: str, action: str, node: Tree[Any] | Token, file_path: str) -> None:
        """Records an encountered database object, including its location.

        Args:
            name: The raw name of the object as found.
            obj_type: The type of the object (e.g., 'TABLE').
            action: The action performed (e.g., 'CREATE', 'REFERENCE').
            node: The AST node associated with the object, used to get location.
                  Expected to be the specific node representing the object name (e.g., qualified_name).
            file_path: The path of the file where the object was found.
        """
        logger.debug(f"ENGINE: record_object called with name={name}, obj_type={obj_type}, action={action}, file_path={file_path}")
        
        # Safely extract position info using getattr
        line: int = int(getattr(node, 'line', 0) or 0)
        column: int = int(getattr(node, 'column', 0) or 0)
        
        # If this is a USE action, store the object type for the upcoming record_statement call
        if action == "USE":
            logger.debug(f"ENGINE: This is a USE action, setting last_use_object_type = {obj_type}")
            self.last_use_object_type = obj_type
            # Removed immediate recording for fixtures - let record_statement handle it consistently
            
        # If this is a DROP action, store the object type for the upcoming record_statement call
        elif action == "DROP":
            logger.debug(f"ENGINE: This is a DROP action, setting last_drop_object_type = {obj_type}")
            self.last_drop_object_type = obj_type
            # Removed immediate recording for fixtures - let record_statement handle it consistently
        
        # Log the extracted info for debugging
        node_info: str = f"Node Type: {type(node).__name__}, Data: {getattr(node, 'data', 'N/A')}" if hasattr(node, 'data') else (f"Node Type: Token, Type: {node.type}" if isinstance(node, Token) else "N/A")
        logger.debug(f"RECORD_OBJECT: Name={name}, Type={obj_type}, Action={action}, NodeInfo='{node_info}', Line={line}, Col={column}, File={file_path}")

        # TODO: Implement logic to resolve full object names (db.schema.table)
        full_name = name # Placeholder for now
        
        # Pass file_path to the model's add_object method
        self.result.add_object(full_name, obj_type, action, file_path, line, column)

    # Pyright cannot infer types for Lark Tree children; ignore errors in this helper
    def _find_child_token_value(self, parent_node: Tree[Any], child_data_name: str) -> Optional[str]:  # type: ignore
        """Helper to find the value of the first Token child of a specific Tree child.

        Searches the direct children of `parent_node` for a Tree node whose `data`
        attribute matches `child_data_name`. If found, it returns the `value` of
        the first child of that Tree node, assuming it's a Token.

        Example structure expected:
            parent_node -> Tree(child_data_name, [Token(..., value)])

        Args:
            parent_node: The parent Tree node to search within.
            child_data_name: The string identifier (`data` attribute) of the target child Tree.

        Returns:
            The string value of the token if found, otherwise None.
        """
        # Avoid partially unknown children by casting
        children_list = cast(List[Any], parent_node.children)
        for child in children_list:
            if isinstance(child, Tree) and child.data == child_data_name:
                # Cast child.children to List[Any] for safe iteration
                raw_children = getattr(child, 'children', [])  # type: ignore
                child_children = cast(List[Any], raw_children)
                token_children: List[Token] = [c for c in child_children if isinstance(c, Token)]
                if token_children:
                    return token_children[0].value
        return None 

    def record_destructive_statement(self, stmt_type: str, node: Tree[Any] | Token, file_path: str) -> None:
        """Records a destructive SQL statement.

        Destructive statements include DELETE, DROP, TRUNCATE, CREATE OR REPLACE, and others
        that modify or destroy data/objects. These are tracked separately for risk assessment.

        Args:
            stmt_type: The type of destructive statement (e.g., 'DELETE', 'DROP_TABLE').
            node: The AST node representing the statement.
            file_path: The path of the file where the statement was found.
        """
        logger.debug(f"ENGINE: record_destructive_statement called with stmt_type={stmt_type}, file_path={file_path}")
        
        # Record the destructive statement in the separate tracking dictionary
        self.result.add_destructive_statement(stmt_type)
        
        # Special handling for DROP statements to ensure DROP_TASK is properly recorded
        if stmt_type == "DROP" and self.last_drop_object_type == "TASK":
            logger.debug(f"ENGINE: Also recording DROP_TASK statement for DROP TASK")
            self.result.add_statement("DROP_TASK", file_path) 