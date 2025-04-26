-- Example 1701
USE ROLE ACCOUNTADMIN;
CREATE ROLE hybrid_quickstart_bi_user_role;
SET my_user = CURRENT_USER();
GRANT ROLE hybrid_quickstart_bi_user_role TO USER IDENTIFIER($my_user);

-- Example 1702
USE ROLE hybrid_quickstart_role;
GRANT USAGE ON WAREHOUSE hybrid_quickstart_wh TO ROLE hybrid_quickstart_bi_user_role;
GRANT USAGE ON DATABASE hybrid_quickstart_db TO ROLE hybrid_quickstart_bi_user_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE hybrid_quickstart_db TO hybrid_quickstart_bi_user_role;

-- Example 1703
USE ROLE hybrid_quickstart_bi_user_role;
USE DATABASE hybrid_quickstart_db;
USE SCHEMA data;

SELECT * FROM order_header LIMIT 10;

-- Example 1704
Object 'ORDER_HEADER' does not exist or not authorized.

-- Example 1705
USE ROLE hybrid_quickstart_role;
GRANT SELECT ON ALL TABLES IN SCHEMA DATA TO ROLE hybrid_quickstart_bi_user_role;

-- Example 1706
USE ROLE hybrid_quickstart_bi_user_role;
SELECT * FROM order_header LIMIT 10;

-- Example 1707
USE ROLE hybrid_quickstart_role;

CREATE MASKING POLICY hide_column_values AS
  (col_value VARCHAR) RETURNS VARCHAR ->
    CASE WHEN CURRENT_ROLE() IN ('HYBRID_QUICKSTART_ROLE') THEN col_value
      ELSE '***MASKED***'
      END;

-- Example 1708
ALTER TABLE truck MODIFY COLUMN truck_email
  SET MASKING POLICY hide_column_values USING (truck_email);

-- Example 1709
SELECT * FROM truck LIMIT 10;

-- Example 1710
USE ROLE hybrid_quickstart_bi_user_role;
SELECT * FROM truck LIMIT 10;

-- Example 1711
USE ROLE hybrid_quickstart_role;
USE WAREHOUSE hybrid_quickstart_wh;
USE DATABASE hybrid_quickstart_db;
USE SCHEMA data;

-- Example 1712
DROP DATABASE hybrid_quickstart_db;
DROP WAREHOUSE hybrid_quickstart_wh;
USE ROLE ACCOUNTADMIN;
DROP ROLE hybrid_quickstart_role;
DROP ROLE hybrid_quickstart_bi_user_role;

-- Example 1713
CREATE DATABASE IF NOT EXISTS cortex_search_tutorial_db;

CREATE OR REPLACE WAREHOUSE cortex_search_tutorial_wh WITH
     WAREHOUSE_SIZE='X-SMALL'
     AUTO_SUSPEND = 120
     AUTO_RESUME = TRUE
     INITIALLY_SUSPENDED=TRUE;

-- Example 1714
CREATE OR REPLACE CORTEX SEARCH SERVICE cortex_search_tutorial_db.public.airbnb_svc
ON listing_text
ATTRIBUTES room_type, amenities
WAREHOUSE = cortex_search_tutorial_wh
TARGET_LAG = '1 hour'
AS
    SELECT
        room_type,
        amenities,
        price,
        cancellation_policy,
        ('Summary\n\n' || summary || '\n\n\nDescription\n\n' || description || '\n\n\nSpace\n\n' || space) as listing_text
    FROM
    cortex_search_tutorial_db.public.airbnb_listings;

-- Example 1715
# Import python packages
import streamlit as st
from snowflake.core import Root
from snowflake.snowpark.context import get_active_session

# Constants
DB = "cortex_search_tutorial_db"
SCHEMA = "public"
SERVICE = "airbnb_svc"
BASE_TABLE = "cortex_search_tutorial_db.public.airbnb_listings"
ARRAY_ATTRIBUTES = {"AMENITIES"}


