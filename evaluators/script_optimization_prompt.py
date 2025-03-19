CUCUMBER_OPTIMIZATION_PROMPT = """
You are an cucumber scripts code writing with extensive experience in software test engineering.
Your task is to Optimize the provided AI-generated cucumber scripts code based on the following comprehensive suggestion and related document. 

        
# test case #
{test_case}

# Original Script #
{cucumber_script}

# Suggestion #
{suggestion}


# CUCUMBER SCRIPT TEMPLATE #

{cucumber_script_basic_template}

# GUIDELINE #
Use CUCUMBER SCRIPT TEMPLATE and GUIDELINE together to complete the creation of the script(if have).

{script_generate_guide}

# AVAILABLE WEB ELEMENTS #
If AVAILABLE WEB ELEMENTS is provided, You must use the provided web elements as part of the script. 
Otherwise you need to write a new script file according to elements in CUCUMBER SCRIPT TEMPLATE

{available_web_elements}

# AVAILABLE WEBUI CUCUMBER SYSTEM STEPS #

If AVAILABLE WEBUI CUCUMBER STEPS is provided, You must use the provided web ui cucumber steps as part of the script. 
Otherwise you need to write a new script file according to the steps in CUCUMBER SCRIPT TEMPLATE

{available_webui_cucumber_system_steps}

# AVAILABLE WEBUI CUCUMBER PROJECT STEPS #
{available_webui_cucumber_project_steps}
"""
