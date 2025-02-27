
from typing import Optional
import re

from agent_core.evaluators import BaseEvaluator
from agent_core.evaluators.entities.evaluator_result import EvaluatorResult

from evaluators.cucumber_evaluator_prompt import CUCUMBER_EVALUATOR_PROMPT

class CucumberEvaluator(BaseEvaluator):

    def __init__(
            self,
            model_name: Optional[str] = None,
            log_level: Optional[str] = None,
            evaluation_threshold: Optional[float] = 0.8,
    ):
        super().__init__(model_name, log_level, evaluation_threshold)

    def evaluate(self, root_task, request, response, background, context_manager) -> EvaluatorResult:
        """
        Evaluate the provided request and generated code response.
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
        #
        # details = {
        #     "score_breakdown": scores,
        #     "raw_evaluation": evaluation_response,
        #     "total_applicable_score": total_score,
        # }
        #
        # if decision == "Reject Code":
        #     improvement_suggestions = generate_improvement_suggestions(scores)
        #     details["improvement_suggestions"] = improvement_suggestions
        # else:
        #     details["improvement_suggestions"] = ""
        #
        # return EvaluatorResult(decision, total_score, details)
        details = {"score_breakdown": scores, "raw_evaluation": evaluation_response}
        return EvaluatorResult(decision, total_score, details)

    def default_prompt(self):
        return CUCUMBER_EVALUATOR_PROMPT


    def parse_scored_evaluation_response(self, evaluation_response):
        """
        Attempts to parse numeric scores from the text and compute a total_score.
        We also check if any single score < 3 triggers a rerun decision.
        """
        scores = []
        total_score = 0

        lines = evaluation_response.strip().split("\n")
        for line in lines:
            # Several regex attempts to capture "Score: <digit>"
            match_1 = re.match(
                r"\d+\.\s\*\*([A-Za-z\s]+)\*\*\s\(Score\s1-5\):\s*Score:\s*(\d)", line
            )
            match_2 = re.match(r"\d+\.\s\*\*([A-Za-z\s]+) \(Score (\d+)\)", line)
            match_3 = re.match(
                r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\(Score:? (\d+)\)\*\*", line
            )
            match_4 = re.match(r"\d+\.\s+\*\*([A-Za-z\s]+)\*\* \(Score (\d+)\):", line)
            match_5 = re.match(r"\*\*([A-Za-z\s]+)\s*\(Score\s1-5\):\s*(\d+)\*\*", line)
            match_6 = re.match(
                r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\(Score\s1-5\):\*\*\s*(\d+)", line
            )
            match_7 = re.match(
                r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\(Score\s1-5\):\s*(\d+)\*\*", line
            )
            match_8 = re.match(
                r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\(Score\s1-5\)\*\*:\s*(\d+)", line
            )
            match_9 = re.match(r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\((\d+)/5\):\*\*", line)
            match_10 = re.match(r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\((\d+)\):\*\*", line)
            match_11 = re.match(
                r"\d+\.\s+\*\*([A-Za-z\s]+)\s*\(Score:\s*(\d+)\):\*\*", line
            )
            match = (
                    match_1
                    or match_2
                    or match_3
                    or match_4
                    or match_5
                    or match_6
                    or match_7
                    or match_8
                    or match_9
                    or match_10
                    or match_11
            )

            if match:
                criterion = match.group(1).strip()
                score = int(match.group(2))
                scores.append((criterion, score))
                total_score += score

        # Check if any criterion scored below 3
        any_low_scores = any(score < 3 for _, score in scores)

        # Final decision logic
        if float(total_score) / 40.0 > self.evaluation_threshold and not any_low_scores:
            decision = "Accept Output"
        else:
            decision = "Rerun Subtask"

        return decision, total_score, scores
