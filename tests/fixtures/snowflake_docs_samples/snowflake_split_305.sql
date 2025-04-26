-- Example 20413
// Specify the number of statements that we expect to execute.
statement.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 3);

-- Example 20414
// Create a string that contains multiple SQL statements.
String command_string = "create table test(n int); " +
                        "insert into test values (1), (2); " +
                        "select * from test order by n";
Statement stmt = connection.createStatement();
// Specify the number of statements (3) that we expect to execute.
stmt.unwrap(SnowflakeStatement.class).setParameter(
        "MULTI_STATEMENT_COUNT", 3);

// Execute all of the statements.
stmt.execute(command_string);                       // false

// --- Get results. ---
// First statement (create table)
stmt.getUpdateCount();                              // 0 (DDL)

// Second statement (insert)
stmt.getMoreResults();                              // true
stmt.getUpdateCount();                              // 2

// Third statement (select)
stmt.getMoreResults();                              // true
ResultSet rs = stmt.getResultSet();
rs.next();                                          // true
rs.getInt(1);                                       // 1
rs.next();                                          // true
rs.getInt(1);                                       // 2
rs.next();                                          // false

// Past the last statement executed.
stmt.getMoreResults();                              // false
stmt.getUpdateCount();                              // 0 (no more results)

-- Example 20415
CREATE OR REPLACE TABLE test(n int);
INSERT INTO TEST VALUES (1), (2);
INSERT INTO TEST VALUES ('not_an_int');  -- execution fails here
INSERT INTO TEST VALUES (3);

-- Example 20416
stmt.execute("UPDATE table1 SET integer_column = 42 WHERE ID = 1000");

-- Example 20417
int my_integer_variable = 42;
PreparedStatement pstmt = connection.prepareStatement("UPDATE table1 SET integer_column = ? WHERE ID = 1000");
pstmt.setInt(1, my_integer_variable);
pstmt.executeUpdate();

-- Example 20418
// The following call interprets the timestamp in terms of the local time zone.
insertStmt.setTimestamp(1, myTimestamp);
// The following call interprets the timestamp in terms of the time zone of the Calendar object.
insertStmt.setTimestamp(1, myTimestamp, Calendar.getInstance(TimeZone.getTimeZone("America/New_York")));

-- Example 20419
import net.snowflake.client.jdbc.SnowflakeUtil;
...
insertStmt.setObject(1, myTimestamp, SnowflakeUtil.EXTRA_TYPES_TIMESTAMP_NTZ);

-- Example 20420
Connection connection = DriverManager.getConnection(url, prop);
connection.setAutoCommit(false);

PreparedStatement pstmt = connection.prepareStatement("INSERT INTO t(c1, c2) VALUES(?, ?)");
pstmt.setInt(1, 101);
pstmt.setString(2, "test1");
pstmt.addBatch();

pstmt.setInt(1, 102);
pstmt.setString(2, "test2");
pstmt.addBatch();

int[] count = pstmt.executeBatch(); // After execution, count[0]=1, count[1]=1
connection.commit();

-- Example 20421
CREATE TEMPORARY STAGE SYSTEM$BIND file_format=(type=csv field_optionally_enclosed_by='"')
Cannot perform CREATE STAGE. This session does not have a current schema. Call 'USE SCHEMA', or use a qualified name.

-- Example 20422
I/O error: Connection reset

-- Example 20423
// Set the "time to live" to 60 seconds.
System.setProperty("net.snowflake.jdbc.ttl", "60")

-- Example 20424
# Set the "time to live" to 60 seconds.
java -cp .:snowflake-jdbc-<version>.jar -Dnet.snowflake.jdbc.ttl=60 <ClassName>

-- Example 20425
String user = "<user>";          // replace "<user>" with your user name
String password = "<password>";  // replace "<password>" with your password
Connection con = DriverManager.getConnection("jdbc:snowflake://<account>.snowflakecomputing.com/", user, password);

-- Example 20426
String user = "<user>";          // replace "<user>" with your user name
String password = "<password>";  // replace "<password>" with your password
Properties props = new Properties();
props.put("user", user);
props.put("password", password);
Connection con = DriverManager.getConnection("jdbc:snowflake://<account>.snowflakecomputing.com/", props);

