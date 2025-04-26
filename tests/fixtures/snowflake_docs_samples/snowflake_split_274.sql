-- Example 18336
VECTOR( <type>, <dimension> )

-- Example 18337
VECTOR(FLOAT, 256)

-- Example 18338
VECTOR(INT, 16)

-- Example 18339
VECTOR(STRING, 256)

-- Example 18340
VECTOR(INT, -1)

-- Example 18341
CREATE OR REPLACE TABLE myvectortable (a VECTOR(float, 3), b VECTOR(float, 3));
INSERT INTO myvectortable SELECT [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3);
INSERT INTO myvectortable SELECT [1,2.2,3]::VECTOR(FLOAT,3), [4,6,8]::VECTOR(FLOAT,3);

COPY INTO @mystage/unload/
  FROM (SELECT TO_ARRAY(a), TO_ARRAY(b) FROM myvectortable);

-- Example 18342
CREATE OR REPLACE TABLE arraytable (a ARRAY, b ARRAY);

COPY INTO arraytable
  FROM @mystage/unload/mydata.csv.gz;

SELECT a::VECTOR(FLOAT, 3), b::VECTOR(FLOAT, 3)
  FROM arraytable;

-- Example 18343
SELECT [1, 2, 3]::VECTOR(FLOAT, 3) AS vec;

-- Example 18344
ALTER TABLE myissues ADD COLUMN issue_vec VECTOR(FLOAT, 768);

UPDATE TABLE myissues
  SET issue_vec = SNOWFLAKE.CORTEX.EMBED_TEXT_768('e5-base-v2', issue_text);

-- Example 18345
SELECT 10.01 n1, 1.1 n2, n1 * n2;

-- Example 18346
+-------+-----+---------+
|    N1 |  N2 | N1 * N2 |
|-------+-----+---------|
| 10.01 | 1.1 |  11.011 |
+-------+-----+---------+

-- Example 18347
SELECT 10.001 n1, .001 n2, n1 * n2;

-- Example 18348
+--------+-------+----------+
|     I1 |    I2 |  I1 * I2 |
|--------+-------+----------|
| 10.001 | 0.001 | 0.010001 |
+--------+-------+----------+

-- Example 18349
SELECT .1 n1, .0000000000001 n2, n1 * n2;

-- Example 18350
+-----+-----------------+-----------------+
|  N1 |              N2 |         N1 * N2 |
|-----+-----------------+-----------------|
| 0.1 | 0.0000000000001 | 0.0000000000000 |
+-----+-----------------+-----------------+

-- Example 18351
SELECT 2 n1, 7 n2, n1 / n2;

-- Example 18352
+----+----+----------+
| N1 | N2 |  N1 / N2 |
|----+----+----------|
|  2 |  7 | 0.285714 |
+----+----+----------+

-- Example 18353
SELECT 10.1 n1, 2.1 n2, n1 / n2;

-- Example 18354
+------+-----+-----------+
|   N1 |  N2 |   N1 / N2 |
|------+-----+-----------|
| 10.1 | 2.1 | 4.8095238 |
+------+-----+-----------+

-- Example 18355
SELECT 10.001 n1, .001 n2, n1 / n2;

-- Example 18356
+--------+-------+-----------------+
|     N1 |    N2 |         N1 / N2 |
|--------+-------+-----------------|
| 10.001 | 0.001 | 10001.000000000 |
+--------+-------+-----------------+

-- Example 18357
SELECT .1 n1, .0000000000001 n2, n1 / n2;

-- Example 18358
+-----+-----------------+-----------------------+
|  N1 |              N2 |               N1 / N2 |
|-----+-----------------+-----------------------|
| 0.1 | 0.0000000000001 | 1000000000000.0000000 |
+-----+-----------------+-----------------------+

-- Example 18359
CREATE OR REPLACE FUNCTION py_udf()
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('numpy','pandas','xgboost==1.5.0')
  HANDLER = 'udf'
AS $$
import numpy as np
import pandas as pd
import xgboost as xgb
def udf():
  return [np.__version__, pd.__version__, xgb.__version__]
$$;

-- Example 18360
SELECT py_udf();

-- Example 18361
+-------------+
| PY_UDF()    |
|-------------|
| [           |
|   "1.19.2", |
|   "1.4.0",  |
|   "1.5.0"   |
| ]           |
+-------------+

-- Example 18362
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

-- Example 18363
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

-- Example 18364
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

-- Example 18365
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

-- Example 18366
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

-- Example 18367
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

-- Example 18368
PUT file:///tmp/image1.jpg @images AUTO_COMPRESS=FALSE;
PUT file:///tmp/image2.jpg @images AUTO_COMPRESS=FALSE;

ALTER STAGE images REFRESH;

