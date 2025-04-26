-- Example 31931
>>> ser = pd.Series(pd.to_timedelta([1, 2, 3], unit='ns'))
>>> ser
0   0 days 00:00:00.000000001
1   0 days 00:00:00.000000002
2   0 days 00:00:00.000000003
dtype: timedelta64[ns]
>>> ser.dt.nanoseconds
0    1
1    2
2    3
dtype: int64

-- Example 31932
>>> tdelta_idx = pd.to_timedelta([1, 2, 3], unit='ns')
>>> tdelta_idx
TimedeltaIndex(['0 days 00:00:00.000000001', '0 days 00:00:00.000000002',
                '0 days 00:00:00.000000003'],
               dtype='timedelta64[ns]', freq=None)
>>> tdelta_idx.nanoseconds
Index([1, 2, 3], dtype='int64')

-- Example 31933
>>> dti = pd.date_range(start='2014-08-01 09:00',
...                     freq='h', periods=3, tz='Europe/Berlin')

-- Example 31934
>>> dti  
DatetimeIndex(['2014-08-01 09:00:00+02:00',
               '2014-08-01 10:00:00+02:00',
               '2014-08-01 11:00:00+02:00'],
              dtype='datetime64[ns, Europe/Berlin]', freq='h')

-- Example 31935
>>> dti.tz_convert('US/Central')  
DatetimeIndex(['2014-08-01 02:00:00-05:00',
               '2014-08-01 03:00:00-05:00',
               '2014-08-01 04:00:00-05:00'],
              dtype='datetime64[ns, US/Central]', freq='h')

-- Example 31936
>>> dti = pd.date_range(start='2014-08-01 09:00', freq='h',
...                     periods=3, tz='Europe/Berlin')

-- Example 31937
>>> dti  
DatetimeIndex(['2014-08-01 09:00:00+02:00',
               '2014-08-01 10:00:00+02:00',
               '2014-08-01 11:00:00+02:00'],
              dtype='datetime64[ns, Europe/Berlin]', freq='h')

-- Example 31938
>>> dti.tz_convert(None)  
DatetimeIndex(['2014-08-01 07:00:00',
               '2014-08-01 08:00:00',
               '2014-08-01 09:00:00'],
              dtype='datetime64[ns]', freq='h')

-- Example 31939
>>> tz_naive = pd.date_range('2018-03-01 09:00', periods=3)
>>> tz_naive
DatetimeIndex(['2018-03-01 09:00:00', '2018-03-02 09:00:00',
               '2018-03-03 09:00:00'],
              dtype='datetime64[ns]', freq=None)

-- Example 31940
>>> tz_aware = tz_naive.tz_localize(tz='US/Eastern')  
>>> tz_aware  
DatetimeIndex(['2018-03-01 09:00:00-05:00',
               '2018-03-02 09:00:00-05:00',
               '2018-03-03 09:00:00-05:00'],
              dtype='datetime64[ns, US/Eastern]', freq=None)

-- Example 31941
>>> tz_aware.tz_localize(None)  
DatetimeIndex(['2018-03-01 09:00:00', '2018-03-02 09:00:00',
               '2018-03-03 09:00:00'],
              dtype='datetime64[ns]', freq=None)

-- Example 31942
>>> s = pd.to_datetime(pd.Series(['2018-10-28 01:30:00',
...                             '2018-10-28 02:00:00',
...                             '2018-10-28 02:30:00',
...                             '2018-10-28 02:00:00',
...                             '2018-10-28 02:30:00',
...                             '2018-10-28 03:00:00',
...                             '2018-10-28 03:30:00']))
>>> s.dt.tz_localize('CET', ambiguous='infer')  
0   2018-10-28 01:30:00+02:00
1   2018-10-28 02:00:00+02:00
2   2018-10-28 02:30:00+02:00
3   2018-10-28 02:00:00+01:00
4   2018-10-28 02:30:00+01:00
5   2018-10-28 03:00:00+01:00
6   2018-10-28 03:30:00+01:00
dtype: datetime64[ns, CET]

-- Example 31943
>>> s = pd.to_datetime(pd.Series(['2018-10-28 01:20:00',
...                             '2018-10-28 02:36:00',
...                             '2018-10-28 03:46:00']))
>>> s.dt.tz_localize('CET', ambiguous=np.array([True, True, False]))  
0   2018-10-28 01:20:00+02:00
1   2018-10-28 02:36:00+02:00
2   2018-10-28 03:46:00+01:00
dtype: datetime64[ns, CET]

-- Example 31944
>>> s = pd.to_datetime(pd.Series(['2015-03-29 02:30:00',
...                             '2015-03-29 03:30:00']))
>>> s.dt.tz_localize('Europe/Warsaw', nonexistent='shift_forward')  
0   2015-03-29 03:00:00+02:00
1   2015-03-29 03:30:00+02:00
dtype: datetime64[ns, Europe/Warsaw]

