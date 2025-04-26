-- Example 31998
>>> s.str.strip('123.!? \n\t')
0     Ant
1     Bee
2     Cat
3    None
4    None
5    None
dtype: object

-- Example 31999
>>> ser = pd.Series(["El niño", "Françoise"])
>>> mytable = str.maketrans({'ñ': 'n', 'ç': 'c'})
>>> ser.str.translate(mytable)  
0   El nino
1   Francoise
dtype: object

-- Example 32000
>>> import pandas
>>> pandas.Series("aaa").str.translate({"a": "A"})
0    aaa
dtype: object
>>> pandas.Series("aaa").str.translate(str.maketrans({"a": "A"}))
0    AAA
dtype: object

-- Example 32001
>>> pd.Series("aaa").str.translate({"a": "A"})
0    AAA
dtype: object
>>> pd.Series("aaa").str.translate(str.maketrans({"a": "A"}))
0    AAA
dtype: object

-- Example 32002
>>> import pandas
>>> pandas.Series("ab").str.translate(str.maketrans({"a": "A", "b": "BBB"}))
0    ABBB
dtype: object

-- Example 32003
>>> pd.Series("ab").str.translate({"a": "A"}).str.replace("b", "BBB")
0    ABBB
dtype: object

-- Example 32004
>>> series = pd.Series(['red', 'green', 'blue'], name='color')
>>> series.to_csv('out.csv', index=False)

-- Example 32005
>>> series.to_csv(index=False)  
>>> compression_opts = dict(method='zip',
...                         archive_name='out.csv')  
>>> series.to_csv('out.zip', index=False,
...           compression=compression_opts)

-- Example 32006
>>> from pathlib import Path  
>>> filepath = Path('folder/subfolder/out.csv')  
>>> filepath.parent.mkdir(parents=True, exist_ok=True)  
>>> df.to_csv(filepath)

-- Example 32007
>>> import os  
>>> os.makedirs('folder/subfolder', exist_ok=True)  
>>> df.to_csv('folder/subfolder/out.csv')

-- Example 32008
>>> d = {'col1': [1, 2], 'col2': [3, 4]}
>>> df = pd.DataFrame(data=d)
>>> df
   col1  col2
0     1     3
1     2     4

-- Example 32009
>>> df2 = pd.DataFrame(np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]]),
...                    columns=['a', 'b', 'c'])
>>> df2
   a  b  c
0  1  2  3
1  4  5  6
2  7  8  9

-- Example 32010
>>> data = np.array([(1, 2, 3), (4, 5, 6), (7, 8, 9)],
...                 dtype=[("a", "i4"), ("b", "i4"), ("c", "i4")])
>>> df3 = pd.DataFrame(data, columns=['c', 'a'])
...
>>> df3
   c  a
0  3  1
1  6  4
2  9  7

-- Example 32011
>>> ser = pd.Series([1, 2, 3], index=["a", "b", "c"], name = "s")
>>> df = pd.DataFrame(data=ser, index=["a", "c"])
>>> df
   s
a  1
c  3
>>> df1 = pd.DataFrame([1, 2, 3], index=["a", "b", "c"], columns=["x"])
>>> df2 = pd.DataFrame(data=df1, index=["a", "c"])
>>> df2
   x
a  1
c  3

-- Example 32012
>>> df = pd.DataFrame({'float': [1.0],
...                    'int': [1],
...                    'datetime': [pd.Timestamp('20180310')],
...                    'string': ['foo']})
>>> df.dtypes
float              float64
int                  int64
datetime    datetime64[ns]
string              object
dtype: object

-- Example 32013
>>> df = pd.DataFrame({'COL1': [1, 2, 3],
...                    'COL2': ['A', 'B', 'C']})

-- Example 32014
>>> df.info() 
<class 'modin.pandas.dataframe.DataFrame'>
SnowflakeIndex
Data columns (total 2 columns):
 #   Column  Non-Null Count  Dtype
