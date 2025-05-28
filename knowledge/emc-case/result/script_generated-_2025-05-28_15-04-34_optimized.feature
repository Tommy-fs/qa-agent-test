```gherkin
# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: LinkingLogic-001
  Verify VIN linking to existing CAIN based on linking strategy and prevent duplicate CAIN creation.
  This test case verifies that a VIN is correctly linked to an existing CAIN based on predefined linking rules and prevents the creation of duplicate CAINs. It also validates the versioning of the CAIN when new VINs with different attributes are linked.
  Author: Your Name
  Jira: 0102

  Scenario Outline: Linking VIN to existing CAIN and versioning
    # Description: This scenario verifies that a VIN is linked to an existing CAIN, and the CAIN is versioned correctly when a second VIN with different attributes is linked.

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    # As a tester, I want to clear existing COMPONENT1 config data for company "0102" to ensure a clean test environment.
    Given Clear COMPONENT1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for the specific COMPANY (derived from ChannelCode).
    # As a tester, I want to insert COMPONENT1 rule data from json file "<RuleJsonModelFilePath>" to define the linking strategy.
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for the specific COMPANY (derived from ChannelCode).
    # As a tester, I want to insert COMPONENT1 overwrite rule data from json file "<RuleJsonModelFilePath>" to define the overwrite strategy.
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 4: Insert an existing CAIN.
    # As a tester, I want to insert an existing CAIN using data from "<CainDataPath>" with PERSON "-01021" to simulate an existing CAIN record.
    Then Insert channel data "<CainDataPath>" with PERSON "-01021"

    # Test Step 5: Insert a VIN with matching criteria to the existing CAIN and ChannelCode 'COMPANY_0102-DS_0102'.
    # As a tester, I want to insert a VIN with matching criteria using data from "<VinDataPath1>" with PERSON "-01022" to link to the existing CAIN.
    Then Insert channel data "<VinDataPath1>" with PERSON "-01022"

    # Test Step 6: Trigger COMPONENT1 process for the VIN.
    # As a system, I want to trigger COMPONENT1 process for PERSON "-01022" to initiate the linking process.
    Then Trigger PERSON "-01022" to COMPONENT1 process

    # Test Step 7: Check the VIN status.
    # As a tester, I want to get the status of PERSON "-01022" and store it in @vinStatus1 to verify the processing status.
    Then Get status with PERSON "-01022" into @vinStatus1
    # As a tester, I want to verify that the VIN status is "Completed".
    Then @vinStatus1 should be "Completed"

    # Test Step 8: Retrieve the count of CAINs.
    # As a tester, I want to retrieve the count of CAINs with CHANNEL_CODE 'COMPANY_0102-DS_0102' and store it in @cainCount1 to ensure no duplicate CAINs are created.
    Then Get count "CAIN" from table "CAIN_TABLE" where "CHANNEL_CODE"='COMPANY_0102-DS_0102' into @cainCount1
    # As a tester, I want to verify that the CAIN count is 1.
    Then @cainCount1 should be 1

    # Test Step 9: Retrieve the count of VINs linked to the CAIN.
    # As a tester, I want to retrieve the count of PERSONs linked to the RESUME associated with PERSON "-01021" and store it in @vinCount1 to verify the linking.
    Then Get count of PERSON linked to RESUME with PERSON "-01021" into @vinCount1
    # As a tester, I want to verify that the VIN count linked to the CAIN is 2.
    Then @vinCount1 should be 2

    # Test Step 10: Retrieve the CAIN version.
    # As a tester, I want to retrieve the version of the CAIN associated with PERSON "-01021" and store it in @cainVersion1 to verify the initial version.
    Then Get PERSON version with PERSON "-01021" into @cainVersion1
    # As a tester, I want to verify that the CAIN version is 1.
    Then @cainVersion1 should be 1

    # Test Step 11: Insert a second VIN with matching criteria to the existing CAIN, different attributes impacting versioning, and ChannelCode 'COMPANY_0102-DS_0102'.
    # As a tester, I want to insert a second VIN with matching criteria using data from "<VinDataPath2>" with PERSON "-01023" to trigger versioning.
    Then Insert channel data "<VinDataPath2>" with PERSON "-01023"

    # Test Step 12: Trigger COMPONENT1 process for the second VIN.
    # As a system, I want to trigger COMPONENT1 process for PERSON "-01023" to initiate the versioning process.
    Then Trigger PERSON "-01023" to COMPONENT1 process

    # Test Step 13: Check the second VIN status.
    # As a tester, I want to get the status of PERSON "-01023" and store it in @vinStatus2 to verify the processing status of the second VIN.
    Then Get status with PERSON "-01023" into @vinStatus2
    # As a tester, I want to verify that the second VIN status is "Completed".
    Then @vinStatus2 should be "Completed"

    # Test Step 14: Retrieve the count of CAINs.
    # As a tester, I want to retrieve the count of CAINs with CHANNEL_CODE 'COMPANY_0102-DS_0102' and store it in @cainCount2 to ensure no duplicate CAINs are created.
    Then Get count "CAIN" from table "CAIN_TABLE" where "CHANNEL_CODE"='COMPANY_0102-DS_0102' into @cainCount2
    # As a tester, I want to verify that the CAIN count is 1.
    Then @cainCount2 should be 1

    # Test Step 15: Retrieve the count of VINs linked to the CAIN.
    # As a tester, I want to retrieve the count of VINs linked to the CAIN associated with PERSON "-01021" and store it in @vinCount2 to verify the linking.
    Then Get count of PERSON linked to RESUME with PERSON "-01021" into @vinCount2
    # As a tester, I want to verify that the VIN count linked to the CAIN is 3.
    Then @vinCount2 should be 3

    # Test Step 16: Retrieve the CAIN version.
    # As a tester, I want to retrieve the version of the CAIN associated with PERSON "-01021" and store it in @cainVersion2 to verify the versioning.
    Then Get PERSON version with PERSON "-01021" into @cainVersion2
    # As a tester, I want to verify that the CAIN version is 2.
    Then @cainVersion2 should be 2

    # Test Step 17: Clear existing linking rules, overwrite rules, and test data.
    # As a tester, I want to clear existing COMPONENT1 config data for company "0102" to ensure a clean test environment for subsequent tests.
    Given Clear COMPONENT1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath | CainDataPath | VinDataPath1 | VinDataPath2 |
      | 000_RuleJsonModelSchema.json | 010_Testing_Data.xlsx | 010_Testing_Data.xlsx | 010_Testing_Data.xlsx |

# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: LinkingLogic-002
  Verify VIN processing when no matching CAIN exists.
  This test case verifies that a new CAIN is created when a VIN is processed and no matching CAIN exists based on the linking rules.
  Author: Your Name
  Jira: 0102

  Scenario Outline: VIN processing when no matching CAIN exists
    # Description: This scenario verifies that a new CAIN is created when a VIN is processed and no matching CAIN exists.

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    # As a tester, I want to clear existing COMPONENT1 config data for company "0102" to ensure a clean test environment.
    Given Clear COMPONENT1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for the specific COMPANY (derived from ChannelCode).
    # As a tester, I want to insert COMPONENT1 rule data from json file "<RuleJsonModelFilePath>" to define the linking strategy.
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for the specific COMPANY (derived from ChannelCode).
    # As a tester, I want to insert COMPONENT1 overwrite rule data from json file "<RuleJsonModelFilePath>" to define the overwrite strategy.
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 4: Insert a VIN with ChannelCode 'COMPANY_0102-DS_0102' that does *not* match any existing CAIN.
    # As a tester, I want to insert a VIN that does not match any existing CAIN using data from "<VinDataPath>" with PERSON "-01021" to simulate a scenario where a new CAIN should be created.
    Then Insert channel data "<VinDataPath>" with PERSON "-01021"

    # Test Step 5: Trigger COMPONENT1 process for the VIN.
    # As a system, I want to trigger COMPONENT1 process for PERSON "-01021" to initiate the CAIN creation process.
    Then Trigger PERSON "-01021" to COMPONENT1 process

    # Test Step 6: Check the VIN status.
    # As a tester, I want to get the status of PERSON "-01021" and store it in @vinStatus to verify the processing status.
    Then Get status with PERSON "-01021" into @vinStatus
    # As a tester, I want to verify that the VIN status is "Completed".
    Then @vinStatus should be "Completed"

    # Test Step 7: Retrieve the count of CAINs.
    # As a tester, I want to retrieve the count of CAINs with CHANNEL_CODE 'COMPANY_0102-DS_0102' and store it in @cainCount to ensure a new CAIN is created.
    Then Get count "CAIN" from table "CAIN_TABLE" where "CHANNEL_CODE"='COMPANY_0102-DS_0102' into @cainCount
    # As a tester, I want to verify that the CAIN count is 1.
    Then @cainCount should be 1

    # Test Step 8: Retrieve the count of VINs linked to the newly created CAIN.
    # As a tester, I want to retrieve the count of VINs linked to the newly created CAIN associated with PERSON "-01021" and store it in @vinCount to verify the linking.
    Then Get count of PERSON linked to RESUME with PERSON "-01021" into @vinCount
    # As a tester, I want to verify that the VIN count linked to the newly created CAIN is 1.
    Then @vinCount should be 1

    # Test Step 9: Retrieve the CAIN version.
    # As a tester, I want to retrieve the version of the CAIN associated with PERSON "-01021" and store it in @cainVersion to verify the initial version.
    Then Get PERSON version with PERSON "-01021" into @cainVersion
    # As a tester, I want to verify that the CAIN version is 1.
    Then @cainVersion should be 1

    # Test Step 10: Clear existing linking rules, overwrite rules, and test data.
    # As a tester, I want to clear existing COMPONENT1 config data for company "0102" to ensure a clean test environment for subsequent tests.
    Given Clear COMPONENT1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath | VinDataPath |
      | 000_RuleJsonModelSchema.json | 010_Testing_Data.xlsx |
```