import pytest
from lark import Tree, LarkError

from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine


def analyze_sql(sql: str):
    tree = parse_sql(sql)
    engine = AnalysisEngine()
    return engine.analyze(tree)


def test_create_database_role_if_not_exists():
    sql = "CREATE DATABASE ROLE IF NOT EXISTS db_role1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_create_database_role_quoted():
    sql = 'CREATE DATABASE ROLE "MyRole";'
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_create_application_role_if_not_exists():
    sql = "CREATE APPLICATION ROLE IF NOT EXISTS app_role1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_create_application_role_quoted():
    sql = 'CREATE APPLICATION ROLE "AppRole";'
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_analyze_database_role_actions():
    res = analyze_sql("CREATE DATABASE ROLE db_role1;")
    assert res.statement_counts.get("CREATE_DATABASE_ROLE", 0) == 1
    assert any(o.action == "CREATE_DATABASE_ROLE" and o.name == "db_role1" for o in res.objects_found)

    res = analyze_sql("ALTER DATABASE ROLE db_role1 RENAME TO db_role2;")
    assert res.statement_counts.get("ALTER_DATABASE_ROLE", 0) == 1
    assert any(o.action == "ALTER_DATABASE_ROLE" and o.name == "db_role1" for o in res.objects_found)

    res = analyze_sql("DROP DATABASE ROLE db_role2;")
    assert res.statement_counts.get("DROP_DATABASE_ROLE", 0) == 1
    assert any(o.action == "DROP_DATABASE_ROLE" and o.name == "db_role2" for o in res.objects_found)

    res = analyze_sql("GRANT DATABASE ROLE db_role2 TO ROLE role1;")
    assert res.statement_counts.get("GRANT_DATABASE_ROLE", 0) == 1
    assert any(
        o.object_type == "DATABASE_ROLE" and o.action == "GRANT_DATABASE_ROLE" and o.name == "db_role2"
        for o in res.objects_found
    )
    assert any(
        o.object_type == "ROLE" and o.action == "GRANT_DATABASE_ROLE" and o.name == "role1"
        for o in res.objects_found
    )

    res = analyze_sql("REVOKE DATABASE ROLE db_role2 FROM ROLE role1;")
    assert res.statement_counts.get("REVOKE_DATABASE_ROLE", 0) == 1
    assert any(
        o.object_type == "DATABASE_ROLE" and o.action == "REVOKE_DATABASE_ROLE" and o.name == "db_role2"
        for o in res.objects_found
    )
    assert any(
        o.object_type == "ROLE" and o.action == "REVOKE_DATABASE_ROLE" and o.name == "role1"
        for o in res.objects_found
    )

    res = analyze_sql("CREATE APPLICATION ROLE app_role1;")
    assert res.statement_counts.get("CREATE_APPLICATION_ROLE", 0) == 1
    assert any(o.action == "CREATE_APPLICATION_ROLE" and o.name == "app_role1" for o in res.objects_found)

    res = analyze_sql("ALTER APPLICATION ROLE app_role1 RENAME TO app_role2;")
    assert res.statement_counts.get("ALTER_APPLICATION_ROLE", 0) == 1
    assert any(o.action == "ALTER_APPLICATION_ROLE" and o.name == "app_role1" for o in res.objects_found)

    res = analyze_sql("DROP APPLICATION ROLE app_role2;")
    assert res.statement_counts.get("DROP_APPLICATION_ROLE", 0) == 1
    assert any(o.action == "DROP_APPLICATION_ROLE" and o.name == "app_role2" for o in res.objects_found)

    res = analyze_sql("GRANT APPLICATION ROLE app_role2 TO ROLE role1;")
    assert res.statement_counts.get("GRANT_APPLICATION_ROLE", 0) == 1
    assert any(
        o.object_type == "APPLICATION_ROLE" and o.action == "GRANT_APPLICATION_ROLE" and o.name == "app_role2"
        for o in res.objects_found
    )
    assert any(
        o.object_type == "ROLE" and o.action == "GRANT_APPLICATION_ROLE" and o.name == "role1"
        for o in res.objects_found
    )

    res = analyze_sql("REVOKE APPLICATION ROLE app_role2 FROM ROLE role1;")
    assert res.statement_counts.get("REVOKE_APPLICATION_ROLE", 0) == 1
    assert any(
        o.object_type == "APPLICATION_ROLE" and o.action == "REVOKE_APPLICATION_ROLE" and o.name == "app_role2"
        for o in res.objects_found
    )
    assert any(
        o.object_type == "ROLE" and o.action == "REVOKE_APPLICATION_ROLE" and o.name == "role1"
        for o in res.objects_found
    )


def test_show_database_roles():
    tree = parse_sql("SHOW DATABASE ROLES;")
    assert isinstance(tree, Tree)


def test_show_application_roles():
    tree = parse_sql("SHOW APPLICATION ROLES;")
    assert isinstance(tree, Tree)


# Negative tests


def test_invalid_create_database_role():
    with pytest.raises(LarkError):
        parse_sql("CREATE DATABASE ROLE IF NOT EXISTS;")


def test_invalid_alter_database_role():
    with pytest.raises(LarkError):
        parse_sql("ALTER DATABASE ROLE;")


def test_invalid_drop_database_role():
    with pytest.raises(LarkError):
        parse_sql("DROP DATABASE ROLE IF EXISTS;")


def test_invalid_grant_database_role():
    with pytest.raises(LarkError):
        parse_sql("GRANT DATABASE ROLE db_role TO r1;")


def test_invalid_revoke_database_role():
    with pytest.raises(LarkError):
        parse_sql("REVOKE DATABASE ROLE db_role FROM r1;")


def test_invalid_create_application_role():
    with pytest.raises(LarkError):
        parse_sql("CREATE APPLICATION ROLE IF NOT EXISTS;")


def test_invalid_alter_application_role():
    with pytest.raises(LarkError):
        parse_sql("ALTER APPLICATION ROLE;")


def test_invalid_drop_application_role():
    with pytest.raises(LarkError):
        parse_sql("DROP APPLICATION ROLE IF EXISTS;")


def test_invalid_grant_application_role():
    with pytest.raises(LarkError):
        parse_sql("GRANT APPLICATION ROLE app_role TO r1;")


def test_invalid_revoke_application_role():
    with pytest.raises(LarkError):
        parse_sql("REVOKE APPLICATION ROLE app_role FROM r1;")

