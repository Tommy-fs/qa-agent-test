import uuid
import importlib
import argparse

from core.log_handler import LoggingHandler
from knowledges.qa_context import QA_CONTEXT, QA_OBJECT


def understand_project():
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Understand Poject', desc='Feed QA project related knowledge')

    contextStr = f"\n<QA_CONTEXT>\n{QA_CONTEXT}\n</QA_CONTEXT>\n"
    contextStr += f"\n<QA_OBJECT>\n{QA_OBJECT}\n</QA_OBJECT>\n"

    parser = argparse.ArgumentParser()
    parser.add_argument("--case", required=True)
    args = parser.parse_args()
    case = args.case

    module_path_k = "knowledges." + case + ".project_knowledges.project_document"
    class_name_k = "PROJECT_DOCUMENT"

    module_k = importlib.import_module(module_path_k)
    project_document = getattr(module_k, class_name_k)

    module_path_c = "knowledges." + case + ".project_knowledges.test_case_example"
    class_name_c = "TEST_CASE_EXAMPLE"

    module_c = importlib.import_module(module_path_c)
    test_case_example = getattr(module_c, class_name_c)

    class_name_g = "TEST_CASE_GUIDE"
    test_case_guide = getattr(module_c, class_name_g)

    contextStr += f"\n<PROJECT_DOCUMENT>\n{project_document}\n</PROJECT_DOCUMENT>\n"
    contextStr += f"\n<TEST_CASE_EXAMPLE>\n{test_case_example}\n</TEST_CASE_EXAMPLE>\n"
    contextStr += f"\n<TEST_CASE_GUIDE>\n{test_case_guide}\n</TEST_CASE_GUIDE>\n"

    log.on_log_end(generate_id)
    return contextStr
