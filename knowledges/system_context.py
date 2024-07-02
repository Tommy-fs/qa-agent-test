SYSTEM_CONTEXT = """
Answer the user's questions based on the below context. 
If the context doesn't contain any relevant information to the question, don't make something up and just say "I don't know":
{context}
"""

SYSTEM_CONTEXT_WITH_TOOLS = """
Answer the user's questions based on the below context. 
{context}
If the context doesn't contain any relevant information to the question, please try to use tools.

You have access to the following set of tools. 
Here are the names and descriptions for each tool:

{tools}

Given the user input, return the name and input of the tool to use. 
Return your response as a JSON blob with 'name' and 'arguments' keys.

The `arguments` should be a dictionary, with keys corresponding to the argument names and the values corresponding to the requested values.
If the tool to be used no arguments defined, then don't generate arguments as output.

If no tools is relevant to use, don't make something up and just say "I don't know".
"""

PLAN_FORMAT = """
Based on backgroud and knowledges above to generate a plan, put each step in the json format as the output, step has attribute step_name and step_description, all steps are under 'steps' root attribute.
ex: step_name: Prepare eggs, step_description: Get the eggs from the fridge and put on the table.
"""

CODE_GENERATION_PROMPT = "\nContext is invisible for me, so put all needed context information into your response and provide implementation code as detailed as possible."