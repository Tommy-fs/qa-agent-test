Below are the Cucumber scripts generated for the provided test cases. Each script is written in Gherkin format and follows the guidelines and context provided.

### Test Case 1: AutoTestRef-001 ###
gherkin
Feature: Verify 'Auto Test Ref#' field is added to Update Ticket action form for Normal DL

@AutoTestRef @Critical
Scenario Outline: Verify 'Auto Test Ref#' field presence in Update Ticket form
    # ***************************************************
    # STEP 1: Operation Manager - Log in and Create Ticket
    # ***************************************************
    Given WebAgent open "<system_url>" url
    And Login SSO as "<operation_manager>"
    And Wait 5 seconds
    And Login as "<operation_manager>"
    Then WebAgent click on createButton
    And WebAgent select "Normal DL" from requestTypeDropdownlist
    And WebAgent click on saveButton
    And Wait 5 seconds
    # ***************************************************
    # STEP 2: Operation Manager - Open Ticket and Verify Field
    # ***************************************************
    When Open ticket by ID "<ticket_id>"
    Then WebAgent is on ticketDetailsPage
    And WebAgent click on updateTicketAction
    Then WebAgent see "Auto Test Ref#" field
    # ***************************************************
    # STEP 3: Operation Manager - Save Form and Verify in Additional Details
    # ***************************************************
    When WebAgent click on saveButton
    Then WebAgent see "Auto Test Ref#" field in additionalDetailsSection

Examples:
    | system_url | operation_manager | ticket_id |
    | "http://xxx-system.com" | "SopsManager" | "12345" |


### Test Case 2: AutoTestRef-002 ###
gherkin
Feature: Verify 'Auto Test Ref#' field is non-mandatory for Normal DL

@AutoTestRef @High
Scenario Outline: Verify 'Auto Test Ref#' field is non-mandatory
    # ***************************************************
    # STEP 1: Operation Manager - Log in and Create Ticket
    # ***************************************************
    Given WebAgent open "<system_url>" url
    And Login SSO as "<operation_manager>"
    And Wait 5 seconds
    And Login as "<operation_manager>"
    Then WebAgent click on createButton
    And WebAgent select "Normal DL" from requestTypeDropdownlist
    And WebAgent click on saveButton
    And Wait 5 seconds
    # ***************************************************
    # STEP 2: Operation Manager - Open Ticket and Verify Non-Mandatory Field
    # ***************************************************
    When Open ticket by ID "<ticket_id>"
    Then WebAgent is on ticketDetailsPage
    And WebAgent click on updateTicketAction
    Then WebAgent see "Auto Test Ref#" field is not mandatory
    # ***************************************************
    # STEP 3: Operation Manager - Save Form Without Filling Field
    # ***************************************************
    When WebAgent click on saveButton
    Then WebAgent see "Auto Test Ref#" field in additionalDetailsSection without validation error

Examples:
    | system_url | operation_manager | ticket_id |
    | "http://xxx-system.com" | "SopsManager" | "12345" |


### Test Case 3: AutoTestRef-003 ###
gherkin
Feature: Verify 'Auto Test Ref#' field is displayed only for Normal DL

@AutoTestRef @Medium
Scenario Outline: Verify 'Auto Test Ref#' field visibility for Special DL
    # ***************************************************
    # STEP 1: Operation Manager - Log in and Create Ticket
    # ***************************************************
    Given WebAgent open "<system_url>" url
    And Login SSO as "<operation_manager>"
    And Wait 5 seconds
    And Login as "<operation_manager>"
    Then WebAgent click on createButton
    And WebAgent select "Special DL" from requestTypeDropdownlist
    And WebAgent click on saveButton
    And Wait 5 seconds
    # ***************************************************
    # STEP 2: Operation Manager - Open Ticket and Verify Field Absence
    # ***************************************************
    When Open ticket by ID "<ticket_id>"
    Then WebAgent is on ticketDetailsPage
    And WebAgent click on updateTicketAction
    Then WebAgent does not see "Auto Test Ref#" field
    # ***************************************************
    # STEP 3: Operation Manager - Save Form and Verify in Additional Details
    # ***************************************************
    When WebAgent click on saveButton
    Then WebAgent does not see "Auto Test Ref#" field in additionalDetailsSection

Examples:
    | system_url | operation_manager | ticket_id |
    | "http://xxx-system.com" | "SopsManager" | "12345" |


### Comments ###
- If any web elements or steps are not available, they should be defined as follows:
  - **Web Elements**: Define new elements in the comments section at the end of the script.
  - **Web UI Cucumber Steps**: Define new steps with appropriate annotations and matching conditions.

These scripts are designed to be clear, concise, and executable, ensuring they meet the test case requirements and expected results.