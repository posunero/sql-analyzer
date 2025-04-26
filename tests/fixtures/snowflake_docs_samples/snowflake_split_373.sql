-- Example 24966
Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0

-- Example 24967
df.groupby(['Animal']).mean()

-- Example 24968
Max Speed
Animal
Falcon      375.0
Parrot       25.0

-- Example 24969
df = pd.DataFrame({"A": ["foo", "foo", "foo", "foo", "foo",
                        "bar", "bar", "bar", "bar"],
                "B": ["one", "one", "one", "two", "two",
                        "one", "one", "two", "two"],
                "C": ["small", "large", "large", "small",
                        "small", "large", "small", "small",
                        "large"],
                "D": [1, 2, 2, 3, 3, 4, 5, 6, 7],
                "E": [2, 4, 5, 5, 6, 6, 8, 9, 9]})
df

-- Example 24970
A    B      C  D  E
0  foo  one  small  1  2
1  foo  one  large  2  4
2  foo  one  large  2  5
3  foo  two  small  3  5
4  foo  two  small  3  6
5  bar  one  large  4  6
6  bar  one  small  5  8
7  bar  two  small  6  9
8  bar  two  large  7  9

-- Example 24971
pd.pivot_table(df, values='D', index=['A', 'B'],
                   columns=['C'], aggfunc="sum")

-- Example 24972
C    large  small
A   B
bar one    4.0      5
    two    7.0      6
foo one    4.0      1
    two    NaN      6

-- Example 24973
df = pd.DataFrame({'foo': ['one', 'one', 'one', 'two', 'two', 'two'],
                'bar': ['A', 'B', 'C', 'A', 'B', 'C'],
                'baz': [1, 2, 3, 4, 5, 6],
                'zoo': ['x', 'y', 'z', 'q', 'w', 't']})
df

-- Example 24974
foo bar  baz zoo
0  one   A    1   x
1  one   B    2   y
2  one   C    3   z
3  two   A    4   q
4  two   B    5   w
5  two   C    6   t

-- Example 24975
>>> session.sql("create or replace temp table prices(product_id varchar, amount number(10, 2))").collect()
[Row(status='Table PRICES successfully created.')]
>>> session.sql("insert into prices values ('id1', 10.0), ('id2', 20.0)").collect()
[Row(number of rows inserted=2)]
>>> # Create a CSV file to demo load
>>> import tempfile
>>> with tempfile.NamedTemporaryFile(mode="w+t") as t:
...     t.writelines(["id1, Product A", "\n" "id2, Product B"])
...     t.flush()
...     create_stage_result = session.sql("create temp stage test_stage").collect()
...     put_result = session.file.put(t.name, "@test_stage/test_dir")

-- Example 24976
>>> df_prices = session.table("prices")

-- Example 24977
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> df_catalog = session.read.schema(StructType([StructField("id", StringType()), StructField("name", StringType())])).csv("@test_stage/test_dir")
>>> df_catalog.show()
---------------------
|"ID"  |"NAME"      |
---------------------
|id1   | Product A  |
|id2   | Product B  |
---------------------

-- Example 24978
>>> session.create_dataframe([(1, "one"), (2, "two")], schema=["col_a", "col_b"]).show()
---------------------
|"COL_A"  |"COL_B"  |
---------------------
|1        |one      |
|2        |two      |
---------------------

>>> session.range(1, 10, 2).to_df("col1").show()
----------
|"COL1"  |
----------
|1       |
|3       |
|5       |
|7       |
|9       |
----------

-- Example 24979
>>> df_merged_data = df_catalog.join(df_prices, df_catalog["id"] == df_prices["product_id"])

-- Example 24980
>>> # Return a new DataFrame containing the product_id and amount columns of the prices table.
>>> # This is equivalent to: SELECT PRODUCT_ID, AMOUNT FROM PRICES;
>>> df_price_ids_and_amounts = df_prices.select(col("product_id"), col("amount"))

-- Example 24981
>>> # Return a new DataFrame containing the product_id column of the prices table as a column named
>>> # item_id. This is equivalent to: SELECT PRODUCT_ID AS ITEM_ID FROM PRICES;
>>> df_price_item_ids = df_prices.select(col("product_id").as_("item_id"))

