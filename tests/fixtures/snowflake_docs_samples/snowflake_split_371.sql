-- Example 24832
>>> session.query_tag = '{"key1": "value1"}'
>>> session.update_query_tag({"key2": "value2"})
>>> print(session.query_tag)
{"key1": "value1", "key2": "value2"}

-- Example 24833
>>> session.sql("ALTER SESSION SET QUERY_TAG = '{\"key1\": \"value1\"}'").collect()
[Row(status='Statement executed successfully.')]
>>> session.update_query_tag({"key2": "value2"})
>>> print(session.query_tag)
{"key1": "value1", "key2": "value2"}

-- Example 24834
>>> session.query_tag = ""
>>> session.update_query_tag({"key1": "value1"})
>>> print(session.query_tag)
{"key1": "value1"}

-- Example 24835
>>> import pandas as pd
>>> pandas_df = pd.DataFrame([(1, "Steve"), (2, "Bob")], columns=["id", "name"])
>>> snowpark_df = session.write_pandas(pandas_df, "write_pandas_table", auto_create_table=True, table_type="temp")
>>> snowpark_df.sort('"id"').to_pandas()
   id   name
0   1  Steve
1   2    Bob

>>> pandas_df2 = pd.DataFrame([(3, "John")], columns=["id", "name"])
>>> snowpark_df2 = session.write_pandas(pandas_df2, "write_pandas_table", auto_create_table=False)
>>> snowpark_df2.sort('"id"').to_pandas()
   id   name
0   1  Steve
1   2    Bob
2   3   John

>>> pandas_df3 = pd.DataFrame([(1, "Jane")], columns=["id", "name"])
>>> snowpark_df3 = session.write_pandas(pandas_df3, "write_pandas_table", auto_create_table=False, overwrite=True)
>>> snowpark_df3.to_pandas()
   id  name
0   1  Jane

>>> pandas_df4 = pd.DataFrame([(1, "Jane")], columns=["id", "name"])
>>> snowpark_df4 = session.write_pandas(pandas_df4, "write_pandas_transient_table", auto_create_table=True, table_type="transient")
>>> snowpark_df4.to_pandas()
   id  name
0   1  Jane

-- Example 24836
>>> from snowflake.snowpark.functions import udf
>>> session.custom_package_usage_config = {"enabled": True, "cache_path": "@my_permanent_stage/folder"} 
>>> session.add_packages("package_unavailable_in_snowflake") 
>>> @udf
... def use_my_custom_package() -> str:
...     import package_unavailable_in_snowflake
...     return "works"
>>> session.clear_packages()
>>> session.clear_imports()

-- Example 24837
>>> session.telemetry_enabled
True
>>> session.telemetry_enabled = False
>>> session.telemetry_enabled
False
>>> session.telemetry_enabled = True
>>> session.telemetry_enabled
True

-- Example 24838
>>> session.sql("create or replace temp table prices(product_id varchar, amount number(10, 2))").collect()
[Row(status='Table PRICES successfully created.')]
>>> session.sql("insert into prices values ('id1', 10.0), ('id2', 20.0)").collect()
[Row(number of rows inserted=2)]
>>> # Create a CSV file to demo load
>>> import tempfile
>>> with tempfile.NamedTemporaryFile(mode="w+t") as t:
...     t.writelines(["id1, Product A", "\n" "id2, Product B"])
...     t.flush()
...     create_stage_result = session.sql("create temp stage test_stage").collect()
...     put_result = session.file.put(t.name, "@test_stage/test_dir")

-- Example 24839
>>> df_prices = session.table("prices")

-- Example 24840
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> df_catalog = session.read.schema(StructType([StructField("id", StringType()), StructField("name", StringType())])).csv("@test_stage/test_dir")
>>> df_catalog.show()
---------------------
|"ID"  |"NAME"      |
---------------------
|id1   | Product A  |
|id2   | Product B  |
---------------------

