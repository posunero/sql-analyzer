-- Example 21820
>>> from snowflake.snowpark.types import IntegerType
>>> from snowflake.snowpark.dataframe import map
>>> import pandas as pd
>>> df = session.create_dataframe([[10, "a", 22], [20, "b", 22]], schema=["col1", "col2", "col3"])
>>> new_df = map(df, lambda row: row[0] * row[0], output_types=[IntegerType()])
>>> new_df.order_by("c_1").show()
---------
|"C_1"  |
---------
|100    |
|400    |
---------

-- Example 21821
>>> new_df = map(df, lambda row: (row[1], row[0] * 3), output_types=[StringType(), IntegerType()])
>>> new_df.order_by("c_1").show()
-----------------
|"C_1"  |"C_2"  |
-----------------
|a      |30     |
|b      |60     |
-----------------

-- Example 21822
>>> new_df = map(
...     df,
...     lambda row: (row[1], row[0] * 3),
...     output_types=[StringType(), IntegerType()],
...     output_column_names=['col1', 'col2']
... )
>>> new_df.order_by("col1").show()
-------------------
|"COL1"  |"COL2"  |
-------------------
|a       |30      |
|b       |60      |
-------------------

-- Example 21823
>>> new_df = map(df, lambda pdf: pdf['COL1']*3, output_types=[IntegerType()], vectorized=True, packages=["pandas"])
>>> new_df.order_by("c_1").show()
---------
|"C_1"  |
---------
|30     |
|60     |
---------

-- Example 21824
>>> new_df = map(
...     df,
...     lambda pdf: (pdf['COL1']*3, pdf['COL2']+"b"),
...     output_types=[IntegerType(), StringType()],
...     output_column_names=['A', 'B'],
...     vectorized=True,
...     packages=["pandas"],
... )
>>> new_df.order_by("A").show()
-------------
|"A"  |"B"  |
-------------
|30   |ab   |
|60   |bb   |
-------------

-- Example 21825
>>> new_df = map(
...     df,
...     lambda pdf: ((pdf.shape[0],) * len(pdf), (pdf.shape[1],) * len(pdf)),
...     output_types=[IntegerType(), IntegerType()],
...     output_column_names=['rows', 'cols'],
...     partition_by="col3",
...     vectorized=True,
...     packages=["pandas"],
... )
>>> new_df.show()
-------------------
|"ROWS"  |"COLS"  |
-------------------
|2       |3       |
|2       |3       |
-------------------

-- Example 21826
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.write.mode("overwrite").save_as_table("saved_table", table_type="temporary")
>>> session.table("saved_table").show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

>>> stage_created_result = session.sql("create temp stage if not exists test_stage").collect()
>>> df.write.copy_into_location("@test_stage/copied_from_dataframe")  # default CSV
[Row(rows_unloaded=2, input_bytes=8, output_bytes=28)]

-- Example 21827
>>> from snowflake.snowpark.functions import col
>>> df = session.create_dataframe([["John", 1], ["Mike", 11]], schema=["name", "age"])
>>> df.select("name").collect()
[Row(NAME='John'), Row(NAME='Mike')]
>>> df.select(col("name")).collect()
[Row(NAME='John'), Row(NAME='Mike')]
>>> df.select(df.col("name")).collect()
[Row(NAME='John'), Row(NAME='Mike')]
>>> df.select(df["name"]).collect()
[Row(NAME='John'), Row(NAME='Mike')]
>>> df.select(df.name).collect()
[Row(NAME='John'), Row(NAME='Mike')]

-- Example 21828
>>> from snowflake.snowpark.functions import lit
>>> df.select(col("name"), lit("const value").alias("literal_column")).collect()
[Row(NAME='John', LITERAL_COLUMN='const value'), Row(NAME='Mike', LITERAL_COLUMN='const value')]

-- Example 21829
>>> df = session.create_dataframe([[20, 5], [1, 2]], schema=["a", "b"])
>>> df.filter((col("a") == 20) | (col("b") <= 10)).collect()  # use parentheses before and after the | operator.
[Row(A=20, B=5), Row(A=1, B=2)]
>>> df.filter((df["a"] + df.b) < 10).collect()
[Row(A=1, B=2)]
>>> df.select((col("b") * 10).alias("c")).collect()
[Row(C=50), Row(C=20)]

