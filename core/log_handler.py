from typing import Any, Dict, Optional, TextIO, cast, List
from uuid import UUID

from langchain_core.callbacks import BaseCallbackHandler
from langchain_core.outputs import LLMResult
from langchain_core.utils.input import print_text
from core import util


class LoggingHandler(BaseCallbackHandler):

    def __init__(
        self, filename: str = 'qa_agent_gpt.log', mode: str = "a", color: Optional[str] = None
    ) -> None:
        """Initialize callback handler."""
        self.file = cast(TextIO, open(filename, mode, encoding="utf-8"))
        self.color = color

    def __del__(self) -> None:
        """Destructor to cleanup when done."""
        self.file.close()

    def on_llm_end(self, response: LLMResult, *, run_id: UUID, parent_run_id: Optional[UUID] = None,
                   **kwargs: Any) -> Any:
        print_text("\n{\"output\":\"" + f"{response.generations[0][0].text}" + "\"}", end="\n", file=self.file)
        print_text(f"\n[{run_id}-end {util.get_local_time()}]", end="\n", file=self.file)

    def on_llm_start(self, serialized: Dict[str, Any], prompts: List[str], *, run_id: UUID,
                     parent_run_id: Optional[UUID] = None, tags: Optional[List[str]] = None,
                     metadata: Optional[Dict[str, Any]] = None, **kwargs: Any) -> Any:
        action_type = metadata.get("action_type")
        name = metadata.get("name")
        desc = metadata.get("desc")
        print_text(
            f"\n[{run_id}-start {util.get_local_time()}] {action_type} ==> {name} ==> {desc}",
            end="\n",
            file=self.file,
        )
        print_text("\n{\"input\":\"" + f"{prompts[0]}" + "\"}", end="\n", file=self.file)

    def on_chain_start(
        self, serialized: Dict[str, Any], inputs: Dict[str, Any], **kwargs: Any
    ) -> None:
        """Print out that we are entering a chain."""
        pass

    def on_chain_end(self, outputs: Dict[str, Any], **kwargs: Any) -> None:
        """Print out that we finished a chain."""
        pass

    def on_text(
        self, text: str, color: Optional[str] = None, end: str = "", **kwargs: Any
    ) -> None:
        """Run when agent ends."""
        print_text(text, color=color or self.color, end=end, file=self.file)

    def on_log_start(
        self, run_id: UUID, name: str, action_type: str = 'step', desc: str = ''
    ) -> None:
        text = f"\n[{run_id}-start {util.get_local_time()}] {action_type} ==> {name} ==> {desc}"
        self.on_text(text)

    def on_log_end(
        self, run_id: UUID
    ) -> None:
        text = f"\n[{run_id}-end {util.get_local_time()}]"
        self.on_text(text)

    def on_log_input(
            self, body: str
    ) -> None:
        text = "\n{\"input\":\"" + f"{body}" + "\"}"
        self.on_text(text)

    def on_log_output(
            self, body: str
    ) -> None:
        text = "\n{\"output\":\"" + f"{body}" + "\"}"
        self.on_text(text)



