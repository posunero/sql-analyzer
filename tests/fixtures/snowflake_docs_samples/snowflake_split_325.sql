-- Example 21753
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

-- Example 21754
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 21755
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.natural_join(df2).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

-- Example 21756
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

-- Example 21757
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

-- Example 21758
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

-- Example 21759
>>> create_result = session.sql('''create or replace temp table monthly_sales(empid int, amount int, month text)
... as select * from values
... (1, 10000, 'JAN'),
... (1, 400, 'JAN'),
... (2, 4500, 'JAN'),
... (2, 35000, 'JAN'),
... (1, 5000, 'FEB'),
... (1, 3000, 'FEB'),
... (2, 200, 'FEB') ''').collect()
>>> df = session.table("monthly_sales")
>>> df.pivot("month", ['JAN', 'FEB']).sum("amount").sort(df["empid"]).show()
-------------------------------
|"EMPID"  |"'JAN'"  |"'FEB'"  |
-------------------------------
|1        |10400    |8000     |
|2        |39500    |200      |
-------------------------------


>>> df = session.table("monthly_sales")
>>> df.pivot("month").sum("amount").sort("empid").show()
-------------------------------
|"EMPID"  |"'FEB'"  |"'JAN'"  |
-------------------------------
|1        |8000     |10400    |
|2        |200      |39500    |
-------------------------------


>>> subquery_df = session.table("monthly_sales").select(col("month")).filter(col("month") == "JAN")
>>> df = session.table("monthly_sales")
>>> df.pivot("month", values=subquery_df).sum("amount").sort("empid").show()
---------------------
|"EMPID"  |"'JAN'"  |
---------------------
|1        |10400    |
|2        |39500    |
---------------------

-- Example 21760
>>> df = session.create_dataframe([(1, "a"), (2, "b")], schema=["a", "b"])
>>> df.print_schema()
root
 |-- "A": LongType() (nullable = False)
 |-- "B": StringType() (nullable = False)

-- Example 21761
>>> df = session.create_dataframe([(1, "a"), (2, "b")], schema=["a", "b"])
>>> df.print_schema()
root
 |-- "A": LongType() (nullable = False)
 |-- "B": StringType() (nullable = False)

-- Example 21762
>>> df = session.range(10000)
>>> weights = [0.1, 0.2, 0.3]
>>> df_parts = df.random_split(weights)
>>> len(df_parts) == len(weights)
True

-- Example 21763
>>> df = session.range(10000)
>>> weights = [0.1, 0.2, 0.3]
>>> df_parts = df.random_split(weights)
>>> len(df_parts) == len(weights)
True

-- Example 21764
>>> # This example renames the column `A` as `NEW_A` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.rename(col("A"), "NEW_A")
>>> df_renamed.show()
-----------------
|"NEW_A"  |"B"  |
-----------------
|1        |2    |
-----------------

>>> # This example renames the column `A` as `NEW_A` and `B` as `NEW_B` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.rename({col("A"): "NEW_A", "B":"NEW_B"})
>>> df_renamed.show()
---------------------
|"NEW_A"  |"NEW_B"  |
---------------------
|1        |2        |
---------------------

-- Example 21765
>>> df = session.create_dataframe([[1, 1.0, "1.0"], [2, 2.0, "2.0"]], schema=["a", "b", "c"])
>>> # replace 1 with 3 in all columns
>>> df.na.replace(1, 3).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|2    |2.0  |2.0  |
-------------------

>>> # replace 1 with 3 and 2 with 4 in all columns
>>> df.na.replace([1, 2], [3, 4]).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|4    |4.0  |2.0  |
-------------------

>>> # replace 1 with 3 and 2 with 3 in all columns
>>> df.na.replace([1, 2], 3).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|3    |3.0  |2.0  |
-------------------

>>> # the following line intends to replaces 1 with 3 and 2 with 4 in all columns
>>> # and will give [Row(3, 3.0, "1.0"), Row(4, 4.0, "2.0")]
>>> df.na.replace({1: 3, 2: 4}).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|4    |4.0  |2.0  |
-------------------

>>> # the following line intends to replace 1 with "3" in column "a",
>>> # but will be ignored since "3" (str) doesn't match the original data type
>>> df.na.replace({1: "3"}, ["a"]).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |1.0  |1.0  |
|2    |2.0  |2.0  |
-------------------

