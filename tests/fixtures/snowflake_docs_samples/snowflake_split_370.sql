-- Example 24765
+----------------+-----------+------+
| ACT_SCENE_LINE | CHARACTER | LINE |
|----------------+-----------+------|
+----------------+-----------+------+

-- Example 24766
SELECT act_scene_line, character, line
  FROM lines
  WHERE SEARCH(line, 'KING Rosencrantz', SEARCH_MODE => 'OR')
    AND act_scene_line IS NOT NULL;

-- Example 24767
+----------------+------------------+-----------------------------------------------------------+
| ACT_SCENE_LINE | CHARACTER        | LINE                                                      |
|----------------+------------------+-----------------------------------------------------------|
| 1.1.1          | WARWICK          | I wonder how the king escaped our hands.                  |
| 1.1.10         | First Gentleman  | Is outward sorrow, though I think the king                |
| 2.2.1          | KING CLAUDIUS    | Welcome, dear Rosencrantz and Guildenstern!               |
| 2.2.35         | KING CLAUDIUS    | Thanks, Rosencrantz and gentle Guildenstern.              |
| 2.2.36         | QUEEN GERTRUDE   | Thanks, Guildenstern and gentle Rosencrantz:              |
| 2.2.241        | HAMLET           | Guildenstern? Ah, Rosencrantz! Good lads, how do ye both? |
| 4.6.27         | HORATIO          | where I am. Rosencrantz and Guildenstern hold their       |
| 5.2.60         | HORATIO          | So Guildenstern and Rosencrantz go to't.                  |
| 5.2.389        | First Ambassador | That Rosencrantz and Guildenstern are dead:               |
| 1.1.1          | KENT             | I thought the king had more affected the Duke of          |
| 1.0.21         | LODOVICO         | This king unto him took a fere,                           |
+----------------+------------------+-----------------------------------------------------------+

-- Example 24768
CREATE OR REPLACE TABLE car_rentals(
  vehicle_make VARCHAR(30),
  dealership VARCHAR(30),
  salesperson VARCHAR(30));

INSERT INTO car_rentals VALUES
  ('Toyota', 'Tindel Toyota', 'Greg Northrup'),
  ('Honda', 'Valley View Auto Sales', 'Frank Beasley'),
  ('Tesla', 'Valley View Auto Sales', 'Arturo Sandoval');

-- Example 24769
SELECT SEARCH((r.vehicle_make, r.dealership, s.src:dealership), 'Toyota Tesla')
    AS contains_toyota_tesla, r.vehicle_make, r.dealership,s.src:dealership
  FROM car_rentals r JOIN car_sales s
    ON r.SALESPERSON=s.src:salesperson.name;

-- Example 24770
+-----------------------+--------------+------------------------+--------------------------+
| CONTAINS_TOYOTA_TESLA | VEHICLE_MAKE | DEALERSHIP             | S.SRC:DEALERSHIP         |
|-----------------------+--------------+------------------------+--------------------------|
| True                  | Toyota       | Tindel Toyota          | "Tindel Toyota"          |
| False                 | Honda        | Valley View Auto Sales | "Valley View Auto Sales" |
+-----------------------+--------------+------------------------+--------------------------+

-- Example 24771
SELECT SEARCH((r.vehicle_make, r.dealership, s.src:dealership), 'Toyota Honda')
    AS contains_toyota_honda, r.vehicle_make, r.dealership, s.src:dealership
  FROM car_rentals r JOIN car_sales s
    ON r.SALESPERSON =s.src:salesperson.name;

-- Example 24772
+-----------------------+--------------+------------------------+--------------------------+
| CONTAINS_TOYOTA_HONDA | VEHICLE_MAKE | DEALERSHIP             | S.SRC:DEALERSHIP         |
|-----------------------+--------------+------------------------+--------------------------|
| True                  | Toyota       | Tindel Toyota          | "Tindel Toyota"          |
| True                  | Honda        | Valley View Auto Sales | "Valley View Auto Sales" |
+-----------------------+--------------+------------------------+--------------------------+

