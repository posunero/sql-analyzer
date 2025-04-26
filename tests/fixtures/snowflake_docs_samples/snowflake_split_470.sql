-- Example 31462
>>> pd.read_excel(open('tmp.xlsx', 'rb'),
...               sheet_name='Sheet3')  
   Unnamed: 0      Name  Value
0           0   string1      1
1           1   string2      2
2           2  #Comment      3

-- Example 31463
>>> pd.read_excel('tmp.xlsx', index_col=None, header=None)  
     0         1      2
0  NaN      Name  Value
1  0.0   string1      1
2  1.0   string2      2
3  2.0  #Comment      3

-- Example 31464
>>> pd.read_excel('tmp.xlsx', index_col=0,
...               dtype={'Name': str, 'Value': float})  
       Name  Value
0   string1    1.0
1   string2    2.0
2  #Comment    3.0

-- Example 31465
>>> pd.read_excel('tmp.xlsx', index_col=0,
...               na_values=['string1', 'string2'])  
       Name  Value
0       NaN      1
1       NaN      2
2  #Comment      3

-- Example 31466
>>> pd.read_excel('tmp.xlsx', index_col=0, comment='#')  
      Name  Value
0  string1    1.0
1  string2    2.0
2     None    NaN

-- Example 31467
>>> import tempfile
>>> import json
>>> temp_dir = tempfile.TemporaryDirectory()
>>> temp_dir_name = temp_dir.name

-- Example 31468
>>> data = {'A': "snowpark!", 'B': 3, 'C': [5, 6]}
>>> with open(f'{temp_dir_name}/snowpark_pandas.json', 'w') as f:
...     json.dump(data, f)

-- Example 31469
>>> import modin.pandas as pd
>>> import snowflake.snowpark.modin.plugin
>>> df = pd.read_json(f'{temp_dir_name}/snowpark_pandas.json')
>>> df
           A  B       C
0  snowpark!  3  [5, 6]

-- Example 31470
>>> _ = session.sql("create or replace temp stage mytempstage").collect()
>>> _ = session.file.put(f'{temp_dir_name}/snowpark_pandas.json', '@mytempstage/myprefix')
>>> df2 = pd.read_json('@mytempstage/myprefix/snowpark_pandas.json')
>>> df2
           A  B       C
0  snowpark!  3  [5, 6]

-- Example 31471
>>> with open(f'{temp_dir_name}/snowpark_pandas2.json', 'w') as f:
...     json.dump(data, f)
>>> df3 = pd.read_json(f'{temp_dir_name}')
>>> df3
           A  B       C
0  snowpark!  3  [5, 6]
1  snowpark!  3  [5, 6]

-- Example 31472
>>> _ = session.file.put(f'{temp_dir_name}/snowpark_pandas2.json', '@mytempstage/myprefix')
>>> df4 = pd.read_json('@mytempstage/myprefix')
>>> df4
           A  B       C
0  snowpark!  3  [5, 6]
1  snowpark!  3  [5, 6]

-- Example 31473
>>> import pandas as native_pd
>>> import tempfile
>>> temp_dir = tempfile.TemporaryDirectory()
>>> temp_dir_name = temp_dir.name

-- Example 31474
>>> df = native_pd.DataFrame(
...     {"foo": range(3), "bar": range(5, 8)}
...    )
>>> df
   foo  bar
0    0    5
1    1    6
2    2    7

-- Example 31475
>>> _ = df.to_parquet(f'{temp_dir_name}/snowpark-pandas.parquet')
>>> restored_df = pd.read_parquet(f'{temp_dir_name}/snowpark-pandas.parquet')
>>> restored_df
   foo  bar
0    0    5
1    1    6
2    2    7

-- Example 31476
>>> restored_bar = pd.read_parquet(f'{temp_dir_name}/snowpark-pandas.parquet', columns=["bar"])
>>> restored_bar
   bar
0    5
1    6
2    7

-- Example 31477
>>> _ = session.sql("create or replace temp stage mytempstage").collect()
>>> _ = session.file.put(f'{temp_dir_name}/snowpark-pandas.parquet', '@mytempstage/myprefix')
>>> df2 = pd.read_parquet('@mytempstage/myprefix/snowpark-pandas.parquet')
>>> df2
   foo  bar
0    0    5
1    1    6
2    2    7

-- Example 31478
>>> _ = df.to_parquet(f'{temp_dir_name}/snowpark-pandas2.parquet')
>>> df3 = pd.read_parquet(f'{temp_dir_name}')
>>> df3
   foo  bar
