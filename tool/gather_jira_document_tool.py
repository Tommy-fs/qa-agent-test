import logging

from langchain_core.tools import tool

from util import knowledge_util


@tool("gather_jira_document")
def gather_jira_document():
    """Collect the JIRA requirement and any related project documents necessary for generating test cases."""
    document_gather = DocumentGather()
    return document_gather.gather_jira_document()


class DocumentGather:

    def gather_jira_document(self):
        logging.basicConfig(level=logging.INFO)
        logging.info(
            'Collect the JIRA requirement and any related project documents necessary for generating test cases')

        project_document = knowledge_util.get_project_knowledge("PROJECT_DOCUMENT", "project_document")

        test_case_example = knowledge_util.get_project_knowledge("TEST_CASE_EXAMPLE", "test_case_example")

        test_case_guide = knowledge_util.get_project_knowledge("TEST_CASE_GUIDE", "test_case_example")

        jira = knowledge_util.get_jira_info("JIRA", "jira")

        context = f"\n# JIRA REQUIREMENT #\n{jira}\n"
        context += f"\n# PROJECT_DOCUMENT #\n{project_document}\n"
        context += f"\n# TEST_CASE_EXAMPLE #\n{test_case_example}\n"
        context += f"\n# TEST_CASE_GUIDE #\n{test_case_guide}\n"

        return context
