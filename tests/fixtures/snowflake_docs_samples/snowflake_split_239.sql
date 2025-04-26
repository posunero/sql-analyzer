-- Example 15993
session.sql("call minus_one(1)").collect()

-- Example 15994
[Row(MINUS_ONE(1)=0)]

-- Example 15995
# Import a file from your local machine as a dependency.
session.add_import("/<path>/my_file.txt")

# Or import a file that you uploaded to a stage as a dependency.
session.add_import("@my_stage/<path>/my_file.txt")

-- Example 15996
def read_file(name: str) -> str:
  import sys
  IMPORT_DIRECTORY_NAME = "snowflake_import_directory"
  import_dir = sys._xoptions[IMPORT_DIRECTORY_NAME]

  with open(import_dir + 'my_file.txt', 'r') as file:
  return file.read()

-- Example 15997
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import sproc
from snowflake.snowpark.files import SnowflakeFile
from snowflake.snowpark.types import StringType, IntegerType

@sproc(name="calc_size", is_permanent=True, stage_location="@my_procedures", replace=True, packages=["snowflake-snowpark-python"])
def calc_size(ignored_session: snowpark.Session, file_path: str) -> int:
  with SnowflakeFile.open(file_path) as f:
    s = f.read()
  return len(s);

-- Example 15998
file_size = session.sql("call calc_size(build_scoped_file_url('@my_stage', 'my_file.csv'))")

-- Example 15999
val session = Session.builder.configFile("my_config.properties").create

val sp = session.sproc.registerTemporary(
  (session: Session, num: Int) => num + 1
)

-- Example 16000
session.storedProcedure(sp, 1).show()

-- Example 16001
val session = Session.builder.configFile("my_config.properties").create

val procName: String = "add_two"
val tempSP: StoredProcedure =
  session.sproc.registerTemporary(
    procName,
    (session: Session, num: Int) => num + 2)

-- Example 16002
session.storedProcedure(procName, 1).show()

-- Example 16003
val session = Session.builder.configFile("my_config.properties").create

val procName: String = "add_hundred"
val stageName: String = "sproc_libs"

val sp: StoredProcedure =
  session.sproc.registerPermanent(
    procName,
    (session: Session, num: Int) => num + 100,
    stageName,
    true
  )

-- Example 16004
session.storedProcedure(procName, 1).show()

