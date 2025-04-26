-- Example 22222
>>> import datetime
>>> df = session.create_dataframe([datetime.datetime(2023, 4, 16), datetime.datetime(2017, 4, 3, 2, 59, 37, 153)], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='2023-04-16 00:00:00.000'), Row(ANS='2017-04-03 02:59:37.000')]

-- Example 22223
>>> df = session.create_dataframe(['2013-05-17', '2013-05-17'], schema=['a'])
>>> df.select(to_date(col('a')).as_('ans')).collect()
[Row(ANS=datetime.date(2013, 5, 17)), Row(ANS=datetime.date(2013, 5, 17))]

>>> df = session.create_dataframe(['2013-05-17', '2013-05-17'], schema=['a'])
>>> df.select(to_date(col('a'), 'YYYY-MM-DD').as_('ans')).collect()
[Row(ANS=datetime.date(2013, 5, 17)), Row(ANS=datetime.date(2013, 5, 17))]

>>> df = session.create_dataframe(['2013-05-17', '2013-05-17'], schema=['a'])
>>> df.select(to_date(col('a'), 'YYYY-MM-DD').as_('ans')).collect()
[Row(ANS=datetime.date(2013, 5, 17)), Row(ANS=datetime.date(2013, 5, 17))]

>>> df = session.create_dataframe(['31536000000000', '71536004000000'], schema=['a'])
>>> df.select(to_date(col('a')).as_('ans')).collect()
[Row(ANS=datetime.date(1971, 1, 1)), Row(ANS=datetime.date(1972, 4, 7))]

-- Example 22224
>>> df = session.create_dataframe(['12', '11.3', '-90.12345'], schema=['a'])
>>> df.select(to_decimal(col('a'), 38, 0).as_('ans')).collect()
[Row(ANS=12), Row(ANS=11), Row(ANS=-90)]

-- Example 22225
>>> df.select(to_decimal(col('a'), 38, 2).as_('ans')).collect()
[Row(ANS=Decimal('12.00')), Row(ANS=Decimal('11.30')), Row(ANS=Decimal('-90.12'))]

-- Example 22226
>>> df = session.create_dataframe(['12', '11.3', '-90.12345'], schema=['a'])
>>> df.select(to_double(col('a')).as_('ans')).collect()
[Row(ANS=12.0), Row(ANS=11.3), Row(ANS=-90.12345)]

-- Example 22227
>>> df = session.create_dataframe(['12+', '11.3+', '90.12-'], schema=['a'])
>>> df.select(to_double(col('a'), "999.99MI").as_('ans')).collect()
[Row(ANS=12.0), Row(ANS=11.3), Row(ANS=-90.12)]

-- Example 22228
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(to_file("@mystage/testCSV.csv").alias("file"))
>>> result = json.loads(df.collect()[0][0])
>>> result["RELATIVE_PATH"]
'testCSV.csv'
>>> result["CONTENT_TYPE"]
'text/csv'


This function or method is in private preview since 1.29.0.

-- Example 22229
>>> df = session.create_dataframe(['POINT(-122.35 37.55)', 'POINT(20.92 43.33)'], schema=['a'])
>>> df.select(to_geography(col("a"))).collect()
[Row(TO_GEOGRAPHY("A")='{\n  "coordinates": [\n    -122.35,\n    37.55\n  ],\n  "type": "Point"\n}'), Row(TO_GEOGRAPHY("A")='{\n  "coordinates": [\n    20.92,\n    43.33\n  ],\n  "type": "Point"\n}')]

-- Example 22230
>>> df = session.create_dataframe(['POINT(-122.35 37.55)', 'POINT(20.92 43.33)'], schema=['a'])
>>> df.select(to_geometry(col("a"))).collect(statement_params={"GEOMETRY_OUTPUT_FORMAT": "WKT"})
[Row(TO_GEOMETRY("A")='POINT(-122.35 37.55)'), Row(TO_GEOMETRY("A")='POINT(20.92 43.33)')]

