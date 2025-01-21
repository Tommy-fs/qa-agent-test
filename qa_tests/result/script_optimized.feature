gherkin
Feature: Ticketing System Email Reply Logic
  This feature verifies that replying to an email with a changed subject creates a new ticket in the system.

  @ticketing
  Scenario Outline: TicketingLogic-002 Reply email with changed subject of existing ticket should update ticket
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule

    # Step 1: Send a new email to DL1 with Subject1 and Body1
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    And Select "<DL1>" from mailFromDropdownlist
    And WebAgent type "<DL1>" into mailToText
    Then WebAgent click on mailAddressoption
    And Wait 1 second
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
    And Get Ticket ID by Subject "<Subject1>" and save into @ticketId1
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
    And Get Ticket ID by Subject "<Subject1>" and save into @ticketId1
    When Open ticket by ID "@ticketId1.Value"
    Then Check ticket Subject is "<Subject1>"
    And Check ticket Body is "<Body1>"

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


### Key Changes:
1. **Added Missing Steps**: Included the missing steps to check the creation of ticket XL002 and ensure the reply action is performed correctly.
2. **Consolidated Steps**: Combined related actions using `And` statements for improved readability.
3. **Ensured Completeness**: Verified that all steps from the test case are represented in the script.
4. **Used Provided Elements**: Utilized the available web elements and steps as per the guidelines.