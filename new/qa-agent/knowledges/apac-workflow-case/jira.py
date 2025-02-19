JIRA = """
Application:
xxx system Loan APAC Instruction

Scope:
HK Platform

Features:
GCM Workflow

Requirement:
Enhance and expand current HK Loans Workflow -HK GCM.


Expectation:

1. INSTRUCTION UNDER 'KL LOANS  - PROCESSING-CHECKER' STATUS, PROCESS STATUS UNDER "PROCESSING- CHECKER -QC CHECKED" OR "PROCESSING-CHEKER", Actions that KL LOANS OPS - PROCESS CHECK can take change:
    1.1. If THIRD PARTY PAYMENT=yes and COMPLETED DATE is blank, please add workFLOW action "submit to Payment",this moment disable action "complete".
    1.2. If THIRD PARTY PAYMENT=yes and COMPLETED DATE isn't blank, please add workFLOW action "complete", also enable action "submit to Payment.
    1.3. If THIRD PARTY PAYMENT=No, please add enable action "complete", disable action "submit to Payment".

2. After KL LOANS OPS - PROCESSING -CHECKER "submit to Payment", set PROCESS STATUS = "PAYMENT - MAKER".
    2.1.Add new workflow point under this status,The role of 'KL LOANS OPS-PROCESSING-PAYMENT MAKER' can perform action "submit Payment Checker". set PROCESS STATUS="PAYMENT-CHECKER"
    2.2.ALSO enable The role of 'KL LOANS OPS -PROCESSING - PAYMENT MAKER' return instruction to 'KL LOANS OPS -PROCESSING -MAKER', PROCESS STATUS set to "PROCESSING- MAKER-MANUAL".

3.  After Submit to Payment checker:
    3.1.Add new workflow point under status, The role of 'KL LOANS OPS -PROCESSING - PAYMENT CHECKER' can perform action"Complete", set current STATUS = "COMPLETED" PROCESS STATUS ="COMPLETED".
    3.2.ALSO ENADlE The role of 'KL LOANS OPS - PROCESSING- PAYMENT CHECKER' RETURN INSTRUCTION TO The role of 'KL LOANS OPS -PROCESSING -MAKER' ,PROCESS STATUS SET TO "PROCESSING- MAKER- MANUAL"
    3.3.ALSO ENABLE The role of 'KL LOANS OPS - PROCESSING PAYMENT CHECKER' RETURN INSTRUCTION TO The role of 'KL LOANS OPS -PROCESSING-PAYMENT MAKER',  SET PROCESS STATUS= "PAYMENT - MAKER

Expand previous HK GCM workflow enable Payment Maker and Payment Checker perform workflow actions.

Business Benefit:
Introduce a standardized workflow for whole Loans operation process, control all steps in system and reduce risk, improve productivity.
"""
