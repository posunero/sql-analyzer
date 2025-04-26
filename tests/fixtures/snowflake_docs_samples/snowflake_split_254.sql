-- Example 16997
CREATE SERVICE echo_service
  MIN_INSTANCES=2
  MAX_INSTANCES=2
  IN COMPUTE POOL tutorial_compute_pool
  FROM @<stage_path>
  SPEC=<spec-file-stage-path>;

-- Example 16998
- name: resource-test
  image: ...
  resources:
    requests:
      memory: 15G

-- Example 16999
spec:
  containers:
  - name: resource-test-gpu
    image: ...
    resources:
      requests:
        memory: 2G
        nvidia.com/gpu: 1
      limits:
        nvidia.com/gpu: 1

-- Example 17000
secrets:                                # optional list
  - snowflakeSecret:
      objectName: <object-name>         # specify this or objectReference
      objectReference: <reference-name> # specify this or objectName
    directoryPath: <path>               # specify this or envVarName
    envVarName: <name>                  # specify this or directoryPath
    secretKeyRef: username | password | secret_string # specify only with envVarName
  - snowflakeSecret: <object-name>      # equivalent to snowflakeSecret.objectName
    ...

-- Example 17001
instances.<Snowflake_assigned_service_DNS_name>

-- Example 17002
spec:
  container:
  - name: echo
    image: <image-name>
    env:
      SERVER_PORT: 8000
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8000
      path: /healthcheck
  endpoint:
  - name: echoendpoint
    port: 8000
    public: true

-- Example 17003
spec:
  containers:
  - name: app
    image: <image1-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/app/logs
    - name: models
      mountPath: /opt/models
  - name: logging-agent
    image: <image2-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/logs
  volumes:
  - name: logs
    source: local
  - name: models
    source: "@model_stage"

-- Example 17004
spec:
  containers:
  - name: app
    image: <image1-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/app/logs
    - name: models
      mountPath: /opt/models
    - name: my-mem-volume
      mountPath: /dev/shm
  - name: logging-agent
    image: <image2-name>
    volumeMounts:
    - name: logs
      mountPath: /opt/logs
  volumes:
  - name: logs
    source: local
  - name: models
    source: "@model_stage"
  - name: "my-mem-volume"
    source: memory
    size: 2G

-- Example 17005
spec:
  ...

  volumes:
  - name: stagemount
    source: "@test"
    uid: <UID-value>
    gid: <GID-value>

-- Example 17006
CONTAINER ID   IMAGE                       COMMAND
—----------------------------------------------------------
a6a1f1fe204d  tutorial-image         "/usr/local/bin/entr…"

-- Example 17007
docker exec -it <container-id> id

-- Example 17008
uid=0(root) gid=0(root) groups=0(root)

-- Example 17009
logExporters:
  eventTableConfig:
    logLevel: < INFO | ERROR | NONE >

-- Example 17010
platformMonitor:
  metricConfig:
    groups:
    - <group_1>
    - <group_2>
    ...

-- Example 17011
capabilities:
  securityContext:
    executeAsCaller: <true / false>    # optional, indicates whether application intends to use caller’s rights

-- Example 17012
serviceRoles:                   # Optional list of service roles
- name: <name>
  endpoints:
  - <endpoint-name>
  - <endpoint-name>
  - ...
- ...

-- Example 17013
CREATE APPLICATION PACKAGE my_app_package ENABLE_RELEASE_CHANNELS=TRUE;
ALTER APPLICATION PACKAGE my_app_package SET ENABLE_RELEASE_CHANNELS=TRUE;

-- Example 17014
ALTER APPLICATION PACKAGE my_app_package MODIFY RELEASE CHANNEL ALPHA ADD ACCOUNTS=(ORG1.ACCOUNT1);

-- Example 17015
ALTER APPLICATION PACKAGE my_app_package MODIFY RELEASE CHANNEL ALPHA REMOVE ACCOUNTS=(ORG1.ACCOUNT1);

-- Example 17016
ALTER APPLICATION PACKAGE my_app_package MODIFY RELEASE CHANNEL ALPHA SET ACCOUNTS=(ORG1.ACCOUNT2);

-- Example 17017
SHOW RELEASE CHANNELS IN APPLICATION PACKAGE my_app_package;

-- Example 17018
SHOW RELEASE CHANNELS IN LISTING <listing_id>;

-- Example 17019
ALTER APPLICATION PACKAGE my_app_package REGISTER VERSION V1 USING '@stage/path';

-- Example 17020
ALTER APPLICATION PACKAGE my_app_package DEREGISTER VERSION v1;

-- Example 17021
ALTER APPLICATION PACKAGE my_app_package MODIFY RELEASE CHANNEL QA ADD VERSION V1;

-- Example 17022
ALTER APPLICATION PACKAGE my_app_package MODIFY RELEASE CHANNEL QA DROP VERSION V1;

-- Example 17023
ALTER APPLICATION PACKAGE my_app_package
  MODIFY RELEASE CHANNEL ALPHA
  SET DEFAULT RELEASE DIRECTIVE VERSION=v1 PATCH=10;

