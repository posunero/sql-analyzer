-- Example 32400
>>> s = pd.Series([0, 1, 2, 3])
>>> s.expanding().sem()
0         NaN
1    0.707107
2    0.707107
3    0.745356
dtype: float64

-- Example 32401
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).std()
          B
0       NaN
1  0.707107
2  1.000000
3  1.000000
4  1.707825

-- Example 32402
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).sum()
     B
0  NaN
1  1.0
2  3.0
3  3.0
4  7.0

-- Example 32403
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.expanding(2).var()
          B
0       NaN
1  0.500000
2  1.000000
3  1.000000
4  2.916667

-- Example 32404
>>> df1 = pd.DataFrame({"col1": [1, 4, 3]})
>>> df2 = pd.DataFrame({"col1": [1, 6, 3]})
>>> df1.rolling(window=3, min_periods=3).corr(other=df2,pairwise=None, numeric_only=True)
       col1
0       NaN
1       NaN
2  0.953821

-- Example 32405
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).count()
   B
0  1
1  2
2  2
3  1
4  1
>>> df.rolling(2, min_periods=2).count()
     B
0  NaN
1  2.0
2  2.0
3  1.0
4  1.0
>>> df.rolling(3, min_periods=1, center=True).count()
   B
0  2
1  3
2  2
3  2
4  1

-- Example 32406
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).max()
     B
0  0.0
1  1.0
2  2.0
3  2.0
4  4.0

-- Example 32407
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).mean()
     B
0  0.0
1  0.5
2  1.5
3  2.0
4  4.0
>>> df.rolling(2, min_periods=2).mean()
     B
0  NaN
1  0.5
2  1.5
3  NaN
4  NaN
>>> df.rolling(3, min_periods=1, center=True).mean()
     B
0  0.5
1  1.0
2  1.5
3  3.0
4  4.0

-- Example 32408
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).min()
     B
0  0.0
1  0.0
2  1.0
3  2.0
4  4.0

-- Example 32409
>>> s = pd.Series([0, 1, 2, 3])
>>> s.rolling(2, min_periods=1).sem()
0         NaN
1    0.707107
2    0.707107
3    0.707107
dtype: float64

-- Example 32410
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).std()
          B
0       NaN
1  0.707107
2  0.707107
3       NaN
4       NaN
>>> df.rolling(2, min_periods=1).std(ddof=0)
     B
0  0.0
1  0.5
2  0.5
3  0.0
4  0.0
>>> df.rolling(3, min_periods=1, center=True).std()
          B
0  0.707107
1  1.000000
2  0.707107
3  1.414214
4       NaN

-- Example 32411
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).sum()
     B
0  0.0
1  1.0
2  3.0
3  2.0
4  4.0
>>> df.rolling(2, min_periods=2).sum()
     B
0  NaN
1  1.0
2  3.0
3  NaN
4  NaN
>>> df.rolling(3, min_periods=1, center=True).sum()
     B
0  1.0
1  3.0
2  3.0
3  6.0
4  4.0

-- Example 32412
>>> df = pd.DataFrame({'B': [0, 1, 2, np.nan, 4]})
>>> df
     B
0  0.0
1  1.0
2  2.0
3  NaN
4  4.0
>>> df.rolling(2, min_periods=1).var()
     B
0  NaN
1  0.5
2  0.5
3  NaN
4  NaN
>>> df.rolling(2, min_periods=1).var(ddof=0)
      B
0  0.00
1  0.25
2  0.25
3  0.00
4  0.00
>>> df.rolling(3, min_periods=1, center=True).var()
     B
0  0.5
1  1.0
2  0.5
3  2.0
4  NaN

-- Example 32413
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([1, 2, 3], index=lst)
>>> ser
a    1
a    2
b    3
dtype: int64
>>> for x, y in ser.groupby(level=0):
...     print(f'{x}\n{y}\n')
a
a    1
a    2
dtype: int64

b
b    3
dtype: int64

