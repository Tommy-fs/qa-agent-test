```gherkin
# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule - Two Persons Linked to One Resume

  Scenario Outline: C20250101A-0102 Verify that two PERSONS can link to the same RESUME if they meet the same linking rule criteria, and validate the link count and linking rule code.

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "COMPANY_0102"

    # Test Step 2: Insert the predefined linking rule for this test case.
    Given Insert component1 rule data with json "<RuleDataFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for this test case.
    Given Insert component1 overwrite rule data with json "<RuleDataFilePath>"

    # Test Step 4: Insert PERSON1 data with a unique Human Info Code and COMPANY_0102 as the ChannelCode.
    Then Insert human info "<Person1MsgPath>" with person "-01021"

    # Test Step 5: Trigger COMPONENT1 processing for PERSON1.
    Then Trigger person "-01021" to component1 process

    # Test Step 6: Insert PERSON2 data with a different Human Info Code but the same COMPANY_0102 as the ChannelCode.
    Then Insert human info "<Person2MsgPath>" with person "-01022"

    # Test Step 7: Trigger COMPONENT1 processing for PERSON2.
    Then Trigger person "-01022" to component1 process

    # Test Step 8: Retrieve the RESUME linked to PERSON1 and store it in RESUMEVariable1.
    Then Get resume with person "-01021" into @resume1

    # Test Step 9: Get the count of PERSONS linked to RESUMEVariable1 and store it in actualCountVariable.
    Then Get count of person linked to resume "@resume1" into @actualCountVariable

    # Test Step 10: Get the linking rule code used by PERSON2 to link to the RESUME and store it in actualLinkingCode.
    Then Get link rule code with person "-01022" into @actualLinkingCode

    # Test Step 11: Compare actualCountVariable with the expected count (2).
    Then Compare "personCountLinkedToResume" actual "@actualCountVariable" with expected "<ExpectedCount>" into @report1 and compare param type "number"

    # Test Step 12: Compare actualLinkingCode with the expected linking rule code.
    Then Compare "LinkingRule" actual "@actualLinkingCode" with expected "<ExpectedLinkingRuleCode>" into @report2 and compare param type "string"

    # Test Step 13: Clear inserted linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "COMPANY_0102"

    # Test Step 14: Generate report
    Then Generate report with "@report1"
    Then Generate report with "@report2"

    Examples:
      | RuleDataFilePath                  | Person1MsgPath                      | Person2MsgPath                      | ExpectedCount | ExpectedLinkingRuleCode |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx:0102:Announcement Date 1 | 010_Testing_Data.xlsx:0102:Announcement Date 2 | 2             | RULE_CODE_FROM_JSON      |

# C20250101A-0103 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0103 Linking Rule - Person Fails to Link Due to No Matching Group

  Scenario Outline: C20250101A-0103 Verify that a PERSON is marked as failed if they cannot match any GROUP based on their COMPANY info.

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "INVALID_CHANNEL_CODE"

    # Test Step 2: Insert the predefined linking rule for this test case.
    Given Insert component1 rule data with json "<RuleDataFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for this test case.
    Given Insert component1 overwrite rule data with json "<RuleDataFilePath>"

    # Test Step 4: Insert PERSON data with an invalid ChannelCode that does not match any COMPANY.
    Then Insert human info "<PersonMsgPath>" with person "-01023"

    # Test Step 5: Trigger COMPONENT1 processing for the PERSON.
    Then Trigger person "-01023" to component1 process

    # Test Step 6: Verify that the PERSON is marked as failed in the system.
    Then Verify person "-01023" status is "failed"

    # Test Step 7: Clear inserted linking rules, overwrite rules, and test data.
    Given Clear component1 config data with company "INVALID_CHANNEL_CODE"

    Examples:
      | RuleDataFilePath                  | PersonMsgPath                      |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data.xlsx:0102:invalid ChannelCode |
```