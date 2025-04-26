-- Example 30993
public MergeBuilder updateColumn​(Map<String,​Column> assignments)

-- Example 30994
Map<String, Column> assignments = new HashMap<>();
 assignments.put("col_1", df.col("col_b"));
 session.table("table").merge(df, Functions.col("col_1").equal_to(df.col("col_a")))
   .whenMatched(Functions.col("col_2").equal_to(Functions.lit(true)))
   .update(assignments).collect();

-- Example 30995
public MergeBuilder delete()

-- Example 30996
session.table("table").merge(df, Functions.col("col_1").equal_to(df.col("col_a")))
   .whenMatched(Functions.col("col_2").equal_to(Functions.lit(true)))
   .delete().collect();

-- Example 30997
public class NotMatchedClauseBuilder
extends Object

-- Example 30998
public MergeBuilder insert​(Column[] values)

-- Example 30999
session.table("tableName").merge(df, Functions.col("col_1").equal_to(df.col("col_a")))
   .whenNotMatched().insert(new Column[]{df.col("col_b"), Functions.lit("c"), Functions.lit(true)})
   .collect();

-- Example 31000
public MergeBuilder insert​(Map<Column,​Column> assignments)

-- Example 31001
Map<Column, Column> assignments = new HashMap<>();
 assignments.put(Functions.col("col_1"), df.col("col_b"));
 session.table("tableName").merge(df, Functions.col("col_1").equal_to(df.col("col_a")))
   .whenNotMatched(df.col("col_a").equal_to(Functions.lit(3)))
   .insert(assignments).collect();

-- Example 31002
public MergeBuilder insertRow​(Map<String,​Column> assignments)

-- Example 31003
Map<String, Column> assignments = new HashMap<>();
 assignments.put("col_1", df.col("col_b"));
 session.table("tableName").merge(df, Functions.col("col_1").equal_to(df.col("col_a")))
   .whenNotMatched(df.col("col_a").equal_to(Functions.lit(3)))
   .insertRow(assignments).collect();

-- Example 31004
public class MergeResult
extends Object

-- Example 31005
public long getRowsInserted()

-- Example 31006
public long getRowsUpdated()

-- Example 31007
public long getRowsDeleted()

-- Example 31008
public class DataFrameWriter
extends Object

-- Example 31009
public DataFrameWriter option​(String key,
                              Object value)

-- Example 31010
df.write().option("compression", "none").csv("@myStage/prefix");

-- Example 31011
public DataFrameWriter options​(Map<String,​Object> configs)

-- Example 31012
Map<String, Object> configs = new HashMap<>();
 configs.put("compression", "none");
 df.write().options(configs).csv("@myStage/prefix");

-- Example 31013
public WriteFileResult csv​(String path)

-- Example 31014
df.write().option("compression", "none").csv("@myStage/prefix");

-- Example 31015
public WriteFileResult json​(String path)

-- Example 31016
df.write().option("compression", "none").json("@myStage/prefix");

-- Example 31017
public WriteFileResult parquet​(String path)

-- Example 31018
df.write().option("compression", "lzo").parquet("@myStage/prefix");

-- Example 31019
public void saveAsTable​(String tableName)

-- Example 31020
df.write().saveAsTable("db1.public_schema.table1");

-- Example 31021
public void saveAsTable​(String[] multipartIdentifier)

-- Example 31022
df.write().saveAsTable(new String[]{"db_name", "schema_name", "table_name"})

-- Example 31023
public DataFrameWriter mode​(String saveMode)

-- Example 31024
public DataFrameWriter mode​(SaveMode saveMode)

-- Example 31025
public DataFrameWriterAsyncActor async()

-- Example 31026
public enum SaveMode
extends Enum<SaveMode>

-- Example 31027
public static final SaveMode Append

-- Example 31028
public static final SaveMode Overwrite

-- Example 31029
public static final SaveMode ErrorIfExists

-- Example 31030
public static final SaveMode Ignore

-- Example 31031
public static SaveMode[] values()

-- Example 31032
for (SaveMode c : SaveMode.values())
    System.out.println(c);

-- Example 31033
public static SaveMode valueOf​(String name)

-- Example 31034
public class HasCachedResult
extends DataFrame

-- Example 31035
public class FileOperation
extends Object

-- Example 31036
public PutResult[] put​(String localFileName,
                       String stageLocation,
                       Map<String,​String> options)

-- Example 31037
Map<String, String> options = new HashMap<>();
 options.put("AUTO_COMPRESS", "FALSE");
 session.file().put("file://file_path", "@stage_name", options);

-- Example 31038
public PutResult[] put​(String localFileName,
                       String stageLocation)

-- Example 31039
session.file().put("file://file_path", "@stage_name");

-- Example 31040
public GetResult[] get​(String stageLocation,
                       String targetDirectory,
                       Map<String,​String> options)

-- Example 31041
Map<String, String> options = new HashMap<>();
 options.put("PATTERN", "'.*.csv'");
 session.file().get("@stage_name/", "file:///tmp/", options);

-- Example 31042
public GetResult[] get​(String stageLocation,
                       String targetDirectory)

-- Example 31043
getSession().file().get("@stage_name/", "file:///tmp/");

-- Example 31044
public void uploadStream​(String stageLocation,
                         InputStream inputStream,
                         boolean compress)

-- Example 31045
public InputStream downloadStream​(String stageLocation,
                                  boolean decompress)

-- Example 31046
public class PutResult
extends Object

-- Example 31047
public String getSourceFileName()

-- Example 31048
public String getTargetFileName()

-- Example 31049
public long getSourceSizeBytes()

-- Example 31050
public long getTargetSizeBytes()

-- Example 31051
public String getSourceCompression()

-- Example 31052
public String getTargetCompression()

-- Example 31053
public String getStatus()

-- Example 31054
public String getEncryption()

-- Example 31055
public String getMessage()

-- Example 31056
public class GetResult
extends Object

-- Example 31057
public String getFileName()

-- Example 31058
public long getSizeBytes()

-- Example 31059
public String getStatus()

