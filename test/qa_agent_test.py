# example
import argparse
import importlib

from qa_agent import QAAgent


def test(log_update=None):
    print("test-begin")

    parser = argparse.ArgumentParser()
    parser.add_argument("--case", required=True)
    args = parser.parse_args()
    case = args.case

    module_path_k = "knowledges." + case + ".jira"
    class_name_k = "JIRA"

    module_k = importlib.import_module(module_path_k)
    jira = getattr(module_k, class_name_k)

    qa_agent = QAAgent()
    qa_agent.run(jira)


test()
