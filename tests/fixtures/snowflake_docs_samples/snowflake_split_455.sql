-- Example 30457
public Column gt​(Column other)

-- Example 30458
public Column lt​(Column other)

-- Example 30459
public Column leq​(Column other)

-- Example 30460
public Column geq​(Column other)

-- Example 30461
public Column equal_null​(Column other)

-- Example 30462
public Column equal_nan()

-- Example 30463
public Column is_null()

-- Example 30464
public Column isNull()

-- Example 30465
public Column is_not_null()

-- Example 30466
public Column or​(Column other)

-- Example 30467
public Column and​(Column other)

-- Example 30468
public Column between​(Column lowerBound,
                      Column upperBound)

-- Example 30469
public Column plus​(Column other)

-- Example 30470
public Column minus​(Column other)

-- Example 30471
public Column multiply​(Column other)

-- Example 30472
public Column divide​(Column other)

-- Example 30473
public Column mod​(Column other)

-- Example 30474
public Column cast​(DataType to)

-- Example 30475
public Column desc()

-- Example 30476
public Column desc_nulls_first()

-- Example 30477
public Column desc_nulls_last()

-- Example 30478
public Column asc()

-- Example 30479
public Column asc_nulls_first()

-- Example 30480
public Column asc_nulls_last()

-- Example 30481
public Column bitor​(Column other)

-- Example 30482
public Column bitand​(Column other)

-- Example 30483
public Column bitxor​(Column other)

-- Example 30484
public Column like​(Column pattern)

-- Example 30485
public Column regexp​(Column pattern)

-- Example 30486
public Column collate​(String collateSpec)

-- Example 30487
public Column over()

-- Example 30488
public Column over​(WindowSpec windowSpec)

-- Example 30489
public Column withinGroup​(Column... cols)

-- Example 30490
df.groupBy(df.col("col1")).agg(Functions.listagg(df.col("col2"), ",")
      .withinGroup(df.col("col2").asc()))

-- Example 30491
public Column in​(Object... values)

-- Example 30492
df.filter(df.col("a").in(1, 2, 3))

-- Example 30493
public Column in​(DataFrame df)

-- Example 30494
DataFrame df1 = session.table(table1);
 DataFrame df2 = session.table(table2);
 df2.filter(df1.col("a").in(df1));

-- Example 30495
public String toString()

-- Example 30496
public final class Functions
extends Object

-- Example 30497
public static Column col​(String name)

-- Example 30498
public static Column col​(DataFrame df)

-- Example 30499
DataFrame df1 = session.sql("select * from values(1,1,1),(2,2,3) as T(c1, c2, c3)");
 DataFrame df2 = session.sql("select * from values(2) as T(a)");
 df1.select(Functions.col("c1"), Functions.col(df2)).show();

-- Example 30500
public static Column toScalar​(DataFrame df)

-- Example 30501
DataFrame df1 = session.sql("select * from values(1,1,1),(2,2,3) as T(c1, c2, c3)");
 DataFrame df2 = session.sql("select * from values(2) as T(a)");
 df1.select(Functions.col("c1"), Functions.toScalar(df2)).show();

-- Example 30502
public static Column lit​(Object literal)

-- Example 30503
public static Column lead​(Column col,
                          int offset,
                          Column defaultValue)

-- Example 30504
public static Column lead​(Column col,
                          int offset)

-- Example 30505
public static Column lead​(Column col)

-- Example 30506
public static Column sqlExpr​(String sqlText)

-- Example 30507
public static Column approx_count_distinct​(Column col)

-- Example 30508
public static Column avg​(Column col)

-- Example 30509
public static Column corr​(Column col1,
                          Column col2)

-- Example 30510
public static Column count​(Column col)

-- Example 30511
public static Column countDistinct​(String first,
                                   String... remaining)

-- Example 30512
public static Column countDistinct​(Column first,
                                   Column... remaining)

-- Example 30513
public static Column count_distinct​(Column first,
                                    Column... remaining)

-- Example 30514
public static Column covar_pop​(Column col1,
                               Column col2)

-- Example 30515
public static Column covar_samp​(Column col1,
                                Column col2)

-- Example 30516
public static Column grouping​(Column col)

-- Example 30517
public static Column grouping_id​(Column... cols)

-- Example 30518
public static Column kurtosis​(Column col)

-- Example 30519
public static Column max​(String colName)

-- Example 30520
DataFrame df = session.createDataFrame(
         new Row[] {Row.create(1), Row.create(3), Row.create(10), Row.create(1), Row.create(3)},
         StructType.create(new StructField("x", DataTypes.IntegerType))
 );
 df.select(max("x")).show();

 ----------------
 |"MAX(""X"")"  |
 ----------------
 |10            |
 ----------------

-- Example 30521
public static Column max​(Column col)

-- Example 30522
public static Column min​(String colName)

-- Example 30523
DataFrame df = session.createDataFrame(
         new Row[] {Row.create(1), Row.create(3), Row.create(10), Row.create(1), Row.create(3)},
         StructType.create(new StructField("x", DataTypes.IntegerType))
 );
 df.select(min("x")).show();

 ----------------
 |"MIN(""X"")"  |
 ----------------
 |1             |
 ----------------

