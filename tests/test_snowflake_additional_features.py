import pytest
from lark import Tree
from sql_analyzer.parser.core import parse_sql
from sql_analyzer.analysis.engine import AnalysisEngine


def analyze_sql(sql: str):
    tree = parse_sql(sql)
    engine = AnalysisEngine()
    return engine.analyze(tree)

# Machine Learning Operations

def test_parse_ml_predict():
    sql = "SELECT ML.PREDICT(model => my_model, input => my_table);"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ML.PREDICT should return a Tree."


def test_parse_ml_train():
    sql = "SELECT ML.TRAIN(input_table => training_data, model => new_model);"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ML.TRAIN should return a Tree."


def test_analyze_ml_predict():
    sql = "SELECT ML.PREDICT(model => my_model, input => my_table);"
    result = analyze_sql(sql)
    assert result.statement_counts.get('ML_PREDICT', 0) == 1
    objs = [o for o in result.objects_found if o.action == 'ML_PREDICT']
    assert any(o.name == 'my_model' for o in objs)
    assert any(o.name == 'my_table' for o in objs)


def test_analyze_ml_train():
    sql = "SELECT ML.TRAIN(input_table => training_data, model => new_model);"
    result = analyze_sql(sql)
    assert result.statement_counts.get('ML_TRAIN', 0) == 1
    objs = [o for o in result.objects_found if o.action == 'ML_TRAIN']
    assert any(o.name == 'new_model' for o in objs)
    assert any(o.name == 'training_data' for o in objs)

# Apache Iceberg Table Support

def test_parse_create_iceberg_table():
    sql = "CREATE ICEBERG TABLE schema1.tbl1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE ICEBERG TABLE should return a Tree."


def test_parse_alter_iceberg_table():
    sql = "ALTER ICEBERG TABLE tbl2;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER ICEBERG TABLE should return a Tree."


def test_parse_drop_iceberg_table():
    sql = "DROP ICEBERG TABLE tbl3;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DROP ICEBERG TABLE should return a Tree."


def test_analyze_iceberg_table_statements():
    # CREATE
    res = analyze_sql("CREATE ICEBERG TABLE tbl1;")
    assert res.statement_counts.get('CREATE_ICEBERG_TABLE', 0) == 1
    assert any(o.action == 'CREATE_ICEBERG_TABLE' and o.name == 'tbl1' for o in res.objects_found)
    # ALTER
    res = analyze_sql("ALTER ICEBERG TABLE tbl2;")
    assert res.statement_counts.get('ALTER_ICEBERG_TABLE', 0) == 1
    assert any(o.action == 'ALTER_ICEBERG_TABLE' and o.name == 'tbl2' for o in res.objects_found)
    # DROP
    res = analyze_sql("DROP ICEBERG TABLE tbl3;")
    assert res.statement_counts.get('DROP_ICEBERG_TABLE', 0) == 1
    assert any(o.action == 'DROP_ICEBERG_TABLE' and o.name == 'tbl3' for o in res.objects_found)

# Snowpark Container Services (Package Management)

def test_parse_create_package():
    sql = "CREATE PACKAGE pkg1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE PACKAGE should return a Tree."


def test_parse_install_package():
    sql = "INSTALL PACKAGE pkg2;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing INSTALL PACKAGE should return a Tree."


def test_parse_remove_package():
    sql = "REMOVE PACKAGE pkg3;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing REMOVE PACKAGE should return a Tree."


def test_analyze_package_statements():
    res = analyze_sql("CREATE PACKAGE pkg1;")
    assert res.statement_counts.get('CREATE_PACKAGE', 0) == 1
    assert any(o.action == 'CREATE_PACKAGE' and o.name == 'pkg1' for o in res.objects_found)
    res = analyze_sql("INSTALL PACKAGE pkg2;")
    assert res.statement_counts.get('INSTALL_PACKAGE', 0) == 1
    assert any(o.action == 'INSTALL_PACKAGE' and o.name == 'pkg2' for o in res.objects_found)
    res = analyze_sql("REMOVE PACKAGE pkg3;")
    assert res.statement_counts.get('REMOVE_PACKAGE', 0) == 1
    assert any(o.action == 'REMOVE_PACKAGE' and o.name == 'pkg3' for o in res.objects_found)

# Advanced Monitoring & Alerting

def test_parse_create_alert():
    sql = "CREATE ALERT alert1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE ALERT should return a Tree."


def test_parse_alter_alert():
    sql = "ALTER ALERT alert2;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER ALERT should return a Tree."


def test_parse_drop_alert():
    sql = "DROP ALERT alert3;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DROP ALERT should return a Tree."


def test_analyze_alert_statements():
    res = analyze_sql("CREATE ALERT alert1;")
    assert res.statement_counts.get('CREATE_ALERT', 0) == 1
    assert any(o.action == 'CREATE_ALERT' and o.name == 'alert1' for o in res.objects_found)
    res = analyze_sql("ALTER ALERT alert2;")
    assert res.statement_counts.get('ALTER_ALERT', 0) == 1
    assert any(o.action == 'ALTER_ALERT' and o.name == 'alert2' for o in res.objects_found)
    res = analyze_sql("DROP ALERT alert3;")
    assert res.statement_counts.get('DROP_ALERT', 0) == 1
    assert any(o.action == 'DROP_ALERT' and o.name == 'alert3' for o in res.objects_found)

# Row Access Policies

def test_parse_alter_row_access_policy():
    sql = "ALTER ROW ACCESS POLICY rap1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER ROW ACCESS POLICY should return a Tree."


