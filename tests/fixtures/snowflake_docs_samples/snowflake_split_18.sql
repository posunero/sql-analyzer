-- Example 1157
select
  query_start_time,
  user_name,
  object_modified_by_ddl:"objectName"::string as table_name,
  'EMAIL' as column_name,
  tag_history.value:"subOperationType"::string as operation,
  tag_history.key as tag_name,
  nvl((tag_history.value:"tagValue"."value")::string, '') as value
from
  TEST_DB.ACCOUNT_USAGE.access_history ah,
  lateral flatten(input => ah.OBJECT_MODIFIED_BY_DDL:"properties"."columns"."EMAIL"."tags") tag_history
where true
  and object_modified_by_ddl:"objectDomain" = 'Table'
  and object_modified_by_ddl:"objectName" = 'TEST_DB.TEST_SH.T'
order by query_start_time asc;

-- Example 1158
+-----------------------------------+---------------+---------------------+-------------+-----------+-------------------------------+-----------+
| QUERY_START_TIME                  | USER_NAME     | TABLE_NAME          | COLUMN_NAME | OPERATION | TAG_NAME                      | VALUE     |
+-----------------------------------+---------------+---------------------+-------------+-----------+-------------------------------+-----------+
| Mon, Feb. 14, 2023 12:01:01 -0600 | TABLE_ADMIN   | HR.TABLES.EMPL_INFO | EMAIL       | ADD       | GOVERNANCE.TAGS.TEST_TAG      | test      |
| Mon, Feb. 14, 2023 12:02:01 -0600 | TABLE_ADMIN   | HR.TABLES.EMPL_INFO | EMAIL       | DROP      | GOVERNANCE.TAGS.TEST_TAG      |           |
| Mon, Feb. 14, 2023 12:03:01 -0600 | TABLE_ADMIN   | HR.TABLES.EMPL_INFO | EMAIL       | ADD       | GOVERNANCE.TAGS.DATA_CATEGORY | sensitive |
| Mon, Feb. 14, 2023 12:04:01 -0600 | DATA_ENGINEER | HR.TABLES.EMPL_INFO | EMAIL       | ADD       | GOVERNANCE.TAGS.DATA_CATEGORY | public    |
+-----------------------------------+---------------+---------------------+-------------+-----------+-------------------------------+-----------+

-- Example 1159
create or replace procedure get_id_value(name string)
returns string not null
language javascript
as
$$
  var my_sql_command = "select id from A where name = '" + NAME + "'";
  var statement = snowflake.createStatement( {sqlText: my_sql_command} );
  var result = statement.execute();
  result.next();
  return result.getColumnValue(1);
$$
;

-- Example 1160
[
  {
    "objectDomain": "PROCEDURE",
    "objectName": "MYDB.PROCEDURES.GET_ID_VALUE",
    "argumentSignature": "(NAME STRING)",
    "dataType": "STRING"
  }
]

-- Example 1161
CREATE OR REPLACE PROCEDURE myproc_child()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  BEGIN
  SELECT * FROM mydb.mysch.mytable;
  RETURN 1;
  END
$$;

CREATE OR REPLACE PROCEDURE myproc_parent()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  BEGIN
  CALL myproc_child();
  RETURN 1;
  END
$$;

CALL myproc_parent();

-- Example 1162
SELECT
  query_id,
  parent_query_id,
  root_query_id,
  direct_objects_accessed
FROM
  SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY;

-- Example 1163
+----------+-----------------+---------------+-----------------------------------+
| QUERY_ID | PARENT_QUERY_ID | ROOT_QUERY_ID | DIRECT_OBJECTS_ACCESSED           |
+----------+-----------------+---------------+-----------------------------------+
|  1       | NULL            | NULL          | [{"objectName": "myproc_parent"}] |
|  2       | 1               | 1             | [{"objectName": "myproc_child"}]  |
|  3       | 2               | 1             | [{"objectName": "mytable"}]       |
+----------+-----------------+---------------+-----------------------------------+