-- Example 18369
SELECT
  calc_phash_distance(
    calc_phash(build_scoped_file_url(@images, 'image1.jpg')),
    calc_phash(build_scoped_file_url(@images, 'image2.jpg'))
  ) ;

-- Example 18370
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

-- Example 18371
PUT file:///tmp/sample.csv @data_stage AUTO_COMPRESS=FALSE;

ALTER STAGE data_stage REFRESH;

-- Example 18372
SELECT * FROM TABLE(PARSE_CSV(build_scoped_file_url(@data_stage, 'sample.csv')));

-- Example 18373
CREATE OR REPLACE TABLE sentiment_results AS
SELECT
  relative_path
  , get_sentiment(build_scoped_file_url(@my_stage, relative_path)) AS sentiment
FROM directory(@my_stage);

-- Example 18374
SELECT t.*
FROM directory(@my_stage) d,
TABLE(parse_excel_udtf(build_scoped_file_url(@my_excel_stage, relative_path)) t;

-- Example 18375
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

-- Example 18376
PUT file:///tmp/NLP_model.pickle @models AUTO_COMPRESS=FALSE;

ALTER STAGE models REFRESH;

-- Example 18377
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

-- Example 18378
SELECT extract_sentiment('I am writing to express my interest in a recent posting made.');

-- Example 18379
def func(text):
  # Append the function's process ID to ensure the file name's uniqueness.
  file_path = '/tmp/content' + str(os.getpid())
  with open(file_path, "w") as file:
    file.write(text)

-- Example 18380
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

-- Example 18381
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

-- Example 18382
SELECT py_udf_null(null);

-- Example 18383
+-------------------+
| PY_UDF_NULL(NULL) |
|-------------------|
| SQL null          |
+-------------------+

-- Example 18384
SELECT py_udf_null(parse_json('null'));

-- Example 18385
+---------------------------------+
| PY_UDF_NULL(PARSE_JSON('NULL')) |
|---------------------------------|
| JSON null                       |
+---------------------------------+

-- Example 18386
SELECT py_udf_null(10);

-- Example 18387
+-----------------+
| PY_UDF_NULL(10) |
|-----------------|
| not null        |
+-----------------+

-- Example 18388
CREATE OR REPLACE PROCEDURE calc_phash(file_path string)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python','imagehash','pillow')
HANDLER = 'run'
AS
$$
from PIL import Image
import imagehash
from snowflake.snowpark.files import SnowflakeFile

def run(ignored_session, file_path):
    with SnowflakeFile.open(file_path, 'rb') as f:
        return imagehash.average_hash(Image.open(f))
$$;

-- Example 18389
CALL calc_phash(build_scoped_file_url(@my_files, 'my_image.jpg'));

-- Example 18390
CREATE OR REPLACE TABLE week_examples (d DATE);

INSERT INTO week_examples VALUES
  ('2016-12-30'),
  ('2016-12-31'),
  ('2017-01-01'),
  ('2017-01-02'),
  ('2017-01-03'),
  ('2017-01-04'),
  ('2017-01-05'),
  ('2017-12-30'),
  ('2017-12-31');

-- Example 18391
ALTER SESSION SET WEEK_START = 0;

SELECT d "Date",
       DAYNAME(d) "Day",
       DAYOFWEEK(d) "DOW",
       DATE_TRUNC('week', d) "Trunc Date",
       DAYNAME("Trunc Date") "Trunc Day",
       LAST_DAY(d, 'week') "Last DOW Date",
       DAYNAME("Last DOW Date") "Last DOW Day",
       DATEDIFF('week', '2017-01-01', d) "Weeks Diff from 2017-01-01 to Date"
  FROM week_examples;

-- Example 18392
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+
| Date       | Day | DOW | Trunc Date | Trunc Day | Last DOW Date | Last DOW Day | Weeks Diff from 2017-01-01 to Date |
|------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------|
| 2016-12-30 | Fri |   5 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2016-12-31 | Sat |   6 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-01 | Sun |   0 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-02 | Mon |   1 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-03 | Tue |   2 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-04 | Wed |   3 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-05 | Thu |   4 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-12-30 | Sat |   6 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
| 2017-12-31 | Sun |   0 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+

-- Example 18393
ALTER SESSION SET WEEK_START = 1;

SELECT d "Date",
       DAYNAME(d) "Day",
       DAYOFWEEK(d) "DOW",
       DATE_TRUNC('week', d) "Trunc Date",
       DAYNAME("Trunc Date") "Trunc Day",
       LAST_DAY(d, 'week') "Last DOW Date",
       DAYNAME("Last DOW Date") "Last DOW Day",
       DATEDIFF('week', '2017-01-01', d) "Weeks Diff from 2017-01-01 to Date"
  FROM week_examples;

-- Example 18394
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+
| Date       | Day | DOW | Trunc Date | Trunc Day | Last DOW Date | Last DOW Day | Weeks Diff from 2017-01-01 to Date |
|------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------|
| 2016-12-30 | Fri |   5 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2016-12-31 | Sat |   6 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-01 | Sun |   7 | 2016-12-26 | Mon       | 2017-01-01    | Sun          |                                  0 |
| 2017-01-02 | Mon |   1 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-03 | Tue |   2 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-04 | Wed |   3 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-01-05 | Thu |   4 | 2017-01-02 | Mon       | 2017-01-08    | Sun          |                                  1 |
| 2017-12-30 | Sat |   6 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
| 2017-12-31 | Sun |   7 | 2017-12-25 | Mon       | 2017-12-31    | Sun          |                                 52 |
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+

-- Example 18395
ALTER SESSION SET WEEK_START = 3;

SELECT d "Date",
       DAYNAME(d) "Day",
       DAYOFWEEK(d) "DOW",
       DATE_TRUNC('week', d) "Trunc Date",
       DAYNAME("Trunc Date") "Trunc Day",
       LAST_DAY(d, 'week') "Last DOW Date",
       DAYNAME("Last DOW Date") "Last DOW Day",
       DATEDIFF('week', '2017-01-01', d) "Weeks Diff from 2017-01-01 to Date"
  FROM week_examples;

-- Example 18396
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+
| Date       | Day | DOW | Trunc Date | Trunc Day | Last DOW Date | Last DOW Day | Weeks Diff from 2017-01-01 to Date |
|------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------|
| 2016-12-30 | Fri |   3 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2016-12-31 | Sat |   4 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-01 | Sun |   5 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-02 | Mon |   6 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-03 | Tue |   7 | 2016-12-28 | Wed       | 2017-01-03    | Tue          |                                  0 |
| 2017-01-04 | Wed |   1 | 2017-01-04 | Wed       | 2017-01-10    | Tue          |                                  1 |
| 2017-01-05 | Thu |   2 | 2017-01-04 | Wed       | 2017-01-10    | Tue          |                                  1 |
| 2017-12-30 | Sat |   4 | 2017-12-27 | Wed       | 2018-01-02    | Tue          |                                 52 |
| 2017-12-31 | Sun |   5 | 2017-12-27 | Wed       | 2018-01-02    | Tue          |                                 52 |
+------------+-----+-----+------------+-----------+---------------+--------------+------------------------------------+

-- Example 18397
ALTER SESSION SET WEEK_OF_YEAR_POLICY=0, WEEK_START=0;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 18398
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  52 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  52 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |  52 |        52 | 2016 |      2016 |
| 2017-01-02 | Mon |   1 |         1 | 2017 |      2017 |
| 2017-01-03 | Tue |   1 |         1 | 2017 |      2017 |
| 2017-01-04 | Wed |   1 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   1 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  52 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  52 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

-- Example 18399
ALTER SESSION SET WEEK_OF_YEAR_POLICY=0, WEEK_START=3;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 18400
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  53 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  53 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |  53 |        52 | 2016 |      2016 |
| 2017-01-02 | Mon |  53 |         1 | 2016 |      2017 |
| 2017-01-03 | Tue |  53 |         1 | 2016 |      2017 |
| 2017-01-04 | Wed |   1 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   1 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  52 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  52 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

-- Example 18401
ALTER SESSION SET WEEK_OF_YEAR_POLICY=1, WEEK_START=1;

SELECT d "Date",
       DAYNAME(d) "Day",
       WEEK(d) "WOY",
       WEEKISO(d) "WOY (ISO)",
       YEAROFWEEK(d) "YOW",
       YEAROFWEEKISO(d) "YOW (ISO)"
  FROM week_examples;

-- Example 18402
+------------+-----+-----+-----------+------+-----------+
| Date       | Day | WOY | WOY (ISO) |  YOW | YOW (ISO) |
|------------+-----+-----+-----------+------+-----------|
| 2016-12-30 | Fri |  53 |        52 | 2016 |      2016 |
| 2016-12-31 | Sat |  53 |        52 | 2016 |      2016 |
| 2017-01-01 | Sun |   1 |        52 | 2017 |      2016 |
| 2017-01-02 | Mon |   2 |         1 | 2017 |      2017 |
| 2017-01-03 | Tue |   2 |         1 | 2017 |      2017 |
| 2017-01-04 | Wed |   2 |         1 | 2017 |      2017 |
| 2017-01-05 | Thu |   2 |         1 | 2017 |      2017 |
| 2017-12-30 | Sat |  53 |        52 | 2017 |      2017 |
| 2017-12-31 | Sun |  53 |        52 | 2017 |      2017 |
+------------+-----+-----+-----------+------+-----------+

