Below are the Cucumber scripts generated for the provided test cases. Each script is written in Gherkin format, following the guidelines and using the available web elements and steps.

---

### Test Case ID: HKGCM-001
**Scenario Outline:** Validate the creation of a new instruction via "NewInstruction" button by KL LOANS OPS-PROCESSING -MAKER role

**Preconditions:** User must have KL LOANS OPS-PROCESSING -MAKER role access.

gherkin
Feature: New Instruction Creation

  @critical
  Scenario Outline: HKGCM-001 - New Instruction Creation by KL LOANS OPS-PROCESSING -MAKER

    # ***************************************************************
    # STEP 1: Log in to the system as KL LOANS OPS-PROCESSING -MAKER
    # ***************************************************************
    Given Login as "<Role>"
    Then WebAgent is on InstructionTab

    # ***************************************************************
    # STEP 2: Click on the "NewInstruction-STARS" button
    # ***************************************************************
    When WebAgent click on createButton
    And WebAgent click on newInstructionItem
    Then WebAgent see newInstructionPage

    # ***************************************************************
    # STEP 3: Fill in all required information for the new instruction
    # ***************************************************************
    When WebAgent type "<InstructionDetails>" into instructionDetailsTextbox
    And WebAgent click on submitButton

    # ***************************************************************
    # STEP 4: Submit the instruction by clicking on "Maker Submit"
    # ***************************************************************
    Then WebAgent click on makerSubmitButton
    And WebAgent see successMsg
    And Check Process Status is "KL LOANS - PROCESSING-CHECKER"
    And Check ticket Status is "KL LOANS OPS"

    Examples:
      | Role                                | InstructionDetails |
      | KL LOANS OPS-PROCESSING -MAKER      | Instruction details |


**Comments:**
- `newInstructionPage` and `makerSubmitButton` are assumed to be existing web elements. If not, they should be defined.

---

### Test Case ID: HKGCM-002
**Scenario Outline:** Validate the creation of an instruction by opening "Report item" by KL LOANS OPS-PROCESSING -MAKER and KL LOANS OPS-PROCESSING-CHECKER

**Preconditions:** User must have KL LOANS OPS-PROCESSING -MAKER and KL LOANS OPS-PROCESSING-CHECKER role access.

gherkin
Feature: Instruction Creation via Report Item

  @high
  Scenario Outline: HKGCM-002 - Instruction Creation by Report Item

    # ***************************************************************
    # STEP 1: Log in to the system as KL LOANS OPS-PROCESSING -MAKER
    # ***************************************************************
    Given Login as "<RoleMaker>"
    Then WebAgent is on ReportItemQueue

    # ***************************************************************
    # STEP 2: Access the "Report item" or "Report Item Pending" queue
    # ***************************************************************
    When WebAgent click on reportItemMenu
    Then WebAgent see reportItemList

    # ***************************************************************
    # STEP 3: Open the item and follow KL Loans Workflow actions
    # ***************************************************************
    When WebAgent click on firstInboxListItemBySubject
    And WebAgent click on submitButton
    Then WebAgent see successMsg

    # ***************************************************************
    # STEP 4: Log in to the system as KL LOANS OPS-PROCESSING -CHECKER
    # ***************************************************************
    Given Login as "<RoleChecker>"
    Then WebAgent is on InstructionTab

    # ***************************************************************
    # STEP 5: Review the submitted item and take appropriate action
    # ***************************************************************
    When WebAgent click on firstInboxListItemBySubject
    And WebAgent click on approveButton
    Then WebAgent see successMsg

    Examples:
      | RoleMaker                          | RoleChecker                          |
      | KL LOANS OPS-PROCESSING -MAKER     | KL LOANS OPS-PROCESSING -CHECKER     |


**Comments:**
- `reportItemList`, `approveButton`, and `reportItemMenu` are assumed to be existing web elements. If not, they should be defined.

---

### Test Case ID: HKGCM-003
**Scenario Outline:** Validate the workflow actions and status changes in HKGCM Workflow

