-- Example 21619
int str
0    1   4
1    2   5
2    3   6

-- Example 21620
df_float = df.astype(float)
df_float

-- Example 21621
int  str
0  1.0  4.0
1  2.0  5.0
2  3.0  6.0

-- Example 21622
df_float.dtypes

-- Example 21623
int    float64
str    float64
dtype: object

-- Example 21624
pd.to_numeric(df.str)

-- Example 21625
0    4.0
1    5.0
2    6.0
Name: str, dtype: float64

-- Example 21626
df = pd.DataFrame({'year': [2015, 2016],
                'month': [2, 3],
                'day': [4, 5]})
pd.to_datetime(df)

-- Example 21627
0   2015-02-04
1   2016-03-05
dtype: datetime64[ns]

-- Example 21628
df_1 = pd.DataFrame([[1,2,3],[4,5,6]])
df_2 = pd.DataFrame([[6,7,8]])
df_1.add(df_2)

-- Example 21629
0    1     2
0  7.0  9.0  11.0
1  NaN  NaN   NaN

-- Example 21630
s1 = pd.Series([1, 2, 3])
s2 = pd.Series([2, 2, 2])
s1 + s2

-- Example 21631
0    3
1    4
2    5
dtype: int64

-- Example 21632
df = pd.DataFrame({"A": [1,2,3], "B": [4,5,6]})
df["A+B"] = df["A"] + df["B"]
df

-- Example 21633
A  B  A+B
0  1  4    5
1  2  5    7
2  3  6    9

-- Example 21634
df = pd.DataFrame([[1, 2, 3],
                [4, 5, 6],
                [7, 8, 9],
                [np.nan, np.nan, np.nan]],
                columns=['A', 'B', 'C'])
df.agg(['sum', 'min'])

-- Example 21635
A     B     C
sum  12.0  15.0  18.0
min   1.0   2.0   3.0

-- Example 21636
df.median()

-- Example 21637
A    4.0
B    5.0
C    6.0
dtype: float64

-- Example 21638
df1 = pd.DataFrame({'lkey': ['foo', 'bar', 'baz', 'foo'],
                    'value': [1, 2, 3, 5]})
df1

-- Example 21639
lkey  value
0  foo      1
1  bar      2
2  baz      3
3  foo      5

-- Example 21640
df2 = pd.DataFrame({'rkey': ['foo', 'bar', 'baz', 'foo'],
                    'value': [5, 6, 7, 8]})
df2

-- Example 21641
rkey  value
0  foo      5
1  bar      6
2  baz      7
3  foo      8

-- Example 21642
df1.merge(df2, left_on='lkey', right_on='rkey')

-- Example 21643
lkey  value_x rkey  value_y
0  foo        1  foo        5
1  foo        1  foo        8
2  bar        2  bar        6
3  baz        3  baz        7
4  foo        5  foo        5
5  foo        5  foo        8

-- Example 21644
df = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3', 'K4', 'K5'],
                'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})
df

-- Example 21645
key   A
0  K0  A0
1  K1  A1
2  K2  A2
3  K3  A3
4  K4  A4
5  K5  A5

-- Example 21646
other = pd.DataFrame({'key': ['K0', 'K1', 'K2'],
                    'B': ['B0', 'B1', 'B2']})
df.join(other, lsuffix='_caller', rsuffix='_other')

-- Example 21647
key_caller   A key_other     B
0         K0  A0        K0    B0
1         K1  A1        K1    B1
2         K2  A2        K2    B2
3         K3  A3      None  None
4         K4  A4      None  None
5         K5  A5      None  None

-- Example 21648
df = pd.DataFrame({'Animal': ['Falcon', 'Falcon','Parrot', 'Parrot'],
               'Max Speed': [380., 370., 24., 26.]})

df

-- Example 21649
Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0

-- Example 21650
df.groupby(['Animal']).mean()

-- Example 21651
Max Speed
Animal
Falcon      375.0
Parrot       25.0

