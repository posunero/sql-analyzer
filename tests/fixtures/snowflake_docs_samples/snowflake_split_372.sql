-- Example 24899
COL_STR  COL_FLOAT  COL_INT
0         a        2.1        1
1         b        4.2        2

-- Example 24900
df.dropna(subset=["COL_FLOAT"], inplace=True)

df

-- Example 24901
COL_STR  COL_FLOAT  COL_INT
0         a        2.1        1
1         c        6.3        2

-- Example 24902
df.shape

-- Example 24903
(2, 3)

-- Example 24904
df.dtypes

-- Example 24905
COL_STR       object
COL_FLOAT    float64
COL_INT        int64
dtype: object

-- Example 24906
# Save the result back to Snowflake with a row_pos column.
df.reset_index(drop=True).to_snowflake('pandas_test2', if_exists='replace', index=True, index_label=['row_pos'])

-- Example 24907
row_pos  COL_STR  COL_FLOAT  COL_INT
0          1         a       2.0        1
1          2         b       4.0        2

-- Example 24908
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

-- Example 24909
df = pd.DataFrame({"a": [1,2,3], "b": ["x", "y", "z"]})
df.columns

-- Example 24910
Index(['a', 'b'], dtype='object')

-- Example 24911
df.index

-- Example 24912
Index([0, 1, 2], dtype='int8')

-- Example 24913
df["a"]

-- Example 24914
0    1
1    2
2    3
Name: a, dtype: int8

-- Example 24915
df["b"]

-- Example 24916
0    x
1    y
2    z
Name: b, dtype: object

-- Example 24917
df.iloc[0,1]

-- Example 24918
'x'

-- Example 24919
df.loc[df["a"] > 2]

-- Example 24920
a  b
2  3  z

-- Example 24921
df.columns = ["c", "d"]
df

-- Example 24922
c  d
0    1  x
1    2  y
2    3  z

-- Example 24923
df = df.set_index("c")
df

-- Example 24924
d
c
1  x
2  y
3  z

-- Example 24925
df.rename(columns={"d": "renamed"})

-- Example 24926
renamed
c
1       x
2       y
3       z

-- Example 24927
import numpy as np
df = pd.DataFrame([[np.nan, 2, np.nan, 0],
                [3, 4, np.nan, 1],
                [np.nan, np.nan, np.nan, np.nan],
                [np.nan, 3, np.nan, 4]],
                columns=list("ABCD"))
df

-- Example 24928
A    B   C    D
0  NaN  2.0 NaN  0.0
1  3.0  4.0 NaN  1.0
2  NaN  NaN NaN  NaN
3  NaN  3.0 NaN  4.0

-- Example 24929
df.isna()

-- Example 24930
A      B     C      D
0   True  False  True  False
1  False  False  True  False
2   True   True  True   True
3   True  False  True  False

-- Example 24931
df.fillna(0)

-- Example 24932
A    B    C    D
0   0.0  2.0  0.0  0.0
1   3.0  4.0  0.0  1.0
2   0.0  0.0  0.0  0.0
3   0.0  3.0  0.0  4.0

-- Example 24933
df.dropna(how="all")

-- Example 24934
A    B   C    D
0   NaN  2.0 NaN  0.0
1   3.0  4.0 NaN  1.0
3   NaN  3.0 NaN  4.0

-- Example 24935
df = pd.DataFrame({"int": [1,2,3], "str": ["4", "5", "6"]})
df

-- Example 24936
int str
0    1   4
1    2   5
2    3   6

-- Example 24937
df_float = df.astype(float)
df_float

-- Example 24938
int  str
0  1.0  4.0
1  2.0  5.0
2  3.0  6.0

-- Example 24939
df_float.dtypes

-- Example 24940
int    float64
str    float64
dtype: object

-- Example 24941
pd.to_numeric(df.str)

-- Example 24942
0    4.0
1    5.0
2    6.0
Name: str, dtype: float64

-- Example 24943
df = pd.DataFrame({'year': [2015, 2016],
                'month': [2, 3],
                'day': [4, 5]})
pd.to_datetime(df)

-- Example 24944
0   2015-02-04
1   2016-03-05
dtype: datetime64[ns]

-- Example 24945
df_1 = pd.DataFrame([[1,2,3],[4,5,6]])
df_2 = pd.DataFrame([[6,7,8]])
df_1.add(df_2)

-- Example 24946
0    1     2
0  7.0  9.0  11.0
1  NaN  NaN   NaN

-- Example 24947
s1 = pd.Series([1, 2, 3])
s2 = pd.Series([2, 2, 2])
s1 + s2

-- Example 24948
0    3
1    4
2    5
dtype: int64

-- Example 24949
df = pd.DataFrame({"A": [1,2,3], "B": [4,5,6]})
df["A+B"] = df["A"] + df["B"]
df

-- Example 24950
A  B  A+B
0  1  4    5
1  2  5    7
2  3  6    9

-- Example 24951
df = pd.DataFrame([[1, 2, 3],
                [4, 5, 6],
                [7, 8, 9],
                [np.nan, np.nan, np.nan]],
                columns=['A', 'B', 'C'])
df.agg(['sum', 'min'])

-- Example 24952
A     B     C
sum  12.0  15.0  18.0
min   1.0   2.0   3.0

-- Example 24953
df.median()

-- Example 24954
A    4.0
B    5.0
C    6.0
dtype: float64

-- Example 24955
df1 = pd.DataFrame({'lkey': ['foo', 'bar', 'baz', 'foo'],
                    'value': [1, 2, 3, 5]})
df1

-- Example 24956
lkey  value
0  foo      1
1  bar      2
2  baz      3
3  foo      5

-- Example 24957
df2 = pd.DataFrame({'rkey': ['foo', 'bar', 'baz', 'foo'],
                    'value': [5, 6, 7, 8]})
df2

-- Example 24958
rkey  value
0  foo      5
1  bar      6
2  baz      7
3  foo      8

-- Example 24959
df1.merge(df2, left_on='lkey', right_on='rkey')

-- Example 24960
lkey  value_x rkey  value_y
0  foo        1  foo        5
1  foo        1  foo        8
2  bar        2  bar        6
3  baz        3  baz        7
4  foo        5  foo        5
5  foo        5  foo        8

-- Example 24961
df = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3', 'K4', 'K5'],
                'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})
df

-- Example 24962
key   A
0  K0  A0
1  K1  A1
2  K2  A2
3  K3  A3
4  K4  A4
5  K5  A5

-- Example 24963
other = pd.DataFrame({'key': ['K0', 'K1', 'K2'],
                    'B': ['B0', 'B1', 'B2']})
df.join(other, lsuffix='_caller', rsuffix='_other')

-- Example 24964
key_caller   A key_other     B
0         K0  A0        K0    B0
1         K1  A1        K1    B1
2         K2  A2        K2    B2
3         K3  A3      None  None
4         K4  A4      None  None
5         K5  A5      None  None

-- Example 24965
df = pd.DataFrame({'Animal': ['Falcon', 'Falcon','Parrot', 'Parrot'],
               'Max Speed': [380., 370., 24., 26.]})

df

