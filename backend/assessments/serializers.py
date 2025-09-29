from rest_framework import serializers
from db_models.models import Assessment, PatientInformation

class PatientInformationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientInformation
        fields = "__all__"


class AssessmentSerializer(serializers.ModelSerializer):
    patient = PatientInformationSerializer()

    class Meta:
        model = Assessment
        fields = "__all__"

    def create(self, validated_data):
        patient_data = validated_data.pop("patient")
        patient, _ = PatientInformation.objects.get_or_create(
            name=patient_data["name"],
            birthdate=patient_data["birthdate"],
            defaults=patient_data
        )
        return Assessment.objects.create(patient=patient, **validated_data)

    def update(self, instance, validated_data):
        patient_data = validated_data.pop("patient", None)
        if patient_data:
            for key, value in patient_data.items():
                setattr(instance.patient, key, value)
            instance.patient.save()
        for key, value in validated_data.items():
            setattr(instance, key, value)
        instance.save()
        return instance
