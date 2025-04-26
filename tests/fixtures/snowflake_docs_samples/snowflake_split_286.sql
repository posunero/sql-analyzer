-- Example 19140
DROP NETWORK RULE myrule;

-- Example 19141
DROP PACKAGES POLICY [ IF EXISTS ] <name>

-- Example 19142
DROP PASSWORD POLICY [ IF EXISTS ] <name>

-- Example 19143
SELECT * from table(information_schema.policy_references(policy_name=>'<string>'));

-- Example 19144
DROP PASSWORD POLICY password_policy_production_1;

-- Example 19145
DROP PRIVACY POLICY <name>

-- Example 19146
SELECT * FROM TABLE(mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(POLICY_NAME=>'my_privacy_policy'));

-- Example 19147
DROP PRIVACY POLICY myprivpolicy;

-- Example 19148
+------------------------------------+
| status                             |
|------------------------------------|
| MYPRIVPOLICY successfully dropped. |
+------------------------------------+

-- Example 19149
DROP PROCEDURE [ IF EXISTS ] <procedure_name> ( [ <arg_data_type> , ... ] )

-- Example 19150
DROP PROCEDURE add_accounting_user(varchar);

-------------------------------------------+
             status                        |
-------------------------------------------+
 ADD_ACCOUNTING_USER successfully dropped. |
-------------------------------------------+

-- Example 19151
DROP REPLICATION GROUP [ IF EXISTS ] <name>

-- Example 19152
DROP REPLICATION GROUP myrg;

-- Example 19153
DROP RESOURCE MONITOR [ IF EXISTS ] <name>

-- Example 19154
DROP RESOURCE MONITOR IF EXISTS my_rm;

-- Example 19155
DROP ROLE [ IF EXISTS ] <name>

-- Example 19156
CREATE ROLE bobr_primary;

GRANT ROLE bobr_primary to USER bobr;

USE ROLE bobr_primary;

DROP ROLE bobr_primary;

-- Example 19157
SQL execution error: Cannot drop role BOBR_PRIMARY as it is the current primary role.

-- Example 19158
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
  WHERE grantee_name = UPPER('<role_name>') OR granted_by = UPPER('<role_name>');

-- Example 19159
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
  WHERE grantee_name = UPPER('myrole') OR granted_by = UPPER('myrole');

-- Example 19160
DROP ROLE myrole;

-- Example 19161
DROP ROW ACCESS POLICY [ IF EXISTS ] <name>

-- Example 19162
SELECT * from table(information_schema.policy_references(policy_name=>'<string>'));

-- Example 19163
DROP ROW ACCESS POLICY rap_table_employee_info;

-- Example 19164
DROP SECRET [ IF EXISTS ] <name>

-- Example 19165
DROP SECRET service_now_creds;

-- Example 19166
DROP SEMANTIC VIEW [ IF EXISTS ] <name>

-- Example 19167
DROP SEMANTIC VIEW my_semantic_view;

-- Example 19168
DROP SEQUENCE [ IF EXISTS ] <name> [ CASCADE | RESTRICT ]

-- Example 19169
DROP SEQUENCE IF EXISTS invoice_sequence_number;

-- Example 19170
DROP SERVICE [ IF EXISTS ] <name> [ FORCE ]

-- Example 19171
DROP SERVICE my_tutorial;

-- Example 19172
+-----------------------------------+
| status                            |
|-----------------------------------|
| MY_TUTORIAL successfully dropped. |
+-----------------------------------+

-- Example 19173
DROP SESSION POLICY [ IF EXISTS ] <name>

-- Example 19174
SELECT * from table(information_schema.policy_references(policy_name=>'<string>'));

-- Example 19175
DROP SESSION POLICY session_policy_production_1;

-- Example 19176
DROP SHARE <name>

-- Example 19177
DROP SHARE sales_s;

+-------------------------------+
| status                        |
|-------------------------------|
| SALES_S successfully dropped. |
+-------------------------------+

-- Example 19178
DROP STAGE [ IF EXISTS ] <name>

-- Example 19179
DROP STAGE my_stage;

--------------------------------+
             status             |
--------------------------------+
 MY_STAGE successfully dropped. |
--------------------------------+

-- Example 19180
DROP STREAM [ IF EXISTS ] <name>

-- Example 19181
SHOW STREAMS LIKE 't2%';


DROP STREAM t2;


SHOW STREAMS LIKE 't2%';

-- Example 19182
DROP STREAM IF EXISTS t2;

-- Example 19183
DROP STREAMLIT [IF EXISTS] <name>

