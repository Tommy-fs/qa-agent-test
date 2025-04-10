# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102

  Scenario Outline: C20250101A0102 integration testing : component1 : linking rule : group rank : case 2

    # Test Step 1: clear data
    Given Clear component1 config data with company "0102"

    # Test Step 2: init table
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert new person1
    Then Insert human info "<MsgPath>" with person "01021"

    # Test Step 4: trigger component1 process
    Then Trigger person "01021" to component1 process

    # Test Step 5: get resume according to person1
    Then Get resume with person "01021" into @resume1

    # Test Step 6: Insert new person2
    Then Insert human info "<MsgPath>" with person "01022"

    # Test Step 7: trigger component1 process
    Then Trigger person "01022" to component1 process

    # Test Step 8: get resume according to person2
    Then Get resume with person "01022" into @resume2

    # Test Step 9: get actual result
    Then Get count of person linked to resume "@resume2" into @actualpersonCount
    Then Get link rule code with person "01022" into @actualLinkingrule

    # Test  Step 10: compare actual result with expected result
    Then Compare "personCountLinkedToResume" actual "@actualpersonCount" with expected "<ExpectedPersonCount>" into @report1 and compare param type "number"
    Then Compare "LinkingRule" actual "@actualLinkingrule" with expected "<ExpectedLinkingRule>" into @report2 and compare param type "string"

    # Test Step 11: clear data
    Given Clear component1 config data with company "0102"

    # Test Step 12: generate result
    Then Generate report with "@report1"
    Then Generate report with "@report2"

    Examples:
      | RuleJsonModelFilePath          | MsgPath | ExpectedPersonCount | ExpectedLinkingRule |
      # @CommonExternalDataProvider:emc.test.data.commonDataProvider:C20250101A-0102