import os
import uvicorn
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
from google import genai
from google.genai import types
from dotenv import load_dotenv

load_dotenv()

# Configuration
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
MAX_SAFE_EVENTS = 2000  

app = FastAPI(title="ESCAPIA AI Report Generator API", redirect_slashes=False)

class IncidentRequest(BaseModel):
    incidentId: str
    startAt: str
    endAt: Optional[str] = None
    status: str
    logs: List[Dict[str, Any]]

def get_val(d: Dict, key1: str, key2: str, default: Any = None) -> Any:
    """Helper to safely get values whether they are camelCase or PascalCase."""
    return d.get(key1, d.get(key2, default))

def process_and_compress_logs(logs: List[Dict[str, Any]]) -> List[str]:
    """Compresses raw logs into a timeline of unique state changes to optimize LLM context."""
    if not logs:
        return []

    compressed_timeline = []
    last_state = None
    event_counter = 1

    for curr in logs:
        route = get_val(curr, 'fullRoute', 'FullRoute', [])
        risk = get_val(curr, 'riskLevel', 'RiskLevel', 'Low')
        fire = get_val(curr, 'fireDetected', 'FireDetected', False)

        if last_state is None or \
           route != get_val(last_state, 'fullRoute', 'FullRoute') or \
           risk != get_val(last_state, 'riskLevel', 'RiskLevel') or \
           fire != get_val(last_state, 'fireDetected', 'FireDetected'):

            ts = get_val(curr, 'timestamp', 'Timestamp', 'Unknown Time')
            safe_exits = get_val(curr, 'safeExitsCount', 'SafeExitsCount', '?')
            total_exits = get_val(curr, 'totalExits', 'TotalExits', 2)
            zone = get_val(curr, 'zoneId', 'ZoneId', 'Unknown')
            
            route_str = " -> ".join(route)
            fire_str = "YES" if fire else "NO"

            log_line = f"[{ts}] Event {event_counter}: {zone} | Fire: {fire_str} | Risk: {risk} | Safe Exits: {safe_exits}/{total_exits} | Route: [{route_str}]"
            compressed_timeline.append(log_line)

            last_state = curr
            event_counter += 1

    return compressed_timeline   

def enforce_hard_cap(events: List[str], max_events: int = MAX_SAFE_EVENTS) -> str:
    """Truncates the middle of the timeline to prevent exceeding Gemini API token limits."""
    if len(events) <= max_events:
        return "\n".join(events) 

    head_cnt = int(max_events * 0.3)
    tail_cnt = int(max_events * 0.3)
    mid_cnt = max_events - head_cnt - tail_cnt

    head = events[:head_cnt]
    tail = events[-tail_cnt:]
    mid_pool = events[head_cnt:-tail_cnt]
    
    step = max(1, len(mid_pool) // mid_cnt)
    middle = mid_pool[::step][:mid_cnt]
    omitted_msg = "\n... [SOME EVENTS OMITTED TO STAY WITHIN API LIMITS] ...\n"

    return "\n".join(head + [omitted_msg] + middle + [omitted_msg] + tail)

def generate_incident_report(incident_id: str, start_at: str, end_at: Optional[str], status: str, compressed_text: str) -> Optional[str]:
    """Invokes Gemini API to generate a structured Markdown post-incident report."""
    client = genai.Client(api_key=GEMINI_API_KEY)

    prompt = (
        f"Analyze the following ESCAPIA System emergency timeline for Incident ID: {incident_id}.\n"
        f"Incident Status: {status}\n"
        f"Started At: {start_at}\n"
        f"Ended At: {end_at if end_at else 'Ongoing (Not concluded yet)'}\n\n"
        "Generate a concise, elegant, and highly readable Post-Incident Report.\n\n"
        f"INCIDENT TIMELINE DATA:\n{compressed_text}"
    )

    try:
        response = client.models.generate_content(
            model="gemini-3.6-flash",
            contents=prompt,
            config=types.GenerateContentConfig(
                system_instruction=(
                    "You are an elite Fire Safety and Security Analyst for the ESCAPIA AI System. "
                    "Your job is to analyze real-time telemetry events for a SINGLE isolated emergency incident "
                    "and generate a concise, elegant, and visually appealing Post-Incident Report in Markdown format. "
                    "The report MUST be medium-length and include: "
                    "1. Executive Summary (Brief overview of the crisis, utilizing the provided start and end times). "
                    "2. Critical Timeline (Only the most important chronological highlights, referencing timestamps). "
                    "3. Evacuation & Routing (Dynamic replanning triggers and safe exits availability). "
                    "4. Actionable Recommendations. "
                    "Tone: Official, objective, analytical, and sleek."
                )
            )
        )
        return response.text
    except Exception as e:
        print(f"\n[CRITICAL ERROR] Gemini failed: {str(e)}\n")
        return None

@app.post("/api/generate-report")
def api_generate_report(request: IncidentRequest):
    """Receives incident data from ASP.NET backend and returns the AI-generated Markdown report."""
    if not request.logs:
        raise HTTPException(status_code=400, detail="No logs provided.")
        
    compressed_timeline = process_and_compress_logs(request.logs)
    safe_payload = enforce_hard_cap(compressed_timeline)

    report_markdown = generate_incident_report(
        request.incidentId, 
        request.startAt, 
        request.endAt, 
        request.status, 
        safe_payload
    )

    if not report_markdown:
        raise HTTPException(status_code=500, detail="Failed to generate AI report.")

    return {
        "status": "success",
        "incidentId": request.incidentId, 
        "report_markdown": report_markdown
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)