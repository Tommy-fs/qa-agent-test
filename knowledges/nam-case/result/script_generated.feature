```cucumber
Feature: TicketingLogic-002 - Add Auto Test Ref# field in Update Ticket action form
    Author: Bard
    Workflow: Ticket Update
    Check Point: Verify the presence and functionality of the Auto Test Ref# field.
    Key Value: Auto Test Ref#

    @Ticket @Regression @TicketingLogic-002
    Scenario Outline: Verify Auto Test Ref# field functionality

        # ***************************************************
        # STEP 1: Operations Manager login and create a ticket
        # ***************************************************
        Given WebAgent open "<loan_web_url>" url
        And Login SSO as "<sso_username>"
        And Wait 5 seconds
        And Login as "<system_username>"
        And WebAgent click on inboxIcon
        And Wait 5 seconds
        Then WebAgent click on createButton
        And WebAgent click on newMessageItem
        And Wait 5 seconds
        Then WebAgent change to next tab
        Then WebAgent is on newMessagePage
        And Select "*GT CN DevTest" from processingTeamDropdownlist
        And Select "TEST123@Q.COM" from fromDropdownlist  # Using provided email in test data
        And WebAgent type "YY544@.COM" into toText # Using provided email in test data
        And WebAgent type "TEST 44" into subjectText # Using provided subject in test data
        And Select "3PDL" from requestTypeDropdownlist # Assuming 3PDL is a selectable option
        Then WebAgent click on sendButton
        And Wait 10 seconds
        Then WebAgent change to tab "xxx system Loan" # Assuming this is the loan application tab
        Then WebAgent is on LoanPage
        And Wait 60 seconds
        And WebAgent click on allTicketsInbox
        And Wait 20 seconds


        # ***************************************************
        # STEPS 3-9: Open, Update, and Verify Ticket
        # ***************************************************
        # Assuming we have a way to find the newly created ticket (e.g., by subject)
        #  - Add steps here to locate and open the newly created ticket -
        # Example (replace with actual implementation):
        # And Get Ticket ID by Subject "TEST 44" and save into @ticketId
        # When Open ticket by ID "@ticketId.Value"
        Then WebAgent change to next tab
        Then WebAgent is on workflowPage
        Then WebAgent click on updateTicketAction
        Then WebAgent see autoTestRefText # Step 5: Verify field presence
        Then WebAgent click on updateTicketButton # Step 6: Update without value
        # Step 7: Check Additional Details (requires new step definition)
        #  - Add a step definition to check the Additional Details section -
        # Example:  And "Auto Test Ref#" field is displayed in "Additional Details" section
        Then WebAgent type "<auto_test_ref>" into autoTestRefText # Step 8: Update with value
        Then WebAgent click on updateTicketButton
        # Reopen the ticket (requires implementation - similar to opening initially)
        # Then WebAgent read text from autoTestRefText into @autoTestRefValue # Step 9: Check retained value
        # And @autoTestRefValue.Value should be "TEST123"


        # ***************************************************
        # STEP 10: Close the Ticket
        # ***************************************************
        Then WebAgent click on closeParentAction
        Then Wait 1 seconds
        # Assuming 'c1ase5 ubAct1am' is a typo and should be something like 'closeSubAction'
        # Then WebAgent click on closeSubAction # Replace with correct element
        Then Wait 5 seconds
        Then check "Status" TicketValue is "Closed"
        Then check "Sub Status" TicketValue is "Closed"
        Then WebAgent click on expandAuditTrail
        And Wait 1 seconds
        Then Close Browser

    Examples:
        | loan_web_url | sso_username | system_username | auto_test_ref |
        |  YOUR_LOAN_WEB_URL  | YOUR_SSO_USERNAME | YOUR_SYSTEM_USERNAME | TEST123 |