-- Example 21830
>>> from snowflake.snowpark.types import StringType, IntegerType
>>> df_with_semi_data = session.create_dataframe([[{"k1": "v1", "k2": "v2"}, ["a0", 1, "a2"]]], schema=["object_column", "array_column"])
>>> df_with_semi_data.select(df_with_semi_data["object_column"]["k1"].alias("k1_value"), df_with_semi_data["array_column"][0].alias("a0_value"), df_with_semi_data["array_column"][1].alias("a1_value")).collect()
[Row(K1_VALUE='"v1"', A0_VALUE='"a0"', A1_VALUE='1')]
>>> # The above two returned string columns have JSON literal values because children of semi-structured data are semi-structured.
>>> # The next line converts JSON literal to a string
>>> df_with_semi_data.select(df_with_semi_data["object_column"]["k1"].cast(StringType()).alias("k1_value"), df_with_semi_data["array_column"][0].cast(StringType()).alias("a0_value"), df_with_semi_data["array_column"][1].cast(IntegerType()).alias("a1_value")).collect()
[Row(K1_VALUE='v1', A0_VALUE='a0', A1_VALUE=1)]

-- Example 21831
>>> from snowflake.snowpark.functions import when, col, lit

>>> df = session.create_dataframe([[None], [1], [2]], schema=["a"])
>>> df.select(when(col("a").is_null(), lit(1)) \
...     .when(col("a") == 1, lit(2)) \
...     .otherwise(lit(3)).alias("case_when_column")).collect()
[Row(CASE_WHEN_COLUMN=1), Row(CASE_WHEN_COLUMN=2), Row(CASE_WHEN_COLUMN=3)]

-- Example 21832
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([[1, "x"], [2, "y"] ,[4, "z"]], schema=["a", "b"])
>>> # Basic example
>>> df.filter(df["a"].in_(lit(1), lit(2), lit(3))).collect()
[Row(A=1, B='x'), Row(A=2, B='y')]

>>> # Check in membership for a DataFrame that has a single column
>>> df_for_in = session.create_dataframe([[1], [2] ,[3]], schema=["col1"])
>>> df.filter(df["a"].in_(df_for_in)).sort(df["a"].asc()).collect()
[Row(A=1, B='x'), Row(A=2, B='y')]

>>> # Use in with a select method call
>>> df.select(df["a"].in_(lit(1), lit(2), lit(3)).alias("is_in_list")).collect()
[Row(IS_IN_LIST=True), Row(IS_IN_LIST=True), Row(IS_IN_LIST=False)]

>>> # Use in with column object
>>> df2 = session.create_dataframe([[1, 1], [2, 4] ,[3, 0]], schema=["a", "b"])
>>> df2.select(df2["a"].in_(df2["b"]).alias("is_a_in_b")).collect()
[Row(IS_A_IN_B=True), Row(IS_A_IN_B=False), Row(IS_A_IN_B=False)]

-- Example 21833
>>> from snowflake.snowpark.functions import lit
>>> df = session.create_dataframe([[1, "x"], [2, "y"] ,[4, "z"]], schema=["a", "b"])
>>> # Basic example
>>> df.filter(df["a"].in_(lit(1), lit(2), lit(3))).collect()
[Row(A=1, B='x'), Row(A=2, B='y')]

>>> # Check in membership for a DataFrame that has a single column
>>> df_for_in = session.create_dataframe([[1], [2] ,[3]], schema=["col1"])
>>> df.filter(df["a"].in_(df_for_in)).sort(df["a"].asc()).collect()
[Row(A=1, B='x'), Row(A=2, B='y')]

>>> # Use in with a select method call
>>> df.select(df["a"].in_(lit(1), lit(2), lit(3)).alias("is_in_list")).collect()
[Row(IS_IN_LIST=True), Row(IS_IN_LIST=True), Row(IS_IN_LIST=False)]

>>> # Use in with column object
>>> df2 = session.create_dataframe([[1, 1], [2, 4] ,[3, 0]], schema=["a", "b"])
>>> df2.select(df2["a"].in_(df2["b"]).alias("is_a_in_b")).collect()
[Row(IS_A_IN_B=True), Row(IS_A_IN_B=False), Row(IS_A_IN_B=False)]

