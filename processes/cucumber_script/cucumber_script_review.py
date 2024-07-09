import uuid

from processes.process import Process


class CucumberScriptReview(Process):

    def __init__(self):
        super().__init__("cucumber script review")

    def execute(self, inputs, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Cucumber script review', desc='Cucumber script review base on test case')


