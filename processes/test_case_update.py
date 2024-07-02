import uuid

from processes.process import Process


class TestCaseUpdate(Process):

    def __init__(self):
        super().__init__("review test case")

    def execute(self, inputs, log):
        generate_id = uuid.uuid1()

