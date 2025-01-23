PROJECT_DOCUMENT = """
HK Instruction Workflow
1. Workflow type
“HK GCM" Workflow is one workflow of HK KL Loans Workflow which created by KL LOANS OPS-PROCESSING -MAKER.S

2.HK GCM Instruction Creation
    1.Create Instruction by “NewInstruction” button
    There is a role could manually create new instruction, who are KL LOANS OPS-PROCESSING -MAKER role, can created instruction with button “NewInstruction-STARS" to run KL Loans workflow-HK GCM.
    2.Create Instruction by open“Report item”
    KL LOANS OPS -PROCESSING -MAKER and KL LOANS OPS-PROCESSING-CHECKER have access to Upload Maturity Report both. XXX system will be based on source files and logic mapping auto generated items and display in "Report item"or“Report ltem Pending"Queue. 
    After Maturity Report uploaded and generated in XXX system, KL LOANS OPS PROCESSING -MAKER can open item then follow KL Loans Workflow actions submit to K LLOANS OPS-PROCESSING -CHECKER.

3.HKGCM Workflow actions and Status change
    1.KL LOANS OPS - PROCESSING -MAKER creates instruction with full information via New Instruction and do“Maker Submit", CURRENT STATUS will be set to “KL LOANS OPS", PROCESS STATUS will be set to "KL LOANS  - PROCESSING-CHECKER”.
    2.KL LOANS OPS -PROCESSING - CHECKER examines whether the target instruction can be approved or not.
    3.If instruction can be approved, system checking QC REQUIRE is true or not, if yes, KL LOANS OPS -PROCESSING -CHECKER do “Submit to QC”, CURRENT STATUS keeps “KL LOANS OPS", PROCESS STATUS will be set to "DRAWDOWN-QC".If no, KL LOANS OPS- PROCESSING -CHECKER do "Complete”, CURRENT STATUS will be set to “COMPLETED", PROCESS STATUS will be set to“COMPLETED".
    4.If instruction cannot be approved, KL LOANS OPS-PROCESSING -CHECKER will return instruction back to KL LOANS OPS - PROCESSING -MAKER, CURRENT STATUS will be set to “KL LOANS OPS”, PROCESS STATUS will be set to“PROCESSING-MAKER-MANUAL”.
    5.After instruction in“DRAWDOWN-QC" stage, lf QC role found target instruction has some issue, QC will do "Return":The instruction will back to KL LOANS OPS - PROCESSING -MAKER, CURRENTSTATUS will be set to “KL LOANS OPS", PROCESS STATUS will be set to"PROCESSING - MAKER-MANUAL"
    6.If QC need do work and is done on it, QC will do “Complete Drawdown QC”:Instruction will be set back to KL LOANS OPS - PROCESSING -CHECKER.CURRENT STATUS will be set to “KL LOANS OPS”, PROCESS STATUS will be set to“PROCESSING-CHECKER-QC CHECKED”.lf instruction's CURRENT STATUS is “KL LOANS OPS", PROCESS STATUS is"PROCESSING -CHECKER -QC CHECKED”, KL LOANS OPS -PROCESSING -CHECKER have access to decided directly complete instruction or return to KLLOANS OPS - PROCESSING -MAKER. After"Complete” action, instructionCURRENT STATUS will be set to “COMPLETED", PROCESS STATUS will be set to “COMPLETED”.
"""
