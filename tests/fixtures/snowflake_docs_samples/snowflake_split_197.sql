-- Example 13179
from snowflake.snowpark import Session
connection_parameters = {
  "account": "<your snowflake account>",
  "user": "<your snowflake user>",
  "role":"<your snowflake role>",
  "database":"<your snowflake database>",
  "schema":"<your snowflake schema",
  "warehouse":"<your snowflake warehouse>",
  "authenticator":"externalbrowser"
}
session = Session.builder.configs(connection_parameters).create()

-- Example 13180
new_session.close()

-- Example 13181
import com.snowflake.snowpark_java.*;

-- Example 13182
import com.snowflake.snowpark_java.types.*;

-- Example 13183
import com.snowflake.snowpark_java.*;

...
// Get a SessionBuilder object.
SessionBuilder builder = Session.builder();

-- Example 13184
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATE_KEY_FILE = </path/to/private_key_file.p8>
PRIVATE_KEY_FILE_PWD = <if the private key is encrypted, set this to the passphrase for decrypting the key>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 13185
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATEKEY = <unencrypted_private_key_from_the_private_key_file>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 13186
// Create a new session, using the connection properties
// specified in a file.
Session session = Session.builder().configFile("/path/to/properties/file").create();

-- Example 13187
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

-- Example 13188
// Close the session, cancelling any queries that are currently running, and
// preventing the use of this Session object for performing any subsequent queries.
session.close();

-- Example 13189
import com.snowflake.snowpark._

-- Example 13190
import com.snowflake.snowpark.functions._

-- Example 13191
import com.snowflake.snowpark.types._

-- Example 13192
import com.snowflake.snowpark._

...
// Get a SessionBuilder object.
val builder = Session.builder

-- Example 13193
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATE_KEY_FILE = </path/to/private_key_file.p8>
PRIVATE_KEY_FILE_PWD = <if the private key is encrypted, set this to the passphrase for decrypting the key>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 13194
# profile.properties file (a text file)
URL = https://<account_identifier>.snowflakecomputing.com
USER = <username>
PRIVATEKEY = <unencrypted_private_key_from_the_private_key_file>
ROLE = <role_name>
WAREHOUSE = <warehouse_name>
DB = <database_name>
SCHEMA = <schema_name>

-- Example 13195
// Create a new session, using the connection properties
// specified in a file.
val session = Session.builder.configFile("/path/to/properties/file").create

-- Example 13196
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

-- Example 13197
// Close the session, cancelling any queries that are currently running, and
// preventing the use of this Session object for performing any subsequent queries.
session.close();

-- Example 13198
{ DESC | DESCRIBE } [ { API | CATALOG | EXTERNAL ACCESS | NOTIFICATION | SECURITY | STORAGE } ] INTEGRATION <name>

-- Example 13199
DESC INTEGRATION my_int;

-- Example 13200
ALTER CONNECTION [ IF EXISTS ] <name> ENABLE FAILOVER TO ACCOUNTS <organization_name>.<account_name> [ , <organization_name>.<account_name> ... ]
                        [ IGNORE EDITION CHECK ]

ALTER CONNECTION [ IF EXISTS ] <name> DISABLE FAILOVER [ TO ACCOUNTS <organization_name>.<account_name> [ , <organization_name>.<account_name> ... ] ]

ALTER CONNECTION [ IF EXISTS ] <name> PRIMARY

ALTER CONNECTION [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER CONNECTION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 13201
ALTER CONNECTION myconnection ENABLE FAILOVER TO ACCOUNTS myorg.myaccount2, myorg.myaccount3;

-- Example 13202
ALTER CONNECTION myconnection SET COMMENT = 'New comment for connection';

-- Example 13203
ALTER CONNECTION myconnection PRIMARY;

-- Example 13204
DROP CONNECTION [ IF EXISTS ] <name>

-- Example 13205
SHOW CONNECTIONS LIKE 't2%';


DROP CONNECTION t2;


SHOW CONNECTIONS LIKE 't2%';

-- Example 13206
DROP CONNECTION IF EXISTS t2;

-- Example 13207
DROP CONNECTION [ IF EXISTS ] <name>

-- Example 13208
SHOW CONNECTIONS LIKE 't2%';


DROP CONNECTION t2;


SHOW CONNECTIONS LIKE 't2%';

-- Example 13209
DROP CONNECTION IF EXISTS t2;

-- Example 13210
SELECT ...
FROM ...
  {
   AT( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> | STREAM => '<name>' } ) |
   BEFORE( STATEMENT => <id> )
  }
