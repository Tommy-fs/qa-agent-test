gherkin
Feature: Funding Dashboard Field Management
  # Test Case ID: FundingDashboard-001
  # This scenario verifies the addition of the Auto Test Ref# field as non-mandatory in all workflow and ticket areas.

  @FundingDashboard @HighPriority
  Scenario Outline: Add Auto Test Ref# field as non-mandatory
    # ***************************************************
    # STEP 1: User Login
    # ***************************************************
    Given WebAgent open "<url>" url
    And Login SSO as "<username>"
    And Wait 5 seconds
    Then WebAgent is on "<homepage>"

    # ***************************************************
    # STEP 2: Navigate to Ticket Workflow
    # ***************************************************
    When WebAgent click on "<ticketWorkflowSection>"
    Then WebAgent is on "<ticketWorkflowPage>"

    # ***************************************************
    # STEP 3: Identify Funding Dashboard Fields
    # ***************************************************
    When WebAgent see "<fundingDashboardFields>"

    # ***************************************************
    # STEP 4: Check Auto Test Ref# Field Presence
    # ***************************************************
    Then WebAgent see "<autoTestRefField>"

    # ***************************************************
    # STEP 5: Verify Auto Test Ref# Field Non-Mandatory
    # ***************************************************
    Then WebAgent read text from "<autoTestRefField>" into @fieldStatus
    And check "Field Status" Ticketvalue is "Non-Mandatory"

    # ***************************************************
    # STEP 6: Submit Change Request
    # ***************************************************
    When WebAgent type "Add Auto Test Ref# field as non-mandatory in all workflow and ticket areas" into "<changeRequestField>"
    And WebAgent click on "<submitChangeRequestButton>"
    Then WebAgent see "<changeRequestSuccessMessage>"

    # ***************************************************
    # STEP 7: Verify New Field Location
    # ***************************************************
    When WebAgent see "<newFieldLocation>"

    # ***************************************************
    # STEP 8: Check Change Application to All Areas
    # ***************************************************
    Then WebAgent see "<allAreasApplication>"

    # ***************************************************
    # STEP 9: Verify Display for Normal DL
    # ***************************************************
    When WebAgent see "<normalDLDisplay>"

    # ***************************************************
    # STEP 10: Confirm Non-Mandatory Status
    # ***************************************************
    Then WebAgent read text from "<autoTestRefField>" into @fieldStatus
    And check "Field Status" Ticketvalue is "Non-Mandatory"

    # ***************************************************
    # STEP 11: Test Functionality by Creating New Ticket
    # ***************************************************
    When WebAgent click on "<createNewTicketButton>"
    And WebAgent type "<ticketDetails>" into "<ticketDetailsField>"
    Then WebAgent click on "<submitTicketButton>"
    And WebAgent see "<ticketCreationSuccessMessage>"

    # ***************************************************
    # STEP 12: Validate Data Transition to GENAIXXX
    # ***************************************************
    Then WebAgent see "<dataTransitionSuccess>"

    # ***************************************************
    # STEP 13: Ensure Improved Data Tracking and Remediation
    # ***************************************************
    Then WebAgent see "<improvedDataTracking>"

  Examples:
    | url                | username  | homepage       | ticketWorkflowSection | ticketWorkflowPage | fundingDashboardFields | autoTestRefField | changeRequestField | submitChangeRequestButton | changeRequestSuccessMessage | newFieldLocation | allAreasApplication | normalDLDisplay | createNewTicketButton | ticketDetails | ticketDetailsField | submitTicketButton | ticketCreationSuccessMessage | dataTransitionSuccess | improvedDataTracking |
    | "http://genaixxx" | "testuser" | "HomePage"     | "TicketWorkflow"      | "WorkflowPage"     | "FundingDashboard"     | "AutoTestRef#"   | "ChangeRequest"    | "SubmitChangeRequest"     | "ChangeRequestSubmitted"    | "UnderContract#" | "AllAreasApplied"   | "AdditionalDetails" | "CreateTicket"        | "Details"    | "TicketDetails"    | "SubmitTicket"    | "TicketCreated"              | "DataTransitioned"    | "DataTrackingImproved" |

# Comments:
# If any web elements or steps are not available, please define them as follows:
# | Annotation Condition | Matching Condition |
# |----------------------|--------------------|
# | @And("^Check ticket Subject is \"([^\"]*)\"$") | Check ticket subject |


### Explanation:
- **Test Case ID**: A unique identifier for the test case is provided.
- **Scenario Outline**: Describes the scenario being tested.
- **Steps**: Each step is clearly defined using Given, When, Then, and And statements.
- **Examples**: Parameters are defined for use in the scenario outline.
- **Comments**: Instructions for defining new web elements or steps if needed.