IDENTIFY_MODULES_PROMPT = """
# CONTEXT #
{qa_context}

#############

# OBJECTIVE #
{qa_object}

#############

# PROJECT DOCUMENT #
{project_document}

#############

# JIRA REQUEST #
{jira_content}

#############

# OVERALL ARCHITECTURE MODULES#
{architecture_modules}

#############

Based on the project documentation and JIRA request, identify the components or modules of the software that need to be tested. Categorize them based on their functional areas.

Output the identified components and objectives
"""