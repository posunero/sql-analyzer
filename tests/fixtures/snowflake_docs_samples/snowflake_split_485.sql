-- Example 32467
>>> df.groupby("a").cumsum()
          b  c
fox       8  2
gorilla  10  7
lion      6  9

-- Example 32468
>>> df = pd.DataFrame([[1, 2], [1, 4], [5, 6]],
...                   columns=['A', 'B'])
>>> df.groupby('A').head(1)
   A  B
0  1  2
2  5  6
>>> df.groupby('A').head(-1)
   A  B
0  1  2
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
>>> df.groupby("col1", dropna=False).head(2)
   col1  col2  col3  col4
a     Z     1    40    -1
b  None     2    50    -2
c     X     3    60    -3
d     Z     4    10    -4
e     Y     5    20    -5
f     X     6    30    -6
h  None     8    80    -8
j     Y    10    10   -10
>>> df.groupby("col1", dropna=False).head(-2)
  col1  col2  col3  col4
c    X     3    60    -3
f    X     6    30    -6

-- Example 32469
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

-- Example 32470
>>> df = pd.DataFrame(
...     data=small_df_data,
...     columns=("species", "speed", "age", "weight", "height"),
...     index=list("abcdefghijklmnopq"),
... )

-- Example 32471
>>> df.groupby("species").idxmax(axis=0, skipna=True)  
             speed age weight height
species
giraffe          k   k      h      k
hippopotamus     l   l      d      l
lion             q   q      q      a
rhino            m   n      n      m
tiger            g   b      e      b

-- Example 32472
>>> df.groupby("species").idxmax(axis=0, skipna=False)  
             speed   age weight height
species
giraffe          k     k      h      k
hippopotamus  None     l      d      l
lion             q  None      q   None
rhino            m     n      n      m
tiger            g     b      e      b

-- Example 32473
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

-- Example 32474
>>> df = pd.DataFrame(
...     data=small_df_data,
...     columns=("species", "speed", "age", "weight", "height"),
...     index=list("abcdefghijklmnopq"),
... )

-- Example 32475
>>> df.groupby("species").idxmin(axis=0, skipna=True)  
             speed age weight height
species
giraffe          p   c      p      c
hippopotamus     l   d      l      d
lion             i   i      i      i
rhino            n   m      m      n
tiger            f   g      b      g

-- Example 32476
>>> df.groupby("species").idxmin(axis=0, skipna=False)  
             speed   age weight height
species
giraffe          p     c      p      c
hippopotamus  None     d      l      d
lion             i  None      i   None
rhino            n     m      m      n
tiger            f     g      b      g

-- Example 32477
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

-- Example 32478
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

-- Example 32479
>>> df = pd.DataFrame({'A': [1, 1, 2, 1, 2],
...                    'B': [np.nan, 2, 3, 4, 5],
...                    'C': [1, 2, 1, 1, 2]}, columns=['A', 'B', 'C'])

-- Example 32480
>>> df.groupby('A').mean()      
     B         C
A
1  3.0  1.333333
2  4.0  1.500000

-- Example 32481
>>> df.groupby(['A', 'B']).mean()   
         C
A B
1 2.0  2.0
  4.0  1.0
2 3.0  1.0
  5.0  2.0

-- Example 32482
>>> df.groupby('A')['B'].mean()
A
1    3.0
2    4.0
Name: B, dtype: float64

-- Example 32483
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

-- Example 32484
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

-- Example 32485
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

-- Example 32486
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

-- Example 32487
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

-- Example 32488
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

-- Example 32489
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

-- Example 32490
>>> lst = ['a', 'a', 'b', 'b']
>>> ser = pd.Series([1, 2, 3, 4], index=lst)

-- Example 32491
>>> ser
a    1
a    2
b    3
b    4
dtype: int64

-- Example 32492
>>> ser.groupby(level=0).shift(1)
a    NaN
a    1.0
b    NaN
b    3.0
dtype: float64

-- Example 32493
>>> data = [[1, 2, 3], [1, 5, 6], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["tuna", "salmon", "catfish", "goldfish"])

-- Example 32494
>>> df
          a  b  c
tuna      1  2  3
salmon    1  5  6
catfish   2  5  8
goldfish  2  6  9

-- Example 32495
>>> df.groupby("a").shift(1)
            b    c
tuna      NaN  NaN
salmon    2.0  3.0
catfish   NaN  NaN
goldfish  5.0  8.0

