-- Example 30122
select
  lah.exchange_name,
  lah.listing_global_name,
  lah.share_name,
  los.value:"objectName"::string as object_name,
  coalesce(los.value:"objectDomain"::string, los.value:"objectDomain"::string) as object_type,
  count(distinct lah.query_token) as n_queries,
  count(distinct lah.consumer_account_locator) as n_distinct_consumer_accounts
from SNOWFLAKE.DATA_SHARING_USAGE.LISTING_ACCESS_HISTORY as lah
join lateral flatten(input=>lah.listing_objects_accessed) as los
where true
  and query_date between '2022-03-01' and '2022-04-30'
group by 1,2,3,4,5
order by 1,2,3,4,5;

-- Example 30123
select
  lah.exchange_name,
  lah.listing_global_name,
  lah.share_name,
  los.value:"objectName"::string as object_name,
  coalesce(los.value:"objectDomain"::string, los.value:"objectDomain"::string) as object_type,
  consumer_account_locator,
  count(distinct lah.query_token) as n_queries
from SNOWFLAKE.DATA_SHARING_USAGE.LISTING_ACCESS_HISTORY as lah
join lateral flatten(input=>lah.listing_objects_accessed) as los
where true
  and query_date between '2022-03-01' and '2022-04-30'
group by 1,2,3,4,5,6
order by 1,2,3,4,5,6;

-- Example 30124
select
  los.value:"objectDomain"::string as object_type,
  los.value:"objectName"::string as object_name,
  cols.value:"columnName"::string as column_name,
  count(distinct lah.query_token) as n_queries,
  count(distinct lah.consumer_account_locator) as n_distinct_consumer_accounts
from SNOWFLAKE.DATA_SHARING_USAGE.LISTING_ACCESS_HISTORY as lah
join lateral flatten(input=>lah.listing_objects_accessed) as los
join lateral flatten(input=>los.value, path=>'columns') as cols
where true
  and los.value:"objectDomain"::string in ('Table', 'View')
  and query_date between '2022-03-01' and '2022-04-30'
  and los.value:"objectName"::string = 'DATABASE_NAME.SCHEMA_NAME.TABLE_NAME'
  and lah.consumer_account_locator = 'CONSUMER_ACCOUNT_LOCATOR'
group by 1,2,3;

-- Example 30125
with
accesses as (
  select
    lah.query_token,
    array_agg(distinct los.value:"objectName"::string) as object_names
  from SNOWFLAKE.DATA_SHARING_USAGE.LISTING_ACCESS_HISTORY as lah
  join lateral flatten(input=>lah.listing_objects_accessed) as los
  where true
    and los.value:"objectDomain"::string in ('Table', 'View')
    and query_date between '2022-03-01' and '2022-04-30'
  group by 1
)
select
  object_names,
  sum(1) as n_queries
from accesses
group by 1

-- Example 30126
with
accesses as (
  select distinct
    los.value:"objectDomain"::string as object_type,
    los.value:"objectName"::string as object_name,
    lah.query_token,
    lah.consumer_account_locator
  from SNOWFLAKE.DATA_SHARING_USAGE.LISTING_ACCESS_HISTORY as lah
  join lateral flatten(input=>lah.listing_objects_accessed) as los
  where true
    and los.value:"objectDomain"::string in ('Table', 'View')
    and query_date between '2022-03-01' and '2022-04-30'
)
select
  a1.object_name as object_name_1,
  a2.object_name as object_name_2,
  a1.consumer_account_locator as consumer_account_locator,
  count(distinct a1.query_token) as n_queries
from accesses as a1
join accesses as a2
  on a1.query_token = a2.query_token
  and a1.object_name < a2.object_name
group by 1,2,3;

-- Example 30127
SELECT
   listing_name,
   listing_display_name,
   SUM(jobs) AS jobs
FROM snowflake.data_sharing_usage.listing_consumption_daily
WHERE 1=1
   AND event_date BETWEEN '2021-01-01' AND '2021-01-31'
