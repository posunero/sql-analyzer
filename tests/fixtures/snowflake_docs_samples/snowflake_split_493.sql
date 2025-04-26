-- Example 33003
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

-- Example 33004
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

-- Example 33005
>>> df = session.create_dataframe([{"a": {"aa": 1, "bb": 2, "cc": 3}}])
>>> df.select(get_ignore_case(df["a"], lit("AA")).alias("get_ignore_case")).collect()
[Row(GET_IGNORE_CASE='1')]

-- Example 33006
>>> df = session.create_dataframe([{"a": {"aa": {"dd": 4}, "bb": 2, "cc": 3}}])
>>> df.select(get_path(df["a"], lit("aa.dd")).alias("get_path")).collect()
[Row(GET_PATH='4')]

-- Example 33007
>>> df = session.create_dataframe([[1, 2, 3], [2, 4, -1], [3, 6, None]], schema=["a", "b", "c"])
>>> df.select(greatest(df["a"], df["b"], df["c"]).alias("greatest")).collect()
[Row(GREATEST=3), Row(GREATEST=4), Row(GREATEST=None)]

-- Example 33008
>>> from snowflake.snowpark import GroupingSets
>>> df = session.create_dataframe([[1, 2, 3], [4, 5, 6]],schema=["a", "b", "c"])
>>> grouping_sets = GroupingSets([col("a")], [col("b")], [col("a"), col("b")])
>>> df.group_by_grouping_sets(grouping_sets).agg([count("c").alias("count_c"), grouping("a").alias("ga"), grouping("b").alias("gb"), grouping("a", "b").alias("gab")]).sort("a", "b").collect()
[Row(A=None, B=2, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=None, B=5, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=1, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=1, B=2, COUNT_C=1, GA=0, GB=0, GAB=0), Row(A=4, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=4, B=5, COUNT_C=1, GA=0, GB=0, GAB=0)]

-- Example 33009
>>> from snowflake.snowpark import GroupingSets
>>> df = session.create_dataframe([[1, 2, 3], [4, 5, 6]],schema=["a", "b", "c"])
>>> grouping_sets = GroupingSets([col("a")], [col("b")], [col("a"), col("b")])
>>> df.group_by_grouping_sets(grouping_sets).agg([count("c").alias("count_c"), grouping("a").alias("ga"), grouping("b").alias("gb"), grouping("a", "b").alias("gab")]).sort("a", "b").collect()
[Row(A=None, B=2, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=None, B=5, COUNT_C=1, GA=1, GB=0, GAB=2), Row(A=1, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=1, B=2, COUNT_C=1, GA=0, GB=0, GAB=0), Row(A=4, B=None, COUNT_C=1, GA=0, GB=1, GAB=1), Row(A=4, B=5, COUNT_C=1, GA=0, GB=0, GAB=0)]

-- Example 33010
>>> import decimal
>>> df = session.create_dataframe([[10, "10", decimal.Decimal(10), 10.0]], schema=["a", "b", "c", "d"])
>>> df.select(hash("a").alias("hash_a"), hash("b").alias("hash_b"), hash("c").alias("hash_c"), hash("d").alias("hash_d")).collect()
[Row(HASH_A=1599627706822963068, HASH_B=3622494980440108984, HASH_C=1599627706822963068, HASH_D=1599627706822963068)]
>>> df.select(hash(lit(None)).alias("one"), hash(lit(None), lit(None)).alias("two"), hash(lit(None), lit(None), lit(None)).alias("three")).collect()
[Row(ONE=8817975702393619368, TWO=953963258351104160, THREE=2941948363845684412)]

-- Example 33011
>>> df = session.create_dataframe(["Snowflake", "Hello"], schema=["input"])
>>> df.select(hex_encode(col("input")).alias("hex_encoded")).collect()
[Row(HEX_ENCODED='536E6F77666C616B65'), Row(HEX_ENCODED='48656C6C6F')]

-- Example 33012
>>> df = session.create_dataframe(["Snowflake", "Hello"], schema=["input"])
>>> df.select(hex_encode(col("input")).alias("hex_encoded")).collect()
[Row(HEX_ENCODED='536E6F77666C616B65'), Row(HEX_ENCODED='48656C6C6F')]

