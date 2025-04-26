-- Example 33070
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(mean("x").as_("x")).collect()
[Row(X=Decimal('3.600000'))]

-- Example 33071
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(median("x").as_("x")).collect()
[Row(X=Decimal('3.000'))]

-- Example 33072
>>> df = session.create_dataframe([1, 3, 10, 1, 3], schema=["x"])
>>> df.select(min("x").as_("x")).collect()
[Row(X=1)]

-- Example 33073
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

-- Example 33074
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(minute("a")).collect()
[Row(MINUTE("A")=11), Row(MINUTE("A")=30)]

-- Example 33075
>>> df = session.create_dataframe([1, 3, 10, 1, 4], schema=["x"])
>>> df.select(mode("x").as_("x")).collect()
[Row(X=1)]

-- Example 33076
>>> df = session.generator(seq8(0), rowcount=3)
>>> df.collect()
[Row(SEQ8(0)=0), Row(SEQ8(0)=1), Row(SEQ8(0)=2)]

-- Example 33077
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(month("a")).collect()
[Row(MONTH("A")=5), Row(MONTH("A")=8)]

-- Example 33078
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(monthname("a")).collect()
[Row(MONTHNAME("A")='May'), Row(MONTHNAME("A")='Aug')]

-- Example 33079
>>> import datetime
>>> df = session.create_dataframe([[
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ]], schema=["a", "b"])
>>> df.select(months_between("a", "b")).collect()
[Row(MONTHS_BETWEEN("A", "B")=Decimal('-3.629452'))]

-- Example 33080
>>> df = session.create_dataframe([[1]], schema=["a"])
>>> df.select(negate(col("a").alias("result"))).show()
------------
|"RESULT"  |
------------
|-1        |
------------

-- Example 33081
>>> import datetime
>>> df = session.create_dataframe([
...     (datetime.date.fromisoformat("2020-08-01"), "mo"),
...     (datetime.date.fromisoformat("2020-12-01"), "we"),
... ], schema=["a", "b"])
>>> df.select(next_day("a", col("b"))).collect()
[Row(NEXT_DAY("A", "B")=datetime.date(2020, 8, 3)), Row(NEXT_DAY("A", "B")=datetime.date(2020, 12, 2))]
>>> df.select(next_day("a", "fr")).collect()
[Row(NEXT_DAY("A", 'FR')=datetime.date(2020, 8, 7)), Row(NEXT_DAY("A", 'FR')=datetime.date(2020, 12, 4))]

-- Example 33082
>>> df = session.create_dataframe([1,2,3], schema=["a"])
>>> df.select(normal(0, 1, "a").alias("normal")).collect()
[Row(NORMAL=-1.143416214223267), Row(NORMAL=-0.78469958830255), Row(NORMAL=-0.365971322006404)]

-- Example 33083
>>> df = session.create_dataframe([[True]], schema=["a"])
>>> df.select(not_(col("a").alias("result"))).show()
------------
|"RESULT"  |
------------
|False     |
------------

-- Example 33084
>>> from snowflake.snowpark.window import Window
>>> window = Window.partition_by("column1").order_by("column2")
>>> df = session.create_dataframe([[1, 10], [1, 11], [2, 20], [2, 21]], schema=["column1", "column2"])
>>> df.select(df["column1"], df["column2"], nth_value(df["column2"], 2).over(window).as_("column2_2nd")).collect()
[Row(COLUMN1=1, COLUMN2=10, COLUMN2_2ND=11), Row(COLUMN1=1, COLUMN2=11, COLUMN2_2ND=11), Row(COLUMN1=2, COLUMN2=20, COLUMN2_2ND=21), Row(COLUMN1=2, COLUMN2=21, COLUMN2_2ND=21)]

-- Example 33085
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

-- Example 33086
>>> df = session.create_dataframe([0, 1], schema=["a"])
>>> df.select(nullifzero(df["a"]).alias("result")).collect()
[Row(RESULT=None), Row(RESULT=1)]

-- Example 33087
>>> df = session.create_dataframe([("a", "b"), ("c", None), (None, "d"), (None, None)], schema=["e1", "e2"])
>>> df.select(ifnull(df["e1"], df["e2"]).alias("result")).collect()
[Row(RESULT='a'), Row(RESULT='c'), Row(RESULT='d'), Row(RESULT=None)]

-- Example 33088
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

-- Example 33089
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

-- Example 33090
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

-- Example 33091
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

-- Example 33092
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

-- Example 33093
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

-- Example 33094
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

-- Example 33095
>>> df = session.create_dataframe(['abc', 'Β', "X'A1B2'"], schema=["a"])
>>> df.select(octet_length(col("a")).alias("octet_length")).collect()
[Row(OCTET_LENGTH=3), Row(OCTET_LENGTH=2), Row(OCTET_LENGTH=7)]

-- Example 33096
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

-- Example 33097
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

-- Example 33098
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

-- Example 33099
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

