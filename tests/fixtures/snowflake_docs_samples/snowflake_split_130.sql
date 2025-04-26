-- Example 8691
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_ANALYST_USAGE_HISTORY;

-- Example 8692
Fine-tuning trained tokens = number of input tokens * number of epochs trained

-- Example 8693
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FINE_TUNING_USAGE_HISTORY;

-- Example 8694
Effective row count limit = 1 epoch limit for base model / number of epochs trained

-- Example 8695
GRANT CREATE MODEL ON SCHEMA my_schema TO ROLE my_role;

-- Example 8696
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT a AS prompt, d AS completion FROM train',
  'SELECT a AS prompt, d AS completion FROM validation'
);

-- Example 8697
USE DATABASE mydb;
USE SCHEMA myschema;

SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM my_training_data',
  'SELECT prompt, completion FROM my_validation_data'
);

-- Example 8698
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'mydb.myschema.my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM mydb2.myschema2.my_training_data',
  'SELECT prompt, completion FROM mydb2.myschema2.my_validation_data'
);

-- Example 8699
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'my_tuned_model',
  'How to fine-tune mistral models'
);

-- Example 8700
Mistral models are a type of deep learning model used for image recognition and classification. Fine-tuning a Mistral model involves adjusting the model's parameters to ...

-- Example 8701
session.sql('call my_model!FORECAST(...)').collect()

-- Example 8702
SELECT SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2024_02');

-- Example 8703
+-------------------------------------------------+
| SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2024_02') |
|-------------------------------------------------|
| DISABLED                                        |
+-------------------------------------------------+

-- Example 8704
SELECT SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES();

-- Example 8705
+--------------------------------------------------------------------------------------------------------------+
| SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES()                                                                 |
|--------------------------------------------------------------------------------------------------------------|
| [{"name":"2023_08","isDefault":true,"isEnabled":true},{"name":"2024_01","isDefault":false,"isEnabled":true}] |
+--------------------------------------------------------------------------------------------------------------+

-- Example 8706
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02');

-- Example 8707
+-------------------------------------------------+
| SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02') |
|-------------------------------------------------|
| ENABLED                                         |
+-------------------------------------------------+

-- Example 8708
SELECT SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02');

-- Example 8709
+-------------------------------------------------+
| SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02')|
|-------------------------------------------------|
| DISABLED                                        |
+-------------------------------------------------+

-- Example 8710
SELECT CURRENT_VERSION();

-- Example 8711
+-------------------+
| CURRENT_VERSION() |
|-------------------|
| 8.5.1             |
+-------------------+

-- Example 8712
CREATE MASKING POLICY MP AS (n NUMBER)
RETURNS NUMBER -> 12345;

-- Example 8713
CREATE TABLE t(col1 NUMBER(2,0));

ALTER TABLE t MODIFY COLUMN col1 SET MASKING POLICY mp;
INSERT INTO t VALUES (10);

-- Example 8714
SELECT * FROM t;

-- Example 8715
SET DDM_CASTING_BCR_START_DATE = '2024-03-01';
SET DDM_CASTING_BCR_END_DATE = '2024-04-03';

-- Example 8716
USE ROLE ACCOUNTADMIN;
SET DDM_CASTING_BCR_START_DATE = '2024-03-01';
SET DDM_CASTING_BCR_END_DATE = '2024-04-03';
SELECT * FROM SNOWFLAKE.BCR_ROLLOUT.BCR_2024_03_DDM_ROLLOUT;

-- Example 8717
CREATE USER janesmith PASSWORD = 'abc123' DEFAULT_ROLE = myrole MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE myrole TO USER janesmith;

-- Example 8718
from snowflake.core.user import Securable, User

my_user = User(
  name="janesmith",
  password="abc123",
  default_role="myrole",
  must_change_password=True)
root.users.create(my_user)

root.users['janesmith'].grant_role(role_type="ROLE", role=Securable(name='myrole'))

-- Example 8719
ALTER USER janesmith SET DISABLED = TRUE;

-- Example 8720
ALTER USER janesmith SET DISABLED = FALSE;

-- Example 8721
user_parameters = root.users["janesmith"].fetch()
user_parameters.disabled = True
root.users["janesmith"].create_or_alter(user_parameters)

-- Example 8722
user_parameters = root.users["janesmith"].fetch()
user_parameters.disabled = False
root.users["janesmith"].create_or_alter(user_parameters)

-- Example 8723
ALTER USER janesmith SET MINS_TO_UNLOCK= 0;

-- Example 8724
user_parameters = root.users["janesmith"].fetch()
user_parameters.mins_to_unlock = 0
root.users["janesmith"].create_or_alter(user_parameters)

-- Example 8725
SHOW PARAMETERS [ LIKE '<pattern>' ] FOR USER <name>

-- Example 8726
ALTER USER <name> SET <session_param> = <value>

-- Example 8727
ALTER USER janesmith SET CLIENT_SESSION_KEEP_ALIVE = TRUE;

-- Example 8728
ALTER USER <name> UNSET <session_param>

-- Example 8729
ALTER USER janesmith SET LAST_NAME = 'Jones';

-- Example 8730
user_parameters = root.users["janesmith"].fetch()
user_parameters.last_name = "Jones"
root.users["janesmith"].create_or_alter(user_parameters)

-- Example 8731
ALTER USER janesmith SET DEFAULT_WAREHOUSE = mywarehouse DEFAULT_NAMESPACE = mydatabase.myschema DEFAULT_ROLE = myrole DEFAULT_SECONDARY_ROLES = ('ALL');