-- Example 24982
>>> # Return a new DataFrame containing the row from the prices table with the ID 1.
>>> # This is equivalent to:
>>> # SELECT * FROM PRICES WHERE PRODUCT_ID = 1;
>>> df_price1 = df_prices.filter((col("product_id") == 1))

-- Example 24983
>>> # Return a new DataFrame for the prices table with the rows sorted by product_id.
>>> # This is equivalent to: SELECT * FROM PRICES ORDER BY PRODUCT_ID;
>>> df_sorted_prices = df_prices.sort(col("product_id"))

-- Example 24984
>>> import snowflake.snowpark.functions as f
>>> df_prices.agg(("amount", "sum")).collect()
[Row(SUM(AMOUNT)=Decimal('30.00'))]
>>> df_prices.agg(f.sum("amount")).collect()
[Row(SUM(AMOUNT)=Decimal('30.00'))]
>>> # rename the aggregation column name
>>> df_prices.agg(f.sum("amount").alias("total_amount"), f.max("amount").alias("max_amount")).collect()
[Row(TOTAL_AMOUNT=Decimal('30.00'), MAX_AMOUNT=Decimal('20.00'))]

-- Example 24985
>>> # Return a new DataFrame for the prices table that computes the sum of the prices by
>>> # category. This is equivalent to:
>>> #  SELECT CATEGORY, SUM(AMOUNT) FROM PRICES GROUP BY CATEGORY
>>> df_total_price_per_category = df_prices.group_by(col("product_id")).sum(col("amount"))
>>> # Have multiple aggregation values with the group by
>>> import snowflake.snowpark.functions as f
>>> df_summary = df_prices.group_by(col("product_id")).agg(f.sum(col("amount")).alias("total_amount"), f.avg("amount")).sort(col("product_id"))
>>> df_summary.show()
-------------------------------------------------
|"PRODUCT_ID"  |"TOTAL_AMOUNT"  |"AVG(AMOUNT)"  |
-------------------------------------------------
|id1           |10.00           |10.00000000    |
|id2           |20.00           |20.00000000    |
-------------------------------------------------

-- Example 24986
>>> from snowflake.snowpark import Window
>>> from snowflake.snowpark.functions import row_number
>>> df_prices.with_column("price_rank",  row_number().over(Window.order_by(col("amount").desc()))).show()
------------------------------------------
|"PRODUCT_ID"  |"AMOUNT"  |"PRICE_RANK"  |
------------------------------------------
|id2           |20.00     |1             |
|id1           |10.00     |2             |
------------------------------------------

-- Example 24987
>>> df = session.create_dataframe([[1, None, 3], [4, 5, None]], schema=["a", "b", "c"])
>>> df.na.fill({"b": 2, "c": 6}).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |3    |
|4    |5    |6    |
-------------------

-- Example 24988
>>> df_prices.collect()
[Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00')), Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))]

-- Example 24989
>>> df_prices.show()
---------------------------
|"PRODUCT_ID"  |"AMOUNT"  |
---------------------------
|id1           |10.00     |
|id2           |20.00     |
---------------------------

-- Example 24990
>>> df = session.create_dataframe([[1, 2], [3, 4], [5, -1]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
-0.5960395606792697

-- Example 24991
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6], [4.0, 6, 8]], schema=["a", "b", "c"])
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 24992
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 24993
>>> from snowflake.snowpark.functions import col, stddev, stddev_pop

>>> df = session.create_dataframe([[1, 2], [3, 4], [1, 4]], schema=["A", "B"])
>>> df.agg(stddev(col("a"))).show()
----------------------
|"STDDEV(A)"         |
----------------------
|1.1547003940416753  |
----------------------


>>> df.agg(stddev(col("a")), stddev_pop(col("a"))).show()
-------------------------------------------
|"STDDEV(A)"         |"STDDEV_POP(A)"     |
-------------------------------------------
|1.1547003940416753  |0.9428091005076267  |
-------------------------------------------


>>> df.agg(("a", "min"), ("b", "max")).show()
-----------------------
|"MIN(A)"  |"MAX(B)"  |
-----------------------
|1         |4         |
-----------------------


>>> df.agg({"a": "count", "b": "sum"}).show()
-------------------------
|"COUNT(A)"  |"SUM(B)"  |
-------------------------
|3           |10        |
-------------------------

