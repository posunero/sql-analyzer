-- Example 10566
+-----------+---------------------------------------------------------------------+
| property  | value                                                               |
+-----------+---------------------------------------------------------------------+
| signature | (ARG_T TABLE(ARG_C1 NUMBER, ARG_C2 NUMBER, ARG_C3 NUMBER))          |
| returns   | NUMBER(38,0)                                                        |
| language  | SQL                                                                 |
| body      | SELECT COUNT(*) FROM arg_t WHERE arg_c1>0 AND arg_c2>0 AND arg_c3>0 |
+-----------+---------------------------------------------------------------------+

-- Example 10567
ALTER FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(NUMBER, NUMBER, NUMBER))
  SET TAG governance.tags.quality = 'counts';

-- Example 10568
DROP FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(
    NUMBER, NUMBER, NUMBER
  )
);

-- Example 10569
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = '5 MINUTE';

-- Example 10570
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * * UTC';

-- Example 10571
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * MON,TUE,WED,THU,FRI UTC';

-- Example 10572
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 6,12,18 * * * UTC';

-- Example 10573
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES';

-- Example 10574
SHOW PARAMETERS LIKE 'DATA_METRIC_SCHEDULE' IN TABLE hr.tables.empl_info;

-- Example 10575
+----------------------+--------------------------------+---------+-------+------------------------------------------------------------------------------------------------------------------------------+--------+
| key                  | value                          | default | level | description                                                                                                                  | type   |
+----------------------+--------------------------------+---------+-------+------------------------------------------------------------------------------------------------------------------------------+--------+
| DATA_METRIC_SCHEDULE | USING CRON 0 6,12,18 * * * UTC |         | TABLE | Specify the schedule that data metric functions associated to the table must be executed in order to be used for evaluation. | STRING |
+----------------------+--------------------------------+---------+-------+------------------------------------------------------------------------------------------------------------------------------+--------+

-- Example 10576
SHOW PARAMETERS LIKE 'DATA_METRIC_SCHEDULE' IN TABLE mydb.public.my_view;

-- Example 10577
ALTER TABLE t
  ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.NULL_COUNT
    ON (c1);

-- Example 10578
ALTER TABLE t
  DROP DATA METRIC FUNCTION governance.dmfs.count_positive_numbers
    ON (c1, c2, c3);

-- Example 10579
SELECT <data_metric_function>(<query>)

-- Example 10580
SELECT governance.dmfs.count_positive_numbers(
  SELECT c1, c2, c3
  FROM t);

-- Example 10581
SELECT SNOWFLAKE.CORE.NULL_COUNT(
  SELECT ssn
  FROM hr.tables.empl_info);

-- Example 10582
USE ROLE ACCOUNTADMIN;
GRANT APPLICATION ROLE SNOWFLAKE.DATA_QUALITY_MONITORING_VIEWER TO ROLE analyst;

-- Example 10583
SELECT *
  FROM TABLE(SYSTEM$DATA_METRIC_SCAN(
    REF_ENTITY_NAME  => 'governance.sch.employeesTable'
    ,METRIC_NAME  => 'snowflake.core.null_count'
    ,ARGUMENT_NAME => 'SSN'
    ,AT_TIMESTAMP => '2024-08-28 02:00:00 -0700'
  ));

-- Example 10584
UPDATE T
  SET email = null
  WHERE T.ID IN (SELECT ID FROM TABLE(SYSTEM$DATA_METRIC_SCAN(
    REF_ENTITY_NAME => 't'
    ,METRIC_NAME => 'snowflake.core.blank_count'
    ,ARGUMENT_NAME => 'email'
  )));

-- Example 10585
SHOW DATA METRIC FUNCTIONS IN ACCOUNT;

-- Example 10586
USE DATABASE governance;
USE SCHEMA INFORMATION_SCHEMA;
SELECT *
  FROM TABLE(
    INFORMATION_SCHEMA.DATA_METRIC_FUNCTION_REFERENCES(
      METRIC_NAME => 'governance.dmfs.count_positive_numbers'
    )
  );

