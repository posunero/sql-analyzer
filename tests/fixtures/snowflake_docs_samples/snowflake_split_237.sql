-- Example 15859
create or replace table stproc_test_table3 (
    n10 numeric(10,0),     /* precision = 10, scale = 0 */
    n12 numeric(12,4),     /* precision = 12, scale = 4 */
    v1 varchar(19)         /* scale = 0 */
    );

-- Example 15860
create or replace procedure get_column_scale(column_index float)
    returns float not null
    language javascript
    as
    $$
    var stmt = snowflake.createStatement(
        {sqlText: "select n10, n12, v1 from stproc_test_table3;"}
        );
    stmt.execute();  // ignore the result set; we just want the scale.
    return stmt.getColumnScale(COLUMN_INDEX); // Get by column index (1-based)
    $$
    ;

-- Example 15861
call get_column_scale(1);
+------------------+
| GET_COLUMN_SCALE |
|------------------|
|                0 |
+------------------+

-- Example 15862
call get_column_scale(2);
+------------------+
| GET_COLUMN_SCALE |
|------------------|
|                4 |
+------------------+

-- Example 15863
call get_column_scale(3);
+------------------+
| GET_COLUMN_SCALE |
|------------------|
|                0 |
+------------------+

-- Example 15864
create procedure broken()
      returns varchar not null
      language javascript
      as
      $$
      var result = "";
      try {
          snowflake.execute( {sqlText: "Invalid Command!;"} );
          result = "Succeeded";
          }
      catch (err)  {
          result =  "Failed: Code: " + err.code + "\n  State: " + err.state;
          result += "\n  Message: " + err.message;
          result += "\nStack Trace:\n" + err.stackTraceTxt; 
          }
      return result;
      $$
      ;

-- Example 15865
-- This is expected to fail.
    call broken();
+---------------------------------------------------------+
| BROKEN                                                  |
|---------------------------------------------------------|
| Failed: Code: 1003                                      |
|   State: 42000                                          |
|   Message: SQL compilation error:                       |
| syntax error line 1 at position 0 unexpected 'Invalid'. |
| Stack Trace:                                            |
| Snowflake.execute, line 4 position 20                   |
+---------------------------------------------------------+

-- Example 15866
CREATE OR REPLACE PROCEDURE validate_age (age float)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
    try {
        if (AGE < 0) {
            throw "Age cannot be negative!";
        } else {
            return "Age validated.";
        }
    } catch (err) {
        return "Error: " + err;
    }
$$;

-- Example 15867
CALL validate_age(50);
+----------------+
| VALIDATE_AGE   |
|----------------|
| Age validated. |
+----------------+
CALL validate_age(-2);
+--------------------------------+
| VALIDATE_AGE                   |
|--------------------------------|
| Error: Age cannot be negative! |
+--------------------------------+

-- Example 15868
-- Create the procedure
CREATE OR REPLACE PROCEDURE cleanup(force_failure VARCHAR)
  RETURNS VARCHAR NOT NULL
  LANGUAGE JAVASCRIPT
  AS
  $$
  var result = "";
  snowflake.execute( {sqlText: "BEGIN WORK;"} );
  try {
      snowflake.execute( {sqlText: "DELETE FROM child;"} );
      snowflake.execute( {sqlText: "DELETE FROM parent;"} );
      if (FORCE_FAILURE === "fail")  {
          // To see what happens if there is a failure/rollback,
          snowflake.execute( {sqlText: "DELETE FROM no_such_table;"} );
          }
      snowflake.execute( {sqlText: "COMMIT WORK;"} );
      result = "Succeeded";
      }
  catch (err)  {
      snowflake.execute( {sqlText: "ROLLBACK WORK;"} );
      return "Failed: " + err;   // Return a success/error indicator.
      }
  return result;
  $$
  ;

CALL cleanup('fail');

CALL cleanup('do not fail');

-- Example 15869
CREATE TABLE western_provinces(ID INT, province VARCHAR);

