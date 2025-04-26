-- Example 21284
val df = Seq("2023-10-10", "2022-05-15", null.asInstanceOf[String]).toDF("date")
 df.select(date_format(col("date"), "YYYY/MM/DD").as("formatted_date")).show()

--------------------
|"FORMATTED_DATE"  |
--------------------
|2023/10/10        |
|2022/05/15        |
|NULL              |
--------------------

-- Example 21285
date.select(dateadd("year", lit(1), col("date_col")))

-- Example 21286
date.select(datediff("year", col("date_col1"), col("date_col2"))),

-- Example 21287
val df = session.createDataFrame(Seq(Array(1, 2, 3))).toDF("id")
 df.filter(expr("id > 2")).show()

--------
|"ID"  |
--------
|3     |
--------

-- Example 21288
val df = session.createDataFrame(Seq((1), (2), (3))).toDF("a")
  df.withColumn("hex_col", hex(col("A"))).select("hex_col").show()
-------------
|"HEX_COL"  |
-------------
|31         |
|32         |
|33         |
-------------

-- Example 21289
val df1 = session.sql("select a, b from table1").
val df2 = session.table(table2)
val dfFilter = df2.filter(functions.in(Seq(col("c1"), col("c2")), df1))

-- Example 21290
val df2 = df.filter(functions.in(Seq(df("c1"), df("c2")), Seq(Seq(1, "a"), Seq(2, "b"))))

-- Example 21291
val df = session.createDataFrame(Seq((5, "a", 10),
                                      (5, "b", 20),
                                      (3, "d", 15),
                                      (3, "e", 40))).toDF("grade", "name", "score")
    val window = Window.partitionBy(col("grade")).orderBy(col("score").desc)
    df.select(last(col("name")).over(window)).show()

---------------------
|"LAST_SCORE_NAME"  |
---------------------
|a                  |
|a                  |
|d                  |
|d                  |
---------------------

-- Example 21292
df.groupBy(df.col("col1")).agg(listagg(df.col("col2"), ",")
    .withinGroup(df.col("col2").asc))

df.select(listagg(df.col("col2"), ",", false))

-- Example 21293
df.groupBy(df.col("col1")).agg(listagg(df.col("col2"), ",")
    .withinGroup(df.col("col2").asc))

df.select(listagg(df.col("col2"), ",", false))

-- Example 21294
df.groupBy(df.col("col1")).agg(listagg(df.col("col2"), ",")
    .withinGroup(df.col("col2").asc))

df.select(listagg(df.col("col2"), ",", false))

-- Example 21295
val df = session.createDataFrame(Seq("java scala python")).toDF("a")
 df.select(locate("scala", col("a")).as("locate")).show()
------------
|"LOCATE"  |
------------
|6         |
------------

-- Example 21296
val df = session.createDataFrame(Seq(("b", "abcd"))).toDF("a", "b")
 df.select(locate(col("a"), col("b"), 1).as("locate")).show()
------------
|"LOCATE"  |
------------
|2         |
------------

-- Example 21297
val df = session.createDataFrame(Seq(100)).toDF("a")
 df.select(log10("a"))).show()
-----------
|"LOG10"  |
-----------
|2.0      |
-----------

-- Example 21298
val df = session.createDataFrame(Seq(100)).toDF("a")
 df.select(log10(col("a"))).show()

-----------
|"LOG10"  |
-----------
|2.0      |
-----------

-- Example 21299
val df = session.createDataFrame(Seq(0.1)).toDF("a")
 df.select(log1p("a").as("log1p")).show()
-----------------------
|"LOG1P"              |
-----------------------
|0.09531017980432493  |
-----------------------

-- Example 21300
val df = session.createDataFrame(Seq(0.1)).toDF("a")
 df.select(log1p(col("a")).as("log1p")).show()
-----------------------
|"LOG1P"              |
-----------------------
|0.09531017980432493  |
-----------------------

-- Example 21301
val df = session.createDataFrame(Seq(1, 3, 10, 1, 3)).toDF("x")
df.select(max("x")).show()

----------------
|"MAX(""X"")"  |
----------------
|10            |
----------------

-- Example 21302
val df = session.createDataFrame(Seq(1, 3, 10, 1, 3)).toDF("x")
df.select(mean("x")).show()

----------------
|"AVG(""X"")"  |
----------------
|3.600000      |
----------------

-- Example 21303
val df = session.createDataFrame(Seq(1, 3, 10, 1, 3)).toDF("x")
df.select(min("x")).show()

