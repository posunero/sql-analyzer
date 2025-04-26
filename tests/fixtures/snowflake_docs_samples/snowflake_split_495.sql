-- Example 33137
>>> df = session.generator(seq8(0), rowcount=3)
>>> df.collect()
[Row(SEQ8(0)=0), Row(SEQ8(0)=1), Row(SEQ8(0)=2)]

-- Example 33138
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

-- Example 33139
>>> df = session.create_dataframe(["a", "b"], schema=["col"]).select(sha1("col"))
>>> df.collect()
[Row(SHA1("COL")='86f7e437faa5a7fce15d1ddcb9eaeaea377667b8'), Row(SHA1("COL")='e9d71f5ee7c92d6dc9e92ffdad17b8bd49418f98')]

-- Example 33140
>>> df = session.create_dataframe(["a", "b"], schema=["col"]).select(sha2("col", 256))
>>> df.collect()
[Row(SHA2("COL", 256)='ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb'), Row(SHA2("COL", 256)='3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d')]

-- Example 33141
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.generator(seq1(0), rowcount=3).select(sin(seq1(0)).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (SIN(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.0000')), Row(CAST (SIN(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.8415')), Row(CAST (SIN(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.9093'))]

-- Example 33142
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.generator(seq1(0), rowcount=3).select(sinh(seq1(0)).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (SINH(SEQ1(0)) AS NUMBER(38, 4))=Decimal('0.0000')), Row(CAST (SINH(SEQ1(0)) AS NUMBER(38, 4))=Decimal('1.1752')), Row(CAST (SINH(SEQ1(0)) AS NUMBER(38, 4))=Decimal('3.6269'))]

-- Example 33143
>>> df = session.create_dataframe([([1,2,3], {'a': 1, 'b': 2}, 3)], ['col1', 'col2', 'col3'])
>>> df.select(size(df.col1), size(df.col2), size(df.col3)).show()
----------------------------------------------------------
|"SIZE(""COL1"")"  |"SIZE(""COL2"")"  |"SIZE(""COL3"")"  |
----------------------------------------------------------
|3                 |2                 |NULL              |
----------------------------------------------------------

-- Example 33144
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe(
...     [10, 10, 20, 25, 30],
...     schema=["a"]
... ).select(skew("a").cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (SKEW("A") AS NUMBER(38, 4))=Decimal('0.0524'))]

-- Example 33145
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

-- Example 33146
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

-- Example 33147
>>> df = session.create_dataframe(["Marsha", "Marcia"], schema=["V"]).select(soundex(col("V")))
>>> df.collect()
[Row(SOUNDEX("V")='M620'), Row(SOUNDEX("V")='M620')]

-- Example 33148
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

-- Example 33149
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

-- Example 33150
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df.select(sql_expr("a + 1").as_("c"), sql_expr("a = 1").as_("d")).collect()  # use SQL expression
[Row(C=2, D=True), Row(C=4, D=False)]

-- Example 33151
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(sqrt(col("N")))
>>> df.collect()
[Row(SQRT("N")=2.0), Row(SQRT("N")=3.0)]

-- Example 33152
>>> df = session.create_dataframe(
...     [["abc", "a"], ["abc", "s"]],
...     schema=["S", "P"],
... ).select(startswith(col("S"), col("P")))
>>> df.collect()
[Row(STARTSWITH("S", "P")=True), Row(STARTSWITH("S", "P")=False)]

-- Example 33153
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(stddev(col("N")).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (STDDEV("N") AS NUMBER(38, 4))=Decimal('3.5355'))]

-- Example 33154
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(stddev_pop(col("N")))
>>> df.collect()
[Row(STDDEV_POP("N")=2.5)]

-- Example 33155
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(stddev_samp(col("N")).cast(DecimalType(scale=4)))
>>> df.collect()
[Row(CAST (STDDEV_SAMP("N") AS NUMBER(38, 4))=Decimal('3.5355'))]

-- Example 33156
>>> df = session.create_dataframe(
...     ["null", "1"],
...     schema=["S"],
... ).select(strip_null_value(parse_json(col("S"))).as_("B")).where(
...     sql_expr("B is null")
... )
>>> df.collect()
[Row(B=None)]

-- Example 33157
>>> df = session.create_dataframe(
...     [["a.b.c", "."], ["1,2.3", ","]],
...     schema=["text", "delimiter"],
... )
>>> df.select(strtok_to_array("text", "delimiter").alias("TIME_FROM_PARTS")).collect()
[Row(TIME_FROM_PARTS='[\n  "a",\n  "b",\n  "c"\n]'), Row(TIME_FROM_PARTS='[\n  "1",\n  "2.3"\n]')]

-- Example 33158
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

-- Example 33159
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 1, 1)).collect()
[Row(SUBSTRING("S", 1, 1)='a'), Row(SUBSTRING("S", 1, 1)='d')]

