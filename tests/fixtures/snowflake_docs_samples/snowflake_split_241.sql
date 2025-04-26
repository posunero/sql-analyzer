-- Example 16127
CREATE FUNCTION f(argument_1 INTEGER, argument_2 VARCHAR) ...

-- Example 16128
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER (PARTITION BY <expression>)) ...;

-- Example 16129
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER (PARTITION BY <expression> ORDER BY <expression>)) ...;

-- Example 16130
SELECT ...
  FROM TABLE ( udtf_name (udtf_arguments) )

-- Example 16131
SELECT * FROM TABLE(js_udtf(10.0::FLOAT, 20.0::FLOAT));
+----+----+
|  Y |  X |
|----+----|
| 20 | 10 |
+----+----+

-- Example 16132
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2)) ;

-- Example 16133
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER (PARTITION BY tab1.c3 ORDER BY tab1.c1));

-- Example 16134
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER ());

-- Example 16135
CREATE OR REPLACE FUNCTION HelloWorld0()
    RETURNS TABLE (OUTPUT_COL VARCHAR)
    LANGUAGE JAVASCRIPT
    AS '{
        processRow: function f(row, rowWriter, context){
           rowWriter.writeRow({OUTPUT_COL: "Hello"});
           rowWriter.writeRow({OUTPUT_COL: "World"});
           }
        }';

SELECT output_col FROM TABLE(HelloWorld0());

-- Example 16136
+------------+
| OUTPUT_COL |
+============+
| Hello      |
+------------+
| World      |
+------------+

-- Example 16137
CREATE OR REPLACE FUNCTION HelloHuman(First_Name VARCHAR, Last_Name VARCHAR)
    RETURNS TABLE (V VARCHAR)
    LANGUAGE JAVASCRIPT
    AS '{
        processRow: function get_params(row, rowWriter, context){
           rowWriter.writeRow({V: "Hello"});
           rowWriter.writeRow({V: row.FIRST_NAME});  // Note the capitalization and the use of "row."!
           rowWriter.writeRow({V: row.LAST_NAME});   // Note the capitalization and the use of "row."!
           }
        }';

SELECT V AS Greeting FROM TABLE(HelloHuman('James', 'Kirk'));

-- Example 16138
+------------+
|  GREETING  |
+============+
| Hello      |
+------------+
| James      |
+------------+
| Kirk       |
+------------+

-- Example 16139
-- set up for the sample
CREATE TABLE parts (p FLOAT, s STRING);

INSERT INTO parts VALUES (1, 'michael'), (1, 'kelly'), (1, 'brian');
INSERT INTO parts VALUES (2, 'clara'), (2, 'maggie'), (2, 'reagan');

-- creation of the UDTF
CREATE OR REPLACE FUNCTION "CHAR_SUM"(INS STRING)
    RETURNS TABLE (NUM FLOAT)
    LANGUAGE JAVASCRIPT
    AS '{
    processRow: function (row, rowWriter, context) {
      this.ccount = this.ccount + 1;
      this.csum = this.csum + row.INS.length;
      rowWriter.writeRow({NUM: row.INS.length});
    },
    finalize: function (rowWriter, context) {
     rowWriter.writeRow({NUM: this.csum});
    },
    initialize: function(argumentInfo, context) {
     this.ccount = 0;
     this.csum = 0;
    }}';

-- Example 16140
SELECT * FROM parts, TABLE(char_sum(s));

-- Example 16141
+--------+---------+-----+
| P      | S       | NUM |
+--------+---------+-----+
| 1      | michael | 7   |
| 1      | kelly   | 5   |
| 1      | brian   | 5   |
| 2      | clara   | 5   |
| 2      | maggie  | 6   |
| 2      | reagan  | 6   |
| [NULL] | [NULL]  | 34  |
+--------+---------+-----+

-- Example 16142
SELECT * FROM parts, TABLE(char_sum(s) OVER (PARTITION BY p));

