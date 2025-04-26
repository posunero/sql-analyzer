-- Example 33271
>>> session.add_packages('snowflake-snowpark-python')
>>> # mod5() in that file has type hints
>>> mod5_sp = session.sproc.register_from_file(
...     file_path="tests/resources/test_sp_dir/test_sp_file.py",
...     func_name="mod5",
... )
>>> mod5_sp(2)
2

-- Example 33272
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

-- Example 33273
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

-- Example 33274
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

-- Example 33275
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

-- Example 33276
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

-- Example 33277
>>> sum_udaf = udaf(PythonSumUDAF, return_type=IntegerType(), input_types=[IntegerType()])
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(sum_udaf("a").alias("sum_a")).collect()  # Query it by calling it
[Row(SUM_A=6)]
>>> df.select(call_function(sum_udaf.name, col("a")).alias("sum_a")).collect()  # Query it by using the name
[Row(SUM_A=6)]

-- Example 33278
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

-- Example 33279
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

-- Example 33280
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

-- Example 33281
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

-- Example 33282
>>> sum_udaf = session.udaf.register_from_file(
...     file_path="tests/resources/test_udaf_dir/test_udaf_file.py",
...     handler_name="MyUDAFWithTypeHints",
... )
>>> df = session.create_dataframe([[1, 3], [1, 4], [2, 5], [2, 6]]).to_df("a", "b")
>>> df.agg(sum_udaf("a").alias("sum_a")).collect()
[Row(SUM_A=6)]

-- Example 33283
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

-- Example 33284
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

-- Example 33285
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

-- Example 33286
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

-- Example 33287
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> @udtf(output_schema=["n1", "n2"])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int, int]]:
...         for i in range(n):
...             yield (i, i+1)
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(N1=0, N2=1), Row(N1=1, N2=2), Row(N1=2, N2=3)]

-- Example 33288
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> @udtf(output_schema=["n1", "n2"])
... class generator_udtf:
...     def process(self, n: int) -> Iterable[Tuple[int, ...]]:
...         for i in range(n):
...             yield (i, i+1)
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(N1=0, N2=1), Row(N1=1, N2=2), Row(N1=2, N2=3)]

-- Example 33289
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

-- Example 33290
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

-- Example 33291
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

-- Example 33292
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

-- Example 33293
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

-- Example 33294
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

-- Example 33295
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

-- Example 33296
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

-- Example 33297
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

-- Example 33298
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

-- Example 33299
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

-- Example 33300
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

-- Example 33301
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

-- Example 33302
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

-- Example 33303
>>> db = session.get_current_database().replace('"', "")
>>> schema = session.get_current_schema().replace('"', "")
>>> _ = session.sql(f"CREATE OR REPLACE TABLE {db}.{schema}.T1(C1 INT)").collect()
>>> _ = session.sql(
...     f"CREATE OR REPLACE VIEW {db}.{schema}.V1 AS SELECT * FROM {db}.{schema}.T1"
... ).collect()
>>> _ = session.sql(
...     f"CREATE OR REPLACE VIEW {db}.{schema}.V2 AS SELECT * FROM {db}.{schema}.V1"
... ).collect()
>>> df = session.lineage.trace(
...     f"{db}.{schema}.T1",
...     "table",
...     direction="downstream"
... )
>>> df.show() 
-------------------------------------------------------------------------------------------------------------------------------------------------
| "SOURCE_OBJECT"                                         | "TARGET_OBJECT"                                        | "DIRECTION"   | "DISTANCE" |
-------------------------------------------------------------------------------------------------------------------------------------------------
| {"createdOn": "2023-11-15T12:30:23Z", "domain": "TABLE",| {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW",| "Downstream"  | 1          |
|  "name": "YOUR_DATABASE.YOUR_SCHEMA.T1", "status":      |  "name": "YOUR_DATABASE.YOUR_SCHEMA.V1", "status":     |               |            |
|  "ACTIVE"}                                              |  "ACTIVE"}                                             |               |            |
| {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW", | {"createdOn": "2023-11-15T12:30:23Z", "domain": "VIEW",| "Downstream"  | 2          |
|  "name": "YOUR_DATABASE.YOUR_SCHEMA.V1", "status":      |  "name": "YOUR_DATABASE.YOUR_SCHEMA.V2", "status":     |               |            |
|  "ACTIVE"}                                              |  "ACTIVE"}                                             |               |            |
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 33304
>>> from snowflake.snowpark.testing import assert_dataframe_equal
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, DoubleType
>>> schema1 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", DoubleType())
... ])
>>> data1 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0]]
>>> df1 = session.create_dataframe(data1, schema1)
>>> df2 = session.create_dataframe(data1, schema1)
>>> assert_dataframe_equal(df2, df1)  # pass, DataFrames are identical

