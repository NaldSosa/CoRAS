from rest_framework import serializers
from db_models.models import (
    PatientInformation, Assessment, PatientIntakeRecord,
    PatientScreening, RiskLevel, RiskChart, Result
)

class RiskLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = RiskLevel
        fields = ["risk_level", "risk_color", "risk_label"]

class RiskChartMiniSerializer(serializers.ModelSerializer):
    risk_level = RiskLevelSerializer()
    class Meta:
        model = RiskChart
        fields = ["risk_percentage", "risk_level"]

class ResultSerializer(serializers.ModelSerializer):
    risk_result = RiskChartMiniSerializer()
    class Meta:
        model = Result
        fields = ["recommendation", "risk_result"]

class AssessmentSerializer(serializers.ModelSerializer):
    results = ResultSerializer(many=True, source="result_set")
    class Meta:
        model = Assessment
        fields = ["id", "assessment_date_time", "is_completed", "results"]

class PatientScreeningSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientScreening
        fields = "__all__"

class PatientIntakeRecordSerializer(serializers.ModelSerializer):
    screenings = PatientScreeningSerializer(many=True, source="patientscreening_set")

    class Meta:
        model = PatientIntakeRecord
        fields = [
            "id",
            "patient",
            "height",
            "weight",
            "bmi",
            "bmi_category",
            "avg_sbp",
            "avg_dbp",
            "bp_category",
            "existing_medication",
            "medicine_mg",
            "smoking_status",
            "drinks_alcohol",
            "excessive_alcohol_use",
            "high_fat_salt_intake",
            "vegetable_intake",
            "fruit_intake",
            "physical_activity",
            "screenings",
        ]

class PatientDetailSerializer(serializers.ModelSerializer):
    intake_records = PatientIntakeRecordSerializer(many=True, source="patientintakerecord_set")
    assessments = AssessmentSerializer(many=True, source="assessment_set")

    class Meta:
        model = PatientInformation
        fields = "__all__"

class PatientListSerializer(serializers.ModelSerializer):
    latest_result = serializers.SerializerMethodField()

    class Meta:
        model = PatientInformation
        fields = ["id", "name", "age", "sex", "latest_result"]

    def get_latest_result(self, obj):
        assessment = Assessment.objects.filter(patient=obj).order_by("-assessment_date_time").first()
        if assessment:
            result = Result.objects.filter(assessment=assessment).first()
            if result:
                return ResultSerializer(result).data
        return None