0    0    5
1    1    6
2    2    7
3    0    5
4    1    6
5    2    7

-- Example 31479
>>> _ = session.file.put(f'{temp_dir_name}/snowpark-pandas2.parquet', '@mytempstage/myprefix')
>>> df3 = pd.read_parquet('@mytempstage/myprefix')
>>> df3
   foo  bar
0    0    5
1    1    6
2    2    7
3    0    5
4    1    6
5    2    7

-- Example 31480
>>> df = pd.read_sas("sas_data.sas7bdat")

-- Example 31481
>>> original_df = pd.DataFrame(
...     {"foo": range(5), "bar": range(5, 10)}
... )
>>> original_df
   foo  bar
0    0    5
1    1    6
2    2    7
3    3    8
4    4    9
>>> pd.to_pickle(original_df, "./dummy.pkl")

-- Example 31482
>>> unpickled_df = pd.read_pickle("./dummy.pkl")  
>>> unpickled_df  
   foo  bar
0    0    5
1    1    6
2    2    7
3    3    8
4    4    9

-- Example 31483
<root>
    <row>
      <column1>data</column1>
      <column2>data</column2>
      <column3>data</column3>
      ...
   </row>
   <row>
      ...
   </row>
   ...
</root>

-- Example 31484
>>> from io import StringIO
>>> xml = '''<?xml version='1.0' encoding='utf-8'?>
... <data xmlns="http://example.com">
... <row>
... <shape>square</shape>
... <degrees>360</degrees>
... <sides>4.0</sides>
... </row>
... <row>
... <shape>circle</shape>
... <degrees>360</degrees>
... <sides/>
... </row>
... <row>
... <shape>triangle</shape>
... <degrees>180</degrees>
... <sides>3.0</sides>
... </row>
... </data>'''

-- Example 31485
>>> df = pd.read_xml(StringIO(xml))
>>> df
      shape  degrees  sides
0    square      360    4.0
1    circle      360    NaN
2  triangle      180    3.0

-- Example 31486
>>> xml = '''<?xml version='1.0' encoding='utf-8'?>
... <data>
... <row shape="square" degrees="360" sides="4.0"/>
... <row shape="circle" degrees="360"/>
... <row shape="triangle" degrees="180" sides="3.0"/>
... </data>'''

-- Example 31487
>>> df = pd.read_xml(StringIO(xml), xpath=".//row")
>>> df
      shape  degrees  sides
0    square      360    4.0
1    circle      360    NaN
2  triangle      180    3.0

-- Example 31488
>>> xml = '''<?xml version='1.0' encoding='utf-8'?>
... <doc:data xmlns:doc="https://example.com">
... <doc:row>
...     <doc:shape>square</doc:shape>
...     <doc:degrees>360</doc:degrees>
...     <doc:sides>4.0</doc:sides>
... </doc:row>
... <doc:row>
...     <doc:shape>circle</doc:shape>
...     <doc:degrees>360</doc:degrees>
...     <doc:sides/>
... </doc:row>
... <doc:row>
...     <doc:shape>triangle</doc:shape>
...     <doc:degrees>180</doc:degrees>
...     <doc:sides>3.0</doc:sides>
... </doc:row>
... </doc:data>'''

-- Example 31489
>>> df = pd.read_xml(
...     StringIO(xml),
...     xpath="//doc:row",
...     namespaces={"doc": "https://example.com"},
... )
>>> df
      shape  degrees  sides
0    square      360    4.0
1    circle      360    NaN
2  triangle      180    3.0

-- Example 31490
>>> xml_data = '''
...         <data>
...         <row>
...             <index>0</index>
...             <a>1</a>
...             <b>2.5</b>
...             <c>True</c>
...             <d>a</d>
...             <e>2019-12-31 00:00:00</e>
...         </row>
...         <row>
...             <index>1</index>
...             <b>4.5</b>
...             <c>False</c>
...             <d>b</d>
...             <e>2019-12-31 00:00:00</e>
...         </row>
...         </data>
...         '''

-- Example 31491
>>> df = pd.read_xml(
...     StringIO(xml_data), dtype_backend="numpy_nullable", parse_dates=["e"]
... )
>>> df
   index    a    b      c  d          e
0      0  1.0  2.5   True  a 2019-12-31
1      1  NaN  4.5  False  b 2019-12-31

-- Example 31492
>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]})
>>> df
   Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0
