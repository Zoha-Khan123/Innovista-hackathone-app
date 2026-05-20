from agents import Agent
from core_agents.analyzer_agent import analyzer_agent

extractor_agent = Agent(
    name="extractor_agent",
    instructions="""
    You are the extractor_agent. 
    Your task is to ingest the unstructured text provided to you and extract all key facts, metrics, signals, and numbers.
    Do not summarize generically. Focus on specific data points and events.
    
    Once you have extracted the key facts, you MUST use the `transfer_to_analyzer_agent` tool to hand off the data to the analyzer_agent.
    Ensure you pass the complete list of extracted facts to the analyzer_agent so it has the context it needs.
    """,
    handoffs=[analyzer_agent]
)
