-- Example 22088
>>> df = session.create_dataframe([1, 2, 3, 2, 4, 5], schema=["col"])
>>> df.select(listagg("col", ",").within_group(df["col"].asc()).as_("result")).collect()
[Row(RESULT='1,2,2,3,4,5')]

-- Example 22089
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

-- Example 22090
>>> from snowflake.snowpark.functions import ln
>>> from math import e
>>> df = session.create_dataframe([[e]], schema=["ln_value"])
>>> df.select(ln(col("ln_value")).alias("result")).show()
------------
|"RESULT"  |
------------
|1.0       |
------------

-- Example 22091
If the first argument is empty, this function always returns 1.

-- Example 22092
>>> df = session.create_dataframe([["find a needle in a haystack"],["nothing but hay in a haystack"]], schema=["expr"])
>>> df.select(locate("needle", col("expr")).alias("1-pos")).show()
-----------
|"1-pos"  |
-----------
|8        |
|0        |
-----------

-- Example 22093
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(localtimestamp(3)).collect()

-- Example 22094
>>> from snowflake.snowpark.types import IntegerType
>>> df = session.create_dataframe([1, 10], schema=["a"])
>>> df.select(log(10, df["a"]).cast(IntegerType()).alias("log")).collect()
[Row(LOG=0), Row(LOG=1)]

-- Example 22095
>>> df = session.create_dataframe([0, 1], schema=["a"])
>>> df.select(log1p(df["a"]).alias("log1p")).collect()
[Row(LOG1P=0.0), Row(LOG1P=0.6931471805599453)]

-- Example 22096
>>> df = session.create_dataframe([1, 2, 8], schema=["a"])
>>> df.select(log2(df["a"]).alias("log2")).collect()
[Row(LOG2=0.0), Row(LOG2=1.0), Row(LOG2=3.0)]

-- Example 22097
>>> df = session.create_dataframe([1, 10], schema=["a"])
>>> df.select(log10(df["a"]).alias("log10")).collect()
[Row(LOG10=0.0), Row(LOG10=1.0)]

-- Example 22098
>>> df = session.create_dataframe(['abc', 'Abc', 'aBC', 'Anführungszeichen', '14.95 €'], schema=["a"])
>>> df.select(lower(col("a"))).collect()
[Row(LOWER("A")='abc'), Row(LOWER("A")='abc'), Row(LOWER("A")='abc'), Row(LOWER("A")='anführungszeichen'), Row(LOWER("A")='14.95 €')]

-- Example 22099
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

-- Example 22100
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

-- Example 22101
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

-- Example 22102
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

-- Example 22103
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

-- Example 22104
>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as M, 'k1' as V")
>>> df.select(map_contains_key(col("V"), "M")).show()
------------------------------------
|"MAP_CONTAINS_KEY(""V"", ""M"")"  |
------------------------------------
|True                              |
------------------------------------

-- Example 22105
>>> df = session.sql("select {'k1': 'v1'} :: MAP(STRING,STRING) as M")
>>> df.select(map_contains_key("k1", "M")).show()
-----------------------------------
|"MAP_CONTAINS_KEY('K1', ""M"")"  |
-----------------------------------
|True                             |
-----------------------------------

-- Example 22106
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

-- Example 22107
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(max("x").as_("x")).collect()
[Row(X=10)]

-- Example 22108
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

-- Example 22109
>>> df = session.create_dataframe(["a", "b"], schema=["col"]).select(md5("col"))
>>> df.collect()
[Row(MD5("COL")='0cc175b9c0f1b6a831c399e269772661'), Row(MD5("COL")='92eb5ffee6ae2fec3ad71c777531578f')]

-- Example 22110
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(mean("x").as_("x")).collect()
[Row(X=Decimal('3.600000'))]

-- Example 22111
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(median("x").as_("x")).collect()
[Row(X=Decimal('3.000'))]

-- Example 22112
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(min("x").as_("x")).collect()
[Row(X=1)]

-- Example 22113
>>> df = session.create_dataframe([
...     [1001, 10, 10000],
...     [1020, 10, 9000],
...     [1030, 10, 8000],
...     [900, 20, 15000],
...     [2000, 20, None],
...     [2010, 20, 15000],
...     [2020, 20, 8000]
... ], schema=["employee_id", "department_id", "salary"])
>>> df.select(min_by("employee_id", "salary", 3).alias("min_by")).collect()
[Row(MIN_BY='[\n  1030,\n  2020,\n  1020\n]')]

-- Example 22114
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(minute("a")).collect()
[Row(MINUTE("A")=11), Row(MINUTE("A")=30)]

