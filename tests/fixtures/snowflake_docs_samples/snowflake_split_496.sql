-- Example 33204
>>> df = session.create_dataframe(['hello', ' world', '   !   '], schema=["a"])
>>> df.collect()
[Row(A='hello'), Row(A=' world'), Row(A='   !   ')]
>>> df.select(trim(col("a"))).collect()
[Row(TRIM("A")='hello'), Row(TRIM("A")='world'), Row(TRIM("A")='!')]

-- Example 33205
>>> df = session.create_dataframe(['EUR 12.96', '7.89USD', '5.99E'], schema=["a"])
>>> df.select(trim(col("a"), lit("EURUSD ")).as_("ans")).collect()
[Row(ANS='12.96'), Row(ANS='7.89'), Row(ANS='5.99')]

-- Example 33206
>>> df = session.create_dataframe(['abc12 45a 79bc!'], schema=["a"])
>>> df.select(trim(col("a"), lit("abc!")).as_("ans")).collect()
[Row(ANS='12 45a 79')]

-- Example 33207
>>> df = session.createDataFrame([-1.0, -0.9, -.5, -.2, 0.0, 0.2, 0.5, 0.9, 1.1, 3.14159], schema=["a"])
>>> df.select(trunc(col("a"))).collect()
[Row(TRUNC("A", 0)=-1.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=0.0), Row(TRUNC("A", 0)=1.0), Row(TRUNC("A", 0)=3.0)]

>>> df = session.createDataFrame([-1.323, 4.567, 0.0123], schema=["a"])
>>> df.select(trunc(col("a"), lit(0))).collect()
[Row(TRUNC("A", 0)=-1.0), Row(TRUNC("A", 0)=4.0), Row(TRUNC("A", 0)=0.0)]
>>> df.select(trunc(col("a"), lit(1))).collect()
[Row(TRUNC("A", 1)=-1.3), Row(TRUNC("A", 1)=4.5), Row(TRUNC("A", 1)=0.0)]
>>> df.select(trunc(col("a"), lit(2))).collect()
[Row(TRUNC("A", 2)=-1.32), Row(TRUNC("A", 2)=4.56), Row(TRUNC("A", 2)=0.01)]

-- Example 33208
>>> import datetime
>>> df = session.createDataFrame([datetime.date(2022, 12, 25), datetime.date(2022, 1, 10), datetime.date(2022, 7, 7)], schema=["a"])
>>> df.select(trunc(col("a"), lit("QUARTER"))).collect()
[Row(TRUNC("A", 'QUARTER')=datetime.date(2022, 10, 1)), Row(TRUNC("A", 'QUARTER')=datetime.date(2022, 1, 1)), Row(TRUNC("A", 'QUARTER')=datetime.date(2022, 7, 1))]

>>> df = session.createDataFrame([datetime.datetime(2022, 12, 25, 13, 59, 38, 467)], schema=["a"])
>>> df.collect()
[Row(A=datetime.datetime(2022, 12, 25, 13, 59, 38, 467))]
>>> df.select(trunc(col("a"), lit("MINUTE"))).collect()
[Row(TRUNC("A", 'MINUTE')=datetime.datetime(2022, 12, 25, 13, 59))]

-- Example 33209
>>> from snowflake.snowpark.types import IntegerType, FloatType
>>> df = session.create_dataframe(['0', '-12', '22', '1001'], schema=["a"])
>>> df.select(try_cast(col("a"), IntegerType()).as_('ans')).collect()
[Row(ANS=0), Row(ANS=-12), Row(ANS=22), Row(ANS=1001)]

-- Example 33210
>>> df = session.create_dataframe(['0.12', 'USD 27.90', '13.97 USD', '€97.0', '17,-'], schema=["a"])
>>> df.select(try_cast(col("a"), FloatType()).as_('ans')).collect()
[Row(ANS=0.12), Row(ANS=None), Row(ANS=None), Row(ANS=None), Row(ANS=None)]

-- Example 33211
>>> df = session.create_dataframe(["01", "A B", "Hello", None], schema=["hex_encoded_string"])
>>> df.select(try_to_binary(df["hex_encoded_string"], 'HEX').alias("b")).collect()
[Row(B=bytearray(b'\x01')), Row(B=None), Row(B=None), Row(B=None)]

-- Example 33212
>>> df = session.create_dataframe([1, 2, 3], schema=["A"])
>>> df.select(typeof(col("A")).as_("ans")).collect()
[Row(ANS='INTEGER'), Row(ANS='INTEGER'), Row(ANS='INTEGER')]