-- Example 32414
>>> data = [[1, 2, 3], [1, 5, 6], [7, 8, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"])
>>> df
   a  b  c
0  1  2  3
1  1  5  6
2  7  8  9
>>> for x, y in df.groupby(by=["a"]):
...     print(f'{x}\n{y}\n')
(1,)
   a  b  c
0  1  2  3
1  1  5  6

(7,)
   a  b  c
2  7  8  9

-- Example 32415
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([1, 2, 3], index=lst)
>>> ser
a    1
a    2
b    3
dtype: int64
>>> for x, y in ser.groupby(level=0):
...     print(f'{x}\n{y}\n')
a
a    1
a    2
dtype: int64

b
b    3
dtype: int64

-- Example 32416
>>> data = [[1, 2, 3], [1, 5, 6], [7, 8, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"])
>>> df
   a  b  c
0  1  2  3
1  1  5  6
2  7  8  9
>>> for x, y in df.groupby(by=["a"]):
...     print(f'{x}\n{y}\n')
(1,)
   a  b  c
0  1  2  3
1  1  5  6

(7,)
   a  b  c
2  7  8  9

-- Example 32417
>>> df = pd.DataFrame({'A': [1, 1, 2, 1, 2],
...                    'B': [np.nan, 2, 3, 4, 5],
...                    'C': [1, 2, 1, 1, 2]})

-- Example 32418
>>> df.groupby('A').indices
{1: array([0, 1, 3]), 2: array([2, 4])}

-- Example 32419
>>> df.set_index('B').groupby('A').indices
{1: array([0, 1, 3]), 2: array([2, 4])}

-- Example 32420
>>> df = pd.DataFrame({'A': [1, 1, 2, 1, 2],
...                    'B': [np.nan, 2, 3, 4, 5],
...                    'C': [1, 2, 1, 1, 2]})

-- Example 32421
>>> df.groupby('A').indices
{1: array([0, 1, 3]), 2: array([2, 4])}

-- Example 32422
>>> df.set_index('B').groupby('A').indices
{1: array([0, 1, 3]), 2: array([2, 4])}

-- Example 32423
>>> df = pd.DataFrame({'A': 'a a b'.split(),
...                    'B': [1,2,3],
...                    'C': [4,6,5]})
>>> g1 = df.groupby('A', group_keys=False)
>>> g2 = df.groupby('A', group_keys=True)

-- Example 32424
>>> g1[['B', 'C']].apply(lambda x: x.select_dtypes('number') / x.select_dtypes('number').sum())
          B    C
0  0.333333  0.4
1  0.666667  0.6
2  1.000000  1.0

-- Example 32425
>>> g2[['B', 'C']].apply(lambda x: x.select_dtypes('number') / x.select_dtypes('number').sum()) 
            B    C
A
a 0  0.333333  0.4
  1  0.666667  0.6
b 2  1.000000  1.0

-- Example 32426
>>> df = pd.DataFrame(
...     {
...         "A": [1, 1, 2, 2],
...         "B": [1, 2, 3, 4],
...         "C": [0.362838, 0.227877, 1.267767, -0.562860],
...     }
... )

-- Example 32427
>>> df
   A  B         C
0  1  1  0.362838
1  1  2  0.227877
2  2  3  1.267767
3  2  4 -0.562860

-- Example 32428
>>> df.groupby('A').agg('min')  
    B         C
A
1  1  0.227877
2  3 -0.562860

-- Example 32429
>>> df.groupby('A').agg(['min', 'max']) 
    B             C
    min max       min       max
A
1   1   2  0.227877  0.362838
2   3   4 -0.562860  1.267767

-- Example 32430
>>> df.groupby('A').B.agg(['min', 'max'])   
    min  max
A
1    1    2
2    3    4

-- Example 32431
>>> df.groupby('A').agg({'B': ['min', 'max'], 'C': 'sum'})  
    B             C
    min max       sum
A
1   1   2  0.590715
2   3   4  0.704907

-- Example 32432
>>> s = pd.Series([1, 2, 3, 4], index=pd.Index([1, 2, 1, 2]))

-- Example 32433
>>> s
1    1
2    2
1    3
2    4
dtype: int64

-- Example 32434
>>> s.groupby(level=0).agg('min')
1    1
2    2
dtype: int64

-- Example 32435
>>> s.groupby(level=0).agg(['min', 'max'])
   min  max
1    1    3
2    2    4

-- Example 32436
>>> df = pd.DataFrame(
...     {
...         "A": [1, 1, 2, 2],
...         "B": [1, 2, 3, 4],
...         "C": [0.362838, 0.227877, 1.267767, -0.562860],
...     }
... )

-- Example 32437
>>> df
   A  B         C
0  1  1  0.362838
1  1  2  0.227877
2  2  3  1.267767
3  2  4 -0.562860

-- Example 32438
>>> df.groupby('A').agg('min')  
    B         C
A
1  1  0.227877
2  3 -0.562860

-- Example 32439
>>> df.groupby('A').agg(['min', 'max']) 
    B             C
    min max       min       max
A
1   1   2  0.227877  0.362838
2   3   4 -0.562860  1.267767

-- Example 32440
>>> df.groupby('A').B.agg(['min', 'max'])   
    min  max
A
1    1    2
2    3    4

-- Example 32441
>>> df.groupby('A').agg({'B': ['min', 'max'], 'C': 'sum'})  
    B             C
    min max       sum
A
1   1   2  0.590715
2   3   4  0.704907

-- Example 32442
>>> s = pd.Series([1, 2, 3, 4], index=pd.Index([1, 2, 1, 2]))

-- Example 32443
>>> s
1    1
2    2
1    3
2    4
dtype: int64

-- Example 32444
>>> s.groupby(level=0).agg('min')
1    1
2    2
dtype: int64

-- Example 32445
>>> s.groupby(level=0).agg(['min', 'max'])
   min  max
1    1    3
2    2    4

-- Example 32446
>>> df = pd.DataFrame(
...     {
...         "col1": ["Z", None, "X", "Z", "Y", "X", "X", None, "X", "Y"],
...         "col2": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
...         "col3": [40, 50, 60, 10, 20, 30, 40, 80, 90, 10],
...         "col4": [-1, -2, -3, -4, -5, -6, -7, -8, -9, -10],
...     },
...     index=list("abcdefghij")
... )
>>> df
   col1  col2  col3  col4
a     Z     1    40    -1
b  None     2    50    -2
c     X     3    60    -3
d     Z     4    10    -4
e     Y     5    20    -5
f     X     6    30    -6
g     X     7    40    -7
h  None     8    80    -8
i     X     9    90    -9
j     Y    10    10   -10

-- Example 32447
>>> df.groupby("col1", dropna=True).transform(lambda df, n: df.head(n), n=2)
   col2  col3  col4
a   1.0  40.0  -1.0
b   NaN   NaN   NaN
c   3.0  60.0  -3.0
d   4.0  10.0  -4.0
e   5.0  20.0  -5.0
f   6.0  30.0  -6.0
g   NaN   NaN   NaN
h   NaN   NaN   NaN
i   NaN   NaN   NaN
j  10.0  10.0 -10.0

-- Example 32448
>>> df.groupby("col1", dropna=False).transform("mean")
   col2  col3  col4
a  2.50  25.0 -2.50
b  5.00  65.0 -5.00
c  6.25  55.0 -6.25
d  2.50  25.0 -2.50
e  7.50  15.0 -7.50
f  6.25  55.0 -6.25
g  6.25  55.0 -6.25
h  5.00  65.0 -5.00
i  6.25  55.0 -6.25
j  7.50  15.0 -7.50

-- Example 32449
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([1, 2, 0], index=lst)
>>> ser  
a    1
a    2
b    0
dtype: int64
>>> ser.groupby(level=0).all()  
a     True
b    False
dtype: bool

-- Example 32450
>>> data = [[1, 0, 3], [1, 5, 6], [7, 8, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["ostrich", "penguin", "parrot"])
>>> df  
         a  b  c
ostrich  1  0  3
penguin  1  5  6
parrot   7  8  9
>>> df.groupby(by=["a"]).all()  
       b      c
a
1  False   True
7   True   True

-- Example 32451
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([1, 2, 0], index=lst)
>>> ser  
a    1
a    2
b    0
dtype: int64
>>> ser.groupby(level=0).any()  
a     True
b    False
dtype: bool

-- Example 32452
>>> data = [[1, 0, 3], [1, 0, 6], [7, 1, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["ostrich", "penguin", "parrot"])
>>> df  
         a  b  c
ostrich  1  0  3
penguin  1  0  6
parrot   7  1  9
>>> df.groupby(by=["a"]).any()  
       b      c
a
1  False   True
7   True   True

-- Example 32453
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([1, 2, np.nan], index=lst)
>>> ser
a    1.0
a    2.0
b    NaN
dtype: float64
>>> ser.groupby(level=0).count()
a    2
b    0
dtype: int64

-- Example 32454
>>> data = [[1, np.nan, 3], [1, np.nan, 6], [7, 8, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["cow", "horse", "bull"])
>>> df
       a    b  c
cow    1  NaN  3
horse  1  NaN  6
bull   7  8.0  9
>>> df.groupby("a").count()     
   b  c
a
1  0  2
7  1  1

-- Example 32455
self.apply(lambda x: pd.Series(np.arange(len(x)), x.index))

-- Example 32456
>>> df = pd.DataFrame([['a'], ['a'], ['a'], ['b'], ['b'], ['a']],
...                   columns=['A'])
>>> df
   A
0  a
1  a
2  a
3  b
4  b
5  a

-- Example 32457
>>> df.groupby('A').cumcount()
0    0
1    1
2    2
3    0
4    1
5    3
dtype: int64

-- Example 32458
>>> df.groupby('A').cumcount(ascending=False)
0    3
1    2
2    1
3    1
4    0
5    0
dtype: int64

-- Example 32459
>>> lst = ['a', 'a', 'a', 'b', 'b', 'b']
>>> ser = pd.Series([1, 6, 2, 3, 1, 4], index=lst)
>>> ser
a    1
a    6
a    2
b    3
b    1
b    4
dtype: int64
>>> ser.groupby(level=0).cummax()
a    1
a    6
a    6
b    3
b    3
b    4
dtype: int64

-- Example 32460
>>> data = [[1, 8, 2], [1, 1, 0], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["cow", "horse", "bull"])
>>> df
       a  b  c
cow    1  8  2
horse  1  1  0
bull   2  6  9
>>> df.groupby("a").groups
{1: ['cow', 'horse'], 2: ['bull']}
>>> df.groupby("a").cummax()
       b  c
cow    8  2
horse  8  2
bull   6  9

-- Example 32461
>>> lst = ['a', 'a', 'a', 'b', 'b', 'b']
>>> ser = pd.Series([1, 6, 2, 3, 0, 4], index=lst)
>>> ser
a    1
a    6
a    2
b    3
b    0
b    4
dtype: int64
>>> ser.groupby(level=0).cummin()
a    1
a    1
a    1
b    3
b    0
b    0
dtype: int64

-- Example 32462
>>> data = [[1, 0, 2], [1, 1, 5], [6, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["snake", "rabbit", "turtle"])
>>> df
        a  b  c
snake   1  0  2
rabbit  1  1  5
turtle  6  6  9
>>> df.groupby("a").groups
{1: ['snake', 'rabbit'], 6: ['turtle']}
>>> df.groupby("a").cummin()
        b  c
snake   0  2
rabbit  0  2
turtle  6  9

-- Example 32463
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([6, 2, 0], index=lst)
>>> ser
a    6
a    2
b    0
dtype: int64

-- Example 32464
>>> ser.groupby(level=0).cumsum()
a    6
a    8
b    0
dtype: int64

-- Example 32465
>>> data = [[1, 8, 2], [1, 2, 5], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["fox", "gorilla", "lion"])
>>> df
         a  b  c
fox      1  8  2
gorilla  1  2  5
lion     2  6  9

-- Example 32466
>>> df.groupby("a").groups
{1: ['fox', 'gorilla'], 2: ['lion']}

