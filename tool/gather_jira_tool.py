import logging

from langchain_core.tools import tool

from util import knowledge_util


@tool("gather_jira")
def gather_jira():
    """Collect the JIRA requirement for generating test cases."""
    jira_gather = JiraGather()
    return jira_gather.gather_jira_document()


class JiraGather:

    def gather_jira_document(self):
        logging.basicConfig(level=logging.INFO)
        logging.info(
            'Collect the JIRA requirement for generating test cases')

        jira = knowledge_util.get_jira_info("JIRA", "jira")

        context = f"\n# JIRA REQUIREMENT #\n{jira}\n"

        return context