-- Example 15870
INSERT INTO western_provinces(ID, province) VALUES
    (1, 'Alberta'),
    (2, 'British Columbia'),
    (3, 'Manitoba')
    ;

-- Example 15871
CREATE OR REPLACE PROCEDURE read_western_provinces()
  RETURNS VARCHAR NOT NULL
  LANGUAGE JAVASCRIPT
  AS
  $$
  var return_value = "";
  try {
      var command = "SELECT * FROM western_provinces ORDER BY province;"
      var stmt = snowflake.createStatement( {sqlText: command } );
      var rs = stmt.execute();
      if (rs.next())  {
          return_value += rs.getColumnValue(1);
          return_value += ", " + rs.getColumnValue(2);
          }
      while (rs.next())  {
          return_value += "\n";
          return_value += rs.getColumnValue(1);
          return_value += ", " + rs.getColumnValue(2);
          }
      }
  catch (err)  {
      result =  "Failed: Code: " + err.code + "\n  State: " + err.state;
      result += "\n  Message: " + err.message;
      result += "\nStack Trace:\n" + err.stackTraceTxt;
      }
  return return_value;
  $$
  ;

-- Example 15872
CALL read_western_provinces();
+------------------------+
| READ_WESTERN_PROVINCES |
|------------------------|
| 1, Alberta             |
| 2, British Columbia    |
| 3, Manitoba            |
+------------------------+
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
+------------------------+
| READ_WESTERN_PROVINCES |
|------------------------|
| 1, Alberta             |
| 2, British Columbia    |
| 3, Manitoba            |
+------------------------+

-- Example 15873
CREATE TABLE all_provinces(ID INT, province VARCHAR);

-- Example 15874
INSERT INTO all_provinces
  WITH 
    one_string (string_col) AS
      (SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))),
    three_strings (one_row) AS
      (SELECT VALUE FROM one_string, LATERAL SPLIT_TO_TABLE(one_string.string_col, '\n'))
  SELECT
         STRTOK(one_row, ',', 1) AS ID,
         STRTOK(one_row, ',', 2) AS province
    FROM three_strings
    WHERE NOT (ID IS NULL AND province IS NULL);
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+

-- Example 15875
SELECT ID, province 
    FROM all_provinces;
+----+-------------------+
| ID | PROVINCE          |
|----+-------------------|
|  1 |  Alberta          |
|  2 |  British Columbia |
|  3 |  Manitoba         |
+----+-------------------+

-- Example 15876
CREATE TRANSIENT TABLE one_string(string_col VARCHAR);

-- Example 15877
CALL read_western_provinces();
+------------------------+
| READ_WESTERN_PROVINCES |
|------------------------|
| 1, Alberta             |
| 2, British Columbia    |
| 3, Manitoba            |
+------------------------+
INSERT INTO one_string
    SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       1 |
+-------------------------+

-- Example 15878
SELECT string_col FROM one_string;
+---------------------+
| STRING_COL          |
|---------------------|
| 1, Alberta          |
| 2, British Columbia |
| 3, Manitoba         |
+---------------------+
-- Show that it's one string, not three rows:
SELECT '>>>' || string_col || '<<<' AS string_col 
    FROM one_string;
+---------------------+
| STRING_COL          |
|---------------------|
| >>>1, Alberta       |
| 2, British Columbia |
| 3, Manitoba<<<      |
+---------------------+
SELECT COUNT(*) FROM one_string;
+----------+
| COUNT(*) |
|----------|
|        1 |
+----------+

