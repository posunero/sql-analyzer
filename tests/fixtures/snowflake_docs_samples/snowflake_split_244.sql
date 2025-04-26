-- Example 16327
from snowflake.snowpark.types import IntegerType
# suppose you have uploaded test_udf_file.py to stage location @mystage.
mod5_udf = session.udf.register_from_file(
  file_path="@mystage/test_udf_file.py",
  func_name="mod5",
  return_type=IntegerType(),
  input_types=[IntegerType()],
)
session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()

-- Example 16328
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 16329
# Import a file from your local machine as a dependency.
session.add_import("/<path>/my_file.txt")

# Or import a file that you uploaded to a stage as a dependency.
session.add_import("@my_stage/<path>/my_file.txt")

-- Example 16330
import sys
import os
import cachetools
from snowflake.snowpark.types import StringType
@cachetools.cached(cache={})
def read_file(filename):
   import_dir = sys._xoptions.get("snowflake_import_directory")
      if import_dir:
         with open(os.path.join(import_dir, filename), "r") as f:
            return f.read()

   # create a temporary text file for test
temp_file_name = "/tmp/temp.txt"
with open(temp_file_name, "w") as t:
   _ = t.write("snowpark")
session.add_import(temp_file_name)
session.add_packages("cachetools")

def add_suffix(s):
   return f"{read_file(os.path.basename(temp_file_name))}-{s}"

concat_file_content_with_str_udf = session.udf.register(
      add_suffix,
      return_type=StringType(),
      input_types=[StringType()]
   )

df = session.create_dataframe(["snowflake", "python"], schema=["a"])
df.select(concat_file_content_with_str_udf("a")).to_df("col1").collect()

-- Example 16331
[Row(COL1='snowpark-snowflake'), Row(COL1='snowpark-python')]

-- Example 16332
os.remove(temp_file_name)
session.clear_imports()

-- Example 16333
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import udf
from snowflake.snowpark.files import SnowflakeFile
from snowflake.snowpark.types import StringType, IntegerType

@udf(name="get_file_length", replace=True, input_types=[StringType()], return_type=IntegerType(), packages=['snowflake-snowpark-python'])
def get_file_length(file_path):
  with SnowflakeFile.open(file_path) as f:
    s = f.read()
  return len(s);

-- Example 16334
session.sql("select get_file_length(build_scoped_file_url(@my_stage, 'example-file.txt'));")

-- Example 16335
CREATE OR REPLACE FUNCTION write_file()
RETURNS STRING
LANGUAGE PYTHON
VOLATILE
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'write_file'
AS
$$
from snowflake.snowpark.files import SnowflakeFile

def write_file():
  file = SnowflakeFile.open_new_result("w") # Open a new result file
  file.write("Hello world")                 # Write data
  return file               # File must be returned
$$;

-- Example 16336
CREATE OR REPLACE FUNCTION convert_to_foo(filename string)
RETURNS STRING
LANGUAGE PYTHON
VOLATILE
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'convert_to_foo'
AS
$$
from snowflake.snowpark.files import SnowflakeFile

def convert_to_foo(filename):
  input_file = SnowflakeFile.open(filename, "r")
  converted_file = SnowflakeFile.open_new_result("w")

  # Foo-type is just adding foo at the end of every line
  for line in input_file.readlines():
    converted_file.write(line[:-1] + 'foo' + '\n')
  return converted_file
$$;

-- Example 16337
COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, 'in.txt')), 'out.foo.txt');

-- Example 16338
CREATE TABLE files_to_convert(file string);
-- Populate files_to_convert with input files:
INSERT INTO files_to_convert VALUES ('file1.txt');
INSERT INTO files_to_convert VALUES ('file2.txt');

COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file)),
      REPLACE(file, '.txt', '.foo.txt') FROM files_to_convert);

-- Example 16339
COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, RELATIVE_PATH)),
      REPLACE(RELATIVE_PATH, 'format1', 'format2') FROM DIRECTORY(@input_stage));

-- Example 16340
-- A basic UDF to read a file:
CREATE OR REPLACE FUNCTION read_udf(filename string)
RETURNS STRING
LANGUAGE PYTHON
VOLATILE
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'read'
AS
'
from snowflake.snowpark.files import SnowflakeFile