-- Example 33213
>>> from snowflake.snowpark.types import VariantType, StructType, StructField
>>> schema = StructType([StructField("A", VariantType())])
>>> df = session.create_dataframe([1, 3.1, 'test'], schema=schema)
>>> df.select(typeof(col("A")).as_("ans")).collect()
[Row(ANS='INTEGER'), Row(ANS='DECIMAL'), Row(ANS='VARCHAR')]

-- Example 33214
>>> from snowflake.snowpark.types import IntegerType
>>> class PythonSumUDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self):
...         return self._sum
...
...     def accumulate(self, input_value):
...         self._sum += input_value
...
...     def merge(self, other_sum):
...         self._sum += other_sum
...
...     def finish(self):
...         return self._sum
>>> sum_udaf = udaf(
...     PythonSumUDAF,
...     name="sum_int",
...     replace=True,
...     return_type=IntegerType(),
...     input_types=[IntegerType()],
... )
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(sum_udaf("a")).collect()
[Row(SUM_INT("A")=6)]

-- Example 33215
>>> @udaf(name="sum_int", replace=True, return_type=IntegerType(), input_types=[IntegerType()])
... class PythonSumUDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self):
...         return self._sum
...
...     def accumulate(self, input_value):
...         self._sum += input_value
...
...     def merge(self, other_sum):
...         self._sum += other_sum
...
...     def finish(self):
...         return self._sum

>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(PythonSumUDAF("a")).collect()
[Row(SUM_INT("A")=6)]

-- Example 33216
>>> from snowflake.snowpark.types import IntegerType
>>> add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()])
>>> df = session.create_dataframe([1, 2, 3], schema=["a"])
>>> df.select(add_one(col("a")).as_("ans")).collect()
[Row(ANS=2), Row(ANS=3), Row(ANS=4)]

-- Example 33217
>>> @udf(name="minus_one", replace=True)
... def minus_one(x: int) -> int:
...     return x - 1
>>> df.select(minus_one(col("a")).as_("ans")).collect()
[Row(ANS=0), Row(ANS=1), Row(ANS=2)]
>>> session.sql("SELECT minus_one(10)").collect()
[Row(MINUS_ONE(10)=9)]

