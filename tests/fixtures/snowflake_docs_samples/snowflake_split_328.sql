-- Example 21954
>>> df = session.create_dataframe([['Hello', 'World', ',']], schema=['a', 'b', 'sep'])
>>> df.select(concat_ws('sep', df.a, df.b)).show()
--------------------------------------
|"CONCAT_WS(""SEP"", ""A"", ""B"")"  |
--------------------------------------
|Hello,World                         |
--------------------------------------

-- Example 21955
>>> df = session.create_dataframe([[1,2], [3,4], [5,5] ], schema=["a","b"])
>>> df.select(contains(col("a"), col("b")).alias("result")).show()
------------
|"RESULT"  |
------------
|False     |
|False     |
|True      |
------------

-- Example 21956
>>> import datetime
>>> from dateutil import tz
>>> datetime_with_tz = datetime.datetime(2022, 4, 6, 9, 0, 0, tzinfo=tz.tzoffset("myzone", -3600*7))
>>> datetime_with_no_tz = datetime.datetime(2022, 4, 6, 9, 0, 0)
>>> df = session.create_dataframe([[datetime_with_tz, datetime_with_no_tz]], schema=["a", "b"])
>>> result = df.select(convert_timezone(lit("UTC"), col("a")), convert_timezone(lit("UTC"), col("b"), lit("Asia/Shanghai"))).collect()
>>> result[0][0]
datetime.datetime(2022, 4, 6, 16, 0, tzinfo=<UTC>)
>>> result[0][1]
datetime.datetime(2022, 4, 6, 1, 0)

-- Example 21957
>>> df = session.create_dataframe([[1, 2], [1, 2], [4, 5], [2, 3], [3, None], [4, None], [6,4]], schema=["a", "b"])
>>> df.select(corr(col("a"), col("b")).alias("result")).show()
---------------------
|"RESULT"           |
---------------------
|0.813681508328809  |
---------------------

-- Example 21958
>>> from math import pi
>>> df = session.create_dataframe([[pi]], schema=["deg"])
>>> df.select(cos(col("deg")).alias("result")).show()
------------
|"RESULT"  |
------------
|-1.0      |
------------

-- Example 21959
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[0]], schema=["deg"])
>>> df.select(cosh(col("deg")).alias("result")).show()
------------
|"RESULT"  |
------------
|1.0       |
------------

-- Example 21960
>>> df = session.create_dataframe([[1], [None], [3], [4], [None]], schema=["a"])
>>> df.select(count(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

>>> df.select(count("*").alias("result")).show()
------------
|"RESULT"  |
------------
|5         |
------------

-- Example 21961
>>> df = session.create_dataframe([[1, 2], [1, 2], [3, None], [2, 3], [3, None], [4, None]], schema=["a", "b"])
>>> df.select(count_distinct(col("a"), col("b")).alias("result")).show()
------------
|"RESULT"  |
------------
|2         |
------------

>>> #  The result should be 2 for {[1,2],[2,3]} since the rest are either duplicate or NULL records

-- Example 21962
>>> df = session.create_dataframe([[1, 2], [1, 2], [3, None], [2, 3], [3, None], [4, None]], schema=["a", "b"])
>>> df.select(count_distinct(col("a"), col("b")).alias("result")).show()
------------
|"RESULT"  |
------------
|2         |
------------

>>> #  The result should be 2 for {[1,2],[2,3]} since the rest are either duplicate or NULL records

-- Example 21963
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2], [1, 2], [4, 5], [2, 3], [3, None], [4, None], [6,4]], schema=["a", "b"])
>>> df.select(covar_pop(col("a"), col("b")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.840     |
------------

-- Example 21964
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2], [1, 2], [4, 5], [2, 3], [3, None], [4, None], [6,4]], schema=["a", "b"])
>>> df.select(covar_samp(col("a"), col("b")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|2.300     |
------------

-- Example 21965
>>> from snowflake.snowpark.functions import create_map
>>> df = session.create_dataframe([("Paris", "France"), ("Tokyo", "Japan")], ("city", "country"))
>>> df.select(create_map("city", "country").alias("map")).show()
-----------------------
|"MAP"                |
-----------------------
|{                    |
|  "Paris": "France"  |
|}                    |
|{                    |
|  "Tokyo": "Japan"   |
|}                    |
-----------------------

-- Example 21966
>>> df.select(create_map([df.city, df.country]).alias("map")).show()
-----------------------
|"MAP"                |
-----------------------
|{                    |
|  "Paris": "France"  |
|}                    |
|{                    |
|  "Tokyo": "Japan"   |
|}                    |
-----------------------

-- Example 21967
>>> from snowflake.snowpark.window import Window
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2], [1, 2], [1,3], [4, 5], [2, 3], [3, 4], [4, 7], [3,7], [4,5]], schema=["a", "b"])
>>> df.select(cume_dist().over(Window.order_by("a")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.333     |
|0.333     |
|0.333     |
|0.444     |
|0.667     |
|0.667     |
|1.000     |
|1.000     |
|1.000     |
------------

-- Example 21968
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_account()).collect()
>>> assert result[0]['CURRENT_ACCOUNT()'] is not None

-- Example 21969
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_available_roles()).collect()
>>> assert result[0]['CURRENT_AVAILABLE_ROLES()'] is not None

