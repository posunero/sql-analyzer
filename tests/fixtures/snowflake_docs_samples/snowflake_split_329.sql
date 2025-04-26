-- Example 22021
>>> df.select(df.strs, flatten(df.maps, recursive=True)).select("strs", "key", "value").where("key is NULL").sort("strs", "value").show()
---------------------------------------
|"STRS"  |"KEY"  |"VALUE"             |
---------------------------------------
|Coffee  |NULL   |"Triangle"          |
|Kimura  |NULL   |"Leg Entanglement"  |
|Kimura  |NULL   |"X"                 |
---------------------------------------

-- Example 22022
>>> df = session.create_dataframe([135.135, -975.975], schema=["a"])
>>> df.select(floor(df["a"]).alias("floor")).collect()
[Row(FLOOR=135.0), Row(FLOOR=-976.0)]

-- Example 22023
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_content_type(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
'text/csv'


This function or method is in private preview since 1.29.0.

-- Example 22024
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_etag(to_file("@mystage/testCSV.csv")).alias("file"))
>>> len(df.collect()[0][0])  


This function or method is in private preview since 1.29.0.

-- Example 22025
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_file_type(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
'document'


This function or method is in private preview since 1.29.0.

-- Example 22026
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_last_modified(to_file("@mystage/testCSV.csv")).alias("file"))
>>> type(df.collect()[0][0])
<class 'datetime.datetime'>


This function or method is in private preview since 1.29.0.

-- Example 22027
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_relative_path(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
'testCSV.csv'


This function or method is in private preview since 1.29.0.

-- Example 22028
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_scoped_file_url(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]


This function or method is in private preview since 1.29.0.

-- Example 22029
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_size(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
32


This function or method is in private preview since 1.29.0.

-- Example 22030
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_stage(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0].split(".")[-1]
'MYSTAGE'


This function or method is in private preview since 1.29.0.

-- Example 22031
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_get_stage_file_url(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]  
'https://'


This function or method is in private preview since 1.29.0.

-- Example 22032
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_audio(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 22033
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_compressed(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 22034
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_document(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
True


This function or method is in private preview since 1.29.0.

-- Example 22035
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_image(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 22036
>>> import json
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> r = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False, overwrite=True)
>>> df = session.range(1).select(fl_is_video(to_file("@mystage/testCSV.csv")).alias("file"))
>>> df.collect()[0][0]
False


This function or method is in private preview since 1.29.0.

-- Example 22037
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 1, 2, 3, 4000))]
>>> df = session.create_dataframe(["2020-05-01 13:11:20.000"], schema=['a'])
>>> df.select(to_timestamp(col("a"), lit("YYYY-MM-DD HH24:MI:SS.FF3")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2020, 5, 1, 13, 11, 20))]

-- Example 22038
>>> import datetime
>>> df = session.createDataFrame([datetime.datetime(2022, 12, 25, 13, 59, 38, 467)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2022, 12, 25, 13, 59, 38, 467))]
>>> df = session.createDataFrame([datetime.date(2023, 3, 1)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2023, 3, 1, 0, 0))]

-- Example 22039
>>> df = session.createDataFrame([20, 31536000000], schema=['a'])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(TO_TIMESTAMP("A")=datetime.datetime(2969, 5, 3, 0, 0))]
>>> df.select(to_timestamp(col("a"), lit(9))).collect()
[Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0)), Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0, 31, 536000))]

-- Example 22040
>>> df = session.createDataFrame(['20', '31536000000', '31536000000000', '31536000000000000'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0))]

-- Example 22041
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['t'])
>>> df.select(from_utc_timestamp(col("t"), "America/Los_Angeles").alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 30, 17, 2, 3, 4000))]

-- Example 22042
>>> df = session.create_dataframe([('2019-01-31 01:02:03.004', "America/Los_Angeles")], schema=['t', 'tz'])
>>> df.select(from_utc_timestamp(col("t"), col("tz")).alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 30, 17, 2, 3, 4000))]

