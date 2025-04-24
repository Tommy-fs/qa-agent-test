```gherkin
Feature: System Email Rule - Add New Email Address to Distribution List
  1) Author: Jinyang
  2) Workflow: Add a new email address to a distribution list and verify the system email rule is updated correctly.
  3) Check Point: Verify email rule updates, ticket creation, and rule inactivation.
  4) Key Value: Distribution List Name (*DL NAME), New Email Address (address@citi.com)

  @SystemEmailRule @High
  Scenario Outline: Add New Email Address to Distribution List and Verify System Email Rule
    # Preconditions:
    # 1. Admin user has access to XMC Loans.
    # 2. An existing distribution list (*DL NAME) is configured in XMC Loans.

    # Step 1: Admin user logs into XMC Loans.
    Given WebAgent open "$xxx systemNAMLoginPage"url
    And Login SSo as "AdminUser"
    And Wait 5 seconds
    And Login as "AdminUser"

    # Step 2: Navigate to the System Email Rule page.
    And WebAgent click on settingIcon
    And Wait 2 seconds
    And WebAgent click on maintenanceIcon
    And Wait 2 seconds
    And WebAgent click on "System Email Rule"

    # Step 3: Locate the rule associated with *DL NAME.
    # Assuming there's a way to search or filter for the DL name on the page.
    # This step might require custom steps based on the UI.
    And WebAgent type "<DL_NAME>" into "Search Distribution List"
    And Wait 2 seconds
    Then WebAgent click on "Search Button"

    # Step 4: Verify the current email addresses associated with the rule.
    # This step might require custom steps based on the UI to extract and verify the email addresses.
    Then WebAgent see "Existing Email Addresses"

    # Step 5: Add the new external email address: address@citi.com to the DL.
    And WebAgent type "address@citi.com" into "Add New Email Address Field"
    And WebAgent click on "Add Email Address Button"
    And Wait 2 seconds

    # Step 6: Return to the System Email Rule page and locate the rule for *DL NAME.
    And WebAgent type "<DL_NAME>" into "Search Distribution List"
    And Wait 2 seconds
    Then WebAgent click on "Search Button"

    # Step 7: Verify the updated email addresses associated with the rule.
    Then WebAgent see "address@citi.com"

    # Step 8: Send a test email to the *DL NAME from an external email account.
    # This step requires external email sending capabilities and might not be fully automated.
    # Assuming a step to trigger an email sending process.
    And WebAgent type "<Test Email Subject>" into subjectText
    And WebAgent type "<Test Email Body>" into "emailBody"
    And WebAgent click on "Send Test Email Button"
    And Wait 60 seconds

    # Step 9: Send a test email to the *DL NAME from the newly added email address (address@citi.com).
    And WebAgent type "<Test Email Subject>" into subjectText
    And WebAgent type "<Test Email Body>" into "emailBody"
    And WebAgent click on "Send Test Email Button"
    And Wait 60 seconds

    # Step 10: Inactivate the email rule for *DL NAME.
    And WebAgent click on "Inactivate Rule Button"
    And Wait 2 seconds
    Then WebAgent see "Rule Status: Inactive"

    # Step 11: Send a test email to the *DL NAME from an external email account.
    And WebAgent type "<Test Email Subject>" into subjectText
    And WebAgent type "<Test Email Body>" into "emailBody"
    And WebAgent click on "Send Test Email Button"
    And Wait 60 seconds

    # Step 12: Activate the email rule for *DL NAME.
    And WebAgent click on "Activate Rule Button"
    And Wait 2 seconds
    Then WebAgent see "Rule Status: Active"

    Examples:
      | DL_NAME | Test Email Subject | Test Email Body |
      | DL Name | Test Subject | Test Body |

Feature: Ticket Creation and Field Population - New Email Address
  1) Author: Jinyang
  2) Workflow: Verify ticket creation and field population via email from the newly added external email address.
  3) Check Point: Verify ticket creation and field population.
  4) Key Value: Distribution List Name (*DL NAME), New Email Address (address@citi.com)

  @TicketCreation @Medium
  Scenario Outline: Ticket Creation and Field Population from New Email Address
    # Preconditions:
    # 1. System Email Rule is configured for *DL NAME.
    # 2. Email address address@citi.com is added to the DL.

    # Step 1: Send an email to the *DL NAME from the newly added email address (address@citi.com) with data for all mandatory fields (Processing Team, Subject, Request Type).
    # This step requires external email sending capabilities and might not be fully automated.
    # Assuming a step to trigger an email sending process.
    Given WebAgent open "$xxx systemNAMLoginPage"url
    And Login SSo as "address@citi.com"
    And Wait 5 seconds
    And Login as "address@citi.com"
    And WebAgent click on inboxIcon
    And Wait 5 seconds
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on newMessagePage
    And Select "<DL_NAME>"from processingTeamDropdownlist
    And WebAgent type "<Test Ticket>"into subjectText
    And Select "<Request Type>"from requestTypeDropdownlist
    And WebAgent click on sendButton
    And Wait 60 seconds

    # Step 2: Open the newly created ticket.
    Then WebAgent change to tab "xxx system Loan"
    Then WebAgent is on LoanPage
    And Wait 60 seconds
    And WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And WebAgent click on clearUserPreferenceButton
    And Wait 10 seconds
    And Get Ticket ID by Subject "<Test Ticket>"and save into @ticketId
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds

    # Step 3: Verify the ticket details are populated correctly based on the email content.
    Then WebAgent change to next tab
    Then WebAgent is on workflowPage
    And check "Processing Team"Ticketvalue is "<DL_NAME>"
    And check "Subject"Ticketvalue is "<Test Ticket>"
    And check "Request Type"Ticketvalue is "<Request Type>"

    # Step 4: Close the ticket.
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
      | DL_NAME | Test Ticket | Request Type |
      | DL Name | Test Ticket Subject | Valid Request Type |

Feature: Export Functionality - After Adding New Email Address
  1) Author: Jinyang
  2) Workflow: Verify the export functionality of system email rules after adding a new email address.
  3) Check Point: Verify the exported data contains the updated rule for *DL NAME, including the newly added email address (address@citi.com).
  4) Key Value: Distribution List Name (*DL NAME), New Email Address (address@citi.com)

  @ExportFunctionality @Low
  Scenario Outline: Verify Export Functionality After Adding New Email Address
    # Preconditions:
    # 1. Admin user has access to XMC Loans.
    # 2. System Email Rule is configured for *DL NAME with address@citi.com added.

    # Step 1: Admin user logs into XMC Loans.
    Given WebAgent open "$xxx systemNAMLoginPage"url
    And Login SSo as "AdminUser"
    And Wait 5 seconds
    And Login as "AdminUser"

    # Step 2: Navigate to the System Email Rule page.
    And WebAgent click on settingIcon
    And Wait 2 seconds
    And WebAgent click on maintenanceIcon
    And Wait 2 seconds
    And WebAgent click on "System Email Rule"

    # Step 3: Click the "Export" button.
    And WebAgent click on "Export Button"
    And Wait 10 seconds

    # Step 4: Verify the exported data contains the updated rule for *DL NAME, including the newly added email address (address@citi.com).
    # This step requires access to the exported file and parsing its content.
    # Assuming a step to verify the content of the exported file.
    Then WebAgent see "Exported File Content"
    And check "Exported File Content"Ticketvalue is "<DL_NAME>"
    And check "Exported File Content"Ticketvalue is "address@citi.com"
    Then Close Browser

    Examples:
      | DL_NAME |
      | DL Name |
```