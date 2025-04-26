-- Example 30792
public static Column seq2()

-- Example 30793
public static Column seq2​(boolean startsFromZero)

-- Example 30794
public static Column seq4()

-- Example 30795
public static Column seq4​(boolean startsFromZero)

-- Example 30796
public static Column seq8()

-- Example 30797
public static Column seq8​(boolean startsFromZero)

-- Example 30798
public static Column uniform​(Column min,
                             Column max,
                             Column gen)

-- Example 30799
public static Column listagg​(Column col,
                             String delimiter,
                             boolean isDistinct)

-- Example 30800
df.groupBy(df.col("col1")).agg(Functions.listagg(df.col("col2"), ",")
      .withinGroup(df.col("col2").asc()))


 df.select(Functions.listagg(df.col("col2"), ",", false))

-- Example 30801
public static Column listagg​(Column col,
                             String delimiter)

-- Example 30802
df.groupBy(df.col("col1")).agg(Functions.listagg(df.col("col2"), ",")
      .withinGroup(df.col("col2").asc()))


 df.select(Functions.listagg(df.col("col2"), ",", false))

-- Example 30803
public static Column listagg​(Column col)

-- Example 30804
df.groupBy(df.col("col1")).agg(Functions.listagg(df.col("col2"), ",")
      .withinGroup(df.col("col2").asc()))


 df.select(Functions.listagg(df.col("col2"), ",", false))

-- Example 30805
public static Column reverse​(Column name)

-- Example 30806
SELECT REVERSE('Hello, world!');
   +--------------------------+
   | REVERSE('HELLO, WORLD!') |
   |--------------------------|
   | !dlrow ,olleH            |
   +--------------------------+

-- Example 30807
public static Column isnull​(Column c)

-- Example 30808
>>> from snowflake.snowpark.functions import is_null >>> df = session.create_dataframe([1.2,
 float("nan"), None, 1.0], schema=["a"]) >>> df.select(is_null("a").as_("a")).collect()
 [Row(A=False), Row(A=False), Row(A=True), Row(A=False)]

-- Example 30809
public static Column unix_timestamp​(Column c)

-- Example 30810
SELECT TO_TIMESTAMP('2013-05-08T23:39:20.123-07:00') AS "TIME_STAMP1",
  DATE_PART(EPOCH_SECOND, "TIME_STAMP1") AS "EXTRACTED EPOCH SECOND";
 +-------------------------+------------------------+
 | TIME_STAMP1             | EXTRACTED EPOCH SECOND |
 |-------------------------+------------------------|
 | 2013-05-08 23:39:20.123 |             1368056360 |
 +-------------------------+------------------------+

-- Example 30811
public static Column regexp_extract​(Column col,
                                    String exp,
                                    Integer position,
                                    Integer Occurences,
                                    Integer grpIdx)

-- Example 30812
from snowflake.snowpark.functions import regexp_extract
 df = session.createDataFrame([["id_20_30", 10], ["id_40_50", 30]], ["id", "age"])
 df.select(regexp_extract("id", r"(\d+)", 1).alias("RES")).show()
    ---------
     |"RES"  |
     ---------
     |20     |
     |40     |
     ---------

-- Example 30813
public static Column signum​(Column col)

-- Example 30814
df =
 session.create_dataframe([(-2, 2, 0)], ["a", "b", "c"]) >>>
 df.select(sign("a").alias("a_sign"), sign("b").alias("b_sign"),
 sign("c").alias("c_sign")).show()
   ----------------------------------
     |"A_SIGN"  |"B_SIGN"  |"C_SIGN"  |
     ----------------------------------
     |-1        |1         |0         |
     ----------------------------------

-- Example 30815
public static Column sign​(Column col)

