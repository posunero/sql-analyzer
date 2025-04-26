-- Example 31663
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

-- Example 31664
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
>>> a.rfloordiv(b)
a   -1.0
b   -2.0
c    0.0
d    NaN
f    NaN
dtype: float64

-- Example 31665
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
>>> a.rmod(b)
a    0.0
b    1.0
c    NaN
d    NaN
f    NaN
dtype: float64

-- Example 31666
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
>>> a.rpow(b)
a   -2.0
b    1.0
c    1.0
d    NaN
f    1.0
dtype: float64

-- Example 31667
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
>>> a.lt(b)
a    False
b     True
c     True
d     None
f     None
dtype: object

-- Example 31668
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
>>> a.gt(b)
a     True
b    False
c    False
d     None
f     None
dtype: object

-- Example 31669
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
>>> a.le(b)
a    False
b     True
c     True
d     None
f     None
dtype: object

-- Example 31670
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
>>> a.ge(b)
a     True
b    False
c    False
d     None
f     None
dtype: object

-- Example 31671
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
>>> a.ne(b)
a    True
b    True
c    True
d    None
f    None
dtype: object

-- Example 31672
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
>>> a.eq(b)
a    False
b    False
c    False
d     None
f     None
dtype: object

-- Example 31673
>>> s = pd.Series([1, 2, 3, 4])
>>> s
0    1
1    2
2    3
3    4
dtype: int64

-- Example 31674
>>> s.agg('min')  
1

-- Example 31675
>>> s.agg(['min', 'max'])
min    1
max    4
dtype: int64

-- Example 31676
>>> s = pd.Series([1, 2, 3, 4])
>>> s
0    1
1    2
2    3
3    4
dtype: int64

-- Example 31677
>>> s.agg('min')  
1

-- Example 31678
>>> s.agg(['min', 'max'])
min    1
max    4
dtype: int64

-- Example 31679
>>> s = pd.Series(['cat', 'dog', None, 'rabbit'])
>>> s
0       cat
1       dog
2      None
3    rabbit
dtype: object

-- Example 31680
>>> s.map({'cat': 'kitten', 'dog': 'puppy'})
0    kitten
1     puppy
2      None
3      None
dtype: object

-- Example 31681
>>> s.map('I am a {}'.format)
0       I am a cat
1       I am a dog
2      I am a <NA>
3    I am a rabbit
dtype: object

-- Example 31682
>>> s.map('I am a {}'.format, na_action='ignore')  
0       I am a cat
1       I am a dog
2             None
3    I am a rabbit
dtype: object

-- Example 31683
>>> ser = pd.Series([390., 350., 30., 20.],
...                 index=['Falcon', 'Falcon', 'Parrot', 'Parrot'],
...                 name="Max Speed")
>>> ser
Falcon    390.0
Falcon    350.0
Parrot     30.0
Parrot     20.0
Name: Max Speed, dtype: float64
>>> ser.groupby(level=0).mean()
Falcon    370.0
Parrot     25.0
Name: Max Speed, dtype: float64

-- Example 31684
>>> arrays = [['Falcon', 'Falcon', 'Parrot', 'Parrot'],
...           ['Captive', 'Wild', 'Captive', 'Wild']]
>>> index = pd.MultiIndex.from_arrays(arrays, names=('Animal', 'Type'))
>>> ser = pd.Series([390., 350., 30., 20.], index=index, name="Max Speed")
>>> ser    
Animal  Type
Falcon  Captive    390.0
        Wild       350.0
Parrot  Captive     30.0
        Wild        20.0
Name: Max Speed, dtype: float64
>>> ser.groupby(level=0).mean()     
Animal
Falcon    370.0
Parrot     25.0
Name: Max Speed, dtype: float64
>>> ser.groupby(level="Type").mean()        
Type
Captive    210.0
Wild       185.0
Name: Max Speed, dtype: float64

-- Example 31685
>>> pd.Series([True, True]).all()  
True
>>> pd.Series([True, False]).all()  
False

-- Example 31686
>>> df = pd.DataFrame({'col1': [True, True], 'col2': [True, False]})
>>> df
   col1   col2
0  True   True
1  True  False

-- Example 31687
>>> df.all()
col1     True
col2    False
dtype: bool

-- Example 31688
>>> df.all(axis='columns')
0     True
1    False
dtype: bool

-- Example 31689
>>> df.all(axis=None)  
False

-- Example 31690
>>> pd.Series([False, False]).any()  
False
>>> pd.Series([True, False]).any()  
True

-- Example 31691
>>> df = pd.DataFrame({"A": [1, 2], "B": [0, 2], "C": [0, 0]})
>>> df
   A  B  C
0  1  0  0
1  2  2  0

-- Example 31692
>>> df.any()
A     True
B     True
C    False
dtype: bool

