-- Example 22155
>>> from snowflake.snowpark.functions import regexp_extract
>>> df = session.createDataFrame([["id_20_30", 10], ["id_40_50", 30]], ["id", "age"])
>>> df.select(regexp_extract("id", r"(\d+)", 1).alias("RES")).show()
---------
|"RES"  |
---------
|20     |
|40     |
---------

-- Example 22156
>>> df = session.create_dataframe(
...     [["It was the best of times, it was the worst of times"]], schema=["a"]
... )
>>> df.select(regexp_replace(col("a"), lit("( ){1,}"), lit("")).alias("result")).show()
--------------------------------------------
|"RESULT"                                  |
--------------------------------------------
|Itwasthebestoftimes,itwastheworstoftimes  |
--------------------------------------------

-- Example 22157
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.groupBy("v").agg(regr_avgx(df["v"], df["v2"]).alias("regr_avgx")).collect()
[Row(V=10, REGR_AVGX=11.0), Row(V=20, REGR_AVGX=22.0), Row(V=25, REGR_AVGX=None), Row(V=30, REGR_AVGX=35.0)]

-- Example 22158
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df = df.group_by("v").agg(regr_avgy(df["v"], df["v2"]).alias("regr_avgy"))
>>> df.collect()
[Row(V=10, REGR_AVGY=10.0), Row(V=20, REGR_AVGY=20.0), Row(V=25, REGR_AVGY=None), Row(V=30, REGR_AVGY=30.0)]

-- Example 22159
>>> df = session.create_dataframe([[1, 10, 11], [1, 20, 22], [1, 25, None], [2, 30, 35]], schema=["k", "v", "v2"])
>>> df.group_by("k").agg(regr_count(col("v"), col("v2")).alias("regr_count")).collect()
[Row(K=1, REGR_COUNT=2), Row(K=2, REGR_COUNT=1)]

-- Example 22160
>>> df = session.create_dataframe([[10, 11], [20, 22], [30, 35]], schema=["v", "v2"])
>>> df.groupBy().agg(regr_intercept(df["v"], df["v2"]).alias("regr_intercept")).collect()
[Row(REGR_INTERCEPT=1.1547344110854496)]

-- Example 22161
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.groupBy("v").agg(regr_r2(col("v"), col("v2")).alias("regr_r2")).collect()
[Row(V=10, REGR_R2=None), Row(V=20, REGR_R2=None), Row(V=25, REGR_R2=None), Row(V=30, REGR_R2=None)]

-- Example 22162
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df = df.group_by("v").agg(regr_slope(df["v2"], df["v"]).alias("regr_slope"))
>>> df.collect()
[Row(V=10, REGR_SLOPE=None), Row(V=20, REGR_SLOPE=None), Row(V=25, REGR_SLOPE=None), Row(V=30, REGR_SLOPE=None)]

-- Example 22163
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.group_by("v").agg(regr_sxx(col("v"), col("v2")).alias("regr_sxx")).collect()
[Row(V=10, REGR_SXX=0.0), Row(V=20, REGR_SXX=0.0), Row(V=25, REGR_SXX=None), Row(V=30, REGR_SXX=0.0)]

-- Example 22164
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df = df.filter(df["v2"].is_not_null())
>>> df.group_by("v").agg(regr_sxy(df["v"], df["v2"]).alias("regr_sxy")).collect()
[Row(V=10, REGR_SXY=0.0), Row(V=20, REGR_SXY=0.0), Row(V=30, REGR_SXY=0.0)]

-- Example 22165
>>> df = session.create_dataframe([[10, 11], [20, 22], [25, None], [30, 35]], schema=["v", "v2"])
>>> df.groupBy("v").agg(regr_syy(df["v"], df["v2"]).alias("regr_syy")).collect()
[Row(V=10, REGR_SYY=0.0), Row(V=20, REGR_SYY=0.0), Row(V=25, REGR_SYY=None), Row(V=30, REGR_SYY=0.0)]