-- Example 8732
user_parameters = root.users["janesmith"].fetch()
user_parameters.default_warehouse = "mywarehouse"
user_parameters.default_namespace = "mydatabase.myschema"
user_parameters.default_role = "myrole"
user_parameters.default_secondary_roles = "ALL"
root.users["janesmith"].create_or_alter(user_parameters)

-- Example 8733
DESC USER janeksmith;

-- Example 8734
my_user = root.users["janesmith"].fetch()
print(my_user.to_dict())

-- Example 8735
users = root.users.iter(like="jane%")
for user in users:
  print(user.name)

-- Example 8736
DROP USER janesmith;

-- Example 8737
root.users["janesmith"].drop()

-- Example 8738
ALTER SECURITY INTEGRATION <oauth_integration> SET NETWORK_POLICY = <oauth_network_policy>;

-- Example 8739
ALTER SECURITY INTEGRATION <oauth_integration> UNSET <oauth_network_policy>;

-- Example 8740
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 8741
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 8742
DESC STORAGE INTEGRATION <integration_name>;

-- Example 8743
GRANT CREATE STAGE ON SCHEMA public TO ROLE myrole;

GRANT USAGE ON INTEGRATION azure_int TO ROLE myrole;

-- Example 8744
USE SCHEMA mydb.public;

CREATE STAGE my_azure_stage
  STORAGE_INTEGRATION = azure_int
  URL = 'azure://myaccount.blob.core.windows.net/container1/path1'
  FILE_FORMAT = my_csv_format;

-- Example 8745
CREATE OR REPLACE STAGE my_azure_stage
  URL='azure://myaccount.blob.core.windows.net/mycontainer/load/files'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...')
  FILE_FORMAT = my_csv_format;

-- Example 8746
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/') ]

-- Example 8747
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

-- Example 8748
DESC STORAGE INTEGRATION <integration_name>;

-- Example 8749
DESC STORAGE INTEGRATION gcs_int;

+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+
| property                    | property_type | property_value                                                              | property_default |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------|
| ENABLED                     | Boolean       | true                                                                        | false            |
| STORAGE_ALLOWED_LOCATIONS   | List          | gcs://mybucket1/path1/,gcs://mybucket2/path2/                               | []               |
| STORAGE_BLOCKED_LOCATIONS   | List          | gcs://mybucket1/path1/sensitivedata/,gcs://mybucket2/path2/sensitivedata/   | []               |
| STORAGE_GCP_SERVICE_ACCOUNT | String        | service-account-id@project1-123456.iam.gserviceaccount.com                  |                  |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 8750
GRANT USAGE ON DATABASE mydb TO ROLE myrole;
GRANT USAGE ON SCHEMA mydb.stages TO ROLE myrole;
GRANT CREATE STAGE ON SCHEMA mydb.stages TO ROLE myrole;
GRANT USAGE ON INTEGRATION gcs_int TO ROLE myrole;

-- Example 8751
USE SCHEMA mydb.stages;

CREATE STAGE my_gcs_stage
  URL = 'gcs://mybucket1/path1'
  STORAGE_INTEGRATION = gcs_int
  FILE_FORMAT = my_csv_format;

-- Example 8752
USE SCHEMA mydb.stages;

CREATE STAGE my_ext_stage2
  URL='gcs://load/encrypted_files/'
  STORAGE_INTEGRATION = gcs_int
  ENCRYPTION=(TYPE = 'GCS_SSE_KMS' KMS_KEY_ID = '{a1b2c3});
  FILE_FORMAT = my_csv_format;

-- Example 8753
from snowflake.core.stage import Stage

my_stage = Stage(
  name="my_gcs_stage",
    storage_integration="gcs_int",
    url="gcs://mybucket1/path1"
)
root.databases["mydb"].schemas["stages"].stages.create(my_stage)

-- Example 8754
ALTER STAGE my_gcs_stage
  SET STORAGE_INTEGRATION = gcs_int;

-- Example 8755
CREATE [ OR REPLACE ]
    [ { [ { LOCAL | GLOBAL } ] TEMP | TEMPORARY | VOLATILE | TRANSIENT } ]
  TABLE [ IF NOT EXISTS ] <table_name>

  (
    -- Column definition
    <col_name> <col_type>
      [ inlineConstraint ]
      [ NOT NULL ]
      [ COLLATE '<collation_specification>' ]
      [
        {
          DEFAULT <expr>
          | { AUTOINCREMENT | IDENTITY }
            [
              {
                ( <start_num> , <step_num> )
                | START <num> INCREMENT <num>
              }
            ]
            [ { ORDER | NOORDER } ]
        }
      ]
      [ [ WITH ] MASKING POLICY <policy_name> [ USING ( <col_name> , <cond_col1> , ... ) ] ]
      [ [ WITH ] PROJECTION POLICY <policy_name> ]
      [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
      [ COMMENT '<string_literal>' ]

    -- Additional column definitions
    [ , <col_name> <col_type> [ ... ] ]

    -- Out-of-line constraints
    [ , outoflineConstraint [ ... ] ]
  )

  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ ENABLE_SCHEMA_EVOLUTION = { TRUE | FALSE } ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] AGGREGATION POLICY <policy_name> [ ENTITY KEY ( <col_name> [ , <col_name> ... ] ) ] ]
  [ [ WITH ] JOIN POLICY <policy_name> [ ALLOWED JOIN KEYS ( <col_name> [ , ... ] ) ] ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 8756
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE
    | PRIMARY KEY
    | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  }
  [ <constraint_properties> ]

-- Example 8757
outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]
  [ COMMENT '<string_literal>' ]

