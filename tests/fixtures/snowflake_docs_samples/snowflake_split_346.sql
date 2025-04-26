-- Example 23160
ALTER SECURITY INTEGRATION my_idp SET SAML2_POST_LOGOUT_REDIRECT_URL = 'https://logout.example.com';

-- Example 23161
ALTER SECURITY INTEGRATION my_idp SET SAML2_X509_CERT = 'AX2bv...';

-- Example 23162
ALTER SECURITY INTEGRATION my_idp REFRESH SAML2_SNOWFLAKE_PRIVATE_KEY;

-- Example 23163
DESCRIBE SECURITY INTEGRATION my_idp;
SELECT "property_value" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "property" = 'SAML2_SNOWFLAKE_X509_CERT';

-- Example 23164
ALTER SECURITY INTEGRATION my_idp SET SAML2_SIGN_REQUEST = true;

-- Example 23165
ALTER SECURITY INTEGRATION my_idp SET SAML2_REQUESTED_NAMEID_FORMAT = 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified';

-- Example 23166
ALTER SECURITY INTEGRATION my_idp SET SAML2_FORCE_AUTHN = true;

-- Example 23167
ALTER SECURITY INTEGRATION my_idp UNSET SAML2_FORCE_AUTHN;

-- Example 23168
ALTER SECURITY INTEGRATION my_idp SET SAML2_POST_LOGOUT_REDIRECT_URL = 'https://logout.example.com';

-- Example 23169
volumes:
- name: <name>
  source: <stage name>

-- Example 23170
volumeMounts:
- name: <name>
  mountPath: <absolute-directory-path>

-- Example 23171
spec:
  containers:
  - name: app
    image: <image1-name>
    volumeMounts:
    - name: models
      mountPath: /opt/models
  volumes:
  - name: models
    source: "@model_stage"

-- Example 23172
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

-- Example 23173
CREATE ROLE notebooks_rl;

-- Example 23174
USE WAREHOUSE <warehouse_name>;

-- Example 23175
ALTER ACCOUNT SET ENABLE_PERSONAL_DATABASE = TRUE;

-- Example 23176
ALTER ACCOUNT SET ENABLE_PERSONAL_DATABASE = FALSE;

-- Example 23177
SHOW PARAMETERS LIKE 'ENABLE_PERSONAL_DATABASE' IN ACCOUNT;

-- Example 23178
USE DATABASE USER$;

-- Example 23179
USE DATABASE USER$bobr;

-- Example 23180
USE DATABASE USER$jlap;

-- Example 23181
ERROR: Insufficient privileges to operate on database 'USER$JLAP'

-- Example 23182
ALTER USER bobr SET ENABLE_PERSONAL_DATABASE = TRUE;
ALTER USER amya SET ENABLE_PERSONAL_DATABASE = TRUE;
ALTER USER jlap SET ENABLE_PERSONAL_DATABASE = TRUE;

-- Example 23183
ALTER USER jlap SET ENABLE_PERSONAL_DATABASE = FALSE;

-- Example 23184
NotebookSqlException: Failed to fetch a pandas Dataframe. The error is: 060109 (0A000): Personal Database is not enabled for user JLAP.
Please contact an account administrator to enable it and try again.

-- Example 23185
CREATE STAGE mystage
  DIRECTORY = (ENABLE = TRUE)
  FILE_FORMAT = myformat;

-- Example 23186
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (ENABLE = TRUE);

-- Example 23187
CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (ENABLE = TRUE);

-- Example 23188
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (ENABLE = TRUE);

-- Example 23189
ALTER STAGE my_stage REFRESH SUBPATH = '2024/01/31';

-- Example 23190
SELECT * FROM DIRECTORY( @<stage_name> )

-- Example 23191
https://<account_identifier>/api/files/<db_name>.<schema_name>.<stage_name>/<relative_path>

-- Example 23192
SELECT * FROM DIRECTORY(@mystage);

-- Example 23193
SELECT FILE_URL FROM DIRECTORY(@mystage) WHERE SIZE > 100000;

-- Example 23194
SELECT FILE_URL FROM DIRECTORY(@mystage) WHERE RELATIVE_PATH LIKE '%.csv';

-- Example 23195
CREATE VIEW reports_information AS
  SELECT
    file_url as report_link,
    author,
    publish_date,
    approved_date,
    geography,
    num_of_pages
  FROM directory(@my_pdf_stage) s
  JOIN report_metadata m
  ON s.file_url = m.file_url

