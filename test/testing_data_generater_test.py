from tool.testing_data_prepare_tool import TestingDataGenerator

testDataGenerator = TestingDataGenerator()

jira = """
Summary: link one vin to an existing cain if the vin meet the linking strategy
Role: BA
Goal: not generate duplicate cain
Scenarios:
- link the vin to an existing cain if the vin meet the linking strategy
Acceptance Criteria:
- check the vin status(should be completed)
- check the count of cain(should be 1)
- check the count of vin linked to the cain (should be 2, assume there is only vin link to the cain before the vin is processed)
- check the cain version(should be 2, assume the new vin is different from the cain and the new vin has higher priority than the vin link to the cain)

Data:
1. prepare testing rules
- refer to 002_RuleGeneration_Prompt.txt(provide testing rule needs through rule template)
- provide more info - pending on result
2. prepare testing data
- prepare two piece of data with different vendor code but same HUB info, announcement date is different
- provide more info - pending on result
"""
testDataGenerator.testing_data_generate(jira)
