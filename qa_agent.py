import uuid

from core import util
from core.log_handler import LoggingHandler
from processes.test_case.test_case_generate import TestCaseGenerate
from processes.test_case.test_case_review import TestCaseReview
# from processes.test_case.test_cases_library import TestCasesLibrary


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
        test_cases = TestCaseGenerate().execute_by_step(jira_request, log)

        similar_cases_in_library = []
        test_case_list = TestCaseGenerate().split_test_cases(test_cases)

        # for test_case in test_case_list:
        #     test_case_json = TestCasesLibrary().parse_test_case(test_case_text=test_case)
        #     summary = test_case_json["summary"]
        #     similar_cases_in_library.append(TestCasesLibrary().search_test_cases(summary))
        #
        # unique_similar_cases = similar_cases_in_library
        #
        # unique_similar_cases_txt = []
        # for similar_case_list in unique_similar_cases:
        #     for similar_case in similar_case_list:
        #         unique_similar_cases_txt.append(TestCasesLibrary().reverse_parse_test_case(test_case=similar_case))
        #
        # delimiter = "\n"
        # existing_test_cases = delimiter.join(unique_similar_cases_txt)
        #
        # test_cases_review = TestCaseReview().execute(test_cases, jira_request, existing_test_cases, log)
        #
        # # TestCaseUpdate().execute(test_cases_review, log)
        #
        # log.on_log_end(generate_id)
        # LoggingHandler().on_text(f"\n[{session_id}-end {util.get_local_time()}]")

        return None
