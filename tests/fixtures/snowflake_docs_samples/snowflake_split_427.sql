-- Example 28584
>>> views = view_collection.iter(like="your-view-name")

-- Example 28585
>>> views = view_collection.iter(like="your-view-name-%")

-- Example 28586
>>> for view in views:
...     print(view.name, view.query)

-- Example 28587
>>> warehouses = root.warehouses
>>> new_wh = Warehouse(
...     name="my_wh",
...     warehouse_size="XSMALL")
>>> warehouses.create(new_wh)

-- Example 28588
>>> warehouse_parameters = Warehouse(
...     name="your-warehouse-name",
...     warehouse_size="SMALL",
...     auto_suspend=500,
...)

-- Example 28589
>>> # Use the warehouse collection created before to create a reference to a warehouse resource
>>> # in Snowflake.
>>> warehouse_reference = warehouse_collection.create(warehouse_parameters)

-- Example 28590
>>> warehouses = warehouse_collection.iter()

-- Example 28591
>>> warehouses = warehouse_collection.iter(like="your-warehouse-name")

-- Example 28592
>>> warehouses = warehouse_collection.iter(like="your-warehouse-name-%")

-- Example 28593
>>> for warehouse in warehouses:
>>>     print(warehouse.name, warehouse.warehouse_size)

-- Example 28594
>>> warehouse = warehouse_reference.abort_all_queries()

-- Example 28595
>>> warehouse_parameters = Warehouse(
...     name="your-warehouse-name",
...     warehouse_size="SMALL",
...     auto_suspend=500,
...)

-- Example 28596
>>> warehouse_reference.drop()

-- Example 28597
>>> warehouse_reference.drop(if_exists=True)

-- Example 28598
>>> warehouse = warehouse_reference.fetch()

-- Example 28599
>>> warehouse_reference.resume()

-- Example 28600
>>> warehouse_reference.resume(if_exists=True)

-- Example 28601
>>> warehouse_reference.suspend()

-- Example 28602
>>> warehouse_reference.suspend(if_exists=True)

-- Example 28603
>>> warehouse_reference.use_warehouse()

