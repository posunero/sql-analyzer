-- Example 30390
public DataFrame naturalJoin​(DataFrame right,
                             String joinType)

-- Example 30391
public DataFrame sort​(Column... sortExprs)

-- Example 30392
DataFrame dfSorted = df.sort(df.col("colA"), df.col("colB").desc);

-- Example 30393
public DataFrame limit​(int n)

-- Example 30394
public RelationalGroupedDataFrame groupBy​(Column... cols)

-- Example 30395
public RelationalGroupedDataFrame groupBy​(String... colNames)

-- Example 30396
public RelationalGroupedDataFrame rollup​(Column... cols)

-- Example 30397
public RelationalGroupedDataFrame rollup​(String... colNames)

-- Example 30398
public RelationalGroupedDataFrame cube​(Column... cols)

-- Example 30399
public RelationalGroupedDataFrame cube​(String... colNames)

-- Example 30400
public RelationalGroupedDataFrame groupByGroupingSets​(GroupingSets... sets)

-- Example 30401
public RelationalGroupedDataFrame pivot​(Column pivotColumn,
                                        Object[] values)

-- Example 30402
DataFrame dfPivoted = df.pivot(df.col("col1"), new int[]{1, 2, 3})
   .agg(sum(df.col("col2")));

-- Example 30403
public RelationalGroupedDataFrame pivot​(String pivotColumn,
                                        Object[] values)

-- Example 30404
DataFrame dfPivoted = df.pivot("col1", new int[]{1, 2, 3})
   .agg(sum(df.col("col2")));

-- Example 30405
public long count()

-- Example 30406
public Column col​(String colName)

-- Example 30407
public DataFrame alias​(String alias)

-- Example 30408
public Row[] collect()

-- Example 30409
public Iterator<Row> toLocalIterator()

-- Example 30410
public void show()

-- Example 30411
public void show​(int n)

-- Example 30412
public void show​(int n,
                 int maxWidth)

-- Example 30413
public void createOrReplaceView​(String viewName)

-- Example 30414
public void createOrReplaceView​(String[] multipartIdentifier)

-- Example 30415
public void createOrReplaceTempView​(String viewName)

-- Example 30416
public void createOrReplaceTempView​(String[] multipartIdentifier)

-- Example 30417
public Optional<Row> first()

-- Example 30418
public Row[] first​(int n)

-- Example 30419
public DataFrame sample​(long num)

-- Example 30420
public DataFrame sample​(double probabilityFraction)

-- Example 30421
public DataFrame[] randomSplit​(double[] weights)

-- Example 30422
public DataFrame flatten​(Column input)

-- Example 30423
DataFrame df = session.sql("select parse_json(value) as value from values('[1,2]') as T(value)");
 DataFrame flattened = df.flatten(df.col("value"));
 flattened.select(df.col("value"), flattened("value").as("newValue")).show();

-- Example 30424
public DataFrame flatten​(Column input,
                         String path,
                         boolean outer,
                         boolean recursive,
                         String mode)

-- Example 30425
DataFrame df = session.sql("select parse_json(value) as value from values('[1,2]') as T(value)");
 DataFrame flattened = df.flatten(df.col("value"), "", false, false, "both");
 flattened.select(df.col("value"), flattened("value").as("newValue")).show();

-- Example 30426
public DataFrameWriter write()

-- Example 30427
df.write().saveAsTable("table1");

-- Example 30428
public DataFrameNaFunctions na()

-- Example 30429
public DataFrameStatFunctions stat()

-- Example 30430
public DataFrameAsyncActor async()

-- Example 30431
public DataFrame join​(TableFunction func,
                      Column... args)

-- Example 30432
// The following example uses the split_to_table function to split
 // column 'a' in this DataFrame on the character ','.
 // Each row in the current DataFrame will produce N rows in the resulting DataFrame,
 // where N is the number of tokens in the column 'a'.

 df.join(TableFunctions.split_to_table(), df.col("a"), Functions.lit(","))

-- Example 30433
public DataFrame join​(TableFunction func,
                      Column[] args,
                      Column[] partitionBy,
                      Column[] orderBy)

-- Example 30434
// The following example passes the values in the column `col1` to the
 // user-defined tabular function (UDTF) `udtf`, partitioning the
 // data by `col2` and sorting the data by `col1`. The example returns
 // a new DataFrame that joins the contents of the current DataFrame with
 // the output of the UDTF.
 df.join(new TableFunction("udtf"),
     new Column[] {df.col("col1")},
     new Column[] {df.col("col2")},
     new Column[] {df.col("col1")});

-- Example 30435
public DataFrame join​(TableFunction func,
                      Map<String,​Column> args)

-- Example 30436
Map<String, Column> args = new HashMap<>();
 args.put("input", Functions.parse_json(df.col("a")));
 df.join(new TableFunction("flatten"), args);

-- Example 30437
public DataFrame join​(TableFunction func,
                      Map<String,​Column> args,
                      Column[] partitionBy,
                      Column[] orderBy)

-- Example 30438
// The following example passes the values in the column `col1` to the
 // user-defined tabular function (UDTF) `udtf`, partitioning the
 // data by `col2` and sorting the data by `col1`. The example returns
 // a new DataFrame that joins the contents of the current DataFrame with
 // the output of the UDTF.
 Map<String, Column> args = new HashMap<>();
 args.put("arg1", df.col("col1"));
 df.join(
   args,
   new Column[] {df.col("col2")},
   new Column[] {df.col("col1")}
 )

-- Example 30439
public DataFrame join​(Column func)

-- Example 30440
df.join(TableFunctions.flatten(
   Functions.parse_json(df.col("col")),
   "path", true, true, "both"
 ));

-- Example 30441
Map<String, Column> args = new HashMap<>();
 args.put("input", Functions.parse_json(df.col("a")));
 df.join(new TableFunction("flatten").call(args));

-- Example 30442
public DataFrame join​(Column func,
                      Column[] partitionBy,
                      Column[] orderBy)

-- Example 30443
df.join(TableFunctions.flatten(
     Functions.parse_json(df.col("col1")),
     "path", true, true, "both"
   ),
   new Column[] {df.col("col2")},
   new Column[] {df.col("col1")}
 );

-- Example 30444
Map<String, Column> args = new HashMap<>();
 args.put("input", Functions.parse_json(df.col("col1")));
 df.join(new TableFunction("flatten").call(args),
 new Column[] {df.col("col2")},
 new Column[] {df.col("col1")});

-- Example 30445
public class Column
extends Object

-- Example 30446
public Column subField​(String field)

-- Example 30447
df.select(df.col("src").subField("salesperson").subField("emails").subField(0))

-- Example 30448
public Column subField​(int index)

-- Example 30449
df.select(df.col("src").subField(1).subField(0))

-- Example 30450
public Optional<String> getName()

-- Example 30451
public Column as​(String alias)

-- Example 30452
public Column alias​(String alias)

-- Example 30453
public Column unary_minus()

-- Example 30454
public Column unary_not()

-- Example 30455
public Column equal_to​(Column other)

-- Example 30456
public Column not_equal​(Column other)

