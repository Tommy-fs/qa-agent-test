import argparse
import logging
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE
from knowledges.qa_context import QA_CONTEXT, QA_OBJECT


@tool("test_case_generate")
def test_case_generate(
        jira_request: Annotated[str, 'local repository file path'],
        project_document: Annotated[str, 'the change suggestions'],
        test_case_example: Annotated[str, 'the change suggestions'],
        test_case_guide: Annotated[str, 'the change suggestions']):
    """Generate test case base on JIRA Description"""
    test_case_generator = TestCaseGenerator()
    test_case_generator.test_cases_generate(jira_request, project_document, test_case_example, test_case_guide)


class TestCaseGenerator:
    def test_cases_generate(self, jira_request, project_document, test_case_example, test_case_guide=""):
        logging.basicConfig(level=logging.INFO)
        logging.info('Generate test case start')

        parameters = {
            "qa_context": QA_CONTEXT,
            "qa_object": QA_OBJECT,
            "jira_content": jira_request,
            "project_document": project_document,
            "test_case_example": test_case_example,
            "test_case_guide": test_case_guide
        }

        prompt = GENERATE_TEST_CASE_KNOWLEDGE.format(
            qa_context=parameters["qa_context"],
            qa_object=parameters["qa_object"],
            jira_content=parameters["jira_content"],
            project_document=parameters["project_document"],
            test_case_example=parameters["test_case_example"],
            test_case_guide=parameters["test_case_guide"]
        )

        agent = Agent()
        # agent.context.add_context("system", CODE_GENERATOR_SYSTEM_MESSAGE)
        # agent.background = f"here is source code: {files_dict_before.to_chat().replace('{', '{{').replace('}', '}}')}"

        test_case = agent.execute(prompt)
        logging.info("AI response:")
        logging.info(test_case)

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledges/" + case + "/result/test_case_generated.txt"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(test_case)

        # file_path = "../result/test_case_generated" + datetime.now().strftime("%Y-%m-%d") + ".txt"
        # with open(file_path, 'w', encoding='utf-8') as file:
        #     file.write(test_case)

        logging.info('Generate test case result:' + test_case)
        return test_case