-- Example 33013
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(hour("a")).collect()
[Row(HOUR("A")=13), Row(HOUR("A")=1)]

-- Example 33014
>>> df = session.create_dataframe([True, False, None], schema=["a"])
>>> df.select(iff(df["a"], lit("true"), lit("false")).alias("iff")).collect()
[Row(IFF='true'), Row(IFF='false'), Row(IFF='false')]

-- Example 33015
>>> df = session.create_dataframe([("a", "b"), ("c", None), (None, "d"), (None, None)], schema=["e1", "e2"])
>>> df.select(ifnull(df["e1"], df["e2"]).alias("result")).collect()
[Row(RESULT='a'), Row(RESULT='c'), Row(RESULT='d'), Row(RESULT=None)]

-- Example 33016
>>> df = session.create_dataframe([[1, "a"], [2, "b"], [3, "c"]], schema=["col1", "col2"])
>>> df.filter(in_([col("col1"), col("col2")], [[1, "a"], [2, "b"]])).show()
-------------------
|"COL1"  |"COL2"  |
-------------------
|1       |a       |
|2       |b       |
-------------------

-- Example 33017
>>> df1 = session.sql("select 1, 'a'")
>>> df.filter(in_([col("col1"), col("col2")], df1)).show()
-------------------
|"COL1"  |"COL2"  |
-------------------
|1       |a       |
-------------------

-- Example 33018
>>> df = session.create_dataframe(["the sky is blue", "WE CAN HANDLE THIS", "ÄäÖößÜü", None], schema=["a"])
>>> df.select(initcap(df["a"]).alias("initcap")).collect()
[Row(INITCAP='The Sky Is Blue'), Row(INITCAP='We Can Handle This'), Row(INITCAP='Ääöößüü'), Row(INITCAP=None)]
>>> df.select(initcap(df["a"], lit('')).alias("initcap")).collect()
[Row(INITCAP='The sky is blue'), Row(INITCAP='We can handle this'), Row(INITCAP='Ääöößüü'), Row(INITCAP=None)]

-- Example 33019
>>> df = session.create_dataframe(["abc"], schema=["a"])
>>> df.select(insert(df["a"], 1, 2, lit("Z")).alias("insert")).collect()
[Row(INSERT='Zc')]

-- Example 33020
>>> df = session.create_dataframe([["hello world"], ["world hello"]], schema=["text"])
>>> df.select(instr(col("text"), "world").alias("position")).collect()
[Row(POSITION=7), Row(POSITION=1)]

-- Example 33021
>>> df = session.create_dataframe([[["element"], True]], schema=["a", "b"])
>>> df.select(is_array(df["a"]).alias("is_array_a"), is_array(df["b"]).alias("is_array_b")).collect()
[Row(IS_ARRAY_A=True, IS_ARRAY_B=False)]

-- Example 33022
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[b"snow", "snow"]], schema=["a", "b"])
>>> df.select(is_binary(to_variant(df["a"])).alias("binary"), is_binary(to_variant(df["b"])).alias("varchar")).collect()
[Row(BINARY=True, VARCHAR=False)]

-- Example 33023
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[True, 'X']], schema=["a", "b"])
>>> df.select(is_boolean(to_variant(df["a"])).alias("boolean"), is_boolean(to_variant(df["b"])).alias("varchar")).collect()
[Row(BOOLEAN=True, VARCHAR=False)]

-- Example 33024
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([["abc", 123]], schema=["a", "b"])
>>> df.select(is_char(to_variant(df["a"])).alias("varchar"), is_char(to_variant(df["b"])).alias("int")).collect()
[Row(VARCHAR=True, INT=False)]

-- Example 33025
>>> import datetime
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[datetime.date(2023, 3, 2), 123]], schema=["a", "b"])
>>> df.select(is_date(to_variant(df["a"])).alias("date"), is_date(to_variant(df["b"])).alias("int")).collect()
[Row(DATE=True, INT=False)]

