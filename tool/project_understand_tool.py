import uuid

from core.log_handler import LoggingHandler
from knowledges.project_document import PROJECT_DOCUMENT
from knowledges.qa_context import QA_CONTEXT, QA_OBJECT
from knowledges.test_case_example import TEST_CASE_EXAMPLE


def understand_project():
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Understand Poject', desc='Feed QA project related knowledge')

    contextStr = f"\n<QA_CONTEXT>\n{QA_CONTEXT}\n</QA_CONTEXT>\n"
    contextStr += f"\n<QA_OBJECT>\n{QA_OBJECT}\n</QA_OBJECT>\n"
    contextStr += f"\n<PROJECT_DOCUMENT>\n{PROJECT_DOCUMENT}\n</PROJECT_DOCUMENT>\n"
    contextStr += f"\n<TEST_CASE_EXAMPLE>\n{TEST_CASE_EXAMPLE}\n</TEST_CASE_EXAMPLE>\n"

    log.on_log_end(generate_id)
    return contextStr
