import weaviate
from core.config import Config
from langchain_community.embeddings import OpenAIEmbeddings


def singleton(cls, *args, **kwargs):
    instances = {}

    def wrapper():
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return wrapper


weaviate_test_case_collection = "TEST_CASE"


@singleton
class WeaviateClient:

    def __init__(self):
        self.weaviate_client = weaviate.connect_to_local(host=Config.WEAVIATE_HOST, port=8088)
        collections = self.weaviate_client.collections.list_all()
        if weaviate_test_case_collection not in collections.keys():
            self.weaviate_client.collections.create(weaviate_test_case_collection)

    def create_object(self, class_name, data, vector):
        self.weaviate_client.collections.get(class_name).data.insert(
            properties=data,
            vector=vector
        )

    def delete_collection(self, class_name):
        self.weaviate_client.collections.delete(class_name)

    def get_method_explanation(self, user_query, limit=10):
        return self.weaviate_client.query \
            .get(Config.WEAVIATE_METHOD_COLLECTION, ["package", "class", "method"]) \
            .with_near_vector({"vector": OpenAIEmbeddings().embed_query(user_query)}) \
            .with_limit(limit) \
            .do()['data']['Get'][Config.WEAVIATE_METHOD_COLLECTION]
