import argparse

from agent_core.agents import Agent

from evaluators.script_optimization_prompt import CUCUMBER_OPTIMIZATION_PROMPT


def default_prompt():
    return CUCUMBER_OPTIMIZATION_PROMPT


class CucumberOptimization:

    def optimization_gherkin_script(self, test_case: str, cucumber_script: str, suggestion: str):
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        cucumber_script_basic_template = readFile(
            "../knowledge/" + case + "/cucumber_knowledge/cucumber_script_base.feature")
        available_web_elements = readFile("../knowledge/" + case + "/cucumber_knowledge/WebElement.yml")
        available_webui_cucumber_system_steps = readFile(
            "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_system_steps.txt")
        available_webui_cucumber_project_steps = readFile(
            "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_project_steps.txt")
        script_generate_guide = readFile(
            "../knowledge/" + case + "/cucumber_knowledge/script_generate_guide.txt")

        prompt_text = (default_prompt()
                       .format(test_case=test_case,
                               cucumber_script=cucumber_script,
                               suggestion=suggestion,
                               cucumber_script_basic_template=cucumber_script_basic_template,
                               script_generate_guide=script_generate_guide,
                               available_web_elements=available_web_elements,
                               available_webui_cucumber_system_steps=available_webui_cucumber_system_steps,
                               available_webui_cucumber_project_steps=available_webui_cucumber_project_steps
                               ))

        agent = Agent(model_name="gemini-1.5-pro-002")
        optimized_script = agent.execute(prompt_text)

        return optimized_script


def readFile(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            file_content = file.read()
        return file_content
    except:
        return ""
