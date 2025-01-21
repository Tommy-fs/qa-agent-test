gherkin
Feature: Funding Dashboard Updates
  # Test Case ID: FundingDashboard-001
  # Scenario Outline: Add Auto Test Ref# field as non-mandatory in all workflow and update ticket areas
  # Preconditions: User must have Bilateral or CAD servicing operations role.

  @FundingDashboard @HighPriority
  Scenario: Add Auto Test Ref# field as non-mandatory in all workflow and update ticket areas
    Given WebAgent open "GENAIXXX" url
    And Login SSO as "testuser"
    And Wait 5 seconds
    And Login as "testuser"
    # Step 1: Log in to GENAIXXX system
    Then User successfully logs in to the system

    # Step 2: Navigate to the ticket workflow section
    When WebAgent click on "ticketWorkflowSection"
    Then Ticket workflow section is displayed

    # Step 3: Identify the fields relevant to the "funding dashboard"
    When WebAgent see "fundingDashboardFields"
    Then Fields related to funding dashboard are identified

    # Step 4: Check if there is a text field available for Auto Test Ref#
    When WebAgent see "autoTestRefField"
    Then Confirm that there is no text field available for Auto Test Ref#

    # Step 5: Make Auto Test Ref# field non-mandatory in all workflow and update ticket areas
    When WebAgent click on "updateTicketAction"
    And WebAgent type "Auto Test Ref#" into "fieldName"
    And WebAgent select "Non-Mandatory" from "fieldRequirementDropdownlist"
    Then Auto Test Ref# field is updated to be non-mandatory

    # Step 6: Verify the changes by creating a new ticket and updating an existing ticket
    When WebAgent click on "createNewTicket"
    And WebAgent type "ticketCreationData" into "ticketDataFields"
    Then Auto Test Ref# field is not mandatory and can be left blank

    # Step 7: Ensure the changes are applied to all DLS, document, and normal DLs
    When WebAgent see "DLSFields"
    And WebAgent see "documentFields"
    And WebAgent see "normalDLFields"
    Then Auto Test Ref# field is visible and non-mandatory in all relevant areas

    # Step 8: Confirm that the new Auto Test Ref# field for Normal DL is shown in the Additional Details section on the Ticket Detail page
    When WebAgent click on "additionalDetailsNotesAction"
    Then New field is displayed in the specified location

    # Step 9: Test the functionality by transitioning funding dashboard data fully to GENAIXXX system
    When WebAgent type "fundingDashboardData" into "dataFields"
    Then Data tracking and remediation efforts are improved

  # Comments: 
  # Define the following web elements if not available:
  # | Web Element Name          | Description                                      |
  # |---------------------------|--------------------------------------------------|
  # | ticketWorkflowSection     | Locator for the ticket workflow section          |
  # | fundingDashboardFields    | Locator for funding dashboard related fields     |
  # | autoTestRefField          | Locator for Auto Test Ref# field                 |
  # | fieldName                 | Locator for the field name input                 |
  # | fieldRequirementDropdownlist | Locator for field requirement dropdown list  |
  # | createNewTicket           | Locator for creating a new ticket button         |
  # | ticketDataFields          | Locator for ticket data input fields             |
  # | DLSFields                 | Locator for DLS related fields                   |
  # | documentFields            | Locator for document related fields              |
  # | normalDLFields            | Locator for normal DL related fields             |
  # | additionalDetailsNotesAction | Locator for Additional Details/Notes action   |
  # | dataFields                | Locator for data input fields                    |


### Explanation:
- **Test Case ID**: Unique identifier for the test case.
- **Scenario Outline**: Describes the purpose of the test case.
- **Preconditions**: Specifies the role required for the user.
- **Steps**: Detailed actions using Given, When, Then, and And statements.
- **Expected Results**: Describes the expected outcomes after executing the steps.
- **Comments**: Lists any custom web elements that need to be defined if not available.