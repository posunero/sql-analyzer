-- Example 30189
gunzip snowflake_linux_x8664_odbc-<version>.tgz

-- Example 30190
tar -xvf snowflake_linux_x8664_odbc-<version>.tar

-- Example 30191
yum install snowflake-odbc-<version>.x86_64.rpm

-- Example 30192
sudo dpkg -i snowflake-odbc-<version>.x86_64.deb

-- Example 30193
sudo apt-get install -f

-- Example 30194
./iodbc_setup.sh

-- Example 30195
./unixodbc_setup.sh

-- Example 30196
ErrorMessagesPath=<path>/ErrorMessages/
LogPath=/tmp/
ODBCInstLib=<driver_manager_path>
CABundleFile=<path>/lib/cacert.pem
ANSIENCODING=UTF-8

-- Example 30197
[ODBC Drivers]
SnowflakeDSIIDriver=Installed

[SnowflakeDSIIDriver]
APILevel=1
ConnectFunctions=YYY
Description=Snowflake DSII
Driver=/<path>/lib/libSnowflake.so
DriverODBCVer=03.52
SQLLevel=1

-- Example 30198
[ODBC Data Sources]
testodbc1 = SnowflakeDSIIDriver
testodbc2 = SnowflakeDSIIDriver


[testodbc1]
Driver      = /usr/jsmith/snowflake_odbc/lib/libSnowflake.so
Description =
server      = myorganization-myaccount.snowflakecomputing.com
role        = sysadmin


[testodbc2]
Driver      = /usr/jsmith/snowflake_odbc/lib/libSnowflake.so
Description =
server      = xy12345.snowflakecomputing.com
role        = analyst
database    = sales
warehouse   = analysis

-- Example 30199
iodbctest "DSN=testodbc2;UID=mary;PWD=password"

-- Example 30200
iODBC Demonstration program
This program shows an interactive SQL processor
Driver Manager: 03.52.0709.0909
Driver: 2.12.70 (Snowflake)

SQL>

-- Example 30201
isql -v testodbc2 mary <password>

-- Example 30202
Dec 14 22:57:50 INFO  2022078208 Driver::LogVersions: SDK Version: 09.04.09.1013
Dec 14 22:57:50 INFO  2022078208 Driver::LogVersions: DSII Version: 2.12.36
Dec 14 22:57:50 INFO  2022078208 SFConnection::connect: Tracing level: 4

+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL>

-- Example 30203
metals

-- Example 30204
mkdir snowpark_projects

-- Example 30205
scalaVersion := "2.12.13"

-- Example 30206
libraryDependencies += "com.snowflake" % "snowpark" % "1.15.0"

-- Example 30207
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._

object Main {
  def main(args: Array[String]): Unit = {
    // Replace the <placeholders> below.
    val configs = Map (
      "URL" -> "https://<account_identifier>.snowflakecomputing.com:443",
      "USER" -> "<user name>",
      "PASSWORD" -> "<password>",
      "ROLE" -> "<role name>",
      "WAREHOUSE" -> "<warehouse name>",
      "DB" -> "<database name>",
      "SCHEMA" -> "<schema name>"
    )
    val session = Session.builder.configs(configs).create
    session.sql("show tables").show()
  }
}

-- Example 30208
Run session not started

-- Example 30209
scalaVersion := "2.12.13"

-- Example 30210
libraryDependencies += "com.snowflake" % "snowpark" % "1.15.0"

-- Example 30211
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._

object Main {
  def main(args: Array[String]): Unit = {
    // Replace the <placeholders> below.
    val configs = Map (
      "URL" -> "https://<account_identifier>.snowflakecomputing.com:443",
      "USER" -> "<user name>",
      "PASSWORD" -> "<password>",
      "ROLE" -> "<role name>",
      "WAREHOUSE" -> "<warehouse name>",
      "DB" -> "<database name>",
      "SCHEMA" -> "<schema name>"
    )
    val session = Session.builder.configs(configs).create
    session.sql("show tables").show()
  }
}