-- Example 15879
SELECT * FROM one_string, LATERAL SPLIT_TO_TABLE(one_string.string_col, '\n');
+---------------------+-----+-------+---------------------+
| STRING_COL          | SEQ | INDEX | VALUE               |
|---------------------+-----+-------+---------------------|
| 1, Alberta          |   1 |     1 | 1, Alberta          |
| 2, British Columbia |     |       |                     |
| 3, Manitoba         |     |       |                     |
| 1, Alberta          |   1 |     2 | 2, British Columbia |
| 2, British Columbia |     |       |                     |
| 3, Manitoba         |     |       |                     |
| 1, Alberta          |   1 |     3 | 3, Manitoba         |
| 2, British Columbia |     |       |                     |
| 3, Manitoba         |     |       |                     |
+---------------------+-----+-------+---------------------+
SELECT VALUE FROM one_string, LATERAL SPLIT_TO_TABLE(one_string.string_col, '\n');
+---------------------+
| VALUE               |
|---------------------|
| 1, Alberta          |
| 2, British Columbia |
| 3, Manitoba         |
+---------------------+

-- Example 15880
CREATE TRANSIENT TABLE three_strings(string_col VARCHAR);

-- Example 15881
INSERT INTO three_strings
  SELECT VALUE FROM one_string, LATERAL SPLIT_TO_TABLE(one_string.string_col, '\n');
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
SELECT string_col 
    FROM three_strings;
+---------------------+
| STRING_COL          |
|---------------------|
| 1, Alberta          |
| 2, British Columbia |
| 3, Manitoba         |
+---------------------+
SELECT COUNT(*) 
    FROM three_strings;
+----------+
| COUNT(*) |
|----------|
|        3 |
+----------+

-- Example 15882
INSERT INTO all_provinces
  SELECT 
         STRTOK(string_col, ',', 1) AS ID, 
         STRTOK(string_col, ',', 2) AS province 
    FROM three_strings
    WHERE NOT (ID IS NULL AND province IS NULL);
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+

-- Example 15883
SELECT ID, province 
    FROM all_provinces;
+----+-------------------+
| ID | PROVINCE          |
|----+-------------------|
|  1 |  Alberta          |
|  2 |  British Columbia |
|  3 |  Manitoba         |
+----+-------------------+
SELECT COUNT(*) 
    FROM all_provinces;
+----------+
| COUNT(*) |
|----------|
|        3 |
+----------+

-- Example 15884
CREATE OR REPLACE PROCEDURE sp_return_array()
      RETURNS VARIANT NOT NULL
      LANGUAGE JAVASCRIPT
      AS
      $$
      // This array will contain one error message (or an empty string) 
      // for each SQL command that we executed.
      var array_of_rows = [];

      // Artificially fake the error messages.
      array_of_rows.push("ERROR: The foo was barred.")
      array_of_rows.push("WARNING: A Carrington Event is predicted.")

      return array_of_rows;
      $$
      ;

-- Example 15885
CALL sp_return_array();
+-----------------------------------------------+
| SP_RETURN_ARRAY                               |
|-----------------------------------------------|
| [                                             |
|   "ERROR: The foo was barred.",               |
|   "WARNING: A Carrington Event is predicted." |
| ]                                             |
+-----------------------------------------------+
-- Now get the individual error messages, in order.
SELECT INDEX, VALUE 
    FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) AS res, LATERAL FLATTEN(INPUT => res.$1)
    ORDER BY index
    ;
+-------+---------------------------------------------+
| INDEX | VALUE                                       |
|-------+---------------------------------------------|
|     0 | "ERROR: The foo was barred."                |
|     1 | "WARNING: A Carrington Event is predicted." |
+-------+---------------------------------------------+

-- Example 15886
CREATE TABLE return_to_me(col_i INT, col_v VARCHAR);
INSERT INTO return_to_me (col_i, col_v) VALUES
    (1, 'Ariel'),
    (2, 'October'),
    (3, NULL),
    (NULL, 'Project');

