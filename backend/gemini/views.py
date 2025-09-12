import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .services.rules import run_risk_assessment
from .services.gemini import summarize_risk

@csrf_exempt
def risk_assessment_view(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON"}, status=400)

        results = run_risk_assessment(data)
        summary = summarize_risk(results)
        return JsonResponse({"results": results, "summary": summary})

    return JsonResponse({"error": "Only POST method is allowed"}, status=405)
