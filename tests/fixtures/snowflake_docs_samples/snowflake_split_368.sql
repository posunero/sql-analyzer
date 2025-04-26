-- Example 24631
snow connection test -c myconnection2

-- Example 24632
+--------------------------------------------------+
| key             | value                          |
|-----------------+--------------------------------|
| Connection name | myconnection2                  |
| Status          | OK                             |
| Host            | example.snowflakecomputing.com |
| Account         | myaccount2                     |
| User            | jdoe2                          |
| Role            | ACCOUNTADMIN                   |
| Database        | not set                        |
| Warehouse       | not set                        |
+--------------------------------------------------+

-- Example 24633
snow connection test -c myconnection2 --enable-diag --diag-log-path $(HOME)/report

-- Example 24634
+----------------------------------------------------------------------------+
| key                  | value                                               |
|----------------------+-----------------------------------------------------|
| Connection name      | myconnection2                                       |
| Status               | OK                                                  |
| Host                 | example.snowflakecomputing.com                      |
| Account              | myaccount2                                          |
| User                 | jdoe2                                               |
| Role                 | ACCOUNTADMIN                                        |
| Database             | not set                                             |
| Warehouse            | not set                                             |
| Diag Report Location | /Users/<username>/SnowflakeConnectionTestReport.txt |
+----------------------------------------------------------------------------+

-- Example 24635
snow connection set-default myconnection2

-- Example 24636
Default connection set to: myconnection2

-- Example 24637
snow sql --help

-- Example 24638
╭─ Connection configuration ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --connection,--environment             -c      TEXT     Name of the connection, as defined in your config.toml. Default: default.            │
│ --host                                         TEXT     Host address for the connection. Overrides the value specified for the connection.   │
│ --port                                         INTEGER  Port for the connection. Overrides the value specified for the connection.           │
│ --account,--accountname                        TEXT     Name assigned to your Snowflake account. Overrides the value specified for the       │
│                                                         connection.                                                                          │
│ --user,--username                              TEXT     Username to connect to Snowflake. Overrides the value specified for the connection.  │
│ --password                                     TEXT     Snowflake password. Overrides the value specified for the connection.                │
│ --authenticator                                TEXT     Snowflake authenticator. Overrides the value specified for the connection.           │
│ --private-key-file,--private-key-path          TEXT     Snowflake private key file path. Overrides the value specified for the connection.   │
│ --token-file-path                              TEXT     Path to file with an OAuth token that should be used when connecting to Snowflake    │
│ --database,--dbname                            TEXT     Database to use. Overrides the value specified for the connection.                   │
│ --schema,--schemaname                          TEXT     Database schema to use. Overrides the value specified for the connection.            │
│ --role,--rolename                              TEXT     Role to use. Overrides the value specified for the connection.                       │
│ --warehouse                                    TEXT     Warehouse to use. Overrides the value specified for the connection.                  │
│ --temporary-connection                 -x               Uses connection defined with command line parameters, instead of one defined in      │
│                                                         config                                                                               │
│ --mfa-passcode                                 TEXT     Token to use for multi-factor authentication (MFA)                                   │
│ --enable-diag                                           Run python connector diagnostic test                                                 │
│ --diag-log-path                                TEXT     Diagnostic report path                                                               │
│ --diag-allowlist-path                          TEXT     Diagnostic report path to optional allowlist                                         │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

-- Example 24639
snow helpers import-snowsql-connections

-- Example 24640
snow helpers import-snowsql-connections

-- Example 24641
SnowSQL config file [/etc/snowsql.cnf] does not exist. Skipping.
SnowSQL config file [/etc/snowflake/snowsql.cnf] does not exist. Skipping.
SnowSQL config file [/usr/local/etc/snowsql.cnf] does not exist. Skipping.
Trying to read connections from [/Users/<user>/.snowsql.cnf].
Reading SnowSQL's connection configuration [connections.connection1] from [/Users/<user>/.snowsql.cnf]
Trying to read connections from [/Users/<user>/.snowsql/config].
Reading SnowSQL's default connection configuration from [/Users/<user>/.snowsql/config]
Reading SnowSQL's connection configuration [connections.connection1] from [/Users/<user>/.snowsql/config]
Reading SnowSQL's connection configuration [connections.connection2] from [/Users/<user>/.snowsql/config]
Connection 'connection1' already exists in Snowflake CLI, do you want to use SnowSQL definition and override existing connection in Snowflake CLI? [y/N]: Y
Connection 'connection2' already exists in Snowflake CLI, do you want to use SnowSQL definition and override existing connection in Snowflake CLI? [y/N]: n
Connection 'default' already exists in Snowflake CLI, do you want to use SnowSQL definition and override existing connection in Snowflake CLI? [y/N]: n
Saving [connection1] connection in Snowflake CLI's config.
Connections successfully imported from SnowSQL to Snowflake CLI.

