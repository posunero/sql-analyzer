-- Example 28918
>>> df[0] + df[1]
0    4.14
1    3.59
2    2.50
dtype: float64

-- Example 28919
CREATE OR REPLACE FUNCTION stock_sale_sum(symbol VARCHAR, quantity NUMBER, price NUMBER(10,2))
  RETURNS TABLE (symbol VARCHAR, total NUMBER(10,2))
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'StockSaleSum'
AS $$
class StockSaleSum:
    def __init__(self):
        self._cost_total = 0
        self._symbol = ""

    def process(self, symbol, quantity, price):
      self._symbol = symbol
      cost = quantity * price
      self._cost_total += cost
      yield (symbol, cost)

    def end_partition(self):
      yield (self._symbol, self._cost_total)
$$;

-- Example 28920
SELECT stock_sale_sum.symbol, total
  FROM stocks_table, TABLE(stock_sale_sum(symbol, quantity, price) OVER (PARTITION BY symbol));

-- Example 28921
def __init__(self):

-- Example 28922
def process(self, *args):

-- Example 28923
CREATE OR REPLACE FUNCTION stock_sale(symbol VARCHAR, quantity NUMBER, price NUMBER(10,2))
  RETURNS TABLE (symbol VARCHAR, total NUMBER(10,2))
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'StockSale'
AS $$
class StockSale:
    def process(self, symbol, quantity, price):
      cost = quantity * price
      yield (symbol, cost)
$$;

-- Example 28924
SELECT stock_sale.symbol, total
  FROM stocks_table, TABLE(stock_sale(symbol, quantity, price) OVER (PARTITION BY symbol));

-- Example 28925
def process(self, symbol, quantity, price):
  cost = quantity * price
  yield (symbol, cost)
  yield (symbol, cost)

-- Example 28926
yield (cost,)

-- Example 28927
def process(self, symbol, quantity, price):
  cost = quantity * price
  return [(symbol, cost), (symbol, cost)]

-- Example 28928
def process(self, number):
  if number < 1:
    yield None
  else:
    yield (number)

-- Example 28929
SELECT stock_sale_sum.symbol, total
  FROM stocks_table, TABLE(stock_sale_sum(symbol, quantity, price) OVER (PARTITION BY symbol));

-- Example 28930
def end_partition(self):

-- Example 28931
class StockSaleSum:
  def __init__(self):
    self._cost_total = 0
    self._symbol = ""

  def process(self, symbol, quantity, price):
    self._symbol = symbol
    cost = quantity * price
    self._cost_total += cost
    yield (symbol, cost)

  def end_partition(self):
    yield (self._symbol, self._cost_total)

-- Example 28932
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'python';

-- Example 28933
CREATE OR REPLACE FUNCTION stock_sale_average(symbol VARCHAR, quantity NUMBER, price NUMBER(10,2))
  RETURNS TABLE (symbol VARCHAR, total NUMBER(10,2))
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('numpy')
  HANDLER = 'StockSaleAverage'
AS $$
import numpy as np

class StockSaleAverage:
    def __init__(self):
      self._price_array = []
      self._quantity_total = 0
      self._symbol = ""

    def process(self, symbol, quantity, price):
      self._symbol = symbol
      self._price_array.append(float(price))
      cost = quantity * price
      yield (symbol, cost)

    def end_partition(self):
      np_array = np.array(self._price_array)
      avg = np.average(np_array)
      yield (self._symbol, avg)
$$;

-- Example 28934
SELECT stock_sale_average.symbol, total
  FROM stocks_table,
  TABLE(stock_sale_average(symbol, quantity, price)
    OVER (PARTITION BY symbol));

-- Example 28935
CREATE OR REPLACE FUNCTION joblib_multiprocessing_udtf(i INT)
  RETURNS TABLE (result INT)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'JoblibMultiprocessing'
  PACKAGES = ('joblib')
AS $$
import joblib
from math import sqrt

class JoblibMultiprocessing:
  def process(self, i):
    pass

  def end_partition(self):
    result = joblib.Parallel(n_jobs=-1)(joblib.delayed(sqrt)(i ** 2) for i in range(10))
    for r in result:
      yield (r, )
$$;

-- Example 28936
import joblib
joblib.parallel_backend('loky')

