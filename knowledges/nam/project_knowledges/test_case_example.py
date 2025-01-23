TEST_CASE_EXAMPLE = """
Priority: Critical
Name: TicketingLogic-001
Summary: Function - update(change request type) Ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
1. Operation Manager login XMC Loan Web.                                     | A: *GT CN  DevTest       | Processing Team: *GT CN DevTest
2. Create a Ticket for DL A and select OTHER as Request Type by New Message. | Request Type value: 3PDL | Status: Unassigned
3. Open Ticket A.                                                            |                          | Sub Status: New
4. Check Processing Team, Statusl Sub Status, Request Type.                  |                          | Request Type: OTHER
5. Click Update Ticket Action.                                               |                          | Request Type: 3P
6. Select Request Type value from Request Type dropdown list.                |                          |
7. Click Update Ticket button.                                               |                          |
8. Check Request Type                                                        |                          |
"""