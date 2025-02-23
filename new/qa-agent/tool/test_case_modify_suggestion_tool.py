import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from knowledges.test_case_suggestion import TEST_CASE_REVIEW


class Suggester(BaseModel):
    generated_test_cases: str = Field(
        description='A paragraph about the generated test cases based on JIRA requirements, including name, summary, priority and steps. The format is str.')
    similar_test_cases: str = Field(
        description='A paragraph about the similar test cases found in vector db, including name, summary, priority and steps. The format is str.')
    jira_request: str = Field(
        description='A paragraph about the specific Jira requirement, including summary and description, The format is str.')
    project_document: str = Field(description='A paragraph about Detailed project documentation, The format is str.')


def test_cases_suggestion(generated_test_cases, similar_test_cases, jira_request, project_document):
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
