TEST_CASE_REVIEW = """
# CONTEXT #
We are a software company, and you are our software test expert. There are now some test cases that have just been generated base on Jira request, and you need to compare them with previous test cases to see if they need to be updated or added.

#############

# PROJECT DOCUMENT #
{project_document}

#############

# JIRA REQUEST #
{jira_content}

#############

#############
# EXISTING TEST CASE #
{existing_test_case}

# GENERATED TEST CASES #
{generated_test_cases}

# OBJECTIVE #
Review existing test cases by below steps:
a. Read test summary and test steps of existing test case to understand the logic and requirements
b. Check the existing test cases one by one, if test case logic is updated by this JIRA, update test case with new JIRA requirements, then report the update details
c. Check new generated test cases one by one, if new generated test case is same as existing test case, then use the existing test case and remove new test generated test case

# RESPONSE #
Output the details of all existing test cases which need to be updated as a list of Test Case one by one:  Test Case Summary, reason of why update the Test Case
Output the generated test cases which need to be updated steps as table with table heads : |No.| Test Step | Test Data | Expected Result |, Test Data means the input in Test Step
Output the generated test cases which need to be added steps as table with  table heads : |No.| Test Step | Test Data | Expected Result |, Test Data means the input in Test Step

#############
"""