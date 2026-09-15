import pandas as pd
import numpy as np
import xgboost as xgb
from sklearn.model_selection import train_test_split

MODEL_FILENAME = "xgb_risk_model.json"
RANDOM_SEED = 42

def generate_synthetic_data(num_samples: int = 5000) -> pd.DataFrame:
    np.random.seed(RANDOM_SEED)
    data = []
    
    for _ in range(num_samples):
        fire_status = np.random.choice([0, 1, 2], p=[0.7, 0.2, 0.1])
        people_count = np.random.randint(0, 100)
        zone_capacity = np.random.choice([30, 50, 100])
        crowd_ratio = people_count / zone_capacity
        
        if fire_status == 2:
            risk_score = np.random.uniform(85, 100)
        elif fire_status == 1:
            risk_score = np.random.uniform(60, 84)
        else:
            if crowd_ratio > 0.9: risk_score = np.random.uniform(40, 59)
            elif crowd_ratio > 0.5: risk_score = np.random.uniform(20, 39)
            else: risk_score = np.random.uniform(0, 19)
                
        data.append([fire_status, people_count, zone_capacity, risk_score])
        
    return pd.DataFrame(data, columns=["fire_status", "people_count", "zone_capacity", "risk_score"])

def train_and_save_model() -> None:
    print("[INFO] Generating synthetic dataset...")
    df = generate_synthetic_data()
    
    X, y = df[["fire_status", "people_count", "zone_capacity"]], df["risk_score"]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=RANDOM_SEED)
    
    print("[INFO] Training XGBoost Regressor...")
    model = xgb.XGBRegressor(n_estimators=100, learning_rate=0.1, max_depth=5, random_state=RANDOM_SEED)
    model.fit(X_train, y_train)
    
    print(f"[INFO] Model R2 Score: {model.score(X_test, y_test):.4f}")
    model.save_model(MODEL_FILENAME)
    print(f"[INFO] Model saved successfully as '{MODEL_FILENAME}'")

if __name__ == "__main__":
    train_and_save_model()