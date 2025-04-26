-- Example 27579
module.exports = async function(context, request) {
    context.log('JavaScript HTTP trigger function processed a request.');

    if (request.body) {
        var rows = request.body.data;
        var results = [];
        rows.forEach(row => {
            results.push([row[0], row]);
        });

        results = {data: results}
        context.res = {
            status: 200,
            body: JSON.stringify(results)
        };
   }
   else {
       context.res = {
           status: 400,
           body: "Please pass data in the request body."
       };
   }
};

-- Example 27580
{
    "data": [ [ 0, 43, "page" ], [ 1, 42, "life, the universe, and everything" ] ]
}

-- Example 27581
{ "data":
    [
        [ 0, [ 0, 43, "page" ] ],
        [ 1, [ 1, 42, "life, the universe, and everything" ]  ]
    ]
}

-- Example 27582
================================================================================
=================== Tracking Worksheet: Google Cloud Console ===================
================================================================================

****** Step 1: Cloud Function (Remote Service) Info ****************************

Cloud Function Trigger URL: ____________________________________________________


****** Step 2: API Config File Info ********************************************

Path Suffix: ___________________________________________________________________
Configuration File Name: _______________________________________________________


****** Step 2: API Gateway (Proxy Service) Info ********************************

Managed Service Identifier: ____________________________________________________
Gateway Base URL : _____________________________________________________________


****** Steps 3-4: API Integration & External Function Info *********************

API Integration Name: __________________________________________________________
API_GCP_SERVICE_ACCOUNT: _______________________________________________________

External Function Name: ________________________________________________________


****** Step 5: Security Info ***************************************************

Security Definition Name: ______________________________________________________

-- Example 27583
select my_external_function(42, 'Life, the Universe, and Everything');

-- Example 27584
[42, "Life, the Universe, and Everything"]

-- Example 27585
================================================================================
======================= Tracking Worksheet: Azure Portal =======================
================================================================================

****** Step 1: Azure Function (Remote Service) Info ****************************

Azure Function app name: _______________________________________________________
HTTP-Triggered Function name: __________________________________________________
Azure Function AD app registration name: _______________________________________
Azure Function App AD Application ID: __________________________________________

    (The value for the Azure Function App AD Application ID above is the
    "Application (client) ID" of the Azure AD app registration for the
    Azure Function. The value is used to fill in the "azure_ad_application_id"
    field in the CREATE API INTEGRATION command. This value is in the form of a
    UUID (universally unique identifier), which contains hexadecimal digits and
    dashes.)


****** Step 2: Azure API Management Service (Proxy Service) Info ***************

API Management service name: ___________________________________________________
API Management API URL suffix: _________________________________________________


****** Steps 3-5: API Integration & External Function Info *********************

API Integration Name: __________________________________________________________
AZURE_MULTI_TENANT_APP_NAME: ___________________________________________________
AZURE_CONSENT_URL: _____________________________________________________________

External Function Name: ________________________________________________________

-- Example 27586
================================================================================
======================= Tracking Worksheet: ARM Template =======================
================================================================================

****** Step 1: Azure Function (Remote Service) Info ****************************

HTTP-Triggered Function name: __________________ echo __________________________
Azure Function AD Application ID: ______________________________________________

    (The value for the Azure Function AD Application ID above is the
    "Application (client) ID" of the Azure AD app registration for the
    Azure Function. The value is used to fill in the "azure_ad_application_id"
    field in the CREATE API INTEGRATION command. This value is in the form of a
    UUID (universally unique identifier), which contains hexadecimal digits and
    dashes.)


****** Step 2: Azure API Management Service (Proxy Service) Info ***************

API Management service name: ___________________________________________________
API Management URL: ____________________________________________________________
Azure Function HTTP Trigger URL: _______________________________________________
API Management API URL suffix: _________________________________________________


****** Steps 3-5: API Integration & External Function Info *********************

API Integration Name: __________________________________________________________
AZURE_MULTI_TENANT_APP_NAME: ___________________________________________________
AZURE_CONSENT_URL: _____________________________________________________________

External Function Name: ________________________________________________________

-- Example 27587
USE DATABASE <database_name>;
USE SCHEMA <schema_name>;

-- Example 27588
GRANT USAGE ON FUNCTION <external_function_name>(<parameter_data_type>) TO <role_name>;

-- Example 27589
GRANT USAGE ON FUNCTION echo(INTEGER, VARCHAR) TO analyst_role;