-- Example 17024
ALTER APPLICATION PACKAGE my_app_package
  MODIFY RELEASE CHANNEL ALPHA
  SET RELEASE DIRECTIVE my_custom_release_directive
  VERSION=V1 PATCH=11 ACCOUNTS=(ORG1.ACCOUNT1);

-- Example 17025
CREATE APPLICATION PACKAGE <name> MULTIPLE_INSTANCES=TRUE;
ALTER APPLICATION PACKAGE <name> SET MULTIPLE_INSTANCES=TRUE;

-- Example 17026
CREATE APPLICATION my_app
  FROM APPLICATION PACKAGE my_app_package
  USING RELEASE CHANNEL QA;

-- Example 17027
CREATE APPLICATION my_app
  FROM LISTING
  USING RELEASE CHANNEL QA;

-- Example 17028
CREATE [ OR REPLACE ] AUTHENTICATION POLICY [ IF NOT EXISTS ] <name>
  [ AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_ENROLLMENT = { REQUIRED | OPTIONAL } ]
  [ CLIENT_TYPES = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ SECURITY_INTEGRATIONS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 17029
CREATE OR ALTER AUTHENTICATION POLICY <name>
  [ AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_ENROLLMENT = { REQUIRED | OPTIONAL } ]
  [ CLIENT_TYPES = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ SECURITY_INTEGRATIONS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 17030
CREATE AUTHENTICATION POLICY restrict_client_types_policy
  CLIENT_TYPES = ('SNOWFLAKE_UI')
  COMMENT = 'Auth policy that only allows access through the web interface';

-- Example 17031
CREATE OR ALTER AUTHENTICATION POLICY restrict_client_types_policy
  MFA_ENROLLMENT = REQUIRED
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWFLAKE_CLI');

-- Example 17032
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY | VOLATILE } ] FILE FORMAT [ IF NOT EXISTS ] <name>
  [ TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM} [ formatTypeOptions ] ]
  [ COMMENT = '<string_literal>' ]

-- Example 17033
formatTypeOptions ::=
-- If TYPE = CSV
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
     FILE_EXTENSION = '<string>'
     PARSE_HEADER = TRUE | FALSE
     SKIP_HEADER = <integer>
     SKIP_BLANK_LINES = TRUE | FALSE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     ESCAPE = '<character>' | NONE
     ESCAPE_UNENCLOSED_FIELD = '<character>' | NONE
     TRIM_SPACE = TRUE | FALSE
     FIELD_OPTIONALLY_ENCLOSED_BY = '<character>' | NONE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
     ENCODING = '<string>' | UTF8
-- If TYPE = JSON
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     TRIM_SPACE = TRUE | FALSE
     MULTI_LINE = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     FILE_EXTENSION = '<string>'
     ENABLE_OCTAL = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
-- If TYPE = AVRO
     COMPRESSION = AUTO | GZIP | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = ORC
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = PARQUET
     COMPRESSION = AUTO | LZO | SNAPPY | NONE
     SNAPPY_COMPRESSION = TRUE | FALSE
     BINARY_AS_TEXT = TRUE | FALSE
     USE_LOGICAL_TYPE = TRUE | FALSE
     TRIM_SPACE = TRUE | FALSE
     USE_VECTORIZED_SCANNER = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = XML
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     PRESERVE_SPACE = TRUE | FALSE
     STRIP_OUTER_ELEMENT = TRUE | FALSE
     DISABLE_AUTO_CONVERT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE

-- Example 17034
CREATE OR ALTER [ { TEMP | TEMPORARY | VOLATILE } ] FILE FORMAT <name>
  [ TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] ]
  [ COMMENT = '<string_literal>' ]

-- Example 17035
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 17036
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 17037
"person":
 {
  "name": "Adam",
  "nickname": null,
  "age": 34,
  "phone_numbers":
  [
    "1234567890",
    "0987654321",
    null,
    "6781234590"
  ]
  }

-- Example 17038
"my_map":
 {
  "key_value":
  [
   {
          "key": "k1",
          "value": "v1"
      },
      {
          "key": "k2",
          "value": "v2"
      }
    ]
  }

-- Example 17039
"person":
 {
  "name": "Adam",
  "age": 34
  "phone_numbers":
  [
   "1234567890",
   "0987654321",
   "6781234590"
  ]
 }

-- Example 17040
CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = CSV
  COMMENT = 'my_file_format';

-- Example 17041
CREATE OR ALTER FILE FORMAT my_csv_format
  TYPE = CSV
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = true
  COMPRESSION = gzip;

-- Example 17042
CREATE OR REPLACE FILE FORMAT my_json_format
  TYPE = JSON;

-- Example 17043
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  COMPRESSION = SNAPPY;

-- Example 17044
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  USE_LOGICAL_TYPE = TRUE;

-- Example 17045
CREATE [ OR REPLACE ] TAG [ IF NOT EXISTS ] <name> [ COMMENT = '<string_literal>' ]

CREATE [ OR REPLACE ] TAG [ IF NOT EXISTS ] <name>
    [ ALLOWED_VALUES '<val_1>' [ , '<val_2>' [ , ... ] ] ]
    [ COMMENT = '<string_literal>' ]