-- Example 22166
>>> df = session.create_dataframe([["a"], ["b"], ["c"]], schema=["a"])
>>> df.select(repeat(col("a"), 3).alias("result")).show()
------------
|"RESULT"  |
------------
|aaa       |
|bbb       |
|ccc       |
------------

-- Example 22167
>>> df = session.create_dataframe([["apple"], ["apple pie"], ["apple juice"]], schema=["a"])
>>> df.select(replace(col("a"), "apple", "orange").alias("result")).show()
----------------
|"RESULT"      |
----------------
|orange        |
|orange pie    |
|orange juice  |
----------------

-- Example 22168
>>> df = session.create_dataframe([["abc"], ["def"]], schema=["a"])
>>> df.select(right(col("a"), 2).alias("result")).show()
------------
|"RESULT"  |
------------
|bc        |
|ef        |
------------

-- Example 22169
>>> df = session.create_dataframe([[1.11], [2.22], [3.33]], schema=["a"])
>>> df.select(round(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|1.0       |
|2.0       |
|3.0       |
------------

-- Example 22170
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

-- Example 22171
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

-- Example 22172
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

-- Example 22173
>>> import datetime
>>> df = session.create_dataframe([
...     datetime.datetime.strptime("2020-05-01 13:11:20.000", "%Y-%m-%d %H:%M:%S.%f"),
...     datetime.datetime.strptime("2020-08-21 01:30:05.000", "%Y-%m-%d %H:%M:%S.%f")
... ], schema=["a"])
>>> df.select(second("a")).collect()
[Row(SECOND("A")=20), Row(SECOND("A")=5)]

-- Example 22174
>>> df = session.generator(seq1(0), rowcount=3)
>>> df.collect()
[Row(SEQ1(0)=0), Row(SEQ1(0)=1), Row(SEQ1(0)=2)]

-- Example 22175
>>> df = session.generator(seq2(0), rowcount=3)
>>> df.collect()
[Row(SEQ2(0)=0), Row(SEQ2(0)=1), Row(SEQ2(0)=2)]

-- Example 22176
>>> df = session.generator(seq4(0), rowcount=3)
>>> df.collect()
[Row(SEQ4(0)=0), Row(SEQ4(0)=1), Row(SEQ4(0)=2)]

-- Example 22177
>>> df = session.generator(seq8(0), rowcount=3)
>>> df.collect()
[Row(SEQ8(0)=0), Row(SEQ8(0)=1), Row(SEQ8(0)=2)]

-- Example 22178
>>> from snowflake.snowpark import Row
>>> df1 = session.create_dataframe([(-2, 2)], ["a", "b"])
>>> df1.select(sequence("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  -2,     |
|  -1,     |
|  0,      |
|  1,      |
|  2       |
|]         |
------------

>>> df2 = session.create_dataframe([(4, -4, -2)], ["a", "b", "c"])
>>> df2.select(sequence("a", "b", "c").alias("result")).show()
------------
|"RESULT"  |
------------
|[         |
|  4,      |
|  2,      |
|  0,      |
|  -2,     |
|  -4      |
|]         |
------------

-- Example 22179
>>> df = session.create_dataframe(["a", "b"], schema=["col"]).select(sha1("col"))
>>> df.collect()
[Row(SHA1("COL")='86f7e437faa5a7fce15d1ddcb9eaeaea377667b8'), Row(SHA1("COL")='e9d71f5ee7c92d6dc9e92ffdad17b8bd49418f98')]

-- Example 22180
>>> df = session.create_dataframe(["a", "b"], schema=["col"]).select(sha2("col", 256))
>>> df.collect()
[Row(SHA2("COL", 256)='ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb'), Row(SHA2("COL", 256)='3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d')]

-- Example 22181
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.generator(seq1(0), rowcount=3).select(sin(seq1(0)).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (SIN(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.0000')), Row(CAST (SIN(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.8415')), Row(CAST (SIN(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.9093'))]

-- Example 22182
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.generator(seq1(0), rowcount=3).select(sinh(seq1(0)).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (SINH(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.0000')), Row(CAST (SINH(SEQ1(0)) AS NUMBER(38, 4))=Decimal('1.1752')), Row(CAST (SINH(SEQ1(0)) AS NUMBER(38, 4))=Decimal('3.6269'))]

-- Example 22183
>>> df = session.create_dataframe([([1,2,3], {'a': 1, 'b': 2}, 3)], ['col1', 'col2', 'col3'])
>>> df.select(size(df.col1), size(df.col2), size(df.col3)).show()
----------------------------------------------------------
|"SIZE(""COL1"")"  |"SIZE(""COL2"")"  |"SIZE(""COL3"")"  |
----------------------------------------------------------
|3                 |2                 |NULL              |
----------------------------------------------------------

-- Example 22184
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe(
...     [10, 10, 20, 25, 30],
...     schema=["a"]
... ).select(skew("a").cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (SKEW("A") AS NUMBER(38, 4))=Decimal('0.0524'))]

-- Example 22185
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

-- Example 22186
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

-- Example 22187
>>> df = session.create_dataframe(["Marsha", "Marcia"], schema=["V"]).select(soundex(col("V")))
>>> df.collect()
[Row(SOUNDEX("V")='M620'), Row(SOUNDEX("V")='M620')]

-- Example 22188
>>> df = session.create_dataframe(
...     [["many-many-words", "-"], ["hello--hello", "--"]],
...     schema=["V", "D"],
... ).select(split(col("V"), col("D")))
>>> df.show()
-------------------------
|"SPLIT(""V"", ""D"")"  |
-------------------------
|[                      |
|  "many",              |
|  "many",              |
|  "words"              |
|]                      |
|[                      |
|  "hello",             |
|  "hello"              |
|]                      |
-------------------------

-- Example 22189
>>> df = session.create_dataframe([["many-many-words"],["hello-hi-hello"]],schema=["V"],)
>>> df.select(split(col("V"), lit("-"))).show()
-----------------------
|"SPLIT(""V"", '-')"  |
-----------------------
|[                    |
|  "many",            |
|  "many",            |
|  "words"            |
|]                    |
|[                    |
|  "hello",           |
|  "hi",              |
|  "hello"            |
|]                    |
-----------------------

-- Example 22190
>>> from snowflake.snowpark.types import IntegerType
>>> @sproc(return_type=IntegerType(), input_types=[IntegerType(), IntegerType()], packages=["snowflake-snowpark-python"])
... def add_sp(session_, x, y):
...     return session_.sql(f"SELECT {x} + {y}").collect()[0][0]
...
>>> add_sp(1, 1)
2

-- Example 22191
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df.select(sql_expr("a + 1").as_("c"), sql_expr("a = 1").as_("d")).collect()  # use SQL expression
[Row(C=2, D=True), Row(C=4, D=False)]

-- Example 22192
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(sqrt(col("N")))
>>> df.collect()
[Row(SQRT("N")=2.0), Row(SQRT("N")=3.0)]

-- Example 22193
>>> df = session.create_dataframe(
...     [["abc", "a"], ["abc", "s"]],
...     schema=["S", "P"],
... ).select(startswith(col("S"), col("P")))
>>> df.collect()
[Row(STARTSWITH("S", "P")=True), Row(STARTSWITH("S", "P")=False)]

-- Example 22194
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(stddev(col("N")).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (STDDEV("N") AS NUMBER(38, 4))=Decimal('3.5355'))]

-- Example 22195
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(stddev_pop(col("N")))
>>> df.collect()
[Row(STDDEV_POP("N")=2.5)]

-- Example 22196
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(stddev_samp(col("N")).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (STDDEV_SAMP("N") AS NUMBER(38, 4))=Decimal('3.5355'))]

-- Example 22197
>>> df = session.create_dataframe(
...     ["null", "1"],
...     schema=["S"],
... ).select(strip_null_value(parse_json(col("S"))).as_("B")).where(
...     sql_expr("B is null")
... )
>>> df.collect()
[Row(B=None)]

-- Example 22198
>>> df = session.create_dataframe(
...     [["a.b.c", "."], ["1,2.3", ","]],
...     schema=["text", "delimiter"],
... )
>>> df.select(strtok_to_array("text", "delimiter").alias("TIME_FROM_PARTS")).collect()
[Row(TIME_FROM_PARTS='[\n  "a",\n  "b",\n  "c"\n]'), Row(TIME_FROM_PARTS='[\n  "1",\n  "2.3"\n]')]

-- Example 22199
>>> from snowflake.snowpark.functions import struct
>>> df = session.createDataFrame([("Bob", 80), ("Alice", None)], ["name", "age"])
>>> res = df.select(struct("age", "name").alias("struct")).show()
---------------------
|"STRUCT"           |
---------------------
|{                  |
|  "age": 80,       |
|  "name": "Bob"    |
|}                  |
|{                  |
|  "age": null,     |
|  "name": "Alice"  |
|}                  |
---------------------

-- Example 22200
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 1, 1)).collect()
[Row(SUBSTRING("S", 1, 1)='a'), Row(SUBSTRING("S", 1, 1)='d')]

-- Example 22201
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 2)).collect()
[Row(SUBSTRING("S", 2)='bc'), Row(SUBSTRING("S", 2)='ef')]

-- Example 22202
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 1, 1)).collect()
[Row(SUBSTRING("S", 1, 1)='a'), Row(SUBSTRING("S", 1, 1)='d')]

-- Example 22203
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 2)).collect()
[Row(SUBSTRING("S", 2)='bc'), Row(SUBSTRING("S", 2)='ef')]