def read(filename):
  return SnowflakeFile.open(filename, "r").read()
';

-- Example 16341
-- Create files_to_convert as in Example 2.

SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file)) as new_file
  FROM files_to_convert;
-- The following query must be run within 24 hours from the prior one
SELECT read_udf(new_file) FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- Example 16342
-- Set up files_to_convert as in Example 2.
-- Set up read_udf as in Example 4.

SELECT read_udf(
    convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file))) FROM files_to_convert;

-- Example 16343
COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file)) FROM files_to_convert);

-- Refresh the directory to get new files in output_stage.
ALTER STAGE output_stage REFRESH;

-- Example 16344
-- Create a stage that includes the font (for PDF creation)

CREATE OR REPLACE STAGE fonts
URL = 's3://sfquickstarts/misc/';

-- UDF to write the data
CREATE OR REPLACE FUNCTION create_report_pdf(data string)
RETURNS TABLE (file string)
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
HANDLER='CreateReport'
PACKAGES = ('snowflake-snowpark-python', 'fpdf')
IMPORTS  = ('@fonts/DejaVuSans.ttf')
AS $$
from snowflake.snowpark.files import SnowflakeFile
from fpdf import FPDF
import shutil
import sys
import uuid
import_dir = sys._xoptions["snowflake_import_directory"]

class CreateReport:
  def __init__(self):
      self.pdf = None

  def process(self, data):
      if self.pdf == None:
        # PDF library edits this file, make sure it's unique.
        font_file = f'/tmp/DejaVuSans-{uuid.uuid4()}.ttf'
        shutil.copy(f'{import_dir}/DejaVuSans.ttf', font_file)
        self.pdf = FPDF()
        self.pdf.add_page()
        self.pdf.add_font('DejaVu', '', font_file, uni=True)
        self.pdf.set_font('DejaVu', '', 14)
      self.pdf.write(8, data)
      self.pdf.ln(8)

  def end_partition(self):
      f = SnowflakeFile.open_new_result("wb")
      f.write(self.pdf.output(dest='S').encode('latin-1'))
      yield f,
$$;

-- Example 16345
-- Fictitious data
 CREATE OR REPLACE TABLE reportData(location string, item string);
 INSERT INTO reportData VALUES ('SanMateo' ,'Item A');
 INSERT INTO reportData VALUES ('SanMateo' ,'Item Z');
 INSERT INTO reportData VALUES ('SanMateo' ,'Item X');
 INSERT INTO reportData VALUES ('Bellevue' ,'Item B');
 INSERT INTO reportData VALUES ('Bellevue' ,'Item Q');

 -- Presigned URLs only work with SSE stages, see note above.
 CREATE OR REPLACE STAGE output_stage ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

 COPY FILES INTO @output_stage
   FROM (SELECT reports.file, location || '.pdf'
           FROM reportData, TABLE(create_report_pdf(item)
           OVER (partition BY location)) AS reports);

 -- Check the results
LIST @output_stage;
SELECT GET_PRESIGNED_URL(@output_stage, 'SanMateo.pdf');

-- Example 16346
CREATE OR REPLACE FUNCTION split_file(path string)
RETURNS TABLE(file string, name string)
LANGUAGE PYTHON
VOLATILE
PACKAGES = ('snowflake-snowpark-python')
RUNTIME_VERSION = 3.9
HANDLER = 'SplitCsvFile'
AS $$
import csv
from snowflake.snowpark.files import SnowflakeFile

class SplitCsvFile:
    def process(self, file):
      toTable1 = SnowflakeFile.open_new_result("w")
      toTable1Csv = csv.writer(toTable1)
      toTable2 = SnowflakeFile.open_new_result("w")
      toTable2Csv = csv.writer(toTable2)
      toTable3 = SnowflakeFile.open_new_result("w")
      toTable3Csv = csv.writer(toTable3)
      with SnowflakeFile.open(file, 'r') as file:
        # File is of the format 1:itemA \n 2:itemB \n [...]
        for line in file.readlines():
          forTable = line[0]
          if (forTable == "1"):
            toTable1Csv.writerow([line[2:-1]])
          if (forTable == "2"):
            toTable2Csv.writerow([line[2:-1]])
          if (forTable == "3"):
            toTable3Csv.writerow([line[2:-1]])
      yield toTable1, 'table1.csv'
      yield toTable2, 'table2.csv'
      yield toTable3, 'table3.csv'