-- Example 10587
USE DATABASE governance;
USE SCHEMA INFORMATION_SCHEMA;
SELECT *
  FROM TABLE(
    INFORMATION_SCHEMA.DATA_METRIC_FUNCTION_REFERENCES(
      REF_ENTITY_NAME => 'hr.tables.empl_info',
      REF_ENTITY_DOMAIN => 'table'
    )
  );

-- Example 10588
USE ROLE ACCOUNTADMIN;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE data_engineer;

GRANT APPLY TAG ON ACCOUNT TO ROLE data_engineer;

-- Example 10589
USE ROLE ACCOUNTADMIN;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE schema_owner;

GRANT APPLY ON TAG governance.tags.schema_mask TO ROLE schema_owner;

-- Example 10590
USE ROLE SECURITYADMIN;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE tag_admin;

-- Example 10591
ALTER TAG security UNSET MASKING POLICY ssn_mask;

ALTER TAG security SET MASKING POLICY ssn_mask_2;

-- Example 10592
ALTER TAG security SET MASKING POLICY ssn_mask_2 FORCE;

-- Example 10593
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 10594
USE ROLE tag_admin;
USE SCHEMA governance.tags;
CREATE OR REPLACE TAG accounting;

-- Example 10595
USE ROLE masking_admin;
USE SCHEMA governance.masking_policies;

CREATE OR REPLACE MASKING POLICY account_name_mask
AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('ACCOUNTING_ADMIN') THEN val
    ELSE '***MASKED***'
  END;

-- Example 10596
CREATE OR REPLACE MASKING POLICY account_number_mask
AS (val number) RETURNS number ->
  CASE
    WHEN CURRENT_ROLE() IN ('ACCOUNTING_ADMIN') THEN val
    ELSE -1
  END;

-- Example 10597
ALTER TAG governance.tags.accounting SET
  MASKING POLICY account_name_mask,
  MASKING POLICY account_number_mask;

-- Example 10598
ALTER TABLE finance.accounting.name_number
  SET TAG governance.tags.accounting = 'tag-based policies';

-- Example 10599
USE ROLE masking_admin;
SELECT *
FROM TABLE (governance.INFORMATION_SCHEMA.POLICY_REFERENCES(
  REF_ENTITY_DOMAIN => 'TABLE',
  REF_ENTITY_NAME => 'governance.accounting.name_number' )
);

-- Example 10600
-------------+------------------+---------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+------------+---------------+
  POLICY_DB  | POLICY_SCHEMA    | POLICY_NAME         | POLICY_KIND    | REF_DATABASE_NAME | REF_SCHEMA_NAME | REF_ENTITY_NAME | REF_ENTITY_DOMAIN | REF_COLUMN_NAME | REF_ARG_COLUMN_NAMES | TAG_DATABASE | TAG_SCHEMA | TAG_NAME   | POLICY_STATUS |
-------------+------------------+---------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+------------+---------------+
  GOVERNANCE | MASKING_POLICIES | ACCOUNT_NAME_MASK   | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NAME    | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING | ACTIVE        |
  GOVERNANCE | MASKING_POLICIES | ACCOUNT_NUMBER_MASK | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NUMBER  | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING | ACTIVE        |
-------------+------------------+---------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+------------+---------------+

-- Example 10601
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 10602
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 10603
USE ROLE analyst;
SELECT * FROM finance.accounting.name_number;

-- Example 10604
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ***MASKED*** | -1             |
---------------+----------------+

-- Example 10605
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 10606
USE ROLE tag_admin;
USE SCHEMA governance.tags;
CREATE TAG accounting_col_string;

-- Example 10607
USE ROLE masking_admin;
USE SCHEMA governance.masking_policies;

CREATE MASKING POLICY account_name_mask_tag_string
AS (val string) RETURNS string ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col_string') = 'visible' THEN val
    ELSE '***MASKED***'
  END;

-- Example 10608
CREATE MASKING POLICY account_number_mask_tag_string
AS (val number) RETURNS number ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col_string') = 'visible' THEN val
    ELSE -1
  END;