**Preconditions:** Instruction must be created with full information.

gherkin
Feature: Workflow Actions and Status Changes

  @medium
  Scenario Outline: HKGCM-003 - Workflow Actions and Status Changes

    # ***************************************************************
    # STEP 1: Create an instruction with full information via "New Instruction"
    # ***************************************************************
    Given Login as "<Role>"
    When WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And WebAgent type "<InstructionDetails>" into instructionDetailsTextbox
    And WebAgent click on submitButton
    Then WebAgent see successMsg
    And Check Process Status is "KL LOANS - PROCESSING-CHECKER"
    And Check ticket Status is "KL LOANS OPS"

    # ***************************************************************
    # STEP 2: KL LOANS OPS-PROCESSING-CHECKER examines the instruction for approval
    # ***************************************************************
    Given Login as "<RoleChecker>"
    When WebAgent click on firstInboxListItemBySubject
    And WebAgent click on approveButton
    Then WebAgent see successMsg

    # ***************************************************************
    # STEP 3: Perform actions based on QC REQUIRE and instruction approval status
    # ***************************************************************
    When WebAgent click on qcRequireButton
    Then WebAgent see qcStatusUpdatedMsg

    # ***************************************************************
    # STEP 4: Perform actions based on QC findings in "DRAWDOWN-QC" stage
    # ***************************************************************
    When WebAgent click on drawdownQcButton
    Then WebAgent see drawdownStatusUpdatedMsg

    Examples:
      | Role                                | RoleChecker                          | InstructionDetails |
      | KL LOANS OPS-PROCESSING -MAKER      | KL LOANS OPS-PROCESSING -CHECKER     | Instruction details |


**Comments:**
- `qcRequireButton`, `qcStatusUpdatedMsg`, `drawdownQcButton`, and `drawdownStatusUpdatedMsg` are assumed to be existing web elements. If not, they should be defined.

---

### Test Case ID: HKGCM-004
**Scenario Outline:** Validate the workflow actions for THIRD PARTY PAYMENT in HK Loans Workflow

**Preconditions:** THIRD PARTY PAYMENT status must be checked.

gherkin
Feature: THIRD PARTY PAYMENT Workflow Actions

  @low
  Scenario Outline: HKGCM-004 - THIRD PARTY PAYMENT Workflow Actions

    # ***************************************************************
    # STEP 1: Check if THIRD PARTY PAYMENT is yes and COMPLETED DATE is blank
    # ***************************************************************
    Given Login as "<Role>"
    When WebAgent check on thirdPartyPaymentYesRadio
    And WebAgent check on completedDateBlankCheckbox
    Then WebAgent see submitToPaymentEnabled
    And WebAgent see completeDisabled

    # ***************************************************************
    # STEP 2: Check if THIRD PARTY PAYMENT is yes and COMPLETED DATE is not blank
    # ***************************************************************
    When WebAgent check on thirdPartyPaymentYesRadio
    And WebAgent uncheck on completedDateBlankCheckbox
    Then WebAgent see submitToPaymentEnabled
    And WebAgent see completeEnabled

    # ***************************************************************
    # STEP 3: Check if THIRD PARTY PAYMENT is No
    # ***************************************************************
    When WebAgent check on thirdPartyPaymentNoRadio
    Then WebAgent see submitToPaymentDisabled
    And WebAgent see completeEnabled

    Examples:
      | Role                                |
      | KL LOANS OPS-PROCESSING -MAKER      |


**Comments:**
- `thirdPartyPaymentYesRadio`, `completedDateBlankCheckbox`, `submitToPaymentEnabled`, `completeDisabled`, `thirdPartyPaymentNoRadio`, `submitToPaymentDisabled`, and `completeEnabled` are assumed to be existing web elements. If not, they should be defined.

---

These scripts are designed to be clear, concise, and aligned with the provided test cases. They utilize the available web elements and steps, ensuring compliance with syntax standards.