-- Example 33160
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 2)).collect()
[Row(SUBSTRING("S", 2)='bc'), Row(SUBSTRING("S", 2)='ef')]

-- Example 33161
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 1, 1)).collect()
[Row(SUBSTRING("S", 1, 1)='a'), Row(SUBSTRING("S", 1, 1)='d')]

-- Example 33162
>>> df = session.create_dataframe(
...     ["abc", "def"],
...     schema=["S"],
... )
>>> df.select(substring(col("S"), 2)).collect()
[Row(SUBSTRING("S", 2)='bc'), Row(SUBSTRING("S", 2)='ef')]

-- Example 33163
>>> df = session.create_dataframe(
...     [4, 9],
...     schema=["N"],
... ).select(sum(col("N")))
>>> df.collect()
[Row(SUM("N")=13)]

-- Example 33164
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

-- Example 33165
>>> df = session.create_dataframe(
...     [1, 2, None, 3],
...     schema=["N"],
... ).select(sum_distinct(col("N")))
>>> df.collect()
[Row(SUM( DISTINCT "N")=6)]

-- Example 33166
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(sysdate()).collect() is not None
True

-- Example 33167
>>> df = session.create_dataframe([(1,)], schema=["A"])
>>> df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> df.select(substr(system_reference("table", "my_table"), 1, 14).alias("identifier")).collect()
[Row(IDENTIFIER='ENT_REF_TABLE_')]

-- Example 33168
>>> from snowflake.snowpark.functions import lit
>>> split_to_table = table_function("split_to_table")
>>> session.table_function(split_to_table(lit("split words to table"), lit(" ")).over()).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 33169
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([0, 1], schema=["N"]).select(
...     tan(col("N")).cast(DecimalType(scale=4))
... )
>>> df.collect()
[Row(CAST (TAN("N") AS NUMBER(38, 4))=Decimal('0.0000')), Row(CAST (TAN("N") AS NUMBER(38, 4))=Decimal('1.5574'))]

-- Example 33170
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([0, 1], schema=["N"]).select(
...     tanh(col("N").cast(DecimalType(scale=4)))
... )
>>> df.collect()
[Row(TANH( CAST ("N" AS NUMBER(38, 4)))=0.0), Row(TANH( CAST ("N" AS NUMBER(38, 4)))=0.7615941559557649)]

-- Example 33171
>>> df = session.create_dataframe(
...     [[11, 11, 0, 987654321], [10, 10, 0, 987654321]],
...     schema=["hour", "minute", "second", "nanoseconds"],
... )
>>> df.select(time_from_parts(
...     "hour", "minute", "second", nanoseconds="nanoseconds"
... ).alias("TIME_FROM_PARTS")).collect()
[Row(TIME_FROM_PARTS=datetime.time(11, 11, 0, 987654)), Row(TIME_FROM_PARTS=datetime.time(10, 10, 0, 987654))]

