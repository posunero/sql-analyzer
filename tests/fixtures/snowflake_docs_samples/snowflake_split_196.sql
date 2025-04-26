-- Example 13112
cur.execute(f"""
    SELECT a, VECTOR_COSINE_SIMILARITY(a, {[1,2,3]}::VECTOR(FLOAT, 3))
      AS similarity
      FROM vectors
      ORDER BY similarity DESC
      LIMIT 1;
""")
print(cur.fetchall())

-- Example 13113
[([1.0, 2.2..., 3.0], 0.9990...)]

-- Example 13114
logging.basicConfig(
    filename=file_name,
    level=logging.INFO)

-- Example 13115
# Logging including the timestamp, thread and the source code location
import logging
for logger_name in ['snowflake.connector', 'botocore', 'boto3']:
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler('/tmp/python_connector.log')
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(logging.Formatter('%(asctime)s - %(threadName)s %(filename)s:%(lineno)d - %(funcName)s() - %(levelname)s - %(message)s'))
    logger.addHandler(ch)

-- Example 13116
# Logging including the timestamp, thread and the source code location
import logging
from snowflake.connector.secret_detector import SecretDetector
for logger_name in ['snowflake.connector', 'botocore', 'boto3']:
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler('/tmp/python_connector.log')
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(SecretDetector('%(asctime)s - %(threadName)s %(filename)s:%(lineno)d - %(funcName)s() - %(levelname)s - %(message)s'))
    logger.addHandler(ch)

-- Example 13117
[log]
save_logs = true
level = "INFO"
path = "<directory to store logs>"

-- Example 13118
# -- (> ---------------------- SECTION=import_connector ---------------------
...
# -- <) ---------------------------- END_SECTION ----------------------------

-- Example 13119
import logging
import os
import sys


# -- (> ---------------------- SECTION=import_connector ---------------------
import snowflake.connector
# -- <) ---------------------------- END_SECTION ----------------------------


