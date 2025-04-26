-- Example 25100
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

-- Example 25101
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

-- Example 25102
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

-- Example 25103
>>> Employee = Row("name", "salary")
>>> emp1 = Employee("John", 10000)
>>> emp1
Row(name='John', salary=10000)
>>> emp2 = Employee("James", 20000)
>>> emp2
Row(name='James', salary=20000)

-- Example 25104
>>> from snowflake.snowpark.functions import when_matched, when_not_matched
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField, StructType
>>> df = session.create_dataframe([[float(4), 3, 5], [2.0, -4, 7], [3.0, 5, 6],[4.0,6,8]], schema=["a", "b", "c"])

-- Example 25105
>>> async_job = df.collect_nowait()
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 25106
>>> async_job = df.collect(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5), Row(A=2.0, B=-4, C=7), Row(A=3.0, B=5, C=6), Row(A=4.0, B=6, C=8)]

-- Example 25107
>>> async_job = df.to_pandas(block=False)
>>> async_job.result()
     A  B  C
0  4.0  3  5
1  2.0 -4  7
2  3.0  5  6
3  4.0  6  8

-- Example 25108
>>> async_job = df.first(block=False)
>>> async_job.result()
[Row(A=4.0, B=3, C=5)]

-- Example 25109
>>> async_job = df.count(block=False)
>>> async_job.result()
4

-- Example 25110
>>> table_name = "name"
>>> async_job = df.write.save_as_table(table_name, block=False)
>>> # copy into a stage file
>>> remote_location = f"{session.get_session_stage()}/name.csv"
>>> async_job = df.write.copy_into_location(remote_location, block=False)
>>> async_job.result()[0]['rows_unloaded']
4

-- Example 25111
>>> schema = StructType([StructField("key", IntegerType()), StructField("value", StringType())])
>>> target_df = session.create_dataframe([(10, "old"), (10, "too_old"), (11, "old")], schema=schema)
>>> target_df.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> target = session.table("my_table")
>>> source = session.create_dataframe([(10, "new"), (12, "new"), (13, "old")], schema=schema)
>>> async_job = target.merge(source,target["key"] == source["key"],[when_matched().update({"value": source["value"]}),when_not_matched().insert({"key": source["key"]})],block=False)
>>> async_job.result()
MergeResult(rows_inserted=2, rows_updated=2, rows_deleted=0)

-- Example 25112
>>> df = session.sql("select SYSTEM$WAIT(3)")
>>> async_job = df.collect_nowait()
>>> async_job.cancel()

-- Example 25113
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

-- Example 25114
>>> # Create a temp stage to run the example code.
>>> _ = session.sql("CREATE or REPLACE temp STAGE mystage").collect()

