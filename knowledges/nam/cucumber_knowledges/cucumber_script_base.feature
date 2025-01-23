Feature:Ticket
1)Author:Jinyang
2)Workflow:
3)Check Point:
4)Key Value:
@Ticket @Regression @Group2
Scenario Outline:C162742-4286 Update ticket
# ***************************************************
# STEP 1:Operation Manager - Create Ticket
# ***************************************************
Given WebAgent open "$xmcNAMLoginPage"url
And Login SSo as "SopsManagel"
And Wait 5 seconds
And Login as "SopsManage1"
And WebAgent click on inboxIcon
And Wait 5 seconds
Then WebAgent click on createButton
And WebAgent click on newMessageItem
And Wait 5 seconds
Then WebAgent change to next tab
Then WebAgent is on newMessagePage
And Select "*GT CN XMC Loan Dev Test"from processingTeamDropdownlist
And Select "*GT CN XMC Loan Dev Test"from frompropdownlist
And WebAgent type "Jia,Bing Mango [OT-TECH]"into toText
And Wait 2 seconds
And Wait 2 seconds
And WebAgent click on searchValueItem
And WebAgent click on messageText
And WebAgent type "Guo,Qihua Jevons [OT-TECH]"into ccText
And Wait 2 seconds
And Wait 2 seconds
And WebAgent click on searchValueItem
And WebAgent click on messageText
And WebAgent type "Guo,Qihua
Jevons [OT-TECH]"into bccText
And Wait 2 seconds
And Wait 2 seconds
And WebAgent click on searchValueItem
And WebAgent click on messageText
Then Prepare Ticket Subject begin with "[XMC Test]UpdateTicket-"and Save into @ticketsubject
And WebAgent type "@ticketsubject.Value"into subjectText
And Wait 5 seconds
And WebAgent type "OTHER"into requestTypeDropdownlist
And Wait 2 seconds
And WebAgent click on searchValueItem
And WebAgent click on messageText
And WebAgent click on nextActionDate
And Wait 2 seconds
Then WebAgent click on nextActionDateToday
#select currency
And WebAgent type "HKD"into currencyDropdownlist
And Wait 2 seconds
And WebAgent click on searchValueItem
And WebAgent click on newMeassageText
#select facility
And WebAgent type "Facility dev test"into facilityDropdownlist
And Wait 2 seconds
And WebAgent click on searchValueItem
#select Effective Date=today
And WebAgent click on effectiveDate
And Wait 2 seconds
Then WebAgent click on effectiveDateToday
#input Contract or RID
And WebAgent type "001C001171880002"into contractNoOrRidText
#input Action Required
And WebAgent type "Approval Approved"into actionRequiredText
And WebAgent type "Mail Content,send from Web by script"into messageText
Then WebAgent click on sendButton
And Wait 10 seconds
Then WebAgent change to tab "XMC Loan"
Then WebAgent is on LoanPage
And Wait 60 seconds
And WebAgent click on allTicketsInbox
And Wait 20 seconds
And WebAgent click on clearUserPreferenceButton
And Wait 10 seconds
And Get Ticket ID by Subject "@ticketsubject.Value"and save into @ticketId
When Open ticket by ID "@ticketId.Value"
Then Wait 5 seconds
# ***************************************************
# STEP 2:Operation Manager - Check Ticket Details
# ***************************************************
Then WebAgent change to next tab
Then WebAgent is on workflowPage
And check "Currency"Ticketvalue is "HKD"
And check "Facility"Ticketvalue is "Facility dev test"
And check "Contract# or RID"Ticketvalue is "001C001171880002"
And check "Action Required"Ticketvalue is "Approval Approved"
# ***************************************************
# STEP 3:Operation Manager - update Ticket in ticket detail
# ***************************************************
Then WebAgent click on updateTicketAction
And WebAgent type "Payoff"into requestTypepropdownlist
And Select "Payoff"from requestTypeDropdownlist
And Select "1.Regression Tags"from tagspropdownlist
And select "YES"from todaysFundingDropdownlist
And select "Awaiting for Documents"from commentspropdownlis
And Select "Pending with Ao"from currentlyPendingwithDropdownlist
Then Clear Input Box "contractNoOrRidText"
And WebAgent type "001C001171880001"into contractNoOrRidText
And WebAgent type "C162742"into amcIDText
And WebAgent click on effectiveDate
And WebAgent click on chooseYearButton
And WebAgent click on selectoneYearButton
And WebAgent click on chooseMonthButton
And WebAgent click on selectoneMonthButton
And WebAgent click on select15thDayButton
And WebAgent click on nextActionDate
And WebAgent click on chooseYearButton
And WebAgent click on selectoneYearButton
And WebAgent click on chooseMonthButton
And WebAgent click on selectoneMonthButton
And WebAgent click on select15thDayButton
And Select "DKK"from currencyDropdownlist
#input Action Required
Then Clear Input Box "actionRequiredText"
And WebAgent type "Approval Rejected"into actionRequiredText
select Facility:CVR REFINING ABIE RC
And select "CVR REFINING ABTE RC"from facilitypropdowni
input Principal Amount:$RN6,input Fee Amouont:SRN3
And WebAgent type "1000000"into principalAmountText
And WebAgent type "10000"into feeAmountText
#input Fed Ref#:003C001591880001
And WebAgent type "003C001591880001"into fedRefText
Then WebAgent click on updateTicketButton
And Wait 4 seconds
# ***************************************************
# STEP 2:Operation Manager - Check Ticket Details
# ***************************************************
And check "Request Type"Ticketvalue is "Payoff"
And check "Tags"Ticketvalue is "1.Regression Tags"
And check "Todays Funding"Ticketvalue is "YES"
And check "Comments"Ticketvalue is "Awaiting for Documents"
And check "Currently Pending With"Ticketvalue is "Pending with AO"
And check "Contract or RID"Ticketvalue is "001C001171880001"
And check "AMC ID"Ticketvalue is "C162742"
And check "Effective Date"Ticketvalue is "2024-12-15"
And check "Next Action Date"Ticketvalue is "2024-12-15"
And check "Currency"TicketValue is "DKK"
And check "Action Required"Ticketvalue is "Approval Rejected"
And check "Facility"Ticketvalue is "CVR REFINING ABTF RC"
And check "Principal Amount"Ticketvalue is "1000000"
And check "Fee Amount"Ticketvalue is "10000"
And check "Fed Ref #Ticketvalue is "003C001591880001"
Then Wait 5 seconds
# ***************************************************
# STEP 2:Operation Manager - Close Ticket
# ***************************************************
Then WebAgent click on closeParentAction
Then Wait 1 seconds
Then WebAgent click
：onc1ase5 ubAct1am
Then Wait 5 seconds
Then check "Status"TicketValue is "Closed"
Then check "Sub Status"Ticketvalue is "Closed"
Then WebAgent click on expandAuditTrail
And Wait 1 seconds
Then Close Browser