-- Example 24773
SELECT line_id, act_scene_line FROM lines
  WHERE SEARCH(act_scene_line, '1.2.500', ANALYZER=>'NO_OP_ANALYZER');

-- Example 24774
+---------+----------------+
| LINE_ID | ACT_SCENE_LINE |
|---------+----------------|
|   91998 | 1.2.500        |
|  108464 | 1.2.500        |
+---------+----------------+

-- Example 24775
SELECT DISTINCT(play)
  FROM lines
  WHERE SEARCH(play, 'love''s', ANALYZER=>'UNICODE_ANALYZER');

-- Example 24776
+----------------------+
| PLAY                 |
|----------------------|
| Love's Labour's Lost |
+----------------------+

-- Example 24777
SELECT DISTINCT(play) FROM lines WHERE SEARCH(play, 'love''s');

-- Example 24778
+---------------------------+
| PLAY                      |
|---------------------------|
| All's Well That Ends Well |
| Love's Labour's Lost      |
| A Midsummer Night's Dream |
| The Winter's Tale         |
+---------------------------+

-- Example 24779
SELECT SEARCH(line, 5) FROM lines;

-- Example 24780
001045 (22023): SQL compilation error:
argument needs to be a string: '1'

-- Example 24781
SELECT SEARCH(line_id, 'dream') FROM lines;

-- Example 24782
001173 (22023): SQL compilation error: error line 1 at position 7: Expected non-empty set of columns supporting full-text search.

-- Example 24783
SELECT SEARCH((line_id, play), 'dream') FROM lines
  ORDER BY play LIMIT 5;

-- Example 24784
+----------------------------------+
| SEARCH((LINE_ID, PLAY), 'DREAM') |
|----------------------------------|
| True                             |
| True                             |
| False                            |
| False                            |
| False                            |
+----------------------------------+

-- Example 24785
SELECT SEARCH('docs@snowflake.com', 'careers@snowflake.com', '@');

-- Example 24786
001881 (42601): SQL compilation error: Expected 1 named argument(s), found 0

-- Example 24787
SELECT SEARCH(play,line,'king', ANALYZER=>'UNICODE_ANALYZER') FROM lines;

-- Example 24788
000939 (22023): SQL compilation error: error line 1 at position 7
too many arguments for function [SEARCH(LINES.PLAY, LINES.LINE, 'king', 'UNICODE_ANALYZER')] expected 3, got 4

-- Example 24789
SELECT SEARCH(line, character) FROM lines;

-- Example 24790
001015 (22023): SQL compilation error:
argument 2 to function SEARCH needs to be constant, found 'LINES.CHARACTER'

-- Example 24791
DESCRIBE TABLE lines;

-- Example 24792
+----------------+---------------+--------+-------+-
| name           | type          | kind   | null? |
|----------------+---------------+--------+-------+-
| LINE_ID        | NUMBER(38,0)  | COLUMN | Y     |
| PLAY           | VARCHAR(50)   | COLUMN | Y     |
| SPEECH_NUM     | NUMBER(38,0)  | COLUMN | Y     |
| ACT_SCENE_LINE | VARCHAR(10)   | COLUMN | Y     |
| CHARACTER      | VARCHAR(30)   | COLUMN | Y     |
| LINE           | VARCHAR(2000) | COLUMN | Y     |
+----------------+---------------+--------+-------+-

-- Example 24793
SELECT * FROM lines
  WHERE line_id=34230;

-- Example 24794
+---------+--------+------------+----------------+-----------+--------------------------------------------+
| LINE_ID | PLAY   | SPEECH_NUM | ACT_SCENE_LINE | CHARACTER | LINE                                       |
|---------+--------+------------+----------------+-----------+--------------------------------------------|
|   34230 | Hamlet |         19 | 3.1.64         | HAMLET    | To be, or not to be, that is the question: |
+---------+--------+------------+----------------+-----------+--------------------------------------------+

