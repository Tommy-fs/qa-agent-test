import time
import uuid

from core.context_manager import ContextManager
from core.llm_chat import LLMChat
from core.planner import Planner
from knowledges.qa_context import QA_CONTEXT, QA_KNOWLEDGE
from processes.process import Process
from tool import tool_management


class TestCaseGenerateProcess(Process):

    def __init__(self):
        super().__init__("generate test case")

    def execute_by_step(self, inputs, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Generate test case', desc='Generate test case base on JIRA Description')

        planner = Planner()
        request = f"Generate test cases for the JIRA requirement\n"
        steps = planner.plan(request, background=QA_CONTEXT, knowledge=QA_KNOWLEDGE)

        context_manager = ContextManager()
        context_manager.get_new_context()
        context_manager.add_context("JIRA requirements", inputs)
        # chat = LLMChat()
        chat = LLMChat(model_type='ADVANCED')
        tools = tool_management.generate_tools()

        for index, step in enumerate(steps, start=1):
            print(step)
            context_response = chat.context_respond_with_tools(context_manager.context_to_str(), tools,
                                                               step.description)

            step_response = context_response
            # step_response = context_response.get('response', 'No response')
            # used_tools_info = context_response.get('used_tools', [])
            # tool_name = used_tools_info[0].get('tool_name', 'Unknown Tool')

            step_response_name = f"{step.output}"

            # if isinstance(step_response, dict):
            #     context = f"{step_response['messages'][0]}: \n{step_response['answer']}"
            # else:
            context = f"{step_response}"

            context_manager.add_context(step_response_name, context)

            with open('step-result.txt', 'a', encoding='utf-8') as log_file:
                timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
                log_entry = (
                    f"{'=' * 40}\n"  # 分隔线
                    f"Step {index} : {step.description} | {timestamp}\n"  # 步骤编号和时间戳
                    f"{'-' * 40}\n"  # 分隔线
                    f"Result: \n{context}\n"  # 步骤结果
                    f"{'=' * 40}\n\n"  # 分隔线
                )
                log_file.write(log_entry)
                log_file.flush()

        log.on_log_end(generate_id)