-- Example 24841
>>> session.create_dataframe([(1, "one"), (2, "two")], schema=["col_a", "col_b"]).show()
---------------------
|"COL_A"  |"COL_B"  |
---------------------
|1        |one      |
|2        |two      |
---------------------

>>> session.range(1, 10, 2).to_df("col1").show()
----------
|"COL1"  |
----------
|1       |
|3       |
|5       |
|7       |
|9       |
----------

-- Example 24842
>>> df_merged_data = df_catalog.join(df_prices, df_catalog["id"] == df_prices["product_id"])

-- Example 24843
>>> # Return a new DataFrame containing the product_id and amount columns of the prices table.
>>> # This is equivalent to: SELECT PRODUCT_ID, AMOUNT FROM PRICES;
>>> df_price_ids_and_amounts = df_prices.select(col("product_id"), col("amount"))

-- Example 24844
>>> # Return a new DataFrame containing the product_id column of the prices table as a column named
>>> # item_id. This is equivalent to: SELECT PRODUCT_ID AS ITEM_ID FROM PRICES;
>>> df_price_item_ids = df_prices.select(col("product_id").as_("item_id"))

-- Example 24845
>>> # Return a new DataFrame containing the row from the prices table with the ID 1.
>>> # This is equivalent to:
>>> # SELECT * FROM PRICES WHERE PRODUCT_ID = 1;
>>> df_price1 = df_prices.filter((col("product_id") == 1))

-- Example 24846
>>> # Return a new DataFrame for the prices table with the rows sorted by product_id.
>>> # This is equivalent to: SELECT * FROM PRICES ORDER BY PRODUCT_ID;
>>> df_sorted_prices = df_prices.sort(col("product_id"))

-- Example 24847
>>> import snowflake.snowpark.functions as f
>>> df_prices.agg(("amount", "sum")).collect()
[Row(SUM(AMOUNT)=Decimal('30.00'))]
>>> df_prices.agg(f.sum("amount")).collect()
[Row(SUM(AMOUNT)=Decimal('30.00'))]
>>> # rename the aggregation column name
>>> df_prices.agg(f.sum("amount").alias("total_amount"), f.max("amount").alias("max_amount")).collect()
[Row(TOTAL_AMOUNT=Decimal('30.00'), MAX_AMOUNT=Decimal('20.00'))]

-- Example 24848
>>> # Return a new DataFrame for the prices table that computes the sum of the prices by
>>> # category. This is equivalent to:
>>> #  SELECT CATEGORY, SUM(AMOUNT) FROM PRICES GROUP BY CATEGORY
>>> df_total_price_per_category = df_prices.group_by(col("product_id")).sum(col("amount"))
>>> # Have multiple aggregation values with the group by
>>> import snowflake.snowpark.functions as f
>>> df_summary = df_prices.group_by(col("product_id")).agg(f.sum(col("amount")).alias("total_amount"), f.avg("amount")).sort(col("product_id"))
>>> df_summary.show()
-------------------------------------------------
|"PRODUCT_ID"  |"TOTAL_AMOUNT"  |"AVG(AMOUNT)"  |
-------------------------------------------------
|id1           |10.00           |10.00000000    |
|id2           |20.00           |20.00000000    |
-------------------------------------------------

-- Example 24849
>>> from snowflake.snowpark import Window
>>> from snowflake.snowpark.functions import row_number
>>> df_prices.with_column("price_rank",  row_number().over(Window.order_by(col("amount").desc()))).show()
------------------------------------------
|"PRODUCT_ID"  |"AMOUNT"  |"PRICE_RANK"  |
------------------------------------------
|id2           |20.00     |1             |
|id1           |10.00     |2             |
------------------------------------------

-- Example 24850
>>> df = session.create_dataframe([[1, None, 3], [4, 5, None]], schema=["a", "b", "c"])
>>> df.na.fill({"b": 2, "c": 6}).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |3    |
|4    |5    |6    |
-------------------

