-- Example 31864
>>> df_0a.squeeze('rows')
a    1
Name: 0, dtype: int64

-- Example 31865
>>> df_0a.squeeze()  
1

-- Example 31866
>>> s1 = pd.Series(["a", "b", "c", "d", "e"])
>>> s2 = pd.Series(["a", "a", "c", "b", "e"])

-- Example 31867
>>> s1.compare(s2)
  self other
1    b     a
3    d     b

-- Example 31868
>>> s = pd.Series([10, 20, 15, 30, 45],
...                   index=pd.date_range("2020-01-01", "2020-01-05"))
>>> s
2020-01-01    10
2020-01-02    20
2020-01-03    15
2020-01-04    30
2020-01-05    45
Freq: None, dtype: int64

-- Example 31869
>>> s.shift(periods=3)
2020-01-01     NaN
2020-01-02     NaN
2020-01-03     NaN
2020-01-04    10.0
2020-01-05    20.0
Freq: None, dtype: float64

-- Example 31870
>>> s.shift(periods=-2)
2020-01-01    15.0
2020-01-02    30.0
2020-01-03    45.0
2020-01-04     NaN
2020-01-05     NaN
Freq: None, dtype: float64

-- Example 31871
>>> s.shift(periods=3, fill_value=0)
2020-01-01     0
2020-01-02     0
2020-01-03     0
2020-01-04    10
2020-01-05    20
Freq: None, dtype: int64

-- Example 31872
>>> s = pd.Series([None, 3, 4])
>>> s.first_valid_index()
1
>>> s = pd.Series([None, None])
>>> s.first_valid_index()
>>> df = pd.DataFrame({'A': [None, 1, 2, None], 'B': [3, 2, 1, None]}, index=[10, 11, 12, 13])
>>> df
      A    B
10  NaN  3.0
11  1.0  2.0
12  2.0  1.0
13  NaN  NaN
>>> df.first_valid_index()
10
>>> df = pd.DataFrame([5, 6, 7, 8], index=["i", "am", "iron", "man"])
>>> df.first_valid_index()
'i'

-- Example 31873
>>> s = pd.Series([None, 3, 4])
>>> s.last_valid_index()
2
>>> s = pd.Series([None, None])
>>> s.last_valid_index()
>>> df = pd.DataFrame({'A': [None, 1, 2, None], 'B': [3, 2, 1, None]}, index=[10, 11, 12, 13])
>>> df
      A    B
10  NaN  3.0
11  1.0  2.0
12  2.0  1.0
13  NaN  NaN
>>> df.last_valid_index()
12
>>> df = pd.DataFrame([5, 6, 7, 8], index=["i", "am", "iron", "man"])
>>> df.last_valid_index()
'man'

-- Example 31874
>>> index = pd.date_range('1/1/2000', periods=9, freq='min')
>>> series = pd.Series(range(9), index=index)
>>> series
2000-01-01 00:00:00    0
2000-01-01 00:01:00    1
2000-01-01 00:02:00    2
2000-01-01 00:03:00    3
2000-01-01 00:04:00    4
2000-01-01 00:05:00    5
2000-01-01 00:06:00    6
2000-01-01 00:07:00    7
2000-01-01 00:08:00    8
Freq: None, dtype: int64
>>> series.resample('3min').sum()
2000-01-01 00:00:00     3
2000-01-01 00:03:00    12
2000-01-01 00:06:00    21
Freq: None, dtype: int64

-- Example 31875
>>> s = pd.Series(["2020-01-01 01:23:00", "2020-02-01 12:11:05"])
>>> s = pd.to_datetime(s)
>>> s
0   2020-01-01 01:23:00
1   2020-02-01 12:11:05
dtype: datetime64[ns]
>>> s.dt.date
0    2020-01-01
1    2020-02-01
dtype: object

-- Example 31876
>>> s = pd.Series(["1/1/2020 10:00:00", "2/1/2020 11:00:00"])
>>> s = pd.to_datetime(s)
>>> s
0   2020-01-01 10:00:00
1   2020-02-01 11:00:00
dtype: datetime64[ns]
>>> s.dt.time
0    10:00:00
1    11:00:00
dtype: object

