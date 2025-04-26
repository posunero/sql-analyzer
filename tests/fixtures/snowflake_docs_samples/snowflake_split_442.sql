-- Example 29586
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://myqueue.queue.core.windows.net/mystoragequeue'
  AZURE_TENANT_ID = 'a123bcde-1234-5678-abc1-9abc12345678';

-- Example 29587
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 29588
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 29589
directoryTable (for Microsoft Azure) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 29590
USE SCHEMA mydb.public;

-- Example 29591
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 29592
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 29593
ALTER STAGE mystage REFRESH;

-- Example 29594
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

-- Example 29595
$ snowsql -a <account_identifier>

-- Example 29596
$ snowsql -a <account_identifier> -u <user_login_name>

-- Example 29597
USE ROLE ACCOUNTADMIN;

CREATE ROLE trust_center_admin_role;
GRANT APPLICATION ROLE SNOWFLAKE.TRUST_CENTER_ADMIN TO ROLE trust_center_admin_role;

CREATE ROLE trust_center_viewer_role;
GRANT APPLICATION ROLE SNOWFLAKE.TRUST_CENTER_VIEWER TO ROLE trust_center_viewer_role;

GRANT ROLE trust_center_admin_role TO USER example_admin_user;

GRANT ROLE trust_center_viewer_role TO USER example_nonadmin_user;

-- Example 29598
SELECT start_timestamp,
       end_timestamp,
       scanner_id,
       scanner_short_description,
       impact,
       severity,
       total_at_risk_count,
       AT_RISK_ENTITIES
  FROM snowflake.trust_center.findings
  WHERE scanner_type = 'Threat' AND
        completion_status = 'SUCCEEDED'
  ORDER BY event_id DESC;

-- Example 29599
[
  {
    "entity_detail": {
      "granted_by": joe_smith,
      "grantee_name": "SNOWFLAKE$SUSPICIOUS_ROLE",
      "modified_on": "2025-01-01 07:00:00.000 Z",
      "role_granted": "ACCOUNTADMIN"
    },
    "entity_id": "SNOWFLAKE$SUSPICIOUS_ROLE",
    "entity_name": "SNOWFLAKE$SUSPICIOUS_ROLE",
    "entity_object_type": "ROLE"
  }
]

-- Example 29600
CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.count_positive_numbers(
  arg_t TABLE(
    arg_c1 NUMBER,
    arg_c2 NUMBER,
    arg_c3 NUMBER
  )
)
RETURNS NUMBER
AS
$$
  SELECT
    COUNT(*)
  FROM arg_t
  WHERE
    arg_c1>0
    AND arg_c2>0
    AND arg_c3>0
$$;

-- Example 29601
CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.referential_check(
  arg_t1 TABLE (arg_c1 INT), arg_t2 TABLE (arg_c2 INT))
RETURNS NUMBER AS
 'SELECT COUNT(*) FROM arg_t1
  WHERE arg_c1 NOT IN (SELECT arg_c2 FROM arg_t2)';

-- Example 29602
ALTER TABLE salesorders
  ADD DATA METRIC FUNCTION governance.dmfs.referential_check
    ON (sp_id, TABLE (my_db.sch1.salespeople(sp_id)));

-- Example 29603
ALTER FUNCTION governance.dmfs.count_positive_numbers(
 TABLE(
   NUMBER,
   NUMBER,
   NUMBER
))
SET SECURE;

-- Example 29604
DESC FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(
    NUMBER, NUMBER, NUMBER
  )
);

-- Example 29605
+-----------+---------------------------------------------------------------------+
| property  | value                                                               |
+-----------+---------------------------------------------------------------------+
| signature | (ARG_T TABLE(ARG_C1 NUMBER, ARG_C2 NUMBER, ARG_C3 NUMBER))          |
| returns   | NUMBER(38,0)                                                        |
| language  | SQL                                                                 |
| body      | SELECT COUNT(*) FROM arg_t WHERE arg_c1>0 AND arg_c2>0 AND arg_c3>0 |
+-----------+---------------------------------------------------------------------+

-- Example 29606
ALTER FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(NUMBER, NUMBER, NUMBER))
  SET TAG governance.tags.quality = 'counts';

-- Example 29607
DROP FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(
    NUMBER, NUMBER, NUMBER
  )
);

