-- Example 33472
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> result = df.select(any_value("a")).collect()
>>> assert len(result) == 1  # non-deterministic value in result.

-- Example 33473
>>> df = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df.select(approx_count_distinct("a").alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

-- Example 33474
>>> df = session.create_dataframe([0,1,2,3,4,5,6,7,8,9], schema=["a"])
>>> df.select(approx_percentile("a", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|4.5       |
------------

-- Example 33475
>>> df = session.create_dataframe([1,2,3,4,5], schema=["a"])
>>> df.select(approx_percentile_accumulate("a").alias("result")).show()
------------------------------
|"RESULT"                    |
------------------------------
|{                           |
|  "state": [                |
|    1.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    2.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    3.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    4.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    5.000000000000000e+00,  |
|    1.000000000000000e+00   |
|  ],                        |
|  "type": "tdigest",        |
|  "version": 1              |
|}                           |
------------------------------

-- Example 33476
>>> df1 = session.create_dataframe([1,2,3,4,5], schema=["a"])
>>> df2 = session.create_dataframe([6,7,8,9,10], schema=["b"])
>>> df_accu1 = df1.select(approx_percentile_accumulate("a").alias("app_percentile_accu"))
>>> df_accu2 = df2.select(approx_percentile_accumulate("b").alias("app_percentile_accu"))
>>> df_accu1.union(df_accu2).select(approx_percentile_combine("app_percentile_accu").alias("result")).show()
------------------------------
|"RESULT"                    |
------------------------------
|{                           |
|  "state": [                |
|    1.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    2.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    3.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    4.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    5.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    6.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    7.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    8.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    9.000000000000000e+00,  |
|    1.000000000000000e+00,  |
|    1.000000000000000e+01,  |
|    1.000000000000000e+00   |
|  ],                        |
|  "type": "tdigest",        |
|  "version": 1              |
|}                           |
------------------------------

-- Example 33477
>>> df = session.create_dataframe([1,2,3,4,5], schema=["a"])
>>> df_accu = df.select(approx_percentile_accumulate("a").alias("app_percentile_accu"))
>>> df_accu.select(approx_percentile_estimate("app_percentile_accu", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|3.0       |
------------

-- Example 33478
>>> df = session.create_dataframe([[1], [2], [3], [1]], schema=["a"])
>>> df.select(array_agg("a", True).within_group("a").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2,      |
|  3       |
|]         |
------------

-- Example 33479
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3])])
>>> df.select(array_append("a", lit(4)).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2,      |
|  3,      |
|  4       |
|]         |
------------

-- Example 33480
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3], b=[4, 5])])
>>> df.select(array_cat("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2,      |
|  3,      |
|  4,      |
|  5       |
|]         |
------------

-- Example 33481
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, None, 3])])
>>> df.select("a", array_compact("a").alias("compacted")).show()
-------------------------
|"A"      |"COMPACTED"  |
-------------------------
|[        |[            |
|  1,     |  1,         |
|  null,  |  3          |
|  3      |]            |
|]        |             |
-------------------------

