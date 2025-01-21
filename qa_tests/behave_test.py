from tool.cucumber_script_validation_tool import run_behave_tests, validate_behave_result

run_behave_tests('C:/Users/fs/PycharmProjects/qa-agent-test/qa_tests/result/script_generated.feature', 'C:/Users/fs/PycharmProjects/qa-agent-test/qa_tests/result/result.json')
validate_behave_result('C:/Users/fs/PycharmProjects/qa-agent-test/qa_tests/result/result.json')