-- Example 20427
Properties props = new Properties();
props.put("user", "myusername");
props.put("authenticator", "oauth");
props.put("role", "myrole");
props.put("password", "xxxxxxxxxxxxx"); // where xxxxxxxxxxxxx is the token string
Connection myconnection = DriverManager.getConnection(url, props);

-- Example 20428
net.snowflake.client.jdbc.SnowflakeSQLException: A connection was not created because the driver is running in diagnostics mode. If this is unintended then disable diagnostics check by removing the ENABLE_DIAGNOSTICS connection parameter

-- Example 20429
com.fasterxml.jackson.core.exc.StreamConstraintsException: String length (XXXXXXX) exceeds the maximum length (180000000)

-- Example 20430
npm install snowflake-sdk

-- Example 20431
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

-- Example 20432
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

-- Example 20433
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

-- Example 20434
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

-- Example 20435
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

-- Example 20436
const connection = snowflake.createConnection({
    account: process.env.SNOWFLAKE_TEST_ACCOUNT,
    username: process.env.SNOWFLAKE_TEST_USER,
    ...
    authenticator: 'USERNAME_PASSWORD_MFA',
    password: "abc123987654", // passcode 987654 is part of the password
    passcodeInPassword: true  // because passcodeInPassword is true
});

-- Example 20437
const connection = snowflake.createConnection({
    account: process.env.SNOWFLAKE_TEST_ACCOUNT,
    username: process.env.SNOWFLAKE_TEST_USER,
    ...
    authenticator: 'USERNAME_PASSWORD_MFA',
    password: "abc123", // password and MFA passcode are input separately
    passcode: "987654"
});

-- Example 20438
ALTER ACCOUNT SET ALLOW_ID_TOKEN = TRUE;

-- Example 20439
const connection = snowflake.createConnection({
  account: process.env.SNOWFLAKE_TEST_ACCOUNT,
  username: process.env.SNOWFLAKE_TEST_USER,
  database: process.env.SNOWFLAKE_TEST_DATABASE,
  schema: process.env.SNOWFLAKE_TEST_SCHEMA,
  warehouse: process.env.SNOWFLAKE_TEST_WAREHOUSE,
  authenticator: 'EXTERNALBROWSER',
  clientStoreTemporaryCredential: true,
});

-- Example 20440
ALTER ACCOUNT SET ALLOW_CLIENT_MFA_CACHING = TRUE;

-- Example 20441
const connection = snowflake.createConnection({
  account: process.env.SNOWFLAKE_TEST_ACCOUNT,
  username: process.env.SNOWFLAKE_TEST_USER,
  database: process.env.SNOWFLAKE_TEST_DATABASE,
  schema: process.env.SNOWFLAKE_TEST_SCHEMA,
  warehouse: process.env.SNOWFLAKE_TEST_WAREHOUSE,
  authenticator: 'USERNAME_PASSWORD_MFA',
  clientRequestMFAToken: true,
});

-- Example 20442
const connection = snowflake.createConnection({
          credentialCacheDir: "../../<folder name>",
});

-- Example 20443
const connection = snowflake.createConnection({
          credentialCacheDir: "C:\\<folder name>\\<subfolder name>",
});

-- Example 20444
const sampleCustomManager = {
  read: function (key) {
  //(do something with the key)
    return token;
  },
  write: function (key, token) {
  //(do something with the key and token)
  },
  remove: function (key) {
    //(do something with the key)
  }
};

-- Example 20445
const myCredentialManager = require('<your custom credential manager module>')
const snowflake = require('snowflake-sdk');

snowflake.configure({
  customCredentialManager: myCredentialManager
})

const connection = snowflake.createConnection({
  account: process.env.SNOWFLAKE_TEST_ACCOUNT,
  database: process.env.SNOWFLAKE_TEST_DATABASE,
  schema: process.env.SNOWFLAKE_TEST_SCHEMA,
  warehouse: process.env.SNOWFLAKE_TEST_WAREHOUSE,
  authenticator: 'USERNAME_PASSWORD_MFA',
  clientRequestMFAToken: true,
});