-- Example 33172
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0], [2022, 3, 31, 11, 11, 0]],
...     schema=["year", "month", "day", "hour", "minute", "second"],
... )
>>> df.select(timestamp_from_parts(
...     "year", "month", "day", "hour", "minute", "second"
... ).alias("TIMESTAMP_FROM_PARTS")).collect()
[Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 33173
>>> df = session.create_dataframe(
...     [['2022-04-01', '11:11:00'], ['2022-03-31', '11:11:00']],
...     schema=["date", "time"]
... )
>>> df.select(
...     timestamp_from_parts(to_date("date"), to_time("time")
... ).alias("TIMESTAMP_FROM_PARTS")).collect()
[Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 33174
>>> import datetime
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0], [2022, 3, 31, 11, 11, 0]],
...     schema=["year", "month", "day", "hour", "minute", "second"],
... )
>>> df.select(timestamp_ltz_from_parts(
...     "year", "month", "day", "hour", "minute", "second"
... ).alias("TIMESTAMP_LTZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_LTZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11, tzinfo=<DstTzInfo 'America/Los_Angeles' PDT-1 day, 17:00:00 DST>)), Row(TIMESTAMP_LTZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11, tzinfo=<DstTzInfo 'America/Los_Angeles' PDT-1 day, 17:00:00 DST>))]

-- Example 33175
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0], [2022, 3, 31, 11, 11, 0]],
...     schema=["year", "month", "day", "hour", "minute", "second"],
... )
>>> df.select(timestamp_ntz_from_parts(
...     "year", "month", "day", "hour", "minute", "second"
... ).alias("TIMESTAMP_NTZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 33176
>>> df = session.create_dataframe(
...     [['2022-04-01', '11:11:00'], ['2022-03-31', '11:11:00']],
...     schema=["date", "time"]
... )
>>> df.select(
...     timestamp_ntz_from_parts(to_date("date"), to_time("time")
... ).alias("TIMESTAMP_NTZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11)), Row(TIMESTAMP_NTZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11))]

-- Example 33177
>>> df = session.create_dataframe(
...     [[2022, 4, 1, 11, 11, 0, 'America/Los_Angeles'], [2022, 3, 31, 11, 11, 0, 'America/Los_Angeles']],
...     schema=["year", "month", "day", "hour", "minute", "second", "timezone"],
... )
>>> df.select(timestamp_tz_from_parts(
...     "year", "month", "day", "hour", "minute", "second", timezone="timezone"
... ).alias("TIMESTAMP_TZ_FROM_PARTS")).collect()
[Row(TIMESTAMP_TZ_FROM_PARTS=datetime.datetime(2022, 4, 1, 11, 11, tzinfo=pytz.FixedOffset(-420))), Row(TIMESTAMP_TZ_FROM_PARTS=datetime.datetime(2022, 3, 31, 11, 11, tzinfo=pytz.FixedOffset(-420)))]

-- Example 33178
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df.select(to_array(col('a')).as_('ans')).collect()
[Row(ANS='[\n  1\n]'), Row(ANS='[\n  2\n]'), Row(ANS='[\n  3\n]'), Row(ANS='[\n  4\n]')]


>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3]), Row(a=None)])
>>> df.select(to_array(col('a')).as_('ans')).collect()
[Row(ANS='[\n  1,\n  2,\n  3\n]'), Row(ANS=None)]

-- Example 33179
>>> df = session.create_dataframe(['00', '67', '0312'], schema=['a'])
>>> df.select(to_binary(col('a')).as_('ans')).collect()
[Row(ANS=bytearray(b'\x00')), Row(ANS=bytearray(b'g')), Row(ANS=bytearray(b'\x03\x12'))]

>>> df = session.create_dataframe(['aGVsbG8=', 'd29ybGQ=', 'IQ=='], schema=['a'])
>>> df.select(to_binary(col('a'), 'BASE64').as_('ans')).collect()
[Row(ANS=bytearray(b'hello')), Row(ANS=bytearray(b'world')), Row(ANS=bytearray(b'!'))]

>>> df.select(to_binary(col('a'), 'UTF-8').as_('ans')).collect()
[Row(ANS=bytearray(b'aGVsbG8=')), Row(ANS=bytearray(b'd29ybGQ=')), Row(ANS=bytearray(b'IQ=='))]

