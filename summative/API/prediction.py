from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from joblib import load
import pandas as pd
import numpy as np


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