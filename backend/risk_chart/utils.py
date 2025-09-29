def categorize_sex(sex):
    if sex == "M":
        return "Male"
    elif sex == "F":
        return "Female"

def categorize_age(age):
    if 20 <= age <= 39: return "20-39"
    elif 40 <= age <= 44: return "40-44"
    elif 45 <= age <= 49: return "45-49"
    elif 50 <= age <= 54: return "50-54"
    elif 55 <= age <= 59: return "55-59"
    elif 60 <= age <= 64: return "60-64"
    elif 65 <= age <= 69: return "65-69"
    elif 70 <= age <= 120: return "70-120"
    return None

def categorize_bmi(bmi):
    if bmi < 20: return "<20"
    elif 20 <= bmi <= 24: return "20-24"
    elif 25 <= bmi <= 29: return "25-29"
    elif 30 <= bmi <= 35: return "30-35"
    else: return "≥35"

def categorize_sbp(sbp):
    if sbp < 120: return "<120"
    elif 120 <= sbp <= 139: return "120-139"
    elif 140 <= sbp <= 159: return "140-159"
    elif 160 <= sbp <= 179: return "160-179"
    else: return "≥180"

def categorize_smoker_status(smoker_status: str) -> str:
    if not smoker_status:
        return "Smoker"

    normalized = smoker_status.strip().lower()

    non_smoker_options = [
        "never smoked",
        "stopped > 1 year",
    ]

    if normalized in non_smoker_options:
        return "Non-smoker"
    else:
        return "Smoker"