def get_column_specification():
    """
    Returns the name of the search column and a list of the names of the attribute columns
    for the provided cortex search service
    """
    session = get_active_session()
    search_service_result = session.sql(f"DESC CORTEX SEARCH SERVICE {DB}.{SCHEMA}.{SERVICE}").collect()[0]
    st.session_state.attribute_columns = search_service_result.attribute_columns.split(",")
    st.session_state.search_column = search_service_result.search_column
    st.session_state.columns = search_service_result.columns.split(",")

def init_layout():
    st.title("Cortex AI Search")
    st.markdown(f"Querying service: `{DB}.{SCHEMA}.{SERVICE}`".replace('"', ''))

def query_cortex_search_service(query, filter={}):
    """
    Queries the cortex search service in the session state and returns a list of results
    """
    session = get_active_session()
    cortex_search_service = (
        Root(session)
        .databases[DB]
        .schemas[SCHEMA]
        .cortex_search_services[SERVICE]
    )
    context_documents = cortex_search_service.search(
        query,
        columns=st.session_state.columns,
        filter=filter,
        limit=st.session_state.limit)
    return context_documents.results

@st.cache_data
def distinct_values_for_attribute(col_name, is_array_attribute=False):
    session = get_active_session()
    if is_array_attribute:
        values = session.sql(f'''
        SELECT DISTINCT value FROM {BASE_TABLE},
        LATERAL FLATTEN(input => {col_name})
        ''').collect()
    else:
        values = session.sql(f"SELECT DISTINCT {col_name} AS VALUE FROM {BASE_TABLE}").collect()
    return [ x["VALUE"].replace('"', "") for x in values ]

def init_search_input():
    st.session_state.query = st.text_input("Query")

def init_limit_input():
    st.session_state.limit = st.number_input("Limit", min_value=1, value=5)

def init_attribute_selection():
    st.session_state.attributes = {}
    for col in st.session_state.attribute_columns:
        is_multiselect = col in ARRAY_ATTRIBUTES
        st.session_state.attributes[col] = st.multiselect(
            col,
            distinct_values_for_attribute(col, is_array_attribute=is_multiselect)
        )

def display_search_results(results):
    """
    Display the search results in the UI
    """
    st.subheader("Search results")
    for i, result in enumerate(results):
        result = dict(result)
        container = st.expander(f"[Result {i+1}]", expanded=True)

        # Add the result text.
        container.markdown(result[st.session_state.search_column])

        # Add the attributes.
        for column, column_value in sorted(result.items()):
            if column == st.session_state.search_column:
                continue
            container.markdown(f"**{column}**: {column_value}")

def create_filter_object(attributes):
    """
    Create a filter object for the search query
    """
    and_clauses = []
    for column, column_values in attributes.items():
        if len(column_values) == 0:
            continue
        if column in ARRAY_ATTRIBUTES:
            for attr_value in column_values:
                and_clauses.append({"@contains": { column: attr_value }})
        else:
            or_clauses = [{"@eq": {column: attr_value}} for attr_value in column_values]
            and_clauses.append({"@or": or_clauses })

    return {"@and": and_clauses} if and_clauses else {}


def main():
    init_layout()
    get_column_specification()
    init_attribute_selection()
    init_limit_input()
    init_search_input()

    if not st.session_state.query:
        return
    results = query_cortex_search_service(
        st.session_state.query,
        filter = create_filter_object(st.session_state.attributes)
    )
    display_search_results(results)


if __name__ == "__main__":
    st.set_page_config(page_title="Cortex AI Search and Summary", layout="wide")
    main()

-- Example 1716
DROP DATABASE IF EXISTS cortex_search_tutorial_db;
DROP WAREHOUSE IF EXISTS cortex_search_tutorial_wh;

