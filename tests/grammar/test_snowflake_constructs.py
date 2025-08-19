import pytest
from sql_analyzer.parser.core import parse_sql


class TestSnowflakeQualifyGrammar:
    def test_qualify_clause_basic(self):
        """QUALIFY after SELECT with window function and followed by ORDER/LIMIT."""
        sql = """
        SELECT col1, ROW_NUMBER() OVER (PARTITION BY col2 ORDER BY col3) AS rn
        FROM t
        QUALIFY rn = 1
        ORDER BY col1
        LIMIT 10;
        """
        tree = parse_sql(sql)
        assert tree is not None

class TestSnowflakeSampleTablesampleGrammar:
    def test_sample_tablesample_variants(self):
        """SAMPLE/TABLESAMPLE with optional method and unit variants."""
        stmts = [
            "SELECT * FROM t SAMPLE (10);",
            "SELECT * FROM t TABLESAMPLE (10 PERCENT);",
            "SELECT * FROM t SAMPLE BERNOULLI (5 ROWS);",
            "SELECT * FROM t TABLESAMPLE SYSTEM (0.1);",
        ]
        for sql in stmts:
            tree = parse_sql(sql)
            assert tree is not None


class TestSnowflakePivotUnpivotGrammar:
    def test_pivot_unpivot_minimal(self):
        """Minimal PIVOT and UNPIVOT forms after a base table reference."""
        sqls = [
            # Simplified pivot: aggregate function, FOR expr, IN list
            """
            SELECT *
            FROM sales PIVOT (SUM(amount) FOR month IN (1,2,3));
            """,
            # Simplified unpivot: expr FOR identifier IN list
            """
            SELECT *
            FROM inventory UNPIVOT (qty FOR m IN (jan,feb,mar));
            """,
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None


class TestSnowflakeWindowFrameGrammar:
    def test_window_frame_rows_and_range(self):
        """Window frame with ROWS and RANGE using BETWEEN ... AND ... bounds."""
        sqls = [
            """
            SELECT SUM(x) OVER (PARTITION BY a ORDER BY b ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
            FROM t;
            """,
            """
            SELECT SUM(x) OVER (ORDER BY b RANGE BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING)
            FROM t;
            """,
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

class TestSnowflakeExceptionHandling:
    """Test exception handling in various block contexts"""
    
    def test_declare_block_with_exception_handling(self):
        """Test DECLARE block with exception handling"""
        sql = """
        DECLARE
          RESULT VARCHAR;
          EXCEPTION_1 EXCEPTION (-20001, 'I caught the expected exception.');
          EXCEPTION_2 EXCEPTION (-20002, 'Not the expected exception!');
        BEGIN
          RESULT := 'If you see this, I did not catch any exception.';
          IF (TRUE) THEN
            RAISE EXCEPTION_1;
          END IF;
          RETURN RESULT;
        EXCEPTION
          WHEN EXCEPTION_2 THEN
            RETURN SQLERRM;
          WHEN EXCEPTION_1 THEN
            RETURN SQLERRM;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_anonymous_block_with_exception_handling(self):
        """Test anonymous BEGIN block with exception handling"""
        sql = """
        BEGIN
          LET count := 1;
          IF (count < 0) THEN
            RETURN 'negative value';
          END IF;
        EXCEPTION
          WHEN EXCEPTION_1 THEN
            RETURN 'caught exception';
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeExecuteImmediate:
    """Test EXECUTE IMMEDIATE statements"""
    
    def test_execute_immediate_with_resultset(self):
        """Test EXECUTE IMMEDIATE with RESULTSET and USING clause"""
        sql = """
        DECLARE
          res RESULTSET;
          query VARCHAR DEFAULT 'SELECT a FROM IDENTIFIER(?) ORDER BY a;';
        BEGIN
          res := (EXECUTE IMMEDIATE :query USING(table_name));
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_execute_immediate_simple(self):
        """Test simple EXECUTE IMMEDIATE statement"""
        sql = """
        BEGIN
          EXECUTE IMMEDIATE 'SELECT 1';
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_execute_immediate_with_parameter(self):
        """Test EXECUTE IMMEDIATE with parameter"""
        sql = """
        BEGIN
          EXECUTE IMMEDIATE :dynamic_sql USING('test_value');
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeControlFlow:
    """Test control flow statements"""
    
    def test_if_statement_with_parentheses(self):
        """Test IF statement with parentheses around condition"""
        sql = """
        BEGIN
          LET count := 1;
          IF (count < 0) THEN
            RETURN 'negative value';
          END IF;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_if_statement_without_parentheses(self):
        """Test IF statement without parentheses around condition"""
        sql = """
        BEGIN
          LET count := 1;
          IF count < 0 THEN
            RETURN 'negative value';
          END IF;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_if_elseif_else_statement(self):
        """Test IF statement with ELSEIF and ELSE"""
        sql = """
        BEGIN
          LET status := 'active';
          IF status = 'active' THEN
            RETURN 'User is active';
          ELSEIF status = 'inactive' THEN
            RETURN 'User is inactive';
          ELSE
            RETURN 'Unknown status';
          END IF;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeApplicationPackage:
    """Test application package statements"""
    
    def test_alter_application_package_set_release_directive(self):
        """Test ALTER APPLICATION PACKAGE with release directive"""
        sql = """
        ALTER APPLICATION PACKAGE hello_snowflake_package
          SET DEFAULT RELEASE DIRECTIVE
          VERSION = 'v1_0'
          PATCH = '2'
          UPGRADE_AFTER = '2025-04-06 11:00:00';
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_alter_application_package_numeric_patch(self):
        """Test ALTER APPLICATION PACKAGE with numeric patch value"""
        sql = """
        ALTER APPLICATION PACKAGE my_package
          SET DEFAULT RELEASE DIRECTIVE
          VERSION = 'v2_0'
          PATCH = 5
          UPGRADE_AFTER = '2025-05-01 10:00:00';
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeReturnStatements:
    """Test various RETURN statement forms"""
    
    def test_return_simple_value(self):
        """Test simple RETURN statement"""
        sql = """
        BEGIN
          RETURN 'hello';
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_return_table_resultset(self):
        """Test RETURN TABLE statement"""
        sql = """
        BEGIN
          RETURN TABLE(res);
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_return_null(self):
        """Test RETURN NULL statement"""
        sql = """
        BEGIN
          RETURN NULL;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_return_expression(self):
        """Test RETURN with expression"""
        sql = """
        BEGIN
          LET result := 42;
          RETURN result * 2;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeProcedureWithReturnTable:
    """Test stored procedures with RETURN TABLE"""
    
    def test_create_procedure_with_return_table(self):
        """Test CREATE PROCEDURE with RETURNS TABLE and RETURN TABLE statement"""
        sql = """
        CREATE OR REPLACE PROCEDURE test_sp()
        RETURNS TABLE(a INTEGER)
        LANGUAGE SQL
        AS
          DECLARE
            res RESULTSET DEFAULT (SELECT a FROM t001 ORDER BY a);
          BEGIN
            RETURN TABLE(res);
          END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_procedure_with_complex_return_table(self):
        """Test procedure with complex RETURN TABLE"""
        sql = """
        CREATE OR REPLACE PROCEDURE get_user_data(user_id INTEGER)
        RETURNS TABLE(id INTEGER, name VARCHAR, email VARCHAR)
        LANGUAGE SQL
        AS
          DECLARE
            user_data RESULTSET;
          BEGIN
            user_data := (SELECT id, name, email FROM users WHERE id = user_id);
            RETURN TABLE(user_data);
          END;
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeDataTypes:
    """Tests for extended Snowflake data types"""

    def test_complex_data_types(self):
        sql = """
        CREATE TABLE t (
            v VARIANT,
            o OBJECT,
            a ARRAY(VARCHAR),
            tm TIME(3) TZ,
            d DATE,
            nt TIMESTAMP_NTZ(9),
            lt TIMESTAMP_LTZ,
            tz TIMESTAMP_TZ(6),
            g GEOGRAPHY
        );
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeGrantRevoke:
    """Tests for expanded GRANT/REVOKE statements"""

    def test_grant_and_revoke(self):
        stmts = [
            "GRANT SELECT ON TABLE mytable TO USER alice;",
            "GRANT USAGE ON PROCEDURE myproc(VARCHAR) TO APPLICATION ROLE app_role;",
            "REVOKE SELECT ON VIEW myview FROM SHARE shared_role;",
        ]
        for sql in stmts:
            tree = parse_sql(sql)
            assert tree is not None


class TestSnowflakeShowDescribe:
    """Tests for additional SHOW/DESCRIBE object kinds"""

    def test_show_describe_variants(self):
        sqls = [
            "SHOW FILE FORMATS;",
            "SHOW SEQUENCES;",
            "SHOW FUNCTIONS;",
            "SHOW PROCEDURES;",
            "SHOW NETWORK POLICIES;",
            "SHOW STORAGE INTEGRATIONS;",
            "SHOW NOTIFICATION INTEGRATIONS;",
            "DESCRIBE FILE FORMAT my_format;",
            "DESCRIBE NETWORK POLICY np1;",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None


class TestSnowflakeLoops:
    """Tests for LOOP, WHILE, and FOR constructs"""

    def test_loop_while_for(self):
        sqls = [
            """
            BEGIN
              LET i := 0;
              WHILE i < 5 DO
                i := i + 1;
              END WHILE;
            END;
            """,
            """
            BEGIN
              FOR r IN (SELECT 1) DO
                RETURN r;
              END FOR;
            END;
            """,
            """
            BEGIN
              LOOP
                RETURN 1;
              END LOOP;
            END;
            """,
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None


class TestSnowflakeTableFunctions:
    """Tests for FLATTEN and common table functions"""

    def test_flatten_and_functions(self):
        sqls = [
            """
            SELECT *
            FROM LATERAL FLATTEN(INPUT => PARSE_JSON(data), PATH => '$', OUTER => TRUE, RECURSIVE => FALSE);
            """,
            "SELECT OBJECT_KEYS(v) FROM t;",
            "SELECT ARRAY_SIZE(a) FROM t;",
            "SELECT * FROM RESULT_SCAN(LAST_QUERY_ID());",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None


class TestSnowflakeFeatureGaps:
    """Additional tests covering previously unsupported Snowflake features."""

    def test_variant_path_and_constructs(self):
        sqls = [
            "SELECT v:details.addresses[0].street FROM t;",
            "SELECT ARRAY_CONSTRUCT(1,2,3), OBJECT_CONSTRUCT('a',1) FROM t;",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

    def test_time_travel_and_clone(self):
        sqls = [
            "SELECT * FROM src AT (TIMESTAMP => '2024-01-01');",
            "CREATE TABLE new_tbl CLONE old_tbl AT (TIMESTAMP => '2024-01-01');",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

    def test_stage_file_format_and_copy(self):
        sqls = [
            "CREATE STAGE stg URL = 's3://bucket' FILE_FORMAT = (TYPE = 'CSV');",
            "CREATE FILE FORMAT fmt TYPE = 'CSV' FIELD_DELIMITER = ',';",
            "COPY INTO tgt FROM @stg FILE_FORMAT = (TYPE = 'CSV');",
            "CREATE STREAM s ON TABLE t APPEND_ONLY = TRUE SHOW_INITIAL_ROWS = FALSE;",
            "CREATE TASK tk WAREHOUSE = wh SCHEDULE = '5 MINUTE' AS SELECT 1;",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

    def test_security_policies_and_share(self):
        sqls = [
            "CREATE ROW ACCESS POLICY rap AS (r STRING) RETURNS BOOLEAN -> r='admin';",
            "CREATE MASKING POLICY mp AS (v STRING) RETURNS STRING -> v;",
            "CREATE SHARE shr;",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

    def test_functions_sampling_and_system(self):
        sqls = [
            "CREATE FUNCTION f() RETURNS STRING LANGUAGE SQL AS $$ SELECT 'x'; $$;",
            "SELECT * FROM t SAMPLE (10) REPEATABLE (1);",
            "SELECT CURRENT_ACCOUNT();",
            "SELECT GET_DDL('TABLE','t');",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

    def test_cloud_and_performance(self):
        sqls = [
            "CREATE WAREHOUSE wh WAREHOUSE_SIZE = 'SMALL' AUTO_SUSPEND = 10 AUTO_RESUME = TRUE;",
            "CREATE RESOURCE MONITOR rm WITH CREDIT_QUOTA = 100 TRIGGERS ON 75 PERCENT DO SUSPEND;",
            "CREATE TABLE t1 (id INT) CLUSTER BY (id);",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None

    def test_external_search_and_materialized(self):
        sqls = [
            "CREATE EXTERNAL TABLE ext (id INT AS (1)) LOCATION = @stg FILE_FORMAT = (TYPE = 'CSV') AUTO_REFRESH = TRUE;",
            "ALTER TABLE t ADD SEARCH OPTIMIZATION ON EQUALITY(col);",
            "ALTER TABLE t ADD SEARCH OPTIMIZATION ON SUBSTRING(col);",
            "CREATE MATERIALIZED VIEW mv AS SELECT * FROM t;",
        ]
        for sql in sqls:
            tree = parse_sql(sql)
            assert tree is not None