>>> snowpark_df = pd.to_snowpark(df, index_label='Order')
>>> snowpark_df.order_by('"Max Speed"').show()
------------------------------------
|"Order"  |"Animal"  |"Max Speed"  |
------------------------------------
|2        |Parrot    |24.0         |
|3        |Parrot    |26.0         |
|1        |Falcon    |370.0        |
|0        |Falcon    |380.0        |
------------------------------------

>>> snowpark_df = pd.to_snowpark(df, index=False)
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
>>> snowpark_df = pd.to_snowpark(df)
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
>>> snowpark_df = pd.to_snowpark(df, index=True, index_label=['A', 'B'])
>>> snowpark_df.order_by('"A"', '"B"').show()
----------------------------------------
|"A"  |"B"    |"Animal"  |"Max Speed"  |
----------------------------------------
|bar  |one    |Falcon    |380.0        |
|bar  |two    |Parrot    |24.0         |
|foo  |one    |Falcon    |370.0        |
|foo  |three  |Parrot    |26.0         |
----------------------------------------

>>> snowpark_df = pd.to_snowpark(df, index=False)
>>> snowpark_df.order_by('"Max Speed"').show()
--------------------------
|"Animal"  |"Max Speed"  |
--------------------------
|Parrot    |24.0         |
|Parrot    |26.0         |
|Falcon    |370.0        |
|Falcon    |380.0        |
--------------------------

>>> snowpark_df = pd.to_snowpark(df["Animal"], index=False)
>>> snowpark_df.order_by('"Animal"').show()
------------
|"Animal"  |
------------
|Falcon    |
|Falcon    |
|Parrot    |
|Parrot    |
------------

-- Example 31493
>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]})
>>> pd.to_pandas(df)
   Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0

-- Example 31494
>>> pd.to_pandas(df['Animal'])
0    Falcon
1    Falcon
2    Parrot
3    Parrot
Name: Animal, dtype: object

-- Example 31495
>>> df = pd.DataFrame({'A': {0: 'a', 1: 'b', 2: 'c'},
...           'B': {0: 1, 1: 3, 2: 5},
...           'C': {0: 2, 1: 4, 2: 6}})

-- Example 31496
>>> pd.melt(df)
  variable value
0        A     a
1        A     b
2        A     c
3        B     1
4        B     3
5        B     5
6        C     2
7        C     4
8        C     6

-- Example 31497
>>> df = pd.DataFrame({'A': {0: 'a', 1: 'b', 2: 'c'},
...           'B': {0: 1, 1: 3, 2: 5},
...           'C': {0: 2, 1: 4, 2: 6}})
>>> pd.melt(df, id_vars=['A'], value_vars=['B'], var_name='myVarname', value_name='myValname')
   A myVarname  myValname
0  a         B          1
1  b         B          3
2  c         B          5

-- Example 31498
>>> a = np.array(["foo", "foo", "foo", "foo", "bar", "bar",
...               "bar", "bar", "foo", "foo", "foo"], dtype=object)
>>> b = np.array(["one", "one", "one", "two", "one", "one",
...               "one", "two", "two", "two", "one"], dtype=object)
>>> c = np.array(["dull", "dull", "shiny", "dull", "dull", "shiny",
...               "shiny", "dull", "shiny", "shiny", "shiny"],
...              dtype=object)
>>> pd.crosstab(a, [b, c], rownames=['a'], colnames=['b', 'c']) 
b    one        two
c   dull shiny dull shiny
a
bar    1     2    1     0
foo    2     2    1     2

-- Example 31499
>>> df = pd.DataFrame({'foo': ['one', 'one', 'one', 'two', 'two',
...                   'two'],
...           'bar': ['A', 'B', 'C', 'A', 'B', 'C'],
...           'baz': [1, 2, 3, 4, 5, 6],
...           'zoo': ['x', 'y', 'z', 'q', 'w', 't']})
>>> df
   foo bar  baz zoo
0  one   A    1   x
1  one   B    2   y
2  one   C    3   z
3  two   A    4   q
4  two   B    5   w
5  two   C    6   t
>>> pd.pivot(data=df, index='foo', columns='bar', values='baz')  
bar  A  B  C
foo
one  1  2  3
two  4  5  6
>>> pd.pivot(data=df, index='foo', columns='bar')['baz']  
bar  A  B  C
foo
one  1  2  3
two  4  5  6
>>> pd.pivot(data=df, index='foo', columns='bar', values=['baz', 'zoo'])  
    baz       zoo
