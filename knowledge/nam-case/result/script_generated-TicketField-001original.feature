# Feature: Verify "Auto Test Ref#" field functionality in Normal DL tickets

# Author: Bard (Generated from TicketField-001)
# Workflow: Normal DL Ticket Creation and Update
# Check Point: Auto Test Ref# field behavior
# Key Value: Auto Test Ref#

Feature: TicketField-001 - Auto Test Ref# Field Functionality

  @TicketField @Regression @High
  Scenario Outline: Verify Auto Test Ref# field

    # Preconditions: User with Operation Manager access is logged in.

    # STEP 1: Login to the system
    Given WebAgent open "$xxx systemNAMLoginPage" url
    And Login SSO as "SopsManagel"
    And Wait 5 seconds
    And Login as "SopsManage1"

    # STEP 2: Navigate to New Message page
    And WebAgent click on inboxIcon
    And Wait 5 seconds
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on newMessagePage

    # STEP 3: Create a new ticket (Simplified for this test case)
    And Select "*GT CN xxx system Loan Dev Test" from processingTeamDropdownlist
    And Select "*GT CN xxx system Loan Dev Test" from frompropdownlist
    And WebAgent type "testuser@example.com" into toText # Simplified recipient
    And WebAgent type "[TicketField-001] Auto Test Ref# Test" into subjectText
    And WebAgent type "OTHER" into requestTypeDropdownlist
    Then WebAgent click on sendButton # Send the ticket
    And Wait 10 seconds

    # STEP 4: Open the created ticket
    Then WebAgent change to tab "xxx system Loan"
    Then WebAgent is on LoanPage
    And Wait 60 seconds
    And WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And WebAgent click on clearUserPreferenceButton
    And Wait 10 seconds
    And Get Ticket ID by Subject "[TicketField-001] Auto Test Ref# Test" and save into @ticketId
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on workflowPage


    # STEP 5: Update the ticket and check Auto Test Ref# field
    Then WebAgent click on updateTicketAction
    And WebAgent type "<auto_test_ref>" into autoTestRefText
    Then WebAgent click on updateTicketButton
    And Wait 4 seconds
    And check "Auto Test Ref#" Ticketvalue is "<auto_test_ref>"

    # STEP 6: Close the ticket
    Then WebAgent click on closeParentAction
    Then Wait 1 seconds
    Then WebAgent click on c1ase5ubAct1am # Placeholder for close sub-action - NEEDS REPLACEMENT WITH CORRECT WEB ELEMENT
    Then Wait 5 seconds
    Then check "Status" TicketValue is "Closed"
    Then check "Sub Status" Ticketvalue is "Closed"


    Examples:
      | auto_test_ref |
      | TESTREF123   |
      | 1234567890   |
      | A1B2C3D4E5   |


# New Web Element used:
# | Element Name        | Selector/Trait                               | Description                                      |
# |---------------------|---------------------------------------------|-------------------------------------------------|
# | autoTestRefText     | #autoTestRefText (Needs actual selector)    | The Auto Test Ref# text field in the update form |
# | c1ase5ubAct1am      |  (Needs actual selector)                    | The close sub-action button/element             |


# Note: The web element selectors for autoTestRefText and c1ase5ubAct1am are placeholders and need to be replaced with the actual selectors from the application.  The simplified email recipient in Step 3 also needs review.  Ensure all other steps and elements align with the actual application.