-- Example 22043
>>> df = session.create_dataframe([1, 2, 3, 4], schema=["a"])  # a single column with 4 rows
>>> df.select(call_function("avg", col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.500000      |
----------------

>>> my_avg = function('avg')
>>> df.select(my_avg(col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.500000      |
----------------

-- Example 22044
>>> from snowflake.snowpark.functions import lit
>>> df = session.createDataFrame([({"a": 1.0, "b": 2.0}, [1, 2, 3],), ({}, [],)], ["map", "list"])
>>> df.select(get(df.list, 1).as_("idx1")).sort(col("idx1")).show()
----------
|"IDX1"  |
----------
|NULL    |
|2       |
----------


>>> df.select(get(df.map, lit("a")).as_("get_a")).sort(col("get_a")).show()
-----------
|"GET_A"  |
-----------
|NULL     |
|1        |
-----------

-- Example 22045
>>> df = session.create_dataframe([{"a": {"aa": 1, "bb": 2, "cc": 3}}])
>>> df.select(get_ignore_case(df["a"], lit("AA")).alias("get_ignore_case")).collect()
[Row(GET_IGNORE_CASE='1')]

-- Example 22046
>>> df = session.create_dataframe([{"a": {"aa": {"dd": 4}, "bb": 2, "cc": 3}}])
>>> df.select(get_path(df["a"], lit("aa.dd")).alias("get_path")).collect()
[Row(GET_PATH='4')]

-- Example 22047
>>> df = session.create_dataframe([[1, 2, 3], [2, 4, -1], [3, 6, None]], schema=["a", "b", "c"])
>>> df.select(greatest(df["a"], df["b"], df["c"]).alias("greatest")).collect()
[Row(GREATEST=3), Row(GREATEST=4), Row(GREATEST=None)]

-- Example 22048
>>> from snowflake.snowpark import GroupingSets
>>> df = session.create_dataframe([[1, 2, 3], [4, 5, 6]],schema=["a", "b", "c"])
>>> grouping_sets = GroupingSets([col("a")], [col("b")], [col("a"), col("b")])
>>> df.group_by_grouping_sets(grouping_sets).agg([count("c").alias("count_c"), grouping("a").alias("ga"), grouping("b").alias("gb"), grouping("a", "b").alias("gab")]).sort("a", "b").collect()
[Row(A=None, B=2, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=None, B=5, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=1, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=1, B=2, COUNT_C=1, GA=0, GB=0, GAB=0), Row(A=4, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=4, B=5, COUNT_C=1, GA=0, GB=0, GAB=0)]

-- Example 22049
>>> from snowflake.snowpark import GroupingSets
>>> df = session.create_dataframe([[1, 2, 3], [4, 5, 6]],schema=["a", "b", "c"])
>>> grouping_sets = GroupingSets([col("a")], [col("b")], [col("a"), col("b")])
>>> df.group_by_grouping_sets(grouping_sets).agg([count("c").alias("count_c"), grouping("a").alias("ga"), grouping("b").alias("gb"), grouping("a", "b").alias("gab")]).sort("a", "b").collect()
[Row(A=None, B=2, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=None, B=5, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=1, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=1, B=2, COUNT_C=1, GA=0, GB=0, GAB=0), Row(A=4, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=4, B=5, COUNT_C=1, GA=0, GB=0, GAB=0)]

-- Example 22050
>>> import decimal
>>> df = session.create_dataframe([[10, "10", decimal.Decimal(10), 10.0]], schema=["a", "b", "c", "d"])
>>> df.select(hash("a").alias("hash_a"), hash("b").alias("hash_b"), hash("c").alias("hash_c"), hash("d").alias("hash_d")).collect()
[Row(HASH_A=1599627706822963068, HASH_B=3622494980440108984, HASH_C=1599627706822963068, HASH_D=1599627706822963068)]
>>> df.select(hash(lit(None)).alias("one"), hash(lit(None), lit(None)).alias("two"), hash(lit(None), lit(None), lit(None)).alias("three")).collect()
[Row(ONE=8817975702393619368, TWO=953963258351104160, THREE=2941948363845684412)]

-- Example 22051
>>> df = session.create_dataframe(["Snowflake", "Hello"], schema=["input"])
>>> df.select(hex_encode(col("input")).alias("hex_encoded")).collect()
[Row(HEX_ENCODED='536E6F77666C616B65'), Row(HEX_ENCODED='48656C6C6F')]

-- Example 22052
>>> df = session.create_dataframe(["Snowflake", "Hello"], schema=["input"])
>>> df.select(hex_encode(col("input")).alias("hex_encoded")).collect()
[Row(HEX_ENCODED='536E6F77666C616B65'), Row(HEX_ENCODED='48656C6C6F')]

-- Example 22053
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(hour("a")).collect()
[Row(HOUR("A")=13), Row(HOUR("A")=1)]

-- Example 22054
>>> df = session.create_dataframe([True, False, None], schema=["a"])
>>> df.select(iff(df["a"], lit("true"), lit("false")).alias("iff")).collect()
[Row(IFF='true'), Row(IFF='false'), Row(IFF='false')]

-- Example 22055
>>> df = session.create_dataframe([("a", "b"), ("c", None), (None, "d"), (None, None)], schema=["e1", "e2"])
>>> df.select(ifnull(df["e1"], df["e2"]).alias("result")).collect()
[Row(RESULT='a'), Row(RESULT='c'), Row(RESULT='d'), Row(RESULT=None)]

-- Example 22056
>>> df = session.create_dataframe([[1, "a"], [2, "b"], [3, "c"]], schema=["col1", "col2"])
>>> df.filter(in_([col("col1"), col("col2")], [[1, "a"], [2, "b"]])).show()
-------------------
|"COL1"  |"COL2"  |
-------------------
|1       |a       |
|2       |b       |
-------------------

-- Example 22057
>>> df1 = session.sql("select 1, 'a'")
>>> df.filter(in_([col("col1"), col("col2")], df1)).show()
-------------------
|"COL1"  |"COL2"  |
-------------------
|1       |a       |
-------------------

-- Example 22058
>>> df = session.create_dataframe(["the sky is blue", "WE CAN HANDLE THIS", "ÄäÖößÜü", None], schema=["a"])
>>> df.select(initcap(df["a"]).alias("initcap")).collect()
[Row(INITCAP='The Sky Is Blue'), Row(INITCAP='We Can Handle This'), Row(INITCAP='Ääöößüü'), Row(INITCAP=None)]
>>> df.select(initcap(df["a"], lit('')).alias("initcap")).collect()
[Row(INITCAP='The sky is blue'), Row(INITCAP='We can handle this'), Row(INITCAP='Ääöößüü'), Row(INITCAP=None)]

-- Example 22059
>>> df = session.create_dataframe(["abc"], schema=["a"])
>>> df.select(insert(df["a"], 1, 2, lit("Z")).alias("insert")).collect()
[Row(INSERT='Zc')]

-- Example 22060
>>> df = session.create_dataframe([["hello world"], ["world hello"]], schema=["text"])
>>> df.select(instr(col("text"), "world").alias("position")).collect()
[Row(POSITION=7), Row(POSITION=1)]

-- Example 22061
>>> df = session.create_dataframe([[["element"], True]], schema=["a", "b"])
>>> df.select(is_array(df["a"]).alias("is_array_a"), is_array(df["b"]).alias("is_array_b")).collect()
[Row(IS_ARRAY_A=True, IS_ARRAY_B=False)]

-- Example 22062
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[b"snow", "snow"]], schema=["a", "b"])
>>> df.select(is_binary(to_variant(df["a"])).alias("binary"), is_binary(to_variant(df["b"])).alias("varchar")).collect()
[Row(BINARY=True, VARCHAR=False)]

-- Example 22063
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[True, 'X']], schema=["a", "b"])
>>> df.select(is_boolean(to_variant(df["a"])).alias("boolean"), is_boolean(to_variant(df["b"])).alias("varchar")).collect()
[Row(BOOLEAN=True, VARCHAR=False)]

