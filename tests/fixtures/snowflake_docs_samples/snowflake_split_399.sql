-- Example 26708
public boolean equals​(Object other)

-- Example 26709
public int hashCode()

-- Example 26710
public String asGeoJSON()

-- Example 26711
public String toString()

-- Example 26712
public static Geography fromGeoJSON​(String g)

-- Example 26713
public class Variant
extends Object
implements Serializable

-- Example 26714
public Variant​(float num)

-- Example 26715
public Variant​(double num)

-- Example 26716
public Variant​(long num)

-- Example 26717
public Variant​(int num)

-- Example 26718
public Variant​(short num)

-- Example 26719
public Variant​(BigDecimal num)

-- Example 26720
public Variant​(BigInteger num)

-- Example 26721
public Variant​(boolean value)

-- Example 26722
public Variant​(String str)

-- Example 26723
public Variant​(byte[] bytes)

-- Example 26724
public Variant​(Time time)

-- Example 26725
public Variant​(Date date)

-- Example 26726
public Variant​(Timestamp timestamp)

-- Example 26727
public Variant​(List<Object> list)

-- Example 26728
public Variant​(Object[] arr)

-- Example 26729
public Variant​(Object obj)

-- Example 26730
public float asFloat()

-- Example 26731
public double asDouble()

-- Example 26732
public short asShort()

-- Example 26733
public int asInt()

-- Example 26734
public long asLong()

-- Example 26735
public BigDecimal asBigDecimal()

-- Example 26736
public BigInteger asBigInteger()

-- Example 26737
public String asString()

-- Example 26738
public String asJsonString()

-- Example 26739
public com.fasterxml.jackson.databind.JsonNode asJsonNode()

-- Example 26740
- to get the first value from array for key "a"

 Variant jv = new Variant("{\"a\": [1, 2], \"b\": \"c\"}");
 System.out.println(jv.asJsonNode().get("a").get(0));

 output
 1

-- Example 26741
public byte[] asBinary()

-- Example 26742
public Time asTime()

-- Example 26743
public Date asDate()

-- Example 26744
public Timestamp asTimestamp()

-- Example 26745
public boolean asBoolean()

-- Example 26746
public Variant[] asArray()

-- Example 26747
public List<Variant> asList()

-- Example 26748
public Map<String,​Variant> asMap()

-- Example 26749
public boolean equals​(Object other)

-- Example 26750
public int hashCode()

-- Example 26751
public String toString()

-- Example 26752
<dependencies>
  ...
  <dependency>
    <groupId>com.snowflake</groupId>
    <artifactId>snowpark</artifactId>
    <version>1.15.0</version>
  </dependency>
  ...
</dependencies>

-- Example 26753
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 26754
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 26755
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 26756
gpg: keyserver receive failed: Server indicated a failure

-- Example 26757
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 26758
gpg --verify snowpark-1.15.0-bundle.tar.gz.asc snowpark-1.15.0-bundle.tar.gz

-- Example 26759
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 26760
-- Create the UDF.
CREATE OR REPLACE FUNCTION my_array_reverse(a ARRAY)
  RETURNS ARRAY
  LANGUAGE JAVASCRIPT
AS
$$
  return A.reverse();
$$
;

-- Example 26761
-- flatten all arrays and values of objects into a single array
-- order of objects may be lost
CREATE OR REPLACE FUNCTION flatten_complete(v variant)
  RETURNS variant
  LANGUAGE JAVASCRIPT
  AS '
  // Define a function flatten(), which always returns an array.
  function flatten(input) {
    var returnArray = [];
    if (Array.isArray(input)) {
      var arrayLength = input.length;
      for (var i = 0; i < arrayLength; i++) {
        returnArray.push.apply(returnArray, flatten(input[i]));
      }
    } else if (typeof input === "object") {
      for (var key in input) {
        if (input.hasOwnProperty(key)) {
          returnArray.push.apply(returnArray, flatten(input[key]));
        }
      }
    } else {
      returnArray.push(input);
    }
    return returnArray;
  }

  // Now call the function flatten() that we defined earlier.
  return flatten(V);
  ';

