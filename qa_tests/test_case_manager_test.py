from pymilvus import MilvusClient

from core.config import Config
from core.test_case_manager import TestCasesManager
from tool.test_case_similar_search_tool import test_cases_similar_search

# client = MilvusClient(Config.MILVUS_URL)
# collection_name = "test_cases_library"
#
#
# client.drop_collection(collection_name=collection_name)


libray = TestCasesManager()

allCasesBefore = libray.get_all_test_cases()
libray.modify_test_case('0f0b38a4-2ca7-4a73-96f9-834668e07bc2', """
Priority: te
Name: tes-001
Summary: test
Steps：
|No.| Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
""")
allCases = libray.get_all_test_cases()

for item in allCases:
    print(f"CASE:" + libray.format_case_info(item['test_case']))
# libray.store_test_case(test_case_example.TEST_CASE_EXAMPLE)

test_case_text_1 = """
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
libray.store_test_case(test_case_text_1)

test_case_text_2 = """
Priority: Critical
Name: TicketingLogic-002
Summary: Reply email with changed subject of existing ticket should update ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Reply this Email to DL1 with Subject2 | DL1, Subject2 | Update  ticket XL001 in Test APP |
| 5 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is updated from Subject1 to Subject2 |
 """
libray.store_test_case(test_case_text_2)

test_case_text_3 = """
    Priority: High
    Name: TicketingLogic-003
    Summary: Reply email, will update ticket
    Steps:
    |No.| Test Step | Test Data | Expected Result |
    | 1 | Send email with Subject-001 to create new ticket XL001 | Subject-001 | New ticket XL001 is created in Test APP |
    | 2 | Reply to email XL001 with Subject-001 | Subject-001 | ticket XL001 is updated in Test APP |
    """
libray.store_test_case(test_case_text_3)

query_result = libray.get_all_test_cases()

for item in query_result:
    print(f"CASE:" + libray.format_case_info(item['test_case']))

# res = test_cases_similar_search("","")
#
# print(res)
# query = "Reply email 1 with change Subject to Subject 2, will create new ticket in Test APP"
# search_results = libray.search_test_cases(query)
#
# if search_results and len(search_results) > 0:
#     for result in search_results:
#         print("MATCH" + str(result))
#
# query = "Psend email 1, will create ticket  in Test APP"
# search_results = libray.search_test_cases(query)
# if search_results and len(search_results) > 0:
#     for result in search_results:
#         print("MATCH" + str(result))
#
# query = "Reply email, update ticket"
# search_results = libray.search_test_cases(query)
#
# if search_results and len(search_results) > 0:
#     for result in search_results:
#         print("MATCH" + str(result))
#
# print("end")
