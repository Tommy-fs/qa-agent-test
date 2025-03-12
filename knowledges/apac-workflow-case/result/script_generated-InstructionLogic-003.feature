```cucumber
# Feature: InstructionLogic-003
# Test Case ID: InstructionLogic-003
# Scenario: Validate Workflow Actions for HK GCM with Third Party Payment
# Description: This scenario validates the workflow actions for a HK GCM instruction with Third Party Payment set to Yes.  It verifies that the "Complete" action is disabled until the COMPLETED DATE is populated and that the instruction can be returned to the Processing Maker.

Feature: Instruction Logic - 003

  @InstructionLogic-003
  Scenario Outline: Validate Workflow Actions for HK GCM with Third Party Payment

    # Preconditions: User is logged out.

    # Test Case Step 1: Login XXX system as Processing Checker (PC123456)
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "PC123456"
    Then Login successfully

    # Test Case Step 2: Create a new instruction with THIRD PARTY PAYMENT = Yes and QC REQUIRE = No
    When Create a new instruction with the following data:
      | Field              | Value |
      | THIRD PARTY PAYMENT | Yes   |
      | QC REQUIRE         | No    |
    Then Create new instruction in Test APP and current status is 'KL LOANS OPS', PROCESS STATUS is 'KL LOANS - PROCESSING-CHECKER'

    # Test Case Step 3: Attempt to Complete the instruction
    When Attempt to perform action "Complete" on the instruction
    Then Action 'Complete' is disabled due to THIRD PARTY PAYMENT being Yes and COMPLETED DATE being blank

    # Test Case Step 4: Perform Action - Submit to Payment
    When Perform action "Submit to Payment" on the instruction
    Then Instruction status changes to 'PAYMENT - MAKER', PROCESS STATUS is 'PAYMENT - MAKER'

    # Test Case Step 5: Login XXX system as Payment Maker (PM123456)
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "PM123456"
    Then Login successfully

    # Test Case Step 6: Perform Action - Submit Payment Checker
    # Assuming the Payment Maker needs to open the instruction first
    When Open the created instruction
    And Perform action "Submit to Payment Checker" on the instruction
    Then Instruction status changes to 'PAYMENT CHECKER', PROCESS STATUS is 'PAYMENT-CHECKER'

    # Test Case Step 7: Attempt to Complete the instruction
    # Assuming the Payment Checker needs to open the instruction first and provide a Completed Date if required.  This step needs clarification.
    When Open the created instruction
    And Enter Completed Date if required # This step needs further definition based on system behavior
    And Perform action "Complete" on the instruction
    Then Instruction status changes to 'COMPLETED', PROCESS STATUS is 'COMPLETED'

    # Test Case Step 8: Attempt to Return instruction to Processing Maker
    When Perform action "Return" on the instruction # Assuming "Return" is the correct action name
    Then Instruction returns successfully to 'KL LOANS OPS - PROCESSING - MAKER', PROCESS STATUS is 'PROCESSING - MAKER-MANUAL'


    Examples:
      |  |


# Comments:
# The following steps need to be implemented in the step definitions file:
# - Create a new instruction with the following data:  (This will require multiple steps within the step definition)
# - Attempt to perform action "<action>" on the instruction
# - Perform action "<action>" on the instruction
# - Open the created instruction
# - Enter Completed Date if required (This step needs further definition)
# - Login successfully (This likely already exists but should be verified)

# Considerations:
# - The exact wording of the status messages should be confirmed and updated in the script if necessary.
# - The "Return" action in step 8 needs to be verified.  The exact action name and expected status should be confirmed.
# - The process for entering the Completed Date in step 7 needs clarification.

# Improvements:
# -  Data-driven testing could be implemented to test with different instruction data.
# -  The script could be enhanced to include assertions for specific error messages when actions are disabled.

```


This revised script provides a more structured and detailed Cucumber scenario outline, directly addressing each step in the test case.  It also includes comments highlighting areas requiring further definition and potential improvements.  Remember to implement the missing step definitions based on the provided template and available web elements and steps.  This detailed approach ensures a strong link between the test case and the script, promoting maintainability and clarity.