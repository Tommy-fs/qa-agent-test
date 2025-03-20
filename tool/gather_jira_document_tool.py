import importlib
import argparse
import json

from langchain_core.tools import tool
import logging


@tool("gather_jira_document")
def gather_jira_document():
    """Collect the JIRA requirement and any related project documents necessary for generating test cases."""
    document_gather = DocumentGather()
    return document_gather.gather_jira_document()


class DocumentGather:

    def gather_jira_document(self):
        logging.basicConfig(level=logging.INFO)
        logging.info(
            'Collect the JIRA requirement and any related project documents necessary for generating test cases')

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        module_path_k = "knowledge." + case + ".project_knowledge.project_document"
        class_name_k = "PROJECT_DOCUMENT"

        module_k = importlib.import_module(module_path_k)
        project_document = getattr(module_k, class_name_k)

        module_path_c = "knowledge." + case + ".project_knowledge.test_case_example"
        class_name_c = "TEST_CASE_EXAMPLE"

        module_c = importlib.import_module(module_path_c)
        test_case_example = getattr(module_c, class_name_c)

        class_name_g = "TEST_CASE_GUIDE"
        test_case_guide = getattr(module_c, class_name_g)

        module_path_k = "knowledge." + case + ".jira"
        class_name_k = "JIRA"

        module_k = importlib.import_module(module_path_k)
        jira = getattr(module_k, class_name_k)

        context = f"\n# JIRA REQUIREMENT #\n{jira}\n"
        context += f"\n# PROJECT_DOCUMENT #\n{project_document}\n"
        context += f"\n# TEST_CASE_EXAMPLE #\n{test_case_example}\n"
        context += f"\n# TEST_CASE_GUIDE #\n{test_case_guide}\n"

        return context
