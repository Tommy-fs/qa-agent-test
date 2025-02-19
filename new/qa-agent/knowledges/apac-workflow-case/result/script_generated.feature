gherkin
Feature: HK GCM Workflow Enhancements

  Scenario Outline: InstructionLogic-002
    Given WebAgent open "XXX systemApacLoginPage" url
    When Login as "KL LOANS OPS - PROCESSING - MAKER"
    Then WebAgent is on InstructionTab
    And Switch Platform to "HK Loans"
    And WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds
    And Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "Yes" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist
    And WebAgent clear input control tenorTextbox
    And WebAgent type "10" into tenorTextbox
    And WebAgent type "$RN6" into facilityNumberTextbox
    And WebAgent type "LINK-$RN6" into linkLcuTextbox
    And Select "HKD" from loanCurrencyDropdownlist
    And WebAgent type "200,000,000.00" into bookingAmountTextbox
    And select "CHATS" from creditAccTypeDropdownlist
    And Select "Same Currency" from creditCurrencyTypepropdownlist
    And Select "YES FLOAT" from installmentDropdownlist
    And WebAgent type "2.12345" into clientAllInRateTextbox
    And WebAgent type "1.12345" into marginTextbox
    And Select "HIBOR" from marginDropdownlist
    And WebAgent type "1.67890" into costRateTextbox
    And WebAgent click on interestBasisRadio
    And Select "1M HIBOR" from rateCodeDropdownlist
    And WebAgent clear input control nextRepricingDateDatepickerTextbox
    And WebAgent type "$TodayDate" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "DBNO$RN6" into debitCustomerAcNoTextbox
    And WebAgent type "TRAN REMARK -$RNText" into tranRemarkTextarea
    And WebAgent type "ST45611" into rmorBackUpSoeId1Textbox
    And WebAgent type "PMIS-$RN6" into pmisTextbox
    And WebAgent type "TOUC-$RN6" into toucTextbox
    And WebAgent type "EXP MIS-$RN6" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist
    And WebAgent is on OperationTab
    And WebAgent click on operationTab
    And WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    And WebAgent click on 3ppBeneficiaryRadio
    And WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
    And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
    And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    And WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    And sign Out
    When Login as "KL LOANS OPS - PROCESSING - CHECKER"
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent click on editButton
    And WebAgent click on operationTab
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    And WebAgent check on pendingsightFundTickbox
    And WebAgent check on accValidationBookingTickbox
    And WebAgent check on accValidationRoLloverTickbox
    And WebAgent check on approvalRequiredTickbox
    And WebAgent check on miftCallReguiredTickbox
    And WebAgent check on obtainedByApprovalTickbox
    And WebAgent check on syndicationRateUpdatedTickbox
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
    And WebAgent click on submitButton
    And WebAgent click on submitToQCButton
    And WebAgent see successMsg
    And Sign Out

  Examples:
    | TodayDate | RN6  | RNText |
    | 2022-10-10 | 123456 | TestText |



This script corresponds to Test Case 1: InstructionLogic-002, which validates the "Submit to Payment" action under specific conditions. The script includes all necessary steps and parameters for execution.