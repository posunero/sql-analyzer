-- Example 16193
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas
from _snowflake import vectorized

@vectorized(input=pandas.DataFrame, max_batch_size=100)
def add_one_to_inputs(df):
 return df[0] + df[1] + 1
$$;

-- Example 16194
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas

def add_one_to_inputs(df):
 return df[0] + df[1] + 1

add_one_to_inputs._sf_vectorized_input = pandas.DataFrame
add_one_to_inputs._sf_max_batch_size = 100
$$;

-- Example 16195
CREATE OR REPLACE FUNCTION add_inputs(x INT, y FLOAT)
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_inputs'
AS $$
import pandas
from _snowflake import vectorized

@vectorized(input=pandas.DataFrame)
def add_inputs(df):
  return df[0] + df[1]
$$;

-- Example 16196
SELECT add_inputs(x, y)
FROM (
  SELECT 1 AS x, 3.14::FLOAT as y UNION ALL
  SELECT 2, 1.59 UNION ALL
  SELECT 3, -0.5
);

-- Example 16197
+------------------+
| ADD_INPUTS(X, Y) |
|------------------|
|             4.14 |
|             3.59 |
|             2.5  |
+------------------+

-- Example 16198
>>> import pandas
>>> df = pandas.DataFrame({0: pandas.array([1, 2, 3]), 1: pandas.array([3.14, 1.59, -0.5])})
>>> df
   0     1
0  1  3.14
1  2  1.59
2  3 -0.50

-- Example 16199
>>> df[0] + df[1]
0    4.14
1    3.59
2    2.50
dtype: float64

-- Example 16200
from _snowflake import vectorized
import pandas

class handler:
  def __init__(self):
    # initialize a state
  @vectorized(input=pandas.DataFrame)
  def end_partition(self, df):
    # process the DataFrame
    return result_df

-- Example 16201
import pandas

class handler:
  def __init__(self):
    # initialize a state
  def end_partition(self, df):
    # process the DataFrame
    return result_df

handler.end_partition._sf_vectorized_input = pandas.DataFrame

-- Example 16202
SELECT * FROM table(udtf(x,y,z) OVER (PARTITION BY 1));

-- Example 16203
SELECT * FROM table(udtf(x,y,z) OVER (PARTITION BY x));

-- Example 16204
import pandas

class handler:
  def __init__(self):
    self.rows = []
  def process(self, *row):
    self.rows.append(row)
  def end_partition(self):
    df = pandas.DataFrame(self.rows)
    # process the DataFrame
    return result_df

-- Example 16205
from _snowflake import vectorized
import pandas

class handler:
  def __init__(self):
    self.rows = []
  @vectorized(input=pandas.DataFrame)
  def end_partition(self, df):
  # process the DataFrame
    return result_df

-- Example 16206
CREATE OR REPLACE TABLE test_values(id VARCHAR, col1 FLOAT, col2 FLOAT, col3 FLOAT, col4 FLOAT, col5 FLOAT);

-- generate 3 partitions of 5 rows each
INSERT INTO test_values
  SELECT 'x',
  UNIFORM(1.5,1000.5,RANDOM(1))::FLOAT col1,
  UNIFORM(1.5,1000.5,RANDOM(2))::FLOAT col2,
  UNIFORM(1.5,1000.5,RANDOM(3))::FLOAT col3,
  UNIFORM(1.5,1000.5,RANDOM(4))::FLOAT col4,
  UNIFORM(1.5,1000.5,RANDOM(5))::FLOAT col5
  FROM TABLE(GENERATOR(ROWCOUNT => 5));

INSERT INTO test_values
  SELECT 'y',
  UNIFORM(1.5,1000.5,RANDOM(10))::FLOAT col1,
  UNIFORM(1.5,1000.5,RANDOM(20))::FLOAT col2,
  UNIFORM(1.5,1000.5,RANDOM(30))::FLOAT col3,
  UNIFORM(1.5,1000.5,RANDOM(40))::FLOAT col4,
  UNIFORM(1.5,1000.5,RANDOM(50))::FLOAT col5
  FROM TABLE(GENERATOR(ROWCOUNT => 5));

INSERT INTO test_values
  SELECT 'z',
  UNIFORM(1.5,1000.5,RANDOM(100))::FLOAT col1,
  UNIFORM(1.5,1000.5,RANDOM(200))::FLOAT col2,
  UNIFORM(1.5,1000.5,RANDOM(300))::FLOAT col3,
  UNIFORM(1.5,1000.5,RANDOM(400))::FLOAT col4,
  UNIFORM(1.5,1000.5,RANDOM(500))::FLOAT col5
  FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- Example 16207