-- Example 31877
>>> idx = pd.DatetimeIndex(["1/1/2020 10:00:00+00:00",
...                         "2/1/2020 11:00:00+00:00"])
>>> idx.time
Index([10:00:00, 11:00:00], dtype='object')

-- Example 31878
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="YE")
... )
>>> datetime_series
0   2000-12-31
1   2001-12-31
2   2002-12-31
dtype: datetime64[ns]
>>> datetime_series.dt.year
0    2000
1    2001
2    2002
dtype: int16

-- Example 31879
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="ME")
... )
>>> datetime_series
0   2000-01-31
1   2000-02-29
2   2000-03-31
dtype: datetime64[ns]
>>> datetime_series.dt.month
0    1
1    2
2    3
dtype: int8

-- Example 31880
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="D")
... )
>>> datetime_series
0   2000-01-01
1   2000-01-02
2   2000-01-03
dtype: datetime64[ns]
>>> datetime_series.dt.day
0    1
1    2
2    3
dtype: int8

-- Example 31881
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="h")
... )
>>> datetime_series
0   2000-01-01 00:00:00
1   2000-01-01 01:00:00
2   2000-01-01 02:00:00
dtype: datetime64[ns]
>>> datetime_series.dt.hour
0    0
1    1
2    2
dtype: int8

-- Example 31882
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="min")
... )
>>> datetime_series
0   2000-01-01 00:00:00
1   2000-01-01 00:01:00
2   2000-01-01 00:02:00
dtype: datetime64[ns]
>>> datetime_series.dt.minute
0    0
1    1
2    2
dtype: int8

-- Example 31883
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="s")
... )
>>> datetime_series
0   2000-01-01 00:00:00
1   2000-01-01 00:00:01
2   2000-01-01 00:00:02
dtype: datetime64[ns]
>>> datetime_series.dt.second
0    0
1    1
2    2
dtype: int8

-- Example 31884
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="us")
... )
>>> datetime_series
0   2000-01-01 00:00:00.000000
1   2000-01-01 00:00:00.000001
2   2000-01-01 00:00:00.000002
dtype: datetime64[ns]
>>> datetime_series.dt.microsecond
0    0
1    1
2    2
dtype: int64

-- Example 31885
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="ns")
... )
>>> datetime_series
0   2000-01-01 00:00:00.000000000
1   2000-01-01 00:00:00.000000001
2   2000-01-01 00:00:00.000000002
dtype: datetime64[ns]
>>> datetime_series.dt.nanosecond
0    0
1    1
2    2
dtype: int32

-- Example 31886
>>> s = pd.Series(pd.date_range('2016-12-31', '2017-01-08', freq='D'))
>>> s
0   2016-12-31
1   2017-01-01
2   2017-01-02
3   2017-01-03
4   2017-01-04
5   2017-01-05
6   2017-01-06
7   2017-01-07
8   2017-01-08
dtype: datetime64[ns]
>>> s.dt.dayofweek
0    5
1    6
2    0
3    1
4    2
5    3
6    4
7    5
8    6
dtype: int16

-- Example 31887
>>> s = pd.date_range('2016-12-31', '2017-01-08', freq='D').to_series()
>>> s.dt.dayofweek
2016-12-31    5
2017-01-01    6
2017-01-02    0
2017-01-03    1
2017-01-04    2
2017-01-05    3
2017-01-06    4
2017-01-07    5
2017-01-08    6
Freq: D, dtype: int32

-- Example 31888
>>> s = pd.date_range('2016-12-31', '2017-01-08', freq='D').to_series()
>>> s.dt.weekday
2016-12-31    5
2017-01-01    6
2017-01-02    0
2017-01-03    1
2017-01-04    2
2017-01-05    3
2017-01-06    4
2017-01-07    5
2017-01-08    6
Freq: None, dtype: int16

-- Example 31889
>>> s = pd.Series(pd.to_datetime(["1/1/2020", "2/1/2020"]))
>>> s
0   2020-01-01
1   2020-02-01
dtype: datetime64[ns]
>>> s.dt.dayofyear
0     1
1    32
dtype: int16

