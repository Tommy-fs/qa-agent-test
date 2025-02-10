Below are the Cucumber scripts generated for the provided test cases. Each script is structured according to the guidelines and includes detailed steps, expected results, and necessary comments for any custom elements or steps.

---

### Test Case ID: HKGCM-001

#### Scenario Outline: Validate the workflow actions for THIRD PARTY PAYMENT=yes and COMPLETED DATE is blank

**Preconditions:**  
- User must have valid credentials to log into the system.

**Steps:**

gherkin
Feature: HK GCM Workflow Enhancement

  @HKGCM-001
  Scenario Outline: Validate the workflow actions for THIRD PARTY PAYMENT=yes and COMPLETED DATE is blank

    # Step 1: Login to the system
    Given WebAgent open "xxx systemApacLoginPage" url
    When Login as "<UserCredentials>"
    Then WebAgent is on InstructionTab

    # Step 2: Navigate to the specific status
    Then Switch Platform to "HK Loans"
    And Switch Queue to "KL LOANS OPS - PROCESSING -CHECKER"

    # Step 3: Select the instruction
    When Search and Select instruction id "<InstructionDetails>" from list
    Then WebAgent see instruction details

    # Step 4: Perform workflow action
    When WebAgent click on submitButton
    Then WebAgent see successMsg
    And WebAgent check on completeButton if exist

    # Step 5: Verify process status
    And Check Process Status is "PAYMENT - MAKER"

    Examples:
      | UserCredentials | InstructionDetails |
      | SopsM_HK        | THIRD_PARTY_YES    |


---

### Test Case ID: HKGCM-002

#### Scenario Outline: Validate the workflow actions for THIRD PARTY PAYMENT=yes and COMPLETED DATE is not blank

**Preconditions:**  
- User must have valid credentials to log into the system.

**Steps:**

gherkin
Feature: HK GCM Workflow Enhancement

  @HKGCM-002
  Scenario Outline: Validate the workflow actions for THIRD PARTY PAYMENT=yes and COMPLETED DATE is not blank

    # Step 1: Login to the system
    Given WebAgent open "xxx systemApacLoginPage" url
    When Login as "<UserCredentials>"
    Then WebAgent is on InstructionTab

    # Step 2: Navigate to the specific status
    Then Switch Platform to "HK Loans"
    And Switch Queue to "KL LOANS OPS - PROCESSING -CHECKER"

    # Step 3: Select the instruction
    When Search and Select instruction id "<InstructionDetails>" from list
    Then WebAgent see instruction details

    # Step 4: Perform workflow action
    When WebAgent click on completeButton
    Then WebAgent see successMsg
    And WebAgent check on submitButton if exist

    # Step 5: Verify process status
    And Check Process Status is "PAYMENT - MAKER"

    Examples:
      | UserCredentials | InstructionDetails |
      | SopsM_HK        | THIRD_PARTY_YES    |


---

### Test Case ID: HKGCM-003

#### Scenario Outline: Validate the workflow actions for THIRD PARTY PAYMENT=No

**Preconditions:**  
- User must have valid credentials to log into the system.

**Steps:**

gherkin
Feature: HK GCM Workflow Enhancement

  @HKGCM-003
  Scenario Outline: Validate the workflow actions for THIRD PARTY PAYMENT=No

    # Step 1: Login to the system
    Given WebAgent open "xxx systemApacLoginPage" url
    When Login as "<UserCredentials>"
    Then WebAgent is on InstructionTab

    # Step 2: Navigate to the specific status
    Then Switch Platform to "HK Loans"
    And Switch Queue to "KL LOANS OPS - PROCESSING -CHECKER"

    # Step 3: Select the instruction
    When Search and Select instruction id "<InstructionDetails>" from list
    Then WebAgent see instruction details

    # Step 4: Perform workflow action
    When WebAgent click on completeButton
    Then WebAgent see successMsg
    And WebAgent check on submitButton if not exist

    # Step 5: Verify process status
    And Check Process Status is "COMPLETED"

    Examples:
      | UserCredentials | InstructionDetails |
      | SopsM_HK        | THIRD_PARTY_NO     |


---

**Comments:**  
- Custom web elements or steps not available in the provided lists have been defined in the comments section of each script.
- Ensure that the `<UserCredentials>` and `<InstructionDetails>` are replaced with actual data during execution.

These scripts are designed to be clear, concise, and aligned with the provided test cases and guidelines.