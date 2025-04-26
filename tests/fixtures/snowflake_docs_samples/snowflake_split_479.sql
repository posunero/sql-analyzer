-- Example 32065
>>> df.loc[('cobra', 'mark ii')]
max_speed    0
shield       4
Name: ('cobra', 'mark ii'), dtype: int64

-- Example 32066
>>> df.loc['cobra', 'mark i']
max_speed    12
shield        2
Name: ('cobra', 'mark i'), dtype: int64

-- Example 32067
>>> df.loc[[('cobra', 'mark ii')]]
               max_speed  shield
cobra mark ii          0       4

-- Example 32068
>>> df.loc[('cobra', 'mark i'), 'shield']  
2

-- Example 32069
>>> df.loc[('cobra', 'mark i'):'viper']
                     max_speed  shield
cobra      mark i           12       2
           mark ii           0       4
sidewinder mark i           10      20
           mark ii           1       4
viper      mark ii           7       1
           mark iii         16      36

-- Example 32070
>>> df.loc[('cobra', 'mark i'):('viper', 'mark ii')]
                    max_speed  shield
cobra      mark i          12       2
           mark ii          0       4
sidewinder mark i          10      20
           mark ii          1       4
viper      mark ii          7       1

-- Example 32071
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

-- Example 32072
>>> df.loc[:, list("ABC")] = pd.Series([1, 3, 5], index=list("CAB"))
>>> df
   A  B  C
0  3  5  1
1  3  5  1

-- Example 32073
>>> df.loc[:, "A":"B"] = pd.Series([10, 20, 30], index=list("ABC"))
>>> df
    A   B  C
0  10  20  1
1  10  20  1

-- Example 32074
>>> mydict = [{'a': 1, 'b': 2, 'c': 3, 'd': 4},
...           {'a': 100, 'b': 200, 'c': 300, 'd': 400},
...           {'a': 1000, 'b': 2000, 'c': 3000, 'd': 4000}]
>>> df = pd.DataFrame(mydict)
>>> df
      a     b     c     d
0     1     2     3     4
1   100   200   300   400
2  1000  2000  3000  4000

-- Example 32075
>>> type(df.iloc[0])
<class 'modin.pandas.series.Series'>
>>> df.iloc[0]
a    1
b    2
c    3
d    4
Name: 0, dtype: int64

-- Example 32076
>>> df.iloc[-1]
a    1000
b    2000
c    3000
d    4000
Name: 2, dtype: int64

-- Example 32077
>>> df.iloc[[0]]
   a  b  c  d
0  1  2  3  4

-- Example 32078
>>> df.iloc[[0, 1]]
     a    b    c    d
0    1    2    3    4
1  100  200  300  400

-- Example 32079
>>> df.iloc[[0, 1, 10, 11]]
     a    b    c    d
0    1    2    3    4
1  100  200  300  400

-- Example 32080
>>> df.iloc[[10, 11, 12]]
Empty DataFrame
Columns: [a, b, c, d]
Index: []

-- Example 32081
>>> df.iloc[:3]
      a     b     c     d
0     1     2     3     4
1   100   200   300   400
2  1000  2000  3000  4000

-- Example 32082
>>> df.iloc[[True, False, True]]
      a     b     c     d
0     1     2     3     4
2  1000  2000  3000  4000

-- Example 32083
>>> df.iloc[[True, False]]      
      a     b     c     d
0     1     2     3     4

-- Example 32084
>>> df.iloc[[True, False, True, True, True]]      
      a     b     c     d
0     1     2     3     4
2  1000  2000  3000  4000

-- Example 32085
>>> df.iloc[lambda x: x.index % 2 == 0]
      a     b     c     d
0     1     2     3     4
2  1000  2000  3000  4000

-- Example 32086
>>> df.iloc[0, 1]  
2

-- Example 32087
>>> df.iloc[[0, 2], [1, 3]]
      b     d
0     2     4
2  2000  4000

-- Example 32088
>>> df.iloc[1:3, 0:3]
      a     b     c
1   100   200   300
2  1000  2000  3000

-- Example 32089
>>> df.iloc[:, [True, False, True, False]]
      a     c
0     1     3
1   100   300
2  1000  3000

-- Example 32090
>>> df.iloc[:, lambda df: [0, 2]]
      a     c
0     1     3
1   100   300
2  1000  3000

-- Example 32091
>>> df = pd.DataFrame({'col1': [1, 2], 'col2': [3, 4]})
>>> df
   col1  col2
0     1     3
1     2     4
>>> df.insert(1, "newcol", [99, 99])
>>> df
   col1  newcol  col2
