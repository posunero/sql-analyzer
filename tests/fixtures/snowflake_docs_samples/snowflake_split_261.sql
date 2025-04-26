-- Example 17465
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;

-- Example 17466
EXECUTE IMMEDIATE $$
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
$$
;

-- Example 17467
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;

-- Example 17468
EXECUTE IMMEDIATE $$
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
$$
;

-- Example 17469
SHOW IMAGE REPOSITORIES;

-- Example 17470
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 17471
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 17472
docker build --rm --platform linux/amd64 -t <repository_url>/<image_name> .

-- Example 17473
docker build --rm --platform linux/amd64 -t myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest .

-- Example 17474
docker login <registry_hostname> -u <username>

-- Example 17475
docker push <repository_url>/<image_name>

-- Example 17476
docker push myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest

-- Example 17477
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 17478
DESCRIBE COMPUTE POOL tutorial_compute_pool;

-- Example 17479
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
    spec:
      containers:
      - name: echo
        image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
        env:
          SERVER_PORT: 8000
          CHARACTER_NAME: Bob
        readinessProbe:
          port: 8000
          path: /healthcheck
      endpoints:
      - name: echoendpoint
        port: 8000
        public: true
      $$
   MIN_INSTANCES=1
   MAX_INSTANCES=1;

-- Example 17480
SHOW SERVICES;

-- Example 17481
DESC SERVICE echo_service;

-- Example 17482
SHOW SERVICE CONTAINERS IN SERVICE echo_service;

-- Example 17483
CREATE FUNCTION my_echo_udf (InputText varchar)
  RETURNS varchar
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 17484
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 17485
SELECT my_echo_udf('hello!');

-- Example 17486
+--------------------------+
| **MY_ECHO_UDF('HELLO!')**|
|------------------------- |
| Bob said hello!          |
+--------------------------+

-- Example 17487
CREATE TABLE messages (message_text VARCHAR)
  AS (SELECT * FROM (VALUES ('Thank you'), ('Hello'), ('Hello World')));

-- Example 17488
SELECT * FROM messages;

-- Example 17489
SELECT my_echo_udf(message_text) FROM messages;

-- Example 17490
+---------------------------+
| MY_ECHO_UDF(MESSAGE_TEXT) |
|---------------------------|
| Bob said Thank you        |
| Bob said Hello            |
| Bob said Hello World      |
+---------------------------+

-- Example 17491
SHOW ENDPOINTS IN SERVICE echo_service;

-- Example 17492
p6bye-myorg-myacct.snowflakecomputing.app

-- Example 17493
SHOW ENDPOINTS IN SERVICE echo_service;

-- Example 17494
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

-- Example 17495
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 17496
ALTER USER <user-name> SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 17497
# To run this on the command line, enter:
#   python3 generateJWT.py --account=<account_identifier> --user=<username> --private_key_file_path=<path_to_private_key_file>

from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.primitives.serialization import Encoding
from cryptography.hazmat.primitives.serialization import PublicFormat
from cryptography.hazmat.backends import default_backend
from datetime import timedelta, timezone, datetime
import argparse
import base64
from getpass import getpass
import hashlib
import logging
import sys

# This class relies on the PyJWT module (https://pypi.org/project/PyJWT/).
import jwt

logger = logging.getLogger(__name__)

try:
    from typing import Text
except ImportError:
    logger.debug('# Python 3.5.0 and 3.5.1 have incompatible typing modules.', exc_info=True)
    from typing_extensions import Text

ISSUER = "iss"
EXPIRE_TIME = "exp"
ISSUE_TIME = "iat"
SUBJECT = "sub"

# If you generated an encrypted private key, implement this method to return
# the passphrase for decrypting your private key. As an example, this function
# prompts the user for the passphrase.
def get_private_key_passphrase():
    return getpass('Passphrase for private key: ')