-- Example 29608
{
   "Version": "2012-10-17",
   "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:PutObject",
               "s3:GetObject",
               "s3:GetObjectVersion",
               "s3:DeleteObject",
               "s3:DeleteObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<my_bucket>/*"
         },
         {
            "Effect": "Allow",
            "Action": [
               "s3:ListBucket",
               "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<my_bucket>",
            "Condition": {
               "StringLike": {
                     "s3:prefix": [
                        "*"
                     ]
               }
            }
         }
   ]
}

-- Example 29609
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'my-s3-us-west-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://<my_bucket>/'
            STORAGE_AWS_ROLE_ARN = '<arn:aws:iam::123456789012:role/myrole>'
            STORAGE_AWS_EXTERNAL_ID = 'iceberg_table_external_id'
         )
      )
      ALLOW_WRITES = TRUE;

-- Example 29610
DESC EXTERNAL VOLUME iceberg_external_volume;

-- Example 29611
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<iceberg_table_external_id>"
        }
      }
    }
  ]
}

-- Example 29612
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 29613
ALTER USER my_user UNSET DEFAULT_SECONDARY_ROLES;
ALTER USER my_user SET DEFAULT_SECONDARY_ROLES = ('ALL');

-- Example 29614
USE SECONDARY ROLES ALL;

-- Example 29615
USE DATABASE USER$bobr;
CREATE SCHEMA bobr_schema;
USE SCHEMA bobr_schema;

-- Example 29616
ALTER SCHEMA bobr_schema RENAME TO bobr_personal_schema;
SHOW TERSE SCHEMAS;

-- Example 29617
+-------------------------------+----------------------+------+---------------+-------------+
| created_on                    | name                 | kind | database_name | schema_name |
|-------------------------------+----------------------+------+---------------+-------------|
| 2024-10-28 19:33:18.437 -0700 | BOBR_PERSONAL_SCHEMA | NULL | USER$BOBR     | NULL        |
| 2024-10-29 14:11:33.267 -0700 | INFORMATION_SCHEMA   | NULL | USER$BOBR     | NULL        |
| 2024-10-28 12:47:21.502 -0700 | PUBLIC               | NULL | USER$BOBR     | NULL        |
+-------------------------------+----------------------+------+---------------+-------------+

-- Example 29618
CREATE NOTEBOOK bobr_prod_notebook
  FROM 'snow://notebook/USER$BOBR.PUBLIC.bobr_private_notebook/versions/version$1/'
  QUERY_WAREHOUSE = 'PUBLIC_WH'
  MAIN_FILE = 'notebook_app.ipynb'
  COMMENT = 'Duplicated from personal database';

-- Example 29619
Notebook BOBR_PROD_NOTEBOOK successfully created.

-- Example 29620
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES;

-- Example 29621
DESCRIBE NOTEBOOK USER$.PUBLIC.bobr_private_notebook;

-- Example 29622
SHOW DATABASES LIKE 'USER$BOBR';

-- Example 29623
from snowflake.snowpark.context import get_active_session
session = get_active_session()

-- Example 29624
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Example 29625
species = ["adelie"] * 3 + ["chinstrap"] * 3 + ["gentoo"] * 3
measurements = ["bill_length", "flipper_length", "bill_depth"] * 3
values = [37.3, 187.1, 17.7, 46.6, 191.7, 17.6, 45.5, 212.7, 14.2]
df = pd.DataFrame({"species": species,"measurement": measurements,"value": values})
df

-- Example 29626
import altair as alt
alt.Chart(df).mark_bar().encode(
    x= alt.X("measurement", axis = alt.Axis(labelAngle=0)),
    y="value",
    color="species"
)

-- Example 29627
import matplotlib.pyplot as plt

pivot_df = pd.pivot_table(data=df, index=['measurement'], columns=['species'], values='value')

import matplotlib.pyplot as plt
ax = pivot_df.plot.bar(stacked=True)
ax.set_xticklabels(list(pivot_df.index), rotation=0)

-- Example 29628
import plotly.express as px
px.bar(df, x='measurement', y='value', color='species')

-- Example 29629
import seaborn as sns

sns.barplot(
    data=df,
    x="measurement", hue="species", y="value",
)

-- Example 29630
import streamlit as st

st.bar_chart(df, x='measurement', y='value', color='species')