-- Example 21970
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_database()).collect()
>>> assert result[0]['CURRENT_DATABASE()'] is not None

-- Example 21971
>>> import datetime
>>> result = session.create_dataframe([1]).select(current_date()).collect()
>>> assert isinstance(result[0]["CURRENT_DATE()"], datetime.date)

-- Example 21972
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_region()).collect()
>>> assert result[0]['CURRENT_REGION()'] is not None

-- Example 21973
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_role()).collect()
>>> assert result[0]['CURRENT_ROLE()'] is not None

-- Example 21974
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_schema()).collect()
>>> assert result[0]['CURRENT_SCHEMA()'] is not None

-- Example 21975
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_schemas()).collect()
>>> assert result[0]['CURRENT_SCHEMAS()'] is not None

-- Example 21976
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_session()).collect()
>>> assert result[0]['CURRENT_SESSION()'] is not None

-- Example 21977
>>> # Return result is tied to session, so we only test if the result exists
>>> session.create_dataframe([1]).select(current_statement()).collect()
[Row(CURRENT_STATEMENT()='SELECT current_statement() FROM ( SELECT "_1" FROM ( SELECT $1 AS "_1" FROM  VALUES (1 :: INT)))')]

-- Example 21978
>>> import datetime
>>> result = session.create_dataframe([1]).select(current_time()).collect()
>>> assert isinstance(result[0]["CURRENT_TIME()"], datetime.time)

-- Example 21979
>>> import datetime
>>> result = session.create_dataframe([1]).select(current_timestamp()).collect()
>>> assert isinstance(result[0]["CURRENT_TIMESTAMP()"], datetime.datetime)

-- Example 21980
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_user()).collect()
>>> assert result[0]['CURRENT_USER()'] is not None

-- Example 21981
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_version()).collect()
>>> assert result[0]['CURRENT_VERSION()'] is not None

-- Example 21982
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_warehouse()).collect()
>>> assert result[0]['CURRENT_WAREHOUSE()'] is not None

-- Example 21983
>>> df = session.create_dataframe([("2023-10-10",), ("2022-05-15",), ("invalid",)], schema=['date'])
>>> df.select(date_format('date', 'YYYY/MM/DD').as_('formatted_date')).show()
--------------------
|"FORMATTED_DATE"  |
--------------------
|2023/10/10        |
|2022/05/15        |
|NULL              |
--------------------

-- Example 21984
>>> df = session.create_dataframe([("2023-10-10 15:30:00",), ("2022-05-15 10:45:00",)], schema=['timestamp'])
>>> df.select(date_format('timestamp', 'YYYY/MM/DD HH:mi:ss').as_('formatted_ts')).show()
-----------------------
|"FORMATTED_TS"       |
-----------------------
|2023/10/10 15:30:00  |
|2022/05/15 10:45:00  |
-----------------------

-- Example 21985
>>> df = session.sql("select '2023-10-10'::DATE as date_col, '2023-10-10 15:30:00'::TIMESTAMP as timestamp_col")
>>> df.select(
...     date_format('date_col', 'YYYY/MM/DD').as_('formatted_dt'),
...     date_format('timestamp_col', 'YYYY/MM/DD HH:mi:ss').as_('formatted_ts')
... ).show()
----------------------------------------
|"FORMATTED_DT"  |"FORMATTED_TS"       |
----------------------------------------
|2023/10/10      |2023/10/10 15:30:00  |
----------------------------------------

-- Example 21986
>>> df = session.create_dataframe([[2022, 4, 1]], schema=["year", "month", "day"])
>>> df.select(date_from_parts("year", "month", "day")).collect()
[Row(DATE_FROM_PARTS("YEAR", "MONTH", "DAY")=datetime.date(2022, 4, 1))]
>>> session.table("dual").select(date_from_parts(2022, 4, 1)).collect()
[Row(DATE_FROM_PARTS(2022, 4, 1)=datetime.date(2022, 4, 1))]

