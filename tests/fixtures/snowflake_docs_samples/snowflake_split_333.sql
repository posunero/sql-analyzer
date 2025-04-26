-- Example 22289
>>> from snowflake.snowpark.types import IntegerType, DoubleType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> def group_sum(pdf):
...     return pd.DataFrame([(pdf.GRADE.iloc[0], pdf.DIVISION.iloc[0], pdf.VALUE.sum(), )])
...
>>> df = session.createDataFrame([('A', 2, 11.0), ('A', 2, 13.9), ('B', 5, 5.0), ('B', 2, 12.1)],
...                              schema=["grade", "division", "value"])
>>> df.group_by([df.grade, df.division] ).applyInPandas(
...     group_sum,
...     output_schema=StructType([StructField("grade", StringType()),
...                                        StructField("division", IntegerType()),
...                                        StructField("sum", DoubleType())]),
...                is_permanent=True, stage_location="@mystage", name="group_sum_in_pandas", replace=True
...            ).order_by("sum").show()
--------------------------------
|"GRADE"  |"DIVISION"  |"SUM"  |
--------------------------------
|B        |5           |5.0    |
|B        |2           |12.1   |
|A        |2           |24.9   |
--------------------------------

-- Example 22290
>>> target_df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t = session.table("my_table")

>>> # delete all rows in a table
>>> t.delete()
DeleteResult(rows_deleted=6)
>>> t.collect()
[]

>>> # delete all rows where column "a" has value 1
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t.delete(t["a"] == 1)
DeleteResult(rows_deleted=2)
>>> t.sort("a", "b").collect()
[Row(A=2, B=1), Row(A=2, B=2), Row(A=3, B=1), Row(A=3, B=2)]

>>> # delete all rows in this table where column "a" in this
>>> # table is equal to column "a" in another dataframe
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> source_df = session.create_dataframe([2, 3, 4, 5], schema=["a"])
>>> t.delete(t["a"] == source_df.a, source_df)
DeleteResult(rows_deleted=4)
>>> t.sort("a", "b").collect()
[Row(A=1, B=1), Row(A=1, B=2)]

-- Example 22291
>>> from snowflake.snowpark.functions import when_matched, when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == "too_old"),
...              [when_matched().update({"value": source["value"]}), when_not_matched().insert({"key": source["key"]})])
MergeResult(rows_inserted=2, rows_updated=1, rows_deleted=0)
>>> target.sort("key", "value").collect()
[Row(KEY=10, VALUE='new'), Row(KEY=10, VALUE='old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE=None), Row(KEY=13, VALUE=None)]

-- Example 22292
>>> target_df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t = session.table("my_table")

>>> # update all rows in column "b" to 0 and all rows in column "a"
>>> # to the summation of column "a" and column "b"
>>> t.update({"b": 0, "a": t.a + t.b})
UpdateResult(rows_updated=6, multi_joined_rows_updated=0)
>>> t.sort("a", "b").collect()
[Row(A=2, B=0), Row(A=3, B=0), Row(A=3, B=0), Row(A=4, B=0), Row(A=4, B=0), Row(A=5, B=0)]

>>> # update all rows in column "b" to 0 where column "a" has value 1
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> t.update({"b": 0}, t["a"] == 1)
UpdateResult(rows_updated=2, multi_joined_rows_updated=0)
>>> t.sort("a", "b").collect()
[Row(A=1, B=0), Row(A=1, B=0), Row(A=2, B=1), Row(A=2, B=2), Row(A=3, B=1), Row(A=3, B=2)]

>>> # update all rows in column "b" to 0 where column "a" in this
>>> # table is equal to column "a" in another dataframe
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> source_df = session.create_dataframe([1, 2, 3, 4], schema=["a"])
>>> t.update({"b": 0}, t["a"] == source_df.a, source_df)
UpdateResult(rows_updated=6, multi_joined_rows_updated=0)
>>> t.sort("a", "b").collect()
[Row(A=1, B=0), Row(A=1, B=0), Row(A=2, B=0), Row(A=2, B=0), Row(A=3, B=0), Row(A=3, B=0)]

-- Example 22293
>>> # Adds a matched clause where a row in source is matched
>>> # if its key is equal to the key of any row in target.
>>> # For all such rows, delete them.
>>> from snowflake.snowpark.functions import when_matched
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=["key", "value"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new")], schema=["key", "value"])
>>> target.merge(source, target["key"] == source["key"], [when_matched().delete()])
MergeResult(rows_inserted=0, rows_updated=0, rows_deleted=2)
>>> target.collect() # the rows are deleted
[Row(KEY=11, VALUE='old')]

-- Example 22294
>>> # Adds a matched clause where a row in source is matched
>>> # if its key is equal to the key of any row in target.
>>> # For all such rows, update its value to the value of the
>>> # corresponding row in source.
>>> from snowflake.snowpark.functions import when_matched, lit
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=["key", "value"])
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new")], schema=["key", "value"])
>>> target.merge(source, (target["key"] == source["key"]) & (target["value"] == lit("too_old")), [when_matched().update({"value": source["value"]})])
MergeResult(rows_inserted=0, rows_updated=1, rows_deleted=0)
>>> target.sort("key", "value").collect() # the value in the table is updated
[Row(KEY=10, VALUE='new'), Row(KEY=10, VALUE='old'), Row(KEY=11, VALUE='old')]

-- Example 22295
>>> # Adds a not-matched clause where a row in source is not matched
>>> # if its key does not equal the key of any row in target.
>>> # For all such rows, insert a row into target whose ley and value
>>> # are assigned to the key and value of the not matched row.
>>> from snowflake.snowpark.functions import when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")

>>> source = session.create_dataframe([(12, "new")], schema=schema)
>>> target.merge(source, target["key"] == source["key"], [when_not_matched().insert([source["key"], source["value"]])])
MergeResult(rows_inserted=1, rows_updated=0, rows_deleted=0)
>>> target.sort("key", "value").collect() # the rows are inserted
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='too_old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE='new')]

>>> # For all such rows, insert a row into target whose key is
>>> # assigned to the key of the not matched row.
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target.merge(source, target["key"] == source["key"], [when_not_matched().insert({"key": source["key"]})])
MergeResult(rows_inserted=1, rows_updated=0, rows_deleted=0)
>>> target.sort("key", "value").collect() # the rows are inserted
[Row(KEY=10, VALUE='old'), Row(KEY=10, VALUE='too_old'), Row(KEY=11, VALUE='old'), Row(KEY=12, VALUE=None)]

-- Example 22296
>>> from snowflake.snowpark.functions import when_matched, when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6],[4.0,6,8]], schema=["a", "b", "c"])

