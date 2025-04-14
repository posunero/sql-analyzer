import logging
from pathlib import Path

logger = logging.getLogger(__name__)

def report_parsing_error(file_path: Path, line: int | None, message: str):
    """Reports a parsing error encountered in a specific file."""
    location = f" at line {line}" if line is not None else ""
    error_message = f"Parsing error in {file_path}{location}: {message}"
    logger.error(error_message)
    # In the future, this could raise an exception or add to an error list
    print(f"ERROR: {error_message}") # Simple console output for now

def report_file_error(file_path: Path, message: str):
    """Reports a general file processing error (e.g., read error)."""
    error_message = f"File error for {file_path}: {message}"
    logger.error(error_message)
    # Similar to above, enhance error handling strategy later
    print(f"ERROR: {error_message}") # Simple console output for now 