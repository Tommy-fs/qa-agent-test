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

    # Step 3: Reply to this email to DL1 with Subject2
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    When Open ticket by ID "@ticketId1.Value"
    Then WebAgent click on replyButton
    And WebAgent type "<Subject2>" into mailSubjectText
    Then WebAgent click on sendReplyButton
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
    Then Check ticket ID "@ticketId2.Value" exists
    And Check ticket Subject is "<Subject2>"

    Examples:
      | testAPPWebUIURL | User    | DL1   | Subject1 | Body1   | Subject2 |
      | http://testapp  | Tester1 | DL1   | Subject1 | Body1   | Subject2 |

# Comments:
# - If there are no available webui cucumber steps or web elements that you want to use, you can customize a new one and display it in a table.
# - Ensure that the script can run normally and meets each step and expected result in the test cases.


### Key Changes:
1. **Reply Step Update**: Changed the step to use `replyButton` and `sendReplyButton` to simulate replying to an email.
2. **New Ticket Verification**: Added a new step (Step 5) to verify the creation of ticket XL002 with Subject2.
3. **Ticket Existence Check**: Added checks to ensure the new ticket ID is retrieved and verified for existence and correct subject.

These changes ensure that the script accurately reflects the test case requirements and verifies the creation of a new ticket with the updated subject.