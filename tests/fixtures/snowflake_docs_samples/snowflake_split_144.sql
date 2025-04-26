-- Example 9629
-- Create an internal stage to store the JAR files.
CREATE OR REPLACE STAGE jars_stage;

-- Create an internal stage to store the data files. The stage includes a directory table.
CREATE OR REPLACE STAGE data_stage DIRECTORY=(ENABLE=TRUE) ENCRYPTION = (TYPE='SNOWFLAKE_SSE');

-- Example 9630
PUT file:///tmp/pdfbox-app-2.0.27.jar @jars_stage AUTO_COMPRESS=FALSE;

-- Example 9631
PUT file://C:\temp\pdfbox-app-2.0.27.jar @jars_stage AUTO_COMPRESS=FALSE;

-- Example 9632
PUT file:///tmp/myfile.pdf @data_stage AUTO_COMPRESS=FALSE;

-- Example 9633
PUT file://C:\temp\myfile.pdf @data_stage AUTO_COMPRESS=FALSE;

-- Example 9634
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

-- Example 9635
ALTER STAGE data_stage REFRESH;

-- Example 9636
SELECT process_pdf_func(BUILD_SCOPED_FILE_URL('@data_stage', '/myfile.pdf'));

-- Example 9637
CREATE PROCEDURE process_pdf_proc(file STRING)
RETURNS STRING
LANGUAGE JAVA
RUNTIME_VERSION = 11
IMPORTS = ('@jars_stage/pdfbox-app-2.0.28.jar')
HANDLER = 'PdfParser.readFile'
PACKAGES = ('com.snowflake:snowpark:latest')
AS
$$
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import com.snowflake.snowpark_java.types.SnowflakeFile;
import com.snowflake.snowpark_java.Session;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class PdfParser {

    public static String readFile(Session session, String fileURL) throws IOException {
        SnowflakeFile file = SnowflakeFile.newInstance(fileURL);
        try (PDDocument document = PDDocument.load(file.getInputStream())) {

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

-- Example 9638
ALTER STAGE data_stage REFRESH;

-- Example 9639
CALL process_pdf_proc(BUILD_SCOPED_FILE_URL('@data_stage', '/UsingThird-PartyPackages.pdf'));

-- Example 9640
-- Create an internal stage to store the data files. The stage includes a directory table.
CREATE OR REPLACE STAGE data_stage DIRECTORY=(ENABLE=TRUE) ENCRYPTION = (TYPE='SNOWFLAKE_SSE');

-- Example 9641
PUT file:///tmp/sample.csv @data_stage AUTO_COMPRESS=FALSE;

-- Example 9642
PUT file://C:\temp\sample.csv @data_stage AUTO_COMPRESS=FALSE;

-- Example 9643
CREATE OR REPLACE FUNCTION parse_csv(file STRING)
RETURNS TABLE (col1 STRING, col2 STRING, col3 STRING )
LANGUAGE JAVA
HANDLER = 'CsvParser'
AS
$$
import org.xml.sax.SAXException;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;
import com.snowflake.snowpark_java.types.SnowflakeFile;

public class CsvParser {

  static class Record {
    public String col1;
    public String col2;
    public String col3;

    public Record(String col1_value, String col2_value, String col3_value)
    {
      col1 = col1_value;
      col2 = col2_value;
      col3 = col3_value;
    }
  }

  public static Class getOutputClass() {
    return Record.class;
  }

  static class CsvStreamingReader {
    private final BufferedReader csvReader;

    public CsvStreamingReader(InputStream is) {
      this.csvReader = new BufferedReader(new InputStreamReader(is));
    }

    public void close() {
      try {
        this.csvReader.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }

    Record getNextRecord() {
      String csvRecord;

      try {
        if ((csvRecord = csvReader.readLine()) != null) {
          String[] columns = csvRecord.split(",", 3);
          return new Record(columns[0], columns[1], columns[2]);
        }
      } catch (IOException e) {
        throw new RuntimeException("Reading CSV failed.", e);
      } finally {
        // No more records, we can close the reader.
        close();
      }

      // Return null to indicate the end of the stream.
      return null;
    }
  }

  public Stream<Record> process(String file_url) throws IOException {
    SnowflakeFile file = SnowflakeFile.newInstance(file_url);

    CsvStreamingReader csvReader = new CsvStreamingReader(file.getInputStream());
    return Stream.generate(csvReader::getNextRecord);
  }
}
$$
;

-- Example 9644
ALTER STAGE data_stage REFRESH;

-- Example 9645
-- Input a file URL.
SELECT * FROM TABLE(PARSE_CSV(BUILD_SCOPED_FILE_URL(@data_stage, 'sample.csv')));

-- Example 9646
CREATE OR REPLACE SECURE VIEW images_scoped_v AS
SELECT BUILD_SCOPED_FILE_URL(@mystage, relative_path) AS scoped_file_url
FROM DIRECTORY(@mystage);

-- Example 9647
CREATE OR REPLACE SECURE VIEW images_for_client_abc AS
SELECT build_scoped_file_url(@myStage, relative_path) AS scoped_file_url
FROM directory(@mystage) d join clients c on d.relative_path = c.relative_path
WHERE c.client_name = 'abc';

-- Example 9648
CREATE OR REPLACE SECURE VIEW images_presigned_v AS
SELECT GET_PRESIGNED_URL(@mystage, relative_path, 60) AS presigned_url
FROM DIRECTORY(@mystage);

-- Example 9649
CREATE SHARE my_share;
GRANT SELECT ON my_secure_view TO SHARE my_share;

-- Example 9650
ALTER SHARE my_share ADD ACCOUNTS=consumer_account_1;

-- Example 9651
COPY INTO my_table FROM @custom_stage
  FILE_PROCESSOR = (
    SCANNER = 'document_ai'
    SCANNER_OPTIONS = (project_name = 'DEMO0200', model_name = 'predict' model_version = '1'));

-- Example 9652
CREATE OR REPLACE TABLE docai_results (inspection_date date, inspector varchar);

COPY INTO docai_results FROM (SELECT $1:inspection_date[0].value::date, $1:inspector[0].value FROM @custom_stage)
  FILE_PROCESSOR = (
    SCANNER = 'document_ai'
    SCANNER_OPTIONS = (project_name = 'DEMO0201', model_name = 'predict' model_version = '1'));

-- Example 9653
SELECT [<alias>.]$<file_col_num>[:<element>] [ , [<alias>.]$<file_col_num>[:<element>] , ...  ]
  FROM { <internal_location> | <external_location> }
  [ ( FILE_FORMAT => '<namespace>.<named_file_format>', PATTERN => '<regex_pattern>' ) ]
  [ <alias> ]

-- Example 9654
LIST @my_gcs_stage;

+---------------------------------------+------+----------------------------------+-------------------------------+
| name                                  | size | md5                              | last_modified                 |
|---------------------------------------+------+----------------------------------+-------------------------------|
| my_gcs_stage/load/                    |  12  | 12348f18bcb35e7b6b628ca12345678c | Mon, 11 Sep 2019 16:57:43 GMT |
| my_gcs_stage/load/data_0_0_0.csv.gz   |  147 | 9765daba007a643bdff4eae10d43218y | Mon, 11 Sep 2019 18:13:07 GMT |
+---------------------------------------+------+----------------------------------+-------------------------------+

-- Example 9655
a|b
c|d

-- Example 9656
e|f
g|h

-- Example 9657
-- Create a file format.
CREATE OR REPLACE FILE FORMAT myformat TYPE = 'csv' FIELD_DELIMITER = '|';

-- Create an internal stage.
CREATE OR REPLACE STAGE mystage1;

-- Stage the data files.
PUT file:///tmp/data*.csv @mystage1;

-- Query the filename and row number metadata columns and the regular data columns in the staged file.
-- Optionally apply pattern matching to the set of files in the stage and optional path.
-- Note that the table alias is provided to make the statement easier to read and is not required.
SELECT t.$1, t.$2 FROM @mystage1 (file_format => 'myformat', pattern=>'.*data.*[.]csv.gz') t;

+----+----+
| $1 | $2 |
|----+----|
| a  | b  |
| c  | d  |
| e  | f  |
| g  | h  |
+----+----+

SELECT t.$1, t.$2 FROM @mystage1 t;

+-----+------+
| $1  | $2   |
|-----+------|
| a|b | NULL |
| c|d | NULL |
| e|f | NULL |
| g|h | NULL |
+-----+------+

-- Example 9658
SELECT ascii(t.$1), ascii(t.$2) FROM @mystage1 (file_format => myformat) t;

+-------------+-------------+
| ASCII(T.$1) | ASCII(T.$2) |
|-------------+-------------|
|          97 |          98 |
|          99 |         100 |
|         101 |         102 |
|         103 |         104 |
+-------------+-------------+

-- Example 9659
{"a": {"b": "x1","c": "y1"}},
{"a": {"b": "x2","c": "y2"}}

-- Example 9660
-- Create a file format
CREATE OR REPLACE FILE FORMAT my_json_format TYPE = 'json';

-- Create an internal stage
CREATE OR REPLACE STAGE mystage2 FILE_FORMAT = my_json_format;

-- Stage the data file
PUT file:///tmp/data1.json @mystage2;

-- Query the repeating a.b element in the staged file
SELECT parse_json($1):a.b FROM @mystage2/data1.json.gz;

+--------------------+
| PARSE_JSON($1):A.B |
|--------------------|
| "x1"               |
| "x2"               |
+--------------------+

-- Example 9661
a|b
c|d

-- Example 9662
e|f
g|h

-- Example 9663
-- Create a file format
CREATE OR REPLACE FILE FORMAT myformat
  TYPE = 'csv' FIELD_DELIMITER = '|';

-- Create an internal stage
CREATE OR REPLACE STAGE mystage1;

-- Stage a data file
PUT file:///tmp/data*.csv @mystage1;

-- Query the filename and row number metadata columns and the regular data columns in the staged file
-- Note that the table alias is provided to make the statement easier to read and is not required
SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, METADATA$FILE_CONTENT_KEY, METADATA$FILE_LAST_MODIFIED, METADATA$START_SCAN_TIME, t.$1, t.$2 FROM @mystage1 (file_format => myformat) t;

+-------------------+--------------------------+---------------------------+-----------------------------+-------------------------------+----+----+
| METADATA$FILENAME | METADATA$FILE_ROW_NUMBER | METADATA$FILE_CONTENT_KEY | METADATA$FILE_LAST_MODIFIED |      METADATA$START_SCAN_TIME | $1 | $2 |
|-------------------+--------------------------+---------------------------+-----------------------------+-------------------------------+----+----|
| data2.csv.gz      |                        1 | aaa11bb2cccccaaaaac1234d9 |     2022-05-01 10:15:57.000 |  2023-02-02 01:31:00.713 +0000| e  | f  |
| data2.csv.gz      |                        2 | aa387aabb2ccedaaaaac123b8 |     2022-05-01 10:05:35.000 |  2023-02-02 01:31:00.755 +0000| g  | h  |
| data1.csv.gz      |                        1 | 39ab11bb2cdeacdcdac1234d9 |     2022-08-03 10:15:26.000 |  2023-02-02 01:31:00.778 +0000| a  | b  |
| data1.csv.gz      |                        2 | 2289aab2abcdeaacaaac348d0 |     2022-09-10 11:15:55.000 |  2023-02-02 01:31:00.778 +0000| c  | d  |
+-------------------+--------------------------+---------------------------+-----------------------------+-------------------------------+----+----+

SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, METADATA$FILE_CONTENT_KEY, METADATA$FILE_LAST_MODIFIED, METADATA$START_SCAN_TIME, t.$1, t.$2 FROM @mystage1 t;

+-------------------+--------------------------+---------------------------+-----------------------------+-------------------------------+-----+------+
| METADATA$FILENAME | METADATA$FILE_ROW_NUMBER | METADATA$FILE_CONTENT_KEY | METADATA$FILE_LAST_MODIFIED |      METADATA$START_SCAN_TIME | $1  | $2   |
|-------------------+--------------------------+---------------------------+-----------------------------+-------------------------------+-----+------|
| data2.csv.gz      |                        1 | aaa11bb2cccccaaaaac1234d9 |     2022-05-01 10:15:57.000 |  2023-02-02 01:31:00.713 +0000| e|f | NULL |
| data2.csv.gz      |                        2 | aa387aabb2ccedaaaaac123b8 |     2022-05-01 10:05:35.000 |  2023-02-02 01:31:00.755 +0000| g|h | NULL |
| data1.csv.gz      |                        1 | 39ab11bb2cdeacdcdac1234d9 |     2022-08-03 10:15:26.000 |  2023-02-02 01:31:00.778 +0000| a|b | NULL |
| data1.csv.gz      |                        2 | 2289aab2abcdeaacaaac348d0 |     2022-09-10 11:15:55.000 |  2023-02-02 01:31:00.778 +0000| c|d | NULL |
+-------------------+--------------------------+---------------------------+-----------------------------+-------------------------------+-----+------+

-- Example 9664
{"a": {"b": "x1","c": "y1"}},
{"a": {"b": "x2","c": "y2"}}

-- Example 9665
-- Create a file format
CREATE OR REPLACE FILE FORMAT my_json_format
  TYPE = 'json';

-- Create an internal stage
CREATE OR REPLACE STAGE mystage2
  FILE_FORMAT = my_json_format;

-- Stage a data file
PUT file:///tmp/data1.json @mystage2;

-- Query the filename and row number metadata columns and the regular data columns in the staged file
SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, parse_json($1) FROM @mystage2/data1.json.gz;

+-------------------+--------------------------+----------------+
| METADATA$FILENAME | METADATA$FILE_ROW_NUMBER | PARSE_JSON($1) |
|-------------------+--------------------------+----------------|
| data1.json.gz     |                        1 | {              |
|                   |                          |   "a": {       |
|                   |                          |     "b": "x1", |
|                   |                          |     "c": "y1"  |
|                   |                          |   }            |
|                   |                          | }              |
| data1.json.gz     |                        2 | {              |
|                   |                          |   "a": {       |
|                   |                          |     "b": "x2", |
|                   |                          |     "c": "y2"  |
|                   |                          |   }            |
|                   |                          | }              |
+-------------------+--------------------------+----------------+

-- Example 9666
CREATE OR REPLACE TABLE table1 (
  filename varchar,
  file_row_number int,
  file_content_key varchar,
  file_last_modified timestamp_ntz,
  start_scan_time timestamp_ltz,
  col1 varchar,
  col2 varchar
);

COPY INTO table1(filename, file_row_number, file_content_key, file_last_modified, start_scan_time, col1, col2)
  FROM (SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, METADATA$FILE_CONTENT_KEY, METADATA$FILE_LAST_MODIFIED, METADATA$START_SCAN_TIME, t.$1, t.$2 FROM @mystage1/data1.csv.gz (file_format => myformat) t);

SELECT * FROM table1;

+--------------+-----------------+---------------------------+-------------------------+-------------------------------+------+------+
| FILENAME     | FILE_ROW_NUMBER | FILE_CONTENT_KEY          | FILE_LAST_MODIFIED      |  START_SCAN_TIME              | COL1 | COL2 |
|--------------+-----------------+---------------------------+-------------------------+-------------------------------+------+------+
| data1.csv.gz | 1               | 39ab11bb2cdeacdcdac1234d9 | 2022-08-03 10:15:26.000 | 2023-02-02 01:31:00.778 +0000 | a    | b    |
| data1.csv.gz | 2               | 2289aab2abcdeaacaaac348d0 | 2022-09-10 11:15:55.000 | 2023-02-02 01:31:00.778 +0000 | c    | d    |
+--------------+-----------------+---------------------------+-------------------------+-------------------------------+------+------+

-- Example 9667
GRANT SELECT ON ALL DYNAMIC TABLES IN SCHEMA mydb.public TO SHARE share1;

GRANT SELECT ON DYNAMIC TABLE mydb.public TO SHARE share1;

-- Example 9668
CREATE DATABASE my_shared_db FROM SHARE provider_account.share1;

-- Example 9669
CREATE OR REPLACE DYNAMIC TABLE my_dynamic_table
  TARGET_LAG = '1 day'
  WAREHOUSE = mywh
  AS
    SELECT * FROM my_shared_db.public.mydb;

-- Example 9670
CREATE DYNAMIC TABLE controller
  TARGET_LAG = <target_lag>
  WAREHOUSE = <warehouse>
  AS
    SELECT 1 A FROM <leaf1>, …, <leafN> LIMIT 0;

-- Example 9671
ALTER DYNAMIC TABLE controller SET
  TARGET_LAG = <new_target_lag>

-- Example 9672
ALTER DYNAMIC TABLE controller REFRESH

-- Example 9673
SHOW DYNAMIC TABLES;

-- Example 9674
CREATE TABLE persons
  AS
    SELECT column1 AS id, parse_json(column2) AS entity
    FROM values
      (12712555,
      '{ name:  { first: "John", last: "Smith"},
        contact: [
        { business:[
          { type: "phone", content:"555-1234" },
          { type: "email", content:"j.smith@example.com" } ] } ] }'),
      (98127771,
      '{ name:  { first: "Jane", last: "Doe"},
        contact: [
        { business:[
          { type: "phone", content:"555-1236" },
          { type: "email", content:"j.doe@example.com" } ] } ] }') v;

CREATE DYNAMIC TABLE example
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = mywh
  REFRESH_MODE = INCREMENTAL
  AS
    SELECT p.id, f.value, f.path
    FROM persons p,
    LATERAL FLATTEN(input => p.entity) f;

-- Example 9675
CREATE DYNAMIC TABLE sums
  AS
    SELECT date_trunc(minute, ts), sum(c1) FROM table
    GROUP BY 1;

-- Example 9676
CREATE DYNAMIC TABLE intermediate
  AS
    SELECT date_trunc(minute, ts) ts_min, c1 FROM table;

-- Example 9677
CREATE DYNAMIC TABLE sums
  AS
    SELECT ts_min, sum(c1) FROM intermediate
    GROUP BY 1;

-- Example 9678
-- Create a landing table to store raw JSON data.
-- Snowpipe could load data into this table.
create or replace table raw (var variant);

-- Create a stream to capture inserts to the landing table.
-- A task will consume a set of columns from this stream.
create or replace stream rawstream1 on table raw;

-- Create a second stream to capture inserts to the landing table.
-- A second task will consume another set of columns from this stream.
create or replace stream rawstream2 on table raw;

-- Create a table that stores the names of office visitors identified in the raw data.
create or replace table names (id int, first_name string, last_name string);

-- Create a table that stores the visitation dates of office visitors identified in the raw data.
create or replace table visits (id int, dt date);

-- Create a task that inserts new name records from the rawstream1 stream into the names table
-- every minute when the stream contains records.
-- Replace the 'mywh' warehouse with a warehouse that your role has USAGE privilege on.
create or replace task raw_to_names
warehouse = mywh
schedule = '1 minute'
when
system$stream_has_data('rawstream1')
as
merge into names n
  using (select var:id id, var:fname fname, var:lname lname from rawstream1) r1 on n.id = to_number(r1.id)
  when matched then update set n.first_name = r1.fname, n.last_name = r1.lname
  when not matched then insert (id, first_name, last_name) values (r1.id, r1.fname, r1.lname)
;

-- Create another task that merges visitation records from the rawstream2 stream into the visits table
-- every minute when the stream contains records.
-- Records with new IDs are inserted into the visits table;
-- Records with IDs that exist in the visits table update the DT column in the table.
-- Replace the 'mywh' warehouse with a warehouse that your role has USAGE privilege on.
create or replace task raw_to_visits
warehouse = mywh
schedule = '1 minute'
when
system$stream_has_data('rawstream2')
as
merge into visits v
  using (select var:id id, var:visit_dt visit_dt from rawstream2) r2 on v.id = to_number(r2.id)
  when matched then update set v.dt = r2.visit_dt
  when not matched then insert (id, dt) values (r2.id, r2.visit_dt)
;

-- Resume both tasks.
alter task raw_to_names resume;
alter task raw_to_visits resume;

-- Insert a set of records into the landing table.
insert into raw
  select parse_json(column1)
  from values
  ('{"id": "123","fname": "Jane","lname": "Smith","visit_dt": "2019-09-17"}'),
  ('{"id": "456","fname": "Peter","lname": "Williams","visit_dt": "2019-09-17"}');

-- Query the change data capture record in the table streams
select * from rawstream1;
select * from rawstream2;

-- Wait for the tasks to run.
-- A tiny buffer is added to the wait time
-- because absolute precision in task scheduling is not guaranteed.
call system$wait(70);

-- Query the table streams again.
-- Records should be consumed and no longer visible in streams.

-- Verify the records were inserted into the target tables.
select * from names;
select * from visits;

-- Insert another set of records into the landing table.
-- The records include both new and existing IDs in the target tables.
insert into raw
  select parse_json(column1)
  from values
  ('{"id": "456","fname": "Peter","lname": "Williams","visit_dt": "2019-09-25"}'),
  ('{"id": "789","fname": "Ana","lname": "Glass","visit_dt": "2019-09-25"}');

-- Wait for the tasks to run.
call system$wait(70);

-- Records should be consumed and no longer visible in streams.
select * from rawstream1;
select * from rawstream2;

-- Verify the records were inserted into the target tables.
select * from names;
select * from visits;

-- Example 9679
-- Use the landing table from the previous example.
-- Alternatively, create a landing table.
-- Snowpipe could load data into this table.
create or replace table raw (id int, type string);

-- Create a stream on the table.  We will use this stream to feed the unload command.
create or replace stream rawstream on table raw;

-- Create a task that executes the COPY statement every minute.
-- The COPY statement reads from the stream and loads into the table stage for the landing table.
-- Replace the 'mywh' warehouse with a warehouse that your role has USAGE privilege on.
create or replace task unloadtask
warehouse = mywh
schedule = '1 minute'
when
  system$stream_has_data('RAWSTREAM')
as
copy into @%raw/rawstream from rawstream overwrite=true;
;

-- Resume the task.
alter task unloadtask resume;

-- Insert raw data into the landing table.
insert into raw values (3,'processed');

-- Query the change data capture record in the table stream
select * from rawstream;

-- Wait for the tasks to run.
-- A tiny buffer is added to the wait time
-- because absolute precision in task scheduling is not guaranteed.
call system$wait(70);

-- Records should be consumed and no longer visible in the stream.
select * from rawstream;

-- Verify the COPY statement unloaded a data file into the table stage.
ls @%raw;

-- Example 9680
-- Create a task that executes an ALTER EXTERNAL TABLE ... REFRESH statement every 5 minutes.
-- Replace the 'mywh' warehouse with a warehouse that your role has USAGE privilege on.
CREATE TASK exttable_refresh_task
WAREHOUSE=mywh
SCHEDULE='5 minutes'
  AS
ALTER EXTERNAL TABLE mydb.myschema.exttable REFRESH;

-- Example 9681
CREATE TASK task_root
  SCHEDULE = '1 MINUTE'
  AS SELECT 1;

CREATE TASK task_a
  AFTER task_root
  AS SELECT 1;

CREATE TASK task_b
  AFTER task_root
  AS SELECT 1;

CREATE TASK task_c
  AFTER task_a, task_b
  AS SELECT 1;

-- Example 9682
CREATE TASK task_finalizer
  FINALIZE = task_root
  AS SELECT 1;

-- Example 9683
CREATE OR REPLACE TASK task_root
  SCHEDULE = '1 MINUTE'
  TASK_AUTO_RETRY_ATTEMPTS = 2   --  Failed task graph retries up to 2 times
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3   --  Task graph suspends after 3 consecutive failures
  AS SELECT 1;

-- Example 9684
CREATE OR REPLACE TASK "task_root"
  SCHEDULE = '1 MINUTE'
  USER_TASK_TIMEOUT_MS = 60000
  CONFIG='{"environment": "production", "path": "/prod_directory/"}'
  AS
    SELECT 1;

CREATE OR REPLACE TASK "task_a"
  USER_TASK_TIMEOUT_MS = 600000
  AFTER "task_root"
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$GET_TASK_GRAPH_CONFIG('path'));
      CREATE TABLE IF NOT EXISTS demo_table(NAME VARCHAR, VALUE VARCHAR);
      INSERT INTO demo_table VALUES('task c path',:value);
    END;

-- Example 9685
CREATE OR REPLACE TASK "task_c"
  SCHEDULE = '1 MINUTE'
  USER_TASK_TIMEOUT_MS = 60000
  AS
    BEGIN
      CALL SYSTEM$SET_RETURN_VALUE('task_c successful');
    END;

CREATE OR REPLACE TASK "task_d"
  USER_TASK_TIMEOUT_MS = 60000
  AFTER "task_c"
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_c'));
      CREATE TABLE IF NOT EXISTS demo_table(NAME VARCHAR, VALUE VARCHAR);
      INSERT INTO demo_table VALUES('Value from predecessor task_c', :value);
    END;

-- Example 9686
-- Updates the date/time table after the root task completes.
CREATE OR REPLACE TASK "task_date_time_table"
  USER_TASK_TIMEOUT_MS = 60000
  AFTER "task_root"
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
      INSERT INTO date_time_table VALUES('order_date',:value);
    END;

-- Example 9687
-- Create a notebook in the public schema
-- USE DATABASE <database name>;
-- USE SCHEMA <schema name>;

-- task_a: Root task. Starts the task graph and sets basic configurations.
CREATE OR REPLACE TASK task_a
  SCHEDULE = '1 MINUTE'
  TASK_AUTO_RETRY_ATTEMPTS = 2
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3
  USER_TASK_TIMEOUT_MS = 60000
  CONFIG='{"environment": "production", "path": "/prod_directory/"}'
  AS
    BEGIN
      CALL SYSTEM$SET_RETURN_VALUE('task_a successful');
    END;
;

-- task_customer_table: Updates the customer table.
--   Runs after the root task completes.
CREATE OR REPLACE TASK task_customer_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT customer_id FROM ref_cust_table
        WHERE cust_name = "Jane Doe";);
      INSERT INTO customer_table VALUES('customer_id',:value);
    END;
;

-- task_product_table: Updates the product table.
--   Runs after the root task completes.
CREATE OR REPLACE TASK task_product_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT product_id FROM ref_item_table
        WHERE PRODUCT_NAME = "widget";);
      INSERT INTO product_table VALUES('product_id',:value);
    END;
;

-- task_date_time_table: Updates the date/time table.
--   Runs after the root task completes.
CREATE OR REPLACE TASK task_date_time_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
      INSERT INTO "date_time_table" VALUES('order_date',:value);
    END;
;

-- task_sales_table: Aggregates changes from other tables.
--   Runs only after updates are complete to all three other tables.
CREATE OR REPLACE TASK task_sales_table
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_customer_table, task_product_table, task_date_time_table
  AS
    BEGIN
      LET VALUE := (SELECT sales_order_id FROM ORDERS);
      JOIN CUSTOMER_TABLE ON orders.customer_id=customer_table.customer_id;
      INSERT INTO sales_table VALUES('sales_order_id',:value);
    END;
;

-- Example 9688
CREATE OR REPLACE TASK notify_finalizer
  USER_TASK_TIMEOUT_MS = 60000
  FINALIZE = task_root
AS
  DECLARE
    my_root_task_id STRING;
    my_start_time TIMESTAMP_LTZ;
    summary_json STRING;
    summary_html STRING;
  BEGIN
    --- Get root task ID
    my_root_task_id := (CALL SYSTEM$TASK_RUNTIME_INFO('CURRENT_ROOT_TASK_UUID'));
    --- Get root task scheduled time
    my_start_time := (CALL SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
    --- Combine all task run info into one JSON string
    summary_json := (SELECT get_task_graph_run_summary(:my_root_task_id, :my_start_time));
    --- Convert JSON into HTML table
    summary_html := (SELECT HTML_FROM_JSON_TASK_RUNS(:summary_json));

    --- Send HTML to email
    CALL SYSTEM$SEND_EMAIL(
        'email_notification',
        'admin@snowflake.com',
        'notification task run summary',
        :summary_html,
        'text/html');
    --- Set return value for finalizer
    CALL SYSTEM$SET_RETURN_VALUE('✅ Graph run summary sent.');
  END

CREATE OR REPLACE FUNCTION get_task_graph_run_summary(my_root_task_id STRING, my_start_time TIMESTAMP_LTZ)
  RETURNS STRING
AS
$$
  (SELECT
    ARRAY_AGG(OBJECT_CONSTRUCT(
      'task_name', name,
      'run_status', state,
      'return_value', return_value,
      'started', query_start_time,
      'duration', duration,
      'error_message', error_message
      )
    ) AS GRAPH_RUN_SUMMARY
  FROM
    (SELECT
      NAME,
      CASE
        WHEN STATE = 'SUCCEED' then '🟢 Succeeded'
        WHEN STATE = 'FAILED' then '🔴 Failed'
        WHEN STATE = 'SKIPPED' then '🔵 Skipped'
        WHEN STATE = 'CANCELLED' then '🔘 Cancelled'
      END AS STATE,
      RETURN_VALUE,
      TO_VARCHAR(QUERY_START_TIME, 'YYYY-MM-DD HH24:MI:SS') AS QUERY_START_TIME,
      CONCAT(TIMESTAMPDIFF('seconds', query_start_time, completed_time),
        ' s') AS DURATION,
      ERROR_MESSAGE
    FROM
      TABLE(my-database.information_schema.task_history(
        ROOT_TASK_ID => my_root_task_id ::STRING,
        SCHEDULED_TIME_RANGE_START => my_start_time,
        SCHEDULED_TIME_RANGE_END => current_timestamp()
      ))
    ORDER BY
      SCHEDULED_TIME)
  )::STRING
$$
;

CREATE OR REPLACE FUNCTION HTML_FROM_JSON_TASK_RUNS(JSON_DATA STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  HANDLER = 'GENERATE_HTML_TABLE'
AS
$$
  IMPORT JSON

  def GENERATE_HTML_TABLE(JSON_DATA):
    column_widths = ["320px", "120px", "400px", "160px", "80px", "480px"]

  DATA = json.loads(JSON_DATA)
  HTML = f"""
    <img src="https://example.com/logo.jpg"
      alt="Company logo" height="72">
    <p><strong>Task Graph Run Summary</strong>
      <br>Sign in to Snowsight to see more details.</p>
    <table border="1" style="border-color:#DEE3EA"
      cellpadding="5" cellspacing="0">
      <thead>
        <tr>
        """
        headers = ["Task name", "Run status", "Return value", "Started", "Duration", "Error message"]
        for i, header in enumerate(headers):
            HTML += f'<th scope="col" style="text-align:left;
            width: {column_widths[i]}">{header.capitalize()}</th>'

        HTML +="""
        </tr>
      </thead>
      <tbody>
        """
        for ROW_DATA in DATA:
          HTML += "<tr>"
          for header in headers:
            key = header.replace(" ", "_").upper()
            CELL_DATA = ROW_DATA.get(key, "")
            HTML += f'<td style="text-align:left;
            width: {column_widths[headers.index(header)]}">{CELL_DATA}</td>'
          HTML += "</tr>"
        HTML +="""
      </tbody>
    </table>
    """
  return HTML
$$
;

-- Example 9689
-- Configuration
-- By default, the notebook creates the objects in the public schema.
-- USE DATABASE <database name>;
-- USE SCHEMA <schema name>;

-- 1. Set the default configurations.
--    Creates a root task ("task_a"), and sets the default configurations
--    used throughout the task graph.
--    Configurations include:
--    * Each task runs after one minute, with a 60-second timeout.
--    * If a task fails, retry it twice. if it fails twice,
--      the entire task graph is considered as failed.
--    * If the task graph fails consecutively three times, suspend the task.
--    * Other environment values are set.

CREATE OR REPLACE TASK task_a
  SCHEDULE = '1 MINUTE'
  USER_TASK_TIMEOUT_MS = 60000
  TASK_AUTO_RETRY_ATTEMPTS = 2
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3
  AS
    BEGIN
      CALL SYSTEM$SET_RETURN_VALUE('task a successful');
    END;
;

-- 2. Use a runtime reflection variable.
--    Creates a child task ("task_b").
--    By design, this example fails the first time it runs, because
--    it writes to a table ("demo_table") that doesn’t exist.
CREATE OR REPLACE TASK task_b
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_a
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$TASK_RUNTIME_INFO('current_task_name'));
      INSERT INTO demo_table VALUES('task b name',:VALUE);
    END;
;

-- 3. Get a task graph configuration value.
--    Creates the child task ("task_c").
--    By design, this example fails the first time it runs, because
--    the predecessor task ("task_b") fails.
CREATE OR REPLACE TASK task_c
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_b
  AS
    BEGIN
      CALL SYSTEM$GET_TASK_GRAPH_CONFIG('path');
      LET VALUE := (SELECT SYSTEM$GET_TASK_GRAPH_CONFIG('path'));
      INSERT INTO demo_table VALUES('task c path',:value);
    END;
;

-- 4. Get a value from a predecessor.
--    Creates the child task ("task_d").
--    By design, this example fails the first time it runs, because
--    the predecessor task ("task_c") fails.
CREATE OR REPLACE TASK task_d
  USER_TASK_TIMEOUT_MS = 60000
  AFTER task_c
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$GET_PREDECESSOR_RETURN_VALUE('TASK_A'));
      INSERT INTO demo_table VALUES('task d: predecessor return value', :value);
    END;
;

-- 5. Create the finalizer task ("task_f"), which creates the missing demo table.
--    After the finalizer completes, the task should automatically retry
--    (see task_a: task_auto_retry_attempts).
--    On retry, task_b, task_c, and task_d should complete successfully.
CREATE OR REPLACE TASK task_f
  USER_TASK_TIMEOUT_MS = 60000
  FINALIZE = task_a
  AS
    BEGIN
      CREATE TABLE IF NOT EXISTS demo_table(NAME VARCHAR, VALUE VARCHAR);
    END;
;

-- 6. Resume the finalizer. Upon creation, tasks start in a suspended state.
--    Use this command to resume the finalizer.
ALTER TASK task_f RESUME;
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE('task_a');

-- 7. Query the task history
SELECT
    name, state, attempt_number, scheduled_from
  FROM
    TABLE(information_schema.task_history(task_name=> 'task_b'))
  LIMIT 5;
;

-- 8. Suspend the task graph to stop incurring costs
--    Note: To stop the task graph, you only need to suspend the root task
--    (task_a). Child tasks don’t run unless the root task is run.
--    If any child tasks are running, they have a limited duration
--    and will end soon.
ALTER TASK task_a SUSPEND;
DROP TABLE demo_table;

-- 9. Check tasks during execution (optional)
--    Run this command to query the demo table during execution
--    to check which tasks have run.
SELECT * FROM demo_table;

-- 10. Demo reset (optional)
--     Run this command to remove the demo table.
--     This causes task_b to fail during its first run.
--     After the task graph retries, task_b will succeed.
DROP TABLE demo_table;

-- Example 9690
-- Source table (null_empty1) contents
+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Create a file format that describes the data and the guidelines for processing it
create or replace file format my_csv_format
  field_optionally_enclosed_by='0x27' null_if=('null');

-- Unload table data into a stage
copy into @mystage
  from null_empty1
  file_format = (format_name = 'my_csv_format');

-- Output the data file contents
1,'null','NULL value'
2,'','Empty string'

-- Load data from the staged file into the target table (null_empty2)
copy into null_empty2
    from @mystage/data_0_0_0.csv.gz
    file_format = (format_name = 'my_csv_format');

select * from null_empty2;

+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Example 9691
-- Source table (null_empty1) contents
+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Create a file format that describes the data and the guidelines for processing it
create or replace file format my_csv_format
  empty_field_as_null=false null_if=('null');

-- Unload table data into a stage
copy into @mystage
  from null_empty1
  file_format = (format_name = 'my_csv_format');

-- Output the data file contents
1,null,NULL value
2,,Empty string

-- Load data from the staged file into the target table (null_empty2)
copy into null_empty2
    from @mystage/data_0_0_0.csv.gz
    file_format = (format_name = 'my_csv_format');

select * from null_empty2;

+---+------+--------------+
| i | V    | D            |
|---+------+--------------|
| 1 | NULL | NULL value   |
| 2 |      | Empty string |
+---+------+--------------+

-- Example 9692
copy into @mystage/myfile.csv.gz from mytable
file_format = (type=csv compression='gzip')
single=true
max_file_size=4900000000;

-- Example 9693
-- Create a table
CREATE OR REPLACE TABLE mytable (
 id number(8) NOT NULL,
 first_name varchar(255) default NULL,
 last_name varchar(255) default NULL,
 city varchar(255),
 state varchar(255)
);

-- Populate the table with data
INSERT INTO mytable (id,first_name,last_name,city,state)
 VALUES
 (1,'Ryan','Dalton','Salt Lake City','UT'),
 (2,'Upton','Conway','Birmingham','AL'),
 (3,'Kibo','Horton','Columbus','GA');

-- Unload the data to a file in a stage
COPY INTO @mystage
 FROM (SELECT OBJECT_CONSTRUCT('id', id, 'first_name', first_name, 'last_name', last_name, 'city', city, 'state', state) FROM mytable)
 FILE_FORMAT = (TYPE = JSON);

-- The COPY INTO location statement creates a file named data_0_0_0.json.gz in the stage.
-- The file contains the following data:

{"city":"Salt Lake City","first_name":"Ryan","id":1,"last_name":"Dalton","state":"UT"}
{"city":"Birmingham","first_name":"Upton","id":2,"last_name":"Conway","state":"AL"}
{"city":"Columbus","first_name":"Kibo","id":3,"last_name":"Horton","state":"GA"}

-- Example 9694
COPY INTO @mystage/myfile.parquet FROM (SELECT id, name, start_date FROM mytable)
  FILE_FORMAT=(TYPE='parquet')
  HEADER = TRUE;

-- Example 9695
COPY INTO @mystage
FROM (SELECT CAST(C1 AS TINYINT) ,
             CAST(C2 AS SMALLINT) ,
             CAST(C3 AS INT),
             CAST(C4 AS BIGINT) FROM mytable)
FILE_FORMAT=(TYPE=PARQUET);

