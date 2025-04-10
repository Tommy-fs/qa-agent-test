```gherkin
Feature: NormalDL-AutoTestRef-001
    1) Author: Jinyang
    2) Workflow: Normal DL ticket creation and update
    3) Check Point: Verify "Auto Test Ref#" field functionality in Normal DL tickets.
    4) Key Value: Auto Test Ref#

    @NormalDL @Regression @AutoTestRef
    Scenario Outline: NormalDL-AutoTestRef-001 Verify "Auto Test Ref#" field functionality in Normal DL tickets.
        # Preconditions: Operations Manager has access to XMC Loan Web.

        # ***************************************************
        # STEP 1: Operations Manager logs in to XMC Loan Web.
        # ***************************************************
        Given WebAgent open "$xxx systemNAMLoginPage"url
        And Login SSo as "SopsManagel"
        And Wait 5 seconds
        And Login as "SopsManage1"

        # ***************************************************
        # STEP 2: Create a new Normal DL ticket via "New Message".
        # ***************************************************
        And WebAgent click on inboxIcon
        And Wait 5 seconds
        Then WebAgent click on createButton
        And WebAgent click on newMessageItem
        And Wait 5 seconds
        Then WebAgent change to next tab
        Then WebAgent is on newMessagePage

        # Input ticket details
        And Select "*GT CN xxx system Loan Dev Test"from processingTeamDropdownlist
        And Select "TESTFROM1@CITI.COM"from fromDropdownlist
        And WebAgent type "TESTTO1@CITI.COM"into toText
        And Prepare Ticket Subject begin with "New Normal DL Ticket"and Save into @ticketsubject
        And WebAgent type "@ticketsubject.Value"into subjectText
        And Select "Normal DL"from requestTypeDropdownlist

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
        # The ticket details page should be displayed.
        Then WebAgent change to next tab
        Then WebAgent is on workflowPage

        # ***************************************************
        # STEP 4: Click the "Update Ticket" action button.
        # ***************************************************
        Then WebAgent click on updateTicketAction

        # ***************************************************
        # STEP 5: Verify the presence of the "Auto Test Ref#" field in the "Update Ticket" form.
        # ***************************************************
        Then WebAgent see autoTestRefText

        # ***************************************************
        # STEP 6: Scenario 1: Leave "Auto Test Ref#" blank. Submit the "Update Ticket" form without entering any value in the "Auto Test Ref#" field.
        # ***************************************************
        Then WebAgent click on updateTicketButton
        And Wait 4 seconds

        # ***************************************************
        # STEP 7: Verify the "Auto Test Ref#" field under the "Additional Details" section on the ticket details page.
        # ***************************************************
        # "Auto Test Ref#" field is displayed under "Additional Details" with no value.
        # This step requires custom code to verify the absence of a value in the "Auto Test Ref#" field.
        # Assuming a step definition exists to check ticket details:
        And check "Auto Test Ref#" Ticketvalue is ""

        # ***************************************************
        # STEP 8: Click the "Update Ticket" action button again.
        # ***************************************************
        Then WebAgent click on updateTicketAction

        # ***************************************************
        # STEP 9: Scenario 2: Enter a value in "Auto Test Ref#".
        # ***************************************************
        And WebAgent type "<AutoTestRef>" into autoTestRefText

        # ***************************************************
        # STEP 10: Submit the "Update Ticket" form.
        # ***************************************************
        Then WebAgent click on updateTicketButton
        And Wait 4 seconds

        # ***************************************************
        # STEP 11: Verify the "Auto Test Ref#" field under the "Additional Details" section on the ticket details page.
        # ***************************************************
        # "Auto Test Ref#" field is displayed under "Additional Details" with the value "TEST-123".
        And check "Auto Test Ref#" Ticketvalue is "<AutoTestRef>"

        # ***************************************************
        # STEP 12: Close the ticket.
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
            | AutoTestRef |
            | TEST-123    |

Feature: NormalDL-AutoTestRef-IncomingEmail-002
    1) Author: Jinyang
    2) Workflow: Normal DL ticket creation via incoming email and update
    3) Check Point: Verify "Auto Test Ref#" field is not available for tickets created via incoming email.
    4) Key Value: Auto Test Ref#

    @NormalDL @Regression @AutoTestRef @IncomingEmail
    Scenario Outline: NormalDL-AutoTestRef-IncomingEmail-002 Verify "Auto Test Ref#" field is not available for tickets created via incoming email.
        # Preconditions: XMC Loan system is configured to receive incoming emails.

        # ***************************************************
        # STEP 1: Send an email to the XMC Loan system's designated email address to generate a new Normal DL ticket.
        # ***************************************************
        # This step requires an external tool or API to send an email.
        # Assuming a step definition exists to send an email:
        Given Send email with subject "Incoming Email Ticket" and body "This is a test email to generate a ticket." from "EXTERNAL@EMAIL.COM" to "XMCLOAN@CITI.COM"

        # ***************************************************
        # STEP 2: Open the newly created ticket.
        # ***************************************************
        # Assuming a step definition exists to find the ticket by subject:
        And Get Ticket ID by Subject "Incoming Email Ticket" and save into @ticketId
        When Open ticket by ID "@ticketId.Value"
        Then Wait 5 seconds

        # ***************************************************
        # STEP 3: Click the "Update Ticket" action button.
        # ***************************************************
        Then WebAgent change to next tab
        Then WebAgent is on workflowPage
        Then WebAgent click on updateTicketAction

        # ***************************************************
        # STEP 4: Verify the presence of the "Auto Test Ref#" field in the "Update Ticket" form.
        # ***************************************************
        # "Auto Test Ref#" field is NOT displayed.
        # This step requires custom code to verify the absence of the "Auto Test Ref#" field.
        # Assuming a step definition exists to check if an element is not present:
        Then WebAgent not see autoTestRefText

        # ***************************************************
        # STEP 5: Close the ticket.
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
            |  |
```