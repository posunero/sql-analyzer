-- Example 9294
# Create a DataFrame with 4 columns, "a", "b", "c" and "d".
df2 = session.create_dataframe([[1, 2, 3, 4]], schema=["a", "b", "c", "d"])
df2.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df2

-- Example 9295
-------------------------
|"A"  |"B"  |"C"  |"D"  |
-------------------------
|1    |2    |3    |4    |
-------------------------

-- Example 9296
# Create another DataFrame with 4 columns, "a", "b", "c" and "d".
from snowflake.snowpark import Row
df3 = session.create_dataframe([Row(a=1, b=2, c=3, d=4)])
df3.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df3

-- Example 9297
-------------------------
|"A"  |"B"  |"C"  |"D"  |
-------------------------
|1    |2    |3    |4    |
-------------------------

-- Example 9298
# Create a DataFrame and specify a schema
from snowflake.snowpark.types import IntegerType, StringType, StructType, StructField
schema = StructType([StructField("a", IntegerType()), StructField("b", StringType())])
df4 = session.create_dataframe([[1, "snow"], [3, "flake"]], schema)
df4.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df4

-- Example 9299
---------------
|"A"  |"B"    |
---------------
|1    |snow   |
|3    |flake  |
---------------

-- Example 9300
# Create a DataFrame from a range
# The DataFrame contains rows with values 1, 3, 5, 7, and 9 respectively.
df_range = session.range(1, 10, 2).to_df("a")
df_range.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df_range

-- Example 9301
-------
|"A"  |
-------
|1    |
|3    |
|5    |
|7    |
|9    |
-------

-- Example 9302
from snowflake.snowpark.types import StructType, StructField, StringType, IntegerType

# Create DataFrames from data in a stage.
df_json = session.read.json("@my_stage2/data1.json")
df_catalog = session.read.schema(StructType([StructField("name", StringType()), StructField("age", IntegerType())])).csv("@stage/some_dir")

-- Example 9303
# Create a DataFrame from a SQL query
df_sql = session.sql("SELECT name from sample_product_data")
df_sql.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df_sql

-- Example 9304
--------------
|"NAME"      |
--------------
|Product 1   |
|Product 1A  |
|Product 1B  |
|Product 2   |
|Product 2A  |
|Product 2B  |
|Product 3   |
|Product 3A  |
|Product 3B  |
|Product 4   |
--------------

-- Example 9305
# Import the col function from the functions module.
# Python worksheets import this function by default
from snowflake.snowpark.functions import col

# Create a DataFrame for the rows with the ID 1
# in the "sample_product_data" table.

# This example uses the == operator of the Column object to perform an
# equality check.
df = session.table("sample_product_data").filter(col("id") == 1)
df.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df

-- Example 9306
------------------------------------------------------------------------------------
|"ID"  |"PARENT_ID"  |"CATEGORY_ID"  |"NAME"     |"SERIAL_NUMBER"  |"KEY"  |"3rd"  |
------------------------------------------------------------------------------------
|1     |0            |5              |Product 1  |prod-1           |1      |10     |
------------------------------------------------------------------------------------

-- Example 9307
# Import the col function from the functions module.
from snowflake.snowpark.functions import col

# Create a DataFrame that contains the id, name, and serial_number
# columns in the "sample_product_data" table.
df = session.table("sample_product_data").select(col("id"), col("name"), col("serial_number"))
df.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df

-- Example 9308
---------------------------------------
|"ID"  |"NAME"      |"SERIAL_NUMBER"  |
---------------------------------------
|1     |Product 1   |prod-1           |
|2     |Product 1A  |prod-1-A         |
|3     |Product 1B  |prod-1-B         |
|4     |Product 2   |prod-2           |
|5     |Product 2A  |prod-2-A         |
|6     |Product 2B  |prod-2-B         |
|7     |Product 3   |prod-3           |
|8     |Product 3A  |prod-3-A         |
|9     |Product 3B  |prod-3-B         |
|10    |Product 4   |prod-4           |
---------------------------------------

-- Example 9309
# Import the col function from the functions module.
from snowflake.snowpark.functions import col

df_product_info = session.table("sample_product_data")
df1 = df_product_info.select(df_product_info["id"], df_product_info["name"], df_product_info["serial_number"])
df2 = df_product_info.select(df_product_info.id, df_product_info.name, df_product_info.serial_number)
df3 = df_product_info.select("id", "name", "serial_number")

-- Example 9310
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
# Create a DataFrame that joins the two DataFrames
# on the column named "key".
df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key")).select(df_lhs["key"].as_("key"), "value1", "value2").show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key")).select(df_lhs["key"].as_("key"), "value1", "value2")

