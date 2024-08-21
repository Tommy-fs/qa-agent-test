import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from knowledges.project_document import PROJECT_DOCUMENT
from knowledges.test_case_suggestion import TEST_CASE_REVIEW


class Suggestion(BaseModel):
    generated_test_cases: str = Field(
        description='A paragraph about the generated test cases based on JIRA requirements, including name, summary, priority and steps. The format is str.')
    similar_test_cases: str = Field(
        description='A paragraph about the similar test cases found in vector db, including name, summary, priority and steps. The format is str.')
    jira_request: str = Field(
        description='A paragraph about the specific Jira requirement, including summary and description, The format is str.')
    project_document: str = Field(description='A paragraph about Detailed project documentation, The format is str.')


def test_cases_suggestion(generated_test_cases, similar_test_cases, jira_request, project_document):
    similar_test_cases ="""
    Priority: Critical
Name: TicketingLogic-002
Summary: Reply email with changed subject of existing ticket should update ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Update  ticket XL001 in Test APP |
| 5 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is updated from Subject1 to Subject2 |
    """
    generated_test_cases = """
        #Test Case 1#
    Priority: Critical
    Name: TicketingLogic-002
    Summary: Reply email with change Subject to create new Ticket
    Steps:
    | No. | Test Step                                      | Test Data                  | Expected Result                                      |
    |-----|-------------------------------------------------|----------------------------|------------------------------------------------------|
    | 1   | Send email to DL1 with Subject1 and Body1       | DL1, Subject1, Body1       | Create new ticket XL001 in Test APP                  |
    | 2   | Reply to email with Subject1 and change to Subject2 | Subject2                   | Create new ticket XL002 in Test APP                  |
    | 3   | Open Test APP WebUI to check ticket XL001        | XL001                      | Ticket XL001 is created with Subject1 and Body1      |
    | 4   | Open Test APP WebUI to check ticket XL002        | XL002                      | Ticket XL002 is created with Subject2                |
        """
    jira_request = """
        Summary: Ticketing Logic - reply email to create new Ticket 1
        Description: 
        Reply email 1 with change Subject to Subject 2, will create ticket XL002 in Test APP
        Steps to Reproduce: 
            1. Send email with Subject1 to create new ticket XL001
            2. Reply email with change Subject1 to Subject 2
        Expected Result: 
            1. Ticket XL001 is not update
            2. Ticket XL002 is created with Subject2
        """

    project_document=PROJECT_DOCUMENT
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Review test case',
                     desc='Review test case, Compare the newly produced test cases with similar test cases. Provide suggestions for using the original test case, modifying the original test case, or adding a new test case.')

    parameters = {
        "similar_test_cases": similar_test_cases,
        "project_document": project_document,
        "generated_test_cases": generated_test_cases,
        "jira_content": jira_request
    }

    suggestion = (
        LLMChat().prompt_with_parameters(TEST_CASE_REVIEW, parameters, 'Review test case',
                                         desc='Review test case, compare with previous test cases to see if updates or additions are needed.')
        .replace("```json", '').replace("```", ''))

    log.on_log_end(generate_id)
    return suggestion
