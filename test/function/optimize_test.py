from agent_core.agents import Agent

from tool.cucumber_script_generate_tool import CucumberScriptGenerator


def test():
    generator = CucumberScriptGenerator()
    generated_test_cases = """
Priority: Critical
Name: HK_GCM_Workflow-001
Summary: Verify HK GCM Workflow when THIRD PARTY PAYMENT is Yes and COMPLETED DATE is blank.
Steps：
| No. | Test Step | Test Data | Expected Result |
|---|---|---|---|
| 1 | Login system as KL LOANS OPS-PROCESSING -MAKER | User with KL LOANS OPS-PROCESSING -MAKER role | Login successful |
| 2 | Create a new HK GCM instruction via 'New Instruction' | THIRD PARTY PAYMENT: Yes | Instruction created successfully |
| 3 | Perform 'Maker Submit' action |  | Instruction submitted, CURRENT STATUS = 'KL LOANS OPS', PROCESS STATUS = 'KL LOANS - PROCESSING-CHECKER' |
| 4 | Verify available actions |  | Only 'Submit to Payment' action is available, 'Complete' action is disabled |
| 5 | Login system as KL LOANS OPS - PROCESSING -CHECKER | User with KL LOANS OPS - PROCESSING -CHECKER role | Login successful |
| 6 | Open the created instruction |  | Instruction opens successfully |
| 7 | Perform 'Submit to Payment' action |  | Action successful, PROCESS STATUS = 'PAYMENT - MAKER' |
| 8 | Login system as KL LOANS OPS-PROCESSING-PAYMENT MAKER | User with KL LOANS OPS-PROCESSING-PAYMENT MAKER role | Login successful |
| 9 | Open the created instruction |  | Instruction opens successfully |
| 10 | Perform 'Submit Payment Checker' action |  | Action successful, PROCESS STATUS = 'PAYMENT-CHECKER' |
| 11 | Login system as KL LOANS OPS -PROCESSING - PAYMENT CHECKER | User with KL LOANS OPS -PROCESSING - PAYMENT CHECKER role | Login successful |
| 12 | Open the created instruction |  | Instruction opens successfully |
| 13 | Perform 'Complete' action |  | Action successful, CURRENT STATUS = 'COMPLETED', PROCESS STATUS = 'COMPLETED', COMPLETED DATE is populated |

    """

    para = generator.enrich_knowledge_parameters(generated_test_cases, failure_history="")
    # script = generator.generate_script(para)
    script = """
    ```cucumber
Feature: HK GCM Workflow

    Instruction Detail:
    1) Author: Bard
    2) Transaction Type: New Drawdown
    3) Workflow: HK GCM
    4) Check Point: E2E
    5) Key Value: THIRD PARTY PAYMENT = Yes, COMPLETED DATE initially blank

    @HK_GCM_Workflow-001
    Scenario Outline: HK_GCM_Workflow-001 Verify HK GCM Workflow when THIRD PARTY PAYMENT is Yes and COMPLETED DATE is blank

        # Preconditions: System is running and accessible. Test users exist with appropriate roles.

        # ***************************************************************
        # STEP 1: Maker creates and submits instruction
        # ***************************************************************
        Given WebAgent open "<System URL>" url
        When Login as "KL LOANS OPS-PROCESSING -MAKER"
        Then WebAgent is on InstructionTab
        Then Switch Platform to "HK Loans"
        Then WebAgent click on createButton
        And WebAgent click on newInstructionItem
        And Wait 5 seconds
        Then Select "New Drawdown" from transactionTypeDropdownlist
        And Select "Short Term Fixed Rate" from loanTypepropdownlist # Assuming this is a relevant loan type
        And Select "Yes" from thirdPartyPaymentDropdownlist # Setting THIRD PARTY PAYMENT to Yes
        # ... other fields as needed for instruction creation ...
        Then WebAgent click on createAndMakerSubmitButton
        And WebAgent see successMsg
        And Save instruction Id and URL with prefix "LHK" from successMsg into @instructionId and @instructionUrl
        Then sign Out


        # ***************************************************************
        # STEP 4: Verify available actions (Checker)
        # ***************************************************************
        When Login as "KL LOANS OPS - PROCESSING -CHECKER"
        Then WebAgent is on OperationTab
        And WebAgent open "@instructionUrl.Value" url
        Then Only "Submit to Payment" action is available # Implement a step to check available actions
        And "Complete" action is disabled # Implement a step to check if an action is disabled


        # ***************************************************************
        # STEP 5-7: Checker submits to Payment, Payment Maker and Checker actions
        # ***************************************************************
        Then WebAgent click on submitButton # Assuming this is how submit is initiated
        Then WebAgent click on submitToPaymentButton
        And WebAgent see successMsg
        Then sign Out

        When Login as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        Then WebAgent click on editButton
        Then WebAgent click on paymentTab
        # ... other payment maker actions ...
        Then WebAgent click on submitButton
        Then WebAgent click on submitToPaymentCheckerButton
        And WebAgent see successMsg
        Then sign Out

        When Login as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER"
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        Then WebAgent click on submitButton
        Then WebAgent click on submitToQCButton # Assuming this goes to QC after Payment Checker
        And WebAgent see successMsg
        Then sign Out


        # ***************************************************************
        # STEP 13: Payment Checker Completes, verify Completed Date
        # ***************************************************************
        # Note:  This assumes there's no separate QC step for completion based on the test case.
        #       If there is a QC step before completion, add those steps here.
        When Login as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER" # Login as the completing user
        Then WebAgent is on PaymentTab
        And WebAgent open "@instructionUrl.Value" url
        Then WebAgent click on completeButton # Assuming this is the final complete action
        And WebAgent see successMsg
        Then CURRENT STATUS is "COMPLETED" # Implement step to verify status
        And PROCESS STATUS is "COMPLETED" # Implement step to verify status
        And COMPLETED DATE is populated # Implement step to verify date population


        Then Close Browser

        Examples:
            | System URL | CUSTOMER GROUP |  # ... other example parameters as needed ...
            | <Test System URL> | GCM |


```

**Key Improvements and Explanations:**

* **Clear Feature Description:**  Provides context about the workflow being tested.
* **Test Case ID Tag:**  `@HK_GCM_Workflow-001` clearly links the script to the test case.
* **Preconditions:** Added a placeholder for preconditions.
* **Focus on the Test Case:** The script now concentrates on the steps specifically outlined in HK_GCM_Workflow-001, omitting unrelated template sections.
* **Verification Steps:** Added placeholders for crucial verification steps like checking available actions and the final "COMPLETED" status and date.  You'll need to implement the actual Cucumber steps for these based on your system's specifics.
* **Combined Actions:** Streamlined some sequences of actions (e.g., Payment Maker/Checker) to be more concise.
* **Example Parameters:**  Added example parameters using the `<...>` notation as required.  Include any other parameters your steps might need.
* **Comments:**  Explanations added to clarify the logic and purpose of different sections.
* **Assumptions:**  Where the test case was ambiguous (e.g., which user performs the final "Complete" action, how "Submit to Payment" is initiated), I've made reasonable assumptions and noted them in comments.  You'll need to adjust these based on your actual system.


**Next Steps:**

1. **Implement Missing Steps:** Replace the placeholder comments (e.g., `# Implement a step to...`) with actual Cucumber step definitions that interact with your web application.
2. **Define Step Definitions:**  Create the code behind the Cucumber steps in your step definition files.  These will use your web automation framework (e.g., Selenium) to interact with the browser and perform the actions.
3. **Complete Example Table:** Fill in the `<...>` placeholders in the `Examples` table with real test data.
4. **Review and Refine:**  Carefully review the generated script against the test case to ensure it accurately reflects the intended test flow and covers all verification points.


This revised structure provides a much stronger foundation for a working Cucumber script that directly addresses the requirements of your test case. Remember to adapt it further based on the specifics of your testing environment and framework.
    """
    # print(script)
    # evaluate_response = generator.evaluate(generated_test_cases, script)
    # print(evaluate_response)

    history = """
    failure script:
    {script}
    suggestion:
     "Add Assertions:** Implement concrete assertions for all expected results.  Use your testing framework's assertion capabilities to verify page elements, status messages, and data correctness.", 
     'Complete Test Data:** Populate the `Examples` table with all necessary test data, including different parameter combinations.', 
     'Improve Structure:** Restructure the scenario outline to clearly separate Given-When-Then blocks for each distinct action.  Consider extracting common actions into reusable functions.', 
     'Refine Comments:** Make comments more concise and consistent.  Ensure each comment includes the step number, user role, and a clear description of the action.', 
     'Leverage Template:**  More closely adhere to the provided template, clearly indicating which parts are from the template and which are custom.', 
     'Optimize Login:**  Avoid redundant login steps.  Consider using background steps or hooks to manage login and logout.', '
     'Specific Page Elements:** Use more specific locators (IDs, CSS selectors) to interact with page elements, making the script more robust.', 'By addressing these points, the generated Cucumber script can be significantly improved in terms of completeness, clarity, maintainability, and execution reliability.']
     """
    history = history.format(script=script)

    para = generator.enrich_knowledge_parameters(generated_test_cases, failure_history=history)
    final_script = generator.generate_script(para)
    print(final_script)

    final_script = """
```cucumber
Feature: HK GCM Workflow

    Instruction Detail:
    1) Author: Bard
    2) Transaction Type: New Drawdown
    3) Workflow: HK GCM
    4) Check Point: E2E
    5) Key Value: THIRD PARTY PAYMENT = Yes, COMPLETED DATE initially blank

    @HK_GCM_Workflow-001
    Scenario Outline: HK_GCM_Workflow-001 Verify HK GCM Workflow when THIRD PARTY PAYMENT is Yes and COMPLETED DATE is blank

        # Preconditions: System is running and accessible. Test users exist with appropriate roles.  Required test data is available.

        Background: User logs in
            Given WebAgent open "<System URL>" url
            And Login as "<User Role>"
            And WebAgent is on InstructionTab
            And Switch Platform to "HK Loans"


        # ***************************************************************
        # Step 1: KL LOANS OPS-PROCESSING -MAKER creates and submits instruction
        # ***************************************************************
        Given User is logged in as "KL LOANS OPS-PROCESSING -MAKER" # Using Background step
        When Maker creates a new HK GCM instruction with THIRD PARTY PAYMENT set to "Yes"
        Then Instruction is created successfully
        And Instruction ID and URL are saved as "<Instruction ID>" and "<Instruction URL>"

        # ***************************************************************
        # Steps 3-4: KL LOANS OPS - PROCESSING -CHECKER verifies actions and submits to Payment
        # ***************************************************************
        Given User is logged in as "KL LOANS OPS - PROCESSING -CHECKER"
        When Checker opens instruction "<Instruction ID>"
        Then Only "Submit to Payment" action is available
        And "Complete" action is disabled
        When Checker clicks "Submit to Payment"
        Then Instruction status is updated to "KL LOANS OPS" and process status to "PAYMENT - MAKER"


        # ***************************************************************
        # Steps 8-10: KL LOANS OPS-PROCESSING-PAYMENT MAKER submits to Payment Checker
        # ***************************************************************
        Given User is logged in as "KL LOANS OPS-PROCESSING-PAYMENT MAKER"
        When Payment Maker opens instruction "<Instruction ID>"
        And Payment Maker performs actions # Placeholder for any payment maker specific actions
        And Payment Maker clicks "Submit Payment Checker"
        Then Instruction process status is updated to "PAYMENT-CHECKER"

        # ***************************************************************
        # Steps 11-13: KL LOANS OPS -PROCESSING - PAYMENT CHECKER completes the instruction
        # ***************************************************************
        Given User is logged in as "KL LOANS OPS -PROCESSING - PAYMENT CHECKER"
        When Payment Checker opens instruction "<Instruction ID>"
        And Payment Checker clicks "Complete"
        Then Instruction current status is "COMPLETED"
        And Instruction process status is "COMPLETED"
        And COMPLETED DATE is populated


        Examples:
            | System URL      | User Role                          | Instruction ID | Instruction URL | CUSTOMER GROUP |
            | <Test System URL> | KL LOANS OPS-PROCESSING -MAKER     | <Instruction ID> | <Instruction URL> | GCM           |
            | <Test System URL> | KL LOANS OPS - PROCESSING -CHECKER | <Instruction ID> | <Instruction URL> | GCM           |
            | <Test System URL> | KL LOANS OPS-PROCESSING-PAYMENT MAKER | <Instruction ID> | <Instruction URL> | GCM           |
            | <Test System URL> | KL LOANS OPS -PROCESSING - PAYMENT CHECKER | <Instruction ID> | <Instruction URL> | GCM           |

```


**Key Changes and Explanations:**

* **Background Step for Login:**  Login is now handled in a `Background` step, eliminating redundant login/logout steps and making the scenario cleaner.
* **Consolidated Steps:** Steps within each user's actions are grouped together for better readability.
* **Placeholder for Payment Maker Actions:** A placeholder `And Payment Maker performs actions` is added.  Fill this in with the specific steps the Payment Maker needs to take.
* **Parameterization:** The `Instruction ID` and `Instruction URL` are now parameterized, allowing you to reuse the same scenario outline for different instructions.  These values would be generated during the instruction creation step and passed along.
* **Clearer Step Descriptions:** Step descriptions are more concise and directly relate to the test case steps.
* **Given-When-Then Structure:**  The scenario outline now follows a clearer Given-When-Then structure, improving readability and organization.
* **Focus on Test Case:** The script is now tightly focused on the steps in the test case, removing unnecessary parts from the template.


**Next Steps:**

1. **Implement Step Definitions:**  The most crucial next step is to implement the actual Cucumber step definitions for each of the steps in the scenario outline.  These step definitions will use your web automation framework (e.g., Selenium) to interact with the application and perform the actions.
2. **Define Custom Steps:** Create custom steps like "Maker creates a new HK GCM instruction with THIRD PARTY PAYMENT set to "Yes"", "Only "Submit to Payment" action is available", and "COMPLETED DATE is populated" using your web automation framework.  These steps will contain the logic to interact with the specific web elements on your application's pages.
3. **Populate Examples Table:**  Replace the placeholders in the `Examples` table with actual test data, including the system URL and potentially other parameters needed for your test.  The `<Instruction ID>` and `<Instruction URL>` will be dynamically generated during the test execution.


This improved script provides a much stronger structure and addresses many of the previous issues.  By implementing the step definitions and populating the examples table, you'll have a complete and executable Cucumber script for your test case.


    """


def execute():
    agent = Agent(model_name="gemini-1.5-pro-002")

    prompt = """
    
    """

    cucumber_script = agent.execute(prompt)
    print(cucumber_script)


test()
