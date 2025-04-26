-- Example 14050
from snowflake.core.database_role import DatabaseRole

my_db_role = DatabaseRole(
  name="my_db_role",
  comment="sample comment"
)

my_db_role_ref = root.databases['my_db'].database_roles.create(my_db_role)

-- Example 14051
database_role_ref = root.databases['my_db'].database_roles['dr1'].clone(target_database_role='dr2', target_database='my_db_2')

-- Example 14052
db_role_list = root.databases['my_db'].database_roles.iter(limit=1, from_name='my_db_role')
for db_role_obj in db_role_list:
  print(db_role_obj.name)

-- Example 14053
root.databases['my_db'].database_roles['my_db_role'].drop()

-- Example 14054
from snowflake.core.role import Securable

root.roles['my_role'].grant_privileges(
    privileges=["OPERATE"], securable_type="WAREHOUSE", securable=Securable(name='my_wh')
)

-- Example 14055
from snowflake.core.role import Securable

root.roles['my_role'].grant_role(role_type="ROLE", role=Securable(name='my_role_1'))

-- Example 14056
from snowflake.core.role import ContainingScope

root.roles['my_role'].grant_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14057
from snowflake.core.role import ContainingScope

root.roles['my_role'].grant_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14058
from snowflake.core.role import Securable

root.roles['my_role'].revoke_privileges(
    privileges=["OPERATE"], securable_type="WAREHOUSE", securable=Securable(name='my_wh')
)

-- Example 14059
from snowflake.core.role import Securable

root.roles['my_role'].revoke_role(role_type="ROLE", role=Securable(name='my_role_1'))

-- Example 14060
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14061
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14062
from snowflake.core.role import Securable

 root.roles['my_role'].revoke_grant_option_for_privileges(
    privileges=["OPERATE"], securable_type="WAREHOUSE", securable=Securable(name='my_wh')
)

-- Example 14063
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_grant_option_for_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14064
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_grant_option_for_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14065
root.roles['my_role'].iter_grants_to()

-- Example 14066
root.roles['my_role'].iter_grants_on()

-- Example 14067
root.roles['my_role'].iter_grants_of()

-- Example 14068
root.roles['my_role'].iter_future_grants_to()

-- Example 14069
from snowflake.core.user import Securable

root.users['my_user'].grant_role(role_type="ROLE", role=Securable(name='my_role'))

-- Example 14070
from snowflake.core.user import Securable

root.users['my_user'].revoke_role(role_type="ROLE", role=Securable(name='my_role'))

-- Example 14071
root.users['my_user'].iter_grants_to()

-- Example 14072
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].grant_privileges(
    privileges=["MODIFY"], securable_type="DATABASE", securable=Securable(name='my_db')
)

-- Example 14073
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].grant_role(role_type="DATABASE ROLE", role=Securable(name='my_db_role_1'))

-- Example 14074
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].grant_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14075
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].grant_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14076
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].revoke_privileges(
    privileges=["MODIFY"], securable_type="DATABASE", securable=Securable(name='my_db')
)

-- Example 14077
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].revoke_role(role_type="DATABASE ROLE", role=Securable(name='my_db_role_1'))

-- Example 14078
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14079
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14080
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].revoke_grant_option_for_privileges(
    privileges=["MODIFY"], securable_type="DATABASE", securable=Securable(name='my_db')
)

-- Example 14081
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_grant_option_for_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14082
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_grant_option_for_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 14083
root.databases['my_db'].database_roles['my_db_role'].iter_grants_to()

-- Example 14084
root.databases['my_db'].database_roles['my_db_role'].iter_future_grants_to()

-- Example 14085
from snowflake.core.grant import Grant
from snowflake.core.grant._grantee import Grantees
from snowflake.core.grant._privileges import Privileges
from snowflake.core.grant._securables import Securables

root.grants.grant(
  Grant(
    grantee=Grantees.role(name='my_role'),
    securable=Securables.current_account,
    privileges=[Privileges.create_database,
                Privileges.create_warehouse],
  )
)

