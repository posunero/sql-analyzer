-- Example 26976
CREATE OR REPLACE FUNCTION my_udf()
  RETURNS STRING
  LANGUAGE PYTHON
  PACKAGES = ('numpy==1.*')
  RUNTIME_VERSION = 3.10
  HANDLER = 'echo'
AS $$
def echo():
  return 'hi'
$$;

-- Example 26977
CREATE OR REPLACE FUNCTION my_udf()
  RETURNS STRING
  LANGUAGE PYTHON
  PACKAGES = ('numpy>=1.2')
  RUNTIME_VERSION = 3.10
  HANDLER = 'echo'
AS $$
def echo():
  return 'hi'
$$;

-- Example 26978
CREATE OR REPLACE FUNCTION my_udf()
  RETURNS STRING
  LANGUAGE PYTHON
  PACKAGES = ('numpy>=1.2,<2')
  RUNTIME_VERSION = 3.10
  HANDLER = 'echo'
AS $$
def echo():
  return 'hi'
$$;

-- Example 26979
CREATE OR REPLACE FUNCTION my_udf()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  IMPORTS = ('@my_stage/file.txt')
  HANDLER = 'compute'
AS $$
import sys
import os

with open(os.path.join(sys._xoptions["snowflake_import_directory"], 'file.txt'), "r") as f:
  s = f.read()

def compute():
  return s
$$;

