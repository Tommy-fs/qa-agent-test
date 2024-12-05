import json

from tool.cucumber_script_generate_tool import cucumber_script_generate, readFile
from tool.cucumber_script_optimize_tool import optimization_gherkin_script
from tool.cucumber_script_validation_tool import validate_test_steps

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

script = """
gherkin
Feature: Ticketing System Email Reply Logic
  This feature verifies that replying to an email with a changed subject creates a new ticket in the system.

  @ticketing
  Scenario Outline: TicketingLogic-002 Reply email with changed subject of existing ticket should update ticket
    Given WebAgent open "<testAPPWebUIURL>" url
    # Step 1: Send a new email to DL1 with Subject1 and Body1
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    And Select "<DL1>" from mailFromDropdownlist
    And WebAgent type "<DL1>" into mailToText
    Then WebAgent click on mailAddressoption
    And Wait 1 seconds
    And WebAgent click on mailContentText
    And WebAgent type "<Body1>" into mailContentText
    And WebAgent type "<Subject1>" into mailSubjectText
    Then WebAgent click on mailSendButton
    And Wait 5 seconds
    Then Close Browser

    # Step 2: Open Test APP WebUI to check ticket XL001
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Get Ticket ID by Subject "<Subject1>" and save into @ticketId1

    # Step 3: Reply to this email to DL1 with Subject2
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    When Open ticket by ID "@ticketId1.Value"
    Then WebAgent click on commentsButton1
    And WebAgent type "<Subject2>" into mailSubjectText
    Then WebAgent click on commentsButton2
    And Wait 5 seconds
    Then Close Browser

    # Step 4: Open Test APP WebUI to check ticket XL001
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    When Open ticket by ID "@ticketId1.Value"
    Then Check ticket Subject is "<Subject1>"


    Examples:
      | testAPPWebUIURL | User    | DL1   | Subject1 | Body1   | Subject2 |
      | http://testapp  | Tester1 | DL1   | Subject1 | Body1   | Subject2 |

# Comments:
# - If there are no available webui cucumber steps or web elements that you want to use, you can customize a new one and display it in a table.
# - Ensure that the script can run normally and meets each steps and expected result in the test cases.


### Explanation:
- **Test Case ID**: The scenario outline is labeled with the test case ID `TicketingLogic-002`.
- **Scenario Outline**: Describes the scenario to verify the functionality of replying to an email with a changed subject.
- **Preconditions**: The user must be logged in and have access to the Test APP WebUI.
- **Steps**: Detailed actions are provided for sending a new email, checking the ticket, replying with a changed subject, and verifying the creation of a new ticket.
- **Examples**: Parameters such as `testAPPWebUIURL`, `User`, `DL1`, `Subject1`, `Body1`, and `Subject2` are defined for use in the scenario.
- **Comments**: Additional notes are provided for customization and ensuring the script's functionality.
"""

missing_steps = [
    {
        'step': 'Reply this Email to DL1 with Subject2',
        'reason': 'The Gherkin script does not correctly represent the expected result of creating a new ticket XL002. The script only changes the subject of the existing ticket but does not verify the creation of a new ticket with Subject2. The expected result should include checking for the creation of a new ticket with the updated subject.'
    },
    {
        'step': 'Open Test APP WebUI to check ticket XL002',
        'reason': 'The Gherkin script does not include a step to verify that a new ticket XL002 is created with Subject2. The script should include a step to check the existence of ticket XL002 with Subject2 to match the expected result.'
    }
]

issues = ""

for idx, step_info in enumerate(missing_steps, start=1):
    issues += f"-Missed step {step_info['step']}\n"
    issues += f"  Reason: {step_info['reason']}\n\n"

res = optimization_gherkin_script(issues, test_cases, script)

print("res" + "\n" + str(res))
