import google.generativeai as genai
from django.conf import settings
import json

genai.configure(api_key=settings.GEMINI_API_KEY)


def analyze_patient(results: dict) -> dict:
    """
    Single Gemini request that generates:
    1. Lifestyle recommendations (Taglish, with English headers).
    2. Short recap (Taglish).
    Returned as plain text, no JSON formatting.
    Gemini also echoes back the patient data to the terminal for debugging.
    """

    model = genai.GenerativeModel("gemini-2.5-flash-lite")

    # 🔎 Debugging: print raw results Gemini will read
    print("=== Patient Data Sent to Gemini ===")
    print(json.dumps(results, indent=2))
    print("===================================")

    prompt = f"""
    You are a supportive health assistant.

    IMPORTANT INSTRUCTIONS:
    - Gamitin ang Taglish: around 80% Tagalog + 20% English.
    - Headers dapat English (For Cardiovascular, For Diabetes Risk, For Respiratory and Cancer Risk).
    - Based on their sex and age, provide lifestyle recommendations each headers to reduce, improve and manage the risks.
    - Content casual at conversational, madaling intindihin.
    - Act like a friendly professional BHW or nurse.
    - DO NOT give prescriptions or medical treatment.
    - If findings are serious, advise to see a doctor immediately.
    - Relate Q1-Q7 answers to possible angina or heart attack. If q3 or q4 or q5 or q6 or q7 is yes, advise to see a doctor immediately.
    - If Q8 is yes, advise to see a doctor immediately for stroke or TIA screening.

    Here are the patient's assessment results (in JSON):
    {json.dumps(results, indent=2)}

    Based on these assessment results, provide BOTH of the following:

    For Cardiovascular:
    [taglish advice here]

    For Diabetes Risk:
    [taglish advice here]

    For Respiratory and Cancer Risk:
    [taglish advice here]

    Summary:
    [short Taglish recap here]
    """


    response = model.generate_content(prompt)
    text = response.text or ""

    # Extract recommendations and summary
    recommendations, summary = "", ""
    if "Summary:" in text:
        parts = text.split("Summary:")
        recommendations = parts[0].strip()
        summary = parts[1].strip()
    else:
        recommendations = text.strip()

    return {
        "ai_recommendations": recommendations,
        "summary": summary,
    }
def run_risk_assessment(data: dict) -> dict:
    """
    Delegate risk assessment to Gemini AI.
    Returns AI-generated lifestyle recommendations (no prescriptions).
    """
    
    return data
