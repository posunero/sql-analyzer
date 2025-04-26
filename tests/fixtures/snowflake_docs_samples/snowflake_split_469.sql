-- Example 31395
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5,
                    A6 arg6,
                    A7 arg7,
                    A8 arg8,
                    A9 arg9,
                    A10 arg10,
                    A11 arg11,
                    A12 arg12,
                    A13 arg13,
                    A14 arg14,
                    A15 arg15,
                    A16 arg16,
                    A17 arg17,
                    A18 arg18,
                    A19 arg19)

-- Example 31396
public interface JavaUDTF21<A0,​A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​A18,​A19,​A20>
extends JavaUDTF

-- Example 31397
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5,
                    A6 arg6,
                    A7 arg7,
                    A8 arg8,
                    A9 arg9,
                    A10 arg10,
                    A11 arg11,
                    A12 arg12,
                    A13 arg13,
                    A14 arg14,
                    A15 arg15,
                    A16 arg16,
                    A17 arg17,
                    A18 arg18,
                    A19 arg19,
                    A20 arg20)

-- Example 31398
public interface JavaUDTF22<A0,​A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​A18,​A19,​A20,​A21>
extends JavaUDTF

-- Example 31399
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5,
                    A6 arg6,
                    A7 arg7,
                    A8 arg8,
                    A9 arg9,
                    A10 arg10,
                    A11 arg11,
                    A12 arg12,
                    A13 arg13,
                    A14 arg14,
                    A15 arg15,
                    A16 arg16,
                    A17 arg17,
                    A18 arg18,
                    A19 arg19,
                    A20 arg20,
                    A21 arg21)

-- Example 31400
public interface JavaUDTF3<A0,​A1,​A2>
extends JavaUDTF

-- Example 31401
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2)

-- Example 31402
public interface JavaUDTF4<A0,​A1,​A2,​A3>
extends JavaUDTF

-- Example 31403
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3)

-- Example 31404
public interface JavaUDTF5<A0,​A1,​A2,​A3,​A4>
extends JavaUDTF

-- Example 31405
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4)

-- Example 31406
public interface JavaUDTF6<A0,​A1,​A2,​A3,​A4,​A5>
extends JavaUDTF

-- Example 31407
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5)

-- Example 31408
public interface JavaUDTF7<A0,​A1,​A2,​A3,​A4,​A5,​A6>
extends JavaUDTF

-- Example 31409
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5,
                    A6 arg6)

-- Example 31410
public interface JavaUDTF8<A0,​A1,​A2,​A3,​A4,​A5,​A6,​A7>
extends JavaUDTF

-- Example 31411
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5,
                    A6 arg6,
                    A7 arg7)

-- Example 31412
public interface JavaUDTF9<A0,​A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8>
extends JavaUDTF

-- Example 31413
Stream<Row> process​(A0 arg0,
                    A1 arg1,
                    A2 arg2,
                    A3 arg3,
                    A4 arg4,
                    A5 arg5,
                    A6 arg6,
                    A7 arg7,
                    A8 arg8)

-- Example 31414
@Documented
public @interface PublicPreview

-- Example 31415
>>> session = pd.session
>>> table_name = "RESULT"
>>> create_result = session.sql(f"CREATE TEMP TABLE {table_name} (A int, B int, C int)").collect()
>>> insert_result = session.sql(f"INSERT INTO {table_name} VALUES(1, 2, 3)").collect()
>>> session.table(table_name).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |3    |
-------------------

-- Example 31416
>>> import modin.pandas as pd
>>> import snowflake.snowpark.modin.plugin
>>> pd.read_snowflake(table_name)   
   A  B  C
0  1  2  3

-- Example 31417
>>> pd.read_snowflake(table_name, index_col="A")   
   B  C
A
1  2  3

-- Example 31418
>>> pd.read_snowflake(table_name, index_col=["A", "B"])   
     C