----------------
|"MIN(""X"")"  |
----------------
|1             |
----------------

-- Example 21304
months_between("2017-11-14", "2017-07-14")  // returns 4.0
months_between("2017-01-01", "2017-01-10")  // returns 0.29032258
months_between("2017-06-01", "2017-06-16 12:00:00")  // returns -0.5

-- Example 21305
val df = Seq((5, 15), (5, 15), (5, 15), (5, 20)).toDF("grade", "score")
  val window = Window.partitionBy(col("grade")).orderBy(col("score"))
  df.select(ntile(2).over(window).as("ntile")).show()
-----------
|"NTILE"  |
-----------
|1        |
|1        |
|2        |
|2        |
-----------

-- Example 21306
val df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(exponent)")
df.select(lit(2.0).as("base"), col("exponent"), pow(2.0, "exponent").as("result")).show()

--------------------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"            |
--------------------------------------------
|2.0     |0.5         |1.4142135623730951  |
|2.0     |2.0         |4.0                 |
|2.0     |2.5         |5.656854249492381   |
|2.0     |4.0         |16.0                |
--------------------------------------------

-- Example 21307
val df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(exponent)")
df.select(lit(2.0).as("base"), col("exponent"), pow(2.0, col("exponent")).as("result"))
  .show()

--------------------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"            |
--------------------------------------------
|2.0     |0.5         |1.4142135623730951  |
|2.0     |2.0         |4.0                 |
|2.0     |2.5         |5.656854249492381   |
|2.0     |4.0         |16.0                |
--------------------------------------------

-- Example 21308
val df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(base)")
df.select(col("base"), lit(2.0).as("exponent"), pow("base", 2.0).as("result")).show()

----------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"  |
----------------------------------
|0.5     |2.0         |0.25      |
|2.0     |2.0         |4.0       |
|2.5     |2.0         |6.25      |
|4.0     |2.0         |16.0      |
----------------------------------

-- Example 21309
val df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(base)")
df.select(col("base"), lit(2.0).as("exponent"), pow(col("base"), 2.0).as("result")).show()

----------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"  |
----------------------------------
|0.5     |2.0         |0.25      |
|2.0     |2.0         |4.0       |
|2.5     |2.0         |6.25      |
|4.0     |2.0         |16.0      |
----------------------------------

-- Example 21310
val df = session.sql(
  "select * from (values (0.1, 2), (2, 3), (2, 0.5), (2, -1)) as T(base, exponent)")
df.select(col("base"), col("exponent"), pow("base", "exponent").as("result")).show()

----------------------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"              |
----------------------------------------------
|0.1     |2.0         |0.010000000000000002  |
|2.0     |3.0         |8.0                   |
|2.0     |0.5         |1.4142135623730951    |
|2.0     |-1.0        |0.5                   |
----------------------------------------------

-- Example 21311
val df = session.sql(
  "select * from (values (0.1, 2), (2, 3), (2, 0.5), (2, -1)) as T(base, exponent)")
df.select(col("base"), col("exponent"), pow("base", col("exponent")).as("result")).show()

----------------------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"              |
----------------------------------------------
|0.1     |2.0         |0.010000000000000002  |
|2.0     |3.0         |8.0                   |
|2.0     |0.5         |1.4142135623730951    |
|2.0     |-1.0        |0.5                   |
----------------------------------------------

-- Example 21312
val df = session.sql(
  "select * from (values (0.1, 2), (2, 3), (2, 0.5), (2, -1)) as T(base, exponent)")
df.select(col("base"), col("exponent"), pow(col("base"), "exponent").as("result")).show()

----------------------------------------------
|"BASE"  |"EXPONENT"  |"RESULT"              |
----------------------------------------------
|0.1     |2.0         |0.010000000000000002  |
|2.0     |3.0         |8.0                   |
|2.0     |0.5         |1.4142135623730951    |
|2.0     |-1.0        |0.5                   |
----------------------------------------------

-- Example 21313
val df = session.createDataFrame(Seq((1), (2), (3))).toDF("a")
  df.withColumn("randn_with_seed", randn(123L)).select("randn_with_seed").show()
------------------------
|"RANDN_WITH_SEED"     |
------------------------
|5777523539921853504   |
|-8190739547906189845  |
|-1138438814981368515  |
------------------------