-- Example 22297
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 22298
>>> async_job = df.collect(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 22299
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 22300
>>> async_job = df.first(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5)]

-- Example 22301
>>> async_job = df.count(block=False)
>>> async_job.result()
4

-- Example 22302
>>> table_name = "name"
>>> async_job = df.write.save_as_table(table_name, block=False)
>>> # copy into a stage file
>>> remote_location = f"{session.get_session_stage()}/name.csv"
>>> async_job = df.write.copy_into_location(remote_location, block=False)
>>> async_job.result()[0]['rows_unloaded']
4

-- Example 22303
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> async_job = target.merge(source,target["key"] == source["key"],[when_matched().update({"value": source["value"]}),when_not_matched().insert({"key": source["key"]})],block=False)
>>> async_job.result()
MergeResult(rows_inserted=2, rows_updated=2, rows_deleted=0)

-- Example 22304
>>> df = session.sql("select SYSTEM$WAIT(3)")
>>> async_job = df.collect_nowait()
>>> async_job.cancel()

-- Example 22305
>>> from snowflake.snowpark.functions import col
>>> query_id = session.sql("select 1 as A, 2 as B, 3 as C").collect_nowait().query_id
>>> async_job = session.create_async_job(query_id)
>>> async_job.query 
'select 1 as A, 2 as B, 3 as C'
>>> async_job.result()
[Row(A=1, B=2, C=3)]
>>> async_job.result(result_type="pandas")
   A  B  C
0  1  2  3
>>> df = async_job.to_df()
>>> df.select(col("A").as_("D"), "B").collect()
[Row(D=1, B=2)]

-- Example 22306
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>>
>>> def my_copy(session: snowflake.snowpark.Session, from_table: str, to_table: str, count: int) -> str:
...     session.table(from_table).limit(count).write.save_as_table(to_table)
...     return "SUCCESS"
>>>
>>> my_copy_sp = session.sproc.register(my_copy, name="my_copy_sp", replace=True)
>>> _ = session.sql("create or replace temp table test_from(test_str varchar) as select randstr(20, random()) from table(generator(rowCount => 100))").collect()
>>>
>>> # call using sql
>>> _ = session.sql("drop table if exists test_to").collect()
>>> session.sql("call my_copy_sp('test_from', 'test_to', 10)").collect()
[Row(MY_COPY_SP='SUCCESS')]
>>> session.table("test_to").count()
10
>>> # call using session.call API
>>> _ = session.sql("drop table if exists test_to").collect()
>>> session.call("my_copy_sp", "test_from", "test_to", 10)
'SUCCESS'
>>> session.table("test_to").count()
10

