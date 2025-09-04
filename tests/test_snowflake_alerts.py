import pytest
from lark import Tree, LarkError

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine


def analyze_sql(sql: str):
    tree = parse_sql(sql)
    engine = AnalysisEngine()
    return engine.analyze(tree)


def test_create_alert_with_definition():
    sql = (
        "CREATE ALERT my_alert WAREHOUSE = wh SCHEDULE = '1 minute' IF EXISTS (SELECT 1) THEN CALL my_proc();"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
    res = analyze_sql(sql)
    assert res.statement_counts.get("CREATE_ALERT", 0) == 1
    assert any(o.object_type == "WAREHOUSE" and o.name == "wh" for o in res.objects_found)
    assert any(o.object_type == "ALERT" and o.action == "SCHEDULE" and o.name == "my_alert" for o in res.objects_found)
    assert any(o.object_type == "PROCEDURE" and o.action == "CALL" and o.name == "my_proc" for o in res.objects_found)


def test_create_alert_clone():
    sql = "CREATE ALERT new_alert CLONE old_alert;"
    res = analyze_sql(sql)
    assert res.statement_counts.get("CREATE_ALERT", 0) == 1
    assert any(o.object_type == "ALERT" and o.action == "CLONE" and o.name == "old_alert" for o in res.objects_found)


def test_execute_and_describe_show_alert():
    assert isinstance(parse_sql("SHOW ALERTS;"), Tree)
    assert isinstance(parse_sql("DESC ALERT my_alert;"), Tree)
    res = analyze_sql("EXECUTE ALERT my_alert;")
    assert res.statement_counts.get("EXECUTE_ALERT", 0) == 1
    assert any(o.object_type == "ALERT" and o.action == "EXECUTE_ALERT" and o.name == "my_alert" for o in res.objects_found)


def test_alter_alert_set_warehouse():
    sql = "ALTER ALERT my_alert SET WAREHOUSE = wh2;"
    res = analyze_sql(sql)
    assert res.statement_counts.get("ALTER_ALERT", 0) == 1
    assert any(o.object_type == "WAREHOUSE" and o.name == "wh2" for o in res.objects_found)


# Negative tests

def test_invalid_create_alert_missing_schedule():
    with pytest.raises(LarkError):
        parse_sql("CREATE ALERT bad_alert WAREHOUSE = wh IF 1=1 THEN CALL proc();")


def test_invalid_execute_alert():
    with pytest.raises(LarkError):
        parse_sql("EXECUTE ALERT;")

