-- Example 33338
groupCube ::= { <column_alias> | <position> | <expr> }

-- Example 33339
-- Create some tables and insert some rows.
CREATE TABLE products (product_ID INTEGER, wholesale_price REAL);
INSERT INTO products (product_ID, wholesale_price) VALUES 
    (1, 1.00),
    (2, 2.00);

CREATE TABLE sales (product_ID INTEGER, retail_price REAL, 
    quantity INTEGER, city VARCHAR, state VARCHAR);
INSERT INTO sales (product_id, retail_price, quantity, city, state) VALUES 
    (1, 2.00,  1, 'SF', 'CA'),
    (1, 2.00,  2, 'SJ', 'CA'),
    (2, 5.00,  4, 'SF', 'CA'),
    (2, 5.00,  8, 'SJ', 'CA'),
    (2, 5.00, 16, 'Miami', 'FL'),
    (2, 5.00, 32, 'Orlando', 'FL'),
    (2, 5.00, 64, 'SJ', 'PR');

-- Example 33340
SELECT state, city, SUM((s.retail_price - p.wholesale_price) * s.quantity) AS profit 
 FROM products AS p, sales AS s
 WHERE s.product_ID = p.product_ID
 GROUP BY CUBE (state, city)
 ORDER BY state, city NULLS LAST
 ;
+-------+---------+--------+
| STATE | CITY    | PROFIT |
|-------+---------+--------|
| CA    | SF      |     13 |
| CA    | SJ      |     26 |
| CA    | NULL    |     39 |
| FL    | Miami   |     48 |
| FL    | Orlando |     96 |
| FL    | NULL    |    144 |
| PR    | SJ      |    192 |
| PR    | NULL    |    192 |
| NULL  | Miami   |     48 |
| NULL  | Orlando |     96 |
| NULL  | SF      |     13 |
| NULL  | SJ      |    218 |
| NULL  | NULL    |    375 |
+-------+---------+--------+

-- Example 33341
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> desc_result = df.describe().sort("SUMMARY").show()
-------------------------------------------------------
|"SUMMARY"  |"A"                 |"B"                 |
-------------------------------------------------------
|count      |2.0                 |2.0                 |
|max        |3.0                 |4.0                 |
|mean       |2.0                 |3.0                 |
|min        |1.0                 |2.0                 |
|stddev     |1.4142135623730951  |1.4142135623730951  |
-------------------------------------------------------

-- Example 33342
>>> df = session.create_dataframe([[1, 2, 3]], schema=["a", "b", "c"])
>>> df.drop("a", "b").show()
-------
|"C"  |
-------
|3    |
-------

-- Example 33343
>>> df = session.create_dataframe([[1.0, 1], [float('nan'), 2], [None, 3], [4.0, None], [float('nan'), None]]).to_df("a", "b")
>>> # drop a row if it contains any nulls, with checking all columns
>>> df.na.drop().show()
-------------
|"A"  |"B"  |
-------------
|1.0  |1    |
-------------

>>> # drop a row only if all its values are null, with checking all columns
>>> df.na.drop(how='all').show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|nan   |2     |
|NULL  |3     |
|4.0   |NULL  |
---------------

>>> # drop a row if it contains at least one non-null and non-NaN values, with checking all columns
>>> df.na.drop(thresh=1).show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|nan   |2     |
|NULL  |3     |
|4.0   |NULL  |
---------------

>>> # drop a row if it contains any nulls, with checking column "a"
>>> df.na.drop(subset=["a"]).show()
--------------
|"A"  |"B"   |
--------------
|1.0  |1     |
|4.0  |NULL  |
--------------

>>> df.na.drop(subset="a").show()
--------------
|"A"  |"B"   |
--------------
|1.0  |1     |
|4.0  |NULL  |
--------------

-- Example 33344
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 33345
>>> df = session.create_dataframe([[1.0, 1], [float('nan'), 2], [None, 3], [4.0, None], [float('nan'), None]]).to_df("a", "b")
>>> # fill null and NaN values in all columns
>>> df.na.fill(3.14).show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|3.14  |2     |
|3.14  |3     |
|4.0   |NULL  |
|3.14  |NULL  |
---------------

>>> # fill null and NaN values in column "a"
>>> df.na.fill(3.14, subset="a").show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|3.14  |2     |
|3.14  |3     |
|4.0   |NULL  |
|3.14  |NULL  |
---------------

