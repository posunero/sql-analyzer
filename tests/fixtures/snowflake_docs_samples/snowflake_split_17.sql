-- Example 1089
CREATE OR REPLACE VIEW join_v (vc1, vc2, c1) AS
  SELECT
      bt.c1 AS vc1,
      bt.c2 AS vc2,
      jt.c1
  FROM bt, jt
  WHERE bt.c3 = jt.c1;

-- Example 1090
query_id | query_start_time | user_name | direct_objects_accessed | base_objects_accessed | objects_modified | object_modified_by_ddl | policies_referenced | parent_query_id | root_query_id

-- Example 1091
select * from view_2;

-- Example 1092
create table table_1 as select * from base_table;

-- Example 1093
SELECT query_id, parent_query_id, direct_objects_accessed
FROM snowflake.account_usage.access_history
WHERE parent_query_id = 6789;

-- Example 1094
SELECT user_name
       , query_id
       , query_start_time
       , direct_objects_accessed
       , base_objects_accessed
FROM access_history
ORDER BY 1, 3 desc
;

-- Example 1095
SELECT distinct user_name
FROM access_history
     , lateral flatten(base_objects_accessed) f1
WHERE f1.value:"objectId"::int=<fill_in_object_id>
AND f1.value:"objectDomain"::string='Table'
AND query_start_time >= dateadd('day', -30, current_timestamp())
;

-- Example 1096
SELECT query_id
       , query_start_time
FROM access_history
     , lateral flatten(base_objects_accessed) f1
WHERE f1.value:"objectId"::int=32998411400350
AND f1.value:"objectDomain"::string='Table'
AND query_start_time >= dateadd('day', -30, current_timestamp())
;

-- Example 1097
SELECT distinct f4.value AS column_name
FROM access_history
     , lateral flatten(base_objects_accessed) f1
     , lateral flatten(f1.value) f2
     , lateral flatten(f2.value) f3
     , lateral flatten(f3.value) f4
WHERE f1.value:"objectId"::int=32998411400350
AND f1.value:"objectDomain"::string='Table'
AND f4.key='columnName'
;

-- Example 1098
copy into table1(col1, col2)
from (select t.$1, t.$2 from @mystage1/data1.csv.gz);

-- Example 1099
{
  "objectDomain": STAGE
  "objectName": "mystage1",
  "objectId": 1,
  "stageKind": "External Named"
}

-- Example 1100
{
  "columns": [
     {
       "columnName": "col1",
       "columnId": 1
     },
     {
       "columnName": "col2",
       "columnId": 2
     }
  ],
  "objectId": 1,
  "objectName": "TEST_DB.TEST_SCHEMA.TABLE1",
  "objectDomain": TABLE
}

-- Example 1101
copy into @mystage1/data1.csv
from table1;

-- Example 1102
{
  "objectDomain": TABLE
  "objectName": "TEST_DB.TEST_SCHEMA.TABLE1",
  "objectId": 123,
  "columns": [
     {
       "columnName": "col1",
       "columnId": 1
     },
     {
       "columnName": "col2",
       "columnId": 2
     }
  ]
}

-- Example 1103
{
  "objectId": 1,
  "objectName": "mystage1",
  "objectDomain": STAGE,
  "stageKind": "External Named"
}

-- Example 1104
put file:///tmp/data/mydata.csv @my_int_stage;

-- Example 1105
{
  "location": "file:///tmp/data/mydata.csv"
}

-- Example 1106
{
  "objectId": 1,
  "objectName": "my_int_stage",
  "objectDomain": STAGE,
  "stageKind": "Internal Named"
}

-- Example 1107
get @%mytable file:///tmp/data/;

-- Example 1108
{
  "objectDomain": Stage
  "objectName": "mytable",
  "objectId": 1,
  "stageKind": "Table"
}

-- Example 1109
{
  "location": "file:///tmp/data/"
}

-- Example 1110
use test_db.test_schema;
create or replace table T1(content variant);
insert into T1(content) select parse_json('{"name": "A", "id":1}');

-- T1 -> T6
insert into T6 select * from T1;

