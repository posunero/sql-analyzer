-- Example 24296
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24297
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24298
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24299
[
  {
    "columns": [
      {
        "columnId": 68613,
        "columnName": "ID"
      },
      {
        "columnId": 68612,
        "columnName": "NAME"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66568,
    "objectName": "TEST_DB.TEST_SCHEMA.T2"
  }
]

-- Example 24300
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24301
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24302
[
  {
    "objectDomain": "Stage",
    "objectId": 118,
    "objectName": "TEST_DB.TEST_SCHEMA.S2",
    "stageKind": "External Named"
  }
]

-- Example 24303
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 24304
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 24305
[
  {
    "columns": [
      {
        "columnId": 68614,
        "columnName": "CUSTOMER_INFO"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66570,
    "objectName": "TEST_DB.TEST_SCHEMA.T3"
  }
]

-- Example 24306
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24307
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "TEST_DB.TEST_SCHEMA.T1"
  }
]

-- Example 24308
[
  {
    "columns": [
      {
        "columnId": 68615,
        "columnName": "NAME"
      },
      {
        "columnId": 68616,
        "columnName": "ID"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66572,
    "objectName": "TEST_DB.TEST_SCHEMA.T4"
  }
]

-- Example 24309
[
  {
    "columns": [
      {
        "columnId": 68611,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66566,
    "objectName": "TEST_DB.TEST_SCHEMA.T6"
  }
]

-- Example 24310
[
  {
    "columns": [
      {
        "columnId": 68611,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66566,
    "objectName": "TEST_DB.TEST_SCHEMA.T6"
  }
]

-- Example 24311
[
  {
    "columns": [
      {
        "columnId": 68618,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66574,
    "objectName": "TEST_DB.TEST_SCHEMA.T7"
  }
]

-- Example 24312
with access_history_flatten as (
    select
        r.value:"objectId" as source_id,
        r.value:"objectName" as source_name,
        r.value:"objectDomain" as source_domain,
        w.value:"objectId" as target_id,
        w.value:"objectName" as target_name,
        w.value:"objectDomain" as target_domain,
        c.value:"columnName" as target_column,
        t.query_start_time as query_start_time
    from
        (select * from TEST_DB.ACCOUNT_USAGE.ACCESS_HISTORY) t,
        lateral flatten(input => t.BASE_OBJECTS_ACCESSED) r,
        lateral flatten(input => t.OBJECTS_MODIFIED) w,
        lateral flatten(input => w.value:"columns", outer => true) c
        ),
    sensitive_data_movements(path, target_id, target_name, target_domain, target_column, query_start_time)
    as
      -- Common Table Expression
      (
        -- Anchor Clause: Get the objects that access S1 directly
        select
            f.source_name || '-->' || f.target_name as path,
            f.target_id,
            f.target_name,
            f.target_domain,
            f.target_column,
            f.query_start_time
        from
            access_history_flatten f
        where
        f.source_domain = 'Stage'
        and f.source_name = 'TEST_DB.TEST_SCHEMA.S1'
        and f.query_start_time >= dateadd(day, -30, date_trunc(day, current_date))
        union all
        -- Recursive Clause: Recursively get all the objects that access S1 indirectly
        select sensitive_data_movements.path || '-->' || f.target_name as path, f.target_id, f.target_name, f.target_domain, f.target_column, f.query_start_time
          from
             access_history_flatten f
            join sensitive_data_movements
            on f.source_id = sensitive_data_movements.target_id
                and f.source_domain = sensitive_data_movements.target_domain
                and f.query_start_time >= sensitive_data_movements.query_start_time
      )
select path, target_name, target_id, target_domain, array_agg(distinct target_column) as target_columns
from sensitive_data_movements
group by path, target_id, target_name, target_domain;

-- Example 24313
// 1

select
  directSources.value: "objectId" as source_object_id,
  directSources.value: "objectName" as source_object_name,
  directSources.value: "columnName" as source_column_name,
  'DIRECT' as source_column_type,
  om.value: "objectName" as target_object_name,
  columns_modified.value: "columnName" as target_column_name
from
  (
    select
      *
    from
      snowflake.account_usage.access_history
  ) t,
  lateral flatten(input => t.OBJECTS_MODIFIED) om,
  lateral flatten(input => om.value: "columns", outer => true) columns_modified,
  lateral flatten(
    input => columns_modified.value: "directSources",
    outer => true
  ) directSources

union

// 2

select
  baseSources.value: "objectId" as source_object_id,
  baseSources.value: "objectName" as source_object_name,
  baseSources.value: "columnName" as source_column_name,
  'BASE' as source_column_type,
  om.value: "objectName" as target_object_name,
  columns_modified.value: "columnName" as target_column_name
from
  (
    select
      *
    from
      snowflake.account_usage.access_history
  ) t,
  lateral flatten(input => t.OBJECTS_MODIFIED) om,
  lateral flatten(input => om.value: "columns", outer => true) columns_modified,
  lateral flatten(
    input => columns_modified.value: "baseSources",
    outer => true
  ) baseSources
;

-- Example 24314
use role accountadmin;
select distinct
    obj_policy.value:"policyName"::VARCHAR as policy_name
from snowflake.account_usage.access_history as ah
    , lateral flatten(ah.policies_referenced) as obj
    , lateral flatten(obj.value:"policies") as obj_policy
;

-- Example 24315
use role accountadmin;
select distinct
    policies.value:"policyName"::VARCHAR as policy_name
from snowflake.account_usage.access_history as ah
    , lateral flatten(ah.policies_referenced) as obj
    , lateral flatten(obj.value:"columns") as columns
    , lateral flatten(columns.value:"policies") as policies
;

-- Example 24316
where query_start_time > '2023-07-07' and
   query_start_time < '2023-07-08' and
   query_id = '01ad7987-0606-6e2c-0001-dd20f12a9777')

-- Example 24317
SELECT *
from(
  select j1.*,j2.QUERY_START_TIME as POLICY_CHANGED_TIME, POLICY_BODY
from
(
  select distinct t1.*,
      t4.value:"policyId"::number as PID
  from (select *
      from SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
      where query_start_time > '2023-07-07' and
         query_start_time < '2023-07-08' and
         query_id = '01ad7987-0606-6e2c-0001-dd20f12a9777') as t1, //
  lateral flatten (input => t1.POLICIES_REFERENCED,OUTER => TRUE) t2,
  lateral flatten (input => t2.value:"columns", OUTER => TRUE) t3,
  lateral flatten (input => t3.value:"policies",OUTER => TRUE) t4
) as j1
left join
(
  select OBJECT_MODIFIED_BY_DDL:"objectId"::number as PID,
      QUERY_START_TIME,
      OBJECT_MODIFIED_BY_DDL:"properties"."policyBody"."value" as POLICY_BODY
      from SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
      where OBJECT_MODIFIED_BY_DDL is not null and
      (OBJECT_MODIFIED_BY_DDL:"objectDomain" ilike '%masking%' or OBJECT_MODIFIED_BY_DDL:"objectDomain" ilike '%row%')
) as j2
On j1.POLICIES_REFERENCED is not null and j1.pid = j2.pid and j1.QUERY_START_TIME>j2.QUERY_START_TIME) as j3
QUALIFY ROW_NUMBER() OVER (PARTITION BY query_id,pid ORDER BY policy_changed_time DESC) = 1;

-- Example 24318
CREATE FUNCTION MYDB.UDFS.GET_PRODUCT(num1 number, num2 number)
RETURNS number
AS
$$
    NUM1 * NUM2
$$
;

-- Example 24319
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "MYDB.UDFS.GET_PRODUCT",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  }
]

-- Example 24320
insert into t1(product)
select get_product(c1, c2) from mydb.tables.t1;

-- Example 24321
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "MYDB.UDFS.GET_PRODUCT",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  },
  {
    "objectDomain": "TABLE",
    "objectName": "MYDB.TABLES.T1",
    "objectId": 1,
    "columns":
    [
      {
        "columnName": "c1",
        "columnId": 1
      },
      {
        "columnName": "c2",
        "columnId": 2
      }
    ]
  }
]

-- Example 24322
[
   {
     "objectDomain": "TABLE",
     "objectName": "MYDB.TABLES.T1",
     "objectId": 2,
     "columns":
     [
       {
         "columnId": "product",
         "columnName": "201",
         "directSourceColumns":
         [
           {
             "objectDomain": "Table",
             "objectName": "MYDB.TABLES.T1",
             "objectId": "1",
             "columnName": "c1"
           },
           {
             "objectDomain": "Table",
             "objectName": "MYDB.TABLES.T1",
             "objectId": "1",
             "columnName": "c2"
           },
           {
             "objectDomain": "FUNCTION",
             "objectName": "MYDB.UDFS.GET_PRODUCT",
             "objectId": "2",
             "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
             "dataType": "NUMBER(38,0)"
           }
         ],
         "baseSourceColumns":[]
       }
     ]
   }
]

-- Example 24323
create view v as
select get_product(c1, c2) as vc from t;

-- Example 24324
create tag governance.tags.pii allowed_values 'sensitive','public';

-- Example 24325
{
  "objectDomain": "TAG",
  "objectName": "governance.tags.pii",
  "objectId": "1",
  "operationType": "CREATE",
  "properties": {
    "allowedValues": {
      "sensitive": {
        "subOperationType": "ADD"
      },
      "public": {
        "subOperationType": "ADD"
      }
    }
  }
}

-- Example 24326
create or replace table hr.data.user_info(
  email string
    with masking policy governance.policies.email_mask
    with tag (governance.tags.pii = 'sensitive')
  )
with tag (governance.tags.pii = 'sensitive');

-- Example 24327
{
  "objectDomain": "TABLE",
  "objectName": "hr.data.user_info",
  "objectId": "1",
  "operationType": "CREATE",
  "properties": {
    "tags": {
      "governance.tags.pii": {
        "subOperationType": "ADD",
        "objectId": {
          "value": "1"
        },
        "tagValue": {
          "value": "sensitive"
        }
      }
    },
    "columns": {
      "email": {
        objectId: {
          "value": 1
        },
        "subOperationType": "ADD",
        "tags": {
          "governance.tags.pii": {
            "subOperationType": "ADD",
            "objectId": {
              "value": "1"
            },
            "tagValue": {
              "value": "sensitive"
            }
          }
        },
        "maskingPolicies": {
          "governance.policies.email_mask": {
            "subOperationType": "ADD",
            "objectId": {
              "value": 2
            }
          }
        }
      }
    }
  }
}

-- Example 24328
alter tag governance.tags.pii set masking policy governance.policies.email_mask;

-- Example 24329
{
  "objectDomain": "TAG",
  "objectName": "governance.tags.pii",
  "objectId": "1",
  "operationType": "ALTER",
  "properties": {
    "maskingPolicies": {
      "governance.policies.email_mask": {
        "subOperationType": "ADD",
        "objectId": {
          "value": 2
        }
      }
    }
  }
}

-- Example 24330
alter table governance.tables.t2 swap with governance.tables.t3;

-- Example 24331
{
  "objectDomain": "Table",
  "objectId": 0,
  "objectName": "GOVERNANCE.TABLES.T2",
  "operationType": "ALTER",
  "properties": {
    "swapTargetDomain": {
      "value": "Table"
    },
    "swapTargetId": {
      "value": 0
    },
    "swapTargetName": {
      "value": "GOVERNANCE.TABLES.T3"
    }
  }
}

-- Example 24332
{
  "objectDomain": "Table",
  "objectId": 0,
  "objectName": "GOVERNANCE.TABLES.T3",
  "operationType": "ALTER",
  "properties": {
    "swapTargetDomain": {
      "value": "Table"
    },
    "swapTargetId": {
      "value": 0
    },
    "swapTargetName": {
      "value": "GOVERNANCE.TABLES.T2"
    }
  }
}

-- Example 24333
drop masking policy governance.policies.email_mask;

-- Example 24334
{
  "objectDomain" : "MASKING_POLICY",
  "objectName": "governance.policies.email_mask",
  "objectId" : "1",
  "operationType": "DROP",
  "properties" : {}
}

-- Example 24335
alter table hr.tables.empl_info
  alter column email set tag governance.tags.test_tag = 'test';

alter table hr.tables.empl_info
  alter column email unset tag governance.tags.test_tag;

alter table hr.tables.empl_info
  alter column email set tag governance.tags.data_category = 'sensitive';

-- Example 24336
alter table hr.tables.empl_info
  alter column email set tag governance.tags.data_category = 'public';

-- Example 24337
select
  query_start_time,
  user_name,
  object_modified_by_ddl:"objectName"::string as table_name,
  'EMAIL' as column_name,
  tag_history.value:"subOperationType"::string as operation,
  tag_history.key as tag_name,
  nvl((tag_history.value:"tagValue"."value")::string, '') as value
from
  TEST_DB.ACCOUNT_USAGE.access_history ah,
  lateral flatten(input => ah.OBJECT_MODIFIED_BY_DDL:"properties"."columns"."EMAIL"."tags") tag_history
where true
  and object_modified_by_ddl:"objectDomain" = 'Table'
  and object_modified_by_ddl:"objectName" = 'TEST_DB.TEST_SH.T'
order by query_start_time asc;

-- Example 24338
+-----------------------------------+---------------+---------------------+-------------+-----------+-------------------------------+-----------+
| QUERY_START_TIME                  | USER_NAME     | TABLE_NAME          | COLUMN_NAME | OPERATION | TAG_NAME                      | VALUE     |
+-----------------------------------+---------------+---------------------+-------------+-----------+-------------------------------+-----------+
| Mon, Feb. 14, 2023 12:01:01 -0600 | TABLE_ADMIN   | HR.TABLES.EMPL_INFO | EMAIL       | ADD       | GOVERNANCE.TAGS.TEST_TAG      | test      |
| Mon, Feb. 14, 2023 12:02:01 -0600 | TABLE_ADMIN   | HR.TABLES.EMPL_INFO | EMAIL       | DROP      | GOVERNANCE.TAGS.TEST_TAG      |           |
| Mon, Feb. 14, 2023 12:03:01 -0600 | TABLE_ADMIN   | HR.TABLES.EMPL_INFO | EMAIL       | ADD       | GOVERNANCE.TAGS.DATA_CATEGORY | sensitive |
| Mon, Feb. 14, 2023 12:04:01 -0600 | DATA_ENGINEER | HR.TABLES.EMPL_INFO | EMAIL       | ADD       | GOVERNANCE.TAGS.DATA_CATEGORY | public    |
+-----------------------------------+---------------+---------------------+-------------+-----------+-------------------------------+-----------+

-- Example 24339
create or replace procedure get_id_value(name string)
returns string not null
language javascript
as
$$
  var my_sql_command = "select id from A where name = '" + NAME + "'";
  var statement = snowflake.createStatement( {sqlText: my_sql_command} );
  var result = statement.execute();
  result.next();
  return result.getColumnValue(1);
$$
;

-- Example 24340
[
  {
    "objectDomain": "PROCEDURE",
    "objectName": "MYDB.PROCEDURES.GET_ID_VALUE",
    "argumentSignature": "(NAME STRING)",
    "dataType": "STRING"
  }
]

-- Example 24341
CREATE OR REPLACE PROCEDURE myproc_child()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  BEGIN
  SELECT * FROM mydb.mysch.mytable;
  RETURN 1;
  END
$$;

CREATE OR REPLACE PROCEDURE myproc_parent()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  BEGIN
  CALL myproc_child();
  RETURN 1;
  END
$$;

CALL myproc_parent();

-- Example 24342
SELECT
  query_id,
  parent_query_id,
  root_query_id,
  direct_objects_accessed
FROM
  SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY;

-- Example 24343
+----------+-----------------+---------------+-----------------------------------+
| QUERY_ID | PARENT_QUERY_ID | ROOT_QUERY_ID | DIRECT_OBJECTS_ACCESSED           |
+----------+-----------------+---------------+-----------------------------------+
|  1       | NULL            | NULL          | [{"objectName": "myproc_parent"}] |
|  2       | 1               | 1             | [{"objectName": "myproc_child"}]  |
|  3       | 2               | 1             | [{"objectName": "mytable"}]       |
+----------+-----------------+---------------+-----------------------------------+

-- Example 24344
CREATE SEQUENCE SEQ
  START = 2
  INCREMENT = 7
  COMMENT = 'Comment on sequence';

-- Example 24345
{
  "objectDomain": "Sequence",
  "objectId": 1,
  "objectName": "TEST_DB.TEST_SCHEMA.SEQ",
  "operationType": "CREATE",
  "properties": {
    "start": {
      "value": "2"
    },
    "increment": {
        "value": "7"
    },
    "comment": {
          "value": "Comment on Sequence"
    }
  }
}

-- Example 24346
CREATE OR REPLACE VIEW v1 (vc1, vc2) AS
  SELECT
    t1.c1 AS vc1,
    t2.c2 AS vc2
  FROM t1 LEFT OUTER JOIN t2
    ON t1.c2 = t2.c1;

-- Example 24347
{
  "columns": [
    {
      "columnId": 0,
      "columnName": "C1"
    },
    {
      "columnId": 0,
      "columnName": "C2"
    }
  ],
  "joinObjects": [
    {
      "joinType": "LEFT_OUTER_JOIN",
      "node": {
        "objectDomain": "Table",
        "objectId": 0,
        "objectName": "DB1.SCH.T2"
      }
    }
  ],
  "objectDomain": "Table",
  "objectId": 0,
  "objectName": "DB1.SCH.T1"
}

-- Example 24348
SELECT ...
FROM <object_ref1> [
                     {
                       INNER
                       | { LEFT | RIGHT | FULL } [ OUTER ]
                     }
                   ]
                   JOIN <object_ref2>
  [ ON <condition> ]
[ ... ]

-- Example 24349
SELECT *
FROM <object_ref1> [
                     {
                       INNER
                       | { LEFT | RIGHT | FULL } [ OUTER ]
                     }
                   ]
                   JOIN <object_ref2>
  [ USING( <column_list> ) ]
[ ... ]

-- Example 24350
SELECT ...
FROM <object_ref1> [
                     {
                       | NATURAL [ { LEFT | RIGHT | FULL } [ OUTER ] ]
                       | CROSS
                     }
                   ]
                   JOIN <object_ref2>
[ ... ]

-- Example 24351
ON object_ref2.id_number = object_ref1.id_number

-- Example 24352
... o1 JOIN o2
    USING (key_column)

-- Example 24353
... o1 JOIN o2
    ON o2.key_column = o1.key_column

-- Example 24354
SELECT ... FROM my_table
  JOIN TABLE(FLATTEN(input=>[col_a]))
  ON ... ;

-- Example 24355
SELECT ... FROM my_table
  INNER JOIN TABLE(FLATTEN(input=>[col_a]))
  ON ... ;

-- Example 24356
SELECT ... FROM my_table
  JOIN TABLE(my_js_udtf(col_a))
  ON ... ;

-- Example 24357
SELECT ... FROM my_table
  INNER JOIN TABLE(my_js_udtf(col_a))
  ON ... ;

-- Example 24358
SELECT ... FROM my_table
  LEFT JOIN TABLE(FLATTEN(input=>[a]))
  ON ... ;

-- Example 24359
SELECT ... FROM my_table
  FULL JOIN TABLE(FLATTEN(input=>[a]))
  ON ... ;

-- Example 24360
SELECT ... FROM my_table
  LEFT JOIN TABLE(my_js_udtf(a))
  ON ... ;

-- Example 24361
SELECT ... FROM my_table
  FULL JOIN TABLE(my_js_udtf(a))
  ON ... ;

-- Example 24362
000002 (0A000): Unsupported feature
  'lateral table function called with OUTER JOIN syntax
   or a join predicate (ON clause)'