-- Example 1164
CREATE SEQUENCE SEQ
  START = 2
  INCREMENT = 7
  COMMENT = 'Comment on sequence';

-- Example 1165
{
  "objectDomain": "Sequence",
  "objectId": 1,
  "objectName": "TEST_DB.TEST_SCHEMA.SEQ",
  "operationType": "CREATE",
  "properties": {
    "start": {
      "value": "2"
    },
    "increment": {
        "value": "7"
    },
    "comment": {
          "value": "Comment on Sequence"
    }
  }
}

-- Example 1166
CREATE OR REPLACE VIEW v1 (vc1, vc2) AS
  SELECT
    t1.c1 AS vc1,
    t2.c2 AS vc2
  FROM t1 LEFT OUTER JOIN t2
    ON t1.c2 = t2.c1;

-- Example 1167
{
  "columns": [
    {
      "columnId": 0,
      "columnName": "C1"
    },
    {
      "columnId": 0,
      "columnName": "C2"
    }
  ],
  "joinObjects": [
    {
      "joinType": "LEFT_OUTER_JOIN",
      "node": {
        "objectDomain": "Table",
        "objectId": 0,
        "objectName": "DB1.SCH.T2"
      }
    }
  ],
  "objectDomain": "Table",
  "objectId": 0,
  "objectName": "DB1.SCH.T1"
}

-- Example 1168
-- Dynamic Data Masking

CREATE MASKING POLICY employee_ssn_mask AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('PAYROLL') THEN val
    ELSE '******'
  END;

-- External Tokenization

  CREATE MASKING POLICY employee_ssn_detokenize AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('PAYROLL') THEN ssn_unprotect(VAL)
    ELSE val -- sees tokenized data
  END;