-- Example 22115
>>> df = session.create_dataframe([1, 3, 10, 1, 4], schema=["x"])
>>> df.select(mode("x").as_("x")).collect()
[Row(X=1)]

-- Example 22116
>>> df = session.generator(seq8(0), rowcount=3)
>>> df.collect()
[Row(SEQ8(0)=0), Row(SEQ8(0)=1), Row(SEQ8(0)=2)]

-- Example 22117
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(month("a")).collect()
[Row(MONTH("A")=5), Row(MONTH("A")=8)]

-- Example 22118
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(monthname("a")).collect()
[Row(MONTHNAME("A")='May'), Row(MONTHNAME("A")='Aug')]

-- Example 22119
>>> import datetime
>>> df = session.create_dataframe([[
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ]], schema=["a", "b"])
>>> df.select(months_between("a", "b")).collect()
[Row(MONTHS_BETWEEN("A", "B")=Decimal('-3.629452'))]

-- Example 22120
>>> df = session.create_dataframe([[1]], schema=["a"])
>>> df.select(negate(col("a").alias("result"))).show()
------------
|"RESULT"  |
------------
|-1        |
------------

-- Example 22121
>>> import datetime
>>> df = session.create_dataframe([
...     (datetime.date.fromisoformat("2020-08-01"), "mo"),
...     (datetime.date.fromisoformat("2020-12-01"), "we"),
... ], schema=["a", "b"])
>>> df.select(next_day("a", col("b"))).collect()
[Row(NEXT_DAY("A", "B")=datetime.date(2020, 8, 3)), Row(NEXT_DAY("A", "B")=datetime.date(2020, 12, 2))]
>>> df.select(next_day("a", "fr")).collect()
[Row(NEXT_DAY("A", 'FR')=datetime.date(2020, 8, 7)), Row(NEXT_DAY("A", 'FR')=datetime.date(2020, 12, 4))]

-- Example 22122
>>> df = session.create_dataframe([1,2,3], schema=["a"])
>>> df.select(normal(0, 1, "a").alias("normal")).collect()
[Row(NORMAL=-1.143416214223267), Row(NORMAL=-0.78469958830255), Row(NORMAL=-0.365971322006404)]

-- Example 22123
>>> df = session.create_dataframe([[True]], schema=["a"])
>>> df.select(not_(col("a").alias("result"))).show()
------------
|"RESULT"  |
------------
|False     |
------------

-- Example 22124
>>> from snowflake.snowpark.window import Window
>>> window = Window.partition_by("column1").order_by("column2")
>>> df = session.create_dataframe([[1, 10], [1, 11], [2, 20], [2, 21]], schema=["column1", "column2"])
>>> df.select(df["column1"], df["column2"], nth_value(df["column2"], 2).over(window).as_("column2_2nd")).collect()
[Row(COLUMN1=1, COLUMN2=10, COLUMN2_2ND=11), Row(COLUMN1=1, COLUMN2=11, COLUMN2_2ND=11), Row(COLUMN1=2, COLUMN2=20, COLUMN2_2ND=21), Row(COLUMN1=2, COLUMN2=21, COLUMN2_2ND=21)]

-- Example 22125
>>> from snowflake.snowpark.window import Window
>>> df = session.create_dataframe(
...     [["C", "SPY", 3], ["C", "AAPL", 10], ["N", "SPY", 5], ["N", "AAPL", 7], ["Q", "MSFT", 3]],
...     schema=["exchange", "symbol", "shares"]
... )
>>> df.select(col("exchange"), col("symbol"), ntile(3).over(Window.partition_by("exchange").order_by("shares")).alias("ntile_3")).order_by(["exchange","symbol"]).show()
-------------------------------------
|"EXCHANGE"  |"SYMBOL"  |"NTILE_3"  |
-------------------------------------
|C           |AAPL      |2          |
|C           |SPY       |1          |
|N           |AAPL      |2          |
|N           |SPY       |1          |
|Q           |MSFT      |1          |
-------------------------------------

-- Example 22126
>>> df = session.create_dataframe([0, 1], schema=["a"])
>>> df.select(nullifzero(df["a"]).alias("result")).collect()
[Row(RESULT=None), Row(RESULT=1)]

-- Example 22127
>>> df = session.create_dataframe([("a", "b"), ("c", None), (None, "d"), (None, None)], schema=["e1", "e2"])
>>> df.select(ifnull(df["e1"], df["e2"]).alias("result")).collect()
[Row(RESULT='a'), Row(RESULT='c'), Row(RESULT='d'), Row(RESULT=None)]