-- Example 15887
-- Create the stored procedure that retrieves a result set and returns it.
CREATE OR REPLACE PROCEDURE sp_return_table(TABLE_NAME VARCHAR, COL_NAMES ARRAY)
      RETURNS VARIANT NOT NULL
      LANGUAGE JAVASCRIPT
      AS
      $$
      // This variable will hold a JSON data structure that holds ONE row.
      var row_as_json = {};
      // This array will contain all the rows.
      var array_of_rows = [];
      // This variable will hold a JSON data structure that we can return as
      // a VARIANT.
      // This will contain ALL the rows in a single "value".
      var table_as_json = {};

      // Run SQL statement(s) and get a resultSet.
      var command = "SELECT * FROM " + TABLE_NAME;
      var cmd1_dict = {sqlText: command};
      var stmt = snowflake.createStatement(cmd1_dict);
      var rs = stmt.execute();

      // Read each row and add it to the array we will return.
      var row_num = 1;
      while (rs.next())  {
        // Put each row in a variable of type JSON.
        row_as_json = {};
        // For each column in the row...
        for (var col_num = 0; col_num < COL_NAMES.length; col_num = col_num + 1) {
          var col_name = COL_NAMES[col_num];
          row_as_json[col_name] = rs.getColumnValue(col_num + 1);
          }
        // Add the row to the array of rows.
        array_of_rows.push(row_as_json);
        ++row_num;
        }
      // Put the array in a JSON variable (so it looks like a VARIANT to
      // Snowflake).  The key is "key1", and the value is the array that has
      // the rows we want.
      table_as_json = { "key1" : array_of_rows };

      // Return the rows to Snowflake, which expects a JSON-compatible VARIANT.
      return table_as_json;
      $$
      ;

-- Example 15888
CALL sp_return_table(
        -- Table name.
        'return_to_me',
        -- Array of column names.
        ARRAY_APPEND(TO_ARRAY('COL_I'), 'COL_V')
        );
+--------------------------+
| SP_RETURN_TABLE          |
|--------------------------|
| {                        |
|   "key1": [              |
|     {                    |
|       "COL_I": 1,        |
|       "COL_V": "Ariel"   |
|     },                   |
|     {                    |
|       "COL_I": 2,        |
|       "COL_V": "October" |
|     },                   |
|     {                    |
|       "COL_I": 3,        |
|       "COL_V": null      |
|     },                   |
|     {                    |
|       "COL_I": null,     |
|       "COL_V": "Project" |
|     }                    |
|   ]                      |
| }                        |
+--------------------------+
-- Use "ResultScan" to get the data from the stored procedure that
-- "did not return a result set".
-- Use "$1:key1" to get the value corresponding to the JSON key named "key1".
SELECT $1:key1 FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
+------------------------+
| $1:KEY1                |
|------------------------|
| [                      |
|   {                    |
|     "COL_I": 1,        |
|     "COL_V": "Ariel"   |
|   },                   |
|   {                    |
|     "COL_I": 2,        |
|     "COL_V": "October" |
|   },                   |
|   {                    |
|     "COL_I": 3,        |
|     "COL_V": null      |
|   },                   |
|   {                    |
|     "COL_I": null,     |
|     "COL_V": "Project" |
|   }                    |
| ]                      |
+------------------------+
-- Now get what we really want.
SELECT VALUE:COL_I AS col_i, value:COL_V AS col_v
  FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) AS res, LATERAL FLATTEN(input => res.$1)
  ORDER BY COL_I;
+-------+-----------+
| COL_I | COL_V     |
|-------+-----------|
| 1     | "Ariel"   |
| 2     | "October" |
| 3     | null      |
| null  | "Project" |
+-------+-----------+

-- Example 15889
CALL sp_return_table(
        -- Table name.
        'return_to_me',
        -- Array of column names.
        ARRAY_APPEND(TO_ARRAY('COL_I'), 'COL_V')
        );
+--------------------------+
| SP_RETURN_TABLE          |
|--------------------------|
| {                        |
|   "key1": [              |
|     {                    |
|       "COL_I": 1,        |
|       "COL_V": "Ariel"   |
|     },                   |
|     {                    |
|       "COL_I": 2,        |
|       "COL_V": "October" |
|     },                   |
|     {                    |
|       "COL_I": 3,        |
|       "COL_V": null      |
|     },                   |
|     {                    |
|       "COL_I": null,     |
|       "COL_V": "Project" |
|     }                    |
|   ]                      |
| }                        |
+--------------------------+
SELECT VALUE:COL_I AS col_i, value:COL_V AS col_v
       FROM (SELECT $1:key1 FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))) AS res,
            LATERAL FLATTEN(input => res.$1)
       ORDER BY COL_I;
