-- Example 9361
df_table.select("\"\"\"column_name_quoted\"\"\"").collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9362
[Row("column_name_quoted"='b')]

-- Example 9363
# The following calls are NOT equivalent!
# The Snowpark library adds double quotes around the column name,
# which makes Snowflake treat the column name as case-sensitive.
df.select(col("id with space")).collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9364
[Row(id with space='c')]

-- Example 9365
from snowflake.snowpark.exceptions import SnowparkSQLException
try:
  df.select(col("ID WITH SPACE")).collect()
except SnowparkSQLException as e:
  print(e.message)

-- Example 9366
000904 (42000): SQL compilation error: error line 1 at position 7
invalid identifier '"ID WITH SPACE"'

-- Example 9367
# Import for the lit and col functions.
from snowflake.snowpark.functions import col, lit

# Show the first 10 rows in which num_items is greater than 5.
# Use `lit(5)` to create a Column object for the literal 5.
df_filtered = df.filter(col("num_items") > lit(5))

-- Example 9368
# Import for the lit function.
from snowflake.snowpark.functions import lit

 # Import for the DecimalType class.
from snowflake.snowpark.types import DecimalType

decimal_value = lit(0.05).cast(DecimalType(5,2))

-- Example 9369
df_product_info = session.table("sample_product_data").filter(col("id") == 1).select(col("name"), col("serial_number"))
df_product_info.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_product_info

-- Example 9370
-------------------------------
|"NAME"     |"SERIAL_NUMBER"  |
-------------------------------
|Product 1  |prod-1           |
-------------------------------

-- Example 9371
# Import the StructType
from snowflake.snowpark.types import *
# Get the StructType object that describes the columns in the
# underlying rowset.
table_schema = session.table("sample_product_data").schema
table_schema
StructType([StructField('ID', LongType(), nullable=True), StructField('PARENT_ID', LongType(), nullable=True), StructField('CATEGORY_ID', LongType(), nullable=True), StructField('NAME', StringType(), nullable=True), StructField('SERIAL_NUMBER', StringType(), nullable=True), StructField('KEY', LongType(), nullable=True), StructField('"3rd"', LongType(), nullable=True)])

-- Example 9372
# Create a DataFrame containing the "id" and "3rd" columns.
df_selected_columns = session.table("sample_product_data").select(col("id"), col("3rd"))
# Print out the names of the columns in the schema.
# This prints List["ID", "\"3rd\""]
df_selected_columns.schema.names

-- Example 9373
['ID', '"3rd"']

-- Example 9374
# Create a DataFrame with the "id" and "name" columns from the "sample_product_data" table.
# This does not execute the query.
df = session.table("sample_product_data").select(col("id"), col("name"))

# Send the query to the server for execution and
# return a list of Rows containing the results.
results = df.collect()
# Use a return statement to return the collect() results in a Python worksheet
# return results

-- Example 9375
# Create a DataFrame for the "sample_product_data" table.
df_products = session.table("sample_product_data")

# Send the query to the server for execution and
# print the count of rows in the table.
print(df_products.count())
12

-- Example 9376
# Create a DataFrame for the "sample_product_data" table.
df_products = session.table("sample_product_data")

# Send the query to the server for execution and
# print the results to the console.
# The query limits the number of rows to 10 by default.
df_products.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
return df_products

-- Example 9377
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

-- Example 9378
# Create a DataFrame for the "sample_product_data" table.
df_products = session.table("sample_product_data")

# Limit the number of rows to 20, rather than 10.
df_products.show(20)
# All rows are returned when you use return in a Python worksheet to return the DataFrame as a table
return df_products

-- Example 9379
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

-- Example 9380
df.write.mode("overwrite").save_as_table("table1")

-- Example 9381
import os
database = os.environ["snowflake_database"]  # use your own database and schema
schema = os.environ["snowflake_schema"]
view_name = "my_view"
df.create_or_replace_view(f"{database}.{schema}.{view_name}")

-- Example 9382
[Row(status='View MY_VIEW successfully created.')]

-- Example 9383
# Define a DataFrame
df_products = session.table("sample_product_data")
# Define a View name
view_name = "my_view"
# Create the view
df_products.create_or_replace_view(f"{view_name}")
# return the view name
return view_name + " successfully created"
my_view successfully created

-- Example 9384
from snowflake.snowpark.types import *

schema_for_data_file = StructType([
                          StructField("id", StringType()),
                          StructField("name", StringType())
                       ])

-- Example 9385
df_reader = session.read.schema(schema_for_data_file)

-- Example 9386
df_reader = df_reader.option("field_delimiter", ";").option("COMPRESSION", "NONE")

-- Example 9387
df = df_reader.csv("@s3_ts_stage/emails/data_0_0_0.csv")

-- Example 9388
# Import the sql_expr function from the functions module.
from snowflake.snowpark.functions import sql_expr

df = session.read.json("@my_stage").select(sql_expr("$1:color"))

-- Example 9389
from snowflake.snowpark.functions import col

df = session.table("car_sales")
df.select(col("src")["dealership"]).show()

-- Example 9390
----------------------------
|"""SRC""['DEALERSHIP']"   |
----------------------------
|"Valley View Auto Sales"  |
|"Tindel Toyota"           |
----------------------------

-- Example 9391
df = session.table("car_sales")
df.select(df["src"]["salesperson"]["name"]).show()

-- Example 9392
------------------------------------
|"""SRC""['SALESPERSON']['NAME']"  |
------------------------------------
|"Frank Beasley"                   |
|"Greg Northrup"                   |
------------------------------------

