TEST_CASE_EXAMPLE = """
Priority: Critical
Name: InstructionLogic-001
Summary: Validate Cancel Instruction function in PH platform
Steps：
|No.| Test Step | Test Data | Expected Result |
1|clear testing rule and data|  |  |
2|insert testing rule|  |  |
3|insert 1st PERSON with raw message and PERSON1|  |  |
4|trigger COMPONENT1 process with PERSON1|  |  |
5|insert 1st PERSON with raw message and PERSON2|  |  |
6|trigger COMPONENT1 process with PERSON2|  |  |
7|get RESUME by PERSON1 and store the value in RESUMEVariable1|  |  |
8|get count of PERSON Link to RESUME Variable1 and store the value in actualCountVariable|  |  |
9|get linking rule code used by PERSON2 and store the value in actualLinkingCode
10|check count of PERSON,compare actual result actualCountVariable with expected result <expectedCountOfPERSON> |  |  |
11|check inking rule code,compare actual result actualLinkingCode with expected result <expectedLinkingRuleCode> |  |  |
12|clear testing rule and data|  |  |
13|generate report report1 and report2|  |  |
"""

TEST_CASE_GUIDE = """
general rules:
1.prepare linking rules and overwrite rules file by provided JsonSchema(000_RuleJsonModelSchema.json),data
sample(001_C20250101A-0102_RuleData.json),jira number(0102),requirements
2.prepare testing data file by provided data template(010_Testing_Data.xlsx),data sample,jira number, requirements, field desc
3.prepare expected result file by provided template,data sample,jira number,expected results
4.prepare linking rules,overwrite rules,testing data,expected results for every jira
5.one jira may have multi linking rules,overwrite rules,testing data,expected results
6.all linking rules,overwrite rules,expected results are being generated in JSON format
7.testing data is generated in EXCEL format
specific rules:
Pre_requisite:
1.every PERSON can only match only one GROUP,one GROUP is associated with only one linking rule,one linking
rule only has one linking criteria
2.overwrite rule is set correctly,one GROUP is associated with one overwrite rule,the overwrite rule is associated
with one COMPANY

Data:
1.prepare testing rules refer to general rules and pre_requisite
provide more info-pending on result
2.prepare testing data refer to general rules and below rules
prepare two pCOMPONENT1ce of data with different human info code but same COMPANY info,announcement date is differdent provide more info-pending on result

"""

