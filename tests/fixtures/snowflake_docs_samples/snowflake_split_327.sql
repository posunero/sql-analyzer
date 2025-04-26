-- Example 21887
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

-- Example 21888
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3])])
>>> df.select(array_size("a").alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

-- Example 21889
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

-- Example 21890
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

-- Example 21891
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

-- Example 21892
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, True, "s"])])
>>> df.select(array_to_string("a", lit(",")).alias("result")).show()
------------
|"RESULT"  |
------------
|1,true,s  |
------------

-- Example 21893
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

-- Example 21894
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

-- Example 21895
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2], [1, 3]), Row([1, 2], [3, 4])], schema=["a", "b"])
>>> df.select(arrays_overlap("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|True      |
|False     |
------------

-- Example 21896
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

-- Example 21897
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

-- Example 21898
>>> df = session.sql("select to_binary('F0A5')::variant as a")
>>> df.select(as_binary("a").alias("result")).show()
--------------------------
|"RESULT"                |
--------------------------
|bytearray(b'ð¥')  |
--------------------------

-- Example 21899
>>> from snowflake.snowpark.functions import as_char, to_variant
>>> df = session.sql("select 'some string' as char")
>>> df.char_v = to_variant(df.char)
>>> df.select(df.char_v.as_("char")).collect() == df.select(df.char).collect()
False
>>> df.select(as_char(df.char_v).as_("char")).collect() == df.select(df.char).collect()
True

-- Example 21900
>>> df = session.sql("select date'2020-1-1'::variant as a")
>>> df.select(as_date("a").alias("result")).show()
--------------
|"RESULT"    |
--------------
|2020-01-01  |
--------------

-- Example 21901
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_decimal("a", 4, 1).alias("result")).show()
------------
|"RESULT"  |
------------
|1.2       |
------------

-- Example 21902
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_double("a").alias("result")).show()
------------
|"RESULT"  |
------------
|1.2345    |
------------

-- Example 21903
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_integer("a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
------------

-- Example 21904
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_decimal("a", 4, 1).alias("result")).show()
------------
|"RESULT"  |
------------
|1.2       |
------------

-- Example 21905
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

-- Example 21906
>>> from snowflake.snowpark.types import VariantType, StructType, StructField, DoubleType
>>> schema=StructType([StructField("radius", DoubleType()),  StructField("radius_v", VariantType())])
>>> df = session.create_dataframe(data=[[2.0, None]], schema=schema)
>>> df.radius_v = to_variant(df.radius)
>>> df.select(df.radius_v.as_("radius_v"), df.radius).collect()
[Row(RADIUS_V='2.000000000000000e+00', RADIUS=2.0)]
>>> df.select(as_real(df.radius_v).as_("real_radius_v"), df.radius).collect()
[Row(REAL_RADIUS_V=2.0, RADIUS=2.0)]

-- Example 21907
>>> from snowflake.snowpark.functions import as_time, to_variant
>>> df = session.sql("select TO_TIME('12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_time(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 21908
>>> from snowflake.snowpark.functions import as_timestamp_ltz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_LTZ('2018-10-10 12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_ltz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 21909
>>> from snowflake.snowpark.functions import as_timestamp_ntz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_NTZ('2018-10-10 12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_ntz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 21910
>>> from snowflake.snowpark.functions import as_timestamp_tz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_TZ('2018-10-10 12:34:56 +0000') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_tz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 21911
>>> from snowflake.snowpark.functions import as_varchar, to_variant
>>> df = session.sql("select 'some string' as char")
>>> df.char_v = to_variant(df.char)
>>> df.select(df.char_v.as_("char")).collect() == df.select(df.char).collect()
False
>>> df.select(as_varchar(df.char_v).as_("char")).collect() == df.select(df.char).collect()
True

-- Example 21912
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=1), Row(A=2), Row(A=3)]

-- Example 21913
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc_nulls_first(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=1), Row(A=2), Row(A=3)]

-- Example 21914
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc_nulls_last(df["a"])).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=None), Row(A=None)]

-- Example 21915
>>> df = session.create_dataframe(['!', 'A', 'a', '', 'bcd', None], schema=['a'])
>>> df.select(df.a, ascii(df.a).as_('ascii')).collect()
[Row(A='!', ASCII=33), Row(A='A', ASCII=65), Row(A='a', ASCII=97), Row(A='', ASCII=0), Row(A='bcd', ASCII=98), Row(A=None, ASCII=None)]

