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

TEST_CASE_GUIDE = """
Instruction test case guide
    1. You need to detect the work flow involved according to the JIRA requirements, and then generate different test cases to test different work flow scenarios.
    2. For each test case, you need to create a new instruction instead of opening an instruction. The test data can be the general data required for production, but some special fields need to be specified.
    3. You need to log in different roles to perform different operations on the instruction.
    4. You need to test a complete work flow in one test case.
    5. THIRD PARTY PAYMENT and QC REQUIRE field is the fields user can choose yes or no. 
    6. The Complete data is a field that is automatically set by the system and cannot be modified manually by the user. The ticket will only have the complete data field when the Complete action is completed. You cannot fill this field when creating an instruction.
"""
