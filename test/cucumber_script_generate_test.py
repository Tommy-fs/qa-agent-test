from tool.cucumber_script_generate_tool import CucumberScriptGenerator

cucumberScriptGenerator = CucumberScriptGenerator()

case = """
Priority: High
Name: System_Email_Rule-001
Summary: Verify adding an external email address to a Distribution List (DL) activates the email rule.
Steps:
| No. | Test Step | Test Data | Expected Result |
|---|---|---|---|
| 1. | Admin user logs into XMC Loans. |  | Successful login |
| 2. | Navigate to the System Email Rule page. |  | System Email Rule page displayed |
| 3. | Locate the rule for *DL NAME. |  | Rule found |
| 4. | Verify the current status of the email rule. |  | Status is either Active or Inactive |
| 5. | If the status is Inactive, click "Active Email Rule(s)" button for *DL NAME. |  | Status changes to Active |
| 6. | Send an email from address@citi.com to *DL NAME. | Email Subject: Test Email | A new ticket is created in XMC Loans associated with *DL NAME. |
| 7. | Verify the ticket details. |  | Ticket details match the information in the email from address@citi.com |
| 8. | Close the ticket. | | Ticket status changed to Closed |


---

Priority: High
Name: System_Email_Rule-002
Summary: Verify adding an external email address to a Distribution List (DL) allows updating existing tickets.
Steps:
| No. | Test Step | Test Data | Expected Result |
|---|---|---|---|
| 1. | Admin user logs into XMC Loans. |  | Successful login |
| 2. | Create a new ticket in XMC Loans for *DL NAME. | Use "New Message" feature. Processing Team: *DL NAME, From: testuser@citi.com, To: *DL NAME, Subject: Existing Ticket Test, Request Type: OTHER | Ticket created successfully |
| 3. | Navigate to the System Email Rule page. |  | System Email Rule page displayed |
| 4. | Locate the rule for *DL NAME. |  | Rule found |
| 5. | Verify the current status of the email rule. |  | Status is Active |
| 6. | Send an email from address@citi.com to *DL NAME replying to the previously created ticket's email thread. | Email Subject: Re: Existing Ticket Test, Email Body: This is an update | The existing ticket in XMC Loans is updated. |
| 7. | Open the existing ticket. |  | Ticket details page displayed |
| 8. | Verify the ticket updates. |  | Ticket updates reflect the information in the email from address@citi.com (e.g., comments, attachments) |
| 9. | Close the ticket. | | Ticket status changed to Closed |


---

Priority: Medium
Name: System_Email_Rule-003
Summary: Verify inactivating the email rule for a DL prevents new ticket creation and existing ticket updates from external email addresses.
Steps:
| No. | Test Step | Test Data | Expected Result |
|---|---|---|---|
| 1. | Admin user logs into XMC Loans. |  | Successful login |
| 2. | Navigate to the System Email Rule page. |  | System Email Rule page displayed |
| 3. | Locate the rule for *DL NAME. |  | Rule found |
| 4. | Click "Inactive Email Rule(s)" button for *DL NAME. |  | Status changes to Inactive |
| 5. | Send an email from address@citi.com to *DL NAME. | Email Subject: New Ticket Attempt | No new ticket is created in XMC Loans. |
| 6. | Create a new ticket in XMC Loans for *DL NAME. | Use "New Message" feature. Processing Team: *DL NAME, From: testuser@citi.com, To: *DL NAME, Subject: Update Attempt, Request Type: OTHER | Ticket created successfully |
| 7. | Send an email from address@citi.com to *DL NAME replying to the previously created ticket's email thread. | Email Subject: Re: Update Attempt, Email Body: This is an update attempt | The existing ticket in XMC Loans is NOT updated. |
| 8. | Open the existing ticket. |  | Ticket details page displayed |
| 9. | Verify the ticket has not been updated. |  | No new updates are present in the ticket. |
| 10. | Close the ticket. | | Ticket status changed to Closed |

"""
cucumberScriptGenerator.cucumber_script_generate(case)
