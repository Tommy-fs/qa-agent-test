```cucumber
# Test Case 1: Successful Login
Feature: User Login - Successful Login

    Test Case ID: TC_LOGIN_001
    Scenario Outline: Verify Successful Login with Valid Credentials
        Preconditions:  Application is running and accessible.

        Given WebAgent open "<login_page_url>" url
        Then WebAgent is on LoginPage

        When WebAgent type "<username>" into usernameTextbox
        And WebAgent type "<password>" into passwordTextbox
        And WebAgent click on loginButton

        Then WebAgent is on HomePage
        And WebAgent see welcomeMessage

        Examples:
            | login_page_url | username | password |
            | https://example.com/login | testuser | password123 |


# Test Case 2: Invalid Login Attempts
Feature: User Login - Invalid Login Attempts

    Test Case ID: TC_LOGIN_002
    Scenario Outline: Verify Login with Invalid Credentials
        Preconditions: Application is running and accessible.

        Given WebAgent open "<login_page_url>" url
        Then WebAgent is on LoginPage

        When WebAgent type "<username>" into usernameTextbox
        And WebAgent type "<password>" into passwordTextbox
        And WebAgent click on loginButton

        Then WebAgent see "<error_message>"

        Examples:
            | login_page_url | username      | password      | error_message                       |
            | https://example.com/login | invaliduser   | password123   | Invalid username or password.      |
            | https://example.com/login | testuser      | wrongpassword | Invalid username or password.      |
            | https://example.com/login |                |               | Username and password are required. |
            | https://example.com/login | test user!    | password123   | Invalid username.                  | # Example assuming specific error message
            | https://example.com/login | testuser      | password!@#   | Invalid password.                  | # Example assuming specific error message


# Test Case 3: Password Recovery
Feature: User Login - Password Recovery

    Test Case ID: TC_LOGIN_003
    Scenario Outline: Verify Password Recovery Functionality
        Preconditions: Application is running and accessible. Email server is configured for testing.

        Given WebAgent open "<login_page_url>" url
        Then WebAgent is on LoginPage

        When WebAgent click on forgotPasswordLink
        Then WebAgent is on PasswordRecoveryPage

        When WebAgent type "<email>" into emailTextbox
        And WebAgent click on resetPasswordButton

        Then WebAgent see passwordResetInstructionsSentMessage
        # Email verification steps are outside the scope of UI automation and should be tested separately.
        # Assume email is received and link is clicked.

        # Following steps simulate user clicking the link and landing on the reset page
        Given WebAgent open "<password_reset_page>" url # This URL would be from the email
        Then WebAgent is on PasswordResetPage

        When WebAgent type "<new_password>" into newPasswordTextbox
        And WebAgent type "<confirm_password>" into confirmPasswordTextbox
        And WebAgent click on updatePasswordButton

        Then WebAgent see passwordUpdatedSuccessfullyMessage

        Examples:
            | login_page_url | email                   | password_reset_page | new_password | confirm_password |
            | https://example.com/login | testuser@example.com | https://example.com/reset | newpassword123 | newpassword123 |
            | https://example.com/login | unregistered@example.com |                     |              |                 | # Negative test case


# Test Case 4: Account Lockout
Feature: User Login - Account Lockout

    Test Case ID: TC_LOGIN_004
    Scenario Outline: Verify Account Lockout after Multiple Failed Login Attempts
        Preconditions: Application is running and accessible. Account lockout policy is configured.

        Given WebAgent open "<login_page_url>" url
        Then WebAgent is on LoginPage

        When WebAgent type "<username>" into usernameTextbox
        And WebAgent type "<password>" into passwordTextbox
        And WebAgent click on loginButton # First attempt
        And WebAgent click on loginButton # Second attempt
        And WebAgent click on loginButton # Third attempt
        And WebAgent click on loginButton # Fourth attempt
        And WebAgent click on loginButton # Fifth attempt

        Then WebAgent see accountLockedMessage

        Examples:
            | login_page_url | username | password      |
            | https://example.com/login | testuser | wrongpassword |


# Test Case 5: Remember Me Functionality
Feature: User Login - Remember Me Functionality

    Test Case ID: TC_LOGIN_005
    Scenario Outline: Verify "Remember Me" Functionality
        Preconditions: Application is running and accessible. "Remember Me" functionality is implemented.

        Given WebAgent open "<login_page_url>" url
        Then WebAgent is on LoginPage

        When WebAgent type "<username>" into usernameTextbox
        And WebAgent type "<password>" into passwordTextbox
        And WebAgent <remember_me_action> rememberMeCheckbox
        And WebAgent click on loginButton

        Then WebAgent is on HomePage

        # Browser restart simulation requires specific driver capabilities and is outside basic Cucumber scope.
        # The following steps would need to be adapted based on the testing framework and browser drivers used.
        Then Close Browser  # Close the browser
        Given WebAgent open "<login_page_url>" url # Reopen the browser at the login page
        Then WebAgent <expected_login_status> on HomePage # Check if logged in or at login page


        Examples:
            | login_page_url | username | password | remember_me_action | expected_login_status |
            | https://example.com/login | testuser | password123 | check on           | is                    |
            | https://example.com/login | testuser | password123 | uncheck on         | is not                 |

```


**Custom Steps (If Needed):**

If any of the above steps are not available in your project, you'll need to define them.  Here's an example of how to define a custom step:

```java
// Example Java step definition (adapt to your framework)
@Given("WebAgent is on LoginPage")
public void webAgentIsOnLoginPage() {
    // Code to assert that the current page is the login page.
    // e.g., check for specific elements, title, URL, etc.
    String currentUrl = driver.getCurrentUrl();
    Assert.assertTrue(currentUrl.contains("/login")); // Example assertion
}
```

You would need to create similar step definitions for any other missing steps, adapting the code to your specific web application and testing framework.  Remember to replace placeholder URLs, element names, and messages with the actual values from your application.  Also, ensure that all web elements used in the scripts are defined in your element repository.