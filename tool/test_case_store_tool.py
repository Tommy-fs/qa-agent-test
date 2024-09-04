import json
import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from core.test_case_manager import TestCasesManager
from knowledges.store_test_case import STORE_TEST_CASE_PROMPT


class Storer(BaseModel):
    test_cases_reviewed_suggestion: str = Field(
        description='A paragraph about suggestions for modifying the vector database data after the test review, The format is str.')


def test_cases_store(test_cases_reviewed_suggestion):
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Store test case', desc='Modify the test cases in the vector database based on the recommendations of the test case view')
    parameters = {
        "test_cases_reviewed_suggestion": test_cases_reviewed_suggestion,
    }

    db_change_plan = (
        LLMChat().prompt_with_parameters(STORE_TEST_CASE_PROMPT, parameters, 'Store test case',
                                         desc='Store test case in vector db'))

    db_change_plan_dict = json.loads(db_change_plan.replace("```json", '').replace("```", ''))
    added_test_cases = db_change_plan_dict['added_test_cases']
    modified_test_cases = db_change_plan_dict['modified_test_cases']
    test_case_manager = TestCasesManager()

    for case in added_test_cases:
        test_case_manager.store_test_case(case)

    for case in modified_test_cases:
        test_case_manager.modify_test_case(case['id'], case['test_case'])
    log.on_log_end(generate_id)
    return db_change_plan