SELECT * FROM test_values;

-- Example 16208
-----------------------------------------------------
|"ID"  |"COL1"  |"COL2"  |"COL3"  |"COL4"  |"COL5"  |
-----------------------------------------------------
|x     |8.0     |99.4    |714.6   |168.7   |397.2   |
|x     |106.4   |237.1   |971.7   |828.4   |988.2   |
|x     |741.3   |207.9   |32.6    |640.6   |63.2    |
|x     |541.3   |828.6   |844.9   |77.3    |403.1   |
|x     |4.3     |723.3   |924.3   |282.5   |158.1   |
|y     |976.1   |562.4   |968.7   |934.3   |977.3   |
|y     |390.0   |244.3   |952.6   |101.7   |24.9    |
|y     |599.7   |191.8   |90.2    |788.2   |761.2   |
|y     |589.5   |201.0   |863.4   |415.1   |696.1   |
|y     |46.7    |659.7   |571.1   |938.0   |513.7   |
|z     |313.9   |188.5   |964.6   |435.4   |519.6   |
|z     |328.3   |643.1   |766.4   |148.1   |596.4   |
|z     |929.0   |255.4   |915.9   |857.2   |425.5   |
|z     |612.8   |816.4   |220.2   |879.5   |331.4   |
|z     |487.1   |704.5   |471.5   |378.9   |481.2   |
-----------------------------------------------------

-- Example 16209
CREATE OR REPLACE FUNCTION summary_stats(id VARCHAR, col1 FLOAT, col2 FLOAT, col3 FLOAT, col4 FLOAT, col5 FLOAT)
  RETURNS TABLE (column_name VARCHAR, count INT, mean FLOAT, std FLOAT, min FLOAT, q1 FLOAT, median FLOAT, q3 FLOAT, max FLOAT)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'handler'
AS $$
from _snowflake import vectorized
import pandas

class handler:
    @vectorized(input=pandas.DataFrame)
    def end_partition(self, df):
      # using describe function to get the summary statistics
      result = df.describe().transpose()
      # add a column at the beginning for column ids
      result.insert(loc=0, column='column_name', value=['col1', 'col2', 'col3', 'col4', 'col5'])
      return result
$$;

-- Example 16210
-- partition by id
SELECT * FROM test_values, TABLE(summary_stats(id, col1, col2, col3, col4, col5)
  OVER (PARTITION BY id))
  ORDER BY id, column_name;

-- Example 16211
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"ID"  |"COL1"  |"COL2"  |"COL3"  |"COL4"  |"COL5"  |"COLUMN_NAME"  |"COUNT"  |"MEAN"              |"STD"               |"MIN"  |"Q1"   |"MEDIAN"  |"Q3"   |"MAX"  |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
|x     |NULL    |NULL    |NULL    |NULL    |NULL    |col1           |5        |280.25999999999993  |339.5609267863427   |4.3    |8.0    |106.4     |541.3  |741.3  |
|x     |NULL    |NULL    |NULL    |NULL    |NULL    |col2           |5        |419.25999999999993  |331.72476995244114  |99.4   |207.9  |237.1     |723.3  |828.6  |
|x     |NULL    |NULL    |NULL    |NULL    |NULL    |col3           |5        |697.62              |384.2964311569911   |32.6   |714.6  |844.9     |924.3  |971.7  |
|x     |NULL    |NULL    |NULL    |NULL    |NULL    |col4           |5        |399.5               |321.2689294033894   |77.3   |168.7  |282.5     |640.6  |828.4  |
|x     |NULL    |NULL    |NULL    |NULL    |NULL    |col5           |5        |401.96000000000004  |359.83584173897964  |63.2   |158.1  |397.2     |403.1  |988.2  |
|y     |NULL    |NULL    |NULL    |NULL    |NULL    |col1           |5        |520.4               |339.16133329139984  |46.7   |390.0  |589.5     |599.7  |976.1  |
|y     |NULL    |NULL    |NULL    |NULL    |NULL    |col2           |5        |371.84              |221.94799616126298  |191.8  |201.0  |244.3     |562.4  |659.7  |
|y     |NULL    |NULL    |NULL    |NULL    |NULL    |col3           |5        |689.2               |371.01012789410476  |90.2   |571.1  |863.4     |952.6  |968.7  |
|y     |NULL    |NULL    |NULL    |NULL    |NULL    |col4           |5        |635.46              |366.6140927460372   |101.7  |415.1  |788.2     |934.3  |938.0  |
|y     |NULL    |NULL    |NULL    |NULL    |NULL    |col5           |5        |594.64              |359.0334218425911   |24.9   |513.7  |696.1     |761.2  |977.3  |
|z     |NULL    |NULL    |NULL    |NULL    |NULL    |col1           |5        |534.22              |252.58182238633088  |313.9  |328.3  |487.1     |612.8  |929.0  |
|z     |NULL    |NULL    |NULL    |NULL    |NULL    |col2           |5        |521.58              |281.4870103574941   |188.5  |255.4  |643.1     |704.5  |816.4  |
|z     |NULL    |NULL    |NULL    |NULL    |NULL    |col3           |5        |667.72              |315.53336907528495  |220.2  |471.5  |766.4     |915.9  |964.6  |
|z     |NULL    |NULL    |NULL    |NULL    |NULL    |col4           |5        |539.8199999999999   |318.73025742781306  |148.1  |378.9  |435.4     |857.2  |879.5  |
|z     |NULL    |NULL    |NULL    |NULL    |NULL    |col5           |5        |470.82              |99.68626786072393   |331.4  |425.5  |481.2     |519.6  |596.4  |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 16212
-- treat the whole table as one partition
SELECT * FROM test_values, TABLE(summary_stats(id, col1, col2, col3, col4, col5)
  OVER (PARTITION BY 1))
  ORDER BY id, column_name;