-- Example 27590
SELECT echo(42, 'Adams');

-- Example 27591
[0, 42, "Adams"]

-- Example 27592
Request failed for external function <function_name>. Error: 401 '{ "statusCode": 401, "message":
"Access denied due to missing subscription key. Make sure to include subscription key when making requests to an API." }'

-- Example 27593
Request failed for external function <function_name>. Error: 401 '{ "statusCode": 401, "message": "Invalid JWT." }'

-- Example 27594
Request failed for external function <function_name> with remote service error: 401 '{ "statusCode": 401, "message": "Invalid JWT." }'

-- Example 27595
{
    "data":
        [
            [0, 43, "page"],
            [1, 42, "life, the universe, and everything"]
        ]
}

-- Example 27596
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
        "Effect": "Allow",
        "Principal":
            {
            "AWS": "arn:aws:sts::<12-digit-number>:assumed-role/<external_function_role>/snowflake"
            },
        "Action": "execute-api:Invoke",
        "Resource": "<method_request_ARN>"
        }
    ]
}

-- Example 27597
arn:aws:iam::987654321098:role/MyNewIAMRole

-- Example 27598
"AWS": "arn:aws:sts::987654321098:assumed-role/MyNewIAMRole/snowflake"

-- Example 27599
arn:aws:execute-api:us-west-1:123456789012:a1b2c3d4e5/*/POST/MyResource

-- Example 27600
arn:aws:execute-api:us-west-1:123456789012:a1b2c3d4e5/*

-- Example 27601
arn:aws-us-gov:execute-api:us-gov-west-1:123456789012:a1b2c3d4e5/*

-- Example 27602
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:sts::<12-digit-number>:assumed-role/<external_function_role>/snowflake"
            },
            "Action": "execute-api:Invoke",
            "Resource": "<method_request_ARN>",
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpc": "<VPC_ID>"
                }
            }
        }
    ]
}

-- Example 27603
arn:aws-us-gov:execute-api:us-gov-west-1:123456789012:a1b2c3d4e5/*

-- Example 27604
snow init
  <path>
  --template <template>
  --template-source <template_source>
  --variable <variables>
  --no-interactive
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27605
snow init new_snowpark_project --template example_snowpark

  Project identifier (used to determine artifacts stage path) [my_snowpark_project]:
  What stage should the procedures and functions be deployed to? [dev_deployment]: snowpark

-- Example 27606
Initialized the new project in new_snowpark_project

-- Example 27607
snow init new_streamlit_project --template-source ../local_templates/example_streamlit -D query_warehouse=dev_wareshouse -D stage=testing

  Name of the streamlit app [streamlit_app]: My streamlit

-- Example 27608
Initialized the new project in new_streamlit_project

-- Example 27609
entities:
  entity_a:
    ...
  entity_b:
    ...

-- Example 27610
entities:
  entity_a:
    ...
  entity_b:
    ...

-- Example 27611
entities:
  entity_a:
    identifier: entity_a_name
    ...
  entity_b:
    identifier:
      name: entity_a_name

-- Example 27612
entities:
  entity_b:
    identifier:
      name: entity_a_name
      schema: public
      database: DEV

-- Example 27613
definition_version: 2
mixins:
  stage_mixin:
    stage: "my_stage"
  snowpark_shared:
    artifacts: ["app/"]
    imports: ["@package_stage/package.zip"]

entities:
  my_function:
    type: "function"
    ...
    meta:
      use_mixins:
        - "stage_mixin"
        - "snowpark_shared"
  my_dashboard:
    type: "dashboard"
    ...
    meta:
      use_mixins:
        - "stage_mixin"

-- Example 27614
mixins:
  mixin_1:
    key: mixin_1_value
  mixin_2:
    key: mixin_2_value

entities:
  foo:
    meta:
      use_mixin:
      - mixin_1
      - mixin_2

-- Example 27615
definition_version: 2
mixins:
  mix1:
    stage: A

  mix2:
    stage: B

entities:
  test_procedure:
    stage: C
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27616
definition_version: 2
entities:
  test_procedure:
    stage: C

-- Example 27617
definition_version: 2
mixins:
  mix1:
    artifacts:
    - a.py

  mix2:
    artifacts:
    - b.py

entities:
  test_procedure:
    artifacts:
      - app/
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27618
definition_version: 2
entities:
  test_procedure:
    artifacts:
      - a.py
      - b.py
      - app/

-- Example 27619
definition_version: 2
mixins:
  mix1:
    secrets:
      secret1: v1

  mix2:
    secrets:
      secret2: v2

entities:
  test_procedure:
    secrets:
      secret3: v3
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27620
definition_version: 2
entities:
  test_procedure:
    secrets:
      secret1: v1
      secret2: v2
      secret3: v3

-- Example 27621
definition_version: 2
mixins:
  mix1:
    secrets:
      secret_name: v1

  mix2:
    secrets:
      secret_name: v2

entities:
  test_procedure:
    secrets:
      secret_name: v3
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27622
definition_version: 2
entities:
  test_procedure:
    secrets:
      secret_name: v3

-- Example 27623
definition_version: 2
mixins:
  shared:
    identifier:
      schema: foo

entities:
  sproc1:
    identifier:
      name: sproc
    meta:
      use_mixins: ["shared"]
  sproc2:
    identifier:
      name: sproc
      schema: from_entity
    meta:
      use_mixins: ["shared"]

-- Example 27624
definition_version: 2
entities:
  sproc1:
    identifier:
      name: sproc
      schema: foo
  sproc2:
    identifier:
      name: sproc
      schema: from_entity

-- Example 27625
definition_version: 2
env:
  database: "dev"
  role: "eng_rl"

-- Example 27626
snow sql \
-q "grant usage on database <% database %> to <% role %>" \
-D "database=dev" \
-D "role=eng_rl"

-- Example 27627
snow sql -q "grant usage on database <% ctx.env.database %> to <% ctx.env.role %>"

-- Example 27628
definition_version: 2
entities:
  test_function:
    type: "function"
    stage: "dev_deployment"
    artifacts: ["app/"]
    handler: "functions.hello_function"
    signature: ""
    returns: string

  hello_procedure:
    type: "procedure"
    stage: "dev_deployment"
    artifacts: ["app/"]
    handler: "procedures.hello_procedure"
    signature:
      - name: "name"
        type: "string"
    returns: string

env:
  database: "dev"
  role: "eng_rl"

-- Example 27629
export database="other"

-- Example 27630
definition_version: 2
env:
  name: "my-app"
entities:
  my_streamlit:
    type: "streamlit"
    identifier: <% ctx.env.name %>

-- Example 27631
export name="other"

-- Example 27632
definition_version: 2
entities:
  pkg:
    type: application package
    artifacts:
      - src: app/*
        dest: ./
  app:
    type: application
    from:
      target: pkg

-- Example 27633
<% ctx.entities.app.identifier %>
<% ctx.entities.pkg.identifier %>

-- Example 27634
definition_version: "1.1"
env:
  schema: "test"
streamlit:
  name: "MY_APP"
  schema: <% ctx.env.schema %>

-- Example 27635
schema="staging"; snow streamlit deploy
schema="prod"; snow streamlit deploy

-- Example 27636
definition_version: "1.1"
streamlit:
  name: "MY_APP"
  schema: <% ctx.env.schema %>

-- Example 27637
definition_version: 2
entities:
  pkg:
    type: application package
    identifier: <% fn.concat_ids(ctx.env.app_name, ctx.env.pkg_suffix) %>
    artifacts:
      - src: app/*
        dest: ./
  app:
    type: application
    identifier: <% fn.concat_ids(ctx.env.app_name, ctx.env.app_suffix) %>

env:
  app_name: myapp_base_name_<% fn.sanitize_id(fn.get_username()) %>
  app_suffix: _app_instance
  pkg_suffix: _pkg

-- Example 27638
DESC APPLICATION <% fn.str_to_id(ctx.entities.app.identifier) %>;
DESC APPLICATION PACKAGE <% fn.str_to_id(ctx.entities.pkg.identifier) %>;

-- Example 27639
cd <project-directory>
snow helpers v1-to-v2

-- Example 27640
Project definition migrated to version 2.

-- Example 27641
cd <project-directory>
snow helpers v1-to-v2

-- Example 27642
Project definition is already at version 2.

-- Example 27643
cd <project-directory>
snow helpers v1-to-v2

-- Example 27644
+- Error-------------------------------------------------------------------+
| snowflake.local.yml file detected, please specify                        |
| --migrate-local-overrides to include or --no-migrate-local-overrides to  |
| exclude its values.                                                      |
+--------------------------------------------------------------------------+

-- Example 27645
cd <project-directory>
snow helpers v1-to-v2

