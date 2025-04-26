-- Example 31596
>>> s = pd.Series([1, 2], index=["a", "b"])
>>> s
a    1
b    2
dtype: int64

-- Example 31597
>>> s_copy = s.copy()
>>> s_copy
a    1
b    2
dtype: int64

-- Example 31598
>>> s = pd.Series([1, 2], index=["a", "b"])
>>> deep = s.copy()
>>> shallow = s.copy(deep=False)

-- Example 31599
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

-- Example 31600
>>> s = pd.Series([1, 2, 3, 4])
>>> s.to_dict()
{0: 1, 1: 2, 2: 3, 3: 4}
>>> from collections import OrderedDict, defaultdict
>>> s.to_dict(OrderedDict)  
OrderedDict([(0, 1), (1, 2), (2, 3), (3, 4)])
>>> dd = defaultdict(list)
>>> s.to_dict(dd)
defaultdict(<class 'list'>, {0: 1, 1: 2, 2: 3, 3: 4})

-- Example 31601
>>> ser = pd.Series(pd.Categorical(['a', 'b', 'a']))  
>>> ser.to_numpy()  
array(['a', 'b', 'a'], dtype=object)

-- Example 31602
>>> ser = pd.Series(pd.date_range('2000', periods=2, tz="CET"))
>>> ser.to_numpy(dtype=object)
array([Timestamp('2000-01-01 00:00:00+0100', tz='UTC+01:00'),
       Timestamp('2000-01-02 00:00:00+0100', tz='UTC+01:00')],
      dtype=object)

-- Example 31603
>>> ser.to_numpy(dtype="datetime64[ns]")
array(['1999-12-31T23:00:00.000000000', '2000-01-01T23:00:00...'],
      dtype='datetime64[ns]')

-- Example 31604
>>> s = pd.Series(['Falcon', 'Falcon',
...                 'Parrot', 'Parrot'],
...                 name = 'Animal')
>>> s.to_pandas()
0    Falcon
1    Falcon
2    Parrot
3    Parrot
Name: Animal, dtype: object

-- Example 31605
>>> mydict = [{'a': 1, 'b': 2, 'c': 3, 'd': 4},
...           {'a': 100, 'b': 200, 'c': 300, 'd': 400},
...           {'a': 1000, 'b': 2000, 'c': 3000, 'd': 4000}]
>>> df = pd.DataFrame(mydict)
>>> df
      a     b     c     d
0     1     2     3     4
1   100   200   300   400
2  1000  2000  3000  4000

-- Example 31606
>>> type(df.iloc[0])
<class 'modin.pandas.series.Series'>
>>> df.iloc[0]
a    1
b    2
c    3
d    4
Name: 0, dtype: int64

-- Example 31607
>>> df.iloc[-1]
a    1000
b    2000
c    3000
d    4000
Name: 2, dtype: int64

-- Example 31608
>>> df.iloc[[0]]
   a  b  c  d
0  1  2  3  4

-- Example 31609
>>> df.iloc[[0, 1]]
     a    b    c    d
0    1    2    3    4
1  100  200  300  400

-- Example 31610
>>> df.iloc[[0, 1, 10, 11]]
     a    b    c    d
0    1    2    3    4
1  100  200  300  400

-- Example 31611
>>> df.iloc[[10, 11, 12]]
Empty DataFrame
Columns: [a, b, c, d]
Index: []

-- Example 31612
>>> df.iloc[:3]
      a     b     c     d
0     1     2     3     4
1   100   200   300   400
2  1000  2000  3000  4000

-- Example 31613
>>> df.iloc[[True, False, True]]
      a     b     c     d
0     1     2     3     4
2  1000  2000  3000  4000

-- Example 31614
>>> df.iloc[[True, False]]      
      a     b     c     d
0     1     2     3     4

-- Example 31615
>>> df.iloc[[True, False, True, True, True]]      
      a     b     c     d
