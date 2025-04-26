-- Example 32936
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_session()).collect()
>>> assert result[0]['CURRENT_SESSION()'] is not None

-- Example 32937
>>> # Return result is tied to session, so we only test if the result exists
>>> session.create_dataframe([1]).select(current_statement()).collect()
[Row(CURRENT_STATEMENT()='SELECT current_statement() FROM ( SELECT "_1" FROM ( SELECT $1 AS "_1" FROM  VALUES (1 :: INT)))')]

-- Example 32938
>>> import datetime
>>> result = session.create_dataframe([1]).select(current_time()).collect()
>>> assert isinstance(result[0]["CURRENT_TIME()"], datetime.time)

-- Example 32939
>>> import datetime
>>> result = session.create_dataframe([1]).select(current_timestamp()).collect()
>>> assert isinstance(result[0]["CURRENT_TIMESTAMP()"], datetime.datetime)

-- Example 32940
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_user()).collect()
>>> assert result[0]['CURRENT_USER()'] is not None

-- Example 32941
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_version()).collect()
>>> assert result[0]['CURRENT_VERSION()'] is not None

-- Example 32942
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_warehouse()).collect()
>>> assert result[0]['CURRENT_WAREHOUSE()'] is not None

-- Example 32943
>>> df = session.create_dataframe([("2023-10-10",), ("2022-05-15",), ("invalid",)], schema=['date'])
>>> df.select(date_format('date', 'YYYY/MM/DD').as_('formatted_date')).show()
--------------------
|"FORMATTED_DATE"  |
--------------------
|2023/10/10        |
|2022/05/15        |
|NULL              |
--------------------

-- Example 32944
>>> df = session.create_dataframe([("2023-10-10 15:30:00",), ("2022-05-15 10:45:00",)], schema=['timestamp'])
>>> df.select(date_format('timestamp', 'YYYY/MM/DD HH:mi:ss').as_('formatted_ts')).show()
-----------------------
|"FORMATTED_TS"       |
-----------------------
|2023/10/10 15:30:00  |
|2022/05/15 10:45:00  |
-----------------------

-- Example 32945
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

-- Example 32946
>>> df = session.create_dataframe([[2022, 4, 1]], schema=["year", "month", "day"])
>>> df.select(date_from_parts("year", "month", "day")).collect()
[Row(DATE_FROM_PARTS("YEAR", "MONTH", "DAY")=datetime.date(2022, 4, 1))]
>>> session.table("dual").select(date_from_parts(2022, 4, 1)).collect()
[Row(DATE_FROM_PARTS(2022, 4, 1)=datetime.date(2022, 4, 1))]

-- Example 32947
>>> import datetime
>>> df = session.create_dataframe([[datetime.datetime(2023, 1, 1, 1, 1, 1)]], schema=["ts_col"])
>>> df.select(date_part("year", col("ts_col")).alias("year"), date_part("epoch_second", col("ts_col")).alias("epoch_second")).show()
---------------------------
|"YEAR"  |"EPOCH_SECOND"  |
---------------------------
|2023    |1672534861      |
---------------------------

-- Example 32948
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

-- Example 32949
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

-- Example 32950
>>> # year difference between two date columns
>>> import datetime
>>> date_df = session.create_dataframe([[datetime.date(2020, 1, 1), datetime.date(2021, 1, 1)]], schema=["date_col1", "date_col2"])
>>> date_df.select(datediff("year", col("date_col1"), col("date_col2")).alias("year_diff")).show()
---------------
|"YEAR_DIFF"  |
---------------
|1            |
---------------

-- Example 32951
>>> from snowflake.snowpark.functions import date_add, to_date
>>> df = session.createDataFrame([("1976-01-06")], ["date"])
>>> df = df.withColumn("date", to_date("date"))
>>> res = df.withColumn("date", date_add("date", 4)).show()
--------------
|"DATE"      |
--------------
|1976-01-10  |
--------------

-- Example 32952
>>> from snowflake.snowpark.functions import date_sub, to_date
>>> df = session.createDataFrame([("1976-01-06")], ["date"])
>>> df = df.withColumn("date", to_date("date"))
>>> df.withColumn("date", date_sub("date", 2)).show()
--------------
|"DATE"      |
--------------
|1976-01-04  |
--------------

-- Example 32953
>>> from snowflake.snowpark.functions import daydiff, to_date
>>> df = session.createDataFrame([("2015-04-08", "2015-05-10")], ["d1", "d2"])
>>> res = df.select(daydiff(to_date(df.d2), to_date(df.d1)).alias("diff")).show()
----------
|"DIFF"  |
----------
|32      |
----------

-- Example 32954
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayname("a")).collect()
[Row(DAYNAME("A")='Fri')]

-- Example 32955
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayofmonth("a")).collect()
[Row(DAYOFMONTH("A")=1)]

-- Example 32956
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayofweek("a")).collect()
[Row(DAYOFWEEK("A")=5)]

-- Example 32957
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(dayofyear("a")).collect()
[Row(DAYOFYEAR("A")=122)]

