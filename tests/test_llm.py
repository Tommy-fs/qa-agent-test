from core.llm_chat import LLMChat
from knowledges.result_summary import SUMMARY

chat = LLMChat()

summary_parameters = {
    "content": """LLM, or Large Language Model, represents a cutting-edge artificial intelligence technology 
    developed primarily by OpenAI. It leverages deep learning techniques, particularly the Transformer architecture, 
    to process and generate human language text. At its core, LLM excels in tasks involving natural language 
    understanding and generation, encompassing functionalities such as text generation, translation, 
    question answering, and summarization. Trained on vast amounts of text data sourced from the internet, 
    LLM possesses extensive knowledge and language comprehension capabilities across diverse linguistic forms and 
    topics. This training methodology enables it to learn language grammar, semantic relationships, and contextual 
    nuances, facilitating natural and fluent language interactions in various domains and contexts.

    LLMs have demonstrated remarkable proficiency in a wide array of applications, including but not limited to 
    conversational agents, content generation, sentiment analysis, and automated customer support. Their ability to 
    comprehend and generate human-like text has significantly advanced capabilities in natural language processing, 
    offering scalable solutions for both commercial and research purposes.

    In summary, LLMs represent a transformative advancement in AI-driven language technologies, bridging the gap between 
    human language understanding and machine-generated text, with profound implications for fields ranging from education 
    and healthcare to business and entertainment."""
}
response = LLMChat().prompt_with_parameters(SUMMARY, summary_parameters, 'Summary')

print(response)