-- Example 21834
>>> from snowflake.snowpark.functions import array_agg, col
>>> from snowflake.snowpark import Window

>>> df = session.create_dataframe([(3, "v1"), (1, "v3"), (2, "v2")], schema=["a", "b"])
>>> # create a DataFrame containing the values in "a" sorted by "b"
>>> df.select(array_agg("a").within_group(col("b").asc()).alias("new_column")).show()
----------------
|"NEW_COLUMN"  |
----------------
|[             |
|  3,          |
|  2,          |
|  1           |
|]             |
----------------

>>> # create a DataFrame containing the values in "a" grouped by "b"
>>> # and sorted by "a" in descending order.
>>> df_array_agg_window = df.select(array_agg("a").within_group(col("a").desc()).over(Window.partitionBy(col("b"))).alias("new_column"))
>>> df_array_agg_window.show()
----------------
|"NEW_COLUMN"  |
----------------
|[             |
|  3           |
|]             |
|[             |
|  1           |
|]             |
|[             |
|  2           |
|]             |
----------------

-- Example 21835
>>> string_t = StringType(23)  # this can be used to create a string type column which holds at most 23 chars
>>> string_t = StringType()    # this can be used to create a string type column with maximum allowed length

-- Example 21836
>>> row = Row(1, 2)
>>> row
Row(1, 2)
>>> row[0]
1
>>> len(row)
2
>>> row[0:1]
Row(1)
>>> named_row = Row(name1=1, name2=2)
>>> named_row
Row(name1=1, name2=2)
>>> named_row["name1"]
1
>>> named_row.name1
1
>>> row == named_row
True

-- Example 21837
>>> Employee = Row("name", "salary")
>>> emp1 = Employee("John", 10000)
>>> emp1
Row(name='John', salary=10000)
>>> emp2 = Employee("James", 20000)
>>> emp2
Row(name='James', salary=20000)

-- Example 21838
>>> row = Row(name1=1, name2=2, name3=Row(childname=3))
>>> row.as_dict()
{'name1': 1, 'name2': 2, 'name3': Row(childname=3)}
>>> row.as_dict(True)
{'name1': 1, 'name2': 2, 'name3': {'childname': 3}}

-- Example 21839
>>> row = Row(name1=1, name2=2, name3=Row(childname=3))
>>> row.as_dict()
{'name1': 1, 'name2': 2, 'name3': Row(childname=3)}
>>> row.as_dict(True)
{'name1': 1, 'name2': 2, 'name3': {'childname': 3}}

-- Example 21840
>>> df = session.create_dataframe([[1, 'a', True, '2022-03-16'], [3, 'b', False, '2023-04-17']], schema=["a", "b", "c", "d"])
>>> res1 = df.filter(col("a") == 1).collect()
>>> res2 = df.filter(lit(1) == col("a")).collect()
>>> res3 = df.filter(sql_expr("a = 1")).collect()
>>> assert res1 == res2 == res3
>>> res1
[Row(A=1, B='a', C=True, D='2022-03-16')]

-- Example 21841
>>> df.filter("a = 1").collect()  # use the SQL expression directly in filter
[Row(A=1, B='a', C=True, D='2022-03-16')]
>>> df.select("a").collect()
[Row(A=1), Row(A=3)]

-- Example 21842
>>> # Use columns and literals in expressions.
>>> df.select(((col("a") + 1).cast("string")).alias("add_one")).show()
-------------
|"ADD_ONE"  |
-------------
|2          |
|4          |
-------------

-- Example 21843
>>> # This example calls the function that corresponds to the TO_DATE() SQL function.
>>> df.select(dateadd('day', lit(1), to_date(col("d")))).show()
---------------------------------------
|"DATEADD('DAY', 1, TO_DATE(""D""))"  |
---------------------------------------
|2022-03-17                           |
|2023-04-18                           |
---------------------------------------

-- Example 21844
>>> my_radians = function("radians")  # "radians" is the SQL function name.
>>> df.select(my_radians(col("a")).alias("my_radians")).show()
------------------------
|"MY_RADIANS"          |
------------------------
|0.017453292519943295  |
|0.05235987755982988   |
------------------------