A B
1 2  3

-- Example 31419
>>> pd.read_snowflake(table_name, index_col=["A", "A", "B"])  
       C
A A B
1 1 2  3

-- Example 31420
>>> pd.read_snowflake(table_name, columns=["A"])  
   A
0  1

-- Example 31421
>>> pd.read_snowflake(table_name, columns=["A", "B"])  
   A  B
0  1  2

-- Example 31422
>>> pd.read_snowflake(table_name, columns=["A", "A", "B"])  
   A  A  B
0  1  1  2

-- Example 31423
>>> pd.read_snowflake(table_name, index_col=["A"], columns=["B", "C"])  
   B  C
A
1  2  3

-- Example 31424
>>> pd.read_snowflake(table_name, index_col=["A", "B"], columns=["A", "B"])  
     A  B
A B
1 2  1  2

-- Example 31425
>>> session = pd.session
>>> table_name = "RESULT"
>>> create_result = session.sql(f"CREATE OR REPLACE TEMP TABLE {table_name} (A int, B int, C int)").collect()
>>> insert_result = session.sql(f"INSERT INTO {table_name} VALUES(1, 2, 3),(-1, -2, -3)").collect()
>>> session.table(table_name).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |3    |
|-1   |-2   |-3   |
-------------------

-- Example 31426
>>> import modin.pandas as pd
>>> import snowflake.snowpark.modin.plugin
>>> pd.read_snowflake(f"SELECT * FROM {table_name}")   
   A  B  C
0  1  2  3
1 -1 -2 -3

-- Example 31427
>>> pd.read_snowflake(f"SELECT * FROM {table_name}", index_col="A")   
    B  C
A
 1  2  3
-1 -2 -3

-- Example 31428
>>> pd.read_snowflake(f"SELECT * FROM {table_name}", index_col=["A", "B"])   
       C
A  B
 1  2  3
-1 -2 -3

-- Example 31429
>>> pd.read_snowflake(f"SELECT * FROM {table_name}", index_col=["A", "A", "B"])  
          C
A  A  B
 1  1  2  3
-1 -1 -2 -3

-- Example 31430
>>> pd.read_snowflake(f"SELECT * FROM {table_name} WHERE A > 0")  
   A  B  C
0  1  2  3

-- Example 31431
>>> pd.read_snowflake(f"-- SQL Comment 1\nSELECT * FROM {table_name} WHERE A > 0")
   A  B  C
0  1  2  3

-- Example 31432
>>> pd.read_snowflake(f'''-- SQL Comment 1
... -- SQL Comment 2
... SELECT * FROM {table_name}
... -- SQL Comment 3
... WHERE A > 0''')
   A  B  C
0  1  2  3

-- Example 31433
>>> # Compute all Fibonacci numbers less than 100.
... pd.read_snowflake(f'''WITH RECURSIVE current_f (current_val, previous_val) AS
... (
...   SELECT 0, 1
...   UNION ALL
...   SELECT current_val + previous_val, current_val FROM current_f
...   WHERE current_val + previous_val < 100
... )
... SELECT current_val FROM current_f''').sort_values("CURRENT_VAL").reset_index(drop=True)
    CURRENT_VAL
0             0
1             1
2             1
3             2
4             3
5             5
6             8
7            13
8            21
9            34
10           55
11           89

-- Example 31434
>>> pd.read_snowflake(f'''WITH T1 AS (SELECT SQUARE(A) AS A2, SQUARE(B) AS B2, SQUARE(C) AS C2 FROM {table_name}),
... T2 AS (SELECT SQUARE(A2) AS A4, SQUARE(B2) AS B4, SQUARE(C2) AS C4 FROM T1),
... T3 AS (SELECT * FROM T1 UNION ALL SELECT * FROM T2)
... SELECT * FROM T3''')  
    A2    B2    C2
