# Feature: HK_GCM_Workflow_TPP_No_QC_False_Complete
# Test Case ID: 1
Feature: HK GCM Workflow - Third Party Payment No, QC False

  # Author: Bard
  # Priority: Critical
  # Summary: Validate HK GCM Workflow for THIRD PARTY PAYMENT = No, QC REQUIRE = False

  @HK_GCM_Workflow_TPP_No_QC_False_Complete
  Scenario Outline: Login and Create HK GCM Instruction

    # Test Case ID: 1
    # Step 1: Login system as KL LOANS OPS - PROCESSING - MAKER
    Given WebAgent open "$apacLoginPage" url
    When Login as "KL LOANS OPS - PROCESSING - MAKER"
    Then Login successful

    # Test Case ID: 2
    # Step 2: Create a new HK GCM Instruction
    When Create a new HK GCM Instruction with THIRD PARTY PAYMENT = "No" and QC REQUIRE = "False"
    Then Instruction created successfully with CURRENT STATUS = "KL LOANS OPS" and PROCESS STATUS = "KL LOANS - PROCESSING-CHECKER"

    Examples:
      | apacLoginPage | KL LOANS OPS - PROCESSING - MAKER |
      | <apacLoginPage> | <KL LOANS OPS - PROCESSING - MAKER> |


# Feature: HK_GCM_Workflow_TPP_No_QC_False_Complete
# Test Case ID: 3, 4, 5, 6
Feature: HK GCM Workflow - Complete Instruction

  # Author: Bard
  # Priority: Critical
  # Summary: Validate Complete action for HK GCM Workflow

  @HK_GCM_Workflow_TPP_No_QC_False_Complete
  Scenario Outline: Complete Instruction

    # Test Case ID: 3
    # Step 3: Login system as KL LOANS OPS - PROCESSING - CHECKER
    Given WebAgent open "$apacLoginPage" url
    When Login as "KL LOANS OPS - PROCESSING - CHECKER"
    Then Login successful

    # Test Case ID: 4
    # Step 4: Open the created instruction
    Given WebAgent open "$instructionUrl" url  # Assuming instructionUrl is stored from previous scenario
    Then Instruction opens successfully

    # Test Case ID: 5
    # Step 5: Verify available actions
    Then Only "Complete" action is available and "Submit to Payment" action is disabled

    # Test Case ID: 6
    # Step 6: Perform "Complete" action
    When WebAgent click on completeButton  # Assuming completeButton is the web element for "Complete" action
    Then Action successful with CURRENT STATUS = "COMPLETED", PROCESS STATUS = "COMPLETED", and COMPLETED DATE populated with today's date

    Examples:
      | apacLoginPage | instructionUrl |
      | <apacLoginPage> | <instructionUrl> |


#  New Step Definitions (if needed - replace placeholders with actual implementation)

#  These would be defined in a separate .java or .rb file depending on your Cucumber implementation.

#  Example Java Step Definitions:

#  @Given("WebAgent open {string} url")
#  public void webAgent_open_url(String url) {
#      driver.get(url);
#  }

#  @When("Login as {string}")
#  public void login_as(String user) {
#      // Implement login logic based on user role
#  }

#  @When("Create a new HK GCM Instruction with THIRD PARTY PAYMENT = {string} and QC REQUIRE = {string}")
#  public void create_hk_gcm_instruction(String thirdPartyPayment, String qcRequire) {
#      // Implement instruction creation logic
#  }

#  @Then("Only {string} action is available and {string} action is disabled")
#  public void verify_actions(String availableAction, String disabledAction) {
#      // Implement action verification logic
#  }

#  And so on for other steps...