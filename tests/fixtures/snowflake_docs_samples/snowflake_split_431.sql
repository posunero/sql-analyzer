-- Example 28851
public void addDependency​(String path)

-- Example 28852
session.addDependency("@my_stage/http-commons.jar")
 session.addDependency("/home/username/lib/language-detector.jar")
 session.addDependency("./resource-dir/")
 session.addDependency("./resource.xml")

-- Example 28853
public Set<URI> getDependencies()

-- Example 28854
public void cancelAll()

-- Example 28855
public Connection jdbcConnection()

-- Example 28856
public void setQueryTag​(String queryTag)

-- Example 28857
public void unsetQueryTag()

-- Example 28858
public void updateQueryTag​(String queryTag)
                    throws com.snowflake.snowpark.SnowparkClientException

-- Example 28859
session.setQueryTag("{\"key1\":\"value1\"}");
 session.updateQueryTag("{\"key2\":\"value2\"}");
 System.out.println(session.getQueryTag().get());
 {"key1":"value1","key2":"value2"}

-- Example 28860
session.sql("ALTER SESSION SET QUERY_TAG = '{\"key1\":\"value1\"}'").collect();
 session.updateQueryTag("{\"key2\":\"value2\"}");
 System.out.println(session.getQueryTag().get());
 {"key1":"value1","key2":"value2"}

-- Example 28861
session.setQueryTag("");
 session.updateQueryTag("{\"key1\":\"value1\"}");
 System.out.println(session.getQueryTag().get());
 {"key1":"value1"}

-- Example 28862
public DataFrame generator​(long rowCount,
                           Column... columns)

-- Example 28863
import com.snowflake.snowpark_java.Functions;
 DataFrame df = session.generator(10, Functions.seq4(),
   Functions.uniform(Functions.lit(1), Functions.lit(4), Functions.random()));

-- Example 28864
public Optional<String> getDefaultDatabase()

-- Example 28865
public Optional<String> getDefaultSchema()

-- Example 28866
public Optional<String> getCurrentDatabase()

-- Example 28867
public Optional<String> getCurrentSchema()

-- Example 28868
public String getFullyQualifiedCurrentSchema()

-- Example 28869
public Optional<String> getQueryTag()

-- Example 28870
public String getSessionStage()

-- Example 28871
public DataFrame flatten​(Column input)

-- Example 28872
import com.snowflake.snowpark_java.Functions;
 DataFrame df = session.flatten(Functions.parse_json(Functions.lit("{\"a\":[1,2]}")));

-- Example 28873
public DataFrame flatten​(Column input,
                         String path,
                         boolean outer,
                         boolean recursive,
                         String mode)

-- Example 28874
import com.snowflake.snowpark_java.Functions;
 DataFrame df = session.flatten(Functions.parse_json(Functions.lit("{\"a\":[1,2]}")),
   "a", false. false, "BOTH");

-- Example 28875
public void close()

-- Example 28876
public String getSessionInfo()

-- Example 28877
public DataFrameReader read()

-- Example 28878
public FileOperation file()

-- Example 28879
public DataFrame tableFunction​(TableFunction func,
                               Column... args)

-- Example 28880
session.tableFunction(TableFunctions.split_to_table(),
   Functions.lit("split by space"), Functions.lit(" "));

-- Example 28881
public DataFrame tableFunction​(TableFunction func,
                               Map<String,​Column> args)

-- Example 28882
Map<String, Column> args = new HashMap<>();
 args.put("input", Functions.parse_json(Functions.lit("[1,2]")));
 session.tableFunction(TableFunctions.flatten(), args);

-- Example 28883
public DataFrame tableFunction​(Column func)

-- Example 28884
session.tableFunction(TableFunctions.flatten(
   Functions.parse_json(df.col("col")),
   "path", true, true, "both"
 ));

-- Example 28885
@PublicPreview
public SProcRegistration sproc()

-- Example 28886
@PublicPreview
public DataFrame storedProcedure​(String spName,
                                 Object... args)

-- Example 28887
session.storedProcedure("sp_name", "arg1", "arg2").show()

-- Example 28888
@PublicPreview
public DataFrame storedProcedure​(StoredProcedure sp,
                                 Object... args)

-- Example 28889
public AsyncJob createAsyncJob​(String queryID)

-- Example 28890
AsyncJob job = session.createAsyncJob(id);
 Row[] result = job.getRows();

