import os


class Config:

    MILVUS_URL = 'http://149.28.241.76:19530'
    OPENAI_MODEL_3 = 'gpt-3.5-turbo-0125'
    OPENAI_MODEL_4 = 'gpt-4o'
    os.environ['OPENAI_API_BASE'] = 'https://api.ohmygpt.com/v1/'
    os.environ['OPENAI_API_KEY'] = 'sk-WZv2j01UF693Aa9d09e6T3BLbKFJ316F20ab612040c189cc'