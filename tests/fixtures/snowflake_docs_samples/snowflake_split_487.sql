-- Example 32601
>>> ser1.resample('2D').last()
2020-01-01    2
2020-01-03    4
Freq: None, dtype: int64

-- Example 32602
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32603
>>> ser2.resample('2S').last()
2020-01-01 00:00:00    2.0
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32604
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32605
>>> df.resample('2D').last()
            a  b  c
2020-01-01  1  2  5
2020-01-03  2  6  9

-- Example 32606
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32607
>>> ser1.resample('2D').max()
2020-01-01    2
2020-01-03    4
Freq: None, dtype: int64

-- Example 32608
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32609
>>> ser2.resample('2S').max()
2020-01-01 00:00:00    2.0
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32610
>>> data = [[1, 8], [1, 2], [2, 5], [2, 6]]
>>> df1 = pd.DataFrame(data,
... columns=["a", "b"],
... index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df1
            a  b
2020-01-01  1  8
2020-01-02  1  2
2020-01-03  2  5
2020-01-04  2  6

-- Example 32611
>>> df1.resample('2D').max()
            a  b
2020-01-01  1  8
2020-01-03  2  6

-- Example 32612
>>> df2 = pd.DataFrame(
... {'A': [1, 2, 3, np.nan], 'B': [np.nan, np.nan, 3, 4]},
... index=pd.date_range('2020-01-01', periods=4, freq='1S'))
>>> df2
                       A    B
2020-01-01 00:00:00  1.0  NaN
2020-01-01 00:00:01  2.0  NaN
2020-01-01 00:00:02  3.0  3.0
2020-01-01 00:00:03  NaN  4.0

-- Example 32613
>>> df2.resample('2S').max()
                       A    B
2020-01-01 00:00:00  2.0  NaN
2020-01-01 00:00:02  3.0  4.0

-- Example 32614
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32615
>>> ser1.resample('2D').mean()
2020-01-01    1.5
2020-01-03    3.5
Freq: None, dtype: float64

-- Example 32616
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32617
>>> ser2.resample('2S').mean()
2020-01-01 00:00:00    1.5
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32618
>>> df1 = pd.DataFrame(
... {'A': [1, 1, 2, 1, 2], 'B': [np.nan, 2, 3, 4, 5]},
... index=pd.date_range('2020-01-01', periods=5, freq='1D'))
>>> df1
            A    B
2020-01-01  1  NaN
2020-01-02  1  2.0
2020-01-03  2  3.0
2020-01-04  1  4.0
2020-01-05  2  5.0

-- Example 32619
>>> df1.resample('2D').mean()
              A    B
2020-01-01  1.0  2.0
2020-01-03  1.5  3.5
2020-01-05  2.0  5.0

-- Example 32620
>>> df1.resample('2D')['B'].mean()
2020-01-01    2.0
2020-01-03    3.5
2020-01-05    5.0
Freq: None, Name: B, dtype: float64

-- Example 32621
>>> df2 = pd.DataFrame(
... {'A': [1, 2, 3, np.nan], 'B': [np.nan, np.nan, 3, 4]},
... index=pd.date_range('2020-01-01', periods=4, freq='1S'))
>>> df2
                       A    B
2020-01-01 00:00:00  1.0  NaN
2020-01-01 00:00:01  2.0  NaN
2020-01-01 00:00:02  3.0  3.0
2020-01-01 00:00:03  NaN  4.0

-- Example 32622
>>> df2.resample('2S').mean()
                       A    B
2020-01-01 00:00:00  1.5  NaN
2020-01-01 00:00:02  3.0  3.5

-- Example 32623
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32624
>>> ser1.resample('2D').median()
2020-01-01    1.5
2020-01-03    3.5
Freq: None, dtype: float64

-- Example 32625
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32626
>>> ser2.resample('2S').median()
2020-01-01 00:00:00    1.5
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32627
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32628
>>> df.resample('2D').median()
              a    b    c
2020-01-01  1.0  5.0  3.5
2020-01-03  2.0  5.5  8.5

-- Example 32629
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32630
>>> ser1.resample('2D').min()
2020-01-01    1
2020-01-03    3
Freq: None, dtype: int64

-- Example 32631
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32632
>>> ser2.resample('2S').min()
2020-01-01 00:00:00    1.0
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32633
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32634
>>> df.resample('2D').min()
            a  b  c
2020-01-01  1  2  2
2020-01-03  2  5  8

-- Example 32635
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 1, 2, 2], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    1
2020-01-03    2
2020-01-04    2
Freq: None, dtype: int64

