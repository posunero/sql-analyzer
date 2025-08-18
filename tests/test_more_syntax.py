import pytest
from lark import Tree

from sql_analyzer.parser.core import parse_sql


def test_asof_join():
    sql = (
        "SELECT * FROM a ASOF JOIN b ON a.id = b.id AND a.ts < b.ts;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)

    sql_order = (
        "SELECT * FROM a ASOF JOIN b ON a.k = b.k AND a.ts <= b.ts ORDER BY a.ts;"
    )
    tree = parse_sql(sql_order)
    assert isinstance(tree, Tree)


def test_natural_directed_join_and_using():
    sql = (
        "SELECT * FROM a NATURAL LEFT JOIN b;"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)

    sql_directed = (
        "SELECT * FROM a INNER DIRECTED JOIN b ON a.id = b.id;"
    )
    tree = parse_sql(sql_directed)
    assert isinstance(tree, Tree)

    sql_using = (
        "SELECT * FROM a INNER JOIN b USING (id, org_id);"
    )
    tree = parse_sql(sql_using)
    assert isinstance(tree, Tree)


def test_lateral_table_function_named_args():
    sql = (
        "SELECT * FROM LATERAL TABLE(FLATTEN(INPUT => arr));"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_values_table_with_dollar_refs():
    sql = (
        "SELECT $1, $2 FROM (VALUES (1, 2), (3, 4)) AS v(c1, c2);"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)

    sql_no_alias = "SELECT $1, $2 FROM (VALUES (10, 20));"
    tree = parse_sql(sql_no_alias)
    assert isinstance(tree, Tree)


def test_pivot_unpivot_and_qualify():
    sql_pivot = (
        "SELECT * FROM ("
        "    SELECT region, product, sales FROM facts"
        ") PIVOT(SUM(sales) FOR product IN ('a', 'b'));"
    )
    tree = parse_sql(sql_pivot)
    assert isinstance(tree, Tree)

    sql_pivot_alias = (
        "SELECT * FROM sales PIVOT(SUM(amount) FOR quarter IN ('Q1','Q2','Q3','Q4')) AS p;"
    )
    tree = parse_sql(sql_pivot_alias)
    assert isinstance(tree, Tree)

    sql_unpivot = (
        "SELECT * FROM inventory UNPIVOT(quantity FOR month IN (jan, feb));"
    )
    tree = parse_sql(sql_unpivot)
    assert isinstance(tree, Tree)

    sql_qualify = (
        "SELECT id FROM t QUALIFY ROW_NUMBER() OVER (ORDER BY id) = 1;"
    )
    tree = parse_sql(sql_qualify)
    assert isinstance(tree, Tree)


def test_sample_time_travel_and_limits():
    sql_sample = "SELECT * FROM t TABLESAMPLE BERNOULLI(50 PERCENT);"
    tree = parse_sql(sql_sample)
    assert isinstance(tree, Tree)

    sql_sample_repeat = "SELECT * FROM t SAMPLE SYSTEM(10 ROWS) REPEATABLE (42);"
    tree = parse_sql(sql_sample_repeat)
    assert isinstance(tree, Tree)

    sql_sample_system = "SELECT * FROM big_table TABLESAMPLE SYSTEM (1);"
    tree = parse_sql(sql_sample_system)
    assert isinstance(tree, Tree)

    sql_time_travel = (
        "SELECT * FROM mytable AT (TIMESTAMP => TO_TIMESTAMP(0));"
    )
    tree = parse_sql(sql_time_travel)
    assert isinstance(tree, Tree)

    sql_time_travel_before = (
        "SELECT * FROM mytable BEFORE (OFFSET => 5);"
    )
    tree = parse_sql(sql_time_travel_before)
    assert isinstance(tree, Tree)

    sql_time_travel_changes = (
        "SELECT * FROM mytable CHANGES (INFORMATION => 10);"
    )
    tree = parse_sql(sql_time_travel_changes)
    assert isinstance(tree, Tree)

    sql_top = "SELECT TOP 5 * FROM t;"
    tree = parse_sql(sql_top)
    assert isinstance(tree, Tree)

    sql_top_ties = "SELECT TOP 10 WITH TIES * FROM t ORDER BY score DESC;"
    tree = parse_sql(sql_top_ties)
    assert isinstance(tree, Tree)

    sql_fetch = "SELECT * FROM t ORDER BY id FETCH NEXT 5 ROWS ONLY;"
    tree = parse_sql(sql_fetch)
    assert isinstance(tree, Tree)

    sql_fetch_ties = "SELECT * FROM t ORDER BY price DESC FETCH NEXT 3 ROWS WITH TIES;"
    tree = parse_sql(sql_fetch_ties)
    assert isinstance(tree, Tree)

    sql_for_update = "SELECT * FROM t FOR UPDATE;"
    tree = parse_sql(sql_for_update)
    assert isinstance(tree, Tree)


def test_hierarchical_and_semantic_view():
    sql_hierarchical = (
        "SELECT LEVEL, CONNECT_BY_ROOT id, SYS_CONNECT_BY_PATH(id, '/') AS path "
        "FROM employees START WITH id = 1 CONNECT BY PRIOR id = manager_id;"
    )
    tree = parse_sql(sql_hierarchical)
    assert isinstance(tree, Tree)

    sql_create_sem_view = "CREATE SEMANTIC VIEW my_sem_view AS SELECT 1;"
    tree = parse_sql(sql_create_sem_view)
    assert isinstance(tree, Tree)

    sql_query_sem_view = "SELECT * FROM SEMANTIC_VIEW(my_sem_view);"
    tree = parse_sql(sql_query_sem_view)
    assert isinstance(tree, Tree)


def test_window_frames_and_match_recognize():
    sql_rows_between = (
        "SELECT SUM(x) OVER (ORDER BY ts ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM t;"
    )
    tree = parse_sql(sql_rows_between)
    assert isinstance(tree, Tree)

    sql_groups_preceding = (
        "SELECT SUM(x) OVER (PARTITION BY g ORDER BY ts GROUPS 1 PRECEDING) FROM t;"
    )
    tree = parse_sql(sql_groups_preceding)
    assert isinstance(tree, Tree)

    sql_exclude = (
        "SELECT SUM(x) OVER (ORDER BY ts RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING EXCLUDE CURRENT ROW) FROM t;"
    )
    tree = parse_sql(sql_exclude)
    assert isinstance(tree, Tree)

    sql_match_recognize = (
        "SELECT * FROM s MATCH_RECOGNIZE ("
        "PARTITION BY id "
        "ORDER BY ts "
        "MEASURES FIRST(val) AS start_val, LAST(val) AS end_val "
        "ONE ROW PER MATCH "
        "AFTER MATCH SKIP TO NEXT ROW "
        "PATTERN (start change*) "
        "DEFINE change AS val <> LAG(val)"
        ");"
    )
    tree = parse_sql(sql_match_recognize)
    assert isinstance(tree, Tree)

    sql_match_recognize_all = (
        "SELECT * FROM s MATCH_RECOGNIZE ("
        "PARTITION BY id ORDER BY ts "
        "ALL ROWS PER MATCH "
        "AFTER MATCH SKIP TO NEXT ROW "
        "PATTERN (A B+) "
        "DEFINE A AS val > 0, B AS val <= 0"
        ");"
    )
    tree = parse_sql(sql_match_recognize_all)
    assert isinstance(tree, Tree)
