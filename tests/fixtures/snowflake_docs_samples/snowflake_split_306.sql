-- Example 20480
const snowflake = require('snowflake-sdk');
snowflake.configure({
  jsonColumnVariantParser: rawColumnValue => JSON.parse(rawColumnValue),
  xmlColumnVariantParser: rawColumnValue => new (require("fast-xml-parser")).XMLParser().parse(rawColumnValue)
})

-- Example 20481
Logger.setInstance(new NodeLogger({ logFilePath: 'STDOUT'}));

-- Example 20482
const snowflake = require('snowflake-sdk');

snowflake.configure({
  logLevel: "INFO",
  logFilePath: "/some/path/log_file.log",
  additionalLogToConsole: false
});

-- Example 20483
{
  "common": {
    "log_level": "INFO",
    "log_path": "/some-path/some-directory"
  }
}

-- Example 20484
const snowflake = require('snowflake-sdk');

var connection = snowflake.createConnection({
  account: account,
  username: user,
  password: password,
  application: application,
  clientConfigFile: '/some/path/client_config.json'
});

-- Example 20485
[ODBC Data Sources]
testodbc1 = Snowflake
testodbc2 = Snowflake


[testodbc1]
Driver      = /opt/snowflake/snowflakeodbc/lib/universal/libSnowflake.dylib
Description =
uid         = peter
server      = myorganization-myaccount.snowflakecomputing.com
role        = sysadmin


[testodbc2]
Driver      = /opt/snowflake/snowflakeodbc/lib/universal/libSnowflake.dylib
Description =
uid         = mary
server      = xy12345.snowflakecomputing.com
role        = analyst
database    = sales
warehouse   = analysis

-- Example 20486
$ "/Library/Application Support/iODBC/bin/iodbctest"

iODBC Demonstration program
This program shows an interactive SQL processor
Driver Manager: 03.52.0607.1008

Enter ODBC connect string (? shows list): dsn=testodbc2;pwd=<password>

Dec 14 20:16:08 INFO  1299 SFConnection::connect: Tracing level: 4

Driver: 2.12.36 (Snowflake - Latest version supported by Snowflake: 2.12.38)

SQL>

-- Example 20487
yum install libiodbc

-- Example 20488
which odbcinst

which isql

-- Example 20489
yum search unixODBC

yum install unixODBC.x86_64

-- Example 20490
odbcinst -j

-- Example 20491
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 2A3149C82551A34A

-- Example 20492
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 20493
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 20494
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 20495
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 20496
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 20497
gpg: keyserver receive failed: Server indicated a failure

-- Example 20498
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 20499
gpg --list-keys

-- Example 20500
rpm -K snowflake-odbc-<version>.x86_64.rpm

-- Example 20501
rpm -K snowflake-odbc-<version>.x86_64.rpm

-- Example 20502
snowflake-odbc-<version>.x86_64.rpm: digests SIGNATURES NOT OK

rpm -Kv snowflake-odbc-<version>.x86_64.rpm

-- Example 20503
snowflake-odbc-<version>.rpm:
    Header V4 RSA/SHA1 Signature, key ID 98cb005c: NOKEY
    Header SHA1 digest: OK
    V4 RSA/SHA1 Signature, key ID 98cb005c: NOKEY
    MD5 digest: OK

-- Example 20504
gpg --export -a <GPG_KEY_ID> > odbc-signing-key.asc
sudo rpm --import odbc-signing-key.asc
rpm -K snowflake-odbc-<version>.x86_64.rpm

-- Example 20505
sudo apt-get install debsig-verify

-- Example 20506
mkdir /usr/share/debsig/keyrings/<GPG_KEY_ID>
gpg --export <GPG_KEY_ID> > snowflakeKey.asc
touch /usr/share/debsig/keyrings/<GPG_KEY_ID>/debsig.gpg
gpg --no-default-keyring --keyring /usr/share/debsig/keyrings/<GPG_KEY_ID>/debsig.gpg --import snowflakeKey.asc

-- Example 20507
/etc/debsig/policies/<GPG_KEY_ID>

-- Example 20508
<?xml version="1.0"?>
<!DOCTYPE Policy SYSTEM "http://www.debian.org/debsig/1.0/policy.dtd">
<Policy xmlns="https://www.debian.org/debsig/1.0/">
<Origin Name="Snowflake Computing" id="2A3149C82551A34A"
Description="Snowflake ODBC Driver DEB package"/>

<Selection>
<Required Type="origin" File="debsig.gpg" id="2A3149C82551A34A"/>
</Selection>

<Verification MinOptional="0">
<Required Type="origin" File="debsig.gpg" id="2A3149C82551A34A"/>
</Verification>

</Policy>

-- Example 20509
sudo debsig-verify snowflake-odbc-<version>.x86_64.deb

-- Example 20510
gpg --delete-key "Snowflake Computing"

-- Example 20511
[snowflake-odbc]
name=snowflake-odbc
baseurl=https://sfc-repo.snowflakecomputing.com/odbc/linux/<VERSION_NUMBER>/
gpgkey=https://sfc-repo.snowflakecomputing.com/odbc/Snowkey-<GPG_KEY_ID>-gpg

-- Example 20512
[snowflake-odbc]
name=snowflake-odbc
baseurl=https://sfc-repo.azure.snowflakecomputing.com/odbc/linux/<VERSION_NUMBER>/
gpgkey=https://sfc-repo.azure.snowflakecomputing.com/odbc/Snowkey-<GPG_KEY_ID>-gpg