-- Example 22064
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([["abc", 123]], schema=["a", "b"])
>>> df.select(is_char(to_variant(df["a"])).alias("varchar"), is_char(to_variant(df["b"])).alias("int")).collect()
[Row(VARCHAR=True, INT=False)]

-- Example 22065
>>> import datetime
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[datetime.date(2023, 3, 2), 123]], schema=["a", "b"])
>>> df.select(is_date(to_variant(df["a"])).alias("date"), is_date(to_variant(df["b"])).alias("int")).collect()
[Row(DATE=True, INT=False)]

-- Example 22066
>>> import datetime
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[datetime.date(2023, 3, 2), 123]], schema=["a", "b"])
>>> df.select(is_date(to_variant(df["a"])).alias("date"), is_date(to_variant(df["b"])).alias("int")).collect()
[Row(DATE=True, INT=False)]

-- Example 22067
>>> import decimal
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[decimal.Decimal(1), "X"]], schema=["a", "b"])
>>> df.select(is_decimal(to_variant(df["a"])).alias("decimal"), is_decimal(to_variant(df["b"])).alias("varchar")).collect()
[Row(DECIMAL=True, VARCHAR=False)]

-- Example 22068
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[1.2, "X"]], schema=["a", "b"])
>>> df.select(is_double(to_variant(df["a"])).alias("double"), is_double(to_variant(df["b"])).alias("varchar")).collect()
[Row(DOUBLE=True, VARCHAR=False)]

