from typing import Callable, Any

from langchain_core.tools import StructuredTool

from tool.project_understand_tool import understand_project_tool
from tool.test_case_generate_tool import Generator
from tool.test_case_generate_tool import generate_test_cases
from tool.test_case_similar_search_tool import Searcher
from tool.test_case_similar_search_tool import test_cases_similar_search
from tool.test_case_suggestion_tool import test_cases_suggestion, Suggestion


def generate_tools() -> list[Callable[..., Any]]:
    return [
        StructuredTool.from_function(
            func=understand_project_tool,
            name='Understand project tool',
            description='Learn knowledge related to projects, qa_object, qa_context and test_case_example.'
        ),
        StructuredTool.from_function(
            func=generate_test_cases,
            name='Generate test cases tool',
            description='Generate corresponding test cases based on JIRA requirements, project documentation, test case examples, and QA_OBJECT.',
            args_schema=Generator
        ),
        StructuredTool.from_function(
            func=test_cases_similar_search,
            name='Similar test cases search tool',
            description='Review test case, Find similar test cases in the vector database.',
            args_schema=Searcher
        ),
        StructuredTool.from_function(
            func=test_cases_suggestion,
            name='test cases suggestion  tool',
            description='Review test case, Compare the newly produced test cases with similar test cases. Provide suggestions for using the original test case, modifying the original test case, or adding a new test case.',
            args_schema=Suggestion
        )
    ]
