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
    cucumber_script_basic_example = readFile(
        "../knowledges/apac-email-case/cucumber_knowledges/cucumber_script_base.feature")
    available_web_elements = readFile("../knowledges/apac-email-case/cucumber_knowledges/WebElement.yml")
    available_webui_cucumber_system_steps = readFile(
        "../knowledges/apac-email-case/cucumber_knowledges/fast_webui_cucumber_system_steps.txt")
    available_webui_cucumber_project_steps = readFile(
        "../knowledges/apac-email-case/cucumber_knowledges/fast_webui_cucumber_project_steps.txt")

    prompt = f"""
        Optimize the following Gherkin script based on these issues and test cases:
        issues:
        {issues}
        
        test case:
        {test_case}

        Original Script:
        {script}
        
        # GUIDELINES #
Please follow these guidelines:
1. Convert each test case into a Gherkin format, which includes Given, When, and Then statements.
2. Ensure that each steps is clear and concise, using plain language.
3. If applicable, include And statements to combine steps for improved readability.
4. Use tags for scenarios that require specific conditions or environments.

#############

# CUCUMBER SCRIPT EXAMPLE #
This is the cucumber script example that has already been written. You can read it to understand the general operating logic of the system.
You need write a script corresponding to the generated test case requirements, but you are not able to copy this example.

{cucumber_script_basic_example}

#############

# AVAILABLE WEB ELEMENTS #
You must use the provided web elements as part of the script. 
If there are no web elements you want to use, Please define them in comments at the end, you just need give the name of the web elementes that you want to use.

{available_web_elements}

#############
You must use the provided web ui cucumber steps as part of the script. 
If there are no web ui cucumber steps you want to use, Please define them in comments at the end.you need give the annotation conditions and matching conditions, such as @And("^Check ticket Subject is \"([^\"]*)\"$").

# AVAILABLE WEBUI CUCUMBER SYSTEM STEPS #
{available_webui_cucumber_system_steps}

#############

# AVAILABLE WEBUI CUCUMBER PROJECT STEPS #
{available_webui_cucumber_project_steps}

#############

# STYLE #
Style refer to the successful software company, such Google, Microsoft.
You need to refer to existing cucumber scripts,  take them as Example, learn writing habit and format to write test case:

#############

# TONE #
Professional, technical

#############

# AUDIENCE #
The generated cucumber scripts should be detailed and meet the requirements, meet each steps and expected result in the test cases, and ensure that the script can run normally

#############

# RESPONSE #

Each generated cucumber scripts includes the following components:

Test Case ID(mandatory): A unique identifier for the test case.
Scenario Outline(mandatory): A brief description of what the test case is intended to verify.
Preconditions(mandatory): Any prerequisites that must be met before executing the test case.
Steps(mandatory): A detailed list of actions to be performed in the test case.
Expected Results(optional): The expected outcome after executing the steps.
Examples(mandatory): The defined parameters you need to use. These parameters need to be used in <>
Comments(optional): If there are no available webui cucumber steps or web elements that you want to use. You can customize a new one and display it in a table

#############

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


def readFile(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        file_content = file.read()
    return file_content
