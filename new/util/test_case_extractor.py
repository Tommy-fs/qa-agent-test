import re


def extract_test_steps(test_cases: str) -> list:
    """
    Extract all Test Steps from the test case text.

    Args:
        test_cases (str): The test case input as a string.

    Returns:
        list: A list of extracted Test Steps.
    """
    # Use regex to match rows in the test steps table
    match = re.findall(r"\|\s*\d+\s*\|\s*(.*?)\s*\|", test_cases)

    # Clean up extracted test steps
    test_steps = [step.strip() for step in match]
    return test_steps


# 示例输入
test_cases = """
id: 4d319c0b-4378-48e4-abf5-3ecce88401c7
Name: TicketingLogic-002
Summary: Reply email with changed subject of existing ticket should update ticket
Priority: Critical

| No. | Test Step | Test Data | Expected Result |
| ----- | ------------------------------------------------ | ---------------------------- | ------------------------------------------------------ |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1 | Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Create new ticket XL002 in Test APP |
| 4 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 remains unchanged |
| 5 | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject2 |
"""

# 调用方法
test_steps = extract_test_steps(test_cases)

# 输出结果
print(test_steps)
