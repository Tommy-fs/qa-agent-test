import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE


class Generator(BaseModel):
    jira_request: str = Field(description='A paragraph about the specific Jira requirement, including summary and description, The format is str.')
    project_document: str = Field(description='A paragraph about Detailed project documentation, The format is str.')
    qa_context: str = Field(description='A paragraph about QA CONTEXT, The format is str.')
    qa_object: str = Field(description='A paragraph about QA OBJECT, The format is str.')
    test_case_example: str = Field(description='A paragraph about TEST CASE EXAMPLE, The format is str.')


def test_cases_generate(jira_request, project_document, qa_context, qa_object, test_case_example):
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

    parameters = {
        "qa_context": qa_context,
        "qa_object": qa_object,
        "jira_content": jira_request,
        "project_document": project_document,
        "test_case_example": test_case_example
    }

    test_case = (
        LLMChat().prompt_with_parameters(GENERATE_TEST_CASE_KNOWLEDGE, parameters, 'Generate test case',
                                         desc='Generate test case base on JIRA Description')
        .replace("```json", '').replace("```", ''))

    log.on_log_end(generate_id)
    return test_case
