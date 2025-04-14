"""
Core analysis logic. Contains the AnalysisEngine class that uses a Visitor
to populate AnalysisResult data structures.
"""

from lark import Tree, Token
from typing import Optional

from sql_analyzer.analysis.models import AnalysisResult, ObjectInfo
from sql_analyzer.parser.visitor import SQLVisitor # Will be created next

class AnalysisEngine:
    """Orchestrates the analysis of a parsed SQL tree.

    Uses an SQLVisitor to traverse the tree and populates an AnalysisResult.
    """
    def __init__(self):
        self.result = AnalysisResult()
        # The visitor needs a reference back to the engine to add findings
        self.visitor = SQLVisitor(self)

    def analyze(self, tree: Tree, file_path: str = "") -> AnalysisResult:
        """Analyzes a parsed SQL tree and returns the results."""
        if not tree:
            # Handle cases where parsing might have failed earlier
            return self.result

        # Reset results if analyzing a new tree/file potentially
        # Or modify to accumulate if desired
        # self.result = AnalysisResult() # Uncomment if you want fresh results per call

        self.visitor.current_file = file_path # Provide context to the visitor
        self.visitor.visit(tree)
        return self.result

    # --- Methods called by the Visitor --- 

    def record_statement(self, statement_node: Tree):
        """Records the occurrence of a statement type."""
        if hasattr(statement_node, 'data'):
            statement_type = str(statement_node.data)
            
            # --- Handling for DDL/USE statements to get specific type --- 

            # Example: Extract CREATE_TABLE from create_table_stmt within ddl_stmt
            if statement_type == 'ddl_stmt' and statement_node.children and isinstance(statement_node.children[0], Tree):
                inner_ddl_node = statement_node.children[0] # e.g., create_stmt, alter_stmt, drop_stmt
                inner_ddl_type = str(inner_ddl_node.data)
                
                # Handle CREATE sub-types (CREATE TABLE, CREATE VIEW, etc.)
                if inner_ddl_type == 'create_stmt' and inner_ddl_node.children and isinstance(inner_ddl_node.children[0], Tree):
                    specific_create_node = inner_ddl_node.children[0]
                    specific_create_type = str(specific_create_node.data)
                    clean_type = specific_create_type.upper().replace('_STMT', '')
                    self.result.add_statement(clean_type)
                    return # Recorded specific CREATE type
                    
                # Handle ALTER sub-types (ALTER TABLE, ALTER WAREHOUSE, etc.)
                elif inner_ddl_type == 'alter_stmt' and inner_ddl_node.children and isinstance(inner_ddl_node.children[0], Tree):
                    specific_alter_node = inner_ddl_node.children[0]
                    specific_alter_type = str(specific_alter_node.data)
                    clean_type = specific_alter_type.upper().replace('_STMT', '')
                    self.result.add_statement(clean_type)
                    return # Recorded specific ALTER type

                # Handle DROP statements (DROP TABLE, DROP VIEW, etc.)
                elif inner_ddl_type == 'drop_stmt':
                    # Find the 'object_type' child node within drop_stmt
                    obj_type_node = None
                    for child in inner_ddl_node.children:
                        if isinstance(child, Tree) and child.data == 'object_type':
                            obj_type_node = child
                            break
                            
                    if obj_type_node and obj_type_node.children and isinstance(obj_type_node.children[0], Token):
                        type_token = obj_type_node.children[0]
                        self.result.add_statement(f'DROP_{type_token.value.upper()}')
                        return # Recorded specific DROP type
                    else:
                        # Fallback if object_type node structure is unexpected
                        self.result.add_statement('DROP') 
                        return
                
                # Add other DDL statement types here if needed (e.g., TRUNCATE)
                # If no specific DDL type handled, fall through to general handling

            # Handle USE statements (USE WAREHOUSE, USE DATABASE, etc.)
            elif statement_type == 'use_stmt':
                # Find the 'object_type' child node within use_stmt
                obj_type_node = None
                for child in statement_node.children:
                    if isinstance(child, Tree) and child.data == 'object_type':
                        obj_type_node = child
                        break
                        
                if obj_type_node and obj_type_node.children and isinstance(obj_type_node.children[0], Token):
                    type_token = obj_type_node.children[0]
                    self.result.add_statement(f'USE_{type_token.value.upper()}')
                    return # Recorded specific USE type
                else:
                     # Fallback if object_type node structure is unexpected
                    self.result.add_statement('USE')
                    return
            
            # --- General Statement Type Cleaning (for non-nested types like SELECT) ---
            if statement_type.startswith('_'):
                statement_type = statement_type[1:] # Remove leading underscore
            if statement_type.endswith(('_stmt', '_statement')):
                suffix_stmt = '_stmt'
                suffix_statement = '_statement'
                if statement_type.endswith(suffix_statement):
                    statement_type = statement_type[:-len(suffix_statement)]
                elif statement_type.endswith(suffix_stmt):
                    statement_type = statement_type[:-len(suffix_stmt)]
                
            self.result.add_statement(statement_type.upper()) # Record cleaned, uppercase type

    def record_object(self, name: str, obj_type: str, action: str, node: Tree):
        """Records an encountered database object."""
        line = node.line if hasattr(node, 'line') else 0
        column = node.column if hasattr(node, 'column') else 0
        # TODO: Implement logic to resolve full object names (db.schema.table)
        # For now, just record the name as found
        full_name = name
        self.result.add_object(full_name, obj_type, action, line, column) 