-- Example 33218
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> class PrimeSieve:
...     def process(self, n):
...         is_prime = [True] * (n + 1)
...         is_prime[0] = False
...         is_prime[1] = False
...         p = 2
...         while p * p <= n:
...             if is_prime[p]:
...                 # set all multiples of p to False
...                 for i in range(p * p, n + 1, p):
...                     is_prime[i] = False
...             p += 1
...         # yield all prime numbers
...         for p in range(2, n + 1):
...             if is_prime[p]:
...                 yield (p,)
>>> prime_udtf = udtf(PrimeSieve, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
>>> session.table_function(prime_udtf(lit(20))).collect()
[Row(NUMBER=2), Row(NUMBER=3), Row(NUMBER=5), Row(NUMBER=7), Row(NUMBER=11), Row(NUMBER=13), Row(NUMBER=17), Row(NUMBER=19)]

Instead of calling `udtf` it is also possible to use udtf as a decorator.

-- Example 33219
>>> @udtf(name="alt_int",replace=True, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
... class Alternator:
...     def __init__(self):
...         self._positive = True
...
...     def process(self, n):
...         for i in range(n):
...             if self._positive:
...                 yield (1,)
...             else:
...                 yield (-1,)
...             self._positive = not self._positive
>>> session.table_function("alt_int", lit(3)).collect()
[Row(NUMBER=1), Row(NUMBER=-1), Row(NUMBER=1)]
>>> session.table_function("alt_int", lit(2)).collect()
[Row(NUMBER=1), Row(NUMBER=-1)]
>>> session.table_function("alt_int", lit(1)).collect()
[Row(NUMBER=1)]

-- Example 33220
>>> df = session.create_dataframe(["U25vd2ZsYWtl", "SEVMTE8="], schema=["input"])
>>> df.select(base64_decode_string(col("input")).alias("decoded")).collect()
[Row(DECODED='Snowflake'), Row(DECODED='HELLO')]

-- Example 33221
>>> import datetime
>>> df = session.create_dataframe(
...     [[1]],
...     schema=["a"],
... )
>>> df.select(uniform(1, 100, col("a")).alias("UNIFORM")).collect()
[Row(UNIFORM=62)]

-- Example 33222
>>> import datetime
>>> df = session.create_dataframe([["2013-05-08T23:39:20.123-07:00"]], schema=["ts_col"])
>>> df.select(unix_timestamp(col("ts_col")).alias("unix_time")).show()
---------------
|"UNIX_TIME"  |
---------------
|1368056360   |
---------------

-- Example 33223
>>> df = session.create_dataframe(['abc', 'Abc', 'aBC', 'Anführungszeichen', '14.95 €'], schema=["a"])
>>> df.select(upper(col("a"))).collect()
[Row(UPPER("A")='ABC'), Row(UPPER("A")='ABC'), Row(UPPER("A")='ABC'), Row(UPPER("A")='ANFÜHRUNGSZEICHEN'), Row(UPPER("A")='14.95 €')]

-- Example 33224
>>> df = session.create_dataframe([1, -1, 1, -1, -1], schema=["a"])
>>> df.select(var_pop(col("a"))).collect()
[Row(VAR_POP("A")=Decimal('0.960000'))]

>>> df = session.create_dataframe([1, None, 2, 3, None, 5, 6], schema=["a"])
>>> df.select(var_pop(col("a"))).collect()
[Row(VAR_POP("A")=Decimal('3.440000'))]

>>> df = session.create_dataframe([None, None, None], schema=["a"])
>>> df.select(var_pop(col("a"))).collect()
[Row(VAR_POP("A")=None)]

>>> df = session.create_dataframe([42], schema=["a"])
>>> df.select(var_pop(col("a"))).collect()
[Row(VAR_POP("A")=Decimal('0.000000'))]

-- Example 33225
>>> df = session.create_dataframe([1, -1, 1, -1, -1], schema=["a"])
>>> df.select(var_samp(col("a"))).collect()
[Row(VARIANCE("A")=Decimal('1.200000'))]

>>> df = session.create_dataframe([1, None, 2, 3, None, 5, 6], schema=["a"])
>>> df.select(var_samp(col("a"))).collect()
[Row(VARIANCE("A")=Decimal('4.300000'))]

>>> df = session.create_dataframe([None, None, None], schema=["a"])
>>> df.select(var_samp(col("a"))).collect()
[Row(VARIANCE("A")=None)]

>>> df = session.create_dataframe([42], schema=["a"])
>>> df.select(var_samp(col("a"))).collect()
[Row(VARIANCE("A")=None)]

-- Example 33226
>>> df = session.create_dataframe([1, -1, 1, -1, -1], schema=["a"])
>>> df.select(variance(col("a"))).collect()
[Row(VARIANCE("A")=Decimal('1.200000'))]

>>> df = session.create_dataframe([1, None, 2, 3, None, 5, 6], schema=["a"])
>>> df.select(variance(col("a"))).collect()
[Row(VARIANCE("A")=Decimal('4.300000'))]

>>> df = session.create_dataframe([None, None, None], schema=["a"])
>>> df.select(variance(col("a"))).collect()
[Row(VARIANCE("A")=None)]

>>> df = session.create_dataframe([42], schema=["a"])
>>> df.select(variance(col("a"))).collect()
[Row(VARIANCE("A")=None)]

-- Example 33227
>>> from snowflake.snowpark.functions import vector_inner_product
>>> df = session.sql("select [1,2,3]::vector(int,3) as a, [2,3,4]::vector(int,3) as b")
>>> df.select(vector_inner_product(df.a, df.b).as_("dist")).show()
----------
|"DIST"  |
----------
|20.0    |
----------

-- Example 33228
>>> from snowflake.snowpark.functions import vector_l2_distance
>>> df = session.sql("select [1,2,3]::vector(int,3) as a, [2,3,4]::vector(int,3) as b")
>>> df.select(vector_l2_distance(df.a, df.b).as_("dist")).show()
----------------------
|"DIST"              |
----------------------
|1.7320508075688772  |
----------------------

-- Example 33229
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(weekofyear("a")).collect()
[Row(WEEKOFYEAR("A")=18)]

-- Example 33230
>>> df = session.create_dataframe([1, None, 2, 3, None, 5, 6], schema=["a"])
>>> df.collect()
[Row(A=1), Row(A=None), Row(A=2), Row(A=3), Row(A=None), Row(A=5), Row(A=6)]
>>> df.select(when(col("a") % 2 == 0, lit("even")).as_("ans")).collect()
[Row(ANS=None), Row(ANS=None), Row(ANS='even'), Row(ANS=None), Row(ANS=None), Row(ANS=None), Row(ANS='even')]

-- Example 33231
>>> df.select(when(col("a") % 2 == 0, lit("even")).when(col("a") % 2 == 1, lit("odd")).as_("ans")).collect()
[Row(ANS='odd'), Row(ANS=None), Row(ANS='even'), Row(ANS='odd'), Row(ANS=None), Row(ANS='odd'), Row(ANS='even')]
>>> df.select(when(col("a") % 2 == 0, lit("even")).when(col("a") % 2 == 1, lit("odd")).otherwise(lit("unknown")).as_("ans")).collect()
[Row(ANS='odd'), Row(ANS='unknown'), Row(ANS='even'), Row(ANS='odd'), Row(ANS='unknown'), Row(ANS='odd'), Row(ANS='even')]

-- Example 33232
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=["key", "value"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=["key", "value"])
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == "too_old"),
...              [when_matched().update({"value": source["value"]})])
MergeResult(rows_inserted=0, rows_updated=1, rows_deleted=0)
>>> target.collect()
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='new'), Row(KEY=11, VALUE='old')]