class JWTGenerator(object):
    """
    Creates and signs a JWT with the specified private key file, username, and account identifier. The JWTGenerator keeps the
    generated token and only regenerates the token if a specified period of time has passed.
    """
    LIFETIME = timedelta(minutes=59)  # The tokens will have a 59-minute lifetime
    RENEWAL_DELTA = timedelta(minutes=54)  # Tokens will be renewed after 54 minutes
    ALGORITHM = "RS256"  # Tokens will be generated using RSA with SHA256

    def __init__(self, account: Text, user: Text, private_key_file_path: Text,
                lifetime: timedelta = LIFETIME, renewal_delay: timedelta = RENEWAL_DELTA):
        """
        __init__ creates an object that generates JWTs for the specified user, account identifier, and private key.
        :param account: Your Snowflake account identifier. See https://docs.snowflake.com/en/user-guide/admin-account-identifier.html. Note that if you are using the account locator, exclude any region information from the account locator.
        :param user: The Snowflake username.
        :param private_key_file_path: Path to the private key file used for signing the JWTs.
        :param lifetime: The number of minutes (as a timedelta) during which the key will be valid.
        :param renewal_delay: The number of minutes (as a timedelta) from now after which the JWT generator should renew the JWT.
        """

        logger.info(
            """Creating JWTGenerator with arguments
            account : %s, user : %s, lifetime : %s, renewal_delay : %s""",
            account, user, lifetime, renewal_delay)

        # Construct the fully qualified name of the user in uppercase.
        self.account = self.prepare_account_name_for_jwt(account)
        self.user = user.upper()
        self.qualified_username = self.account + "." + self.user

        self.lifetime = lifetime
        self.renewal_delay = renewal_delay
        self.private_key_file_path = private_key_file_path
        self.renew_time = datetime.now(timezone.utc)
        self.token = None

        # Load the private key from the specified file.
        with open(self.private_key_file_path, 'rb') as pem_in:
            pemlines = pem_in.read()
            try:
                # Try to access the private key without a passphrase.
                self.private_key = load_pem_private_key(pemlines, None, default_backend())
            except TypeError:
                # If that fails, provide the passphrase returned from get_private_key_passphrase().
                self.private_key = load_pem_private_key(pemlines, get_private_key_passphrase().encode(), default_backend())

    def prepare_account_name_for_jwt(self, raw_account: Text) -> Text:
        """
        Prepare the account identifier for use in the JWT.
        For the JWT, the account identifier must not include the subdomain or any region or cloud provider information.
        :param raw_account: The specified account identifier.
        :return: The account identifier in a form that can be used to generate the JWT.
        """
        account = raw_account
        if not '.global' in account:
            # Handle the general case.
            idx = account.find('.')
            if idx > 0:
                account = account[0:idx]
        else:
            # Handle the replication case.
            idx = account.find('-')
            if idx > 0:
                account = account[0:idx]
        # Use uppercase for the account identifier.
        return account.upper()

    def get_token(self) -> Text:
        """
        Generates a new JWT. If a JWT has already been generated earlier, return the previously generated token unless the
        specified renewal time has passed.
        :return: the new token
        """
        now = datetime.now(timezone.utc)  # Fetch the current time

        # If the token has expired or doesn't exist, regenerate the token.
        if self.token is None or self.renew_time <= now:
            logger.info("Generating a new token because the present time (%s) is later than the renewal time (%s)",
                        now, self.renew_time)
            # Calculate the next time we need to renew the token.
            self.renew_time = now + self.renewal_delay

            # Prepare the fields for the payload.
            # Generate the public key fingerprint for the issuer in the payload.
            public_key_fp = self.calculate_public_key_fingerprint(self.private_key)

            # Create our payload
            payload = {
                # Set the issuer to the fully qualified username concatenated with the public key fingerprint.
                ISSUER: self.qualified_username + '.' + public_key_fp,

                # Set the subject to the fully qualified username.
                SUBJECT: self.qualified_username,

                # Set the issue time to now.
                ISSUE_TIME: now,

                # Set the expiration time, based on the lifetime specified for this object.
                EXPIRE_TIME: now + self.lifetime
            }

            # Regenerate the actual token
            token = jwt.encode(payload, key=self.private_key, algorithm=JWTGenerator.ALGORITHM)
            # If you are using a version of PyJWT prior to 2.0, jwt.encode returns a byte string instead of a string.
            # If the token is a byte string, convert it to a string.
            if isinstance(token, bytes):
              token = token.decode('utf-8')
            self.token = token
            logger.info("Generated a JWT with the following payload: %s", jwt.decode(self.token, key=self.private_key.public_key(), algorithms=[JWTGenerator.ALGORITHM]))

        return self.token

    def calculate_public_key_fingerprint(self, private_key: Text) -> Text:
        """
        Given a private key in PEM format, return the public key fingerprint.
        :param private_key: private key string
        :return: public key fingerprint
        """
        # Get the raw bytes of public key.
        public_key_raw = private_key.public_key().public_bytes(Encoding.DER, PublicFormat.SubjectPublicKeyInfo)

        # Get the sha256 hash of the raw bytes.
        sha256hash = hashlib.sha256()
        sha256hash.update(public_key_raw)

        # Base64-encode the value and prepend the prefix 'SHA256:'.
        public_key_fp = 'SHA256:' + base64.b64encode(sha256hash.digest()).decode('utf-8')
        logger.info("Public key fingerprint is %s", public_key_fp)

        return public_key_fp

