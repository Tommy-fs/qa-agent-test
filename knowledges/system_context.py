SYSTEM_CONTEXT = """
Answer the user's questions based on the below context. 
If the context doesn't contain any relevant information to the question, don't make something up and just say "I don't know":
{context}
"""

SYSTEM_CONTEXT_WITH_TOOLS = """
Answer the human's question using the following context and tools:

Context:
{context}

Use tools with context to answer questions.

You have access to the following set of tools. 
Here are the names and descriptions for each tool:

Available Tools:
{tools}

Given the user input, return the name and input of the tool to use. 
Return your response as a JSON dictionary with 'name' and 'inputs' keys.

The `inputs` should be a dictionary, represent the specific parameter values required by the tool. You need to pass them as input to the tool.

The `input` keys corresponding to the argument names.
Find the parameters required by the tool method from the context as 'input' values.
Do not use the parameter description in the tool as the 'input' value. Instead, find the corresponding content in the context as the 'input' value.
Do not use the label - <> in the context as the 'input' value, but use the specific content between the label <> and </> as the 'input' value.
The format of `input` value must conform to the type of argument defined in tool.

If the tool to be used no arguments defined, then don't generate arguments as output.

"""

PLAN_FORMAT = """
Based on background and knowledge above to generate a plan, put each steps in the json format as the output, steps has attribute step_name, step_description, and step_output, all steps are under 'steps' root attribute.
ex: step_name: Prepare eggs, step_description: Get the eggs from the fridge and put on the table, step_output: Prepared eggs on table
"""

CODE_GENERATION_PROMPT = "\nContext is invisible for me, so put all needed context information into your response and provide implementation code as detailed as possible."