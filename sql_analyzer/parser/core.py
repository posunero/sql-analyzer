"""
Core parser logic. Loads the grammar and provides parsing functions.
"""

import os
from pathlib import Path
from lark import Lark, Tree, LarkError
from typing import Optional

# Determine the absolute path to the grammar file
# Assumes grammar/ is in the parent directory of this file's directory (parser/)
grammar_path = Path(__file__).parent.parent / "grammar" / "snowflake.lark"

try:
    # Attempt to load the grammar file relative to this script's location
    # Using propagate_positions=True to get line/column info for errors/analysis
    # maybe_placeholders=False is generally safer for SQL
    # parser='lalr' is a good balance of speed and power
    sql_parser = Lark.open(
        grammar_path,
        parser='lalr',
        propagate_positions=True,
        maybe_placeholders=False,
        start='start' # Corrected: Use the 'start' rule from snowflake.lark
    )
except FileNotFoundError:
    print(f"Error: Grammar file not found at {grammar_path}")
    # Consider raising a custom exception or exiting if the grammar is essential
    sql_parser = None
except Exception as e:
    print(f"Error loading grammar: {e}")
    sql_parser = None

def parse_sql(sql_text: str) -> Optional[Tree]:
    """
    Parses the given SQL text using the loaded Lark grammar.

    Args:
        sql_text: The string containing the SQL script to parse.

    Returns:
        A Lark Tree representing the parsed SQL, or None if parsing fails
        or the parser wasn't loaded.

    Raises:
        LarkError: If parsing fails, containing details about the error.
                   (This is handled internally and converted to returning None,
                    but callers might want to know it *can* be raised).
    """
    if not sql_parser:
        print("Error: SQL parser not initialized.")
        return None

    try:
        tree = sql_parser.parse(sql_text)
        return tree
    except LarkError as e:
        # Log the error or handle it as needed
        # For now, just print it and return None
        print(f"Error parsing SQL: {e}")
        # Optionally re-raise or raise a custom exception
        # raise e
        return None 