-- Example 1169
CREATE MASKING POLICY email_mask AS
(val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('PAYROLL') THEN val
    ELSE '******'
  END;

-- Example 1170
CREATE MASKING POLICY email_visibility AS
(email varchar, visibility string) RETURNS varchar ->
  CASE
    WHEN CURRENT_ROLE() = 'ADMIN' THEN email
    WHEN VISIBILITY = 'PUBLIC' THEN email
    ELSE '***MASKED***'
  END;

-- Example 1171
SELECT email, city
FROM customers
WHERE city = 'San Mateo';

SELECT <SQL_expression>(email), city
FROM customers
WHERE city = 'San Mateo';

-- Example 1172
SELECT email
FROM customers
WHERE email = 'user@example.com';

SELECT <SQL_expression>(email)
FROM customers
WHERE <SQL_expression>(email) = 'user@example.com';

-- Example 1173
SELECT b.email, d.city
FROM
  sf_tuts.public.emp_basic AS b
  JOIN sf_tuts.public.emp_details AS d ON b.email = d.email;

SELECT
  <SQL_expression>(b.email),
  d.city
FROM
  sf_tuts.public.emp_basic AS b
  JOIN sf_tuts.public.emp_details AS d ON <SQL_expression>(b.email) = <SQL_expression>(d.email);

-- Example 1174
-- table
CREATE OR REPLACE TABLE user_info (ssn string masking policy ssn_mask);

-- view
CREATE OR REPLACE VIEW user_info_v (ssn masking policy ssn_mask_v) AS SELECT * FROM user_info;

-- Example 1175
-- table
ALTER TABLE IF EXISTS user_info MODIFY COLUMN ssn_number SET MASKING POLICY ssn_mask;

-- view
ALTER VIEW user_info_v MODIFY COLUMN ssn_number SET MASKING POLICY ssn_mask_v;

-- Example 1176
-- table
CREATE OR REPLACE TABLE user_info (email string masking policy email_visibility) USING (email, visibility);

--view
CREATE OR REPLACE VIEW user_info_v (email masking policy email_visibility) USING (email, visibility) AS SELECT * FROM user_info;

-- Example 1177
-- table
ALTER TABLE IF EXISTS user_info MODIFY COLUMN email
SET MASKING POLICY email_visibility USING (EMAIL, VISIBILITY);

-- VIEW
ALTER VIEW user_info_v MODIFY COLUMN email
SET MASKING POLICY email_visibility USING (email, visibility);

-- Example 1178
ALTER TABLE t1 MODIFY COLUMN c1 UNSET MASKING POLICY;

ALTER TABLE t1 MODIFY COLUMN c1 SET MASKING POLICY p2;

-- Example 1179
ALTER TABLE t1 MODIFY COLUMN c1 SET MASKING POLICY p2 FORCE;

-- Example 1180
ALTER TABLE t1 MODIFY COLUMN c1 SET MASKING POLICY policy1 USING (c1, c3, c4) FORCE;

-- Example 1181
CREATE OR REPLACE MATERIALIZED VIEW user_info_mv
  (ssn_number masking policy ssn_mask)
AS SELECT ssn_number FROM user_info;

-- Example 1182
SQL execution error: One or more materialized views exist on the table. number of mvs=<number>, table name=<table_name>.

-- Example 1183
Unsupported feature 'CREATE ON MASKING POLICY COLUMN'.

-- Example 1184
SELECT * from table(
  INFORMATION_SCHEMA.POLICY_REFERENCES(
    policy_name=>'<policy_name>'
  )
);

-- Example 1185
ALTER TABLE t1 MODIFY COLUMN VALUE SET MASKING POLICY p1;

-- Example 1186
CREATE VIEW ssn_count AS SELECT DISTINCT(ssn) FROM table1;

-- Example 1187
CASE
  WHEN CURRENT_ROLE() IN ('PAYROLL') THEN val
  ELSE '***MASKED***'
END;

-- Example 1188
USE ROLE analyst;
SELECT COUNT(DISTINCT ssn) FROM v1;

-- Example 1189
EXPLAIN USING JSON SELECT * FROM mydb.public.ssn_record;

-- Example 1190
{
  "GlobalStats": {
    "partitionsTotal": 0,
    "partitionsAssigned": 0,
    "bytesAssigned": 0
  },
  "Operations": [
    [
      {
        "id": 0,
        "operation": "Result",
        "expressions": [
          "1",
          "'**MASKED**'"
        ]
      },
      {
        "id": 1,
        "parent": 0,
        "operation": "Generator",
        "expressions": [
          "1"
        ]
      }
    ]
  ]
}

-- Example 1191
-- create a security_officer custom role

USE ROLE ACCOUNTADMIN;
CREATE ROLE security_officer;

-- grant CREATE AND APPLY masking policy privileges to the SECURITY_OFFICER custom role.

GRANT CREATE MASKING POLICY ON SCHEMA mydb.mysch TO ROLE security_officer;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE security_officer;

-- Example 1192
USE ROLE ACCOUNTADMIN;
CREATE ROLE security_officer;
GRANT CREATE MASKING POLICY ON SCHEMA mydb.mysch TO ROLE security_officer;

-- Example 1193
USE ROLE security_officer;
GRANT APPLY ON MASKING POLICY ssn_mask TO ROLE human_resources;

-- Example 1194
USE ROLE ACCOUNTADMIN;
GRANT CREATE MASKING POLICY ON SCHEMA mydb.mysch TO ROLE support;
GRANT CREATE MASKING POLICY ON SCHEMA <DB_NAME.SCHEMA_NAME> TO ROLE FINANCE;

-- Example 1195
USE ROLE support;
GRANT APPLY ON MASKING POLICY ssn_mask TO ROLE human_resources;

-- Example 1196
USE ROLE finance;
GRANT APPLY ON MASKING POLICY cash_flow_mask TO ROLE audit_internal;

-- Example 1197
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.MASKING_POLICIES
ORDER BY POLICY_NAME;

-- Example 1198
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.POLICY_REFERENCES
ORDER BY POLICY_NAME, REF_COLUMN_NAME;

-- Example 1199
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
    'my_table',
    'table'
  )
);