-- Example 26980
CREATE OR REPLACE FUNCTION calc_phash(file_path STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python','imagehash','pillow')
  HANDLER = 'run'
AS $$
from PIL import Image
import imagehash
from snowflake.snowpark.files import SnowflakeFile

def run(file_path):
  with SnowflakeFile.open(file_path, 'rb') as f:
  return imagehash.average_hash(Image.open(f))
$$;

-- Example 26981
CREATE OR REPLACE FUNCTION calc_phash_distance(h1 STRING, h2 STRING)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('imagehash')
  HANDLER = 'run'
AS $$
import imagehash

def run(h1, h2):
  return imagehash.hex_to_hash(h1) - imagehash.hex_to_hash(h2)
$$;

-- Example 26982
PUT file:///tmp/image1.jpg @images AUTO_COMPRESS=FALSE;
PUT file:///tmp/image2.jpg @images AUTO_COMPRESS=FALSE;

ALTER STAGE images REFRESH;

-- Example 26983
SELECT
  calc_phash_distance(
    calc_phash(build_scoped_file_url(@images, 'image1.jpg')),
    calc_phash(build_scoped_file_url(@images, 'image2.jpg'))
  ) ;

-- Example 26984
CREATE FUNCTION parse_csv(file_path STRING)
  RETURNS TABLE (col1 STRING, col2 STRING, col3 STRING)
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'csvparser'
AS $$
from snowflake.snowpark.files import SnowflakeFile

class csvparser:
  def process(self, stagefile):
    with SnowflakeFile.open(stagefile) as f:
      for line in f.readlines():
        lineStr = line.strip()
        row = lineStr.split(",")
        try:
          # Read the columns from the line.
          yield (row[1], row[0], row[2], )
        except:
          pass
$$;

-- Example 26985
PUT file:///tmp/sample.csv @data_stage AUTO_COMPRESS=FALSE;

ALTER STAGE data_stage REFRESH;

-- Example 26986
SELECT * FROM TABLE(PARSE_CSV(build_scoped_file_url(@data_stage, 'sample.csv')));

-- Example 26987
CREATE OR REPLACE TABLE sentiment_results AS
SELECT
  relative_path
  , get_sentiment(build_scoped_file_url(@my_stage, relative_path)) AS sentiment
FROM directory(@my_stage);

-- Example 26988
SELECT t.*
FROM directory(@my_stage) d,
TABLE(parse_excel_udtf(build_scoped_file_url(@my_excel_stage, relative_path)) t;

-- Example 26989
CREATE OR REPLACE FUNCTION extract_sentiment(input_data STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python','scikit-learn')
  HANDLER = 'run'
AS $$
from snowflake.snowpark.files import SnowflakeFile
from sklearn.linear_model import SGDClassifier
import pickle

def run(input_data):
  model_file = '@models/NLP_model.pickle'
  # Specify 'mode = rb' to open the file in binary mode.
  with SnowflakeFile.open(model_file, 'rb', require_scoped_url = False) as f:
    model = pickle.load(f)
    return model.predict([input_data])[0]
$$;

-- Example 26990
PUT file:///tmp/NLP_model.pickle @models AUTO_COMPRESS=FALSE;

ALTER STAGE models REFRESH;

-- Example 26991
CREATE OR REPLACE FUNCTION extract_sentiment(input_data STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python','scikit-learn')
  HANDLER = 'run'
AS $$
from snowflake.snowpark.files import SnowflakeFile
from sklearn.linear_model import SGDClassifier
import pickle

def run(input_data):
  model_file = 'https://my_account/api/files/my_db/my_schema/models/NLP_model.pickle'
  # Specify 'rb' to open the file in binary mode.
  with SnowflakeFile.open(model_file, 'rb', require_scoped_url = False) as f:
    model = pickle.load(f)
    return model.predict([input_data])[0]
$$;

-- Example 26992
SELECT extract_sentiment('I am writing to express my interest in a recent posting made.');

-- Example 26993
def func(text):
  # Append the function's process ID to ensure the file name's uniqueness.
  file_path = '/tmp/content' + str(os.getpid())
  with open(file_path, "w") as file:
    file.write(text)

-- Example 26994
CREATE OR REPLACE FUNCTION py_spacy(str STRING)
  RETURNS ARRAY
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'func'
  PACKAGES = ('spacy')
  IMPORTS = ('@spacy_stage/spacy_en_core_web_sm.zip')
AS $$
import fcntl
import os
import spacy
import sys
import threading
import zipfile

 # File lock class for synchronizing write access to /tmp.
 class FileLock:
   def __enter__(self):
       self._lock = threading.Lock()
       self._lock.acquire()
       self._fd = open('/tmp/lockfile.LOCK', 'w+')
       fcntl.lockf(self._fd, fcntl.LOCK_EX)

    def __exit__(self, type, value, traceback):
       self._fd.close()
       self._lock.release()

 # Get the location of the import directory. Snowflake sets the import
 # directory location so code can retrieve the location via sys._xoptions.
 IMPORT_DIRECTORY_NAME = "snowflake_import_directory"
 import_dir = sys._xoptions[IMPORT_DIRECTORY_NAME]

 # Get the path to the ZIP file and set the location to extract to.
 zip_file_path = import_dir + "spacy_en_core_web_sm.zip"
 extracted = '/tmp/en_core_web_sm'

 # Extract the contents of the ZIP. This is done under the file lock
 # to ensure that only one worker process unzips the contents.
 with FileLock():
    if not os.path.isdir(extracted + '/en_core_web_sm/en_core_web_sm-2.3.1'):
       with zipfile.ZipFile(zip_file_path, 'r') as myzip:
          myzip.extractall(extracted)

 # Load the model from the extracted file.
 nlp = spacy.load(extracted + "/en_core_web_sm/en_core_web_sm-2.3.1")

 def func(text):
    doc = nlp(text)
    result = []

    for ent in doc.ents:
       result.append((ent.text, ent.start_char, ent.end_char, ent.label_))
    return result
 $$;

-- Example 26995
CREATE OR REPLACE FUNCTION py_udf_null(a VARIANT)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'udf'
AS $$

def udf(a):
   if not a:
       return 'JSON null'
   elif getattr(a, "is_sql_null", False):
       return 'SQL null'
   else:
       return 'not null'
$$;

-- Example 26996
SELECT py_udf_null(null);

-- Example 26997
+-------------------+
| PY_UDF_NULL(NULL) |
|-------------------|
| SQL null          |
+-------------------+

-- Example 26998
SELECT py_udf_null(parse_json('null'));

-- Example 26999
+---------------------------------+
| PY_UDF_NULL(PARSE_JSON('NULL')) |
|---------------------------------|
| JSON null                       |
+---------------------------------+

-- Example 27000
SELECT py_udf_null(10);

-- Example 27001
+-----------------+
| PY_UDF_NULL(10) |
|-----------------|
| not null        |
+-----------------+

-- Example 27002
UnicodeDecodeError: 'utf-8' codec can't decode byte 0xf7 in position 12: invalid start byte

-- Example 27003
with SnowflakeFile.open(file_name, 'rb') as f:

-- Example 27004
if (x < 0):
  raise ValueError("x must be non-negative.");

-- Example 27005
String user = "<user>";          // replace "<user>" with your user name
String password = "<password>";  // replace "<password>" with your password
Connection con = DriverManager.getConnection("jdbc:snowflake://<account>.snowflakecomputing.com/", user, password);

-- Example 27006
String user = "<user>";          // replace "<user>" with your user name
String password = "<password>";  // replace "<password>" with your password
Properties props = new Properties();
props.put("user", user);
props.put("password", password);
Connection con = DriverManager.getConnection("jdbc:snowflake://<account>.snowflakecomputing.com/", props);

-- Example 27007
Properties props = new Properties();
props.put("user", "myusername");
props.put("authenticator", "oauth");
props.put("role", "myrole");
props.put("password", "xxxxxxxxxxxxx"); // where xxxxxxxxxxxxx is the token string
Connection myconnection = DriverManager.getConnection(url, props);

-- Example 27008
net.snowflake.client.jdbc.SnowflakeSQLException: A connection was not created because the driver is running in diagnostics mode. If this is unintended then disable diagnostics check by removing the ENABLE_DIAGNOSTICS connection parameter

-- Example 27009
com.fasterxml.jackson.core.exc.StreamConstraintsException: String length (XXXXXXX) exceeds the maximum length (180000000)

-- Example 27010
SELECT t.VALUE:type::VARCHAR as type,
  t.VALUE:host::VARCHAR as host,
  t.VALUE:port as port
FROM TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$ALLOWLIST_PRIVATELINK()))) AS t
WHERE type ILIKE ANY ('OCSP%');

-- Example 27011
+-----------------------+---------------------------------------------------------------+------+
| TYPE                  | HOST                                                          | PORT |
|-----------------------+---------------------------------------------------------------+------|
| OCSP_CACHE            | ocsp.account1234.us-west-2.privatelink.snowflakecomputing.com | 80   |
| OCSP_CACHE_REGIONLESS | ocsp.my_org-my_account.privatelink.snowflakecomputing.com     | 80   |
+-----------------------+---------------------------------------------------------------+------+

-- Example 27012
Logger.setInstance(new NodeLogger({ logFilePath: 'STDOUT'}));

-- Example 27013
const snowflake = require('snowflake-sdk');

snowflake.configure({
  logLevel: "INFO",
  logFilePath: "/some/path/log_file.log",
  additionalLogToConsole: false
});

-- Example 27014
{
  "common": {
    "log_level": "INFO",
    "log_path": "/some-path/some-directory"
  }
}

-- Example 27015
const snowflake = require('snowflake-sdk');

var connection = snowflake.createConnection({
  account: account,
  username: user,
  password: password,
  application: application,
  clientConfigFile: '/some/path/client_config.json'
});

-- Example 27016
----------DATAFRAME EXECUTION PLAN----------
Query List:
0.
SELECT
  "_1" AS "col %",
  "_2" AS "col *"
FROM
  (
    SELECT
      *
    FROM
      (
        VALUES
          (1 :: int, 2 :: int),
          (3 :: int, 4 :: int) AS SN_TEMP_OBJECT_639016133("_1", "_2")
      )
  )
Logical Execution Plan:
 GlobalStats:
    partitionsTotal=0
    partitionsAssigned=0
    bytesAssigned=0
Operations:
1:0     ->Result  SN_TEMP_OBJECT_639016133.COLUMN1, SN_TEMP_OBJECT_639016133.COLUMN2
1:1          ->ValuesClause  (1, 2), (3, 4)

--------------------------------------------

-- Example 27017
# simplelogger.properties file (a text file)
# Set the default log level for the SimpleLogger to DEBUG.
org.slf4j.simpleLogger.defaultLogLevel=debug

-- Example 27018
java.base does not "opens java.nio" to unnamed module

-- Example 27019
--add-opens=java.base/java.nio=ALL-UNNAMED

-- Example 27020
java --add-opens=java.base/java.nio=ALL-UNNAMED -jar my-snowpark-app.jar.

-- Example 27021
java --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/sun.security.util=ALL-UNNAMED -jar my-snowpark-app.jar

-- Example 27022
export JDK_JAVA_OPTIONS="--add-opens=java.base/java.nio=ALL-UNNAMED"

-- Example 27023
export JDK_JAVA_OPTIONS="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/sun.security.util=ALL-UNNAMED"

-- Example 27024
CREATE OR REPLACE TABLE sample_product_data (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT, amount NUMBER(12, 2), quantity INT, product_date DATE);
INSERT INTO sample_product_data VALUES
    (1, 0, 5, 'Product 1', 'prod-1', 1, 10, 1.00, 15, TO_DATE('2021.01.01', 'YYYY.MM.DD')),
    (2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20, 2.00, 30, TO_DATE('2021.02.01', 'YYYY.MM.DD')),
    (3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30, 3.00, 45, TO_DATE('2021.03.01', 'YYYY.MM.DD')),
    (4, 0, 10, 'Product 2', 'prod-2', 2, 40, 4.00, 60, TO_DATE('2021.04.01', 'YYYY.MM.DD')),
    (5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50, 5.00, 75, TO_DATE('2021.05.01', 'YYYY.MM.DD')),
    (6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60, 6.00, 90, TO_DATE('2021.06.01', 'YYYY.MM.DD')),
    (7, 0, 20, 'Product 3', 'prod-3', 3, 70, 7.00, 105, TO_DATE('2021.07.01', 'YYYY.MM.DD')),
    (8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80, 7.25, 120, TO_DATE('2021.08.01', 'YYYY.MM.DD')),
    (9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90, 7.50, 135, TO_DATE('2021.09.01', 'YYYY.MM.DD')),
    (10, 0, 50, 'Product 4', 'prod-4', 4, 100, 7.75, 150, TO_DATE('2021.10.01', 'YYYY.MM.DD')),
    (11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100, 8.00, 165, TO_DATE('2021.11.01', 'YYYY.MM.DD')),
    (12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100, 8.50, 180, TO_DATE('2021.12.01', 'YYYY.MM.DD'));

-- Example 27025
SELECT * FROM sample_product_data;

-- Example 27026
// Create a DataFrame from the data in the "sample_product_data" table.
DataFrame dfTable = session.table("sample_product_data");

// Print out the first 10 rows.
dfTable.show();

-- Example 27027
// Import name from the types package, which contains StructType and StructField.
import com.snowflake.snowpark_java.types.*;
...

 // Create a DataFrame containing specified values.
 Row[] data = {Row.create(1, "a"), Row.create(2, "b")};
 StructType schema =
   StructType.create(
     new StructField("num", DataTypes.IntegerType),
     new StructField("str", DataTypes.StringType));
 DataFrame df = session.createDataFrame(data, schema);

 // Print the contents of the DataFrame.
 df.show();

-- Example 27028
// Create a DataFrame from a range
DataFrame dfRange = session.range(1, 10, 2);

// Print the contents of the DataFrame.
dfRange.show();

-- Example 27029
// Create a DataFrame from data in a stage.
DataFrame dfJson = session.read().json("@mystage2/data1.json");

// Print the contents of the DataFrame.
dfJson.show();

-- Example 27030
// Create a DataFrame from a SQL query
DataFrame dfSql = session.sql("SELECT name from sample_product_data");

// Print the contents of the DataFrame.
dfSql.show();

-- Example 27031
// Create a DataFrame for the rows with the ID 1
// in the "sample_product_data" table.
DataFrame df = session.table("sample_product_data").filter(
  Functions.col("id").equal_to(Functions.lit(1)));
df.show();

-- Example 27032
// Create a DataFrame that contains the id, name, and serial_number
// columns in te "sample_product_data" table.
DataFrame df = session.table("sample_product_data").select(
  Functions.col("id"), Functions.col("name"), Functions.col("serial_number"));
df.show();

-- Example 27033
DataFrame dfProductInfo = session.table("sample_product_data").select(Functions.col("id"), Functions.col("name"));
dfProductInfo.show();

-- Example 27034
// Specify the equivalent of "WHERE id = 12"
// in an SQL SELECT statement.
DataFrame df = session.table("sample_product_data");
df.filter(Functions.col("id").equal_to(Functions.lit(12))).show();

-- Example 27035
// Specify the equivalent of "WHERE key + category_id < 10"
// in an SQL SELECT statement.
DataFrame df2 = session.table("sample_product_data");
df2.filter(Functions.col("key").plus(Functions.col("category_id")).lt(Functions.lit(10))).show();

-- Example 27036
// Specify the equivalent of "SELECT key * 10 AS c"
// in an SQL SELECT statement.
DataFrame df3 = session.table("sample_product_data");
df3.select(Functions.col("key").multiply(Functions.lit(10)).as("c")).show();

-- Example 27037
// Specify the equivalent of "sample_a JOIN sample_b on sample_a.id_a = sample_b.id_a"
// in an SQL SELECT statement.
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a")));
dfJoined.show();

-- Example 27038
// Create a DataFrame that joins two other DataFrames (dfLhs and dfRhs).
// Use the DataFrame.col method to refer to the columns used in the join.
DataFrame dfLhs = session.table("sample_a");
DataFrame dfRhs = session.table("sample_b");
DataFrame dfJoined = dfLhs.join(dfRhs, dfLhs.col("id_a").equal_to(dfRhs.col("id_a"))).select(dfLhs.col("value").as("L"), dfRhs.col("value").as("R"));
dfJoined.show();

-- Example 27039
// The following calls are equivalent:
df.select(Functions.col("id123"));
df.select(Functions.col("ID123"));

-- Example 27040
DataFrame df = session.table("\"10tablename\"");

-- Example 27041
// The following calls are equivalent:
df.select(Functions.col("3rdID"));
df.select(Functions.col("\"3rdID\""));

// The following calls are equivalent:
df.select(Functions.col("id with space"));
df.select(Functions.col("\"id with space\""));

-- Example 27042
describe table quoted;
+------------------------+ ...
| name                   | ...
|------------------------+ ...
| name_with_"air"_quotes | ...
| "column_name_quoted"   | ...
+------------------------+ ...

