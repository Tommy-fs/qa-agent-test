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
Review test cases by below steps:
a. Read project document, JIRA request, test summary and test steps of existing test case to understand the logic and requirements
b. Check the existing test cases and new generated test cases one by one, if the new generated case already exists in the original test case and the logic is the same, then use the original test case
c. Check the existing test cases and new generated test cases one by one, If the existing test case does not have a similar one with new generated test case, add a new test case
d. Check the existing test cases and new generated test cases one by one, if the new generated case already exists in the original test case, but the logic is different, the original test case should be updated based on the generated test case

# RESPONSE #

a. The output is divided into three parts. The first part is the original test case that can be reused in this JIRA request. The second part is what was not originally available and needs to be added. The third part is what was originally available but the logic needs to be modified
b. Output the generated test case which already exists in the original test case library and the logic is the same, which can be used in this JIRA REQUEST
b. Output the generated test cases that do not exist in the original test cases and need to be added
c. Output the generated test cases that need to be updated on the original test cases, and provide the updated test cases
#############
"""