-- Example 22231
>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df = session.create_dataframe([Row(a=None),Row(a=12),Row(a=3.141),Row(a={'a':10,'b':20}),Row(a=[1,23,456])], schema=schema)
>>> df.select(to_json(col("a")).as_('ans')).collect()
[Row(ANS=None), Row(ANS='12'), Row(ANS='3.141'), Row(ANS='{"a":10,"b":20}'), Row(ANS='[1,23,456]')]

-- Example 22232
>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df = session.create_dataframe(["{'a':10,'b':20}", None], schema=schema)
>>> df.select(to_object(col("a")).as_('ans')).collect()
[Row(ANS='{\n  "a": 10,\n  "b": 20\n}'), Row(ANS=None)]

-- Example 22233
>>> df = session.create_dataframe(['04:15:29.999'], schema=['a'])
>>> df.select(to_time(col("a"))).collect()
[Row(TO_TIME("A")=datetime.time(4, 15, 29, 999000))]

-- Example 22234
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 1, 2, 3, 4000))]
>>> df = session.create_dataframe(["2020-05-01 13:11:20.000"], schema=['a'])
>>> df.select(to_timestamp(col("a"), lit("YYYY-MM-DD HH24:MI:SS.FF3")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2020, 5, 1, 13, 11, 20))]

-- Example 22235
>>> import datetime
>>> df = session.createDataFrame([datetime.datetime(2022, 12, 25, 13, 59, 38, 467)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2022, 12, 25, 13, 59, 38, 467))]
>>> df = session.createDataFrame([datetime.date(2023, 3, 1)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2023, 3, 1, 0, 0))]

-- Example 22236
>>> df = session.createDataFrame([20, 31536000000], schema=['a'])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(TO_TIMESTAMP("A")=datetime.datetime(2969, 5, 3, 0, 0))]
>>> df.select(to_timestamp(col("a"), lit(9))).collect()
[Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0)), Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0, 31, 536000))]

-- Example 22237
>>> df = session.createDataFrame(['20', '31536000000', '31536000000000', '31536000000000000'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0))]

-- Example 22238
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['t'])
>>> df.select(to_utc_timestamp(col("t"), "America/Los_Angeles").alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 9, 2, 3, 4000))]

-- Example 22239
>>> df = session.create_dataframe([('2019-01-31 01:02:03.004', "America/Los_Angeles")], schema=['t', 'tz'])
>>> df.select(to_utc_timestamp(col("t"), col("tz")).alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 9, 2, 3, 4000))]

-- Example 22240
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='1'), Row(ANS='2'), Row(ANS='3'), Row(ANS='4')]

-- Example 22241
>>> import datetime
>>> df = session.create_dataframe([datetime.datetime(2023, 4, 16), datetime.datetime(2017, 4, 3, 2, 59, 37, 153)], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='2023-04-16 00:00:00.000'), Row(ANS='2017-04-03 02:59:37.000')]

-- Example 22242
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df_conv = df.select(to_variant(col("a")).as_("ans")).sort("ans")
>>> df_conv.collect()
[Row(ANS='1'), Row(ANS='2'), Row(ANS='3'), Row(ANS='4')]

After conversion via to_variant, another variant dataframe can be merged.

>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df_other = session.create_dataframe([Row(a=10), Row(a='test'), Row(a={'a': 10, 'b': 20}), Row(a=[1, 2, 3])], schema=schema)
>>> df_conv.union(df_other).select(typeof(col("ans")).as_("ans")).sort("ans").collect()
[Row(ANS='ARRAY'), Row(ANS='INTEGER'), Row(ANS='INTEGER'), Row(ANS='INTEGER'), Row(ANS='INTEGER'), Row(ANS='INTEGER'), Row(ANS='OBJECT'), Row(ANS='VARCHAR')]

-- Example 22243
>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df = session.create_dataframe([Row(a=10), Row(a='test'), Row(a={'a': 10, 'b': 20}), Row(a=[1, 2, 3])], schema=schema)
>>> df.select(to_xml(col("A")).as_("ans")).collect()
[Row(ANS='<SnowflakeData type="INTEGER">10</SnowflakeData>'), Row(ANS='<SnowflakeData type="VARCHAR">test</SnowflakeData>'), Row(ANS='<SnowflakeData type="OBJECT"><a type="INTEGER">10</a><b type="INTEGER">20</b></SnowflakeData>'), Row(ANS='<SnowflakeData type="ARRAY"><e type="INTEGER">1</e><e type="INTEGER">2</e><e type="INTEGER">3</e></SnowflakeData>')]

