-- Example 30926
public byte[] getBinary​(int index)

-- Example 30927
public Date getDate​(int index)

-- Example 30928
public Time getTime​(int index)

-- Example 30929
public Timestamp getTimestamp​(int index)

-- Example 30930
public BigDecimal getDecimal​(int index)

-- Example 30931
public Variant getVariant​(int index)

-- Example 30932
public Geography getGeography​(int index)

-- Example 30933
public Geometry getGeometry​(int index)

-- Example 30934
public List<Variant> getListOfVariant​(int index)

-- Example 30935
public Map<String,​Variant> getMapOfVariant​(int index)

-- Example 30936
public List<?> getList​(int index)

-- Example 30937
public Map<?,​?> getMap​(int index)

-- Example 30938
public Row getObject​(int index)

-- Example 30939
public int fieldIndex​(String fieldName)

-- Example 30940
public <T> T getAs​(int index,
                   Class<T> clazz)
            throws ClassCastException,
                   ArrayIndexOutOfBoundsException

-- Example 30941
Row row = Row.create(1, "Alice", 95.5);
 row.getAs(0, Integer.class); // Returns 1 as an Int
 row.getAs(1, String.class); // Returns "Alice" as a String
 row.getAs(2, Double.class); // Returns 95.5 as a Double

-- Example 30942
public <T> T getAs​(String fieldName,
                   Class<T> clazz)

-- Example 30943
StructType schema =
     StructType.create(
        new StructField("name", DataTypes.StringType),
        new StructField("val", DataTypes.IntegerType));
 Row[] data = { Row.create("Alice", 1) };
 DataFrame df = session.createDataFrame(data, schema);
 Row row = df.collect()[0];

 row.getAs("name", String.class); // Returns "Alice" as a String
 row.getAs("val", Integer.class); // Returns 1 as an Int

-- Example 30944
public String toString()

-- Example 30945
public static Row create​(Object... values)

-- Example 30946
public class TypedAsyncJob<T>
extends AsyncJob

-- Example 30947
public T getResult​(int maxWaitTimeInSeconds)

-- Example 30948
public T getResult()

-- Example 30949
public class AsyncJob
extends Object

-- Example 30950
public String getQueryId()

-- Example 30951
public Iterator<Row> getIterator​(int maxWaitTimeInSeconds)

-- Example 30952
public Iterator<Row> getIterator()

-- Example 30953
public Row[] getRows​(int maxWaitTimeInSeconds)

-- Example 30954
public Row[] getRows()

-- Example 30955
public boolean isDone()

-- Example 30956
public void cancel()

-- Example 30957
public class Updatable
extends DataFrame

-- Example 30958
public UpdateResult update​(Map<Column,​Column> assignments)

-- Example 30959
Map<Column, Column> assignments = new HashMap<>;
 assignments.put(Functions.col("col1"), Functions.lit(1);
 // Assign value 1 to column col1 in all rows in updatable.
 session.table("tableName").update(assignment);

-- Example 30960
public UpdateResult updateColumn​(Map<String,​Column> assignments)

-- Example 30961
Map<String, Column> assignments = new HashMap<>;
 assignments.put("col1", Functions.lit(1);
 // Assign value 1 to column col1 in all rows in updatable.
 session.table("tableName").updateColumn(assignment);

-- Example 30962
public UpdateResult update​(Map<Column,​Column> assignments,
                           Column condition)

-- Example 30963
Map<Column, Column> assignments = new HashMap<>;
 assignments.put(Functions.col("col1"), Functions.lit(1);
 // Assign value 1 to column col1 in the rows if col2 is true in updatable.
 session.table("tableName").updateColumn(assignment,
   Functions.col("col2").equal_to(Functions.lit(true)));

-- Example 30964
public UpdateResult updateColumn​(Map<String,​Column> assignments,
                                 Column condition)

-- Example 30965
Map<String, Column> assignments = new HashMap<>;
 assignments.put("col1", Functions.lit(1);
 // Assign value 1 to column col1 in the rows if col3 is true in updatable.
 session.table("tableName").updateColumn(assignment,
   Functions.col("col2").equal_to(Functions.lit(true)));

-- Example 30966
public UpdateResult update​(Map<Column,​Column> assignments,
                           Column condition,
                           DataFrame sourceData)

-- Example 30967
Map<Column, Column> assignments = new HashMap<>;
 assignments.put(Functions.col("col1"), Functions.lit(1);
 session.table("tableName").update(assignment,
   Functions.col("col2").equal_to(df.col("col_a")), df);

-- Example 30968
public UpdateResult updateColumn​(Map<String,​Column> assignments,
                                 Column condition,
                                 DataFrame sourceData)

-- Example 30969
Map<String, Column> assignments = new HashMap<>;
 assignments.put("col1", Functions.lit(1);
 session.table("tableName").updateColumn(assignment,
   Functions.col("col2").equal_to(df.col("col_a")), df);

-- Example 30970
public DeleteResult delete()

-- Example 30971
public DeleteResult delete​(Column condition)

-- Example 30972
session.table("tableName").delete(Functions.col("col1").equal_to(Functions.lit(1)));

-- Example 30973
public DeleteResult delete​(Column condition,
                           DataFrame sourceData)

-- Example 30974
session.table(tableName).delete(Functions.col("col1").equal_to(df.col("col2")), df);

-- Example 30975
public MergeBuilder merge​(DataFrame source,
                          Column joinExpr)

-- Example 30976
public Updatable clone()

-- Example 30977
public UpdatableAsyncActor async()

-- Example 30978
public class UpdateResult
extends Object

-- Example 30979
public long getRowsUpdated()

-- Example 30980
public long getMultiJoinedRowsUpdated()

-- Example 30981
public class DeleteResult
extends Object

-- Example 30982
public long getRowsDeleted()

-- Example 30983
public class MergeBuilder
extends Object

-- Example 30984
public MatchedClauseBuilder whenMatched()

-- Example 30985
public MatchedClauseBuilder whenMatched​(Column condition)

-- Example 30986
public NotMatchedClauseBuilder whenNotMatched()

-- Example 30987
public NotMatchedClauseBuilder whenNotMatched​(Column condition)

-- Example 30988
public MergeResult collect()

-- Example 30989
public MergeBuilderAsyncActor async()

-- Example 30990
public class MatchedClauseBuilder
extends Object

-- Example 30991
public MergeBuilder update​(Map<Column,​Column> assignments)

-- Example 30992
Map<Column, Column> assignments = new HashMap<>();
 assignments.put(Functions.col("col_1"), df.col("col_b"));
 session.table("table").merge(df, Functions.col("col_1").equal_to(df.col("col_a")))
   .whenMatched().update(assignments).collect();