-- Example 30212
mkdir snowpark_project
cd snowpark_project

-- Example 30213
sbt new scala/hello-world.g8

-- Example 30214
scalaVersion := "2.12.13"

-- Example 30215
libraryDependencies += "com.snowflake" % "snowpark" % "1.15.0"

-- Example 30216
Compile/console/scalacOptions += "-Yrepl-class-based"
Compile/console/scalacOptions += "-Yrepl-outdir"
Compile/console/scalacOptions += "repl_classes"

-- Example 30217
import com.snowflake.snowpark._
import com.snowflake.snowpark.functions._

object Main {
  def main(args: Array[String]): Unit = {
    // Replace the <placeholders> below.
    val configs = Map (
      "URL" -> "https://<account_identifier>.snowflakecomputing.com:443",
      "USER" -> "<user name>",
      "PASSWORD" -> "<password>",
      "ROLE" -> "<role name>",
      "WAREHOUSE" -> "<warehouse name>",
      "DB" -> "<database name>",
      "SCHEMA" -> "<schema name>"
    )
    val session = Session.builder.configs(configs).create
    session.sql("show tables").show()
  }
}

-- Example 30218
sbt "runMain Main"

-- Example 30219
scalaVersion := "2.12.13"

-- Example 30220
libraryDependencies += "com.snowflake" % "snowpark" % "1.15.0"

-- Example 30221
<dependencies>
  ...
  <dependency>
    <groupId>com.snowflake</groupId>
    <artifactId>snowpark</artifactId>
    <version>1.15.0</version>
  </dependency>
  ...
</dependencies>

-- Example 30222
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 30223
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 30224
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 30225
gpg: keyserver receive failed: Server indicated a failure

-- Example 30226
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 30227
gpg --verify snowpark-1.15.0-bundle.tar.gz.asc snowpark-1.15.0-bundle.tar.gz

-- Example 30228
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 30229
SELECT ...
FROM ...
[ ORDER BY ... ]
LIMIT <count> [ OFFSET <start> ]
[ ... ]

-- Example 30230
SELECT ...
FROM ...
[ ORDER BY ... ]
[ OFFSET <start> ] [ { ROW | ROWS } ] FETCH [ { FIRST | NEXT } ] <count> [ { ROW | ROWS } ] [ ONLY ]
[ ... ]

-- Example 30231
select c1 from testtable;

+------+
|   C1 |
|------|
|    1 |
|    2 |
|    3 |
|   20 |
|   19 |
|   18 |
|    1 |
|    2 |
|    3 |
|    4 |
| NULL |
|   30 |
| NULL |
+------+

select c1 from testtable limit 3 offset 3;

+----+
| C1 |
|----|
| 20 |
| 19 |
| 18 |
+----+

select c1 from testtable order by c1;

+------+
|   C1 |
|------|
|    1 |
|    1 |
|    2 |
|    2 |
|    3 |
|    3 |
|    4 |
|   18 |
|   19 |
|   20 |
|   30 |
| NULL |
| NULL |
+------+

select c1 from testtable order by c1 limit 3 offset 3;

+----+
| ID |
|----|
|  2 |
|  3 |
|  3 |
+----+

-- Example 30232
CREATE TABLE demo1 (i INTEGER);
INSERT INTO demo1 (i) VALUES (1), (2);

-- Example 30233
SELECT * FROM demo1 ORDER BY i LIMIT NULL OFFSET NULL;
+---+
| I |
|---|
| 1 |
| 2 |
+---+

-- Example 30234
SELECT * FROM demo1 ORDER BY i LIMIT '' OFFSET '';
+---+
| I |
|---|
| 1 |
| 2 |
+---+

-- Example 30235
SELECT * FROM demo1 ORDER BY i LIMIT $$$$ OFFSET $$$$;
+---+
| I |
|---|
| 1 |
| 2 |
+---+

-- Example 30236
{
    "Flood": flood_date_array::VARIANT,
    "Earthquake": earthquake_date_array::VARIANT,
    ...
}