-- Example 22204
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(sum(col("N")))
>>> df.collect()
[Row(SUM("N")=13)]

-- Example 22205
>>> df = session.create_dataframe([
...     [1, "Excellent"],
...     [1, "Excellent"],
...     [1, "Great"],
...     [1, "Mediocre"],
...     [2, "Terrible"],
...     [2, "Bad"],
... ], schema=["product_id", "review"])
>>> summary_df = df.select(summarize_agg(col("review")))
>>> summary_df.count()
1
>>> summary_df = df.group_by("product_id").agg(summarize_agg(col("review")))
>>> summary_df.count()
2


This function or method is in private preview since 1.29.0.

-- Example 22206
>>> df = session.create_dataframe(
...     [1, 2, None, 3],
...     schema=["N"],
... ).select(sum_distinct(col("N")))
>>> df.collect()
[Row(SUM( DISTINCT "N")=6)]

-- Example 22207
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(sysdate()).collect() is not None
True

-- Example 22208
>>> df = session.create_dataframe([(1,)], schema=["A"])
>>> df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> df.select(substr(system_reference("table", "my_table"), 1, 14).alias("identifier")).collect()
[Row(IDENTIFIER='ENT_REF_TABLE_')]

-- Example 22209
>>> from snowflake.snowpark.functions import lit
>>> split_to_table = table_function("split_to_table")
>>> session.table_function(split_to_table(lit("split words to table"), lit(" ")).over()).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 22210
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([0, 1], schema=["N"]).select(
...     tan(col("N")).cast(DecimalType(scale=4))
... )
>>> df.collect()
[Row(CAST (TAN("N") AS NUMBER(38, 4))=Decimal('0.0000')), Row(CAST (TAN("N") AS NUMBER(38, 4))=Decimal('1.5574'))]

