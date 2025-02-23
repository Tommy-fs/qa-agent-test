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
1. **Clarity of User Roles** 
   - [ ] Each step of the test case should clearly specify the user role performing the action to ensure the operating entity is unambiguous. 
   - [ ] If consecutive steps are performed by the same user role, repeated labeling can be omitted; however, when the user role changes, the new role must be explicitly indicated.

2. **Standardization of Test Data** 
   - [ ] Specific data involved in the test case (e.g., input values, configuration parameters, environment variables, etc.) should be clearly annotated in the test data section, along with their source or generation rules. 
   - [ ] For dynamically generated data, describe its generation logic or range to ensure test repeatability and consistency.

3. **Completeness of Checkpoints** 
   - [ ] Test cases should include explicit checkpoints to verify whether the system behavior meets expectations. Checkpoints should cover multiple dimensions such as functionality, interface, and performance, for example: 
     - Correctness of field values (e.g., input validation, calculation results, etc.). 
     - Display status of interface elements (e.g., buttons, menus, prompt messages, etc.). 
     - Timeliness and accuracy of system responses (e.g., API return results, database updates, etc.). 
   - [ ] Each checkpoint should clearly describe the expected result and compare it with the actual result to ensure the rigor of the test.

4. **Readability and Maintainability of Test Cases** 
   - [ ] Test case descriptions should be concise and unambiguous, making it easy for team members to understand and execute. 
   - [ ] The structure of test cases should be modular to facilitate future maintenance and expansion, such as organizing cases through grouping or tagging. 
   - [ ] For complex scenarios, comments or explanations can be added to help testers quickly understand the context.

5. **Coverage and Boundary Conditions** 
   - [ ] Test cases should cover core functionalities, common scenarios, and edge cases to ensure comprehensive validation of features. 
   - [ ] Special attention should be paid to boundary conditions (e.g., upper and lower limits of input values, special characters, null values, etc.) to verify the robustness of the system. 
   - [ ] For scenarios involving multiple languages, devices, or resolutions, corresponding test cases should be designed to ensure compatibility.

6. **Dependency and Environment Management** 
   - [ ] Test cases should clearly annotate their dependencies on external conditions (e.g., database state, network environment, third-party services, etc.) to facilitate environment setup and issue troubleshooting. 
   - [ ] For test cases requiring specific environments or configurations, detailed setup instructions should be provided to ensure test executability.

7. **Adaptability for Automation** 
   - [ ] If test cases are intended for automated testing, ensure that their steps are clearly described and scriptable, avoiding reliance on manual judgment. 
   - [ ] For automated testing, annotate key operational elements (e.g., button IDs, input field names, etc.) to facilitate script writing and maintenance.

8. **Work flow test guide** 
    1. You need to detect the work flow involved according to the JIRA requirements, and then generate different test cases to test different work flow scenarios.
    2. For each test case, you need to create a new instruction instead of opening an instruction. The test data can be the general data required for production, but some special fields need to be specified.
    3. Creating instructions can only be done for specific roles, which you need to find in the documentation.
    5. You need to log in different roles to perform different operations on the instruction.
    6. You need to test a complete work flow in one test case.
    7. THIRD PARTY PAYMENT and QC REQUIRE field is the fields user can choose yes or no. 
    8. The Complete data is a field that is automatically set by the system and cannot be modified manually by the user. The ticket will only have the complete data field when the Complete action is completed. You cannot fill this field when creating an instruction.
    9. To verify whether an action is available, you must actually trigger the action to see if an error is reported.
"""


