-- Example 31127
public static WindowSpec rowsBetween​(long start,
                                     long end)

-- Example 31128
public static WindowSpec rangeBetween​(long start,
                                      long end)

-- Example 31129
public class WindowSpec
extends Object

-- Example 31130
public WindowSpec partitionBy​(Column... cols)

-- Example 31131
public WindowSpec orderBy​(Column... cols)

-- Example 31132
public WindowSpec rowsBetween​(long start,
                              long end)

-- Example 31133
public WindowSpec rangeBetween​(long start,
                               long end)

-- Example 31134
public class CloudProviderToken
extends Object

-- Example 31135
public CloudProviderToken​(String id,
                          String key,
                          String token)

-- Example 31136
public String getAccessKeyId()

-- Example 31137
public String getSecretAccessKey()

-- Example 31138
public String getToken()

-- Example 31139
public class CaseExpr
extends Column

-- Example 31140
public CaseExpr when​(Column condition,
                     Column value)

-- Example 31141
public Column otherwise​(Column value)

-- Example 31142
public class ColumnIdentifier
extends Object
implements Cloneable

-- Example 31143
public ColumnIdentifier​(String name)

-- Example 31144
public String name()

-- Example 31145
public String quotedName()

-- Example 31146
public boolean equals​(Object other)

-- Example 31147
public int hashCode()

-- Example 31148
public String toString()

-- Example 31149
public ColumnIdentifier clone()

-- Example 31150
public class DataFrameAsyncActor
extends Object

-- Example 31151
protected final com.snowflake.snowpark.Session session

-- Example 31152
public TypedAsyncJob<Row[]> collect()

-- Example 31153
public TypedAsyncJob<Iterator<Row>> toLocalIterator()

-- Example 31154
public TypedAsyncJob<Long> count()

-- Example 31155
public class CopyableDataFrameAsyncActor
extends DataFrameAsyncActor

-- Example 31156
public TypedAsyncJob<Void> copyInto​(String tableName)

-- Example 31157
public TypedAsyncJob<Void> copyInto​(String tableName,
                                    Column[] transformations)

-- Example 31158
public TypedAsyncJob<Void> copyInto​(String tableName,
                                    Column[] transformations,
                                    Map<String,​?> options)

-- Example 31159
public TypedAsyncJob<Void> copyInto​(String tableName,
                                    String[] targetColumnNames,
                                    Column[] transformations,
                                    Map<String,​?> options)

-- Example 31160
public class UpdatableAsyncActor
extends DataFrameAsyncActor

-- Example 31161
public TypedAsyncJob<UpdateResult> update​(Map<Column,​Column> assignments)

-- Example 31162
public TypedAsyncJob<UpdateResult> updateColumn​(Map<String,​Column> assignments)

-- Example 31163
public TypedAsyncJob<UpdateResult> update​(Map<Column,​Column> assignments,
                                          Column condition)

-- Example 31164
public TypedAsyncJob<UpdateResult> updateColumn​(Map<String,​Column> assignments,
                                                Column condition)

-- Example 31165
public TypedAsyncJob<UpdateResult> update​(Map<Column,​Column> assignments,
                                          Column condition,
                                          DataFrame sourceData)

-- Example 31166
public TypedAsyncJob<UpdateResult> updateColumn​(Map<String,​Column> assignments,
                                                Column condition,
                                                DataFrame sourceData)

-- Example 31167
public TypedAsyncJob<DeleteResult> delete()

-- Example 31168
public TypedAsyncJob<DeleteResult> delete​(Column condition)

-- Example 31169
public TypedAsyncJob<DeleteResult> delete​(Column condition,
                                          DataFrame sourceData)

-- Example 31170
public class DataFrameNaFunctions
extends Object

-- Example 31171
public DataFrame drop​(int minNonNullsPerRow,
                      String[] cols)

-- Example 31172
public DataFrame fill​(Map<String,​?> valueMap)

-- Example 31173
public DataFrame replace​(String colName,
                         Map<?,​?> replacement)

-- Example 31174
public class DataFrameStatFunctions
extends Object

-- Example 31175
public Optional<Double> corr​(String col1,
                             String col2)

-- Example 31176
public Optional<Double> cov​(String col1,
                            String col2)

-- Example 31177
public Optional<Double>[] approxQuantile​(String col,
                                         double[] percentile)

-- Example 31178
public Optional<Double>[][] approxQuantile​(String[] cols,
                                           double[] percentile)

-- Example 31179
public DataFrame crosstab​(String col1,
                          String col2)

-- Example 31180
public DataFrame sampleBy​(Column col,
                          Map<?,​Double> fractions)

-- Example 31181
public DataFrame sampleBy​(String colName,
                          Map<?,​Double> fractions)

-- Example 31182
public class DataFrameWriterAsyncActor
extends Object

-- Example 31183
public TypedAsyncJob<Void> saveAsTable​(String tableName)

-- Example 31184
public TypedAsyncJob<Void> saveAsTable​(String[] multipartIdentifier)

-- Example 31185
public TypedAsyncJob<WriteFileResult> csv​(String path)

-- Example 31186
public TypedAsyncJob<WriteFileResult> json​(String path)

-- Example 31187
public TypedAsyncJob<WriteFileResult> parquet​(String path)

-- Example 31188
public abstract class DataType
extends Object
implements Serializable

-- Example 31189
public DataType()

-- Example 31190
public String typeName()

-- Example 31191
public String toString()

-- Example 31192
public boolean equals​(Object other)

-- Example 31193
public int hashCode()