-- Example 32496
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

-- Example 32497
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

-- Example 32498
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

-- Example 32499
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

-- Example 32500
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

-- Example 32501
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

-- Example 32502
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

-- Example 32503
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

-- Example 32504
>>> df = pd.DataFrame({
...     'gender': ['male', 'male', 'female', 'male', 'female', 'male'],
...     'education': ['low', 'medium', 'high', 'low', 'high', 'low'],
...     'country': ['US', 'FR', 'US', 'FR', 'FR', 'FR']
... })

-- Example 32505
>>> df  
        gender  education   country
0       male    low         US
1       male    medium      FR
2       female  high        US
3       male    low         FR
4       female  high        FR
5       male    low         FR

-- Example 32506
>>> df.groupby('gender').value_counts()  
gender  education  country
female  high       FR         1
                   US         1
male    low        FR         2
                   US         1
        medium     FR         1
Name: count, dtype: int64

-- Example 32507
>>> df.groupby('gender').value_counts(ascending=True)  
gender  education  country
female  high       FR         1
                   US         1
male    low        US         1
        medium     FR         1
        low        FR         2
Name: count, dtype: int64

-- Example 32508
>>> df.groupby('gender').value_counts(normalize=True)  
gender  education  country
female  high       FR         0.50
                   US         0.50
male    low        FR         0.50
                   US         0.25
        medium     FR         0.25
Name: proportion, dtype: float64

-- Example 32509
>>> df.groupby('gender', as_index=False).value_counts()  
   gender education country  count
0  female      high      FR      1
1  female      high      US      1
2    male       low      FR      2
3    male       low      US      1
4    male    medium      FR      1

-- Example 32510
>>> df.groupby('gender', as_index=False).value_counts(normalize=True)  
   gender education country  proportion
0  female      high      FR        0.50
1  female      high      US        0.50
2    male       low      FR        0.50
3    male       low      US        0.25
4    male    medium      FR        0.25

-- Example 32511
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

-- Example 32512
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

-- Example 32513
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

-- Example 32514
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

-- Example 32515
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

-- Example 32516
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

-- Example 32517
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

-- Example 32518
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

-- Example 32519
self.apply(lambda x: pd.Series(np.arange(len(x)), x.index))

-- Example 32520
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

-- Example 32521
>>> df.groupby('A').cumcount()
0    0
1    1
2    2
3    0
4    1
5    3
dtype: int64

-- Example 32522
>>> df.groupby('A').cumcount(ascending=False)
0    3
1    2
2    1
3    1
4    0
5    0
dtype: int64

-- Example 32523
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

-- Example 32524
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

-- Example 32525
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

-- Example 32526
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

-- Example 32527
>>> lst = ['a', 'a', 'b']
>>> ser = pd.Series([6, 2, 0], index=lst)
>>> ser
a    6
a    2
b    0
dtype: int64

-- Example 32528
>>> ser.groupby(level=0).cumsum()
a    6
a    8
b    0
dtype: int64

-- Example 32529
>>> data = [[1, 8, 2], [1, 2, 5], [2, 6, 9]]
>>> df = pd.DataFrame(data, columns=["a", "b", "c"],
...                   index=["fox", "gorilla", "lion"])
>>> df
         a  b  c
fox      1  8  2
gorilla  1  2  5
lion     2  6  9

-- Example 32530
>>> df.groupby("a").groups
{1: ['fox', 'gorilla'], 2: ['lion']}

-- Example 32531
>>> df.groupby("a").cumsum()
          b  c
fox       8  2
gorilla  10  7
lion      6  9

-- Example 32532
>>> df = pd.DataFrame([[1, 2], [1, 4], [5, 6]],
...                   columns=['A', 'B'])
>>> df.groupby('A').head(1)
   A  B
0  1  2
2  5  6
>>> df.groupby('A').head(-1)
   A  B
0  1  2
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
>>> df.groupby("col1", dropna=False).head(2)
   col1  col2  col3  col4
a     Z     1    40    -1
b  None     2    50    -2
c     X     3    60    -3
d     Z     4    10    -4
e     Y     5    20    -5
f     X     6    30    -6
h  None     8    80    -8
j     Y    10    10   -10
>>> df.groupby("col1", dropna=False).head(-2)
  col1  col2  col3  col4
c    X     3    60    -3
f    X     6    30    -6

-- Example 32533
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

