Below are the Cucumber scripts for the generated test cases based on the provided guidelines and available elements. Each script is associated with a specific test case and includes detailed steps and expected results.

---

### Test Case ID: GCMWorkflow-001

**Scenario Outline:** Validate the workflow actions for instructions with THIRD PARTY PAYMENT set to "Yes" and COMPLETED DATE is blank.

**Preconditions:** User must have access to the XXX system with Maker and Checker roles.

gherkin
Feature: HK GCM Workflow Enhancement

  @GCMWorkflow-001
  Scenario Outline: Validate workflow actions for THIRD PARTY PAYMENT "Yes" and COMPLETED DATE blank

    # ***************************************************************
    # STEP 1: Maker creates an instruction and submits it
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - MAKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on InstructionTab
    And WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Select "Yes" from thirdPartyPaymentDropdownlist
    And WebAgent type "" into completedDateTextbox
    Then WebAgent click on submitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "GCM" from successMsg into @instructionId and @instructionUrl
    Then Sign Out

    # ***************************************************************
    # STEP 2: Checker verifies the instruction
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - CHECKER"
    When WebAgent open "@instructionUrl.Value" url
    Then WebAgent is on InstructionTab
    And WebAgent see "Submit to Payment" button enabled
    And WebAgent see "Complete" button disabled
    Then Sign Out

    Examples:
      | thirdPartyPayment | completedDate |
      | Yes               |               |


---

### Test Case ID: GCMWorkflow-002

**Scenario Outline:** Validate the workflow actions for instructions with THIRD PARTY PAYMENT set to "Yes" and COMPLETED DATE is not blank.

**Preconditions:** User must have access to the XXX system with Maker and Checker roles.

gherkin
Feature: HK GCM Workflow Enhancement

  @GCMWorkflow-002
  Scenario Outline: Validate workflow actions for THIRD PARTY PAYMENT "Yes" and COMPLETED DATE set

    # ***************************************************************
    # STEP 1: Maker creates an instruction and completes it
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - MAKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on InstructionTab
    And WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Select "Yes" from thirdPartyPaymentDropdownlist
    And WebAgent type "<completedDate>" into completedDateTextbox
    Then WebAgent click on submitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "GCM" from successMsg into @instructionId and @instructionUrl
    Then Sign Out

    # ***************************************************************
    # STEP 2: Checker verifies the instruction
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - CHECKER"
    When WebAgent open "@instructionUrl.Value" url
    Then WebAgent is on InstructionTab
    And WebAgent see "Submit to Payment" button enabled
    And WebAgent see "Complete" button enabled
    Then Sign Out

    Examples:
      | thirdPartyPayment | completedDate |
      | Yes               | 2023-10-01    |


---

### Test Case ID: GCMWorkflow-003

**Scenario Outline:** Validate the workflow actions for instructions with THIRD PARTY PAYMENT set to "No".

**Preconditions:** User must have access to the XXX system with Maker and Checker roles.

gherkin
Feature: HK GCM Workflow Enhancement

  @GCMWorkflow-003
  Scenario Outline: Validate workflow actions for THIRD PARTY PAYMENT "No"

    # ***************************************************************
    # STEP 1: Maker creates an instruction and submits it
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - MAKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on InstructionTab
    And WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Select "No" from thirdPartyPaymentDropdownlist
    Then WebAgent click on submitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "GCM" from successMsg into @instructionId and @instructionUrl
    Then Sign Out

    # ***************************************************************
    # STEP 2: Checker verifies the instruction
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - CHECKER"
    When WebAgent open "@instructionUrl.Value" url
    Then WebAgent is on InstructionTab
    And WebAgent see "Complete" button enabled
    And WebAgent see "Submit to Payment" button disabled
    Then Sign Out

    Examples:
      | thirdPartyPayment |
      | No                |


---

### Test Case ID: GCMWorkflow-004

**Scenario Outline:** Validate the workflow transition after "Submit to Payment" action.

**Preconditions:** User must have access to the XXX system with Checker and Payment Maker roles.

gherkin
Feature: HK GCM Workflow Enhancement

  @GCMWorkflow-004
  Scenario Outline: Validate workflow transition after "Submit to Payment" action

    # ***************************************************************
    # STEP 1: Checker submits instruction to payment
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - CHECKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on InstructionTab
    And WebAgent open "<instructionUrl>"
    Then WebAgent click on submitToPaymentButton
    And WebAgent see successMsg
    Then Sign Out

    # ***************************************************************
    # STEP 2: Payment Maker verifies available actions
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - PAYMENT MAKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on PaymentTab
    And WebAgent open "<instructionUrl>"
    And WebAgent see "Submit Payment Checker" button enabled
    And WebAgent see "Return to Maker" button enabled
    Then Sign Out

    Examples:
      | instructionUrl |
      | @instructionUrl |


---

### Test Case ID: GCMWorkflow-005

**Scenario Outline:** Validate the workflow transition after "Submit Payment Checker" action.

**Preconditions:** User must have access to the XXX system with Payment Maker and Payment Checker roles.

gherkin
Feature: HK GCM Workflow Enhancement

  @GCMWorkflow-005
  Scenario Outline: Validate workflow transition after "Submit Payment Checker" action

    # ***************************************************************
    # STEP 1: Payment Maker submits to Payment Checker
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - PAYMENT MAKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on PaymentTab
    And WebAgent open "<instructionUrl>"
    Then WebAgent click on submitToPaymentCheckerButton
    And WebAgent see successMsg
    Then Sign Out

    # ***************************************************************
    # STEP 2: Payment Checker verifies available actions
    # ***************************************************************
    Given Login as "KL LOANS OPS - PROCESSING - PAYMENT CHECKER"
    When WebAgent open "XXX system" url
    Then WebAgent is on PaymentTab
    And WebAgent open "<instructionUrl>"
    And WebAgent see "Complete" button enabled
    And WebAgent see "Return to Payment Maker" button enabled
    Then Sign Out

    Examples:
      | instructionUrl |
      | @instructionUrl |


---

**Comments:**

- For any missing web elements or steps, please define them as needed in the comments section of each script.
- Ensure all scripts are executed in the correct environment and with the correct user roles.
- The scripts are designed to be clear and concise, following the Gherkin syntax standards.