-- Example 24851
>>> df_prices.collect()
[Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00')), Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))]

-- Example 24852
>>> df_prices.show()
---------------------------
|"PRODUCT_ID"  |"AMOUNT"  |
---------------------------
|id1           |10.00     |
|id2           |20.00     |
---------------------------

-- Example 24853
>>> df = session.create_dataframe([[1, 2], [3, 4], [5, -1]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
-0.5960395606792697

-- Example 24854
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6], [4.0, 6, 8]], schema=["a", "b", "c"])
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 24855
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 24856
pip install "snowflake-snowpark-python[modin]"

-- Example 24857
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

-- Example 24858
import modin.pandas as pd

# Import the Snowpark plugin for modin.
import snowflake.snowpark.modin.plugin

# Create a Snowpark session with a default connection.
from snowflake.snowpark.session import Session
session = Session.builder.create()

# Create a Snowpark pandas DataFrame from existing Snowflake table
df = pd.read_snowflake('SNOWFALL')

# Alternatively, create a Snowpark pandas DataFrame with sample data.
df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                    [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                    [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                    columns=["DAY", "LOCATION", "SNOWFALL"])

# Inspect the DataFrame
df

-- Example 24859
DAY  LOCATION  SNOWFALL
0       1  Big Bear       8.0
1       2  Big Bear      10.0
2       3  Big Bear       NaN
3       1     Tahoe       3.0
4       2     Tahoe       NaN
5       3     Tahoe      13.0
6       1  Whistler       NaN
7  Friday  Whistler      40.0
8       3  Whistler      25.0

-- Example 24860
# In-place point update to fix data error.
df.loc[df["DAY"]=="Friday","DAY"]=2

# Inspect the columns after update.
# Note how the data type is updated automatically after transformation.
df["DAY"]

-- Example 24861
0    1
1    2
2    3
3    1
4    2
5    3
6    1
7    2
8    3
Name: DAY, dtype: int64

-- Example 24862
# Drop rows with null values.
df.dropna()

-- Example 24863
DAY  LOCATION  SNOWFALL
0   1  Big Bear       8.0
1   2  Big Bear      10.0
3   1     Tahoe       3.0
5   3     Tahoe      13.0
7   2  Whistler      40.0
8   3  Whistler      25.0

-- Example 24864
# Compute the average daily snowfall across locations.
df.groupby("LOCATION").mean()["SNOWFALL"]

-- Example 24865
LOCATION
Big Bear     9.0
Tahoe        8.0
Whistler    32.5
Name: SNOWFALL, dtype: float64

-- Example 24866
conda create --name snowpark_pandas python=3.9
conda activate snowpark_pandas

-- Example 24867
pip install "snowflake-snowpark-python[modin]"

-- Example 24868
conda install snowflake-snowpark-python modin==0.28.1

-- Example 24869
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

CONNECTION_PARAMETERS = {
    'account': '<myaccount>',
    'user': '<myuser>',
    'password': '<mypassword>',
    'role': '<myrole>',
    'database': '<mydatabase>',
    'schema': '<myschema>',
    'warehouse': '<mywarehouse>',
}
session = Session.builder.configs(CONNECTION_PARAMETERS).create()

# pandas on Snowflake will automatically pick up the Snowpark session created above.
# It will use that session to create new DataFrames.
df = pd.DataFrame([1, 2])
df2 = pd.read_snowflake('CUSTOMER')

-- Example 24870
# pd.session is the session that pandas on Snowflake is using for new DataFrames.
# In this case it is the same as the Snowpark session that we've created.
assert pd.session is session

# Run SQL query with returned result as Snowpark DataFrame
snowpark_df = pd.session.sql('select * from customer')
snowpark_df.show()

-- Example 24871
default_connection_name = "default"

[default]
account = "<myaccount>"
user = "<myuser>"
password = "<mypassword>"
role="<myrole>"
database = "<mydatabase>"
schema = "<myschema>"
warehouse = "<mywarehouse>"

-- Example 24872
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
# create a DataFrame.
df = pd.DataFrame([[1, 2], [3, 4]])

-- Example 24873
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>").create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>").create()
pd.session = pandas_session
df = pd.DataFrame([1, 2, 3])

