import pytest
from sql_analyzer.parser.core import parse_sql


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


class TestSnowflakeStorageIntegration:
    """Test storage integration statements"""
    
    def test_create_storage_integration_gcs(self):
        """Test CREATE STORAGE INTEGRATION for Google Cloud Storage"""
        sql = """
        CREATE STORAGE INTEGRATION gcs_int
          TYPE = EXTERNAL_STAGE
          STORAGE_PROVIDER = 'GCS'
          ENABLED = TRUE
          STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
          STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_create_storage_integration_s3(self):
        """Test CREATE STORAGE INTEGRATION for AWS S3"""
        sql = """
        CREATE STORAGE INTEGRATION s3_int
          TYPE = EXTERNAL_STAGE
          STORAGE_PROVIDER = 'S3'
          ENABLED = TRUE
          STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket/path1/', 's3://mybucket/path2/')
          STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/MyRole';
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_create_storage_integration_azure(self):
        """Test CREATE STORAGE INTEGRATION for Azure"""
        sql = """
        CREATE STORAGE INTEGRATION azure_int
          TYPE = EXTERNAL_STAGE
          STORAGE_PROVIDER = 'AZURE'
          ENABLED = TRUE
          STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer/path1/')
          AZURE_TENANT_ID = '12345678-1234-1234-1234-123456789012';
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeVariableDeclarations:
    """Test variable declarations and assignments"""
    
    def test_let_statement_with_assignment(self):
        """Test LET statement with assignment operator"""
        sql = """
        BEGIN
          LET count := 1;
          LET message := 'Hello World';
          LET result := count * 10;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_declare_with_default_values(self):
        """Test DECLARE with DEFAULT values"""
        sql = """
        DECLARE
          counter INTEGER DEFAULT 0;
          status VARCHAR DEFAULT 'pending';
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP();
        BEGIN
          counter := counter + 1;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_declare_resultset_with_query(self):
        """Test DECLARE RESULTSET with default query"""
        sql = """
        DECLARE
          user_data RESULTSET DEFAULT (SELECT * FROM users WHERE active = TRUE);
        BEGIN
          RETURN TABLE(user_data);
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None


class TestSnowflakeComplexScenarios:
    """Test complex scenarios combining multiple features"""
    
    def test_complex_procedure_with_all_features(self):
        """Test procedure combining multiple Snowflake features"""
        sql = """
        CREATE OR REPLACE PROCEDURE process_user_data(input_user_id INTEGER)
        RETURNS TABLE(user_id INTEGER, status VARCHAR, processed_at TIMESTAMP)
        LANGUAGE SQL
        AS
          DECLARE
            user_count INTEGER DEFAULT 0;
            result_data RESULTSET;
            error_msg VARCHAR;
            PROCESSING_ERROR EXCEPTION (-20001, 'Error processing user data');
          BEGIN
            -- Check if user exists
            SELECT COUNT(*) INTO user_count FROM users WHERE id = input_user_id;
            
            IF (user_count = 0) THEN
              RAISE PROCESSING_ERROR;
            END IF;
            
            -- Process the data
            result_data := (
              SELECT id, 'processed', CURRENT_TIMESTAMP()
              FROM users 
              WHERE id = input_user_id
            );
            
            RETURN TABLE(result_data);
            
                      EXCEPTION
              WHEN PROCESSING_ERROR THEN
                RETURN TABLE((SELECT input_user_id, 'error', CURRENT_TIMESTAMP()));
          END;
        """
        tree = parse_sql(sql)
        assert tree is not None

    def test_dynamic_sql_with_exception_handling(self):
        """Test dynamic SQL execution with exception handling"""
        sql = """
        DECLARE
          dynamic_query VARCHAR;
          result_set RESULTSET;
          SQL_ERROR EXCEPTION (-20002, 'Dynamic SQL execution failed');
        BEGIN
          dynamic_query := 'SELECT * FROM ' || :table_name || ' WHERE active = TRUE';
          
          BEGIN
            result_set := (EXECUTE IMMEDIATE :dynamic_query);
            RETURN TABLE(result_set);
          EXCEPTION
            WHEN SQL_ERROR THEN
              RETURN TABLE((SELECT 'Error executing query' as message));
          END;
        END;
        """
        tree = parse_sql(sql)
        assert tree is not None 