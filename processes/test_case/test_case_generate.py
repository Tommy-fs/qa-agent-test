import re
import uuid

from core.context_manager import ContextManager
from core.llm_chat import LLMChat
from core.planner import Planner
from knowledges.generate_test_case import GENERATE_TEST_CASE_KNOWLEDGE
from knowledges.project_document import PROJECT_DOCUMENT
from knowledges.qa_context import QA_CONTEXT, QA_KNOWLEDGE
from knowledges.qa_context import QA_OBJECT
from knowledges.test_case_example import TEST_CASE_EXAMPLE
from processes.process import Process
from tool import tool_management


class TestCaseGenerateProcess(Process):

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

        planner = Planner()
        request = f"Generate test cases for the JIRA requirement\n"
        steps = planner.plan(request, background=QA_CONTEXT, knowledge=QA_KNOWLEDGE)

        context_manager = ContextManager()
        context_manager.get_new_context()
        context_manager.add_context("JIRA requirements", inputs)

        chat = LLMChat()
        tools = tool_management.generate_tools()

        for index, step in enumerate(steps, start=1):
            print(step)
            context_response = chat.context_respond_with_tools(context_manager.context_to_str(), tools,
                                                               step.description)

            step_response = context_response.get('response', 'No response')
            used_tools_info = context_response.get('used_tools', [])
            tool_name = used_tools_info[0].get('tool_name', 'Unknown Tool')

            step_response_name = f"{step.output}"

            if isinstance(step_response, dict):
                context = f"{step_response['messages'][0]}: \n{step_response['answer']}"
            else:
                context = f"{step_response}"
            context_manager.add_context(step_response_name, context)

        log.on_log_end(generate_id)
