-- Example 32802
>>> from snowflake.snowpark.functions import when, col, lit

>>> df = session.create_dataframe([[None], [1], [2]], schema=["a"])
>>> df.select(when(col("a").is_null(), lit(1)) \
...     .when(col("a") == 1, lit(2)) \
...     .otherwise(lit(3)).alias("case_when_column")).collect()
[Row(CASE_WHEN_COLUMN=1), Row(CASE_WHEN_COLUMN=2), Row(CASE_WHEN_COLUMN=3)]

-- Example 32803
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

-- Example 32804
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

-- Example 32805
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

-- Example 32806
>>> string_t = StringType(23)  # this can be used to create a string type column which holds at most 23 chars
>>> string_t = StringType()    # this can be used to create a string type column with maximum allowed length

-- Example 32807
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

-- Example 32808
>>> Employee = Row("name", "salary")
>>> emp1 = Employee("John", 10000)
>>> emp1
Row(name='John', salary=10000)
>>> emp2 = Employee("James", 20000)
>>> emp2
Row(name='James', salary=20000)

-- Example 32809
>>> row = Row(name1=1, name2=2, name3=Row(childname=3))
>>> row.as_dict()
{'name1': 1, 'name2': 2, 'name3': Row(childname=3)}
>>> row.as_dict(True)
{'name1': 1, 'name2': 2, 'name3': {'childname': 3}}

-- Example 32810
>>> row = Row(name1=1, name2=2, name3=Row(childname=3))
>>> row.as_dict()
{'name1': 1, 'name2': 2, 'name3': Row(childname=3)}
>>> row.as_dict(True)
{'name1': 1, 'name2': 2, 'name3': {'childname': 3}}

-- Example 32811
>>> df = session.create_dataframe([[-1]], schema=["a"])
>>> df.select(abs(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
------------

-- Example 32812
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[0.5]], schema=["deg"])
>>> df.select(acos(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.047     |
------------

-- Example 32813
>>> df = session.create_dataframe([2.352409615], schema=["a"])
>>> df.select(acosh("a").as_("acosh")).collect()
[Row(ACOSH=1.4999999998857607)]

-- Example 32814
>>> import datetime
>>> df = session.create_dataframe([datetime.date(2022, 4, 6)], schema=["d"])
>>> df.select(add_months("d", 4)).collect()[0][0]
datetime.date(2022, 8, 6)

-- Example 32815
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

-- Example 32816
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

-- Example 32817
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

-- Example 32818
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> result = df.select(any_value("a")).collect()
>>> assert len(result) == 1  # non-deterministic value in result.

-- Example 32819
>>> df = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df.select(approx_count_distinct("a").alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

-- Example 32820
>>> df = session.create_dataframe([0,1,2,3,4,5,6,7,8,9], schema=["a"])
>>> df.select(approx_percentile("a", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|4.5       |
------------

-- Example 32821
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

-- Example 32822
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

-- Example 32823
>>> df = session.create_dataframe([1,2,3,4,5], schema=["a"])
>>> df_accu = df.select(approx_percentile_accumulate("a").alias("app_percentile_accu"))
>>> df_accu.select(approx_percentile_estimate("app_percentile_accu", 0.5).alias("result")).show()
------------
|"RESULT"  |
------------
|3.0       |
------------

-- Example 32824
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

-- Example 32825
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

-- Example 32826
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

-- Example 32827
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

-- Example 32828
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

-- Example 32829
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

-- Example 32830
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2]), Row([1, 3])], schema=["a"])
>>> df.select(array_contains(lit(2), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|True      |
|False     |
------------

-- Example 32831
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

-- Example 32832
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

-- Example 32833
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

-- Example 32834
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

-- Example 32835
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

-- Example 32836
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, True, "s"])])
>>> df.select(array_to_string("a", lit(",")).alias("result")).show()
------------
|"RESULT"  |
------------
|1,true,s  |
------------

-- Example 32837
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A='20')]
>>> df = session.sql("select array_construct() as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A=None)]
>>> df = session.sql("select array_construct(null, null, null) as A")
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A=None)]

-- Example 32838
>>> df = session.create_dataframe([[[None, None, None]]], schema=["A"])
>>> df.select(array_max(df.a).as_("max_a")).collect()
[Row(MAX_A='null')]

-- Example 32839
>>> df = session.sql("select array_construct(20, 0, null, 10) as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A='0')]
>>> df = session.sql("select array_construct() as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A=None)]
>>> df = session.sql("select array_construct(null, null, null) as A")
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A=None)]

