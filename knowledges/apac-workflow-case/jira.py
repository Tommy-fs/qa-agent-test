JIRA = """
Application:
XMC Loan APAC Instruction
Scope:
HK Platform
Features:
GCM Workflow
Reguirement:
Enhance and expand current HK Loans Workflow -HK GCM.
INSTRUCTION UNEY KL IOANS OPS-PROCESING-CHECKER SAP PROCES STATUS UNDER "PROCESING- CHECKER -0CCHECKED" "PROCESSING-CHEKERKLIOANS OPS - PROCESINGCHECKER actions change:
1. If THIRD PARTY PAYMENT=yes and COMPLTED DATE is blank, please add workow action "submit to Payment",this moment disable action "complete".
2. If THIRD PARTY PAYMENT=yes and COMPLETED DATE isn't blank, please add workfow action "complete", also enable action "submit to Payment.
3. If THIRD PARTY PAYIMENT=No, please add enable action "complete", disable action "submit to Pavment".
After KL LOANS OPS - PROCESSING -CHECKER "submit to Pavment", set PROCESS STATUS = "PAYMENT - MAKER".
.Ad new workilow Dont uner ths SS KLLOANS OPS-PROCESSING-PAYMENT MAKER can perom acion"submto PamentChecKer. St PROCES STATUS="PAYENT-CHECKER2. AISO EnabIE KL LOANS OPS -PROCESING - PAYMENT MAKER rEUM InSrUCOn tO KL LOANS OPS -PROCESSING -MAKER PROCESS STATUS SEt tO"PROCESSING- MAKER-MANUAL".
After Submit to Payment checker:
1.Add new workiow point underthis SatUS, KL LOANS OPS -PROCESING - PAYMENT CHECKER can perorm action"ComptE", t CURENT STATUS = "COMPLETED" PROCESS STATUS ="COMPLETED".
2.AO ENADlE KL LOANS OPS - PROCESING- PAYMENT CHECKER TELmIStNGOn tOKLLOANS OPS -PROCESSING -MAKER PROCESSSTATUS SE O"PROCESING- MAKER- MANUA!"3.ASO ENBDE KLLOANS OPS - PROCESING PAYMENT CHECKER TU IDStUCOn O KLLOANS OPS-PROCESING-PAYMENT MAKER ST PROCESS STATUS= "PAYMENT - MAKER
Expectation:
Expand previous HK GCM workflow enable Payment Maker and Payment Checker perform workflow actions.
Business Benefit:
Introduce a standardized worklow for whole Loans operation process, control all steps in system and reduce risk, improve productivity.
"""
