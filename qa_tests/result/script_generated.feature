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
    When Open ticket by ID "@ticketId1.Value"
    Then Check ticket Subject is "<Subject1>"
    And Check ticket Body is "<Body1>"

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


### Explanation:
- **Test Case ID**: The scenario outline is labeled with the test case ID `TicketingLogic-002`.
- **Scenario Outline**: Describes the scenario to verify the functionality of replying to an email with a changed subject.
- **Preconditions**: The user must be logged in and have access to the Test APP WebUI.
- **Steps**: Detailed actions are provided for sending a new email, checking the ticket, replying with a changed subject, and verifying the creation of a new ticket.
- **Examples**: Parameters such as `testAPPWebUIURL`, `User`, `DL1`, `Subject1`, `Body1`, and `Subject2` are defined for use in the scenario.
- **Comments**: Additional notes are provided for customization and ensuring the script's functionality.