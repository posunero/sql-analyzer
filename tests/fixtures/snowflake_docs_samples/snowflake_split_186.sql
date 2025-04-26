-- Example 12442
ALTER TAG security UNSET MASKING POLICY ssn_mask;

ALTER TAG security SET MASKING POLICY ssn_mask_2;

-- Example 12443
ALTER TAG security SET MASKING POLICY ssn_mask_2 FORCE;

-- Example 12444
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 12445
USE ROLE tag_admin;
USE SCHEMA governance.tags;
CREATE OR REPLACE TAG accounting;

-- Example 12446
USE ROLE masking_admin;
USE SCHEMA governance.masking_policies;

CREATE OR REPLACE MASKING POLICY account_name_mask
AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('ACCOUNTING_ADMIN') THEN val
    ELSE '***MASKED***'
  END;

-- Example 12447
CREATE OR REPLACE MASKING POLICY account_number_mask
AS (val number) RETURNS number ->
  CASE
    WHEN CURRENT_ROLE() IN ('ACCOUNTING_ADMIN') THEN val
    ELSE -1
  END;

-- Example 12448
ALTER TAG governance.tags.accounting SET
  MASKING POLICY account_name_mask,
  MASKING POLICY account_number_mask;

-- Example 12449
ALTER TABLE finance.accounting.name_number
  SET TAG governance.tags.accounting = 'tag-based policies';

-- Example 12450
USE ROLE masking_admin;
SELECT *
FROM TABLE (governance.INFORMATION_SCHEMA.POLICY_REFERENCES(
  REF_ENTITY_DOMAIN => 'TABLE',
  REF_ENTITY_NAME => 'governance.accounting.name_number' )
);

-- Example 12451
-------------+------------------+---------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+------------+---------------+
  POLICY_DB  | POLICY_SCHEMA    | POLICY_NAME         | POLICY_KIND    | REF_DATABASE_NAME | REF_SCHEMA_NAME | REF_ENTITY_NAME | REF_ENTITY_DOMAIN | REF_COLUMN_NAME | REF_ARG_COLUMN_NAMES | TAG_DATABASE | TAG_SCHEMA | TAG_NAME   | POLICY_STATUS |
-------------+------------------+---------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+------------+---------------+
  GOVERNANCE | MASKING_POLICIES | ACCOUNT_NAME_MASK   | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NAME    | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING | ACTIVE        |
  GOVERNANCE | MASKING_POLICIES | ACCOUNT_NUMBER_MASK | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NUMBER  | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING | ACTIVE        |
-------------+------------------+---------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+------------+---------------+

-- Example 12452
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 12453
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 12454
USE ROLE analyst;
SELECT * FROM finance.accounting.name_number;

-- Example 12455
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ***MASKED*** | -1             |
---------------+----------------+

-- Example 12456
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 12457
USE ROLE tag_admin;
USE SCHEMA governance.tags;
CREATE TAG accounting_col_string;

-- Example 12458
USE ROLE masking_admin;
USE SCHEMA governance.masking_policies;

CREATE MASKING POLICY account_name_mask_tag_string
AS (val string) RETURNS string ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col_string') = 'visible' THEN val
    ELSE '***MASKED***'
  END;

-- Example 12459
CREATE MASKING POLICY account_number_mask_tag_string
AS (val number) RETURNS number ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col_string') = 'visible' THEN val
    ELSE -1
  END;

-- Example 12460
ALTER TAG accounting_col_string SET
  MASKING POLICY account_name_mask_tag_string,
  MASKING POLICY account_number_mask_tag_string;

-- Example 12461
ALTER TABLE finance.accounting.name_number MODIFY COLUMN
  account_name SET TAG governance.tags.accounting_col_string = 'visible',
  account_number SET TAG governance.tags.accounting_col_string = 'protect';

-- Example 12462
SELECT *
FROM TABLE(
 governance.INFORMATION_SCHEMA.POLICY_REFERENCES(
   REF_ENTITY_DOMAIN => 'TABLE',
   REF_ENTITY_NAME => 'finance.accounting.name_number'
   )
);

-- Example 12463
------------+----------------+--------------------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+-----------------------+---------------+
 POLICY_DB  | POLICY_SCHEMA  | POLICY_NAME                    |  POLICY_KIND   | REF_DATABASE_NAME | REF_SCHEMA_NAME | REF_ENTITY_NAME | REF_ENTITY_DOMAIN | REF_COLUMN_NAME | REF_ARG_COLUMN_NAMES | TAG_DATABASE | TAG_SCHEMA | TAG_NAME              | POLICY_STATUS |
