from lark import Lark
import os

# Get the current directory (where parser.py is located)
current_dir = os.path.dirname(os.path.abspath(__file__))
grammar_path = os.path.join(current_dir, 'snowflake.lark')

parser = Lark.open(grammar_path, parser='lalr', propagate_positions=True, maybe_placeholders=False)

# Test various SQL statements
test_statements = [
    "SELECT * FROM my_table;",
    "CREATE WAREHOUSE my_warehouse WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 60;",
    "CREATE TASK my_task WAREHOUSE = compute_wh SCHEDULE = 'USING CRON 0 0 * * * UTC' AS SELECT * FROM my_table;",
    "CREATE STREAM my_stream ON TABLE my_table APPEND_ONLY = TRUE;",
    "ALTER WAREHOUSE my_warehouse SUSPEND;",
    "DROP TABLE my_table;",
    "SHOW TABLES;",
    "DESCRIBE TABLE my_table;"
]

for i, stmt in enumerate(test_statements):
    try:
        print(f"\nParsing statement {i+1}: {stmt}")
        tree = parser.parse(stmt)
        print("Success! Parse tree:")
        print(tree.pretty())
    except Exception as e:
        print(f"Error parsing: {e}")