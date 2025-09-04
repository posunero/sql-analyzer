import pytest
from lark import Tree, LarkError

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine


def analyze_sql(sql: str):
    tree = parse_sql(sql)
    engine = AnalysisEngine()
    return engine.analyze(tree)


def test_create_notification_integrations():
    sql_email = (
        "CREATE NOTIFICATION INTEGRATION email_int TYPE = EMAIL "
        "DIRECTION = OUTBOUND ENABLED = TRUE "
        "NOTIFICATION_PROVIDER = AWS_SES;"
    )
    res = analyze_sql(sql_email)
    assert res.statement_counts.get("CREATE_INTEGRATION", 0) == 1
    assert any(o.action == "CREATE_INTEGRATION" and o.name == "email_int" for o in res.objects_found)
    assert any(o.action == "TYPE" and o.name == "email_int" for o in res.objects_found)
    assert any(o.action == "DIRECTION" and o.name == "email_int" for o in res.objects_found)
    assert any(o.action == "ENABLED" and o.name == "email_int" for o in res.objects_found)
    assert any(o.action == "PROVIDER" and o.name == "email_int" for o in res.objects_found)

    sql_queue = (
        "CREATE NOTIFICATION INTEGRATION queue_int TYPE = QUEUE "
        "DIRECTION = OUTBOUND ENABLED = FALSE "
        "NOTIFICATION_PROVIDER = AWS_SQS;"
    )
    tree = parse_sql(sql_queue)
    assert isinstance(tree, Tree)

    sql_webhook = (
        "CREATE NOTIFICATION INTEGRATION webhook_int TYPE = WEBHOOK "
        "DIRECTION = INBOUND ENABLED = TRUE "
        "NOTIFICATION_PROVIDER = CUSTOM;"
    )
    tree = parse_sql(sql_webhook)
    assert isinstance(tree, Tree)


def test_alter_notification_integration():
    sql = (
        "ALTER INTEGRATION email_int SET ENABLED = FALSE DIRECTION = INBOUND;"
    )
    res = analyze_sql(sql)
    assert res.statement_counts.get("ALTER_INTEGRATION", 0) == 1
    assert any(o.action == "ALTER_INTEGRATION" and o.name == "email_int" for o in res.objects_found)
    assert any(o.action == "ENABLED" and o.name == "email_int" for o in res.objects_found)
    assert any(o.action == "DIRECTION" and o.name == "email_int" for o in res.objects_found)


def test_invalid_notification_integration_direction():
    with pytest.raises(LarkError):
        parse_sql(
            "CREATE NOTIFICATION INTEGRATION bad_int TYPE = EMAIL DIRECTION = SIDEWAYS;"
        )

