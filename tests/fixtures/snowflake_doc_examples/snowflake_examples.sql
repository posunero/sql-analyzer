-- Extracted Snowflake SQL Examples

-- From snowflake_split_246.sql
CREATE OR REPLACE STAGE jars_stage;
CREATE OR REPLACE STAGE data_stage DIRECTORY=(ENABLE=TRUE) ENCRYPTION = (TYPE='SNOWFLAKE_SSE');
CREATE FUNCTION process_pdf_func(file STRING)
RETURNS STRING
LANGUAGE JAVA
RUNTIME_VERSION = 11
IMPORTS = ('@jars_stage/pdfbox-app-2.0.27.jar')
HANDLER = 'PdfParser.readFile'
AS
$$
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class PdfParser {

    public static String readFile(InputStream stream) throws IOException {
        try (PDDocument document = PDDocument.load(stream)) {

            document.getClass();

            if (!document.isEncrypted()) {

                PDFTextStripperByArea stripper = new PDFTextStripperByArea();
                stripper.setSortByPosition(true);

                PDFTextStripper tStripper = new PDFTextStripper();

                String pdfFileInText = tStripper.getText(document);
                return pdfFileInText;
            }
        }
        return null;
    }
}
$$;
ALTER STAGE data_stage REFRESH;
SELECT process_pdf_func(BUILD_SCOPED_FILE_URL('@data_stage', '/myfile.pdf'));
CREATE PROCEDURE process_pdf_proc(file STRING)
RETURNS STRING
LANGUAGE JAVA
RUNTIME_VERSION = 11
IMPORTS = ('@jars_stage/pdfbox-app-2.0.28.jar');
ALTER STAGE data_stage REFRESH;
CREATE OR REPLACE STAGE data_stage DIRECTORY=(ENABLE=TRUE) ENCRYPTION = (TYPE='SNOWFLAKE_SSE');
CREATE OR REPLACE FUNCTION parse_csv(file STRING)
RETURNS TABLE (col1 STRING)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('pandas==1.5.3', 'common-helper-fns')
IMPORTS = ('@data_stage/sample.csv')
HANDLER = 'parse_csv.parse_csv_file';
ALTER STAGE data_stage REFRESH;
SELECT * FROM TABLE(PARSE_CSV(BUILD_SCOPED_FILE_URL(@data_stage, 'sample.csv')));
SELECT col1
FROM tab1
WHERE location = 'New York';
CREATE TABLE patients(
    patient_ID VARCHAR(50),
    category VARCHAR(50),
    diagnosis VARCHAR(100)
);
INSERT INTO patients (patient_ID, category, diagnosis) VALUES
('P001', 'MentalHealth', 'Anxiety'),
('P002', 'PhysicalHealth', 'Fever'),
('P003', 'MentalHealth', 'Depression');
CREATE VIEW mental_health_view AS
SELECT * FROM patients WHERE category = 'MentalHealth';
CREATE VIEW physical_health_view AS
SELECT * FROM patients WHERE category = 'PhysicalHealth';
SELECT * FROM physical_health_view
WHERE 1/IFF(category = 'MentalHealth', 0, 1) = 1;
SELECT * FROM patients
WHERE
patient_ID IN (
    SELECT patient_ID
    FROM mental_health_view
);
CREATE STAGE mystage;
CREATE OR REPLACE PROCEDURE MYPROC(value INT, fromTable STRING, toTable STRING, count INT)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
    BEGIN
        INSERT INTO identifier(:toTable) SELECT * FROM identifier(:fromTable) LIMIT :count;
        RETURN 'Success';
    END;