-- Example 31693
>>> df = pd.DataFrame({"A": [True, False], "B": [1, 2]})
>>> df
       A  B
0   True  1
1  False  2

-- Example 31694
>>> df.any(axis='columns')
0    True
1    True
dtype: bool

-- Example 31695
>>> df = pd.DataFrame({"A": [True, False], "B": [1, 0]})
>>> df
       A  B
0   True  1
1  False  0

-- Example 31696
>>> df.any(axis='columns')
0     True
1    False
dtype: bool

-- Example 31697
>>> df.any(axis=None)  
True

-- Example 31698
>>> pd.DataFrame([]).any()
Series([], dtype: bool)

-- Example 31699
>>> s = pd.Series([0.0, 1.0, np.nan])
>>> s.count()  
2

-- Example 31700
>>> s = pd.Series([2, np.nan, 5, -1, 0])
>>> s
0    2.0
1    NaN
2    5.0
3   -1.0
4    0.0
dtype: float64

-- Example 31701
>>> s.cummax()
0    2.0
1    NaN
2    5.0
3    5.0
4    5.0
dtype: float64

-- Example 31702
>>> s.cummax(skipna=False)
0    2.0
1    NaN
2    NaN
3    NaN
4    NaN
dtype: float64

-- Example 31703
>>> df = pd.DataFrame([[2.0, 1.0], [3.0, np.nan], [1.0, 0.0]], columns=list('AB'))
>>> df
     A    B
0  2.0  1.0
1  3.0  NaN
2  1.0  0.0

-- Example 31704
>>> df.cummax()
     A    B
0  2.0  1.0
1  3.0  NaN
2  3.0  1.0

-- Example 31705
>>> s = pd.Series([2, np.nan, 5, -1, 0])
>>> s
0    2.0
1    NaN
2    5.0
3   -1.0
4    0.0
dtype: float64

-- Example 31706
>>> s.cummin()
0    2.0
1    NaN
2    2.0
3   -1.0
4   -1.0
dtype: float64

-- Example 31707
>>> s.cummin(skipna=False)
0    2.0
1    NaN
2    NaN
3    NaN
4    NaN
dtype: float64

-- Example 31708
>>> df = pd.DataFrame([[2.0, 1.0], [3.0, np.nan], [1.0, 0.0]], columns=list('AB'))
>>> df
     A    B
0  2.0  1.0
1  3.0  NaN
2  1.0  0.0

-- Example 31709
>>> df.cummin()
     A    B
0  2.0  1.0
1  2.0  NaN
2  1.0  0.0

-- Example 31710
>>> s = pd.Series([2, np.nan, 5, -1, 0])
>>> s
0    2.0
1    NaN
2    5.0
3   -1.0
4    0.0
dtype: float64

-- Example 31711
>>> s.cumsum()
0    2.0
1    NaN
2    7.0
3    6.0
4    6.0
dtype: float64

-- Example 31712
>>> s.cumsum(skipna=False)
0    2.0
1    NaN
2    NaN
3    NaN
4    NaN
dtype: float64

-- Example 31713
>>> df = pd.DataFrame([[2.0, 1.0], [3.0, np.nan], [1.0, 0.0]], columns=list('AB'))
>>> df
     A    B
0  2.0  1.0
1  3.0  NaN
2  1.0  0.0

-- Example 31714
>>> df.cumsum()
     A    B
0  2.0  1.0
1  5.0  NaN
2  6.0  1.0

-- Example 31715
>>> pd.Series([1, 2, 3]).describe()  
count    3.0
mean     2.0
std      1.0
min      1.0
25%      1.5
50%      2.0
75%      2.5
max      3.0
dtype: float64

-- Example 31716
>>> pd.Series(['a', 'b', 'c']).describe()  
count     3
unique    3
top       a
freq      1
dtype: object

-- Example 31717
>>> s = pd.Series([1, 1, 2, 3, 5, 8])
>>> s.diff()
0    NaN
1    0.0
2    1.0
3    1.0
4    2.0
5    3.0
dtype: float64

-- Example 31718
>>> s.diff(periods=3)
0    NaN
1    NaN
2    NaN
3    2.0
4    4.0
5    6.0
dtype: float64

-- Example 31719
>>> s.diff(periods=-1)
0    0.0
1   -1.0
2   -1.0
3   -2.0
4   -3.0
5    NaN
dtype: float64

-- Example 31720
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

-- Example 31721
>>> s.max()  
8

-- Example 31722
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

-- Example 31723
>>> s.mean()  
3.5

-- Example 31724
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

-- Example 31725
>>> s.median()  
3.0

-- Example 31726
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

-- Example 31727
>>> s.min()  
0

-- Example 31728
>>> s = pd.Series([90, 91, 85])
>>> s
0    90
1    91
2    85
dtype: int64

-- Example 31729
>>> s.pct_change()
0         NaN
1    0.011111
2   -0.065934
dtype: float64

