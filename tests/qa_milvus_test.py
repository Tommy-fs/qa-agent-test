from pymilvus import MilvusClient

from core.config import Config
from qa_agent import QAAgent

from processes.test_case.test_cases_library import TestCasesLibrary


client = MilvusClient(Config.MILVUS_URL)
collection_name = "test_cases_library"
client.drop_collection(collection_name=collection_name)

libray = TestCasesLibrary()

test_case_text_1 = """
Priority: Critical
Name: TicketingLogic-001
Summary: Send new email with same body and subject as existing ticket should create new ticket
Steps：
|No.| Test Step | Test Data | Expected Result |
| 1 | Send New Email to DL1 with Subject1 and Body1 | DL1, Subject1, Body1| Create new ticket XL001 in Test APP |
| 2 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is created with Subject1 and Body1 |
| 3 | Send New Email to DL1 with Subject2 and Body2 | DL1, Subject2, Body2| Create new ticket XL002 in Test APP |
| 4 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 is not updated |
| 5 | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject1 and Body1 |

    """
libray.store_test_case(test_case_text_1)

test_case_text_2 = """
Priority: Critical
Name: TicketingLogic-002
Summary: Reply email with changed subject of existing ticket should update old ticket
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
    Summary: Reply email with change Subject to create new ticket
    Steps:
    |No.| Test Step | Test Data | Expected Result |
    | 1 | Send email with Subject-001 to create new ticket XL001 | Subject-001 | New ticket XL001 is created in Test APP |
    | 2 | Reply to email XL001 with change Subject-001 to Subject-002 | Subject-002 | New ticket XL002 is created in Test APP |
    | 3 | Open Test APP WebUI to check ticket XL001 | XL001 | Ticket XL001 remains unchanged |
    | 4 | Open Test APP WebUI to check ticket XL002 | XL002 | Ticket XL002 is created with Subject-002 |
    """
libray.store_test_case(test_case_text_3)

QAAgent().run("test-qa", """
Summary: Ticketing Logic - reply email to create new Ticket 1
Description: 
    Reply email 1 with change Subject to Subject 2, will create ticket XL002 in Test APP
    Steps to Reproduce: 
        1. Send email with Subject1 to create new ticket XL001
        2. Reply email with change Subject1 to Subject 2
    Expected Result: 
        1. Ticket XL001 is not update
        2. Ticket XL002 is created with Subject2
""")
