from evaluators.cucumber_scripts_evaluator import CucumberEvaluator
from tool.cucumber_script_generate_tool import CucumberScriptGenerator


def test():
    print("test-begin")

    # evaluator = CucumberEvaluator()
    test_case = """
    Priority: Critical  
Name: TicketingLogic-002  
Summary: Function - Add 'Auto Test Ref#' field in Update Ticket action form  
Steps：  
| No. | Test Step                                                                 | Test Data                                                                                       | Expected Result                                      |
|-----|---------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------|
| 1   | Operation Manager login xxx system Loan Web.                             | A: *GT CN DevTest                                                                               | Processing Team: *GT CN DevTest                     |
| 2   | Create a Ticket for Normal DL and fill in mandatory fields by New Message. | Processing Team: *Test processing DL, From email address: TESTFROM1@CITI.COM, To email address: TESTTO1@CITI.COM, SUBJECT: Add Auto Test Ref#, Request Type value: 3PDL | Status: Unassigned                                   |
| 3   | Open Ticket created for Normal DL.                                       |                                                                                                 | Sub Status: New                                     |
| 4   | Click Update Ticket Action.                                              |                                                                                                 | Update Ticket form is displayed                     |
| 5   | Verify 'Auto Test Ref#' field is present in Update Ticket action form.  |                                                                                                 | 'Auto Test Ref#' field is displayed                 |
| 6   | Leave 'Auto Test Ref#' field empty and click Update Ticket button.      |                                                                                                 | Ticket is updated successfully without error        |
| 7   | Check Additional Details section in Ticket Detail page.                 |                                                                                                 | 'Auto Test Ref#' field is not displayed in Additional Details |
| 8   | Enter value in 'Auto Test Ref#' field and click Update Ticket button.   | Auto Test Ref#: TEST123                                                                        | Ticket is updated successfully                       |
| 9   | Check Additional Details section in Ticket Detail page again.           |                                                                                                 | 'Auto Test Ref#' field displays value TEST123       |
| 10  | Close the Ticket.                                                        |                                                                                                 | Ticket status is changed to Closed                   |

    """
    scripts = """
    ```cucumber
# Feature: Add 'Auto Test Ref#' field in Update Ticket action form
# Test Case ID: TicketingLogic-002
# Author: Bard (Generated)
# Description: This feature verifies the addition of the 'Auto Test Ref#' field in the Update Ticket action form.

Feature: Update Ticket Form Enhancement

  @Ticket @Regression @TicketingLogic-002
  Scenario Outline: Add Auto Test Ref# field

    # Preconditions: User is logged in as an Operation Manager. A ticket exists.

    Given WebAgent open "$xxx systemNAMLoginPage" url
    And Login SSO as "SopsManagel"
    And Wait 5 seconds
    And Login as "SopsManage1"

    # Navigate to existing ticket (using a predefined ticket subject for demonstration)
    And WebAgent click on inboxIcon
    And Wait 5 seconds
    Then WebAgent click on allTicketsInbox
    And Wait 20 seconds
    And WebAgent click on clearUserPreferenceButton
    And Wait 10 seconds
    And Get Ticket ID by Subject "[xxx system Test]ExistingTicket" and save into @ticketId  # Replace with actual ticket subject retrieval method
    When Open ticket by ID "@ticketId.Value"
    Then Wait 5 seconds
    Then WebAgent change to next tab
    Then WebAgent is on workflowPage


    # Steps:
    # 1. Open the Update Ticket action form.
    When WebAgent click on updateTicketAction

    # 2. Verify the presence of the 'Auto Test Ref#' field.
    Then WebAgent see autoTestRefText

    # 3. Enter a value into the 'Auto Test Ref#' field.
    When WebAgent type "<auto_test_ref>" into autoTestRefText

    # 4. Update the ticket.
    Then WebAgent click on updateTicketButton
    And Wait 4 seconds

    # 5. Verify the updated ticket details (including the 'Auto Test Ref#' field).
    Then check "Auto Test Ref #" Ticketvalue is "<auto_test_ref>"

    # Clean up - Close the ticket
    Then WebAgent click on closeParentAction
    Then Wait 1 seconds
    Then WebAgent click on c1ase5ubAct1am # Replace with actual close action element
    Then Wait 5 seconds
    Then check "Status" TicketValue is "Closed"
    Then check "Sub Status" Ticketvalue is "Closed"
    Then WebAgent click on expandAuditTrail
    And Wait 1 seconds
    Then Close Browser


    Examples:
      | auto_test_ref |
      | TestRef123    |



#  Comments/Customized Steps (if needed):
#  If there are no predefined steps or web elements for certain actions,
#  you would define them here following the provided examples.
#  For instance:
#  @Then("WebAgent see {string}")
#  public void webAgentSee(String elementId) {
#      // Implementation to check if the element with the given ID is present
#  }

```


Key improvements and considerations in this script:

* **Clearer Structure:** The script is organized with comments to delineate the different steps of the test case, making it easier to understand and maintain.
* **Preconditions:**  Explicitly states the preconditions for the test case.
* **Verification:** Includes steps to verify the presence of the 'Auto Test Ref#' field and its value after the ticket update.
* **Data-Driven Testing:** Uses `Scenario Outline` and `Examples` to allow for testing with different values for the 'Auto Test Ref#' field.
* **Cleanup:** Includes steps to close the ticket after the test, ensuring a clean state for subsequent tests.
* **Comments for Customization:**  Provides a clear section for adding custom steps or web element definitions if the provided ones are insufficient.
* **Specific Element IDs:**  Uses the provided web element ID `autoTestRefText` for interacting with the new field.
* **Realistic Ticket Subject:**  Uses a placeholder "[xxx system Test]ExistingTicket" for retrieving a ticket ID.  This needs to be replaced with the actual mechanism for identifying a test ticket.  This could involve creating a ticket as part of the test setup or using a predefined ticket ID.


This revised script provides a more robust and maintainable solution for testing the 'Auto Test Ref#' field functionality.  Remember to replace the placeholder ticket subject and close action element with the actual values from your application.  Also, implement any custom steps or web element definitions as needed.

    """
    # res = evaluator.evaluate(test_case, scripts)
    generator = CucumberScriptGenerator()
    generator.evaluate_and_optimize(test_case, scripts)
    # print(res)
    print("test-end")


test()
