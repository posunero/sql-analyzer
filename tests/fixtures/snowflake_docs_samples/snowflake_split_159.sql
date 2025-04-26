-- Example 10633
SELECT email, city
FROM customers
WHERE city = 'San Mateo';

SELECT <SQL_expression>(email), city
FROM customers
WHERE city = 'San Mateo';

-- Example 10634
SELECT email
FROM customers
WHERE email = 'user@example.com';

SELECT <SQL_expression>(email)
FROM customers
WHERE <SQL_expression>(email) = 'user@example.com';

-- Example 10635
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

-- Example 10636
-- table
CREATE OR REPLACE TABLE user_info (ssn string masking policy ssn_mask);

-- view
CREATE OR REPLACE VIEW user_info_v (ssn masking policy ssn_mask_v) AS SELECT * FROM user_info;

-- Example 10637
-- table
ALTER TABLE IF EXISTS user_info MODIFY COLUMN ssn_number SET MASKING POLICY ssn_mask;

-- view
ALTER VIEW user_info_v MODIFY COLUMN ssn_number SET MASKING POLICY ssn_mask_v;

-- Example 10638
-- table
CREATE OR REPLACE TABLE user_info (email string masking policy email_visibility) USING (email, visibility);

--view
CREATE OR REPLACE VIEW user_info_v (email masking policy email_visibility) USING (email, visibility) AS SELECT * FROM user_info;

-- Example 10639
-- table
ALTER TABLE IF EXISTS user_info MODIFY COLUMN email
SET MASKING POLICY email_visibility USING (EMAIL, VISIBILITY);

-- VIEW
ALTER VIEW user_info_v MODIFY COLUMN email
SET MASKING POLICY email_visibility USING (email, visibility);

-- Example 10640
ALTER TABLE t1 MODIFY COLUMN c1 UNSET MASKING POLICY;

ALTER TABLE t1 MODIFY COLUMN c1 SET MASKING POLICY p2;

-- Example 10641
ALTER TABLE t1 MODIFY COLUMN c1 SET MASKING POLICY p2 FORCE;

-- Example 10642
ALTER TABLE t1 MODIFY COLUMN c1 SET MASKING POLICY policy1 USING (c1, c3, c4) FORCE;

-- Example 10643
CREATE OR REPLACE MATERIALIZED VIEW user_info_mv
  (ssn_number masking policy ssn_mask)
AS SELECT ssn_number FROM user_info;

-- Example 10644
SQL execution error: One or more materialized views exist on the table. number of mvs=<number>, table name=<table_name>.

-- Example 10645
Unsupported feature 'CREATE ON MASKING POLICY COLUMN'.

-- Example 10646
SELECT * from table(
  INFORMATION_SCHEMA.POLICY_REFERENCES(
    policy_name=>'<policy_name>'
  )
);

-- Example 10647
ALTER TABLE t1 MODIFY COLUMN VALUE SET MASKING POLICY p1;

-- Example 10648
CREATE VIEW ssn_count AS SELECT DISTINCT(ssn) FROM table1;

-- Example 10649
CASE
  WHEN CURRENT_ROLE() IN ('PAYROLL') THEN val
  ELSE '***MASKED***'
END;

-- Example 10650
USE ROLE analyst;
SELECT COUNT(DISTINCT ssn) FROM v1;

-- Example 10651
EXPLAIN USING JSON SELECT * FROM mydb.public.ssn_record;

-- Example 10652
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

-- Example 10653
-- create a security_officer custom role

USE ROLE ACCOUNTADMIN;
CREATE ROLE security_officer;

-- grant CREATE AND APPLY masking policy privileges to the SECURITY_OFFICER custom role.

GRANT CREATE MASKING POLICY ON SCHEMA mydb.mysch TO ROLE security_officer;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE security_officer;

-- Example 10654
USE ROLE ACCOUNTADMIN;
CREATE ROLE security_officer;
GRANT CREATE MASKING POLICY ON SCHEMA mydb.mysch TO ROLE security_officer;