-- Example 21916
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1]], schema=["deg"])
>>> df.select(asin(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.571     |
------------

-- Example 21917
>>> df = session.create_dataframe([2.129279455], schema=["a"])
>>> df.select(asinh(df["a"]).alias("asinh")).collect()
[Row(ASINH=1.4999999999596934)]

-- Example 21918
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1]], schema=["deg"])
>>> df.select(atan(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.785     |
------------

-- Example 21919
>>> df = session.create_dataframe([0.9051482536], schema=["a"])
>>> df.select(atanh(df["a"]).alias("result")).collect()
[Row(RESULT=1.4999999997517164)]

-- Example 21920
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2]], schema=["x", "y"])
>>> df.select(atan2(df.x, df.y).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.464     |
------------

-- Example 21921
>>> df = session.create_dataframe([[1], [2], [2]], schema=["d"])
>>> df.select(avg(df.d).alias("result")).show()
------------
|"RESULT"  |
------------
|1.666667  |
------------

-- Example 21922
>>> df = session.create_dataframe(["Snowflake", "Data"], schema=["input"])
>>> df.select(base64_encode(col("input")).alias("encoded")).collect()
[Row(ENCODED='U25vd2ZsYWtl'), Row(ENCODED='RGF0YQ==')]

-- Example 21923
>>> df = session.create_dataframe(["U25vd2ZsYWtl", "SEVMTE8="], schema=["input"])
>>> df.select(base64_decode_string(col("input")).alias("decoded")).collect()
[Row(DECODED='Snowflake'), Row(DECODED='HELLO')]

-- Example 21924
>>> df = session.create_dataframe(["Snowflake", "Data"], schema=["input"])
>>> df.select(base64_encode(col("input")).alias("encoded")).collect()
[Row(ENCODED='U25vd2ZsYWtl'), Row(ENCODED='RGF0YQ==')]

-- Example 21925
>>> df = session.create_dataframe([['abc'], ['Δ']], schema=["v"])
>>> df = df.withColumn("b", lit("A1B2").cast("binary"))
>>> df.select(bit_length(col("v")).alias("BIT_LENGTH_V"), bit_length(col("b")).alias("BIT_LENGTH_B")).collect()
[Row(BIT_LENGTH_V=24, BIT_LENGTH_B=16), Row(BIT_LENGTH_V=16, BIT_LENGTH_B=16)]

-- Example 21926
>>> df = session.create_dataframe([1, 2, 3, 32768, 32769], schema=["a"])
>>> df.select(bitmap_bit_position("a").alias("bit_position")).collect()
[Row(BIT_POSITION=0), Row(BIT_POSITION=1), Row(BIT_POSITION=2), Row(BIT_POSITION=32767), Row(BIT_POSITION=0)]

-- Example 21927
>>> df = session.create_dataframe([1, 2, 3, 32768, 32769], schema=["a"])
>>> df.select(bitmap_bucket_number(col("a")).alias("bucket_number")).collect()
[Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=2)]

-- Example 21928
>>> df = session.create_dataframe([1, 32769], schema=["a"])
>>> df.select(bitmap_bucket_number(df["a"]).alias("bitmap_id"),bitmap_bit_position(df["a"]).alias("bit_position")).group_by("bitmap_id").agg(bitmap_construct_agg(col("bit_position")).alias("bitmap")).collect()
[Row(BITMAP_ID=1, BITMAP=bytearray(b'\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00')), Row(BITMAP_ID=2, BITMAP=bytearray(b'\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00'))]

-- Example 21929
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(bitnot("a")).collect()[0][0]
-2

-- Example 21930
>>> df = session.create_dataframe([2], schema=["a"])
>>> df.select(bitshiftleft("a", 1)).collect()[0][0]
4

-- Example 21931
>>> df = session.create_dataframe([2], schema=["a"])
>>> df.select(bitshiftright("a", 1)).collect()[0][0]
1

-- Example 21932
>>> df.select(build_stage_file_url("@images_stage", "/us/yosemite/half_dome.jpg").alias("url")).collect()

-- Example 21933
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

-- Example 21934
>>> import decimal
>>> data = [(decimal.Decimal(1.235)),(decimal.Decimal(3.5))]
>>> df = session.createDataFrame(data, ["value"])
>>> df.select(bround('VALUE',1).alias("VALUE")).show() # Rounds to 1 decimal place
-----------
|"VALUE"  |
-----------
|1.2      |
|3.5      |
-----------

>>> df.select(bround('VALUE',0).alias("VALUE")).show() # Rounds to 1 decimal place
-----------
|"VALUE"  |
-----------
|1        |
|4        |
-----------