class python_veritas_base:

    """
    PURPOSE:
        This is the Base/Parent class for programs that use the Snowflake
        Connector for Python.
        This class is intended primarily for:
            * Sample programs, e.g. in the documentation.
            * Tests.
    """


    def __init__(self, p_log_file_name = None):

        """
        PURPOSE:
            This does any required initialization steps, which in this class is
            basically just turning on logging.
        """

        file_name = p_log_file_name
        if file_name is None:
            file_name = '/tmp/snowflake_python_connector.log'

        # -- (> ---------- SECTION=begin_logging -----------------------------
        logging.basicConfig(
            filename=file_name,
            level=logging.INFO)
        # -- <) ---------- END_SECTION ---------------------------------------


    # -- (> ---------------------------- SECTION=main ------------------------
    def main(self, argv):

        """
        PURPOSE:
            Most tests follow the same basic pattern in this main() method:
               * Create a connection.
               * Set up, e.g. use (or create and use) the warehouse, database,
                 and schema.
               * Run the queries (or do the other tasks, e.g. load data).
               * Clean up. In this test/demo, we drop the warehouse, database,
                 and schema. In a customer scenario, you'd typically clean up
                 temporary tables, etc., but wouldn't drop your database.
               * Close the connection.
        """

        # Read the connection parameters (e.g. user ID) from the command line
        # and environment variables, then connect to Snowflake.
        connection = self.create_connection(argv)

        # Set up anything we need (e.g. a separate schema for the test/demo).
        self.set_up(connection)

        # Do the "real work", for example, create a table, insert rows, SELECT
        # from the table, etc.
        self.do_the_real_work(connection)

        # Clean up. In this case, we drop the temporary warehouse, database, and
        # schema.
        self.clean_up(connection)

        print("\nClosing connection...")
        # -- (> ------------------- SECTION=close_connection -----------------
        connection.close()
        # -- <) ---------------------------- END_SECTION ---------------------

    # -- <) ---------------------------- END_SECTION=main --------------------


    def args_to_properties(self, args):

        """
        PURPOSE:
            Read the command-line arguments and store them in a dictionary.
            Command-line arguments should come in pairs, e.g.:
                "--user MyUser"
        INPUTS:
            The command line arguments (sys.argv).
        RETURNS:
            Returns the dictionary.
        DESIRABLE ENHANCEMENTS:
            Improve error detection and handling.
        """

        connection_parameters = {}

        i = 1
        while i < len(args) - 1:
            property_name = args[i]
            # Strip off the leading "--" from the tag, e.g. from "--user".
            property_name = property_name[2:]
            property_value = args[i + 1]
            connection_parameters[property_name] = property_value
            i += 2

        return connection_parameters


    def create_connection(self, argv):

        """
        PURPOSE:
            This gets account identifier and login information from the
            environment variables and command-line parameters, connects to the
            server, and returns the connection object.
        INPUTS:
            argv: This is usually sys.argv, which contains the command-line
                  parameters. It could be an equivalent substitute if you get
                  the parameter information from another source.
        RETURNS:
            A connection.
        """

        # Get account identifier and login information from environment variables and command-line parameters.
        # For information about account identifiers, see
        # https://docs.snowflake.com/en/user-guide/admin-account-identifier.html .
        # -- (> ----------------------- SECTION=set_login_info ---------------

        # Get the password from an appropriate environment variable, if
        # available.
        PASSWORD = os.getenv('SNOWSQL_PWD')

        # Get the other login info etc. from the command line.
        if len(argv) < 11:
            msg = "ERROR: Please pass the following command-line parameters:\n"
            msg += "--warehouse <warehouse> --database <db> --schema <schema> "
            msg += "--user <user> --account <account_identifier> "
            print(msg)
            sys.exit(-1)
        else:
            connection_parameters = self.args_to_properties(argv)
            USER = connection_parameters["user"]
            ACCOUNT = connection_parameters["account"]
            WAREHOUSE = connection_parameters["warehouse"]
            DATABASE = connection_parameters["database"]
            SCHEMA = connection_parameters["schema"]
            # Optional: for internal testing only.
            try:
                PORT = connection_parameters["port"]
            except:
                PORT = ""
            try:
                PROTOCOL = connection_parameters["protocol"]
            except:
                PROTOCOL = ""

        # If the password is set by both command line and env var, the
        # command-line value takes precedence over (is written over) the
        # env var value.

        # If the password wasn't set either in the environment var or on
        # the command line...
        if PASSWORD is None or PASSWORD == '':
            print("ERROR: Set password, e.g. with SNOWSQL_PWD environment variable")
            sys.exit(-2)
        # -- <) ---------------------------- END_SECTION ---------------------

        # Optional diagnostic:
        #print("USER:", USER)
        #print("ACCOUNT:", ACCOUNT)
        #print("WAREHOUSE:", WAREHOUSE)
        #print("DATABASE:", DATABASE)
        #print("SCHEMA:", SCHEMA)
        #print("PASSWORD:", PASSWORD)
        #print("PROTOCOL:" "'" + PROTOCOL + "'")
        #print("PORT:" + "'" + PORT + "'")

        print("Connecting...")
        # If the PORT is set but the protocol is not, we ignore the PORT (bug!!).
        if PROTOCOL is None or PROTOCOL == "" or PORT is None or PORT == "":
            # -- (> ------------------- SECTION=connect_to_snowflake ---------
            conn = snowflake.connector.connect(
                user=USER,
                password=PASSWORD,
                account=ACCOUNT,
                warehouse=WAREHOUSE,
                database=DATABASE,
                schema=SCHEMA
                )
            # -- <) ---------------------------- END_SECTION -----------------
        else:

            conn = snowflake.connector.connect(
                user=USER,
                password=PASSWORD,
                account=ACCOUNT,
                warehouse=WAREHOUSE,
                database=DATABASE,
                schema=SCHEMA,
                # Optional: for internal testing only.
                protocol=PROTOCOL,
                port=PORT
                )

        return conn


    def set_up(self, connection):

        """
        PURPOSE:
            Set up to run a test. You can override this method with one
            appropriate to your test/demo.
        """

        # Create a temporary warehouse, database, and schema.
        self.create_warehouse_database_and_schema(connection)


    def do_the_real_work(self, conn):

        """
        PURPOSE:
            Your sub-class should override this to include the code required for
            your documentation sample or your test case.
            This default method does a very simple self-test that shows that the
            connection was successful.
        """

        # Create a cursor for this connection.
        cursor1 = conn.cursor()
        # This is an example of an SQL statement we might want to run.
        command = "SELECT PI()"
        # Run the statement.
        cursor1.execute(command)
        # Get the results (should be only one):
        for row in cursor1:
            print(row[0])
        # Close this cursor.
        cursor1.close()


    def clean_up(self, connection):

        """
        PURPOSE:
            Clean up after a test. You can override this method with one
            appropriate to your test/demo.
        """

        # Create a temporary warehouse, database, and schema.
        self.drop_warehouse_database_and_schema(connection)


    def create_warehouse_database_and_schema(self, conn):

        """
        PURPOSE:
            Create the temporary schema, database, and warehouse that we use
            for most tests/demos.
        """

        # Create a database, schema, and warehouse if they don't already exist.
        print("\nCreating warehouse, database, schema...")
        # -- (> ------------- SECTION=create_warehouse_database_schema -------
        conn.cursor().execute("CREATE WAREHOUSE IF NOT EXISTS tiny_warehouse_mg")
        conn.cursor().execute("CREATE DATABASE IF NOT EXISTS testdb_mg")
        conn.cursor().execute("USE DATABASE testdb_mg")
        conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS testschema_mg")
        # -- <) ---------------------------- END_SECTION ---------------------

        # -- (> --------------- SECTION=use_warehouse_database_schema --------
        conn.cursor().execute("USE WAREHOUSE tiny_warehouse_mg")
        conn.cursor().execute("USE DATABASE testdb_mg")
        conn.cursor().execute("USE SCHEMA testdb_mg.testschema_mg")
        # -- <) ---------------------------- END_SECTION ---------------------


    def drop_warehouse_database_and_schema(self, conn):

        """
        PURPOSE:
            Drop the temporary schema, database, and warehouse that we create
            for most tests/demos.
        """

        # -- (> ------------- SECTION=drop_warehouse_database_schema ---------
        conn.cursor().execute("DROP SCHEMA IF EXISTS testschema_mg")
        conn.cursor().execute("DROP DATABASE IF EXISTS testdb_mg")
        conn.cursor().execute("DROP WAREHOUSE IF EXISTS tiny_warehouse_mg")
        # -- <) ---------------------------- END_SECTION ---------------------


