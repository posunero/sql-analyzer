import os
from pathlib import Path
import logging
from typing import Iterator

logger = logging.getLogger(__name__)

def find_sql_files(start_path: str) -> Iterator[Path]:
    """
    Recursively finds all .sql files starting from the given path.

    Args:
        start_path: The directory or file path to start searching from.

    Yields:
        Path objects representing the found .sql files.
    """
    path = Path(start_path)
    if not path.exists():
        logger.error(f"Path does not exist: {start_path}")
        return

    if path.is_file():
        if path.suffix.lower() == '.sql':
            yield path
    elif path.is_dir():
        for item in path.rglob('*.sql'):
            if item.is_file():
                yield item

def read_file_content(file_path: Path) -> str | None:
    """
    Reads the content of a file.

    Args:
        file_path: The path to the file.

    Returns:
        The content of the file as a string, or None if an error occurs.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except IOError as e:
        logger.error(f"Error reading file {file_path}: {e}")
        return None
    except UnicodeDecodeError as e:
        logger.error(f"Error decoding file {file_path} as UTF-8: {e}")
        # Consider trying other encodings or reporting more specifically
        return None 