# example1.py

from agent_core.agents import Agent


def main():
    agent = Agent(model_name="gemini-1.5-flash-002")
    agent.execute("Who are you?")
    print(f"Response: {agent.execution_responses}")


if __name__ == "__main__":
    main()
