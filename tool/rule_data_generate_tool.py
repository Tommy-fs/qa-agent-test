import argparse
import logging
from typing import Annotated
from datetime import datetime
from agent_core.agents import Agent
from langchain_core.tools import tool

from knowledge.generate_rule_data import GENERATE_RULE_DATA_PROMPT
from util import knowledge_util


@tool("rule_data_generate_tool")
def rule_data_generate_tool(jira_number: Annotated[str, 'the related jira number']):
    """Generate test case base on JIRA Description and related Document"""
    rule_data_generator = RuleDataGenerator()
    return rule_data_generator.rule_data_generate(jira_number)


class RuleDataGenerator:
    def rule_data_generate(self, jira_number="001"):
        logging.basicConfig(level=logging.INFO)
        logging.info('Generate rule data start')

        rule_json_model_schema = knowledge_util.get_other_knowledge("000_RuleJsonModelSchema.json")
        rule_data = knowledge_util.get_other_knowledge("001_C20250101A-0102_RuleData.json")

        prompt = GENERATE_RULE_DATA_PROMPT.format(
            jira_number=jira_number,
            rule_json_model_schema=rule_json_model_schema,
            rule_data=rule_data
        )

        agent = Agent(model_name="gemini-1.5-flash-002")

        rule_data = agent.execute(prompt)
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledge/" + case + "/result/rule_data_generated_" + datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S") + ".json"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(rule_data.replace("```json", '').replace("```", ''))

        logging.info("Rule data has been wrote in " + file_path)

        return rule_data.replace("```json", '').replace("```", '')