# ----------------------------------------------------------------------------

if __name__ == '__main__':
    pvb = python_veritas_base()
    pvb.main(sys.argv)

-- Example 13120
import sys

# -- (> ---------------------- SECTION=import_connector ---------------------
import snowflake.connector
# -- <) ---------------------------- END_SECTION ----------------------------


# Import the base class that contains methods used in many tests and code 
# examples.
from python_veritas_base import python_veritas_base


class python_connector_example (python_veritas_base):

  """
  PURPOSE:
      This is a simple example program that shows how to use the Snowflake 
      Python Connector to create and query a table.
  """

  def __init__(self):
    pass


  def do_the_real_work(self, conn):

    """
    INPUTS:
        conn is a Connection object returned from snowflake.connector.connect().
    """

    print("\nCreating table test_table...")
    # -- (> ----------------------- SECTION=create_table ---------------------
    conn.cursor().execute(
        "CREATE OR REPLACE TABLE "
        "test_table(col1 integer, col2 string)")

    conn.cursor().execute(
        "INSERT INTO test_table(col1, col2) VALUES " + 
        "    (123, 'test string1'), " + 
        "    (456, 'test string2')")
    # -- <) ---------------------------- END_SECTION -------------------------


    print("\nSelecting from test_table...")
    # -- (> ----------------------- SECTION=querying_data --------------------
    cur = conn.cursor()
    try:
        cur.execute("SELECT col1, col2 FROM test_table ORDER BY col1")
        for (col1, col2) in cur:
            print('{0}, {1}'.format(col1, col2))
    finally:
        cur.close()
    # -- <) ---------------------------- END_SECTION -------------------------