-- Example 24795
CREATE OR REPLACE TABLE lines(
  line_id INT,
  play VARCHAR(50),
  speech_num INT,
  act_scene_line VARCHAR(10),
  character VARCHAR(30),
  line VARCHAR(2000)
  );

INSERT INTO lines VALUES
  (4,'Henry IV Part 1',1,'1.1.1','KING HENRY IV','So shaken as we are, so wan with care,'),
  (13,'Henry IV Part 1',1,'1.1.10','KING HENRY IV','Which, like the meteors of a troubled heaven,'),
  (9526,'Henry VI Part 3',1,'1.1.1','WARWICK','I wonder how the king escaped our hands.'),
  (12664,'All''s Well That Ends Well',1,'1.1.1','COUNTESS','In delivering my son from me, I bury a second husband.'),
  (15742,'All''s Well That Ends Well',114,'5.3.378','KING','Your gentle hands lend us, and take our hearts.'),
  (16448,'As You Like It',2,'2.3.6','ADAM','And wherefore are you gentle, strong and valiant?'),
  (24055,'The Comedy of Errors',14,'5.1.41','AEMELIA','Be quiet, people. Wherefore throng you hither?'),
  (28487,'Cymbeline',3,'1.1.10','First Gentleman','Is outward sorrow, though I think the king'),
  (33522,'Hamlet',1,'2.2.1','KING CLAUDIUS','Welcome, dear Rosencrantz and Guildenstern!'),
  (33556,'Hamlet',5,'2.2.35','KING CLAUDIUS','Thanks, Rosencrantz and gentle Guildenstern.'),
  (33557,'Hamlet',6,'2.2.36','QUEEN GERTRUDE','Thanks, Guildenstern and gentle Rosencrantz:'),
  (33776,'Hamlet',67,'2.2.241','HAMLET','Guildenstern? Ah, Rosencrantz! Good lads, how do ye both?'),
  (34230,'Hamlet',19,'3.1.64','HAMLET','To be, or not to be, that is the question:'),
  (35672,'Hamlet',7,'4.6.27','HORATIO','where I am. Rosencrantz and Guildenstern hold their'),
  (36289,'Hamlet',14,'5.2.60','HORATIO','So Guildenstern and Rosencrantz go to''t.'),
  (36640,'Hamlet',143,'5.2.389','First Ambassador','That Rosencrantz and Guildenstern are dead:'),
  (43494,'King John',1,'1.1.1','KING JOHN','Now, say, Chatillon, what would France with us?'),
  (43503,'King John',5,'1.1.10','CHATILLON','To this fair island and the territories,'),
  (49031,'King Lear',1,'1.1.1','KENT','I thought the king had more affected the Duke of'),
  (49040,'King Lear',4,'1.1.10','GLOUCESTER','so often blushed to acknowledge him, that now I am'),
  (52797,'Love''s Labour''s Lost',1,'1.1.1','FERDINAND','Let fame, that all hunt after in their lives,'),
  (55778,'Love''s Labour''s Lost',405,'5.2.971','ADRIANO DE ARMADO','Apollo. You that way: we this way.'),
  (67000,'A Midsummer Night''s Dream',1,'1.1.1','THESEUS','Now, fair Hippolyta, our nuptial hour'),
  (69296,'A Midsummer Night''s Dream',104,'5.1.428','PUCK','And Robin shall restore amends.'),
  (75787,'Pericles',178,'1.0.21','LODOVICO','This king unto him took a fere,'),
  (78407,'Richard II',1,'1.1.1','KING RICHARD II','Old John of Gaunt, time-honour''d Lancaster,'),
  (91998,'The Tempest',108,'1.2.500','FERDINAND','Were I but where ''tis spoken.'),
  (92454,'The Tempest',150,'2.1.343','ALONSO','Wherefore this ghastly looking?'),
  (99330,'Troilus and Cressida',30,'1.1.102','AENEAS','How now, Prince Troilus! wherefore not afield?'),
  (100109,'Troilus and Cressida',31,'2.1.53','ACHILLES','Why, how now, Ajax! wherefore do you thus? How now,'),
  (108464,'The Winter''s Tale',106,'1.2.500','CAMILLO','As or by oath remove or counsel shake')
  ;

