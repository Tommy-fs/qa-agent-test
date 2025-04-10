```gherkin
Feature: HK GCM Workflow - KL LOANS OPS - PROCESS CHECK
  Instruction Detail:
    1) Author: Jevons
    2) Transaction Type: 01 (New Drawdown)
    3) Workflow: HK GCM
    4) Check Point: E2E
  Test Case ID: HK_GCM_Workflow-001

  @HK_GCM_Workflow-001
  Scenario Outline: Verify actions based on THIRD PARTY PAYMENT (Yes) and COMPLETED DATE
    # Preconditions:
    # The system should be running and accessible.
    # KL LOANS OPS - PROCESS CHECK user account should exist.
    Given WebAgent open "$xxx systemApacLoginPage" url

    # STEP 1: Create a new instruction in the system with THIRD PARTY PAYMENT set to 'Yes'.
    # Instruction details are provided through the Examples table.
    Given Login as "SopsM_HK"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "Yes" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio
    And WebAgent type "<CUSTOMER_NAME>" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "<BASE_NUMBER>" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist
    And WebAgent clear input control tenorTextbox
    And WebAgent type "<TENOR>" into tenorTextbox
    And WebAgent type "<FACILITY_NUMBER>" into facilityNumberTextbox
    And WebAgent type "<LINK_LCU>" into linkLcuTextbox
    And Select "<LOAN_CURRENCY>" from loanCurrencyDropdownlist
    And WebAgent type "<BOOKING_AMOUNT>" into bookingAmountTextbox
    And select "<CREDIT_ACC_TYPE>" from creditAccTypeDropdownlist
    And Select "Same Currency" from creditCurrencyTypepropdownlist
    And Select "YES FLOAT" from installmentDropdownlist
    And WebAgent type "<CLIENT_ALL_IN_RATE>" into clientAllInRateTextbox
    And WebAgent type "<MARGIN>" into marginTextbox
    And Select "HIBOR" from marginDropdownlist
    And WebAgent type "<COST_RATE>" into costRateTextbox
    Then WebAgent click on interestBasisRadio
    And Select "1M HIBOR" from rateCodeDropdownlist
    And WebAgent clear input control nextRepricingDateDatepickerTextbox
    And WebAgent type "$TodayDate" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "<DEBIT_CUSTOMER_AC_NO>" into debitCustomerAcNoTextbox
    Then WebAgent type "<TRAN_REMARK>" into tranRemarkTextarea
    And WebAgent type "<RMOR_BACKUP_SOE_ID1>" into rmorBackUpSoeId1Textbox
    And WebAgent type "<PMIS>" into pmisTextbox
    And WebAgent type "<TOUC>" into toucTextbox
    And WebAgent type "<EXP_MIS>" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist
    Then WebAgent is on OperationTab
    Then WebAgent click on operationTab
    Then WebAgent type "<PENDING_REMARK>" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    Then WebAgent click on 3ppBeneficiaryRadio
    Then WebAgent type "<PROCESS_NOTE>" into processingNoteTextarea
    And WebAgent type "<NEW_CONTRACT_REFERENCE_NO>" into newContractReferenceNoTextbox
    And WebAgent type "<NEW_CUSTOM_REFERENCE_NO>" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out

    # STEP 2: Login as KL LOANS OPS - PROCESS CHECK.
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "SopsC HK"

    # STEP 3: Access the newly created instruction using the saved URL.
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on operationTab
    # Expected Result: Instruction details displayed.
    Then WebAgent should see element "customerNameTextbox"

    # STEP 4: Verify available actions before COMPLETED DATE is reached.
    # Expected Result: Specific actions are available as per HK GCM Workflow with THIRD PARTY PAYMENT 'Yes' and before completion date.
    Then the following actions should be available before COMPLETED DATE for THIRD PARTY PAYMENT 'Yes':
      | Action 1 |
      | Action 2 |
      | Action 3 |

    # STEP 5: Wait for the system to set the COMPLETED DATE.
    # Expected Result: COMPLETED DATE populated by the system.
    Then Wait for the system to set the COMPLETED DATE

    # STEP 6: Refresh the instruction view.
    # Expected Result: Instruction details displayed with COMPLETED DATE.
    When Refresh the instruction view
    Then WebAgent should see element "completedDateTextbox"

    # STEP 7: Verify available actions after COMPLETED DATE is reached.
    # Expected Result: Specific actions are available as per HK GCM Workflow with THIRD PARTY PAYMENT 'Yes' and after completion date. These actions should differ from step 4.
    Then the following actions should be available after COMPLETED DATE for THIRD PARTY PAYMENT 'Yes':
      | Action 4 |
      | Action 5 |
      | Action 6 |
    Then Close Browser

    Examples:
      | CUSTOMER_GROUP | CUSTOMER_NAME | BASE_NUMBER | TENOR | FACILITY_NUMBER | LINK_LCU | LOAN_CURRENCY | BOOKING_AMOUNT | CREDIT_ACC_TYPE | CLIENT_ALL_IN_RATE | MARGIN | COST_RATE | DEBIT_CUSTOMER_AC_NO | TRAN_REMARK | RMOR_BACKUP_SOE_ID1 | PMIS | TOUC | EXP_MIS | PENDING_REMARK | PROCESS_NOTE | NEW_CONTRACT_REFERENCE_NO | NEW_CUSTOM_REFERENCE_NO |
      | GCM            | GCM-TXN01-$TodayDate-$RN6 | HKO$RN6 | 10    | $RN6           | LINK-$RN6 | HKD           | 200,000,000.00 | CHATS             | 2.12345            | 1.12345 | 1.67890   | DBNO$RN6            | TRAN REMARK -$RNText | ST45611             | PMIS-$RN6 | TOUC-$RN6 | EXP MIS-$RN6 | PENDING REMARK $RNText | PROCESS NOTE $RNText | New-Contract-Ref-$RN6 | New-Custom-Ref-$RN6 |

---
Feature: HK GCM Workflow - KL LOANS OPS - PROCESS CHECK
  Instruction Detail:
    1) Author: Jevons
    2) Transaction Type: 01 (New Drawdown)
    3) Workflow: HK GCM
    4) Check Point: E2E
  Test Case ID: HK_GCM_Workflow-002

  @HK_GCM_Workflow-002
  Scenario Outline: Verify actions based on THIRD PARTY PAYMENT (No) and COMPLETED DATE
    # Preconditions:
    # The system should be running and accessible.
    # KL LOANS OPS - PROCESS CHECK user account should exist.
    Given WebAgent open "$xxx systemApacLoginPage" url

    # STEP 1: Create a new instruction in the system with THIRD PARTY PAYMENT set to 'No'.
    # Instruction details are provided through the Examples table.
    Given Login as "SopsM_HK"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "No" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio
    And WebAgent type "<CUSTOMER_NAME>" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "<BASE_NUMBER>" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist
    And WebAgent clear input control tenorTextbox
    And WebAgent type "<TENOR>" into tenorTextbox
    And WebAgent type "<FACILITY_NUMBER>" into facilityNumberTextbox
    And WebAgent type "<LINK_LCU>" into linkLcuTextbox
    And Select "<LOAN_CURRENCY>" from loanCurrencyDropdownlist
    And WebAgent type "<BOOKING_AMOUNT>" into bookingAmountTextbox
    And select "<CREDIT_ACC_TYPE>" from creditAccTypeDropdownlist
    And Select "Same Currency" from creditCurrencyTypepropdownlist
    And Select "YES FLOAT" from installmentDropdownlist
    And WebAgent type "<CLIENT_ALL_IN_RATE>" into clientAllInRateTextbox
    And WebAgent type "<MARGIN>" into marginTextbox
    And Select "HIBOR" from marginDropdownlist
    And WebAgent type "<COST_RATE>" into costRateTextbox
    Then WebAgent click on interestBasisRadio
    And Select "1M HIBOR" from rateCodeDropdownlist
    And WebAgent clear input control nextRepricingDateDatepickerTextbox
    And WebAgent type "$TodayDate" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "<DEBIT_CUSTOMER_AC_NO>" into debitCustomerAcNoTextbox
    Then WebAgent type "<TRAN_REMARK>" into tranRemarkTextarea
    And WebAgent type "<RMOR_BACKUP_SOE_ID1>" into rmorBackUpSoeId1Textbox
    And WebAgent type "<PMIS>" into pmisTextbox
    And WebAgent type "<TOUC>" into toucTextbox
    And WebAgent type "<EXP_MIS>" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist
    Then WebAgent is on OperationTab
    Then WebAgent click on operationTab
    Then WebAgent type "<PENDING_REMARK>" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    Then WebAgent click on 3ppBeneficiaryRadio
    Then WebAgent type "<PROCESS_NOTE>" into processingNoteTextarea
    And WebAgent type "<NEW_CONTRACT_REFERENCE_NO>" into newContractReferenceNoTextbox
    And WebAgent type "<NEW_CUSTOM_REFERENCE_NO>" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out

    # STEP 2: Login as KL LOANS OPS - PROCESS CHECK.
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "SopsC HK"

    # STEP 3: Access the newly created instruction using the saved URL.
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on operationTab
    # Expected Result: Instruction details displayed.
    Then WebAgent should see element "customerNameTextbox"

    # STEP 4: Verify available actions before COMPLETED DATE is reached.
    # Expected Result: Specific actions are available as per HK GCM Workflow with THIRD PARTY PAYMENT 'No' and before completion date.
    Then the following actions should be available before COMPLETED DATE for THIRD PARTY PAYMENT 'No':
      | Action 1 |
      | Action 2 |
      | Action 3 |

    # STEP 5: Wait for the system to set the COMPLETED DATE.
    # Expected Result: COMPLETED DATE populated by the system.
    Then Wait for the system to set the COMPLETED DATE

    # STEP 6: Refresh the instruction view.
    # Expected Result: Instruction details displayed with COMPLETED DATE.
    When Refresh the instruction view
    Then WebAgent should see element "completedDateTextbox"

    # STEP 7: Verify available actions after COMPLETED DATE is reached.
    # Expected Result: Specific actions are available as per HK GCM Workflow with THIRD PARTY PAYMENT 'No' and after completion date. These actions should differ from step 4 and also differ from test case HK_GCM_Workflow-001 step 7.
    Then the following actions should be available after COMPLETED DATE for THIRD PARTY PAYMENT 'No':
      | Action 4 |
      | Action 5 |
      | Action 6 |
    Then Close Browser

    Examples:
      | CUSTOMER_GROUP | CUSTOMER_NAME | BASE_NUMBER | TENOR | FACILITY_NUMBER | LINK_LCU | LOAN_CURRENCY | BOOKING_AMOUNT | CREDIT_ACC_TYPE | CLIENT_ALL_IN_RATE | MARGIN | COST_RATE | DEBIT_CUSTOMER_AC_NO | TRAN_REMARK | RMOR_BACKUP_SOE_ID1 | PMIS | TOUC | EXP_MIS | PENDING_REMARK | PROCESS_NOTE | NEW_CONTRACT_REFERENCE_NO | NEW_CUSTOM_REFERENCE_NO |
      | GCM            | GCM-TXN01-$TodayDate-$RN6 | HKO$RN6 | 10    | $RN6           | LINK-$RN6 | HKD           | 200,000,000.00 | CHATS             | 2.12345            | 1.12345 | 1.67890   | DBNO$RN6            | TRAN REMARK -$RNText | ST45611             | PMIS-$RN6 | TOUC-$RN6 | EXP MIS-$RN6 | PENDING REMARK $RNText | PROCESS NOTE $RNText | New-Contract-Ref-$RN6 | New-Custom-Ref-$RN6 |

---
Feature: HK GCM Workflow - COMPLETED DATE Modification
  Instruction Detail:
    1) Author: Jevons
    2) Transaction Type: 01 (New Drawdown)
    3) Workflow: HK GCM
    4) Check Point: E2E
  Test Case ID: HK_GCM_Workflow-003

  @HK_GCM_Workflow-003
  Scenario Outline: Verify COMPLETED DATE cannot be manually modified
    # Preconditions:
    # The system should be running and accessible.
    # KL LOANS OPS - PROCESS CHECK user account should exist.
    Given WebAgent open "$xxx systemApacLoginPage" url

    # STEP 1: Create a new instruction in the system.
    # Instruction details are provided through the Examples table.
    Given Login as "SopsM_HK"
    Then WebAgent is on InstructionTab
    Then Switch Platform to "HK Loans"
    Then WebAgent click on createButton
    And WebAgent click on newInstructionItem
    And Wait 5 seconds
    Then Select "New Drawdown" from transactionTypeDropdownlist
    And Select "Short Term Fixed Rate" from loanTypepropdownlist
    And Select "Yes" from thirdPartyPaymentDropdownlist
    And Select "No" from syndicatedLoanDropdownList
    And WebAgent click on workingCapitalNoRadio
    And WebAgent type "<CUSTOMER_NAME>" into customerNameTextbox
    And WebAgent clear input control baseNumberTextbox
    And WebAgent type "<BASE_NUMBER>" into baseNumberTextbox
    And Select "<CUSTOMER_GROUP>" from customerGroupDropdownlist
    And WebAgent clear input control valueDTDatepickerTextbox
    And WebAgent type "$TodayDate" into valueDTDatepickerTextbox
    And Select "PASS" from classificationDropdownlist
    And WebAgent clear input control tenorTextbox
    And WebAgent type "<TENOR>" into tenorTextbox
    And WebAgent type "<FACILITY_NUMBER>" into facilityNumberTextbox
    And WebAgent type "<LINK_LCU>" into linkLcuTextbox
    And Select "<LOAN_CURRENCY>" from loanCurrencyDropdownlist
    And WebAgent type "<BOOKING_AMOUNT>" into bookingAmountTextbox
    And select "<CREDIT_ACC_TYPE>" from creditAccTypeDropdownlist
    And Select "Same Currency" from creditCurrencyTypepropdownlist
    And Select "YES FLOAT" from installmentDropdownlist
    And WebAgent type "<CLIENT_ALL_IN_RATE>" into clientAllInRateTextbox
    And WebAgent type "<MARGIN>" into marginTextbox
    And Select "HIBOR" from marginDropdownlist
    And WebAgent type "<COST_RATE>" into costRateTextbox
    Then WebAgent click on interestBasisRadio
    And Select "1M HIBOR" from rateCodeDropdownlist
    And WebAgent clear input control nextRepricingDateDatepickerTextbox
    And WebAgent type "$TodayDate" into nextRepricingDateDatepickerTextbox
    And Select "Manual" from autoRepayDropdownlist
    And WebAgent type "<DEBIT_CUSTOMER_AC_NO>" into debitCustomerAcNoTextbox
    Then WebAgent type "<TRAN_REMARK>" into tranRemarkTextarea
    And WebAgent type "<RMOR_BACKUP_SOE_ID1>" into rmorBackUpSoeId1Textbox
    And WebAgent type "<PMIS>" into pmisTextbox
    And WebAgent type "<TOUC>" into toucTextbox
    And WebAgent type "<EXP_MIS>" into expMisTextbox
    And WebAgent check on ignoreWeekendTickbox if exist
    And Select "P10110-Manufacturing Textiles cotton" from econSectorDropdownlist
    And Select "0 - Other" from loanPurposepropdownlist
    And Select "Use in HK" from countryLoanUsedDropdownlist
    Then WebAgent is on OperationTab
    Then WebAgent click on operationTab
    Then WebAgent type "<PENDING_REMARK>" into pendingRemarkTextarea
    And WebAgent check on kivTickbox
    Then WebAgent click on 3ppBeneficiaryRadio
    Then WebAgent type "<PROCESS_NOTE>" into processingNoteTextarea
    And WebAgent type "<NEW_CONTRACT_REFERENCE_NO>" into newContractReferenceNoTextbox
    And WebAgent type "<NEW_CUSTOM_REFERENCE_NO>" into newCustomReferenceNoTextbox
    And Select "Yes" from svsMakerDropdownlist
    And Select "AT" from atorotDropdownlist
    And Select "PASS" from classificationMakerDropdownlist
    Then WebAgent click on createAndMakerSubmitButton
    And WebAgent see successMsg
    And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
    Then sign Out

    # STEP 2: Login as KL LOANS OPS - PROCESS CHECK.
    Given WebAgent open "$xxx systemApacLoginPage" url
    When Login as "SopsC HK"

    # STEP 3: Access the newly created instruction using the saved URL.
    Then WebAgent is on OperationTab
    And WebAgent open "@instructionUrl.Value" url
    And WebAgent check on qcWarningMessage if exist
    And Wait 5 seconds
    Then WebAgent click on editButton
    Then WebAgent click on operationTab
    # Expected Result: Instruction details displayed.
    Then WebAgent should see element "customerNameTextbox"

    # STEP 4: Attempt to manually modify the COMPLETED DATE field.
    # Expected Result: The system should prevent manual modification of the COMPLETED DATE field. An error message may be displayed.
    When WebAgent attempts to modify the COMPLETED DATE field with "2024-01-01"
    Then WebAgent should see an error message indicating that the COMPLETED DATE cannot be manually modified
    Then Close Browser

    Examples:
      | CUSTOMER_GROUP | CUSTOMER_NAME | BASE_NUMBER | TENOR | FACILITY_NUMBER | LINK_LCU | LOAN_CURRENCY | BOOKING_AMOUNT | CREDIT_ACC_TYPE | CLIENT_ALL_IN_RATE | MARGIN | COST_RATE | DEBIT_CUSTOMER_AC_NO | TRAN_REMARK | RMOR_BACKUP_SOE_ID1 | PMIS | TOUC | EXP_MIS | PENDING_REMARK | PROCESS_NOTE | NEW_CONTRACT_REFERENCE_NO | NEW_CUSTOM_REFERENCE_NO |
      | GCM            | GCM-TXN01-$TodayDate-$RN6 | HKO$RN6 | 10    | $RN6           | LINK-$RN6 | HKD           | 200,000,000.00 | CHATS             | 2.12345            | 1.12345 | 1.67890   | DBNO$RN6            | TRAN REMARK -$RNText | ST45611             | PMIS-$RN6 | TOUC-$RN6 | EXP MIS-$RN6 | PENDING REMARK $RNText | PROCESS NOTE $RNText | New-Contract-Ref-$RN6 | New-Custom-Ref-$RN6 |
```