+-------+-----------+
| COL_I | COL_V     |
|-------+-----------|
| 1     | "Ariel"   |
| 2     | "October" |
| 3     | null      |
| null  | "Project" |
+-------+-----------+

-- Example 15890
CREATE VIEW stproc_view (col_i, col_v) AS 
  SELECT NULLIF(VALUE:COL_I::VARCHAR, 'null'::VARCHAR), 
         NULLIF(value:COL_V::VARCHAR, 'null'::VARCHAR)
    FROM (SELECT $1:key1 AS tbl FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))) AS res, 
         LATERAL FLATTEN(input => res.tbl);

-- Example 15891
CALL sp_return_table(
        -- Table name.
        'return_to_me',
        -- Array of column names.
        ARRAY_APPEND(TO_ARRAY('COL_I'), 'COL_V')
        );
+--------------------------+
| SP_RETURN_TABLE          |
|--------------------------|
| {                        |
|   "key1": [              |
|     {                    |
|       "COL_I": 1,        |
|       "COL_V": "Ariel"   |
|     },                   |
|     {                    |
|       "COL_I": 2,        |
|       "COL_V": "October" |
|     },                   |
|     {                    |
|       "COL_I": 3,        |
|       "COL_V": null      |
|     },                   |
|     {                    |
|       "COL_I": null,     |
|       "COL_V": "Project" |
|     }                    |
|   ]                      |
| }                        |
+--------------------------+
SELECT * 
    FROM stproc_view
    ORDER BY COL_I;
+-------+---------+
| COL_I | COL_V   |
|-------+---------|
| 1     | Ariel   |
| 2     | October |
| 3     | NULL    |
| NULL  | Project |
+-------+---------+

-- Example 15892
CALL sp_return_table(
        -- Table name.
        'return_to_me',
        -- Array of column names.
        ARRAY_APPEND(TO_ARRAY('COL_I'), 'COL_V')
        );
+--------------------------+
| SP_RETURN_TABLE          |
|--------------------------|
| {                        |
|   "key1": [              |
|     {                    |
|       "COL_I": 1,        |
|       "COL_V": "Ariel"   |
|     },                   |
|     {                    |
|       "COL_I": 2,        |
|       "COL_V": "October" |
|     },                   |
|     {                    |
|       "COL_I": 3,        |
|       "COL_V": null      |
|     },                   |
|     {                    |
|       "COL_I": null,     |
|       "COL_V": "Project" |
|     }                    |
|   ]                      |
| }                        |
+--------------------------+
SELECT COL_V 
    FROM stproc_view
    WHERE COL_V IS NOT NULL
    ORDER BY COL_V;
+---------+
| COL_V   |
|---------|
| Ariel   |
| October |
| Project |
+---------+

-- Example 15893
create table reviews (customer_ID VARCHAR, review VARCHAR);
create table purchase_history (customer_ID VARCHAR, price FLOAT, paid FLOAT,
                               product_ID VARCHAR, purchase_date DATE);

-- Example 15894
insert into purchase_history (customer_ID, price, paid, product_ID, purchase_date) values 
    (1, 19.99, 19.99, 'chocolate', '2018-06-17'::DATE),
    (2, 19.99,  0.00, 'chocolate', '2017-02-14'::DATE),
    (3, 19.99,  19.99, 'chocolate', '2017-03-19'::DATE);

insert into reviews (customer_ID, review) values (1, 'Loved the milk chocolate!');
insert into reviews (customer_ID, review) values (2, 'Loved the dark chocolate!');

