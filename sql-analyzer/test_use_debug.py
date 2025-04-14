"""
Direct debug script to test handling of USE statements without pytest.
"""

from sql_analyzer.analysis.engine import AnalysisEngine
from sql_analyzer.parser.core import parse_sql
from lark import Tree, Token

# Sample SQL with USE statements
SQL_USE_STATEMENTS = """
USE WAREHOUSE my_wh;
USE DATABASE my_db;
"""

def debug_use_statements():
    print("\n=== Testing USE statement analysis ===\n")
    print(f"Parsing SQL: {SQL_USE_STATEMENTS}")
    
    tree = parse_sql(SQL_USE_STATEMENTS)
    if not tree:
        print("Failed to parse SQL")
        return
    
    print("\nParse tree created successfully. Running analysis...")
    
    engine = AnalysisEngine()
    result = engine.analyze(tree, file_path="debug_script.sql")
    
    print("\n=== Analysis Results ===")
    print(f"Statement counts: {dict(result.statement_counts)}")
    print("Objects found:")
    for obj in result.objects_found:
        print(f"  - {obj.action} {obj.object_type}: {obj.name}")
    
    print("\nExpected counts should include:")
    print("  - USE_WAREHOUSE: 1")
    print("  - USE_DATABASE: 1")
    print("Instead of generic 'USE' counts")

if __name__ == "__main__":
    debug_use_statements() 