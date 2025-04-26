-- Example 11772
accountObjectPrivileges ::=
-- For APPLICATION PACKAGE
    { ATTACH LISTING | DEVELOP | INSTALL | MANAGE VERSIONS | MANAGE RELEASES } [ , ... ]
-- For COMPUTE POOL
   { MODIFY | MONITOR | OPERATE | USAGE } [ , ... ]
-- For CONNECTION
   { FAILOVER } [ , ... ]
-- For DATABASE
   { APPLYBUDGET | CREATE { DATABASE ROLE | SCHEMA }
   | IMPORTED PRIVILEGES | MODIFY | MONITOR | USAGE } [ , ... ]
-- For EXTERNAL VOLUME
   { USAGE } [ , ... ]
-- For FAILOVER GROUP
   { FAILOVER | MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For INTEGRATION
   { USAGE | USE_ANY_ROLE } [ , ... ]
-- For ORGANIZATION PROFILE
   { MODIFY } [ , ... ]
-- For REPLICATION GROUP
   { MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For RESOURCE MONITOR
   { MODIFY | MONITOR } [ , ... ]
-- For USER
   { MONITOR } [ , ... ]
-- For WAREHOUSE
   { APPLYBUDGET | MODIFY | MONITOR | USAGE | OPERATE } [ , ... ]

-- Example 11773
schemaPrivileges ::=

    ADD SEARCH OPTIMIZATION | APPLYBUDGET
  | CREATE {
        ALERT | CORTEX SEARCH SERVICE | DATA METRIC FUNCTION | DATASET
      | EVENT TABLE | FILE FORMAT | FUNCTION
      | { GIT | IMAGE } REPOSITORY
      | MODEL | NETWORK RULE | NOTEBOOK | PIPE | PROCEDURE
      | { AGGREGATION | AUTHENTICATION | MASKING | PACKAGES
         | PASSWORD | PRIVACY | PROJECTION | ROW ACCESS | SESSION } POLICY
      | SECRET | SEQUENCE | SERVICE | SNAPSHOT | STAGE | STREAM | STREAMLIT
      | SNOWFLAKE.CORE.BUDGET
      | SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
      | SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER
      | SNOWFLAKE.ML.ANOMALY_DETECTION | SNOWFLAKE.ML.CLASSIFICATION
         | SNOWFLAKE.ML.FORECAST | SNOWFLAKE.ML.TOP_INSIGHTS
      | SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE
      | [ { DYNAMIC | EXTERNAL | ICEBERG } ] TABLE
      | TAG | TASK | [ { MATERIALIZED | SEMANTIC } ] VIEW
      }
   | MODIFY | MONITOR | USAGE
   [ , ... ]

-- Example 11774
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DATA METRIC FUNCTION
     USAGE [ , ... ]
  -- For DYNAMIC TABLE
     MONITOR, OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { APPLYBUDGET | DELETE | OWNERSHIP | REFERENCES | SELECT | TRUNCATE } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), MODEL, PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For GIT REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For HYBRID TABLE
     { APPLYBUDGET | DELETE | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For ICEBERG TABLE
     { APPLYBUDGET | DELETE | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { AGGREGATION | AUTHENTICATION | MASKING | JOIN | PACKAGES | PASSWORD | PRIVACY | PROJECTION | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     { READ | USAGE } [ , ... ]
  -- For SEMANTIC VIEW
     REFERENCES [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For STREAMLIT
     USAGE [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]

-- Example 11775
REVOKE OPERATE ON WAREHOUSE report_wh FROM ROLE analyst;

-- Example 11776
REVOKE GRANT OPTION FOR OPERATE ON WAREHOUSE report_wh FROM ROLE analyst;

-- Example 11777
REVOKE SELECT ON ALL TABLES IN SCHEMA mydb.myschema from ROLE analyst;

-- Example 11778
REVOKE ALL PRIVILEGES ON FUNCTION add5(number) FROM ROLE analyst;

REVOKE ALL PRIVILEGES ON FUNCTION add5(string) FROM ROLE analyst;

-- Example 11779
REVOKE ALL PRIVILEGES ON PROCEDURE clean_schema(string) FROM ROLE analyst;

REVOKE ALL PRIVILEGES ON procedure clean_schema(string, string) FROM ROLE analyst;

-- Example 11780
REVOKE SELECT, INSERT ON FUTURE TABLES IN SCHEMA mydb.myschema
FROM ROLE role1;

-- Example 11781
REVOKE SELECT ON ALL TABLES IN SCHEMA mydb.myschema
  FROM DATABASE ROLE mydb.dr1;

-- Example 11782
REVOKE ALL PRIVILEGES ON FUNCTION add5(number)
  FROM DATABASE ROLE mydb.dr1;

REVOKE ALL PRIVILEGES ON FUNCTION add5(string)
  FROM DATABASE ROLE mydb.dr1;

-- Example 11783
REVOKE ALL PRIVILEGES ON PROCEDURE clean_schema(string)
  FROM DATABASE ROLE mydb.dr1;

REVOKE ALL PRIVILEGES ON procedure clean_schema(string, string)
  FROM DATABASE ROLE mydb.dr1;

-- Example 11784
REVOKE SELECT,INSERT ON FUTURE TABLES IN SCHEMA mydb.myschema
  FROM DATABASE ROLE mydb.dr1;

-- Example 11785
SHOW GRANTS [ LIMIT <rows> ]

SHOW GRANTS ON ACCOUNT [ LIMIT <rows> ]

SHOW GRANTS ON <object_type> <object_name> [ LIMIT <rows> ]

SHOW GRANTS TO {
  APPLICATION <app_name>
  | APPLICATION ROLE [ <app_name>. ]<app_role_name>
  | SERVICE ROLE <service_name>!<service_role_name>
  | <class_name> ROLE <instance_name>!<instance_role_name>
  | ROLE <role_name>
  | SHARE <share_name> [ IN APPLICATION PACKAGE <app_package_name> ]
  | USER <user_name>
} [ LIMIT <rows> ]

SHOW GRANTS OF {
  APPLICATION ROLE <app_role_name>
  | SERVICE ROLE <service_name>!<service_role_name>
  | ROLE <role_name>
} [ LIMIT <rows> ]

SHOW GRANTS OF SHARE <share_name> [ LIMIT <rows> ]

SHOW FUTURE GRANTS IN SCHEMA { <schema_name> } [ LIMIT <rows> ]

SHOW FUTURE GRANTS IN DATABASE { <database_name> } [ LIMIT <rows> ]

SHOW FUTURE GRANTS TO ROLE <role_name> [ LIMIT <rows> ]

SHOW FUTURE GRANTS TO DATABASE ROLE <database_role_name>

-- Example 11786
Invalid state of the shared database role. Please revoke the future grants to the shared database role.

-- Example 11787
SHOW GRANTS ON DATABASE sales;

+---------------------------------+-----------+------------+------------+------------+--------------+--------------+----------------------+--------------+
| created_on                      | privilege | granted_on | name       | granted_to | grantee_name | grant_option | granted_by_role_type | granted_by   |
+---------------------------------+-----------+------------+------------+------------+--------------+--------------+----------------------+--------------+
| Thu, 07 Jul 2016 05:22:29 -0700 | OWNERSHIP | DATABASE   | REALESTATE | ROLE       | ACCOUNTADMIN | true         | ROLE                 | ACCOUNTADMIN |
| Thu, 07 Jul 2016 12:14:12 -0700 | USAGE     | DATABASE   | REALESTATE | ROLE       | PUBLIC       | false        | ROLE                 | ACCOUNTADMIN |
+---------------------------------+-----------+------------+------------+------------+--------------+--------------+----------------------+--------------+

-- Example 11788
SHOW GRANTS TO ROLE analyst;

+---------------------------------+------------------+------------+------------+------------+--------------+------------+
| created_on                      | privilege        | granted_on | name       | granted_to | grant_option | granted_by |
|---------------------------------+------------------+------------+------------+------------+--------------+------------+
| Wed, 17 Dec 2014 18:19:37 -0800 | CREATE WAREHOUSE | ACCOUNT    | DEMOENV    | ANALYST    | false        | SYSADMIN   |
+---------------------------------+------------------+------------+------------+------------+--------------+------------+

-- Example 11789
SHOW GRANTS TO USER demo;

+---------------------------------+------+------------+-------+---------------+
| created_on                      | role | granted_to | name  | granted_by    |
|---------------------------------+------+------------+-------+---------------+
| Wed, 31 Dec 1969 16:00:00 -0800 | DBA  | USER       | DEMO  | SECURITYADMIN |
+---------------------------------+------+------------+-------+---------------+

-- Example 11790
SHOW GRANTS OF ROLE analyst;

+---------------------------------+---------+------------+--------------+---------------+
| created_on                      | role    | granted_to | grantee_name | granted_by    |
|---------------------------------+---------+------------+--------------+---------------|
| Tue, 05 Jul 2016 16:16:34 -0700 | ANALYST | ROLE       | ANALYST_US   | SECURITYADMIN |
| Tue, 05 Jul 2016 16:16:34 -0700 | ANALYST | ROLE       | DBA          | SECURITYADMIN |
| Fri, 08 Jul 2016 10:21:30 -0700 | ANALYST | USER       | JOESM        | SECURITYADMIN |
+---------------------------------+---------+------------+--------------+---------------+

-- Example 11791
SHOW FUTURE GRANTS IN SCHEMA sales.public;

+-------------------------------+-----------+----------+---------------------------+----------+-----------------------+--------------+
| created_on                    | privilege | grant_on | name                      | grant_to | grantee_name          | grant_option |
|-------------------------------+-----------+----------+---------------------------+----------+-----------------------+--------------|
| 2018-12-21 09:22:26.946 -0800 | INSERT    | TABLE    | SALES.PUBLIC.<TABLE>      | ROLE     | ROLE1                 | false        |
| 2018-12-21 09:22:26.946 -0800 | SELECT    | TABLE    | SALES.PUBLIC.<TABLE>      | ROLE     | ROLE1                 | false        |
+-------------------------------+-----------+----------+---------------------------+----------+-----------------------+--------------+

-- Example 11792
SHOW GRANTS TO SNOWFLAKE.CORE.BUDGET ROLE cost.budgets.my_budget!ADMIN;

-- Example 11793
+-------------------------------+-----------+------------+----------------------------------------------------------------------------------------------------------------------------------------+
| created_on                    | privilege | granted_on | name                                                                                                                                   |
+-------------------------------+-----------+------------+----------------------------------------------------------------------------------------------------------------------------------------+
| 2023-10-31 15:57:41.489 +0000 | USAGE     | ROLE       | SNOWFLAKE.CORE.BUDGET!ADMIN                                                                                                            |
| 2023-09-25 22:56:12.798 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!ACTIVATE():VARCHAR(16777216)                                                                                     |
| 2023-09-25 22:56:13.304 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!ADD_RESOURCE(TARGET_REF VARCHAR):VARCHAR(16777216)                                                               |
| 2023-09-25 22:56:12.863 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_ACTIVATION_DATE():DATE                                                                                       |
| 2023-09-25 22:56:12.412 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_BUDGET_NAME():VARCHAR(16777216)                                                                              |
| 2023-09-25 22:56:11.510 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_CONFIG():TABLE: ()                                                                                           |
| 2023-09-25 22:56:13.432 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_LINKED_RESOURCES():TABLE: ()                                                                                 |
| 2023-09-25 22:56:11.582 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_MEASUREMENT_TABLE():TABLE: ()                                                                                |
| 2023-09-25 22:56:12.153 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_NOTIFICATION_EMAIL():VARCHAR(16777216)                                                                       |
| 2023-09-25 22:56:12.016 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_NOTIFICATION_INTEGRATION_NAME():VARCHAR(16777216)                                                            |
| 2023-09-25 22:56:12.286 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_NOTIFICATION_MUTE_FLAG():VARCHAR(16777216)                                                                   |
| 2023-09-25 22:56:13.068 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_SERVICE_TYPE_USAGE(SERVICE_TYPE VARCHAR):TABLE: ()                                                           |
| 2023-09-25 22:56:13.245 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_SERVICE_TYPE_USAGE(SERVICE_TYPE VARCHAR, TIME_DEPART VARCHAR, USER_TIMEZONE VARCHAR, TIME_LOWER_BOUND VARCHA |
| 2023-09-25 22:56:12.595 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_SPENDING_HISTORY():TABLE: ()                                                                                 |
| 2023-09-25 22:56:12.732 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_SPENDING_HISTORY(TIME_LOWER_BOUND VARCHAR, TIME_UPPER_BOUND VARCHAR):TABLE: ()                               |
| 2023-09-25 22:56:11.716 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!GET_SPENDING_LIMIT():NUMBER(38,0)                                                                                |
| 2023-09-25 22:56:13.367 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!REMOVE_RESOURCE(TARGET_REF VARCHAR):VARCHAR(16777216)                                                            |
| 2023-09-25 22:56:11.856 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!SET_EMAIL_NOTIFICATIONS(NOTIFICATION_CHANNEL_NAME VARCHAR, EMAIL VARCHAR):VARCHAR(16777216)                      |
| 2023-09-25 22:56:12.349 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!SET_NOTIFICATION_MUTE_FLAG(USER_MUTE_FLAG BOOLEAN):VARCHAR(16777216)                                             |
| 2023-09-25 22:56:11.780 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!SET_SPENDING_LIMIT(SPENDING_LIMIT FLOAT):VARCHAR(16777216)                                                       |
| 2023-09-25 22:56:12.475 +0000 | USAGE     | PROCEDURE  | SNOWFLAKE.CORE.BUDGET!SET_TASK_SCHEDULE(NEW_SCHEDULE VARCHAR):VARCHAR(16777216)                                                        |
+-------------------------------+-----------+------------+----------------------------------------------------------------------------------------------------------------------------------------+

-- Example 11794
CREATE TABLE hospital_table (patient_id INTEGER,
                             patient_name VARCHAR, 
                             billing_address VARCHAR,
                             diagnosis VARCHAR, 
                             treatment VARCHAR,
                             cost NUMBER(10,2));
INSERT INTO hospital_table 
        (patient_ID, patient_name, billing_address, diagnosis, treatment, cost) 
    VALUES
        (1, 'Mark Knopfler', '1982 Telegraph Road', 'Industrial Disease', 
            'a week of peace and quiet', 2000.00),
        (2, 'Guido van Rossum', '37 Florida St.', 'python bite', 'anti-venom', 
            70000.00)
        ;

-- Example 11795
CREATE VIEW doctor_view AS
    SELECT patient_ID, patient_name, diagnosis, treatment FROM hospital_table;

CREATE VIEW accountant_view AS
    SELECT patient_ID, patient_name, billing_address, cost FROM hospital_table;

-- Example 11796
SELECT DISTINCT diagnosis FROM doctor_view;
+--------------------+
| DIAGNOSIS          |
|--------------------|
| Industrial Disease |
| python bite        |
+--------------------+

-- Example 11797
SELECT treatment, cost 
    FROM doctor_view AS dv, accountant_view AS av
    WHERE av.patient_ID = dv.patient_ID;
+---------------------------+----------+
| TREATMENT                 |     COST |
|---------------------------+----------|
| a week of peace and quiet |  2000.00 |
| anti-venom                | 70000.00 |
+---------------------------+----------+

-- Example 11798
CREATE VIEW v1 AS SELECT ... FROM my_database.my_schema.my_table;

CREATE VIEW v1 AS SELECT ... FROM my_schema.my_table;

CREATE VIEW v1 AS SELECT ... FROM my_table;

-- Example 11799
CREATE VIEW employee_hierarchy (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
   WITH RECURSIVE employee_hierarchy_cte (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_cte.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_cte.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_cte
       WHERE employee_hierarchy_cte.employee_ID = employees.manager_ID
   )
   SELECT * 
      FROM employee_hierarchy_cte
);

-- Example 11800
CREATE RECURSIVE VIEW employee_hierarchy_02 (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_02.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_02.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_02
        WHERE employee_hierarchy_02.employee_ID = employees.manager_ID
);

-- Example 11801
CREATE TABLE employees (id INTEGER, title VARCHAR);
INSERT INTO employees (id, title) VALUES
    (1, 'doctor'),
    (2, 'nurse'),
    (3, 'janitor')
    ;

CREATE VIEW doctors as SELECT * FROM employees WHERE title = 'doctor';
CREATE VIEW nurses as SELECT * FROM employees WHERE title = 'nurse';
CREATE VIEW medical_staff AS
    SELECT * FROM doctors
    UNION
    SELECT * FROM nurses
    ;

-- Example 11802
SELECT * 
    FROM medical_staff
    ORDER BY id;
+----+--------+
| ID | TITLE  |
|----+--------|
|  1 | doctor |
|  2 | nurse  |
+----+--------+

-- Example 11803
DELETE FROM hospital_table 
    WHERE cost > (SELECT AVG(cost) FROM accountant_view);

-- Example 11804
CREATE SECURE VIEW v CHANGE_TRACKING = TRUE AS SELECT col1, col2 FROM t;

-- Example 11805
ALTER VIEW v2 SET CHANGE_TRACKING = TRUE;

-- Example 11806
CREATE TABLE t (col1 STRING, col2 NUMBER) CHANGE_TRACKING = TRUE;

-- Example 11807
ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

-- Example 11808
-- Create a table to store the names and fees paid by members of a gym
CREATE OR REPLACE TABLE members (
  id number(8) NOT NULL,
  name varchar(255) default NULL,
  fee number(3) NULL
);

-- Create a stream to track changes to date in the MEMBERS table
CREATE OR REPLACE STREAM member_check ON TABLE members;

-- Create a table to store the dates when gym members joined
CREATE OR REPLACE TABLE signup (
  id number(8),
  dt DATE
  );

INSERT INTO members (id,name,fee)
VALUES
(1,'Joe',0),
(2,'Jane',0),
(3,'George',0),
(4,'Betty',0),
(5,'Sally',0);

INSERT INTO signup
VALUES
(1,'2018-01-01'),
(2,'2018-02-15'),
(3,'2018-05-01'),
(4,'2018-07-16'),
(5,'2018-08-21');

-- The stream records the inserted rows
SELECT * FROM member_check;

+----+--------+-----+-----------------+-------------------+------------------------------------------+
| ID | NAME   | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+--------+-----+-----------------+-------------------+------------------------------------------|
|  1 | Joe    |   0 | INSERT          | False             | d200504bf3049a7d515214408d9a804fd03b46cd |
|  2 | Jane   |   0 | INSERT          | False             | d0a551cecbee0f9ad2b8a9e81bcc33b15a525a1e |
|  3 | George |   0 | INSERT          | False             | b98ad609fffdd6f00369485a896c52ca93b92b1f |
|  4 | Betty  |   0 | INSERT          | False             | e554e6e68293a51d8e69d68e9b6be991453cc901 |
|  5 | Sally  |   0 | INSERT          | False             | c94366cf8a4270cf299b049af68a04401c13976d |
+----+--------+-----+-----------------+-------------------+------------------------------------------+

-- Apply a $90 fee to members who joined the gym after a free trial period ended:
MERGE INTO members m
  USING (
    SELECT id, dt
    FROM signup s
    WHERE DATEDIFF(day, '2018-08-15'::date, s.dt::DATE) < -30) s
    ON m.id = s.id
  WHEN MATCHED THEN UPDATE SET m.fee = 90;

SELECT * FROM members;

+----+--------+-----+
| ID | NAME   | FEE |
|----+--------+-----|
|  1 | Joe    |  90 |
|  2 | Jane   |  90 |
|  3 | George |  90 |
|  4 | Betty  |   0 |
|  5 | Sally  |   0 |
+----+--------+-----+

-- The stream records the updated FEE column as a set of inserts
-- rather than deletes and inserts because the stream contents
-- have not been consumed yet
SELECT * FROM member_check;

+----+--------+-----+-----------------+-------------------+------------------------------------------+
| ID | NAME   | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+--------+-----+-----------------+-------------------+------------------------------------------|
|  1 | Joe    |  90 | INSERT          | False             | 957e84b34ef0f3d957470e02bddccb027810892c |
|  2 | Jane   |  90 | INSERT          | False             | b00168a4edb9fb399dd5cc015e5f78cbea158956 |
|  3 | George |  90 | INSERT          | False             | 75206259362a7c89126b7cb039371a39d821f76a |
|  4 | Betty  |   0 | INSERT          | False             | 9b225bc2612d5e57b775feea01dd04a32ce2ad18 |
|  5 | Sally  |   0 | INSERT          | False             | 5a68f6296c975980fbbc569ce01033c192168eca |
+----+--------+-----+-----------------+-------------------+------------------------------------------+

-- Create a table to store member details in production
CREATE OR REPLACE TABLE members_prod (
  id number(8) NOT NULL,
  name varchar(255) default NULL,
  fee number(3) NULL
);

-- Insert the first batch of stream data into the production table
INSERT INTO members_prod(id,name,fee) SELECT id, name, fee FROM member_check WHERE METADATA$ACTION = 'INSERT';

-- The stream position is advanced
select * from member_check;

+----+------+-----+-----------------+-------------------+-----------------+
| ID | NAME | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|----+------+-----+-----------------+-------------------+-----------------|
+----+------+-----+-----------------+-------------------+-----------------+

-- Access and lock the stream
BEGIN;

-- Increase the fee paid by paying members
UPDATE members SET fee = fee + 15 where fee > 0;

+------------------------+-------------------------------------+
| number of rows updated | number of multi-joined rows updated |
|------------------------+-------------------------------------|
|                      3 |                                   0 |
+------------------------+-------------------------------------+

-- These changes are not visible because the change interval of the stream object starts at the current offset and ends at the current
-- transactional time point, which is the beginning time of the transaction
SELECT * FROM member_check;

+----+------+-----+-----------------+-------------------+-----------------+
| ID | NAME | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|----+------+-----+-----------------+-------------------+-----------------|
+----+------+-----+-----------------+-------------------+-----------------+

-- Commit changes
COMMIT;

-- The changes surface now because the stream object uses the current transactional time as the end point of the change interval that now
-- includes the changes in the source table
SELECT * FROM member_check;

+----+--------+-----+-----------------+-------------------+------------------------------------------+
| ID | NAME   | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+--------+-----+-----------------+-------------------+------------------------------------------|
|  1 | Joe    | 105 | INSERT          | True              | 123a45b67cd0e8f012345g01abcdef012345678a |
|  2 | Jane   | 105 | INSERT          | True              | 456b45b67cd1e8f123456g01ghijkl123456779b |
|  3 | George | 105 | INSERT          | True              | 567890c89de2f9g765438j20jklmn0234567890d |
|  1 | Joe    |  90 | DELETE          | True              | 123a45b67cd0e8f012345g01abcdef012345678a |
|  2 | Jane   |  90 | DELETE          | True              | 456b45b67cd1e8f123456g01ghijkl123456779b |
|  3 | George |  90 | DELETE          | True              | 567890c89de2f9g765438j20jklmn0234567890d |
+----+--------+-----+-----------------+-------------------+------------------------------------------+

-- Example 11809
-- Create a source table.
create or replace table t(id int, name string);

-- Create a standard stream on the source table.
create or replace  stream delta_s on table t;

-- Create an append-only stream on the source table.
create or replace  stream append_only_s on table t append_only=true;

-- Insert 3 rows into the source table.
insert into t values (0, 'charlie brown');
insert into t values (1, 'lucy');
insert into t values (2, 'linus');

-- Delete 1 of the 3 rows.
delete from t where id = '0';

-- The standard stream removes the deleted row.
select * from delta_s order by id;

+----+-------+-----------------+-------------------+------------------------------------------+
| ID | NAME  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+-------+-----------------+-------------------+------------------------------------------|
|  1 | lucy  | INSERT          | False             | 7b12c9ee7af9245497a27ac4909e4aa97f126b50 |
|  2 | linus | INSERT          | False             | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
+----+-------+-----------------+-------------------+------------------------------------------+

-- The append-only stream does not remove the deleted row.
select * from append_only_s order by id;

+----+---------------+-----------------+-------------------+------------------------------------------+
| ID | NAME          | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+---------------+-----------------+-------------------+------------------------------------------|
|  0 | charlie brown | INSERT          | False             | e83abf629af50ccf94d1e78c547bfd8079e68d00 |
|  1 | lucy          | INSERT          | False             | 7b12c9ee7af9245497a27ac4909e4aa97f126b50 |
|  2 | linus         | INSERT          | False             | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
+----+---------------+-----------------+-------------------+------------------------------------------+

-- Create a table to store the change data capture records in each of the streams.
create or replace  table t2(id int, name string, stream_type string default NULL);

-- Insert the records from the streams into the new table, advancing the offset of each stream.
insert into t2(id,name,stream_type) select id, name, 'delta stream' from delta_s;
insert into t2(id,name,stream_type) select id, name, 'append_only stream' from append_only_s;

-- Update a row in the source table.
update t set name = 'sally' where name = 'linus';

-- The standard stream records the update operation.
select * from delta_s order by id;

+----+-------+-----------------+-------------------+------------------------------------------+
| ID | NAME  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+-------+-----------------+-------------------+------------------------------------------|
|  2 | sally | INSERT          | True              | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
|  2 | linus | DELETE          | True              | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
+----+-------+-----------------+-------------------+------------------------------------------+

-- The append-only stream does not record the update operation.
select * from append_only_s order by id;

+----+------+-----------------+-------------------+-----------------+
| ID | NAME | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|----+------+-----------------+-------------------+-----------------|
+----+------+-----------------+-------------------+-----------------+

-- Example 11810
-- Create a staging table that stores raw JSON data
CREATE OR REPLACE TABLE data_staging (
  raw variant);

-- Create a stream on the staging table
CREATE OR REPLACE STREAM data_check ON TABLE data_staging;

-- Create 2 production tables to store transformed
-- JSON data in relational columns
CREATE OR REPLACE TABLE data_prod1 (
    id number(8),
    ts TIMESTAMP_TZ
    );

CREATE OR REPLACE TABLE data_prod2 (
    id number(8),
    color VARCHAR,
    num NUMBER
    );

-- Load JSON data into staging table
-- using COPY statement, Snowpipe,
-- or inserts

SELECT * FROM data_staging;

+--------------------------------------+
| RAW                                  |
|--------------------------------------|
| {                                    |
|   "id": 7077,                        |
|   "x1": "2018-08-14T20:57:01-07:00", |
|   "x2": [                            |
|     {                                |
|       "y1": "green",                 |
|       "y2": "35"                     |
|     }                                |
|   ]                                  |
| }                                    |
| {                                    |
|   "id": 7078,                        |
|   "x1": "2018-08-14T21:07:26-07:00", |
|   "x2": [                            |
|     {                                |
|       "y1": "cyan",                  |
|       "y2": "107"                    |
|     }                                |
|   ]                                  |
| }                                    |
+--------------------------------------+

--  Stream table shows inserted data
SELECT * FROM data_check;

+--------------------------------------+-----------------+-------------------+------------------------------------------+
| RAW                                  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|--------------------------------------+-----------------+-------------------|------------------------------------------|
| {                                    | INSERT          | False             | 789012e01ef4j3k890123k35mnopqr567890124j |
|   "id": 7077,                        |                 |                   |                                          |
|   "x1": "2018-08-14T20:57:01-07:00", |                 |                   |                                          |
|   "x2": [                            |                 |                   |                                          |
|     {                                |                 |                   |                                          |
|       "y1": "green",                 |                 |                   |                                          |
|       "y2": "35"                     |                 |                   |                                          |
|     }                                |                 |                   |                                          |
|   ]                                  |                 |                   |                                          |
| }                                    |                 |                   |                                          |
| {                                    | INSERT          | False             | 765432u89tk3l6y456789012rst7vx678912456k |
|   "id": 7078,                        |                 |                   |                                          |
|   "x1": "2018-08-14T21:07:26-07:00", |                 |                   |                                          |
|   "x2": [                            |                 |                   |                                          |
|     {                                |                 |                   |                                          |
|       "y1": "cyan",                  |                 |                   |                                          |
|       "y2": "107"                    |                 |                   |                                          |
|     }                                |                 |                   |                                          |
|   ]                                  |                 |                   |                                          |
| }                                    |                 |                   |                                          |
+--------------------------------------+-----------------+-------------------+------------------------------------------+

-- Access and lock the stream
BEGIN;

-- Transform and copy JSON elements into relational columns
-- in the production tables
INSERT INTO data_prod1 (id, ts)
SELECT t.raw:id, to_timestamp_tz(t.raw:x1)
FROM data_check t
WHERE METADATA$ACTION = 'INSERT';

INSERT INTO data_prod2 (id, color, num)
SELECT t.raw:id, f.value:y1, f.value:y2
FROM data_check t
, lateral flatten(input => raw:x2) f
WHERE METADATA$ACTION = 'INSERT';

-- Commit changes in the stream objects participating in the transaction
COMMIT;

SELECT * FROM data_prod1;

+------+---------------------------+
|   ID | TS                        |
|------+---------------------------|
| 7077 | 2018-08-14 20:57:01 -0700 |
| 7078 | 2018-08-14 21:07:26 -0700 |
+------+---------------------------+

SELECT * FROM data_prod2;

+------+-------+-----+
|   ID | COLOR | NUM |
|------+-------+-----|
| 7077 | green |  35 |
| 7078 | cyan  | 107 |
+------+-------+-----+

SELECT * FROM data_check;

+-----+-----------------+-------------------+
| RAW | METADATA$ACTION | METADATA$ISUPDATE |
|-----+-----------------+-------------------|
+-----+-----------------+-------------------+

-- Example 11811
-- Create multiple tables with matching column values.
CREATE TABLE birds (
  id number,
  common varchar(100),
  class varchar(100)
);

CREATE TABLE sightings (
  d date,
  loc varchar(100),
  b_id number,
  c number
);

-- Create a view that queries the tables with a join.
CREATE VIEW bird_sightings AS
SELECT b.id AS id,
       b.common AS common_name,
       b.class AS classification,
       s.d AS date,
       s.loc AS location,
       s.c AS count
FROM birds b
INNER JOIN sightings s ON b.id = s.b_id;

-- Create a stream on the view.
CREATE STREAM bird_sightings_s ON VIEW bird_sightings;

-- Insert values into the tables.
INSERT INTO birds
VALUES
    (1,'Scarlet Tanager','P. olivacea'),
    (14,'Mallard','A. platyrhynchos'),
    (48,'Spotted Sandpiper','A. macularius'),
    (92,'Great Blue Heron','A. herodias');

INSERT INTO sightings
VALUES
    (current_date(),'Gibson Island',1,4),
    (current_date(),'Lake Los Pajaro',14,12),
    (current_date(),'Lake Los Pajaro',92,12),
    (current_date(),'Gibson Island',14,21),
    (current_date(),'Gibson Island',92,5);

-- Query the stream.
-- The stream displays a record for each row added to the view.
SELECT * FROM bird_sightings_s;

+----+------------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+
| ID | COMMON_NAME      | CLASSIFICATION   | DATE       | LOCATION        | COUNT | METADATA$ROW_ID                          | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------|
|  1 | Scarlet Tanager  | P. olivacea      | 2021-09-07 | Gibson Island   |     4 | a2522b47726ac2a922104c8e2f668d065ff6fcd0 | INSERT          | False             |
| 14 | Mallard          | A. platyrhynchos | 2021-09-07 | Lake Los Pajaro |    12 | fceb4ad5cb6d2df2865d0f572b8a2aa98f240b70 | INSERT          | False             |
| 92 | Great Blue Heron | A. herodias      | 2021-09-07 | Lake Los Pajaro |    12 | 0db99176fe8bd50749b2b48fb2befab416ff9272 | INSERT          | False             |
| 14 | Mallard          | A. platyrhynchos | 2021-09-07 | Gibson Island   |    21 | 2e94ef3a33e52ba5de5d816dc41c60fedf9cb1eb | INSERT          | False             |
| 92 | Great Blue Heron | A. herodias      | 2021-09-07 | Gibson Island   |     5 | a1df477ac8e388e1cf0ada77e9097c6effa346a7 | INSERT          | False             |
+----+------------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+

-- Consume the stream records in a DML statement (INSERT, MERGE, etc.).

-- Query the stream.
-- The stream is empty.
+----+-------------+----------------+------+----------+-------+-----------------+-----------------+-------------------+
| ID | COMMON_NAME | CLASSIFICATION | DATE | LOCATION | COUNT | METADATA$ROW_ID | METADATA$ACTION | METADATA$ISUPDATE |
|----+-------------+----------------+------+----------+-------+-----------------+-----------------+-------------------|
+----+-------------+----------------+------+----------+-------+-----------------+-----------------+-------------------+

-- Delete a row from the birds table.
DELETE FROM birds WHERE id = 14;

-- Query the stream.
-- The stream displays two records for the single DELETE operation.
SELECT * FROM bird_sightings_s;

+----+-------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+
| ID | COMMON_NAME | CLASSIFICATION   | DATE       | LOCATION        | COUNT | METADATA$ROW_ID                          | METADATA$ACTION | METADATA$ISUPDATE |
|----+-------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------|
| 14 | Mallard     | A. platyrhynchos | 2021-09-07 | Lake Los Pajaro |    12 | 83c22ff4be80d65a2e9776df0e35b22079cb4430 | DELETE          | False             |
| 14 | Mallard     | A. platyrhynchos | 2021-09-07 | Gibson Island   |    21 | e29cfae8c3c7d261ed903c2303f61e4d49c01ba1 | DELETE          | False             |
+----+-------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+

-- Example 11812
-- Create a table.
CREATE TABLE ndf (
  c1 number
);

-- Create a view that queries the table and
-- also returns the CURRENT_USER and CURRENT_TIMESTAMP values
-- for the query transaction.
CREATE VIEW ndf_v AS
SELECT CURRENT_USER() AS u,
       CURRENT_TIMESTAMP() AS ts,
       c1 AS num
FROM ndf;

-- Create a stream on the view.
CREATE STREAM ndf_s ON VIEW ndf_v;

-- User peter inserts rows into table ndf.
INSERT INTO ndf
VALUES
    (1),
    (2),
    (3);

-- User marie inserts rows into table ndf.
INSERT INTO ndf
VALUES
    (4),
    (5),
    (6);

-- User PETER queries the stream.
-- The stream returns the username for the user.
-- The stream also returns the current timestamp for the query transaction in each row,
-- NOT the timestamp when each row was inserted.
SELECT * FROM ndf_s;

+-------+-------------------------------+-----+-----------------+------------------------------------------+
| U     | TS                            | NUM | METADATA$ACTION | METADATA$ROW_ID                          |
|-------+-------------------------------+-----+-----------------+------------------------------------------|
| PETER | 2021-08-16 11:56:33.778 -0700 |   1 | INSERT          | d200504bf3049a7d515214408d9a804fd03b46cd |
| PETER | 2021-08-16 11:56:33.778 -0700 |   2 | INSERT          | d0a551cecbee0f9ad2b8a9e81bcc33b15a525a1e |
| PETER | 2021-08-16 11:56:33.778 -0700 |   3 | INSERT          | b98ad609fffdd6f00369485a896c52ca93b92b1f |
| PETER | 2021-08-16 11:56:33.778 -0700 |   4 | INSERT          | 62d34abc3fac85c037fb9f47f7758f08d025d9ed |
| PETER | 2021-08-16 11:56:33.778 -0700 |   5 | INSERT          | e554e6e68293a51d8e69d68e9b6be991453cc901 |
| PETER | 2021-08-16 11:56:33.778 -0700 |   6 | INSERT          | f6fa32c498a28b2349d2c6f6be55c30eb1d5310f |
+-------+-------------------------------+-----+-----------------+------------------------------------------+

-- User MARIE queries the stream.
-- The stream returns the username for the user
-- and the current timestamp for the query transaction in each row.
SELECT * FROM ndf_s;
+-------+-------------------------------+-----+-----------------+------------------------------------------+
| U     | TS                            | NUM | METADATA$ACTION | METADATA$ROW_ID                          |
|-------+-------------------------------+-----+-----------------+------------------------------------------|
| MARIE | 2021-08-16 12:04:21.768 -0700 |   1 | INSERT          | d200504bf3049a7d515214408d9a804fd03b46cd |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   2 | INSERT          | d0a551cecbee0f9ad2b8a9e81bcc33b15a525a1e |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   3 | INSERT          | b98ad609fffdd6f00369485a896c52ca93b92b1f |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   4 | INSERT          | 62d34abc3fac85c037fb9f47f7758f08d025d9ed |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   5 | INSERT          | e554e6e68293a51d8e69d68e9b6be991453cc901 |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   6 | INSERT          | f6fa32c498a28b2349d2c6f6be55c30eb1d5310f |
+-------+-------------------------------+-----+-----------------+------------------------------------------+

-- Example 11813
BEGIN [ { WORK | TRANSACTION } ] [ NAME <name> ]

START TRANSACTION [ NAME <name> ]

-- Example 11814
BEGIN;
BEGIN;    -- Ignored!
INSERT INTO table1 ...;
BEGIN;    -- Ignored!
INSERT INTO table2 ...;
COMMIT;

-- Example 11815
BEGIN;

SHOW TRANSACTIONS;

+---------------+--------+--------------+--------------------------------------+-------------------------------+---------+
|            id | user   |      session | name                                 | started_on                    | state   |
|---------------+--------+--------------+--------------------------------------+-------------------------------+---------|
| 1530042321085 | USER1  | 223347060798 | 56cb9163-77a3-4223-b3e0-aa24a20540a3 | 2018-06-26 12:45:21.085 -0700 | running |
+---------------+--------+--------------+--------------------------------------+-------------------------------+---------+

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------|
| 1530042321085         |
+-----------------------+

-- Example 11816
BEGIN NAME T1;

SHOW TRANSACTIONS;

+---------------+--------+--------------+------+-------------------------------+---------+
|            id | user   |      session | name | started_on                    | state   |
|---------------+--------+--------------+------+-------------------------------+---------|
| 1530042377426 | USER1  | 223347060798 | T1   | 2018-06-26 12:46:17.426 -0700 | running |
+---------------+--------+--------------+------+-------------------------------+---------+

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------|
| 1530042377426         |
+-----------------------+

-- Example 11817
START TRANSACTION NAME T2;

SHOW TRANSACTIONS;

+---------------+--------+--------------+------+-------------------------------+---------+
|            id | user   |      session | name | started_on                    | state   |
|---------------+--------+--------------+------+-------------------------------+---------|
| 1530042467963 | USER1  | 223347060798 | T2   | 2018-06-26 12:47:47.963 -0700 | running |
+---------------+--------+--------------+------+-------------------------------+---------+

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------|
| 1530042467963         |
+-----------------------+

-- Example 11818
COMMIT [ WORK ]

-- Example 11819
BEGIN;
INSERT INTO table1 ...;
COMMIT;
COMMIT;  -- Ignored!

-- Example 11820
SELECT COUNT(*) FROM A1;

+----------+
| COUNT(*) |
|----------+
|        0 |
+----------+

BEGIN NAME T3;

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------+
| 1432071497832         |
+-----------------------+

INSERT INTO A1 VALUES (1), (2);

+-------------------------+
| number of rows inserted |
|-------------------------+
|                       2 |
+-------------------------+

COMMIT;

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------+
| [NULL]                |
+-----------------------+

SELECT LAST_TRANSACTION();

+--------------------+
| LAST_TRANSACTION() |
|--------------------+
| 1432071497832      |
+--------------------+

SELECT COUNT(*) FROM A1;

+----------+
| COUNT(*) |
|----------+
|        2 |
+----------+

-- Example 11821
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 11822
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 11823
DESC STORAGE INTEGRATION <integration_name>;

-- Example 11824
az group create --name <resource_group_name> --location <location>

-- Example 11825
az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

-- Example 11826
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind BlobStorage --access-tier Hot

-- Example 11827
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind StorageV2

-- Example 11828
az storage queue create --name <storage_queue_name> --account-name <storage_account_name>

-- Example 11829
export storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queueid="$queuestorageid/queueservices/default/queues/<storage_queue_name>"

-- Example 11830
set storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queueid="%queuestorageid%/queueservices/default/queues/<storage_queue_name>"

-- Example 11831
az extension add --name eventgrid

-- Example 11832
az eventgrid event-subscription create \
--source-resource-id $storageid \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint $queueid \
--advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit DeleteBlob DeleteFile SftpRemove

-- Example 11833
az eventgrid event-subscription create \
--source-resource-id %storageid% \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint %queueid% \
-advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit DeleteBlob DeleteFile SftpRemove

-- Example 11834
https://<storage_account_name>.queue.core.windows.net/<storage_queue_name>

-- Example 11835
CREATE NOTIFICATION INTEGRATION <integration_name>
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_URL>'
  AZURE_TENANT_ID = '<directory_ID>';

-- Example 11836
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://myqueue.queue.core.windows.net/mystoragequeue'
  AZURE_TENANT_ID = 'a123bcde-1234-5678-abc1-9abc12345678';

-- Example 11837
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 11838
USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/mycontainer/files/'
  STORAGE_INTEGRATION = my_storage_int;