0     1     2     3     4
2  1000  2000  3000  4000

-- Example 31616
>>> df.iloc[lambda x: x.index % 2 == 0]
      a     b     c     d
0     1     2     3     4
2  1000  2000  3000  4000

-- Example 31617
>>> df.iloc[0, 1]  
2

-- Example 31618
>>> df.iloc[[0, 2], [1, 3]]
      b     d
0     2     4
2  2000  4000

-- Example 31619
>>> df.iloc[1:3, 0:3]
      a     b     c
1   100   200   300
2  1000  2000  3000

-- Example 31620
>>> df.iloc[:, [True, False, True, False]]
      a     c
0     1     3
1   100   300
2  1000  3000

-- Example 31621
>>> df.iloc[:, lambda df: [0, 2]]
      a     c
0     1     3
1   100   300
2  1000  3000

-- Example 31622
>>> s = pd.Series(['A', 'B', 'C'])
>>> for index, value in s.items():
...     print(f"Index : {index}, Value : {value}")
Index : 0, Value : A
Index : 1, Value : B
Index : 2, Value : C

-- Example 31623
>>> df = pd.DataFrame([[1, 2], [4, 5], [7, 8]],
...      index=['cobra', 'viper', 'sidewinder'],
...      columns=['max_speed', 'shield'])
>>> df
            max_speed  shield
cobra               1       2
viper               4       5
sidewinder          7       8

-- Example 31624
>>> df.loc['viper']
max_speed    4
shield       5
Name: viper, dtype: int64

-- Example 31625
>>> df.loc[['viper', 'sidewinder']]
            max_speed  shield
viper               4       5
sidewinder          7       8

-- Example 31626
>>> df.loc['cobra', 'shield']  
2

-- Example 31627
>>> df.loc['cobra':'viper', 'max_speed']
cobra    1
viper    4
Name: max_speed, dtype: int64

-- Example 31628
>>> df.loc[[False, False, True]]
            max_speed  shield
sidewinder          7       8

-- Example 31629
>>> df.loc[pd.Series([False, True, False],
...        index=['viper', 'sidewinder', 'cobra'])]
            max_speed  shield
sidewinder          7       8

-- Example 31630
>>> df.loc[pd.Index(["cobra", "viper"], name="foo")]  
       max_speed  shield
foo
cobra          1       2
viper          4       5

-- Example 31631
>>> df.loc[df['shield'] > 6]
            max_speed  shield
sidewinder          7       8

-- Example 31632
>>> df.loc[df['shield'] > 6, ['max_speed']]
            max_speed
sidewinder          7

-- Example 31633
>>> df.loc[lambda df: df['shield'] == 8]
            max_speed  shield
sidewinder          7       8

-- Example 31634
>>> df.loc[['viper', 'sidewinder'], ['shield']] = 50
>>> df
            max_speed  shield
cobra               1       2
viper               4      50
sidewinder          7      50

-- Example 31635
>>> df.loc['cobra'] = 10
>>> df
            max_speed  shield
cobra              10      10
viper               4      50
sidewinder          7      50

-- Example 31636
>>> df.loc[:, 'max_speed'] = 30
>>> df
            max_speed  shield
cobra              30      10
viper              30      50
sidewinder         30      50

-- Example 31637
>>> df.loc[df['shield'] > 35] = 0
>>> df
            max_speed  shield
cobra              30      10
viper               0       0
sidewinder          0       0

-- Example 31638
>>> df.loc["viper"] = pd.Series([99, 99], index=["max_speed", "shield"])
>>> df
            max_speed  shield
cobra              30      10
viper              99      99
sidewinder          0       0

-- Example 31639
>>> df = pd.DataFrame([[1, 2], [4, 5], [7, 8]],
...      index=[7, 8, 9], columns=['max_speed', 'shield'])
>>> df
   max_speed  shield
7          1       2
8          4       5
9          7       8

-- Example 31640
>>> df.loc[7:9]
   max_speed  shield