-- Example 21845
>>> df.select(call_function("radians", col("a")).as_("call_function_radians")).show()
---------------------------
|"CALL_FUNCTION_RADIANS"  |
---------------------------
|0.017453292519943295     |
|0.05235987755982988      |
---------------------------

-- Example 21846
>>> df.select(avg("a")).show()
----------------
|"AVG(""A"")"  |
----------------
|2.000000      |
----------------

>>> df.select(avg(col("a"))).show()
----------------
|"AVG(""A"")"  |
----------------
|2.000000      |
----------------

-- Example 21847
>>> import datetime
>>> from snowflake.snowpark.window import Window
>>> df.select(col("d"), lead("d", 1, datetime.date(2024, 5, 18), False).over(Window.order_by("d")).alias("lead_day")).show()
---------------------------
|"D"         |"LEAD_DAY"  |
---------------------------
|2022-03-16  |2023-04-17  |
|2023-04-17  |2024-05-18  |
---------------------------

-- Example 21848
>>> df.select(when(df["a"] > 2, "Greater than 2").else_("Less than 2").alias("compare_with_2")).show()
--------------------
|"COMPARE_WITH_2"  |
--------------------
|Less than 2       |
|Greater than 2    |
--------------------

-- Example 21849
>>> df.with_column("e", lit("1.2")).select(to_decimal("e", 5, 2)).show()
-----------------------------
|"TO_DECIMAL(""E"", 5, 2)"  |
-----------------------------
|1.20                       |
|1.20                       |
-----------------------------

-- Example 21850
>>> df.select(when("a > 2", "Greater than 2").else_("Less than 2").alias("compare_with_2")).show()
--------------------
|"COMPARE_WITH_2"  |
--------------------
|Less than 2       |
|Greater than 2    |
--------------------

