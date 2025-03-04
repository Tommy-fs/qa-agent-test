import json
import re
from typing import Optional

from agent_core.evaluators import BaseEvaluator
from agent_core.evaluators.entities.evaluator_result import EvaluatorResult

from evaluators.document_evaluator_prompt import DOCUMENT_EVALUATOR_PROMPT


class DocumentEvaluator(BaseEvaluator):
    def __init__(
            self,
            model_name: Optional[str] = None,
            log_level: Optional[str] = None,
            evaluation_threshold: Optional[float] = 0.8,
    ):
        super().__init__(model_name, log_level, evaluation_threshold)

    def evaluate(self, root_task, request, response, background, context_manager) -> EvaluatorResult:
        """
        Evaluate the response jira request and related document.
        """
        prompt_text = self.prompt.format(root_task=root_task,
                                         request=request, response=response, background=background,
                                         context=context_manager.context_to_str()
                                         )

        try:
            evaluation_response = self._model.process(prompt_text)
        except Exception as e:
            self.logger.error("Error during model evaluation: %s", e)
            return EvaluatorResult(
                "Reject Code",
                0,
                {
                    "score_breakdown": [],
                    "raw_evaluation": "",
                    "improvement_suggestions": "Model evaluation failed. Please try again.",
                },
            )

        decision, total_score, scores = self.parse_scored_evaluation_response(
            evaluation_response
        )
        details = {"score_breakdown": scores, "raw_evaluation": evaluation_response}
        return EvaluatorResult(decision, total_score, details)

    def default_prompt(self):
        return DOCUMENT_EVALUATOR_PROMPT

    def parse_scored_evaluation_response(self, evaluation_response):
        """
        Attempts to parse numeric scores from the text and compute a total_score.
        """

        response_json = evaluation_response.replace("```json", '').replace("```", '').strip()

        try:
            data = json.loads(response_json)

            decision = data["Recommendation"]
            total_score = data["total_score"]
            scores = {k: v["score"] for k, v in data["evaluation"].items()}

            return decision, total_score, scores

        except Exception as e:
            print("Input is not valid JSON. Attempting to parse manually.")

            decision = ""
            total_score = 0
            scores = {}

            if "Recommendation" in response_json:
                start = response_json.find("Recommendation") + len("Recommendation") + 3
                end = response_json.find("\"", start)
                decision = response_json[start:end]

            if "total_score" in response_json:
                start = response_json.find("total_score") + len("total_score") + 2
                end = response_json.find(",", start)
                total_score = int(response_json[start:end])

            evaluation_start = response_json.find("evaluation")
            evaluation_end = response_json.find("}", evaluation_start)
            evaluation_str = response_json[evaluation_start:evaluation_end]

            for line in evaluation_str.splitlines():
                if "Score" in line:
                    key_start = line.find("\"") + 1
                    key_end = line.find("\"", key_start)
                    key = line[key_start:key_end]

                    score_start = line.find("score") + len("score") + 2
                    score_end = line.find(",", score_start)
                    score = int(line[score_start:score_end].strip())

                    scores[key] = score

            return decision, total_score, scores
