-- Example 8423
$ SNOWSQL_DOWNLOAD_DIR=/var/shared snowsql -h

-- Example 8424
$ snowsql --bootstrap-version

-- Example 8425
$ curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/linux_x86_64/snowsql-<version>-linux_x86_64.bash

-- Example 8426
$ curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/linux_x86_64/snowsql-<version>-linux_x86_64.bash

-- Example 8427
$ curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash

-- Example 8428
$ curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash

-- Example 8429
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 2A3149C82551A34A

-- Example 8430
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 8431
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 8432
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 8433
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 8434
gpg: keyserver receive failed: Server indicated a failure

-- Example 8435
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 8436
# If you prefer to use curl to download the signature file, run this command:
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash.sig

# Verify the package signature.
gpg --verify snowsql-1.3.3-linux_x86_64.bash.sig snowsql-1.3.3-linux_x86_64.bash

-- Example 8437
# If you prefer to use curl to download the signature file, run this command:
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash.sig

# Verify the package signature.
gpg --verify snowsql-1.3.3-linux_x86_64.bash.sig snowsql-1.3.3-linux_x86_64.bash

-- Example 8438
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 8439
gpg --delete-key "Snowflake Computing"

-- Example 8440
bash snowsql-linux_x86_64.bash

-- Example 8441
SNOWSQL_DEST=~/bin SNOWSQL_LOGIN_SHELL=~/.profile bash snowsql-linux_x86_64.bash

-- Example 8442
snowsql -v

-- Example 8443
Version: 1.3.1

-- Example 8444
snowsql -v 1.3.0

-- Example 8445
rpm -i <package_name>

-- Example 8446
SNOWSQL_DOWNLOAD_DIR=/var/shared snowsql -h

-- Example 8447
snowsql --bootstrap-version

-- Example 8448
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/darwin_x86_64/snowsql-<version>-darwin_x86_64.pkg

-- Example 8449
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/darwin_x86_64/snowsql-<version>-darwin_x86_64.pkg

-- Example 8450
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/darwin_x86_64/snowsql-1.3.3-darwin_x86_64.pkg

-- Example 8451
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/darwin_x86_64/snowsql-1.3.3-darwin_x86_64.pkg

-- Example 8452
installer -pkg snowsql-darwin_x86_64.pkg -target CurrentUserHomeDirectory

-- Example 8453
snowsql -v

-- Example 8454
Version: 1.3.0

-- Example 8455
snowsql -v 1.3.1

-- Example 8456
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

-- Example 8457
brew install --cask snowflake-snowsql

-- Example 8458
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

-- Example 8459
SNOWSQL_DOWNLOAD_DIR=/var/shared snowsql -h

-- Example 8460
snowsql --bootstrap-version

-- Example 8461
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/windows_x86_64/snowsql-<version>-windows_x86_64.msi

-- Example 8462
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/windows_x86_64/snowsql-<version>-windows_x86_64.msi

-- Example 8463
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/windows_x86_64/snowsql-1.3.3-windows_x86_64.msi

-- Example 8464
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/windows_x86_64/snowsql-1.3.3-windows_x86_64.msi

-- Example 8465
C:\Users\<username> msiexec /i snowsql-windows_x86_64.msi /q

-- Example 8466
snowsql -v

-- Example 8467
Version: 1.3.1

-- Example 8468
snowsql -v 1.3.0

-- Example 8469
snowsql -v

-- Example 8470
Version: 1.3.1

-- Example 8471
snowsql -o noup=False

-- Example 8472
$ snowsql -v

  Version: 1.3.1

-- Example 8473
$ snowsql --versions

 1.3.1
 1.3.0

-- Example 8474
$ snowsql -v 1.3.0

  Installing version: 1.3.0 [####################################]  100%

-- Example 8475
$ snowsql -v 1.3.0

-- Example 8476
snowsql -o repository_base_url=https://sfc-repo.azure.snowflakecomputing.com/snowsql

-- Example 8477
repository_base_url=https://sfc-repo.azure.snowflakecomputing.com/snowsql

-- Example 8478
repository_base_url=https://sfc-repo.azure.snowflakecomputing.com/snowsql

-- Example 8479
from example_package import function
import other_package

-- Example 8480
import scikit-learn

-- Example 8481
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):
    # your code goes here

-- Example 8482
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

# Add parameters with optional type hints to the main handler function
def main(session: snowpark.Session, language: str):
  # Your code goes here, inside the "main" handler.
  table_name = 'information_schema.packages'
  dataFrame = session.table(table_name).filter(col("language") == language)

  # Print a sample of the dataFrame to standard output
  dataFrame.show()

  # The return value appears in the Results tab
  return dataFrame

# Add a second function to supply a value for the language parameter to validate that your main handler function runs.
def test_language(session: snowpark.Session):
  return main(session, 'java')

-- Example 8483
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):
  tableName = "range_table"
  df_range = session.range(1, 10, 2).to_df('a')
  df_range.write.mode("overwrite").save_as_table(tableName)
  return tableName + " table successfully created"

-- Example 8484
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
from snowflake.snowpark.dataframe_reader import *
from snowflake.snowpark.functions import *

def main(session: snowpark.Session):

  inputTableName = "snowflake.account_usage.task_history"
  outputTableName = "aggregate_task_history"

  df = session.table(inputTableName)
  df.filter(col("STATE") != "SKIPPED")\
    .group_by(("SCHEDULED_TIME"), "STATE").count()\
    .write.mode("overwrite").save_as_table(outputTableName)
  return outputTableName + " table successfully written"

-- Example 8485
import snowflake.snowpark as snowpark
from snowflake.snowpark.types import *

schema_for_file = StructType([
  StructField("name", StringType()),
  StructField("role", StringType())
])

fileLocation = "@DB1.PUBLIC.FILES/data_0_0_0.csv.gz"
outputTableName = "employees"

def main(session: snowpark.Session):
  df_reader = session.read.schema(schema_for_file)
  df = df_reader.csv(fileLocation)
  df.write.mode("overwrite").save_as_table(outputTableName)

  return outputTableName + " table successfully written from stage"

-- Example 8486
SELECT
  COUNT(O_ORDERDATE) as orders, O_ORDERDATE as date
FROM
  SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
WHERE
  O_ORDERDATE = :daterange
GROUP BY
  :datebucket(O_ORDERDATE), O_ORDERDATE
ORDER BY
  O_ORDERDATE
LIMIT 10;

-- Example 8487
ALTER SESSION SET SIMULATED_DATA_SHARING_CONSUMER = xy12345;

-- Example 8488
GRANT READ ON TAG mydb.tags.tag1 TO SHARE my_share;

GRANT USAGE ON DATABASE mydb TO SHARE my_share;
GRANT USAGE ON SCHEMA mydb.tags TO SHARE my_share;

-- Example 8489
GRANT READ ON TAG mydb.tags.tag1 TO DATABASE ROLE my_db_role;
GRANT USAGE ON SCHEMA mydb.tags TO DATABASE ROLE my_db_role;
GRANT DATABASE ROLE my_db_role TO SHARE my_share;

