import google.generativeai as genai
from django.conf import settings
import json

genai.configure(api_key=settings.GEMINI_API_KEY)

def generate_ai_recommendations(data: dict) -> dict:
    """
    Use Gemini to create patient-friendly recommendations
    based on age, gender, and health inputs.
    - Relates advice to major NCD risk factors (CVD, diabetes, cancers, respiratory diseases).
    - No medical prescriptions.
    - If severe findings are present, advise consulting a doctor.
    """

    model = genai.GenerativeModel("gemini-2.5-flash-lite")

    prompt = f"""
    You are a supportive health assistant.
    Based on the following patient profile, provide recommendations that are
    explicitly linked to major Non-Communicable Diseases (NCDs).

    - Relate blood pressure, diet, smoking, exercise, and alcohol use
      to cardiovascular disease risk.
    - Relate symptoms like polyuria, polyphagia, polydipsia to diabetes risk.
    - Relate smoking exposure to chronic respiratory disease and cancer risks.
    - Always keep advice supportive, patient-friendly, and easy to understand.
    - DO NOT provide prescriptions or medical treatment.
    - If findings are serious (e.g., emergency BP, stroke signs, angina),
      clearly add: "Critical findings detected. Please consult a doctor immediately."

    Patient Profile:
    {json.dumps(data, indent=2)}
    """

    response = model.generate_content(prompt)
    return {"ai_recommendations": response.text}


def summarize_risk(results: dict) -> str:
    """
    Short bilingual recap (English + Tagalog).
    """

    model = genai.GenerativeModel("gemini-2.5-flash-lite")

    prompt = f"""
    You are a health assistant.
    Summarize the following recommendations into a SHORT, DIRECT recap.
    - 1–2 sentences only.
    - Write in English first, then Tagalog.
    - If there are critical findings, clearly flag them in both languages.

    Assessment Results:
    {json.dumps(results, indent=2)}
    """

    response = model.generate_content(prompt)
    return response.text