---  ------  --------------  -----
 0   COL1    3 non-null      int64
 1   COL2    3 non-null      object
dtypes: int64(1), object(1)
memory usage: 0.0 bytes

-- Example 32015
>>> df = pd.DataFrame({'a': [1, 2] * 3,
...                    'b': [True, False] * 3,
...                    'c': [1.0, 2.0] * 3})

-- Example 32016
>>> df.dtypes  
a      int64
b       bool
c    float64
dtype: object

-- Example 32017
>>> df.select_dtypes("number")  
   a    c
0  1  1.0
1  2  2.0
2  1  1.0
3  2  2.0
4  1  1.0
5  2  2.0

-- Example 32018
>>> df.select_dtypes(include=[bool])  
       b
0   True
1  False
2   True
3  False
4   True
5  False

-- Example 32019
>>> df.select_dtypes(exclude=[int])  
       b    c
0   True  1.0
1  False  2.0
2   True  1.0
3  False  2.0
4   True  1.0
5  False  2.0

-- Example 32020
>>> df = pd.DataFrame({'col1': [1, 2], 'col2': [3, 4]})
>>> df.axes
[Index([0, 1], dtype='int64'), Index(['col1', 'col2'], dtype='object')]

-- Example 32021
>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]})
>>> df.to_pandas()
   Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0

-- Example 32022
>>> df['Animal'].to_pandas()
0    Falcon
1    Falcon
2    Parrot
3    Parrot
Name: Animal, dtype: object

-- Example 32023
>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]})
>>> df
   Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0
>>> snowpark_df = df.to_snowpark(index_label='Order')
>>> snowpark_df.order_by('"Max Speed"').show()
------------------------------------
|"Order"  |"Animal"  |"Max Speed"  |
------------------------------------
|2        |Parrot    |24.0         |
|3        |Parrot    |26.0         |
|1        |Falcon    |370.0        |
|0        |Falcon    |380.0        |
------------------------------------

>>> snowpark_df = df.to_snowpark(index=False)
>>> snowpark_df.order_by('"Max Speed"').show()
--------------------------
|"Animal"  |"Max Speed"  |
--------------------------
|Parrot    |24.0         |
|Parrot    |26.0         |
|Falcon    |370.0        |
|Falcon    |380.0        |
--------------------------

>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]}, index=pd.Index([3, 5, 6, 7], name="id"))
>>> df      
    Animal  Max Speed
id
3  Falcon      380.0
5  Falcon      370.0
6  Parrot       24.0
7  Parrot       26.0
>>> snowpark_df = df.to_snowpark()
>>> snowpark_df.order_by('"id"').show()
---------------------------------
|"id"  |"Animal"  |"Max Speed"  |
---------------------------------
|3     |Falcon    |380.0        |
|5     |Falcon    |370.0        |
|6     |Parrot    |24.0         |
|7     |Parrot    |26.0         |
---------------------------------


MultiIndex usage

>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]},
...                    index=pd.MultiIndex.from_tuples([('bar', 'one'), ('foo', 'one'), ('bar', 'two'), ('foo', 'three')], names=['first', 'second']))
>>> df      
                Animal  Max Speed
first second
bar   one     Falcon      380.0
foo   one     Falcon      370.0
bar   two     Parrot       24.0
foo   three   Parrot       26.0
>>> snowpark_df = df.to_snowpark(index=True, index_label=['A', 'B'])
>>> snowpark_df.order_by('"A"', '"B"').show()
----------------------------------------
|"A"  |"B"    |"Animal"  |"Max Speed"  |
----------------------------------------
|bar  |one    |Falcon    |380.0        |
|bar  |two    |Parrot    |24.0         |
|foo  |one    |Falcon    |370.0        |
|foo  |three  |Parrot    |26.0         |
----------------------------------------

>>> snowpark_df = df.to_snowpark(index=False)
>>> snowpark_df.order_by('"Max Speed"').show()
--------------------------
|"Animal"  |"Max Speed"  |
--------------------------
|Parrot    |24.0         |
|Parrot    |26.0         |
|Falcon    |370.0        |
|Falcon    |380.0        |
--------------------------

