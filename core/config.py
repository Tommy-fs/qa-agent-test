import os


class Config:

    WEAVIATE_URL = ''
    MONGO_URL = 'mongodb://localhost:27017'
    WEAVIATE_METHOD_COLLECTION = 'Method'
    WEAVIATE_CLASS_COLLECTION = 'Clazz'
    WEAVIATE_RAW_COLLECTION = 'RAW'
    OPENAI_MODEL_3 = 'gpt-3.5-turbo-0125'
    OPENAI_MODEL_4 = 'gpt-4o'
    SQL_DDL_DML_FILE_PATH = '/Users/liuzhongxu/PycharmProjects/code-interpreter/database.sql'
    os.environ['OPENAI_API_BASE'] = 'https://api.ohmygpt.com/v1/'
    os.environ['OPENAI_API_KEY'] = 'sk-WZv2j01UF693Aa9d09e6T3BLbKFJ316F20ab612040c189cc'
