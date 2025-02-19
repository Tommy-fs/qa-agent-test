from agent_core.agents import Agent
from agent_core.planners import GraphPlanner

from knowledges.qa_context import QA_KNOWLEDGE, QA_CONTEXT, QA_OBJECT
from tool.cucumber_script_generate_tool import cucumber_script_generate
from tool.test_case_generate_tool import test_case_generate


class QAAgent:

    def __init__(self):
        self.agent = Agent()

    def run(self, jira_requesst):
        self.agent.tools = [test_case_generate, cucumber_script_generate]
        self.agent.knowledge = QA_OBJECT
        self.agent.background = QA_CONTEXT

        self.agent.planner = GraphPlanner()

        self.agent.execute(jira_requesst)