-- Example 33100
>>> df = session.create_dataframe([['{"key": "1"}']], schema=["a"])
>>> df.select(parse_json(df["a"]).alias("result")).show()
----------------
|"RESULT"      |
----------------
|{             |
|  "key": "1"  |
|}             |
----------------

-- Example 33101
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

-- Example 33102
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

-- Example 33103
>>> df = session.create_dataframe([0,1,2,3,4,5,6,7,8,9], schema=["a"])
>>> df.select(approx_percentile("a", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|4.5       |
------------

-- Example 33104
>>> df = session.create_dataframe([
...     (0, 0), (0, 10), (0, 20), (0, 30), (0, 40),
...     (1, 10), (1, 20), (2, 10), (2, 20), (2, 25),
...     (2, 30), (3, 60), (4, None)
... ], schema=["k", "v"])
>>> df.group_by("k").agg(percentile_cont(0.25).within_group("v").as_("percentile")).sort("k").collect()
[Row(K=0, PERCENTILE=Decimal('10.000')), Row(K=1, PERCENTILE=Decimal('12.500')), Row(K=2, PERCENTILE=Decimal('17.500')), Row(K=3, PERCENTILE=Decimal('60.000')), Row(K=4, PERCENTILE=None)]

-- Example 33105
>>> df = session.create_dataframe([['an', 'banana'], ['nan', 'banana']], schema=["expr1", "expr2"])
>>> df.select(position(df["expr1"], df["expr2"], 3).alias("position")).collect()
[Row(POSITION=4), Row(POSITION=3)]

-- Example 33106
>>> df = session.create_dataframe([[2, 3], [3, 4]], schema=["x", "y"])
>>> df.select(pow(col("x"), col("y")).alias("result")).show()
------------
|"RESULT"  |
------------
|8.0       |
|81.0      |
------------

-- Example 33107
>>> import datetime
>>> df = session.create_dataframe([
...     (datetime.date.fromisoformat("2020-08-01"), "mo"),
...     (datetime.date.fromisoformat("2020-12-01"), "we"),
... ], schema=["a", "b"])
>>> df.select(previous_day("a", col("b"))).collect()
[Row(PREVIOUS_DAY("A", "B")=datetime.date(2020, 7, 27)), Row(PREVIOUS_DAY("A", "B")=datetime.date(2020, 11, 25))]
>>> df.select(previous_day("a", "fr")).collect()
[Row(PREVIOUS_DAY("A", 'FR')=datetime.date(2020, 7, 31)), Row(PREVIOUS_DAY("A", 'FR')=datetime.date(2020, 11, 27))]

-- Example 33108
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

-- Example 33109
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(quarter("a")).collect()
[Row(QUARTER("A")=2), Row(QUARTER("A")=3)]

-- Example 33110
>>> df = session.create_dataframe([[1.111], [2.222], [3.333]], schema=["a"])
>>> df.select(radians(col("a")).cast("number(38, 5)").alias("result")).show()
------------
|"RESULT"  |
------------
|0.01939   |
|0.03878   |
|0.05817   |
------------

-- Example 33111
>>> df = session.create_dataframe([1,2,3], schema=["seed"])
>>> df.select(randn("seed").alias("randn")).collect()
[Row(RANDN=-1.143416214223267), Row(RANDN=-0.78469958830255), Row(RANDN=-0.365971322006404)]
>>> df.select(randn().alias("randn")).collect()

-- Example 33112
>>> df = session.sql("select 1")
>>> df = df.select(random(123).alias("result"))

-- Example 33113
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

-- Example 33114
>>> df = session.sql("select * from values('apple'),('banana'),('peach') as T(a)")
>>> df.select(regexp_count(col("a"), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|3         |
|1         |
------------

-- Example 33115
>>> from snowflake.snowpark.functions import regexp_extract
>>> df = session.createDataFrame([["id_20_30", 10], ["id_40_50", 30]], ["id", "age"])
>>> df.select(regexp_extract("id", r"(\d+)", 1).alias("RES")).show()
---------
|"RES"  |
---------
|20     |
|40     |
---------

-- Example 33116
>>> df = session.create_dataframe(
...     [["It was the best of times, it was the worst of times"]], schema=["a"]
... )
>>> df.select(regexp_replace(col("a"), lit("( ){1,}"), lit("")).alias("result")).show()
--------------------------------------------
|"RESULT"                                  |
--------------------------------------------
|Itwasthebestoftimes,itwastheworstoftimes  |
--------------------------------------------

-- Example 33117
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.groupBy("v").agg(regr_avgx(df["v"], df["v2"]).alias("regr_avgx")).collect()
[Row(V=10, REGR_AVGX=11.0), Row(V=20, REGR_AVGX=22.0), Row(V=25, REGR_AVGX=None), Row(V=30, REGR_AVGX=35.0)]

-- Example 33118
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df = df.group_by("v").agg(regr_avgy(df["v"], df["v2"]).alias("regr_avgy"))
>>> df.collect()
[Row(V=10, REGR_AVGY=10.0), Row(V=20, REGR_AVGY=20.0), Row(V=25, REGR_AVGY=None), Row(V=30, REGR_AVGY=30.0)]

-- Example 33119
>>> df = session.create_dataframe([[1, 10, 11], [1, 20, 22], [1, 25, None], [2, 30, 35]], schema=["k", "v", "v2"])
>>> df.group_by("k").agg(regr_count(col("v"), col("v2")).alias("regr_count")).collect()
[Row(K=1, REGR_COUNT=2), Row(K=2, REGR_COUNT=1)]

-- Example 33120
>>> df = session.create_dataframe([[10, 11], [20, 22], [30, 35]], schema=["v", "v2"])
>>> df.groupBy().agg(regr_intercept(df["v"], df["v2"]).alias("regr_intercept")).collect()
[Row(REGR_INTERCEPT=1.1547344110854496)]

-- Example 33121
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.groupBy("v").agg(regr_r2(col("v"), col("v2")).alias("regr_r2")).collect()
[Row(V=10, REGR_R2=None), Row(V=20, REGR_R2=None), Row(V=25, REGR_R2=None), Row(V=30, REGR_R2=None)]

-- Example 33122
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df = df.group_by("v").agg(regr_slope(df["v2"], df["v"]).alias("regr_slope"))
>>> df.collect()
[Row(V=10, REGR_SLOPE=None), Row(V=20, REGR_SLOPE=None), Row(V=25, REGR_SLOPE=None), Row(V=30, REGR_SLOPE=None)]

-- Example 33123
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.group_by("v").agg(regr_sxx(col("v"), col("v2")).alias("regr_sxx")).collect()
[Row(V=10, REGR_SXX=0.0), Row(V=20, REGR_SXX=0.0), Row(V=25, REGR_SXX=None), Row(V=30, REGR_SXX=0.0)]

-- Example 33124
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df = df.filter(df["v2"].is_not_null())
>>> df.group_by("v").agg(regr_sxy(df["v"], df["v2"]).alias("regr_sxy")).collect()
[Row(V=10, REGR_SXY=0.0), Row(V=20, REGR_SXY=0.0), Row(V=30, REGR_SXY=0.0)]

-- Example 33125
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.groupBy("v").agg(regr_syy(df["v"], df["v2"]).alias("regr_syy")).collect()
[Row(V=10, REGR_SYY=0.0), Row(V=20, REGR_SYY=0.0), Row(V=25, REGR_SYY=None), Row(V=30, REGR_SYY=0.0)]

-- Example 33126
>>> df = session.create_dataframe([["a"], ["b"], ["c"]], schema=["a"])
>>> df.select(repeat(col("a"), 3).alias("result")).show()
------------
|"RESULT"  |
------------
|aaa       |
|bbb       |
|ccc       |
------------

-- Example 33127
>>> df = session.create_dataframe([["apple"], ["apple pie"], ["apple juice"]], schema=["a"])
>>> df.select(replace(col("a"), "apple", "orange").alias("result")).show()
----------------
|"RESULT"      |
----------------
|orange        |
|orange pie    |
|orange juice  |
----------------

-- Example 33128
>>> df = session.create_dataframe([["abc"], ["def"]], schema=["a"])
>>> df.select(right(col("a"), 2).alias("result")).show()
------------
|"RESULT"  |
------------
|bc        |
|ef        |
------------

-- Example 33129
>>> df = session.create_dataframe([[1.11], [2.22], [3.33]], schema=["a"])
>>> df.select(round(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|1.0       |
|2.0       |
|3.0       |
------------

-- Example 33130
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
>>> df.select(row_number().over(Window.partition_by(col("X")).order_by(col("Y"))).alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|2         |
|3         |
|1         |
|2         |
------------

-- Example 33131
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([["a"], ["b"], ["c"]], schema=["a"])
>>> df.select(rpad(col("a"), 3, lit("k")).alias("result")).show()
------------
|"RESULT"  |
------------
|akk       |
|bkk       |
|ckk       |
------------

-- Example 33132
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

-- Example 33133
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(second("a")).collect()
[Row(SECOND("A")=20), Row(SECOND("A")=5)]

-- Example 33134
>>> df = session.generator(seq1(0), rowcount=3)
>>> df.collect()
[Row(SEQ1(0)=0), Row(SEQ1(0)=1), Row(SEQ1(0)=2)]

-- Example 33135
>>> df = session.generator(seq2(0), rowcount=3)
>>> df.collect()
[Row(SEQ2(0)=0), Row(SEQ2(0)=1), Row(SEQ2(0)=2)]

-- Example 33136
>>> df = session.generator(seq4(0), rowcount=3)
>>> df.collect()
[Row(SEQ4(0)=0), Row(SEQ4(0)=1), Row(SEQ4(0)=2)]

