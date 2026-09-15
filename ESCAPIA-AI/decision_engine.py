import xgboost as xgb
import networkx as nx
import pandas as pd
from typing import Dict, Any

class EvacuationPlanner:
    CRITICAL_RISK_THRESHOLD = 85.0
    BLOCKED_PATH_PENALTY = 999999
    RISK_PENALTY_DIVISOR = 10.0
    DEFAULT_CAPACITY = 50

    def __init__(self, model_path: str = "xgb_risk_model.json"):
        self.risk_model = xgb.XGBRegressor()
        self.risk_model.load_model(model_path)
        
        self.graph = nx.Graph()
        self._build_building_graph()
        
        self.zone_capacities = {
            "Zone_1": 50, "Zone_2": 50, "Zone_3": 100, "Zone_4": 30,
            "Zone_5": 50, "Zone_6": 100, "Zone_7": 30, "Zone_8": 50,
            "Exit_A": 500, "Exit_B": 500
        }

    def _build_building_graph(self) -> None:
        self.graph.add_weighted_edges_from([
            ("Zone_1", "Zone_3", 10), ("Zone_1", "Zone_4", 15),
            ("Zone_2", "Zone_3", 12), ("Zone_2", "Zone_5", 10),
            ("Zone_3", "Zone_6", 20), ("Zone_4", "Exit_A", 25),
            ("Zone_5", "Zone_7", 15), ("Zone_6", "Exit_B", 30),
            ("Zone_7", "Exit_A", 10), ("Zone_8", "Exit_B", 10),
            ("Zone_4", "Zone_8", 20), ("Zone_5", "Zone_6", 15)
        ])

    def calculate_zone_risk(self, fire_detected: bool, smoke_detected: bool, people_count: int, zone_id: str) -> float:
        fire_status = 2 if fire_detected else (1 if smoke_detected else 0)
        capacity = self.zone_capacities.get(zone_id, self.DEFAULT_CAPACITY)
        
        input_data = pd.DataFrame([[fire_status, people_count, capacity]], 
                                  columns=["fire_status", "people_count", "zone_capacity"])
        return float(self.risk_model.predict(input_data)[0])

    def get_safest_route(self, start_zone: str, all_zones_state: Dict[str, Any]) -> Dict[str, Any]:
        if start_zone not in self.graph:
            return {"targetExit": None, "fullPath": [start_zone], "nextSafeZone": "STAY_AND_WAIT"}

        temp_graph = self.graph.copy()
        
        # Apply dynamic risk penalties to edge weights
        for u, v, data in temp_graph.edges(data=True):
            risk_u = all_zones_state.get(u, {}).get("risk_score", 0)
            risk_v = all_zones_state.get(v, {}).get("risk_score", 0)
            avg_risk = (risk_u + risk_v) / 2.0
            
            penalty = self.BLOCKED_PATH_PENALTY if avg_risk >= self.CRITICAL_RISK_THRESHOLD else 1 + (avg_risk / self.RISK_PENALTY_DIVISOR)
            temp_graph[u][v]['weight'] = data['weight'] * penalty

        best_exit, safest_path, min_cost = None, None, float('inf')

        # Pathfinding evaluation against all viable exits
        for exit_node in ["Exit_A", "Exit_B"]:
            if all_zones_state.get(exit_node, {}).get("risk_score", 0) >= self.CRITICAL_RISK_THRESHOLD:
                continue 

            try:
                path = nx.dijkstra_path(temp_graph, source=start_zone, target=exit_node, weight='weight')
                cost = nx.dijkstra_path_length(temp_graph, source=start_zone, target=exit_node, weight='weight')
                if cost < min_cost:
                    min_cost, safest_path, best_exit = cost, path, exit_node
            except nx.NetworkXNoPath:
                continue

        # Trajectory validation and shelter-in-place enforcement
        if safest_path and min_cost < self.BLOCKED_PATH_PENALTY and len(safest_path) > 1:
            next_step = safest_path[1]
        else:
            next_step = "STAY_AND_WAIT"

        return {
            "targetExit": best_exit,
            "fullPath": safest_path if next_step != "STAY_AND_WAIT" else [start_zone],
            "nextSafeZone": next_step
        }