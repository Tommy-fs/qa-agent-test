import re
import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.log_handler import LoggingHandler
from core.test_case_manager import TestCasesManager


class Searcher(BaseModel):
    generated_test_cases: str = Field(
        description='A paragraph about the generated test cases based on JIRA requirements, including name, summary, priority and steps. The format is str.')
    jira_request: str = Field(
        description='A paragraph about the specific Jira requirement, including summary and description, The format is str.')


def split_test_cases(inputs):
    split_strings = re.split(r'"}\nPriority', inputs)
    split_strings = [s + '"}' if i == 0 else 'Priority' + s for i, s in enumerate(split_strings)]

    test_cases_list = [s.strip() for s in split_strings]

    return test_cases_list


def test_cases_similar_search(generated_test_cases, jira_request):
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
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Search test case',
                     desc='Search test case, Find similar test cases in the vector database.')

    test_case_manager = TestCasesManager()

    similar_cases_in_library = []
    test_case_list = split_test_cases(generated_test_cases)

    for test_case in test_case_list:
        test_case_json = test_case_manager.parse_test_case(test_case_text=test_case)
        summary = test_case_json["summary"]
        similar_cases_in_library.append(test_case_manager.search_test_cases(test_case))

    unique_similar_cases = similar_cases_in_library

    unique_similar_cases_txt = []
    for similar_case_list in unique_similar_cases:
        for similar_case in similar_case_list:
            unique_similar_cases_txt.append(test_case_manager.reverse_parse_test_case(test_case=similar_case))

    delimiter = "\n"

    similar_test_cases = delimiter.join(unique_similar_cases_txt)

    log.on_log_end(generate_id)
    return similar_test_cases