-- Example 30237
[
    {
        "Event_ID": 54::VARIANT,
        "Type": "Earthquake"::VARIANT,
        "Magnitude": 7.4::VARIANT,
        "Timestamp": "2018-06-09 12:32:15"::TIMESTAMP_LTZ::VARIANT
        ...
    }::VARIANT,
    {
        "Event_ID": 55::VARIANT,
        "Type": "Tornado"::VARIANT,
        "Maximum_wind_speed": 186::VARIANT,
        "Timestamp": "2018-07-01 09:42:55"::TIMESTAMP_LTZ::VARIANT
        ...
    }::VARIANT
]

-- Example 30238
CREATE TABLE my_table (my_variant_column VARIANT);
COPY INTO my_table ... FILE FORMAT = (TYPE = 'JSON') ...

-- Example 30239
INSERT INTO my_table (my_variant_column) SELECT PARSE_JSON('{...}');

-- Example 30240
ARRAY_AGG( [ DISTINCT ] <expr1> ) [ WITHIN GROUP ( <orderby_clause> ) ]

-- Example 30241
ARRAY_AGG( [ DISTINCT ] <expr1> )
  [ WITHIN GROUP ( <orderby_clause> ) ]
  OVER ( [ PARTITION BY <expr2> ] [ ORDER BY <expr3> [ { ASC | DESC } ] ] [ <window_frame> ] )

-- Example 30242
SELECT ARRAY_AGG(DISTINCT O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY) ...;

-- Example 30243
SELECT ARRAY_AGG(DISTINCT O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERSTATUS) ...;

-- Example 30244
SQL compilation error: [ORDERS.O_ORDERSTATUS] is not a valid order by expression

-- Example 30245
CREATE TABLE orders (
    o_orderkey INTEGER,         -- unique ID for each order.
    o_clerk VARCHAR,            -- identifies which clerk is responsible.
    o_totalprice NUMBER(12, 2), -- total price.
    o_orderstatus CHAR(1)       -- 'F' = Fulfilled (sent); 
                                -- 'O' = 'Ordered but not yet Fulfilled'.
    );

INSERT INTO orders (o_orderkey, o_orderstatus, o_clerk, o_totalprice) 
  VALUES 
    ( 32123, 'O', 'Clerk#000000321',     321.23),
    ( 41445, 'F', 'Clerk#000000386', 1041445.00),
    ( 55937, 'O', 'Clerk#000000114', 1055937.00),
    ( 67781, 'F', 'Clerk#000000521', 1067781.00),
    ( 80550, 'O', 'Clerk#000000411', 1080550.00),
    ( 95808, 'F', 'Clerk#000000136', 1095808.00),
    (101700, 'O', 'Clerk#000000220', 1101700.00),
    (103136, 'F', 'Clerk#000000508', 1103136.00);

-- Example 30246
SELECT O_ORDERKEY AS order_keys
  FROM orders
  WHERE O_TOTALPRICE > 450000
  ORDER BY O_ORDERKEY;
+------------+
| ORDER_KEYS |
|------------|
|      41445 |
|      55937 |
|      67781 |
|      80550 |
|      95808 |
|     101700 |
|     103136 |
+------------+

-- Example 30247
SELECT ARRAY_AGG(O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY ASC)
  FROM orders 
  WHERE O_TOTALPRICE > 450000;
+--------------------------------------------------------------+
| ARRAY_AGG(O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY ASC) |
|--------------------------------------------------------------|
| [                                                            |
|   41445,                                                     |
|   55937,                                                     |
|   67781,                                                     |
|   80550,                                                     |
|   95808,                                                     |
|   101700,                                                    |
|   103136                                                     |
| ]                                                            |
+--------------------------------------------------------------+

-- Example 30248
SELECT ARRAY_AGG(DISTINCT O_ORDERSTATUS) WITHIN GROUP (ORDER BY O_ORDERSTATUS ASC)
  FROM orders 
  WHERE O_TOTALPRICE > 450000
  ORDER BY O_ORDERSTATUS ASC;
