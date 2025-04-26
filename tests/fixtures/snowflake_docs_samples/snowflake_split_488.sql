-- Example 32668
import modin.pandas as pd
import numpy as np
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
df = pd.concat([pd.DataFrame([range(i, i+5)]) for i in range(0, 150, 5)])
df = df.cache_result(inplace=False)
print(df)
df = df.reset_index(drop=True)
print(df)

-- Example 32669
>>> connection_parameters = {
...     "user": "<user_name>",
...     "password": "<password>",
...     "account": "<account_name>",
...     "role": "<role_name>",
...     "warehouse": "<warehouse_name>",
...     "database": "<database_name>",
...     "schema": "<schema_name>",
... }
>>> session = Session.builder.configs(connection_parameters).create()

-- Example 32670
>>> session = Session.builder.configs({"connection": <your python connector connection>}).create()

-- Example 32671
>>> session = Session.builder.app_name("my_app").configs(db_parameters).create() 
>>> print(session.query_tag) 
APPNAME=my_app
>>> session = Session.builder.app_name("my_app", format_json=True).configs(db_parameters).create() 
>>> print(session.query_tag) 
{"APPNAME": "my_app"}

-- Example 32672
>>> from snowflake.snowpark.types import IntegerType
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> session.add_import("tests/resources/test_udf_dir/test_udf_file.py", import_path="resources.test_udf_dir.test_udf_file")
>>> mod5_and_plus1_udf = session.udf.register(
...     lambda x: mod5(x) + 1,
...     return_type=IntegerType(),
...     input_types=[IntegerType()]
... )
>>> session.range(1, 8, 2).select(mod5_and_plus1_udf("id")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=4), Row(COL1=1), Row(COL1=3)]
>>> session.clear_imports()

-- Example 32673
>>> import numpy as np
>>> from snowflake.snowpark.functions import udf
>>> import numpy
>>> import pandas
>>> import dateutil
>>> # add numpy with the latest version on Snowflake Anaconda
>>> # and pandas with the version "2.1.*"
>>> # and dateutil with the local version in your environment
>>> session.custom_package_usage_config = {"enabled": True}  # This is added because latest dateutil is not in snowflake yet
>>> session.add_packages("numpy", "pandas==2.1.*", dateutil)
>>> @udf
... def get_package_name_udf() -> list:
...     return [numpy.__name__, pandas.__name__, dateutil.__name__]
>>> session.sql(f"select {get_package_name_udf.name}()").to_df("col1").show()
----------------
|"COL1"        |
----------------
|[             |
|  "numpy",    |
|  "pandas",   |
|  "dateutil"  |
|]             |
----------------

>>> session.clear_packages()

-- Example 32674
>>> from snowflake.snowpark.functions import udf
>>> import numpy
>>> import pandas
>>> # test_requirements.txt contains "numpy" and "pandas"
>>> session.add_requirements("tests/resources/test_requirements.txt")
>>> @udf
... def get_package_name_udf() -> list:
...     return [numpy.__name__, pandas.__name__]
>>> session.sql(f"select {get_package_name_udf.name}()").to_df("col1").show()
--------------
|"COL1"      |
--------------
|[           |
|  "numpy",  |
|  "pandas"  |
|]           |
--------------

>>> session.clear_packages()

-- Example 32675
>>> session.query_tag = "tag1"
>>> session.append_query_tag("tag2")
>>> print(session.query_tag)
tag1,tag2
>>> session.query_tag = "new_tag"
>>> print(session.query_tag)
new_tag

-- Example 32676
>>> session.query_tag = ""
>>> session.append_query_tag("tag1")
>>> print(session.query_tag)
tag1

-- Example 32677
>>> session.query_tag = "tag1"
>>> session.append_query_tag("tag2", separator="|")
>>> print(session.query_tag)
tag1|tag2

-- Example 32678
>>> session.sql("ALTER SESSION SET QUERY_TAG = 'tag1'").collect()
[Row(status='Statement executed successfully.')]
>>> session.append_query_tag("tag2")
>>> print(session.query_tag)
tag1,tag2

-- Example 32679
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>>
>>> @sproc(name="my_copy_sp", replace=True)
... def my_copy(session: snowflake.snowpark.Session, from_table: str, to_table: str, count: int) -> str:
...     session.table(from_table).limit(count).write.save_as_table(to_table)
...     return "SUCCESS"
>>> _ = session.sql("create or replace table test_from(test_str varchar) as select randstr(20, random()) from table(generator(rowCount => 100))").collect()
>>> _ = session.sql("drop table if exists test_to").collect()
>>> session.call("my_copy_sp", "test_from", "test_to", 10)
'SUCCESS'
>>> session.table("test_to").count()
10

