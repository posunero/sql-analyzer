-- Example 31194
public class ArrayType
extends DataType

-- Example 31195
public DataType getElementType()

-- Example 31196
public String toString()

-- Example 31197
public boolean equals​(Object other)

-- Example 31198
public int hashCode()

-- Example 31199
public class BinaryType
extends DataType

-- Example 31200
public class BooleanType
extends DataType

-- Example 31201
public class ByteType
extends DataType

-- Example 31202
public class DateType
extends DataType

-- Example 31203
public class DecimalType
extends DataType

-- Example 31204
public static final int MAX_PRECISION

-- Example 31205
public static final int MAX_SCALE

-- Example 31206
public int getPrecision()

-- Example 31207
public int getScale()

-- Example 31208
public String toString()

-- Example 31209
public boolean equals​(Object other)

-- Example 31210
public int hashCode()

-- Example 31211
public class DoubleType
extends DataType

-- Example 31212
public class FloatType
extends DataType

-- Example 31213
public class GeographyType
extends DataType

-- Example 31214
public class GeometryType
extends DataType

-- Example 31215
public class IntegerType
extends DataType

-- Example 31216
public class LongType
extends DataType

-- Example 31217
public class MapType
extends DataType

-- Example 31218
public DataType getKeyType()

-- Example 31219
public DataType getValueType()

-- Example 31220
public String toString()

-- Example 31221
public boolean equals​(Object other)

-- Example 31222
public int hashCode()

-- Example 31223
public class ShortType
extends DataType

-- Example 31224
public class StringType
extends DataType

-- Example 31225
public class TimestampType
extends DataType

-- Example 31226
public class TimeType
extends DataType

-- Example 31227
public class VariantType
extends DataType

-- Example 31228
public class Geometry
extends Object
implements Serializable

-- Example 31229
public boolean equals​(Object other)

-- Example 31230
public int hashCode()

-- Example 31231
public String toString()

-- Example 31232
public static Geometry fromGeoJSON​(String g)

-- Example 31233
public class GroupingSets
extends Object

-- Example 31234
@SafeVarargs
public static GroupingSets create​(Set<Column>... sets)

-- Example 31235
public class MergeBuilderAsyncActor
extends Object

-- Example 31236
public TypedAsyncJob<MergeResult> collect()

-- Example 31237
public class SessionBuilder
extends Object

-- Example 31238
public SessionBuilder configFile​(String path)

-- Example 31239
public SessionBuilder config​(String key,
                             String value)

-- Example 31240
public SessionBuilder configs​(Map<String,​String> configs)

-- Example 31241
public Session create()

-- Example 31242
public Session getOrCreate()

-- Example 31243
public SessionBuilder appName​(String appName)

-- Example 31244
Session session = Session.builder().appName("myApp").configFile(myConfigFile).create();
 System.out.println(session.getQueryTag().get());
 {"APPNAME":"myApp"}

-- Example 31245
Session session = Session.builder().appName("myApp").configFile(myConfigFile).create();
 System.out.println(session.getQueryTag().get());
 APPNAME=myApp

-- Example 31246
public class SnowflakeFile
extends Object

-- Example 31247
public SnowflakeFile()

-- Example 31248
public static SnowflakeFile newInstance​(String scopedUrl)

-- Example 31249
public static SnowflakeFile newInstance​(String url,
                                        boolean requireScopedUrl)

-- Example 31250
@Deprecated
public static SnowflakeFile newInstanceFromOwnerFileUrl​(String url)

-- Example 31251
public InputStream getInputStream()

-- Example 31252
public Long getSize()

-- Example 31253
public class TableFunctions
extends Object

-- Example 31254
public static TableFunction split_to_table()

-- Example 31255
session.tableFunction(TableFunctions.split_to_table(),
   Functions.lit("split by space"), Functions.lit(" "));

-- Example 31256
public static Column split_to_table​(Column str,
                                    String delimiter)

-- Example 31257
session.tableFunction(TableFunctions.split_to_table(,
   Functions.lit("split by space"), Functions.lit(" ")));

-- Example 31258
public static TableFunction flatten()

-- Example 31259
Map<String, Column> args = new HashMap<>();
 args.put("input", Functions.parse_json(Functions.lit("[1,2]")));
 session.tableFunction(TableFunctions.flatten(), args);

-- Example 31260
public static Column flatten​(Column input,
                             String path,
                             boolean outer,
                             boolean recursive,
                             String mode)