# ============================================================================

if __name__ == '__main__':

    test_case = python_connector_example()
    test_case.main(sys.argv)

-- Example 13121
export SNOWSQL_PWD='MyPassword'

-- Example 13122
python3 python_connector_example.py --warehouse <unique_warehouse_name> --database <new_warehouse_zzz_test> --schema <new_schema_zzz_test> --account myorganization-myaccount --user MyUserName

-- Example 13123
Connecting...

Creating warehouse, database, schema...

Creating table test_table...

Selecting from test_table...
123, test string1
456, test string2

Closing connection...

-- Example 13124
#!/usr/bin/env python
#
# Snowflake Connector for Python Sample Program
#

# Logging
import logging
logging.basicConfig(
    filename='/tmp/snowflake_python_connector.log',
    level=logging.INFO)

import snowflake.connector

# Set ACCOUNT to your account identifier.
# See https://docs.snowflake.com/en/user-guide/gen-conn-config.
ACCOUNT = '<my_organization>-<my_account>'
# Set your login information.
USER = '<login_name>'
PASSWORD = '<password>'

import os

# Only required if you copy data from your S3 bucket
AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')

# Connecting to Snowflake
con = snowflake.connector.connect(
  user=USER,
  password=PASSWORD,
  account=ACCOUNT,
)

# Creating a database, schema, and warehouse if none exists
con.cursor().execute("CREATE WAREHOUSE IF NOT EXISTS tiny_warehouse")
con.cursor().execute("CREATE DATABASE IF NOT EXISTS testdb")
con.cursor().execute("USE DATABASE testdb")
con.cursor().execute("CREATE SCHEMA IF NOT EXISTS testschema")

# Using the database, schema and warehouse
con.cursor().execute("USE WAREHOUSE tiny_warehouse")
con.cursor().execute("USE SCHEMA testdb.testschema")

# Creating a table and inserting data
con.cursor().execute(
    "CREATE OR REPLACE TABLE "
    "testtable(col1 integer, col2 string)")
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(123, 'test string1'),(456, 'test string2')")

# Copying data from internal stage (for testtable table)
con.cursor().execute("PUT file:///tmp/data0/file* @%testtable")
con.cursor().execute("COPY INTO testtable")

# Copying data from external stage (S3 bucket -
# replace <s3_bucket> with the name of your bucket)
con.cursor().execute("""
COPY INTO testtable FROM s3://<s3_bucket>/data/
     STORAGE_INTEGRATION = myint
     FILE_FORMAT=(field_delimiter=',')
""".format(
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY))

# Querying data
cur = con.cursor()
try:
    cur.execute("SELECT col1, col2 FROM testtable")
    for (col1, col2) in cur:
        print('{0}, {1}'.format(col1, col2))
finally:
    cur.close()

# Binding data
con.cursor().execute(
    "INSERT INTO testtable(col1, col2) "
    "VALUES(%(col1)s, %(col2)s)", {
        'col1': 789,
        'col2': 'test string3',
        })

# Retrieving column names
cur = con.cursor()
cur.execute("SELECT * FROM testtable")
print(','.join([col[0] for col in cur.description]))

# Catching syntax errors
cur = con.cursor()
try:
    cur.execute("SELECT * FROM testtable")
except snowflake.connector.errors.ProgrammingError as e:
    # default error message
    print(e)
    # user error message
    print('Error {0} ({1}): {2} ({3})'.format(e.errno, e.sqlstate, e.msg, e.sfqid))
finally:
    cur.close()

# Retrieving the Snowflake query ID
cur = con.cursor()
cur.execute("SELECT * FROM testtable")
print(cur.sfqid)

# Closing the connection
con.close()

-- Example 13125
jdbc:snowflake://<account_identifier>.snowflakecomputing.com/?<connection_params>

-- Example 13126
String connectionURL = "jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?query_tag='folder=folder1 folder2&'

