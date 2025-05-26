-- More Extracted Snowflake SQL Examples (Set 6)

-- From snowflake_split_403.sql

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

PUT file:///tmp/image1.jpg @images AUTO_COMPRESS=FALSE;
PUT file:///tmp/image2.jpg @images AUTO_COMPRESS=FALSE;

ALTER STAGE images REFRESH;

SELECT
  calc_phash_distance(
    calc_phash(build_scoped_file_url(@images, 'image1.jpg')),
    calc_phash(build_scoped_file_url(@images, 'image2.jpg'))
  ) ;

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

PUT file:///tmp/sample.csv @data_stage AUTO_COMPRESS=FALSE;

ALTER STAGE data_stage REFRESH;

SELECT * FROM TABLE(PARSE_CSV(build_scoped_file_url(@data_stage, 'sample.csv')));

CREATE OR REPLACE TABLE sentiment_results AS
SELECT
  relative_path
  , get_sentiment(build_scoped_file_url(@my_stage, relative_path)) AS sentiment
FROM directory(@my_stage); 