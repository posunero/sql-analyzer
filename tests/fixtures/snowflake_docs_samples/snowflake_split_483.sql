-- Example 32333
>>> df.sort_values(by='col1', ascending=False)
   col1  col2  col3 col4
4     D     7     2    e
5     C     4     3    F
2     B     9     9    c
0     A     2     0    a
1     A     1     1    B
3  None     8     4    D

-- Example 32334
>>> df.sort_values(by='col1', ascending=False, na_position='first')
   col1  col2  col3 col4
3  None     8     4    D
4     D     7     2    e
5     C     4     3    F
2     B     9     9    c
0     A     2     0    a
1     A     1     1    B

-- Example 32335
>>> primes = pd.Series([2, 3, 5, 7])

-- Example 32336
>>> even_primes = primes[primes % 2 == 0]   
>>> even_primes  
0    2
dtype: int64

-- Example 32337
>>> even_primes.squeeze()  
2

-- Example 32338
>>> odd_primes = primes[primes % 2 == 1]  
>>> odd_primes  
1    3
2    5
3    7
dtype: int64

-- Example 32339
>>> odd_primes.squeeze()  
1    3
2    5
3    7
dtype: int64

-- Example 32340
>>> df = pd.DataFrame([[1, 2], [3, 4]], columns=['a', 'b'])
>>> df
   a  b
0  1  2
1  3  4

-- Example 32341
>>> df_a = df[['a']]
>>> df_a
   a
0  1
1  3

-- Example 32342
>>> df_a.squeeze('columns')
0    1
1    3
Name: a, dtype: int64

-- Example 32343
>>> df_0a = df.loc[df.index < 1, ['a']]
>>> df_0a
   a
0  1

-- Example 32344
>>> df_0a.squeeze('rows')
a    1
Name: 0, dtype: int64

-- Example 32345
>>> df_0a.squeeze()  
1

-- Example 32346
>>> df_single_level_cols = pd.DataFrame([[0, 1], [2, 3]], index=['cat', 'dog'], columns=['weight', 'height'])
>>> df_single_level_cols
     weight  height
cat       0       1
dog       2       3
>>> df_single_level_cols.stack()
cat  weight    0
     height    1
dog  weight    2
     height    3
dtype: int64

-- Example 32347
>>> d1 = {'col1': [1, 2], 'col2': [3, 4]}
>>> df1 = pd.DataFrame(data=d1)
>>> df1
   col1  col2
0     1     3
1     2     4

-- Example 32348
>>> df1_transposed = df1.T  # or df1.transpose()
>>> df1_transposed
      0  1
col1  1  2
col2  3  4

-- Example 32349
>>> df1.dtypes
col1    int64
col2    int64
dtype: object

-- Example 32350
>>> df1_transposed.dtypes
0    int64
1    int64
dtype: object

-- Example 32351
>>> d2 = {'name': ['Alice', 'Bob'],
...      'score': [9.5, 8],
...      'employed': [False, True],
...       'kids': [0, 0]}
>>> df2 = pd.DataFrame(data=d2)
>>> df2
    name  score  employed  kids
0  Alice    9.5     False     0
1    Bob    8.0      True     0

-- Example 32352
>>> df2_transposed = df2.T  # or df2.transpose()
>>> df2_transposed
              0     1
name      Alice   Bob
score       9.5   8.0
employed  False  True
kids          0     0

-- Example 32353
>>> df2.dtypes
name         object
score       float64
employed       bool
kids          int64
dtype: object

-- Example 32354
>>> df2_transposed.dtypes
0    object
1    object
dtype: object

-- Example 32355
>>> d1 = {'col1': [1, 2], 'col2': [3, 4]}
>>> df1 = pd.DataFrame(data=d1)
>>> df1
   col1  col2
0     1     3
1     2     4

-- Example 32356
>>> df1_transposed = df1.T  # or df1.transpose()
>>> df1_transposed
      0  1
col1  1  2
col2  3  4

-- Example 32357
>>> df1.dtypes
col1    int64
col2    int64
dtype: object

-- Example 32358
>>> df1_transposed.dtypes
0    int64
1    int64
dtype: object

-- Example 32359
>>> d2 = {'name': ['Alice', 'Bob'],
...      'score': [9.5, 8],
...      'employed': [False, True],
...       'kids': [0, 0]}
>>> df2 = pd.DataFrame(data=d2)
>>> df2
    name  score  employed  kids
0  Alice    9.5     False     0
1    Bob    8.0      True     0

-- Example 32360
>>> df2_transposed = df2.T  # or df2.transpose()
>>> df2_transposed
              0     1
name      Alice   Bob
score       9.5   8.0
employed  False  True
kids          0     0

-- Example 32361
>>> df2.dtypes
name         object
score       float64
employed       bool
kids          int64
dtype: object

-- Example 32362
>>> df2_transposed.dtypes
0    object
1    object
dtype: object