-- Example 24642
snow sql -q "select 42;" --temporary-connection \
                           --account myaccount \
                           --user jdoe

-- Example 24643
select 42;
+----+
| 42 |
|----|
| 42 |
+----+

-- Example 24644
SNOWFLAKE_ACCOUNT = "account"
SNOWFLAKE_USER = "user"
SNOWFLAKE_PRIVATE_KEY_FILE = "/path/to/key.p8"

-- Example 24645
snow sql -q "select 42" --temporary-connection

-- Example 24646
select 42;
+----+
| 42 |
|----|
| 42 |
+----+

-- Example 24647
SNOWFLAKE_ACCOUNT = "account"
SNOWFLAKE_USER = "user"
SNOWFLAKE_PRIVATE_KEY_RAW = "-----BEGIN PRIVATE KEY-----..."

-- Example 24648
snow sql -q "select 42" --temporary-connection

-- Example 24649
select 42;
+----+
| 42 |
|----|
| 42 |
+----+

-- Example 24650
snow connection add \
   --connection-name jwt \
   --authenticator SNOWFLAKE_JWT \
   --private-key-file ~/.ssh/sf_private_key.p8

-- Example 24651
[connections.jwt]
account = "my_account"
user = "jdoe"
authenticator = "SNOWFLAKE_JWT"
private_key_file = "~/sf_private_key.p8"

-- Example 24652
snow connection add --token-file-path "my-token.txt"

-- Example 24653
[connections.oauth]
account = "my_account"
user = "jdoe"
authenticator = "oauth"
token_file_path = "my-token.txt"

-- Example 24654
snow connection add --authenticator externalbrowser

-- Example 24655
[connections.externalbrowser]
account = "my_account"
user = "jdoe"
authenticator = "externalbrowser"

