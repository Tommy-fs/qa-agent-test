GENERATE_TEST_CASE_KNOWLEDGE = """
# CONTEXT #
{qa_context}

#############

# OBJECTIVE #

#############

# PROJECT DOCUMENT #
{project_document}

#############

# JIRA REQUEST #
{jira_content}

#############

# TEST PURPOSE #
Regression Functional testing

#############

# TEST DATA #
Mock test data by your understanding

#############

# LIMITATION #
For test data, Email Subject must use this format: Subject-001, Subject-002

#############

# STYLE #
Style refer to the successful software company, such Google, Microsoft.
You need to refer to existing Test Cases,  take them as Example, learn writing habit and format to write test case:

#############

#Test Case Example#
{test_case_example}

#############

# TONE #
Professional, technical

#############

# AUDIENCE #
Test cases should be detailed and easy to understood, junior tester will test system step by step, follow your test case.

#############

# RESPONSE #
Output test cases steps as table with  table heads : |No.| Test Step | Test Data | Expected Result |, Test Data means the input in Test Step

#############

"""