$$;
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
TYPE = 'IPV4'
VALUE_LIST = ('172.16.1.0/24');
CREATE OR REPLACE SECRET oauth_token
TYPE = 'GENERIC_SECRET'
API_AUTHENTICATION = 'OAUTH2'
OAUTH2_REFRESH_TOKEN = '...';
CREATE OR REPLACE SECRET bp_maps_api
TYPE = 'GENERIC_SECRET'
API_AUTHENTICATION = 'API_KEY'
API_KEY = '...';
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
ALLOWED_NETWORK_RULES = ('google_apis_network_rule')
ALLOWED_AUTHENTICATION_SECRETS = ('oauth_token', 'bp_maps_api');
CREATE OR REPLACE FUNCTION google_translate_python(sentence STRING, language STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('google-cloud-translate')
EXTERNAL_ACCESS_INTEGRATIONS = ('google_apis_access_integration')
HANDLER = 'translate_python.translate_text';
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT('AWS', 'us-west-2');
CREATE OR REPLACE NETWORK RULE aws_s3_network_rule
TYPE = 'IPV4'
VALUE_LIST = ('52.216.0.0/16');
CREATE OR REPLACE SECURITY INTEGRATION aws_s3_security_integration
TYPE = EXTERNAL_STAGE
ENABLED = TRUE
STORAGE_PROVIDER = S3
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/my-role';
CREATE OR REPLACE SECRET aws_s3_access_token
TYPE = 'GENERIC_SECRET'
API_AUTHENTICATION = 'AWS_SIGV4'
AWS_KEY_ID = '...' AWS_SECRET_KEY = '...';
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION aws_s3_external_access_integration
ALLOWED_NETWORK_RULES = ('aws_s3_network_rule')
ALLOWED_AUTHENTICATION_SECRETS = ('aws_s3_access_token');

-- From snowflake_split_261.sql
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
EXECUTE IMMEDIATE $$
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
$$;
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
EXECUTE IMMEDIATE $$
DECLARE
  ret1 NUMBER;
BEGIN
  CALL my_procedure('Manitoba', 127.4) into :ret1;
  RETURN ret1;
END;
$$;
SHOW IMAGE REPOSITORIES;
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;
DESCRIBE COMPUTE POOL tutorial_compute_pool;
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
SHOW SERVICES;
DESC SERVICE echo_service;
SHOW SERVICE CONTAINERS IN SERVICE echo_service;
CREATE FUNCTION my_echo_udf (InputText varchar)
  RETURNS varchar
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;
SELECT my_echo_udf('hello!');
CREATE TABLE messages (message_text VARCHAR)
  AS (SELECT * FROM (VALUES ('Thank you'), ('Hello'), ('Hello World')));
SELECT * FROM messages;
SELECT my_echo_udf(message_text) FROM messages;
SHOW ENDPOINTS IN SERVICE echo_service;
ALTER USER <user-name> SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';
CREATE [ OR REPLACE ] SNAPSHOT [ IF NOT EXISTS ] <name>
FROM SERVICE <service_name>;
CREATE SNAPSHOT snapshot_0
FROM SERVICE example_service;
ALTER SNAPSHOT [ IF EXISTS ] <name> SET COMMENT = '<string_literal>';
ALTER SNAPSHOT example_snapshot SET COMMENT = 'sample comment.';

-- From snowflake_split_273.sql
SELECT
  SYSTEM$TYPEOF(
     {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  ) AS object_cast_type,
  SYSTEM$TYPEOF(
     {'city':'San Mateo','state':'CA'}::VARIANT::OBJECT(city VARCHAR, state VARCHAR)
  ) AS variant_cast_type;
SELECT
  SYSTEM$TYPEOF(
    CAST ({'my_key':'my_value'} AS MAP(VARCHAR, VARCHAR))
  ) AS map_cast_type,
  SYSTEM$TYPEOF(
    CAST ({'my_key':'my_value'} AS MAP(VARCHAR, VARCHAR))
  ) AS variant_cast_type;
SELECT
  SYSTEM$TYPEOF(
    {'my_key':'my_value'}::MAP(VARCHAR, VARCHAR)
  ) AS map_cast_type,
  SYSTEM$TYPEOF(
    {'my_key':'my_value'}::VARIANT::MAP(VARCHAR, VARCHAR)
  ) AS variant_cast_type;
SELECT [1,2,NULL,3]::ARRAY(INTEGER)::VARIANT;
SELECT CAST(
  CAST([1,2,3] AS ARRAY(NUMBER))
  AS ARRAY(VARCHAR)) AS cast_array;
SELECT CAST({'city': 'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(state VARCHAR, city VARCHAR)) AS object_value_order;
SELECT CAST({'city':'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(city_name VARCHAR, state_name VARCHAR) RENAME FIELDS) AS object_value_key_names;
SELECT CAST({'city':'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(city VARCHAR, state VARCHAR, zipcode NUMBER) ADD FIELDS) AS add_fields;
SELECT ARRAY_CONSTRUCT(10, 20, 30)::ARRAY(NUMBER);
SELECT OBJECT_CONSTRUCT(
  'oname', 'abc',
  'created_date', '2020-01-18'::DATE
)::OBJECT(
  oname VARCHAR,
  created_date DATE
);
SELECT [10, 20, 30]::ARRAY(NUMBER);
SELECT {
  'oname': 'abc',
  'created_date': '2020-01-18'::DATE
}::OBJECT(
  oname VARCHAR,
  created_date DATE
);
SELECT OBJECT_CONSTRUCT(
  'city', 'San Mateo',
  'state', 'CA'
)::MAP(
  VARCHAR,
  VARCHAR
);
SELECT {
  'city': 'San Mateo',
  'state': 'CA'
}::MAP(
  VARCHAR,
  VARCHAR
);
SELECT {
  '-10': 'CA',
  '-20': 'OR'
}::MAP(
  NUMBER,
  VARCHAR
);
SELECT OBJECT_KEYS({'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR, state VARCHAR));
SELECT MAP_KEYS({'my_key':'my_value'}::MAP(VARCHAR,VARCHAR));
SELECT
  SYSTEM$TYPEOF(
    ARRAY_CONSTRUCT('San Mateo')[0]
  ) AS semi_structured_array_element,
  SYSTEM$TYPEOF(
    CAST(
      ARRAY_CONSTRUCT('San Mateo') AS ARRAY(VARCHAR)
    )[0]
  ) AS structured_array_element;
SELECT ARRAY_SIZE([1,2,3]::ARRAY(NUMBER));
SELECT MAP_SIZE({'my_key':'my_value'}::MAP(VARCHAR,VARCHAR));
SELECT ARRAY_CONTAINS(10, [1, 10, 100]::ARRAY(NUMBER));
SELECT ARRAY_POSITION(10, [1, 10, 100]::ARRAY(NUMBER));
SELECT MAP_CONTAINS_KEY('key_to_find', my_map);
SELECT MAP_CONTAINS_KEY(10, my_map);
SELECT ARRAYS_OVERLAP(numeric_array, other_numeric_array);
SELECT ARRAY_APPEND( [1,2]::ARRAY(DOUBLE), 3::NUMBER );
SELECT ARRAY_APPEND( [1,2]::ARRAY(DOUBLE), '3' );
SELECT ARRAY_APPEND( [1,2]::ARRAY(NUMBER), '2022-02-02'::DATE );
SELECT ARRAY_CAT( [1,2]::ARRAY(NUMBER), ['3','4'] );
SELECT ARRAY_CAT( [1,2], ['3','4']::ARRAY(VARCHAR) );
SELECT
  ARRAY_CAT(
    [1, 2, 3]::ARRAY(NUMBER NOT NULL),
    [5.5, NULL]::ARRAY(NUMBER(2, 1))
  ) AS concatenated_array,
  SYSTEM$TYPEOF(concatenated_array);
SELECT
  ARRAY_EXCEPT( [1,2]::ARRAY(NUMBER), [2,3]::ARRAY(DOUBLE) );
SELECT ARRAY_EXCEPT( [1,2]::ARRAY(NUMBER), ['2','3']::ARRAY(VARCHAR) );
SELECT OBJECT_DELETE( {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR), 'zip_code' );
SELECT
OBJECT_DELETE(
{'city':'San Mateo','state':'CA','zip_code':94404}::OBJECT(city VARCHAR,state VARCHAR,zip_code NUMBER),
'zip_code'
);
SELECT
OBJECT_DELETE(
{'city':'San Mateo','state':'CA','zip_code':null}::OBJECT(city VARCHAR,state VARCHAR,zip_code NUMBER),
'zip_code'
); 