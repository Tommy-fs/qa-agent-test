```gherkin
# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: LinkingLogic-001
  Verify VIN linking to existing CAIN based on linking strategy and prevent duplicate CAIN creation.

  Scenario Outline: Linking VIN to existing CAIN and versioning

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear COMPONENT1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for the specific COMPANY (derived from ChannelCode).
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for the specific COMPANY (derived from ChannelCode).
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 4: Insert an existing CAIN.
    Then Insert channel data "<CainDataPath>" with PERSON "-01021"

    # Test Step 5: Insert a VIN with matching criteria to the existing CAIN and ChannelCode 'COMPANY_0102-DS_0102'.
    Then Insert channel data "<VinDataPath1>" with PERSON "-01022"

    # Test Step 6: Trigger COMPONENT1 process for the VIN.
    Then Trigger PERSON "-01022" to COMPONENT1 process

    # Test Step 7: Check the VIN status.
    Then Get status with PERSON "-01022" into @vinStatus1

    # Test Step 8: Retrieve the count of CAINs.
    Then Get count "CAIN" from table "CAIN_TABLE" where "CHANNEL_CODE"="COMPANY_0102-DS_0102" into @cainCount1

    # Test Step 9: Retrieve the count of VINs linked to the CAIN.
    Then Get count of PERSON linked to RESUME "-01021" into @vinCount1

    # Test Step 10: Retrieve the CAIN version.
    Then Get PERSON version with PERSON "-01021" into @cainVersion1

    # Test Step 11: Insert a second VIN with matching criteria to the existing CAIN, different attributes impacting versioning, and ChannelCode 'COMPANY_0102-DS_0102'.
    Then Insert channel data "<VinDataPath2>" with PERSON "-01023"

    # Test Step 12: Trigger COMPONENT1 process for the second VIN.
    Then Trigger PERSON "-01023" to COMPONENT1 process

    # Test Step 13: Check the second VIN status.
    Then Get status with PERSON "-01023" into @vinStatus2

    # Test Step 14: Retrieve the count of CAINs.
    Then Get count "CAIN" from table "CAIN_TABLE" where "CHANNEL_CODE"="COMPANY_0102-DS_0102" into @cainCount2

    # Test Step 15: Retrieve the count of VINs linked to the CAIN.
    Then Get count of PERSON linked to RESUME "-01021" into @vinCount2

    # Test Step 16: Retrieve the CAIN version.
    Then Get PERSON version with PERSON "-01021" into @cainVersion2

    # Test Step 17: Clear existing linking rules, overwrite rules, and test data.
    Given Clear COMPONENT1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath | CainDataPath | VinDataPath1 | VinDataPath2 |
      | 000_RuleJsonModelSchema.json | 010_Testing_Data.xlsx | 010_Testing_Data.xlsx | 010_Testing_Data.xlsx |

# C20250101A-0102 @projectA-component1-link-regression @projectA-component1-link @projectA
Feature: LinkingLogic-002
  Verify VIN processing when no matching CAIN exists.

  Scenario Outline: VIN processing when no matching CAIN exists

    # Test Step 1: Clear existing linking rules, overwrite rules, and test data.
    Given Clear COMPONENT1 config data with company "0102"

    # Test Step 2: Insert the predefined linking rule for the specific COMPANY (derived from ChannelCode).
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 3: Insert the predefined overwrite rule for the specific COMPANY (derived from ChannelCode).
    Given Insert COMPONENT1 rule data with json "<RuleJsonModelFilePath>"

    # Test Step 4: Insert a VIN with ChannelCode 'COMPANY_0102-DS_0102' that does *not* match any existing CAIN.
    Then Insert channel data "<VinDataPath>" with PERSON "-01021"

    # Test Step 5: Trigger COMPONENT1 process for the VIN.
    Then Trigger PERSON "-01021" to COMPONENT1 process

    # Test Step 6: Check the VIN status.
    Then Get status with PERSON "-01021" into @vinStatus

    # Test Step 7: Retrieve the count of CAINs.
    Then Get count "CAIN" from table "CAIN_TABLE" where "CHANNEL_CODE"="COMPANY_0102-DS_0102" into @cainCount

    # Test Step 8: Retrieve the count of VINs linked to the newly created CAIN.
    Then Get count of PERSON linked to RESUME "-01021" into @vinCount

    # Test Step 9: Retrieve the CAIN version.
    Then Get PERSON version with PERSON "-01021" into @cainVersion

    # Test Step 10: Clear existing linking rules, overwrite rules, and test data.
    Given Clear COMPONENT1 config data with company "0102"

    Examples:
      | RuleJsonModelFilePath | VinDataPath |
      | 000_RuleJsonModelSchema.json | 010_Testing_Data.xlsx |
```