-- Example 17046
CREATE OR ALTER TAG <name>
  [ ALLOWED_VALUES '<val_1>' [ , '<val_2>' [ , ... ] ] ]
  [ COMMENT = '<string_literal>' ]

-- Example 17047
CREATE TAG cost_center COMMENT = 'cost_center tag';

-- Example 17048
CREATE OR ALTER TAG cost_center ALLOWED_VALUES 'finance', 'engineering', 'sales';

-- Example 17049
conda install snowpark-checkpoints

-- Example 17050
pip install snowpark-checkpoints

-- Example 17051
conda install snowpark-checkpoints-collectors

-- Example 17052
pip install snowpark-checkpoints-collectors

-- Example 17053
conda install snowpark-checkpoints-hypothesis

-- Example 17054
pip install snowpark-checkpoints-hypothesis

-- Example 17055
conda install snowpark-checkpoints-validators

-- Example 17056
pip install snowpark-checkpoints-validators

-- Example 17057
conda install snowpark-checkpoints-configuration

-- Example 17058
pip install snowpark-checkpoints-configuration

-- Example 17059
def collect_dataframe_checkpoint(df: SparkDataFrame,
  checkpoint_name: str,
  sample: Optional[float],
  mode: Optional[CheckpointMode],
  output_path: Optional[str]) -> None:

-- Example 17060
def original_spark_code_I_dont_understand(df):
 from pyspark.sql.functions import col, when

 ret = df.withColumn(
     "life_stage",
     when(col("byte") < 4, "child")
     .when(col("byte").between(4, 10), "teenager")
     .otherwise("adult"),
 )
 return ret


@check_with_spark(
 job_context=job_context, spark_function=original_spark_code_I_dont_understand
)
def new_snowpark_code_I_do_understand(df):
  from snowflake.snowpark.functions import col, lit, when

  ref = df.with_column(
      "life_stage",
      when(col("byte") < 4, lit("child"))
      .when(col("byte").between(4, 10), lit("teenager"))
      .otherwise(lit("adult")),
 )
 return ref


 df1 = new_snowpark_code_I_do_understand(df)

-- Example 17061
# Check a schema/stats here!
validate_dataframe_checkpoint(
   df1,
"demo_add_a_column_dataframe",
job_context=job_context,
mode=CheckpointMode.DATAFRAME, # CheckpointMode.Schema)
)

-- Example 17062
from pandas import DataFrame as PandasDataFrame
from pandera import DataFrameSchema, Column, Check
from snowflake.snowpark import Session
from snowflake.snowpark import DataFrame as SnowparkDataFrame
from snowflake.snowpark_checkpoints.checkpoint import check_output_schema
from numpy import int8

# Define the Pandera schema
out_schema = DataFrameSchema(
{
    "COLUMN1": Column(int8, Check.between(0, 10, include_max=True, include_min=True)),
    "COLUMN2": Column(float, Check.less_than_or_equal_to(-1.2)),
    "COLUMN3": Column(float, Check.less_than(10)),
}
)

# Define the Snowpark function and apply the decorator
@check_output_schema(out_schema, "output_schema_checkpoint")
def preprocessor(dataframe: SnowparkDataFrame):
 return dataframe.with_column(
    "COLUMN3", dataframe["COLUMN1"] + dataframe["COLUMN2"]
)

# Create a Snowpark session and DataFrame
session = Session.builder.getOrCreate()
df = PandasDataFrame(
{
    "COLUMN1": [1, 4, 0, 10, 9],
    "COLUMN2": [-1.3, -1.4, -2.9, -10.1, -20.4],
}
)

sp_dataframe = session.create_dataframe(df)

# Apply the preprocessor function
preprocessed_dataframe = preprocessor(sp_dataframe)

-- Example 17063
from pandas import DataFrame as PandasDataFrame
from pandera import DataFrameSchema, Column, Check
from snowflake.snowpark import Session
from snowflake.snowpark import DataFrame as SnowparkDataFrame
from snowflake.snowpark_checkpoints.checkpoint import check_input_schema
from numpy import int8

# Define the Pandera schema
input_schema = DataFrameSchema(
{
    "COLUMN1": Column(int8, Check.between(0, 10, include_max=True, include_min=True)),
    "COLUMN2": Column(float, Check.less_than_or_equal_to(-1.2)),
}
)

# Define the Snowpark function and apply the decorator
@check_input_schema(input_schema, "input_schema_checkpoint")
def process_dataframe(dataframe: SnowparkDataFrame):
return dataframe.with_column(
    "COLUMN3", dataframe["COLUMN1"] + dataframe["COLUMN2"]
)

# Create a Snowpark session and DataFrame
session = Session.builder.getOrCreate()
df = PandasDataFrame(
{
    "COLUMN1": [1, 4, 0, 10, 9],
    "COLUMN2": [-1.3, -1.4, -2.9, -10.1, -20.4],
}
)
sp_dataframe = session.create_dataframe(df)

# Apply the process_dataframe function
processed_dataframe = process_dataframe(sp_dataframe)