------------+----------------+--------------------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+-----------------------+---------------+
 GOVERNANCE | MASKING_POLICY | ACCOUNT_NAME_MASK_TAG_STRING   | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NAME    | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING_COL_STRING | ACTIVE        |
 GOVERNANCE | MASKING_POLICY | ACCOUNT_NUMBER_MASK_TAG_STRING | MASKING_POLICY | FINANCE           | ACCOUNTING      | NAME_NUMBER     | TABLE             | ACCOUNT_NUMBER  | NULL                 | GOVERNANCE   | TAGS       | ACCOUNTING_COL_STRING | ACTIVE        |
------------+----------------+--------------------------------+----------------+-------------------+-----------------+-----------------+-------------------+-----------------+----------------------+--------------+------------+-----------------------+---------------+

-- Example 12464
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 12465
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | -1             |
---------------+----------------+

-- Example 12466
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 12467
USE ROLE row_access_admin;
USE SCHEMA governance.row_access_policies;

CREATE ROW ACCESS POLICY rap_tag_value
AS (account_number number)
RETURNS BOOLEAN ->
SYSTEM$GET_TAG_ON_CURRENT_TABLE('tags.accounting_row_string') = 'visible'
AND
'accounting_admin' = CURRENT_ROLE();

-- Example 12468
ALTER TABLE finance.accounting.name_number
  ADD ROW ACCESS POLICY rap_tag_value ON (account_number);

-- Example 12469
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 12470
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
               |                |
---------------+----------------+

-- Example 12471
USE ROLE tag_admin;
USE SCHEMA governance.tags;
CREATE TAG accounting_row_string;

-- Example 12472
USE ROLE masking_admin;
USE SCHEMA governance.masking_policies;

CREATE MASKING POLICY account_name_mask AS (val string) RETURNS string ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_row_string') = 'visible' THEN val
    ELSE '***MASKED***'
  END;

-- Example 12473
CREATE MASKING POLICY account_number_mask AS (val number) RETURNS number ->
  CASE
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_row_string') = 'visible' THEN val
    ELSE -1
  END;

-- Example 12474
ALTER TAG governance.tags.accounting_row_string SET
  MASKING POLICY account_name_mask,
  MASKING POLICY account_number_mask;

-- Example 12475
ALTER TABLE finance.accounting.name_number
  SET TAG governance.tags.accounting_row_string = 'visible';

-- Example 12476
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 12477
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | 1000           |
---------------+----------------+

-- Example 12478
ALTER TABLE finance.accounting.name_number MODIFY COLUMN
  account_number SET TAG governance.tags.accounting_row_string = 'protect';

-- Example 12479
USE ROLE accounting_admin;
SELECT * FROM finance.accounting.name_number;

-- Example 12480
---------------+----------------+
  ACCOUNT_NAME | ACCOUNT_NUMBER |
---------------+----------------+
  ACME         | -1             |
---------------+----------------+

-- Example 12481
CREATE [ OR REPLACE ] TAG [ IF NOT EXISTS ] <name> [ COMMENT = '<string_literal>' ]

CREATE [ OR REPLACE ] TAG [ IF NOT EXISTS ] <name>
    [ ALLOWED_VALUES '<val_1>' [ , '<val_2>' [ , ... ] ] ]
    [ COMMENT = '<string_literal>' ]

-- Example 12482
CREATE OR ALTER TAG <name>
  [ ALLOWED_VALUES '<val_1>' [ , '<val_2>' [ , ... ] ] ]
  [ COMMENT = '<string_literal>' ]

-- Example 12483
CREATE TAG cost_center COMMENT = 'cost_center tag';

-- Example 12484
CREATE OR ALTER TAG cost_center ALLOWED_VALUES 'finance', 'engineering', 'sales';

-- Example 12485
DROP TAG [ IF EXISTS ] <name>

-- Example 12486
DROP TAG cost_center;

-- Example 12487
UNDROP TAG <name>

-- Example 12488
UNDROP TAG cost_center;