-- Example 24994
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 24995
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 24996
>>> create_result = session.sql("create temp table RESULT (NUM int)").collect()
>>> insert_result = session.sql("insert into RESULT values(1),(2)").collect()

-- Example 24997
>>> df = session.table("RESULT")
>>> df.collect()
[Row(NUM=1), Row(NUM=2)]

-- Example 24998
>>> # Run cache_result and then insert into the original table to see
>>> # that the cached result is not affected
>>> df1 = df.cache_result()
>>> insert_again_result = session.sql("insert into RESULT values (3)").collect()
>>> df1.collect()
[Row(NUM=1), Row(NUM=2)]
>>> df.collect()
[Row(NUM=1), Row(NUM=2), Row(NUM=3)]

-- Example 24999
>>> # You can run cache_result on a result that has already been cached
>>> df2 = df1.cache_result()
>>> df2.collect()
[Row(NUM=1), Row(NUM=2)]

-- Example 25000
>>> df3 = df.cache_result()
>>> # Drop RESULT and see that the cached results still exist
>>> drop_table_result = session.sql(f"drop table RESULT").collect()
>>> df1.collect()
[Row(NUM=1), Row(NUM=2)]
>>> df2.collect()
[Row(NUM=1), Row(NUM=2)]
>>> df3.collect()
[Row(NUM=1), Row(NUM=2), Row(NUM=3)]
>>> # Clean up the cached result
>>> df3.drop_table()
>>> # use context manager to clean up the cached result after it's use.
>>> with df2.cache_result() as df4:
...     df4.collect()
[Row(NUM=1), Row(NUM=2)]

-- Example 25001
>>> # Create a CSV file to demo load
>>> import tempfile
>>> with tempfile.NamedTemporaryFile(mode="w+t") as t:
...     t.writelines(["id1, Product A", "\n" "id2, Product B"])
...     t.flush()
...     create_stage_result = session.sql("create temp stage if not exists test_stage").collect()
...     put_result = session.file.put(t.name, "@test_stage/copy_into_table_dir", overwrite=True)
>>> # user_schema is used to read from CSV files. For other files it's not needed.
>>> from snowflake.snowpark.types import StringType, StructField, StringType
>>> from snowflake.snowpark.functions import length
>>> user_schema = StructType([StructField("product_id", StringType()), StructField("product_name", StringType())])
>>> # Use the DataFrameReader (session.read below) to read from CSV files.
>>> df = session.read.schema(user_schema).csv("@test_stage/copy_into_table_dir")
>>> # specify target column names.
>>> target_column_names = ["product_id", "product_name"]
>>> drop_result = session.sql("drop table if exists copied_into_table").collect()  # The copy will recreate the table.
>>> copied_into_result = df.copy_into_table("copied_into_table", target_columns=target_column_names, force=True)
>>> session.table("copied_into_table").show()
---------------------------------
|"PRODUCT_ID"  |"PRODUCT_NAME"  |
---------------------------------
|id1           | Product A      |
|id2           | Product B      |
---------------------------------

-- Example 25002
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
0.9999999999999991

-- Example 25003
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.cov("a", "b")
0.010000000000000037

-- Example 25004
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[5, 6], [7, 8]], schema=["c", "d"])
>>> df1.cross_join(df2).sort("a", "b", "c", "d").show()
-------------------------
|"A"  |"B"  |"C"  |"D"  |
-------------------------
|1    |2    |5    |6    |
|1    |2    |7    |8    |
|3    |4    |5    |6    |
|3    |4    |7    |8    |
-------------------------

>>> df3 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df4 = session.create_dataframe([[5, 6], [7, 8]], schema=["a", "b"])
>>> df3.cross_join(df4, lsuffix="_l", rsuffix="_r").sort("a_l", "b_l", "a_r", "b_r").show()
---------------------------------
|"A_L"  |"B_L"  |"A_R"  |"B_R"  |
---------------------------------
|1      |2      |5      |6      |
|1      |2      |7      |8      |
|3      |4      |5      |6      |
|3      |4      |7      |8      |
---------------------------------

