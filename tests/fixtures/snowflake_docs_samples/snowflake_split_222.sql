-- Example 14854
from snowflake.ml.feature_store import FeatureStore, CreationMode

fs = FeatureStore(
        session=session,
        database="MY_DB",
        name="MY_FEATURE_STORE",
        default_warehouse="MY_WH",
      )

-- Example 14855
from snowflake.ml.feature_store import Entity

entity = Entity(
    name="MY_ENTITY",
    join_keys=["UNIQUE_ID"],
    desc="my entity"
)
fs.register_entity(entity)

-- Example 14856
fs.list_entities().show()

-- Example 14857
entity = fs.get_entity(name="MY_ENTITY")
print(entity.join_keys)

-- Example 14858
fs.update_entity(
    name="MY_ENTITY",
    desc="NEW DESCRIPTION"
)

-- Example 14859
fs.delete_entity(name="MY_ENTITY")

-- Example 14860
from snowflake.ml.feature_store import FeatureView

managed_fv = FeatureView(
    name="MY_MANAGED_FV",
    entities=[entity],
    feature_df=my_df,                   # Snowpark DataFrame containing feature transformations
    timestamp_col="ts",                 # optional timestamp column name in the dataframe
    refresh_freq="5 minutes",           # how often feature data refreshes
    desc="my managed feature view"      # optional description
)

-- Example 14861
external_fv = FeatureView(
    name="MY_EXTERNAL_FV",
    entities=[entity],
    feature_df=my_df,                   # Snowpark DataFrame referencing the feature table
    timestamp_col="ts",                 # optional timestamp column name in the dataframe
    refresh_freq=None,                  # None means the feature view is external
    desc="my external feature view"     # optional description
)

-- Example 14862
external_fv = external_fv.attach_feature_desc(
    {
        "SENDERID": "Sender account ID for the transaction",
        "RECEIVERID": "Receiver account ID for the transaction",
        "IBAN": "International Bank Identifier for the receiver bank",
        "AMOUNT": "Amount of the transaction"
    }
)

-- Example 14863
registered_fv: FeatureView = fs.register_feature_view(
    feature_view=managed_fv,    # feature view created above, could also use external_fv
    version="1",
    block=True,         # whether function call blocks until initial data is available
    overwrite=False,    # whether to replace existing feature view with same name/version
)

-- Example 14864
retrieved_fv: FeatureView = fs.get_feature_view(
    name="MY_MANAGED_FV",
    version="1"
)

-- Example 14865
fs.list_feature_views(
    entity_name="<entity_name>",                # optional
    feature_view_name="<feature_view_name>",    # optional
).show()

-- Example 14866
fs.update_feature_view(
    name="<name>",
    version="<version>",
    refresh_freq="<new_fresh_freq>",    # optional
    warehouse="<new_warehouse>",        # optional
    desc="<new_description>",           # optional
)

-- Example 14867
fs.delete_feature_view(
    feature_view="<name>",
    version="<version>",
)

-- Example 14868
def get_zipcode(df: snowpark.DataFrame) -> snowpark.DataFrame:
    df = df.fillna({"foo": 0})
    df = df.with_column(
        "zipcode",
        F.compute_zipcode(df["lat"], df["long"])
    )
    return df

-- Example 14869
SELECT
    COALESCE(foo, 0) AS foo,
    compute_zipcode(lat, long) AS zipcode
FROM <source_table_name>;

-- Example 14870
def sum_rainfall(df: snowpark.DataFrame) -> snowpark.DataFrame:
    df = df.group_by(
        ["location", to_date(timestamp)]
    ).agg(
        sum("rain").alias("sum_rain"),
        avg("humidity").alias("avg_humidity")
    )
    return df

-- Example 14871
SELECT
    location,
    TO_DATE(timestamp) AS date,
    SUM(rain) AS sum_rain,
    AVG(humidity) AS avg_humidity
FROM <source_table_name>
GROUP BY location, date;

-- Example 14872
def sum_past_3_transactions(df: snowpark.DataFrame) -> snowpark.DataFrame:
    window = Window.partition_by("id").order_by("ts").rows_between(2, Window.CURRENT_ROW)

    return df.select(
        sum("amount").over(window).alias("sum_past_3_transactions")
    )

-- Example 14873
SELECT
    id,
    SUM(amount) OVER (PARTITION BY id ORDER BY ts ROWS BETWEEN 2 PRECEDING and 0 FOLLOWING)
        AS sum_past_3_transactions
FROM <source_table_name>;

-- Example 14874
new_df =  df.analytics.moving_agg(
    aggs={"SALESAMOUNT": ["SUM", "AVG"]},
    window_sizes=[2, 3],
    order_by=["ORDERDATE"],
    group_by=["PRODUCTKEY"]
)