-- Example 12489
ALTER TAG [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER TAG [ IF EXISTS ] <name> { ADD | DROP } ALLOWED_VALUES '<val_1>' [ , '<val_2>' [ , ... ] ]

ALTER TAG [ IF EXISTS ]<name> UNSET ALLOWED_VALUES

ALTER TAG [ IF EXISTS ] <name> SET MASKING POLICY <masking_policy_name> [ , MASKING POLICY <masking_policy_2_name> , ... ]
                                                          [ FORCE ]

ALTER TAG [ IF EXISTS ] <name> UNSET MASKING POLICY <masking_policy_name> [ , MASKING POLICY <masking_policy_2_name> , ... ]

ALTER TAG [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER TAG [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12490
ALTER TAG cost_center RENAME TO cost_center_na;

-- Example 12491
CREATE [ OR REPLACE ] <integration_type> INTEGRATION [ IF NOT EXISTS ] <object_name>
  [ <integration_type_params> ]
  [ COMMENT = '<string_literal>' ]

-- Example 12492
ALTER <integration_type> INTEGRATION <object_name> <actions>

-- Example 12493
ALTER SHARE [ IF EXISTS ] <name> { ADD | REMOVE } ACCOUNTS = <consumer_account> [ , <consumer_account> , ... ]
                                        [ SHARE_RESTRICTIONS = { TRUE | FALSE } ]

ALTER SHARE [ IF EXISTS ] <name> SET { [ ACCOUNTS = <consumer_account> [ , <consumer_account> ... ] ]
                                       [ COMMENT = '<string_literal>' ] }

ALTER SHARE [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER SHARE <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER SHARE [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12494
ALTER SHARE sales_s ADD ACCOUNTS=<orgname.accountname1>,<orgname.accountname2>;

+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 12495
ALTER SHARE sales_s REMOVE ACCOUNT=<orgname.accountname>;

+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 12496
GRANT MANAGE SHARE TARGET ON ACCOUNT TO ROLE <role_name>;

GRANT ROLE <role_name> TO USER <user_name>;

USE ROLE <role_name>;

ALTER SHARE <data_share_name> ADD ACCOUNTS = <orgname.accountname1>,<orgname.accountname2>;

-- Example 12497
ALTER SHARE sales_s SET COMMENT='This share contains sales data for 2017';

+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 12498
ALTER DATABASE ROLE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER DATABASE ROLE [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER DATABASE ROLE [ IF EXISTS ] <name> UNSET COMMENT

ALTER DATABASE ROLE [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER DATABASE ROLE [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12499
ALTER DATABASE ROLE d1.dr1 RENAME TO d1.dbr2;

-- Example 12500
ALTER DATABASE ROLE d1.dbr2 SET COMMENT = 'New comment for database role';

-- Example 12501
ALTER SNOWFLAKE.CORE.BUDGET [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER SNOWFLAKE.CORE.BUDGET [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER SNOWFLAKE.CORE.BUDGET [ IF EXISTS ] <name> UNSET COMMENT

ALTER SNOWFLAKE.CORE.BUDGET [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER SNOWFLAKE.CORE.BUDGET [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12502
ALTER SNOWFLAKE.CORE.BUDGET my_budget SET TAG dept = 'finance';

-- Example 12503
ALTER SNOWFLAKE.ML.CLASSIFICATION [ IF EXISTS ] <name>
    RENAME TO '<new_model_name>';

-- Example 12504
ALTER SNOWFLAKE.ML.CLASSIFICATION  [ IF EXISTS ] <name>
    SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ];

-- Example 12505
ALTER SNOWFLAKE.ML.CLASSIFICATION [ IF EXISTS ] <name>
    SET COMMENT = '<string_literal>';

-- Example 12506
ALTER SNOWFLAKE.ML.CLASSIFICATION [ IF EXISTS ] <name>
    UNSET TAG <tag_name> [ , <tag_name> ... ];

-- Example 12507
ALTER SNOWFLAKE.ML.CLASSIFICATION [ IF EXISTS ] <name>
    UNSET COMMENT;

-- Example 12508
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) RENAME TO <new_name>

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET SECURE

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET { SECURE | LOG_LEVEL | TRACE_LEVEL | COMMENT }

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <integration_name> [ , <integration_name> ... ] ) ]
  [ SECRETS = ( '<secret_variable_name>' = <secret_name> [ , '<secret_variable_name>' = <secret_name> ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) UNSET TAG <tag_name> [ , <tag_name> ... ]