def main():
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    cli_parser = argparse.ArgumentParser()
    cli_parser.add_argument('--account', required=True, help='The account identifier (e.g. "myorganization-myaccount" for "myorganization-myaccount.snowflakecomputing.com").')
    cli_parser.add_argument('--user', required=True, help='The user name.')
    cli_parser.add_argument('--private_key_file_path', required=True, help='Path to the private key file used for signing the JWT.')
    cli_parser.add_argument('--lifetime', type=int, default=59, help='The number of minutes that the JWT should be valid for.')
    cli_parser.add_argument('--renewal_delay', type=int, default=54, help='The number of minutes before the JWT generator should produce a new JWT.')
    args = cli_parser.parse_args()

    token = JWTGenerator(args.account, args.user, args.private_key_file_path, timedelta(minutes=args.lifetime), timedelta(minutes=args.renewal_delay)).get_token()
    print('JWT:')
    print(token)

if __name__ == "__main__":
    main()

-- Example 17498
from generateJWT import JWTGenerator
from datetime import timedelta
import argparse
import logging
import sys
import requests
logger = logging.getLogger(__name__)

def main():
  args = _parse_args()
  token = _get_token(args)
  snowflake_jwt = token_exchange(token,endpoint=args.endpoint, role=args.role,
                  snowflake_account_url=args.snowflake_account_url,
                  snowflake_account=args.account)
  spcs_url=f'https://{args.endpoint}{args.endpoint_path}'
  connect_to_spcs(snowflake_jwt, spcs_url)

def _get_token(args):
  token = JWTGenerator(args.account, args.user, args.private_key_file_path, timedelta(minutes=args.lifetime),
            timedelta(minutes=args.renewal_delay)).get_token()
  logger.info("Key Pair JWT: %s" % token)
  return token

def token_exchange(token, role, endpoint, snowflake_account_url, snowflake_account):
  scope_role = f'session:role:{role}' if role is not None else None
  scope = f'{scope_role} {endpoint}' if scope_role is not None else endpoint
  data = {
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': scope,
    'assertion': token,
  }
  logger.info(data)
  url = f'https://{snowflake_account}.snowflakecomputing.com/oauth/token'
  if snowflake_account_url:
    url =       f'{snowflake_account_url}/oauth/token'
  logger.info("oauth url: %s" %url)
  response = requests.post(url, data=data)
  logger.info("snowflake jwt : %s" % response.text)
  assert 200 == response.status_code, "unable to get snowflake token"
  return response.text

def connect_to_spcs(token, url):
  # Create a request to the ingress endpoint with authz.
  headers = {'Authorization': f'Snowflake Token="{token}"'}
  response = requests.post(f'{url}', headers=headers)
  logger.info("return code %s" % response.status_code)
  logger.info(response.text)

def _parse_args():
  logging.basicConfig(stream=sys.stdout, level=logging.INFO)
  cli_parser = argparse.ArgumentParser()
  cli_parser.add_argument('--account', required=True,
              help='The account identifier (for example, "myorganization-myaccount" for '
                '"myorganization-myaccount.snowflakecomputing.com").')
  cli_parser.add_argument('--user', required=True, help='The user name.')
  cli_parser.add_argument('--private_key_file_path', required=True,
              help='Path to the private key file used for signing the JWT.')
  cli_parser.add_argument('--lifetime', type=int, default=59,
              help='The number of minutes that the JWT should be valid for.')
  cli_parser.add_argument('--renewal_delay', type=int, default=54,
              help='The number of minutes before the JWT generator should produce a new JWT.')
  cli_parser.add_argument('--role',
              help='The role we want to use to create and maintain a session for. If a role is not provided, '
                'use the default role.')
  cli_parser.add_argument('--endpoint', required=True,
              help='The ingress endpoint of the service')
  cli_parser.add_argument('--endpoint-path', default='/',
              help='The url path for the ingress endpoint of the service')
  cli_parser.add_argument('--snowflake_account_url', default=None,
              help='The account url of the account for which we want to log in. Type of '
                'https://myorganization-myaccount.snowflakecomputing.com')
  args = cli_parser.parse_args()
  return args

