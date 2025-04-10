```gherkin
Feature: Linking Rule - Two Persons Linked to One Resume
  Description: Verify that two PERSONS can link to the same RESUME if they meet the linking rule criteria, and validate the link count and linking rule code.
  Author: AI Assistant
  Test Case ID: TC_LINKING_RULE_001

  Scenario Outline: Two PERSONS linked to one RESUME when linking rule criteria are met
    # Preconditions: System is in a clean state.

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data. (Admin action)
    Given Clear component1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for this test case. (Admin action)
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule associated with COMPANY_0102. (Admin action)
    Given Insert component1 overwrite rule data with company "COMPANY_0102" and overwrite action "None"

    # Test Step 4: Insert PERSON1 data with ChannelCode "COMPANY_0102-DS_0102" and a unique Human Info Code. (Data Input action)
    Then Insert human info "<MsgPath1>" with person "-01021"

    # Test Step 5: Trigger COMPONENT1 to process PERSON1. (System action)
    Then Trigger person "-01021" to component1 process

    # Test Step 6: Verify RESUME created for PERSON1 (System Assertion)
    Then Get resume with person "-01021" into @resume1
    Then Verify resume "@resume1" is created

    # Test Step 7: Insert PERSON2 data with ChannelCode "COMPANY_0102-DS_0102", a different Human Info Code, and a different Announcement Date. (Data Input action)
    Then Insert human info "<MsgPath2>" with person "-01022"

    # Test Step 8: Trigger COMPONENT1 to process PERSON2. (System action)
    Then Trigger person "-01022" to component1 process

    # Test Step 9: Verify PERSON2 linked to PERSON1's RESUME (System Assertion)
    Then Get resume with person "-01022" into @resume2
    Then Compare resume "@resume1" with resume "@resume2"

    # Test Step 10: Get the count of PERSONS linked to the retrieved RESUME. (System action)
    Then Get count of person linked to resume "@resume1" into @actualpersonCount

    # Test Step 11: Get the linking rule code used to link PERSON2 to the RESUME. (System action)
    Then Get link rule code with person "-01022" into @actualLinkingrule

    # Test  Step 12: compare actual result with expected result (System Assertion)
    Then Compare "personCountLinkedToResume" actual "@actualpersonCount" with expected "<ExpectedPersonCount>" into @report1 and compare param type "number"
    Then Compare "LinkingRule" actual "@actualLinkingrule" with expected "<ExpectedLinkingRule>" into @report2 and compare param type "string"

    # Test Step 13: Clear existing linking rules, overwrite rules, and test data. (Admin action)
    Given Clear component1 config data with company "0102"

    # Test Step 14: generate result (System action)
    Then Generate report with "@report1"
    Then Generate report with "@report2"

    Examples:
      | RuleJsonModelFilePath | MsgPath1 | MsgPath2 | ExpectedPersonCount | ExpectedLinkingRule |
      | rule_001.json         | person_0102_1.json | person_0102_2.json | 2                   | RULE_001          |

Feature: Linking Rule - Person Fails to Link Due to No Matching Group
  Description: Verify that a PERSON is marked as failed if they cannot match any GROUP based on their COMPANY information.
  Author: AI Assistant
  Test Case ID: TC_LINKING_RULE_002

  Scenario Outline: Person fails to link due to no matching group because of no matching group
    # Preconditions: System is in a clean state.

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data. (Admin action)
    Given Clear component1 config data with company "0103"

    # Test Step 2: Insert a linking rule associated with a specific GROUP (e.g., GROUP_A). (Admin action)
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule associated with COMPANY_0103. (Admin action)
    Given Insert component1 overwrite rule data with company "COMPANY_0103" and overwrite action "None"

    # Test Step 4: Insert PERSON data with a ChannelCode that does not correspond to any existing GROUP (e.g., "COMPANY_0103-DS_0103", assuming no GROUP is associated with COMPANY_0103). (Data Input action)
    Then Insert human info "<MsgPath>" with person "-01031"

    # Test Step 5: Trigger COMPONENT1 to process the PERSON. (System action)
    Then Trigger person "-01031" to component1 process

    # Test Step 6: Verify PERSON marked as failed (System Assertion)
    Then Verify person "-01031" status is "failed"

    # Test Step 7: Clear existing linking rules, overwrite rules, and test data. (Admin action)
    Given Clear component1 config data with company "0103"

    Examples:
      | RuleJsonModelFilePath | MsgPath |
      | rule_002.json         | person_0103_1.json |
```