import argparse
import logging
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from knowledges.generate_cucumber_script import GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE


@tool("cucumber_script_generate")
def cucumber_script_generate(
        generated_test_cases: Annotated[str, 'local repository file path']):
    """Generate test case base on JIRA Description"""
    test_case_script_generator = CucumberScriptGenerator()
    test_case_script_generator.cucumber_script_generate(generated_test_cases)


class CucumberScriptGenerator:
    def cucumber_script_generate(self, generated_test_cases):
        logging.basicConfig(level=logging.INFO)
        logging.info('Generate cucumber script start')

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        cucumber_script_basic_template = self.readFile(
            "../knowledges/" + case + "/cucumber_knowledges/cucumber_script_base.feature")
        available_web_elements = self.readFile("../knowledges/" + case + "/cucumber_knowledges/WebElement.yml")
        available_webui_cucumber_system_steps = self.readFile(
            "../knowledges/" + case + "/cucumber_knowledges/fast_webui_cucumber_system_steps.txt")
        available_webui_cucumber_project_steps = self.readFile(
            "../knowledges/" + case + "/cucumber_knowledges/fast_webui_cucumber_project_steps.txt")
        script_generate_guide = self.readFile(
            "../knowledges/" + case + "/cucumber_knowledges/script_generate_guide.txt")
        project_document = self.readFile(
            "../knowledges/" + case + "/project_knowledges/project_document.py")

        parameters = {
            "generated_test_cases": generated_test_cases,
            "cucumber_script_basic_template": cucumber_script_basic_template,
            "available_web_elements": available_web_elements,
            "available_webui_cucumber_system_steps": available_webui_cucumber_system_steps,
            "available_webui_cucumber_project_steps": available_webui_cucumber_project_steps,
            "script_generate_guide": script_generate_guide,
            "project_document": project_document
        }

        prompt = GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE.format(
            generated_test_cases=parameters["generated_test_cases"],
            cucumber_script_basic_template=parameters["cucumber_script_basic_template"],
            available_web_elements=parameters["available_web_elements"],
            available_webui_cucumber_system_steps=parameters["available_webui_cucumber_system_steps"],
            available_webui_cucumber_project_steps=parameters["available_webui_cucumber_project_steps"],
            script_generate_guide=parameters["script_generate_guide"],
            project_document=parameters["project_document"],
        )

        agent = Agent()

        cucumber_script = agent.execute(prompt)
        logging.info("AI response:")
        logging.info(cucumber_script)

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledges/" + case + "/result/script_generated.feature"
        self.writeFile(file_path, cucumber_script)
        return cucumber_script

    def readFile(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            file_content = file.read()
        return file_content

    def writeFile(self, file_path, file_content):
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(file_content)
