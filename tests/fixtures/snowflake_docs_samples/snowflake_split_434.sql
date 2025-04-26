-- Example 29052
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF4<?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29053
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF5<?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29054
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF6<?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29055
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF7<?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29056
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF8<?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29057
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF9<?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29058
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF10<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29059
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF11<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29060
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF12<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29061
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF13<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29062
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF14<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29063
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF15<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29064
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF16<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29065
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF17<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29066
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF18<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29067
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF19<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29068
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF20<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29069
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF21<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29070
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF22<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29071
# Import the upper function from the functions module.
from snowflake.snowpark.functions import upper, col
session.table("sample_product_data").select(upper(col("name")).alias("upper_name")).collect()

-- Example 29072
[Row(UPPER_NAME='PRODUCT 1'), Row(UPPER_NAME='PRODUCT 1A'), Row(UPPER_NAME='PRODUCT 1B'), Row(UPPER_NAME='PRODUCT 2'),
Row(UPPER_NAME='PRODUCT 2A'), Row(UPPER_NAME='PRODUCT 2B'), Row(UPPER_NAME='PRODUCT 3'), Row(UPPER_NAME='PRODUCT 3A'),
Row(UPPER_NAME='PRODUCT 3B'), Row(UPPER_NAME='PRODUCT 4'), Row(UPPER_NAME='PRODUCT 4A'), Row(UPPER_NAME='PRODUCT 4B')]

-- Example 29073
# Import the call_function function from the functions module.
from snowflake.snowpark.functions import call_function
df = session.create_dataframe([[1, 2], [3, 4]], schema=["col1", "col2"])
# Call the system-defined function RADIANS() on col1.
df.select(call_function("radians", col("col1"))).collect()

-- Example 29074
[Row(RADIANS("COL1")=0.017453292519943295), Row(RADIANS("COL1")=0.05235987755982988)]

-- Example 29075
# Import the call_function function from the functions module.
from snowflake.snowpark.functions import function

# Create a function object for the system-defined function RADIANS().
radians = function("radians")
df = session.create_dataframe([[1, 2], [3, 4]], schema=["col1", "col2"])
# Call the system-defined function RADIANS() on col1.
df.select(radians(col("col1"))).collect()

-- Example 29076
[Row(RADIANS("COL1")=0.017453292519943295), Row(RADIANS("COL1")=0.05235987755982988)]

-- Example 29077
# Import the call_udf function from the functions module.
from snowflake.snowpark.functions import call_udf

# Runs the scalar function 'minus_one' on col1 of df.
df = session.create_dataframe([[1, 2], [3, 4]], schema=["col1", "col2"])
df.select(call_udf("minus_one", col("col1"))).collect()

-- Example 29078
[Row(MINUS_ONE("COL1")=0), Row(MINUS_ONE("COL1")=2)]

-- Example 29079
from snowflake.snowpark.types import IntegerType, StructField, StructType
from snowflake.snowpark.functions import udtf, lit
class GeneratorUDTF:
    def process(self, n):
        for i in range(n):
            yield (i, )
