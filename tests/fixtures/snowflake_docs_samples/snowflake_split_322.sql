-- Example 21552
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

-- Example 21553
# pd.session is the session that pandas on Snowflake is using for new DataFrames.
# In this case it is the same as the Snowpark session that we've created.
assert pd.session is session

# Run SQL query with returned result as Snowpark DataFrame
snowpark_df = pd.session.sql('select * from customer')
snowpark_df.show()

-- Example 21554
default_connection_name = "default"

[default]
account = "<myaccount>"
user = "<myuser>"
password = "<mypassword>"
role="<myrole>"
database = "<mydatabase>"
schema = "<myschema>"
warehouse = "<mywarehouse>"

-- Example 21555
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
# create a DataFrame.
df = pd.DataFrame([[1, 2], [3, 4]])

-- Example 21556
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>").create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>").create()
pd.session = pandas_session
df = pd.DataFrame([1, 2, 3])

-- Example 21557
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

df = pd.DataFrame([1, 2, 3])

-- Example 21558
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>"}).create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>"}).create()
df = pd.DataFrame([1, 2, 3])

-- Example 21559
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

-- Example 21560
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

-- Example 21561
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

-- Example 21562
# Create a Snowpark session with a default connection.
session = Session.builder.create()

train = pd.read_snowflake('TITANIC')

train[['Pclass', 'Parch', 'Sex', 'Survived']].head()

-- Example 21563
Pclass  Parch     Sex       Survived
0       3      0     male               0
1       1      0   female               1
2       3      0   female               1
3       1      0   female               1
4       3      0     male               0

-- Example 21564
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

-- Example 21565
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

-- Example 21566
feature_cols = ['Pclass', 'Parch']
X_pandas = train.loc[:, feature_cols]
y_pandas = train["Survived"]

from sklearn.linear_model import LogisticRegression

logreg = LogisticRegression()
logreg.fit(X_pandas, y_pandas)
y_pred_pandas = logreg.predict(X_pandas)
acc_eval = accuracy_score(y_pandas, y_pred_pandas)

-- Example 21567
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

from snowflake.cortex import Translate
content_df = pd.DataFrame(["good morning","hello", "goodbye"], columns=["content"])
result = content_df.apply(Translate, from_language="en", to_language="de")
result["content"]

-- Example 21568
Guten Morgen
Hallo
Auf Wiedersehen
Name: content, dtype: object

-- Example 21569
from snowflake.cortex import Sentiment

s = pd.read_snowflake("reviews")["content"]
result = s.apply(Sentiment)
result

-- Example 21570
from snowflake.cortex import ExtractAnswer
content = "The Snowflake company was co-founded by Thierry Cruanes, Marcin Zukowski, and Benoit Dageville in 2012 and is headquartered in Bozeman, Montana."

df = pd.DataFrame([content])
result = df.apply(ExtractAnswer, question="When was Snowflake founded?")
result[0][0][0]["answer"]

-- Example 21571
'2012'

-- Example 21572
df = pd.DataFrame({"a": [1,2,3], "b": ["x", "y", "z"]})
# Running this in Snowpark pandas throws an error
df["A"].sum()
# Convert a small sample of 10 rows to pandas DataFrame for testing
pandas_df = df.head(10).to_pandas()
# Run the same operation. KeyError indicates that the column reference is incorrect
pandas_df["A"].sum()
# Fix the column reference to get the Snowpark pandas query working
df["a"].sum()

-- Example 21573
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

-- Example 21574
df = pd.read_snowflake('pandas_test')
df2 = pd.pivot_table(df, index='index_col', columns='pivot_col') # expensive operation
df3 = df.merge(df2)
df4 = df3.where(df2 == True)

-- Example 21575
df = pd.read_snowflake('pandas_test')
df2 = pd.pivot_table(df, index='index_col', columns='pivot_col') # expensive operation
df2.cache_result(inplace=True)
df3 = df.merge(df2)
df4 = df3.where(df2 == True)

-- Example 21576
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

-- Example 21577
COL_STR    COL_FLOAT    COL_INT
0       a          2.1        1.0
1       b          4.2        2.0
2       c          6.3        NaN

-- Example 21578
df.to_snowflake("pandas_test", if_exists='replace',index=False)

-- Example 21579
# Create a DataFrame out of a Snowflake table.
df = pd.read_snowflake('pandas_test')

df.shape

-- Example 21580
(3, 3)

