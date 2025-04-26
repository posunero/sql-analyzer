-- Example 32869
>>> from snowflake.snowpark.functions import as_timestamp_ntz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_NTZ('2018-10-10 12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_ntz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 32870
>>> from snowflake.snowpark.functions import as_timestamp_tz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_TZ('2018-10-10 12:34:56 +0000') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_tz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 32871
>>> from snowflake.snowpark.functions import as_varchar, to_variant
>>> df = session.sql("select 'some string' as char")
>>> df.char_v = to_variant(df.char)
>>> df.select(df.char_v.as_("char")).collect() == df.select(df.char).collect()
False
>>> df.select(as_varchar(df.char_v).as_("char")).collect() == df.select(df.char).collect()
True

-- Example 32872
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=1), Row(A=2), Row(A=3)]

-- Example 32873
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc_nulls_first(df["a"])).collect()
[Row(A=None), Row(A=None), Row(A=1), Row(A=2), Row(A=3)]

-- Example 32874
>>> df = session.create_dataframe([None, 3, 2, 1, None], schema=["a"])
>>> df.sort(asc_nulls_last(df["a"])).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=None), Row(A=None)]

-- Example 32875
>>> df = session.create_dataframe(['!', 'A', 'a', '', 'bcd', None], schema=['a'])
>>> df.select(df.a, ascii(df.a).as_('ascii')).collect()
[Row(A='!', ASCII=33), Row(A='A', ASCII=65), Row(A='a', ASCII=97), Row(A='', ASCII=0), Row(A='bcd', ASCII=98), Row(A=None, ASCII=None)]

-- Example 32876
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1]], schema=["deg"])
>>> df.select(asin(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.571     |
------------

-- Example 32877
>>> df = session.create_dataframe([2.129279455], schema=["a"])
>>> df.select(asinh(df["a"]).alias("asinh")).collect()
[Row(ASINH=1.4999999999596934)]

-- Example 32878
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1]], schema=["deg"])
>>> df.select(atan(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.785     |
------------

-- Example 32879
>>> df = session.create_dataframe([0.9051482536], schema=["a"])
>>> df.select(atanh(df["a"]).alias("result")).collect()
[Row(RESULT=1.4999999997517164)]

-- Example 32880
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2]], schema=["x", "y"])
>>> df.select(atan2(df.x, df.y).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.464     |
------------

-- Example 32881
>>> df = session.create_dataframe([[1], [2], [2]], schema=["d"])
>>> df.select(avg(df.d).alias("result")).show()
------------
|"RESULT"  |
------------
|1.666667  |
------------

-- Example 32882
>>> df = session.create_dataframe(["Snowflake", "Data"], schema=["input"])
>>> df.select(base64_encode(col("input")).alias("encoded")).collect()
[Row(ENCODED='U25vd2ZsYWtl'), Row(ENCODED='RGF0YQ==')]

-- Example 32883
>>> df = session.create_dataframe(["U25vd2ZsYWtl", "SEVMTE8="], schema=["input"])
>>> df.select(base64_decode_string(col("input")).alias("decoded")).collect()
[Row(DECODED='Snowflake'), Row(DECODED='HELLO')]

-- Example 32884
>>> df = session.create_dataframe(["Snowflake", "Data"], schema=["input"])
>>> df.select(base64_encode(col("input")).alias("encoded")).collect()
[Row(ENCODED='U25vd2ZsYWtl'), Row(ENCODED='RGF0YQ==')]

-- Example 32885
>>> df = session.create_dataframe([['abc'], ['Δ']], schema=["v"])
>>> df = df.withColumn("b", lit("A1B2").cast("binary"))
>>> df.select(bit_length(col("v")).alias("BIT_LENGTH_V"), bit_length(col("b")).alias("BIT_LENGTH_B")).collect()
[Row(BIT_LENGTH_V=24, BIT_LENGTH_B=16), Row(BIT_LENGTH_V=16, BIT_LENGTH_B=16)]

-- Example 32886
>>> df = session.create_dataframe([1, 2, 3, 32768, 32769], schema=["a"])
>>> df.select(bitmap_bit_position("a").alias("bit_position")).collect()
[Row(BIT_POSITION=0), Row(BIT_POSITION=1), Row(BIT_POSITION=2), Row(BIT_POSITION=32767), Row(BIT_POSITION=0)]

-- Example 32887
>>> df = session.create_dataframe([1, 2, 3, 32768, 32769], schema=["a"])
>>> df.select(bitmap_bucket_number(col("a")).alias("bucket_number")).collect()
[Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=1), Row(BUCKET_NUMBER=2)]