if __name__ == "__main__":
  main()

-- Example 17499
python3 access-via-keypair.py \
  --account <account-identifier> \
  --user <user-name> \
  --role TEST_ROLE \
  --private_key_file_path rsa_key.p8 \
  --endpoint <ingress-hostname> \
  --endpoint-path /ui

-- Example 17500
def _get_token(args):
    token = JWTGenerator(args.account,
                        args.user,
                        args.private_key_file_path,
                        timedelta(minutes=args.lifetime),
                        timedelta(minutes=args.renewal_delay)).get_token()
    logger.info("Key Pair JWT: %s" % token)
    return token

-- Example 17501
scope_role = f'session:role:{role}' if role is not None else None
scope = f'{scope_role} {endpoint}' if scope_role is not None else endpoint

data = {
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': scope,
    'assertion': token,
}

-- Example 17502
url = f'{snowflake_account_url}/oauth/token'
response = requests.post(url, data=data)
assert 200 == response.status_code, "unable to get Snowflake token"
return response.text

-- Example 17503
headers = {'Authorization': f'Snowflake Token="{token}"'}
response = requests.post(f'{url}', headers=headers)

-- Example 17504
from flask import Flask
from flask import request
from flask import make_response
from flask import render_template
import logging
import os
import sys

SERVICE_HOST = os.getenv('SERVER_HOST', '0.0.0.0')
SERVER_PORT = os.getenv('SERVER_PORT', 8080)
CHARACTER_NAME = os.getenv('CHARACTER_NAME', 'I')


def get_logger(logger_name):
  logger = logging.getLogger(logger_name)
  logger.setLevel(logging.DEBUG)
  handler = logging.StreamHandler(sys.stdout)
  handler.setLevel(logging.DEBUG)
  handler.setFormatter(
    logging.Formatter(
      '%(name)s [%(asctime)s] [%(levelname)s] %(message)s'))
  logger.addHandler(handler)
  return logger


logger = get_logger('echo-service')

app = Flask(__name__)


@app.get("/healthcheck")
def readiness_probe():
  return "I'm ready!"


@app.post("/echo")
def echo():
  '''
  Main handler for input data sent by Snowflake.
  '''
  message = request.json
  logger.debug(f'Received request: {message}')

  if message is None or not message['data']:
    logger.info('Received empty message')
    return {}

  # input format:
  #   {"data": [
  #     [row_index, column_1_value, column_2_value, ...],
  #     ...
  #   ]}
  input_rows = message['data']
  logger.info(f'Received {len(input_rows)} rows')

  # output format:
  #   {"data": [
  #     [row_index, column_1_value, column_2_value, ...}],
  #     ...
  #   ]}
  output_rows = [[row[0], get_echo_response(row[1])] for row in input_rows]
  logger.info(f'Produced {len(output_rows)} rows')

  response = make_response({"data": output_rows})
  response.headers['Content-type'] = 'application/json'
  logger.debug(f'Sending response: {response.json}')
  return response


@app.route("/ui", methods=["GET", "POST"])
def ui():
  '''
  Main handler for providing a web UI.
  '''
  if request.method == "POST":
    # getting input in HTML form
    input_text = request.form.get("input")
    # display input and output
    return render_template("basic_ui.html",
      echo_input=input_text,
      echo_reponse=get_echo_response(input_text))
  return render_template("basic_ui.html")


def get_echo_response(input):
  return f'{CHARACTER_NAME} said {input}'

if __name__ == '__main__':
  app.run(host=SERVICE_HOST, port=SERVER_PORT)

-- Example 17505
@app.post("/echo")
def echo():

-- Example 17506
@app.route("/ui", methods=["GET", "POST"])
def ui():

-- Example 17507
@app.get("/healthcheck")
def readiness_probe():

-- Example 17508
ARG BASE_IMAGE=python:3.10-slim-buster
FROM $BASE_IMAGE
COPY echo_service.py ./
COPY templates/ ./templates/
RUN pip install --upgrade pip && \\
pip install flask
CMD ["python", "echo_service.py"]

