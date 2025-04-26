-- Example 32199
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

-- Example 32200
>>> df.var()
age       352.916667
height      0.056367
dtype: float64

-- Example 32201
>>> df.var(ddof=0)
age       264.687500
height      0.042275
dtype: float64

-- Example 32202
>>> df = pd.DataFrame({'A': [4, 5, 6], 'B': [4, 1, 1]})
>>> df.nunique()
A    3
B    2
dtype: int64

-- Example 32203
>>> df = pd.DataFrame({'A': [None, pd.NA, None], 'B': [1, 2, 1]})
>>> df.nunique()
A    0
B    2
dtype: int64

-- Example 32204
>>> df.nunique(dropna=False)
A    1
B    2
dtype: int64

-- Example 32205
>>> df = pd.DataFrame({'num_legs': [2, 4, 4, 6],
...                    'num_wings': [2, 0, 0, 0]},
...                   index=['falcon', 'dog', 'cat', 'ant'])
>>> df
        num_legs  num_wings
falcon         2          2
dog            4          0
cat            4          0
ant            6          0

-- Example 32206
>>> df.value_counts()
num_legs  num_wings
4         0            2
2         2            1
6         0            1
Name: count, dtype: int64

-- Example 32207
>>> df.value_counts(sort=False)
num_legs  num_wings
2         2            1
4         0            2
6         0            1
Name: count, dtype: int64

-- Example 32208
>>> df.value_counts(ascending=True)
num_legs  num_wings
2         2            1
6         0            1
4         0            2
Name: count, dtype: int64

-- Example 32209
>>> df.value_counts(normalize=True)
num_legs  num_wings
4         0            0.50
2         2            0.25
6         0            0.25
Name: proportion, dtype: float64

-- Example 32210
>>> df = pd.DataFrame({'first_name': ['John', 'Anne', 'John', 'Beth'],
...                    'middle_name': ['Smith', None, None, 'Louise']})
>>> df
  first_name middle_name
0       John       Smith
1       Anne        None
2       John        None
3       Beth      Louise

-- Example 32211
>>> df.value_counts()
first_name  middle_name
John        Smith          1
Beth        Louise         1
Name: count, dtype: int64

-- Example 32212
>>> df.value_counts(dropna=False)
first_name  middle_name
John        Smith          1
Anne        NaN            1
John        NaN            1
Beth        Louise         1
Name: count, dtype: int64

-- Example 32213
>>> df.value_counts("first_name")
first_name
John    2
Anne    1
Beth    1
Name: count, dtype: int64

-- Example 32214
>>> s = pd.Series([1, 2, 3, 4])
>>> s
0    1
1    2
2    3
3    4
dtype: int64

-- Example 32215
>>> s.add_prefix('item_')
item_0    1
item_1    2
item_2    3
item_3    4
dtype: int64

-- Example 32216
>>> df = pd.DataFrame({'A': [1, 2, 3, 4], 'B': [3, 4, 5, 6]})
>>> df
   A  B
0  1  3
1  2  4
2  3  5
3  4  6

-- Example 32217
>>> df.add_prefix('col_')
   col_A  col_B
0      1      3
1      2      4
2      3      5
3      4      6

-- Example 32218
>>> s = pd.Series([1, 2, 3, 4])
>>> s
0    1
1    2
2    3
3    4
dtype: int64

-- Example 32219
>>> s.add_suffix('_item')
0_item    1
1_item    2
2_item    3
3_item    4
dtype: int64

-- Example 32220
>>> df = pd.DataFrame({'A': [1, 2, 3, 4], 'B': [3, 4, 5, 6]})
>>> df
   A  B
0  1  3
1  2  4
2  3  5
3  4  6

-- Example 32221
>>> df.add_suffix('_col')
   A_col  B_col
0      1      3
1      2      4
2      3      5
3      4      6

-- Example 32222
>>> s = pd.Series(data=np.arange(3), index=['A', 'B', 'C'])
>>> s
A    0
B    1
C    2
dtype: int64

-- Example 32223
>>> s.drop(labels=['B', 'C'])
A    0
dtype: int64

-- Example 32224
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

-- Example 32225
>>> s.drop(labels='weight', level=1)
lama    speed      45.0
        length      1.2
cow     speed      30.0
        length      1.5
falcon  speed     320.0
        length      0.3
dtype: float64

-- Example 32226
>>> df = pd.DataFrame({
...     'brand': ['Yum Yum', 'Yum Yum', 'Indomie', 'Indomie', 'Indomie'],
...     'style': ['cup', 'cup', 'cup', 'pack', 'pack'],
...     'rating': [4, 4, 3.5, 15, 5]
... })
>>> df
     brand style  rating
0  Yum Yum   cup     4.0
1  Yum Yum   cup     4.0
2  Indomie   cup     3.5
3  Indomie  pack    15.0
4  Indomie  pack     5.0

