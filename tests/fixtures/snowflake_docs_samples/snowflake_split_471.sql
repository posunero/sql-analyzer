-- Example 31529
>>> df1.merge(df2, left_on='lkey', right_on='rkey')
  lkey  value_x rkey  value_y
0  foo        1  foo        5
1  foo        1  foo        8
2  bar        2  bar        6
3  baz        3  baz        7
4  foo        5  foo        5
5  foo        5  foo        8

-- Example 31530
>>> df1.merge(df2, left_on='lkey', right_on='rkey',
...           suffixes=('_left', '_right'))
  lkey  value_left rkey  value_right
0  foo           1  foo            5
1  foo           1  foo            8
2  bar           2  bar            6
3  baz           3  baz            7
4  foo           5  foo            5
5  foo           5  foo            8

-- Example 31531
>>> df1 = pd.DataFrame({'a': ['foo', 'bar'], 'b': [1, 2]})
>>> df2 = pd.DataFrame({'a': ['foo', 'baz'], 'c': [3, 4]})
>>> df1
     a  b
0  foo  1
1  bar  2
>>> df2
     a  c
0  foo  3
1  baz  4

-- Example 31532
>>> df1.merge(df2, how='inner', on='a')
     a  b  c
0  foo  1  3

-- Example 31533
>>> df1.merge(df2, how='left', on='a')
     a  b    c
0  foo  1  3.0
1  bar  2  NaN

-- Example 31534
>>> df1 = pd.DataFrame({'left': ['foo', 'bar']})
>>> df2 = pd.DataFrame({'right': [7, 8]})
>>> df1
  left
0  foo
1  bar
>>> df2
   right
0      7
1      8

-- Example 31535
>>> df1.merge(df2, how='cross')
  left  right
0  foo      7
1  foo      8
2  bar      7
3  bar      8

-- Example 31536
>>> left = pd.DataFrame({"a": [1, 5, 10], "left_val": ["a", "b", "c"]})
>>> left
    a left_val
0   1        a
1   5        b
2  10        c
>>> right = pd.DataFrame({"a": [1, 2, 3, 6, 7], "right_val": [1, 2, 3, 6, 7]})
>>> right
   a  right_val
0  1          1
1  2          2
2  3          3
3  6          6
4  7          7
>>> pd.merge_asof(left, right, on="a")
    a left_val  right_val
0   1        a          1
1   5        b          3
2  10        c          7
>>> pd.merge_asof(left, right, on="a", allow_exact_matches=False)
    a left_val  right_val
0   1        a        NaN
1   5        b        3.0
2  10        c        7.0
>>> pd.merge_asof(left, right, on="a", direction="forward")
    a left_val  right_val
0   1        a        1.0
1   5        b        6.0
2  10        c        NaN

-- Example 31537
>>> quotes = pd.DataFrame(
...    {
...        "time": [
...            pd.Timestamp("2016-05-25 13:30:00.023"),
...            pd.Timestamp("2016-05-25 13:30:00.023"),
...            pd.Timestamp("2016-05-25 13:30:00.030"),
...            pd.Timestamp("2016-05-25 13:30:00.041"),
...            pd.Timestamp("2016-05-25 13:30:00.048"),
...            pd.Timestamp("2016-05-25 13:30:00.049"),
...            pd.Timestamp("2016-05-25 13:30:00.072"),
...            pd.Timestamp("2016-05-25 13:30:00.075")
...        ],
...        "bid": [720.50, 51.95, 51.97, 51.99, 720.50, 97.99, 720.50, 52.01],
...        "ask": [720.93, 51.96, 51.98, 52.00, 720.93, 98.01, 720.88, 52.03]
...    }
... )
>>> quotes
                     time     bid     ask