-- Example 24796
snow object drop
  <object_type>
  <object_name>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 24797
snow object drop procedure "test_procedure()"

-- Example 24798
drop procedure test_procedure()
+--------------------------------------+
| status                               |
|--------------------------------------|
| TEST_PROCEDURE successfully dropped. |
+--------------------------------------+

-- Example 24799
snow object list
  <object_type>
  --like <like>
  --in <scope>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 24800
snow object list role --like public%

-- Example 24801
show roles like 'public%'
+-------------------------------------------------------------------------------
| created_on                       | name        | is_default | is_current | ...
|----------------------------------+-------------+------------+------------+----
| 2023-02-01 15:25:04.105000-08:00 | PUBLIC      | N          | N          | ...
| 2024-01-15 12:55:05.840000-08:00 | PUBLIC_TEST | N          | N          | ...
+-------------------------------------------------------------------------------

-- Example 24802
DROP SNOWFLAKE.ML.ANOMALY_DETECTION [IF EXISTS] <model_name>;

-- Example 24803
DROP SNOWFLAKE.ML.FORECAST [ IF EXISTS ] <model_name>;

-- Example 24804
>>> connection_parameters = {
...     "user": "<user_name>",
...     "password": "<password>",
...     "account": "<account_name>",
...     "role": "<role_name>",
...     "warehouse": "<warehouse_name>",
...     "database": "<database_name>",
...     "schema": "<schema_name>",
... }
>>> session = Session.builder.configs(connection_parameters).create()

-- Example 24805
>>> session = Session.builder.configs({"connection": <your python connector connection>}).create()

-- Example 24806
>>> session = Session.builder.app_name("my_app").configs(db_parameters).create() 
>>> print(session.query_tag) 
APPNAME=my_app
>>> session = Session.builder.app_name("my_app", format_json=True).configs(db_parameters).create() 
>>> print(session.query_tag) 
{"APPNAME": "my_app"}

-- Example 24807
>>> from snowflake.snowpark.types import IntegerType
>>> from resources.test_udf_dir.test_udf_file import mod5
>>> session.add_import("tests/resources/test_udf_dir/test_udf_file.py", import_path="resources.test_udf_dir.test_udf_file")
>>> mod5_and_plus1_udf = session.udf.register(
...     lambda x: mod5(x) + 1,
...     return_type=IntegerType(),
...     input_types=[IntegerType()]
... )
>>> session.range(1, 8, 2).select(mod5_and_plus1_udf("id")).to_df("col1").collect()
[Row(COL1=2), Row(COL1=4), Row(COL1=1), Row(COL1=3)]
>>> session.clear_imports()

-- Example 24808
>>> import numpy as np
>>> from snowflake.snowpark.functions import udf
>>> import numpy
>>> import pandas
>>> import dateutil
>>> # add numpy with the latest version on Snowflake Anaconda
>>> # and pandas with the version "2.1.*"
>>> # and dateutil with the local version in your environment
>>> session.custom_package_usage_config = {"enabled": True}  # This is added because latest dateutil is not in snowflake yet
>>> session.add_packages("numpy", "pandas==2.1.*", dateutil)
>>> @udf
... def get_package_name_udf() -> list:
...     return [numpy.__name__, pandas.__name__, dateutil.__name__]
>>> session.sql(f"select {get_package_name_udf.name}()").to_df("col1").show()
----------------
|"COL1"        |
----------------
|[             |
|  "numpy",    |
|  "pandas",   |
|  "dateutil"  |
|]             |
----------------

>>> session.clear_packages()

