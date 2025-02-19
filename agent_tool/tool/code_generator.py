from typing import Annotated
import re
import logging

from agent_core.agents import Agent
from langchain_core.tools import tool

from agent_tool.code.system_context import CODE_GENERATOR_SYSTEM_MESSAGE
from agent_tool.code.file_dict import FilesDict
from agent_tool.code.file_selector import FileSelector
from agent_tool.code.file_store import FileStore

@tool("code")
def code(
    local_repo: Annotated[str, 'local repository file path'],
    change_suggestion: Annotated[str, 'the change suggestions'],
    need_changed_file_path: Annotated[
        str, 'only contains the File Path with string format instead of json, file path should be like src/component/<component>/<filename>, split by comma if exist multiple filepath']
) -> str:
    """
    Generate new code or improve existing code based on the provided modification advice.
    This process involves analyzing the given recommendations, understanding the necessary changes,
    and implementing the adjustments in the codebase.
    The goal is to enhance functionality, optimize performance, and ensure the code meets the specified requirements and best practices.
    """
    code_instance = Code()
    detail = change_suggestion
    code_instance.run(project_path=local_repo, prompt_str=detail, selected_files=need_changed_file_path)
    return 'Code Change Success'

class Code:
    def run(self, project_path: str = ".", prompt_str: str = "", selected_files: str = ""):

        logging.basicConfig(level=logging.INFO)
        file_store = FileStore(project_path)
        files_dict_before = FileSelector(project_path).ask_for_files(selected_files)

        agent = Agent()
        agent.context.add_context("system", CODE_GENERATOR_SYSTEM_MESSAGE)
        agent.background = f"here is source code: {files_dict_before.to_chat().replace('{', '{{').replace('}', '}}')}"

        ai_response = agent.execute(prompt_str)
        logging.info("AI response:")
        logging.info(ai_response)

        files_dict = self.handle_ai_response(ai_response, files_dict_before)

        if not files_dict or files_dict_before == files_dict:
            logging.info("No changes applied.")
        else:
            diff_summary = file_store.compare(files_dict_before, files_dict)
            logging.info("Changes to be made:")
            logging.info(diff_summary)
        file_store.push(files_dict)

    def handle_ai_response(self, ai_response: str, original_files: FilesDict) -> FilesDict:
        """
        Parse the AI response to extract multiple file modifications.
        Expected format for each file block:
            FILE_START
            file: <file_path>
            <file content>
            FILE_END
        If a file block does not include a file path, fallback to apply the change to each originally selected file.
        """

        pattern = re.compile(r'FILE_START\s+file:\s*(.*?)\n(.*?)\nFILE_END', re.DOTALL)
        matches = pattern.findall(ai_response)
        files = {}
        if matches:
            for file_path, content in matches:
                file_path = file_path.strip()
                content = self.clean_code_block(content)
                files[file_path] = content.rstrip()
        else:
            # fallback
            pattern_single = re.compile(r'FILE_START\s*\n(.*?)\nFILE_END', re.DOTALL)
            updated_code = pattern_single.findall(ai_response)
            if updated_code:
                for key in original_files.keys():
                    files[key] = updated_code[0].rstrip()
        return FilesDict(files)

    def clean_code_block(self, content: str) -> str:
        """
        Cleans the code block content by removing language markers like ```java and similar.
        """
        content = re.sub(r'```.*?\n', '', content)
        content = re.sub(r'```', '', content)
        return content

