import argparse
import json
import logging
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from knowledges.generate_cucumber_script import GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE


@tool("cucumber_script_generate")
def cucumber_script_generate(
        generated_test_cases: Annotated[str, 'Newly generated test cases in the previous step']):
    """Generate cucumber script based on test case generated and related document"""
    test_case_script_generator = CucumberScriptGenerator()
    return test_case_script_generator.cucumber_script_generate(generated_test_cases)


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

        cucumber_scripts = []
        test_cases_dict = self.parseTestCases(generated_test_cases)
        for case_name, case_content in test_cases_dict.items():
            parameters["generated_test_cases"] = case_content
            generate_script = self.generate_script(parameters, case_name)
            cucumber_scripts.append(generate_script)

        return json.dumps(cucumber_scripts)

    def readFile(self, file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                file_content = file.read()
            return file_content
        except:
            return ""

    def writeFile(self, file_path, file_content):
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(file_content)

    def parseTestCases(self, test_cases):
        test_case_lines = test_cases.strip().splitlines()

        test_cases_dict = {}
        current_case = []
        case_name = None

        for line in test_case_lines:
            if line.strip():
                if 'name:' in line.lower():
                    case_name = line.split(":", 1)[1].strip()
                if '**name:**' in line.lower():
                    case_name = line.split('**Name:**', 1)[1].strip()
                if '---' in line:
                    if current_case and case_name:
                        test_cases_dict[case_name] = "\n".join(current_case)
                        current_case = []
                        case_name = None
                        continue
                current_case.append(line.strip())

        if current_case and case_name:
            test_cases_dict[case_name] = "\n".join(current_case)

        return test_cases_dict

    def generate_script(self, parameters, case_name):
        prompt = GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE.format(
            generated_test_cases=parameters["generated_test_cases"],
            cucumber_script_basic_template=parameters["cucumber_script_basic_template"],
            available_web_elements=parameters["available_web_elements"],
            available_webui_cucumber_system_steps=parameters["available_webui_cucumber_system_steps"],
            available_webui_cucumber_project_steps=parameters["available_webui_cucumber_project_steps"],
            script_generate_guide=parameters["script_generate_guide"],
            project_document=parameters["project_document"]
        )

        agent = Agent(model_name="gemini-1.5-pro-002")

        cucumber_script = agent.execute(prompt)

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        file_path = "../knowledges/" + case + "/result/script_generated-" + str(case_name) + ".feature"
        self.writeFile(file_path, cucumber_script)

        logging.info("Test case script has been wrote in " + file_path)

        return cucumber_script
