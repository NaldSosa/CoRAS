from rest_framework import generics, views, status
from rest_framework.response import Response
from django.utils.dateparse import parse_datetime
from db_models.models import Assessment
from .serializers import AssessmentSerializer

# Single create
class AssessmentCreateView(generics.CreateAPIView):
    queryset = Assessment.objects.all()
    serializer_class = AssessmentSerializer


# Bulk sync
class AssessmentBulkSyncView(views.APIView):
    def post(self, request, *args, **kwargs):
        data = request.data.get("assessments", [])
        synced_ids = []

        for assessment_data in data:
            client_id = assessment_data.get("client_id")
            last_updated_client = assessment_data.get("last_updated", None)
            if last_updated_client:
                last_updated_client = parse_datetime(last_updated_client)

            serializer = AssessmentSerializer(data=assessment_data)
            serializer.is_valid(raise_exception=True)

            # check if already exists
            assessment = Assessment.objects.filter(client_id=client_id).first()
            if assessment:
                # conflict resolution: keep server if newer
                if last_updated_client and assessment.last_updated > last_updated_client:
                    continue
                serializer.update(assessment, serializer.validated_data)
                synced_ids.append(assessment.client_id)
            else:
                new_instance = serializer.save()
                synced_ids.append(new_instance.client_id)

        return Response(
            {"message": "Bulk sync successful", "synced_ids": synced_ids},
            status=status.HTTP_201_CREATED,
        )