-- Example 22307
>>> from snowflake.snowpark.functions import sproc
>>> from snowflake.snowpark.types import IntegerType
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> add_one_sp = sproc(
...     lambda session_, x: session_.sql(f"select {x} + 1").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType()]
... )
>>> add_one_sp(1)
2

-- Example 22308
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> @sproc
... def add_sp(session_: snowflake.snowpark.Session, x: int, y: int) -> int:
...    return session_.sql(f"select {x} + {y}").collect()[0][0]
>>> add_sp(1, 2)
3

-- Example 22309
>>> from snowflake.snowpark.types import IntegerType
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.sproc.register(
...     lambda session_, x, y: session_.sql(f"SELECT {x} * {y}").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True,
...     name="mul_sp",
...     replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("call mul_sp(5, 6)").collect()
[Row(MUL_SP=30)]
>>> # skip stored proc creation if it already exists
>>> _ = session.sproc.register(
...     lambda session_, x, y: session_.sql(f"SELECT {x} * {y} + 1").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True,
...     name="mul_sp",
...     if_not_exists=True,
...     stage_location="@mystage",
... )
>>> session.sql("call mul_sp(5, 6)").collect()
[Row(MUL_SP=30)]
>>> # overwrite stored procedure
>>> _ = session.sproc.register(
...     lambda session_, x, y: session_.sql(f"SELECT {x} * {y} + 1").collect()[0][0],
...     return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True,
...     name="mul_sp",
...     replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("call mul_sp(5, 6)").collect()
[Row(MUL_SP=31)]

-- Example 22310
>>> import snowflake.snowpark
>>> from resources.test_sp_dir.test_sp_file import mod5
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> @sproc(imports=[("tests/resources/test_sp_dir/test_sp_file.py", "resources.test_sp_dir.test_sp_file")])
... def mod5_and_plus1_sp(session_: snowflake.snowpark.Session, x: int) -> int:
...     return mod5(session_, x) + 1
>>> mod5_and_plus1_sp(2)
3

-- Example 22311
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>> import numpy as np
>>> import math
>>>
>>> @sproc(packages=["snowflake-snowpark-python", "numpy"])
... def sin_sp(_: snowflake.snowpark.Session, x: float) -> float:
...     return np.sin(x)
>>> sin_sp(0.5 * math.pi)
1.0

-- Example 22312
>>> session.add_packages('snowflake-snowpark-python')
>>> # mod5() in that file has type hints
>>> mod5_sp = session.sproc.register_from_file(
...     file_path="tests/resources/test_sp_dir/test_sp_file.py",
...     func_name="mod5",
... )
>>> mod5_sp(2)
2

-- Example 22313
>>> from snowflake.snowpark.types import IntegerType
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.file.put("tests/resources/test_sp_dir/test_sp_file.py", "@mystage", auto_compress=False)
>>> mod5_sp = session.sproc.register_from_file(
...     file_path="@mystage/test_sp_file.py",
...     func_name="mod5",
...     return_type=IntegerType(),
...     input_types=[IntegerType()],
... )
>>> mod5_sp(2)
2

-- Example 22314
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> @sproc(return_type=StructType([StructField("A", IntegerType()), StructField("B", IntegerType())]), input_types=[IntegerType(), IntegerType()])
... def select_sp(session_, x, y):
...     return session_.sql(f"SELECT {x} as A, {y} as B")
...
>>> select_sp(1, 2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 22315
>>> from snowflake.snowpark.types import IntegerType, StructType
>>> @sproc(return_type=StructType(), input_types=[IntegerType(), IntegerType()])
... def select_sp(session_, x, y):
...     return session_.sql(f"SELECT {x} as A, {y} as B")
...
>>> select_sp(1, 2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 22316
>>> from snowflake.snowpark.dataframe import DataFrame
>>> @sproc
... def select_sp(session_: snowflake.snowpark.Session, x: int, y: int) -> DataFrame:
...     return session_.sql(f"SELECT {x} as A, {y} as B")
...
>>> select_sp(1, 2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 22317
>>> import numpy
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> a = 1
>>> def f():
...     return 2
>>>
>>> from snowflake.snowpark.functions import udf
>>> session.add_import("tests/resources/test_udf_dir/test_udf_file.py", import_path="resources.test_udf_dir.test_udf_file")
>>> session.add_packages("numpy")
>>> @udf
... def g(x: int) -> int:
...     return mod5(numpy.square(x)) + a + f()
>>> df = session.create_dataframe([4], schema=["a"])
>>> df.select(g("a")).to_df("col1").show()
----------
|"COL1"  |
----------
|4       |
----------

-- Example 22318
>>> from snowflake.snowpark.types import IntegerType
>>> from snowflake.snowpark.functions import udf
>>> add_one_udf = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()])
>>> session.range(1, 8, 2).select(add_one_udf("id")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=4), Row(COL1=6), Row(COL1=8)]

-- Example 22319
>>> from snowflake.snowpark.functions import udf
>>> @udf
... def add_udf(x: int, y: int) -> int:
...        return x + y
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["x", "y"])
>>> df.select(add_udf("x", "y")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]

-- Example 22320
>>> from snowflake.snowpark.types import IntegerType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.udf.register(
...     lambda x, y: x * y, return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True, name="mul", replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("select mul(5, 6) as mul").collect()
[Row(MUL=30)]
>>> # skip udf creation if it already exists
>>> _ = session.udf.register(
...     lambda x, y: x * y + 1, return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True, name="mul", if_not_exists=True,
...     stage_location="@mystage",
... )
>>> session.sql("select mul(5, 6) as mul").collect()
[Row(MUL=30)]
>>> # overwrite udf definition when it already exists
>>> _ = session.udf.register(
...     lambda x, y: x * y + 1, return_type=IntegerType(),
...     input_types=[IntegerType(), IntegerType()],
...     is_permanent=True, name="mul", replace=True,
...     stage_location="@mystage",
... )
>>> session.sql("select mul(5, 6) as mul").collect()
[Row(MUL=31)]

-- Example 22321
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> from snowflake.snowpark.functions import udf
>>> @udf(imports=[("tests/resources/test_udf_dir/test_udf_file.py", "resources.test_udf_dir.test_udf_file")])
... def mod5_and_plus1_udf(x: int) -> int:
...     return mod5(x) + 1
>>> session.range(1, 8, 2).select(mod5_and_plus1_udf("id")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=4), Row(COL1=1), Row(COL1=3)]

-- Example 22322
>>> from snowflake.snowpark.functions import udf
>>> import numpy as np
>>> import math
>>> @udf(packages=["numpy"])
... def sin_udf(x: float) -> float:
...     return np.sin(x)
>>> df = session.create_dataframe([0.0, 0.5 * math.pi], schema=["d"])
>>> df.select(sin_udf("d")).to_df("col1").collect()
[Row(COL1=0.0), Row(COL1=1.0)]

-- Example 22323
>>> # mod5() in that file has type hints
>>> mod5_udf = session.udf.register_from_file(
...     file_path="tests/resources/test_udf_dir/test_udf_file.py",
...     func_name="mod5",
... )
>>> session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 22324
>>> from snowflake.snowpark.types import IntegerType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.file.put("tests/resources/test_udf_dir/test_udf_file.py", "@mystage", auto_compress=False)
>>> mod5_udf = session.udf.register_from_file(
...     file_path="@mystage/test_udf_file.py",
...     func_name="mod5",
...     return_type=IntegerType(),
...     input_types=[IntegerType()],
... )
>>> session.range(1, 8, 2).select(mod5_udf("id")).to_df("col1").collect()
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]

