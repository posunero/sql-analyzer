-- Example 15524
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1;

-- Example 15525
+---------------------------------------------------------+
| status                                                  |
|---------------------------------------------------------|
| Application 'hello_snowflake_app' created successfully. |
+---------------------------------------------------------+

-- Example 15526
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING '@hello_snowflake_code.core.hello_snowflake_stage';

-- Example 15527
+---------------------------------------------------------+
| status                                                  |
|---------------------------------------------------------|
| Application 'hello_snowflake_app' created successfully. |
+---------------------------------------------------------+

-- Example 15528
ALTER APPLICATION [ IF EXISTS ] <name> SET
  [ COMMENT = '<string-literal>' ]
  [ SHARE_EVENTS_WITH_PROVIDER = { TRUE | FALSE } ]
  [ DEBUG_MODE = { TRUE | FALSE } ]

ALTER APPLICATION [ IF EXISTS ] <name> UNSET
  [ COMMENT ]
  [ SHARE_EVENTS_WITH_PROVIDER ]
  [ DEBUG_MODE ]

ALTER APPLICATION [ IF EXISTS ] <name> RENAME TO <new_app_name>

ALTER APPLICATION <name> UPGRADE

ALTER APPLICATION <name> UPGRADE USING VERSION <version_name> [ PATCH <patch_num> ]

ALTER APPLICATION <name> UPGRADE USING <path_to_stage>

ALTER APPLICATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER APPLICATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER APPLICATION <name> UNSET REFERENCES[ ( '<reference_name>' [ , '<reference_alias>' ] ) ]

ALTER APPLICATION <name> SET SHARED TELEMETRY EVENTS ('<event_definition' [ , <event_definition>, ...])

ALTER APPLICATION <name> SET AUTHORIZE_TELEMETRY_EVENT_SHARING = { TRUE | FALSE }

-- Example 15529
DESC[RIBE] APPLICATION <name>

-- Example 15530
DESC APPLICATION hello_snowflake_app;

-- Example 15531
+------------------------------------+-------------------------------+
| property                           | value                         |
|------------------------------------+-------------------------------|
| name                               | hello_snowflake_app           |
| source_organization                | my_organization               |
| source_account                     | provider_account              |
| source_type                        | APPLICATION PACKAGE           |
| source                             | hello_snowflake_package       |
| version                            | v1_0                          |
| version_label                      | NULL                          |
| patch                              | 0                             |
| created_on                         | 2024-05-25 08:30:41.520 -0700 |
| last_upgraded_on                   |                               |
| share_events_with_provider         | FALSE                         |
| authorize_telemetry_event_sharing  | FALSE                         |
| log_level                          | OFF                           |
| trace_level                        | OFF                           |
| debug_mode                         | FALSE                         |
| upgrade_state                      | COMPLETE                      |
| upgrade_target_version             | NULL                          |
| upgrade_target_patch               | 0                             |
| upgrade_attempt                    | NULL                          |
| upgrade_task_id                    | NULL                          |
| upgrade_started_on                 |                               |
| upgrade_attempted_on               |                               |
| upgrade_failure_type               | NULL                          |
| upgrade_failure_reason             | NULL                          |
| previous_version                   | NULL                          |
| previous_patch                     | 0                             |
| previous_version_state             | COMPLETE                      |
| comment                            |                               |
+------------------------------------+-------------------------------+

-- Example 15532
DROP APPLICATION [ IF EXISTS ] <name> [ CASCADE ]

-- Example 15533
DROP APPLICATION hello_snowflake_app;

-- Example 15534
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| hello_snowflake_app successfully dropped. |
+-------------------------------------------+

-- Example 15535
SHOW APPLICATIONS [ LIKE '<pattern>' ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ];

-- Example 15536
SHOW APPLICATIONS;

-- Example 15537
+-------------------------------+------------------------+------------+------------+---------------------+----------------------------+---------------+---------+---------------------+-----------------+-------+---------+----------------+
| created_on                    | name                   | is_default | is_current | source_type         | source                     | owner         | comment | version             | label           | patch | options | retention_time |
|-------------------------------+------------------------+------------+------------+---------------------+----------------------------+---------------+---------+---------------------+-----------------+-------+---------+----------------|
| 2023-02-03 10:14:09.828 -0800 | hello_snowflake_app    | N          | Y          | APPLICATION PACKAGE | hello_snowflake_package    | PROVIDER_ROLE |         | v1                  | Version v1      |     0 |         | 1              |
| 2023-03-22 16:12:40.373 -0700 | PRODUCTION_APP         | Y          | Y          | APPLICATION PACKAGE | hello_snowflake_package    | PROVIDER_ROLE |         | v2                  | Version v2      |     0 |         | 1              |
+-------------------------------+------------------------+------------+------------+---------------------+----------------------------+---------------+---------+---------------------+-----------------+-------+---------+----------------+