-- Example 21766
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 21767
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 21768
>>> df = session.create_dataframe([[1, "some string value", 3, 4]], schema=["col1", "col2", "col3", "col4"])
>>> df_selected = df.select(col("col1"), col("col2").substr(0, 10), df["col3"] + df["col4"])

-- Example 21769
>>> df_selected = df.select("col1", "col2", "col3")

-- Example 21770
>>> df_selected = df.select(["col1", "col2", "col3"])

-- Example 21771
>>> df_selected = df.select(df["col1"], df.col2, df.col("col3"))

-- Example 21772
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df.select(df.col1, split_to_table(df.col2, lit(" ")), df.col("col3")).show()
-----------------------------------------------
|"COL1"  |"SEQ"  |"INDEX"  |"VALUE"  |"COL3"  |
-----------------------------------------------
|1       |1      |1        |some     |3       |
|1       |1      |2        |string   |3       |
|1       |1      |3        |value    |3       |
-----------------------------------------------

-- Example 21773
>>> df = session.create_dataframe([-1, 2, 3], schema=["a"])  # with one pair of [], the dataframe has a single column and 3 rows.
>>> df.select_expr("abs(a)", "a + 2", "cast(a as string)").show()
--------------------------------------------
|"ABS(A)"  |"A + 2"  |"CAST(A AS STRING)"  |
--------------------------------------------
|1         |1        |-1                   |
|2         |4        |2                    |
|3         |5        |3                    |
--------------------------------------------

-- Example 21774
>>> df = session.create_dataframe([-1, 2, 3], schema=["a"])  # with one pair of [], the dataframe has a single column and 3 rows.
>>> df.select_expr("abs(a)", "a + 2", "cast(a as string)").show()
--------------------------------------------
|"ABS(A)"  |"A + 2"  |"CAST(A AS STRING)"  |
--------------------------------------------
|1         |1        |-1                   |
|2         |4        |2                    |
|3         |5        |3                    |
--------------------------------------------

-- Example 21775
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

-- Example 21776
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 21777
>>> df1 = session.range(1, 10, 2).to_df("col1")
>>> df2 = session.range(1, 10, 2).to_df(["col1"])

-- Example 21778
>>> df = session.table("prices")
>>> for row in df.to_local_iterator():
...     print(row)
Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00'))
Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))

-- Example 21779
>>> df1 = session.range(1, 10, 2).to_df("col1")
>>> df2 = session.range(1, 10, 2).to_df(["col1"])

-- Example 21780
>>> df = session.table("prices")
>>> for row in df.to_local_iterator():
...     print(row)
Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00'))
Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))

-- Example 21781
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> for pandas_df in df.to_pandas_batches():
...     print(pandas_df)
   A  B
0  1  2
1  3  4

-- Example 21782
>>> df = session.create_dataframe([[1, 2, 3]], schema=["a", "b", "c"])
>>> snowpark_pandas_df = df.to_snowpark_pandas()  
>>> snowpark_pandas_df      
   A  B  C
0  1  2  3

-- Example 21783
>>> snowpark_pandas_df = df.to_snowpark_pandas(index_col='A')  
>>> snowpark_pandas_df      
   B  C
A
1  2  3
>>> snowpark_pandas_df = df.to_snowpark_pandas(index_col='A', columns=['B'])  
>>> snowpark_pandas_df      
   B
A
1  2
>>> snowpark_pandas_df = df.to_snowpark_pandas(index_col=['B', 'A'], columns=['A', 'C', 'A'])  
>>> snowpark_pandas_df      
     A  C  A
B A
2 1  1  3  1

-- Example 21784
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[0, 1], [3, 4]], schema=["c", "d"])
>>> df1.union(df2).sort("a").show()
-------------
|"A"  |"B"  |
-------------
|0    |1    |
|1    |2    |
|3    |4    |
-------------

-- Example 21785
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[0, 1], [3, 4]], schema=["c", "d"])
>>> df1.union_all(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
|0    |1    |
|3    |4    |
-------------

-- Example 21786
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_all_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |2    |
-------------

-- Example 21787
>>> df1 = session.create_dataframe([[1, 2], [1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1, 3]], schema=["b", "a", "c"])
>>> df1.union_all_by_name(df2, allow_missing_columns=True).show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |NULL  |
|1    |2    |NULL  |
|1    |2    |3     |
--------------------

-- Example 21788
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 21789
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1, 3]], schema=["b", "a", "c"])
>>> df1.union_by_name(df2, allow_missing_columns=True).sort("c").show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |NULL  |
|1    |2    |3     |
--------------------

