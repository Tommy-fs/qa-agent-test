TEST_CASE_EXAMPLE = """
Priority: Critical
Name: TicketingLogic-001
Summary: Send new email with same body and subject as existing ticket should create new ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL002 in Test APP |
| 4 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is not updated |
| 5 | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject1 and Body1 |
"""