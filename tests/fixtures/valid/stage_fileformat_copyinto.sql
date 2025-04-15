-- CREATE FILE FORMATs
CREATE FILE FORMAT csv_fmt TYPE = 'CSV' FIELD_DELIMITER = ',';
CREATE FILE FORMAT json_fmt TYPE = 'JSON' ;
CREATE FILE FORMAT parquet_fmt TYPE = 'PARQUET';

-- CREATE STAGEs with different options
CREATE STAGE mystage1 URL = 's3://bucket/data/' FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = '|');
CREATE STAGE mystage2 FILE_FORMAT = csv_fmt;
CREATE STAGE mystage3 URL = 'azure://container/data/';

-- COPY INTO with various options
COPY INTO mytable FROM @mystage1 FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = '|');
COPY INTO mytable2 FROM @mystage2 FILE_FORMAT = (FORMAT_NAME = csv_fmt);
COPY INTO mytable3 FROM @mystage3;
COPY INTO @mystage1 FROM mytable;
-- COPY INTO with SELECT
COPY INTO mytable4 FROM (SELECT * FROM @mystage2 WHERE col1 > 10) FILE_FORMAT = (FORMAT_NAME = csv_fmt); 