-- Example 9311
-------------------------------
|"KEY"  |"VALUE1"  |"VALUE2"  |
-------------------------------
|a      |1         |3         |
|b      |2         |4         |
-------------------------------

-- Example 9312
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
# If both dataframes have the same column "key", the following is more convenient.
df_lhs.join(df_rhs, ["key"]).show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_lhs.join(df_rhs, ["key"])

-- Example 9313
-------------------------------
|"KEY"  |"VALUE1"  |"VALUE2"  |
-------------------------------
|a      |1         |3         |
|b      |2         |4         |
-------------------------------

-- Example 9314
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
# Use & operator connect join expression. '|' and ~ are similar.
df_joined_multi_column = df_lhs.join(df_rhs, (df_lhs.col("key") == df_rhs.col("key")) & (df_lhs.col("value1") < df_rhs.col("value2"))).select(df_lhs["key"].as_("key"), "value1", "value2")
df_joined_multi_column.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_joined_multi_column

-- Example 9315
-------------------------------
|"KEY"  |"VALUE1"  |"VALUE2"  |
-------------------------------
|a      |1         |3         |
|b      |2         |4         |
-------------------------------

-- Example 9316
# copy the DataFrame if you want to do a self-join
from copy import copy

# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
df_lhs_copied = copy(df_lhs)
df_self_joined = df_lhs.join(df_lhs_copied, (df_lhs.col("key") == df_lhs_copied.col("key")) & (df_lhs.col("value1") == df_lhs_copied.col("value1")))

-- Example 9317
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key")).show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key"))

-- Example 9318
-----------------------------------------------------
|"l_av5t_KEY"  |"VALUE1"  |"r_1p6k_KEY"  |"VALUE2"  |
-----------------------------------------------------
|a             |1         |a             |3         |
|b             |2         |b             |4         |
-----------------------------------------------------

-- Example 9319
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key")).select(df_lhs["key"].alias("key1"), df_rhs["key"].alias("key2"), "value1", "value2").show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key")).select(df_lhs["key"].alias("key1"), df_rhs["key"].alias("key2"), "value1", "value2")

-- Example 9320
-----------------------------------------
|"KEY1"  |"KEY2"  |"VALUE1"  |"VALUE2"  |
-----------------------------------------
|a       |a       |1         |3         |
|b       |b       |2         |4         |
-----------------------------------------

-- Example 9321
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value1"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value2"])
df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key"), lsuffix="_left", rsuffix="_right").show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key"), lsuffix="_left", rsuffix="_right")

-- Example 9322
--------------------------------------------------
|"KEY_LEFT"  |"VALUE1"  |"KEY_RIGHT"  |"VALUE2"  |
--------------------------------------------------
|a           |1         |a            |3         |
|b           |2         |b            |4         |
--------------------------------------------------

-- Example 9323
from snowflake.snowpark.exceptions import SnowparkJoinException

df = session.table("sample_product_data")
# This fails because columns named "id" and "parent_id"
# are in the left and right DataFrames in the join.
try:
  df_joined = df.join(df, col("id") == col("parent_id")) # fails
except SnowparkJoinException as e:
  print(e.message)

-- Example 9324
You cannot join a DataFrame with itself because the column references cannot be resolved correctly. Instead, create a copy of the DataFrame with copy.copy(), and join the DataFrame with this copy.

-- Example 9325
# This fails because columns named "id" and "parent_id"
# are in the left and right DataFrames in the join.
try:
  df_joined = df.join(df, df["id"] == df["parent_id"])   # fails
except SnowparkJoinException as e:
  print(e.message)

-- Example 9326
You cannot join a DataFrame with itself because the column references cannot be resolved correctly. Instead, create a copy of the DataFrame with copy.copy(), and join the DataFrame with this copy.

-- Example 9327
from copy import copy

# Create a DataFrame object for the "sample_product_data" table for the left-hand side of the join.
df_lhs = session.table("sample_product_data")
# Clone the DataFrame object to use as the right-hand side of the join.
df_rhs = copy(df_lhs)

# Create a DataFrame that joins the two DataFrames
# for the "sample_product_data" table on the
# "id" and "parent_id" columns.
df_joined = df_lhs.join(df_rhs, df_lhs.col("id") == df_rhs.col("parent_id"))
df_joined.count()

-- Example 9328
# Import the col function from the functions module.
from snowflake.snowpark.functions import col

df_product_info = session.table("sample_product_data").select(col("id"), col("name"))
df_product_info.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_product_info

