-- Example 31730
>>> s.pct_change(periods=2)
0         NaN
1         NaN
2   -0.055556
dtype: float64

-- Example 31731
>>> s = pd.Series([90, 91, None, 85])
>>> s
0    90.0
1    91.0
2     NaN
3    85.0
dtype: float64

-- Example 31732
>>> s.ffill().pct_change()
0         NaN
1    0.011111
2    0.000000
3   -0.065934
dtype: float64

-- Example 31733
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

-- Example 31734
>>> df.pct_change()
                  FR        GR        IT
1980-01-01       NaN       NaN       NaN
1980-02-01  0.013810  0.013684  0.006549
1980-03-01  0.053365  0.059318  0.061876

-- Example 31735
>>> df = pd.DataFrame({
...     '2016': [1769950, 30586265],
...     '2015': [1500923, 40912316],
...     '2014': [1371819, 41403351]},
...     index=['GOOG', 'APPL'])
>>> df
          2016      2015      2014
GOOG   1769950   1500923   1371819
APPL  30586265  40912316  41403351

-- Example 31736
>>> df.pct_change(axis='columns', periods=-1)
          2016      2015  2014
GOOG  0.179241  0.094112   NaN
APPL -0.252395 -0.011860   NaN

-- Example 31737
>>> s = pd.Series([1, 2, 3, 4])

-- Example 31738
>>> s.quantile(.5)  
2.5

-- Example 31739
>>> s.quantile([.25, .5, .75]) 
0.25    1.75
0.50    2.50
0.75    3.25
dtype: float64

-- Example 31740
>>> s = pd.Series([None, 0, 25, 50, 75, 100, np.nan])
>>> s.quantile([0, 0.25, 0.5, 0.75, 1]) 
0.00      0.0
0.25     25.0
0.50     50.0
0.75     75.0
1.00    100.0
dtype: float64

-- Example 31741
>>> df = pd.DataFrame({'A': [0, 1, 2],
...           'B': [1, 2, 1],
...           'C': [3, 4, 5]})
>>> df.skew()
A    0.000000
B    1.732059
C    0.000000
dtype: float64

-- Example 31742
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

-- Example 31743
>>> df.std()
age       18.786076
height     0.237417
dtype: float64

-- Example 31744
>>> df.std(ddof=0)
age       16.269219
height     0.205609
dtype: float64

-- Example 31745
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

-- Example 31746
>>> s.sum()  
14

-- Example 31747
>>> pd.Series([], dtype="float64").sum()  # min_count=0 is the default  
0.0

-- Example 31748
>>> pd.Series([], dtype="float64").sum(min_count=1)  
nan

-- Example 31749
>>> pd.Series([np.nan]).sum()  
0.0

-- Example 31750
>>> pd.Series([np.nan]).sum(min_count=1)  
nan

-- Example 31751
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

-- Example 31752
>>> df.var()
age       352.916667
height      0.056367
dtype: float64

-- Example 31753
>>> df.var(ddof=0)
age       264.687500
height      0.042275
dtype: float64

-- Example 31754
>>> pd.Series([2, 1, 3, 3], name='A').unique()
array([2, 1, 3])

-- Example 31755
>>> pd.Series([pd.Timestamp('2016-01-01', tz='US/Eastern')
...            for _ in range(3)]).unique()
array([Timestamp('2016-01-01 00:00:00-0500', tz='UTC-05:00')],
      dtype=object)

-- Example 31756
>>> import numpy as np
>>> s = pd.Series([1, 3, 5, 7, 7])
>>> s
0    1
1    3
2    5
3    7
4    7
dtype: int64

-- Example 31757
>>> s.nunique()  
4

-- Example 31758
>>> s = pd.Series([pd.NaT, np.nan, pd.NA, None, 1])
>>> s.nunique()  
1

-- Example 31759
>>> s.nunique(dropna=False)  
2

-- Example 31760
>>> s = pd.Series([3, 1, 2, 3, 4, np.nan])
>>> s.value_counts()
3.0    2
1.0    1
2.0    1
4.0    1
Name: count, dtype: int64