-- Example 22325
>>> import sys
>>> import os
>>> import cachetools
>>> from snowflake.snowpark.types import StringType
>>> @cachetools.cached(cache={})
... def read_file(filename):
...     import_dir = sys._xoptions.get("snowflake_import_directory")
...     if import_dir:
...         with open(os.path.join(import_dir, filename), "r") as f:
...             return f.read()
>>>
>>> # create a temporary text file for test
>>> temp_file_name = "/tmp/temp.txt"
>>> with open(temp_file_name, "w") as t:
...     _ = t.write("snowpark")
>>> session.add_import(temp_file_name)
>>> session.add_packages("cachetools")
>>> concat_file_content_with_str_udf = session.udf.register(
...     lambda s: f"{read_file(os.path.basename(temp_file_name))}-{s}",
...     return_type=StringType(),
...     input_types=[StringType()]
... )
>>>
>>> df = session.create_dataframe(["snowflake", "python"], schema=["a"])
>>> df.select(concat_file_content_with_str_udf("a")).to_df("col1").collect()
[Row(COL1='snowpark-snowflake'), Row(COL1='snowpark-python')]
>>> os.remove(temp_file_name)
>>> session.clear_imports()

-- Example 22326
>>> from snowflake.snowpark.functions import udf
>>> from snowflake.snowpark.types import IntegerType, PandasSeriesType, PandasDataFrameType
>>> df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
>>> add_udf1 = udf(lambda series1, series2: series1 + series2, return_type=PandasSeriesType(IntegerType()),
...               input_types=[PandasSeriesType(IntegerType()), PandasSeriesType(IntegerType())],
...               max_batch_size=20)
>>> df.select(add_udf1("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]
>>> add_udf2 = udf(lambda df: df[0] + df[1], return_type=PandasSeriesType(IntegerType()),
...               input_types=[PandasDataFrameType([IntegerType(), IntegerType()])],
...               max_batch_size=20)
>>> df.select(add_udf2("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]

-- Example 22327
>>> from snowflake.snowpark.functions import udf
>>> from snowflake.snowpark.types import PandasSeries, PandasDataFrame
>>> @udf
... def apply_mod5_udf(series: PandasSeries[int]) -> PandasSeries[int]:
...     return series.apply(lambda x: x % 5)
>>> session.range(1, 8, 2).select(apply_mod5_udf("id")).to_df("col1").collect()
[Row(COL1=1), Row(COL1=3), Row(COL1=0), Row(COL1=2)]
>>> @udf
... def mul_udf(df: PandasDataFrame[int, int]) -> PandasSeries[int]:
...     return df[0] * df[1]
>>> df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
>>> df.select(mul_udf("a", "b")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=12)]

-- Example 22328
>>> # `pandas_udf` is an alias of `udf`, but it can only be used to create a vectorized UDF
>>> from snowflake.snowpark.functions import pandas_udf
>>> from snowflake.snowpark.types import IntegerType
>>> import pandas as pd
>>> df = session.create_dataframe([[1, 2], [3, 4]]).to_df("a", "b")
>>> def add1(series1: pd.Series, series2: pd.Series) -> pd.Series:
...     return series1 + series2
>>> add_udf1 = pandas_udf(add1, return_type=IntegerType(),
...                       input_types=[IntegerType(), IntegerType()])
>>> df.select(add_udf1("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]
>>> def add2(df: pd.DataFrame) -> pd.Series:
...     return df[0] + df[1]
>>> add_udf2 = pandas_udf(add2, return_type=IntegerType(),
...                       input_types=[IntegerType(), IntegerType()])
>>> df.select(add_udf2("a", "b")).to_df("add_result").collect()
[Row(ADD_RESULT=3), Row(ADD_RESULT=7)]

-- Example 22329
>>> from snowflake.snowpark.types import IntegerType
>>> from snowflake.snowpark.functions import call_function, col, udaf
>>> class PythonSumUDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self):
...         return self._sum
...
...     def accumulate(self, input_value):
...         self._sum += input_value
...
...     def merge(self, other_sum):
...         self._sum += other_sum
...
...     def finish(self):
...         return self._sum

-- Example 22330
>>> sum_udaf = udaf(PythonSumUDAF, return_type=IntegerType(), input_types=[IntegerType()])
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(sum_udaf("a").alias("sum_a")).collect()  # Query it by calling it
[Row(SUM_A=6)]
>>> df.select(call_function(sum_udaf.name, col("a")).alias("sum_a")).collect()  # Query it by using the name
[Row(SUM_A=6)]

-- Example 22331
>>> from snowflake.snowpark.functions import udaf
>>> @udaf
... class PythonSumUDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self) -> int:
...         return self._sum
...
...     def accumulate(self, input_value: int) -> None:
...         self._sum += input_value
...
...     def merge(self, other_sum: int) -> None:
...         self._sum += other_sum
...
...     def finish(self) -> int:
...         return self._sum
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(PythonSumUDAF("a").alias("sum_a")).collect()  # Query it by calling it
[Row(SUM_A=6)]
>>> df.select(call_function(PythonSumUDAF.name, col("a")).alias("sum_a")).collect()  # Query it by using the name
[Row(SUM_A=6)]

-- Example 22332
>>> from snowflake.snowpark.functions import udaf
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> @udaf(is_permanent=True, name="sum_udaf", replace=True, stage_location="@mystage")
... class PythonSumUDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self) -> int:
...         return self._sum
...
...     def accumulate(self, input_value: int) -> None:
...         self._sum += input_value
...
...     def merge(self, other_sum: int) -> None:
...         self._sum += other_sum
...
...     def finish(self) -> int:
...         return self._sum
>>> session.sql("select sum_udaf(column1) as sum1 from values (1, 2), (2, 3)").collect()
[Row(SUM1=3)]

-- Example 22333
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> from snowflake.snowpark.functions import udaf
>>> @udaf(imports=[("tests/resources/test_udf_dir/test_udf_file.py", "resources.test_udf_dir.test_udf_file")])
... class SumMod5UDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self) -> int:
...         return self._sum
...
...     def accumulate(self, input_value: int) -> None:
...         self._sum = mod5(self._sum + input_value)
...
...     def merge(self, other_sum: int) -> None:
...         self._sum = mod5(self._sum + other_sum)
...
...     def finish(self) -> int:
...         return self._sum
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(SumMod5UDAF("a").alias("sum_mod5_a")).collect()
[Row(SUM_MOD5_A=1)]

-- Example 22334
>>> import math
>>> from snowflake.snowpark.functions import udaf
>>> import numpy as np
>>> @udaf(packages=["numpy"])
... class SumSinUDAF:
...     def __init__(self) -> None:
...         self._sum = 0
...
...     @property
...     def aggregate_state(self) -> float:
...         return self._sum
...
...     def accumulate(self, input_value: float) -> None:
...         self._sum += input_value
...
...     def merge(self, other_sum: float) -> None:
...         self._sum += other_sum
...
...     def finish(self) -> float:
...         return np.sin(self._sum)
>>> df = session.create_dataframe([[0.0], [0.5 * math.pi]]).to_df("a")
>>> df.agg(SumSinUDAF("a").alias("sum_sin_a")).collect()
[Row(SUM_SIN_A=1.0)]

-- Example 22335
>>> sum_udaf = session.udaf.register_from_file(
...     file_path="tests/resources/test_udaf_dir/test_udaf_file.py",
...     handler_name="MyUDAFWithTypeHints",
... )
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(sum_udaf("a").alias("sum_a")).collect()
[Row(SUM_A=6)]

-- Example 22336
>>> from snowflake.snowpark.functions import udaf
>>> from snowflake.snowpark.types import IntegerType
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.file.put("tests/resources/test_udaf_dir/test_udaf_file.py", "@mystage", auto_compress=False)
>>> sum_udaf = session.udaf.register_from_file(
...     file_path="@mystage/test_udaf_file.py",
...     handler_name="MyUDAFWithoutTypeHints",
...     input_types=[IntegerType()],
...     return_type=IntegerType(),
... )
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(sum_udaf("a").alias("sum_a")).collect()
[Row(SUM_A=6)]

-- Example 22337
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> class GeneratorUDTF:
...     def process(self, n):
...         for i in range(n):
...             yield (i, )
>>> generator_udtf = udtf(GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
>>> session.table_function(generator_udtf(lit(3))).collect()  # Query it by calling it
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]
>>> session.table_function(generator_udtf.name, lit(3)).collect()  # Query it by using the name
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]
>>> # Or you can lateral-join a UDTF like any other table functions
>>> df = session.create_dataframe([2, 3], schema=["c"])
>>> df.join_table_function(generator_udtf(df["c"])).sort("c", "number").show()
------------------
|"C"  |"NUMBER"  |
------------------
|2    |0         |
|2    |1         |
|3    |0         |
|3    |1         |
|3    |2         |
------------------