-- Example 16213
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"ID"  |"COL1"  |"COL2"  |"COL3"  |"COL4"  |"COL5"  |"COLUMN_NAME"  |"COUNT"  |"MEAN"             |"STD"               |"MIN"  |"Q1"                |"MEDIAN"  |"Q3"    |"MAX"  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|NULL  |NULL    |NULL    |NULL    |NULL    |NULL    |col1           |15       |444.96             |314.01110034974425  |4.3    |210.14999999999998  |487.1     |606.25  |976.1  |
|NULL  |NULL    |NULL    |NULL    |NULL    |NULL    |col2           |15       |437.56             |268.95505944302295  |99.4   |204.45              |255.4     |682.1   |828.6  |
|NULL  |NULL    |NULL    |NULL    |NULL    |NULL    |col3           |15       |684.8466666666667  |331.87254839915937  |32.6   |521.3               |844.9     |938.45  |971.7  |
|NULL  |NULL    |NULL    |NULL    |NULL    |NULL    |col4           |15       |524.9266666666666  |327.074780585783    |77.3   |225.6               |435.4     |842.8   |938.0  |
|NULL  |NULL    |NULL    |NULL    |NULL    |NULL    |col5           |15       |489.14             |288.9176669671038   |24.9   |364.29999999999995  |481.2     |646.25  |988.2  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 16214
import pandas as pd
from snowflake.snowpark import Session
from snowflake.snowpark.types import PandasDataFrame

class one_hot_encode:
  def process(self, df: PandasDataFrame[str]) -> PandasDataFrame[int,int,int,int,int,int,int,int,int,int]:
      return pd.get_dummies(df)
  process._sf_vectorized_input = pd.DataFrame


one_hot_encode_udtf = session.udtf.register(
  one_hot_encode,
  output_schema=["categ0", "categ1", "categ2", "categ3", "categ4", "categ5", "categ6", "categ7", "categ8", "categ9"],
  input_names=['"categ"']
)

df_table = session.table("categories")
df_table.show()

-- Example 16215
-----------
|"CATEG"  |
-----------
|categ1   |
|categ6   |
|categ8   |
|categ5   |
|categ7   |
|categ5   |
|categ1   |
|categ2   |
|categ2   |
|categ4   |
-----------

-- Example 16216
res = df_table.select("categ", one_hot_encode_udtf("categ")).to_pandas()
print(res.head())

-- Example 16217
CATEG  CATEG0  CATEG1  CATEG2  CATEG3  CATEG4  CATEG5  CATEG6  CATEG7  CATEG8  CATEG9
0  categ0       1       0       0       0       0       0       0       0       0       0
1  categ0       1       0       0       0       0       0       0       0       0       0
2  categ5       0       0       0       0       0       1       0       0       0       0
3  categ3       0       0       0       1       0       0       0       0       0       0
4  categ8       0       0       0       0       0       0       0       0       1       0

