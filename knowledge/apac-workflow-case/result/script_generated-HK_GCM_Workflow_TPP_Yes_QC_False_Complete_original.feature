Feature: HK GCM Workflow Enhancements

# Instruction Detail:
# 1) Author:Bard
# 2) Transaction Type: New Drawdown
# 3) Workflow: HK GCM
# 4) Check Point: E2E
# 5) Key Value: THIRD PARTY PAYMENT = Yes, QC REQUIRE = False

# Test Case ID: HK_GCM_Workflow_TPP_Yes_QC_False_Complete

@HK_GCM_Workflow
Scenario Outline: HK_GCM_Workflow_TPP_Yes_QC_False_Complete

    # Preconditions: User accounts for Processing Maker, Processing Checker, Payment Maker, Payment Checker, and Quality Controller are set up.

    # ***************************************************************
    # STEP 1: Processing Maker Create and Maker Submit
    # ***************************************************************
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "SopsM_HK"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Create New Instruction
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "Yes" from thirdPartyPaymentDropdownlist  # Setting Third Party Payment to Yes
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # ... (Remaining steps for data entry in Step 1 from the template)

    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out


    # ***************************************************************
    # STEP 2: Processing Checker Submit to QC
    # ****************************************************************
    # ... (Steps for Processing Checker from the template)


    # ***************************************************************
    # STEP 3: Quality Controller Complete Drawdown QC
    # ***************************************************************
    When Login as "SopsQC HK"
    Then WebAgent is on DrawdownTab
    And WebAgent open "@instructionUrl.Value" url # Using saved instruction URL
    And Wait 5 seconds

    Then WebAgent click on editButton
    Then WebAgent click on qcChecklistDrawdownTab

    # Set fields value in Drawdown QC Checklist section (from template)
    # ...

    Then WebAgent click on completeDrawdownoCButton # QC Completes Drawdown QC
    And WebAgent see successMsg
    Then Sign Out


    # ***************************************************************
    # STEP 4: Processing Checker Submit to Payment
    # ***************************************************************
    # ... (Steps for Processing Checker Submit to Payment from the template)


    # ***************************************************************
    # STEP 5: Payment Maker Submit to Payment Checker
    # ***************************************************************
    # ... (Steps for Payment Maker and Checker from the template)


    # ***************************************************************
    # STEP 6: Payment Checker Submit to QC
    # ***************************************************************
    # ... (Steps for Payment Checker Submit to QC from the template)


    # ***************************************************************
    # STEP 7: Quality Controller Complete Disbursement QC
    # **************************************************************
    # ... (Steps for Quality Controller Complete Disbursement QC from the template)


    Then Close Browser


    Examples:
        | CUSTOMER GROUP |
        | GCM           |