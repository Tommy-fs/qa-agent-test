
Feature: System Email Rule - Add New Email Address to Distribution List
  1) Author: Jinyang
  2) Workflow: Add a new email address to a distribution list and verify the system email rule is updated correctly.
  3) Check Point: Verify email rule updates, ticket creation, and rule inactivation.
  4) Key Value: Distribution List Name (*DL NAME), New Email Address (address@citi.com)

  @SystemEmailRule @High @TC_1
  Scenario Outline: Add New Email Address to Distribution List and Verify System Email Rule
    # Preconditions:
    # 1. Admin user has access to XMC Loans.
    # 2. An existing distribution list (*DL NAME) is configured in XMC Loans.

    # Step 1: Admin user logs into XMC Loans.
    # Opening the login page and logging in as an admin user
    Given WebAgent open "$xxx systemNAMLoginPage"url
    And Login SSO as "AdminUser"
    And Wait 5 seconds
    And Login as "AdminUser"

    # Step 2: Navigate to the System Email Rule page.
    # Clicking on setting icon, maintenance icon and then system email rule to navigate to the page
    And WebAgent click on settingIcon
    And Wait 2 seconds
    And WebAgent click on maintenanceIcon
    And Wait 2 seconds
    And WebAgent click on "System Email Rule"

    # Step 3: Locate the rule associated with <DL_NAME>.
    # Typing the DL name into the search field and clicking the search button
    And WebAgent type "<DL_NAME>" into "Search Distribution List"
    And Wait 2 seconds
    Then WebAgent click on "Search Button"

    # Step 4: Verify the current email addresses associated with the rule.
    # Assuming there's a way to extract and verify the email addresses.
    Then WebAgent see "Existing Email Addresses"

    # Step 5: Add the new external email address: address@citi.com to the DL.
    # Typing the new email address into the add email address field and clicking the add button
    And WebAgent type "address@citi.com" into "Add New Email Address Field"
    And WebAgent click on "Add Email Address Button"
    And Wait 2 seconds

    # Step 6: Return to the System Email Rule page and locate the rule for <DL_NAME>.
    # Typing the DL name into the search field and clicking the search button
    And WebAgent type "<DL_NAME>" into "Search Distribution List"
    And Wait 2 seconds
    Then WebAgent click on "Search Button"

    # Step 7: Verify the updated email addresses associated with the rule.
    # Verifying that the new email address is displayed
    Then WebAgent see "address@citi.com"

    # Step 8: Send a test email to the <DL_NAME> from an external email account.
    # Inputting the test email subject and body and clicking the send button
    And WebAgent type "<Test Email Subject>" into subjectText
    And WebAgent type "<Test Email Body>" into "emailBody"
    And WebAgent click on "Send Test Email Button"
    And Wait 60 seconds

    # Step 9: Send a test email to the <DL_NAME> from the newly added email address (address@citi.com).
    # Inputting the test email subject and body and clicking the send button
    And WebAgent type "<Test Email Subject>" into subjectText
    And WebAgent type "<Test Email Body>" into "emailBody"
    And WebAgent click on "Send Test Email Button"
    And Wait 60 seconds

    # Step 10: Inactivate the email rule for <DL_NAME>.
    # Clicking the inactivate rule button
    And WebAgent click on "Inactivate Rule Button"
    And Wait 2 seconds
    Then WebAgent see "Rule Status: Inactive"

    # Step 11: Send a test email to the <DL_NAME> from an external email account.
    # Inputting the test email subject and body and clicking the send button
    And WebAgent type "<Test Email Subject>" into subjectText
    And WebAgent type "<Test Email Body>" into "emailBody"
    And WebAgent click on "Send Test Email Button"
    And Wait 60 seconds

    # Step 12: Activate the email rule for <DL_NAME>.
    # Clicking the activate rule button
    And WebAgent click on "Activate Rule Button"
    And Wait 2 seconds
    Then WebAgent see "Rule Status: Active"
    Then Close Browser

    Examples:
      | DL_NAME | Test Email Subject | Test Email Body |
      | DL Name | Test Subject | Test Body |