[ ... ]

-- Example 13211
Error: statement <query_id> not found

-- Example 13212
AT ( TIMESTAMP => '2024-06-05 12:30:00'::TIMESTAMP_LTZ )

AT ( TIMESTAMP => '2024-06-05 12:30:00'::TIMESTAMP )

AT ( TIMESTAMP => '2024-06-05 12:30:00' )

-- Example 13213
CREATE OR REPLACE TABLE tt1 (c1 INT, c2 INT);
INSERT INTO tt1 VALUES(1,2);
INSERT INTO tt1 VALUES(2,3);

-- Example 13214
SHOW TERSE TABLES LIKE 'tt1';

-- Example 13215
+-------------------------------+------+-------+---------------+----------------+
| created_on                    | name | kind  | database_name | schema_name    |
|-------------------------------+------+-------+---------------+----------------|
| 2024-06-05 15:25:35.557 -0700 | TT1  | TABLE | TRAVEL_DB     | TRAVEL_SCHEMA  |
+-------------------------------+------+-------+---------------+----------------+

-- Example 13216
INSERT INTO tt1 VALUES(3,4);

-- Example 13217
SELECT * FROM tt1 at(TIMESTAMP => '2024-06-05 15:29:00'::TIMESTAMP);

-- Example 13218
000707 (02000): Time travel data is not available for table TT1. The requested time is either beyond the allowed time travel period or before the object creation time.

-- Example 13219
SELECT * FROM tt1 at(TIMESTAMP => '2024-06-05 15:29:00'::TIMESTAMP_LTZ);

-- Example 13220
+----+----+
| C1 | C2 |
|----+----|
|  1 |  2 |
|  2 |  3 |
+----+----+

-- Example 13221
SELECT * FROM tt1 at(TIMESTAMP => '2024-06-05 15:31:00'::TIMESTAMP_LTZ);

-- Example 13222
+----+----+
| C1 | C2 |
|----+----|
|  1 |  2 |
|  2 |  3 |
|  3 |  4 |
+----+----+

-- Example 13223
WITH mycte AS
  (SELECT mytable.* FROM mytable)
SELECT * FROM mycte AT(TIMESTAMP => '2024-03-13 13:56:09.553 +0100'::TIMESTAMP_TZ);

-- Example 13224
WITH mycte AS
  (SELECT * FROM mytable AT(TIMESTAMP => '2024-03-13 13:56:09.553 +0100'::TIMESTAMP_TZ))
SELECT * FROM mycte;

-- Example 13225
Time travel data is not available for table <tablename>

-- Example 13226
... AT(TIMESTAMP => '2018-07-27 12:00:00')               -- fails
... AT(TIMESTAMP => '2018-07-27 12:00:00'::TIMESTAMP)    -- succeeds

-- Example 13227
SELECT * FROM my_table AT(TIMESTAMP => 'Wed, 26 Jun 2024 09:20:00 -0700'::TIMESTAMP_LTZ);

-- Example 13228
SELECT * FROM my_table AT(TIMESTAMP => TO_TIMESTAMP(1432669154242, 3));

-- Example 13229
SELECT * FROM my_table AT(OFFSET => -60*5) AS T WHERE T.flag = 'valid';