-- Example 1200
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 1201
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| created_on                    | privilege | granted_on    | name                        | granted_to | grantee_name    | grant_option | granted_by |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| 2024-01-24 17:12:26.984 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.GOVERNANCE_VIEWER | ROLE       | DATA_ENGINEER   | false        |            |
| 2024-01-24 17:12:47.967 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.OBJECT_VIEWER     | ROLE       | DATA_ENGINEER   | false        |            |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|

-- Example 1202
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE data_engineer;
GRANT DATABASE ROLE SNOWFLAKE.OBJECT_VIEWER TO ROLE data_engineer;
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 1203
create tag cost_center
    allowed_values 'finance', 'engineering';

-- Example 1204
select get_ddl('tag', 'cost_center')

+------------------------------------------------------------------------------+
| GET_DDL('tag', 'cost_center')                                                |
|------------------------------------------------------------------------------|
| create or replace tag cost_center allowed_values = 'finance', 'engineering'; |
+------------------------------------------------------------------------------+

-- Example 1205
alter tag cost_center
    add allowed_values 'marketing';

-- Example 1206
alter tag cost_center
    drop allowed_values 'engineering';

-- Example 1207
select system$get_tag_allowed_values('governance.tags.cost_center');

+--------------------------------------------------------------+
| SYSTEM$GET_TAG_ALLOWED_VALUES('GOVERNANCE.TAGS.COST_CENTER') |
|--------------------------------------------------------------|
| ["finance","marketing"]                                      |
+--------------------------------------------------------------+

-- Example 1208
USE ROLE USERADMIN;
CREATE ROLE tag_admin;
USE ROLE ACCOUNTADMIN;
GRANT CREATE TAG ON SCHEMA mydb.mysch TO ROLE tag_admin;
GRANT APPLY TAG ON ACCOUNT TO ROLE tag_admin;

-- Example 1209
USE ROLE USERADMIN;
GRANT ROLE tag_admin TO USER jsmith;

-- Example 1210
USE ROLE tag_admin;
USE SCHEMA mydb.mysch;
CREATE TAG cost_center;

-- Example 1211
USE ROLE tag_admin;
CREATE WAREHOUSE mywarehouse WITH TAG (cost_center = 'sales');

-- Example 1212
USE ROLE tag_admin;
ALTER WAREHOUSE wh1 SET TAG cost_center = 'sales';

-- Example 1213
ALTER TABLE hr.tables.empl_info
  MODIFY COLUMN job_title
  SET TAG visibility = 'public';

-- Example 1214
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAGS
ORDER BY TAG_NAME;

-- Example 1215
SELECT SYSTEM$GET_TAG('cost_center', 'my_table', 'table');

-- Example 1216
SELECT *
FROM TABLE(
  snowflake.account_usage.tag_references_with_lineage(
    'my_db.my_schema.cost_center'
  )
);

-- Example 1217
SELECT * FROM snowflake.account_usage.tag_references
ORDER BY TAG_NAME, DOMAIN, OBJECT_ID;

-- Example 1218
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.TAG_REFERENCES(
    'my_table',
    'table'
  )
);

-- Example 1219
SELECT *
FROM TABLE(
  INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
    'my_table',
    'table'
  )
);

-- Example 1220
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 1221
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| created_on                    | privilege | granted_on    | name                        | granted_to | grantee_name    | grant_option | granted_by |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| 2024-01-24 17:12:26.984 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.GOVERNANCE_VIEWER | ROLE       | DATA_ENGINEER   | false        |            |
| 2024-01-24 17:12:47.967 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.OBJECT_VIEWER     | ROLE       | DATA_ENGINEER   | false        |            |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|

-- Example 1222
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE data_engineer;
GRANT DATABASE ROLE SNOWFLAKE.OBJECT_VIEWER TO ROLE data_engineer;
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 1223
use role securityadmin;
grant create tag on schema <db_name.schema_name> to role tag_admin;
grant apply tag on account to role tag_admin;

-- Example 1224
use role securityadmin;
grant create tag on schema <db_name.schema_name> to role tag_admin;
grant apply on tag cost_center to role finance_role;