-- Example 33482
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.select(array_construct("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2       |
|]         |
|[         |
|  3,      |
|  4       |
|]         |
------------

-- Example 33483
>>> df = session.create_dataframe([[1, None, 2], [3, None, 4]], schema=["a", "b", "c"])
>>> df.select(array_construct_compact("a", "b", "c").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2       |
|]         |
|[         |
|  3,      |
|  4       |
|]         |
------------

-- Example 33484
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2]), Row([1, 3])], schema=["a"])
>>> df.select(array_contains(lit(2), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|True      |
|False     |
------------

-- Example 33485
>>> from snowflake.snowpark.functions import array_construct,array_distinct,lit
>>> df = session.createDataFrame([["1"]], ["A"])
>>> df = df.withColumn("array", array_construct(lit(1), lit(1), lit(1), lit(2), lit(3), lit(2), lit(2)))
>>> df.withColumn("array_d", array_distinct("ARRAY")).show()
-----------------------------
|"A"  |"ARRAY"  |"ARRAY_D"  |
-----------------------------
|1    |[        |[          |
|     |  1,     |  1,       |
|     |  1,     |  2,       |
|     |  1,     |  3        |
|     |  2,     |]          |
|     |  3,     |           |
|     |  2,     |           |
|     |  2      |           |
|     |]        |           |
-----------------------------

-- Example 33486
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(["A", "B"], ["B", "C"])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  "A"     |
|]         |
------------

>>> df = session.create_dataframe([Row(["A", "B", "B", "B", "C"], ["B"])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  "A",    |
|  "B",    |
|  "B",    |
|  "C"     |
|]         |
------------

>>> df = session.create_dataframe([Row(["A", None, None], ["B", None])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  "A",    |
|  null    |
|]         |
------------

>>> df = session.create_dataframe([Row([{'a': 1, 'b': 2}, 1], [{'a': 1, 'b': 2}, 3])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1       |
|]         |
------------

>>> df = session.create_dataframe([Row(["A", "B"], None)], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude").alias("result")).show()
------------
|"RESULT"  |
------------
|NULL      |
------------

>>> df = session.create_dataframe([Row(["A", "B"], ["B", "C"])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude", False).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  "A"     |
|]         |
------------

>>> df = session.create_dataframe([Row(["A", "B", "B", "B", "C"], ["B"])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude", False).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  "A",    |
|  "C"     |
|]         |
------------

>>> df = session.create_dataframe([Row(["A", None, None], ["B", None])], schema=["source_array", "array_of_elements_to_exclude"])
>>> df.select(array_except("source_array", "array_of_elements_to_exclude", False).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  "A"     |
|]         |
------------

-- Example 33487
>>> from snowflake.snowpark import Row
>>> df1 = session.create_dataframe([(-2, 2)], ["a", "b"])
>>> df1.select(array_generate_range("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  -2,     |
|  -1,     |
|  0,      |
|  1       |
|]         |
------------

>>> df2 = session.create_dataframe([(4, -4, -2)], ["a", "b", "c"])
>>> df2.select(array_generate_range("a", "b", "c").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  4,      |
|  2,      |
|  0,      |
|  -2      |
|]         |
------------

-- Example 33488
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2]), Row([1, 3])], schema=["a"])
>>> df.select(array_insert("a", lit(0), lit(10)).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  10,     |
|  1,      |
|  2       |
|]         |
|[         |
|  10,     |
|  1,      |
|  3       |
|]         |
------------

-- Example 33489
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2], [1, 3])], schema=["a", "b"])
>>> df.select(array_intersection("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1       |
|]         |
------------

-- Example 33490
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, True, "s"])])
>>> df.select(array_to_string("a", lit(",")).alias("result")).show()
------------
|"RESULT"  |
------------
|1,true,s  |
------------

-- Example 33491
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A='20')]
>>> df = session.sql("select array_construct() as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A=None)]
>>> df = session.sql("select array_construct(null, null, null) as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A=None)]

-- Example 33492
>>> df = session.create_dataframe([[[None, None, None]]], schema=["A"])
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A='null')]

-- Example 33493
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A='0')]
>>> df = session.sql("select array_construct() as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A=None)]
>>> df = session.sql("select array_construct(null, null, null) as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A=None)]

-- Example 33494
>>> df = session.create_dataframe([[[None, None, None]]], schema=["A"])
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A='null')]

-- Example 33495
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([2, 1]), Row([1, 3])], schema=["a"])
>>> df.select(array_position(lit(1), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|0         |
------------

-- Example 33496
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3])])
>>> df.select(array_prepend("a", lit(4)).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  4,      |
|  1,      |
|  2,      |
|  3       |
|]         |
------------

-- Example 33497
>>> from snowflake.snowpark.types import VariantType
>>> df = session.create_dataframe([([1, '2', 3.1, 1, 1],)], ['data'])
>>> df.select(array_remove(df.data, 1).alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|[          |
|  "2",     |
|  3.1      |
|]          |
-------------

-- Example 33498
>>> df.select(array_remove(df.data, lit('2').cast(VariantType())).alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|[          |
|  1,       |
|  3.1,     |
|  1,       |
|  1        |
|]          |
-------------

-- Example 33499
>>> df.select(array_remove(df.data, None).alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|NULL       |
-------------

-- Example 33500
>>> df.select(array_remove(array_remove(df.data, 1), "2").alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|[          |
|  3.1      |
|]          |
-------------

-- Example 33501
>>> df = session.sql("select [1, 2, 3, 4] :: ARRAY(INT) as A")
>>> df.select(array_reverse("A")).show()
--------------------------
|"ARRAY_REVERSE(""A"")"  |
--------------------------
|[                       |
|  4,                    |
|  3,                    |
|  2,                    |
|  1                     |
|]                       |
--------------------------

-- Example 33502
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3])])
>>> df.select(array_size("a").alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

-- Example 33503
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3, 4, 5])])
>>> df.select(array_slice("a", lit(1), lit(3)).alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  2,      |
|  3       |
|]         |
------------

-- Example 33504
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_sort(df.a).as_("sorted_a")).show()
---------------
|"SORTED_A"   |
---------------
|[            |
|  0,         |
|  10,        |
|  20,        |
|  undefined  |
|]            |
---------------

