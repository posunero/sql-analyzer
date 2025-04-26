-- Example 31261
df.join(TableFunctions.flatten(
   Functions.parse_json(df.col("col")), "path", true, true, "both"));

-- Example 31262
public static Column flatten​(Column input)

-- Example 31263
df.join(TableFunctions.flatten(
   Functions.parse_json(df.col("col"))));

-- Example 31264
public static Column explode​(Column input)

-- Example 31265
DataFrame df =
   getSession()
     .createDataFrame(
       new Row[] {Row.create("{\"a\":1, \"b\":2}")},
       StructType.create(new StructField("col", DataTypes.StringType)));
 DataFrame df1 =
   df.select(
     Functions.parse_json(df.col("col"))
       .cast(DataTypes.createMapType(DataTypes.StringType, DataTypes.IntegerType))
       .as("col"));
 df1.select(TableFunctions.explode(df1.col("col"))).show()

-- Example 31266
public class UDTFRegistration
extends Object

-- Example 31267
import java.util.stream.Stream;
 import com.snowflake.snowpark_java.types.*;
 import com.snowflake.snowpark_java.udtf.*;

 class MyRangeUdtf implements JavaUDTF2<Integer, Integer> {
   public StructType outputSchema() {
     return StructType.create(new StructField("C1", DataTypes.IntegerType));
   }

   // Because the process() method in this example does not pass in Map arguments,
   // implementing the inputSchema() method is optional.
   public StructType inputSchema() {
     return StructType.create(
             new StructField("start_value", DataTypes.IntegerType),
             new StructField("value_count", DataTypes.IntegerType));
   }

   public Stream<Row> endPartition() {
     return Stream.empty();
   }

   public Stream<Row> process(Integer start, Integer count) {
     Stream.Builder<Row> builder = Stream.builder();
     for (int i = start; i < start + count ; i++) {
       builder.add(Row.create(i));
     }
     return builder.build();
   }
 }

-- Example 31268
// Use the MyRangeUdtf defined in previous example.
 TableFunction tableFunction = session.udtf().registerTemporary("myUdtf", new MyRangeUdtf());
 session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 31269
// Use the MyRangeUdtf defined in previous example.
 TableFunction tableFunction = session.udtf().registerPermanent("myUdtf", new MyRangeUdtf(), "@myStage");
 session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 31270
// Use the MyRangeUdtf defined in previous example.
 TableFunction tableFunction = session.udtf().registerTemporary(new MyRangeUdtf());
 session.tableFunction(tableFunction, Functions.lit(10), Functions.lit(5)).show();

-- Example 31271
public TableFunction registerTemporary​(JavaUDTF udtf)

-- Example 31272
public TableFunction registerTemporary​(String funcName,
                                       JavaUDTF udtf)

-- Example 31273
public TableFunction registerPermanent​(String funcName,
                                       JavaUDTF udtf,
                                       String stageLocation)

-- Example 31274
@FunctionalInterface
public interface JavaSProc0<RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31275
RT call​(Session session)

-- Example 31276
@FunctionalInterface
public interface JavaSProc1<A1,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31277
RT call​(Session session,
        A1 arg1)

-- Example 31278
@FunctionalInterface
public interface JavaSProc10<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31279
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10)

-- Example 31280
@FunctionalInterface
public interface JavaSProc11<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31281
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11)

-- Example 31282
@FunctionalInterface
public interface JavaSProc12<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31283
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12)

-- Example 31284
@FunctionalInterface
public interface JavaSProc13<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31285
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13)

-- Example 31286
@FunctionalInterface
public interface JavaSProc14<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31287
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14)

-- Example 31288
@FunctionalInterface
public interface JavaSProc15<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31289
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15)

-- Example 31290
@FunctionalInterface
public interface JavaSProc16<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31291
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15,
        A16 arg16)

-- Example 31292
@FunctionalInterface
public interface JavaSProc17<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31293
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15,
        A16 arg16,
        A17 arg17)

-- Example 31294
@FunctionalInterface
public interface JavaSProc18<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​A18,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31295
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15,
        A16 arg16,
        A17 arg17,
        A18 arg18)

-- Example 31296
@FunctionalInterface
public interface JavaSProc19<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​A18,​A19,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31297
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15,
        A16 arg16,
        A17 arg17,
        A18 arg18,
        A19 arg19)

-- Example 31298
@FunctionalInterface
public interface JavaSProc2<A1,​A2,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31299
RT call​(Session session,
        A1 arg1,
        A2 arg2)

-- Example 31300
@FunctionalInterface
public interface JavaSProc20<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​A18,​A19,​A20,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31301
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15,
        A16 arg16,
        A17 arg17,
        A18 arg18,
        A19 arg19,
        A20 arg20)

-- Example 31302
@FunctionalInterface
public interface JavaSProc21<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​A13,​A14,​A15,​A16,​A17,​A18,​A19,​A20,​A21,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31303
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12,
        A13 arg13,
        A14 arg14,
        A15 arg15,
        A16 arg16,
        A17 arg17,
        A18 arg18,
        A19 arg19,
        A20 arg20,
        A21 arg21)

-- Example 31304
@FunctionalInterface
public interface JavaSProc3<A1,​A2,​A3,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31305
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3)

-- Example 31306
@FunctionalInterface
public interface JavaSProc4<A1,​A2,​A3,​A4,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31307
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4)

-- Example 31308
@FunctionalInterface
public interface JavaSProc5<A1,​A2,​A3,​A4,​A5,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31309
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5)

-- Example 31310
@FunctionalInterface
public interface JavaSProc6<A1,​A2,​A3,​A4,​A5,​A6,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31311
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6)

-- Example 31312
@FunctionalInterface
public interface JavaSProc7<A1,​A2,​A3,​A4,​A5,​A6,​A7,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31313
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7)

-- Example 31314
@FunctionalInterface
public interface JavaSProc8<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31315
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8)

-- Example 31316
@FunctionalInterface
public interface JavaSProc9<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​RT>
extends com.snowflake.snowpark_java.internal.JavaSProc

-- Example 31317
RT call​(Session session,
        A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9)

-- Example 31318
@FunctionalInterface
public interface JavaUDF0<RT>
extends com.snowflake.snowpark_java.internal.JavaUDF

-- Example 31319
RT call()

-- Example 31320
@FunctionalInterface
public interface JavaUDF1<A1,​RT>
extends com.snowflake.snowpark_java.internal.JavaUDF

-- Example 31321
RT call​(A1 arg1)

-- Example 31322
@FunctionalInterface
public interface JavaUDF10<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​RT>
extends com.snowflake.snowpark_java.internal.JavaUDF

-- Example 31323
RT call​(A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10)

-- Example 31324
@FunctionalInterface
public interface JavaUDF11<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​RT>
extends com.snowflake.snowpark_java.internal.JavaUDF

-- Example 31325
RT call​(A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11)

-- Example 31326
@FunctionalInterface
public interface JavaUDF12<A1,​A2,​A3,​A4,​A5,​A6,​A7,​A8,​A9,​A10,​A11,​A12,​RT>
extends com.snowflake.snowpark_java.internal.JavaUDF

-- Example 31327
RT call​(A1 arg1,
        A2 arg2,
        A3 arg3,
        A4 arg4,
        A5 arg5,
        A6 arg6,
        A7 arg7,
        A8 arg8,
        A9 arg9,
        A10 arg10,
        A11 arg11,
        A12 arg12)

