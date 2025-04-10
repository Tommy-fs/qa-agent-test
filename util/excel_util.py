import os
from pathlib import Path

import pandas as pd


def excel_to_str(relative_path, sheet_name=0):
    project_root = find_project_root()
    abs_path = project_root / relative_path

    try:
        df = pd.read_excel(abs_path, sheet_name=sheet_name)
        return df.to_string(index=False)
    except Exception as e:
        return f"excel transfer to str failed : {str(e)}"


def str_to_excel(data_str, relative_path, sheet_name="Sheet1"):
    try:

        project_root = find_project_root()
        abs_path = project_root / relative_path

        os.makedirs(abs_path.parent, exist_ok=True)

        rows = [line.split() for line in data_str.split('\n') if line.strip()]
        df = pd.DataFrame(rows[1:], columns=rows[0]) if rows else pd.DataFrame()

        df.to_excel(abs_path, sheet_name=sheet_name, index=False)
        return f"Excel file has been stored in : {abs_path}"

    except Exception as e:
        return f"Excel file stored failed: {str(e)}"


def find_project_root(marker_file="qa_agent.py"):
    current_path = Path(__file__).parent
    while current_path != current_path.parent:
        if (current_path / marker_file).exists():
            return current_path
        current_path = current_path.parent
    raise FileNotFoundError(f"file not found: {marker_file}")
