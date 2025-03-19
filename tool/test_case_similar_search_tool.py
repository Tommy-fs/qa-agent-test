import re
import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.log_handler import LoggingHandler
from core.test_case_manager import TestCasesManager
from knowledge.test_case_search import TEST_CASE_SEARCH_PROMPT


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
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Search test case',
                     desc='Search test case, Find similar test cases in the vector database.')

    test_case_manager = TestCasesManager()

    similar_cases_in_library = []
    test_case_list = split_test_cases(generated_test_cases)

    for test_case in test_case_list:
        # test_case_json = test_case_manager.parse_test_case(test_case_text=test_case)
        # summary = test_case_json["summary"]
        similar_cases_in_library.append(
            test_case_manager.search_test_cases(TEST_CASE_SEARCH_PROMPT.format(generated_test=test_case)))

    unique_similar_cases = similar_cases_in_library

    unique_similar_cases_txt = []
    for similar_case_list in unique_similar_cases:
        for similar_case in similar_case_list:
            unique_similar_cases_txt.append(test_case_manager.reverse_parse_test_case(test_case=similar_case))

    delimiter = "\n"

    similar_test_cases = delimiter.join(unique_similar_cases_txt)

    log.on_log_end(generate_id)
    return similar_test_cases