-- Example 33180
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='1'), Row(ANS='2'), Row(ANS='3'), Row(ANS='4')]

-- Example 33181
>>> import datetime
>>> df = session.create_dataframe([datetime.datetime(2023, 4, 16), datetime.datetime(2017, 4, 3, 2, 59, 37, 153)], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='2023-04-16 00:00:00.000'), Row(ANS='2017-04-03 02:59:37.000')]

-- Example 33182
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

-- Example 33183
>>> df = session.create_dataframe(['12', '11.3', '-90.12345'], schema=['a'])
>>> df.select(to_decimal(col('a'), 38, 0).as_('ans')).collect()
[Row(ANS=12), Row(ANS=11), Row(ANS=-90)]

-- Example 33184
>>> df.select(to_decimal(col('a'), 38, 2).as_('ans')).collect()
[Row(ANS=Decimal('12.00')), Row(ANS=Decimal('11.30')), Row(ANS=Decimal('-90.12'))]

-- Example 33185
>>> df = session.create_dataframe(['12', '11.3', '-90.12345'], schema=['a'])
>>> df.select(to_double(col('a')).as_('ans')).collect()
[Row(ANS=12.0), Row(ANS=11.3), Row(ANS=-90.12345)]

-- Example 33186
>>> df = session.create_dataframe(['12+', '11.3+', '90.12-'], schema=['a'])
>>> df.select(to_double(col('a'), "999.99MI").as_('ans')).collect()
[Row(ANS=12.0), Row(ANS=11.3), Row(ANS=-90.12)]

-- Example 33187
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

-- Example 33188
>>> df = session.create_dataframe(['POINT(-122.35 37.55)', 'POINT(20.92 43.33)'], schema=['a'])
>>> df.select(to_geography(col("a"))).collect()
[Row(TO_GEOGRAPHY("A")='{\n  "coordinates": [\n    -122.35,\n    37.55\n  ],\n  "type": "Point"\n}'), Row(TO_GEOGRAPHY("A")='{\n  "coordinates": [\n    20.92,\n    43.33\n  ],\n  "type": "Point"\n}')]

-- Example 33189
>>> df = session.create_dataframe(['POINT(-122.35 37.55)', 'POINT(20.92 43.33)'], schema=['a'])
>>> df.select(to_geometry(col("a"))).collect(statement_params={"GEOMETRY_OUTPUT_FORMAT": "WKT"})
[Row(TO_GEOMETRY("A")='POINT(-122.35 37.55)'), Row(TO_GEOMETRY("A")='POINT(20.92 43.33)')]

-- Example 33190
>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df = session.create_dataframe([Row(a=None),Row(a=12),Row(a=3.141),Row(a={'a':10,'b':20}),Row(a=[1,23,456])], schema=schema)
>>> df.select(to_json(col("a")).as_('ans')).collect()
[Row(ANS=None), Row(ANS='12'), Row(ANS='3.141'), Row(ANS='{"a":10,"b":20}'), Row(ANS='[1,23,456]')]

-- Example 33191
>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df = session.create_dataframe(["{'a':10,'b':20}", None], schema=schema)
>>> df.select(to_object(col("a")).as_('ans')).collect()
[Row(ANS='{\n  "a": 10,\n  "b": 20\n}'), Row(ANS=None)]

-- Example 33192
>>> df = session.create_dataframe(['04:15:29.999'], schema=['a'])
>>> df.select(to_time(col("a"))).collect()
[Row(TO_TIME("A")=datetime.time(4, 15, 29, 999000))]

-- Example 33193
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 1, 2, 3, 4000))]
>>> df = session.create_dataframe(["2020-05-01 13:11:20.000"], schema=['a'])
>>> df.select(to_timestamp(col("a"), lit("YYYY-MM-DD HH24:MI:SS.FF3")).as_("ans")).collect()
[Row(ANS=datetime.datetime(2020, 5, 1, 13, 11, 20))]