>>> # fill null and NaN values in column "a"
>>> df.na.fill({"a": 3.14}).show()
---------------
|"A"   |"B"   |
---------------
|1.0   |1     |
|3.14  |2     |
|3.14  |3     |
|4.0   |NULL  |
|3.14  |NULL  |
---------------

>>> # fill null and NaN values in column "a" and "b"
>>> df.na.fill({"a": 3.14, "b": 15}).show()
--------------
|"A"   |"B"  |
--------------
|1.0   |1    |
|3.14  |2    |
|3.14  |3    |
|4.0   |15   |
|3.14  |15   |
--------------

>>> df2 = session.create_dataframe([[1.0, True], [2.0, False], [3.0, False], [None, None]]).to_df("a", "b")
>>> df2.na.fill(True).show()
----------------
|"A"   |"B"    |
----------------
|1.0   |True   |
|2.0   |False  |
|3.0   |False  |
|NULL  |True   |
----------------

-- Example 33346
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["A", "B"])
>>> df_filtered = df.filter((col("A") > 1) & (col("B") < 100))  # Must use parenthesis before and after operator &.

>>> # The following two result in the same SQL query:
>>> df.filter(col("a") > 1).collect()
[Row(A=3, B=4)]
>>> df.filter("a > 1").collect()  # use SQL expression
[Row(A=3, B=4)]

-- Example 33347
>>> table1 = session.sql("select parse_json(numbers) as numbers from values('[1,2]') as T(numbers)")
>>> flattened = table1.flatten(table1["numbers"])
>>> flattened.select(table1["numbers"], flattened["value"].as_("flattened_number")).show()
----------------------------------
|"NUMBERS"  |"FLATTENED_NUMBER"  |
----------------------------------
|[          |1                   |
|  1,       |                    |
|  2        |                    |
|]          |                    |
|[          |2                   |
|  1,       |                    |
|  2        |                    |
|]          |                    |
----------------------------------

-- Example 33348
>>> from snowflake.snowpark.functions import col, lit, sum as sum_, max as max_
>>> df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> df.group_by().agg(sum_("b")).collect()
[Row(SUM(B)=9)]
>>> df.group_by("a").agg(sum_("b")).sort("a").collect()
[Row(A=1, SUM(B)=3), Row(A=2, SUM(B)=3), Row(A=3, SUM(B)=3)]
>>> df.group_by("a").agg(sum_("b").alias("sum_b"), max_("b").alias("max_b")).sort("a").collect()
[Row(A=1, SUM_B=3, MAX_B=2), Row(A=2, SUM_B=3, MAX_B=2), Row(A=3, SUM_B=3, MAX_B=2)]
>>> df.group_by(["a", lit("snow")]).agg(sum_("b")).sort("a").collect()
[Row(A=1, LITERAL()='snow', SUM(B)=3), Row(A=2, LITERAL()='snow', SUM(B)=3), Row(A=3, LITERAL()='snow', SUM(B)=3)]
>>> df.group_by("a").agg((col("*"), "count"), max_("b")).sort("a").collect()
[Row(A=1, COUNT(LITERAL())=2, MAX(B)=2), Row(A=2, COUNT(LITERAL())=2, MAX(B)=2), Row(A=3, COUNT(LITERAL())=2, MAX(B)=2)]
>>> df.group_by("a").median("b").sort("a").collect()
[Row(A=1, MEDIAN(B)=Decimal('1.500')), Row(A=2, MEDIAN(B)=Decimal('1.500')), Row(A=3, MEDIAN(B)=Decimal('1.500'))]
>>> df.group_by("a").function("avg")("b").sort("a").collect()
[Row(A=1, AVG(B)=Decimal('1.500000')), Row(A=2, AVG(B)=Decimal('1.500000')), Row(A=3, AVG(B)=Decimal('1.500000'))]

