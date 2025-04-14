"""
Contains a Lark Visitor implementation that correctly analyzes SQL statements.
"""

from lark import Visitor, Tree, Token
from typing import List, Dict, Any, TYPE_CHECKING

if TYPE_CHECKING:
    from sql_analyzer.analysis.engine import AnalysisEngine

class SQLVisitor(Visitor):
    """A visitor that traverses the SQL parse tree to identify statements and objects."""
    
    def __init__(self, engine):
        self.engine = engine
        self.current_file = ""
        self.debug = False  # Set to True to enable debug output
        
    def _debug(self, msg):
        """Print debug message if debug mode is enabled."""
        if self.debug:
            print(msg)
            
    def _debug_tree(self, tree, prefix="Tree"):
        """Print tree structure for debugging."""
        if not self.debug:
            return
            
        def _print_node(node, indent=0):
            if isinstance(node, Tree):
                print(f"{'  ' * indent}{node.data}")
                for child in node.children:
                    _print_node(child, indent + 1)
            elif isinstance(node, Token):
                print(f"{'  ' * indent}TOKEN[{node.type}]: {node.value}")
            else:
                print(f"{'  ' * indent}OTHER: {node}")
                
        print(f"\n--- {prefix} ---")
        _print_node(tree)
        print("-------------------\n")
        
    def statement(self, tree):
        """Process a statement node - record its type."""
        self._debug_tree(tree, "Statement")
        
        # The statement node contains exactly one child - the actual statement type
        if tree.children and len(tree.children) == 1:
            stmt_node = tree.children[0]
            if isinstance(stmt_node, Tree):
                # Record the statement type (e.g., select_stmt, create_table_stmt)
                # The engine will handle cleaning/extracting the specific type
                self.engine.record_statement(stmt_node)
                
        # Lark's Visitor will automatically call the specific methods below
        # No need for manual dispatch here anymore
        # self.visit_children(tree) # Lark does this automatically
    
    def select_stmt(self, tree):
        """Extract table references from a SELECT statement."""
        self._debug_tree(tree, "Select Statement")
        
        # Find all table_ref nodes
        for table_ref in self._find_all_by_name(tree, 'table_ref'):
            # Within table_ref, find qualified_name for the table
            for qual_name in self._find_all_by_name(table_ref, 'qualified_name'):
                table_name = self._extract_qualified_name(qual_name)
                if table_name:
                    self._debug(f"Found table reference: {table_name}")
                    # Action is REFERENCE
                    self.engine.record_object(table_name, "TABLE", "REFERENCE", qual_name)
    
    def create_table_stmt(self, tree):
        """Extract the table being created from a CREATE TABLE statement."""
        self._debug_tree(tree, "Create Table Statement")
        
        # CREATE TABLE statements have the table name as a qualified_name child
        # Important: Find the *first* qualified_name, which is the table name itself
        qual_name = self._find_first_by_name(tree, 'qualified_name')
        if qual_name:
            table_name = self._extract_qualified_name(qual_name)
            if table_name:
                self._debug(f"Found table creation: {table_name}")
                 # Action is CREATE
                self.engine.record_object(table_name, "TABLE", "CREATE", qual_name)

        # Note: We might want to process other qualified names (e.g., column names, constraints)
        # but for object tracking, we primarily care about the table name here.
        
    def alter_table_stmt(self, tree):
        """Extract the table being altered from an ALTER TABLE statement."""
        self._debug_tree(tree, "Alter Table Statement")
        
        # ALTER TABLE statements have the table name as the first qualified_name child
        qual_name = self._find_first_by_name(tree, 'qualified_name')
        if qual_name:
            table_name = self._extract_qualified_name(qual_name)
            if table_name:
                self._debug(f"Found table alteration: {table_name}")
                 # Action is ALTER
                self.engine.record_object(table_name, "TABLE", "ALTER", qual_name)

    def drop_stmt(self, tree):
        """Extract object being dropped from a DROP statement."""
        self._debug_tree(tree, "Drop Statement")
        
        # Find the object type (nested inside object_type node)
        obj_type = "UNKNOWN"
        obj_type_node = self._find_first_by_name(tree, 'object_type')
        if obj_type_node and obj_type_node.children:
            token = obj_type_node.children[0]
            if isinstance(token, Token):
                 obj_type = token.value.upper() # Use uppercase for consistency

        # Find the qualified_name (object name)
        qual_name = self._find_first_by_name(tree, 'qualified_name')
        if qual_name:
            obj_name = self._extract_qualified_name(qual_name)
            if obj_name:
                self._debug(f"Found {obj_type} drop: {obj_name}")
                 # Action is DROP
                self.engine.record_object(obj_name, obj_type, "DROP", qual_name)
    
    def use_stmt(self, tree):
        """Extract object from a USE statement."""
        self._debug_tree(tree, "Use Statement")
        
        # Find the object type (nested inside object_type node)
        obj_type = "UNKNOWN"
        obj_type_node = self._find_first_by_name(tree, 'object_type')
        if obj_type_node and obj_type_node.children:
            token = obj_type_node.children[0]
            if isinstance(token, Token):
                 obj_type = token.value.upper() # Use uppercase for consistency

        # Find the qualified_name (object name)
        qual_name = self._find_first_by_name(tree, 'qualified_name')
        if qual_name:
            obj_name = self._extract_qualified_name(qual_name)
            if obj_name:
                self._debug(f"Found {obj_type} use: {obj_name}")
                 # Action is USE
                self.engine.record_object(obj_name, obj_type, "USE", qual_name)
    
    def _find_all_by_name(self, tree, name):
        """Find all subtrees with the given node name."""
        if not isinstance(tree, Tree):
            return []
            
        result = []
        if hasattr(tree, 'data') and tree.data == name:
            result.append(tree)
            
        for child in tree.children:
            if isinstance(child, Tree): # Recurse only into Trees
                result.extend(self._find_all_by_name(child, name))
            
        return result
    
    def _find_first_by_name(self, tree, name):
        """Find the first direct child subtree with the given node name."""
        if not isinstance(tree, Tree):
            return None
        for child in tree.children:
            if isinstance(child, Tree) and hasattr(child, 'data') and child.data == name:
                return child
        return None # Not found as a direct child
    
    def _extract_qualified_name(self, tree):
        """Extract the full name from a qualified_name node."""
        if not isinstance(tree, Tree) or not hasattr(tree, 'data') or tree.data != 'qualified_name':
            return None
            
        name_parts = [
            child.value for child in tree.children 
            if isinstance(child, Token) and child.type == 'IDENTIFIER'
        ]
        
        if not name_parts:
            return None
            
        return ".".join(name_parts)

    # --- Utility Methods ---
    
    def _find_all_by_name(self, tree, name):
        """Find all subtrees with the given node name."""
        if not isinstance(tree, Tree):
            return []
            
        result = []
        if hasattr(tree, 'data') and tree.data == name:
            result.append(tree)
            
        for child in tree.children:
            if isinstance(child, Tree): # Recurse only into Trees
                result.extend(self._find_all_by_name(child, name))
            
        return result
    
    def _find_first_by_name(self, tree, name):
        """Find the first direct child subtree with the given node name."""
        if not isinstance(tree, Tree):
            return None
        for child in tree.children:
            if isinstance(child, Tree) and hasattr(child, 'data') and child.data == name:
                return child
        return None # Not found as a direct child

    # --- Lark Visitor Methods (Default Behavior) ---
    # These are typically visited automatically by Lark
    
    def start(self, tree: Tree):
        """Entry point for the entire SQL script."""
        self._debug_tree(tree, "start")
        # Default visitor behavior is to visit children, which is what we want.
        pass 
        
    def _statement(self, tree: Tree):
        """Processes an _statement node (wrapper around statement)."""
        self._debug_tree(tree, "_statement")
        # Default visitor behavior is fine.
        pass

    def qualified_name(self, tree: Tree):
        """Handles qualified names when visited directly.
        This happens for names not explicitly handled by statement rules above.
        We generally don't need to record these unless we add context tracking.
        """
        self._debug_tree(tree, "qualified_name direct visit")
        # Don't record anything by default here, as context is unknown.
        pass
    
    # Removed the placeholder comments and extra methods

# End of class SQLVisitor 