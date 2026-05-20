import asyncio
import json
import sys
from agents import Agent, Runner, trace
from connection import config
from core_tools.db import execute_db_action

# Configure stdout to handle unicode characters on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

# 1. Text Preprocessing Agent Definition
from core_agents.preprocessor_agent import text_preprocessing_agent

# 2. Extract Agent Definition (Entry point for multi-agent pipeline)
from core_agents.extractor_agent import extractor_agent

# 3. Orchestration & Execution
async def main():
    raw_business_report = """
    Monthly Sales Report – April 2026
    Sales in Karachi dropped by 28% compared to last month.
    Customer feedback indicates that prices are higher than competitors.
    Website analytics show a 35% increase in cart abandonment.
    Fuel prices increased by 12%, raising delivery costs.
    At the same time, Lahore experienced a 15% increase in orders after running a 10% discount campaign.
    """
    
    with trace("Innovista agent - Challenge 1 Orchestration"):
        print("--- Phase 0: Preprocessing & Normalizing Data ---")
        preprocessor_result = await Runner.run(
            text_preprocessing_agent,
            f"Please clean and normalize this text:\n{raw_business_report}",
            run_config=config
        )
        
        try:
            preprocessor_json = json.loads(preprocessor_result.final_output)
            cleaned_text = preprocessor_json.get("cleaned_text")
            
            if not cleaned_text:
                raise ValueError("The key 'cleaned_text' was missing from the preprocessor's JSON output.")
                
            print(f"[SUCCESS] Cleaned Text Generated (Length: {len(cleaned_text)} chars)")
            
        except json.JSONDecodeError:
            print("[ERROR] Failed to parse output from the Preprocessor Agent as JSON.")
            print(f"Raw Output:\n{preprocessor_result.final_output}")
            return
        except Exception as e:
            print(f"[ERROR] {str(e)}")
            return

        print("\n--- Phase 1: Multi-Agent Analysis & Simulation ---")
        analyzer_result = await Runner.run(
            extractor_agent,
            f"Input:\n{cleaned_text}",
            run_config=config
        )
        
        try:
            analyzer_json = json.loads(analyzer_result.final_output)
            print("\n--- Final Structured Output ---")
            print(json.dumps(analyzer_json, indent=2))
            
            # Attach original input text for traceability
            analyzer_json["original_input"] = raw_business_report
            
            # Trigger Database Agent for full payload
            db_res_1 = await execute_db_action("insight", analyzer_json)
            print(f"\n[DB AGENT] {json.dumps(db_res_1)}")
            
        except json.JSONDecodeError:
            print("[ERROR] Failed to parse output from the Action Agent as JSON.")
            print(f"Raw Output:\n{analyzer_result.final_output}")
            return
        except Exception as e:
            print(f"[ERROR] {str(e)}")
            return

if __name__ == "__main__":
    asyncio.run(main())