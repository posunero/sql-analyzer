-- Example 17265
CREATE STAGE my_ext_stage2
  URL='gcs://load/encrypted_files/'
  STORAGE_INTEGRATION = my_storage_int
  ENCRYPTION=(TYPE = 'GCS_SSE_KMS' KMS_KEY_ID = '{a1b2c3});

-- Example 17266
CREATE STAGE my_ext_stage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = myint;

-- Example 17267
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/mycontainer/files/'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...');

-- Example 17268
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 17269
CREATE OR ALTER STAGE my_int_stage
  COMMENT='my_comment'
  ;

-- Example 17270
CREATE OR ALTER STAGE my_int_stage
  DIRECTORY=(ENABLE=true);

-- Example 17271
CREATE OR ALTER STAGE my_ext_stage
  URL='s3://load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z');

-- Example 17272
CREATE OR ALTER STAGE my_ext_stage
  URL='s3://load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  DIRECTORY=(ENABLE=true);

-- Example 17273
verified_queries:

- name: "lowest revenue each month"
  question: For each month, what was the lowest daily revenue and on what date did that lowest revenue occur?

  use_as_onboarding_question: true

  sql: "WITH monthly_min_revenue AS (
SELECT
    DATE_TRUNC('MONTH', date) AS month,
    MIN(daily_revenue) AS min_revenue
FROM \__daily_revenue
GROUP BY
DATE_TRUNC('MONTH', date)

)

SELECT
    mmr.month,
    mmr.min_revenue,
    dr.date AS min_revenue_date
FROM monthly_min_revenue AS mmr JOIN \__daily_revenue AS dr
ON mmr.month = DATE_TRUNC('MONTH', dr.date)
AND mmr.min_revenue = dr.daily_revenue
ORDER BY mmr.month DESC NULLS LAST"

verified_at: 1715187400

verified_by: user_name

-- Example 17274
What was my overall sales of iced tea in Q1?

-- Example 17275
SELECT DISTINCT name FROM product WHERE name LIKE '%iced%tea%'

