GENERATE_RULE_DATA_PROMPT = """
Prepare a json file, jira number is {jira_number}

generate a new json for me by json schema and following blow needs

1. logic of data
-common set
    -- one ison rule file can have multi group which are associated with CoMpANy, then associated with linking rule and Overwrite Rule

-linking rule
    --one json rule file can have multi linking rules which can be associated with one group or multi group
    --every linking rule has rank, higher rank higher priority
    --every linking rule has one or more linking criteria
    --every linking criteria has rank, higher rank higher priority

-Overwrite Rule
    --one json rule file can have multi overwrite rules--
    --one Overwrite Rule is only associated with one common set
    --one Overwrite Rule can be associated with multi COMPANY

-"canCreate" setting
    --set at common Overwrite Rule level, cowpANy Overwrite Rule level, common Overwrite Rule oc level. common Overwrite kule bcA level

-"useCentralRanking" setting
    --set at COMPANY Overwrite Rule level

-rang of rank,from 1to 99,higher rank higher priority

2. rules
-without any code

-output format
    --json

-json schema
    --RuleJsonModelschema.json,generate the json file according to this schema
-example
    --001 C20250101A-0102 RuleData.json,generate the json file according to this example
    --keep the file structure of RuleData.json if i only provide the jira number
-priority of provided rules
    --if provided rules are conflict with each other, higher priority take precedence
    --higher rank higher priority
    --default rank 10 if not provided
-output file
    --just copy RuleData.json if only providing the jira number
    --if a child linking rule is missing for a group, automatically add a default child linking rule
    --validate the json file according to RuleJsonModelschema.json
    --priority，99

-priority,rank of special rule is higher than common rule

-naming convention
    --common rule
        --if haPERsONg multi below elements, just need to update the last number which logic is to add one to the original number
        --replace number 0102 in below name by provided jira number
    -special rule
        --if haPERsONg multi group nodes, not update the groupcd if the elementlists in both group are same(ignore the order of elemcd)
        --if hapERsONg multi param value asociated to "HumanModel.Human.channelcode", update the last number of "DS1" which logic is to add one to the original number

    -VISLd-> Tor eXamDIe, VLSCD C20250I0IA 6I02 1, VLSCD (20250101A 0102 2, only need to replace 0102 by provided Tira number
    -groupcd-> for example, Vs C20258101A 0102 1,VS C20258101A 0102 2, only need to replace 0102 by provided jira number
    -COMPANVCd->for example, JIRA 0102 COMPANY, only need to replace 0102 by provided jira number
    -elemcd under group ->for example, VSELE C20258101A 8182 1, VSELE C28258101A 0102 2, only need to replace 8182 by provided jira number
    -elemcd under criterialist ->for example, CRELE C20250101A 8102 1, CRELE C20250101A 0102 2, only ned to replace 8182 by provided ira number
    -vlccd->for example, VLCCD C28258181A 8102 1, VLCCD C20258101A 8102 2, only need to replace 8102 by provided jira number

-PERSONDcaPath/RESUMEDcaPath, refer to file 000_DC_DCA_DEF.xlsx
    - if I input one DCA value, such as Identity, you need to complete the entire path "HumanModel. HumanIdentityInfo. Identity"

-for common set elements
    -- using provided values, else using default values
    -- for special element "ChannelCode", default value format is "JIRA_0102_COMPANY-DS1_0102", for example, "JIRA_0102_COMPANY-DS1_0102",
    "JIRA_0102_COMPANY-DS2_0102", replace the 0102 by provided jira number
- for linking rule
    -- rank of common linking rule is higher than child linking rule
    -- default linking rule is common linking rule if I don't provide the type of linking rule

- for link criteria elements of common linking rule, using provided values, else using default values; compare values of PERSON with corresponding values
of RESUME or limit element value of PERSON
    -- compare value in PERSON with value in RESUME, for example, Identity value of PERSON is equal to value of RESUME
    -- limit value in PERSON, for example, "OriginLevel" value in PERSON is "GLOBAL"
    -- value of each element maybe not null, so "isElemNullPermitted" is false else "isElemNullPermitted" is true; if i don't clarify the value can be null, "isElemNullPermitted" default to false

- for link criteria elements of child linking rule, default to using two elements
    -- Identity of PERSON is equal to Identity of RESUME
    -- using formula "PERSONtoRESUME" to compare ParentHumanPERSON of PERSON with ParentHumanPERSON of RESUME

-"canCreate"setting
    -- using provided value, default is true
    -- each set DC/DCA rank will have this setting

-"useCentralRanking"setting
    -- using provided value, default is true
    -- Overwrite Rule at company level will have this setting

-ranking setting
    -- ad one DC/DCA under one Overwrite Rule at common level or company level and set the rank for the DC/DCA, set rank by provided DC/DCA and level and rank
    -- default to set common DC rank for DC Human, Dates, "HumanClassification", "HumanResume", "HumanIdentityInfo", "HumanHierarchicalRelation","HumanUpdateInfo"

-- default to not set rank for common level DCA and company level DC/DCA

-ranking
    -- rank of linking rule, for linking rule which is associated with one group, rank of child linking rule is lower than common linking rule

3. scenarios
3.1 scenario 1， if I type the json file has 3 link rules, check the number of vlsCd which should be equal to 3， if not, adding new linking rule
3.2 scenario 2， if I type the json file has 3 ow rules, check the number of group under owstrategyList which should be equal to 3， if not, adding new owstrategy
3.3 scenario 3， if I type one group and two link rules, it means the group is associated with two link rules;
if I type two group and two link rules, it means each group is associated with each link rules;
3.4 scenario 4， if I type set rank for root DC, it means add dcPath "HumanModel"; if I type set rank for one DC, it means add whole dcPath for the DC
3.5 scenario 5， if I type set rank for one DCA, it means add whole dcpath for the DCA
3.6 scenario 6， if I type set rank at common level for one DC/DCA, it means add whole dcpath for the DC/DCA at common level (under
owStrategylist. dcRankList or owStrategyList.dcaRankList)
3.7 scenario 7， if I type set rank at company level for one DC/DCA, it means add whole dcPath for the DC/DCA at company level (under
owStrategyList.companyOwStrategyList.dcRankListorowStrategyList.companyOwStrategyList.dcaRankList)

4. example, below examples can generate the provided RuleData.json according to json schema, logic of data and rules
- example 1
    - jira number, 999
    - two group, group1 and group2
        - group1, two elements, elements are ChannelCode and Language, value of Language is "EN"; the group is associated with company (provide multi company in future)
            - linking rule 1(common linking rule) and linking rule 2(child linking rule) are associated with group1
                - linking rule 1 criteria elements, three elements, "Identity"+"Skill1"+"EffectiveDate"(can be null)
            - Overwrite Rule 1 is associated with group1
                - one company is associated with Overwrite Rule 1
                - rank setting
                    - common DC, set rank 80
                    - common DCA, not configure
                    - company DC, not configure
                    - company DCA, not configure

        -group2, one element, element is ChannelCode
            - linking rule 3(common linking rule) is associated with group2
                - linking rule 3 criteria elements, three elements, "Identity"+"Language"+"EffectiveDate"(can be null)+"Scope"(value is "earth")
            - Overwrite Rule 2 is associated with group2
                - one company is associated with Overwrite Rule 12
                - rank setting
                    - common DC, set rank 85
                    - common DCA, not configure
                    - company DC, not configure
                    - company DCA, not configure

-example 2
    -jira number, 999
    - common set 1， elements are ChannelCode and Language (value is "EN");
        - linking rule 1， criteria elements are "Identity"+"Skill1"+"EffectiveDate"(can be null)
        - linking rule 2， child linking
        - Overwrite Rule 1， set common DC rank as 80
    - common set 2，
        - linking rule 3， criteria elements are "Identity"+"Language"+"EffectiveDate"(can be null)+"OriginLevel"(value is "global")
        - Overwrite Rule 2， set common DC rank as 85

# RuleJsonModelschema.json #

{rule_json_model_schema}

# RuleData.json #

{rule_data}
"""
