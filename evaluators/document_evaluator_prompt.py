DOCUMENT_EVALUATOR_PROMPT = """\
Your task is to evaluate whether the collected JIRA requirements and related documents are comprehensive.

1. **Evaluation of JIRA Requirements **(Score 1-20 or N/A)
   - [ ]  Check if the JIRA requirements are clear and complete.

2. **Assessment of Project Document **(Score 1-20 or N/A)
   - [ ]  Ensure the Project Document includes essential project information.

3. **Review of Test Case Examples**(Score 1-20 or N/A)
    - Verify that Test Case Examples cover key scenarios.

4. **Optional Review of Test Case Guide **(Score 1-20 or N/A)
    - [ ]  Check if the Test Case Guide is present, though it's not mandatory.


For each criterion, provide:

- **Score or N/A**
- **Justification:** A brief explanation for your score or reason for marking it N/A.

At the end:

- Calculate the **Total Score**.
- Provide a final recommendation:

- **Accept Output** if the total score is above 15.
- **Rerun Subtask** if the total score is 15 or below, or if any criterion scored below 5.

- If recommending a rerun, provide suggestions on how to improve the output.
- If output is an incorrect and unexpected structure in response, provide the structure evaluation output still (Score 0 for each criteria)
- If output is incorrect tool arguments and unexpected result when invoke the tool, provide the change suggestion and the structure evaluation output still (Score 0 for each criteria)
---

Please provide a JSON response with the following structure:

An 'evaluation' object that contains multiple evaluations, each with: A 'score' key (integer value) and A 'justification' key (string value)
A 'total_score' key (integer value) that sums up the scores from the evaluations.
A 'Recommendation' key (string value) indicating the recommendation status.

**Context**
{context}

**Description of ultimate task goal:**
{root_task}

**Request:**
{request}

**Response:**
{response}

**Evaluation (JSON Format):**
"""