-- S1 -> T1
copy into T1 from @S1;

-- T1 -> T2
create table T2 as select content:"name" as name, content:"id" as id from T1;

-- T1 -> S2
copy into @S2 from T1;

-- S1 -> T3
create or replace table T3(customer_info variant);
copy into T3 from @S1;

-- T1 -> T4
create or replace table T4(name string, id string, address string);
insert into T4(name, id) select content:"name", content:"id" from T1;

-- T6 -> T7
create table T7 as select * from T6;

-- Example 1111
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

-- Example 1112
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

-- Example 1113
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

-- Example 1114
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 1115
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 1116
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

-- Example 1117
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

-- Example 1118
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

-- Example 1119
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

-- Example 1120
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

-- Example 1121
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

-- Example 1122
[
  {
    "objectDomain": "Stage",
    "objectId": 118,
    "objectName": "TEST_DB.TEST_SCHEMA.S2",
    "stageKind": "External Named"
  }
]

-- Example 1123
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 1124
[
  {
    "objectDomain": "Stage",
    "objectId": 117,
    "objectName": "TEST_DB.TEST_SCHEMA.S1",
    "stageKind": "External Named"
  }
]

-- Example 1125
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

-- Example 1126
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

-- Example 1127
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

-- Example 1128
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

-- Example 1129
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

-- Example 1130
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

-- Example 1131
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

-- Example 1132
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

-- Example 1133
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

-- Example 1134
use role accountadmin;
select distinct
    obj_policy.value:"policyName"::VARCHAR as policy_name
from snowflake.account_usage.access_history as ah
    , lateral flatten(ah.policies_referenced) as obj
    , lateral flatten(obj.value:"policies") as obj_policy
;

-- Example 1135
use role accountadmin;
select distinct
    policies.value:"policyName"::VARCHAR as policy_name
from snowflake.account_usage.access_history as ah
    , lateral flatten(ah.policies_referenced) as obj
    , lateral flatten(obj.value:"columns") as columns
    , lateral flatten(columns.value:"policies") as policies
;

-- Example 1136
where query_start_time > '2023-07-07' and
   query_start_time < '2023-07-08' and
   query_id = '01ad7987-0606-6e2c-0001-dd20f12a9777')

-- Example 1137
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

-- Example 1138
CREATE FUNCTION MYDB.UDFS.GET_PRODUCT(num1 number, num2 number)
RETURNS number
AS
$$
    NUM1 * NUM2
$$
;

-- Example 1139
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "MYDB.UDFS.GET_PRODUCT",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  }
]

-- Example 1140
insert into t1(product)
select get_product(c1, c2) from mydb.tables.t1;

-- Example 1141
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

-- Example 1142
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

-- Example 1143
create view v as
select get_product(c1, c2) as vc from t;

-- Example 1144
create tag governance.tags.pii allowed_values 'sensitive','public';

-- Example 1145
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

-- Example 1146
create or replace table hr.data.user_info(
  email string
    with masking policy governance.policies.email_mask
    with tag (governance.tags.pii = 'sensitive')
  )
with tag (governance.tags.pii = 'sensitive');

-- Example 1147
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

-- Example 1148
alter tag governance.tags.pii set masking policy governance.policies.email_mask;

-- Example 1149
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

-- Example 1150
alter table governance.tables.t2 swap with governance.tables.t3;

-- Example 1151
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

-- Example 1152
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

-- Example 1153
drop masking policy governance.policies.email_mask;

-- Example 1154
{
  "objectDomain" : "MASKING_POLICY",
  "objectName": "governance.policies.email_mask",
  "objectId" : "1",
  "operationType": "DROP",
  "properties" : {}
}

-- Example 1155
alter table hr.tables.empl_info
  alter column email set tag governance.tags.test_tag = 'test';

alter table hr.tables.empl_info
  alter column email unset tag governance.tags.test_tag;

alter table hr.tables.empl_info
  alter column email set tag governance.tags.data_category = 'sensitive';

-- Example 1156
alter table hr.tables.empl_info
  alter column email set tag governance.tags.data_category = 'public';