-- Example 33349
>>> from snowflake.snowpark.functions import col, lit, sum as sum_, max as max_
>>> df = session.create_dataframe([(1, 1),(1, 2),(2, 1),(2, 2),(3, 1),(3, 2)], schema=["a", "b"])
>>> df.group_by().agg(sum_("b")).collect()
[Row(SUM(B)=9)]
>>> df.group_by("a").agg(sum_("b")).sort("a").collect()
[Row(A=1, SUM(B)=3), Row(A=2, SUM(B)=3), Row(A=3, SUM(B)=3)]
>>> df.group_by("a").agg(sum_("b").alias("sum_b"), max_("b").alias("max_b")).sort("a").collect()
[Row(A=1, SUM_B=3, MAX_B=2), Row(A=2, SUM_B=3, MAX_B=2), Row(A=3, SUM_B=3, MAX_B=2)]
>>> df.group_by(["a", lit("snow")]).agg(sum_("b")).sort("a").collect()
[Row(A=1, LITERAL()='snow', SUM(B)=3), Row(A=2, LITERAL()='snow', SUM(B)=3), Row(A=3, LITERAL()='snow', SUM(B)=3)]
>>> df.group_by("a").agg((col("*"), "count"), max_("b")).sort("a").collect()
[Row(A=1, COUNT(LITERAL())=2, MAX(B)=2), Row(A=2, COUNT(LITERAL())=2, MAX(B)=2), Row(A=3, COUNT(LITERAL())=2, MAX(B)=2)]
>>> df.group_by("a").median("b").sort("a").collect()
[Row(A=1, MEDIAN(B)=Decimal('1.500')), Row(A=2, MEDIAN(B)=Decimal('1.500')), Row(A=3, MEDIAN(B)=Decimal('1.500'))]
>>> df.group_by("a").function("avg")("b").sort("a").collect()
[Row(A=1, AVG(B)=Decimal('1.500000')), Row(A=2, AVG(B)=Decimal('1.500000')), Row(A=3, AVG(B)=Decimal('1.500000'))]

-- Example 33350
>>> from snowflake.snowpark import GroupingSets
>>> df = session.create_dataframe([[1, 2, 10], [3, 4, 20], [1, 4, 30]], schema=["A", "B", "C"])
>>> df.group_by_grouping_sets(GroupingSets([col("a")])).count().sort("a").collect()
[Row(A=1, COUNT=2), Row(A=3, COUNT=1)]
>>> df.group_by_grouping_sets(GroupingSets(col("a"))).count().sort("a").collect()
[Row(A=1, COUNT=2), Row(A=3, COUNT=1)]
>>> df.group_by_grouping_sets(GroupingSets([col("a")], [col("b")])).count().sort("a", "b").collect()
[Row(A=None, B=2, COUNT=1), Row(A=None, B=4, COUNT=2), Row(A=1, B=None, COUNT=2), Row(A=3, B=None, COUNT=1)]
>>> df.group_by_grouping_sets(GroupingSets([col("a"), col("b")], [col("c")])).count().sort("a", "b", "c").collect()
[Row(A=None, B=None, C=10, COUNT=1), Row(A=None, B=None, C=20, COUNT=1), Row(A=None, B=None, C=30, COUNT=1), Row(A=1, B=2, C=None, COUNT=1), Row(A=1, B=4, C=None, COUNT=1), Row(A=3, B=4, C=None, COUNT=1)]

-- Example 33351
SELECT ...
FROM ...
[ ... ]
GROUP BY GROUPING SETS ( groupSet [ , groupSet [ , ... ] ] )
[ ... ]

-- Example 33352
groupSet ::= { <column_alias> | <position> | <expr> }

-- Example 33353
CREATE or replace TABLE nurses (
  ID INTEGER,
  full_name VARCHAR,
  medical_license VARCHAR,   -- LVN, RN, etc.
  radio_license VARCHAR      -- Technician, General, Amateur Extra
  )
  ;

INSERT INTO nurses
    (ID, full_name, medical_license, radio_license)
  VALUES
    (201, 'Thomas Leonard Vicente', 'LVN', 'Technician'),
    (202, 'Tamara Lolita VanZant', 'LVN', 'Technician'),
    (341, 'Georgeann Linda Vente', 'LVN', 'General'),
    (471, 'Andrea Renee Nouveau', 'RN', 'Amateur Extra')
    ;

-- Example 33354
SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY GROUPING SETS (medical_license, radio_license);

-- Example 33355
+----------+-----------------+---------------+
| COUNT(*) | MEDICAL_LICENSE | RADIO_LICENSE |
|----------+-----------------+---------------|
|        3 | LVN             | NULL          |
|        1 | RN              | NULL          |
|        2 | NULL            | Technician    |
|        1 | NULL            | General       |
|        1 | NULL            | Amateur Extra |
+----------+-----------------+---------------+

-- Example 33356
INSERT INTO nurses
    (ID, full_name, medical_license, radio_license)
  VALUES
    (101, 'Lily Vine', 'LVN', NULL),
    (102, 'Larry Vancouver', 'LVN', NULL),
    (172, 'Rhonda Nova', 'RN', NULL)
    ;

