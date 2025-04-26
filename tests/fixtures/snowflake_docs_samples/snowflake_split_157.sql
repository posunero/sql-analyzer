-- Example 10499
USE ROLE accountadmin;

CREATE SHARE sales_s;

GRANT USAGE ON DATABASE sales_db TO SHARE sales_s;
GRANT USAGE ON SCHEMA sales_db.aggregates_eula TO SHARE sales_s;
GRANT SELECT ON TABLE sales_db.aggregates_eula.aggregate_1 TO SHARE sales_s;

SHOW GRANTS TO SHARE sales_s;

ALTER SHARE sales_s ADD ACCOUNTS=xy12345, yz23456;

SHOW GRANTS OF SHARE sales_s;

-- Example 10500
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

-- Example 10501
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- Example 10502
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'DISABLED';

-- Example 10503
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US,AWS_EU';

-- Example 10504
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE DATABASE my_database;
USE DATABASE my_database;

CREATE OR REPLACE SCHEMA my_schema;
USE SCHEMA my_schema;

CREATE ROLE policy_admin;

GRANT USAGE ON DATABASE my_database TO ROLE policy_admin;
GRANT USAGE ON SCHEMA my_database.my_schema TO ROLE policy_admin;
GRANT CREATE AUTHENTICATION POLICY ON SCHEMA my_database.my_schema TO ROLE policy_admin;
GRANT APPLY AUTHENTICATION POLICY ON ACCOUNT TO ROLE policy_admin;

USE ROLE policy_admin;

CREATE AUTHENTICATION POLICY my_example_authentication_policy
  CLIENT_TYPES = ('SNOWFLAKE_UI')
  AUTHENTICATION_METHODS = ('OAUTH', 'PASSWORD');

-- Example 10505
ALTER ACCOUNT SET AUTHENTICATION POLICY my_example_authentication_policy;

-- Example 10506
ALTER USER example_user SET AUTHENTICATION POLICY my_example_authentication_policy;

-- Example 10507
GRANT APPLY AUTHENTICATION POLICY ON ACCOUNT TO ROLE my_policy_admin

-- Example 10508
GRANT APPLY AUTHENTICATION POLICY ON USER example_user TO ROLE my_policy_admin

-- Example 10509
CREATE AUTHENTICATION POLICY require_mfa_with_password_authentication_policy
  MFA_AUTHENTICATION_METHODS = ('PASSWORD')
  MFA_ENROLLMENT = REQUIRED;

-- Example 10510
ALTER ACCOUNT SET AUTHENTICATION POLICY require_mfa_with_password_authentication_policy;

-- Example 10511
CREATE AUTHENTICATION POLICY require_mfa_authentication_policy
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  MFA_ENROLLMENT = REQUIRED;

-- Example 10512
ALTER ACCOUNT SET AUTHENTICATION POLICY require_mfa_authentication_policy;

-- Example 10513
POLICY_REFERENCES( POLICY_NAME => '<authentication_policy_name>' )

-- Example 10514
POLICY_REFERENCES( REF_ENTITY_DOMAIN => 'USER', REF_ENTITY_NAME => '<username>')

-- Example 10515
POLICY_REFERENCES( REF_ENTITY_DOMAIN => 'ACCOUNT', REF_ENTITY_NAME => '<accountname>')

-- Example 10516
SELECT *
FROM TABLE(
    my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
      POLICY_NAME => 'my_db.my_schema.authentication_policy_prod_1'
  )
);

-- Example 10517
CREATE AUTHENTICATION POLICY admin_authentication_policy
  AUTHENTICATION_METHODS = ('SAML', 'PASSWORD')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  SECURITY_INTEGRATIONS = ('EXAMPLE_OKTA_INTEGRATION');

-- Example 10518
ALTER USER <administrator_name> SET AUTHENTICATION POLICY admin_authentication_policy

-- Example 10519
CREATE AUTHENTICATION POLICY restrict_client_type_policy
  CLIENT_TYPES = ('SNOWFLAKE_UI')
  COMMENT = 'Only allows access through the web interface';

-- Example 10520
ALTER USER example_user SET AUTHENTICATION POLICY restrict_client_type_policy;

-- Example 10521
CREATE SECURITY INTEGRATION example_okta_integration
  TYPE = SAML2
  SAML2_SSO_URL = 'https://okta.example.com';
  ...

-- Example 10522
CREATE SECURITY INTEGRATION example_entra_integration
  TYPE = SAML2
  SAML2_SSO_URL = 'https://entra-example_acme.com';
  ...

-- Example 10523
CREATE AUTHENTICATION POLICY multiple_idps_authentication_policy
  AUTHENTICATION_METHODS = ('SAML')
  SECURITY_INTEGRATIONS = ('EXAMPLE_OKTA_INTEGRATION', 'EXAMPLE_ENTRA_INTEGRATION');

-- Example 10524
ALTER ACCOUNT SET AUTHENTICATION POLICY multiple_idps_authentication_policy;

-- Example 10525
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

-- Example 10526
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8

-- Example 10527
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIE6T...
-----END ENCRYPTED PRIVATE KEY-----

-- Example 10528
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 10529
-----BEGIN PUBLIC KEY-----
MIIBIj...
-----END PUBLIC KEY-----

-- Example 10530
ALTER USER example_user SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 10531
DESC USER example_user;
SELECT SUBSTR((SELECT "value" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "property" = 'RSA_PUBLIC_KEY_FP'), LEN('SHA256:') + 1);

-- Example 10532
Azk1Pq...

-- Example 10533
openssl rsa -pubin -in rsa_key.pub -outform DER | openssl dgst -sha256 -binary | openssl enc -base64