-- Example 21652
df = pd.DataFrame({"A": ["foo", "foo", "foo", "foo", "foo",
                        "bar", "bar", "bar", "bar"],
                "B": ["one", "one", "one", "two", "two",
                        "one", "one", "two", "two"],
                "C": ["small", "large", "large", "small",
                        "small", "large", "small", "small",
                        "large"],
                "D": [1, 2, 2, 3, 3, 4, 5, 6, 7],
                "E": [2, 4, 5, 5, 6, 6, 8, 9, 9]})
df

-- Example 21653
A    B      C  D  E
0  foo  one  small  1  2
1  foo  one  large  2  4
2  foo  one  large  2  5
3  foo  two  small  3  5
4  foo  two  small  3  6
5  bar  one  large  4  6
6  bar  one  small  5  8
7  bar  two  small  6  9
8  bar  two  large  7  9

-- Example 21654
pd.pivot_table(df, values='D', index=['A', 'B'],
                   columns=['C'], aggfunc="sum")

-- Example 21655
C    large  small
A   B
bar one    4.0      5
    two    7.0      6
foo one    4.0      1
    two    NaN      6

-- Example 21656
df = pd.DataFrame({'foo': ['one', 'one', 'one', 'two', 'two', 'two'],
                'bar': ['A', 'B', 'C', 'A', 'B', 'C'],
                'baz': [1, 2, 3, 4, 5, 6],
                'zoo': ['x', 'y', 'z', 'q', 'w', 't']})
df

-- Example 21657
foo bar  baz zoo
0  one   A    1   x
1  one   B    2   y
2  one   C    3   z
3  two   A    4   q
4  two   B    5   w
5  two   C    6   t

-- Example 21658
CREATE OR REPLACE WAREHOUSE snowpark_opt_wh WITH
  WAREHOUSE_SIZE = 'MEDIUM'
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
  MAX_CONCURRENCY_LEVEL = 1;

CREATE OR REPLACE PROCEDURE train()
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('snowflake-snowpark-python', 'scikit-learn', 'joblib')
  HANDLER = 'main'
AS $$
import os
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import PolynomialFeatures
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split, GridSearchCV
from joblib import dump

def main(session):
 # Load features
 df = session.table('MARKETING_BUDGETS_FEATURES').to_pandas()
 X = df.drop('REVENUE', axis = 1)
 y = df['REVENUE']

 # Split dataset into training and test
 X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state = 42)

 # Preprocess numeric columns
 numeric_features = ['SEARCH_ENGINE','SOCIAL_MEDIA','VIDEO','EMAIL']
 numeric_transformer = Pipeline(steps=[('poly',PolynomialFeatures(degree = 2)),('scaler', StandardScaler())])
 preprocessor = ColumnTransformer(transformers=[('num', numeric_transformer, numeric_features)])

 # Create pipeline and train
 pipeline = Pipeline(steps=[('preprocessor', preprocessor),('classifier', LinearRegression(n_jobs=-1))])
 model = GridSearchCV(pipeline, param_grid={}, n_jobs=-1, cv=10)
 model.fit(X_train, y_train)

 # Upload trained model to a stage
 model_file = os.path.join('/tmp', 'model.joblib')
 dump(model, model_file)
 session.file.put(model_file, "@ml_models",overwrite=True)

 # Return model R2 score on train and test data
 return {"R2 score on Train": model.score(X_train, y_train),"R2 score on Test": model.score(X_test, y_test)}
$$;

-- Example 21659
CALL train();

-- Example 21660
>>> import logging
>>> import sys

>>> logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

-- Example 21661
>>> df = session.create_dataframe([[1, 'a', True, '2022-03-16'], [3, 'b', False, '2023-04-17']], schema=["a", "b", "c", "d"])
>>> res1 = df.filter(col("a") == 1).collect()
>>> res2 = df.filter(lit(1) == col("a")).collect()
>>> res3 = df.filter(sql_expr("a = 1")).collect()
>>> assert res1 == res2 == res3
>>> res1
[Row(A=1, B='a', C=True, D='2022-03-16')]