-- Example 9393
df = session.table("car_sales")
df.select(df["src"]["vehicle"][0]).show()
df.select(df["src"]["vehicle"][0]["price"]).show()

-- Example 9394
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

-- Example 9395
from snowflake.snowpark.functions import get, get_path, lit

df.select(get(col("src"), lit("dealership"))).show()
df.select(col("src")["dealership"]).show()

-- Example 9396
df.select(get_path(col("src"), lit("vehicle[0].make"))).show()
df.select(col("src")["vehicle"][0]["make"]).show()

-- Example 9397
# Import the objects for the data types, including StringType.
from snowflake.snowpark.types import *

df = session.table("car_sales")
df.select(col("src")["salesperson"]["id"]).show()
df.select(col("src")["salesperson"]["id"].cast(StringType())).show()

-- Example 9398
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

-- Example 9399
df = session.table("car_sales")
df.join_table_function("flatten", col("src")["customer"]).show()

-- Example 9400
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

-- Example 9401
df.join_table_function("flatten", col("src")["customer"]).select(col("value")["name"], col("value")["address"]).show()

-- Example 9402
-------------------------------------------------
|"""VALUE""['NAME']"   |"""VALUE""['ADDRESS']"  |
-------------------------------------------------
|"Joyce Ridgely"       |"San Francisco, CA"     |
|"Bradley Greenbloom"  |"New York, NY"          |
-------------------------------------------------

-- Example 9403
df.join_table_function("flatten", col("src")["customer"]).select(col("value")["name"].cast(StringType()).as_("Customer Name"), col("value")["address"].cast(StringType()).as_("Customer Address")).show()

-- Example 9404
-------------------------------------------
|"Customer Name"     |"Customer Address"  |
-------------------------------------------
|Joyce Ridgely       |San Francisco, CA   |
|Bradley Greenbloom  |New York, NY        |
-------------------------------------------

-- Example 9405
# Get the list of the files in a stage.
# The collect() method causes this SQL statement to be executed.
session.sql("create or replace temp stage my_stage").collect()

-- Example 9406
# Prepend a return statement to return the collect() results in a Python worksheet
[Row(status='Stage area MY_STAGE successfully created.')]

-- Example 9407
stage_files_df = session.sql("ls @my_stage").collect()
# Prepend a return statement to return the collect() results in a Python worksheet
# Resume the operation of a warehouse.
# Note that you must call the collect method to execute
# the SQL statement.
session.sql("alter warehouse if exists my_warehouse resume if suspended").collect()

-- Example 9408
# Prepend a return statement to return the collect() results in a Python worksheet
[Row(status='Statement executed successfully.')]

-- Example 9409
# Set up a SQL statement to copy data from a stage to a table.
session.sql("copy into sample_product_data from @my_stage file_format=(type = csv)").collect()
# Prepend a return statement to return the collect() results in a Python worksheet

-- Example 9410
[Row(status='Copy executed with 0 files processed.')]

-- Example 9411
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

-- Example 9412
000904 (42000): SQL compilation error: error line 1 at position 104
invalid identifier 'SIZE'

-- Example 9413
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

-- Example 9414
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

-- Example 9415
python_df = session.create_dataframe(["a", "b", "c"])
pandas_df = python_df.to_pandas()

-- Example 9416
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

-- Example 9417
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

-- Example 9418
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df_filtered = df.filter((col("A") > 1) & (col("B") < 100))  # Must use parenthesis before and after operator &.

>>> # The following two result in the same SQL query:
>>> df.filter(col("a") > 1).collect()
[Row(A=3, B=4)]
>>> df.filter("a > 1").collect()  # use SQL expression
[Row(A=3, B=4)]

-- Example 9419
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:DeleteObject",
              "s3:DeleteObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<bucket>/<prefix>/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<bucket>",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "<prefix>/*"
                    ]
                }
            }
        }
    ]
}

-- Example 9420
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<bucket>/<prefix>/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<bucket>",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "<prefix>/*"
                    ]
                }
            }
        }
    ]
}

-- Example 9421
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 9422
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 9423
DESC INTEGRATION <integration_name>;

-- Example 9424
DESC INTEGRATION s3_int;

-- Example 9425
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+
| property                  | property_type | property_value                                                                 | property_default |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------|
| ENABLED                   | Boolean       | true                                                                           | false            |
| STORAGE_ALLOWED_LOCATIONS | List          | s3://mybucket1/mypath1/,s3://mybucket2/mypath2/                                | []               |
| STORAGE_BLOCKED_LOCATIONS | List          | s3://mybucket1/mypath1/sensitivedata/,s3://mybucket2/mypath2/sensitivedata/    | []               |
| STORAGE_AWS_IAM_USER_ARN  | String        | arn:aws:iam::123456789001:user/abc1-b-self1234                                 |                  |
| STORAGE_AWS_ROLE_ARN      | String        | arn:aws:iam::001234567890:role/myrole                                          |                  |
| STORAGE_AWS_EXTERNAL_ID   | String        | MYACCOUNT_SFCRole=2_a123456/s0aBCDEfGHIJklmNoPq=                               |                  |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+

-- Example 9426
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake_external_id>"
        }
      }
    }
  ]
}

-- Example 9427
GRANT CREATE STAGE ON SCHEMA public TO ROLE myrole;

GRANT USAGE ON INTEGRATION s3_int TO ROLE myrole;

