gherkin
Feature: Ticketing Logic

  # Test Case ID: 4d319c0b-4378-48e4-abf5-3ecce88401c7
  # Scenario Outline: Reply email with changed subject of existing ticket should update ticket
  # Preconditions: Ensure that the Test APP WebUI is accessible and the email distribution list DL1 is configured.
  
  @critical
  Scenario Outline: TicketingLogic-002 Reply email with changed subject of existing ticket should update ticket

    Given WebAgent open "<testAPPWebUIURL>" url
    #**************************************************************
    # STEP 1: Send New Email to DL1 with Subject1 and Body1
    #**************************************************************
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on createButton
    And WebAgent click on newMessageltem
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

    #**************************************************************
    # STEP 2: Open Test APP WebUI to check ticket XL001
    #**************************************************************
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Get Ticket ID by Subject "<Subject1>" and save into @ticketId

    #**************************************************************
    # STEP 3: Reply this Email to DL1 with Subject2
    #**************************************************************
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent click on typeEmailCommentsRadio
    And WebAgent type "<Subject2>" into mailSubjectText
    Then WebAgent click on commentsButton2
    And Wait 5 seconds

    #**************************************************************
    # STEP 4: Open Test APP WebUI to check ticket XL001
    #**************************************************************
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Open ticket by ID "@ticketId.Value"
    Then Check ticket Subject is "<Subject1>"

    #**************************************************************
    # STEP 5: Open Test APP WebUI to check ticket XL002
    #**************************************************************
    Given WebAgent open "<testAPPWebUIURL>" url
    When Login as "<User>"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Get Ticket ID by Subject "<Subject2>" and save into @newTicketId
    And Open ticket by ID "@newTicketId.Value"
    Then Check ticket Subject is "<Subject2>"

    Examples:
      | testAPPWebUIURL | User   | DL1   | Subject1 | Body1 | Subject2 |
      | http://testapp  | Admin  | DL1   | Subject1 | Body1 | Subject2 |

  # Comments:
  # If there are no available webui cucumber steps or web elements that you want to use, please define them here.
  # For example, you might need a step to check the ticket subject:
  # @And("^Check ticket Subject is \"([^\"]*)\"$")


### Explanation:
- **Test Case ID**: A unique identifier for the test case is provided.
- **Scenario Outline**: Describes the scenario being tested.
- **Preconditions**: Lists any prerequisites for the test.
- **Steps**: Detailed steps are provided using Given, When, Then, and And statements.
- **Examples**: Defines the parameters used in the scenario.
- **Comments**: Allows for customization if necessary web elements or steps are not available.