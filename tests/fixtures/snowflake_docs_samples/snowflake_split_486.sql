-- Example 32534
>>> df = pd.DataFrame(
...     data=small_df_data,
...     columns=("species", "speed", "age", "weight", "height"),
...     index=list("abcdefghijklmnopq"),
... )

-- Example 32535
>>> df.groupby("species").idxmax(axis=0, skipna=True)  
             speed age weight height
species
giraffe          k   k      h      k
hippopotamus     l   l      d      l
lion             q   q      q      a
rhino            m   n      n      m
tiger            g   b      e      b

-- Example 32536
>>> df.groupby("species").idxmax(axis=0, skipna=False)  
             speed   age weight height
species
giraffe          k     k      h      k
hippopotamus  None     l      d      l
lion             q  None      q   None
rhino            m     n      n      m
tiger            g     b      e      b

-- Example 32537
>>> small_df_data = [
...        ["lion", 78, 50, 50, 50],
...        ["tiger", -35, 12, -378, 1246],
...        ["giraffe", 54, -9, 67, -256],
...        ["hippopotamus", np.nan, -537, -47, -789],
...        ["tiger", 89, 2, 256, 246],
...        ["tiger", -325, 2, 2, 5],
...        ["tiger", 367, -367, 3, -6],
...        ["giraffe", 25, 6, 312, 6],
...        ["lion", -5, -5, -3, -4],
...        ["lion", 15, np.nan, 2, 12],
...        ["giraffe", 100, 200, 300, 400],
...        ["hippopotamus", -100, -300, -600, -200],
...        ["rhino", 26, 2, -45, 14],
...        ["rhino", -7, 63, 257, -257],
...        ["lion", 1, 2, 3, 4],
...        ["giraffe", -5, -6, -7, 8],
...        ["lion", 1234, 456, 78, np.nan],
... ]

-- Example 32538
>>> df = pd.DataFrame(
...     data=small_df_data,
...     columns=("species", "speed", "age", "weight", "height"),
...     index=list("abcdefghijklmnopq"),
... )

-- Example 32539
>>> df.groupby("species").idxmin(axis=0, skipna=True)  
             speed age weight height
species
giraffe          p   c      p      c
hippopotamus     l   d      l      d
lion             i   i      i      i
rhino            n   m      m      n
tiger            f   g      b      g

-- Example 32540
>>> df.groupby("species").idxmin(axis=0, skipna=False)  
             speed   age weight height
species
giraffe          p     c      p      c
hippopotamus  None     d      l      d
lion             i  None      i   None
rhino            n     m      m      n
tiger            f     g      b      g

-- Example 32541
>>> lst = ['a', 'a', 'b', 'b']
>>> ser = pd.Series([1, 2, 3, 4], index=lst)
>>> ser
a    1
a    2
b    3
b    4
dtype: int64
>>> ser.groupby(level=0).max()
a    2
b    4
dtype: int64

-- Example 32542
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["tiger", "leopard", "cheetah", "lion"])
>>> df
         a  b  c
tiger    1  8  2
leopard  1  2  5
cheetah  2  5  8
lion     2  6  9
>>> df.groupby("a").max()  
   b  c
a
1  8  5
2  6  9

-- Example 32543
>>> df = pd.DataFrame({'A': [1, 1, 2, 1, 2],
...                    'B': [np.nan, 2, 3, 4, 5],
...                    'C': [1, 2, 1, 1, 2]}, columns=['A', 'B', 'C'])

-- Example 32544
>>> df.groupby('A').mean()      
     B         C
A
1  3.0  1.333333
2  4.0  1.500000

-- Example 32545
>>> df.groupby(['A', 'B']).mean()   
         C
A B
1 2.0  2.0
  4.0  1.0
2 3.0  1.0
  5.0  2.0

-- Example 32546
>>> df.groupby('A')['B'].mean()
A
1    3.0
2    4.0
Name: B, dtype: float64

-- Example 32547
>>> lst = ['a', 'a', 'a', 'b', 'b', 'b']
>>> ser = pd.Series([7, 2, 8, 4, 3, 3], index=lst)
>>> ser
a    7
a    2
a    8
b    4
b    3
b    3
dtype: int64
>>> ser.groupby(level=0).median()
a    7.0
b    3.0
dtype: float64

-- Example 32548
>>> data = {'a': [1, 3, 5, 7, 7, 8, 3], 'b': [1, 4, 8, 4, 4, 2, 1]}
>>> df = pd.DataFrame(data, index=['dog', 'dog', 'dog',
...                   'mouse', 'mouse', 'mouse', 'mouse'])
>>> df
       a  b