-- Example 13127
String connectionURL = "jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?query_tag='folder%3Dfolder1%20folder2%26'

-- Example 13128
Properties props = new Properties();
props.put("parameter1", parameter1Value);
props.put("parameter2", parameter2Value);
Connection con = DriverManager.getConnection("jdbc:snowflake://<account_identifier>.snowflakecomputing.com/", props);

-- Example 13129
jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?user=peter&warehouse=mywh&db=mydb&schema=public

-- Example 13130
jdbc:snowflake://xy12345.snowflakecomputing.com/?user=peter&warehouse=mywh&db=mydb&schema=public

-- Example 13131
[default]
account = 'my_organization-my_account'
user = 'test_user'
password = '******'
warehouse = 'testw'
database = 'test_db'
schema = 'test_nodejs'
protocol = 'https'
port = '443'


[aws-oauth-file]
account = 'my_organization-my_account'
user = 'test_user'
password = '******'
warehouse = 'testw'
database = 'test_db'
schema = 'test_nodejs'
protocol = 'https'
port = '443'
authenticator = 'oauth'
token_file_path = '/Users/test/.snowflake/token'

-- Example 13132
javac -cp bcprov-jdk<versions>.jar:bcpkix-jdk<versions>.jar TestJdbc.java

java -cp .:snowflake-jdbc-<ver>.jar:bcprov-jdk<versions>.jar:bcpkix-jdk<versions>.jar TestJdbc.java

-- Example 13133
javac -cp bcprov-jdk<versions>.jar;bcpkix-jdk<versions>.jar TestJdbc.java

java -cp .;snowflake-jdbc-<ver>.jar;bcprov-jdk<versions>.jar;bcpkix-jdk<versions>.jar TestJdbc.java

-- Example 13134
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.bouncycastle.openssl.jcajce.JceOpenSSLPKCS8DecryptorProviderBuilder;
import org.bouncycastle.operator.InputDecryptorProvider;
import org.bouncycastle.operator.OperatorCreationException;
import org.bouncycastle.pkcs.PKCS8EncryptedPrivateKeyInfo;
import org.bouncycastle.pkcs.PKCSException;

import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
import java.security.PrivateKey;
import java.security.Security;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.DriverManager;
import java.util.Properties;

public class TestJdbc
{
  // Path to the private key file that you generated earlier.
  private static final String PRIVATE_KEY_FILE = "/<path>/rsa_key.p8";

  public static class PrivateKeyReader
  {

    // If you generated an encrypted private key, implement this method to return
    // the passphrase for decrypting your private key.
    private static String getPrivateKeyPassphrase() {
      return "<private_key_passphrase>";
    }

    public static PrivateKey get(String filename)
            throws Exception
    {
      PrivateKeyInfo privateKeyInfo = null;
      Security.addProvider(new BouncyCastleProvider());
      // Read an object from the private key file.
      PEMParser pemParser = new PEMParser(new FileReader(Paths.get(filename).toFile()));
      Object pemObject = pemParser.readObject();
      if (pemObject instanceof PKCS8EncryptedPrivateKeyInfo) {
        // Handle the case where the private key is encrypted.
        PKCS8EncryptedPrivateKeyInfo encryptedPrivateKeyInfo = (PKCS8EncryptedPrivateKeyInfo) pemObject;
        String passphrase = getPrivateKeyPassphrase();
        InputDecryptorProvider pkcs8Prov = new JceOpenSSLPKCS8DecryptorProviderBuilder().build(passphrase.toCharArray());
        privateKeyInfo = encryptedPrivateKeyInfo.decryptPrivateKeyInfo(pkcs8Prov);
      } else if (pemObject instanceof PrivateKeyInfo) {
        // Handle the case where the private key is unencrypted.
        privateKeyInfo = (PrivateKeyInfo) pemObject;
      }
      pemParser.close();
      JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider(BouncyCastleProvider.PROVIDER_NAME);
      return converter.getPrivateKey(privateKeyInfo);
    }
  }