-- Example 1717
database = root.databases.create(
  Database(
    name="PYTHON_API_DB"),
    mode=CreateMode.or_replace
  )

-- Example 1718
schema = database.schemas.create(
  Schema(
    name="PYTHON_API_SCHEMA"),
    mode=CreateMode.or_replace,
  )

-- Example 1719
table = schema.tables.create(
  Table(
    name="PYTHON_API_TABLE",
    columns=[
      TableColumn(
        name="TEMPERATURE",
        datatype="int",
        nullable=False,
      ),
      TableColumn(
        name="LOCATION",
        datatype="string",
      ),
    ],
  ),
mode=CreateMode.or_replace
)

-- Example 1720
table_details = table.fetch()

-- Example 1721
table_details.to_dict()

-- Example 1722
{
    "name": "PYTHON_API_TABLE",
    "kind": "TABLE",
    "enable_schema_evolution": False,
    "change_tracking": False,
    "data_retention_time_in_days": 1,
    "max_data_extension_time_in_days": 14,
    "default_ddl_collation": "",
    "columns": [
        {"name": "TEMPERATURE", "datatype": "NUMBER(38,0)", "nullable": False},
        {"name": "LOCATION", "datatype": "VARCHAR(16777216)", "nullable": True},
    ],
    "created_on": datetime.datetime(
        2024, 5, 9, 8, 59, 15, 832000, tzinfo=datetime.timezone.utc
    ),
    "database_name": "PYTHON_API_DB",
    "schema_name": "PYTHON_API_SCHEMA",
    "rows": 0,
    "bytes": 0,
    "owner": "ACCOUNTADMIN",
    "automatic_clustering": False,
    "search_optimization": False,
    "owner_role_type": "ROLE",
}

-- Example 1723
table_details.columns.append(
    TableColumn(
      name="elevation",
      datatype="int",
      nullable=False,
      constraints=[PrimaryKey()],
    )
)

-- Example 1724
table.create_or_alter(table_details)

-- Example 1725
table.fetch().to_dict()

-- Example 1726
{
    "name": "PYTHON_API_TABLE",
    "kind": "TABLE",
    "enable_schema_evolution": False,
    "change_tracking": False,
    "data_retention_time_in_days": 1,
    "max_data_extension_time_in_days": 14,
    "default_ddl_collation": "",
    "columns": [
        {"name": "TEMPERATURE", "datatype": "NUMBER(38,0)", "nullable": False},
        {"name": "LOCATION", "datatype": "VARCHAR(16777216)", "nullable": True},
        {"name": "ELEVATION", "datatype": "NUMBER(38,0)", "nullable": False},
    ],
    "created_on": datetime.datetime(
        2024, 5, 9, 8, 59, 15, 832000, tzinfo=datetime.timezone.utc
    ),
    "database_name": "PYTHON_API_DB",
    "schema_name": "PYTHON_API_SCHEMA",
    "rows": 0,
    "bytes": 0,
    "owner": "ACCOUNTADMIN",
    "automatic_clustering": False,
    "search_optimization": False,
    "owner_role_type": "ROLE",
    "constraints": [
        {"name": "ELEVATION", "column_names": ["ELEVATION"], "constraint_type": "PRIMARY KEY"}
    ]
}

-- Example 1727
warehouses = root.warehouses

-- Example 1728
python_api_wh = Warehouse(
    name="PYTHON_API_WH",
    warehouse_size="SMALL",
    auto_suspend=500,
)

warehouse = warehouses.create(python_api_wh,mode=CreateMode.or_replace)

-- Example 1729
warehouse_details = warehouse.fetch()
warehouse_details.to_dict()

-- Example 1730
{
  'name': 'PYTHON_API_WH',
  'auto_suspend': 500,
  'auto_resume': 'true',
  'resource_monitor': 'null',
  'comment': '',
  'max_concurrency_level': 8,
  'statement_queued_timeout_in_seconds': 0,
  'statement_timeout_in_seconds': 172800,
  'tags': {},
  'warehouse_type': 'STANDARD',
  'warehouse_size': 'Small'
}