-- Example 25005
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[5, 6], [7, 8]], schema=["c", "d"])
>>> df1.cross_join(df2).sort("a", "b", "c", "d").show()
-------------------------
|"A"  |"B"  |"C"  |"D"  |
-------------------------
|1    |2    |5    |6    |
|1    |2    |7    |8    |
|3    |4    |5    |6    |
|3    |4    |7    |8    |
-------------------------

>>> df3 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df4 = session.create_dataframe([[5, 6], [7, 8]], schema=["a", "b"])
>>> df3.cross_join(df4, lsuffix="_l", rsuffix="_r").sort("a_l", "b_l", "a_r", "b_r").show()
---------------------------------
|"A_L"  |"B_L"  |"A_R"  |"B_R"  |
---------------------------------
|1      |2      |5      |6      |
|1      |2      |7      |8      |
|3      |4      |5      |6      |
|3      |4      |7      |8      |
---------------------------------

-- Example 25006
>>> df = session.create_dataframe([(1, 1), (1, 2), (2, 1), (2, 1), (2, 3), (3, 2), (3, 3)], schema=["key", "value"])
>>> ct = df.stat.crosstab("key", "value").sort(df["key"])
>>> ct.show()  
---------------------------------------------------------------------------------------------
|"KEY"  |"CAST(1 AS NUMBER(38,0))"  |"CAST(2 AS NUMBER(38,0))"  |"CAST(3 AS NUMBER(38,0))"  |
---------------------------------------------------------------------------------------------
|1      |1                          |1                          |0                          |
|2      |2                          |0                          |1                          |
|3      |0                          |1                          |1                          |
---------------------------------------------------------------------------------------------

-- Example 25007
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> desc_result = df.describe().sort("SUMMARY").show()
-------------------------------------------------------
|"SUMMARY"  |"A"                 |"B"                 |
-------------------------------------------------------
|count      |2.0                 |2.0                 |
|max        |3.0                 |4.0                 |
|mean       |2.0                 |3.0                 |
|min        |1.0                 |2.0                 |
|stddev     |1.4142135623730951  |1.4142135623730951  |
-------------------------------------------------------

-- Example 25008
>>> df = session.create_dataframe([[1, 2, 3]], schema=["a", "b", "c"])
>>> df.drop("a", "b").show()
-------
|"C"  |
-------
|3    |
-------

-- Example 25009
>>> df = session.create_dataframe([[1.0, 1], [float('nan'), 2], [None, 3], [4.0, None], [float('nan'), None]]).to_df("a", "b")
>>> # drop a row if it contains any nulls, with checking all columns
>>> df.na.drop().show()
-------------
|"A"  |"B"  |
-------------
|1.0  |1    |
-------------

>>> # drop a row only if all its values are null, with checking all columns
>>> df.na.drop(how='all').show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|nan   |2     |
|NULL  |3     |
|4.0   |NULL  |
---------------

>>> # drop a row if it contains at least one non-null and non-NaN values, with checking all columns
>>> df.na.drop(thresh=1).show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|nan   |2     |
|NULL  |3     |
|4.0   |NULL  |
---------------

>>> # drop a row if it contains any nulls, with checking column "a"
>>> df.na.drop(subset=["a"]).show()
--------------
|"A"  |"B"   |
--------------
|1.0  |1     |
|4.0  |NULL  |
--------------

>>> df.na.drop(subset="a").show()
--------------
|"A"  |"B"   |
--------------
|1.0  |1     |
|4.0  |NULL  |
--------------

-- Example 25010
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 25011
>>> df = session.create_dataframe([[1.0, 1], [float('nan'), 2], [None, 3], [4.0, None], [float('nan'), None]]).to_df("a", "b")
>>> # fill null and NaN values in all columns
>>> df.na.fill(3.14).show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|3.14  |2     |
|3.14  |3     |
|4.0   |NULL  |
|3.14  |NULL  |
---------------

>>> # fill null and NaN values in column "a"
>>> df.na.fill(3.14, subset="a").show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|3.14  |2     |
|3.14  |3     |
|4.0   |NULL  |
|3.14  |NULL  |
---------------

>>> # fill null and NaN values in column "a"
>>> df.na.fill({"a": 3.14}).show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|3.14  |2     |
|3.14  |3     |
|4.0   |NULL  |
|3.14  |NULL  |
---------------