-- Example 17276
CREATE OR REPLACE CORTEX SEARCH SERVICE my_logical_dimension_search_service
  ON my_dimension
  WAREHOUSE = xsmall
  TARGET_LAG = '1 hour'
  AS (
      SELECT DISTINCT my_dimension FROM my_logical_dimension_landing_table
  );`

-- Example 17277
tables:

  - name: my_table

    base_table:
      database: my_database
      schema: my_schema
      table: my_table

    dimensions:
      - name: my_dimension
        expr: my_column
        cortex_search_service:
          service: my_logical_dimension_search_service
          literal_column: my_column     # optional
          database: my_search_database  # optional
          schema: my_search_schema      # optional

-- Example 17278
SELECT * FROM snowflake.organization_usage.metering_daily_history
  WHERE service_type = 'ORGANIZATION_USAGE';

-- Example 17279
SELECT
  SUM(active_bytes + time_travel_bytes + failsafe_bytes + retained_for_clone_bytes) / pow(1000, 4)
    AS org_usage_approx_storage_tb
  FROM snowflake.organization_usage.table_storage_metrics
  WHERE 1=1
    AND table_schema = 'ORGANIZATION_USAGE_LOCAL';

-- Example 17280
from snowflake.ml.registry import Registry

reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")

-- Example 17281
from snowflake.ml.model import type_hints
mv = reg.log_model(clf,
                   model_name="my_model",
                   version_name="v1",
                   conda_dependencies=["scikit-learn"],
                   comment="My awesome ML model",
                   metrics={"score": 96},
                   sample_input_data=train_features,
                   task=type_hints.Task.TABULAR_BINARY_CLASSIFICATION)

-- Example 17282
from snowflake.ml.model._model_composer.model_manifest import model_manifest
model_manifest.ModelManifest._ENABLE_USER_FILES = True

-- Example 17283
LIST 'snow://model/my_model/versions/V3/';

-- Example 17284
name                                      size                  md5                      last_modified
versions/V3/MANIFEST.yml           30639    2f6186fb8f7d06e737a4dfcdab8b1350        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/functions/apply.py      2249    e9df6db11894026ee137589a9b92c95d        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/functions/predict.py    2251    132699b4be39cc0863c6575b18127f26        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model.zip             721663    e92814d653cecf576f97befd6836a3c6        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model/env/conda.yml          332        1574be90b7673a8439711471d58ec746        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model/model.yaml       25718    33e3d9007f749bb2e98f19af2a57a80b        Thu, 18 Jan 2024 09:24:37 GMT

-- Example 17285
GET 'snow://model/model_my_model/versions/V3/MANIFEST.yml'

-- Example 17286
session.file.get('snow://model/my_model/versions/V3/MANIFEST.yml', 'model_artifacts')

-- Example 17287
reg.delete_model("mymodel")

-- Example 17288
model_df = reg.show_models()

-- Example 17289
model_list = reg.models()

-- Example 17290
m = reg.get_model("MyModel")

-- Example 17291
print(m.comment)
m.comment = "A better description than the one I provided originally"

-- Example 17292
print(m.description)
m.description = "A better description than the one I provided originally"

-- Example 17293
print(m.show_tags())

-- Example 17294
m.set_tag("live_version", "v1")

-- Example 17295
m.get_tag("live_version")

-- Example 17296
m.unset_tag("live_version")

-- Example 17297
m.rename("MY_MODEL_TOO")

-- Example 17298
version_list = m.versions()

-- Example 17299
version_df = m.show_versions()

-- Example 17300
m.delete_version("rc1")

-- Example 17301
default_version = m.default
m.default = "v2"

-- Example 17302
m = reg.get_model("MyModel")

mv = m.version("v1")
mv = m.default

-- Example 17303
print(mv.comment)
print(mv.description)

mv.comment = "A model version comment"
mv.description = "Same as setting the comment"

-- Example 17304
from sklearn import metrics

test_accuracy = metrics.accuracy_score(test_labels, prediction)

-- Example 17305
test_confusion_matrix = metrics.confusion_matrix(test_labels, prediction)

-- Example 17306
# scalar metric
mv.set_metric("test_accuracy", test_accuracy)

# hierarchical (dictionary) metric
mv.set_metric("evaluation_info", {"dataset_used": "my_dataset", "accuracy": test_accuracy, "f1_score": f1_score})

# multivalent (matrix) metric
mv.set_metric("confusion_matrix", test_confusion_matrix)

-- Example 17307
metrics = mv.show_metrics()

-- Example 17308
mv.delete_metric("test_accuracy")

-- Example 17309
mv.export("~/mymodel/")

-- Example 17310
mv.export("~/mymodel/", export_mode=ExportMode.FULL)

-- Example 17311
clf = mv.load()

-- Example 17312
conda_env = session.file.get("snow://model/<modelName>/versions/<versionName>/runtimes/python_runtime/env/conda.yml", ".")
open("~/conda.yml", "w").write(conda_env)

-- Example 17313
conda env create --name newenv --file=~/conda.yml
conda activate newenv

-- Example 17314
clf = mv.load(options={"use_gpu": True})

-- Example 17315
remote_prediction = mv.run(test_features, function_name="predict")
remote_prediction.show()   # assuming test_features is Snowpark DataFrame

-- Example 17316
Show Change Log

-- Example 17317
----------------------------------
--       Location Setup         --
----------------------------------
GRANT USAGE ON DATABASE <database> TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA <database.schema> TO ROLE PUBLIC;
GRANT CREATE NOTEBOOK ON SCHEMA <database.schema> TO ROLE PUBLIC;

-- For Notebooks on Container runtime, run the following:
GRANT CREATE SERVICE ON SCHEMA <database.schema> TO ROLE PUBLIC;

----------------------------------
--    Compute Resource Setup    --
----------------------------------
GRANT USAGE ON WAREHOUSE <warehouse> TO ROLE PUBLIC;

-- For Notebooks on Container runtime:
CREATE COMPUTE POOL CPU_XS
  MIN_NODES = 1
  MAX_NODES = 15
  INSTANCE_FAMILY = CPU_X64_XS;

CREATE COMPUTE POOL GPU_S
  MIN_NODES = 1
  MAX_NODES = 5
  INSTANCE_FAMILY = GPU_NV_S;

GRANT USAGE ON COMPUTE POOL CPU_XS TO ROLE PUBLIC;
GRANT USAGE ON COMPUTE POOL GPU_S TO ROLE PUBLIC;

-------------------------------------
-- Optional: External Access --
-------------------------------------

-- Example EAI
CREATE OR REPLACE NETWORK RULE allow_all_rule
MODE = 'EGRESS'
TYPE = 'HOST_PORT'
VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION allow_all_integration
ALLOWED_NETWORK_RULES = (allow_all_rule)
ENABLED = true;

GRANT USAGE ON INTEGRATION allow_all_integration TO ROLE PUBLIC;

-- Example 17318
CREATE ROLE notebooks_rl;

-- Example 17319
USE WAREHOUSE <warehouse_name>;

-- Example 17320
ALTER ACCOUNT SET ENABLE_PERSONAL_DATABASE = TRUE;

-- Example 17321
ALTER ACCOUNT SET ENABLE_PERSONAL_DATABASE = FALSE;

-- Example 17322
SHOW PARAMETERS LIKE 'ENABLE_PERSONAL_DATABASE' IN ACCOUNT;

-- Example 17323
USE DATABASE USER$;

-- Example 17324
USE DATABASE USER$bobr;

-- Example 17325
USE DATABASE USER$jlap;

-- Example 17326
ERROR: Insufficient privileges to operate on database 'USER$JLAP'

-- Example 17327
ALTER USER bobr SET ENABLE_PERSONAL_DATABASE = TRUE;
ALTER USER amya SET ENABLE_PERSONAL_DATABASE = TRUE;
ALTER USER jlap SET ENABLE_PERSONAL_DATABASE = TRUE;

-- Example 17328
ALTER USER jlap SET ENABLE_PERSONAL_DATABASE = FALSE;

-- Example 17329
NotebookSqlException: Failed to fetch a pandas Dataframe. The error is: 060109 (0A000): Personal Database is not enabled for user JLAP.
Please contact an account administrator to enable it and try again.

-- Example 17330
CREATE OR REPLACE NETWORK RULE pypi_network_rule
MODE = EGRESS
TYPE = HOST_PORT
VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org',  'files.pythonhosted.org');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION pypi_access_integration
ALLOWED_NETWORK_RULES = (pypi_network_rule)
ENABLED = true;

