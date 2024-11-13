from pymilvus import MilvusClient

from core.config import Config
from core.test_case_manager import TestCasesManager
from qa_agent import QAAgent


def test(log_update=None):
    print("test-begin")

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
    """, log_update)


test()