-- Example 22128
>>> from snowflake.snowpark.types import StructType, StructField, VariantType, StringType
>>> df = session.create_dataframe(
...     [["name", "Joe"], ["zip", "98004"]],
...     schema=StructType([StructField("k", StringType()), StructField("v", VariantType())])
... )
>>> df.select(object_agg(col("k"), col("v")).alias("result")).show()
--------------------
|"RESULT"          |
--------------------
|{                 |
|  "name": "Joe",  |
|  "zip": "98004"  |
|}                 |
--------------------

-- Example 22129
>>> from snowflake.snowpark.types import StructType, StructField, VariantType, StringType
>>> df = session.create_dataframe(
...     [["name", "Joe"], ["zip", "98004"],["age", None], [None, "value"]],
...     schema=StructType([StructField("k", StringType()), StructField("v", VariantType())])
... )
>>> df.select(object_construct(col("k"), col("v")).alias("result")).show()
--------------------
|"RESULT"          |
--------------------
|{                 |
|  "name": "Joe"   |
|}                 |
|{                 |
|  "zip": "98004"  |
|}                 |
|{}                |
|{}                |
--------------------

-- Example 22130
>>> from snowflake.snowpark.types import StructType, StructField, VariantType, StringType
>>> df = session.create_dataframe(
...     [["key_1", "one"], ["key_2", None]],
...     schema=StructType([StructField("k", StringType()), StructField("v", VariantType())])
... )
>>> df.select(object_construct_keep_null(col("k"), col("v")).alias("result")).show()
--------------------
|"RESULT"          |
--------------------
|{                 |
|  "key_1": "one"  |
|}                 |
|{                 |
|  "key_2": null   |
|}                 |
--------------------

-- Example 22131
>>> from snowflake.snowpark.functions import lit
>>> df = session.sql(
...     "select object_construct(a,b,c,d,e,f) as obj from "
...     "values('age', 21, 'zip', 21021, 'name', 'Joe'),"
...     "('age', 26, 'zip', 94021, 'name', 'Jay') as T(a,b,c,d,e,f)"
... )
>>> df.select(object_delete(col("obj"), lit("age")).alias("result")).show()
--------------------
|"RESULT"          |
--------------------
|{                 |
|  "name": "Joe",  |
|  "zip": 21021    |
|}                 |
|{                 |
|  "name": "Jay",  |
|  "zip": 94021    |
|}                 |
--------------------

-- Example 22132
>>> from snowflake.snowpark.functions import lit
>>> df = session.sql(
...     "select object_construct(a,b,c,d,e,f) as obj, k, v from "
...     "values('age', 21, 'zip', 21021, 'name', 'Joe', 'age', 0),"
...     "('age', 26, 'zip', 94021, 'name', 'Jay', 'age', 0) as T(a,b,c,d,e,f,k,v)"
... )
>>> df.select(object_insert(col("obj"), lit("key"), lit("v")).alias("result")).show()
--------------------
|"RESULT"          |
--------------------
|{                 |
|  "age": 21,      |
|  "key": "v",     |
|  "name": "Joe",  |
|  "zip": 21021    |
|}                 |
|{                 |
|  "age": 26,      |
|  "key": "v",     |
|  "name": "Jay",  |
|  "zip": 94021    |
|}                 |
--------------------

-- Example 22133
>>> from snowflake.snowpark.functions import lit
>>> df = session.sql(
...     "select object_construct(a,b,c,d,e,f) as obj, k, v from "
...     "values('age', 21, 'zip', 21021, 'name', 'Joe', 'age', 0),"
...     "('age', 26, 'zip', 94021, 'name', 'Jay', 'age', 0) as T(a,b,c,d,e,f,k,v)"
... )
>>> df.select(object_keys(col("obj")).alias("result")).show()
-------------
|"RESULT"   |
-------------
|[          |
|  "age",   |
|  "name",  |
|  "zip"    |
|]          |
|[          |
|  "age",   |
|  "name",  |
|  "zip"    |
|]          |
-------------

-- Example 22134
>>> from snowflake.snowpark.functions import lit
>>> df = session.sql(
...     "select object_construct(a,b,c,d,e,f) as obj, k, v from "
...     "values('age', 21, 'zip', 21021, 'name', 'Joe', 'age', 0),"
...     "('age', 26, 'zip', 94021, 'name', 'Jay', 'age', 0) as T(a,b,c,d,e,f,k,v)"
... )
>>> df.select(object_pick(col("obj"), col("k"), lit("name")).alias("result")).show()
-------------------
|"RESULT"         |
-------------------
|{                |
|  "age": 21,     |
|  "name": "Joe"  |
|}                |
|{                |
|  "age": 26,     |
|  "name": "Jay"  |
|}                |
-------------------

