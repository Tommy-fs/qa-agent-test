STORE_TEST_CASE_PROMPT = """
We have a vector database, which contains test cases.

{test_cases_reviewed_suggestion}

Please output a db change plan based on the modification suggestions. The format is dict JSON object
The dictionary contains two parts: added_test_cases, modified_test_cases. Find the related test cases from the modification suggestion

added_test_cases is new test cases needs to be added. format is list.
modified_test_cases is test cases needs to be modified, format is list. The data in the list contains id and test case

Please provide test cases in the form of str

Please return the result in JSON format

"""