0     1      99     3
1     2      99     4
>>> df.insert(0, "col1", [100, 100], allow_duplicates=True)
>>> df
   col1  col1  newcol  col2
0   100     1      99     3
1   100     2      99     4

-- Example 32092
>>> df.insert(0, "col0", pd.Series([5, 6], index=[1, 2]))
>>> df
   col0  col1  col1  newcol  col2
0   NaN   100     1      99     3
1   5.0   100     2      99     4

-- Example 32093
>>> df = pd.DataFrame([[1, 1.5], [2, 2.5], [3, 7.8]], columns=['int', 'float'])
>>> df
   int  float
0    1    1.5
1    2    2.5
2    3    7.8

-- Example 32094
>>> df = pd.DataFrame([[0, 2, 3], [0, 4, 1]], columns=['A', 'B', 'C'])
>>> df
   A  B  C
0  0  2  3
1  0  4  1

-- Example 32095
>>> df = pd.DataFrame({'species': ['bear', 'bear', 'marsupial'],
...                   'population': [1864, 22000, 80000]},
...                   index=['panda', 'polar', 'koala'])
>>> df
         species  population
panda       bear        1864
polar       bear       22000
koala  marsupial       80000
>>> for label, content in df.items():
...    print(f'label: {label}')
...    print(f'content:\n{content}')
...
label: species
content:
panda         bear
polar         bear
koala    marsupial
Name: species, dtype: object
label: population
content:
panda     1864
polar    22000
koala    80000
Name: population, dtype: int64

-- Example 32096
>>> df = pd.DataFrame({'num_legs': [4, 2], 'num_wings': [0, 2]}, index=['dog', 'hawk'])
>>> df
      num_legs  num_wings
dog          4          0
hawk         2          2
>>> for row in df.itertuples():
...     print(row)
...
Pandas(Index='dog', num_legs=4, num_wings=0)
Pandas(Index='hawk', num_legs=2, num_wings=2)

-- Example 32097
>>> df = pd.DataFrame([[1, 2], [4, 5], [7, 8]],
...      index=['cobra', 'viper', 'sidewinder'],
...      columns=['max_speed', 'shield'])
>>> df
            max_speed  shield
cobra               1       2
viper               4       5
sidewinder          7       8

-- Example 32098
>>> for row in df.itertuples():
...     print(row)
...
Pandas(Index='cobra', max_speed=1, shield=2)
Pandas(Index='viper', max_speed=4, shield=5)
Pandas(Index='sidewinder', max_speed=7, shield=8)

-- Example 32099
>>> df = pd.DataFrame({'num_legs': [2, 4], 'num_wings': [2, 0]},
...                   index=['falcon', 'dog'])
>>> df
        num_legs  num_wings
falcon         2          2
dog            4          0

-- Example 32100
>>> df.isin([0, 2])
        num_legs  num_wings
falcon      True       True
dog        False       True

-- Example 32101
>>> ~df.isin([0, 2])
        num_legs  num_wings
falcon     False      False
dog         True      False

-- Example 32102
>>> df.isin({'num_wings': [0, 3]})
        num_legs  num_wings
falcon     False      False
dog        False       True

-- Example 32103
>>> other = pd.DataFrame({'num_legs': [8, 3], 'num_wings': [0, 2]},
...                      index=['spider', 'falcon'])
>>> df.isin(other)
        num_legs  num_wings
falcon     False       True
dog        False      False

-- Example 32104
>>> df = pd.DataFrame(np.arange(10).reshape(-1, 2), columns=['A', 'B'])

-- Example 32105
>>> df  
   A  B
0  0  1
1  2  3
2  4  5
3  6  7
4  8  9

-- Example 32106
>>> m = df % 3 == 0
>>> df.where(m, -df)  
   A  B
0  0 -1
1 -2  3
2 -4 -5
3  6 -7
4 -8  9

-- Example 32107
>>> data = np.where(m, df, -df)
>>> df.where(m, -df) == pd.DataFrame(data, columns=['A', 'B'])  
      A     B
0  True  True
1  True  True
2  True  True
3  True  True
4  True  True

-- Example 32108
>>> df.where(m, -df) == df.mask(~m, -df)  
      A     B
0  True  True
1  True  True
2  True  True
3  True  True
4  True  True

-- Example 32109
>>> m = df % 3 == 0
>>> df.mask(m, -df)   
   A  B
0  0  1
1  2 -3
2  4  5
3 -6  7
4  8 -9

-- Example 32110
>>> data = np.where(~m, df, -df)
>>> df.mask(m, -df) == pd.DataFrame(data, columns=['A', 'B'])  
    A     B