-- Example 22135
>>> df = session.create_dataframe(['abc', 'Β', "X'A1B2'"], schema=["a"])
>>> df.select(octet_length(col("a")).alias("octet_length")).collect()
[Row(OCTET_LENGTH=3), Row(OCTET_LENGTH=2), Row(OCTET_LENGTH=7)]

-- Example 22136
>>> from snowflake.snowpark.types import PandasSeriesType, PandasDataFrameType, IntegerType
>>> add_one_df_pandas_udf = pandas_udf(
...     lambda df: df[0] + df[1] + 1,
...     return_type=PandasSeriesType(IntegerType()),
...     input_types=[PandasDataFrameType([IntegerType(), IntegerType()])]
... )
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.select(add_one_df_pandas_udf("a", "b").alias("result")).order_by("result").show()
------------
|"RESULT"  |
------------
|4         |
|8         |
------------

-- Example 22137
>>> from snowflake.snowpark.types import PandasSeriesType, PandasDataFrameType, IntegerType
>>> @pandas_udf(
...     return_type=PandasSeriesType(IntegerType()),
...     input_types=[PandasDataFrameType([IntegerType(), IntegerType()])],
... )
... def add_one_df_pandas_udf(df):
...     return df[0] + df[1] + 1
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.select(add_one_df_pandas_udf("a", "b").alias("result")).order_by("result").show()
------------
|"RESULT"  |
------------
|4         |
|8         |
------------

-- Example 22138
>>> from snowflake.snowpark.types import PandasSeriesType, PandasDataFrameType, IntegerType
>>> class multiply:
...     def __init__(self):
...         self.multiplier = 10
...     def end_partition(self, df):
...         df.col1 = df.col1*self.multiplier
...         df.col2 = df.col2*self.multiplier
...         yield df
>>> multiply_udtf = pandas_udtf(
...     multiply,
...     output_schema=PandasDataFrameType([StringType(), IntegerType(), FloatType()], ["id_", "col1_", "col2_"]),
...     input_types=[PandasDataFrameType([StringType(), IntegerType(), FloatType()])],
...     input_names=['"id"', '"col1"', '"col2"']
... )
>>> df = session.create_dataframe([['x', 3, 35.9],['x', 9, 20.5]], schema=["id", "col1", "col2"])
>>> df.select(multiply_udtf("id", "col1", "col2").over(partition_by=["id"])).sort("col1_").show()
-----------------------------
|"ID_"  |"COL1_"  |"COL2_"  |
-----------------------------
|x      |30       |359.0    |
|x      |90       |205.0    |
-----------------------------

-- Example 22139
>>> @pandas_udtf(
... output_schema=PandasDataFrameType([StringType(), IntegerType(), FloatType()], ["id_", "col1_", "col2_"]),
... input_types=[PandasDataFrameType([StringType(), IntegerType(), FloatType()])],
... input_names=['"id"', '"col1"', '"col2"']
... )
... class _multiply:
...     def __init__(self):
...         self.multiplier = 10
...     def end_partition(self, df):
...         df.col1 = df.col1*self.multiplier
...         df.col2 = df.col2*self.multiplier
...         yield df
>>> df.select(multiply_udtf("id", "col1", "col2").over(partition_by=["id"])).sort("col1_").show()
-----------------------------
|"ID_"  |"COL1_"  |"COL2_"  |
-----------------------------
|x      |30       |359.0    |
|x      |90       |205.0    |
-----------------------------

-- Example 22140
>>> df = session.create_dataframe([['{"key": "1"}']], schema=["a"])
>>> df.select(parse_json(df["a"]).alias("result")).show()
----------------
|"RESULT"      |
----------------
|{             |
|  "key": "1"  |
|}             |
----------------

-- Example 22141
>>> df = session.sql(
...     "select (column1) as v from values ('<t1>foo<t2>bar</t2><t3></t3></t1>'), "
...     "('<t1></t1>')"
... )
>>> df.select(parse_xml("v").alias("result")).show()
------------------
|"RESULT"        |
------------------
|<t1>            |
|  foo           |
|  <t2>bar</t2>  |
|  <t3></t3>     |
|</t1>           |
|<t1></t1>       |
------------------