-- Example 15895
create or replace procedure delete_nonessential_customer_data(customer_ID varchar)
    returns varchar not null
    language javascript
    as
    $$

    // If the customer posted reviews of products, delete those reviews.
    var sql_cmd = "DELETE FROM reviews WHERE customer_ID = " + CUSTOMER_ID;
    snowflake.execute( {sqlText: sql_cmd} );

    // Delete any other records not needed for warranty or payment info.
    // ...

    var result = "Deleted non-financial, non-warranty data for customer " + CUSTOMER_ID;

    // Find out if the customer has any net unpaid balance (or surplus/prepayment).
    sql_cmd = "SELECT SUM(price) - SUM(paid) FROM purchase_history WHERE customer_ID = " + CUSTOMER_ID;
    var stmt = snowflake.createStatement( {sqlText: sql_cmd} );
    var rs = stmt.execute();
    // There should be only one row, so should not need to iterate.
    rs.next();
    var net_amount_owed = rs.getColumnValue(1);

    // Look up the number of purchases still under warranty...
    var number_purchases_under_warranty = 0;
    // Assuming a 1-year warranty...
    sql_cmd = "SELECT COUNT(*) FROM purchase_history ";
    sql_cmd += "WHERE customer_ID = " + CUSTOMER_ID;
    // Can't use CURRENT_DATE() because that changes. So assume that today is 
    // always June 15, 2019.
    sql_cmd += "AND PURCHASE_DATE > dateadd(year, -1, '2019-06-15'::DATE)";
    var stmt = snowflake.createStatement( {sqlText: sql_cmd} );
    var rs = stmt.execute();
    // There should be only one row, so should not need to iterate.
    rs.next();
    number_purchases_under_warranty = rs.getColumnValue(1);

    // Check whether need to keep some purchase history data; if not, then delete the data.
    if (net_amount_owed == 0.0 && number_purchases_under_warranty == 0)  {
        // Delete the purchase history of this customer ...
        sql_cmd = "DELETE FROM purchase_history WHERE customer_ID = " + CUSTOMER_ID;
        snowflake.execute( {sqlText: sql_cmd} );
        // ... and delete anything else that should be deleted.
        // ...
        result = "Deleted all data, including financial and warranty data, for customer " + CUSTOMER_ID;
        }
    return result;
    $$
    ;

-- Example 15896
SELECT * FROM reviews;
+-------------+---------------------------+
| CUSTOMER_ID | REVIEW                    |
|-------------+---------------------------|
| 1           | Loved the milk chocolate! |
| 2           | Loved the dark chocolate! |
+-------------+---------------------------+
SELECT * FROM purchase_history;
+-------------+-------+-------+------------+---------------+
| CUSTOMER_ID | PRICE |  PAID | PRODUCT_ID | PURCHASE_DATE |
|-------------+-------+-------+------------+---------------|
| 1           | 19.99 | 19.99 | chocolate  | 2018-06-17    |
| 2           | 19.99 |  0    | chocolate  | 2017-02-14    |
| 3           | 19.99 | 19.99 | chocolate  | 2017-03-19    |
+-------------+-------+-------+------------+---------------+

-- Example 15897
call delete_nonessential_customer_data(1);
+---------------------------------------------------------+
| DELETE_NONESSENTIAL_CUSTOMER_DATA                       |
|---------------------------------------------------------|
| Deleted non-financial, non-warranty data for customer 1 |
+---------------------------------------------------------+
SELECT * FROM reviews;
+-------------+---------------------------+
| CUSTOMER_ID | REVIEW                    |
|-------------+---------------------------|
| 2           | Loved the dark chocolate! |
+-------------+---------------------------+
SELECT * FROM purchase_history;
+-------------+-------+-------+------------+---------------+
| CUSTOMER_ID | PRICE |  PAID | PRODUCT_ID | PURCHASE_DATE |
|-------------+-------+-------+------------+---------------|
| 1           | 19.99 | 19.99 | chocolate  | 2018-06-17    |
| 2           | 19.99 |  0    | chocolate  | 2017-02-14    |
| 3           | 19.99 | 19.99 | chocolate  | 2017-03-19    |
+-------------+-------+-------+------------+---------------+