-- Example 16143
+--------+---------+-----+
| P      | S       | NUM |
+--------+---------+-----+
| 1      | michael | 7   |
| 1      | kelly   | 5   |
| 1      | brian   | 5   |
| 1      | [NULL]  | 17  |
| 2      | clara   | 5   |
| 2      | maggie  | 6   |
| 2      | reagan  | 6   |
| 2      | [NULL]  | 17  |
+--------+---------+-----+

-- Example 16144
CREATE OR REPLACE FUNCTION range_to_values(PREFIX VARCHAR, RANGE_START FLOAT, RANGE_END FLOAT)
    RETURNS TABLE (IP_ADDRESS VARCHAR)
    LANGUAGE JAVASCRIPT
    AS $$
      {
        processRow: function f(row, rowWriter, context)  {
          var suffix = row.RANGE_START;
          while (suffix <= row.RANGE_END)  {
            rowWriter.writeRow( {IP_ADDRESS: row.PREFIX + "." + suffix} );
            suffix = suffix + 1;
            }
          }
      }
      $$;

SELECT * FROM TABLE(range_to_values('192.168.1', 42::FLOAT, 45::FLOAT));

-- Example 16145
+--------------+
| IP_ADDRESS   |
+==============+
| 192.168.1.42 |
+--------------+
| 192.168.1.43 |
+--------------+
| 192.168.1.44 |
+--------------+
| 192.168.1.45 |
+--------------+

-- Example 16146
CREATE TABLE ip_address_ranges(prefix VARCHAR, range_start INTEGER, range_end INTEGER);
INSERT INTO ip_address_ranges (prefix, range_start, range_end) VALUES
    ('192.168.1', 42, 44),
    ('192.168.2', 10, 12),
    ('192.168.2', 40, 40)
    ;

SELECT rtv.ip_address
  FROM ip_address_ranges AS r, TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv;

-- Example 16147
+--------------+
| IP_ADDRESS   |
+==============+
| 192.168.1.42 |
+--------------+
| 192.168.1.43 |
+--------------+
| 192.168.1.44 |
+--------------+
| 192.168.2.10 |
+--------------+
| 192.168.2.11 |
+--------------+
| 192.168.2.12 |
+--------------+
| 192.168.2.40 |
+--------------+

-- Example 16148
for input_row in ip_address_ranges:
  output_row = range_to_values(input_row.prefix, input_row.range_start, input_row.range_end)

-- Example 16149
-- Example UDTF that "converts" an IPV4 address to a range of IPV6 addresses.
-- (for illustration purposes only and is not intended for actual use)
CREATE OR REPLACE FUNCTION fake_ipv4_to_ipv6(ipv4 VARCHAR)
    RETURNS TABLE (IPV6 VARCHAR)
    LANGUAGE JAVASCRIPT
    AS $$
      {
        processRow: function f(row, rowWriter, context)  {
          rowWriter.writeRow( {IPV6: row.IPV4 + "." + "000.000.000.000"} );
          rowWriter.writeRow( {IPV6: row.IPV4 + "." + "..."} );
          rowWriter.writeRow( {IPV6: row.IPV4 + "." + "FFF.FFF.FFF.FFF"} );
          }
      }
      $$;

SELECT ipv6 FROM TABLE(fake_ipv4_to_ipv6('192.168.3.100'));

-- Example 16150
+-------------------------------+
| IPV6                          |
+===============================+
| 192.168.3.100.000.000.000.000 |
+-------------------------------+
| 192.168.3.100....             |
+-------------------------------+
| 192.168.3.100.FFF.FFF.FFF.FFF |
+-------------------------------+

-- Example 16151
SELECT rtv6.ipv6
  FROM ip_address_ranges AS r,
       TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv,
       TABLE(fake_ipv4_to_ipv6(rtv.ip_address)) AS rtv6
  WHERE r.prefix = '192.168.2'  -- limits the output for this example
  ;

