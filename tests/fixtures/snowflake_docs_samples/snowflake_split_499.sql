-- Example 33405
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_all_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |2    |
-------------

-- Example 33406
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

-- Example 33407
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 33408
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1, 3]], schema=["b", "a", "c"])
>>> df1.union_by_name(df2, allow_missing_columns=True).sort("c").show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |NULL  |
|1    |2    |3     |
--------------------

-- Example 33409
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

-- Example 33410
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_all_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |2    |
-------------

-- Example 33411
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

-- Example 33412
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1]], schema=["b", "a"])
>>> df1.union_by_name(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 33413
>>> df1 = session.create_dataframe([[1, 2]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[2, 1, 3]], schema=["b", "a", "c"])
>>> df1.union_by_name(df2, allow_missing_columns=True).sort("c").show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |NULL  |
|1    |2    |3     |
--------------------

-- Example 33414
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

-- Example 33415
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df_filtered = df.filter((col("A") > 1) & (col("B") < 100))  # Must use parenthesis before and after operator &.

>>> # The following two result in the same SQL query:
>>> df.filter(col("a") > 1).collect()
[Row(A=3, B=4)]
>>> df.filter("a > 1").collect()  # use SQL expression
[Row(A=3, B=4)]

-- Example 33416
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_column("mean", (df["a"] + df["b"]) / 2).show()
------------------------
|"A"  |"B"  |"MEAN"    |
------------------------
|1    |2    |1.500000  |
|3    |4    |3.500000  |
------------------------

-- Example 33417
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

-- Example 33418
>>> # This example renames the column `A` as `NEW_A` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.with_column_renamed(col("A"), "NEW_A")
>>> df_renamed.show()
-----------------
|"NEW_A"  |"B"  |
-----------------
|1        |2    |
-----------------

-- Example 33419
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.with_column("mean", (df["a"] + df["b"]) / 2).show()
------------------------
|"A"  |"B"  |"MEAN"    |
------------------------
|1    |2    |1.500000  |
|3    |4    |3.500000  |
------------------------

-- Example 33420
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

-- Example 33421
>>> # This example renames the column `A` as `NEW_A` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.with_column_renamed(col("A"), "NEW_A")
>>> df_renamed.show()
-----------------
|"NEW_A"  |"B"  |
-----------------
|1        |2    |
-----------------

-- Example 33422
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

-- Example 33423
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

-- Example 33424
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

-- Example 33425
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

-- Example 33426
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

-- Example 33427
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 33428
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 33429
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
0.9999999999999991

-- Example 33430
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.cov("a", "b")
0.010000000000000037

-- Example 33431
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

-- Example 33432
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 33433
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 33434
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

-- Example 33435
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

-- Example 33436
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

-- Example 33437
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

-- Example 33438
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

-- Example 33439
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

-- Example 33440
>>> new_df = map(df, lambda row: (row[1], row[0] * 3), output_types=[StringType(), IntegerType()])
>>> new_df.order_by("c_1").show()
-----------------
|"C_1"  |"C_2"  |
-----------------
|a      |30     |
|b      |60     |
-----------------

-- Example 33441
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

-- Example 33442
>>> new_df = map(df, lambda pdf: pdf['COL1']*3, output_types=[IntegerType()], vectorized=True, packages=["pandas"])
>>> new_df.order_by("c_1").show()
---------
|"C_1"  |
---------
|30     |
|60     |
---------

-- Example 33443
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

-- Example 33444
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

-- Example 33445
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

-- Example 33446
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

-- Example 33447
>>> from snowflake.snowpark.functions import lit
>>> df.select(col("name"), lit("const value").alias("literal_column")).collect()
[Row(NAME='John', LITERAL_COLUMN='const value'), Row(NAME='Mike', LITERAL_COLUMN='const value')]

-- Example 33448
>>> df = session.create_dataframe([[20, 5], [1, 2]], schema=["a", "b"])
>>> df.filter((col("a") == 20) | (col("b") <= 10)).collect()  # use parentheses before and after the | operator.
[Row(A=20, B=5), Row(A=1, B=2)]
>>> df.filter((df["a"] + df.b) < 10).collect()
[Row(A=1, B=2)]
>>> df.select((col("b") * 10).alias("c")).collect()
[Row(C=50), Row(C=20)]

-- Example 33449
>>> from snowflake.snowpark.types import StringType, IntegerType
>>> df_with_semi_data = session.create_dataframe([[{"k1": "v1", "k2": "v2"}, ["a0", 1, "a2"]]], schema=["object_column", "array_column"])
>>> df_with_semi_data.select(df_with_semi_data["object_column"]["k1"].alias("k1_value"), df_with_semi_data["array_column"][0].alias("a0_value"), df_with_semi_data["array_column"][1].alias("a1_value")).collect()
[Row(K1_VALUE='"v1"', A0_VALUE='"a0"', A1_VALUE='1')]
>>> # The above two returned string columns have JSON literal values because children of semi-structured data are semi-structured.
>>> # The next line converts JSON literal to a string
>>> df_with_semi_data.select(df_with_semi_data["object_column"]["k1"].cast(StringType()).alias("k1_value"), df_with_semi_data["array_column"][0].cast(StringType()).alias("a0_value"), df_with_semi_data["array_column"][1].cast(IntegerType()).alias("a1_value")).collect()
[Row(K1_VALUE='v1', A0_VALUE='a0', A1_VALUE=1)]

-- Example 33450
>>> from snowflake.snowpark.functions import when, col, lit

>>> df = session.create_dataframe([[None], [1], [2]], schema=["a"])
>>> df.select(when(col("a").is_null(), lit(1)) \
...     .when(col("a") == 1, lit(2)) \
...     .otherwise(lit(3)).alias("case_when_column")).collect()
[Row(CASE_WHEN_COLUMN=1), Row(CASE_WHEN_COLUMN=2), Row(CASE_WHEN_COLUMN=3)]

-- Example 33451
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

-- Example 33452
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

-- Example 33453
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

-- Example 33454
>>> string_t = StringType(23)  # this can be used to create a string type column which holds at most 23 chars
>>> string_t = StringType()    # this can be used to create a string type column with maximum allowed length

-- Example 33455
>>> row = Row(name1=1, name2=2, name3=Row(childname=3))
>>> row.as_dict()
{'name1': 1, 'name2': 2, 'name3': Row(childname=3)}
>>> row.as_dict(True)
{'name1': 1, 'name2': 2, 'name3': {'childname': 3}}

-- Example 33456
>>> row = Row(name1=1, name2=2, name3=Row(childname=3))
>>> row.as_dict()
{'name1': 1, 'name2': 2, 'name3': Row(childname=3)}
>>> row.as_dict(True)
{'name1': 1, 'name2': 2, 'name3': {'childname': 3}}

-- Example 33457
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

-- Example 33458
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df.select(sql_expr("a + 1").as_("c"), sql_expr("a = 1").as_("d")).collect()  # use SQL expression
[Row(C=2, D=True), Row(C=4, D=False)]

-- Example 33459
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

-- Example 33460
>>> from snowflake.snowpark.functions import lit
>>> split_to_table = table_function("split_to_table")
>>> session.table_function(split_to_table(lit("split words to table"), lit(" ")).over()).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 33461
>>> from snowflake.snowpark.functions import lit
>>> session.table_function(call_table_function("split_to_table", lit("split words to table"), lit(" ")).over()).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 33462
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
>>> df.select(lead("Z").over(Window.partition_by(col("X")).order_by(col("Y"))).alias("result")).collect()
[Row(RESULT=1), Row(RESULT=3), Row(RESULT=None), Row(RESULT=3), Row(RESULT=None)]

-- Example 33463
>>> df = session.create_dataframe(['12', '11.3', '-90.12345'], schema=['a'])
>>> df.select(to_decimal(col('a'), 38, 0).as_('ans')).collect()
[Row(ANS=12), Row(ANS=11), Row(ANS=-90)]

-- Example 33464
>>> df.select(to_decimal(col('a'), 38, 2).as_('ans')).collect()
[Row(ANS=Decimal('12.00')), Row(ANS=Decimal('11.30')), Row(ANS=Decimal('-90.12'))]

-- Example 33465
>>> df = session.create_dataframe([[-1]], schema=["a"])
>>> df.select(abs(col("a")).alias("result")).show()
------------
|"RESULT"  |
------------
|1         |
------------

-- Example 33466
>>> from snowflake.snowpark.types import DecimalType
>>> df = session.create_dataframe([[0.5]], schema=["deg"])
>>> df.select(acos(col("deg")).cast(DecimalType(scale=3)).alias("result")).show()
------------
|"RESULT"  |
------------
|1.047     |
------------

-- Example 33467
>>> df = session.create_dataframe([2.352409615], schema=["a"])
>>> df.select(acosh("a").as_("acosh")).collect()
[Row(ACOSH=1.4999999998857607)]

-- Example 33468
>>> import datetime
>>> df = session.create_dataframe([datetime.date(2022, 4, 6)], schema=["d"])
>>> df.select(add_months("d", 4)).collect()[0][0]
datetime.date(2022, 8, 6)

-- Example 33469
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

-- Example 33470
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

-- Example 33471
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

