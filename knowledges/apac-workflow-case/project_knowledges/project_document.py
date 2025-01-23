PROJECT_DOCUMENT = """
HK Instruction Workflow
1. Workflow type
“HK GCM" Workflow is one workflow of HK KL Loans Workflow which created by KL LOANSOPS-PROCESSING -MAKER.

2.HK GCM Instruction Creation
    1.Create Instruction by“NewInstruction” button
    There is a role could manually create new instruction, who are KL LOANSOPS-PROCESSING -MAKER role, can created instruction with button “NewInstruction-STARS" to run KL Loans workflow-HK GCM.
    2.Create Instruction byopen“Report ltem”
    KL LOANS OPS -PROCESSING -MAKER and KL LOANS OPS-PROCESSING-CHECKER have access to Upload Maturity Report both. XMC will be based onsource files and logic mapping auto generated items and display in "Reporttem"or“Report ltem Pending"Queue. 
    After Maturity Report uploaded and generated in XMC, KL LOANS OPSPROCESSING -MAKER can open item then follow KL Loans Workflow actionssubmit to KLLOANS OPS-PROCESSING -CHECKER.

3.HKGCM Workflow actions and Status change
    1.KL LOANS OPS - PROCESSING -MAKER creates instruction with full informationvia New Instruction and do“Maker Submit":CURRENT STATUS set to “KL LOANS OPS", PROCESS STATUS set to"PROCESSING-CHECKER”.
    2.KL LOANS OPS -PROCESSING -CHECKER examines whether the target instruction can be approved or not.
    3.If instruction can be approved, system checking QC REQUIRE is true or not, ifyes, KL LOANS OPS -PROCESSING -CHECKER do“Submit to QC”:CURRENT STATUS keeps “KL LOANS OPS", PROCESS STATUS set toDRAWDOWN-OC".If nO, KL LOANS OPS- PROCESSING -CHECKER do"Complete”:CURRENT STATUS set to “COMPLETED", PROCESS STATUS set to“COMPLETED".
    4.If instruction cannot be approved, KL LOANS OPS-PROCESSING -CHECKER will return instruction back to KL LOANS OPS - PROCESSING -MAKER, CURRENT STATUS set to “KL LOANS OPS”, PROCESS STATUS set to“PROCESSING-MAKER-MANUAL”.
    5.After instruction in“DRAWDOWN-QC" stage, lf QC role found target instructionhas some issue, QC will do "Return":The instruction will back to KL LOANS OPS - PROCESSING -MAKER, CURRENTSTATUS set to “KL LOANS OPS", PROCESS STATUS set to"PROCESSING - MAKER-MANUAL"
    6.If QC need do work and is done on it, QC will do “Complete Drawdown QC”:Instruction will be set back to KL LOANS OPS - PROCESSING -CHECKER.CURRENT STATUS set to “KL LOANS OPS”, PROCESS STATUS set to“PROCESSING-CHECKER-QC CHECKED”.lf instruction's CURRENT STATUS is “KL LOANS OPS", PROCESS STATUS is"PROCESSING -CHECKER -QC CHECKED”, KL LOANS OPS -PROCESSING -CHECKER have access to decided directly complete instruction or return to KLLOANS OPS - PROCESSING -MAKER. After"Complete” action, instructionCURRENT STATUS set to “COMPLETED", PROCESS STATUS set to “COMPLETED”.
"""