-- Example 24874
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

df = pd.DataFrame([1, 2, 3])

-- Example 24875
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>"}).create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>"}).create()
df = pd.DataFrame([1, 2, 3])

-- Example 24876
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):
  import modin.pandas as pd
  import snowflake.snowpark.modin.plugin

  df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                  [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                  [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                  columns=["DAY", "LOCATION", "SNOWFALL"])

  # Print a sample of the dataframe to standard output.
  print(df)

  snowpark_df = df.to_snowpark(index=None)
  # Return value will appear in the Results tab.
  return snowpark_df

-- Example 24877
CREATE OR REPLACE PROCEDURE run_data_transformation_pipeline_sp()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python','modin')
HANDLER='data_transformation_pipeline'
AS $$
def data_transformation_pipeline(session):
  import modin.pandas as pd
  import snowflake.snowpark.modin.plugin
  from datetime import datetime
  # Create a Snowpark pandas DataFrame with sample data.
  df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                    [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                    [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                      columns=["DAY", "LOCATION", "SNOWFALL"])
  # Drop rows with null values.
  df = df.dropna()
  # In-place point update to fix data error.
  df.loc[df["DAY"]=="Friday","DAY"]=2
  # Save Results as a Snowflake Table
  timestamp = datetime.now().strftime("%Y_%m_%d_%H_%M")
  save_path = f"OUTPUT_{timestamp}"
  df.to_snowflake(name=save_path, if_exists="replace", index=False)
  return f'Transformed DataFrame saved to {save_path}.'
$$;

-- Example 24878
from snowflake.snowpark.context import get_active_session
session = get_active_session()

from snowflake.snowpark import Session

def data_transformation_pipeline(session: Session) -> str:
  import modin.pandas as pd
  import snowflake.snowpark.modin.plugin
  from datetime import datetime
  # Create a Snowpark pandas DataFrame with sample data.
  df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                     [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                     [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                      columns=["DAY", "LOCATION", "SNOWFALL"])
  # Drop rows with null values.
  df = df.dropna()
  # In-place point update to fix data error.
  df.loc[df["DAY"]=="Friday","DAY"]=2
  # Save Results as a Snowflake Table
  timestamp = datetime.now().strftime("%Y_%m_%d_%H_%M")
  save_path = f"OUTPUT_{timestamp}"
  df.to_snowflake(name=save_path, if_exists="replace", index=False)
  return f'Transformed DataFrame saved to {save_path}.'


dt_pipeline_sproc = session.sproc.register(name="run_data_transformation_pipeline_sp",
                             func=data_transformation_pipeline,
                             replace=True,
                             packages=['modin', 'snowflake-snowpark-python'])

-- Example 24879
# Create a Snowpark session with a default connection.
session = Session.builder.create()

train = pd.read_snowflake('TITANIC')

train[['Pclass', 'Parch', 'Sex', 'Survived']].head()

-- Example 24880
Pclass  Parch     Sex       Survived
0       3      0     male               0
1       1      0   female               1
2       3      0   female               1
3       1      0   female               1
4       3      0     male               0

-- Example 24881
import altair as alt

survived_per_age_plot = alt.Chart(train).mark_bar(
).encode(
    x=alt.X('Age', bin=alt.Bin(maxbins=25)),
    y='count()',
    column='Survived:N',
    color='Survived:N',
).properties(
    width=300,
    height=300
).configure_axis(
    grid=False
)

-- Example 24882
# Perform groupby aggregation with Snowpark pandas
survived_per_gender = train.groupby(['Sex','Survived']).agg(count_survived=('Survived', 'count')).reset_index()

survived_per_gender_pandas = survived_per_gender
survived_per_gender_plot = alt.Chart(survived_per_gender).mark_bar().encode(
   x='Survived:N',
   y='Survived_Count',
   color='Sex',
   column='Sex'
).properties(
   width=200,
   height=200
).configure_axis(
   grid=False
)

-- Example 24883
feature_cols = ['Pclass', 'Parch']
X_pandas = train.loc[:, feature_cols]
y_pandas = train["Survived"]

from sklearn.linear_model import LogisticRegression

logreg = LogisticRegression()
logreg.fit(X_pandas, y_pandas)
y_pred_pandas = logreg.predict(X_pandas)
acc_eval = accuracy_score(y_pandas, y_pred_pandas)

-- Example 24884
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

from snowflake.cortex import Translate
content_df = pd.DataFrame(["good morning","hello", "goodbye"], columns=["content"])
result = content_df.apply(Translate, from_language="en", to_language="de")
result["content"]

-- Example 24885
Guten Morgen
Hallo
Auf Wiedersehen
Name: content, dtype: object

-- Example 24886
from snowflake.cortex import Sentiment

s = pd.read_snowflake("reviews")["content"]
result = s.apply(Sentiment)
result

-- Example 24887
from snowflake.cortex import ExtractAnswer
content = "The Snowflake company was co-founded by Thierry Cruanes, Marcin Zukowski, and Benoit Dageville in 2012 and is headquartered in Bozeman, Montana."

df = pd.DataFrame([content])
result = df.apply(ExtractAnswer, question="When was Snowflake founded?")
result[0][0][0]["answer"]

-- Example 24888
'2012'

-- Example 24889
df = pd.DataFrame({"a": [1,2,3], "b": ["x", "y", "z"]})
# Running this in Snowpark pandas throws an error
df["A"].sum()
# Convert a small sample of 10 rows to pandas DataFrame for testing
pandas_df = df.head(10).to_pandas()
# Run the same operation. KeyError indicates that the column reference is incorrect
pandas_df["A"].sum()
# Fix the column reference to get the Snowpark pandas query working
df["a"].sum()

-- Example 24890
for i in np.arange(0, 50):
  if i % 2 == 0:
    data = pd.concat([data, pd.DataFrame({'A': i, 'B': i + 1}, index=[0])], ignore_index=True)
  else:
    data = pd.concat([data, pd.DataFrame({'A': i}, index=[0])], ignore_index=True)

# Instead of creating one DataFrame per row and concatenating them,
# try to directly create the DataFrame out of the data, like this:

data = pd.DataFrame(
      {
          "A": range(0, 50),
          "B": [i + 1 if i % 2 == 0 else None for i in range(50)],
      },
)

-- Example 24891
df = pd.read_snowflake('pandas_test')
df2 = pd.pivot_table(df, index='index_col', columns='pivot_col') # expensive operation
df3 = df.merge(df2)
df4 = df3.where(df2 == True)

-- Example 24892
df = pd.read_snowflake('pandas_test')
df2 = pd.pivot_table(df, index='index_col', columns='pivot_col') # expensive operation
df2.cache_result(inplace=True)
df3 = df.merge(df2)
df4 = df3.where(df2 == True)

-- Example 24893
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

from snowflake.snowpark import Session

CONNECTION_PARAMETERS = {
    'account': '<myaccount>',
    'user': '<myuser>',
    'password': '<mypassword>',
    'role': '<myrole>',
    'database': '<mydatabase>',
    'schema': '<myschema>',
    'warehouse': '<mywarehouse>',
}
session = Session.builder.configs(CONNECTION_PARAMETERS).create()

df = pd.DataFrame([['a', 2.1, 1],['b', 4.2, 2],['c', 6.3, None]], columns=["COL_STR", "COL_FLOAT", "COL_INT"])

df

-- Example 24894
COL_STR    COL_FLOAT    COL_INT
0       a          2.1        1.0
1       b          4.2        2.0
2       c          6.3        NaN

-- Example 24895
df.to_snowflake("pandas_test", if_exists='replace',index=False)

-- Example 24896
# Create a DataFrame out of a Snowflake table.
df = pd.read_snowflake('pandas_test')

df.shape

-- Example 24897
(3, 3)

-- Example 24898
df.head(2)