$$;
-- Create a stage with access to an import file.
CREATE OR REPLACE STAGE staged_files url="s3://sfquickstarts/misc/";

-- Add the files to be split into a table - we just add one.
CREATE OR REPLACE TABLE filesToSplit(path string);
INSERT INTO filesToSplit VALUES ( 'items.txt');

-- Create output tables
CREATE OR REPLACE TABLE table1(item string);
CREATE OR REPLACE TABLE table2(item string);
CREATE OR REPLACE TABLE table3(item string);

-- Create output stage
CREATE OR REPLACE stage output_stage;

-- Creates files named path-tableX.csv
COPY FILES INTO @output_stage FROM
  (SELECT file, path || '-' || name FROM filesToSplit, TABLE(split_file(build_scoped_file_url(@staged_files, path))));

-- We use pattern and COPY INTO (not COPY FILES INTO) to upload to a final table.
COPY INTO table1 FROM @output_stage PATTERN = '.*.table1.csv';
COPY INTO table2 FROM @output_stage PATTERN = '.*.table2.csv';
COPY INTO table3 FROM @output_stage PATTERN = '.*.table3.csv';

-- See results
SELECT * from table1;
SELECT * from table2;
SELECT * from table3;

-- Example 16347
from sklearn.linear_model import LinearRegression
model = LinearRegression()
model.fit(X, y)

@udf(packages=['pandas', 'scikit-learn','xgboost'])
def predict(df: PandasDataFrame[float, float, float, float]) -> PandasSeries[float]:
    # The input pandas DataFrame doesn't include column names. Specify the column names explicitly when needed.
    df.columns = ["col1", "col2", "col3", "col4"]
    return model.predict(df)

-- Example 16348
import snowflake.snowpark as snowpark
from snowflake.snowpark.types import IntegerType
from snowflake.snowpark.functions import udaf
def main(session: snowpark.Session):
class PythonSumUDAF:
  def __init__(self):
    # This aggregate state is a primitive Python data type.
    self._partial_sum = 0

  @property
  def aggregate_state(self):
    return self._partial_sum

  def accumulate(self, input_value):
    self._partial_sum += input_value

  def merge(self, other_partial_sum):
    self._partial_sum += other_partial_sum

  def finish(self):
    return self._partial_sum
sum_udaf = udaf(PythonSumUDAF, name="sum_int", replace=True, return_type=IntegerType(), input_types=[IntegerType()])

-- Example 16349
df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
result = df.agg(sum_udaf("a")).collect()
print(result.collect())

-- Example 16350
import snowflake.snowpark as snowpark
from snowflake.snowpark.types import IntegerType
from snowflake.snowpark.functions import udaf
def main(session: snowpark.Session):
  class PythonSumUDAF:
    def __init__(self):
      self._partial_sum = 0

    @property
  def aggregate_state(self):
    return self._partial_sum

  def accumulate(self, input_value, input_value2):
    self._partial_sum += input_value + input_value2

  def merge(self, other_partial_sum):
    self._partial_sum += other_partial_sum

  def finish(self):
    return self._partial_sum
sum_udaf = udaf(PythonSumUDAF, name="sum_int", replace=True, return_type=IntegerType(), input_types=[IntegerType(), IntegerType()])

-- Example 16351
df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
result = df.agg(sum_udaf("a", "b"))
print(result.collect())

-- Example 16352
from snowflake.snowpark.types import StructField, StructType, StringType, IntegerType, FloatType
from snowflake.snowpark.functions import udtf, table_function
schema = StructType([
  StructField("symbol", StringType())
  StructField("cost", IntegerType()),
])
@udtf(output_schema=schema,input_types=[StringType(), IntegerType(), FloatType()],stage_location="straut_udf",is_permanent=True,name="test_udtf",replace=True)
class StockSale:
  def process(self, symbol, quantity, price):
    cost = quantity * price
    yield (symbol, cost)