>>> # fill null and NaN values in column "a" and "b"
>>> df.na.fill({"a": 3.14, "b": 15}).show()
--------------
|"A"   |"B"  |
--------------
|1.0   |1    |
|3.14  |2    |
|3.14  |3    |
|4.0   |15   |
|3.14  |15   |
--------------

>>> df2 = session.create_dataframe([[1.0, True], [2.0, False], [3.0, False], [None, None]]).to_df("a", "b")
>>> df2.na.fill(True).show()
----------------
|"A"   |"B"    |
----------------
|1.0   |True   |
|2.0   |False  |
|3.0   |False  |
|NULL  |True   |
----------------

-- Example 25012
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df_filtered = df.filter((col("A") > 1) & (col("B") < 100))  # Must use parenthesis before and after operator &.

>>> # The following two result in the same SQL query:
>>> df.filter(col("a") > 1).collect()
[Row(A=3, B=4)]
>>> df.filter("a > 1").collect()  # use SQL expression
[Row(A=3, B=4)]

-- Example 25013
>>> table1 = session.sql("select parse_json(numbers) as numbers from values('[1,2]') as T(numbers)")
>>> flattened = table1.flatten(table1["numbers"])
>>> flattened.select(table1["numbers"], flattened["value"].as_("flattened_number")).show()
----------------------------------
|"NUMBERS"  |"FLATTENED_NUMBER"  |
----------------------------------
|[          |1                   |
|  1,       |                    |
|  2        |                    |
|]          |                    |
|[          |2                   |
|  1,       |                    |
|  2        |                    |
|]          |                    |
----------------------------------

-- Example 25014
>>> from snowflake.snowpark.functions import col, lit, sum as sum_, max as max_
>>> df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> df.group_by().agg(sum_("b")).collect()
[Row(SUM(B)=9)]
>>> df.group_by("a").agg(sum_("b")).sort("a").collect()
[Row(A=1, SUM(B)=3), Row(A=2, SUM(B)=3), Row(A=3, SUM(B)=3)]
>>> df.group_by("a").agg(sum_("b").alias("sum_b"), max_("b").alias("max_b")).sort("a").collect()
[Row(A=1, SUM_B=3, MAX_B=2), Row(A=2, SUM_B=3, MAX_B=2), Row(A=3, SUM_B=3, MAX_B=2)]
>>> df.group_by(["a", lit("snow")]).agg(sum_("b")).sort("a").collect()
[Row(A=1, LITERAL()='snow', SUM(B)=3), Row(A=2, LITERAL()='snow', SUM(B)=3), Row(A=3, LITERAL()='snow', SUM(B)=3)]
>>> df.group_by("a").agg((col("*"), "count"), max_("b")).sort("a").collect()
[Row(A=1, COUNT(LITERAL())=2, MAX(B)=2), Row(A=2, COUNT(LITERAL())=2, MAX(B)=2), Row(A=3, COUNT(LITERAL())=2, MAX(B)=2)]
>>> df.group_by("a").median("b").sort("a").collect()
[Row(A=1, MEDIAN(B)=Decimal('1.500')), Row(A=2, MEDIAN(B)=Decimal('1.500')), Row(A=3, MEDIAN(B)=Decimal('1.500'))]
>>> df.group_by("a").function("avg")("b").sort("a").collect()
[Row(A=1, AVG(B)=Decimal('1.500000')), Row(A=2, AVG(B)=Decimal('1.500000')), Row(A=3, AVG(B)=Decimal('1.500000'))]

