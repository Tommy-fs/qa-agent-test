```gherkin
# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Two Persons Linked to One Resume
  # Author: Test Automation Team
  # Description: Verify that two PERSONS can link to the same RESUME if they meet the linking rule criteria, and validate the link count and linking rule code.
  # Checkpoints:
  #   - Two PERSONS are linked to the same RESUME.
  #   - The link count is 2.
  #   - The linking rule code matches the expected code.

  Scenario Outline: C20250101A0102 Verify two PERSONS can link to the same RESUME

    # Step 1: Clear existing linking rules, overwrite rules, and test data.
    # Action: Clear component1 config data for company 0102.
    Given Clear component1 config data with company "0102"

    # Step 2: Insert the predefined linking rule for this test case.
    # Action: Insert component1 rule data from the specified JSON file.
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Step 3: Insert the predefined overwrite rule for this test case.
    # Action: Insert component1 rule data from the specified JSON file for overwrite rule.
    Given Insert component1 rule data with json "<OverwriteRuleJsonModelFilePath>"

    # Step 4: Insert PERSON1 data with a unique Human Info Code and COMPANY_0102 as the ChannelCode.
    # Action: Insert human info for PERSON1 using data from the specified file.
    Then Insert human info "<Person1MsgPath>" with person "-01021"

    # Step 5: Trigger COMPONENT1 to process PERSON1.
    # Action: Trigger component1 process for PERSON1.
    Then Trigger person "-01021" to component1 process
    # Expected Result: RESUME created for PERSON1

    # Step 6: Insert PERSON2 data with a different Human Info Code but the same COMPANY_0102 as the ChannelCode and a different Announcement Date.
    # Action: Insert human info for PERSON2 using data from the specified file.
    Then Insert human info "<Person2MsgPath>" with person "-01022"

    # Step 7: Trigger COMPONENT1 to process PERSON2.
    # Action: Trigger component1 process for PERSON2.
    Then Trigger person "-01022" to component1 process
    # Expected Result: PERSON2 linked to PERSON1's RESUME

    # Step 8: Retrieve the RESUME linked to PERSON1.
    # Action: Get resume for PERSON1 and store it in variable @resume1.
    Then Get resume with person "-01021" into @resume1

    # Step 9: Get the count of PERSONS linked to the retrieved RESUME.
    # Action: Get the count of persons linked to resume @resume1 and store it in variable @actualPersonCount.
    Then Get count of person linked to resume "@resume1" into @actualPersonCount
    # Expected Result: Actual Count = 2

    # Step 10: Get the linking rule code used to link PERSON2 to the RESUME.
    # Action: Get the linking rule code for PERSON2 and store it in variable @actualLinkingRuleCode.
    Then Get link rule code with person "-01022" into @actualLinkingRuleCode
    # Expected Result: Actual Linking Rule Code = Expected Linking Rule Code (from `001_C20250101A-0102_RuleData.json`)

    # Step 11: Compare the actual count of PERSONS linked to the RESUME with the expected count (2).
    # Action: Compare the actual person count with the expected person count.
    Then Compare "personCountLinkedToResume" actual "@actualPersonCount" with expected "<ExpectedPersonCount>" into @report1 and compare param type "number"
    # Expected Result: Counts match

    # Step 12: Compare the actual linking rule code with the expected linking rule code.
    # Action: Compare the actual linking rule code with the expected linking rule code.
    Then Compare "LinkingRuleCode" actual "@actualLinkingRuleCode" with expected "<ExpectedLinkingRuleCode>" into @report2 and compare param type "string"
    # Expected Result: Linking rule codes match

    # Step 13: Clear inserted linking rules, overwrite rules, and test data.
    # Action: Clear component1 config data for company 0102.
    Given Clear component1 config data with company "0102"

    # Step 14: Generate report
    # Action: Generate report for person count and linking rule code comparison.
    Then Generate report with "@report1"
    Then Generate report with "@report2"

    Examples:
      | RuleJsonModelFilePath          | OverwriteRuleJsonModelFilePath | Person1MsgPath | Person2MsgPath | ExpectedPersonCount | ExpectedLinkingRuleCode |
      | 001_C20250101A-0102_RuleData.json | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx | 010_Testing_Data.xlsx | 2 | RULE_0102 |

# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Person Fails to Link Due to No Matching Group
  # Author: Test Automation Team
  # Description: Verify that a PERSON is marked as failed if they cannot match any GROUP based on their COMPANY information.
  # Checkpoints:
  #   - The PERSON is marked as failed.

  Scenario Outline: C20250101A0102 Verify PERSON fails to link due to no matching GROUP

    # Step 1: Clear existing linking rules, overwrite rules, and test data.
    # Action: Clear component1 config data for company 0102.
    Given Clear component1 config data with company "0102"

    # Step 2: Insert the predefined linking rule for this test case.
    # Action: Insert component1 rule data from the specified JSON file.
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Step 3: Insert PERSON data with a ChannelCode that does not correspond to any existing COMPANY.
    # Action: Insert human info for PERSON with an invalid ChannelCode using data from the specified file.
    Then Insert human info "<PersonMsgPath>" with person "-01021"

    # Step 4: Trigger COMPONENT1 to process the PERSON.
    # Action: Trigger component1 process for PERSON.
    Then Trigger person "-01021" to component1 process

    # Step 5: Verify that the PERSON is marked as failed.
    # Action: Verify that the PERSON status is "Failed".
    Then Verify person "-01021" status is "Failed"

    # Step 6: Clear inserted linking rules and test data.
    # Action: Clear component1 config data for company 0102.
    Given Clear component1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath          | PersonMsgPath |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx |

# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Person Fails to Link Due to Matching Linking Rule
  # Author: Test Automation Team
  # Description: Verify that a PERSON is marked as failed if they match a linking rule associated with their GROUP. (This seems contradictory to the project document, needs clarification, assuming it means no matching *criteria* within the rule)
  # Checkpoints:
  #   - A new RESUME is created for the PERSON.

  Scenario Outline: C20250101A0102 Verify PERSON fails to link due to matching linking rule

    # Step 1: Clear existing linking rules, overwrite rules, and test data.
    # Action: Clear component1 config data for company 0102.
    Given Clear component1 config data with company "0102"

    # Step 2: Insert a linking rule with criteria that will not match any existing RESUME.
    # Action: Insert component1 rule data from the specified JSON file with modified linking criteria.
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Step 3: Insert PERSON data with a ChannelCode corresponding to the COMPANY associated with the linking rule.
    # Action: Insert human info for PERSON using data from the specified file.
    Then Insert human info "<PersonMsgPath>" with person "-01021"

    # Step 4: Trigger COMPONENT1 to process the PERSON.
    # Action: Trigger component1 process for PERSON.
    Then Trigger person "-01021" to component1 process

    # Step 5: Verify that a new RESUME is created for the PERSON.
    # Action: Verify that a new RESUME is created for the PERSON.
    Then Verify resume created for person "-01021"

    # Step 6: Clear inserted linking rules and test data.
    # Action: Clear component1 config data for company 0102.
    Given Clear component1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath          | PersonMsgPath |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx |
```