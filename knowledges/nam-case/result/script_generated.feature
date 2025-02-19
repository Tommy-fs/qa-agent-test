Feature: XMC Loan - Auto Test Ref# Field Addition

Scenario Outline: Verify the addition of 'Auto Test Ref#' field in Update Ticket action form for Normal DL and its display in Additional Details section

  Given User with Operations Manager role logs into XMC Loan Web
  And Create a new ticket for Normal DL using the New Message option with Processing Team: <Processing Team>, From email address: <From Email>, To email address: <To Email>, Subject: <Subject>, Request Type: Normal DL
  And Open the created ticket
  And Click on 'Update Ticket' action button
  And Verify the presence of 'Auto Test Ref#' field in the Update Ticket form
  When Enter a value <Auto Test Ref#> in the 'Auto Test Ref#' field and save the form
  And Verify that the 'Auto Test Ref#' field value is displayed in Additional Details section
  And Close the ticket to complete the test case

  Examples:
    | Processing Team       | From Email      | To Email     | Subject      | Auto Test Ref# |
    | *GT CN DevTest        | TEST123@Q.COM   | YY544@.COM   | Subject-001  | AT12345       


Scenario Outline: Verify that the 'Auto Test Ref#' field is non-mandatory in the Update Ticket action form for Normal DL

  Given User with Operations Manager role logs into XMC Loan Web
  And Create a new ticket for Normal DL using the New Message option with Processing Team: <Processing Team>, From email address: <From Email>, To email address: <To Email>, Subject: <Subject>, Request Type: Normal DL
  And Open the created ticket
  And Click on 'Update Ticket' action button
  And Leave the 'Auto Test Ref#' field empty and save the form
  And Verify that the 'Auto Test Ref#' field is not displayed in Additional Details section when left empty
  And Close the ticket to complete the test case

  Examples:
    | Processing Team       | From Email      | To Email     | Subject      |
    | *GT CN DevTest        | TEST123@Q.COM   | YY544@.COM   | Subject-002  | 

#############

# COMMENTS #
If there are no available webui cucumber steps or web elements that you want to use, please provide the details, and I can help customize them for you.