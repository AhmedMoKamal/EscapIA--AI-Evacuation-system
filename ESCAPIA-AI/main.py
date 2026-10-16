import os
import sys
import cv2
import json
import time
import requests
import threading
import queue
import subprocess
from ultralytics import YOLO
from decision_engine import EvacuationPlanner
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration
IP_CAMERA_URL = os.getenv("IP_CAMERA_URL")
API_URL = os.getenv("BACKEND_API_URL")
LOG_FILENAME = "ai_log_data.jsonl"


class BackendSyncEngine:
    """Silent background worker to send API updates without lagging the camera or cluttering the terminal."""
    def __init__(self, api_url, sync_interval=1.0):
        self.api_url = api_url
        self.sync_interval = sync_interval
        self.latest_states = {}
        self.lock = threading.Lock()
        self.stopped = False
        self.session = requests.Session()
        self.session.headers.update({"Content-Type": "application/json"})
        self.thread = threading.Thread(target=self._worker, daemon=True)
        self.thread.start()

    def update_state(self, zone_id, state_payload):
        with self.lock:
            self.latest_states[zone_id] = state_payload.copy()

    def _worker(self):
        while not self.stopped:
            with self.lock:
                payloads = list(self.latest_states.values())
                self.latest_states.clear()

            for payload in payloads:
                if self.stopped or not self.api_url:
                    break
                try:
                    self.session.post(self.api_url, json=payload, timeout=3.0)
                except requests.exceptions.RequestException:
                    pass

            time.sleep(self.sync_interval)

    def stop(self):
        self.stopped = True


class SpeakerEngine:
    """Isolated process TTS engine to guarantee reliable multi-event speech on Windows without freezing."""
    def __init__(self):
        self.q = queue.Queue()
        self.thread = threading.Thread(target=self._worker, daemon=True)
        self.thread.start()

    def _worker(self):
        tts_script = (
            "import sys, pyttsx3; "
            "engine = pyttsx3.init(); "
            "engine.setProperty('rate', 160); "
            "engine.say(sys.argv[1]); "
            "engine.runAndWait()"
        )
        creation_flags = subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0

        while True:
            text = self.q.get()
            if text is None:
                break

            try:
                subprocess.run(
                    [sys.executable, "-c", tts_script, text],
                    creationflags=creation_flags,
                    check=False
                )
            except Exception as e:
                print(f"\n[TTS WARNING] Failed to speak: {e}")

            self.q.task_done()

    def speak(self, text):
        self.q.put(text)


class CameraStream:
    """Background threaded camera stream for optimal FPS."""
    def __init__(self, src=0):
        self.stream = cv2.VideoCapture(src)
        self.grabbed, self.frame = self.stream.read()
        self.stopped = False
        self.thread = threading.Thread(target=self.update, daemon=True)
        self.thread.start()

    def update(self):
        while not self.stopped:
            self.grabbed, self.frame = self.stream.read()
        self.stream.release()

    def read(self):
        return self.grabbed, self.frame

    def stop(self):
        self.stopped = True
        if hasattr(self, 'thread') and self.thread.is_alive():
            self.thread.join()


