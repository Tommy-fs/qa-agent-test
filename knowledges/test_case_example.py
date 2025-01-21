# TEST_CASE_EXAMPLE = """
# Priority: Critical
# Name: TicketingLogic-001
# Summary: Send new email with same body and subject as existing ticket should create new ticket
# Steps：
# |No.| Test Step | Test Data | Expected Result |
# | 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
# | 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
# | 3 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL002 in Test APP |
# | 4 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is not updated |
# | 5 | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject1 and Body1 |
# """

TEST_CASE_EXAMPLE = """
Priority: Critical
Name: TicketingLogic-001
Summary: Function - update(change request type) Ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
1. Operation Manager login XMC Loan Web.                                     | A: *GT CN  DevTest       | Processing Team: *GT CN DevTest
2. Create a Ticket for DL A and select OTHER as Request Type by New Message. | Request Type value: 3PDL | Status: Unassigned
3. Opetn Ticket A.                                                           |                          | Sub Status: New
4. Check Processing Team, Statusl Sub Status, Request Type.                  |                          | Request Type: OTHER
5. Click Update Ticket Action.                                               |                          | Request Type: 3P
6. Select Request Type value from Request Type dropdown list.                |                          |
7. Click Update Ticket button.                                               |                          |
8. Check Request Type                                                        |                          |
"""