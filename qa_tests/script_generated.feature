gherkin
Feature: Ticketing Logic

  # Test Case ID: 4d319c0b-4378-48e4-abf5-3ecce88401c7
  # Scenario Outline: TicketingLogic-002 - Reply email with changed subject of existing ticket should update ticket
  # Preconditions: User must have access to Test APP WebUI and email client.

  @critical
  Scenario: Reply email with changed subject of existing ticket should update ticket
    Given WebAgent open "Test APP WebUI URL"
    When Login as "Test User"
    Then WebAgent is on InboxModule

    # Step 1: Send New Email to DL1 with Subject1 and Body1
    When WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    And Select "DL1" from mailFromDropdownlist
    And WebAgent type "DL1" into mailToText
    And WebAgent type "Subject1" into mailSubjectText
    And WebAgent type "Body1" into mailContentText
    Then WebAgent click on mailSendButton
    And Wait 5 seconds
    Then Close Browser

    # Step 2: Open Test APP WebUI to check ticket XL001
    Given WebAgent open "Test APP WebUI URL"
    When Login as "Test User"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    And Wait 20 seconds
    And Get Ticket ID by Subject "Subject1" and save into @ticketId
    When Open ticket by ID "@ticketId.Value"
    Then Check ticket Subject is "Subject1"
    And Check ticket Body is "Body1"
    Then Close Browser

    # Step 3: Reply this Email to DL1 with Subject2
    Given WebAgent open "Test APP WebUI URL"
    When Login as "Test User"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    And Wait 20 seconds
    When Open ticket by ID "@ticketId.Value"
    Then WebAgent click on commentsButton1
    And WebAgent type "Subject2" into mailSubjectText
    Then WebAgent click on mailSendButton
    And Wait 5 seconds
    Then Close Browser

    # Step 4: Open Test APP WebUI to check ticket XL001
    Given WebAgent open "Test APP WebUI URL"
    When Login as "Test User"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    And Wait 20 seconds
    When Open ticket by ID "@ticketId.Value"
    Then Check ticket Subject is "Subject1"
    And Check ticket Body is "Body1"
    Then Close Browser

    # Step 5: Open Test APP WebUI to check ticket XL002
    Given WebAgent open "Test APP WebUI URL"
    When Login as "Test User"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    And Wait 20 seconds
    And Get Ticket ID by Subject "Subject2" and save into @newTicketId
    When Open ticket by ID "@newTicketId.Value"
    Then Check ticket Subject is "Subject2"
    Then Close Browser

  # Comments:
  # If there are no available webui cucumber steps or web elements that you want to use, you can customize a new one and display it in a table.
  # | Annotation Condition | Matching Condition |
  # |----------------------|--------------------|
  # | @And("^Check ticket Subject is \"([^\"]*)\"$") | Check ticket Subject is "([^"]*)" |
  # | @And("^Check ticket Body is \"([^\"]*)\"$") | Check ticket Body is "([^"]*)" |


### Explanation:
- **Test Case ID**: A unique identifier for the test case is provided.
- **Scenario Outline**: Describes the purpose of the test case.
- **Preconditions**: Lists any prerequisites needed before executing the test.
- **Steps**: Detailed actions to be performed, using the available web elements and cucumber steps.
- **Expected Results**: The expected outcomes are checked using custom steps if necessary.
- **Comments**: Provides a table for any custom steps that need to be defined.