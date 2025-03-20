Feature: HK GCM Workflow Enhancements for THIRD PARTY PAYMENT = Yes, QC REQUIRE = False

    Instruction Detail:
    1) Author:Jevons
    2) Transaction Type: New Drawdown
    3) Workflow: HK GCM
    4) Check Point: E2E
    5) Key Value: THIRD PARTY PAYMENT = Yes, QC REQUIRE = False

    @HK_GCM_Workflow
    Scenario Outline: HK_GCM_Workflow_TPP_Yes_QC_False_Complete

        # Preconditions: User accounts for Processing Maker, Processing Checker, Payment Maker, Payment Checker, and Quality Controller are set up.  This should ideally be handled in a Background section or a Before hook.

        Background:
            Given User accounts are set up for "SopsM_HK", "SopsC_HK", "SopsPM_HK", "SopsPC_HK", and "SopsQC_HK"


        # ***************************************************************
        # STEP 1: Processing Maker (SopsM_HK) - Create and Maker Submit
        # ***************************************************************
        Given WebAgent opens the "$xxx systemApacLoginPage" url  # Processing Maker opens the login page
        When Processing Maker logs in as "SopsM_HK"
        Then WebAgent is on the InstructionTab  # Processing Maker is on the Instruction Tab
        Then Processing Maker switches platform to "HK Loans"

        # Create New Instruction
        Then Processing Maker clicks on the createButton
        And Processing Maker clicks on the newInstructionItem
        And Processing Maker waits 5 seconds

        # Set fields value in MainSection
        Then Processing Maker selects "New Drawdown" from the transactionTypeDropdownlist
        And Processing Maker selects "Short Term Fixed Rate" from the loanTypepropdownlist
        And Processing Maker selects "Yes" from the thirdPartyPaymentDropdownlist  # Setting Third Party Payment to Yes
        And Processing Maker selects "No" from the syndicatedLoanDropdownList
        And Processing Maker clicks on the workingCapitalNoRadio

        # Set fields value in General Information Section
        And Processing Maker types "GCM-TXN01-$TodayDate-$RN6" into the customerNameTextbox
        And Processing Maker clears the baseNumberTextbox
        And Processing Maker types "HKO$RN6" into the baseNumberTextbox
        And Processing Maker selects "<CUSTOMER GROUP>" from the customerGroupDropdownlist # GCM workflow only has GCM value
        And Processing Maker clears the valueDTDatepickerTextbox
        And Processing Maker types "$TodayDate" into the valueDTDatepickerTextbox
        And Processing Maker selects "PASS" from the classificationDropdownlist
        # ... (Remaining steps for data entry in Step 1 from the template - fill in all fields)

        Then Processing Maker clicks on the createAndMakerSubmitButton
        And WebAgent sees the success message containing "Instruction created successfully" # Specific assertion
        And Processing Maker saves the instruction ID and URL with prefix "LHK" from the success message into @instructionId and @instructionUrl
        Then Processing Maker signs out


        # ***************************************************************
        # STEP 2: Processing Checker (SopsC_HK) - Submit to QC
        # ****************************************************************
        # ... (Steps for Processing Checker from the template - fill in all fields and actions)


        # ***************************************************************
        # STEP 3: Quality Controller (SopsQC_HK) - Complete Drawdown QC
        # ***************************************************************
        # ... (Steps for Quality Controller Complete Drawdown QC from the template - fill in all fields and actions)


        # ***************************************************************
        # STEP 4: Processing Checker (SopsC_HK) - Submit to Payment
        # ***************************************************************
        # ... (Steps for Processing Checker Submit to Payment from the template - fill in all fields and actions)


        # ***************************************************************
        # STEP 5: Payment Maker (SopsPM_HK) - Submit to Payment Checker
        # ***************************************************************
        # ... (Steps for Payment Maker and Checker from the template - fill in all fields and actions)


        # ***************************************************************
        # STEP 6: Payment Checker (SopsPC_HK) - Submit to QC
        # ***************************************************************
        # ... (Steps for Payment Checker Submit to QC from the template - fill in all fields and actions)


        # ***************************************************************
        # STEP 7: Quality Controller (SopsQC_HK) - Complete Disbursement QC
        # **************************************************************
        # ... (Steps for Quality Controller Complete Disbursement QC from the template - fill in all fields and actions)


        Then WebAgent closes the browser

        Examples:
            | CUSTOMER GROUP | TodayDate  | RN6 | RNText | RNRate | RNAmount |  # Include all example data
            | GCM           | 2024-07-26 | 123 | Test   | 1.234  | 10000   |  # Provide realistic example values