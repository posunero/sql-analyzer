"""
Handles command-line argument parsing.
"""

import argparse
import logging

logger = logging.getLogger(__name__)

def parse_arguments() -> argparse.Namespace:
    """Parses command-line arguments for the SQL analyzer."""
    parser = argparse.ArgumentParser(
        description="Analyzes Snowflake SQL files to extract metadata and statistics."
    )

    parser.add_argument(
        'input_paths',
        metavar='PATH',
        type=str,
        nargs='+',
        help='One or more paths to SQL files or directories containing SQL files.'
    )

    parser.add_argument(
        '--format',
        type=str,
        choices=['text', 'json', 'csv'],
        default='text',
        help='Output format for the analysis results (default: text).'
    )

    parser.add_argument(
        '--verbose',
        '--log-level',
        action='store',
        default='INFO',
        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
        help='Set the logging level (default: INFO).'
    )

    parser.add_argument(
        '--fail-fast',
        action='store_true',
        help='Stop processing immediately if an error is encountered in any file.'
    )

    # Add more arguments here as needed, e.g., output file
    # parser.add_argument(
    #     '--output',
    #     '--out',
    #     type=str,
    #     default=None,
    #     help='Optional path to write the output report file.'
    # )

    args = parser.parse_args()
    logger.debug(f"Arguments parsed: {args}")
    return args 