-- Example 30816
df =
 session.create_dataframe([(-2, 2, 0)], ["a", "b", "c"]) >>>
 df.select(sign("a").alias("a_sign"), sign("b").alias("b_sign"),
 sign("c").alias("c_sign")).show()
   ----------------------------------
     |"A_SIGN"  |"B_SIGN"  |"C_SIGN"  |
     ----------------------------------
     |-1        |1         |0         |
     ----------------------------------

-- Example 30817
public static Column substring_index​(String col,
                                     String delim,
                                     Integer count)

-- Example 30818
public static Column collect_list​(Column c)

-- Example 30819
df = session.create_dataframe([[1], [2], [3], [1]], schema=["a"])
 df.select(array_agg("a", True).alias("result")).show()
 "RESULT" [ 1, 2, 3 ]

-- Example 30820
public static Column date_add​(Integer days,
                              Column start)

-- Example 30821
SELECT TO_DATE('2013-05-08') AS v1, DATE_ADD(year, 2, TO_DATE('2013-05-08')) AS v;

 +------------+------------+
 | V1         | V          |
 |------------+------------|
 | 2013-05-08 | 2015-05-08 |
 +------------+------------+

-- Example 30822
public static Column date_add​(Column start,
                              Column days)

-- Example 30823
SELECT TO_DATE('2013-05-08') AS v1, DATE_ADD(year, 2, TO_DATE('2013-05-08')) AS v;

 +------------+------------+
 | V1         | V          |
 |------------+------------|
 | 2013-05-08 | 2015-05-08 |
 +------------+------------+

-- Example 30824
public static Column collect_set​(Column e)

-- Example 30825
>>> df = session.create_dataframe([[1], [2], [3], [1]], schema=["a"])
 >>> df.select(array_agg("a", True).alias("result")).show()
 ------------
 |"RESULT"  |
 ------------
 |[         |
 |  1,      |
 |  2,      |
 |  3       |
 |]         |
 ------------

-- Example 30826
public static Column collect_set​(String e)

-- Example 30827
df = session.create_dataframe([[1], [2], [3], [1]], schema=["a"])
 df.select(array_agg("a", True).alias("result")).show()
 ------------
 |"RESULT" |
 ------------
 |[| | 1, | | 2, | | 3 | |] |
 ------------

-- Example 30828
public static Column from_unixtime​(Column ut)

-- Example 30829
df = session.create_dataframe([("2023-10-10",), ("2022-05-15",), ("invalid",)] ,
 schema=['date']) df.select(date_format('date', 'YYYY/MM/DD').as_('formatted_date')).show()
 --------------------
 |"FORMATTED_DATE" |
 --------------------
 |2023/10/10 | |2022/05/15 | |NULL
 | --------------------

-- Example 30830
public static Column from_unixtime​(Column ut,
                                   String f)

-- Example 30831
df = session.create_dataframe([("2023-10-10",), ("2022-05-15",),
 ("invalid",)], schema=['date'])
 df.select(date_format('date',
 'YYYY/MM/DD').as_('formatted_date')).show()
 --------------------
 |"FORMATTED_DATE" |
 --------------------
 |2023/10/10 | |2022/05/15 | |NULL |
 --------------------

-- Example 30832
public static Column monotonically_increasing_id()

-- Example 30833
>>> df = session.generator(seq8(0), rowcount=3)
 >>> df.collect()
 [Row(SEQ8(0)=0),Row(SEQ8(0)=1), Row(SEQ8(0)=2)]

-- Example 30834
public static Column months_between​(String end,
                                    String start)

-- Example 30835
{{{
 months_between("2017-11-14", "2017-07-14")  // returns 4.0
 months_between("2017-01-01", "2017-01-10")  // returns 0.29032258
 months_between("2017-06-01", "2017-06-16 12:00:00")  // returns -0.5
 }}}

-- Example 30836
public static Column instr​(Column str,
                           String substring)