-- Example 31890
>>> s = pd.Series(["1/1/2020 10:00:00+00:00", "2/1/2020 11:00:00+00:00"])
>>> s = pd.to_datetime(s)
>>> s
0   2020-01-01 10:00:00+00:00
1   2020-02-01 11:00:00+00:00
dtype: datetime64[ns, UTC]
>>> s.dt.dayofyear
0    1
1   32
dtype: int32

-- Example 31891
>>> idx = pd.DatetimeIndex(["1/1/2020 10:00:00+00:00",
...                         "2/1/2020 11:00:00+00:00"])
>>> idx.dayofyear
Index([1, 32], dtype='int32')

-- Example 31892
>>> datetime_series = pd.Series(
...     pd.date_range("2000-01-01", periods=3, freq="3ME")
... )
>>> datetime_series
0   2000-01-31
1   2000-04-30
2   2000-07-31
dtype: datetime64[ns]
>>> datetime_series.dt.quarter
0    1
1    2
2    3
dtype: int8

-- Example 31893
>>> ser = pd.Series(pd.date_range("2020-05-01", periods=5, freq="4D"))
>>> ser.dt.isocalendar()
   year  week  day
0  2020    18    5
1  2020    19    2
2  2020    19    6
3  2020    20    3
4  2020    20    7

-- Example 31894
>>> s = pd.Series(pd.date_range(start='2018-01', freq='ME', periods=3))
>>> s
0   2018-01-31
1   2018-02-28
2   2018-03-31
dtype: datetime64[ns]
>>> s.dt.month_name()
0     January
1    February
2       March
dtype: object

-- Example 31895
>>> idx = pd.date_range(start='2018-01', freq='ME', periods=3)
>>> idx
DatetimeIndex(['2018-01-31', '2018-02-28', '2018-03-31'], dtype='datetime64[ns]', freq=None)
>>> idx.month_name()  
Index(['January', 'February', 'March'], dtype='object')

-- Example 31896
>>> idx = pd.date_range(start='2018-01', freq='ME', periods=3)
>>> idx
DatetimeIndex(['2018-01-31', '2018-02-28', '2018-03-31'], dtype='datetime64[ns]', freq=None)
>>> idx.month_name(locale='pt_BR.utf8')  
Index(['Janeiro', 'Fevereiro', 'Março'], dtype='object')

-- Example 31897
>>> s = pd.Series(pd.date_range(start='2018-01-01', freq='D', periods=3))
>>> s
0   2018-01-01
1   2018-01-02
2   2018-01-03
dtype: datetime64[ns]
>>> s.dt.day_name()
0       Monday
1      Tuesday
2    Wednesday
dtype: object

-- Example 31898
>>> idx = pd.date_range(start='2018-01-01', freq='D', periods=3)
>>> idx
DatetimeIndex(['2018-01-01', '2018-01-02', '2018-01-03'], dtype='datetime64[ns]', freq=None)
>>> idx.day_name()  
Index(['Monday', 'Tuesday', 'Wednesday'], dtype='object')

-- Example 31899
>>> idx = pd.date_range(start='2018-01-01', freq='D', periods=3)
>>> idx
DatetimeIndex(['2018-01-01', '2018-01-02', '2018-01-03'], dtype='datetime64[ns]', freq=None)
>>> idx.day_name(locale='pt_BR.utf8')  
Index(['Segunda', 'Terça', 'Quarta'], dtype='object')

-- Example 31900
>>> s = pd.Series(pd.date_range("2018-02-27", periods=3))
>>> s
0   2018-02-27
1   2018-02-28
2   2018-03-01
dtype: datetime64[ns]
>>> s.dt.is_month_start
0    False
1    False
2     True
dtype: bool
>>> s.dt.is_month_end
0    False
1     True
2    False
dtype: bool

-- Example 31901
>>> s = pd.Series(pd.date_range("2018-02-27", periods=3))
>>> s
0   2018-02-27
1   2018-02-28
2   2018-03-01
dtype: datetime64[ns]
>>> s.dt.is_month_start
0    False
1    False
2     True
dtype: bool
>>> s.dt.is_month_end
0    False
1     True
2    False
dtype: bool

