"""
Centralized functions for reporting specific types of errors via logging.

These functions provide a consistent way to log errors encountered during
file processing (parsing, file access) using the standard logging module.
They are primarily called from the main processing loop.
"""

import logging
from pathlib import Path
from typing import Optional

logger = logging.getLogger(__name__) # Logger specific to this module

def report_parsing_error(file_path: Path | str, line: Optional[int], message: str) -> None:
    """Logs a parsing error encountered in a specific file and line.

    Args:
        file_path: The path to the file where the error occurred.
        line: The line number (1-indexed) where the error occurred, or None if unknown.
        message: The specific error message, potentially including Lark details.
    """
    # Ensure file_path is a string for logging
    file_path_str = str(file_path)
    line_str = f" at line {line}" if line is not None else ""
    log_message = f"Parse error in \"{file_path_str}\"{line_str}: {message}"
    # Log as ERROR because parsing failures prevent analysis of that file
    logger.error(log_message)

def report_file_error(file_path: Path | str, message: str) -> None:
    """Logs an error related to accessing or reading a file.

    Args:
        file_path: The path to the file that could not be accessed/read.
        message: A description of the file access error (e.g., permissions, not found).
    """
    file_path_str = str(file_path)
    log_message = f"File access/read error for \"{file_path_str}\": {message}"
    # Log as ERROR as this prevents processing the file
    logger.error(log_message)

# Future: Could add functions for specific analysis errors if they arise.

# Add more specific error reporting functions as needed 