-- Example 30837
SELECT id,
        string1,
        REGEXP_SUBSTR(string1, 'nevermore\\d') AS substring,
        REGEXP_INSTR( string1, 'nevermore\\d') AS position
   FROM demo1
   ORDER BY id;

   +----+-------------------------------------+------------+----------+
 | ID | STRING1                             | SUBSTRING  | POSITION |
 |----+-------------------------------------+------------+----------|
 |  1 | nevermore1, nevermore2, nevermore3. | nevermore1 |        1 |
 +----+-------------------------------------+------------+----------+

-- Example 30838
public static Column from_utc_timestamp​(Column ts)

-- Example 30839
ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';
 SELECT TO_TIMESTAMP_TZ('2024-04-05 01:02:03');
  +----------------------------------------+
 | TO_TIMESTAMP_TZ('2024-04-05 01:02:03') |
 |----------------------------------------|
 | 2024-04-05 01:02:03.000 -0700          |
 +----------------------------------------+

-- Example 30840
public static Column to_utc_timestamp​(Column ts)

-- Example 30841
public static Column format_number​(Column x,
                                   Integer d)

-- Example 30842
public static Column desc​(String name)

-- Example 30843
public static Column asc​(String name)

-- Example 30844
DataFrame df = getSession().sql("select * from values(3),(1),(2) as t(a)");
 df.sort(Functions.asc("a")).show();
 -------
 |"A"  |
 -------
 |1    |
 |2    |
 |3    |
 -------

-- Example 30845
public static Column size​(Column col)

-- Example 30846
DataFrame df = getSession().sql("select array_construct(a,b,c) as arr from values(1,2,3) as T(a,b,c)");
 df.select(Functions.size(Functions.col("arr"))).show();
 -------------------------
 |"ARRAY_SIZE(""ARR"")"  |
 -------------------------
 |3                      |
 -------------------------

-- Example 30847
public static Column expr​(String s)

-- Example 30848
DataFrame df = getSession().sql("select a from values(1), (2), (3) as T(a)");
 df.filter(Functions.expr("a > 2")).show();
 -------
 |"A"  |
 -------
 |3    |
 -------

-- Example 30849
public static Column array​(Column... cols)

-- Example 30850
DataFrame df = getSession().sql("select * from values(1,2,3) as T(a,b,c)");
 df.select(Functions.array(df.col("a"), df.col("b"), df.col("c")).as("array")).show();
 -----------
 |"ARRAY"  |
 -----------
 |[        |
 |  1,     |
 |  2,     |
 |  3      |
 |]        |
 -----------

-- Example 30851
public static Column date_format​(Column col,
                                 String s)

-- Example 30852
DataFrame df = getSession().sql("select * from values ('2023-10-10'), ('2022-05-15') as T(a)");
 df.select(Functions.date_format(df.col("a"), "YYYY/MM/DD").as("formatted_date")).show();
 --------------------
 |"FORMATTED_DATE"  |
 --------------------
 |2023/10/10        |
 |2022/05/15        |
 --------------------

-- Example 30853
public static Column last​(Column col)

-- Example 30854
DataFrame df = getSession().sql("select * from values (5, 'a', 10), (5, 'b', 20),\n" +
             "    (3, 'd', 15), (3, 'e', 40) as T(grade,name,score)");
 df.select(Functions.last(df.col("name")).over(Window.partitionBy(df.col("grade")).orderBy(df.col("score").desc()))).show();
 ----------------
 |"LAST_VALUE"  |
 ----------------
 |a             |
 |a             |
 |d             |
 |d             |
 ----------------

-- Example 30855
public static Column log10​(Column col)

-- Example 30856
DataFrame df = getSession().sql("select * from values (100) as T(a)");
 df.select(Functions.log10(df.col("a")).as("log10")).show();
 -----------
 |"LOG10"  |
 -----------
 |2.0      |
 -----------

-- Example 30857
public static Column log10​(String s)

-- Example 30858
DataFrame df = getSession().sql("select * from values (100) as T(a)");
 df.select(Functions.log10("a").as("log10")).show();
 -----------
 |"LOG10"  |
 -----------
 |2.0      |
 -----------