-- Example 32363
>>> index = pd.MultiIndex.from_tuples([('one', 'a'), ('one', 'b'),
...                                    ('two', 'a'), ('two', 'b')])
>>> s = pd.Series(np.arange(1.0, 5.0), index=index)
>>> s
one  a    1.0
     b    2.0
two  a    3.0
     b    4.0
dtype: float64
>>> s.unstack(level=-1)
       a    b
one  1.0  2.0
two  3.0  4.0
>>> s.unstack(level=0)
   one  two
a  1.0  3.0
b  2.0  4.0
>>> df = s.unstack(level=0)
>>> df.unstack()
one  a    1.0
     b    2.0
two  a    3.0
     b    4.0
dtype: float64

-- Example 32364
>>> df = pd.DataFrame(
...     {
...         "col1": ["a", "a", "b", "b", "a"],
...         "col2": [1.0, 2.0, 3.0, np.nan, 5.0],
...         "col3": [1.0, 2.0, 3.0, 4.0, 5.0]
...     },
...     columns=["col1", "col2", "col3"],
... )
>>> df
  col1  col2  col3
0    a   1.0   1.0
1    a   2.0   2.0
2    b   3.0   3.0
3    b   NaN   4.0
4    a   5.0   5.0

-- Example 32365
>>> df2 = df.copy()
>>> df2.loc[0, 'col1'] = 'c'
>>> df2.loc[2, 'col3'] = 4.0
>>> df2
  col1  col2  col3
0    c   1.0   1.0
1    a   2.0   2.0
2    b   3.0   4.0
3    b   NaN   4.0
4    a   5.0   5.0

-- Example 32366
>>> df.compare(df2) 
   col1       col3
   self other self other
0     a     c  NaN   NaN
2  None  None  3.0   4.0