-- Example 31945
>>> s.dt.tz_localize('Europe/Warsaw', nonexistent='shift_backward')  
0   2015-03-29 01:59:59.999999999+01:00
1   2015-03-29 03:30:00+02:00
dtype: datetime64[ns, Europe/Warsaw]

-- Example 31946
>>> s.dt.tz_localize('Europe/Warsaw', nonexistent=pd.Timedelta('1h'))  
0   2015-03-29 03:30:00+02:00
1   2015-03-29 03:30:00+02:00
dtype: datetime64[ns, Europe/Warsaw]

-- Example 31947
>>> s = pd.Series(['lower', 'CAPITALS', 'this is a sentence', 'SwApCaSe'])
>>> s
0                 lower
1              CAPITALS
2    this is a sentence
3              SwApCaSe
dtype: object

-- Example 31948
>>> s.str.capitalize()
0                 Lower
1              Capitals
2    This is a sentence
3              Swapcase
dtype: object

-- Example 31949
>>> ser = pd.Series(['dog', 'bird', 'mouse'])
>>> ser.str.center(8, fillchar='.')
0    ..dog...
1    ..bird..
2    .mouse..
dtype: object

-- Example 31950
>>> ser = pd.Series(['dog', 'bird', 'mouse'])
>>> ser.str.ljust(8, fillchar='.')
0    dog.....
1    bird....
2    mouse...
dtype: object

-- Example 31951
>>> ser = pd.Series(['dog', 'bird', 'mouse'])
>>> ser.str.rjust(8, fillchar='.')
0    .....dog
1    ....bird
2    ...mouse
dtype: object

-- Example 31952
>>> s1 = pd.Series(['Mouse', 'dog', 'house and parrot', '23', np.nan])
>>> s1.str.contains('og', regex=False)
0    False
1     True
2    False
3    False
4     None
dtype: object

-- Example 31953
>>> ind = pd.Index(['Mouse', 'dog', 'house and parrot', '23.0', np.nan])
>>> ind.str.contains('23', regex=False)
Index([False, False, False, True, None], dtype='object')

-- Example 31954
>>> s1.str.contains('oG', case=True, regex=True)
0    False
1    False
2    False
3    False
4     None
dtype: object

-- Example 31955
>>> s1.str.contains('og', na=False, regex=True)
0    False
1     True
2    False
3    False
4    False
dtype: bool

-- Example 31956
>>> s1.str.contains('house|dog', regex=True)
0    False
1     True
2     True
3    False
4     None
dtype: object

-- Example 31957
>>> import re
>>> s1.str.contains('PARROT', flags=re.IGNORECASE, regex=True)
0    False
1    False
2     True
3    False
4     None
dtype: object

-- Example 31958
>>> s1.str.contains('\d', regex=True)
0    False
1    False
2    False
3     True
4     None
dtype: object

-- Example 31959
>>> s2 = pd.Series(['40', '40.0', '41', '41.0', '35'])
>>> s2.str.contains('.0', regex=True)
0     True
1     True
2    False
3     True
4    False
dtype: bool

-- Example 31960
>>> s = pd.Series(['A', 'B', 'Aaba', 'Baca', np.nan, 'CABA', 'cat'])
>>> s.str.count('a')
0    0.0
1    0.0
2    2.0
3    2.0
4    NaN
5    0.0
6    1.0
dtype: float64

-- Example 31961
>>> s = pd.Series(['$', 'B', 'Aab$', '$$ca', 'C$B$', 'cat'])
>>> s.str.count('\$')
0    1
1    0
2    1
3    2
4    2
5    0
dtype: int64

-- Example 31962
>>> pd.Index(['A', 'A', 'Aaba', 'cat']).str.count('a')
Index([0, 0, 2, 1], dtype='int64')

-- Example 31963
>>> s = pd.Series(['bat', 'bear', 'caT', np.nan])
>>> s
0     bat
1    bear
2     caT
3    None
dtype: object

-- Example 31964
>>> s.str.endswith('t')
0     True
1    False
2    False
3     None
dtype: object

-- Example 31965
>>> s.str.endswith(('t', 'T'))
0     True
1    False
2     True
3     None
dtype: object

-- Example 31966
>>> s.str.endswith('t', na=False)
0     True
1    False
2    False
3    False
dtype: bool

-- Example 31967
>>> s = pd.Series(["String",
...            (1, 2, 3),
...            ["a", "b", "c"],
...            123,
...            -456,
...            {1: "Hello", "2": "World"}])
>>> s.str.get(1)
0       t
1    None
2    None
3    None
4    None
5    None
dtype: object

-- Example 31968
>>> s.str.get(-1)
0       g
1    None
2    None
3    None
4    None
5    None
dtype: object

-- Example 31969
>>> s = pd.Series(['23', '³', '⅕', ''])

-- Example 31970
>>> s = pd.Series(['leopard', 'Golden Eagle', 'SNAKE', ''])
>>> s.str.islower()
0     True
1    False
2    False
3    False
dtype: bool

