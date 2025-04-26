-- Example 9227
[Row(name_with_"air"_quotes='a')]

-- Example 9228
df_table.select("\"\"\"column_name_quoted\"\"\"").collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9229
[Row("column_name_quoted"='b')]

-- Example 9230
# The following calls are NOT equivalent!
# The Snowpark library adds double quotes around the column name,
# which makes Snowflake treat the column name as case-sensitive.
df.select(col("id with space")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9231
[Row(id with space='c')]

-- Example 9232
from snowflake.snowpark.exceptions import SnowparkSQLException
try:
  df.select(col("ID WITH SPACE")).collect()
except SnowparkSQLException as e:
  print(e.message)

-- Example 9233
000904 (42000): SQL compilation error: error line 1 at position 7
invalid identifier '"ID WITH SPACE"'

-- Example 9234
# Import for the lit and col functions.
from snowflake.snowpark.functions import col, lit

# Show the first 10 rows in which num_items is greater than 5.
# Use `lit(5)` to create a Column object for the literal 5.
df_filtered = df.filter(col("num_items") > lit(5))

-- Example 9235
# Import for the lit function.
from snowflake.snowpark.functions import lit

 # Import for the DecimalType class.
from snowflake.snowpark.types import DecimalType

decimal_value = lit(0.05).cast(DecimalType(5,2))

-- Example 9236
df_product_info = session.table("sample_product_data").filter(col("id") == 1).select(col("name"), col("serial_number"))
df_product_info.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_product_info

-- Example 9237
-------------------------------
|"NAME"     |"SERIAL_NUMBER"  |
-------------------------------
|Product 1  |prod-1           |
-------------------------------

-- Example 9238
# Import the StructType
from snowflake.snowpark.types import *
# Get the StructType object that describes the columns in the
# underlying rowset.
table_schema = session.table("sample_product_data").schema
table_schema
StructType([StructField('ID', LongType(), nullable=True), StructField('PARENT_ID', LongType(), nullable=True), StructField('CATEGORY_ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('SERIAL_NUMBER', StringType(), nullable=True), StructField('KEY', LongType(), nullable=True), StructField('"3rd"', LongType(), nullable=True)])

-- Example 9239
# Create a DataFrame containing the "id" and "3rd" columns.
df_selected_columns = session.table("sample_product_data").select(col("id"), col("3rd"))
# Print out the names of the columns in the schema.
# This prints List["ID", "\"3rd\""]
df_selected_columns.schema.names

-- Example 9240
['ID', '"3rd"']

-- Example 9241
# Create a DataFrame with the "id" and "name" columns from the "sample_product_data" table.
# This does not execute the query.
df = session.table("sample_product_data").select(col("id"), col("name"))

# Send the query to the server for execution and
# return a list of Rows containing the results.
results = df.collect()
# Use a return statement to return the collect() results in a Python worksheet
# return results

-- Example 9242
# Create a DataFrame for the "sample_product_data" table.
df_products = session.table("sample_product_data")

# Send the query to the server for execution and
# print the count of rows in the table.
print(df_products.count())
12

-- Example 9243
# Create a DataFrame for the "sample_product_data" table.
df_products = session.table("sample_product_data")

# Send the query to the server for execution and
# print the results to the console.
# The query limits the number of rows to 10 by default.
df_products.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_products

-- Example 9244
-------------------------------------------------------------------------------------
|"ID"  |"PARENT_ID"  |"CATEGORY_ID"  |"NAME"      |"SERIAL_NUMBER"  |"KEY"  |"3rd"  |
-------------------------------------------------------------------------------------
|1     |0            |5              |Product 1   |prod-1           |1      |10     |
|2     |1            |5              |Product 1A  |prod-1-A         |1      |20     |
|3     |1            |5              |Product 1B  |prod-1-B         |1      |30     |
|4     |0            |10             |Product 2   |prod-2           |2      |40     |
|5     |4            |10             |Product 2A  |prod-2-A         |2      |50     |
|6     |4            |10             |Product 2B  |prod-2-B         |2      |60     |
|7     |0            |20             |Product 3   |prod-3           |3      |70     |
|8     |7            |20             |Product 3A  |prod-3-A         |3      |80     |
|9     |7            |20             |Product 3B  |prod-3-B         |3      |90     |
|10    |0            |50             |Product 4   |prod-4           |4      |100    |
-------------------------------------------------------------------------------------

-- Example 9245
# Create a DataFrame for the "sample_product_data" table.
df_products = session.table("sample_product_data")

# Limit the number of rows to 20, rather than 10.
df_products.show(20)
# All rows are returned when you use return in a Python worksheet to return the DataFrame as a table
return df_products

-- Example 9246
-------------------------------------------------------------------------------------
|"ID"  |"PARENT_ID"  |"CATEGORY_ID"  |"NAME"      |"SERIAL_NUMBER"  |"KEY"  |"3rd"  |
-------------------------------------------------------------------------------------
|1     |0            |5              |Product 1   |prod-1           |1      |10     |
|2     |1            |5              |Product 1A  |prod-1-A         |1      |20     |
|3     |1            |5              |Product 1B  |prod-1-B         |1      |30     |
|4     |0            |10             |Product 2   |prod-2           |2      |40     |
|5     |4            |10             |Product 2A  |prod-2-A         |2      |50     |
|6     |4            |10             |Product 2B  |prod-2-B         |2      |60     |
|7     |0            |20             |Product 3   |prod-3           |3      |70     |
|8     |7            |20             |Product 3A  |prod-3-A         |3      |80     |
|9     |7            |20             |Product 3B  |prod-3-B         |3      |90     |
|10    |0            |50             |Product 4   |prod-4           |4      |100    |
|11    |10           |50             |Product 4A  |prod-4-A         |4      |100    |
|12    |10           |50             |Product 4B  |prod-4-B         |4      |100    |
-------------------------------------------------------------------------------------

-- Example 9247
df.write.mode("overwrite").save_as_table("table1")

-- Example 9248
import os
database = os.environ["snowflake_database"]  # use your own database and schema
schema = os.environ["snowflake_schema"]
view_name = "my_view"
df.create_or_replace_view(f"{database}.{schema}.{view_name}")

-- Example 9249
[Row(status='View MY_VIEW successfully created.')]

-- Example 9250
# Define a DataFrame
df_products = session.table("sample_product_data")
# Define a View name
view_name = "my_view"
# Create the view
df_products.create_or_replace_view(f"{view_name}")
# return the view name
return view_name + " successfully created"
my_view successfully created

-- Example 9251
from snowflake.snowpark.types import *

schema_for_data_file = StructType([
                          StructField("id", StringType()),
                          StructField("name", StringType())
                       ])

-- Example 9252
df_reader = session.read.schema(schema_for_data_file)

-- Example 9253
df_reader = df_reader.option("field_delimiter", ";").option("COMPRESSION", "NONE")

-- Example 9254
df = df_reader.csv("@s3_ts_stage/emails/data_0_0_0.csv")

-- Example 9255
# Import the sql_expr function from the functions module.
from snowflake.snowpark.functions import sql_expr

df = session.read.json("@my_stage").select(sql_expr("$1:color"))

-- Example 9256
from snowflake.snowpark.functions import col

df = session.table("car_sales")
df.select(col("src")["dealership"]).show()

-- Example 9257
----------------------------
|"""SRC""['DEALERSHIP']"   |
----------------------------
|"Valley View Auto Sales"  |
|"Tindel Toyota"           |
----------------------------

-- Example 9258
df = session.table("car_sales")
df.select(df["src"]["salesperson"]["name"]).show()

-- Example 9259
------------------------------------
|"""SRC""['SALESPERSON']['NAME']"  |
------------------------------------
|"Frank Beasley"                   |
|"Greg Northrup"                   |
------------------------------------

-- Example 9260
df = session.table("car_sales")
df.select(df["src"]["vehicle"][0]).show()
df.select(df["src"]["vehicle"][0]["price"]).show()

-- Example 9261
---------------------------
|"""SRC""['VEHICLE'][0]"  |
---------------------------
|{                        |
|  "extras": [            |
|    "ext warranty",      |
|    "paint protection"   |
|  ],                     |
|  "make": "Honda",       |
|  "model": "Civic",      |
|  "price": "20275",      |
|  "year": "2017"         |
|}                        |
|{                        |
|  "extras": [            |
|    "ext warranty",      |
|    "rust proofing",     |
|    "fabric protection"  |
|  ],                     |
|  "make": "Toyota",      |
|  "model": "Camry",      |
|  "price": "23500",      |
|  "year": "2017"         |
|}                        |
---------------------------

------------------------------------
|"""SRC""['VEHICLE'][0]['PRICE']"  |
------------------------------------
|"20275"                           |
|"23500"                           |
------------------------------------

-- Example 9262
from snowflake.snowpark.functions import get, get_path, lit

df.select(get(col("src"), lit("dealership"))).show()
df.select(col("src")["dealership"]).show()

-- Example 9263
df.select(get_path(col("src"), lit("vehicle[0].make"))).show()
df.select(col("src")["vehicle"][0]["make"]).show()

-- Example 9264
# Import the objects for the data types, including StringType.
from snowflake.snowpark.types import *

df = session.table("car_sales")
df.select(col("src")["salesperson"]["id"]).show()
df.select(col("src")["salesperson"]["id"].cast(StringType())).show()

-- Example 9265
----------------------------------
|"""SRC""['SALESPERSON']['ID']"  |
----------------------------------
|"55"                            |
|"274"                           |
----------------------------------

---------------------------------------------------
|"CAST (""SRC""['SALESPERSON']['ID'] AS STRING)"  |
---------------------------------------------------
|55                                               |
|274                                              |
---------------------------------------------------

-- Example 9266
df = session.table("car_sales")
df.join_table_function("flatten", col("src")["customer"]).show()

-- Example 9267
----------------------------------------------------------------------------------------------------------------------------------------------------------
|"SRC"                                      |"SEQ"  |"KEY"  |"PATH"  |"INDEX"  |"VALUE"                            |"THIS"                               |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|{                                          |1      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "San Francisco, CA",  |  {                                  |
|    {                                      |       |       |        |         |  "name": "Joyce Ridgely",         |    "address": "San Francisco, CA",  |
|      "address": "San Francisco, CA",      |       |       |        |         |  "phone": "16504378889"           |    "name": "Joyce Ridgely",         |
|      "name": "Joyce Ridgely",             |       |       |        |         |}                                  |    "phone": "16504378889"           |
|      "phone": "16504378889"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Valley View Auto Sales",  |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "55",                            |       |       |        |         |                                   |                                     |
|    "name": "Frank Beasley"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "paint protection"                 |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Honda",                     |       |       |        |         |                                   |                                     |
|      "model": "Civic",                    |       |       |        |         |                                   |                                     |
|      "price": "20275",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
|{                                          |2      |NULL   |[0]     |0        |{                                  |[                                    |
|  "customer": [                            |       |       |        |         |  "address": "New York, NY",       |  {                                  |
|    {                                      |       |       |        |         |  "name": "Bradley Greenbloom",    |    "address": "New York, NY",       |
|      "address": "New York, NY",           |       |       |        |         |  "phone": "12127593751"           |    "name": "Bradley Greenbloom",    |
|      "name": "Bradley Greenbloom",        |       |       |        |         |}                                  |    "phone": "12127593751"           |
|      "phone": "12127593751"               |       |       |        |         |                                   |  }                                  |
|    }                                      |       |       |        |         |                                   |]                                    |
|  ],                                       |       |       |        |         |                                   |                                     |
|  "date": "2017-04-28",                    |       |       |        |         |                                   |                                     |
|  "dealership": "Tindel Toyota",           |       |       |        |         |                                   |                                     |
|  "salesperson": {                         |       |       |        |         |                                   |                                     |
|    "id": "274",                           |       |       |        |         |                                   |                                     |
|    "name": "Greg Northrup"                |       |       |        |         |                                   |                                     |
|  },                                       |       |       |        |         |                                   |                                     |
|  "vehicle": [                             |       |       |        |         |                                   |                                     |
|    {                                      |       |       |        |         |                                   |                                     |
|      "extras": [                          |       |       |        |         |                                   |                                     |
|        "ext warranty",                    |       |       |        |         |                                   |                                     |
|        "rust proofing",                   |       |       |        |         |                                   |                                     |
|        "fabric protection"                |       |       |        |         |                                   |                                     |
|      ],                                   |       |       |        |         |                                   |                                     |
|      "make": "Toyota",                    |       |       |        |         |                                   |                                     |
|      "model": "Camry",                    |       |       |        |         |                                   |                                     |
|      "price": "23500",                    |       |       |        |         |                                   |                                     |
|      "year": "2017"                       |       |       |        |         |                                   |                                     |
|    }                                      |       |       |        |         |                                   |                                     |
|  ]                                        |       |       |        |         |                                   |                                     |
|}                                          |       |       |        |         |                                   |                                     |
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 9268
df.join_table_function("flatten", col("src")["customer"]).select(col("value")["name"], col("value")["address"]).show()

-- Example 9269
-------------------------------------------------
|"""VALUE""['NAME']"   |"""VALUE""['ADDRESS']"  |
-------------------------------------------------
|"Joyce Ridgely"       |"San Francisco, CA"     |
|"Bradley Greenbloom"  |"New York, NY"          |
-------------------------------------------------

-- Example 9270
df.join_table_function("flatten", col("src")["customer"]).select(col("value")["name"].cast(StringType()).as_("Customer Name"), col("value")["address"].cast(StringType()).as_("Customer Address")).show()

-- Example 9271
-------------------------------------------
|"Customer Name"     |"Customer Address"  |
-------------------------------------------
|Joyce Ridgely       |San Francisco, CA   |
|Bradley Greenbloom  |New York, NY        |
-------------------------------------------

-- Example 9272
# Get the list of the files in a stage.
# The collect() method causes this SQL statement to be executed.
session.sql("create or replace temp stage my_stage").collect()

-- Example 9273
# Prepend a return statement to return the collect() results in a Python worksheet
[Row(status='Stage area MY_STAGE successfully created.')]

-- Example 9274
stage_files_df = session.sql("ls @my_stage").collect()
# Prepend a return statement to return the collect() results in a Python worksheet
# Resume the operation of a warehouse.
# Note that you must call the collect method to execute
# the SQL statement.
session.sql("alter warehouse if exists my_warehouse resume if suspended").collect()

-- Example 9275
# Prepend a return statement to return the collect() results in a Python worksheet
[Row(status='Statement executed successfully.')]

-- Example 9276
# Set up a SQL statement to copy data from a stage to a table.
session.sql("copy into sample_product_data from @my_stage file_format=(type = csv)").collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9277
[Row(status='Copy executed with 0 files processed.')]

-- Example 9278
df = session.sql("select id, parent_id from sample_product_data where id < 10")
# Because the underlying SQL statement for the DataFrame is a SELECT statement,
# you can call the filter method to transform this DataFrame.
results = df.filter(col("id") < 3).select(col("id")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

# In this example, the underlying SQL statement is not a SELECT statement.
df = session.sql("ls @my_stage")
# Calling the filter method results in an error.
try:
  df.filter(col("size") > 50).collect()
except SnowparkSQLException as e:
  print(e.message)

-- Example 9279
000904 (42000): SQL compilation error: error line 1 at position 104
invalid identifier 'SIZE'

-- Example 9280
import threading
from snowflake.snowpark import Session

# Define the list of tables
tables = ["customers", "orders", "products"]

# Function to copy data from stage to tables
def execute_copy(table_name):
    try:
        # Read data from the stage using DataFrameReader
        df = (
            session.read.option("SKIP_HEADER", 1)
            .option("PATTERN", f"{table_name}[.]csv")
            .option("FORCE", True)
            .csv(f"@my_stage")
        )

        # Copy data into the target table
        df.copy_into_table(
            table_name=table_name, target_columns=session.table(table_name).columns
        )

    except Exception as e:
        print(f"Failed to copy data into {table_name}, Error: {e}")

# Create an empty list of threads
threads = []

# Loop through and start a thread for each table
for table in tables:
    thread = threading.Thread(target=execute_copy, args=(table,))
    threads.append(thread)
    thread.start()

# Wait for all threads to finish
for thread in threads:
    thread.join()

-- Example 9281
from concurrent.futures import ThreadPoolExecutor
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col, month, sum, lit

# List of customers
customers = ["customer1", "customer2", "customer3"]

# Define a function to process each customer transaction table
def process_customer_table(customer_name):
    table_name = f"transaction_{customer_name}"

    try:
        # Load the customer transaction table
        df = session.table(table_name)
        print(f"Processing {table_name}...")

        # Filter data by positive values and non null categories
        df_filtered = df.filter((col("value") > 0) & col("category").is_not_null())

        # Perform aggregation: Sum of value by category and month
        df_aggregated = df_filtered.with_column("month", month(col("date"))).with_column("customer_name", lit(customer_name)).group_by(col("category"), col("month"), col("customer_name")).agg(sum("value").alias("total_value"))

        # Save the processed data into a new result table
        df_aggregated.show()
        df_aggregated.write.save_as_table("aggregate_customers", mode="append")
        print(f"Data from {table_name} processed and saved")

    except Exception as e:
        print(f"Error processing {table_name}: {e}")

# Using ThreadPoolExecutor to handle concurrency
with ThreadPoolExecutor(max_workers=3) as executor:
    # Submit tasks for each customer table
    executor.map(process_customer_table, customers)

# Display the results from the aggregate table
session.table("aggregate_customers").show()

-- Example 9282
python_df = session.create_dataframe(["a", "b", "c"])
pandas_df = python_df.to_pandas()

-- Example 9283
session.sql('CREATE OR REPLACE TABLE sample_product_data (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT)').collect()

-- Example 9284
[Row(status='Table SAMPLE_PRODUCT_DATA successfully created.')]

-- Example 9285
session.sql("""
INSERT INTO sample_product_data VALUES
(1, 0, 5, 'Product 1', 'prod-1', 1, 10),
(2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20),
(3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30),
(4, 0, 10, 'Product 2', 'prod-2', 2, 40),
(5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50),
(6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60),
(7, 0, 20, 'Product 3', 'prod-3', 3, 70),
(8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80),
(9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90),
(10, 0, 50, 'Product 4', 'prod-4', 4, 100),
(11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100),
(12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100)
""").collect()

-- Example 9286
[Row(number of rows inserted=12)]

-- Example 9287
session.sql("SELECT count(*) FROM sample_product_data").collect()

-- Example 9288
[Row(COUNT(*)=12)]

-- Example 9289
CREATE OR REPLACE TABLE sample_product_data
  (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT);

INSERT INTO sample_product_data VALUES
  (1, 0, 5, 'Product 1', 'prod-1', 1, 10),
  (2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20),
  (3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30),
  (4, 0, 10, 'Product 2', 'prod-2', 2, 40),
  (5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50),
  (6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60),
  (7, 0, 20, 'Product 3', 'prod-3', 3, 70),
  (8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80),
  (9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90),
  (10, 0, 50, 'Product 4', 'prod-4', 4, 100),
  (11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100),
  (12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100);

SELECT count(*) FROM sample_product_data;

-- Example 9290
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
  df_table = session.table("sample_product_data")

-- Example 9291
# Create a DataFrame from the data in the "sample_product_data" table.
df_table = session.table("sample_product_data")

# To print out the first 10 rows, call df_table.show()

-- Example 9292
# Create a DataFrame with one column named a from specified values.
df1 = session.create_dataframe([1, 2, 3, 4]).to_df("a")
df1.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df1

-- Example 9293
-------
|"A"  |
-------
|1    |
|2    |
|3    |
|4    |
-------