select value from table(flatten(flatten_complete(parse_json(
'[
  {"key1" : [1, 2], "key2" : ["string1", "string2"]},
  {"key3" : [{"inner key 1" : 10, "inner key 2" : 11}, 12]}
  ]'))));

-----------+
   VALUE   |
-----------+
 1         |
 2         |
 "string1" |
 "string2" |
 10        |
 11        |
 12        |
-----------+

-- Example 26762
-- Valid UDF.  'N' must be capitalized.
CREATE OR REPLACE FUNCTION add5(n double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS 'return N + 5;';

select add5(0.0);

-- Valid UDF. Lowercase argument is double-quoted.
CREATE OR REPLACE FUNCTION add5_quoted("n" double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS 'return n + 5;';

select add5_quoted(0.0);

-- Invalid UDF. Error returned at runtime because JavaScript identifier 'n' cannot be resolved.
CREATE OR REPLACE FUNCTION add5_lowercase(n double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS 'return n + 5;';

select add5_lowercase(0.0);

-- Example 26763
create or replace table strings (s string);
insert into strings values (null), ('non-null string');

-- Example 26764
CREATE OR REPLACE FUNCTION string_reverse_nulls(s string)
    RETURNS string
    LANGUAGE JAVASCRIPT
    AS '
    if (S === undefined) {
        return "string was null";
    } else
    {
        return undefined;
    }
    ';

-- Example 26765
select string_reverse_nulls(s) 
    from strings
    order by 1;
+-------------------------+
| STRING_REVERSE_NULLS(S) |
|-------------------------|
| string was null         |
| NULL                    |
+-------------------------+

-- Example 26766
CREATE OR REPLACE FUNCTION variant_nulls(V VARIANT)
      RETURNS VARCHAR
      LANGUAGE JAVASCRIPT
      AS '
      if (V === undefined) {
        return "input was SQL null";
      } else if (V === null) {
        return "input was variant null";
      } else {
        return V;
      }
      ';

-- Example 26767
select null, 
       variant_nulls(cast(null as variant)),
       variant_nulls(PARSE_JSON('null'))
       ;
+------+--------------------------------------+-----------------------------------+
| NULL | VARIANT_NULLS(CAST(NULL AS VARIANT)) | VARIANT_NULLS(PARSE_JSON('NULL')) |
|------+--------------------------------------+-----------------------------------|
| NULL | input was SQL null                   | input was variant null            |
+------+--------------------------------------+-----------------------------------+

-- Example 26768
CREATE OR REPLACE FUNCTION variant_nulls(V VARIANT)
      RETURNS variant
      LANGUAGE JAVASCRIPT
      AS $$
      if (V == 'return undefined') {
        return undefined;
      } else if (V == 'return null') {
        return null;
      } else if (V == 3) {
        return {
            key1 : undefined,
            key2 : null
            };
      } else {
        return V;
      }
      $$;

-- Example 26769
select variant_nulls('return undefined'::VARIANT) AS "RETURNED UNDEFINED",
       variant_nulls('return null'::VARIANT) AS "RETURNED NULL",
       variant_nulls(3) AS "RETURNED VARIANT WITH UNDEFINED AND NULL; NOTE THAT UNDEFINED WAS REMOVED";
+--------------------+---------------+---------------------------------------------------------------------------+
| RETURNED UNDEFINED | RETURNED NULL | RETURNED VARIANT WITH UNDEFINED AND NULL; NOTE THAT UNDEFINED WAS REMOVED |
|--------------------+---------------+---------------------------------------------------------------------------|
| NULL               | null          | {                                                                         |
|                    |               |   "key2": null                                                            |
|                    |               | }                                                                         |
+--------------------+---------------+---------------------------------------------------------------------------+

-- Example 26770
CREATE OR REPLACE FUNCTION num_test(a double)
  RETURNS string
  LANGUAGE JAVASCRIPT
AS
$$
  return A;
$$
;

-- Example 26771
select hash(1) AS a, 
       num_test(hash(1)) AS b, 
       a - b;
+----------------------+----------------------+------------+
|                    A | B                    |      A - B |
|----------------------+----------------------+------------|
| -4730168494964875235 | -4730168494964875000 | -235.00000 |
+----------------------+----------------------+------------+

-- Example 26772
getColumnValueAsString()

-- Example 26773
Cannot determine which implementation of handler "handler name" to invoke since there are multiple
definitions with <number of args> arguments in function <user defined function name> with
handler <class name>.<handler name>

-- Example 26774
jar cf ./my_udf.jar MyClass.class

