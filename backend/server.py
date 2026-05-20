from fastapi import FastAPI, HTTPException, Body, Request
from pydantic import BaseModel
import json
import logging
from agents import Runner, trace
from connection import config
from core_tools.db import execute_db_action

# Import the defined agents
# We import them directly from main.py since that's where they are currently fully defined
from core_agents.extractor_agent import extractor_agent
from core_agents.preprocessor_agent import text_preprocessing_agent
from core_tools.extractors import extract_text_from_pdf, extract_text_from_url

app = FastAPI(
    title="InsightFlow Agentic Microservices",
    description="API exposing OpenAI agents for Google Antigravity Orchestration",
    version="1.0.0"
)

# Enable logging so that openai-agents traces are printed to the console
logging.basicConfig(level=logging.INFO)

# Add CORS middleware to allow Flutter Web to connect to FastAPI
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Pydantic Schemas ---
class AnalyzeRequest(BaseModel):
    raw_data: str

class SimulateRequest(BaseModel):
    delegated_action: str

# --- Endpoints ---

@app.post("/analyze")
async def analyze_data(request: Request):
    """
    Node 2 Target: Receives unstructured data (Text, PDF, URL) and returns extracted facts and recommended action.
    """
    try:
        content_type = request.headers.get("content-type", "")
        raw_data = ""
        original_input_record = ""

        # Handle Multi-modal input from Frontend
        if "multipart/form-data" in content_type:
            form = await request.form()
            input_type = form.get("input_type", "text")
            
            if input_type == "pdf":
                file = form.get("file")
                if not file:
                    raise HTTPException(status_code=400, detail="PDF file missing")
                file_bytes = await file.read()
                raw_data = extract_text_from_pdf(file_bytes)
                original_input_record = f"[PDF Document Uploaded: {file.filename}]"
                
            elif input_type == "url":
                url = form.get("url")
                if not url:
                    raise HTTPException(status_code=400, detail="URL missing")
                raw_data = extract_text_from_url(url)
                original_input_record = f"[Scraped from URL: {url}]"
                
            else:
                raw_data = form.get("raw_data", "")
                original_input_record = raw_data
                
        # Handle JSON (Backward Compatibility)
        elif "application/json" in content_type:
            body_json = await request.json()
            raw_data = body_json.get("raw_data", "")
            original_input_record = raw_data
            
        # Handle Raw Text (Backward Compatibility)
        else:
            body_bytes = await request.body()
            raw_data = body_bytes.decode("utf-8")
            original_input_record = raw_data

        if not raw_data.strip():
            raise HTTPException(status_code=400, detail="No readable content found in input")

        # Phase 0: Preprocess and normalize text
        with trace("Text Preprocessing Phase"):
            pre_result = await Runner.run(
                text_preprocessing_agent, 
                f"Please clean and normalize this text:\n{raw_data}", 
                run_config=config
            )
        preprocessor_json = json.loads(pre_result.final_output)
        cleaned_text = preprocessor_json.get("cleaned_text", raw_data)
        
        # Phase 1: Analyze cleaned text
        with trace("Multi-Agent Orchestration Phase"):
            result = await Runner.run(
                extractor_agent, 
                f"Input:\n{cleaned_text}", 
                run_config=config
            )
        # Parse the output to ensure it's valid JSON before returning to Antigravity
        analyzer_json = json.loads(result.final_output)
        
        # Attach original input for database traceability
        analyzer_json["original_input"] = original_input_record
        
        # Trigger Database Agent for full payload
        await execute_db_action("insight", analyzer_json)
        
        return analyzer_json
    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="Agent returned invalid JSON")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    # Start the server on port 8000
    uvicorn.run(app, host="0.0.0.0", port=8000)