-- Example 32227
>>> df.drop_duplicates()
     brand style  rating
0  Yum Yum   cup     4.0
2  Indomie   cup     3.5
3  Indomie  pack    15.0
4  Indomie  pack     5.0

-- Example 32228
>>> df.drop_duplicates(subset=['brand'])
     brand style  rating
0  Yum Yum   cup     4.0
2  Indomie   cup     3.5

-- Example 32229
>>> df.drop_duplicates(subset=['brand', 'style'], keep='last')
     brand style  rating
1  Yum Yum   cup     4.0
2  Indomie   cup     3.5
4  Indomie  pack     5.0

-- Example 32230
>>> df = pd.DataFrame({
...     'brand': ['Yum Yum', 'Yum Yum', 'Indomie', 'Indomie', 'Indomie'],
...     'style': ['cup', 'cup', 'cup', 'pack', 'pack'],
...     'rating': [4, 4, 3.5, 15, 5]
... })
>>> df
     brand style  rating
0  Yum Yum   cup     4.0
1  Yum Yum   cup     4.0
2  Indomie   cup     3.5
3  Indomie  pack    15.0
4  Indomie  pack     5.0

-- Example 32231
>>> df.duplicated()
0    False
1     True
2    False
3    False
4    False
dtype: bool

-- Example 32232
>>> df.duplicated(keep='last')
0     True
1    False
2    False
3    False
4    False
dtype: bool

-- Example 32233
>>> df.duplicated(keep=False)
0     True
1     True
2    False
3    False
4    False
dtype: bool

-- Example 32234
>>> df.duplicated(subset=['brand'])
0    False
1     True
2    False
3     True
4     True
dtype: bool

-- Example 32235
>>> df = pd.DataFrame({1: [10], 2: [20]})
>>> df
    1   2
0  10  20

-- Example 32236
>>> exactly_equal = pd.DataFrame({1: [10], 2: [20]})
>>> exactly_equal
    1   2
0  10  20
>>> df.equals(exactly_equal)  
True

-- Example 32237
>>> different_column_type = pd.DataFrame({1.0: [10], 2.0: [20]})
>>> different_column_type
   1.0  2.0
0   10   20
>>> df.equals(different_column_type)  
True

-- Example 32238
>>> different_data_type = pd.DataFrame({1: [10.0], 2: [20.0]})
>>> different_data_type
      1     2
0  10.0  20.0
>>> df.equals(different_data_type)  
False

-- Example 32239
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

-- Example 32240
>>> df
            temp_celsius  temp_fahrenheit windspeed
2014-02-12          24.3             75.7      high
2014-02-13          31.0             87.8      high
2014-02-14          22.0             71.6    medium
2014-02-15          35.0             95.0    medium

-- Example 32241
>>> df.get(["temp_celsius", "windspeed"])
            temp_celsius windspeed
2014-02-12          24.3      high
2014-02-13          31.0      high
2014-02-14          22.0    medium
2014-02-15          35.0    medium

-- Example 32242
>>> ser = df['windspeed']
>>> ser.get('2014-02-13')
2014-02-13    high
Freq: None, Name: windspeed, dtype: object

-- Example 32243
>>> ser.get('2014-02-10', '[unknown]')
Series([], Freq: None, Name: windspeed, dtype: object)

-- Example 32244
>>> df = pd.DataFrame({'consumption': [10.51, 103.11, 55.48],
...                     'co2_emissions': [37.2, 19.66, 1712]},
...                   index=['Pork', 'Wheat Products', 'Beef'])
>>> df
                consumption  co2_emissions
Pork                  10.51          37.20
Wheat Products       103.11          19.66
Beef                  55.48        1712.00
>>> df.idxmax()
consumption      Wheat Products
co2_emissions              Beef
dtype: object
>>> df.idxmax(axis=1)
Pork              co2_emissions
Wheat Products      consumption
Beef              co2_emissions
dtype: object
>>> s = pd.Series(data=[1, None, 4, 3, 4],
...               index=['A', 'B', 'C', 'D', 'E'])
>>> s.idxmax()
'C'
>>> s.idxmax(skipna=False)  
nan

-- Example 32245
>>> df = pd.DataFrame({'consumption': [10.51, 103.11, 55.48],
...                     'co2_emissions': [37.2, 19.66, 1712]},
...                   index=['Pork', 'Wheat Products', 'Beef'])
>>> df
                consumption  co2_emissions