-- Example 32367
>>> df = pd.DataFrame({'key': ['K0', 'K1', 'K2', 'K3', 'K4', 'K5'],
...                    'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})

-- Example 32368
>>> df
  key   A
0  K0  A0
1  K1  A1
2  K2  A2
3  K3  A3
4  K4  A4
5  K5  A5

-- Example 32369
>>> other = pd.DataFrame({'key': ['K0', 'K1', 'K2'],
...                       'B': ['B0', 'B1', 'B2']})

-- Example 32370
>>> other
  key   B
0  K0  B0
1  K1  B1
2  K2  B2

-- Example 32371
>>> df.join(other, lsuffix='_caller', rsuffix='_other')
  key_caller   A key_other     B
0         K0  A0        K0    B0
1         K1  A1        K1    B1
2         K2  A2        K2    B2
3         K3  A3      None  None
4         K4  A4      None  None
5         K5  A5      None  None

-- Example 32372
>>> df.set_index('key').join(other.set_index('key'))  
      A     B
key
K0   A0    B0
K1   A1    B1
K2   A2    B2
K3   A3  None
K4   A4  None
K5   A5  None

-- Example 32373
>>> df.join(other.set_index('key'), on='key')
  key   A     B
0  K0  A0    B0
1  K1  A1    B1
2  K2  A2    B2
3  K3  A3  None
4  K4  A4  None
5  K5  A5  None

-- Example 32374
>>> df = pd.DataFrame({'key': ['K0', 'K1', 'K1', 'K3', 'K0', 'K1'],
...                    'A': ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']})

-- Example 32375
>>> df
  key   A
0  K0  A0
1  K1  A1
2  K1  A2
3  K3  A3
4  K0  A4
5  K1  A5

-- Example 32376
>>> df.join(other.set_index('key'), on='key', validate='m:1')  
  key   A    B
0  K0  A0   B0
1  K1  A1   B1
2  K1  A2   B1
3  K3  A3  NaN
4  K0  A4   B0
5  K1  A5   B1

-- Example 32377
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

-- Example 32378
>>> df1.merge(df2, left_on='lkey', right_on='rkey')
  lkey  value_x rkey  value_y
0  foo        1  foo        5
1  foo        1  foo        8
2  bar        2  bar        6
3  baz        3  baz        7
4  foo        5  foo        5
5  foo        5  foo        8

-- Example 32379
>>> df1.merge(df2, left_on='lkey', right_on='rkey',
...           suffixes=('_left', '_right'))
  lkey  value_left rkey  value_right
0  foo           1  foo            5
1  foo           1  foo            8
2  bar           2  bar            6
3  baz           3  baz            7
4  foo           5  foo            5
5  foo           5  foo            8

-- Example 32380
>>> df1 = pd.DataFrame({'a': ['foo', 'bar'], 'b': [1, 2]})
>>> df2 = pd.DataFrame({'a': ['foo', 'baz'], 'c': [3, 4]})
>>> df1
     a  b
0  foo  1
1  bar  2
>>> df2
     a  c
0  foo  3
1  baz  4

-- Example 32381
>>> df1.merge(df2, how='inner', on='a')
     a  b  c
0  foo  1  3

-- Example 32382
>>> df1.merge(df2, how='left', on='a')
     a  b    c
0  foo  1  3.0
1  bar  2  NaN

-- Example 32383
>>> df1 = pd.DataFrame({'left': ['foo', 'bar']})
>>> df2 = pd.DataFrame({'right': [7, 8]})
>>> df1
  left
0  foo
1  bar
>>> df2
   right
0      7
1      8

-- Example 32384
>>> df1.merge(df2, how='cross')
  left  right
0  foo      7
1  foo      8
2  bar      7
3  bar      8

-- Example 32385
>>> df = pd.DataFrame({"Col1": [10, 20, 15, 30, 45],
...                    "Col2": [13, 23, 18, 33, 48],
...                    "Col3": [17, 27, 22, 37, 52]},
...                   index=pd.date_range("2020-01-01", "2020-01-05"))
>>> df
            Col1  Col2  Col3
2020-01-01    10    13    17
2020-01-02    20    23    27
2020-01-03    15    18    22
2020-01-04    30    33    37
2020-01-05    45    48    52

-- Example 32386
>>> df.shift(periods=3)
            Col1  Col2  Col3
2020-01-01   NaN   NaN   NaN
2020-01-02   NaN   NaN   NaN
2020-01-03   NaN   NaN   NaN
2020-01-04  10.0  13.0  17.0
2020-01-05  20.0  23.0  27.0

-- Example 32387
>>> df.shift(periods=1, axis="columns")
            Col1  Col2  Col3
2020-01-01  None    10    13
2020-01-02  None    20    23
2020-01-03  None    15    18
2020-01-04  None    30    33
2020-01-05  None    45    48

-- Example 32388
>>> df.shift(periods=3, fill_value=0)
            Col1  Col2  Col3
2020-01-01     0     0     0
2020-01-02     0     0     0
2020-01-03     0     0     0
2020-01-04    10    13    17
2020-01-05    20    23    27

-- Example 32389
>>> s = pd.Series([None, 3, 4])
>>> s.first_valid_index()
1
>>> s = pd.Series([None, None])
>>> s.first_valid_index()
>>> df = pd.DataFrame({'A': [None, 1, 2, None], 'B': [3, 2, 1, None]}, index=[10, 11, 12, 13])
>>> df
      A    B
10  NaN  3.0
11  1.0  2.0
12  2.0  1.0
13  NaN  NaN
>>> df.first_valid_index()
10
>>> df = pd.DataFrame([5, 6, 7, 8], index=["i", "am", "iron", "man"])
>>> df.first_valid_index()
'i'

-- Example 32390
>>> s = pd.Series([None, 3, 4])
>>> s.last_valid_index()
2
>>> s = pd.Series([None, None])
>>> s.last_valid_index()
>>> df = pd.DataFrame({'A': [None, 1, 2, None], 'B': [3, 2, 1, None]}, index=[10, 11, 12, 13])
>>> df
      A    B
10  NaN  3.0
11  1.0  2.0
12  2.0  1.0
13  NaN  NaN
>>> df.last_valid_index()
12
>>> df = pd.DataFrame([5, 6, 7, 8], index=["i", "am", "iron", "man"])
>>> df.last_valid_index()
'man'

-- Example 32391
>>> index = pd.date_range('1/1/2000', periods=9, freq='min')
>>> series = pd.Series(range(9), index=index)
>>> series
2000-01-01 00:00:00    0
2000-01-01 00:01:00    1
2000-01-01 00:02:00    2
2000-01-01 00:03:00    3
2000-01-01 00:04:00    4
2000-01-01 00:05:00    5
2000-01-01 00:06:00    6
2000-01-01 00:07:00    7
2000-01-01 00:08:00    8
Freq: None, dtype: int64
>>> series.resample('3min').sum()
2000-01-01 00:00:00     3
2000-01-01 00:03:00    12
2000-01-01 00:06:00    21
Freq: None, dtype: int64

-- Example 32392
>>> series = pd.Series(['red', 'green', 'blue'], name='color')
>>> series.to_csv('out.csv', index=False)

-- Example 32393
>>> series.to_csv(index=False)  
>>> compression_opts = dict(method='zip',
...                         archive_name='out.csv')  
>>> series.to_csv('out.zip', index=False,
...           compression=compression_opts)

-- Example 32394
>>> from pathlib import Path  
>>> filepath = Path('folder/subfolder/out.csv')  
>>> filepath.parent.mkdir(parents=True, exist_ok=True)  
>>> df.to_csv(filepath)

-- Example 32395
>>> import os  
>>> os.makedirs('folder/subfolder', exist_ok=True)  
>>> df.to_csv('folder/subfolder/out.csv')

-- Example 32396
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).count()
     B
0  NaN
1  2.0
2  3.0
3  3.0
4  4.0

-- Example 32397
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).max()
     B
0  NaN
1  1.0
2  2.0
3  2.0
4  4.0

-- Example 32398
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).mean()
      B
0   NaN
1  0.50
2  1.00
3  1.00
4  1.75

-- Example 32399
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).min()
     B
0  NaN
1  0.0
2  0.0
3  0.0
4  0.0

