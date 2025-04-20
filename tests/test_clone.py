import pytest
from lark import Tree
from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine

def analyze_sql(sql: str):
    tree = parse_sql(sql)
    engine = AnalysisEngine()
    return engine.analyze(tree)

@pytest.mark.parametrize("sql", [
    "CREATE TABLE new_tbl CLONE src_tbl;",
    "CREATE DATABASE new_db CLONE src_db;",
    "CREATE SCHEMA new_sch CLONE src_sch;"
])
def test_parse_clone_variants(sql):
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), f"Parsing clone SQL should return a Tree. SQL: {sql}"

@pytest.mark.parametrize("sql, stmt, source", [
    ("CREATE TABLE new_tbl CLONE src_tbl;", "CREATE_TABLE", "src_tbl"),
    ("CREATE DATABASE new_db CLONE src_db;", "CREATE_DATABASE", "src_db")
])
def test_analyze_clone_variants(sql, stmt, source):
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1, f"{stmt} count should be 1 for SQL: {sql}"
    assert any(o.action == "CLONE" and o.name == source for o in res.objects_found), f"CLONE action not recorded for source {source}" 