-- Example 22244
>>> df = session.create_dataframe(["abcdef", "abba"], schema=["a"])
>>> df.select(translate(col("a"), lit("abc"), lit("ABC")).as_("ans")).collect()
[Row(ANS='ABCdef'), Row(ANS='ABBA')]

>>> df = session.create_dataframe(["file with spaces.txt", "\ttest"], schema=["a"])
>>> df.select(translate(col("a"), lit(" \t"), lit("_")).as_("ans")).collect()
[Row(ANS='file_with_spaces.txt'), Row(ANS='test')]

-- Example 22245
>>> df = session.create_dataframe(['hello', ' world', '   !   '], schema=["a"])
>>> df.collect()
[Row(A='hello'), Row(A=' world'), Row(A='   !   ')]
>>> df.select(trim(col("a"))).collect()
[Row(TRIM("A")='hello'), Row(TRIM("A")='world'), Row(TRIM("A")='!')]

-- Example 22246
>>> df = session.create_dataframe(['EUR 12.96', '7.89USD', '5.99E'], schema=["a"])
>>> df.select(trim(col("a"), lit("EURUSD ")).as_("ans")).collect()
[Row(ANS='12.96'), Row(ANS='7.89'), Row(ANS='5.99')]

-- Example 22247
>>> df = session.create_dataframe(['abc12 45a 79bc!'], schema=["a"])
>>> df.select(trim(col("a"), lit("abc!")).as_("ans")).collect()
[Row(ANS='12 45a 79')]

-- Example 22248
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

-- Example 22249
>>> import datetime
>>> df = session.createDataFrame([datetime.date(2022, 12, 25), datetime.date(2022, 1, 10), datetime.date(2022, 7, 7)], schema=["a"])
>>> df.select(trunc(col("a"), lit("QUARTER"))).collect()
[Row(TRUNC("A", 'QUARTER')=datetime.date(2022, 10, 1)), Row(TRUNC("A", 'QUARTER')=datetime.date(2022, 1, 1)), Row(TRUNC("A", 'QUARTER')=datetime.date(2022, 7, 1))]

>>> df = session.createDataFrame([datetime.datetime(2022, 12, 25, 13, 59, 38, 467)], schema=["a"])
>>> df.collect()
[Row(A=datetime.datetime(2022, 12, 25, 13, 59, 38, 467))]
>>> df.select(trunc(col("a"), lit("MINUTE"))).collect()
[Row(TRUNC("A", 'MINUTE')=datetime.datetime(2022, 12, 25, 13, 59))]

-- Example 22250
>>> from snowflake.snowpark.types import IntegerType, FloatType
>>> df = session.create_dataframe(['0', '-12', '22', '1001'], schema=["a"])
>>> df.select(try_cast(col("a"), IntegerType()).as_('ans')).collect()
[Row(ANS=0), Row(ANS=-12), Row(ANS=22), Row(ANS=1001)]

-- Example 22251
>>> df = session.create_dataframe(['0.12', 'USD 27.90', '13.97 USD', '€97.0', '17,-'], schema=["a"])
>>> df.select(try_cast(col("a"), FloatType()).as_('ans')).collect()
[Row(ANS=0.12), Row(ANS=None), Row(ANS=None), Row(ANS=None), Row(ANS=None)]

-- Example 22252
>>> df = session.create_dataframe(["01", "A B", "Hello", None], schema=["hex_encoded_string"])
>>> df.select(try_to_binary(df["hex_encoded_string"], 'HEX').alias("b")).collect()
[Row(B=bytearray(b'\x01')), Row(B=None), Row(B=None), Row(B=None)]

-- Example 22253
>>> df = session.create_dataframe([1, 2, 3], schema=["A"])
>>> df.select(typeof(col("A")).as_("ans")).collect()
[Row(ANS='INTEGER'), Row(ANS='INTEGER'), Row(ANS='INTEGER')]

