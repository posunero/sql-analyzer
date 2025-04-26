-- Example 31797
>>> ser = pd.Series([-1, 5, 6, 2, 4])
>>> ser
0   -1
1    5
2    6
3    2
4    4
dtype: int64

-- Example 31798
>>> ser.take([0, 3])
0   -1
3    2
dtype: int64

-- Example 31799
>>> ser.take([-1, -2])
4    4
3    2
dtype: int64

-- Example 31800
>>> s = pd.Series(range(5))
>>> t = pd.Series([True, False])
>>> s.where(t, 99)  
0     0
1    99
2    99
3    99
4    99
dtype: int64

-- Example 31801
>>> s.where(s > 1, 10)  
0    10
1    10
2    2
3    3
4    4
dtype: int64

-- Example 31802
>>> s = pd.Series(range(5))
>>> t = pd.Series([True, False])
>>> s.mask(t, 99)  
0    99
1     1
2    99
3    99
4    99
dtype: int64

-- Example 31803
>>> s.mask(s > 1, 10)  
0     0
1     1
2    10
3    10
4    10
dtype: int64

-- Example 31804
>>> s = pd.Series([1, 2, 3, 4])
>>> s
0    1
1    2
2    3
3    4
dtype: int64

-- Example 31805
>>> s.add_prefix('item_')
item_0    1
item_1    2
item_2    3
item_3    4
dtype: int64

-- Example 31806
>>> df = pd.DataFrame({'A': [1, 2, 3, 4], 'B': [3, 4, 5, 6]})
>>> df
   A  B
0  1  3
1  2  4
2  3  5
3  4  6

-- Example 31807
>>> df.add_prefix('col_')
   col_A  col_B
0      1      3
1      2      4
2      3      5
3      4      6

-- Example 31808
>>> s = pd.Series([1, 2, 3, 4])
>>> s
0    1
1    2
2    3
3    4
dtype: int64

-- Example 31809
>>> s.add_suffix('_item')
0_item    1
1_item    2
2_item    3
3_item    4
dtype: int64

-- Example 31810
>>> df = pd.DataFrame({'A': [1, 2, 3, 4], 'B': [3, 4, 5, 6]})
>>> df
   A  B
0  1  3
1  2  4
2  3  5
3  4  6

-- Example 31811
>>> df.add_suffix('_col')
   A_col  B_col
0      1      3
1      2      4
2      3      5
3      4      6

-- Example 31812
>>> ser = pd.Series([1., 2., np.nan])
>>> ser
0    1.0
1    2.0
2    NaN
dtype: float64

-- Example 31813
>>> ser.dropna()
0    1.0
1    2.0
dtype: float64

-- Example 31814
>>> ser.dropna(inplace=True)
>>> ser
0    1.0
1    2.0
dtype: float64

-- Example 31815
>>> ser = pd.Series([np.nan, 2, pd.NaT, '', None, 'I stay'])
>>> ser  
0      None
1         2
2      None
3
4      None
5    I stay
dtype: object
>>> ser.dropna()  
1         2
3
5    I stay
dtype: object

-- Example 31816
>>> df = pd.DataFrame([[np.nan, 2, np.nan, 0],
...                    [3, 4, np.nan, 1],
...                    [np.nan, np.nan, np.nan, np.nan],
...                    [np.nan, 3, np.nan, 4]],
...                   columns=list("ABCD"))
>>> df
     A    B   C    D
0  NaN  2.0 NaN  0.0
1  3.0  4.0 NaN  1.0
2  NaN  NaN NaN  NaN
3  NaN  3.0 NaN  4.0

-- Example 31817
>>> df.fillna(0)
     A    B    C    D
0  0.0  2.0  0.0  0.0
1  3.0  4.0  0.0  1.0
2  0.0  0.0  0.0  0.0
3  0.0  3.0  0.0  4.0

-- Example 31818
>>> values = {"A": 0, "B": 1, "C": 2, "D": 3}
>>> df.fillna(value=values)
     A    B    C    D
0  0.0  2.0  2.0  0.0
1  3.0  4.0  2.0  1.0
2  0.0  1.0  2.0  3.0
3  0.0  3.0  2.0  4.0

-- Example 31819
>>> df.fillna(method="ffill", limit=1)
     A    B   C    D