-- Example 17509
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Welcome to echo service!</title>
  </head>
  <body>
    <h1>Welcome to echo service!</h1>
    <form action="{{ url_for("ui") }}" method="post">
      <label for="input">Input:<label><br>
      <input type="text" id="input" name="input"><br>
    </form>
    <h2>Input:</h2>
    {{ echo_input }}
    <h2>Output:</h2>
    {{ echo_reponse }}
  </body>
</html>

-- Example 17510
spec:
  containers:
  - name: echo
    image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
    env:
      SERVER_PORT: 8000
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8000
      path: /healthcheck
  endpoints:
  - name: echoendpoint
    port: 8000
    public: true

-- Example 17511
CHARACTER_NAME = os.getenv('CHARACTER_NAME', 'I')
SERVER_PORT = os.getenv('SERVER_PORT', 8080)

-- Example 17512
@app.get("/healthcheck")
def readiness_probe():

-- Example 17513
CREATE FUNCTION my_echo_udf (InputText VARCHAR)
  RETURNS VARCHAR
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 17514
docker build --rm -t my_service:local .

-- Example 17515
docker run --rm -p 8080:8080 my_service:local

-- Example 17516
curl -X POST http://localhost:8080/echo \
  -H "Content-Type: application/json" \
  -d '{"data":[[0, "Hello friend"], [1, "Hello World"]]}'

-- Example 17517
{"data":[[0,"I said Hello Friend"],[1,"I said Hello World"]]}

-- Example 17518
DESC[RIBE] SERVICE <name>

-- Example 17519
SELECT SYSTEM$GET_SERVICE_DNS_DOMAIN('mydb.myschema');

-- Example 17520
DESCRIBE SERVICE echo_service;

-- Example 17521
+--------------+---------+---------------+-------------+-----------+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+-------------------+------------------+---------------------+---------------+---------------+-------------+------------------------------+-------------------------------+-------------------------------+------------+--------------+-------------------+---------+-----------------+-----------------+--------+--------------+------------------------------------------------------------------+--------------+------------------------+----------------------+
| name         | status  | database_name | schema_name | owner     | compute_pool          | spec                                                                                                                                                         | dns_name                            | current_instances | target_instances | min_ready_instances | min_instances | max_instances | auto_resume | external_access_integrations | created_on                    | updated_on                    | resumed_on | suspended_on | auto_suspend_secs | comment | owner_role_type | query_warehouse | is_job | is_async_job | spec_digest                                                      | is_upgrading | managing_object_domain | managing_object_name |
|--------------+---------+---------------+-------------+-----------+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+-------------------+------------------+---------------------+---------------+---------------+-------------+------------------------------+-------------------------------+-------------------------------+------------+--------------+-------------------+---------+-----------------+-----------------+--------+--------------+------------------------------------------------------------------+--------------+------------------------+----------------------|
| ECHO_SERVICE | RUNNING | TUTORIAL_DB   | DATA_SCHEMA | TEST_ROLE | TUTORIAL_COMPUTE_POOL | ---                                                                                                                                                          | echo-service.k3m6.svc.spcs.internal |                 1 |                1 |                   1 |             1 |             1 | true        | NULL                         | 2024-11-29 12:12:47.310 -0800 | 2024-11-29 12:12:48.843 -0800 | NULL       | NULL         |                 0 | NULL    | ROLE            | NULL            | false  | false        | edaf548eb0c2744a87426529b53aac75756d0ea1c0ba5edb3cbb4295a381f2b4 | false        | NULL                   | NULL                 |
|              |         |               |             |           |                       | spec:                                                                                                                                                        |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |   containers:                                                                                                                                                |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |   - name: "echo"                                                                                                                                             |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     image: "sfengineering-prod1-snowservices-test2.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest" |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     sha256: "@sha256:d04a2d7b7d9bd607df994926e3cc672edcb541474e4888a01703e8bb0dd3f173"                                                                       |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     env:                                                                                                                                                     |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |       SERVER_PORT: "8000"                                                                                                                                    |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |       CHARACTER_NAME: "Bob"                                                                                                                                  |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     readinessProbe:                                                                                                                                          |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |       port: 8000                                                                                                                                             |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |       path: "/healthcheck"                                                                                                                                   |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     resources:                                                                                                                                               |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |       limits:                                                                                                                                                |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |         memory: "6Gi"                                                                                                                                        |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |         cpu: "1"                                                                                                                                             |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |       requests:                                                                                                                                              |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |         memory: "0.5Gi"                                                                                                                                      |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |         cpu: "0.5"                                                                                                                                           |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |   endpoints:                                                                                                                                                 |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |   - name: "echoendpoint"                                                                                                                                     |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     port: 8000                                                                                                                                               |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |     public: true                                                                                                                                             |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
|              |         |               |             |           |                       |                                                                                                                                                              |                                     |                   |                  |                     |               |               |             |                              |                               |                               |            |              |                   |         |                 |                 |        |              |                                                                  |              |                        |                      |
+--------------+---------+---------------+-------------+-----------+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+-------------------+------------------+---------------------+---------------+---------------+-------------+------------------------------+-------------------------------+-------------------------------+------------+--------------+-------------------+---------+-----------------+-----------------+--------+--------------+------------------------------------------------------------------+--------------+------------------------+----------------------+

