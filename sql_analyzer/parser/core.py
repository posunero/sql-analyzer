"""
Core SQL parsing functionality.

This module is responsible for loading the Lark grammar for Snowflake SQL
and providing a function to parse SQL text into an Abstract Syntax Tree (AST).
It handles grammar loading errors and basic validation of input text.
"""

from __future__ import annotations
import logging
from pathlib import Path
from lark import Lark, Tree, LarkError
from typing import Optional, Any

logger: logging.Logger = logging.getLogger(__name__)

# Determine the absolute path to the grammar file
# Assumes grammar/ is in the parent directory of this file's directory (parser/)
grammar_path: Path = Path(__file__).parent.parent / "grammar" / "snowflake.lark"

# --- Lark Parser Configuration ---
# parser='earley': Chosen for its ability to handle ambiguities, which can be common
#                    in complex SQL grammars. LALR is faster but less flexible.
# propagate_positions=True: Essential for obtaining line/column numbers for AST nodes,
#                           used in error reporting and object location tracking.
# maybe_placeholders=False: Generally safer for SQL to avoid potential misinterpretations
#                            of placeholders if they are not explicitly part of the grammar.
# start='start': Specifies the entry point rule in the snowflake.lark grammar.
# -------------------------------
try:
    # Attempt to load the grammar file relative to this script's location
    # Using propagate_positions=True to get line/column info for errors/analysis
    # maybe_placeholders=False is generally safer for SQL
    sql_parser: Optional[Lark] = Lark.open(  # type: ignore
        str(grammar_path),
        parser='earley',
        propagate_positions=True,
        maybe_placeholders=False,
        start='start'
    )
except FileNotFoundError:
    print(f"Error: Grammar file not found at {grammar_path}")
    # Consider raising a custom exception or exiting if the grammar is essential
    sql_parser = None
except Exception as e:
    print(f"Error loading grammar: {e}")
    sql_parser = None

def parse_sql(sql_text: str) -> Optional[Tree[Any]]:
    """
    Parses the given SQL text using the loaded Lark grammar.

    Args:
        sql_text: The string containing the SQL script to parse.

    Returns:
        A Lark Tree representing the parsed SQL, or None if parsing fails
        or the parser wasn't loaded.

    Raises:
        LarkError: If parsing fails, containing details about the error.
                   The error is logged, and then the exception is re-raised.
    """
    # Add check for empty/whitespace input
    if not sql_text or sql_text.isspace():
        print("Skipping empty or whitespace-only input.")
        return None # Return None for empty input, don't raise error

    if not sql_parser:
        print("Error: SQL parser not initialized.")
        return None

    try:
        # Lark.parse returns a Tree[Any]
        tree: Tree[Any] = sql_parser.parse(sql_text)
        return tree
    except LarkError as e:
        # Log the error and re-raise without printing to stdout
        logger.error(f"Error parsing SQL: {e}")
        raise e
        # return None # Don't return None anymore 