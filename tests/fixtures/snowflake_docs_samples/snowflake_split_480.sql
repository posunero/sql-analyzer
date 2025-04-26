-- Example 32132
>>> df.all(axis='columns')
0     True
1    False
dtype: bool

-- Example 32133
>>> df.all(axis=None)  
False

-- Example 32134
>>> pd.Series([False, False]).any()  
False
>>> pd.Series([True, False]).any()  
True

-- Example 32135
>>> df = pd.DataFrame({"A": [1, 2], "B": [0, 2], "C": [0, 0]})
>>> df
   A  B  C
0  1  0  0
1  2  2  0

-- Example 32136
>>> df.any()
A     True
B     True
C    False
dtype: bool

-- Example 32137
>>> df = pd.DataFrame({"A": [True, False], "B": [1, 2]})
>>> df
       A  B
0   True  1
1  False  2

-- Example 32138
>>> df.any(axis='columns')
0    True
1    True
dtype: bool

-- Example 32139
>>> df = pd.DataFrame({"A": [True, False], "B": [1, 0]})
>>> df
       A  B
0   True  1
1  False  0

-- Example 32140
>>> df.any(axis='columns')
0     True
1    False
dtype: bool

-- Example 32141
>>> df.any(axis=None)  
True

-- Example 32142
>>> pd.DataFrame([]).any()
Series([], dtype: bool)

-- Example 32143
>>> df = pd.DataFrame({"Person":
...                    ["John", "Myla", "Lewis", "John", "Myla"],
...                    "Age": [24., np.nan, 21., 33, 26],
...                    "Single": [False, True, True, True, False]})
>>> df   
   Person   Age  Single
0    John  24.0   False
1    Myla   NaN    True
2   Lewis  21.0    True
3    John  33.0    True
4    Myla  26.0   False

-- Example 32144
>>> df.count()
Person    5
Age       4
Single    5
dtype: int64

-- Example 32145
>>> s = pd.Series([2, np.nan, 5, -1, 0])
>>> s
0    2.0
1    NaN
2    5.0
3   -1.0
4    0.0
dtype: float64

-- Example 32146
>>> s.cummax()
0    2.0
1    NaN
2    5.0
3    5.0
4    5.0
dtype: float64

-- Example 32147
>>> s.cummax(skipna=False)
0    2.0
1    NaN
2    NaN
3    NaN
4    NaN
dtype: float64

-- Example 32148
>>> df = pd.DataFrame([[2.0, 1.0], [3.0, np.nan], [1.0, 0.0]], columns=list('AB'))
>>> df
     A    B
0  2.0  1.0
1  3.0  NaN
2  1.0  0.0

-- Example 32149
>>> df.cummax()
     A    B
0  2.0  1.0
1  3.0  NaN
2  3.0  1.0

-- Example 32150
>>> s = pd.Series([2, np.nan, 5, -1, 0])
>>> s
0    2.0
1    NaN
2    5.0
3   -1.0
4    0.0
dtype: float64

-- Example 32151
>>> s.cummin()
0    2.0
1    NaN
2    2.0
3   -1.0
4   -1.0
dtype: float64

-- Example 32152
>>> s.cummin(skipna=False)
0    2.0
1    NaN
2    NaN
3    NaN
4    NaN
dtype: float64

-- Example 32153
>>> df = pd.DataFrame([[2.0, 1.0], [3.0, np.nan], [1.0, 0.0]], columns=list('AB'))
>>> df
     A    B
0  2.0  1.0
1  3.0  NaN
2  1.0  0.0

-- Example 32154
>>> df.cummin()
     A    B
0  2.0  1.0
1  2.0  NaN
2  1.0  0.0

-- Example 32155
>>> s = pd.Series([2, np.nan, 5, -1, 0])
>>> s
0    2.0
1    NaN
2    5.0
3   -1.0
4    0.0
dtype: float64

-- Example 32156
>>> s.cumsum()
0    2.0
1    NaN
2    7.0
3    6.0
4    6.0
dtype: float64

-- Example 32157
>>> s.cumsum(skipna=False)
0    2.0
1    NaN
2    NaN
3    NaN
4    NaN
dtype: float64

-- Example 32158
>>> df = pd.DataFrame([[2.0, 1.0], [3.0, np.nan], [1.0, 0.0]], columns=list('AB'))
>>> df
     A    B
0  2.0  1.0
1  3.0  NaN
2  1.0  0.0

-- Example 32159
>>> df.cumsum()
     A    B
