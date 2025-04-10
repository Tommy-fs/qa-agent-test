```gherkin
# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Two Persons Linked to One Resume

  Scenario Outline: C20250101A0102 Verify two PERSONS can link to the same RESUME

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for this test case.
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for this test case.
    Given Insert component1 rule data with json "<OverwriteRuleJsonModelFilePath>"

    # Test Step 4: Insert PERSON1 data with a unique Human Info Code and COMPANY_0102 as the ChannelCode.
    Then Insert human info "<Person1MsgPath>" with person "-01021"

    # Test Step 5: Trigger COMPONENT1 to process PERSON1.
    Then Trigger person "-01021" to component1 process

    # Test Step 6: Insert PERSON2 data with a different Human Info Code but the same COMPANY_0102 as the ChannelCode and a different Announcement Date.
    Then Insert human info "<Person2MsgPath>" with person "-01022"

    # Test Step 7: Trigger COMPONENT1 to process PERSON2.
    Then Trigger person "-01022" to component1 process

    # Test Step 8: Retrieve the RESUME linked to PERSON1.
    Then Get resume with person "-01021" into @resume1

    # Test Step 9: Get the count of PERSONS linked to the retrieved RESUME.
    Then Get count of person linked to resume "@resume1" into @actualPersonCount

    # Test Step 10: Get the linking rule code used to link PERSON2 to the RESUME.
    Then Get link rule code with person "-01022" into @actualLinkingRuleCode

    # Test Step 11: Compare the actual count of PERSONS linked to the RESUME with the expected count (2).
    Then Compare "personCountLinkedToResume" actual "@actualPersonCount" with expected "<ExpectedPersonCount>" into @report1 and compare param type "number"

    # Test Step 12: Compare the actual linking rule code with the expected linking rule code.
    Then Compare "LinkingRuleCode" actual "@actualLinkingRuleCode" with expected "<ExpectedLinkingRuleCode>" into @report2 and compare param type "string"

    # Test Step 13: Clear inserted linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "0102"

    # Test Step 14: Generate report
    Then Generate report with "@report1"
    Then Generate report with "@report2"

    Examples:
      | RuleJsonModelFilePath          | OverwriteRuleJsonModelFilePath | Person1MsgPath | Person2MsgPath | ExpectedPersonCount | ExpectedLinkingRuleCode |
      | 001_C20250101A-0102_RuleData.json | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx | 010_Testing_Data.xlsx | 2 | ExpectedRuleCode |

# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Person Fails to Link Due to No Matching Group

  Scenario Outline: C20250101A0102 Verify PERSON fails to link due to no matching GROUP

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for this test case.
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert PERSON data with a ChannelCode that does not correspond to any existing COMPANY.
    Then Insert human info "<PersonMsgPath>" with person "-01021"

    # Test Step 4: Trigger COMPONENT1 to process the PERSON.
    Then Trigger person "-01021" to component1 process

    # Test Step 5: Verify that the PERSON is marked as failed.
    Then Verify person "-01021" status is "Failed"

    # Test Step 6: Clear inserted linking rules and test data.
    Given Clear component1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath          | PersonMsgPath |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx |

# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Person Fails to Link Due to Matching Linking Rule

  Scenario Outline: C20250101A0102 Verify PERSON fails to link due to matching linking rule

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "0102"

    # Test Step 2: Insert a linking rule with criteria that will not match any existing RESUME.
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert PERSON data with a ChannelCode corresponding to the COMPANY associated with the linking rule.
    Then Insert human info "<PersonMsgPath>" with person "-01021"

    # Test Step 4: Trigger COMPONENT1 to process the PERSON.
    Then Trigger person "-01021" to component1 process

    # Test Step 5: Verify that a new RESUME is created for the PERSON.
    Then Verify resume created for person "-01021"

    # Test Step 6: Clear inserted linking rules and test data.
    Given Clear component1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath          | PersonMsgPath |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx |
```