-- Example 33357
SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY GROUPING SETS (medical_license, radio_license);

-- Example 33358
+----------+-----------------+---------------+
| COUNT(*) | MEDICAL_LICENSE | RADIO_LICENSE |
|----------+-----------------+---------------|
|        5 | LVN             | NULL          |
|        2 | RN              | NULL          |
|        2 | NULL            | Technician    |
|        1 | NULL            | General       |
|        1 | NULL            | Amateur Extra |
|        3 | NULL            | NULL          |
+----------+-----------------+---------------+

-- Example 33359
SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY medical_license, radio_license;

-- Example 33360
+----------+-----------------+---------------+
| COUNT(*) | MEDICAL_LICENSE | RADIO_LICENSE |
|----------+-----------------+---------------|
|        2 | LVN             | Technician    |
|        1 | LVN             | General       |
|        1 | RN              | Amateur Extra |
|        2 | LVN             | NULL          |
|        1 | RN              | NULL          |
+----------+-----------------+---------------+

-- Example 33361
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.intersect(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

-- Example 33362
>>> from snowflake.snowpark.functions import col
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.join(df2, df1.a == df2.a).select(df1.a.alias("a_1"), df2.a.alias("a_2"), df1.b, df2.c).show()
-----------------------------
|"A_1"  |"A_2"  |"B"  |"C"  |
-----------------------------
|1      |1      |2    |7    |
|3      |3      |4    |8    |
-----------------------------

>>> # refer a single column "a"
>>> df1.join(df2, "a").select(df1.a.alias("a"), df1.b, df2.c).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

>>> # rename the ambiguous columns
>>> df3 = df1.to_df("df1_a", "b")
>>> df4 = df2.to_df("df2_a", "c")
>>> df3.join(df4, col("df1_a") == col("df2_a")).select(col("df1_a").alias("a"), "b", "c").show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

-- Example 33363
>>> # join multiple columns
>>> mdf1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> mdf2 = session.create_dataframe([[1, 2], [3, 4], [7, 6]], schema=["a", "b"])
>>> mdf1.join(mdf2, ["a", "b"]).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
-------------

>>> mdf1.join(mdf2, (mdf1["a"] < mdf2["a"]) & (mdf1["b"] == mdf2["b"])).select(mdf1["a"].as_("new_a"), mdf1["b"].as_("new_b")).show()
---------------------
|"NEW_A"  |"NEW_B"  |
---------------------
|5        |6        |
---------------------

>>> # use lsuffix and rsuffix to resolve duplicating column names
>>> mdf1.join(mdf2, (mdf1["a"] < mdf2["a"]) & (mdf1["b"] == mdf2["b"]), lsuffix="_left", rsuffix="_right").show()
-----------------------------------------------
|"A_LEFT"  |"B_LEFT"  |"A_RIGHT"  |"B_RIGHT"  |
-----------------------------------------------
|5         |6         |7          |6          |
-----------------------------------------------

>>> mdf1.join(mdf2, (mdf1["a"] < mdf2["a"]) & (mdf1["b"] == mdf2["b"]), rsuffix="_right").show()
-------------------------------------
|"A"  |"B"  |"A_RIGHT"  |"B_RIGHT"  |
-------------------------------------
|5    |6    |7          |6          |
-------------------------------------

>>> # examples of different joins
>>> df5 = session.create_dataframe([3, 4, 5, 5, 6, 7], schema=["id"])
>>> df6 = session.create_dataframe([5, 6, 7, 7, 8, 9], schema=["id"])
>>> # inner join
>>> df5.join(df6, "id", "inner").sort("id").show()
--------
|"ID"  |
--------
|5     |
|5     |
|6     |
|7     |
|7     |
--------

>>> # left/leftouter join
>>> df5.join(df6, "id", "left").sort("id").show()
--------
|"ID"  |
--------
|3     |
|4     |
|5     |
|5     |
|6     |
|7     |
|7     |
--------

>>> # right/rightouter join
>>> df5.join(df6, "id", "right").sort("id").show()
--------
|"ID"  |
--------
|5     |
|5     |
|6     |
|7     |
|7     |
|8     |
|9     |
--------

>>> # full/outer/fullouter join
>>> df5.join(df6, "id", "full").sort("id").show()
--------
|"ID"  |
--------
|3     |
|4     |
|5     |
|5     |
|6     |
|7     |
|7     |
|8     |
|9     |
--------

>>> # semi/leftsemi join
>>> df5.join(df6, "id", "semi").sort("id").show()
--------
|"ID"  |
--------
|5     |
|5     |
|6     |
|7     |
--------

>>> # anti/leftanti join
>>> df5.join(df6, "id", "anti").sort("id").show()
--------
|"ID"  |
--------
|3     |
|4     |
--------

-- Example 33364
>>> df1.filter(df1.a == 1).join(df2, df1.a == df2.a).select(df1.a.alias("a"), df1.b, df2.c)

-- Example 33365
>>> df1.join(df2, (df1.a == 1) & (df1.a == df2.a)).select(df1.a.alias("a"), df1.b, df2.c).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
-------------------

-- Example 33366
>>> df3 = df1.filter(df1.a == 1)
>>> df3.join(df2, df3.a == df2.a).select(df3.a.alias("a"), df3.b, df2.c).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
-------------------

-- Example 33367
>>> # asof join examples
>>> df1 = session.create_dataframe([['A', 1, 15, 3.21],
...                                 ['A', 2, 16, 3.22],
...                                 ['B', 1, 17, 3.23],
...                                 ['B', 2, 18, 4.23]],
...                                schema=["c1", "c2", "c3", "c4"])
>>> df2 = session.create_dataframe([['A', 1, 14, 3.19],
...                                 ['B', 2, 16, 3.04]],
...                                schema=["c1", "c2", "c3", "c4"])
>>> df1.join(df2, on=["c1", "c2"], how="asof", match_condition=(df1.c3 >= df2.c3)) \
...     .select(df1.c1, df1.c2, df1.c3.alias("C3_1"), df1.c4.alias("C4_1"), df2.c3.alias("C3_2"), df2.c4.alias("C4_2")) \
...     .order_by("c1", "c2").show()
---------------------------------------------------
|"C1"  |"C2"  |"C3_1"  |"C4_1"  |"C3_2"  |"C4_2"  |
---------------------------------------------------
|A     |1     |15      |3.21    |14      |3.19    |
|A     |2     |16      |3.22    |NULL    |NULL    |
|B     |1     |17      |3.23    |NULL    |NULL    |
|B     |2     |18      |4.23    |16      |3.04    |
---------------------------------------------------

>>> df1.join(df2, on=(df1.c1 == df2.c1) & (df1.c2 == df2.c2), how="asof",
...     match_condition=(df1.c3 >= df2.c3), lsuffix="_L", rsuffix="_R") \
...     .order_by("C1_L", "C2_L").show()
-------------------------------------------------------------------------
|"C1_L"  |"C2_L"  |"C3_L"  |"C4_L"  |"C1_R"  |"C2_R"  |"C3_R"  |"C4_R"  |
-------------------------------------------------------------------------
|A       |1       |15      |3.21    |A       |1       |14      |3.19    |
|A       |2       |16      |3.22    |NULL    |NULL    |NULL    |NULL    |
|B       |1       |17      |3.23    |NULL    |NULL    |NULL    |NULL    |
|B       |2       |18      |4.23    |B       |2       |16      |3.04    |
-------------------------------------------------------------------------

>>> df1 = df1.alias("L")
>>> df2 = df2.alias("R")
>>> df1.join(df2, using_columns=["c1", "c2"], how="asof",
...         match_condition=(df1.c3 >= df2.c3)).order_by("C1", "C2").show()
-----------------------------------------------
|"C1"  |"C2"  |"C3L"  |"C4L"  |"C3R"  |"C4R"  |
-----------------------------------------------
|A     |1     |15     |3.21   |14     |3.19   |
|A     |2     |16     |3.22   |NULL   |NULL   |
|B     |1     |17     |3.23   |NULL   |NULL   |
|B     |2     |18     |4.23   |16     |3.04   |
-----------------------------------------------

-- Example 33368
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.join_table_function("split_to_table", df["addresses"], lit(" ")).show()
--------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
--------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1        |address1  |
|James   |address1 address2 address3  |1      |2        |address2  |
|James   |address1 address2 address3  |1      |3        |address3  |
--------------------------------------------------------------------

-- Example 33369
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.join_table_function(split_to_table(df["addresses"], lit(" "))).show()
--------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
--------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1        |address1  |
|James   |address1 address2 address3  |1      |2        |address2  |
|James   |address1 address2 address3  |1      |3        |address3  |
--------------------------------------------------------------------

-- Example 33370
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.create_dataframe([
...     ["John", "James", "address1 address2 address3"],
...     ["Mike", "James", "address4 address5 address6"],
...     ["Cathy", "Stone", "address4 address5 address6"],
... ],
... schema=["first_name", "last_name", "addresses"])
>>> df.join_table_function(split_to_table(df["addresses"], lit(" ")).over(partition_by="last_name", order_by="first_name")).show()
----------------------------------------------------------------------------------------
|"FIRST_NAME"  |"LAST_NAME"  |"ADDRESSES"                 |"SEQ"  |"INDEX"  |"VALUE"   |
----------------------------------------------------------------------------------------
|John          |James        |address1 address2 address3  |1      |1        |address1  |
|John          |James        |address1 address2 address3  |1      |2        |address2  |
|John          |James        |address1 address2 address3  |1      |3        |address3  |
|Mike          |James        |address4 address5 address6  |2      |1        |address4  |
|Mike          |James        |address4 address5 address6  |2      |2        |address5  |
|Mike          |James        |address4 address5 address6  |2      |3        |address6  |
|Cathy         |Stone        |address4 address5 address6  |3      |1        |address4  |
|Cathy         |Stone        |address4 address5 address6  |3      |2        |address5  |
|Cathy         |Stone        |address4 address5 address6  |3      |3        |address6  |
----------------------------------------------------------------------------------------

-- Example 33371
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df = session.sql("select 'James' as name, 'address1 address2 address3' as addresses")
>>> df.join_table_function(split_to_table(col("addresses"), lit(" ")).alias("seq", "idx", "val")).show()
------------------------------------------------------------------
|"NAME"  |"ADDRESSES"                 |"SEQ"  |"IDX"  |"VAL"     |
------------------------------------------------------------------
|James   |address1 address2 address3  |1      |1      |address1  |
|James   |address1 address2 address3  |1      |2      |address2  |
|James   |address1 address2 address3  |1      |3      |address3  |
------------------------------------------------------------------

-- Example 33372
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df.limit(1).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
-------------

>>> df.limit(1, offset=1).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 33373
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 33374
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.natural_join(df2).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |2    |7    |
|3    |4    |8    |
-------------------

-- Example 33375
>>> df1 = session.create_dataframe([[1, 2], [3, 4], [5, 6]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 7], [3, 8]], schema=["a", "c"])
>>> df1.natural_join(df2, "left").show()
--------------------
|"A"  |"B"  |"C"   |
--------------------
|1    |2    |7     |
|3    |4    |8     |
|5    |6    |NULL  |
--------------------