-- Example 14086
from snowflake.core.grant import Grant
from snowflake.core.grant._grantee import Grantees
from snowflake.core.grant._privileges import Privileges
from snowflake.core.grant._securables import Securables

root.grants.grant(
  Grant(
    grantee=Grantees.role('my_role'),
    securable=Securables.database('my_db'),
    privileges=[Privileges.imported_privileges],
  )
)

-- Example 14087
from snowflake.core.grant import Grant
from snowflake.core.grant._grantee import Grantees
from snowflake.core.grant._securables import Securables

root.grants.grant(
  Grant(
    grantee=Grantees.role('ACCOUNTADMIN'),
    securable=Securables.role('my_role'),
  )
)

-- Example 14088
$ snowsql -a <account_identifier> -u <user> --private-key-path <path>/rsa_key.p8

-- Example 14089
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token=<oauth_token>

-- Example 14090
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token="<oauth_token>"

-- Example 14091
POST /api/v2/databases/{database}/schemas/{schema}/tasks
(request body)

-- Example 14092
def create_task(task_name, create_mode):
    """
    Create a task given the task name and create mode
    """
    headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + generate_JWT_token(),
    "Accept": "application/json",
    "User-Agent": "myApplicationName/1.0"
    }
    request_body = {
        "name": task_name,
        "warehouse": "myWarehouse",
        "definition": "select 1"
    }
    request_url = "{}/api/v2/databases/{}/schemas/{}/tasks?createMode={}".format(SNOWFLAKE_URL, DATABASE_NAME, SCHEMA_NAME, create_mode)
    response = requests.post(request_url, json=request_body, headers=headers, timeout=60)
    print_response("POST {}".format(request_url), response)

-- Example 14093
{
  [
      {
          "name": "name_example",
          "warehouse": "test_wh",
          "schedule": {
          "schedule_type": "MINUTES_TYPE",
          "minutes": 10
          },
          "comment": "test_comment",
          "config": {
          "output_dir": "/temp/test_directory/",
          "learning_rate": "0.1"
          },
          "definition": "this task does...",
          "predecessors": [
          "task1",
          "task2",
          "task3"
          ],
          "user_task_managed_initial_warehouse_size": "XSMALL",
          "user_task_timeout_ms": 10,
          "suspend_task_after_num_failures": 3,
          "condition": "select 1",
          "allow_overlapping_execution": false,
          "error_integration": "my_notification_int",
          "created_on": "2024-06-18T01:01:01.111111",
          "id": "task_id",
          "owner": "TASK_ADMIN",
          "owner_role_type": "ADMIN",
          "state": "started",
          "last_committed_on": "2024-06-18T01:01:01.111111",
          "last_suspended_on": "2024-06-18T01:01:01.111111",
          "database_name": "TESTDB",
          "schema_name": "TESTSCHEMA"
      }
  ]
}

-- Example 14094
Location: /api/v2/results/5b3ce6ae-d123-4c27-afb3-8a26422d5f321

-- Example 14095
location = <content of the Location header>

while TRUE {
    sleep for x milliseconds
    response = call GET ( host + location )

    if response is 202
      continue

    if response = 200 {
        <code to extract data from the response header>
        exit
    }
}

-- Example 14096
Link: </api/v2/results/01b66701-0000-001c-0000-0030000b91521?page=0>; rel="first",</api/v2/results/01b66701-0000-001c-0000-0030000b91521?page=1>; rel="next",</api/v2/results/01b66701-0000-001c-0000-0030000b91521?page=9>; rel="last"

-- Example 14097
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token=<oauth_token>

-- Example 14098
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token="<oauth_token>"

-- Example 14099
$ snowsql -a <account_identifier> -u <user> --private-key-path <path>/rsa_key.p8

-- Example 14100
pip install pyjwt

-- Example 14101
from datetime import timedelta, timezone, datetime

# This example relies on the PyJWT module (https://pypi.org/project/PyJWT/).
import jwt