  public static void main(String[] args)
      throws Exception
  {
    String url = "jdbc:snowflake://<account_identifier>.snowflakecomputing.com";
    Properties prop = new Properties();
    prop.put("user", "<user>");
    prop.put("privateKey", PrivateKeyReader.get(PRIVATE_KEY_FILE));
    prop.put("db", "<database_name>");
    prop.put("schema", "<schema_name>");
    prop.put("warehouse", "<warehouse_name>");
    prop.put("role", "<role_name>");

    Connection conn = DriverManager.getConnection(url, prop);
    Statement stat = conn.createStatement();
    ResultSet res = stat.executeQuery("select 1");
    res.next();
    System.out.println(res.getString(1));
    conn.close();
  }
}

-- Example 13135
Properties props = new Properties();
props.put("private_key_file", "/tmp/rsa_key.p8");
props.put("private_key_file_pwd", "dummyPassword");
Connection connection = DriverManager.getConnection("jdbc:snowflake://myorganization-myaccount.snowflake.com", props);

-- Example 13136
Connection connection = DriverManager.getConnection(
    "jdbc:snowflake://myorganization-myaccount.snowflake.com/?private_key_file=/tmp/rsa_key.p8&private_key_file_pwd=dummyPassword",
    props);

-- Example 13137
java.security.NoSuchAlgorithmException: 1.2.840.113549.1.5.13 SecretKeyFactory not available

java.security.InvalidKeyException: IOException : DER input, Integer tag error

-- Example 13138
-Dnet.snowflake.jdbc.enableBouncyCastle=true

-- Example 13139
System.setProperty("http.useProxy", "true");
System.setProperty("http.proxyHost", "proxyHost Value");
System.setProperty("http.proxyPort", "proxyPort Value");
System.setProperty("http.proxyUser", "proxyUser Value");
System.setProperty("http.proxyPassword", "proxyPassword Value");
System.setProperty("https.proxyHost", "proxyHost HTTPS Value");
System.setProperty("https.proxyPort", "proxyPort HTTPS Value");
System.setProperty("https.proxyUser", "proxyUser HTTPS Value");
System.setProperty("https.proxyPassword", "proxyPassword HTTPS Value");
System.setProperty("http.proxyProtocol", "https");

-- Example 13140
-Dhttp.useProxy=true
-Dhttps.proxyHost=<proxy_host>
-Dhttps.proxyPort=<proxy_port>
-Dhttps.proxyUser=<proxy_user>
-Dhttps.proxyPassword=<proxy_password>
-Dhttp.proxyHost=<proxy_host>
-Dhttp.proxyPort=<proxy_port>
-Dhttp.proxyUser=<proxy_user>
-Dhttp.proxyPassword=<proxy_password>
-Dhttp.proxyProtocol="https"

-- Example 13141
-Dhttp.nonProxyHosts="*.example.com|localhost|myorganization-myaccount.snowflakecomputing.com|192.168.91.*"

-- Example 13142
jdbc:snowflake://<account_identifier>.snowflakecomputing.com/?warehouse=<warehouse_name>&useProxy=true&proxyHost=<ip_address>&proxyPort=<port>&proxyUser=test&proxyPassword=test

-- Example 13143
jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?warehouse=DemoWarehouse1&useProxy=true&proxyHost=172.31.89.76&proxyPort=8888&proxyUser=test&proxyPassword=test

-- Example 13144
useProxy=true
proxyHost=127.0.0.1
proxyPort=8080
nonProxyHosts=*

-- Example 13145
&nonProxyHosts=<bypass_proxy_for_these_hosts>

-- Example 13146
&nonProxyHosts=*.example.com%7Clocalhost%7Cmyorganization-myaccount.snowflakecomputing.com%7C192.168.91.*

-- Example 13147
&proxyProtocol=https

-- Example 13148
Properties connection_properties = new Properties();
connection_properties.put("ocspFailOpen", "false");
...
connection = DriverManager.getConnection(connectionString, connection_properties);

-- Example 13149
Properties p = new Properties(System.getProperties());
p.put("net.snowflake.jdbc.ocspFailOpen", "false");
System.setProperties(p);