-- Example 10655
USE ROLE security_officer;
GRANT APPLY ON MASKING POLICY ssn_mask TO ROLE human_resources;

-- Example 10656
USE ROLE ACCOUNTADMIN;
GRANT CREATE MASKING POLICY ON SCHEMA mydb.mysch TO ROLE support;
GRANT CREATE MASKING POLICY ON SCHEMA <DB_NAME.SCHEMA_NAME> TO ROLE FINANCE;

-- Example 10657
USE ROLE support;
GRANT APPLY ON MASKING POLICY ssn_mask TO ROLE human_resources;

-- Example 10658
USE ROLE finance;
GRANT APPLY ON MASKING POLICY cash_flow_mask TO ROLE audit_internal;

-- Example 10659
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.MASKING_POLICIES
ORDER BY POLICY_NAME;

-- Example 10660
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.POLICY_REFERENCES
ORDER BY POLICY_NAME, REF_COLUMN_NAME;

-- Example 10661
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
    'my_table',
    'table'
  )
);

-- Example 10662
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 10663
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| created_on                    | privilege | granted_on    | name                        | granted_to | grantee_name    | grant_option | granted_by |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| 2024-01-24 17:12:26.984 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.GOVERNANCE_VIEWER | ROLE       | DATA_ENGINEER   | false        |            |
| 2024-01-24 17:12:47.967 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.OBJECT_VIEWER     | ROLE       | DATA_ENGINEER   | false        |            |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|

-- Example 10664
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE data_engineer;
GRANT DATABASE ROLE SNOWFLAKE.OBJECT_VIEWER TO ROLE data_engineer;
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 10665
CREATE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

-- Example 10666
CREATE OR REPLACE TABLE join_table (
  col1 INT,
  col2 VARCHAR,
  col3 NUMBER )
  JOIN POLICY jp1;

-- Example 10667
SELECT * FROM join_table;

-- Example 10668
506037 (23001): SQL compilation error: Join Policy violation, please contact the policy admin for details

-- Example 10669
SELECT * FROM join_table jt1 INNER JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 10670
+------+------+------+------+------+------+
| COL1 | COL2 | COL3 | COL1 | COL2 | COL3 |
|------+------+------+------+------+------|
+------+------+------+------+------+------+

-- Example 10671
SELECT * FROM join_table jt1 INNER JOIN join_table_2 jt2 ON jt1.col2=jt2.col2;

-- Example 10672
+------+------+------+------+------+------+
| COL1 | COL2 | COL3 | COL1 | COL2 | COL3 |
|------+------+------+------+------+------|
+------+------+------+------+------+------+

-- Example 10673
ALTER TABLE join_table UNSET JOIN POLICY;

DROP JOIN POLICY jp1;

CREATE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

CREATE OR REPLACE TABLE join_table (
  col1 INT,
  col2 VARCHAR,
  col3 NUMBER )
  JOIN POLICY jp1 ALLOWED JOIN KEYS (col1);

-- Example 10674
SELECT * FROM join_table jt1 INNER JOIN join_table_2 jt2 ON jt1.col2=jt2.col2;

-- Example 10675
506038 (23001): SQL compilation error: Join Policy violation, invalid join condition with reason: Disallowed join key used.

-- Example 10676
SHOW JOIN POLICIES;

-- Example 10677
+-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------+
| created_on                    | name | database_name | schema_name    | kind        | owner        | comment | owner_role_type | options |
|-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------|
| 2024-12-04 15:15:49.591 -0800 | JP1  | POLICY1_DB    | POLICY1_SCHEMA | JOIN_POLICY | POLICY1_ROLE |         | ROLE            |         |
+-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------+

-- Example 10678
DESCRIBE JOIN POLICY jp1;

-- Example 10679
+------+-----------+-----------------+----------------------------------------+
| name | signature | return_type     | body                                   |
|------+-----------+-----------------+----------------------------------------|
| JP1  | ()        | JOIN_CONSTRAINT | JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE) |
+------+-----------+-----------------+----------------------------------------+