0  NaN  2.0 NaN  0.0
1  3.0  4.0 NaN  1.0
2  3.0  4.0 NaN  1.0
3  NaN  3.0 NaN  4.0

-- Example 31820
>>> df2 = pd.DataFrame(np.zeros((4, 4)), columns=list("ABCE"))
>>> df.fillna(df2)
     A    B    C    D
0  0.0  2.0  0.0  0.0
1  3.0  4.0  0.0  1.0
2  0.0  0.0  0.0  NaN
3  0.0  3.0  0.0  4.0

-- Example 31821
>>> ser = pd.Series([5, 6, np.nan])
>>> ser
0    5.0
1    6.0
2    NaN
dtype: float64

-- Example 31822
>>> ser.isna()
0    False
1    False
2     True
dtype: bool

-- Example 31823
>>> ser = pd.Series([5, 6, np.nan])
>>> ser
0    5.0
1    6.0
2    NaN
dtype: float64

-- Example 31824
>>> ser.isna()
0    False
1    False
2     True
dtype: bool

-- Example 31825
>>> df = pd.DataFrame([['ant', 'bee', 'cat'], ['dog', None, 'fly']])
>>> df
     0     1    2
0  ant   bee  cat
1  dog  None  fly
>>> df.notna()
      0      1     2
0  True   True  True
1  True  False  True
>>> df.notnull()
      0      1     2
0  True   True  True
1  True  False  True

-- Example 31826
>>> df = pd.DataFrame([['ant', 'bee', 'cat'], ['dog', None, 'fly']])
>>> df
     0     1    2
0  ant   bee  cat
1  dog  None  fly
>>> df.notna()
      0      1     2
0  True   True  True
1  True  False  True
>>> df.notnull()
      0      1     2
0  True   True  True
1  True  False  True

-- Example 31827
>>> s = pd.Series([1, 2, 3, 4, 5])
>>> s.replace(1, 5)
0    5
1    2
2    3
3    4
4    5
dtype: int64

-- Example 31828
>>> s.replace({1: 10, 2: 100})
0     10
1    100
2      3
3      4
4      5
dtype: int64

-- Example 31829
>>> s = pd.Series(['bat', 'foo', 'bait'])
>>> s.replace(to_replace=r'^ba.$', value='new', regex=True)
0     new
1     foo
2    bait
dtype: object

-- Example 31830
>>> s.replace(regex=r'^ba.$', value='new')
0     new
1     foo
2    bait
dtype: object

-- Example 31831
>>> s.replace(regex={r'^ba.$': 'new', 'foo': 'xyz'})
0     new
1     xyz
2    bait
dtype: object

-- Example 31832
>>> s.replace(regex=[r'^ba.$', 'foo'], value='new')
0     new
1     new
2    bait
dtype: object

-- Example 31833
>>> s = pd.Series([10, 'a', 'a', 'b', 'a'])

-- Example 31834
>>> s.replace({'a': None})
0      10
1    None
2    None
3       b
4    None
dtype: object

-- Example 31835
>>> s.replace('a', None)
0      10
1    None
2    None
3       b
4    None
dtype: object

-- Example 31836
>>> s = pd.Series([np.nan, 1, 3, 10, 5])
>>> s
0     NaN
1     1.0
2     3.0
3    10.0
4     5.0
dtype: float64

-- Example 31837
>>> s.sort_values(ascending=True)
1     1.0
2     3.0
4     5.0
3    10.0
0     NaN
dtype: float64

-- Example 31838
>>> s.sort_values(ascending=False)
3    10.0
4     5.0
2     3.0
1     1.0
0     NaN
dtype: float64

-- Example 31839
>>> s.sort_values(ascending=False, inplace=True)
>>> s
3    10.0
4     5.0
2     3.0
1     1.0
0     NaN
dtype: float64

-- Example 31840
>>> s.sort_values(na_position='first')
0     NaN
1     1.0
2     3.0
4     5.0
3    10.0
dtype: float64

-- Example 31841
>>> s = pd.Series(['z', 'b', 'd', 'a', 'c'])
>>> s
0    z
1    b
2    d
3    a
4    c
dtype: object

