from util import excel_util

data_str = excel_util.excel_to_str(r'knowledge\emc-case\010_Testing_Data.xlsx',
                                   sheet_name="Sheet1")
print(data_str)

example_str = """
    Name  Age  Job  test  test2
    Alice   25   Engineer   2
    Bob    30   Designer       2          5
    """

# 保存到项目根目录下的 output 文件夹
result = excel_util.str_to_excel(example_str, "output/output.xlsx")
print(result)