-- Example 21851
>>> df = session.create_dataframe([[-1]], schema=["a"])
>>> df.select(abs(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
------------

-- Example 21852
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[0.5]], schema=["deg"])
>>> df.select(acos(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.047     |
------------

-- Example 21853
>>> df = session.create_dataframe([2.352409615], schema=["a"])
>>> df.select(acosh("a").as_("acosh")).collect()
[Row(ACOSH=1.4999999998857607)]

-- Example 21854
>>> import datetime
>>> df = session.create_dataframe([datetime.date(2022, 4, 6)], schema=["d"])
>>> df.select(add_months("d", 4)).collect()[0][0]
datetime.date(2022, 8, 6)

-- Example 21855
>>> df = session.create_dataframe([
...     [1, "Excellent"],
...     [1, "Excellent"],
...     [1, "Great"],
...     [1, "Mediocre"],
...     [2, "Terrible"],
...     [2, "Bad"],
... ], schema=["product_id", "review"])
>>> summary_df = df.select(ai_agg(col("review"), "Summarize the product reviews for a blog post targeting consumers"))
>>> summary_df.count()
1
>>> summary_df = df.group_by("product_id").agg(ai_agg(col("review"), "Summarize the product reviews for a blog post targeting consumers"))
>>> summary_df.count()
2

-- Example 21856
>>> # for text
>>> session.range(1).select(ai_classify('One day I will see the world', ['travel', 'cooking']).alias("answer")).show()
-----------------------
|"ANSWER"             |
-----------------------
|{                    |
|  "label": "travel"  |
|}                    |
-----------------------

>>> df = session.create_dataframe([
...     ['France', ['North America', 'Europe', 'Asia']],
...     ['Singapore', ['North America', 'Europe', 'Asia']],
...     ['one day I will see the world', ['travel', 'cooking', 'dancing']],
...     ['my lobster bisque is second to none', ['travel', 'cooking', 'dancing']]
... ], schema=["data", "category"])
>>> df.select(ai_classify(col("data"), col("category"))["label"].alias("class")).show()
-------------
|"CLASS"    |
-------------
|"Europe"   |
|"Asia"     |
|"travel"   |
|"cooking"  |
-------------

>>> # for image
>>> _ = session.sql("CREATE OR REPLACE TEMP STAGE mystage ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')").collect()
>>> _ = session.file.put("tests/resources/dog.jpg", "@mystage", auto_compress=False)
>>> df = session.range(1).select(
...     ai_classify(
...         prompt("Please help me classify the dog within this image {0}", to_file("@mystage/dog.jpg")),
...         ["French Bulldog", "Golden Retriever", "Bichon", "Cavapoo", "Beagle"]
...     ).alias("classes")
... )
>>> df.show()
------------------------
|"CLASSES"             |
------------------------
|{                     |
|  "label": "Cavapoo"  |
|}                     |
------------------------




This function or method is in private preview since 1.31.0.

-- Example 21857
>>> # for text
>>> session.range(1).select(ai_filter('Is Canada in North America?').alias("answer")).show()
------------
|"ANSWER"  |
------------
|True      |
------------

>>> # use prompt function
>>> df = session.create_dataframe(["Switzerland", "Korea"], schema=["country"])
>>> df.select(
...     ai_filter(prompt("Is {0} in Asia?", col("country"))).as_("asia"),
...     ai_filter(prompt("Is {0} in Europe?", col("country"))).as_("europe"),
...     ai_filter(prompt("Is {0} in North America?", col("country"))).as_("north_america"),
...     ai_filter(prompt("Is {0} in Central America?", col("country"))).as_("central_america"),
... ).show()
-----------------------------------------------------------
|"ASIA"  |"EUROPE"  |"NORTH_AMERICA"  |"CENTRAL_AMERICA"  |
-----------------------------------------------------------
|False   |True      |False            |False              |
|True    |False     |False            |False              |
-----------------------------------------------------------

>>> # for image
>>> _ = session.sql("CREATE OR REPLACE TEMP STAGE mystage ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')").collect()
>>> _ = session.file.put("tests/resources/dog.jpg", "@mystage", auto_compress=False)
>>> df = session.range(1).select(ai_filter("is it a dog picture?", to_file("@mystage/dog.jpg")).alias("is_dog"))
>>> df.show()
------------
|"IS_DOG"  |
------------
|True      |
------------



This function or method is in private preview since 1.29.0.

-- Example 21858
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> result = df.select(any_value("a")).collect()
>>> assert len(result) == 1  # non-deterministic value in result.

-- Example 21859
>>> df = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df.select(approx_count_distinct("a").alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

-- Example 21860
>>> df = session.create_dataframe([0,1,2,3,4,5,6,7,8,9], schema=["a"])
>>> df.select(approx_percentile("a", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|4.5       |
------------

-- Example 21861
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

-- Example 21862
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

-- Example 21863
>>> df = session.create_dataframe([1,2,3,4,5], schema=["a"])
>>> df_accu = df.select(approx_percentile_accumulate("a").alias("app_percentile_accu"))
>>> df_accu.select(approx_percentile_estimate("app_percentile_accu", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|3.0       |
------------

-- Example 21864
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

-- Example 21865
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

-- Example 21866
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

-- Example 21867
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

-- Example 21868
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

-- Example 21869
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

-- Example 21870
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2]), Row([1, 3])], schema=["a"])
>>> df.select(array_contains(lit(2), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|True      |
|False     |
------------

-- Example 21871
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

-- Example 21872
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

-- Example 21873
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

-- Example 21874
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

-- Example 21875
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

-- Example 21876
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, True, "s"])])
>>> df.select(array_to_string("a", lit(",")).alias("result")).show()
------------
|"RESULT"  |
------------
|1,true,s  |
------------

-- Example 21877
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A='20')]
>>> df = session.sql("select array_construct() as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A=None)]
>>> df = session.sql("select array_construct(null, null, null) as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A=None)]

-- Example 21878
>>> df = session.create_dataframe([[[None, None, None]]], schema=["A"])
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A='null')]

-- Example 21879
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A='0')]
>>> df = session.sql("select array_construct() as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A=None)]
>>> df = session.sql("select array_construct(null, null, null) as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A=None)]

-- Example 21880
>>> df = session.create_dataframe([[[None, None, None]]], schema=["A"])
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A='null')]

-- Example 21881
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([2, 1]), Row([1, 3])], schema=["a"])
>>> df.select(array_position(lit(1), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|0         |
------------

-- Example 21882
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

-- Example 21883
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

-- Example 21884
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

-- Example 21885
>>> df.select(array_remove(df.data, None).alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|NULL       |
-------------

-- Example 21886
>>> df.select(array_remove(array_remove(df.data, 1), "2").alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|[          |
|  3.1      |
|]          |
-------------

