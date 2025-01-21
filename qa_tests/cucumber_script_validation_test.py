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
    When Open ticket by ID "@ticketId1.Value"
    Then Check ticket Subject is "<Subject1>"
    And Check ticket Body is "<Body1>"

    # Step 3: Reply to this email to DL1 with Subject2
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Wait 5 seconds
    Then Close Browser

    # Step 4: Open Test APP WebUI to check ticket XL001
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule


    # Step 5: Open Test APP WebUI to check ticket XL002
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Get Ticket ID by Subject "<Subject2>" and save into @ticketId2
    When Open ticket by ID "@ticketId2.Value"
    Then Check ticket Subject is "<Subject2>"

    Examples:
      | testAPPWebUIURL | User    | DL1   | Subject1 | Body1   | Subject2 |
      | http://testapp  | Tester1 | DL1   | Subject1 | Body1   | Subject2 |

# Comments:
# - If there are no available webui cucumber steps or web elements that you want to use, you can customize a new one and display it in a table.
# - Ensure that the script can run normally and meets each step and expected result in the test cases.


"""

res = validate_test_steps(test_cases, script)

print("res" + "\n" + str(res))