GROUP BY 1,2
ORDER BY 3 DESC

-- Example 30128
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY listing_name, listing_display_name ORDER BY jobs DESC) AS rank
FROM (
  SELECT
    listing_name,
    listing_display_name,
    consumer_account_locator,
    SUM(jobs) AS jobs
  FROM snowflake.data_sharing_usage.listing_consumption_daily
  WHERE 1=1
    AND event_date BETWEEN '2021-01-01' AND '2021-01-31'
  GROUP BY 1,2,3
)
ORDER BY
  listing_name,
  listing_display_name,
  rank

-- Example 30129
SELECT
  listing_name,
  listing_display_name,
  event_date,
  event_type,
  SUM(1) AS count_gets_requests
FROM snowflake.data_sharing_usage.listing_events_daily
GROUP BY 1,2,3,4

-- Example 30130
SELECT
  listing_name,
  listing_display_name,
  event_date,
  SUM(IFF(event_type = 'LISTING CLICK', consumer_accounts_daily, 0)) AS listing_clicks,
  SUM(IFF(event_type IN ('GET', 'REQUEST') and action = 'STARTED', consumer_accounts_daily, 0)) AS get_request_started,
  SUM(IFF(event_type IN ('GET', 'REQUEST') and action = 'COMPLETED', consumer_accounts_daily, 0)) AS get_request_completed,
  get_request_completed / NULLIFZERO(listing_clicks) AS ctr
FROM snowflake.data_sharing_usage.LISTING_TELEMETRY_DAILY
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- Example 30131
SELECT
  listing_name,
  listing_display_name,
  event_date,
  COUNT_IF(event_type= 'listing_view' AND region_group='NONE') as unknown_user_view_count,
  COUNT_IF(event_type= 'listing_view' AND region_group!='NONE') as known_user_view_count
FROM snowflake.data_sharing_usage.LISTING_TELEMETRY_DAILY
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- Example 30132
SELECT
  event_date,
  listing_name,
  listing_global_name,
  consumer_account_name,
  consumer_account_locator,
  consumer_organization_name,
  current_pricing_plan,
  next_pricing_plan,
  is_consumer_auto_renewal_enabled,
  purchase_state,
  current_pricing_plan_start_on,
  current_pricing_plan_end_on,
  trial_end_on,
  access_end_on
FROM snowflake.data_sharing_usage.paid_listing_access_and_change_log
WHERE TRUE
  AND consumer_organization_name = 'specific_organization_name'
  AND listing_display_name = 'specific_listing_display_name'
ORDER BY event_date DESC;

-- Example 30133
SELECT
  event_date,
  listing_name,
  listing_global_name,
  consumer_account_name,
  consumer_account_locator,
  consumer_organization_name,
  current_pricing_plan,
  next_pricing_plan,
  is_consumer_auto_renewal_enabled,
  purchase_state,
  current_pricing_plan_start_on,
  current_pricing_plan_end_on,
  trial_end_on,
  access_end_on
FROM snowflake.data_sharing_usage.paid_listing_access_and_change_log
WHERE TRUE
  AND consumer_organization_name = 'specific_organization_name'
  AND listing_display_name = 'specific_listing_display_name'
QUALIFY TRUE
  AND ROW_NUMBER() OVER (
   PARTITION BY
    consumer_organization_name,
    consumer_snowflake_region,
    consumer_account_name,
    listing_display_name
ORDER BY event_date DESC ) = 1;

-- Example 30134
SQL Execution Error: Cannot create catalog integration <catalog_integration_name> due to error: Unable to process: Unable to find
warehouse <catalog_name>. Check the REST configuration and ensure the warehouse name '<catalog_name>' matches the Polaris catalog
name.

-- Example 30135
SQL Execution Error: User provided authentication credentials are invalid for catalog integration <catalog_integration_name> due
to error: Malformed request: unauthorized_client: The client is not authorized.

