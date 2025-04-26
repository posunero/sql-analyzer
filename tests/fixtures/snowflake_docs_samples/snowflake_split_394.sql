-- Example 26373
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

-- Example 26374
from snowflake.snowpark.context import get_active_session
session = get_active_session()

-- Example 26375
# Create a Snowpark Pandas DataFrame with sample data.
df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                    [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                    [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                    columns=["DAY", "LOCATION", "SNOWFALL"])
# Drop rows with null values.
df.dropna()
# Compute the average daily snowfall across locations.
df.groupby("LOCATION").mean()["SNOWFALL"]

-- Example 26376
from snowflake.snowpark.context import get_active_session
session = get_active_session()

-- Example 26377
from snowflake.core import Root
api_root = Root(session)

-- Example 26378
# Create a database and schema by running the following cell in the notebook:
database_ref = api_root.databases.create(Database(name="demo_database"), mode="orreplace")
schema_ref = database_ref.schemas.create(Schema(name="demo_schema"), mode="orreplace")

-- Example 26379
# first argument
sys.argv[0]

# print the entire list
st.write(sys.argv)

-- Example 26380
EXECUTE NOTEBOOK DB.SCHEMA.NOTEBOOK_NAME('--env staging --tablename staging-table');

-- Example 26381
# Top-level Header

-- Example 26382
## 2nd-level Header

-- Example 26383
### 3rd-level Header

-- Example 26384
*italicized text*

-- Example 26385
**bolded text**

-- Example 26386
[Link text](url)

-- Example 26387
1. first item
2. second item
  1. Nested first
  2. Nested second

-- Example 26388
- first item
- second item
  - Nested first
  - Nested second

-- Example 26389
```python
import pandas as pd
df = pd.DataFrame([1,2,3])
```

-- Example 26390
```sql
SELECT * FROM MYTABLE
```

-- Example 26391
![<alt_text>](<path_to_image>)

-- Example 26392
SELECT 'FRIDAY' as SNOWDAY, 0.2 as CHANCE_OF_SNOW
UNION ALL
SELECT 'SATURDAY',0.5
UNION ALL
SELECT 'SUNDAY', 0.9;

-- Example 26393
snowpark_df = cell1.to_df()

-- Example 26394
my_df = cell1.to_pandas()

-- Example 26395
SELECT * FROM {{cell2}} where PRICE > 500

-- Example 26396
c = "USA"

-- Example 26397
SELECT * FROM my_table WHERE COUNTRY = '{{c}}'

-- Example 26398
column_name = "COUNTRY"

-- Example 26399
SELECT * FROM my_table WHERE {{column_name}} = 'USA'

-- Example 26400
from snowflake.snowpark.context import get_active_session
session = get_active_session()
code_to_run = """
BEGIN
    CALL TRANSACTION_ANOMALY_MODEL!DETECT_ANOMALIES(
        INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'ANOMALY_INFERENCE'),
        TIMESTAMP_COLNAME =>'DATE',
        TARGET_COLNAME => 'TRANSACTION_AMOUNT',
        CONFIG_OBJECT => {'prediction_interval': 0.95}
    );

    LET x := SQLID;
    CREATE TABLE ANOMALY_PREDICTIONS AS SELECT * FROM TABLE(RESULT_SCAN(:x));
END;
"""
data = session.sql(code_to_run).collect(block=True);

-- Example 26401
user#> !help

+------------+-------------------------------------------+-------------+--------------------------------------------------------------------------------------------+
| Command    | Use                                       | Aliases     | Description                                                                                |
|------------+-------------------------------------------+-------------+--------------------------------------------------------------------------------------------|
| !abort     | !abort <query id>                         |             | Abort a query                                                                              |
| !connect   | !connect <connection_name>                |             | Create a new connection                                                                    |
| !define    | !define <variable>=<value>                |             | Define a variable as the given value                                                       |
| !edit      | !edit <query>                             |             | Opens up a text editor. Useful for writing longer queries. Defaults to last query          |
| !exit      | !exit                                     | !disconnect | Drop the current connection                                                                |
| !help      | !help                                     | !helps, !h  | Show the client help.                                                                      |
| !options   | !options                                  | !opts       | Show all options and their values                                                          |
| !pause     | !pause                                    |             | Pauses running queries.                                                                    |
| !print     | !print <message>                          |             | Print given text                                                                           |
| !queries   | !queries help, <filter>=<value>, <filter> |             | Lists queries matching the specified filters. Write <!queries> help for a list of filters. |
| !quit      | !quit                                     | !q          | Drop all connections and quit SnowSQL                                                      |
| !rehash    | !rehash                                   |             | Refresh autocompletion                                                                     |
| !result    | !result <query id>                        |             | See the result of a query                                                                  |
| !set       | !set <option>=<value>                     |             | Set an option to the given value                                                           |
| !source    | !source <filename>, <url>                 | !load       | Execute given sql file                                                                     |
| !spool     | !spool <filename>, off                    |             | Turn on or off writing results to file                                                     |
| !system    | !system <system command>                  |             | Run a system command in the shell                                                          |
| !variables | !variables                                | !vars       | Show all variables and their values                                                        |
+------------+-------------------------------------------+-------------+--------------------------------------------------------------------------------------------+

-- Example 26402
[variables]
<variable_name>=<variable_value>

-- Example 26403
[variables]
tablename=CENUSTRACKONE

-- Example 26404
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=$DB_KEY

-- Example 26405
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=%DB_KEY%

-- Example 26406
user#> !define tablename=CENUSTRACKONE

-- Example 26407
[options]
variable_substitution = True

-- Example 26408
$ snowsql ... -o variable_substitution=true

-- Example 26409
user#> !set variable_substitution=true

-- Example 26410
user#> !define snowshell=bash

user#> !set variable_substitution=true

user#> select '&snowshell';

+--------+
| 'BASH' |
|--------|
| bash   |
+--------+

-- Example 26411
user#> !define snowshell=bash

user#> !set variable_substitution=false

user#> select '&snowshell';

+--------------+
| '&SNOWSHELL' |
|--------------|
| &snowshell   |
+--------------+

-- Example 26412
select '&z';

Variable z is not defined

-- Example 26413
user#> !define snowshell=bash

user#> !set variable_substitution=true

select '&{snowshell}_shell';

+--------------+
| 'BASH_SHELL' |
|--------------|
| bash_shell   |
+--------------+

-- Example 26414
user#> !set variable_substitution=true

user#> select '&notsubstitution';

Variable notsubstitution is not defined

user#> select '&&notsubstitution';

+--------------------+
| '&NOTSUBSTITUTION' |
|--------------------|
| &notsubstitution   |
+--------------------+

-- Example 26415
user#> !variables

+-----------+-------+
| Name      | Value |
|-----------+-------|
| snowshell | bash  |
+-----------+-------+

-- Example 26416
user#> insert into a values(1),(2),(3);

+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
3 Row(s) produced. Time Elapsed: 0.950s

user#> !set variable_substitution=true

user#> select &__rowcount;

+---+
| 3 |
|---|
| 3 |
+---+

-- Example 26417
user#> !set variable_substitution=true

user#> select * from a;

user#> select '&__sfqid';

+----------------------------------------+
| 'A5F35B56-49A2-4437-BA0E-998496CE793E' |
|----------------------------------------|
| a5f35b56-49a2-4437-ba0e-998496ce793e   |
+----------------------------------------+

-- Example 26418
snowsql -a myorganization-myaccount -u jsmith -f /tmp/input_script.sql -o output_file=/tmp/output.csv -o quiet=true -o friendly=false -o header=false -o output_format=csv

-- Example 26419
user#> !source example.sql

-- Example 26420
snowsql -c my_example_connection -d sales_db -s public -q 'select * from mytable limit 10' -o output_format=csv -o header=false -o timing=false -o friendly=false  > output_file.csv

-- Example 26421
snowsql -c my_example_connection -d sales_db -s public -q "select * from mytable limit 10" -o output_format=csv -o header=false -o timing=false -o friendly=false  > output_file.csv

-- Example 26422
[user]#[warehouse]@[database].[schema]>

-- Example 26423
jdoe#DATALOAD@BOOKS_DB.PUBLIC>

-- Example 26424
jdoe#DATALOAD@BOOKS_DB.PUBLIC> !set prompt_format=[#FF0000][user].[role].[#00FF00][database].[schema].[#0000FF][warehouse]>

-- Example 26425
user#> !abort 77589bd1-bcbf-4ec8-9ebc-6c949b00614d;

-- Example 26426
[connections.my_example_connection]
...

-- Example 26427
user#> !connect my_example_connection

-- Example 26428
user#> !print Include This Text

-- Example 26429
!queries session

-- Example 26430
!queries amount=20

-- Example 26431
!queries amount=20 duration=200

-- Example 26432
!queries warehouse=mywh

-- Example 26433
user#> !queries session

+-----+--------------------------------------+----------+-----------+----------+
| VAR | QUERY ID                             | SQL TEXT | STATUS    | DURATION |
|-----+--------------------------------------+----------+-----------+----------|
| &0  | acbd6778-c68c-4e79-a977-510b2d8c08f1 | select 1 | SUCCEEDED |       19 |
+-----+--------------------------------------+----------+-----------+----------+

user#> !result &0

+---+
| 1 |
|---|
| 1 |
+---+

user#> !result acbd6778-c68c-4e79-a977-510b2d8c08f1

+---+
| 1 |
|---|
| 1 |
+---+

-- Example 26434
user#> !result 77589bd1-bcbf-4ec8-9ebc-6c949b00614d;

-- Example 26435
user#> !options

+-----------------------+-------------------+
| Name                  | Value             |
|-----------------------+-------------------|
 ...
| rowset_size           | 1000              |
 ...
+-----------------------+-------------------+

user#> !set rowset_size=500

user#> !options

+-----------------------+-------------------+
| Name                  | Value             |
|-----------------------+-------------------|
 ...
| rowset_size           | 500               |
 ...
+-----------------------+-------------------+

user#> !set rowset_size=1000

user#> !options

+-----------------------+-------------------+
| Name                  | Value             |
|-----------------------+-------------------|
 ...
| rowset_size           | 1000              |
 ...
+-----------------------+-------------------+

-- Example 26436
user#> !source example.sql

user#> !load /tmp/scripts/example.sql

user#> !load http://www.example.com/sql_text.sql

-- Example 26437
user#> select 1 num;

+-----+
| NUM |
|-----|
|   1 |
+-----+

user#> !spool /tmp/spool_example

user#> select 2 num;

+---+
| 2 |
|---|
| 2 |
+---+

user#> !spool off

user#> select 3 num;

+---+
| 3 |
|---|
| 3 |
+---+

user#> !exit

Goodbye!

$ cat /tmp/spool_example

+---+
| 2 |
|---|
| 2 |
+---+

-- Example 26438
user#> !set output_format=csv

user#> !spool /tmp/spool_example

-- Example 26439
user#> !system ls ~