-- Example 22338
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> @udtf(output_schema=["number"])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int]]:
...         for i in range(n):
...             yield (i, )
>>> session.table_function(generator_udtf(lit(3))).collect()  # Query it by calling it
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]
>>> session.table_function(generator_udtf.name, lit(3)).collect()  # Query it by using the name
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 22339
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> class GeneratorUDTF:
...     def process(self, n):
...         for i in range(n):
...             yield (i, )
>>> generator_udtf = udtf(
...     GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()],
...     is_permanent=True, name="generator_udtf", replace=True, stage_location="@mystage"
... )
>>> session.sql("select * from table(generator_udtf(3))").collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 22340
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> @udtf(output_schema=["n1", "n2"])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int, int]]:
...         for i in range(n):
...             yield (i, i+1)
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(N1=0, N2=1), Row(N1=1, N2=2), Row(N1=2, N2=3)]

-- Example 22341
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> @udtf(output_schema=["n1", "n2"])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int, ...]]:
...         for i in range(n):
...             yield (i, i+1)
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(N1=0, N2=1), Row(N1=1, N2=2), Row(N1=2, N2=3)]

-- Example 22342
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> @udtf(output_schema=["number"], imports=[("tests/resources/test_udf_dir/test_udf_file.py", "resources.test_udf_dir.test_udf_file")])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int]]:
...         for i in range(n):
...             yield (mod5(i), )
>>> session.table_function(generator_udtf(lit(6))).collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2), Row(NUMBER=3), Row(NUMBER=4), Row(NUMBER=0)]