-- Example 33376
>>> from snowflake.snowpark.functions import col

>>> df = session.create_dataframe([[1, 2], [3, 4], [1, 4]], schema=["A", "B"])
>>> df.sort(col("A"), col("B").asc()).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------


>>> df.sort(col("a"), ascending=False).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
|1    |2    |
|1    |4    |
-------------


>>> # The values from the list overwrite the column ordering.
>>> df.sort(["a", col("b").desc()], ascending=[1, 1]).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------

-- Example 33377
>>> from snowflake.snowpark.functions import col

>>> df = session.create_dataframe([[1, 2], [3, 4], [1, 4]], schema=["A", "B"])
>>> df.sort(col("A"), col("B").asc()).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------


>>> df.sort(col("a"), ascending=False).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
|1    |2    |
|1    |4    |
-------------


>>> # The values from the list overwrite the column ordering.
>>> df.sort(["a", col("b").desc()], ascending=[1, 1]).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------

-- Example 33378
>>> create_result = session.sql('''create or replace temp table monthly_sales(empid int, amount int, month text)
... as select * from values
... (1, 10000, 'JAN'),
... (1, 400, 'JAN'),
... (2, 4500, 'JAN'),
... (2, 35000, 'JAN'),
... (1, 5000, 'FEB'),
... (1, 3000, 'FEB'),
... (2, 200, 'FEB') ''').collect()
>>> df = session.table("monthly_sales")
>>> df.pivot("month", ['JAN', 'FEB']).sum("amount").sort(df["empid"]).show()
-------------------------------
|"EMPID"  |"'JAN'"  |"'FEB'"  |
-------------------------------
|1        |10400    |8000     |
|2        |39500    |200      |
-------------------------------