0 2016-05-25 13:30:00.023  720.50  720.93
1 2016-05-25 13:30:00.023   51.95   51.96
2 2016-05-25 13:30:00.030   51.97   51.98
3 2016-05-25 13:30:00.041   51.99   52.00
4 2016-05-25 13:30:00.048  720.50  720.93
5 2016-05-25 13:30:00.049   97.99   98.01
6 2016-05-25 13:30:00.072  720.50  720.88
7 2016-05-25 13:30:00.075   52.01   52.03
>>> trades = pd.DataFrame(
...    {
...        "time": [
...            pd.Timestamp("2016-05-25 13:30:00.023"),
...            pd.Timestamp("2016-05-25 13:30:00.038"),
...            pd.Timestamp("2016-05-25 13:30:00.048"),
...            pd.Timestamp("2016-05-25 13:30:00.048"),
...            pd.Timestamp("2016-05-25 13:30:00.048")
...        ],
...        "price": [51.95, 51.95, 720.77, 720.92, 98.0],
...        "quantity": [75, 155, 100, 100, 100]
...    }
... )
>>> trades
                     time   price  quantity
0 2016-05-25 13:30:00.023   51.95        75
1 2016-05-25 13:30:00.038   51.95       155
2 2016-05-25 13:30:00.048  720.77       100
3 2016-05-25 13:30:00.048  720.92       100
4 2016-05-25 13:30:00.048   98.00       100
>>> pd.merge_asof(trades, quotes, on="time")
                     time   price  quantity     bid     ask
0 2016-05-25 13:30:00.023   51.95        75   51.95   51.96
1 2016-05-25 13:30:00.038   51.95       155   51.97   51.98
2 2016-05-25 13:30:00.048  720.77       100  720.50  720.93
3 2016-05-25 13:30:00.048  720.92       100  720.50  720.93
4 2016-05-25 13:30:00.048   98.00       100  720.50  720.93

-- Example 31538
>>> pd.unique([2, 1, 3, 3])
array([2, 1, 3])

-- Example 31539
>>> pd.unique([pd.Timestamp('2016-01-01', tz='US/Eastern')
...            for _ in range(3)])
array([Timestamp('2016-01-01 00:00:00-0500', tz='UTC-05:00')],
      dtype=object)

-- Example 31540
>>> pd.unique([("a", "b"), ("b", "a"), ("a", "c"), ("b", "a")])
array([list(['a', 'b']), list(['b', 'a']), list(['a', 'c'])], dtype=object)

-- Example 31541
>>> pd.unique([None, np.nan, 2])
array([nan,  2.])

-- Example 31542
>>> s = pd.Series(['1.0', '2', -3])
>>> pd.to_numeric(s)
0    1.0
1    2.0
2   -3.0
dtype: float64

-- Example 31543
>>> pd.date_range(start='1/1/2018', end='1/08/2018')
DatetimeIndex(['2018-01-01', '2018-01-02', '2018-01-03', '2018-01-04',
               '2018-01-05', '2018-01-06', '2018-01-07', '2018-01-08'],
              dtype='datetime64[ns]', freq=None)

-- Example 31544
>>> pd.date_range(
...     start=pd.to_datetime("1/1/2018").tz_localize("Europe/Berlin"),
...     end=pd.to_datetime("1/08/2018").tz_localize("Europe/Berlin"),
... )
DatetimeIndex(['2018-01-01 00:00:00+01:00', '2018-01-02 00:00:00+01:00',
               '2018-01-03 00:00:00+01:00', '2018-01-04 00:00:00+01:00',
               '2018-01-05 00:00:00+01:00', '2018-01-06 00:00:00+01:00',
               '2018-01-07 00:00:00+01:00', '2018-01-08 00:00:00+01:00'],
              dtype='datetime64[ns, UTC+01:00]', freq=None)

-- Example 31545
>>> pd.date_range(start='1/1/2018', periods=8)
DatetimeIndex(['2018-01-01', '2018-01-02', '2018-01-03', '2018-01-04',
               '2018-01-05', '2018-01-06', '2018-01-07', '2018-01-08'],
              dtype='datetime64[ns]', freq=None)

-- Example 31546
>>> pd.date_range(end='1/1/2018', periods=8)
DatetimeIndex(['2017-12-25', '2017-12-26', '2017-12-27', '2017-12-28',
               '2017-12-29', '2017-12-30', '2017-12-31', '2018-01-01'],
              dtype='datetime64[ns]', freq=None)

-- Example 31547
>>> pd.date_range(start='2018-04-24', end='2018-04-27', periods=3)
DatetimeIndex(['2018-04-24 00:00:00', '2018-04-25 12:00:00',
               '2018-04-27 00:00:00'],
              dtype='datetime64[ns]', freq=None)

