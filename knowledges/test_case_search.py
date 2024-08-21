TEST_CASE_SEARCH_PROMPT = """
This is a newly generated test case:

{generated_test}

Please find the most similar case in the vector database according to the summary and test step.
"""