-- Example 13150
###########################################################
#   Default Logging Configuration File
#
# You can use a different file by specifying a filename
# with the java.util.logging.config.file system property.
# For example java -Djava.util.logging.config.file=myfile
############################################################

############################################################
#   Global properties
############################################################

# "handlers" specifies a comma-separated list of log Handler
# classes.  These handlers will be installed during VM startup.
# Note that these classes must be on the system classpath.
# ConsoleHandler and FileHandler are configured here such that
# the logs are dumped into both a standard error and a file.
handlers = java.util.logging.ConsoleHandler, java.util.logging.FileHandler

# Default global logging level.
# This specifies which kinds of events are logged across
# all loggers.  For any given facility this global level
# can be overriden by a facility specific level.
# Note that the ConsoleHandler also has a separate level
# setting to limit messages printed to the console.
.level = INFO

############################################################
# Handler specific properties.
# Describes specific configuration information for Handlers.
############################################################

# default file output is in the tmp dir
java.util.logging.FileHandler.pattern = /tmp/snowflake_jdbc%u.log
java.util.logging.FileHandler.limit = 5000000000000000
java.util.logging.FileHandler.count = 10
java.util.logging.FileHandler.level = INFO
java.util.logging.FileHandler.formatter = net.snowflake.client.log.SFFormatter

# Limit the messages that are printed on the console to INFO and above.
java.util.logging.ConsoleHandler.level = INFO
java.util.logging.ConsoleHandler.formatter = net.snowflake.client.log.SFFormatter

# Example to customize the SimpleFormatter output format
# to print one-line log message like this:
#     <level>: <log message> [<date/time>]
#
# java.util.logging.SimpleFormatter.format=%4$s: %5$s [%1$tc]%n

############################################################
# Facility specific properties.
# Provides extra control for each logger.
############################################################

# Snowflake JDBC logging level.
net.snowflake.level = INFO
net.snowflake.handler = java.util.logging.FileHandler

-- Example 13151
java -jar application.jar -Dnet.snowflake.jdbc.loggerImpl=net.snowflake.client.log.JDK14Logger -Djava.util.logging.config.file=logging.properties

-- Example 13152
{
  "common": {
    "log_level": "DEBUG",
    "log_path": "/home/user/logs"
  }
}

-- Example 13153
[HKEY_LOCAL_MACHINE\SOFTWARE\Snowflake\Driver]

-- Example 13154
[HKEY_CURRENT_USER\SOFTWARE\ODBC\ODBC.INI\<DSN_NAME>]

[HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\<DSN_NAME>]

-- Example 13155
[HKEY_CURRENT_USER\SOFTWARE\WOW6432NODE\ODBC\ODBC.INI\<DSN_NAME>]

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432NODE\ODBC\ODBC.INI\<DSN_NAME>]

-- Example 13156
Requested conversion is not supported
Cannot get the current row value of column

-- Example 13157
no_proxy=localhost,.example.com,myorganization-myaccount.snowflakecomputing.com,192.168.1.15,192.168.1.16

-- Example 13158
driver={SnowflakeDSIIDriver};server=myorganization-myaccount.snowflakecomputing.com;uid=myloginname;pwd=mypassword;database=mydatabase;schema=myschema;warehouse=mywarehouse;role=myrole;...

-- Example 13159
[connection]
Description = SnowflakeDB
Driver      = SnowflakeDSIIDriver
Locale      = en-US
server      = myorganization-myaccount.snowflakecomputing.com
proxy       = http://proxyserver.company:80
no_proxy    = .amazonaws.com

-- Example 13160
export http_proxy=http://proxyserver.example.com:80
export https_proxy=http://proxyserver.example.com:80

-- Example 13161
export https_proxy=http://username:password@proxyserver.example.com:80

-- Example 13162
set http_proxy=http://proxyserver.example.com:80
set https_proxy=http://proxyserver.example.com:80

-- Example 13163
set https_proxy=http://username:password@proxyserver.example.com:80

-- Example 13164
EnablePidLogFileNames = true  # Appends the process ID to each log file
LogFileSize = 30,145,728      # Sets log files size to 30MB
LogFileCount = 100            # Saves the 100 most recent log files

