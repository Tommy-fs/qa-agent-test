```gherkin
Feature: HK GCM Workflow - Action Verification

  @HK_GCM_Workflow-001
  Scenario Outline: Verify KL LOANS OPS - PROCESS CHECK actions based on THIRD PARTY PAYMENT (True) and COMPLETED DATE for HK GCM Workflow.
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.

    Given User logs in with valid credentials for "KL LOANS OPS - PROCESS CHECK" role
    # Step 2: Create a new instruction order
    When User creates a new instruction order with relevant details
    # Step 3: Set THIRD PARTY PAYMENT to True
    And User sets THIRD PARTY PAYMENT to "True"
    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on workflow rules and COMPLETED DATE
    # Expected Result: Only actions permitted based on workflow rules and COMPLETED DATE are displayed

    Examples:
      | |

---
Feature: HK GCM Workflow - Action Verification

  @HK_GCM_Workflow-002
  Scenario Outline: Verify KL LOANS OPS - PROCESS CHECK actions based on THIRD PARTY PAYMENT (False) and COMPLETED DATE for HK GCM Workflow.
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.

    Given User logs in with valid credentials for "KL LOANS OPS - PROCESS CHECK" role
    # Step 2: Create a new instruction order
    When User creates a new instruction order with relevant details
    # Step 3: Set THIRD PARTY PAYMENT to False
    And User sets THIRD PARTY PAYMENT to "False"
    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on workflow rules and COMPLETED DATE
    # Expected Result: Only actions permitted based on workflow rules and COMPLETED DATE are displayed

    Examples:
      | |

---
Feature: HK GCM Workflow - Completed Date Verification

  @HK_GCM_Workflow-003
  Scenario Outline: Verify COMPLETED DATE is automatically set and non-modifiable.
    # Preconditions:
    # 1. User has valid credentials with any role.
    # 2. System is in a clean state.

    Given User logs in with valid credentials for any role
    # Step 2: Create a new instruction order
    When User creates a new instruction order with relevant details
    # Expected Result: Instruction created successfully with COMPLETED DATE automatically populated
    Then System automatically populates COMPLETED DATE upon instruction creation
    # Step 3: Attempt to modify COMPLETED DATE
    When User attempts to modify COMPLETED DATE with "Any date"
    # Expected Result: Modification not allowed.  Error message displayed or field disabled.
    Then System prevents modification of COMPLETED DATE and displays an error message or disables the field

    Examples:
      | |

---
Feature: HK GCM Workflow - Completed Date Impact Verification

  @HK_GCM_Workflow-004
  Scenario Outline: Verify impact of COMPLETED DATE on KL LOANS OPS - PROCESS CHECK actions with THIRD PARTY PAYMENT (True).
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.

    Given User logs in with valid credentials for "KL LOANS OPS - PROCESS CHECK" role
    # Step 2: Create a new instruction order
    When User creates a new instruction order with relevant details
    # Step 3: Set THIRD PARTY PAYMENT to True
    And User sets THIRD PARTY PAYMENT to "True"
    # Step 4: Simulate backdating COMPLETED DATE
    And User simulates backdating COMPLETED DATE to "Date in the past"
    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on backdated COMPLETED DATE and workflow rules
    # Step 5: Simulate future dating COMPLETED DATE
    And User simulates future dating COMPLETED DATE to "Date in the future"
    # Step 5: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on future dated COMPLETED DATE and workflow rules

    Examples:
      | |

---
Feature: HK GCM Workflow - Completed Date Impact Verification

  @HK_GCM_Workflow-005
  Scenario Outline: Verify impact of COMPLETED DATE on KL LOANS OPS - PROCESS CHECK actions with THIRD PARTY PAYMENT (False).
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.

    Given User logs in with valid credentials for "KL LOANS OPS - PROCESS CHECK" role
    # Step 2: Create a new instruction order
    When User creates a new instruction order with relevant details
    # Step 3: Set THIRD PARTY PAYMENT to False
    And User sets THIRD PARTY PAYMENT to "False"
    # Step 4: Simulate backdating COMPLETED DATE
    And User simulates backdating COMPLETED DATE to "Date in the past"
    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on backdated COMPLETED DATE and workflow rules
    # Step 5: Simulate future dating COMPLETED DATE
    And User simulates future dating COMPLETED DATE to "Date in the future"
    # Step 5: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on future dated COMPLETED DATE and workflow rules

    Examples:
      | |
```