-- Example 10609
ALTER TAG accounting_col_string SET
  MASKING POLICY account_name_mask_tag_string,
  MASKING POLICY account_number_mask_tag_string;

-- Example 10610
ALTER TABLE finance.accounting.name_number MODIFY COLUMN
  account_name SET TAG governance.tags.accounting_col_string = 'visible',
  account_number SET TAG governance.tags.accounting_col_string = 'protect';

-- Example 10611
SELECT *
FROM TABLE(
 governance.INFORMATION_SCHEMA.POLICY_REFERENCES(
   REF_ENTITY_DOMAIN => 'TABLE',
   REF_ENTITY_NAME => 'finance.accounting.name_number'
   )
);

-- Example 10612
------------+----------------+--------------------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+-----------------------+---------------+
 POLICY_DB  | POLICY_SCHEMA  | POLICY_NAME                    |  POLICY_KIND   | REF_DATABASE_NAME | REF_SCHEMA_NAME | REF_ENTITY_NAME | REF_ENTITY_DOMAIN | REF_COLUMN_NAME | REF_ARG_COLUMN_NAMES | TAG_DATABASE | TAG_SCHEMA | TAG_NAME              | POLICY_STATUS |
------------+----------------+--------------------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+-----------------------+---------------+
 GOVERNANCE | MASKING_POLICY | ACCOUNT_NAME_MASK_TAG_STRING   | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NAME    | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING_COL_STRING | ACTIVE        |
 GOVERNANCE | MASKING_POLICY | ACCOUNT_NUMBER_MASK_TAG_STRING | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NUMBER  | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING_COL_STRING | ACTIVE        |
------------+----------------+--------------------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+-----------------------+---------------+

-- Example 10613
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 10614
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | -1             |
---------------+----------------+

-- Example 10615
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 10616
USE ROLE row_access_admin;
USE SCHEMA governance.row_access_policies;

CREATE ROW ACCESS POLICY rap_tag_value
AS (account_number number)
RETURNS BOOLEAN ->
SYSTEM$GET_TAG_ON_CURRENT_TABLE('tags.accounting_row_string') = 'visible'
AND
'accounting_admin' = CURRENT_ROLE();

-- Example 10617
ALTER TABLE finance.accounting.name_number
  ADD ROW ACCESS POLICY rap_tag_value ON (account_number);

-- Example 10618
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 10619
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
               |                |
---------------+----------------+

-- Example 10620
USE ROLE tag_admin;
USE SCHEMA governance.tags;
CREATE TAG accounting_row_string;

-- Example 10621
USE ROLE masking_admin;
USE SCHEMA governance.masking_policies;

CREATE MASKING POLICY account_name_mask AS (val string) RETURNS string ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_row_string') = 'visible' THEN val
    ELSE '***MASKED***'
  END;

-- Example 10622
CREATE MASKING POLICY account_number_mask AS (val number) RETURNS number ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_row_string') = 'visible' THEN val
    ELSE -1
  END;

-- Example 10623
ALTER TAG governance.tags.accounting_row_string SET
  MASKING POLICY account_name_mask,
  MASKING POLICY account_number_mask;

-- Example 10624
ALTER TABLE finance.accounting.name_number
  SET TAG governance.tags.accounting_row_string = 'visible';

-- Example 10625
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 10626
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 10627
ALTER TABLE finance.accounting.name_number MODIFY COLUMN
  account_number SET TAG governance.tags.accounting_row_string = 'protect';

-- Example 10628
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 10629
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | -1             |
---------------+----------------+

-- Example 10630
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

-- Example 10631
CREATE MASKING POLICY email_mask AS
(val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('PAYROLL') THEN val
    ELSE '******'
  END;

-- Example 10632
CREATE MASKING POLICY email_visibility AS
(email varchar, visibility string) RETURNS varchar ->
  CASE
    WHEN CURRENT_ROLE() = 'ADMIN' THEN email
    WHEN VISIBILITY = 'PUBLIC' THEN email
    ELSE '***MASKED***'
  END;