>>> data2 = [[2, "Saka", 2.0], [1, "Rice", 1.0], [3, "White", 3.0]]  # change the order
>>> df3 = session.create_dataframe(data2, schema1)
>>> assert_dataframe_equal(df3, df1)  # pass, DataFrames are identical

>>> data3 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [4, "Rowe", 4.0]]
>>> df4 = session.create_dataframe(data3, schema1)
>>> assert_dataframe_equal(df4, df1)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 0: actual 4, expected 3
Different row:
--- actual ---
+++ expected +++
- Row(ID=4, NAME='Rowe', VALUE=4.0)
?        ^        ^^^          ^

+ Row(ID=3, NAME='White', VALUE=3.0)
?        ^        ^^^^          ^

>>> data4 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0001]]
>>> df5 = session.create_dataframe(data4, schema1)
>>> assert_dataframe_equal(df5, df1, atol=1e-3)  # pass, DataFrames are identical due to higher error tolerance
>>> assert_dataframe_equal(df5, df1, atol=1e-5)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 2: actual 3.0001, expected 3.0
Different row:
--- actual ---
+++ expected +++
- Row(ID=3, NAME='White', VALUE=3.0001)
?                                  ---

+ Row(ID=3, NAME='White', VALUE=3.0)

>>> schema2 = StructType([
...     StructField("id", IntegerType()),
...     StructField("key", StringType()),
...     StructField("value", DoubleType())
... ])
>>> df6 = session.create_dataframe(data1, schema2)
>>> assert_dataframe_equal(df6, df1)  
Traceback (most recent call last):
AssertionError: Column name mismatch at column 1: actual KEY, expected NAME
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('KEY', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?                                                                        ^ -

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

>>> schema3 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", IntegerType())
... ])
>>> df7 = session.create_dataframe(data1, schema3)
>>> assert_dataframe_equal(df7, df1)  
Traceback (most recent call last):
AssertionError: Column data type mismatch at column 2: actual LongType(), expected DoubleType()
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', LongType(), nullable=True)])
?                                                                                                                                  ^ ^^

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

-- Example 33305
>>> from snowflake.snowpark.testing import assert_dataframe_equal
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, DoubleType
>>> schema1 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", DoubleType())
... ])
>>> data1 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0]]
>>> df1 = session.create_dataframe(data1, schema1)
>>> df2 = session.create_dataframe(data1, schema1)
>>> assert_dataframe_equal(df2, df1)  # pass, DataFrames are identical

>>> data2 = [[2, "Saka", 2.0], [1, "Rice", 1.0], [3, "White", 3.0]]  # change the order
>>> df3 = session.create_dataframe(data2, schema1)
>>> assert_dataframe_equal(df3, df1)  # pass, DataFrames are identical

>>> data3 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [4, "Rowe", 4.0]]
>>> df4 = session.create_dataframe(data3, schema1)
>>> assert_dataframe_equal(df4, df1)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 0: actual 4, expected 3
Different row:
--- actual ---
+++ expected +++
- Row(ID=4, NAME='Rowe', VALUE=4.0)
?        ^        ^^^          ^

+ Row(ID=3, NAME='White', VALUE=3.0)
?        ^        ^^^^          ^

>>> data4 = [[1, "Rice", 1.0], [2, "Saka", 2.0], [3, "White", 3.0001]]
>>> df5 = session.create_dataframe(data4, schema1)
>>> assert_dataframe_equal(df5, df1, atol=1e-3)  # pass, DataFrames are identical due to higher error tolerance
>>> assert_dataframe_equal(df5, df1, atol=1e-5)  
Traceback (most recent call last):
AssertionError: Value mismatch on row 2 at column 2: actual 3.0001, expected 3.0
Different row:
--- actual ---
+++ expected +++
- Row(ID=3, NAME='White', VALUE=3.0001)
?                                  ---

+ Row(ID=3, NAME='White', VALUE=3.0)

