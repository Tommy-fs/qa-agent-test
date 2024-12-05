from core.llm_chat import LLMChat

script_result_path = "./result/script_optimized.feature"

def score_gherkin_script(script: str, test_case: dict, resources: dict) -> dict:
    """
    Score the generated Gherkin script based on multiple criteria.
    Args:
        script (str): The Gherkin script to evaluate.
        test_case (dict): The original test case.
        resources (dict): Available resources (web elements, system steps).

    Returns:
        dict: A score breakdown and total score.
    """
    score = {
        "syntax_correctness": 0,
        "test_case_coverage": 0,
        "resource_usage": 0,
        "logical_clarity": 0,
        "total_score": 0,
    }

    # Syntax correctness (30 points)
    # try:
    #     from gherkin.parser import Parser
    #     parser = Parser()
    #     parser.parse(script)
    #     score["syntax_correctness"] = 30
    # except Exception:
    #     score["syntax_correctness"] = 0

    # Test case coverage (30 points)
    test_steps = test_case.get("Steps", [])
    covered_steps = sum(1 for step in test_steps if step in script)
    score["test_case_coverage"] = min(30, (covered_steps / len(test_steps)) * 30)

    # Resource usage (20 points)
    used_resources = sum(1 for res_type in resources for res in resources[res_type] if res in script)
    total_resources = sum(len(resources[res_type]) for res_type in resources)
    score["resource_usage"] = min(20, (used_resources / total_resources) * 20)

    # Logical clarity (20 points)
    if "Given" in script and "When" in script and "Then" in script:
        score["logical_clarity"] = 20  # Assuming basic clarity for this example

    # Total score
    score["total_score"] = sum(score.values())
    return score


def optimization_gherkin_script(issues: str, test_case: str, script: str):
    prompt = f"""
        Optimize the following Gherkin script based on these issues and test cases:
        issues:
        {issues}
        
        test case:
        {test_case}

        Original Script:
        {script}
        """
    parameters = {
        "test_case": test_case,
        "issues": issues,
        "script": script
    }

    # Use GPT to analyze all steps at once
    gpt_response = (
        LLMChat(model_type='ADVANCED').prompt_with_parameters(prompt, parameters,
                                                              'optimization Script',
                                                              desc='optimization Script')
        .replace("```json", '').replace("```", ''))

    writeFile(script_result_path, gpt_response)

    return gpt_response


def writeFile(file_path, file_content):
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(file_content)