-- Example 33026
>>> import datetime
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[datetime.date(2023, 3, 2), 123]], schema=["a", "b"])
>>> df.select(is_date(to_variant(df["a"])).alias("date"), is_date(to_variant(df["b"])).alias("int")).collect()
[Row(DATE=True, INT=False)]

-- Example 33027
>>> import decimal
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[decimal.Decimal(1), "X"]], schema=["a", "b"])
>>> df.select(is_decimal(to_variant(df["a"])).alias("decimal"), is_decimal(to_variant(df["b"])).alias("varchar")).collect()
[Row(DECIMAL=True, VARCHAR=False)]

-- Example 33028
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[1.2, "X"]], schema=["a", "b"])
>>> df.select(is_double(to_variant(df["a"])).alias("double"), is_double(to_variant(df["b"])).alias("varchar")).collect()
[Row(DOUBLE=True, VARCHAR=False)]

-- Example 33029
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([[1, "X"]], schema=["a", "b"])
>>> df.select(is_integer(to_variant(df["a"])).alias("int"), is_integer(to_variant(df["b"])).alias("varchar")).collect()
[Row(INT=True, VARCHAR=False)]

-- Example 33030
>>> from snowflake.snowpark.functions import is_null
>>> df = session.create_dataframe([1.2, float("nan"), None, 1.0], schema=["a"])
>>> df.select(is_null("a").as_("a")).collect()
[Row(A=False), Row(A=False), Row(A=True), Row(A=False)]

-- Example 33031
>>> from snowflake.snowpark.functions import to_variant, is_null_value
>>> df = session.create_dataframe([[{"a": "foo"}], [{"a": None}], [None]], schema=["a"])
>>> df.select(is_null_value(to_variant("a")["a"]).as_("a")).collect()
[Row(A=False), Row(A=True), Row(A=None)]

-- Example 33032
>>> from snowflake.snowpark.functions import to_variant, is_object
>>> df = session.create_dataframe([[[1, 2], {"a": "snow"}]], schema=["a", "b"])
>>> df.select(is_object(to_variant("a")).as_("a"), is_object(to_variant("b")).as_("b")).collect()
[Row(A=False, B=True)]

-- Example 33033
>>> from snowflake.snowpark.functions import to_variant, is_real
>>> df = session.create_dataframe([[1.2, "X"]], schema=["a", "b"])
>>> df.select(is_real(to_variant("a")).as_("a"), is_real(to_variant("b")).as_("b")).collect()
[Row(A=True, B=False)]

-- Example 33034
>>> import datetime
>>> from snowflake.snowpark.functions import to_variant, is_time
>>> df = session.create_dataframe([[datetime.time(10, 10), "X"]], schema=["a", "b"])
>>> df.select(is_time(to_variant("a")).as_("a"), is_time(to_variant("b")).as_("b")).collect()
[Row(A=True, B=False)]

-- Example 33035
>>> from snowflake.snowpark.functions import to_variant, is_timestamp_ltz
>>> df = session.sql("select to_timestamp_ntz('2017-02-24 12:00:00.456') as timestamp_ntz1, "
...                  "to_timestamp_ltz('2017-02-24 13:00:00.123 +01:00') as timestamp_ltz1, "
...                  "to_timestamp_tz('2017-02-24 13:00:00.123 +01:00') as timestamp_tz1")
>>> df.select(is_timestamp_ltz(to_variant("timestamp_ntz1")).as_("a"),
...           is_timestamp_ltz(to_variant("timestamp_ltz1")).as_("b"),
...           is_timestamp_ltz(to_variant("timestamp_tz1")).as_("c")).collect()
[Row(A=False, B=True, C=False)]

-- Example 33036
>>> from snowflake.snowpark.functions import to_variant, is_timestamp_ntz
>>> df = session.sql("select to_timestamp_ntz('2017-02-24 12:00:00.456') as timestamp_ntz1, "
...                  "to_timestamp_ltz('2017-02-24 13:00:00.123 +01:00') as timestamp_ltz1, "
...                  "to_timestamp_tz('2017-02-24 13:00:00.123 +01:00') as timestamp_tz1")
>>> df.select(is_timestamp_ntz(to_variant("timestamp_ntz1")).as_("a"),
...           is_timestamp_ntz(to_variant("timestamp_ltz1")).as_("b"),
...           is_timestamp_ntz(to_variant("timestamp_tz1")).as_("c")).collect()
[Row(A=True, B=False, C=False)]