0  2.0  1.0
1  5.0  NaN
2  6.0  1.0

-- Example 32160
>>> df = pd.DataFrame({'numeric': [1, 2, 3],
...                    'object': ['a', 'b', 'c']
...                   })
>>> df.describe(include='all') 
        numeric object
count       3.0      3
unique      NaN      3
top         NaN      a
freq        NaN      1
mean        2.0   None
std         1.0   None
min         1.0   None
25%         1.5   None
50%         2.0   None
75%         2.5   None
max         3.0   None

-- Example 32161
>>> pd.DataFrame({'numeric': [1, 2, 3], 'object': ['a', 'b', 'c']}).describe(include='number') 
       numeric
count      3.0
mean       2.0
std        1.0
min        1.0
25%        1.5
50%        2.0
75%        2.5
max        3.0

-- Example 32162
>>> pd.DataFrame({'numeric': [1, 2, 3], 'object': ['a', 'b', 'c']}).describe(exclude='number') 
       object
count       3
unique      3
top         a
freq        1

-- Example 32163
>>> df = pd.DataFrame({'a': [1, 2, 3, 4, 5, 6],
...                    'b': [1, 1, 2, 3, 5, 8],
...                    'c': [1, 4, 9, 16, 25, 36]})
>>> df 
   a  b   c
0  1  1   1
1  2  1   4
2  3  2   9
3  4  3  16
4  5  5  25
5  6  8  36

-- Example 32164
>>> df.diff() 
    a    b     c
0  NaN  NaN   NaN
1  1.0  0.0   3.0
2  1.0  1.0   5.0
3  1.0  1.0   7.0
4  1.0  2.0   9.0
5  1.0  3.0  11.0

-- Example 32165
>>> df.diff(axis=1) 
    a   b   c
0 None  0   0
1 None -1   3
2 None -1   7
3 None -1  13
4 None  0  20
5 None  2  28

-- Example 32166
>>> df.diff(periods=3) 
    a    b     c
0  NaN  NaN   NaN
1  NaN  NaN   NaN
2  NaN  NaN   NaN
3  3.0  2.0  15.0
4  3.0  4.0  21.0
5  3.0  6.0  27.0

-- Example 32167
>>> df.diff(periods=-1) 
    a    b     c
0 -1.0  0.0  -3.0
1 -1.0 -1.0  -5.0
2 -1.0 -1.0  -7.0
3 -1.0 -2.0  -9.0
4 -1.0 -3.0 -11.0
5  NaN  NaN   NaN

-- Example 32168
>>> idx = pd.MultiIndex.from_arrays([
...     ['warm', 'warm', 'cold', 'cold'],
...     ['dog', 'falcon', 'fish', 'spider']],
...     names=['blooded', 'animal'])
>>> s = pd.Series([4, 2, 0, 8], name='legs', index=idx)
>>> s
blooded  animal
warm     dog       4
         falcon    2
cold     fish      0
         spider    8
Name: legs, dtype: int64

-- Example 32169
>>> s.max()  
8

-- Example 32170
>>> idx = pd.MultiIndex.from_arrays([
...     ['warm', 'warm', 'cold', 'cold'],
...     ['dog', 'falcon', 'fish', 'spider']],
...     names=['blooded', 'animal'])
>>> s = pd.Series([4, 2, 0, 8], name='legs', index=idx)
>>> s
blooded  animal
warm     dog       4
         falcon    2
cold     fish      0
         spider    8
Name: legs, dtype: int64

-- Example 32171
>>> s.mean()  
3.5

-- Example 32172
>>> idx = pd.MultiIndex.from_arrays([
...     ['warm', 'warm', 'cold', 'cold'],
...     ['dog', 'falcon', 'fish', 'spider']],
...     names=['blooded', 'animal'])
>>> s = pd.Series([4, 2, 0, 8], name='legs', index=idx)
>>> s
blooded  animal
warm     dog       4
         falcon    2
cold     fish      0
         spider    8
Name: legs, dtype: int64

-- Example 32173
>>> s.median()  
3.0

-- Example 32174
>>> idx = pd.MultiIndex.from_arrays([
...     ['warm', 'warm', 'cold', 'cold'],
...     ['dog', 'falcon', 'fish', 'spider']],
...     names=['blooded', 'animal'])
>>> s = pd.Series([4, 2, 0, 8], name='legs', index=idx)
>>> s
blooded  animal
warm     dog       4
         falcon    2
cold     fish      0
         spider    8
Name: legs, dtype: int64

