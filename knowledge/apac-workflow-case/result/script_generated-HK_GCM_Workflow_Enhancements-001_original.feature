Feature: HK GCM Workflow Enhancements

# Instruction Detail:
# 1) Author: Jevons
# 2) Transaction Type: 01 (New Drawdown)
# 3) Workflow: HK GCM
# 4) Check Point: E2E
# 5) Key Value: THIRD PARTY PAYMENT = Yes, QC REQUIRE = False

@HK_GCM_Workflow_Enhancements-001
Scenario Outline: HK_GCM_Workflow_Enhancements-001 Verify HK GCM Workflow enhancements for THIRD PARTY PAYMENT = Yes and QC REQUIRE = False

    # Preconditions: User is logged out of the system.

    # ***************************************************************
    # STEP 1: Processing Maker Create and Maker Submit
    # ***************************************************************
    # Open the application URL and login as processing maker of HK Loans
    Given WebAgent open "<URL>" url
    When Login as "SopsM_HK"

    # Navigate to Instruction Tab and switch platform to HK Loans
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Create New Instruction
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in Main Section
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "Yes" from thirdPartyPaymentDropdownlist  # Setting THIRD PARTY PAYMENT = Yes
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section
    And WebAgent type "GCM-TXN01-<TodayDate>-<RN6>" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO<RN6>" into baseNumberTextbox
    And Select "GCM" from customerGroupDropdownlist # GCM workflow only has GCM value
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "<TodayDate>" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist

    # ... (Remaining steps for data entry in other sections - follow the template)

    # Perform the action - Create and Maker Submit
    Then WebAgent click on createAndMakerSubmitButton

    # Check the success message and save Instruction ID and URL
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl

    # Sign Out
    Then sign Out


    # ***************************************************************
    # STEP 2: Processing Checker Submit to QC
    # ****************************************************************
    # ... (Follow the template for Checker actions)

    # ***************************************************************
    # STEP 3: Quality Controller Complete Drawdown QC
    # ***************************************************************
    # ... (Follow the template for QC actions)


    # ***************************************************************
    # STEP 4 - 7: Remaining Steps (Follow the template)
    # ***************************************************************
    # ... (Complete the remaining steps based on the template)


    Examples:
        | URL                     | TodayDate | RN6 | CUSTOMER GROUP | RNText | RNRate | RNAmount |
        | $xxx systemApacLoginPage | 2024-07-26 | 123 | GCM           | Test   | 1.234  | 10000   |