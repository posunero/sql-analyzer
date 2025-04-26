-- Example 30591
DataFrame df = session.sql("select * from (values (0.5), (2), (2.5), (4)) as T(exponent)");
 df.select(lit(2.0).as("base"), col("exponent"), pow(2.0, "exponent").as("result")).show();

 --------------------------------------------
 |"BASE"  |"EXPONENT"  |"RESULT"            |
 --------------------------------------------
 |2.0     |0.5         |1.4142135623730951  |
 |2.0     |2.0         |4.0                 |
 |2.0     |2.5         |5.656854249492381   |
 |2.0     |4.0         |16.0                |
 --------------------------------------------

-- Example 30592
public static Column round​(Column e,
                           Column scale)

-- Example 30593
DataFrame df = session.sql("select * from (values (-3.78), (-2.55), (1.23), (2.55), (3.78)) as T(a)");
 df.select(round(col("a"), lit(1)).alias("round")).show();

 -----------
 |"ROUND"  |
 -----------
 |-3.8     |
 |-2.6     |
 |1.2      |
 |2.6      |
 |3.8      |
 -----------

-- Example 30594
public static Column round​(Column e)

-- Example 30595
DataFrame df = session.sql("select * from (values (-3.7), (-2.5), (1.2), (2.5), (3.7)) as T(a)");
 df.select(round(col("a")).alias("round")).show();

 -----------
 |"ROUND"  |
 -----------
 |-4       |
 |-3       |
 |1        |
 |3        |
 |4        |
 -----------

-- Example 30596
public static Column round​(Column e,
                           int scale)

-- Example 30597
DataFrame df = session.sql("select * from (values (-3.78), (-2.55), (1.23), (2.55), (3.78)) as T(a)");
 df.select(round(col("a"), 1).alias("round")).show();

 -----------
 |"ROUND"  |
 -----------
 |-3.8     |
 |-2.6     |
 |1.2      |
 |2.6      |
 |3.8      |
 -----------

-- Example 30598
public static Column bitshiftleft​(Column e,
                                  Column numBits)

-- Example 30599
public static Column bitshiftright​(Column e,
                                   Column numBits)

-- Example 30600
public static Column sin​(Column e)

-- Example 30601
public static Column sinh​(Column e)

-- Example 30602
public static Column tan​(Column e)

-- Example 30603
public static Column tanh​(Column e)

-- Example 30604
public static Column degrees​(Column e)

-- Example 30605
public static Column radians​(Column e)

-- Example 30606
public static Column md5​(Column e)

-- Example 30607
public static Column sha1​(Column e)

-- Example 30608
public static Column sha2​(Column e,
                          int numBits)

-- Example 30609
public static Column hash​(Column... cols)

-- Example 30610
public static Column ascii​(Column e)

-- Example 30611
public static Column concat_ws​(Column separator,
                               Column... exprs)

-- Example 30612
public static Column initcap​(Column e)

-- Example 30613
public static Column length​(Column e)

-- Example 30614
public static Column lower​(Column e)

-- Example 30615
public static Column upper​(Column e)

-- Example 30616
public static Column lpad​(Column str,
                          Column len,
                          Column pad)

-- Example 30617
public static Column rpad​(Column str,
                          Column len,
                          Column pad)

-- Example 30618
public static Column ltrim​(Column e,
                           Column trimString)

-- Example 30619
public static Column ltrim​(Column e)

-- Example 30620
public static Column rtrim​(Column e,
                           Column trimString)

-- Example 30621
public static Column rtrim​(Column e)

-- Example 30622
public static Column trim​(Column e,
                          Column trimString)

-- Example 30623
public static Column repeat​(Column str,
                            Column n)

-- Example 30624
public static Column soundex​(Column e)

-- Example 30625
public static Column split​(Column str,
                           Column pattern)

-- Example 30626
public static Column substring​(Column str,
                               Column pos,
                               Column len)

-- Example 30627
public static Column any_value​(Column e)

-- Example 30628
public static Column translate​(Column src,
                               Column matchingString,
                               Column replaceString)

-- Example 30629
public static Column contains​(Column col,
                              Column str)

-- Example 30630
public static Column startswith​(Column col,
                                Column str)

-- Example 30631
public static Column chr​(Column col)

-- Example 30632
public static Column add_months​(Column startDate,
                                Column numMonths)

-- Example 30633
public static Column current_date()

-- Example 30634
public static Column current_timestamp()

-- Example 30635
public static Column current_region()

-- Example 30636
public static Column current_time()

-- Example 30637
public static Column current_version()

-- Example 30638
public static Column current_account()

-- Example 30639
public static Column current_role()

-- Example 30640
public static Column current_available_roles()

-- Example 30641
public static Column current_session()

-- Example 30642
public static Column current_statement()

-- Example 30643
public static Column current_user()

-- Example 30644
public static Column current_database()

-- Example 30645
public static Column current_schema()

-- Example 30646
public static Column current_schemas()

-- Example 30647
public static Column current_warehouse()

-- Example 30648
public static Column sysdate()

-- Example 30649
public static Column convert_timezone​(Column sourceTimeZone,
                                      Column targetTimeZone,
                                      Column sourceTimestampNTZ)

-- Example 30650
df.select(Functions.convert_timezone(Functions.lit("America/Los_Angeles"),
 Functions.lit("America/New_York"), df.col("time")));

-- Example 30651
public static Column convert_timezone​(Column targetTimeZone,
                                      Column sourceTimestamp)

-- Example 30652
df.select(Functions.convert_timezone(Functions.lit("America/New_York"), df.col("time")));

-- Example 30653
public static Column year​(Column e)

-- Example 30654
public static Column quarter​(Column e)

-- Example 30655
public static Column month​(Column e)

-- Example 30656
public static Column dayofweek​(Column e)

-- Example 30657
public static Column dayofmonth​(Column e)