-- Example 25015
>>> from snowflake.snowpark.functions import col, lit, sum as sum_, max as max_
>>> df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> df.group_by().agg(sum_("b")).collect()
[Row(SUM(B)=9)]
>>> df.group_by("a").agg(sum_("b")).sort("a").collect()
[Row(A=1, SUM(B)=3), Row(A=2, SUM(B)=3), Row(A=3, SUM(B)=3)]
>>> df.group_by("a").agg(sum_("b").alias("sum_b"), max_("b").alias("max_b")).sort("a").collect()
[Row(A=1, SUM_B=3, MAX_B=2), Row(A=2, SUM_B=3, MAX_B=2), Row(A=3, SUM_B=3, MAX_B=2)]
>>> df.group_by(["a", lit("snow")]).agg(sum_("b")).sort("a").collect()
[Row(A=1, LITERAL()='snow', SUM(B)=3), Row(A=2, LITERAL()='snow', SUM(B)=3), Row(A=3, LITERAL()='snow', SUM(B)=3)]
>>> df.group_by("a").agg((col("*"), "count"), max_("b")).sort("a").collect()
[Row(A=1, COUNT(LITERAL())=2, MAX(B)=2), Row(A=2, COUNT(LITERAL())=2, MAX(B)=2), Row(A=3, COUNT(LITERAL())=2, MAX(B)=2)]
>>> df.group_by("a").median("b").sort("a").collect()
[Row(A=1, MEDIAN(B)=Decimal('1.500')), Row(A=2, MEDIAN(B)=Decimal('1.500')), Row(A=3, MEDIAN(B)=Decimal('1.500'))]
>>> df.group_by("a").function("avg")("b").sort("a").collect()
[Row(A=1, AVG(B)=Decimal('1.500000')), Row(A=2, AVG(B)=Decimal('1.500000')), Row(A=3, AVG(B)=Decimal('1.500000'))]

-- Example 25016
>>> from snowflake.snowpark import GroupingSets
>>> df = session.create_dataframe([[1, 2, 10], [3, 4, 20], [1, 4, 30]], schema=["A", "B", "C"])
>>> df.group_by_grouping_sets(GroupingSets([col("a")])).count().sort("a").collect()
[Row(A=1, COUNT=2), Row(A=3, COUNT=1)]
>>> df.group_by_grouping_sets(GroupingSets(col("a"))).count().sort("a").collect()
[Row(A=1, COUNT=2), Row(A=3, COUNT=1)]
>>> df.group_by_grouping_sets(GroupingSets([col("a")], [col("b")])).count().sort("a", "b").collect()
[Row(A=None, B=2, COUNT=1), Row(A=None, B=4, COUNT=2), Row(A=1, B=None, COUNT=2), Row(A=3, B=None, COUNT=1)]
>>> df.group_by_grouping_sets(GroupingSets([col("a"), col("b")], [col("c")])).count().sort("a", "b", "c").collect()
[Row(A=None, B=None, C=10, COUNT=1), Row(A=None, B=None, C=20, COUNT=1), Row(A=None, B=None, C=30, COUNT=1), Row(A=1, B=2, C=None, COUNT=1), Row(A=1, B=4, C=None, COUNT=1), Row(A=3, B=4, C=None, COUNT=1)]

