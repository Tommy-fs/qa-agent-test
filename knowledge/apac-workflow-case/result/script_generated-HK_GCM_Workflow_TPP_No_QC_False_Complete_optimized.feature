Feature: HK GCM Workflow - Third Party Payment No, QC Required False - Complete
  Description: This feature validates the HK GCM workflow when THIRD PARTY PAYMENT is No and QC REQUIRE is False, covering the complete flow until completion.
  Test Case ID: HK_GCM_Workflow_TPP_No_QC_False_Complete
  Author: Jevons

  Background:
    Given WebAgent open "https://your-actual-url/login" url  # Replace with your actual URL

  @HK_GCM_TPP_No_QC_False
  Scenario Outline: Login as KL LOANS OPS - PROCESSING - MAKER (Test Case ID: 1)
    # Preconditions: None
    When Login as "KL LOANS OPS - PROCESSING - MAKER"
    Then User sees the welcome message "Welcome, KL LOANS OPS - PROCESSING - MAKER" # Specific assertion
    Then sign Out # Logout after scenario

    Examples:
      | |


  @HK_GCM_TPP_No_QC_False
  Scenario Outline: Create a new HK GCM Instruction (Test Case ID: 2)
    # Preconditions: User is logged in as KL LOANS OPS - PROCESSING - MAKER
    Given Login as "KL LOANS OPS - PROCESSING - MAKER"
    Then WebAgent is on InstructionTab
    And Switch Platform to "HK Loans"
    When Create HK GCM Instruction with Third Party Payment "No" and QC Require "False" and Customer Group "GCM" # Use template-based step, implemented below
    Then Instruction is created successfully with message "Instruction created successfully" # Specific assertion
    And Current Status is "KL LOANS OPS" # Specific assertion
    And Process Status is "KL LOANS - PROCESSING-CHECKER" # Specific assertion
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out # Logout after scenario

    Examples:
      | Customer Name    | Base Number |  # ... other relevant data for instruction creation ...
      | Test Customer 1 | 12345       |
      | Test Customer 2 | 67890       |



  @HK_GCM_TPP_No_QC_False
  Scenario Outline: Login as KL LOANS OPS - PROCESSING - CHECKER (Test Case ID: 3)
    # Preconditions: None
    When Login as "KL LOANS OPS - PROCESSING - CHECKER"
    Then User sees the welcome message "Welcome, KL LOANS OPS - PROCESSING - CHECKER" # Specific assertion
    Then sign Out # Logout after scenario

    Examples:
      | |

  @HK_GCM_TPP_No_QC_False
  Scenario Outline: Open the created instruction (Test Case ID: 4)
    # Preconditions: User is logged in as KL LOANS OPS - PROCESSING - CHECKER, Instruction exists
    Given Login as "KL LOANS OPS - PROCESSING - CHECKER"
    And WebAgent open "<instructionUrl>" url # Use saved instruction URL from Examples table
    Then Instruction details are displayed for instruction ID "<instructionId>" # More specific checkpoint
    Then sign Out # Logout after scenario

    Examples:
        | instructionUrl | instructionId |
        | @instructionUrl.Value | @instructionId.Value | # Assuming @instructionUrl and @instructionId are set in a previous scenario


  # ... (Similar scenarios for the remaining test cases 5-16, following the same structure) ...

  @HK_GCM_TPP_No_QC_False
  Scenario Outline: Verify PROCESS STATUS after return to PAYMENT-MAKER from PAYMENT-CHECKER (Test Case ID: 16)
    # Preconditions: Instruction returned to PAYMENT-MAKER by PAYMENT-CHECKER
    Given Login as "KL LOANS OPS - PROCESSING - PAYMENT MAKER"
    And WebAgent open "<instructionUrl>" url # Use saved instruction URL from Examples table
    When User returns instruction to PAYMENT-MAKER # Implement specific return action
    Then Process Status is "PAYMENT - MAKER" # Assert the expected status
    Then sign Out # Logout after scenario

    Examples:
        | instructionUrl |
        | @instructionUrl.Value | # Assuming @instructionUrl is set in a previous scenario


  # Example Step Definition (Adapt to your specific application and framework)
  When(/^Create HK GCM Instruction with Third Party Payment "([^"]*)" and QC Require "([^"]*)" and Customer Group "([^"]*)"$/) do |tpp, qc, customer_group|
    # Implement instruction creation logic here using the provided parameters
    # ... (Code to interact with the application UI or API) ...

    # Example: Setting fields based on parameters
    select_from_dropdown("thirdPartyPaymentDropdownlist", tpp)
    # ... set other fields similarly ...

    click_button("createButton") # Or appropriate action to create the instruction

    # Check for success message and store instruction ID and URL
    expect(page).to have_content("Instruction created successfully") # Or appropriate success message
    # ... (Code to extract and store instruction ID and URL) ...
  end

  Then(/^User sees the welcome message "([^"]*)"$/) do |welcome_message|
    expect(page).to have_content(welcome_message) # Or appropriate check for the welcome message
  end

  Then(/^Instruction details are displayed for instruction ID "([^"]*)"$/) do |instruction_id|
    expect(page).to have_content(instruction_id) # Or appropriate check for the instruction details
  end

  When(/^User returns instruction to PAYMENT-MAKER$/) do
    # Implement the specific steps to return the instruction in your application
    # ... (Code to interact with the application UI to return the instruction) ...
  end

  Then Close Browser # Ensure browser closure after each scenario