-- Example 22343
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> import numpy as np
>>> @udtf(output_schema=["number"], packages=["numpy"])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int]]:
...         for i in np.arange(n):
...             yield (i, )
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 22344
>>> from collections import Counter
>>> from typing import Iterable, Tuple
>>> from snowflake.snowpark.functions import lit
>>> class MyWordCount:
...     def __init__(self) -> None:
...         self._total_per_partition = 0
...
...     def process(self, s1: str) -> Iterable[Tuple[str, int]]:
...         words = s1.split()
...         self._total_per_partition = len(words)
...         counter = Counter(words)
...         yield from counter.items()
...
...     def end_partition(self):
...         yield ("partition_total", self._total_per_partition)

-- Example 22345
>>> udtf_name = "word_count_udtf"
>>> word_count_udtf = session.udtf.register(
...     MyWordCount, ["word", "count"], name=udtf_name, is_permanent=False, replace=True
... )
>>> # Call it by its name
>>> df1 = session.table_function(udtf_name, lit("w1 w2 w2 w3 w3 w3"))
>>> df1.show()
-----------------------------
|"WORD"           |"COUNT"  |
-----------------------------
|w1               |1        |
|w2               |2        |
|w3               |3        |
|partition_total  |6        |
-----------------------------

-- Example 22346
>>> # Call it by the returned callable instance
>>> df2 = session.table_function(word_count_udtf(lit("w1 w2 w2 w3 w3 w3")))
>>> df2.show()
-----------------------------
|"WORD"           |"COUNT"  |
-----------------------------
|w1               |1        |
|w2               |2        |
|w3               |3        |
|partition_total  |6        |
-----------------------------