generator_udtf = udtf(GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
session.table_function(generator_udtf(lit(3))).collect()

-- Example 29080
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

-- Example 29081
from snowflake.snowpark.functions import table_function
split_to_table = table_function("split_to_table")
df = session.create_dataframe([
  ["John", "James", "address1 address2 address3"],
  ["Mike", "James", "address4 address5 address6"],
  ["Cathy", "Stone", "address4 address5 address6"],
],
schema=["first_name", "last_name", "addresses"])
df.join_table_function(split_to_table(df["addresses"], lit(" ")).over(partition_by="last_name", order_by="first_name")).show()

-- Example 29082
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

-- Example 29083
session.call("your_proc_name", 1)

-- Example 29084
0

-- Example 29085
CREATE OR REPLACE AGGREGATE FUNCTION PYTHON_SUM(a INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'PythonSum'
AS $$
class PythonSum:
  def __init__(self):
    # This aggregate state is a primitive Python data type.
    self._partial_sum = 0

  @property
  def aggregate_state(self):
    return self._partial_sum

  def accumulate(self, input_value):
    self._partial_sum += input_value

  def merge(self, other_partial_sum):
    self._partial_sum += other_partial_sum

  def finish(self):
    return self._partial_sum
$$;

-- Example 29086
CREATE OR REPLACE TABLE sales(item STRING, price INT);

INSERT INTO sales VALUES ('car', 10000), ('motorcycle', 5000), ('car', 7500), ('motorcycle', 3500), ('motorcycle', 1500), ('car', 20000);

SELECT * FROM sales;

-- Example 29087
SELECT python_sum(price) FROM sales;

-- Example 29088
SELECT sum(col) FROM sales;

-- Example 29089
SELECT item, python_sum(price) FROM sales GROUP BY item;

-- Example 29090
CREATE OR REPLACE AGGREGATE FUNCTION python_avg(a INT)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'PythonAvg'
AS $$
from dataclasses import dataclass

@dataclass
class AvgAggState:
    count: int
    sum: int

class PythonAvg:
    def __init__(self):
        # This aggregate state is an object data type.
        self._agg_state = AvgAggState(0, 0)

    @property
    def aggregate_state(self):
        return self._agg_state

    def accumulate(self, input_value):
        sum = self._agg_state.sum
        count = self._agg_state.count

        self._agg_state.sum = sum + input_value
        self._agg_state.count = count + 1

    def merge(self, other_agg_state):
        sum = self._agg_state.sum
        count = self._agg_state.count

        other_sum = other_agg_state.sum
        other_count = other_agg_state.count

        self._agg_state.sum = sum + other_sum
        self._agg_state.count = count + other_count

    def finish(self):
        sum = self._agg_state.sum
        count = self._agg_state.count
        return sum / count
$$;

-- Example 29091
CREATE OR REPLACE TABLE sales(item STRING, price INT);
INSERT INTO sales VALUES ('car', 10000), ('motorcycle', 5000), ('car', 7500), ('motorcycle', 3500), ('motorcycle', 1500), ('car', 20000);

-- Example 29092
SELECT python_avg(price) FROM sales;

-- Example 29093
SELECT avg(price) FROM sales;

-- Example 29094
SELECT item, python_avg(price) FROM sales GROUP BY item;

-- Example 29095
CREATE OR REPLACE AGGREGATE FUNCTION pythonGetUniqueValues(input ARRAY)
  RETURNS ARRAY
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'PythonGetUniqueValues'
AS $$
class PythonGetUniqueValues:
    def __init__(self):
        self._agg_state = set()

    @property
    def aggregate_state(self):
        return self._agg_state

    def accumulate(self, input):
        self._agg_state.update(input)

    def merge(self, other_agg_state):
        self._agg_state.update(other_agg_state)

    def finish(self):
        return list(self._agg_state)
$$;

-- Example 29096
CREATE OR REPLACE TABLE array_table(x array) AS
SELECT ARRAY_CONSTRUCT(0, 1, 2, 3, 4, 'foo', 'bar', 'snowflake') UNION ALL
SELECT ARRAY_CONSTRUCT(1, 3, 5, 7, 9, 'foo', 'barbar', 'snowpark') UNION ALL
SELECT ARRAY_CONSTRUCT(0, 2, 4, 6, 8, 'snow');

SELECT * FROM array_table;

SELECT pythonGetUniqueValues(x) FROM array_table;

-- Example 29097
CREATE OR REPLACE AGGREGATE FUNCTION pythonMapCount(input STRING)
  RETURNS OBJECT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'PythonMapCount'
AS $$
from collections import defaultdict

class PythonMapCount:
    def __init__(self):
        self._agg_state = defaultdict(int)

    @property
    def aggregate_state(self):
        return self._agg_state

    def accumulate(self, input):
        # Increment count of lowercase input
        self._agg_state[input.lower()] += 1

    def merge(self, other_agg_state):
        for item, count in other_agg_state.items():
            self._agg_state[item] += count

    def finish(self):
        return dict(self._agg_state)
$$;

-- Example 29098
CREATE OR REPLACE TABLE string_table(x STRING);
INSERT INTO string_table SELECT 'foo' FROM TABLE(GENERATOR(ROWCOUNT => 1000));
INSERT INTO string_table SELECT 'bar' FROM TABLE(GENERATOR(ROWCOUNT => 2000));
INSERT INTO string_table SELECT 'snowflake' FROM TABLE(GENERATOR(ROWCOUNT => 50));
INSERT INTO string_table SELECT 'snowpark' FROM TABLE(GENERATOR(ROWCOUNT => 123));
INSERT INTO string_table SELECT 'SnOw' FROM TABLE(GENERATOR(ROWCOUNT => 1));
INSERT INTO string_table SELECT 'snow' FROM TABLE(GENERATOR(ROWCOUNT => 4));

SELECT pythonMapCount(x) FROM string_table;

-- Example 29099
CREATE OR REPLACE AGGREGATE FUNCTION pythonTopK(input INT, k INT)
  RETURNS ARRAY
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'PythonTopK'
AS $$
import heapq
from dataclasses import dataclass
import itertools
from typing import List

@dataclass
class AggState:
    minheap: List[int]
    k: int

class PythonTopK:
    def __init__(self):
        self._agg_state = AggState([], 0)

    @property
    def aggregate_state(self):
        return self._agg_state

    @staticmethod
    def get_top_k_items(minheap, k):
      # Return k smallest elements if there are more than k elements on the min heap.
      if (len(minheap) > k):
        return [heapq.heappop(minheap) for i in range(k)]
      return minheap

    def accumulate(self, input, k):
        self._agg_state.k = k

        # Store the input as negative value, as heapq is a min heap.
        heapq.heappush(self._agg_state.minheap, -input)

        # Store only top k items on the min heap.
        self._agg_state.minheap = self.get_top_k_items(self._agg_state.minheap, k)

    def merge(self, other_agg_state):
        k = self._agg_state.k if self._agg_state.k > 0 else other_agg_state.k

        # Merge two min heaps by popping off elements from one and pushing them onto another.
        while(len(other_agg_state.minheap) > 0):
            heapq.heappush(self._agg_state.minheap, heapq.heappop(other_agg_state.minheap))

        # Store only k elements on the min heap.
        self._agg_state.minheap = self.get_top_k_items(self._agg_state.minheap, k)

    def finish(self):
        return [-x for x in self._agg_state.minheap]
$$;

-- Example 29100
CREATE OR REPLACE TABLE numbers_table(num_column INT);
INSERT INTO numbers_table SELECT 5 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 1 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 9 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 7 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 10 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 3 FROM TABLE(GENERATOR(ROWCOUNT => 10));

-- Return top 15 largest values from numbers_table.
SELECT pythonTopK(num_column, 15) FROM numbers_table;

-- Example 29101
// Import the upper function from the functions object.
import com.snowflake.snowpark.functions._
...
session.table("products").select(upper(col("name"))).show()

-- Example 29102
// Import the callBuiltin function from the functions object.
import com.snowflake.snowpark.functions._
...
// Call the system-defined function RADIANS() on col1.
val result = df.select(callBuiltin("radians", col("col1"))).collect()

-- Example 29103
// Import the callBuiltin function from the functions object.
import com.snowflake.snowpark.functions._
...
// Create a function object for the system-defined function RADIANS().
val radians = builtin("radians")
// Call the system-defined function RADIANS() on col1.
val result = df.select(radians(col("col1"))).collect()

-- Example 29104
// Import the callUDF function from the functions object.
import com.snowflake.snowpark.functions._
...
// Runs the scalar function 'myFunction' on col1 and col2 of df.
val result =
    df.select(
        callUDF("myDB.schema.myFunction", col("col1"), col("col2"))
    ).collect()

-- Example 29105
CREATE OR REPLACE FUNCTION product_by_category_id(cat_id INT)
  RETURNS TABLE(id INT, name VARCHAR)
  AS
  $$
    SELECT id, name
      FROM sample_product_data
      WHERE category_id = cat_id
  $$
  ;

-- Example 29106
val dfTableFunctionOutput = session.tableFunction(TableFunction("product_by_category_id"), Map("cat_id" -> lit(10)))
dfTableFunctionOutput.show()

-- Example 29107
val session = Session.builder.configFile("my_config.properties").create

// Assign the lambda function.
val func = (session: Session, num: Int) => num + 1

// Execute the function locally.
val result = session.sproc.runLocally(func, 1)
print("\nResult: " + result)

-- Example 29108
val session = Session.builder.configFile("my_config.properties").create

val name: String = "add_two"

val tempSP: StoredProcedure =
  session.sproc.registerTemporary(
    name,
    (session: Session, num: Int) => num + 2
  )

session.storedProcedure(name, 1).show()

// Execute the procedure on the server by passing the procedure's name.
session.storedProcedure(incrementProc, 1).show();

// Execute the procedure on the server by passing a variable
// representing the procedure.
session.storedProcedure(tempSP, 1).show();

-- Example 29109
val sv = new Variant("{\"a\": [1, 2], \"b\": 3, \"c\": \"xyz\"}")
  println(sv.asJsonNode().get("a").get(0))
output
1

-- Example 29110
import com.snowflake.snowpark._

-- Example 29111
import com.snowflake.snowpark.functions._

-- Example 29112
import com.snowflake.snowpark.types._

-- Example 29113
import com.snowflake.snowpark._

...
// Get a SessionBuilder object.
val builder = Session.builder

-- Example 29114
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATE_KEY_FILE = </path/to/private_key_file.p8>
PRIVATE_KEY_FILE_PWD = <if the private key is encrypted, set this to the passphrase for decrypting the key>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 29115
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATEKEY = <unencrypted_private_key_from_the_private_key_file>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 29116
// Create a new session, using the connection properties
// specified in a file.
val session = Session.builder.configFile("/path/to/properties/file").create

-- Example 29117
// Create a new session, using the connection properties
// specified in a Map.
val session = Session.builder.configs(Map(
    "URL" -> "https://<account_identifier>.snowflakecomputing.com",
    "USER" -> "<username>",
    "PRIVATE_KEY_FILE" -> "</path/to/private_key_file.p8>",
    "PRIVATE_KEY_FILE_PWD" -> "<if the private key is encrypted, set this to the passphrase for decrypting the key>",
    "ROLE" -> "<role_name>",
    "WAREHOUSE" -> "<warehouse_name>",
    "DB" -> "<database_name>",
    "SCHEMA" -> "<schema_name>"
)).create

-- Example 29118
// Close the session, cancelling any queries that are currently running, and
// preventing the use of this Session object for performing any subsequent queries.
session.close();