-- Example 23196
CREATE STAGE my_int_stage
  DIRECTORY = (
    ENABLE = TRUE
    AUTO_REFRESH = TRUE
  );

-- Example 23197
CREATE OR REPLACE STAGE my_pdf_stage
  ENCRYPTION = ( TYPE = 'SNOWFLAKE_SSE')
  DIRECTORY = ( ENABLE = TRUE);

-- Example 23198
CREATE STREAM my_pdf_stream ON STAGE my_pdf_stage;

-- Example 23199
CREATE OR REPLACE FUNCTION PDF_PARSE(file_path string)
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  HANDLER = 'parse_pdf_fields'
  PACKAGES=('typing-extensions','PyPDF2','snowflake-snowpark-python')
AS
$$
from pathlib import Path
import PyPDF2 as pypdf
from io import BytesIO
from snowflake.snowpark.files import SnowflakeFile

def parse_pdf_fields(file_path):
    with SnowflakeFile.open(file_path, 'rb') as f:
        buffer = BytesIO(f.readall())
    reader = pypdf.PdfFileReader(buffer)
    fields = reader.getFields()
    field_dict = {}
    for k, v in fields.items():
        if "/V" in v.keys():
            field_dict[v["/T"]] = v["/V"].replace("/", "") if v["/V"].startswith("/") else v["/V"]

    return field_dict
$$;

-- Example 23200
CREATE OR REPLACE TABLE prod_reviews (
  file_name varchar,
  file_data variant
);

-- Example 23201
CREATE OR REPLACE TASK load_new_file_data
  WAREHOUSE = 'MY_WAREHOUSE'
  SCHEDULE = '1 minute'
  COMMENT = 'Process new files on the stage and insert their data into the prod_reviews table.'
  WHEN
  SYSTEM$STREAM_HAS_DATA('my_pdf_stream')
  AS
  INSERT INTO prod_reviews (
    SELECT relative_path as file_name,
    PDF_PARSE(build_scoped_file_url('@my_pdf_stage', relative_path)) as file_data
    FROM my_pdf_stream
    WHERE METADATA$ACTION='INSERT'
  );

-- Example 23202
PUT file:///my/file/path/prod_review1.pdf @my_pdf_stage AUTO_COMPRESS = FALSE;
PUT file:///my/file/path/prod_review2.pdf @my_pdf_stage AUTO_COMPRESS = FALSE;

ALTER STAGE my_pdf_stage REFRESH;

-- Example 23203
SELECT * FROM my_pdf_stream;

-- Example 23204
EXECUTE TASK load_new_file_data;
+----------------------------------------------------------+
| status                                                   |
|----------------------------------------------------------|
| Task LOAD_NEW_FILE_DATA is scheduled to run immediately. |
+----------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.178s

-- Example 23205
select * from prod_reviews;
+------------------+----------------------------------+
| FILE_NAME        | FILE_DATA                        |
|------------------+----------------------------------|
| prod_review1.pdf | {                                |
|                  |   "FirstName": "John",           |
|                  |   "LastName": "Johnson",         |
|                  |   "Middle Name": "Michael",      |
|                  |   "Product": "Tennis Shoes",     |
|                  |   "Purchase Date": "03/15/2022", |
|                  |   "Recommend": "Yes"             |
|                  | }                                |
| prod_review2.pdf | {                                |
|                  |   "FirstName": "Emily",          |
|                  |   "LastName": "Smith",           |
|                  |   "Middle Name": "Ann",          |
|                  |   "Product": "Red Skateboard",   |
|                  |   "Purchase Date": "01/10/2023", |
|                  |   "Recommend": "MayBe"           |
|                  | }                                |
+------------------+----------------------------------+

-- Example 23206
CREATE OR REPLACE VIEW prod_review_info_v
  AS
  WITH file_data
  AS (
      SELECT
        file_name
        , parse_json(file_data) AS file_data
      FROM prod_reviews
  )
  SELECT
      file_name
      , file_data:FirstName::varchar AS first_name
      , file_data:LastName::varchar AS last_name
      , file_data:"Middle Name"::varchar AS middle_name
      , file_data:Product::varchar AS product
      , file_data:"Purchase Date"::date AS purchase_date
      , file_data:Recommend::varchar AS recommended
      , build_scoped_file_url(@my_pdf_stage, file_name) AS scoped_review_url
  FROM file_data;

SELECT * FROM prod_review_info_v;