-- Example 32840
>>> df = session.create_dataframe([[[None, None, None]]], schema=["A"])
>>> df.select(array_min(df.a).as_("min_a")).collect()
[Row(MIN_A='null')]

-- Example 32841
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([2, 1]), Row([1, 3])], schema=["a"])
>>> df.select(array_position(lit(1), "a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
|0         |
------------

-- Example 32842
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

-- Example 32843
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

-- Example 32844
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

-- Example 32845
>>> df.select(array_remove(df.data, None).alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|NULL       |
-------------

-- Example 32846
>>> df.select(array_remove(array_remove(df.data, 1), "2").alias("objects")).show()
-------------
|"OBJECTS"  |
-------------
|[          |
|  3.1      |
|]          |
-------------

-- Example 32847
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

-- Example 32848
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, 2, 3])])
>>> df.select(array_size("a").alias("result")).show()
------------
|"RESULT"  |
------------
|3         |
------------

-- Example 32849
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

-- Example 32850
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

-- Example 32851
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

-- Example 32852
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row(a=[1, True, "s"])])
>>> df.select(array_to_string("a", lit(",")).alias("result")).show()
------------
|"RESULT"  |
------------
|1,true,s  |
------------

-- Example 32853
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

-- Example 32854
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

-- Example 32855
>>> from snowflake.snowpark import Row
>>> df = session.create_dataframe([Row([1, 2], [1, 3]), Row([1, 2], [3, 4])], schema=["a", "b"])
>>> df.select(arrays_overlap("a", "b").alias("result")).show()
------------
|"RESULT"  |
------------
|True      |
|False     |
------------

-- Example 32856
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

-- Example 32857
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

-- Example 32858
>>> df = session.sql("select to_binary('F0A5')::variant as a")
>>> df.select(as_binary("a").alias("result")).show()
--------------------------
|"RESULT"                |
--------------------------
|bytearray(b'ð¥')  |
--------------------------

-- Example 32859
>>> from snowflake.snowpark.functions import as_char, to_variant
>>> df = session.sql("select 'some string' as char")
>>> df.char_v = to_variant(df.char)
>>> df.select(df.char_v.as_("char")).collect() == df.select(df.char).collect()
False
>>> df.select(as_char(df.char_v).as_("char")).collect() == df.select(df.char).collect()
True

-- Example 32860
>>> df = session.sql("select date'2020-1-1'::variant as a")
>>> df.select(as_date("a").alias("result")).show()
--------------
|"RESULT"    |
--------------
|2020-01-01  |
--------------

-- Example 32861
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_decimal("a", 4, 1).alias("result")).show()
------------
|"RESULT"  |
------------
|1.2       |
------------

-- Example 32862
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_double("a").alias("result")).show()
------------
|"RESULT"  |
------------
|1.2345    |
------------

-- Example 32863
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_integer("a").alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
------------

-- Example 32864
>>> df = session.sql("select 1.2345::variant as a")
>>> df.select(as_decimal("a", 4, 1).alias("result")).show()
------------
|"RESULT"  |
------------
|1.2       |
------------

-- Example 32865
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

-- Example 32866
>>> from snowflake.snowpark.types import VariantType, StructType, StructField, DoubleType
>>> schema=StructType([StructField("radius", DoubleType()),  StructField("radius_v", VariantType())])
>>> df = session.create_dataframe(data=[[2.0, None]], schema=schema)
>>> df.radius_v = to_variant(df.radius)
>>> df.select(df.radius_v.as_("radius_v"), df.radius).collect()
[Row(RADIUS_V='2.000000000000000e+00', RADIUS=2.0)]
>>> df.select(as_real(df.radius_v).as_("real_radius_v"), df.radius).collect()
[Row(REAL_RADIUS_V=2.0, RADIUS=2.0)]

-- Example 32867
>>> from snowflake.snowpark.functions import as_time, to_variant
>>> df = session.sql("select TO_TIME('12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_time(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

-- Example 32868
>>> from snowflake.snowpark.functions import as_timestamp_ltz, to_variant
>>> df = session.sql("select TO_TIMESTAMP_LTZ('2018-10-10 12:34:56') as alarm")
>>> df.alarm_v = to_variant(df.alarm)
>>> df.select(df.alarm_v.as_("alarm")).collect() == df.select(df.alarm).collect()
False
>>> df.select(as_timestamp_ltz(df.alarm_v).as_("alarm")).collect() == df.select(df.alarm).collect()
True