-- Example 10534
writing RSA key
Azk1Pq...

-- Example 10535
ALTER USER example_user SET RSA_PUBLIC_KEY_2='JERUEHtcve...';

-- Example 10536
ALTER USER example_user UNSET RSA_PUBLIC_KEY;

-- Example 10537
use role accountadmin;
use database demo_db;
use schema information_schema;
select *
    from table(rest_event_history(
        'scim',
        dateadd('minutes',-5,current_timestamp()),
        current_timestamp(),
        200))
    order by event_timestamp;

-- Example 10538
use role accountadmin;
alter account set ENABLE_INTERNAL_STAGES_PRIVATELINK = true;

-- Example 10539
use role accountadmin;
alter account set ENABLE_INTERNAL_STAGES_PRIVATELINK = true;
select key, value from table(flatten(input=>parse_json(system$get_privatelink_config())));

-- Example 10540
dig <bucket_name>.s3.<region>.amazonaws.com

-- Example 10541
alter account set S3_STAGE_VPCE_DNS_NAME='*.vpce-sd98fs0d9f8g.s3.us-west2.vpce.amazonaws.com';

-- Example 10542
aws sts get-federation-token --name sam

-- Example 10543
{
   ...
   "FederatedUser": {
       "FederatedUserId": "185...:sam",
       "Arn": "arn:aws:sts::185...:federated-user/sam"
   },
   "PackedPolicySize": 0
 }

-- Example 10544
select SYSTEM$AUTHORIZE_PRIVATELINK ( '<aws_id>' , '<federated_token>' );

-- Example 10545
use role accountadmin;

select SYSTEM$AUTHORIZE_PRIVATELINK (
    '185...',
    '{
       "Credentials": {
           "AccessKeyId": "ASI...",
           "SecretAccessKey": "enw...",
           "SessionToken": "Fwo...",
           "Expiration": "2021-01-07T19:06:23+00:00"
       },
       "FederatedUser": {
           "FederatedUserId": "185...:sam",
           "Arn": "arn:aws:sts::185...:federated-user/sam"
       },
       "PackedPolicySize": 0
    }'
  );

-- Example 10546
Name     CloudName   SubscriptionId                        State    IsDefault
-------  ----------  ------------------------------------  -------  ----------
MyCloud  AzureCloud  13c...                                Enabled  True

-- Example 10547
az network private-endpoint show

-- Example 10548
az account get-access-token --subscription <SubscriptionID>

-- Example 10549
{
   "accessToken": "eyJ...",
   "expiresOn": "2021-05-21 21:38:31.401332",
   "subscription": "0cc...",
   "tenant": "d47...",
   "tokenType": "Bearer"
 }

-- Example 10550
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$AUTHORIZE_PRIVATELINK (
  '/subscriptions/26d.../resourcegroups/sf-1/providers/microsoft.network/privateendpoints/test-self-service',
  'eyJ...'
  );

-- Example 10551
use role accountadmin;
select key, value from table(flatten(input=>parse_json(system$get_privatelink_config())));

-- Example 10552
gcloud components update

-- Example 10553
gcloud auth login

-- Example 10554
gcloud config set project <project_id>

-- Example 10555
gcloud projects list --sort-by=projectId

-- Example 10556
gcloud compute addresses create <customer_vip_name> \
--subnet=<subnet_name> \
--addresses=<customer_vip_address>
--region=<region>

-- Example 10557
gcloud compute addresses create psc-vip-1 \
--subnet=psc-subnet \
--addresses=192.168.3.3 \
--region=us-central1

# returns

Created [https://www.googleapis.com/compute/v1/projects/docstest-123456/regions/us-central1/addresses/psc-vip-1].

-- Example 10558
gcloud compute forwarding-rules create <name> \
--region=<region> \
--network=<network_name> \
--address=<customer_vip_name> \
--target-service-attachment=<privatelink-gcp-service-attachment>

-- Example 10559
gcloud compute forwarding-rules create test-psc-rule \
--region=us-central1 \
--network=psc-vpc \
--address=psc-vip-1 \
--target-service-attachment=projects/us-central1-deployment1-c8cc/regions/us-central1/serviceAttachments/snowflake-us-central1-psc

# returns

Created [https://www.googleapis.com/compute/projects/mdlearning-293607/regions/us-central1/forwardingRules/test-psc-rule].

-- Example 10560
gcloud compute forwarding-rules list --regions=<region>

-- Example 10561
CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.count_positive_numbers(
  arg_t TABLE(
    arg_c1 NUMBER,
    arg_c2 NUMBER,
    arg_c3 NUMBER
  )
)
RETURNS NUMBER
AS
$$
  SELECT
    COUNT(*)
  FROM arg_t
  WHERE
    arg_c1>0
    AND arg_c2>0
    AND arg_c3>0
$$;

-- Example 10562
CREATE OR REPLACE DATA METRIC FUNCTION governance.dmfs.referential_check(
  arg_t1 TABLE (arg_c1 INT), arg_t2 TABLE (arg_c2 INT))
RETURNS NUMBER AS
 'SELECT COUNT(*) FROM arg_t1
  WHERE arg_c1 NOT IN (SELECT arg_c2 FROM arg_t2)';

-- Example 10563
ALTER TABLE salesorders
  ADD DATA METRIC FUNCTION governance.dmfs.referential_check
    ON (sp_id, TABLE (my_db.sch1.salespeople(sp_id)));

-- Example 10564
ALTER FUNCTION governance.dmfs.count_positive_numbers(
 TABLE(
   NUMBER,
   NUMBER,
   NUMBER
))
SET SECURE;

-- Example 10565
DESC FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(
    NUMBER, NUMBER, NUMBER
  )
);