-- Example 1731
warehouse_list = warehouses.iter(like="PYTHON_API_WH")
result = next(warehouse_list)
result.to_dict()

-- Example 1732
{
  'name': 'PYTHON_API_WH',
  'auto_suspend': 500,
  'auto_resume': 'true',
  'resource_monitor': 'null',
  'comment': '',
  'max_concurrency_level': 8,
  'statement_queued_timeout_in_seconds': 0,
  'statement_timeout_in_seconds': 172800,
  'tags': {},
  'warehouse_type': 'STANDARD',
  'warehouse_size': 'Small'
}

-- Example 1733
warehouse = root.warehouses.create(Warehouse(
    name="PYTHON_API_WH",
    warehouse_size="LARGE",
    auto_suspend=500,
), mode=CreateMode.or_replace)

-- Example 1734
warehouse.fetch().size

-- Example 1735
warehouse.drop()

-- Example 1736
SHOW IMAGE REPOSITORIES;

-- Example 1737
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 1738
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 1739
docker build --rm --platform linux/amd64 -t <repository_url>/<image_name> .

-- Example 1740
docker build --rm --platform linux/amd64 -t myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest .

-- Example 1741
docker login <registry_hostname> -u <username>

-- Example 1742
docker push <repository_url>/<image_name>

-- Example 1743
docker push myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest

-- Example 1744
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 1745
DESCRIBE COMPUTE POOL tutorial_compute_pool;

-- Example 1746
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

-- Example 1747
SHOW SERVICES;

-- Example 1748
DESC SERVICE echo_service;

-- Example 1749
SHOW SERVICE CONTAINERS IN SERVICE echo_service;

-- Example 1750
CREATE FUNCTION my_echo_udf (InputText varchar)
  RETURNS varchar
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 1751
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 1752
SELECT my_echo_udf('hello!');

-- Example 1753
+--------------------------+
| **MY_ECHO_UDF('HELLO!')**|
|------------------------- |
| Bob said hello!          |
+--------------------------+

-- Example 1754
CREATE TABLE messages (message_text VARCHAR)
  AS (SELECT * FROM (VALUES ('Thank you'), ('Hello'), ('Hello World')));

-- Example 1755
SELECT * FROM messages;

-- Example 1756
SELECT my_echo_udf(message_text) FROM messages;

-- Example 1757
+---------------------------+
| MY_ECHO_UDF(MESSAGE_TEXT) |
|---------------------------|
| Bob said Thank you        |
| Bob said Hello            |
| Bob said Hello World      |
+---------------------------+

-- Example 1758
SHOW ENDPOINTS IN SERVICE echo_service;

-- Example 1759
p6bye-myorg-myacct.snowflakecomputing.app

-- Example 1760
SHOW ENDPOINTS IN SERVICE echo_service;

-- Example 1761
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

-- Example 1762
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 1763
ALTER USER <user-name> SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 1764
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

-- Example 1765
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

-- Example 1766
python3 access-via-keypair.py \
  --account <account-identifier> \
  --user <user-name> \
  --role TEST_ROLE \
  --private_key_file_path rsa_key.p8 \
  --endpoint <ingress-hostname> \
  --endpoint-path /ui

-- Example 1767
def _get_token(args):
    token = JWTGenerator(args.account,
                        args.user,
                        args.private_key_file_path,
                        timedelta(minutes=args.lifetime),
                        timedelta(minutes=args.renewal_delay)).get_token()
    logger.info("Key Pair JWT: %s" % token)
    return token

-- Example 1768
scope_role = f'session:role:{role}' if role is not None else None
scope = f'{scope_role} {endpoint}' if scope_role is not None else endpoint

data = {
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'scope': scope,
    'assertion': token,
}