def test_parse_drop_row_access_policy():
    sql = "DROP ROW ACCESS POLICY rap2;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DROP ROW ACCESS POLICY should return a Tree."


def test_analyze_row_access_policy_statements():
    res = analyze_sql("CREATE ROW ACCESS POLICY rap3 AS (id INT) RETURNS BOOLEAN -> TRUE;")
    assert res.statement_counts.get('CREATE_ROW_ACCESS_POLICY', 0) == 1
    assert any(o.action == 'CREATE_ROW_ACCESS_POLICY' and o.name == 'rap3' for o in res.objects_found)
    res = analyze_sql("ALTER ROW ACCESS POLICY rap1;")
    assert res.statement_counts.get('ALTER_ROW_ACCESS_POLICY', 0) == 1
    assert any(o.action == 'ALTER_ROW_ACCESS_POLICY' and o.name == 'rap1' for o in res.objects_found)
    res = analyze_sql("DROP ROW ACCESS POLICY rap2;")
    assert res.statement_counts.get('DROP_ROW_ACCESS_POLICY', 0) == 1
    assert any(o.action == 'DROP_ROW_ACCESS_POLICY' and o.name == 'rap2' for o in res.objects_found)

# Column-Level Security & Dynamic Data Masking

def test_parse_alter_table_set_masking_policy():
    sql = "ALTER TABLE t1 MODIFY COLUMN col1 SET MASKING POLICY mask1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER TABLE SET MASKING POLICY should return a Tree."


def test_analyze_masking_policy_statements():
    res = analyze_sql("CREATE MASKING POLICY mp1 AS (val STRING) RETURNS STRING -> val;")
    assert res.statement_counts.get('CREATE_MASKING_POLICY', 0) == 1
    assert any(o.action == 'CREATE_MASKING_POLICY' and o.name == 'mp1' for o in res.objects_found)
    res = analyze_sql("ALTER TABLE t1 MODIFY COLUMN col1 SET MASKING POLICY mp1;")
    assert res.statement_counts.get('SET_MASKING_POLICY', 0) == 1
    assert any(o.object_type == 'COLUMN' and o.action == 'SET_MASKING_POLICY' and o.name == 'col1' for o in res.objects_found)
    assert any(o.object_type == 'MASKING_POLICY' and o.action == 'SET_MASKING_POLICY' and o.name == 'mp1' for o in res.objects_found)

# Authentication Policies

def test_parse_create_authentication_policy():
    sql = "CREATE AUTHENTICATION POLICY ap1;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE AUTHENTICATION POLICY should return a Tree."


def test_parse_alter_authentication_policy():
    sql = "ALTER AUTHENTICATION POLICY ap2;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing ALTER AUTHENTICATION POLICY should return a Tree."


def test_parse_drop_authentication_policy():
    sql = "DROP AUTHENTICATION POLICY ap3;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing DROP AUTHENTICATION POLICY should return a Tree."


def test_analyze_authentication_policy_statements():
    res = analyze_sql("CREATE AUTHENTICATION POLICY ap1;")
    assert res.statement_counts.get('CREATE_AUTHENTICATION_POLICY', 0) == 1
    assert any(o.action == 'CREATE_AUTHENTICATION_POLICY' and o.name == 'ap1' for o in res.objects_found)
    res = analyze_sql("ALTER AUTHENTICATION POLICY ap2;")
    assert res.statement_counts.get('ALTER_AUTHENTICATION_POLICY', 0) == 1
    assert any(o.action == 'ALTER_AUTHENTICATION_POLICY' and o.name == 'ap2' for o in res.objects_found)
    res = analyze_sql("DROP AUTHENTICATION POLICY ap3;")
    assert res.statement_counts.get('DROP_AUTHENTICATION_POLICY', 0) == 1
    assert any(o.action == 'DROP_AUTHENTICATION_POLICY' and o.name == 'ap3' for o in res.objects_found)

# Resource Monitor Tests

def test_parse_create_resource_monitor_basic():
    sql = "CREATE RESOURCE MONITOR rm1 WITH CREDIT_QUOTA = 100 TRIGGERS ON 80 PERCENT DO NOTIFY;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE RESOURCE MONITOR should return a Tree."


def test_parse_create_resource_monitor_or_replace():
    sql = "CREATE OR REPLACE RESOURCE MONITOR rm2 WITH CREDIT_QUOTA = 200 TRIGGERS ON 90 PERCENT DO NOTIFY ON 95 PERCENT DO NOTIFY;"
    tree = parse_sql(sql)
    assert isinstance(tree, Tree), "Parsing CREATE OR REPLACE RESOURCE MONITOR with multiple triggers should return a Tree."


def test_analyze_create_resource_monitor_basic():
    res = analyze_sql("CREATE RESOURCE MONITOR rm3 WITH CREDIT_QUOTA = 150 TRIGGERS ON 85 PERCENT DO NOTIFY;")
    assert res.statement_counts.get('CREATE_RESOURCE_MONITOR', 0) == 1
    assert any(o.action == 'CREATE_RESOURCE_MONITOR' and o.name == 'rm3' for o in res.objects_found)


def test_analyze_create_resource_monitor_or_replace():
    res = analyze_sql("CREATE OR REPLACE RESOURCE MONITOR rm4 WITH CREDIT_QUOTA = 250 TRIGGERS ON 90 PERCENT DO NOTIFY ON 95 PERCENT DO NOTIFY;")
    assert res.statement_counts.get('CREATE_RESOURCE_MONITOR', 0) == 1
    assert any(o.action == 'CREATE_RESOURCE_MONITOR' and o.name == 'rm4' for o in res.objects_found) 