>>> df.select(array_sort(df.a, False).as_("sorted_a")).show()
---------------
|"SORTED_A"   |
---------------
|[            |
|  20,        |
|  10,        |
|  0,         |
|  undefined  |
|]            |
---------------

>>> df.select(array_sort(df.a, False, True).as_("sorted_a")).show()
----------------
|"SORTED_A"    |
----------------
|[             |
|  undefined,  |
|  20,         |
|  10,         |
|  0           |
|]             |
----------------

-- Example 33505
>>> df = session.create_dataframe([[[20, 0, None, 10]]], schema=["a"])
>>> df.select(array_sort(df.a, False, False).as_("sorted_a")).show()
--------------
|"SORTED_A"  |
--------------
|[           |
|  null,     |
|  20,       |
|  10,       |
|  0         |
|]           |
--------------

>>> df.select(array_sort(df.a, False, True).as_("sorted_a")).show()
--------------
|"SORTED_A"  |
--------------
|[           |
|  null,     |
|  20,       |
|  10,       |
|  0         |
|]           |
--------------

-- Example 33506
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, True, "s"])])
>>> df.select(array_to_string("a", lit(",")).alias("result")).show()
------------
|"RESULT"  |
------------
|1,true,s  |
------------

-- Example 33507
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3], b=[4, 5])])
>>> df.select(array_cat("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2,      |
|  3,      |
|  4,      |
|  5       |
|]         |
------------

-- Example 33508
>>> df = session.create_dataframe([[5], [2], [1], [2], [1]], schema=["a"])
>>> df.select(array_unique_agg("a").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  5,      |
|  2,      |
|  1       |
|]         |
------------

-- Example 33509
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2], [1, 3]), Row([1, 2], [3, 4])], schema=["a", "b"])
>>> df.select(arrays_overlap("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|True      |
|False     |
------------

-- Example 33510
>>> df = session.sql("select array_construct('10', '20', '30') as A, array_construct(10, 20, 30) as B")
>>> df.select(arrays_zip(df.a, df.b).as_("zipped")).show(statement_params={"enable_arrays_zip_function": "TRUE"})
-------------------
|"ZIPPED"         |
-------------------
|[                |
|  {              |
|    "$1": "10",  |
|    "$2": 10     |
|  },             |
|  {              |
|    "$1": "20",  |
|    "$2": 20     |
|  },             |
|  {              |
|    "$1": "30",  |
|    "$2": 30     |
|  }              |
|]                |
-------------------

>>> df = session.sql("select array_construct('10', '20', '30') as A, array_construct(1, 2) as B, array_construct(1.1) as C")
>>> df.select(arrays_zip(df.a, df.b, df.c).as_("zipped")).show(statement_params={"enable_arrays_zip_function": "TRUE"})
-------------------
|"ZIPPED"         |
-------------------
|[                |
|  {              |
|    "$1": "10",  |
|    "$2": 1,     |
|    "$3": 1.1    |
|  },             |
|  {              |
|    "$1": "20",  |
|    "$2": 2,     |
|    "$3": null   |
|  },             |
|  {              |
|    "$1": "30",  |
|    "$2": null,  |
|    "$3": null   |
|  }              |
|]                |
-------------------

-- Example 33511
>>> df = session.sql("select array_construct(1, 2)::variant as a")
>>> df.select(as_array("a").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  1,      |
|  2       |
|]         |
------------

-- Example 33512
>>> df = session.sql("select to_binary('F0A5')::variant as a")
>>> df.select(as_binary("a").alias("result")).show()
--------------------------
|"RESULT"                |
--------------------------
|bytearray(b'ð¥')  |
--------------------------

-- Example 33513
>>> from snowflake.snowpark.functions import as_char, to_variant
>>> df = session.sql("select 'some string' as char")
>>> df.char_v = to_variant(df.char)
>>> df.select(df.char_v.as_("char")).collect() == df.select(df.char).collect()
False
>>> df.select(as_char(df.char_v).as_("char")).collect() == df.select(df.char).collect()
True

-- Example 33514
>>> df = session.sql("select date'2020-1-1'::variant as a")
>>> df.select(as_date("a").alias("result")).show()
--------------
|"RESULT"    |
--------------
|2020-01-01  |
--------------

-- Example 33515
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_decimal("a", 4, 1).alias("result")).show()
------------
|"RESULT"  |
------------
|1.2       |
------------

-- Example 33516
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_double("a").alias("result")).show()
------------
|"RESULT"  |
------------
|1.2345    |
------------