-- Example 22142
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
>>> df.select(percent_rank().over(Window.partition_by("x").order_by(col("y"))).alias("result")).show()
------------
|"RESULT"  |
------------
|0.0       |
|0.5       |
|0.5       |
|0.0       |
|0.0       |
------------

-- Example 22143
>>> df = session.create_dataframe([0,1,2,3,4,5,6,7,8,9], schema=["a"])
>>> df.select(approx_percentile("a", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|4.5       |
------------

-- Example 22144
>>> df = session.create_dataframe([
...     (0, 0), (0, 10), (0, 20), (0, 30), (0, 40),
...     (1, 10), (1, 20), (2, 10), (2, 20), (2, 25),
...     (2, 30), (3, 60), (4, None)
... ], schema=["k", "v"])
>>> df.group_by("k").agg(percentile_cont(0.25).within_group("v").as_("percentile")).sort("k").collect()
[Row(K=0, PERCENTILE=Decimal('10.000')), Row(K=1, PERCENTILE=Decimal('12.500')), Row(K=2, PERCENTILE=Decimal('17.500')), Row(K=3, PERCENTILE=Decimal('60.000')), Row(K=4, PERCENTILE=None)]

-- Example 22145
>>> df = session.create_dataframe([['an', 'banana'], ['nan', 'banana']], schema=["expr1", "expr2"])
>>> df.select(position(df["expr1"], df["expr2"], 3).alias("position")).collect()
[Row(POSITION=4), Row(POSITION=3)]

-- Example 22146
>>> df = session.create_dataframe([[2, 3], [3, 4]], schema=["x", "y"])
>>> df.select(pow(col("x"), col("y")).alias("result")).show()
------------
|"RESULT"  |
------------
|8.0       |
|81.0      |
------------

-- Example 22147
>>> import datetime
>>> df = session.create_dataframe([
...     (datetime.date.fromisoformat("2020-08-01"), "mo"),
...     (datetime.date.fromisoformat("2020-12-01"), "we"),
... ], schema=["a", "b"])
>>> df.select(previous_day("a", col("b"))).collect()
[Row(PREVIOUS_DAY("A", "B")=datetime.date(2020, 7, 27)), Row(PREVIOUS_DAY("A", "B")=datetime.date(2020, 11, 25))]
>>> df.select(previous_day("a", "fr")).collect()
[Row(PREVIOUS_DAY("A", 'FR')=datetime.date(2020, 7, 31)), Row(PREVIOUS_DAY("A", 'FR')=datetime.date(2020, 11, 27))]

-- Example 22148
>>> df = session.create_dataframe([["Alice", "Monday"], ["Bob", "Tuesday"]], schema=["name", "day"])
>>> df.select(prompt("Hello, {0}. Today is {1}", col("name"), col("day")).alias("greeting")).show()
--------------------------------------------
|"GREETING"                                |
--------------------------------------------
|{                                         |
|  "args": [                               |
|    "Alice",                              |
|    "Monday"                              |
|  ],                                      |
|  "template": "Hello, {0}. Today is {1}"  |
|}                                         |
|{                                         |
|  "args": [                               |
|    "Bob",                                |
|    "Tuesday"                             |
|  ],                                      |
|  "template": "Hello, {0}. Today is {1}"  |
|}                                         |
--------------------------------------------



This function or method is in private preview since 1.31.0.

-- Example 22149
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(quarter("a")).collect()
[Row(QUARTER("A")=2), Row(QUARTER("A")=3)]

-- Example 22150
>>> df = session.create_dataframe([[1.111], [2.222], [3.333]], schema=["a"])
>>> df.select(radians(col("a")).cast("number(38, 5)").alias("result")).show()
------------
|"RESULT"  |
------------
|0.01939   |
|0.03878   |
|0.05817   |
------------

-- Example 22151
>>> df = session.create_dataframe([1,2,3], schema=["seed"])
>>> df.select(randn("seed").alias("randn")).collect()
[Row(RANDN=-1.143416214223267), Row(RANDN=-0.78469958830255), Row(RANDN=-0.365971322006404)]
>>> df.select(randn().alias("randn")).collect()

-- Example 22152
>>> df = session.sql("select 1")
>>> df = df.select(random(123).alias("result"))

-- Example 22153
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
>>> df.select(rank().over(Window.partition_by(col("X")).order_by(col("Y"))).alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|2         |
|2         |
|1         |
|1         |
------------

-- Example 22154
>>> df = session.sql("select * from values('apple'),('banana'),('peach') as T(a)")
>>> df.select(regexp_count(col("a"), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|3         |
|1         |
------------

