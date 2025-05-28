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

QA_KNOWLEDGE = """
To create test cases, you need to follow the following steps:
1. Gather the JIRA requirement to understand requirement.
2. Gather related documents to understand background, document including project_document, test_case_example, test_case_guide.
3. Generate test cases: Generate corresponding test cases base on JIRA requirements, project documents and QA Object.
4. Prepare rule data: Prepare rule data based on the provided files.
5. Prepare test data: Prepare test data based on the provided files.
6. Generate cucumber scripts: Generate cucumber script base on generated test cases.
"""