-- Example 21662
>>> df.filter("a = 1").collect()  # use the SQL expression directly in filter
[Row(A=1, B='a', C=True, D='2022-03-16')]
>>> df.select("a").collect()
[Row(A=1), Row(A=3)]

-- Example 21663
>>> # Use columns and literals in expressions.
>>> df.select(((col("a") + 1).cast("string")).alias("add_one")).show()
-------------
|"ADD_ONE"  |
-------------
|2          |
|4          |
-------------

-- Example 21664
>>> # This example calls the function that corresponds to the TO_DATE() SQL function.
>>> df.select(dateadd('day', lit(1), to_date(col("d")))).show()
---------------------------------------
|"DATEADD('DAY', 1, TO_DATE(""D""))"  |
---------------------------------------
|2022-03-17                           |
|2023-04-18                           |
---------------------------------------

-- Example 21665
>>> my_radians = function("radians")  # "radians" is the SQL function name.
>>> df.select(my_radians(col("a")).alias("my_radians")).show()
------------------------
|"MY_RADIANS"          |
------------------------
|0.017453292519943295  |
|0.05235987755982988   |
------------------------

-- Example 21666
>>> df.select(call_function("radians", col("a")).as_("call_function_radians")).show()
---------------------------
|"CALL_FUNCTION_RADIANS"  |
---------------------------
|0.017453292519943295     |
|0.05235987755982988      |
---------------------------

-- Example 21667
>>> df.select(avg("a")).show()
----------------
|"AVG(""A"")"  |
----------------
|2.000000      |
----------------

