import argparse
import importlib
import logging


def get_project_knowledge(class_name, module_file):
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        module_path = "knowledge." + case + ".project_knowledge." + module_file

        return get_class_module(class_name, module_path)
    except Exception as e:
        logging.error("get project knowledge error")
        raise


def get_jira_info(class_name, module_file):
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        module_path = "knowledge." + case + module_file

        return get_class_module(class_name, module_path)
    except Exception as e:
        logging.error("get project knowledge error")
        raise


def get_cucumber_knowledge(module_file):
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--case", required=True)
        args = parser.parse_args()
        case = args.case

        knowledge = readFile(
            "../knowledge/" + case + "/cucumber_knowledge/" + module_file)

        return knowledge
    except Exception as e:
        logging.error("get project knowledge error")
        raise


def readFile(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            file_content = file.read()
        return file_content
    except:
        return ""


def get_class_module(class_name, module_path):
    try:
        module = importlib.import_module(module_path)
        res = getattr(module, class_name)
        return res
    except Exception as e:
        logging.error("get class module content error")
        raise