-- Example 24656
definition_version: 2
entities:
  pkg:
    type: application package
    identifier: <name_of_app_pkg>
    stage: app_src.stage
    manifest: app/manifest.yml
    artifacts:
      - src: app/*
        dest: ./
      - src: src/module-add/target/add-1.0-SNAPSHOT.jar
        dest: module-add/add-1.0-SNAPSHOT.jar
      - src: src/module-ui/src/*
        dest: streamlit/
    meta:
      role: <your_app_pkg_owner_role>
      warehouse: <your_app_pkg_warehouse>
      post_deploy:
        - sql_script: scripts/any-provider-setup.sql
        - sql_script: scripts/shared-content.sql
  app:
    type: application
    identifier: <name_of_app>
    from:
      target: pkg
    debug: <true|false>
    meta:
      role: <your_app_owner_role>
      warehouse: <your_app_warehouse>

-- Example 24657
definition_version: 2
entities:
  myapp_pkg:
    type: application package
    ...
    meta:
      post_deploy:
        - sql_script: scripts/post_deploy1.sql
        - sql_script: scripts/post_deploy2.sql

-- Example 24658
GRANT reference_usage on database provider_data to share in entity <% fn.str_to_id(ctx.entities.myapp_pkg.identifier) %>

-- Example 24659
pkg:
  artifacts:
    - src: app/*
      dest: ./
    - src: streamlit/*
      dest: streamlit/
    - src: src/resources/images/snowflake.png
      dest: streamlit/

-- Example 24660
pkg:
  artifacts:
    - src: qpp/*
      dest: ./
      processors:
          - name: snowpark
            properties:
              env:
                type: conda
                name: <conda_name>

-- Example 24661
from:
  target: my_pkg

-- Example 24662
telemetry:
  share_mandatory_events: true

-- Example 24663
telemetry:
  share_mandatory_events: true
  optional_shared_events:
    - DEBUG_LOGS

-- Example 24664
definition_version: 2
entities:
  app:
    type: application
    from:
      target: pkg
    telemetry:
      share_mandatory_events: true
      optional_shared_events:
        - DEBUG_LOGS

...

-- Example 24665
configuration:
    telemetry_event_definitions:
        - type: ERRORS_AND_WARNINGS
          sharing: MANDATORY
        - type: DEBUG_LOGS
          sharing: OPTIONAL

-- Example 24666
definition_version: 2
entities:
  app:
    type: application
    from:
      target: pkg
    telemetry:
      share_mandatory_events: true

-- Example 24667
definition_version: 2
entities:
  app:
    type: application
    from:
      target: pkg
    telemetry:
      share_mandatory_events: true
      optional_shared_events:
        - DEBUG_LOGS

-- Example 24668
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark
            properties:
              env:
                type: conda
                name: <conda_name>

-- Example 24669
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark
            properties:
              env:
                type: venv
                path: <venv_path>

-- Example 24670
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark
            properties:
              env:
                type: current

-- Example 24671
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark

-- Example 24672
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - snowpark

-- Example 24673
definition_version: 2
entities:
  pkg:
    type: application package
    identifier: myapp_pkg
    artifacts:
      - src: app/*
        dest: ./
        processors:
          - templates
    manifest: app/manifest.yml
  app:
    type: application
    identifier: myapp_<% fn.get_username() %>
    from:
      target: pkg

-- Example 24674
This is a README file for application package <% ctx.entities.pkg.identifier %>.

-- Example 24675
This is a README file for application package myapp_pkg.

-- Example 24676
entities:
  pkg:
    meta:
      role: <your_app_pkg_owner_role>
      name: <name_of_app_pkg>
      warehouse: <your_app_pkg_warehouse>
  app:
    debug: <true|false>
    meta:
      role: <your_app_owner_role>
      name: <name_of_app>
      warehouse: <your_app_warehouse>

-- Example 24677
import net.snowflake.ingest.SimpleIngestManager;
import net.snowflake.ingest.connection.HistoryRangeResponse;
import net.snowflake.ingest.connection.HistoryResponse;
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
import java.time.Instant;
import java.util.Set;
import java.util.TreeSet;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

public class SDKTest
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

  private static HistoryResponse waitForFilesHistory(SimpleIngestManager manager,
                                                     Set<String> files)
          throws Exception
  {
    ExecutorService service = Executors.newSingleThreadExecutor();

    class GetHistory implements
            Callable<HistoryResponse>
    {
      private Set<String> filesWatchList;
      GetHistory(Set<String> files)
      {
        this.filesWatchList = files;
      }
      String beginMark = null;

      public HistoryResponse call()
              throws Exception
      {
        HistoryResponse filesHistory = null;
        while (true)
        {
          Thread.sleep(500);
          HistoryResponse response = manager.getHistory(null, null, beginMark);
          if (response.getNextBeginMark() != null)
          {
            beginMark = response.getNextBeginMark();
          }
          if (response != null && response.files != null)
          {
            for (HistoryResponse.FileEntry entry : response.files)
            {
              //if we have a complete file that we've
              // loaded with the same name..
              String filename = entry.getPath();
              if (entry.getPath() != null && entry.isComplete() &&
                      filesWatchList.contains(filename))
              {
                if (filesHistory == null)
                {
                  filesHistory = new HistoryResponse();
                  filesHistory.setPipe(response.getPipe());
                }
                filesHistory.files.add(entry);
                filesWatchList.remove(filename);
                //we can return true!
                if (filesWatchList.isEmpty()) {
                  return filesHistory;
                }
              }
            }
          }
        }
      }
    }

    GetHistory historyCaller = new GetHistory(files);
    //fork off waiting for a load to the service
    Future<HistoryResponse> result = service.submit(historyCaller);

    HistoryResponse response = result.get(2, TimeUnit.MINUTES);
    return response;
  }

  public static void main(String[] args)
  {
    final String host = "<account_identifier>.snowflakecomputing.com";
    final String user = "<user_login_name>";
    final String pipe = "<db_name>.<schema_name>.<pipe_name>";
    try
    {
      final long oneHourMillis = 1000 * 3600L;
      String startTime = Instant
              .ofEpochMilli(System.currentTimeMillis() - 4 * oneHourMillis).toString();
      final PrivateKey privateKey = PrivateKeyReader.get(PRIVATE_KEY_FILE);
      SimpleIngestManager manager = new SimpleIngestManager(host.split("\.")[0], user, pipe, privateKey, "https", host, 443);
      List<StagedFileWrapper> files = new ArrayList<>();
      // Add the paths and sizes the files that you want to load.
      // Use paths that are relative to the stage where the files are located
      // (the stage that is specified in the pipe definition)..
      files.add(new StagedFileWrapper("<path>/<filename>", <file_size_in_bytes> /* file size is optional but recommended, pass null when it is not available */));
      files.add(new StagedFileWrapper("<path>/<filename>", <file_size_in_bytes> /* file size is optional but recommended, pass null when it is not available */));
      ...
      manager.ingestFiles(files, null);
      HistoryResponse history = waitForFilesHistory(manager, files);
      System.out.println("Received history response: " + history.toString());
      String endTime = Instant
              .ofEpochMilli(System.currentTimeMillis()).toString();

      HistoryRangeResponse historyRangeResponse =
              manager.getHistoryRange(null,
                                      startTime,
                                      endTime);
      System.out.println("Received history range response: " +
                                 historyRangeResponse.toString());

    }
    catch (Exception e)
    {
      e.printStackTrace();
    }

  }
}

-- Example 24678
from logging import getLogger
from snowflake.ingest import SimpleIngestManager
from snowflake.ingest import StagedFile
from snowflake.ingest.utils.uris import DEFAULT_SCHEME
from datetime import timedelta
from requests import HTTPError
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.serialization import Encoding
from cryptography.hazmat.primitives.serialization import PrivateFormat
from cryptography.hazmat.primitives.serialization import NoEncryption
import time
import datetime
import os
import logging

