-- Example 19609
<classification_profile_name>!DESCRIBE()

-- Example 19610
{
   "auto_tag": true | false ,
   "maximum_classification_validity_days": <integer>,
   "minimum_object_age_for_classification_days": <integer>
   "column_tag_map": <object>
   "custom_classifiers": <object>,
}

-- Example 19611
SELECT my_classification_profile!DESCRIBE();

-- Example 19612
+--------------------------------------------------------+
|         MY_CLASSIFICATION_PROFILE!DESCRIBE()           |
+--------------------------------------------------------+
|   {                                                    |
|     "auto_tag": true,                                  |
|     "maximum_classification_validity_days": 30,        |
|     "column_tag_map": [                                |
|       {                                                |
|         "semantic_categories": [                       |
|           "NAME"                                       |
|         ],                                             |
|         "tag_name": "test_cc_db.test_cc_schema.pii_r3",|
|         "tag_value": "important"                       |
|       },                                               |
|      "custom_classifiers": {                           |
|        "PII": {                                        |
|          "SC1": {                                      |
|            "col_name_regex": "my_name",                |
|             "description": "a new semantic category",  |
|             "privacy_category": "IDENTIFIER",          |
|             "threshold": 0.8,                          |
|             "value_regex": "\\\\d{{2}}-\\\\d{{2}}"     |
|          },                                            |
|          "SC2": {                                      |
|            "privacy_category": "IDENTIFIER",           |
|            "threshold": 0.8,                           |
|            "value_regex": "\\\\d{{3}}-\\\\d{{3}}|\\\\d"|
|          }                                             |
|        }                                               |
|      },                                                |
       "minimum_object_age_for_classification_days": 1   |
|   }                                                    |
+--------------------------------------------------------+

-- Example 19613
<classification_profile_name>!SET_AUTO_TAG( <boolean_value> )

-- Example 19614
CALL my_classification_profile!SET_AUTO_TAG(true);

-- Example 19615
CALL my_classification_profile!SET_AUTO_TAG(false);

-- Example 19616
<classification_profile_name>!SET_CUSTOM_CLASSIFIERS( <object> )

-- Example 19617
CALL my_classification_profile!SET_CUSTOM_CLASSIFIERS(
  {
    'medical_codes': medical_codes!list(),
    'finance_codes': finance_codes!list()
  });

-- Example 19618
<classification_profile_name>!SET_MAXIMUM_CLASSIFICATION_VALIDITY_DAYS( <days> )

-- Example 19619
CALL my_classification_profile!SET_MAXIMUM_CLASSIFICATION_VALIDITY_DAYS(5);

-- Example 19620
<classification_profile_name>!SET_MINIMUM_OBJECT_AGE_FOR_CLASSIFICATION_DAYS( <days> )

-- Example 19621
CALL my_classification_profile!SET_MINIMUM_OBJECT_AGE_FOR_CLASSIFICATION_DAYS(1);

-- Example 19622
<classification_profile_name>!SET_TAG_MAP( <object> )

-- Example 19623
CALL my_classification_profile!SET_TAG_MAP(
  {
    'column_tag_map':[
      {
        'tag_name':'tag_db.sch.pii',
        'tag_value':'important',
        'semantic_categories':['NAME']
      }
    ]
  }
);

-- Example 19624
<classification_profile_name>!UNSET_CUSTOM_CLASSIFIERS()

-- Example 19625
CALL my_classification_profile!UNSET_CUSTOM_CLASSIFIERS();

-- Example 19626
<classification_profile_name>!UNSET_MAXIMUM_CLASSIFICATION_VALIDITY_DAYS()

-- Example 19627
CALL my_classification_profile!UNSET_MAXIMUM_CLASSIFICATION_VALIDITY_DAYS();

-- Example 19628
<classification_profile_name>!UNSET_TAG_MAP()

-- Example 19629
CALL my_classification_profile!UNSET_TAG_MAP();

-- Example 19630
CREATE [ OR REPLACE ] SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER
[ IF NOT EXISTS ] <custom_classifier_name>()

-- Example 19631
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER medical_codes();

-- Example 19632
DROP SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER
[ IF EXISTS ] <custom_classifier_name>

-- Example 19633
DROP SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER data.classifiers.medical_codes;

-- Example 19634
{
  SHOW SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER           |
  SHOW SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER INSTANCES
}
  [ LIKE <pattern> ]
  [ IN
    {
      ACCOUNT                  |

      DATABASE                 |
      DATABASE <database_name> |

      SCHEMA                   |
      SCHEMA <schema_name>     |
      <schema_name>
    }
  ]

-- Example 19635
SHOW SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER;

-- Example 19636
+----------------------------------+---------------+---------------+-------------+-----------------+---------+-------------+
| created_on                       | name          | database_name | schema_name | current_version | comment | owner       |
+----------------------------------+---------------+---------------+-------------+-----------------+---------+-------------+
| 2023-09-08 07:00:00.123000+00:00 | MEDICAL_CODES | DATA          | CLASSIFIERS | 1.0             | None    | DATA_OWNER  |
+----------------------------------+---------------+---------------+-------------+-----------------+---------+-------------+

-- Example 19637
<custom_classifier>!ADD_REGEX(
  '<semantic_category>' ,
  '<privacy_category>' ,
  '<value_regex>' ,
  [ <column_name_regex> ] ,
  [ <description> ] ,
  [ <threshold> ]
  )

-- Example 19638
SELECT <col_to_classify>
FROM <table_with_col_to_classify>
WHERE <col_to_classify> REGEXP('<regex>');

-- Example 19639
CALL medical_codes!ADD_REGEX(
  'ICD_10_CODES',
  'IDENTIFIER',
  '[A-TV-Z][0-9][0-9AB]\.?[0-9A-TV-Z]{0,4}',
  'ICD.*',
  'Add a regex to identify ICD-10 medical codes in a column',
  0.8
);

-- Example 19640
+---------------+
|   ADD_REGEX   |
+---------------+
| ICD_10_CODES  |
+---------------+

-- Example 19641
<custom_classifier>!DELETE_CATEGORY( '<semantic_category>' )

-- Example 19642
CALL medical_codes!DELETE_CATEGORY('IC_10_CODES');

-- Example 19643
+------------------------------+
|       DELETE_CATEGORY        |
+------------------------------+
| Deleted category IC_10_CODES |
+------------------------------+

-- Example 19644
<custom_classifier>!LIST()

-- Example 19645
{
  "semantic_category_name": {
    "col_name_regex": "string",
    "description": "string",
    "privacy_category": "string",
    "threshold": number,
    "value_regex": "string"
   }
}

-- Example 19646
SELECT medical_codes!LIST();

-- Example 19647
+--------------------------------------------------------------------------------+
| MEDICAL_CODES!LIST()                                                           |
+--------------------------------------------------------------------------------+
| {                                                                              |
|   "ICD-10-CODES": {                                                            |
|     "col_name_regex": "ICD.*",                                                 |
|     "description": "Add a regex to identify ICD-10 medical codes in a column", |
|     "privacy_category": "IDENTIFIER",                                          |
|     "threshold": 0.8,                                                          |
|     "value_regex": "[A-TV-Z][0-9][0-9AB]\.?[0-9A-TV-Z]{0,4}"                   |
|   }                                                                            |
| }                                                                              |
+--------------------------------------------------------------------------------+

-- Example 19648
<model_build_name>!PREDICT(<presigned_url>,
                           [ <model_build_version> ]
                          )

-- Example 19649
{
  "__documentMetadata": {
    "ocrScore": 0.918
  },
  "invoice_number": [
    {
      "score": 0.925,
      "value": "123/20"
    }
  ],
  "invoice_items": [
    {
      "score": 0.839,
      "value": "NEW CRUSHED VELVET DIVAN BED"
    },
    {
      "score": 0.839,
      "value": "Vintage Radiator"
    },
    {
      "score": 0.839,
      "value": "Solid Wooden Worktop"
    },
    {
      "score": 0.839,
      "value": "Sienna Crushed Velvet Curtains"
    }
  ],
  "tax_amount": [
    {
      "score": 0.879,
      "value": "77.57"
    }
  ],
  "total_amount": [
    {
      "score": 0.809,
      "value": "465.43 GBP"
    }
  ],
  "buyer_name": [
    {
      "score": 0.925
    }
  ]
  "vendor_name": [
    {
      "score": 0.9,
      "value": "UK Exports & Imports Ltd"
    }
  ]
}

-- Example 19650
SELECT inspections!PREDICT(
  GET_PRESIGNED_URL(@pdf_inspections_stage, RELATIVE_PATH), 1)
  FROM DIRECTORY(@pdf_inspections_stage);

-- Example 19651
SELECT paystubs!PREDICT(
  GET_PRESIGNED_URL(@pdf_paystubs_stage, 'paystubs/paystub01.pdf'), 1);

-- Example 19652
CREATE [ OR REPLACE ] SNOWFLAKE.ML.FORECAST [ IF NOT EXISTS ] <model_name>(
  INPUT_DATA => <input_data>,
  [ SERIES_COLNAME => '<series_colname>', ]
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  TARGET_COLNAME => '<target_colname>',
  [ CONFIG_OBJECT => <config_object> ]
)
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ COMMENT = '<string_literal>' ]

