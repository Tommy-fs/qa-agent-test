from flask import Flask, render_template
from flask_socketio import SocketIO
import eventlet

from qa_tests import qa_agent_test

eventlet.monkey_patch()

app = Flask(__name__)
socketio = SocketIO(app, async_mode='eventlet', cors_allowed_origins="*")


@app.route('/')
def index():
    return render_template('index.html')


def long_running_process():
    with app.app_context():
        try:
            qa_agent_test.test(log_update)
        except Exception as e:
            print(f"Exception: {e}")  # 输出错误信息


@app.route('/start-process')
def start_process():
    print("process begin")
    socketio.start_background_task(long_running_process)
    return 'Process Started'


def log_update(step=None, result=None):
    socketio.emit('log_update', {'step': step, 'result': result}, broadcast=True)


if __name__ == '__main__':
    socketio.run(app, host='127.0.0.1', port=5000, debug=True)
