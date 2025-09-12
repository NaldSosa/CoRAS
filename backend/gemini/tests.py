import requests

URL = "http://127.0.0.1:8000/risk-assessment/"

test_cases = {
    "Healthy Patient": {
        "age": 35,
        "gender": "male",
        "systolic": 120,
        "diastolic": 80,
        "smoking_status": "stopped > 1 year",
        "high_salt_fat": False,
        "vegetables_daily": True,
        "fruits_daily": True,
        "exercise_enough": True,
        "polyuria": False,
        "polyphagia": False,
        "polydipsia": False,
        "alcohol_intake": False,
        "excessive_alcohol": False,
        "angina_q1": False,
        "angina_q2": False,
        "angina_q3": False,
        "angina_q4": False,
        "angina_q5": False,
        "angina_q6": False,
        "angina_q7": False,
        "stroke_q8": False
    },
    "Elevated BP + Smoking + Poor Diet": {
        "age": 52,
        "gender": "female",
        "systolic": 125,
        "diastolic": 95,
        "smoking_status": "active smoker",
        "high_salt_fat": True,
        "vegetables_daily": False,
        "fruits_daily": False,
        "exercise_enough": False,
        "polyuria": False,
        "polyphagia": False,
        "polydipsia": False,
        "alcohol_intake": True,
        "excessive_alcohol": False,
        "angina_q1": False,
        "angina_q2": False,
        "angina_q3": False,
        "angina_q4": False,
        "angina_q5": False,
        "angina_q6": False,
        "angina_q7": False,
        "stroke_q8": False
    },
    "Emergency BP + Excessive Alcohol": {
        "age": 60,
        "gender": "male",
        "systolic": 160,
        "diastolic": 120,
        "smoking_status": "passive smoker",
        "high_salt_fat": True,
        "vegetables_daily": False,
        "fruits_daily": True,
        "exercise_enough": False,
        "polyuria": True,
        "polyphagia": True,
        "polydipsia": False,
        "alcohol_intake": True,
        "excessive_alcohol": True,
        "angina_q1": False,
        "angina_q2": False,
        "angina_q3": False,
        "angina_q4": False,
        "angina_q5": False,
        "angina_q6": False,
        "angina_q7": False,
        "stroke_q8": False
    },
    "Possible Angina/Heart Attack": {
        "age": 48,
        "gender": "female",
        "systolic": 118,
        "diastolic": 82,
        "smoking_status": "stopped < 1 year",
        "high_salt_fat": False,
        "vegetables_daily": True,
        "fruits_daily": True,
        "exercise_enough": True,
        "polyuria": False,
        "polyphagia": False,
        "polydipsia": False,
        "alcohol_intake": False,
        "excessive_alcohol": False,
        "angina_q1": True,
        "angina_q2": True,
        "angina_q3": True,
        "angina_q4": False,
        "angina_q5": False,
        "angina_q6": False,
        "angina_q7": False,
        "stroke_q8": False
    },
    "Stroke / TIA": {
        "age": 72,
        "gender": "male",
        "systolic": 115,
        "diastolic": 75,
        "smoking_status": "stopped > 1 year",
        "high_salt_fat": False,
        "vegetables_daily": True,
        "fruits_daily": True,
        "exercise_enough": True,
        "polyuria": False,
        "polyphagia": False,
        "polydipsia": False,
        "alcohol_intake": False,
        "excessive_alcohol": False,
        "angina_q1": False,
        "angina_q2": False,
        "angina_q3": False,
        "angina_q4": False,
        "angina_q5": False,
        "angina_q6": False,
        "angina_q7": False,
        "stroke_q8": True
    }
}

for name, payload in test_cases.items():
    response = requests.post(URL, json=payload).json()
    print(f"\n=== {name} ===")

    print("\n--- Recommendations ---")
    for key, value in response.get("results", {}).items():
        print(f"{key}: {value}")

    print("\n--- Summary ---")
    print(response.get("summary", "No summary"))
    print("\n" + "="*50)