-- Example 31902
>>> df = pd.DataFrame({'dates': pd.date_range("2017-03-30",
...                   periods=4)})
>>> df.assign(quarter=df.dates.dt.quarter,
...           is_quarter_start=df.dates.dt.is_quarter_start)
       dates  quarter  is_quarter_start
0 2017-03-30        1             False
1 2017-03-31        1             False
2 2017-04-01        2              True
3 2017-04-02        2             False

-- Example 31903
>>> df = pd.DataFrame({'dates': pd.date_range("2017-03-30",
...                    periods=4)})
>>> df.assign(quarter=df.dates.dt.quarter,
...           is_quarter_end=df.dates.dt.is_quarter_end)
       dates  quarter  is_quarter_end
0 2017-03-30        1           False
1 2017-03-31        1            True
2 2017-04-01        2           False
3 2017-04-02        2           False

-- Example 31904
>>> dates = pd.Series(pd.date_range("2017-12-30", periods=3))
>>> dates
0   2017-12-30
1   2017-12-31
2   2018-01-01
dtype: datetime64[ns]

-- Example 31905
>>> dates.dt.is_year_start
0    False
1    False
2     True
dtype: bool

-- Example 31906
>>> dates = pd.Series(pd.date_range("2017-12-30", periods=3))
>>> dates
0   2017-12-30
1   2017-12-31
2   2018-01-01
dtype: datetime64[ns]

-- Example 31907
>>> dates.dt.is_year_end
0    False
1     True
2    False
dtype: bool

-- Example 31908
>>> idx = pd.date_range("2012-01-01", "2015-01-01", freq="YE")
>>> idx
DatetimeIndex(['2012-12-31', '2013-12-31', '2014-12-31'], dtype='datetime64[ns]', freq=None)
>>> idx.is_leap_year  
array([ True, False, False])

-- Example 31909
>>> dates_series = pd.Series(idx)
>>> dates_series
0   2012-12-31
1   2013-12-31
2   2014-12-31
dtype: datetime64[ns]
>>> dates_series.dt.is_leap_year
0     True
1    False
2    False
dtype: bool

-- Example 31910
>>> rng = pd.date_range('1/1/2018 11:59:00', periods=3, freq='min')
>>> rng
DatetimeIndex(['2018-01-01 11:59:00', '2018-01-01 12:00:00',
               '2018-01-01 12:01:00'],
              dtype='datetime64[ns]', freq=None)
>>> rng.floor('h')
DatetimeIndex(['2018-01-01 11:00:00', '2018-01-01 12:00:00',
               '2018-01-01 12:00:00'],
              dtype='datetime64[ns]', freq=None)

-- Example 31911
>>> pd.Series(rng).dt.floor("h")
0   2018-01-01 11:00:00
1   2018-01-01 12:00:00
2   2018-01-01 12:00:00
dtype: datetime64[ns]

-- Example 31912
>>> rng_tz = pd.DatetimeIndex(["2021-10-31 03:30:00"], tz="Europe/Amsterdam")

-- Example 31913
>>> rng_tz.floor("2h", ambiguous=False)  
DatetimeIndex(['2021-10-31 02:00:00+01:00'],
            dtype='datetime64[ns, Europe/Amsterdam]', freq=None)

-- Example 31914
>>> rng_tz.floor("2h", ambiguous=True)  
DatetimeIndex(['2021-10-31 02:00:00+02:00'],
            dtype='datetime64[ns, Europe/Amsterdam]', freq=None)

-- Example 31915
>>> rng = pd.date_range('1/1/2018 11:59:00', periods=3, freq='min')
>>> rng
DatetimeIndex(['2018-01-01 11:59:00', '2018-01-01 12:00:00',
               '2018-01-01 12:01:00'],
              dtype='datetime64[ns]', freq=None)
>>> rng.ceil('h')
DatetimeIndex(['2018-01-01 12:00:00', '2018-01-01 12:00:00',
               '2018-01-01 13:00:00'],
              dtype='datetime64[ns]', freq=None)

-- Example 31916
>>> pd.Series(rng).dt.ceil("h")
0   2018-01-01 12:00:00
1   2018-01-01 12:00:00
2   2018-01-01 13:00:00
dtype: datetime64[ns]