-- Example 25115
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType, FloatType
>>> _ = session.file.put("tests/resources/testCSV.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV file.
>>> user_schema = StructType([StructField("a", IntegerType()), StructField("b", StringType()), StructField("c", FloatType())])
>>> # Create a DataFrame that is configured to load data from the CSV file.
>>> df = session.read.options({"field_delimiter": ",", "skip_header": 1}).schema(user_schema).csv("@mystage/testCSV.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(A=2, B='two', C=2.2)]

-- Example 25116
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

-- Example 25117
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

-- Example 25118
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.parquet", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.parquet("@mystage/test.parquet").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

-- Example 25119
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.orc", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.orc("@mystage/test.orc").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

-- Example 25120
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.avro", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.avro("@mystage/test.avro").where(col('"num"') == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(str='str2', num=2)]

-- Example 25121
>>> from snowflake.snowpark.functions import col
>>> _ = session.file.put("tests/resources/test.parquet", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.option("infer_schema", False).parquet("@mystage/test.parquet").where(col('$1')["num"] == 2)
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
-------------------
|"$1"             |
-------------------
|{                |
|  "num": 2,      |
|  "str": "str2"  |
|}                |
-------------------

-- Example 25122
>>> from snowflake.snowpark.functions import col, lit
>>> _ = session.file.put("tests/resources/testJson.json", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.json("@mystage/testJson.json").where(col("$1")["fruit"] == lit("Apple"))
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
-----------------------
|"$1"                 |
-----------------------
|{                    |
|  "color": "Red",    |
|  "fruit": "Apple",  |
|  "size": "Large"    |
|}                    |
|{                    |
|  "color": "Red",    |
|  "fruit": "Apple",  |
|  "size": "Large"    |
|}                    |
-----------------------

-- Example 25123
>>> _ = session.file.put("tests/resources/test.xml", "@mystage", auto_compress=False)
>>> # Create a DataFrame that uses a DataFrameReader to load data from a file in a stage.
>>> df = session.read.xml("@mystage/test.xml")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
---------------------
|"$1"               |
---------------------
|<test>             |
|  <num>1</num>     |
|  <str>str1</str>  |
|</test>            |
|<test>             |
|  <num>2</num>     |
|  <str>str2</str>  |
|</test>            |
---------------------

-- Example 25124
>>> from snowflake.snowpark.types import StructType, StructField, IntegerType, StringType
>>> _ = session.sql("create file format if not exists csv_format type=csv skip_header=1 null_if='none';").collect()
>>> _ = session.file.put("tests/resources/testCSVspecialFormat.csv", "@mystage", auto_compress=False)
>>> # Define the schema for the data in the CSV files.
>>> schema = StructType([StructField("ID", IntegerType()),StructField("USERNAME", StringType()),StructField("FIRSTNAME", StringType()),StructField("LASTNAME", StringType())])
>>> # Create a DataFrame that is configured to load data from the CSV files in the stage.
>>> df = session.read.schema(schema).option("format_name", "csv_format").csv("@mystage/testCSVspecialFormat.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.collect()
[Row(ID=0, USERNAME='admin', FIRSTNAME=None, LASTNAME=None), Row(ID=1, USERNAME='test_user', FIRSTNAME='test', LASTNAME='user')]

-- Example 25125
>>> from snowflake.snowpark.column import METADATA_FILENAME, METADATA_FILE_ROW_NUMBER
>>> df = session.read.with_metadata(METADATA_FILENAME, METADATA_FILE_ROW_NUMBER.as_("ROW NUMBER")).schema(user_schema).csv("@mystage/testCSV.csv")
>>> # Load the data into the DataFrame and return an array of rows containing the results.
>>> df.show()
--------------------------------------------------------
|"METADATA$FILENAME"  |"ROW NUMBER"  |"A"  |"B"  |"C"  |
--------------------------------------------------------
|testCSV.csv          |1             |1    |one  |1.2  |
|testCSV.csv          |2             |2    |two  |2.2  |
--------------------------------------------------------

-- Example 25126
>>> # Read a csv file without a header
>>> df = session.read.option("INFER_SCHEMA", True).csv("@mystage/testCSV.csv")
>>> df.show()
----------------------
|"c1"  |"c2"  |"c3"  |
----------------------
|1     |one   |1.2   |
|2     |two   |2.2   |
----------------------

-- Example 25127
>>> # Read a csv file with header and parse the header
>>> _ = session.file.put("tests/resources/testCSVheader.csv", "@mystage", auto_compress=False)
>>> df = session.read.option("INFER_SCHEMA", True).option("PARSE_HEADER", True).csv("@mystage/testCSVheader.csv")
>>> df.show()
----------------------------
|"id"  |"name"  |"rating"  |
----------------------------
|1     |one     |1.2       |
|2     |two     |2.2       |
----------------------------

-- Example 25128
>>> df = session.read.option("INFER_SCHEMA", True).json("@mystage/testJson.json")
>>> df.show()
------------------------------
|"color"  |"fruit"  |"size"  |
------------------------------
|Red      |Apple    |Large   |
|Red      |Apple    |Large   |
------------------------------

-- Example 25129
>>> # Each XML record is extracted as a separate row,
>>> # and each field within that record becomes a separate column of type VARIANT
>>> _ = session.file.put("tests/resources/nested.xml", "@mystage", auto_compress=False)
>>> df = session.read.option("rowTag", "tag").xml("@mystage/nested.xml")
>>> df.show()
-----------------------
|"'test'"             |
-----------------------
|{                    |
|  "num": "1",        |
|  "obj": {           |
|    "bool": "true",  |
|    "str": "str2"    |
|  },                 |
|  "str": "str1"      |
|}                    |
-----------------------

-- Example 25130
>>> # Query nested fields using dot notation
>>> from snowflake.snowpark.functions import col
>>> df.select(
...     "'test'.num", "'test'.str", col("'test'.obj"), col("'test'.obj.bool")
... ).show()
------------------------------------------------------------------------------------------------------
|"""'TEST'"":""NUM"""  |"""'TEST'"":""STR"""  |"""'TEST'"":""OBJ"""  |"""'TEST'"":""OBJ"".""BOOL"""  |
------------------------------------------------------------------------------------------------------
|"1"                   |"str1"                |{                     |"true"                         |
|                      |                      |  "bool": "true",     |                               |
|                      |                      |  "str": "str2"       |                               |
|                      |                      |}                     |                               |
------------------------------------------------------------------------------------------------------

-- Example 25131
import oracledb
def create_oracledb_connection():
    connection = oracledb.connect(...)
    return connection

df = session.read.dbapi(create_oracledb_connection, table=...)

-- Example 25132
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

-- Example 25133
>>> # save this dataframe to a csv file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.csv"
>>> copy_result = df.write.csv(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3

-- Example 25134
>>> # save this dataframe to a json file on the session stage
>>> df = session.sql("select parse_json('[{a: 1, b: 2}, {a: 3, b: 0}]')")
>>> remote_file_path = f"{session.get_session_stage()}/names.json"
>>> copy_result = df.write.json(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
1

-- Example 25135
>>> # save this dataframe to a parquet file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.parquet"
>>> copy_result = df.write.parquet(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3

-- Example 25136
>>> # save this dataframe to a csv file on the session stage
>>> df = session.create_dataframe([["John", "Berry"], ["Rick", "Berry"], ["Anthony", "Davis"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> remote_file_path = f"{session.get_session_stage()}/names.csv"
>>> copy_result = df.write.format("csv").save(remote_file_path, overwrite=True, single=True)
>>> copy_result[0].rows_unloaded
3

-- Example 25137
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

-- Example 25138
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

-- Example 25139
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

-- Example 25140
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

-- Example 25141
>>> # save this dataframe to a json file on the session stage
>>> df = session.create_dataframe([["John", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df.write.save_as_table("my_table", table_type="temporary")
>>> df2 = session.create_dataframe([["Rick", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df2.write.insert_into("my_table")
>>> session.table("my_table").collect()
[Row(FIRST_NAME='John', LAST_NAME='Berry'), Row(FIRST_NAME='Rick', LAST_NAME='Berry')]

-- Example 25142
>>> # save this dataframe to a json file on the session stage
>>> df = session.create_dataframe([["John", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df.write.save_as_table("my_table", table_type="temporary")
>>> df2 = session.create_dataframe([["Rick", "Berry"]], schema = ["FIRST_NAME", "LAST_NAME"])
>>> df2.write.insert_into("my_table")
>>> session.table("my_table").collect()
[Row(FIRST_NAME='John', LAST_NAME='Berry'), Row(FIRST_NAME='Rick', LAST_NAME='Berry')]

-- Example 25143
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

-- Example 25144
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> _ = session.file.put("tests/resources/testCSV.csv", "@mystage/prefix1")
>>> # Download one file from a stage.
>>> fd = session.file.get_stream("@myStage/prefix1/testCSV.csv.gz", decompress=True)
>>> assert fd.read(5) == b"1,one"
>>> fd.close()

-- Example 25145
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> put_result = session.file.put("tests/resources/t*.csv", "@mystage/prefix1")
>>> put_result[0].status
'UPLOADED'

-- Example 25146
CREATE TEMPORARY TABLE mytemptable (id NUMBER, creation_date DATE);

-- Example 25147
from snowflake.core.table import Table, TableColumn

my_temp_table = Table(
  name="mytemptable",
  columns=[TableColumn(name="id", datatype="int"),
          TableColumn(name="creation_date", datatype="timestamp_tz")],
  kind="TEMPORARY"
)
root.databases["<database>"].schemas["<schema>"].tables.create(my_temp_table)

-- Example 25148
CREATE TRANSIENT TABLE mytranstable (id NUMBER, creation_date DATE);

-- Example 25149
from snowflake.core.table import Table, TableColumn

my_trans_table = Table(
  name="mytranstable",
  columns=[TableColumn(name="id", datatype="int"),
          TableColumn(name="creation_date", datatype="timestamp_tz")],
  kind="TRANSIENT"
)
root.databases["<database>"].schemas["<schema>"].tables.create(my_trans_table)

-- Example 25150
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

-- Example 25151
>>> from snowflake.snowpark.functions import lit
>>> df.select(col("name"), lit("const value").alias("literal_column")).collect()
[Row(NAME='John', LITERAL_COLUMN='const value'), Row(NAME='Mike', LITERAL_COLUMN='const value')]

-- Example 25152
>>> df = session.create_dataframe([[20, 5], [1, 2]], schema=["a", "b"])
>>> df.filter((col("a") == 20) | (col("b") <= 10)).collect()  # use parentheses before and after the | operator.
[Row(A=20, B=5), Row(A=1, B=2)]
>>> df.filter((df["a"] + df.b) < 10).collect()
[Row(A=1, B=2)]
>>> df.select((col("b") * 10).alias("c")).collect()
[Row(C=50), Row(C=20)]

-- Example 25153
>>> from snowflake.snowpark.types import StringType, IntegerType
>>> df_with_semi_data = session.create_dataframe([[{"k1": "v1", "k2": "v2"}, ["a0", 1, "a2"]]], schema=["object_column", "array_column"])
>>> df_with_semi_data.select(df_with_semi_data["object_column"]["k1"].alias("k1_value"), df_with_semi_data["array_column"][0].alias("a0_value"), df_with_semi_data["array_column"][1].alias("a1_value")).collect()
[Row(K1_VALUE='"v1"', A0_VALUE='"a0"', A1_VALUE='1')]
>>> # The above two returned string columns have JSON literal values because children of semi-structured data are semi-structured.
>>> # The next line converts JSON literal to a string
>>> df_with_semi_data.select(df_with_semi_data["object_column"]["k1"].cast(StringType()).alias("k1_value"), df_with_semi_data["array_column"][0].cast(StringType()).alias("a0_value"), df_with_semi_data["array_column"][1].cast(IntegerType()).alias("a1_value")).collect()
[Row(K1_VALUE='v1', A0_VALUE='a0', A1_VALUE=1)]

-- Example 25154
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df_filtered = df.filter((col("A") > 1) & (col("B") < 100))  # Must use parenthesis before and after operator &.

>>> # The following two result in the same SQL query:
>>> df.filter(col("a") > 1).collect()
[Row(A=3, B=4)]
>>> df.filter("a > 1").collect()  # use SQL expression
[Row(A=3, B=4)]

-- Example 25155
CREATE [ OR REPLACE ] STORAGE INTEGRATION [IF NOT EXISTS]
  <name>
  TYPE = EXTERNAL_STAGE
  cloudProviderParams
  ENABLED = { TRUE | FALSE }
  STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/' [ , '<cloud>://<bucket>/<path>/' ... ] )
  [ STORAGE_BLOCKED_LOCATIONS = ('<cloud>://<bucket>/<path>/' [ , '<cloud>://<bucket>/<path>/' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 25156
cloudProviderParams (for Amazon S3) ::=
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  [ STORAGE_AWS_EXTERNAL_ID = '<external_id>' ]
  [ STORAGE_AWS_OBJECT_ACL = 'bucket-owner-full-control' ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 25157
cloudProviderParams (for Google Cloud Storage) ::=
  STORAGE_PROVIDER = 'GCS'

-- Example 25158
cloudProviderParams (for Microsoft Azure) ::=
  STORAGE_PROVIDER = 'AZURE'
  AZURE_TENANT_ID = '<tenant_id>'
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 25159
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket1/path1/', 's3://mybucket2/path2/');

-- Example 25160
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/');

-- Example 25161
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer/path1/', 'azure://myaccount.blob.core.windows.net/mycontainer/path2/');

-- Example 25162
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket3/path3/', 's3://mybucket4/path4/');

-- Example 25163
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket3/path3/', 'gcs://mybucket4/path4/');

-- Example 25164
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer/path3/', 'azure://myaccount.blob.core.windows.net/mycontainer/path4/');

-- Example 25165
COPY FILES INTO @[<namespace>.]<stage_name>[/<path>/]
  FROM @[<namespace>.]<stage_name>[/<path>/]
  [ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
  [ PATTERN = '<regex_pattern>' ]
  [ DETAILED_OUTPUT = { TRUE | FALSE } ]

-- Example 25166
COPY FILES INTO @[<namespace>.]<stage_name>[/<path>/]
  FROM ( SELECT <existing_url> [ , <new_filename> ] FROM ... )
  [ DETAILED_OUTPUT = { TRUE | FALSE } ]