-- Example 32680
>>> from snowflake.snowpark.dataframe import DataFrame
>>>
>>> @sproc(name="my_table_sp", replace=True)
... def my_table(session: snowflake.snowpark.Session, x: int, y: int, col1: str, col2: str) -> DataFrame:
...     return session.sql(f"select {x} as {col1}, {y} as {col2}")
>>> session.call("my_table_sp", 1, 2, "a", "b").show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 32681
>>> # create a dataframe with a schema
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField
>>> schema = StructType([StructField("a", IntegerType()), StructField("b", StringType())])
>>> session.create_dataframe([[1, "snow"], [3, "flake"]], schema).collect()
[Row(A=1, B='snow'), Row(A=3, B='flake')]

>>> # create a dataframe by inferring a schema from the data
>>> from snowflake.snowpark import Row
>>> # infer schema
>>> session.create_dataframe([1, 2, 3, 4], schema=["a"]).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=4)]
>>> session.create_dataframe([[1, 2, 3, 4]], schema=["a", "b", "c", "d"]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"]).collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> session.create_dataframe([Row(a=1, b=2, c=3, d=4)]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([{"a": 1}, {"b": 2}]).collect()
[Row(A=1, B=None), Row(A=None, B=2)]

>>> # create a dataframe from a pandas Dataframe
>>> import pandas as pd
>>> session.create_dataframe(pd.DataFrame([(1, 2, 3, 4)], columns=["a", "b", "c", "d"])).collect()
[Row(a=1, b=2, c=3, d=4)]

>>> # create a dataframe using an implicit struct schema string
>>> session.create_dataframe([[10, 20], [30, 40]], schema="x: int, y: int").collect()
[Row(X=10, Y=20), Row(X=30, Y=40)]

-- Example 32682
>>> from snowflake.snowpark.functions import when_matched, when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6],[4.0,6,8]], schema=["a", "b", "c"])

-- Example 32683
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 32684
>>> async_job = df.collect(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 32685
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 32686
>>> async_job = df.first(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5)]

-- Example 32687
>>> async_job = df.count(block=False)
>>> async_job.result()
4

-- Example 32688
>>> table_name = "name"
>>> async_job = df.write.save_as_table(table_name, block=False)
>>> # copy into a stage file
>>> remote_location = f"{session.get_session_stage()}/name.csv"
>>> async_job = df.write.copy_into_location(remote_location, block=False)
>>> async_job.result()[0]['rows_unloaded']
4

-- Example 32689
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> async_job = target.merge(source,target["key"] == source["key"],[when_matched().update({"value": source["value"]}),when_not_matched().insert({"key": source["key"]})],block=False)
>>> async_job.result()
MergeResult(rows_inserted=2, rows_updated=2, rows_deleted=0)

-- Example 32690
>>> df = session.sql("select SYSTEM$WAIT(3)")
>>> async_job = df.collect_nowait()
>>> async_job.cancel()

-- Example 32691
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

-- Example 32692
>>> # create a dataframe with a schema
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField
>>> schema = StructType([StructField("a", IntegerType()), StructField("b", StringType())])
>>> session.create_dataframe([[1, "snow"], [3, "flake"]], schema).collect()
[Row(A=1, B='snow'), Row(A=3, B='flake')]