-- Example 32888
>>> df = session.create_dataframe([1, 32769], schema=["a"])
>>> df.select(bitmap_bucket_number(df["a"]).alias("bitmap_id"),bitmap_bit_position(df["a"]).alias("bit_position")).group_by("bitmap_id").agg(bitmap_construct_agg(col("bit_position")).alias("bitmap")).collect()
[Row(BITMAP_ID=1, BITMAP=bytearray(b'\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00')), Row(BITMAP_ID=2, BITMAP=bytearray(b'\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00'))]

-- Example 32889
>>> df = session.create_dataframe([1], schema=["a"])
>>> df.select(bitnot("a")).collect()[0][0]
-2

-- Example 32890
>>> df = session.create_dataframe([2], schema=["a"])
>>> df.select(bitshiftleft("a", 1)).collect()[0][0]
4

-- Example 32891
>>> df = session.create_dataframe([2], schema=["a"])
>>> df.select(bitshiftright("a", 1)).collect()[0][0]
1

-- Example 32892
>>> df.select(build_stage_file_url("@images_stage", "/us/yosemite/half_dome.jpg").alias("url")).collect()

-- Example 32893
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

-- Example 32894
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

-- Example 32895
>>> df = session.create_dataframe([1, 2, 3, 4], schema=["a"])  # a single column with 4 rows
>>> df.select(call_function("avg", col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.500000      |
----------------

-- Example 32896
>>> df = session.create_dataframe([1, 2, 3, 4], schema=["a"])  # a single column with 4 rows
>>> df.select(call_function("avg", col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.500000      |
----------------

-- Example 32897
>>> from snowflake.snowpark.functions import lit
>>> session.table_function(call_table_function("split_to_table", lit("split words to table"), lit(" ")).over()).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 32898
>>> from snowflake.snowpark.types import IntegerType
>>> udf_def = session.udf.register(lambda x, y: x + y, name="add_columns", input_types=[IntegerType(), IntegerType()], return_type=IntegerType(), replace=True)
>>> df = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df.select(call_udf("add_columns", col("a"), col("b"))).show()
-------------------------------
|"ADD_COLUMNS(""A"", ""B"")"  |
-------------------------------
|3                            |
-------------------------------

-- Example 32899
>>> from snowflake.snowpark.types import DecimalType, IntegerType
>>> df = session.create_dataframe([[1.5432]], schema=["d"])
>>> df.select(cast(df.d, DecimalType(15, 2)).as_("DECIMAL"), cast(df.d, IntegerType()).as_("INT")).show()
---------------------
|"DECIMAL"  |"INT"  |
---------------------
|1.54       |2      |
---------------------

-- Example 32900
>>> df = session.create_dataframe([0, 2, -10, None], schema=["x"])
>>> df.select(cbrt("x").alias("cbrt_x")).collect()
[Row(CBRT_X=0.0), Row(CBRT_X=1.2599210498948734), Row(CBRT_X=-2.1544346900318834), Row(CBRT_X=None)]

-- Example 32901
>>> df = session.create_dataframe([135.135, -975.975], schema=["a"])
>>> df.select(ceil(df["a"]).alias("ceil")).collect()
[Row(CEIL=136.0), Row(CEIL=-975.0)]

-- Example 32902
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

-- Example 32903
>>> df = session.create_dataframe(["banana"], schema=['a'])
>>> df.select(charindex(lit("an"), df.a, 1).as_("result")).show()
------------
|"RESULT"  |
------------
|2         |
------------

-- Example 32904
>>> df.select(charindex(lit("an"), df.a, 3).as_("result")).show()
------------
|"RESULT"  |
------------
|4         |
------------

-- Example 32905
>>> df = session.create_dataframe(["{'ValidKey1': 'ValidValue1'}", "{'Malformed -- missing val':}", None], schema=['a'])
>>> df.select(check_json(df.a)).show()
-----------------------
|"CHECK_JSON(""A"")"  |
-----------------------
|NULL                 |
|misplaced }, pos 29  |
|NULL                 |
-----------------------

-- Example 32906
>>> df = session.create_dataframe(["<name> Valid </name>", "<name> Invalid </WRONG_CLOSING_TAG>", None], schema=['a'])
>>> df.select(check_xml(df.a)).show()
---------------------------------------------------
|"CHECK_XML(""A"")"                               |
---------------------------------------------------
|NULL                                             |
|no opening tag for </WRONG_CLOSING_TAG>, pos 35  |
|NULL                                             |
---------------------------------------------------

-- Example 32907
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

-- Example 32908
>>> df = session.create_dataframe(['ñ'], schema=['v'])
>>> df.select(df.v == lit('Ñ'), collate(df.v, 'sp-upper') == lit('Ñ')).show()
----------------------------------------------------------
|"(""V"" = 'Ñ')"  |"(COLLATE(""V"", 'SP-UPPER') = 'Ñ')"  |
----------------------------------------------------------
|False            |True                                  |
----------------------------------------------------------

-- Example 32909
>>> df = session.create_dataframe(['ñ'], schema=['v'])
>>> df.select(collation(collate(df.v, 'sp-upper'))).show()
-------------------------------------------
|"COLLATION(COLLATE(""V"", 'SP-UPPER'))"  |
-------------------------------------------
|sp-upper                                 |
-------------------------------------------

-- Example 32910
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

-- Example 32911
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

-- Example 32912
>>> df = session.create_dataframe([['Hello', 'World']], schema=['a', 'b'])
>>> df.select(concat(df.a, df.b)).show()
--------------------------
|"CONCAT(""A"", ""B"")"  |
--------------------------
|HelloWorld              |
--------------------------

-- Example 32913
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([['Hello', 'World']], schema=['a', 'b'])
>>> df.select(concat_ws(lit(','), df.a, df.b)).show()
----------------------------------
|"CONCAT_WS(',', ""A"", ""B"")"  |
----------------------------------
|Hello,World                     |
----------------------------------

-- Example 32914
>>> df = session.create_dataframe([['Hello', 'World', ',']], schema=['a', 'b', 'sep'])
>>> df.select(concat_ws('sep', df.a, df.b)).show()
--------------------------------------
|"CONCAT_WS(""SEP"", ""A"", ""B"")"  |
--------------------------------------
|Hello,World                         |
--------------------------------------

-- Example 32915
>>> df = session.create_dataframe([[1,2], [3,4], [5,5] ], schema=["a","b"])
>>> df.select(contains(col("a"), col("b")).alias("result")).show()
------------
|"RESULT"  |
------------
|False     |
|False     |
|True      |
------------

-- Example 32916
>>> import datetime
>>> from dateutil import tz
>>> datetime_with_tz = datetime.datetime(2022, 4, 6, 9, 0, 0, tzinfo=tz.tzoffset("myzone", -3600*7))
>>> datetime_with_no_tz = datetime.datetime(2022, 4, 6, 9, 0, 0)
>>> df = session.create_dataframe([[datetime_with_tz, datetime_with_no_tz]], schema=["a", "b"])
>>> result = df.select(convert_timezone(lit("UTC"), col("a")), convert_timezone(lit("UTC"), col("b"), lit("Asia/Shanghai"))).collect()
>>> result[0][0]
datetime.datetime(2022, 4, 6, 16, 0, tzinfo=<UTC>)
>>> result[0][1]
datetime.datetime(2022, 4, 6, 1, 0)

-- Example 32917
>>> df = session.create_dataframe([[1, 2], [1, 2], [4, 5], [2, 3], [3, None], [4, None], [6,4]], schema=["a", "b"])
>>> df.select(corr(col("a"), col("b")).alias("result")).show()
---------------------
|"RESULT"           |
---------------------
|0.813681508328809  |
---------------------

-- Example 32918
>>> from math import pi
>>> df = session.create_dataframe([[pi]], schema=["deg"])
>>> df.select(cos(col("deg")).alias("result")).show()
------------
|"RESULT"  |
------------
|-1.0      |
------------

-- Example 32919
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[0]], schema=["deg"])
>>> df.select(cosh(col("deg")).alias("result")).show()
------------
|"RESULT"  |
------------
|1.0       |
------------

-- Example 32920
>>> df = session.create_dataframe([[1], [None], [3], [4], [None]], schema=["a"])
>>> df.select(count(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

>>> df.select(count("*").alias("result")).show()
------------
|"RESULT"  |
------------
|5         |
------------

-- Example 32921
>>> df = session.create_dataframe([[1, 2], [1, 2], [3, None], [2, 3], [3, None], [4, None]], schema=["a", "b"])
>>> df.select(count_distinct(col("a"), col("b")).alias("result")).show()
------------
|"RESULT"  |
------------
|2         |
------------

>>> #  The result should be 2 for {[1,2],[2,3]} since the rest are either duplicate or NULL records

-- Example 32922
>>> df = session.create_dataframe([[1, 2], [1, 2], [3, None], [2, 3], [3, None], [4, None]], schema=["a", "b"])
>>> df.select(count_distinct(col("a"), col("b")).alias("result")).show()
------------
|"RESULT"  |
------------
|2         |
------------

>>> #  The result should be 2 for {[1,2],[2,3]} since the rest are either duplicate or NULL records

-- Example 32923
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2], [1, 2], [4, 5], [2, 3], [3, None], [4, None], [6,4]], schema=["a", "b"])
>>> df.select(covar_pop(col("a"), col("b")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.840     |
------------

-- Example 32924
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2], [1, 2], [4, 5], [2, 3], [3, None], [4, None], [6,4]], schema=["a", "b"])
>>> df.select(covar_samp(col("a"), col("b")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|2.300     |
------------

-- Example 32925
>>> from snowflake.snowpark.functions import create_map
>>> df = session.create_dataframe([("Paris", "France"), ("Tokyo", "Japan")], ("city", "country"))
>>> df.select(create_map("city", "country").alias("map")).show()
-----------------------
|"MAP"                |
-----------------------
|{                    |
|  "Paris": "France"  |
|}                    |
|{                    |
|  "Tokyo": "Japan"   |
|}                    |
-----------------------

-- Example 32926
>>> df.select(create_map([df.city, df.country]).alias("map")).show()
-----------------------
|"MAP"                |
-----------------------
|{                    |
|  "Paris": "France"  |
|}                    |
|{                    |
|  "Tokyo": "Japan"   |
|}                    |
-----------------------

-- Example 32927
>>> from snowflake.snowpark.window import Window
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[1, 2], [1, 2], [1,3], [4, 5], [2, 3], [3, 4], [4, 7], [3,7], [4,5]], schema=["a", "b"])
>>> df.select(cume_dist().over(Window.order_by("a")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|0.333     |
|0.333     |
|0.333     |
|0.444     |
|0.667     |
|0.667     |
|1.000     |
|1.000     |
|1.000     |
------------

-- Example 32928
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_account()).collect()
>>> assert result[0]['CURRENT_ACCOUNT()'] is not None

-- Example 32929
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_available_roles()).collect()
>>> assert result[0]['CURRENT_AVAILABLE_ROLES()'] is not None

-- Example 32930
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_database()).collect()
>>> assert result[0]['CURRENT_DATABASE()'] is not None

-- Example 32931
>>> import datetime
>>> result = session.create_dataframe([1]).select(current_date()).collect()
>>> assert isinstance(result[0]["CURRENT_DATE()"], datetime.date)

-- Example 32932
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_region()).collect()
>>> assert result[0]['CURRENT_REGION()'] is not None

-- Example 32933
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_role()).collect()
>>> assert result[0]['CURRENT_ROLE()'] is not None

-- Example 32934
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_schema()).collect()
>>> assert result[0]['CURRENT_SCHEMA()'] is not None

-- Example 32935
>>> # Return result is tied to session, so we only test if the result exists
>>> result = session.create_dataframe([1]).select(current_schemas()).collect()
>>> assert result[0]['CURRENT_SCHEMAS()'] is not None

