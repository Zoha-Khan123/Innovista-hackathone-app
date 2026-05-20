import os
from datetime import datetime, timezone
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL environment variable is missing!")

# Connect to MongoDB cluster
client = AsyncIOMotorClient(DATABASE_URL)

# Since the provided URI doesn't have a default DB name before the '?',
# we will connect to a default 'insightflow' database
db = client.get_database("insightflow")

async def execute_db_action(agent_type: str, data: dict) -> dict:
    """
    Database Execution Agent function to persist structured data into MongoDB.
    Follows strictly defined output formatting without explanation.
    """
    document = data.copy()
    document["created_at"] = datetime.now(timezone.utc)
    
    if agent_type == "insight":
        collection_name = "insights_collection"
    elif agent_type == "simulation":
        collection_name = "simulation_collection"
    elif agent_type == "campaign":
        collection_name = "campaign_collection"
    else:
        raise ValueError(f"Unknown agent_type: {agent_type}")
        
    collection = db.get_collection(collection_name)
    
    # Insert document
    result = await collection.insert_one(document)
    
    # Return strict JSON formatted response
    return {
        "status": "success",
        "operation": "insert",
        "collection": collection_name,
        "record_id": str(result.inserted_id)
    }