>>> # create a dataframe by inferring a schema from the data
>>> from snowflake.snowpark import Row
>>> # infer schema
>>> session.create_dataframe([1, 2, 3, 4], schema=["a"]).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=4)]
>>> session.create_dataframe([[1, 2, 3, 4]], schema=["a", "b", "c", "d"]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"]).collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> session.create_dataframe([Row(a=1, b=2, c=3, d=4)]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([{"a": 1}, {"b": 2}]).collect()
[Row(A=1, B=None), Row(A=None, B=2)]

>>> # create a dataframe from a pandas Dataframe
>>> import pandas as pd
>>> session.create_dataframe(pd.DataFrame([(1, 2, 3, 4)], columns=["a", "b", "c", "d"])).collect()
[Row(a=1, b=2, c=3, d=4)]

>>> # create a dataframe using an implicit struct schema string
>>> session.create_dataframe([[10, 20], [30, 40]], schema="x: int, y: int").collect()
[Row(X=10, Y=20), Row(X=30, Y=40)]

-- Example 32693
df = session.flatten(parse_json(lit('{"a":[1,2]}')), "a", False, False, "BOTH")

-- Example 32694
>>> from snowflake.snowpark.functions import lit, parse_json
>>> session.flatten(parse_json(lit('{"a":[1,2]}')), path="a", outer=False, recursive=False, mode="BOTH").show()
-------------------------------------------------------
|"SEQ"  |"KEY"  |"PATH"  |"INDEX"  |"VALUE"  |"THIS"  |
-------------------------------------------------------
|1      |NULL   |a[0]    |0        |1        |[       |
|       |       |        |         |         |  1,    |
|       |       |        |         |         |  2     |
|       |       |        |         |         |]       |
|1      |NULL   |a[1]    |1        |2        |[       |
|       |       |        |         |         |  1,    |
|       |       |        |         |         |  2     |
|       |       |        |         |         |]       |
-------------------------------------------------------

-- Example 32695
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

-- Example 32696
>>> df_prices = session.table("prices")

-- Example 32697
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> df_catalog = session.read.schema(StructType([StructField("id", StringType()), StructField("name", StringType())])).csv("@test_stage/test_dir")
>>> df_catalog.show()
---------------------
|"ID"  |"NAME"      |
---------------------
|id1   | Product A  |
|id2   | Product B  |
---------------------

-- Example 32698
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

-- Example 32699
>>> df_merged_data = df_catalog.join(df_prices, df_catalog["id"] == df_prices["product_id"])

-- Example 32700
>>> # Return a new DataFrame containing the product_id and amount columns of the prices table.
>>> # This is equivalent to: SELECT PRODUCT_ID, AMOUNT FROM PRICES;
>>> df_price_ids_and_amounts = df_prices.select(col("product_id"), col("amount"))

-- Example 32701
>>> # Return a new DataFrame containing the product_id column of the prices table as a column named
>>> # item_id. This is equivalent to: SELECT PRODUCT_ID AS ITEM_ID FROM PRICES;
>>> df_price_item_ids = df_prices.select(col("product_id").as_("item_id"))

-- Example 32702
>>> # Return a new DataFrame containing the row from the prices table with the ID 1.
>>> # This is equivalent to:
>>> # SELECT * FROM PRICES WHERE PRODUCT_ID = 1;
>>> df_price1 = df_prices.filter((col("product_id") == 1))

-- Example 32703
>>> # Return a new DataFrame for the prices table with the rows sorted by product_id.
>>> # This is equivalent to: SELECT * FROM PRICES ORDER BY PRODUCT_ID;
>>> df_sorted_prices = df_prices.sort(col("product_id"))

-- Example 32704
>>> import snowflake.snowpark.functions as f
>>> df_prices.agg(("amount", "sum")).collect()
[Row(SUM(AMOUNT)=Decimal('30.00'))]
>>> df_prices.agg(f.sum("amount")).collect()
[Row(SUM(AMOUNT)=Decimal('30.00'))]
>>> # rename the aggregation column name
>>> df_prices.agg(f.sum("amount").alias("total_amount"), f.max("amount").alias("max_amount")).collect()
[Row(TOTAL_AMOUNT=Decimal('30.00'), MAX_AMOUNT=Decimal('20.00'))]

-- Example 32705
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

-- Example 32706
>>> from snowflake.snowpark import Window
>>> from snowflake.snowpark.functions import row_number
>>> df_prices.with_column("price_rank",  row_number().over(Window.order_by(col("amount").desc()))).show()
------------------------------------------
|"PRODUCT_ID"  |"AMOUNT"  |"PRICE_RANK"  |
------------------------------------------
|id2           |20.00     |1             |
|id1           |10.00     |2             |
------------------------------------------

-- Example 32707
>>> df = session.create_dataframe([[1, None, 3], [4, 5, None]], schema=["a", "b", "c"])
>>> df.na.fill({"b": 2, "c": 6}).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |3    |
|4    |5    |6    |
-------------------

-- Example 32708
>>> df_prices.collect()
[Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00')), Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))]

-- Example 32709
>>> df_prices.show()
---------------------------
|"PRODUCT_ID"  |"AMOUNT"  |
---------------------------
|id1           |10.00     |
|id2           |20.00     |
---------------------------

-- Example 32710
>>> df = session.create_dataframe([[1, 2], [3, 4], [5, -1]], schema=["a", "b"])
>>> df.stat.corr("a", "b")
-0.5960395606792697

-- Example 32711
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6], [4.0, 6, 8]], schema=["a", "b", "c"])
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 32712
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 32713
>>> from snowflake.snowpark.functions import seq1, seq8, uniform
>>> df = session.generator(seq1(1).as_("sequence one"), uniform(1, 10, 2).as_("uniform"), rowcount=3)
>>> df.show()
------------------------------
|"sequence one"  |"UNIFORM"  |
------------------------------
|0               |3          |
|1               |3          |
|2               |3          |
------------------------------

