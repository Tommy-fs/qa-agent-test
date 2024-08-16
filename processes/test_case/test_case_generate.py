import uuid
from typing import Callable, Any

from langchain_core.tools import StructuredTool

from core.context_manager import ContextManager
from core.llm_chat import LLMChat
from core.log_handler import LoggingHandler
from core.planner import Planner
from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE
from knowledges.identify_modules import IDENTIFY_MODULES_PROMPT
from knowledges.test_case_example import TEST_CASE_EXAMPLE
from knowledges.qa_context import QA_CONTEXT
from knowledges.qa_context import QA_OBJECT
from knowledges.project_document import PROJECT_DOCUMENT
from processes.process import Process
from langchain.pydantic_v1 import BaseModel, Field
import re


class TestCaseGenerate(Process):

    def __init__(self):
        super().__init__("generate test case")

    def execute(self, inputs, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

        parameters = {
            "qa_context": QA_CONTEXT,
            "qa_object": QA_OBJECT,
            "jira_content": inputs,
            "project_document": PROJECT_DOCUMENT,
            "test_case_example": TEST_CASE_EXAMPLE
        }

        test_case = (
            LLMChat().prompt_with_parameters(GENERATE_TEST_CASE_KNOWLEDGE, parameters, 'Generate test case',
                                             desc='Generate test case base on JIRA Description')
            .replace("```json", '').replace("```", ''))

        log.on_log_end(generate_id)
        return test_case

    def execute_by_step(self, inputs, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

        parameters = {
            "qa_context": QA_CONTEXT,
            "qa_object": QA_OBJECT,
            "jira_content": inputs,
            "project_document": PROJECT_DOCUMENT,
            "test_case_example": TEST_CASE_EXAMPLE
        }

        request = GENERATE_TEST_CASE_KNOWLEDGE.format(
            qa_context=parameters.get("qa_context", ""),
            qa_object=parameters.get("qa_object", ""),
            project_document=parameters.get("project_document", ""),
            jira_content=parameters.get("jira_content", ""),
            test_case_example=parameters.get("test_case_example", "")
        )
        planner = Planner()
        steps = planner.plan(request, background=QA_CONTEXT + QA_OBJECT, knowledge=PROJECT_DOCUMENT)

        context_manager = ContextManager()
        context_manager.get_new_context()

        chat = LLMChat()
        tools = self.generate_tools()

        for index, step in enumerate(steps, start=1):
            print(step)
            context_response = chat.context_respond_with_tools(context_manager.context_to_str(), tools,
                                                               step.description)
            step_number = f"Step {index} : {step.description}"
            if isinstance(context_response, dict):
                context = f"{context_response['messages'][0]}: \n{context_response['answer']}"
            else:
                context = f"{context_response}"
            context_manager.add_context(step_number, context)

        log.on_log_end(generate_id)

    def split_test_cases(self, inputs):
        split_strings = re.split(r'"}\nPriority', inputs)
        split_strings = [s + '"}' if i == 0 else 'Priority' + s for i, s in enumerate(split_strings)]

        test_cases_list = [s.strip() for s in split_strings]

        return test_cases_list

    def generate_tools(self) -> list[Callable[..., Any]]:
        return [
            StructuredTool.from_function(
                func=self.modules_identify,
                name='Identify Components and Modules',
                description='Based on the project documentation and JIRA request, identify the components or modules of the software that need to be tested. Categorize them based on their functional areas.',
                args_schema=self.Identify
            )]

    def modules_identify(self, inputs, jira):
        log = LoggingHandler()
        identify_id = uuid.uuid1()
        log.on_log_start(identify_id, 'Modules Identify',
                         desc='Modules Identify')

        parameters = {
            "qa_context": QA_CONTEXT,
            "qa_object": QA_OBJECT,
            "project_document": PROJECT_DOCUMENT,
            "jira_content": jira,
            "architecture_modules": inputs
        }
        modules = (
            LLMChat().prompt_with_parameters(IDENTIFY_MODULES_PROMPT, parameters, 'Modules Identify',
                                             desc='Modules Identify')
            .replace("```json", '').replace("```", ''))

        log.on_log_end(identify_id)

        return modules

    class Identify(BaseModel):
        inputs: str = Field(
            description='One sentence describing the overall architecture modules of the project and the modules related to this JIRA requirement')
        jira: str = Field(
            description='Detailed description of jira requirements')
