PROJECT_DOCUMENT = """
Common flow:
Upstream system will send PERSON to ProjectA,COMPONENT1 of ProjectA will process PERSON by linking rules and overwrite rule. COMPONENT1 will generate a RESUME if one PERSON can match linking rule and overwrite rule,will mark one PERSON failed if not.


detailed flow about linking rule:
1.look up matching GROUP associated with one COMPANY by PERSON info,if one PERSON can't match any GROUP, mark the PERSON failed,else go to step 2
- COMPANY info can be derived from filed of Human.ChannelCode,channelCode format is 'COMPANY_NUMBER-DS_NUMBER'
- example channelCode is COMPANY_0102-DS_0102,example COMPANY is COMPANY_0102
- number is from fCOMPONENT1ld 'Jira No.'provided in testing_data.xls
2.look up matching linking rule associated with the GROUP,if can match the linking rule,mark the PERSON failed, else go to step 3
3.look up matching linking criteria associated with the linking rule,look up existing RESUME using the linking criteria,link the PERSON to the RESUME if one RESUME can be found,else generating a new RESUME
"""