-- Example 21790
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[0, 1], [3, 4]], schema=["c", "d"])
>>> df1.union_all(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
|0    |1    |
|3    |4    |
-------------

-- Example 21791
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_all_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |2    |
-------------

-- Example 21792
>>> df1 = session.create_dataframe([[1, 2], [1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1, 3]], schema=["b", "a", "c"])
>>> df1.union_all_by_name(df2, allow_missing_columns=True).show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |NULL  |
|1    |2    |NULL  |
|1    |2    |3     |
--------------------

-- Example 21793
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 21794
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1, 3]], schema=["b", "a", "c"])
>>> df1.union_by_name(df2, allow_missing_columns=True).sort("c").show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |NULL  |
|1    |2    |3     |
--------------------

-- Example 21795
>>> df = session.create_dataframe([
...     (1, 'electronics', 100, 200),
...     (2, 'clothes', 100, 300)
... ], schema=["empid", "dept", "jan", "feb"])
>>> df = df.unpivot("sales", "month", ["jan", "feb"]).sort("empid")
>>> df.show()
---------------------------------------------
|"EMPID"  |"DEPT"       |"MONTH"  |"SALES"  |
---------------------------------------------
|1        |electronics  |JAN      |100      |
|1        |electronics  |FEB      |200      |
|2        |clothes      |JAN      |100      |
|2        |clothes      |FEB      |300      |
---------------------------------------------

-- Example 21796
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df_filtered = df.filter((col("A") > 1) & (col("B") < 100))  # Must use parenthesis before and after operator &.

>>> # The following two result in the same SQL query:
>>> df.filter(col("a") > 1).collect()
[Row(A=3, B=4)]
>>> df.filter("a > 1").collect()  # use SQL expression
[Row(A=3, B=4)]

-- Example 21797
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_column("mean", (df["a"] + df["b"]) / 2).show()
------------------------
|"A"  |"B"  |"MEAN"    |
------------------------
|1    |2    |1.500000  |
|3    |4    |3.500000  |
------------------------

-- Example 21798
>>> from snowflake.snowpark.functions import udtf
>>> @udtf(output_schema=["number"])
... class sum_udtf:
...     def process(self, a: int, b: int) -> Iterable[Tuple[int]]:
...         yield (a + b, )
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_column("total", sum_udtf(df.a, df.b)).sort(df.a).show()
-----------------------
|"A"  |"B"  |"TOTAL"  |
-----------------------
|1    |2    |3        |
|3    |4    |7        |
-----------------------

-- Example 21799
>>> # This example renames the column `A` as `NEW_A` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.with_column_renamed(col("A"), "NEW_A")
>>> df_renamed.show()
-----------------
|"NEW_A"  |"B"  |
-----------------
|1        |2    |
-----------------

-- Example 21800
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_column("mean", (df["a"] + df["b"]) / 2).show()
------------------------
|"A"  |"B"  |"MEAN"    |
------------------------
|1    |2    |1.500000  |
|3    |4    |3.500000  |
------------------------

-- Example 21801
>>> from snowflake.snowpark.functions import udtf
>>> @udtf(output_schema=["number"])
... class sum_udtf:
...     def process(self, a: int, b: int) -> Iterable[Tuple[int]]:
...         yield (a + b, )
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_column("total", sum_udtf(df.a, df.b)).sort(df.a).show()
-----------------------
|"A"  |"B"  |"TOTAL"  |
-----------------------
|1    |2    |3        |
|3    |4    |7        |
-----------------------

-- Example 21802
>>> # This example renames the column `A` as `NEW_A` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.with_column_renamed(col("A"), "NEW_A")
>>> df_renamed.show()
-----------------
|"NEW_A"  |"B"  |
-----------------
|1        |2    |
-----------------

-- Example 21803
>>> from snowflake.snowpark.functions import udtf
>>> @udtf(output_schema=["number"])
... class sum_udtf:
...     def process(self, a: int, b: int) -> Iterable[Tuple[int]]:
...         yield (a + b, )
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_columns(["mean", "total"], [(df["a"] + df["b"]) / 2, sum_udtf(df.a, df.b)]).sort(df.a).show()
----------------------------------
|"A"  |"B"  |"MEAN"    |"TOTAL"  |
----------------------------------
|1    |2    |1.500000  |3        |
|3    |4    |3.500000  |7        |
----------------------------------

