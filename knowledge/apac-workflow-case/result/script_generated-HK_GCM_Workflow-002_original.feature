```gherkin
Feature: HK GCM Workflow

  @HK_GCM_Workflow-002
  Scenario Outline: Verify HK GCM Workflow with THIRD PARTY PAYMENT=No and QC REQUIRE=False

    # Preconditions: User must have valid credentials for each role.

    # Test Case ID: 1
    # Step 1: Login as KL LOANS OPS-PROCESSING-MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-MAKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 2
    # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT = Yes, QC REQUIRE = True, other fields filled as required
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "No" from thirdPartyPaymentDropdownlist
    And Select "Yes" from qcRequireDropdownlist
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN02-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist

    # Set fields value in MATURITY DT Section(Mandatory)
    And WebAgent clear input control tenorTextbox
    And WebAgent type "10" into tenorTextbox
    And WebAgent type "$RN6" into facilityNumberTextbox
    And WebAgent type "LINK-$RN6" into linkLcuTextbox

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
    And WebAgent type "$TodayDate" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "DBNO$RN6" into debitCustomerAcNoTextbox

    # Set fields value in Additional Remark Section(Mandatory)
    Then WebAgent type "TRAN REMARK -$RNText" into tranRemarkTextarea
    And WebAgent type "ST45611" into rmorBackUpSoeId1Textbox
    And WebAgent type "PMIS-$RN6" into pmisTextbox
    And WebAgent type "TOUC-$RN6" into toucTextbox
    And WebAgent type "EXP MIS-$RN6" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist

    # Set fields value in IMR Details Section(Mandatory)
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist

    # Switch to Operation Tab(Mandatory)
    Then WebAgent is on OperationTab
    #Indicate the blow actions repository is on Operation Tab(Mandatory)
    Then WebAgent click on operationTab

    # Set fields value in Operation Status Section(Mandatory)
    Then WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
    And WebAgent check on kivTickbox

    # Set fields value in Checklist Section(Mandatory)
    Then WebAgent click on 3ppBeneficiaryRadio

    # Set fields value in Operation details Section(Mandatory)
    Then WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox

    # Set fields value in Booking Section(Mandatory)
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist

    # Perform the action -Create and Maker Submit(Mandatory)
    Then WebAgent click on createAndMakerSubmitButton

    # Check the success message to confirm the instruction is created successfully and get the Instruction ID
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl

    # Expected Result: Instruction created successfully. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = KL LOANS - PROCESSING-CHECKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 3
    # Step 3: Perform 'Maker Submit' action
    # Login as KL LOANS OPS-PROCESSING-MAKER
    When Login as "KL LOANS OPS-PROCESSING-MAKER"
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    # Perform the action - Maker Submit
    Then WebAgent click on makerSubmitButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = KL LOANS - PROCESSING-CHECKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 4
    # Step 4: Login as KL LOANS OPS-PROCESSING-CHECKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-CHECKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 5
    # Step 5: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Test Case ID: 6
    # Step 6: Perform 'Submit to QC' action
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
    And WebAgent type "$RN6" into batchNoTextbox
    And WebAgent type "$RN6" into batchEntriesCountTextbox
    And Select "Yes" from svsCheckerDropdownlist

    # Set fields value in Approval Details
    And WebAgent type "CRI REF -$RN6" into criRefTextbox
    And WebAgent type "Auto Approved -$RN6" into approvalByTextbox
    And WebAgent type "Approval Type -$RN6" into approvalTypeTextbox

    # Set fields value in Linkage
    And WebAgent type "$RNRate" into linkageExchangeRateTextbox
    And WebAgent type "$RNAmount" into linkageLinkAmountTextbox

    # Set fields value in Booking
    And Select "PASS" from classificationCheckerDropdownlist

    # Perform the action- Submit to QC
    Then WebAgent click on submitButton
    Then WebAgent click on submitToQCButton

    #Check the success message:to confirm the action is successful
    And WebAgent see successMsg

    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = DRAWDOWN-QC
    # Sign Out the system
    Then Sign Out

    # Test Case ID: 7
    # Step 7: Login as QC
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "QC"
    Then WebAgent is on DrawdownTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 8
    # Step 8: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds

    # Expected Result: Instruction opens successfully

    # Test Case ID: 9
    # Step 9: Perform 'Complete Drawdown QC' action
    Then WebAgent click on editButton
    Then WebAgent click on qcChecklistDrawdownTab

    # Set fields value in Drawdown 0c Checklist section
    Then WebAgent type " identification -$RNText" into drawdownIdentificationQCTextarea
    And WebAgent type "Facility Details $RNText" into drawdownFacilityQCTextarea
    And WebAgent type "Drawdown Details $RNText" into drawdownApprovaloCTextarea
    And WebAgent type "Approval -$RNText" into drawdownSupportingQCTextarea
    And WebAgent type "Supporting Documents Details $RNText" into drawdownDetailsQCTextarea
    Then WebAgent click on drawdownIdentificationocstatusRadio
    Then WebAgent click on drawdownFacilityocstatusRadio
    Then WebAgent click on drawdownDetailsocStatusRadio
    Then WebAgent click on drawdownApprovalocstatusRadio
    Then WebAgent click on drawdownSupportingQcStatusRadio

    # Perform the action -Complete Drawdown 0
    Then WebAgent click on completeDrawdownoCButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg

    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = PROCESSING-CHECKER-QC CHECKED
    # Sign Out the system
    Then Sign Out

    # Test Case ID: 10
    # Step 10: Perform 'Return' action
    # Login as QC
    When Login as "QC"
    # Indicate the below actions repository is on Drawdown Tab
    Then WebAgent is on DrawdownTab
    # Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    # Perform the action - Return
    Then WebAgent click on returnButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = PROCESSING-MAKER-MANUAL
    # Sign Out the system
    Then Sign Out

    # Test Case ID: 11
    # Step 11: Login as KL LOANS OPS-PROCESSING-MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-MAKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 12
    # Step 12: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Test Case ID: 13
    # Step 13: Perform 'Maker Submit' action
    # Perform the action - Maker Submit
    Then WebAgent click on editButton
    Then WebAgent click on makerSubmitButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = KL LOANS - PROCESSING-CHECKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 14
    # Step 14: Login as KL LOANS OPS-PROCESSING-CHECKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-CHECKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 15
    # Step 15: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Test Case ID: 16
    # Step 16: Verify available actions with THIRD PARTY PAYMENT = Yes, COMPLETED DATE = blank
    # Verify available actions
    Then Verify Action 'Submit to Payment' available
    And Verify Action 'Complete' disabled
    # Expected Result: Action 'Submit to Payment' available, Action 'Complete' disabled

    # Test Case ID: 17
    # Step 17: Perform 'Submit to Payment' action
    # Perform the action - Submit to Payment
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. PROCESS STATUS = PAYMENT - MAKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 18
    # Step 18: Login as KL LOANS OPS-PROCESSING-PAYMENT MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
    Then WebAgent is on PaymentTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 19
    # Step 19: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Test Case ID: 20
    # Step 20: Perform 'Submit Payment Checker' action
    # Perform the action - Submit to Payment Checker
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentCheckerButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. PROCESS STATUS = PAYMENT-CHECKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 21
    # Step 21: Login as KL LOANS OPS-PROCESSING-PAYMENT CHECKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT CHECKER"
    Then WebAgent is on PaymentTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 22
    # Step 22: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Test Case ID: 23
    # Step 23: Perform 'Complete' action
    # Perform the action - Complete
    Then WebAgent click on completeButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. CURRENT STATUS = COMPLETED, PROCESS STATUS = COMPLETED, COMPLETED DATE populated with today's date
    # Sign Out the system
    Then sign Out

    # Test Case ID: 24
    # Step 24: Login as KL LOANS OPS-PROCESSING-CHECKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-CHECKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Test Case ID: 25
    # Step 25: Create a new HK GCM Instruction with THIRD PARTY PAYMENT = Yes, QC REQUIRE = True, other fields filled as required
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "No" from thirdPartyPaymentDropdownlist
    And Select "Yes" from qcRequireDropdownlist
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN03-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist

    # Set fields value in MATURITY DT Section(Mandatory)
    And WebAgent clear input control tenorTextbox
    And WebAgent type "10" into tenorTextbox
    And WebAgent type "$RN6" into facilityNumberTextbox
    And WebAgent type "LINK-$RN6" into linkLcuTextbox

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
    And WebAgent type "$TodayDate" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "DBNO$RN6" into debitCustomerAcNoTextbox

    # Set fields value in Additional Remark Section(Mandatory)
    Then WebAgent type "TRAN REMARK -$RNText" into tranRemarkTextarea
    And WebAgent type "ST45611" into rmorBackUpSoeId1Textbox
    And WebAgent type "PMIS-$RN6" into pmisTextbox
    And WebAgent type "TOUC-$RN6" into toucTextbox
    And WebAgent type "EXP MIS-$RN6" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist

    # Set fields value in IMR Details Section(Mandatory)
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist

    # Switch to Operation Tab(Mandatory)
    Then WebAgent is on OperationTab
    #Indicate the blow actions repository is on Operation Tab(Mandatory)
    Then WebAgent click on operationTab

    # Set fields value in Operation Status Section(Mandatory)
    Then WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
    And WebAgent check on kivTickbox

    # Set fields value in Checklist Section(Mandatory)
    Then WebAgent click on 3ppBeneficiaryRadio

    # Set fields value in Operation details Section(Mandatory)
    Then WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox

    # Set fields value in Booking Section(Mandatory)
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist

    # Perform the action -Create and Maker Submit(Mandatory)
    Then WebAgent click on createAndMakerSubmitButton

    # Check the success message to confirm the instruction is created successfully and get the Instruction ID
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl

    # Expected Result: Instruction created successfully. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = KL LOANS - PROCESSING-CHECKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 26
    # Step 26: Repeat steps 3-9
    # Step 3: Perform 'Maker Submit' action
    # Login as KL LOANS OPS-PROCESSING-MAKER
    When Login as "KL LOANS OPS-PROCESSING-MAKER"
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    # Perform the action - Maker Submit
    Then WebAgent click on makerSubmitButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = KL LOANS - PROCESSING-CHECKER
    # Sign Out the system
    Then sign Out

    # Step 4: Login as KL LOANS OPS-PROCESSING-CHECKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-CHECKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Step 5: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Step 6: Perform 'Submit to QC' action
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
    And WebAgent type "$RN6" into batchNoTextbox
    And WebAgent type "$RN6" into batchEntriesCountTextbox
    And Select "Yes" from svsCheckerDropdownlist

    # Set fields value in Approval Details
    And WebAgent type "CRI REF -$RN6" into criRefTextbox
    And WebAgent type "Auto Approved -$RN6" into approvalByTextbox
    And WebAgent type "Approval Type -$RN6" into approvalTypeTextbox

    # Set fields value in Linkage
    And WebAgent type "$RNRate" into linkageExchangeRateTextbox
    And WebAgent type "$RNAmount" into linkageLinkAmountTextbox

    # Set fields value in Booking
    And Select "PASS" from classificationCheckerDropdownlist

    # Perform the action- Submit to QC
    Then WebAgent click on submitButton
    Then WebAgent click on submitToQCButton

    #Check the success message:to confirm the action is successful
    And WebAgent see successMsg

    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = DRAWDOWN-QC
    # Sign Out the system
    Then Sign Out

    # Step 7: Login as QC
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "QC"
    Then WebAgent is on DrawdownTab
    Then Switch Platform to "HK Loans"

    # Step 8: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds

    # Expected Result: Instruction opens successfully

    # Step 9: Perform 'Complete Drawdown QC' action
    Then WebAgent click on editButton
    Then WebAgent click on qcChecklistDrawdownTab

    # Set fields value in Drawdown 0c Checklist section
    Then WebAgent type " identification -$RNText" into drawdownIdentificationQCTextarea
    And WebAgent type "Facility Details $RNText" into drawdownFacilityQCTextarea
    And WebAgent type "Drawdown Details $RNText" into drawdownApprovaloCTextarea
    And WebAgent type "Approval -$RNText" into drawdownSupportingQCTextarea
    And WebAgent type "Supporting Documents Details $RNText" into drawdownDetailsQCTextarea
    Then WebAgent click on drawdownIdentificationocstatusRadio
    Then WebAgent click on drawdownFacilityocstatusRadio
    Then WebAgent click on drawdownDetailsocStatusRadio
    Then WebAgent click on drawdownApprovalocstatusRadio
    Then WebAgent click on drawdownSupportingQcStatusRadio

    # Perform the action -Complete Drawdown 0
    Then WebAgent click on completeDrawdownoCButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg

    # Expected Result: Action successful. CURRENT STATUS = KL LOANS OPS, PROCESS STATUS = PROCESSING-CHECKER-QC CHECKED
    # Sign Out the system
    Then Sign Out

    # Test Case ID: 27
    # Step 27: Perform 'Submit to Payment' action
    # Login as Processing Checker of Hk Loans
    When Login as "KL LOANS OPS-PROCESSING-CHECKER"
    # Indicate the below actions repository is on Operation Tab
    Then WebAgent is on OperationTab# Open the URL of Instruction
    And WebAgent open "@instructionUrl.Value" urlAnd Wait 5 seconds
    # Perform the action - Submit to Payment
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentButton
    # Check the success messageto confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. PROCESS STATUS = PAYMENT - MAKER
    # Sign Out the system
    Then sign Out

    # Test Case ID: 28
    # Step 28: Repeat steps 18-22
    # Step 18: Login as KL LOANS OPS-PROCESSING-PAYMENT MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
    Then WebAgent is on PaymentTab
    Then Switch Platform to "HK Loans"

    # Step 19: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Step 20: Perform 'Submit Payment Checker' action
    # Perform the action - Submit to Payment Checker
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentCheckerButton
    # Check the success message to confirm the action is successful
    And WebAgent see successMsg
    # Expected Result: Action successful. PROCESS STATUS = PAYMENT-CHECKER
    # Sign Out the system
    Then sign Out

    # Step 21: Login as KL LOANS OPS-PROCESSING-PAYMENT CHECKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT CHECKER"
    Then WebAgent is on PaymentTab
    Then Switch Platform to "HK Loans"

    # Step 22: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Expected Result: Instruction opens successfully

    # Test Case ID: 29
    # Step 29: Verify available actions with THIRD PARTY PAYMENT = Yes, COMPLETED DATE != blank
    # Verify available actions
    Then Verify Action 'Submit to Payment' available
    And Verify Action 'Complete' available
    # Expected Result: Actions 'Submit to Payment' and 'Complete' available

    Then Close Browser

    Examples:
      | CUSTOMER GROUP |
      | GCM            |
```