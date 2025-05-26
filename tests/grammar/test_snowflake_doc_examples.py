import os
import glob
import pytest
from typing import List
from sql_analyzer.parser.core import parse_sql

FIXTURES_DIR = os.path.join(os.path.dirname(__file__), '..', 'fixtures', 'snowflake_doc_examples')

# Collect all .sql files in the fixture directory
def get_sql_files() -> List[str]:
    pattern = os.path.join(FIXTURES_DIR, '*.sql')
    return glob.glob(pattern)

@pytest.mark.parametrize('sql_file', get_sql_files())
def test_parse_snowflake_doc_example(sql_file: str) -> None:
    with open(sql_file, encoding='utf-8') as f:
        sql = f.read()
    if not sql.strip():
        pytest.skip(f"{sql_file} is empty or whitespace only.")
    try:
        tree = parse_sql(sql)
    except Exception as e:
        pytest.fail(f"Parsing failed for {sql_file}: {e}")
    assert tree is not None, f"No parse tree returned for {sql_file}" 