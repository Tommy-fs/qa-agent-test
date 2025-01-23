Below are the Cucumber scripts generated for the provided test cases. Each script is structured to include the necessary components and follows the guidelines provided.

---

### Test Case ID: TC_HK_GCM_001
#### Scenario Outline: HK GCM Workflow Enhancement - Submit to Payment Action
**Preconditions:** User must have valid credentials for KL LOANS OPS-PROCESSING-CHECKER.

gherkin
@apacinstruction @high
Feature: HK GCM Workflow Enhancement

  Scenario Outline: Submit to Payment Action
    # ***************************************************************
    # STEP 1: Log in as KL LOANS OPS-PROCESSING-CHECKER
    # ***************************************************************
    Given Login as "<user_role>"
    Then WebAgent is on "<platform>"

    # ***************************************************************
    # STEP 2: Create a new instruction with THIRD PARTY PAYMENT = Yes and COMPLETED DATE = blank
    # ***************************************************************
    When WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And WebAgent select "Yes" from thirdPartyPaymentDropdownlist
    And WebAgent type "" into completedDateTextbox
    Then WebAgent see submitToPaymentActionEnabled
    And WebAgent see completeActionDisabled

    # ***************************************************************
    # STEP 3: Submit the instruction
    # ***************************************************************
    When WebAgent click on submitButton
    Then Check Process Status is "PAYMENT - MAKER"

    # ***************************************************************
    # STEP 4: Create a new instruction with THIRD PARTY PAYMENT = Yes and COMPLETED DATE is not blank
    # ***************************************************************
    When WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And WebAgent select "Yes" from thirdPartyPaymentDropdownlist
    And WebAgent type "<completed_date>" into completedDateTextbox
    Then WebAgent see completeActionEnabled
    And WebAgent see submitToPaymentActionEnabled

    # ***************************************************************
    # STEP 5: Submit the instruction
    # ***************************************************************
    When WebAgent click on submitButton
    Then Check Process Status is "PAYMENT - MAKER"

    # ***************************************************************
    # STEP 6: Create a new instruction with THIRD PARTY PAYMENT = No
    # ***************************************************************
    When WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And WebAgent select "No" from thirdPartyPaymentDropdownlist
    Then WebAgent see completeActionEnabled
    And WebAgent see submitToPaymentActionDisabled

    # ***************************************************************
    # STEP 7: Submit the instruction
    # ***************************************************************
    When WebAgent click on submitButton
    Then Check Process Status is "PROCESSING - MAKER-MANUAL"

    Examples:
      | user_role                          | platform  | completed_date |
      | KL LOANS OPS-PROCESSING-CHECKER    | HK Loans  | 2023-10-01     |


---

### Test Case ID: TC_HK_GCM_002
#### Scenario Outline: HK GCM Workflow Enhancement - Payment Checker Actions
**Preconditions:** User must have valid credentials for KL LOANS OPS-PROCESSING-PAYMENT CHECKER.

gherkin
@apacinstruction @medium
Feature: HK GCM Workflow Enhancement

  Scenario Outline: Payment Checker Actions
    # ***************************************************************
    # STEP 1: Log in as KL LOANS OPS-PROCESSING-PAYMENT CHECKER
    # ***************************************************************
    Given Login as "<user_role>"
    Then WebAgent is on "<platform>"

    # ***************************************************************
    # STEP 2: Perform "Complete" action on an instruction
    # ***************************************************************
    When WebAgent click on completeButton
    Then Check ticket Status is "COMPLETED"
    And Check Process Status is "COMPLETED"

    # ***************************************************************
    # STEP 3: Perform "Return to KL LOANS OPS-PROCESSING-MAKER" action
    # ***************************************************************
    When WebAgent click on returnToMakerButton
    Then Check Process Status is "PROCESSING-MAKER-MANUAL"

    # ***************************************************************
    # STEP 4: Perform "Submit to Payment Checker" action
    # ***************************************************************
    When WebAgent click on submitToPaymentCheckerButton
    Then Check Process Status is "PAYMENT - MAKER"

    # ***************************************************************
    # STEP 5: Perform "Return to KL LOANS OPS-PROCESSING-MAKER" action
    # ***************************************************************
    When WebAgent click on returnToMakerButton
    Then Check Process Status is "PROCESSING - MAKER-MANUAL"

    # ***************************************************************
    # STEP 6: Perform "Complete" action after "Submit to Payment Checker"
    # ***************************************************************
    When WebAgent click on completeButton
    Then Check ticket Status is "COMPLETED"
    And Check Process Status is "COMPLETED"

    Examples:
      | user_role                              | platform  |
      | KL LOANS OPS-PROCESSING-PAYMENT CHECKER| HK Loans  |


---

### Test Case ID: TC_HK_GCM_003
#### Scenario Outline: HK GCM Workflow Enhancement - Payment Maker Actions
**Preconditions:** User must have valid credentials for KL LOANS OPS-PROCESSING-PAYMENT MAKER.

gherkin
@apacinstruction @low
Feature: HK GCM Workflow Enhancement

  Scenario Outline: Payment Maker Actions
    # ***************************************************************
    # STEP 1: Log in as KL LOANS OPS-PROCESSING-PAYMENT MAKER
    # ***************************************************************
    Given Login as "<user_role>"
    Then WebAgent is on "<platform>"

    # ***************************************************************
    # STEP 2: Perform "Return to KL LOANS OPS-PROCESSING-MAKER" action
    # ***************************************************************
    When WebAgent click on returnToMakerButton
    Then Check Process Status is "PROCESSING-MAKER-MANUAL"

    # ***************************************************************
    # STEP 3: Perform "Submit to Payment Checker" action
    # ***************************************************************
    When WebAgent click on submitToPaymentCheckerButton
    Then Check Process Status is "PAYMENT - MAKER"

    # ***************************************************************
    # STEP 4: Perform "Return to KL LOANS OPS-PROCESSING-PAYMENT MAKER" action
    # ***************************************************************
    When WebAgent click on returnToPaymentMakerButton
    Then Check Process Status is "PAYMENT - MAKER"

    Examples:
      | user_role                            | platform  |
      | KL LOANS OPS-PROCESSING-PAYMENT MAKER| HK Loans  |


---

**Comments:**
- The web elements `submitToPaymentActionEnabled`, `completeActionDisabled`, `completeActionEnabled`, `submitToPaymentActionDisabled`, `completeButton`, `returnToMakerButton`, `submitToPaymentCheckerButton`, and `returnToPaymentMakerButton` are assumed to be defined in the system. If not, they should be defined as per the system's requirements.
- The `completedDateTextbox` is assumed to be a text input field for entering the completed date.

These scripts are designed to be clear, concise, and executable within the Cucumber framework, adhering to the syntax standards and guidelines provided.