Pork                  10.51          37.20
Wheat Products       103.11          19.66
Beef                  55.48        1712.00
>>> df.idxmin()
consumption                Pork
co2_emissions    Wheat Products
dtype: object
>>> df.idxmin(axis=1)
Pork                consumption
Wheat Products    co2_emissions
Beef                consumption
dtype: object
>>> s = pd.Series(data=[1, None, 4, 3, 4],
...               index=['A', 'B', 'C', 'D', 'E'])
>>> s.idxmin()
'A'
>>> s.idxmin(skipna=False)  
nan

-- Example 32246
>>> df = pd.DataFrame({"A": [1, 2, 3], "B": [4, 5, 6]})
>>> df.rename(columns={"A": "a", "B": "c"})
   a  c
0  1  4
1  2  5
2  3  6

-- Example 32247
>>> df.rename(index={0: "x", 1: "y", 2: "z"})
   A  B
x  1  4
y  2  5
z  3  6

-- Example 32248
>>> df.index
Index([0, 1, 2], dtype='int64')

-- Example 32249
>>> df.rename(columns={"A": "a", "B": "b", "C": "c"}, errors="raise")
Traceback (most recent call last):
  ...
KeyError: "['C'] not found in axis"

-- Example 32250
>>> df.rename(str.lower, axis='columns')
   a  b
0  1  4
1  2  5
2  3  6

-- Example 32251
>>> df.rename({1: 2, 2: 4}, axis='index')
   A  B
0  1  4
2  2  5
4  3  6

-- Example 32252
>>> df = pd.DataFrame([('bird', 389.0),
...                    ('bird', 24.0),
...                    ('mammal', 80.5),
...                    ('mammal', np.nan)],
...                   index=['falcon', 'parrot', 'lion', 'monkey'],
...                   columns=('class', 'max_speed'))
>>> df
         class  max_speed
falcon    bird      389.0
parrot    bird       24.0
lion    mammal       80.5
monkey  mammal        NaN

-- Example 32253
>>> df.reset_index()
    index   class  max_speed
0  falcon    bird      389.0
1  parrot    bird       24.0
2    lion  mammal       80.5
3  monkey  mammal        NaN

-- Example 32254
>>> df.reset_index(drop=True)
    class  max_speed
0    bird      389.0
1    bird       24.0
2  mammal       80.5
3  mammal        NaN

-- Example 32255
>>> index = pd.MultiIndex.from_tuples([('bird', 'falcon'),
...                                    ('bird', 'parrot'),
...                                    ('mammal', 'lion'),
...                                    ('mammal', 'monkey')],
...                                   names=['class', 'name'])
>>> columns = pd.MultiIndex.from_tuples([('speed', 'max'),
...                                      ('species', 'type')])
>>> df = pd.DataFrame([(389.0, 'fly'),
...                    ( 24.0, 'fly'),
...                    ( 80.5, 'run'),
...                    (np.nan, 'jump')],
...                   index=index,
...                   columns=columns)
>>> df 
               speed species
                 max    type
class  name
bird   falcon  389.0     fly
       parrot   24.0     fly
mammal lion     80.5     run
       monkey    NaN    jump

-- Example 32256
>>> df.reset_index(names=['classes', 'names']) 
  classes   names  speed species
                     max    type
0    bird  falcon  389.0     fly
1    bird  parrot   24.0     fly
2  mammal    lion   80.5     run
3  mammal  monkey    NaN    jump

-- Example 32257
>>> df.reset_index(level='class') 
         class  speed species
                  max    type
name
falcon    bird  389.0     fly
parrot    bird   24.0     fly
lion    mammal   80.5     run
monkey  mammal    NaN    jump

-- Example 32258
>>> df.reset_index(level='class', col_level=1) 
                speed species
         class    max    type
name
falcon    bird  389.0     fly
parrot    bird   24.0     fly
lion    mammal   80.5     run
monkey  mammal    NaN    jump

-- Example 32259
>>> df.reset_index(level='class', col_level=1, col_fill='species') 
       species  speed species
         class    max    type
name
falcon    bird  389.0     fly
parrot    bird   24.0     fly
lion    mammal   80.5     run
monkey  mammal    NaN    jump

-- Example 32260
>>> df.reset_index(level='class', col_level=1, col_fill='genus') 
         genus  speed species
         class    max    type
name
falcon    bird  389.0     fly
parrot    bird   24.0     fly
lion    mammal   80.5     run
monkey  mammal    NaN    jump

-- Example 32261
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

-- Example 32262
>>> df['num_legs'].sample(n=3) 
fish      0
spider    8
falcon    2
Name: num_legs, dtype: int64

-- Example 32263
>>> df.sample(frac=0.5, replace=True) with replacement 
      num_legs  num_wings  num_specimen_seen
dog          4          0                  2
fish         0          0                  8

-- Example 32264
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

-- Example 32265
>>> df.sample(n=20)
        num_legs  num_wings  num_specimen_seen
falcon         2          2                 10
dog            4          0                  2
spider         8          0                  1
fish           0          0                  8