-- Example 28891
CREATE OR REPLACE FUNCTION addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'addone_py'
AS $$
def addone_py(i):
 return i+1
$$;

-- Example 28892
SELECT addone(3);

-- Example 28893
CREATE STAGE mystage;

-- Example 28894
PUT file:///Users/MyUserName/MyCompiledJavaCode.jar
  @mystage
  AUTO_COMPRESS = FALSE
  OVERWRITE = TRUE
  ;

-- Example 28895
CREATE OR REPLACE PROCEDURE MYPROC(value INT, fromTable STRING, toTable STRING, count INT)
  RETURNS INT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('@mystage/MyCompiledJavaCode.jar')
  HANDLER = 'MyJavaClass.run';

-- Example 28896
CREATE OR REPLACE PROCEDURE sp_concatenate_strings(
    first_arg VARCHAR,
    second_arg VARCHAR,
    third_arg VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
  BEGIN
    RETURN first_arg || second_arg || third_arg;
  END;
  $$;

-- Example 28897
CALL sp_concatenate_strings(
  first_arg => 'one',
  second_arg => 'two',
  third_arg => 'three');

-- Example 28898
+------------------------+
| SP_CONCATENATE_STRINGS |
|------------------------|
| onetwothree            |
+------------------------+

-- Example 28899
CALL sp_concatenate_strings(
  third_arg => 'three',
  first_arg => 'one',
  second_arg => 'two');

-- Example 28900
+------------------------+
| SP_CONCATENATE_STRINGS |
|------------------------|
| onetwothree            |
+------------------------+

-- Example 28901
CALL sp_concatenate_strings(
  'one',
  'two',
  'three');

-- Example 28902
+------------------------+
| SP_CONCATENATE_STRINGS |
|------------------------|
| onetwothree            |
+------------------------+

-- Example 28903
CREATE OR REPLACE PROCEDURE build_string_proc(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
    BEGIN
      RETURN prefix || word || suffix;
    END;
  $$
  ;

-- Example 28904
CALL build_string_proc('hello');

-- Example 28905
+-------------------+
| BUILD_STRING_PROC |
|-------------------|
| pre-hello-post    |
+-------------------+

-- Example 28906
CALL build_string_proc('hello', 'before-');

-- Example 28907
+-------------------+
| BUILD_STRING_PROC |
|-------------------|
| before-hello-post |
+-------------------+

-- Example 28908
CALL build_string_proc(word => 'hello', suffix => '-after');

-- Example 28909
+-------------------+
| BUILD_STRING_PROC |
|-------------------|
| pre-hello-after   |
+-------------------+

-- Example 28910
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas
from _snowflake import vectorized

@vectorized(input=pandas.DataFrame)
def add_one_to_inputs(df):
 return df[0] + df[1] + 1
$$;

-- Example 28911
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas

def add_one_to_inputs(df):
 return df[0] + df[1] + 1

add_one_to_inputs._sf_vectorized_input = pandas.DataFrame
$$;

-- Example 28912
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas
from _snowflake import vectorized

@vectorized(input=pandas.DataFrame, max_batch_size=100)
def add_one_to_inputs(df):
 return df[0] + df[1] + 1
$$;

-- Example 28913
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas

def add_one_to_inputs(df):
 return df[0] + df[1] + 1

add_one_to_inputs._sf_vectorized_input = pandas.DataFrame
add_one_to_inputs._sf_max_batch_size = 100
$$;

-- Example 28914
CREATE OR REPLACE FUNCTION add_inputs(x INT, y FLOAT)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_inputs'
AS $$
import pandas
from _snowflake import vectorized

@vectorized(input=pandas.DataFrame)
def add_inputs(df):
  return df[0] + df[1]
$$;

-- Example 28915
SELECT add_inputs(x, y)
FROM (
  SELECT 1 AS x, 3.14::FLOAT as y UNION ALL
  SELECT 2, 1.59 UNION ALL
  SELECT 3, -0.5
);

-- Example 28916
+------------------+
| ADD_INPUTS(X, Y) |
|------------------|
|             4.14 |
|             3.59 |
|             2.5  |
+------------------+

-- Example 28917
>>> import pandas
>>> df = pandas.DataFrame({0: pandas.array([1, 2, 3]), 1: pandas.array([3.14, 1.59, -0.5])})
>>> df
   0     1
0  1  3.14
1  2  1.59
2  3 -0.50