-- Example 21987
>>> import datetime
>>> df = session.create_dataframe([[datetime.datetime(2023, 1, 1, 1, 1, 1)]], schema=["ts_col"])
>>> df.select(date_part("year", col("ts_col")).alias("year"), date_part("epoch_second", col("ts_col")).alias("epoch_second")).show()
---------------------------
|"YEAR"  |"EPOCH_SECOND"  |
---------------------------
|2023    |1672534861      |
---------------------------

-- Example 21988
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(date_trunc("YEAR", "a"), date_trunc("MONTH", "a"), date_trunc("DAY", "a")).collect()
[Row(DATE_TRUNC('YEAR', "A")=datetime.datetime(2020, 1, 1, 0, 0), DATE_TRUNC('MONTH', "A")=datetime.datetime(2020, 5, 1, 0, 0), DATE_TRUNC('DAY', "A")=datetime.datetime(2020, 5, 1, 0, 0))]
>>> df.select(date_trunc("HOUR", "a"), date_trunc("MINUTE", "a"), date_trunc("SECOND", "a")).collect()
[Row(DATE_TRUNC('HOUR', "A")=datetime.datetime(2020, 5, 1, 13, 0), DATE_TRUNC('MINUTE', "A")=datetime.datetime(2020, 5, 1, 13, 11), DATE_TRUNC('SECOND', "A")=datetime.datetime(2020, 5, 1, 13, 11, 20))]
>>> df.select(date_trunc("QUARTER", "a")).collect()
[Row(DATE_TRUNC('QUARTER', "A")=datetime.datetime(2020, 4, 1, 0, 0))]

-- Example 21989
>>> # add one year on dates
>>> import datetime
>>> date_df = session.create_dataframe([[datetime.date(2020, 1, 1)]], schema=["date_col"])
>>> date_df.select(dateadd("year", lit(1), col("date_col")).alias("year_added")).show()
----------------
|"YEAR_ADDED"  |
----------------
|2021-01-01    |
----------------

>>> date_df.select(dateadd("month", lit(1), col("date_col")).alias("month_added")).show()
-----------------
|"MONTH_ADDED"  |
-----------------
|2020-02-01     |
-----------------

>>> date_df.select(dateadd("day", lit(1), col("date_col")).alias("day_added")).show()
---------------
|"DAY_ADDED"  |
---------------
|2020-01-02   |
---------------

-- Example 21990
>>> # year difference between two date columns
>>> import datetime
>>> date_df = session.create_dataframe([[datetime.date(2020, 1, 1), datetime.date(2021, 1, 1)]], schema=["date_col1", "date_col2"])
>>> date_df.select(datediff("year", col("date_col1"), col("date_col2")).alias("year_diff")).show()
---------------
|"YEAR_DIFF"  |
---------------
|1            |
---------------

-- Example 21991
>>> from snowflake.snowpark.functions import date_add, to_date
>>> df = session.createDataFrame([("1976-01-06")], ["date"])
>>> df = df.withColumn("date", to_date("date"))
>>> res = df.withColumn("date", date_add("date", 4)).show()
--------------
|"DATE"      |
--------------
|1976-01-10  |
--------------

-- Example 21992
>>> from snowflake.snowpark.functions import date_sub, to_date
>>> df = session.createDataFrame([("1976-01-06")], ["date"])
>>> df = df.withColumn("date", to_date("date"))
>>> df.withColumn("date", date_sub("date", 2)).show()
--------------
|"DATE"      |
--------------
|1976-01-04  |
--------------

-- Example 21993
>>> from snowflake.snowpark.functions import daydiff, to_date
>>> df = session.createDataFrame([("2015-04-08", "2015-05-10")], ["d1", "d2"])
>>> res = df.select(daydiff(to_date(df.d2), to_date(df.d1)).alias("diff")).show()
----------
|"DIFF"  |
----------
|32      |
----------

-- Example 21994
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayname("a")).collect()
[Row(DAYNAME("A")='Fri')]

-- Example 21995
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayofmonth("a")).collect()
[Row(DAYOFMONTH("A")=1)]

-- Example 21996
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayofweek("a")).collect()
[Row(DAYOFWEEK("A")=5)]

-- Example 21997
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayofyear("a")).collect()
[Row(DAYOFYEAR("A")=122)]

