```gherkin
Feature: TicketField-001 - Verify "Auto Test Ref#" field functionality in Normal DL Ticket creation and update.
  1) Author: Jinyang
  2) Workflow: Normal DL Ticket creation and update
  3) Check Point: Verify "Auto Test Ref#" field functionality
  4) Key Value: Auto Test Ref# field

  @TicketField-001 @High @Regression
  Scenario Outline: Verify "Auto Test Ref#" field functionality in Normal DL Ticket creation and update.
    # Preconditions: Operations Manager has access to XMC Loan Web.

    # ***************************************************
    # STEP 1: Operations Manager logs in to XMC Loan Web.
    # ***************************************************
    Given WebAgent open "$xxx systemNAMLoginPage"url
    And Login SSo as "SopsManagel"
    And Wait 5 seconds
    And Login as "SopsManage1"

    # ***************************************************
    # STEP 2: Create a new Normal DL Ticket via "New Message".
    # ***************************************************
    And WebAgent click on inboxIcon
    And Wait 5 seconds
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on newMessagePage

    # Select DL A in Processing Team Dropdown list.
    And Select "<ProcessingTeam>" from processingTeamDropdownlist
    And Select "<FromEmail>" from fromDropdownlist

    # input To address
    And WebAgent type "<ToEmail>" into toText

    # input Subject
    Then Prepare Ticket Subject begin with "[xxx system Test]NormalDLTicket-"and Save into @ticketsubject
    And WebAgent type "@ticketsubject.Value"into subjectText
    And Select "<RequestType>" from requestTypeDropdownlist

    # Click Send button.
    Then WebAgent click on sendButton
    And Wait 10 seconds

    # Go to All Ticket Inbox and Open ticket
    Then WebAgent change to tab "xxx system Loan"
    Then WebAgent is on LoanPage
    And Wait 60 seconds
    And WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And Get Ticket ID by Subject "@ticketsubject.Value"and save into @ticketId
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds

    # ***************************************************
    # STEP 3: Open the newly created ticket.
    # ***************************************************
    # The ticket details page should open. This is implicitly verified by the following steps.

    # ***************************************************
    # STEP 4: Verify the presence of "Auto Test Ref#" field in the "Update Ticket" action form.
    # ***************************************************
    Then WebAgent click on updateTicketAction
    And Wait 2 seconds
    Then WebAgent see autoTestRefText

    # ***************************************************
    # STEP 5: Click "Update Ticket" action button without entering a value in "Auto Test Ref#" field.
    # ***************************************************
    Then WebAgent click on updateTicketButton
    And Wait 2 seconds

    # ***************************************************
    # STEP 6: Verify the presence of "Auto Test Ref#" field in the "Additional Details" section.
    # ***************************************************
    # Assuming "Additional Details" section is always visible or expands automatically.
    # If not, an additional step to expand the section might be needed.
    # This step verifies the presence of the field, but not the value (which is checked later).
    Then WebAgent see autoTestRefText

    # ***************************************************
    # STEP 7: Click "Update Ticket" action button with "Auto Test Ref#" value.
    # ***************************************************
    Then WebAgent click on updateTicketAction
    And WebAgent type "<AutoTestRef>" into autoTestRefText
    Then WebAgent click on updateTicketButton
    And Wait 2 seconds

    # ***************************************************
    # STEP 8: Verify the value of "Auto Test Ref#" field in the "Additional Details" section.
    # ***************************************************
    And check "Auto Test Ref#" Ticketvalue is "<AutoTestRef>"

    # ***************************************************
    # STEP 9: Close the ticket.
    # ***************************************************
    Then WebAgent click on closeParentAction
    Then Wait 1 seconds
    Then WebAgent click：onc1ase5 ubAct1am
    Then Wait 5 seconds
    Then check "Status"TicketValue is "Closed"
    Then check "Sub Status"Ticketvalue is "Closed"
    Then WebAgent click on expandAuditTrail
    And Wait 1 seconds
    Then Close Browser

    Examples:
      | ProcessingTeam | FromEmail | ToEmail | RequestType | AutoTestRef |
      | *GT CN DevTest | TESTFROM1@CITI.COM | TESTTO1@CITI.COM | Normal DL | TESTREF123 |

Feature: TicketField-002 - Verify "Auto Test Ref#" field behavior with existing Normal DL Tickets.
  1) Author: Jinyang
  2) Workflow: Normal DL Ticket update
  3) Check Point: Verify "Auto Test Ref#" field behavior with existing Normal DL Tickets
  4) Key Value: Auto Test Ref# field

  @TicketField-002 @Medium @Regression
  Scenario Outline: Verify "Auto Test Ref#" field behavior with existing Normal DL Tickets.
    # Preconditions: Operations Manager has access to XMC Loan Web and an existing Normal DL Ticket exists.

    # ***************************************************
    # STEP 1: Operations Manager logs in to XMC Loan Web.
    # ***************************************************
    Given WebAgent open "$xxx systemNAMLoginPage"url
    And Login SSo as "SopsManagel"
    And Wait 5 seconds
    And Login as "SopsManage1"

    # ***************************************************
    # STEP 2: Open an existing Normal DL Ticket.
    # ***************************************************
    And WebAgent click on inboxIcon
    And Wait 5 seconds
    Then WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And Get Ticket ID by Subject "<TicketSubject>"and save into @ticketId
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds

    # ***************************************************
    # STEP 3: Verify the presence of "Auto Test Ref#" field in the "Update Ticket" action form.
    # ***************************************************
    Then WebAgent click on updateTicketAction
    And Wait 2 seconds
    Then WebAgent see autoTestRefText

    # ***************************************************
    # STEP 4: Click "Update Ticket" action button without modifying any fields.
    # ***************************************************
    Then WebAgent click on updateTicketButton
    And Wait 2 seconds

    # ***************************************************
    # STEP 5: Click "Update Ticket" action button with "Auto Test Ref#" value.
    # ***************************************************
    Then WebAgent click on updateTicketAction
    And WebAgent type "<AutoTestRef>" into autoTestRefText
    Then WebAgent click on updateTicketButton
    And Wait 2 seconds

    # ***************************************************
    # STEP 6: Verify the value of "Auto Test Ref#" field in the "Additional Details" section.
    # ***************************************************
    And check "Auto Test Ref#" Ticketvalue is "<AutoTestRef>"

    # ***************************************************
    # STEP 7: Close the ticket.
    # ***************************************************
    Then WebAgent click on closeParentAction
    Then Wait 1 seconds
    Then WebAgent click：onc1ase5 ubAct1am
    Then Wait 5 seconds
    Then check "Status"TicketValue is "Closed"
    Then check "Sub Status"Ticketvalue is "Closed"
    Then WebAgent click on expandAuditTrail
    And Wait 1 seconds
    Then Close Browser

    Examples:
      | TicketSubject | AutoTestRef |
      | [xxx system Test]ExistingNormalDLTicket- | TESTREF456 |
```