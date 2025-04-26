-- Example 28718
SELECT * FROM tab1, TABLE(js_udtf(tab1.c1, tab1.c2) OVER ());

-- Example 28719
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

-- Example 28720
+------------+
| OUTPUT_COL |
+============+
| Hello      |
+------------+
| World      |
+------------+

-- Example 28721
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

-- Example 28722
+------------+
|  GREETING  |
+============+
| Hello      |
+------------+
| James      |
+------------+
| Kirk       |
+------------+

-- Example 28723
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

-- Example 28724
SELECT * FROM parts, TABLE(char_sum(s));

-- Example 28725
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

-- Example 28726
SELECT * FROM parts, TABLE(char_sum(s) OVER (PARTITION BY p));

-- Example 28727
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

-- Example 28728
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

-- Example 28729
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

-- Example 28730
CREATE TABLE ip_address_ranges(prefix VARCHAR, range_start INTEGER, range_end INTEGER);
INSERT INTO ip_address_ranges (prefix, range_start, range_end) VALUES
    ('192.168.1', 42, 44),
    ('192.168.2', 10, 12),
    ('192.168.2', 40, 40)
    ;

SELECT rtv.ip_address
  FROM ip_address_ranges AS r, TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv;

-- Example 28731
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

-- Example 28732
for input_row in ip_address_ranges:
  output_row = range_to_values(input_row.prefix, input_row.range_start, input_row.range_end)

-- Example 28733
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

-- Example 28734
+-------------------------------+
| IPV6                          |
+===============================+
| 192.168.3.100.000.000.000.000 |
+-------------------------------+
| 192.168.3.100....             |
+-------------------------------+
| 192.168.3.100.FFF.FFF.FFF.FFF |
+-------------------------------+

-- Example 28735
SELECT rtv6.ipv6
  FROM ip_address_ranges AS r,
       TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv,
       TABLE(fake_ipv4_to_ipv6(rtv.ip_address)) AS rtv6
  WHERE r.prefix = '192.168.2'  -- limits the output for this example
  ;

-- Example 28736
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

-- Example 28737
SELECT rtv6.ipv6
  FROM ip_address_ranges AS r,
       TABLE(fake_ipv4_to_ipv6(rtv.ip_address)) AS rtv6,
       TABLE(range_to_values(r.prefix, r.range_start::FLOAT, r.range_end::FLOAT)) AS rtv
 WHERE r.prefix = '192.168.2'  -- limits the output for this example
  ;

-- Example 28738
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

-- Example 28739
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

-- Example 28740
snow object list --help

-- Example 28741
Usage: snow object list [OPTIONS] OBJECT_TYPE

Lists all available Snowflake objects of given type.
Supported types: compute-pool, database, function, image-repository, integration, network-rule,
procedure, role, schema, secret, service, stage, stream, streamlit, table, task,
user, view, warehouse

...

-- Example 28742
snow object create TYPE ([OBJECT_ATTRIBUTES]|[--json {OBJECT_DEFINITION}])

-- Example 28743
snow object create database name=my_db comment="Created with Snowflake CLI"

-- Example 28744
snow object create database --json '{"name":"my_db", "comment":"Created with Snowflake CLI"}'

-- Example 28745
snow object create database name=my_db comment='Created with Snowflake CLI'

-- Example 28746
snow object create table name=my_table columns='[{"name":"col1","datatype":"number", "nullable":false}]' constraints='[{"name":"prim_key", "column_names":["col1"], "constraint_type":"PRIMARY KEY"}]' --database my_db

-- Example 28747
snow object create database --json '{"name":"my_db", "comment":"Created with Snowflake CLI"}'

-- Example 28748
snow object create table --json "$(cat table.json)" --database my_db

-- Example 28749
{
  "name": "my_table",
  "columns": [
    {
      "name": "col1",
      "datatype": "number",
      "nullable": false
    }
  ],
  "constraints": [
    {
      "name": "prim_key",
      "column_names": ["col1"],
      "constraint_type": "PRIMARY KEY"
    }
  ]
}

-- Example 28750
snow object list TYPE

-- Example 28751
snow object list role

