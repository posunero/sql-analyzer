-- Example 32266
>>> df = pd.DataFrame({
... "Videogame": ["Dark Souls", "Cruelty Squad", "Stardew Valley"],
... "Genre": ["Souls-like", "Immersive-sim", "Farming-sim"],
... "Rating": [9.5, 9.0, 8.7]})
>>> df.set_axis(['a', 'b', 'c'], axis="index") 
        Videogame          Genre  Rating
a      Dark Souls     Souls-like     9.5
b   Cruelty Squad  Immersive-sim     9.0
c  Stardew Valley    Farming-sim     8.7

-- Example 32267
>>> df.set_axis(["Name", "Sub-genre", "Rating out of 10"], axis=1) 
             Name      Sub-genre  Rating out of 10
0      Dark Souls     Souls-like               9.5
1   Cruelty Squad  Immersive-sim               9.0
2  Stardew Valley    Farming-sim               8.7

-- Example 32268
>>> columns = pd.MultiIndex.from_tuples([("Gas", "Toyota"), ("Gas", "Ford"), ("Electric", "Tesla"), ("Electric", "Nio"),])
>>> data = [[100, 300, 900, 400], [200, 500, 300, 600]]
>>> df = pd.DataFrame(columns=columns, data=data)
>>> df.set_axis([2010, 2015], axis="rows") 
        Gas      Electric
     Toyota Ford    Tesla  Nio
2010    100  300      900  400
2015    200  500      300  600

-- Example 32269
>>> df = pd.DataFrame({'month': [1, 4, 7, 10],
...                    'year': [2012, 2014, 2013, 2014],
...                    'sale': [55, 40, 84, 31]})
>>> df
   month  year  sale
0      1  2012    55
1      4  2014    40
2      7  2013    84
3     10  2014    31

-- Example 32270
>>> df.set_index('month')  
       year  sale
month
1      2012    55
4      2014    40
7      2013    84
10     2014    31

-- Example 32271
>>> df.set_index(['year', 'month'])  
            sale
year month
2012 1        55
2014 4        40
2013 7        84
2014 10       31

-- Example 32272
>>> df.set_index([pd.Index([1, 2, 3, 4]), 'year']) 
         month  sale
   year
1  2012  1      55
2  2014  4      40
3  2013  7      84
4  2014  10     31

-- Example 32273
>>> s = pd.Series([1, 2, 3, 4])
>>> df.set_index([s, s**2]) 
        month  year  sale
1 1.0       1  2012    55
2 4.0       4  2014    40
3 9.0       7  2013    84
4 16.0     10  2014    31

-- Example 32274
>>> df = pd.DataFrame([('falcon', 'bird', 389.0),
...                    ('parrot', 'bird', 24.0),
...                    ('lion', 'mammal', 80.5),
...                    ('monkey', 'mammal', np.nan)],
...                   columns=['name', 'class', 'max_speed'],
...                   index=[0, 2, 3, 1])
>>> df
     name   class  max_speed
0  falcon    bird      389.0
2  parrot    bird       24.0
3    lion  mammal       80.5
1  monkey  mammal        NaN

-- Example 32275
>>> df.take([0, 3])
     name   class  max_speed
0  falcon    bird      389.0
1  monkey  mammal        NaN

-- Example 32276
>>> df.take([1, 2], axis=1)
    class  max_speed
0    bird      389.0
2    bird       24.0
3  mammal       80.5
1  mammal        NaN

-- Example 32277
>>> df.take([-1, -2])
     name   class  max_speed
1  monkey  mammal        NaN
3    lion  mammal       80.5

-- Example 32278
>>> df = pd.DataFrame({"name": ['Alfred', 'Batman', 'Catwoman'],
...                    "toy": [None, 'Batmobile', 'Bullwhip'],
...                    "born": [pd.NaT, pd.Timestamp("1940-04-25"),
...                             pd.NaT]})
>>> df
       name        toy       born
0    Alfred       None        NaT
1    Batman  Batmobile 1940-04-25
2  Catwoman   Bullwhip        NaT

-- Example 32279
>>> df.dropna()
     name        toy       born
1  Batman  Batmobile 1940-04-25

-- Example 32280
>>> df.dropna(how='all')
       name        toy       born
0    Alfred       None        NaT
1    Batman  Batmobile 1940-04-25
2  Catwoman   Bullwhip        NaT

-- Example 32281
>>> df.dropna(thresh=2)
       name        toy       born
1    Batman  Batmobile 1940-04-25
2  Catwoman   Bullwhip        NaT

-- Example 32282
>>> df.dropna(subset=['name', 'toy'])
       name        toy       born