-- Example 24809
>>> from snowflake.snowpark.functions import udf
>>> import numpy
>>> import pandas
>>> # test_requirements.txt contains "numpy" and "pandas"
>>> session.add_requirements("tests/resources/test_requirements.txt")
>>> @udf
... def get_package_name_udf() -> list:
...     return [numpy.__name__, pandas.__name__]
>>> session.sql(f"select {get_package_name_udf.name}()").to_df("col1").show()
--------------
|"COL1"      |
--------------
|[           |
|  "numpy",  |
|  "pandas"  |
|]           |
--------------

>>> session.clear_packages()

-- Example 24810
>>> session.query_tag = "tag1"
>>> session.append_query_tag("tag2")
>>> print(session.query_tag)
tag1,tag2
>>> session.query_tag = "new_tag"
>>> print(session.query_tag)
new_tag

-- Example 24811
>>> session.query_tag = ""
>>> session.append_query_tag("tag1")
>>> print(session.query_tag)
tag1

-- Example 24812
>>> session.query_tag = "tag1"
>>> session.append_query_tag("tag2", separator="|")
>>> print(session.query_tag)
tag1|tag2

-- Example 24813
>>> session.sql("ALTER SESSION SET QUERY_TAG = 'tag1'").collect()
[Row(status='Statement executed successfully.')]
>>> session.append_query_tag("tag2")
>>> print(session.query_tag)
tag1,tag2

-- Example 24814
>>> import snowflake.snowpark
>>> from snowflake.snowpark.functions import sproc
>>>
>>> session.add_packages('snowflake-snowpark-python')
>>>
>>> @sproc(name="my_copy_sp", replace=True)
... def my_copy(session: snowflake.snowpark.Session, from_table: str, to_table: str, count: int) -> str:
...     session.table(from_table).limit(count).write.save_as_table(to_table)
...     return "SUCCESS"
>>> _ = session.sql("create or replace table test_from(test_str varchar) as select randstr(20, random()) from table(generator(rowCount => 100))").collect()
>>> _ = session.sql("drop table if exists test_to").collect()
>>> session.call("my_copy_sp", "test_from", "test_to", 10)
'SUCCESS'
>>> session.table("test_to").count()
10

-- Example 24815
>>> from snowflake.snowpark.dataframe import DataFrame
>>>
>>> @sproc(name="my_table_sp", replace=True)
... def my_table(session: snowflake.snowpark.Session, x: int, y: int, col1: str, col2: str) -> DataFrame:
...     return session.sql(f"select {x} as {col1}, {y} as {col2}")
>>> session.call("my_table_sp", 1, 2, "a", "b").show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 24816
>>> # create a dataframe with a schema
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField
>>> schema = StructType([StructField("a", IntegerType()), StructField("b", StringType())])
>>> session.create_dataframe([[1, "snow"], [3, "flake"]], schema).collect()
[Row(A=1, B='snow'), Row(A=3, B='flake')]