-- Example 21581
df.head(2)

-- Example 21582
COL_STR  COL_FLOAT  COL_INT
0         a        2.1        1
1         b        4.2        2

-- Example 21583
df.dropna(subset=["COL_FLOAT"], inplace=True)

df

-- Example 21584
COL_STR  COL_FLOAT  COL_INT
0         a        2.1        1
1         c        6.3        2

-- Example 21585
df.shape

-- Example 21586
(2, 3)

-- Example 21587
df.dtypes

-- Example 21588
COL_STR       object
COL_FLOAT    float64
COL_INT        int64
dtype: object

-- Example 21589
# Save the result back to Snowflake with a row_pos column.
df.reset_index(drop=True).to_snowflake('pandas_test2', if_exists='replace', index=True, index_label=['row_pos'])

-- Example 21590
row_pos  COL_STR  COL_FLOAT  COL_INT
0          1         a       2.0        1
1          2         b       4.0        2

-- Example 21591
# Reading and writing to Snowflake
df = pd.DataFrame({"fruit": ["apple", "orange"], "size": [3.4, 5.4], "weight": [1.4, 3.2]})
df.to_snowflake("test_table", if_exists="replace", index=False )

df_table = pd.read_snowflake("test_table")


# Generate sample CSV file
with open("data.csv", "w") as f:
    f.write('fruit,size,weight\napple,3.4,1.4\norange,5.4,3.2')
# Read from local CSV file
df_csv = pd.read_csv("data.csv")

# Generate sample JSON file
with open("data.json", "w") as f:
    f.write('{"fruit":"apple", "size":3.4, "weight":1.4},{"fruit":"orange", "size":5.4, "weight":3.2}')
# Read from local JSON file
df_json = pd.read_json('data.json')

# Upload data.json and data.csv to Snowflake stage named @TEST_STAGE
# Read CSV and JSON file from stage
df_csv = pd.read_csv('@TEST_STAGE/data.csv')
df_json = pd.read_json('@TEST_STAGE/data.json')

-- Example 21592
df = pd.DataFrame({"a": [1,2,3], "b": ["x", "y", "z"]})
df.columns

-- Example 21593
Index(['a', 'b'], dtype='object')

-- Example 21594
df.index

-- Example 21595
Index([0, 1, 2], dtype='int8')

-- Example 21596
df["a"]

-- Example 21597
0    1
1    2
2    3
Name: a, dtype: int8

-- Example 21598
df["b"]

-- Example 21599
0    x
1    y
2    z
Name: b, dtype: object

-- Example 21600
df.iloc[0,1]

-- Example 21601
'x'

-- Example 21602
df.loc[df["a"] > 2]

-- Example 21603
a  b
2  3  z

-- Example 21604
df.columns = ["c", "d"]
df

-- Example 21605
c  d
0    1  x
1    2  y
2    3  z

-- Example 21606
df = df.set_index("c")
df

-- Example 21607
d
c
1  x
2  y
3  z

-- Example 21608
df.rename(columns={"d": "renamed"})

-- Example 21609
renamed
c
1       x
2       y
3       z

-- Example 21610
import numpy as np
df = pd.DataFrame([[np.nan, 2, np.nan, 0],
                [3, 4, np.nan, 1],
                [np.nan, np.nan, np.nan, np.nan],
                [np.nan, 3, np.nan, 4]],
                columns=list("ABCD"))
df

-- Example 21611
A    B   C    D
0  NaN  2.0 NaN  0.0
1  3.0  4.0 NaN  1.0
2  NaN  NaN NaN  NaN
3  NaN  3.0 NaN  4.0

-- Example 21612
df.isna()

-- Example 21613
A      B     C      D
0   True  False  True  False
1  False  False  True  False
2   True   True  True   True
3   True  False  True  False

-- Example 21614
df.fillna(0)

-- Example 21615
A    B    C    D
0   0.0  2.0  0.0  0.0
1   3.0  4.0  0.0  1.0
2   0.0  0.0  0.0  0.0
3   0.0  3.0  0.0  4.0

-- Example 21616
df.dropna(how="all")

-- Example 21617
A    B   C    D
0   NaN  2.0 NaN  0.0
1   3.0  4.0 NaN  1.0
3   NaN  3.0 NaN  4.0

-- Example 21618
df = pd.DataFrame({"int": [1,2,3], "str": ["4", "5", "6"]})
df

