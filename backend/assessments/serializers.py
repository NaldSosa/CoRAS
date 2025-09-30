from rest_framework import serializers
from db_models.models import (
    PatientInformation, Assessment, PatientIntakeRecord,
    PatientScreening, Result, RiskChart
)
from risk_chart.utils import (
    categorize_sex, categorize_age,
    categorize_bmi, categorize_sbp, categorize_smoker_status
)
from gemini.gemini import analyze_patient


class PatientInformationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientInformation
        fields = "__all__"


class AssessmentSerializer(serializers.ModelSerializer):
    patient_info = PatientInformationSerializer(write_only=True)

    class Meta:
        model = Assessment
        fields = [
            "id", "assessment_date_time", "user",
            "is_completed", "is_archived", "is_synced",
            "patient_info"
        ]

    def create(self, validated_data):
        request = self.context["request"]
        data = request.data

        patient_data = validated_data.pop("patient_info")
        if "id" in patient_data:
            patient = PatientInformation.objects.get(id=patient_data["id"])
            for field, value in patient_data.items():
                if field != "id":
                    setattr(patient, field, value)
            patient.save()
        else:
            patient = PatientInformation.objects.create(**patient_data)

        assessment = Assessment.objects.create(patient=patient, **validated_data)

        intake = PatientIntakeRecord.objects.create(
            patient=patient,
            hypertension=(data.get("hypertension") == "YES"),
            stroke=(data.get("stroke") == "YES"),
            heart_attack=(data.get("heart_attack") == "YES"),
            diabetes=(data.get("diabetes") == "YES"),
            asthma=(data.get("asthma") == "YES"),
            cancer=(data.get("cancer") == "YES"),
            kidney_disease=(data.get("kidney_disease") == "YES"),
            height=int(data.get("height", 0)),
            weight=int(data.get("weight", 0)),
            bmi=float(data.get("bmi", 0)),
            bmi_category=data.get("bmi_category"),
            waist_circumference=int(data.get("waist_circumference", 0)),
            hip_circumference=int(data.get("hip_circumference", 0)),
            whr_ratio=float(data.get("whr_ratio", 0)),
            whr_category=data.get("whr_category"),
            first_sbp=int(data.get("sbp", 0)),
            first_dbp=int(data.get("dbp", 0)),
            second_sbp=int(data.get("second_sbp", 0) or 0),
            second_dbp=int(data.get("second_dbp", 0) or 0),
            avg_sbp=int(data.get("sbp", 0)),
            avg_dbp=int(data.get("dbp", 0)),
            bp_category=data.get("bp_category"),
            existing_medication=data.get("existing_medication"),
            medicine_mg=data.get("medicine_mg"),
            smoking_status=data.get("smoking"),
            drinks_alcohol=data.get("alcohol"),
            excessive_alcohol_use=data.get("excessive_alcohol"),
            high_fat_salt_intake=data.get("high_fat_salt"),
            vegetable_intake=data.get("vegetable_intake"),
            fruit_intake=data.get("fruit_intake"),
            physical_activity=data.get("physical_activity"),
        )

        PatientScreening.objects.create(
            patient_intake_record=intake,
            question_one=(data.get("Q1") == "YES"),
            question_two=(data.get("Q2") == "YES"),
            question_three=(data.get("Q3") == "YES"),
            question_four=(data.get("Q4") == "YES"),
            question_five=(data.get("Q5") == "YES"),
            question_six=(data.get("Q6") == "YES"),
            question_seven=(data.get("Q7") == "YES"),
            question_eight=(data.get("Q8") == "YES"),
            is_diagnosed_diabetes=data.get("diabetes_diagnosed"),
            with_without_medication=data.get("with_without_medication"),
            existing_diabetes_medicines=data.get("existing_diabetes_medicines"),
            diabetes_med_milligrams=data.get("diabetes_med_milligrams"),
            have_polyphagia=(data.get("polyphagia") == "YES"),
            have_polydipsia=(data.get("polydipsia") == "YES"),
            have_polyuria=(data.get("polyuria") == "YES"),
        )

        sex = categorize_sex(patient.sex[0])  # "M"/"F" to "Male"/"Female"
        age_group = categorize_age(patient.age)
        bmi_group = categorize_bmi(intake.bmi)
        sbp_group = categorize_sbp(intake.avg_sbp)
        smoker_status = categorize_smoker_status(intake.smoking_status)

        risk_chart = RiskChart.lookup(sex, age_group, smoker_status, bmi_group, sbp_group)

        results_data = dict(data)
        results_data.update({
            "risk_percentage": risk_chart.risk_percentage if risk_chart else None,
            "risk_level": risk_chart.risk_level.risk_label if risk_chart else None,
        })

        gemini_output = analyze_patient(results_data)
        recommendation_text = gemini_output.get("ai_recommendations", "")

        Result.objects.create(
            assessment=assessment,
            risk_result=risk_chart,
            recommendation=recommendation_text,
        )

        return {
            "assessment_id": assessment.id,
            "patient": PatientInformationSerializer(patient).data,
            "risk": {
                "risk_percentage": risk_chart.risk_percentage if risk_chart else 0,
                "risk_level": risk_chart.risk_level.risk_label if risk_chart else "Unknown",
                "risk_color": risk_chart.risk_level.risk_color if risk_chart else "#808080",
            },
            "recommendation": recommendation_text,
        }