-- Example 14875
new_df = df.analytics.cumulative_agg(
    aggs={"SALESAMOUNT": ["SUM", "MIN", "MAX"]},
    order_by=["ORDERDATE"],
    group_by=["PRODUCTKEY"],
    is_forward=True
)

-- Example 14876
new_df = df.analytics.compute_lag(
    cols=["SALESAMOUNT"],
    lags=[1, 2],
    order_by=["ORDERDATE"],
    group_by=["PRODUCTKEY"]
)

-- Example 14877
new_df = df.analytics.compute_lead(
    cols=["SALESAMOUNT"],
    leads=[1, 2],
    order_by=["ORDERDATE"],
    group_by=["PRODUCTKEY"]
)

-- Example 14878
def custom_column_naming(input_col, agg, window):
    return f"{agg}_{input_col}_{window.replace('-', 'past_')}"

result_df = weather_df.analytics.time_series_agg(
    aggs={"rain": ["SUM"]},
    windows=["-3D", "-5D"],
    sliding_interval="1D",
    group_by=["location"],
    time_col="ts",
    col_formatter=custom_column_naming
)

-- Example 14879
select
    TS,
    LOCATION,
    sum(RAIN) over (
        partition by LOCATION
        order by TS
        range between interval '3 days' preceding and current row
    ) SUM_RAIN_3D,
    sum(RAIN) over (
        partition by LOCATION
        order by TS
        range between interval '5 days' preceding and current row
    ) SUM_RAIN_5D
from <source_table_name>

-- Example 14880
# In Python
@F.udf(
    name="MY_UDF",
    immutable=True,
    # ...
)
def my_udf(...):
    # ...

-- Example 14881
training_set = fs.generate_training_set(
    spine_df=MySourceDataFrame,
    features=[registered_fv],
    save_as="data_20240101",                    # optional
    spine_timestamp_col="TS",                   # optional
    spine_label_cols=["LABEL1", "LABEL2"],      # optional
    include_feature_view_timestamp_col=False,   # optional
)

-- Example 14882
dataset: Dataset = fs.generate_dataset(
    name="MY_DATASET",
    spine_df=MySourceDataFrame,
    features=[registered_fv],
    version="v1",                               # optional
    spine_timestamp_col="TS",                   # optional
    spine_label_cols=["LABEL1", "LABEL2"],      # optional
    include_feature_view_timestamp_col=False,   # optional
    desc="my new dataset",                      # optional
)

-- Example 14883
my_model = train_my_model(training_set)

-- Example 14884
my_model = train_my_model(dataset.read.to_snowpark_dataframe())

-- Example 14885
prediction_df: snowpark.DataFrame = fs.retrieve_feature_values(
    spine_df=prediction_source_dataframe,
    features=[registered_fv],
    spine_timestamp_col="TS",
    exclude_columns=[],
)

# predict with your previously trained model
my_model.predict(prediction_df)

-- Example 14886
SET FS_SHARE = '<fs_share_name>';
SET FS_DATABASE = '<fs_database_name>';
SET FS_SCHEMA = '<fs_schema_name>';
SET FV_NAME = '<feature_view_name_with_version>';
SET ENTITY_NAME = '<entity_name>';

-- Example 14887
SET SCHEMA_FQN = CONCAT($FS_DATABASE, '.', $FS_SCHEMA);
SET TAG_OBJECT_FQN = CONCAT($SCHEMA_FQN, '.', 'SNOWML_FEATURE_STORE_OBJECT');
SET TAG_METADATA_FQN = CONCAT($SCHEMA_FQN, '.', 'SNOWML_FEATURE_VIEW_METADATA');
SET FULL_ENTITY_NAME = CONCAT('SNOWML_FEATURE_STORE_ENTITY_', $ENTITY_NAME);
SET ENTITY_FQN = CONCAT($SCHEMA_FQN, '.', $FULL_ENTITY_NAME);
SET FV_FQN = CONCAT($SCHEMA_FQN, '.', $FV_NAME);

-- Grant privileges to target share
GRANT USAGE ON DATABASE IDENTIFIER($FS_DATABASE) TO SHARE IDENTIFIER($FS_SHARE);
GRANT REFERENCE_USAGE ON DATABASE IDENTIFIER($FS_DATABASE) to SHARE IDENTIFIER($FS_SHARE);
GRANT USAGE ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO SHARE IDENTIFIER($FS_SHARE);
GRANT READ ON TAG IDENTIFIER($TAG_OBJECT_FQN) TO SHARE IDENTIFIER($FS_SHARE);
GRANT READ ON TAG IDENTIFIER($TAG_METADATA_FQN) TO SHARE IDENTIFIER($FS_SHARE);
GRANT READ ON TAG IDENTIFIER($ENTITY_FQN) TO SHARE IDENTIFIER($FS_SHARE);