>>> schema2 = StructType([
...     StructField("id", IntegerType()),
...     StructField("key", StringType()),
...     StructField("value", DoubleType())
... ])
>>> df6 = session.create_dataframe(data1, schema2)
>>> assert_dataframe_equal(df6, df1)  
Traceback (most recent call last):
AssertionError: Column name mismatch at column 1: actual KEY, expected NAME
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('KEY', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?                                                                        ^ -

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

>>> schema3 = StructType([
...     StructField("id", IntegerType()),
...     StructField("name", StringType()),
...     StructField("value", IntegerType())
... ])
>>> df7 = session.create_dataframe(data1, schema3)
>>> assert_dataframe_equal(df7, df1)  
Traceback (most recent call last):
AssertionError: Column data type mismatch at column 2: actual LongType(), expected DoubleType()
Different schema:
--- actual ---
+++ expected +++
- StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', LongType(), nullable=True)])
?                                                                                                                                  ^ ^^

+ StructType([StructField('ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('VALUE', DoubleType(), nullable=True)])
?

-- Example 33306
import oracledb
def create_oracledb_connection():
    connection = oracledb.connect(...)
    return connection

df = session.read.dbapi(create_oracledb_connection, table=...)

-- Example 33307
>>> # save this dataframe to a parquet file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.parquet"
>>> copy_result = df.write.copy_into_location(remote_file_path, file_format_type="parquet", header=True, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3
>>> # the following code snippet just verifies the file content and is actually irrelevant to Snowpark
>>> # download this file and read it using pyarrow
>>> import os
>>> import tempfile
>>> import pyarrow.parquet as pq
>>> with tempfile.TemporaryDirectory() as tmpdirname:
...     _ = session.file.get(remote_file_path, tmpdirname)
...     pq.read_table(os.path.join(tmpdirname, "names.parquet"))
pyarrow.Table
FIRST_NAME: string not null
LAST_NAME: string not null
----
FIRST_NAME: [["John","Rick","Anthony"]]
LAST_NAME: [["Berry","Berry","Davis"]]

-- Example 33308
>>> # save this dataframe to a csv file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.csv"
>>> copy_result = df.write.csv(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3

-- Example 33309
>>> # save this dataframe to a json file on the session stage
>>> df = session.sql("select parse_json('[{a: 1, b: 2}, {a: 3, b: 0}]')")
>>> remote_file_path = f"{session.get_session_stage()}/names.json"
>>> copy_result = df.write.json(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
1

-- Example 33310
>>> # save this dataframe to a parquet file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.parquet"
>>> copy_result = df.write.parquet(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3

-- Example 33311
>>> # save this dataframe to a csv file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.csv"
>>> copy_result = df.write.format("csv").save(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3

-- Example 33312
Basic table saves

>>> df = session.create_dataframe([[1,2],[3,4]], schema=["a", "b"])
>>> df.write.mode("overwrite").save_as_table("my_table", table_type="temporary")
>>> session.table("my_table").collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> df.write.save_as_table("my_table", mode="append", table_type="temporary")
>>> session.table("my_table").collect()
[Row(A=1, B=2), Row(A=3, B=4), Row(A=1, B=2), Row(A=3, B=4)]
>>> df.write.mode("overwrite").save_as_table("my_transient_table", table_type="transient")
>>> session.table("my_transient_table").collect()
[Row(A=1, B=2), Row(A=3, B=4)]

-- Example 33313
Saving DataFrame to an Iceberg table. Note that the external_volume, catalog, and base_location should have been setup externally.
See `Create your first Iceberg table <https://docs.snowflake.com/en/user-guide/tutorials/create-your-first-iceberg-table>`_ for more information on creating iceberg resources.

>>> df = session.create_dataframe([[1,2],[3,4]], schema=["a", "b"])
>>> iceberg_config = {
...     "external_volume": "example_volume",
...     "catalog": "example_catalog",
...     "base_location": "/iceberg_root",
...     "storage_serialization_policy": "OPTIMIZED",
... }
>>> df.write.mode("overwrite").save_as_table("my_table", iceberg_config=iceberg_config) # doctest: +SKIP

-- Example 33314
Basic table saves

>>> df = session.create_dataframe([[1,2],[3,4]], schema=["a", "b"])
>>> df.write.mode("overwrite").save_as_table("my_table", table_type="temporary")
>>> session.table("my_table").collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> df.write.save_as_table("my_table", mode="append", table_type="temporary")
>>> session.table("my_table").collect()
[Row(A=1, B=2), Row(A=3, B=4), Row(A=1, B=2), Row(A=3, B=4)]
>>> df.write.mode("overwrite").save_as_table("my_transient_table", table_type="transient")
>>> session.table("my_transient_table").collect()
[Row(A=1, B=2), Row(A=3, B=4)]

-- Example 33315
Saving DataFrame to an Iceberg table. Note that the external_volume, catalog, and base_location should have been setup externally.
See `Create your first Iceberg table <https://docs.snowflake.com/en/user-guide/tutorials/create-your-first-iceberg-table>`_ for more information on creating iceberg resources.

>>> df = session.create_dataframe([[1,2],[3,4]], schema=["a", "b"])
>>> iceberg_config = {
...     "external_volume": "example_volume",
...     "catalog": "example_catalog",
...     "base_location": "/iceberg_root",
...     "storage_serialization_policy": "OPTIMIZED",
... }
>>> df.write.mode("overwrite").save_as_table("my_table", iceberg_config=iceberg_config) # doctest: +SKIP

-- Example 33316
>>> # save this dataframe to a json file on the session stage
>>> df = session.create_dataframe([["John", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df.write.save_as_table("my_table", table_type="temporary")
>>> df2 = session.create_dataframe([["Rick", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df2.write.insert_into("my_table")
>>> session.table("my_table").collect()
[Row(FIRST_NAME='John', LAST_NAME='Berry'), Row(FIRST_NAME='Rick', LAST_NAME='Berry')]

-- Example 33317
>>> # save this dataframe to a json file on the session stage
>>> df = session.create_dataframe([["John", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df.write.save_as_table("my_table", table_type="temporary")
>>> df2 = session.create_dataframe([["Rick", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df2.write.insert_into("my_table")
>>> session.table("my_table").collect()
[Row(FIRST_NAME='John', LAST_NAME='Berry'), Row(FIRST_NAME='Rick', LAST_NAME='Berry')]

-- Example 33318
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> _ = session.file.put("tests/resources/t*.csv", "@mystage/prefix1")
>>> # Download one file from a stage.
>>> get_result1 = session.file.get("@myStage/prefix1/test2CSV.csv", "tests/downloaded/target1")
>>> assert len(get_result1) == 1
>>> # Download all the files from @myStage/prefix.
>>> get_result2 = session.file.get("@myStage/prefix1", "tests/downloaded/target2")
>>> assert len(get_result2) > 1
>>> # Download files with names that match a regular expression pattern.
>>> get_result3 = session.file.get("@myStage/prefix1", "tests/downloaded/target3", pattern=".*test.*.csv.gz")
>>> assert len(get_result3) > 1

-- Example 33319
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> _ = session.file.put("tests/resources/testCSV.csv", "@mystage/prefix1")
>>> # Download one file from a stage.
>>> fd = session.file.get_stream("@myStage/prefix1/testCSV.csv.gz", decompress=True)
>>> assert fd.read(5) == b"1,one"
>>> fd.close()

-- Example 33320
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> put_result = session.file.put("tests/resources/t*.csv", "@mystage/prefix1")
>>> put_result[0].status
'UPLOADED'

-- Example 33321
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

-- Example 33322
>>> Employee = Row("name", "salary")
>>> emp1 = Employee("John", 10000)
>>> emp1
Row(name='John', salary=10000)
>>> emp2 = Employee("James", 20000)
>>> emp2
Row(name='James', salary=20000)

-- Example 33323
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

-- Example 33324
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 33325
>>> df = session.create_dataframe([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], schema=["a"])
>>> df.stat.approx_quantile("a", [0, 0.1, 0.4, 0.6, 1])  

>>> df2 = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df2.stat.approx_quantile(["a", "b"], [0, 0.1, 0.6])

-- Example 33326
>>> create_result = session.sql("create temp table RESULT (NUM int)").collect()
>>> insert_result = session.sql("insert into RESULT values(1),(2)").collect()

-- Example 33327
>>> df = session.table("RESULT")
>>> df.collect()
[Row(NUM=1), Row(NUM=2)]

-- Example 33328
>>> # Run cache_result and then insert into the original table to see
>>> # that the cached result is not affected
>>> df1 = df.cache_result()
>>> insert_again_result = session.sql("insert into RESULT values (3)").collect()
>>> df1.collect()
[Row(NUM=1), Row(NUM=2)]
>>> df.collect()
[Row(NUM=1), Row(NUM=2), Row(NUM=3)]

-- Example 33329
>>> # You can run cache_result on a result that has already been cached
>>> df2 = df1.cache_result()
>>> df2.collect()
[Row(NUM=1), Row(NUM=2)]

-- Example 33330
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

-- Example 33331
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

-- Example 33332
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
0.9999999999999991

-- Example 33333
>>> df = session.create_dataframe([[0.1, 0.5], [0.2, 0.6], [0.3, 0.7]], schema=["a", "b"])
>>> df.stat.cov("a", "b")
0.010000000000000037

-- Example 33334
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

-- Example 33335
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

-- Example 33336
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

-- Example 33337
SELECT ...
FROM ...
[ ... ]
GROUP BY CUBE ( groupCube [ , groupCube [ , ... ] ] )
[ ... ]

