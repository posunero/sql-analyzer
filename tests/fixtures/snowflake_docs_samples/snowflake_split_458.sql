-- Example 30658
public static Column dayofyear​(Column e)

-- Example 30659
public static Column last_day​(Column e)

-- Example 30660
public static Column weekofyear​(Column e)

-- Example 30661
public static Column hour​(Column e)

-- Example 30662
public static Column minute​(Column e)

-- Example 30663
public static Column second​(Column e)

-- Example 30664
public static Column next_day​(Column date,
                              Column dayOfWeek)

-- Example 30665
public static Column previous_day​(Column date,
                                  Column dayOfWeek)

-- Example 30666
public static Column to_timestamp​(Column s)

-- Example 30667
public static Column to_timestamp​(Column s,
                                  Column fmt)

-- Example 30668
public static Column to_date​(Column e)

-- Example 30669
public static Column to_date​(Column e,
                             Column fmt)

-- Example 30670
public static Column date_from_parts​(Column year,
                                     Column month,
                                     Column day)

-- Example 30671
public static Column time_from_parts​(Column hour,
                                     Column minute,
                                     Column second,
                                     Column nanosecond)

-- Example 30672
public static Column time_from_parts​(Column hour,
                                     Column minute,
                                     Column second)

-- Example 30673
public static Column timestamp_from_parts​(Column year,
                                          Column month,
                                          Column day,
                                          Column hour,
                                          Column minute,
                                          Column second)

-- Example 30674
public static Column timestamp_from_parts​(Column year,
                                          Column month,
                                          Column day,
                                          Column hour,
                                          Column minute,
                                          Column second,
                                          Column nanosecond)

-- Example 30675
public static Column timestamp_from_parts​(Column dateExpr,
                                          Column timeExpr)

-- Example 30676
public static Column timestamp_ltz_from_parts​(Column year,
                                              Column month,
                                              Column day,
                                              Column hour,
                                              Column minute,
                                              Column second)

-- Example 30677
public static Column timestamp_ltz_from_parts​(Column year,
                                              Column month,
                                              Column day,
                                              Column hour,
                                              Column minute,
                                              Column second,
                                              Column nanosecond)

-- Example 30678
public static Column timestamp_ntz_from_parts​(Column year,
                                              Column month,
                                              Column day,
                                              Column hour,
                                              Column minute,
                                              Column second)

-- Example 30679
public static Column timestamp_ntz_from_parts​(Column year,
                                              Column month,
                                              Column day,
                                              Column hour,
                                              Column minute,
                                              Column second,
                                              Column nanosecond)

-- Example 30680
public static Column timestamp_ntz_from_parts​(Column dateExpr,
                                              Column timeExpr)

-- Example 30681
public static Column timestamp_tz_from_parts​(Column year,
                                             Column month,
                                             Column day,
                                             Column hour,
                                             Column minute,
                                             Column second)

-- Example 30682
public static Column timestamp_tz_from_parts​(Column year,
                                             Column month,
                                             Column day,
                                             Column hour,
                                             Column minute,
                                             Column second,
                                             Column nanosecond)

-- Example 30683
public static Column timestamp_tz_from_parts​(Column year,
                                             Column month,
                                             Column day,
                                             Column hour,
                                             Column minute,
                                             Column second,
                                             Column nanosecond,
                                             Column timezone)

-- Example 30684
public static Column dayname​(Column expr)

-- Example 30685
public static Column monthname​(Column expr)

-- Example 30686
public static Column dateadd​(String part,
                             Column value,
                             Column expr)

-- Example 30687
date.select(Functions.dateadd("year", Functions.lit(1), date.col("date_col")))

-- Example 30688
public static Column datediff​(String part,
                              Column col1,
                              Column col2)

-- Example 30689
date.select(Functions.datediff("year", date.col("date_col1"), date.col("date_col2")))

-- Example 30690
public static Column trunc​(Column expr,
                           Column scale)

-- Example 30691
public static Column date_trunc​(String format,
                                Column timestamp)

-- Example 30692
public static Column concat​(Column... exprs)

-- Example 30693
public static Column arrays_overlap​(Column a1,
                                    Column a2)

-- Example 30694
public static Column endswith​(Column expr,
                              Column str)

-- Example 30695
public static Column insert​(Column baseExpr,
                            Column position,
                            Column length,
                            Column insertExpr)

-- Example 30696
public static Column left​(Column strExpr,
                          Column lengthExpr)

-- Example 30697
public static Column right​(Column strExpr,
                           Column lengthExpr)

-- Example 30698
public static Column regexp_count​(Column strExpr,
                                  Column pattern,
                                  Column position,
                                  Column parameters)

-- Example 30699
public static Column regexp_count​(Column strExpr,
                                  Column pattern)

-- Example 30700
public static Column regexp_replace​(Column strExpr,
                                    Column pattern)

-- Example 30701
public static Column regexp_replace​(Column strExpr,
                                    Column pattern,
                                    Column replacement)

-- Example 30702
public static Column replace​(Column strExpr,
                             Column pattern,
                             Column replacement)

-- Example 30703
public static Column replace​(Column strExpr,
                             Column pattern)

-- Example 30704
public static Column charindex​(Column targetExpr,
                               Column sourceExpr)

-- Example 30705
public static Column charindex​(Column targetExpr,
                               Column sourceExpr,
                               Column position)

-- Example 30706
public static Column collate​(Column expr,
                             String collationSpec)

-- Example 30707
public static Column collation​(Column expr)

-- Example 30708
public static Column array_intersection​(Column col1,
                                        Column col2)

-- Example 30709
public static Column is_array​(Column col)

-- Example 30710
public static Column is_boolean​(Column col)

-- Example 30711
public static Column is_binary​(Column col)

-- Example 30712
public static Column is_char​(Column col)

-- Example 30713
public static Column is_varchar​(Column col)

-- Example 30714
public static Column is_date​(Column col)

-- Example 30715
public static Column is_date_value​(Column col)

-- Example 30716
public static Column is_decimal​(Column col)

-- Example 30717
public static Column is_double​(Column col)

-- Example 30718
public static Column is_real​(Column col)

-- Example 30719
public static Column is_integer​(Column col)

-- Example 30720
public static Column is_null_value​(Column col)

-- Example 30721
public static Column is_object​(Column col)

-- Example 30722
public static Column is_time​(Column col)

-- Example 30723
public static Column is_timestamp_ltz​(Column col)

-- Example 30724
public static Column is_timestamp_ntz​(Column col)