-- Example 28937
CREATE OR REPLACE FUNCTION <name> ( [ <arguments> ] )
  RETURNS TABLE ( <output_column_name> <output_column_type> [, <output_column_name> <output_column_type> ... ] )
  LANGUAGE PYTHON
  [ IMPORTS = ( '<imports>' ) ]
  RUNTIME_VERSION = 3.9
  [ PACKAGES = ( '<package_name>' [, '<package_name>' . . .] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  HANDLER = '<handler_class>'
  [ AS '<python_code>' ]

-- Example 28938
DataFrame df = session.table("sample_product_data");
df.select(Functions.upper(Functions.col("name"))).show();

-- Example 28939
// Call the system-defined function RADIANS() on degrees.
DataFrame dfDegrees = session.range(0, 360, 45).rename("degrees", Functions.col("id"));
dfDegrees.select(Functions.col("degrees"), Functions.callUDF("radians", Functions.col("degrees"))).show();

-- Example 28940
import com.snowflake.snowpark_java.types.*;
...
// Create and register a temporary named UDF
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerTemporary(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType);
// Call the named UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", doubleUdf.apply(Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 28941
CREATE OR REPLACE FUNCTION product_by_category_id(cat_id INT)
  RETURNS TABLE(id INT, name VARCHAR)
  AS
  $$
    SELECT id, name
      FROM sample_product_data
      WHERE category_id = cat_id
  $$
  ;

-- Example 28942
import java.util.HashMap;
import java.util.Map;
...

Map<String, Column> arguments = new HashMap<>();
arguments.put("cat_id", Functions.lit(10));
DataFrame dfTableFunctionOutput = session.tableFunction(new TableFunction("product_by_category_id"), arguments);
dfTableFunctionOutput.show();

-- Example 28943
Session session = Session.builder().configFile("my_config.properties").create();

// Assign the lambda function to a variable.
JavaSProc1<Integer, Integer> func =
  (Session session, Integer num) -> num + 1;

// Execute the function locally.
int result = (Integer)session.sproc().runLocally(func, 1);
System.out.println("\nResult: " + result);

// Register the procedure.
StoredProcedure sp =
  session.sproc().registerTemporary(
    func,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

// Execute the procedure on the server.
session.storedProcedure(sp, 1).show();

-- Example 28944
Session session = Session.builder().configFile("my_config.properties").create();

String incrementProc = "increment";

// Register the procedure.
StoredProcedure tempSP =
  session.sproc().registerTemporary(
    incrementProc,
    (Session session, Integer num) -> num + 1,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

// Execute the procedure on the server by passing the procedure's name.
session.storedProcedure(incrementProc, 1).show();

// Execute the procedure on the server by passing a variable
// representing the procedure.
session.storedProcedure(tempSP, 1).show();

-- Example 28945
import com.snowflake.snowpark_java.*;

-- Example 28946
import com.snowflake.snowpark_java.types.*;

-- Example 28947
import com.snowflake.snowpark_java.*;

...
// Get a SessionBuilder object.
SessionBuilder builder = Session.builder();

-- Example 28948
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATE_KEY_FILE = </path/to/private_key_file.p8>
PRIVATE_KEY_FILE_PWD = <if the private key is encrypted, set this to the passphrase for decrypting the key>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 28949
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATEKEY = <unencrypted_private_key_from_the_private_key_file>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 28950
// Create a new session, using the connection properties
// specified in a file.
Session session = Session.builder().configFile("/path/to/properties/file").create();

-- Example 28951
import com.snowflake.snowpark_java.*;
import java.util.HashMap;
import java.util.Map;
...
// Create a new session, using the connection properties
// specified in a Map.
// Replace the <placeholders> below.
Map<String, String> properties = new HashMap<>();
properties.put("URL", "https://<account_identifier>.snowflakecomputing.com:443");
properties.put("USER", "<user name>");
properties.put("PRIVATE_KEY_FILE", "</path/to/private_key_file.p8>");
properties.put("PRIVATE_KEY_FILE_PWD", "<if the private key is encrypted, set this to the passphrase for decrypting the key>");
properties.put("ROLE", "<role name>");
properties.put("WAREHOUSE", "<warehouse name>");
properties.put("DB", "<database name>");
properties.put("SCHEMA", "<schema name>");
Session session = Session.builder().configs(properties).create();

-- Example 28952
// Close the session, cancelling any queries that are currently running, and
// preventing the use of this Session object for performing any subsequent queries.
session.close();

-- Example 28953
public final class DataTypes
extends Object

-- Example 28954
public static final ByteType ByteType

-- Example 28955
public static final ShortType ShortType

-- Example 28956
public static final IntegerType IntegerType

-- Example 28957
public static final LongType LongType

-- Example 28958
public static final FloatType FloatType

-- Example 28959
public static final DoubleType DoubleType

-- Example 28960
public static final BinaryType BinaryType

-- Example 28961
public static final BooleanType BooleanType

-- Example 28962
public static final DateType DateType

-- Example 28963
public static final GeographyType GeographyType

-- Example 28964
public static final GeometryType GeometryType

-- Example 28965
public static final StringType StringType

-- Example 28966
public static final TimestampType TimestampType

-- Example 28967
public static final TimeType TimeType

-- Example 28968
public static final VariantType VariantType

-- Example 28969
public static DecimalType createDecimalType​(int precision,
                                            int scale)

-- Example 28970
public static ArrayType createArrayType​(DataType elementType)

-- Example 28971
public static MapType createMapType​(DataType keyType,
                                    DataType valueType)

-- Example 28972
public class StructType
extends DataType
implements Iterable<StructField>

-- Example 28973
public StructType​(StructType other)

-- Example 28974
public StructType​(StructField[] fields)

-- Example 28975
public static StructType create​(StructField... fields)

-- Example 28976
public int fieldIndex​(String fieldName)

-- Example 28977
public String[] names()

-- Example 28978
public int size()

-- Example 28979
public Iterator<StructField> iterator()

-- Example 28980
public StructField get​(int index)

-- Example 28981
public String toString()

-- Example 28982
public StructType add​(StructField field)

-- Example 28983
public StructType add​(String name,
                      DataType dataType,
                      boolean nullable)

-- Example 28984
public StructType add​(String name,
                      DataType dataType)