-- Example 22069
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[1, "X"]], schema=["a", "b"])
>>> df.select(is_integer(to_variant(df["a"])).alias("int"), is_integer(to_variant(df["b"])).alias("varchar")).collect()
[Row(INT=True, VARCHAR=False)]

-- Example 22070
>>> from snowflake.snowpark.functions import is_null
>>> df = session.create_dataframe([1.2, float("nan"), None, 1.0], schema=["a"])
>>> df.select(is_null("a").as_("a")).collect()
[Row(A=False), Row(A=False), Row(A=True), Row(A=False)]

-- Example 22071
>>> from snowflake.snowpark.functions import to_variant, is_null_value
>>> df = session.create_dataframe([[{"a": "foo"}], [{"a": None}], [None]], schema=["a"])
>>> df.select(is_null_value(to_variant("a")["a"]).as_("a")).collect()
[Row(A=False), Row(A=True), Row(A=None)]

-- Example 22072
>>> from snowflake.snowpark.functions import to_variant, is_object
>>> df = session.create_dataframe([[[1, 2], {"a": "snow"}]], schema=["a", "b"])
>>> df.select(is_object(to_variant("a")).as_("a"), is_object(to_variant("b")).as_("b")).collect()
[Row(A=False, B=True)]

-- Example 22073
>>> from snowflake.snowpark.functions import to_variant, is_real
>>> df = session.create_dataframe([[1.2, "X"]], schema=["a", "b"])
>>> df.select(is_real(to_variant("a")).as_("a"), is_real(to_variant("b")).as_("b")).collect()
[Row(A=True, B=False)]

-- Example 22074
>>> import datetime
>>> from snowflake.snowpark.functions import to_variant, is_time
>>> df = session.create_dataframe([[datetime.time(10, 10), "X"]], schema=["a", "b"])
>>> df.select(is_time(to_variant("a")).as_("a"), is_time(to_variant("b")).as_("b")).collect()
[Row(A=True, B=False)]

-- Example 22075
>>> from snowflake.snowpark.functions import to_variant, is_timestamp_ltz
>>> df = session.sql("select to_timestamp_ntz('2017-02-24 12:00:00.456') as timestamp_ntz1, "
...                  "to_timestamp_ltz('2017-02-24 13:00:00.123 +01:00') as timestamp_ltz1, "
...                  "to_timestamp_tz('2017-02-24 13:00:00.123 +01:00') as timestamp_tz1")
>>> df.select(is_timestamp_ltz(to_variant("timestamp_ntz1")).as_("a"),
...           is_timestamp_ltz(to_variant("timestamp_ltz1")).as_("b"),
...           is_timestamp_ltz(to_variant("timestamp_tz1")).as_("c")).collect()
[Row(A=False, B=True, C=False)]

-- Example 22076
>>> from snowflake.snowpark.functions import to_variant, is_timestamp_ntz
>>> df = session.sql("select to_timestamp_ntz('2017-02-24 12:00:00.456') as timestamp_ntz1, "
...                  "to_timestamp_ltz('2017-02-24 13:00:00.123 +01:00') as timestamp_ltz1, "
...                  "to_timestamp_tz('2017-02-24 13:00:00.123 +01:00') as timestamp_tz1")
>>> df.select(is_timestamp_ntz(to_variant("timestamp_ntz1")).as_("a"),
...           is_timestamp_ntz(to_variant("timestamp_ltz1")).as_("b"),
...           is_timestamp_ntz(to_variant("timestamp_tz1")).as_("c")).collect()
[Row(A=True, B=False, C=False)]

-- Example 22077
>>> from snowflake.snowpark.functions import to_variant, is_timestamp_tz
>>> df = session.sql("select to_timestamp_ntz('2017-02-24 12:00:00.456') as timestamp_ntz1, "
...                  "to_timestamp_ltz('2017-02-24 13:00:00.123 +01:00') as timestamp_ltz1, "
...                  "to_timestamp_tz('2017-02-24 13:00:00.123 +01:00') as timestamp_tz1")
>>> df.select(is_timestamp_tz(to_variant("timestamp_ntz1")).as_("a"),
...           is_timestamp_tz(to_variant("timestamp_ltz1")).as_("b"),
...           is_timestamp_tz(to_variant("timestamp_tz1")).as_("c")).collect()
[Row(A=False, B=False, C=True)]

