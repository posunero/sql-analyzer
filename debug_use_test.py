"""
Debug script to test the USE statement handling in the analysis engine.
"""

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine
from lark import Tree, Token


# Sample USE statements for testing
sql_text = """
USE WAREHOUSE my_wh;
USE DATABASE my_db;
"""

def main():
    print("\n--- Parsing and analyzing USE statements ---")
    print(f"SQL input:\n{sql_text}")
    
    tree = parse_sql(sql_text)
    if not tree:
        print("Failed to parse SQL.")
        return
    
    # Create engine and enable debugging
    engine = AnalysisEngine()
    engine.visitor.debug = True
    
    # Analyze the parsed tree
    result = engine.analyze(tree)
    
    # Print results
    print("\n--- Results ---")
    print(f"Statement counts: {dict(result.statement_counts)}")
    print(f"Objects found: {len(result.objects_found)}")
    
    for obj in result.objects_found:
        print(f"  - {obj.action} {obj.object_type}: {obj.name}")


if __name__ == "__main__":
    main() 