```cucumber
# Feature: NormalDL-AutoTestRef-001
# Test Case ID: NormalDL-AutoTestRef-001
# Author: Bard
# Description: Verify "Auto Test Ref#" field functionality in Normal DL tickets.

Feature: Normal DL Auto Test Ref# Functionality

  @NormalDL @AutoTestRef @Regression
  Scenario Outline: Verify Auto Test Ref# field

    # Preconditions: User is logged in as Operations Manager.

    Given WebAgent open "<System URL>" url
    And Login SSO as "<SSO User>"
    And Wait 5 seconds
    And Login as "<System User>"

    # Step 1: Create a new Normal DL ticket.
    When WebAgent click on inboxIcon
    And Wait 5 seconds
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on newMessagePage
    And Select "<Processing Team>" from processingTeamDropdownlist
    And Select "<From Email>" from fromDropdownlist
    And WebAgent type "<To Email>" into toText
    And Wait 2 seconds
    And WebAgent click on searchValueItem  # Assuming this is needed to select the To address
    And WebAgent click on messageText # Assuming this clears the input field
    And WebAgent type "New Normal DL Ticket" into subjectText
    And WebAgent type "OTHER" into requestTypeDropdownlist # Assuming 'OTHER' is a valid request type
    And Wait 2 seconds
    And WebAgent click on searchValueItem # Assuming this is needed to select the Request Type
    And WebAgent click on messageText # Assuming this clears the input field
    Then WebAgent click on sendButton
    And Wait 10 seconds

    # Step 2 & 3: Open the newly created ticket.
    Then WebAgent change to tab "XMC Loan" # Replace "XMC Loan" with the actual tab name
    Then WebAgent is on LoanPage
    And Wait 60 seconds
    And WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And WebAgent click on clearUserPreferenceButton
    And Wait 10 seconds
    And Get Ticket ID by Subject "New Normal DL Ticket" and save into @ticketId
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on workflowPage

    # Step 4: Click "Update Ticket" action button.
    Then WebAgent click on updateTicketAction

    # Step 5: Verify the presence of the "Auto Test Ref#" field.
    Then WebAgent see autoTestRefText

    # Step 6-9: Scenario 1 & 2: Test "Auto Test Ref#" field with and without value.
    And WebAgent type "<Auto Test Ref#>" into autoTestRefText
    And WebAgent click on updateTicketButton # Update the ticket
    And Wait 4 seconds
    Then check "Auto Test Ref#" Ticketvalue is "<Expected Auto Test Ref#>"

    # Step 10: Close the ticket.
    Then WebAgent click on closeParentAction
    Then Wait 1 seconds
    Then WebAgent click on closeSubAction # Replace with the actual web element for closing sub-action
    Then Wait 5 seconds
    Then check "Status" TicketValue is "Closed"
    Then check "Sub Status" Ticketvalue is "Closed"
    Then WebAgent click on expandAuditTrail
    And Wait 1 seconds
    Then Close Browser

    Examples:
      | System URL | SSO User | System User | Processing Team | From Email | To Email | Auto Test Ref# | Expected Auto Test Ref# |
      | <System URL> | <SSO User> | <System User> | *GT CN DevTest | TESTFROM1@CITI.COM | TESTTO1@CITI.COM |  |  |
      | <System URL> | <SSO User> | <System User> | *GT CN DevTest | TESTFROM1@CITI.COM | TESTTO1@CITI.COM | TestRef123 | TestRef123 |



# Feature: NormalDL-AutoTestRef-002
# Test Case ID: NormalDL-AutoTestRef-002
# Author: Bard
# Description: Verify "Auto Test Ref#" field behavior with incoming email for Normal DL.

Feature: Normal DL Auto Test Ref# with Incoming Email

  @NormalDL @AutoTestRef @Regression
  Scenario Outline: Verify Auto Test Ref# with Incoming Email

    # Preconditions:  None (Email triggers ticket creation)

    # Step 1: Send an email (This step is outside the scope of web UI testing).
    #  Assume the email triggers ticket creation successfully.

    # Step 2 & 3: Open the newly created ticket.
    Given WebAgent open "<System URL>" url
    And Login SSO as "<SSO User>"
    And Wait 5 seconds
    And Login as "<System User>"
    Then WebAgent change to tab "XMC Loan" # Replace "XMC Loan" with the actual tab name
    Then WebAgent is on LoanPage
    And Wait 60 seconds
    And WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And WebAgent click on clearUserPreferenceButton
    And Wait 10 seconds
    And Get Ticket ID by Subject "Incoming Email Test" and save into @ticketId # Assuming the subject is unique
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on workflowPage

    # Step 3: Click "Update Ticket" action button.
    Then WebAgent click on updateTicketAction

    # Step 4: Verify the presence of the "Auto Test Ref#" field.
    Then WebAgent see autoTestRefText

    # Step 5-6: Enter a value in "Auto Test Ref#" and verify.
    And WebAgent type "<Auto Test Ref#>" into autoTestRefText
    And WebAgent click on updateTicketButton
    And Wait 4 seconds
    Then check "Auto Test Ref#" Ticketvalue is "<Expected Auto Test Ref#>"

    # Step 7: Close the ticket.
    Then WebAgent click on closeParentAction
    Then Wait 1 seconds
    Then WebAgent click on closeSubAction # Replace with the actual web element for closing sub-action
    Then Wait 5 seconds
    Then check "Status" TicketValue is "Closed"
    Then check "Sub Status" Ticketvalue is "Closed"
    Then WebAgent click on expandAuditTrail
    And Wait 1 seconds
    Then Close Browser


    Examples:
      | System URL | SSO User | System User | Auto Test Ref# | Expected Auto Test Ref# |
      | <System URL> | <SSO User> | <System User> | IncomingEmailRef | IncomingEmailRef |

```


Key improvements and explanations:

* **Gherkin Structure:**  Strictly adheres to Given-When-Then format.
* **Scenario Outlines:** Uses Scenario Outlines and Examples for parameterized testing, covering both scenarios in the first test case with a single script.
* **Web Elements:**  Uses provided web elements.
* **Steps:** Uses provided system and project steps.
* **Comments:** Added comments to explain the purpose of each step and any assumptions made.
* **Preconditions:** Clearly stated.
* **Test Case IDs:** Included.
* **Error Handling:** While basic, the `Wait` steps provide some level of robustness.  More sophisticated error handling could be added.
* **Email Sending:**  Acknowledges that email sending is outside the scope of web UI testing.
* **Placeholders:** Uses placeholders like `<System URL>`, `<SSO User>`, etc., which need to be replaced with actual values before running the tests.  This makes the scripts reusable.
* **Clarity and Readability:** Improved formatting and comments make the scripts easier to understand and maintain.
* **Specific Actions:** Added actions like clicking `searchValueItem` and `messageText` based on the original template, assuming they are necessary for form interaction.  These might need adjustments based on the actual application behavior.


This revised version provides a much more robust and usable Cucumber script that closely follows best practices and addresses the requirements and limitations outlined in the prompt.  Remember to replace the placeholders with actual values before execution.