# 11/cucumber_scripts_evaluator.py

import json
from typing import Optional, List

from agent_core.evaluators import BaseEvaluator
from agent_core.evaluators.entities.evaluator_result import EvaluatorResult


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


class CodingEvaluator(BaseEvaluator):
    DEFAULT_PROMPT = """\
You are an expert code reviewer with extensive experience in software engineering and multiple programming languages.
Your task is to evaluate the provided AI-generated code based on the following comprehensive criteria. Note: The provided code may be a complete implementation or just a code fragment. If a particular criterion is not applicable, please mark it as "N/A" and exclude it from the overall scoring.

1. **Standardization of Feature Modules**(Score 1-10 or N/A)
   - [ ] The **Feature module** should include basic information about the script, such as:
     - The name of the functional module being tested.
     - Author information (e.g., name or team name).
     - Creation date and last modification date.
     - Other key information (e.g., version number, dependency environment, etc.).
   - [ ] The Feature description should be concise and accurately summarize the goals and scope of the test scenario.

2. **Clarity of Scenario Outline**(Score 1-10 or N/A)
   - [ ] The **Scenario Outline** should clearly describe the main test points of the script, including:
     - The goal of the test scenario.
     - The input data and expected results involved.
     - If parameterized testing is used, list all possible parameter combinations.
   - [ ] Use the `Examples` table to clearly define test data, ensuring readability and maintainability.

3. **Step Comments and Readability**(Score 1-10 or N/A)
   - [ ] Add comments before each test step, including:
     - Step number (e.g., "Step 1").
     - The user role performing the action.
     - A description of the specific action for the step.
   - [ ] Comments should be concise and avoid redundant information to facilitate future maintenance and team collaboration.

4. **Initialization and Cleanup of Test Steps**(Score 1-10 or N/A)
   - [ ] At the beginning of each test scenario, clearly define initialization steps, such as:
     - Opening the browser and navigating to the target website.
     - Logging into the system with the specified user role.
   - [ ] At the end of each test scenario, perform cleanup operations, such as:
     - Closing the browser.

5. **Standardization of Data Input and Page Operations**(Score 1-10 or N/A)
   - [ ] When entering data on a page, follow these rules:
     - Refer to templates to select the correct page type, method, and value.
     - Use default values from the template for fields not specifically specified.
     - For fields that are specifically specified, use the given values.

   - [ ] Before users operate on data, ensure the following:
     - Open the correct data page.
     - Click the edit button to enter edit mode.
     - After entering the required values, perform the corresponding action (e.g., save, submit, etc.).

6. **Completeness of Checkpoints**(Score 1-10 or N/A)
   - [ ] The test script should include necessary checkpoints to verify whether the system behavior meets expectations, such as:
     - Display status of page elements (e.g., buttons, text, prompt messages, etc.).
     - Correctness of field values (e.g., input validation, calculation results, etc.).
   - [ ] Each checkpoint should clearly describe the expected result and compare it with the actual result.

7. **Code Structure and Maintainability**(Score 1-10 or N/A)
   - [ ] The test script should follow Cucumber framework best practices, such as:
     - Using clear Gherkin syntax (Given-When-Then structure).
     - Avoiding code duplication by extracting common steps into reusable methods.
     - Using tags to categorize and manage test scenarios.
   - [ ] The script should have good readability and maintainability, such as:
     - Using meaningful variable and method names.
     - Adding necessary comments to explain complex logic.
     - Following the project's code style guidelines.

8. **Performance and Stability**(Score 1-10 or N/A)
   - [ ] The test script should consider performance and stability, such as:
     - Avoiding unnecessary wait times by using explicit waits instead of hard-coded waits.
     - Ensuring consistent results across multiple executions to avoid failures due to environment or data issues.

9. **Dependency Management and Environment Adaptation**(Score 1-10 or N/A)
    - [ ] The test script should clearly annotate its dependencies on external conditions (e.g., database state, network environment, third-party services, etc.).
    - [ ] For scripts requiring specific environments or configurations, provide detailed setup instructions to ensure test executability.

10. **Reference document relevance**(Score 1-10 or N/A)
    - [ ] Some action script codes are provided in the template.The comment specifies which action
    - [ ] When there is an action in the test case, you need to use the corresponding action code provided by the template as the basis
    - [ ] Modify the parameters, steps and other contents in the corresponding template according to specific needs to generate new related script files


For each criterion, provide:

- **Score (1-10) or N/A**
- **Justification:** A brief explanation for your score or reason for marking it N/A.

At the end:

- Calculate the **Total Score**.
- Provide a final recommendation:

- **Accept Output** if the total score is above 85 and no criterion scored below 5.
- **Rerun Subtask** if the total score is 85 or below, or if any criterion scored below 5.

- If recommending a rerun, provide suggestions on how to improve the output.
- If output is an incorrect and unexpected structure in response, provide the structure evaluation output still (Score 0 for each criteria)
- If output is incorrect tool arguments and unexpected result when invoke the tool, provide the change suggestion and the structure evaluation output still (Score 0 for each criteria)
---

**Context**
{context}

**Description of ultimate task goal:**
{root_task}

**Request:**
{request}

**Response:**
{response}

**Evaluation (JSON Format):**
"""

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
        return self.DEFAULT_PROMPT

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
