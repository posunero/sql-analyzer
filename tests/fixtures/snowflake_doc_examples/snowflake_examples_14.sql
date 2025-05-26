-- More Extracted Snowflake SQL Examples (Set 14)

-- From snowflake_split_409.sql
-- (No direct SQL DDL/DML, mostly HTTP/JSON API examples, skip)

-- From snowflake_split_410.sql
-- (Already processed in previous batch)

-- From snowflake_split_411.sql
-- (Already processed in previous batch)

-- From snowflake_split_412.sql
-- External function usage and grants
USE DATABASE <database_name>;
USE SCHEMA <schema_name>;
GRANT USAGE ON FUNCTION <external_function_name>(<parameter_data_type>) TO <role_name>;
GRANT USAGE ON FUNCTION echo(INTEGER, VARCHAR) TO analyst_role;
SELECT echo(42, 'Adams');

-- From snowflake_split_413.sql
-- (YAML/definition examples, skip)

-- From snowflake_split_414.sql
-- (Mostly CLI/command output, skip)

-- From snowflake_split_415.sql
-- (Mostly CLI/command output, skip)

-- From snowflake_split_416.sql
-- (Mostly CLI/command output, skip)

-- From snowflake_split_417.sql
CREATE OR REPLACE PROCEDURE MYPROC(fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'MyJavaClass.run'
  AS
  $$
    import com.snowflake.snowpark_java.*;
    public class MyJavaClass {
      public String run(Session session, String fromTable, String toTable, int count) {
        session.table(fromTable).limit(count).write().saveAsTable(toTable);
        return "SUCCESS";
      }
    }
  $$;

CREATE FUNCTION my_udf(i NUMBER)
  RETURNS NUMBER
  LANGUAGE JAVA
  IMPORTS = ('@mystage/handlers/my_handler.jar')
  HANDLER = 'MyClass.myFunction'; 