0  1.0   4.0   9.0
1  1.0   4.0   9.0
2  1.0  16.0  81.0
3  1.0  16.0  81.0

-- Example 31435
>>> pd.read_snowflake('''WITH filter_rows AS PROCEDURE (table_name VARCHAR, column_to_filter VARCHAR, value NUMBER)
... RETURNS TABLE(A NUMBER, B NUMBER, C NUMBER)
... LANGUAGE PYTHON
... RUNTIME_VERSION = '3.8'
... PACKAGES = ('snowflake-snowpark-python')
... HANDLER = 'filter_rows'
... AS $$from snowflake.snowpark.functions import col
... def filter_rows(session, table_name, column_to_filter, value):
...   df = session.table(table_name)
...   return df.filter(col(column_to_filter) == value)$$
... ''' + f"CALL filter_rows('{table_name}', 'A', 1)", enforce_ordering=True)
   A  B  C
0  1  2  3

-- Example 31436
>>> pd.read_snowflake('''
... WITH filter_rows AS PROCEDURE (table_name VARCHAR, column_to_filter VARCHAR, value NUMBER)
... Returns TABLE(A NUMBER, B NUMBER, C NUMBER)
... LANGUAGE SCALA
... RUNTIME_VERSION = '2.12'
... PACKAGES = ('com.snowflake:snowpark:latest')
... HANDLER = 'Filter.filterRows'
... AS $$
... import com.snowflake.snowpark.functions._
... import com.snowflake.snowpark._
...
... object Filter {
...   def filterRows(session: Session, tableName: String, column_to_filter: String, value: Int): DataFrame = {
...       val table = session.table(tableName)
...       val filteredRows = table.filter(col(column_to_filter) === value)
...       return filteredRows
...   }
... }
... $$
... ''' + f"CALL filter_rows('{table_name}', 'A', -1)", enforce_ordering=True)
   A  B  C
0 -1 -2 -3

-- Example 31437
>>> from snowflake.snowpark.functions import sproc
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType, StringType
>>> from snowflake.snowpark.functions import col
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> session.add_packages('snowflake-snowpark-python')
>>> @sproc(return_type=StructType([StructField("A", IntegerType()), StructField("B", IntegerType()), StructField("C", IntegerType()), StructField("D", IntegerType())]), input_types=[StringType(), StringType(), IntegerType()], is_permanent=True, name="multiply_col_by_value", stage_location="mystage")
... def select_sp(session_, tableName, col_to_multiply, value):
...     df = session_.table(table_name)
...     return df.select('*', (col(col_to_multiply)*value).as_("D"))

-- Example 31438
>>> pd.read_snowflake(f"CALL multiply_col_by_value('{table_name}', 'A', 2)", enforce_ordering=True)
   A  B  C  D
0  1  2  3  2
1 -1 -2 -3 -2

-- Example 31439
>>> session.sql("DROP PROCEDURE multiply_col_by_value(VARCHAR, VARCHAR, NUMBER)").collect()
[Row(status='MULTIPLY_COL_BY_VALUE successfully dropped.')]

-- Example 31440
>>> df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
...                               'Parrot', 'Parrot'],
...                    'Max Speed': [380., 370., 24., 26.]})
>>> pd.to_pandas(df)
   Animal  Max Speed
0  Falcon      380.0
1  Falcon      370.0
2  Parrot       24.0
3  Parrot       26.0

-- Example 31441
>>> pd.to_pandas(df['Animal'])
0    Falcon
1    Falcon
2    Parrot
3    Parrot
Name: Animal, dtype: object

-- Example 31442
>>> df = pd.DataFrame([[2, 0], [3, 7], [4, 9]], columns=['A', 'B'])
>>> df
   A  B
0  2  0
1  3  7
2  4  9

-- Example 31443
>>> df.apply(np.sum, axis=1)
0     2
1    10
2    13
dtype: int64