-- Example 13165
{
  "common": {
    "log_level": "DEBUG",
    "log_path": "/home/user/logs"
  }
}

-- Example 13166
var connection = snowflake.createConnection({
  account: "myaccount.us-east-2",
  username: "myusername",
  password: "mypassword"
});

-- Example 13167
<exhibit name="Polar Bear Plunge">
  <animal id="000001">
    <scientificName>Ursus maritimus</scientificName>
    <englishName>Polar Bear</englishName>
    <name>Kalluk</name>
  </animal>
  <animal id="000002">
    <scientificName>Ursus maritimus</scientificName>
    <englishName>Polar Bear</englishName>
    <name>Chinook</name>
  </animal>
</exhibit>

-- Example 13168
{
  exhibit: {
    animal: [
      {
        "scientificName": "Ursus maritimus",
        "englishName": "Polar Bear",
        "name": "Kalluk",
      },
      {
        "scientificName": "Ursus maritimus",
        "englishName": "Polar Bear",
        "name": "Chinook"
      }
    ]
  }
}

-- Example 13169
{
    exhibit: {
      animal: [
        {
          "scientificName": "Ursus maritimus",
          "englishName": "Polar Bear",
          "name": "Kalluk",
          "@_id": "000001"
        },
        {
          "scientificName": "Ursus maritimus",
          "englishName": "Polar Bear",
          "name": "Chinook",
          "@_id": "000002"
        }
      ],
      "@_name": "Polar Bear Plunge"
    }
}

-- Example 13170
{
  exhibit: {
    animal: [
      {
        "scientificName": {
          "#text": "Ursus maritimus"
        },
        "englishName": {
          "#text": "Polar Bear"
        },
        "name": {
          "#text": "Kalluk"
        },
        "@_id": "000001"
      },
      {
        "scientificName": {
          "#text": "Ursus maritimus"
        },
        "englishName": {
          "#text": "Polar Bear"
        },
        "name": {
          "#text": "Chinook"
        },
        "@_id": "000002"
      }
      "@_name": "Polar Bear Plunge"
    ]
  }
}

-- Example 13171
{
    exhibit: {
      animal: [
        {
          "scientificName": "Ursus maritimus",
          "englishName": "Polar Bear",
          "name": "Kalluk",
          "id": "000001"
        },
        {
          "scientificName": "Ursus maritimus",
          "englishName": "Polar Bear",
          "name": "Chinook",
          "id": "000002"
        }
      ],
      "name": "Polar Bear Plunge"
    }
}

-- Example 13172
{
    exhibit: {
      "@@": {
        "@_name": "Polar Bear Plunge"
      }
      animal: [
        {
          "@@": {
            "@_id": "000001"
          },
          "scientificName": "Ursus maritimus",
          "englishName": "Polar Bear",
          "name": "Kalluk"
        },
        {
          "@@": {
            "@_id": "000002"
          },
          "scientificName": "Ursus maritimus",
          "englishName": "Polar Bear",
          "name": "Chinook"
        }
      ]
    }
}

-- Example 13173
from snowflake.snowpark import Session

-- Example 13174
vi connections.toml

-- Example 13175
[myconnection]
account = "myaccount"
user = "jdoe"
password = "******"
warehouse = "my-wh"
database = "my_db"
schema = "my_schema"

-- Example 13176
[myconnection_test]
account = "myaccount"
user = "jdoe-test"
password = "******"
warehouse = "my-test_wh"
database = "my_test_db"
schema = "my_schema"

-- Example 13177
session = Session.builder.config("connection_name", "myconnection").create()

-- Example 13178
connection_parameters = {
  "account": "<your snowflake account>",
  "user": "<your snowflake user>",
  "password": "<your snowflake password>",
  "role": "<your snowflake role>",  # optional
  "warehouse": "<your snowflake warehouse>",  # optional
  "database": "<your snowflake database>",  # optional
  "schema": "<your snowflake schema>",  # optional
}

new_session = Session.builder.configs(connection_parameters).create()