-- Example 32024
>>> new_df = df.cache_result()

-- Example 32025
>>> import numpy as np

-- Example 32026
>>> np.all((new_df == df).values)  
True

-- Example 32027
>>> df.reset_index(drop=True, inplace=True) # Slower

-- Example 32028
>>> new_df.reset_index(drop=True, inplace=True) # Faster

-- Example 32029
Saving DataFrame to an Iceberg table. Note that the external_volume, catalog, and base_location should have been setup externally.
See `Create your first Iceberg table <https://docs.snowflake.com/en/user-guide/tutorials/create-your-first-iceberg-table>`_ for more information on creating iceberg resources.

>>> df = session.create_dataframe([[1,2],[3,4]], schema=["a", "b"])
>>> iceberg_config = {
...     "external_volume": "example_volume",
...     "catalog": "example_catalog",
...     "base_location": "/iceberg_root",
...     "storage_serialization_policy": "OPTIMIZED",
... }
>>> df.to_snowpark_pandas().to_iceberg("my_table", mode="overwrite", iceberg_config=iceberg_config) # doctest: +SKIP

-- Example 32030
>>> d = {'col1': [1, 2], 'col2': [3, 4]}
>>> df = pd.DataFrame(data=d)
>>> df.dtypes
col1    int64
col2    int64
dtype: object

-- Example 32031
>>> df.astype('int32').dtypes
col1    int64
col2    int64
dtype: object

-- Example 32032
>>> df.astype({'col1': 'float64'}).dtypes
col1    float64
col2      int64
dtype: object

-- Example 32033
>>> ser = pd.Series([1, 2], dtype=str)
>>> ser
0    1
1    2
dtype: object
>>> ser.astype('float64')
0    1.0
1    2.0
dtype: float64

-- Example 32034
>>> s = pd.Series([1, 2], index=["a", "b"])
>>> s
a    1
b    2
dtype: int64

-- Example 32035
>>> s_copy = s.copy()
>>> s_copy
a    1
b    2
dtype: int64

-- Example 32036
>>> s = pd.Series([1, 2], index=["a", "b"])
>>> deep = s.copy()
>>> shallow = s.copy(deep=False)

-- Example 32037
>>> s.sort_values(ascending=False, inplace=True)
>>> shallow.sort_values(ascending=False, inplace=True)
>>> s
b    2
a    1
dtype: int64
>>> shallow
b    2
a    1
dtype: int64
>>> deep
a    1
b    2
dtype: int64

-- Example 32038
>>> df = pd.DataFrame({'temp_c': [17.0, 25.0]},
...                   index=['Portland', 'Berkeley'])
>>> df
          temp_c
Portland    17.0
Berkeley    25.0

-- Example 32039
>>> df.assign(temp_f=lambda x: x.temp_c * 9 / 5 + 32)
          temp_c  temp_f
Portland    17.0    62.6
Berkeley    25.0    77.0

-- Example 32040
>>> df.assign(temp_f=df['temp_c'] * 9 / 5 + 32)
          temp_c  temp_f
Portland    17.0    62.6
Berkeley    25.0    77.0

-- Example 32041
>>> df.assign(temp_f=lambda x: x['temp_c'] * 9 / 5 + 32,
...           temp_k=lambda x: (x['temp_f'] + 459.67) * 5 / 9)
          temp_c  temp_f  temp_k
Portland    17.0    62.6  290.15
Berkeley    25.0    77.0  298.15

-- Example 32042
>>> df = pd.DataFrame({'col1': [17.0, 25.0, 22.0]})
>>> df
   col1
0  17.0
1  25.0
2  22.0

-- Example 32043
>>> df.assign(new_col=[10, 11])
   col1  new_col
0  17.0       10
1  25.0       11
2  22.0       11