-- Example 21998
>>> import math
>>> from snowflake.snowpark.types import StructType, StructField, DoubleType, IntegerType
>>> df = session.create_dataframe(
...     [math.pi / 3, math.pi, 3 * math.pi],
...     schema=StructType([StructField("a", DoubleType())]),
... )
>>> df.select(degrees(col("a")).cast(IntegerType()).alias("DEGREES")).collect()
[Row(DEGREES=60), Row(DEGREES=180), Row(DEGREES=540)]

-- Example 21999
>>> from snowflake.snowpark.window import Window
>>> window = Window.order_by("key")
>>> df = session.create_dataframe([(1, "1"), (2, "2"), (1, "3"), (2, "4")], schema=["key", "value"])
>>> df.select(dense_rank().over(window).as_("dense_rank")).collect()
[Row(DENSE_RANK=1), Row(DENSE_RANK=1), Row(DENSE_RANK=2), Row(DENSE_RANK=2)]

-- Example 22000
>>> df = session.create_dataframe([1, 2, 3, None, None], schema=["a"])
>>> df.sort(desc(df["a"])).collect()
[Row(A=3), Row(A=2), Row(A=1), Row(A=None), Row(A=None)]

-- Example 22001
>>> df = session.create_dataframe([1, 2, 3, None, None], schema=["a"])
>>> df.sort(desc_nulls_first(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=3), Row(A=2), Row(A=1)]

-- Example 22002
>>> df = session.create_dataframe([1, 2, 3, None, None], schema=["a"])
>>> df.sort(desc_nulls_last(df["a"])).collect()
[Row(A=3), Row(A=2), Row(A=1), Row(A=None), Row(A=None)]

-- Example 22003
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(div0(df["a"], 1).alias("divided_by_one"), div0(df["a"], 0).alias("divided_by_zero")).collect()
[Row(DIVIDED_BY_ONE=Decimal('1.000000'), DIVIDED_BY_ZERO=Decimal('0.000000'))]

-- Example 22004
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(divnull(df["a"], 1).alias("divided_by_one"), divnull(df["a"], 0).alias("divided_by_zero")).collect()
[Row(DIVIDED_BY_ONE=Decimal('1.000000'), DIVIDED_BY_ZERO=None)]

-- Example 22005
>>> df = session.create_dataframe(
...     [["abc", "def"], ["abcdef", "abc"], ["snow", "flake"]],
...     schema=["s1", "s2"]
... )
>>> df.select(
...     editdistance(col("s1"), col("s2")).alias("distance"),
...     editdistance(col("s1"), col("s2"), 2).alias("max_2_distance")
... ).collect()
[Row(DISTANCE=3, MAX_2_DISTANCE=2), Row(DISTANCE=3, MAX_2_DISTANCE=2), Row(DISTANCE=5, MAX_2_DISTANCE=2)]

-- Example 22006
>>> df = session.create_dataframe(["apple", "banana", "peach"], schema=["a"])
>>> df.select(endswith(df["a"], lit("ana")).alias("endswith")).collect()
[Row(ENDSWITH=False), Row(ENDSWITH=True), Row(ENDSWITH=False)]

-- Example 22007
>>> import math
>>> df = session.create_dataframe([1.1, math.nan, 2.3], schema=["a"])
>>> df.select(equal_nan(df["a"]).alias("equal_nan")).collect()
[Row(EQUAL_NAN=False), Row(EQUAL_NAN=True), Row(EQUAL_NAN=False)]

-- Example 22008
>>> df = session.create_dataframe([[1, 1], [1, None], [None, 2], [None, None]], schema=["a", "b"])
>>> df.select(equal_null(df["a"], df["b"]).alias("equal_null")).collect()
[Row(EQUAL_NULL=True), Row(EQUAL_NULL=False), Row(EQUAL_NULL=False), Row(EQUAL_NULL=True)]

-- Example 22009
>>> import math
>>> from snowflake.snowpark.types import IntegerType
>>> df = session.create_dataframe([0.0, math.log(10)], schema=["a"])
>>> df.select(exp(df["a"]).cast(IntegerType()).alias("exp")).collect()
[Row(EXP=1), Row(EXP=10)]

-- Example 22010
>>> df = session.create_dataframe([[1, [1, 2, 3], {"Ashi Garami": "Single Leg X"}, "Kimura"],
...                                [2, [11, 22], {"Sankaku": "Triangle"}, "Coffee"]],
...                                schema=["idx", "lists", "maps", "strs"])
>>> df.select(df.idx, explode(df.lists)).sort(col("idx")).show()
-------------------
|"IDX"  |"VALUE"  |
-------------------
|1      |1        |
|1      |2        |
|1      |3        |
|2      |11       |
|2      |22       |
-------------------