1    Batman  Batmobile 1940-04-25
2  Catwoman   Bullwhip        NaT

-- Example 32283
>>> df.dropna(inplace=True)
>>> df
     name        toy       born
1  Batman  Batmobile 1940-04-25

-- Example 32284
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

-- Example 32285
>>> df.fillna(0)
     A    B    C    D
0  0.0  2.0  0.0  0.0
1  3.0  4.0  0.0  1.0
2  0.0  0.0  0.0  0.0
3  0.0  3.0  0.0  4.0

-- Example 32286
>>> values = {"A": 0, "B": 1, "C": 2, "D": 3}
>>> df.fillna(value=values)
     A    B    C    D
0  0.0  2.0  2.0  0.0
1  3.0  4.0  2.0  1.0
2  0.0  1.0  2.0  3.0
3  0.0  3.0  2.0  4.0

-- Example 32287
>>> df.fillna(method="ffill", limit=1)
     A    B   C    D
0  NaN  2.0 NaN  0.0
1  3.0  4.0 NaN  1.0
2  3.0  4.0 NaN  1.0
3  NaN  3.0 NaN  4.0

-- Example 32288
>>> df2 = pd.DataFrame(np.zeros((4, 4)), columns=list("ABCE"))
>>> df.fillna(df2)
     A    B    C    D
0  0.0  2.0  0.0  0.0
1  3.0  4.0  0.0  1.0
2  0.0  0.0  0.0  NaN
3  0.0  3.0  0.0  4.0

-- Example 32289
>>> df = pd.DataFrame(dict(age=[5, 6, np.nan],
...                   born=[pd.NaT, pd.Timestamp('1939-05-27'),
...                         pd.Timestamp('1940-04-25')],
...                   name=['Alfred', 'Batman', ''],
...                   toy=[None, 'Batmobile', 'Joker']))
>>> df
   age       born    name        toy
0  5.0        NaT  Alfred       None
1  6.0 1939-05-27  Batman  Batmobile
2  NaN 1940-04-25              Joker

-- Example 32290
>>> df.isna()
     age   born   name    toy
0  False   True  False   True
1  False  False  False  False
2   True  False  False  False

-- Example 32291
>>> df = pd.DataFrame(dict(age=[5, 6, np.nan],
...                   born=[pd.NaT, pd.Timestamp('1939-05-27'),
...                         pd.Timestamp('1940-04-25')],
...                   name=['Alfred', 'Batman', ''],
...                   toy=[None, 'Batmobile', 'Joker']))
>>> df
   age       born    name        toy
0  5.0        NaT  Alfred       None
1  6.0 1939-05-27  Batman  Batmobile
2  NaN 1940-04-25              Joker

-- Example 32292
>>> df.isna()
     age   born   name    toy
0  False   True  False   True
1  False  False  False  False
2   True  False  False  False

-- Example 32293
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

-- Example 32294
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

-- Example 32295
>>> df = pd.DataFrame({'A': [0, 1, 2, 3, 4], 'B': [5, 6, 7, 8, 9]})
>>> df.replace(0, 5)
   A  B
0  5  5
1  1  6
2  2  7
3  3  8
4  4  9

-- Example 32296
>>> df.replace([0, 1, 2, 3], 4)
   A  B
0  4  5
1  4  6
2  4  7
3  4  8
4  4  9

-- Example 32297
>>> df.replace([0, 1, 2, 3], [4, 3, 2, 1])
   A  B
0  4  5
1  3  6
2  2  7
3  1  8
4  4  9

-- Example 32298
>>> df.replace({0: 10, 1: 100})
     A  B
0   10  5
1  100  6
2    2  7
3    3  8
4    4  9

-- Example 32299
>>> df = pd.DataFrame({'A': [0, 1, 2, 3, 4], 'B': [5, 6, 7, 8, 9], 'C': ['a', 'b', 'c', 'd', 'e']})
>>> df.replace({'A': 0, 'B': 5}, 100)
     A    B  C
0  100  100  a
1    1    6  b
2    2    7  c
3    3    8  d
4    4    9  e

-- Example 32300
>>> df.replace({'A': {0: 100, 4: 400}})
     A  B  C
0  100  5  a
1    1  6  b
2    2  7  c
3    3  8  d
4  400  9  e

-- Example 32301
>>> df = pd.DataFrame({'A': ['bat', 'foo', 'bait'],
...                    'B': ['abc', 'bar', 'xyz']})
>>> df.replace(to_replace=r'^ba.$', value='new', regex=True)
      A    B
0   new  abc
1   foo  new
2  bait  xyz

-- Example 32302
>>> df.replace({'A': r'^ba.$'}, {'A': 'new'}, regex=True)
      A    B