-- Example 32044
>>> df.assign(new_col=[10, 11, 12, 13, 14])
   col1  new_col
0  17.0       10
1  25.0       11
2  22.0       12

-- Example 32045
>>> df = pd.DataFrame([[1, 2], [4, 5], [7, 8]],
...      index=['cobra', 'viper', 'sidewinder'],
...      columns=['max_speed', 'shield'])
>>> df
            max_speed  shield
cobra               1       2
viper               4       5
sidewinder          7       8

-- Example 32046
>>> df.loc['viper']
max_speed    4
shield       5
Name: viper, dtype: int64

-- Example 32047
>>> df.loc[['viper', 'sidewinder']]
            max_speed  shield
viper               4       5
sidewinder          7       8

-- Example 32048
>>> df.loc['cobra', 'shield']  
2

-- Example 32049
>>> df.loc['cobra':'viper', 'max_speed']
cobra    1
viper    4
Name: max_speed, dtype: int64

-- Example 32050
>>> df.loc[[False, False, True]]
            max_speed  shield
sidewinder          7       8

-- Example 32051
>>> df.loc[pd.Series([False, True, False],
...        index=['viper', 'sidewinder', 'cobra'])]
            max_speed  shield
sidewinder          7       8

-- Example 32052
>>> df.loc[pd.Index(["cobra", "viper"], name="foo")]  
       max_speed  shield
foo
cobra          1       2
viper          4       5

-- Example 32053
>>> df.loc[df['shield'] > 6]
            max_speed  shield
sidewinder          7       8

-- Example 32054
>>> df.loc[df['shield'] > 6, ['max_speed']]
            max_speed
sidewinder          7

-- Example 32055
>>> df.loc[lambda df: df['shield'] == 8]
            max_speed  shield
sidewinder          7       8

-- Example 32056
>>> df.loc[['viper', 'sidewinder'], ['shield']] = 50
>>> df
            max_speed  shield
cobra               1       2
viper               4      50
sidewinder          7      50

-- Example 32057
>>> df.loc['cobra'] = 10
>>> df
            max_speed  shield
cobra              10      10
viper               4      50
sidewinder          7      50

-- Example 32058
>>> df.loc[:, 'max_speed'] = 30
>>> df
            max_speed  shield
cobra              30      10
viper              30      50
sidewinder         30      50

-- Example 32059
>>> df.loc[df['shield'] > 35] = 0
>>> df
            max_speed  shield
cobra              30      10
viper               0       0
sidewinder          0       0

-- Example 32060
>>> df.loc["viper"] = pd.Series([99, 99], index=["max_speed", "shield"])
>>> df
            max_speed  shield
cobra              30      10
viper              99      99
sidewinder          0       0

-- Example 32061
>>> df = pd.DataFrame([[1, 2], [4, 5], [7, 8]],
...      index=[7, 8, 9], columns=['max_speed', 'shield'])
>>> df
   max_speed  shield
7          1       2
8          4       5
9          7       8

-- Example 32062
>>> df.loc[7:9]
   max_speed  shield
7          1       2
8          4       5
9          7       8

-- Example 32063
>>> tuples = [
...    ('cobra', 'mark i'), ('cobra', 'mark ii'),
...    ('sidewinder', 'mark i'), ('sidewinder', 'mark ii'),
...    ('viper', 'mark ii'), ('viper', 'mark iii')
... ]
>>> index = pd.MultiIndex.from_tuples(tuples)
>>> values = [[12, 2], [0, 4], [10, 20],
...         [1, 4], [7, 1], [16, 36]]
>>> df = pd.DataFrame(values, columns=['max_speed', 'shield'], index=index)
>>> df
                     max_speed  shield
cobra      mark i           12       2
           mark ii           0       4
sidewinder mark i           10      20
           mark ii           1       4
viper      mark ii           7       1
           mark iii         16      36

-- Example 32064
>>> df.loc['cobra']
         max_speed  shield
mark i          12       2
mark ii          0       4

