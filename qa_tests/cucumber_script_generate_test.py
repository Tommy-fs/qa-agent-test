from tool.cucumber_script_generate_tool import cucumber_script_generate, readFile

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

cucumber_script_base = readFile("../knowledges/cucumber_knowledges/cucumber_script_base.feature")
available_web_elements = readFile("../knowledges/cucumber_knowledges/WebElement.yml")
available_webui_cucumber_system_steps = readFile(
    "../knowledges/cucumber_knowledges/fast_webui_cucumber_system_steps.txt")
available_webui_cucumber_project_steps = readFile(
    "../knowledges/cucumber_knowledges/fast_webui_cucumber_project_steps.txt")

res = cucumber_script_generate(test_cases)

print(res)
