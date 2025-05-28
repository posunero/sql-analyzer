import pytest
from lark import Tree
from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine
from typing import Any

# Helper for analysis

def analyze_sql(sql: str) -> Any:
    tree = parse_sql(sql)
    if tree is None:
        raise ValueError("Failed to parse SQL")
    engine = AnalysisEngine()
    return engine.analyze(tree)

# --- CLONE Tests ---
@pytest.mark.parametrize("sql, stmt, source", [
    ("CREATE TABLE new_tbl CLONE src_tbl;", "CREATE_TABLE", "src_tbl"),
    ("CREATE DATABASE new_db CLONE src_db;", "CREATE_DATABASE", "src_db"),
    ("CREATE SCHEMA new_sch CLONE src_sch;", "CREATE_SCHEMA", "src_sch"),
])
def test_clone_parsing_and_analysis(sql: str, stmt: str, source: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == "CLONE" and o.name == source for o in res.objects_found)

# --- SHARE Tests ---
@pytest.mark.parametrize("sql, stmt", [
    ("CREATE SHARE my_share;", "CREATE_SHARE"),
    ("CREATE OR REPLACE SHARE IF NOT EXISTS my_share;", "CREATE_SHARE"),
])
def test_share_create(sql: str, stmt: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == "my_share" for o in res.objects_found)

@pytest.mark.parametrize("sql", [
    "ALTER SHARE my_share ADD DATA;",
    "ALTER SHARE my_share DROP DATA;"
])
def test_share_alter(sql: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get("ALTER_SHARE", 0) == 1
    assert any(o.action == "ALTER_SHARE" and o.name == "my_share" for o in res.objects_found)

def test_share_drop() -> None:
    sql = "DROP SHARE my_share;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    print(f"Tree: {tree.pretty()}")
    print(f"RES: {res}")
    print(f"RES.statement_counts: {res.statement_counts}")
    assert res.statement_counts.get("DROP_SHARE", 0) == 1
    assert any(o.action == "DROP_SHARE" and o.name == "my_share" for o in res.objects_found)

# --- INTEGRATION Tests ---
@pytest.mark.parametrize("sql, stmt", [
    ("CREATE INTEGRATION my_int;", "CREATE_INTEGRATION"),
    ("CREATE OR REPLACE INTEGRATION IF NOT EXISTS my_int;", "CREATE_INTEGRATION"),
])
def test_integration_create(sql: str, stmt: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == "my_int" for o in res.objects_found)

@pytest.mark.parametrize("sql", [
    "ALTER INTEGRATION my_int;",
    "ALTER INTEGRATION my_int TYPE = 'X';"
])
def test_integration_alter(sql: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get("ALTER_INTEGRATION", 0) == 1
    assert any(o.action == "ALTER_INTEGRATION" and o.name == "my_int" for o in res.objects_found)

def test_integration_drop() -> None:
    sql = "DROP INTEGRATION my_int;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get("DROP_INTEGRATION", 0) == 1
    assert any(o.action == "DROP_INTEGRATION" and o.name == "my_int" for o in res.objects_found)

# --- EXTERNAL TABLE Tests ---
@pytest.mark.parametrize("stmt, name", [
    ("CREATE EXTERNAL TABLE ext.tbl1;", "ext.tbl1"),
    ("ALTER EXTERNAL TABLE ext.tbl1;", "ext.tbl1"),
    ("DROP EXTERNAL TABLE ext.tbl1;", "ext.tbl1"),
])
def test_external_table(stmt: str, name: str) -> None:
    tree = parse_sql(stmt)
    assert isinstance(tree, Tree)
    res = analyze_sql(stmt)
    action = stmt.split()[0] + "_EXTERNAL_TABLE"
    assert res.statement_counts.get(action, 0) == 1
    assert any(o.action == action and o.name == name for o in res.objects_found)

# --- MATERIALIZED VIEW Tests ---
@pytest.mark.parametrize("sql, stmt, name", [
    ("CREATE MATERIALIZED VIEW mv1 AS SELECT c1 FROM t1;", "CREATE_MATERIALIZED_VIEW", "mv1"),
    ("CREATE OR REPLACE MATERIALIZED VIEW IF NOT EXISTS mv2 AS SELECT * FROM t2;", "CREATE_MATERIALIZED_VIEW", "mv2"),
])
def test_mview_create(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)

@pytest.mark.parametrize("sql, stmt, name", [
    ("ALTER MATERIALIZED VIEW mv1;", "ALTER_MATERIALIZED_VIEW", "mv1"),
    ("DROP MATERIALIZED VIEW mv1;", "DROP_MATERIALIZED_VIEW", "mv1"),
])
def test_mview_alter_drop(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)

# --- EXTERNAL FUNCTION Tests ---
@pytest.mark.parametrize("sql, stmt, name", [
    ("CREATE EXTERNAL FUNCTION ef1;", "CREATE_EXTERNAL_FUNCTION", "ef1"),
    ("ALTER EXTERNAL FUNCTION ef1;", "ALTER_EXTERNAL_FUNCTION", "ef1"),
    ("DROP EXTERNAL FUNCTION ef1;", "DROP_EXTERNAL_FUNCTION", "ef1"),
])
def test_efunc(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)

# --- NETWORK POLICY Tests ---
@pytest.mark.parametrize("sql, stmt, name", [
    ("CREATE NETWORK POLICY np1;", "CREATE_NETWORK_POLICY", "np1"),
    ("ALTER NETWORK POLICY np1;", "ALTER_NETWORK_POLICY", "np1"),
    ("DROP NETWORK POLICY np1;", "DROP_NETWORK_POLICY", "np1"),
])
def test_network_policy(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)

# --- REPLICATION Tests ---
@pytest.mark.parametrize("sql, stmt, name", [
    ("CREATE REPLICATION rep1;", "CREATE_REPLICATION", "rep1"),
    ("CREATE OR REPLACE REPLICATION IF NOT EXISTS rep2;", "CREATE_REPLICATION", "rep2"),
])
def test_replication_create(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)

@pytest.mark.parametrize("sql", [
    "ALTER REPLICATION rep1;",
    "ALTER REPLICATION rep2;"
])
def test_replication_alter(sql: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get("ALTER_REPLICATION", 0) == 1
    assert any(o.action == "ALTER_REPLICATION" and o.name.startswith("rep") for o in res.objects_found)

# --- ACCOUNT-Level Tests ---
@pytest.mark.parametrize("sql, stmt, name", [
    ("CREATE ACCOUNT acc1;", "CREATE_ACCOUNT", "acc1"),
    ("CREATE OR REPLACE ACCOUNT IF NOT EXISTS acc2;", "CREATE_ACCOUNT", "acc2"),
])
def test_account_create(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)

@pytest.mark.parametrize("sql, stmt, name", [
    ("ALTER ACCOUNT acc1;", "ALTER_ACCOUNT", "acc1"),
    ("DROP ACCOUNT acc1;", "DROP_ACCOUNT", "acc1"),
])
def test_account_alter_and_drop(sql: str, stmt: str, name: str) -> None:
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get(stmt, 0) == 1
    assert any(o.action == stmt and o.name == name for o in res.objects_found)


def test_account_show() -> None:
    tree = parse_sql("SHOW ACCOUNTS;")
    assert isinstance(tree, Tree)
    res = analyze_sql("SHOW ACCOUNTS;")
    assert res.statement_counts.get("SHOW_ACCOUNTS", 0) == 1
