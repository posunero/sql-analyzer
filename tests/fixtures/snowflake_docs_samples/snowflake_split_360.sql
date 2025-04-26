-- Example 24095
scope=session:role:R1

-- Example 24096
scope=refresh_token

-- Example 24097
scope=refresh_token session:role:R1

-- Example 24098
<snowflake_account_url>/oauth/token-request

-- Example 24099
Content-type: application/x-www-form-urlencoded

-- Example 24100
{
  "access_token":  "ACCESS_TOKEN",
  "expires_in": 600,
  "refresh_token": "REFRESH_TOKEN",
  "token_type": "Bearer",
  "username": "user1",
}

-- Example 24101
{
  "data" : null,
  "message" : "This is an invalid client.",
  "code" : null,
  "success" : false,
  "error" : "invalid_client"
}

-- Example 24102
<snowflake_account_url>/oauth/token

-- Example 24103
Content-type: application/x-www-form-urlencoded

-- Example 24104
{
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': 'session:role:TEST_ROLE ab12-orgname-acctname.snowflakecomputing.app',
    'assertion': '<token>'
}

-- Example 24105
{
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': 'ab12-orgname-acctname.snowflakecomputing.app',
    'assertion': '<token>'
}

-- Example 24106
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8

-- Example 24107
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIE6TAbBgkqhkiG9w0BBQMwDgQILYPyCppzOwECAggABIIEyLiGSpeeGSe3xHP1
wHLjfCYycUPennlX2bd8yX8xOxGSGfvB+99+PmSlex0FmY9ov1J8H1H9Y3lMWXbL
...
-----END ENCRYPTED PRIVATE KEY-----

-- Example 24108
$ openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 24109
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy+Fw2qv4Roud3l6tjPH4
zxybHjmZ5rhtCz9jppCV8UTWvEXxa88IGRIHbJ/PwKW/mR8LXdfI7l/9vCMXX4mk
...
-----END PUBLIC KEY-----

-- Example 24110
ALTER SECURITY INTEGRATION myint SET OAUTH_CLIENT_RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 24111
DESC SECURITY INTEGRATION myint;

+----------------------------------+---------------+----------------------------------------------------------------------+------------------+
| property                         | property_type | property_value                                                       | property_default |
|----------------------------------+---------------+----------------------------------------------------------------------+------------------|
...
| OAUTH_CLIENT_RSA_PUBLIC_KEY_FP   | String        | SHA256:MRItnbO/123abc/abcdefghijklmn12345678901234=                  |                  |
| OAUTH_CLIENT_RSA_PUBLIC_KEY_2_FP | String        |                                                                      |                  |
...
+----------------------------------+---------------+----------------------------------------------------------------------+------------------+

-- Example 24112
import datetime
import json
import urllib

import jwt
import requests

private_key = """
<private_key>
"""

public_key_fp = "<public_key_fp>" # SHA256:MR...


def _make_request(payload, encoded_jwt_token):
    token_url = "https://<account_name>.snowflakecomputing.com/oauth/token-request"
    headers = {
            u'Authorization': "Bearer %s" % (encoded_jwt_token),
            u'content-type': u'application/x-www-form-urlencoded'
    }
    r = requests.post(
            token_url,
            headers=headers,
            data=urllib.urlencode(payload))
    return r.json()


def make_request_for_access_token(oauth_az_code, encoded_jwt_token):
    """ Given an Authorization Code, make a request for an Access Token
    and a Refresh Token."""
    payload = {
        'grant_type': 'authorization_code',
        'code': oauth_az_code,
        'redirect_uri': <redirect_uri>
    }
    return _make_request(payload, encoded_jwt_token)


def make_request_for_refresh_token(refresh_token, encoded_jwt_token):
    """ Given a Refresh Token, make a request for another Access Token."""
    payload = {
        'grant_type': 'refresh_token',
        'refresh_token': refresh_token
    }
    return _make_request(payload, encoded_jwt_token)


def main():
    account_locator = "<account_locator>"
    client_id = "1234"  # found by running DESC SECURITY INTEGRATION
    issuer = "{}.{}".format(client_id, public_key_fp)
    subject = "{}.{}".format(account_locator, client_id)
    payload = {
        'iss': issuer,
        'sub': subject,
        'iat': datetime.datetime.utcnow(),
        'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=30)
    }
    encoded_jwt_token = jwt.encode(
            payload,
            private_key,
            algorithm='RS256')

    data = make_request_for_access_token(<oauth_az_code>, encoded_jwt_token)
    refresh_token = data['refresh_token']
    data = make_request_for_refresh_token(refresh_token, encoded_jwt_token)
    access_token = data['access_token']