-- Example 30136
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The Snowflake service
connection associated with the Polaris catalog integration does not have the required privileges to send notifications. The
minimum required privileges are TABLE_CREATE, TABLE_WRITE_PROPERTIES, TABLE_DROP, NAMESPACE_CREATE, and NAMESPACE_DROP.

-- Example 30137
SQL Execution Error: Failed to access the REST endpoint of catalog integration <catalog_integration_name> with error: Unable to
process: Failed to get subscoped credentials: Error assuming AWS_ROLE:
User: <IAM_user_arn> is not authorized to perform: sts:AssumeRole on resource: <S3_role_arn>. Check the accessibility of the REST
catalog URI or warehouse.

-- Example 30138
{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "",
         "Effect": "Allow",
         "Principal": {
           "AWS": [
               "arn:aws:iam::111111111111:user/----0000-s",
               "arn:aws:iam::222222222222:user/----0000-s"
            ]
         },
         "Action": "sts:AssumeRole",
         "Condition": {
           "StringEquals": {
             "sts:ExternalId": "iceberg_table_external_id"
           }
         }
       }
     ]
   }

-- Example 30139
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The associated Polaris
catalog cannot be of type INTERNAL.

-- Example 30140
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: SQL Execution Error:
Resource on the REST endpoint of catalog integration CATINT is forbidden due to error: Forbidden: Invalid locations '[<path to metadata file>]'
for identifier '<identifier>': <path to metadata file> is not in the list of allowed locations: [<list of allowed locations>].

-- Example 30141
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The Snowflake service
connection associated with the Polaris catalog integration does not have the required privileges to send notifications. The minimum
required privileges are TABLE_CREATE, TABLE_WRITE_PROPERTIES, TABLE_DROP, NAMESPACE_CREATE, and NAMESPACE_DROP.

-- Example 30142
SQL Execution Error: Failed to access the REST endpoint of catalog integration <catalog_integration_name> with error: Unable to
process: Failed to get subscoped credentials: Error assuming AWS_ROLE:
User: <IAM_user_arn> is not authorized to perform: sts:AssumeRole on resource: <S3_role_arn>. Check the accessibility of the REST
catalog URI or warehouse.

-- Example 30143
{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "",
         "Effect": "Allow",
         "Principal": {
           "AWS": [
               "arn:aws:iam::111111111111:user/----0000-s",
               "arn:aws:iam::222222222222:user/----0000-s"
            ]
         },
         "Action": "sts:AssumeRole",
         "Condition": {
           "StringEquals": {
             "sts:ExternalId": "iceberg_table_external_id"
           }
         }
       }
     ]
   }

-- Example 30144
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The associated Polaris
catalog cannot be of type INTERNAL.

-- Example 30145
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: SQL Execution Error:
Resource on the REST endpoint of catalog integration CATINT is forbidden due to error: Forbidden: Invalid locations '[<path to metadata file>]'
for identifier '<identifier>': <path to metadata file> is not in the list of allowed locations: [<list of allowed locations>].

-- Example 30146
var connection = snowflake.createConnection({
  account: "myaccount.us-east-2",
  username: "myusername",
  password: "mypassword"
});

-- Example 30147
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

-- Example 30148
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

-- Example 30149
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

-- Example 30150
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

-- Example 30151
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

-- Example 30152
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

-- Example 30153
<model_name>!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 30154
ACCOUNT=<account_name>
GSIP=<account_name>.snowflakecomputing.com
PORT=443

-- Example 30155
sfsql [ -u <user> ] [ -c <password> ] [ -d <database> ] [ -s <schema> ] ... [ -h ]

-- Example 30156
$ cd /Users/user1/client
$ ./sfsql -u user1 -c 1234567a

using GNU readline (Brian Fox, Chet Ramey), Java wrapper by Bernhard Bablok
henplus config at /Users/ybrenman/.henplus
----------------------------------------------------------------------------
 HenPlus II 0.9.8 "Yay Labor Day"
 Copyright(C) 1997..2009 Henner Zeller <H.Zeller@acm.org>
 HenPlus is provided AS IS and comes with ABSOLUTELY NO WARRANTY
 This is free software, and you are welcome to redistribute it under the
 conditions of the GNU Public License <http://www.gnu.org/licenses/gpl2.txt>
