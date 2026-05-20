from agents import function_tool

@function_tool
def simulate_dashboard_update(insight: str, metrics: str):
    """
    Simulate updating a business dashboard with new insights and metrics.
    """
    print(f"\n[SIMULATION: Dashboard Update] Dashboard updated with insight: '{insight}'")
    print(f"[SIMULATION: Dashboard Update] Metrics changed: {metrics}\n")
    return "Dashboard successfully updated."

@function_tool
def simulate_notification(recipient: str, message: str):
    """
    Simulate sending a notification (Email/SMS) to a specific recipient.
    """
    print(f"\n[SIMULATION: Notification] Sent to {recipient}: '{message}'\n")
    return f"Notification sent to {recipient}."

@function_tool
def simulate_crm_update(action: str, details: str):
    """
    Simulate updating a CRM or logging an action to the database.
    """
    print(f"\n[SIMULATION: CRM Update] Action logged: '{action}'")
    print(f"[SIMULATION: CRM Update] Details: {details}\n")
    return "CRM successfully updated."