-- Example 22254
>>> from snowflake.snowpark.types import VariantType, StructType, StructField
>>> schema = StructType([StructField("A", VariantType())])
>>> df = session.create_dataframe([1, 3.1, 'test'], schema=schema)
>>> df.select(typeof(col("A")).as_("ans")).collect()
[Row(ANS='INTEGER'), Row(ANS='DECIMAL'), Row(ANS='VARCHAR')]

-- Example 22255
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

-- Example 22256
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

-- Example 22257
>>> from snowflake.snowpark.types import IntegerType
>>> add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()])
>>> df = session.create_dataframe([1, 2, 3], schema=["a"])
>>> df.select(add_one(col("a")).as_("ans")).collect()
[Row(ANS=2), Row(ANS=3), Row(ANS=4)]

-- Example 22258
>>> @udf(name="minus_one", replace=True)
... def minus_one(x: int) -> int:
...     return x - 1
>>> df.select(minus_one(col("a")).as_("ans")).collect()
[Row(ANS=0), Row(ANS=1), Row(ANS=2)]
>>> session.sql("SELECT minus_one(10)").collect()
[Row(MINUS_ONE(10)=9)]

-- Example 22259
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

-- Example 22260
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

-- Example 22261
>>> df = session.create_dataframe(["U25vd2ZsYWtl", "SEVMTE8="], schema=["input"])
>>> df.select(base64_decode_string(col("input")).alias("decoded")).collect()
[Row(DECODED='Snowflake'), Row(DECODED='HELLO')]

-- Example 22262
>>> import datetime
>>> df = session.create_dataframe(
...     [[1]],
...     schema=["a"],
... )
>>> df.select(uniform(1, 100, col("a")).alias("UNIFORM")).collect()
[Row(UNIFORM=62)]

-- Example 22263
>>> import datetime
>>> df = session.create_dataframe([["2013-05-08T23:39:20.123-07:00"]], schema=["ts_col"])
>>> df.select(unix_timestamp(col("ts_col")).alias("unix_time")).show()
---------------
|"UNIX_TIME"  |
---------------
|1368056360   |
---------------

-- Example 22264
>>> df = session.create_dataframe(['abc', 'Abc', 'aBC', 'Anführungszeichen', '14.95 €'], schema=["a"])
>>> df.select(upper(col("a"))).collect()
[Row(UPPER("A")='ABC'), Row(UPPER("A")='ABC'), Row(UPPER("A")='ABC'), Row(UPPER("A")='ANFÜHRUNGSZEICHEN'), Row(UPPER("A")='14.95 €')]

-- Example 22265
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

-- Example 22266
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

-- Example 22267
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

-- Example 22268
>>> from snowflake.snowpark.functions import vector_inner_product
>>> df = session.sql("select [1,2,3]::vector(int,3) as a, [2,3,4]::vector(int,3) as b")
>>> df.select(vector_inner_product(df.a, df.b).as_("dist")).show()
----------
|"DIST"  |
----------
|20.0    |
----------

-- Example 22269
>>> from snowflake.snowpark.functions import vector_l2_distance
>>> df = session.sql("select [1,2,3]::vector(int,3) as a, [2,3,4]::vector(int,3) as b")
>>> df.select(vector_l2_distance(df.a, df.b).as_("dist")).show()
----------------------
|"DIST"              |
----------------------
|1.7320508075688772  |
----------------------