-- Example 21804
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.with_columns(["seq", "idx", "val"], [split_to_table(df.addresses, lit(" "))]).show()
------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"IDX"  |"VAL"     |
------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1      |address1  |
|James   |address1 address2 address3  |1      |2      |address2  |
|James   |address1 address2 address3  |1      |3      |address3  |
------------------------------------------------------------------

-- Example 21805
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

-- Example 21806
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

-- Example 21807
>>> df = session.create_dataframe([[1, 1.0, "1.0"], [2, 2.0, "2.0"]], schema=["a", "b", "c"])
>>> # replace 1 with 3 in all columns
>>> df.na.replace(1, 3).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|2    |2.0  |2.0  |
-------------------

>>> # replace 1 with 3 and 2 with 4 in all columns
>>> df.na.replace([1, 2], [3, 4]).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|4    |4.0  |2.0  |
-------------------

>>> # replace 1 with 3 and 2 with 3 in all columns
>>> df.na.replace([1, 2], 3).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|3    |3.0  |2.0  |
-------------------

>>> # the following line intends to replaces 1 with 3 and 2 with 4 in all columns
>>> # and will give [Row(3, 3.0, "1.0"), Row(4, 4.0, "2.0")]
>>> df.na.replace({1: 3, 2: 4}).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|4    |4.0  |2.0  |
-------------------

>>> # the following line intends to replace 1 with "3" in column "a",
>>> # but will be ignored since "3" (str) doesn't match the original data type
>>> df.na.replace({1: "3"}, ["a"]).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |1.0  |1.0  |
|2    |2.0  |2.0  |
-------------------

-- Example 21808
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 21809
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 21810
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
0.9999999999999991

-- Example 21811
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.cov("a", "b")
0.010000000000000037

-- Example 21812
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

-- Example 21813
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 21814
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 21815
>>> data = [
...     ["2023-01-01", 101, 200],
...     ["2023-01-02", 101, 100],
...     ["2023-01-03", 101, 300],
...     ["2023-01-04", 102, 250],
... ]
>>> df = session.create_dataframe(data).to_df(
...     "ORDERDATE", "PRODUCTKEY", "SALESAMOUNT"
... )
>>> result = df.analytics.moving_agg(
...     aggs={"SALESAMOUNT": ["SUM", "AVG"]},
...     window_sizes=[2, 3],
...     order_by=["ORDERDATE"],
...     group_by=["PRODUCTKEY"],
... )
>>> result.show()
--------------------------------------------------------------------------------------------------------------------------------------
|"ORDERDATE"  |"PRODUCTKEY"  |"SALESAMOUNT"  |"SALESAMOUNT_SUM_2"  |"SALESAMOUNT_AVG_2"  |"SALESAMOUNT_SUM_3"  |"SALESAMOUNT_AVG_3"  |
--------------------------------------------------------------------------------------------------------------------------------------
|2023-01-04   |102           |250            |250                  |250.000              |250                  |250.000              |
|2023-01-01   |101           |200            |200                  |200.000              |200                  |200.000              |
|2023-01-02   |101           |100            |300                  |150.000              |300                  |150.000              |
|2023-01-03   |101           |300            |400                  |200.000              |600                  |200.000              |
--------------------------------------------------------------------------------------------------------------------------------------

-- Example 21816
>>> sample_data = [
...     ["2023-01-01", 101, 200],
...     ["2023-01-02", 101, 100],
...     ["2023-01-03", 101, 300],
...     ["2023-01-04", 102, 250],
... ]
>>> df = session.create_dataframe(sample_data).to_df(
...     "ORDERDATE", "PRODUCTKEY", "SALESAMOUNT"
... )
>>> res = df.analytics.cumulative_agg(
...     aggs={"SALESAMOUNT": ["SUM", "MIN", "MAX"]},
...     group_by=["PRODUCTKEY"],
...     order_by=["ORDERDATE"],
...     is_forward=True
... )
>>> res.show()
----------------------------------------------------------------------------------------------------------
|"ORDERDATE"  |"PRODUCTKEY"  |"SALESAMOUNT"  |"SALESAMOUNT_SUM"  |"SALESAMOUNT_MIN"  |"SALESAMOUNT_MAX"  |
----------------------------------------------------------------------------------------------------------
|2023-01-03   |101           |300            |300                |300                |300                |
|2023-01-02   |101           |100            |400                |100                |300                |
|2023-01-01   |101           |200            |600                |100                |300                |
|2023-01-04   |102           |250            |250                |250                |250                |
----------------------------------------------------------------------------------------------------------