-- Example 22347
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> generator_udtf = session.udtf.register_from_file(
...     file_path="tests/resources/test_udtf_dir/test_udtf_file.py",
...     handler_name="GeneratorUDTF",
...     output_schema=StructType([StructField("number", IntegerType())]),
...     input_types=[IntegerType()]
... )
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 22348
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> _ = session.file.put("tests/resources/test_udtf_dir/test_udtf_file.py", "@mystage", auto_compress=False)
>>> generator_udtf = session.udtf.register_from_file(
...     file_path="@mystage/test_udtf_file.py",
...     handler_name="GeneratorUDTF",
...     output_schema=StructType([StructField("number", IntegerType())]),
...     input_types=[IntegerType()]
... )
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 22349
>>> from snowflake.snowpark.types import PandasDataFrameType, IntegerType, StringType, FloatType
>>> class multiply:
...     def __init__(self):
...         self.multiplier = 10
...     def end_partition(self, df):
...         df.col1 = df.col1*self.multiplier
...         df.col2 = df.col2*self.multiplier
...         yield df
>>> multiply_udtf = session.udtf.register(
...     multiply,
...     output_schema=PandasDataFrameType([StringType(), IntegerType(), FloatType()], ["id_", "col1_", "col2_"]),
...     input_types=[PandasDataFrameType([StringType(), IntegerType(), FloatType()])],
...     input_names = ['"id"', '"col1"', '"col2"'],
... )
>>> df = session.create_dataframe([['x', 3, 35.9],['x', 9, 20.5]], schema=["id", "col1", "col2"])
>>> df.select(multiply_udtf("id", "col1", "col2").over(partition_by=["id"])).sort("col1_").show()
-----------------------------
|"ID_"  |"COL1_"  |"COL2_"  |
-----------------------------
|x      |30       |359.0    |
|x      |90       |205.0    |
-----------------------------

-- Example 22350
>>> from snowflake.snowpark.types import PandasDataFrame
>>> class multiply:
...     def __init__(self):
...         self.multiplier = 10
...     def end_partition(self, df: PandasDataFrame[str, int, float]) -> PandasDataFrame[str, int, float]:
...         df.col1 = df.col1*self.multiplier
...         df.col2 = df.col2*self.multiplier
...         yield df
>>> multiply_udtf = session.udtf.register(
...     multiply,
...     output_schema=["id_", "col1_", "col2_"],
...     input_names = ['"id"', '"col1"', '"col2"'],
... )
>>> df = session.create_dataframe([['x', 3, 35.9],['x', 9, 20.5]], schema=["id", "col1", "col2"])
>>> df.select(multiply_udtf("id", "col1", "col2").over(partition_by=["id"])).sort("col1_").show()
-----------------------------
|"ID_"  |"COL1_"  |"COL2_"  |
-----------------------------
|x      |30       |359.0    |
|x      |90       |205.0    |
-----------------------------

-- Example 22351
>>> import pandas as pd
>>> from snowflake.snowpark.types import IntegerType, StringType, FloatType, StructType, StructField
>>> class multiply:
...     def __init__(self):
...         self.multiplier = 10
...     def end_partition(self, df: pd.DataFrame) -> pd.DataFrame:
...         df.col1 = df.col1*self.multiplier
...         df.col2 = df.col2*self.multiplier
...         yield df
>>> multiply_udtf = session.udtf.register(
...     multiply,
...     output_schema=StructType([StructField("id_", StringType()), StructField("col1_", IntegerType()), StructField("col2_", FloatType())]),
...     input_types=[StringType(), IntegerType(), FloatType()],
...     input_names = ['"id"', '"col1"', '"col2"'],
... )
>>> df = session.create_dataframe([['x', 3, 35.9],['x', 9, 20.5]], schema=["id", "col1", "col2"])
>>> df.select(multiply_udtf("id", "col1", "col2").over(partition_by=["id"])).sort("col1_").show()
-----------------------------
|"ID_"  |"COL1_"  |"COL2_"  |
-----------------------------
|x      |30       |359.0    |
|x      |90       |205.0    |
-----------------------------

