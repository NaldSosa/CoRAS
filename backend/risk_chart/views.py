from rest_framework.decorators import api_view
from rest_framework.response import Response
from db_models.models import RiskChart
from .utils import (
    categorize_sex, categorize_age,
    categorize_bmi, categorize_sbp, categorize_smoker_status
)

@api_view(["POST"])
def get_risk_assessment(request):
    data = request.data

    # For debugging
    print("RAW request.data:", data)

    try:
        sex = data.get("sex")
        age = int(data.get("age"))
        bmi = float(data.get("bmi"))
        sbp = int(data.get("sbp"))
        raw_smoker_status = data.get("smoker_status") or data.get("smoking")
    except Exception as e:
        print("Error parsing inputs:", e)
        return Response({"error": f"Invalid input: {e}"}, status=400)

    # convert raw inputs to categories
    sex = categorize_sex(sex)
    age_group = categorize_age(age)
    bmi_group = categorize_bmi(bmi)
    sbp_group = categorize_sbp(sbp)
    smoker_status = categorize_smoker_status(raw_smoker_status)

    # for debugging
    print("🔎 Categorized values:", {
        "sex": sex,
        "age_group": age_group,
        "smoker_status": smoker_status,
        "bmi_group": bmi_group,
        "sbp_group": sbp_group,
    })

    risk = RiskChart.lookup(sex, age_group, smoker_status, bmi_group, sbp_group)

    if risk:
        print("RiskChart match found:", risk.risk_percentage, risk.risk_level.risk_label)
        return Response({
            "risk_percentage": risk.risk_percentage,
            "risk_level": risk.risk_level.risk_label,
            "risk_color": risk.risk_level.risk_color,
        })
    else:
        print("No RiskChart match found for categories above")
        return Response({"error": "No matching risk found"}, status=404)