-- Example 21817
>>> sample_data = [
...     ["2023-01-01", 101, 200],
...     ["2023-01-02", 101, 100],
...     ["2023-01-03", 101, 300],
...     ["2023-01-04", 102, 250],
... ]
>>> df = session.create_dataframe(sample_data).to_df(
...     "ORDERDATE", "PRODUCTKEY", "SALESAMOUNT"
... )
>>> res = df.analytics.compute_lag(
...     cols=["SALESAMOUNT"],
...     lags=[1, 2],
...     order_by=["ORDERDATE"],
...     group_by=["PRODUCTKEY"],
... )
>>> res.show()
------------------------------------------------------------------------------------------
|"ORDERDATE"  |"PRODUCTKEY"  |"SALESAMOUNT"  |"SALESAMOUNT_LAG_1"  |"SALESAMOUNT_LAG_2"  |
------------------------------------------------------------------------------------------
|2023-01-04   |102           |250            |NULL                 |NULL                 |
|2023-01-01   |101           |200            |NULL                 |NULL                 |
|2023-01-02   |101           |100            |200                  |NULL                 |
|2023-01-03   |101           |300            |100                  |200                  |
------------------------------------------------------------------------------------------

-- Example 21818
>>> sample_data = [
...     ["2023-01-01", 101, 200],
...     ["2023-01-02", 101, 100],
...     ["2023-01-03", 101, 300],
...     ["2023-01-04", 102, 250],
... ]
>>> df = session.create_dataframe(sample_data).to_df(
...     "ORDERDATE", "PRODUCTKEY", "SALESAMOUNT"
... )
>>> res = df.analytics.compute_lead(
...     cols=["SALESAMOUNT"],
...     leads=[1, 2],
...     order_by=["ORDERDATE"],
...     group_by=["PRODUCTKEY"]
... )
>>> res.show()
--------------------------------------------------------------------------------------------
|"ORDERDATE"  |"PRODUCTKEY"  |"SALESAMOUNT"  |"SALESAMOUNT_LEAD_1"  |"SALESAMOUNT_LEAD_2"  |
--------------------------------------------------------------------------------------------
|2023-01-04   |102           |250            |NULL                  |NULL                  |
|2023-01-01   |101           |200            |100                   |300                   |
|2023-01-02   |101           |100            |300                   |NULL                  |
|2023-01-03   |101           |300            |NULL                  |NULL                  |
--------------------------------------------------------------------------------------------

-- Example 21819
>>> sample_data = [
...     ["2023-01-01", 101, 200],
...     ["2023-01-02", 101, 100],
...     ["2023-01-03", 101, 300],
...     ["2023-01-04", 102, 250],
... ]
>>> df = session.create_dataframe(sample_data).to_df(
...     "ORDERDATE", "PRODUCTKEY", "SALESAMOUNT"
... )
>>> df = df.with_column("ORDERDATE", to_timestamp(df["ORDERDATE"]))
>>> def custom_formatter(input_col, agg, window):
...     return f"{agg}_{input_col}_{window}"
>>> res = df.analytics.time_series_agg(
...     time_col="ORDERDATE",
...     group_by=["PRODUCTKEY"],
...     aggs={"SALESAMOUNT": ["SUM", "MAX"]},
...     windows=["1D", "-1D"],
...     sliding_interval="12H",
...     col_formatter=custom_formatter,
... )
>>> res.show()
----------------------------------------------------------------------------------------------------------------------------------------------------
|"PRODUCTKEY"  |"SALESAMOUNT"  |"ORDERDATE"          |"SUM_SALESAMOUNT_1D"  |"MAX_SALESAMOUNT_1D"  |"SUM_SALESAMOUNT_-1D"  |"MAX_SALESAMOUNT_-1D"  |
----------------------------------------------------------------------------------------------------------------------------------------------------
|102           |250            |2023-01-04 00:00:00  |250                   |250                   |250                    |250                    |
|101           |200            |2023-01-01 00:00:00  |300                   |200                   |200                    |200                    |
|101           |100            |2023-01-02 00:00:00  |400                   |300                   |300                    |200                    |
|101           |300            |2023-01-03 00:00:00  |300                   |300                   |400                    |300                    |
----------------------------------------------------------------------------------------------------------------------------------------------------