-- Example 31761
>>> s.value_counts(normalize=True)
3.0    0.4
1.0    0.2
2.0    0.2
4.0    0.2
Name: proportion, dtype: float64

-- Example 31762
>>> s.value_counts(dropna=False)
3.0    2
1.0    1
2.0    1
4.0    1
NaN    1
Name: count, dtype: int64

-- Example 31763
>>> c = pd.Series([6, 7, 8, 9], name='c')
>>> a = pd.Series([0, 0, 1, 2])
>>> b = pd.Series([0, 3, 4, 5])

-- Example 31764
>>> c.case_when(caselist=[(a.gt(0), a),  # condition, replacement
...                       (b.gt(0), b)])
0    6
1    3
2    1
3    2
Name: c, dtype: int64

-- Example 31765
>>> s = pd.Series(data=np.arange(3), index=['A', 'B', 'C'])
>>> s
A    0
B    1
C    2
dtype: int64

-- Example 31766
>>> s.drop(labels=['B', 'C'])
A    0
dtype: int64

-- Example 31767
>>> midx = pd.MultiIndex(levels=[['lama', 'cow', 'falcon'],
...                              ['speed', 'weight', 'length']],
...                      codes=[[0, 0, 0, 1, 1, 1, 2, 2, 2],
...                             [0, 1, 2, 0, 1, 2, 0, 1, 2]])
>>> s = pd.Series([45, 200, 1.2, 30, 250, 1.5, 320, 1, 0.3],
...               index=midx)
>>> s
lama    speed      45.0
        weight    200.0
        length      1.2
cow     speed      30.0
        weight    250.0
        length      1.5
falcon  speed     320.0
        weight      1.0
        length      0.3
dtype: float64

-- Example 31768
>>> s.drop(labels='weight', level=1)
lama    speed      45.0
        length      1.2
cow     speed      30.0
        length      1.5
falcon  speed     320.0
        length      0.3
dtype: float64

-- Example 31769
>>> s = pd.Series(['llama', 'cow', 'llama', 'beetle', 'llama', 'hippo'],
...                 name='animal')
>>> s
0     llama
1       cow
2     llama
3    beetle
4     llama
5     hippo
Name: animal, dtype: object

-- Example 31770
>>> s.drop_duplicates()
0     llama
1       cow
3    beetle
5     hippo
Name: animal, dtype: object

-- Example 31771
>>> s.drop_duplicates(keep='last')
1       cow
3    beetle
4     llama
5     hippo
Name: animal, dtype: object

-- Example 31772
>>> s.drop_duplicates(keep=False)
1       cow
3    beetle
5     hippo
Name: animal, dtype: object

-- Example 31773
>>> df = pd.DataFrame(
...     [
...         [24.3, 75.7, "high"],
...         [31, 87.8, "high"],
...         [22, 71.6, "medium"],
...         [35, 95, "medium"],
...     ],
...     columns=["temp_celsius", "temp_fahrenheit", "windspeed"],
...     index=pd.date_range(start="2014-02-12", end="2014-02-15", freq="D"),
... )

-- Example 31774
>>> df
            temp_celsius  temp_fahrenheit windspeed
2014-02-12          24.3             75.7      high
2014-02-13          31.0             87.8      high
2014-02-14          22.0             71.6    medium
2014-02-15          35.0             95.0    medium

-- Example 31775
>>> df.get(["temp_celsius", "windspeed"])
            temp_celsius windspeed
2014-02-12          24.3      high
2014-02-13          31.0      high
2014-02-14          22.0    medium
2014-02-15          35.0    medium

-- Example 31776
>>> ser = df['windspeed']
>>> ser.get('2014-02-13')
2014-02-13    high
Freq: None, Name: windspeed, dtype: object

-- Example 31777
>>> ser.get('2014-02-10', '[unknown]')
Series([], Freq: None, Name: windspeed, dtype: object)

-- Example 31778
>>> s = pd.Series(data=[1, None, 4, 3, 4],
...               index=['A', 'B', 'C', 'D', 'E'])
>>> s.idxmax()
'C'

