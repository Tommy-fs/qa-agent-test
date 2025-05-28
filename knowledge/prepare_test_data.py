PREPARE_TEST_DATA_PROMPT = """

Please refer to the template (testing_data.csv), testing-data-logic and requirement to fill the testing data in the template. and output format is csv.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
requirement:
Find the 'prepare testing data' related requirement
{requirement}

----------------------------------------------------------------------------------------------------------------------------------------------------------------
testing-data-logic:

- Jira No., will be provided in testing data preparation
- Order, int type, start from 1
- PERSON, int, format is 'jiraNo<index>, start with minus '-', combine with jiraNo and index, index is int starting from 1
- Type, two values, 'I' indicates 'insert', 'U' indicates update
- Human.CompanyCode, default value '/'
- Human.ChannelCode, format is 'JIRA_jiraNo_COMPANY-DS<Index>_jiraNo', index is int type starting from 1, for example 'JIRA-0102-COMPANY_DS1_0102'
- Human.Scope, three values, 'EARTH', COUNTRY', 'PROVINCE'
- Human.CanBeUpdate, default value 'Y'
- Human.IsVirtual, for one jira, if only having EARTH level PERSON, IsVirtual is 'N';
    - If having EARTH and COUNTRY level PERSON, IsVirtual of EARTH PERSON is 'Y', IsVirtual of COUNTRY PERSON is 'N';
    - If having EARTH, COUNTRY and PROVINCE PERSON, IsVirtual of EARTH PERSON is 'Y', IsVirtual of COUNTRY PERSON is 'Y', IsVirtual of PROVINCE PERSON is 'N'
- Dates.EffectiveDate, type is time, format is '2024-02-02702:00:00Z'
- Dates.BirthDate, type is time, format is '2024-02-02702:00:00Z'
- HumanClassification.Nationality, default value is 'CHINA'
- HumanClassification.Required, three value, 'CHOS', 'Y', 'N'
- HumanClassification.Language, default is 'CHINESE'
- HumanClassification.Skill1, values in list ('PUTONGHUA', 'FANGYAN')
- HumanClassification.Skill2, if Skill1 is 'FANGYAN', values in list ('FANGYAN1', 'FANGYAN2'),
  if HumansSubTypeLevel1 is PUTONGHUA, value is '/'
- HumanResume.Resume, default value is '/'
- HumanResume.Version, type is time, start from 1, if need to update PERSON, need to increase the version
- HumanIdentityInfo.Identity, type is string, format is 'EARTH<Index>, index is int starting from 1
- HumanIdentityInfo.IdentityVersion, type is int starting from 1, increase the value if having multi PERSON
- HumanHierarchicalRelation.ParentPerson, for one jira and ChannelCode, value of EARTH PERSON is '/'; value of COUNTRY PERSON is PERSON number of EARTH PERSON;
  Value of PROVINCE PERSON is PERSON number of COUNTRY PERSON
- HumanHierarchicalRelation.ParentResume, default value is '/'
- HumanUpdateInfo.UpdatedQualifier, UpdatedQualifier, oldValue and NewValue appear in pairs, one PERSON may have multi pairs, type is string
    - if value HumansSubTypeLevel2 is 'FANGYAN1', value is 'LANGUAGE-FANGYAN1'
    - if value HumansSubTypeLevel2 is 'FANGYAN2', value is 'LANGUAGE-FANGYAN2'
- HumanUpdateInfo.OldValue, UpdatedQualifier, oldValue and NewValue appear in pairs, one PERSON may have multi pairs, type is string
- HumanUpdateInfo.NewValue, UpdatedQualifier, OldValue and NewValue appear in pairs, one PERSON may have multi paris, type is string, value is different from OldValue
 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
testing_data.csv:

{testing_data}

----------------------------------------------------------------------------------------------------------------------------------------------------------------
format:

Do not generate Explanation and other useless string, the output must be csv format

"""
