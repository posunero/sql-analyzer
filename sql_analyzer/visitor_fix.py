"""
Contains a new Lark Visitor implementation that correctly handles the AST structure.
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
        
    def statement(self, tree):
        """Process a statement node - this is a key entry point."""
        # The statement node contains exactly one child - the actual statement type
        if tree.children and len(tree.children) == 1:
            stmt_node = tree.children[0]
            if isinstance(stmt_node, Tree):
                # Record the statement type (e.g., select_stmt, create_table_stmt)
                self.engine.record_statement(stmt_node)
                
                # Handle specific statement types that create/modify/reference objects
                if stmt_node.data == 'select_stmt':
                    self._process_select_stmt(stmt_node)
                elif stmt_node.data == 'create_table_stmt':
                    self._process_create_table_stmt(stmt_node)
                elif stmt_node.data == 'alter_table_stmt':
                    self._process_alter_table_stmt(stmt_node)
                elif stmt_node.data == 'drop_stmt':
                    self._process_drop_stmt(stmt_node)
                elif stmt_node.data == 'use_stmt':
                    self._process_use_stmt(stmt_node)
    
    def _process_select_stmt(self, tree):
        """Extract table references from a SELECT statement."""
        # Find all table_ref nodes
        for table_ref in self._find_all_by_name(tree, 'table_ref'):
            # Within table_ref, find qualified_name for the table
            for qual_name in self._find_all_by_name(table_ref, 'qualified_name'):
                table_name = self._extract_qualified_name(qual_name)
                if table_name:
                    self.engine.record_object(table_name, "TABLE", "REFERENCE", qual_name)
    
    def _process_create_table_stmt(self, tree):
        """Extract the table being created from a CREATE TABLE statement."""
        # CREATE TABLE statements have the table name as a qualified_name child
        for qual_name in self._find_all_by_name(tree, 'qualified_name'):
            table_name = self._extract_qualified_name(qual_name)
            if table_name:
                self.engine.record_object(table_name, "TABLE", "CREATE", qual_name)
                break  # Only process the first qualified_name (table name)
    
    def _process_alter_table_stmt(self, tree):
        """Extract the table being altered from an ALTER TABLE statement."""
        # ALTER TABLE statements have the table name as a qualified_name child
        for qual_name in self._find_all_by_name(tree, 'qualified_name'):
            table_name = self._extract_qualified_name(qual_name)
            if table_name:
                self.engine.record_object(table_name, "TABLE", "ALTER", qual_name)
                break  # Only process the first qualified_name (table name)
    
    def _process_drop_stmt(self, tree):
        """Extract object being dropped from a DROP statement."""
        # Find the object type (TOKEN child)
        obj_type = "UNKNOWN"
        if len(tree.children) >= 1 and isinstance(tree.children[0], Token):
            obj_type = tree.children[0].value
            
        # Find the qualified_name (object name)
        for qual_name in self._find_all_by_name(tree, 'qualified_name'):
            obj_name = self._extract_qualified_name(qual_name)
            if obj_name:
                self.engine.record_object(obj_name, obj_type, "DROP", qual_name)
                break
    
    def _process_use_stmt(self, tree):
        """Extract object from a USE statement."""
        # Find the object type (TOKEN child)
        obj_type = "UNKNOWN"
        if len(tree.children) >= 1 and isinstance(tree.children[0], Token):
            obj_type = tree.children[0].value
            
        # Find the qualified_name (object name)
        for qual_name in self._find_all_by_name(tree, 'qualified_name'):
            obj_name = self._extract_qualified_name(qual_name)
            if obj_name:
                self.engine.record_object(obj_name, obj_type, "USE", qual_name)
                break
    
    def _find_all_by_name(self, tree, name):
        """Find all subtrees with the given node name."""
        if not isinstance(tree, Tree):
            return []
            
        result = []
        if hasattr(tree, 'data') and tree.data == name:
            result.append(tree)
            
        for child in tree.children:
            result.extend(self._find_all_by_name(child, name))
            
        return result
    
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