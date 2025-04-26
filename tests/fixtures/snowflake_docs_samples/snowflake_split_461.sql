-- Example 30859
public static Column log1p​(Column col)

-- Example 30860
DataFrame df = getSession().sql("select * from values (0.1) as T(a)");
 df.select(Functions.log1p(df.col("a")).as("log1p")).show();
 -----------------------
 |"LOG1P"              |
 -----------------------
 |0.09531017980432493  |
 -----------------------

-- Example 30861
public static Column log1p​(String s)

-- Example 30862
DataFrame df = getSession().sql("select * from values (0.1) as T(a)");
 df.select(Functions.log1p("a").as("log1p")).show();
 -----------------------
 |"LOG1P"              |
 -----------------------
 |0.09531017980432493  |
 -----------------------

-- Example 30863
public static Column base64​(Column c)

-- Example 30864
DataFrame df = getSession().sql("select * from values ('test') as T(a)");
 df.select(Functions.base64(Functions.col("a")).as("base64")).show();
 ------------
 |"BASE64"  |
 ------------
 |dGVzdA==  |
 ------------

-- Example 30865
public static Column unbase64​(Column c)

-- Example 30866
DataFrame df = getSession().sql("select * from values ('dGVzdA==') as T(a)");
 df.select(Functions.unbase64(Functions.col("a")).as("unbase64")).show();
 --------------
 |"UNBASE64"  |
 --------------
 |test        |
 --------------

-- Example 30867
public static Column locate​(Column substr,
                            Column str,
                            int pos)

-- Example 30868
DataFrame df = getSession().sql("select * from values ('scala', 'java scala python'), \n " +
             "('b', 'abcd') as T(a,b)");
 df.select(Functions.locate(Functions.col("a"), Functions.col("b"), 1).as("locate")).show();
 ------------
 |"LOCATE"  |
 ------------
 |6         |
 |2         |
 ------------

-- Example 30869
public static Column locate​(String substr,
                            Column str)

-- Example 30870
DataFrame df = getSession().sql("select * from values ('abcd') as T(s)");
 df.select(Functions.locate("b", Functions.col("s")).as("locate")).show();
 ------------
 |"LOCATE"  |
 ------------
 |2         |
 ------------

-- Example 30871
public static Column ntile​(int n)

-- Example 30872
DataFrame df = getSession().sql("select * from values(1,2),(1,2),(2,1),(2,2),(2,2) as T(x,y)");
 df.select(Functions.ntile(4).over(Window.partitionBy(df.col("x")).orderBy(df.col("y"))).as("ntile")).show();
 -----------
 |"NTILE"  |
 -----------
 |1        |
 |2        |
 |3        |
 |1        |
 |2        |
 -----------

-- Example 30873
public static Column randn()

-- Example 30874
DataFrame df = getSession().sql("select * from values(1),(2),(3) as T(a)");
 df.withColumn("randn",Functions.randn()).select("randn").show();
 ------------------------
 |"RANDN"               |
 ------------------------
 |6799378361097866000   |
 |-7280487148628086605  |
 |775606662514393461    |
 ------------------------

-- Example 30875
public static Column randn​(long seed)

-- Example 30876
DataFrame df = getSession().sql("select * from values(1),(2),(3) as T(a)");
 df.withColumn("randn_with_seed",Functions.randn(123l)).select("randn_with_seed").show();
 ------------------------
 |"RANDN_WITH_SEED"     |
 ------------------------
 |5777523539921853504   |
 |-8190739547906189845  |
 |-1138438814981368515  |
 ------------------------

-- Example 30877
public static Column shiftleft​(Column c,
                               int numBits)

-- Example 30878
DataFrame df = getSession().sql("select * from values(1),(2),(3) as T(a)");
 df.select(Functions.shiftleft(Functions.col("a"), 1).as("shiftleft")).show();
 ---------------
 |"SHIFTLEFT"  |
 ---------------
 |2            |
 |4            |
 |6            |
 ---------------

