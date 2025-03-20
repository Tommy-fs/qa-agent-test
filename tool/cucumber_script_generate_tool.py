import argparse
import json
import logging
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from evaluators.cucumber_script_optimization import CucumberOptimization
from evaluators.cucumber_scripts_evaluator import CucumberEvaluator
from knowledge.generate_cucumber_script import GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE


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
            "../knowledge/" + case + "/cucumber_knowledge/cucumber_script_base.feature")
        available_web_elements = self.readFile("../knowledge/" + case + "/cucumber_knowledge/WebElement.yml")
        available_webui_cucumber_system_steps = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_system_steps.txt")
        available_webui_cucumber_project_steps = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_project_steps.txt")
        script_generate_guide = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/script_generate_guide.txt")
        project_document = self.readFile(
            "../knowledge/" + case + "/project_knowledge/project_document.py")

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
        test_cases_dict = self.parse_test_cases(generated_test_cases)
        for case_name, case_content in test_cases_dict.items():
            parameters["generated_test_cases"] = case_content
            generate_script = self.generate_script(parameters)
            self.write_script_to_file(case_name + "_original", generate_script)

            final_response = self.evaluate_and_optimize(case_content, generate_script)
            logging.info('evaluate_and_optimize result' + final_response["decision"])

            final_script = final_response["final_script"]
            cucumber_scripts.append(final_script)
            self.write_script_to_file(case_name + "_optimized", final_script)
        return json.dumps(cucumber_scripts)

    def readFile(self, file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                file_content = file.read()
            return file_content
        except:
            return ""

    def write_script_to_file(self, case_name, file_content):
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        try:
            start = file_content.index('```cucumber') + len('```cucumber')
            end = file_content.index('```', start)
            script = file_content[start:end].strip()
        except (ValueError, AttributeError):  # 处理找不到字符串或传入非字符串的情况
            script = file_content
        file_path = "../knowledge/" + case + "/result/script_generated-" + str(case_name) + ".feature"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(script)

        logging.info("Test case script has been wrote in " + file_path)

    def parse_test_cases(self, test_cases):
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

    def generate_script(self, parameters):
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

        return cucumber_script

    def evaluate_and_optimize(self, case_content, generate_script, max_iterations=3):
        global evaluation_output, total_score
        iteration_count = 0
        evaluator = CucumberEvaluator()
        optimization = CucumberOptimization()
        while iteration_count < max_iterations:
            iteration_count += 1
            logging.info(f"Iteration {iteration_count}: Evaluating the script...")

            evaluation_output = evaluator.evaluate(case_content, generate_script)

            decision = evaluation_output["decision"]
            suggestions = evaluation_output["suggestions"]
            total_score = evaluation_output["total_score"]

            if "accept" in decision.lower():
                logging.info(f"The script passed evaluation! - {total_score}")
                return {
                    "decision": "Pass",
                    "total_score": total_score,
                    "final_script": generate_script,
                }
            elif "reject" in decision.lower():
                logging.info(f"The script total score is {total_score}")
                logging.info("The script requires modifications. Applying suggestions...")
                logging.info(f"Suggestions: {suggestions}")

                generate_script = optimization.optimization_gherkin_script(case_content, generate_script,
                                                                           "\n".join(suggestions))
                logging.info("Optimization applied. Re-evaluating the script...")
            else:
                raise ValueError(f"Unexpected decision: {decision}")

        logging.info(f"The script did not pass after the maximum number of iterations {total_score}.")
        return {
            "decision": "Failed",
            "total_score": evaluation_output["total_score"],
            "final_script": generate_script
        }
