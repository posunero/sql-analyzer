import pytest
import json
from lark import Tree
from pathlib import Path

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.models import AnalysisResult
from sql_analyzer.reporting.formats import text as text_formatter, json as json_formatter

# Reuse helper functions from test_analysis
from .test_analysis import analyze_sql, analyze_fixture_file

# Path to the PIPE fixture
PIPE_FIXTURE = "tests/fixtures/valid/pipe_statements.sql"

# Parser tests for PIPE

def test_parse_create_pipe():
    sql = "CREATE PIPE p1 AUTO_INGEST = TRUE AWS_SNS_TOPIC = 'topic' COMMENT = 'cmt' AS COPY INTO t1 FROM @s1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE PIPE should return a Tree."


def test_parse_alter_pipe_set():
    sql = "ALTER PIPE p1 SET COMMENT = 'new_comment', AUTO_INGEST = FALSE;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER PIPE SET should return a Tree."


def test_parse_alter_pipe_refresh():
    sql = "ALTER PIPE p1 REFRESH;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER PIPE REFRESH should return a Tree."


def test_parse_drop_pipe():
    sql = "DROP PIPE IF EXISTS p1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DROP PIPE should return a Tree."

# Fixture for analysis and reporting tests
@pytest.fixture(scope="module")
def pipe_result() -> AnalysisResult:
    # Analyze the fixture file containing PIPE statements
    return analyze_fixture_file(PIPE_FIXTURE)

# Analysis tests for PIPE

def test_analyze_create_pipe(pipe_result):
    assert pipe_result.statement_counts.get('CREATE_PIPE', 0) == 1
    pipes = [o for o in pipe_result.objects_found if o.object_type == 'PIPE' and o.action == 'CREATE_PIPE']
    assert len(pipes) == 1 and pipes[0].name == 'my_pipe'


def test_analyze_pipe_params(pipe_result):
    # Check that AUTO_INGEST, AWS_SNS_TOPIC, and COMMENT parameters are recorded
    param_actions = {o.action for o in pipe_result.objects_found if o.object_type == 'PIPE'}
    assert 'AUTO_INGEST' in param_actions
    assert 'AWS_SNS_TOPIC' in param_actions
    assert 'COMMENT' in param_actions


def test_analyze_embedded_copy(pipe_result):
    # The embedded COPY INTO should record COPY_INTO_TABLE and references
    assert pipe_result.statement_counts.get('COPY_INTO_TABLE', 0) >= 1
    assert any(o for o in pipe_result.objects_found if o.object_type == 'TABLE' and o.action == 'COPY_INTO_TABLE' and o.name == 'my_table')
    # Check object_interactions for the COPY_FROM_STAGE action
    stage_interactions = pipe_result.object_interactions.get(('STAGE', '@my_stage'), set())
    assert 'COPY_FROM_STAGE' in stage_interactions
    assert any(o for o in pipe_result.objects_found if o.object_type == 'FILE_FORMAT' and o.action == 'REFERENCE' and o.name == 'fmt')


def test_analyze_alter_refresh_drop(pipe_result):
    # Ensure ALTER_PIPE, REFRESH, and DROP_PIPE statements are counted
    assert pipe_result.statement_counts.get('ALTER_PIPE', 0) == 1
    assert pipe_result.statement_counts.get('DROP_PIPE', 0) == 1
    # REFRESH is recorded as an action on the PIPE object
    assert any(o for o in pipe_result.objects_found if o.object_type == 'PIPE' and o.action == 'REFRESH')

# Reporting tests for PIPE

def test_text_formatter_pipe(pipe_result):
    report = text_formatter.format_text(pipe_result, verbose=True)
    # Statement summary should include PIPE DDL counts
    assert 'CREATE_PIPE: 1' in report
    assert 'ALTER_PIPE: 1' in report
    assert 'DROP_PIPE: 1' in report
    assert 'COPY_INTO_TABLE:' in report


def test_json_formatter_pipe(pipe_result):
    data = json_formatter.format_json(pipe_result)
    obj = json.loads(data)
    # Statement counts in JSON
    assert obj['statement_counts']['CREATE_PIPE'] == 1
    assert obj['statement_counts']['ALTER_PIPE'] == 1
    assert obj['statement_counts']['DROP_PIPE'] == 1
    # Ensure PIPE object appears in objects_found
    pipe_objs = [o for o in obj['objects_found'] if o['object_type'] == 'PIPE']
    assert any(o['action'] == 'CREATE_PIPE' for o in pipe_objs) 