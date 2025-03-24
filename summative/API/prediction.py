from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from joblib import load
import pandas as pd
import numpy as np
import uvicorn


# Initialize FastAPI app
app = FastAPI(title="Used Car Price Prediction API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Load the saved model, scaler, feature columns, and fill_dict
model = load('dependencies/best_model.joblib')
scaler = load('dependencies/scaler.joblib')
feature_columns = load('dependencies/feature_columns.joblib')
fill_dict = load('dependencies/fill_dict.joblib')

# Function to extract numerical values from string input
def extract_number(s):
    if pd.isnull(s) or 'null' in str(s):
        return np.nan
    try:
        return float(s.split()[0])
    except:
        return np.nan
    

# Define Pydantic model for input validation
class CarInput(BaseModel):
    Year: int = Field(..., ge=1990, le=2023, description="Manufacturing year of the car (1990-2023)")
    Kilometers_Driven: int = Field(..., ge=0, description="Total distance driven (in kilometers)")
    Fuel_Type: str = Field(..., description="Type of fuel (e.g., Petrol, Diesel, CNG, LPG)")
    Transmission: str = Field(..., description="Transmission type (Manual or Automatic)")
    Owner_Type: str = Field(..., description="Ownership history (e.g., First, Second)")
    Mileage: str = Field(..., description="Fuel efficiency (e.g., '18.9 kmpl' or '26.6 km/kg')")
    Engine: str = Field(..., description="Engine displacement (e.g., '1197 CC')")
    Power: str = Field(..., description="Engine power (e.g., '81.86 bhp')")
    Seats: float = Field(..., ge=2, le=10, description="Number of seats (2-10)")
    Location: str = Field(..., description="Location of the car (e.g., Mumbai, Pune)")
    Name: str = Field(..., description="Car name (e.g., 'Maruti Swift VXI')")


# Function to preprocess and predict
def predict_car_price(input_data: CarInput, scaler, model, feature_columns, fill_dict):
    # Convert input data to DataFrame
    input_dict = input_data.dict()
    input_df = pd.DataFrame([input_dict])
    
    # Extract Brand from Name
    input_df['Brand'] = input_df['Name'].apply(lambda x: x.split()[0])
    input_df = input_df.drop('Name', axis=1)
    
    # Clean numerical columns
    for col in ['Mileage', 'Engine', 'Power']:
        input_df[col] = input_df[col].apply(extract_number)
    
    # Impute missing values with the same medians used during training
    input_df.fillna(fill_dict, inplace=True)
    
    # One-hot encode categorical variables
    input_encoded = pd.get_dummies(input_df, columns=['Location', 'Fuel_Type', 'Transmission', 'Owner_Type', 'Brand'], drop_first=True)
    
    # Align columns with training data (add missing columns as zeros)
    for col in feature_columns:
        if col not in input_encoded.columns:
            input_encoded[col] = 0
    input_encoded = input_encoded[feature_columns]
    
    # Scale features
    input_scaled = scaler.transform(input_encoded)
    
    # Make prediction
    prediction = model.predict(input_scaled)
    return round(prediction[0], 2)

# Define the POST endpoint
@app.post("/predict")
async def predict(input_data: CarInput):
    try:
        prediction = predict_car_price(input_data, scaler, model, feature_columns, fill_dict)
        return {"predicted_price": float(prediction)}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction error: {str(e)}")


# Run the app directly when the script is executed
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)