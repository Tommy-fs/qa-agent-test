import uuid
from core.log_handler import LoggingHandler
from tool.cucumber_script_generate_tool import readFile


def understand_cucumber_script_knowledge():
    generate_id = uuid.uuid1()
    log = LoggingHandler()
    log.on_log_start(generate_id, 'Understand cucumber script knowledge', desc='Feed cucumber script base knowledge')

    cucumber_script_base = readFile("../knowledges/apac-email-case/cucumber_knowledges/cucumber_script_base.feature")
    available_web_elements = readFile("../knowledges/apac-email-case/cucumber_knowledges/WebElement.yml")
    available_webui_cucumber_system_steps = readFile(
        "../knowledges/apac-email-case/cucumber_knowledges/fast_webui_cucumber_system_steps.txt")
    available_webui_cucumber_project_steps = readFile(
        "../knowledges/apac-email-case/cucumber_knowledges/fast_webui_cucumber_project_steps.txt")

    contextStr = f"\n<CUCUMBER_SCRIPT_BASIC_EXAMPLE>\n{cucumber_script_base}\n</CUCUMBER_SCRIPT_BASIC_EXAMPLE>\n"
    contextStr += f"\n<AVAILABLE_WEB_ELEMENTS>\n{available_web_elements}\n</AVAILABLE_WEB_ELEMENTS>\n"
    contextStr += f"\n<AVAILABLE_WEBUI_CUCUMBER_SYSTEM_STEPS>\n{available_webui_cucumber_system_steps}\n</AVAILABLE_WEBUI_CUCUMBER_SYSTEM_STEPS>\n"
    contextStr += f"\n<AVAILABLE_WEBUI_CUCUMBER_PROJECT_STEPS>\n{available_webui_cucumber_project_steps}\n</AVAILABLE_WEBUI_CUCUMBER_PROJECT_STEPS>\n"

    log.on_log_end(generate_id)
    return contextStr