-- Example 32636
>>> ser1.resample('2D').nunique()
2020-01-01    1
2020-01-03    1
Freq: None, dtype: int64

-- Example 32637
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32638
>>> df.resample('2D').nunique()
            a  b  c
2020-01-01  1  2  2
2020-01-03  1  2  2

-- Example 32639
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32640
>>> ser1.resample('2D').quantile()
2020-01-01    1.5
2020-01-03    3.5
Freq: None, dtype: float64

-- Example 32641
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32642
>>> df.resample('2D').quantile(q=0.2)
              a      b    c
2020-01-01  1.0  3.199  2.6
2020-01-03  2.0  5.200  8.2

-- Example 32643
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32644
>>> ser1.resample('2D').std()
2020-01-01    0.707107
2020-01-03    0.707107
Freq: None, dtype: float64

-- Example 32645
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32646
>>> ser2.resample('2S').std()
2020-01-01 00:00:00    0.707107
2020-01-01 00:00:02         NaN
Freq: None, dtype: float64

-- Example 32647
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32648
>>> df.resample('2D').std()
              a         b         c
2020-01-01  0.0  4.242641  2.121320
2020-01-03  0.0  0.707107  0.707107

-- Example 32649
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32650
>>> ser1.resample('2D').size()
2020-01-01    2
2020-01-03    2
Freq: None, dtype: int64

-- Example 32651
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32652
>>> ser2.resample('2S').size()
2020-01-01 00:00:00    2
2020-01-01 00:00:02    2
Freq: None, dtype: int64

-- Example 32653
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32654
>>> df.resample('2D').size()
2020-01-01    2
2020-01-03    2
Freq: None, dtype: int64

-- Example 32655
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32656
>>> ser1.resample('2D').sum()
2020-01-01    3
2020-01-03    7
Freq: None, dtype: int64

-- Example 32657
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32658
>>> ser2.resample('2S').sum()
2020-01-01 00:00:00    3.0
2020-01-01 00:00:02    4.0
Freq: None, dtype: float64

-- Example 32659
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32660
>>> df.resample('2D').sum()
            a   b   c
2020-01-01  2  10   7
2020-01-03  4  11  17

-- Example 32661
>>> lst1 = pd.date_range('2020-01-01', periods=4, freq='1D')
>>> ser1 = pd.Series([1, 2, 3, 4], index=lst1)
>>> ser1
2020-01-01    1
2020-01-02    2
2020-01-03    3
2020-01-04    4
Freq: None, dtype: int64

-- Example 32662
>>> ser1.resample('2D').var()
2020-01-01    0.5
2020-01-03    0.5
Freq: None, dtype: float64

-- Example 32663
>>> lst2 = pd.date_range('2020-01-01', periods=4, freq='S')
>>> ser2 = pd.Series([1, 2, np.nan, 4], index=lst2)
>>> ser2
2020-01-01 00:00:00    1.0
2020-01-01 00:00:01    2.0
2020-01-01 00:00:02    NaN
2020-01-01 00:00:03    4.0
Freq: None, dtype: float64

-- Example 32664
>>> ser2.resample('2S').var()
2020-01-01 00:00:00    0.5
2020-01-01 00:00:02    NaN
Freq: None, dtype: float64

-- Example 32665
>>> data = [[1, 8, 2], [1, 2, 5], [2, 5, 8], [2, 6, 9]]
>>> df = pd.DataFrame(data,
...      columns=["a", "b", "c"],
...      index=pd.date_range('2020-01-01', periods=4, freq='1D'))
>>> df
            a  b  c
2020-01-01  1  8  2
2020-01-02  1  2  5
2020-01-03  2  5  8
2020-01-04  2  6  9

-- Example 32666
>>> df.resample('2D').var()
              a     b    c
2020-01-01  0.0  18.0  4.5
2020-01-03  0.0   0.5  0.5

-- Example 32667
import modin.pandas as pd
import numpy as np
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
df = pd.concat([pd.DataFrame([range(i, i+5)]) for i in range(0, 150, 5)])
print(df)
df = df.reset_index(drop=True)
print(df)