# TEST_CASE_GUIDE = """
# general rules:
# 1.prepare linking rules and overwrite rules file by provided JsonSchema(000_RuleJsonModelSchema.json),data
# sample(001_C20250101A-0102_RuleData.json),jira number(0102),requirements
# 2.prepare testing data file by provided data template(010_Testing_Data.xlsx),data sample,jira number, requirements, field desc
# 3.prepare expected result file by provided template,data sample,jira number,expected results
# 4.prepare linking rules,overwrite rules,testing data,expected results for every jira
# 5.one jira may have multi linking rules,overwrite rules,testing data,expected results
# 6.all linking rules,overwrite rules,expected results are being generated in JSON format
# 7.testing data is generated in EXCEL format
# specific rules:
# Pre_requisite:
# 1.every PERSON can only match only one GROUP,one GROUP is associated with only one linking rule,one linking
# rule only has one linking criteria
# 2.overwrite rule is set correctly,one GROUP is associated with one overwrite rule,the overwrite rule is associated
# with one COMPANY
#
# Data:
# 1.prepare testing rules refer to general rules and pre_requisite
# provide more info-pending on result
# 2.prepare testing data refer to general rules and below rules
# prepare two pCOMPONENT1ce of data with different human info code but same COMPANY info,announcement date is differdent provide more info-pending on result
#
# 000_RuleJsonModelSchema.json:
#
# {
#   "$schema": "http://json-schema.org/draft-07/schema#",
#   "type": "object",
#   "properties": {
#     "linkuleList": {
#       "type": "array",
#       "items": {
#         "type": "object",
#         "description": "Define Ranked person Linking Rule for group to be used for linking",
#         "properties": {
#           "v1cdn": {
#             "type": "string",
#             "description": "Unique link rule code"
#           },
#           "group": {
#             "type": "object",
#             "description": "Define Vendor or subset of Vendor to have it's own Linking Rule or overwrite Rule",
#             "properties": {
#               "groupc0p": {
#                 "type": "string",
#                 "description": "Unique group code"
#               },
#               "groupAssociation": {
#                 "type": "object",
#                 "description": "Define Company associated group with their ranking",
#                 "properties": {
#                   "companycdn": {
#                     "type": "string",
#                     "description": "Company for which the linking/overwrite is defined for this group"
#                   },
#                   "rank": {
#                     "type": "number",
#                     "description": "Rank the group for Company (in case person is part of two group and both are linked to Company - high ranked associated group will be used to",
#                     "minimum": 0,
#                     "maximum": 100
#                   }
#                 }
#               },
#               "type": {
#                 "type": "string",
#                 "description": "Define which processes group applies to",
#                 "enum": [
#                   "LINKING",
#                   "OVERWRITE",
#                   "CREATE-resume"
#                 ]
#               }
#             },
#             "required": [
#               "groupc0p",
#               "groupAssociation"
#             ]
#           },
#           "elementList": {
#             "type": "array",
#             "items": {
#               "type": "object",
#               "properties": {
#                 "elendd": {
#                   "type": "string",
#                   "description": "Unique group element code"
#                 },
#                 "personDcaPath": {
#                   "type": "string",
#                   "description": "Vendor/person DCA path that to be used to define the Set"
#                 },
#                 "condition": {
#                   "type": "string",
#                   "description": "Criteria Formula to be used to compare Element",
#                   "enum": [
#                     "EQ",
#                     "like",
#                     "neq",
#                     "in",
#                     "min",
#                     "Null",
#                     "Nnull",
#                     "query",
#                     "persontoresume"
#                   ]
#                 },
#                 "param": {
#                   "type": "string",
#                   "description": "Parameter when need to validate the person Value compared with some parameter"
#                 },
#                 "elemGroupOrder": {
#                   "type": "number"
#                 }
#               },
#               "required": [
#                 "elendd",
#                 "condition",
#                 "personDcaPath"
#               ]
#             }
#           },
#           "rank": {
#             "type": "number",
#             "description": "Rank/Processing Order for person Linking Criteria",
#             "minimum": 0,
#             "maximum": 100
#           }
#         },
#         "required": [
#           "group",
#           "elementList",
#           "rank"
#         ]
#       }
#     },
#     "criteriaList": {
#       "type": "array",
#       "items": {
#         "type": "object",
#         "description": "Define Ranked person Linking Criteria(s) to be used for person Linking Rule",
#         "properties": {
#           "v1c02": {
#             "type": "string",
#             "description": "Unique link rule criteria code"
#           },
#           "rank": {
#             "type": "number",
#             "description": "Rank/Processing Order for person Linking Criteria",
#             "minimum": 0,
#             "maximum": 100
#           },
#           "elementList": {
#             "type": "array",
#             "items": {
#               "type": "object",
#               "description": "Define Linking Criteria Elements (DCAs) and their order for the Linking Criteria (LC) Logic",
#               "properties": {
#                 "elencd": {
#                   "type": "string",
#                   "description": "Unique link rule criteria element code"
#                 },
#                 "personDcaPath": {
#                   "type": "string",
#                   "description": "Event/resume DCA ID that to be used to link"
#                 },
#                 "condition": {
#                   "type": "string",
#                   "description": "Criteria Formula to be used to compare Element",
#                   "enum": [
#                     "FO",
#                     "like",
#                     "neg",
#                     "nin",
#                     "Null",
#                     "Wound1",
#                     "query",
#                     "persontoresume"
#                   ]
#                 },
#                 "resumeDcaPath": {
#                   "type": "string",
#                   "description": "Vendor/person DCA path that to be used to link"
#                 },
#                 "param": {
#                   "type": "string",
#                   "description": "Parameter when need to validate the resume Value compared with some parameter"
#                 },
#                 "clennGroupOrder": {
#                   "type": "number"
#                 },
#                 "isItemNullPermitted": {
#                   "type": "boolean"
#                 },
#                 "docCompareParentsClean": {
#                   "type": "boolean"
#                 },
#                 "parentEventOriginInVIOd": {
#                   "type": "string"
#                 }
#               },
#               "required": [
#                 "elencd",
#                 "personDcaPath",
#                 "condition"
#               ]
#             }
#           }
#         },
#         "required": [
#           "rank",
#           "elementList",
#           "v1c02"
#         ]
#       }
#     },
#     "CompanyOverwriteist": {
#       "type": "array",
#       "description": "Define Company group Overwrite Rule",
#       "items": {
#         "type": "object",
#         "properties": {
#           "companycd": {
#             "type": "string",
#             "description": "Company code for which custom rank is defined for Company Overwrite Rule"
#           },
#           "dcRankList": {
#             "type": "array",
#             "items": {
#               "type": "object",
#               "properties": {
#                 "dcPath": {
#                   "type": "string",
#                   "description": "Data Concept path for which Overwrite rank is defined"
#                 },
#                 "rank": {
#                   "type": "number",
#                   "description": "RANK (1 as lowest and 100 as highest)",
#                   "minimum": 0,
#                   "maximum": 100
#                 },
#                 "doNotWrite": {
#                   "type": "boolean",
#                   "description": "Enable Company to ignore/not process this data concept even if it is getting Processed as per Central Overwrite Rule"
#                 }
#               },
#               "required": [
#                 "dcPath",
#                 "rank"
#               ]
#             }
#           },
#           "dataInMList": {
#             "type": "array",
#             "items": {
#               "type": "object",
#               "properties": {
#                 "rank": {
#                   "type": "number",
#                   "description": "RANK (1 as lowest and 100 as highest)",
#                   "minimum": 0,
#                   "maximum": 100
#                 },
#                 "dataPath": {
#                   "type": "string",
#                   "description": "Data Concept Attribute path for which Overwrite rank is defined"
#                 },
#                 "doNotWrite": {
#                   "type": "boolean",
#                   "description": "Enable Company to ignore/not process this data concept even if it is getting Processed as per Central Overwrite Rule"
#                 }
#               }
#             }
#           },
#           "usCentralRanking": {
#             "type": "boolean",
#             "description": "Whether to use the core ranking or not"
#           },
#           "canCreate": {
#             "type": "boolean",
#             "description": "Whether can it create new event when no existing event Linked"
#           },
#           "processingLogicType": {
#             "type": "string",
#             "enum": [
#               "STP",
#               "ANUAL",
#               "MARXING",
#               "INFORMATION"
#             ]
#           }
#         },
#         "required": [
#           "companycd",
#           "dcRankList",
#           "usCentralRanking"
#         ]
#       }
#     },
#     "defaultist": {
#       "type": "array",
#       "description": "Define group Core Overwrite Rule Ranking at Data Concept Level",
#       "items": {
#         "type": "object",
#         "properties": {
#           "default": {
#             "type": "string",
#             "description": "Data Concept path for which Overwrite rank is defined"
#           },
#           "rank": {
#             "type": "number",
#             "description": "RAXR (1 as lowest and 100 as highest)",
#             "minimum": 0,
#             "maximum": 100
#           },
#           "canCreate": {
#             "type": "boolean",
#             "description": "If this concept was not created by other vendor can this vendor create this concept"
#           },
#           "canDelete": {
#             "type": "boolean",
#             "description": "If attribute is created by other vendor can this vendor delete this attribute if higher ranked"
#           }
#         },
#         "required": [
#           "default",
#           "rank"
#         ]
#       }
#     },
#     "dcsRanklist": {
#       "type": "array",
#       "description": "Define group Core Overwrite Rule Ranking at Data Concept Attribute Level",
#       "items": {
#         "type": "object",
#         "properties": {
#           "dcaPath": {
#             "type": "string",
#             "description": "Data Concept Attributes path for which overwrite rank is defined"
#           },
#           "rank": {
#             "type": "number",
#             "description": "RAXR (1 as lowest and 100 as highest)",
#             "minimum": 0,
#             "maximum": 100
#           },
#           "canCreate": {
#             "type": "boolean",
#             "description": "If this attribute was not created by other vendor can this vendor create this attribute"
#           },
#           "canDelete": {
#             "type": "boolean",
#             "description": "If attribute is created by other vendor can this vendor delete this attribute if higher ranked"
#           }
#         },
#         "required": [
#           "dcaPath",
#           "rank"
#         ]
#       }
#     }
#   },
#   "required": [
#     "linkuleList",
#     "criteriaList",
#     "CompanyOverwriteist"
#   ]
# }
#
# 001_C20250101A-0102_RuleData.json:
#
# {
#   "linkRuleList": [
#     {
#       "vlsCd": "VLSCD_C20250101A_0102_1",
#       "group": {
#         "groupCd": "VS_C20250101A_0102_1",
#         "groupAssociation": {
#           "type": "LINKING",
#           "rank": 99,
#           "companyCd": "COMP1"
#         },
#         "elementList": [
#           {
#             "elemCd": "VSSLE_C20250101A_0102_1",
#             "personDcaPath": "HumanModel.HumanIdentityInfo.Identity",
#             "condition": "Nnull"
#           },
#           {
#             "elemCd": "VSSLE_C20250101A_0102_2",
#             "personDcaPath": "HumanModel.HumanClassification.Nationality",
#             "condition": "Nnull"
#           },
#           {
#             "elemCd": "VSSLE_C20250101A_0102_3",
#             "personDcaPath": "HumanModel.HumanClassification.Required",
#             "condition": "Nnull"
#           }
#         ]
#       },
#       "rank": 1,
#       "criteriaList": [
#         {
#           "v1cCd": "VLCCD_C20250101A_0102_1",
#           "rank": 3,
#           "elementList": [
#             {
#               "e1emCd": "CRELE_C20250101A_0102_1",
#               "personDcaPath": "HumanModel.HumanIdentityInfo.Identity",
#               "resumeDcaPath": "HumanModel.HumanIdentityInfo.Identity",
#               "condition": "EQ"
#             },
#             {
#               "e1emCd": "CRELE_C20250101A_0102_2",
#               "personDcaPath": "HumanModel.HumanClassification.Nationality",
#               "resumeDcaPath": "HumanModel.HumanClassification.Nationality",
#               "condition": "EQ"
#             }
#           ]
#         }
#       ]
#     },
# 	{
#       "vlsCd": "VLSCD_C20250101A_0102_2",
#       "group": {
#         "groupCd": "VS_C20250101A_0102_1",
#         "groupAssociation": {
#           "type": "LINKING",
#           "rank": 10,
#           "companyCd": "COMP1"
#         },
#         "elementList": [
#           {
#             "elemCd": "VSSLE_C20250101A_0102_1",
#             "personDcaPath": "HumanModel.HumanIdentityInfo.Identity",
#             "condition": "Nnull"
#           },
#           {
#             "elemCd": "VSSLE_C20250101A_0102_2",
#             "personDcaPath": "HumanModel.HumanClassification.Nationality",
#             "condition": "Nnull"
#           },
#           {
#             "elemCd": "VSSLE_C20250101A_0102_3",
#             "personDcaPath": "HumanModel.HumanClassification.Required",
#             "condition": "Nnull"
#           }
#         ]
#       },
#       "rank": 1,
#       "criteriaList": [
#         {
#           "v1cCd": "VLCCD_C20250101A_0102_1",
#           "rank": 3,
#           "elementList": [
#             {
#               "e1emCd": "CRELE_C20250101A_0102_1",
#               "personDcaPath": "HumanModel.HumanIdentityInfo.Identity",
#               "resumeDcaPath": "HumanModel.HumanIdentityInfo.Identity",
#               "condition": "EQ"
#             },
#             {
#               "e1emCd": "CRELE_C20250101A_0102_2",
#               "personDcaPath": "HumanModel.HumanClassification.Required",
#               "resumeDcaPath": "HumanModel.HumanClassification.Required",
#               "condition": "EQ"
#             }
#           ]
#         }
#       ]
#     }
#   ],
#   "owRuleList": [
#     {
#       "group": {
#         "groupCd": "VS_C20250101A_0102_BOSS",
#         "groupAssociation": {
#           "type": "OVERWRITE",
#           "rank": 20,
#           "companyCd": "COMP1"
#         },
#         "elementList": [
#           {
#             "elemCd": "VSELE_C20250101A_0102_12",
#             "personDcaPath": "HumanModel.Human.ChannelCode",
#             "condition": "EQ",
#             "param": "COMP1-BOSS"
#           },
#           {
#             "elemCd": "VSELE_C20250101A_0102_2",
#             "personDcaPath": "HumanModel.HumanClassification.Nationality",
#             "condition": "EQ",
#             "param": "US"
#           }
#         ]
#       },
#       "defaultRank": 12,
#       "canCreate": true,
#       "companyOwRuleList": [
#         {
#           "companyCd": "COMP1",
#           "useCentralRanking": true,
#           "dcRankList": [],
#           "dcaRankList": []
#         }
#       ],
#       "dcRankList": [
#         {
#           "dcPath": "HumanModel",
#           "rank": 20,
#           "canCreate": true
#         }
#       ],
#       "dcaRankList": []
#     },
#     {
#       "group": {
#         "groupCd": "VS_C20250101A_0102_LAGOU",
#         "groupAssociation": {
#           "type": "OVERWRITE",
#           "rank": 10,
#           "companyCd": "COMP1"
#         },
#         "elementList": [
#           {
#             "elemCd": "VSELE_C20250101A_0102_11",
#             "personDcaPath": "HumanModel.Human.ChannelCode",
#             "condition": "EQ",
#             "param": "COMP1-LAGOU"
#           },
#           {
#             "elemCd": "VSELE_C20250101A_0102_2",
#             "personDcaPath": "HumanModel.HumanClassification.Nationality",
#             "condition": "EQ",
#             "param": "China"
#           }
#         ]
#       },
#       "defaultRank": 11,
#       "canCreate": true,
#       "companyOwRuleList": [
#         {
#           "companyCd": "COMP1",
#           "useCentralRanking": true,
#           "dcRankList": [],
#           "dcaRankList": []
#         }
#       ],
#       "dcRankList": [
#         {
#           "dcPath": "HumanModel",
#           "rank": 20,
#           "canCreate": true
#         }
#       ],
#       "dcaRankList": []
#     }
#   ]
# }
#
# 010_Testing_Data.xlsx
#
# Jira No.	Order	PERSON	Type	Human.CompanyCode	Human.ChannelCode	Human.Scope	Human.CanBeUpdate	Human.IsVirtual	HumanDates.EffectiveDate	HumanDates.BirthDate	HumanClassification.Nationality	HumanClassification.Required	HumanClassification.Resume	HumanClassification.Skill1	HumanClassification.Skill2	HumanResume.Resume	HumanResume.Version	HumanIdentityInfo.Identity	HumanIdentityInfo.IdentityVersion	HumanHierarchicalRelation.ParentPerson	HumanHierarchicalRelation.ParentResume	HumanUpdateInfo.UpdatedQualifier	HumanUpdateInfo.OldValue	HumanUpdateInfo.NewValue
# 0102	1	01021	I	/	COMPANY-LACOU_0102	earth	Y	N	2024-02-01T01:00:00Z	2024-02-01T01:00:00Z	CHINA	YES	CHINESE	PROGRAMMING	java	/	1	earth01	1	/	/	/	/	/
# 0102	2	01021	I	/	COMPANY-BOSS_0102	earth	Y	N	2024-02-01T01:00:00Z	2024-02-01T01:00:00Z	US	YES	CHINESE	PROGRAMMING	java	/	1	earth01	1	/	/	/	/	/
#
# """