if __name__ == '__main__':
    main()

-- Example 24113
"Authorization: Bearer JWT_TOKEN"

-- Example 24114
alter integration myint set oauth_client_rsa_public_key_2='JERUEHtcve...';

-- Example 24115
alter integration myint unset oauth_client_rsa_public_key;

-- Example 24116
CREATE [ OR REPLACE ] SECURITY INTEGRATION [ IF NOT EXISTS ]
  <name>
  TYPE = OAUTH
  ENABLED = { TRUE | FALSE }
  OAUTH_CLIENT = <partner_application>
  oauthClientParams
  [ COMMENT = '<string_literal>' ]

-- Example 24117
oauthClientParams ::=
  [ OAUTH_ISSUE_REFRESH_TOKENS = TRUE | FALSE ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ BLOCKED_ROLES_LIST = ('<role_name>', '<role_name>') ]

-- Example 24118
CREATE SECURITY INTEGRATION td_oauth_int1
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = TABLEAU_DESKTOP;

-- Example 24119
DESC SECURITY INTEGRATION td_oauth_int1;

-- Example 24120
CREATE SECURITY INTEGRATION td_oauth_int2
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_REFRESH_TOKEN_VALIDITY = 36000
  BLOCKED_ROLES_LIST = ('SYSADMIN')
  OAUTH_CLIENT = TABLEAU_DESKTOP;

-- Example 24121
CREATE SECURITY INTEGRATION ts_oauth_int1
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = TABLEAU_SERVER;

-- Example 24122
DESC SECURITY INTEGRATION ts_oauth_int1;

-- Example 24123
CREATE SECURITY INTEGRATION ts_oauth_int2
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = TABLEAU_SERVER
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400
  BLOCKED_ROLES_LIST = ('SYSADMIN');

-- Example 24124
SHOW DELEGATED AUTHORIZATIONS;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
|-------------------------------+-----------+-----------+-------------------+--------------------|
| 2018-11-27 07:43:10.914 -0800 | JSMITH    | PUBLIC    | MY_OAUTH_INT      | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 24125
SHOW DELEGATED AUTHORIZATIONS
    BY USER <username>;

-- Example 24126
SHOW DELEGATED AUTHORIZATIONS
    TO SECURITY INTEGRATION <integration_name>;

-- Example 24127
ALTER USER <username> REMOVE DELEGATED AUTHORIZATIONS
    FROM SECURITY INTEGRATION <integration_name>

-- Example 24128
ALTER USER <username> REMOVE DELEGATED AUTHORIZATION
    OF ROLE <role_name>
    FROM SECURITY INTEGRATION <integration_name>

-- Example 24129
jdbc:snowflake://<account_identifier>.snowflakecomputing.com/?<connection_params>

-- Example 24130
String connectionURL = "jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?query_tag='folder=folder1 folder2&'

-- Example 24131
String connectionURL = "jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?query_tag='folder%3Dfolder1%20folder2%26'

-- Example 24132
Properties props = new Properties();
props.put("parameter1", parameter1Value);
props.put("parameter2", parameter2Value);
Connection con = DriverManager.getConnection("jdbc:snowflake://<account_identifier>.snowflakecomputing.com/", props);

-- Example 24133
jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?user=peter&warehouse=mywh&db=mydb&schema=public

-- Example 24134
jdbc:snowflake://xy12345.snowflakecomputing.com/?user=peter&warehouse=mywh&db=mydb&schema=public

-- Example 24135
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

-- Example 24136
javac -cp bcprov-jdk<versions>.jar:bcpkix-jdk<versions>.jar TestJdbc.java

java -cp .:snowflake-jdbc-<ver>.jar:bcprov-jdk<versions>.jar:bcpkix-jdk<versions>.jar TestJdbc.java

-- Example 24137
javac -cp bcprov-jdk<versions>.jar;bcpkix-jdk<versions>.jar TestJdbc.java

java -cp .;snowflake-jdbc-<ver>.jar;bcprov-jdk<versions>.jar;bcpkix-jdk<versions>.jar TestJdbc.java

-- Example 24138
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

-- Example 24139
Properties props = new Properties();
props.put("private_key_file", "/tmp/rsa_key.p8");
props.put("private_key_file_pwd", "dummyPassword");
Connection connection = DriverManager.getConnection("jdbc:snowflake://myorganization-myaccount.snowflake.com", props);

-- Example 24140
Connection connection = DriverManager.getConnection(
    "jdbc:snowflake://myorganization-myaccount.snowflake.com/?private_key_file=/tmp/rsa_key.p8&private_key_file_pwd=dummyPassword",
    props);

