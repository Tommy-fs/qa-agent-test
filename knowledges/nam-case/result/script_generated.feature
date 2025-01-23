gherkin
Feature: Auto Test Ref# Field Verification for Normal DL Tickets
  # This feature verifies the addition and configuration of the 'Auto Test Ref#' field for Normal DL tickets.

  @AutoTestRef @Critical
  Scenario Outline: AutoTestRef-001 Verify 'Auto Test Ref#' field is added and configured correctly
    # ***************************************************
    # STEP 1: Log in to the xxx system Loan Web application
    # ***************************************************
    Given WebAgent open "<url>" url
    And Login SSO as "<username>"
    And Wait 5 seconds
    And Login as "<username>"
    Then WebAgent is on homepage

    # ***************************************************
    # STEP 2: Create a new ticket for Normal DL
    # ***************************************************
    When WebAgent click on createButton
    And Select "<ticketType>" from requestTypeDropdownlist
    Then WebAgent click on saveButton
    And Wait 5 seconds
    And Get Ticket ID by Subject "<ticketSubject>" and save into @ticketId

    # ***************************************************
    # STEP 3: Check 'Auto Test Ref#' field visibility
    # ***************************************************
    When Open ticket by ID "@ticketId.Value"
    Then WebAgent click on updateTicketAction
    And WebAgent see autoTestRefField

    # ***************************************************
    # STEP 4: Fill out 'Auto Test Ref#' field
    # ***************************************************
    When WebAgent type "<testValue>" into autoTestRefField
    And WebAgent click on saveButton
    Then Wait 5 seconds

    # ***************************************************
    # STEP 5: Verify 'Auto Test Ref#' field in Additional Details
    # ***************************************************
    When WebAgent click on additionalDetailsNotesAction
    Then WebAgent see autoTestRefField
    And check "Auto Test Ref#" Ticketvalue is "<testValue>"

    # ***************************************************
    # STEP 6: Verify 'Auto Test Ref#' field is non-mandatory
    # ***************************************************
    Then WebAgent see nonMandatoryFlag

    # ***************************************************
    # STEP 7: Close ticket and verify data archiving
    # ***************************************************
    When WebAgent click on closeParentAction
    Then Wait 5 seconds
    And check "Auto Test Ref#" ArchivedData is "<testValue>"

    Examples:
      | url                  | username | ticketType | ticketSubject          | testValue |
      | http://xxx system-loan.com  | testuser | Normal DL  | [xxx system Test]AutoTestRef  | Test123   |

# Comments:
# - autoTestRefField: Define the web element for the 'Auto Test Ref#' field.
# - nonMandatoryFlag: Define the web element to check if the field is non-mandatory.
# - ArchivedData: Define the web element to verify archived data.


### Explanation:
- **Test Case ID**: AutoTestRef-001
- **Scenario Outline**: Describes the verification of the 'Auto Test Ref#' field for Normal DL tickets.
- **Preconditions**: User must be logged in as an Operations Manager.
- **Steps**: Detailed actions are provided for logging in, creating a ticket, checking field visibility, filling out the field, verifying in additional details, checking non-mandatory status, and verifying data archiving.
- **Examples**: Parameters such as URL, username, ticket type, ticket subject, and test value are defined for use in the scenario.
- **Comments**: Custom web elements are suggested for defining specific elements not provided in the available list.