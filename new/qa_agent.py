import argparse
import importlib

from agent_core.agents import Agent
from agent_core.planners import GraphPlanner

from evaluators.cucumber_scripts_evaluator import CucumberEvaluator
from knowledges.qa_context import QA_KNOWLEDGE, QA_BACKGROUND, QA_OBJECT
from tool.cucumber_script_generate_tool import cucumber_script_generate
from tool.test_case_generate_tool import test_case_generate


class QAAgent:

    def __init__(self):
        self.jira_request = None
        self.agent = Agent()

    def run(self, jira_request):
        self.agent.tools = [test_case_generate, cucumber_script_generate]
        self.agent.knowledge = QA_KNOWLEDGE
        self.agent.background = QA_BACKGROUND

        self.jira_request = jira_request
        self.add_context()
        self.agent.enable_evaluators()
        self.agent.add_evaluator("cucumber script evaluator", CucumberEvaluator(self.agent.model_name))
        self.agent.planner = GraphPlanner()
        request = f"Generate test cases for the JIRA requirement\n"
        self.agent.execute(request)

    def add_context(self):
        self.agent.context.add_context('JIRA requirements', self.jira_request)

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

        self.agent.context.add_context('PROJECT DOCUMENT', project_document)
        self.agent.context.add_context('TEST CASE EXAMPLE', test_case_example)
        self.agent.context.add_context('TEST CASE GUIDE', test_case_guide)
        self.agent.context.add_context('QA CONTEXT', QA_BACKGROUND)
        self.agent.context.add_context('QA OBJECT', QA_OBJECT)
