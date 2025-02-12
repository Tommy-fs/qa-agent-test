import argparse
import uuid
from typing import Annotated

from langchain.pydantic_v1 import BaseModel, Field
from langchain_core.tools import tool

from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE


@tool("test_case_generate_tool")
def test_case_generate_tool(
        jira_request: Annotated[str, 'local repository file path'],
        project_document: Annotated[str, 'the change suggestions'],
        qa_context: Annotated[str, 'the change suggestions'],
        qa_object: Annotated[str, 'the change suggestions'],
        test_case_example: Annotated[str, 'the change suggestions'],
        test_case_guide: Annotated[str, 'the change suggestions']):
        """Build the project locally to test and verify the results of the implemented changes"""
        test_cases_generate(jira_request, project_document, qa_context, qa_object, test_case_example, test_case_guide)


class TestCaseGenerator(BaseModel):
    jira_request: str = Field(
        description='A paragraph about the specific Jira requirement, including summary and description, The format is str.')
    project_document: str = Field(description='A paragraph about Detailed project documentation, The format is str.')
    qa_context: str = Field(description='A paragraph about QA CONTEXT, The format is str.')
    qa_object: str = Field(description='A paragraph about QA OBJECT, The format is str.')
    test_case_example: str = Field(description='A paragraph about TEST CASE EXAMPLE, The format is str.')
    test_case_guide: str = Field(description='A paragraph about TEST CASE GUIDE, The format is str.')


def test_cases_generate(jira_request, project_document, qa_context, qa_object, test_case_example, test_case_guide=""):
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

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

    log.on_log_end(generate_id)
    return test_case
