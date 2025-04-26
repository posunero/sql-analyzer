-- Example 30725
public static Column is_timestamp_tz​(Column col)

-- Example 30726
public static Column check_json​(Column col)

-- Example 30727
public static Column check_xml​(Column col)

-- Example 30728
public static Column json_extract_path_text​(Column col,
                                            Column path)

-- Example 30729
public static Column parse_json​(Column col)

-- Example 30730
public static Column parse_xml​(Column col)

-- Example 30731
public static Column strip_null_value​(Column col)

-- Example 30732
public static Column array_agg​(Column col)

-- Example 30733
public static Column array_append​(Column array,
                                  Column element)

-- Example 30734
public static Column array_cat​(Column array1,
                               Column array2)

-- Example 30735
public static Column array_compact​(Column array)

-- Example 30736
public static Column array_construct​(Column... cols)

-- Example 30737
public static Column array_construct_compact​(Column... cols)

-- Example 30738
public static Column array_contains​(Column variant,
                                    Column array)

-- Example 30739
public static Column array_insert​(Column array,
                                  Column pos,
                                  Column element)

-- Example 30740
public static Column array_position​(Column variant,
                                    Column array)

-- Example 30741
public static Column array_prepend​(Column array,
                                   Column element)

-- Example 30742
public static Column array_size​(Column array)

-- Example 30743
public static Column array_slice​(Column array,
                                 Column from,
                                 Column to)

-- Example 30744
public static Column array_to_string​(Column array,
                                     Column separator)

-- Example 30745
public static Column objectagg​(Column key,
                               Column value)

-- Example 30746
public static Column object_construct​(Column... key_values)

-- Example 30747
public static Column object_delete​(Column obj,
                                   Column key1,
                                   Column... keys)

-- Example 30748
public static Column object_insert​(Column obj,
                                   Column key,
                                   Column value)

-- Example 30749
public static Column object_insert​(Column obj,
                                   Column key,
                                   Column value,
                                   Column update_flag)

-- Example 30750
public static Column object_pick​(Column obj,
                                 Column key1,
                                 Column... keys)

-- Example 30751
public static Column as_array​(Column variant)

-- Example 30752
public static Column as_binary​(Column variant)

-- Example 30753
public static Column as_char​(Column variant)

-- Example 30754
public static Column as_varchar​(Column variant)

-- Example 30755
public static Column as_date​(Column variant)

-- Example 30756
public static Column as_decimal​(Column variant)

-- Example 30757
public static Column as_decimal​(Column variant,
                                int precision)

-- Example 30758
public static Column as_decimal​(Column variant,
                                int precision,
                                int scale)

-- Example 30759
public static Column as_number​(Column variant)

-- Example 30760
public static Column as_number​(Column variant,
                               int precision)

-- Example 30761
public static Column as_number​(Column variant,
                               int precision,
                               int scale)

-- Example 30762
public static Column as_double​(Column variant)

-- Example 30763
public static Column as_real​(Column variant)

-- Example 30764
public static Column as_integer​(Column variant)

-- Example 30765
public static Column as_object​(Column variant)

-- Example 30766
public static Column as_time​(Column variant)

-- Example 30767
public static Column as_timestamp_ltz​(Column variant)

-- Example 30768
public static Column as_timestamp_ntz​(Column variant)

-- Example 30769
public static Column as_timestamp_tz​(Column variant)

-- Example 30770
public static Column strtok_to_array​(Column array)

-- Example 30771
public static Column strtok_to_array​(Column array,
                                     Column delimiter)

-- Example 30772
public static Column to_array​(Column col)

-- Example 30773
public static Column to_json​(Column col)

-- Example 30774
public static Column to_object​(Column col)

-- Example 30775
public static Column to_variant​(Column col)

-- Example 30776
public static Column to_xml​(Column col)

-- Example 30777
public static Column get​(Column col1,
                         Column col2)

-- Example 30778
public static Column get_ignore_case​(Column obj,
                                     Column field)

-- Example 30779
public static Column object_keys​(Column obj)

-- Example 30780
public static Column xmlget​(Column xml,
                            Column tag,
                            Column instance)

-- Example 30781
public static Column xmlget​(Column xml,
                            Column tag)

-- Example 30782
public static Column get_path​(Column col,
                              Column path)

-- Example 30783
public static CaseExpr when​(Column condition,
                            Column value)

-- Example 30784
import com.snowflake.snowpark_java.Functions;
 df.select(Functions
     .when(df.col("col").is_null, Functions.lit(1))
     .when(df.col("col").equal_to(Functions.lit(1)), Functions.lit(6))
     .otherwise(Functions.lit(7)));

-- Example 30785
public static Column iff​(Column condition,
                         Column expr1,
                         Column expr2)

-- Example 30786
public static Column in​(Column[] columns,
                        List<List<Object>> values)

-- Example 30787
import com.snowflake.snowpark_java.Functions;
 df.filter(Functions.in(new Column[]{df.col("c1"), df.col("c2")},
   Arrays.asList(Array.asList(1, "a"), Array.asList(2, "b"))));

-- Example 30788
public static Column in​(Column[] columns,
                        DataFrame df)

-- Example 30789
import com.snowflake.snowpark_java.Functions;
 import com.snowflake.snowpark_java.DataFrame;
 DataFrame df1 = session.sql("select a, b from table1");
 DataFrame df2 = session.table("table2");
 df2.filter(Functions.in(new Column[]{df2.col("c1"), df2.col("c2")}, df1));

-- Example 30790
public static Column seq1()

-- Example 30791
public static Column seq1​(boolean startsFromZero)

