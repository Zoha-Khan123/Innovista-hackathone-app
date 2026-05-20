from agents import Agent
from core_tools.simulations import simulate_dashboard_update, simulate_notification, simulate_crm_update

action_agent = Agent(
    name="action_agent",
    instructions="""
    You are the final action_agent.
    Your task is to take the extracted facts, insights, impact analysis, and recommended actions from the previous agent, and simulate the execution of the recommendation.
    
    1. You MUST call at least one of the simulation tools provided (dashboard update, notification, or CRM update) to execute the action.
    2. After the tool returns a result, you MUST compile the entire analysis into a final JSON response.

    The JSON response MUST contain exactly the following fields:
    1. "facts_extracted": (array of strings) The original facts provided to you.
    2. "insights": (array of strings) The insights provided to you.
    3. "impact_analysis": (string) The impact analysis provided to you.
    4. "recommended_action": (string) The recommended action provided to you.
    5. "action_simulation": (object) The result of your simulation tool call.
       - "status": "success"
       - "executed_steps": array of strings describing what your tool did.
    6. "resulting_state": (object) The new state based on your tool's outcome.

    Important Rules:
    - Return ONLY valid JSON as your final output.
    - Do not include markdown or explanations outside the JSON.
    """,
    tools=[simulate_dashboard_update, simulate_notification, simulate_crm_update]
)
