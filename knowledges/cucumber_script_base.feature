Feature:INDIA EM WORKFLOW
  Workflow Detail:
  1)Author:Jevons
  2)Workflow Type:Booking Workflow
  3)DL:*ICG APAC IND SYSTEM DL

  @indiaemail
  Scenario Outline:C162742-11276 INDIA_Booking_Workflow With Reject

    Given WebAgent open "SxmcIndiaLoginPage"url
#**************************************************************
#  STEP 1:Operation Manager Create New Message in SYSTEM Web
#*************************************************************
    When Login as "$Operation Manager India"
    Then WebAgent is on InboxModule
    Then WebAgent click on createButton
    And WebAgent click on newMessageItem
    And Wait 5 seconds
    Then WebAgent change to next tab

    And Select "*ICG APAC IND SYSTEM DL"from mailFrompropdownlist
    And WebAgent type "Guo,Qihua Jevons [TECH]"into mailToText
    Then WebAgent click on mailAddressoption
    And Wait 1 seconds
    And WebAgent click on mailContentText

    And WebAgent type "Mail Content,send from Web by script ---India Booking Workflow"into mailContentText
    And WebAgent type "[SYSTEM Test]Auto-India Booking Workflow with Reject $TodayDate $RN3"into mailSubjectText
    Then WebAgent click on mailSendButton
    And Wait 5 seconds
    Then Close Browser

#***************************************************************
#  STEP 2:Operation Manager Save Ticket ID
#***************************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation_Manager_India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 20 seconds
    And Get Ticket ID by Subject "[SYSTEM Test]Auto-India Booking Workflow With Reject"and save into @ticketId
#**************************************************************
#  STEP 3:Operation Manager Update Ticket
#*************************************************************
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    And WebAgent click on updateTicketButton
    Then Wait 3 seconds

    Then Select "<Request Type>"from requestTypeDropdownlist
    Then Select "<Currency>"from currencyDropdownList
    And WebAgent type "<Amount>"into amountText
    And WebAgent type "<Base No>"into baseNoText
    And WebAgent type "<Client Name>"into clientNameText
    And WebAgent type "<Flexcube Ref no>"into flexcubeRefnoText
    And WebAgent type "<Cosmos Ref no>"into cosmosRefnoText
    Then Select "<Branch>"from branchDropdownList
    Then Select "<Client Segment>"from clientSegmentDropdownList
    Then Select "<Payment Type>"from paymentTypeDropdownList

    Then WebAgent click on submitButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "Assigned to Maker"


#***************************************************************
#  STEP 4:Operation Manager Assign To User
#**************************************************************
    Then WebAgent click on assignButton
    Then Wait 2 seconds
    Then WebAgent click on assignToMeButton
    Then Wait 2 seconds

    Then Select "<Request Type>"from requestTypeDropdownlist
    Then Wait 2 seconds
    Then WebAgent click on submitButton
    Then Wait 10 seconds

    Then WebAgent click on confirmNotificationButton if exist
    Then Wait 2 seconds
    Then Check ticket Sub Status is "Assigned to Maker"
#****************************************************
#  STEP 5:Operation Manager Send For Review
#********************************************************
    Then WebAgent click on reviewButton
    Then WebAgent click on sendForReviewButton

    And WebAgent type "Send For Review to Nola"into mailContentText
    And WebAgent type "Send For Review to Nola"into markerRemarks
    Then Select "No exception"from statusRemarkDropdownList
    Then Select "Chai,Nola [TECH]"from checkerDropdownList
    Then Wait 2 seconds
    Then WebAgent click on sendForReviewButton

    Then Wait 3 seconds
    Then Check ticket Sub Status is "Pending Checker Review"
    Then Close Browser
#*******率率**********************************************
#  STEP 6:Operation Reviewer Reject
#****率率****************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation Reviewer_India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 10 seconds

    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent click on reviewButton
    Then Wait 1 seconds
    Then WebAgent click on rejectButton
    Then Wait 2 seconds

    And WebAgent type "Checker Reject the ticket"into checkerRemarks
    Then Wait 1 seconds
    Then WebAgent click on typeEmailCommentsRadio
    Then Wait 1 seconds
    And Select "No exception"from statusRemarkDropdownList
    Then Wait 1 seconds

    Then WebAgent click on rejectButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "Checker Rejected"
    Then Close Browser