-- Example 19653
CREATE SNOWFLAKE.ML.FORECAST <name>(
  '<input_data>', '<series_colname>', '<timestamp_colname>', '<target_colname>'
);

-- Example 19654
DROP SNOWFLAKE.ML.FORECAST [ IF EXISTS ] <model_name>;

-- Example 19655
{
  SHOW SNOWFLAKE.ML.FORECAST           |
  SHOW SNOWFLAKE.ML.FORECAST INSTANCES
}
  [ LIKE <pattern> ]
  [ IN
      {
        ACCOUNT                  |

        DATABASE                 |
        DATABASE <database_name> |

        SCHEMA                   |
        SCHEMA <schema_name>     |
        <schema_name>
      }
   ]

-- Example 19656
<name>!FORECAST(
  FORECASTING_PERIODS => <forecasting_periods>,
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19657
<name>!FORECAST(
  INPUT_DATA => <input_data>,
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19658
<name>!FORECAST(
  SERIES_VALUE => <series>,
  FORECASTING_PERIODS => <forecasting_periods>,
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19659
<name>!FORECAST(
  SERIES_VALUE => <series>,
  SERIES_COLNAME => <series_colname>,
  INPUT_DATA => <input_data>,
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19660
<model_name>!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 19661
<model_name>!SHOW_EVALUATION_METRICS();

-- Example 19662
<model_name>!SHOW_EVALUATION_METRICS(
  INPUT_DATA => <input_data>,
  [ SERIES_COLNAME => '<series_colname>', ]
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  TARGET_COLNAME => '<target_colname>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19663
<model_name>!SHOW_TRAINING_LOGS();

-- Example 19664
CREATE [ OR REPLACE ] SNOWFLAKE.ML.FORECAST [ IF NOT EXISTS ] <model_name>(
  INPUT_DATA => <input_data>,
  [ SERIES_COLNAME => '<series_colname>', ]
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  TARGET_COLNAME => '<target_colname>',
  [ CONFIG_OBJECT => <config_object> ]
)
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ COMMENT = '<string_literal>' ]

-- Example 19665
CREATE SNOWFLAKE.ML.FORECAST <name>(
  '<input_data>', '<series_colname>', '<timestamp_colname>', '<target_colname>'
);

-- Example 19666
<name>!FORECAST(
  FORECASTING_PERIODS => <forecasting_periods>,
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19667
<name>!FORECAST(
  INPUT_DATA => <input_data>,
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19668
<name>!FORECAST(
  SERIES_VALUE => <series>,
  FORECASTING_PERIODS => <forecasting_periods>,
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19669
<name>!FORECAST(
  SERIES_VALUE => <series>,
  SERIES_COLNAME => <series_colname>,
  INPUT_DATA => <input_data>,
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19670
<model_name>!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 19671
<model_name>!SHOW_TRAINING_LOGS();

-- Example 19672
<model_name>!SHOW_EVALUATION_METRICS();

-- Example 19673
<model_name>!SHOW_EVALUATION_METRICS(
  INPUT_DATA => <input_data>,
  [ SERIES_COLNAME => '<series_colname>', ]
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  TARGET_COLNAME => '<target_colname>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19674
CREATE [ OR REPLACE ] SNOWFLAKE.ML.TOP_INSIGHTS [ IF NOT EXISTS ] <instance_name>()
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ COMMENT = '<string_literal>' ]

-- Example 19675
DROP SNOWFLAKE.ML.TOP_INSIGHTS [ IF EXISTS ] <instance_name>;

