from __future__ import annotations
"""
Module for SQL validation functionality.
"""
import logging
from typing import Optional, Dict, List, Tuple
from pathlib import Path

from lark import LarkError

from sql_analyzer.parser import core as parser_core
from sql_analyzer.utils import file_system

logger: logging.Logger = logging.getLogger(__name__)

def validate_sql_file(file_path: Path) -> Tuple[bool, Optional[str]]:
    """
    Validate a single SQL file.
    
    Args:
        file_path: Path to the SQL file
        
    Returns:
        Tuple of (is_valid, error_message)
    """
    try:
        content: Optional[str] = file_system.read_file_content(file_path)
        if content is None:
            return False, "Could not read file"

        # Use existing parser to validate
        parser_core.parse_sql(content)
        return True, None
    except LarkError as e:
        # Format error message nicely
        error_msg = f"Line {getattr(e, 'line', '?')}, column {getattr(e, 'column', '?')}: {str(e)}"
        return False, error_msg
    except Exception as e:
        return False, f"Unexpected error: {str(e)}"

def validate_multiple_files(file_paths: List[Path]) -> Dict[str, Tuple[bool, Optional[str]]]:
    """
    Validate multiple SQL files.
    
    Args:
        file_paths: List of paths to SQL files
        
    Returns:
        Dictionary of {file_path: (is_valid, error_message)}
    """
    results: Dict[str, Tuple[bool, Optional[str]]] = {}
    for file_path in file_paths:
        is_valid: bool
        error_message: Optional[str]
        is_valid, error_message = validate_sql_file(file_path)
        results[str(file_path)] = (is_valid, error_message)
    return results 