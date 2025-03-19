import argparse
import json

from agent_core.agents import Agent
from agent_core.evaluators.entities.evaluator_result import EvaluatorResult

from evaluators.cucumber_evaluator_prompt import CUCUMBER_EVALUATOR_PROMPT


class CucumberEvaluator:

    def evaluate(self, test_case, cucumber_script) -> EvaluatorResult:
        """
        Evaluate the provided request and generated script response.
        """

        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        cucumber_script_basic_template = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/cucumber_script_base.feature")
        available_web_elements = self.readFile("../knowledge/" + case + "/cucumber_knowledge/WebElement.yml")
        available_webui_cucumber_system_steps = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_system_steps.txt")
        available_webui_cucumber_project_steps = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/fast_webui_cucumber_project_steps.txt")
        script_generate_guide = self.readFile(
            "../knowledge/" + case + "/cucumber_knowledge/script_generate_guide.txt")

        prompt_text = (self.default_prompt()
                       .format(test_case=test_case,
                               cucumber_script=cucumber_script,
                               cucumber_script_basic_template=cucumber_script_basic_template,
                               script_generate_guide=script_generate_guide,
                               available_web_elements=available_web_elements,
                               available_webui_cucumber_system_steps=available_webui_cucumber_system_steps,
                               available_webui_cucumber_project_steps=available_webui_cucumber_project_steps
                               ))

        agent = Agent(model_name="gemini-1.5-pro-002")

        evaluation_response = agent.execute(prompt_text)

        decision, score, suggestion, details = self.parse_scored_evaluation_response(
            evaluation_response
        )

        return EvaluatorResult(
            decision=decision,
            score=score,
            suggestion=suggestion,
        )

    def default_prompt(self):
        return CUCUMBER_EVALUATOR_PROMPT

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

    def readFile(self, file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                file_content = file.read()
            return file_content
        except:
            return ""