-- Example 16152
+------------------------------+
| IPV6                         |
+==============================+
| 192.168.2.10.000.000.000.000 |
+------------------------------+
| 192.168.2.10....             |
+------------------------------+
| 192.168.2.10.FFF.FFF.FFF.FFF |
+------------------------------+
| 192.168.2.11.000.000.000.000 |
+------------------------------+
| 192.168.2.11....             |
+------------------------------+
| 192.168.2.11.FFF.FFF.FFF.FFF |
+------------------------------+
| 192.168.2.12.000.000.000.000 |
+------------------------------+
| 192.168.2.12....             |
+------------------------------+
| 192.168.2.12.FFF.FFF.FFF.FFF |
+------------------------------+
| 192.168.2.40.000.000.000.000 |
+------------------------------+
| 192.168.2.40....             |
+------------------------------+
| 192.168.2.40.FFF.FFF.FFF.FFF |
+------------------------------+

-- Example 16153
SELECT rtv6.ipv6
  FROM ip_address_ranges AS r,
       TABLE(fake_ipv4_to_ipv6(rtv.ip_address)) AS rtv6,
       TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv
 WHERE r.prefix = '192.168.2'  -- limits the output for this example
  ;

-- Example 16154
-- First, create a small table of IP address owners.
-- This table uses only IPv4 addresses for simplicity.
DROP TABLE ip_address_owners;
CREATE TABLE ip_address_owners (ip_address VARCHAR, owner_name VARCHAR);
INSERT INTO ip_address_owners (ip_address, owner_name) VALUES
  ('192.168.2.10', 'Barbara Hart'),
  ('192.168.2.11', 'David Saugus'),
  ('192.168.2.12', 'Diego King'),
  ('192.168.2.40', 'Victoria Valencia')
  ;

-- Now join the IP address owner table to the IPv4 addresses.
SELECT rtv.ip_address, ipo.owner_name
  FROM ip_address_ranges AS r,
       TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv,
       ip_address_owners AS ipo
 WHERE ipo.ip_address = rtv.ip_address AND
      r.prefix = '192.168.2'   -- limits the output for this example
  ;

-- Example 16155
+--------------+-------------------+
| IP_ADDRESS   | OWNER_NAME        |
+==============+===================+
| 192.168.2.10 | Barbara Hart      |
+--------------+-------------------+
| 192.168.2.11 | David Saugus      |
+--------------+-------------------+
| 192.168.2.12 | Diego King        |
+--------------+-------------------+
| 192.168.2.40 | Victoria Valencia |
+--------------+-------------------+

-- Example 16156
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

-- Example 16157
CREATE OR REPLACE TABLE sales(item STRING, price INT);

INSERT INTO sales VALUES ('car', 10000), ('motorcycle', 5000), ('car', 7500), ('motorcycle', 3500), ('motorcycle', 1500), ('car', 20000);

SELECT * FROM sales;

-- Example 16158
SELECT python_sum(price) FROM sales;

-- Example 16159
SELECT sum(col) FROM sales;

-- Example 16160
SELECT item, python_sum(price) FROM sales GROUP BY item;

-- Example 16161
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

-- Example 16162
CREATE OR REPLACE TABLE sales(item STRING, price INT);
INSERT INTO sales VALUES ('car', 10000), ('motorcycle', 5000), ('car', 7500), ('motorcycle', 3500), ('motorcycle', 1500), ('car', 20000);

-- Example 16163
SELECT python_avg(price) FROM sales;

-- Example 16164
SELECT avg(price) FROM sales;

-- Example 16165
SELECT item, python_avg(price) FROM sales GROUP BY item;

-- Example 16166
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

-- Example 16167
CREATE OR REPLACE TABLE array_table(x array) AS
SELECT ARRAY_CONSTRUCT(0, 1, 2, 3, 4, 'foo', 'bar', 'snowflake') UNION ALL
SELECT ARRAY_CONSTRUCT(1, 3, 5, 7, 9, 'foo', 'barbar', 'snowpark') UNION ALL
SELECT ARRAY_CONSTRUCT(0, 2, 4, 6, 8, 'snow');

SELECT * FROM array_table;

SELECT pythonGetUniqueValues(x) FROM array_table;

-- Example 16168
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

