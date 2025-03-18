import argparse
import importlib
import logging

from agent_core.agents import Agent
from agent_core.planners import GraphPlanner

from evaluators.cucumber_scripts_evaluator import CucumberEvaluator
from evaluators.document_gather_evaluator import DocumentEvaluator
from knowledges.qa_context import QA_KNOWLEDGE, QA_BACKGROUND, QA_OBJECT
from tool.cucumber_script_generate_tool import cucumber_script_generate
from tool.gather_jira_document_tool import gather_jira_document
from tool.test_case_generate_tool import test_case_generate


class QAAgent:

    def __init__(self):
        self.jira_request = None
        self.agent = Agent()

    def run(self, jira_request):
        logging.basicConfig(level=logging.INFO)

        self.agent.tools = [gather_jira_document, test_case_generate, cucumber_script_generate]
        self.agent.knowledge = QA_KNOWLEDGE
        self.agent.background = QA_BACKGROUND

        self.jira_request = jira_request
        self.add_context()

        self.agent.enable_evaluators()

        # self.agent.add_evaluator("gather jira document", DocumentEvaluator(self.agent.model_name))
        self.agent.add_evaluator("cucumber script generate", CucumberEvaluator(self.agent.model_name))

        self.agent.planner = GraphPlanner()
        request = f"Generate test cases for the JIRA requirement\n" + jira_request
        self.agent.execute(request)

        execution_history = self.agent.execution_history
        print(f"Execution History: {execution_history}")
        execution_result = self.agent.get_execution_result_summary()
        print(f"Execution Result: {execution_result}")

    def add_context(self):
        # self.agent.context.add_context('JIRA requirements', self.jira_request)
        self.agent.context.add_context('QA CONTEXT', QA_BACKGROUND)
        self.agent.context.add_context('QA OBJECT', QA_OBJECT)
