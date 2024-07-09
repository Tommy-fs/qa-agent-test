import uuid

from processes.process import Process


class CucumberScriptGenerate(Process):

    def __init__(self):
        super().__init__("generate cucumber script")

    def execute(self, inputs, log):
        generate_id = uuid.uuid1()
        log.on_log_start(generate_id, 'Generate cucumber script', desc='Generate cucumber script base on test case')