# Construct the fully qualified name of the user in uppercase.
# - Replace <account_identifier> with your account identifier.
#   (See https://docs.snowflake.com/en/user-guide/admin-account-identifier.html .)
# - Replace <user_name> with your Snowflake user name.
account = "<account_identifier>"

# Get the account identifier without the region, cloud provider, or subdomain.
if not '.global' in account:
    idx = account.find('.')
    if idx > 0:
        account = account[0:idx]
    else:
        # Handle the replication case.
        idx = account.find('-')
        if idx > 0:
            account = account[0:idx]

# Use uppercase for the account identifier and user name.
account = account.upper()
user = "<user_name>".upper()
qualified_username = account + "." + user

# Get the current time in order to specify the time when the JWT was issued and the expiration time of the JWT.
now = datetime.now(timezone.utc)

# Specify the length of time during which the JWT will be valid. You can specify at most 1 hour.
lifetime = timedelta(minutes=59)

# Create the payload for the token.
payload = {

    # Set the issuer to the fully qualified username concatenated with the public key fingerprint (calculated in the  previous step).
    "iss": qualified_username + '.' + public_key_fp,

    # Set the subject to the fully qualified username.
    "sub": qualified_username,

    # Set the issue time to now.
    "iat": now,

    # Set the expiration time, based on the lifetime specified for this object.
    "exp": now + lifetime
}

# Generate the JWT. private_key is the private key that you read from the private key file in the previous step when you generated the public key fingerprint.
encoding_algorithm="RS256"
token = jwt.encode(payload, key=private_key, algorithm=encoding_algorithm)

# If you are using a version of PyJWT prior to 2.0, jwt.encode returns a byte string, rather than a string.
# If the token is a byte string, convert it to a string.
if isinstance(token, bytes):
  token = token.decode('utf-8')
decoded_token = jwt.decode(token, key=private_key.public_key(), algorithms=[encoding_algorithm])
print("Generated a JWT with the following payload:\n{}".format(decoded_token))

-- Example 14102
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.primitives.serialization import Encoding
from cryptography.hazmat.primitives.serialization import PublicFormat
from cryptography.hazmat.backends import default_backend
..
import base64
from getpass import getpass
import hashlib
..
# If you generated an encrypted private key, implement this method to return
# the passphrase for decrypting your private key. As an example, this function
# prompts the user for the passphrase.
def get_private_key_passphrase():
    return getpass('Passphrase for private key: ')

# Private key that you will load from the private key file.
private_key = None

# Open the private key file.
# Replace <private_key_file_path> with the path to your private key file (e.g. /x/y/z/rsa_key.p8).
with open('<private_key_file_path>', 'rb') as pem_in:
    pemlines = pem_in.read()
    try:
        # Try to access the private key without a passphrase.
        private_key = load_pem_private_key(pemlines, None, default_backend())
    except TypeError:
        # If that fails, provide the passphrase returned from get_private_key_passphrase().
        private_key = load_pem_private_key(pemlines, get_private_key_passphrase().encode(), default_backend())

# Get the raw bytes of the public key.
public_key_raw = private_key.public_key().public_bytes(Encoding.DER, PublicFormat.SubjectPublicKeyInfo)

# Get the sha256 hash of the raw bytes.
sha256hash = hashlib.sha256()
sha256hash.update(public_key_raw)

# Base64-encode the value and prepend the prefix 'SHA256:'.
public_key_fp = 'SHA256:' + base64.b64encode(sha256hash.digest()).decode('utf-8')

-- Example 14103
POST /api/v2/statements HTTP/1.1
(request body)

-- Example 14104
{
  "statement": "select * from my_table",
  ...
}

-- Example 14105
curl -i -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <jwt>" \
    -H "Accept: application/json" \
    -H "User-Agent: myApplicationName/1.0" \
    -d "@request-body.json" \
    "https://<account_identifier>.snowflakecomputing.com/api/v2/statements"

-- Example 14106
{
  "statement": "select * from T where c1=?",
  "timeout": 60,
  "database": "TESTDB",
  "schema": "TESTSCHEMA",
  "warehouse": "TESTWH",
  "role": "TESTROLE",
  "bindings": {
    "1": {
      "type": "FIXED",
      "value": "123"
    }
  }
}