-- Example 14888
GRANT SELECT ON DYNAMIC TABLE IDENTIFIER($FV_FQN) TO SHARE IDENTIFIER($FS_SHARE);

-- Example 14889
GRANT SELECT ON VIEW IDENTIFIER($FV_FQN) TO SHARE IDENTIFIER($FS_SHARE);

-- Example 14890
FROM <left_table> ASOF JOIN <right_table>
  MATCH_CONDITION ( <left_table.timecol> <comparison_operator> <right_table.timecol> )
  [ ON <table.col> = <table.col> [ AND ... ] | USING ( <column_list> ) ]

-- Example 14891
->ASOF Join  joinKey: (S.LOCATION = R.LOCATION) AND (S.STATE = R.STATE),
  matchCondition: (S.OBSERVED >= R.OBSERVED)

-- Example 14892
CREATE OR REPLACE TABLE left_table (
  c1 VARCHAR(1),
  c2 TINYINT,
  c3 TIME,
  c4 NUMBER(3,2)
);

CREATE OR REPLACE TABLE right_table (
  c1 VARCHAR(1),
  c2 TINYINT,
  c3 TIME,
  c4 NUMBER(3,2)
);

INSERT INTO left_table VALUES
  ('A',1,'09:15:00',3.21),
  ('A',2,'09:16:00',3.22),
  ('B',1,'09:17:00',3.23),
  ('B',2,'09:18:00',4.23);

INSERT INTO right_table VALUES
  ('A',1,'09:14:00',3.19),
  ('B',1,'09:16:00',3.04);

-- Example 14893
SELECT * FROM left_table ORDER BY c1, c2;

-- Example 14894
+----+----+----------+------+
| C1 | C2 | C3       |   C4 |
|----+----+----------+------|
| A  |  1 | 09:15:00 | 3.21 |
| A  |  2 | 09:16:00 | 3.22 |
| B  |  1 | 09:17:00 | 3.23 |
| B  |  2 | 09:18:00 | 4.23 |
+----+----+----------+------+

-- Example 14895
SELECT * FROM right_table ORDER BY c1, c2;

-- Example 14896
+----+----+----------+------+
| C1 | C2 | C3       |   C4 |
|----+----+----------+------|
| A  |  1 | 09:14:00 | 3.19 |
| B  |  1 | 09:16:00 | 3.04 |
+----+----+----------+------+

-- Example 14897
SELECT *
  FROM left_table l ASOF JOIN right_table r
    MATCH_CONDITION(l.c3>=r.c3)
    ON(l.c1=r.c1 and l.c2=r.c2)
  ORDER BY l.c1, l.c2;

-- Example 14898
+----+----+----------+------+------+------+----------+------+
| C1 | C2 | C3       |   C4 | C1   | C2   | C3       |   C4 |
|----+----+----------+------+------+------+----------+------|
| A  |  1 | 09:15:00 | 3.21 | A    |  1   | 09:14:00 | 3.19 |
| A  |  2 | 09:16:00 | 3.22 | NULL | NULL | NULL     | NULL |
| B  |  1 | 09:17:00 | 3.23 | B    |  1   | 09:16:00 | 3.04 |
| B  |  2 | 09:18:00 | 4.23 | NULL | NULL | NULL     | NULL |
+----+----+----------+------+------+------+----------+------+

-- Example 14899
SELECT *
  FROM left_table l ASOF JOIN right_table r
    MATCH_CONDITION(l.c3>=r.c3)
  ORDER BY l.c1, l.c2;

-- Example 14900
+----+----+----------+------+----+----+----------+------+
| C1 | C2 | C3       |   C4 | C1 | C2 | C3       |   C4 |
|----+----+----------+------+----+----+----------+------|
| A  |  1 | 09:15:00 | 3.21 | A  |  1 | 09:14:00 | 3.19 |
| A  |  2 | 09:16:00 | 3.22 | B  |  1 | 09:16:00 | 3.04 |
| B  |  1 | 09:17:00 | 3.23 | B  |  1 | 09:16:00 | 3.04 |
| B  |  2 | 09:18:00 | 4.23 | B  |  1 | 09:16:00 | 3.04 |
+----+----+----------+------+----+----+----------+------+

-- Example 14901
CREATE OR REPLACE TABLE right_table
  (c1 VARCHAR(1),
  c2 TINYINT,
  c3 TIME,
  c4 NUMBER(3,2),
  right_id VARCHAR(2));

INSERT INTO right_table VALUES
  ('A',1,'09:14:00',3.19,'A1'),
  ('A',1,'09:14:00',3.19,'A2'),
  ('B',1,'09:16:00',3.04,'B1');

SELECT * FROM right_table ORDER BY 1, 2;