-- Example 31971
>>> s = pd.Series(['leopard', 'Golden Eagle', 'SNAKE', '', 'Snake'])
>>> s.str.istitle()
0    False
1     True
2    False
3    False
4     True
dtype: bool

-- Example 31972
>>> s = pd.Series(['leopard', 'Golden Eagle', 'SNAKE', ''])
>>> s.str.isupper()
0    False
1    False
2     True
3    False
dtype: bool

-- Example 31973
>>> s = pd.Series(['dog',
...                 '',
...                 5,
...                 {'foo' : 'bar'},
...                 [2, 3, 5, 7],
...                 ('one', 'two', 'three')])
>>> s.str.len()
0    3.0
1    0.0
2    NaN
3    NaN
4    NaN
5    NaN
dtype: float64

-- Example 31974
>>> s = pd.Series(['1. Ant.  ', '2. Bee!\n', '3. Cat?\t', np.nan, 10, True])
>>> s  
0    1. Ant.
1    2. Bee!\n
2    3. Cat?\t
3         None
4           10
5         True
dtype: object

-- Example 31975
>>> s.str.lstrip('123.')  
0    Ant.
1    Bee!\n
2    Cat?\t
3      None
4      None
5      None
dtype: object

-- Example 31976
>>> ser = pd.Series(["horse", "eagle", "donkey"])
>>> ser.str.match("e")
0    False
1     True
2    False
dtype: bool

-- Example 31977
>>> pd.Series(['foo', 'fuz', np.nan]).str.replace('f.', 'ba', regex=True)
0     bao
1     baz
2    None
dtype: object

-- Example 31978
>>> pd.Series(['f.o', 'fuz', np.nan]).str.replace('f.', 'ba', regex=False)
0     bao
1     fuz
2    None
dtype: object

-- Example 31979
>>> s = pd.Series(['1. Ant.  ', '2. Bee!\n', '3. Cat?\t', np.nan, 10, True])
>>> s  
0    1. Ant.
1    2. Bee!\n
2    3. Cat?\t
3         None
4           10
5         True
dtype: object

-- Example 31980
>>> s.str.rstrip('.!? \n\t')
0    1. Ant
1    2. Bee
2    3. Cat
3      None
4      None
5      None
dtype: object

-- Example 31981
>>> s = pd.Series(["koala", "dog", "chameleon"])
>>> s
0        koala
1          dog
2    chameleon
dtype: object

-- Example 31982
>>> s.str.slice(start=1)
0        oala
1          og
2    hameleon
dtype: object

-- Example 31983
>>> s.str.slice(start=-1)
0    a
1    g
2    n
dtype: object

-- Example 31984
>>> s.str.slice(stop=2)
0    ko
1    do
2    ch
dtype: object

-- Example 31985
>>> s.str.slice(step=2)
0      kaa
1       dg
2    caeen
dtype: object

-- Example 31986
>>> s.str.slice(start=0, stop=5, step=3)
0    kl
1     d
2    cm
dtype: object

-- Example 31987
>>> s = pd.Series(
...     [
...         "this is a regular sentence",
...         "https://docs.python.org/3/tutorial/index.html",
...         np.nan
...     ]
... )
>>> s
0                       this is a regular sentence
1    https://docs.python.org/3/tutorial/index.html
2                                             None
dtype: object

-- Example 31988
>>> s.str.split()
0                   [this, is, a, regular, sentence]
1    [https://docs.python.org/3/tutorial/index.html]
2                                               None
dtype: object

-- Example 31989
>>> s.str.split(n=2)
0                     [this, is, a regular sentence]
1    [https://docs.python.org/3/tutorial/index.html]
2                                               None
dtype: object

-- Example 31990
>>> s.str.split(pat="/")
0                         [this is a regular sentence]
1    [https:, , docs.python.org, 3, tutorial, index...
2                                                 None
dtype: object

-- Example 31991
>>> s.str.split(expand=True)
                                               0     1     2        3         4
0                                           this    is     a  regular  sentence
1  https://docs.python.org/3/tutorial/index.html  None  None     None      None
2                                           None  None  None     None      None

-- Example 31992
>>> s = pd.Series(['bat', 'Bear', 'cat', np.nan])
>>> s
0     bat
1    Bear
2     cat
3    None
dtype: object

-- Example 31993
>>> s.str.startswith('b')
0     True
1    False
2    False
3     None
dtype: object

-- Example 31994
>>> s.str.startswith(('b', 'B'))
0     True
1     True
2    False
3     None
dtype: object

-- Example 31995
>>> s.str.startswith('b', na=False)
0     True
1    False
2    False
3    False
dtype: bool

-- Example 31996
>>> s = pd.Series(['1. Ant.  ', '2. Bee!\n', '3. Cat?\t', np.nan, 10, True])
>>> s  
0    1. Ant.
1    2. Bee!\n
2    3. Cat?\t
3         None
4           10
5         True
dtype: object

-- Example 31997
>>> s.str.strip()
0    1. Ant.
1    2. Bee!
2    3. Cat?
3       None
4       None
5       None
dtype: object