-- Example 22211
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([0, 1], schema=["N"]).select(
...     tanh(col("N").cast(DecimalType(scale=4)))
... )
>>> df.collect()
[Row(TANH( CAST ("N" AS NUMBER(38, 4)))=0.0), Row(TANH( CAST ("N" AS NUMBER(38, 4)))=0.7615941559557649)]

-- Example 22212
>>> df = session.create_dataframe(
...     [[11, 11, 0, 987654321], [10, 10, 0, 987654321]],
...     schema=["hour", "minute", "second", "nanoseconds"],
... )
>>> df.select(time_from_parts(
...     "hour", "minute", "second", nanoseconds="nanoseconds"
... ).alias("TIME_FROM_PARTS")).collect()
[Row(TIME_FROM_PARTS=datetime.time(11, 11, 0, 987654)), Row(TIME_FROM_PARTS=datetime.time(10, 10, 0, 987654))]

-- Example 22213
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0], [2022, 3, 31, 11, 11, 0]],
...     schema=["year", "month", "day", "hour", "minute", "second"],
... )
>>> df.select(timestamp_from_parts(
...     "year", "month", "day", "hour", "minute", "second"
... ).alias("TIMESTAMP_FROM_PARTS")).collect()
[Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 22214
>>> df = session.create_dataframe(
...     [['2022-04-01', '11:11:00'], ['2022-03-31', '11:11:00']],
...     schema=["date", "time"]
... )
>>> df.select(
...     timestamp_from_parts(to_date("date"), to_time("time")
... ).alias("TIMESTAMP_FROM_PARTS")).collect()
[Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 22215
>>> import datetime
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0], [2022, 3, 31, 11, 11, 0]],
...     schema=["year", "month", "day", "hour", "minute", "second"],
... )
>>> df.select(timestamp_ltz_from_parts(
...     "year", "month", "day", "hour", "minute", "second"
... ).alias("TIMESTAMP_LTZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_LTZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11, tzinfo=<DstTzInfo 'America/Los_Angeles' PDT-1 day, 17:00:00 DST>)), Row(TIMESTAMP_LTZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11, tzinfo=<DstTzInfo 'America/Los_Angeles' PDT-1 day, 17:00:00 DST>))]

-- Example 22216
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0], [2022, 3, 31, 11, 11, 0]],
...     schema=["year", "month", "day", "hour", "minute", "second"],
... )
>>> df.select(timestamp_ntz_from_parts(
...     "year", "month", "day", "hour", "minute", "second"
... ).alias("TIMESTAMP_NTZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 22217
>>> df = session.create_dataframe(
...     [['2022-04-01', '11:11:00'], ['2022-03-31', '11:11:00']],
...     schema=["date", "time"]
... )
>>> df.select(
...     timestamp_ntz_from_parts(to_date("date"), to_time("time")
... ).alias("TIMESTAMP_NTZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 22218
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0, 'America/Los_Angeles'], [2022, 3, 31, 11, 11, 0, 'America/Los_Angeles']],
...     schema=["year", "month", "day", "hour", "minute", "second", "timezone"],
... )
>>> df.select(timestamp_tz_from_parts(
...     "year", "month", "day", "hour", "minute", "second", timezone="timezone"
... ).alias("TIMESTAMP_TZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_TZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11, tzinfo=pytz.FixedOffset(-420))), Row(TIMESTAMP_TZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11, tzinfo=pytz.FixedOffset(-420)))]

-- Example 22219
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df.select(to_array(col('a')).as_('ans')).collect()
[Row(ANS='[\n  1\n]'), Row(ANS='[\n  2\n]'), Row(ANS='[\n  3\n]'), Row(ANS='[\n  4\n]')]


>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3]), Row(a=None)])
>>> df.select(to_array(col('a')).as_('ans')).collect()
[Row(ANS='[\n  1,\n  2,\n  3\n]'), Row(ANS=None)]

-- Example 22220
>>> df = session.create_dataframe(['00', '67', '0312'], schema=['a'])
>>> df.select(to_binary(col('a')).as_('ans')).collect()
[Row(ANS=bytearray(b'\x00')), Row(ANS=bytearray(b'g')), Row(ANS=bytearray(b'\x03\x12'))]

>>> df = session.create_dataframe(['aGVsbG8=', 'd29ybGQ=', 'IQ=='], schema=['a'])
>>> df.select(to_binary(col('a'), 'BASE64').as_('ans')).collect()
[Row(ANS=bytearray(b'hello')), Row(ANS=bytearray(b'world')), Row(ANS=bytearray(b'!'))]

>>> df.select(to_binary(col('a'), 'UTF-8').as_('ans')).collect()
[Row(ANS=bytearray(b'aGVsbG8=')), Row(ANS=bytearray(b'd29ybGQ=')), Row(ANS=bytearray(b'IQ=='))]

-- Example 22221
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='1'), Row(ANS='2'), Row(ANS='3'), Row(ANS='4')]