-- Example 14902
+----+----+----------+------+----------+
| C1 | C2 | C3       |   C4 | RIGHT_ID |
|----+----+----------+------+----------|
| A  |  1 | 09:14:00 | 3.19 | A1       |
| A  |  1 | 09:14:00 | 3.19 | A2       |
| B  |  1 | 09:16:00 | 3.04 | B1       |
+----+----+----------+------+----------+

-- Example 14903
SELECT *
  FROM left_table l ASOF JOIN right_table r
    MATCH_CONDITION(l.c3>=r.c3)
  ORDER BY l.c1, l.c2;

-- Example 14904
+----+----+----------+------+----+----+----------+------+----------+
| C1 | C2 | C3       |   C4 | C1 | C2 | C3       |   C4 | RIGHT_ID |
|----+----+----------+------+----+----+----------+------+----------|
| A  |  1 | 09:15:00 | 3.21 | A  |  1 | 09:14:00 | 3.19 | A2       |
| A  |  2 | 09:16:00 | 3.22 | B  |  1 | 09:16:00 | 3.04 | B1       |
| B  |  1 | 09:17:00 | 3.23 | B  |  1 | 09:16:00 | 3.04 | B1       |
| B  |  2 | 09:18:00 | 4.23 | B  |  1 | 09:16:00 | 3.04 | B1       |
+----+----+----------+------+----+----+----------+------+----------+

-- Example 14905
SELECT ...
  FROM t1
    ASOF JOIN t2
      MATCH_CONDITION(...)
      ON t1.c1 = t2.c1
  WHERE t1 ...;

-- Example 14906
WITH t1 AS (SELECT * FROM t1 WHERE t1 ...)
SELECT ...
  FROM t1
    ASOF JOIN (SELECT * FROM t2 WHERE t2.c1 IN (SELECT t1.c1 FROM t1)) AS t2
      MATCH_CONDITION(...)
      ON t1.c1 = t2.c1;

-- Example 14907
SELECT * FROM asof;

WITH match_condition AS (SELECT * FROM T1) SELECT * FROM match_condition;

-- Example 14908
SELECT * FROM "asof";

WITH "match_condition" AS (SELECT * FROM T1) SELECT * FROM "match_condition";

-- Example 14909
SELECT * FROM "ASOF";

WITH "MATCH_CONDITION" AS (SELECT * FROM T1) SELECT * FROM "MATCH_CONDITION";

-- Example 14910
SELECT * FROM t1 asof;

SELECT * FROM t2 match_condition;

-- Example 14911
SELECT * FROM t1 AS asof;

SELECT * FROM t1 "asof";

SELECT * FROM t2 AS match_condition;

SELECT * FROM t2 "match_condition";

-- Example 14912
INSERT INTO trades VALUES('SNOW','2023-09-30 12:02:55.000',3000);

-- Example 14913
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       1 |
+-------------------------+

-- Example 14914
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time >= quote_time)
    ON t.stock_symbol=q.stock_symbol
  ORDER BY t.stock_symbol;

-- Example 14915
+--------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:03.000 | 139.00000000 |
| SNOW         | 2023-09-30 12:02:55.000 |     3000 | NULL                    |         NULL |
| SNOW         | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:02.000 | 163.00000000 |
| SNOW         | 2023-10-01 09:00:10.000 |     1500 | 2023-10-01 09:00:08.000 | 165.00000000 |
+--------------+-------------------------+----------+-------------------------+--------------+

-- Example 14916
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time <= quote_time)
    ON t.stock_symbol=q.stock_symbol
  ORDER BY t.stock_symbol;

-- Example 14917
+--------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:07.000 | 142.00000000 |
| SNOW         | 2023-10-01 09:00:10.000 |     1500 | NULL                    |         NULL |
| SNOW         | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:07.000 | 166.00000000 |
| SNOW         | 2023-09-30 12:02:55.000 |     3000 | 2023-10-01 09:00:01.000 | 166.00000000 |
+--------------+-------------------------+----------+-------------------------+--------------+

-- Example 14918
SELECT t.stock_symbol, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time <= quote_time)
    USING(stock_symbol)
  ORDER BY t.stock_symbol;

-- Example 14919
CREATE OR REPLACE TABLE companies(
  stock_symbol VARCHAR(4),
  company_name VARCHAR(100)
);

 INSERT INTO companies VALUES
  ('NVDA','NVIDIA Corp'),
  ('TSLA','Tesla Inc'),
  ('SNOW','Snowflake Inc'),
  ('AAPL','Apple Inc')
;

-- Example 14920
SELECT t.stock_symbol, c.company_name, t.trade_time, t.quantity, q.quote_time, q.price
  FROM trades t ASOF JOIN quotes q
    MATCH_CONDITION(t.trade_time >= quote_time)
    ON t.stock_symbol=q.stock_symbol
    INNER JOIN companies c ON c.stock_symbol=t.stock_symbol
  ORDER BY t.stock_symbol;

