```gherkin
Feature: HK GCM Workflow
    Instruction Detail:
    1) Author: Jevons
    2) Transaction Type: 01 (New Drawdown)
    3) Workflow: HK GCM
    4) Check Point: E2E
    5) Key Value: HK_GCM_Workflow

    @hkgcm
    Scenario Outline: HK_GCM_Workflow-001 - Validate HK GCM Workflow with THIRD PARTY PAYMENT=Yes and COMPLETED DATE blank, then COMPLETED DATE not blank.
        # Preconditions:
        # The system should be running and accessible.
        # User accounts for KL LOANS OPS-PROCESSING-MAKER, KL LOANS OPS-PROCESSING-PAYMENT MAKER and CHECKER should exist.

        # Step 1: Login system as KL LOANS OPS-PROCESSING-MAKER
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsM_HK" # Assuming "SopsM_HK" is the role for KL LOANS OPS-PROCESSING-MAKER

        # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT = Yes
        Then WebAgent is on InstructionTab
        Then Switch Platform to "HK Loans"
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
        And WebAgent verify CURRENT STATUS is "KL LOANS OPS"
        And WebAgent verify PROCESS STATUS is "KL LOANS - PROCESSING-CHECKER"

        # Step 3: Verify available actions - Only 'Submit to Payment' action is available, 'Complete' action is disabled
        Then WebAgent is able to see "Submit to Payment" action
        And WebAgent is not able to see "Complete" action

        # Step 4: Perform 'Submit to Payment' action
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PAYMENT - MAKER"

        # Step 5: Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsPM HK" # Assuming "SopsPM HK" is the role for KL LOANS OPS-PROCESSING-PAYMENT MAKER

        # Step 6: Open the created instruction
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds

        # Step 7: Perform 'Submit Payment Checker' action
        Then WebAgent click on editButton
        Then WebAgent click on paymentTab
        And Wait 5 seconds
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentCheckerButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PAYMENT-CHECKER"

        # Step 8: Login system as KL LOANS OPS-PROCESSING-PAYMENT CHECKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsPC HK" # Assuming "SopsPC HK" is the role for KL LOANS OPS-PROCESSING-PAYMENT CHECKER

        # Step 9: Open the created instruction
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds

        # Step 10: Perform 'Complete' action
        Then WebAgent click on editButton
        Then WebAgent click on paymentTab
        And Wait 5 seconds
        Then WebAgent click on submitButton
        And Wait 5 seconds
        Then WebAgent click on submitToQCButton
        And WebAgent see successMsg
        And WebAgent verify CURRENT STATUS is "COMPLETED"
        And WebAgent verify PROCESS STATUS is "COMPLETED"
        And WebAgent verify COMPLETED DATE is populated

        # Step 11: Login system as KL LOANS OPS-PROCESSING-MAKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsM_HK" # Assuming "SopsM_HK" is the role for KL LOANS OPS-PROCESSING-MAKER

        # Step 12: Create a new HK GCM Instruction with THIRD PARTY PAYMENT = Yes
        Then WebAgent is on InstructionTab
        Then Switch Platform to "HK Loans"
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

        # Step 13: Simulate system setting COMPLETED DATE
        # Assuming there's a step to simulate setting the COMPLETED DATE.  This needs a custom step definition.
        Then Simulate system sets COMPLETED DATE

        # Step 14: Verify available actions - Both 'Submit to Payment' and 'Complete' actions are available
        Then WebAgent should see "Submit to Payment" button
        And WebAgent should see "Complete" button

        Then Close Browser

        Examples:
            | CUSTOMER GROUP |
            | GCM            |

---
Feature: HK GCM Workflow
    Instruction Detail:
    1) Author: Jevons
    2) Transaction Type: 01 (New Drawdown)
    3) Workflow: HK GCM
    4) Check Point: E2E
    5) Key Value: HK_GCM_Workflow

    @hkgcm
    Scenario Outline: HK_GCM_Workflow-002 - Validate HK GCM Workflow with THIRD PARTY PAYMENT=No.
        # Preconditions:
        # The system should be running and accessible.
        # User accounts for KL LOANS OPS-PROCESSING-MAKER should exist.

        # Step 1: Login system as KL LOANS OPS-PROCESSING-MAKER
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsM_HK" # Assuming "SopsM_HK" is the role for KL LOANS OPS-PROCESSING-MAKER

        # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT = No
        Then WebAgent is on InstructionTab
        Then Switch Platform to "HK Loans"
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
        And WebAgent verify CURRENT STATUS is "KL LOANS OPS"
        And WebAgent verify PROCESS STATUS is "KL LOANS - PROCESSING-CHECKER"

        # Step 3: Verify available actions - Only 'Complete' action is available, 'Submit to Payment' action is disabled
        Then WebAgent is able to see "Complete" action
        And WebAgent is not able to see "Submit to Payment" action

        # Step 4: Perform 'Complete' action
        Then WebAgent click on completeButton
        And WebAgent see successMsg
        And WebAgent verify CURRENT STATUS is "COMPLETED"
        And WebAgent verify PROCESS STATUS is "COMPLETED"
        And WebAgent verify COMPLETED DATE is populated

        Then Close Browser

        Examples:
            | CUSTOMER GROUP |
            | GCM            |

---
Feature: HK GCM Workflow
    Instruction Detail:
    1) Author: Jevons
    2) Transaction Type: 01 (New Drawdown)
    3) Workflow: HK GCM
    4) Check Point: E2E
    5) Key Value: HK_GCM_Workflow

    @hkgcm
    Scenario Outline: HK_GCM_Workflow-003 - Validate Return functionalities for Payment Maker and Payment Checker.
        # Preconditions:
        # The system should be running and accessible.
        # User accounts for KL LOANS OPS-PROCESSING-MAKER, KL LOANS OPS-PROCESSING-PAYMENT MAKER, and KL LOANS OPS-PROCESSING-PAYMENT CHECKER should exist.

        # Step 1: Login system as KL LOANS OPS-PROCESSING-MAKER
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsM_HK" # Assuming "SopsM_HK" is the role for KL LOANS OPS-PROCESSING-MAKER

        # Step 2: Create a new HK GCM Instruction with THIRD PARTY PAYMENT = Yes
        Then WebAgent is on InstructionTab
        Then Switch Platform to "HK Loans"
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
        And WebAgent type "GCM-TXN04-$TodayDate-$RN6" into customerNameTextbox
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

        # Step 3: Perform 'Submit to Payment' action
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PAYMENT - MAKER"

        # Step 4: Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsPM HK" # Assuming "SopsPM HK" is the role for KL LOANS OPS-PROCESSING-PAYMENT MAKER

        # Step 5: Open the created instruction
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds

        # Step 6: Perform 'Return to Maker' action
        Then WebAgent click on returnToMakerButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PROCESSING-MAKER-MANUAL"

        # Step 7: Login system as KL LOANS OPS-PROCESSING-MAKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsM_HK" # Assuming "SopsM_HK" is the role for KL LOANS OPS-PROCESSING-MAKER

        # Step 8: Perform 'Submit to Payment' action
        Then WebAgent is on InstructionTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PAYMENT - MAKER"

        # Step 9: Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsPM HK" # Assuming "SopsPM HK" is the role for KL LOANS OPS-PROCESSING-PAYMENT MAKER

        # Step 10: Perform 'Submit Payment Checker' action
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on editButton
        Then WebAgent click on paymentTab
        And Wait 5 seconds
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentCheckerButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PAYMENT-CHECKER"

        # Step 11: Login system as KL LOANS OPS-PROCESSING-PAYMENT CHECKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsPC HK" # Assuming "SopsPC HK" is the role for KL LOANS OPS-PROCESSING-PAYMENT CHECKER

        # Step 12: Perform 'Return to Maker' action
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds
        Then WebAgent click on returnToMakerButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PROCESSING-MAKER-MANUAL"

        # Step 13: Login system as KL LOANS OPS-PROCESSING-PAYMENT CHECKER
        Then sign Out
        Given WebAgent open "$xxx systemApacLoginPage" url
        When Login as "SopsPC HK" # Assuming "SopsPC HK" is the role for KL LOANS OPS-PROCESSING-PAYMENT CHECKER

        # Step 14: Open the created instruction
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        And Wait 5 seconds

        # Step 15: Perform 'Return to Payment Maker' action
        Then WebAgent click on returnToPaymentMakerButton
        And WebAgent see successMsg
        And WebAgent verify PROCESS STATUS is "PAYMENT - MAKER"

        Then Close Browser

        Examples:
            | CUSTOMER GROUP |
            | GCM            |
```