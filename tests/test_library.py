from processes.test_case.test_cases_library import TestCasesLibrary

libray = TestCasesLibrary()

# libray.store_test_case(test_case_example.TEST_CASE_EXAMPLE)

test_case_text_1 = """
    Priority: Critical
    Name: TicketingLogic-001
    Summary: Send new email with same body and subject as existing ticket should create new ticket
    Steps：
    |No.| Test Step | Test Data | Expected Result |
    | 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
    | 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
    """
libray.store_test_case(test_case_text_1)

test_case_text_2 = """
    Priority: High
    Name: TicketingLogic-002
    Summary: Update existing ticket with new information should reflect the change
    Steps：
    |No.| Test Step | Test Data | Expected Result |
    | 1 | Open Ticket XL001 in Test APP | XL001 | Ticket XL001 is open |
    | 2 | Update ticket information with new details | XL001, New details | Ticket XL001 is updated with new details |
    """
libray.store_test_case(test_case_text_2)

test_case_text_3 = """
    Priority: High
    Name: TicketingLogic-003
    Summary: Reply email with change Subject to create new ticket
    Steps:
    |No.| Test Step | Test Data | Expected Result |
    | 1 | Send email with Subject-001 to create new ticket XL001 | Subject-001 | New ticket XL001 is created in Test APP |
    | 2 | Reply to email XL001 with change Subject-001 to Subject-002 | Subject-002 | New ticket XL002 is created in Test APP |
    | 3 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 remains unchanged |
    | 4 | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject-002 |
    """
libray.store_test_case(test_case_text_3)

query_result = libray.get_all_test_cases()

if query_result and len(query_result) > 0:
    for entity in query_result:
        print("ALL" + str(entity))

query = "Reply email 1 with change Subject to Subject 2, will create ticket XL002 in Test APP"
search_results = libray.search_test_cases(query)

if search_results and len(search_results) > 0:
    for result in search_results:
        print("MATCH" + str(result))

print("end")
