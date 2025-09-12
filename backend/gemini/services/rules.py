from .gemini import generate_ai_recommendations

def run_risk_assessment(data: dict) -> dict:
    """
    Delegate risk assessment to Gemini AI.
    Returns AI-generated recommendations (no prescriptions).
    """

    results = generate_ai_recommendations(data)
    return results
