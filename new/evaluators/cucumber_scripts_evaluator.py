# 11/cucumber_scripts_evaluator.py

import json
from typing import Optional, List

from agent_core.evaluators import BaseEvaluator
from agent_core.evaluators.entities.evaluator_result import EvaluatorResult

from evaluators.cucumber_evaluator_prompt import CUCUMBER_EVALUATOR_PROMPT


def generate_improvement_suggestions(scores: List[tuple]) -> str:
    """
    Generate improvement suggestions based on the scores. For each applicable criterion with a score below 3,
    provide a specific suggestion.
    """
    suggestion_dict = {
        "Requirements Coverage": "Ensure the code fully addresses and implements the requirements.",
        "Correctness": "Review the logic and test the code to verify its correctness.",
        "Code Style and Conventions": "Follow standard coding practices and style guidelines.",
        "Readability and Documentation": "Improve code organization and add meaningful comments and documentation.",
        "Efficiency and Performance": "Optimize algorithms and resource usage for better performance.",
        "Maintainability and Scalability": "Refactor the code to enhance maintainability and facilitate future extensions.",
        "Security and Robustness": "Implement proper error handling and security measures to cover edge cases.",
        "Testability": "Design the code structure to facilitate unit testing and overall verification.",
    }

    suggestions = []
    for criterion, score_value in scores:
        if score_value < 3:
            suggestion = suggestion_dict.get(
                criterion, f"Consider improving {criterion}."
            )
            suggestions.append(f"- {criterion}: {suggestion}")

    if not suggestions:
        suggestions.append(
            "Review the overall implementation to better meet the requirements and quality standards."
        )

    return "\n".join(suggestions)


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

        details = {
            "score_breakdown": scores,
            "raw_evaluation": evaluation_response,
            "total_applicable_score": total_score,
        }

        if decision == "Reject Code":
            improvement_suggestions = generate_improvement_suggestions(scores)
            details["improvement_suggestions"] = improvement_suggestions
        else:
            details["improvement_suggestions"] = ""

        return EvaluatorResult(decision, total_score, details)

    def default_prompt(self):
        return CUCUMBER_EVALUATOR_PROMPT

    def parse_scored_evaluation_response(self, evaluation_response: str):
        """
        Parse the evaluation text to extract scores for each criterion, and calculate the total and average scores.
        For criteria marked as N/A, they are excluded from the score calculation.
        """
        try:
            cleaned_evaluation_response = (
                evaluation_response.replace("```json", "").replace("```", "").strip()
            )
            evaluation_data = json.loads(cleaned_evaluation_response)
        except json.JSONDecodeError:
            self.logger.error("Unable to parse the model's evaluation response.")
            return "Reject Code", 0, []

        scores = []
        total_score = 0
        applicable_criteria_count = 0

        for item in evaluation_data["scores"]:
            score_value = item["score"]
            if score_value != "N/A":
                scores.append((item["criterion"], score_value))
                total_score += score_value
                applicable_criteria_count += 1

        if applicable_criteria_count == 0:
            self.logger.warning("No valid criteria were parsed for evaluation.")
            return "Reject Code", 0, scores

        # Check if any criterion scored below 3
        any_low_scores = any(score < 3 for _, score in scores)
        average_score = total_score / applicable_criteria_count

        decision = (
            "Accept Code"
            if average_score >= (5 * self.evaluation_threshold) and not any_low_scores
            else "Reject Code"
        )

        return decision, total_score, scores
