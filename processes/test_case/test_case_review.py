import uuid

from core.llm_chat import LLMChat
from knowledges.test_case_suggestion import TEST_CASE_REVIEW
from knowledges.project_document import PROJECT_DOCUMENT
from processes.process import Process


class TestCaseReview(Process):

    def __init__(self):
        super().__init__("review test case")

    def execute(self, inputs, jira_request, existing_test_cases, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Review test case',
                         desc='Review test case, compare with previous test cases to see if updates or additions are needed.')

        parameters = {
            "existing_test_case": existing_test_cases,
            "project_document": PROJECT_DOCUMENT,
            "generated_test_cases": inputs,
            "jira_content": jira_request
        }

        test_case = (
            LLMChat().prompt_with_parameters(TEST_CASE_REVIEW, parameters, 'Review test case',
                                             desc='Review test case, compare with previous test cases to see if updates or additions are needed.')
            .replace("```json", '').replace("```", ''))

        log.on_log_end(generate_id)
        return test_case