-- Example 22270
>>> import datetime
>>> df = session.create_dataframe(
...     [[datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f")]],
...     schema=["a"],
... )
>>> df.select(weekofyear("a")).collect()
[Row(WEEKOFYEAR("A")=18)]

-- Example 22271
>>> df = session.create_dataframe([1, None, 2, 3, None, 5, 6], schema=["a"])
>>> df.collect()
[Row(A=1), Row(A=None), Row(A=2), Row(A=3), Row(A=None), Row(A=5), Row(A=6)]
>>> df.select(when(col("a") % 2 == 0, lit("even")).as_("ans")).collect()
[Row(ANS=None), Row(ANS=None), Row(ANS='even'), Row(ANS=None), Row(ANS=None), Row(ANS=None), Row(ANS='even')]

-- Example 22272
>>> df.select(when(col("a") % 2 == 0, lit("even")).when(col("a") % 2 == 1, lit("odd")).as_("ans")).collect()
[Row(ANS='odd'), Row(ANS=None), Row(ANS='even'), Row(ANS='odd'), Row(ANS=None), Row(ANS='odd'), Row(ANS='even')]
>>> df.select(when(col("a") % 2 == 0, lit("even")).when(col("a") % 2 == 1, lit("odd")).otherwise(lit("unknown")).as_("ans")).collect()
[Row(ANS='odd'), Row(ANS='unknown'), Row(ANS='even'), Row(ANS='odd'), Row(ANS='unknown'), Row(ANS='odd'), Row(ANS='even')]

-- Example 22273
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=["key", "value"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=["key", "value"])
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == "too_old"),
...              [when_matched().update({"value": source["value"]})])
MergeResult(rows_inserted=0, rows_updated=1, rows_deleted=0)
>>> target.collect()
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='new'), Row(KEY=11, VALUE='old')]

-- Example 22274
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

-- Example 22275
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

-- Example 22276
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

-- Example 22277
>>> df = session.create_dataframe(['<level1 attr1="a">1<level2 attr2="b">2<level3>3a</level3><level3>3b</level3></level2></level1>'], schema=["str"]).select(parse_xml("str").as_("obj"))
>>> df.collect()
[Row(OBJ='<level1 attr1="a">\n  1\n  <level2 attr2="b">\n    2\n    <level3>3a</level3>\n    <level3>3b</level3>\n  </level2>\n</level1>')]
>>> df.select(xmlget("obj", lit("level2")).as_("ans")).collect()
[Row(ANS='<level2 attr2="b">\n  2\n  <level3>3a</level3>\n  <level3>3b</level3>\n</level2>')]

-- Example 22278
>>> df.select(xmlget(xmlget("obj", lit("level2")), lit("level3"), lit(0)).as_("ans")).collect()
[Row(ANS='<level3>3a</level3>')]
>>> df.select(xmlget(xmlget("obj", lit("level2")), lit("level3"), lit(1)).as_("ans")).collect()
[Row(ANS='<level3>3b</level3>')]
>>> df.select(xmlget("obj", lit("level2"), lit(5)).as_("ans")).collect()
[Row(ANS=None)]

-- Example 22279
>>> df.select(get(xmlget("obj", lit("level2")), lit("@")).as_("ans")).collect()
[Row(ANS='"level2"')]
>>> df.select(get(xmlget("obj", lit("level2")), lit("$")).as_("ans")).collect()
[Row(ANS='[\n  2,\n  {\n    "$": "3a",\n    "@": "level3"\n  },\n  {\n    "$": "3b",\n    "@": "level3"\n  }\n]')]
>>> df.select(get(xmlget(xmlget("obj", lit("level2")), lit("level3")), lit("$")).as_("ans")).collect()
[Row(ANS='"3a"')]
>>> df.select(get(xmlget("obj", lit("level2")), lit("@attr2")).as_("ans")).collect()
[Row(ANS='"b"')]

-- Example 22280
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(year("a")).collect()
[Row(YEAR("A")=2020), Row(YEAR("A")=2020)]

-- Example 22281
>>> from snowflake.snowpark.functions import col, avg
>>> window1 = Window.partition_by("value").order_by("key").rows_between(Window.CURRENT_ROW, 2)
>>> window2 = Window.order_by(col("key").desc()).range_between(Window.UNBOUNDED_PRECEDING, Window.UNBOUNDED_FOLLOWING)
>>> df = session.create_dataframe([(1, "1"), (2, "2"), (1, "3"), (2, "4")], schema=["key", "value"])
>>> df.select(avg("value").over(window1).as_("window1"), avg("value").over(window2).as_("window2")).sort("window1").collect()
[Row(WINDOW1=1.0, WINDOW2=2.5), Row(WINDOW1=2.0, WINDOW2=2.5), Row(WINDOW1=3.0, WINDOW2=2.5), Row(WINDOW1=4.0, WINDOW2=2.5)]

-- Example 22282
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

-- Example 22283
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

-- Example 22284
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

-- Example 22285
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

-- Example 22286
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

-- Example 22287
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

-- Example 22288
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