-- Example 31779
>>> s = pd.Series(data=[1, None, 4, 3, 4],
...               index=['A', 'B', 'C', 'D', 'E'])
>>> s.idxmin()
'A'

-- Example 31780
>>> s = pd.Series([1, 2, 3])
>>> s
0    1
1    2
2    3
dtype: int64
>>> s.rename("my_name")  # scalar, changes Series.name
0    1
1    2
2    3
Name: my_name, dtype: int64
>>> s.rename({1: 3, 2: 5})  # mapping, changes labels
0    1
3    2
5    3
dtype: int64

-- Example 31781
>>> s = pd.Series(["dog", "cat", "monkey"])
>>> s
0       dog
1       cat
2    monkey
dtype: object
>>> s.rename_axis("animal")
animal
0       dog
1       cat
2    monkey
dtype: object

-- Example 31782
>>> s = pd.Series([1, 2, 3, 4], name='foo',
...               index=pd.Index(['a', 'b', 'c', 'd'], name='idx'))

-- Example 31783
>>> s.reset_index()
  idx  foo
0   a    1
1   b    2
2   c    3
3   d    4

-- Example 31784
>>> s.reset_index(name='values')
  idx  values
0   a       1
1   b       2
2   c       3
3   d       4

-- Example 31785
>>> s.reset_index(drop=True)
0    1
1    2
2    3
3    4
Name: foo, dtype: int64

-- Example 31786
>>> s.reset_index(inplace=True, drop=True)
>>> s
0    1
1    2
2    3
3    4
Name: foo, dtype: int64

-- Example 31787
>>> arrays = [np.array(['bar', 'bar', 'baz', 'baz']),
...           np.array(['one', 'two', 'one', 'two'])]
>>> s2 = pd.Series(
...     range(4), name='foo',
...     index=pd.MultiIndex.from_arrays(arrays,
...                                     names=['a', 'b']))

-- Example 31788
>>> s2.reset_index(level='a')  
       a  foo
b
one  bar    0
two  bar    1
one  baz    2
two  baz    3

-- Example 31789
>>> s2.reset_index()
     a    b  foo
0  bar  one    0
1  bar  two    1
2  baz  one    2
3  baz  two    3

-- Example 31790
>>> df = pd.DataFrame({'num_legs': [2, 4, 8, 0],
...                    'num_wings': [2, 0, 0, 0],
...                    'num_specimen_seen': [10, 2, 1, 8]},
...                   index=['falcon', 'dog', 'spider', 'fish'])
>>> df
        num_legs  num_wings  num_specimen_seen
falcon         2          2                 10
dog            4          0                  2
spider         8          0                  1
fish           0          0                  8

-- Example 31791
>>> df['num_legs'].sample(n=3) 
fish      0
spider    8
falcon    2
Name: num_legs, dtype: int64

-- Example 31792
>>> df.sample(frac=0.5, replace=True) with replacement 
      num_legs  num_wings  num_specimen_seen
dog          4          0                  2
fish         0          0                  8

-- Example 31793
>>> df.sample(frac=2, replace=True) 
        num_legs  num_wings  num_specimen_seen
dog            4          0                  2
fish           0          0                  8
falcon         2          2                 10
falcon         2          2                 10
fish           0          0                  8
dog            4          0                  2
fish           0          0                  8
dog            4          0                  2

-- Example 31794
>>> df.sample(n=20)
        num_legs  num_wings  num_specimen_seen
falcon         2          2                 10
dog            4          0                  2
spider         8          0                  1
fish           0          0                  8

-- Example 31795
>>> ser = pd.Series(["apple", "banana", "cauliflower"])
>>> ser.set_axis(["A:", "B:", "C:"], axis="index")
A:          apple
B:         banana
C:    cauliflower
dtype: object

-- Example 31796
>>> ser.set_axis([1000, 45, -99.23], axis=0)
 1000.00          apple
 45.00           banana
-99.23      cauliflower
dtype: object