-- Example 16353
from snowflake.snowpark.types import IntegerType, StructField, StructType
from snowflake.snowpark.functions import udtf, lit
class GeneratorUDTF:
    def process(self, n):
        for i in range(n):
            yield (i, )
generator_udtf = udtf(GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])

-- Example 16354
session.table_function(generator_udtf(lit(3))).collect()  # Query it by calling it

-- Example 16355
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 16356
session.table_function(generator_udtf.name, lit(3)).collect()  # Query it by using the name

-- Example 16357
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 16358
from collections import Counter
from typing import Iterable, Tuple
from snowflake.snowpark.functions import lit
class MyWordCount:
      def __init__(self):
          self._total_per_partition = 0

      def process(self, s1: str) -> Iterable[Tuple[str, int]]:
        words = s1.split()
        self._total_per_partition = len(words)
        counter = Counter(words)
        yield from counter.items()

    def end_partition(self):
        yield ("partition_total", self._total_per_partition)
udtf_name = "word_count_udtf"
word_count_udtf = session.udtf.register(
    MyWordCount, ["word", "count"], name=udtf_name, is_permanent=False, replace=True
)

-- Example 16359
# Call it by its name
df1 = session.table_function(udtf_name, lit("w1 w2 w2 w3 w3 w3"))
df1.show()

-- Example 16360
-----------------------------
|"WORD"           |"COUNT"  |
-----------------------------
|w1               |1        |
|w2               |2        |
|w3               |3        |
|partition_total  |6        |
-----------------------------

-- Example 16361
from snowflake.snowpark.types import IntegerType, StructField, StructType
from snowflake.snowpark.functions import udtf, lit
_ = session.sql("create or replace temp stage mystage").collect()
_ = session.file.put("tests/resources/test_udtf_dir/test_udtf_file.py", "@mystage", auto_compress=False)
generator_udtf = session.udtf.register_from_file(
    file_path="@mystage/test_udtf_file.py",
    handler_name="GeneratorUDTF",
    output_schema=StructType([StructField("number", IntegerType())]),
    input_types=[IntegerType()]
  )

-- Example 16362
session.table_function(generator_udtf(lit(3))).collect()

-- Example 16363
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 16364
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
  df_table = session.table("sample_product_data")

-- Example 16365
# Add a zip file that you uploaded to a stage.
session.add_import("@my_stage/<path>/my_library.zip")

-- Example 16366
# Import a Python file from your local machine.
session.add_import("/<path>/my_module.py")

# Import a Python file from your local machine and specify a relative Python import path.
session.add_import("/<path>/my_module.py", import_path="my_dir.my_module")

-- Example 16367
# Add a directory of resource files.
session.add_import("/<path>/my-resource-dir/")

# Add a resource file.
session.add_import("/<path>/my-resource.xml")

-- Example 16368
import numpy as np
import pandas as pd
import xgboost as xgb
from snowflake.snowpark.functions import udf

session.add_packages("numpy", "pandas", "xgboost==1.5.0")

@udf
def compute() -> list:
  return [np.__version__, pd.__version__, xgb.__version__]

-- Example 16369
session.add_requirements("mydir/requirements.txt")

-- Example 16370
import numpy as np
import pandas as pd
import xgboost as xgb
from snowflake.snowpark.functions import udf

@udf(packages=["numpy", "pandas", "xgboost==1.5.0"])
  def compute() -> list:
  return [np.__version__, pd.__version__, xgb.__version__]

-- Example 16371
from snowflake.snowpark.types import IntegerType
from snowflake.snowpark.functions import udf

add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()])

-- Example 16372
from snowflake.snowpark.types import IntegerType
from snowflake.snowpark.functions import udf

add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()], name="my_udf", replace=True)

-- Example 16373
@udf(name="minus_one", is_permanent=True, stage_location="@my_stage", replace=True)
def minus_one(x: int) -> int:
  return x-1

-- Example 16374
df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
df.select(add_one("a"), minus_one("b")).collect()

-- Example 16375
[Row(MY_UDF("A")=2, MINUS_ONE("B")=1), Row(MY_UDF("A")=4, MINUS_ONE("B")=3)]

-- Example 16376
session.sql("select minus_one(1)").collect()

-- Example 16377
[Row(MINUS_ONE(1)=0)]

-- Example 16378
def mod5(x: int) -> int:
  return x % 5

