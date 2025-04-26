-- Example 28985
public Optional<StructField> nameToField​(String name)

-- Example 28986
public boolean equals​(Object other)

-- Example 28987
public int hashCode()

-- Example 28988
public void printTreeString()

-- Example 28989
public class StructField
extends Object

-- Example 28990
public StructField​(ColumnIdentifier columnIdentifier,
                   DataType dataType,
                   boolean nullable)

-- Example 28991
public StructField​(ColumnIdentifier columnIdentifier,
                   DataType dataType)

-- Example 28992
public StructField​(String name,
                   DataType dataType,
                   boolean nullable)

-- Example 28993
public StructField​(String name,
                   DataType dataType)

-- Example 28994
public String name()

-- Example 28995
public ColumnIdentifier columnIdentifier()

-- Example 28996
public DataType dataType()

-- Example 28997
public boolean nullable()

-- Example 28998
public String toString()

-- Example 28999
public boolean equals​(Object other)

-- Example 29000
public int hashCode()

-- Example 29001
public class UDFRegistration
extends Object

-- Example 29002
public UserDefinedFunction registerTemporary​(JavaUDF0<?> func,
                                             DataType output)

-- Example 29003
public UserDefinedFunction registerTemporary​(JavaUDF1<?,​?> func,
                                             DataType input,
                                             DataType output)

-- Example 29004
public UserDefinedFunction registerTemporary​(JavaUDF2<?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29005
public UserDefinedFunction registerTemporary​(JavaUDF3<?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29006
public UserDefinedFunction registerTemporary​(JavaUDF4<?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29007
public UserDefinedFunction registerTemporary​(JavaUDF5<?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29008
public UserDefinedFunction registerTemporary​(JavaUDF6<?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29009
public UserDefinedFunction registerTemporary​(JavaUDF7<?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29010
public UserDefinedFunction registerTemporary​(JavaUDF8<?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29011
public UserDefinedFunction registerTemporary​(JavaUDF9<?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29012
public UserDefinedFunction registerTemporary​(JavaUDF10<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29013
public UserDefinedFunction registerTemporary​(JavaUDF11<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29014
public UserDefinedFunction registerTemporary​(JavaUDF12<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29015
public UserDefinedFunction registerTemporary​(JavaUDF13<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29016
public UserDefinedFunction registerTemporary​(JavaUDF14<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29017
public UserDefinedFunction registerTemporary​(JavaUDF15<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29018
public UserDefinedFunction registerTemporary​(JavaUDF16<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29019
public UserDefinedFunction registerTemporary​(JavaUDF17<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29020
public UserDefinedFunction registerTemporary​(JavaUDF18<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29021
public UserDefinedFunction registerTemporary​(JavaUDF19<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29022
public UserDefinedFunction registerTemporary​(JavaUDF20<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29023
public UserDefinedFunction registerTemporary​(JavaUDF21<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29024
public UserDefinedFunction registerTemporary​(JavaUDF22<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29025
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF0<?> func,
                                             DataType output)

-- Example 29026
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF1<?,​?> func,
                                             DataType input,
                                             DataType output)

-- Example 29027
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF2<?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29028
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF3<?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29029
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF4<?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29030
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF5<?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29031
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF6<?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29032
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF7<?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29033
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF8<?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29034
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF9<?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29035
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF10<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29036
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF11<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29037
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF12<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29038
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF13<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29039
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF14<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29040
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF15<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29041
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF16<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29042
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF17<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29043
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF18<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29044
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF19<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29045
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF20<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29046
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF21<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29047
public UserDefinedFunction registerTemporary​(String name,
                                             JavaUDF22<?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output)

-- Example 29048
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF0<?> func,
                                             DataType output,
                                             String stageLocation)

-- Example 29049
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF1<?,​?> func,
                                             DataType input,
                                             DataType output,
                                             String stageLocation)

-- Example 29050
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF2<?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

-- Example 29051
public UserDefinedFunction registerPermanent​(String name,
                                             JavaUDF3<?,​?,​?,​?> func,
                                             DataType[] input,
                                             DataType output,
                                             String stageLocation)

