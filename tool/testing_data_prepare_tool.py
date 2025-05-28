import argparse
import logging
from datetime import datetime
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from knowledge.prepare_test_data import PREPARE_TEST_DATA_PROMPT
from util import knowledge_util


@tool("testing_data_prepare_tool")
def testing_data_prepare_tool(
        jira_request: Annotated[str, 'the actual jira request']):
    """prepare test data base on JIRA Description and related Document"""
    testing_data_generator = TestingDataGenerator()
    return testing_data_generator.testing_data_prepare(jira_request)


class TestingDataGenerator:
    def testing_data_prepare(self, jira_request):
        logging.basicConfig(level=logging.INFO)
        logging.info('prepare testing data start')

        testing_data = knowledge_util.get_other_knowledge("testing_data.csv")

        prompt = PREPARE_TEST_DATA_PROMPT.format(
            testing_data=testing_data,
            requirement=jira_request,
        )

        agent = Agent(model_name="gemini-1.5-pro-002")

        rule_data = agent.execute(prompt)
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledge/" + case + "/result/testing_data_prepared_" + datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S") + ".csv"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(rule_data.replace("```json", '').replace("```", ''))

        logging.info("Rule data has been wrote in " + file_path)

        return rule_data.replace("```json", '').replace("```", '')
