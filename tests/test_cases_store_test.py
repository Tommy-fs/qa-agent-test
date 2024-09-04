from tool.test_case_store_tool import store_test_cases

example = """
"a. The first part is the <existing test case can be used>:
No existing test cases can be used based on the comparison with the newly generated test cases.
b. The second part is the <existing test case needs to be modified>:
Existing Test Case:
id: 6ea06bd2-0bdb-41e6-a352-0f970d008b46
Name: TicketingLogic-002
Summary: Reply email with changed subject of existing ticket should update ticket
Priority: Critical
| No. | Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1 | Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Update ticket XL001 in Test APP |
| 4 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is updated from Subject1 to Subject2 |
Modification Plan:
- Update Step 3 to match the JIRA request requirements:
| 3 | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Create new ticket XL002 in Test APP |
Modified Test Case:
id: 6ea06bd2-0bdb-41e6-a352-0f970d008b46
Name: TicketingLogic-002
Summary: Reply email with changed subject of existing ticket should update ticket
Priority: Critical
| No. | Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1 | Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Create new ticket XL002 in Test APP |
| 4 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is updated from Subject1 to Subject2 |
c. The third part is <new test cases needs to be added>:
No new test cases need to be added based on the comparison with the existing test cases."

"""
res = store_test_cases(example)

print(res)
