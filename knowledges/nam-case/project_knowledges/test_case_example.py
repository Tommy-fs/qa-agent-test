TEST_CASE_EXAMPLE = """
Priority: Critical
Name: TicketingLogic-001
Summary: Function - update(change request type) Ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
1. Operation Manager login xxx system Loan Web.                                     | A: *GT CN  DevTest       | Processing Team: *GT CN DevTest
2. Create a Ticket for DL A and select OTHER as Request Type by New Message. | Processing Team: * TEST@.QCOM, From email address: TEST123@Q.COM, To email address: YY544@.COM,SUBJECT: TEST 44,Request Type value: 3PDL | Status: Unassigned
3. Open Ticket A.                                                            |                          | Sub Status: New
4. Check Processing Team, Statusl Sub Status, Request Type.                  |                          | Request Type: OTHER
5. Click Update Ticket Action.                                               |                          | Request Type: 3P
6. Select Request Type value from Request Type dropdown list.                |                          |
7. Click Update Ticket button.                                               |                          |
8. Check Request Type                                                        |                          |
"""

TEST_CASE_GUIDE = """
1. if the requirement is relate for different workflow type(Normal workflow or Document workflow), need create different test case for every workflow type.
2. if the requirement is relate for ticket,the last step must be close ticket to make sure the case is completed
3. if the requirement is relate for ticket workflow(take action in ticket), use one case to test all require point.
4. Mandatory field must be filled in test data column when do 'new Message' action. 
5. can provide who login xmc loan web in test case, for example User who have Operations Manager login XMC Loan web
6. need close browser and reopen URL before change another role login.
7. need got and provide the test data for field in every page from requirement
8. when test filed is mandatory or not, you can create a ticket without entering a value for this field and see if the system will respond with a prompt. You can verify this within a test case without creating an additional test case
"""