+------------------+------------+-----------+-------------+----------------+---------------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FILE_NAME        | FIRST_NAME | LAST_NAME | MIDDLE_NAME | PRODUCT        | PURCHASE_DATE | RECOMMENDED | SCOPED_REVIEW_URL                                                                                                                                                                                                                                                                                                                                                                                                              |
|------------------+------------+-----------+-------------+----------------+---------------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| prod_review1.pdf | John       | Johnson   | Michael     | Tennis Shoes   | 2022-03-15    | Yes         | https://mydeployment.us-west-2.aws.privatelink.snowflakecomputing.com/api/files/01aefcdc-0000-6f92-0000-012900fdc73e/1275606224902/RZ4s%2bJLa6iHmLouHA79b94tg%2f3SDA%2bOQX01pAYo%2bl6gAxiLK8FGB%2bv8L2QSB51tWP%2fBemAbpFd%2btKfEgKibhCXN2QdMCNraOcC1uLdR7XV40JRIrB4gDYkpHxx3HpCSlKkqXeuBll%2fyZW9Dc6ZEtwF19GbnEBR9FwiUgyqWjqSf4KTmgWKv5gFCpxwqsQgofJs%2fqINOy%2bOaRPa%2b65gcnPpY2Dc1tGkJGC%2fT110Iw30cKuMGZ2HU%3d              |
| prod_review2.pdf | Emily      | Smith     | Ann         | Red Skateboard | 2023-01-10    | MayBe       | https://mydeployment.us-west-2.aws.privatelink.snowflakecomputing.com/api/files/01aefcdc-0000-6f92-0000-012900fdc73e/1275606224902/g3glgIbGik3VOmgcnltZxVNQed8%2fSBehlXbgdZBZqS1iAEsFPd8pkUNB1DSQEHoHfHcWLsaLblAdSpPIZm7wDwaHGvbeRbLit6nvE%2be2LHOsPR1UEJrNn83o%2fZyq4kVCIgKeSfMeGH2Gmrvi82JW%2fDOyZJITgCEZzpvWGC9Rmnr1A8vux47uZj9MYjdiN2Hho3uL9ExeFVo8FUtR%2fHkdCJKIzCRidD5oP55m9p2ml2yHOkDJW50%3d                            |
+------------------+------------+-----------+-------------+----------------+---------------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 23207
CREATE STAGE my_int_stage
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
  DIRECTORY = ( ENABLE = true );

-- Example 23208
SELECT * FROM DIRECTORY( @<stage_name> )

-- Example 23209
https://<account_identifier>/api/files/<db_name>.<schema_name>.<stage_name>/<relative_path>

-- Example 23210
SELECT * FROM DIRECTORY(@mystage);

-- Example 23211
SELECT FILE_URL FROM DIRECTORY(@mystage) WHERE SIZE > 100000;

-- Example 23212
SELECT FILE_URL FROM DIRECTORY(@mystage) WHERE RELATIVE_PATH LIKE '%.csv';

-- Example 23213
CREATE VIEW reports_information AS
  SELECT
    file_url as report_link,
    author,
    publish_date,
    approved_date,
    geography,
    num_of_pages
  FROM directory(@my_pdf_stage) s
  JOIN report_metadata m
  ON s.file_url = m.file_url

-- Example 23214
CREATE STAGE mystage
  DIRECTORY = (ENABLE = TRUE)
  FILE_FORMAT = myformat;

-- Example 23215
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (ENABLE = TRUE);

-- Example 23216
CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (ENABLE = TRUE);

-- Example 23217
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (ENABLE = TRUE);

-- Example 23218
ALTER STAGE my_stage REFRESH SUBPATH = '2024/01/31';

-- Example 23219
yyyy-mm-dd hh:mm:ss.nnn n.s.c.jdbc.SnowflakeSQLException FINE <init>:40 -
Snowflake exception: JWT token is invalid. [0ce9eb56-821d-4ca9-a774-04ae89a0cf5a],
sqlState:08001, vendorCode:390,144, queryId:

-- Example 23220
SELECT JSON_EXTRACT_PATH_TEXT(SYSTEM$GET_LOGIN_FAILURE_DETAILS('0ce9eb56-821d-4ca9-a774-04ae89a0cf5a'), 'errorCode');

-- Example 23221
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 23222
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.vpce.us-west-2.vpce-svc-012345678910f1234',
  'my.onprem.storage.com'
);

-- Example 23223
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT('com.amazonaws.us-west-2.s3');

-- Example 23224
SELECT SYSTEM$RESTORE_PRIVATELINK_ENDPOINT('com.amazonaws.us-west-2.s3');

-- Example 23225
SELECT SYSTEM$GET_PRIVATELINK_ENDPOINTS_INFO();