dog    1  1
dog    3  4
dog    5  8
mouse  7  4
mouse  7  4
mouse  8  2
mouse  3  1
>>> df.groupby(level=0).median()
         a    b
dog    3.0  4.0
mouse  7.0  3.0

-- Example 32549
>>> lst = ['a', 'a', 'b', 'b']
>>> ser = pd.Series([1, 2, 3, 4], index=lst)
>>> ser
a    1
a    2
b    3
b    4
dtype: int64
>>> ser.groupby(level=0).min()
a    1
b    3
dtype: int64

-- Example 32550
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["tiger", "leopard", "cheetah", "lion"])
>>> df
         a  b  c
tiger    1  8  2
leopard  1  2  5
cheetah  2  5  8
lion     2  6  9
>>> df.groupby("a").min()  
   b  c
a
1  2  2
2  5  8

-- Example 32551
>>> lst = ['a', 'a', 'b', 'b']
>>> ser = pd.Series([1, 2, 3, 4], index=lst)
>>> ser
a    1
a    2
b    3
b    4
dtype: int64
>>> ser.groupby(level=0).pct_change()
a         NaN
a    1.000000
b         NaN
b    0.333333
dtype: float64

-- Example 32552
>>> data = [[1, 2, 3], [1, 5, 6], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"], index=["tuna", "salmon", "catfish", "goldfish"])
>>> df  
           a  b  c
    tuna   1  2  3
  salmon   1  5  6
 catfish   2  5  8
goldfish   2  6  9
>>> df.groupby("a").pct_change()  
            b  c
    tuna    NaN    NaN
  salmon    1.5  1.000
 catfish    NaN    NaN
goldfish    0.2  0.125

-- Example 32553
>>> df = pd.DataFrame({"group": ["a", "a", "a", "b", "b", "b", "b"], "value": [2, 4, 2, 3, 5, 1, 2]})
>>> df
  group  value
0     a      2
1     a      4
2     a      2
3     b      3
4     b      5
5     b      1
6     b      2
>>> df = df.groupby("group").rank(method='min')
>>> df
   value
0      1
1      3
2      1
3      3
4      4
5      1
6      2

-- Example 32554
>>> lst = ['a', 'a', 'b', 'b']
>>> ser = pd.Series([1, 2, 3, 4], index=lst)

-- Example 32555
>>> ser
a    1
a    2
b    3
b    4
dtype: int64

-- Example 32556
>>> ser.groupby(level=0).shift(1)
a    NaN
a    1.0
b    NaN
b    3.0
dtype: float64

-- Example 32557
>>> data = [[1, 2, 3], [1, 5, 6], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["tuna", "salmon", "catfish", "goldfish"])

-- Example 32558
>>> df
          a  b  c
tuna      1  2  3
salmon    1  5  6
catfish   2  5  8
goldfish  2  6  9

-- Example 32559
>>> df.groupby("a").shift(1)
            b    c
tuna      NaN  NaN
salmon    2.0  3.0
catfish   NaN  NaN
goldfish  5.0  8.0

-- Example 32560
>>> data = [[1, 2, 3], [1, 5, 6], [7, 8, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["owl", "toucan", "eagle"])
>>> df
        a  b  c
owl     1  2  3
toucan  1  5  6
eagle   7  8  9
>>> df.groupby("a").size()
a
1    2
7    1
dtype: int64

-- Example 32561
>>> data = [[1, 2, 3], [1, 5, 6], [7, 8, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["owl", "toucan", "eagle"])
>>> df
        a  b  c
owl     1  2  3
toucan  1  5  6
eagle   7  8  9
>>> df.groupby("a")["b"].size()
a
1    2
7    1
Name: b, dtype: int64

-- Example 32562
>>> lst = ['a', 'a', 'a', 'b', 'b', 'b', 'c']
>>> ser = pd.Series([7, 2, 8, 4, 3, 3, 1], index=lst)
>>> ser
a    7
a    2
a    8
b    4
b    3
b    3
c    1
dtype: int64
>>> ser.groupby(level=0).std()
a    3.21455
b    0.57735
c        NaN
dtype: float64
>>> ser.groupby(level=0).std(ddof=0)
a    2.624669
b    0.471404
c    0.000000
dtype: float64

-- Example 32563
>>> data = {'a': [1, 3, 5, 7, 7, 8, 3], 'b': [1, 4, 8, 4, 4, 2, 1]}
>>> df = pd.DataFrame(data, index=pd.Index(['dog', 'dog', 'dog',
...                   'mouse', 'mouse', 'mouse', 'mouse'], name='c'))
>>> df      
       a  b
c
dog    1  1
dog    3  4
dog    5  8
mouse  7  4
mouse  7  4
mouse  8  2
mouse  3  1
>>> df.groupby('c').std()       
              a         b
c
dog    2.000000  3.511885
mouse  2.217356  1.500000
>>> data = {'a': [1, 3, 5, 7, 7, 8, 3], 'b': ['c', 'e', 'd', 'a', 'a', 'b', 'e']}
>>> df = pd.DataFrame(data, index=pd.Index(['dog', 'dog', 'dog',
...                   'mouse', 'mouse', 'mouse', 'mouse'], name='c'))
>>> df      
       a  b
c
dog    1  c
dog    3  e
dog    5  d
mouse  7  a
mouse  7  a
mouse  8  b
mouse  3  e
>>> df.groupby('c').std(numeric_only=True)       
              a
c
dog    2.000000
mouse  2.217356

-- Example 32564
>>> lst = ['a', 'a', 'b', 'b']
>>> ser = pd.Series([1, 2, 3, 4], index=lst)
>>> ser
a    1
a    2
b    3
b    4
dtype: int64
>>> ser.groupby(level=0).sum()
a    3
b    7
dtype: int64

-- Example 32565
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["tiger", "leopard", "cheetah", "lion"])
>>> df
         a  b  c
tiger    1  8  2
leopard  1  2  5
cheetah  2  5  8
lion     2  6  9
>>> df.groupby("a").sum()  
    b   c
a
1  10   7
2  11  17

-- Example 32566
>>> df = pd.DataFrame([['a', 1], ['a', 2], ['b', 1], ['b', 2]],
...                   columns=['A', 'B'])
>>> df.groupby('A').tail(1)
   A  B
1  a  2
3  b  2
>>> df.groupby('A').tail(-1)
   A  B
1  a  2
3  b  2

-- Example 32567
>>> df = pd.DataFrame(
...     {
...         "col1": ["Z", None, "X", "Z", "Y", "X", "X", None, "X", "Y"],
...         "col2": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
...         "col3": [40, 50, 60, 10, 20, 30, 40, 80, 90, 10],
...         "col4": [-1, -2, -3, -4, -5, -6, -7, -8, -9, -10],
...     },
...     index=list("abcdefghij"),
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
>>> df.groupby("col1", dropna=False).tail(2)
   col1  col2  col3  col4
a     Z     1    40    -1
b  None     2    50    -2
d     Z     4    10    -4
e     Y     5    20    -5
g     X     7    40    -7
h  None     8    80    -8
i     X     9    90    -9
j     Y    10    10   -10
>>> df.groupby("col1", dropna=False).tail(-2)
  col1  col2  col3  col4
g    X     7    40    -7
i    X     9    90    -9

-- Example 32568
>>> lst = ['a', 'a', 'a', 'b', 'b', 'b', 'c']
>>> ser = pd.Series([7, 2, 8, 4, 3, 3, 1], index=lst)
>>> ser
a    7
a    2
a    8
b    4
b    3
b    3
c    1
dtype: int64
>>> ser.groupby(level=0).var()
a    10.333333
b     0.333333
c          NaN
dtype: float64
>>> ser.groupby(level=0).var(ddof=0)
a    6.888889
b    0.222222
c    0.000000
dtype: float64

-- Example 32569
>>> data = {'a': [1, 3, 5, 7, 7, 8, 3], 'b': [1, 4, 8, 4, 4, 2, 1]}
>>> df = pd.DataFrame(data, index=pd.Index(['dog', 'dog', 'dog',
...                   'mouse', 'mouse', 'mouse', 'mouse'], name='c'))
>>> df      
       a  b
c
dog    1  1
dog    3  4
dog    5  8
mouse  7  4
mouse  7  4
mouse  8  2
mouse  3  1
>>> df.groupby('c').var()       
              a          b
c
dog    4.000000  12.333333
mouse  4.916667   2.250000
>>> data = {'a': [1, 3, 5, 7, 7, 8, 3], 'b': ['c', 'e', 'd', 'a', 'a', 'b', 'e']}
>>> df = pd.DataFrame(data, index=pd.Index(['dog', 'dog', 'dog',
...                   'mouse', 'mouse', 'mouse', 'mouse'], name='c'))
>>> df      
       a  b
c
dog    1  c
dog    3  e
dog    5  d
mouse  7  a
mouse  7  a
mouse  8  b
mouse  3  e
>>> df.groupby('c').var(numeric_only=True)       
              a
c
dog    4.000000
mouse  4.916667

-- Example 32570
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32571
>>> ser1.resample('2D').indices
defaultdict(<class 'list'>, {Timestamp('2020-01-01 00:00:00'): [0, 1], Timestamp('2020-01-03 00:00:00'): [2, 3]})

-- Example 32572
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32573
>>> df.resample('2D').indices
defaultdict(<class 'list'>, {Timestamp('2020-01-01 00:00:00'): [0, 1], Timestamp('2020-01-03 00:00:00'): [2, 3]})

-- Example 32574
>>> s = pd.Series([1, 2, 3], index=pd.date_range('20180101', periods=3, freq='h'))
>>> s
2018-01-01 00:00:00    1
2018-01-01 01:00:00    2
2018-01-01 02:00:00    3
Freq: None, dtype: int64
>>> s.resample("30min").asfreq()
2018-01-01 00:00:00    1.0
2018-01-01 00:30:00    NaN
2018-01-01 01:00:00    2.0
2018-01-01 01:30:00    NaN
2018-01-01 02:00:00    3.0
Freq: None, dtype: float64
>>> s.resample("2h").asfreq()
2018-01-01 00:00:00    1
2018-01-01 02:00:00    3
Freq: None, dtype: int64

-- Example 32575
>>> s = pd.Series([1, 2, 3],
... index=pd.date_range('20180101', periods=3, freq='h'))
>>> s
2018-01-01 00:00:00    1
2018-01-01 01:00:00    2
2018-01-01 02:00:00    3
Freq: None, dtype: int64
>>> s.resample('30min').bfill()
2018-01-01 00:00:00    1
2018-01-01 00:30:00    2
2018-01-01 01:00:00    2
2018-01-01 01:30:00    3
2018-01-01 02:00:00    3
Freq: None, dtype: int64
>>> df = pd.DataFrame({'a': [2, np.nan, 6], 'b': [1, 3, 5]},
...      index=pd.date_range('20180101', periods=3,
...      freq='h'))
>>> df
                       a  b
2018-01-01 00:00:00  2.0  1
2018-01-01 01:00:00  NaN  3
2018-01-01 02:00:00  6.0  5
>>> df.resample('30min').bfill()
                       a  b
2018-01-01 00:00:00  2.0  1
2018-01-01 00:30:00  NaN  3
2018-01-01 01:00:00  NaN  3
2018-01-01 01:30:00  6.0  5
2018-01-01 02:00:00  6.0  5

-- Example 32576
>>> ser1.resample('1D').ffill()
2020-01-03    1
2020-01-04    2
2020-01-05    3
2020-01-06    3
2020-01-07    4
2020-01-08    5
Freq: None, dtype: int64

-- Example 32577
>>> ser1.resample('3D').ffill()
2020-01-03    1
2020-01-06    3
Freq: None, dtype: int64

-- Example 32578
>>> lst2 = pd.to_datetime(pd.Index(['2023-01-03 1:00:00', '2023-01-04', '2023-01-05 23:00:00', '2023-01-06', '2023-01-07 2:00:00', '2023-01-10']))
>>> ser2 = pd.Series([1, 2, 3, 4, None, 6], index=lst2)
>>> ser2
2023-01-03 01:00:00    1.0
2023-01-04 00:00:00    2.0
2023-01-05 23:00:00    3.0
2023-01-06 00:00:00    4.0
2023-01-07 02:00:00    NaN
2023-01-10 00:00:00    6.0
Freq: None, dtype: float64

-- Example 32579
>>> ser2.resample('1D').ffill()
2023-01-03    NaN
2023-01-04    2.0
2023-01-05    2.0
2023-01-06    4.0
2023-01-07    4.0
2023-01-08    NaN
2023-01-09    NaN
2023-01-10    6.0
Freq: None, dtype: float64

-- Example 32580
>>> ser2.resample('2D').ffill()
2023-01-03    NaN
2023-01-05    2.0
2023-01-07    4.0
2023-01-09    NaN
Freq: None, dtype: float64

-- Example 32581
>>> index1 = pd.to_datetime(['2020-01-03', '2020-01-04', '2020-01-05', '2020-01-07', '2020-01-08'])
>>> df1 = pd.DataFrame({'a': range(len(index1)),
... 'b': range(len(index1) + 10, len(index1) * 2 + 10)},
...  index=index1)
>>> df1
            a   b
2020-01-03  0  15
2020-01-04  1  16
2020-01-05  2  17
2020-01-07  3  18
2020-01-08  4  19

-- Example 32582
>>> df1.resample('1D').ffill()
            a   b
2020-01-03  0  15
2020-01-04  1  16
2020-01-05  2  17
2020-01-06  2  17
2020-01-07  3  18
2020-01-08  4  19

-- Example 32583
>>> df1.resample('3D').ffill()
            a   b
2020-01-03  0  15
2020-01-06  2  17

-- Example 32584
>>> index2 = pd.to_datetime(pd.Index(['2023-01-03 1:00:00', '2023-01-04', '2023-01-05 23:00:00', '2023-01-06', '2023-01-07 2:00:00', '2023-01-10']))
>>> df2 = pd.DataFrame({'a': range(len(index2)),
... 'b': range(len(index2) + 10, len(index2) * 2 + 10)},
...  index=index2)
>>> df2
                     a   b
2023-01-03 01:00:00  0  16
2023-01-04 00:00:00  1  17
2023-01-05 23:00:00  2  18
2023-01-06 00:00:00  3  19
2023-01-07 02:00:00  4  20
2023-01-10 00:00:00  5  21

-- Example 32585
>>> df2.resample('1D').ffill()
              a     b
2023-01-03  NaN   NaN
2023-01-04  1.0  17.0
2023-01-05  1.0  17.0
2023-01-06  3.0  19.0
2023-01-07  3.0  19.0
2023-01-08  4.0  20.0
2023-01-09  4.0  20.0
2023-01-10  5.0  21.0

-- Example 32586
>>> df2.resample('2D').ffill()
              a     b
2023-01-03  NaN   NaN
2023-01-05  1.0  17.0
2023-01-07  3.0  19.0
2023-01-09  4.0  20.0

-- Example 32587
>>> s = pd.Series([1, 2, 3], index=pd.date_range('20180101', periods=3, freq='h'))
>>> s
2018-01-01 00:00:00    1
2018-01-01 01:00:00    2
2018-01-01 02:00:00    3
Freq: None, dtype: int64
>>> s.resample('30min').fillna("pad")
2018-01-01 00:00:00    1
2018-01-01 00:30:00    1
2018-01-01 01:00:00    2
2018-01-01 01:30:00    2
2018-01-01 02:00:00    3
Freq: None, dtype: int64
>>> s.resample('30min').fillna("backfill")
2018-01-01 00:00:00    1
2018-01-01 00:30:00    2
2018-01-01 01:00:00    2
2018-01-01 01:30:00    3
2018-01-01 02:00:00    3
Freq: None, dtype: int64
>>> sm = pd.Series([1, None, 3],
... index=pd.date_range('20180101', periods=3, freq='h'))
>>> sm
2018-01-01 00:00:00    1.0
2018-01-01 01:00:00    NaN
2018-01-01 02:00:00    3.0
Freq: None, dtype: float64
>>> sm.resample('30min').fillna('pad')
2018-01-01 00:00:00    1.0
2018-01-01 00:30:00    1.0
2018-01-01 01:00:00    NaN
2018-01-01 01:30:00    NaN
2018-01-01 02:00:00    3.0
Freq: None, dtype: float64
>>> sm.resample('30min').fillna('backfill')
2018-01-01 00:00:00    1.0
2018-01-01 00:30:00    NaN
2018-01-01 01:00:00    NaN
2018-01-01 01:30:00    3.0
2018-01-01 02:00:00    3.0
Freq: None, dtype: float64

-- Example 32588
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32589
>>> ser1.resample('2D').count()
2020-01-01    2
2020-01-03    2
Freq: None, dtype: int64

-- Example 32590
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32591
>>> ser2.resample('2S').count()
2020-01-01 00:00:00    2
2020-01-01 00:00:02    1
Freq: None, dtype: int64

-- Example 32592
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32593
>>> df.resample('2D').count()
            a  b  c
2020-01-01  2  2  2
2020-01-03  2  2  2

-- Example 32594
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32595
>>> ser1.resample('2D').first()
2020-01-01    1
2020-01-03    3
Freq: None, dtype: int64

-- Example 32596
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32597
>>> ser2.resample('2S').first()
2020-01-01 00:00:00    1.0
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32598
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32599
>>> df.resample('2D').first()
            a  b  c
2020-01-01  1  8  2
2020-01-03  2  5  8

-- Example 32600
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