-- Example 13230
SELECT * FROM my_table BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 13231
SELECT oldt.* ,newt.*
  FROM my_table BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726') AS oldt
    FULL OUTER JOIN my_table AT(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726') AS newt
    ON oldt.id = newt.id
  WHERE oldt.id IS NULL OR newt.id IS NULL;

-- Example 13232
SELECT *
  FROM db1.public.htt1
    AT(TIMESTAMP => '2024-06-05 17:50:00'::TIMESTAMP_LTZ) h
    JOIN db1.public.tt1
    AT(TIMESTAMP => '2024-06-05 17:50:00'::TIMESTAMP_LTZ) t
    ON h.c1=t.c1;

-- Example 13233
SHOW [ TERSE ] SCHEMAS
  [ HISTORY ]
  [ LIKE '<pattern>' ]
  [ IN { ACCOUNT | DATABASE [ <db_name> ] | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> } ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ]
  [ WITH PRIVILEGES <object_privilege> [ , <object_privilege> [ , ... ] ] ]

-- Example 13234
SHOW SCHEMAS IN APPLICATION my_app;
SHOW SCHEMAS IN DATABASE SNOWFLAKE;

-- Example 13235
+-----+-------+-----+-----------+-----+
| ... | name  | ... | owner     | ... |
+-----+-------+-----+-----------+-----+
| ... | LOCAL | ... | SNOWFLAKE | ... |
+-----+-------+-----+-----------+-----+

-- Example 13236
SHOW SCHEMAS;

-- Example 13237
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+-----------------+--------+-------------------+
| created_on                      | name               | is_default | is_current | database_name | owner  | comment                                                   | options | retention_time | owner_role_type | budget | OBJECT_VISIBILITY |
|---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+-----------------+--------+-------------------+
| Fri, 13 May 2016 17:58:37 -0700 | INFORMATION_SCHEMA | N          | N          | MYTESTDB      |        | Views describing the contents of schemas in this database |         |              1 | ROLE            | NULL   | NULL              |
| Wed, 25 Feb 2015 16:16:54 -0800 | PUBLIC             | N          | Y          | MYTESTDB      | PUBLIC |                                                           |         |              1 | ROLE            | NULL   | NULL              |
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+-----------------+--------+-------------------+

-- Example 13238
SHOW SCHEMAS HISTORY;

-- Example 13239
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+---------------------------------+-----------------+----------+-------------------+
| created_on                      | name               | is_default | is_current | database_name | owner  | comment                                                   | options | retention_time | dropped_on                      | owner_role_type | budget   | OBJECT_VISIBILITY |
|---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+---------------------------------+-----------------+----------+-------------------+
| Fri, 13 May 2016 17:59:50 -0700 | INFORMATION_SCHEMA | N          | N          | MYTESTDB      |        | Views describing the contents of schemas in this database |         |              1 | NULL                            |                 | NULL     | NULL              |
| Wed, 25 Feb 2015 16:16:54 -0800 | PUBLIC             | N          | Y          | MYTESTDB      | PUBLIC |                                                           |         |              1 | NULL                            | ROLE            | NULL     | NULL              |
| Tue, 17 Mar 2015 16:42:29 -0700 | MYSCHEMA           | N          | N          | MYTESTDB      | PUBLIC |                                                           |         |              1 | Fri, 13 May 2016 17:25:32 -0700 | ROLE            | MYBUDGET | NULL              |
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+---------------------------------+-----------------+----------+-------------------+

-- Example 13240
SHOW SCHEMAS WITH PRIVILEGES USAGE;

-- Example 13241
+-------------------------------+----------------+------------+------------+-----------------------------------------------------------+--------------+---------+---------+----------------+-----------------+--------+-------------------+
| created_on                    | name           | is_default | is_current | database_name                                             | owner        | comment | options | retention_time | owner_role_type | budget | OBJECT_VISIBILITY |
|-------------------------------+----------------+------------+------------+-----------------------------------------------------------+--------------+---------+---------+----------------+-----------------+--------+-------------------+
| 2023-01-27 15:01:12.940 -0800 | PUBLIC         | N          | N          | BOOKS_DB                                                  | DATA_ADMIN   |         |         | 1              | ROLE            | NULL   | NULL              |
| 2023-09-15 15:22:51.164 -0700 | PUBLIC         | N          | N          | TEST_DB                                                   | ACCOUNTADMIN |         |         | 4              | ROLE            | NULL   | NULL              |
| 2023-01-13 10:58:49.584 -0800 | ACCOUNT_USAGE  | N          | N          | SNOWFLAKE                                                 |              |         |         | 1              |                 | NULL   | NULL              |
+-------------------------------+----------------+------------+------------+-----------------------------------------------------------+--------------+---------+---------+----------------+-----------------+--------+-------------------+

-- Example 13242
ALTER TABLE <table_name> ALTER COLUMN <column_name> SET DEFAULT <new_sequence>.nextval;

-- Example 13243
ALTER TABLE <name> RESUME RECLUSTER

-- Example 13244
CREATE OR REPLACE DATABASE staging_sales CLONE sales;

DROP TABLE sales.public.t_sales;

ALTER TABLE sales.public.t_sales_20170522 RENAME TO sales.public.t_sales;

-- Example 13245
002002 (42710): None: SQL compilation error: Object 'T_SALES' already exists.

