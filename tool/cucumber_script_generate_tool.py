import uuid

from langchain.pydantic_v1 import BaseModel, Field

from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from knowledges.generate_cucumber_script import GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE

script_result_path = "./result/script_generated.feature"


class CucumberScriptGenerator(BaseModel):
    generated_test_cases: str = Field(
        description='A paragraph about the specific test casse generated, The format is str.')
    cucumber_script_basic_example: str = Field(
        description='A paragraph about cucumber script basic example, The format is str.')
    available_web_elements: str = Field(
        description='A paragraph about the web elements that can use in the cucumber scripts., The format is str.')
    available_webui_cucumber_system_steps: str = Field(
        description='A paragraph about the webui cucumber system steps that can use in the cucumber scripts., The format is str.')
    available_webui_cucumber_project_steps: str = Field(
        description='A paragraph about the webui cucumber project steps that can use in the cucumber scripts., The format is str.')


def test_cases_generate(generated_test_cases, cucumber_script_basic_example, available_web_elements,
                        available_webui_cucumber_system_steps, available_webui_cucumber_project_steps):
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

    parameters = {
        "generated_test_cases": generated_test_cases,
        "cucumber_script_basic_example": cucumber_script_basic_example,
        "available_web_elements": available_web_elements,
        "available_webui_cucumber_system_steps": available_webui_cucumber_system_steps,
        "available_webui_cucumber_project_steps": available_webui_cucumber_project_steps
    }

    cucumber_script = (
        LLMChat(model_type='ADVANCED').prompt_with_parameters(GENERATE_CUCUMBER_SCRIPT_KNOWLEDGE, parameters,
                                                              'Generate Cucumber Script',
                                                              desc='Generate cucumber script base on test cases')
        .replace("```json", '').replace("```", ''))

    log.on_log_end(generate_id)
    writeFile(script_result_path, cucumber_script)
    return cucumber_script


def readFile(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        file_content = file.read()
    return file_content


def writeFile(file_path, file_content):
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(file_content)
