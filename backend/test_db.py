import asyncio
import os
import sys
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

async def test_connection():
    print("Loading environment variables...")
    load_dotenv()
    
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        print("ERROR: DATABASE_URL not found in .env")
        return
        
    print(f"Connecting to MongoDB...")
    
    try:
        # Create client
        client = AsyncIOMotorClient(db_url, serverSelectionTimeoutMS=5000)
        
        # Select database and collection
        db = client.get_database("insightflow")
        collection = db.get_collection("test_collection")
        
        print("Connection established. Testing insertion...")
        
        # Insert test document
        test_doc = {"message": "Hello from Google Antigravity Hackathon!", "status": "testing"}
        insert_result = await collection.insert_one(test_doc)
        print(f"SUCCESS: Inserted document with ID: {insert_result.inserted_id}")
        
        # Fetch the document back
        fetched_doc = await collection.find_one({"_id": insert_result.inserted_id})
        print(f"SUCCESS: Retrieved document: {fetched_doc['message']}")
        
        # Cleanup
        await collection.delete_one({"_id": insert_result.inserted_id})
        print("SUCCESS: Cleaned up test document.")
        print("\n[OK] DATABASE CONNECTION IS 100% WORKING!")
        
    except Exception as e:
        print(f"\n[ERROR] DATABASE CONNECTION FAILED:")
        print(str(e))
        print("\nTroubleshooting Tips:")
        print("1. Go to your MongoDB Atlas Dashboard (cloud.mongodb.com)")
        print("2. Click on 'Network Access' on the left sidebar")
        print("3. Ensure you have an IP Address listed as '0.0.0.0/0' (Allow access from anywhere)")
        print("4. Check that your Database User password is correct in the DATABASE_URL")

if __name__ == "__main__":
    asyncio.run(test_connection())
