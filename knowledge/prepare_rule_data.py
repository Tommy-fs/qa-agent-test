PREPARE_RULE_DATA_PROMPT = """

generate a new json for me by json schema and following blow needs

{rule_generation_prompt}

# General Rules:
1. **group**:  
   - A JSON rule file can contain multiple groups.  
   - Each group:  
    - Is associated with a company and linked to linking/overwrite rules.  
    - Must include the element 'ChannelCode' (default: 'JIRA_<JIRA_NUMBER>_COMPANY-DS<INDEX>_<JIRA_NUMBER>').

2. **Linking Rules**:  
   - A JSON rule file can have multiple linking rules.  
   - Each Linking Rule is associated with one or more groups.  
   - Each Linking Rule has a rank (higher rank = higher priority).  
   - Rank of common Linking Rule is higher than child Linking Rule.  
   - Each Linking Rule contains one or more linking criteria.  
   - Linking criteria also have ranks (higher rank = higher priority).  
   - **common Linking Rule**:  
	- Criteria elements compare PERSON values with RESUME values or limit PERSON element values.  
	- 'ISElemNullPermitted' means the element value can be null, default: false.  
	- Default criteria: elements: 'Identity', 'Language', 'EffectiveDate' (can be null), and 'Scope' (value = "earth").  
   - **Child Linking Rule**:  
    - Default criteria elements:  
		- 'Identity' of PERSON equals 'Identity' of RESUME.  
		- 'ParentPerson' of PERSON compared to 'ParentResume' of RESUME using the formula 'PERSONtoRESUME'.

3. **Overwrite Rules**:  
   - A JSON rule file can have multiple overwrite rules, each associated with one group and linked to multiple companies.  
   - **Ranking Settings**:  
    - Can set rank at Channel DC, Channel DCA, Company DC, and Company DCA levels. Set rank by providing DC/DCA and rank. Not inherit rank from parent DC.  
    - If a parent DC and its rank are provided:  
		- Do not include child DCs and their ranks under the same Overwrite Rule.  
		- Child DC ranks will be ignored unless explicitly required in the Overwrite Rule.  
    - Ranks range from 1 to 99 (higher rank = higher priority).  
    - If a second Overwrite Rule's DC rank is higher than the first, generate a higher rank for the second.
	- **'canCreate' Settings*:
	  - Defined at Channel Overwrite Rule level, Company Overwrite Rule level, Channel Overwrite Rule DC level, and Channel Overwrite Rule DCA level.
	  - Default value: 'true'.
	- **'useCentralRanking' Settings*:
	  - Defined at the Company Overwrite Rule level.
	  - Default value: 'true'.

4. **Naming Conventions**:
   - JIRA_NUMBER, example '11304'
   - 'ChannelCd': Replace the JIRA number in the format 'VS_<C20250101A_JIRA_NUMBER>_<INDEX>'.
	- If multiple groups are present, but the elements and values of the elements are the same, not update the index.
   - 'vlccd': Replace the JIRA number in the format 'VLCCD_<C20250101A_JIRA_NUMBER>_<INDEX>'.
   - 'vlscd': Replace the JIRA number in the format 'VLSCD_<C20250101A_JIRA_NUMBER>_<INDEX>'.
   - 'element under group: Replace the JIRA number in the format 'VSERL_<C20250101A_JIRA_NUMBER>_<INDEX>'.
   - 'elemCd' under criteriaList: Replace the JIRA number in the format 'CREIE_<C20250101A_JIRA_NUMBER>_<INDEX>'.
   - 'CompanyCd': Replace the JIRA number in the format 'JIRA_<JIRA_NUMBER>_Company'.
   - 'HumanDcaPath/ResumeDcaPath': Use the full path from the 'DC-DCA-Relation.json' file.
	- For example, if the DCA value is "Identity", complete the path as "HumanModel.HumanIdentityInfo.Identity".
   - Default value for 'ChannelCode': `JIRA_<C20250101A_JIRA_NUMBER>_CONFANY-DS<INDEX>_<JIRA_NUMBER>'.


5. **Validation Rules**:
   - Ensure the number of groups under `owRuleList` matches the number of overwrite rules.
   - If a group is associated with multiple linking rules, ensure all are included.

6. **Default Values**:
   - Use default values for unspecified elements as described above.

### json validation :
1. **Schema**
    - Validate generated JSON files using `000_RuleJsonModelSchema.json`.
    - Refer to `000_RuleData_Example.json` for structure.

### output :
1. **Output file**
    - Generate a JSON rule file based on the requirements without any manual intervention.
    - Replace the JIRA number in `000_RuleData_Example.json.json` with the provided JIRA number if only providing the jira number.
    - Validate the generated file using `000_RuleJsonModelSchema.json`.
    - File type: JSON

### Scenarios:
1. Example 1:
    - JIRA number: `999`.
    - group 1:
		- Elements: `ChannelCode`, `Language` (value: "CN").
		- Linking rules:
			- Rule 1: Criteria elements: `Identity`, `Skill1`, `EffectiveDate` (nullable).
			- Rule 2: Child linking.
    - group 2:




2. Example 2:
    - JIRA number: '19009'.
    - group 1:
		- Elements: 'ChannelCode', 'Language' (value: "CN").
		- linking rules:
			- Rule 1: Criteria elements: 'Identity', 'Skill1', 'EffectiveDate' (nullable).
			- Rule 2: Child linking.
		- Overwrite Rule 1
			- Channel DC rank
				- 'HumanModel',
					- 'Human', 80
					- 'HumanDates', 80
					- 'HumanClassification', 80
					- 'HumanResume', 80
					- 'HumanIdentifyingfo', 80
					- 'HumanAdditionalInfo', 80
					- 'HumanUpdateInfo',80
			- Channel DCA rank
				- HumanModel.Human
					- 'CanBeUpdated',
					- 'IsVirtual',
				- HumanModel.HumanDates
					  - 'EffectiveDate',
					  - 'BirthDate',
				- HumanModel.HumanClassification
					  - 'Nationality',
					  - 'Required',
					  - 'Language',
					  - 'Skill1',
					  - 'Skill2',
				- HumanModel.HumanIdentityInfo
					- 'Version',
				- HumanModel.HumanAdditionalInfo
					  - 'AdditionalCode',
					  - 'AdditionalValue',
				- HumanModel.HumanUpdateInfo
					  - 'UpdatedQualifier',
					  - 'OldValue',
					  - 'NewValue',
			- Company DC rank
				- 'HumanModel',
				  - 'Human',
				  - 'HumanDates',
				  - 'HumanClassification',
				  - 'HumanResume',
				  - 'HumanIdentityInfo',
				  - 'HumanAdditionalInfo',
				  - 'HumanUpdateInfo',
			- Company DCA rank
				- HumanModel.Human
				  - 'CanBeUpdated',
				  - 'IsVirtual',
				- HumanModel.HumanDates
				  - 'EffectiveDate',
				  - 'BirthDate',
				- HumanModel.HumanClassification
				  - 'Nationality',
				  - 'Required',
				  - 'Language',
				  - 'Skill1',
				  - 'Skill2',
				- HumanModel.HumanIdentityInfo
				  - 'Version',
				- HumanModel.HumanAdditionalInfo
				  - 'AdditionalCode',
				  - 'AdditionalValue',
				- HumanModel.HumanUpdateInfo
				  - 'UpdatedQualifier',
				  - 'OldValue',
				  - 'NewValue',												
	- group 2:
	- Linking Rule 3: Criteria elements: 'Identity', 'Language', 'EffectiveDate' (nullable), 'Scope' (value: "earth").
	- Overwrite Rule 2
		- Channel DC rank
			- 'HumanModel',
			  - 'Human', 85
			  - 'HumanDates', 85
			  - 'HumanClassification', 85
			  - 'HumanResume', 85
			  - 'HumanIdentityInfo', 85
			  - 'HumanAdditionalInfo', 85
			  - 'HumanUpdateInfo',85
		- Channel DCA rank
			- HumanModel.Human
			  - 'CanBeUpdated',
			  - 'IsVirtual',
			- HumanModel.HumanDates
			  - 'EffectiveDate',
			  - 'BirthDate',
			- HumanModel.HumanClassification
			  - 'Nationality',
			  - 'Required',
			  - 'Language',
			  - 'Skill1',
			  - 'Skill2',
			- HumanModel.HumanIdentityInfo
			  - 'Version',
			- HumanModel.HumanAdditionalInfo
			  - 'AdditionalCode',
			  - 'AdditionalValue',
			- HumanModel.HumanUpdateInfo
			  - 'UpdatedQualifier',
			  - 'OldValue',
			  - 'NewValue',
		- Company DC rank
			- 'HumanModel',
			  - 'Human',
			  - 'HumanDates',
			  - 'HumanClassification',
			  - 'HumanResume',
			  - 'HumanIdentityInfo',
			  - 'HumanAdditionalInfo',
			  - 'HumanUpdateInfo',
		- Company DCA rank
			- HumanModel.Human
			  - 'CanBeUpdated',
			  - 'IsVirtual',
			- HumanModel.HumanDates
			  - 'EffectiveDate',
			  - 'BirthDate',
			- HumanModel.HumanClassification
			  - 'Nationality',
			  - 'Required',
			  - 'Language',
			  - 'Skill1',
			  - 'Skill2',
			- HumanModel.HumanIdentityInfo
			  - 'Version',
			- HumanModel.HumanAdditionalInfo
			  - `AdditionalCode',
			  - `AdditionalValue',
			- HumanModel.HumanUpdateInfo
			  - `UpdatedQualifier',
			  - `OldValue',
			  - `NewValue',
			  
# RuleJsonModelschema.json #

{rule_json_model_schema}

# RuleData.json #

{rule_data}
"""