-- Example 33037
>>> from snowflake.snowpark.functions import to_variant, is_timestamp_tz
>>> df = session.sql("select to_timestamp_ntz('2017-02-24 12:00:00.456') as timestamp_ntz1, "
...                  "to_timestamp_ltz('2017-02-24 13:00:00.123 +01:00') as timestamp_ltz1, "
...                  "to_timestamp_tz('2017-02-24 13:00:00.123 +01:00') as timestamp_tz1")
>>> df.select(is_timestamp_tz(to_variant("timestamp_ntz1")).as_("a"),
...           is_timestamp_tz(to_variant("timestamp_ltz1")).as_("b"),
...           is_timestamp_tz(to_variant("timestamp_tz1")).as_("c")).collect()
[Row(A=False, B=False, C=True)]

-- Example 33038
>>> from snowflake.snowpark.types import StructField, VariantType
>>> df = session.create_dataframe([["abc", 123]], schema=["a", "b"])
>>> df.select(is_char(to_variant(df["a"])).alias("varchar"), is_char(to_variant(df["b"])).alias("int")).collect()
[Row(VARCHAR=True, INT=False)]

-- Example 33039
>>> from snowflake.snowpark.functions import json_extract_path_text, to_variant
>>> df = session.create_dataframe([[{"a": "foo"}, "a"], [{"a": None}, "a"], [{"a": "foo"}, "b"], [None, "a"]], schema=["k", "v"])
>>> df.select(json_extract_path_text(to_variant("k"), "v").as_("res")).collect()
[Row(RES='foo'), Row(RES=None), Row(RES=None), Row(RES=None)]

-- Example 33040
>>> from snowflake.snowpark.functions import kurtosis
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(kurtosis("x").as_("x")).collect()
[Row(X=Decimal('3.613736609956'))]

-- Example 33041
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

-- Example 33042
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(last_day("a")).collect()
[Row(LAST_DAY("A")=datetime.date(2020, 5, 31)), Row(LAST_DAY("A")=datetime.date(2020, 8, 31))]
>>> df.select(last_day("a", "YEAR")).collect()
[Row(LAST_DAY("A", "YEAR")=datetime.date(2020, 12, 31)), Row(LAST_DAY("A", "YEAR")=datetime.date(2020, 12, 31))]

-- Example 33043
>>> from snowflake.snowpark.window import Window
>>> window = Window.partition_by("column1").order_by("column2")
>>> df = session.create_dataframe([[1, 10], [1, 11], [2, 20], [2, 21]], schema=["column1", "column2"])
>>> df.select(df["column1"], df["column2"], last_value(df["column2"]).over(window).as_("column2_last")).collect()
[Row(COLUMN1=1, COLUMN2=10, COLUMN2_LAST=11), Row(COLUMN1=1, COLUMN2=11, COLUMN2_LAST=11), Row(COLUMN1=2, COLUMN2=20, COLUMN2_LAST=21), Row(COLUMN1=2, COLUMN2=21, COLUMN2_LAST=21)]

-- Example 33044
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

-- Example 33045
>>> df = session.create_dataframe([[1, 2, 3], [2, 4, -1], [3, 6, None]], schema=["a", "b", "c"])
>>> df.select(least(df["a"], df["b"], df["c"]).alias("least")).collect()
[Row(LEAST=1), Row(LEAST=-1), Row(LEAST=None)]

-- Example 33046
>>> df = session.create_dataframe([["abc"], ["def"]], schema=["a"])
>>> df.select(left(col("a"), 2).alias("result")).show()
------------
|"RESULT"  |
------------
|ab        |
|de        |
------------

