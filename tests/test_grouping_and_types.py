import pytest
from lark import Tree

from sql_analyzer.parser.core import parse_sql


def test_grouping_sets_rollup_cube():
    sql = (
        "SELECT region, product, SUM(sales) AS s "
        "FROM facts "
        "GROUP BY GROUPING SETS ((region, product), (region), ());"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_rollup():
    sql = (
        "SELECT region, product, SUM(sales) "
        "FROM facts "
        "GROUP BY ROLLUP (region, product);"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_grouping_functions_with_cube():
    sql = (
        "SELECT region, product, GROUPING(region) AS g_r, GROUPING_ID(region, product) AS gid, SUM(sales) "
        "FROM facts "
        "GROUP BY CUBE (region, product);"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)


def test_vector_and_geo_types():
    sql = (
        "CREATE TABLE items ("
        "id INT, "
        "embedding VECTOR(FLOAT, 768), "
        "g GEOGRAPHY, "
        "h GEOMETRY"
        ");"
    )
    tree = parse_sql(sql)
    assert isinstance(tree, Tree)
