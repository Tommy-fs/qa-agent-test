import time


def get_local_time():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