-- Example 31548
>>> pd.date_range(start='1/1/2018', periods=5, freq='ME')
DatetimeIndex(['2018-01-31', '2018-02-28', '2018-03-31', '2018-04-30',
               '2018-05-31'],
              dtype='datetime64[ns]', freq=None)

-- Example 31549
>>> pd.date_range(start='1/1/2018', periods=5, freq='3ME')
DatetimeIndex(['2018-01-31', '2018-04-30', '2018-07-31', '2018-10-31',
               '2019-01-31'],
              dtype='datetime64[ns]', freq=None)

-- Example 31550
>>> pd.date_range(start='1/1/2018', periods=5, freq=pd.offsets.MonthEnd(3))
DatetimeIndex(['2018-01-31', '2018-04-30', '2018-07-31', '2018-10-31',
               '2019-01-31'],
              dtype='datetime64[ns]', freq=None)

-- Example 31551
>>> pd.date_range(start='1/1/2018', periods=5, tz='Asia/Tokyo')
DatetimeIndex(['2018-01-01 00:00:00+09:00', '2018-01-02 00:00:00+09:00',
               '2018-01-03 00:00:00+09:00', '2018-01-04 00:00:00+09:00',
               '2018-01-05 00:00:00+09:00'],
              dtype='datetime64[ns, UTC+09:00]', freq=None)

-- Example 31552
>>> pd.date_range(start='2017-01-01', end='2017-01-04', inclusive="both")
DatetimeIndex(['2017-01-01', '2017-01-02', '2017-01-03', '2017-01-04'], dtype='datetime64[ns]', freq=None)

-- Example 31553
>>> pd.date_range(start='2017-01-01', end='2017-01-04', inclusive='left')
DatetimeIndex(['2017-01-01', '2017-01-02', '2017-01-03'], dtype='datetime64[ns]', freq=None)

-- Example 31554
>>> pd.date_range(start='2017-01-01', end='2017-01-04', inclusive='right')
DatetimeIndex(['2017-01-02', '2017-01-03', '2017-01-04'], dtype='datetime64[ns]', freq=None)

-- Example 31555
>>> pd.bdate_range(start='1/1/2018', end='1/08/2018') 
DatetimeIndex(['2018-01-01', '2018-01-02', '2018-01-03', '2018-01-04',
        '2018-01-05', '2018-01-08'],
        dtype='datetime64[ns]', freq=None)

-- Example 31556
>>> df = pd.DataFrame({'year': [2015, 2016],
...                    'month': [2, 3],
...                    'day': [4, 5]})
>>> pd.to_datetime(df)
0   2015-02-04
1   2016-03-05
dtype: datetime64[ns]

-- Example 31557
>>> s = pd.Series(['3/11/2000', '3/12/2000', '3/13/2000'] * 1000)
>>> s.head()
0    3/11/2000
1    3/12/2000
2    3/13/2000
3    3/11/2000
4    3/12/2000
dtype: object

-- Example 31558
>>> pd.to_datetime(1490195805, unit='s')
Timestamp('2017-03-22 15:16:45')
>>> pd.to_datetime(1490195805433502912, unit='ns')
Timestamp('2017-03-22 15:16:45.433502912')

-- Example 31559
>>> pd.to_datetime([1, 2, 3], unit='D',
...                origin=pd.Timestamp('1960-01-01'))
DatetimeIndex(['1960-01-02', '1960-01-03', '1960-01-04'], dtype='datetime64[ns]', freq=None)

-- Example 31560
>>> pd.to_datetime(['13000101', 'abc'], format='%Y%m%d', errors='coerce')
DatetimeIndex(['NaT', 'NaT'], dtype='datetime64[ns]', freq=None)

-- Example 31561
>>> pd.to_datetime(['2018-10-26 12:00:00', '2018-10-26 13:00:15'])
DatetimeIndex(['2018-10-26 12:00:00', '2018-10-26 13:00:15'], dtype='datetime64[ns]', freq=None)

-- Example 31562
>>> pd.to_datetime(['2018-10-26 12:00:00 -0500', '2018-10-26 13:00:00 -0500'])
DatetimeIndex(['2018-10-26 12:00:00-05:00', '2018-10-26 13:00:00-05:00'], dtype='datetime64[ns, UTC-05:00]', freq=None)