-- Example 16005
CREATE OR REPLACE PROCEDURE MYPROC(fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'MyJavaClass.run'
  AS
  $$
    import com.snowflake.snowpark_java.*;

    public class MyJavaClass {
      public String run(Session session, String fromTable, String toTable, int count) {
        session.table(fromTable).limit(count).write().saveAsTable(toTable);
        return "SUCCESS";
      }
    }
  $$;

-- Example 16006
CREATE FUNCTION my_udf(i NUMBER)
  RETURNS NUMBER
  LANGUAGE JAVA
  IMPORTS = ('@mystage/handlers/my_handler.jar')
  HANDLER = 'MyClass.myFunction'

-- Example 16007
Session session = Session.builder().configFile("my_config.properties").create();

StoredProcedure sp =
  session.sproc().registerTemporary(
    (Session spSession, Integer num) -> num + 1,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

-- Example 16008
session.storedProcedure(sp, 1).show();

-- Example 16009
Session session = Session.builder().configFile("my_config.properties").create();

String procName = "increment";

StoredProcedure tempSP =
  session.sproc().registerTemporary(
    procName,
    (Session session, Integer num) -> num + 1,
    DataTypes.IntegerType,
    DataTypes.IntegerType
  );

-- Example 16010
session.storedProcedure(procName, 1).show();

-- Example 16011
Session session = Session.builder().configFile("my_config.properties").create();

String procName = "add_hundred";
String stageName = "sproc_libs";

StoredProcedure sp =
    session.sproc().registerPermanent(
        procName,
        (Session session, Integer num) -> num + 100,
        DataTypes.IntegerType,
        DataTypes.IntegerType,
        stageName,
        true
    );

-- Example 16012
session.storedProcedure(procName, 1).show();

-- Example 16013
import pandas as pd
import snowflake.snowpark
import xgboost as xgb
from snowflake.snowpark.functions import sproc

session.add_packages("snowflake-snowpark-python", "pandas", "xgboost==1.5.0")

@sproc
def compute(session: snowflake.snowpark.Session) -> list:
  return [pd.__version__, xgb.__version__]

-- Example 16014
session.add_requirements("mydir/requirements.txt")

-- Example 16015
import pandas as pd
import snowflake.snowpark
import xgboost as xgb
from snowflake.snowpark.functions import sproc

@sproc(packages=["snowflake-snowpark-python", "pandas", "xgboost==1.5.0"])
def compute(session: snowflake.snowpark.Session) -> list:
  return [pd.__version__, xgb.__version__]

-- Example 16016
from snowflake.snowpark.functions import sproc
from snowflake.snowpark.types import IntegerType

add_one = sproc(lambda session, x: session.sql(f"select {x} + 1").collect()[0][0], return_type=IntegerType(), input_types=[IntegerType()], packages=["snowflake-snowpark-python"])

-- Example 16017
from snowflake.snowpark.functions import sproc
from snowflake.snowpark.types import IntegerType

add_one = sproc(lambda session, x: session.sql(f"select {x} + 1").collect()[0][0], return_type=IntegerType(), input_types=[IntegerType()], name="my_sproc", replace=True, packages=["snowflake-snowpark-python"])

-- Example 16018
import snowflake.snowpark
from snowflake.snowpark.functions import sproc

@sproc(name="minus_one", is_permanent=True, stage_location="@my_stage", replace=True, packages=["snowflake-snowpark-python"])
def minus_one(session: snowflake.snowpark.Session, x: int) -> int:
  return session.sql(f"select {x} - 1").collect()[0][0]

-- Example 16019
add_one(1)

-- Example 16020
2

-- Example 16021
session.call("minus_one", 1)

-- Example 16022
0

-- Example 16023
session.sql("call minus_one(1)").collect()

-- Example 16024
[Row(MINUS_ONE(1)=0)]

-- Example 16025
# Import a file from your local machine as a dependency.
session.add_import("/<path>/my_file.txt")

# Or import a file that you uploaded to a stage as a dependency.
session.add_import("@my_stage/<path>/my_file.txt")

-- Example 16026
def read_file(name: str) -> str:
  import sys
  IMPORT_DIRECTORY_NAME = "snowflake_import_directory"
  import_dir = sys._xoptions[IMPORT_DIRECTORY_NAME]

  with open(import_dir + 'my_file.txt', 'r') as file:
  return file.read()

-- Example 16027
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import sproc
from snowflake.snowpark.files import SnowflakeFile
from snowflake.snowpark.types import StringType, IntegerType

@sproc(name="calc_size", is_permanent=True, stage_location="@my_procedures", replace=True, packages=["snowflake-snowpark-python"])
def calc_size(ignored_session: snowpark.Session, file_path: str) -> int:
  with SnowflakeFile.open(file_path) as f:
    s = f.read()
  return len(s);

-- Example 16028
file_size = session.sql("call calc_size(build_scoped_file_url('@my_stage', 'my_file.csv'))")

-- Example 16029
val session = Session.builder.configFile("my_config.properties").create

val sp = session.sproc.registerTemporary(
  (session: Session, num: Int) => num + 1
)

-- Example 16030
session.storedProcedure(sp, 1).show()

-- Example 16031
val session = Session.builder.configFile("my_config.properties").create

val procName: String = "add_two"
val tempSP: StoredProcedure =
  session.sproc.registerTemporary(
    procName,
    (session: Session, num: Int) => num + 2)

-- Example 16032
session.storedProcedure(procName, 1).show()

-- Example 16033
val session = Session.builder.configFile("my_config.properties").create

val procName: String = "add_hundred"
val stageName: String = "sproc_libs"

val sp: StoredProcedure =
  session.sproc.registerPermanent(
    procName,
    (session: Session, num: Int) => num + 100,
    stageName,
    true
  )

-- Example 16034
session.storedProcedure(procName, 1).show()

-- Example 16035
WITH <name> AS PROCEDURE ([ <arg_name> <arg_data_type> ]) [ , ... ] )
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE { SCALA | JAVA }
  RUNTIME_VERSION = '<scala_or_java_runtime_version>'
  PACKAGES = ( 'com.snowflake:snowpark:<version>' [, '<package_name_and_version>' ...] )
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<fully_qualified_method_name>'
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ AS '<procedure_definition>' ]
  [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
CALL <name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 16036
WITH <name> AS PROCEDURE ([ <arg_name> <arg_data_type> ]) [ , ... ] )
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE { SCALA | JAVA }
  RUNTIME_VERSION = '<scala_or_java_runtime_version>'
  PACKAGES = ( 'com.snowflake:snowpark:<version>' [, '<package_name_and_version>' ...] )
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<fully_qualified_method_name>'
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
CALL <name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 16037
WITH <name> AS PROCEDURE ([ <arg_name> <arg_data_type> ]) [ , ... ] )
  RETURNS <result_data_type> [ [ NOT ] NULL ]
  LANGUAGE JAVASCRIPT
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  AS '<procedure_definition>'
  [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
CALL <name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 16038
WITH <name> AS PROCEDURE ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE PYTHON
  RUNTIME_VERSION = '<python_version>'
  PACKAGES = ( 'snowflake-snowpark-python[==<version>]'[, '<package_name>[==<version>]' ... ])
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<function_name>'
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
  AS '<procedure_definition>'
CALL <name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 16039
WITH <name> AS PROCEDURE ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS { <result_data_type> [ [ NOT ] NULL ] | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE PYTHON
  RUNTIME_VERSION = '<python_version>'
  PACKAGES = ( 'snowflake-snowpark-python[==<version>]'[, '<package_name>[==<version>]' ... ])
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [, '<stage_path_and_file_name_to_read>' ...] ) ]
  HANDLER = '<module_file_name>.<function_name>'
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
CALL <name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 16040
WITH <name> AS PROCEDURE ([ <arg_name> <arg_data_type> ]) [ , ... ] )
  RETURNS { <result_data_type> | TABLE ( [ <col_name> <col_data_type> [ , ... ] ] ) }
  LANGUAGE SQL
  [ { CALLED ON NULL INPUT | { RETURNS NULL ON NULL INPUT | STRICT } } ]
  AS '<procedure_definition>'
  [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
CALL <name> ( [ [ <arg_name> => ] <arg> , ... ] )
  [ INTO :<snowflake_scripting_variable> ]

-- Example 16041
WITH get_top_sales() AS PROCEDURE
  RETURNS TABLE (sales_date DATE, quantity NUMBER)
  ...
CALL get_top_sales();

-- Example 16042
WITH get_top_sales() AS PROCEDURE
  ...
  RETURNS TABLE ()
CALL get_top_sales();

-- Example 16043
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE(g GEOGRAPHY)
  ...

-- Example 16044
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE(g GEOGRAPHY)
  ...
CALL test_return_geography_table_1();

-- Example 16045
Stored procedure execution error: data type of returned table does not match expected returned table type

-- Example 16046
CREATE OR REPLACE PROCEDURE test_return_geography_table_1()
  RETURNS TABLE()
  ...

-- Example 16047
WITH test_return_geography_table_1() AS PROCEDURE
  RETURNS TABLE()
  ...
CALL test_return_geography_table_1();

-- Example 16048
WITH proc3 AS PROCEDURE ()
  RETURNS VARCHAR
  LANGUAGE javascript
  AS
  $$
  var rs = snowflake.execute( { sqlText:
      `INSERT INTO table1 ("column 1")
          SELECT 'value 1' AS "column 1" ;`
      } );
  return 'Done.';
  $$
CALL proc3();

-- Example 16049
SELECT * FROM information_schema.packages WHERE language = '<language>';

-- Example 16050
domain:package_name:version

-- Example 16051
PACKAGES = ('com.snowflake:snowpark:latest')

-- Example 16052
package_name[==version]

-- Example 16053
PACKAGES = ('snowflake-snowpark-python', 'spacy==2.3.5')

-- Example 16054
domain:package_name:version

-- Example 16055
PACKAGES = ('com.snowflake:snowpark:latest')

-- Example 16056
WITH myproc AS PROCEDURE()
  ...
  HANDLER = 'run'
  AS
  $$
  def run(session):
    ...
  $$
CALL myproc();

-- Example 16057
WITH myproc AS PROCEDURE()
  ...
  IMPORTS = ('@mystage/my_py_file.py')
  HANDLER = 'my_py_file.run'
CALL myproc();

-- Example 16058
com.my_company.my_package.MyClass.myMethod

-- Example 16059
com.my_company.my_package