-- Example 29631
with open("myfile.txt",'w') as f:
    f.write("abc")
f.close()

-- Example 29632
import os
os.listdir()

-- Example 29633
CREATE OR REPLACE STAGE permanent_stage;

-- Example 29634
with open("myfile.txt",'w') as f:
  f.write("abc")
f.close()

-- Example 29635
from snowflake.snowpark.context import get_active_session
session = get_active_session()

put_result = session.file.put("myfile.txt","@PERMANENT_STAGE", auto_compress= False)
put_result[0].status

-- Example 29636
LS @permanent_stage;

-- Example 29637
import pandas as pd
df = pd.read_csv("data.csv")

-- Example 29638
snow://notebook/<DATABASE>.<SCHEMA>.<NOTEBOOK_NAME>/versions/live/<file_name>

-- Example 29639
LIST 'snow://notebook/<DATABASE>.<SCHEMA>.<NOTEBOOK_NAME>/versions/live/data.csv'

-- Example 29640
# Generate sample JSON file
with open("data.json", "w") as f:
    f.write('{"fruit":"apple", "size":3.4, "weight":1.4},{"fruit":"orange", "size":5.4, "weight":3.2}')
# Read from local JSON file (File doesn't show in UI)
df = pd.read_json("data.json",lines=True)
df

-- Example 29641
Result size for streamlit list exceeded the limit. Streamlit list was truncated.

-- Example 29642
st.plotly_chart(fig, render_mode='svg')

WebGL is not supported by your browser - visit https://get.webgl.org for more info.

-- Example 29643
AttributeError: ‘NoneType’ object has no attribute ‘sql’

-- Example 29644
session = get_active_session() #establishing a Snowpark session

-- Example 29645
Notebook connection lost and cannot reconnect. Restart or end session.

-- Example 29646
Something went wrong. Unable to connect. A firewall or ad blocker might be preventing you from connecting.

-- Example 29647
ModuleNotFoundError: Line 2: Module Not Found: snowflake.core. To import packages from Anaconda, install them first using the package
selector at the top of the page.

-- Example 29648
SnowflakeInternalException{signature=std::vector<sf::RuntimePathLinkage> sf::{anonymous}::buildRuntimeFileSet(const sf::UdfRuntime&, std::string_view, const std::vector<sf::udf::ThirdPartyLibrariesInfo>&, bool):"libpython_missing", internalMsg=[XP_WORKER_FAILURE: Unexpected error signaled by function 'std::vector<sf::RuntimePathLinkage> sf::{anonymous}::buildRuntimeFileSet(const sf::UdfRuntime&, std::string_view, const std::vector<sf::udf::ThirdPartyLibrariesInfo>&, bool)'
Assert "libpython_missing"[{"function": "std::vector<sf::RuntimePathLinkage> sf::{anonymous}::buildRuntimeFileSet(const sf::UdfRuntime&, std::string_view, const std::vector<sf::udf::ThirdPartyLibrariesInfo>&, bool)", "line": 1307, "stack frame ptr": "0xf2ff65553120",  "libPythonOnHost": "/opt/sfc/deployments/prod1/ExecPlatform/cache/directory_cache/server_2921757878/v3/python_udf_libs/.data/4e8f2a35e2a60eb4cce3538d6f794bd7881d238d64b1b3e28c72c0f3d58843f0/lib/libpython3.9.so.1.0"}]], userMsg=Processing aborted due to error 300010:791225565; incident 9770775., reporter=unknown, dumpFile= file://, isAborting=true, isVerbose=false}

-- Example 29649
Matplotlib created a temporary cache directory at /tmp/matplotlib-2fk8582w because the default path (/home/udf/.config/matplotlib) is
not a writable directory; it is highly recommended to set the MPLCONFIGDIR environment variable to a writable directory, in particular
to speed up the import of Matplotlib and to better support multiprocessing.

-- Example 29650
import os
os.environ["MPLCONFIGDIR"] = '/tmp/'
import matplotlib.pyplot as plt

-- Example 29651
Readonly file system: `/home/udf/.cache`

-- Example 29652
import os
os.environ['HF_HOME'] = '/tmp'
os.environ['SENTENCE_TRANSFORMERS_HOME'] = '/tmp'

from sentence_transformers import SentenceTransformer
model = SentenceTransformer("Snowflake/snowflake-arctic-embed-xs")