-- Example 32958
>>> import math
>>> from snowflake.snowpark.types import StructType, StructField, DoubleType, IntegerType
>>> df = session.create_dataframe(
...     [math.pi / 3, math.pi, 3 * math.pi],
...     schema=StructType([StructField("a", DoubleType())]),
... )
>>> df.select(degrees(col("a")).cast(IntegerType()).alias("DEGREES")).collect()
[Row(DEGREES=60), Row(DEGREES=180), Row(DEGREES=540)]

-- Example 32959
>>> from snowflake.snowpark.window import Window
>>> window = Window.order_by("key")
>>> df = session.create_dataframe([(1, "1"), (2, "2"), (1, "3"), (2, "4")], schema=["key", "value"])
>>> df.select(dense_rank().over(window).as_("dense_rank")).collect()
[Row(DENSE_RANK=1), Row(DENSE_RANK=1), Row(DENSE_RANK=2), Row(DENSE_RANK=2)]

-- Example 32960
>>> df = session.create_dataframe([1, 2, 3, None, None], schema=["a"])
>>> df.sort(desc(df["a"])).collect()
[Row(A=3), Row(A=2), Row(A=1), Row(A=None), Row(A=None)]

-- Example 32961
>>> df = session.create_dataframe([1, 2, 3, None, None], schema=["a"])
>>> df.sort(desc_nulls_first(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=3), Row(A=2), Row(A=1)]

-- Example 32962
>>> df = session.create_dataframe([1, 2, 3, None, None], schema=["a"])
>>> df.sort(desc_nulls_last(df["a"])).collect()
[Row(A=3), Row(A=2), Row(A=1), Row(A=None), Row(A=None)]

-- Example 32963
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(div0(df["a"], 1).alias("divided_by_one"), div0(df["a"], 0).alias("divided_by_zero")).collect()
[Row(DIVIDED_BY_ONE=Decimal('1.000000'), DIVIDED_BY_ZERO=Decimal('0.000000'))]

-- Example 32964
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(divnull(df["a"], 1).alias("divided_by_one"), divnull(df["a"], 0).alias("divided_by_zero")).collect()
[Row(DIVIDED_BY_ONE=Decimal('1.000000'), DIVIDED_BY_ZERO=None)]

-- Example 32965
>>> df = session.create_dataframe(
...     [["abc", "def"], ["abcdef", "abc"], ["snow", "flake"]],
...     schema=["s1", "s2"]
... )
>>> df.select(
...     editdistance(col("s1"), col("s2")).alias("distance"),
...     editdistance(col("s1"), col("s2"), 2).alias("max_2_distance")
... ).collect()
[Row(DISTANCE=3, MAX_2_DISTANCE=2), Row(DISTANCE=3, MAX_2_DISTANCE=2), Row(DISTANCE=5, MAX_2_DISTANCE=2)]

-- Example 32966
>>> df = session.create_dataframe(["apple", "banana", "peach"], schema=["a"])
>>> df.select(endswith(df["a"], lit("ana")).alias("endswith")).collect()
[Row(ENDSWITH=False), Row(ENDSWITH=True), Row(ENDSWITH=False)]

-- Example 32967
>>> import math
>>> df = session.create_dataframe([1.1, math.nan, 2.3], schema=["a"])
>>> df.select(equal_nan(df["a"]).alias("equal_nan")).collect()
[Row(EQUAL_NAN=False), Row(EQUAL_NAN=True), Row(EQUAL_NAN=False)]

-- Example 32968
>>> df = session.create_dataframe([[1, 1], [1, None], [None, 2], [None, None]], schema=["a", "b"])
>>> df.select(equal_null(df["a"], df["b"]).alias("equal_null")).collect()
[Row(EQUAL_NULL=True), Row(EQUAL_NULL=False), Row(EQUAL_NULL=False), Row(EQUAL_NULL=True)]

-- Example 32969
>>> import math
>>> from snowflake.snowpark.types import IntegerType
>>> df = session.create_dataframe([0.0, math.log(10)], schema=["a"])
>>> df.select(exp(df["a"]).cast(IntegerType()).alias("exp")).collect()
[Row(EXP=1), Row(EXP=10)]

-- Example 32970
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

-- Example 32971
>>> df.select(df.strs, explode(df.maps)).sort(col("strs")).show()
-----------------------------------------
|"STRS"  |"KEY"        |"VALUE"         |
-----------------------------------------
|Coffee  |Sankaku      |"Triangle"      |
|Kimura  |Ashi Garami  |"Single Leg X"  |
-----------------------------------------

-- Example 32972
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

-- Example 32973
>>> df.select(explode('maps').as_("primo", "secundo")).sort(col("primo")).show()
--------------------------------
|"PRIMO"      |"SECUNDO"       |
--------------------------------
|Ashi Garami  |"Single Leg X"  |
|Sankaku      |"Triangle"      |
--------------------------------

-- Example 32974
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