-- Example 21314
val df = session.createDataFrame(Seq((1), (2), (3))).toDF("a")
  df.withColumn("randn", randn()).select("randn").show()
------------------------
|"RANDN"               |
------------------------
|-2093909082984812541  |
|-1379817492278593383  |
|-1231198046297539927  |
------------------------

-- Example 21315
val df = session.sql(
  "select * from (values (-3.78), (-2.55), (1.23), (2.55), (3.78)) as T(a)")
df.select(round(col("a"), 1).alias("round")).show()

-----------
|"ROUND"  |
-----------
|-3.8     |
|-2.6     |
|1.2      |
|2.6      |
|3.8      |
-----------

-- Example 21316
val df = session.sql("select * from (values (-3.7), (-2.5), (1.2), (2.5), (3.7)) as T(a)")
df.select(round(col("a")).alias("round")).show()

-----------
|"ROUND"  |
-----------
|-4       |
|-3       |
|1        |
|3        |
|4        |
-----------

-- Example 21317
val df = session.sql(
  "select * from (values (-3.78), (-2.55), (1.23), (2.55), (3.78)) as T(a)")
df.select(round(col("a"), lit(1)).alias("round")).show()

-----------
|"ROUND"  |
-----------
|-3.8     |
|-2.6     |
|1.2      |
|2.6      |
|3.8      |
-----------

-- Example 21318
val df = session.createDataFrame(Seq((1), (2), (3))).toDF("a")
  df.select(shiftleft(col("A"), 1).as("shiftleft")).show()
---------------
|"SHIFTLEFT"  |
---------------
|2            |
|4            |
|6            |
---------------

-- Example 21319
val df = session.createDataFrame(Seq((1), (2), (3))).toDF("a")
  df.select(shiftright(col("A"), 1).as("shiftright")).show()
----------------
|"SHIFTRIGHT"  |
----------------
|0             |
|1             |
|1             |
----------------

-- Example 21320
val df = session.createDataFrame(Seq(Array(1, 2, 3))).toDF("id")
  df.select(size(col("id"))).show()

------------------------
|"ARRAY_SIZE(""ID"")"  |
------------------------
|3                     |
------------------------

-- Example 21321
val df = session.createDataFrame(
               Seq(("many-many-words", "-"), ("hello--hello", "--"))).toDF("V", "D")
df.select(split(col("V"), col("D"))).show()

-- Example 21322
val df = session.createDataFrame(Seq("many-many-words", "hello-hi-hello")).toDF("V")
df.select(split(col("V"), lit("-"))).show()

-- Example 21323
import functions._
val df1 = session.sql("select * from values(1,1,1),(2,2,3) as T(c1,c2,c3)")
val df2 = session.sql("select * from values(2) as T(a)")
df1.select(Column("c1"), toScalar(df2)).show()
df1.filter(Column("c1") < toScalar(df2)).show()

-- Example 21324
val df = session.createDataFrame(Seq("dGVzdA==")).toDF("a")
 df.select(unbase64(col("a")).as("unbase64")).show()
--------------
|"UNBASE64"  |
--------------
|test        |
--------------

-- Example 21325
val df = session.createDataFrame(Seq((31), (32), (33))).toDF("a")
  df.withColumn("unhex_col", unhex(col("A"))).select("unhex_col").show()
---------------
|"UNHEX_COL"  |
---------------
|1            |
|2            |
|3            |
---------------

-- Example 21326
import com.snowflake.snowpark.functions._
session.generator(10, seq4(), uniform(lit(1), lit(5), random())).show()

-- Example 21327
import functions._
df.select(
  when(col("col").is_null, lit(1))
    .when(col("col") === 1, lit(2))
    .otherwise(lit(3))
)

-- Example 21328
import com.snowflake.snowpark.functions.parse_json

// Creates DataFrame from Session.tableFunction
session.tableFunction(tableFunctions.flatten, Map("input" -> parse_json(lit("[1,2]"))))
session.tableFunction(tableFunctions.split_to_table, "split by space", " ")

// DataFrame joins table function
df.join(tableFunctions.flatten, Map("input" -> parse_json(df("a"))))
df.join(tableFunctions.split_to_table, df("a"), ",")

// Invokes any table function including user-defined table function
 df.join(tableFunctions.tableFunction("flatten"), Map("input" -> parse_json(df("a"))))
 session.tableFunction(tableFunctions.tableFunction("split_to_table"), "split by space", " ")

-- Example 21329
import com.snowflake.snowpark.functions._