-- Example 20513
yum install snowflake-odbc

-- Example 20514
gunzip snowflake_linux_x8664_odbc-<version>.tgz

-- Example 20515
tar -xvf snowflake_linux_x8664_odbc-<version>.tar

-- Example 20516
yum install snowflake-odbc-<version>.x86_64.rpm

-- Example 20517
sudo dpkg -i snowflake-odbc-<version>.x86_64.deb

-- Example 20518
sudo apt-get install -f

-- Example 20519
./iodbc_setup.sh

-- Example 20520
./unixodbc_setup.sh

-- Example 20521
ErrorMessagesPath=<path>/ErrorMessages/
LogPath=/tmp/
ODBCInstLib=<driver_manager_path>
CABundleFile=<path>/lib/cacert.pem
ANSIENCODING=UTF-8

-- Example 20522
[ODBC Drivers]
SnowflakeDSIIDriver=Installed

[SnowflakeDSIIDriver]
APILevel=1
ConnectFunctions=YYY
Description=Snowflake DSII
Driver=/<path>/lib/libSnowflake.so
DriverODBCVer=03.52
SQLLevel=1

-- Example 20523
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

-- Example 20524
iodbctest "DSN=testodbc2;UID=mary;PWD=password"

-- Example 20525
iODBC Demonstration program
This program shows an interactive SQL processor
Driver Manager: 03.52.0709.0909
Driver: 2.12.70 (Snowflake)

SQL>

-- Example 20526
isql -v testodbc2 mary <password>

-- Example 20527
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

-- Example 20528
// Sending a batch of SQL statements to be executed
rc = SQLExecDirect(hstmt,
      (SQLCHAR *) "select c1 from t1; select c2 from t2; select c3 from t3",
      SQL_NTS);

-- Example 20529
// Specify that you want to execute a batch of 3 SQL statements
rc = SQLSetStmtAttr(hstmt, SQL_SF_STMT_ATTR_MULTI_STATEMENT_COUNT, (SQLPOINTER)3, 0);

-- Example 20530
alter session set MULTI_STATEMENT_COUNT = 0;

-- Example 20531
alter account set MULTI_STATEMENT_COUNT = 0;

-- Example 20532
alter user set MULTI_STATEMENT_COUNT = 0;

-- Example 20533
SQLCHAR * Statement = "INSERT INTO t (c1, c2) VALUES (?, ?)";

SQLSetStmtAttr(hstmt, SQL_ATTR_PARAM_BIND_TYPE, SQL_PARAM_BIND_BY_COLUMN, 0);
SQLSetStmtAttr(hstmt, SQL_ATTR_PARAMSET_SIZE, ARRAY_SIZE, 0);
SQLSetStmtAttr(hstmt, SQL_ATTR_PARAM_STATUS_PTR, ParamStatusArray, 0);
SQLSetStmtAttr(hstmt, SQL_ATTR_PARAMS_PROCESSED_PTR, &ParamsProcessed, 0);
SQLBindParameter(hstmt, 1, SQL_PARAM_INPUT, SQL_C_ULONG, SQL_INTEGER, 5, 0,
                 IntValuesArray, 0, IntValuesIndArray);
SQLBindParameter(hstmt, 2, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, STR_VALUE_LEN - 1, 0,
                 StringValuesArray, STR_VALUE_LEN, StringValuesLenOrIndArray);
...
SQLExecDirect(hstmt, Statement, SQL_NTS);

-- Example 20534
CREATE TEMPORARY STAGE SYSTEM$BIND file_format=(type=csv field_optionally_enclosed_by='"')
Cannot perform CREATE STAGE. This session does not have a current schema. Call 'USE SCHEMA', or use a qualified name.

-- Example 20535
pip install snowflake-connector-python

-- Example 20536
import snowflake.connector

-- Example 20537
PASSWORD = os.getenv('SNOWSQL_PWD')
WAREHOUSE = os.getenv('WAREHOUSE')
...

-- Example 20538
import os

AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')

-- Example 20539
con = snowflake.connector.connect(
    user='XXXX',
    password='XXXX',
    account='XXXX',
    session_parameters={
        'QUERY_TAG': 'EndOfMonthFinancials',
    }
)

-- Example 20540
con.cursor().execute("ALTER SESSION SET QUERY_TAG = 'EndOfMonthFinancials'")

-- Example 20541
conn = snowflake.connector.connect(
    user=USER,
    password=PASSWORD,
    account=ACCOUNT,
    warehouse=WAREHOUSE,
    database=DATABASE,
    schema=SCHEMA
    )

-- Example 20542
$ vi connections.toml

-- Example 20543
[myconnection]
account = "myorganization-myaccount"
user = "jdoe"
password = "******"
warehouse = "my-wh"
database = "my_db"
schema = "my_schema"

-- Example 20544
[myconnection_test]
account = "myorganization-myaccount"
user = "jdoe-test"
password = "******"
warehouse = "my-test_wh"
database = "my_test_db"
schema = "my_schema"

-- Example 20545
with snowflake.connector.connect(
      connection_name="myconnection",
) as conn:

-- Example 20546
with snowflake.connector.connect(
      connection_name="myconnection",
      warehouse="test_xl_wh",
      database="testdb_2"
) as conn:

