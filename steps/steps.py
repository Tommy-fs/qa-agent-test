from behave import given, when, then, use_step_matcher

use_step_matcher("re")


# Given 和 When 同时适用
@given(r'Print Log "([^\"]*)"')
@when(r'Print Log "([^\"]*)"')
def step_print_log(context, log_info):
    print(f"Log Info: {log_info}")


# Given 和 When 同时适用
@given(r'Login as "([^\"]*)"')
@when(r'Login as "([^\"]*)"')
def step_login_as(context, username):
    print(f"Logging in as: {username}")


# Given 和 When 同时适用
@then(r'Switch Platform to "([^\"]*)"')
@when(r'Switch Platform to "([^\"]*)"')
def step_switch_platform(context, platform):
    print(f"Switching to platform: {platform}")


# Given 和 When 同时适用
@then(r'Switch Queue to "([^\"]*)"')
@when(r'Switch Queue to "([^\"]*)"')
def step_switch_queue(context, queue):
    print(f"Switching to queue: {queue}")


# Given 和 When 同时适用
@then(r'Sign Out')
@when(r'Sign Out')
def step_sign_out(context):
    print("Signing out")


# Given 和 When 同时适用
@then(r'Close Browser')
@when(r'Close Browser')
def step_close_browser(context):
    print("Closing browser")


# Given 和 When 同时适用
@then(r'(\w+) Check on (@?[\W\.]+)')
@when(r'(\w+) Check on (@?[\W\.]+)')
def step_check_element_exist(context, action, element):
    print(f"{action} checking if {element} exists")


# Given 和 When 同时适用
@then(r'(\w+) click on (@?[\W\.]+)')
@when(r'(\w+) click on (@?[\W\.]+)')
def step_click_if_exist(context, action, element):
    print(f"{action} clicking on {element} if it exists")


# Given 和 When 同时适用
@when(r'Select "([^\"]*)" from (@?[\w\.]+)')
@given(r'Select "([^\"]*)" from (@?[\w\.]+)')
def step_select_from_dropdown(context, value, field):
    print(f"Selecting {value} from {field}")


# Given 和 When 同时适用
@when(r'Search and Select instruction id "([^\"]*)" from list')
@given(r'Search and Select instruction id "([^\"]*)" from list')
def step_search_and_select_instruction(context, instruction_id):
    print(f"Searching and selecting instruction ID: {instruction_id}")


# Given 和 When 同时适用
@then(r'Wait page loading')
@when(r'Wait page loading')
def step_wait_page_loading(context):
    print("Waiting for page to load")


# Given 和 When 同时适用
@when(r'([\w\.]+) not exist')
@given(r'([\w\.]+) not exist')
def step_element_not_exist(context, element):
    print(f"Checking if {element} does not exist")


# Given 和 When 同时适用
@given(r'read file "([^\"]*)" into (\w+)')
@when(r'read file "([^\"]*)" into (\w+)')
def step_read_file(context, file_path, variable_name):
    print(f"Reading file {file_path} into variable {variable_name}")


# Given 和 When 同时适用
@given(r'Send key CtrlV')
@when(r'Send key CtrlV')
def step_send_key_ctrlv(context):
    print("Sending key Ctrl+V")


# Given 和 When 同时适用
@given(r'Send key Enter')
@when(r'Send key Enter')
def step_send_key_enter(context):
    print("Sending key Enter")


# Given 和 When 同时适用
@given(r'Copy "([^\"]*)" into clipboard')
@when(r'Copy "([^\"]*)" into clipboard')
def step_copy_to_clipboard(context, content):
    print(f"Copying {content} into clipboard")


# Given 和 When 同时适用
@given(r'Select Local file with "([^\"]*)"')
@when(r'Select Local file with "([^\"]*)"')
def step_select_local_file(context, file_path):
    print(f"Selecting local file with path: {file_path}")


# Given 和 When 同时适用
@then(r'Check Process Status is "([^\"]*)"')
@when(r'Check Process Status is "([^\"]*)"')
def step_check_process_status(context, status):
    print(f"Checking Process Status: {status}")


# Given 和 When 同时适用
@then(r'(\w+) check (@?[\w\.]+) value is "([^\"]*)"')
@when(r'(\w+) check (@?[\w\.]+) value is "([^\"]*)"')
def step_check_value_exact(context, element, value):
    print(f"Checking if {element} value is exactly {value}")


# Given 和 When 同时适用
@then(r'(\w+) check (@?[\W\.]+) value contain "([^\"]*)"')
@when(r'(\w+) check (@?[\W\.]+) value contain "([^\"]*)"')
def step_check_value_contains(context, element, value):
    print(f"Checking if {element} value contains {value}")


# Given 和 When 同时适用
@given(r'Save instruction Id and URL with prefix "([^\"]*)" from ([\W\.]+) into (\w+) and (\w+)')
@when(r'Save instruction Id and URL with prefix "([^\"]*)" from ([\W\.]+) into (\w+) and (\w+)')
def step_save_instruction_url(context, prefix, element, var1, var2):
    print(f"Saving instruction ID and URL with prefix {prefix} from {element} into {var1} and {var2}")


# Given 和 When 同时适用
@given(r'Save Change Request Id from ([\w\.]+) into (\w+)')
@when(r'Save Change Request Id from ([\w\.]+) into (\w+)')
def step_save_change_request_id(context, element, var):
    print(f"Saving Change Request ID from {element} into {var}")


# Given 和 When 同时适用
@given(r'Get Ticket ID by Subject "([^\"]*)" and save into (\w+)')
@when(r'Get Ticket ID by Subject "([^\"]*)" and save into (\w+)')
def step_get_ticket_id(context, subject, var):
    print(f"Getting Ticket ID by Subject {subject} and saving into {var}")


# Given 和 When 同时适用
@given(r'Open ticket by ID "([^\"]*)"')
@when(r'Open ticket by ID "([^\"]*)"')
def step_open_ticket_by_id(context, ticket_id):
    print(f"Opening ticket by ID: {ticket_id}")


# Given 和 When 同时适用
@given(r'Select Account Change Request by Request_ID "([^\"]*)"')
@when(r'Select Account Change Request by Request_ID "([^\"]*)"')
def step_select_account_change_request(context, request_id):
    print(f"Selecting Account Change Request by Request ID: {request_id}")


# Given 和 When 同时适用
@given(r'Select Account by Account_Number "([^\"]*)"')
@when(r'Select Account by Account_Number "([^\"]*)"')
def step_select_account_by_number(context, account_number):
    print(f"Selecting Account by Account Number: {account_number}")


# Given 和 When 同时适用
@then(r'Check ticket Sub Status is "([^\"]*)"')
@when(r'Check ticket Sub Status is "([^\"]*)"')
def step_check_ticket_sub_status(context, status):
    print(f"Checking ticket Sub Status: {status}")


# Given 和 When 同时适用
@then(r'Check ticket Status is "([^\"]*)"')
@when(r'Check ticket Status is "([^\"]*)"')
def step_check_ticket_status(context, status):
    print(f"Checking ticket Status: {status}")


# Given 和 When 同时适用
@then(r'Check ticket Processing Team is "([^\"]*)"')
@when(r'Check ticket Processing Team is "([^\"]*)"')
def step_check_ticket_processing_team(context, team):
    print(f"Checking ticket Processing Team: {team}")


# Given 和 When 同时适用
@then(r'Check Latest Activity in Audit Trail is "([^\"]*)"')
@when(r'Check Latest Activity in Audit Trail is "([^\"]*)"')
def step_check_latest_activity_in_audit_trail(context, activity):
    print(f"Checking Latest Activity in Audit Trail: {activity}")


# Given 和 When 同时适用
@then(r'Print login user "([^\"]*)"')
@when(r'Print login user "([^\"]*)"')
def step_print_login_user(context, username):
    print(f"Logged in user: {username}")


# Given 和 When 同时适用
@given(r'Get instruction Id')
@when(r'Get instruction Id')
def step_get_instruction_id(context):
    print("Getting instruction ID")


# Given 和 When 同时适用
@when(r'(\w+) click on (@?[\\W\\.]+)')
@given(r'(\w+) click on (@?[\\W\\.]+)')
def step_click_on_element(context, action, element):
    print(f"{action} clicking on {element}")


# Given 和 When 同时适用
@when(r'(\w+) type "([^\"]*)" into (@?[\\w\\.]+)')
@given(r'(\w+) type "([^\"]*)" into (@?[\\w\\.]+)')
def step_type_text_into_inputbox(context, action, text, inputbox):
    print(f"{action} typing text '{text}' into {inputbox}")


# Given 和 When 同时适用
@when(r'(\w+) select "([^\"]*)" from (@?[\\w\.]+)')
@given(r'(\w+) select "([^\"]*)" from (@?[\\w\.]+)')
def step_select_from_dropdownlist(context, action, item, dropdownlist):
    print(f"{action} selecting '{item}' from {dropdownlist}")


# Given 和 When 同时适用
@when(r'(\w+) check on (@?[\\W\\.]+)')
@given(r'(\w+) check on (@?[\\W\\.]+)')
def step_check_on_checkbox(context, action, checkbox):
    print(f"{action} checking on {checkbox}")


# Given 和 When 同时适用
@when(r'(\w+) uncheck on (@?[\\W\\.]+)')
@given(r'(\w+) uncheck on (@?[\\W\\.]+)')
def step_uncheck_on_checkbox(context, action, checkbox):
    print(f"{action} unchecking on {checkbox}")


# Given 和 When 同时适用
@then(r'(\w+) read text from (@?[\\w\\.]+) into (@\w+)')
@when(r'(\w+) read text from (@?[\\w\\.]+) into (@\w+)')
def step_read_text_from_element(context, action, element, variable):
    print(f"{action} reading text from {element} into {variable}")


# Given 和 When 同时适用
@when(r'(\w+) open "([^\"]*)" url')
@given(r'(\w+) open "([^\"]*)" url')
def step_open_url(context, action, url):
    print(f"{action} opening URL: {url}")


# Given 和 When 同时适用
@then(r'(\w+) get current url')
@when(r'(\w+) get current url')
def step_get_current_url(context, action):
    print(f"{action} getting current URL")


# Given 和 When 同时适用
@then(r'(\w+) (am|is) on (@?[\\w\\.]+)')
@when(r'(\w+) (am|is) on (@?[\\w\\.]+)')
def step_check_page_is_open(context, action, state, page):
    print(f"{action} {state} on {page}")


# Given 和 When 同时适用
@then(r'(\w+) see (@?[\\w\\.]+)')
@when(r'(\w+) see (@?[\\w\\.]+)')
def step_check_element_exist(context, action, element):
    print(f"{action} seeing {element}")


# Given 和 When 同时适用
@then(r'(\w+) refresh')
@when(r'(\w+) refresh')
def step_refresh_page(context, action):
    print(f"{action} refreshing the page")