-- Example 16218
def one_hot_encode(df: PandasSeries[str]) -> PandasSeries[Variant]:
  return pd.get_dummies(df).to_dict('records')

one_hot_encode._sf_vectorized_input = pd.DataFrame

one_hot_encode_udf = session.udf.register(
  one_hot_encode,
  output_schema=["encoding"],
)

df_table = session.table("categories")
df_table.show()
res = df_table.select(one_hot_encode_udf("categ")).to_df("encoding").to_pandas()
print(res.head())
0  {\n  "categ0": false,\n  "categ1": false,\n  "...
1  {\n  "categ0": false,\n  "categ1": true,\n  "c...
2  {\n  "categ0": false,\n  "categ1": false,\n  "...
3  {\n  "categ0": false,\n  "categ1": false,\n  "...
4  {\n  "categ0": true,\n  "categ1": false,\n  "c...

-- Example 16219
return tuple(map(lambda n: (scalar_value, n[0], n[1]), results))

-- Example 16220
return tuple([scalar_value] * len(results), results[:, 0], results[:, 1])

-- Example 16221
CREATE FUNCTION vec_udtf(variant OBJ)

-- Example 16222
CREATE FUNCTION vec_udtf(a INTEGER, b FLOAT, c STRING)

-- Example 16223
input_df['y'] =  input_df['y'].astype("int64")

-- Example 16224
results = []
while(...):
  partial_result = pd.DataFrame(...)
  results.append(partial_result)
return pd.concat(results)

-- Example 16225
while(...):
  partial_result = pd.DataFrame(...)
  yield partial_result

-- Example 16226
CREATE OR REPLACE FUNCTION <name> ( [ <arguments> ] )
  RETURNS TABLE ( <output_col_name> <output_col_type> [, <output_col_name> <output_col_type> ... ] )
  AS '<sql_expression>'

-- Example 16227
SELECT ...
  FROM TABLE ( udtf_name (udtf_arguments) )

-- Example 16228
CREATE FUNCTION t()
    RETURNS TABLE(msg VARCHAR)
    AS
    $$
        SELECT 'Hello'
        UNION
        SELECT 'World'
    $$;

-- Example 16229
SELECT msg 
    FROM TABLE(t())
    ORDER BY msg;
+-------+
| MSG   |
|-------|
| Hello |
| World |
+-------+

-- Example 16230
CREATE FUNCTION t()
    RETURNS TABLE(msg VARCHAR)
    AS
    '
        SELECT \'Hello\'
        UNION
        SELECT \'World\'
    ';

-- Example 16231
SELECT msg
    FROM TABLE(t())
    ORDER BY msg;
+-------+
| MSG   |
|-------|
| Hello |
| World |
+-------+

-- Example 16232
create or replace table orders (
    product_id varchar, 
    quantity_sold numeric(11, 2)
    );

insert into orders (product_id, quantity_sold) values 
    ('compostable bags', 2000),
    ('re-usable cups',  1000);

-- Example 16233
create or replace function orders_for_product(PROD_ID varchar)
    returns table (Product_ID varchar, Quantity_Sold numeric(11, 2))
    as
    $$
        select product_ID, quantity_sold 
            from orders 
            where product_ID = PROD_ID
    $$
    ;

-- Example 16234
select product_id, quantity_sold
    from table(orders_for_product('compostable bags'))
    order by product_id;
+------------------+---------------+
| PRODUCT_ID       | QUANTITY_SOLD |
|------------------+---------------|
| compostable bags |       2000.00 |
+------------------+---------------+

-- Example 16235
create or replace table countries (country_code char(2), country_name varchar);
insert into countries (country_code, country_name) values 
    ('FR', 'FRANCE'),
    ('US', 'UNITED STATES'),
    ('ES', 'SPAIN');

create or replace table user_addresses (user_ID integer, country_code char(2));
insert into user_addresses (user_id, country_code) values 
    (100, 'ES'),
    (123, 'FR'),
    (123, 'US');

-- Example 16236
CREATE OR REPLACE FUNCTION get_countries_for_user ( id number )
  RETURNS TABLE (country_code char, country_name varchar)
  AS 'select distinct c.country_code, c.country_name
      from user_addresses a, countries c
      where a.user_id = id
      and c.country_code = a.country_code';

-- Example 16237
select *
    from table(get_countries_for_user(123)) cc
    where cc.country_code in ('US','FR','CA')
    order by country_code;
+--------------+---------------+
| COUNTRY_CODE | COUNTRY_NAME  |
|--------------+---------------|
| FR           | FRANCE        |
| US           | UNITED STATES |
+--------------+---------------+

-- Example 16238
create or replace table favorite_years as
    select 2016 year
    UNION ALL
    select 2017
    UNION ALL
    select 2018
    UNION ALL
    select 2019;

 create or replace table colors as
    select 2017 year, 'red' color, true favorite
    UNION ALL
    select 2017 year, 'orange' color, true favorite
    UNION ALL
    select 2017 year, 'green' color, false favorite
    UNION ALL
    select 2018 year, 'blue' color, true favorite
    UNION ALL
    select 2018 year, 'violet' color, true favorite
    UNION ALL
    select 2018 year, 'brown' color, false favorite;

create or replace table fashion as
    select 2017 year, 'red' fashion_color
    UNION ALL
    select 2018 year, 'black' fashion_color
    UNION ALL
    select 2019 year, 'orange' fashion_color;

-- Example 16239
create or replace function favorite_colors(the_year int)
    returns table(color string) as
    'select color from colors where year=the_year and favorite=true';

-- Example 16240
select color
    from table(favorite_colors(2017))
    order by color;
+--------+
| COLOR  |
|--------|
| orange |
| red    |
+--------+

-- Example 16241
select * 
    from favorite_years y join table(favorite_colors(y.year)) c
    order by year, color;
+------+--------+
| YEAR | COLOR  |
|------+--------|
| 2017 | orange |
| 2017 | red    |
| 2018 | blue   |
| 2018 | violet |
+------+--------+

-- Example 16242
select * 
    from fashion f join table(favorite_colors(f.year)) fav
    where fav.color = f.fashion_color ;
+------+---------------+-------+
| YEAR | FASHION_COLOR | COLOR |
|------+---------------+-------|
| 2017 | red           | red   |
+------+---------------+-------+

-- Example 16243
select fav.color as favorite_2017, f.*
    from fashion f JOIN table(favorite_colors(2017)) fav
    where fav.color = f.fashion_color
    order by year;
+---------------+------+---------------+
| FAVORITE_2017 | YEAR | FASHION_COLOR |
|---------------+------+---------------|
| red           | 2017 | red           |
| orange        | 2019 | orange        |
+---------------+------+---------------+

-- Example 16244
import com.snowflake.snowpark_java.types.*;
...

// Create and register an anonymous UDF (doubleUdf)
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  Functions.udf((Integer x) -> x + x, DataTypes.IntegerType, DataTypes.IntegerType);
// Call the anonymous UDF.
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", doubleUdf.apply(Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16245
import com.snowflake.snowpark_java.types.*;
...

// Create and register a permanent named UDF ("doubleUdf")
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerPermanent(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType,
      "mystage");
// Call the named UDF.
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16246
// Add a JAR file that you uploaded to a stage.
session.addDependency("@my_stage/<path>/my-library.jar");

-- Example 16247
// Add a JAR file on your local machine.
session.addDependency("/<path>/my-library.jar");

// Add a directory of resource files.
session.addDependency("/<path>/my-resource-dir/");

// Add a resource file.
session.addDependency("/<path>/my-resource.xml");

-- Example 16248
-- Put the Snowpark JAR file in a stage.
PUT file:///<path>/snowpark-1.15.0.jar @mystage

-- Example 16249
// Add the Snowpark JAR file that you uploaded to a stage.
session.addDependency("@mystage/snowpark-1.15.0.jar.gz");

-- Example 16250
import com.snowflake.snowpark_java.types.*;
...

// Create and register an anonymous UDF
// that takes in an integer argument and returns an integer value.
UserDefinedFunction doubleUdf =
  Functions.udf((Integer x) -> x + x, DataTypes.IntegerType, DataTypes.IntegerType);
// Call the anonymous UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", doubleUdf.apply(Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16251
import com.snowflake.snowpark_java.types.*;

// Import the package for your custom code.
// The custom code in this example detects the language of textual data.
import com.mycompany.LanguageDetector;

// If the custom code is packaged in a JAR file, add that JAR file as
// a dependency.
session.addDependency("$HOME/language-detector.jar");

// Create a detector
LanguageDetector detector = new LanguageDetector();

// Create an anonymous UDF that takes a string of text and returns the language used in that string.
// Note that this captures the detector object created above.
// Assign the UDF to the langUdf variable, which will be used to call the UDF.
UserDefinedFunction langUdf =
  Functions.udf(
    (String s) -> Option(detector.detect(s)).getOrElse("UNKNOWN"),
    DataTypes.StringType,
    DataTypes.StringType);

// Create a new DataFrame that contains an additional "lang" column that contains the language
// detected by the UDF.
DataFrame dfEmailsWithLangCol =
    dfEmails.withColumn("lang", langUdf(Functions.col("text_data")));

-- Example 16252
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
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16253
import com.snowflake.snowpark_java.types.*;
...

// Create and register a permanent named UDF
// that takes in an integer argument and returns an integer value.
// Specify that the UDF and dependent JAR files should be uploaded to
// the internal stage named mystage.
UserDefinedFunction doubleUdf =
  session
    .udf()
    .registerPermanent(
      "doubleUdf",
      (Integer x) -> x + x,
      DataTypes.IntegerType,
      DataTypes.IntegerType,
      "mystage");
// Call the named UDF, passing in the "quantity" column.
// The example uses withColumn to return a DataFrame containing
// the UDF result in a new column named "doubleQuantity".
DataFrame df = session.table("sample_product_data");
DataFrame dfWithDoubleQuantity = df.withColumn("doubleQuantity", Functions.callUDF("doubleUdf", Functions.col("quantity")));
dfWithDoubleQuantity.show();

-- Example 16254
Exception in thread "main" java.io.NotSerializableException: <YourObjectName>

-- Example 16255
import com.snowflake.snowpark_java.*;
import com.snowflake.snowpark_java.types.*;
import java.io.Serializable;

// Context needed for a UDF.
class Context {
  double randomInt = Math.random();
}

// Serializable context needed for the UDF.
class SerContext implements Serializable {
  double randomInt = Math.random();
}

class TestUdf {
  public static void main(String[] args) {
    // Create the session.
    Session session = Session.builder().configFile("/<path>/profile.properties").create();
    session.range(1, 10, 2).show();

    // Create a DataFrame with two columns ("c" and "d").
    DataFrame dummy =
      session.createDataFrame(
        new Row[]{
          Row.create(1, 1),
          Row.create(2, 2),
          Row.create(3, 3)
        },
        StructType.create(
          new StructField("c", DataTypes.IntegerType),
          new StructField("d", DataTypes.IntegerType))
        );
    dummy.show();

    // Initialize the context once per invocation.
    UserDefinedFunction udfRepeatedInit =
      Functions.udf(
        (Integer i) -> new Context().randomInt,
        DataTypes.IntegerType,
        DataTypes.DoubleType
      );
    dummy.select(udfRepeatedInit.apply(dummy.col("c"))).show();

    // Initialize the serializable context only once,
    // regardless of the number of times that the UDF is invoked.
    SerContext sC = new SerContext();
    UserDefinedFunction udfOnceInit =
      Functions.udf(
        (Integer i) -> sC.randomInt,
        DataTypes.IntegerType,
        DataTypes.DoubleType
      );
    dummy.select(udfOnceInit.apply(dummy.col("c"))).show();
    UserDefinedFunction udfOnceInit = udf((i: Int) => sC.randomInt);
  }
}

-- Example 16256
# Create a new JAR file containing data/hello.txt.
$ jar cvf <path>/myJar.jar data/hello.txt

-- Example 16257
// Specify that myJar.jar contains files that your UDF depends on.
session.addDependency("<path>/myJar.jar");

-- Example 16258
// Read data/hello.txt from myJar.jar.
String resourceName = "/data/hello.txt";
InputStream inputStream = Class.forName("com.snowflake.snowpark_java.DataFrame").getResourceAsStream(resourceName);

-- Example 16259
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

// Create a function class that reads a file.
class UDFCode {
  private static String fileContent = null;
  // The code in this block reads the file. To prevent this code from executing each time that the UDF is called,
  // The file content is cached in 'fileContent'.
  public static String readFile() {
    if (fileContent == null) {
      try {
        String resourceName = "/data/hello.txt";
        InputStream inputStream = Class.forName("com.snowflake.snowpark_java.DataFrame")
          .getResourceAsStream(resourceName);
        fileContent = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
      } catch (Exception e) {
        fileContent = "Error while reading file";
      }
    }
    return fileContent;
  }
}

