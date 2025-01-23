TEST_CASE_EXAMPLE = """
Priority: Critical
Name: InstructionLogic-001
Summary: Validate Cancel Instruction function in PH platform
Steps：
|No.| Test Step | Test Data | Expected Result |
| 1 | Login XXX system as Business (TT123456) | Business account: TT123456| Login successfully |
| 2 | Switch to Platform -PH |  |  |
| 3 | Create a new instruction and Perform Action-Create and Submit to KL | | Create new instruction in Test APP and current status is "submit to KL"|
| 4 | Login XXX system as Processing Maker(QQ22273) | Processing maker account: QQ22273 | Login successfully |
| 5 | Open the instruction created and Perform Action-Return to Business | instruction created | instruction return successfully and current status is "Return to Business" |
| 6 | Login XXX system as Business(BJ38271)again | Business account: TT123456 | Login successfully |
| 7 | Open the instruction created and Perform Action-CancelInstruction | instruction created | the Cancel Action success and current status is "Cancel Instruction"|
"""