-- Example 33233
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == "too_old"),
...              [when_not_matched().insert({"key": source["key"]})])
MergeResult(rows_inserted=2, rows_updated=0, rows_deleted=0)
>>> target.sort(col("key"), col("value")).collect()
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='too_old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE=None), Row(KEY=13, VALUE=None)]

-- Example 33234
>>> import datetime
>>> from snowflake.snowpark.functions import window
>>> df = session.createDataFrame(
...      [(datetime.datetime.strptime("2024-10-31 09:05:00.000", "%Y-%m-%d %H:%M:%S.%f"),)],
...      schema=["time"]
... )
>>> df.select(window(df.time, "5 minutes")).show()
----------------------------------------
|"WINDOW"                              |
----------------------------------------
|{                                     |
|  "end": "2024-10-31 09:10:00.000",   |
|  "start": "2024-10-31 09:05:00.000"  |
|}                                     |
----------------------------------------


>>> df.select(window(df.time, "5 minutes", start_time="2 minutes")).show()
----------------------------------------
|"WINDOW"                              |
----------------------------------------
|{                                     |
|  "end": "2024-10-31 09:07:00.000",   |
|  "start": "2024-10-31 09:02:00.000"  |
|}                                     |
----------------------------------------

-- Example 33235
>>> import datetime
>>> from snowflake.snowpark.functions import sum, window
>>> df = session.createDataFrame([
...         (datetime.datetime(2024, 10, 31, 1, 0, 0), 1),
...         (datetime.datetime(2024, 10, 31, 2, 0, 0), 1),
...         (datetime.datetime(2024, 10, 31, 3, 0, 0), 1),
...         (datetime.datetime(2024, 10, 31, 4, 0, 0), 1),
...         (datetime.datetime(2024, 10, 31, 5, 0, 0), 1),
...     ], schema=["time", "value"]
... )
>>> df.group_by(window(df.time, "2 hours")).agg(sum(df.value)).sort("window").show()
-------------------------------------------------------
|"WINDOW"                              |"SUM(VALUE)"  |
-------------------------------------------------------
|{                                     |1             |
|  "end": "2024-10-31 02:00:00.000",   |              |
|  "start": "2024-10-31 00:00:00.000"  |              |
|}                                     |              |
|{                                     |2             |
|  "end": "2024-10-31 04:00:00.000",   |              |
|  "start": "2024-10-31 02:00:00.000"  |              |
|}                                     |              |
|{                                     |2             |
|  "end": "2024-10-31 06:00:00.000",   |              |
|  "start": "2024-10-31 04:00:00.000"  |              |
|}                                     |              |
-------------------------------------------------------

-- Example 33236
>>> df = session.create_dataframe(['<level1 attr1="a">1<level2 attr2="b">2<level3>3a</level3><level3>3b</level3></level2></level1>'], schema=["str"]).select(parse_xml("str").as_("obj"))
>>> df.collect()
[Row(OBJ='<level1 attr1="a">\n  1\n  <level2 attr2="b">\n    2\n    <level3>3a</level3>\n    <level3>3b</level3>\n  </level2>\n</level1>')]
>>> df.select(xmlget("obj", lit("level2")).as_("ans")).collect()
[Row(ANS='<level2 attr2="b">\n  2\n  <level3>3a</level3>\n  <level3>3b</level3>\n</level2>')]

-- Example 33237
>>> df.select(xmlget(xmlget("obj", lit("level2")), lit("level3"), lit(0)).as_("ans")).collect()
[Row(ANS='<level3>3a</level3>')]
>>> df.select(xmlget(xmlget("obj", lit("level2")), lit("level3"), lit(1)).as_("ans")).collect()
[Row(ANS='<level3>3b</level3>')]
>>> df.select(xmlget("obj", lit("level2"), lit(5)).as_("ans")).collect()
[Row(ANS=None)]

-- Example 33238
>>> df.select(get(xmlget("obj", lit("level2")), lit("@")).as_("ans")).collect()
[Row(ANS='"level2"')]
>>> df.select(get(xmlget("obj", lit("level2")), lit("$")).as_("ans")).collect()
[Row(ANS='[\n  2,\n  {\n    "$": "3a",\n    "@": "level3"\n  },\n  {\n    "$": "3b",\n    "@": "level3"\n  }\n]')]
>>> df.select(get(xmlget(xmlget("obj", lit("level2")), lit("level3")), lit("$")).as_("ans")).collect()
[Row(ANS='"3a"')]
>>> df.select(get(xmlget("obj", lit("level2")), lit("@attr2")).as_("ans")).collect()
[Row(ANS='"b"')]