-- Example 31444
>>> df.apply(lambda x: [1, 2], axis=1)
0    [1, 2]
1    [1, 2]
2    [1, 2]
dtype: object

-- Example 31445
>>> import scipy.stats
>>> pd.session.custom_package_usage_config['enabled'] = True
>>> pd.session.add_packages(['numpy', scipy])
>>> df.apply(lambda x: np.dot(x * scipy.stats.norm.cdf(0), x * scipy.stats.norm.cdf(0)), axis=1)
0     1.00
1    14.50
2    24.25
dtype: float64

-- Example 31446
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
df = pd.DataFrame([1, 2, 3])

-- Example 31447
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>").create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>").create()
pd.session = pandas_session
df = pd.DataFrame([1, 2, 3])

-- Example 31448
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

df = pd.DataFrame([1, 2, 3])

-- Example 31449
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>"}).create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>"}).create()
df = pd.DataFrame([1, 2, 3])

-- Example 31450
import modin.pandas as pd
import numpy as np
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
df = pd.concat([pd.DataFrame([range(i, i+5)]) for i in range(0, 150, 5)])
print(df)
df = df.reset_index(drop=True)
print(df)

-- Example 31451
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

-- Example 31452
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

# Session.builder.create() will create a default Snowflake connection.
Session.builder.create()
df = pd.DataFrame([1, 2, 3])

-- Example 31453
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>").create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>").create()
pd.session = pandas_session
df = pd.DataFrame([1, 2, 3])

-- Example 31454
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

df = pd.DataFrame([1, 2, 3])

-- Example 31455
import modin.pandas as pd
import snowflake.snowpark.modin.plugin
from snowflake.snowpark import Session

pandas_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account1>"}).create()
other_session = Session.builder.configs({"user": "<user>", "password": "<password>", "account": "<account2>"}).create()
df = pd.DataFrame([1, 2, 3])

-- Example 31456
>>> import csv
>>> import tempfile
>>> temp_dir = tempfile.TemporaryDirectory()
>>> temp_dir_name = temp_dir.name
>>> with open(f'{temp_dir_name}/data.csv', 'w') as f:
...     writer = csv.writer(f)
...     writer.writerows([['c1','c2','c3'], [1,2,3], [4,5,6], [7,8,9]])
>>> import modin.pandas as pd
>>> import snowflake.snowpark.modin.plugin
>>> df = pd.read_csv(f'{temp_dir_name}/data.csv')
>>> df
   c1  c2  c3
0   1   2   3
1   4   5   6
2   7   8   9

-- Example 31457
>>> _ = session.sql("create or replace temp stage mytempstage").collect()
>>> _ = session.file.put(f'{temp_dir_name}/data.csv', '@mytempstage/myprefix')
>>> df2 = pd.read_csv('@mytempstage/myprefix/data.csv')
>>> df2
   c1  c2  c3
0   1   2   3
1   4   5   6
2   7   8   9

-- Example 31458
>>> with open(f'{temp_dir_name}/data2.csv', 'w') as f:
...     writer = csv.writer(f)
...     writer.writerows([['c1','c2','c3'], [1,2,3], [4,5,6], [7,8,9]])
>>> df3 = pd.read_csv(f'{temp_dir_name}/data2.csv')
>>> df3
   c1  c2  c3
0   1   2   3
1   4   5   6
2   7   8   9

-- Example 31459
>>> _ = session.file.put(f'{temp_dir_name}/data2.csv', '@mytempstage/myprefix')
>>> df4 = pd.read_csv('@mytempstage/myprefix')
>>> df4
   c1  c2  c3
0   1   2   3
1   4   5   6
2   7   8   9
3   1   2   3
4   4   5   6
5   7   8   9

-- Example 31460
>>> temp_dir.cleanup()

-- Example 31461
>>> pd.read_excel('tmp.xlsx', index_col=0)  
       Name  Value
0   string1      1
1   string2      2
2  #Comment      3