0  True  True
1  True  True
2  True  True
3  True  True
4  True  True

-- Example 32111
>>> df.mask(m, -df) == df.where(~m, -df)  
    A     B
0  True  True
1  True  True
2  True  True
3  True  True
4  True  True

-- Example 32112
>>> df = pd.DataFrame([[1, 2.12], [3.356, 4.567]])
>>> df
       0      1
0  1.000  2.120
1  3.356  4.567

-- Example 32113
>>> df.applymap(lambda x: len(str(x)))
   0  1
0  3  4
1  5  5

-- Example 32114
>>> df.applymap(lambda x: x**2)
           0          1
0   1.000000   4.494400
1  11.262736  20.857489

-- Example 32115
>>> df ** 2
           0          1
0   1.000000   4.494400
1  11.262736  20.857489

-- Example 32116
>>> df = pd.DataFrame([[1, 2, 3],
...                    [4, 5, 6],
...                    [7, 8, 9],
...                    [np.nan, np.nan, np.nan]],
...                   columns=['A', 'B', 'C'])

-- Example 32117
>>> df.agg(['sum', 'min'])
        A     B     C
sum  12.0  15.0  18.0
min   1.0   2.0   3.0

-- Example 32118
>>> df.agg({'A' : ['sum', 'min'], 'B' : ['min', 'max']})
        A    B
sum  12.0  NaN
min   1.0  2.0
max   NaN  8.0

-- Example 32119
>>> df.agg("max", axis="columns")
0    3.0
1    6.0
2    9.0
3    NaN
dtype: float64

-- Example 32120
>>> df.agg({ 0: ["sum"], 1: ["min"] }, axis=1)
   sum  min
0  6.0  NaN
1  NaN  4.0

-- Example 32121
>>> df = pd.DataFrame([[1, 2, 3],
...                    [4, 5, 6],
...                    [7, 8, 9],
...                    [np.nan, np.nan, np.nan]],
...                   columns=['A', 'B', 'C'])

-- Example 32122
>>> df.agg(['sum', 'min'])
        A     B     C
sum  12.0  15.0  18.0
min   1.0   2.0   3.0

-- Example 32123
>>> df.agg({'A' : ['sum', 'min'], 'B' : ['min', 'max']})
        A    B
sum  12.0  NaN
min   1.0  2.0
max   NaN  8.0

-- Example 32124
>>> df.agg("max", axis="columns")
0    3.0
1    6.0
2    9.0
3    NaN
dtype: float64

-- Example 32125
>>> df.agg({ 0: ["sum"], 1: ["min"] }, axis=1)
   sum  min
0  6.0  NaN
1  NaN  4.0

-- Example 32126
>>> d1 = {'col1': [1, 2, 3], 'col2': [3, 4, 5]}
>>> df = pd.DataFrame(data=d1)
>>> df
   col1  col2
0     1     3
1     2     4
2     3     5
>>> df.transform(lambda x: x + 1, axis=1)
   col1  col2
0     2     4
1     3     5
2     4     6

-- Example 32127
>>> df.transform(np.square, axis=1)
   col1  col2
0   1.0   9.0
1   4.0  16.0
2   9.0  25.0

-- Example 32128
>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]})
>>> df
   Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0

>>> df.groupby(['Animal']).mean()   
        Max Speed
Animal
Falcon      375.0
Parrot       25.0

**Hierarchical Indexes**

We can groupby different levels of a hierarchical index
using the `level` parameter:

>>> arrays = [['Falcon', 'Falcon', 'Parrot', 'Parrot'],
...           ['Captive', 'Wild', 'Captive', 'Wild']]
>>> index = pd.MultiIndex.from_arrays(arrays, names=('Animal', 'Type'))
>>> df = pd.DataFrame({'Max Speed': [390., 350., 30., 20.]},
...                   index=index)
>>> df      
                Max Speed
Animal Type
Falcon Captive      390.0
       Wild         350.0
Parrot Captive       30.0
       Wild          20.0

>>> df.groupby(level=0).mean()      
        Max Speed
Animal
Falcon      370.0
Parrot       25.0

>>> df.groupby(level="Type").mean()     
         Max Speed
Type
Captive      210.0
Wild         185.0

-- Example 32129
>>> pd.Series([True, True]).all()  
True
>>> pd.Series([True, False]).all()  
False

-- Example 32130
>>> df = pd.DataFrame({'col1': [True, True], 'col2': [True, False]})
>>> df
   col1   col2
0  True   True
1  True  False

-- Example 32131
>>> df.all()
col1     True
col2    False
dtype: bool

