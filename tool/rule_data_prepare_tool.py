import argparse
import logging
from datetime import datetime
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from knowledge.prepare_rule_data import PREPARE_RULE_DATA_PROMPT
from util import knowledge_util


@tool("rule_data_prepare_tool")
def rule_data_prepare_tool():
    """prepare rule data base on related Document"""
    rule_data_generator = RuleDataGenerator()
    return rule_data_generator.rule_data_prepare()


class RuleDataGenerator:
    def rule_data_prepare(self):
        logging.basicConfig(level=logging.INFO)
        logging.info('Prepare rule data start')

        rule_json_model_schema = knowledge_util.get_other_knowledge("000_RuleJsonModelSchema.json")
        rule_data = knowledge_util.get_other_knowledge("001_C20250101A-0102_RuleData.json")
        rule_generation_prompt = knowledge_util.get_other_knowledge("002-RuleGeneration_Prompt.txt")

        prompt = PREPARE_RULE_DATA_PROMPT.format(
            rule_generation_prompt=rule_generation_prompt,
            rule_json_model_schema=rule_json_model_schema,
            rule_data=rule_data
        )

        agent = Agent(model_name="gemini-1.5-pro-002")

        rule_data_generated = agent.execute(prompt)
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledge/" + case + "/result/rule_data_prepared_" + datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S") + ".json"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(rule_data_generated.replace("```json", '').replace("```", ''))

        logging.info("Rule data has been wrote in " + file_path)

        return rule_data_generated.replace("```json", '').replace("```", '')
