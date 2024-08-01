import uuid

from core.llm_chat import LLMChat
from core.planner import Planner
from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE
from knowledges.test_case_example import TEST_CASE_EXAMPLE
from knowledges.qa_context import QA_CONTEXT
from knowledges.qa_context import QA_OBJECT
from knowledges.project_document import PROJECT_DOCUMENT
from processes.process import Process
import re


class TestCaseGenerate(Process):

    def __init__(self):
        super().__init__("generate test case")

    def execute(self, inputs, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

        parameters = {
            "qa_context": QA_CONTEXT,
            "qa_object": QA_OBJECT,
            "jira_content": inputs,
            "project_document": PROJECT_DOCUMENT,
            "test_case_example": TEST_CASE_EXAMPLE
        }

        test_case = (
            LLMChat().prompt_with_parameters(GENERATE_TEST_CASE_KNOWLEDGE, parameters, 'Generate test case',
                                             desc='Generate test case base on JIRA Description')
            .replace("```json", '').replace("```", ''))

        log.on_log_end(generate_id)
        return test_case

    def execute_by_step(self, inputs, log):
        parameters = {
            "qa_context": QA_CONTEXT,
            "qa_object": QA_OBJECT,
            "jira_content": inputs,
            "project_document": PROJECT_DOCUMENT,
            "test_case_example": TEST_CASE_EXAMPLE
        }

        request = GENERATE_TEST_CASE_KNOWLEDGE.format(
            qa_context=parameters.get("qa_context", ""),
            qa_object=parameters.get("qa_object", ""),
            project_document=parameters.get("project_document", ""),
            jira_content=parameters.get("jira_content", ""),
            test_case_example=parameters.get("test_case_example", "")
        )
        planner = Planner()
        steps = planner.plan(request, background=QA_CONTEXT + QA_OBJECT, knowledge=PROJECT_DOCUMENT)

    def split_test_cases(self, inputs):
        split_strings = re.split(r'"}\nPriority', inputs)
        split_strings = [s + '"}' if i == 0 else 'Priority' + s for i, s in enumerate(split_strings)]

        test_cases_list = [s.strip() for s in split_strings]

        return test_cases_list