-- Example 32175
>>> s.min()  
0

-- Example 32176
>>> s = pd.Series([90, 91, 85])
>>> s
0    90
1    91
2    85
dtype: int64

-- Example 32177
>>> s.pct_change()
0         NaN
1    0.011111
2   -0.065934
dtype: float64

-- Example 32178
>>> s.pct_change(periods=2)
0         NaN
1         NaN
2   -0.055556
dtype: float64

-- Example 32179
>>> s = pd.Series([90, 91, None, 85])
>>> s
0    90.0
1    91.0
2     NaN
3    85.0
dtype: float64

-- Example 32180
>>> s.ffill().pct_change()
0         NaN
1    0.011111
2    0.000000
3   -0.065934
dtype: float64

-- Example 32181
>>> df = pd.DataFrame({
...     'FR': [4.0405, 4.0963, 4.3149],
...     'GR': [1.7246, 1.7482, 1.8519],
...     'IT': [804.74, 810.01, 860.13]},
...     index=['1980-01-01', '1980-02-01', '1980-03-01'])
>>> df
                FR      GR      IT
1980-01-01  4.0405  1.7246  804.74
1980-02-01  4.0963  1.7482  810.01
1980-03-01  4.3149  1.8519  860.13

-- Example 32182
>>> df.pct_change()
                  FR        GR        IT
1980-01-01       NaN       NaN       NaN
1980-02-01  0.013810  0.013684  0.006549
1980-03-01  0.053365  0.059318  0.061876

-- Example 32183
>>> df = pd.DataFrame({
...     '2016': [1769950, 30586265],
...     '2015': [1500923, 40912316],
...     '2014': [1371819, 41403351]},
...     index=['GOOG', 'APPL'])
>>> df
          2016      2015      2014
GOOG   1769950   1500923   1371819
APPL  30586265  40912316  41403351

-- Example 32184
>>> df.pct_change(axis='columns', periods=-1)
          2016      2015  2014
GOOG  0.179241  0.094112   NaN
APPL -0.252395 -0.011860   NaN

-- Example 32185
>>> df = pd.DataFrame(np.array([[1, 1], [2, 10], [3, 100], [4, 100]]), columns=['a', 'b'])

-- Example 32186
>>> df.quantile(.1) 
a    1.3
b    3.7
Name: 0.1, dtype: float64

-- Example 32187
>>> df.quantile([.1, .5]) 
       a     b
0.1  1.3   3.7
0.5  2.5  55.0

-- Example 32188
>>> df = pd.DataFrame({"a": [None, 0, 25, 50, 75, 100, np.nan]})
>>> df.quantile([0, 0.25, 0.5, 0.75, 1]) 
          a
0.00    0.0
0.25   25.0
0.50   50.0
0.75   75.0
1.00  100.0

-- Example 32189
>>> df = pd.DataFrame({'A': [0, 1, 2],
...           'B': [1, 2, 1],
...           'C': [3, 4, 5]})
>>> df.skew()
A    0.000000
B    1.732059
C    0.000000
dtype: float64

-- Example 32190
>>> idx = pd.MultiIndex.from_arrays([
...     ['warm', 'warm', 'cold', 'cold'],
...     ['dog', 'falcon', 'fish', 'spider']],
...     names=['blooded', 'animal'])
>>> s = pd.Series([4, 2, 0, 8], name='legs', index=idx)
>>> s
blooded  animal
warm     dog       4
         falcon    2
cold     fish      0
         spider    8
Name: legs, dtype: int64

-- Example 32191
>>> s.sum()  
14

-- Example 32192
>>> pd.Series([], dtype="float64").sum()  # min_count=0 is the default  
0.0

-- Example 32193
>>> pd.Series([], dtype="float64").sum(min_count=1)  
nan

-- Example 32194
>>> pd.Series([np.nan]).sum()  
0.0

-- Example 32195
>>> pd.Series([np.nan]).sum(min_count=1)  
nan

-- Example 32196
>>> df = pd.DataFrame({'person_id': [0, 1, 2, 3],
...                   'age': [21, 25, 62, 43],
...                   'height': [1.61, 1.87, 1.49, 2.01]}
...                  ).set_index('person_id')
>>> df    
           age  height
person_id
0           21    1.61
1           25    1.87
2           62    1.49
3           43    2.01

-- Example 32197
>>> df.std()
age       18.786076
height     0.237417
dtype: float64

-- Example 32198
>>> df.std(ddof=0)
age       16.269219
height     0.205609
dtype: float64

