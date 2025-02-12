Feature:HongKong
    Instruction Detail:
    1) Author:Jevons
    2) Transaction Type:01 (New Drawdown)
    3) Workflow:HK GCM
    4) Check Point:E2E
    5) Key Value:

    @apacinstruction
    Scenario Outline:C162742-3889 HK GCM

        # ***************************************************************
        # STEP 1:Processing Maker Create and Maker Submit
        # ***************************************************************
        Given WebAgent open "$xxx systemApacLoginPage"url
        When Login as "SopsM_HK"
        Then WebAgent is on InstructionTab
        Then Switch Platform to "HK Loans"
        Then WebAgent cLick on reportItemMenu

        Then WebAgent click on createButton
        And WebAgent click on newInstructionItem
        And Wait 5 seconds

        # Main Section
        Then Select "New Drawdown" from transactionTypeDropdownlist
        And Select "Short Term Fixed Rate" from loanTypepropdownlist
        And Select "Yes" from thirdPartyPaymentDropdownlist
        And Select "No" from syndicatedLoanDropdownList
        And WebAgent click on workingCapitalNoRadio

        # General Information
        And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
        And WebAgent clear input control baseNumberTextbox
        And WebAgent type "HKO$RN6" into baseNumberTextbox
        And Select "<CUSTOMER GROUP>" from customerGroupDropdownlist GCM workflow only has GCM vaLue
        And WebAgent clear input control valueDTDatepickerTextbox
        And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
        And Select "PASS" from classificationDropdownlist

        # MATURITY DT
        And WebAgent clear input control tenorTextbox
        And WebAgent type "10" into tenorTextbox
        And WebAgent type "$RN6" into facilityNumberTextbox
        And WebAgent type "LINK-$RN6" into linkLcuTextbox
        And Select "HKD" from loanCurrencyDropdownlist
        And WebAgent type "200,000,000.00" into bookingAmountTextbox
        And select "CHATS" from creditAccTypeDropdownlist
        And Select "Same Currency" from creditCurrencyTypepropdownlist
        And Select "YES FLOAT" from installmentDropdownlist

        # Interest Rate,Cost Rate and Funding
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

        # Additional Remark
        Then WebAgent type "TRAN REMARK -$RNText" into tranRemarkTextarea
        And WebAgent type "ST45611" into rmorBackUpSoeId1Textbox
        And WebAgent type "PMIS-$RN6" into pmisTextbox
        And WebAgent type "TOUC-$RN6" into toucTextbox
        And WebAgent type "EXP MIS-$RN6" into expMisTextbox
        # Ignore Weekend will show according to date
        And WebAgent check on ignoreWeekendTickbox if exist

        # IMR Details
        And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
        And Select "0 - Other" from loanPurposepropdownlist
        And Select "Use in HK" from countryLoanUsedDropdownlist

        # Switch to Operation Tab
        Then WebAgent is on OperationTab
        Then WebAgent click on operationTab

        # Operation Status
        Then WebAgent type "PENDING REMARK $RNText" into pendingRemarkTextarea
        And WebAgent check on kivTickbox

        # Checklist
        Then WebAgent click on 3ppBeneficiaryRadio

        # Operation details
        Then WebAgent type "PROCESS NOTE $RNText" into processingNoteTextarea
        And WebAgent type "New-Contract-Ref-$RN6" into newContractReferenceNoTextbox
        And WebAgent type "New-Custom-Ref-$RN6" into newCustomReferenceNoTextbox

        # Booking
        And Select "Yes" from svsMakerDropdownlist
        And Select "AT" from atorotDropdownlist
        And Select "PASS" from classificationMakerDropdownlist
        Then WebAgent click on createAndMakerSubmitButton

        And WebAgent see successMsg
        And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
        Then sign Out

        # ***************************************************************
        # STEP 2:Processing Checker Submit to QC
        # ****************************************************************
        When Login as "SopsC HK"
        Then WebAgent is on OperationTab
        And Switch PLatform to "HK Loans"
        And WebAgent open "@instructionUrl.Value" url
        And WebAgent check on qcWarningMessage if exist
        And Wait 5 seconds
        Then WebAgent click on editButton
        Then WebAgent click on operationTab
        # Checklist
        Then WebAgent check on pendingsightFundTickbox
        Then WebAgent check on accValidationBookingTickbox
        Then WebAgent check on accValidationRoLloverTickbox
        Then WebAgent check on approvalRequiredTickbox
        Then WebAgent check on miftCallReguiredTickbox
        Then WebAgent check on obtainedByApprovalTickbox
        Then WebAgent check on syndicationRateUpdatedTickbox
        And Select "Approved" from approvalstatusDropdownlist
        And Select "Done Mift Call" from miftCallstatusDropdownlist

        # Operation details
        And WebAgent type "$RN6" into batchNoTextbox
        And WebAgent type "$RN6" into batchEntriesCountTextbox
        And Select "Yes" from svsCheckerDropdownlist

        # Approval Details
        And WebAgent type "CRI REF -$RN6" into criRefTextbox
        And WebAgent type "Auto Approved -$RN6" into approvalByTextbox
        And WebAgent type "Approval Type -$RN6" into approvalTypeTextbox

        # Linkage
        And WebAgent type "$RNRate" into linkageExchangeRateTextbox
        And WebAgent type "$RNAmount" into linkageLinkAmountTextbox

        # Booking
        And Select "PASS" from classificationCheckerDropdownlist
        Then WebAgent click on submitButton
        Then WebAgent click on submitToQCButton

        And WebAgent see successMsg
        Then Sign Out

        # ***************************************************************
        # STEP 3:Quality Controller Complete Drawdown QC
        # ***************************************************************
        When Login as "SopsQC HK"
        Then WebAgent is on DrawdownTab
        And Switch PLatform to "HK Loans"
        And WebAgent open "QinstructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on editButton
        Then WebAgent click on qcChecklistDrawdownTab
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
        Then WebAgent click on completeDrawdownoCButton
        And WebAgent see successMsg
        Then Sign Out

        # ***************************************************************
        # STEP 4:Processing Checker Submit to Payment
        # ***************************************************************
        When Login as "SopsC HK"
        Then WebAgent is on OperationTab
        And Switch PLatform to "HK Loans"
        And WebAgent open "QinstructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentButton
        And WebAgent see successMsg
        Then Sign Out

        # ***************************************************************
        # STEP 5:Payment Maker Submit to Payment Checker
        # ***************************************************************
        When Login as "SopsPM HK"
        Then WebAgent is on PaymentTab
        And Switch PLatform to "HK Loans"
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on editButton
        Then WebAgent click on paymentTab
        And Wait 5 seconds
        Then WebAgent type "PAYMENT NOTE $RNText" into paymentNoteTextarea
        And WebAgent check on multipleCheckerRequiredTickbox
        And WebAgent type "RemiRefer $RN6" into remittanceReferenceTextbox
        And Select "CitiFT RTGS" from remittancesystemDropdownlist
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentCheckerButton
        And WebAgent see successMsg
        Then Sign Out

        # ***************************************************************
        # STEP 6:Payment Checker Submit to QC
        # ***************************************************************
        When Login as "SopsPC HK"
        Then WebAgent is on PaymentTab
        And Switch PLatform to "HK Loans"
        And WebAgent open "QinstructionUrl.Value" url
        And WebAgent check on qcWarningMessage if exist
        And Wait 5 seconds
        Then WebAgent click on editButton
        Then WebAgent click on paymentTab
        And Wait 5 seconds
        Then WebAgent click on submitButton
        And Wait 5 seconds
        Then WebAgent click on submitToQCButton
        And WebAgent see successMsg
        Then Sign Out

        # ***************************************************************
        # STEP 7:Quality Controller Complete Disbursement QC
        # **************************************************************
        When Login as "SopsQC HK"
        Then WebAgent is on DisbursementTab
        And Switch PLatform to "HK Loans"
        And WebAgent open "QinstructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on editButton
        Then WebAgent click on qcChecklistDisbursementTab
        And Wait 5 seconds
        Then WebAgent click on disbursementIdentificationocstatusRadio
        Then WebAgent click on disbursementMIFTQCStatusRadio
        Then WebAgent click on disbursementDetailsQcStatusRadio
        Then WebAgent click on disbursementApprovalocstatusRadio
        Then WebAgent type "Identification $RNText" into disbursementIdentificationQCTextarea
        Then WebAgent type "Disbursement Checking For Bilateral -$RNText" into disbursementCheckingQCTextarea
        Then WebAgent type "Disbursement Details in Payment System-$RNText" into disbursementDetailsQCTextarea
        Then WebAgent type "Approval -$RNText" into disbursementApprovalQCTextarea
        And Select "Yes" from sanctionHitsDropdownlist
        And Wait 5 seconds

        And WebAgent see sanctionHitsDropdownlist
        Then WebAgent click on completeButton
        And Wait 5 seconds
        And WebAgent see successMsg
        Then sign Out

        Then Close Browser

        Examples:
            ||
            ||