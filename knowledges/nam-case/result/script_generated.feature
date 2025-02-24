```gherkin
Feature: Ticket Management
    1) Author: Jinyang
    2) Workflow: Ticket Creation and Update
    3) Check Point: Validate Ticket Details
    4) Key Value: Ticket ID

    @Ticket @Regression @Group2
    Scenario Outline: C162742-4286 Update ticket
        # ***************************************************
        # STEP 1: Operation Manager - Create Ticket
        # ***************************************************
        Given WebAgent open "http://example.com/systemNAMLoginPage" url
        # Login using SSO as a specific role
        And Login SSO as "SopsManagel"
        # Wait for the system to process the login
        And Wait 5 seconds
        # Login as a system user
        And Login as "SopsManage1"
        # Navigate to the inbox
        And WebAgent click on inboxIcon
        # Wait for the inbox to load
        And Wait 5 seconds
        # Click on the create button to initiate a new ticket
        Then WebAgent click on createButton
        # Click on the new message item to create a new ticket
        And WebAgent click on newMessageItem
        # Wait for the new message page to load
        And Wait 5 seconds
        # Switch to the new message tab
        Then WebAgent change to next tab
        # Verify that the new message page is displayed
        Then WebAgent is on newMessagePage
        # Select the processing team from the dropdown
        And Select "*GT CN xxx system Loan Dev Test" from processingTeamDropdownlist
        # Select the sender's address from the dropdown
        And Select "*GT CN xxx system Loan Dev Test" from fromDropdownlist
        # Input the recipient's email address
        And WebAgent type "Jia,Bing Mango [OT-TECH]" into toText
        # Wait for the system to process the input
        And Wait 2 seconds
        # Click on the search value item to find the recipient
        And WebAgent click on searchValueItem
        # Click on the message text to confirm the selection
        And WebAgent click on messageText
        # Input CC email address
        And WebAgent type "Guo,Qihua Jevons [OT-TECH]" into ccText
        # Wait for the system to process the input
        And Wait 2 seconds
        # Click on the search value item to find the CC recipient
        And WebAgent click on searchValueItem
        # Click on the message text to confirm the selection
        And WebAgent click on messageText
        # Input BCC email address
        And WebAgent type "Guo,Qihua Jevons [OT-TECH]" into bccText
        # Wait for the system to process the input
        And Wait 2 seconds
        # Click on the search value item to find the BCC recipient
        And WebAgent click on searchValueItem
        # Click on the message text to confirm the selection
        Then Prepare Ticket Subject begin with "[xxx system Test]UpdateTicket-" and Save into @ticketsubject
        # Input the ticket subject
        And WebAgent type "@ticketsubject.Value" into subjectText
        # Wait for the system to process the input
        And Wait 5 seconds
        # Select the request type from the dropdown
        And WebAgent type "OTHER" into requestTypeDropdownlist
        # Wait for the system to process the input
        And Wait 2 seconds
        # Click on the next action date field
        And WebAgent click on nextActionDate
        # Wait for the system to process the input
        And Wait 2 seconds
        # Select today's date for the next action
        Then WebAgent click on nextActionDateToday
        # Select currency from the dropdown
        And WebAgent type "HKD" into currencyDropdownlist
        # Wait for the system to process the input
        And Wait 2 seconds
        # Click on the search value item to find the currency
        And WebAgent click on searchValueItem
        # Click on the new message text to confirm the selection
        And WebAgent click on newMessageText
        # Select facility from the dropdown
        And WebAgent type "Facility dev test" into facilityDropdownlist
        # Wait for the system to process the input
        And Wait 2 seconds
        # Click on the search value item to find the facility
        And WebAgent click on searchValueItem
        # Click on the effective date field
        And WebAgent click on effectiveDate
        # Wait for the system to process the input
        And Wait 2 seconds
        # Select today's date for the effective date
        Then WebAgent click on effectiveDateToday
        # Input the contract number or RID
        And WebAgent type "001C001171880002" into contractNoOrRidText
        # Input the action required
        And WebAgent type "Approval Approved" into actionRequiredText
        # Input the message content
        And WebAgent type "Mail Content, send from Web by script" into messageText
        # Click on the send button to submit the ticket
        Then WebAgent click on sendButton
        # Wait for the ticket to be processed
        And Wait 10 seconds
        # Switch to the Loan tab
        Then WebAgent change to tab "xxx system Loan"
        # Verify that the Loan page is displayed
        Then WebAgent is on LoanPage
        # Wait for the Loan page to load
        And Wait 60 seconds
        # Click on all tickets inbox to view tickets
        And WebAgent click on allTicketsInbox
        # Wait for the inbox to load
        And Wait 20 seconds
        # Click on clear user preference button
        And WebAgent click on clearUserPreferenceButton
        # Wait for the system to process the action
        And Wait 10 seconds
        # Get the ticket ID by subject and save it
        And Get Ticket ID by Subject "@ticketsubject.Value" and save into @ticketId
        # Open the ticket using the ticket ID
        When Open ticket by ID "@ticketId.Value"
        # Wait for the ticket to load
        Then Wait 5 seconds
        # ***************************************************
        # STEP 2: Operation Manager - Check Ticket Details
        # ***************************************************
        # Switch to the workflow page
        Then WebAgent change to next tab
        # Verify the ticket details
        Then WebAgent is on workflowPage
        And check "Currency" Ticket value is "HKD"
        And check "Facility" Ticket value is "Facility dev test"
        And check "Contract# or RID" Ticket value is "001C001171880002"
        And check "Action Required" Ticket value is "Approval Approved"
        # ***************************************************
        # STEP 3: Operation Manager - Update Ticket in Ticket Detail
        # ***************************************************
        # Click on the update ticket action
        Then WebAgent click on updateTicketAction
        # Input the request type
        And WebAgent type "Payoff" into requestTypeDropdownlist
        # Select the request type from the dropdown
        And Select "Payoff" from requestTypeDropdownlist
        # Select tags from the dropdown
        And Select "1.Regression Tags" from tagspropdownlist
        # Select today's funding option
        And select "YES" from todaysFundingDropdownlist
        # Select comments from the dropdown
        And select "Awaiting for Documents" from commentspropdownlist
        # Select currently pending with option
        And Select "Pending with AO" from currentlyPendingwithDropdownlist
        # Clear the input box for contract number or RID
        Then Clear Input Box "contractNoOrRidText"
        # Input the new contract number
        And WebAgent type "001C001171880001" into contractNoOrRidText
        # Input the AMC ID
        And WebAgent type "C162742" into amcIDText
        # Click on the effective date field
        And WebAgent click on effectiveDate
        # Select the year for the effective date
        And WebAgent click on chooseYearButton
        # Select the specific year
        And WebAgent click on selectoneYearButton
        # Select the month for the effective date
        And WebAgent click on chooseMonthButton
        # Select the specific month
        And WebAgent click on selectoneMonthButton
        # Select the 15th day of the month
        And WebAgent click on select15thDayButton
        # Click on the next action date field
        And WebAgent click on nextActionDate
        # Select the year for the next action date
        And WebAgent click on chooseYearButton
        # Select the specific year
        And WebAgent click on selectoneYearButton
        # Select the month for the next action date
        And WebAgent click on chooseMonthButton
        # Select the specific month
        And WebAgent click on selectoneMonthButton
        # Select the 15th day of the month
        And WebAgent click on select15thDayButton
        # Select currency from the dropdown
        And Select "DKK" from currencyDropdownlist
        # Clear the input box for action required
        Then Clear Input Box "actionRequiredText"
        # Input the new action required
        And WebAgent type "Approval Rejected" into actionRequiredText
        # Select facility from the dropdown
        And select "CVR REFINING ABTE RC" from facilitypropdownlist
        # Input the principal amount
        And WebAgent type "1000000" into principalAmountText
        # Input the fee amount
        And WebAgent type "10000" into feeAmountText
        # Input the Fed Ref number
        And WebAgent type "003C001591880001" into fedRefText
        # Click on the update ticket button to submit the changes
        Then WebAgent click on updateTicketButton
        # Wait for the update to be processed
        And Wait 4 seconds
        # ***************************************************
        # STEP 4: Operation Manager - Check Updated Ticket Details
        # ***************************************************
        # Verify the updated ticket details
        And check "Request Type" Ticket value is "Payoff"
        And check "Tags" Ticket value is "1.Regression Tags"
        And check "Todays Funding" Ticket value is "YES"
        And check "Comments" Ticket value is "Awaiting for Documents"
        And check "Currently Pending With" Ticket value is "Pending with AO"
        And check "Contract or RID" Ticket value is "001C001171880001"
        And check "AMC ID" Ticket value is "C162742"
        And check "Effective Date" Ticket value is "2024-12-15"
        And check "Next Action Date" Ticket value is "2024-12-15"
        And check "Currency" Ticket value is "DKK"
        And check "Action Required" Ticket value is "Approval Rejected"
        And check "Facility" Ticket value is "CVR REFINING ABTE RC"
        And check "Principal Amount" Ticket value is "1000000"
        And check "Fee Amount" Ticket value is "10000"
        And check "Fed Ref #" Ticket value is "003C001591880001"
        # Wait for the system to process the checks
        Then Wait 5 seconds
        # ***************************************************
        # STEP 5: Operation Manager - Close Ticket
        # ***************************************************
        # Click on the close parent action
        Then WebAgent click on closeParentAction
        # Wait for the system to process the action
        Then Wait 1 seconds
        # Click on the close sub action
        Then WebAgent click on closeSubAction
        # Wait for the system to process the action
        Then Wait 5 seconds
        # Verify that the ticket status is closed
        Then check "Status" Ticket value is "Closed"
        # Verify that the sub status is closed
        Then check "Sub Status" Ticket value is "Closed"
        # Expand the audit trail for review
        Then WebAgent click on expandAuditTrail
        # Wait for the audit trail to load
        And Wait 1 seconds
        # Close the browser after the operations
        Then Close Browser
        Examples:
            |  |
``` 

This Cucumber script is structured according to the provided guidelines and template, ensuring clarity and adherence to syntax standards. Each step is accompanied by comments explaining the purpose of the action, and the script is organized into logical sections corresponding to the test case steps.