-- Example 24141
java.security.NoSuchAlgorithmException: 1.2.840.113549.1.5.13 SecretKeyFactory not available

java.security.InvalidKeyException: IOException : DER input, Integer tag error

-- Example 24142
-Dnet.snowflake.jdbc.enableBouncyCastle=true

-- Example 24143
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

-- Example 24144
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

-- Example 24145
-Dhttp.nonProxyHosts="*.example.com|localhost|myorganization-myaccount.snowflakecomputing.com|192.168.91.*"

-- Example 24146
jdbc:snowflake://<account_identifier>.snowflakecomputing.com/?warehouse=<warehouse_name>&useProxy=true&proxyHost=<ip_address>&proxyPort=<port>&proxyUser=test&proxyPassword=test

-- Example 24147
jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/?warehouse=DemoWarehouse1&useProxy=true&proxyHost=172.31.89.76&proxyPort=8888&proxyUser=test&proxyPassword=test

-- Example 24148
useProxy=true
proxyHost=127.0.0.1
proxyPort=8080
nonProxyHosts=*

-- Example 24149
&nonProxyHosts=<bypass_proxy_for_these_hosts>

-- Example 24150
&nonProxyHosts=*.example.com%7Clocalhost%7Cmyorganization-myaccount.snowflakecomputing.com%7C192.168.91.*

-- Example 24151
&proxyProtocol=https

-- Example 24152
Properties connection_properties = new Properties();
connection_properties.put("ocspFailOpen", "false");
...
connection = DriverManager.getConnection(connectionString, connection_properties);

-- Example 24153
Properties p = new Properties(System.getProperties());
p.put("net.snowflake.jdbc.ocspFailOpen", "false");
System.setProperties(p);

-- Example 24154
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

-- Example 24155
java -jar application.jar -Dnet.snowflake.jdbc.loggerImpl=net.snowflake.client.log.JDK14Logger -Djava.util.logging.config.file=logging.properties

-- Example 24156
{
  "common": {
    "log_level": "DEBUG",
    "log_path": "/home/user/logs"
  }
}

-- Example 24157
// Use a browser to authenticate via SSO.
var connection = snowflake.createConnection({
  ...,
  authenticator: "EXTERNALBROWSER"
});
// Establish a connection. Use connectAsync, rather than connect.
connection.connectAsync(
  function (err, conn)
  {
    ... // Handle any errors.
  }
).then(() =>
{
  // Execute SQL statements.
  var statement = connection.execute({...});
});

-- Example 24158
// Use native SSO authentication through Okta.
var connection = snowflake.createConnection({
  ...,
  username: '<user_name_for_okta>',
  password: '<password_for_okta>',
  authenticator: "https://myaccount.okta.com"
});

// Establish a connection.
connection.connectAsync(
  function (err, conn)
  {
    ... // Handle any errors.
  }
);

// Execute SQL statements.
var statement = connection.execute({...});

-- Example 24159
// Read the private key file from the filesystem.
var crypto = require('crypto');
var fs = require('fs');
var privateKeyFile = fs.readFileSync('<path_to_private_key_file>/rsa_key.p8');

// Get the private key from the file as an object.
const privateKeyObject = crypto.createPrivateKey({
  key: privateKeyFile,
  format: 'pem',
  passphrase: 'passphrase'
});

// Extract the private key from the object as a PEM-encoded string.
var privateKey = privateKeyObject.export({
  format: 'pem',
  type: 'pkcs8'
});

// Use the private key for authentication.
var connection = snowflake.createConnection({
  ...
  authenticator: "SNOWFLAKE_JWT",
  privateKey: privateKey
});

// Establish a connection.
connection.connect(
  function (err, conn)
  {
    ... // Handle any errors.
  }
);

// Execute SQL statements.
var statement = connection.execute({...});

-- Example 24160
// Use an encrypted private key file for authentication.
// Specify the passphrase for decrypting the key.
var connection = snowflake.createConnection({
  ...
  authenticator: "SNOWFLAKE_JWT",
  privateKeyPath: "<path-to-privatekey>/privatekey.p8",
  privateKeyPass: '<passphrase_to_decrypt_the_private_key>'
});

// Establish a connection.
connection.connect(
  function (err, conn)
  {
    ... // Handle any errors.
  }
);

// Execute SQL statements.
var statement = connection.execute({...});

-- Example 24161
// Use OAuth for authentication.
var connection = snowflake.createConnection({
  ...
  authenticator: "OAUTH",
  token: "<your_oauth_token>"
});

// Establish a connection.
connection.connect(
  function (err, conn)
  {
    ... // Handle any errors.
  }
);

// Execute SQL statements.
var statement = connection.execute({...});