-- Example 33517
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_integer("a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
------------

-- Example 33518
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_decimal("a", 4, 1).alias("result")).show()
------------
|"RESULT"  |
------------
|1.2       |
------------

-- Example 33519
>>> df = session.sql("select object_construct('A',1,'B','BBBB')::variant as a")
>>> df.select(as_object("a").alias("result")).show()
-----------------
|"RESULT"       |
-----------------
|{              |
|  "A": 1,      |
|  "B": "BBBB"  |
|}              |
-----------------

-- Example 33520
>>> from snowflake.snowpark.types import VariantType, StructType, StructField, DoubleType
>>> schema=StructType([StructField("radius", DoubleType()),  StructField("radius_v", VariantType())])
>>> df = session.create_dataframe(data=[[2.0, None]], schema=schema)
>>> df.radius_v = to_variant(df.radius)
>>> df.select(df.radius_v.as_("radius_v"), df.radius).collect()
[Row(RADIUS_V='2.000000000000000e+00', RADIUS=2.0)]
>>> df.select(as_real(df.radius_v).as_("real_radius_v"), df.radius).collect()
[Row(REAL_RADIUS_V=2.0, RADIUS=2.0)]

-- Example 33521
>>> from snowflake.snowpark.functions import as_time, to_variant
>>> df = session.sql("select TO_TIME('12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_time(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 33522
>>> from snowflake.snowpark.functions import as_timestamp_ltz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_LTZ('2018-10-10 12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_ltz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 33523
>>> from snowflake.snowpark.functions import as_timestamp_ntz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_NTZ('2018-10-10 12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_ntz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 33524
>>> from snowflake.snowpark.functions import as_timestamp_tz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_TZ('2018-10-10 12:34:56 +0000') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_tz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 33525
>>> from snowflake.snowpark.functions import as_varchar, to_variant
>>> df = session.sql("select 'some string' as char")
>>> df.char_v = to_variant(df.char)
>>> df.select(df.char_v.as_("char")).collect() == df.select(df.char).collect()
False
>>> df.select(as_varchar(df.char_v).as_("char")).collect() == df.select(df.char).collect()
True

-- Example 33526
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=1), Row(A=2), Row(A=3)]

-- Example 33527
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc_nulls_first(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=1), Row(A=2), Row(A=3)]

-- Example 33528
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc_nulls_last(df["a"])).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=None), Row(A=None)]

-- Example 33529
>>> df = session.create_dataframe(['!', 'A', 'a', '', 'bcd', None], schema=['a'])
>>> df.select(df.a, ascii(df.a).as_('ascii')).collect()
[Row(A='!', ASCII=33), Row(A='A', ASCII=65), Row(A='a', ASCII=97), Row(A='', ASCII=0), Row(A='bcd', ASCII=98), Row(A=None, ASCII=None)]

-- Example 33530
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1]], schema=["deg"])
>>> df.select(asin(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.571     |
------------

-- Example 33531
>>> df = session.create_dataframe([2.129279455], schema=["a"])
>>> df.select(asinh(df["a"]).alias("asinh")).collect()
[Row(ASINH=1.4999999999596934)]

-- Example 33532
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1]], schema=["deg"])
>>> df.select(atan(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.785     |
------------

-- Example 33533
>>> df = session.create_dataframe([0.9051482536], schema=["a"])
>>> df.select(atanh(df["a"]).alias("result")).collect()
[Row(RESULT=1.4999999997517164)]

-- Example 33534
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2]], schema=["x", "y"])
>>> df.select(atan2(df.x, df.y).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.464     |
------------

-- Example 33535
>>> df = session.create_dataframe([[1], [2], [2]], schema=["d"])
>>> df.select(avg(df.d).alias("result")).show()
------------
|"RESULT"  |
------------
|1.666667  |
------------

-- Example 33536
>>> df = session.create_dataframe(["Snowflake", "Data"], schema=["input"])
>>> df.select(base64_encode(col("input")).alias("encoded")).collect()
[Row(ENCODED='U25vd2ZsYWtl'), Row(ENCODED='RGF0YQ==')]

-- Example 33537
>>> df = session.create_dataframe(["U25vd2ZsYWtl", "SEVMTE8="], schema=["input"])
>>> df.select(base64_decode_string(col("input")).alias("decoded")).collect()
[Row(DECODED='Snowflake'), Row(DECODED='HELLO')]

-- Example 33538
>>> df = session.create_dataframe(["Snowflake", "Data"], schema=["input"])
>>> df.select(base64_encode(col("input")).alias("encoded")).collect()
[Row(ENCODED='U25vd2ZsYWtl'), Row(ENCODED='RGF0YQ==')]