-- Example 22352
>>> from snowflake.snowpark.types import PandasDataFrameType, IntegerType, StringType, FloatType
>>> class multiply:
...     def __init__(self):
...         self.multiplier = 10
...     def end_partition(self, df):
...         df.columns = ["id", "col1", "col2"]
...         df.col1 = df.col1*self.multiplier
...         df.col2 = df.col2*self.multiplier
...         yield df
>>> multiply_udtf = session.udtf.register(
...     multiply,
...     output_schema=PandasDataFrameType([StringType(), IntegerType(), FloatType()], ["id_", "col1_", "col2_"]),
...     input_types=[PandasDataFrameType([StringType(), IntegerType(), FloatType()])],
... )
>>> df = session.create_dataframe([['x', 3, 35.9],['x', 9, 20.5]], schema=["id", "col1", "col2"])
>>> df.select(multiply_udtf("id", "col1", "col2").over(partition_by=["id"])).sort("col1_").show()
-----------------------------
|"ID_"  |"COL1_"  |"COL2_"  |
-----------------------------
|x      |30       |359.0    |
|x      |90       |205.0    |
-----------------------------

-- Example 22353
>>> class multiply:
...     def process(self, df: PandasDataFrame[str,int, float]) -> PandasDataFrame[int]:
...         return (df['col1'] * 10, )
>>> multiply_udtf = session.udtf.register(
...     multiply,
...     output_schema=["col1x10"],
...     input_names=['"id"', '"col1"', '"col2"']
... )
>>> df = session.create_dataframe([['x', 3, 35.9],['x', 9, 20.5]], schema=["id", "col1", "col2"])
>>> df.select("id", "col1", "col2", multiply_udtf("id", "col1", "col2")).order_by("col1").show()
--------------------------------------
|"ID"  |"COL1"  |"COL2"  |"COL1X10"  |
--------------------------------------
|x     |3       |35.9    |30         |
|x     |9       |20.5    |90         |
--------------------------------------

-- Example 22354
>>> class mean:
...     def __init__(self) -> None:
...         self.sum = 0
...         self.len = 0
...     def process(self, df: pd.DataFrame) -> pd.DataFrame:
...         self.sum += df['value'].sum()
...         self.len += len(df)
...         return ([None] * len(df),)
...     def end_partition(self):
...         return ([self.sum / self.len],)
>>> mean_udtf = session.udtf.register(mean,
...                       output_schema=StructType([StructField("mean", FloatType())]),
...                       input_types=[StringType(), IntegerType()],
...                       input_names=['"name"', '"value"'])
>>> df = session.create_dataframe([["x", 10], ["x", 20], ["x", 33], ["y", 10], ["y", 25], ], schema=["name", "value"])
>>> df.select("name", "value", mean_udtf("name", "value").over(partition_by="name")).order_by("name", "value").show()
-----------------------------
|"NAME"  |"VALUE"  |"MEAN"  |
-----------------------------
|x       |NULL     |21.0    |
|x       |10       |NULL    |
|x       |20       |NULL    |
|x       |33       |NULL    |
|y       |NULL     |17.5    |
|y       |10       |NULL    |
|y       |25       |NULL    |
-----------------------------

-- Example 22355
>>> class sum:
...     def __init__(self):
...         self.sum = None
...     def process(self, df):
...         if self.sum is None:
...             self.sum = df
...         else:
...             self.sum += df
...         return df
...     def end_partition(self):
...         return self.sum
>>> sum_udtf = session.udtf.register(sum,
...         output_schema=PandasDataFrameType([StringType(), IntegerType()], ["id_", "col1_"]),
...         input_types=[PandasDataFrameType([StringType(), IntegerType()])],
...         max_batch_size=1)
>>> df = session.create_dataframe([["x", 10], ["x", 20], ["x", 33], ["y", 10], ["y", 25], ], schema=["id", "col1"])
>>> df.select("id", "col1", sum_udtf("id", "col1").over(partition_by="id")).order_by("id", "col1").show()
-----------------------------------
|"ID"  |"COL1"  |"ID_"  |"COL1_"  |
-----------------------------------
|x     |NULL    |xxx    |63       |
|x     |10      |x      |10       |
|x     |20      |x      |20       |
|x     |33      |x      |33       |
|y     |NULL    |yy     |35       |
|y     |10      |y      |10       |
|y     |25      |y      |25       |
-----------------------------------

