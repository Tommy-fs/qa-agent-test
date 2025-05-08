import os
import re
import sys
from pathlib import Path

from behave.parser import parse_file
from gherkin.errors import ParserError
from gherkin.parser import Parser


class GherkinValidator:

    def __init__(self,
                 step_pattern_file: str = "D:\\code\\qa-agent-test-new\\knowledge\\nam-case-2\\cucumber_knowledge\\fast_webui_cucumber_project_steps.txt",
                 element_dict_file: str = "D:\\code\\qa-agent-test-new\\knowledge\\nam-case-2\\cucumber_knowledge\\WebElement.yml"):
        self.parser = Parser()
        self.errors = []
        self.warnings = []
        self.step_patterns = self.load_step_patterns(step_pattern_file)
        self.element_dict = self.load_element_dict(element_dict_file)
        self.enable_semantics_validation = False

    def validate_file(self, file_path: str) -> bool:
        self.errors.clear()
        self.warnings.clear()

        if not os.path.exists(file_path):
            self._add_error(f"File not found: {file_path}")
            return False

        if not self._validate_basic_syntax(file_path):
            return False

        self._validate_structure(file_path)

        self._validate_step_parameters(file_path)

        if self.enable_semantics_validation:
            self._validate_step_semantics(file_path)

        return len(self.errors) == 0

    def _validate_basic_syntax(self, file_path: str) -> bool:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            gherkin_document = self.parser.parse(content)

            if not gherkin_document.get('feature'):
                self._add_error("No 'Feature' found in the file")
                return False

            return True
        except ParserError as e:
            self._add_error(f"Syntax error: {str(e)}")
            return False
        except UnicodeDecodeError:
            self._add_error("File encoding error (must be UTF-8)")
            return False

    def _validate_structure(self, file_path: str):
        try:
            feature = parse_file(file_path)

            if not feature.name:
                self._add_warning("Feature has no title")

            for scenario in feature.scenarios:
                if not scenario.name:
                    self._add_error(f"Scenario at line {scenario.line} has no name")

                for step in scenario.steps:
                    if not step.name.strip():
                        self._add_error(f"Empty step at line {step.line}")

                    if step.step_type not in ('given', 'when', 'then', 'and', 'but'):
                        self._add_error(f"Invalid step keyword at line {step.line}")

            for scenario in feature.scenarios:
                if hasattr(scenario, 'examples') and scenario.examples:
                    for example in scenario.examples:
                        if not example.table:
                            self._add_error(f"Empty examples table at line {example.line}")
                            continue

                        if not example.table.headings:
                            self._add_error(f"Examples table has no headings at line {example.line}")

        except Exception as e:
            self._add_error(f"Structure validation failed: {str(e)}")

    def _validate_step_parameters(self, file_path: str):
        try:
            feature = parse_file(file_path)

            for scenario in feature.scenarios:
                for step in scenario.steps:
                    if '<' in step.name and '>' in step.name:
                        if not hasattr(scenario, 'examples') or not scenario.examples:
                            self._add_warning(
                                f"Step contains variables but no examples table: {step.name} "
                                f"at line {step.line}"
                            )
                        else:
                            variable = step.name.split('<')[1].split('>')[0]
                            found = False
                            for example in scenario.examples:
                                if variable in example.table.headings:
                                    found = True
                                    break
                            if not found:
                                self._add_error(
                                    f"Variable '{variable}' not found in examples table "
                                    f"for step at line {step.line}"
                                )
        except Exception as e:
            self._add_error(f"Step parameter validation failed: {str(e)}")

    def _validate_step_semantics(self, file_path: str):
        try:
            feature = parse_file(file_path)

            for scenario in feature.scenarios:
                for step in scenario.steps:
                    step_text = step.name.strip()

                    matched = False
                    for pattern in self.step_patterns:
                        match = pattern.match(step_text)
                        if match:
                            matched = True
                            for group in match.groups():
                                if group not in self.element_dict:
                                    self._add_error(f"Element '{group}' not found for step at line {step.line}")
                            break
                    if not matched:
                        self._add_error(f"Unrecognized step format at line {step.line}: {step_text}")
        except Exception as e:
            self._add_error(f"Step semantic validation failed: {str(e)}")

    def load_step_patterns(self, file_path):
        patterns = []
        with open(file_path, 'r', encoding='utf-8') as f:
            for line_number, line in enumerate(f, 1):  # enumerate starts from 1 to get the line number
                try:
                    match = re.search(r'@(?:Given|When|Then|And|But)\(["\'](.*?)["\']\)', line)
                    if match:
                        regex = match.group(1)
                        corrected_regex = regex.replace("\\\\", "\\")
                        compiled = re.compile(corrected_regex)
                        patterns.append(compiled)
                except Exception as e:
                    self._add_error(
                        f"Error parsing step pattern on line {line_number}: {line.strip()}. Error: {str(e)}")
        return patterns

    def load_element_dict(self, file_path):
        element_map = {}
        with open(file_path, 'r', encoding='utf-8') as f:
            for line_number, line in enumerate(f, 1):  # enumerate starts from 1 to get the line number
                try:
                    if ':' in line:
                        key, value = line.split(':', 1)
                        element_map[key.strip()] = value.strip()
                except Exception as e:
                    self._add_error(
                        f"Error parsing element dictionary on line {line_number}: {line.strip()}. Error: {str(e)}")
        return element_map

    def _add_error(self, message: str):
        self.errors.append(message)

    def _add_warning(self, message: str):
        self.warnings.append(message)

    def print_report(self):
        if not self.errors and not self.warnings:
            print("File is valid with no issues")
            return

        if self.errors:
            print("Validation errors:")
            for error in self.errors:
                print(f"  - {error}")

        if self.warnings:
            print("Validation warnings:")
            for warning in self.warnings:
                print(f"  - {warning}")


def validate_directory(directory: str, recursive: bool = True):
    path = Path(directory)
    validator = GherkinValidator()

    pattern = "**/*.feature" if recursive else "*.feature"
    files = list(path.glob(pattern))

    if not files:
        print(f"No .feature files found in {directory}")
        return

    print(f"Validating {len(files)} Gherkin files...\n")

    all_valid = True
    for file in files:
        print(f"Validating: {file}")
        is_valid = validator.validate_file(str(file))
        validator.print_report()
        print("-" * 50)

        if not is_valid:
            all_valid = False

    if all_valid:
        print("\nAll files passed validation")
    else:
        print("\nSome files failed validation")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python gherkin_validator.py <file_or_directory> [--recursive]")
        sys.exit(1)

    target = sys.argv[1]
    recursive = "--recursive" in sys.argv

    if os.path.isfile(target):
        validator = GherkinValidator()
        if validator.validate_file(target):
            print("\nFile is valid")
            sys.exit(0)
        else:
            print("\nFile is invalid")
            for error in validator.errors:
                print(error)
            sys.exit(1)
    elif os.path.isdir(target):
        validate_directory(target, recursive)
    else:
        print(f"Path not found: {target}")
        sys.exit(1)