bar   A  B  C   A  B  C
foo
one   1  2  3   x  y  z
two   4  5  6   q  w  t
>>> df = pd.DataFrame({
...     "lev1": [1, 1, 1, 2, 2, 2],
...     "lev2": [1, 1, 2, 1, 1, 2],
...     "lev3": [1, 2, 1, 2, 1, 2],
...     "lev4": [1, 2, 3, 4, 5, 6],
...     "values": [0, 1, 2, 3, 4, 5]})
>>> df
   lev1  lev2  lev3  lev4  values
0     1     1     1     1       0
1     1     1     2     2       1
2     1     2     1     3       2
3     2     1     2     4       3
4     2     1     1     5       4
5     2     2     2     6       5
>>> pd.pivot(data=df, index="lev1", columns=["lev2", "lev3"], values="values")  
lev2  1       2
lev3  1  2    1    2
lev1
1     0  1  2.0  NaN
2     4  3  NaN  5.0
>>> pd.pivot(data=df, index=["lev1", "lev2"], columns=["lev3"], values="values")  
lev3         1    2
lev1 lev2
1    1     0.0  1.0
     2     2.0  NaN
2    1     4.0  3.0
     2     NaN  5.0

-- Example 31500
>>> df = pd.DataFrame({"A": ["foo", "foo", "foo", "foo", "foo",
...                          "bar", "bar", "bar", "bar"],
...                    "B": ["one", "one", "one", "two", "two",
...                          "one", "one", "two", "two"],
...                    "C": ["small", "large", "large", "small",
...                          "small", "large", "small", "small",
...                          "large"],
...                    "D": [1, 2, 2, 3, 3, 4, 5, 6, 7],
...                    "E": [2, 4, 5, 5, 6, 6, 8, 9, 9]})
>>> df
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

-- Example 31501
>>> table = pd.pivot_table(df, values='D', index=['A', 'B'],
...                        columns=['C'], aggfunc="sum")
>>> table  
C        large  small
A   B
bar one    4.0      5
    two    7.0      6
foo one    4.0      1
    two    NaN      6

-- Example 31502
>>> table = pd.pivot_table(df, values='D', index=['A', 'B'],
...                        columns=['C'], aggfunc="sum", fill_value=0)
>>> table  
C        large  small
A   B
bar one    4.0      5
    two    7.0      6
foo one    4.0      1
    two    NaN      6

-- Example 31503
>>> table = pd.pivot_table(df, values=['D', 'E'], index=['A', 'C'],
...                        aggfunc={'D': "mean", 'E': "mean"})
>>> table  
                  D         E
                  D         E
A   C
bar large  5.500000  7.500000
    small  5.500000  8.500000
foo large  2.000000  4.500000
    small  2.333333  4.333333

-- Example 31504
>>> table = pd.pivot_table(df, values=['D', 'E'], index=['A', 'C'],
...                        aggfunc={'D': "mean",
...                                 'E': ["min", "max", "mean"]})
>>> table  
                  D   E
               mean max      mean min
                  D   E         E   E
A   C
bar large  5.500000   9  7.500000   6
    small  5.500000   9  8.500000   8
foo large  2.000000   5  4.500000   4
    small  2.333333   6  4.333333   2

-- Example 31505
>>> pd.cut(np.array([1, 7, 5, 4, 6, 3]), 3, labels=False)
... 
array([0, 2, 1, 1, 2, 0])

-- Example 31506
>>> pd.cut([0, 1, 1, 2], bins=4, labels=False)
array([0, 1, 1, 3])

-- Example 31507
>>> s = pd.Series(np.array([2, 4, 6, 8, 10]),
...               index=['a', 'b', 'c', 'd', 'e'])
>>> pd.cut(s, 3, labels=False)
... 
a    0
b    0
c    1
d    2
e    2
dtype: int64

-- Example 31508
>>> s1 = pd.Series(['a', 'b'])
>>> s2 = pd.Series(['c', 'd'])
>>> pd.concat([s1, s2])
0    a
1    b
0    c
1    d
dtype: object

-- Example 31509
>>> pd.concat([s1, s2], ignore_index=True)
0    a
1    b
2    c
3    d
dtype: object

-- Example 31510
>>> pd.concat([s1, s2], keys=['s1', 's2'])
s1  0    a
    1    b
s2  0    c
    1    d
dtype: object

-- Example 31511
>>> pd.concat([s1, s2], keys=['s1', 's2'],
...           names=['Series name', 'Row ID'])
Series name  Row ID
s1           0         a
             1         b
s2           0         c
             1         d
dtype: object

