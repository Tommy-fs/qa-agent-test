```gherkin
Feature: HK GCM Workflow - KL LOANS OPS - PROCESS CHECK

  @HK_GCM_Workflow-001
  Scenario Outline: Verify actions based on THIRD PARTY PAYMENT (Yes) and COMPLETED DATE

    # Preconditions:
    # The system should be running and accessible.
    # KL LOANS OPS - PROCESS CHECK user account should exist.

    # STEP 1: Create a new instruction in the system.
    Given a new instruction is created with THIRD PARTY PAYMENT set to 'Yes'
    # Expected Result: Instruction created successfully.

    # STEP 2: Login as KL LOANS OPS - PROCESS CHECK.
    When Login as "KL LOANS OPS - PROCESS CHECK"
    # Expected Result: Login successful.

    # STEP 3: Access the newly created instruction.
    Then Access the instruction with Instruction ID
    # Expected Result: Instruction details displayed.

    # STEP 4: Verify available actions before COMPLETED DATE is reached.
    And Verify available actions before COMPLETED DATE for THIRD PARTY PAYMENT 'Yes'
    # Expected Result: Specific actions available as per HK GCM Workflow with THIRD PARTY PAYMENT 'Yes' and before completion date.

    # STEP 5: Wait for the system to set the COMPLETED DATE.
    Then Wait for the system to set the COMPLETED DATE
    # Expected Result: COMPLETED DATE populated by the system.

    # STEP 6: Refresh the instruction view.
    When Refresh the instruction view
    # Expected Result: Instruction details displayed with COMPLETED DATE.

    # STEP 7: Verify available actions after COMPLETED DATE is reached.
    Then Verify available actions after COMPLETED DATE for THIRD PARTY PAYMENT 'Yes'
    # Expected Result: Specific actions available as per HK GCM Workflow with THIRD PARTY PAYMENT 'Yes' and after completion date. These actions should differ from step 4.

    Examples:
      | |

---
Feature: HK GCM Workflow - KL LOANS OPS - PROCESS CHECK

  @HK_GCM_Workflow-002
  Scenario Outline: Verify actions based on THIRD PARTY PAYMENT (No) and COMPLETED DATE

    # Preconditions:
    # The system should be running and accessible.
    # KL LOANS OPS - PROCESS CHECK user account should exist.

    # STEP 1: Create a new instruction in the system.
    Given a new instruction is created with THIRD PARTY PAYMENT set to 'No'
    # Expected Result: Instruction created successfully.

    # STEP 2: Login as KL LOANS OPS - PROCESS CHECK.
    When Login as "KL LOANS OPS - PROCESS CHECK"
    # Expected Result: Login successful.

    # STEP 3: Access the newly created instruction.
    Then Access the instruction with Instruction ID
    # Expected Result: Instruction details displayed.

    # STEP 4: Verify available actions before COMPLETED DATE is reached.
    And Verify available actions before COMPLETED DATE for THIRD PARTY PAYMENT 'No'
    # Expected Result: Specific actions available as per HK GCM Workflow with THIRD PARTY PAYMENT 'No' and before completion date.

    # STEP 5: Wait for the system to set the COMPLETED DATE.
    Then Wait for the system to set the COMPLETED DATE
    # Expected Result: COMPLETED DATE populated by the system.

    # STEP 6: Refresh the instruction view.
    When Refresh the instruction view
    # Expected Result: Instruction details displayed with COMPLETED DATE.

    # STEP 7: Verify available actions after COMPLETED DATE is reached.
    Then Verify available actions after COMPLETED DATE for THIRD PARTY PAYMENT 'No'
    # Expected Result: Specific actions available as per HK GCM Workflow with THIRD PARTY PAYMENT 'No' and after completion date. These actions should differ from step 4 and also differ from test case HK_GCM_Workflow-001 step 7.

    Examples:
      | |

---
Feature: HK GCM Workflow - COMPLETED DATE Modification

  @HK_GCM_Workflow-003
  Scenario Outline: Verify COMPLETED DATE cannot be manually modified

    # Preconditions:
    # The system should be running and accessible.
    # KL LOANS OPS - PROCESS CHECK user account should exist.

    # STEP 1: Create a new instruction in the system.
    Given a new instruction is created
    # Expected Result: Instruction created successfully.

    # STEP 2: Login as KL LOANS OPS - PROCESS CHECK.
    When Login as "KL LOANS OPS - PROCESS CHECK"
    # Expected Result: Login successful.

    # STEP 3: Access the newly created instruction.
    Then Access the instruction with Instruction ID
    # Expected Result: Instruction details displayed.

    # STEP 4: Attempt to manually modify the COMPLETED DATE field.
    And Attempt to manually modify the COMPLETED DATE field with "Any date"
    # Expected Result: The system should prevent manual modification of the COMPLETED DATE field. An error message may be displayed.

    Examples:
      | |
```