-- Example 32714
>>> df = session.generator(seq8(0), uniform(1, 10, 2), timelimit=1).order_by(seq8(0)).limit(3)
>>> df.show()
-----------------------------------
|"SEQ8(0)"  |"UNIFORM(1, 10, 2)"  |
-----------------------------------
|0          |3                    |
|1          |3                    |
|2          |3                    |
-----------------------------------

-- Example 32715
>>> with session.query_history(True) as query_history:
...     df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
...     df = df.filter(df.a == 1)
...     res = df.collect()
>>> assert len(query_history.queries) == 2
>>> assert query_history.queries[0].is_describe
>>> assert not query_history.queries[1].is_describe

-- Example 32716
>>> session.range(10).collect()
[Row(ID=0), Row(ID=1), Row(ID=2), Row(ID=3), Row(ID=4), Row(ID=5), Row(ID=6), Row(ID=7), Row(ID=8), Row(ID=9)]
>>> session.range(1, 10).collect()
[Row(ID=1), Row(ID=2), Row(ID=3), Row(ID=4), Row(ID=5), Row(ID=6), Row(ID=7), Row(ID=8), Row(ID=9)]
>>> session.range(1, 10, 2).collect()
[Row(ID=1), Row(ID=3), Row(ID=5), Row(ID=7), Row(ID=9)]

-- Example 32717
>>> session.clear_imports()
>>> len(session.get_imports())
0
>>> session.add_import("tests/resources/test_udf_dir/test_udf_file.py")
>>> len(session.get_imports())
1
>>> session.remove_import("tests/resources/test_udf_dir/test_udf_file.py")
>>> len(session.get_imports())
0

-- Example 32718
>>> session.clear_packages()
>>> len(session.get_packages())
0
>>> session.add_packages("numpy", "pandas==2.1.4")
>>> len(session.get_packages())
2
>>> session.remove_package("numpy")
>>> len(session.get_packages())
1
>>> session.remove_package("pandas")
>>> len(session.get_packages())
0

-- Example 32719
>>> from snowflake.snowpark.functions import udf
>>> import numpy
>>> import pandas
>>> # test_requirements.txt contains "numpy" and "pandas"
>>> session.custom_package_usage_config = {"enabled": True, "force_push": True} # Recommended configuration
>>> session.replicate_local_environment(ignore_packages={"snowflake-snowpark-python", "snowflake-connector-python", "urllib3", "tzdata", "numpy"}, relax=True)
>>> @udf
... def get_package_name_udf() -> list:
...     return [numpy.__name__, pandas.__name__]
>>> if sys.version_info <= (3, 11):
...     session.sql(f"select {get_package_name_udf.name}()").to_df("col1").show()  
--------------
|"COL1"      |
--------------
|[           |
|  "numpy",  |
|  "pandas"  |
|]           |
--------------

>>> session.clear_packages()
>>> session.clear_imports()

-- Example 32720
>>> # create a dataframe from a SQL query
>>> df = session.sql("select 1/2")
>>> # execute the query
>>> df.collect()
[Row(1/2=Decimal('0.500000'))]

>>> # Use params to bind variables
>>> session.sql("select * from values (?, ?), (?, ?)", params=[1, "a", 2, "b"]).sort("column1").collect()
[Row(COLUMN1=1, COLUMN2='a'), Row(COLUMN1=2, COLUMN2='b')]

-- Example 32721
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df1.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> session.table("my_table").collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> current_db = session.get_current_database()
>>> current_schema = session.get_current_schema()
>>> session.table([current_db, current_schema, "my_table"]).collect()
[Row(A=1, B=2), Row(A=3, B=4)]