-- Example 15538
CREATE APPLICATION PACKAGE [ IF NOT EXISTS ] <name>
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , ... ] ) ]
  [ DISTRIBUTION = { INTERNAL | EXTERNAL } ]
  [ MULTIPLE_INSTANCES = TRUE ]
  [ ENABLE_RELEASE_CHANNELS = TRUE ]

-- Example 15539
CREATE APPLICATION PACKAGE hello_snowflake_package;

-- Example 15540
+-----------------------------------------------------------------------+
| status                                                                |
|-----------------------------------------------------------------------|
| Application Package 'hello_snowflake_package' created successfully.   |
+-----------------------------------------------------------------------+

-- Example 15541
ALTER APPLICATION PACKAGE [ IF EXISTS ] <name> SET
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ COMMENT = <string-literal> ]
  [ DISTRIBUTION = { INTERNAL | EXTERNAL } ]
  [ MULTIPLE_INSTANCES = TRUE ]
  [ ENABLE_RELEASE_CHANNELS = TRUE ]

ALTER APPLICATION PACKAGE [ IF EXISTS ] <name> UNSET
  [ DATA_RETENTION_TIME_IN_DAYS ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS ]
  [ DEFAULT_DDL_COLLATION ]
  [ COMMENT ]
  [ DISTRIBUTION ]

ALTER APPLICATION PACKAGE <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER APPLICATION PACKAGE <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 15542
ALTER APPLICATION PACKAGE hello_snowflake_package SET
  COMMENT = 'Altered the Hello Snowflake app.';

-- Example 15543
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| Statement executed successfully.          |
+-------------------------------------------+

-- Example 15544
DROP APPLICATION PACKAGE [ IF EXISTS ] <name>

-- Example 15545
DROP APPLICATION PACKAGE hello_snowflake_app;

-- Example 15546
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| hello_snowflake_app successfully dropped. |
+-------------------------------------------+

-- Example 15547
SHOW APPLICATION PACKAGES [ LIKE '<pattern>' ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ];

-- Example 15548
SHOW APPLICATION PACKAGES;

-- Example 15549
+-------------------------------+-------------------------+------------+------------+--------------+----------------+----------+---------+----------------+------------+-------------------+
| created_on                    | name                    | is_default | is_current | distribution | owner          | comment  | options | retention_time | dropped_on | application_class |
| 2023-06-02 16:28:31.371 -0700 | hello_snowflake_package | N          | N          | INTERNAL     | ACCOUNTADMIN   |          |         | 1              | NULL       | NULL              |
+-------------------------------+-------------------------+------------+------------+--------------+----------------+----------+---------+----------------+------------+-------------------+

