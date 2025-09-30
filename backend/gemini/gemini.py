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

    # For debugging
    print("=== Patient Data Sent to Gemini ===")
    print(json.dumps(results, indent=2))
    print("===================================")

    prompt = f"""
    You are a supportive health assistant.

    IMPORTANT INSTRUCTIONS:
    - Gumamit ng **Tagalog**, simple at madaling intindihin.
    - Magsimula sa: "Based on the assessment results, narito ang ilang payo:".
    - Magbigay ng **lifestyle tips** (diet, exercise, iwas bisyo, stress, tulog).
    - Kung may seryosong indikasyon → payo agad na magpatingin sa doktor.
    - Walang gamot, reseta, o medical treatment.
    - Tone: parang mabait na BHW/nurse — casual pero propesyonal.
    - Kung Q3–Q7 = "yes" → sabihin na kailangan magpatingin agad (possible heart issue).
    - Kung Q8 = "yes" → sabihin na magpa-check para sa stroke/TIA screening.
    - Kung may isa o higit pang "yes" sa mga diabetes symptoms (Polyuria, Polydipsia, Polyphagia) → payo na magpa-check para sa diabetes.
    - Huwag ulitin ang tanong; diretsong recommendations lang.
    - Align with WHO/DOH healthy lifestyle guidelines.
    - Iwasan ang medical jargon; gumamit ng simpleng salita.
    - Gumamit ng passive voice, hindi "ikaw/you/niyo/iyo/ninyo/inyo".

    Here are the patient's assessment results (in JSON):
    {json.dumps(results, indent=2)}

    Based on these assessment results, provide direct lifestyle recommendation in 1 paragraph depending on the patient assessment results.

    Risks:
    [List down any health risks identified from the assessment results.]

    Lifestyle Recommendations:
    [Provide clear and actionable lifestyle recommendations based on the assessment results.]
    """


    response = model.generate_content(prompt)
    text = response.text or ""
    return {"ai_recommendations": text}

def run_risk_assessment(data: dict) -> dict:
    """
    Delegate risk assessment to Gemini AI.
    Returns AI-generated lifestyle recommendations (no prescriptions).
    """
    
    return data


