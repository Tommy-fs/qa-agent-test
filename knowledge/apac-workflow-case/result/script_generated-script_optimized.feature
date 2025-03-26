```gherkin
Feature: HK GCM Workflow - Action Verification based on Third Party Payment and Completed Date
  # This feature verifies the available actions for KL LOANS OPS - PROCESS CHECK role in the HK GCM workflow
  # based on the THIRD PARTY PAYMENT status and COMPLETED DATE.
  # Author: Jevons
  # Transaction Type: New Drawdown
  # Workflow: HK GCM
  # Check Point: Action Verification

  @HK_GCM_Workflow-001
  Scenario Outline: Verify KL LOANS OPS - PROCESS CHECK actions when THIRD PARTY PAYMENT is <Third_Party_Payment> and COMPLETED DATE is Today
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.
    # 3. Instruction should be in initial state

    Given WebAgent open "$xxx systemApacLoginPage"url
    # Step 1: Login to the system
    When Login as "SopsM_HK" # Login as KL LOANS OPS - PROCESS CHECK role
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Switch Platform to HK Loans
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new instruction order
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "<Third_Party_Payment>" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist GCM workflow only has GCM vaLue
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

    # Sign Out the system
    Then sign Out

    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    # Expected Result: Only actions permitted based on workflow rules and COMPLETED DATE are displayed
    Then User verifies that only the permitted actions "<Expected_Actions>" are displayed for "KL LOANS OPS - PROCESS CHECK" role based on workflow rules and COMPLETED DATE
    And WebAgent should see "<Expected_Actions>" button

    # Sign Out the system
    Then Close Browser

    Examples:
      | Third_Party_Payment | CUSTOMER_GROUP | Expected_Actions |
      | Yes                 | GCM            | Submit, Edit, View |

---
Feature: HK GCM Workflow - Action Verification based on Third Party Payment and Completed Date
  # This feature verifies the available actions for KL LOANS OPS - PROCESS CHECK role in the HK GCM workflow
  # based on the THIRD PARTY PAYMENT status and COMPLETED DATE.
  # Author: Jevons
  # Transaction Type: New Drawdown
  # Workflow: HK GCM
  # Check Point: Action Verification

  @HK_GCM_Workflow-002
  Scenario Outline: Verify KL LOANS OPS - PROCESS CHECK actions when THIRD PARTY PAYMENT is <Third_Party_Payment> and COMPLETED DATE is Today
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.
    # 3. Instruction should be in initial state

    Given WebAgent open "$xxx systemApacLoginPage"url
    # Step 1: Login to the system
    When Login as "SopsM_HK" # Login as KL LOANS OPS - PROCESS CHECK role
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Switch Platform to HK Loans
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new instruction order
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "<Third_Party_Payment>" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist GCM workflow only has GCM vaLue
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

    # Sign Out the system
    Then sign Out

    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    # Expected Result: Only actions permitted based on workflow rules and COMPLETED DATE are displayed
    Then User verifies that only the permitted actions "<Expected_Actions>" are displayed for "KL LOANS OPS - PROCESS CHECK" role based on workflow rules and COMPLETED DATE
    And WebAgent should see "<Expected_Actions>" button

    # Sign Out the system
    Then Close Browser

    Examples:
      | Third_Party_Payment | CUSTOMER_GROUP | Expected_Actions |
      | No                  | GCM            | Submit, Edit, View |

---
Feature: HK GCM Workflow - Completed Date Verification

  # This feature verifies that the COMPLETED DATE is automatically set upon instruction creation
  # and that it cannot be modified by the user.
  # Author: Jevons
  # Transaction Type: New Drawdown
  # Workflow: HK GCM
  # Check Point: Completed Date Verification

  @HK_GCM_Workflow-003
  Scenario Outline: Verify COMPLETED DATE is automatically set and non-modifiable
    # Preconditions:
    # 1. User has valid credentials with any role.
    # 2. System is in a clean state.

    Given WebAgent open "$xxx systemApacLoginPage"url
    # Step 1: Login to the system
    When Login as "SopsM_HK" # Using a valid role for login
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Switch Platform to HK Loans
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new instruction order
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
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist GCM workflow only has GCM vaLue
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

    # Expected Result: Instruction created successfully with COMPLETED DATE automatically populated
    Then System automatically populates COMPLETED DATE upon instruction creation
    And WebAgent should see completedDate populated

    # Step 3: Attempt to modify COMPLETED DATE
    When User attempts to modify COMPLETED DATE to "<Any_Date>"
    # Expected Result: Modification not allowed.  Error message displayed or field disabled.
    Then System prevents modification of COMPLETED DATE and displays an error message or disables the field
    And WebAgent should see error message "Modification not allowed"

    # Sign Out the system
    Then Close Browser

    Examples:
      | CUSTOMER_GROUP | Any_Date   |
      | GCM            | 2024-01-01 |

---
Feature: HK GCM Workflow - Impact of Completed Date on Actions (Third Party Payment True)

  # This feature verifies the impact of the COMPLETED DATE on the available actions for
  # KL LOANS OPS - PROCESS CHECK role when THIRD PARTY PAYMENT is True.
  # Author: Jevons
  # Transaction Type: New Drawdown
  # Workflow: HK GCM
  # Check Point: Completed Date Impact Verification

  @HK_GCM_Workflow-004
  Scenario Outline: Verify impact of COMPLETED DATE on actions with THIRD PARTY PAYMENT <Third_Party_Payment>
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.
    # 3. Instruction should be in initial state

    Given WebAgent open "$xxx systemApacLoginPage"url
    # Step 1: Login to the system
    When Login as "SopsM_HK" # Login as KL LOANS OPS - PROCESS CHECK role
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Switch Platform to HK Loans
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new instruction order
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "<Third_Party_Payment>" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist GCM workflow only has GCM vaLue
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

    # Step 4: Simulate backdating COMPLETED DATE
    And User simulates backdating COMPLETED DATE to "<Past_Date>"

    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on backdated COMPLETED DATE and workflow rules
    And WebAgent should see "<Expected_Actions_Past>" button

    # Step 5: Simulate future dating COMPLETED DATE
    And User simulates future dating COMPLETED DATE to "<Future_Date>"

    # Step 5: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on future dated COMPLETED DATE and workflow rules
    And WebAgent should see "<Expected_Actions_Future>" button

    # Sign Out the system
    Then Close Browser

    Examples:
      | Third_Party_Payment | CUSTOMER_GROUP | Past_Date  | Future_Date | Expected_Actions_Past | Expected_Actions_Future |
      | Yes                 | GCM            | 2023-01-01 | 2025-01-01 | View,Edit            | Submit,View             |

---
Feature: HK GCM Workflow - Impact of Completed Date on Actions (Third Party Payment False)

  # This feature verifies the impact of the COMPLETED DATE on the available actions for
  # KL LOANS OPS - PROCESS CHECK role when THIRD PARTY PAYMENT is False.
  # Author: Jevons
  # Transaction Type: New Drawdown
  # Workflow: HK GCM
  # Check Point: Completed Date Impact Verification

  @HK_GCM_Workflow-005
  Scenario Outline: Verify impact of COMPLETED DATE on actions with THIRD PARTY PAYMENT <Third_Party_Payment>
    # Preconditions:
    # 1. User has valid credentials with KL LOANS OPS - PROCESS CHECK role.
    # 2. System is in a clean state.
    # 3. Instruction should be in initial state

    Given WebAgent open "$xxx systemApacLoginPage"url
    # Step 1: Login to the system
    When Login as "SopsM_HK" # Login as KL LOANS OPS - PROCESS CHECK role
    # Indicate the below actions repository is on Instruction Tab
    Then WebAgent is on InstructionTab
    # Switch Platform to "HK Loans"
    Then Switch Platform to "HK Loans"

    # Step 2: Create a new instruction order
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds

    # Set fields value in MainSection(Mandatory)
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "<Third_Party_Payment>" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio

    # Set fields value in General Information Section(Mandatory)
    And WebAgent type "GCM-TXN01-$TodayDate-$RN6" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "HKO$RN6" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist GCM workflow only has GCM vaLue
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

    # Step 4: Simulate backdating COMPLETED DATE
    And User simulates backdating COMPLETED DATE to "<Past_Date>"

    # Step 4: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on backdated COMPLETED DATE and workflow rules
    And WebAgent should see "<Expected_Actions_Past>" button

    # Step 5: Simulate future dating COMPLETED DATE
    And User simulates future dating COMPLETED DATE to "<Future_Date>"

    # Step 5: Verify available actions for KL LOANS OPS - PROCESS CHECK
    Then User verifies available actions for "KL LOANS OPS - PROCESS CHECK" role based on future dated COMPLETED DATE and workflow rules
    And WebAgent should see "<Expected_Actions_Future>" button

    # Sign Out the system
    Then Close Browser

    Examples:
      | Third_Party_Payment | CUSTOMER_GROUP | Past_Date  | Future_Date | Expected_Actions_Past | Expected_Actions_Future |
      | No                  | GCM            | 2023-01-01 | 2025-01-01 | View,Edit            | Submit,View             |
```