>>> df = session.table("monthly_sales")
>>> df.pivot("month").sum("amount").sort("empid").show()
-------------------------------
|"EMPID"  |"'FEB'"  |"'JAN'"  |
-------------------------------
|1        |8000     |10400    |
|2        |200      |39500    |
-------------------------------


>>> subquery_df = session.table("monthly_sales").select(col("month")).filter(col("month") == "JAN")
>>> df = session.table("monthly_sales")
>>> df.pivot("month", values=subquery_df).sum("amount").sort("empid").show()
---------------------
|"EMPID"  |"'JAN'"  |
---------------------
|1        |10400    |
|2        |39500    |
---------------------

-- Example 33379
>>> df = session.create_dataframe([(1, "a"), (2, "b")], schema=["a", "b"])
>>> df.print_schema()
root
 |-- "A": LongType() (nullable = False)
 |-- "B": StringType() (nullable = False)

-- Example 33380
>>> df = session.create_dataframe([(1, "a"), (2, "b")], schema=["a", "b"])
>>> df.print_schema()
root
 |-- "A": LongType() (nullable = False)
 |-- "B": StringType() (nullable = False)

-- Example 33381
>>> df = session.range(10000)
>>> weights = [0.1, 0.2, 0.3]
>>> df_parts = df.random_split(weights)
>>> len(df_parts) == len(weights)
True

