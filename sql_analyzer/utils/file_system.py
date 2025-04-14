"""
File system utilities.

Provides functions for discovering SQL files within directories and reading
their content, handling common file system errors.
"""

import os
from pathlib import Path
import logging
from typing import Iterator, Optional

logger = logging.getLogger(__name__)

def find_sql_files(start_path: str) -> Iterator[Path]:
    """Finds all files with the `.sql` extension within a given path.

    If the `start_path` is a file, it yields the file itself if it ends with `.sql`.
    If the `start_path` is a directory, it recursively searches for all `.sql` files
    within that directory and its subdirectories.

    Args:
        start_path: The path (file or directory) to search within.

    Yields:
        Path objects for each `.sql` file found.

    Raises:
        FileNotFoundError: If the `start_path` does not exist.
    """
    path = Path(start_path)
    if not path.exists():
        logger.error(f"Starting path does not exist: {start_path}")
        raise FileNotFoundError(f"The specified path does not exist: {start_path}")

    if path.is_file():
        if path.suffix.lower() == '.sql':
            logger.debug(f"Found single SQL file: {path}")
            yield path
        else:
            logger.warning(f"Input file is not a .sql file, skipping: {path}")
    elif path.is_dir():
        logger.info(f"Searching for .sql files recursively in directory: {path}")
        count = 0
        for item in path.rglob('*.sql'):
            if item.is_file():
                logger.debug(f"Found SQL file: {item}")
                yield item
                count += 1
        if count == 0:
            logger.warning(f"No .sql files found in directory: {path}")
    else:
        # This case should be rare (e.g., broken symlink, special file)
        logger.warning(f"Input path is neither a file nor a directory: {path}")

def read_file_content(file_path: Path) -> Optional[str]:
    """Reads the entire content of a text file, attempting UTF-8 decoding.

    Args:
        file_path: The `Path` object representing the file to read.

    Returns:
        The content of the file as a string if successful, otherwise None.
        Logs errors if reading or decoding fails.
    """
    try:
        logger.debug(f"Reading content from: {file_path}")
        content = file_path.read_text(encoding='utf-8')
        logger.debug(f"Successfully read {len(content)} characters from {file_path}")
        return content
    except IOError as e:
        logger.error(f"IOError reading file {file_path}: {e}")
        return None
    except UnicodeDecodeError as e:
        logger.error(f"UnicodeDecodeError reading file {file_path} as UTF-8: {e}. Try a different encoding if needed.")
        return None
    except Exception as e:
        logger.exception(f"Unexpected error reading file {file_path}: {e}", exc_info=True)
        return None

# TODO: Implement file finding/reading functions 