-- Example 19184
DROP TASK [ IF EXISTS ] <name>

-- Example 19185
SHOW TASKS LIKE 't2%';


DROP TASK t2;


SHOW TASKS LIKE 't2%';

-- Example 19186
DROP TASK IF EXISTS t2;

-- Example 19187
DROP VIEW [ IF EXISTS ] <name>

-- Example 19188
DROP VIEW myview;

-- Example 19189
------------------------------+
           status             |
------------------------------+
 MYVIEW successfully dropped. |
------------------------------+

-- Example 19190
DROP WAREHOUSE [ IF EXISTS ] <name>

-- Example 19191
EXECUTE IMMEDIATE '<string_literal>'
    [ USING ( <bind_variable> [ , <bind_variable> ... ] ) ]

EXECUTE IMMEDIATE <variable>
    [ USING ( <bind_variable> [ , <bind_variable> ... ] ) ]

EXECUTE IMMEDIATE $<session_variable>
    [ USING ( <bind_variable> [ , <bind_variable> ... ] ) ]

-- Example 19192
CREATE PROCEDURE execute_immediate_local_variable()
RETURNS VARCHAR
AS
DECLARE
  v1 VARCHAR DEFAULT 'CREATE TABLE temporary1 (i INTEGER)';
  v2 VARCHAR DEFAULT 'INSERT INTO temporary1 (i) VALUES (76)';
  result INTEGER DEFAULT 0;
BEGIN
  EXECUTE IMMEDIATE v1;
  EXECUTE IMMEDIATE v2  ||  ',(80)'  ||  ',(84)';
  result := (SELECT SUM(i) FROM temporary1);
  RETURN result::VARCHAR;
END;

-- Example 19193
CREATE PROCEDURE execute_immediate_local_variable()
RETURNS VARCHAR
AS
$$
DECLARE
  v1 VARCHAR DEFAULT 'CREATE TABLE temporary1 (i INTEGER)';
  v2 VARCHAR DEFAULT 'INSERT INTO temporary1 (i) VALUES (76)';
  result INTEGER DEFAULT 0;
BEGIN
  EXECUTE IMMEDIATE v1;
  EXECUTE IMMEDIATE v2  ||  ',(80)'  ||  ',(84)';
  result := (SELECT SUM(i) FROM temporary1);
  RETURN result::VARCHAR;
END;
$$;

-- Example 19194
CALL execute_immediate_local_variable();

-- Example 19195
+----------------------------------+
| EXECUTE_IMMEDIATE_LOCAL_VARIABLE |
|----------------------------------|
| 240                              |
+----------------------------------+

-- Example 19196
CREATE OR REPLACE TABLE invoices (id INTEGER, price NUMBER(12, 2));

INSERT INTO invoices (id, price) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 19197
CREATE OR REPLACE PROCEDURE min_max_invoices_sp(
    minimum_price NUMBER(12,2),
    maximum_price NUMBER(12,2))
  RETURNS TABLE (id INTEGER, price NUMBER(12, 2))
  LANGUAGE SQL
AS
DECLARE
  rs RESULTSET;
  query VARCHAR DEFAULT 'SELECT * FROM invoices WHERE price > ? AND price < ?';
BEGIN
  rs := (EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price));
  RETURN TABLE(rs);
END;

-- Example 19198
CREATE OR REPLACE PROCEDURE min_max_invoices_sp(
    minimum_price NUMBER(12,2),
    maximum_price NUMBER(12,2))
  RETURNS TABLE (id INTEGER, price NUMBER(12, 2))
  LANGUAGE SQL
AS
$$
DECLARE
  rs RESULTSET;
  query VARCHAR DEFAULT 'SELECT * FROM invoices WHERE price > ? AND price < ?';
BEGIN
  rs := (EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price));
  RETURN TABLE(rs);
END;
$$
;

-- Example 19199
CALL min_max_invoices_sp(20, 30);

-- Example 19200
+----+-------+
| ID | PRICE |
|----+-------|
|  2 | 22.22 |
+----+-------+

-- Example 19201
SET stmt =
$$
    SELECT PI();
$$
;

-- Example 19202
EXECUTE IMMEDIATE $stmt;

-- Example 19203
+-------------+
|        PI() |
|-------------|
| 3.141592654 |
+-------------+

-- Example 19204
EXECUTE IMMEDIATE $$
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := PI() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;
$$
;

-- Example 19205
+-----------------+
| anonymous block |
|-----------------|
|    28.274333882 |
+-----------------+

-- Example 19206
EXECUTE NOTEBOOK <name> ()