-- Example 33382
>>> df = session.range(10000)
>>> weights = [0.1, 0.2, 0.3]
>>> df_parts = df.random_split(weights)
>>> len(df_parts) == len(weights)
True

-- Example 33383
>>> # This example renames the column `A` as `NEW_A` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.rename(col("A"), "NEW_A")
>>> df_renamed.show()
-----------------
|"NEW_A"  |"B"  |
-----------------
|1        |2    |
-----------------

>>> # This example renames the column `A` as `NEW_A` and `B` as `NEW_B` in the DataFrame.
>>> df = session.sql("select 1 as A, 2 as B")
>>> df_renamed = df.rename({col("A"): "NEW_A", "B":"NEW_B"})
>>> df_renamed.show()
---------------------
|"NEW_A"  |"NEW_B"  |
---------------------
|1        |2        |
---------------------

-- Example 33384
>>> df = session.create_dataframe([[1, 1.0, "1.0"], [2, 2.0, "2.0"]], schema=["a", "b", "c"])
>>> # replace 1 with 3 in all columns
>>> df.na.replace(1, 3).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|2    |2.0  |2.0  |
-------------------

>>> # replace 1 with 3 and 2 with 4 in all columns
>>> df.na.replace([1, 2], [3, 4]).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|4    |4.0  |2.0  |
-------------------

>>> # replace 1 with 3 and 2 with 3 in all columns
>>> df.na.replace([1, 2], 3).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|3    |3.0  |2.0  |
-------------------

>>> # the following line intends to replaces 1 with 3 and 2 with 4 in all columns
>>> # and will give [Row(3, 3.0, "1.0"), Row(4, 4.0, "2.0")]
>>> df.na.replace({1: 3, 2: 4}).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|3    |3.0  |1.0  |
|4    |4.0  |2.0  |
-------------------

>>> # the following line intends to replace 1 with "3" in column "a",
>>> # but will be ignored since "3" (str) doesn't match the original data type
>>> df.na.replace({1: "3"}, ["a"]).show()
-------------------
|"A"  |"B"  |"C"  |
-------------------
|1    |1.0  |1.0  |
|2    |2.0  |2.0  |
-------------------

-- Example 33385
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 33386
>>> df = session.create_dataframe([("Bob", 17), ("Alice", 10), ("Nico", 8), ("Bob", 12)], schema=["name", "age"])
>>> fractions = {"Bob": 0.5, "Nico": 1.0}
>>> sample_df = df.stat.sample_by("name", fractions)  # non-deterministic result

-- Example 33387
>>> df = session.create_dataframe([[1, "some string value", 3, 4]], schema=["col1", "col2", "col3", "col4"])
>>> df_selected = df.select(col("col1"), col("col2").substr(0, 10), df["col3"] + df["col4"])

-- Example 33388
>>> df_selected = df.select("col1", "col2", "col3")

-- Example 33389
>>> df_selected = df.select(["col1", "col2", "col3"])

-- Example 33390
>>> df_selected = df.select(df["col1"], df.col2, df.col("col3"))