0   new  abc
1   foo  bar
2  bait  xyz

-- Example 32303
>>> df.replace(regex=r'^ba.$', value='new')
      A    B
0   new  abc
1   foo  new
2  bait  xyz

-- Example 32304
>>> df.replace(regex={r'^ba.$': 'new', 'foo': 'xyz'})
      A    B
0   new  abc
1   xyz  new
2  bait  xyz

-- Example 32305
>>> df.replace(regex=[r'^ba.$', 'foo'], value='new')
      A    B
0   new  abc
1   new  new
2  bait  xyz

-- Example 32306
>>> df = pd.DataFrame({'A': [0, 1, 2, 3, 4],
...                    'B': ['a', 'b', 'c', 'd', 'e'],
...                    'C': ['f', 'g', 'h', 'i', 'j']})

-- Example 32307
>>> df.replace(to_replace='^[a-g]', value='e', regex=True)
     A  B  C
0  0.0  e  e
1  1.0  e  e
2  2.0  e  h
3  3.0  e  i
4  4.0  e  j

-- Example 32308
>>> df.replace(to_replace={'B': '^[a-c]', 'C': '^[h-j]'}, value='e', regex=True)
   A  B  C
0  0  e  f
1  1  e  g
2  2  e  e
3  3  d  e
4  4  e  e

-- Example 32309
>>> df = pd.DataFrame({'A': {0: 'a', 1: 'b', 2: 'c'},
...           'B': {0: 1, 1: 3, 2: 5},
...           'C': {0: 2, 1: 4, 2: 6}})
>>> df
   A  B  C
0  a  1  2
1  b  3  4
2  c  5  6

-- Example 32310
>>> df.melt()
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

-- Example 32311
>>> df = pd.DataFrame({'A': {0: 'a', 1: 'b', 2: 'c'},
...           'B': {0: 1, 1: 3, 2: 5},
...           'C': {0: 2, 1: 4, 2: 6}})
>>> df.melt(id_vars=['A'], value_vars=['B'], var_name='myVarname', value_name='myValname')
   A myVarname  myValname
0  a         B          1
1  b         B          3
2  c         B          5

-- Example 32312
>>> df = pd.DataFrame({'population': [59000000, 65000000, 434000,
...                                   434000, 434000, 337000, 11300,
...                                   11300, 11300],
...                    'GDP': [1937894, 2583560 , 12011, 4520, 12128,
...                            17036, 182, 38, 311],
...                    'alpha-2': ["IT", "FR", "MT", "MV", "BN",
...                                "IS", "NR", "TV", "AI"]},
...                   index=["Italy", "France", "Malta",
...                          "Maldives", "Brunei", "Iceland",
...                          "Nauru", "Tuvalu", "Anguilla"])
>>> df
          population      GDP alpha-2
Italy       59000000  1937894      IT
France      65000000  2583560      FR
Malta         434000    12011      MT
Maldives      434000     4520      MV
Brunei        434000    12128      BN
Iceland       337000    17036      IS
Nauru          11300      182      NR
Tuvalu         11300       38      TV
Anguilla       11300      311      AI

-- Example 32313
>>> df.nlargest(3, 'population')
        population      GDP alpha-2
France    65000000  2583560      FR
Italy     59000000  1937894      IT
Malta       434000    12011      MT

-- Example 32314
>>> df.nlargest(3, 'population', keep='last')
        population      GDP alpha-2
France    65000000  2583560      FR
Italy     59000000  1937894      IT
Brunei      434000    12128      BN

-- Example 32315
>>> df.nlargest(3, 'population', keep='all')  
          population      GDP alpha-2
France      65000000  2583560      FR
Italy       59000000  1937894      IT
Malta         434000    12011      MT
Maldives      434000     4520      MV
Brunei        434000    12128      BN

-- Example 32316
>>> df.nlargest(5, 'population', keep='all')  
          population      GDP alpha-2
France      65000000  2583560      FR
Italy       59000000  1937894      IT
Malta         434000    12011      MT
Maldives      434000     4520      MV
Brunei        434000    12128      BN

-- Example 32317
>>> df.nlargest(3, ['population', 'GDP'])
        population      GDP alpha-2
France    65000000  2583560      FR
Italy     59000000  1937894      IT
Brunei      434000    12128      BN

-- Example 32318
>>> df = pd.DataFrame({'population': [59000000, 65000000, 434000,
...                                   434000, 434000, 337000, 337000,
...                                   11300, 11300],
...                    'GDP': [1937894, 2583560 , 12011, 4520, 12128,
...                            17036, 182, 38, 311],
...                    'alpha-2': ["IT", "FR", "MT", "MV", "BN",
...                                "IS", "NR", "TV", "AI"]},
...                   index=["Italy", "France", "Malta",
...                          "Maldives", "Brunei", "Iceland",
...                          "Nauru", "Tuvalu", "Anguilla"])
>>> df
          population      GDP alpha-2