-- Example 20446
var statement = connection.execute({
  sqlText: 'CREATE DATABASE testdb',
  complete: function(err, stmt, rows) {
    if (err) {
      console.error('Failed to execute statement due to the following error: ' + err.message);
    } else {
      console.log('Successfully executed statement: ' + stmt.getSqlText());
    }
  }
});

-- Example 20447
let queryId;
let statement;

// 1. Execute query with asyncExec set to true
await new Promise((resolve) =>
{
  connection.execute({
    sqlText: 'CALL SYSTEM$WAIT(3, \'SECONDS\')',
    asyncExec: true,
    complete: async function (err, stmt, rows)
    {
      queryId = stmt.getQueryId(); // Get the query ID
      resolve();
    }
  });
});

// 2. Get results using the query ID
const statement = await connection.getResultsFromQueryId({ queryId: queryId });
await new Promise((resolve, reject) =>
{
  var stream = statement.streamRows();
  stream.on('error', function (err)
  {
    reject(err);
  });
  stream.on('data', function (row)
  {
    console.log(row);
  });
  stream.on('end', function ()
  {
    resolve();
  });
});

-- Example 20448
// 1. Execute query with asyncExec set to true
connection.execute({
  sqlText: 'CALL SYSTEM$WAIT(3, \'SECONDS\')',
  asyncExec: true,
  complete: async function (err, stmt, rows)
  {
    let queryId = stmt.getQueryId();

    // 2. Get results using the query ID
    connection.getResultsFromQueryId({
      queryId: queryId,
      complete: async function (err, _stmt, rows)
      {
        console.log(rows);
      }
    });
  }
});

-- Example 20449
let queryId;

// 1. Execute query with asyncExec set to true
await new Promise((resolve, reject) =>
{
  statement = connection.execute({
    sqlText: 'CALL SYSTEM$WAIT(3, \'SECONDS\')',
    asyncExec: true,
    complete: async function (err, stmt, rows)
    {
      queryId = statement.getQueryId();
      resolve();
    }
  });
});

// 2. Check query status until it's finished executing
const seconds = 2;
let status = await connection.getQueryStatus(queryId);
while (connection.isStillRunning(status))
{
  console.log(`Query status is ${status}, timeout for ${seconds} seconds`);

  await new Promise((resolve) =>
  {
    setTimeout(() => resolve(), 1000 * seconds);
  });

  status = await connection.getQueryStatus(queryId);
}

console.log(`Query has finished executing, status is ${status}`);

-- Example 20450
ALTER SESSION SET multi_statement_count = <n>

-- Example 20451
var statement = connection.execute({
    sqlText: "ALTER SESSION SET multi_statement_count=0",
    complete: function (err, stmt, rows) {
      if (err) {
        console.error('1 Failed to execute statement due to the following error: ' + err.message);
      } else {
        testMulti();
      }
    }
  });
function testMulti() {
  console.log('select bind execute.');
  var selectStatement = connection.execute({
    sqlText: "create or replace table test(n int); insert into test values(1), (2); select * from test order by n",
    complete: function (err, stmt, rows) {
      if (err) {
        console.error('1 Failed to execute statement due to the following error: ' + err.message);
      }
      else {
        console.log('==== complete');
        console.log('==== sqlText=' + stmt.getSqlText());
        if(stmt.hasNext())
        {
          stmt.NextResult();
        }
        else {
          // do something else, e.g. close the connection
        }
      }
    }
  });
}

-- Example 20452
var selectStatement = connection.execute({
    sqlText: "CREATE OR REPLACE TABLE test(n int); INSERT INTO test values(1), (2); SELECT * FROM test ORDER BY n",
    parameters: { MULTI_STATEMENT_COUNT: 3 },
    complete: function (err, stmt, rows) {
      if (err) {
        console.error('1 Failed to execute statement due to the following error: ' + err.message);
      }
      else {
        console.log('==== complete');
        console.log('==== sqlText=' + stmt.getSqlText());
        if(stmt.hasNext())
        {
          stmt.NextResult();
        }
        else {
          // do something else, e.g. close the connection
        }
      }
    }
  });