-- Example 31512
>>> df1 = pd.DataFrame([['a', 1], ['b', 2]],
...                    columns=['letter', 'number'])
>>> df1
  letter  number
0      a       1
1      b       2
>>> df2 = pd.DataFrame([['c', 3], ['d', 4]],
...                    columns=['letter', 'number'])
>>> df2
  letter  number
0      c       3
1      d       4
>>> pd.concat([df1, df2])
  letter  number
0      a       1
1      b       2
0      c       3
1      d       4

-- Example 31513
>>> df3 = pd.DataFrame([['c', 3, 'cat'], ['d', 4, 'dog']],
...                    columns=['letter', 'number', 'animal'])
>>> df3
  letter  number animal
0      c       3    cat
1      d       4    dog
>>> pd.concat([df1, df3], sort=False)
  letter  number animal
0      a       1   None
1      b       2   None
0      c       3    cat
1      d       4    dog

-- Example 31514
>>> pd.concat([df1, df3], join="inner")
  letter  number
0      a       1
1      b       2
0      c       3
1      d       4

-- Example 31515
>>> df4 = pd.DataFrame([['bird', 'polly'], ['monkey', 'george']],
...                    columns=['animal', 'name'])
>>> pd.concat([df1, df4], axis=1)
  letter  number  animal    name
0      a       1    bird   polly
1      b       2  monkey  george

-- Example 31516
>>> pd.concat([s1, s2], axis=1)
   0  1
0  a  c
1  b  d

-- Example 31517
>>> pd.concat([df1, df4], axis=1, ignore_index=True)
   0  1       2       3
0  a  1    bird   polly
1  b  2  monkey  george

-- Example 31518
>>> pd.concat([df1, df4], axis=1, keys=['x', 'y']) 
       x              y
  letter number  animal    name
0      a      1    bird   polly
1      b      2  monkey  george

-- Example 31519
>>> pd.concat([s1, s2], axis=1, keys=['x', 'y'])
   x  y
0  a  c
1  b  d

-- Example 31520
>>> df5 = pd.DataFrame([['a', 1], ['b', 2]],
...                    columns=['letter', 'number'],
...                    index=[1, 2])
>>> df5
  letter  number
1      a       1
2      b       2
>>> pd.concat([df1, df5], axis=1, join='inner')
  letter  number letter  number
1      b       2      a       1

-- Example 31521
>>> df5 = pd.DataFrame([1], index=['a'])
>>> df5
   0
a  1
>>> df6 = pd.DataFrame([2], index=['a'])
>>> df6
   0
a  2
>>> pd.concat([df5, df6], verify_integrity=True)
Traceback (most recent call last):
    ...
ValueError: Indexes have overlapping values: Index(['a'], dtype='object')

-- Example 31522
>>> df7 = pd.DataFrame({'a': 1, 'b': 2}, index=[0])
>>> df7
   a  b
0  1  2
>>> new_row = pd.DataFrame({'a': 3, 'b': 4}, index=[0])
>>> new_row
   a  b
0  3  4
>>> pd.concat([df7, new_row], ignore_index=True)
   a  b
0  1  2
1  3  4

-- Example 31523
>>> s = pd.Series(list('abca'))

-- Example 31524
>>> pd.get_dummies(s)
       a      b      c
0   True  False  False
1  False   True  False
2  False  False   True
3   True  False  False

-- Example 31525
>>> df = pd.DataFrame({'A': ['a', 'b', 'a'], 'B': ['b', 'a', 'c'],
...                    'C': [1, 2, 3]})

-- Example 31526
>>> pd.get_dummies(df, prefix=['col1', 'col2'])
   C  col1_a  col1_b  col2_a  col2_b  col2_c
0  1    True   False   False    True   False
1  2   False    True    True   False   False
2  3    True   False   False   False    True

-- Example 31527
>>> pd.get_dummies(pd.Series(list('abcaa')))
       a      b      c
0   True  False  False
1  False   True  False
2  False  False   True
3   True  False  False
4   True  False  False

-- Example 31528
>>> df1 = pd.DataFrame({'lkey': ['foo', 'bar', 'baz', 'foo'],
...                     'value': [1, 2, 3, 5]})
>>> df2 = pd.DataFrame({'rkey': ['foo', 'bar', 'baz', 'foo'],
...                     'value': [5, 6, 7, 8]})
>>> df1
  lkey  value
0  foo      1
1  bar      2
2  baz      3
3  foo      5
>>> df2
  rkey  value
0  foo      5
1  bar      6
2  baz      7
3  foo      8