-- Example 10680
CREATE JOIN POLICY my_join_policy
  AS () RETURNS JOIN_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'
          OR CURRENT_ROLE() = 'FINANCE_ROLE'
          OR CURRENT_ROLE() = 'HR_ROLE'
        THEN JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE)
      ELSE JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE)
    END;

-- Example 10681
SELECT col1, col2 FROM join_table;

-- Example 10682
SELECT *
  FROM join_table jt1, join_table_2 jt2
  WHERE jt1.col1=jt2.col1;

-- Example 10683
SELECT * FROM join_table jt1
  LEFT OUTER JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 10684
SELECT * FROM join_table jt1
  RIGHT OUTER JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 10685
SELECT * FROM join_table jt1 JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 10686
SELECT * FROM JOIN_TABLE
UNION
SELECT * FROM JOIN_TABLE_3;

-- Example 10687
SELECT * FROM JOIN_TABLE
INTERSECT
SELECT * FROM JOIN_TABLE_3;

-- Example 10688
SELECT * FROM JOIN_TABLE
EXCEPT
SELECT * FROM JOIN_TABLE_3;

-- Example 10689
SELECT * FROM JOIN_TABLE_3
EXCEPT
SELECT * FROM JOIN_TABLE;

-- Example 10690
CREATE VIEW join_table_view AS
  SELECT * FROM join_table;

-- Example 10691
SELECT * FROM join_table_view;

-- Example 10692
ALTER JOIN POLICY jp3 SET BODY -> JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE);

-- Example 10693
ALTER TABLE join_table SET JOIN POLICY jp2 FORCE;

-- Example 10694
ALTER VIEW join_view UNSET JOIN POLICY;

-- Example 10695
SELECT policy_name, policy_body, created
  FROM SNOWFLAKE.ACCOUNT_USAGE.JOIN_POLICIES
  WHERE policy_name='JP2' AND created LIKE '2024-11-26%';

-- Example 10696
+-------------+----------------------------------------------------------+-------------------------------+
| POLICY_NAME | POLICY_BODY                                              | CREATED                       |
|-------------+----------------------------------------------------------+-------------------------------|
| JP2         | CASE                                                     | 2024-11-26 11:22:54.848 -0800 |
|             |           WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'           |                               |
|             |             THEN JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE) |                               |
|             |           ELSE JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE)    |                               |
|             |         END                                              |                               |
+-------------+----------------------------------------------------------+-------------------------------+

-- Example 10697
USE DATABASE my_db;
USE SCHEMA INFORMATION_SCHEMA;
SELECT
    policy_name,
    policy_kind,
    ref_entity_name,
    ref_entity_domain,
    ref_column_name,
    ref_arg_column_names,
    policy_status
  FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(policy_name => 'my_db.my_schema.jp1'));

-- Example 10698
USE DATABASE my_db;
USE SCHEMA INFORMATION_SCHEMA;
SELECT
    policy_name,
    policy_kind,
    ref_entity_name,
    ref_entity_domain,
    ref_column_name,
    ref_arg_column_names,
    policy_status
  FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(ref_entity_name => 'my_db.my_schema.join_table', ref_entity_domain => 'table'));

-- Example 10699
+-------------+-------------+-----------------+-------------------+-----------------+----------------------+---------------+
| POLICY_NAME | POLICY_KIND | REF_ENTITY_NAME | REF_ENTITY_DOMAIN | REF_COLUMN_NAME | REF_ARG_COLUMN_NAMES | POLICY_STATUS |
|-------------+-------------+-----------------+-------------------+-----------------+----------------------+---------------|
| JP1         | JOIN_POLICY | JOIN_TABLE      | TABLE             | NULL            | [ "COL1" ]           | ACTIVE        |
+-------------+-------------+-----------------+-------------------+-----------------+----------------------+---------------+