def process_zone(frame, people_model, hazard_model, zone_id, counters, planner, building_state, prev_routes, speaker):
    """Core AI pipeline: detection, tracking, risk assessment, and dynamic routing."""
    results_people = people_model.track(frame, classes=[0], tracker="bytetrack.yaml", persist=True, verbose=False)
    results_hazard = hazard_model(frame, conf=0.55, verbose=False)

    people_count = 0
    fire_boxes, smoke_boxes = [], []

    # Hazard Detection
    if len(results_hazard[0].boxes) > 0:
        boxes = results_hazard[0].boxes.xyxy.cpu().numpy()
        class_ids = results_hazard[0].boxes.cls.int().cpu().tolist()
        confs = results_hazard[0].boxes.conf.cpu().tolist()
        names = results_hazard[0].names

        for box, cls_id, conf in zip(boxes, class_ids, confs):
            x1, y1, x2, y2 = map(int, box)
            detected_class = names[cls_id].lower()

            if "fire" in detected_class and conf >= 0.68:
                fire_boxes.append((x1, y1, x2, y2))
            elif "smoke" in detected_class and conf >= 0.75:
                smoke_boxes.append((x1, y1, x2, y2))

    # Sticky Memory Filter with Hysteresis Latch
    if fire_boxes:
        counters[zone_id]["fire"] = min(60, counters[zone_id]["fire"] + 3)
        if counters[zone_id]["fire"] >= 45:
            counters[zone_id]["fire_latched"] = True
            counters[zone_id]["fire"] = 60
    else:
        counters[zone_id]["fire"] = max(0, counters[zone_id]["fire"] - 3)
        if counters[zone_id]["fire"] == 0:
            counters[zone_id]["fire_latched"] = False

    if smoke_boxes:
        counters[zone_id]["smoke"] = min(60, counters[zone_id]["smoke"] + 3)
        if counters[zone_id]["smoke"] >= 45:
            counters[zone_id]["smoke_latched"] = True
            counters[zone_id]["smoke"] = 60
    else:
        counters[zone_id]["smoke"] = max(0, counters[zone_id]["smoke"] - 3)
        if counters[zone_id]["smoke"] == 0:
            counters[zone_id]["smoke_latched"] = False

    fire_confirmed = counters[zone_id].get("fire_latched", False)
    smoke_confirmed = counters[zone_id].get("smoke_latched", False)

    # Crowd Tracking
    if results_people[0].boxes is not None and results_people[0].boxes.id is not None:
        for idx, box in enumerate(results_people[0].boxes.xyxy.cpu().numpy()):
            x1, y1, x2, y2 = map(int, box)
            people_count += 1
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.putText(frame, f"Person {idx + 1}", (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    # Risk Assessment & Pathfinding
    risk_score = planner.calculate_zone_risk(fire_confirmed, smoke_confirmed, people_count, zone_id)
    building_state[zone_id]["risk_score"] = risk_score
    
    candidate_route = planner.get_safest_route(zone_id, building_state)

    evacuation_required = risk_score > 60
    risk_level_str = "High" if evacuation_required else ("Medium" if risk_score > 30 else "Low")

    # Actionable Output with Route Locking
    if evacuation_required:
        locked_route = prev_routes.get(zone_id)

        if locked_route is None:
            locked_route = candidate_route.copy()
            prev_routes[zone_id] = locked_route
            counters[zone_id]["is_rerouted"] = False
        else:
            locked_path = locked_route.get("fullPath") or [zone_id]
            locked_next = locked_route.get("nextSafeZone")
            locked_exit = locked_route.get("targetExit")

            path_blocked = (
                any(building_state.get(step, {}).get("risk_score", 0) >= 60 for step in locked_path[1:])
                or building_state.get(locked_next, {}).get("risk_score", 0) >= 60
                or building_state.get(locked_exit, {}).get("risk_score", 0) >= 60
            )

            if candidate_route["nextSafeZone"] == "STAY_AND_WAIT" and locked_next != "STAY_AND_WAIT":
                locked_route = candidate_route.copy()
                prev_routes[zone_id] = locked_route
                counters[zone_id]["is_rerouted"] = True
            elif (path_blocked or locked_next == "STAY_AND_WAIT") and candidate_route["nextSafeZone"] != "STAY_AND_WAIT":
                if (candidate_route["nextSafeZone"], candidate_route["targetExit"]) != (locked_next, locked_exit):
                    locked_route = candidate_route.copy()
                    prev_routes[zone_id] = locked_route
                    counters[zone_id]["is_rerouted"] = True

        next_safe_zone = locked_route["nextSafeZone"]
        target_exit = locked_route["targetExit"]
        full_path = locked_route.get("fullPath") or [zone_id]
        is_rerouted = counters[zone_id].get("is_rerouted", False)

        if next_safe_zone == "STAY_AND_WAIT":
            instruction = "SHELTER IN PLACE. All escape routes are currently blocked or unsafe."
            alert_text = "HAZARD! SHELTER IN PLACE!"
            full_path = [zone_id]
        else:
            instruction = f"{'ALERT! Path blocked. Re-routing via' if is_rerouted else 'Evacuate immediately via'} {next_safe_zone} towards {target_exit}."
            alert_text = f"HAZARD! Route: {next_safe_zone}"
        
        alert_color = (0, 0, 255)
        if counters[zone_id].get("last_instruction") != instruction:
            print(f"\n[CRITICAL] {zone_id}: {instruction}")
            counters[zone_id]["last_instruction"] = instruction
            spoken_text = instruction.replace("_", " ")
            speaker.speak(spoken_text)
    else:
        instruction = "Normal conditions. No evacuation required."
        alert_text, alert_color = "Status: Normal", (0, 255, 0)
        counters[zone_id]["last_instruction"] = ""
        counters[zone_id]["is_rerouted"] = False
        prev_routes[zone_id] = None
        full_path = []
        is_rerouted = False

    # Safe Exits Calculation
    safe_exits = sum(1 for ext in ["Exit_A", "Exit_B"] if building_state[ext]["risk_score"] < 60)

    # Payload Generation
    zone_state = {
        "zoneId": zone_id,
        "fireDetected": fire_confirmed,
        "smokeDetected": smoke_confirmed,
        "peopleCount": people_count,
        "crowdDensity": "High" if people_count > 5 else "Low",
        "riskLevel": risk_level_str,
        "evacuationRequired": evacuation_required,
        "instruction": instruction,
        "fullRoute": full_path,
        "isRerouted": is_rerouted,
        "safeExitsCount": safe_exits,
        "totalExits": 2
    }

    # UI Rendering
    for (x1, y1, x2, y2) in fire_boxes:
        color = (0, 0, 255) if fire_confirmed else (0, 165, 255)
        text = "FIRE" if fire_confirmed else "DETECTING FIRE..."
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        cv2.putText(frame, text, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)

    for (x1, y1, x2, y2) in smoke_boxes:
        color = (0, 0, 255) if smoke_confirmed else (200, 200, 200)
        text = "SMOKE" if smoke_confirmed else "DETECTING SMOKE..."
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        cv2.putText(frame, text, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)

    cv2.rectangle(frame, (10, 10), (450, 90), (0, 0, 0), -1)
    cv2.putText(frame, f"{zone_id} Count: {people_count}", (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
    cv2.putText(frame, alert_text, (20, 75), cv2.FONT_HERSHEY_SIMPLEX, 0.7, alert_color, 2)

    return frame, zone_state


def main():
    print("[INFO] Initializing Models & Engines...")
    model_people_A = YOLO("yolo11n.pt")
    model_people_B = YOLO("yolo11n.pt")
    model_hazard = YOLO("best.pt")
    planner = EvacuationPlanner("xgb_risk_model.json")
    speaker = SpeakerEngine()
    backend_sync = BackendSyncEngine(API_URL, sync_interval=1.0)

    print("[INFO] Establishing Camera Feeds...")
    cap_A = CameraStream(0)
    cap_B = CameraStream(IP_CAMERA_URL)

    hazard_counters = {
        "Zone_1": {
            "fire": 0, "smoke": 0,
            "fire_latched": False, "smoke_latched": False,
            "is_rerouted": False, "last_instruction": ""
        },
        "Zone_2": {
            "fire": 0, "smoke": 0,
            "fire_latched": False, "smoke_latched": False,
            "is_rerouted": False, "last_instruction": ""
        }
    }
    
    prev_routes_state = {"Zone_1": None, "Zone_2": None}
    global_building_state = {z: {"risk_score": r} for z, r in {
        "Zone_1": 0, "Zone_2": 0, "Zone_3": 10, "Zone_4": 15,
        "Zone_5": 5, "Zone_6": 20, "Zone_7": 5, "Zone_8": 10,
        "Exit_A": 0, "Exit_B": 0
    }.items()}

    log_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), LOG_FILENAME)
    data_log_file = open(log_path, "a")

    # Keyboard mapping for dynamic exit risks
    key_actions = {
        ord('a'): ("Exit_A", 90), ord('s'): ("Exit_A", 0),
        ord('d'): ("Exit_B", 90), ord('f'): ("Exit_B", 0)
    }

    print("[INFO] System Active. Press 'q' to terminate.")

    try:
        while True:
            success_A, frame_A = cap_A.read()
            success_B, frame_B = cap_B.read()

            if not success_A or frame_A is None:
                continue

            # Process Streams
            processed_A, state_A = process_zone(
                frame_A.copy(), model_people_A, model_hazard, "Zone_1", 
                hazard_counters, planner, global_building_state, prev_routes_state, speaker
            )
            data_log_file.write(json.dumps(state_A) + "\n")
            backend_sync.update_state("Zone_1", state_A)
            cv2.imshow("ESCAPIA - Zone 1", processed_A)

            if success_B and frame_B is not None:
                processed_B, state_B = process_zone(
                    cv2.resize(frame_B.copy(), (640, 480)), model_people_B, model_hazard, "Zone_2", 
                    hazard_counters, planner, global_building_state, prev_routes_state, speaker
                )
                data_log_file.write(json.dumps(state_B) + "\n")
                backend_sync.update_state("Zone_2", state_B)
                cv2.imshow("ESCAPIA - Zone 2", processed_B)

            data_log_file.flush()

            # Keyboard Interrupts & Simulation
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                break
            elif key in key_actions:
                target_zone, new_risk = key_actions[key]
                global_building_state[target_zone]["risk_score"] = new_risk
                print(f"\n[UPDATE] {target_zone} risk {'forced to 90' if new_risk else 'reset to 0'}!")

    finally:
        print("[INFO] Executing Graceful Shutdown...")
        backend_sync.stop()
        data_log_file.close()
        cap_A.stop()
        cap_B.stop()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    main()