>>> # create a dataframe by inferring a schema from the data
>>> from snowflake.snowpark import Row
>>> # infer schema
>>> session.create_dataframe([1, 2, 3, 4], schema=["a"]).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=4)]
>>> session.create_dataframe([[1, 2, 3, 4]], schema=["a", "b", "c", "d"]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"]).collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> session.create_dataframe([Row(a=1, b=2, c=3, d=4)]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([{"a": 1}, {"b": 2}]).collect()
[Row(A=1, B=None), Row(A=None, B=2)]

>>> # create a dataframe from a pandas Dataframe
>>> import pandas as pd
>>> session.create_dataframe(pd.DataFrame([(1, 2, 3, 4)], columns=["a", "b", "c", "d"])).collect()
[Row(a=1, b=2, c=3, d=4)]

>>> # create a dataframe using an implicit struct schema string
>>> session.create_dataframe([[10, 20], [30, 40]], schema="x: int, y: int").collect()
[Row(X=10, Y=20), Row(X=30, Y=40)]

-- Example 24817
>>> # create a dataframe with a schema
>>> from snowflake.snowpark.types import IntegerType, StringType, StructField
>>> schema = StructType([StructField("a", IntegerType()), StructField("b", StringType())])
>>> session.create_dataframe([[1, "snow"], [3, "flake"]], schema).collect()
[Row(A=1, B='snow'), Row(A=3, B='flake')]

>>> # create a dataframe by inferring a schema from the data
>>> from snowflake.snowpark import Row
>>> # infer schema
>>> session.create_dataframe([1, 2, 3, 4], schema=["a"]).collect()
[Row(A=1), Row(A=2), Row(A=3), Row(A=4)]
>>> session.create_dataframe([[1, 2, 3, 4]], schema=["a", "b", "c", "d"]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"]).collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> session.create_dataframe([Row(a=1, b=2, c=3, d=4)]).collect()
[Row(A=1, B=2, C=3, D=4)]
>>> session.create_dataframe([{"a": 1}, {"b": 2}]).collect()
[Row(A=1, B=None), Row(A=None, B=2)]

>>> # create a dataframe from a pandas Dataframe
>>> import pandas as pd
>>> session.create_dataframe(pd.DataFrame([(1, 2, 3, 4)], columns=["a", "b", "c", "d"])).collect()
[Row(a=1, b=2, c=3, d=4)]

>>> # create a dataframe using an implicit struct schema string
>>> session.create_dataframe([[10, 20], [30, 40]], schema="x: int, y: int").collect()
[Row(X=10, Y=20), Row(X=30, Y=40)]

-- Example 24818
df = session.flatten(parse_json(lit('{"a":[1,2]}')), "a", False, False, "BOTH")

-- Example 24819
>>> from snowflake.snowpark.functions import lit, parse_json
>>> session.flatten(parse_json(lit('{"a":[1,2]}')), path="a", outer=False, recursive=False, mode="BOTH").show()
-------------------------------------------------------
|"SEQ"  |"KEY"  |"PATH"  |"INDEX"  |"VALUE"  |"THIS"  |
-------------------------------------------------------
|1      |NULL   |a[0]    |0        |1        |[       |
|       |       |        |         |         |  1,    |
|       |       |        |         |         |  2     |
|       |       |        |         |         |]       |
|1      |NULL   |a[1]    |1        |2        |[       |
|       |       |        |         |         |  1,    |
|       |       |        |         |         |  2     |
|       |       |        |         |         |]       |
-------------------------------------------------------

-- Example 24820
>>> from snowflake.snowpark.functions import seq1, seq8, uniform
>>> df = session.generator(seq1(1).as_("sequence one"), uniform(1, 10, 2).as_("uniform"), rowcount=3)
>>> df.show()
------------------------------
|"sequence one"  |"UNIFORM"  |
------------------------------
|0               |3          |
|1               |3          |
|2               |3          |
------------------------------

-- Example 24821
>>> df = session.generator(seq8(0), uniform(1, 10, 2), timelimit=1).order_by(seq8(0)).limit(3)
>>> df.show()
-----------------------------------
|"SEQ8(0)"  |"UNIFORM(1, 10, 2)"  |
-----------------------------------
|0          |3                    |
|1          |3                    |
|2          |3                    |
-----------------------------------

-- Example 24822
>>> with session.query_history(True) as query_history:
...     df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
...     df = df.filter(df.a == 1)
...     res = df.collect()
>>> assert len(query_history.queries) == 2
>>> assert query_history.queries[0].is_describe
>>> assert not query_history.queries[1].is_describe

-- Example 24823
>>> session.range(10).collect()
[Row(ID=0), Row(ID=1), Row(ID=2), Row(ID=3), Row(ID=4), Row(ID=5), Row(ID=6), Row(ID=7), Row(ID=8), Row(ID=9)]
>>> session.range(1, 10).collect()
[Row(ID=1), Row(ID=2), Row(ID=3), Row(ID=4), Row(ID=5), Row(ID=6), Row(ID=7), Row(ID=8), Row(ID=9)]
>>> session.range(1, 10, 2).collect()
[Row(ID=1), Row(ID=3), Row(ID=5), Row(ID=7), Row(ID=9)]

-- Example 24824
>>> session.clear_imports()
>>> len(session.get_imports())
0
>>> session.add_import("tests/resources/test_udf_dir/test_udf_file.py")
>>> len(session.get_imports())
1
>>> session.remove_import("tests/resources/test_udf_dir/test_udf_file.py")
>>> len(session.get_imports())
0

-- Example 24825
>>> session.clear_packages()
>>> len(session.get_packages())
0
>>> session.add_packages("numpy", "pandas==2.1.4")
>>> len(session.get_packages())
2
>>> session.remove_package("numpy")
>>> len(session.get_packages())
1
>>> session.remove_package("pandas")
>>> len(session.get_packages())
0

-- Example 24826
>>> from snowflake.snowpark.functions import udf
>>> import numpy
>>> import pandas
>>> # test_requirements.txt contains "numpy" and "pandas"
>>> session.custom_package_usage_config = {"enabled": True, "force_push": True} # Recommended configuration
>>> session.replicate_local_environment(ignore_packages={"snowflake-snowpark-python", "snowflake-connector-python", "urllib3", "tzdata", "numpy"}, relax=True)
>>> @udf
... def get_package_name_udf() -> list:
...     return [numpy.__name__, pandas.__name__]
>>> if sys.version_info <= (3, 11):
...     session.sql(f"select {get_package_name_udf.name}()").to_df("col1").show()  
--------------
|"COL1"      |
--------------
|[           |
|  "numpy",  |
|  "pandas"  |
|]           |
--------------

>>> session.clear_packages()
>>> session.clear_imports()

-- Example 24827
>>> # create a dataframe from a SQL query
>>> df = session.sql("select 1/2")
>>> # execute the query
>>> df.collect()
[Row(1/2=Decimal('0.500000'))]

>>> # Use params to bind variables
>>> session.sql("select * from values (?, ?), (?, ?)", params=[1, "a", 2, "b"]).sort("column1").collect()
[Row(COLUMN1=1, COLUMN2='a'), Row(COLUMN1=2, COLUMN2='b')]

-- Example 24828
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df1.write.save_as_table("my_table", mode="overwrite", table_type="temporary")
>>> session.table("my_table").collect()
[Row(A=1, B=2), Row(A=3, B=4)]
>>> current_db = session.get_current_database()
>>> current_schema = session.get_current_schema()
>>> session.table([current_db, current_schema, "my_table"]).collect()
[Row(A=1, B=2), Row(A=3, B=4)]

-- Example 24829
>>> from snowflake.snowpark.functions import lit
>>> session.table_function("split_to_table", lit("split words to table"), lit(" ")).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 24830
>>> from snowflake.snowpark.functions import table_function, lit
>>> split_to_table = table_function("split_to_table")
>>> session.table_function(split_to_table(lit("split words to table"), lit(" "))).collect()
[Row(SEQ=1, INDEX=1, VALUE='split'), Row(SEQ=1, INDEX=2, VALUE='words'), Row(SEQ=1, INDEX=3, VALUE='to'), Row(SEQ=1, INDEX=4, VALUE='table')]

-- Example 24831
>>> from snowflake.snowpark.types import IntegerType, StructField, StructType
>>> from snowflake.snowpark.functions import udtf, lit
>>> class GeneratorUDTF:
...     def process(self, n):
...         for i in range(n):
...             yield (i, )
>>> generator_udtf = udtf(GeneratorUDTF, output_schema=StructType([StructField("number", IntegerType())]), input_types=[IntegerType()])
>>> session.table_function(generator_udtf(lit(3))).collect()
[Row(NUMBER=0), Row(NUMBER=1), Row(NUMBER=2)]