-- Example 33047
>>> df = session.create_dataframe(["the sky is blue", "WE CAN HANDLE THIS", "ÄäÖößÜü", None], schema=["a"])
>>> df.select(length(df["a"]).alias("length")).collect()
[Row(LENGTH=15), Row(LENGTH=18), Row(LENGTH=7), Row(LENGTH=None)]

-- Example 33048
>>> df = session.create_dataframe([1, 2, 3, 2, 4, 5], schema=["col"])
>>> df.select(listagg("col", ",").within_group(df["col"].asc()).as_("result")).collect()
[Row(RESULT='1,2,2,3,4,5')]

-- Example 33049
>>> import datetime
>>> columns = [lit(1), lit("1"), lit(1.0), lit(True), lit(b'snow'), lit(datetime.date(2023, 2, 2)), lit([1, 2]), lit({"snow": "flake"}), lit(lit(1))]
>>> session.create_dataframe([[]]).select([c.as_(str(i)) for i, c in enumerate(columns)]).show()
---------------------------------------------------------------------------------------------
|"0"  |"1"  |"2"  |"3"   |"4"                 |"5"         |"6"   |"7"                |"8"  |
---------------------------------------------------------------------------------------------
|1    |1    |1.0  |True  |bytearray(b'snow')  |2023-02-02  |[     |{                  |1    |
|     |     |     |      |                    |            |  1,  |  "snow": "flake"  |     |
|     |     |     |      |                    |            |  2   |}                  |     |
|     |     |     |      |                    |            |]     |                   |     |
---------------------------------------------------------------------------------------------

-- Example 33050
>>> from snowflake.snowpark.functions import ln
>>> from math import e
>>> df = session.create_dataframe([[e]], schema=["ln_value"])
>>> df.select(ln(col("ln_value")).alias("result")).show()
------------
|"RESULT"  |
------------
|1.0       |
------------

-- Example 33051
If the first argument is empty, this function always returns 1.

-- Example 33052
>>> df = session.create_dataframe([["find a needle in a haystack"],["nothing but hay in a haystack"]], schema=["expr"])
>>> df.select(locate("needle", col("expr")).alias("1-pos")).show()
-----------
|"1-pos"  |
-----------
|8        |
|0        |
-----------

-- Example 33053
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(localtimestamp(3)).collect()

-- Example 33054
>>> from snowflake.snowpark.types import IntegerType
>>> df = session.create_dataframe([1, 10], schema=["a"])
>>> df.select(log(10, df["a"]).cast(IntegerType()).alias("log")).collect()
[Row(LOG=0), Row(LOG=1)]

-- Example 33055
>>> df = session.create_dataframe([0, 1], schema=["a"])
>>> df.select(log1p(df["a"]).alias("log1p")).collect()
[Row(LOG1P=0.0), Row(LOG1P=0.6931471805599453)]

-- Example 33056
>>> df = session.create_dataframe([1, 2, 8], schema=["a"])
>>> df.select(log2(df["a"]).alias("log2")).collect()
[Row(LOG2=0.0), Row(LOG2=1.0), Row(LOG2=3.0)]

-- Example 33057
>>> df = session.create_dataframe([1, 10], schema=["a"])
>>> df.select(log10(df["a"]).alias("log10")).collect()
[Row(LOG10=0.0), Row(LOG10=1.0)]

-- Example 33058
>>> df = session.create_dataframe(['abc', 'Abc', 'aBC', 'Anführungszeichen', '14.95 €'], schema=["a"])
>>> df.select(lower(col("a"))).collect()
[Row(LOWER("A")='abc'), Row(LOWER("A")='abc'), Row(LOWER("A")='abc'), Row(LOWER("A")='anführungszeichen'), Row(LOWER("A")='14.95 €')]

-- Example 33059
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([["a"], ["b"], ["c"]], schema=["a"])
>>> df.select(lpad(col("a"), 3, lit("k")).alias("result")).show()
------------
|"RESULT"  |
------------
|kka       |
|kkb       |
|kkc       |
------------

-- Example 33060
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([["asss"], ["bsss"], ["csss"]], schema=["a"])
>>> df.select(rtrim(col("a"), trim_string=lit("sss")).alias("result")).show()
------------
|"RESULT"  |
------------
|a         |
|b         |
|c         |
------------