-- Example 22011
>>> df.select(df.strs, explode(df.maps)).sort(col("strs")).show()
-----------------------------------------
|"STRS"  |"KEY"        |"VALUE"         |
-----------------------------------------
|Coffee  |Sankaku      |"Triangle"      |
|Kimura  |Ashi Garami  |"Single Leg X"  |
-----------------------------------------

-- Example 22012
>>> df.select(explode(col("lists")).alias("uno")).sort(col("uno")).show()
---------
|"UNO"  |
---------
|1      |
|2      |
|3      |
|11     |
|22     |
---------

-- Example 22013
>>> df.select(explode('maps').as_("primo", "secundo")).sort(col("primo")).show()
--------------------------------
|"PRIMO"      |"SECUNDO"       |
--------------------------------
|Ashi Garami  |"Single Leg X"  |
|Sankaku      |"Triangle"      |
--------------------------------

-- Example 22014
>>> df = session.create_dataframe([[1, [1, 2, 3], {"Ashi Garami": "Single Leg X"}],
...                                [2, [11, 22], {"Sankaku": "Triangle"}],
...                                [3, [], {}]],
...                                schema=["idx", "lists", "maps"])
>>> df.select(df.idx, explode_outer(df.lists)).sort(col("idx")).show()
-------------------
|"IDX"  |"VALUE"  |
-------------------
|1      |1        |
|1      |2        |
|1      |3        |
|2      |11       |
|2      |22       |
|3      |NULL     |
-------------------

-- Example 22015
>>> df.select(df.idx, explode_outer(df.maps)).sort(col("idx")).show()
----------------------------------------
|"IDX"  |"KEY"        |"VALUE"         |
----------------------------------------
|1      |Ashi Garami  |"Single Leg X"  |
|2      |Sankaku      |"Triangle"      |
|3      |NULL         |NULL            |
----------------------------------------

-- Example 22016
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df.select(sql_expr("a + 1").as_("c"), sql_expr("a = 1").as_("d")).collect()  # use SQL expression
[Row(C=2, D=True), Row(C=4, D=False)]

-- Example 22017
>>> df = session.create_dataframe([0, 1, 5, 10], schema=["a"])
>>> df.select(factorial(df["a"]).alias("factorial")).collect()
[Row(FACTORIAL=1), Row(FACTORIAL=1), Row(FACTORIAL=120), Row(FACTORIAL=3628800)]

-- Example 22018
>>> from snowflake.snowpark.window import Window
>>> window = Window.partition_by("column1").order_by("column2")
>>> df = session.create_dataframe([[1, 10], [1, 11], [2, 20], [2, 21]], schema=["column1", "column2"])
>>> df.select(df["column1"], df["column2"], first_value(df["column2"]).over(window).as_("column2_first")).collect()
[Row(COLUMN1=1, COLUMN2=10, COLUMN2_FIRST=10), Row(COLUMN1=1, COLUMN2=11, COLUMN2_FIRST=10), Row(COLUMN1=2, COLUMN2=20, COLUMN2_FIRST=20), Row(COLUMN1=2, COLUMN2=21, COLUMN2_FIRST=20)]

-- Example 22019
>>> df = session.create_dataframe([[1, [1, 2, 3], {"Ashi Garami": ["X", "Leg Entanglement"]}, "Kimura"],
...                                [2, [11, 22], {"Sankaku": ["Triangle"]}, "Coffee"],
...                                [3, [], {}, "empty"]],
...                                schema=["idx", "lists", "maps", "strs"])
>>> df.select(df.idx, flatten(df.lists, outer=True)).select("idx", "value").sort("idx").show()
-------------------
|"IDX"  |"VALUE"  |
-------------------
|1      |1        |
|1      |2        |
|1      |3        |
|2      |11       |
|2      |22       |
|3      |NULL     |
-------------------

-- Example 22020
>>> df.select(df.strs, flatten(df.maps, recursive=True)).select("strs", "key", "value").where("key is not NULL").sort("strs").show()
-----------------------------------------------
|"STRS"  |"KEY"        |"VALUE"               |
-----------------------------------------------
|Coffee  |Sankaku      |[                     |
|        |             |  "Triangle"          |
|        |             |]                     |
|Kimura  |Ashi Garami  |[                     |
|        |             |  "X",                |
|        |             |  "Leg Entanglement"  |
|        |             |]                     |
-----------------------------------------------