Italy       59000000  1937894      IT
France      65000000  2583560      FR
Malta         434000    12011      MT
Maldives      434000     4520      MV
Brunei        434000    12128      BN
Iceland       337000    17036      IS
Nauru         337000      182      NR
Tuvalu         11300       38      TV
Anguilla       11300      311      AI

-- Example 32319
>>> df.nsmallest(3, 'population')
          population    GDP alpha-2
Tuvalu         11300     38      TV
Anguilla       11300    311      AI
Iceland       337000  17036      IS

-- Example 32320
>>> df.nsmallest(3, 'population', keep='last')
          population  GDP alpha-2
Anguilla       11300  311      AI
Tuvalu         11300   38      TV
Nauru         337000  182      NR

-- Example 32321
>>> df.nsmallest(3, 'population', keep='all')  
          population    GDP alpha-2
Tuvalu         11300     38      TV
Anguilla       11300    311      AI
Iceland       337000  17036      IS
Nauru         337000    182      NR

-- Example 32322
>>> df.nsmallest(4, 'population', keep='all')  
          population    GDP alpha-2
Tuvalu         11300     38      TV
Anguilla       11300    311      AI
Iceland       337000  17036      IS
Nauru         337000    182      NR

-- Example 32323
>>> df.nsmallest(3, ['population', 'GDP'])
          population  GDP alpha-2
Tuvalu         11300   38      TV
Anguilla       11300  311      AI
Nauru         337000  182      NR

-- Example 32324
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
>>> df.pivot(index='foo', columns='bar', values='baz')  
bar  A  B  C
foo
one  1  2  3
two  4  5  6
>>> df.pivot(index='foo', columns='bar')['baz']  
bar  A  B  C
foo
one  1  2  3
two  4  5  6
>>> df.pivot(index='foo', columns='bar', values=['baz', 'zoo'])  
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
>>> df.pivot(index="lev1", columns=["lev2", "lev3"], values="values")  
lev2  1       2
lev3  1  2    1    2
lev1
1     0  1  2.0  NaN
2     4  3  NaN  5.0
>>> df.pivot(index=["lev1", "lev2"], columns=["lev3"], values="values")  
lev3         1    2
lev1 lev2
1    1     0.0  1.0
     2     2.0  NaN
2    1     4.0  3.0
     2     NaN  5.0

-- Example 32325
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

-- Example 32326
>>> table = df.pivot_table(values='D', index=['A', 'B'],
...                        columns=['C'], aggfunc="sum")
>>> table  
C        large  small
A   B
bar one    4.0      5
    two    7.0      6
foo one    4.0      1
    two    NaN      6

-- Example 32327
>>> table = df.pivot_table(values='D', index=['A', 'B'],
...                        columns=['C'], aggfunc="sum", fill_value=0)
>>> table  
C        large  small
A   B
bar one    4.0      5
    two    7.0      6
foo one    4.0      1
    two    NaN      6

-- Example 32328
>>> table = df.pivot_table(values=['D', 'E'], index=['A', 'C'],
...                        aggfunc={'D': "mean", 'E': "mean"})
>>> table  
                  D         E
                  D         E
A   C
bar large  5.500000  7.500000
    small  5.500000  8.500000
foo large  2.000000  4.500000
    small  2.333333  4.333333

-- Example 32329
>>> table = df.pivot_table(values=['D', 'E'], index=['A', 'C'],
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

-- Example 32330
>>> df = pd.DataFrame({
...     'col1': ['A', 'A', 'B', np.nan, 'D', 'C'],
...     'col2': [2, 1, 9, 8, 7, 4],
...     'col3': [0, 1, 9, 4, 2, 3],
...     'col4': ['a', 'B', 'c', 'D', 'e', 'F']
... })
>>> df
   col1  col2  col3 col4
0     A     2     0    a
1     A     1     1    B
2     B     9     9    c
3  None     8     4    D
4     D     7     2    e
5     C     4     3    F

-- Example 32331
>>> df.sort_values(by=['col1'])
   col1  col2  col3 col4
0     A     2     0    a
1     A     1     1    B
2     B     9     9    c
5     C     4     3    F
4     D     7     2    e
3  None     8     4    D

-- Example 32332
>>> df.sort_values(by=['col1', 'col2'])
   col1  col2  col3 col4
1     A     1     1    B
0     A     2     0    a
2     B     9     9    c
5     C     4     3    F
4     D     7     2    e
3  None     8     4    D

