-- More Extracted Snowflake SQL Examples (Set 12)

-- From snowflake_split_410.sql

CREATE EXTERNAL LISTING my1stlisting
SHARE myshare AS
$$
 title: "My first SQL listing"
 description: "This is my first listing"
 listing_terms:
   type: "OFFLINE"
 targets:
   accounts: ["Org1.Account1"]
$$ PUBLISH=FALSE REVIEW=FALSE;

ALTER LISTING MY1STLISTING PUBLISH;
ALTER LISTING MY1STLISTING UNPUBLISH;

ALTER LISTING MY1STLISTING AS
$$
   title: "My First SQL Listing"
   description: "This is my first listing"
   listing_terms:
     type: "OFFLINE"
   targets:
     accounts: ["Org1.Account1"]
   usage_examples:
     - title: "this is a test sql"
       description: "Simple example"
       query: "select *"
$$;

SHOW LISTINGS LIKE 'MY1STLISTING';
SHOW LISTINGS;
DESC LISTING MY1STLISTING;
DROP LISTING IF EXISTS MY1STLISTING;

GRANT MANAGE RELEASES ON APPLICATION PACKAGE hello_snowflake_package TO ROLE release_mgr;

ALTER APPLICATION PACKAGE hello_snowflake_package SET DEFAULT RELEASE DIRECTIVE VERSION = v1_0 PATCH = 2;
ALTER APPLICATION PACKAGE hello_snowflake_package SET RELEASE DIRECTIVE hello_snowflake_package_custom ACCOUNTS = (CONSUMER_ORG.CONSUMER_ACCOUNT) VERSION = v1_0 PATCH = 0;
ALTER APPLICATION PACKAGE hello_snowflake_package MODIFY RELEASE DIRECTIVE hello_snowflake_package_custom VERSION = v1_0 PATCH = 0;
ALTER APPLICATION PACKAGE hello_snowflake_package UNSET RELEASE DIRECTIVE hello_snowflake_package_custom;

CREATE APPLICATION hello_snowflake FROM APPLICATION PACKAGE hello_snowflake_package;
SHOW RELEASE DIRECTIVES IN APPLICATION PACKAGE hello_snowflake_package;

CREATE PROCEDURE PROGRAMS.LOOKUP(...)
  RETURNS STRING
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('/scripts/libraries/jar/lookup.jar', '/scripts/libraries/jar/log4j.jar')
  HANDLER = 'com.acme.programs.Lookup';

CREATE OR ALTER VERSIONED SCHEMA app_code;
CREATE STAGE app_code.app_jars;

CREATE FUNCTION app_code.add(x INT, y INT)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'TestAddFunc.add'
  TARGET_PATH = '@app_code.app_jars/TestAddFunc.jar'
  AS
  $$
  class TestAddFunc {
    public static int add(int x, int y) {
      Return x + y;
    }
  }
  $$;

CREATE FUNCTION app_code.add(x INTEGER, y INTEGER)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'TestAddFunc.add'
  IMPORTS = ('/JARs/Java/TestAddFunc.jar');

CREATE FUNCTION app_code.py_echo_func(str STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  HANDLER = 'echo'
AS
$$
def echo(str):
  return "ECHO: " + str
$$;

CREATE FUNCTION PY_PROCESS_DATA_FUNC()
  RETURNS STRING
  LANGUAGE PYTHON
  HANDLER = 'TestPythonFunc.process'
  IMPORTS = ('/python_modules/TestPythonFunc.py', '/python_modules/data.csv');

CREATE OR REPLACE PROCEDURE APP_SCHEMA.ERROR_CATCH()
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS OWNER
  AS $$
    try {
      let x = y.length;
    }
    catch(err){
      return "There is an error.";
    }
    return "Done";
  $$;

CREATE OR REPLACE PROCEDURE calculator.create_external_function(integration_name STRING)
  RETURNS STRING
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  DECLARE
    CREATE_STATEMENT VARCHAR;
  BEGIN
    CREATE_STATEMENT := 'CREATE OR REPLACE EXTERNAL FUNCTION EXTERNAL_ADD(NUM1 FLOAT, NUM2 FLOAT)
        RETURNS FLOAT API_INTEGRATION = ? AS ''https://xyz.execute-api.us-west-2.amazonaws.com/production/sum'';' ;
    EXECUTE IMMEDIATE :CREATE_STATEMENT USING (INTEGRATION_NAME);
    RETURN 'EXTERNAL FUNCTION CREATED';
  END;

GRANT USAGE ON PROCEDURE calculator.create_external_function(string) TO APPLICATION ROLE app_public; 