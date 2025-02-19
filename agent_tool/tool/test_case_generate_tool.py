import argparse
import logging
from typing import Annotated

from langchain_core.tools import tool

from core.llm_chat import LLMChat

from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE


@tool("test_case_generate_tool")
def test_case_generate_tool(
        jira_request: Annotated[str, 'local repository file path'],
        project_document: Annotated[str, 'the change suggestions'],
        qa_context: Annotated[str, 'the change suggestions'],
        qa_object: Annotated[str, 'the change suggestions'],
        test_case_example: Annotated[str, 'the change suggestions'],
        test_case_guide: Annotated[str, 'the change suggestions']):
    """Generate test case base on JIRA Description"""
    test_case_generator = TestCaseGenerator()
    test_case_generator.test_cases_generate(jira_request, project_document, qa_context, qa_object, test_case_example,
                                            test_case_guide)


class TestCaseGenerator:
    def test_cases_generate(self, jira_request, project_document, qa_context, qa_object, test_case_example,
                            test_case_guide=""):
        logging.basicConfig(level=logging.INFO)
        logging.info('Generate test case start')

        parameters = {
            "qa_context": qa_context,
            "qa_object": qa_object,
            "jira_content": jira_request,
            "project_document": project_document,
            "test_case_example": test_case_example,
            "test_case_guide": test_case_guide
        }

        test_case = (
            LLMChat(model_type='ADVANCED').prompt_with_parameters(GENERATE_TEST_CASE_KNOWLEDGE, parameters,
                                                                  'Generate test case',
                                                                  desc='Generate test case base on JIRA Description')
            .replace("```json", '').replace("```", ''))

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledges/" + case + "/result/test_case_generated.txt"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(test_case)

        logging.info('Generate test case result:' + test_case)
        return test_case