-- Example 32975
>>> df.select(df.idx, explode_outer(df.maps)).sort(col("idx")).show()
----------------------------------------
|"IDX"  |"KEY"        |"VALUE"         |
----------------------------------------
|1      |Ashi Garami  |"Single Leg X"  |
|2      |Sankaku      |"Triangle"      |
|3      |NULL         |NULL            |
----------------------------------------

-- Example 32976
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df.select(sql_expr("a + 1").as_("c"), sql_expr("a = 1").as_("d")).collect()  # use SQL expression
[Row(C=2, D=True), Row(C=4, D=False)]

-- Example 32977
>>> df = session.create_dataframe([0, 1, 5, 10], schema=["a"])
>>> df.select(factorial(df["a"]).alias("factorial")).collect()
[Row(FACTORIAL=1), Row(FACTORIAL=1), Row(FACTORIAL=120), Row(FACTORIAL=3628800)]

-- Example 32978
>>> from snowflake.snowpark.window import Window
>>> window = Window.partition_by("column1").order_by("column2")
>>> df = session.create_dataframe([[1, 10], [1, 11], [2, 20], [2, 21]], schema=["column1", "column2"])
>>> df.select(df["column1"], df["column2"], first_value(df["column2"]).over(window).as_("column2_first")).collect()
[Row(COLUMN1=1, COLUMN2=10, COLUMN2_FIRST=10), Row(COLUMN1=1, COLUMN2=11, COLUMN2_FIRST=10), Row(COLUMN1=2, COLUMN2=20, COLUMN2_FIRST=20), Row(COLUMN1=2, COLUMN2=21, COLUMN2_FIRST=20)]

-- Example 32979
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

-- Example 32980
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

-- Example 32981
>>> df.select(df.strs, flatten(df.maps, recursive=True)).select("strs", "key", "value").where("key is NULL").sort("strs", "value").show()
---------------------------------------
|"STRS"  |"KEY"  |"VALUE"             |
---------------------------------------
|Coffee  |NULL   |"Triangle"          |
|Kimura  |NULL   |"Leg Entanglement"  |
|Kimura  |NULL   |"X"                 |
---------------------------------------

-- Example 32982
>>> df = session.create_dataframe([135.135, -975.975], schema=["a"])
>>> df.select(floor(df["a"]).alias("floor")).collect()
[Row(FLOOR=135.0), Row(FLOOR=-976.0)]

-- Example 32983
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_content_type(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
'text/csv'


This function or method is in private preview since 1.29.0.

-- Example 32984
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_etag(to_file("@mystage/testCSV.csv")).alias("file"))
>>> len(df.collect()[0][0])  


This function or method is in private preview since 1.29.0.

-- Example 32985
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_file_type(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
'document'


This function or method is in private preview since 1.29.0.

-- Example 32986
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_last_modified(to_file("@mystage/testCSV.csv")).alias("file"))
>>> type(df.collect()[0][0])
<class 'datetime.datetime'>


This function or method is in private preview since 1.29.0.

-- Example 32987
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_relative_path(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
'testCSV.csv'


This function or method is in private preview since 1.29.0.

-- Example 32988
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_scoped_file_url(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]


This function or method is in private preview since 1.29.0.

-- Example 32989
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_size(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
32


This function or method is in private preview since 1.29.0.

-- Example 32990
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_stage(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0].split(".")[-1]
'MYSTAGE'


This function or method is in private preview since 1.29.0.

-- Example 32991
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_stage_file_url(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]  
'https://'


This function or method is in private preview since 1.29.0.

-- Example 32992
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_audio(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 32993
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_compressed(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 32994
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_document(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
True


This function or method is in private preview since 1.29.0.

-- Example 32995
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_image(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 32996
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_video(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 32997
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 1, 2, 3, 4000))]
>>> df = session.create_dataframe(["2020-05-01 13:11:20.000"], schema=['a'])
>>> df.select(to_timestamp(col("a"), lit("YYYY-MM-DD HH24:MI:SS.FF3")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2020, 5, 1, 13, 11, 20))]

-- Example 32998
>>> import datetime
>>> df = session.createDataFrame([datetime.datetime(2022, 12, 25, 13, 59, 38, 467)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2022, 12, 25, 13, 59, 38, 467))]
>>> df = session.createDataFrame([datetime.date(2023, 3, 1)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2023, 3, 1, 0, 0))]

-- Example 32999
>>> df = session.createDataFrame([20, 31536000000], schema=['a'])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(TO_TIMESTAMP("A")=datetime.datetime(2969, 5, 3, 0, 0))]
>>> df.select(to_timestamp(col("a"), lit(9))).collect()
[Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0)), Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0, 31, 536000))]

-- Example 33000
>>> df = session.createDataFrame(['20', '31536000000', '31536000000000', '31536000000000000'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0))]

-- Example 33001
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['t'])
>>> df.select(from_utc_timestamp(col("t"), "America/Los_Angeles").alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 30, 17, 2, 3, 4000))]

-- Example 33002
>>> df = session.create_dataframe([('2019-01-31 01:02:03.004', "America/Los_Angeles")], schema=['t', 'tz'])
>>> df.select(from_utc_timestamp(col("t"), col("tz")).alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 30, 17, 2, 3, 4000))]

