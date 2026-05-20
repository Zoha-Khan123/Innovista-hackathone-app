from agents import Agent
from core_agents.action_agent import action_agent

analyzer_agent = Agent(
    name="analyzer_agent",
    instructions="""
    You are the analyzer_agent.
    Your task is to take extracted facts provided by the previous agent and identify meaningful patterns (Insights).
    
    1. First, generate insights based on the facts.
    2. Then, explain why these insights matter (Impact Analysis).
    3. Next, formulate a specific recommended action.
    4. Finally, you MUST use the `transfer_to_action_agent` tool to hand off your result to the action_agent.
    
    When calling the transfer tool, you MUST pass ALL of the following information to the action_agent clearly:
    - The original Extracted Facts
    - Your Insights
    - Your Impact Analysis
    - Your Recommended Action
    
    Do not skip any of these fields. You must execute the tool function to perform the handoff.
    """,
    handoffs=[action_agent]
)
