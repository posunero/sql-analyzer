-- Example 31060
public String getEncryption()

-- Example 31061
public String getMessage()

-- Example 31062
public class DataFrameReader
extends Object

-- Example 31063
public DataFrame table​(String name)

-- Example 31064
public DataFrameReader schema​(StructType schema)

-- Example 31065
public CopyableDataFrame csv​(String path)

-- Example 31066
String filePath = "@myStage/myFile.csv";
 DataFrame df = session.read().schema(userSchema).csv(filePath);

-- Example 31067
session.read().schema(userSchema).csv(path).copyInto("T1")

-- Example 31068
public CopyableDataFrame json​(String path)

-- Example 31069
DataFrame df = session.read().json(path);

-- Example 31070
session.read().json(path).copyInto("T1")

-- Example 31071
public CopyableDataFrame avro​(String path)

-- Example 31072
session.read().avro(path).where(Functions.sqlExpr("$1:col").gt(Functions.lit(1)));

-- Example 31073
session.read().avro(path).copyInto("T1")

-- Example 31074
public CopyableDataFrame parquet​(String path)

-- Example 31075
session.read().parquet(path).where(Functions.sqlExpr("$1:col").gt(Functions.lit(1)));

-- Example 31076
session.read().parquet(path).copyInto("T1")

-- Example 31077
public CopyableDataFrame orc​(String path)

-- Example 31078
session.read().orc(path).where(Functions.sqlExpr("$1:col").gt(Functions.lit(1)));

-- Example 31079
session.read().orc(path).copyInto("T1")

-- Example 31080
public CopyableDataFrame xml​(String path)

-- Example 31081
session.read().parquet(path).where(Functions
   .sqlExpr("xmlget($1, 'num', 0):\"$\"").gt(Functions.lit(1)));

-- Example 31082
session.read().xml(path).copyInto("T1")

-- Example 31083
public DataFrameReader option​(String key,
                              Object value)

-- Example 31084
session.read().option("field_delimiter", ";").option("skip_header", 1)
   .schema(schema).csv(path);

-- Example 31085
public DataFrameReader options​(Map<String,​Object> configs)

-- Example 31086
Map<String, Object> configs = new HashMap<>();
 configs.put("field_delimiter", ";");
 configs.put("skip_header", 1);
 session.read().options(configs).schema(schema).csv(path);

-- Example 31087
public class CopyableDataFrame
extends DataFrame

-- Example 31088
public void copyInto​(String tableName)

-- Example 31089
session.read().schema(userSchema).csv(myFileStage).copyInto("T");

-- Example 31090
public void copyInto​(String tableName,
                     Column[] transformations)

-- Example 31091
Column[] transformations = {Functions.col("$1"), Functions.length(Functions.col("$1"))};
 session.read().schema(userSchema).csv(myFileStage).copyInto("T", transformations)

-- Example 31092
public void copyInto​(String tableName,
                     Column[] transformations,
                     Map<String,​?> options)

-- Example 31093
Map<String, Object> options = new HashMap<>();
 options.put("FORCE", "TRUE");
 options.put("skip_header", 1);
 Column[] transformations = {Functions.col("$1"), Functions.length(Functions.col("$1"))};
 session.read().schema(userSchema).csv(myFileStage).copyInto("T", transformations, options);

-- Example 31094
public void copyInto​(String tableName,
                     String[] targetColumnNames,
                     Column[] transformations,
                     Map<String,​?> options)

-- Example 31095
Map<String, Object> options = new HashMap<>();
 options.put("FORCE", "TRUE");
 options.put("skip_header", 1);
 Column[] transformations = {Functions.col("$1"), Functions.length(Functions.col("$1"))};
 String[] targetColumnNames = {"A", "A_LEN"};
 session.read().schema(userSchema).csv(myFileStage).copyInto("T", targetColumnNames, transformations, options);

-- Example 31096
public CopyableDataFrame clone()

-- Example 31097
public CopyableDataFrameAsyncActor async()

-- Example 31098
public class WriteFileResult
extends Object

-- Example 31099
public Row[] getRows()

-- Example 31100
public StructType getSchema()

-- Example 31101
public class UserDefinedFunction
extends Object

-- Example 31102
import com.snowflake.snowpark_java.functions;
 import com.snowflake.snowpark_java.types.DataTypes;

 UserDefinedFunction myUdf = Functions.udf(
   (Integer x, Integer y) -> x + y,
   new DataType[]{DataTypes.IntegerType, DataTypes.IntegerType},
   DataTypes.IntegerType
 );
 df.select(myUdf.apply(df.col("col2"), df.col("col2")));

-- Example 31103
public Column apply​(Column... exprs)

-- Example 31104
public class TableFunction
extends Object

-- Example 31105
public TableFunction​(String funcName)

-- Example 31106
public String funcName()

-- Example 31107
public Column call​(Column... args)

-- Example 31108
public Column call​(Map<String,​Column> args)

-- Example 31109
public class RelationalGroupedDataFrame
extends Object

-- Example 31110
public DataFrame agg​(Column... cols)

-- Example 31111
public DataFrame avg​(Column... cols)

-- Example 31112
public DataFrame mean​(Column... cols)

-- Example 31113
public DataFrame sum​(Column... cols)

-- Example 31114
public DataFrame median​(Column... cols)

-- Example 31115
public DataFrame min​(Column... cols)

-- Example 31116
public DataFrame max​(Column... cols)

-- Example 31117
public DataFrame any_value​(Column... cols)

-- Example 31118
public DataFrame count()

-- Example 31119
public DataFrame builtin​(String aggName,
                         Column... cols)

-- Example 31120
df.groupBy("col1").builtin("max", df.col("col2"));

-- Example 31121
public final class Window
extends Object

-- Example 31122
public static WindowSpec partitionBy​(Column... cols)

-- Example 31123
public static WindowSpec orderBy​(Column... cols)

-- Example 31124
public static long unboundedPreceding()

-- Example 31125
public static long unboundedFollowing()

-- Example 31126
public static long currentRow()