-- Example 15898
call delete_nonessential_customer_data(2);
+---------------------------------------------------------+
| DELETE_NONESSENTIAL_CUSTOMER_DATA                       |
|---------------------------------------------------------|
| Deleted non-financial, non-warranty data for customer 2 |
+---------------------------------------------------------+
SELECT * FROM reviews;
+-------------+--------+
| CUSTOMER_ID | REVIEW |
|-------------+--------|
+-------------+--------+
SELECT * FROM purchase_history;
+-------------+-------+-------+------------+---------------+
| CUSTOMER_ID | PRICE |  PAID | PRODUCT_ID | PURCHASE_DATE |
|-------------+-------+-------+------------+---------------|
| 1           | 19.99 | 19.99 | chocolate  | 2018-06-17    |
| 2           | 19.99 |  0    | chocolate  | 2017-02-14    |
| 3           | 19.99 | 19.99 | chocolate  | 2017-03-19    |
+-------------+-------+-------+------------+---------------+

-- Example 15899
call delete_nonessential_customer_data(3);
+-------------------------------------------------------------------------+
| DELETE_NONESSENTIAL_CUSTOMER_DATA                                       |
|-------------------------------------------------------------------------|
| Deleted all data, including financial and warranty data, for customer 3 |
+-------------------------------------------------------------------------+
SELECT * FROM reviews;
+-------------+--------+
| CUSTOMER_ID | REVIEW |
|-------------+--------|
+-------------+--------+
SELECT * FROM purchase_history;
+-------------+-------+-------+------------+---------------+
| CUSTOMER_ID | PRICE |  PAID | PRODUCT_ID | PURCHASE_DATE |
|-------------+-------+-------+------------+---------------|
| 1           | 19.99 | 19.99 | chocolate  | 2018-06-17    |
| 2           | 19.99 |  0    | chocolate  | 2017-02-14    |
+-------------+-------+-------+------------+---------------+

-- Example 15900
create table sv_table (f float);
insert into sv_table (f) values (49), (51);

-- Example 15901
set SESSION_VAR1 = 50;

-- Example 15902
create procedure session_var_user()
  returns float
  language javascript
  EXECUTE AS CALLER
  as
  $$
  // Set the second session variable
  var stmt = snowflake.createStatement(
      {sqlText: "set SESSION_VAR2 = 'I was set inside the StProc.'"}
      );
  var rs = stmt.execute();  // we ignore the result in this case
  // Run a query using the first session variable
  stmt = snowflake.createStatement(
      {sqlText: "select f from sv_table where f > $SESSION_VAR1"}
      );
  rs = stmt.execute();
  rs.next();
  var output = rs.getColumnValue(1);
  return output;
  $$
  ;

-- Example 15903
CALL session_var_user();
+------------------+
| SESSION_VAR_USER |
|------------------|
|               51 |
+------------------+

-- Example 15904
SELECT $SESSION_VAR2;
+------------------------------+
| $SESSION_VAR2                |
|------------------------------|
| I was set inside the StProc. |
+------------------------------+

-- Example 15905
create procedure cannot_use_session_vars()
  returns float
  language javascript
  EXECUTE AS OWNER
  as
  $$
  // Run a query using the first session variable
  var stmt = snowflake.createStatement(
      {sqlText: "select f from sv_table where f > $SESSION_VAR1"}
      );
  var rs = stmt.execute();
  rs.next();
  var output = rs.getColumnValue(1);
  return output;
  $$
  ;

-- Example 15906
CALL cannot_use_session_vars();