-- Example 28604
definition_version: 2
entities:
  codegen_nativeapp_pkg:
    type: application package
    manifest: root_files/_manifest.yml
    artifacts:
      - src: root_files/README.md
        dest: README.md
      - src: root_files/_manifest.yml
        dest: manifest.yml
      - src: root_files/setup_scripts/*
        dest: setup_scripts/
      - src: python/user_gen/echo.py
        dest: user_gen/echo.py
      - src: python/cli_gen/*
        dest: cli_gen/
        processors:
          - snowpark
  codegen_nativeapp_pkg:
    type: application
    from:
      target: codegen_nativeapp_pkg

-- Example 28605
snow app bundle

-- Example 28606
# Example python file "echo.py" that a developer writes

def echo_fn(data):
    return 'echo_fn: ' + data

def echo_proc(session, data):
    return 'echo_proc: ' + data

-- Example 28607
-- Sample setup_script.sql SQL file for a Snowflake Native App

CREATE APPLICATION ROLE IF NOT EXISTS app_instance_role;

CREATE OR ALTER VERSIONED SCHEMA ext_code_schema;
GRANT USAGE ON SCHEMA ext_code_schema TO APPLICATION ROLE app_instance_role;

CREATE OR REPLACE PROCEDURE ext_code_schema.py_echo_proc(DATA string)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES=('snowflake-snowpark-python')
  HANDLER='echo.echo_proc'
  IMPORTS=('/echo.py');

    GRANT USAGE ON PROCEDURE ext_code_schema.py_echo_proc(string)
      TO APPLICATION ROLE app_instance_role;

-- Wraps a function from a python file
CREATE OR REPLACE FUNCTION ext_code_schema.py_echo_fn(string)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES=('snowflake-snowpark-python')
HANDLER='echo.echo_fn'
IMPORTS=('/echo.py');

GRANT USAGE ON FUNCTION ext_code_schema.py_echo_fn(DATA string)
  TO APPLICATION ROLE app_instance_role;

-- Example 28608
# some python file echo.py
@udf(name="echo_fn")
def echo_fn(data) -> str:
  return 'echo_fn: ' + str

-- Example 28609
-- Sample setup_script.sql SQL file for a Snowflake Native App

-- User-written code
CREATE OR REPLACE APPLICATION ROLE app_instance_role;

CREATE OR ALTER VERSIONED SCHEMA ext_code_schema;
GRANT USAGE ON SCHEMA ext_code_schema TO APPLICATION ROLE app_instance_role;

-- Snowflake CLI generated code
CREATE OR REPLACE FUNCTION ext_code_schema.py_echo_fn(DATA string)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES=('snowflake-snowpark-python')
  HANDLER='echo.echo_fn'
  IMPORTS=('/echo.py');

  GRANT USAGE ON FUNCTION ext_code_schema.py_echo_fn(string)
    TO APPLICATION ROLE app_instance_role;

-- Example 28610
# output/deploy/dest_dir1/dest_dir2/echo.py
#: @sproc(
#:    return_type=IntegerType(),
#:    input_types=[IntegerType(), IntegerType()],
#:    packages=["snowflake-snowpark-python==1.15.0"],
#:    native_app_params={
#:        "schema": "ext_code_schema",
#:        "application_roles": ["app_instance_role"],
#:    },
#: )
def add_sp(session_, x, y):
    return x + y

-- Example 28611
snow app bundle
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 28612
entities:
  pkg:
    type: application package
    ...
    artifacts:
      - src: dir1/dir2/*
        dest: dest_dir1/dest_dir2/
      - src: dir8/dir9/file.txt
        dest: dest_dir8/dest_file.txt
  ...

-- Example 28613
-- deploy_root
      -- dest_dir1
            -- dest_dir2
                  -- dir3
                      -- ... <entire directory tree of dir3>
                  -- dir4
                      -- ... <entire directory tree of dir4>
                  -- file3.txt
                  -- file4.txt
      -- dest_dir8
            -- dest_file.txt

-- Example 28614
cd my_app_project
snow app bundle

-- Example 28615
snow init my_app_bundle_project --template app_basic
cd "my_app_bundle_project"
snow app bundle
ls my_app_bundle_project/output/deploy

-- Example 28616
>>> import numpy
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> a = 1
>>> def f():
...     return 2
>>>
>>> from snowflake.snowpark.functions import udf
>>> session.add_import("tests/resources/test_udf_dir/test_udf_file.py", import_path="resources.test_udf_dir.test_udf_file")
>>> session.add_packages("numpy")
>>> @udf
... def g(x: int) -> int:
...     return mod5(numpy.square(x)) + a + f()
>>> df = session.create_dataframe([4], schema=["a"])
>>> df.select(g("a")).to_df("col1").show()
----------
|"COL1"  |
----------
|4       |
----------

-- Example 28617
>>> from snowflake.snowpark.types import IntegerType
>>> from snowflake.snowpark.functions import udf
>>> add_one_udf = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()])
>>> session.range(1, 8, 2).select(add_one_udf("id")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=4), Row(COL1=6), Row(COL1=8)]

-- Example 28618
>>> from snowflake.snowpark.functions import udf
>>> @udf
... def add_udf(x: int, y: int) -> int:
...        return x + y
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["x", "y"])
>>> df.select(add_udf("x", "y")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]

-- Example 28619
>>> from snowflake.snowpark.types import IntegerType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.udf.register(
...     lambda x, y: x * y, return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True, name="mul", replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("select mul(5, 6) as mul").collect()
[Row(MUL=30)]
>>> # skip udf creation if it already exists
>>> _ = session.udf.register(
...     lambda x, y: x * y + 1, return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True, name="mul", if_not_exists=True,
...     stage_location="@mystage",
... )
>>> session.sql("select mul(5, 6) as mul").collect()
[Row(MUL=30)]
>>> # overwrite udf definition when it already exists
>>> _ = session.udf.register(
...     lambda x, y: x * y + 1, return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True, name="mul", replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("select mul(5, 6) as mul").collect()
[Row(MUL=31)]

-- Example 28620
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> from snowflake.snowpark.functions import udf
>>> @udf(imports=[("tests/resources/test_udf_dir/test_udf_file.py", "resources.test_udf_dir.test_udf_file")])
... def mod5_and_plus1_udf(x: int) -> int:
...     return mod5(x) + 1
>>> session.range(1, 8, 2).select(mod5_and_plus1_udf("id")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=4), Row(COL1=1), Row(COL1=3)]

-- Example 28621
>>> from snowflake.snowpark.functions import udf
>>> import numpy as np
>>> import math
>>> @udf(packages=["numpy"])
... def sin_udf(x: float) -> float:
...     return np.sin(x)
>>> df = session.create_dataframe([0.0, 0.5 * math.pi], schema=["d"])
>>> df.select(sin_udf("d")).to_df("col1").collect()
[Row(COL1=0.0), Row(COL1=1.0)]

-- Example 28622
>>> # mod5() in that file has type hints
>>> mod5_udf = session.udf.register_from_file(
...     file_path="tests/resources/test_udf_dir/test_udf_file.py",
...     func_name="mod5",
... )
>>> session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 28623
>>> from snowflake.snowpark.types import IntegerType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.file.put("tests/resources/test_udf_dir/test_udf_file.py", "@mystage", auto_compress=False)
>>> mod5_udf = session.udf.register_from_file(
...     file_path="@mystage/test_udf_file.py",
...     func_name="mod5",
...     return_type=IntegerType(),
...     input_types=[IntegerType()],
... )
>>> session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 28624
>>> import sys
>>> import os
>>> import cachetools
>>> from snowflake.snowpark.types import StringType
>>> @cachetools.cached(cache={})
... def read_file(filename):
...     import_dir = sys._xoptions.get("snowflake_import_directory")
...     if import_dir:
...         with open(os.path.join(import_dir, filename), "r") as f:
...             return f.read()
>>>
>>> # create a temporary text file for test
>>> temp_file_name = "/tmp/temp.txt"
>>> with open(temp_file_name, "w") as t:
...     _ = t.write("snowpark")
>>> session.add_import(temp_file_name)
>>> session.add_packages("cachetools")
>>> concat_file_content_with_str_udf = session.udf.register(
...     lambda s: f"{read_file(os.path.basename(temp_file_name))}-{s}",
...     return_type=StringType(),
...     input_types=[StringType()]
... )
>>>
>>> df = session.create_dataframe(["snowflake", "python"], schema=["a"])
>>> df.select(concat_file_content_with_str_udf("a")).to_df("col1").collect()
[Row(COL1='snowpark-snowflake'), Row(COL1='snowpark-python')]
>>> os.remove(temp_file_name)
>>> session.clear_imports()

-- Example 28625
>>> from snowflake.snowpark.functions import udf
>>> from snowflake.snowpark.types import IntegerType, PandasSeriesType, PandasDataFrameType
>>> df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
>>> add_udf1 = udf(lambda series1, series2: series1 + series2, return_type=PandasSeriesType(IntegerType()),
...               input_types=[PandasSeriesType(IntegerType()), PandasSeriesType(IntegerType())],
...               max_batch_size=20)
>>> df.select(add_udf1("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]
>>> add_udf2 = udf(lambda df: df[0] + df[1], return_type=PandasSeriesType(IntegerType()),
...               input_types=[PandasDataFrameType([IntegerType(), IntegerType()])],
...               max_batch_size=20)
>>> df.select(add_udf2("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]

-- Example 28626
>>> from snowflake.snowpark.functions import udf
>>> from snowflake.snowpark.types import PandasSeries, PandasDataFrame
>>> @udf
... def apply_mod5_udf(series: PandasSeries[int]) -> PandasSeries[int]:
...     return series.apply(lambda x: x % 5)
>>> session.range(1, 8, 2).select(apply_mod5_udf("id")).to_df("col1").collect()
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]
>>> @udf
... def mul_udf(df: PandasDataFrame[int, int]) -> PandasSeries[int]:
...     return df[0] * df[1]
>>> df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
>>> df.select(mul_udf("a", "b")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=12)]

-- Example 28627
>>> # `pandas_udf` is an alias of `udf`, but it can only be used to create a vectorized UDF
>>> from snowflake.snowpark.functions import pandas_udf
>>> from snowflake.snowpark.types import IntegerType
>>> import pandas as pd
>>> df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
>>> def add1(series1: pd.Series, series2: pd.Series) -> pd.Series:
...     return series1 + series2
>>> add_udf1 = pandas_udf(add1, return_type=IntegerType(),
...                       input_types=[IntegerType(), IntegerType()])
>>> df.select(add_udf1("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]
>>> def add2(df: pd.DataFrame) -> pd.Series:
...     return df[0] + df[1]
>>> add_udf2 = pandas_udf(add2, return_type=IntegerType(),
...                       input_types=[IntegerType(), IntegerType()])
>>> df.select(add_udf2("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]

-- Example 28628
>>> from snowflake.snowpark.types import IntegerType
>>> @sproc(return_type=IntegerType(), input_types=[IntegerType(), IntegerType()], packages=["snowflake-snowpark-python"])
... def add_sp(session_, x, y):
...     return session_.sql(f"SELECT {x} + {y}").collect()[0][0]
...
>>> add_sp(1, 1)
2

-- Example 28629
CREATE OR REPLACE FUNCTION addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'addone_py'
AS $$
def addone_py(i):
 return i+1
$$;

-- Example 28630
SELECT addone(10);

-- Example 28631
+------------+
| ADDONE(10) |
|------------|
|         11 |
+------------+

-- Example 28632
def snore(n):   # return a series of n snores
  result = []
  for a in range(n):
    result.append("Zzz")
  return result

-- Example 28633
put
file:///Users/Me/sleepy.py
@~/
auto_compress = false
overwrite = true
;

-- Example 28634
CREATE OR REPLACE FUNCTION dream(i INT)
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'sleepy.snore'
  IMPORTS = ('@~/sleepy.py')

-- Example 28635
SELECT dream(3);

-- Example 28636
+----------+
| DREAM(3) |
|----------|
| [        |
|   "Zzz", |
|   "Zzz", |
|   "Zzz"  |
| ]        |
+----------+

-- Example 28637
CREATE OR REPLACE FUNCTION multiple_import_files(s STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  IMPORTS = ('@python_udf_dep/bar/python_imports_a.zip', '@python_udf_dep/foo/python_imports_b.zip')
  HANDLER = 'compute'
AS $$
def compute(s):
  return s
$$;

-- Example 28638
GRANT USAGE ON FUNCTION my_python_udf(number, number) TO my_role;

-- Example 28639
import com.snowflake.snowpark_java.*;

public class MyClass
{
  public String myMethod(Session session, String fromTable, String toTable, int count)
  {
    session.table(fromTable).limit(count).write().saveAsTable(toTable);
    return "Success";
  }
}

-- Example 28640
CREATE OR REPLACE PROCEDURE file_reader_java_proc_snowflakefile(input VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = 11
HANDLER = 'FileReader.execute'
PACKAGES=('com.snowflake:snowpark:latest')
AS $$
import java.io.InputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import com.snowflake.snowpark_java.types.SnowflakeFile;
import com.snowflake.snowpark_java.Session;

class FileReader {
  public String execute(Session session, String fileName) throws IOException {
    InputStream input = SnowflakeFile.newInstance(fileName).getInputStream();
    return new String(input.readAllBytes(), StandardCharsets.UTF_8);
  }
}
$$;

-- Example 28641
CALL file_reader_java_proc_snowflakefile(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 28642
String filename = "@my_stage/filename.txt";
String sfFile = SnowflakeFile.newInstance(filename, false);

-- Example 28643
CREATE OR REPLACE PROCEDURE file_reader_java_proc_input(input VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = 11
HANDLER = 'FileReader.execute'
PACKAGES=('com.snowflake:snowpark:latest')
AS $$
import java.io.InputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import com.snowflake.snowpark.Session;

class FileReader {
  public String execute(Session session, InputStream stream) throws IOException {
    String contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
    return contents;
  }
}
$$;

-- Example 28644
CALL file_reader_java_proc_input(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 28645
CREATE OR REPLACE PROCEDURE getResultJDBC()
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = 11
PACKAGES = ('com.snowflake:snowpark:latest')
HANDLER = 'TestJavaSP.asyncBasic'
AS
$$
import java.sql.*;
import net.snowflake.client.jdbc.*;

class TestJavaSP {
  public String asyncBasic(com.snowflake.snowpark.Session session) throws Exception {
    Connection connection = session.jdbcConnection();
    SnowflakeStatement stmt = (SnowflakeStatement)connection.createStatement();
    ResultSet resultSet = stmt.executeAsyncQuery("CALL SYSTEM$WAIT(10)");
    resultSet.next();
    return resultSet.getString(1);
  }
}
$$;

-- Example 28646
conda create --name py39_env --override-channels -c https://repo.anaconda.com/pkgs/snowflake python=3.9 numpy pandas pyarrow

-- Example 28647
CONDA_SUBDIR=osx-64 conda create -n snowpark python=3.9 numpy pandas pyarrow --override-channels -c https://repo.anaconda.com/pkgs/snowflake
conda activate snowpark
conda config --env --set subdir osx-64

-- Example 28648
conda install snowflake-snowpark-python

-- Example 28649
pip install snowflake-snowpark-python

-- Example 28650
conda install snowflake-snowpark-python pandas pyarrow