-- Example 16169
CREATE OR REPLACE TABLE string_table(x STRING);
INSERT INTO string_table SELECT 'foo' FROM TABLE(GENERATOR(ROWCOUNT => 1000));
INSERT INTO string_table SELECT 'bar' FROM TABLE(GENERATOR(ROWCOUNT => 2000));
INSERT INTO string_table SELECT 'snowflake' FROM TABLE(GENERATOR(ROWCOUNT => 50));
INSERT INTO string_table SELECT 'snowpark' FROM TABLE(GENERATOR(ROWCOUNT => 123));
INSERT INTO string_table SELECT 'SnOw' FROM TABLE(GENERATOR(ROWCOUNT => 1));
INSERT INTO string_table SELECT 'snow' FROM TABLE(GENERATOR(ROWCOUNT => 4));

SELECT pythonMapCount(x) FROM string_table;

-- Example 16170
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

-- Example 16171
CREATE OR REPLACE TABLE numbers_table(num_column INT);
INSERT INTO numbers_table SELECT 5 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 1 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 9 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 7 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 10 FROM TABLE(GENERATOR(ROWCOUNT => 10));
INSERT INTO numbers_table SELECT 3 FROM TABLE(GENERATOR(ROWCOUNT => 10));

-- Return top 15 largest values from numbers_table.
SELECT pythonTopK(num_column, 15) FROM numbers_table;

-- Example 16172
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

-- Example 16173
SELECT stock_sale_sum.symbol, total
  FROM stocks_table, TABLE(stock_sale_sum(symbol, quantity, price) OVER (PARTITION BY symbol));

-- Example 16174
def __init__(self):

-- Example 16175
def process(self, *args):

-- Example 16176
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

-- Example 16177
SELECT stock_sale.symbol, total
  FROM stocks_table, TABLE(stock_sale(symbol, quantity, price) OVER (PARTITION BY symbol));

-- Example 16178
def process(self, symbol, quantity, price):
  cost = quantity * price
  yield (symbol, cost)
  yield (symbol, cost)

-- Example 16179
yield (cost,)

-- Example 16180
def process(self, symbol, quantity, price):
  cost = quantity * price
  return [(symbol, cost), (symbol, cost)]

-- Example 16181
def process(self, number):
  if number < 1:
    yield None
  else:
    yield (number)

-- Example 16182
SELECT stock_sale_sum.symbol, total
  FROM stocks_table, TABLE(stock_sale_sum(symbol, quantity, price) OVER (PARTITION BY symbol));

-- Example 16183
def end_partition(self):

-- Example 16184
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

-- Example 16185
SELECT * FROM INFORMATION_SCHEMA.PACKAGES WHERE LANGUAGE = 'python';

-- Example 16186
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

-- Example 16187
SELECT stock_sale_average.symbol, total
  FROM stocks_table,
  TABLE(stock_sale_average(symbol, quantity, price)
    OVER (PARTITION BY symbol));

-- Example 16188
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

-- Example 16189
import joblib
joblib.parallel_backend('loky')

-- Example 16190
CREATE OR REPLACE FUNCTION <name> ( [ <arguments> ] )
  RETURNS TABLE ( <output_column_name> <output_column_type> [, <output_column_name> <output_column_type> ... ] )
  LANGUAGE PYTHON
  [ IMPORTS = ( '<imports>' ) ]
  RUNTIME_VERSION = 3.9
  [ PACKAGES = ( '<package_name>' [, '<package_name>' . . .] ) ]
  [ TARGET_PATH = '<stage_path_and_file_name_to_write>' ]
  HANDLER = '<handler_class>'
  [ AS '<python_code>' ]

-- Example 16191
CREATE FUNCTION add_one_to_inputs(x NUMBER(10, 0), y NUMBER(10, 0))
  RETURNS NUMBER(10, 0)
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('pandas')
  HANDLER = 'add_one_to_inputs'
AS $$
import pandas
from _snowflake import vectorized

@vectorized(input=pandas.DataFrame)
def add_one_to_inputs(df):
 return df[0] + df[1] + 1
$$;

-- Example 16192
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
$$;