val df = Seq("""{"a":1, "b": 2}""").toDF("a")
val df1 = df.select(
  parse_json(df("a"))
  .cast(types.MapType(types.StringType, types.IntegerType))
  .as("a"))
df1.select(lit(1), tableFunctions.explode(df1("a")), df1("a")("a")).show()

-- Example 21330
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten(parse_json(df("a")), "path", true, true, "both")
)

-- Example 21331
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten(parse_json(df("a")))
)

-- Example 21332
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(
  tableFunctions.flatten,
  Map("input" -> parse_json(df("a"), "outer" -> lit(true)))
)

session.tableFunction(
  tableFunctions.flatten,
  Map("input" -> parse_json(lit("[1,2]"), "mode" -> lit("array")))
)

-- Example 21333
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(tableFunctions.split_to_table(df("a"), lit(",")))

-- Example 21334
import com.snowflake.snowpark.functions._
import com.snowflake.snowpark.tableFunctions._

df.join(tableFunctions.split_to_table, df("a"), lit(","))
session.tableFunction(
  tableFunctions.split_to_table,
  lit("split by space"),
  lit(" ")
)

-- Example 21335
CASE
    WHEN <condition1> THEN <result1>
  [ WHEN <condition2> THEN <result2> ]
  [ ... ]
  [ ELSE <result3> ]
END

CASE <expr>
    WHEN <value1> THEN <result1>
  [ WHEN <value2> THEN <result2> ]
  [ ... ]
  [ ELSE <result3> ]
END

-- Example 21336
CASE
    WHEN <condition1> THEN <result1>
  [ WHEN <condition2> THEN <result2> ]

-- Example 21337
CASE <expr>
    WHEN <value1> THEN <result1>
  [ WHEN <value2> THEN <result2> ]
  ...

-- Example 21338
SELECT
    column1,
    CASE
        WHEN column1=1 THEN 'one'
        WHEN column1=2 THEN 'two'
        ELSE 'other'
    END AS result
FROM (values(1),(2),(3)) v;

-- Example 21339
+---------+--------+
| COLUMN1 | RESULT |
|---------+--------|
|       1 | one    |
|       2 | two    |
|       3 | other  |
+---------+--------+

-- Example 21340
SELECT
    column1,
    CASE
        WHEN column1=1 THEN 'one'
        WHEN column1=2 THEN 'two'
    END AS result
FROM (values(1),(2),(3)) v;

-- Example 21341
+---------+--------+
| COLUMN1 | RESULT |
|---------+--------|
|       1 | one    |
|       2 | two    |
|       3 | NULL   |
+---------+--------+

-- Example 21342
SELECT
    column1,
    CASE 
        WHEN column1 = 1 THEN 'one'
        WHEN column1 = 2 THEN 'two'
        WHEN column1 IS NULL THEN 'NULL'
        ELSE 'other'
    END AS result
FROM VALUES (1), (2), (NULL);

-- Example 21343
+---------+--------+
| COLUMN1 | RESULT |
|---------+--------|
|       1 | one    |
|       2 | two    |
|    NULL | NULL   |
+---------+--------+

-- Example 21344
SELECT CASE COLLATE('m', 'upper')
    WHEN 'M' THEN TRUE
    ELSE FALSE
END;

-- Example 21345
+----------------------------+
| CASE COLLATE('M', 'UPPER') |
|     WHEN 'M' THEN TRUE     |
|     ELSE FALSE             |
| END                        |
|----------------------------|
| True                       |
+----------------------------+

-- Example 21346
SELECT CASE 'm'
    WHEN COLLATE('M', 'lower') THEN TRUE
    ELSE FALSE
END;

-- Example 21347
+------------------------------------------+
| CASE 'M'                                 |
|     WHEN COLLATE('M', 'LOWER') THEN TRUE |
|     ELSE FALSE                           |
| END                                      |
|------------------------------------------|
| True                                     |
+------------------------------------------+

-- Example 21348
import java.util.stream.Stream;

...

public Stream<OutputRow> process(String v) {
  return Stream.of(new OutputRow(v));
}

...

-- Example 21349
public Stream<OutputRow> process(int number) {
  if (inputNumber < 1) {
    return Stream.empty();
  }
  return Stream.of(new OutputRow(number));
}

-- Example 21350
class OutputRow {

  public String name;
  public int id;

  public OutputRow(String pName, int pId) {
    this.name = pName;
    this.id = pId;
  }

}