-- Example 25017
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.intersect(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 25018
>>> from snowflake.snowpark.functions import col
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.join(df2, df1.a == df2.a).select(df1.a.alias("a_1"), df2.a.alias("a_2"), df1.b, df2.c).show()
-----------------------------
|"A_1"  |"A_2"  |"B"  |"C"  |
-----------------------------
|1      |1      |2    |7    |
|3      |3      |4    |8    |
-----------------------------

>>> # refer a single column "a"
>>> df1.join(df2, "a").select(df1.a.alias("a"), df1.b, df2.c).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

>>> # rename the ambiguous columns
>>> df3 = df1.to_df("df1_a", "b")
>>> df4 = df2.to_df("df2_a", "c")
>>> df3.join(df4, col("df1_a") == col("df2_a")).select(col("df1_a").alias("a"), "b", "c").show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

-- Example 25019
>>> # join multiple columns
>>> mdf1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> mdf2 = session.create_dataframe([[1, 2], [3, 4], [7, 6]], schema=["a", "b"])
>>> mdf1.join(mdf2, ["a", "b"]).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

>>> mdf1.join(mdf2, (mdf1["a"] < mdf2["a"]) & (mdf1["b"] == mdf2["b"])).select(mdf1["a"].as_("new_a"), mdf1["b"].as_("new_b")).show()
---------------------
|"NEW_A"  |"NEW_B"  |
---------------------
|5        |6        |
---------------------

>>> # use lsuffix and rsuffix to resolve duplicating column names
>>> mdf1.join(mdf2, (mdf1["a"] < mdf2["a"]) & (mdf1["b"] == mdf2["b"]), lsuffix="_left", rsuffix="_right").show()
-----------------------------------------------
|"A_LEFT"  |"B_LEFT"  |"A_RIGHT"  |"B_RIGHT"  |
-----------------------------------------------
|5         |6         |7          |6          |
-----------------------------------------------

>>> mdf1.join(mdf2, (mdf1["a"] < mdf2["a"]) & (mdf1["b"] == mdf2["b"]), rsuffix="_right").show()
-------------------------------------
|"A"  |"B"  |"A_RIGHT"  |"B_RIGHT"  |
-------------------------------------
|5    |6    |7          |6          |
-------------------------------------

>>> # examples of different joins
>>> df5 = session.create_dataframe([3, 4, 5, 5, 6, 7], schema=["id"])
>>> df6 = session.create_dataframe([5, 6, 7, 7, 8, 9], schema=["id"])
>>> # inner join
>>> df5.join(df6, "id", "inner").sort("id").show()
--------
|"ID"  |
--------
|5     |
|5     |
|6     |
|7     |
|7     |
--------

>>> # left/leftouter join
>>> df5.join(df6, "id", "left").sort("id").show()
--------
|"ID"  |
--------
|3     |
|4     |
|5     |
|5     |
|6     |
|7     |
|7     |
--------

>>> # right/rightouter join
>>> df5.join(df6, "id", "right").sort("id").show()
--------
|"ID"  |
--------
|5     |
|5     |
|6     |
|7     |
|7     |
|8     |
|9     |
--------

>>> # full/outer/fullouter join
>>> df5.join(df6, "id", "full").sort("id").show()
--------
|"ID"  |
--------
|3     |
|4     |
|5     |
|5     |
|6     |
|7     |
|7     |
|8     |
|9     |
--------

>>> # semi/leftsemi join
>>> df5.join(df6, "id", "semi").sort("id").show()
--------
|"ID"  |
--------
|5     |
|5     |
|6     |
|7     |
--------

>>> # anti/leftanti join
>>> df5.join(df6, "id", "anti").sort("id").show()
--------
|"ID"  |
--------
|3     |
|4     |
--------

-- Example 25020
>>> df1.filter(df1.a == 1).join(df2, df1.a == df2.a).select(df1.a.alias("a"), df1.b, df2.c)

-- Example 25021
>>> df1.join(df2, (df1.a == 1) & (df1.a == df2.a)).select(df1.a.alias("a"), df1.b, df2.c).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
-------------------

-- Example 25022
>>> df3 = df1.filter(df1.a == 1)
>>> df3.join(df2, df3.a == df2.a).select(df3.a.alias("a"), df3.b, df2.c).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
-------------------

-- Example 25023
>>> # asof join examples
>>> df1 = session.create_dataframe([['A', 1, 15, 3.21],
...                                 ['A', 2, 16, 3.22],
...                                 ['B', 1, 17, 3.23],
...                                 ['B', 2, 18, 4.23]],
...                                schema=["c1", "c2", "c3", "c4"])
>>> df2 = session.create_dataframe([['A', 1, 14, 3.19],
...                                 ['B', 2, 16, 3.04]],
...                                schema=["c1", "c2", "c3", "c4"])
>>> df1.join(df2, on=["c1", "c2"], how="asof", match_condition=(df1.c3 >= df2.c3)) \
...     .select(df1.c1, df1.c2, df1.c3.alias("C3_1"), df1.c4.alias("C4_1"), df2.c3.alias("C3_2"), df2.c4.alias("C4_2")) \
...     .order_by("c1", "c2").show()
---------------------------------------------------
|"C1"  |"C2"  |"C3_1"  |"C4_1"  |"C3_2"  |"C4_2"  |
---------------------------------------------------
|A     |1     |15      |3.21    |14      |3.19    |
|A     |2     |16      |3.22    |NULL    |NULL    |
|B     |1     |17      |3.23    |NULL    |NULL    |
|B     |2     |18      |4.23    |16      |3.04    |
---------------------------------------------------

>>> df1.join(df2, on=(df1.c1 == df2.c1) & (df1.c2 == df2.c2), how="asof",
...     match_condition=(df1.c3 >= df2.c3), lsuffix="_L", rsuffix="_R") \
...     .order_by("C1_L", "C2_L").show()
-------------------------------------------------------------------------
|"C1_L"  |"C2_L"  |"C3_L"  |"C4_L"  |"C1_R"  |"C2_R"  |"C3_R"  |"C4_R"  |
-------------------------------------------------------------------------
|A       |1       |15      |3.21    |A       |1       |14      |3.19    |
|A       |2       |16      |3.22    |NULL    |NULL    |NULL    |NULL    |
|B       |1       |17      |3.23    |NULL    |NULL    |NULL    |NULL    |
|B       |2       |18      |4.23    |B       |2       |16      |3.04    |
-------------------------------------------------------------------------

>>> df1 = df1.alias("L")
>>> df2 = df2.alias("R")
>>> df1.join(df2, using_columns=["c1", "c2"], how="asof",
...         match_condition=(df1.c3 >= df2.c3)).order_by("C1", "C2").show()
-----------------------------------------------
|"C1"  |"C2"  |"C3L"  |"C4L"  |"C3R"  |"C4R"  |
-----------------------------------------------
|A     |1     |15     |3.21   |14     |3.19   |
|A     |2     |16     |3.22   |NULL   |NULL   |
|B     |1     |17     |3.23   |NULL   |NULL   |
|B     |2     |18     |4.23   |16     |3.04   |
-----------------------------------------------

-- Example 25024
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.join_table_function("split_to_table", df["addresses"], lit(" ")).show()
--------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
--------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1        |address1  |
|James   |address1 address2 address3  |1      |2        |address2  |
|James   |address1 address2 address3  |1      |3        |address3  |
--------------------------------------------------------------------

-- Example 25025
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.join_table_function(split_to_table(df["addresses"], lit(" "))).show()
--------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
--------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1        |address1  |
|James   |address1 address2 address3  |1      |2        |address2  |
|James   |address1 address2 address3  |1      |3        |address3  |
--------------------------------------------------------------------

-- Example 25026
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.create_dataframe([
...     ["John", "James", "address1 address2 address3"],
...     ["Mike", "James", "address4 address5 address6"],
...     ["Cathy", "Stone", "address4 address5 address6"],
... ],
... schema=["first_name", "last_name", "addresses"])
>>> df.join_table_function(split_to_table(df["addresses"], lit(" ")).over(partition_by="last_name", order_by="first_name")).show()
----------------------------------------------------------------------------------------
|"FIRST_NAME"  |"LAST_NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
----------------------------------------------------------------------------------------
|John          |James        |address1 address2 address3  |1      |1        |address1  |
|John          |James        |address1 address2 address3  |1      |2        |address2  |
|John          |James        |address1 address2 address3  |1      |3        |address3  |
|Mike          |James        |address4 address5 address6  |2      |1        |address4  |
|Mike          |James        |address4 address5 address6  |2      |2        |address5  |
|Mike          |James        |address4 address5 address6  |2      |3        |address6  |
|Cathy         |Stone        |address4 address5 address6  |3      |1        |address4  |
|Cathy         |Stone        |address4 address5 address6  |3      |2        |address5  |
|Cathy         |Stone        |address4 address5 address6  |3      |3        |address6  |
----------------------------------------------------------------------------------------

-- Example 25027
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.join_table_function(split_to_table(col("addresses"), lit(" ")).alias("seq", "idx", "val")).show()
------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"IDX"  |"VAL"     |
------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1      |address1  |
|James   |address1 address2 address3  |1      |2      |address2  |
|James   |address1 address2 address3  |1      |3      |address3  |
------------------------------------------------------------------

-- Example 25028
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.limit(1).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

>>> df.limit(1, offset=1).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 25029
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 25030
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.natural_join(df2).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

-- Example 25031
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.natural_join(df2, "left").show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |7     |
|3    |4    |8     |
|5    |6    |NULL  |
--------------------

-- Example 25032
>>> from snowflake.snowpark.functions import col

>>> df = session.create_dataframe([[1, 2], [3, 4], [1, 4]], schema=["A", "B"])
>>> df.sort(col("A"), col("B").asc()).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------


>>> df.sort(col("a"), ascending=False).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
|1    |2    |
|1    |4    |
-------------


>>> # The values from the list overwrite the column ordering.
>>> df.sort(["a", col("b").desc()], ascending=[1, 1]).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------

