from __future__ import annotations

"""
Handles command-line argument parsing.
"""

import argparse
import logging

logger: logging.Logger = logging.getLogger(__name__)

def parse_arguments() -> argparse.Namespace:
    """Parses and validates command-line arguments for the SQL analyzer.

    Returns:
        An argparse.Namespace object containing the parsed arguments.
    """
    parser: argparse.ArgumentParser = argparse.ArgumentParser(
        description="Analyzes Snowflake SQL files to extract metadata, statistics, and object references.",
    )

    parser.add_argument(
        'input_paths',
        metavar='PATH',
        type=str,
        nargs='+',
        help='One or more paths to SQL files or directories containing SQL files. Paths are processed recursively.'
    )

    parser.add_argument(
        '--format',
        type=str,
        choices=['text', 'json', 'html'],
        default='text',
        help='Output format for the analysis results. (default: text)'
    )

    parser.add_argument(
        '--verbose',
        '--log-level',
        action='store',
        default='INFO',
        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
        help='Set the detail level for logging messages. (default: INFO)'
    )

    parser.add_argument(
        '--verbose-report',
        action='store_true',
        help='Generate a more detailed report. For text format, this includes object locations (line/column).'
    )

    parser.add_argument(
        '--fail-fast',
        action='store_true',
        help='Stop processing immediately if an error is encountered in any file.'
    )

    parser.add_argument(
        '--output',
        '--out',
        type=str,
        default=None,
        help='Optional path to write the output report file instead of printing to stdout.'
    )

    parser.add_argument(
        '--validate',
        action='store_true',
        help='Only validate SQL syntax without performing analysis.'
    )

    # Add more arguments here as needed, e.g., output file
    # parser.add_argument(
    #     '--output',
    #     '--out',
    #     type=str,
    #     default=None,
    #     help='Optional path to write the output report file instead of printing to stdout.'
    # )

    args: argparse.Namespace = parser.parse_args()
    logger.debug(f"Arguments parsed: {args}")
    return args 