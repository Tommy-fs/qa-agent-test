import re

from core.llm_chat import LLMChat
from util import test_case_extractor
import subprocess
import json
import os


def validate_test_steps(test_cases: str, script: str) -> dict:
    """
    Validate all Test Steps at once by using GPT for semantic validation.

    Args:
        test_cases (str): A list of test steps from the test case.
        script (str): Generated Gherkin script.

    Returns:
        dict: Validation result with missing steps, matched steps, and score.
    """
    test_steps = test_case_extractor.extract_test_steps(test_cases)

    # Generate the validation prompt
    prompt = f"""
    You are an expert in Gherkin scripts. Validate whether each test step, along with its Test Data and Expected Result, is correctly represented in the provided Gherkin script. 

    Please analyze from a global perspective whether each step of the test case is covered by the script. Don't check step by step rigidly, check globally
    Please verify from a human perspective, not a machine, as long as the script covers the test case
    The order of the test case steps does not need to correspond to the order of the script steps. For example, the first step of the test case can be covered in the fifth step of the script.
    
    ### Test Steps with Details:
    {test_cases}

    ### Gherkin Script:
    {script}

    For each test step in the test case, please ensure the following:
    1. **Correct Representation**: Does the Gherkin script accurately represent the **Test Step**, **Test Data**, and **Expected Result** provided in the test case?
    2. **Step Order and Flow**: Are the steps ordered logically (Given/When/Then) and in the correct sequence?
    3. **Test Data**: Is the **Test Data** correctly used within the step, and is it aligned with the corresponding action or condition in the Gherkin script?
    4. **Expected Results**: Does the **Expected Result** for each step match the behavior described in the test case? Ensure that the expected outcome is clear, detailed, and correctly expressed.

    Strictly respond in the following format for each step:
    - **Step step_number**: Matched/Not Matched
    - **Reason**: [If matched, provide no explanation. If not matched, provide a detailed explanation of what is missing, incorrect, or unclear, and give a recommended improvement.]

    Your response should cover these aspects:
    1. Any **missing steps**, **incorrect data**, or **incomplete expected results** in the script.
    2. If **any step** is completely missing, explain which specific part (e.g., Test Data, Expected Result) is absent.
    4. Ensure that each step is logically coherent and adheres to Gherkin best practices.

    Do not include any other information. Make sure the format is consistent, and do not add extra details. You must cover the following aspects for each step:
    1. **Correct Representation**: Does the Gherkin script accurately represent the Test Step, Test Data, and Expected Result?
    2. **Logical Flow**: Is the order of the steps correct (Given/When/Then)?
    3. **Missing Details**: Is there any missing Test Data or Expected Result for any step?

    Please do not leave out any steps and provide a clear reason for why any step did not match, including whether the issue is related to missing data, incorrect test steps, or mismatched expected results. Keep the output strictly formatted with no deviations.
    
    For example:
    - **Step 1**: Matched
    - **Step 2**: Not Matched
        - **Reason**: Missing Expected Result for the step.

    Strictly adhere to the above format and provide detailed feedback.
    """


    parameters = {"test_cases": test_cases, "script": script}
    gpt_response = (
        LLMChat().prompt_with_parameters(prompt, parameters,
                                                              'Cucumber Script steps validation',
                                                              desc='Cucumber Script steps validation')
        .replace("```json", '').replace("```", ''))

    results = {"missing_steps": [], "matched_steps": 0}
    lines = gpt_response.split("\n")
    for idx, line in enumerate(lines):
        if "**Step" in line:
            pattern = r"- \*\*Step (\d+)\*\*: (Matched|Not Matched)"
            match = re.match(pattern, line)
            if match:
                step_number = int(match.group(1))
                status = match.group(2)

                # Check if it's matched or not matched
                if status == "Not Matched":
                    reason = "No reason provided"
                    # Check next line for reason
                    if idx + 1 < len(lines) and "Reason" in lines[idx + 1]:
                        reason = lines[idx + 1].split("**Reason**:")[1].strip()

                    results["missing_steps"].append({
                        "step": test_steps[step_number - 1],
                        "reason": reason
                    })
                else:
                    results["matched_steps"] += 1

    # Calculate the score
    results["score"] = (results["matched_steps"] / len(test_steps)) * 100 if test_steps else 0
    return results


def run_behave_tests(feature_path='features', result_file='result.json'):

    if not os.path.exists(feature_path):
        print(f"Feature path {feature_path} does not exist.")
        return

    command = [
        'behave', feature_path,
        '--format', 'json',
        '--out', result_file
    ]

    try:
        # 执行命令
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print(f"Behave tests executed successfully. Results saved to {result_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while running behave: {e.stderr}")
    except FileNotFoundError:
        print("Behave command not found. Please ensure behave is installed.")


def validate_behave_result(result_file='result.json'):

    try:
        with open(result_file, 'r') as file:
            data = json.load(file)

        all_passed = True
        for feature in data:
            for scenario in feature.get('elements', []):
                for step in scenario.get('steps', []):
                    # 检查每个 step 的状态
                    if step.get('result', {}).get('status') != 'passed':
                        all_passed = False
                        print(f"Step failed: {step.get('name')}")

        if all_passed:
            print("All steps passed.")
        else:
            print("Some steps failed. See above for details.")

    except FileNotFoundError:
        print(f"Result file {result_file} not found!")
    except json.JSONDecodeError:
        print(f"Error decoding the JSON file {result_file}.")