-- Example 21935
>>> df = session.create_dataframe([1, 2, 3, 4], schema=["a"])  # a single column with 4 rows
>>> df.select(call_function("avg", col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.500000      |
----------------

-- Example 21936
>>> df = session.create_dataframe([1, 2, 3, 4], schema=["a"])  # a single column with 4 rows
>>> df.select(call_function("avg", col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.500000      |
----------------

-- Example 21937
>>> from snowflake.snowpark.functions import lit
>>> session.table_function(call_table_function("split_to_table", lit("split words to table"), lit(" ")).over()).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 21938
>>> from snowflake.snowpark.types import IntegerType
>>> udf_def = session.udf.register(lambda x, y: x + y, name="add_columns", input_types=[IntegerType(), IntegerType()], return_type=IntegerType(), replace=True)
>>> df = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df.select(call_udf("add_columns", col("a"), col("b"))).show()
-------------------------------
|"ADD_COLUMNS(""A"", ""B"")"  |
-------------------------------
|3                            |
-------------------------------

-- Example 21939
>>> from snowflake.snowpark.types import DecimalType, IntegerType
>>> df = session.create_dataframe([[1.5432]], schema=["d"])
>>> df.select(cast(df.d, DecimalType(15, 2)).as_("DECIMAL"), cast(df.d, IntegerType()).as_("INT")).show()
---------------------
|"DECIMAL"  |"INT"  |
---------------------
|1.54       |2      |
---------------------

-- Example 21940
>>> df = session.create_dataframe([0, 2, -10, None], schema=["x"])
>>> df.select(cbrt("x").alias("cbrt_x")).collect()
[Row(CBRT_X=0.0), Row(CBRT_X=1.2599210498948734), Row(CBRT_X=-2.1544346900318834), Row(CBRT_X=None)]

-- Example 21941
>>> df = session.create_dataframe([135.135, -975.975], schema=["a"])
>>> df.select(ceil(df["a"]).alias("ceil")).collect()
[Row(CEIL=136.0), Row(CEIL=-975.0)]

-- Example 21942
>>> df = session.create_dataframe([83, 33, 169, 8364, None], schema=['a'])
>>> df.select(df.a, char(df.a).as_('char')).sort(df.a).show()
-----------------
|"A"   |"CHAR"  |
-----------------
|NULL  |NULL    |
|33    |!       |
|83    |S       |
|169   |©       |
|8364  |€       |
-----------------

-- Example 21943
>>> df = session.create_dataframe(["banana"], schema=['a'])
>>> df.select(charindex(lit("an"), df.a, 1).as_("result")).show()
------------
|"RESULT"  |
------------
|2         |
------------

-- Example 21944
>>> df.select(charindex(lit("an"), df.a, 3).as_("result")).show()
------------
|"RESULT"  |
------------
|4         |
------------

-- Example 21945
>>> df = session.create_dataframe(["{'ValidKey1': 'ValidValue1'}", "{'Malformed -- missing val':}", None], schema=['a'])
>>> df.select(check_json(df.a)).show()
-----------------------
|"CHECK_JSON(""A"")"  |
-----------------------
|NULL                 |
|misplaced }, pos 29  |
|NULL                 |
-----------------------

-- Example 21946
>>> df = session.create_dataframe(["<name> Valid </name>", "<name> Invalid </WRONG_CLOSING_TAG>", None], schema=['a'])
>>> df.select(check_xml(df.a)).show()
---------------------------------------------------
|"CHECK_XML(""A"")"                               |
---------------------------------------------------
|NULL                                             |
|no opening tag for </WRONG_CLOSING_TAG>, pos 35  |
|NULL                                             |
---------------------------------------------------

-- Example 21947
>>> df = session.create_dataframe([[1, 2, 3], [None, 2, 3], [None, None, 3], [None, None, None]], schema=['a', 'b', 'c'])
>>> df.select(df.a, df.b, df.c, coalesce(df.a, df.b, df.c).as_("COALESCE")).show()
-----------------------------------
|"A"   |"B"   |"C"   |"COALESCE"  |
-----------------------------------
|1     |2     |3     |1           |
|NULL  |2     |3     |2           |
|NULL  |NULL  |3     |3           |
|NULL  |NULL  |NULL  |NULL        |
-----------------------------------

-- Example 21948
>>> df = session.create_dataframe(['ñ'], schema=['v'])
>>> df.select(df.v == lit('Ñ'), collate(df.v, 'sp-upper') == lit('Ñ')).show()
----------------------------------------------------------
|"(""V"" = 'Ñ')"  |"(COLLATE(""V"", 'SP-UPPER') = 'Ñ')"  |
----------------------------------------------------------
|False            |True                                  |
----------------------------------------------------------

-- Example 21949
>>> df = session.create_dataframe(['ñ'], schema=['v'])
>>> df.select(collation(collate(df.v, 'sp-upper'))).show()
-------------------------------------------
|"COLLATION(COLLATE(""V"", 'SP-UPPER'))"  |
-------------------------------------------
|sp-upper                                 |
-------------------------------------------

-- Example 21950
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

-- Example 21951
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

-- Example 21952
>>> df = session.create_dataframe([['Hello', 'World']], schema=['a', 'b'])
>>> df.select(concat(df.a, df.b)).show()
--------------------------
|"CONCAT(""A"", ""B"")"  |
--------------------------
|HelloWorld              |
--------------------------

-- Example 21953
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([['Hello', 'World']], schema=['a', 'b'])
>>> df.select(concat_ws(lit(','), df.a, df.b)).show()
----------------------------------
|"CONCAT_WS(',', ""A"", ""B"")"  |
----------------------------------
|Hello,World                     |
----------------------------------