----------------------------------------------------------------------------
HenPlus II connecting
 url 'jdbc:snowflake://xy12345.snowflakecomputing.com:443/?account=xy12345&user=user1&ssl=on'
 driver version 2.3
 Snowflake - 1.0 (driver change version: 2.3.1, latest change version: 2.4.38)
no transactions.
 No Transaction *

user1@snowflake:xy12345.snowflakecomputing.com>

-- Example 30157
user1@xy12345.snowflakecomputing.com> set-property sql-result-showfooter false
user1@xy12345.snowflakecomputing.com> set-property sql-result-showheader false

-- Example 30158
user1@xy12345.snowflakecomputing.com> select * from test1;


user1@xy12345.snowflakecomputing.com> select * from test1
                                      ;;

user1@xy12345.snowflakecomputing.com> select * from test1
                                      /

-- Example 30159
user1@xy12345.snowflakecomputing.com> @/Users/user1/scripts/query.sql

-- Example 30160
info [ <topic> | <subtopic> ]

-- Example 30161
info;

info warehouses;

info alter_warehouse;

-- Example 30162
yum install libiodbc

-- Example 30163
which odbcinst

which isql

-- Example 30164
yum search unixODBC

yum install unixODBC.x86_64

-- Example 30165
odbcinst -j

-- Example 30166
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 2A3149C82551A34A

-- Example 30167
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 30168
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 30169
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 30170
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 30171
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 30172
gpg: keyserver receive failed: Server indicated a failure

-- Example 30173
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 30174
gpg --list-keys

-- Example 30175
rpm -K snowflake-odbc-<version>.x86_64.rpm

-- Example 30176
rpm -K snowflake-odbc-<version>.x86_64.rpm

-- Example 30177
snowflake-odbc-<version>.x86_64.rpm: digests SIGNATURES NOT OK

rpm -Kv snowflake-odbc-<version>.x86_64.rpm

-- Example 30178
snowflake-odbc-<version>.rpm:
    Header V4 RSA/SHA1 Signature, key ID 98cb005c: NOKEY
    Header SHA1 digest: OK
    V4 RSA/SHA1 Signature, key ID 98cb005c: NOKEY
    MD5 digest: OK

-- Example 30179
gpg --export -a <GPG_KEY_ID> > odbc-signing-key.asc
sudo rpm --import odbc-signing-key.asc
rpm -K snowflake-odbc-<version>.x86_64.rpm

-- Example 30180
sudo apt-get install debsig-verify

-- Example 30181
mkdir /usr/share/debsig/keyrings/<GPG_KEY_ID>
gpg --export <GPG_KEY_ID> > snowflakeKey.asc
touch /usr/share/debsig/keyrings/<GPG_KEY_ID>/debsig.gpg
gpg --no-default-keyring --keyring /usr/share/debsig/keyrings/<GPG_KEY_ID>/debsig.gpg --import snowflakeKey.asc

-- Example 30182
/etc/debsig/policies/<GPG_KEY_ID>

-- Example 30183
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

-- Example 30184
sudo debsig-verify snowflake-odbc-<version>.x86_64.deb

-- Example 30185
gpg --delete-key "Snowflake Computing"

-- Example 30186
[snowflake-odbc]
name=snowflake-odbc
baseurl=https://sfc-repo.snowflakecomputing.com/odbc/linux/<VERSION_NUMBER>/
gpgkey=https://sfc-repo.snowflakecomputing.com/odbc/Snowkey-<GPG_KEY_ID>-gpg

-- Example 30187
[snowflake-odbc]
name=snowflake-odbc
baseurl=https://sfc-repo.azure.snowflakecomputing.com/odbc/linux/<VERSION_NUMBER>/
gpgkey=https://sfc-repo.azure.snowflakecomputing.com/odbc/Snowkey-<GPG_KEY_ID>-gpg

-- Example 30188
yum install snowflake-odbc