-- Example 30879
public static Column shiftright​(Column c,
                                int numBits)

-- Example 30880
DataFrame df = getSession().sql("select * from values(1),(2),(3) as T(a)");
 df.select(Functions.shiftright(Functions.col("a"), 1).as("shiftright")).show();
 ---------------
 |"SHIFTRIGHT"  |
 ---------------
 |0            |
 |1            |
 |1            |
 ---------------

-- Example 30881
public static Column hex​(Column c)

-- Example 30882
DataFrame df = getSession().sql("select * from values(1),(2),(3) as T(a)");
 df.select(Functions.hex(Functions.col("a")).as("hex")).show();
 ---------
 |"HEX"  |
 ---------
 |31     |
 |32     |
 |33     |
 ---------

-- Example 30883
public static Column unhex​(Column c)

-- Example 30884
DataFrame df = getSession().sql("select * from values(31),(32),(33) as T(a)");
 df.select(Functions.unhex(Functions.col("a")).as("unhex")).show();
 -----------
 |"UNHEX"  |
 -----------
 |1        |
 |2        |
 |3        |
 -----------

-- Example 30885
public static Column callUDF​(String udfName,
                             Column... cols)

-- Example 30886
public static UserDefinedFunction udf​(JavaUDF0<?> func,
                                      DataType output)

-- Example 30887
public static UserDefinedFunction udf​(JavaUDF1<?,​?> func,
                                      DataType input,
                                      DataType output)

-- Example 30888
public static UserDefinedFunction udf​(JavaUDF2<?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30889
public static UserDefinedFunction udf​(JavaUDF3<?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30890
public static UserDefinedFunction udf​(JavaUDF4<?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30891
public static UserDefinedFunction udf​(JavaUDF5<?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30892
public static UserDefinedFunction udf​(JavaUDF6<?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30893
public static UserDefinedFunction udf​(JavaUDF7<?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30894
public static UserDefinedFunction udf​(JavaUDF8<?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30895
public static UserDefinedFunction udf​(JavaUDF9<?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30896
public static UserDefinedFunction udf​(JavaUDF10<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30897
public static UserDefinedFunction udf​(JavaUDF11<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30898
public static UserDefinedFunction udf​(JavaUDF12<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30899
public static UserDefinedFunction udf​(JavaUDF13<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30900
public static UserDefinedFunction udf​(JavaUDF14<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30901
public static UserDefinedFunction udf​(JavaUDF15<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30902
public static UserDefinedFunction udf​(JavaUDF16<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30903
public static UserDefinedFunction udf​(JavaUDF17<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30904
public static UserDefinedFunction udf​(JavaUDF18<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30905
public static UserDefinedFunction udf​(JavaUDF19<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30906
public static UserDefinedFunction udf​(JavaUDF20<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30907
public static UserDefinedFunction udf​(JavaUDF21<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30908
public static UserDefinedFunction udf​(JavaUDF22<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                      DataType[] input,
                                      DataType output)

-- Example 30909
public class Row
extends Object
implements Serializable, Cloneable

-- Example 30910
public Row​(Object[] values)

-- Example 30911
public List<Object> toList()

-- Example 30912
public int size()

-- Example 30913
public Row clone()

-- Example 30914
public boolean equals​(Object other)

-- Example 30915
public int hashCode()

-- Example 30916
public Object get​(int index)

-- Example 30917
public boolean isNullAt​(int index)

-- Example 30918
public boolean getBoolean​(int index)

-- Example 30919
public byte getByte​(int index)

-- Example 30920
public short getShort​(int index)

-- Example 30921
public int getInt​(int index)

-- Example 30922
public long getLong​(int index)

-- Example 30923
public float getFloat​(int index)

-- Example 30924
public double getDouble​(int index)

-- Example 30925
public String getString​(int index)

