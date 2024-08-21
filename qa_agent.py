import uuid

from core import util
from core.log_handler import LoggingHandler
from processes.test_case.test_case_generate import TestCaseGenerateProcess


class QAAgent:

    def __init__(self):
        self.name = "QA_Agent"

    def run(self, session_id, inputs):
        LoggingHandler().on_text(f"\n[{session_id}-start {util.get_local_time()}]")
        log = LoggingHandler()

        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Generate test case workflow',
                         desc='Generate test case workflow')

        jira_request = inputs
        test_cases = TestCaseGenerateProcess().execute_by_step(jira_request, log)

        return None