-- Example 32722
>>> from snowflake.snowpark.functions import lit
>>> session.table_function("split_to_table", lit("split words to table"), lit(" ")).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 32723
>>> from snowflake.snowpark.functions import table_function, lit
>>> split_to_table = table_function("split_to_table")
>>> session.table_function(split_to_table(lit("split words to table"), lit(" "))).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 32724
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> class GeneratorUDTF:
...     def process(self, n):
...         for i in range(n):
...             yield (i, )
>>> generator_udtf = udtf(GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 32725
>>> session.query_tag = '{"key1": "value1"}'
>>> session.update_query_tag({"key2": "value2"})
>>> print(session.query_tag)
{"key1": "value1", "key2": "value2"}

-- Example 32726
>>> session.sql("ALTER SESSION SET QUERY_TAG = '{\"key1\": \"value1\"}'").collect()
[Row(status='Statement executed successfully.')]
>>> session.update_query_tag({"key2": "value2"})
>>> print(session.query_tag)
{"key1": "value1", "key2": "value2"}

-- Example 32727
>>> session.query_tag = ""
>>> session.update_query_tag({"key1": "value1"})
>>> print(session.query_tag)
{"key1": "value1"}

-- Example 32728
>>> import pandas as pd
>>> pandas_df = pd.DataFrame([(1, "Steve"), (2, "Bob")], columns=["id", "name"])
>>> snowpark_df = session.write_pandas(pandas_df, "write_pandas_table", auto_create_table=True, table_type="temp")
>>> snowpark_df.sort('"id"').to_pandas()
   id   name
0   1  Steve
1   2    Bob

>>> pandas_df2 = pd.DataFrame([(3, "John")], columns=["id", "name"])
>>> snowpark_df2 = session.write_pandas(pandas_df2, "write_pandas_table", auto_create_table=False)
>>> snowpark_df2.sort('"id"').to_pandas()
   id   name
0   1  Steve
1   2    Bob
2   3   John

>>> pandas_df3 = pd.DataFrame([(1, "Jane")], columns=["id", "name"])
>>> snowpark_df3 = session.write_pandas(pandas_df3, "write_pandas_table", auto_create_table=False, overwrite=True)
>>> snowpark_df3.to_pandas()
   id  name
0   1  Jane

>>> pandas_df4 = pd.DataFrame([(1, "Jane")], columns=["id", "name"])
>>> snowpark_df4 = session.write_pandas(pandas_df4, "write_pandas_transient_table", auto_create_table=True, table_type="transient")
>>> snowpark_df4.to_pandas()
   id  name
0   1  Jane

-- Example 32729
>>> from snowflake.snowpark.functions import udf
>>> session.custom_package_usage_config = {"enabled": True, "cache_path": "@my_permanent_stage/folder"} 
>>> session.add_packages("package_unavailable_in_snowflake") 
>>> @udf
... def use_my_custom_package() -> str:
...     import package_unavailable_in_snowflake
...     return "works"
>>> session.clear_packages()
>>> session.clear_imports()

-- Example 32730
>>> # Create a temp stage to run the example code.
>>> _ = session.sql("CREATE or REPLACE temp STAGE mystage").collect()

-- Example 32731
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, FloatType
>>> _ = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV file.
>>> user_schema = StructType([StructField("a", IntegerType()), StructField("b", StringType()), StructField("c", FloatType())])
>>> # Create a DataFrame that is configured to load data from the CSV file.
>>> df = session.read.options({"field_delimiter": ",", "skip_header": 1}).schema(user_schema).csv("@mystage/testCSV.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(A=2, B='two', C=2.2)]

-- Example 32732
>>> _ = session.file.put("tests/resources/testJson.json", "@mystage", auto_compress=True)
>>> # Create a DataFrame that is configured to load data from the gzipped JSON file.
>>> json_df = session.read.option("compression", "gzip").json("@mystage/testJson.json.gz")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> json_df.show()
-----------------------
|"$1"                 |
-----------------------
|{                    |
|  "color": "Red",    |
|  "fruit": "Apple",  |
|  "size": "Large"    |
|}                    |
-----------------------

-- Example 32733
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/*.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV files.
>>> user_schema = StructType([StructField("a", IntegerType()), StructField("b", StringType()), StructField("c", FloatType())])
>>> # Create a DataFrame that is configured to load data from the CSV files in the stage.
>>> csv_df = session.read.option("pattern", ".*V[.]csv").schema(user_schema).csv("@mystage").sort(col("a"))
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> csv_df.collect()
[Row(A=1, B='one', C=1.2), Row(A=2, B='two', C=2.2), Row(A=3, B='three', C=3.3), Row(A=4, B='four', C=4.4)]

-- Example 32734
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.parquet", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.parquet("@mystage/test.parquet").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