logging.basicConfig(
        filename='/tmp/ingest.log',
        level=logging.DEBUG)
logger = getLogger(__name__)

# If you generated an encrypted private key, implement this method to return
# the passphrase for decrypting your private key.
def get_private_key_passphrase():
  return '<private_key_passphrase>'

with open("/<private_key_path>/rsa_key.p8", 'rb') as pem_in:
  pemlines = pem_in.read()
  private_key_obj = load_pem_private_key(pemlines,
  get_private_key_passphrase().encode(),
  default_backend())

private_key_text = private_key_obj.private_bytes(
  Encoding.PEM, PrivateFormat.PKCS8, NoEncryption()).decode('utf-8')
# Assume the public key has been registered in Snowflake:
# private key in PEM format

ingest_manager = SimpleIngestManager(account='<account_identifier>',
                                     host='<account_identifier>.snowflakecomputing.com',
                                     user='<user_login_name>',
                                     pipe='<db_name>.<schema_name>.<pipe_name>',
                                     private_key=private_key_text)
# List of files, but wrapped into a class
staged_file_list = [
  StagedFile('<path>/<filename>', <file_size_in_bytes>),  # file size is optional but recommended, pass None if not available
  StagedFile('<path>/<filename>', <file_size_in_bytes>),  # file size is optional but recommended, pass None if not available
  ...
  ]

try:
    resp = ingest_manager.ingest_files(staged_file_list)
except HTTPError as e:
    # HTTP error, may need to retry
    logger.error(e)
    exit(1)

# This means Snowflake has received file and will start loading
assert(resp['responseCode'] == 'SUCCESS')

# Needs to wait for a while to get result in history
while True:
    history_resp = ingest_manager.get_history()

    if len(history_resp['files']) > 0:
        print('Ingest Report:\n')
        print(history_resp)
        break
    else:
        # wait for 20 seconds
        time.sleep(20)

    hour = timedelta(hours=1)
    date = datetime.datetime.utcnow() - hour
    history_range_resp = ingest_manager.get_history_range(date.isoformat() + 'Z')

    print('\nHistory scan report: \n')
    print(history_range_resp)

-- Example 24679
CREATE OR ALTER execution failed. Partial updates may have been applied.

-- Example 24680
snow object create
  <object_type>
  <object_attributes>
  --json <object_json>
  --if-not-exists
  --replace
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

-- Example 24681
snow object create database name=my_db comment="Created with Snowflake CLI"

-- Example 24682
snow object create table name=my_table columns='[{"name":"col1","datatype":"number", "nullable":false}]' constraints='[{"name":"prim_key", "column_names":["col1"], "constraint_type":"PRIMARY KEY"}]' --database my_db

-- Example 24683
snow object create database name=my_db comment='Created with Snowflake CLI'

-- Example 24684
snow object create table name=my_table columns='[{"name":"col1","datatype":"number", "nullable":false}]' constraints='[{"name":"prim_key", "column_names":["col1"], "constraint_type":"PRIMARY KEY"}]' --database my_db

-- Example 24685
snow object create database --json '{"name":"my_db", "comment":"Created with Snowflake CLI"}'

-- Example 24686
snow object create table --json "$(cat table.json)" --database my_db

-- Example 24687
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

-- Example 24688
CREATE FAILOVER GROUP [ IF NOT EXISTS ] <name>
    OBJECT_TYPES = <object_type> [ , <object_type> , ... ]
    [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
    [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]
    [ ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> , ... ] ]
    ALLOWED_ACCOUNTS = <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ]
    [ IGNORE EDITION CHECK ]
    [ REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }' ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ ERROR_INTEGRATION = <integration_name> ]

-- Example 24689
CREATE FAILOVER GROUP [ IF NOT EXISTS ] <secondary_name>
    AS REPLICA OF <org_name>.<source_account_name>.<name>

-- Example 24690
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 24691
CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 24692
CREATE FAILOVER GROUP myfg
    AS REPLICA OF myorg.myaccount1.myfg;

-- Example 24693
CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1, db2, db3
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 24694
CREATE FAILOVER GROUP myfg
    AS REPLICA OF myorg.myaccount1.myfg;

-- Example 24695
CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, INTEGRATIONS
    ALLOWED_INTEGRATION_TYPES = STORAGE INTEGRATIONS, NOTIFICATION INTEGRATIONS
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 24696
CREATE FAILOVER GROUP myfg
    AS REPLICA OF myorg.myaccount1.myfg;

-- Example 24697
SELECT t_unprotected.email
  FROM t_unprotected JOIN t_protected ON t_unprotected.email = t_protected.email;