-- Example 15907
create procedure cannot_set_session_vars()
  returns float
  language javascript
  EXECUTE AS OWNER
  as
  $$
  // Set the second session variable
  var stmt = snowflake.createStatement(
      {sqlText: "set SESSION_VAR2 = 'I was set inside the StProc.'"}
      );
  var rs = stmt.execute();  // we ignore the result in this case
  return 3.0;   // dummy value.
  $$
  ;

-- Example 15908
CALL cannot_set_session_vars();

-- Example 15909
-- Set up.
push a;
push b;
...
-- Clean up in the reverse order that you set up.
pop b;
pop a;

-- Example 15910
CREATE PROCEDURE f() ...
    $$
    set x;
    set y;
    try  {
       set z;
       -- Do something interesting...
       ...
       unset z;
       }
    catch  {
       -- Give error message...
       ...
       unset z;
       }
    unset y;
    unset x;
    $$
    ;

-- Example 15911
CREATE OR REPLACE PROCEDURE myProc(fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'MyClass.myMethod'
  AS
  $$
    import com.snowflake.snowpark_java.*;

    public class MyClass
    {
      public String myMethod(Session session, String fromTable, String toTable, int count)
      {
        session.table(fromTable).limit(count).write().saveAsTable(toTable);
        return "Success";
      }
    }
  $$;

-- Example 15912
CREATE OR REPLACE PROCEDURE output_message(message VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
  RETURN message;
END;

-- Example 15913
CREATE OR REPLACE PROCEDURE output_message(message VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  RETURN message;
END;
$$
;

-- Example 15914
CALL output_message('Hello World');

-- Example 15915
WITH anonymous_output_message AS PROCEDURE (message VARCHAR)
  RETURNS VARCHAR NOT NULL
  LANGUAGE SQL
  AS
  $$
  BEGIN
    RETURN message;
  END;
  $$
CALL anonymous_output_message('Hello World');

-- Example 15916
CREATE OR REPLACE PROCEDURE return_greater(number_1 INTEGER, number_2 INTEGER)
RETURNS INTEGER NOT NULL
LANGUAGE SQL
AS
BEGIN
  IF (number_1 > number_2) THEN
    RETURN number_1;
  ELSE
    RETURN number_2;
  END IF;
END;

-- Example 15917
CREATE OR REPLACE PROCEDURE return_greater(number_1 INTEGER, number_2 INTEGER)
RETURNS INTEGER NOT NULL
LANGUAGE SQL
AS
$$
BEGIN
  IF (number_1 > number_2) THEN
    RETURN number_1;
  ELSE
    RETURN number_2;
  END IF;
END;
$$
;

-- Example 15918
CALL return_greater(2, 3);

-- Example 15919
CREATE OR REPLACE PROCEDURE find_invoice_by_id(id VARCHAR)
RETURNS TABLE (id INTEGER, price NUMBER(12,2))
LANGUAGE SQL
AS
DECLARE
  res RESULTSET DEFAULT (SELECT * FROM invoices WHERE id = :id);
BEGIN
  RETURN TABLE(res);
END;

-- Example 15920
CREATE OR REPLACE PROCEDURE find_invoice_by_id(id VARCHAR)
RETURNS TABLE (id INTEGER, price NUMBER(12,2))
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET DEFAULT (SELECT * FROM invoices WHERE id = :id);
BEGIN
  RETURN TABLE(res);
END;
$$
;

-- Example 15921
CALL find_invoice_by_id('2');

-- Example 15922
CREATE OR REPLACE PROCEDURE test_bind_comment(comment VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
BEGIN
  CREATE OR REPLACE TABLE test_table_with_comment(a VARCHAR, n NUMBER) COMMENT = :comment;
END;

-- Example 15923
CREATE OR REPLACE PROCEDURE test_bind_comment(comment VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  CREATE OR REPLACE TABLE test_table_with_comment(a VARCHAR, n NUMBER) COMMENT = :comment;
END;
$$
;

-- Example 15924
CALL test_bind_comment('My Test Table');

-- Example 15925
SELECT comment FROM information_schema.tables WHERE table_name='TEST_TABLE_WITH_COMMENT';