-- Example 31842
>>> s.sort_values()
3    a
1    b
4    c
2    d
0    z
dtype: object

-- Example 31843
>>> s = pd.Series(['a', 'B', 'c', 'D', 'e'])
>>> s.sort_values()
1    B
3    D
0    a
2    c
4    e
dtype: object

-- Example 31844
>>> s = pd.Series([1, 2, 3, 4],
...               index=pd.MultiIndex.from_product([['one', 'two'],
...                                                 ['a', 'b']]))
>>> s
one  a    1
     b    2
two  a    3
     b    4
dtype: int64
>>> s.unstack(level=-1)
     a  b
one  1  2
two  3  4
>>> s.unstack(level=0)
   one  two
a    1    3
b    2    4

-- Example 31845
>>> countries_population = {"Italy": 59000000, "France": 65000000,
...                         "Malta": 434000, "Maldives": 434000,
...                         "Brunei": 434000, "Iceland": 337000,
...                         "Nauru": 11300, "Tuvalu": 11300,
...                         "Anguilla": 11300, "Montserrat": 5200}
>>> s = pd.Series(countries_population)
>>> s
Italy         59000000
France        65000000
Malta           434000
Maldives        434000
Brunei          434000
Iceland         337000
Nauru            11300
Tuvalu           11300
Anguilla         11300
Montserrat        5200
dtype: int64

-- Example 31846
>>> s.nlargest()
France      65000000
Italy       59000000
Malta         434000
Maldives      434000
Brunei        434000
dtype: int64

-- Example 31847
>>> s.nlargest(3)
France    65000000
Italy     59000000
Malta       434000
dtype: int64

-- Example 31848
>>> s.nlargest(3, keep='last')
France    65000000
Italy     59000000
Brunei      434000
dtype: int64

-- Example 31849
>>> s.nlargest(3, keep='all')  
France      65000000
Italy       59000000
Malta         434000
Maldives      434000
Brunei        434000
dtype: int64

-- Example 31850
>>> countries_population = {"Italy": 59000000, "France": 65000000,
...                         "Brunei": 434000, "Malta": 434000,
...                         "Maldives": 434000, "Iceland": 337000,
...                         "Nauru": 11300, "Tuvalu": 11300,
...                         "Anguilla": 11300, "Montserrat": 5200}
>>> s = pd.Series(countries_population)
>>> s
Italy         59000000
France        65000000
Brunei          434000
Malta           434000
Maldives        434000
Iceland         337000
Nauru            11300
Tuvalu           11300
Anguilla         11300
Montserrat        5200
dtype: int64

-- Example 31851
>>> s.nsmallest()
Montserrat      5200
Nauru          11300
Tuvalu         11300
Anguilla       11300
Iceland       337000
dtype: int64

-- Example 31852
>>> s.nsmallest(3)
Montserrat     5200
Nauru         11300
Tuvalu        11300
dtype: int64

-- Example 31853
>>> s.nsmallest(3, keep='last')
Montserrat     5200
Anguilla      11300
Tuvalu        11300
dtype: int64

-- Example 31854
>>> s.nsmallest(3, keep='all')  
Montserrat     5200
Nauru         11300
Tuvalu        11300
Anguilla      11300
dtype: int64

-- Example 31855
>>> primes = pd.Series([2, 3, 5, 7])

-- Example 31856
>>> even_primes = primes[primes % 2 == 0]   
>>> even_primes   
0    2
dtype: int64

-- Example 31857
>>> even_primes.squeeze()   
2

-- Example 31858
>>> odd_primes = primes[primes % 2 == 1]   
>>> odd_primes   
1    3
2    5
3    7
dtype: int64

-- Example 31859
>>> odd_primes.squeeze()   
1    3
2    5
3    7
dtype: int64

-- Example 31860
>>> df = pd.DataFrame([[1, 2], [3, 4]], columns=['a', 'b'])
>>> df
   a  b
0  1  2
1  3  4

-- Example 31861
>>> df_a = df[['a']]
>>> df_a
   a
0  1
1  3

-- Example 31862
>>> df_a.squeeze('columns')
0    1
1    3
Name: a, dtype: int64

-- Example 31863
>>> df_0a = df.loc[df.index < 1, ['a']]
>>> df_0a
   a
0  1