-- Example 31917
>>> rng_tz = pd.DatetimeIndex(["2021-10-31 01:30:00"], tz="Europe/Amsterdam")

-- Example 31918
>>> rng_tz.ceil("h", ambiguous=False)  
DatetimeIndex(['2021-10-31 02:00:00+01:00'],
            dtype='datetime64[ns, Europe/Amsterdam]', freq=None)

-- Example 31919
>>> rng_tz.ceil("h", ambiguous=True)  
DatetimeIndex(['2021-10-31 02:00:00+02:00'],
            dtype='datetime64[ns, Europe/Amsterdam]', freq=None)

-- Example 31920
>>> rng = pd.date_range('1/1/2018 11:59:00', periods=3, freq='min')
>>> rng
DatetimeIndex(['2018-01-01 11:59:00', '2018-01-01 12:00:00',
               '2018-01-01 12:01:00'],
              dtype='datetime64[ns]', freq=None)
>>> rng.round('h')
DatetimeIndex(['2018-01-01 12:00:00', '2018-01-01 12:00:00',
               '2018-01-01 12:00:00'],
              dtype='datetime64[ns]', freq=None)

-- Example 31921
>>> pd.Series(rng).dt.round("h")
0   2018-01-01 12:00:00
1   2018-01-01 12:00:00
2   2018-01-01 12:00:00
dtype: datetime64[ns]

-- Example 31922
>>> rng_tz = pd.DatetimeIndex(["2021-10-31 03:30:00"], tz="Europe/Amsterdam")

-- Example 31923
>>> rng_tz.floor("2h", ambiguous=False)  
DatetimeIndex(['2021-10-31 02:00:00+01:00'],
              dtype='datetime64[ns, Europe/Amsterdam]', freq=None)

-- Example 31924
>>> rng_tz.floor("2h", ambiguous=True)  
DatetimeIndex(['2021-10-31 02:00:00+02:00'],
              dtype='datetime64[ns, Europe/Amsterdam]', freq=None)

-- Example 31925
>>> ser = pd.Series(pd.to_timedelta([1, 2, 3], unit='d'))
>>> ser
0   1 days
1   2 days
2   3 days
dtype: timedelta64[ns]
>>> ser.dt.days
0    1
1    2
2    3
dtype: int64

-- Example 31926
>>> tdelta_idx = pd.to_timedelta(["0 days", "10 days", "20 days"])
>>> tdelta_idx
TimedeltaIndex(['0 days', '10 days', '20 days'], dtype='timedelta64[ns]', freq=None)
>>> tdelta_idx.days
Index([0, 10, 20], dtype='int64')

-- Example 31927
>>> ser = pd.Series(pd.to_timedelta([1, 2, 3], unit='s'))
>>> ser
0   0 days 00:00:01
1   0 days 00:00:02
2   0 days 00:00:03
dtype: timedelta64[ns]
>>> ser.dt.seconds
0    1
1    2
2    3
dtype: int64

-- Example 31928
>>> tdelta_idx = pd.to_timedelta([1, 2, 3], unit='s')
>>> tdelta_idx
TimedeltaIndex(['0 days 00:00:01', '0 days 00:00:02', '0 days 00:00:03'], dtype='timedelta64[ns]', freq=None)
>>> tdelta_idx.seconds
Index([1, 2, 3], dtype='int64')

-- Example 31929
>>> ser = pd.Series(pd.to_timedelta([1, 2, 3], unit='us'))
>>> ser
0   0 days 00:00:00.000001
1   0 days 00:00:00.000002
2   0 days 00:00:00.000003
dtype: timedelta64[ns]
>>> ser.dt.microseconds
0    1
1    2
2    3
dtype: int64

-- Example 31930
>>> tdelta_idx = pd.to_timedelta([1, 2, 3], unit='us')
>>> tdelta_idx
TimedeltaIndex(['0 days 00:00:00.000001', '0 days 00:00:00.000002',
                '0 days 00:00:00.000003'],
               dtype='timedelta64[ns]', freq=None)
>>> tdelta_idx.microseconds
Index([1, 2, 3], dtype='int64')

