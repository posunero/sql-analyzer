-- Example 30524
public static Column min​(Column col)

-- Example 30525
public static Column mean​(String colName)

-- Example 30526
DataFrame df = session.createDataFrame(
         new Row[] {Row.create(1), Row.create(3), Row.create(10), Row.create(1), Row.create(3)},
         StructType.create(new StructField("x", DataTypes.IntegerType))
 );
 df.select(mean("x")).show();

 ----------------
 |"AVG(""X"")"  |
 ----------------
 |3.600000      |
 ----------------

-- Example 30527
public static Column mean​(Column col)

-- Example 30528
public static Column median​(Column col)

-- Example 30529
public static Column skew​(Column col)

-- Example 30530
public static Column stddev​(Column col)

-- Example 30531
public static Column stddev_samp​(Column col)

-- Example 30532
public static Column stddev_pop​(Column col)

-- Example 30533
public static Column sum​(Column col)

-- Example 30534
public static Column sum​(String colName)

-- Example 30535
public static Column sum_distinct​(Column col)

-- Example 30536
public static Column variance​(Column col)

-- Example 30537
public static Column var_samp​(Column col)

-- Example 30538
public static Column var_pop​(Column col)

-- Example 30539
public static Column approx_percentile​(Column col,
                                       double percentile)

-- Example 30540
public static Column approx_percentile_accumulate​(Column col)

-- Example 30541
public static Column approx_percentile_estimate​(Column col,
                                                double percentile)

-- Example 30542
public static Column approx_percentile_combine​(Column state)

-- Example 30543
public static Column cume_dist()

-- Example 30544
public static Column dense_rank()

-- Example 30545
public static Column lag​(Column col,
                         int offset,
                         Column defaultValue)

-- Example 30546
public static Column lag​(Column col,
                         int offset)

-- Example 30547
public static Column lag​(Column col)

-- Example 30548
public static Column ntile​(Column col)

-- Example 30549
public static Column percent_rank()

-- Example 30550
public static Column rank()

-- Example 30551
public static Column row_number()

-- Example 30552
public static Column coalesce​(Column... cols)

-- Example 30553
public static Column equal_nan​(Column col)

-- Example 30554
public static Column is_null​(Column col)

-- Example 30555
public static Column negate​(Column col)

-- Example 30556
public static Column not​(Column col)

-- Example 30557
public static Column random​(long seed)

-- Example 30558
public static Column random()

-- Example 30559
public static Column bitnot​(Column col)

-- Example 30560
public static Column to_decimal​(Column expr,
                                int precision,
                                int scale)

-- Example 30561
public static Column div0​(Column dividend,
                          Column divisor)

-- Example 30562
public static Column sqrt​(Column col)

-- Example 30563
public static Column abs​(Column col)

-- Example 30564
public static Column acos​(Column col)

-- Example 30565
public static Column asin​(Column col)

-- Example 30566
public static Column atan​(Column col)

-- Example 30567
public static Column atan2​(Column y,
                           Column x)

-- Example 30568
public static Column ceil​(Column col)

-- Example 30569
public static Column floor​(Column col)

-- Example 30570
public static Column cos​(Column col)

-- Example 30571
public static Column cosh​(Column col)

-- Example 30572
public static Column exp​(Column col)

-- Example 30573
public static Column factorial​(Column col)

-- Example 30574
public static Column greatest​(Column... cols)

-- Example 30575
public static Column least​(Column... cols)

-- Example 30576
public static Column log​(Column base,
                         Column a)

-- Example 30577
public static Column pow​(Column l,
                         Column r)

-- Example 30578
public static Column pow​(Column l,
                         String r)

-- Example 30579
DataFrame df = session.sql("select * from (values (0.1, 2), (2, 3), (2, 0.5), (2, -1)) as T(base, exponent)");
 df.select(col("base"), col("exponent"), pow(col("base"), "exponent").as("result")).show();

 ----------------------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"              |
 ----------------------------------------------
 |0.1     |2.0         |0.010000000000000002  |
 |2.0     |3.0         |8.0                   |
 |2.0     |0.5         |1.4142135623730951    |
 |2.0     |-1.0        |0.5                   |
 ----------------------------------------------

-- Example 30580
public static Column pow​(String l,
                         Column r)

-- Example 30581
DataFrame df = session.sql("select * from (values (0.1, 2), (2, 3), (2, 0.5), (2, -1)) as T(base, exponent)");
 df.select(col("base"), col("exponent"), pow("base", col("exponent")).as("result")).show();

 ----------------------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"              |
 ----------------------------------------------
 |0.1     |2.0         |0.010000000000000002  |
 |2.0     |3.0         |8.0                   |
 |2.0     |0.5         |1.4142135623730951    |
 |2.0     |-1.0        |0.5                   |
 ----------------------------------------------

-- Example 30582
public static Column pow​(String l,
                         String r)

-- Example 30583
DataFrame df = session.sql("select * from (values (0.1, 2), (2, 3), (2, 0.5), (2, -1)) as T(base, exponent)");
 df.select(col("base"), col("exponent"), pow("base", "exponent").as("result")).show();

 ----------------------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"              |
 ----------------------------------------------
 |0.1     |2.0         |0.010000000000000002  |
 |2.0     |3.0         |8.0                   |
 |2.0     |0.5         |1.4142135623730951    |
 |2.0     |-1.0        |0.5                   |
 ----------------------------------------------

-- Example 30584
public static Column pow​(Column l,
                         Double r)

-- Example 30585
DataFrame df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(base)");
 df.select(col("base"), lit(2.0).as("exponent"), pow(col("base"), 2.0).as("result")).show();

 ----------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"  |
 ----------------------------------
 |0.5     |2.0         |0.25      |
 |2.0     |2.0         |4.0       |
 |2.5     |2.0         |6.25      |
 |4.0     |2.0         |16.0      |
 ----------------------------------

-- Example 30586
public static Column pow​(String l,
                         Double r)

-- Example 30587
DataFrame df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(base)");
 df.select(col("base"), lit(2.0).as("exponent"), pow("base", 2.0).as("result")).show();

 ----------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"  |
 ----------------------------------
 |0.5     |2.0         |0.25      |
 |2.0     |2.0         |4.0       |
 |2.5     |2.0         |6.25      |
 |4.0     |2.0         |16.0      |
 ----------------------------------

-- Example 30588
public static Column pow​(Double l,
                         Column r)

-- Example 30589
DataFrame df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(exponent)");
 df.select(lit(2.0).as("base"), col("exponent"), pow(2.0, col("exponent")).as("result")).show();

 --------------------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"            |
 --------------------------------------------
 |2.0     |0.5         |1.4142135623730951  |
 |2.0     |2.0         |4.0                 |
 |2.0     |2.5         |5.656854249492381   |
 |2.0     |4.0         |16.0                |
 --------------------------------------------

-- Example 30590
public static Column pow​(Double l,
                         String r)

