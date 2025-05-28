import argparse
import json
import logging
from datetime import datetime
from typing import Annotated

from agent_core.agents import Agent
from langchain_core.tools import tool

from evaluators.cucumber_scripts_evaluator import CucumberEvaluator
from knowledge.generate_cucumber_script import GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE
from util import knowledge_util


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

        parameters = self.enrich_knowledge_parameters(generated_test_cases)

        # cucumber_scripts = []
        # test_cases_dict = self.parse_test_cases(generated_test_cases)
        # for case_name, case_content in test_cases_dict.items():
        #     parameters["generated_test_cases"] = case_content
        #     generate_script = self.generate_script(parameters)
        #     self.write_script_to_file(case_name + "_original", generate_script)
        #
        #     evaluate_response = self.evaluate_and_optimize(case_content, generate_script)
        #     logging.info(f'evaluate_and_optimize result' + evaluate_response["decision"])
        #
        #     final_script = evaluate_response["final_script"]
        #     cucumber_scripts.append(final_script)
        #     self.write_script_to_file(case_name + "_optimized", final_script)

        generate_script = self.generate_script(parameters)
        self.write_script_to_file("_" + datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S") + "_original", generate_script)

        evaluate_response = self.evaluate_and_optimize(generated_test_cases, generate_script)
        logging.info(f'evaluate_and_optimize result' + evaluate_response["decision"])

        final_script = evaluate_response["final_script"]
        # cucumber_scripts.append(final_script)
        self.write_script_to_file("_" + datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S") + "_optimized", final_script)

        return json.dumps(final_script)

    def write_script_to_file(self, case_name, file_content):
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        try:
            start = file_content.index('```cucumber') + len('```cucumber')
            end = file_content.index('```', start)
            script = file_content[start:end].strip()
        except (ValueError, AttributeError):
            script = file_content
        file_path = "../knowledge/" + case + "/result/script_generated-" + str(case_name) + ".feature"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(script)

        logging.info("Test case script has been wrote in " + file_path)

    def parse_test_cases(self, test_cases):
        test_case_lines = test_cases.strip().splitlines()

        if len(test_case_lines) <= 1:
            test_case_lines = test_cases.strip().split("\n")
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
        cucumber_script = ""
        try:
            prompt = GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE.format(
                generated_test_cases=parameters["generated_test_cases"],
                cucumber_script_basic_template=parameters["cucumber_script_basic_template"],
                available_web_elements=parameters["available_web_elements"],
                available_webui_cucumber_system_steps=parameters["available_webui_cucumber_system_steps"],
                available_webui_cucumber_project_steps=parameters["available_webui_cucumber_project_steps"],
                script_generate_guide=parameters["script_generate_guide"],
                project_document=parameters["project_document"],
                failure_history=parameters["failure_history"]
            )

            agent = Agent(model_name="gemini-2.0-flash-001")
            # agent.planner = GraphPlanner()
            # agent.enable_evaluators()
            # evaluator = CucumberEvaluatorCore(model_name="gemini-1.5-pro-002")
            # agent.add_evaluator("cucumber script generate", evaluator)
            # agent.knowledge = """Generate cucumber script base on generated test cases."""
            # agent.background = """We are a software company, and you are our software test expert, your responsibility is
            # to create cucumber scripts."""

            cucumber_script = agent.execute(prompt)
        except Exception as e:
            logging.info(f"Test case script generate failed : {e} ")

        return cucumber_script

    def evaluate_and_optimize(self, case_content, generate_script, max_iterations=3):
        global evaluation_output, total_score
        iteration_count = 0

        failure_history = []

        while iteration_count < max_iterations:
            iteration_count += 1
            logging.info(f"Iteration {iteration_count}: Evaluating the script...")

            evaluation_output = self.evaluate(case_content, generate_script)

            decision = evaluation_output["decision"]
            suggestions = evaluation_output["suggestions"]
            total_score = evaluation_output["total_score"]

            if "accept" in decision.lower():
                logging.info(f"The script passed evaluation! - {total_score}")
                suggestion_history_str = "\n".join([
                    f"Suggestions: {', '.join(suggestion)}"
                    for script, suggestion in failure_history
                ])
                self.write_script_to_file("suggestion_history_" + datetime.now().strftime(
                    "%Y-%m-%d_%H-%M-%S"), suggestion_history_str)

                return {
                    "decision": "Pass",
                    "total_score": total_score,
                    "final_script": generate_script,
                }
            elif "reject" in decision.lower():
                logging.info(f"The script total score is {total_score}")
                logging.info(f"The script requires modifications. Applying suggestions...")
                logging.info(f"Suggestions: {suggestions}")

                failure_history.append((generate_script, suggestions))

                failure_history_str = "\n".join([f"Failure Script: {script}\nSuggestions: {', '.join(suggestion)}"
                                                 for script, suggestion in failure_history])

                parameters = self.enrich_knowledge_parameters(case_content, failure_history_str)
                generate_script = self.generate_script(parameters)

                logging.info(f"Optimization applied. Re-evaluating the script...")
            else:
                raise ValueError(f"Unexpected decision: {decision}")

        logging.info(f"The script did not pass after the maximum number of iterations {total_score}.")

        suggestion_history_str = "\n".join([
            f"Suggestions: {', '.join(suggestion)}"
            for script, suggestion in failure_history[:-1]
        ])

        self.write_script_to_file("suggestion_history_" + datetime.now().strftime(
            "%Y-%m-%d_%H-%M-%S"), suggestion_history_str)
        return {
            "decision": "Failed",
            "total_score": evaluation_output["total_score"],
            "final_script": generate_script
        }

    def evaluate(self, case_content, generate_script):
        evaluator = CucumberEvaluator()

        logging.info(f"Evaluating the script...")

        output = evaluator.evaluate(case_content, generate_script)

        decision = output["decision"]
        suggestions = output["suggestions"]
        score = output["total_score"]

        return {
            "decision": decision,
            "total_score": score,
            "suggestions": suggestions
        }

    def enrich_knowledge_parameters(self, generated_test_cases, failure_history=""):
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        cucumber_script_basic_template = knowledge_util.get_cucumber_knowledge("cucumber_script_base.feature")

        available_web_elements = knowledge_util.get_cucumber_knowledge("WebElement.yml")

        available_webui_cucumber_system_steps = knowledge_util.get_cucumber_knowledge(
            "fast_webui_cucumber_system_steps.txt")

        available_webui_cucumber_project_steps = knowledge_util.get_cucumber_knowledge(
            "fast_webui_cucumber_project_steps.txt")

        script_generate_guide = knowledge_util.get_cucumber_knowledge("script_generate_guide.txt")

        project_document = knowledge_util.get_project_knowledge("PROJECT_DOCUMENT", "project_document")

        parameters = {
            "generated_test_cases": generated_test_cases,
            "cucumber_script_basic_template": cucumber_script_basic_template,
            "available_web_elements": available_web_elements,
            "available_webui_cucumber_system_steps": available_webui_cucumber_system_steps,
            "available_webui_cucumber_project_steps": available_webui_cucumber_project_steps,
            "script_generate_guide": script_generate_guide,
            "project_document": project_document,
            "failure_history": failure_history
        }

        return parameters