-- Example 14107
...
"statement": "select * from T where c1=?",
...
"bindings": {
  "1": {
    "type": "FIXED",
    "value": "123"
  }
},
...

-- Example 14108
{
  code: "100037",
  message: "<bind type> value '<value>' is not recognized",
  sqlState: "22018",
  statementHandle: "<ID>"
}

-- Example 14109
POST /api/v2/statements?requestId=ea7b46ed-bdc1-8c32-d593-764fcad64e83&retry=true HTTP/1.1

-- Example 14110
GET /api/v2/statements/{statementHandle}

-- Example 14111
{
  "code": "090001",
  "sqlState": "00000",
  "message": "successfully executed",
  "statementHandle": "e4ce975e-f7ff-4b5e-b15e-bf25f59371ae",
  "statementStatusUrl": "/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"
}

-- Example 14112
{
  ...
  "statementHandles" : [ "019c9fce-0502-f1fc-0000-438300e02412", "019c9fce-0502-f1fc-0000-438300e02416" ],
  ...
}

-- Example 14113
curl -i -X GET \
    -H "Authorization: Bearer <jwt>" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: myApplicationName/1.0" \
    "https://<account_identifier>.snowflakecomputing.com/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"

-- Example 14114
{
  "code": "090001",
  "statementHandle": "536fad38-b564-4dc5-9892-a4543504df6c",
  "sqlState": "00000",
  "message": "successfully executed",
  "createdOn": 1597090533987,
  "statementStatusUrl": "/api/v2/statements/536fad38-b564-4dc5-9892-a4543504df6c",
  "resultSetMetaData" : {
    "numRows" : 50000,
    "format" : "jsonv2",
    "partitionInfo" : [ {
      "rowCount" : 12288,
      "uncompressedSize" : 124067,
      "compressedSize" : 29591
    }, {
      "rowCount" : 37712,
      "uncompressedSize" : 414841,
      "compressedSize" : 84469
    }],
  },
  "data": [
    ["customer1", "1234 A Avenue", "98765", "2021-01-20
    12:34:56.03459878"],
    ["customer2", "987 B Street", "98765", "2020-05-31
    01:15:43.765432134"],
    ["customer3", "8777 C Blvd", "98765", "2019-07-01
    23:12:55.123467865"],
    ["customer4", "64646 D Circle", "98765", "2021-08-03
    13:43:23.0"]
  ]
}

-- Example 14115
{
 "resultSetMetaData": {
  "numRows": 1300,
  "rowType": [
   {
    "name":"ROWNUM",
    "type":"FIXED",
    "length":0,
    "precision":38,
    "scale":0,
    "nullable":false
   }, {
    "name":"ACCOUNT_NAME",
    "type":"TEXT",
    "length":1024,
    "precision":0,
    "scale":0,
    "nullable":false
   }, {
    "name":"ADDRESS",
    "type":"TEXT",
    "length":16777216,
    "precision":0,
    "scale":0,
    "nullable":true
   }, {
    "name":"ZIP",
    "type":"TEXT",
    "length":100,
    "precision":0,
    "scale":0,
    "nullable":true
   }, {
    "name":"CREATED_ON",
    "type":"TIMESTAMP_NTZ",
    "length":0,
    "precision":0,
    "scale":3,
    "nullable":false
   }],
  "partitionInfo": [{
    ... // Partition metadata
  }]
 }
}

-- Example 14116
{
    "resultSetMetaData": {
    "numRows: 103477,
    "format": "jsonv2"
    "rowType": {
      ... // Column metadata.
    },
    "partitionInfo": [{
        "rowCount": 12344,
        "uncompressedSize": 14384873,
      },{
        "rowCount": 47387,
        "uncompressedSize": 76483423,
        "compressedSize": 4342748
      },{
        "rowCount": 43746,
        "uncompressedSize": 43748274,
        "compressedSize": 746323
    }]
  },
  ...
}

