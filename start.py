import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel

from qa_agent import QAAgent

app = FastAPI()


class Item(BaseModel):
    id: str
    content: str


@app.get("/test_case")
def develop(item: Item):
    QAAgent().run(item.id, item.content)
    return {"message": "end"}


# Upgrade spring-boot-start-parent library version from 3.1.5 to 3.2.3
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
