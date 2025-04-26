-- Example 17733
SELECT employee_name FROM employee WHERE employee_department = 'Marketing';
SELECT employee_name FROM employee WHERE employee_department IN ('Marketing', 'Sales');

-- Example 17734
CREATE OR REPLACE HYBRID TABLE ht1pk
  (COL1 NUMBER(38,0) NOT NULL COMMENT 'Primary key',
  COL2 NUMBER(38,0) NOT NULL,
  COL3 VARCHAR(16777216),
  CONSTRAINT PKEY_1 PRIMARY KEY (COL1));

DESCRIBE TABLE ht1pk;

-- Example 17735
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+-------------+-------------+----------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment     | policy name | privacy domain |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+-------------+-------------+----------------|
| COL1 | NUMBER(38,0)      | COLUMN | N     | NULL    | Y           | N          | NULL  | NULL       | Primary key | NULL        | NULL           |
| COL2 | NUMBER(38,0)      | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL        | NULL        | NULL           |
| COL3 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL        | NULL        | NULL           |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+-------------+-------------+----------------+

-- Example 17736
SHOW [ TERSE ] [ HYBRID ] TABLES [ LIKE '<pattern>' ]
                                 [ IN { ACCOUNT | DATABASE [ <db_name> ] | SCHEMA [ <schema_name> ] } ]
                                 [ STARTS WITH '<name_string>' ]
                                 [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 17737
SHOW HYBRID TABLES LIKE 'product_%' IN mydb.myschema;

-- Example 17738
SHOW [ TERSE ] INDEXES
  [ LIKE '<pattern>' ]
  [ IN { ACCOUNT | DATABASE [ <database_name> ] | SCHEMA [ <schema_name> ] | TABLE | TABLE <table_name> } ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 17739
SHOW TERSE INDEXES LIKE '%DEVICE%';

-- Example 17740
+-------------------------------+---------------------------------------+-----------------+---------------+-------------+
| created_on                    | name                                  | kind            | database_name | schema_name |
|-------------------------------+---------------------------------------+-----------------+---------------+-------------|
| 2024-08-29 12:24:49.197 -0700 | SYS_INDEX_SENSOR_DATA_DEVICE1_PRIMARY | KEY_VALUE_INDEX | HT_SENSORS    | HT_SCHEMA   |
| 2024-08-29 12:24:49.197 -0700 | DEVICE_IDX                            | KEY_VALUE_INDEX | HT_SENSORS    | HT_SCHEMA   |
| 2024-08-29 14:03:36.537 -0700 | SYS_INDEX_SENSOR_DATA_DEVICE2_PRIMARY | KEY_VALUE_INDEX | HT_SENSORS    | HT_SCHEMA   |
| 2024-08-29 14:03:36.537 -0700 | DEVICE_IDX                            | KEY_VALUE_INDEX | HT_SENSORS    | HT_SCHEMA   |
+-------------------------------+---------------------------------------+-----------------+---------------+-------------+

-- Example 17741
SHOW INDEXES;
SELECT
    "name", "is_unique", "table", "columns", "included_columns", "database_name", "schema_name"
  FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "included_columns" != '[]';

-- Example 17742
+------------+-----------+---------------------+-------------+------------------+---------------+-------------+
| name       | is_unique | table               | columns     | included_columns | database_name | schema_name |
|------------+-----------+---------------------+-------------+------------------+---------------+-------------|
| DEVICE_IDX | N         | SENSOR_DATA_DEVICE2 | [DEVICE_ID] | [TEMPERATURE]    | HT_SENSORS    | HT_SCHEMA   |
+------------+-----------+---------------------+-------------+------------------+---------------+-------------+

-- Example 17743
SHOW TRANSACTIONS [ IN ACCOUNT ]

-- Example 17744
SHOW TRANSACTIONS;

-- Example 17745
+---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------+
|                  id | user    |         session | name                                 | started_on                    | state   | scope |
|---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------|
| 1721165674582000000 | CALIBAN | 186457423713330 | 551f494d-90ed-438d-b32b-1161396c3a22 | 2024-07-16 14:34:34.582 -0700 | running |     0 |
| 1721165584820000000 | CALIBAN | 186457423749354 | a092aa44-9a0a-4955-9659-123b35c0efeb | 2024-07-16 14:33:04.820 -0700 | running |     0 |
+---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------+

-- Example 17746
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 17747
<registry-hostname>/<db_name>/<schema_name>/<repository_name>

-- Example 17748
myorg-myacct.registry.snowflake.com/my_db/my_schema/my_repository

-- Example 17749
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

-- Example 17750
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8

-- Example 17751
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIE6T...
-----END ENCRYPTED PRIVATE KEY-----

-- Example 17752
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 17753
-----BEGIN PUBLIC KEY-----
MIIBIj...
-----END PUBLIC KEY-----

-- Example 17754
ALTER USER example_user SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 17755
DESC USER example_user;
SELECT SUBSTR((SELECT "value" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "property" = 'RSA_PUBLIC_KEY_FP'), LEN('SHA256:') + 1);

-- Example 17756
Azk1Pq...

-- Example 17757
openssl rsa -pubin -in rsa_key.pub -outform DER | openssl dgst -sha256 -binary | openssl enc -base64

-- Example 17758
writing RSA key
Azk1Pq...

-- Example 17759
ALTER USER example_user SET RSA_PUBLIC_KEY_2='JERUEHtcve...';

-- Example 17760
ALTER USER example_user UNSET RSA_PUBLIC_KEY;

-- Example 17761
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token=<oauth_token>

-- Example 17762
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token="<oauth_token>"

-- Example 17763
$ snowsql -a <account_identifier> -u <user> --private-key-path <path>/rsa_key.p8

-- Example 17764
pip install pyjwt

-- Example 17765
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

-- Example 17766
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

-- Example 17767
CREATE SECURITY INTEGRATION oauth_kp_int
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = CUSTOM
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'
  OAUTH_REDIRECT_URI = 'https://localhost.com'
  OAUTH_ISSUE_REFRESH_TOKENS = TRUE
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400
  BLOCKED_ROLES_LIST = ('SYSADMIN')
  OAUTH_CLIENT_RSA_PUBLIC_KEY ='
  MIIBI
  ...
  ';

-- Example 17768
<snowflake_account_url>/oauth/authorize

-- Example 17769
scope=session:role:R1

-- Example 17770
scope=refresh_token

-- Example 17771
scope=refresh_token session:role:R1

-- Example 17772
<snowflake_account_url>/oauth/token-request

-- Example 17773
Content-type: application/x-www-form-urlencoded

-- Example 17774
{
  "access_token":  "ACCESS_TOKEN",
  "expires_in": 600,
  "refresh_token": "REFRESH_TOKEN",
  "token_type": "Bearer",
  "username": "user1",
}

-- Example 17775
{
  "data" : null,
  "message" : "This is an invalid client.",
  "code" : null,
  "success" : false,
  "error" : "invalid_client"
}

-- Example 17776
<snowflake_account_url>/oauth/token

-- Example 17777
Content-type: application/x-www-form-urlencoded

-- Example 17778
{
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': 'session:role:TEST_ROLE ab12-orgname-acctname.snowflakecomputing.app',
    'assertion': '<token>'
}

-- Example 17779
{
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': 'ab12-orgname-acctname.snowflakecomputing.app',
    'assertion': '<token>'
}

-- Example 17780
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8

-- Example 17781
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIE6TAbBgkqhkiG9w0BBQMwDgQILYPyCppzOwECAggABIIEyLiGSpeeGSe3xHP1
wHLjfCYycUPennlX2bd8yX8xOxGSGfvB+99+PmSlex0FmY9ov1J8H1H9Y3lMWXbL
...
-----END ENCRYPTED PRIVATE KEY-----

-- Example 17782
$ openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 17783
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy+Fw2qv4Roud3l6tjPH4
zxybHjmZ5rhtCz9jppCV8UTWvEXxa88IGRIHbJ/PwKW/mR8LXdfI7l/9vCMXX4mk
...
-----END PUBLIC KEY-----

-- Example 17784
ALTER SECURITY INTEGRATION myint SET OAUTH_CLIENT_RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 17785
DESC SECURITY INTEGRATION myint;

+----------------------------------+---------------+----------------------------------------------------------------------+------------------+
| property                         | property_type | property_value                                                       | property_default |
|----------------------------------+---------------+----------------------------------------------------------------------+------------------|
...
| OAUTH_CLIENT_RSA_PUBLIC_KEY_FP   | String        | SHA256:MRItnbO/123abc/abcdefghijklmn12345678901234=                  |                  |
| OAUTH_CLIENT_RSA_PUBLIC_KEY_2_FP | String        |                                                                      |                  |
...
+----------------------------------+---------------+----------------------------------------------------------------------+------------------+

-- Example 17786
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

-- Example 17787
"Authorization: Bearer JWT_TOKEN"

-- Example 17788
alter integration myint set oauth_client_rsa_public_key_2='JERUEHtcve...';

-- Example 17789
alter integration myint unset oauth_client_rsa_public_key;

-- Example 17790
from snowflake.core import Root

root = Root(my_connection)

-- Example 17791
from snowflake.core import Root
from snowflake.snowpark.context import get_active_session

session = get_active_session()
root = Root(session)

-- Example 17792
root = Root(my_connection)
stages = root.databases["my_db"].schemas["my_schema"].stages
my_stage = stages["my_stage"] # Access the "my_stage" StageResource

-- Example 17793
# my_wh is created from scratch
my_wh = Warehouse(name="my_wh", warehouse_size="X-Small")
root.warehouses.create(my_wh)

-- Example 17794
# my_wh_ref is retrieved from an existing warehouse
# This returns a WarehouseResource object, which is a reference to a warehouse named "my_wh" in your Snowflake account
my_wh_ref = root.warehouses["my_wh"]

-- Example 17795
# my_wh is fetched from an existing warehouse
my_wh = root.warehouses["my_wh"].fetch()
print(my_wh.name, my_wh.auto_resume)

-- Example 17796
# my_wh is fetched from an existing warehouse
my_wh = root.warehouses["my_wh"].fetch()
my_wh.warehouse_size = "X-Small"
root.warehouses["my_wh"].create_or_alter(my_wh)

-- Example 17797
# my_wh_ref is retrieved from an existing warehouse
# This returns a WarehouseResource object, which is a reference to a warehouse named "my_wh" in your Snowflake account
my_wh_ref = root.warehouses["my_wh"]

# Fetch returns the properties of the object (returns a "Model" Warehouse object that represents that warehouse's properties)
wh_properties = my_wh_ref.fetch()

-- Example 17798
# my_wh_ref is retrieved from an existing warehouse
my_wh_ref = root.warehouses["my_wh"]

# Resume a warehouse using a WarehouseResource object
my_wh_ref.resume()

-- Example 17799
# my_stage is retrieved from an existing stage
stage_ref = root.databases["my_db"].schemas["my_schema"].stages["my_stage"]

# Print file names and their sizes on a stage using a StageResource object
for file in stage_ref.list_files():
  print(file.name, file.size)

