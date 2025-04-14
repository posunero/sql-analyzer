"""
Debug script to examine the AST structure of USE statements.
"""

from sql_analyzer.parser.core import parse_sql
from lark import Tree, Token

# Sample USE statements
sql_text = """
USE DATABASE my_db;
USE WAREHOUSE my_wh;
"""

def print_node(node, indent=0):
    """Pretty-print the node structure."""
    indent_str = "  " * indent
    if isinstance(node, Tree):
        print(f"{indent_str}TREE[{node.data}]")
        for child in node.children:
            print_node(child, indent + 1)
    elif isinstance(node, Token):
        print(f"{indent_str}TOKEN[{node.type}]: {node.value!r}")
    else:
        print(f"{indent_str}OTHER: {node}")

def explore_use_stmt(tree, target_rule='use_stmt'):
    """Find and explore the structure of use statements."""
    if isinstance(tree, Tree):
        # If this is the target node, print its structure
        if tree.data == target_rule:
            print(f"\n--- Found {target_rule} ---")
            print_node(tree)
            print("-------------------\n")
            return
        
        # Otherwise, explore children
        for child in tree.children:
            explore_use_stmt(child, target_rule)

if __name__ == "__main__":
    print("Parsing SQL...")
    tree = parse_sql(sql_text)
    
    if tree:
        print("Exploring USE statements...")
        explore_use_stmt(tree)
        
        # Also check the object_type nodes directly
        print("\nExploring object_type nodes...")
        explore_use_stmt(tree, 'object_type')
    else:
        print("Failed to parse SQL.") 