-- Example 33239
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(year("a")).collect()
[Row(YEAR("A")=2020), Row(YEAR("A")=2020)]

-- Example 33240
>>> from snowflake.snowpark.functions import col, avg
>>> window1 = Window.partition_by("value").order_by("key").rows_between(Window.CURRENT_ROW, 2)
>>> window2 = Window.order_by(col("key").desc()).range_between(Window.UNBOUNDED_PRECEDING, Window.UNBOUNDED_FOLLOWING)
>>> df = session.create_dataframe([(1, "1"), (2, "2"), (1, "3"), (2, "4")], schema=["key", "value"])
>>> df.select(avg("value").over(window1).as_("window1"), avg("value").over(window2).as_("window2")).sort("window1").collect()
[Row(WINDOW1=1.0, WINDOW2=2.5), Row(WINDOW1=2.0, WINDOW2=2.5), Row(WINDOW1=3.0, WINDOW2=2.5), Row(WINDOW1=4.0, WINDOW2=2.5)]

-- Example 33241
>>> from snowflake.snowpark.functions import col, count, make_interval
>>>
>>> df = session.range(5)
>>> window = Window.order_by("id").range_between(-1, Window.CURRENT_ROW)
>>> df.select(col("id"), count("id").over(window).as_("count")).show()
------------------
|"ID"  |"COUNT"  |
------------------
|0     |1        |
|1     |2        |
|2     |2        |
|3     |2        |
|4     |2        |
------------------

-- Example 33242
>>> import datetime
>>> from snowflake.snowpark.types import StructType, StructField, TimestampType, TimestampTimeZone
>>>
>>> df = session.create_dataframe(
...    [
...        datetime.datetime(2021, 12, 21, 9, 12, 56),
...        datetime.datetime(2021, 12, 21, 8, 12, 56),
...        datetime.datetime(2021, 12, 21, 7, 12, 56),
...        datetime.datetime(2021, 12, 21, 6, 12, 56),
...    ],
...    schema=StructType([StructField("a", TimestampType(TimestampTimeZone.NTZ))]),
... )
>>> window = Window.order_by(col("a").desc()).range_between(-make_interval(hours=1), make_interval(hours=1))
>>> df.select(col("a"), count("a").over(window).as_("count")).show()
---------------------------------
|"A"                  |"COUNT"  |
---------------------------------
|2021-12-21 09:12:56  |2        |
|2021-12-21 08:12:56  |3        |
|2021-12-21 07:12:56  |3        |
|2021-12-21 06:12:56  |2        |
---------------------------------

-- Example 33243
>>> from snowflake.snowpark.functions import col, count, make_interval
>>>
>>> df = session.range(5)
>>> window = Window.order_by("id").range_between(-1, Window.CURRENT_ROW)
>>> df.select(col("id"), count("id").over(window).as_("count")).show()
------------------
|"ID"  |"COUNT"  |
------------------
|0     |1        |
|1     |2        |
|2     |2        |
|3     |2        |
|4     |2        |
------------------

-- Example 33244
>>> import datetime
>>> from snowflake.snowpark.types import StructType, StructField, TimestampType, TimestampTimeZone
>>>
>>> df = session.create_dataframe(
...    [
...        datetime.datetime(2021, 12, 21, 9, 12, 56),
...        datetime.datetime(2021, 12, 21, 8, 12, 56),
...        datetime.datetime(2021, 12, 21, 7, 12, 56),
...        datetime.datetime(2021, 12, 21, 6, 12, 56),
...    ],
...    schema=StructType([StructField("a", TimestampType(TimestampTimeZone.NTZ))]),
... )
>>> window = Window.order_by(col("a").desc()).range_between(-make_interval(hours=1), make_interval(hours=1))
>>> df.select(col("a"), count("a").over(window).as_("count")).show()
---------------------------------
|"A"                  |"COUNT"  |
---------------------------------
|2021-12-21 09:12:56  |2        |
|2021-12-21 08:12:56  |3        |
|2021-12-21 07:12:56  |3        |
|2021-12-21 06:12:56  |2        |
---------------------------------

