```gherkin
# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Linking Rule Logic - 0102

  Scenario Outline: Verify two PERSONS can link to one RESUME if they meet the same linking rule and criteria.

    # Test Step 1: Clear existing rules and data
    Given Clear component1 config data with company "0102"

    # Test Step 2: Insert linking rule VLSCD_C20250101A_0102_1 and overwrite rules as defined in 001_C20250101A-0102_RuleData.json
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert two PERSON records with different Human.IdentityInfo.Identity but the same Human.ChannelCode (derived from COMPANY_0102), and other required fields as defined in the Jira request and 010_Testing_Data.xlsx. Ensure both PERSONS match the linking rule criteria.
    Then Insert human info "<MsgPath1>" with person "01021"
    Then Insert human info "<MsgPath2>" with person "01022"

    # Test Step 4: Trigger COMPONENT1 process for both PERSON records.
    Then Trigger person "01021" to component1 process
    Then Trigger person "01022" to component1 process

    # Test Step 5: Retrieve the RESUME linked to the first PERSON and store it in RESUMEVariable1.
    Then Get resume with person "01021" into @resume1

    # Test Step 6: Retrieve the RESUME linked to the second PERSON and store it in RESUMEVariable2.
    Then Get resume with person "01022" into @resume2

    # Test Step 7: Compare RESUMEVariable1 and RESUMEVariable2.
    Then Compare "resume" actual "@resume1" with expected "@resume2" into @report1 and compare param type "string"

    # Test Step 8: Get the count of PERSONS linked to RESUME in RESUMEVariable1 and store it in actualCountVariable.
    Then Get count of person linked to resume "@resume1" into @actualpersonCount

    # Test Step 9: Get the status of both PERSON records and store them in actualStatus, separated by ','.
    Then Get status of person "01021" into @status1
    Then Get status of person "01022" into @status2
    Then Set variable "@actualStatus" with value "@{status1},@{status2}"

    # Test Step 10: Check the count of PERSONS linked to the RESUME. Compare actualCountVariable with expected result '2'.
    Then Compare "personCountLinkedToResume" actual "@actualpersonCount" with expected "<ExpectedPersonCount>" into @report2 and compare param type "number"

    # Test Step 11: Check the status of both PERSON records. Compare actualStatus with expected result 'completed,completed'.
    Then Compare "personStatus" actual "@actualStatus" with expected "<ExpectedStatus>" into @report3 and compare param type "string"

    # Test Step 12: Clear inserted rules and data.
    Given Clear component1 config data with company "0102"

    # Generate report
    Then Generate report with "@report1"
    Then Generate report with "@report2"
    Then Generate report with "@report3"

    Examples:
      | RuleJsonModelFilePath          | MsgPath1 | MsgPath2 | ExpectedPersonCount | ExpectedStatus          |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data_PERSON1.xlsx | 010_Testing_Data_PERSON2.xlsx | 2 | completed,completed |

# C20250101A-0102-Negative @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: C20250101A-0102 Negative Test - Linking Rule Logic - 0102 - Negative Test - Different Criteria

  Scenario Outline: Verify two PERSONS with different criteria link to different RESUMEs.

    # Test Step 1: Clear existing rules and data
    Given Clear component1 config data with company "0102"

    # Test Step 2: Insert linking rule VLSCD_C20250101A_0102_2 and overwrite rules as defined in 001_C20250101A-0102_RuleData.json
    Given Insert component1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert two PERSON records with different Human.IdentityInfo.Identity and different Human.Classification.Required but the same Human.ChannelCode (derived from COMPANY_0102), and other required fields as defined in the Jira request and 010_Testing_Data.xlsx. Ensure both PERSONS match the linking rule criteria.
    Then Insert human info "<MsgPath1>" with person "01021"
    Then Insert human info "<MsgPath2>" with person "01022"

    # Test Step 4: Trigger COMPONENT1 process for both PERSON records.
    Then Trigger person "01021" to component1 process
    Then Trigger person "01022" to component1 process

    # Test Step 5: Retrieve the RESUME linked to the first PERSON and store it in RESUMEVariable1.
    Then Get resume with person "01021" into @resume1

    # Test Step 6: Retrieve the RESUME linked to the second PERSON and store it in RESUMEVariable2.
    Then Get resume with person "01022" into @resume2

    # Test Step 7: Compare RESUMEVariable1 and RESUMEVariable2.
    Then Compare "resume" actual "@resume1" with expected "@resume2" into @report1 and compare param type "string" and expected "false"

    # Test Step 8: Get the count of PERSONS linked to RESUME in RESUMEVariable1 and store it in actualCountVariable1.
    Then Get count of person linked to resume "@resume1" into @actualpersonCount1

    # Test Step 9: Get the count of PERSONS linked to RESUME in RESUMEVariable2 and store it in actualCountVariable2.
    Then Get count of person linked to resume "@resume2" into @actualpersonCount2

    # Test Step 10: Get the status of both PERSON records and store them in actualStatus, separated by ','.
    Then Get status of person "01021" into @status1
    Then Get status of person "01022" into @status2
    Then Set variable "@actualStatus" with value "@{status1},@{status2}"

    # Test Step 11: Check the count of PERSONS linked to each RESUME. Compare actualCountVariable1 and actualCountVariable2 with expected result '1'.
    Then Compare "personCountLinkedToResume1" actual "@actualpersonCount1" with expected "<ExpectedPersonCount>" into @report2 and compare param type "number"
    Then Compare "personCountLinkedToResume2" actual "@actualpersonCount2" with expected "<ExpectedPersonCount>" into @report3 and compare param type "number"

    # Test Step 12: Check the status of both PERSON records. Compare actualStatus with expected result 'completed,completed'.
    Then Compare "personStatus" actual "@actualStatus" with expected "<ExpectedStatus>" into @report4 and compare param type "string"

    # Test Step 13: Clear inserted rules and data.
    Given Clear component1 config data with company "0102"

    # Generate report
    Then Generate report with "@report1"
    Then Generate report with "@report2"
    Then Generate report with "@report3"
    Then Generate report with "@report4"

    Examples:
      | RuleJsonModelFilePath          | MsgPath1 | MsgPath2 | ExpectedPersonCount | ExpectedStatus          |
      | 001_C20250101A-0102_RuleData.json | 010_Testing_Data_PERSON1.xlsx | 010_Testing_Data_PERSON2.xlsx | 1 | completed,completed |
```