+-----------------------------------------------------------------------------+
| ARRAY_AGG(DISTINCT O_ORDERSTATUS) WITHIN GROUP (ORDER BY O_ORDERSTATUS ASC) |
|-----------------------------------------------------------------------------|
| [                                                                           |
|   "F",                                                                      |
|   "O"                                                                       |
| ]                                                                           |
+-----------------------------------------------------------------------------+

-- Example 30249
SELECT 
    O_ORDERSTATUS, 
    ARRAYAGG(O_CLERK) WITHIN GROUP (ORDER BY O_TOTALPRICE DESC)
  FROM orders 
  WHERE O_TOTALPRICE > 450000
  GROUP BY O_ORDERSTATUS
  ORDER BY O_ORDERSTATUS DESC;
+---------------+-------------------------------------------------------------+
| O_ORDERSTATUS | ARRAYAGG(O_CLERK) WITHIN GROUP (ORDER BY O_TOTALPRICE DESC) |
|---------------+-------------------------------------------------------------|
| O             | [                                                           |
|               |   "Clerk#000000220",                                        |
|               |   "Clerk#000000411",                                        |
|               |   "Clerk#000000114"                                         |
|               | ]                                                           |
| F             | [                                                           |
|               |   "Clerk#000000508",                                        |
|               |   "Clerk#000000136",                                        |
|               |   "Clerk#000000521",                                        |
|               |   "Clerk#000000386"                                         |
|               | ]                                                           |
+---------------+-------------------------------------------------------------+

-- Example 30250
CREATE OR REPLACE TABLE array_data AS (
WITH data AS (
  SELECT 1 a, [1,3,2,4,7,8,10] b
  UNION ALL
  SELECT 2, [1,3,2,4,7,8,10]
  )
SELECT 'Ord'||a o_orderkey, 'c'||value o_clerk, index
  FROM data, TABLE(FLATTEN(b))
);

-- Example 30251
SELECT o_orderkey,
    ARRAY_AGG(o_clerk) OVER(PARTITION BY o_orderkey ORDER BY o_orderkey
      ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS result
  FROM array_data;

-- Example 30252
+------------+---------+
| O_ORDERKEY | RESULT  |
|------------+---------|
| Ord1       | [       |
|            |   "c1"  |
|            | ]       |
| Ord1       | [       |
|            |   "c1", |
|            |   "c3"  |
|            | ]       |
| Ord1       | [       |
|            |   "c1", |
|            |   "c3", |
|            |   "c2"  |
|            | ]       |
| Ord1       | [       |
|            |   "c1", |
|            |   "c3", |
|            |   "c2", |
|            |   "c4"  |
|            | ]       |
| Ord1       | [       |
|            |   "c3", |
|            |   "c2", |
|            |   "c4", |
|            |   "c7"  |
|            | ]       |
| Ord1       | [       |
|            |   "c2", |
|            |   "c4", |
|            |   "c7", |
|            |   "c8"  |
|            | ]       |
| Ord1       | [       |
|            |   "c4", |
|            |   "c7", |
|            |   "c8", |
|            |   "c10" |
|            | ]       |
| Ord2       | [       |
|            |   "c1"  |
|            | ]       |
| Ord2       | [       |
|            |   "c1", |
|            |   "c3"  |
|            | ]       |
...

-- Example 30253
copy into home_sales(city, zip, sale_date, price)
   from (select t.$1, t.$2, t.$6, t.$7 from @mystage/sales.csv.gz t)
   FILE_FORMAT = (FORMAT_NAME = mycsvformat);

-- Example 30254
copy into home_sales(city, zip, sale_date, price)
   from (select SUBSTR(t.$2,4), t.$1, t.$5, t.$4 from @mystage t)
   FILE_FORMAT = (FORMAT_NAME = mycsvformat);

-- Example 30255
snowflake,2.8,2016-10-5
warehouse,-12.3,2017-01-23