#***************************************************************
#  STEP 7:Operation Manager Send For Review
#**************************************************************济
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation_Manager_India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 10 seconds

    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent click on reviewButton
    Then WebAgent click on sendForReviewButton

    And WebAgent type "Send For Review to Nola again"into mailContentText
    And WebAgent type ",Send For Review to Nola again"into markerRemarks
    Then SeLect "No exception"from statusRemarkDropdownList
    Then Select "Chai,Nola [TECH]"from checkerDropdownList
    Then Wait 2 seconds

    Then WebAgent click on sendForReviewButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "Pending Checker Review"
    Then Close Browser

#**************************************************************
#  STEP 8:Operation Reviewer Send For OC Review
#*************************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation Reviewer India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 10 seconds
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab

    Then WebAgent click on reviewButton
    Then WebAgent click on sendForQCReviewButton

    And WebAgent type "Send For QC Review to Jimmy"into mailContentText
    And WebAgent type ",Send For QC Review to Jimmy"into checkerRemarks
    Then Select "No exception"from statusRemarkDropdownList
    Then Select "Chen,Jimmy [TECH NE]"from qcpropdownlist
    Then Wait 2 seconds

    Then WebAgent click on sendForQCReviewButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "Pending QC Review"
    Then Close Browser
#***************************************************************
#  STEP 9:Operation OC Reject To Checker
#***************************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation OC India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 10 seconds

    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab

    Then WebAgent click on reviewButton
    Then WebAgent click on rejectToCheckerButton

    And WebAgent type "Jimmy Reject To Checker"into mailContentText
    And WebAgent type "Jimmy Reject To Checker"into qcRemarks
    Then Wait 2 seconds

    Then WebAgent click on rejectToCheckerButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "QC Rejected To Checker"
    Then Close Browser
#***************************************************************
#  STEP 10:Operation Reviewer Send For OC Review again
#***************************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation Reviewer India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 10 seconds
    When Open ticket by ID "@ticketId.Value"

    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent click on reviewButton
    Then WebAgent click on sendForoCReviewButton

    And WebAgent type "Send For QC Review to Jimmy again"into mailContentText
    And WebAgent type ",Send For QC Review to Jimmy again"into checkerRemarks

    Then Select "No exception"from statusRemarkDropdownList
    Then Select "Chen,Jimmy [TECH NE]"from qcDropdownlist
    Then Wait 2 seconds

    Then WebAgent click on sendForQCReviewButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "Pending QC Review"
    Then Close Browser

#*************************************************************
#  STEP 11:Operation OC Perform Review
#**************************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation QC India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 15 seconds

    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab

    Then WebAgent click on reviewButton
    Then WebAgent click on performReviewButton

    And WebAgent type "Jimmy Performed Review"into mailContentText
    And WebAgent type ",Jimmy Performed Review"into qcRemarks

    Then Wait 2 seconds
    Then WebAgent click on performReviewButton
    Then Wait 3 seconds
    Then Check ticket Sub Status is "QC Confirmed"
    Then Close Browser
#**************************************************************
#  STEP 12:Operation Reviewer Close Ticket
#***************************************************************
    Given WebAgent open "$xmcIndiaLoginPage"url
    When Login as "$Operation Reviewer India"
    Then WebAgent is on InboxModule
    Then WebAgent click on inboxIcon
    Then Wait 15 seconds
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab

    Then WebAgent click on closeTicketButton1
    Then Wait 2 seconds
    Then WebAgent click on typeEmailCommentsRadio
    Then Wait 1 seconds
    And WebAgent type "Close ticket"into mailContentText
    Then Wait 1 seconds
    Then Wait 1 seconds

    And Select "No exception"from statusRemarkDropdownList
    Then WebAgent click on closeTicketButton2
    Then Wait 3 seconds
    Then Check ticket Sub Status is "Closed"
    Then Close Browser

    Examples:
      |Request Type   | Currency| Amount        |Base No    |Client Name      |Flexcube Ref no      |Cosmos Ref no        |Branch client  | Segment |Payment Type             |
      |Booking Process| USD     | 1,540,000.00  |IN0123456  |Auto client Name |Auto Flexcube REf no | Auto Cosmos Ref no  |Mumbai         |TILC     |Internal -client account |