-- Example 22078
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([["abc", 123]], schema=["a", "b"])
>>> df.select(is_char(to_variant(df["a"])).alias("varchar"), is_char(to_variant(df["b"])).alias("int")).collect()
[Row(VARCHAR=True, INT=False)]

-- Example 22079
>>> from snowflake.snowpark.functions import json_extract_path_text, to_variant
>>> df = session.create_dataframe([[{"a": "foo"}, "a"], [{"a": None}, "a"], [{"a": "foo"}, "b"], [None, "a"]], schema=["k", "v"])
>>> df.select(json_extract_path_text(to_variant("k"), "v").as_("res")).collect()
[Row(RES='foo'), Row(RES=None), Row(RES=None), Row(RES=None)]

-- Example 22080
>>> from snowflake.snowpark.functions import kurtosis
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(kurtosis("x").as_("x")).collect()
[Row(X=Decimal('3.613736609956'))]

-- Example 22081
>>> from snowflake.snowpark.window import Window
>>> df = session.create_dataframe(
...     [
...         [1, 2, 1],
...         [1, 2, 3],
...         [2, 1, 10],
...         [2, 2, 1],
...         [2, 2, 3],
...     ],
...     schema=["x", "y", "z"]
... )
>>> df.select(lag("Z").over(Window.partition_by(col("X")).order_by(col("Y"))).alias("result")).collect()
[Row(RESULT=None), Row(RESULT=10), Row(RESULT=1), Row(RESULT=None), Row(RESULT=1)]

-- Example 22082
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(last_day("a")).collect()
[Row(LAST_DAY("A")=datetime.date(2020, 5, 31)), Row(LAST_DAY("A")=datetime.date(2020, 8, 31))]
>>> df.select(last_day("a", "YEAR")).collect()
[Row(LAST_DAY("A", "YEAR")=datetime.date(2020, 12, 31)), Row(LAST_DAY("A", "YEAR")=datetime.date(2020, 12, 31))]

-- Example 22083
>>> from snowflake.snowpark.window import Window
>>> window = Window.partition_by("column1").order_by("column2")
>>> df = session.create_dataframe([[1, 10], [1, 11], [2, 20], [2, 21]], schema=["column1", "column2"])
>>> df.select(df["column1"], df["column2"], last_value(df["column2"]).over(window).as_("column2_last")).collect()
[Row(COLUMN1=1, COLUMN2=10, COLUMN2_LAST=11), Row(COLUMN1=1, COLUMN2=11, COLUMN2_LAST=11), Row(COLUMN1=2, COLUMN2=20, COLUMN2_LAST=21), Row(COLUMN1=2, COLUMN2=21, COLUMN2_LAST=21)]

-- Example 22084
>>> from snowflake.snowpark.window import Window
>>> df = session.create_dataframe(
...     [
...         [1, 2, 1],
...         [1, 2, 3],
...         [2, 1, 10],
...         [2, 2, 1],
...         [2, 2, 3],
...     ],
...     schema=["x", "y", "z"]
... )
>>> df.select(lead("Z").over(Window.partition_by(col("X")).order_by(col("Y"))).alias("result")).collect()
[Row(RESULT=1), Row(RESULT=3), Row(RESULT=None), Row(RESULT=3), Row(RESULT=None)]

-- Example 22085
>>> df = session.create_dataframe([[1, 2, 3], [2, 4, -1], [3, 6, None]], schema=["a", "b", "c"])
>>> df.select(least(df["a"], df["b"], df["c"]).alias("least")).collect()
[Row(LEAST=1), Row(LEAST=-1), Row(LEAST=None)]

-- Example 22086
>>> df = session.create_dataframe([["abc"], ["def"]], schema=["a"])
>>> df.select(left(col("a"), 2).alias("result")).show()
------------
|"RESULT"  |
------------
|ab        |
|de        |
------------

-- Example 22087
>>> df = session.create_dataframe(["the sky is blue", "WE CAN HANDLE THIS", "ÄäÖößÜü", None], schema=["a"])
>>> df.select(length(df["a"]).alias("length")).collect()
[Row(LENGTH=15), Row(LENGTH=18), Row(LENGTH=7), Row(LENGTH=None)]