7          1       2
8          4       5
9          7       8

-- Example 31641
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

-- Example 31642
>>> df.loc['cobra']
         max_speed  shield
mark i          12       2
mark ii          0       4

-- Example 31643
>>> df.loc[('cobra', 'mark ii')]
max_speed    0
shield       4
Name: ('cobra', 'mark ii'), dtype: int64

-- Example 31644
>>> df.loc['cobra', 'mark i']
max_speed    12
shield        2
Name: ('cobra', 'mark i'), dtype: int64

-- Example 31645
>>> df.loc[[('cobra', 'mark ii')]]
               max_speed  shield
cobra mark ii          0       4

-- Example 31646
>>> df.loc[('cobra', 'mark i'), 'shield']  
2

-- Example 31647
>>> df.loc[('cobra', 'mark i'):'viper']
                     max_speed  shield
cobra      mark i           12       2
           mark ii           0       4
sidewinder mark i           10      20
           mark ii           1       4
viper      mark ii           7       1
           mark iii         16      36

-- Example 31648
>>> df.loc[('cobra', 'mark i'):('viper', 'mark ii')]
                    max_speed  shield
cobra      mark i          12       2
           mark ii          0       4
sidewinder mark i          10      20
           mark ii          1       4
viper      mark ii          7       1

-- Example 31649
>>> df = pd.DataFrame([[1, 2, 3], [4, 5, 6]], columns=list("ABC"))
>>> df.loc[:, pd.Series(list("ABC"))] = pd.Series([-10, -20, -30])
>>> df
    A   B   C
0 -10 -20 -30
1 -10 -20 -30
>>> df.loc[:, pd.Series(list("ABC"))] = pd.Series([10, 20, 30], index=list("CBA"))
>>> df
    A   B   C
0  10  20  30
1  10  20  30
>>> df.loc[:, pd.Series(list("BAC"))] = pd.Series([-10, -20, -30], index=list("ABC"))
>>> df
    A   B   C
0 -20 -10 -30
1 -20 -10 -30

-- Example 31650
>>> df.loc[:, list("ABC")] = pd.Series([1, 3, 5], index=list("CAB"))
>>> df
   A  B  C
0  3  5  1
1  3  5  1

-- Example 31651
>>> df.loc[:, "A":"B"] = pd.Series([10, 20, 30], index=list("ABC"))
>>> df
    A   B  C
0  10  20  1
1  10  20  1

-- Example 31652
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.add(b)
a   -1.0
b   -1.0
c    3.0
d    NaN
f    NaN
dtype: float64

-- Example 31653
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.sub(b)
a    3.0
b   -3.0
c   -3.0
d    NaN
f    NaN
dtype: float64

-- Example 31654
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.truediv(b)
a   -0.5
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31655
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.truediv(b)
a   -0.5
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31656
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.floordiv(b)
a   -1.0
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31657
>>> a = pd.Series([1, 2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b    2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a    2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.mod(b)
a    1.0
b    0.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31658
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.pow(b)
a    1.0
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31659
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.radd(b)
a   -1.0
b   -1.0
c    3.0
d    NaN
f    NaN
dtype: float64

-- Example 31660
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.rsub(b)
a   -3.0
b    3.0
c    3.0
d    NaN
f    NaN
dtype: float64

-- Example 31661
>>> a = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> a
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> b = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> b
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> a.rmul(b)
a   -2.0
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31662
>>> a = pd.Series([-2, 1, 3, np.nan, 1], index=['a', 'b', 'c', 'd', 'f'])
>>> a
a   -2.0
b    1.0
c    3.0
d    NaN
f    1.0
dtype: float64
>>> b = pd.Series([1, -2, 0, np.nan], index=['a', 'b', 'c', 'd'])
>>> b
a    1.0
b   -2.0
c    0.0
d    NaN
dtype: float64
>>> a.rtruediv(b)
a   -0.5
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