-- Example 9329
---------------------
|"ID"  |"NAME"      |
---------------------
|1     |Product 1   |
|2     |Product 1A  |
|3     |Product 1B  |
|4     |Product 2   |
|5     |Product 2A  |
|6     |Product 2B  |
|7     |Product 3   |
|8     |Product 3A  |
|9     |Product 3B  |
|10    |Product 4   |
---------------------

-- Example 9330
# Specify the equivalent of "WHERE id = 20"
# in a SQL SELECT statement.
df_filtered = df.filter(col("id") == 20)

-- Example 9331
df = session.create_dataframe([[1, 3], [2, 10]], schema=["a", "b"])
# Specify the equivalent of "WHERE a + b < 10"
# in a SQL SELECT statement.
df_filtered = df.filter((col("a") + col("b")) < 10)
df_filtered.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_filtered

-- Example 9332
-------------
|"A"  |"B"  |
-------------
|1    |3    |
-------------

-- Example 9333
df = session.create_dataframe([[1, 3], [2, 10]], schema=["a", "b"])
# Specify the equivalent of "SELECT b * 10 AS c"
# in a SQL SELECT statement.
df_selected = df.select((col("b") * 10).as_("c"))
df_selected.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_selected

-- Example 9334
-------
|"C"  |
-------
|30   |
|100  |
-------

-- Example 9335
dfX = session.create_dataframe([[1], [2]], schema=["a_in_X"])
dfY = session.create_dataframe([[1], [3]], schema=["b_in_Y"])
# Specify the equivalent of "X JOIN Y on X.a_in_X = Y.b_in_Y"
# in a SQL SELECT statement.
df_joined = dfX.join(dfY, col("a_in_X") == col("b_in_Y")).select(dfX["a_in_X"].alias("the_joined_column"))
df_joined.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_joined

-- Example 9336
-----------------------
|"THE_JOINED_COLUMN"  |
-----------------------
|1                    |
-----------------------

-- Example 9337
# Create two DataFrames to join
df_lhs = session.create_dataframe([["a", 1], ["b", 2]], schema=["key", "value"])
df_rhs = session.create_dataframe([["a", 3], ["b", 4]], schema=["key", "value"])
# Create a DataFrame that joins two other DataFrames (df_lhs and df_rhs).
# Use the DataFrame.col method to refer to the columns used in the join.
df_joined = df_lhs.join(df_rhs, df_lhs.col("key") == df_rhs.col("key")).select(df_lhs.col("key").as_("key"), df_lhs.col("value").as_("L"), df_rhs.col("value").as_("R"))
df_joined.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_joined

-- Example 9338
---------------------
|"KEY"  |"L"  |"R"  |
---------------------
|a      |1    |3    |
|b      |2    |4    |
---------------------

-- Example 9339
session.sql("""
  create or replace temp table "10tablename"(
  id123 varchar, -- case insensitive because it's not quoted.
  "3rdID" varchar, -- case sensitive.
  "id with space" varchar -- case sensitive.
)""").collect()
# Add return to the statement to return the collect() results in a Python worksheet

-- Example 9340
[Row(status='Table 10tablename successfully created.')]

-- Example 9341
session.sql("""insert into "10tablename" (id123, "3rdID", "id with space") values ('a', 'b', 'c')""").collect()
# Add return to the statement to return the collect() results in a Python worksheet

-- Example 9342
[Row(number of rows inserted=1)]

-- Example 9343
df = session.table('"10tablename"')
df.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df

-- Example 9344
---------------------------------------
|"ID123"  |"3rdID"  |"id with space"  |
---------------------------------------
|a        |b        |c                |
---------------------------------------

-- Example 9345
df.select(col("id123")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9346
[Row(ID123='a')]

-- Example 9347
df = session.table("\"10tablename\"")

-- Example 9348
df = session.table('"10tablename"')

-- Example 9349
df.select(col("3rdID")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9350
[Row(3rdID='b')]

-- Example 9351
df.select(col("id with space")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9352
[Row(id with space='c')]

-- Example 9353
df.select(col("\"id with space\"")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9354
[Row(id with space='c')]

-- Example 9355
session.sql('''
  create or replace temp table quoted(
  "name_with_""air""_quotes" varchar,
  """column_name_quoted""" varchar
)''').collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9356
[Row(status='Table QUOTED successfully created.')]

-- Example 9357
session.sql('''insert into quoted ("name_with_""air""_quotes", """column_name_quoted""") values ('a', 'b')''').collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9358
[Row(number of rows inserted=1)]

-- Example 9359
df_table = session.table("quoted")
df_table.select("\"name_with_\"\"air\"\"_quotes\"").collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9360
[Row(name_with_"air"_quotes='a')]

