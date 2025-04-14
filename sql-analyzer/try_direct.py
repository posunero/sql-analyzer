"""
Direct test for USE statement handling.
"""

import sys
from pathlib import Path
from lark import Tree, Token

# Add root directory to path
sys.path.append(str(Path(__file__).parent))

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.models import AnalysisResult

def handle_use_stmt(node, result=None):
    """Direct test of USE statement handler logic."""
    if result is None:
        result = AnalysisResult()

    print(f"Handling node type: {node.data}")
    print(f"Children: {node.children}")
    
    # Look for object_type child node
    for child in node.children:
        if isinstance(child, Tree) and child.data == 'object_type':
            # Get the token value
            if child.children and isinstance(child.children[0], Token):
                obj_type = child.children[0].value.upper()
                print(f"Found object_type: {obj_type}")
                
                # Add to result
                stmt_type = f"USE_{obj_type}"
                result.add_statement(stmt_type)
                print(f"Added statement type: {stmt_type}")
                return result
    
    # Fallback
    print("No object_type found, using fallback")
    result.add_statement("USE")
    return result

def test_use_stmt():
    """Test parsing and handling a USE statement."""
    # Parse a simple USE statement
    sql = "USE WAREHOUSE my_wh;"
    tree = parse_sql(sql)
    
    if not tree:
        print("Failed to parse SQL")
        return
    
    # Find the use_stmt node
    def find_use_stmt(node):
        if isinstance(node, Tree):
            if node.data == 'use_stmt':
                print(f"Found use_stmt node: {node}")
                return node
            
            for child in node.children:
                result = find_use_stmt(child)
                if result:
                    return result
        return None
    
    use_node = find_use_stmt(tree)
    if not use_node:
        print("No use_stmt node found")
        return
    
    # Test our handler
    result = handle_use_stmt(use_node)
    
    # Check the result
    print("\nFinal statement counts:")
    for stmt_type, count in result.statement_counts.items():
        print(f"  {stmt_type}: {count}")

if __name__ == "__main__":
    test_use_stmt() 