>>> df.select(avg(col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.000000      |
----------------

-- Example 21668
>>> import datetime
>>> from snowflake.snowpark.window import Window
>>> df.select(col("d"), lead("d", 1, datetime.date(2024, 5, 18), False).over(Window.order_by("d")).alias("lead_day")).show()
---------------------------
|"D"         |"LEAD_DAY"  |
---------------------------
|2022-03-16  |2023-04-17  |
|2023-04-17  |2024-05-18  |
---------------------------

-- Example 21669
>>> df.select(when(df["a"] > 2, "Greater than 2").else_("Less than 2").alias("compare_with_2")).show()
--------------------
|"COMPARE_WITH_2"  |
--------------------
|Less than 2       |
|Greater than 2    |
--------------------

-- Example 21670
>>> df.with_column("e", lit("1.2")).select(to_decimal("e", 5, 2)).show()
-----------------------------
|"TO_DECIMAL(""E"", 5, 2)"  |
-----------------------------
|1.20                       |
|1.20                       |
-----------------------------

-- Example 21671
>>> df.select(when("a > 2", "Greater than 2").else_("Less than 2").alias("compare_with_2")).show()
--------------------
|"COMPARE_WITH_2"  |
--------------------
|Less than 2       |
|Greater than 2    |
--------------------

-- Example 21672
>>> # Create a temp stage to run the example code.
>>> _ = session.sql("CREATE or REPLACE temp STAGE mystage").collect()

-- Example 21673
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, FloatType
>>> _ = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV file.
>>> user_schema = StructType([StructField("a", IntegerType()), StructField("b", StringType()), StructField("c", FloatType())])
>>> # Create a DataFrame that is configured to load data from the CSV file.
>>> df = session.read.options({"field_delimiter": ",", "skip_header": 1}).schema(user_schema).csv("@mystage/testCSV.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(A=2, B='two', C=2.2)]

-- Example 21674
>>> _ = session.file.put("tests/resources/testJson.json", "@mystage", auto_compress=True)
>>> # Create a DataFrame that is configured to load data from the gzipped JSON file.
>>> json_df = session.read.option("compression", "gzip").json("@mystage/testJson.json.gz")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> json_df.show()
-----------------------
|"$1"                 |
-----------------------
|{                    |
|  "color": "Red",    |
|  "fruit": "Apple",  |
|  "size": "Large"    |
|}                    |
-----------------------

-- Example 21675
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/*.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV files.
>>> user_schema = StructType([StructField("a", IntegerType()), StructField("b", StringType()), StructField("c", FloatType())])
>>> # Create a DataFrame that is configured to load data from the CSV files in the stage.
>>> csv_df = session.read.option("pattern", ".*V[.]csv").schema(user_schema).csv("@mystage").sort(col("a"))
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> csv_df.collect()
[Row(A=1, B='one', C=1.2), Row(A=2, B='two', C=2.2), Row(A=3, B='three', C=3.3), Row(A=4, B='four', C=4.4)]

-- Example 21676
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.parquet", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.parquet("@mystage/test.parquet").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

-- Example 21677
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.orc", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.orc("@mystage/test.orc").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

-- Example 21678
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.avro", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.avro("@mystage/test.avro").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

-- Example 21679
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.parquet", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.option("infer_schema", False).parquet("@mystage/test.parquet").where(col('$1')["num"] == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
-------------------
|"$1"             |
-------------------
|{                |
|  "num": 2,      |
|  "str": "str2"  |
|}                |
-------------------

-- Example 21680
>>> from snowflake.snowpark.functions import col, lit
>>> _ = session.file.put("tests/resources/testJson.json", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.json("@mystage/testJson.json").where(col("$1")["fruit"] == lit("Apple"))
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
-----------------------
|"$1"                 |
-----------------------
|{                    |
|  "color": "Red",    |
|  "fruit": "Apple",  |
|  "size": "Large"    |
|}                    |
|{                    |
|  "color": "Red",    |
|  "fruit": "Apple",  |
|  "size": "Large"    |
|}                    |
-----------------------

-- Example 21681
>>> _ = session.file.put("tests/resources/test.xml", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.xml("@mystage/test.xml")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
---------------------
|"$1"               |
---------------------
|<test>             |
|  <num>1</num>     |
|  <str>str1</str>  |
|</test>            |
|<test>             |
|  <num>2</num>     |
|  <str>str2</str>  |
|</test>            |
---------------------

-- Example 21682
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> _ = session.sql("create file format if not exists csv_format type=csv skip_header=1 null_if='none';").collect()
>>> _ = session.file.put("tests/resources/testCSVspecialFormat.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV files.
>>> schema = StructType([StructField("ID", IntegerType()),StructField("USERNAME", StringType()),StructField("FIRSTNAME", StringType()),StructField("LASTNAME", StringType())])
>>> # Create a DataFrame that is configured to load data from the CSV files in the stage.
>>> df = session.read.schema(schema).option("format_name", "csv_format").csv("@mystage/testCSVspecialFormat.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(ID=0, USERNAME='admin', FIRSTNAME=None, LASTNAME=None), Row(ID=1, USERNAME='test_user', FIRSTNAME='test', LASTNAME='user')]

-- Example 21683
>>> from snowflake.snowpark.column import METADATA_FILENAME, METADATA_FILE_ROW_NUMBER
>>> df = session.read.with_metadata(METADATA_FILENAME, METADATA_FILE_ROW_NUMBER.as_("ROW NUMBER")).schema(user_schema).csv("@mystage/testCSV.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
--------------------------------------------------------
|"METADATA$FILENAME"  |"ROW NUMBER"  |"A"  |"B"  |"C"  |
--------------------------------------------------------
|testCSV.csv          |1             |1    |one  |1.2  |
|testCSV.csv          |2             |2    |two  |2.2  |
--------------------------------------------------------

-- Example 21684
>>> # Read a csv file without a header
>>> df = session.read.option("INFER_SCHEMA", True).csv("@mystage/testCSV.csv")
>>> df.show()
----------------------
|"c1"  |"c2"  |"c3"  |
----------------------
|1     |one   |1.2   |
|2     |two   |2.2   |
----------------------

-- Example 21685
>>> # Read a csv file with header and parse the header
>>> _ = session.file.put("tests/resources/testCSVheader.csv", "@mystage", auto_compress=False)
>>> df = session.read.option("INFER_SCHEMA", True).option("PARSE_HEADER", True).csv("@mystage/testCSVheader.csv")
>>> df.show()
----------------------------
|"id"  |"name"  |"rating"  |
----------------------------
|1     |one     |1.2       |
|2     |two     |2.2       |
----------------------------

