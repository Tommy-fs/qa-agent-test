TEST_CASE_EXAMPLE = """
Priority: Critical
Name: TicketingLogic-001
Summary: Function - update(change request type) Ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
1. Operation Manager login xxx system Loan Web.                                     | A: *GT CN  DevTest       | Processing Team: *GT CN DevTest
2. Create a Ticket for DL A and select OTHER as Request Type by New Message. | Processing Team: *Test processing DL, From email address: TESTFROM1@CITI.COM, To email address: TESTTO1@CITI.COM,SUBJECT: update(change request type) Ticket, Request Type value: 3PDL | Status: Unassigned
3. Open Ticket A.                                                            |                          | Sub Status: New
4. Check Processing Team, Statusl Sub Status, Request Type.                  |                          | Request Type: OTHER
5. Click Update Ticket Action.                                               |                          | Request Type: 3P
6. Select Request Type value from Request Type dropdown list.                |                          |
7. Click Update Ticket button.                                               |                          |
8. Check Request Type                                                        |                          |
"""

TEST_CASE_GUIDE = """
1. If the requirement is relate for different workflow type(Normal workflow or Document workflow), need create different test case for every workflow type.
2. If the requirement is relate for ticket,the last step must be close ticket to make sure the case is completed.
3. If the requirement is relate for ticket workflow(take action in ticket), use one case to test all require point.
4. If the page include new tested field(from requirement) or Mandatory field, must prepare the test data for these fields and fill them before submit or Save.
5. Need according the requirement provide the role in test case
6. Need close browser and reopen URL before change another role login.
"""