-- Example 15550
ALTER APPLICATION ROLE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER APPLICATION ROLE [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER APPLICATION ROLE [ IF EXISTS ] <name> UNSET COMMENT

-- Example 15551
ALTER APPLICATION ROLE app_role RENAME TO new_app_role;

-- Example 15552
ALTER APPLICATION ROLE app_role SET
  COMMENT = 'Application role for the Hello Snowflake application.';

-- Example 15553
ALTER APPLICATION ROLE app_role UNSET COMMENT;

-- Example 15554
CREATE [ OR REPLACE ] APPLICATION ROLE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 15555
CREATE OR ALTER APPLICATION ROLE <name>
  [ COMMENT = '<string_literal>' ]

-- Example 15556
CREATE APPLICATION ROLE app_role
  COMMENT = 'Application role for the Hello Snowflake application.';

-- Example 15557
DROP APPLICATION ROLE [ IF EXISTS ] <name>

-- Example 15558
DROP APPLICATION ROLE APP_ROLE;

-- Example 15559
GRANT APPLICATION ROLE <name> TO  { ROLE <parent_role_name> | APPLICATION ROLE <application_role>  | APPLICATION <application_name>}

-- Example 15560
GRANT APPLICATION ROLE app_role to APPLICATION ROLE other_app_role;

-- Example 15561
REVOKE APPLICATION ROLE <name> FROM { ROLE <parent_role_name> | APPLICATION ROLE <application_role> | APPLICATION <application> }

-- Example 15562
REVOKE APPLICATION ROLE app_role FROM APPLICATION ROLE other_role;

-- Example 15563
SHOW APPLICATION ROLES IN APPLICATION <name>
  [ LIKE <pattern> ] [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 15564
SHOW APPLICATION ROLES IN APPLICATION hello_snowflake_app;

-- Example 15565
SHOW APPLICATION ROLES IN APPLICATION myapp LIMIT 10 FROM 'app_role2';

-- Example 15566
CREATE OR ALTER VERSIONED SCHEMA <name>
  [ WITH MANAGED ACCESS ]
  [ DATA_RETENTION_TIME_IN_DAYS = ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ COMMENT = '<string_literal>' ]

-- Example 15567
SHOW PRIVILEGES IN APPLICATION <name>

-- Example 15568
SHOW REFERENCES IN APPLICATION <name>

-- Example 15569
SHOW RELEASE DIRECTIVES [ LIKE '<pattern>' ]
  IN APPLICATION PACKAGE <name>

-- Example 15570
SHOW RELEASE DIRECTIVES IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 15571
+---------+-------------+---------------------------------+-------------------------------+---------+-------+-------------------------------+------------------------+--------------------------+----------------+-------------------------------+
| name    | target_type | target_name                     | created_on                    | version | patch | modified_on                   | active_regions         | pending_regions          | release_status | deployed_on                   |
|---------+-------------+---------------------------------+-------------------------------+---------+-------+-------------------------------+------------------------+--------------------------+----------------+-------------------------------+
| DEFAULT | DEFAULT     | NULL                            | 2023-04-02 14:55:17.304 -0700 | V2      |     0 | 2023-04-02 15:47:08.673 -0700 | PUBLIC.AWS_AP_SOUTH_1  | PUBLIC.AWS_AP_SOUTH_1    | IN PROGRESS    |                               |
| NEW_RD  | ACCOUNT     | [PROVIDER_DEV.PROVIDER_AWS]     | 2023-04-02 16:30:44.443 -0700 | V1      |     1 | 2023-04-03 07:10:42.428 -0700 | ALL                    |                          | DEPLOYED       | 2023-04-03 07:10:42.428 -0700 |         |
+---------+-------------+---------------------------------+-------------------------------+---------+-------+-------------------------------+------------------------+--------------------------+----------------+-------------------------------+

-- Example 15572
SHOW TELEMETRY EVENT DEFINITIONS IN APPLICATION <name>

-- Example 15573
SHOW TELEMETRY EVENT DEFINITIONS IN APPLICATION hello_snowflake;

-- Example 15574
+--------------------------+----------------+---------------+--------------+
|   name                   |   type         |   sharing     |   status     |
+--------------------------+----------------+---------------+--------------+
|   SNOWFLAKE$DEBUG_LOGS   |   DEBUG_LOGS   |   OPTIONAL    |   ENABLED    |
|   SNOWFLAKE$TRACES       |   TRACES       |   MANDATORY   |   ENABLED    |
+--------------------------+----------------+---------------+--------------+

-- Example 15575
SHOW VERSIONS [ LIKE <pattern> ]
  IN APPLICATION PACKAGE <name>;

-- Example 15576
SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_app;

-- Example 15577
+----------------+-------+---------+---------+-------------------------------+------------+-----------+-------------+-------+---------------+
| version        | patch | label   | comment | created_on                    | dropped_on | log_level | trace_level | state | review_status |
|----------------+-------+---------+---------+-------------------------------+------------+-----------+-------------+-------+---------------|
| V1_0           |     0 | NULL    | NULL    | 2023-05-10 17:11:47.696 -0700 | NULL       | OFF       | OFF         | READY | NOT_REVIEWED  |
+----------------+-------+---------+---------+-------------------------------+------------+-----------+-------------+-------+---------------+

-- Example 15578
ALTER APPLICATION PACKAGE <name>
  MODIFY RELEASE DIRECTIVE <release_directive>
  VERSION = <version_identifier>
  PATCH = <patch_num>
  [ UPGRADE_AFTER = '<timestamp>' ]

ALTER APPLICATION PACKAGE <name>
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = <version_identifier>
  PATCH = <patch_num>
  [ UPGRADE_AFTER = '<timestamp>' ]

ALTER APPLICATION PACKAGE <name>
  SET RELEASE DIRECTIVE <release_directive>
  ACCOUNTS = ( <organization_name>.<account_name> [ , <organization_name>.<account_name> , ... ] )
  VERSION = <version_identifier>
  PATCH = <patch_num>
  [ UPGRADE_AFTER = '<timestamp>' ]

ALTER APPLICATION PACKAGE <name> UNSET RELEASE DIRECTIVE <release_directive>

-- Example 15579
ALTER APPLICATION PACKAGE <name> ADD VERSION [ <version_identifier> ]
  USING <path_to_version_directory> [ LABEL = '<display_label>' ]

ALTER APPLICATION PACKAGE <name> DROP VERSION <version_identifier>

ALTER APPLICATION PACKAGE <name> ADD PATCH [<patch_number>] FOR VERSION [<version_identifier>]
  USING <path_to_version_directory> [ LABEL = '<display_label>' ]

-- Example 15580
ALTER APPLICATION PACKAGE hello_snowflake_package
  ADD VERSION v1_1
  USING '@hello_snowflake_code.core.hello_snowflake_stage';

-- Example 15581
+---------------------------------------------------------------------------------------+---------+-------+
| status                                                                                | version | patch |
|---------------------------------------------------------------------------------------+---------+-------|
| Version 'v1_1' of application package 'hello_snowflake_package' created successfully. | v1_1    |     0 |
+---------------------------------------------------------------------------------------+---------+-------+

-- Example 15582
GRANT DATABASE ROLE SNOWFLAKE.PYPI_REPOSITORY_USER TO ROLE some_user_role;

-- Example 15583
GRANT DATABASE ROLE SNOWFLAKE.PYPI_REPOSITORY_USER TO ROLE PUBLIC;

-- Example 15584
CREATE OR REPLACE FUNCTION sklearn_udf()
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  ARTIFACT_REPOSITORY = snowflake.snowpark.pypi_shared_repository
  ARTIFACT_REPOSITORY_PACKAGES = ('scikit-learn')
  HANDLER = 'udf'
  AS
$$
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

def udf():
  X, y = load_iris(return_X_y=True)
  X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

  model = RandomForestClassifier()
  model.fit(X_train, y_train)
  return model.score(X_test, y_test)
$$;

SELECT sklearn_udf();

-- Example 15585
CREATE OR REPLACE PROCEDURE TEST_PRESIDIO(x)
  RETURNS STRING
  LANGUAGE PYTHON
  RESOURCE_CONSTRAINT=(architecture='x86')
  RUNTIME_VERSION = 3.9
  HANDLER = 'main'
  ARTIFACT_REPOSITORY = snowflake.snowpark.pypi_shared_repository
  ARTIFACT_REPOSITORY_PACKAGES = ('presidio_analyzer','presidio_anonymizer')
  AS
$$
from presidio_analyzer import AnalyzerEngine

# Set up the engine, loads the NLP module (spaCy model by default) and other PII recognizers
analyzer = AnalyzerEngine()

# Call analyzer to get results
results = analyzer.analyze(text="My phone number is 425-xxx-xxxx",
entities=["PHONE_NUMBER"],
language='en')
return results
$$;

-- Example 15586
...
artifact_repository="snowflake.snowpark.pypi_shared_repository",
artifact_repository_packages=["urllib3", "requests"],
...

-- Example 15587
pip install <package name> --only-binary=:all: --python-version 3.9 –platform <platform_tag>

-- Example 15588
pip install snowflake-sqlalchemy --dry-run --ignore-installed

-- Example 15589
CREATE OR REPLACE FUNCTION sklearn_udf()
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('snowpark','snowflake-sqlalchemy')
  ARTIFACT_REPOSITORY = my_pypirepo
  ARTIFACT_REPOSITORY_PACKAGES = ('scikit-learn')
  HANDLER = 'udf'
  AS
  ...

-- Example 15590
CREATE WAREHOUSE so_warehouse WITH
   WAREHOUSE_SIZE = 'LARGE'
   WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
   RESOURCE_CONSTRAINT = 'MEMORY_16X_X86';