-- Example 33061
>>> import datetime
>>> from snowflake.snowpark.functions import to_date
>>>
>>> df = session.create_dataframe([datetime.datetime(2023, 8, 8, 1, 2, 3)], schema=["ts"])
>>> df.select(to_date(col("ts") + make_interval(days=10)).alias("next_day")).show()
--------------
|"NEXT_DAY"  |
--------------
|2023-08-18  |
--------------

-- Example 33062
>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as A, {'k2': 'v2'} :: MAP(STRING,STRING) as B")
>>> df.select(map_cat("A", "B")).show()
---------------------------
|"MAP_CAT(""A"", ""B"")"  |
---------------------------
|{                        |
|  "k1": "v1",            |
|  "k2": "v2"             |
|}                        |
---------------------------

>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as A, {'k2': 'v2'} :: MAP(STRING,STRING) as B, {'k3': 'v3'} :: MAP(STRING,STRING) as C")
>>> df.select(map_cat("A", "B", "C")).show()
-------------------------------------------
|"MAP_CAT(MAP_CAT(""A"", ""B""), ""C"")"  |
-------------------------------------------
|{                                        |
|  "k1": "v1",                            |
|  "k2": "v2",                            |
|  "k3": "v3"                             |
|}                                        |
-------------------------------------------

-- Example 33063
>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as A, {'k2': 'v2'} :: MAP(STRING,STRING) as B")
>>> df.select(map_cat("A", "B")).show()
---------------------------
|"MAP_CAT(""A"", ""B"")"  |
---------------------------
|{                        |
|  "k1": "v1",            |
|  "k2": "v2"             |
|}                        |
---------------------------

>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as A, {'k2': 'v2'} :: MAP(STRING,STRING) as B, {'k3': 'v3'} :: MAP(STRING,STRING) as C")
>>> df.select(map_cat("A", "B", "C")).show()
-------------------------------------------
|"MAP_CAT(MAP_CAT(""A"", ""B""), ""C"")"  |
-------------------------------------------
|{                                        |
|  "k1": "v1",                            |
|  "k2": "v2",                            |
|  "k3": "v3"                             |
|}                                        |
-------------------------------------------

-- Example 33064
>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as M, 'k1' as V")
>>> df.select(map_contains_key(col("V"), "M")).show()
------------------------------------
|"MAP_CONTAINS_KEY(""V"", ""M"")"  |
------------------------------------
|True                              |
------------------------------------

-- Example 33065
>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as M")
>>> df.select(map_contains_key("k1", "M")).show()
-----------------------------------
|"MAP_CONTAINS_KEY('K1', ""M"")"  |
-----------------------------------
|True                             |
-----------------------------------

-- Example 33066
>>> df = session.sql("select {'k1': 'v1', 'k2': 'v2'} :: MAP(STRING,STRING) as M")
>>> df.select(map_keys("M")).show()
---------------------
|"MAP_KEYS(""M"")"  |
---------------------
|[                  |
|  "k1",            |
|  "k2"             |
|]                  |
---------------------

-- Example 33067
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(max("x").as_("x")).collect()
[Row(X=10)]

-- Example 33068
>>> df = session.create_dataframe([
...     [1001, 10, 10000],
...     [1020, 10, 9000],
...     [1030, 10, 8000],
...     [900, 20, 15000],
...     [2000, 20, None],
...     [2010, 20, 15000],
...     [2020, 20, 8000]
... ], schema=["employee_id", "department_id", "salary"])
>>> df.select(max_by("employee_id", "salary", 3)).collect()
[Row(MAX_BY("EMPLOYEE_ID", "SALARY", 3)='[\n  900,\n  2010,\n  1001\n]')]

-- Example 33069
>>> df = session.create_dataframe(["a", "b"], schema=["col"]).select(md5("col"))
>>> df.collect()
[Row(MD5("COL")='0cc175b9c0f1b6a831c399e269772661'), Row(MD5("COL")='92eb5ffee6ae2fec3ad71c777531578f')]

