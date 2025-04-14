"""
Centralized error reporting utilities.
"""

import logging
from pathlib import Path

logger = logging.getLogger(__name__) # Get logger specific to this module

def report_parsing_error(file_path: Path | str, line: int | None, message: str):
    """Reports a parsing error encountered in a specific file.

    Args:
        file_path: The path to the file where the error occurred.
        line: The line number where the error occurred (if available).
        message: The error message.
    """
    location = f" at line {line}" if line else ""
    log_message = f"Parse error in {file_path}{location}: {message}"
    logger.error(log_message) # Log as error for visibility

def report_file_error(file_path: Path | str, message: str):
    """Reports an error related to file access or reading.

    Args:
        file_path: The path to the file involved.
        message: The error message.
    """
    log_message = f"File error for {file_path}: {message}"
    logger.error(log_message)

# Add more specific error reporting functions as needed 