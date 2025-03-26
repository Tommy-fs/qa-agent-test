```gherkin
Feature: HongKong GCM Workflow

  Instruction Detail:
    1) Author: [Your Name]
    2) Workflow: HK GCM
    3) THIRD PARTY PAYMENT: Yes
    4) QC REQUIRE: True
    5) Check Point: E2E

  @hkgcm
  Scenario Outline: HK_GCM_Workflow-001 Verify HK GCM Workflow with THIRD PARTY PAYMENT=Yes and QC REQUIRE=True

    # Preconditions:
    # The system should be in a clean state.
    # User accounts with appropriate roles (SopsM_HK, SopsC_HK, SopsQC_HK, opsPM_HK, SopsPC_HK) should be available.

    # ***************************************************************
    # STEP 1: Processing Maker Create and Maker Submit
    # ***************************************************************
    # open the application url and login as processing maker of HK Loans
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "SopsM_HK"

    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab

    # Switch Platform to HK Loans
    Then Switch Platform to "HK Loans"

    # Create New Instruction(Mandatory)
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "Yes" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN01-<TodayDate>-<RN6>" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO<RN6>" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "<TodayDate>" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist

    # Set fields value in MATURITY DT Section(Mandatory)
    And WebAgent clear input control tenorTextbox
    And WebAgent type "10" into tenorTextbox
    And WebAgent type "<RN6>" into facilityNumberTextbox
    And WebAgent type "LINK-<RN6>" into linkLcuTextbox

    # Set fields value in Loans Detail Section(Mandatory)
    And Select "HKD" from loanCurrencyDropdownlist
    And WebAgent type "200,000,000.00" into bookingAmountTextbox
    And select "CHATS" from creditAccTypeDropdownlist
    And Select "Same Currency" from creditCurrencyTypepropdownlist
    And Select "YES FLOAT" from installmentDropdownlist

    # Set fields value in Interest Rate,Cost Rate and Funding Section(Mandatory)
    And WebAgent type "2.12345" into clientAllInRateTextbox
    And WebAgent type "1.12345" into marginTextbox
    And Select "HIBOR" from marginDropdownlist
    And WebAgent type "1.67890" into costRateTextbox
    Then WebAgent click on interestBasisRadio
    And Select "1M HIBOR" from rateCodeDropdownlist
    And WebAgent clear input control nextRepricingDateDatepickerTextbox
    And WebAgent type "<TodayDate>" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "DBNO<RN6>" into debitCustomerAcNoTextbox

    # Set fields value in Additional Remark Section(Mandatory)
    Then WebAgent type "TRAN REMARK - <RNText>" into tranRemarkTextarea
    And WebAgent type "ST45611" into rmorBackUpSoeId1Textbox
    And WebAgent type "PMIS-<RN6>" into pmisTextbox
    And WebAgent type "TOUC-<RN6>" into toucTextbox
    And WebAgent type "EXP MIS-<RN6>" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist

    # Set fields value in IMR Details Section(Mandatory)
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist

    # Switch to Operation Tab(Mandatory)
    Then WebAgent is on OperationTab

    # Indicate the blow actions repository is on Operation Tab(Mandatory)
    Then WebAgent click on operationTab

    # Set fields value in Operation Status Section(Mandatory)
    Then WebAgent type "PENDING REMARK <RNText>" into pendingRemarkTextarea
    And WebAgent check on kivTickbox

    # Set fields value in Checklist Section(Mandatory)
    Then WebAgent click on 3ppBeneficiaryRadio

    # Set fields value in Operation details Section(Mandatory)
    Then WebAgent type "PROCESS NOTE <RNText>" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-<RN6>" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-<RN6>" into newCustomReferenceNoTextbox

    # Set fields value in Booking Section(Mandatory)
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist

    # Perform the action -Create and Maker Submit(Mandatory)
    Then WebAgent click on createAndMakerSubmitButton

    # Check the success message to confirm the instruction is created successfully and get the Instruction ID
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl

    # Sign Out the system
    Then sign Out

    # ***************************************************************
    # STEP 2: Processing Checker Submit to QC
    # ****************************************************************

    # Login as Processing Checker of Hk Loans
    When Login as "SopsC HK"

    # Indicate the below actions repository is on Operation Tab
    Then WebAgent is on OperationTab

    # Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" url

    # Check the warning message and wait for 5 seconds
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds

    # Edit the instruction and click on Operation Tab
    Then WebAgent click on editButton
    Then WebAgent click on operationTab

    # Set fields value in Checklist Section
    Then WebAgent check on pendingsightFundTickbox
    Then WebAgent check on accValidationBookingTickbox
    Then WebAgent check on accValidationRoLloverTickbox
    Then WebAgent check on approvalRequiredTickbox
    Then WebAgent check on miftCallReguiredTickbox
    Then WebAgent check on obtainedByApprovalTickbox
    Then WebAgent check on syndicationRateUpdatedTickbox
    And Select "Approved" from approvalstatusDropdownlist
    And Select "Done Mift Call" from miftCallstatusDropdownlist

    # Set fields value in Operation details
    And WebAgent type "<RN6>" into batchNoTextbox
    And WebAgent type "<RN6>" into batchEntriesCountTextbox
    And Select "Yes" from svsCheckerDropdownlist

    # Set fields value in Approval Details
    And WebAgent type "CRI REF -<RN6>" into criRefTextbox
    And WebAgent type "Auto Approved -<RN6>" into approvalByTextbox
    And WebAgent type "Approval Type -<RN6>" into approvalTypeTextbox

    # Set fields value in Linkage
    And WebAgent type "<RNRate>" into linkageExchangeRateTextbox
    And WebAgent type "<RNAmount>" into linkageLinkAmountTextbox

    # Set fields value in Booking
    And Select "PASS" from classificationCheckerDropdownlist

    # Perform the action- Submit to QC
    Then WebAgent click on submitButton
    Then WebAgent click on submitToQCButton

    # Check the success message:to confirm the action is successful
    And WebAgent see successMsg

    # Sign Out the system
    Then Sign Out

    # ***************************************************************
    # STEP 3: Quality Controller Complete Drawdown QC
    # ***************************************************************

    # Login as Quality Controller of HK Loans
    When Login as "SopsQC HK"

    # Indicate the below actions repository is on Drawdown Tab
    Then WebAgent is on DrawdownTab

    # Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds

    # Edit the instruction and click on Drawdown Tab
    Then WebAgent click on editButton
    Then WebAgent click on qcChecklistDrawdownTab

    # Set fields value in Drawdown 0c Checklist section
    Then WebAgent type " identification -<RNText>" into drawdownIdentificationQCTextarea
    And WebAgent type "Facility Details <RNText>" into drawdownFacilityQCTextarea
    And WebAgent type "Drawdown Details <RNText>" into drawdownApprovaloCTextarea
    And WebAgent type "Approval -<RNText>" into drawdownSupportingQCTextarea
    And WebAgent type "Supporting Documents Details <RNText>" into drawdownDetailsQCTextarea
    Then WebAgent click on drawdownIdentificationocstatusRadio
    Then WebAgent click on drawdownFacilityocstatusRadio
    Then WebAgent click on drawdownDetailsocStatusRadio
    Then WebAgent click on drawdownApprovalocstatusRadio
    Then WebAgent click on drawdownSupportingQcStatusRadio

    # Perform the action -Complete Drawdown 0
    Then WebAgent click on completeDrawdownoCButton

    # Check the success message to confirm the action is successful
    And WebAgent see successMsg

    # Sign Out the system
    Then Sign Out

    # ***************************************************************
    # STEP 4: Processing Checker Submit to Payment
    # ***************************************************************

    # Login as Processing Checker of Hk Loans
    When Login as "SopsC HK"

    # Indicate the below actions repository is on Operation Tab
    Then WebAgent is on OperationTab

    # Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds

    # Perform the action - Submit to Payment
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentButton

    # Check the success message to confirm the action is successful
    And WebAgent see successMsg

    # Sign Out the system
    Then sign Out

    # ***************************************************************
    # STEP 5: Payment Maker Submit to Payment Checker
    # ***************************************************************

    # Login as Payment Maker of HK Loans
    When Login as "SopsPM HK"

    # Indicate the below actions repository is on Payment Tab
    Then WebAgent is on PaymentTab

    # Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds

    # Edit the instruction and click on Payment Tab
    Then WebAgent click on editButton
    Then WebAgent click on paymentTab
    And Wait 5 seconds

    # Set fields value in Payment Details Section
    Then WebAgent type "PAYMENT NOTE - <RNText>" into paymentNoteTextarea
    And WebAgent check on multiplecheckerRequiredTickbox
    And WebAgent type "RemiRefer - <RN6>" into remittanceReferenceTextbox
    And Select "citiFT - RTGS" from remittanceSystemDropdownlist

    # Perform the action - Submit to Payment cheker
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentCheckerButton

    # Check the success message confirm the action is successful
    And WebAgent see successMsg

    # Sign Out the system
    Then sign Out

    # ***************************************************************
    # STEP 6: Payment Checker Submit to QC
    # ***************************************************************

    # Login as Payment Checker of HK Loans
    When Login as "SopsPC HK"

    # Indicate the below actions repository is on Payment Tab
    Then WebAgent is on PaymentTab

    # Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" url

    # Check the warning message and wait for 5 seconds
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds

    # Edit the instruction and click on Payment Tab
    Then WebAgent click on editButton
    Then WebAgent click on paymentTab
    And Wait 5 seconds

    # Perform the action - Submit to QC
    Then WebAgent click on submitButton
    And Wait 5 seconds
    Then WebAgent click on submitToQCButton

    # Check the success message to confirm the action is successful
    And WebAgent see successMsg

    # Sign Out the system
    Then Sign Out

    # ***************************************************************
    # STEP 7: Quality Controller Complete Disbursement QC
    # **************************************************************

    # Login as Quality Controller of HK Loans
    When Login as "SopsQC HK"

    # Indicate the below actions repository is on Disbursement Tab
    Then WebAgent is on DisbursementTab

    # Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds

    # Edit the instruction and click on Disbursement Tab
    Then WebAgent click on editButton
    Then WebAgent click on qcChecklistDisbursementTab
    And Wait 5 seconds

    # Set fields value in Disbursment 0c Checklist section
    Then WebAgent click on disbursementIdentificationocstatusRadio
    Then WebAgent click on disbursementMIFTQCStatusRadio
    Then WebAgent click on disbursementDetailsQcStatusRadio
    Then WebAgent click on disbursementApprovalocstatusRadio
    Then WebAgent type "Identification <RNText>" into disbursementIdentificationQCTextarea
    Then WebAgent type "Disbursement Checking For Bilateral -<RNText>" into disbursementCheckingQCTextarea
    Then WebAgent type "Disbursement Details in Payment System-<RNText>" into disbursementDetailsQCTextarea
    Then WebAgent type "Approval -<RNText>" into disbursementApprovalQCTextarea
    And Select "Yes" from sanctionHitsDropdownlist
    And Wait 5 seconds

    # Perform the action - complete
    Then WebAgent click on completeButton
    And Wait 5 seconds

    # Check the success message to confirm the action is successful
    And WebAgent see successMsg

    # Sign Out the system
    Then Sign Out

    Then Close Browser

    Examples:
      | CUSTOMER_GROUP | TodayDate  | RN6  | RNText | RNRate | RNAmount |
      | GCM            | 2024-01-26 | 123456 | ABCDEF | 1.2345 | 1000.00 |
```