GENERATE_TEST_CASE_KNOWLEDGE = """
# CONTEXT #
{qa_context}

#############

# OBJECTIVE #
{qa_object}

#############

# PROJECT DOCUMENT #
{project_document}

#############

# JIRA REQUEST #
{jira_content}

#############

#Test Case Guide#
You need to strictly follow the following rules and guidelines to generate test cases(If exists)
{test_case_guide}

#############

#Test Case Template#
You need to understand and imitate this case to write a new test case， Strictly follow the output format of this test case
{test_case_example}

#############

# TEST PURPOSE #
Regression Functional testing

#############

# TEST DATA #
Mock test data by your understanding and related document.

#############

# STYLE #
Style refer to the successful software company, such Google, Microsoft.
You need to refer to existing Test Cases,  take them as Example, learn writing habit and format to write test case:

#############

# TONE #
Professional, technical

#############

# AUDIENCE #
Test cases should be detailed and easy to understood, junior tester will test system steps by steps, follow your test case.

#############

# RESPONSE #

1. Output test cases with name, summary, priority and steps.
2. Output test cases steps as table with  table heads : |No.| Test Step | Test Data | Expected Result |, Test Data means the input in Test Step
3. If there are multiple test cases output, use split lines (---) to split each test case

#############

# LIMITATION #
1. Output cannot have any extra content, only name, summary, priority and steps tables.
2. The output steps table of test case must be aligned with each column, and you need to automatically adjust it.
3. Merge as many test cases as possible that repeat most steps into one case.

#############

"""