-- Example 20453
connection.execute({
  sqlText: 'SELECT c1 FROM (SELECT 1 AS c1 UNION ALL SELECT 2 AS c1) WHERE c1 = 1;'
});

-- Example 20454
connection.execute({
  sqlText: 'SELECT c1 FROM (SELECT :1 AS c1 UNION ALL SELECT :2 AS c1) WHERE c1 = :1;',
  binds: [1, 2]
});

-- Example 20455
connection.execute({
p
  sqlText: 'SELECT c1 FROM (SELECT ? AS c1 UNION ALL SELECT ? AS c1) WHERE c1 = ?;',
  binds: [1, 2, 1]
});

-- Example 20456
connection.execute({
  sqlText: 'INSERT INTO t(c1, c2, c3) values(?, ?, ?)',
  binds: [[1, 'string1', 2.0], [2, 'string2', 4.0], [3, 'string3', 6.0]]
});

-- Example 20457
create or replace table test(id int, foo variant);

-- Example 20458
// standard stuff like defining connection, etc
var statement = connection.execute({
    // table columns are id: int, foo: variant
    sqlText: 'insert into test_db.public.test select value:id, value:foo from table(flatten(parse_json(?)))',
    binds: [JSON.stringify([
    {id: 1, foo: [{a: '1', b: '2'}]},
    {id: 2, foo: [{c: '3', d: '4'}]}
    ])],
    complete: function(err, stmt, rows) {
        if (err) {
            console.error('Failed to execute statement due to the following error: ' + err.message);
        } else {
            console.log('[queryID ' + statement.getStatementId() + ', requestId ' + statement.getRequestId() + '] Number of rows produced: ' + rows.length);
            // rest of the code
          }
    }
});

-- Example 20459
statement.cancel(function(err, stmt) {
  if (err) {
    console.error('Unable to abort statement due to the following error: ' + err.message);
  } else {
    console.log('Successfully aborted statement');
  }
});

-- Example 20460
var requestId;
connection.execute({
  sqlText: 'INSERT INTO testTable VALUES (1);',
    complete: function (err, stmt, rows)
    {
      var stream = stmt.streamRows();
      requestId = stmt.getRequestId();   // Retrieves the request ID
      stream.on('data', function (row)
      {
        console.log(row);
      });
      stream.on('end', function (row)
      {
        console.log('done');
      });
    }
});

-- Example 20461
connection.execute({
  sqlText: 'INSERT INTO testTable VALUES (1);',  // optional
    requestId: requestId,  // Uses the request ID from before
    complete: function (err, stmt, rows)
    {
      var stream = stmt.streamRows();
      stream.on('data', function (row)
      {
        console.log(row);
      });
      stream.on('end', function (row)
      {
        console.log('done');
      });
  }
});

-- Example 20462
connection.execute({
  sqlText: 'SELECT * FROM sometable',
  complete: function(err, stmt, rows) {
    if (err) {
      console.error('Failed to execute statement due to the following error: ' + err.message);
    } else {
      console.log('Number of rows produced: ' + rows.length);
    }
  }
});

-- Example 20463
var connection = snowflake.createConnection({
    account: process.env.SFACCOUNT,
    username: process.env.SFUSER,
    // ...
    streamResult: true
});

// [..rest of the code..]

connection.execute({
  sqlText: "select L_COMMENT from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.LINEITEM limit 100000;",
  streamResult: true,
  complete: function (err, stmt)
  {
    var stream = stmt.streamRows();
    // Read data from the stream when it is available
    stream.on('readable', function (row)
    {
      while ((row = this.read()) !== null)
      {
        console.log(row);
      }
    }).on('end', function ()
    {
      console.log('done');
    }).on('error', function (err)
    {
      console.log(err);
    });
  }
});

