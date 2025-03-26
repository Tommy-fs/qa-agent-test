import argparse
import re
from typing import Optional

from agent_core.agents import Agent
from agent_core.evaluators import BaseEvaluator
from agent_core.evaluators.entities.evaluator_result import EvaluatorResult

from evaluators.script_evaluator_prompt import CUCUMBER_EVALUATOR_PROMPT


class CucumberEvaluatorCore(BaseEvaluator):

    def __init__(
            self,
            model_name: Optional[str] = None,
            log_level: Optional[str] = None,
            evaluation_threshold: Optional[float] = 80,
    ):
        super().__init__(model_name, log_level, evaluation_threshold)

    def evaluate(self, root_task, request, response, background, context_manager) -> EvaluatorResult:
        """
        Evaluate the provided request and generated script response.
        """

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        # cucumber_script_basic_template = readFile(
        #     "../knowledge/" + case + "/cucumber_knowledge/cucumber_script_base.feature")
        # available_web_elements = readFile("../knowledge/" + case + "/cucumber_knowledge/WebElement.yml")
        # available_webui_cucumber_system_steps = readFile(
        #     "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_system_steps.txt")
        # available_webui_cucumber_project_steps = readFile(
        #     "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_project_steps.txt")
        # script_generate_guide = readFile(
        #     "../knowledge/" + case + "/cucumber_knowledge/script_generate_guide.txt")
        #
        # prompt_text = (default_prompt()
        #                .format(test_case=test_case,
        #                        cucumber_script=cucumber_script,
        #                        cucumber_script_basic_template=cucumber_script_basic_template,
        #                        script_generate_guide=script_generate_guide,
        #                        available_web_elements=available_web_elements,
        #                        available_webui_cucumber_system_steps=available_webui_cucumber_system_steps,
        #                        available_webui_cucumber_project_steps=available_webui_cucumber_project_steps
        #                        ))

        prompt_text = self.prompt.format(root_task=root_task,
                                         request=request, response=response, background=background,
                                         context=context_manager.context_to_str()
                                         )

        agent = Agent(model_name="gemini-1.5-pro-002")

        evaluation_response = agent.execute(prompt_text)

        response = parse_scored_evaluation_response(evaluation_response)

        return EvaluatorResult(
            name=self.name,
            decision=str(response["decision"]),
            score=response["total_score"],
            suggestion="\n".join(response["suggestions"]),
            details=response["scores"],
            prompt=prompt_text,
        )

    def default_prompt(self):
        return CUCUMBER_EVALUATOR_PROMPT

def default_prompt():
    return CUCUMBER_EVALUATOR_PROMPT


def parse_scored_evaluation_response(evaluation_response):
    response_json = evaluation_response.replace("```json", '').replace("```", '').strip()

    result = {
        "decision": None,
        "total_score": None,
        "scores": {},
        "suggestions": []
    }

    # Extract the decision
    decision_match = re.search(r"\*\*Recommendation:\*\*\s*(.+)", response_json)
    if decision_match:
        result["decision"] = decision_match.group(1).strip()

    # Extract the total score
    total_score_match = re.search(r"\*\*Total Score:\*\*\s*(\d+)", response_json)
    if total_score_match:
        result["total_score"] = int(total_score_match.group(1))

    # Extract individual scores
    scores_matches = re.findall(r"\*\*(\d+\.\s.*?):\*\*\s*- \*\*Score:\*\*\s*(\d+)", response_json)
    for criterion, score in scores_matches:
        result["scores"][criterion.strip()] = int(score)

    # Extract suggestions
    suggestions_match = re.search(r"\*\*Suggestions for Improvement:\*\*\n([\s\S]+)", response_json)
    if suggestions_match:
        suggestions_text = suggestions_match.group(1)
        # Split suggestions into individual items
        result["suggestions"] = [s.strip("* ").strip() for s in suggestions_text.split("\n") if s.strip()]

    return result


def readFile(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            file_content = file.read()
        return file_content
    except:
        return ""