-- Example 33245
>>> import pandas as pd
>>> from snowflake.snowpark.types import StructType, StructField, StringType, FloatType
>>> def convert(pandas_df):
...     return pandas_df.assign(TEMP_F = lambda x: x.TEMP_C * 9 / 5 + 32)
>>> df = session.createDataFrame([('SF', 21.0), ('SF', 17.5), ('SF', 24.0), ('NY', 30.9), ('NY', 33.6)],
...         schema=['location', 'temp_c'])
>>> df.group_by("location").apply_in_pandas(convert,
...     output_schema=StructType([StructField("location", StringType()),
...                               StructField("temp_c", FloatType()),
...                               StructField("temp_f", FloatType())])).order_by("temp_c").show()
---------------------------------------------
|"LOCATION"  |"TEMP_C"  |"TEMP_F"           |
---------------------------------------------
|SF          |17.5      |63.5               |
|SF          |21.0      |69.8               |
|SF          |24.0      |75.2               |
|NY          |30.9      |87.61999999999999  |
|NY          |33.6      |92.48              |
---------------------------------------------

-- Example 33246
>>> from snowflake.snowpark.types import IntegerType, DoubleType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> def group_sum(pdf):
...     return pd.DataFrame([(pdf.GRADE.iloc[0], pdf.DIVISION.iloc[0], pdf.VALUE.sum(), )])
...
>>> df = session.createDataFrame([('A', 2, 11.0), ('A', 2, 13.9), ('B', 5, 5.0), ('B', 2, 12.1)],
...                              schema=["grade", "division", "value"])
>>> df.group_by([df.grade, df.division] ).applyInPandas(
...     group_sum,
...     output_schema=StructType([StructField("grade", StringType()),
...                                        StructField("division", IntegerType()),
...                                        StructField("sum", DoubleType())]),
...                is_permanent=True, stage_location="@mystage", name="group_sum_in_pandas", replace=True
...            ).order_by("sum").show()
--------------------------------
|"GRADE"  |"DIVISION"  |"SUM"  |
--------------------------------
|B        |5           |5.0    |
|B        |2           |12.1   |
|A        |2           |24.9   |
--------------------------------

-- Example 33247
>>> import pandas as pd
>>> from snowflake.snowpark.types import StructType, StructField, StringType, FloatType
>>> def convert(pandas_df):
...     return pandas_df.assign(TEMP_F = lambda x: x.TEMP_C * 9 / 5 + 32)
>>> df = session.createDataFrame([('SF', 21.0), ('SF', 17.5), ('SF', 24.0), ('NY', 30.9), ('NY', 33.6)],
...         schema=['location', 'temp_c'])
>>> df.group_by("location").apply_in_pandas(convert,
...     output_schema=StructType([StructField("location", StringType()),
...                               StructField("temp_c", FloatType()),
...                               StructField("temp_f", FloatType())])).order_by("temp_c").show()
---------------------------------------------
|"LOCATION"  |"TEMP_C"  |"TEMP_F"           |
---------------------------------------------
|SF          |17.5      |63.5               |
|SF          |21.0      |69.8               |
|SF          |24.0      |75.2               |
|NY          |30.9      |87.61999999999999  |
|NY          |33.6      |92.48              |
---------------------------------------------

-- Example 33248
>>> from snowflake.snowpark.types import IntegerType, DoubleType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> def group_sum(pdf):
...     return pd.DataFrame([(pdf.GRADE.iloc[0], pdf.DIVISION.iloc[0], pdf.VALUE.sum(), )])
...
>>> df = session.createDataFrame([('A', 2, 11.0), ('A', 2, 13.9), ('B', 5, 5.0), ('B', 2, 12.1)],
...                              schema=["grade", "division", "value"])
>>> df.group_by([df.grade, df.division] ).applyInPandas(
...     group_sum,
...     output_schema=StructType([StructField("grade", StringType()),
...                                        StructField("division", IntegerType()),
...                                        StructField("sum", DoubleType())]),
...                is_permanent=True, stage_location="@mystage", name="group_sum_in_pandas", replace=True
...            ).order_by("sum").show()
--------------------------------
|"GRADE"  |"DIVISION"  |"SUM"  |
--------------------------------
|B        |5           |5.0    |
|B        |2           |12.1   |
|A        |2           |24.9   |
--------------------------------

-- Example 33249
>>> target_df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t = session.table("my_table")

>>> # delete all rows in a table
>>> t.delete()
DeleteResult(rows_deleted=6)
>>> t.collect()
[]

>>> # delete all rows where column "a" has value 1
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t.delete(t["a"] == 1)
DeleteResult(rows_deleted=2)
>>> t.sort("a", "b").collect()
[Row(A=2, B=1), Row(A=2, B=2), Row(A=3, B=1), Row(A=3, B=2)]

>>> # delete all rows in this table where column "a" in this
>>> # table is equal to column "a" in another dataframe
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> source_df = session.create_dataframe([2, 3, 4, 5], schema=["a"])
>>> t.delete(t["a"] == source_df.a, source_df)
DeleteResult(rows_deleted=4)
>>> t.sort("a", "b").collect()
[Row(A=1, B=1), Row(A=1, B=2)]