-- Example 28752
+--------------------------------------------------------------------------------------------------------------------------------+
|            |            |            |            | is_inherit | assigned_t | granted_to | granted_ro |            |           |
| created_on | name       | is_default | is_current | ed         | o_users    | _roles     | les        | owner      | comment   |
|------------+------------+------------+------------+------------+------------+------------+------------+------------+-----------|
| 2023-07-24 | ACCOUNTADM | N          | N          | N          | 2          | 0          | 2          |            | Account   |
| 06:05:49-0 | IN         |            |            |            |            |            |            |            | administr |
| 7:00       |            |            |            |            |            |            |            |            | ator can  |
|            |            |            |            |            |            |            |            |            | manage    |
|            |            |            |            |            |            |            |            |            | all       |
|            |            |            |            |            |            |            |            |            | aspects   |
|            |            |            |            |            |            |            |            |            | of the    |
|            |            |            |            |            |            |            |            |            | account.  |
| 2023-07-24 | PUBLIC     | N          | N          | Y          | 0          | 0          | 0          |            | Public    |
| 06:05:48.9 |            |            |            |            |            |            |            |            | role is   |
| 56000-07:0 |            |            |            |            |            |            |            |            | automatic |
| 0          |            |            |            |            |            |            |            |            | ally      |
|            |            |            |            |            |            |            |            |            | available |
|            |            |            |            |            |            |            |            |            | to every  |
|            |            |            |            |            |            |            |            |            | user in   |
|            |            |            |            |            |            |            |            |            | the       |
|            |            |            |            |            |            |            |            |            | account.  |
| 2023-07-24 | SYSADMIN   | N          | N          | N          | 0          | 1          | 0          |            | System    |
| 06:05:49.0 |            |            |            |            |            |            |            |            | administr |
| 33000-07:0 |            |            |            |            |            |            |            |            | ator can  |
| 0          |            |            |            |            |            |            |            |            | create    |
|            |            |            |            |            |            |            |            |            | and       |
|            |            |            |            |            |            |            |            |            | manage    |
|            |            |            |            |            |            |            |            |            | databases |
|            |            |            |            |            |            |            |            |            | and       |
|            |            |            |            |            |            |            |            |            | warehouse |
|            |            |            |            |            |            |            |            |            | s.        |
| 2023-07-24 | USERADMIN  | N          | N          | N          | 0          | 1          | 0          |            | User      |
| 06:05:49.0 |            |            |            |            |            |            |            |            | administr |
| 45000-07:0 |            |            |            |            |            |            |            |            | ator can  |
| 0          |            |            |            |            |            |            |            |            | create    |
|            |            |            |            |            |            |            |            |            | and       |
|            |            |            |            |            |            |            |            |            | manage    |
|            |            |            |            |            |            |            |            |            | users and |
|            |            |            |            |            |            |            |            |            | roles     |
+--------------------------------------------------------------------------------------------------------------------------------+

-- Example 28753
snow object list role --like public%

-- Example 28754
show roles like 'public%'
+-------------------------------------------------------------------------------
| created_on                       | name        | is_default | is_current | ...
|----------------------------------+-------------+------------+------------+----
| 2023-02-01 15:25:04.105000-08:00 | PUBLIC      | N          | N          | ...
| 2024-01-15 12:55:05.840000-08:00 | PUBLIC_TEST | N          | N          | ...
+-------------------------------------------------------------------------------

-- Example 28755
snow object describe TYPE IDENTIFIER

-- Example 28756
snow object describe function "hello_function(string)"

-- Example 28757
describe function hello_function(string)
+---------------------------------------------------------------------
| property           | value
|--------------------+------------------------------------------------
| signature          | (NAME VARCHAR)
| returns            | VARCHAR(16777216)
| language           | PYTHON
| null handling      | CALLED ON NULL INPUT
| volatility         | VOLATILE
| body               | None
| imports            |
| handler            | functions.hello_function
| runtime_version    | 3.9
| packages           | ['snowflake-snowpark-python']
| installed_packages | ['_libgcc_mutex==0.1','_openmp_mutex==5.1',...
+---------------------------------------------------------------------

-- Example 28758
snow object drop TYPE IDENTIFIER

-- Example 28759
snow object drop procedure "test_procedure()"

-- Example 28760
drop procedure test_procedure()
+--------------------------------------+
| status                               |
|--------------------------------------|
| TEST_PROCEDURE successfully dropped. |
+--------------------------------------+

-- Example 28761
public class StoredProcedure
extends Object

-- Example 28762
StoredProcedure sproc = session.sproc.registerTemporary(
   (Session session, Integer num) -> {
     int result = session.sql("select " + num).collect()[0].getInt(0);
     return result + 100;
   }, DataTypes.IntegerType, DataTypes.IntegerType
 );
 session.storedProcedure(sproc, 123).show();

-- Example 28763
public Optional<String> getName()

-- Example 28764
public class SProcRegistration
extends Object

-- Example 28765
StoredProcedure sp =
   session.sproc().registerTemporary((Session session, Integer num) -> num + 1,
     DataTypes.IntegerType, DataTypes.IntegerType);
 session.storedProcedure(sp, 1).show();

-- Example 28766
String name = "sproc";
 StoredProcedure sp =
   session.sproc().registerTemporary(name, (Session session, Integer num) -> num + 1,
     DataTypes.IntegerType, DataTypes.IntegerType);
 session.storedProcedure(sp, 1).show();
 session.storedProcedure(name, 1).show();

-- Example 28767
String name = "sproc";
 String stageName = "stage";
 StoredProcedure sp =
   session.sproc().registerPermanent(
     name,
     (Session session, Integer col1) -> col1 + 100,
     DataTypes.IntegerType,
     DataTypes.IntegerType,
     stageName,
     true
   );
  session.storedProcedure(sp, 1).show();
  session.storedProcedure(name, 1).show();

-- Example 28768
JavaSproc1<Integer, Integer> func =
   (Session session, Integer col1) -> col1 + 100;
 StoredProcedure sp =
   session.sproc().registerTemporary(func, DataTypes.IntegerType, DataTypes.IntegerType);
 int localResult = (Integer) session.sproc().runLocally(func, 1);
 DataFrame resultDF = session.storedProcedure(sp, 1);

-- Example 28769
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc0<?> sp,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28770
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc1<?,​?> sp,
                                         DataType input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28771
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc2<?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28772
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc3<?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28773
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc4<?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28774
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc5<?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28775
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc6<?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28776
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc7<?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28777
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc8<?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28778
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc9<?,​?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28779
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc10<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28780
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc11<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28781
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc12<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28782
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc13<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

-- Example 28783
public StoredProcedure registerPermanent​(String name,
                                         JavaSProc14<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> sp,
                                         DataType[] input,
                                         DataType output,
                                         String stageLocation,
                                         boolean isCallerMode)

