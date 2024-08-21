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

# EXISTING TEST CASES #
{similar_test_cases}

#############

# GENERATED TEST CASES #
{generated_test_cases}

#############

# OBJECTIVE #
Review test cases by below steps:
a. Read project document, JIRA request to understand the logic and requirements
b. Read GENERATED TEST CASES and EXISTING TEST CASES one by one, understand the summary and each step
c. Compare the new generated test cases one by one with the existing test cases.
   If the summary of the newly generated test case is consistent with the existing test case and the logic of each step is the same, all step of existing test case meet the needs of Jira request, then it is considered that the <existing test case can be used>.
   If the summary of the newly generated test case is similar to the existing test case, but the step logic is inconsistent, and the existing case does not satisfy this jira request, then it is considered that the <existing test case needs to be modified>, and do not considered it as the <test cases needs to be added>. Provide a modification plan
   If the newly generated test case does not have a similar one with existing test cases. That is considered as the <test cases needs to be added>.
   
# RESPONSE #
The output is divided into three parts. 
a. The first part is the <existing test case can be used>.
b. The second part is the <existing test case needs to be modified>, with existing test case, modification suggestions and comparisons before and after the modification
c. The third part is <test cases needs to be added>.

#############
"""