-- Example 33194
>>> import datetime
>>> df = session.createDataFrame([datetime.datetime(2022, 12, 25, 13, 59, 38, 467)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2022, 12, 25, 13, 59, 38, 467))]
>>> df = session.createDataFrame([datetime.date(2023, 3, 1)], schema=["a"])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(2023, 3, 1, 0, 0))]

-- Example 33195
>>> df = session.createDataFrame([20, 31536000000], schema=['a'])
>>> df.select(to_timestamp(col("a"))).collect()
[Row(TO_TIMESTAMP("A")=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(TO_TIMESTAMP("A")=datetime.datetime(2969, 5, 3, 0, 0))]
>>> df.select(to_timestamp(col("a"), lit(9))).collect()
[Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0)), Row(TO_TIMESTAMP("A", 9)=datetime.datetime(1970, 1, 1, 0, 0, 31, 536000))]

-- Example 33196
>>> df = session.createDataFrame(['20', '31536000000', '31536000000000', '31536000000000000'], schema=['a'])
>>> df.select(to_timestamp(col("a")).as_("ans")).collect()
[Row(ANS=datetime.datetime(1970, 1, 1, 0, 0, 20)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0)), Row(ANS=datetime.datetime(1971, 1, 1, 0, 0))]

-- Example 33197
>>> df = session.create_dataframe(['2019-01-31 01:02:03.004'], schema=['t'])
>>> df.select(to_utc_timestamp(col("t"), "America/Los_Angeles").alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 9, 2, 3, 4000))]

-- Example 33198
>>> df = session.create_dataframe([('2019-01-31 01:02:03.004', "America/Los_Angeles")], schema=['t', 'tz'])
>>> df.select(to_utc_timestamp(col("t"), col("tz")).alias("ans")).collect()
[Row(ANS=datetime.datetime(2019, 1, 31, 9, 2, 3, 4000))]

-- Example 33199
>>> df = session.create_dataframe([1, 2, 3, 4], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='1'), Row(ANS='2'), Row(ANS='3'), Row(ANS='4')]

-- Example 33200
>>> import datetime
>>> df = session.create_dataframe([datetime.datetime(2023, 4, 16), datetime.datetime(2017, 4, 3, 2, 59, 37, 153)], schema=['a'])
>>> df.select(to_char(col('a')).as_('ans')).collect()
[Row(ANS='2023-04-16 00:00:00.000'), Row(ANS='2017-04-03 02:59:37.000')]

-- Example 33201
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

-- Example 33202
>>> from snowflake.snowpark.types import VariantType, StructField, StructType
>>> from snowflake.snowpark import Row
>>> schema = StructType([StructField("a", VariantType())])
>>> df = session.create_dataframe([Row(a=10), Row(a='test'), Row(a={'a': 10, 'b': 20}), Row(a=[1, 2, 3])], schema=schema)
>>> df.select(to_xml(col("A")).as_("ans")).collect()
[Row(ANS='<SnowflakeData type="INTEGER">10</SnowflakeData>'), Row(ANS='<SnowflakeData type="VARCHAR">test</SnowflakeData>'), Row(ANS='<SnowflakeData type="OBJECT"><a type="INTEGER">10</a><b type="INTEGER">20</b></SnowflakeData>'), Row(ANS='<SnowflakeData type="ARRAY"><e type="INTEGER">1</e><e type="INTEGER">2</e><e type="INTEGER">3</e></SnowflakeData>')]

-- Example 33203
>>> df = session.create_dataframe(["abcdef", "abba"], schema=["a"])
>>> df.select(translate(col("a"), lit("abc"), lit("ABC")).as_("ans")).collect()
[Row(ANS='ABCdef'), Row(ANS='ABBA')]

>>> df = session.create_dataframe(["file with spaces.txt", "\ttest"], schema=["a"])
>>> df.select(translate(col("a"), lit(" \t"), lit("_")).as_("ans")).collect()
[Row(ANS='file_with_spaces.txt'), Row(ANS='test')]