-- Example 33391
>>> from snowflake.snowpark.functions import table_function
>>> split_to_table = table_function("split_to_table")
>>> df.select(df.col1, split_to_table(df.col2, lit(" ")), df.col("col3")).show()
-----------------------------------------------
|"COL1"  |"SEQ"  |"INDEX"  |"VALUE"  |"COL3"  |
-----------------------------------------------
|1       |1      |1        |some     |3       |
|1       |1      |2        |string   |3       |
|1       |1      |3        |value    |3       |
-----------------------------------------------

-- Example 33392
>>> df = session.create_dataframe([-1, 2, 3], schema=["a"])  # with one pair of [], the dataframe has a single column and 3 rows.
>>> df.select_expr("abs(a)", "a + 2", "cast(a as string)").show()
--------------------------------------------
|"ABS(A)"  |"A + 2"  |"CAST(A AS STRING)"  |
--------------------------------------------
|1         |1        |-1                   |
|2         |4        |2                    |
|3         |5        |3                    |
--------------------------------------------

-- Example 33393
>>> df = session.create_dataframe([-1, 2, 3], schema=["a"])  # with one pair of [], the dataframe has a single column and 3 rows.
>>> df.select_expr("abs(a)", "a + 2", "cast(a as string)").show()
--------------------------------------------
|"ABS(A)"  |"A + 2"  |"CAST(A AS STRING)"  |
--------------------------------------------
|1         |1        |-1                   |
|2         |4        |2                    |
|3         |5        |3                    |
--------------------------------------------

-- Example 33394
>>> from snowflake.snowpark.functions import col

>>> df = session.create_dataframe([[1, 2], [3, 4], [1, 4]], schema=["A", "B"])
>>> df.sort(col("A"), col("B").asc()).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------


>>> df.sort(col("a"), ascending=False).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
|1    |2    |
|1    |4    |
-------------


>>> # The values from the list overwrite the column ordering.
>>> df.sort(["a", col("b").desc()], ascending=[1, 1]).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|1    |4    |
|3    |4    |
-------------

-- Example 33395
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[1, 2], [5, 6]], schema=["c", "d"])
>>> df1.subtract(df2).show()
-------------
|"A"  |"B"  |
-------------
|3    |4    |
-------------

-- Example 33396
>>> df1 = session.range(1, 10, 2).to_df("col1")
>>> df2 = session.range(1, 10, 2).to_df(["col1"])

-- Example 33397
>>> df = session.table("prices")
>>> for row in df.to_local_iterator():
...     print(row)
Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00'))
Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))

-- Example 33398
>>> df1 = session.range(1, 10, 2).to_df("col1")
>>> df2 = session.range(1, 10, 2).to_df(["col1"])

-- Example 33399
>>> df = session.table("prices")
>>> for row in df.to_local_iterator():
...     print(row)
Row(PRODUCT_ID='id1', AMOUNT=Decimal('10.00'))
Row(PRODUCT_ID='id2', AMOUNT=Decimal('20.00'))

-- Example 33400
>>> df = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> for pandas_df in df.to_pandas_batches():
...     print(pandas_df)
   A  B
0  1  2
1  3  4

-- Example 33401
>>> df = session.create_dataframe([[1, 2, 3]], schema=["a", "b", "c"])
>>> snowpark_pandas_df = df.to_snowpark_pandas()  
>>> snowpark_pandas_df      
   A  B  C
0  1  2  3

-- Example 33402
>>> snowpark_pandas_df = df.to_snowpark_pandas(index_col='A')  
>>> snowpark_pandas_df      
   B  C
A
1  2  3
>>> snowpark_pandas_df = df.to_snowpark_pandas(index_col='A', columns=['B'])  
>>> snowpark_pandas_df      
   B
A
1  2
>>> snowpark_pandas_df = df.to_snowpark_pandas(index_col=['B', 'A'], columns=['A', 'C', 'A'])  
>>> snowpark_pandas_df      
     A  C  A
B A
2 1  1  3  1

-- Example 33403
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[0, 1], [3, 4]], schema=["c", "d"])
>>> df1.union(df2).sort("a").show()
-------------
|"A"  |"B"  |
-------------
|0    |1    |
|1    |2    |
|3    |4    |
-------------

-- Example 33404
>>> df1 = session.create_dataframe([[1, 2], [3, 4]], schema=["a", "b"])
>>> df2 = session.create_dataframe([[0, 1], [3, 4]], schema=["c", "d"])
>>> df1.union_all(df2).show()
-------------
|"A"  |"B"  |
-------------
|1    |2    |
|3    |4    |
|0    |1    |
|3    |4    |
-------------

