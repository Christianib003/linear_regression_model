# Used Car Price Prediction Project

This project implements a machine learning model to predict used car prices using Linear Regression. The implementation includes a model training component, an API service, and a Flutter mobile application for user interaction.

## Table of Contents
- [Used Car Price Prediction Project](#used-car-price-prediction-project)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Dataset](#dataset)
  - [Project Structure](#project-structure)
  - [Components](#components)
    - [Linear Regression Model](#linear-regression-model)
    - [API Service](#api-service)
    - [Flutter Application](#flutter-application)
  - [Setup and Installation](#setup-and-installation)
    - [Linear Regression Model](#linear-regression-model-1)
    - [API Service](#api-service-1)
    - [Flutter Application](#flutter-application-1)
  - [Usage](#usage)
  - [API Documentation](#api-documentation)

## Project Overview
This project is part of the Machine Learning coursework for Term 3, Year 2. It demonstrates the practical application of Linear Regression in predicting used car prices based on various features. The project is structured as a complete end-to-end solution with three main components: the machine learning model, an API service, and a mobile application.

## Dataset
The project uses the "Used Cars Dataset" from Kaggle ([Dataset Link](https://www.kaggle.com/code/yogidsba/predict-used-car-prices-linearregression)). This dataset contains information about used cars including various features such as:
- Make and model
- Year of manufacture
- Mileage
- Other relevant car specifications

The dataset was chosen for its relevance to real-world applications and its suitability for demonstrating linear regression concepts.

## Project Structure
The project is organized into three main directories:

```
linear_regression_model/
├── linear_regression/    # Machine learning model implementation
├── API/                  # FastAPI service for model deployment
└── FlutterApp/          # Mobile application (Coming Soon)
```

## Components

### Linear Regression Model
Located in the `linear_regression/` directory, this component includes:
- Data preprocessing scripts
- Model training implementation
- Model evaluation and validation
- Trained model files

### API Service
Located in the `API/` directory, this component:
- Provides a RESTful API service using FastAPI
- Hosts the trained model for predictions
- Exposes the `/predict` endpoint for making predictions
- API documentation available at: https://linear-regression-model-sain.onrender.com/docs

### Flutter Application
The Flutter application (coming soon) will be located in the `FlutterApp/` directory and will feature:
- A form screen for inputting car details
- A prediction results screen
- Integration with the prediction API
- User-friendly interface for interacting with the model

## Setup and Installation
Each component has its own virtual environment and dependencies:

### Linear Regression Model
```bash
cd linear_regression
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### API Service
```bash
cd API
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Flutter Application
```bash
cd FlutterApp
flutter pub get
```

## Usage
1. Train the model using the scripts in the `linear_regression` directory
2. Start the API service to serve predictions
3. Use the Flutter application to interact with the model:
   - Input car details through the form screen
   - View predictions on the results screen

## API Documentation
The API documentation is available at https://linear-regression-model-sain.onrender.com/docs

Key endpoints:
- `/predict`: POST endpoint for making car price predictions
  - Accepts car features as input
  - Returns predicted price

For detailed API usage and examples, please refer to the API documentation link above.