-- Example 33250
>>> from snowflake.snowpark.functions import when_matched, when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == "too_old"),
...              [when_matched().update({"value": source["value"]}), when_not_matched().insert({"key": source["key"]})])
MergeResult(rows_inserted=2, rows_updated=1, rows_deleted=0)
>>> target.sort("key", "value").collect()
[Row(KEY=10, VALUE='new'), Row(KEY=10, VALUE='old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE=None), Row(KEY=13, VALUE=None)]

-- Example 33251
>>> target_df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t = session.table("my_table")

>>> # update all rows in column "b" to 0 and all rows in column "a"
>>> # to the summation of column "a" and column "b"
>>> t.update({"b": 0, "a": t.a + t.b})
UpdateResult(rows_updated=6, multi_joined_rows_updated=0)
>>> t.sort("a", "b").collect()
[Row(A=2, B=0), Row(A=3, B=0), Row(A=3, B=0), Row(A=4, B=0), Row(A=4, B=0), Row(A=5, B=0)]

>>> # update all rows in column "b" to 0 where column "a" has value 1
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t.update({"b": 0}, t["a"] == 1)
UpdateResult(rows_updated=2, multi_joined_rows_updated=0)
>>> t.sort("a", "b").collect()
[Row(A=1, B=0), Row(A=1, B=0), Row(A=2, B=1), Row(A=2, B=2), Row(A=3, B=1), Row(A=3, B=2)]

>>> # update all rows in column "b" to 0 where column "a" in this
>>> # table is equal to column "a" in another dataframe
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> source_df = session.create_dataframe([1, 2, 3, 4], schema=["a"])
>>> t.update({"b": 0}, t["a"] == source_df.a, source_df)
UpdateResult(rows_updated=6, multi_joined_rows_updated=0)
>>> t.sort("a", "b").collect()
[Row(A=1, B=0), Row(A=1, B=0), Row(A=2, B=0), Row(A=2, B=0), Row(A=3, B=0), Row(A=3, B=0)]

-- Example 33252
>>> # Adds a matched clause where a row in source is matched
>>> # if its key is equal to the key of any row in target.
>>> # For all such rows, delete them.
>>> from snowflake.snowpark.functions import when_matched
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=["key", "value"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new")], schema=["key", "value"])
>>> target.merge(source, target["key"] == source["key"], [when_matched().delete()])
MergeResult(rows_inserted=0, rows_updated=0, rows_deleted=2)
>>> target.collect() # the rows are deleted
[Row(KEY=11, VALUE='old')]

-- Example 33253
>>> # Adds a matched clause where a row in source is matched
>>> # if its key is equal to the key of any row in target.
>>> # For all such rows, update its value to the value of the
>>> # corresponding row in source.
>>> from snowflake.snowpark.functions import when_matched, lit
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=["key", "value"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new")], schema=["key", "value"])
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == lit("too_old")), [when_matched().update({"value": source["value"]})])
MergeResult(rows_inserted=0, rows_updated=1, rows_deleted=0)
>>> target.sort("key", "value").collect() # the value in the table is updated
[Row(KEY=10, VALUE='new'), Row(KEY=10, VALUE='old'), Row(KEY=11, VALUE='old')]

-- Example 33254
>>> # Adds a not-matched clause where a row in source is not matched
>>> # if its key does not equal the key of any row in target.
>>> # For all such rows, insert a row into target whose ley and value
>>> # are assigned to the key and value of the not matched row.
>>> from snowflake.snowpark.functions import when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")

>>> source = session.create_dataframe([(12, "new")], schema=schema)
>>> target.merge(source, target["key"] == source["key"], [when_not_matched().insert([source["key"], source["value"]])])
MergeResult(rows_inserted=1, rows_updated=0, rows_deleted=0)
>>> target.sort("key", "value").collect() # the rows are inserted
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='too_old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE='new')]

>>> # For all such rows, insert a row into target whose key is
>>> # assigned to the key of the not matched row.
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target.merge(source, target["key"] == source["key"], [when_not_matched().insert({"key": source["key"]})])
MergeResult(rows_inserted=1, rows_updated=0, rows_deleted=0)
>>> target.sort("key", "value").collect() # the rows are inserted
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='too_old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE=None)]

-- Example 33255
>>> from snowflake.snowpark.functions import when_matched, when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6],[4.0,6,8]], schema=["a", "b", "c"])

-- Example 33256
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 33257
>>> async_job = df.collect(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 33258
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 33259
>>> async_job = df.first(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5)]

-- Example 33260
>>> async_job = df.count(block=False)
>>> async_job.result()
4

