from pymilvus import MilvusClient

from core.config import Config
from core.test_case_manager import TestCasesManager
from qa_agent import QAAgent


def test(log_update=None):
    print("test-begin")
    client = MilvusClient(Config.MILVUS_URL)
    collection_name = "test_cases_library"
    client.drop_collection(collection_name=collection_name)

    if log_update:
        log_update(step="Preparation: Add test case example in vector db")

    libray = TestCasesManager()

    test_case_text_1 = """
    Priority: Critical
    Name: TicketingLogic-001
    Summary: Send new email with same body and subject as existing ticket should create new ticket
    Steps：
    | No. | Test Step                                      | Test Data                  | Expected Result                                      |
    |-----|------------------------------------------------|----------------------------|------------------------------------------------------|
    | 1   | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
    | 2   | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
    | 3   | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL002 in Test APP |
    | 4   | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is not updated |
    | 5   | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject1 and Body1 |
        """
    libray.store_test_case(test_case_text_1)

    test_case_text_2 = """
    Priority: Critical
    Name: TicketingLogic-002
    Summary: Reply email with changed subject of existing ticket should update ticket
    Steps：
    | No. | Test Step                                      | Test Data                  | Expected Result                                      |
    |-----|------------------------------------------------|----------------------------|------------------------------------------------------|
    | 1   | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
    | 2   | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
    | 3   | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Update  ticket XL001 in Test APP |
    | 4   | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is updated from Subject1 to Subject2 |
    
        """
    libray.store_test_case(test_case_text_2)
    query_result_before = libray.get_all_test_cases()
    if log_update:
        log_update(result=query_result_before)

    QAAgent().run("test-qa", """
    Summary: Ticketing Logic - When replying to an email, adding a processing team will generate a new ticket
    Description: 
        Reply email 1 and Add a new recipient
        The system will generate a new ticket
    """, log_update)

    query_result = libray.get_all_test_cases()

    print("------------------------------- All TEST CASE -------------------------------")
    if query_result and len(query_result) > 0:
        for item in query_result:
            print("CASE:" + libray.format_case_info(item['test_case']))

test()
