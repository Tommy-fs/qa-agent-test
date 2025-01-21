from pymilvus import MilvusClient

from core.config import Config
from core.test_case_manager import TestCasesManager
from qa_agent import QAAgent


def test(log_update=None):
    print("test-begin")

    QAAgent().run("test-qa", """
    Problem Statement: Bilateral and CAD servicing operations want to be able to use our system - GENAIXXX to have a funding dashboard that 
outlines all relevant information that leadership needs tracked and monitored.
    Current Process: our system - GENAIXXX ticket workflow has all the fields relevant to what would be on a "funding dashboard" but does not have 
a text field available for Auto Test Ref# Because of this, we cannot move away from a manual touchpoint in SharePoint but 
would prefer to use our system - GENAIXXX instead since all updates show in individual columns within a public inbox.
    Change Requested:
Please also make this Auto Test Ref# non mandatory field
Location of the New Auto Test Re:Under Contract # or RID in all Workflow and Update Ticket Areas
    + Change should be applied to all DLS, document and normal DLs. +
• New added field for Normal DL will be shown in Additional Details section in left area of Ticket Detail page
• New field is non mandatory.
    This will allow the Bilateral department to transition their funding dashboard data fully to our system - GENAIXXX and to eliminate an additional 
touchpoint and allow for better data tracking and remediation efforts.
    """, log_update)


test()
