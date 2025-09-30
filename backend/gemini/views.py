import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .gemini import analyze_patient, run_risk_assessment

@csrf_exempt
def risk_assessment_view(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON"}, status=400)

        # run your manual rules
        results = run_risk_assessment(data)

        # call Gemini ONCE
        gemini_output = analyze_patient(results)

        return JsonResponse({
            "results": results,
            "ai_recommendations": gemini_output.get("ai_recommendations"),
            "summary": gemini_output.get("summary"),
        })

    return JsonResponse({"error": "Only POST method is allowed"}, status=405)