-- Example 20464
connection.execute({
  sqlText: 'SELECT * FROM sometable',
  streamResult: true, // prevent rows from being returned inline in the complete callback
  complete: function(err, stmt, rows) {
    // no rows returned inline because streamResult was set to true
    console.log('rows: ' + rows); // 'rows: undefined'

    // only consume at most the last 5 rows in the result
    rows = [];
    stmt.streamRows({
      start: Math.max(0, stmt.getNumRows() - 5),
      end: stmt.getNumRows() - 1,
    })
    .on('error', function(err) {
      console.error('Unable to consume requested rows');
    })
    .on('data', function(row) {
      rows.push(row);
    })
    .on('end', function() {
      console.log('Number of rows consumed: ' + rows.length);
    });
  }
})

-- Example 20465
connection.execute( {
                    sqlText: 'ALTER SESSION SET JS_TREAT_INTEGER_AS_BIGINT = TRUE',
                    complete: function ...
                    }
                  );

-- Example 20466
var connection = snowflake.createConnection(
      {
      username: 'fakeusername',
      password: 'fakepassword',
      account: 'fakeaccountidentifier',
      jsTreatIntegerAsBigInt: true
      }
    );

-- Example 20467
connection.execute({
  sqlText: 'SELECT 1.123456789123456789123456789 as "c1"',
  fetchAsString: ['Number'],
  complete: function(err, stmt, rows) {
    if (err) {
      console.error('Failed to execute statement due to the following error: ' + err.message);
    } else {
      console.log('c1: ' + rows[0].c1); // c1: 1.123456789123456789123456789
    }
  }
});

-- Example 20468
<exhibit name="Art Show">
  <piece id="000001">
    <name>Mona Lisa</name>
    <artist>Leonardo da Vinci</artist>
    <year>1503</year>
  </piece>
  <piece id="000002">
    <name>The Starry Night</name>
    <artist>Vincent van Gogh</artist>
    <year>1889</year>
  </piece>
</exhibit>

-- Example 20469
{
  exhibit: {
    piece: [
      {
        "name": "Mona Lisa",
        "artist": "Leonardo da Vinci",
        "year": "1503",
      },
      {
        "name": "The Starry Night",
        "artist": "Vincent van Gogh",
        "year": "1889",
      }
    ]
  }
}

-- Example 20470
const snowflake = require('snowflake-sdk');
snowflake.configure({
  xmlParserConfig: {
    /*  Parameters that you can override
    *   ignoreAttributes - default true,
    *   attributeNamePrefix - default '@_',
    *   attributesGroupName - default unset,
    *   alwaysCreateTextNode - default false
    */
    ignoreAttributes: false, attributesGroupName: '@', attributeNamePrefix: ''
  }
});

-- Example 20471
{
  exhibit: {
    piece: [
      {
        "name": "Mona Lisa",
        "artist": "Leonardo da Vinci",
        "year": "1503",
        '@': { id: '000001' }
      },
      {
        "name": "The Starry Night",
        "artist": "Vincent van Gogh",
        "year": "1889",
        '@': { id: '000002' }
      }
    ],
    '@': { name: 'Art Show' }
  }

-- Example 20472
select *
from (select 'a' as key, 1 as foo, 3 as name) as table1
join (select 'a' as key, 2 as foo, 3 as name2) as table2 on table1.key = table2.key
join (select 'a' as key, 3 as foo) as table3 on table1.key = table3.key

-- Example 20473
{KEY: 'a', FOO: 3, NAME: 3, NAME2: 3};

-- Example 20474
['a', 1, 3, 'a', 2, 3, 'a', 3];

-- Example 20475
{KEY: 'a', FOO: 1, NAME: 3, KEY_2: 'a', FOO_2: 2, NAME2: 3, KEY_3: 'a', FOO_3: 3};

-- Example 20476
snowflake.createConnection({
  account: account,
  username: username,
  ...
  rowMode: 'array'})

-- Example 20477
connection.execute({
  sqlText: sql,
  rowMode: 'array',
  ...
  )}

-- Example 20478
const snowflake = require('snowflake-sdk');
snowflake.configure({
  jsonColumnVariantParser: rawColumnValue => JSON.parse(rawColumnValue)
})

-- Example 20479
const snowflake = require('snowflake-sdk');
snowflake.configure({
  xmlColumnVariantParser: rawColumnValue => new (require("fast-xml-parser")).XMLParser().parse(rawColumnValue)
})

