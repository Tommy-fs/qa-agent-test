```gherkin
Feature: HK GCM Workflow

  @hkgcm
  Scenario Outline: HK_GCM_Workflow-001 Verify HK GCM Workflow when THIRD PARTY PAYMENT is Yes and COMPLETED DATE is blank.
    # Preconditions: User with KL LOANS OPS-PROCESSING -MAKER, KL LOANS OPS - PROCESSING -CHECKER, and KL LOANS OPS-PROCESSING-PAYMENT MAKER roles are available.

    # Step 1: Login system as KL LOANS OPS-PROCESSING -MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING -MAKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT: Yes
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
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
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

    # Step 3: Perform 'Maker Submit' action
    Then WebAgent is on OperationTab
    Then WebAgent click on operationTab
    Then WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    Then WebAgent click on 3ppBeneficiaryRadio
    Then WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out

    # Step 4: Verify available actions - Only 'Submit to Payment' action is available, 'Complete' action is disabled
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on operationTab
    Then WebAgent check on pendingsightFundTickbox
    Then WebAgent check on accValidationBookingTickbox
    Then WebAgent check on accValidationRoLloverTickbox
    Then WebAgent check on approvalRequiredTickbox
    Then WebAgent check on miftCallReguiredTickbox
    Then WebAgent check on obtainedByApprovalTickbox
    Then WebAgent check on syndicationRateUpdatedTickbox
    And Select "Approved" from approvalstatusDropdownlist
    And Select "Done Mift Call" from miftCallstatusDropdownlist
    And WebAgent type "$RN6" into batchNoTextbox
    And WebAgent type "$RN6" into batchEntriesCountTextbox
    And Select "Yes" from svsCheckerDropdownlist
    And WebAgent type "CRI REF -$RN6" into criRefTextbox
    And WebAgent type "Auto Approved -$RN6" into approvalByTextbox
    And WebAgent type "Approval Type -$RN6" into approvalTypeTextbox
    And WebAgent type "$RNRate" into linkageExchangeRateTextbox
    And WebAgent type "$RNAmount" into linkageLinkAmountTextbox
    And Select "PASS" from classificationCheckerDropdownlist
    # TODO: Add steps to verify that only 'Submit to Payment' action is available and 'Complete' action is disabled.  This requires custom step definitions to inspect the UI.
    Then sign Out

    # Step 5: Login system as KL LOANS OPS - PROCESSING -CHECKER
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab

    # Step 6: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Step 7: Perform 'Submit to Payment' action
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentButton
    And WebAgent see successMsg
    Then sign Out

    # Step 8: Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
    Then WebAgent is on PaymentTab

    # Step 9: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on paymentTab
    And Wait 5 seconds
    Then WebAgent type "PAYMENT NOTE - $RNText" into paymentNoteTextarea
    And WebAgent check on multiplecheckerRequiredTickbox
    And WebAgent type "RemiRefer - $RN6" into remittanceReferenceTextbox
    And Select "citiFT - RTGS" from remittanceSystemDropdownlist

    # Step 10: Verify available actions - 'Submit Payment Checker' and 'Return to KL LOANS OPS -PROCESSING -MAKER' actions are available
    # TODO: Add steps to verify that 'Submit Payment Checker' and 'Return to KL LOANS OPS -PROCESSING -MAKER' actions are available. This requires custom step definitions to inspect the UI.
    Then sign Out

    Examples:
      | CUSTOMER GROUP |
      | GCM            |

  @hkgcm
  Scenario Outline: HK_GCM_Workflow-002 Verify HK GCM Workflow when THIRD PARTY PAYMENT is Yes and COMPLETED DATE is not blank.
    # Preconditions: User with KL LOANS OPS-PROCESSING -MAKER, KL LOANS OPS - PROCESSING -CHECKER, and KL LOANS OPS-PROCESSING-PAYMENT MAKER roles are available.

    # Step 1: Login system as KL LOANS OPS-PROCESSING -MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING -MAKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT: Yes
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
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
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

    # Step 3: Perform 'Maker Submit' action
    Then WebAgent is on OperationTab
    Then WebAgent click on operationTab
    Then WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    Then WebAgent click on 3ppBeneficiaryRadio
    Then WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out

    # Step 4: Simulate system setting COMPLETED DATE
    # TODO: Add step to simulate setting the COMPLETED DATE. This requires a custom step definition.
    Given Set COMPLETED DATE to today

    # Step 5: Login system as KL LOANS OPS - PROCESSING -CHECKER
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab

    # Step 6: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on operationTab
    Then WebAgent check on pendingsightFundTickbox
    Then WebAgent check on accValidationBookingTickbox
    Then WebAgent check on accValidationRoLloverTickbox
    Then WebAgent check on approvalRequiredTickbox
    Then WebAgent check on miftCallReguiredTickbox
    Then WebAgent check on obtainedByApprovalTickbox
    Then WebAgent check on syndicationRateUpdatedTickbox
    And Select "Approved" from approvalstatusDropdownlist
    And Select "Done Mift Call" from miftCallstatusDropdownlist
    And WebAgent type "$RN6" into batchNoTextbox
    And WebAgent type "$RN6" into batchEntriesCountTextbox
    And Select "Yes" from svsCheckerDropdownlist
    And WebAgent type "CRI REF -$RN6" into criRefTextbox
    And WebAgent type "Auto Approved -$RN6" into approvalByTextbox
    And WebAgent type "Approval Type -$RN6" into approvalTypeTextbox
    And WebAgent type "$RNRate" into linkageExchangeRateTextbox
    And WebAgent type "$RNAmount" into linkageLinkAmountTextbox
    And Select "PASS" from classificationCheckerDropdownlist

    # Step 7: Verify available actions - Both 'Submit to Payment' and 'Complete' actions are available
    # TODO: Add steps to verify that both 'Submit to Payment' and 'Complete' actions are available. This requires custom step definitions to inspect the UI.
    Then sign Out

    # Step 8: Perform 'Submit to Payment' action
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentButton
    And WebAgent see successMsg
    Then sign Out

    # Step 9: Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
    Then WebAgent is on PaymentTab

    # Step 10: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on paymentTab
    And Wait 5 seconds
    Then WebAgent type "PAYMENT NOTE - $RNText" into paymentNoteTextarea
    And WebAgent check on multiplecheckerRequiredTickbox
    And WebAgent type "RemiRefer - $RN6" into remittanceReferenceTextbox
    And Select "citiFT - RTGS" from remittanceSystemDropdownlist

    # Step 11: Verify available actions - 'Submit Payment Checker' and 'Return to KL LOANS OPS -PROCESSING -MAKER' actions are available
    # TODO: Add steps to verify that 'Submit Payment Checker' and 'Return to KL LOANS OPS -PROCESSING -MAKER' actions are available. This requires custom step definitions to inspect the UI.
    Then sign Out

    # Step 12: Go back to step 6 and perform 'Complete' action instead of 'Submit to Payment'
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    Then WebAgent click on submitButton
    Then WebAgent click on completeButton
    And WebAgent see successMsg
    Then sign Out

    Examples:
      | CUSTOMER GROUP |
      | GCM            |

  @hkgcm
  Scenario Outline: HK_GCM_Workflow-003 Verify HK GCM Workflow when THIRD PARTY PAYMENT is No.
    # Preconditions: User with KL LOANS OPS-PROCESSING -MAKER and KL LOANS OPS - PROCESSING -CHECKER roles are available.

    # Step 1: Login system as KL LOANS OPS-PROCESSING -MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING -MAKER"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT: No
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "No" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
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

    # Step 3: Perform 'Maker Submit' action
    Then WebAgent is on OperationTab
    Then WebAgent click on operationTab
    Then WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    Then WebAgent click on 3ppBeneficiaryRadio
    Then WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out

    # Step 4: Login system as KL LOANS OPS - PROCESSING -CHECKER
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab

    # Step 5: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on operationTab
    Then WebAgent check on pendingsightFundTickbox
    Then WebAgent check on accValidationBookingTickbox
    Then WebAgent check on accValidationRoLloverTickbox
    Then WebAgent check on approvalRequiredTickbox
    Then WebAgent check on miftCallReguiredTickbox
    Then WebAgent check on obtainedByApprovalTickbox
    Then WebAgent check on syndicationRateUpdatedTickbox
    And Select "Approved" from approvalstatusDropdownlist
    And Select "Done Mift Call" from miftCallstatusDropdownlist
    And WebAgent type "$RN6" into batchNoTextbox
    And WebAgent type "$RN6" into batchEntriesCountTextbox
    And Select "Yes" from svsCheckerDropdownlist
    And WebAgent type "CRI REF -$RN6" into criRefTextbox
    And WebAgent type "Auto Approved -$RN6" into approvalByTextbox
    And WebAgent type "Approval Type -$RN6" into approvalTypeTextbox
    And WebAgent type "$RNRate" into linkageExchangeRateTextbox
    And WebAgent type "$RNAmount" into linkageLinkAmountTextbox
    And Select "PASS" from classificationCheckerDropdownlist

    # Step 6: Verify available actions - Only 'Complete' action is available, 'Submit to Payment' action is disabled
    # TODO: Add steps to verify that only 'Complete' action is available and 'Submit to Payment' action is disabled. This requires custom step definitions to inspect the UI.
    Then sign Out

    # Step 7: Perform 'Complete' action
    When Login as "KL LOANS OPS - PROCESSING -CHECKER"
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    Then WebAgent click on submitButton
    Then WebAgent click on completeButton
    And WebAgent see successMsg
    Then sign Out

    Examples:
      | CUSTOMER GROUP |
      | GCM            |

  @hkgcm
  Scenario Outline: HK_GCM_Workflow-004 Verify Payment Checker Actions and Return scenarios.
    # Preconditions: HK_GCM_Workflow-001 or HK_GCM_Workflow-002 has been executed, resulting in Process Status 'PAYMENT - MAKER'.

    # Step 1: Follow steps 1-7 from HK_GCM_Workflow-001 or HK_GCM_Workflow-002
    # Assuming HK_GCM_Workflow-001 or HK_GCM_Workflow-002 has been run and the instruction ID is stored in @instructionId and @instructionUrl

    # Step 2: Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER
    Given WebAgent open "$xxx systemApacLoginPage"url
    When Login as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
    Then WebAgent is on PaymentTab

    # Step 3: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on paymentTab
    And Wait 5 seconds
    Then WebAgent type "PAYMENT NOTE - $RNText" into paymentNoteTextarea
    And WebAgent check on multiplecheckerRequiredTickbox
    And WebAgent type "RemiRefer - $RN6" into remittanceReferenceTextbox
    And Select "citiFT - RTGS" from remittanceSystemDropdownlist

    # Step 4: Perform 'Submit Payment Checker' action
    Then WebAgent click on submitButton
    Then WebAgent click on submitToPaymentCheckerButton
    And WebAgent see successMsg
    Then sign Out

    # Step 5: Login system as KL LOANS OPS -PROCESSING - PAYMENT CHECKER
    When Login as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER"
    Then WebAgent is on PaymentTab

    # Step 6: Open the created instruction
    And WebAgent open "@instructionUrl.Value" url

    # Step 7: Verify available actions - 'Complete', 'Return to KL LOANS OPS -PROCESSING -MAKER', and 'Return to KL LOANS OPS -PROCESSING-PAYMENT MAKER' actions are available
    # TODO: Add steps to verify that 'Complete', 'Return to KL LOANS OPS -PROCESSING -MAKER', and 'Return to KL LOANS OPS -PROCESSING-PAYMENT MAKER' actions are available. This requires custom step definitions to inspect the UI.
    Then sign Out

    # Step 8: Perform 'Complete' action
    When Login as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER"
    Then WebAgent is on PaymentTab
    And WebAgent open "@instructionUrl.Value" url
    Then WebAgent click on submitButton
    Then WebAgent click on completeButton
    And WebAgent see successMsg
    Then sign Out

    # Step 9: Repeat steps 5-6
    When Login as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER"
    Then WebAgent is on PaymentTab
    And WebAgent open "@instructionUrl.Value" url

    # Step 10: Perform 'Return to KL LOANS OPS -PROCESSING -MAKER' action
    Then WebAgent click on returnButton
    Then Select "Return to KL LOANS OPS -PROCESSING -MAKER" from returnReasonDropdownlist
    And WebAgent type "Returning to Maker" into returnCommentsTextarea
    Then WebAgent click on confirmReturnButton
    And WebAgent see successMsg
    Then sign Out

    # Step 11: Repeat steps 5-6
    When Login as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER"
    Then WebAgent is on PaymentTab
    And WebAgent open "@instructionUrl.Value" url

    # Step 12: Perform 'Return to KL LOANS OPS -PROCESSING-PAYMENT MAKER' action
    Then WebAgent click on returnButton
    Then Select "Return to KL LOANS OPS -PROCESSING-PAYMENT MAKER" from returnReasonDropdownlist
    And WebAgent type "Returning to Payment Maker" into returnCommentsTextarea
    Then WebAgent click on confirmReturnButton
    And WebAgent see successMsg
    Then sign Out

    Examples:
      |  |
      |  |
```