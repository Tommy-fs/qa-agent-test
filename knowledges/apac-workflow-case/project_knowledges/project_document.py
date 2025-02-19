PROJECT_DOCUMENT = """
This system is a system for creating instruction orders, which have many fields. 
Some require user input, while others are automatically entered by the system and follow different workflows. 
Each order has a corresponding state at each step, 
and users with corresponding permissions can operate the order in the corresponding state to perform actions, 
and then proceed step by step.

HK Instruction Workflow
1. Workflow type
“HK GCM" Workflow is one workflow of HK KL Loans Workflow which created by KL LOANS OPS-PROCESSING -MAKER.

2.HKGCM Workflow actions and Status change
    1.user who has the KL LOANS OPS - PROCESSING -MAKER role can create instruction with full information via 'New Instruction' button and do “Maker Submit" action. Other roles are not allowed to create instructions
    The instruction's CURRENT STATUS will be set to “KL LOANS OPS", PROCESS STATUS will be set to "KL LOANS  - PROCESSING-CHECKER”.
    Additional: THIRD PARTY PAYMENT is a field where users need to select yes or no
    2.If QC REQUIRE field is true ,The user who has the KL LOANS OPS -PROCESSING -CHECKER role do “Submit to QC” action, 
    CURRENT STATUS keeps “KL LOANS OPS", PROCESS STATUS will be set to "DRAWDOWN-QC".
    3.If QC REQUIRE field is false ,The user who has the  KL LOANS OPS- PROCESSING -CHECKER role do "Complete” action, 
    CURRENT STATUS will be set to “COMPLETED", PROCESS STATUS will be set to “COMPLETED".
    COMPLETED DATE Field will be set today, Additional: COMPLETED DATE This is a field that is automatically set by the system and cannot be modified manually by the user. Before this state, the field of COMPLETED DATE is empty.
    4.The user who has the  KL LOANS OPS-PROCESSING -CHECKER role can do return action back to KL LOANS OPS - PROCESSING -MAKER, 
    CURRENT STATUS will be set to “KL LOANS OPS”, PROCESS STATUS will be set to “PROCESSING-MAKER-MANUAL”.
    5.If instruction in “DRAWDOWN-QC" stage, The user who has the  QC role found can do "Return",
    The instruction will back to 'KL LOANS OPS - PROCESSING -MAKER', CURRENT STATUS will be set to “KL LOANS OPS", PROCESS STATUS will be set to"PROCESSING - MAKER-MANUAL"
    6.If instruction in “DRAWDOWN-QC" stage, The user who has the QC role can do “Complete Drawdown QC”
    Instruction will be set back to 'KL LOANS OPS - PROCESSING -CHECKER'. CURRENT STATUS will be set to “KL LOANS OPS”, PROCESS STATUS will be set to“PROCESSING-CHECKER-QC CHECKED”.
    7.If instruction's CURRENT STATUS is “KL LOANS OPS", PROCESS STATUS is"PROCESSING -CHECKER -QC CHECKED”, 
    The role of 'KL LOANS OPS -PROCESSING' -CHECKER have access to decided directly 'complete' instruction or 'return to KLLOANS OPS - PROCESSING -MAKER'. 
    After "Complete” action, instructionCURRENT STATUS will be set to “COMPLETED", PROCESS STATUS will be set to “COMPLETED”.
"""