-- Example 17522
CREATE [ OR REPLACE ] SNAPSHOT [ IF NOT EXISTS ] <name>
  FROM SERVICE <service_name>
  VOLUME "<volume_name>"
  INSTANCE <instance_id>
  [ COMMENT = '<string_literal>']
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , ... ] ) ]

-- Example 17523
CREATE SNAPSHOT snapshot_0
  FROM SERVICE example_service
  VOLUME "data"
  INSTANCE 0
  COMMENT='new snapshot';

-- Example 17524
SHOW SNAPSHOTS [ LIKE '<pattern>' ]
               [ IN
                   {
                       ACCOUNT                  |

                       DATABASE                 |
                       DATABASE <database_name> |

                       SCHEMA                   |
                       SCHEMA <schema_name>     |
                       <schema_name>            |
                   }
               ]
               [ STARTS WITH '<name_string>' ]
               [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 17525
SHOW SNAPSHOTS;

-- Example 17526
+-------------+---------+---------------+-------------+------------------------------------+-------------+----------+------+-----------------+-----------+-----------------+-------------------------------+-------------------------------+
| name        | state   | database_name | schema_name | service_name                       | volume_name | instance | size | comment         | owner     | owner_role_type | created_on                    | updated_on                    |
|-------------+---------+---------------+-------------+------------------------------------+-------------+----------+------+-----------------+-----------+-----------------+-------------------------------+-------------------------------|
| MY_SNAPSHOT | CREATED | TUTORIAL_DB   | DATA_SCHEMA | TUTORIAL_DB.DATA_SCHEMA.MY_SERVICE | block-vol1  | 0        |   10 | updated comment | TEST_ROLE | ROLE            | 2023-12-13 17:06:04.162 -0800 | 2023-12-13 17:06:56.303 -0800 |
+-------------+---------+---------------+-------------+------------------------------------+-------------+----------+------+-----------------+-----------+-----------------+-------------------------------+-------------------------------+

-- Example 17527
{ DESC | DESCRIBE } SNAPSHOT <name>

-- Example 17528
DESC SNAPSHOT my_snapshot;

-- Example 17529
+-------------+---------+---------------+-------------+------------------------------------+-------------+----------+------+-----------------+-----------+-----------------+-------------------------------+-------------------------------+
| name        | state   | database_name | schema_name | service_name                       | volume_name | instance | size | comment         | owner     | owner_role_type | created_on                    | updated_on                    |
|-------------+---------+---------------+-------------+------------------------------------+-------------+----------+------+-----------------+-----------+-----------------+-------------------------------+-------------------------------|
| MY_SNAPSHOT | CREATED | TUTORIAL_DB   | DATA_SCHEMA | TUTORIAL_DB.DATA_SCHEMA.MY_SERVICE | block-vol1  | 0        |   10 | updated comment | TEST_ROLE | ROLE            | 2023-12-13 17:06:04.162 -0800 | 2023-12-13 17:06:56.303 -0800 |
+-------------+---------+---------------+-------------+------------------------------------+-------------+----------+------+-----------------+-----------+-----------------+-------------------------------+-------------------------------+

-- Example 17530
ALTER SNAPSHOT [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

-- Example 17531
ALTER SNAPSHOT example_snapshot SET COMMENT = 'sample comment.';

