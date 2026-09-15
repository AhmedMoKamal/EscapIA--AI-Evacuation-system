import os
import cv2
import json
import requests
import threading
from ultralytics import YOLO
from decision_engine import EvacuationPlanner
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration
IP_CAMERA_URL = os.getenv("IP_CAMERA_URL")
API_URL = os.getenv("BACKEND_API_URL")
LOG_FILENAME = "ai_log_data.jsonl"


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


def process_zone(frame, people_model, hazard_model, zone_id, counters, planner, building_state, prev_routes):
    """Core AI pipeline: detection, tracking, risk assessment, and dynamic routing."""
    results_people = people_model.track(frame, classes=[0], tracker="bytetrack.yaml", persist=True, verbose=False)
    results_hazard = hazard_model(frame, conf=0.40, verbose=False)

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

            if "fire" in detected_class and conf >= 0.45:
                fire_boxes.append((x1, y1, x2, y2))
            elif "smoke" in detected_class and conf >= 0.75:
                smoke_boxes.append((x1, y1, x2, y2))

    # Sticky Memory Filter (Anti-flickering)
    counters[zone_id]["fire"] = max(0, min(60, counters[zone_id]["fire"] + (3 if fire_boxes else -2)))
    counters[zone_id]["smoke"] = max(0, min(60, counters[zone_id]["smoke"] + (3 if smoke_boxes else -2)))

    fire_confirmed = counters[zone_id]["fire"] >= 45
    smoke_confirmed = counters[zone_id]["smoke"] >= 45

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
    
    route_info = planner.get_safest_route(zone_id, building_state)
    next_safe_zone, target_exit = route_info['nextSafeZone'], route_info['targetExit']
    full_path = route_info.get('fullPath') or [zone_id]

    # Replanning Detection
    prev_route = prev_routes.get(zone_id, [])
    is_rerouted = bool(prev_route and full_path and prev_route != full_path)
    prev_routes[zone_id] = full_path

    evacuation_required = risk_score > 60
    risk_level_str = "High" if evacuation_required else ("Medium" if risk_score > 30 else "Low")

    # Actionable Output
    if evacuation_required:
        if next_safe_zone == "STAY_AND_WAIT":
            instruction = "SHELTER IN PLACE. All escape routes are currently blocked or unsafe."
            alert_text = "HAZARD! SHELTER IN PLACE!"
            full_path = [zone_id]
        else:
            instruction = f"{'ALERT! Path blocked. Re-routing via' if is_rerouted else 'Evacuate immediately via'} {next_safe_zone} towards {target_exit}."
            alert_text = f"HAZARD! Route: {next_safe_zone}"
        
        alert_color = (0, 0, 255)
        if not counters[zone_id]["alert_printed"]:
            print(f"\n[CRITICAL] {zone_id}: {instruction}")
            counters[zone_id]["alert_printed"] = True
    else:
        instruction = "Normal conditions. No evacuation required."
        alert_text, alert_color = "Status: Normal", (0, 255, 0)
        counters[zone_id]["alert_printed"] = False
        full_path, prev_routes[zone_id] = [], []

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

    print("[INFO] Establishing Camera Feeds...")
    cap_A = CameraStream(0)
    cap_B = CameraStream(IP_CAMERA_URL)

    frame_counter = 0
    hazard_counters = {
        "Zone_1": {"fire": 0, "smoke": 0, "alert_printed": False},
        "Zone_2": {"fire": 0, "smoke": 0, "alert_printed": False}
    }
    
    prev_routes_state = {"Zone_1": [], "Zone_2": []}
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

            frame_counter += 1

            # Process Streams
            processed_A, state_A = process_zone(
                frame_A.copy(), model_people_A, model_hazard, "Zone_1", 
                hazard_counters, planner, global_building_state, prev_routes_state
            )
            data_log_file.write(json.dumps(state_A) + "\n")
            cv2.imshow("ESCAPIA - Zone 1", processed_A)

            if success_B and frame_B is not None:
                processed_B, state_B = process_zone(
                    cv2.resize(frame_B.copy(), (640, 480)), model_people_B, model_hazard, "Zone_2", 
                    hazard_counters, planner, global_building_state, prev_routes_state
                )
                data_log_file.write(json.dumps(state_B) + "\n")
                cv2.imshow("ESCAPIA - Zone 2", processed_B)

            data_log_file.flush()

            # Async Payload Transmission
            if frame_counter % 20 == 0:
                try:
                    requests.post(API_URL, json=state_A, timeout=0.5)
                    if success_B and frame_B is not None:
                        requests.post(API_URL, json=state_B, timeout=0.5)
                except requests.exceptions.RequestException as e:
                    print(f"[WARNING] Failed to send data to C# API: {e}")

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
        data_log_file.close()
        cap_A.stop()
        cap_B.stop()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    main()