-- Example 16379
# mod5() in that file has type hints
mod5_udf = session.udf.register_from_file(
  file_path="tests/resources/test_udf_dir/test_udf_file.py",
  func_name="mod5",
)
session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()

-- Example 16380
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 16381
from snowflake.snowpark.types import IntegerType
# suppose you have uploaded test_udf_file.py to stage location @mystage.
mod5_udf = session.udf.register_from_file(
  file_path="@mystage/test_udf_file.py",
  func_name="mod5",
  return_type=IntegerType(),
  input_types=[IntegerType()],
)
session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()

-- Example 16382
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 16383
# Import a file from your local machine as a dependency.
session.add_import("/<path>/my_file.txt")

# Or import a file that you uploaded to a stage as a dependency.
session.add_import("@my_stage/<path>/my_file.txt")

-- Example 16384
import sys
import os
import cachetools
from snowflake.snowpark.types import StringType
@cachetools.cached(cache={})
def read_file(filename):
   import_dir = sys._xoptions.get("snowflake_import_directory")
      if import_dir:
         with open(os.path.join(import_dir, filename), "r") as f:
            return f.read()

   # create a temporary text file for test
temp_file_name = "/tmp/temp.txt"
with open(temp_file_name, "w") as t:
   _ = t.write("snowpark")
session.add_import(temp_file_name)
session.add_packages("cachetools")

def add_suffix(s):
   return f"{read_file(os.path.basename(temp_file_name))}-{s}"

concat_file_content_with_str_udf = session.udf.register(
      add_suffix,
      return_type=StringType(),
      input_types=[StringType()]
   )

df = session.create_dataframe(["snowflake", "python"], schema=["a"])
df.select(concat_file_content_with_str_udf("a")).to_df("col1").collect()

-- Example 16385
[Row(COL1='snowpark-snowflake'), Row(COL1='snowpark-python')]

-- Example 16386
os.remove(temp_file_name)
session.clear_imports()

-- Example 16387
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import udf
from snowflake.snowpark.files import SnowflakeFile
from snowflake.snowpark.types import StringType, IntegerType

@udf(name="get_file_length", replace=True, input_types=[StringType()], return_type=IntegerType(), packages=['snowflake-snowpark-python'])
def get_file_length(file_path):
  with SnowflakeFile.open(file_path) as f:
    s = f.read()
  return len(s);

-- Example 16388
session.sql("select get_file_length(build_scoped_file_url(@my_stage, 'example-file.txt'));")

-- Example 16389
CREATE OR REPLACE FUNCTION write_file()
RETURNS STRING
LANGUAGE PYTHON
VOLATILE
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'write_file'
AS
$$
from snowflake.snowpark.files import SnowflakeFile

def write_file():
  file = SnowflakeFile.open_new_result("w") # Open a new result file
  file.write("Hello world")                 # Write data
  return file               # File must be returned
$$;

-- Example 16390
CREATE OR REPLACE FUNCTION convert_to_foo(filename string)
RETURNS STRING
LANGUAGE PYTHON
VOLATILE
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'convert_to_foo'
AS
$$
from snowflake.snowpark.files import SnowflakeFile

def convert_to_foo(filename):
  input_file = SnowflakeFile.open(filename, "r")
  converted_file = SnowflakeFile.open_new_result("w")

  # Foo-type is just adding foo at the end of every line
  for line in input_file.readlines():
    converted_file.write(line[:-1] + 'foo' + '\n')
  return converted_file
$$;

-- Example 16391
COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, 'in.txt')), 'out.foo.txt');

-- Example 16392
CREATE TABLE files_to_convert(file string);
-- Populate files_to_convert with input files:
INSERT INTO files_to_convert VALUES ('file1.txt');
INSERT INTO files_to_convert VALUES ('file2.txt');

COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, file)),
      REPLACE(file, '.txt', '.foo.txt') FROM files_to_convert);

-- Example 16393
COPY FILES INTO @output_stage FROM
  (SELECT convert_to_foo(BUILD_SCOPED_FILE_URL(@input_stage, RELATIVE_PATH)),
      REPLACE(RELATIVE_PATH, 'format1', 'format2') FROM DIRECTORY(@input_stage));