-- Example 31563
>>> pd.to_datetime(['2018-10-26 12:00:00 -0500', '2018-10-26 13:00:00 -0500'], format="%Y-%m-%d %H:%M:%S %z")
DatetimeIndex(['2018-10-26 12:00:00-05:00', '2018-10-26 13:00:00-05:00'], dtype='datetime64[ns, UTC-05:00]', freq=None)

-- Example 31564
>>> pd.to_datetime(['2020-10-25 02:00:00 +0200', '2020-10-25 04:00:00 +0100'])
DatetimeIndex([2020-10-25 02:00:00+02:00, 2020-10-25 04:00:00+01:00], dtype='object', freq=None)

-- Example 31565
>>> pd.to_datetime(['2020-10-25 02:00:00 +0200', '2020-10-25 04:00:00 +0100'], format="%Y-%m-%d %H:%M:%S %z")
DatetimeIndex([2020-10-25 02:00:00+02:00, 2020-10-25 04:00:00+01:00], dtype='object', freq=None)

-- Example 31566
>>> pd.to_datetime(['2018-10-26 12:00', '2018-10-26 13:00'], utc=True)
DatetimeIndex(['2018-10-26 12:00:00+00:00', '2018-10-26 13:00:00+00:00'], dtype='datetime64[ns, UTC]', freq=None)

-- Example 31567
>>> pd.to_datetime(['2018-10-26 12:00:00 -0530', '2018-10-26 12:00:00 -0500'],
...                utc=True)
DatetimeIndex(['2018-10-26 17:30:00+00:00', '2018-10-26 17:00:00+00:00'], dtype='datetime64[ns, UTC]', freq=None)

-- Example 31568
>>> d = {'a': 1, 'b': 2, 'c': 3}
>>> ser = pd.Series(data=d, index=['a', 'b', 'c'])
>>> ser
a    1
b    2
c    3
dtype: int64

-- Example 31569
>>> d = {'a': 1, 'b': 2, 'c': 3}
>>> ser = pd.Series(data=d, index=['x', 'y', 'z'])
>>> ser
x   NaN
y   NaN
z   NaN
dtype: float64

-- Example 31570
>>> s = pd.Series([1, 2, 3])
>>> s.dtype
dtype('int64')

-- Example 31571
>>> s = pd.Series([1, 2, 3])
>>> s.dtype
dtype('int64')

-- Example 31572
>>> animals = pd.Series(['llama', 'cow', 'llama', 'beetle', 'llama'])
>>> animals.duplicated()
0    False
1    False
2     True
3    False
4     True
dtype: bool

-- Example 31573
>>> animals.duplicated(keep='first')
0    False
1    False
2     True
3    False
4     True
dtype: bool

-- Example 31574
>>> animals.duplicated(keep='last')
0     True
1    False
2     True
3    False
4    False
dtype: bool

-- Example 31575
>>> animals.duplicated(keep=False)
0     True
1    False
2     True
3    False
4     True
dtype: bool

-- Example 31576
>>> series = pd.Series([1, 2, 3], name=99)
>>> series
0    1
1    2
2    3
Name: 99, dtype: int64

-- Example 31577
>>> exactly_equal = pd.Series([1, 2, 3], name=99)
>>> exactly_equal
0    1
1    2
2    3
Name: 99, dtype: int64
>>> series.equals(exactly_equal)  
True

-- Example 31578
>>> different_column_type = pd.Series([1, 2, 3], name=99.0)
>>> different_column_type
0    1
1    2
2    3
Name: 99.0, dtype: int64
>>> series.equals(different_column_type)  
True

-- Example 31579
>>> different_data_type = pd.Series([1.0, 2.0, 3.0], name=99)
>>> different_data_type
0    1.0
1    2.0
2    3.0
Name: 99, dtype: float64
>>> series.equals(different_data_type)  
False

-- Example 31580
>>> s = pd.Series([1, 2, 2])
>>> s.is_monotonic_increasing  
True

-- Example 31581
>>> s = pd.Series([3, 2, 1])
>>> s.is_monotonic_increasing  
False