-- Example 33261
>>> table_name = "name"
>>> async_job = df.write.save_as_table(table_name, block=False)
>>> # copy into a stage file
>>> remote_location = f"{session.get_session_stage()}/name.csv"
>>> async_job = df.write.copy_into_location(remote_location, block=False)
>>> async_job.result()[0]['rows_unloaded']
4

-- Example 33262
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> async_job = target.merge(source,target["key"] == source["key"],[when_matched().update({"value": source["value"]}),when_not_matched().insert({"key": source["key"]})],block=False)
>>> async_job.result()
MergeResult(rows_inserted=2, rows_updated=2, rows_deleted=0)

-- Example 33263
>>> df = session.sql("select SYSTEM$WAIT(3)")
>>> async_job = df.collect_nowait()
>>> async_job.cancel()

-- Example 33264
>>> from snowflake.snowpark.functions import col
>>> query_id = session.sql("select 1 as A, 2 as B, 3 as C").collect_nowait().query_id
>>> async_job = session.create_async_job(query_id)
>>> async_job.query 
'select 1 as A, 2 as B, 3 as C'
>>> async_job.result()
[Row(A=1, B=2, C=3)]
>>> async_job.result(result_type="pandas")
   A  B  C
0  1  2  3
>>> df = async_job.to_df()
>>> df.select(col("A").as_("D"), "B").collect()
[Row(D=1, B=2)]

-- Example 33265
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>>
>>> def my_copy(session: snowflake.snowpark.Session, from_table: str, to_table: str, count: int) -> str:
...     session.table(from_table).limit(count).write.save_as_table(to_table)
...     return "SUCCESS"
>>>
>>> my_copy_sp = session.sproc.register(my_copy, name="my_copy_sp", replace=True)
>>> _ = session.sql("create or replace temp table test_from(test_str varchar) as select randstr(20, random()) from table(generator(rowCount => 100))").collect()
>>>
>>> # call using sql
>>> _ = session.sql("drop table if exists test_to").collect()
>>> session.sql("call my_copy_sp('test_from', 'test_to', 10)").collect()
[Row(MY_COPY_SP='SUCCESS')]
>>> session.table("test_to").count()
10
>>> # call using session.call API
>>> _ = session.sql("drop table if exists test_to").collect()
>>> session.call("my_copy_sp", "test_from", "test_to", 10)
'SUCCESS'
>>> session.table("test_to").count()
10

-- Example 33266
>>> from snowflake.snowpark.functions import sproc
>>> from snowflake.snowpark.types import IntegerType
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> add_one_sp = sproc(
...     lambda session_, x: session_.sql(f"select {x} + 1").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType()]
... )
>>> add_one_sp(1)
2

-- Example 33267
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> @sproc
... def add_sp(session_: snowflake.snowpark.Session, x: int, y: int) -> int:
...    return session_.sql(f"select {x} + {y}").collect()[0][0]
>>> add_sp(1, 2)
3

-- Example 33268
>>> from snowflake.snowpark.types import IntegerType
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.sproc.register(
...     lambda session_, x, y: session_.sql(f"SELECT {x} * {y}").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True,
...     name="mul_sp",
...     replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("call mul_sp(5, 6)").collect()
[Row(MUL_SP=30)]
>>> # skip stored proc creation if it already exists
>>> _ = session.sproc.register(
...     lambda session_, x, y: session_.sql(f"SELECT {x} * {y} + 1").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True,
...     name="mul_sp",
...     if_not_exists=True,
...     stage_location="@mystage",
... )
>>> session.sql("call mul_sp(5, 6)").collect()
[Row(MUL_SP=30)]
>>> # overwrite stored procedure
>>> _ = session.sproc.register(
...     lambda session_, x, y: session_.sql(f"SELECT {x} * {y} + 1").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True,
...     name="mul_sp",
...     replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("call mul_sp(5, 6)").collect()
[Row(MUL_SP=31)]

-- Example 33269
>>> import snowflake.snowpark
>>> from resources.test_sp_dir.test_sp_file import mod5
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> @sproc(imports=[("tests/resources/test_sp_dir/test_sp_file.py", "resources.test_sp_dir.test_sp_file")])
... def mod5_and_plus1_sp(session_: snowflake.snowpark.Session, x: int) -> int:
...     return mod5(session_, x) + 1
>>> mod5_and_plus1_sp(2)
3

-- Example 33270
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>> import numpy as np
>>> import math
>>>
>>> @sproc(packages=["snowflake-snowpark-python", "numpy"])
... def sin_sp(_: snowflake.snowpark.Session, x: float) -> float:
...     return np.sin(x)
>>> sin_sp(0.5 * math.pi)
1.0

