import json
import re
import uuid
import torch
from pymilvus.milvus_client import IndexParams
from transformers import BertModel, BertTokenizer

from pymilvus import MilvusClient, CollectionSchema, FieldSchema, DataType

from core.config import Config

client = MilvusClient(Config.MILVUS_URL)

collection_name = "test_cases_library"


class TestCasesLibrary:

    def __init__(self):
        # Initialize BERT tokenizer and model
        self.tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
        self.bert_model = BertModel.from_pretrained('bert-base-uncased')

        if not client.has_collection(collection_name=collection_name):
            fields = [
                FieldSchema(name="id", dtype=DataType.VARCHAR, max_length=256),
                FieldSchema(name="test_case", dtype=DataType.JSON),
                FieldSchema(name="summary_vector", dtype=DataType.FLOAT_VECTOR, dim=768),
                # FieldSchema(name="steps_vector", dtype=DataType.FLOAT_VECTOR, dim=768)
            ]

            schema = CollectionSchema(collection_name=collection_name, fields=fields, primary_field="id")
            client.create_collection(collection_name=collection_name, schema=schema)
            index_params = IndexParams(
                index_name="summary_vector_index",
                field_name="summary_vector"
            )
            client.create_index(collection_name=collection_name, index_params=index_params)

    def get_all_test_cases(self):
        try:
            client.load_collection(collection_name=collection_name)
            query_result = client.query(collection_name=collection_name, filter="", output_fields=None, timeout=None,
                                        limit=1000)

            return query_result

        except Exception as e:
            print(f"Failed to query collection: {e}")

    def modify_test_case(self, test_case_id, modified_test_case_text):
        try:
            query_result = client.query(collection_name=collection_name,
                                        filter=f'id="{test_case_id}"',
                                        output_fields=None,
                                        timeout=None,
                                        limit=1)

            if query_result:
                existing_entity = query_result[0][0].entity
                existing_test_case = json.loads(existing_entity["test_case"])

                modified_test_case = self.parse_test_case(modified_test_case_text)
                existing_test_case.update(modified_test_case)

                summary_vector = self.get_bert_vector(existing_test_case["summary"])
                # steps_text = "\n".join([step["step"] for step in existing_test_case["steps"]])
                # steps_vector = self.get_bert_vector(steps_text)

                updated_entity = {
                    "id": existing_entity["id"],
                    "test_case": json.dumps(existing_test_case),
                    "summary_vector": summary_vector,
                    # "steps_vector": steps_vector
                }
                client.upsert(collection_name=collection_name, data=[updated_entity])
                print(f"Test case '{existing_test_case['name']}' modified successfully.")
            else:
                print(f"Test case with id '{test_case_id}' not found.")

        except Exception as e:
            print(f"Error modifying test case: {e}")

    def delete_test_case(self, test_case_id):
        try:
            query_result = client.query(collection_name=collection_name,
                                        filter=f'id="{test_case_id}"',
                                        output_fields=None,
                                        timeout=None,
                                        limit=1)

            if query_result:
                existing_entity = query_result[0][0].entity

                client.delete(collection_name=collection_name, id_array=[existing_entity["id"]])
                print(f"Test case '{existing_entity['test_case']['name']}' deleted successfully.")
            else:
                print(f"Test case with id '{test_case_id}' not found.")

        except Exception as e:
            print(f"Error deleting test case: {e}")

    def search_test_cases(self, query_text):
        topk = 2

        # tfidf = TfidfVectorizer()
        # query_vector = tfidf.fit_transform([query_text]).toarray()[0]

        query_vector = self.get_bert_vector(query_text)
        try:
            client.load_collection(collection_name=collection_name)
            search_response = client.search(
                collection_name=collection_name,
                data=[query_vector],
                search_params={
                    # "metric_type": "L2",
                    "metric_type": "IP",
                    "params": {"topk": topk},
                    "anns_field": "summary_vector"
                },
                output_fields=["test_case"]
            )

            results = []
            for result in search_response:
                for hit in result:
                    # print(str(hit.get("distance")) + str(hit.get("entity").get("test_case")))
                    results.append(json.loads(hit.get("entity").get("test_case")))

            return results[:topk]
        except Exception as e:
            print(f"Error during search: {e}")

    def store_test_case(self, test_case_text):
        test_case = self.parse_test_case(test_case_text)

        # tfidf = TfidfVectorizer()
        steps_text = "\n".join([step["step"] for step in test_case["steps"]])

        # summary_vector = tfidf.fit_transform([test_case["summary"]]).toarray()[0]
        # steps_vector = tfidf.fit_transform([steps_text]).toarray()[0]

        summary_vector = self.get_bert_vector([test_case["summary"]])
        steps_vector = self.get_bert_vector(steps_text)

        try:
            entities = {
                "id": str(uuid.uuid4()),
                "test_case": json.dumps(test_case),
                "summary_vector": summary_vector,
                # "steps_vector": steps_vector
            }
            client.insert(collection_name=collection_name, data=[entities])
            print(f"Test case '{test_case['name']}' added successfully.")
        except Exception as e:
            print(f"Error adding test case: {e}")

    def parse_test_case(self, test_case_text):
        lines = test_case_text.split("\n")
        test_case = {}
        steps = []
        for line in lines:
            line = line.strip()
            if line.startswith('|'):
                parts = [part.strip() for part in re.split(r'\s*\|\s*', line.strip('|').strip())]
                if len(parts) == 4:
                    steps.append({
                        "no": parts[0],
                        "step": parts[1],
                        "data": parts[2],
                        "expected": parts[3]
                    })
            elif line.startswith("Priority:"):
                test_case["priority"] = line.split(":")[1].strip()
            elif line.startswith("Name:"):
                test_case["name"] = line.split(":")[1].strip()
            elif line.startswith("Summary:"):
                test_case["summary"] = line.split(":")[1].strip()

        test_case["steps"] = steps
        return test_case

    def reverse_parse_test_case(self, test_case):
        lines = []

        if "name" in test_case:
            lines.append(f"Name: {test_case['name']}")

        if "summary" in test_case:
            lines.append(f"Summary: {test_case['summary']}")

        if "priority" in test_case:
            lines.append(f"Priority: {test_case['priority']}")

        if "steps" in test_case:
            lines.append("")
            lines.append("| No | Step | Data | Expected |")
            lines.append("|----|------|------|----------|")
            for step in test_case["steps"]:
                lines.append(f"| {step['no']} | {step['step']} | {step['data']} | {step['expected']} |")

        return "\n".join(lines)

    def get_bert_vector(self, text):
        inputs = self.tokenizer(text, return_tensors='pt')
        with torch.no_grad():
            outputs = self.bert_model(**inputs)
        vector = outputs.last_hidden_state.mean(dim=1).squeeze().numpy()
        return vector

    # def get_bert_vector(self, text):
    #     inputs = self.tokenizer(text, return_tensors="pt", padding=True, truncation=True, max_length=128)
    #
    #     with torch.no_grad():
    #         outputs = self.bert_model(**inputs)
    #         embeddings = outputs.last_hidden_state[:, 0, :]
    #
    #     return embeddings.numpy().tolist()