-- Example 31582
>>> s = pd.Series([3, 2, 2, 1])
>>> s.is_monotonic_decreasing  
True

-- Example 31583
>>> s = pd.Series([1, 2, 3])
>>> s.is_monotonic_decreasing  
False

-- Example 31584
>>> s = pd.Series([1, 2, 3])
>>> s.shape
(3,)

-- Example 31585
>>> ser = pd.Series([390., 350., 30., 20.],
...                 index=['Falcon', 'Falcon', 'Parrot', 'Parrot'],
...                 name="Max Speed")
>>> ser
Falcon    390.0
Falcon    350.0
Parrot     30.0
Parrot     20.0
Name: Max Speed, dtype: float64
>>> snowpark_df = ser.to_snowpark(index_label="Animal")
>>> snowpark_df.order_by('"Max Speed"').show()
--------------------------
|"Animal"  |"Max Speed"  |
--------------------------
|Parrot    |20.0         |
|Parrot    |30.0         |
|Falcon    |350.0        |
|Falcon    |390.0        |
--------------------------

>>> snowpark_df = ser.to_snowpark(index=False)
>>> snowpark_df.order_by('"Max Speed"').show()
---------------
|"Max Speed"  |
---------------
|20.0         |
|30.0         |
|350.0        |
|390.0        |
---------------


MultiIndex usage
>>> ser = pd.Series([390., 350., 30., 20.],
...                 index=pd.MultiIndex.from_tuples([('bar', 'one'), ('foo', 'one'), ('bar', 'two'), ('foo', 'three')], names=['first', 'second']),
...                 name="Max Speed")
>>> ser
first  second
bar    one       390.0
foo    one       350.0
bar    two        30.0
foo    three      20.0
Name: Max Speed, dtype: float64
>>> snowpark_df = ser.to_snowpark(index=True, index_label=['A', 'B'])
>>> snowpark_df.order_by('"A"', '"B"').show()
-----------------------------
|"A"  |"B"    |"Max Speed"  |
-----------------------------
|bar  |one    |390.0        |
|bar  |two    |30.0         |
|foo  |one    |350.0        |
|foo  |three  |20.0         |
-----------------------------

>>> snowpark_df = ser.to_snowpark(index=False)
>>> snowpark_df.order_by('"Max Speed"').show()
---------------
|"Max Speed"  |
---------------
|20.0         |
|30.0         |
|350.0        |
|390.0        |
---------------

-- Example 31586
>>> new_series = series.cache_result()

-- Example 31587
>>> import numpy as np

-- Example 31588
>>> np.all((new_series == series).values)  
True

-- Example 31589
>>> series.reset_index(drop=True, inplace=True) # Slower

-- Example 31590
>>> new_series.reset_index(drop=True, inplace=True) # Faster

-- Example 31591
Saving Series to an Iceberg table. Note that the external_volume, catalog, and base_location should have been setup externally.
See `Create your first Iceberg table <https://docs.snowflake.com/en/user-guide/tutorials/create-your-first-iceberg-table>`_ for more information on creating iceberg resources.

>>> df = session.create_dataframe([[1,2],[3,4]], schema=["a", "b"])
>>> iceberg_config = {
...     "external_volume": "example_volume",
...     "catalog": "example_catalog",
...     "base_location": "/iceberg_root",
...     "storage_serialization_policy": "OPTIMIZED",
... }
>>> df.to_snowpark_pandas()["a"].to_iceberg("my_table", mode="overwrite", iceberg_config=iceberg_config) # doctest: +SKIP

-- Example 31592
>>> d = {'col1': [1, 2], 'col2': [3, 4]}
>>> df = pd.DataFrame(data=d)
>>> df.dtypes
col1    int64
col2    int64
dtype: object

-- Example 31593
>>> df.astype('int32').dtypes
col1    int64
col2    int64
dtype: object

-- Example 31594
>>> df.astype({'col1': 'float64'}).dtypes
col1    float64
col2      int64
dtype: object

-- Example 31595
>>> ser = pd.Series([1, 2], dtype=str)
>>> ser
0    1
1    2
dtype: object
>>> ser.astype('float64')
0    1.0
1    2.0
dtype: float64

